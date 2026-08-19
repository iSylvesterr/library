-- Decompiled with Potassium's decompiler.

game:GetService("Debris");
game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
local RunService = game:GetService("RunService");
game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Component = require(ReplicatedStorage.Packages.Component);
local Maid = require(ReplicatedStorage.Packages.Maid);
local PetConfig = require(ReplicatedStorage.Shared.Info.PetConfig);
require(ReplicatedStorage.Client.Controllers.UI_Manager);
local PetSounds = game.SoundService:WaitForChild("SoundEffects"):WaitForChild("Greedy"):WaitForChild("PetSounds");
local v1 = Component.new({
    Tag = "DecoPet"
});
local u2 = Random.new();

function v1.Start(u3) -- Line: 27
    -- upvalues: Knit (copy), Maid (copy), PetConfig (copy), PetSounds (copy), u2 (copy), RunService (copy)
    Knit.OnStart():await();
    u3.SoundController = Knit.GetController("SoundController");
    u3._maid = Maid.new();
    local v4 = u3.Instance:GetAttribute("PetID");
    local v5 = PetConfig.GetPet(v4);

    if not v5 then
        warn("INVALID PET " .. tostring(v4));

        return;
    end;

    local idleAnim = v5.idleAnim;
    local Animator = u3.Instance:WaitForChild("AnimationController"):WaitForChild("Animator");

    local function loadAnim(p6) -- Line: 44
        -- upvalues: Animator (copy)
        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://" .. tostring(p6);
        local success, result = pcall(function() -- Line: 47
            -- upvalues: Animator (ref), Animation (copy)
            return Animator:LoadAnimation(Animation);
        end);

        return success and result and result or nil;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://" .. tostring(idleAnim);
    local success, result = pcall(function() -- Line: 47
        -- upvalues: Animator (copy), Animation (copy)
        return Animator:LoadAnimation(Animation);
    end);
    local u7 = success and result or nil;
    u7:Play();
    local u8 = PetSounds:WaitForChild(v4, 5):GetChildren();

    if u8 then
        local u9 = 0;
        local u10 = u2:NextInteger(5, 15);
        u3._maid:GiveTask(RunService.Heartbeat:Connect(function(p11) -- Line: 59
            -- upvalues: u9 (ref), u10 (ref), u2 (ref), u8 (copy), u3 (copy)
            u9 = u9 + p11;

            if u9 < u10 then
                return;
            end;

            u9 = 0;
            u10 = u2:NextInteger(5, 6);
            local v12 = u8[u2:NextInteger(1, #u8)];
            u3.SoundController:PlaySound(v12, u3.Instance.PrimaryPart, {
                RollOffMaxDistance = 40,
                RollOffMinDistance = 20
            });
        end));
    else
        warn("NO SFX FOR PET ", v4);
    end;

    u3._maid:GiveTask(function() -- Line: 72
        -- upvalues: u7 (copy)
        if u7 then
            u7:Stop();
        end;
    end);
end;

function v1.Stop(p13) -- Line: 78
    if p13._maid then
        p13._maid:Destroy();
    end;
end;

return v1;