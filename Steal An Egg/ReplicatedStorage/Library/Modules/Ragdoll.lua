-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1;

if RunService:IsServer() then
    u1 = require(ServerScriptService.Library.Modules.ClientCharacterAction);
else
    u1 = nil;
end;

local u2 = {};
local u3 = 0;
local u4 = {
    ClientRagdollRemote = script.Ragdoll
};

local function clearRagdollAttachments(p5, p6) -- Line: 39
    if not p5 then
        return;
    end;

    for _, child in p5:GetChildren() do
        if child.ClassName == "Attachment" then
            local v7 = child:GetAttribute("RagdollAttachment");

            if v7 and (not p6 or v7 == p6) then
                child:Destroy();
            end;
        end;
    end;
end;

local function clearRagdollConstraints(p8, p9) -- Line: 56
    if not p8 then
        return;
    end;

    for _, child in p8:GetChildren() do
        local v10 = child:GetAttribute("RagdollConstraint");

        if v10 and (not p9 or v10 == p9) and (child.ClassName == "BallSocketConstraint" or child.ClassName == "HingeConstraint") then
            child:Destroy();
        end;
    end;
end;

local function applyServerRagdollState(p11, p12) -- Line: 71
    local RootPart = p11.RootPart;

    if not RootPart then
        return;
    end;

    p11:ChangeState(Enum.HumanoidStateType.Physics);

    if p12 and typeof(p12) == "Vector3" then
        RootPart:ApplyImpulse(p12);
    end;
end;

local function clearServerRagdollState(p13) -- Line: 85
    local RootPart = p13.RootPart;

    if not RootPart then
        return;
    end;

    p13:ChangeState(Enum.HumanoidStateType.GettingUp);
    RootPart.CanCollide = true;
end;

local function createConstraintFromMotor6D(p14) -- Line: 95
    -- upvalues: clearRagdollConstraints (copy), clearRagdollAttachments (copy)
    local Part0 = p14.Part0;
    local Part1 = p14.Part1;

    if not (Part0 and Part1) then
        return nil;
    end;

    clearRagdollConstraints(p14.Parent, p14.Name);
    clearRagdollAttachments(Part0, p14.Name);
    clearRagdollAttachments(Part1, p14.Name);
    local BallSocketConstraint = Instance.new("BallSocketConstraint");
    local Attachment = Instance.new("Attachment");
    local Attachment2 = Instance.new("Attachment");
    Attachment.Name = "RagdollAttachment_" .. p14.Name .. "_A";
    Attachment2.Name = "RagdollAttachment_" .. p14.Name .. "_B";
    Attachment:SetAttribute("RagdollAttachment", p14.Name);
    Attachment2:SetAttribute("RagdollAttachment", p14.Name);
    Attachment.Parent = Part0;
    Attachment2.Parent = Part1;
    BallSocketConstraint.Name = "RagdollConstraint_" .. p14.Name;
    BallSocketConstraint:SetAttribute("RagdollConstraint", p14.Name);
    BallSocketConstraint.Parent = p14.Parent;
    BallSocketConstraint.Attachment0 = Attachment;
    BallSocketConstraint.Attachment1 = Attachment2;
    Attachment.CFrame = p14.C0;
    Attachment2.CFrame = p14.C1;
    BallSocketConstraint.LimitsEnabled = true;
    BallSocketConstraint.TwistLimitsEnabled = true;

    if p14.Name ~= "Root" and p14.Name ~= "Neck" then
        return BallSocketConstraint;
    end;

    BallSocketConstraint:Destroy();
    local HingeConstraint = Instance.new("HingeConstraint");
    HingeConstraint.Name = "RagdollConstraint_" .. p14.Name;
    HingeConstraint:SetAttribute("RagdollConstraint", p14.Name);
    HingeConstraint.Parent = p14.Parent;
    HingeConstraint.Attachment0 = Attachment;
    HingeConstraint.Attachment1 = Attachment2;
    HingeConstraint.LimitsEnabled = true;

    return HingeConstraint;
end;

local function destroyRagdollConstraints(p15) -- Line: 142
    -- upvalues: clearRagdollConstraints (copy), clearRagdollAttachments (copy)
    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("Motor6D") then
            local Parent = descendant.Parent;

            if Parent then
                clearRagdollConstraints(Parent, descendant.Name);
                clearRagdollAttachments(descendant.Part0, descendant.Name);
                clearRagdollAttachments(descendant.Part1, descendant.Name);
                descendant.Enabled = true;
            end;
        end;
    end;
end;

local function createRagdollConstraints(p16) -- Line: 159
    -- upvalues: createConstraintFromMotor6D (copy)
    for _, descendant in p16:GetDescendants() do
        if descendant:IsA("Motor6D") then
            createConstraintFromMotor6D(descendant);
            descendant.Enabled = false;
        end;
    end;
end;

function u4.IsRagdolled(p17) -- Line: 172
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.Model(p17);

    if u2[p17] ~= nil then
        return true;
    end;

    local v18 = p17:FindFirstChildOfClass("Humanoid");
    local v19;

    if v18 == nil then
        v19 = false;
    else
        v19 = v18:GetState() == Enum.HumanoidStateType.Physics;
    end;

    return v19;
end;

function u4.Ragdoll(p20) -- Line: 182
    -- upvalues: Players (copy), u1 (copy), createRagdollConstraints (copy)
    local Humanoid = p20:WaitForChild("Humanoid");

    if Humanoid:GetState() == Enum.HumanoidStateType.Physics then
        return;
    end;

    Humanoid.BreakJointsOnDeath = false;
    local v21 = Players:GetPlayerFromCharacter(p20);

    if v21 == nil then
        if Humanoid.RootPart then
            Humanoid:ChangeState(Enum.HumanoidStateType.Physics);
        end;
    else
        assert(u1, "ClientCharacterAction must exist on the server").BeginRagdoll(v21, p20, 5, nil);
    end;

    createRagdollConstraints(p20);
end;

function u4.NpcRagdoll(p22, p23) -- Line: 202
    -- upvalues: createRagdollConstraints (copy), destroyRagdollConstraints (copy)
    local Humanoid = p22:FindFirstChild("Humanoid");

    if not Humanoid then
        return;
    end;

    Humanoid.BreakJointsOnDeath = false;

    if Humanoid:GetState() == Enum.HumanoidStateType.Physics then
        return;
    end;

    Humanoid.PlatformStand = true;
    Humanoid:ChangeState(Enum.HumanoidStateType.Physics);
    createRagdollConstraints(p22);
    task.wait(p23);

    if not (p22 and p22.Parent) then
        return;
    end;

    Humanoid.PlatformStand = false;
    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
    destroyRagdollConstraints(p22);
end;

function u4.TimedRagdoll(p24, p25, p26) -- Line: 230
    -- upvalues: u2 (copy), u3 (ref), Players (copy), createRagdollConstraints (copy), u1 (copy), destroyRagdollConstraints (copy)
    local Humanoid = p24:WaitForChild("Humanoid");
    Humanoid.BreakJointsOnDeath = false;
    local v27 = Humanoid:GetState() == Enum.HumanoidStateType.Physics;
    local v28 = u2[p24];
    u3 = u3 + 1;
    local v29 = u3;
    local v30;

    if v28 then
        v30 = v28.OwnsConstraints;
    else
        v30 = not v27;
    end;

    u2[p24] = {
        Token = v29,
        OwnsConstraints = v30
    };
    local v31 = Players:GetPlayerFromCharacter(p24);

    if v28 == nil and not v27 then
        createRagdollConstraints(p24);
    end;

    if v31 == nil then
        local RootPart = Humanoid.RootPart;

        if RootPart then
            Humanoid:ChangeState(Enum.HumanoidStateType.Physics);

            if p26 and typeof(p26) == "Vector3" then
                RootPart:ApplyImpulse(p26);
            end;
        end;
    else
        assert(u1, "ClientCharacterAction must exist on the server").BeginRagdoll(v31, p24, p25, p26);
    end;

    task.wait(p25);
    local v32 = u2[p24];

    if not v32 or v32.Token ~= v29 then
        return;
    end;

    u2[p24] = nil;
    local v33 = Players:GetPlayerFromCharacter(p24);

    if v33 == nil then
        local RootPart = Humanoid.RootPart;

        if RootPart then
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
            RootPart.CanCollide = true;
        end;
    else
        assert(u1, "ClientCharacterAction must exist on the server").EndRagdoll(v33, p24);
    end;

    if v32.OwnsConstraints then
        destroyRagdollConstraints(p24);
    end;
end;

function u4.TimedRagdollAsync(p34, p35, p36) -- Line: 278
    -- upvalues: u4 (copy)
    task.spawn(u4.TimedRagdoll, p34, p35, p36);
end;

function u4.ApplyClientRagdoll(p37, p38) -- Line: 282
    -- upvalues: createRagdollConstraints (copy)
    local v39 = p37:FindFirstChildOfClass("Humanoid");
    local v40 = `Character {p37:GetFullName()} is missing Humanoid`;
    assert(v39 ~= nil, v40);
    v39.BreakJointsOnDeath = false;
    local v41 = v39:GetState() == Enum.HumanoidStateType.Physics;
    local RootPart = v39.RootPart;

    if RootPart then
        v39:ChangeState(Enum.HumanoidStateType.Physics);

        if p38 and typeof(p38) == "Vector3" then
            RootPart:ApplyImpulse(p38);
        end;
    end;

    if not v41 then
        createRagdollConstraints(p37);
    end;
end;

function u4.ClearClientRagdoll(p42) -- Line: 295
    -- upvalues: destroyRagdollConstraints (copy)
    local v43 = p42:FindFirstChildOfClass("Humanoid");
    local v44 = `Character {p42:GetFullName()} is missing Humanoid`;
    assert(v43 ~= nil, v44);
    local RootPart = v43.RootPart;

    if RootPart then
        v43:ChangeState(Enum.HumanoidStateType.GettingUp);
        RootPart.CanCollide = true;
    end;

    destroyRagdollConstraints(p42);
end;

function u4.Unragdoll(p45) -- Line: 302
    -- upvalues: Players (copy), u1 (copy), destroyRagdollConstraints (copy)
    local v46 = Players:GetPlayerFromCharacter(p45);

    if v46 == nil then
        local v47 = p45:FindFirstChildOfClass("Humanoid");
        local v48 = v47 ~= nil and v47.RootPart;

        if v48 then
            v47:ChangeState(Enum.HumanoidStateType.GettingUp);
            v48.CanCollide = true;
        end;
    else
        assert(u1, "ClientCharacterAction must exist on the server").EndRagdoll(v46, p45);
    end;

    destroyRagdollConstraints(p45);
end;

return u4;