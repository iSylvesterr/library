-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local PlayerInfo = require(ReplicatedStorage.Interface.Screens.Gameplay.Top.PlayerInfo);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = nil;
local u3 = nil;
local u4 = {};
local u5 = {};

local function clearFrame(p6) -- Line: 38
    local v7 = p6:GetChildren();

    for _, v in ipairs(v7) do
        if v.ClassName == "Frame" and v.Name ~= "MorePlayers" then
            v:Destroy();
        end;
    end;
end;

local function updateFrameVisibility() -- Line: 50
    -- upvalues: u2 (ref), u3 (ref)
    if not (u2 and u3) then
        return;
    end;

    local v8;

    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        v8 = not u3.Gameplay.Middle.TeamSelection.Visible;
    else
        v8 = false;
    end;

    u2.Visible = v8;

    if not u2.Visible then
        return;
    end;

    local MorePlayers = u2.Players.MorePlayers;
    local v9 = {};

    for _, child in ipairs(u2.Players:GetChildren()) do
        if child.ClassName == "Frame" and child.Name ~= "MorePlayers" then
            table.insert(v9, child);
        end;
    end;

    table.sort(v9, function(p10, p11) -- Line: 71
        return p10.LayoutOrder < p11.LayoutOrder;
    end);

    for i, v in ipairs(v9) do
        v.Visible = i <= 5;
    end;

    local v12 = math.max(#v9 - 5, 0);
    MorePlayers.Visible = v12 > 0;
    MorePlayers.Content.Amount.Text = `+{v12}`;
end;

function u1.createTemplate(p13) -- Line: 87
    -- upvalues: u1 (copy), PlayerInfo (copy), u2 (ref), u4 (copy), updateFrameVisibility (copy)
    local v14 = workspace:GetAttribute("Gamemode");
    local v15 = p13:GetAttribute("Team");

    if v14 == "Deathmatch" and (v15 == "Terrorists" or v15 == "Counter-Terrorists") then
        u1.cleanupPlayerTemplate(p13);
        local v16 = PlayerInfo.createTemplate(p13, u2.Players);

        if v16 then
            u4[p13] = v16;
        end;

        updateFrameVisibility();
    end;
end;

function u1.cleanupPlayerTemplate(p17) -- Line: 104
    -- upvalues: u4 (copy), PlayerInfo (copy), updateFrameVisibility (copy)
    local v18 = u4[p17];
    u4[p17] = nil;

    if v18 then
        PlayerInfo.cleanupTemplate(p17);
        v18:Destroy();
        updateFrameVisibility();
    end;
end;

function u1.playerAdded(u19) -- Line: 118
    -- upvalues: u5 (copy), Janitor (copy), PlayerInfo (copy), u1 (copy), updateFrameVisibility (copy)
    local v20 = u5[u19];

    if v20 then
        v20:Destroy();
    end;

    local v21 = Janitor.new();
    u5[u19] = v21;
    local u22 = nil;

    local function applyLifeStateToTemplate() -- Line: 128
        -- upvalues: PlayerInfo (ref), u19 (copy)
        local v23 = PlayerInfo.getTemplateByUserId(u19.UserId);

        if not v23 then
            return;
        end;

        local Character = u19.Character;
        local v24 = Character and Character:GetAttribute("Dead") == true and true or u19:GetAttribute("IsSpectating") == true;
        PlayerInfo.applyTemplateLifeState(v23, v24 == true);
    end;

    local function bindCharacterState(p25) -- Line: 139
        -- upvalues: u22 (ref), applyLifeStateToTemplate (copy), Janitor (ref)
        if u22 then
            u22:Destroy();
            u22 = nil;
        end;

        if not p25 then
            applyLifeStateToTemplate();

            return;
        end;

        local v26 = Janitor.new();
        u22 = v26;
        v26:Add(p25:GetAttributeChangedSignal("Dead"):Connect(applyLifeStateToTemplate));
        applyLifeStateToTemplate();
    end;

    local function handleTeamUpdate() -- Line: 157
        -- upvalues: u19 (copy), u1 (ref), bindCharacterState (copy), applyLifeStateToTemplate (copy), u22 (ref)
        local v27 = u19:GetAttribute("Team");

        if v27 ~= "Counter-Terrorists" and v27 ~= "Terrorists" then
            u1.cleanupPlayerTemplate(u19);

            if u22 then
                u22:Destroy();
                u22 = nil;
            end;

            return;
        end;

        u1.createTemplate(u19);
        bindCharacterState(u19.Character);
        applyLifeStateToTemplate();
    end;

    v21:Add(u19:GetAttributeChangedSignal("Team"):Connect(handleTeamUpdate));
    v21:Add(u19:GetAttributeChangedSignal("IsSpectating"):Connect(applyLifeStateToTemplate));
    v21:Add(u19:GetAttributeChangedSignal("Score"):Connect(function() -- Line: 174
        -- upvalues: updateFrameVisibility (ref)
        task.defer(updateFrameVisibility);
    end));
    v21:Add(u19.CharacterAdded:Connect(bindCharacterState));
    v21:Add(u19.CharacterRemoving:Connect(function() -- Line: 178
        -- upvalues: applyLifeStateToTemplate (copy)
        applyLifeStateToTemplate();
    end));
    v21:Add(function() -- Line: 181
        -- upvalues: u22 (ref)
        if u22 then
            u22:Destroy();
            u22 = nil;
        end;
    end);
    bindCharacterState(u19.Character);
    handleTeamUpdate();
end;

function u1.Initialize(p28, p29) -- Line: 195
    -- upvalues: u3 (ref), u2 (ref), Observers (copy), GetTimerFormat (copy), Router (copy), updateFrameVisibility (copy)
    u3 = p28;
    u2 = p29;
    Observers.observeAttribute(workspace, "Timer", function(p30) -- Line: 198
        -- upvalues: u2 (ref), GetTimerFormat (ref), Router (ref)
        local v31 = workspace:GetAttribute("Gamemode");
        local v32 = workspace:GetAttribute("GameState");
        u2.Time.Timer.TextColor3 = Color3.fromRGB(255, 255, 255);
        u2.Time.Timer.Text = GetTimerFormat(p30);

        if v31 ~= "Deathmatch" or (v32 == "Warmup" or p30 > 10) then
            return;
        end;

        u2.Time.Timer.TextColor3 = Color3.fromRGB(165, 20, 20);
        Router.broadcastRouter("PlayCountdownTimer");
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(updateFrameVisibility);
    u3.Gameplay.Middle.TeamSelection:GetPropertyChangedSignal("Visible"):Connect(updateFrameVisibility);
    updateFrameVisibility();
end;

function u1.Start() -- Line: 215
    -- upvalues: clearFrame (copy), u2 (ref), Players (copy), u1 (copy), u5 (copy), updateFrameVisibility (copy)
    clearFrame(u2.Players);

    for _, v in Players:GetPlayers() do
        u1.playerAdded(v);
    end;

    Players.PlayerAdded:Connect(u1.playerAdded);
    Players.PlayerRemoving:Connect(function(p33) -- Line: 224
        -- upvalues: u5 (ref), u1 (ref), updateFrameVisibility (ref)
        local v34 = u5[p33];
        u5[p33] = nil;

        if v34 then
            v34:Destroy();
        end;

        u1.cleanupPlayerTemplate(p33);
        updateFrameVisibility();
    end);
end;

return u1;