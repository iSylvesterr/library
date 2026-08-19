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

local function YAxisSafeUnit(p2) -- Line: 14
    return p2.Magnitude <= 1e-6 and Vector3.new(-0, -1, -0) or p2.Unit;
end;

local u64 = {
    LogIndent = 0,

    GetRotationBetween = function(p3, p4) -- Line: 25, Name: GetRotationBetween
        local v5 = p3:Dot(p4);
        local Magnitude = p3:Cross(p4).Magnitude;
        local v6 = math.atan2(Magnitude, v5);
        local v7 = p3:Cross(p4);
        local v8 = v7.Magnitude <= 1e-6 and Vector3.new(-0, -1, -0) or v7.Unit;

        if Magnitude >= 1e-6 then
            return CFrame.fromAxisAngle(v8, v6);
        end;

        if v5 > 0 then
            return CFrame.new();
        end;

        local v9 = math.abs(p3.X) > math.abs(p3.Z) and Vector3.new(-p3.Y, p3.X, 0) or Vector3.new(0, -p3.Z, p3.Y);

        return CFrame.fromAxisAngle(v9.Unit, 3.141592653589793);
    end,

    GetCFrameAxis = function(p10, p11) -- Line: 44, Name: GetCFrameAxis
        local v12, v13, v14 = p10:ToEulerAnglesXYZ();

        if p11 == "X" then
            return v12;
        end;

        if p11 == "Y" then
            return v13;
        end;

        if p11 == "Z" then
            return v14;
        end;

        return nil;
    end,

    GatherObjectSettings = function(u15) -- Line: 56, Name: GatherObjectSettings
        -- upvalues: DefaultObjectSettings (copy)
        local function Expect(p16, p17, p18) -- Line: 59
            -- upvalues: u15 (copy)
            if typeof(p16) == p17 then
                return true;
            end;

            warn((`[SmartBone][Object] Expected attribute {p18} on {u15.Name} to be of type {p17}, got type {typeof(p16)}`));

            return false;
        end;

        local v19 = {};

        for i, v in DefaultObjectSettings do
            local v20 = u15:GetAttribute(i);

            if v20 ~= nil then
                local v21 = typeof(v);
                local v22;

                if typeof(v20) == v21 then
                    v22 = true;
                else
                    warn((`[SmartBone][Object] Expected attribute {i} on {u15.Name} to be of type {v21}, got type {typeof(v20)}`));
                    v22 = false;
                end;

                if not v22 then
                    v20 = nil;
                end;
            end;

            v19[i] = v20 == nil and v and v or v20;
        end;

        return v19;
    end,

    GatherBoneSettings = function(u23) -- Line: 83, Name: GatherBoneSettings
        local function Attrib(p24) -- Line: 84
            -- upvalues: u23 (copy)
            return u23:GetAttribute(p24);
        end;

        local function _(p25, p26, p27) -- Line: 88
            -- upvalues: u23 (copy)
            if typeof(p25) ~= p26 then
                warn((`[SmartBone][Bone] Expected attribute {p27} on {u23.Name} to be of type {p26}, got type {typeof(p25)}`));
            end;
        end;

        local v28 = u23:GetAttribute("XAxisLocked") or false;
        local v29 = u23:GetAttribute("YAxisLocked") or false;
        local v30 = u23:GetAttribute("ZAxisLocked") or false;
        local v31 = u23:GetAttribute("XAxisLimits") or NumberRange.new((-1 / 0), (1 / 0));
        local v32 = u23:GetAttribute("YAxisLimits") or NumberRange.new((-1 / 0), (1 / 0));
        local v33 = u23:GetAttribute("ZAxisLimits") or NumberRange.new((-1 / 0), (1 / 0));
        local v34 = u23:GetAttribute("Radius") or 0.25;
        local v35 = u23:GetAttribute("RotationLimit") or 180;
        local v36 = u23:GetAttribute("Force") or "¬";
        local v37 = u23:GetAttribute("Gravity") or "¬";

        if typeof(v28) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute XAxisLocked on {u23.Name} to be of type boolean, got type {typeof(v28)}`));
        end;

        if typeof(v29) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute YAxisLocked on {u23.Name} to be of type boolean, got type {typeof(v29)}`));
        end;

        if typeof(v30) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute ZAxisLocked on {u23.Name} to be of type boolean, got type {typeof(v30)}`));
        end;

        if typeof(v31) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute XAxisLimits on {u23.Name} to be of type NumberRange, got type {typeof(v31)}`));
        end;

        if typeof(v32) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute YAxisLimits on {u23.Name} to be of type NumberRange, got type {typeof(v32)}`));
        end;

        if typeof(v33) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute ZAxisLimits on {u23.Name} to be of type NumberRange, got type {typeof(v33)}`));
        end;

        if typeof(v34) ~= "number" then
            warn((`[SmartBone][Bone] Expected attribute Radius on {u23.Name} to be of type number, got type {typeof(v34)}`));
        end;

        if typeof(v35) ~= "number" then
            warn((`[SmartBone][Bone] Expected attribute RotationLimit on {u23.Name} to be of type number, got type {typeof(v35)}`));
        end;

        if v36 ~= "¬" and typeof(v36) ~= "Vector3" then
            warn((`[SmartBone][Bone] Expected attribute Force on {u23.Name} to be of type Vector3, got type {typeof(v36)}`));
        end;

        if v36 ~= "¬" and typeof(v37) ~= "Vector3" then
            warn((`[SmartBone][Bone] Expected attribute Gravity on {u23.Name} to be of type Vector3, got type {typeof(v37)}`));
        end;

        return {
            AxisLocked = { v28, v29, v30 },
            XAxisLimits = v31,
            YAxisLimits = v32,
            ZAxisLimits = v33,
            RotationLimit = v35,
            Radius = v34,
            Force = v36,
            Gravity = v37
        };
    end,

    ClosestPointOnLine = function(p38, p39, p40, p41) -- Line: 142, Name: ClosestPointOnLine
        local v42 = (p41 - p38):Dot(p39);

        return p38 + p39 * math.clamp(v42, -p40, p40);
    end,

    ClosestPointInBox = function(p43, p44, p45) -- Line: 150, Name: ClosestPointInBox
        local v46 = p43:PointToObjectSpace(p45);
        local X = p44.X;
        local X2 = p44.X;
        local Z = p44.Z;
        local X3 = v46.X;
        local Y = v46.Y;
        local Z2 = v46.Z;

        if v46 ~= v46 or p44 ~= p44 then
            return false, p43.Position, Vector3.new(0, 1, 0);
        end;

        local v47 = math.clamp(X3, -X * 0.5, X * 0.5);
        local v48 = math.clamp(Y, -X2 * 0.5, X2 * 0.5);
        local v49 = math.clamp(Z2, -Z * 0.5, Z * 0.5);

        if v47 ~= X3 or (v48 ~= Y or v49 ~= Z2) then
            local v50 = p43 * Vector3.new(v47, v48, v49);

            return false, v50, (p45 - v50).unit;
        end;

        local v51 = X3 - X * 0.5;
        local v52 = Y - X2 * 0.5;
        local v53 = Z2 - Z * 0.5;
        local v54 = -X3 - X * 0.5;
        local v55 = -Y - X2 * 0.5;
        local v56 = -Z2 - Z * 0.5;
        local v57 = math.max(v51, v52, v53, v54, v55, v56);

        if v57 == v51 then
            return true, p43 * Vector3.new(X * 0.5, Y, Z2), p43.XVector;
        end;

        if v57 == v52 then
            return true, p43 * Vector3.new(X3, X2 * 0.5, Z2), p43.YVector;
        end;

        if v57 == v53 then
            return true, p43 * Vector3.new(X3, Y, Z * 0.5), p43.ZVector;
        end;

        if v57 == v54 then
            return true, p43 * Vector3.new(-X * 0.5, Y, Z2), -p43.XVector;
        end;

        if v57 == v55 then
            return true, p43 * Vector3.new(X3, -X2 * 0.5, Z2), -p43.YVector;
        end;

        if v57 == v56 then
            return true, p43 * Vector3.new(X3, Y, -Z * 0.5), -p43.ZVector;
        end;

        warn("CLOSEST POINT ON BOX FAIL");

        return false, Vector3.new(0, 0, 0), Vector3.new(0, 1, 0);
    end,

    GetCollider = function(p58) -- Line: 205, Name: GetCollider
        -- upvalues: HttpService (copy), u1 (copy)
        local v59 = p58:FindFirstChild("self.Collider");
        local v60;

        if v59 and v59:IsA("ModuleScript") then
            local u61 = require(v59);
            local u62 = nil;
            pcall(function() -- Line: 214
                -- upvalues: u62 (ref), HttpService (ref), u61 (copy)
                u62 = HttpService:JSONDecode(u61);
            end);
            v60 = u62;
        else
            v60 = nil;
        end;

        if v60 then
            return v60;
        end;

        local function GetShapeName(p63) -- Line: 227
            return p63:GetAttribute("ColliderShape") or (not p63:IsA("Part") and "Box" or p63.Shape.Name);
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
                Type = u1[p58:GetAttribute("ColliderShape") or (not p58:IsA("Part") and "Box" or p58.Shape.Name)] or "Box"
            }
        };
    end
};

function u64.SB_INDENT_LOG() -- Line: 261
    -- upvalues: u64 (copy)
    local v65 = u64;
    v65.LogIndent = v65.LogIndent + 1;
end;

function u64.SB_UNINDENT_LOG() -- Line: 265
    -- upvalues: u64 (copy)
    local v66 = u64;
    v66.LogIndent = v66.LogIndent - 1;
    u64.LogIndent = math.max(u64.LogIndent, 0);
end;

function u64.SB_ASSERT_CB(p67, p68, ...) -- Line: 270
    if p67 == false or p67 == nil then
        p68(...);
    end;
end;

function u64.SB_VERBOSE_LOG(p69) -- Line: 276
    -- upvalues: Config (copy), u64 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local v70 = string.rep("    ", u64.LogIndent);
    print((`{v70}[SmartBone][Log]: {p69}`));
end;

function u64.SB_VERBOSE_WARN(p71) -- Line: 286
    -- upvalues: Config (copy), u64 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local v72 = string.rep("    ", u64.LogIndent);
    warn((`{v72}[SmartBone][Warn]: {p71}`));
end;

function u64.SB_VERBOSE_ERROR(p73) -- Line: 296
    -- upvalues: Config (copy), u64 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local v74 = string.rep("    ", u64.LogIndent);
    error((`{v74}[SmartBone][Error]: {p73}`));
end;

return u64;