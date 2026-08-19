-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local ServerClock = require(ReplicatedStorage.ClientModules.ServerClock);
local NumberUtils = require(ReplicatedStorage.SharedModules.NumberUtils);
local DevProductController = require(Players.LocalPlayer.PlayerScripts.Controllers.DevProductController);
local PlayerSelector = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PlayerSelector");

local function formatTime(p2) -- Line: 19
    local v3 = math.ceil(p2);
    local v4 = math.max(v3, 0);
    local v5 = math.floor(v4 / 60);
    local v6 = v4 % 60;

    if v5 > 0 then
        return string.format("%dm %ds", v5, v6);
    end;

    return tostring(v6) .. "s";
end;

local function handleGiftPurchase(u7) -- Line: 29
    -- upvalues: PlayerSelector (copy), Networking (copy), DevProductController (copy)
    local u8 = nil;
    task.spawn(function() -- Line: 31
        -- upvalues: PlayerSelector (ref), u8 (ref)
        u8 = PlayerSelector.PlayerSelected.Event:Wait() or "cancelled";
    end);
    PlayerSelector.Enabled = true;

    repeat
        task.wait();
    until u8 ~= nil;

    if u8 == "cancelled" then
        return;
    end;

    local success, result = pcall(function() -- Line: 44
        -- upvalues: Networking (ref), u8 (ref)
        Networking.DevProducts.SetGiftTarget:Fire(u8.UserId);
    end);

    if not success then
        warn((`[ExclusiveStoreController] SetGiftTarget fire failed ({u7}): {result}`));
    end;

    local success2, result2 = pcall(function() -- Line: 50
        -- upvalues: DevProductController (ref), u7 (copy)
        DevProductController:PromptPurchase(u7 .. ":Gift");
    end);

    if not success2 then
        warn((`[ExclusiveStoreController] Gift purchase prompt failed ({u7}): {result2}`));
    end;
end;

function v1.Init(p9) -- Line: 62
end;

function v1.Setup(p10, p11) -- Line: 64
    -- upvalues: DevProductController (copy), NumberUtils (copy), RunService (copy), ServerClock (copy), handleGiftPurchase (copy), Networking (copy)
    local container = p11.container;
    local templates = p11.templates;

    for _, v in templates do
        v.Visible = false;
    end;

    local Robux_Shelf = container:WaitForChild("Robux_Shelf");
    Robux_Shelf.Visible = false;
    local Buttons = Robux_Shelf.Main_Frame.Buttons;
    local u12 = Buttons:WaitForChild("1Button");
    local GiftButton1 = Buttons:WaitForChild("GiftButton1");
    local Seed_Name = Robux_Shelf.Main_Frame:WaitForChild("Seed_Name");
    local u13 = {};
    local u14 = nil;
    local u15 = false;
    local u16 = Color3.fromHex("#2d2617");
    local u17 = Color3.fromHex("#2f0000");
    local u18 = ColorSequence.new(Color3.fromHex("#ff0000"));
    local u19 = {};

    local function updateTextAppearance(p20, p21, p22) -- Line: 94
        -- upvalues: u16 (copy), u17 (copy), u19 (copy), u18 (copy)
        local Text = p20:FindFirstChild("Text");

        if not Text then
            return;
        end;

        local TextLabel = Text:FindFirstChild("TextLabel");

        if not TextLabel then
            return;
        end;

        local v23 = TextLabel:FindFirstChildWhichIsA("TextLabel");
        local v24 = TextLabel:FindFirstChildWhichIsA("UIStroke");

        if v24 then
            local v25;

            if p21 then
                v25 = u16;
            else
                v25 = u17;
            end;

            v24.Color = v25;
        end;

        if v23 then
            local v26 = v23:FindFirstChildWhichIsA("UIStroke");

            if v26 then
                local v27;

                if p21 then
                    v27 = u16;
                else
                    v27 = u17;
                end;

                v26.Color = v27;
            end;

            local v28 = v23:FindFirstChildWhichIsA("UIGradient");

            if v28 then
                if not u19[p22] then
                    u19[p22] = v28.Color;
                end;

                local v29;

                if p21 then
                    v29 = u19[p22];
                else
                    v29 = u18;
                end;

                v28.Color = v29;
            end;
        end;
    end;

    local function getSelectedEntry() -- Line: 126
        -- upvalues: u14 (ref), u13 (copy)
        if not u14 then
            return nil;
        end;

        for _, v in u13 do
            if v.frame == u14 then
                return v;
            end;
        end;

        return nil;
    end;

    local function hideShelf() -- Line: 136
        -- upvalues: Robux_Shelf (copy)
        Robux_Shelf.Visible = false;
    end;

    local function updateShelf() -- Line: 140
        -- upvalues: u14 (ref), Robux_Shelf (copy), u13 (copy), Seed_Name (copy), DevProductController (ref), NumberUtils (ref), u12 (copy), GiftButton1 (copy)
        if not u14 then
            Robux_Shelf.Visible = false;

            return;
        end;

        if u14 then
            for _, v in u13 do
                if v.frame == u14 then
                    break;
                end;
            end;
        else
            local v = nil;
        end;

        if not v then
            Robux_Shelf.Visible = false;

            return;
        end;

        local itemData = v.itemData;
        Seed_Name.Value = itemData.itemName;
        task.spawn(function() -- Line: 156
            -- upvalues: DevProductController (ref), itemData (copy), u14 (ref), v (copy), NumberUtils (ref), u12 (ref)
            local v30 = DevProductController:WaitForPreloadedProductInfo(itemData.productKey, 5);

            if u14 ~= v.frame then
                return;
            end;

            if not v30 then
                u12.TextDisplay.TextLabel.Text = "Buy";
                u12.TextDisplay.TextLabel.TextLabel.Text = "Buy";

                return;
            end;

            local v31 = `{NumberUtils.FormatWithCommas(v30.PriceInRobux)}`;
            u12.TextDisplay.TextLabel.Text = v31;
            u12.TextDisplay.TextLabel.TextLabel.Text = v31;
        end);
        GiftButton1.Visible = itemData.giftable;
        Robux_Shelf.Visible = true;
    end;

    local function clearDeal(p32) -- Line: 175
        -- upvalues: u13 (copy), u14 (ref), Robux_Shelf (copy), u19 (copy)
        local v33 = u13[p32];

        if not v33 then
            return;
        end;

        if u14 == v33.frame then
            u14 = nil;
            Robux_Shelf.Visible = false;
        end;

        if v33.heartbeat then
            v33.heartbeat:Disconnect();
        end;

        for _, v in v33.connections do
            v:Disconnect();
        end;

        u19[p32] = nil;
        v33.frame:Destroy();
        u13[p32] = nil;
    end;

    local function setupDeal(u34, p35) -- Line: 198
        -- upvalues: clearDeal (copy), templates (copy), container (copy), DevProductController (ref), NumberUtils (ref), updateTextAppearance (copy), u14 (ref), Robux_Shelf (copy), u13 (copy), updateShelf (copy), RunService (ref), ServerClock (ref)
        clearDeal(u34);
        local v36 = templates[u34];

        if not v36 then
            return;
        end;

        local u37 = p35.items[1];

        if not u37 then
            return;
        end;

        local u38 = v36:Clone();
        u38.Name = "ActiveDeal_" .. u34;
        u38.Visible = true;
        u38.Parent = container;
        local Main_Frame = u38:FindFirstChild("Main_Frame");

        if not Main_Frame then
            return;
        end;

        local v39 = {};
        local Seed_Text = Main_Frame:FindFirstChild("Seed_Text");

        if Seed_Text then
            Seed_Text.Text = u37.itemName;
            local v40 = Seed_Text:FindFirstChildWhichIsA("TextLabel");

            if v40 then
                v40.Text = u37.itemName;
            end;
        end;

        local ImageDisplay = Main_Frame:FindFirstChild("ImageDisplay");
        local v41 = ImageDisplay and ImageDisplay:FindFirstChild("Vector");

        if v41 then
            v41.Image = u37.image or "";
        end;

        local Rarity = Main_Frame:FindFirstChild("Rarity");
        local v42 = Rarity and Rarity:FindFirstChild("Rarity_Text");

        if v42 then
            v42.Text = u34;
            local v43 = v42:FindFirstChildWhichIsA("TextLabel");

            if v43 then
                v43.Text = u34;
            end;
        end;

        local Stock_Text = Main_Frame:FindFirstChild("Stock_Text");

        if Stock_Text then
            Stock_Text.Text = u37.stock <= 0 and "0 Stock" or "x" .. u37.stock .. " in Stock";
        end;

        local SoldOut = Main_Frame:FindFirstChild("SoldOut");

        if SoldOut then
            SoldOut.Visible = u37.stock <= 0;
        end;

        local Text = Main_Frame:FindFirstChild("Text");
        local u44 = Text and Text:FindFirstChild("TextLabel");

        if u44 then
            if u37.stock <= 0 then
                u44.Text = "SOLD OUT";
                local v45 = u44:FindFirstChildWhichIsA("TextLabel");

                if v45 then
                    v45.Text = "SOLD OUT";
                end;
            else
                task.spawn(function() -- Line: 270
                    -- upvalues: DevProductController (ref), u37 (copy), NumberUtils (ref), u44 (copy)
                    local v46 = DevProductController:WaitForPreloadedProductInfo(u37.productKey, 5);
                    local v47 = not v46 and "" or `{NumberUtils.FormatWithCommas(v46.PriceInRobux)}`;
                    u44.Text = v47;
                    local v48 = u44:FindFirstChildWhichIsA("TextLabel");

                    if v48 then
                        v48.Text = v47;
                    end;
                end);
            end;
        end;

        updateTextAppearance(Main_Frame, u37.stock > 0, u34);
        local TextButton = Main_Frame:FindFirstChild("TextButton");

        if TextButton then
            table.insert(v39, TextButton.Activated:Connect(function() -- Line: 288
                -- upvalues: u14 (ref), u38 (copy), Robux_Shelf (ref), u13 (ref), updateShelf (ref)
                if u14 == u38 then
                    u14 = nil;
                    Robux_Shelf.Visible = false;

                    return;
                end;

                local v49 = nil;

                for _, v in u13 do
                    if v.frame == u38 then
                        v49 = v;
                        break;
                    end;
                end;

                if v49 and v49.itemData.stock <= 0 then
                    return;
                end;

                u14 = u38;
                Robux_Shelf.LayoutOrder = u38.LayoutOrder + 1;
                updateShelf();
            end));
        end;

        local LeavesIn = Main_Frame:FindFirstChild("LeavesIn");
        local u50;

        if LeavesIn then
            u50 = LeavesIn:FindFirstChild("Timer");
        else
            u50 = LeavesIn;
        end;

        if LeavesIn then
            LeavesIn = LeavesIn:FindFirstChild("UIGradient");
        end;

        local expiresAt = p35.expiresAt;
        local restockTime = p35.restockTime;
        u13[u34] = {
            frame = u38,
            heartbeat = RunService.Heartbeat:Connect(function() -- Line: 318
                -- upvalues: expiresAt (copy), ServerClock (ref), clearDeal (ref), u34 (copy), u50 (copy), LeavesIn (copy), restockTime (copy)
                local v51 = expiresAt - ServerClock.Now();

                if v51 <= 0 then
                    clearDeal(u34);

                    return;
                end;

                if u50 then
                    local v52 = math.ceil(v51);
                    local v53 = math.max(v52, 0);
                    local v54 = math.floor(v53 / 60);
                    local v55 = v53 % 60;
                    local v56;

                    if v54 > 0 then
                        v56 = string.format("%dm %ds", v54, v55);
                    else
                        v56 = tostring(v55) .. "s";
                    end;

                    u50.Text = v56;
                    local v57;

                    if v51 <= 30 then
                        v57 = Color3.fromHex("#ff0000");
                    else
                        v57 = Color3.new(1, 1, 1);
                    end;

                    u50.TextColor3 = v57;
                end;

                if LeavesIn then
                    LeavesIn.Offset = Vector2.new(v51 / restockTime, 0);
                end;
            end),
            itemData = u37,
            connections = v39
        };
    end;

    local function updateStock(p58, p59) -- Line: 346
        -- upvalues: u13 (copy), DevProductController (ref), NumberUtils (ref), updateTextAppearance (copy), u14 (ref), Robux_Shelf (copy)
        local u60 = u13[p58];

        if not u60 then
            return;
        end;

        local v61 = p59.items[1];

        if not v61 then
            return;
        end;

        u60.itemData.stock = v61.stock;
        local Main_Frame = u60.frame:FindFirstChild("Main_Frame");

        if not Main_Frame then
            return;
        end;

        local Stock_Text = Main_Frame:FindFirstChild("Stock_Text");

        if Stock_Text then
            Stock_Text.Text = v61.stock <= 0 and "0 Stock" or "x" .. v61.stock .. " in Stock";
        end;

        local SoldOut = Main_Frame:FindFirstChild("SoldOut");

        if SoldOut then
            SoldOut.Visible = v61.stock <= 0;
        end;

        local Text = Main_Frame:FindFirstChild("Text");
        local u62 = Text and Text:FindFirstChild("TextLabel");

        if u62 then
            if v61.stock <= 0 then
                u62.Text = "SOLD OUT";
                local v63 = u62:FindFirstChildWhichIsA("TextLabel");

                if v63 then
                    v63.Text = "SOLD OUT";
                end;
            else
                task.spawn(function() -- Line: 381
                    -- upvalues: DevProductController (ref), u60 (copy), NumberUtils (ref), u62 (copy)
                    local v64 = DevProductController:WaitForPreloadedProductInfo(u60.itemData.productKey, 5);
                    local v65 = not v64 and "" or `{NumberUtils.FormatWithCommas(v64.PriceInRobux)}`;
                    u62.Text = v65;
                    local v66 = u62:FindFirstChildWhichIsA("TextLabel");

                    if v66 then
                        v66.Text = v65;
                    end;
                end);
            end;
        end;

        updateTextAppearance(Main_Frame, v61.stock > 0, p58);

        if v61.stock <= 0 and u14 == u60.frame then
            u14 = nil;
            Robux_Shelf.Visible = false;
        end;
    end;

    u12.Activated:Connect(function() -- Line: 406
        -- upvalues: u15 (ref), u14 (ref), u13 (copy), DevProductController (ref)
        if u15 then
            return;
        end;

        if u14 then
            for _, v in u13 do
                if v.frame == u14 then
                    break;
                end;
            end;
        else
            local v = nil;
        end;

        if not v then
            return;
        end;

        if v.itemData.stock <= 0 then
            return;
        end;

        u15 = true;
        local success, result = pcall(function() -- Line: 413
            -- upvalues: DevProductController (ref), v (copy)
            DevProductController:PromptPurchase(v.itemData.productKey);
        end);

        if not success then
            warn((`[ExclusiveStoreController] Buy purchase prompt failed ({v.itemData.productKey}): {result}`));
        end;

        task.wait();
        u15 = false;
    end);
    GiftButton1.Activated:Connect(function() -- Line: 423
        -- upvalues: u15 (ref), u14 (ref), u13 (copy), handleGiftPurchase (ref)
        if u15 then
            return;
        end;

        if u14 then
            for _, v in u13 do
                if v.frame == u14 then
                    break;
                end;
            end;
        else
            local v = nil;
        end;

        if not v then
            return;
        end;

        if v.itemData.stock <= 0 then
            return;
        end;

        if not v.itemData.giftable then
            return;
        end;

        u15 = true;
        local success, result = pcall(function() -- Line: 431
            -- upvalues: handleGiftPurchase (ref), v (copy)
            handleGiftPurchase(v.itemData.productKey);
        end);

        if not success then
            warn((`[ExclusiveStoreController] Gift flow failed ({v.itemData.productKey}): {result}`));
        end;

        task.wait();
        u15 = false;
    end);
    Networking.ExclusiveShop.DealUpdate.OnClientEvent:Connect(function(p67) -- Line: 444
        -- upvalues: u13 (copy), clearDeal (copy), updateStock (copy), setupDeal (copy)
        for i in pairs(u13) do
            if not p67[i] then
                clearDeal(i);
            end;
        end;

        for i, v in p67 do
            if u13[i] then
                updateStock(i, v);
            else
                setupDeal(i, v);
            end;
        end;
    end);
end;

return v1;