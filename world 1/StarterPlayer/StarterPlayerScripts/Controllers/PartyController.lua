-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 50
};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local StarterGui = game:GetService("StarterGui");
local Players = game:GetService("Players");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local PartyConfig = require(ReplicatedStorage.SharedModules.PartyConfig);
local PartyFlags = require(ReplicatedStorage.SharedModules.Flags.PartyFlags);
local PartySchedule = require(ReplicatedStorage.SharedModules.PartySchedule);
local PartyPickupFlyUp = require(ReplicatedStorage.ClientModules.Effects.PartyPickupFlyUp);
local ScreenConfetti = require(ReplicatedStorage.ClientModules.Effects.ScreenConfetti);
local ScreenResolution = require(ReplicatedStorage.ClientModules.ScreenResolution);
local Trove = require(ReplicatedStorage.ClientModules.Trove);
local ChestData = require(ReplicatedStorage.SharedModules.ChestData);
local ChestItemDisplay = require(ReplicatedStorage.SharedModules.ChestItemDisplay);
local RarityVisuals = require(ReplicatedStorage.SharedModules.RarityVisuals);
local FormatChance = require(ReplicatedStorage.UserGenerated.Strings.FormatChance);
local GuiController = require(script.Parent.GuiController);
local NotificationController = require(script.Parent.NotificationController);
local LocalPlayer = Players.LocalPlayer;
local u2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local CoinsLoop = SoundService.SFX.CoinsLoop;
local u3 = NumberRange.new(10, 20);
local u4 = Trove.new();
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = {};
local u12 = nil;
local u13 = 0;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = 0;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = false;
local u27 = nil;
local u28 = nil;
local u29 = "";
local u30 = 0;
local u31 = 0;
local u32 = false;

local function BindGui() -- Line: 137
    -- upvalues: LocalPlayer (copy), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return false;
    end;

    u5 = PlayerGui:FindFirstChild("PartyPoint");

    if not u5 then
        return false;
    end;

    u6 = u5:FindFirstChild("PartyPoints");

    if not u6 then
        return false;
    end;

    u7 = u5:FindFirstChild("ProgressBar", true);
    u8 = u5:FindFirstChild("Ticks", true);
    u9 = u5:FindFirstChild("RewardsIndicator", true);
    u14 = u5:FindFirstChild("ExpCounter", true);
    u15 = u5:FindFirstChild("Sunburst", true);
    local v33;

    if u15 then
        v33 = u15:FindFirstChild("Chase");
    else
        v33 = nil;
    end;

    u16 = v33;
    u17 = u5:FindFirstChild("GardenButton", true);
    local v34;

    if u17 then
        v34 = u17:FindFirstChildOfClass("UISizeConstraint");
    else
        v34 = nil;
    end;

    u18 = v34;
    local v35;

    if u7 == nil or u8 == nil then
        v35 = false;
    else
        v35 = u14 ~= nil;
    end;

    return v35;
end;

local function CollectSlots(p36) -- Line: 166
    local v37 = {};

    if not p36 then
        return v37;
    end;

    for _, child in ipairs(p36:GetChildren()) do
        if child:IsA("GuiObject") and tonumber(child.Name) then
            table.insert(v37, child);
        end;
    end;

    table.sort(v37, function(p38, p39) -- Line: 174
        return tonumber(p38.Name) < tonumber(p39.Name);
    end);

    return v37;
end;

local function FitRow(p40, p41, p42, p43) -- Line: 183
    -- upvalues: CollectSlots (copy)
    local v44 = CollectSlots(p40);
    local v45 = v44[1];

    if not v45 then
        return v44;
    end;

    for i = #v44 + 1, p41 do
        local v46 = v45:Clone();
        v46.Name = tostring(i);
        v46.LayoutOrder = i;

        if p43 then
            v46.ImageTransparency = p42;
        else
            v46.BackgroundTransparency = p42;
        end;

        v46.Parent = p40;
        v44[i] = v46;
    end;

    for i = #v44, p41 + 1, -1 do
        v44[i]:Destroy();
        v44[i] = nil;
    end;

    local v47 = p41 <= 1 and 0 or 1 / (p41 - 1);
    local v48 = math.min(v47, 0.057588);

    for i, v in v44 do
        v.Position = UDim2.new((i - 1) * v47, 0, v.Position.Y.Scale, v.Position.Y.Offset);

        if p43 then
            v.Size = UDim2.new(v48, 0, v.Size.Y.Scale, v.Size.Y.Offset);
        end;
    end;

    return v44;
end;

local function BuildMarkers() -- Line: 226
    -- upvalues: u8 (ref), u9 (ref), PartyConfig (copy), u10 (ref), u11 (ref), FitRow (copy), u12 (ref)
    if not (u8 and u9) then
        return;
    end;

    local v49 = 0;

    for _, v in PartyConfig.Ticks do
        if not v.IsChest then
            v49 = v49 + 1;
        end;
    end;

    if v49 < 1 then
        return;
    end;

    local v50 = u10[1];
    local v51 = u11[1];

    if #u10 == v49 and (#u11 == v49 and (v50 and (v50.Parent == u8 and (v51 and v51.Parent == u9)))) then
        return;
    end;

    u10 = FitRow(u8, v49, 0.5, false);
    u11 = FitRow(u9, v49, 0, true);
    u12 = nil;
end;

local function PaintTick(p52, p53) -- Line: 256
    -- upvalues: u10 (ref), u11 (ref)
    local v54 = u10[p52];

    if v54 then
        v54.BackgroundTransparency = p53 and 0 or 0.5;
    end;

    local v55 = u11[p52];

    if v55 then
        v55.ImageTransparency = 0;
    end;
end;

local function NextRewardIndex() -- Line: 272
    -- upvalues: u19 (ref), PartyConfig (copy)
    local v56 = u19 and (u19.Claimed or {}) or {};

    for i, v in ipairs(PartyConfig.Ticks) do
        if not v.IsChest and (v56[i] ~= true and v56[tostring(i)] ~= true) then
            return i;
        end;
    end;

    return nil;
end;

local function ApplyIconVisibility() -- Line: 288
    -- upvalues: u12 (ref), NextRewardIndex (copy), u11 (ref)
    local v57 = u12 or NextRewardIndex();

    for i, v in u11 do
        v.Visible = i == v57;
    end;
end;

local function SetFill(p58) -- Line: 297
    -- upvalues: u7 (ref), TweenService (copy), u2 (copy)
    if not u7 then
        return;
    end;

    local v59 = math.clamp(p58, 0, 1);
    TweenService:Create(u7, u2, {
        Size = UDim2.new(v59, 0, u7.Size.Y.Scale, u7.Size.Y.Offset)
    }):Play();
end;

local function UpdateChestWobble() -- Line: 307
    -- upvalues: u16 (ref), u6 (ref)
    if not (u16 and u6) then
        return;
    end;

    local v60 = os.clock() % 4;
    local v61;

    if u6.Visible and v60 < 0.7 then
        local v62 = v60 / 0.7;
        v61 = math.sin(v62 * 3.141592653589793 * 2 * 3) * 12 * (1 - v62);
    else
        v61 = 0;
    end;

    if u16.Rotation ~= v61 then
        u16.Rotation = v61;
    end;
end;

local function UpdateGardenButtonSize() -- Line: 327
    -- upvalues: BindGui (copy), u18 (ref), ScreenResolution (copy)
    if not (BindGui() and u18) then
        return;
    end;

    local v63 = ScreenResolution.GetResolutionScale();
    local v64 = math.min(v63, 1) * 225;
    local v65 = math.clamp(v64, 120, 225);
    u18.MaxSize = Vector2.new(v65, v65);
end;

local function EnsureCountdownUi() -- Line: 335
    -- upvalues: u27 (ref), LocalPlayer (copy), StarterGui (copy), u4 (copy), u28 (ref), PartyConfig (copy)
    if u27 and u27.Parent then
        return;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return;
    end;

    local PartyCountdownBanner = PlayerGui:FindFirstChild("PartyCountdownBanner");

    if not PartyCountdownBanner then
        local DripUpdateNotification = StarterGui:FindFirstChild("DripUpdateNotification");

        if not DripUpdateNotification then
            return;
        end;

        PartyCountdownBanner = DripUpdateNotification:Clone();
        PartyCountdownBanner.Name = "PartyCountdownBanner";
        PartyCountdownBanner.Enabled = true;
        PartyCountdownBanner.ResetOnSpawn = false;
        PartyCountdownBanner.Parent = PlayerGui;
        u4:Add(PartyCountdownBanner);
    end;

    u27 = PartyCountdownBanner:FindFirstChild("Popdown_Frame");
    u28 = PartyCountdownBanner:FindFirstChild("TextLabel", true);

    if u27 then
        u27.Visible = false;
    end;

    local ImageVector = PartyCountdownBanner:FindFirstChild("ImageVector", true);

    if ImageVector and ImageVector:IsA("ImageLabel") then
        ImageVector.Image = PartyConfig.Icon;
        local QuestionMark = ImageVector:FindFirstChild("QuestionMark");

        if QuestionMark and QuestionMark:IsA("GuiObject") then
            QuestionMark.Visible = false;
        end;
    end;
end;

local function GetCountdownRemaining() -- Line: 382
    -- upvalues: PartySchedule (copy)
    if PartySchedule.ShouldShowBanner() then
        return PartySchedule.SecondsUntilStart();
    end;

    return nil;
end;

local function FormatCountdown(p66) -- Line: 388
    local v67 = math.floor(p66);
    local v68 = math.max(0, v67);
    local v69 = math.floor(v68 / 3600);
    local v70 = math.floor(v68 % 3600 / 60);
    local v71 = v68 % 60;

    if v69 > 0 then
        return string.format("%d:%02d:%02d", v69, v70, v71);
    end;

    return string.format("%d:%02d", v70, v71);
end;

local function UpdateVisibility() -- Line: 401
    -- upvalues: BindGui (copy), u19 (ref), LocalPlayer (copy), PartySchedule (copy), u5 (ref), u6 (ref), u17 (ref), EnsureCountdownUi (copy), u27 (ref), GuiController (copy)
    if not BindGui() then
        return;
    end;

    local v72;

    if u19 == nil then
        v72 = false;
    else
        v72 = u19.Active == true;
    end;

    local v73 = LocalPlayer:GetAttribute("MinigameCanLeave") == true;
    local v74 = not v72;

    if v74 then
        local v75;

        if PartySchedule.ShouldShowBanner() then
            v75 = PartySchedule.SecondsUntilStart();
        else
            v75 = nil;
        end;

        v74 = v75 ~= nil;
    end;

    u5.Enabled = v72 or v73;
    u6.Visible = v72;

    if u17 then
        u17.Visible = v73;
    end;

    if v74 then
        EnsureCountdownUi();
    end;

    if u27 then
        u27.Visible = v74;
    end;

    if not v72 and GuiController:IsOpen("PartyOdds") then
        GuiController:Close();
    end;
end;

local function UpdateCountdown() -- Line: 430
    -- upvalues: PartySchedule (copy), u27 (ref), UpdateVisibility (copy), u28 (ref), FormatCountdown (copy), u29 (ref)
    local v76;

    if PartySchedule.ShouldShowBanner() then
        v76 = PartySchedule.SecondsUntilStart();
    else
        v76 = nil;
    end;

    if not v76 then
        if u27 and u27.Visible then
            UpdateVisibility();
        end;

        return;
    end;

    if not (u27 and u27.Visible) then
        UpdateVisibility();
    end;

    if not u28 then
        return;
    end;

    local v77 = "PARTY IN: " .. FormatCountdown(v76);

    if v77 ~= u29 then
        u29 = v77;
        u28.Text = v77;
    end;
end;

local function Render(p78) -- Line: 454
    -- upvalues: BindGui (copy), UpdateVisibility (copy), PartyConfig (copy), SetFill (copy), u14 (ref), BuildMarkers (copy), u10 (ref), u11 (ref), u12 (ref), NextRewardIndex (copy)
    if not (p78 and BindGui()) then
        return;
    end;

    UpdateVisibility();

    if not p78.Active then
        return;
    end;

    local MaxPoints = p78.MaxPoints;

    if type(MaxPoints) ~= "number" or MaxPoints <= 0 then
        MaxPoints = PartyConfig.GetMaxTickPoints();
    end;

    local v79 = p78.Points or 0;
    SetFill(v79 / MaxPoints);

    if u14 then
        u14.Text = tostring(v79) .. " Pts";
    end;

    BuildMarkers();
    local v80 = p78.Claimed or {};

    for i, v in ipairs(PartyConfig.Ticks) do
        if not v.IsChest then
            local v81 = v80[i] == true and true or v80[tostring(i)] == true;
            local v82 = u10[i];

            if v82 then
                v82.BackgroundTransparency = v81 and 0 or 0.5;
            end;

            local v83 = u11[i];

            if v83 then
                v83.ImageTransparency = 0;
            end;
        end;
    end;

    local v84 = u12 or NextRewardIndex();

    for i, v in u11 do
        v.Visible = i == v84;
    end;
end;

local function FlushConfetti() -- Line: 487
    -- upvalues: u32 (ref), u31 (ref), u30 (ref), ScreenConfetti (copy), u3 (copy)
    u32 = false;
    u31 = os.clock() + 0.75;
    local v85 = u30;
    u30 = 0;

    if v85 <= 0 then
        return;
    end;

    local v86 = math.floor(v85 * 2 + 10);
    local v87 = math.clamp(v86, 10, 90);
    ScreenConfetti.Play({
        Duration = 0,
        Burst = v87,
        Size = u3
    });
end;

local function FlyHatToCounter() -- Line: 513
    -- upvalues: PartyFlags (copy), BindGui (copy), u14 (ref), PartyPickupFlyUp (copy)
    if not PartyFlags.HatFlyOnPoints:Get() then
        return;
    end;

    if not (BindGui() and u14) then
        return;
    end;

    PartyPickupFlyUp.Play({
        Target = u14
    });
end;

local function CelebratePoints(p88) -- Line: 521
    -- upvalues: PartyFlags (copy), u30 (ref), u31 (ref), FlushConfetti (copy), u32 (ref)
    if not PartyFlags.ConfettiOnPoints:Get() then
        return;
    end;

    u30 = u30 + p88;
    local v89 = u31 - os.clock();

    if v89 <= 0 then
        FlushConfetti();

        return;
    end;

    if u32 then
        return;
    end;

    u32 = true;
    task.delay(v89, FlushConfetti);
end;

local function ApplyState(p90) -- Line: 542
    -- upvalues: u19 (ref), Render (copy), CoinsLoop (copy), NotificationController (copy), FlyHatToCounter (copy), CelebratePoints (copy)
    local v91 = u19;
    u19 = p90;
    Render(p90);

    if p90 and (p90.Active and (v91 and v91.EventId == p90.EventId)) then
        local v92 = (p90.Points or 0) - (v91.Points or 0);

        if v92 > 0 then
            CoinsLoop:Play();
            NotificationController:CreatePartyPointsNotification(v92);
            FlyHatToCounter();
            CelebratePoints(v92);
        end;
    end;
end;

local function ShakeIcon(u93) -- Line: 562
    -- upvalues: RunService (copy)
    local u94 = os.clock();
    local u95 = nil;
    u95 = RunService.RenderStepped:Connect(function() -- Line: 565
        -- upvalues: u94 (copy), u93 (copy), u95 (ref)
        local v96 = (os.clock() - u94) / 0.35;

        if v96 < 1 and u93.Parent then
            u93.Rotation = math.sin(v96 * 3.141592653589793 * 2 * 3) * 14 * (1 - v96);

            return;
        end;

        u93.Rotation = 0;

        if u95 then
            u95:Disconnect();
            u95 = nil;
        end;
    end);
end;

local function RevealItems(u97, p98) -- Line: 582
    -- upvalues: PartyFlags (copy), u13 (ref), PartyPickupFlyUp (copy), RarityVisuals (copy)
    if not PartyFlags.RevealOnTick:Get() then
        return;
    end;

    if type(p98) ~= "table" then
        return;
    end;

    for _, v in ipairs(p98) do
        if type(v) == "table" and (type(v.Image) == "string" and v.Image ~= "") then
            local u99 = type(v.Name) ~= "string" and "" or v.Name;
            local u100 = type(v.Amount) ~= "number" and 1 or math.floor(v.Amount);
            local u101;

            if type(v.RarityName) == "string" then
                u101 = v.RarityName;
            else
                u101 = nil;
            end;

            local v102 = os.clock();
            local v103 = math.max(v102 + 0.35, u13);
            u13 = v103 + 0.35;
            task.delay(v103 - v102, function() -- Line: 603
                -- upvalues: PartyPickupFlyUp (ref), u97 (copy), v (copy), u100 (copy), u99 (copy), u101 (copy), RarityVisuals (ref)
                local Play = PartyPickupFlyUp.Play;
                local v104 = {
                    Size = 150,
                    Duration = 1.1,
                    Hold = 0.6,
                    Tilt = 8,
                    Origin = u97,
                    Image = v.Image
                };
                local v105;

                if u100 > 1 then
                    v105 = `x{u100} {u99}`;
                else
                    v105 = u99;
                end;

                v104.Text = v105;
                local v106;

                if u101 then
                    v106 = RarityVisuals.GetStaticColor(u101);
                else
                    v106 = nil;
                end;

                v104.TextColor = v106;
                Play(v104);
            end);
        end;
    end;
end;

local function OnTickUnlocked(u107, p108) -- Line: 620
    -- upvalues: BindGui (copy), BuildMarkers (copy), u10 (ref), u11 (ref), u12 (ref), NextRewardIndex (copy), TweenService (copy), RunService (copy), RevealItems (copy)
    if not BindGui() then
        return;
    end;

    BuildMarkers();
    local v109 = u10[u107];

    if v109 then
        v109.BackgroundTransparency = 0;
    end;

    local v110 = u11[u107];

    if v110 then
        v110.ImageTransparency = 0;
    end;

    local u111 = u11[u107];

    if not u111 then
        return;
    end;

    u12 = u107;
    local v112 = u12 or NextRewardIndex();

    for i, v in u11 do
        v.Visible = i == v112;
    end;

    local Size = u111.Size;
    local v113 = UDim2.new(Size.X.Scale * 1.25, 0, Size.Y.Scale * 1.25, 0);
    local v114 = TweenService:Create(u111, TweenInfo.new(0.12), {
        Size = v113
    });
    v114:Play();
    v114.Completed:Once(function() -- Line: 637
        -- upvalues: TweenService (ref), u111 (copy), Size (copy)
        TweenService:Create(u111, TweenInfo.new(0.12), {
            Size = Size
        }):Play();
    end);
    local u115 = os.clock();
    local u116 = nil;
    u116 = RunService.RenderStepped:Connect(function() -- Line: 565
        -- upvalues: u115 (copy), u111 (copy), u116 (ref)
        local v117 = (os.clock() - u115) / 0.35;

        if v117 < 1 and u111.Parent then
            u111.Rotation = math.sin(v117 * 3.141592653589793 * 2 * 3) * 14 * (1 - v117);

            return;
        end;

        u111.Rotation = 0;

        if u116 then
            u116:Disconnect();
            u116 = nil;
        end;
    end);
    RevealItems(u111, p108);
    task.delay(0.35, function() -- Line: 647
        -- upvalues: u12 (ref), u107 (copy), NextRewardIndex (ref), u11 (ref)
        if u12 ~= u107 then
            return;
        end;

        u12 = nil;
        local v118 = u12 or NextRewardIndex();

        for i, v in u11 do
            v.Visible = i == v118;
        end;
    end);
end;

local function OnGardenClicked() -- Line: 656
    -- upvalues: u20 (ref), Networking (copy)
    local v119 = workspace:GetServerTimeNow();

    if v119 - u20 < 1 then
        return;
    end;

    u20 = v119;
    Networking.Minigame.LeaveRequest:Fire();
end;

local function BindOddsGui() -- Line: 664
    -- upvalues: u21 (ref), LocalPlayer (copy), u22 (ref), u23 (ref), u24 (ref), u25 (ref)
    if u21 and u21.Parent then
        return true;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return false;
    end;

    local PartyOdds = PlayerGui:FindFirstChild("PartyOdds");

    if not PartyOdds then
        return false;
    end;

    local Frame = PartyOdds:FindFirstChild("Frame");
    local v120;

    if Frame then
        v120 = Frame:FindFirstChild("ScrollingFrame");
    else
        v120 = nil;
    end;

    if not v120 then
        return false;
    end;

    u21 = PartyOdds;
    u22 = v120;
    u23 = v120:FindFirstChild("FirstItem");
    u24 = v120:FindFirstChild("FourthItem");
    u25 = v120:FindFirstChild("Reward");
    local v121;

    if u23 == nil then
        v121 = false;
    else
        v121 = u25 ~= nil;
    end;

    return v121;
end;

local function BindOddsExit() -- Line: 694
    -- upvalues: u26 (ref), u21 (ref), u4 (copy), GuiController (copy)
    if u26 or not u21 then
        return;
    end;

    local Frame = u21:FindFirstChild("Frame");
    local v122;

    if Frame then
        v122 = Frame:FindFirstChild("Header");
    else
        v122 = nil;
    end;

    local v123;

    if v122 then
        v123 = v122:FindFirstChild("ExitButton");
    else
        v123 = nil;
    end;

    if not (v123 and v123:IsA("GuiButton")) then
        return;
    end;

    u4:Connect(v123.MouseButton1Click, function() -- Line: 704
        -- upvalues: GuiController (ref)
        GuiController:Close();
    end);
    u26 = true;
end;

local function PickTemplate(p124, p125) -- Line: 711
    -- upvalues: u25 (ref), u24 (ref), u23 (ref)
    if p124 == p125 then
        return u25;
    end;

    if p124.Tier and u24 then
        return u24;
    end;

    return u23;
end;

local function PopulateOdds() -- Line: 726
    -- upvalues: BindOddsGui (copy), u22 (ref), ChestData (copy), PartyConfig (copy), u25 (ref), u24 (ref), u23 (ref), ChestItemDisplay (copy), FormatChance (copy)
    if not BindOddsGui() then
        return;
    end;

    for _, child in u22:GetChildren() do
        if child.Name == "OddsCell" then
            child:Destroy();
        end;
    end;

    local v126 = ChestData.GetData(PartyConfig.ChestCrateName);

    if not v126 or (not v126.Items or #v126.Items == 0) then
        return;
    end;

    local v127 = 0;

    for _, v in v126.Items do
        v127 = v127 + v.Chance;
    end;

    if v127 <= 0 then
        return;
    end;

    local v128 = table.clone(v126.Items);
    table.sort(v128, function(p129, p130) -- Line: 749
        return p129.Chance < p130.Chance;
    end);
    local v131 = v128[1];

    for i, v in v128 do
        local v132;

        if v == v131 then
            v132 = u25;
        elseif v.Tier and u24 then
            v132 = u24;
        else
            v132 = u23;
        end;

        if v132 then
            local v133 = v132:Clone();
            local v134 = v133:FindFirstChild("Cell") or v133;
            local Icon = v134:FindFirstChild("Icon");

            if Icon then
                Icon.Image = ChestItemDisplay.Image(v);
            end;

            local ItemName = v134:FindFirstChild("ItemName");

            if ItemName then
                ItemName.Text = ChestItemDisplay.Name(v);
            end;

            local Odds = v134:FindFirstChild("Odds");

            if Odds then
                Odds.Text = FormatChance(v.Chance / v127);
            end;

            v133.Name = "OddsCell";
            v133.Visible = true;
            v133.LayoutOrder = i;
            v133.Parent = u22;
        end;
    end;
end;

local function ToggleOdds() -- Line: 792
    -- upvalues: BindOddsGui (copy), GuiController (copy), BindOddsExit (copy), PopulateOdds (copy)
    if not BindOddsGui() then
        return;
    end;

    if GuiController:IsOpen("PartyOdds") then
        GuiController:Close();

        return;
    end;

    BindOddsExit();
    PopulateOdds();
    GuiController:Open("PartyOdds");
end;

function v1.Init(p135) -- Line: 807
end;

function v1.Start(p136) -- Line: 810
    -- upvalues: UpdateVisibility (copy), u4 (copy), ScreenResolution (copy), UpdateGardenButtonSize (copy), LocalPlayer (copy), Networking (copy), ApplyState (copy), u19 (ref), OnTickUnlocked (copy), u15 (ref), ToggleOdds (copy), u17 (ref), OnGardenClicked (copy), u29 (ref), UpdateCountdown (copy), PartySchedule (copy), PartyFlags (copy), RunService (copy), UpdateChestWobble (copy)
    UpdateVisibility();
    u4:Add(ScreenResolution.Observe(UpdateGardenButtonSize));
    u4:Connect(LocalPlayer:GetAttributeChangedSignal("MinigameCanLeave"), UpdateVisibility);
    u4:Connect(Networking.Party.State.OnClientEvent, ApplyState);
    task.spawn(function() -- Line: 829
        -- upvalues: Networking (ref), u19 (ref), ApplyState (ref)
        local success, result = pcall(function() -- Line: 830
            -- upvalues: Networking (ref)
            return Networking.Party.RequestState:Fire();
        end);

        if success and (result ~= nil and u19 == nil) then
            ApplyState(result);
        end;
    end);
    u4:Connect(Networking.Party.TickUnlocked.OnClientEvent, function(p137) -- Line: 840
        -- upvalues: OnTickUnlocked (ref)
        if type(p137) ~= "table" then
            return;
        end;

        if type(p137.Index) ~= "number" then
            return;
        end;

        OnTickUnlocked(p137.Index, p137.Items);
    end);

    if u15 and u15:IsA("GuiButton") then
        u4:Connect(u15.MouseButton1Click, ToggleOdds);
    end;

    if u17 and u17:IsA("GuiButton") then
        u4:Connect(u17.MouseButton1Click, OnGardenClicked);
    end;

    local function OnScheduleChanged() -- Line: 857
        -- upvalues: u29 (ref), UpdateVisibility (ref), UpdateCountdown (ref)
        u29 = "";
        UpdateVisibility();
        UpdateCountdown();
    end;

    u4:Connect(workspace:GetAttributeChangedSignal(PartySchedule.StartAtAttribute), OnScheduleChanged);
    PartyFlags.StartAtUnix.Changed:Connect(OnScheduleChanged);
    u4:Connect(RunService.Heartbeat, UpdateCountdown);
    u4:Connect(RunService.Heartbeat, UpdateChestWobble);
    UpdateCountdown();
end;

return v1;