-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local LevelsIcon = require(ReplicatedStorage.Database.Custom.GameStats.LevelsIcon);
local Sound = require(ReplicatedStorage.Classes.Sound);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter);
local Halftime = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Halftime);
local u2 = CFrame.new(-0.251, 0.806, -0.406) * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);
local u3 = { {
        maxLevel = 5,
        title = "Recruit"
    }, {
        maxLevel = 10,
        title = "Private"
    }, {
        maxLevel = 15,
        title = "Corporal"
    }, {
        maxLevel = 20,
        title = "Sergeant"
    }, {
        maxLevel = 25,
        title = "Master Sergeant"
    }, {
        maxLevel = 30,
        title = "Lieutenant"
    }, {
        maxLevel = 35,
        title = "Captain"
    }, {
        maxLevel = 40,
        title = "Global Elite"
    } };
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local CurrentCamera = workspace.CurrentCamera;
local Characters = ReplicatedStorage.Assets.Characters;
local u4 = { {
        Entrance = "rbxassetid://100747011940776",
        Idle = "rbxassetid://100747011940776"
    }, {
        Entrance = "rbxassetid://103701913618746",
        Idle = "rbxassetid://100955283476946"
    }, {
        Entrance = "rbxassetid://91396952135880",
        Idle = "rbxassetid://120200138438261"
    }, {
        Entrance = "rbxassetid://136102955582599",
        Idle = "rbxassetid://74544097369437"
    }, {
        Entrance = "rbxassetid://71439100344953",
        Idle = "rbxassetid://122693948164334"
    } };
local u5 = {
    CT = {
        Character = "IDF",
        Weapon = "M4A1-S",
        Glove = "CT Glove"
    },
    T = {
        Character = "Anarchist",
        Weapon = "AK-47",
        Glove = "T Glove"
    }
};
local u6 = {
    ["Counter-Terrorists"] = "CT",
    Terrorists = "T"
};
local u7 = Janitor.new();
local u8 = false;
local u9 = 0;
local u10 = true;
local u11 = "EndScreen";
local u12 = nil;
local u13 = nil;
local u14 = {
    RoundWonCT = true,
    RoundWonT = true,
    RoundLost = true,
    PlayerMVPCT = true,
    PlayerMVPT = true
};

local function isPlayingTeam(p15) -- Line: 212
    return p15 == "Counter-Terrorists" and true or p15 == "Terrorists";
end;

local function isDrawOutcome(p16) -- Line: 216
    return p16 == "Draw";
end;

local function isHalftimeOverlayMode(p17) -- Line: 220
    return p17 == "Halftime";
end;

local function getOrdinalPlacementText(p18) -- Line: 224
    local v19 = p18 % 100;

    if v19 >= 11 and v19 <= 13 then
        return `{p18}th`;
    end;

    local v20 = p18 % 10;

    if v20 == 1 then
        return `{p18}st`;
    end;

    if v20 == 2 then
        return `{p18}nd`;
    end;

    if v20 == 3 then
        return `{p18}rd`;
    end;

    return `{p18}th`;
end;

local function sortPlayersByADR(p21) -- Line: 242
    local v22 = {};

    for i, v in pairs(p21) do
        local Team = v.Team;

        if Team == "Counter-Terrorists" and true or Team == "Terrorists" then
            table.insert(v22, {
                userId = i,
                data = v
            });
        end;
    end;

    table.sort(v22, function(p23, p24) -- Line: 250
        if (p23.data.ADR or 0) ~= (p24.data.ADR or 0) then
            return (p23.data.ADR or 0) > (p24.data.ADR or 0);
        end;

        if (p23.data.Score or 0) == (p24.data.Score or 0) then
            return (tonumber(p23.userId) or (1 / 0)) < (tonumber(p24.userId) or (1 / 0));
        end;

        return (p23.data.Score or 0) > (p24.data.Score or 0);
    end);

    return v22;
end;

local function rankFFAPlayers(p25) -- Line: 265
    local v26 = {};

    for i, v in pairs(p25) do
        local Team = v.Team;

        if Team == "Counter-Terrorists" and true or Team == "Terrorists" then
            table.insert(v26, {
                userId = i,
                data = v
            });
        end;
    end;

    table.sort(v26, function(p27, p28) -- Line: 273
        if (p27.data.Score or 0) ~= (p28.data.Score or 0) then
            return (p27.data.Score or 0) > (p28.data.Score or 0);
        end;

        if (p27.data.Kills or 0) ~= (p28.data.Kills or 0) then
            return (p27.data.Kills or 0) > (p28.data.Kills or 0);
        end;

        if (p27.data.Assists or 0) == (p28.data.Assists or 0) then
            return (tonumber(p27.userId) or (1 / 0)) < (tonumber(p28.userId) or (1 / 0));
        end;

        return (p27.data.Assists or 0) > (p28.data.Assists or 0);
    end);

    return v26;
end;

local function cleanupDebris() -- Line: 291
    -- upvalues: LocalPlayer (copy)
    local Debris = workspace:FindFirstChild("Debris");

    if Debris then
        for _, child in Debris:GetChildren() do
            child:Destroy();
        end;
    end;

    local Characters2 = workspace:FindFirstChild("Characters");

    if Characters2 then
        for _, child in Characters2:GetChildren() do
            if child:IsA("Folder") then
                for _, child2 in child:GetChildren() do
                    child2:Destroy();
                end;
            end;
        end;
    end;

    if LocalPlayer.Character then
        LocalPlayer.Character:Destroy();
    end;
end;

local function getRankTitle(p29) -- Line: 318
    -- upvalues: u3 (copy)
    for _, v in ipairs(u3) do
        if p29 <= v.maxLevel then
            return v.title;
        end;
    end;

    return "Global Elite";
end;

local function getMiddleFrame() -- Line: 327
    -- upvalues: PlayerGui (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if not MainGui then
        return nil;
    end;

    local Gameplay = MainGui:FindFirstChild("Gameplay");

    if Gameplay then
        return Gameplay:FindFirstChild("Middle");
    end;

    return nil;
end;

local function getEndScreenFrame() -- Line: 337
    -- upvalues: PlayerGui (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");
    local v30;

    if MainGui then
        local Gameplay = MainGui:FindFirstChild("Gameplay");

        if Gameplay then
            v30 = Gameplay:FindFirstChild("Middle");
        else
            v30 = nil;
        end;
    else
        v30 = nil;
    end;

    if v30 then
        return v30:FindFirstChild("EndScreen");
    end;

    return nil;
end;

local function setElementTransparency(p31, p32) -- Line: 343
    if p31:IsA("TextLabel") then
        p31.TextTransparency = p32;

        return;
    end;

    if p31:IsA("TextButton") then
        p31.TextTransparency = p32;

        return;
    end;

    if p31:IsA("ImageLabel") then
        p31.ImageTransparency = p32;

        return;
    end;

    if p31:IsA("ImageButton") then
        p31.ImageTransparency = p32;

        return;
    end;

    if p31:IsA("Frame") then
        p31.BackgroundTransparency = p32;

        return;
    end;

    if p31:IsA("UIStroke") then
        p31.Transparency = p32;
    end;
end;

local function tweenElementTransparency(p33, p34) -- Line: 359
    -- upvalues: TweenService (copy)
    local v35 = TweenInfo.new(0.5);

    if p33:IsA("TextLabel") or p33:IsA("TextButton") then
        TweenService:Create(p33, v35, {
            TextTransparency = p34
        }):Play();

        return;
    end;

    if p33:IsA("ImageLabel") or p33:IsA("ImageButton") then
        TweenService:Create(p33, v35, {
            ImageTransparency = p34
        }):Play();

        return;
    end;

    if p33:IsA("Frame") then
        TweenService:Create(p33, v35, {
            BackgroundTransparency = p34
        }):Play();

        return;
    end;

    if p33:IsA("UIStroke") then
        TweenService:Create(p33, v35, {
            Transparency = p34
        }):Play();
    end;
end;

local function shouldSkipFade(p36) -- Line: 373
    if p36:GetAttribute("SkipFade") then
        return true;
    end;

    local Parent = p36.Parent;

    while Parent and Parent:IsA("GuiObject") do
        if Parent:GetAttribute("SkipFade") then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function fadeFrame(p37, p38) -- Line: 389
    -- upvalues: shouldSkipFade (copy), TweenService (copy), tweenElementTransparency (copy)
    local v39;

    if shouldSkipFade(p37) then
        v39 = nil;
    else
        v39 = TweenService:Create(p37, TweenInfo.new(0.5), {
            BackgroundTransparency = p38
        });
    end;

    for _, descendant in p37:GetDescendants() do
        if not shouldSkipFade(descendant) then
            tweenElementTransparency(descendant, p38);
        end;
    end;

    if v39 then
        v39:Play();
    end;

    return v39;
end;

local function fadeOutFrame(p40) -- Line: 409
    -- upvalues: fadeFrame (copy)
    return fadeFrame(p40, 1);
end;

local function fadeInFrame(p41) -- Line: 413
    -- upvalues: shouldSkipFade (copy), setElementTransparency (copy), fadeFrame (copy)
    if not shouldSkipFade(p41) then
        p41.BackgroundTransparency = 1;
    end;

    for _, descendant in p41:GetDescendants() do
        if not shouldSkipFade(descendant) then
            setElementTransparency(descendant, 1);
        end;
    end;

    p41.Visible = true;

    return fadeFrame(p41, 0);
end;

local function getBarTweenInfo(p42) -- Line: 436
    return TweenInfo.new(p42 and 0.375 or 0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
end;

local function playXpBarFillSound(p43) -- Line: 442
    -- upvalues: Sound (copy), CurrentCamera (copy)
    local v44 = Sound.new("Interface"):play({
        Name = "XP Bar Fill",
        Parent = CurrentCamera
    });

    if v44 and p43 then
        v44.PlaybackSpeed = p43;
    end;

    return v44;
end;

local function playLevelUpSound() -- Line: 457
    -- upvalues: Sound (copy), CurrentCamera (copy)
    return Sound.new("Interface"):play({
        Name = "Level Up",
        Parent = CurrentCamera
    });
end;

local function createBarSize(p45, p46) -- Line: 483
    return UDim2.new(p45, 0, p46.Scale, p46.Offset);
end;

local function setInfoText(p47, p48) -- Line: 487
    local Amount = p47:FindFirstChild("Amount");

    if Amount then
        Amount.Text = p48;
    end;
end;

local function storeFrameTransparency(p49) -- Line: 499
    local v50 = {};

    for _, descendant in p49:GetDescendants() do
        if descendant:IsA("UIStroke") then
            v50[descendant] = descendant.Transparency;
        end;
    end;

    return {
        BackgroundTransparency = p49.BackgroundTransparency,
        Strokes = v50
    };
end;

local function restoreFrameTransparency(p51, p52) -- Line: 512
    p51.BackgroundTransparency = p52.BackgroundTransparency;

    for i, v in pairs(p52.Strokes) do
        if i and i.Parent then
            i.Transparency = v;
        end;
    end;
end;

local function populateLevelFrame(p53) -- Line: 521
    -- upvalues: PlayerGui (copy), u13 (ref), DataController (copy), LocalPlayer (copy), u3 (copy), LevelsIcon (copy), storeFrameTransparency (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");
    local v54;

    if MainGui then
        local Gameplay = MainGui:FindFirstChild("Gameplay");

        if Gameplay then
            v54 = Gameplay:FindFirstChild("Middle");
        else
            v54 = nil;
        end;
    else
        v54 = nil;
    end;

    local v55;

    if v54 then
        v55 = v54:FindFirstChild("EndScreen");
    else
        v55 = nil;
    end;

    if not v55 then
        return nil;
    end;

    local Level = v55:FindFirstChild("Level");

    if not Level then
        return nil;
    end;

    local v56 = u13 or DataController.Get(LocalPlayer, "Level");

    if not v56 then
        return nil;
    end;

    local v57 = v56.Level or 1;
    local v58 = v56.Experience or 0;
    local v59 = v56.NextExperienceRequirement or 1000;
    local TextLabel = Level:FindFirstChild("TextLabel");

    if TextLabel then
        local v60 = "Global Elite";

        for _, v in ipairs(u3) do
            if v57 <= v.maxLevel then
                v60 = v.title;
                break;
            end;
        end;

        TextLabel.Text = `[{v60} Rank {v57}]`;
    end;

    local Rank = Level:FindFirstChild("Rank");

    if Rank then
        Rank.Image = LevelsIcon[tostring(v57)] or "";
    end;

    local LevelBar = Level:FindFirstChild("LevelBar");

    if not LevelBar then
        return nil;
    end;

    local Current = LevelBar:FindFirstChild("Current");
    local Earned = LevelBar:FindFirstChild("Earned");

    if not (Current and Earned) then
        return nil;
    end;

    local CurrentInfo = Level:FindFirstChild("CurrentInfo", true);
    local EarnedInfo = Level:FindFirstChild("EarnedInfo", true);

    if not (CurrentInfo and EarnedInfo) then
        return nil;
    end;

    Current:SetAttribute("SkipFade", true);
    Earned:SetAttribute("SkipFade", true);
    CurrentInfo:SetAttribute("SkipFade", true);
    EarnedInfo:SetAttribute("SkipFade", true);
    local v61 = `{v58}xp`;
    local Amount = CurrentInfo:FindFirstChild("Amount");

    if Amount then
        Amount.Text = v61;
    end;

    local v62 = `+{p53}xp`;
    local Amount2 = EarnedInfo:FindFirstChild("Amount");

    if Amount2 then
        Amount2.Text = v62;
    end;

    local Y = Current.Size.Y;
    local v63 = storeFrameTransparency(CurrentInfo);
    local v64 = storeFrameTransparency(EarnedInfo);

    return {
        currentXP = v58,
        xpEarned = p53,
        nextLevelXP = math.max(v59, 1),
        currentLevel = v57,
        barHeight = Y,
        levelBar = LevelBar,
        levelFrame = Level,
        currentBar = Current,
        earnedBar = Earned,
        currentInfo = CurrentInfo,
        earnedInfo = EarnedInfo,
        currentInfoTransparency = v63,
        earnedInfoTransparency = v64
    };
end;

local function calcInfoXOffset(p65, p66, p67) -- Line: 593
    local Parent = p66.Parent;

    return p65.AbsolutePosition.X + p67 * p65.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + p66.AnchorPoint.X * p66.AbsoluteSize.X;
end;

local function tweenInfoToBarEnd(p68, p69, p70, p71) -- Line: 611
    -- upvalues: TweenService (copy)
    local Position = p68.Position;
    local Parent = p68.Parent;

    return TweenService:Create(p68, p71, {
        Position = UDim2.new(0, p69.AbsolutePosition.X + p70 * p69.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + p68.AnchorPoint.X * p68.AbsoluteSize.X, Position.Y.Scale, Position.Y.Offset)
    });
end;

local function wouldOverlap(p72, p73, p74) -- Line: 622
    return p73.Parent.AbsolutePosition.X + p74 - p73.AnchorPoint.X * p73.AbsoluteSize.X < p72.AbsolutePosition.X + p72.AbsoluteSize.X + 5;
end;

local function calcInfoTopAlignedYOffset(p75, p76) -- Line: 631
    local Parent = p75.Parent;

    return p76 - (Parent and Parent.AbsolutePosition.Y or 0) + p75.AnchorPoint.Y * p75.AbsoluteSize.Y;
end;

local function getAdjustedEarnedPosition(p77, p78, p79) -- Line: 638
    local Y = p77.AbsolutePosition.Y;

    if p78.Parent.AbsolutePosition.X + p79 - p78.AnchorPoint.X * p78.AbsoluteSize.X >= p77.AbsolutePosition.X + p77.AbsoluteSize.X + 5 then
        local Parent = p78.Parent;

        return UDim2.new(0, p79, 0, Y - (Parent and Parent.AbsolutePosition.Y or 0) + p78.AnchorPoint.Y * p78.AbsoluteSize.Y);
    end;

    local Parent = p78.Parent;

    return UDim2.new(0, p79, 0, Y + p77.AbsoluteSize.Y + -2 - (Parent and Parent.AbsolutePosition.Y or 0) + p78.AnchorPoint.Y * p78.AbsoluteSize.Y);
end;

local function tweenInfoToBarEndWithOverlapCheck(p80, p81, p82, p83, p84) -- Line: 651
    -- upvalues: getAdjustedEarnedPosition (copy), TweenService (copy)
    local Parent = p80.Parent;

    return TweenService:Create(p80, p84, {
        Position = getAdjustedEarnedPosition(p81, p80, p82.AbsolutePosition.X + p83 * p82.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + p80.AnchorPoint.X * p80.AbsoluteSize.X)
    });
end;

local function animateLevelBar(p85) -- Line: 657
    -- upvalues: u8 (ref), TweenService (copy), tweenInfoToBarEnd (copy), Sound (copy), CurrentCamera (copy), getAdjustedEarnedPosition (copy), tweenInfoToBarEndWithOverlapCheck (copy), u3 (copy), LevelsIcon (copy)
    if not u8 then
        return;
    end;

    local v86 = math.clamp(p85.currentXP / p85.nextLevelXP, 0, 1);
    local v87 = p85.currentXP + p85.xpEarned;
    local v88 = math.clamp(v87 / p85.nextLevelXP, 0, 1);
    local v89 = p85.nextLevelXP <= v87;
    p85.currentBar.Visible = false;
    p85.earnedBar.Visible = false;
    local barHeight = p85.barHeight;
    p85.currentBar.Size = UDim2.new(0, 0, barHeight.Scale, barHeight.Offset);
    local barHeight2 = p85.barHeight;
    p85.earnedBar.Size = UDim2.new(0, 0, barHeight2.Scale, barHeight2.Offset);
    p85.currentInfo.Visible = false;
    p85.earnedInfo.Visible = false;
    local currentInfoTransparency = p85.currentInfoTransparency;
    p85.currentInfo.BackgroundTransparency = currentInfoTransparency.BackgroundTransparency;

    for i, v in pairs(currentInfoTransparency.Strokes) do
        if i and i.Parent then
            i.Transparency = v;
        end;
    end;

    local earnedInfoTransparency = p85.earnedInfoTransparency;
    p85.earnedInfo.BackgroundTransparency = earnedInfoTransparency.BackgroundTransparency;

    for i, v in pairs(earnedInfoTransparency.Strokes) do
        if i and i.Parent then
            i.Transparency = v;
        end;
    end;

    local levelBar = p85.levelBar;
    local currentInfo = p85.currentInfo;
    local Parent = currentInfo.Parent;
    local levelBar2 = p85.levelBar;
    local earnedInfo = p85.earnedInfo;
    local Parent2 = earnedInfo.Parent;
    local v90 = levelBar2.AbsolutePosition.X + 0 * levelBar2.AbsoluteSize.X - (Parent2 and Parent2.AbsolutePosition.X or 0) + earnedInfo.AnchorPoint.X * earnedInfo.AbsoluteSize.X;
    local Position = p85.currentInfo.Position;
    local Position2 = p85.earnedInfo.Position;
    p85.currentInfo.Position = UDim2.new(0, levelBar.AbsolutePosition.X + 0 * levelBar.AbsoluteSize.X - (Parent and Parent.AbsolutePosition.X or 0) + currentInfo.AnchorPoint.X * currentInfo.AbsoluteSize.X, Position.Y.Scale, Position.Y.Offset);
    p85.earnedInfo.Position = UDim2.new(0, v90, Position2.Y.Scale, Position2.Y.Offset);
    task.wait(0.5);

    if not u8 then
        return;
    end;

    p85.currentBar.Visible = true;
    p85.currentInfo.Visible = true;

    if v86 > 0 then
        local v91 = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
        local currentBar = p85.currentBar;
        local v92 = {};
        local barHeight3 = p85.barHeight;
        v92.Size = UDim2.new(v86, 0, barHeight3.Scale, barHeight3.Offset);
        local v93 = TweenService:Create(currentBar, v91, v92);
        local v94 = tweenInfoToBarEnd(p85.currentInfo, p85.levelBar, v86, v91);
        Sound.new("Interface"):play({
            Name = "XP Bar Fill",
            Parent = CurrentCamera
        });
        v93:Play();
        v94:Play();
        v93.Completed:Wait();

        if not u8 then
            return;
        end;
    end;

    if p85.xpEarned <= 0 then
        return;
    end;

    task.wait(0.6);

    if not u8 then
        return;
    end;

    local barHeight3 = p85.barHeight;
    p85.earnedBar.Size = UDim2.new(v86, 0, barHeight3.Scale, barHeight3.Offset);
    p85.earnedBar.Visible = true;
    p85.earnedInfo.Visible = true;
    local levelBar3 = p85.levelBar;
    local earnedInfo2 = p85.earnedInfo;
    local Parent3 = earnedInfo2.Parent;
    local v95 = getAdjustedEarnedPosition(p85.currentInfo, p85.earnedInfo, levelBar3.AbsolutePosition.X + v86 * levelBar3.AbsoluteSize.X - (Parent3 and Parent3.AbsolutePosition.X or 0) + earnedInfo2.AnchorPoint.X * earnedInfo2.AbsoluteSize.X);
    p85.earnedInfo.Position = v95;

    if not v89 then
        local v96 = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
        local earnedBar = p85.earnedBar;
        local v97 = {};
        local barHeight4 = p85.barHeight;
        v97.Size = UDim2.new(v88, 0, barHeight4.Scale, barHeight4.Offset);
        local v98 = TweenService:Create(earnedBar, v96, v97);
        local v99 = tweenInfoToBarEndWithOverlapCheck(p85.earnedInfo, p85.currentInfo, p85.levelBar, v88, v96);
        local v100 = Sound.new("Interface"):play({
            Name = "XP Bar Fill",
            Parent = CurrentCamera
        });

        if v100 then
            v100.PlaybackSpeed = 1.15;
        end;

        v98:Play();
        v99:Play();
        v98.Completed:Wait();

        return;
    end;

    local v101 = TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
    local earnedBar = p85.earnedBar;
    local v102 = {};
    local barHeight4 = p85.barHeight;
    v102.Size = UDim2.new(1, 0, barHeight4.Scale, barHeight4.Offset);
    local v103 = TweenService:Create(earnedBar, v101, v102);
    local v104 = tweenInfoToBarEndWithOverlapCheck(p85.earnedInfo, p85.currentInfo, p85.levelBar, 1, v101);
    local v105 = Sound.new("Interface"):play({
        Name = "XP Bar Fill",
        Parent = CurrentCamera
    });

    if v105 then
        v105.PlaybackSpeed = 1.15;
    end;

    v103:Play();
    v104:Play();
    v103.Completed:Wait();

    if not u8 then
        return;
    end;

    Sound.new("Interface"):play({
        Name = "Level Up",
        Parent = CurrentCamera
    });
    local v106 = math.clamp((v87 - p85.nextLevelXP) / p85.nextLevelXP, 0, 1);
    local v107 = p85.currentLevel + 1;
    local TextLabel = p85.levelFrame:FindFirstChild("TextLabel");

    if TextLabel then
        local v108 = "Global Elite";

        for _, v in ipairs(u3) do
            if v107 <= v.maxLevel then
                v108 = v.title;
                break;
            end;
        end;

        TextLabel.Text = `[{v108} Rank {v107}]`;
    end;

    local Rank = p85.levelFrame:FindFirstChild("Rank");

    if Rank then
        Rank.Image = LevelsIcon[tostring(v107)] or "";
    end;

    local barHeight5 = p85.barHeight;
    p85.currentBar.Size = UDim2.new(0, 0, barHeight5.Scale, barHeight5.Offset);
    local barHeight6 = p85.barHeight;
    p85.earnedBar.Size = UDim2.new(0, 0, barHeight6.Scale, barHeight6.Offset);
    p85.currentInfo.Visible = false;
    local levelBar4 = p85.levelBar;
    local earnedInfo3 = p85.earnedInfo;
    local Parent4 = earnedInfo3.Parent;
    local earnedInfo4 = p85.earnedInfo;
    local Parent5 = earnedInfo4.Parent;
    p85.earnedInfo.Position = UDim2.new(0, levelBar4.AbsolutePosition.X + 0 * levelBar4.AbsoluteSize.X - (Parent4 and Parent4.AbsolutePosition.X or 0) + earnedInfo3.AnchorPoint.X * earnedInfo3.AbsoluteSize.X, 0, p85.currentInfo.AbsolutePosition.Y - (Parent5 and Parent5.AbsolutePosition.Y or 0) + earnedInfo4.AnchorPoint.Y * earnedInfo4.AbsoluteSize.Y);
    local earnedBar2 = p85.earnedBar;
    local v109 = {};
    local barHeight7 = p85.barHeight;
    v109.Size = UDim2.new(v106, 0, barHeight7.Scale, barHeight7.Offset);
    local v110 = TweenService:Create(earnedBar2, v101, v109);
    local v111 = tweenInfoToBarEnd(p85.earnedInfo, p85.levelBar, v106, v101);
    v110:Play();
    v111:Play();
    v110.Completed:Wait();
end;

local function scaleUDim2(p112, p113) -- Line: 797
    return UDim2.new(p112.X.Scale * p113, p112.X.Offset * p113, p112.Y.Scale * p113, p112.Y.Offset * p113);
end;

local function getItemIcon(p114) -- Line: 804
    -- upvalues: Cases (copy), Skins (copy)
    local v115 = not p114.Type and "" or string.lower(p114.Type);
    local Name = p114.Name;

    if v115 == "credits" then
        return "rbxassetid://115958498634807";
    end;

    if v115 == "case" or (v115 == "sticker capsule" or (v115 == "charm pack" or v115 == "charm capsule")) then
        local v116 = Cases.GetCaseByName(Name);

        if v116 and v116.imageAssetId then
            return v116.imageAssetId;
        end;
    end;

    local v117 = p114.Skin and (Name and Skins.GetSkinInformation(Name, p114.Skin));

    if v117 then
        if v117.wearImages and v117.wearImages[1] then
            return v117.wearImages[1].assetId;
        end;

        if v117.charmImages and v117.charmImages[1] then
            return v117.charmImages[1].assetId;
        end;

        if v117.imageAssetId then
            return v117.imageAssetId;
        end;
    end;

    return "rbxassetid://18822070027";
end;

local function displayDrops(p118) -- Line: 847
    -- upvalues: u8 (ref), PlayerGui (copy), getItemIcon (copy), Rarities (copy), fadeInFrame (copy), TweenService (copy), u7 (copy)
    if not u8 or (not p118 or #p118 == 0) then
        return;
    end;

    local MainGui = PlayerGui:FindFirstChild("MainGui");
    local v119;

    if MainGui then
        local Gameplay = MainGui:FindFirstChild("Gameplay");

        if Gameplay then
            v119 = Gameplay:FindFirstChild("Middle");
        else
            v119 = nil;
        end;
    else
        v119 = nil;
    end;

    local v120;

    if v119 then
        v120 = v119:FindFirstChild("EndScreen");
    else
        v120 = nil;
    end;

    if not v120 then
        return;
    end;

    local Drops = v120:FindFirstChild("Drops");
    local v121;

    if Drops then
        v121 = Drops:FindFirstChild("Container");
    else
        v121 = Drops;
    end;

    local v122;

    if v121 then
        v122 = v121:FindFirstChild("ItemTemplate");
    else
        v122 = v121;
    end;

    if not v122 then
        return;
    end;

    v121:SetAttribute("SkipFade", true);
    v122.Visible = false;

    for _, child in v121:GetChildren() do
        if child:IsA("Frame") and child.Name ~= "ItemTemplate" then
            child:Destroy();
        end;
    end;

    Drops.Visible = false;
    task.wait(0.8);

    if not u8 then
        return;
    end;

    local v123 = {};

    for i, v in ipairs(p118) do
        local reward = v.reward;
        local v124 = reward.type == "credits";
        local inventoryItem = reward.inventoryItem;

        if v124 or inventoryItem then
            local v125 = v122:Clone();
            v125.Name = "Drop_" .. i;
            v125.Visible = false;
            v125.Parent = v121;
            local Content = v125:FindFirstChild("Content");

            if Content then
                local Icon = Content:FindFirstChild("Icon");

                if Icon then
                    Icon.Image = v124 and "rbxassetid://115958498634807" or getItemIcon(inventoryItem);
                end;

                local v126 = Content:FindFirstChild("amount") or Content:FindFirstChild("Amount");

                if v126 then
                    if v124 and reward.amount then
                        v126.Visible = true;
                        v126.Text = `x{reward.amount}`;
                    else
                        v126.Visible = false;
                    end;
                end;

                local RarityFrame = Content:FindFirstChild("RarityFrame");

                if RarityFrame then
                    RarityFrame = RarityFrame:FindFirstChild("UIGradient");
                end;

                if RarityFrame then
                    if v124 then
                        inventoryItem = "Rare";
                    elseif inventoryItem then
                        inventoryItem = inventoryItem.Rarity;
                    end;

                    if inventoryItem then
                        local v127 = Rarities[inventoryItem];

                        if v127 and v127.ColorSequence then
                            RarityFrame.Color = v127.ColorSequence;
                        end;
                    end;
                end;

                local Size = Content.Size;
                Content.Size = UDim2.new(Size.X.Scale * 1.25, Size.X.Offset * 1.25, Size.Y.Scale * 1.25, Size.Y.Offset * 1.25);
                local Player = v125:FindFirstChild("Player", true);

                if Player and v.userId > 0 then
                    Player.Image = `rbxthumb://type=AvatarHeadShot&id={v.userId}&w=150&h=150`;
                end;

                table.insert(v123, {
                    item = v125,
                    content = Content,
                    originalSize = Size
                });
            else
                v125:Destroy();
            end;
        end;
    end;

    if #v123 == 0 then
        return;
    end;

    fadeInFrame(Drops);
    task.wait(0.5);

    if not u8 then
        return;
    end;

    local u128 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out);

    for i, v in ipairs(v123) do
        task.delay((i - 1) * 0.35, function() -- Line: 961
            -- upvalues: u8 (ref), v (copy), TweenService (ref), u128 (copy), u7 (ref)
            if not u8 then
                return;
            end;

            v.item.Visible = true;
            local v129 = TweenService:Create(v.content, u128, {
                Size = v.originalSize
            });
            u7:Add(v129, "Cancel");
            v129:Play();
        end);
    end;
end;

local function captureVisibilitySnapshot(p130) -- Line: 972
    -- upvalues: u12 (ref)
    local Gameplay = p130:FindFirstChild("Gameplay");
    local Menu = p130:FindFirstChild("Menu");
    local v131;

    if Gameplay then
        v131 = Gameplay:FindFirstChild("Middle") or nil;
    else
        v131 = nil;
    end;

    local v132 = {};
    local v133;

    if Gameplay then
        v133 = Gameplay.Visible or false;
    else
        v133 = false;
    end;

    v132.GameplayVisible = v133;
    v132.MenuVisible = Menu and Menu.Visible or false;
    v132.GameplayChildren = {};
    v132.MiddleChildren = {};

    if Gameplay then
        for _, child in Gameplay:GetChildren() do
            if child:IsA("Frame") or child:IsA("CanvasGroup") then
                v132.GameplayChildren[child.Name] = child.Visible;
            end;
        end;
    end;

    if v131 then
        for _, child in v131:GetChildren() do
            if child:IsA("Frame") or child:IsA("CanvasGroup") then
                v132.MiddleChildren[child.Name] = child.Visible;
            end;
        end;
    end;

    u12 = v132;
end;

local function restoreVisibilitySnapshot(p134, p135) -- Line: 1003
    -- upvalues: u12 (ref), u14 (copy)
    if not u12 then
        return;
    end;

    local v136 = u12;
    u12 = nil;
    local Gameplay = p134:FindFirstChild("Gameplay");
    local Menu = p134:FindFirstChild("Menu");
    local v137;

    if Gameplay then
        v137 = Gameplay:FindFirstChild("Middle") or nil;
    else
        v137 = nil;
    end;

    if Menu then
        Menu.Visible = v136.MenuVisible;
    end;

    if Gameplay then
        Gameplay.Visible = v136.GameplayVisible;

        for _, child in Gameplay:GetChildren() do
            if child:IsA("Frame") or child:IsA("CanvasGroup") then
                local v138 = v136.GameplayChildren[child.Name];

                if v138 ~= nil then
                    child.Visible = v138;
                end;
            end;
        end;
    end;

    if v137 then
        for _, child in v137:GetChildren() do
            if child:IsA("Frame") or child:IsA("CanvasGroup") then
                local v139 = v136.MiddleChildren[child.Name];

                if v139 ~= nil then
                    child.Visible = v139;
                end;
            end;
        end;

        if p135 then
            for i in pairs(u14) do
                local v140 = v137:FindFirstChild(i);

                if v140 and (v140:IsA("Frame") or v140:IsA("CanvasGroup")) then
                    v140.Visible = false;
                end;
            end;
        end;
    end;
end;

local function enforceEndScreenVisibility(p141) -- Line: 1052
    -- upvalues: u11 (ref), MenuState (copy)
    local v142 = u11 == "Halftime";

    if p141:FindFirstChild("Menu") then
        MenuState.HideMenu();
    end;

    local Gameplay = p141:FindFirstChild("Gameplay");

    if not Gameplay then
        return;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");
    local v143;

    if Middle then
        v143 = Middle:FindFirstChild("EndScreen") or nil;
    else
        v143 = nil;
    end;

    local v144;

    if Middle then
        v144 = Middle:FindFirstChild("Halftime") or nil;
    else
        v144 = nil;
    end;

    Gameplay.Visible = true;

    for _, child in Gameplay:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            child.Visible = child == Middle;
        end;
    end;

    if not Middle then
        return;
    end;

    Middle.Visible = true;

    for _, child in Middle:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            if child == v143 then
                child.Visible = not v142;
            elseif child == v144 then
                child.Visible = v142;
            else
                child.Visible = false;
            end;
        end;
    end;

    if v143 then
        v143.Visible = not v142;
    end;

    if v144 then
        v144.Visible = v142;
    end;
end;

local function showEndScreenUI(p145) -- Line: 1104
    -- upvalues: PlayerGui (copy), captureVisibilitySnapshot (copy), CameraController (copy), MenuState (copy), Halftime (copy), u7 (copy), RunServiceController (copy), enforceEndScreenVisibility (copy), setElementTransparency (copy)
    local didWin = p145.didWin;
    local isDraw = p145.isDraw;
    local winningTeam = p145.winningTeam;
    local ctScore = p145.ctScore;
    local tScore = p145.tScore;
    local scoreTextOverride = p145.scoreTextOverride;
    local showAccolades = p145.showAccolades;
    local returnToMenu = p145.returnToMenu;
    local v146 = p145.overlayMode == "Halftime";
    local halftimeTeam = p145.halftimeTeam;
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if not MainGui then
        return;
    end;

    captureVisibilitySnapshot(MainGui);
    CameraController.setForceLockOverride("EndScreen", true);
    CameraController.setPerspective(false, true);

    if MainGui:FindFirstChild("Menu") then
        MenuState.HideMenu();
        CameraController.setForceLockOverride("Menu", false);
    end;

    local Gameplay = MainGui:FindFirstChild("Gameplay");

    if not Gameplay then
        return;
    end;

    Gameplay.Visible = true;

    for _, child in Gameplay:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            child.Visible = false;
        end;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");

    if not Middle then
        return;
    end;

    for _, child in Middle:GetChildren() do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            child.Visible = false;
        end;
    end;

    Middle.Visible = true;
    local EndScreen = Middle:FindFirstChild("EndScreen");
    local Halftime2 = Middle:FindFirstChild("Halftime");

    if v146 then
        if EndScreen then
            EndScreen.Visible = false;
        end;

        if Halftime2 and (halftimeTeam == "Counter-Terrorists" or halftimeTeam == "Terrorists") then
            Halftime.Show(halftimeTeam);
        else
            Halftime.Hide();
        end;

        u7:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1172
            -- upvalues: enforceEndScreenVisibility (ref), MainGui (copy)
            enforceEndScreenVisibility(MainGui);
        end), "Disconnect", "EndScreenVisibilityLock");

        return;
    end;

    Halftime.Hide();

    if not EndScreen then
        return;
    end;

    local MapVote = EndScreen:FindFirstChild("MapVote");

    if MapVote then
        MapVote.Visible = false;
    end;

    local Top = EndScreen:FindFirstChild("Top");

    if Top then
        Top.Visible = false;
    end;

    EndScreen.Visible = true;
    local Victory = EndScreen:FindFirstChild("Victory");
    local Defeat = EndScreen:FindFirstChild("Defeat");

    if Victory then
        Victory.BackgroundTransparency = 0;

        for _, descendant in Victory:GetDescendants() do
            setElementTransparency(descendant, 0);
        end;

        Victory.Visible = isDraw or didWin;
    end;

    if Defeat then
        Defeat.BackgroundTransparency = 0;

        for _, descendant in Defeat:GetDescendants() do
            setElementTransparency(descendant, 0);
        end;

        Defeat.Visible = not isDraw and not didWin;
    end;

    local MVP = EndScreen:FindFirstChild("MVP");

    if MVP then
        MVP.Visible = showAccolades;
    end;

    local Close = EndScreen:FindFirstChild("Close");

    if Close then
        Close.Visible = returnToMenu;
    end;

    local v147;

    if isDraw then
        v147 = scoreTextOverride or `<b>{ctScore}</b> - {tScore}`;
    else
        if winningTeam == "Counter-Terrorists" then
            local v148 = ctScore;
            ctScore = tScore;
            tScore = v148;
        end;

        v147 = scoreTextOverride or `<b>{tScore}</b> - {ctScore}`;
    end;

    local v149 = Victory and Victory:FindFirstChild("Score");

    if v149 then
        v149.BackgroundColor3 = Color3.fromRGB(11, 97, 31);
        v149.Glow.ImageColor3 = Color3.fromRGB(46, 158, 78);
        v149.Pattern.ImageColor3 = Color3.fromRGB(134, 255, 78);
        v149.UIStroke.Color = Color3.fromRGB(48, 127, 48);
        local TextLabel = v149:FindFirstChild("TextLabel");

        if TextLabel then
            TextLabel.Text = v147;
        end;
    end;

    local v150 = Defeat and Defeat:FindFirstChild("Score");

    if v150 then
        v150.BackgroundColor3 = Color3.fromRGB(83, 9, 9);
        v150.Glow.ImageColor3 = Color3.fromRGB(158, 14, 14);
        v150.Pattern.ImageColor3 = Color3.fromRGB(255, 53, 53);
        v150.UIStroke.Color = Color3.fromRGB(127, 48, 48);
        local TextLabel = v150:FindFirstChild("TextLabel");

        if TextLabel then
            TextLabel.Text = v147;
        end;
    end;

    local v151 = Victory and Victory:FindFirstChild("TextLabel");

    if v151 then
        v151.Text = isDraw and "Draw" or "Victory";
    end;

    local v152 = Defeat and Defeat:FindFirstChild("TextLabel");

    if v152 then
        v152.Text = isDraw and "Draw" or "Defeat";
    end;

    local Level = EndScreen:FindFirstChild("Level");

    if Level then
        Level.Visible = false;
    end;

    local Drops = EndScreen:FindFirstChild("Drops");

    if Drops then
        Drops.Visible = false;
    end;

    u7:Add(RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function() -- Line: 1285
        -- upvalues: enforceEndScreenVisibility (ref), MainGui (copy)
        enforceEndScreenVisibility(MainGui);
    end), "Disconnect", "EndScreenVisibilityLock");
end;

local function hideEndScreenUI() -- Line: 1290
    -- upvalues: PlayerGui (copy), Halftime (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if not MainGui then
        return;
    end;

    local Gameplay = MainGui:FindFirstChild("Gameplay");

    if not Gameplay then
        return;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");

    if not Middle then
        return;
    end;

    local EndScreen = Middle:FindFirstChild("EndScreen");

    if not EndScreen then
        return;
    end;

    EndScreen.Visible = false;
    Halftime.Hide();
    local Victory = EndScreen:FindFirstChild("Victory");
    local Defeat = EndScreen:FindFirstChild("Defeat");
    local Level = EndScreen:FindFirstChild("Level");

    if Victory then
        Victory.Visible = false;
    end;

    if Defeat then
        Defeat.Visible = false;
    end;

    if Level then
        Level.Visible = false;
        local LevelBar = Level:FindFirstChild("LevelBar");

        if LevelBar then
            local Current = LevelBar:FindFirstChild("Current");
            local Earned = LevelBar:FindFirstChild("Earned");

            if Current then
                Current:SetAttribute("SkipFade", nil);
            end;

            if Earned then
                Earned:SetAttribute("SkipFade", nil);
            end;
        end;

        local CurrentInfo = Level:FindFirstChild("CurrentInfo", true);
        local EarnedInfo = Level:FindFirstChild("EarnedInfo", true);

        if CurrentInfo then
            CurrentInfo:SetAttribute("SkipFade", nil);
        end;

        if EarnedInfo then
            EarnedInfo:SetAttribute("SkipFade", nil);
        end;
    end;

    local MVP = EndScreen:FindFirstChild("MVP");

    if MVP then
        MVP.Visible = false;

        for i = 1, 5 do
            local v153 = MVP:FindFirstChild((tostring(i)));

            if v153 then
                v153.Visible = false;
            end;
        end;
    end;

    local Drops = EndScreen:FindFirstChild("Drops");

    if Drops then
        Drops.Visible = false;
        local Container = Drops:FindFirstChild("Container");

        if Container then
            Container:SetAttribute("SkipFade", nil);

            for _, child in Container:GetChildren() do
                if child:IsA("Frame") and child.Name ~= "ItemTemplate" then
                    child:Destroy();
                end;
            end;
        end;
    end;

    local MapVote = EndScreen:FindFirstChild("MapVote");

    if MapVote then
        MapVote.Visible = true;
    end;

    local Top = EndScreen:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;
end;

local function getEquippedGloveId(p154) -- Line: 1362
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v155 = DataController.Get(LocalPlayer, "Loadout");

    if type(v155) ~= "table" then
        return nil;
    end;

    local v156 = v155[p154];

    if type(v156) ~= "table" or not v156.Equipped then
        return nil;
    end;

    local v157 = v156.Equipped["Equipped Gloves"];

    if type(v157) == "string" and v157 ~= "" then
        return v157;
    end;

    return nil;
end;

local function findInventoryItem(p158) -- Line: 1374
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v159 = DataController.Get(LocalPlayer, "Inventory");

    if type(v159) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v159) do
        if v and v._id == p158 then
            return v;
        end;
    end;

    return nil;
end;

local function attachGlovesToCharacter(p160, p161, p162) -- Line: 1386
    -- upvalues: DataController (copy), LocalPlayer (copy), findInventoryItem (copy), u5 (copy), Skins (copy), ReplicatedStorage (copy), AttachGlovesToCharacter (copy)
    local v163 = nil;
    local v164 = nil;
    local v165 = nil;

    if p162 then
        v163 = p162.Name;
        v164 = p162.Skin;
        v165 = p162.Float;
    else
        local v166 = p161 == "CT" and "Counter-Terrorists" or "Terrorists";
        local v167 = DataController.Get(LocalPlayer, "Loadout");
        local v168;

        if type(v167) == "table" then
            local v169 = v167[v166];

            if type(v169) == "table" and v169.Equipped then
                v168 = v169.Equipped["Equipped Gloves"];

                if type(v168) ~= "string" or v168 == "" then
                    v168 = nil;
                end;
            else
                v168 = nil;
            end;
        else
            v168 = nil;
        end;

        if v168 then
            local v170 = findInventoryItem(v168);

            if v170 then
                v163 = v170.Name;
                v164 = v170.Skin;
                v165 = v170.Float;
            end;
        end;
    end;

    local v171 = v163 or u5[p161].Glove;
    local v172;

    if v164 and (v164 ~= "" and v165 ~= nil) then
        v172 = Skins.GetGloves(v171, v164, v165) or nil;
    else
        v172 = nil;
    end;

    local v173;

    if v172 then
        v173 = v172:GetChildren();
    else
        local v174 = ReplicatedStorage.Assets.Weapons:FindFirstChild(v171);

        if not v174 then
            return;
        end;

        v173 = v174:GetChildren();
    end;

    local v175 = p160:FindFirstChild("CharacterArmor") or Instance.new("Folder");
    v175.Name = "CharacterArmor";
    v175.Parent = p160;
    AttachGlovesToCharacter(v173, p160, v175);
end;

local function getEquippedWeaponFromLoadout(p176, p177) -- Line: 1426
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v178 = DataController.Get(LocalPlayer, "Loadout");

    if type(v178) ~= "table" then
        return nil;
    end;

    local v179 = v178[p176];

    if type(v179) ~= "table" or not v179.Loadout then
        return nil;
    end;

    local Rifles = v179.Loadout.Rifles;

    if not Rifles or type(Rifles.Options) ~= "table" then
        return nil;
    end;

    local v180 = DataController.Get(LocalPlayer, "Inventory");

    if type(v180) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(Rifles.Options) do
        if type(v) == "string" and v ~= "" then
            for _, v2 in ipairs(v180) do
                if v2 and (v2._id == v and v2.Name == p177) then
                    return {
                        Skin = v2.Skin,
                        Float = v2.Float,
                        StatTrack = v2.StatTrack,
                        NameTag = v2.NameTag
                    };
                end;
            end;
        end;
    end;

    return nil;
end;

local function attachWeaponToCharacter(p181, p182, p183) -- Line: 1452
    -- upvalues: u5 (copy), Skins (copy), getEquippedWeaponFromLoadout (copy), u2 (copy)
    local Weapon = u5[p182].Weapon;
    local v184 = nil;

    if p183 and (p183.Skin and p183.Skin ~= "") then
        v184 = Skins.GetCharacterModel(Weapon, p183.Skin, p183.Float, p183.StatTrack, p183.NameTag);
    else
        local v185 = getEquippedWeaponFromLoadout(p182 == "CT" and "Counter-Terrorists" or "Terrorists", Weapon);

        if v185 and (v185.Skin and v185.Skin ~= "") then
            v184 = Skins.GetCharacterModel(Weapon, v185.Skin, v185.Float, v185.StatTrack, v185.NameTag);
        end;
    end;

    local v186 = v184 or Skins.GetBaseWeaponModel(Weapon, "Character");

    if not v186 then
        return;
    end;

    v186.Name = Weapon;
    local RightHand = p181:FindFirstChild("RightHand");

    if not RightHand then
        v186:Destroy();

        return;
    end;

    if not v186.PrimaryPart then
        local Weapon2 = v186:FindFirstChild("Weapon");

        if Weapon2 then
            Weapon2 = Weapon2:FindFirstChild("Insert");
        end;

        if not Weapon2 then
            v186:Destroy();

            return;
        end;

        v186.PrimaryPart = Weapon2;
    end;

    for _, descendant in v186:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = false;
            descendant.Massless = true;
        end;
    end;

    v186.Parent = p181;
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = "WeaponAttachment";
    Motor6D.Part0 = RightHand;
    Motor6D.Part1 = v186.PrimaryPart;
    Motor6D.Parent = RightHand;

    if Weapon == "AK-47" then
        Motor6D.C0 = u2;

        return;
    end;

    local Properties = v186:FindFirstChild("Properties");

    if Properties then
        local C0 = Properties:FindFirstChild("C0");
        local C1 = Properties:FindFirstChild("C1");

        if C0 then
            Motor6D.C0 = C0.Value;
        end;

        if C1 then
            Motor6D.C1 = C1.Value;
        end;
    end;
end;

local function calculateHSP(p187, p188) -- Line: 1517
    local v189 = p187 or 0;

    return v189 <= 0 and "0%" or `{math.floor((p188 or 0) / v189 * 100)}%`;
end;

local function populateMVPFrame(p190) -- Line: 1527
    -- upvalues: PlayerGui (copy), Players (copy), DataController (copy), Skins (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if not MainGui then
        return;
    end;

    local Gameplay = MainGui:FindFirstChild("Gameplay");

    if not Gameplay then
        return;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");

    if not Middle then
        return;
    end;

    local EndScreen = Middle:FindFirstChild("EndScreen");

    if not EndScreen then
        return;
    end;

    local MVP = EndScreen:FindFirstChild("MVP");

    if not MVP then
        return;
    end;

    local v191 = { 3, 2, 4, 1, 5 };

    for i = 1, 5 do
        local v192 = MVP:FindFirstChild((tostring(i)));

        if v192 then
            v192.Visible = false;
        end;
    end;

    for i, v in ipairs(p190) do
        local v193 = MVP:FindFirstChild((tostring(v191[i])));

        if v193 then
            local data = v.data;
            local userId = v.userId;
            local v194 = Players:GetPlayerByUserId((tonumber(userId)));
            local v195 = v194 and v194.Name or `Player_{userId}`;
            local Username = v193:FindFirstChild("Username");

            if Username then
                Username.Text = v195;
            end;

            local KDA = v193:FindFirstChild("KDA");

            if KDA then
                KDA.Text = `{data.Kills or 0}-{data.Deaths or 0}-{data.Assists or 0}`;
            end;

            local HSP = v193:FindFirstChild("HSP");

            if HSP then
                local v196 = data.Kills or 0;
                HSP.Text = v196 <= 0 and "0%" or `{math.floor((data.Headshots or 0) / v196 * 100)}%`;
            end;

            local APR = v193:FindFirstChild("APR");

            if APR then
                local v197 = math.floor(data.ADR or 0);
                APR.Text = tostring(v197);
            end;

            local Score = v193:FindFirstChild("Score");

            if not Score then
                for _, child in v193:GetChildren() do
                    if child:IsA("TextLabel") and (child.Name == "NameScore" and child.Text ~= "SCORE") then
                        Score = child;
                        break;
                    end;
                end;
            end;

            if Score then
                Score.Text = tostring(data.Score or 0);
            end;

            local Category = v193:FindFirstChild("Category");

            if Category then
                Category.Text = data.Accolade or "Participant";
            end;

            local Player = v193:FindFirstChild("Player");
            local v198 = Player and Player:FindFirstChild("Avatar");

            if v198 then
                v198.Image = `rbxthumb://type=AvatarHeadShot&id={userId}&w=150&h=150`;
            end;

            local Pin = v193:FindFirstChild("Pin");

            if Pin then
                if v194 and data.Team then
                    local v199, v200 = DataController.Get(v194, "Loadout", "Inventory");
                    local v201 = "";

                    if v199 and v200 then
                        local v202 = v199[data.Team];

                        if v202 and v202.Equipped then
                            local v203 = v202.Equipped["Equipped Badge"];

                            if v203 and v203 ~= "" then
                                for _, v2 in ipairs(v200) do
                                    if v2._id == v203 then
                                        local v204 = Skins.GetSkinInformation(v2.Name, v2.Skin);

                                        if v204 and v204.imageAssetId then
                                            v201 = v204.imageAssetId;
                                        end;

                                        break;
                                    end;
                                end;
                            end;
                        end;
                    end;

                    if v201 == "" then
                        Pin.Visible = false;
                    else
                        Pin.Image = v201;
                        Pin.Visible = true;
                    end;
                else
                    Pin.Visible = false;
                end;
            end;

            v193.Visible = true;
        end;
    end;
end;

local function spawnEndScreenCharacters(p205, p206) -- Line: 1661
    -- upvalues: populateMVPFrame (copy), u6 (copy), u5 (copy), Characters (copy), attachGlovesToCharacter (copy), attachWeaponToCharacter (copy), u4 (copy), u7 (copy)
    local v207 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen");

    if not v207 then
        return {};
    end;

    local v208 = {};

    for i = 1, math.min(5, #p205) do
        table.insert(v208, p205[i]);
    end;

    if p206 then
        populateMVPFrame(v208);
    end;

    local v209 = { 3, 2, 4, 1, 5 };
    local v210 = {};

    for i, v in ipairs(v208) do
        local v211 = v209[i];
        local v212 = v207:FindFirstChild((tostring(v211)));

        if v212 then
            local v213 = u6[v.data.Team];

            if v213 then
                local v214 = u5[v213];

                if v214 then
                    local v215 = Characters:FindFirstChild(v214.Character);

                    if v215 then
                        local v216 = v215:Clone();
                        v216.Name = "EndScreenCharacter_" .. v.userId;
                        v216:PivotTo(v212.CFrame);
                        v216.Parent = v207;
                        attachGlovesToCharacter(v216, v213, v.data.Gloves);
                        attachWeaponToCharacter(v216, v213, v.data.Weapon);
                        local Humanoid = v216:FindFirstChild("Humanoid");

                        if Humanoid then
                            local v217 = Humanoid:FindFirstChildOfClass("Animator");

                            if not v217 then
                                v217 = Instance.new("Animator");
                                v217.Parent = Humanoid;
                            end;

                            local v218 = u4[v211];

                            if v218 then
                                local Animation = Instance.new("Animation");
                                Animation.AnimationId = v218.Entrance;
                                local v219 = v217:LoadAnimation(Animation);
                                v219.Looped = false;
                                v219.Priority = Enum.AnimationPriority.Action;
                                v219:Play();
                                local Animation2 = Instance.new("Animation");
                                Animation2.AnimationId = v218.Idle;
                                local v220 = v217:LoadAnimation(Animation2);
                                v220.Looped = true;
                                v220.Priority = Enum.AnimationPriority.Idle;
                                v220:Play();
                                u7:Add(Animation);
                                u7:Add(v219);
                                u7:Add(Animation2);
                                u7:Add(v220);
                            end;
                        end;

                        u7:Add(v216, "Destroy");
                        table.insert(v210, v216);
                    end;
                end;
            end;
        end;
    end;

    return v210;
end;

local function animateCamera() -- Line: 1757
    -- upvalues: CurrentCamera (copy), CameraController (copy), TweenService (copy)
    local v221 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EndScreen");

    if not v221 then
        return nil;
    end;

    local Start = v221:FindFirstChild("Start");
    local End = v221:FindFirstChild("End");

    if not (Start and End) then
        warn("[EndScreen] Missing Start or End part!");

        return nil;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.CFrame = Start.CFrame;
    CurrentCamera.Focus = Start.CFrame;
    CurrentCamera.FieldOfView = CameraController.clampFOV(60);
    CameraController.setMouseEnabled(true);
    local v222 = TweenService:Create(CurrentCamera, TweenInfo.new(14, Enum.EasingStyle.Linear), {
        CFrame = End.CFrame
    });
    v222:Play();

    return v222;
end;

local function closeAllActiveScenes() -- Line: 1792
    -- upvalues: MenuState (copy), Router (copy), PlayerGui (copy), CameraController (copy), ReplicatedStorage (copy)
    MenuState.SetBlurEnabled(false);

    if MenuState.IsCaseSceneActive() then
        Router.broadcastRouter("CaseSceneCloseForGameEnd");
    end;

    if MenuState.IsInspectActive() then
        Router.broadcastRouter("WeaponInspectCloseForGameEnd");
    end;

    if MenuState.IsTradeUpActive() then
        return;
    end;

    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        local Menu = MainGui:FindFirstChild("Menu");

        if Menu and Menu.Visible then
            MenuState.HideMenu();
            CameraController.setForceLockOverride("Menu", false);
        end;

        if Menu then
            Menu.BackgroundTransparency = 1;
        end;
    end;

    local MainGui2 = PlayerGui:FindFirstChild("MainGui");
    local v223;

    if MainGui2 then
        local Gameplay = MainGui2:FindFirstChild("Gameplay");

        if Gameplay then
            v223 = Gameplay:FindFirstChild("Middle");
        else
            v223 = nil;
        end;
    else
        v223 = nil;
    end;

    if not v223 then
        return;
    end;

    local BuyMenu = v223:FindFirstChild("BuyMenu");

    if BuyMenu and BuyMenu.Visible then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu).closeFrame();
    end;

    local TeamSelection = v223:FindFirstChild("TeamSelection");

    if TeamSelection and TeamSelection.Visible then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection).closeFrame();
    end;
end;

function u1.IsActive() -- Line: 1845
    -- upvalues: u8 (ref)
    return u8;
end;

local function showMainMenuAfterEndScreen() -- Line: 1849
    -- upvalues: ReplicatedStorage (copy), PlayerGui (copy), CameraController (copy)
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
    local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
    MenuSceneController.ShowMenuScene();
    Top.ResetToMainMenu();
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if not MainGui then
        return;
    end;

    CameraController.setForceLockOverride("Menu", true);
    CameraController.setPerspective(true, true);
    MainGui.Menu.Visible = true;
    MainGui.Gameplay.Visible = false;
    MainGui.Gameplay.Bottom.Visible = false;
end;

function u1.ExitMapVoteToMenu() -- Line: 1873
    -- upvalues: u8 (ref), MenuState (copy), u1 (copy), CameraController (copy), hideEndScreenUI (copy), showMainMenuAfterEndScreen (copy), u12 (ref), u10 (ref)
    if u8 then
        MenuState.SetWantsMainMenu(true);
        u1._finishSequence(true);

        return;
    end;

    MenuState.SetWantsMainMenu(true);
    CameraController.setForceLockOverride("EndScreen", false);
    hideEndScreenUI();
    CameraController.SetEnabled(true);
    showMainMenuAfterEndScreen();
    u12 = nil;
    u10 = true;
end;

function u1._runSequence(u224) -- Line: 1890
    -- upvalues: u9 (ref), u10 (ref), u11 (ref), cleanupDebris (copy), showEndScreenUI (copy), spawnEndScreenCharacters (copy), animateCamera (copy), u7 (copy), PlayerGui (copy), populateLevelFrame (copy), fadeFrame (copy), fadeInFrame (copy), animateLevelBar (copy), displayDrops (copy), u1 (copy)
    u9 = u9 + 1;
    local u225 = u9;
    u10 = u224.returnToMenu;
    u11 = u224.overlayMode;
    cleanupDebris();
    showEndScreenUI(u224);
    spawnEndScreenCharacters(u224.displayPlayers, u224.showAccolades);
    local v226 = animateCamera();

    if v226 then
        u7:Add(v226, "Cancel");
    end;

    if u224.showProgression then
        task.delay(4, function() -- Line: 1908
            -- upvalues: u225 (copy), u9 (ref), PlayerGui (ref), populateLevelFrame (ref), u224 (copy), fadeFrame (ref), fadeInFrame (ref), animateLevelBar (ref), displayDrops (ref)
            if u225 ~= u9 then
                return;
            end;

            local MainGui = PlayerGui:FindFirstChild("MainGui");
            local v227;

            if MainGui then
                local Gameplay = MainGui:FindFirstChild("Gameplay");

                if Gameplay then
                    v227 = Gameplay:FindFirstChild("Middle");
                else
                    v227 = nil;
                end;
            else
                v227 = nil;
            end;

            local v228;

            if v227 then
                v228 = v227:FindFirstChild("EndScreen");
            else
                v228 = nil;
            end;

            if not v228 then
                return;
            end;

            local Victory = v228:FindFirstChild("Victory");
            local Defeat = v228:FindFirstChild("Defeat");
            local Level = v228:FindFirstChild("Level");
            local u229 = populateLevelFrame(u224.xpEarned);
            local v230 = u224.isDraw and Victory and Victory or (u224.didWin and Victory and Victory or Defeat);

            if v230 and v230.Visible then
                fadeFrame(v230, 1);
            end;

            task.delay(0.5, function() -- Line: 1925
                -- upvalues: u225 (ref), u9 (ref), Victory (copy), Defeat (copy), Level (copy), fadeInFrame (ref), u229 (copy), animateLevelBar (ref), u224 (ref), displayDrops (ref)
                if u225 ~= u9 then
                    return;
                end;

                if Victory then
                    Victory.Visible = false;
                end;

                if Defeat then
                    Defeat.Visible = false;
                end;

                if Level then
                    fadeInFrame(Level);
                    task.spawn(function() -- Line: 1934
                        -- upvalues: u229 (ref), animateLevelBar (ref), u224 (ref), displayDrops (ref)
                        if u229 then
                            animateLevelBar(u229);
                        end;

                        if u224.levelRewards and #u224.levelRewards > 0 then
                            displayDrops(u224.levelRewards);
                        end;
                    end);
                end;
            end);
        end);
    end;

    task.delay(u224.sequenceDuration or (u224.showProgression and 14 or 4), function() -- Line: 1952
        -- upvalues: u225 (copy), u9 (ref), u1 (ref), u224 (copy)
        if u225 ~= u9 then
            return;
        end;

        u1._finishSequence(u224.returnToMenu);
    end);
end;

function u1._finishSequence(p231) -- Line: 1958
    -- upvalues: u10 (ref), u9 (ref), u11 (ref), u8 (ref), CameraController (copy), u7 (copy), hideEndScreenUI (copy), PlayerGui (copy), showMainMenuAfterEndScreen (copy), u12 (ref), restoreVisibilitySnapshot (copy), MenuState (copy), DataController (copy), LocalPlayer (copy), u13 (ref)
    if p231 == nil then
        p231 = u10;
    end;

    if typeof(p231) ~= "boolean" then
        p231 = p231 and true or u10;
    end;

    u9 = u9 + 1;
    u11 = "EndScreen";
    u8 = false;
    CameraController.setForceLockOverride("EndScreen", false);
    u7:Cleanup();
    hideEndScreenUI();
    CameraController.SetEnabled(true);
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if p231 then
        showMainMenuAfterEndScreen();
        u12 = nil;
        u10 = true;
    elseif MainGui and u12 then
        restoreVisibilitySnapshot(MainGui, true);
        MenuState.HideMenu();
        MainGui.Gameplay.Visible = true;
        CameraController.setPerspective(true, false);
    else
        showMainMenuAfterEndScreen();
        u12 = nil;
        u10 = true;
    end;

    local v232 = DataController.Get(LocalPlayer, "Level");

    if v232 then
        u13 = {
            Level = v232.Level,
            Experience = v232.Experience,
            NextExperienceRequirement = v232.NextExperienceRequirement
        };
    end;
end;

function u1.Begin(p233) -- Line: 2009
    -- upvalues: u8 (ref), u1 (copy), MenuState (copy), Router (copy), LocalPlayer (copy), rankFFAPlayers (copy), sortPlayersByADR (copy), closeAllActiveScenes (copy), SpectateController (copy), CameraController (copy)
    local v234 = p233.Halftime == true and "Halftime" or "EndScreen";

    if u8 then
        warn("[EndScreen] Interrupting active sequence for new end screen");
        local success, result = pcall(u1._finishSequence, false);

        if not success then
            warn("[EndScreen] _finishSequence error during interrupt: " .. tostring(result));
        end;

        u8 = false;
    end;

    if MenuState.IsCaseSceneActive() and Router.broadcastRouter("IsCaseSceneRolling") == true then
        return;
    end;

    if MenuState.IsTradeUpActive() then
        return;
    end;

    local v235 = workspace:GetAttribute("Gamemode") == "Deathmatch";
    local v236;

    if p233.Players then
        v236 = p233.Players[tostring(LocalPlayer.UserId)] or nil;
    else
        v236 = nil;
    end;

    if not v236 then
        warn(("[EndScreen] Local player missing from payload (userId=%s, teamAttr=%s, winningTeam=%s)"):format(tostring(LocalPlayer.UserId), tostring(LocalPlayer:GetAttribute("Team")), (tostring(p233.WinningTeam))));
        local v237 = LocalPlayer:GetAttribute("Team");

        if v237 ~= "Counter-Terrorists" and v237 ~= "Terrorists" then
            return;
        end;

        if v235 then
            return;
        end;
    end;

    local v238 = v236 and v236.Team or LocalPlayer:GetAttribute("Team");
    local v239 = p233.WinningTeam == "Draw";
    local v240 = nil;
    local v241 = p233.ShowAccolades ~= false;
    local v242 = p233.ShowProgression ~= false;
    local SequenceDuration = p233.SequenceDuration;
    local v243 = p233.ReturnToMenu ~= false;
    local v244, v245;

    if v235 then
        local v246, v247;

        if not v236 then
            v246 = warn;
            v247 = "[EndScreen] Begin skipped for Deathmatch: invalid team data (team=%s)";

            if v236 then
                v236 = v236.Team;
            end;

            v246(v247:format((tostring(v236))));

            return;
        end;

        local Team = v236.Team;

        if Team ~= "Counter-Terrorists" and Team ~= "Terrorists" then
            v246 = warn;
            v247 = "[EndScreen] Begin skipped for Deathmatch: invalid team data (team=%s)";

            if v236 then
                v236 = v236.Team;
            end;

            v246(v247:format((tostring(v236))));

            return;
        end;

        v244 = rankFFAPlayers(p233.Players);

        if #v244 == 0 then
            warn("[EndScreen] Begin skipped for Deathmatch: no eligible ranked players");

            return;
        end;

        local v248 = nil;

        for i, v in ipairs(v244) do
            if v.userId == tostring(LocalPlayer.UserId) then
                v248 = i;
                break;
            end;
        end;

        if not v248 then
            warn(("[EndScreen] Begin skipped for Deathmatch: local player missing from ranked list (userId=%s)"):format((tostring(LocalPlayer.UserId))));

            return;
        end;

        v245 = v248 == 1;

        if not v240 then
            local v249 = v248 % 100;
            local v250;

            if v249 >= 11 and v249 <= 13 then
                v250 = `{v248}th`;
            else
                local v251 = v248 % 10;

                if v251 == 1 then
                    v250 = `{v248}st`;
                elseif v251 == 2 then
                    v250 = `{v248}nd`;
                elseif v251 == 3 then
                    v250 = `{v248}rd`;
                else
                    v250 = `{v248}th`;
                end;
            end;

            v240 = `You placed {v250}`;
        end;
    else
        if v238 ~= "Counter-Terrorists" and v238 ~= "Terrorists" then
            warn(("[EndScreen] Begin skipped: invalid team (team=%s, teamAttr=%s, winningTeam=%s)"):format(tostring(v238), tostring(LocalPlayer:GetAttribute("Team")), (tostring(p233.WinningTeam))));

            return;
        end;

        v245 = not v239 and p233.WinningTeam == v238;
        local v252 = {};

        for i, v in pairs(p233.Players) do
            if v.Team == v238 then
                v252[i] = v;
            end;
        end;

        v244 = sortPlayersByADR(v252);
    end;

    local success, result = pcall(closeAllActiveScenes);

    if not success then
        warn("[EndScreen] closeAllActiveScenes error: " .. tostring(result));
    end;

    local success2, result2 = pcall(SpectateController.Stop, false, true);

    if not success2 then
        warn("[EndScreen] SpectateController.Stop error: " .. tostring(result2));
    end;

    CameraController.SetEnabled(false);
    u8 = true;
    local v253 = v236 and v236.ExperienceEarned or 0;
    local v254 = {};

    for i in pairs(p233.Players) do
        local v255 = tonumber(i);

        if v255 then
            table.insert(v254, v255);
        end;
    end;

    table.sort(v254);
    local v256 = {};

    for _, v in ipairs(v254) do
        local v257 = p233.Players[tostring(v)];

        if v257 then
            v257 = v257.LevelRewards;
        end;

        if v257 then
            for _, v2 in ipairs(v257) do
                table.insert(v256, {
                    userId = v,
                    reward = v2
                });
            end;
        end;
    end;

    u1._runSequence({
        displayPlayers = v244,
        didWin = v245,
        isDraw = v239,
        winningTeam = p233.WinningTeam,
        xpEarned = v253,
        levelRewards = v256,
        ctScore = p233.CTScore or 0,
        tScore = p233.TScore or 0,
        scoreTextOverride = v240,
        showAccolades = v241,
        showProgression = v242,
        sequenceDuration = SequenceDuration,
        returnToMenu = v243,
        overlayMode = v234,
        halftimeTeam = v238
    });
end;

function u1.Initialize() -- Line: 2170
    -- upvalues: PlayerGui (copy), ActivateButton (copy), CloseButtonRegistry (copy), u1 (copy), MenuState (copy), GameState (copy), DataController (copy), LocalPlayer (copy), u13 (ref), Remotes (copy), u8 (ref)
    local MainGui = PlayerGui:FindFirstChild("MainGui");
    local v258;

    if MainGui then
        local Gameplay = MainGui:FindFirstChild("Gameplay");

        if Gameplay then
            v258 = Gameplay:FindFirstChild("Middle");
        else
            v258 = nil;
        end;
    else
        v258 = nil;
    end;

    local v259;

    if v258 then
        v259 = v258:FindFirstChild("EndScreen");
    else
        v259 = nil;
    end;

    if v259 then
        local Drops = v259:FindFirstChild("Drops");

        if Drops then
            Drops.Visible = false;
        end;

        local Close = v259:FindFirstChild("Close");

        if Close then
            ActivateButton(Close);
            CloseButtonRegistry.Add(v259, Close, function() -- Line: 2183
                -- upvalues: u1 (ref), MenuState (ref), GameState (ref)
                if not u1.IsActive() then
                    if GameState.GetState() == "Map Voting" then
                        u1.ExitMapVoteToMenu();
                    end;

                    return;
                end;

                MenuState.SetWantsMainMenu(true);
                u1._finishSequence(true);
            end);
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Level", function(p260) -- Line: 2197
        -- upvalues: u13 (ref)
        if u13 == nil and p260 then
            u13 = {
                NextExperienceRequirement = p260.NextExperienceRequirement,
                Experience = p260.Experience,
                Level = p260.Level
            };
        end;
    end);
    Remotes.Match.EndScreen.Listen(function(p261) -- Line: 2207
        -- upvalues: u1 (ref), u8 (ref)
        local success, result = pcall(u1.Begin, p261);

        if not success then
            warn("[EndScreen] Begin failed: " .. tostring(result));

            if u8 then
                pcall(u1._finishSequence);
            end;
        end;
    end);
end;

return u1;