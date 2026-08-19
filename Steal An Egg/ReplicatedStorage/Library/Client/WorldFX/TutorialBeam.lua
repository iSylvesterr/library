-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local TutorialBeam = ReplicatedStorage.Assets.Extra.TutorialBeam;
local LocalPlayer = Players.LocalPlayer;
local v1 = {};

local function createTargetAttachment(p2, p3) -- Line: 38
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "TutorialBeamTargetAttachment";

    if typeof(p2) == "Instance" and p2:IsA("BasePart") then
        Attachment.Parent = p2;

        return Attachment, nil;
    end;

    local Part = Instance.new("Part");
    Part.Name = "TutorialBeamContainer";
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Position = p2;
    Part.Parent = workspace;
    p3:Add(Part);
    Attachment.Parent = Part;

    return Attachment, Part;
end;

local function attachToPlayer(p4) -- Line: 60
    local Character = p4._player.Character;

    if not Character then
        p4._beam.Enabled = false;

        return;
    end;

    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5);

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        p4._beam.Enabled = false;

        return;
    end;

    if p4._playerAttachment then
        p4._trove:Remove(p4._playerAttachment);
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "TutorialBeamPlayerAttachment";
    Attachment.Parent = HumanoidRootPart;
    p4._playerAttachment = Attachment;
    p4._trove:Add(Attachment);
    p4._beam.Attachment0 = Attachment;
    p4._beam.Enabled = true;
end;

function v1.Create(p5, p6) -- Line: 88
    -- upvalues: Trove (copy), TutorialBeam (copy), createTargetAttachment (copy), Workspace (copy), LocalPlayer (copy), attachToPlayer (copy)
    local v7;

    if typeof(p5) == "Vector3" then
        v7 = true;
    elseif typeof(p5) == "Instance" then
        v7 = p5:IsA("BasePart");
    else
        v7 = false;
    end;

    assert(v7, "target must be BasePart or Vector3");
    local v8 = Trove.new();
    local v9;

    if p6 and p6.Template then
        v9 = p6.Template;
    else
        v9 = TutorialBeam;
    end;

    local v10 = not (p6 and p6.Name) and "TutorialBeam" or p6.Name;
    local v11, v12 = createTargetAttachment(p5, v8);
    v8:Add(v11);
    local v13 = v9:Clone();
    v13.Name = v10;
    v13.Attachment1 = v11;
    v13.FaceCamera = true;
    v13.Enabled = false;
    v13.Parent = Workspace;
    v8:Add(v13);
    local u14 = {
        _playerAttachment = nil,
        _trove = v8,
        _beam = v13,
        _targetAttachment = v11,
        _targetContainer = v12,
        _player = LocalPlayer
    };
    attachToPlayer(u14);
    v8:Connect(LocalPlayer.CharacterAdded, function(u15) -- Line: 120
        -- upvalues: attachToPlayer (ref), u14 (copy)
        task.spawn(function() -- Line: 121
            -- upvalues: u15 (copy), attachToPlayer (ref), u14 (ref)
            if u15:WaitForChild("HumanoidRootPart", 5) then
                attachToPlayer(u14);
            end;
        end);
    end);

    return u14;
end;

function v1.UpdateTarget(p16, p17) -- Line: 132
    -- upvalues: Asserts (copy), createTargetAttachment (copy)
    Asserts.table(p16);
    local v18;

    if typeof(p17) == "Vector3" then
        v18 = true;
    elseif typeof(p17) == "Instance" then
        v18 = p17:IsA("BasePart");
    else
        v18 = false;
    end;

    assert(v18, "newTarget must be BasePart or Vector3");

    if typeof(p17) == "Vector3" and p16._targetContainer ~= nil then
        p16._targetContainer.Position = p17;

        return;
    end;

    if p17 == p16._targetAttachment.Parent then
        return;
    end;

    p16._trove:Remove(p16._targetAttachment);

    if p16._targetContainer ~= nil then
        p16._trove:Remove(p16._targetContainer);
    end;

    local v19, v20 = createTargetAttachment(p17, p16._trove);
    p16._trove:Add(v19);
    p16._targetAttachment = v19;
    p16._targetContainer = v20;
    p16._beam.Attachment1 = v19;
end;

function v1.Destroy(p21) -- Line: 160
    -- upvalues: Asserts (copy)
    Asserts.table(p21);
    p21._trove:Destroy();
end;

return v1;