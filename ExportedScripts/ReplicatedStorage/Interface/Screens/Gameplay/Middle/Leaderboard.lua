-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local u2 = Color3.fromRGB(165, 183, 212);
local u3 = Color3.fromRGB(219, 199, 126);
local u4 = Color3.fromRGB(81, 81, 81);
local u5 = Color3.fromRGB(95, 95, 95);
local u6 = Color3.fromRGB(255, 255, 255);
local u7 = {
    BombDefuse = "rbxassetid://138772806705472",
    BombExplode = "rbxassetid://97682949239067",
    BombObjective = "rbxassetid://97682949239067",
    Elimination = "rbxassetid://70876442749327",
    TimeExpiration = "rbxassetid://96043369049959",
    HostageRescue = "rbxassetid://138772806705472"
};
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon);
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local ProfileInspect = require(script:WaitForChild("ProfileInspect"));
local u8 = UDim2.fromScale(0.582, 0.782);
local u9 = UDim2.fromScale(0.582, 0.355);
local u10 = UDim2.fromScale(0.273, 0.85);
local u11 = UDim2.fromScale(0.82, 0.9);
local u12 = UDim2.fromScale(0.758, 0.9);
local u13 = UDim2.fromScale(0.638, 0.9);
local u14 = UDim2.fromScale(0.937, 0.9);
local u15 = UDim2.fromScale(0.702, 0.9);
local u16 = UDim2.fromScale(0.882, 0.9);
local u17 = UDim2.fromScale(0.762, 0.365);
local u18 = UDim2.fromScale(0.503, 0.785);
local u19 = UDim2.fromScale(0.503, 0.364);
local u20 = UDim2.fromScale(0.135, 0.85);
local u21 = UDim2.fromScale(0.79, 0.9);
local u22 = UDim2.fromScale(0.715, 0.9);
local u23 = UDim2.fromScale(0.57, 0.9);
local u24 = UDim2.fromScale(0.932, 0.9);
local u25 = UDim2.fromScale(0.648, 0.9);
local u26 = UDim2.fromScale(0.866, 0.9);
local u27 = UDim2.fromScale(0.921, 0.365);
local u28 = Color3.new(1, 1, 1);
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = false;
local u35 = {};
local u36 = {};

local function commaNumber(p37) -- Line: 109
    return tostring(p37):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function clearFrame(p38) -- Line: 115
    local v39 = p38:GetChildren();

    for _, v in ipairs(v39) do
        if v.ClassName == "Frame" then
            v:Destroy();
        end;
    end;
end;

local function getPlayersOnTeam(p40) -- Line: 127
    -- upvalues: Players (copy)
    local v41 = {};

    for _, v in ipairs(Players:GetPlayers()) do
        if v:GetAttribute("Team") == p40 then
            table.insert(v41, v);
        end;
    end;

    return v41;
end;

local function lightenTowardWhite(p42) -- Line: 142
    -- upvalues: u28 (copy)
    return p42:Lerp(u28, 0.2);
end;

local function getMousePositionInLeaderboard() -- Line: 148
    -- upvalues: UserInputService (copy), GuiService (copy), u29 (ref)
    local v43 = UserInputService:GetMouseLocation();
    local v44 = GuiService:GetGuiInset();
    local AbsolutePosition = u29.AbsolutePosition;
    local AbsoluteSize = u29.AbsoluteSize;

    return UDim2.fromScale((v43.X - v44.X - AbsolutePosition.X) / AbsoluteSize.X, (v43.Y - v44.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
end;

local function resetProfileInspect() -- Line: 163
    -- upvalues: u30 (ref), u32 (ref), u31 (ref), ProfileInspect (copy)
    if not u30 then
        u32 = nil;

        return;
    end;

    u30.Visible = false;

    if u31 then
        u30.Position = u31;
    end;

    ProfileInspect.Reset();
    u32 = nil;
end;

local function openProfileInspect(p45) -- Line: 179
    -- upvalues: u30 (ref), u32 (ref), getMousePositionInLeaderboard (copy), ProfileInspect (copy)
    if not u30 then
        return;
    end;

    u32 = p45;
    u30.Position = getMousePositionInLeaderboard();
    ProfileInspect.Populate(p45);
    u30.Visible = true;
end;

local function bindPlayerRowInteractions(u46, u47, p48) -- Line: 192
    -- upvalues: u28 (copy), u30 (ref), u32 (ref), getMousePositionInLeaderboard (copy), ProfileInspect (copy)
    local BackgroundColor3 = u46.BackgroundColor3;
    local u49 = false;

    local function applyBackgroundColor() -- Line: 200
        -- upvalues: u46 (copy), u49 (ref), BackgroundColor3 (copy), u28 (ref)
        local v50;

        if u49 then
            v50 = BackgroundColor3:Lerp(u28, 0.2);
        else
            v50 = BackgroundColor3;
        end;

        u46.BackgroundColor3 = v50;
    end;

    u46.Active = true;
    p48:Add(u46.MouseEnter:Connect(function() -- Line: 207
        -- upvalues: u49 (ref), u46 (copy), BackgroundColor3 (copy), u28 (ref)
        u49 = true;
        local v51;

        if u49 then
            v51 = BackgroundColor3:Lerp(u28, 0.2);
        else
            v51 = BackgroundColor3;
        end;

        u46.BackgroundColor3 = v51;
    end));
    p48:Add(u46.MouseLeave:Connect(function() -- Line: 211
        -- upvalues: u49 (ref), u46 (copy), BackgroundColor3 (copy), u28 (ref)
        u49 = false;
        local v52;

        if u49 then
            v52 = BackgroundColor3:Lerp(u28, 0.2);
        else
            v52 = BackgroundColor3;
        end;

        u46.BackgroundColor3 = v52;
    end));
    p48:Add(u46.InputBegan:Connect(function(p53) -- Line: 215
        -- upvalues: u47 (copy), u30 (ref), u32 (ref), getMousePositionInLeaderboard (ref), ProfileInspect (ref)
        if p53.UserInputType == Enum.UserInputType.MouseButton1 then
            local v54 = u47;

            if not u30 then
                return;
            end;

            u32 = v54;
            u30.Position = getMousePositionInLeaderboard();
            ProfileInspect.Populate(v54);
            u30.Visible = true;
        end;
    end));
end;

local function getCharactersAlive(p55) -- Line: 224
    -- upvalues: RemoveFromArray (copy)
    return RemoveFromArray(p55, function(p56, p57) -- Line: 225
        local Character = p57.Character;

        if Character and Character:IsDescendantOf(workspace) then
            local v58 = Character:FindFirstChildOfClass("Humanoid");

            if v58 and v58.Health > 0 then
                return false;
            end;
        end;

        return true;
    end);
end;

local function updateAliveCounts() -- Line: 239
    -- upvalues: u29 (ref), getPlayersOnTeam (copy), RemoveFromArray (copy)
    if not u29 then
        return;
    end;

    local v59 = workspace:GetAttribute("Gamemode");

    if v59 ~= "Bomb Defusal" and v59 ~= "Hostage Rescue" then
        return;
    end;

    local v60 = getPlayersOnTeam("Counter-Terrorists");
    local v61 = getPlayersOnTeam("Terrorists");
    local v65 = RemoveFromArray(v60, function(p62, p63) -- Line: 225
        local Character = p63.Character;

        if Character and Character:IsDescendantOf(workspace) then
            local v64 = Character:FindFirstChildOfClass("Humanoid");

            if v64 and v64.Health > 0 then
                return false;
            end;
        end;

        return true;
    end);
    local v69 = RemoveFromArray(v61, function(p66, p67) -- Line: 225
        local Character = p67.Character;

        if Character and Character:IsDescendantOf(workspace) then
            local v68 = Character:FindFirstChildOfClass("Humanoid");

            if v68 and v68.Health > 0 then
                return false;
            end;
        end;

        return true;
    end);
    u29.Team.CT.Alive.Text = `ALIVE {tostring(#v65)}/{tostring(#v60)}`;
    u29.Team.T.Alive.Text = `ALIVE {tostring(#v69)}/{tostring(#v61)}`;
end;

local function observeAliveCountPlayer(p70) -- Line: 264
    -- upvalues: u36 (copy), Janitor (copy), updateAliveCounts (copy)
    local v71 = u36[p70];

    if v71 then
        v71:Destroy();
    end;

    local v72 = Janitor.new();
    local u73 = nil;
    u36[p70] = v72;

    local function bindCharacter(p74) -- Line: 274
        -- upvalues: u73 (ref), Janitor (ref), updateAliveCounts (ref)
        if u73 then
            u73:Destroy();
            u73 = nil;
        end;

        if p74 then
            local u75 = Janitor.new();
            u73 = u75;
            u75:Add(p74:GetAttributeChangedSignal("Dead"):Connect(updateAliveCounts));

            local function bindHumanoid(p76) -- Line: 285
                -- upvalues: u75 (copy), updateAliveCounts (ref)
                u75:Add(p76.HealthChanged:Connect(updateAliveCounts));
                updateAliveCounts();
            end;

            local v77 = p74:FindFirstChildOfClass("Humanoid");

            if v77 then
                u75:Add(v77.HealthChanged:Connect(updateAliveCounts));
                updateAliveCounts();
            else
                u75:Add(p74.ChildAdded:Connect(function(p78) -- Line: 294
                    -- upvalues: u75 (copy), updateAliveCounts (ref)
                    if p78:IsA("Humanoid") then
                        u75:Add(p78.HealthChanged:Connect(updateAliveCounts));
                        updateAliveCounts();
                    end;
                end));
            end;
        end;

        updateAliveCounts();
    end;

    v72:Add(p70:GetAttributeChangedSignal("Team"):Connect(updateAliveCounts));
    v72:Add(p70:GetAttributeChangedSignal("IsSpectating"):Connect(updateAliveCounts));
    v72:Add(p70.CharacterAdded:Connect(bindCharacter));
    v72:Add(p70.CharacterRemoving:Connect(function() -- Line: 308
        -- upvalues: u73 (ref), updateAliveCounts (ref)
        if u73 then
            u73:Destroy();
            u73 = nil;
        end;

        updateAliveCounts();
    end));
    v72:Add(function() -- Line: 311
        -- upvalues: u73 (ref)
        if u73 then
            u73:Destroy();
            u73 = nil;
        end;
    end);
    bindCharacter(p70.Character);
end;

local function updateGamemode() -- Line: 323
    -- upvalues: u29 (ref), u18 (copy), u19 (copy), u21 (copy), u22 (copy), u23 (copy), u24 (copy), u25 (copy), u26 (copy), u20 (copy), u27 (copy), u8 (copy), u9 (copy), u11 (copy), u12 (copy), u14 (copy), u15 (copy), u13 (copy), u16 (copy), u10 (copy), u17 (copy)
    local v79 = workspace:GetAttribute("Gamemode");
    u29.Team.CT.Score.Visible = v79 ~= "Deathmatch";
    u29.Team.T.Score.Visible = v79 ~= "Deathmatch";
    local v80 = workspace:GetAttribute("Map");
    local TopInfo = u29.TopInfo;
    local v81 = `{v79} | {v80}`;
    TopInfo.Gamemode.Text = v81;
    u29.Top.TopInfo.Gamemode.Text = v81;

    if v79 ~= "Deathmatch" then
        if v79 == "Bomb Defusal" or v79 == "Hostage Rescue" then
            u29["Counter-Terrorists"].Position = u8;
            u29.Terrorists.Position = u9;
            TopInfo.Assists.Position = u11;
            TopInfo.Deaths.Position = u12;
            TopInfo.Score.Position = u14;
            TopInfo.Kills.Position = u15;
            TopInfo.Money.Position = u13;
            TopInfo.MVPs.Position = u16;
            TopInfo.Ping.Position = u10;
            u29["Counter-Terrorists"].Size = u17;
            u29.Terrorists.Size = u17;
            u29.DeathmatchDivider.Visible = false;
            u29.Team.Visible = true;
        end;

        return;
    end;

    u29["Counter-Terrorists"].Position = u18;
    u29.Terrorists.Position = u19;
    TopInfo.Assists.Position = u21;
    TopInfo.Deaths.Position = u22;
    TopInfo.Money.Position = u23;
    TopInfo.Score.Position = u24;
    TopInfo.Kills.Position = u25;
    TopInfo.MVPs.Position = u26;
    TopInfo.Ping.Position = u20;
    u29["Counter-Terrorists"].Size = u27;
    u29.Terrorists.Size = u27;
    u29.DeathmatchDivider.Visible = true;
    u29.Team.Visible = false;
end;

local function isCompetitiveRoundsMode() -- Line: 367
    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return false;
    end;

    local v82 = workspace:GetAttribute("Gamemode");

    return v82 == "Bomb Defusal" and true or v82 == "Hostage Rescue";
end;

local function getRoundFrame(p83) -- Line: 377
    -- upvalues: u29 (ref)
    if not u29 then
        return nil;
    end;

    if p83 <= 12 then
        local Results1 = u29:FindFirstChild("Results1");

        return Results1 and Results1:FindFirstChild((tostring(p83))) or nil;
    end;

    local Results2 = u29:FindFirstChild("Results2");

    return Results2 and Results2:FindFirstChild((tostring(p83))) or nil;
end;

local function isPostHalftime() -- Line: 392
    local v84 = workspace:GetAttribute("HalftimeRound");
    local v85 = workspace:GetAttribute("CurrentRound");

    if v84 and v85 then
        return v84 < v85;
    end;

    return false;
end;

local function teamColor(p86) -- Line: 403
    -- upvalues: u2 (copy), u3 (copy)
    if p86 == "Counter-Terrorists" then
        return u2;
    end;

    return u3;
end;

local function getTeamSlotName(p87, p88) -- Line: 418
    local v89 = p88 == "Terrorists";
    local v90;

    if p87 <= 12 then
        local v91 = workspace:GetAttribute("HalftimeRound");
        local v92 = workspace:GetAttribute("CurrentRound");

        if v91 and v92 then
            v90 = v91 < v92;
        else
            v90 = false;
        end;
    else
        v90 = false;
    end;

    if v90 then
        v89 = not v89;
    end;

    return v89 and "Team1" or "Team2";
end;

local function decodeRoundResults() -- Line: 427
    -- upvalues: HttpService (copy)
    local v93 = workspace:GetAttribute("RoundResults");

    if typeof(v93) ~= "string" or v93 == "" then
        return {};
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, v93);

    return (not success or typeof(result) ~= "table") and {} or result;
end;

local function applyLossBonusVisibility() -- Line: 441
    -- upvalues: u29 (ref)
    if not u29 then
        return;
    end;

    local v94;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local v95 = workspace:GetAttribute("Gamemode");
        v94 = v95 == "Bomb Defusal" and true or v95 == "Hostage Rescue";
    else
        v94 = false;
    end;

    local LossBonus = u29:FindFirstChild("LossBonus");
    local Results1 = u29:FindFirstChild("Results1");
    local Results2 = u29:FindFirstChild("Results2");
    local Spilter = u29:FindFirstChild("Spilter");

    if LossBonus then
        LossBonus.Visible = v94;
    end;

    if Results1 then
        Results1.Visible = v94;
    end;

    if Results2 then
        Results2.Visible = v94;
    end;

    if Spilter then
        Spilter.Visible = v94;
    end;
end;

local function paintLossBar(p96, p97, p98) -- Line: 458
    -- upvalues: u4 (copy)
    if not p96 then
        return;
    end;

    local v99 = math.clamp(p97, 0, 4);

    for i = 1, 4 do
        local v100 = p96:FindFirstChild((tostring(i)));

        if v100 then
            v100.BackgroundColor3 = i <= v99 and p98 and p98 or u4;
        end;
    end;
end;

local function applyLossBars() -- Line: 469
    -- upvalues: u29 (ref), paintLossBar (copy), u3 (copy), u2 (copy)
    if not u29 then
        return;
    end;

    local LossBonus = u29:FindFirstChild("LossBonus");

    if not LossBonus then
        return;
    end;

    local Bar1 = LossBonus:FindFirstChild("Bar1");
    local Bar2 = LossBonus:FindFirstChild("Bar2");
    local v101 = workspace:GetAttribute("TLossStreak") or 0;
    local v102 = workspace:GetAttribute("CTLossStreak") or 0;
    paintLossBar(Bar1, v101, u3);
    paintLossBar(Bar2, v102, u2);
end;

local function resetRoundFrame(p103) -- Line: 485
    -- upvalues: u5 (copy)
    p103.BackgroundColor3 = u5;
    local Team1 = p103:FindFirstChild("Team1");
    local Team2 = p103:FindFirstChild("Team2");

    if Team1 then
        Team1.Visible = false;
        Team1.BackgroundTransparency = 0;
        local Icon = Team1:FindFirstChild("Icon");

        if Icon then
            Icon.Image = "";
            Icon.ImageTransparency = 0;
        end;
    end;

    if Team2 then
        Team2.Visible = false;
        Team2.BackgroundTransparency = 0;
        local Icon = Team2:FindFirstChild("Icon");

        if Icon then
            Icon.Image = "";
            Icon.ImageTransparency = 0;
        end;
    end;
end;

local function paintRoundResult(p104, p105, p106, p107) -- Line: 511
    -- upvalues: u2 (copy), u3 (copy), u7 (copy)
    local v108;

    if p105 == "Counter-Terrorists" then
        v108 = u2;
    else
        v108 = u3;
    end;

    p104.BackgroundColor3 = v108;
    local v109 = p105 == "Terrorists";
    local v110;

    if p107 <= 12 then
        local v111 = workspace:GetAttribute("HalftimeRound");
        local v112 = workspace:GetAttribute("CurrentRound");

        if v111 and v112 then
            v110 = v111 < v112;
        else
            v110 = false;
        end;
    else
        v110 = false;
    end;

    if v110 then
        v109 = not v109;
    end;

    local v113 = v109 and "Team1" or "Team2";
    local v114 = p104:FindFirstChild(v113);
    local v115 = p104:FindFirstChild(v113 == "Team1" and "Team2" or "Team1");

    if v114 then
        v114.Visible = true;
        v114.BackgroundTransparency = 0;
        local v116;

        if p105 == "Counter-Terrorists" then
            v116 = u2;
        else
            v116 = u3;
        end;

        v114.BackgroundColor3 = v116;
        local Icon = v114:FindFirstChild("Icon");

        if Icon then
            Icon.Image = u7[p106] or "rbxassetid://70876442749327";
            local v117;

            if p105 == "Counter-Terrorists" then
                v117 = u2;
            else
                v117 = u3;
            end;

            Icon.ImageColor3 = v117;
            Icon.ImageTransparency = 0;
        end;
    end;

    if v115 then
        v115.Visible = false;
    end;
end;

local function applyTrophy(p118) -- Line: 540
    -- upvalues: u29 (ref), getRoundFrame (copy), decodeRoundResults (copy)
    if not u29 then
        return;
    end;

    local v119 = workspace:GetAttribute("RoundsToWin");

    if not v119 then
        return;
    end;

    if p118 ~= "Counter-Terrorists" and p118 ~= "Terrorists" then
        return;
    end;

    local v120 = workspace:GetAttribute("CTScore") or 0;
    local v121 = workspace:GetAttribute("TScore") or 0;
    local v122 = v120 + v121 + (v119 - (p118 == "Counter-Terrorists" and v120 and v120 or v121));

    if v122 < 1 or v122 > 24 then
        return;
    end;

    local v123 = getRoundFrame(v122);

    if not v123 then
        return;
    end;

    for _, v in ipairs((decodeRoundResults())) do
        if v.round == v122 then
            return;
        end;
    end;

    local v124 = p118 == "Terrorists";
    local v125;

    if v122 <= 12 then
        local v126 = workspace:GetAttribute("HalftimeRound");
        local v127 = workspace:GetAttribute("CurrentRound");

        if v126 and v127 then
            v125 = v126 < v127;
        else
            v125 = false;
        end;
    else
        v125 = false;
    end;

    if v125 then
        v124 = not v124;
    end;

    local v128 = v123:FindFirstChild(v124 and "Team1" or "Team2");

    if not v128 then
        return;
    end;

    v128.Visible = true;
    v128.BackgroundTransparency = 1;
    local Icon = v128:FindFirstChild("Icon");

    if Icon then
        Icon.Image = "rbxassetid://4857633530";
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255);
        Icon.ImageTransparency = 0;
    end;
end;

local function refreshResults() -- Line: 587
    -- upvalues: u29 (ref), getRoundFrame (copy), resetRoundFrame (copy), decodeRoundResults (copy), paintRoundResult (copy), u6 (copy), applyTrophy (copy), LocalPlayer (copy)
    if not u29 then
        return;
    end;

    local v129;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        local v130 = workspace:GetAttribute("Gamemode");
        v129 = v130 == "Bomb Defusal" and true or v130 == "Hostage Rescue";
    else
        v129 = false;
    end;

    if not v129 then
        return;
    end;

    for i = 1, 24 do
        local v131 = getRoundFrame(i);

        if v131 then
            resetRoundFrame(v131);
        end;
    end;

    for _, v in ipairs((decodeRoundResults())) do
        local v132 = getRoundFrame(v.round);

        if v132 then
            paintRoundResult(v132, v.winner, v.winType, v.round);
        end;
    end;

    local v133 = workspace:GetAttribute("CurrentRound");

    if v133 and (v133 >= 1 and v133 <= 24) then
        local v134 = false;

        for _, v in ipairs((decodeRoundResults())) do
            if v.round == v133 then
                v134 = true;
                break;
            end;
        end;

        local v135 = not v134 and getRoundFrame(v133);

        if v135 then
            v135.BackgroundColor3 = u6;
        end;
    end;

    applyTrophy((LocalPlayer:GetAttribute("Team")));
end;

function u1.createTemplate(u136, u137, u138) -- Line: 637
    -- upvalues: ReplicatedStorage (copy), GetBadgeIcon (copy), LocalPlayer (copy), bindPlayerRowInteractions (copy), Observers (copy), DataController (copy), HttpService (copy)
    local u139 = ReplicatedStorage.Assets.UI.Leaderboard[u137]:Clone();
    u139.Player.Image = `rbxthumb://type=AvatarHeadShot&id={u136.UserId}&w=150&h=150`;
    u139.PlayerName.Text = `{u136.DisplayName} (@{u136.Name})`;
    local v140 = GetBadgeIcon(u136, u137);
    u139.Badge.Visible = v140 ~= "";
    u139.Badge.Image = v140;
    u139.LayoutOrder = 0;
    u139.Assists.Amount.Text = "0";
    u139.Deaths.Amount.Text = "0";
    u139.Score.Amount.Text = "0";
    u139.Kills.Amount.Text = "0";
    u139.MVPs.Amount.Text = "0";
    u139.Money.Amount.Text = "";
    u139.LayoutOrder = 1;
    u139.Ping.Text = "0";
    local u141 = {};

    local function storeTransparencyRecursive(p142) -- Line: 667
        -- upvalues: u141 (copy), storeTransparencyRecursive (copy)
        if p142:IsA("Frame") then
            u141[p142] = {
                BackgroundTransparency = p142.BackgroundTransparency
            };
        elseif p142:IsA("TextLabel") then
            u141[p142] = {
                BackgroundTransparency = p142.BackgroundTransparency,
                TextTransparency = p142.TextTransparency
            };
        elseif p142:IsA("TextButton") then
            u141[p142] = {
                BackgroundTransparency = p142.BackgroundTransparency,
                TextTransparency = p142.TextTransparency
            };
        elseif p142:IsA("ImageLabel") then
            u141[p142] = {
                BackgroundTransparency = p142.BackgroundTransparency,
                ImageTransparency = p142.ImageTransparency
            };
        elseif p142:IsA("ImageButton") then
            u141[p142] = {
                BackgroundTransparency = p142.BackgroundTransparency,
                ImageTransparency = p142.ImageTransparency
            };
        end;

        for _, child in p142:GetChildren() do
            storeTransparencyRecursive(child);
        end;
    end;

    u141[u139] = {
        BackgroundTransparency = u139.BackgroundTransparency
    };

    for _, child in u139:GetChildren() do
        storeTransparencyRecursive(child);
    end;

    if u136 == LocalPlayer then
        u139.BackgroundColor3 = Color3.fromRGB(139, 128, 98);
    end;

    bindPlayerRowInteractions(u139, u136, u138);

    local function isTeammate() -- Line: 718
        -- upvalues: u136 (copy), LocalPlayer (ref)
        return u136:GetAttribute("Team") == LocalPlayer:GetAttribute("Team");
    end;

    local function updateMoneyVisibility() -- Line: 725
        -- upvalues: u136 (copy), LocalPlayer (ref), u139 (copy)
        local v143 = workspace:GetAttribute("Gamemode");

        if u136:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") and v143 ~= "Deathmatch" then
            u139.Money.Amount.Text = "";

            return;
        end;

        local v144 = u136:GetAttribute("Money");
        u139.Money.Amount.Text = v144 == nil and "" or (`${tostring(v144):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}` or "");
    end;

    u138:Add(Observers.observeAttribute(u136, "Money", function(p145) -- Line: 735
        -- upvalues: updateMoneyVisibility (copy)
        updateMoneyVisibility();
    end));
    updateMoneyVisibility();
    local u146 = u139.Player:FindFirstChildOfClass("UIStroke");

    local function updateTeamColors() -- Line: 741
        -- upvalues: u146 (copy), u136 (copy), LocalPlayer (ref)
        if not u146 then
            return;
        end;

        if u136:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
            u146.Enabled = false;

            return;
        end;

        local v147 = u136:GetAttribute("CompetitivePlayerColor");

        if not v147 then
            u146.Enabled = false;

            return;
        end;

        u146.Color = v147 or Color3.fromRGB(255, 255, 255);
        u146.Enabled = true;
    end;

    if u146 then
        if u136:GetAttribute("Team") == LocalPlayer:GetAttribute("Team") then
            local v148 = u136:GetAttribute("CompetitivePlayerColor");

            if v148 then
                u146.Color = v148 or Color3.fromRGB(255, 255, 255);
                u146.Enabled = true;
            else
                u146.Enabled = false;
            end;
        else
            u146.Enabled = false;
        end;
    end;

    u138:Add(Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 763
        -- upvalues: updateMoneyVisibility (copy), u146 (copy), u136 (copy), LocalPlayer (ref)
        updateMoneyVisibility();

        if not u146 then
            return;
        end;

        if u136:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
            u146.Enabled = false;

            return;
        end;

        local v149 = u136:GetAttribute("CompetitivePlayerColor");

        if not v149 then
            u146.Enabled = false;

            return;
        end;

        u146.Color = v149 or Color3.fromRGB(255, 255, 255);
        u146.Enabled = true;
    end));
    u138:Add(Observers.observeAttribute(u136, "Team", function() -- Line: 768
        -- upvalues: updateMoneyVisibility (copy), u146 (copy), u136 (copy), LocalPlayer (ref)
        updateMoneyVisibility();

        if not u146 then
            return;
        end;

        if u136:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
            u146.Enabled = false;

            return;
        end;

        local v150 = u136:GetAttribute("CompetitivePlayerColor");

        if not v150 then
            u146.Enabled = false;

            return;
        end;

        u146.Color = v150 or Color3.fromRGB(255, 255, 255);
        u146.Enabled = true;
    end));
    u138:Add(Observers.observeAttribute(u136, "CompetitivePlayerColor", updateTeamColors));
    u138:Add(Observers.observeAttribute(u136, "Kills", function(p151) -- Line: 776
        -- upvalues: u139 (copy)
        u139.Kills.Amount.Text = tostring(p151):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        u139.LayoutOrder = -p151;
    end));
    u138:Add(Observers.observeAttribute(u136, "Deaths", function(p152) -- Line: 782
        -- upvalues: u139 (copy)
        u139.Deaths.Amount.Text = tostring(p152):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end));
    u138:Add(Observers.observeAttribute(u136, "Assists", function(p153) -- Line: 787
        -- upvalues: u139 (copy)
        u139.Assists.Amount.Text = tostring(p153):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end));
    u138:Add(Observers.observeAttribute(u136, "Score", function(p154) -- Line: 792
        -- upvalues: u139 (copy)
        u139.Score.Amount.Text = tostring(p154):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end));
    u138:Add(Observers.observeAttribute(u136, "MVPs", function(p155) -- Line: 797
        -- upvalues: u139 (copy)
        u139.MVPs.Amount.Text = tostring(p155):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end));
    u138:Add(Observers.observeAttribute(u136, "Ping", function(p156) -- Line: 802
        -- upvalues: u139 (copy)
        u139.Ping.Text = p156;
    end));

    local function updateDeadSymbol() -- Line: 807
        -- upvalues: u136 (copy), u139 (copy), u141 (copy)
        local Character = u136.Character;

        if Character then
            Character = Character:GetAttribute("Dead") == true;
        end;

        local v157 = u136:GetAttribute("IsSpectating") == true;
        local v158 = Character == true and true or v157 == true;

        if u139 and u139:FindFirstChild("Dead") then
            u139.Dead.Visible = v158;
        end;

        if v158 then
            if u139:FindFirstChild("Bomb") then
                u139.Bomb.Visible = false;
            end;

            if u139:FindFirstChild("DefuseKit") then
                u139.DefuseKit.Visible = false;
            end;
        end;

        if v158 then
            u139.BackgroundTransparency = 1;

            local function setTransparencyRecursive(p159) -- Line: 835
                -- upvalues: setTransparencyRecursive (copy)
                if p159:IsA("Frame") then
                    p159.BackgroundTransparency = 1;
                elseif p159:IsA("TextLabel") then
                    p159.TextTransparency = 0.5;
                    p159.BackgroundTransparency = 1;
                elseif p159:IsA("TextButton") then
                    p159.TextTransparency = 0.5;
                    p159.BackgroundTransparency = 1;
                elseif p159:IsA("ImageLabel") then
                    p159.ImageTransparency = 0.5;
                    p159.BackgroundTransparency = 1;
                elseif p159:IsA("ImageButton") then
                    p159.ImageTransparency = 0.5;
                    p159.BackgroundTransparency = 1;
                end;

                for _, child in ipairs(p159:GetChildren()) do
                    setTransparencyRecursive(child);
                end;
            end;

            for _, child in ipairs(u139:GetChildren()) do
                setTransparencyRecursive(child);
            end;

            return;
        end;

        local function restoreTransparencyRecursive(p160) -- Line: 864
            -- upvalues: u141 (ref), restoreTransparencyRecursive (copy)
            local v161 = u141[p160];

            if v161 then
                if p160:IsA("Frame") then
                    p160.BackgroundTransparency = v161.BackgroundTransparency;
                elseif p160:IsA("TextLabel") then
                    p160.TextTransparency = v161.TextTransparency;
                    p160.BackgroundTransparency = v161.BackgroundTransparency;
                elseif p160:IsA("TextButton") then
                    p160.TextTransparency = v161.TextTransparency;
                    p160.BackgroundTransparency = v161.BackgroundTransparency;
                elseif p160:IsA("ImageLabel") then
                    p160.ImageTransparency = v161.ImageTransparency;
                    p160.BackgroundTransparency = v161.BackgroundTransparency;
                elseif p160:IsA("ImageButton") then
                    p160.ImageTransparency = v161.ImageTransparency;
                    p160.BackgroundTransparency = v161.BackgroundTransparency;
                end;
            end;

            for _, child in ipairs(p160:GetChildren()) do
                restoreTransparencyRecursive(child);
            end;
        end;

        local v162 = u141[u139];

        if v162 then
            u139.BackgroundTransparency = v162.BackgroundTransparency;
        end;

        for _, child in ipairs(u139:GetChildren()) do
            restoreTransparencyRecursive(child);
        end;
    end;

    local u163 = nil;

    local function setupCharacterObserver() -- Line: 911
        -- upvalues: u136 (copy), updateDeadSymbol (copy), u163 (ref)
        local Character = u136.Character;

        if Character then
            updateDeadSymbol();

            return Character:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 922
                -- upvalues: updateDeadSymbol (ref), u163 (ref)
                updateDeadSymbol();

                if u163 then
                    u163();
                end;
            end);
        end;

        updateDeadSymbol();

        return nil;
    end;

    u138:Add(Observers.observeAttribute(u136, "IsSpectating", function(p164) -- Line: 933
        -- upvalues: updateDeadSymbol (copy)
        updateDeadSymbol();
    end));
    local v168 = u136.CharacterAdded:Connect(function(p165) -- Line: 938
        -- upvalues: u146 (copy), u136 (copy), LocalPlayer (ref), u138 (copy), updateTeamColors (copy), setupCharacterObserver (copy), u163 (ref)
        task.wait(0.1);

        if u146 then
            if u136:GetAttribute("Team") == LocalPlayer:GetAttribute("Team") then
                local v166 = u136:GetAttribute("CompetitivePlayerColor");

                if v166 then
                    u146.Color = v166 or Color3.fromRGB(255, 255, 255);
                    u146.Enabled = true;
                else
                    u146.Enabled = false;
                end;
            else
                u146.Enabled = false;
            end;
        end;

        u138:Add(p165:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(updateTeamColors));
        local v167 = setupCharacterObserver();

        if v167 then
            u138:Add(v167);
        end;

        if u163 then
            u163();
        end;
    end);
    local v170 = u136.CharacterRemoving:Connect(function(p169) -- Line: 956
        -- upvalues: updateDeadSymbol (copy)
        updateDeadSymbol();
    end);
    u138:Add(v168);
    u138:Add(v170);

    if u136.Character then
        local v171 = setupCharacterObserver();

        if v171 then
            u138:Add(v171);
        end;
    else
        updateDeadSymbol();
    end;

    local u173 = DataController.CreateListener(u136, `Loadout.{u137}.Equipped.Equipped Badge`, function() -- Line: 976
        -- upvalues: GetBadgeIcon (ref), u136 (copy), u137 (copy), u139 (copy)
        local v172 = GetBadgeIcon(u136, u137);
        u139.Badge.Image = v172;
        u139.Badge.Visible = v172 ~= "";
    end);
    u138:Add(function() -- Line: 983
        -- upvalues: DataController (ref), u136 (copy), u137 (copy), u173 (copy)
        DataController.RemoveListener(u136, `Loadout.{u137}.Equipped.Equipped Badge`, u173);
    end);

    u163 = function() -- Line: 989
        -- upvalues: u136 (copy), LocalPlayer (ref), u137 (copy), u139 (copy), HttpService (ref)
        local v174 = u136:GetAttribute("Team") == LocalPlayer:GetAttribute("Team");
        local Character = u136.Character;

        if Character then
            Character = Character:GetAttribute("Dead") == true;
        end;

        local v175 = u136:GetAttribute("IsSpectating") == true;
        local v176 = not Character and not v175;

        if u137 == "Terrorists" then
            local Bomb = u139:FindFirstChild("Bomb");

            if Bomb then
                local v177 = u136:GetAttribute("Slot5");

                if not v177 then
                    Bomb.Visible = false;

                    return;
                end;

                local v178 = HttpService:JSONDecode(v177 or "[]");

                if v174 then
                    if v176 then
                        if v178 then
                            v178 = v178.Weapon == "C4";
                        end;
                    else
                        v178 = v176;
                    end;
                else
                    v178 = v174;
                end;

                Bomb.Visible = v178;
            end;
        else
            local v179 = u137 == "Counter-Terrorists" and u139:FindFirstChild("DefuseKit");

            if v179 then
                local v180 = u136:GetAttribute("HasDefuseKit");

                if v174 then
                    if v176 then
                        v176 = v180 == true;
                    end;
                else
                    v176 = v174;
                end;

                v179.Visible = v176;
            end;
        end;
    end;

    if u137 == "Terrorists" then
        u138:Add(Observers.observeAttribute(u136, "Slot5", function(p181) -- Line: 1024
            -- upvalues: u163 (ref), u139 (copy)
            u163();

            return function() -- Line: 1027
                -- upvalues: u139 (ref)
                if u139 and u139:FindFirstChild("Bomb") then
                    u139.Bomb.Visible = false;
                end;
            end;
        end));
    elseif u137 == "Counter-Terrorists" then
        u138:Add(Observers.observeAttribute(u136, "HasDefuseKit", function(p182) -- Line: 1035
            -- upvalues: u163 (ref), u139 (copy)
            u163();

            return function() -- Line: 1037
                -- upvalues: u139 (ref)
                if u139 and u139:FindFirstChild("DefuseKit") then
                    u139.DefuseKit.Visible = false;
                end;
            end;
        end));
    end;

    u138:Add(Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 1046
        -- upvalues: u163 (ref)
        u163();
    end));
    u163();

    return u139;
end;

function u1.openFrame() -- Line: 1059
    -- upvalues: EndScreenController (copy), GameState (copy), u29 (ref), u1 (copy), u34 (ref)
    if EndScreenController.IsActive() or GameState.GetState() == "Map Voting" then
        if u29 and u29.Visible then
            u1.closeFrame();
        end;

        return;
    end;

    u34 = false;
    u29.Visible = true;
end;

function u1.closeFrame() -- Line: 1071
    -- upvalues: u29 (ref), u34 (ref), u30 (ref), u32 (ref), u31 (ref), ProfileInspect (copy), CameraController (copy)
    u29.Visible = false;
    u34 = false;

    if u30 then
        u30.Visible = false;

        if u31 then
            u30.Position = u31;
        end;

        ProfileInspect.Reset();
        u32 = nil;
    else
        u32 = nil;
    end;

    CameraController.setForceLockOverride("Leaderboard", false);
end;

function u1.CloseProfileInspect() -- Line: 1078
    -- upvalues: u30 (ref), u32 (ref), u31 (ref), ProfileInspect (copy)
    if not u30 then
        u32 = nil;

        return;
    end;

    u30.Visible = false;

    if u31 then
        u30.Position = u31;
    end;

    ProfileInspect.Reset();
    u32 = nil;
end;

function u1.GetInspectedPlayer() -- Line: 1082
    -- upvalues: u32 (ref)
    return u32;
end;

function u1.IsRightClickUnlockActive() -- Line: 1086
    -- upvalues: u34 (ref)
    return u34;
end;

function u1.characterAdded(p183, p184) -- Line: 1092
    -- upvalues: Janitor (copy), u1 (copy), u29 (ref), u35 (copy)
    local v185 = Janitor.new();
    u1.cleanup(p183);
    local u186 = u1.createTemplate(p183, p184, v185);
    u186.Parent = u29:FindFirstChild(p184);
    v185:Add(function() -- Line: 1099
        -- upvalues: u186 (copy)
        u186:Destroy();
    end);
    u35[p183] = v185;
end;

function u1.observePlayer(u187) -- Line: 1108
    -- upvalues: Observers (copy), u1 (copy)
    Observers.observeAttribute(u187, "Team", function(p188) -- Line: 1109
        -- upvalues: u1 (ref), u187 (copy)
        if p188 == "Terrorists" or p188 == "Counter-Terrorists" then
            u1.characterAdded(u187, p188);
        end;

        return function() -- Line: 1115
            -- upvalues: u1 (ref), u187 (ref)
            u1.cleanup(u187);
        end;
    end);
end;

function u1.cleanup(p189) -- Line: 1123
    -- upvalues: u35 (copy)
    local v190 = u35[p189];
    u35[p189] = nil;

    if v190 then
        v190:Destroy();
    end;
end;

function u1.Initialize(p191, p192) -- Line: 1135
    -- upvalues: u29 (ref), u30 (ref), u31 (ref), ProfileInspect (copy), u33 (ref), UserInputService (copy), u34 (ref), CameraController (copy), Observers (copy), updateGamemode (copy), updateAliveCounts (copy), applyLossBonusVisibility (copy), applyLossBars (copy), refreshResults (copy), u1 (copy), LocalPlayer (copy), GetTimerFormat (copy), observeAliveCountPlayer (copy), u36 (copy)
    u29 = p192;
    u30 = p192:FindFirstChild("ProfileInspect");

    if u30 then
        u31 = u30.Position;
        u30.Visible = false;
        ProfileInspect.Bind(u30);
    end;

    if u33 then
        u33:Disconnect();
        u33 = nil;
    end;

    u33 = UserInputService.InputBegan:Connect(function(p193) -- Line: 1150
        -- upvalues: u29 (ref), u34 (ref), CameraController (ref)
        if p193.UserInputType == Enum.UserInputType.MouseButton2 and (u29 and u29.Visible) then
            u34 = true;
            CameraController.setForceLockOverride("Leaderboard", true);
        end;
    end);
    Observers.observeAttribute(workspace, "Gamemode", function() -- Line: 1158
        -- upvalues: updateGamemode (ref), updateAliveCounts (ref), applyLossBonusVisibility (ref), applyLossBars (ref), refreshResults (ref)
        updateGamemode();
        updateAliveCounts();
        applyLossBonusVisibility();
        applyLossBars();
        refreshResults();
    end);
    Observers.observeAttribute(workspace, "Map", updateGamemode);
    Observers.observeAttribute(workspace, "ServerGamemode", function() -- Line: 1166
        -- upvalues: applyLossBonusVisibility (ref), applyLossBars (ref), refreshResults (ref)
        applyLossBonusVisibility();
        applyLossBars();
        refreshResults();
    end);
    Observers.observeAttribute(workspace, "GameState", function(p194) -- Line: 1171
        -- upvalues: u1 (ref), updateAliveCounts (ref)
        if p194 == "Map Voting" then
            u1.closeFrame();
        end;

        updateAliveCounts();
    end);
    Observers.observeAttribute(workspace, "CTScore", function(p195) -- Line: 1179
        -- upvalues: u29 (ref), refreshResults (ref)
        u29.Team.CT.Score.Text = tostring(p195);
        refreshResults();

        return function() -- Line: 1182
            -- upvalues: u29 (ref)
            u29.Team.CT.Score.Text = "";
        end;
    end);
    Observers.observeAttribute(workspace, "TScore", function(p196) -- Line: 1188
        -- upvalues: u29 (ref), refreshResults (ref)
        u29.Team.T.Score.Text = tostring(p196);
        refreshResults();

        return function() -- Line: 1191
            -- upvalues: u29 (ref)
            u29.Team.T.Score.Text = "";
        end;
    end);
    Observers.observeAttribute(workspace, "RoundResults", refreshResults);
    Observers.observeAttribute(workspace, "CurrentRound", refreshResults);
    Observers.observeAttribute(workspace, "RoundsToWin", refreshResults);
    Observers.observeAttribute(workspace, "HalftimeRound", refreshResults);
    Observers.observeAttribute(workspace, "CTLossStreak", applyLossBars);
    Observers.observeAttribute(workspace, "TLossStreak", applyLossBars);
    Observers.observeAttribute(LocalPlayer, "Team", refreshResults);
    applyLossBonusVisibility();
    applyLossBars();
    refreshResults();
    Observers.observeAttribute(workspace, "Timer", function(p197) -- Line: 1215
        -- upvalues: GetTimerFormat (ref), u29 (ref)
        local v198 = GetTimerFormat(p197);
        u29.TopInfo.Timer.Text = v198;
        u29.Top.TopInfo.Timer.Text = v198;
    end);
    Observers.observePlayer(function(u199) -- Line: 1222
        -- upvalues: u1 (ref), observeAliveCountPlayer (ref), u36 (ref), updateAliveCounts (ref)
        u1.observePlayer(u199);
        observeAliveCountPlayer(u199);

        return function() -- Line: 1226
            -- upvalues: u36 (ref), u199 (copy), u1 (ref), updateAliveCounts (ref)
            local v200 = u36[u199];
            u36[u199] = nil;

            if v200 then
                v200:Destroy();
            end;

            u1.cleanup(u199);
            updateAliveCounts();
        end;
    end);
end;

function u1.Start() -- Line: 1238
    -- upvalues: clearFrame (copy), u29 (ref), updateAliveCounts (copy)
    clearFrame((u29:WaitForChild("Counter-Terrorists")));
    clearFrame((u29:WaitForChild("Terrorists")));
    updateAliveCounts();
end;

return u1;