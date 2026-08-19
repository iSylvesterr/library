-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 3
};
local Players = game:GetService("Players");
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Signal = require(ReplicatedStorage.ClientModules.Signal);
local MessagePrompt = require(ReplicatedStorage.ClientModules.MessagePrompt);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local DevProducts = require(ReplicatedStorage.SharedModules.DevProducts);
local Environment = require(ReplicatedStorage.SharedModules.Environment);
local PlayerStateClient = require(ReplicatedStorage.ClientModules.PlayerStateClient);
local MarketplaceServiceHelper = require(ReplicatedStorage.UserGenerated.Roblox.MarketplaceServiceHelper);
local LocalPlayer = Players.LocalPlayer;
local u2 = Environment.env == "Dev" and true or RunService:IsStudio();

local function debugPrint(p3) -- Line: 21
    -- upvalues: u2 (copy)
    if u2 then
        print(p3);
    end;
end;

local u4 = Signal.new();
local u5 = Signal.new();
local u6 = Signal.new();
local u7 = Signal.new();
v1.PurchaseStartedSignal = u4;
v1.PurchaseCancelledSignal = u5;
v1.PurchaseCompleteSignal = u6;
v1.PurchaseFailedSignal = u7;
v1.PurchaseStarted = u4;
v1.PurchaseCancelled = u5;
v1.PurchaseComplete = u6;
v1.PurchaseFailed = u7;
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = false;
local u12 = false;

local function isInstantPurchasesEnabled() -- Line: 50
    -- upvalues: Environment (copy)
    local v13 = workspace:GetAttribute("InstantPurchasesEnabled");

    if type(v13) == "boolean" then
        return v13;
    end;

    return Environment.config.InstantPurchases;
end;

local function setEnabled(p14, p15) -- Line: 58
    if p14:IsA("ScreenGui") then
        p14.Enabled = p15;

        return;
    end;

    if p14:IsA("LayerCollector") then
        p14.Enabled = p15;

        return;
    end;

    if p14:IsA("GuiObject") then
        p14.Visible = p15;
    end;
end;

local function setText(p16, p17) -- Line: 68
    if not p16 then
        return;
    end;

    if p16:IsA("TextLabel") or (p16:IsA("TextButton") or p16:IsA("TextBox")) then
        p16.Text = p17;
    end;
end;

local function setImage(p18, p19) -- Line: 75
    if not p18 then
        return;
    end;

    if p18:IsA("ImageLabel") or p18:IsA("ImageButton") then
        p18.Image = p19;
    end;
end;

local function getPromptChoice(p20, p21) -- Line: 82
    -- upvalues: LocalPlayer (copy), u10 (copy), MarketplaceServiceHelper (copy)
    local v22 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v22 then
        return nil;
    end;

    local PreRobuxPrompt = v22:FindFirstChild("PreRobuxPrompt");

    if not PreRobuxPrompt then
        return nil;
    end;

    local v23 = u10[p21];
    local v24;

    if v23 then
        v24 = v23;
    else
        local v25;
        v25, v24 = pcall(MarketplaceServiceHelper.GetInfoAsync, p21, Enum.InfoType.Product);

        if v25 and v24 then
            u10[p21] = v24;
        else
            v24 = v23;
        end;
    end;

    local v26;

    if v24 then
        v26 = v24.Name;
    else
        v26 = v24;
    end;

    local v27;

    if v24 then
        v27 = v24.PriceInRobux;
    else
        v27 = v24;
    end;

    local v28;

    if v24 then
        v28 = v24.Image;
    else
        v28 = v24;
    end;

    if v24 then
        v24 = v24.IconImageAssetId;
    end;

    if type(v28) ~= "string" or v28 == "" then
        if type(v24) == "number" then
            v28 = "rbxassetid://" .. tostring(v24);
        else
            v28 = "https://www.roblox.com/thumbs/asset.ashx?assetid=" .. tostring(p21) .. "&x=100&y=100&format=png";
        end;
    end;

    local v29 = type(v27) ~= "number" and "<font family=\"rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json\" weight=\"400\">robux</font> ?" or `<font family="rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json" weight="400">robux</font> {v27}`;

    if type(v26) ~= "string" or v26 == "" then
        v26 = p20;
    end;

    local function descend(p30, p31) -- Line: 116
        for _, v in ipairs(p31) do
            p30 = p30:FindFirstChild(v);

            if not p30 then
                return nil;
            end;
        end;

        return p30;
    end;

    local v32 = descend(PreRobuxPrompt, { "ProductPurchaseModal", "SheetContainer", "Sheet", "Content", "Content", "ScrollingFrame", "ScrollingFrame", "SheetContentContainer", "ProductDetailsContainer", "ProductDetails" });

    if v32 then
        local v33 = descend(v32, { "ItemDetailsFrame", "ItemDetailsFrame", "ItemName" });
        local ItemIcon = v32:FindFirstChild("ItemIcon");
        local v34 = descend(v32, { "ItemDetailsFrame", "ItemDetails", "ItemCost" });

        if v33 and (v33 and (v33:IsA("TextLabel") or (v33:IsA("TextButton") or v33:IsA("TextBox")))) then
            v33.Text = v26;
        end;

        if ItemIcon and (ItemIcon and (ItemIcon:IsA("ImageLabel") or ItemIcon:IsA("ImageButton"))) then
            ItemIcon.Image = v28;
        end;

        if v34 and (v34 and (v34:IsA("TextLabel") or (v34:IsA("TextButton") or v34:IsA("TextBox")))) then
            v34.Text = v29;
        end;
    end;

    local v35 = descend(PreRobuxPrompt, { "ProductPurchaseModal", "SheetContainer", "Sheet", "Content", "Actions", "1" });

    if not v35 then
        return nil;
    end;

    local BuyRobux = v35:FindFirstChild("BuyRobux");
    local BuyTokens = v35:FindFirstChild("BuyTokens");

    if not (BuyRobux and BuyTokens) then
        return nil;
    end;

    if PreRobuxPrompt:IsA("ScreenGui") then
        PreRobuxPrompt.Enabled = true;
    elseif PreRobuxPrompt:IsA("LayerCollector") then
        PreRobuxPrompt.Enabled = true;
    elseif PreRobuxPrompt:IsA("GuiObject") then
        PreRobuxPrompt.Visible = true;
    end;

    local u36 = false;
    local u37 = nil;

    local function finish(p38) -- Line: 172
        -- upvalues: u36 (ref), u37 (ref)
        if u36 then
            return;
        end;

        u36 = true;
        u37 = p38;
    end;

    local v39 = BuyRobux.MouseButton1Click:Connect(function() -- Line: 178
        -- upvalues: u36 (ref), u37 (ref)
        if u36 then
            return;
        end;

        u36 = true;
        u37 = "Robux";
    end);
    local v40 = BuyTokens.MouseButton1Click:Connect(function() -- Line: 182
        -- upvalues: u36 (ref), u37 (ref)
        if u36 then
            return;
        end;

        u36 = true;
        u37 = "Tokens";
    end);
    local v41 = {};
    local success, result = pcall(function() -- Line: 188
        -- upvalues: PreRobuxPrompt (copy)
        return PreRobuxPrompt.ProductPurchaseModal.Backdrop;
    end);

    if success and (result and result:IsA("GuiButton")) then
        v41[#v41 + 1] = result.MouseButton1Click:Connect(function() -- Line: 192
            -- upvalues: u36 (ref), u37 (ref)
            if u36 then
                return;
            end;

            u36 = true;
            u37 = nil;
        end);
    end;

    local success2, result2 = pcall(function() -- Line: 197
        -- upvalues: PreRobuxPrompt (copy)
        return PreRobuxPrompt.ProductPurchaseModal.SheetContainer.Sheet.Content.Header.Content.CloseAffordance;
    end);

    if success2 and (result2 and result2:IsA("GuiButton")) then
        v41[#v41 + 1] = result2.MouseButton1Click:Connect(function() -- Line: 201
            -- upvalues: u36 (ref), u37 (ref)
            if u36 then
                return;
            end;

            u36 = true;
            u37 = nil;
        end);
    end;

    local v42;

    if PreRobuxPrompt:IsA("ScreenGui") or PreRobuxPrompt:IsA("LayerCollector") then
        v42 = PreRobuxPrompt:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 209
            -- upvalues: PreRobuxPrompt (copy), u36 (ref), u37 (ref)
            if PreRobuxPrompt.Enabled == false then
                if u36 then
                    return;
                end;

                u36 = true;
                u37 = nil;
            end;
        end);
    else
        v42 = nil;
    end;

    local v43 = os.clock();

    while not u36 and (PreRobuxPrompt.Parent and os.clock() - v43 <= 60) do
        task.wait();
    end;

    if v39 then
        v39:Disconnect();
    end;

    if v40 then
        v40:Disconnect();
    end;

    if v42 then
        v42:Disconnect();
    end;

    for _, v in ipairs(v41) do
        v:Disconnect();
    end;

    if PreRobuxPrompt:IsA("ScreenGui") then
        PreRobuxPrompt.Enabled = false;
    elseif PreRobuxPrompt:IsA("LayerCollector") then
        PreRobuxPrompt.Enabled = false;
    elseif PreRobuxPrompt:IsA("GuiObject") then
        PreRobuxPrompt.Visible = false;
    end;

    return u37;
end;

local BindableEvent = Instance.new("BindableEvent");

function v1.GetPreloadedProductInfoByProductId(p44, p45) -- Line: 238
    -- upvalues: u10 (copy)
    return u10[p45];
end;

function v1.GetPreloadedProductInfo(p46, p47) -- Line: 242
    -- upvalues: DevProducts (copy), u10 (copy)
    local v48 = DevProducts.GetByKey(p47);

    if not v48 then
        return nil;
    end;

    local ProductId = v48.ProductId;

    if type(ProductId) == "number" then
        return u10[ProductId];
    end;

    return nil;
end;

function v1.WaitForPreloadedProductInfoByProductId(p49, p50, p51) -- Line: 254
    -- upvalues: u11 (ref), BindableEvent (copy), u10 (copy)
    if not u11 then
        BindableEvent.Event:Wait();
    end;

    if type(p50) == "number" then
        return u10[p50];
    end;

    return nil;
end;

function v1.WaitForPreloadedProductInfo(p52, p53, p54) -- Line: 262
    -- upvalues: u11 (ref), BindableEvent (copy), DevProducts (copy), u10 (copy)
    if not u11 then
        BindableEvent.Event:Wait();
    end;

    local v55 = DevProducts.GetByKey(p53);

    if not v55 then
        return nil;
    end;

    local ProductId = v55.ProductId;

    if type(ProductId) == "number" then
        return u10[ProductId];
    end;

    return nil;
end;

function v1.PromptPurchaseInternal(p56, p57) -- Line: 275
    -- upvalues: DevProducts (copy), PlayerStateClient (copy), getPromptChoice (copy), Networking (copy), MarketplaceService (copy), LocalPlayer (copy)
    local v58 = DevProducts.GetByKey(p57);

    if not v58 then
        return false, "Invalid product";
    end;

    local ProductId = v58.ProductId;

    if type(ProductId) ~= "number" then
        return false, "Invalid product";
    end;

    local TokenCost = v58.TokenCost;
    local v59 = PlayerStateClient:GetLocalReplica() or PlayerStateClient:WaitForLocalReplica(2);
    local v60 = v59 and (v59.Data.Tokens or 0) or 0;
    local v61;

    if type(TokenCost) == "number" and TokenCost >= 0 then
        v61 = TokenCost <= v60;
    else
        v61 = false;
    end;

    if not v61 then
        MarketplaceService:PromptProductPurchase(LocalPlayer, ProductId);

        return true, "Prompted Robux";
    end;

    local v62 = getPromptChoice(p57, ProductId);

    if v62 == "Tokens" then
        return Networking.DevProducts.PurchaseWithTokens:Fire(p57);
    end;

    if v62 ~= "Robux" then
        return false, "Cancelled";
    end;

    MarketplaceService:PromptProductPurchase(LocalPlayer, ProductId);

    return true, "Prompted Robux";
end;

function v1.Init(p63) -- Line: 307
    -- upvalues: MarketplaceService (copy), LocalPlayer (copy), u8 (copy), u6 (copy), u7 (copy), u9 (copy), u2 (copy), Networking (copy), DevProducts (copy), u10 (copy), u11 (ref), BindableEvent (copy), u12 (ref)
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p64, p65, p66) -- Line: 308
        -- upvalues: LocalPlayer (ref), u8 (ref), u6 (ref), u7 (ref)
        if p64 ~= LocalPlayer.UserId then
            return;
        end;

        local v67 = u8[p65];

        if not v67 then
            return;
        end;

        u8[p65] = nil;

        if p66 then
            u6:Fire(v67);

            return;
        end;

        u7:Fire(v67, "Robux purchase cancelled");
    end);
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p68, u69, p70) -- Line: 322
        -- upvalues: LocalPlayer (ref), u9 (ref), u2 (ref), Networking (ref), u6 (ref), u7 (ref)
        if p68 ~= LocalPlayer then
            return;
        end;

        local u71 = u9[u69];

        if not u71 then
            if p70 then
                warn((`[GamepassGearDebug] gamepass {u69} purchased but no pending key; server NOT notified`));
            end;

            return;
        end;

        u9[u69] = nil;

        if p70 then
            task.spawn(function() -- Line: 338
                -- upvalues: u71 (copy), u69 (copy), u2 (ref), Networking (ref), u6 (ref), u7 (ref)
                local v72 = `[GamepassGearDebug] purchase finished for {u71} (id {u69}); notifying server`;

                if u2 then
                    print(v72);
                end;

                local v73, v74, v75 = pcall(Networking.DevProducts.GamepassPurchased.Fire, Networking.DevProducts.GamepassPurchased, u71);

                if v73 and v74 then
                    local v76 = `[GamepassGearDebug] server confirmed grant for {u71}`;

                    if u2 then
                        print(v76);
                    end;

                    u6:Fire(u71);

                    return;
                end;

                if v73 then
                    v74 = v75;
                end;

                warn((`[GamepassGearDebug] server grant FAILED for {u71}: invokeOk={v73}, message={v74}`));
                u7:Fire(u71, not v73 and "Server error" or v75);
            end);

            return;
        end;

        u7:Fire(u71, "Gamepass purchase cancelled");
    end);
    task.spawn(function() -- Line: 354
        -- upvalues: DevProducts (ref), u10 (ref), u11 (ref), BindableEvent (ref)
        local v77 = workspace:GetAttribute("RemoteDeveloperProducts");

        if not v77 then
            workspace:GetAttributeChangedSignal("RemoteDeveloperProducts"):Wait();
            v77 = workspace:GetAttribute("RemoteDeveloperProducts");
        end;

        for _, v in game:GetService("HttpService"):JSONDecode(v77) do
            DevProducts.AddProduct({
                Key = v[1],
                ProductId = v[3],
                TokenCost = v[2]
            });
            local v78 = v[3];
            local v79 = v[4];

            if type(v78) == "number" and (type(v79) == "number" and (v79 > 0 and u10[v78] == nil)) then
                u10[v78] = {
                    Name = type(v[5]) ~= "string" and "" or v[5],
                    PriceInRobux = v79,
                    Image = type(v[6]) ~= "string" and "" or v[6]
                };
            end;
        end;

        u11 = true;
        BindableEvent:Fire();
    end);
    task.spawn(function() -- Line: 388
        -- upvalues: DevProducts (ref), u12 (ref)
        local v80 = workspace:GetAttribute("RemoteGamepasses");

        if not v80 then
            workspace:GetAttributeChangedSignal("RemoteGamepasses"):Wait();
            v80 = workspace:GetAttribute("RemoteGamepasses");
        end;

        for _, v in game:GetService("HttpService"):JSONDecode(v80) do
            local AddGamepass = DevProducts.AddGamepass;
            local v81 = {
                Key = v[1],
                GamepassId = v[2],
                Name = v[3]
            };
            local v82;

            if type(v[4]) == "string" and v[4] ~= "" then
                v82 = v[4];
            else
                v82 = nil;
            end;

            v81.Image = v82;
            local v83;

            if type(v[5]) == "number" and v[5] > 0 then
                v83 = v[5];
            else
                v83 = nil;
            end;

            v81.PriceInRobux = v83;
            AddGamepass(v81);
        end;

        u12 = true;
    end);
end;

function v1.PromptPurchase(p84, p85) -- Line: 409
    -- upvalues: u4 (copy), DevProducts (copy), u7 (copy), Environment (copy), u10 (copy), MessagePrompt (copy), Networking (copy), u6 (copy), u5 (copy), u8 (copy)
    u4:Fire(p85);
    local v86 = DevProducts.GetByKey(p85);

    if not v86 then
        u7:Fire(p85, "Invalid product");

        return false, "Invalid product";
    end;

    local v87 = workspace:GetAttribute("InstantPurchasesEnabled");

    if type(v87) ~= "boolean" then
        v87 = Environment.config.InstantPurchases;
    end;

    if not v87 then
        local v88, v89 = p84:PromptPurchaseInternal(p85);

        if v88 and v89 == "Prompted Robux" then
            local ProductId = v86.ProductId;

            if type(ProductId) == "number" then
                u8[ProductId] = p85;
            end;

            return v88, v89;
        end;

        if v88 then
            u6:Fire(p85);

            return v88, v89;
        end;

        if v89 == "Cancelled" then
            u5:Fire(p85);

            return v88, v89;
        end;

        u7:Fire(p85, v89);

        return v88, v89;
    end;

    local ProductId = v86.ProductId;
    local v90;

    if type(ProductId) == "number" then
        v90 = u10[ProductId];
    else
        v90 = nil;
    end;

    local v91;

    if v90 and (type(v90.Name) == "string" and v90.Name ~= "") then
        v91 = v90.Name;
    else
        v91 = p85;
    end;

    if not MessagePrompt.Prompt({
        titleOverride = "Instant Purchase",
        yield = true,
        message = `Instant purchase {v91}?`,
        options = MessagePrompt.Choices.YesNo
    }) then
        u5:Fire(p85);

        return false, "Cancelled";
    end;

    local v92, v93 = Networking.DevProducts.InstantGrant:Fire(p85);

    if v92 then
        u6:Fire(p85);

        return true, "Instant granted";
    end;

    u7:Fire(p85, v93 or "Instant grant failed");

    return false, v93 or "Instant grant failed";
end;

function v1.PromptGamepassPurchase(p94, p95) -- Line: 468
    -- upvalues: u4 (copy), DevProducts (copy), u7 (copy), MarketplaceService (copy), LocalPlayer (copy), Environment (copy), MessagePrompt (copy), Networking (copy), u6 (copy), u5 (copy), u9 (copy)
    u4:Fire(p95);
    local v96 = DevProducts.GetGamepassByKey(p95);

    if not v96 then
        u7:Fire(p95, "Invalid gamepass");

        return false, "Invalid gamepass";
    end;

    local GamepassId = v96.GamepassId;

    if type(GamepassId) ~= "number" then
        u7:Fire(p95, "Invalid gamepass");

        return false, "Invalid gamepass";
    end;

    local success, result = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, LocalPlayer.UserId, GamepassId);

    if success and result then
        u7:Fire(p95, "Already owned");

        return false, "Already owned";
    end;

    local v97 = LocalPlayer:GetAttribute("OwnedGamepasses");

    if type(v97) == "string" and v97 ~= "" then
        local v98 = p95:match("^Gamepass:([^:]+)");

        if v98 then
            for i in v97:gmatch("[^,]+") do
                if i == v98 then
                    u7:Fire(p95, "Already owned");

                    return false, "Already owned";
                end;
            end;
        end;
    end;

    local v99 = workspace:GetAttribute("InstantPurchasesEnabled");

    if type(v99) ~= "boolean" then
        v99 = Environment.config.InstantPurchases;
    end;

    if not v99 then
        u9[GamepassId] = p95;
        MarketplaceService:PromptGamePassPurchase(LocalPlayer, GamepassId);

        return true, "Prompted Gamepass";
    end;

    local v100;

    if type(v96.Name) == "string" and v96.Name ~= "" then
        v100 = v96.Name;
    else
        v100 = p95;
    end;

    if not MessagePrompt.Prompt({
        titleOverride = "Instant Purchase",
        yield = true,
        message = `Instant purchase {v100}?`,
        options = MessagePrompt.Choices.YesNo
    }) then
        u5:Fire(p95);

        return false, "Cancelled";
    end;

    local v101, v102 = Networking.DevProducts.InstantGrantGamepass:Fire(p95);

    if v101 then
        u6:Fire(p95);

        return true, "Instant granted";
    end;

    u7:Fire(p95, v102 or "Instant grant failed");

    return false, v102 or "Instant grant failed";
end;

function v1.WaitForGamepassesReady(p103) -- Line: 532
    -- upvalues: u12 (ref)
    if u12 then
        return;
    end;

    while not u12 do
        task.wait();
    end;
end;

return v1;