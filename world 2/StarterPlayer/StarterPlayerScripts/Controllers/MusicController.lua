-- Decompiled with Potassium's decompiler.

local MusicController = game.StarterPlayer.StarterPlayerScripts.Controllers.MusicController;

if script ~= MusicController then
    return require(MusicController);
end;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local WeatherValues = ReplicatedStorage:WaitForChild("WeatherValues");
local SharedModules = ReplicatedStorage:WaitForChild("SharedModules");
local WeatherData = require(SharedModules:WaitForChild("WeatherData"));
local PartyConfig = require(SharedModules:WaitForChild("PartyConfig"));
local MusicTracks = SoundService:WaitForChild("MusicTracks");
local Day = MusicTracks:WaitForChild("Day");
local u1 = {};

local function dbg(...) -- Line: 43
end;

local v2 = {
    StartOrder = 2
};

for _, v in WeatherData.Data do
    u1[v.Name] = v.AlwaysOn == true;
end;

local u3 = Random.new();
local u4 = setmetatable({}, {
    __mode = "k"
});
local u5 = {};
local u6 = Day;
local u7 = nil;
local u8 = nil;
local u9 = {};
local u10 = 0;
local u11 = nil;
local u12 = nil;
local u13 = 0;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = false;
local u20 = false;
local u21 = false;

local function getPlayableSounds(p22) -- Line: 86
    -- upvalues: u5 (copy), u4 (copy)
    local v23 = {};

    for _, child in p22:GetChildren() do
        if child:IsA("Sound") and (child.SoundId ~= "" and (not u5[child] or child.TimeLength > 0)) then
            table.insert(v23, child);

            if u4[child] == nil then
                u4[child] = child.Volume;
            end;
        end;
    end;

    return v23;
end;

local function shuffleInPlace(p24) -- Line: 104
    -- upvalues: u3 (copy)
    for i = #p24, 2, -1 do
        local v25 = u3:NextInteger(1, i);
        local v26 = p24[i];
        p24[i] = p24[v25];
        p24[v25] = v26;
    end;
end;

local function rebuildPlaylist(p27, p28) -- Line: 111
    -- upvalues: u9 (ref), getPlayableSounds (copy), u10 (ref), shuffleInPlace (copy), dbg (copy)
    u9 = getPlayableSounds(p27);
    u10 = 0;
    shuffleInPlace(u9);
    dbg("rebuildPlaylist for folder:", p27.Name, "| track count:", #u9);

    for i, v in u9 do
        dbg("  playlist[" .. i .. "]:", v.Name);
    end;

    if p28 and (#u9 > 1 and u9[1] == p28) then
        local v29 = u9[1];
        u9[1] = u9[2];
        u9[2] = v29;
        dbg("  swapped first track to avoid repeat:", p28.Name);
    end;
end;

local function nextTrackFromFolder(p30) -- Line: 127
    -- upvalues: dbg (copy), u6 (ref), u10 (ref), u9 (ref), rebuildPlaylist (copy), u11 (ref)
    dbg("nextTrackFromFolder:", p30.Name, "| currentFolder:", u6.Name, "| playlistIndex:", u10, "| #playlist:", #u9);

    if p30 ~= u6 then
        dbg("  folder changed from", u6.Name, "-> rebuilding playlist");
        rebuildPlaylist(p30, u11);
    end;

    if #u9 == 0 then
        dbg("  playlist empty, rebuilding");
        rebuildPlaylist(p30, u11);
    end;

    if #u9 == 0 then
        dbg("  playlist STILL empty after rebuild, returning nil");

        return nil;
    end;

    u10 = u10 + 1;

    if u10 > #u9 then
        dbg("  playlistIndex overflowed, reshuffling");
        rebuildPlaylist(p30, u11);
        u10 = 1;

        if #u9 == 0 then
            dbg("  playlist empty after reshuffle, returning nil");

            return nil;
        end;
    end;

    local v31 = u9[u10];

    if not v31 then
        dbg("  no track at index", u10, "returning nil");

        return nil;
    end;

    u11 = v31;
    dbg("  chose track:", v31.Name, "from folder:", p30.Name, "| index:", u10);

    return v31;
end;

local function cancelTweens() -- Line: 170
    -- upvalues: u14 (ref), dbg (copy), u15 (ref), u16 (ref), u17 (ref)
    if u14 then
        dbg("cancelTweens: cancelling fadeInTween");
        u14:Cancel();
        u14 = nil;
    end;

    if u15 then
        dbg("cancelTweens: cancelling fadeOutTween");
        u15:Cancel();
        u15 = nil;
    end;

    if u16 then
        dbg("cancelTweens: killing orphaned fadingOutSound:", u16.Name, "| IsPlaying:", u16.IsPlaying);
        u16:Stop();
        u16.TimePosition = 0;
        u16.Volume = u17 or u16.Volume;
        u16 = nil;
        u17 = nil;
    end;
end;

local function disconnectEnded() -- Line: 192
    -- upvalues: u12 (ref), dbg (copy)
    if u12 then
        dbg("disconnectEnded: disconnecting previous Ended connection");
        u12:Disconnect();
        u12 = nil;
    end;
end;

local function tweenVolume(p32, p33, p34) -- Line: 200
    -- upvalues: TweenService (copy)
    local v35 = TweenService:Create(p32, TweenInfo.new(p34, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Volume = p33
    });
    v35:Play();

    return v35;
end;

local function stopAllExcept(p36) -- Line: 210
    -- upvalues: MusicTracks (copy), dbg (copy), u4 (copy)
    local v37 = p36 and (p36.Name or "nil") or "nil";

    for _, child in MusicTracks:GetChildren() do
        if child:IsA("Folder") then
            for _, child2 in child:GetChildren() do
                if child2:IsA("Sound") and (child2 ~= p36 and child2.IsPlaying) then
                    dbg("stopAllExcept: STOPPING orphan:", child2.Name, "in folder:", child.Name, "(keeping:", v37, ")");
                    child2:Stop();
                    child2.TimePosition = 0;
                    child2.Volume = u4[child2] or child2.Volume;
                end;
            end;
        end;
    end;
end;

function v2._CrossFadeTo(u38, u39) -- Line: 226
    -- upvalues: u13 (ref), u7 (ref), dbg (copy), cancelTweens (copy), u12 (ref), u5 (copy), u4 (copy), u14 (ref), tweenVolume (copy), stopAllExcept (copy), u16 (ref), u17 (ref), u15 (ref), MusicTracks (copy)
    u13 = u13 + 1;
    local u40 = u13;
    local v41 = u39 and (u39.Name or "nil") or "nil";
    local v42 = u39 and u39.Parent and (u39.Parent.Name or "nil") or "nil";
    local v43 = u7 and u7.Name or "nil";
    local v44 = u7 and (u7.Parent and u7.Parent.Name) or "nil";
    dbg("=== _CrossFadeTo ===");
    dbg("  transitionId:", u40);
    dbg("  prev:", v43, "(folder:", v44, ")");
    dbg("  next:", v41, "(folder:", v42, ")");
    cancelTweens();

    if u12 then
        dbg("disconnectEnded: disconnecting previous Ended connection");
        u12:Disconnect();
        u12 = nil;
    end;

    local u45 = u7;

    local function armStallWatchdog(u46) -- Line: 247
        -- upvalues: u13 (ref), u40 (copy), u5 (ref), u38 (copy)
        task.delay(5, function() -- Line: 248
            -- upvalues: u13 (ref), u40 (ref), u46 (copy), u5 (ref), u38 (ref)
            if u13 ~= u40 then
                return;
            end;

            if u46.TimeLength > 0 then
                return;
            end;

            warn((`[MusicController] "{u46.Name}" ({u46.SoundId}) never loaded, skipping it`));
            u5[u46] = true;
            u38:_PlayNext();
        end);
    end;

    if u45 and (u39 and u45 == u39) then
        dbg("  same-sound restart:", u45.Name);
        local v47 = u4[u45] or u45.Volume;
        u4[u45] = v47;
        u45:Stop();
        u45.Looped = false;
        u45.TimePosition = 0;
        u45.Volume = 0;
        u45:Play();
        u14 = tweenVolume(u45, v47, 2.25);
        u7 = u45;
        task.delay(5, function() -- Line: 248
            -- upvalues: u13 (ref), u40 (copy), u45 (copy), u5 (ref), u38 (copy)
            if u13 ~= u40 then
                return;
            end;

            if u45.TimeLength > 0 then
                return;
            end;

            warn((`[MusicController] "{u45.Name}" ({u45.SoundId}) never loaded, skipping it`));
            u5[u45] = true;
            u38:_PlayNext();
        end);
        stopAllExcept(u45);
        u12 = u45.Ended:Connect(function() -- Line: 275
            -- upvalues: dbg (ref), u45 (copy), u40 (copy), u13 (ref), u38 (copy)
            dbg("  Ended fired (same-sound) for:", u45.Name, "| myId:", u40, "| transitionId:", u13);

            if u13 == u40 then
                u38:_PlayNext();

                return;
            end;

            dbg("  STALE transitionId, ignoring Ended");
        end);

        return;
    end;

    if u45 then
        dbg("  fading OUT:", u45.Name);
        local u48 = u4[u45] or u45.Volume;
        u16 = u45;
        u17 = u48;
        u15 = tweenVolume(u45, 0, 2.25);
        u15.Completed:Connect(function(p49) -- Line: 295
            -- upvalues: dbg (ref), u45 (copy), u40 (copy), u13 (ref), u48 (copy), u16 (ref), u17 (ref)
            dbg("  fadeOut Completed for:", u45.Name, "| state:", tostring(p49), "| myId:", u40, "| transitionId:", u13);

            if u13 ~= u40 then
                dbg("  STALE transitionId on fadeOut Completed, ignoring");

                return;
            end;

            if p49 ~= Enum.PlaybackState.Completed then
                dbg("  fadeOut was NOT completed (cancelled?), ignoring");

                return;
            end;

            u45:Stop();
            u45.TimePosition = 0;
            u45.Volume = u48;
            dbg("  fadeOut cleanup done for:", u45.Name);

            if u16 == u45 then
                u16 = nil;
                u17 = nil;
            end;
        end);
    end;

    if not u39 then
        dbg("  no nextSound, clearing currentSound");
        u7 = nil;

        return;
    end;

    local v50 = u4[u39] or u39.Volume;
    u4[u39] = v50;
    dbg("  fading IN:", u39.Name, "| baseVol:", v50);
    u39.Looped = false;
    u39.TimePosition = 0;
    u39.Volume = 0;
    u39:Play();
    u14 = tweenVolume(u39, v50, 2.25);
    u7 = u39;
    task.delay(5, function() -- Line: 248
        -- upvalues: u13 (ref), u40 (copy), u39 (copy), u5 (ref), u38 (copy)
        if u13 ~= u40 then
            return;
        end;

        if u39.TimeLength > 0 then
            return;
        end;

        warn((`[MusicController] "{u39.Name}" ({u39.SoundId}) never loaded, skipping it`));
        u5[u39] = true;
        u38:_PlayNext();
    end);

    for _, child in MusicTracks:GetChildren() do
        if child:IsA("Folder") then
            for _, child2 in child:GetChildren() do
                if child2:IsA("Sound") and (child2 ~= u39 and (child2 ~= u45 and child2.IsPlaying)) then
                    dbg("  SAFETY SWEEP: stopping leaked sound:", child2.Name, "in folder:", child.Name);
                    child2:Stop();
                    child2.TimePosition = 0;
                    child2.Volume = u4[child2] or child2.Volume;
                end;
            end;
        end;
    end;

    u12 = u39.Ended:Connect(function() -- Line: 352
        -- upvalues: dbg (ref), u39 (copy), u40 (copy), u13 (ref), u38 (copy)
        dbg("  Ended fired for:", u39.Name, "| myId:", u40, "| transitionId:", u13);

        if u13 == u40 then
            u38:_PlayNext();

            return;
        end;

        dbg("  STALE transitionId, ignoring Ended");
    end);
end;

function v2._ResolveWeatherValuesName(p51) -- Line: 362
    -- upvalues: dbg (copy), WeatherData (copy), WeatherValues (copy), u1 (copy)
    dbg("_ResolveWeatherValuesName checking WeatherData.Data...");

    for _, v in WeatherData.Data do
        if v.AlwaysOn ~= true then
            local v52 = WeatherValues:FindFirstChild(v.Name);

            if v52 and v52:IsA("Folder") then
                local Playing = v52:FindFirstChild("Playing");

                if Playing and Playing:IsA("BoolValue") then
                    dbg("  WeatherData entry:", v.Name, "| Playing:", Playing.Value);

                    if Playing.Value then
                        dbg("  >>> ACTIVE weather from WeatherData:", v.Name);

                        return v.Name;
                    end;
                end;
            end;
        end;
    end;

    dbg("  checking loose WeatherValues folders...");

    for _, child in WeatherValues:GetChildren() do
        if child:IsA("Folder") then
            local Playing = child:FindFirstChild("Playing");

            if Playing and Playing:IsA("BoolValue") then
                dbg("  loose folder:", child.Name, "| Playing:", Playing.Value, "| AlwaysOn:", u1[child.Name] or false);

                if Playing.Value and not u1[child.Name] then
                    dbg("  >>> ACTIVE weather from loose folder:", child.Name);

                    return child.Name;
                end;
            end;
        end;
    end;

    dbg("  no active weather found");

    return nil;
end;

function v2._ResolveTargetFolder(p53) -- Line: 398
    -- upvalues: dbg (copy), MusicTracks (copy), getPlayableSounds (copy), u8 (ref), u18 (ref), Day (copy)
    dbg("--- _ResolveTargetFolder ---");

    if workspace:GetAttribute("InDisco") == true then
        local Disco = MusicTracks:FindFirstChild("Disco");

        if Disco and Disco:IsA("Folder") then
            local v54 = #getPlayableSounds(Disco);
            dbg("  disco active | playable tracks:", v54);

            if v54 > 0 then
                dbg("  >>> using Disco folder");

                return Disco;
            end;
        else
            dbg("  WARNING: InDisco is set but no MusicTracks.Disco folder found!");
        end;
    end;

    if u8 and workspace:GetAttribute("InAdminParty") == true then
        local v55 = #getPlayableSounds(u8);
        dbg("  party active | playable tracks:", v55);

        if v55 > 0 then
            dbg("  >>> using AdminParty folder");

            return u8;
        end;
    end;

    local v56 = p53:_ResolveWeatherValuesName();

    if v56 then
        local v57 = MusicTracks:FindFirstChild(v56);

        if v57 and v57:IsA("Folder") then
            local v58 = #getPlayableSounds(v57);
            dbg("  weatherValues folder:", v56, "| playable tracks:", v58);

            if v58 > 0 then
                dbg("  >>> using WeatherValues folder:", v56);

                return v57;
            end;
        else
            dbg("  WARNING: WeatherValues says", v56, "but no matching MusicTracks folder found!");
        end;
    end;

    if u18 then
        dbg("  timeCycleWeatherName:", u18);
        local v59 = MusicTracks:FindFirstChild(u18);

        if v59 and v59:IsA("Folder") then
            local v60 = #getPlayableSounds(v59);
            dbg("  timeCycle folder:", u18, "| playable tracks:", v60);

            if v60 > 0 then
                dbg("  >>> using TimeCycle folder:", u18);

                return v59;
            end;
        else
            dbg("  WARNING: timeCycle says", u18, "but no matching MusicTracks folder found!");
        end;
    else
        dbg("  timeCycleWeatherName is nil");
    end;

    dbg("  >>> falling back to Day folder");

    return Day;
end;

function v2._SetFolder(p61, p62) -- Line: 469
    -- upvalues: dbg (copy), u6 (ref), u7 (ref), rebuildPlaylist (copy), u11 (ref), nextTrackFromFolder (copy)
    dbg("_SetFolder:", p62.Name, "| currentFolder:", u6.Name, "| currentSound:", u7 and u7.Name or "nil");

    if p62 == u6 and u7 then
        dbg("  same folder & has currentSound, skipping");

        return;
    end;

    if p62 ~= u6 then
        dbg("  folder CHANGED:", u6.Name, "->", p62.Name);
        u6 = p62;
        rebuildPlaylist(p62, u11);
    end;

    p61:_CrossFadeTo((nextTrackFromFolder(p62)));
end;

function v2._PlayNext(p63) -- Line: 487
    -- upvalues: dbg (copy), u20 (ref), u21 (ref), u6 (ref), nextTrackFromFolder (copy)
    dbg("=== _PlayNext ===");

    if u20 then
        dbg("  cutsceneMuted, deferring _PlayNext until cutscene ends");
        u21 = true;

        return;
    end;

    local v64 = p63:_ResolveTargetFolder();
    dbg("  resolved folder:", v64.Name, "| currentFolder:", u6.Name);

    if v64 == u6 then
        p63:_CrossFadeTo((nextTrackFromFolder(u6)));

        return;
    end;

    dbg("  folder changed during _PlayNext, calling _SetFolder");
    p63:_SetFolder(v64);
end;

function v2._Refresh(p65) -- Line: 509
    -- upvalues: dbg (copy), u20 (ref), u21 (ref), MusicTracks (copy)
    dbg("=== _Refresh ===");

    if u20 then
        dbg("  cutsceneMuted, deferring refresh until cutscene ends");
        u21 = true;

        return;
    end;

    for _, child in MusicTracks:GetChildren() do
        if child:IsA("Folder") then
            for _, child2 in child:GetChildren() do
                if child2:IsA("Sound") and child2.IsPlaying then
                    dbg("  CURRENTLY PLAYING:", child2.Name, "in", child.Name, "| vol:", string.format("%.3f", child2.Volume));
                end;
            end;
        end;
    end;

    p65:_SetFolder((p65:_ResolveTargetFolder()));
end;

function v2._QueueRefresh(u66) -- Line: 531
    -- upvalues: dbg (copy), u19 (ref)
    dbg("_QueueRefresh called | already queued:", u19);

    if u19 then
        return;
    end;

    u19 = true;
    task.defer(function() -- Line: 538
        -- upvalues: dbg (ref), u19 (ref), u66 (copy)
        dbg("_QueueRefresh deferred fire");
        u19 = false;
        u66:_Refresh();
    end);
end;

function v2._HookWeatherFolder(u67, u68) -- Line: 545
    -- upvalues: dbg (copy)
    local Playing = u68:FindFirstChild("Playing");

    if not (Playing and Playing:IsA("BoolValue")) then
        return;
    end;

    dbg("Hooking weather folder:", u68.Name);
    Playing.Changed:Connect(function() -- Line: 552
        -- upvalues: dbg (ref), u68 (copy), Playing (copy), u67 (copy)
        dbg("Playing.Changed on weather folder:", u68.Name, "| new value:", Playing.Value);
        u67:_QueueRefresh();
    end);
end;

function v2.SetActiveWeather(p69, p70) -- Line: 558
    -- upvalues: dbg (copy), u18 (ref)
    dbg("=== SetActiveWeather:", tostring(p70), "| previous timeCycle:", tostring(u18), "===");
    u18 = p70;
    p69:_QueueRefresh();
end;

function v2.SetCutsceneMuted(p71, p72) -- Line: 567
    -- upvalues: dbg (copy), u20 (ref), cancelTweens (copy), u7 (ref), stopAllExcept (copy), u4 (copy), u14 (ref), tweenVolume (copy), u21 (ref)
    dbg("=== SetCutsceneMuted:", p72, "===");

    if u20 == p72 then
        return;
    end;

    u20 = p72;

    if p72 then
        cancelTweens();

        if u7 and u7.IsPlaying then
            u7:Pause();
        end;

        stopAllExcept(u7);

        return;
    end;

    local v73 = u7;
    local v74 = false;

    if v73 and not v73.IsPlaying then
        if v73.TimeLength <= 0 or v73.TimePosition < v73.TimeLength then
            local v75 = u4[v73] or v73.Volume;
            v73:Resume();
            u14 = tweenVolume(v73, v75, 1);
            v74 = v73.IsPlaying;
        end;
    else
        v74 = v73 and v73.IsPlaying and true or v74;
    end;

    if v74 then
        if u21 then
            u21 = false;
            p71:_QueueRefresh();
        end;

        return;
    end;

    dbg("  paused track dead/finished, clearing and refreshing");
    u7 = nil;
    u21 = false;
    p71:_QueueRefresh();
end;

local function buildPartyFolder() -- Line: 623
    -- upvalues: MusicTracks (copy), SoundService (copy), PartyConfig (copy), dbg (copy)
    local AdminParty = MusicTracks:FindFirstChild("AdminParty");

    if AdminParty and AdminParty:IsA("Folder") then
        return AdminParty;
    end;

    local Master = SoundService:FindFirstChild("Master");

    if Master then
        Master = Master:FindFirstChild("GameMusic");
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "AdminParty";

    for _, v in PartyConfig.MusicTracks do
        local Sound = Instance.new("Sound");
        Sound.Name = v.Name;
        Sound.SoundId = `rbxassetid://{v.AssetId}`;
        Sound.Looped = false;
        Sound.Volume = PartyConfig.MusicVolume;

        if Master and Master:IsA("SoundGroup") then
            Sound.SoundGroup = Master;
        end;

        Sound.Parent = Folder;
    end;

    Folder.Parent = MusicTracks;
    dbg("buildPartyFolder: created", "AdminParty", "with", #PartyConfig.MusicTracks, "tracks");

    return Folder;
end;

function v2.Init(p76) -- Line: 653
    -- upvalues: u8 (ref), buildPartyFolder (copy)
    u8 = buildPartyFolder();
end;

function v2.Start(u77) -- Line: 657
    -- upvalues: dbg (copy), WeatherValues (copy), MusicTracks (copy)
    dbg("=== MusicController:Start ===");
    workspace:GetAttributeChangedSignal("InAdminParty"):Connect(function() -- Line: 660
        -- upvalues: dbg (ref), u77 (copy)
        dbg("InAdminParty changed:", workspace:GetAttribute("InAdminParty"));
        u77:_QueueRefresh();
    end);
    workspace:GetAttributeChangedSignal("InDisco"):Connect(function() -- Line: 665
        -- upvalues: dbg (ref), u77 (copy)
        dbg("InDisco changed:", workspace:GetAttribute("InDisco"));
        u77:_QueueRefresh();
    end);

    for _, child in WeatherValues:GetChildren() do
        if child:IsA("Folder") then
            u77:_HookWeatherFolder(child);
        end;
    end;

    WeatherValues.ChildAdded:Connect(function(p78) -- Line: 676
        -- upvalues: dbg (ref), u77 (copy)
        if p78:IsA("Folder") then
            dbg("WeatherValues.ChildAdded:", p78.Name);
            u77:_HookWeatherFolder(p78);
            u77:_QueueRefresh();
        end;
    end);
    MusicTracks.ChildAdded:Connect(function(p79) -- Line: 684
        -- upvalues: dbg (ref), u77 (copy)
        dbg("MusicTracks.ChildAdded:", p79.Name);
        u77:_QueueRefresh();
    end);
    MusicTracks.ChildRemoved:Connect(function(p80) -- Line: 688
        -- upvalues: dbg (ref), u77 (copy)
        dbg("MusicTracks.ChildRemoved:", p80.Name);
        u77:_QueueRefresh();
    end);
    u77:_QueueRefresh();
end;

return v2;