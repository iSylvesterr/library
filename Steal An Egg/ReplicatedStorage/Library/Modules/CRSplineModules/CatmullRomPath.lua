-- Decompiled with Potassium's decompiler.

local BaseSpline = require(script.Parent:WaitForChild("BaseSpline"));
local CatmullRomSpline = require(script.Parent:WaitForChild("CatmullRomSpline"));
local u1 = setmetatable({}, BaseSpline);
u1.__index = u1;

function u1.new(p2, p3) -- Line: 69
    -- upvalues: BaseSpline (copy), u1 (copy)
    local v4 = BaseSpline.new();
    local v5 = setmetatable(v4, u1);
    v5.LinkedSplines = {};
    v5.LinkConnectedSplinesOnly = p3 or false;
    v5._Connections = {};

    if p2 ~= nil then
        for i = 1, #p2 do
            v5:LinkSpline(p2[i]);
        end;
    end;

    return v5;
end;

function u1.fromPoints(p6, p7) -- Line: 92
    -- upvalues: CatmullRomSpline (copy), u1 (copy)
    if #p6 < 4 then
        error("Cannot create a CatmullRomPath from less than 4 control points!");
    end;

    local v8 = {};

    for i = 3, #p6 - 1 do
        table.insert(v8, CatmullRomSpline.new({
            p6[i - 2],
            p6[i - 1],
            p6[i],
            p6[i + 1]
        }, p7));
    end;

    return u1.new(v8, true);
end;

function u1.LinkSpline(p9, p10) -- Line: 120
    local LinkedSplines = p9.LinkedSplines;
    local v11 = LinkedSplines[#LinkedSplines];
    local LinkConnectedSplinesOnly = p9.LinkConnectedSplinesOnly;

    if v11 == nil then
        table.insert(LinkedSplines, p10);
        p9:_ListenToSplineUpdate(p10);
    elseif LinkConnectedSplinesOnly then
        local Points = v11.Points;
        local Points2 = p10.Points;
        local v12 = true;

        if Points[2] == Points2[1] and Points[3] == Points2[2] then
            if Points[4] ~= Points2[3] then
                v12 = false;
            end;
        else
            v12 = false;
        end;

        if not v12 then
            error("Unable to link the given CatmullRomSpline to the CatmullRomPath!");
        end;

        table.insert(LinkedSplines, p10);
        p9:_ListenToSplineUpdate(p10);
    else
        table.insert(LinkedSplines, p10);
        p9:_ListenToSplineUpdate(p10);
    end;

    for i = 1, #LinkedSplines do
        if #LinkedSplines[i].Points < 4 then
            return;
        end;
    end;

    p9:_UpdateLength();
end;

function u1.UnlinkSpline(p13, p14) -- Line: 159
    local LinkedSplines = p13.LinkedSplines;
    local LinkConnectedSplinesOnly = p13.LinkConnectedSplinesOnly;

    if typeof(p14) == "number" then
        if LinkConnectedSplinesOnly and p14 ~= #LinkedSplines then
            warn("Cannot unlink the spline; this path is meant to be connected by connected splines!\nTry setting CatmullRomSpline.LinkConnectedSplinesOnly to false!");

            return;
        end;

        if LinkedSplines[p14] == nil then
            return;
        end;

        table.remove(LinkedSplines, p14);
        p13:_StopListeningToSplineUpdate(p14);
    else
        local v15 = table.find(LinkedSplines, p14);

        if v15 == nil then
            return;
        end;

        if LinkConnectedSplinesOnly and v15 ~= #LinkedSplines then
            return;
        end;

        table.remove(LinkedSplines, v15);
        p13:_StopListeningToSplineUpdate(p14);
    end;

    if #LinkedSplines < 1 then
        return;
    end;

    for i = 1, #LinkedSplines do
        if #LinkedSplines[i].Points < 4 then
            return;
        end;
    end;

    p13:_UpdateLength();
end;

function u1.PiecewiseTransform(p16, p17) -- Line: 204
    local LinkedSplines = p16.LinkedSplines;
    local v18 = #LinkedSplines;

    if v18 == 1 then
        return LinkedSplines[1], p17;
    end;

    if v18 < 1 then
        error("Cannot return a spline at value t without splines!");
    end;

    local v19 = 1 / v18;
    local v20, v21;

    if p17 <= 0 then
        v20 = p17 * v19;
        v21 = 1;
    elseif p17 >= 1 then
        v21 = #LinkedSplines;
        v20 = (p17 - 1) * v19 + 1;
    else
        v21 = math.ceil(p17 * v18);
        v20 = p17 * v18 - v21 + 1;
    end;

    return LinkedSplines[v21], v20;
end;

function u1._ListenToSplineUpdate(u22, p23) -- Line: 231
    u22:_StopListeningToSplineUpdate(p23);
    u22._Connections[p23] = p23.Updated:Connect(function() -- Line: 234
        -- upvalues: u22 (copy)
        u22:_UpdateLength();
    end);
end;

function u1._StopListeningToSplineUpdate(p24, p25) -- Line: 240
    local v26 = p24._Connections[p25];

    if v26 then
        v26:Disconnect();
        v26[p25] = nil;
    end;
end;

function u1.Position(p27, p28) -- Line: 249
    local v29, v30 = p27:PiecewiseTransform(p28);

    return v29:Position(v30);
end;

function u1.Velocity(p31, p32) -- Line: 254
    local v33, v34 = p31:PiecewiseTransform(p32);

    return v33:Velocity(v34);
end;

function u1.Acceleration(p35, p36) -- Line: 259
    local v37, v38 = p35:PiecewiseTransform(p36);

    return v37:Acceleration(v38);
end;

return u1;