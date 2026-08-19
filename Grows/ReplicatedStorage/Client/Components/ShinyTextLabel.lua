-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Component = require(ReplicatedStorage.Packages.Component);
local Maid = require(ReplicatedStorage.Packages.Maid);
local ExpandedRarities = require(ReplicatedStorage.Shared.Info.ExpandedRarities);
local UI_Manager = require(ReplicatedStorage.Client.Controllers.UI_Manager);
local v1 = Component.new({
    Tag = "ShinyTextLabel"
});

function v1.Start(u2) -- Line: 17
    -- upvalues: Knit (copy), Maid (copy), UI_Manager (copy), ExpandedRarities (copy)
    Knit.OnStart():await();
    u2._maid = Maid.new();
    local v3 = u2.Instance:GetAttribute("rarity");
    local v4 = v3 == "CELESTIAL";
    local v5 = v3 == "SECRET";
    local v6 = v3 == "DIVINE";
    local v7 = v3 == "CHARGED";
    local v8 = v3 == "ANCIENT";
    local v9 = v3 == "TRANSCENDENT";

    if v4 or (v5 or (v6 or (v7 or (v8 or v9)))) then
        u2.Instance.TextColor3 = Color3.new(1, 1, 1);
        u2.uiGradient = Instance.new("UIGradient", u2.Instance);

        if v4 then
            UI_Manager:SetupShinyGradient(u2.uiGradient, UI_Manager.GRADIENTS.CELESTIAL);
        elseif v5 then
            UI_Manager:SetupShinyGradient(u2.uiGradient, UI_Manager.GRADIENTS.SECRET);
        elseif v6 then
            UI_Manager:SetupShinyGradient(u2.uiGradient, UI_Manager.GRADIENTS.DIVINE);
        elseif v7 then
            UI_Manager:SetupShinyGradient(u2.uiGradient, UI_Manager.GRADIENTS.CHARGED);
        elseif v8 then
            UI_Manager:SetupRainbowShinyGradient(u2.uiGradient, 1, UI_Manager.GRADIENTS.ANCIENT);
        elseif v9 then
            UI_Manager:SetupRainbowShinyGradient(u2.uiGradient, 1, UI_Manager.GRADIENTS.TRANSCENDENT);
        end;
    else
        local v10 = ExpandedRarities[v3];

        if v10 then
            u2.Instance.TextColor3 = v10.mainColor;
        end;
    end;

    u2._maid:GiveTask(function() -- Line: 56
        -- upvalues: u2 (copy), UI_Manager (ref)
        if u2.uiGradient then
            UI_Manager:RemoveShinyGradient(u2.uiGradient);
        end;
    end);
end;

function v1.Stop(p11) -- Line: 64
    if p11._maid then
        p11._maid:Destroy();
    end;
end;

return v1;