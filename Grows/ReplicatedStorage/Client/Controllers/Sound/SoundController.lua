-- Decompiled with Potassium's decompiler.

game:GetService("CollectionService");
local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
game:GetService("UserInputService");
local SoundEffects = SoundService:WaitForChild("SoundEffects");
local Knit = require(ReplicatedStorage.Packages.Knit);
local SharedSfx = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Other"):WaitForChild("SharedSfx"));
require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("CustomEnum"));
local LocalPlayer = Players.LocalPlayer;
local u1 = {
    [Enum.Material.Concrete] = { "rbxassetid://127936209151021" },
    [Enum.Material.Ground] = { "rbxassetid://114120733705524" },
    [Enum.Material.Grass] = { "rbxassetid://114120733705524" },
    [Enum.Material.Metal] = { "rbxassetid://79451526328137" },
    [Enum.Material.DiamondPlate] = { "rbxassetid://79451526328137" },
    [Enum.Material.CorrodedMetal] = { "rbxassetid://79451526328137" },
    [Enum.Material.Sand] = { "rbxassetid://85348556009935" },
    [Enum.Material.Wood] = { "rbxassetid://116338614143387" },
    [Enum.Material.WoodPlanks] = { "rbxassetid://116338614143387" },
    [Enum.Material.Cardboard] = { "rbxassetid://116338614143387" },
    [Enum.Material.Mud] = { "rbxassetid://84854942818291" }
};
local v2 = Knit.CreateController({
    Name = "SoundController"
});
local u3 = nil;
local u4 = 1;
local u5 = 1.65;

function v2.PlaySound(p6, p7, p8, p9) -- Line: 66
    -- upvalues: Players (copy), SharedSfx (copy)
    return SharedSfx:PlaySFX(p7, p8 or Players.LocalPlayer, p9);
end;

function v2.PlaySoundAtPosition(p10, p11, p12, p13, p14) -- Line: 73
    -- upvalues: SoundService (copy), SoundEffects (copy), Debris (copy)
    local v15;

    if typeof(p11) == "string" then
        v15 = SoundService:FindFirstChild(p11, true);

        if not v15 then
            warn("[SoundController] Cannot find sound effect", p11);

            return;
        end;
    else
        v15 = p11;
    end;

    if v15:IsA("Folder") then
        local v16 = v15:GetChildren();

        if #v16 == 0 then
            return;
        end;

        v15 = v16[math.random(1, #v16)];
    end;

    local Part = Instance.new("Part");
    Part.Name = "SoundEmitter";
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.CFrame = CFrame.new(p12);
    Part.Parent = workspace;
    local v17 = v15:Clone();
    v17.PlayOnRemove = false;

    if not v17.SoundGroup then
        v17.SoundGroup = SoundEffects;
    end;

    if p13 then
        for i, v in p13 do
            v17[i] = v;
        end;
    end;

    v17.Parent = Part;
    v17:Play();
    Debris:AddItem(Part, p14 or math.max(5, v17.TimeLength + 0.5));

    return Part;
end;

function v2.StopSound(p18, p19, p20) -- Line: 117
    -- upvalues: Players (copy), SharedSfx (copy)
    SharedSfx:StopSFX(p19, p20 or Players.LocalPlayer);
end;

function v2.FadeOutSound(u21, u22, p23, p24) -- Line: 122
    -- upvalues: Players (copy), SharedSfx (copy), TweenService (copy)
    local u25 = p23 or Players.LocalPlayer;
    local u26 = SharedSfx:GetSoundObject(u22, u25);

    if not u26 then
        return;
    end;

    local Volume = u26.Volume;
    local v27 = TweenService:Create(u26, TweenInfo.new(p24 or 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
        Volume = 0
    });
    v27:Play();
    v27.Completed:Connect(function() -- Line: 152
        -- upvalues: u21 (copy), u22 (copy), u25 (ref), u26 (copy), Volume (copy)
        u21:StopSound(u22, u25);

        if u26.Parent then
            u26.Volume = Volume;
        end;
    end);
end;

function v2.StopSoundsFromParent(p28, p29) -- Line: 161
    -- upvalues: SharedSfx (copy)
    SharedSfx:StopSFXFromParent(p29);
end;

function v2.PlayServerSound(p30, p31, p32, p33) -- Line: 165
    p30.ServerSfxService.playServerSound:Fire(p31, p32, p33);
end;

function v2.StopServerSound(p34, p35, p36) -- Line: 169
    p34.ServerSfxService.stopServerSound:Fire(p35, p36);
end;

function v2.UpdateRunningSound(p37, p38) -- Line: 173
    -- upvalues: Players (copy), u3 (ref), u4 (ref), u5 (ref)
    if not (Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
        return;
    end;

    local Running = Players.LocalPlayer.Character.HumanoidRootPart:WaitForChild("Running");

    if not u3 then
        u3 = Running.SoundId;
    end;

    if not p38 then
        Running.SoundId = u3;
        u5 = 1.65;
        Running.PlaybackSpeed = u4 * 1.65;

        return;
    end;

    Running.SoundId = p38;
    Running.PlaybackSpeed = u4 * 0.95;
    u5 = 0.95;
    Running.Volume = 0.6;
end;

function v2.SetupFootstepSounds(u39) -- Line: 198
    -- upvalues: LocalPlayer (copy), u1 (copy)
    local function updateFootstepSound() -- Line: 199
        -- upvalues: LocalPlayer (ref), u1 (ref), u39 (copy)
        if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) then
            return;
        end;

        local FloorMaterial = LocalPlayer.Character.Humanoid.FloorMaterial;
        local v40;

        if u1[FloorMaterial] then
            local v41 = math.random(1, #u1[FloorMaterial]);
            v40 = u1[FloorMaterial][v41];
        else
            v40 = u1[Enum.Material.Concrete][1];
        end;

        u39:UpdateRunningSound(v40);
    end;

    local function onCharacterAdded(p42) -- Line: 218
        -- upvalues: updateFootstepSound (copy), LocalPlayer (ref)
        local Humanoid = p42:WaitForChild("Humanoid");
        updateFootstepSound();
        Humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(updateFootstepSound);
        Humanoid.Seated:Connect(function(p43, p44) -- Line: 228
            -- upvalues: LocalPlayer (ref)
            if not p43 then
                LocalPlayer:SetAttribute("Armoured", false);
                LocalPlayer:SetAttribute("InsideVehicle", false);

                return;
            end;

            if p44 and p44.Name == "DriverSeat" then
                LocalPlayer:SetAttribute("InsideVehicle", true);

                return;
            end;

            LocalPlayer:SetAttribute("Armoured", false);
            LocalPlayer:SetAttribute("InsideVehicle", false);
        end);
    end;

    LocalPlayer.CharacterAdded:Connect(onCharacterAdded);

    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character);
    end;
end;

function v2.UpdateReductionFactor(p45, p46) -- Line: 250
    -- upvalues: Players (copy), u4 (ref), u5 (ref)
    local Character = Players.LocalPlayer.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local Running = HumanoidRootPart:WaitForChild("Running");
    u4 = p46;
    Running.PlaybackSpeed = u5 * u4;
end;

function v2.KnitInit(p47) -- Line: 261
    -- upvalues: Knit (copy)
    p47.CharacterStatManager = Knit.GetService("CharacterStatManager");
    p47.ServerSfxService = Knit.GetService("ServerSfxService");
    p47.UserInputParser = Knit.GetController("UserInputParser");
end;

function v2.KnitStart(u48) -- Line: 268
    u48.ServerSfxService.playClientSound:Connect(function(p49, p50, p51) -- Line: 269
        -- upvalues: u48 (copy)
        u48:PlaySound(p49, p50, p51);
    end);
    u48.ServerSfxService.stopClientSound:Connect(function(p52, p53) -- Line: 273
        -- upvalues: u48 (copy)
        u48:StopSound(p52, p53);
    end);
    u48.CharacterStatManager.UpdateReductionFactor:Connect(function(p54) -- Line: 280
        -- upvalues: u48 (copy)
        u48:UpdateReductionFactor(p54);
    end);
end;

return v2;