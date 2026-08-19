-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Audio = require(ReplicatedStorage.Library.Audio);
local AreaEggResetCycle = require(ReplicatedStorage.Directory.AreaEggResetCycle);
require(ReplicatedStorage.Library.Types.AreaEggResetCycle);
local AreaEggResetTimeUtil = require(ReplicatedStorage.Library.Util.AreaEggResetTimeUtil);
local ChatMsg = require(ReplicatedStorage.Library.Client.ChatMsg);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local NotificationCmds = require(ReplicatedStorage.Library.Client.NotificationCmds);
local AreaEggResetWall = require(ReplicatedStorage.Library.Client.AreaEggResetWall);
local PreloadSounds = require(ReplicatedStorage.Library.Functions.PreloadSounds);
local u1 = TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
local TeleportFadeHoldSeconds = AreaEggResetCycle.TeleportFadeHoldSeconds;
local u2 = TweenInfo.new(AreaEggResetCycle.TeleportFadeSeconds, Enum.EasingStyle.Linear);
local u3 = TweenInfo.new(AreaEggResetCycle.SleepIconFadeSeconds, Enum.EasingStyle.Quad);
local u4 = TweenInfo.new(AreaEggResetCycle.NightIconFadeOutSeconds, Enum.EasingStyle.Quad);
local u5 = Log.new();
local u6 = GUI.FadeFrame();
local u7 = GUI.ResetStartTimer();
local TextLabel = u7.Frame.TextLabel;
local NightTimer = u7.Frame.NightTimer;
local UIStroke = NightTimer.UIStroke;
local SleepIcon = u7.Frame.SleepIcon;
local u8 = GUI.ResetStartTimerLabelScale();
local u9 = 0;
local u10 = nil;
local u11 = 0;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = (-1 / 0);
u7.Adornee = AreaEggResetWall.GetVisualWallPart();
task.spawn(PreloadSounds, 117751546358455, 136029417452204);

local function stopActiveTween() -- Line: 77
    -- upvalues: u10 (ref)
    if u10 ~= nil then
        u10:Cancel();
        u10 = nil;
    end;
end;

local function stopActiveFadeTween() -- Line: 84
    -- upvalues: u12 (ref)
    if u12 ~= nil then
        u12:Cancel();
        u12 = nil;
    end;
end;

local function stopActiveNightVisualTweens() -- Line: 91
    -- upvalues: u13 (ref), u14 (ref), u15 (ref)
    if u13 ~= nil then
        u13:Cancel();
        u13 = nil;
    end;

    if u14 ~= nil then
        u14:Cancel();
        u14 = nil;
    end;

    if u15 ~= nil then
        u15:Cancel();
        u15 = nil;
    end;
end;

local function tweenFadeFrame(p19, p20) -- Line: 106
    -- upvalues: u12 (ref), TweenService (copy), u6 (copy), u2 (copy), u11 (ref)
    if u12 ~= nil then
        u12:Cancel();
        u12 = nil;
    end;

    local v21 = TweenService:Create(u6, u2, {
        BackgroundTransparency = p20
    });
    u12 = v21;
    v21:Play();
    v21.Completed:Wait();

    if p19 ~= u11 then
        return false;
    end;

    u12 = nil;

    return true;
end;

local function runTeleportFade(p22) -- Line: 121
    -- upvalues: tweenFadeFrame (copy), TeleportFadeHoldSeconds (copy), u11 (ref)
    if not tweenFadeFrame(p22, 0) then
        return;
    end;

    task.wait(TeleportFadeHoldSeconds);

    if p22 ~= u11 then
        return;
    end;

    tweenFadeFrame(p22, 1);
end;

local function setCountdownVisible(p23) -- Line: 132
    -- upvalues: TextLabel (copy)
    TextLabel.Visible = p23;
end;

local function tweenNightVisuals(p24, p25) -- Line: 136
    -- upvalues: u13 (ref), u14 (ref), u15 (ref), u4 (copy), u3 (copy), TweenService (copy), SleepIcon (copy), NightTimer (copy), UIStroke (copy), u9 (ref)
    if u13 ~= nil then
        u13:Cancel();
        u13 = nil;
    end;

    if u14 ~= nil then
        u14:Cancel();
        u14 = nil;
    end;

    if u15 ~= nil then
        u15:Cancel();
        u15 = nil;
    end;

    local v26;

    if p25 == 1 then
        v26 = u4;
    else
        v26 = u3;
    end;

    local v27 = TweenService:Create(SleepIcon, v26, {
        ImageTransparency = p25
    });
    local v28 = TweenService:Create(NightTimer, v26, {
        TextTransparency = p25
    });
    local v29 = TweenService:Create(UIStroke, v26, {
        Transparency = p25
    });
    u13 = v27;
    u14 = v28;
    u15 = v29;
    v27:Play();
    v28:Play();
    v29:Play();
    v27.Completed:Wait();

    if p24 ~= u9 then
        return false;
    end;

    u13 = nil;
    u14 = nil;
    u15 = nil;

    return true;
end;

local function animateCount(p30) -- Line: 164
    -- upvalues: u10 (ref), TextLabel (copy), u8 (copy), TweenService (copy), u1 (copy)
    if u10 ~= nil then
        u10:Cancel();
        u10 = nil;
    end;

    TextLabel.Text = tostring(p30);
    u8.Scale = 1.3;
    local v31 = TweenService:Create(u8, u1, {
        Scale = 1
    });
    u10 = v31;
    v31:Play();
end;

local function announceRareSpawns(p32) -- Line: 175
    -- upvalues: ChatMsg (copy), NotificationCmds (copy), EggCmds (copy)
    for _, v in ipairs(p32) do
        ChatMsg.New(v.Message, nil, nil, nil, true, nil);
        NotificationCmds.Message.Top({
            Time = 4,
            Message = v.Message,
            Color = Color3.new(1, 1, 1),
            Sound = v.SoundId
        });
    end;

    EggCmds.AreaEggRareSpawnsPresented:Fire(p32);
end;

local function requestJoinRareSpawnPresentations(u33) -- Line: 188
    -- upvalues: EggCmds (copy), announceRareSpawns (copy), u5 (copy), requestJoinRareSpawnPresentations (copy)
    local v34, v35 = EggCmds.RequestAreaEggRareSpawnPresentations();

    if v34 then
        announceRareSpawns((assert(v35, "Ready rare spawn response must include presentations")));

        return;
    end;

    if u33 >= 30 then
        u5:AtError():Log("Area egg rare spawn join presentation request exhausted profile-readiness retries");

        return;
    end;

    task.delay(1, function() -- Line: 199
        -- upvalues: requestJoinRareSpawnPresentations (ref), u33 (copy)
        requestJoinRareSpawnPresentations(u33 + 1);
    end);
end;

local function runCountdown(p36, p37) -- Line: 204
    -- upvalues: AreaEggResetWall (copy), u7 (copy), TextLabel (copy), NightTimer (copy), Workspace (copy), tweenNightVisuals (copy), u9 (ref), AreaEggResetCycle (copy), NotificationCmds (copy), u17 (ref), announceRareSpawns (copy), Audio (copy), animateCount (copy), u10 (ref), u8 (copy), u18 (ref), u16 (ref)
    AreaEggResetWall.PrepareReveal();
    u7.Enabled = true;
    TextLabel.Visible = false;
    task.spawn(AreaEggResetWall.Reveal);
    local v38 = p37.DayStartsAt - Workspace:GetServerTimeNow();
    local v39 = math.ceil(v38);
    NightTimer.Text = `{math.max(v39, 1)}s`;

    if not tweenNightVisuals(p36, 0) then
        return;
    end;

    while true do
        local v40 = Workspace:GetServerTimeNow();
        local v41 = p37.DayStartsAt - v40;

        if v41 <= 0 then
            break;
        end;

        local v42 = math.ceil(v41);
        NightTimer.Text = `{v42}s`;
        task.wait((math.max(p37.DayStartsAt - (v42 - 1) - v40, 0.05)));

        if p36 ~= u9 then
            return;
        end;
    end;

    if not tweenNightVisuals(p36, 1) then
        return;
    end;

    local wait = task.wait;
    local v43 = p37.DayStartsAt + AreaEggResetCycle.WallCountdownDelayAfterDayStartsSeconds - Workspace:GetServerTimeNow();
    wait((math.max(v43, 0)));

    if p36 ~= u9 then
        return;
    end;

    NotificationCmds.Message.Top({
        Message = "ALL EGG RESET!",
        Time = 3.5
    });
    announceRareSpawns(assert(u17, "Active reset sequence payload must exist when day countdown starts").RareSpawns);
    local v44 = AreaEggResetWall.GetVisualWall();
    local v45 = v44.Position + v44.CFrame.LookVector * (v44.Size.Z / 2);

    for i = AreaEggResetCycle.WallCountdownSeconds, 1, -1 do
        if p36 ~= u9 then
            return;
        end;

        Audio.Play(117751546358455, v45, 1, 2, 220);
        animateCount(i);

        if i == AreaEggResetCycle.WallCountdownSeconds then
            TextLabel.Visible = true;
        end;

        task.wait(1);
    end;

    if p36 == u9 then
        if u10 ~= nil then
            u10:Cancel();
            u10 = nil;
        end;

        u8.Scale = 1;
        Audio.Play(136029417452204, v45, 1, 1.5, 220);
        TextLabel.Visible = false;
        AreaEggResetWall.Collapse();

        if p36 ~= u9 then
            return;
        end;

        u7.Enabled = false;
        u18 = p37.DayStartsAt;
        u16 = nil;
        u17 = nil;
    end;
end;

local function startSequence(p46) -- Line: 273
    -- upvalues: u18 (ref), u16 (ref), u17 (ref), u9 (ref), runCountdown (copy)
    if p46.DayStartsAt <= u18 then
        return;
    end;

    local v47 = u16;

    if v47 ~= nil and p46.DayStartsAt < v47 then
        return;
    end;

    if p46.DayStartsAt == v47 then
        u17 = p46;

        return;
    end;

    u16 = p46.DayStartsAt;
    u17 = p46;
    u9 = u9 + 1;
    task.spawn(runCountdown, u9, p46);
end;

u5:AtDebug():Log("Reset start timer controller initialized");
u7.Enabled = false;
TextLabel.Visible = false;
SleepIcon.ImageTransparency = 1;
NightTimer.TextTransparency = 1;
UIStroke.Transparency = 1;
AreaEggResetWall.Reset();
EggCmds.AreaEggResetTeleportFade:Connect(function() -- Line: 305
    -- upvalues: u11 (ref), runTeleportFade (copy)
    u11 = u11 + 1;
    task.spawn(runTeleportFade, u11);
end);
EggCmds.AreaEggResetStartCountdown:Connect(startSequence);
task.spawn(requestJoinRareSpawnPresentations, 1);
Workspace:GetAttributeChangedSignal("Event_DemonicEvent"):Connect(function() -- Line: 314
    -- upvalues: SleepIcon (copy), Workspace (copy), NightTimer (copy), UIStroke (copy)
    SleepIcon.Image = Workspace:GetAttribute("Event_DemonicEvent") and "rbxassetid://97443431423842" or "rbxassetid://131317614803230";
    NightTimer.TextColor3 = Workspace:GetAttribute("Event_DemonicEvent") and Color3.fromRGB(255, 64, 0) or Color3.fromRGB(83, 83, 83);
    UIStroke.Color = Workspace:GetAttribute("Event_DemonicEvent") and Color3.fromRGB(108, 49, 0) or Color3.fromRGB(0, 0, 0);
end);
SleepIcon.Image = Workspace:GetAttribute("Event_DemonicEvent") and "rbxassetid://97443431423842" or "rbxassetid://131317614803230";
NightTimer.TextColor3 = Workspace:GetAttribute("Event_DemonicEvent") and Color3.fromRGB(255, 64, 0) or Color3.fromRGB(83, 83, 83);
UIStroke.Color = Workspace:GetAttribute("Event_DemonicEvent") and Color3.fromRGB(108, 49, 0) or Color3.fromRGB(0, 0, 0);

if AreaEggResetTimeUtil.IsNight(Workspace:GetServerTimeNow()) then
    local v48 = {
        DayStartsAt = AreaEggResetTimeUtil.GetNextResetAt(Workspace:GetServerTimeNow()),
        RareSpawns = {}
    };

    if v48.DayStartsAt > u18 then
        local v49 = u16;

        if v49 == nil or v48.DayStartsAt >= v49 then
            if v48.DayStartsAt == v49 then
                u17 = v48;
            else
                u16 = v48.DayStartsAt;
                u17 = v48;
                u9 = u9 + 1;
                task.spawn(runCountdown, u9, v48);
            end;
        end;
    end;
end;