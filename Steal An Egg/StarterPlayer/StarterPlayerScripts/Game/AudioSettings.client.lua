-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Client = ReplicatedStorage:WaitForChild("Library"):WaitForChild("Client");
local SettingsCmds = require(Client.SettingsCmds);
local Default = SoundService:WaitForChild("Default");
local DefaultReverb = SoundService:WaitForChild("DefaultReverb");
local Music = SoundService:WaitForChild("Music");
local Volume = Default.Volume;
local Volume2 = DefaultReverb.Volume;
local Volume3 = Music.Volume;

local function applySfx(p1) -- Line: 22
    -- upvalues: Default (copy), Volume (copy), DefaultReverb (copy), Volume2 (copy)
    Default.Volume = p1 and Volume or 0;
    DefaultReverb.Volume = p1 and Volume2 or 0;
end;

local function applyMusic(p2) -- Line: 27
    -- upvalues: Music (copy), Volume3 (copy)
    Music.Volume = p2 and Volume3 or 0;
end;

local function applyAll() -- Line: 31
    -- upvalues: SettingsCmds (copy), Default (copy), Volume (copy), DefaultReverb (copy), Volume2 (copy), Music (copy), Volume3 (copy)
    local v3 = SettingsCmds.IsEnabled("SFX");
    Default.Volume = v3 and Volume or 0;
    DefaultReverb.Volume = v3 and Volume2 or 0;
    Music.Volume = SettingsCmds.IsEnabled("Music") and Volume3 or 0;
end;

SettingsCmds.Changed:Connect(function(p4, p5) -- Line: 37
    -- upvalues: Default (copy), Volume (copy), DefaultReverb (copy), Volume2 (copy), Music (copy), Volume3 (copy)
    if p4 ~= "SFX" then
        if p4 == "Music" then
            Music.Volume = p5 ~= false and Volume3 or 0;
        end;

        return;
    end;

    local v6 = p5 ~= false;
    Default.Volume = v6 and Volume or 0;
    DefaultReverb.Volume = v6 and Volume2 or 0;
end);
local v7 = SettingsCmds.IsEnabled("SFX");
Default.Volume = v7 and Volume and Volume or 0;
DefaultReverb.Volume = v7 and Volume2 and Volume2 or 0;
Music.Volume = SettingsCmds.IsEnabled("Music") and Volume3 and Volume3 or 0;