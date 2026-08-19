-- Decompiled with Potassium's decompiler.

local BaseSpline = require(script.Parent:WaitForChild("BaseSpline"));
local u1 = { "number", "Vector2", "Vector3", "Instance" };

local function isCatmullRomPoint(p2) -- Line: 78
    -- upvalues: u1 (copy)
    local v3 = typeof(p2);

    if table.find(u1, v3) == nil then
        return false;
    end;

    return v3 ~= "Instance" and true or p2:IsA("BasePart");
end;

local u4 = setmetatable({}, BaseSpline);
u4.__index = u4;

function u4.new(p5, p6) -- Line: 95
    -- upvalues: BaseSpline (copy), u4 (copy)
    local v7 = BaseSpline.new();
    local v8 = setmetatable(v7, u4);
    v8.Points = {};
    v8.Tension = p6 or 0.5;
    v8._PointType = "nil";
    v8._Connections = {};

    if p5 ~= nil then
        for i = 1, #p5 do
            v8:AddPoint(p5[i]);
        end;
    end;

    return v8;
end;

function u4.ChangeTension(p9, p10) -- Line: 115
    if p9.Tension == p10 then
        return;
    end;

    p9.Tension = p10;

    if #p9.Points == 4 then
        p9:_UpdateLength();
    end;
end;

function u4.IsValidPoint(p11, p12) -- Line: 128
    -- upvalues: isCatmullRomPoint (ref)
    local v13 = (p11._PointType == "Vector3" and (typeof(p12) == "Instance" and p12:IsA("BasePart")) or p11._PointType == "Instance" and typeof(p12) == "Vector3") and true or (p11._PointType == typeof(p12) and true or false);

    return isCatmullRomPoint(p12) and v13;
end;

function u4.AddPoint(p14, p15, p16) -- Line: 143
    -- upvalues: isCatmullRomPoint (ref)
    local Points = p14.Points;

    if #Points == 0 then
        p14._PointType = typeof(p15);
    elseif #Points > 3 then
        error("Cannot add more points to this CatmullRomSpline object!");
    end;

    if not (isCatmullRomPoint(p15) and p14:IsValidPoint(p15)) then
        error("The given point is not a valid point for this CatmullRomSpline object!");
    end;

    if typeof(p15) == "Instance" and p15:IsA("BasePart") then
        p14:_ListenToPositionChange(p15);
    end;

    table.insert(Points, p16 or #Points + 1, p15);

    if #Points == 4 then
        p14:_UpdateLength();
    end;
end;

function u4.RemovePoint(p17, p18) -- Line: 169
    local Points = p17.Points;

    if Points[p18] == nil then
        return;
    end;

    local v19 = table.remove(Points, p18);

    if typeof(v19) == "Instance" and v19:IsA("BasePart") then
        p17:_StopListeningToPositionChange(v19);
    end;

    if #Points < 4 then
        p17.Length = 0;
        p17._LengthCache = {};
    end;
end;

function u4.GetVectorPoints(p20) -- Line: 188
    local v21 = {};

    for i, v in ipairs(p20.Points) do
        if typeof(v) == "Instance" then
            if v:IsA("BasePart") then
                v21[i] = v.Position;
            else
                error("CatmullRomSpline expected a BasePart Instance, got " .. tostring(v.ClassName) .. "!");
            end;
        else
            v21[i] = v;
        end;
    end;

    return v21;
end;

function u4.GetVectorConstants(p22) -- Line: 206
    local v23 = p22:GetVectorPoints();
    local v24 = #v23;

    if v24 < 4 then
        error("CatmullRomSpline:GetVectorConstants() expected 4 points, got " .. tostring(v24) .. " points.");
    end;

    local Tension = p22.Tension;

    return v23[2], Tension * (v23[3] - v23[1]), 3 * (v23[3] - v23[2]) - Tension * (v23[4] - v23[2]) - 2 * Tension * (v23[3] - v23[1]), -2 * (v23[3] - v23[2]) + Tension * (v23[4] - v23[2]) + Tension * (v23[3] - v23[1]);
end;

function u4._ListenToPositionChange(u25, p26) -- Line: 221
    u25._Connections[p26] = p26:GetPropertyChangedSignal("Position"):Connect(function() -- Line: 223
        -- upvalues: u25 (copy)
        if #u25.Points < 4 then
            return;
        end;

        u25:_UpdateLength();
    end);
end;

function u4._StopListeningToPositionChange(p27, p28) -- Line: 232
    local _Connections = p27._Connections;
    local v29 = _Connections[p28];

    if v29 == nil then
        return;
    end;

    v29:Disconnect();
    _Connections[p28] = nil;
end;

function u4.Position(p30, p31) -- Line: 244
    local v32, v33, v34, v35 = p30:GetVectorConstants();

    return v32 + v33 * p31 + v34 * p31 * p31 + v35 * p31 * p31 * p31;
end;

function u4.Velocity(p36, p37) -- Line: 251
    local _, v38, v39, v40 = p36:GetVectorConstants();

    return v38 + 2 * v39 * p37 + 3 * v40 * p37 * p37;
end;

function u4.Acceleration(p41, p42) -- Line: 258
    local _, _, v43, v44 = p41:GetVectorConstants();

    return 2 * v43 + 6 * v44 * p42;
end;

return u4;