-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local UserInputService = game:GetService("UserInputService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local Auctioneer = require(ReplicatedStorage.SharedModules.Auctioneer);
local AuctioneerFlags = require(ReplicatedStorage.SharedModules.Flags.AuctioneerFlags);
local NumberUtils = require(ReplicatedStorage.SharedModules.NumberUtils);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local PetSizes = require(ReplicatedStorage.SharedData.PetSizes);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local GuiController = require(script.Parent.GuiController);
local DevProductController = require(script.Parent.DevProductController);
local NotificationController = require(script.Parent.NotificationController);
local TopText = require(ReplicatedStorage.ClientModules.TopText);
local NPC = require(ReplicatedStorage.ClientModules.NPC);
local MailboxItemCatalog = require(script.Parent:WaitForChild("MailboxController"):WaitForChild("MailboxItemCatalog"));

local function isAuctionActive() -- Line: 98
    -- upvalues: AuctioneerFlags (copy)
    local v1 = workspace:GetAttribute("AuctionStandOverride");

    if v1 == "on" then
        return true;
    end;

    if v1 == "off" then
        return false;
    end;

    local v2 = AuctioneerFlags.Enabled:Get() and AuctioneerFlags.OpenEnabled:Get();

    return v2;
end;

local u3 = { "DefaultFrame", "GoldFrame", "RainbowFrame" };
local u4 = u3[#u3];
local u5 = {};
local u6 = {
    Epic = "GoldFrame",
    Legendary = "GoldFrame",
    Mythic = "RainbowFrame",
    Super = "RainbowFrame"
};

for i, v in u3 do
    u5[v] = i;
end;

local SFX = SoundService:FindFirstChild("SFX");
local u7 = not UserInputService.TouchEnabled;
local v8 = Color3.new(0.207843, 0.137255, 0.054902);
local u9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, v8),
    ColorSequenceKeypoint.new(0.499, v8),
    ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
});
local v10 = {};
local u11 = nil;
local u12 = {};
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = {};
local u17 = {};
local u18 = 0;
local u19 = 0;
local u20 = 0;
local u21 = {};
local u22 = {};
local u23 = {};
local u24 = {};
local u25 = {};
local u26 = {};
local u27 = 1.5;
local u28 = 0;
local u29 = {};
local u30 = {};
local u31 = {};
local u32 = {};

local function serverNow() -- Line: 239
    local success, result = pcall(function() -- Line: 240
        return workspace:GetServerTimeNow();
    end);

    if success then
        return result;
    end;

    return os.time();
end;

local function playSfx(p33) -- Line: 249
    -- upvalues: SFX (copy)
    if not SFX then
        return;
    end;

    local v34 = SFX:FindFirstChild(p33);

    if v34 and v34:IsA("Sound") then
        v34.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        v34.TimePosition = 0;
        v34.Playing = true;
    end;
end;

local function lerp(p35, p36, p37) -- Line: 261
    return p35 + (p36 - p35) * p37;
end;

local function setChain(p38, p39) -- Line: 268
    if p38:IsA("TextLabel") or p38:IsA("TextButton") then
        p38.Text = p39;
    end;

    for _, descendant in p38:GetDescendants() do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            descendant.Text = p39;
        end;
    end;
end;

local function lotEntry(p40) -- Line: 282
    return {
        Name = p40.item,
        FruitName = p40.item,
        Mutation = p40.mutation,
        Size = p40.size,
        Type = p40.type
    };
end;

local function resolveIcon(u41) -- Line: 295
    -- upvalues: MailboxItemCatalog (copy)
    local v43, _, v44 = pcall(function() -- Line: 296
        -- upvalues: MailboxItemCatalog (ref), u41 (copy)
        local v42 = u41;

        return MailboxItemCatalog.Resolve(u41.category, u41.item, {
            Name = v42.item,
            FruitName = v42.item,
            Mutation = v42.mutation,
            Size = v42.size,
            Type = v42.type
        });
    end);

    return (not v43 or (typeof(v44) ~= "string" or v44 == "")) and "rbxassetid://81520753924742" or v44;
end;

local function resolveDisplayName(u45) -- Line: 310
    -- upvalues: MailboxItemCatalog (copy), Auctioneer (copy)
    if u45.category == "Pets" then
        local success, result = pcall(function() -- Line: 312
            -- upvalues: MailboxItemCatalog (ref), u45 (copy)
            local v46 = u45;

            return MailboxItemCatalog.Resolve(u45.category, u45.item, {
                Name = v46.item,
                FruitName = v46.item,
                Mutation = v46.mutation,
                Size = v46.size,
                Type = v46.type
            });
        end);

        if success and (typeof(result) == "string" and result ~= "") then
            return result;
        end;
    end;

    return Auctioneer.DisplayName(u45);
end;

local function resolveRarity(p47) -- Line: 326
    -- upvalues: MailboxItemCatalog (copy), SeedData (copy)
    local success, result = pcall(MailboxItemCatalog.ResolveRarity, p47.category, p47.item);

    if success and (typeof(result) == "string" and result ~= "") then
        return result;
    end;

    if p47.category == "Seeds" or p47.category == "HarvestedFruits" then
        for _, v in SeedData do
            if v.SeedName == p47.item then
                return v.Rarity or "";
            end;
        end;
    end;

    return "";
end;

local function frameForLot(p48, p49) -- Line: 349
    -- upvalues: u6 (copy), PetSizes (copy), PetTypes (copy), u4 (copy), u3 (copy), u5 (copy)
    local v50 = u6[p49] or "DefaultFrame";

    if p48.category ~= "Pets" then
        return v50;
    end;

    local v51 = PetSizes.Normalize(p48.size);

    if p48.type == PetTypes.Rainbow or v51 == "Huge" then
        return u4;
    end;

    if v51 == "Big" then
        return u3[math.min((u5[v50] or 1) + 1, #u3)];
    end;

    return v50;
end;

local function formatTimer(p52) -- Line: 365
    local v53 = (type(p52) ~= "number" or (p52 ~= p52 or (p52 == (1 / 0) or p52 == (-1 / 0)))) and 0 or p52;
    local v54 = math.floor(v53);
    local v55 = math.max(0, v54);
    local v56 = v55 // 60;

    if v56 >= 60 then
        return string.format("%dh %dm", v56 // 60, v56 % 60);
    end;

    return string.format("%dm %02ds", v56, v55 % 60);
end;

local function formatPrice(p57) -- Line: 382
    -- upvalues: NumberUtils (copy)
    local v58 = (type(p57) ~= "number" or (p57 ~= p57 or (p57 == (1 / 0) or (p57 == (-1 / 0) or p57 < 0)))) and 0 or p57;

    return NumberUtils.Abbreviate((math.floor(v58))) .. "¢";
end;

local function clearRows() -- Line: 393
    -- upvalues: u21 (copy), u23 (copy), u24 (copy), u25 (copy), u26 (copy), u29 (copy), u30 (copy), u31 (copy)
    for _, v in u21 do
        v:Destroy();
    end;

    table.clear(u21);
    table.clear(u23);
    table.clear(u24);
    table.clear(u25);
    table.clear(u26);
    table.clear(u29);
    table.clear(u30);
    table.clear(u31);
end;

local function buyLot(p59) -- Line: 407
    -- upvalues: u22 (copy), AuctioneerFlags (copy), u32 (copy), SFX (copy), NotificationController (copy), Auctioneer (copy), serverNow (copy), Networking (copy)
    local v60 = os.clock();
    local v61 = u22[p59.lotId];

    if v61 and AuctioneerFlags.PurchaseDebounceSeconds:Get() > v60 - v61 then
        return;
    end;

    if v60 < (u32[p59.lotId] or 0) then
        if SFX then
            local Failed = SFX:FindFirstChild("Failed");

            if Failed and Failed:IsA("Sound") then
                Failed.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                Failed.TimePosition = 0;
                Failed.Playing = true;
            end;
        end;

        NotificationController:CreateNotification("Please wait a moment!", false, 2);

        return;
    end;

    u22[p59.lotId] = v60;
    local v62 = Auctioneer.CurrentPrice(p59, serverNow());
    Networking.Auctioneer.PurchaseLot:Fire(p59.lotId, v62);
    local v63 = AuctioneerFlags.PurchaseCooldownSeconds:Get();

    if v63 > 0 then
        u32[p59.lotId] = v60 + v63;
    end;
end;

local function buyLotRobux(u64) -- Line: 434
    -- upvalues: Networking (copy), SFX (copy), DevProductController (copy)
    if u64.robuxPrice == nil then
        return;
    end;

    local success, result = pcall(function() -- Line: 445
        -- upvalues: Networking (ref), u64 (copy)
        return Networking.Auctioneer.PrepareRobux:Fire(u64.lotId);
    end);

    if success and typeof(result) == "number" then
        DevProductController:PromptPurchase((`Auctioneer:Auction Item:{result}`));

        return;
    end;

    if not SFX then
        return;
    end;

    local Failed = SFX:FindFirstChild("Failed");

    if Failed and Failed:IsA("Sound") then
        Failed.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Failed.TimePosition = 0;
        Failed.Playing = true;
    end;
end;

local function mainFrameOf(p65) -- Line: 456
    local Frame = p65:FindFirstChild("Frame");

    if Frame then
        Frame = Frame:FindFirstChild("Main_Frame");
    end;

    return Frame;
end;

local function placeButton(p66, p67, p68) -- Line: 464
    local v69 = p66:FindFirstChildOfClass("UIAspectRatioConstraint");

    if v69 then
        v69:Destroy();
    end;

    p66.AnchorPoint = Vector2.new(0.5, 1);
    p66.Position = UDim2.new(p67, 0, 0.972, 0);
    p66.Size = UDim2.new(p68, 0, 0.131, 0);
end;

local function setRobuxPriceFace(p70, p71) -- Line: 484
    -- upvalues: setChain (copy), NumberUtils (copy)
    local Text = p70:FindFirstChild("Text");
    local v72 = Text and Text:FindFirstChildWhichIsA("ImageLabel");

    if v72 then
        v72.Visible = false;
    end;

    local v73 = Text or p70:FindFirstChildWhichIsA("TextLabel");

    if v73 then
        setChain(v73, (`{NumberUtils.FormatWithCommas(p71)}`));
    end;
end;

local function buildRow(u74, p75) -- Line: 498
    -- upvalues: u11 (ref), AuctioneerFlags (copy), resolveRarity (copy), u6 (copy), PetSizes (copy), PetTypes (copy), u4 (copy), u3 (copy), u5 (copy), u12 (copy), setChain (copy), resolveDisplayName (copy), MailboxItemCatalog (copy), u9 (copy), u30 (copy), u7 (copy), SFX (copy), placeButton (copy), u31 (copy), setRobuxPriceFace (copy), buyLotRobux (copy), buyLot (copy), u21 (copy)
    local v76 = u11;

    if not v76 then
        return;
    end;

    local v77 = AuctioneerFlags.RobuxEnabled:Get();
    local v78;

    if u74.robuxPrice == nil then
        v78 = false;
    else
        v78 = u74.dualCurrency == true;
    end;

    if u74.robuxPrice ~= nil and not (v78 or v77) then
        return;
    end;

    local v79;

    if u74.robuxPrice == nil then
        v79 = false;
    else
        v79 = not v78 and v77;
    end;

    local v80 = v78 and v77;
    local v81 = resolveRarity(u74);
    local v82;

    if v79 then
        v82 = "RobuxFrame";
    else
        v82 = u6[v81] or "DefaultFrame";

        if u74.category == "Pets" then
            local v83 = PetSizes.Normalize(u74.size);

            if u74.type == PetTypes.Rainbow or v83 == "Huge" then
                v82 = u4;
            elseif v83 == "Big" then
                v82 = u3[math.min((u5[v82] or 1) + 1, #u3)];
            end;
        end;
    end;

    local v84 = u12[v82] or u12.DefaultFrame;

    if not v84 then
        return;
    end;

    local v85 = v84:Clone();
    v85.Name = "Lot_" .. u74.lotId;
    v85.LayoutOrder = p75;
    v85.Visible = true;
    local Frame = v85:FindFirstChild("Frame");

    if Frame then
        Frame = Frame:FindFirstChild("Main_Frame");
    end;

    if not Frame then
        v85:Destroy();

        return;
    end;

    local ItemName = Frame:FindFirstChild("ItemName");

    if ItemName then
        setChain(ItemName, resolveDisplayName(u74));
    end;

    local v87, _, v88 = pcall(function() -- Line: 296
        -- upvalues: MailboxItemCatalog (ref), u74 (copy)
        local v86 = u74;

        return MailboxItemCatalog.Resolve(u74.category, u74.item, {
            Name = v86.item,
            FruitName = v86.item,
            Mutation = v86.mutation,
            Size = v86.size,
            Type = v86.type
        });
    end);
    local v89 = (not v87 or (typeof(v88) ~= "string" or v88 == "")) and "rbxassetid://81520753924742" or v88;
    local ImageDisplay = Frame:FindFirstChild("ImageDisplay");
    local v90;

    if ImageDisplay then
        v90 = ImageDisplay:FindFirstChild("Vector");
    else
        v90 = ImageDisplay;
    end;

    if v90 and v90:IsA("ImageLabel") then
        v90.Image = v89;
    end;

    local v91;

    if ImageDisplay then
        v91 = ImageDisplay:FindFirstChild("Amount");
    else
        v91 = ImageDisplay;
    end;

    if v91 and v91:IsA("GuiObject") then
        if u74.count and u74.count > 1 then
            v91.Visible = true;
            setChain(v91, (`x{u74.count}`));
        else
            v91.Visible = false;
        end;
    end;

    local v92 = ImageDisplay or Frame;
    v92:SetAttribute("ItemToolTip", resolveDisplayName(u74));
    v92:SetAttribute("ItemToolTipImage", v89);
    v92:SetAttribute("ItemToolTipRarity", v81);
    v92:SetAttribute("ItemToolTipSubtitle", (not u74.count or u74.count <= 1) and "" or `x{u74.count}`);
    local Rarity = Frame:FindFirstChild("Rarity");

    if Rarity and Rarity:IsA("GuiObject") then
        Rarity.Visible = false;
    end;

    local RefreshIn = Frame:FindFirstChild("RefreshIn");

    if RefreshIn and RefreshIn:IsA("GuiObject") then
        local v93 = RefreshIn:FindFirstChildWhichIsA("ImageLabel");

        if v93 then
            v93.Visible = true;
        end;

        local v94 = RefreshIn:FindFirstChildOfClass("UIGradient");

        if v94 then
            v94.Color = u9;
            v94.Offset = Vector2.new(-0.5, 0);
            u30[u74.lotId] = v94;
        end;

        RefreshIn.Visible = true;
    end;

    if u7 then
        v85.MouseEnter:Connect(function() -- Line: 608
            -- upvalues: SFX (ref)
            if not SFX then
                return;
            end;

            local Hover = SFX:FindFirstChild("Hover");

            if Hover and Hover:IsA("Sound") then
                Hover.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                Hover.TimePosition = 0;
                Hover.Playing = true;
            end;
        end);
    end;

    local BuyButton = Frame:FindFirstChild("BuyButton");
    local RobuxButton = Frame:FindFirstChild("RobuxButton");

    if BuyButton and BuyButton:IsA("GuiButton") then
        if v80 then
            placeButton(BuyButton, 0.275, 0.43);
        else
            placeButton(BuyButton, 0.5, 0.88);
        end;

        if v79 then
            u31[u74.lotId] = true;
            setRobuxPriceFace(BuyButton, u74.robuxPrice);
            BuyButton.Activated:Connect(function() -- Line: 633
                -- upvalues: SFX (ref), buyLotRobux (ref), u74 (copy)
                if SFX then
                    local Click = SFX:FindFirstChild("Click");

                    if Click and Click:IsA("Sound") then
                        Click.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Click.TimePosition = 0;
                        Click.Playing = true;
                    end;
                end;

                buyLotRobux(u74);
            end);
        else
            BuyButton.Activated:Connect(function() -- Line: 638
                -- upvalues: SFX (ref), buyLot (ref), u74 (copy)
                if SFX then
                    local Click = SFX:FindFirstChild("Click");

                    if Click and Click:IsA("Sound") then
                        Click.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Click.TimePosition = 0;
                        Click.Playing = true;
                    end;
                end;

                buyLot(u74);
            end);
        end;
    end;

    if RobuxButton and RobuxButton:IsA("GuiObject") then
        RobuxButton.Visible = v80;

        if v80 and RobuxButton:IsA("GuiButton") then
            placeButton(RobuxButton, 0.725, 0.43);
            setRobuxPriceFace(RobuxButton, u74.robuxPrice);
            RobuxButton.Activated:Connect(function() -- Line: 655
                -- upvalues: SFX (ref), buyLotRobux (ref), u74 (copy)
                if SFX then
                    local Click = SFX:FindFirstChild("Click");

                    if Click and Click:IsA("Sound") then
                        Click.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Click.TimePosition = 0;
                        Click.Playing = true;
                    end;
                end;

                buyLotRobux(u74);
            end);
        end;
    end;

    v85.Parent = v76;
    u21[u74.lotId] = v85;
end;

local function rebuildRows() -- Line: 666
    -- upvalues: clearRows (copy), u16 (ref), buildRow (copy)
    clearRows();
    local v95 = #u16;

    for i, v in u16 do
        local v96;

        if v.robuxPrice == nil then
            v96 = false;
        else
            v96 = v.dualCurrency ~= true;
        end;

        if v96 then
            local i = i + v95;
        end;

        buildRow(v, i);
    end;
end;

local function updateHeader(p97) -- Line: 686
    -- upvalues: u19 (ref), u18 (ref), u20 (ref), u13 (ref), formatTimer (copy), u14 (ref), u16 (ref)
    if u19 > 0 and u18 > 0 then
        local v98 = u18 + u20;
        local v99 = u19 + v98 - p97;

        if u13 then
            u13.Text = v99 <= 0 and "Refreshing..." or "Refresh in " .. formatTimer(v99);
        end;

        if u14 and v98 > 0 then
            local v100 = math.clamp((p97 - u19) / v98, 0, 1);
            u14.Offset = Vector2.new(v100 * 1 + -0.5, 0);
        end;

        return;
    end;

    local v101 = u16[1];

    if not v101 then
        if u13 then
            u13.Text = "Refresh in --";
        end;

        return;
    end;

    local v102 = v101.expiresAt - p97;

    if u13 then
        u13.Text = v102 <= 0 and "Refreshing..." or "Refresh in " .. formatTimer(v102);
    end;

    if u14 then
        local v103 = v101.expiresAt - v101.rolledAt;

        if v103 > 0 then
            local v104 = math.clamp(1 - v102 / v103, 0, 1);
            u14.Offset = Vector2.new(v104 * 1 + -0.5, 0);
        end;
    end;
end;

local function refreshRows(p105, p106) -- Line: 732
    -- upvalues: u16 (ref), u21 (copy), u17 (ref), Auctioneer (copy), u29 (copy), u31 (copy), u23 (copy), setChain (copy), NumberUtils (copy), u24 (copy), u25 (copy), u26 (copy), u27 (ref), formatTimer (copy), u30 (copy), u32 (copy)
    for _, v in u16 do
        local v107 = u21[v.lotId];

        if v107 then
            local Frame = v107:FindFirstChild("Frame");

            if Frame then
                Frame = Frame:FindFirstChild("Main_Frame");
            end;

            if Frame then
                local v108 = u17[v.lotId];
                local v109 = Auctioneer.IsActive(v, p106, v108);
                local v110 = Auctioneer.CurrentPrice(v, p106);
                local v111;

                if v.stockQuantity == nil or v108 == nil then
                    v111 = false;
                else
                    v111 = v108 <= 0;
                end;

                local v112 = v.expiresAt <= p106;
                local v113 = v111 or v112;

                if v111 then
                    local v114 = u29[v.lotId];

                    if v114 == nil then
                        u29[v.lotId] = v110;
                    else
                        v110 = v114;
                    end;
                else
                    u29[v.lotId] = nil;
                end;

                local BuyButton = Frame:FindFirstChild("BuyButton");
                local RobuxButton = Frame:FindFirstChild("RobuxButton");
                local Stock_Text = Frame:FindFirstChild("Stock_Text");
                local RefreshIn = Frame:FindFirstChild("RefreshIn");
                local OUT_OF_STOCK = Frame:FindFirstChild("OUT_OF_STOCK");

                if OUT_OF_STOCK and OUT_OF_STOCK:IsA("GuiObject") then
                    OUT_OF_STOCK.Visible = v111;
                end;

                local EXPIRED = Frame:FindFirstChild("EXPIRED");

                if EXPIRED and EXPIRED:IsA("GuiObject") then
                    if v112 then
                        v112 = not v111;
                    end;

                    EXPIRED.Visible = v112;
                end;

                local v115;

                if BuyButton then
                    v115 = BuyButton:FindFirstChild("Text");
                else
                    v115 = BuyButton;
                end;

                if v115 and not u31[v.lotId] then
                    local v116 = u23[v.lotId];

                    if v116 ~= nil and math.abs(v116 - v110) <= v110 * 0.5 then
                        local v117 = v116 + (v110 - v116) * (1 - math.exp(-p105 * 6));

                        if math.abs(v117 - v110) >= 1 then
                            v110 = v117;
                        end;
                    end;

                    u23[v.lotId] = v110;
                    local v118 = (type(v110) ~= "number" or (v110 ~= v110 or (v110 == (1 / 0) or (v110 == (-1 / 0) or v110 < 0)))) and 0 or v110;
                    setChain(v115, NumberUtils.Abbreviate((math.floor(v118))) .. "¢");
                end;

                if Stock_Text and Stock_Text:IsA("TextLabel") then
                    if v113 then
                        Stock_Text.Text = "Sold out";
                    elseif v.stockQuantity == nil then
                        Stock_Text.Text = "";
                    else
                        local v119 = v108 or (v.stockQuantity or 0);
                        local v120 = (type(v119) ~= "number" or v119 ~= v119) and 0 or v119;
                        local v121 = math.floor(v120);
                        local v122 = math.max(0, v121);
                        local v123 = u24[v.lotId];
                        local v124 = u25[v.lotId];

                        if v123 == nil or v123 <= v122 then
                            u26[v.lotId] = nil;
                            v123 = v122;
                        elseif v122 ~= v124 then
                            local v125 = math.clamp(u27 * 1.35, 0.6, 30);
                            u26[v.lotId] = (v123 - v122) / v125;
                        end;

                        u25[v.lotId] = v122;
                        local v126 = u26[v.lotId];

                        if v126 and v122 < v123 then
                            v123 = math.max(v122, v123 - v126 * p105);
                        end;

                        u24[v.lotId] = v123;
                        local FormatWithCommas = NumberUtils.FormatWithCommas;
                        local v127 = math.round(v123);
                        Stock_Text.Text = `x{FormatWithCommas((math.max(0, v127)))} in Stock`;
                    end;
                end;

                if RefreshIn then
                    setChain(RefreshIn:FindFirstChild("Timer") or RefreshIn, formatTimer(v.expiresAt - p106));
                    local v128 = u30[v.lotId];

                    if v128 then
                        local v129 = v.expiresAt - v.rolledAt;
                        local v130 = v129 <= 0 and 1 or math.clamp((p106 - v.rolledAt) / v129, 0, 1);
                        v128.Offset = Vector2.new(v130 * 1 + -0.5, 0);
                    end;
                end;

                if RobuxButton and (RobuxButton:IsA("GuiButton") and RobuxButton.Visible) then
                    RobuxButton.Active = not v113;
                    RobuxButton.AutoButtonColor = not v113;
                    RobuxButton.BackgroundTransparency = v113 and 0.5 or 0;
                end;

                if BuyButton and BuyButton:IsA("GuiButton") then
                    if v109 then
                        v109 = os.clock() >= (u32[v.lotId] or 0);
                    end;

                    BuyButton.AutoButtonColor = v109;
                    BuyButton.BackgroundTransparency = v109 and 0 or 0.5;
                end;
            end;
        end;
    end;
end;

local function applySnapshot(p131) -- Line: 904
    -- upvalues: u16 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), rebuildRows (copy)
    if typeof(p131) ~= "table" then
        return;
    end;

    local manifest = p131.manifest;
    u16 = {};

    if typeof(manifest) == "table" and typeof(manifest.lots) == "table" then
        for _, v in manifest.lots do
            if typeof(v) == "table" and typeof(v.lotId) == "string" then
                table.insert(u16, v);
            end;
        end;
    end;

    if typeof(p131.stock) == "table" then
        u17 = p131.stock;
    end;

    if typeof(p131.rollIntervalSeconds) == "number" and p131.rollIntervalSeconds > 0 then
        u18 = p131.rollIntervalSeconds;
    end;

    if typeof(p131.rollWindowUnix) == "number" and p131.rollWindowUnix > 0 then
        u19 = p131.rollWindowUnix;
    end;

    u20 = typeof(p131.timerShiftSeconds) ~= "number" and 0 or p131.timerShiftSeconds;
    rebuildRows();
end;

local function applyStockUpdate(p132) -- Line: 932
    -- upvalues: u28 (ref), u27 (ref), u17 (ref)
    if typeof(p132) ~= "table" then
        return;
    end;

    local v133 = os.clock();

    if u28 > 0 then
        local v134 = v133 - u28;

        if v134 > 0.05 and v134 < 30 then
            local v135 = u27;
            u27 = v135 + (v134 - v135) * 0.6;
        end;
    end;

    u28 = v133;

    if typeof(p132.stock) == "table" then
        u17 = p132.stock;
    end;
end;

local function bindNpc() -- Line: 958
    -- upvalues: u15 (ref), AuctioneerFlags (copy), GuiController (copy), NPC (copy), TopText (copy), Players (copy)
    local AuctionStand = workspace:WaitForChild("AuctionStand", 30);

    if not AuctionStand then
        return;
    end;

    local u136 = nil;

    for _, descendant in AuctionStand:GetDescendants() do
        if descendant:IsA("ProximityPrompt") and descendant:GetAttribute("DontShow") == nil then
            u136 = descendant;
            break;
        end;
    end;

    if not u136 then
        return;
    end;

    u136.ObjectText = "Auctioneer";
    u136.ActionText = "Talk";
    local u137 = u136:FindFirstAncestorWhichIsA("Model");
    local u138 = nil;

    local function getInteractTrack() -- Line: 994
        -- upvalues: u138 (ref), u137 (copy)
        if u138 then
            return u138;
        end;

        if not u137 then
            return nil;
        end;

        local v139 = u137:FindFirstChildOfClass("Humanoid");
        local Animations = u137:FindFirstChild("Animations");

        if not (v139 and Animations) then
            return nil;
        end;

        local v140 = v139:FindFirstChildOfClass("Animator");
        local Interact = Animations:FindFirstChild("Interact");

        if v140 and (Interact and Interact:IsA("Animation")) then
            u138 = v140:LoadAnimation(Interact);
        end;

        return u138;
    end;

    local u141 = nil;
    local u144 = (function() -- Line: 1015, Name: getIdleTrack
        -- upvalues: u141 (ref), u137 (copy)
        if u141 then
            return u141;
        end;

        if not u137 then
            return nil;
        end;

        local v142 = u137:FindFirstChildOfClass("Humanoid");
        local Animations = u137:FindFirstChild("Animations");

        if not (v142 and Animations) then
            return nil;
        end;

        local v143 = v142:FindFirstChildOfClass("Animator");
        local Idle = Animations:FindFirstChild("Idle");

        if v143 and (Idle and Idle:IsA("Animation")) then
            u141 = v143:LoadAnimation(Idle);
        end;

        return u141;
    end)();

    if u144 then
        u144:Play(0.1, 1, 1);
    end;

    local u145 = AuctionStand:FindFirstChildWhichIsA("BillboardGui", true);
    local u146 = u15;

    local function syncEnabled() -- Line: 1046
        -- upvalues: AuctioneerFlags (ref), u146 (copy), u136 (ref), u145 (copy)
        local v147 = workspace:GetAttribute("AuctionStandOverride");
        local v148;

        if v147 == "on" then
            v148 = true;
        elseif v147 == "off" then
            v148 = false;
        else
            v148 = AuctioneerFlags.Enabled:Get() and AuctioneerFlags.OpenEnabled:Get();
        end;

        local v149;

        if u146 == nil then
            v149 = false;
        else
            v149 = u146.Enabled;
        end;

        local v150;

        if v148 then
            v150 = not v149;
        else
            v150 = v148;
        end;

        u136.Enabled = v150;

        if u145 then
            if v148 then
                v148 = not v149;
            end;

            u145.Enabled = v148;
        end;
    end;

    local v151 = workspace:GetAttribute("AuctionStandOverride");
    local v152;

    if v151 == "on" then
        v152 = true;
    elseif v151 == "off" then
        v152 = false;
    else
        v152 = AuctioneerFlags.Enabled:Get() and AuctioneerFlags.OpenEnabled:Get();
    end;

    local v153;

    if u146 == nil then
        v153 = false;
    else
        v153 = u146.Enabled;
    end;

    local v154;

    if v152 then
        v154 = not v153;
    else
        v154 = v152;
    end;

    u136.Enabled = v154;

    if u145 then
        if v152 then
            v152 = not v153;
        end;

        u145.Enabled = v152;
    end;

    AuctioneerFlags.OpenEnabled.Changed:Connect(syncEnabled);
    AuctioneerFlags.Enabled.Changed:Connect(syncEnabled);
    workspace:GetAttributeChangedSignal("AuctionStandOverride"):Connect(syncEnabled);

    if u146 then
        u146:GetPropertyChangedSignal("Enabled"):Connect(syncEnabled);
    end;

    u136.Triggered:Connect(function() -- Line: 1069
        -- upvalues: AuctioneerFlags (ref), GuiController (ref), NPC (ref), u136 (ref), getInteractTrack (copy), u144 (copy), u137 (copy), TopText (ref), Players (ref), u146 (copy), u145 (copy)
        local v155 = workspace:GetAttribute("AuctionStandOverride");
        local v156;

        if v155 == "on" then
            v156 = true;
        elseif v155 == "off" then
            v156 = false;
        else
            v156 = AuctioneerFlags.Enabled:Get() and AuctioneerFlags.OpenEnabled:Get();
        end;

        if not v156 then
            return;
        end;

        if GuiController:IsOpen("Auction") then
            return;
        end;

        if not NPC.CanSpeak() then
            return;
        end;

        task.spawn(function() -- Line: 1081
            -- upvalues: NPC (ref), u136 (ref), getInteractTrack (ref), u144 (ref), u137 (ref), TopText (ref), AuctioneerFlags (ref), GuiController (ref), Players (ref), u146 (ref), u145 (ref)
            NPC.StartSpeaking();
            u136.Enabled = false;
            local v157 = getInteractTrack();

            if v157 then
                u144:Stop(0.1);
                v157:Play(0.1, 100, 1);
                print("PLAY");
                task.spawn(function() -- Line: 1091
                    -- upvalues: u144 (ref)
                    task.wait(1.95);
                    u144:Play(0.1, 1, 1);
                end);
            end;

            local success = pcall(function() -- Line: 1098
                -- upvalues: u137 (ref), TopText (ref), AuctioneerFlags (ref), GuiController (ref)
                if u137 then
                    TopText.NpcText(u137, "Step right up! Here\'s what\'s on the block today!", true);
                    task.wait(1.0830302779823362);
                end;

                local v158 = workspace:GetAttribute("AuctionStandOverride");
                local v159;

                if v158 == "on" then
                    v159 = true;
                elseif v158 == "off" then
                    v159 = false;
                else
                    v159 = AuctioneerFlags.Enabled:Get() and AuctioneerFlags.OpenEnabled:Get();
                end;

                if v159 and not GuiController:IsOpen("Auction") then
                    GuiController:Open("Auction", nil, { "HUD" });
                end;

                task.wait(0.4);
            end);

            if u137 then
                TopText.TakeAwayResponses(u137, Players.LocalPlayer);
            end;

            NPC.EndSpeaking();
            local v160 = workspace:GetAttribute("AuctionStandOverride");
            local v161;

            if v160 == "on" then
                v161 = true;
            elseif v160 == "off" then
                v161 = false;
            else
                v161 = AuctioneerFlags.Enabled:Get() and AuctioneerFlags.OpenEnabled:Get();
            end;

            local v162;

            if u146 == nil then
                v162 = false;
            else
                v162 = u146.Enabled;
            end;

            local v163;

            if v161 then
                v163 = not v162;
            else
                v163 = v161;
            end;

            u136.Enabled = v163;

            if u145 then
                if v161 then
                    v161 = not v162;
                end;

                u145.Enabled = v161;
            end;

            if not success then
                warn("Auctioneer dialogue failed");
            end;
        end);
    end);
end;

local function bindHudButton() -- Line: 1129
    -- upvalues: Players (copy), AuctioneerFlags (copy)
    local LocalPlayer = Players.LocalPlayer;
    local TeleportButtons = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TeleportButtons", 30);

    if TeleportButtons then
        TeleportButtons = TeleportButtons:WaitForChild("TeleportButtons", 30);
    end;

    if TeleportButtons then
        TeleportButtons = TeleportButtons:WaitForChild("Auction", 30);
    end;

    if not (TeleportButtons and TeleportButtons:IsA("TextButton")) then
        return;
    end;

    local function syncVisible() -- Line: 1139
        -- upvalues: TeleportButtons (copy)
        TeleportButtons.Visible = false;
    end;

    TeleportButtons.Visible = false;
    AuctioneerFlags.Enabled.Changed:Connect(syncVisible);
    AuctioneerFlags.OpenEnabled.Changed:Connect(syncVisible);
    LocalPlayer:GetAttributeChangedSignal("AuctionButtonOverride"):Connect(syncVisible);
    workspace:GetAttributeChangedSignal("AuctionStandOverride"):Connect(syncVisible);
    LocalPlayer:GetAttributeChangedSignal("IsStealingFruit"):Connect(syncVisible);
    LocalPlayer:GetAttributeChangedSignal("CarryingStolenFruit"):Connect(syncVisible);
end;

local function setup() -- Line: 1159
    -- upvalues: Players (copy), u15 (ref), u11 (ref), u6 (copy), u12 (copy), u13 (ref), u14 (ref), GuiController (copy), Networking (copy), applySnapshot (copy), applyStockUpdate (copy), u22 (copy), u32 (copy), AuctioneerFlags (copy), rebuildRows (copy), RunService (copy), updateHeader (copy), refreshRows (copy), bindNpc (copy), bindHudButton (copy)
    local Auction = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Auction");

    if Auction:IsA("ScreenGui") then
        Auction.Enabled = false;
        u15 = Auction;
    end;

    local Frame = Auction:WaitForChild("Frame");
    local Header = Frame:WaitForChild("Header");
    u11 = Frame:WaitForChild("ScrollingFrame");
    local v164 = {};

    for _, v in u6 do
        if not v164[v] then
            v164[v] = true;
            local v165 = u11:FindFirstChild(v);

            if v165 and v165:IsA("Frame") then
                u12[v] = v165;
            end;
        end;
    end;

    u12.DefaultFrame = u11:WaitForChild("DefaultFrame");
    u12.RobuxFrame = u11:WaitForChild("RobuxFrame");

    for _, v in u12 do
        v.Visible = false;
        v.Parent = nil;
    end;

    local RefreshIn = Header:FindFirstChild("RefreshIn");

    if RefreshIn then
        u13 = RefreshIn:FindFirstChild("Timer");
        u14 = RefreshIn:FindFirstChildOfClass("UIGradient");
    end;

    local ExitButton = Header:FindFirstChild("ExitButton");

    if ExitButton and ExitButton:IsA("GuiButton") then
        ExitButton.Activated:Connect(function() -- Line: 1201
            -- upvalues: GuiController (ref)
            GuiController:Close();
        end);
    end;

    Networking.Auctioneer.Snapshot.OnClientEvent:Connect(applySnapshot);
    Networking.Auctioneer.StockUpdate.OnClientEvent:Connect(applyStockUpdate);
    Networking.Auctioneer.PurchaseResult.OnClientEvent:Connect(function(p166, p167, p168) -- Line: 1210
        -- upvalues: u22 (ref), u32 (ref)
        u22[p166] = nil;

        if not p167 then
            u32[p166] = nil;
        end;
    end);
    AuctioneerFlags.RobuxEnabled.Changed:Connect(rebuildRows);
    task.spawn(function() -- Line: 1232
        -- upvalues: Networking (ref), applySnapshot (ref)
        local success, result = pcall(function() -- Line: 1233
            -- upvalues: Networking (ref)
            return Networking.Auctioneer.RequestSnapshot:Fire();
        end);

        if success and result ~= nil then
            applySnapshot(result);
        end;
    end);
    RunService.RenderStepped:Connect(function(p169) -- Line: 1244
        -- upvalues: Auction (copy), updateHeader (ref), refreshRows (ref)
        if not Auction.Enabled then
            return;
        end;

        local success, result = pcall(function() -- Line: 240
            return workspace:GetServerTimeNow();
        end);

        if not success then
            result = os.time();
        end;

        updateHeader(result);
        refreshRows(p169, result);
    end);
    task.spawn(bindNpc);
    task.spawn(bindHudButton);
end;

function v10.Init(p170) -- Line: 1264
end;

function v10.Start(p171) -- Line: 1266
    -- upvalues: setup (copy)
    task.spawn(setup);
end;

return v10;