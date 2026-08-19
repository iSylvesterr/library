-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SystemGameConfig = UtilsSystem.SystemGameConfig;

if SystemGameConfig.GetValue({ "Setting", "启用" }) == false then
    return;
end;

local SoundService = UtilsSystem.SoundService;
local SoundInstance = UtilsSystem.SoundInstance;
local AddListen = UtilsSystem.AddListen;
local LocalPlayer = UtilsSystem.LocalPlayer;
local u1 = SystemGameConfig.GetValue({ "Setting", "音量渐变秒" });
local Setting = LocalPlayer:WaitForChild("Setting", (1 / 0));
local BGM = Setting:WaitForChild("BGM", (1 / 0));
local EFFECT = Setting:WaitForChild("EFFECT", (1 / 0));
local u2 = {};

for _, child in SoundService:GetChildren() do
    if child:IsA("SoundGroup") then
        u2[child.Name] = child.Volume;
    end;
end;

local function _settingStoredToGain01(p3) -- Line: 73
    if p3 > 0 and p3 <= 1 then
        p3 = p3 * 100;
    end;

    return math.clamp(p3, 0, 100) / 100;
end;

local function _getSoundGroupBaseVolume(p4) -- Line: 86
    -- upvalues: u2 (copy)
    return u2[p4] or 1;
end;

local function _applySoundGroupGain(p5, p6) -- Line: 96
    -- upvalues: SoundInstance (copy), u2 (copy), u1 (copy)
    SoundInstance:SetSoundGroupVolume(p5, p6 * (u2[p5] or 1), u1);
end;

local function _applyEffectGroupsGain(p7) -- Line: 105
    -- upvalues: u2 (copy), SoundInstance (copy), u1 (copy)
    for i, _ in u2 do
        if i ~= "BGM" then
            SoundInstance:SetSoundGroupVolume(i, p7 * (u2[i] or 1), u1);
        end;
    end;
end;

local function _bindVolumeSetting(p8, u9) -- Line: 119
    -- upvalues: AddListen (copy)
    AddListen.NumValueAdd(p8, function(p10) -- Line: 120
        -- upvalues: u9 (copy)
        if p10 > 0 and p10 <= 1 then
            p10 = p10 * 100;
        end;

        u9(math.clamp(p10, 0, 100) / 100);
    end);
end;

local function u12(p11) -- Line: 128
    -- upvalues: SoundInstance (copy), u2 (copy), u1 (copy)
    SoundInstance:SetSoundGroupVolume("BGM", p11 * (u2.BGM or 1), u1);
end;

AddListen.NumValueAdd(BGM, function(p13) -- Line: 120
    -- upvalues: u12 (copy)
    if p13 > 0 and p13 <= 1 then
        p13 = p13 * 100;
    end;

    u12(math.clamp(p13, 0, 100) / 100);
end);

local function u15(p14) -- Line: 132
    -- upvalues: u2 (copy), SoundInstance (copy), u1 (copy)
    for i, _ in u2 do
        if i ~= "BGM" then
            SoundInstance:SetSoundGroupVolume(i, p14 * (u2[i] or 1), u1);
        end;
    end;
end;

AddListen.NumValueAdd(EFFECT, function(p16) -- Line: 120
    -- upvalues: u15 (copy)
    if p16 > 0 and p16 <= 1 then
        p16 = p16 * 100;
    end;

    u15(math.clamp(p16, 0, 100) / 100);
end);