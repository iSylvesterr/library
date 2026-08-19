-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = false;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = OverlapParams.new();
u10.FilterType = Enum.RaycastFilterType.Include;
local v11 = {};

local function UpdateBuoyancy(p12, p13) -- Line: 49
    p12.Force = Vector3.new(0, p13.AssemblyMass * workspace.Gravity, 0);
end;

local function EnterSwim() -- Line: 53
    -- upvalues: u3 (ref), u4 (ref), u6 (ref), u9 (ref), u8 (ref)
    local v14 = u3;
    local v15 = u4;

    if u6 or not (v14 and v15) then
        return;
    end;

    u6 = true;
    v14:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false);
    v14:ChangeState(Enum.HumanoidStateType.Swimming);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "SwimBuoyancyAttachment";
    Attachment.Parent = v15;
    local VectorForce = Instance.new("VectorForce");
    VectorForce.Name = "SwimBuoyancy";
    VectorForce.Attachment0 = Attachment;
    VectorForce.ApplyAtCenterOfMass = true;
    VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World;
    VectorForce.Force = Vector3.new(0, v15.AssemblyMass * workspace.Gravity, 0);
    VectorForce.Parent = v15;
    u9 = Attachment;
    u8 = VectorForce;
end;

local function ExitSwim(p16) -- Line: 85
    -- upvalues: u7 (ref), u8 (ref), u9 (ref), u6 (ref), u3 (ref)
    u7 = nil;

    if u8 then
        u8:Destroy();
        u8 = nil;
    end;

    if u9 then
        u9:Destroy();
        u9 = nil;
    end;

    if not u6 then
        return;
    end;

    u6 = false;
    local v17 = u3;

    if v17 then
        v17:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true);

        if not p16 then
            v17:ChangeState(Enum.HumanoidStateType.GettingUp);
        end;
    end;
end;

local function BindCharacter(p18) -- Line: 109
    -- upvalues: u5 (ref), ExitSwim (copy), u2 (ref), u3 (ref), u4 (ref), u10 (copy)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    ExitSwim();
    u2 = p18;
    u3 = p18:FindFirstChildOfClass("Humanoid");
    u4 = p18:FindFirstChild("HumanoidRootPart");
    u10.FilterDescendantsInstances = { p18 };

    if u3 then
        u5 = u3.Died:Connect(ExitSwim);
    end;
end;

local function UnbindCharacter() -- Line: 127
    -- upvalues: ExitSwim (copy), u5 (ref), u2 (ref), u3 (ref), u4 (ref)
    ExitSwim();

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    u2 = nil;
    u3 = nil;
    u4 = nil;
end;

local function GetPropModel(p19) -- Line: 138
    while p19 and p19 ~= workspace do
        if p19:IsA("Model") then
            if p19.Name == "PropPreview" then
                return p19;
            end;

            if p19:GetAttribute("PropId") ~= nil then
                return p19;
            end;
        end;

        p19 = p19.Parent;
    end;

    return nil;
end;

local function IsSwimPartActive(p20) -- Line: 157
    -- upvalues: GetPropModel (copy)
    local v21 = GetPropModel(p20);

    if not v21 then
        return true;
    end;

    if v21.Name == "PropPreview" then
        return false;
    end;

    if v21:GetAttribute("PropId") == nil then
        return false;
    end;

    return v21:GetAttribute("IsBeingMoved") ~= true;
end;

local function IsInsideAnySwimPart() -- Line: 169
    -- upvalues: u1 (copy), GetPropModel (copy), u10 (copy), u7 (ref)
    for i in u1 do
        local v22 = GetPropModel(i);
        local v23;

        if v22 then
            if v22.Name == "PropPreview" or v22:GetAttribute("PropId") == nil then
                v23 = false;
            else
                v23 = v22:GetAttribute("IsBeingMoved") ~= true;
            end;
        else
            v23 = true;
        end;

        if v23 and #workspace:GetPartsInPart(i, u10) > 0 then
            u7 = i;

            return true;
        end;
    end;

    return false;
end;

local function OnHeartbeat() -- Line: 181
    -- upvalues: u4 (ref), u3 (ref), u6 (ref), ExitSwim (copy), u7 (ref), u8 (ref), u9 (ref), u1 (copy), IsInsideAnySwimPart (copy), EnterSwim (copy)
    local v24 = u4;
    local v25 = u3;

    if not (v24 and v25) then
        if u6 then
            ExitSwim();
        end;

        return;
    end;

    if v25.PlatformStand then
        if u6 then
            u7 = nil;

            if u8 then
                u8:Destroy();
                u8 = nil;
            end;

            if u9 then
                u9:Destroy();
                u9 = nil;
            end;

            if not u6 then
                return;
            end;

            u6 = false;
            local v26 = u3;

            if v26 then
                v26:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true);
            end;
        end;

        return;
    end;

    if not next(u1) then
        if u6 then
            ExitSwim();
        end;

        return;
    end;

    local v27 = IsInsideAnySwimPart();

    if v27 and not u6 then
        EnterSwim();
    elseif not v27 and u6 then
        ExitSwim();
    end;

    if u6 then
        local v28 = u8;

        if v28 then
            v28.Force = Vector3.new(0, v24.AssemblyMass * workspace.Gravity, 0);
        end;

        if v25:GetState() ~= Enum.HumanoidStateType.Swimming then
            v25:ChangeState(Enum.HumanoidStateType.Swimming);
        end;
    end;
end;

local function RegisterSwimPart(p29) -- Line: 222
    -- upvalues: u1 (copy)
    if p29:IsA("BasePart") then
        u1[p29] = true;
    end;
end;

local function UnregisterSwimPart(p30) -- Line: 228
    -- upvalues: u1 (copy), u7 (ref), ExitSwim (copy)
    if not p30:IsA("BasePart") then
        return;
    end;

    u1[p30] = nil;

    if p30 == u7 then
        ExitSwim();
    end;
end;

function v11.Start(p31) -- Line: 238
    -- upvalues: CollectionService (copy), u1 (copy), RegisterSwimPart (copy), UnregisterSwimPart (copy), LocalPlayer (copy), BindCharacter (copy), UnbindCharacter (copy), RunService (copy), OnHeartbeat (copy)
    for _, v in CollectionService:GetTagged("SwimArea") do
        if v:IsA("BasePart") then
            u1[v] = true;
        end;
    end;

    CollectionService:GetInstanceAddedSignal("SwimArea"):Connect(RegisterSwimPart);
    CollectionService:GetInstanceRemovedSignal("SwimArea"):Connect(UnregisterSwimPart);

    if LocalPlayer.Character then
        BindCharacter(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(BindCharacter);
    LocalPlayer.CharacterRemoving:Connect(UnbindCharacter);
    RunService.Heartbeat:Connect(OnHeartbeat);
end;

return v11;