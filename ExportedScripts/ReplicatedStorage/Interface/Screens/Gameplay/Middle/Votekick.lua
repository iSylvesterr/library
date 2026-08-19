-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local u2 = nil;
local u3 = nil;
local u4 = 0;
local u5 = false;

local function ShouldAutoCloseForState(p6) -- Line: 35
    return p6 == "Game Ending" and true or p6 == "Map Voting";
end;

function u1.UpdateAmount(p7, p8, p9) -- Line: 41
    -- upvalues: u2 (ref), LocalPlayer (copy)
    u2.Option[p7].Amount.Text = `{p8}`;

    if LocalPlayer.UserId ~= tonumber(p9) then
        return;
    end;

    u2.Result.TextLabel.Text = `You voted: <font color="{p7 == "Yes" and "rgb(90, 186, 55)" or "rgb(255,49,49)"}">{string.upper(p7)}</font>`;
    u2.Result.Visible = true;
end;

function u1.UpdateFrame(p10, p11) -- Line: 55
    -- upvalues: Players (copy), u2 (ref)
    local v12 = Players:GetPlayerByUserId(p10);
    local v13 = Players:GetPlayerByUserId(p11);

    if not v12 then
        return;
    end;

    u2.Player.Text = `Kick player: {v12.Name}? `;
    u2.Frame.Title.Text = `Vote By: {v13 and v13.Name or "Unknown"}`;
    u2.Option.Yes.Amount.Text = "0";
    u2.Option.No.Amount.Text = "0";
end;

function u1.OpenFrame(p14) -- Line: 70
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u4 (ref), LocalPlayer (copy), TweenService (copy), u1 (copy)
    u2.Position = UDim2.fromScale(-0.08, 0.525);
    u2:SetAttribute("IsVoteKickActive", true);
    u2.Result.Visible = false;
    u3 = p14;
    u2.Visible = true;
    u5 = false;
    u4 = u4 + 1;
    local u15 = u4;

    if LocalPlayer.UserId == p14 then
        u2.Result.TextLabel.Text = "You are being vote kicked.";
        u2.Result.Visible = true;
    end;

    TweenService:Create(u2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.08, 0.525)
    }):Play();
    task.delay(30, function() -- Line: 91
        -- upvalues: u4 (ref), u15 (copy), u1 (ref)
        if u4 == u15 then
            u1.CloseFrame();
        end;
    end);
end;

function u1.CloseFrame() -- Line: 100
    -- upvalues: u4 (ref), u2 (ref), u3 (ref), u5 (ref), TweenService (copy)
    u4 = u4 + 1;
    local u16 = u4;
    u2:SetAttribute("IsVoteKickActive", false);
    u2.Result.Visible = false;
    u3 = nil;
    u5 = false;

    if not u2.Visible then
        u2.Position = UDim2.fromScale(-0.08, 0.525);

        return;
    end;

    local v17 = TweenService:Create(u2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(-0.08, 0.525)
    });
    v17.Completed:Once(function() -- Line: 118
        -- upvalues: u4 (ref), u16 (copy), u2 (ref)
        if u4 == u16 then
            u2.Visible = false;
        end;
    end);
    v17:Play();
end;

function u1.CastVote(p18) -- Line: 129
    -- upvalues: u3 (ref), LocalPlayer (copy), u5 (ref), Remotes (copy)
    if u3 and LocalPlayer.UserId == u3 then
        return;
    end;

    if not u5 then
        u5 = true;

        return (p18 == "Yes" and Remotes.VoteKick.VoteYes or Remotes.VoteKick.VoteNo).Send({
            Amount = 0,
            Voter = tostring(LocalPlayer.UserId)
        });
    end;
end;

function u1.Initialize(p19, p20) -- Line: 149
    -- upvalues: u2 (ref), GetUserPlatform (copy), Remotes (copy), u1 (copy), GameState (copy), ActivateButton (copy), UserInputService (copy)
    u2 = p20;
    u2:SetAttribute("IsVoteKickActive", false);
    u2.Visible = false;
    local v21 = table.find(GetUserPlatform(), "Mobile") ~= nil;
    local Keybinds = u2:FindFirstChild("Keybinds");
    local MobileNoButton = u2:FindFirstChild("MobileNoButton");
    local MobileYesButton = u2:FindFirstChild("MobileYesButton");

    if Keybinds then
        Keybinds.Visible = not v21;
    end;

    if MobileNoButton then
        MobileNoButton.Visible = v21;
    end;

    if MobileYesButton then
        MobileYesButton.Visible = v21;
    end;

    Remotes.VoteKick.VoteNoUpdate.Listen(function(p22) -- Line: 170
        -- upvalues: u1 (ref)
        u1.UpdateAmount("No", p22.Amount, p22.Voter);
    end);
    Remotes.VoteKick.VoteYesUpdate.Listen(function(p23) -- Line: 174
        -- upvalues: u1 (ref)
        u1.UpdateAmount("Yes", p23.Amount, p23.Voter);
    end);
    Remotes.VoteKick.StartVote.Listen(function(p24) -- Line: 178
        -- upvalues: GameState (ref), u1 (ref)
        local v25 = GameState.GetState();

        if v25 == "Game Ending" and true or v25 == "Map Voting" then
            return;
        end;

        local v26 = tonumber(p24.TargetUserId);
        local v27 = tonumber(p24.VoterUserId);
        u1.UpdateFrame(v26, v27);
        u1.OpenFrame(v26);
    end);
    Remotes.VoteKick.EndVote.Listen(function() -- Line: 188
        -- upvalues: u1 (ref)
        u1.CloseFrame();
    end);
    GameState.ListenToState(function(p28, p29) -- Line: 191
        -- upvalues: u1 (ref)
        if p29 ~= "Game Ending" and p29 ~= "Map Voting" then
            return;
        end;

        u1.CloseFrame();
    end);

    if v21 and (MobileNoButton and MobileYesButton) then
        ActivateButton(MobileNoButton);
        ActivateButton(MobileYesButton);
        MobileNoButton.Activated:Connect(function() -- Line: 202
            -- upvalues: u1 (ref)
            u1.CastVote("No");
        end);
        MobileYesButton.Activated:Connect(function() -- Line: 205
            -- upvalues: u1 (ref)
            u1.CastVote("Yes");
        end);
    end;

    if not (v21 and (MobileNoButton and MobileYesButton)) then
        UserInputService.InputBegan:Connect(function(p30, p31) -- Line: 211
            -- upvalues: u2 (ref), UserInputService (ref), u1 (ref)
            if p31 then
                return;
            end;

            if not u2.Visible then
                return;
            end;

            if UserInputService:GetFocusedTextBox() then
                return;
            end;

            if p30.UserInputType ~= Enum.UserInputType.Keyboard then
                return;
            end;

            if p30.KeyCode == Enum.KeyCode.K then
                u1.CastVote("Yes");

                return;
            end;

            if p30.KeyCode ~= Enum.KeyCode.L then
                return;
            end;

            u1.CastVote("No");
        end);
    end;
end;

return u1;