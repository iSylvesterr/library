-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Observers = require(ReplicatedStorage.Packages.Observers);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function clearFrame(p6, p7) -- Line: 38
    local v8 = p6:GetChildren();

    for _, v in ipairs(v8) do
        if v.ClassName == p7 then
            v:Destroy();
        end;
    end;
end;

local function updateVotingFrame(p9) -- Line: 50
    -- upvalues: u3 (ref), Players (copy)
    local v10 = u3.MapVote:GetChildren();

    for _, v in ipairs(v10) do
        if v:IsA("ImageButton") then
            local v11 = p9 and p9[v.Name] or v:GetAttribute("Amount");

            if v11 then
                v.Main.Amount.Text = `<font color="rgb(219,199,126)">{v11}</font>/{#Players:GetPlayers()}`;
                v:SetAttribute("Amount", v11);
            end;
        end;
    end;
end;

local function createVoteButton(p12, u13) -- Line: 68
    -- upvalues: ReplicatedStorage (copy), Players (copy), u3 (ref), u2 (ref), Remotes (copy), TweenService (copy)
    local v14 = ReplicatedStorage.Database.Custom.GameStats.Maps:WaitForChild(u13, 10);

    if not v14 then
        warn((`Failed to load map module for {u13} - map may not exist or hasn't replicated yet`));

        return;
    end;

    local v15 = require(v14);

    if not (v15 and v15.Icon) then
        warn((`Map {u13} is missing Icon property`));

        return;
    end;

    local u16 = ReplicatedStorage.Assets.UI.EndScreen.VoteTemplate:Clone();
    u16.Main.Amount.Text = `<font color="rgb(219,199,126)">0</font>/{#Players:GetPlayers()}`;
    u16.Main.Icon.Image = v15.Icon;
    u16.Parent = u3.MapVote;
    u16.Main.Selection.Text = u13;
    u16:SetAttribute("Amount", 0);
    u16.Title.Visible = p12 == 1;
    u16.Voted.Visible = false;
    u16.Name = u13;
    u16.Button.MouseButton1Click:Connect(function() -- Line: 96
        -- upvalues: u2 (ref), u13 (copy), Remotes (ref), TweenService (ref), u16 (copy), u3 (ref)
        if u2 ~= u13 then
            Remotes.Map.SubmitMapVote.Send(u13);
            TweenService:Create(u16.Main.UIStroke, TweenInfo.new(0.5), {
                Transparency = 0
            }):Play();
            TweenService:Create(u16.Main.UIStroke, TweenInfo.new(0.5), {
                Thickness = 5.5
            }):Play();

            if u2 then
                local v17 = u3.MapVote:FindFirstChild(u2);
                TweenService:Create(v17.Main.UIStroke, TweenInfo.new(0.5), {
                    Transparency = 0.75
                }):Play();
                TweenService:Create(v17.Main.UIStroke, TweenInfo.new(0.5), {
                    Thickness = 1.5
                }):Play();
            end;

            u2 = u13;
        end;
    end);
    u16.Button.MouseEnter:Connect(function() -- Line: 126
        -- upvalues: TweenService (ref), u16 (copy)
        TweenService:Create(u16.Main.Icon.UIScale, TweenInfo.new(0.5), {
            Scale = 1.1
        }):Play();
    end);
    u16.Button.MouseLeave:Connect(function() -- Line: 130
        -- upvalues: TweenService (ref), u16 (copy)
        TweenService:Create(u16.Main.Icon.UIScale, TweenInfo.new(0.5), {
            Scale = 1
        }):Play();
    end);
end;

function u1.CloseFrame() -- Line: 138
    -- upvalues: u3 (ref), CameraController (copy), LocalPlayer (copy), ReplicatedStorage (copy), u4 (ref)
    local Visible = u3.Visible;
    u3.Visible = false;
    CameraController.setForceLockOverride("EndScreen", false);

    if Visible then
        local v18 = LocalPlayer:GetAttribute("Team");

        if not (LocalPlayer.Character and v18) or v18 == "Spectators" then
            require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection).openFrame();

            return;
        end;
    end;

    if not (require(ReplicatedStorage.Controllers.MenuSceneController).IsActive() or u4.Menu.Visible) then
        return;
    end;

    require(ReplicatedStorage.Interface.Screens.Menu.Top).ResetToMainMenu();

    if not u4.Menu.Visible then
        CameraController.setForceLockOverride("Menu", true);
        u4.Menu.Visible = true;
    end;

    u4.Gameplay.Visible = false;
end;

function u1.Initialize(p19, p20) -- Line: 179
    -- upvalues: u3 (ref), u4 (ref), clearFrame (copy), Remotes (copy), u5 (ref), u2 (ref), createVoteButton (copy), updateVotingFrame (copy), u1 (copy), Observers (copy), GetTimerFormat (copy), GameState (copy), TweenService (copy)
    u3 = p20;
    u4 = p19;
    clearFrame(u3.MapVote, "ImageButton");
    Remotes.Map.StartMapVote.Listen(function(p21) -- Line: 185
        -- upvalues: u5 (ref), clearFrame (ref), u3 (ref), u2 (ref), createVoteButton (ref)
        if u5 then
            u5:Cancel();
            u5 = nil;
        end;

        clearFrame(u3.MapVote, "ImageButton");
        u2 = nil;

        for i, v in ipairs(p21) do
            createVoteButton(i, v);
        end;
    end);
    Remotes.Map.UpdateMapVote.Listen(function(p22) -- Line: 198
        -- upvalues: updateVotingFrame (ref)
        updateVotingFrame(p22);
    end);
    Remotes.Map.EndMapVote.Listen(function(p23) -- Line: 203
        -- upvalues: u5 (ref), u1 (ref)
        if u5 then
            u5:Cancel();
            u5 = nil;
        end;

        u1.CloseFrame();
    end);
    Observers.observePlayer(function() -- Line: 212
        -- upvalues: updateVotingFrame (ref)
        updateVotingFrame();

        return function() -- Line: 215
            -- upvalues: updateVotingFrame (ref)
            updateVotingFrame();
        end;
    end);
    Observers.observeAttribute(workspace, "Timer", function(p24) -- Line: 221
        -- upvalues: u3 (ref), GetTimerFormat (ref), GameState (ref), u5 (ref), TweenService (ref)
        u3.Top.Timer.Text = GetTimerFormat(p24);

        if GameState.GetState() == "Map Voting" and not u5 then
            local Extra = u3.Top:FindFirstChild("Extra");

            if Extra and p24 > 0 then
                Extra.Size = UDim2.new(0, 0, Extra.Size.Y.Scale, Extra.Size.Y.Offset);
                local v25 = TweenService:Create(Extra, TweenInfo.new(p24 * 1.15, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(1, 0, Extra.Size.Y.Scale, Extra.Size.Y.Offset)
                });
                u5 = v25;
                v25:Play();
            end;
        end;
    end);

    if GameState.GetState() == "Map Voting" then
        local v26 = false;

        for _, child in ipairs(u3.MapVote:GetChildren()) do
            if child:IsA("ImageButton") then
                v26 = true;
                break;
            end;
        end;

        if not v26 then
            Remotes.Map.RequestMapVote.Send();
        end;
    end;
end;

return u1;