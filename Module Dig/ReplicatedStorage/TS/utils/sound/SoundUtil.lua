-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local SFX = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "SFX").SFX;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local SoundService = v1.SoundService;
local u2 = {
    looped = false,
    volume = 1,
    playbackSpeed = 1,
    enabled = true,
    cleanupDelay = 10,
    parent = SoundService
};
local u3 = {};
local u4 = {};
local u5 = 0;
local u6 = 0;

local function takeFromPool(p7, p8) -- Line: 22
    local v9 = p7[p8];

    if v9 == nil then
        return nil;
    end;

    local v10 = #v9;
    local v11 = v9[v10];
    v9[v10] = nil;

    if #v9 == 0 then
        p7[p8] = nil;
    end;

    return v11;
end;

local function addToPool(p12, p13, p14) -- Line: 42
    local v15 = p12[p13];

    if v15 then
        table.insert(v15, p14);

        return;
    end;

    p12[p13] = { p14 };
end;

local function assignAsset(p16, p17) -- Line: 56
    if p16.asset == p17 then
        return nil;
    end;

    p16.asset = p17;
    p16.player.Asset = p17;
end;

local function playWhenReady(u18) -- Line: 63
    if u18.IsReady then
        u18:Play();

        return nil;
    end;

    local u19 = nil;
    u19 = u18:GetPropertyChangedSignal("IsReady"):Connect(function() -- Line: 69
        -- upvalues: u18 (copy), u19 (ref)
        if not u18.IsReady then
            return nil;
        end;

        u19:Disconnect();
        u18:Play();
    end);
end;

local function startPooledPlayback(u20) -- Line: 77
    local readyConnection = u20.readyConnection;

    if readyConnection ~= nil then
        readyConnection:Disconnect();
    end;

    u20.readyConnection = nil;
    local player = u20.player;
    player:Stop();
    player.TimePosition = 0;

    if player.IsReady then
        player:Play();

        return nil;
    end;

    local generation = u20.generation;
    u20.readyConnection = player:GetPropertyChangedSignal("IsReady"):Connect(function() -- Line: 92
        -- upvalues: player (copy), u20 (copy), generation (copy)
        if not player.IsReady then
            return nil;
        end;

        local readyConnection2 = u20.readyConnection;

        if readyConnection2 ~= nil then
            readyConnection2:Disconnect();
        end;

        u20.readyConnection = nil;

        if u20.generation ~= generation then
            return nil;
        end;

        player.TimePosition = 0;
        player:Play();
    end);
end;

local u21 = nil;

local function buildUiSoundBundle() -- Line: 109
    -- upvalues: u21 (ref)
    local AudioPlayer = Instance.new("AudioPlayer");
    local AudioDeviceOutput = Instance.new("AudioDeviceOutput", AudioPlayer);
    local Wire = Instance.new("Wire", AudioPlayer);
    Wire.SourceInstance = AudioPlayer;
    Wire.TargetInstance = AudioDeviceOutput;
    local u22 = {
        asset = "",
        generation = 0,
        active = false,
        player = AudioPlayer,
        output = AudioDeviceOutput
    };
    AudioPlayer.Ended:Connect(function() -- Line: 122
        -- upvalues: u21 (ref), u22 (copy)
        return u21(u22);
    end);

    return u22;
end;

local function destroyUiSoundBundle(p23) -- Line: 127
    local readyConnection = p23.readyConnection;

    if readyConnection ~= nil then
        readyConnection:Disconnect();
    end;

    p23.readyConnection = nil;
    p23.output:Destroy();
    p23.player:Destroy();
end;

u21 = function(u24) -- Line: 136, Name: releaseUiSoundBundle
    -- upvalues: SoundService (copy), u5 (ref), u3 (copy)
    if not u24.active then
        return nil;
    end;

    u24.active = false;
    u24.generation = u24.generation + 1;
    local readyConnection = u24.readyConnection;

    if readyConnection ~= nil then
        readyConnection:Disconnect();
    end;

    u24.readyConnection = nil;

    if not pcall(function() -- Line: 147
        -- upvalues: u24 (copy), SoundService (ref)
        u24.player:Stop();
        u24.player.TimePosition = 0;
        u24.player.Parent = SoundService;
    end) or u5 >= 32 then
        local readyConnection2 = u24.readyConnection;

        if readyConnection2 ~= nil then
            readyConnection2:Disconnect();
        end;

        u24.readyConnection = nil;
        u24.output:Destroy();
        u24.player:Destroy();

        return nil;
    end;

    local v25 = u3;
    local asset = u24.asset;
    local v26 = v25[asset];

    if v26 then
        table.insert(v26, u24);
    else
        v25[asset] = { u24 };
    end;

    u5 = u5 + 1;
end;

local function playSound(p27, p28) -- Line: 159
    -- upvalues: u2 (copy), SFX (copy), u3 (copy), u5 (ref), buildUiSoundBundle (copy), startPooledPlayback (copy), u21 (ref)
    local v29 = p28 == nil and {} or p28;
    local u30 = table.clone(u2);
    setmetatable(u30, nil);

    for i, v in v29 do
        u30[i] = v;
    end;

    local u31 = SFX[p27];

    if not u30.looped then
        local v32 = u3;
        local v33 = v32[u31];
        local v34;

        if v33 == nil then
            v34 = nil;
        else
            local v35 = #v33;
            v34 = v33[v35];
            v33[v35] = nil;

            if #v33 == 0 then
                v32[u31] = nil;
            end;
        end;

        if v34 then
            u5 = u5 - 1;
        end;

        local u36 = v34 or buildUiSoundBundle();

        if not pcall(function(p37) -- Line: 188
            -- upvalues: u31 (copy), u30 (copy)
            local v38 = u31;

            if p37.asset ~= v38 then
                p37.asset = v38;
                p37.player.Asset = v38;
            end;

            p37.player.Volume = u30.volume;
            p37.player.Looping = false;
            p37.player.PlaybackSpeed = u30.playbackSpeed;
            p37.player.Parent = u30.parent;
        end, u36) then
            local v39 = u36;
            local readyConnection = v39.readyConnection;

            if readyConnection ~= nil then
                readyConnection:Disconnect();
            end;

            v39.readyConnection = nil;
            v39.output:Destroy();
            v39.player:Destroy();
            u36 = buildUiSoundBundle();
            local v40 = u36;

            if v40.asset ~= u31 then
                v40.asset = u31;
                v40.player.Asset = u31;
            end;

            v40.player.Volume = u30.volume;
            v40.player.Looping = false;
            v40.player.PlaybackSpeed = u30.playbackSpeed;
            v40.player.Parent = u30.parent;
        end;

        u36.active = true;
        local generation = u36.generation;
        startPooledPlayback(u36);
        task.delay(u30.cleanupDelay, function() -- Line: 204
            -- upvalues: u36 (ref), generation (copy), u21 (ref)
            if u36.generation == generation then
                u21(u36);
            end;
        end);

        return u36.player;
    end;

    local AudioPlayer = Instance.new("AudioPlayer", u30.parent);
    AudioPlayer.Asset = u31;
    AudioPlayer.Volume = u30.volume;
    AudioPlayer.Looping = true;
    AudioPlayer.PlaybackSpeed = u30.playbackSpeed;
    local AudioDeviceOutput = Instance.new("AudioDeviceOutput", AudioPlayer);
    local Wire = Instance.new("Wire", AudioPlayer);
    Wire.SourceInstance = AudioPlayer;
    Wire.TargetInstance = AudioDeviceOutput;

    if AudioPlayer.IsReady then
        AudioPlayer:Play();

        return AudioPlayer;
    end;

    local u41 = nil;
    u41 = AudioPlayer:GetPropertyChangedSignal("IsReady"):Connect(function() -- Line: 69
        -- upvalues: AudioPlayer (copy), u41 (ref)
        if not AudioPlayer.IsReady then
            return nil;
        end;

        u41:Disconnect();
        AudioPlayer:Play();
    end);

    return AudioPlayer;
end;

local u42 = nil;

local function buildWorldSoundBundle() -- Line: 212
    -- upvalues: CollectionService (copy), u42 (ref)
    local AudioPlayer = Instance.new("AudioPlayer");
    local AudioEmitter = Instance.new("AudioEmitter");
    CollectionService:AddTag(AudioEmitter, "NoiseSource");
    local AudioAnalyzer = Instance.new("AudioAnalyzer");
    local Wire = Instance.new("Wire");
    Wire.Parent = AudioPlayer;
    Wire.SourceInstance = AudioPlayer;
    Wire.TargetInstance = AudioEmitter;
    local Wire2 = Instance.new("Wire");
    Wire2.Parent = AudioPlayer;
    Wire2.SourceInstance = AudioPlayer;
    Wire2.TargetInstance = AudioAnalyzer;
    local u43 = {
        asset = "",
        generation = 0,
        active = false,
        player = AudioPlayer,
        emitter = AudioEmitter,
        analyzer = AudioAnalyzer
    };
    AudioPlayer.Ended:Connect(function() -- Line: 233
        -- upvalues: u42 (ref), u43 (copy)
        return u42(u43);
    end);

    return u43;
end;

local function destroyWorldSoundBundle(p44) -- Line: 238
    local readyConnection = p44.readyConnection;

    if readyConnection ~= nil then
        readyConnection:Disconnect();
    end;

    p44.readyConnection = nil;
    p44.player:Destroy();
    p44.emitter:Destroy();
    p44.analyzer:Destroy();
end;

u42 = function(u45) -- Line: 248, Name: releaseWorldSoundBundle
    -- upvalues: SoundService (copy), u6 (ref), u4 (copy)
    if not u45.active then
        return nil;
    end;

    u45.active = false;
    u45.generation = u45.generation + 1;
    local readyConnection = u45.readyConnection;

    if readyConnection ~= nil then
        readyConnection:Disconnect();
    end;

    u45.readyConnection = nil;

    if not pcall(function() -- Line: 259
        -- upvalues: u45 (copy), SoundService (ref)
        u45.player:Stop();
        u45.player.TimePosition = 0;
        u45.player.Parent = SoundService;
        u45.emitter.Parent = SoundService;
        u45.analyzer.Parent = SoundService;
    end) or u6 >= 48 then
        local readyConnection2 = u45.readyConnection;

        if readyConnection2 ~= nil then
            readyConnection2:Disconnect();
        end;

        u45.readyConnection = nil;
        u45.player:Destroy();
        u45.emitter:Destroy();
        u45.analyzer:Destroy();

        return nil;
    end;

    local v46 = u4;
    local asset = u45.asset;
    local v47 = v46[asset];

    if v47 then
        table.insert(v47, u45);
    else
        v46[asset] = { u45 };
    end;

    u6 = u6 + 1;
end;

return {
    playSound = playSound,

    prewarmWorldSounds = function(p48) -- Line: 273, Name: prewarmWorldSounds
        -- upvalues: SFX (copy), u4 (copy), u6 (ref), buildWorldSoundBundle (copy), SoundService (copy)
        for _, v in p48 do
            local v49 = SFX[v];
            local v50 = u4[v49];
            local v51 = v50 ~= nil and #v50 or v50;
            local v52 = v51 == nil and 0 or v51;

            while v52 < 2 and u6 < 48 do
                local v53 = buildWorldSoundBundle();

                if v53.asset ~= v49 then
                    v53.asset = v49;
                    v53.player.Asset = v49;
                end;

                v53.player.Parent = SoundService;
                v53.emitter.Parent = SoundService;
                v53.analyzer.Parent = SoundService;
                local v54 = u4;
                local v55 = v54[v49];

                if v55 then
                    table.insert(v55, v53);
                else
                    v54[v49] = { v53 };
                end;

                u6 = u6 + 1;
                v52 = v52 + 1;
            end;
        end;
    end,

    playWorldSound = function(u56, p57) -- Line: 297, Name: playWorldSound
        -- upvalues: u2 (copy), SFX (copy), buildWorldSoundBundle (copy), u4 (copy), u6 (ref), startPooledPlayback (copy), u42 (ref)
        local v58 = p57 == nil and {} or p57;
        local u59 = table.clone(u2);
        setmetatable(u59, nil);

        for i, v in v58 do
            u59[i] = v;
        end;

        if SFX[u56] then
            u56 = SFX[u56];
        end;

        if u59.looped then
            local v60 = buildWorldSoundBundle();

            if v60.asset ~= u56 then
                v60.asset = u56;
                v60.player.Asset = u56;
            end;

            v60.player.Volume = not u59.enabled and 0 or u59.volume;
            v60.player.Looping = true;
            v60.player.PlaybackSpeed = u59.playbackSpeed;
            v60.player.Parent = u59.parent;
            v60.emitter.Parent = u59.parent;
            v60.analyzer.Parent = u59.parent;
            local player = v60.player;

            if player.IsReady then
                player:Play();
            else
                local u61 = nil;
                u61 = player:GetPropertyChangedSignal("IsReady"):Connect(function() -- Line: 69
                    -- upvalues: player (copy), u61 (ref)
                    if not player.IsReady then
                        return nil;
                    end;

                    u61:Disconnect();
                    player:Play();
                end);
            end;

            return {
                player = v60.player,
                emitter = v60.emitter,
                analyzer = v60.analyzer
            };
        end;

        local v62 = u4;
        local v63 = v62[u56];
        local v64;

        if v63 == nil then
            v64 = nil;
        else
            local v65 = #v63;
            v64 = v63[v65];
            v63[v65] = nil;

            if #v63 == 0 then
                v62[u56] = nil;
            end;
        end;

        if v64 then
            u6 = u6 - 1;
        end;

        local u66 = v64 or buildWorldSoundBundle();

        if not pcall(function(p67) -- Line: 329
            -- upvalues: u56 (copy), u59 (copy)
            local v68 = u56;

            if p67.asset ~= v68 then
                p67.asset = v68;
                p67.player.Asset = v68;
            end;

            p67.player.Volume = not u59.enabled and 0 or u59.volume;
            p67.player.Looping = false;
            p67.player.PlaybackSpeed = u59.playbackSpeed;
            p67.player.Parent = u59.parent;
            p67.emitter.Parent = u59.parent;
            p67.analyzer.Parent = u59.parent;
        end, u66) then
            local v69 = u66;
            local readyConnection = v69.readyConnection;

            if readyConnection ~= nil then
                readyConnection:Disconnect();
            end;

            v69.readyConnection = nil;
            v69.player:Destroy();
            v69.emitter:Destroy();
            v69.analyzer:Destroy();
            u66 = buildWorldSoundBundle();
            local v70 = u66;

            if v70.asset ~= u56 then
                v70.asset = u56;
                v70.player.Asset = u56;
            end;

            v70.player.Volume = not u59.enabled and 0 or u59.volume;
            v70.player.Looping = false;
            v70.player.PlaybackSpeed = u59.playbackSpeed;
            v70.player.Parent = u59.parent;
            v70.emitter.Parent = u59.parent;
            v70.analyzer.Parent = u59.parent;
        end;

        u66.active = true;
        local generation = u66.generation;
        startPooledPlayback(u66);
        task.delay(u59.cleanupDelay, function() -- Line: 347
            -- upvalues: u66 (ref), generation (copy), u42 (ref)
            if u66.generation == generation then
                u42(u66);
            end;
        end);

        return {
            player = u66.player,
            emitter = u66.emitter,
            analyzer = u66.analyzer
        };
    end
};