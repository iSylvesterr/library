-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = {};

local function isLeadEnabled(p2) -- Line: 16
    if type(p2) ~= "table" then
        return false;
    end;

    local aimLeadEnabled = p2.aimLeadEnabled;

    return aimLeadEnabled == true and true or aimLeadEnabled == 1;
end;

local function getLeadSeconds(p3) -- Line: 24
    if type(p3) ~= "table" then
        return 0;
    end;

    local aimLeadSeconds = p3.aimLeadSeconds;

    return (type(aimLeadSeconds) ~= "number" or aimLeadSeconds <= 0) and 0 or aimLeadSeconds;
end;

local function clampHorizontal(p4, p5) -- Line: 35
    local v6 = Vector3.new(p4.X, 0, p4.Z);
    local Magnitude = v6.Magnitude;

    if Magnitude < 1e-6 then
        return v6;
    end;

    if type(p5) == "number" and (p5 > 0 and p5 < Magnitude) then
        return v6.Unit * p5;
    end;

    return v6;
end;

function v1.computeHorizontalAimPoint(p7, p8, p9) -- Line: 49
    if not p7 then
        return p8;
    end;

    local v10;

    if type(p9) == "table" then
        local aimLeadEnabled = p9.aimLeadEnabled;
        v10 = aimLeadEnabled == true and true or aimLeadEnabled == 1;
    else
        v10 = false;
    end;

    if not v10 then
        return p7.Position;
    end;

    local v11;

    if type(p9) == "table" then
        local aimLeadSeconds = p9.aimLeadSeconds;
        v11 = (type(aimLeadSeconds) ~= "number" or aimLeadSeconds <= 0) and 0 or aimLeadSeconds;
    else
        v11 = 0;
    end;

    if v11 <= 0 then
        return p7.Position;
    end;

    local AssemblyLinearVelocity = p7.AssemblyLinearVelocity;
    local v12 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z) * v11;
    local v13;

    if type(p9) == "table" and (type(p9.aimLeadMaxStuds) == "number" and p9.aimLeadMaxStuds > 0) then
        v13 = p9.aimLeadMaxStuds;
    else
        v13 = nil;
    end;

    local v14 = Vector3.new(v12.X, 0, v12.Z);
    local Magnitude = v14.Magnitude;

    if Magnitude >= 1e-6 and (type(v13) == "number" and (v13 > 0 and v13 < Magnitude)) then
        v14 = v14.Unit * v13;
    end;

    return p7.Position + v14;
end;

function v1.getDataForGroupAbility(p15) -- Line: 72
    -- upvalues: ReplicatedStorage (copy)
    if type(p15) ~= "string" or p15 == "" then
        return nil;
    end;

    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

    if ClientSideCode then
        ClientSideCode = ClientSideCode:FindFirstChild("SystemSkill");
    end;

    if ClientSideCode then
        ClientSideCode = ClientSideCode:FindFirstChild("GroupSkillModule");
    end;

    if not ClientSideCode then
        return nil;
    end;

    local v16 = ClientSideCode:FindFirstChild(p15);

    if not (v16 and v16:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, v16);

    if not success or type(result) ~= "table" then
        return nil;
    end;

    local Data = result.Data;

    if type(Data) == "table" then
        return Data;
    end;

    return nil;
end;

return v1;