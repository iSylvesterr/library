-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ToolSetup = require(ReplicatedStorage.Library.Util.ToolSetup);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Megaphone = require(ReplicatedStorage.Directory.Gears._Index.Other.Megaphone);
local Megaphone2 = Constants.NETWORK_MAP.Megaphone;
local COOLDOWN = Megaphone.COOLDOWN;
local u2 = false;
local u3 = {};

local function _stopVFX(p4) -- Line: 69
    -- upvalues: u3 (copy)
    if not p4 then
        return;
    end;

    local v5 = u3[p4];

    if v5 and v5.Parent then
        v5:Destroy();
        u3[p4] = nil;
    end;
end;

local function startEffectWindow() -- Line: 81
    -- upvalues: u2 (ref)
    if u2 then
        return;
    end;

    u2 = true;
end;

local function stopEffectWindow() -- Line: 89
    -- upvalues: u2 (ref)
    if not u2 then
        return;
    end;

    u2 = false;
end;

local u7 = ToolSetup.Initialize(Megaphone.DisplayName, {
    onActivated = function(p6) -- Line: 97, Name: onActivated
        -- upvalues: u2 (ref), Network (copy), Megaphone2 (copy)
        if u2 then
            return;
        end;

        Network.Fire(Megaphone2.REQUEST_ACTIVATE);
    end,

    onUnequipped = function() -- Line: 105, Name: onUnequipped
        -- upvalues: u2 (ref)
        if not u2 then
            return;
        end;

        u2 = false;
    end
});
Network.Fired(Megaphone2.PLAY_VFX):Connect(function(u8, p9) -- Line: 26, Name: playVFX
    -- upvalues: Asserts (copy), u1 (copy), u3 (copy), Megaphone (copy)
    Asserts.Model(u8);
    local u10 = p9:FindFirstChildWhichIsA("ParticleEmitter", true);

    if not u10 then
        u1:AtWarning():Log((`[Megaphone] No VFX found for {u8.Name}`));

        return;
    end;

    u10.Enabled = true;
    u3[u8] = u10;
    task.delay(Megaphone.EFFECT_DURATION, function() -- Line: 39
        -- upvalues: u3 (ref), u8 (copy), u10 (copy)
        if u3[u8] == u10 then
            u3[u8] = nil;

            if u10.Parent then
                u10.Enabled = false;
            end;
        end;
    end);
end);
Network.Fired(Megaphone2.PLAY_SFX):Connect(function(p11) -- Line: 49, Name: playSFX
    -- upvalues: Asserts (copy), Megaphone (copy)
    Asserts.Model(p11);

    if Megaphone.SFX_ID ~= "rbxassetid://0" then
        local v12 = p11.PrimaryPart or p11:FindFirstChild("HumanoidRootPart");

        if v12 and v12:IsA("BasePart") then
            local Sound = Instance.new("Sound");
            Sound.SoundId = Megaphone.SFX_ID;
            Sound.Parent = v12;
            Sound:Play();
            task.delay(5, function() -- Line: 60
                -- upvalues: Sound (copy)
                if Sound.Parent then
                    Sound:Destroy();
                end;
            end);
        end;
    end;
end);
Network.Fired(Megaphone2.START_EFFECT_WINDOW):Connect(function() -- Line: 119
    -- upvalues: u2 (ref), ToolSetup (copy), u7 (ref), COOLDOWN (copy)
    if not u2 then
        u2 = true;
    end;

    ToolSetup.StartCooldown(u7, COOLDOWN);
end);
Network.Fired(Megaphone2.STOP_EFFECT_WINDOW):Connect(stopEffectWindow);