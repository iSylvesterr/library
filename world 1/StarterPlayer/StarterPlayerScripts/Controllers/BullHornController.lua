-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local BullHornConfig = require(ReplicatedStorage.SharedModules.BullHornConfig);
local EmitDuration = require(ReplicatedStorage.SharedModules.EmitDuration);
local NotificationController = require(script.Parent.NotificationController);
local LocalPlayer = Players.LocalPlayer;
local ATTRIBUTE = BullHornConfig.ATTRIBUTE;
local RANGE = BullHornConfig.RANGE;
local CooldownSeconds = BullHornConfig.CooldownSeconds;
local u2 = nil;
local u3 = nil;
local u4 = (-1 / 0);

function v1.Init(p5) -- Line: 29
end;

function v1.Start(u6) -- Line: 32
    -- upvalues: LocalPlayer (copy), Networking (copy), u4 (ref)
    local Character = LocalPlayer.Character;

    if Character then
        u6:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p7) -- Line: 37
        -- upvalues: u6 (copy)
        u6:SetupCharacter(p7);
    end);
    Networking.BullHorn.BlastFx.OnClientEvent:Connect(function(p8) -- Line: 41
        -- upvalues: u6 (copy)
        u6:PlayBlastFx(p8);
    end);
    Networking.Gear.CooldownsReset.OnClientEvent:Connect(function() -- Line: 47
        -- upvalues: u4 (ref)
        u4 = (-1 / 0);
    end);
end;

function v1.BindTool(u9, p10) -- Line: 55
    -- upvalues: u2 (ref), u3 (ref)
    u2 = p10;

    if u3 then
        u3:Disconnect();
    end;

    u3 = p10.Activated:Connect(function() -- Line: 60
        -- upvalues: u9 (copy)
        u9:OnActivated();
    end);
end;

function v1.UnbindTool(p11) -- Line: 65
    -- upvalues: u2 (ref), u3 (ref)
    u2 = nil;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

function v1.SetupCharacter(u12, p13) -- Line: 73
    -- upvalues: ATTRIBUTE (copy), u2 (ref)
    u12:UnbindTool();

    for _, child in p13:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute(ATTRIBUTE) then
            u12:BindTool(child);
        end;
    end;

    p13.ChildAdded:Connect(function(p14) -- Line: 82
        -- upvalues: ATTRIBUTE (ref), u12 (copy)
        if p14:IsA("Tool") and p14:GetAttribute(ATTRIBUTE) then
            u12:BindTool(p14);
        end;
    end);
    p13.ChildRemoved:Connect(function(p15) -- Line: 88
        -- upvalues: u2 (ref), u12 (copy)
        if p15 == u2 then
            u12:UnbindTool();
        end;
    end);
end;

function v1.OnActivated(p16) -- Line: 98
    -- upvalues: u2 (ref), CooldownSeconds (copy), u4 (ref), LocalPlayer (copy), Players (copy), RANGE (copy), NotificationController (copy), Networking (copy)
    local v17 = u2;

    if not v17 then
        return;
    end;

    local v18 = CooldownSeconds:Get();
    local v19 = workspace:GetServerTimeNow();

    if v19 - u4 < v18 then
        return;
    end;

    if LocalPlayer:GetAttribute("InSafeZone") then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local Position = HumanoidRootPart.Position;
    local LookVector = HumanoidRootPart.CFrame.LookVector;
    local v20 = Vector3.new(LookVector.X, 0, LookVector.Z);

    if v20.Magnitude < 0.001 then
        return;
    end;

    local Unit = v20.Unit;
    local v21 = {};

    for _, v in Players:GetPlayers() do
        if v ~= LocalPlayer then
            local Character2 = v.Character;

            if Character2 then
                Character2 = Character2:FindFirstChild("HumanoidRootPart");
            end;

            if Character2 and Character2:IsA("BasePart") then
                local v22 = Character2.Position - Position;

                if RANGE >= v22.Magnitude then
                    local v23 = Vector3.new(v22.X, 0, v22.Z);

                    if v23.Magnitude <= 0.001 or Unit:Dot(v23.Unit) >= 0 then
                        table.insert(v21, v.UserId);
                    end;
                end;
            end;
        end;
    end;

    if #v21 == 0 then
        NotificationController:CreateNotification("<font color=\"#ff5555\">Blow at players to knock them back!</font>");

        return;
    end;

    u4 = v19;
    v17:SetAttribute("CooldownEnd", os.clock() + v18);
    Networking.BullHorn.Blast:Fire(v21);
end;

function v1.PlayBlastFx(p24, p25) -- Line: 155
    -- upvalues: ATTRIBUTE (copy), EmitDuration (copy), SoundService (copy), Debris (copy)
    if not p25 then
        return;
    end;

    local Character = p25.Character;

    if not Character then
        return;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute(ATTRIBUTE) then
            EmitDuration(child);
            break;
        end;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("BullHorn");
    end;

    if SFX and SFX:IsA("Sound") then
        local v26 = SFX:Clone();
        v26.Parent = HumanoidRootPart;
        v26.Playing = true;
        Debris:AddItem(v26, v26.TimeLength + 1);
    end;
end;

return v1;