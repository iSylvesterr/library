-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Variables = require(Library.Variables);
local GetProductByID = require(script.Parent.GetProductByID);
local GetGamepassByID = require(script.Parent.GetGamepassByID);
local LocalPlayer = Players.LocalPlayer;
local u1 = { Constants.MAIN_DEV_ID };
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = nil;

local function clearAllProductLocks() -- Line: 26
    -- upvalues: u5 (copy)
    for _, v in pairs(u5) do
        table.clear(v);
    end;
end;

local function markProductLocks(p7) -- Line: 32
    -- upvalues: u2 (copy), u5 (copy)
    local v8 = u2[p7];

    if not v8 then
        return;
    end;

    for _, v in ipairs(v8) do
        u5[v][p7] = true;
    end;
end;

local function clearPromptInFlight() -- Line: 43
    -- upvalues: u6 (ref), u5 (copy)
    u6 = nil;

    for _, v in pairs(u5) do
        table.clear(v);
    end;
end;

local function clearPendingProduct(p9, p10) -- Line: 48
    -- upvalues: u4 (copy), u3 (copy), u2 (copy), u5 (copy)
    u4[p9] = nil;

    if p10 then
        u3[p9] = true;
    end;

    local v11 = u2[p9];

    if v11 then
        for _, v in ipairs(v11) do
            u5[v][p9] = nil;
        end;
    end;
end;

for i, v in pairs(u2) do
    if not u5[i] then
        u5[i] = {};
    end;

    for _, v2 in ipairs(v) do
        if not u5[v2] then
            u5[v2] = {};
        end;
    end;
end;

if RunService:IsClient() then
    local Network = require(Library.Client.Network);
    Network.Fired("Product Failed"):Connect(function(p12) -- Line: 75
        -- upvalues: u4 (copy), u3 (copy), u2 (copy), u5 (copy)
        local ProductId = p12.ProductId;
        u4[ProductId] = nil;
        u3[ProductId] = true;
        local v13 = u2[ProductId];

        if v13 then
            for _, v in ipairs(v13) do
                u5[v][ProductId] = nil;
            end;
        end;
    end);
    Network.Fired("Product Bought"):Connect(function(p14, p15) -- Line: 79
        -- upvalues: u4 (copy), u3 (copy), u2 (copy), u5 (copy)
        local ProductId = p15.ProductId;
        u4[ProductId] = nil;
        u3[ProductId] = true;
        local v16 = u2[ProductId];

        if v16 then
            for _, v in ipairs(v16) do
                u5[v][ProductId] = nil;
            end;
        end;
    end);
    Network.Fired("Products: Receipt Processed"):Connect(function(p17) -- Line: 83
        -- upvalues: u4 (copy), u3 (copy), u2 (copy), u5 (copy)
        u4[p17] = nil;
        u3[p17] = true;
        local v18 = u2[p17];

        if v18 then
            for _, v in ipairs(v18) do
                u5[v][p17] = nil;
            end;
        end;
    end);
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p19, p20, p21) -- Line: 87
        -- upvalues: Players (copy), u6 (ref), u5 (copy), u4 (copy), u2 (copy), GetProductByID (copy)
        if p19 ~= Players.LocalPlayer.UserId then
            return;
        end;

        u6 = nil;

        for _, v in pairs(u5) do
            table.clear(v);
        end;

        if p21 then
            local v22 = GetProductByID(p20);

            if v22 and v22.SinglePurchase then
                u4[p20] = true;
            end;

            return;
        end;

        u4[p20] = nil;
        local v23 = u2[p20];

        if v23 then
            for _, v in ipairs(v23) do
                u5[v][p20] = nil;
            end;
        end;
    end);
end;

local u24 = false;

return {
    Prompt = function(p25, p26) -- Line: 109, Name: Prompt
        -- upvalues: RunService (copy), Library (copy), Variables (copy), u24 (ref), GetProductByID (copy), GetGamepassByID (copy), u6 (ref), u3 (copy), u4 (copy), u5 (copy), u1 (copy), LocalPlayer (copy), MarketplaceService (copy), u2 (copy)
        assert(RunService:IsClient());
        local Signal = require(Library.Signal);
        local Audio = require(Library.Audio);
        local Functions = require(Library.Functions);
        local Client = Library:WaitForChild("Client");
        local Message = require(Client.Message);
        local Network = require(Client.Network);
        local FFlags = require(Client.FFlags);
        local Gamepasses = require(Client.Gamepasses);
        local Products = Network.NET_MAP.Products;

        if not (FFlags.Get(FFlags.Keys.Purchases) or FFlags.CanBypass()) then
            Message.New(
                "Sorry! Roblox is experiencing technical difficulties, and purchases have been temporarily disabled. Please try again soon.",
                {
                    title = "Oops!",
                    err = true
                }
            );

            return;
        end;

        local GiftUserId = Variables.GiftUserId;
        local GiftUserName = Variables.GiftUserName;

        if GiftUserId then
            if not p26 then
                Message.New("Sorry! You cannot gift gamepasses!", {
                    title = "Oops!",
                    err = true
                });

                return;
            end;

            local v27 = GetProductByID(p25);

            if not v27 then
                Message.New("Sorry! Failed to find product!", {
                    title = "Oops!",
                    err = true
                });

                return;
            end;

            if not v27.ComputeItems then
                Message.New("Sorry! This product cannot be gifted!", {
                    title = "Oops!",
                    err = true
                });

                return;
            end;

            if not Message.New(`This purchase will be gifted to {GiftUserName}, are you sure?`, true, {
                icon = Functions.GetThumbnailFromUserIdAsync(GiftUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            }) then
                Signal.Fire("Gift User Reset");

                return;
            end;

            local v28, v29 = Network.Invoke("Products: Gifting", GiftUserId, p25, nil);

            if not v28 then
                Message.New(v29 or "Sorry! Something went wrong!", {
                    title = "Oops!",
                    err = true
                });

                return;
            end;

            Signal.Fire("Gift User Reset");
            u24 = true;
        elseif p26 and u24 then
            Network.Invoke("Products: Clear Gifting");
            u24 = false;
        end;

        if p26 then
            local v30 = GetProductByID(p25);

            if not v30 then
                Message.New(
                    "Sorry! Something went wrong! If this keeps happening please contact our support!",
                    {
                        title = "Oops!",
                        err = true
                    }
                );

                return;
            end;

            if not FFlags.BulkGet("Product", v30._id) then
                Message.New(
                    "Sorry! Roblox is having trouble so we have temporarily disabled this purchase! Try back soon!",
                    {
                        title = "Oops!",
                        err = true
                    }
                );

                return;
            end;

            if u6 ~= nil then
                Message.New("Finish the current purchase prompt first.", {
                    title = "Oops!",
                    err = true
                });

                return;
            end;

            if FFlags.Get(FFlags.Keys.BlockRepeatSingleProductPurchases) and v30.SinglePurchase then
                if u3[v30.ProductId] then
                    Message.New(
                        "Roblox is having trouble and it looks like you\'ve already attempted to purchase this! Please attempt to rejoin if the purchase is not granted! (#1)",
                        {
                            title = "Oops!",
                            err = true
                        }
                    );

                    return;
                end;

                if u4[v30.ProductId] then
                    Message.New(
                        "Roblox is having trouble and it looks like you\'ve already attempted to purchase this! Please attempt to rejoin if the purchase is not granted! (#2)",
                        {
                            title = "Oops!",
                            err = true
                        }
                    );

                    return;
                end;

                if FFlags.Get(FFlags.Keys.PurchaseAdditionalLocks) and (u5[v30.ProductId] and Functions.DictionaryLength(u5[v30.ProductId]) > 0) then
                    Message.New(
                        "Roblox is having trouble and it looks like you\'ve already attempted to purchase this! Please attempt to rejoin if the purchase is not granted! (#3)",
                        {
                            title = "Oops!",
                            err = true
                        }
                    );

                    return;
                end;
            end;

            if v30.ClientTest then
                local v31, v32, v33 = Functions.wcall(v30.ClientTest);

                if not (v31 and v32) then
                    Message.New(v33 or "Something went wrong attempting to purchase this product!", {
                        title = "Oops!",
                        err = true
                    });

                    return;
                end;
            end;
        else
            local v34 = GetGamepassByID(p25);

            if not v34 then
                Message.New(
                    "Sorry! Something went wrong! If this keeps happening please contact our support!",
                    {
                        title = "Oops!",
                        err = true
                    }
                );

                return;
            end;

            if not FFlags.BulkGet("Gamepass", v34._id) then
                Message.New(
                    "Sorry! Roblox is having trouble so we have temporarily disabled this purchase! Try back soon!",
                    {
                        title = "Oops!",
                        err = true
                    }
                );

                return;
            end;

            if v34.ClientTest then
                local v35, v36, v37 = Functions.wcall(v34.ClientTest);

                if not (v35 and v36) then
                    Message.New(v37 or "Something went wrong attempting to purchase this gamepass!", {
                        title = "Oops!",
                        err = true
                    });

                    return;
                end;
            end;
        end;

        if u1[LocalPlayer.UserId] and FFlags.Get(FFlags.Keys.ProductBypassWhitelist) then
            if not Message.New("Instant whitelist purchase?", true) then
                return;
            end;

            local v38, v39 = Network.Invoke("Products: Whitelist Purchase", p25, p26 == true);

            if v38 then
                return;
            end;

            Message.New(v39 or "Something went wrong!", {
                err = true
            });
        end;

        if not p26 then
            if Gamepasses.Owns(p25) then
                return;
            end;

            Audio.Play("rbxassetid://129627240635324", script, 1.35, 0.6);
            Signal.Fire("Prompting Purchase");
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, p25);

            return;
        end;

        local v40 = GetProductByID(p25);

        if not v40 then
            Message.New("Something went wrong! (#3)", {
                err = true
            });

            return;
        end;

        local v41, v42 = Network.Invoke(Products.REQUEST_SERVER_TEST, v40.ProductId);

        if not v41 then
            Message.New(v42 or "Something went wrong attempting to purchase this product!", {
                title = "Oops!",
                err = true
            });

            return;
        end;

        Audio.Play("rbxassetid://129627240635324", script, 1.35, 0.6);
        u6 = v40.ProductId;
        local ProductId = v40.ProductId;
        local v43 = u2[ProductId];

        if v43 then
            for _, v in ipairs(v43) do
                u5[v][ProductId] = true;
            end;
        end;

        if FFlags.Get(FFlags.Keys.LegacyPrompting) then
            Signal.Fire("Prompting Purchase");
            MarketplaceService:PromptProductPurchase(LocalPlayer, p25);
        else
            local v44, v45 = Network.Invoke(Products.REQUEST_PROMPT_PURCHASE, v40.ProductId);

            if not v44 then
                u6 = nil;

                for _, v in pairs(u5) do
                    table.clear(v);
                end;

                Message.New(v45 or "Something went wrong attempting to purchase this product!", {
                    title = "Oops!",
                    err = true
                });

                return;
            end;
        end;

        if FFlags.Get(FFlags.Keys.LegacyPrompting) then
        end;
    end
};