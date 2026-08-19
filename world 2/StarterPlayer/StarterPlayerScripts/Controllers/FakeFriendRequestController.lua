-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local StarterGui = game:GetService("StarterGui");
local u1 = require("@game/ReplicatedStorage/SharedModules/Networking");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local v2 = {};

local function resolveUi() -- Line: 19
    -- upvalues: PlayerGui (copy)
    local FriendRequest = PlayerGui:FindFirstChild("FriendRequest");

    if not FriendRequest then
        return nil;
    end;

    local Frame = FriendRequest:FindFirstChild("Frame");
    local v3;

    if Frame then
        v3 = Frame:FindFirstChild("FriendTemplate");
    else
        v3 = Frame;
    end;

    if Frame and v3 then
        return FriendRequest, Frame, v3;
    end;

    return nil;
end;

function v2.Prompt(p4, u5) -- Line: 36
    -- upvalues: LocalPlayer (copy), PlayerGui (copy), u1 (copy), StarterGui (copy)
    if not u5 or u5 == LocalPlayer then
        return;
    end;

    local FriendRequest = PlayerGui:FindFirstChild("FriendRequest");
    local v6, v7;

    if FriendRequest then
        v6 = FriendRequest:FindFirstChild("Frame");

        if v6 then
            v7 = v6:FindFirstChild("FriendTemplate");
        else
            v7 = v6;
        end;

        if not (v6 and v7) then
            FriendRequest = nil;
            v6 = nil;
            v7 = nil;
        end;
    else
        FriendRequest = nil;
        v6 = nil;
        v7 = nil;
    end;

    if not (FriendRequest and (v6 and v7)) then
        return;
    end;

    local u8 = v7:Clone();
    u8.Name = "FriendRequest_" .. u5.UserId;
    u8.Visible = true;
    local ImageLabel = u8:FindFirstChild("ImageLabel");

    if ImageLabel then
        ImageLabel = ImageLabel:FindFirstChild("PlayerPortrait");
    end;

    if ImageLabel then
        ImageLabel.Image = `rbxthumb://type=AvatarHeadShot&id={u5.UserId}&w={420}&h={420}`;
    end;

    local TextLabel = u8:FindFirstChild("TextLabel");

    if TextLabel then
        TextLabel.Text = `{u5.DisplayName} sent you a friend request`;
    end;

    local Buttons = u8:FindFirstChild("Buttons");
    local v9;

    if Buttons then
        v9 = Buttons:FindFirstChild("AcceptButton");
    else
        v9 = Buttons;
    end;

    if Buttons then
        Buttons = Buttons:FindFirstChild("DeclineButton");
    end;

    if Buttons then
        Buttons.Activated:Connect(function() -- Line: 66
            -- upvalues: u8 (copy), u1 (ref), u5 (copy)
            u8:Destroy();
            u1.Gifting.FakeFriendRequestResponse:Fire(u5, false);
        end);
    end;

    if v9 then
        v9.Activated:Connect(function() -- Line: 73
            -- upvalues: u8 (copy), u1 (ref), u5 (copy), StarterGui (ref)
            u8:Destroy();
            u1.Gifting.FakeFriendRequestResponse:Fire(u5, true);
            pcall(function() -- Line: 76
                -- upvalues: StarterGui (ref), u5 (ref)
                StarterGui:SetCore("PromptSendFriendRequest", u5);
            end);
        end);
    end;

    u8.Parent = v6;

    if FriendRequest then
        FriendRequest.Enabled = true;
    end;
end;

function v2.Init(u10) -- Line: 89
    -- upvalues: u1 (copy)
    u1.Gifting.FakeFriendRequest.OnClientEvent:Connect(function(p11) -- Line: 90
        -- upvalues: u10 (copy)
        if typeof(p11) ~= "Instance" or not p11:IsA("Player") then
            return;
        end;

        u10:Prompt(p11);
    end);
end;

function v2.Start(p12) -- Line: 99
end;

return v2;