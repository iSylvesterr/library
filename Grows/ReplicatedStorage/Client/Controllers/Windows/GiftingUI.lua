-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Knit = require(game.ReplicatedStorage.Packages.Knit);
local UI_Manager = require(game.ReplicatedStorage.Client.Controllers.UI_Manager);
local CustomEnum = require(game.ReplicatedStorage.Shared.Info.CustomEnum);
require(game.ReplicatedStorage.Shared.Utility.ItemHelperFunctions);
local PlayerIconCache = require(game.ReplicatedStorage.Client.Modules.Info.PlayerIconCache);
local v1 = Knit.CreateController({
    Name = "GiftingUI"
});
local Maid = require(game.ReplicatedStorage.Packages.Maid);
local PlayerGui = game.Players.LocalPlayer.PlayerGui;
local Gifting = PlayerGui:WaitForChild("Windows"):WaitForChild("Gifting");
local Shop = PlayerGui:WaitForChild("WindowsLocalZ"):WaitForChild("Shop");
local Top = Gifting:WaitForChild("Top");
local Exit = Top:WaitForChild("Exit");
local Title = Top:WaitForChild("Title");
local ItemHolder = Gifting:WaitForChild("ScrollHolder"):WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder");
local Template = ItemHolder:WaitForChild("Template");
Template.Parent = script;
local u2 = -1;
local u3 = nil;
local u4 = {};
local u5 = RunService:IsStudio();
local u6 = false;

function v1.update(u7) -- Line: 49
    -- upvalues: u6 (ref), u4 (copy), u5 (copy), Maid (copy), Template (copy), ItemHolder (copy), UI_Manager (copy), PlayerIconCache (copy), Gifting (copy), u2 (ref), CustomEnum (copy), u3 (ref), Title (copy)
    if u6 then
        return;
    end;

    u6 = true;

    for _, v in u4 do
        v.maid:Destroy();
    end;

    local v8 = {};

    for _, v in game.Players:GetPlayers() do
        table.insert(v8, v);
    end;

    for i, v in v8 do
        if u5 or v.Name ~= game.Players.LocalPlayer.Name then
            if not u4[i] then
                u4[i] = {};
                u4[i].maid = Maid.new();
                u4[i].icon = Template:Clone();
                u4[i].icon.Parent = ItemHolder;
                UI_Manager:AddBounceButton(u4[i].icon.Button, 1.03);
            end;

            u4[i].maid:GiveTask(function() -- Line: 73
                -- upvalues: UI_Manager (ref), u4 (ref), i (copy)
                UI_Manager:RemoveBounceButton(u4[i].icon.Button);

                if u4[i].icon then
                    u4[i].icon:Destroy();
                end;

                u4[i] = nil;
            end);
            local u9 = true;
            local u10 = task.spawn(function() -- Line: 80
                -- upvalues: u4 (ref), i (copy), PlayerIconCache (ref), v (copy), u9 (ref)
                u4[i].icon.Button.TextLabel.Text = PlayerIconCache:FetchDisplayName(v.UserId);
                u9 = false;
            end);
            local u11 = true;
            local u12 = task.spawn(function() -- Line: 85
                -- upvalues: u4 (ref), i (copy), PlayerIconCache (ref), v (copy), u11 (ref)
                u4[i].icon.Button.ImageLabel.Image = PlayerIconCache:FetchIcon(v.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size180x180);
                u11 = false;
            end);
            u4[i].maid:GiveTask(function() -- Line: 90
                -- upvalues: u9 (ref), u10 (copy), u11 (ref), u12 (copy)
                if u9 then
                    task.cancel(u10);
                end;

                if u11 then
                    task.cancel(u12);
                end;
            end);
            u4[i].maid:GiveTask(u4[i].icon.Button.Activated:Connect(function() -- Line: 95
                -- upvalues: UI_Manager (ref), Gifting (ref), u2 (ref), CustomEnum (ref), u7 (copy), u3 (ref), v (copy)
                UI_Manager:CloseWindow(Gifting, true);

                if u2 == CustomEnum.GIFT_TYPES.TICKETS then
                    u7.FarmersMarketService.purchaseTickets:Fire(u3.productName, v.UserId);

                    return;
                end;

                if u2 ~= CustomEnum.GIFT_TYPES.BUNDLE then
                    warn("INVALID GIFT TYPE!! " .. tostring(u2));

                    return;
                end;

                UI_Manager:CloseWindow(Gifting, true);
                u7.BundlesService.attemptBuyBundle:Fire(u3.bundleID, v.UserId);
            end));
        end;
    end;

    if u2 == CustomEnum.GIFT_TYPES.TICKETS then
        Title.Text = "GIFT " .. u3.amt .. " TICKETS";
    elseif u2 == CustomEnum.GIFT_TYPES.BUNDLE then
        if u3.bundleID == CustomEnum.BUNDLES.EMOTES then
            Title.Text = "GIFT EMOTES";
        end;
    else
        Title.Text = "GIFT ITEM";
    end;

    u6 = false;
end;

function v1.OpenGiftingUI(p13, p14, p15) -- Line: 129
    -- upvalues: u2 (ref), u3 (ref), UI_Manager (copy), Gifting (copy)
    u2 = p14;
    u3 = p15;
    UI_Manager:OpenWindow(Gifting, true);
end;

function v1.KnitStart(u16) -- Line: 136
    -- upvalues: UI_Manager (copy), Exit (copy), Shop (copy), Gifting (copy)
    UI_Manager:AddBounceButton(Exit, 1.2);
    Exit.Activated:Connect(function() -- Line: 139
        -- upvalues: UI_Manager (ref), Shop (ref)
        UI_Manager:OpenWindow(Shop, true);
    end);
    Gifting:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 144
        -- upvalues: Gifting (ref), u16 (copy)
        if Gifting.Visible then
            u16:update();
        end;
    end);
    game.Players.PlayerAdded:Connect(function(p17) -- Line: 148
        -- upvalues: Gifting (ref), u16 (copy)
        if Gifting.Visible then
            u16:update();
        end;
    end);
    game.Players.PlayerRemoving:Connect(function(p18) -- Line: 152
        -- upvalues: Gifting (ref), u16 (copy)
        if Gifting.Visible then
            u16:update();
        end;
    end);
end;

function v1.KnitInit(p19) -- Line: 157
    -- upvalues: Knit (copy)
    p19.DataClient = Knit.GetController("DataClient");
    p19.CurrencyService = Knit.GetService("CurrencyService");
    p19.FarmersMarketService = Knit.GetService("FarmersMarketService");
    p19.BundlesService = Knit.GetService("BundlesService");
end;

return v1;