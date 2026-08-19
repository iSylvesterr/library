-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Network = require(ReplicatedStorage.Library.Client.Network);
local CoreCall = require(ReplicatedStorage.Library.Functions.CoreCall);
local u1 = {};
local LocalPlayer = Players.LocalPlayer;
local Friend_Notification = LocalPlayer.PlayerGui:WaitForChild("Friend_Notification");
local BodyLabel = Friend_Notification.Frame.Frame.Background.Holder.BodyLabel;
local Accept = Friend_Notification.Frame.Frame.Background.Holder.Frame.Accept;
local Decline = Friend_Notification.Frame.Frame.Background.Holder.Frame.Decline;
local u2 = {};
local u3 = nil;

function u1.DismissCurrent() -- Line: 23
    -- upvalues: u3 (ref), u2 (copy), BodyLabel (copy), Friend_Notification (copy)
    if not u3 then
        return;
    end;

    local v4 = table.find(u2, u3);

    if v4 then
        table.remove(u2, v4);
    end;

    u3 = nil;

    if #u2 <= 0 then
        Friend_Notification.Show_VAL.Value = false;

        return;
    end;

    if u3 then
        return;
    end;

    local v5 = u2[1];
    u3 = v5;
    BodyLabel.Text = `Friend request from\n{v5.Name}`;
    Friend_Notification.Show_VAL.Value = true;
end;

function u1.AcceptCurrent() -- Line: 45
    -- upvalues: u3 (ref), u1 (copy), CoreCall (copy)
    local v6 = u3;
    u1.DismissCurrent();

    if v6 then
        CoreCall("SetCore", "PromptSendFriendRequest", v6);
    end;
end;

Network.Fired(Network.NET_MAP.Gifting.FRIEND_REQUEST):Connect(function(p7) -- Line: 53
    -- upvalues: LocalPlayer (copy), u2 (copy), u3 (ref), BodyLabel (copy), Friend_Notification (copy)
    if p7:IsFriendsWith(LocalPlayer.UserId) then
        return;
    end;

    if not table.find(u2, p7) then
        table.insert(u2, p7);
    end;

    if not u3 then
        local v8 = u2[1];
        u3 = v8;
        BodyLabel.Text = `Friend request from\n{v8.Name}`;
        Friend_Notification.Show_VAL.Value = true;
    end;
end);
Accept.MouseButton1Click:Connect(u1.AcceptCurrent);
Decline.MouseButton1Click:Connect(u1.DismissCurrent);

return u1;