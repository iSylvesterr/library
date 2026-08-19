-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local MarketplaceService = game:GetService("MarketplaceService");
local Player = require(ReplicatedStorage.Library.Player);
local GIF2 = require(ReplicatedStorage.Library.Client.GUIFX.GIF2);
local Functions = require(ReplicatedStorage.Library.Functions);
local Signal = require(ReplicatedStorage.Library.Signal);
local Network = require(ReplicatedStorage.Library.Client.Network);
local u1 = Player.PlayerGui();
local u2 = false;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function showPurchasePending() -- Line: 17
    -- upvalues: u2 (ref), u5 (ref), u3 (ref), GIF2 (copy), u4 (ref), Lighting (copy), u1 (copy), Functions (copy)
    if u2 then
        return;
    end;

    u2 = true;
    local v6 = script:FindFirstChild("Purchase Pending"):Clone();
    u5 = v6;
    u3 = GIF2.Create(v6.Frame.GIF, { 100, 100 }, { 5, 6 }, 28, 0.65, true);
    local BlurEffect = Instance.new("BlurEffect");
    u4 = BlurEffect;
    BlurEffect.Size = 0;
    BlurEffect.Name = "PurchasePendingBlur";
    BlurEffect.Parent = Lighting;
    v6.Frame.BackgroundTransparency = 1;
    v6.Parent = u1;
    Functions.Tween(BlurEffect, {
        Size = 20
    }, { 0.25, "Sine", "Out" });
    Functions.Tween(v6.Frame, {
        BackgroundTransparency = 0.5
    }, { 0.2, "Expo", "Out" });
    Functions.Tween(v6.Frame.GIF, {
        ImageTransparency = 0
    }, { 0.2, "Expo", "Out" });
end;

local function closePurchasePending() -- Line: 37
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), Functions (copy)
    if not u2 then
        return;
    end;

    u2 = false;
    local v7 = u3;
    local u8 = u4;
    local u9 = u5;
    u3 = nil;
    u5 = nil;
    u4 = nil;

    if v7 then
        v7();
    end;

    if u9 then
        Functions.Tween(u9.Frame.GIF, {
            ImageTransparency = 1
        }, { 0.3, "Expo", "Out" });
        Functions.Tween(u9.Frame, {
            BackgroundTransparency = 1
        }, { 0.3, "Expo", "Out" }).Completed:Connect(function() -- Line: 54
            -- upvalues: u9 (copy)
            u9:Destroy();
        end);
    end;

    if u8 then
        Functions.Tween(u8, {
            Size = 0
        }, { 0.2, "Expo", "Out" }).Completed:Connect(function() -- Line: 59
            -- upvalues: u8 (copy)
            u8:Destroy();
        end);
    end;
end;

Signal.Fired("Prompting Purchase"):Connect(showPurchasePending);
Network.Fired("Prompting Purchase"):Connect(showPurchasePending);
MarketplaceService.PromptGamePassPurchaseFinished:Connect(closePurchasePending);
MarketplaceService.PromptProductPurchaseFinished:Connect(closePurchasePending);
MarketplaceService.PromptPurchaseFinished:Connect(closePurchasePending);
MarketplaceService.PromptPremiumPurchaseFinished:Connect(closePurchasePending);

return {};