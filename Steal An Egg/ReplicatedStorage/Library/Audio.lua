-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local Library = ReplicatedStorage:WaitForChild("Library");
local AddDebris = require(Library.Functions.AddDebris);
local ParseAssetId = require(Library.Functions.ParseAssetId);
local Tween = require(Library.Functions.Tween);
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local InstanceCheck = require(ReplicatedStorage.Library.Functions.InstanceCheck);
local Interface = require(script.Types.Interface);
local u1, u2;

if RunService:IsClient() then
    local Client = Library:WaitForChild("Client");
    u1 = require(Client.FFlags);
    u2 = require(Client.SettingsCmds);
else
    u1 = nil;
    u2 = nil;
end;

local Music = script:WaitForChild("Music");
local u3 = RunService:IsClient();
local Sound = Instance.new("Sound");
local u4 = Random.new();
local u5 = {};

local function isInsideBox(p6, p7) -- Line: 42
    local v8;

    if p6.X >= -p7.X and (p6.X <= p7.X and (p6.Y >= -p7.Y and (p6.Y <= p7.Y and p6.Z >= -p7.Z))) then
        v8 = p6.Z <= p7.Z;
    else
        v8 = false;
    end;

    return v8;
end;

local function addToGarbageCollection(p9, p10) -- Line: 51
    -- upvalues: u5 (copy)
    table.insert(u5, { p9, p10 });
end;

local function scanGarbageCollection() -- Line: 58
    -- upvalues: u5 (copy), RunService (copy), AddDebris (copy)
    for i = #u5, 1, -1 do
        if i % 25 == 0 then
            RunService.Heartbeat:Wait();
        end;

        local v11 = u5[i];
        local v12 = v11[1];
        local v13 = v11[2];

        if not v12 or (not v12.Parent or (not v12.Playing or v12.SoundId == "")) then
            if v13 and (v12 and v12.Parent) then
                AddDebris(v12.Parent, 0);
            elseif v12 then
                AddDebris(v12, 0);
            end;

            table.remove(u5, i);
        end;
    end;
end;

local u19 = {
    __types = Interface,

    ScheduleAndPlay = function(u14, u15, p16) -- Line: 87, Name: ScheduleAndPlay
        -- upvalues: Asserts (copy)
        Asserts.Sound(u14);
        Asserts.optional.func(u15);
        Asserts.optional.Instance(p16);

        if p16 then
            u14.Parent = p16;
        end;

        task.spawn(function() -- Line: 96
            -- upvalues: u14 (copy), u15 (copy)
            if not u14.IsLoaded then
                u14.Loaded:Wait();
            end;

            local u17 = nil;
            local u18 = nil;

            local function stoppedOrEnded() -- Line: 104
                -- upvalues: u17 (ref), u18 (ref), u15 (ref), u14 (ref)
                if u17 then
                    u17:Disconnect();
                    u17 = nil;
                end;

                if u18 then
                    u18:Disconnect();
                    u18 = nil;
                end;

                if u15 and u15(u14) then
                    return;
                end;

                u14:Destroy();
            end;

            u17 = u14.Ended:Once(stoppedOrEnded);
            u18 = u14.Stopped:Once(stoppedOrEnded);
            u14:Play();
        end);

        return u14;
    end
};

function u19.PlayFromSoundFile(p20, p21, p22) -- Line: 128
    -- upvalues: u19 (copy)
    return u19.PlayFromFormattedParams(p20.SoundId, p21, p20.Data, p22);
end;

function u19.PlayFromFormattedParams(p23, p24, p25, p26) -- Line: 132
    -- upvalues: Interface (copy), u19 (copy)
    assert(Interface.PlayFormattedParamsInterface(p25));

    return u19.Play(p23, p24, p25.Speed, p25.Volume, p25.MaxDistance, p25.SoundGroup, p25.Looped, p25.TimePos, p25.Player, p25.SkipPlay, p26);
end;

function u19.PrepareSoundFromSoundFile(p27, p28) -- Line: 155
    -- upvalues: Asserts (copy), Interface (copy), InstanceCheck (copy), ParseAssetId (copy), u4 (copy)
    Asserts.Sound(p27);
    assert(Interface.SoundFile(p28));
    local SoundId = p28.SoundId;
    local Data = p28.Data;
    local v29;

    if Data then
        v29 = Data.Speed;
    else
        v29 = Data;
    end;

    local v30;

    if Data then
        v30 = Data.Volume;
    else
        v30 = Data;
    end;

    local v31;

    if Data then
        v31 = Data.MaxDistance;
    else
        v31 = Data;
    end;

    local v32;

    if Data then
        v32 = Data.SoundGroup;
    else
        v32 = Data;
    end;

    local v33;

    if Data then
        v33 = Data.Looped;
    else
        v33 = Data;
    end;

    if Data then
        Data = Data.TimePos;
    end;

    if not InstanceCheck(SoundId, "Sound") then
        if type(SoundId) == "table" then
            SoundId = SoundId[math.random(1, #SoundId)];
        end;

        if type(SoundId) == "string" then
            SoundId = ParseAssetId(SoundId);
        end;

        local v34 = type(SoundId) == "number";
        assert(v34, "soundIdOrInstance must be a number");
        assert(SoundId > 0, "soundIdOrInstance must be greater than 0");
    end;

    local v35 = v29 == nil and 1 or v29;

    if type(v35) == "table" then
        v35 = u4:NextNumber(unpack(v35));
    end;

    local v36 = type(v35) == "number";
    assert(v36, "speed must be a number");
    local v37 = v30 == nil and 1 or v30;

    if type(v37) == "table" then
        v37 = u4:NextNumber(unpack(v37));
    end;

    local v38 = type(v37) == "number";
    assert(v38, "volume must be a number");
    local v39 = v31 == nil and 200 or v31;
    local v40 = type(v39) == "number";
    assert(v40, "maxDistance must be a number");

    if typeof(v32) == "Instance" then
        local v41 = v32:IsA("SoundGroup");
        assert(v41, "soundGroup must be a SoundGroup instance");
        local _ = v32.Name;
    end;

    if v33 == nil then
        v33 = false;
    end;

    local v42 = type(v33) == "boolean";
    assert(v42, "looped must be a boolean");
    local v43 = Data == nil and 0 or Data;
    local v44 = type(v43) == "number";
    assert(v44, "timePos must be a number");
    p27.SoundId = ("rbxassetid://%d"):format(SoundId);
    p27.PlaybackSpeed = v35;
    p27.Volume = v37;
    p27.Looped = v33;
    p27.TimePosition = v43;
    p27.RollOffMode = Enum.RollOffMode.LinearSquare;
    p27.RollOffMinDistance = 0.001;
    p27.RollOffMaxDistance = v39;

    return p27;
end;

function u19.Play(p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55) -- Line: 224
    -- upvalues: InstanceCheck (copy), ParseAssetId (copy), u4 (copy), Asserts (copy), u3 (copy), u1 (ref), Sound (copy), u2 (ref), SoundService (copy), __DEBRIS (copy), u19 (copy)
    local v56 = InstanceCheck(p45, "Sound");

    if not v56 then
        if type(p45) == "table" then
            p45 = p45[math.random(1, #p45)];
        end;

        if type(p45) == "string" then
            p45 = ParseAssetId(p45);
        end;

        local v57 = type(p45) == "number";
        assert(v57, "soundIdOrInstance must be a number");
        assert(p45 > 0, "soundIdOrInstance must be greater than 0");
    end;

    if typeof(p46) == "Vector3" then
        p46 = CFrame.new(p46);
    end;

    local v58 = typeof(p46) == "CFrame" and true or typeof(p46) == "Instance";
    assert(v58, "target must be either a CFrame or an Instance");
    local v59 = p47 == nil and 1 or p47;

    if type(v59) == "table" then
        v59 = u4:NextNumber(unpack(v59));
    end;

    local v60 = type(v59) == "number";
    assert(v60, "speed must be a number");
    local v61 = p48 == nil and 1 or p48;

    if type(v61) == "table" then
        v61 = u4:NextNumber(unpack(v61));
    end;

    local v62 = type(v61) == "number";
    assert(v62, "volume must be a number");
    local v63 = p49 == nil and 200 or p49;
    local v64 = type(v63) == "number";
    assert(v64, "maxDistance must be a number");

    if typeof(p50) == "Instance" then
        local v65 = p50:IsA("SoundGroup");
        assert(v65, "soundGroup must be a SoundGroup instance");
        p50 = p50.Name;
    end;

    local v66 = p50 == nil and true or type(p50) == "string";
    assert(v66, "soundGroup must be nil or a string when not an Instance");

    if p51 == nil then
        p51 = false;
    end;

    local v67 = type(p51) == "boolean";
    assert(v67, "looped must be a boolean");
    local v68 = p52 == nil and 0 or p52;
    local v69 = type(v68) == "number";
    assert(v69, "timePos must be a number");
    Asserts.optional.table(p55);

    if not u3 then
        local Network = require(game:GetService("ServerScriptService"):WaitForChild("Library").Network);

        if p53 then
            Network.Fire("PlaySound", p53, p45, p46, v59, v61, v63, p50, p51, v68, nil, p54, p55);
        else
            Network.FireAll("PlaySound", p45, p46, v59, v61, v63, p50, p51, v68, nil, p54, p55);
        end;

        return nil;
    end;

    if not u1.Get(u1.Keys.SFX) then
        return Sound;
    end;

    if u2 and not u2.IsEnabled("SFX") then
        return Sound;
    end;

    local v70 = nil;
    local v71 = Vector3.new(0, 0, 0);
    local v72 = true;

    if typeof(p46) == "CFrame" then
        v70 = p46;
    elseif typeof(p46) == "Instance" then
        if p46:IsA("Model") then
            local PrimaryPart = p46.PrimaryPart;

            if not PrimaryPart then
                warn("Tried to play Audio on a Model with no PrimaryPart:", p46, p45, debug.traceback());

                return Sound;
            end;

            v70 = PrimaryPart.CFrame;
            v71 = PrimaryPart.Size;
        elseif p46:IsA("BasePart") then
            v70 = p46.CFrame;
            v71 = p46.Size;
        elseif p46:IsA("PVInstance") then
            v70 = p46:GetPivot();
        elseif p46:IsA("Attachment") then
            v70 = p46.WorldCFrame;
        end;
    end;

    local CFrame2 = workspace.CurrentCamera.CFrame;

    if not v70 then
        v70 = CFrame2;
        v72 = false;
    end;

    if not p51 and v72 then
        local v73 = v63 * 2;
        local v74 = v71 * 0.5 + Vector3.new(v73, v73, v73);
        local v75 = v70:ToObjectSpace(CFrame2);
        local v76;

        if v75.X >= -v74.X and (v75.X <= v74.X and (v75.Y >= -v74.Y and (v75.Y <= v74.Y and v75.Z >= -v74.Z))) then
            v76 = v75.Z <= v74.Z;
        else
            v76 = false;
        end;

        if not v76 then
            return Sound;
        end;
    end;

    local v77 = SoundService:FindFirstChild(p50 or "Default");

    if v77.Name == "Music" and v77:FindFirstChild("GameMusic") then
        v77 = v77:FindFirstChild("GameMusic");
    end;

    local v78 = `Could not find SoundGroup with name: {p50 or "Default"}`;
    assert(v77, v78);
    local v79 = v77:IsA("SoundGroup");
    assert(v79, "Found instance is not a SoundGroup");
    local u80 = false;
    local u81;

    if typeof(p46) == "CFrame" then
        u81 = Instance.new("Part");
        u81.CFrame = p46;
        u81.Anchored = true;
        u81.CanCollide = false;
        u81.CanQuery = false;
        u81.CanTouch = false;
        u81.Size = Vector3.new(0, 0, 0);
        u81.Transparency = 1;
        u81.Parent = __DEBRIS;
        u80 = true;
    elseif p46:IsA("Model") then
        u81 = p46.PrimaryPart;

        if not u81 then
            warn("Tried to play Audio on a Model with no PrimaryPart:", p46, p45, debug.traceback());

            return Sound;
        end;
    else
        u81 = p46;
    end;

    local v82 = typeof(u81) == "Instance";
    assert(v82, "target must be an Instance");
    local v83 = v56 and p45:Clone() or Instance.new("Sound");

    if not v56 then
        v83.SoundId = ("rbxassetid://%d"):format(p45);
        v83.PlaybackSpeed = v59;
        v83.Volume = v61;
        v83.Looped = p51;
        v83.TimePosition = v68;
        v83.RollOffMode = Enum.RollOffMode.LinearSquare;
        v83.RollOffMinDistance = 0.001;
        v83.RollOffMaxDistance = v63;
        v83.SoundGroup = v77;

        if p55 then
            for _, v in ipairs(p55) do
                Asserts.Instance(v);
                v.Parent = v83;
            end;
        end;
    end;

    if u81:IsA("Model") then
        u81 = u81.PrimaryPart or u81;
    end;

    v83.Parent = u81;

    if not p54 then
        u19.ScheduleAndPlay(v83, function() -- Line: 448
            -- upvalues: u80 (ref), u81 (ref)
            if u80 then
                u81:Destroy();

                return true;
            end;
        end);
    end;

    return v83;
end;

function u19.PlayError(p84) -- Line: 460
    -- upvalues: u19 (copy)
    u19.Play("rbxassetid://131342831254185", script, 1, 1 * (p84 or 1));
end;

function u19.PlayStatement(p85) -- Line: 464
    -- upvalues: u19 (copy)
    u19.Play("rbxassetid://131342831254185", script, 1, 0.5 * (p85 or 1));
end;

function u19.PlayQuestion(p86) -- Line: 468
    -- upvalues: u19 (copy)
    u19.Play("rbxassetid://131342831254185", script, 1, 0.8 * (p86 or 1));
end;

function u19.PlayLocked(p87) -- Line: 472
    -- upvalues: u19 (copy)
    u19.Play("rbxassetid://131342831254185", script, 1, 1 * (p87 or 1));
end;

function u19.Huh(p88, p89) -- Line: 476
    -- upvalues: u19 (copy)
    u19.Play("rbxassetid://131342831254185", script, 1, 1 * (p89 or 1), nil, nil, nil, nil, p88);
end;

function u19.Fade(p90, p91, p92, p93, p94) -- Line: 479
    -- upvalues: Interface (copy), Tween (copy)
    assert(Interface.FadeParams(p90, p91, p92, p93, p94));

    return Tween(p90, {
        Volume = p91
    }, { p92, p93, p94 });
end;

function u19.PlayMusic(p95, p96, p97, p98, p99, p100) -- Line: 497
    -- upvalues: u3 (copy), u2 (ref), Sound (copy), ParseAssetId (copy), u4 (copy), SoundService (copy), Music (copy), u19 (copy), u5 (copy)
    if u3 and (u2 and not u2.IsEnabled("Music")) then
        return Sound;
    end;

    if type(p95) == "table" then
        p95 = p95[math.random(1, #p95)];
    end;

    if type(p95) == "string" then
        p95 = ParseAssetId(p95);
    end;

    local v101 = type(p95) == "number";
    assert(v101, "soundId must be a number");
    assert(p95 > 0, "soundId must be greater than 0");
    local v102 = p96 == nil and 1 or p96;

    if type(v102) == "table" then
        v102 = u4:NextNumber(unpack(v102));
    end;

    local v103 = type(v102) == "number";
    assert(v103, "volume must be a number");
    local v104 = p97 == nil and 1 or p97;
    local v105 = type(v104) == "number";
    assert(v105, "fadeTime must be a number");

    if typeof(p98) == "Instance" then
        local v106 = p98:IsA("SoundGroup");
        assert(v106, "group must be a SoundGroup instance");
        p98 = p98.Name;
    end;

    local v107 = p98 == nil and true or type(p98) == "string";
    assert(v107, "group must be nil or a string when not an Instance");
    local v108 = p99 == nil and true or p99;
    local v109 = type(v108) == "boolean";
    assert(v109, "loop must be a boolean");
    local v110 = type(p100 == nil and 0 or p100) == "number";
    assert(v110, "timePos must be a number");
    local v111 = SoundService:FindFirstChild(p98 or "Music");

    if v111.Name == "Music" and v111:FindFirstChild("GameMusic") then
        v111 = v111:FindFirstChild("GameMusic");
    end;

    assert(v111, "Could not find SoundGroup with name: " .. (p98 or "Music"));
    local v112 = v111:IsA("SoundGroup");
    assert(v112, "Found instance is not a SoundGroup");
    local Sound2 = Instance.new("Sound");
    Sound2.SoundId = ("rbxassetid://%d"):format(p95);
    Sound2.Volume = 0;
    Sound2.Looped = v108;
    Sound2.SoundGroup = v111;
    Sound2.Parent = Music;
    Sound2:Play();

    for _, child in ipairs(Music:GetChildren()) do
        if child:IsA("Sound") then
            u19.Fade(child, 0, v104);
        end;
    end;

    u19.Fade(Sound2, v102, v104);
    table.insert(u5, { Sound2, nil });

    return Sound2;
end;

function u19.StopMusic(p113) -- Line: 567
    -- upvalues: Music (copy), u19 (copy)
    local v114 = p113 == nil and 1 or p113;
    local v115 = type(v114) == "number";
    assert(v115, "fadeTime must be a number");

    for _, child in ipairs(Music:GetChildren()) do
        if child:IsA("Sound") then
            u19.Fade(child, 0, v114);
        end;
    end;
end;

if u3 then
    local DefaultReverb = SoundService:FindFirstChild("DefaultReverb");
    local v116 = DefaultReverb and DefaultReverb:FindFirstChild("ReverbSoundEffect");

    if v116 then
        v116.DryLevel = -1.3389357926122634;
        v116.WetLevel = -16.90196080028514;
    end;

    local function computeVolume(p117) -- Line: 592
        return (math.clamp(p117, 0, 1) * 2) ^ 2;
    end;

    local Client = Library:WaitForChild("Client");
    local Network = require(Client.Network);
    local Signal = require(Library.Signal);
    Network.Fired("PlaySound"):Connect(function(...) -- Line: 601
        -- upvalues: u19 (copy)
        u19.Play(...);
    end);
    Signal.Fired("Setting Slider Update"):Connect(function(p118, p119) -- Line: 605
        -- upvalues: SoundService (copy)
        if p118 == "Music" then
            SoundService:WaitForChild("Music").Volume = (math.clamp(p119, 0, 1) * 2) ^ 2;

            return;
        end;

        if p118 == "SFX" then
            local Default = SoundService:WaitForChild("Default");
            local DefaultReverb2 = SoundService:WaitForChild("DefaultReverb");
            local v120 = (math.clamp(p119, 0, 1) * 2) ^ 2;
            Default.Volume = v120;
            DefaultReverb2.Volume = v120;
        end;
    end);
end;

_G.Huh = u19.Huh;
task.spawn(function() -- Line: 662
    -- upvalues: u3 (copy), scanGarbageCollection (copy)
    if not u3 then
        return;
    end;

    while true do
        task.wait(1);
        scanGarbageCollection();
    end;
end);

return u19;