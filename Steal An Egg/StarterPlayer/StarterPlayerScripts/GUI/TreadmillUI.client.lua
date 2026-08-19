-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
require(ReplicatedStorage.Library.Types.AreaEggs);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local FormatDurationSymbol = require(ReplicatedStorage.Library.Functions.FormatDurationSymbol);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Save = require(ReplicatedStorage.Library.Client.Save);
local SettingsCmds = require(ReplicatedStorage.Library.Client.SettingsCmds);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local Treadmills = require(ReplicatedStorage.Directory.Treadmills);
local Trails = require(ReplicatedStorage.Directory.Trails);
local UpdateTextAndShadow = require(ReplicatedStorage.Library.Functions.UpdateTextAndShadow);
local SpeedGainAnimation = require(ReplicatedStorage.Library.Client.GUIFX.SpeedGainAnimation);
local SpeedPowerProjection = require(ReplicatedStorage.Library.Client.SpeedPowerProjection);
local TreadmillCharacterPresentationController = require(script.Parent.Parent.Game.Plots.TreadmillCharacterPresentationController);
local TreadmillVideoController = require(ReplicatedStorage.Library.Client.TreadmillVideoController);
require(ReplicatedStorage.Library.Client.TreadmillVideoController.Types.Interface);
local Visibility = require(script.Visibility);
local Treadmills2 = Constants.NETWORK_MAP.Treadmills;
local Treadmills3 = Constants.NETWORK_MAP.Treadmills;
local v1 = GUI.Money();
local CurrentBoost = v1.Bottom.Frame.SpeedValue.CurrentBoost;
local TextColor3 = CurrentBoost.Shadow.TextColor3;
local TemporarySpeedBoost = v1.Bottom.Frame.TemporarySpeedBoost;
local CurrentBoost2 = TemporarySpeedBoost.CurrentBoost;
local u2 = false;
local u3 = nil;
local u4 = 0;
local u5 = 0;
local u6 = nil;
local u7 = 1;

local function updateSpeedPower() -- Line: 64
    -- upvalues: Save (copy), SpeedPowerProjection (copy), TreadmillUtil (copy), u7 (ref), Workspace (copy), TextColor3 (copy), Trails (copy), UpdateTextAndShadow (copy), CurrentBoost (copy)
    local v8 = Save.Get();

    if not v8 then
        return;
    end;

    local v9 = SpeedPowerProjection.GetSpeedPower();
    local v10 = TreadmillUtil.ResolveEffectiveSpeedPower(v9, u7);
    local v11 = TreadmillUtil.FormatSpeedPower((math.floor(v10)));
    local v12 = TreadmillUtil.ResolveSpeedBoostSpeedStepMultiplier(v8);
    local v13 = TreadmillUtil.ResolveTemporarySpeedBoostSpeedStepMultiplier(v8, Workspace:GetServerTimeNow());
    local v14 = TreadmillUtil.ResolveAdditiveSpeedStepMultiplier(v12, v13);
    local v15 = TextColor3;
    local EquippedTrail = v8.EquippedTrail;

    if EquippedTrail ~= nil and (Trails.Types.TrailNameExists(EquippedTrail) and v8.TrailInventory[EquippedTrail]) then
        v15 = Trails.Directory[EquippedTrail].Rarity.Color;
    end;

    local v16;

    if TreadmillUtil.DEFAULT_SPEED_STEP_MULTIPLIER < v14 then
        local v17 = TreadmillUtil.FormatSpeedMultiplierValue(v14);
        v16 = v11 .. ` ({v17})`;
        v11 = v11 .. ` <font color="#00FF00">({v17})</font>`;
    else
        v16 = nil;
    end;

    UpdateTextAndShadow(CurrentBoost, v11, v15, v16);
end;

local function updateTemporarySpeedBoostDisplay() -- Line: 97
    -- upvalues: Save (copy), TreadmillUtil (copy), Workspace (copy), TemporarySpeedBoost (copy), CurrentBoost2 (copy), FormatDurationSymbol (copy)
    local v18 = Save.Get();
    local v19 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v18, Workspace:GetServerTimeNow());

    if v19 <= 0 then
        TemporarySpeedBoost.Visible = false;

        return false;
    end;

    TemporarySpeedBoost.Visible = true;
    CurrentBoost2.Text = `X2 Speed ({FormatDurationSymbol(v19)})`;

    return true;
end;

local function startTemporarySpeedBoostCountdown() -- Line: 111
    -- upvalues: u5 (ref), Save (copy), TreadmillUtil (copy), Workspace (copy), TemporarySpeedBoost (copy), CurrentBoost2 (copy), FormatDurationSymbol (copy), updateSpeedPower (copy)
    u5 = u5 + 1;
    local u20 = u5;
    local v21 = Save.Get();
    local v22 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v21, Workspace:GetServerTimeNow());
    local v23;

    if v22 <= 0 then
        TemporarySpeedBoost.Visible = false;
        v23 = false;
    else
        TemporarySpeedBoost.Visible = true;
        CurrentBoost2.Text = `X2 Speed ({FormatDurationSymbol(v22)})`;
        v23 = true;
    end;

    if not v23 then
        return;
    end;

    task.spawn(function() -- Line: 119
        -- upvalues: u20 (copy), u5 (ref), Save (ref), TreadmillUtil (ref), Workspace (ref), TemporarySpeedBoost (ref), CurrentBoost2 (ref), FormatDurationSymbol (ref), updateSpeedPower (ref)
        while u20 == u5 do
            task.wait(1);
            local v24 = Save.Get();
            local v25 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v24, Workspace:GetServerTimeNow());
            local v26;

            if v25 <= 0 then
                TemporarySpeedBoost.Visible = false;
                v26 = false;
            else
                TemporarySpeedBoost.Visible = true;
                CurrentBoost2.Text = `X2 Speed ({FormatDurationSymbol(v25)})`;
                v26 = true;
            end;

            if not v26 then
                updateSpeedPower();

                return;
            end;

            updateSpeedPower();
        end;
    end);
end;

local function stopActiveTreadmillVisualSimulation() -- Line: 131
    -- upvalues: u6 (ref), SpeedPowerProjection (copy), u4 (ref)
    local v27 = u6;

    if v27 ~= nil then
        SpeedPowerProjection.EndSession(v27.Token);
    end;

    u4 = u4 + 1;
    u6 = nil;
end;

local function applyTreadmillVideoSetting(p28) -- Line: 140
    -- upvalues: u3 (ref), SettingsCmds (copy), TreadmillVideoController (copy), Save (copy)
    local v29 = u3;

    if v29 == nil or SettingsCmds.IsEnabled("DisableVideos") then
        TreadmillVideoController.Stop();

        return;
    end;

    if p28 ~= nil then
        TreadmillVideoController.Start(v29, p28);

        return;
    end;

    local v30 = Save.Get();
    assert(v30 ~= nil, "Save data must be loaded before enabling treadmill videos");
    TreadmillVideoController.Start(v29, v30.TreadmillMediaFeedState);
end;

local function resolveCurrentSpeedPowerPerStep(p31, p32) -- Line: 157
    -- upvalues: TreadmillUtil (copy), Save (copy)
    return TreadmillUtil.ResolveSpeedPowerPerStep(Save.Get(), p31, p32);
end;

local function flushPendingScreenSpeedGain(u33) -- Line: 161
    -- upvalues: SpeedGainAnimation (copy), CurrentBoost (copy), SpeedPowerProjection (copy)
    if u33.PendingScreenSpeedPowerDelta <= 0 then
        return;
    end;

    local PendingScreenSpeedPowerDelta = u33.PendingScreenSpeedPowerDelta;
    SpeedGainAnimation.Play(CurrentBoost, PendingScreenSpeedPowerDelta, nil, function() -- Line: 167
        -- upvalues: SpeedPowerProjection (ref), u33 (copy), PendingScreenSpeedPowerDelta (copy)
        SpeedPowerProjection.RevealCompletedGain(u33.Token, PendingScreenSpeedPowerDelta);
    end);
    u33.PendingScreenSpeedPowerDelta = 0;
end;

local function resetNextScreenPopupAt(p34, p35) -- Line: 173
    -- upvalues: TreadmillUtil (copy)
    p34.NextScreenPopupAt = p35 + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL;
end;

local function handleTransparentModeSpeedGainPulse(u36, p37, p38) -- Line: 177
    -- upvalues: SpeedGainAnimation (copy), CurrentBoost (copy), SpeedPowerProjection (copy), TreadmillUtil (copy)
    u36.PendingScreenSpeedPowerDelta = u36.PendingScreenSpeedPowerDelta + p37;

    if u36.NextScreenPopupAt <= p38 then
        if u36.PendingScreenSpeedPowerDelta > 0 then
            local PendingScreenSpeedPowerDelta = u36.PendingScreenSpeedPowerDelta;
            SpeedGainAnimation.Play(CurrentBoost, PendingScreenSpeedPowerDelta, nil, function() -- Line: 167
                -- upvalues: SpeedPowerProjection (ref), u36 (copy), PendingScreenSpeedPowerDelta (copy)
                SpeedPowerProjection.RevealCompletedGain(u36.Token, PendingScreenSpeedPowerDelta);
            end);
            u36.PendingScreenSpeedPowerDelta = 0;
        end;

        u36.NextScreenPopupAt = p38 + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL;
    end;
end;

local function handleVisibleModeSpeedGainPulse(u39, u40, p41) -- Line: 189
    -- upvalues: TreadmillUtil (copy), SpeedGainAnimation (copy), CurrentBoost (copy), SpeedPowerProjection (copy)
    u39.PendingScreenSpeedPowerDelta = 0;
    u39.NextScreenPopupAt = p41 + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL;
    SpeedGainAnimation.PlayWalk(CurrentBoost, u40, u39.RarityColor, function() -- Line: 196
        -- upvalues: SpeedPowerProjection (ref), u39 (copy), u40 (copy)
        SpeedPowerProjection.RevealCompletedGain(u39.Token, u40);
    end);
end;

local function handleServerSpeedGain(p42, p43) -- Line: 201
    -- upvalues: u6 (ref), SpeedPowerProjection (copy), SpeedGainAnimation (copy), CurrentBoost (copy), updateSpeedPower (copy)
    if p43 == "Treadmill" and u6 ~= nil then
        return;
    end;

    if p43 ~= "Instant" or u6 == nil then
        updateSpeedPower();

        if p43 == "Walk" then
            SpeedGainAnimation.PlayWalk(CurrentBoost, p42, nil, updateSpeedPower);

            return;
        end;

        SpeedGainAnimation.Play(CurrentBoost, p42, nil, updateSpeedPower);

        return;
    end;

    local v44 = u6;
    v44.SimulatedSpeedPower = v44.SimulatedSpeedPower + p42;
    local v45 = SpeedPowerProjection.RevealCompletedGain(v44.Token, p42);
    assert(v45, "Instant Speed Power gain must target the active treadmill projection");
    SpeedGainAnimation.Play(CurrentBoost, p42, nil, updateSpeedPower);
end;

local function startActiveTreadmillVisualSimulation(p46, p47, p48) -- Line: 223
    -- upvalues: u6 (ref), SpeedPowerProjection (copy), u4 (ref), Workspace (copy), Save (copy), TreadmillUtil (copy), TreadmillCharacterPresentationController (copy), SpeedGainAnimation (copy), CurrentBoost (copy)
    local v49 = u6;

    if v49 ~= nil then
        SpeedPowerProjection.EndSession(v49.Token);
    end;

    u4 = u4 + 1;
    u6 = nil;
    local v50 = Workspace:GetServerTimeNow();
    local v51 = Save.Get();
    assert(v51 ~= nil, "Save data must be loaded before starting treadmill simulation");
    local u52 = u4;
    u6 = {
        PendingScreenSpeedPowerDelta = 0,
        NextScreenPopupAt = v50 + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL,
        NextSpeedAwardAt = p47,
        RarityColor = p48,
        SimulatedSpeedPower = TreadmillUtil.NormalizeSpeedPower(v51.SpeedPower),
        SpeedMultiplier = p46,
        Token = u52
    };
    SpeedPowerProjection.BeginSession(u52);
    task.spawn(function() -- Line: 245
        -- upvalues: u6 (ref), u52 (copy), Workspace (ref), TreadmillUtil (ref), Save (ref), TreadmillCharacterPresentationController (ref), SpeedGainAnimation (ref), CurrentBoost (ref), SpeedPowerProjection (ref)
        while true do
            local v53 = u6;

            if v53 == nil or v53.Token ~= u52 then
                break;
            end;

            local v54 = Workspace:GetServerTimeNow();
            local v55 = math.max(v53.NextSpeedAwardAt - v54, 0);

            if v55 > 0 then
                task.wait(v55);
            end;

            local u56 = u6;

            if u56 == nil or u56.Token ~= u52 then
                break;
            end;

            while true do
                local v57 = Workspace:GetServerTimeNow();

                if v57 < u56.NextSpeedAwardAt then
                    break;
                end;

                local NextSpeedAwardAt = u56.NextSpeedAwardAt;
                local SpeedMultiplier = u56.SpeedMultiplier;
                local u58 = TreadmillUtil.ResolveSpeedPowerPerStep(Save.Get(), SpeedMultiplier, NextSpeedAwardAt);
                u56.SimulatedSpeedPower = u56.SimulatedSpeedPower + u58;

                if TreadmillCharacterPresentationController.IsLocalCharacterFullyTransparent() then
                    u56.PendingScreenSpeedPowerDelta = u56.PendingScreenSpeedPowerDelta + u58;

                    if u56.NextScreenPopupAt <= v57 then
                        if u56.PendingScreenSpeedPowerDelta > 0 then
                            local PendingScreenSpeedPowerDelta = u56.PendingScreenSpeedPowerDelta;
                            SpeedGainAnimation.Play(CurrentBoost, PendingScreenSpeedPowerDelta, nil, function() -- Line: 167
                                -- upvalues: SpeedPowerProjection (ref), u56 (copy), PendingScreenSpeedPowerDelta (copy)
                                SpeedPowerProjection.RevealCompletedGain(u56.Token, PendingScreenSpeedPowerDelta);
                            end);
                            u56.PendingScreenSpeedPowerDelta = 0;
                        end;

                        u56.NextScreenPopupAt = v57 + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL;
                    end;
                else
                    u56.PendingScreenSpeedPowerDelta = 0;
                    u56.NextScreenPopupAt = v57 + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL;
                    SpeedGainAnimation.PlayWalk(CurrentBoost, u58, u56.RarityColor, function() -- Line: 196
                        -- upvalues: SpeedPowerProjection (ref), u56 (copy), u58 (copy)
                        SpeedPowerProjection.RevealCompletedGain(u56.Token, u58);
                    end);
                end;

                u56 = u6;

                if u56 == nil or u56.Token ~= u52 then
                    return;
                end;

                local v59 = TreadmillUtil.SpeedPowerToProgressionWalkSpeed(u56.SimulatedSpeedPower);
                u56.NextSpeedAwardAt = NextSpeedAwardAt + TreadmillUtil.ResolveWalkSpeedPowerAwardInterval(v59);
            end;
        end;
    end);
end;

EggCmds.AreaEggCarryStateChanged:Connect(function(p60) -- Line: 290
    -- upvalues: u7 (ref), updateSpeedPower (copy)
    u7 = p60.SpeedMultiplier;
    updateSpeedPower();
end);

if not Save.IsLocalDataLoaded() then
    Save.LoadedStats:Wait();
end;

SpeedGainAnimation.HideTemplate();
TreadmillVideoController.Stop();
TreadmillCharacterPresentationController.StopCameraTransparency();
updateSpeedPower();
u5 = u5 + 1;
local u61 = u5;
local v62 = Save.Get();
local v63 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v62, Workspace:GetServerTimeNow());
local v64;

if v63 <= 0 then
    TemporarySpeedBoost.Visible = false;
    v64 = false;
else
    TemporarySpeedBoost.Visible = true;
    CurrentBoost2.Text = `X2 Speed ({FormatDurationSymbol(v63)})`;
    v64 = true;
end;

if v64 then
    task.spawn(function() -- Line: 119
        -- upvalues: u61 (copy), u5 (ref), Save (copy), TreadmillUtil (copy), Workspace (copy), TemporarySpeedBoost (copy), CurrentBoost2 (copy), FormatDurationSymbol (copy), updateSpeedPower (copy)
        while u61 == u5 do
            task.wait(1);
            local v65 = Save.Get();
            local v66 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v65, Workspace:GetServerTimeNow());
            local v67;

            if v66 <= 0 then
                TemporarySpeedBoost.Visible = false;
                v67 = false;
            else
                TemporarySpeedBoost.Visible = true;
                CurrentBoost2.Text = `X2 Speed ({FormatDurationSymbol(v66)})`;
                v67 = true;
            end;

            if not v67 then
                updateSpeedPower();

                return;
            end;

            updateSpeedPower();
        end;
    end);
end;

SpeedPowerProjection.Changed:Connect(updateSpeedPower);
Save.ConnectForDataChanged("SpeedBoostTierIndex", updateSpeedPower);
Save.ConnectForDataChanged({ "EquippedTrail", "TrailInventory" }, updateSpeedPower);
Save.ConnectForDataChanged("TemporarySpeedBoostRemainingSeconds", function() -- Line: 308
    -- upvalues: updateSpeedPower (copy), u5 (ref), Save (copy), TreadmillUtil (copy), Workspace (copy), TemporarySpeedBoost (copy), CurrentBoost2 (copy), FormatDurationSymbol (copy)
    updateSpeedPower();
    u5 = u5 + 1;
    local u68 = u5;
    local v69 = Save.Get();
    local v70 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v69, Workspace:GetServerTimeNow());
    local v71;

    if v70 <= 0 then
        TemporarySpeedBoost.Visible = false;
        v71 = false;
    else
        TemporarySpeedBoost.Visible = true;
        CurrentBoost2.Text = `X2 Speed ({FormatDurationSymbol(v70)})`;
        v71 = true;
    end;

    if not v71 then
        return;
    end;

    task.spawn(function() -- Line: 119
        -- upvalues: u68 (copy), u5 (ref), Save (ref), TreadmillUtil (ref), Workspace (ref), TemporarySpeedBoost (ref), CurrentBoost2 (ref), FormatDurationSymbol (ref), updateSpeedPower (ref)
        while u68 == u5 do
            task.wait(1);
            local v72 = Save.Get();
            local v73 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v72, Workspace:GetServerTimeNow());
            local v74;

            if v73 <= 0 then
                TemporarySpeedBoost.Visible = false;
                v74 = false;
            else
                TemporarySpeedBoost.Visible = true;
                CurrentBoost2.Text = `X2 Speed ({FormatDurationSymbol(v73)})`;
                v74 = true;
            end;

            if not v74 then
                updateSpeedPower();

                return;
            end;

            updateSpeedPower();
        end;
    end);
end);
Save.ConnectForDataChanged("TemporarySpeedBoostActiveStartedAt", function() -- Line: 312
    -- upvalues: updateSpeedPower (copy), u5 (ref), Save (copy), TreadmillUtil (copy), Workspace (copy), TemporarySpeedBoost (copy), CurrentBoost2 (copy), FormatDurationSymbol (copy)
    updateSpeedPower();
    u5 = u5 + 1;
    local u75 = u5;
    local v76 = Save.Get();
    local v77 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v76, Workspace:GetServerTimeNow());
    local v78;

    if v77 <= 0 then
        TemporarySpeedBoost.Visible = false;
        v78 = false;
    else
        TemporarySpeedBoost.Visible = true;
        CurrentBoost2.Text = `X2 Speed ({FormatDurationSymbol(v77)})`;
        v78 = true;
    end;

    if not v78 then
        return;
    end;

    task.spawn(function() -- Line: 119
        -- upvalues: u75 (copy), u5 (ref), Save (ref), TreadmillUtil (ref), Workspace (ref), TemporarySpeedBoost (ref), CurrentBoost2 (ref), FormatDurationSymbol (ref), updateSpeedPower (ref)
        while u75 == u5 do
            task.wait(1);
            local v79 = Save.Get();
            local v80 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v79, Workspace:GetServerTimeNow());
            local v81;

            if v80 <= 0 then
                TemporarySpeedBoost.Visible = false;
                v81 = false;
            else
                TemporarySpeedBoost.Visible = true;
                CurrentBoost2.Text = `X2 Speed ({FormatDurationSymbol(v80)})`;
                v81 = true;
            end;

            if not v81 then
                updateSpeedPower();

                return;
            end;

            updateSpeedPower();
        end;
    end);
end);
Network.Fired(Treadmills3.SPEED_GAIN_EVENT):Connect(handleServerSpeedGain);
SettingsCmds.Changed:Connect(function(p82) -- Line: 319
    -- upvalues: u3 (ref), SettingsCmds (copy), TreadmillVideoController (copy), Save (copy)
    if p82 == "DisableVideos" then
        local v83 = u3;

        if v83 == nil or SettingsCmds.IsEnabled("DisableVideos") then
            TreadmillVideoController.Stop();

            return;
        end;

        local v84 = Save.Get();
        assert(v84 ~= nil, "Save data must be loaded before enabling treadmill videos");
        TreadmillVideoController.Start(v83, v84.TreadmillMediaFeedState);
    end;
end);
Network.Fired(Treadmills2.ACTIVE_TREADMILL_EVENT):Connect(function(p85, p86, p87, p88) -- Line: 326
    -- upvalues: u3 (ref), u2 (ref), u6 (ref), SpeedPowerProjection (copy), u4 (ref), updateSpeedPower (copy), TreadmillVideoController (copy), TreadmillCharacterPresentationController (copy), Visibility (copy), Treadmills (copy), startActiveTreadmillVisualSimulation (copy), applyTreadmillVideoSetting (copy)
    u3 = p85;
    u2 = false;

    if p85 == nil then
        local v89 = u6;

        if v89 ~= nil then
            SpeedPowerProjection.EndSession(v89.Token);
        end;

        u4 = u4 + 1;
        u6 = nil;
        updateSpeedPower();
        TreadmillVideoController.Stop();
        TreadmillCharacterPresentationController.StopCameraTransparency();
        Visibility.Apply(false);

        return;
    end;

    local v90 = typeof(p86) == "number";
    assert(v90, "Active treadmill speed multiplier must be a number");
    local v91 = typeof(p87) == "number";
    assert(v91, "Active treadmill next award time must be a number");
    local v92 = typeof(p88) == "table";
    assert(v92, "Active treadmill media feed state must be a table");
    local v93, v94 = Treadmills.Types.TreadmillNameExists(p85);
    local v95 = v94 or `Treadmill "{p85}" does not exist`;
    assert(v93, v95);
    local Color = Treadmills.Directory[p85].Rarity.Color;
    updateSpeedPower();
    Visibility.Apply(true);
    startActiveTreadmillVisualSimulation(p86, p87, Color);
    TreadmillCharacterPresentationController.StartCameraTransparency(p85);
    applyTreadmillVideoSetting(p88);
end);
UserInputService.JumpRequest:Connect(function() -- Line: 358
    -- upvalues: u3 (ref), u2 (ref), Network (copy), Treadmills3 (copy)
    if u3 == nil or u2 then
        return;
    end;

    u2 = true;

    if Network.Invoke(Treadmills3.REQUEST_UNEQUIP) ~= true then
        u2 = false;
    end;
end);