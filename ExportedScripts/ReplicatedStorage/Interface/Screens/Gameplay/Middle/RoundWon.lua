-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = false;
local u3 = nil;
local v4 = {};

local function formatMVPReason(p5) -- Line: 56
    return (not p5 or p5 == "Unknown") and "MVP" or `MVP | {p5}`;
end;

local function arePlayersAliveOnBothTeams() -- Line: 64
    -- upvalues: Players (copy)
    local v6 = 0;
    local v7 = 0;

    for _, v in ipairs(Players:GetPlayers()) do
        local v8 = v:GetAttribute("Team");

        if v8 == "Counter-Terrorists" or v8 == "Terrorists" then
            local Character = v.Character;

            if Character and (Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead")) then
                local v9 = Character:FindFirstChildOfClass("Humanoid");

                if v9 and (v9.Health > 0 and not v:GetAttribute("IsSpectating")) then
                    if v8 == "Counter-Terrorists" then
                        v7 = v7 + 1;
                    else
                        v6 = v6 + 1;
                    end;
                end;
            end;
        end;
    end;

    local v10;

    if v7 > 0 then
        v10 = v6 > 0;
    else
        v10 = false;
    end;

    return v10;
end;

local function stopMVPMusic() -- Line: 88
    -- upvalues: LocalPlayer (copy), u3 (ref)
    local MVP = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MVP");

    if MVP and MVP:IsA("Sound") then
        MVP:Stop();
        MVP:Destroy();
    end;

    u3 = nil;
end;

local function updateMVPMusicVolume() -- Line: 98
    -- upvalues: u3 (ref), DataController (copy), LocalPlayer (copy)
    if not (u3 and u3.Parent) then
        return;
    end;

    local v11 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.MVP Volume") or 50) / 50;
    local v12 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
    u3.Volume = (u3:GetAttribute("BaseVolume") or u3.Volume) * v11 * v12;
end;

local function playMVPMusic() -- Line: 111
    -- upvalues: MenuState (copy), LocalPlayer (copy), DataController (copy), arePlayersAliveOnBothTeams (copy), u3 (ref), Sound (copy)
    if MenuState.GetCurrentScreen() ~= nil then
        return;
    end;

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local MVP = PlayerGui:FindFirstChild("MVP");

    if MVP and (MVP:IsA("Sound") and MVP.IsPlaying) then
        return;
    end;

    if DataController.Get(LocalPlayer, "Settings.Audio.Other.Mute MVP Music when players on both teams are alive") == true and arePlayersAliveOnBothTeams() then
        return;
    end;

    local v13 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.MVP Volume") or 50) / 50;
    u3 = Sound.new("Round"):play({
        Name = "MVP",
        Parent = PlayerGui
    }, v13);

    if u3 then
        local v14 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
        local Volume = u3.Volume;

        if v13 > 0 and v14 > 0 then
            Volume = Volume / (v13 * v14) or Volume;
        end;

        u3:SetAttribute("BaseVolume", Volume);
        u3.Destroying:Once(function() -- Line: 147
            -- upvalues: u3 (ref)
            u3 = nil;
        end);
    end;
end;

local function hideAllRoundWonAndMVPFrames() -- Line: 153
    -- upvalues: u1 (copy)
    for _, v in u1 do
        v.roundWonFrame.Visible = false;

        if v.playerMVPCTFrame then
            v.playerMVPCTFrame.Visible = false;
        end;

        if v.playerMVPTFrame then
            v.playerMVPTFrame.Visible = false;
        end;
    end;
end;

local function updateMVPFrame(p15, p16, p17) -- Line: 165
    -- upvalues: Players (copy)
    local MVP = p15:FindFirstChild("MVP");
    local v18 = MVP and MVP:FindFirstChild("Text");

    if v18 then
        v18.Text = p16;
    end;

    local Name = p15:FindFirstChild("Name");

    if Name then
        Name.Text = p17;
    end;

    local Player = p15:FindFirstChild("Player");

    if Player then
        local Player2 = Player:FindFirstChild("Player");
        local v19 = Player2 and Players:FindFirstChild(p17);

        if v19 then
            Player2.Image = `rbxthumb://type=AvatarHeadShot&id={v19.UserId}&w=420&h=420`;
        end;
    end;
end;

local function onRoundWinner(p20) -- Line: 191
    -- upvalues: LocalPlayer (copy), u1 (copy)
    local v21 = LocalPlayer:GetAttribute("Team");

    for _, v in u1 do
        local v22;

        if p20 == v.winningTeam then
            v22 = v21 == p20;
        else
            v22 = false;
        end;

        v.roundWonFrame.Visible = v22;
    end;
end;

local function onRoundMVP(p23) -- Line: 198
    -- upvalues: Players (copy), u1 (copy), updateMVPFrame (copy), playMVPMusic (copy)
    if not (p23 and (p23.Team and (p23.PlayerName and p23.Reason))) then
        return;
    end;

    local Team = p23.Team;
    local PlayerName = p23.PlayerName;
    local Reason = p23.Reason;

    if Team ~= "Counter-Terrorists" and Team ~= "Terrorists" then
        return;
    end;

    if not Players:FindFirstChild(PlayerName) then
        return;
    end;

    local v24 = (not Reason or Reason == "Unknown") and "MVP" or `MVP | {Reason}`;

    for _, v in u1 do
        if Team == "Counter-Terrorists" and v.playerMVPCTFrame then
            updateMVPFrame(v.playerMVPCTFrame, v24, PlayerName);
            v.playerMVPCTFrame.Visible = true;

            if v.playerMVPTFrame then
                v.playerMVPTFrame.Visible = false;
            end;

            playMVPMusic();
        elseif Team == "Terrorists" and v.playerMVPTFrame then
            updateMVPFrame(v.playerMVPTFrame, v24, PlayerName);
            v.playerMVPTFrame.Visible = true;

            if v.playerMVPCTFrame then
                v.playerMVPCTFrame.Visible = false;
            end;

            playMVPMusic();
        end;
    end;
end;

local function ensureListenersInitialized() -- Line: 238
    -- upvalues: u2 (ref), DataController (copy), LocalPlayer (copy), updateMVPMusicVolume (copy), GameState (copy), hideAllRoundWonAndMVPFrames (copy), u3 (ref), Remotes (copy), onRoundWinner (copy), onRoundMVP (copy)
    if u2 then
        return;
    end;

    u2 = true;
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", updateMVPMusicVolume);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.MVP Volume", updateMVPMusicVolume);
    GameState.ListenToState(function(p25, p26) -- Line: 247
        -- upvalues: hideAllRoundWonAndMVPFrames (ref), LocalPlayer (ref), u3 (ref)
        if p25 == "Intermission" and p26 == "Buy Period" or p26 == "Round In Progress" then
            hideAllRoundWonAndMVPFrames();
            local MVP = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MVP");

            if MVP and MVP:IsA("Sound") then
                MVP:Stop();
                MVP:Destroy();
            end;

            u3 = nil;
        end;
    end);
    Remotes.UI.RoundWinner.Listen(onRoundWinner);
    Remotes.UI.RoundMVP.Listen(onRoundMVP);
end;

function v4.create(u27) -- Line: 261
    -- upvalues: u1 (copy), ensureListenersInitialized (copy)
    return {
        Initialize = function(p28, p29) -- Line: 264, Name: Initialize
            -- upvalues: u1 (ref), u27 (copy), ensureListenersInitialized (ref)
            u1[u27] = {
                winningTeam = u27,
                roundWonFrame = p29,
                mainGui = p28,
                playerMVPCTFrame = p28.Gameplay.Middle:FindFirstChild("PlayerMVPCT"),
                playerMVPTFrame = p28.Gameplay.Middle:FindFirstChild("PlayerMVPT")
            };
            ensureListenersInitialized();
        end
    };
end;

return v4;