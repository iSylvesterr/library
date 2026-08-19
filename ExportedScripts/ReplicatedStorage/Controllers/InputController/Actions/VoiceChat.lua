-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Signal = require(ReplicatedStorage.Packages.Signal);
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    disabled = "Disabled",
    off = "Disabled",
    ["push to talk"] = "Push To Talk",
    pushtotalk = "Push To Talk",
    ptt = "Push To Talk",
    ["open mic"] = "Open Microphone",
    openmic = "Open Microphone",
    ["open microphone"] = "Open Microphone",
    openmicrophone = "Open Microphone"
};
local u3 = Signal.new();
local u4 = {
    IsPushToTalkHeld = false,
    IsVoiceInputRefreshQueued = false,
    LastVoiceInputScanTime = 0,
    ShouldRecreateVoiceInputs = false,
    VoiceActivityConnection = nil,
    VoiceMode = "Disabled",
    PlayerConnections = {},
    SpeakingPlayers = {},
    Trackers = {}
};
u1.Name = "Voice Chat";
u1.Group = "Default";
u1.Category = "Communication Options";
u1.SpeakingChanged = u3;

function u1.GetVoiceMode(p5) -- Line: 77
    -- upvalues: u2 (copy)
    if typeof(p5) ~= "string" then
        return "Disabled";
    end;

    local v6 = string.lower(p5);
    local v7 = string.gsub(v6, "[%s_%-%./]+", " ");
    local v8 = string.gsub(v7, "^%s+", "");
    local v9 = string.gsub(v8, "%s+$", "");
    local v10 = string.gsub(v9, "%s+", "");

    return u2[v9] or u2[v10] or "Disabled";
end;

function u1.SetVoiceMode(p11) -- Line: 91
    -- upvalues: u4 (copy), u1 (copy)
    u4.VoiceMode = u1.GetVoiceMode(p11);
    u4.IsPushToTalkHeld = false;
    u1.SyncVoiceMuted();
    u1.SyncVoiceActivity();
end;

function u1.SetPushToTalkHeld(p12) -- Line: 98
    -- upvalues: u4 (copy), u1 (copy)
    u4.IsPushToTalkHeld = p12;
    u1.SyncVoiceMuted();
    u1.SyncVoiceActivity();
end;

function u1.IsVoiceTransmitting() -- Line: 104
    -- upvalues: LocalPlayer (copy), u4 (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        return false;
    end;

    if u4.VoiceMode == "Open Microphone" then
        return true;
    end;

    local v13;

    if u4.VoiceMode == "Push To Talk" then
        v13 = u4.IsPushToTalkHeld;
    else
        v13 = false;
    end;

    return v13;
end;

function u1.IsPlayerSpeaking(p14) -- Line: 116
    -- upvalues: u4 (copy)
    return u4.SpeakingPlayers[p14] == true;
end;

function u1.SetPlayerSpeaking(p15, p16) -- Line: 120
    -- upvalues: u1 (copy), u4 (copy), u3 (copy)
    if u1.IsPlayerSpeaking(p15) == p16 then
        return;
    end;

    u4.SpeakingPlayers[p15] = p16 and true or nil;
    u3:Fire(p15, p16);
end;

function u1.GetVoiceInput(p17) -- Line: 129
    -- upvalues: LocalPlayer (copy)
    return (p17 or LocalPlayer):FindFirstChildWhichIsA("AudioDeviceInput");
end;

function u1.SetVoiceMuted(p18) -- Line: 133
    -- upvalues: u1 (copy)
    local v19 = u1.GetVoiceInput();

    if v19 then
        v19.Muted = p18;
    end;
end;

function u1.DestroyTracker(p20) -- Line: 140
    -- upvalues: u4 (copy), u1 (copy)
    local v21 = u4.Trackers[p20];

    if not v21 then
        return;
    end;

    v21.Wire:Destroy();
    v21.Analyzer:Destroy();
    u4.Trackers[p20] = nil;
    u1.SetPlayerSpeaking(p20, false);
end;

function u1.QueueVoiceInputRefresh(p22, p23) -- Line: 152
    -- upvalues: u4 (copy), u1 (copy)
    u4.ShouldRecreateVoiceInputs = u4.ShouldRecreateVoiceInputs or p22 == true;

    if p23 then
        task.delay(0.25, function() -- Line: 156
            -- upvalues: u1 (ref)
            u1.QueueVoiceInputRefresh(true);
        end);
    end;

    if u4.IsVoiceInputRefreshQueued then
        return;
    end;

    u4.IsVoiceInputRefreshQueued = true;
    task.defer(function() -- Line: 167
        -- upvalues: u4 (ref), u1 (ref)
        local ShouldRecreateVoiceInputs = u4.ShouldRecreateVoiceInputs;
        u4.IsVoiceInputRefreshQueued = false;
        u4.ShouldRecreateVoiceInputs = false;

        if ShouldRecreateVoiceInputs then
            local v24 = {};

            for i in pairs(u4.Trackers) do
                table.insert(v24, i);
            end;

            for _, v in ipairs(v24) do
                u1.DestroyTracker(v);
            end;
        end;

        u1.SyncVoiceInputs(true);
        u1.SyncVoiceActivity();
    end);
end;

function u1.TrackVoiceInput(p25, p26) -- Line: 189
    -- upvalues: u4 (copy), u1 (copy), LocalPlayer (copy)
    local v27 = u4.Trackers[p25];

    if v27 and v27.Input == p26 then
        return;
    end;

    u1.DestroyTracker(p25);
    local AudioAnalyzer = Instance.new("AudioAnalyzer");
    AudioAnalyzer.Name = `{p25.Name}VoiceChatAnalyzer`;
    AudioAnalyzer.SpectrumEnabled = false;
    AudioAnalyzer.Parent = LocalPlayer;
    local Wire = Instance.new("Wire");
    Wire.Name = "VoiceChatAnalyzerWire";
    Wire.SourceInstance = p26;
    Wire.SourceName = "Output";
    Wire.TargetInstance = AudioAnalyzer;
    Wire.TargetName = "Input";
    Wire.Parent = AudioAnalyzer;
    u4.Trackers[p25] = {
        LastVoiceActivityTime = 0,
        Analyzer = AudioAnalyzer,
        Input = p26,
        Wire = Wire
    };

    if p25 == LocalPlayer then
        u1.SyncVoiceMuted();
    end;
end;

function u1.SyncVoiceInputs(p28) -- Line: 222
    -- upvalues: u4 (copy), u1 (copy), Players (copy)
    local v29 = os.clock();

    if not p28 and v29 - u4.LastVoiceInputScanTime < 0.2 then
        return;
    end;

    u4.LastVoiceInputScanTime = v29;

    for i in pairs(u4.Trackers) do
        if not i.Parent then
            u1.DestroyTracker(i);
        end;
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        local v30 = u4.Trackers[v];
        local v31 = u1.GetVoiceInput(v);

        if v31 then
            u1.TrackVoiceInput(v, v31);
        elseif v30 then
            u1.DestroyTracker(v);
        end;
    end;
end;

function u1.ObservePlayer(p32) -- Line: 248
    -- upvalues: u4 (copy), u1 (copy)
    if u4.PlayerConnections[p32] then
        return;
    end;

    local v33 = {};
    u4.PlayerConnections[p32] = v33;

    local function refreshVoiceAccess() -- Line: 256
        -- upvalues: u1 (ref)
        u1.QueueVoiceInputRefresh(true, true);
    end;

    local function refreshVoiceInput(p34) -- Line: 260
        -- upvalues: u1 (ref)
        if p34:IsA("AudioDeviceInput") then
            u1.QueueVoiceInputRefresh();
        end;
    end;

    local v35 = p32:GetAttributeChangedSignal("Team");
    table.insert(v33, v35:Connect(refreshVoiceAccess));
    local v36 = p32:GetAttributeChangedSignal("IsSpectating");
    table.insert(v33, v36:Connect(refreshVoiceAccess));
    table.insert(v33, p32.ChildAdded:Connect(refreshVoiceInput));
    table.insert(v33, p32.ChildRemoved:Connect(refreshVoiceInput));
    u1.QueueVoiceInputRefresh();
end;

function u1.UnobservePlayer(p37) -- Line: 274
    -- upvalues: u4 (copy), u1 (copy)
    local v38 = u4.PlayerConnections[p37];

    if not v38 then
        u1.DestroyTracker(p37);

        return;
    end;

    u4.PlayerConnections[p37] = nil;

    for _, v in ipairs(v38) do
        v:Disconnect();
    end;

    table.clear(v38);
    u1.DestroyTracker(p37);
end;

function u1.SyncPlayerVoiceActivity(p39, p40) -- Line: 291
    -- upvalues: LocalPlayer (copy), u1 (copy)
    if p39 == LocalPlayer and not u1.IsVoiceTransmitting() then
        p40.LastVoiceActivityTime = 0;
        u1.SetPlayerSpeaking(p39, false);

        return;
    end;

    local v41 = os.clock();
    local v42 = math.max(p40.Analyzer.RmsLevel, p40.Analyzer.PeakLevel);

    if not u1.IsPlayerSpeaking(p39) then
        if v42 >= 0.0008 then
            p40.LastVoiceActivityTime = v41;
            u1.SetPlayerSpeaking(p39, true);
        end;

        return;
    end;

    if v42 >= 0.0005 then
        p40.LastVoiceActivityTime = v41;

        return;
    end;

    if v41 - p40.LastVoiceActivityTime >= 0.7 then
        u1.SetPlayerSpeaking(p39, false);
    end;
end;

function u1.SyncVoiceActivity() -- Line: 321
    -- upvalues: u1 (copy), u4 (copy)
    u1.SyncVoiceInputs();

    for i, v in pairs(u4.Trackers) do
        u1.SyncPlayerVoiceActivity(i, v);
    end;
end;

function u1.StartVoiceActivityLoop() -- Line: 329
    -- upvalues: u4 (copy), RunServiceController (copy), u1 (copy)
    if not u4.VoiceActivityConnection then
        u4.VoiceActivityConnection = RunServiceController.BindToPostSimulation("InputController.VoiceChat.SyncVoiceActivity", u1.SyncVoiceActivity);
    end;
end;

function u1.SyncVoiceMuted() -- Line: 338
    -- upvalues: LocalPlayer (copy), u1 (copy), u4 (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        u1.SetVoiceMuted(true);

        return;
    end;

    if u4.VoiceMode == "Open Microphone" then
        u1.SetVoiceMuted(false);

        return;
    end;

    u1.SetVoiceMuted(u4.VoiceMode ~= "Push To Talk" and true or not u4.IsPushToTalkHeld);
end;

function u1.OnInput(p43, p44) -- Line: 348
    -- upvalues: LocalPlayer (copy), u1 (copy), u4 (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        u1.SetPushToTalkHeld(false);

        return;
    end;

    if u4.VoiceMode ~= "Push To Talk" then
        u1.SyncVoiceMuted();

        return;
    end;

    if p43 == Enum.UserInputState.Begin then
        u1.SetPushToTalkHeld(true);

        return;
    end;

    if p43 == Enum.UserInputState.End or p43 == Enum.UserInputState.Cancel then
        u1.SetPushToTalkHeld(false);
    end;
end;

Players.PlayerAdded:Connect(u1.ObservePlayer);
Players.PlayerRemoving:Connect(u1.UnobservePlayer);
workspace:GetAttributeChangedSignal("VoiceAccessRevision"):Connect(function() -- Line: 369
    -- upvalues: u1 (copy)
    u1.QueueVoiceInputRefresh(true, true);
end);

for _, v in ipairs(Players:GetPlayers()) do
    u1.ObservePlayer(v);
end;

LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting"):Connect(function() -- Line: 377
    -- upvalues: u1 (copy)
    u1.SyncVoiceMuted();
    u1.SyncVoiceActivity();
end);
DataController.CreateListener(LocalPlayer, "Settings.Audio.Voice Chat.Voice Chat Activation Mode", u1.SetVoiceMode);
u1.StartVoiceActivityLoop();
u1.SyncVoiceMuted();
u1.SyncVoiceInputs(true);
u1.SyncVoiceActivity();
u1.Callback = u1.OnInput;

return table.freeze(u1);