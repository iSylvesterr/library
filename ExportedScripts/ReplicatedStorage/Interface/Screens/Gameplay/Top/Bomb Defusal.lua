-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local PlayerInfo = require(ReplicatedStorage.Interface.Screens.Gameplay.Top.PlayerInfo);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = Color3.fromRGB(85, 255, 85);
local u3 = Color3.fromRGB(250, 31, 31);
local u4 = Color3.fromRGB(85, 255, 85);
local u5 = Color3.fromRGB(230, 36, 36);
local u6 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true);
local u7 = { "Counter-Terrorists", "Terrorists" };
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {
    ["Counter-Terrorists"] = {},
    Terrorists = {}
};
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;

local function clearFrame(p19) -- Line: 68
    for _, child in p19:GetChildren() do
        if child.ClassName == "Frame" and child.Name ~= "MorePlayers" then
            child:Destroy();
        end;
    end;
end;

local function IsPlayableTeam(p20) -- Line: 78
    return p20 == "Counter-Terrorists" and true or p20 == "Terrorists";
end;

local function GetPlayerAlive(p21) -- Line: 84
    if p21:GetAttribute("IsSpectating") == true then
        return false;
    end;

    local Character = p21.Character;

    if not (Character and Character:IsDescendantOf(workspace)) then
        return false;
    end;

    if Character:GetAttribute("Dead") == true then
        return false;
    end;

    local v22 = Character:FindFirstChildOfClass("Humanoid");
    local v23;

    if v22 == nil then
        v23 = false;
    else
        v23 = v22.Health > 0;
    end;

    return v23;
end;

local function RefreshTeamHud(p24) -- Line: 102
    -- upvalues: u12 (copy), u13 (copy), u10 (copy), PlayerInfo (copy)
    local v25 = u12[p24];
    local v26 = u13[p24];
    local v27 = 0;

    for _, v in ipairs(v26) do
        if u10[v] == true then
            v27 = v27 + 1;
        end;
    end;

    v25.playerCountLabel.Text = tostring(v27);
    local v28 = #v26;
    local v29 = v28 > 10;
    local v30 = not v29 and 0 or v28 - 9;
    v25.morePlayersFrame.Visible = v30 > 0;
    v25.morePlayersAmountLabel.Text = `+{v30}`;
    local v31 = v29 and 9 or v28;

    for i, v in ipairs(v26) do
        local v32 = PlayerInfo.getTemplateByUserId(v.UserId);

        if v32 and v32.Parent == v25.holder then
            v32.Visible = i <= v31;
        end;
    end;
end;

local function RefreshAllTeamHuds() -- Line: 130
    -- upvalues: u7 (copy), RefreshTeamHud (copy)
    for _, v in ipairs(u7) do
        RefreshTeamHud(v);
    end;
end;

local function RemovePlayerFromRoster(p33) -- Line: 136
    -- upvalues: u11 (copy), u13 (copy)
    local v34 = u11[p33];

    if v34 ~= "Counter-Terrorists" and v34 ~= "Terrorists" then
        u11[p33] = nil;

        return nil;
    end;

    u11[p33] = nil;
    local v35 = u13[v34];

    for i, v in ipairs(v35) do
        if v == p33 then
            table.remove(v35, i);

            return v34;
        end;
    end;

    return v34;
end;

local function SetPlayerRosterTeam(p36, p37) -- Line: 155
    -- upvalues: u11 (copy), RemovePlayerFromRoster (copy), u13 (copy)
    if u11[p36] == p37 then
        return nil;
    end;

    local v38 = RemovePlayerFromRoster(p36);
    u11[p36] = p37;
    table.insert(u13[p37], p36);

    return v38;
end;

local function SetPlayerAliveState(p39, p40) -- Line: 166
    -- upvalues: u10 (copy), u11 (copy), RefreshTeamHud (copy)
    if u10[p39] == p40 then
        return;
    end;

    u10[p39] = p40;
    local v41 = u11[p39];

    if v41 == "Counter-Terrorists" and true or v41 == "Terrorists" then
        RefreshTeamHud(v41);
    end;
end;

local function RefreshPlayerAliveState(p42) -- Line: 178
    -- upvalues: GetPlayerAlive (copy), u10 (copy), u11 (copy), RefreshTeamHud (copy)
    local v43 = GetPlayerAlive(p42);

    if u10[p42] == v43 then
        return;
    end;

    u10[p42] = v43;
    local v44 = u11[p42];

    if v44 == "Counter-Terrorists" and true or v44 == "Terrorists" then
        RefreshTeamHud(v44);
    end;
end;

local function ResetRosterState() -- Line: 182
    -- upvalues: u7 (copy), u13 (copy), u11 (copy), u10 (copy), RefreshTeamHud (copy)
    for _, v in ipairs(u7) do
        table.clear(u13[v]);
    end;

    table.clear(u11);
    table.clear(u10);

    for _, v in ipairs(u7) do
        RefreshTeamHud(v);
    end;
end;

local function UpdateFrameVisibility() -- Line: 192
    -- upvalues: u15 (ref), u14 (ref)
    local v45 = workspace:GetAttribute("Gamemode");
    u14.Visible = (v45 == "Hostage Rescue" and true or v45 == "Bomb Defusal") and not u15.Gameplay.Middle.TeamSelection.Visible;
end;

local function StopBombGlow() -- Line: 200
    -- upvalues: u18 (ref), u14 (ref)
    if u18 then
        u18:Cancel();
        u18 = nil;
    end;

    u14.Time.Bomb.Glow.ImageTransparency = 0.75;
end;

local function StartBombGlow() -- Line: 209
    -- upvalues: u18 (ref), u14 (ref), TweenService (copy), u6 (copy)
    if u18 then
        return;
    end;

    u14.Time.Bomb.Glow.ImageTransparency = 0.75;
    u18 = TweenService:Create(u14.Time.Bomb.Glow, u6, {
        ImageTransparency = 0
    });
    u18:Play();
end;

local function UpdateBombDisplay() -- Line: 221
    -- upvalues: u16 (ref), u18 (ref), u14 (ref), u3 (copy), u5 (copy), u4 (copy), u2 (copy), StartBombGlow (copy)
    local v46 = u16;

    if not v46 then
        if u18 then
            u18:Cancel();
            u18 = nil;
        end;

        u14.Time.Bomb.Glow.ImageTransparency = 0.75;
        u14.Time.Bomb.Glow.ImageColor3 = u3;
        u14.Time.Bomb.ImageColor3 = u5;
        u14.Time.Timer.Visible = true;
        u14.Time.Bomb.Visible = false;

        return;
    end;

    u14.Time.Timer.Visible = false;
    u14.Time.Bomb.Visible = true;
    local v47 = v46:GetAttribute("Defused") == true;
    u14.Time.Bomb.Glow.ImageColor3 = v47 and u2 or u3;
    u14.Time.Bomb.ImageColor3 = v47 and u4 or u5;

    if not v47 then
        StartBombGlow();

        return;
    end;

    if u18 then
        u18:Cancel();
        u18 = nil;
    end;

    u14.Time.Bomb.Glow.ImageTransparency = 0.75;
end;

local function SetCurrentBomb(p48) -- Line: 250
    -- upvalues: u17 (ref), u16 (ref), UpdateBombDisplay (copy)
    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u16 = p48;

    if u16 then
        u17 = u16:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
    end;

    UpdateBombDisplay();
end;

function u1.CreateTemplate(p49) -- Line: 268
    -- upvalues: u1 (copy), PlayerInfo (copy), u14 (ref), u8 (copy)
    local v50 = workspace:GetAttribute("Gamemode");
    local v51 = p49:GetAttribute("Team");

    if v50 == "Bomb Defusal" or v50 == "Hostage Rescue" then
        u1.CleanupTemplate(p49);
        local v52 = PlayerInfo.createTemplate(p49, u14[v51]);

        if v52 then
            u8[p49] = v52;
        end;
    end;
end;

function u1.CleanupTemplate(p53) -- Line: 283
    -- upvalues: u8 (copy), PlayerInfo (copy)
    local v54 = u8[p53];
    u8[p53] = nil;

    if v54 then
        PlayerInfo.cleanupTemplate(p53);
        v54:Destroy();
    end;
end;

function u1.PlayerAdded(u55) -- Line: 294
    -- upvalues: u9 (copy), Janitor (copy), u10 (copy), u11 (copy), RefreshTeamHud (copy), GetPlayerAlive (copy), RemovePlayerFromRoster (copy), u13 (copy), u1 (copy), LocalPlayer (copy), Players (copy), u7 (copy), PlayerInfo (copy)
    local v56 = u9[u55];

    if v56 then
        v56:Destroy();
    end;

    local v57 = Janitor.new();
    u9[u55] = v57;
    local u58 = nil;

    local function clearCharacterObserver() -- Line: 304
        -- upvalues: u58 (ref)
        if u58 then
            u58:Destroy();
            u58 = nil;
        end;
    end;

    local function bindCharacterState(p59) -- Line: 311
        -- upvalues: u58 (ref), u55 (copy), u10 (ref), u11 (ref), RefreshTeamHud (ref), Janitor (ref), GetPlayerAlive (ref)
        if u58 then
            u58:Destroy();
            u58 = nil;
        end;

        if not p59 then
            local v60 = u55;

            if u10[v60] == false then
                return;
            end;

            u10[v60] = false;
            local v61 = u11[v60];

            if v61 == "Counter-Terrorists" and true or v61 == "Terrorists" then
                RefreshTeamHud(v61);
            end;

            return;
        end;

        local u62 = Janitor.new();
        u58 = u62;
        u62:Add(p59:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 322
            -- upvalues: u55 (ref), GetPlayerAlive (ref), u10 (ref), u11 (ref), RefreshTeamHud (ref)
            local v63 = u55;
            local v64 = GetPlayerAlive(v63);

            if u10[v63] == v64 then
                return;
            end;

            u10[v63] = v64;
            local v65 = u11[v63];

            if v65 == "Counter-Terrorists" and true or v65 == "Terrorists" then
                RefreshTeamHud(v65);
            end;
        end));

        local function bindHumanoid(p66) -- Line: 326
            -- upvalues: u62 (copy), u55 (ref), GetPlayerAlive (ref), u10 (ref), u11 (ref), RefreshTeamHud (ref)
            u62:Add(p66:GetPropertyChangedSignal("Health"):Connect(function() -- Line: 327
                -- upvalues: u55 (ref), GetPlayerAlive (ref), u10 (ref), u11 (ref), RefreshTeamHud (ref)
                local v67 = u55;
                local v68 = GetPlayerAlive(v67);

                if u10[v67] == v68 then
                    return;
                end;

                u10[v67] = v68;
                local v69 = u11[v67];

                if v69 == "Counter-Terrorists" and true or v69 == "Terrorists" then
                    RefreshTeamHud(v69);
                end;
            end));
            local v70 = u55;
            local v71 = GetPlayerAlive(v70);

            if u10[v70] == v71 then
                return;
            end;

            u10[v70] = v71;
            local v72 = u11[v70];

            if v72 == "Counter-Terrorists" and true or v72 == "Terrorists" then
                RefreshTeamHud(v72);
            end;
        end;

        local v73 = p59:FindFirstChildOfClass("Humanoid");

        if v73 then
            u62:Add(v73:GetPropertyChangedSignal("Health"):Connect(function() -- Line: 327
                -- upvalues: u55 (ref), GetPlayerAlive (ref), u10 (ref), u11 (ref), RefreshTeamHud (ref)
                local v74 = u55;
                local v75 = GetPlayerAlive(v74);

                if u10[v74] == v75 then
                    return;
                end;

                u10[v74] = v75;
                local v76 = u11[v74];

                if v76 == "Counter-Terrorists" and true or v76 == "Terrorists" then
                    RefreshTeamHud(v76);
                end;
            end));
            local v77 = u55;
            local v78 = GetPlayerAlive(v77);

            if u10[v77] == v78 then
                return;
            end;

            u10[v77] = v78;
            local v79 = u11[v77];

            if v79 == "Counter-Terrorists" and true or v79 == "Terrorists" then
                RefreshTeamHud(v79);
            end;
        else
            u62:Add(p59.ChildAdded:Connect(function(p80) -- Line: 337
                -- upvalues: u62 (copy), u55 (ref), GetPlayerAlive (ref), u10 (ref), u11 (ref), RefreshTeamHud (ref)
                if p80:IsA("Humanoid") then
                    u62:Add(p80:GetPropertyChangedSignal("Health"):Connect(function() -- Line: 327
                        -- upvalues: u55 (ref), GetPlayerAlive (ref), u10 (ref), u11 (ref), RefreshTeamHud (ref)
                        local v81 = u55;
                        local v82 = GetPlayerAlive(v81);

                        if u10[v81] == v82 then
                            return;
                        end;

                        u10[v81] = v82;
                        local v83 = u11[v81];

                        if v83 == "Counter-Terrorists" and true or v83 == "Terrorists" then
                            RefreshTeamHud(v83);
                        end;
                    end));
                    local v84 = u55;
                    local v85 = GetPlayerAlive(v84);

                    if u10[v84] == v85 then
                        return;
                    end;

                    u10[v84] = v85;
                    local v86 = u11[v84];

                    if v86 == "Counter-Terrorists" and true or v86 == "Terrorists" then
                        RefreshTeamHud(v86);
                    end;
                end;
            end));
            local v87 = u55;
            local v88 = GetPlayerAlive(v87);

            if u10[v87] == v88 then
                return;
            end;

            u10[v87] = v88;
            local v89 = u11[v87];

            if v89 == "Counter-Terrorists" and true or v89 == "Terrorists" then
                RefreshTeamHud(v89);
            end;
        end;
    end;

    local function handleTeamUpdate() -- Line: 346
        -- upvalues: u55 (copy), u11 (ref), RemovePlayerFromRoster (ref), u13 (ref), u10 (ref), GetPlayerAlive (ref), u1 (ref), RefreshTeamHud (ref), LocalPlayer (ref), Players (ref), u7 (ref), PlayerInfo (ref)
        local v90 = u55:GetAttribute("Team");

        if v90 ~= "Counter-Terrorists" and v90 ~= "Terrorists" then
            local v91 = RemovePlayerFromRoster(u55);
            u10[u55] = nil;
            u1.CleanupTemplate(u55);

            if v91 then
                RefreshTeamHud(v91);
            end;

            return;
        end;

        local v92 = u55;
        local v93;

        if u11[v92] == v90 then
            v93 = nil;
        else
            v93 = RemovePlayerFromRoster(v92);
            u11[v92] = v90;
            table.insert(u13[v90], v92);
        end;

        u10[u55] = GetPlayerAlive(u55);
        u1.CreateTemplate(u55);

        if v93 then
            RefreshTeamHud(v93);
        end;

        RefreshTeamHud(v90);

        if u55 == LocalPlayer then
            for _, v in Players:GetPlayers() do
                if v ~= LocalPlayer then
                    local v94 = v:GetAttribute("Team");

                    if v94 == "Counter-Terrorists" or v94 == "Terrorists" then
                        u1.CreateTemplate(v);
                    else
                        u1.CleanupTemplate(v);
                    end;
                end;
            end;

            for _, v in ipairs(u7) do
                RefreshTeamHud(v);
            end;
        end;

        PlayerInfo.refreshCompetitiveColors();
    end;

    v57:Add(u55:GetAttributeChangedSignal("Team"):Connect(handleTeamUpdate));
    v57:Add(u55:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 385
        -- upvalues: u55 (copy), GetPlayerAlive (ref), u10 (ref), u11 (ref), RefreshTeamHud (ref)
        local v95 = u55;
        local v96 = GetPlayerAlive(v95);

        if u10[v95] == v96 then
            return;
        end;

        u10[v95] = v96;
        local v97 = u11[v95];

        if v97 == "Counter-Terrorists" and true or v97 == "Terrorists" then
            RefreshTeamHud(v97);
        end;
    end));
    v57:Add(u55.CharacterAdded:Connect(bindCharacterState));
    v57:Add(u55.CharacterRemoving:Connect(function() -- Line: 389
        -- upvalues: u58 (ref), u55 (copy), u10 (ref), u11 (ref), RefreshTeamHud (ref)
        if u58 then
            u58:Destroy();
            u58 = nil;
        end;

        local v98 = u55;

        if u10[v98] == false then
            return;
        end;

        u10[v98] = false;
        local v99 = u11[v98];

        if v99 == "Counter-Terrorists" and true or v99 == "Terrorists" then
            RefreshTeamHud(v99);
        end;
    end));
    v57:Add(function() -- Line: 393
        -- upvalues: u58 (ref), RemovePlayerFromRoster (ref), u55 (copy), u10 (ref), RefreshTeamHud (ref)
        if u58 then
            u58:Destroy();
            u58 = nil;
        end;

        local v100 = RemovePlayerFromRoster(u55);
        u10[u55] = nil;

        if v100 then
            RefreshTeamHud(v100);
        end;
    end);
    bindCharacterState(u55.Character);
    handleTeamUpdate();
end;

function u1.Initialize(p101, p102) -- Line: 409
    -- upvalues: u15 (ref), u14 (ref), u12 (copy), Observers (copy), PlayerInfo (copy), Remotes (copy), Players (copy), GetPlayerAlive (copy), u10 (copy), u11 (copy), RefreshTeamHud (copy), GameState (copy), GetTimerFormat (copy), UpdateFrameVisibility (copy), CollectionService (copy), u17 (ref), u16 (ref), UpdateBombDisplay (copy), u7 (copy)
    u15 = p101;
    u14 = p102;
    local v103 = u14["Counter-Terrorists"];
    local Terrorists = u14.Terrorists;
    u12["Counter-Terrorists"] = {
        holder = u14["Counter-Terrorists"],
        playerCountLabel = u14.Time["Counter-Terrorists"].Players,
        morePlayersFrame = v103.MorePlayers,
        morePlayersAmountLabel = v103.MorePlayers.Amount
    };
    u12.Terrorists = {
        holder = u14.Terrorists,
        playerCountLabel = u14.Time.Terrorists.Players,
        morePlayersFrame = Terrorists.MorePlayers,
        morePlayersAmountLabel = Terrorists.MorePlayers.Amount
    };
    Observers.observeAttribute(workspace, "CTScore", function(p104) -- Line: 427
        -- upvalues: u14 (ref)
        u14.Time["Counter-Terrorists"].Score.Text = tostring(p104);

        return function() -- Line: 429
        end;
    end);
    Observers.observeAttribute(workspace, "TScore", function(p105) -- Line: 432
        -- upvalues: u14 (ref)
        u14.Time.Terrorists.Score.Text = tostring(p105);

        return function() -- Line: 434
        end;
    end);
    Observers.observeAttribute(workspace, "ServerGamemode", function(p106) -- Line: 437
        -- upvalues: PlayerInfo (ref)
        PlayerInfo.refreshCompetitiveColors();

        return function() -- Line: 439
        end;
    end);
    Remotes.UI.UIPlayerKilled.Listen(function(p107) -- Line: 442
        -- upvalues: Players (ref), PlayerInfo (ref), GetPlayerAlive (ref), u10 (ref), u11 (ref), RefreshTeamHud (ref)
        local v108 = tonumber(p107.Victim);
        local v109;

        if v108 then
            v109 = Players:GetPlayerByUserId(v108);
        else
            v109 = v108;
        end;

        if v109 then
            local v110 = PlayerInfo.getTemplateByUserId(v108);

            if v110 and v110.Parent then
                local Character = v109.Character;

                if Character then
                    Character = Character:GetAttribute("Dead") == true;
                end;

                local v111 = v109:GetAttribute("IsSpectating") == true;

                if Character == true and true or v111 == true then
                    PlayerInfo.applyTemplateLifeState(v110, true);
                end;
            end;

            local v112 = GetPlayerAlive(v109);

            if u10[v109] ~= v112 then
                u10[v109] = v112;
                local v113 = u11[v109];

                if v113 == "Counter-Terrorists" and true or v113 == "Terrorists" then
                    RefreshTeamHud(v113);
                end;
            end;
        end;

        local v114 = tonumber(p107.Killer);
        local v115;

        if v114 then
            v115 = Players:GetPlayerByUserId(v114);
        else
            v115 = v114;
        end;

        if v115 then
            PlayerInfo.incrementTemplateKills(v114);
        end;
    end);
    Remotes.UI.RoundWinner.Listen(function(p116) -- Line: 470
        -- upvalues: PlayerInfo (ref)
        PlayerInfo.setTeammateInfoRevealed(true);
    end);
    GameState.ListenToState(function(p117, p118) -- Line: 474
        -- upvalues: PlayerInfo (ref)
        if p118 == "Buy Period" then
            PlayerInfo.setTeammateInfoRevealed(true);

            return;
        end;

        if p117 == "Buy Period" and p118 == "Round In Progress" then
            PlayerInfo.setTeammateInfoRevealed(false);
        end;
    end);
    workspace:GetAttributeChangedSignal("Timer"):Connect(function() -- Line: 485
        -- upvalues: u14 (ref), GetTimerFormat (ref)
        local v119 = workspace:GetAttribute("Timer");

        if not v119 then
            return;
        end;

        local v120 = workspace:GetAttribute("Gamemode");
        local v121 = workspace:GetAttribute("GameState");
        u14.Time.Timer.TextColor3 = Color3.fromRGB(255, 255, 255);
        u14.Time.Timer.Text = GetTimerFormat(v119);

        if v120 ~= "Hostage Rescue" and v120 ~= "Bomb Defusal" or (v121 == "Warmup" or v119 > 10) then
            return;
        end;

        u14.Time.Timer.TextColor3 = Color3.fromRGB(165, 20, 20);
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(UpdateFrameVisibility);
    u15.Gameplay.Middle.TeamSelection:GetPropertyChangedSignal("Visible"):Connect(UpdateFrameVisibility);
    CollectionService:GetInstanceAddedSignal("Bomb"):Connect(function(p122) -- Line: 509
        -- upvalues: u17 (ref), u16 (ref), UpdateBombDisplay (ref)
        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u16 = p122;

        if u16 then
            u17 = u16:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
        end;

        UpdateBombDisplay();
    end);
    CollectionService:GetInstanceRemovedSignal("Bomb"):Connect(function(p123) -- Line: 513
        -- upvalues: u16 (ref), u17 (ref), UpdateBombDisplay (ref)
        if p123 == u16 then
            if u17 then
                u17:Disconnect();
                u17 = nil;
            end;

            u16 = nil;

            if u16 then
                u17 = u16:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
            end;

            UpdateBombDisplay();
        end;
    end);
    local v124 = workspace:GetAttribute("Gamemode");
    u14.Visible = (v124 == "Hostage Rescue" and true or v124 == "Bomb Defusal") and not u15.Gameplay.Middle.TeamSelection.Visible;
    local v125 = CollectionService:GetTagged("Bomb")[1];

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u16 = v125;

    if u16 then
        u17 = u16:GetAttributeChangedSignal("Defused"):Connect(UpdateBombDisplay);
    end;

    UpdateBombDisplay();

    for _, v in ipairs(u7) do
        RefreshTeamHud(v);
    end;
end;

function u1.Start() -- Line: 524
    -- upvalues: clearFrame (copy), u14 (ref), ResetRosterState (copy), Players (copy), u1 (copy), u9 (copy)
    clearFrame(u14["Counter-Terrorists"]);
    clearFrame(u14.Terrorists);
    ResetRosterState();

    for _, v in Players:GetPlayers() do
        u1.PlayerAdded(v);
    end;

    Players.PlayerAdded:Connect(u1.PlayerAdded);
    Players.PlayerRemoving:Connect(function(p126) -- Line: 535
        -- upvalues: u9 (ref), u1 (ref)
        local v127 = u9[p126];
        u9[p126] = nil;

        if v127 then
            v127:Destroy();
        end;

        u1.CleanupTemplate(p126);
    end);
end;

return u1;