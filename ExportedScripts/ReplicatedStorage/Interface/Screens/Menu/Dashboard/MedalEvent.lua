-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local LocalPlayer = Players.LocalPlayer;
local u2 = Constants.EVENT_END_TIMES["MEDAL.TV"];
local u3 = Constants.ACTIVE_EVENTS["MEDAL.TV"];
local u4 = nil;
local u5 = {
    isLinked = false,
    hasClipped = false
};
local u6 = {};
local u7 = 0;

local function IsAvailable() -- Line: 41
    -- upvalues: u3 (copy), u2 (copy)
    local v8 = u3 and os.time() < u2;

    return v8;
end;

local function FormatTimer(p9) -- Line: 47
    local v10 = math.floor(p9 / 86400);
    local v11 = math.floor(p9 % 86400 / 3600);
    local v12 = math.floor(p9 % 3600 / 60);
    local v13 = p9 % 60;

    if v10 >= 1 then
        return string.format("%02i:%02i:%02i:%02i", v10, v11, v12, v13);
    end;

    return string.format("%02i:%02i:%02i", v11, v12, v13);
end;

local function UpdateMissionCard(p14, p15, p16) -- Line: 62
    -- upvalues: TweenService (copy)
    local Bar = p14:FindFirstChild("Bar");
    local v17 = Bar and Bar:FindFirstChild("Frame");

    if v17 then
        local v18 = UDim2.fromScale(p15 and 1 or 0, 1);

        if p16 and p15 then
            v17.Size = UDim2.fromScale(0, 1);
            TweenService:Create(v17, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = v18
            }):Play();
        else
            v17.Size = v18;
        end;
    end;

    local Button = p14:FindFirstChild("Button");

    if Button then
        local Title = Button:FindFirstChild("Title");

        if Title then
            Title.Text = p15 and "COMPLETED" or "REFRESH";
        end;

        Button.Active = not p15;
    end;
end;

local function SetupRefreshButton(p19, u20, u21) -- Line: 93
    -- upvalues: ActivateButton (copy), u7 (ref), Router (copy), Remotes (copy)
    ActivateButton(p19);
    p19.MouseButton1Click:Connect(function() -- Line: 95
        -- upvalues: u21 (copy), u7 (ref), Router (ref), Remotes (ref), u20 (copy)
        if u21() then
            return;
        end;

        local v22 = tick();

        if v22 - u7 < 5 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Please wait before refreshing again.");

            return;
        end;

        u7 = v22;
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        Remotes.Collaborations.RefreshMedalStatus.Send(u20);
    end);
end;

local function UpdateRewardIndicators(p23, p24, p25, p26, p27, p28) -- Line: 114
    -- upvalues: TweenService (copy)
    local Content = p23.Container.Frame.Rewards.Item.Frame.Progress.Content;
    local v29 = Content:FindFirstChild("1");
    local v30 = Content:FindFirstChild("2");

    if v29 then
        local v31 = p24 and 0 or 0.75;

        if p26 and p27 then
            TweenService:Create(v29, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = v31
            }):Play();
        else
            v29.BackgroundTransparency = v31;
        end;
    end;

    if v30 then
        local v32 = p25 and 0 or 0.75;

        if p26 and p28 then
            TweenService:Create(v30, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = v32
            }):Play();

            return;
        end;

        v30.BackgroundTransparency = v32;
    end;
end;

local function UpdateDisplay(p33) -- Line: 155
    -- upvalues: Profiler (copy), u4 (ref), ReplicatedStorage (copy), DataController (copy), LocalPlayer (copy), u5 (copy), UpdateRewardIndicators (copy), u6 (ref), ActivateButton (copy), u7 (ref), Router (copy), Remotes (copy), UpdateMissionCard (copy)
    Profiler.mark("UI.Dashboard.UpdateMedalEventDisplay");
    local MedalEvent = u4.Right.MedalEvent;
    local ScrollingFrame = MedalEvent.Container.Frame.ScrollingFrame;
    local MedalAssets = ReplicatedStorage.Assets.UI.MedalAssets;
    local v34 = DataController.Get(LocalPlayer, "HasClaimedExclusiveMedalReward") == true;
    local u35 = v34 or LocalPlayer:GetAttribute("RobloxAccountLinkedToMedal") == true;
    local u36 = v34 or LocalPlayer:GetAttribute("HasClippedBloxStrike") == true;
    local v37 = u35 ~= u5.isLinked;
    local v38 = u36 ~= u5.hasClipped;
    u5.isLinked = u35;
    u5.hasClipped = u36;
    UpdateRewardIndicators(MedalEvent, u35, u36, p33, v37, v38);

    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    u6 = {};
    local v39 = MedalAssets.Unlocked:Clone();
    v39.TextLabel.Text = "Link your Roblox account to your Medal account";
    v39.Name = "LinkAccount";
    v39.LayoutOrder = 1;
    v39.Parent = ScrollingFrame;
    u6.LinkAccount = v39;
    local Button = v39.Button;

    local function u40() -- Line: 186
        -- upvalues: u35 (copy)
        return u35;
    end;

    ActivateButton(Button);
    local u41 = "link";
    Button.MouseButton1Click:Connect(function() -- Line: 95
        -- upvalues: u40 (copy), u7 (ref), Router (ref), Remotes (ref), u41 (copy)
        if u40() then
            return;
        end;

        local v42 = tick();

        if v42 - u7 < 5 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Please wait before refreshing again.");

            return;
        end;

        u7 = v42;
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        Remotes.Collaborations.RefreshMedalStatus.Send(u41);
    end);
    UpdateMissionCard(v39, u35, p33 and v37);
    local v43;

    if u35 then
        v43 = MedalAssets.Unlocked:Clone();
        v43.TextLabel.Text = "Clip and upload your best BloxStrike moment";
        local Button2 = v43.Button;

        local function u44() -- Line: 195
            -- upvalues: u36 (copy)
            return u36;
        end;

        ActivateButton(Button2);
        local u45 = "clip";
        Button2.MouseButton1Click:Connect(function() -- Line: 95
            -- upvalues: u44 (copy), u7 (ref), Router (ref), Remotes (ref), u45 (copy)
            if u44() then
                return;
            end;

            local v46 = tick();

            if v46 - u7 < 5 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "Please wait before refreshing again.");

                return;
            end;

            u7 = v46;
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            Remotes.Collaborations.RefreshMedalStatus.Send(u45);
        end);
        UpdateMissionCard(v43, u36, p33 and v38);
    else
        v43 = MedalAssets.Locked:Clone();
    end;

    v43.Name = "ClipKill";
    v43.LayoutOrder = 2;
    v43.Parent = ScrollingFrame;
    u6.ClipKill = v43;
end;

local function SetupHeartbeat(u47) -- Line: 210
    -- upvalues: RunServiceController (copy), u4 (ref), u2 (copy), FormatTimer (copy)
    local Timer = u47.Container.Frame.Header.Timer;
    local Glow = u47.Container.Frame.Rewards.Item.Frame.Content.Outer.Icon.Glow;
    RunServiceController.BindToHeartbeat("UI.Dashboard.MedalEvent", function(p48) -- Line: 214
        -- upvalues: u4 (ref), u47 (copy), u2 (ref), Glow (copy), Timer (copy), FormatTimer (ref)
        if not (u4.Visible and u47.Visible) then
            return;
        end;

        local v49 = u2 - os.time();
        local v50 = math.max(0, v49);

        if v50 <= 0 then
            u47.Visible = false;

            return;
        end;

        Glow.Rotation = Glow.Rotation + p48 * 6.7;
        Timer.Text = FormatTimer(v50);
    end);
end;

function v1.IsAvailable() -- Line: 233
    -- upvalues: u3 (copy), u2 (copy)
    local v51 = u3 and os.time() < u2;

    return v51;
end;

function v1.Initialize(p52, p53) -- Line: 239
    -- upvalues: u4 (ref), u3 (copy), u2 (copy), UpdateDisplay (copy), LocalPlayer (copy), DataController (copy), SetupHeartbeat (copy)
    u4 = p52;
    local MedalEvent = p53:FindFirstChild("MedalEvent");
    local v54 = u3 and os.time() < u2;

    if MedalEvent then
        MedalEvent.Visible = v54;
    end;

    if not (MedalEvent and v54) then
        return;
    end;

    UpdateDisplay(false);
    LocalPlayer:GetAttributeChangedSignal("RobloxAccountLinkedToMedal"):Connect(function() -- Line: 255
        -- upvalues: UpdateDisplay (ref)
        UpdateDisplay(true);
    end);
    LocalPlayer:GetAttributeChangedSignal("HasClippedBloxStrike"):Connect(function() -- Line: 258
        -- upvalues: UpdateDisplay (ref)
        UpdateDisplay(true);
    end);
    DataController.CreateListener(LocalPlayer, "HasClaimedExclusiveMedalReward", function() -- Line: 261
        -- upvalues: UpdateDisplay (ref)
        UpdateDisplay(false);
    end);
    SetupHeartbeat(MedalEvent);
end;

return v1;