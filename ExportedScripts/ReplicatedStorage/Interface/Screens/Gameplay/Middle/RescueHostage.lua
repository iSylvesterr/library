-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local LocalPlayer = Players.LocalPlayer;
local u2 = Color3.fromRGB(219, 159, 47);
local u3 = Color3.fromRGB(43, 172, 43);
local u4 = Color3.fromRGB(182, 45, 45);
local u5 = nil;
local u6 = nil;

local function formatTime(p7) -- Line: 80
    local v8 = math.floor(p7 / 60);
    local v9 = p7 % 60;
    local v10 = math.floor(v9);
    local v11 = math.floor((v9 - v10) * 1000);

    return string.format("%02d:%02d.%03d", v8, v10, v11);
end;

local function getBackgroundColor(p12) -- Line: 91
    -- upvalues: u4 (copy), u2 (copy), u3 (copy)
    local v13 = math.clamp(p12, 0, 1);

    if v13 <= 0.5 then
        return u4:Lerp(u2, v13 * 2);
    end;

    return u2:Lerp(u3, (v13 - 0.5) * 2);
end;

function u1.InitializeProgressBar(p14) -- Line: 108
    -- upvalues: u4 (copy)
    if not (p14.Frame and p14.Frame.ProgressBar) then
        warn("RescueHostage: Frame or ProgressBar not found");

        return;
    end;

    local ProgressBar = p14.Frame.ProgressBar;
    local LeftGradient = ProgressBar:FindFirstChild("LeftGradient");
    local RightGradient = ProgressBar:FindFirstChild("RightGradient");
    local ProgressBarImage = LeftGradient:FindFirstChild("ProgressBarImage");
    local ProgressBarImage2 = RightGradient:FindFirstChild("ProgressBarImage");
    local UIGradient = ProgressBarImage:FindFirstChild("UIGradient");
    local UIGradient2 = ProgressBarImage2:FindFirstChild("UIGradient");
    p14.LeftProgressImage = ProgressBarImage;
    p14.RightProgressImage = ProgressBarImage2;
    p14.LeftGradient = UIGradient;
    p14.RightGradient = UIGradient2;
    ProgressBarImage.ImageColor3 = u4;
    ProgressBarImage2.ImageColor3 = u4;
    ProgressBarImage.ImageTransparency = 0;
    ProgressBarImage2.ImageTransparency = 0;
    LeftGradient.Visible = true;
    RightGradient.Visible = true;
    ProgressBarImage.Visible = true;
    ProgressBarImage2.Visible = true;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.501, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.501, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Rotation = 0;
    UIGradient2.Rotation = 0;
end;

function u1.UpdateProgressBar(p15, p16) -- Line: 170
    -- upvalues: u4 (copy), u2 (copy), u3 (copy)
    if not (p15.Frame and p15.Frame.ProgressBar) then
        return;
    end;

    if not (p15.LeftGradient and p15.RightGradient) then
        return;
    end;

    if not (p15.LeftProgressImage and p15.RightProgressImage) then
        return;
    end;

    local v17 = math.clamp(p16, 0, 1);
    local v18 = math.clamp(v17, 0, 1);
    local v19;

    if v18 <= 0.5 then
        v19 = u4:Lerp(u2, v18 * 2);
    else
        v19 = u2:Lerp(u3, (v18 - 0.5) * 2);
    end;

    p15.LeftProgressImage.ImageColor3 = v19;
    p15.RightProgressImage.ImageColor3 = v19;
    local v20 = v17 * 180;
    p15.RightGradient.Rotation = 360 - v20;
    p15.LeftGradient.Rotation = v20 + 180;
    p15:AnimateRescue(v17);

    if p15.Frame.UIGradient then
        local v21 = math.clamp(v17, 0, 1);
        local v22;

        if v21 <= 0.5 then
            v22 = u4:Lerp(u2, v21 * 2);
        else
            v22 = u2:Lerp(u3, (v21 - 0.5) * 2);
        end;

        local v23 = v22:Lerp(Color3.new(0, 0, 0), 0.3);
        p15.Frame.UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v22), ColorSequenceKeypoint.new(1, v23) });
    end;

    local v24 = math.clamp(v17, 0, 1);
    local v25;

    if v24 <= 0.5 then
        v25 = u4:Lerp(u2, v24 * 2);
    else
        v25 = u2:Lerp(u3, (v24 - 0.5) * 2);
    end;

    local v26 = v25:Lerp(Color3.new(0, 0, 0), 0.2);

    if p15.Frame.Frame1 then
        p15.Frame.Frame1.BackgroundColor3 = v26;
    end;

    if p15.Frame.Frame2 then
        p15.Frame.Frame2.BackgroundColor3 = v26;
    end;
end;

function u1.AnimateRescue(p27, p28) -- Line: 214
    if not (p27.Frame and p27.Frame.ProgressBar) then
        return;
    end;

    local Hostage = p27.Frame.ProgressBar:FindFirstChild("Hostage");

    if not Hostage then
        return;
    end;

    local v29 = tick() * (p28 * 0.5 + 0.5) * 3.141592653589793 * 2;
    local v30 = math.sin(v29);
    local v31 = Vector2.new(0.85, 0.85);
    local v32 = v30 * 0.05 + 1;
    local v33 = UDim2.new(v31.X * v32, 0, v31.Y * v32, 0);
    local v34 = Color3.fromRGB(255, 200, 0):Lerp(Color3.fromRGB(255, 255, 255), (v30 + 1) / 2);
    Hostage.Size = v33;
    Hostage.ImageColor3 = v34;
end;

function u1.UpdateTimer(p35, p36) -- Line: 257
    if not (p35.Frame and p35.Frame.Timer) then
        return;
    end;

    local Timer = p35.Frame.Timer;
    local v37 = math.floor(p36 / 60);
    local v38 = p36 % 60;
    local v39 = math.floor(v38);
    local v40 = math.floor((v38 - v39) * 1000);
    Timer.Text = string.format("%02d:%02d.%03d", v37, v39, v40);
    p35.Frame.Timer.TextStrokeColor3 = Color3.new(0, 0, 0);
    p35.Frame.Timer.TextColor3 = Color3.new(1, 1, 1);
    p35.Frame.Timer.TextStrokeTransparency = 0;
end;

function u1.UpdateTitle(p41) -- Line: 273
    if not (p41.Frame and p41.Frame.Title) then
        return;
    end;

    p41.Frame.Title.Text = string.format("%s is rescuing the hostage %s a kit.", p41.PlayerName, p41.HasRescueKit and "with" or "without");
    p41.Frame.Title.TextStrokeColor3 = Color3.new(0, 0, 0);
    p41.Frame.Title.TextColor3 = Color3.new(1, 1, 1);
    p41.Frame.Title.TextStrokeTransparency = 0;
end;

function u1.StartRescue(u42, p43) -- Line: 292
    -- upvalues: LocalPlayer (copy), SpectateController (copy), RunServiceController (copy), Remotes (copy)
    if u42.IsRescuing then
        return;
    end;

    local v44 = LocalPlayer:GetAttribute("IsSpectating");
    local v45 = SpectateController.GetCurrentSpectateInstance();
    local v46 = p43 or (v44 and (v45 and v45.Player) or LocalPlayer);
    u42.HasRescueKit = v46:GetAttribute("HasRescueKit");
    u42.PlayerName = v46.Name;
    u42.RescueTime = u42.HasRescueKit and 1 or 4;
    local v47 = v46:GetAttribute("RescueStartTime");

    if v47 and (v44 or v46 ~= LocalPlayer) then
        local v48 = tick();

        if v47 <= v48 and v48 - v47 <= u42.RescueTime then
            u42.RescueStartTime = v47;
        else
            u42.RescueStartTime = v48;
        end;
    else
        u42.RescueStartTime = tick();
    end;

    u42.RescueProgress = 0;
    u42.IsRescuing = true;

    if u42.Frame then
        u42.Frame.Visible = true;
    end;

    u42:UpdateProgressBar(0);
    u42:UpdateTimer(u42.RescueTime);
    u42:UpdateTitle();
    u42.Janitor:Add(RunServiceController.BindToHeartbeat("UI.RescueHostage.UpdateProgress", function() -- Line: 338
        -- upvalues: u42 (copy), LocalPlayer (ref), SpectateController (ref)
        if not u42.IsRescuing or u42.IsFinished then
            return;
        end;

        local v49 = LocalPlayer:GetAttribute("IsSpectating");
        local v50 = SpectateController.GetCurrentSpectateInstance();

        if v49 then
            if v50 then
                v49 = u42.PlayerName ~= LocalPlayer.Name;
            else
                v49 = v50;
            end;
        end;

        if v49 and v50 then
            local Player = v50.Player;

            if not Player:GetAttribute("IsRescuingHostage") then
                if u42.RescueProgress >= 0.95 then
                    u42:FinishRescue();

                    return;
                end;

                u42:CancelRescue();

                return;
            end;

            local v51 = Player:GetAttribute("RescueStartTime");

            if v51 then
                local v52 = tick();

                if v51 < u42.RescueStartTime and (v51 <= v52 and v52 - v51 <= u42.RescueTime) then
                    u42.RescueStartTime = v51;
                end;
            end;
        end;

        local v53 = tick() - u42.RescueStartTime;
        u42.RescueProgress = math.min(v53 / u42.RescueTime, 1);
        local v54 = math.max(u42.RescueTime - v53, 0);
        u42:UpdateProgressBar(u42.RescueProgress);
        u42:UpdateTimer(v54);

        if u42.RescueProgress < 1 or (u42.IsFinished or v49) then
            return;
        end;

        u42:FinishRescue();
    end), "Disconnect", "ProgressConnection");

    if not v44 or v46 == LocalPlayer then
        Remotes.Hostage.StartRescue.Send();
    end;

    u42.RescueStarted:Fire();
end;

function u1.CancelRescue(u55) -- Line: 411
    -- upvalues: LocalPlayer (copy), SpectateController (copy), Remotes (copy)
    if not u55.IsRescuing then
        return;
    end;

    local v56 = LocalPlayer:GetAttribute("IsSpectating");
    local v57 = SpectateController.GetCurrentSpectateInstance();

    if v56 then
        if v57 then
            v57 = u55.PlayerName ~= LocalPlayer.Name;
        end;
    else
        v57 = v56;
    end;

    u55.IsRescuing = false;
    u55.IsFinished = true;
    u55:UpdateProgressBar(0);

    if u55.Frame then
        u55.Frame.Visible = false;
    end;

    if not v57 then
        Remotes.Hostage.CancelRescue.Send();
    end;

    u55.RescueCancelled:Fire();
    task.defer(function() -- Line: 440
        -- upvalues: u55 (copy)
        u55:Destroy();
    end);
end;

function u1.FinishRescue(u58) -- Line: 447
    -- upvalues: LocalPlayer (copy), SpectateController (copy), Remotes (copy)
    if not u58.IsRescuing or u58.IsFinished then
        return;
    end;

    local v59 = LocalPlayer:GetAttribute("IsSpectating");
    local v60 = SpectateController.GetCurrentSpectateInstance();

    if v59 then
        if v60 then
            v60 = u58.PlayerName ~= LocalPlayer.Name;
        end;
    else
        v60 = v59;
    end;

    u58.IsFinished = true;
    u58.IsRescuing = false;

    if not v60 then
        Remotes.Hostage.PickedUp.Send();
    end;

    u58.RescueFinished:Fire();
    task.delay(0.5, function() -- Line: 470
        -- upvalues: u58 (copy)
        u58:Destroy();
    end);
end;

function u1.new(p61) -- Line: 478
    -- upvalues: u1 (copy), Janitor (copy), Signal (copy)
    local v62 = setmetatable({}, u1);
    v62.Janitor = Janitor.new();
    v62.Frame = p61;
    v62.RightProgressImage = nil;
    v62.LeftProgressImage = nil;
    v62.RightGradient = nil;
    v62.LeftGradient = nil;
    v62.RescueTime = 4;
    v62.HasRescueKit = false;
    v62.RescueStartTime = 0;
    v62.RescueProgress = 0;
    v62.IsRescuing = false;
    v62.IsFinished = false;
    v62.PlayerName = "";
    v62.RescueCancelled = v62.Janitor:Add(Signal.new());
    v62.RescueFinished = v62.Janitor:Add(Signal.new());
    v62.RescueStarted = v62.Janitor:Add(Signal.new());

    if v62.Frame then
        v62.Frame.Visible = false;
    end;

    v62:InitializeProgressBar();

    return v62;
end;

function u1.Destroy(p63) -- Line: 522
    -- upvalues: u6 (ref)
    if u6 == p63 then
        u6 = nil;
    end;

    if p63.Frame then
        p63.Frame.Visible = false;
    end;

    p63.Janitor:Destroy();
end;

function u1.Initialize(p64, p65) -- Line: 540
    -- upvalues: u5 (ref), GameState (copy), u6 (ref), Router (copy), u1 (copy), LocalPlayer (copy), SpectateController (copy)
    u5 = p65;
    GameState.ListenToState(function(p66, p67) -- Line: 544
        -- upvalues: u6 (ref)
        if (p67 == "Buy Period" or p67 == "Warmup") and u6 then
            u6:Destroy();
            u6 = nil;
        end;
    end);
    Router.observerRouter("Start Rescue Hostage", function() -- Line: 554
        -- upvalues: u6 (ref), u1 (ref), u5 (ref)
        if not u6 then
            u6 = u1.new(u5);
        end;

        if u6 then
            u6:StartRescue();
        end;

        return nil;
    end);
    Router.observerRouter("Cancel Rescue Hostage", function() -- Line: 567
        -- upvalues: u6 (ref)
        if u6 then
            u6:CancelRescue();
            u6 = nil;
        end;

        return nil;
    end);
    local u68 = nil;

    local function updateSpectateRescue() -- Line: 580
        -- upvalues: LocalPlayer (ref), SpectateController (ref), u6 (ref), u1 (ref), u5 (ref)
        local v69 = LocalPlayer:GetAttribute("IsSpectating");
        local v70 = SpectateController.GetCurrentSpectateInstance();

        if v69 and v70 then
            local Player = v70.Player;

            if Player:GetAttribute("IsRescuingHostage") then
                if not u6 then
                    u6 = u1.new(u5);
                end;

                if u6 then
                    u6:StartRescue(Player);
                end;
            elseif u6 then
                u6:CancelRescue();
                u6 = nil;
            end;
        elseif u6 and not LocalPlayer:GetAttribute("IsRescuingHostage") then
            u6:CancelRescue();
            u6 = nil;
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 613
        -- upvalues: updateSpectateRescue (copy)
        updateSpectateRescue();
    end);

    local function setupSpectateRescueListener() -- Line: 618
        -- upvalues: u68 (ref), SpectateController (ref), updateSpectateRescue (copy)
        if u68 then
            u68:Disconnect();
            u68 = nil;
        end;

        local v71 = SpectateController.GetCurrentSpectateInstance();

        if v71 then
            u68 = v71.Player:GetAttributeChangedSignal("IsRescuingHostage"):Connect(function() -- Line: 626
                -- upvalues: updateSpectateRescue (ref)
                updateSpectateRescue();
            end);
            updateSpectateRescue();
        end;
    end;

    SpectateController.ListenToSpectate:Connect(function(p72) -- Line: 635
        -- upvalues: setupSpectateRescueListener (copy)
        setupSpectateRescueListener();
    end);
    task.wait(0.1);
    setupSpectateRescueListener();
end;

return u1;