-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GUI = require(ReplicatedStorage.Library.Client.GUI);
require(ReplicatedStorage.Library.Types.GUI);
local Player = require(ReplicatedStorage.Library.Player);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local v1 = GUI.Money();
local Money = v1.Bottom.Frame.Money;
local FriendBoost = v1.Bottom.Frame.FriendBoost;
local TopBar = GUI.OfflineMoneyInPlot().TopBar;
local u2 = GUI.TopBarStandard();
local u3 = GUI.Backpack();
local v4 = GUI.SideButtons();
local Tools = v4.Left.Tools;
local TreadmillSpeedShop = Tools.TreadmillSpeedShop;
local DoubleYourSpeed = Tools.DoubleYourSpeed;
local Right = v4.Right;
local Tabs = v4.Tabs;
local u5 = {};

for _, child in ipairs(Tools:GetChildren()) do
    if child:IsA("GuiObject") then
        u5[#u5 + 1] = child;
    elseif child:IsA("Folder") then
        for _, child2 in ipairs(child:GetChildren()) do
            if child2:IsA("GuiObject") then
                u5[#u5 + 1] = child2;
            end;
        end;
    end;
end;

local u6 = nil;

return {
    Apply = function(p7) -- Line: 67, Name: Apply
        -- upvalues: u6 (ref), u5 (copy), u3 (copy), FriendBoost (copy), Money (copy), Right (copy), Tabs (copy), TopBar (copy), u2 (copy), TreadmillSpeedShop (copy), DoubleYourSpeed (copy), Player (copy), TabController (copy)
        if not p7 then
            if TabController.IsOpen("TreadmillSpeedShop") then
                TabController.CloseTab();
            end;

            local v8 = u6;

            if v8 == nil then
                return;
            end;

            u2.Enabled = v8.TopBarEnabled;
            TopBar.Visible = v8.OfflineMoneyInPlotVisible;
            u3.Enabled = v8.BackpackEnabled;
            Money.Visible = v8.MoneyVisible;
            FriendBoost.Visible = v8.FriendBoostVisible;
            Right.Visible = v8.SideButtonsGuiRightVisible;

            for i, v in pairs(v8.ToolVisibility) do
                if i.Parent ~= nil then
                    i.Visible = v;
                end;
            end;

            u6 = nil;

            return;
        end;

        if u6 == nil then
            local v9 = {};

            for _, v in ipairs(u5) do
                v9[v] = v.Visible;
            end;

            u6 = {
                BackpackEnabled = u3.Enabled,
                FriendBoostVisible = FriendBoost.Visible,
                MoneyVisible = Money.Visible,
                SideButtonsGuiRightVisible = Right.Visible,
                SideButtonTabsVisible = Tabs.Visible,
                ToolVisibility = v9,
                OfflineMoneyInPlotVisible = TopBar.Visible,
                TopBarEnabled = u2.Enabled
            };
        end;

        u3.Enabled = false;
        Right.Visible = false;
        Money.Visible = false;
        FriendBoost.Visible = false;
        TopBar.Visible = false;
        u2.Enabled = false;
        local v10 = u6;
        assert(v10 ~= nil, "Expected treadmill UI visibility state");

        for i in pairs(v10.ToolVisibility) do
            i.Visible = false;
        end;

        TreadmillSpeedShop.Visible = true;
        DoubleYourSpeed.Visible = true;
        local v11 = Player.Optional.Humanoid();

        if v11 ~= nil then
            v11:UnequipTools();
        end;
    end
};