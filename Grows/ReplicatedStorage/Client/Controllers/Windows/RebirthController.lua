-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local RebirthConfig = require(ReplicatedStorage.Shared.Info.RebirthConfig);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local AbbreviateNumber = require(ReplicatedStorage.Shared.Utility.AbbreviateNumber);
local Products = require(ReplicatedStorage.Shared.Info.Products);
local u1 = Color3.fromRGB(0, 255, 0);
local u2 = Color3.fromRGB(125, 125, 125);
local u3 = {
    [1] = true,
    [3] = true,
    [5] = true
};
local v4 = Knit.CreateController({
    Name = "RebirthController"
});

function v4.KnitStart(p5) -- Line: 47
    -- upvalues: Maid (copy), Players (copy), Knit (copy), CustomEnum (copy), RebirthConfig (copy), Products (copy), u3 (copy), AbbreviateNumber (copy), u1 (copy), u2 (copy)
    local v6 = Maid.new();
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local u7 = Knit.GetService("RebirthService");
    local u8 = Knit.GetService("PurchaseManager");
    local UI_Manager = p5.UI_Manager;
    local DataClient = p5.DataClient;
    local Button = PlayerGui:WaitForChild("HUD").SideMenus.Left.Buttons.Rebirth:WaitForChild("Button");
    local Notif = Button:WaitForChild("Notif");
    local Rebirth = PlayerGui:WaitForChild("Windows"):WaitForChild("Rebirth");
    local Exit = Rebirth.Top.Exit;
    local Rewards = Rebirth.Content.Upgrades.Rewards;
    local SpeedUpgrade = Rebirth.Content.Upgrades.SpeedUpgrade;
    local FertilizerReward = Rebirth.Content.Upgrades.SpeedUpgrade.FertilizerReward;
    local Frame = FertilizerReward.Frame;
    local u9 = FertilizerReward:Clone();
    u9.Name = "PlotExpansionReward";
    u9.LayoutOrder = 1;
    u9.Frame.TextLabel.Text = "Plot Upgrade";
    u9.Frame.ImageLabel.Image = "rbxassetid://71013731388095";
    u9.Visible = false;
    u9.Parent = FertilizerReward.Parent;
    local u10 = FertilizerReward:Clone();
    u10.Name = "FarmersMarketReward";
    u10.LayoutOrder = 2;
    u10.Frame.TextLabel.Text = "Farmer\'s Market";
    u10.Frame.ImageLabel.Image = "rbxassetid://92650717269997";
    u10.Visible = false;
    u10.Parent = FertilizerReward.Parent;
    local u11 = FertilizerReward:Clone();
    u11.Name = "PetShopReward";
    u11.LayoutOrder = 3;
    u11.Frame.TextLabel.Text = "Pet Shop";
    u11.Frame.ImageLabel.Image = "rbxassetid://104195641365354";
    u11.Visible = false;
    u11.Parent = FertilizerReward.Parent;
    local u12 = FertilizerReward:Clone();
    u12.Name = "DecorShopReward";
    u12.LayoutOrder = 4;
    u12.Frame.TextLabel.Text = "Furniture Shop";
    u12.Frame.ImageLabel.Image = "rbxassetid://84913696110308";
    u12.Visible = false;
    u12.Parent = FertilizerReward.Parent;
    local Requirements = Rebirth.Content.Requirements;
    local MoneyBar = Requirements.MoneyBar;
    local Fill = MoneyBar.Fill;
    local Amount = MoneyBar.WoodDisplay.Amount;
    local Buttons = Rebirth.Content.Buttons;
    local Button2 = Buttons.Unlock.Button;
    local Button3 = Buttons.SkipRebirth.Button;
    local Warning = Rebirth.Content:FindFirstChild("Warning");
    local Fertilizers = PlayerGui.Windows:WaitForChild("FertilizerSelect").Content:WaitForChild("Fertilizers");
    Button2.AutoButtonColor = false;
    Button3.AutoButtonColor = false;

    local function getFertilizerIcon(p13) -- Line: 118
        -- upvalues: Fertilizers (copy)
        local v14 = Fertilizers:FindFirstChild(p13);

        if v14 then
            v14 = v14:FindFirstChild("Button");
        end;

        if v14 then
            v14 = v14:FindFirstChild("ImageLabel");
        end;

        return v14 and v14.Image or nil;
    end;

    local function refresh() -- Line: 125
        -- upvalues: DataClient (copy), CustomEnum (ref), RebirthConfig (ref), Rewards (copy), SpeedUpgrade (copy), u9 (copy), u10 (copy), u11 (copy), u12 (copy), Requirements (copy), Buttons (copy), Warning (copy), Notif (copy), UI_Manager (copy), Products (ref), Frame (copy), Fertilizers (copy), u3 (ref), Fill (copy), Amount (copy), AbbreviateNumber (ref), Button2 (copy), u1 (ref), u2 (ref)
        local currentData = DataClient.currentData;

        if not currentData then
            return;
        end;

        local v15 = currentData.Currency and (currentData.Currency[CustomEnum.CURRENCIES.COINS] or 0) or 0;
        local v16 = RebirthConfig.GetNext(currentData.Rebirth or 0);

        if not v16 then
            Rewards.Text = "MAX LEVEL REACHED";
            SpeedUpgrade.Visible = false;
            u9.Visible = false;
            u10.Visible = false;
            u11.Visible = false;
            u12.Visible = false;
            Requirements.Visible = false;
            Buttons.Visible = false;

            if Warning then
                Warning.Visible = false;
            end;

            Notif.Visible = false;
            UI_Manager:RemovePulseV2(Notif);

            return;
        end;

        Rewards.Text = string.format("Rebirth %d Unlocks:", v16.level);
        SpeedUpgrade.Visible = true;
        Requirements.Visible = true;
        Buttons.Visible = true;
        Buttons.SkipRebirth.Visible = Products["SkipRebirth" .. v16.level] ~= nil;

        if Warning then
            Warning.Visible = true;
        end;

        Frame.TextLabel.Text = v16.fertilizer.displayName .. " Fertilizer";
        local v17 = Fertilizers:FindFirstChild(v16.fertilizerKey);

        if v17 then
            v17 = v17:FindFirstChild("Button");
        end;

        if v17 then
            v17 = v17:FindFirstChild("ImageLabel");
        end;

        local v18 = v17 and v17.Image or nil;

        if v18 then
            Frame.ImageLabel.Image = v18;
        end;

        u9.Visible = u3[v16.level] == true;
        u10.Visible = v16.level == 2;
        u11.Visible = v16.level == 2;
        u12.Visible = v16.level == 4;
        local cost = v16.cost;
        local v19 = math.clamp(v15 / cost, 0, 1);
        Fill.Size = UDim2.new(v19, 0, 1, 0);
        Amount.Text = "$" .. AbbreviateNumber(v15) .. " / $" .. AbbreviateNumber(cost);
        local v20 = cost <= v15;
        Button2.BackgroundColor3 = v20 and u1 or u2;
        Button2.TextLabel.Text = "REBIRTH";
        Notif.Visible = v20;

        if v20 then
            UI_Manager:AddPulseV2(Notif, 1.7, 2, {
                zIndex = 10,
                color = Color3.new(1, 1, 1)
            });

            return;
        end;

        UI_Manager:RemovePulseV2(Notif);
    end;

    UI_Manager:AddBounceButton(Button, 1.05, false);
    UI_Manager:AddBounceButton(Button2, 1.05, false);
    UI_Manager:AddBounceButton(Button3, 1.05, false);
    UI_Manager:AddBounceButton(Exit, 1.05, true);
    UI_Manager:SetupRainbowShinyGradient(Button3.UIGradient, 0.5);
    v6:GiveTask(Button.Activated:Connect(function() -- Line: 191
        -- upvalues: UI_Manager (copy), Rebirth (copy), refresh (copy)
        UI_Manager:ToggleWindow(Rebirth, true);
        refresh();
    end));
    v6:GiveTask(Exit.Activated:Connect(function() -- Line: 196
        -- upvalues: UI_Manager (copy), Rebirth (copy)
        UI_Manager:CloseWindow(Rebirth, true);
    end));
    v6:GiveTask(Button2.Activated:Connect(function() -- Line: 200
        -- upvalues: DataClient (copy), RebirthConfig (ref), CustomEnum (ref), u7 (copy)
        local currentData = DataClient.currentData;

        if not currentData then
            return;
        end;

        local v21 = RebirthConfig.GetNext(currentData.Rebirth or 0);

        if not v21 then
            return;
        end;

        if (currentData.Currency and currentData.Currency[CustomEnum.CURRENCIES.COINS] or 0) < v21.cost then
            return;
        end;

        u7:DoRebirth();
    end));
    v6:GiveTask(Button3.Activated:Connect(function() -- Line: 210
        -- upvalues: DataClient (copy), RebirthConfig (ref), Products (ref), u8 (copy)
        local currentData = DataClient.currentData;

        if not currentData then
            return;
        end;

        local v22 = RebirthConfig.GetNext(currentData.Rebirth or 0);

        if not v22 then
            return;
        end;

        local v23 = "SkipRebirth" .. v22.level;

        if not Products[v23] then
            return;
        end;

        u8.PromptProductPurchase:Fire(v23);
    end));
    v6:GiveTask(DataClient.EV_UPDATE:Connect(refresh));
    DataClient.EV_FIRST_UPDATE:Once(refresh);

    if DataClient:GetLoaded() then
        refresh();
    end;

    p5._maid = v6;
end;

function v4.KnitInit(p24) -- Line: 227
    -- upvalues: Knit (copy)
    p24.UI_Manager = Knit.GetController("UI_Manager");
    p24.DataClient = Knit.GetController("DataClient");
end;

return v4;