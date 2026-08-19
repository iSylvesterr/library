-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextChatService = game:GetService("TextChatService");
local Players = game:GetService("Players");
local Knit = require(ReplicatedStorage.Packages.Knit);
require(ReplicatedStorage.Packages.Signal);
require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("CustomEnum"));
local _ = Players.LocalPlayer;
local v1 = Knit.CreateController({
    Name = "ChatController"
});

function v1.KnitStart(p2) -- Line: 17
    -- upvalues: TextChatService (copy), Players (copy)
    function TextChatService.OnIncomingMessage(p3) -- Line: 19
        -- upvalues: Players (ref)
        if string.sub(p3.Text, 1, 1) == "!" then
            local TextChatMessageProperties = Instance.new("TextChatMessageProperties");
            TextChatMessageProperties.Text = " ";

            return TextChatMessageProperties;
        end;

        local v4 = Players:GetPlayerByUserId(p3.TextSource.UserId or 0);

        if v4 then
            if v4:GetAttribute("VIP") then
                p3.PrefixText = string.format("<font color=\'rgb(255, 200, 0)\'>%s</font>", "[VIP] " .. v4.DisplayName);

                return;
            end;

            p3.PrefixText = string.format("<font color=\'rgb(180, 180, 180)\'>%s</font>", v4.DisplayName);
        end;
    end;
end;

function v1.KnitInit(p5) -- Line: 38
    -- upvalues: Knit (copy)
    p5.DataClient = Knit.GetController("DataClient");
end;

return v1;