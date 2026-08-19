-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Config = require(script.Parent:WaitForChild("Config"));
local DefaultObjectSettings = require(script.Parent:WaitForChild("DefaultObjectSettings"));
local u1 = {
    Block = "Box",
    Ball = "Sphere",
    Capsule = "Capsule",
    Sphere = "Sphere",
    Box = "Box",
    Cylinder = "Cylinder"
};

local function SafeUnit(p2) -- Line: 14
    return p2.Magnitude == 0 and Vector3.new(-0, -1, -0) or p2.Unit;
end;

local u62 = {
    LogIndent = 0,

    GetRotationBetween = function(p3, p4) -- Line: 25, Name: GetRotationBetween
        local v5 = p3:Dot(p4);
        local Magnitude = p3:Cross(p4).Magnitude;
        local v6 = math.atan2(Magnitude, v5);
        local v7 = p3:Cross(p4);

        return CFrame.fromAxisAngle(v7.Magnitude == 0 and Vector3.new(-0, -1, -0) or v7.Unit, v6);
    end,

    GetCFrameAxis = function(p8, p9) -- Line: 34, Name: GetCFrameAxis
        local v10, v11, v12 = p8:ToEulerAnglesXYZ();

        if p9 == "X" then
            return v10;
        end;

        if p9 == "Y" then
            return v11;
        end;

        if p9 == "Z" then
            return v12;
        end;

        return nil;
    end,

    GatherObjectSettings = function(u13) -- Line: 46, Name: GatherObjectSettings
        -- upvalues: DefaultObjectSettings (copy)
        local function Expect(p14, p15, p16) -- Line: 49
            -- upvalues: u13 (copy)
            if typeof(p14) == p15 then
                return true;
            end;

            warn((`[SmartBone][Object] Expected attribute {p16} on {u13.Name} to be of type {p15}, got type {typeof(p14)}`));

            return false;
        end;

        local v17 = {};

        for i, v in DefaultObjectSettings do
            local v18 = u13:GetAttribute(i);

            if v18 ~= nil then
                local v19 = typeof(v);
                local v20;

                if typeof(v18) == v19 then
                    v20 = true;
                else
                    warn((`[SmartBone][Object] Expected attribute {i} on {u13.Name} to be of type {v19}, got type {typeof(v18)}`));
                    v20 = false;
                end;

                if not v20 then
                    v18 = nil;
                end;
            end;

            v17[i] = v18 == nil and v and v or v18;
        end;

        return v17;
    end,

    GatherBoneSettings = function(u21) -- Line: 77, Name: GatherBoneSettings
        local function Attrib(p22) -- Line: 78
            -- upvalues: u21 (copy)
            return u21:GetAttribute(p22);
        end;

        local function _(p23, p24, p25) -- Line: 82
            -- upvalues: u21 (copy)
            if typeof(p23) ~= p24 then
                warn((`[SmartBone][Bone] Expected attribute {p25} on {u21.Name} to be of type {p24}, got type {typeof(p23)}`));
            end;
        end;

        local v26 = u21:GetAttribute("XAxisLocked") or false;
        local v27 = u21:GetAttribute("YAxisLocked") or false;
        local v28 = u21:GetAttribute("ZAxisLocked") or false;
        local v29 = u21:GetAttribute("XAxisLimits") or NumberRange.new((-1 / 0), (1 / 0));
        local v30 = u21:GetAttribute("YAxisLimits") or NumberRange.new((-1 / 0), (1 / 0));
        local v31 = u21:GetAttribute("ZAxisLimits") or NumberRange.new((-1 / 0), (1 / 0));
        local v32 = u21:GetAttribute("Radius") or 0.25;
        local v33 = u21:GetAttribute("RotationLimit") or 180;
        local v34 = u21:GetAttribute("Force") or "¬";
        local v35 = u21:GetAttribute("Gravity") or "¬";

        if typeof(v26) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute XAxisLocked on {u21.Name} to be of type boolean, got type {typeof(v26)}`));
        end;

        if typeof(v27) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute YAxisLocked on {u21.Name} to be of type boolean, got type {typeof(v27)}`));
        end;

        if typeof(v28) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute ZAxisLocked on {u21.Name} to be of type boolean, got type {typeof(v28)}`));
        end;

        if typeof(v29) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute XAxisLimits on {u21.Name} to be of type NumberRange, got type {typeof(v29)}`));
        end;

        if typeof(v30) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute YAxisLimits on {u21.Name} to be of type NumberRange, got type {typeof(v30)}`));
        end;

        if typeof(v31) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute ZAxisLimits on {u21.Name} to be of type NumberRange, got type {typeof(v31)}`));
        end;

        if typeof(v32) ~= "number" then
            warn((`[SmartBone][Bone] Expected attribute Radius on {u21.Name} to be of type number, got type {typeof(v32)}`));
        end;

        if typeof(v33) ~= "number" then
            warn((`[SmartBone][Bone] Expected attribute RotationLimit on {u21.Name} to be of type number, got type {typeof(v33)}`));
        end;

        if v34 ~= "¬" and typeof(v34) ~= "Vector3" then
            warn((`[SmartBone][Bone] Expected attribute Force on {u21.Name} to be of type Vector3, got type {typeof(v34)}`));
        end;

        if v34 ~= "¬" and typeof(v35) ~= "Vector3" then
            warn((`[SmartBone][Bone] Expected attribute Gravity on {u21.Name} to be of type Vector3, got type {typeof(v35)}`));
        end;

        return {
            AxisLocked = { v26, v27, v28 },
            XAxisLimits = v29,
            YAxisLimits = v30,
            ZAxisLimits = v31,
            RotationLimit = v33,
            Radius = v32,
            Force = v34,
            Gravity = v35
        };
    end,

    ClosestPointOnLine = function(p36, p37, p38, p39) -- Line: 140, Name: ClosestPointOnLine
        local v40 = (p39 - p36):Dot(p37);

        return p36 + p37 * math.clamp(v40, -p38, p38);
    end,

    ClosestPointInBox = function(p41, p42, p43) -- Line: 148, Name: ClosestPointInBox
        local v44 = p41:PointToObjectSpace(p43);
        local X = p42.X;
        local X2 = p42.X;
        local Z = p42.Z;
        local X3 = v44.X;
        local Y = v44.Y;
        local Z2 = v44.Z;

        if v44 ~= v44 or p42 ~= p42 then
            return false, p41.Position, Vector3.new(0, 1, 0);
        end;

        local v45 = math.clamp(X3, -X * 0.5, X * 0.5);
        local v46 = math.clamp(Y, -X2 * 0.5, X2 * 0.5);
        local v47 = math.clamp(Z2, -Z * 0.5, Z * 0.5);

        if v45 ~= X3 or (v46 ~= Y or v47 ~= Z2) then
            local v48 = p41 * Vector3.new(v45, v46, v47);

            return false, v48, (p43 - v48).unit;
        end;

        local v49 = X3 - X * 0.5;
        local v50 = Y - X2 * 0.5;
        local v51 = Z2 - Z * 0.5;
        local v52 = -X3 - X * 0.5;
        local v53 = -Y - X2 * 0.5;
        local v54 = -Z2 - Z * 0.5;
        local v55 = math.max(v49, v50, v51, v52, v53, v54);

        if v55 == v49 then
            return true, p41 * Vector3.new(X * 0.5, Y, Z2), p41.XVector;
        end;

        if v55 == v50 then
            return true, p41 * Vector3.new(X3, X2 * 0.5, Z2), p41.YVector;
        end;

        if v55 == v51 then
            return true, p41 * Vector3.new(X3, Y, Z * 0.5), p41.ZVector;
        end;

        if v55 == v52 then
            return true, p41 * Vector3.new(-X * 0.5, Y, Z2), -p41.XVector;
        end;

        if v55 == v53 then
            return true, p41 * Vector3.new(X3, -X2 * 0.5, Z2), -p41.YVector;
        end;

        if v55 == v54 then
            return true, p41 * Vector3.new(X3, Y, -Z * 0.5), -p41.ZVector;
        end;

        warn("CLOSEST POINT ON BOX FAIL");

        return false, Vector3.new(0, 0, 0), Vector3.new(0, 1, 0);
    end,

    GetCollider = function(p56) -- Line: 203, Name: GetCollider
        -- upvalues: HttpService (copy), u1 (copy)
        local v57 = p56:FindFirstChild("self.Collider");
        local v58;

        if v57 and v57:IsA("ModuleScript") then
            local u59 = require(v57);
            local u60 = nil;
            pcall(function() -- Line: 212
                -- upvalues: u60 (ref), HttpService (ref), u59 (copy)
                u60 = HttpService:JSONDecode(u59);
            end);
            v58 = u60;
        else
            v58 = nil;
        end;

        if v58 then
            return v58;
        end;

        local function GetShapeName(p61) -- Line: 225
            return p61:GetAttribute("ColliderShape") or (not p61:IsA("Part") and "Box" or p61.Shape.Name);
        end;

        return {
            {
                ScaleX = 1,
                ScaleY = 1,
                ScaleZ = 1,
                OffsetX = 0,
                OffsetY = 0,
                OffsetZ = 0,
                RotationX = 0,
                RotationY = 0,
                RotationZ = 0,
                Type = u1[p56:GetAttribute("ColliderShape") or (not p56:IsA("Part") and "Box" or p56.Shape.Name)] or "Box"
            }
        };
    end
};

function u62.SB_INDENT_LOG() -- Line: 259
    -- upvalues: u62 (copy)
    local v63 = u62;
    v63.LogIndent = v63.LogIndent + 1;
end;

function u62.SB_UNINDENT_LOG() -- Line: 263
    -- upvalues: u62 (copy)
    local v64 = u62;
    v64.LogIndent = v64.LogIndent - 1;
    u62.LogIndent = math.max(u62.LogIndent, 0);
end;

function u62.SB_ASSERT_CB(p65, p66, ...) -- Line: 268
    if p65 == false or p65 == nil then
        p66(...);
    end;
end;

function u62.SB_VERBOSE_LOG(p67) -- Line: 274
    -- upvalues: Config (copy), u62 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local v68 = string.rep("    ", u62.LogIndent);
    print((`{v68}[SmartBone][Log]: {p67}`));
end;

function u62.SB_VERBOSE_WARN(p69) -- Line: 284
    -- upvalues: Config (copy), u62 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local v70 = string.rep("    ", u62.LogIndent);
    warn((`{v70}[SmartBone][Warn]: {p69}`));
end;

function u62.SB_VERBOSE_ERROR(p71) -- Line: 294
    -- upvalues: Config (copy), u62 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local v72 = string.rep("    ", u62.LogIndent);
    error((`{v72}[SmartBone][Error]: {p71}`));
end;

return u62;