-- Decompiled with Potassium's decompiler.

local u1 = {};
local GuildShop = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GuildShop");
local Content = GuildShop:WaitForChild("MainFrame"):WaitForChild("Content");
local CurrentFrame = Content:WaitForChild("CurrentFrame");
local PayoutFrame = Content:WaitForChild("PayoutFrame");
local Prizes = PayoutFrame:WaitForChild("Prizes");
local TemplateFrame = Prizes:WaitForChild("TemplateFrame");
local Prizes2 = CurrentFrame:WaitForChild("Prizes");
local TemplateFrame2 = Prizes2:WaitForChild("TemplateFrame");
local ReplicatedStorage = game.ReplicatedStorage;
local SeedPackData = require(ReplicatedStorage.SharedModules.SeedPackData);
local GearShopData = require(ReplicatedStorage.SharedModules.GearShopData);
local EggData = require(ReplicatedStorage.SharedModules.EggData);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local ServerClock = require(ReplicatedStorage.ClientModules.ServerClock);
local Gradients = ReplicatedStorage.SharedModules.RarityData.Gradients;
local RefreshIn = PayoutFrame:WaitForChild("RefreshIn");
local RefreshIn2 = CurrentFrame:WaitForChild("RefreshIn");

local function abbreviate(p2) -- Line: 44
    local v3 = tonumber(p2);

    if not v3 then
        return tostring(p2);
    end;

    local v4 = { "", "K", "M", "B", "T" };
    local v5 = 1;

    while math.abs(v3) >= 1000 and v5 < #v4 do
        v3 = v3 / 1000;
        v5 = v5 + 1;
    end;

    return string.format("%.3f", v3):gsub("%.?0+$", "") .. v4[v5];
end;

local u6 = 0;
local u7 = false;

function ToggleUpdate(u8)
    -- upvalues: u6 (ref), u7 (ref), u1 (copy)
    task.spawn(function() -- Line: 67
        -- upvalues: u6 (ref), u8 (copy), u7 (ref), u1 (ref)
        u6 = u6 + 1;

        if u8 == true and u7 == false then
            u7 = true;

            while u6 == u6 do
                u1:SetProjectedTimer();
                u1:SetThisWeekTimer();
                task.wait(0.5);
            end;
        end;

        u7 = u8;
    end);
end;

function u1.Init(p9) -- Line: 85
    -- upvalues: u1 (copy), GuildShop (copy)
    u1:SetProjectedPayoutFrame(
        { {
                Name = "Jump Mushroom",
                Cost = 20
            }, {
                Name = "Uncommon Seed Pack",
                Cost = 80
            }, {
                Name = "Legendary Sprinkler",
                Cost = 500
            }, {
                Name = "Super Seed Pack",
                Cost = 4000
            } },
        2,
        1200
    );
    u1:SetLastWeekFrame(
        { {
                Name = "Jump Mushroom",
                Cost = 20
            }, {
                Name = "Uncommon Seed Pack",
                Cost = 80
            }, {
                Name = "Legendary Sprinkler",
                Cost = 500
            }, {
                Name = "Super Seed Pack",
                Cost = 4000
            } },
        1,
        1200
    );

    if GuildShop.Enabled == true then
        ToggleUpdate(true);
    end;

    GuildShop:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 133
        -- upvalues: GuildShop (ref)
        if GuildShop.Enabled == true then
            ToggleUpdate(true);

            return;
        end;

        ToggleUpdate(false);
    end);
end;

local function formatCountdown(p10) -- Line: 149
    local v11 = math.max(p10, 0);
    local v12 = math.floor(v11);
    local v13 = math.floor(v12 / 86400);
    local v14 = math.floor(v12 % 86400 / 3600);
    local v15 = math.floor(v12 % 3600 / 60);

    if v13 > 0 then
        return string.format("%dd %dh", v13, v14);
    end;

    if v14 > 0 then
        return string.format("%dh %dm", v14, v15);
    end;

    return string.format("%dm %ds", v15, v12 % 60);
end;

local function timeUntilFriday(p16) -- Line: 167
    -- upvalues: ServerClock (copy)
    local v17 = ServerClock.Seconds();
    local v18 = os.date("!*t", v17 + -18000);
    local v19 = (6 - v18.wday) % 7 * 86400 + (50400 - (v18.hour * 3600 + v18.min * 60 + v18.sec));

    if v19 <= 0 then
        v19 = v19 + 604800;
    end;

    return v19 + (p16 or 0) * 7 * 86400;
end;

function u1.SetProjectedTimer(p20) -- Line: 190
    -- upvalues: RefreshIn (copy), formatCountdown (copy), timeUntilFriday (copy)
    RefreshIn.Timer.Text = "Opens in: " .. formatCountdown((timeUntilFriday(0)));
end;

function u1.SetThisWeekTimer(p21) -- Line: 194
    -- upvalues: RefreshIn2 (copy), formatCountdown (copy), timeUntilFriday (copy)
    RefreshIn2.Timer.Text = "Expires in: " .. formatCountdown((timeUntilFriday(0)));
end;

function u1.SetProjectedPayoutFrame(p22, p23, p24, p25) -- Line: 198
    -- upvalues: Prizes (copy), PayoutFrame (copy), abbreviate (copy), GearShopData (copy), SeedPackData (copy), EggData (copy), SeedData (copy), TemplateFrame (copy), Worlds (copy), Gradients (copy)
    for _, child in pairs(Prizes:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "TemplateFrame" then
            child:Destroy();
        end;
    end;

    if p25 then
        PayoutFrame.BeanstalkFrame.Amount.Text = abbreviate(p25);
        PayoutFrame.BeanstalkFrame.Amount.TextLabel.Text = PayoutFrame.BeanstalkFrame.Amount.Text;
    end;

    for _, v in pairs(p23) do
        local v26 = nil;
        local v27 = nil;

        for _, v2 in pairs(GearShopData.Data) do
            if v2.ItemName == v.Name then
                v26 = v2.IMG.Value;
                v27 = v2.Rarity;
                break;
            end;
        end;

        if v26 == nil and string.find(v.Name, "Seed Pack") then
            local v28 = SeedPackData.GetData(v.Name);
            v26 = v28.IMG;
            v27 = v28.Rarity;
        end;

        if v26 == nil then
            local v29 = EggData.GetData(v.Name);

            if v29 then
                v26 = v29.IMG;
                v27 = v29.Rarity;
            end;
        end;

        if v26 == nil then
            for _, v2 in pairs(SeedData) do
                if v2.SeedName == v then
                    v26 = v2.SeedImage.Value;
                    v27 = v2.Rarity;
                    break;
                end;
            end;
        end;

        if v26 == nil then
            for _, descendant in pairs(game.ReplicatedStorage.SharedModules:GetDescendants()) do
                if descendant.Name == v.Name and descendant:IsA("StringValue") then
                    v26 = descendant.Value;
                    break;
                end;
            end;
        end;

        if v26 == nil then
            for _, child in pairs(game.ReplicatedStorage.SharedModules.GuildCrateData.GuildCrateImages:GetChildren()) do
                if child.Name == v.Name then
                    v26 = child.Value;
                end;
            end;
        end;

        if v26 ~= nil then
            local _ = v27 == nil;
        end;

        local v30 = TemplateFrame:Clone();

        if v26 then
            v30.Vector.Image = v26;
        end;

        local v31 = abbreviate(v.Cost);
        v30.BuyButton.HolderFrame.TextLabel.TextLabel.Text = v31 .. Worlds.Current.CurrencySuffix;
        v30.BuyButton.HolderFrame.TextLabel.Text = abbreviate(v.Cost) .. Worlds.Current.CurrencySuffix;
        v30.LayoutOrder = tonumber(v.Cost);
        local v32 = Gradients:FindFirstChild(v27);

        if v32 then
            local v33 = v32:Clone();
            v33.Parent = v30;

            if v32.Name == "Super" or v32.Name == "Secret" then
                v33:AddTag("InfiniteGradient");
            end;
        end;

        v30.Parent = Prizes;
        v30.Visible = true;
    end;

    PayoutFrame.Description.Text = "Week " .. tostring(p24);
end;

function u1.SetLastWeekFrame(p34, p35, p36, p37) -- Line: 326
    -- upvalues: Prizes2 (copy), CurrentFrame (copy), abbreviate (copy), GearShopData (copy), SeedPackData (copy), EggData (copy), SeedData (copy), TemplateFrame2 (copy), Worlds (copy), Gradients (copy)
    for _, child in pairs(Prizes2:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "TemplateFrame" then
            child:Destroy();
        end;
    end;

    if p37 then
        CurrentFrame.BeanstalkFrame.Amount.Text = abbreviate(p37);
        CurrentFrame.BeanstalkFrame.Amount.TextLabel.Text = CurrentFrame.BeanstalkFrame.Amount.Text;
    end;

    for _, v in pairs(p35) do
        local v38 = nil;
        local v39 = nil;

        for _, v2 in pairs(GearShopData.Data) do
            if v2.ItemName == v.Name then
                v38 = v2.IMG.Value;
                v39 = v2.Rarity;
                break;
            end;
        end;

        if v38 == nil and string.find(v.Name, "Seed Pack") then
            local v40 = SeedPackData.GetData(v.Name);
            v38 = v40.IMG;
            v39 = v40.Rarity;
        end;

        if v38 == nil then
            local v41 = EggData.GetData(v.Name);

            if v41 then
                v38 = v41.IMG;
                v39 = v41.Rarity;
            end;
        end;

        if v38 == nil then
            for _, v2 in pairs(SeedData) do
                if v2.SeedName == v then
                    v38 = v2.SeedImage.Value;
                    v39 = v2.Rarity;
                    break;
                end;
            end;
        end;

        if v38 == nil then
            for _, descendant in pairs(game.ReplicatedStorage.SharedModules:GetDescendants()) do
                if descendant.Name == v.Name and descendant:IsA("StringValue") then
                    v38 = descendant.Value;
                    break;
                end;
            end;
        end;

        if v38 == nil then
            for _, child in pairs(game.ReplicatedStorage.SharedModules.GuildCrateData.GuildCrateImages:GetChildren()) do
                if child.Name == v.Name then
                    v38 = child.Value;
                end;
            end;
        end;

        if v38 ~= nil then
            local _ = v39 == nil;
        end;

        local v42 = TemplateFrame2:Clone();

        if v38 then
            v42.Vector.Image = v38;
        end;

        local v43 = abbreviate(v.Cost);
        v42.BuyButton.HolderFrame.TextLabel.TextLabel.Text = v43 .. Worlds.Current.CurrencySuffix;
        v42.BuyButton.HolderFrame.TextLabel.Text = abbreviate(v.Cost) .. Worlds.Current.CurrencySuffix;
        v42.LayoutOrder = tonumber(v.Cost);
        local v44 = Gradients:FindFirstChild(v39);

        if v44 then
            local v45 = v44:Clone();
            v45.Parent = v42;

            if v44.Name == "Super" or v44.Name == "Secret" then
                v45:AddTag("InfiniteGradient");
            end;
        end;

        v42.Parent = Prizes2;
        v42.Visible = true;
    end;

    CurrentFrame.Description.Text = "Week " .. tostring(p36);
end;

return u1;