-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = require("@game/ReplicatedStorage/SharedModules/Networking");
local LocalPlayer = Players.LocalPlayer;
local Gifting = LocalPlayer.PlayerGui:WaitForChild("Gifting");
local Notification = Gifting:WaitForChild("Notification");
local u2 = {
    Crate = "Crates",
    Gnome = "Gnomes",
    Mushroom = "Mushrooms",
    Sprinkler = "Sprinklers",
    WateringCan = "WateringCans",
    HarvestedFruit = "HarvestedFruits",
    SeedTool = "Seeds"
};
local v3 = {};
local u4 = nil;
local u5 = {};
local u6 = nil;
local u7 = {};

function v3._createPrompt(p8, u9, p10) -- Line: 37
    -- upvalues: u4 (ref), u1 (copy), u5 (copy)
    local function attach(p11) -- Line: 38
        -- upvalues: u4 (ref), u1 (ref), u9 (copy), u5 (ref)
        if p11.Name ~= "HumanoidRootPart" then
            return;
        end;

        if p11:FindFirstChild("Gift") then
            return;
        end;

        local ProximityPrompt = Instance.new("ProximityPrompt");
        ProximityPrompt.ClickablePrompt = true;
        ProximityPrompt.Name = "Gift";
        ProximityPrompt.HoldDuration = 0.5;
        ProximityPrompt.MaxActivationDistance = 10;
        ProximityPrompt.RequiresLineOfSight = false;
        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
        ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.G;
        ProximityPrompt.ActionText = "Gift";
        ProximityPrompt.Enabled = u4 ~= nil;
        ProximityPrompt.Triggered:Connect(function() -- Line: 60
            -- upvalues: u4 (ref), u1 (ref), u9 (ref)
            if not u4 then
                return;
            end;

            u1.Gifting.Send:Fire(u9.UserId, u4.type, u4.uuid);
        end);
        ProximityPrompt.Destroying:Connect(function() -- Line: 68
            -- upvalues: u5 (ref), ProximityPrompt (copy)
            local v12 = table.find(u5, ProximityPrompt);

            if v12 then
                table.remove(u5, v12);
            end;
        end);
        ProximityPrompt.Parent = p11;
        table.insert(u5, ProximityPrompt);
    end;

    local HumanoidRootPart = p10:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        attach(HumanoidRootPart);
    end;

    p10.ChildAdded:Connect(attach);
end;

function v3._updateEquippedTool(p13, p14) -- Line: 88
    -- upvalues: u2 (copy), u4 (ref), u5 (copy)
    local v15 = p14:FindFirstChildWhichIsA("Tool");
    local v16 = nil;

    if v15 then
        for i, v in u2 do
            local v17 = v15:GetAttribute(i);

            if v17 then
                local v18 = v15:GetAttribute("Id");

                if type(v18) == "string" then
                    v17 = v18;
                elseif type(v17) ~= "string" then
                    v17 = v15.Name;
                end;

                v16 = {
                    type = v,
                    uuid = v17
                };
                break;
            end;
        end;
    end;

    u4 = v16;

    for _, v in u5 do
        v.Enabled = v16 ~= nil;
    end;
end;

function v3._watchPlayer(u19, u20) -- Line: 118
    -- upvalues: LocalPlayer (copy)
    if u20 == LocalPlayer then
        return;
    end;

    u20.CharacterAdded:Connect(function(p21) -- Line: 123
        -- upvalues: u19 (copy), u20 (copy)
        u19:_createPrompt(u20, p21);
    end);

    if u20.Character then
        u19:_createPrompt(u20, u20.Character);
    end;
end;

function v3._watchLocalPlayer(u22, u23) -- Line: 132
    u22:_updateEquippedTool(u23);
    u23.ChildAdded:Connect(function() -- Line: 135
        -- upvalues: u22 (copy), u23 (copy)
        u22:_updateEquippedTool(u23);
    end);
    u23.ChildRemoved:Connect(function() -- Line: 139
        -- upvalues: u22 (copy), u23 (copy)
        u22:_updateEquippedTool(u23);
    end);
end;

function v3._dismissGift(p24, p25) -- Line: 144
    -- upvalues: u6 (ref), u1 (copy), u7 (copy), Gifting (copy)
    if not u6 then
        return;
    end;

    if p25 then
        u1.Gifting.Response:Fire(u6.player, false);
    end;

    u6 = nil;

    if next(u7) then
        p24:_showNextGift();

        return;
    end;

    Gifting.Enabled = false;
end;

function v3._showNextGift(u26) -- Line: 162
    -- upvalues: u6 (ref), u7 (copy), Players (copy), Notification (copy), Gifting (copy)
    if u6 then
        return;
    end;

    local u27 = table.remove(u7, 1);

    if not u27 then
        return;
    end;

    if not (u27.player and u27.player:IsDescendantOf(Players)) then
        u26:_showNextGift();

        return;
    end;

    u6 = u27;
    task.delay(30, function() -- Line: 181
        -- upvalues: u6 (ref), u27 (copy), u26 (copy)
        if u6 == u27 then
            u26:_dismissGift(true);
        end;
    end);
    Notification.TextLabel.Text = `@{u27.player.Name} gifted:`;
    Notification.Reward.Text = u27.itemName;
    Notification.Reward.TextLabel.Text = u27.itemName;
    Gifting.Enabled = true;
end;

function v3.Init(u28) -- Line: 194
    -- upvalues: u1 (copy), u7 (copy), u6 (ref)
    u1.Gifting.Prompted.OnClientEvent:Connect(function(p29, p30) -- Line: 195
        -- upvalues: u7 (ref), u6 (ref), u28 (copy)
        table.insert(u7, {
            player = p29,
            itemName = p30
        });

        if not u6 then
            u28:_showNextGift();
        end;
    end);
end;

function v3.Start(u31) -- Line: 204
    -- upvalues: LocalPlayer (copy), Players (copy), Notification (copy), u6 (ref), u1 (copy)
    if LocalPlayer.Character then
        u31:_watchLocalPlayer(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p32) -- Line: 209
        -- upvalues: u31 (copy)
        u31:_watchLocalPlayer(p32);
    end);

    for _, v in Players:GetPlayers() do
        u31:_watchPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p33) -- Line: 217
        -- upvalues: u31 (copy)
        u31:_watchPlayer(p33);
    end);
    Notification.Buttons.AcceptButton.Activated:Connect(function() -- Line: 221
        -- upvalues: u6 (ref), u1 (ref), u31 (copy)
        if not u6 then
            return;
        end;

        u1.Gifting.Response:Fire(u6.player, true);
        u31:_dismissGift(false);
    end);
    Notification.Buttons.DeclineButton.Activated:Connect(function() -- Line: 230
        -- upvalues: u31 (copy)
        u31:_dismissGift(true);
    end);
end;

return v3;