-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local Votekick = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Votekick);
local LocalPlayer = Players.LocalPlayer;
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection);
local u2 = nil;
local u3 = nil;

local function ClearFrame(p4) -- Line: 36
    local v5 = p4:GetChildren();

    for _, v in ipairs(v5) do
        if v:IsA("Frame") then
            v:Destroy();
        end;
    end;
end;

local function IsActiveTeamPlayer(p6) -- Line: 48
    -- upvalues: Votekick (copy)
    return Votekick.GetActiveTeam(p6:GetAttribute("Team")) ~= nil;
end;

local function GetActiveTeamPlayerCount() -- Line: 54
    -- upvalues: Players (copy), Votekick (copy)
    local v7 = 0;

    for _, v in ipairs(Players:GetPlayers()) do
        if Votekick.GetActiveTeam(v:GetAttribute("Team")) ~= nil then
            v7 = v7 + 1;
        end;
    end;

    return v7;
end;

function u1.PlayerAdded(u8) -- Line: 67
    -- upvalues: LocalPlayer (copy), Votekick (copy), u3 (ref), ReplicatedStorage (copy), Router (copy), Remotes (copy)
    if LocalPlayer == u8 or Votekick.GetActiveTeam(u8:GetAttribute("Team")) == nil then
        return;
    end;

    if not u3.Menu.VoteKick.Container:FindFirstChild((tostring(u8.UserId))) then
        local v9 = ReplicatedStorage.Assets.UI.VoteKick.PlayerTemplate:Clone();
        v9.PlayerIcon.Image = `rbxthumb://type=AvatarHeadShot&id={u8.UserId}&w=420&h=420`;
        v9.PlayerInfo.Username.Text = `@{u8.Name}`;
        v9.PlayerInfo.Nickname.Text = u8.DisplayName;
        v9.Parent = u3.Menu.VoteKick.Container;
        v9.Name = tostring(u8.UserId);
        v9.MouseButton1Click:Connect(function() -- Line: 80
            -- upvalues: Router (ref), Remotes (ref), u8 (copy), u3 (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            Remotes.VoteKick.CallVote.Send((tostring(u8.UserId)));
            u3.Menu.VoteKick.Visible = false;
        end);
    end;
end;

function u1.RefreshVoteKickEntries() -- Line: 91
    -- upvalues: ClearFrame (copy), u3 (ref), Players (copy), u1 (copy)
    ClearFrame(u3.Menu.VoteKick.Container);

    for _, v in ipairs(Players:GetPlayers()) do
        u1.PlayerAdded(v);
    end;
end;

function u1.OpenChooseTeam() -- Line: 101
    -- upvalues: LocalPlayer (copy), TeamSelection (copy)
    local v10 = LocalPlayer:GetAttribute("IsSpectating");
    local v11 = LocalPlayer:GetAttribute("Team");

    if v11 ~= "Counter-Terrorists" and v11 ~= "Terrorists" and v10 ~= true then
        return;
    end;

    if v10 then
        TeamSelection.openFrame();

        return;
    end;

    if not LocalPlayer.Character then
        return;
    end;

    TeamSelection.ToggleTeamSelection();
end;

function u1.Initialize(p12, p13) -- Line: 129
    -- upvalues: u3 (ref), u2 (ref), u1 (copy), Players (copy)
    u3 = p12;
    u2 = p13;
    u1.RefreshVoteKickEntries();
    Players.PlayerAdded:Connect(function(p14) -- Line: 134
        -- upvalues: u1 (ref)
        u1.PlayerAdded(p14);
    end);
    Players.PlayerRemoving:Connect(function(p15) -- Line: 138
        -- upvalues: u3 (ref)
        local v16 = u3.Menu.VoteKick.Container:FindFirstChild((tostring(p15.UserId)));

        if not v16 then
            return;
        end;

        v16:Destroy();
    end);
end;

function u1.Start() -- Line: 149
    -- upvalues: ActivateButton (copy), u3 (ref), CloseButtonRegistry (copy), Router (copy), u2 (ref), u1 (copy), Votekick (copy), LocalPlayer (copy), DataController (copy), GetActiveTeamPlayerCount (copy)
    ActivateButton(u3.Menu.VoteKick.Buttons.Close);
    CloseButtonRegistry.Add(u3.Menu.VoteKick, u3.Menu.VoteKick.Buttons.Close, function() -- Line: 152
        -- upvalues: Router (ref), u3 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u3.Menu.VoteKick.Visible = false;
    end);
    ActivateButton(u2.ChooseTeam);
    u2.ChooseTeam.MouseButton1Click:Connect(function() -- Line: 158
        -- upvalues: u1 (ref)
        u1.OpenChooseTeam();
    end);
    ActivateButton(u2.VoteKick);
    u2.VoteKick.MouseButton1Click:Connect(function() -- Line: 164
        -- upvalues: Router (ref), u3 (ref), Votekick (ref), LocalPlayer (ref), DataController (ref), GetActiveTeamPlayerCount (ref), u1 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local VoteKick = u3.Menu:FindFirstChild("VoteKick");

        if not VoteKick then
            return;
        end;

        local v17 = Votekick.GetActiveTeam(LocalPlayer:GetAttribute("Team"));

        if LocalPlayer:GetAttribute("IsSpectating") and not v17 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You cannot vote kick while spectating as a spectator.");

            return;
        end;

        if not v17 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You must be on a team to start a vote kick.");

            return;
        end;

        local v18 = DataController.Get(LocalPlayer, "Level");
        local v19;

        if typeof(v18) == "table" then
            v19 = tonumber(v18.Level);
        else
            v19 = nil;
        end;

        if not v19 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Your data is still loading. Please try again in a moment.");

            return;
        end;

        if v19 < Votekick.MIN_LEVEL then
            Router.broadcastRouter("CreateMenuNotification", "Error", (`You need to be level {Votekick.MIN_LEVEL} to vote kick players.`));

            return;
        end;

        if GetActiveTeamPlayerCount() < Votekick.MINIMUM_ACTIVE_PLAYERS then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Not enough active players to start a vote kick.");

            return;
        end;

        pcall(function() -- Line: 198
            -- upvalues: u1 (ref)
            u1.RefreshVoteKickEntries();
        end);
        VoteKick.Visible = true;
    end);
end;

return u1;