-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 6
};
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
Players.LocalPlayer:WaitForChild("PlayerGui");
local Click = SoundService.SFX.Click;
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local u2 = {};

local function GetCachedSfx(p3) -- Line: 17
    -- upvalues: u2 (copy), SoundService (copy)
    local v4 = u2[p3];

    if v4 and v4.Parent then
        return v4;
    end;

    for _, descendant in SoundService.SFX:GetDescendants() do
        if descendant:IsA("Sound") and descendant.Name == p3 then
            u2[p3] = descendant;

            return descendant;
        end;
    end;

    return nil;
end;

function v1.Init(p5) -- Line: 30
    -- upvalues: Networking (copy), GetCachedSfx (copy), SoundService (copy), TweenService (copy)
    Networking.SFX.PlaySound.OnClientEvent:Connect(function(p6) -- Line: 31
        -- upvalues: GetCachedSfx (ref), SoundService (ref)
        local v7 = GetCachedSfx(p6);

        if not v7 then
            return;
        end;

        local u8 = v7:Clone();
        u8.Name = "TemporarySFX";
        u8.Parent = SoundService;
        u8.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        u8:Play();
        u8.Ended:Once(function() -- Line: 39
            -- upvalues: u8 (copy)
            u8:Destroy();
        end);
    end);
    Networking.SFX.PlaySoundVolume.OnClientEvent:Connect(function(p9, p10) -- Line: 44
        -- upvalues: GetCachedSfx (ref), SoundService (ref)
        local v11 = GetCachedSfx(p9);

        if not v11 then
            return;
        end;

        local u12 = v11:Clone();
        u12.Name = "TemporarySFX";
        u12.Parent = SoundService;
        u12.Volume = p10;
        u12.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        u12:Play();
        u12.Ended:Once(function() -- Line: 53
            -- upvalues: u12 (copy)
            u12:Destroy();
        end);
    end);
    Networking.SFX.PlaySoundFade.OnClientEvent:Connect(function(p13, p14, u15) -- Line: 58
        -- upvalues: GetCachedSfx (ref), SoundService (ref), TweenService (ref)
        local v16 = GetCachedSfx(p13);

        if not v16 then
            return;
        end;

        local u17 = v16:Clone();
        u17.Name = "TemporarySFX";
        u17.Parent = SoundService;
        u17:Play();
        u17.Ended:Once(function() -- Line: 67
            -- upvalues: u17 (copy)
            u17:Destroy();
        end);
        task.delay(p14, function() -- Line: 71
            -- upvalues: u17 (copy), TweenService (ref), u15 (copy)
            if not u17.Parent then
                return;
            end;

            local v18 = TweenService:Create(u17, TweenInfo.new(u15, Enum.EasingStyle.Linear), {
                Volume = 0
            });
            v18.Completed:Once(function() -- Line: 75
                -- upvalues: u17 (ref)
                u17:Destroy();
            end);
            v18:Play();
        end);
    end);
    Networking.SFX.LocationSFX.OnClientEvent:Connect(function(p19, p20) -- Line: 82
        -- upvalues: GetCachedSfx (ref)
        local v21 = GetCachedSfx(p20);

        if not v21 then
            return;
        end;

        local Part = Instance.new("Part");
        Part.Size = Vector3.new(1, 1, 1);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Transparency = 1;
        Part.Position = p19;
        Part.Parent = workspace;
        local v22 = v21:Clone();
        v22.Name = "LocationSFX";
        v22.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        v22.RollOffMode = Enum.RollOffMode.InverseTapered;
        v22.RollOffMinDistance = 10;
        v22.RollOffMaxDistance = 80;
        v22.Parent = Part;
        v22:Play();
        v22.Ended:Once(function() -- Line: 105
            -- upvalues: Part (copy)
            Part:Destroy();
        end);
    end);
end;

function v1.SetupButton(u23, p24) -- Line: 111
    -- upvalues: CollectionService (copy)
    if not (p24:IsA("TextButton") or p24:IsA("ImageButton")) then
        return;
    end;

    if not CollectionService:HasTag(p24, "ClickSFX") then
        return;
    end;

    p24.MouseButton1Click:Connect(function() -- Line: 115
        -- upvalues: u23 (copy)
        u23:PlayClickSound();
    end);
end;

function v1.PlayClickSound(p25) -- Line: 120
    -- upvalues: Click (copy)
    Click.TimePosition = 0;
    Click.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    Click:Play();
end;

function v1.PlaySFX(p26, p27) -- Line: 126
    -- upvalues: GetCachedSfx (copy)
    local v28 = GetCachedSfx(p27);

    if v28 then
        v28.TimePosition = 0;
        v28.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        v28:Play();
    end;
end;

return v1;