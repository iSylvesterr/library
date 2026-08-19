-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local AreaEggResetTimeUtil = require(ReplicatedStorage.Library.Util.AreaEggResetTimeUtil);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local AreaEggResetCycle = require(ReplicatedStorage.Directory.AreaEggResetCycle);
local FormatDurationSymbol = require(ReplicatedStorage.Library.Functions.FormatDurationSymbol);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = Color3.fromRGB(255, 64, 64);
local v2 = GUI.GameResetTimer();
local u3 = GUI.TutorialInstructions();
local v4 = u3:IsA("ScreenGui");
assert(v4, "TutorialInstructions must be a ScreenGui");
local TimeLeft = v2.TimeLeft;
local EndingSoon = v2.EndingSoon;
local TextLabel = TimeLeft.Main.TextLabel;
local TextLabel2 = EndingSoon.Main.TextLabel;
local ImageLabel = TimeLeft.Main.Frame.ImageLabel;
local ImageLabel2 = EndingSoon.Main.Frame.ImageLabel;
local TextColor3 = TextLabel.TextColor3;
local TextColor32 = TextLabel2.TextColor3;
local u5 = -1;
local u6 = AreaEggResetTimeUtil.GetPeriodIndex(Workspace:GetServerTimeNow());
local u7 = false;
local u8 = false;
local Enabled = u3.Enabled;
local u9 = false;
local u10 = false;
local Enabled2 = u3.Enabled;

if Constants.IS_MOBILE then
    TimeLeft.Position = UDim2.fromScale(0.89, TimeLeft.Position.Y.Scale);
end;

local function getBlinkColor(p11, p12, p13) -- Line: 64
    -- upvalues: AreaEggResetTimeUtil (copy), u1 (copy)
    if p12 or not (AreaEggResetTimeUtil.IsFinalBlinkWindow(p11) and AreaEggResetTimeUtil.IsBlinkRed(p11)) then
        return p13;
    end;

    return u1;
end;

local function setNormalTimer(p14, p15, p16) -- Line: 76
    -- upvalues: TimeLeft (copy), EndingSoon (copy), TextLabel (copy), TextColor3 (copy), AreaEggResetTimeUtil (copy), u1 (copy), TextLabel2 (copy), TextColor32 (copy)
    TimeLeft.Visible = true;
    EndingSoon.Visible = false;
    TextLabel.Text = p16;
    local v17 = TextColor3;

    if not p15 and (AreaEggResetTimeUtil.IsFinalBlinkWindow(p14) and AreaEggResetTimeUtil.IsBlinkRed(p14)) then
        v17 = u1;
    end;

    TextLabel.TextColor3 = v17;
    TextLabel2.TextColor3 = TextColor32;
end;

local function setEndingSoonTimer(p18, p19, p20) -- Line: 84
    -- upvalues: TimeLeft (copy), EndingSoon (copy), TextLabel2 (copy), TextLabel (copy), TextColor3 (copy), TextColor32 (copy), AreaEggResetTimeUtil (copy), u1 (copy)
    TimeLeft.Visible = false;
    EndingSoon.Visible = true;
    TextLabel2.Text = p20;
    TextLabel.TextColor3 = TextColor3;
    local v21 = TextColor32;

    if not p19 and (AreaEggResetTimeUtil.IsFinalBlinkWindow(p18) and AreaEggResetTimeUtil.IsBlinkRed(p18)) then
        v21 = u1;
    end;

    TextLabel2.TextColor3 = v21;
end;

local function refreshTimer(p22) -- Line: 92
    -- upvalues: Workspace (copy), AreaEggResetTimeUtil (copy), u5 (ref), u6 (ref), u9 (ref), u7 (ref), u10 (ref), u8 (ref), Enabled2 (ref), Enabled (ref), AreaEggResetCycle (copy), ImageLabel (copy), ImageLabel2 (copy), FormatDurationSymbol (copy), TimeLeft (copy), EndingSoon (copy), TextLabel2 (copy), TextLabel (copy), TextColor3 (copy), TextColor32 (copy), u1 (copy)
    local v23 = Workspace:GetServerTimeNow();
    local v24 = AreaEggResetTimeUtil.GetActivePeriodIndex(v23);
    local v25 = AreaEggResetTimeUtil.IsNight(v23);
    local v26 = AreaEggResetTimeUtil.GetPhaseTimeLeft(v23);
    local v27 = math.ceil(v26);

    if not p22 and (v27 == u5 and (v24 == u6 and (u9 == u7 and (u10 == u8 and Enabled2 == Enabled)))) then
        return;
    end;

    u5 = v27;
    u6 = v24;
    u7 = u9;
    u8 = u10;
    Enabled = Enabled2;
    local v28;

    if v25 then
        v28 = AreaEggResetCycle.SunIcon;
    else
        v28 = AreaEggResetCycle.MoonIcon;
    end;

    ImageLabel.Image = v28;
    ImageLabel2.Image = v28;
    local v29 = "in " .. FormatDurationSymbol(v27);

    if v25 or (not AreaEggResetTimeUtil.IsEndingSoon(v27) or (u9 or (u10 or Enabled2))) then
        TimeLeft.Visible = true;
        EndingSoon.Visible = false;
        TextLabel.Text = v29;
        local v30 = TextColor3;

        if not v25 and (AreaEggResetTimeUtil.IsFinalBlinkWindow(v27) and AreaEggResetTimeUtil.IsBlinkRed(v27)) then
            v30 = u1;
        end;

        TextLabel.TextColor3 = v30;
        TextLabel2.TextColor3 = TextColor32;

        return;
    end;

    TimeLeft.Visible = false;
    EndingSoon.Visible = true;
    TextLabel2.Text = v29;
    TextLabel.TextColor3 = TextColor3;
    local v31 = TextColor32;

    if not v25 and (AreaEggResetTimeUtil.IsFinalBlinkWindow(v27) and AreaEggResetTimeUtil.IsBlinkRed(v27)) then
        v31 = u1;
    end;

    TextLabel2.TextColor3 = v31;
end;

refreshTimer();
EggCmds.AreaEggCarryStateChanged:Connect(function(p32) -- Line: 136
    -- upvalues: u9 (ref), refreshTimer (copy)
    u9 = p32.IsCarrying;
    refreshTimer(true);
end);
Network.Fired(Constants.NETWORK_MAP.Treadmills.ACTIVE_TREADMILL_EVENT):Connect(function(p33) -- Line: 141
    -- upvalues: u10 (ref), refreshTimer (copy)
    u10 = p33 ~= nil;
    refreshTimer(true);
end);
u3:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 146
    -- upvalues: Enabled2 (ref), u3 (copy), refreshTimer (copy)
    Enabled2 = u3.Enabled;
    refreshTimer(true);
end);
RunService.Heartbeat:Connect(function(p34) -- Line: 151
    -- upvalues: refreshTimer (copy)
    refreshTimer();
end);