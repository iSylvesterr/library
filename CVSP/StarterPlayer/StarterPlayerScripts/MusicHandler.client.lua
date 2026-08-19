-- Decompiled with Potassium's decompiler.

local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Bindables = ReplicatedStorage:WaitForChild("Bindables");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local PlayMusic = Bindables:WaitForChild("PlayMusic");
local PlayAmbiance = Bindables:WaitForChild("PlayAmbiance");
local StopAudio = Bindables:WaitForChild("StopAudio");
local Sounds = ReplicatedStorage:WaitForChild("Sounds");
local Music = Sounds:WaitForChild("Music");
local Ambiance = Sounds:WaitForChild("Ambiance");
local u1 = nil;
local u2 = {};
local u3 = false;
local u4 = nil;

repeat
    task.wait();
until workspace:GetAttribute("Loaded") == true;

local v5 = Remotes.RequestSettings:InvokeServer();
local u6, u7;

if v5 == nil then
    u6 = true;
    u7 = true;
else
    u7 = v5.Music;
    u6 = v5.Ambiance;
end;

local function fadeOutAndStop(p8) -- Line: 28
    if not p8 then
        return;
    end;

    local Volume = p8.Volume;

    for i = 1, 0, -0.05 do
        if not p8.Parent then
            return;
        end;

        p8.Volume = Volume * i;
        task.wait(0.05);
    end;

    p8:Stop();
    p8:Destroy();
end;

local function fadeIn(p9, p10) -- Line: 40
    if not p9 then
        return;
    end;

    p9.Volume = 0;
    p9:Play();

    for i = 0, 1, 0.01 do
        if not p9.Parent then
            return;
        end;

        p9.Volume = p10 * i;
        task.wait(0.03);
    end;

    p9.Volume = p10;
end;

local function pickDifferentTrack(p11, p12) -- Line: 52
    local v13 = p11:GetChildren();

    if #v13 == 0 then
        return nil;
    end;

    local v14 = {};

    for _, v in ipairs(v13) do
        if v.Name ~= p12 then
            table.insert(v14, v);
        end;
    end;

    if #v14 > 0 then
        v13 = v14 or v13;
    end;

    return v13[math.random(1, #v13)];
end;

local function playLoopMusic(p15) -- Line: 65
    -- upvalues: Music (copy), u3 (ref), u4 (ref), pickDifferentTrack (copy), SoundService (copy), u1 (ref), fadeIn (copy), fadeOutAndStop (copy)
    local v16 = Music:FindFirstChild(p15);

    if not v16 then
        return;
    end;

    local v17 = nil;

    while true do
        local v18 = u3 and (u4 == p15 and pickDifferentTrack(v16, v17));

        if not v18 then
            break;
        end;

        v17 = v18.Name;
        local v19 = v18:Clone();
        v19.Looped = false;
        v19.Volume = v18.Volume or 0.5;
        v19.Parent = SoundService.BGM or SoundService;
        u1 = v19;
        fadeIn(v19, v19.Volume);

        while v19.Parent and not v19.IsLoaded do
            task.wait(0.1);
        end;

        local v20 = v19.Parent and (v19.TimeLength or 0) or 0;

        if v20 > 0 then
            while v19.Parent and (v19.IsPlaying and v19.TimePosition < v20 - 1.5) do
                task.wait(0.25);
            end;
        else
            while v19.Parent and v19.IsPlaying do
                task.wait(0.25);
            end;
        end;

        if u3 and (u4 == p15 and v19.Parent) then
            fadeOutAndStop(v19);
        end;
    end;
end;

local u21 = nil;
local u22 = nil;

local function playMusic(p23, p24) -- Line: 117
    -- upvalues: u21 (ref), u22 (ref), Music (copy), u3 (ref), u1 (ref), u4 (ref), fadeOutAndStop (copy), u7 (ref), playLoopMusic (copy)
    if u21 and not p24 then
        u22 = p23;

        return;
    end;

    if not Music:FindFirstChild(p23) then
        warn("Music folder does not exist:", p23);

        return;
    end;

    if u3 and (u1 and (u1.Parent and u4 == p23)) then
        return;
    end;

    local v25 = u1;
    u3 = false;
    u1 = nil;
    u4 = p23;

    if v25 then
        task.spawn(fadeOutAndStop, v25);
    end;

    if not u7 then
        return;
    end;

    u3 = true;
    task.spawn(playLoopMusic, p23);
end;

local function playLoopAmbiance(p26) -- Line: 157
    -- upvalues: Ambiance (copy), u2 (copy), pickDifferentTrack (copy), SoundService (copy), fadeIn (copy), fadeOutAndStop (copy)
    local v27 = Ambiance:FindFirstChild(p26);

    if not v27 then
        return;
    end;

    local v28 = nil;

    while true do
        local v29 = u2[p26] and (u2[p26].playing and pickDifferentTrack(v27, v28));

        if not v29 then
            break;
        end;

        v28 = v29.Name;
        local v30 = v29:Clone();
        v30.Looped = false;
        v30.Volume = v29.Volume or 0.5;
        v30.Parent = SoundService.BGM or SoundService;
        u2[p26].track = v30;
        fadeIn(v30, v30.Volume);

        while v30.Parent and not v30.IsLoaded do
            task.wait(0.1);
        end;

        local v31 = v30.Parent and (v30.TimeLength or 0) or 0;

        if v31 > 0 then
            while v30.Parent and (v30.IsPlaying and v30.TimePosition < v31 - 1.5) do
                task.wait(0.25);
            end;
        else
            while v30.Parent and v30.IsPlaying do
                task.wait(0.25);
            end;
        end;

        if u2[p26] and (u2[p26].playing and v30.Parent) then
            fadeOutAndStop(v30);
        end;
    end;
end;

local u32 = nil;

local function playAmbiance(p33) -- Line: 203
    -- upvalues: u32 (ref), u6 (ref), u2 (copy), fadeOutAndStop (copy), playLoopAmbiance (copy)
    u32 = p33;

    if not u6 then
        u2[p33] = {
            playing = false
        };

        return;
    end;

    if u2[p33] then
        local v34 = u2[p33];
        v34.playing = false;

        if v34.track then
            task.spawn(fadeOutAndStop, v34.track);
            v34.track = nil;
        end;

        u2[p33] = nil;
    end;

    u2[p33] = {
        playing = true
    };
    task.spawn(playLoopAmbiance, p33);
end;

local function stopAudio(p35, p36, p37) -- Line: 226
    -- upvalues: u21 (ref), u22 (ref), u3 (ref), u1 (ref), u4 (ref), fadeOutAndStop (copy), u2 (copy)
    if p35 == "Music" or p35 == "Both" then
        if u21 and not p37 then
            if not p36 then
                u22 = nil;
            end;
        else
            u3 = false;
            local v38 = u1;
            u1 = nil;

            if not p36 then
                u4 = nil;
            end;

            if v38 then
                task.spawn(fadeOutAndStop, v38);
            end;
        end;
    end;

    if p35 == "Ambiance" or p35 == "Both" then
        for i, v in pairs(u2) do
            v.playing = false;

            if v.track then
                task.spawn(fadeOutAndStop, v.track);
                v.track = nil;
            end;

            u2[i] = nil;
        end;
    end;
end;

local function stopAll() -- Line: 263
    -- upvalues: stopAudio (copy)
    stopAudio("Both");
end;

Bindables.SettingUpdated.Event:Connect(function(p39, p40) -- Line: 267
    -- upvalues: u7 (ref), u4 (ref), playMusic (copy), u21 (ref), u3 (ref), u1 (ref), fadeOutAndStop (copy), u6 (ref), u32 (ref), playAmbiance (copy), stopAudio (copy)
    if p39 == "Music" then
        u7 = p40;

        if p40 then
            if u4 then
                playMusic(u4);
            end;
        else
            if u21 then
                return;
            end;

            u3 = false;
            local v41 = u1;
            u1 = nil;

            if v41 then
                task.spawn(fadeOutAndStop, v41);
            end;
        end;
    elseif p39 == "Ambiance" then
        u6 = p40;

        if p40 then
            if u32 then
                playAmbiance(u32);
            end;
        else
            stopAudio("Ambiance");
        end;
    end;
end);
PlayMusic.Event:Connect(function(p42) -- Line: 294
    -- upvalues: playMusic (copy)
    playMusic(p42);
end);
Bindables:WaitForChild("MusicOverride").Event:Connect(function(p43) -- Line: 299
    -- upvalues: u21 (ref), u22 (ref), u4 (ref), playMusic (copy)
    if p43 then
        if not u21 then
            u22 = u4;
        end;

        u21 = p43;
        playMusic(p43, true);

        return;
    end;

    local v44 = u22 or "Default";
    u21 = nil;
    u22 = nil;
    playMusic(v44);
end);
PlayAmbiance.Event:Connect(playAmbiance);
StopAudio.Event:Connect(function(p45, p46) -- Line: 321
    -- upvalues: stopAudio (copy)
    stopAudio(p45 or "Both", p46);
end);
Remotes:WaitForChild("BossMusic").OnClientEvent:Connect(function(p47) -- Line: 326
    -- upvalues: Bindables (copy)
    if p47 then
        Bindables.MusicOverride:Fire("Boss");

        return;
    end;

    Bindables.MusicOverride:Fire(nil);
end);