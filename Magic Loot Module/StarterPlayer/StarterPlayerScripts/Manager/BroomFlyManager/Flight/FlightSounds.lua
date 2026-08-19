-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundInstance = UtilsSystem.SoundInstance;
local SoundModule = UtilsSystem.SoundModule;
require(script.Parent.GroundSkimVfx);
local u1 = {
    fadeSec = 0.15,
    soundNames = {
        flight = "普通飞行音效",
        waterSkim = "水面低空表现音效",
        groundSkim = "地面低空表现音效"
    },
    flightVolumeRange = {
        volumeAtMinSpeed = 0,
        volumeAtMaxSpeed = 1
    }
};
local u2 = {};
u2.__index = u2;

local function volumeForSpeed(p3, p4, p5) -- Line: 68
    if p4 <= 0 then
        return p5.volumeAtMinSpeed;
    end;

    local v6 = math.clamp(p3 / p4, 0, 1);

    return p5.volumeAtMinSpeed + v6 * (p5.volumeAtMaxSpeed - p5.volumeAtMinSpeed);
end;

local function fadeInLoop(p7, p8) -- Line: 80
    -- upvalues: TweenService (copy)
    if not p7 then
        return;
    end;

    p7.sound.Volume = 0;

    if not p7.sound.IsPlaying then
        p7.sound:Play();
    end;

    TweenService:Create(p7.sound, TweenInfo.new(p8), {
        Volume = p7.oriVolume
    }):Play();
end;

local function startLoop(p9, p10, p11) -- Line: 91
    -- upvalues: SoundInstance (copy), fadeInLoop (copy)
    local v12 = SoundInstance:GetSoundByTag(p10);

    if not v12 then
        v12 = SoundInstance:new({
            Is2D = true,
            Looped = true,
            SoundName = p9,
            SoundTag = p10
        });

        if v12 and v12.sound then
            v12.sound.Looped = true;
        end;
    end;

    if v12 then
        fadeInLoop(v12, p11);
    end;

    return v12;
end;

local function stopLoop(p13, p14, p15) -- Line: 111
    -- upvalues: SoundModule (copy)
    SoundModule:StopSoundLocal({
        SoundName = p13,
        SoundTag = p14,
        FadeTime = p15
    });
end;

local function setLoopVolume(p16, p17) -- Line: 119
    if not p16 then
        return;
    end;

    p16.sound.Volume = p16.oriVolume * p17;
end;

function u2.new(p18) -- Line: 126
    -- upvalues: u1 (copy), u2 (copy), startLoop (copy), SoundInstance (copy)
    local v19 = p18 or u1;
    local v20 = setmetatable({
        _skimSoundState = "Off",
        _config = v19
    }, u2);
    startLoop(v19.soundNames.flight, "BroomFly_FlightLoop", v19.fadeSec);
    local v21 = SoundInstance:GetSoundByTag("BroomFly_FlightLoop");
    local flightVolumeRange = v19.flightVolumeRange;

    if not v21 then
        return v20;
    end;

    v21.sound.Volume = v21.oriVolume * (flightVolumeRange.volumeAtMinSpeed + (flightVolumeRange.volumeAtMaxSpeed - flightVolumeRange.volumeAtMinSpeed) * 0);

    return v20;
end;

function u2.Update(p22, p23, p24, p25) -- Line: 142
    -- upvalues: SoundInstance (copy), SoundModule (copy), startLoop (copy)
    local _config = p22._config;
    local soundNames = _config.soundNames;
    local fadeSec = _config.fadeSec;
    local v26 = SoundInstance:GetSoundByTag("BroomFly_FlightLoop");
    local flightVolumeRange = _config.flightVolumeRange;
    local v27;

    if p24 <= 0 then
        v27 = flightVolumeRange.volumeAtMinSpeed;
    else
        local v28 = math.clamp(p23 / p24, 0, 1);
        v27 = flightVolumeRange.volumeAtMinSpeed + v28 * (flightVolumeRange.volumeAtMaxSpeed - flightVolumeRange.volumeAtMinSpeed);
    end;

    if v26 then
        v26.sound.Volume = v26.oriVolume * v27;
    end;

    if p25 == p22._skimSoundState then
        return;
    end;

    local _skimSoundState = p22._skimSoundState;
    p22._skimSoundState = p25;

    if _skimSoundState == "Water" then
        SoundModule:StopSoundLocal({
            SoundTag = "BroomFly_WaterSkimLoop",
            SoundName = soundNames.waterSkim,
            FadeTime = fadeSec
        });
    elseif _skimSoundState == "Solid" then
        SoundModule:StopSoundLocal({
            SoundTag = "BroomFly_GroundSkimLoop",
            SoundName = soundNames.groundSkim,
            FadeTime = fadeSec
        });
    end;

    if p25 == "Water" then
        startLoop(soundNames.waterSkim, "BroomFly_WaterSkimLoop", fadeSec);

        return;
    end;

    if p25 == "Solid" then
        startLoop(soundNames.groundSkim, "BroomFly_GroundSkimLoop", fadeSec);
    end;
end;

function u2.Stop(p29) -- Line: 177
    -- upvalues: SoundModule (copy)
    local _config = p29._config;
    local soundNames = _config.soundNames;
    local fadeSec = _config.fadeSec;
    SoundModule:StopSoundLocal({
        SoundTag = "BroomFly_FlightLoop",
        SoundName = soundNames.flight,
        FadeTime = fadeSec
    });
    SoundModule:StopSoundLocal({
        SoundTag = "BroomFly_WaterSkimLoop",
        SoundName = soundNames.waterSkim,
        FadeTime = fadeSec
    });
    SoundModule:StopSoundLocal({
        SoundTag = "BroomFly_GroundSkimLoop",
        SoundName = soundNames.groundSkim,
        FadeTime = fadeSec
    });
    p29._skimSoundState = "Off";
end;

return u2;