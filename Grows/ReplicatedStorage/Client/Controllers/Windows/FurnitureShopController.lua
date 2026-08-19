-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarketplaceService = game:GetService("MarketplaceService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local DecorAssets = require(ReplicatedStorage.Shared.Utility.DecorAssets);
local FurnitureShopConfig = require(ReplicatedStorage.Shared.Info.FurnitureShopConfig);
local Products = require(ReplicatedStorage.Shared.Info.Products);
local v1 = Knit.CreateController({
    Name = "FurnitureShopController"
});
local u2 = Color3.fromRGB(157, 97, 68);
local u3 = Color3.fromRGB(189, 116, 82);
local u4 = {
    ["Small Wood Bench 2"] = 180,
    ["Large Wood Bench 2"] = 180,
    ["Fish Pond"] = 180
};
local u5 = {};

local function getProductPrice(u6) -- Line: 26
    -- upvalues: u5 (copy), MarketplaceService (copy)
    if u5[u6] then
        return u5[u6];
    end;

    local success, result = pcall(function() -- Line: 28
        -- upvalues: MarketplaceService (ref), u6 (copy)
        return MarketplaceService:GetProductInfo(u6, Enum.InfoType.Product);
    end);

    if not (success and (result and result.PriceInRobux)) then
        return nil;
    end;

    u5[u6] = result.PriceInRobux;

    return result.PriceInRobux;
end;

local function splitName(p7) -- Line: 38
    local v8 = {};

    for i in p7:gmatch("%S+") do
        table.insert(v8, i);
    end;

    if #v8 <= 1 then
        return p7, "";
    end;

    local v9 = math.ceil(#v8 / 2);

    return table.concat(v8, " ", 1, v9), table.concat(v8, " ", v9 + 1);
end;

function v1.KnitStart(p10) -- Line: 46
    -- upvalues: Players (copy), Knit (copy), DecorAssets (copy), u4 (copy), u3 (copy), u2 (copy), splitName (copy), FurnitureShopConfig (copy), Products (copy), u5 (copy), MarketplaceService (copy)
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local u11 = Knit.GetService("FurnitureShopService");
    local u12 = Knit.GetService("FarmersMarketService");
    local UI_Manager = p10.UI_Manager;
    local DataClient = p10.DataClient;
    local SoundController = p10.SoundController;
    local FurnitureShop = PlayerGui:WaitForChild("Windows"):WaitForChild("FurnitureShop");
    local Exit = FurnitureShop.Top:WaitForChild("Exit");
    local Button = FurnitureShop.Top:WaitForChild("GetTicketsButton"):WaitForChild("Button");
    local ItemHolder = FurnitureShop.Content:WaitForChild("Sort"):WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder");
    local ItemHolder2 = FurnitureShop.Content:WaitForChild("FurnitureList"):WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder");
    local u13 = ItemHolder:WaitForChild("Button"):Clone();
    local u14 = nil;

    for _, child in ItemHolder:GetChildren() do
        if child:IsA("Frame") and child.Name == "Button" then
            child:Destroy();
        end;
    end;

    local u15 = ItemHolder2:WaitForChild("Cell"):Clone();

    for _, child in ItemHolder2:GetChildren() do
        if child:IsA("Frame") and child.Name == "Cell" then
            child:Destroy();
        end;
    end;

    local u16 = nil;
    local u17 = {};

    local function renderModelViewport(p18, p19, p20) -- Line: 80
        -- upvalues: DecorAssets (ref), u4 (ref)
        for _, child in p18:GetChildren() do
            if child:IsA("Model") or child:IsA("Camera") then
                child:Destroy();
            end;
        end;

        local ImageLabel = p18.Parent:FindFirstChild("ImageLabel");

        if ImageLabel then
            ImageLabel.Visible = false;
        end;

        p18.ZIndex = 3;
        local v21 = DecorAssets.resolveTemplate(p19, p20);

        if not v21 then
            return;
        end;

        local v22 = v21:Clone();

        for _, descendant in v22:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;

                if descendant.Name == "SpawnPart" then
                    descendant.Transparency = 1;
                end;
            end;

            if descendant:IsA("Script") or (descendant:IsA("LocalScript") or descendant:IsA("ProximityPrompt")) then
                descendant:Destroy();
            end;
        end;

        local v23, v24 = v22:GetBoundingBox();
        v22:PivotTo(v22:GetPivot() + (Vector3.new(0, 0, 0) - v23.Position));
        local v25 = u4[p20];

        if v25 then
            v22:PivotTo(CFrame.Angles(0, math.rad(v25), 0) * v22:GetPivot());
        end;

        v22.Parent = p18;
        local Camera = Instance.new("Camera");
        Camera.FieldOfView = 40;
        local v26 = v24.Magnitude * 1.1 + 2;
        Camera.CFrame = CFrame.lookAt(Vector3.new(v26 * 0.7, v24.Y * 0.5 + v26 * 0.4, v26 * 0.7), Vector3.new(0, 0, 0));
        Camera.Parent = p18;
        p18.CurrentCamera = Camera;
        p18.Ambient = Color3.fromRGB(200, 200, 200);
        p18.LightColor = Color3.fromRGB(255, 255, 255);
    end;

    local function showCategory(u27) -- Line: 122
        -- upvalues: u16 (ref), u17 (copy), u3 (ref), u2 (ref), ItemHolder2 (copy), u15 (copy), splitName (ref), renderModelViewport (copy), UI_Manager (copy), u11 (copy), SoundController (copy), LocalPlayer (copy)
        u16 = u27;

        for i, v in u17 do
            v.BackgroundColor3 = i == u27 and u3 or u2;
        end;

        for _, child in ItemHolder2:GetChildren() do
            if child:IsA("Frame") and child.Name == "Cell" then
                child:Destroy();
            end;
        end;

        for i, v in u27.items do
            local v28 = u15:Clone();
            v28.LayoutOrder = i;
            local v29, v30 = splitName(v.id);

            if v28:FindFirstChild("Line1") then
                v28.Line1.Text = v29;
            end;

            if v28:FindFirstChild("Line2") then
                v28.Line2.Text = v30;
            end;

            local v31 = v28:FindFirstChild("NO STOCK");

            if v31 then
                v31.Visible = false;
            end;

            local Stock = v28:FindFirstChild("Stock");

            if Stock then
                Stock.Visible = false;
            end;

            local ViewportFrame = v28.Furniture:FindFirstChild("ViewportFrame");

            if ViewportFrame then
                renderModelViewport(ViewportFrame, u27.type, v.id);
            end;

            local Button2 = v28.BuyButton.Button;
            local Price = Button2:FindFirstChild("Price");
            local Tickets = Button2:FindFirstChild("Tickets");

            if Price then
                Price.Text = tostring(v.price);
            end;

            if Price and Tickets then
                local v32 = #tostring(v.price);
                local v33 = 0.447;
                local v34 = 0.5;

                if v32 <= 1 then
                    v33 = 0.56;
                    v34 = 0.615;
                elseif v32 == 2 then
                    v33 = 0.507;
                    v34 = 0.561;
                end;

                Tickets.Position = UDim2.new(v33, 0, 0.5, 0);
                Price.Position = UDim2.new(v34, 0, 0.5, 0);
            end;

            UI_Manager:AddBounceButton(Button2, 1.05, false);
            Button2.Activated:Connect(function() -- Line: 160
                -- upvalues: u11 (ref), u27 (copy), v (copy), SoundController (ref), LocalPlayer (ref)
                local v35, v36 = u11:BuyFurniture(u27.type, v.id):await();

                if v35 and v36 then
                    SoundController:PlaySound("ShopBuy", LocalPlayer);
                end;
            end);
            v28.Parent = ItemHolder2;
        end;
    end;

    local function buildTabs() -- Line: 175
        -- upvalues: ItemHolder (copy), u17 (copy), FurnitureShopConfig (ref), u13 (copy), u2 (ref), UI_Manager (copy), showCategory (copy)
        for _, child in ItemHolder:GetChildren() do
            if child:IsA("Frame") and child.Name == "Button" then
                child:Destroy();
            end;
        end;

        table.clear(u17);

        for i, v in FurnitureShopConfig.Categories do
            local v37 = u13:Clone();
            v37.LayoutOrder = i;
            local Button2 = v37:FindFirstChild("Button");
            local v38;

            if Button2 then
                v38 = Button2:FindFirstChild("Identifier");
            else
                v38 = Button2;
            end;

            if v38 then
                v38.Text = v.name;
            end;

            if Button2 then
                Button2.BackgroundColor3 = u2;
                u17[v] = Button2;
                UI_Manager:AddBounceButton(Button2, 1.05, false);
                Button2.Activated:Connect(function() -- Line: 190
                    -- upvalues: showCategory (ref), v (copy)
                    showCategory(v);
                end);
            end;

            v37.Parent = ItemHolder;
        end;
    end;

    local Limited = FurnitureShop.Content:WaitForChild("Limited");
    local Reward = Limited:WaitForChild("Reward");
    local Timer = Limited:WaitForChild("Timer");
    local Button2 = Limited.Buttons.BuyButton.Button;
    local RobuxButton = Limited.Buttons.RobuxButton;
    local Button3 = RobuxButton.Button;
    local u39 = nil;
    local u40 = 0;

    local function formatLimitedTimer(p41) -- Line: 210
        local v42 = math.floor(p41);
        local v43 = math.max(0, v42);
        local v44 = math.floor(v43 / 86400);
        local v45 = math.floor(v43 % 86400 / 3600);
        local v46 = math.floor(v43 % 3600 / 60);
        local v47 = v43 % 60;

        if v44 > 0 then
            return string.format("%dd %dh %dm", v44, v45, v46);
        end;

        if v45 > 0 then
            return string.format("%dh %dm %ds", v45, v46, v47);
        end;

        return string.format("%dm %ds", v46, v47);
    end;

    local function populateLimited() -- Line: 221
        -- upvalues: FurnitureShopConfig (ref), u39 (ref), u40 (ref), Reward (copy), renderModelViewport (copy), Button2 (copy), Products (ref), RobuxButton (copy), Button3 (copy), u5 (ref), MarketplaceService (ref)
        local v48, v49 = FurnitureShopConfig.GetLimitedOffer(workspace:GetServerTimeNow());
        u39 = v48;
        u40 = v49;
        Reward.TextLabel.Text = v48.id;
        renderModelViewport(Reward.ViewportFrame, "Limited", v48.id);
        local Price = Button2:FindFirstChild("Price");

        if Price then
            Price.Text = tostring(v48.price);
        end;

        local u50 = Products["Tickets" .. tostring(v48.price)];
        RobuxButton.Visible = u50 ~= nil;

        if u50 then
            local Price2 = Button3:FindFirstChild("Price");
            local v51 = u5[u50.Id];

            if v51 and Price2 then
                Price2.Text = tostring(v51);

                return;
            end;

            if Price2 then
                task.spawn(function() -- Line: 238
                    -- upvalues: u50 (copy), u5 (ref), MarketplaceService (ref), Price2 (copy)
                    local Id = u50.Id;
                    local v52;

                    if u5[Id] then
                        v52 = u5[Id];
                    else
                        local success, result = pcall(function() -- Line: 28
                            -- upvalues: MarketplaceService (ref), Id (copy)
                            return MarketplaceService:GetProductInfo(Id, Enum.InfoType.Product);
                        end);

                        if success and (result and result.PriceInRobux) then
                            u5[Id] = result.PriceInRobux;
                            v52 = result.PriceInRobux;
                        else
                            v52 = nil;
                        end;
                    end;

                    if v52 then
                        Price2.Text = tostring(v52);
                    end;
                end);
            end;
        end;
    end;

    task.spawn(function() -- Line: 247
        -- upvalues: FurnitureShopConfig (ref), Products (ref), u5 (ref), MarketplaceService (ref)
        local v53 = FurnitureShopConfig.GetLimitedOffer(workspace:GetServerTimeNow());

        if v53 then
            v53 = Products["Tickets" .. tostring(v53.price)];
        end;

        if v53 then
            local Id = v53.Id;

            if u5[Id] then
                local _ = u5[Id];

                return;
            end;

            local success, result = pcall(function() -- Line: 28
                -- upvalues: MarketplaceService (ref), Id (copy)
                return MarketplaceService:GetProductInfo(Id, Enum.InfoType.Product);
            end);

            if success and (result and result.PriceInRobux) then
                u5[Id] = result.PriceInRobux;
                local _ = result.PriceInRobux;
            end;
        end;
    end);
    UI_Manager:AddBounceButton(Button2, 1.05, false);
    Button2.Activated:Connect(function() -- Line: 254
        -- upvalues: u39 (ref), u11 (copy), SoundController (copy), LocalPlayer (copy)
        if not u39 then
            return;
        end;

        local v54, v55 = u11:BuyFurniture("Limited", u39.id):await();

        if v54 and v55 then
            SoundController:PlaySound("ShopBuy", LocalPlayer);
        end;
    end);
    UI_Manager:AddBounceButton(Button3, 1.05, false);
    Button3.Activated:Connect(function() -- Line: 263
        -- upvalues: u39 (ref), Products (ref), u12 (copy)
        if not u39 then
            return;
        end;

        local v56 = "Tickets" .. tostring(u39.price);

        if Products[v56] then
            u12.purchaseTickets:Fire(v56, nil);
        end;
    end);
    task.spawn(function() -- Line: 270
        -- upvalues: u39 (ref), u40 (ref), populateLimited (copy), Timer (copy), formatLimitedTimer (copy)
        while true do
            repeat
                task.wait(1);
            until u39;

            local v57 = workspace:GetServerTimeNow();

            if u40 <= v57 then
                populateLimited();
            end;

            Timer.Text = formatLimitedTimer(u40 - v57);
        end;
    end);
    local u58 = false;

    local function open() -- Line: 286
        -- upvalues: u58 (ref), buildTabs (copy), populateLimited (copy), showCategory (copy), FurnitureShopConfig (ref), UI_Manager (copy), FurnitureShop (copy), u14 (ref), u11 (copy)
        if not u58 then
            buildTabs();
            u58 = true;
        end;

        populateLimited();
        showCategory(FurnitureShopConfig.Categories[1]);
        UI_Manager:OpenWindow(FurnitureShop, true);

        if u14 and u14.Enabled then
            u14.Enabled = false;
            u11:MarkOpened();
        end;
    end;

    UI_Manager:AddBounceButton(Exit, 1.05, true);
    Exit.Activated:Connect(function() -- Line: 302
        -- upvalues: UI_Manager (copy), FurnitureShop (copy)
        UI_Manager:CloseWindow(FurnitureShop, true);
    end);
    UI_Manager:AddBounceButton(Button, 1.05, false);
    Button.Activated:Connect(function() -- Line: 306
        -- upvalues: UI_Manager (copy), FurnitureShop (copy), LocalPlayer (copy), Knit (ref)
        UI_Manager:CloseWindow(FurnitureShop, true);
        local MarketStand = workspace.BigField:FindFirstChild("MarketStand");
        local v59;

        if MarketStand then
            v59 = MarketStand:FindFirstChild("MarketTP");
        else
            v59 = MarketStand;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if v59 and Character then
            local v60 = v59.Position + Vector3.new(0, 3, 0);
            local PromptHolder = MarketStand:FindFirstChild("PromptHolder");
            local v61 = PromptHolder and PromptHolder.Position or v59.Position + v59.CFrame.LookVector * 4;
            Character.CFrame = CFrame.lookAt(v60, (Vector3.new(v61.X, v60.Y, v61.Z)));
            Character.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        end;

        local v62 = Knit.GetController("FarmersMarketController");

        if v62 and v62.OpenMarket then
            v62.OpenMarket();
        end;
    end);
    task.spawn(function() -- Line: 332
        -- upvalues: u14 (ref), DataClient (copy), open (copy)
        local PromptHolder = workspace:WaitForChild("BigField"):WaitForChild("FurnitureStand"):WaitForChild("PromptHolder");
        local ProximityPrompt = PromptHolder:WaitForChild("ProximityPrompt");
        local RebirthReq = PromptHolder:WaitForChild("RebirthReq");
        u14 = PromptHolder:WaitForChild("Alert");

        local function refreshStand() -- Line: 339
            -- upvalues: DataClient (ref), RebirthReq (copy), ProximityPrompt (copy), u14 (ref)
            local currentData = DataClient.currentData;
            local v63 = (currentData and (currentData.Rebirth or 0) or 0) >= 4;
            RebirthReq.Enabled = not v63;
            ProximityPrompt.Enabled = v63;

            if v63 then
                if currentData then
                    currentData = currentData.OpenedFurnitureShop == true;
                end;

                v63 = not currentData;
            end;

            u14.Enabled = v63;
        end;

        local currentData = DataClient.currentData;
        local v64 = (currentData and (currentData.Rebirth or 0) or 0) >= 4;
        RebirthReq.Enabled = not v64;
        ProximityPrompt.Enabled = v64;

        if v64 then
            if currentData then
                currentData = currentData.OpenedFurnitureShop == true;
            end;

            v64 = not currentData;
        end;

        u14.Enabled = v64;
        DataClient.EV_UPDATE:Connect(refreshStand);
        ProximityPrompt.Triggered:Connect(function() -- Line: 349
            -- upvalues: DataClient (ref), open (ref)
            if (DataClient.currentData and DataClient.currentData.Rebirth or 0) >= 4 then
                open();
            end;
        end);
    end);
end;

function v1.KnitInit(p65) -- Line: 355
    -- upvalues: Knit (copy)
    p65.UI_Manager = Knit.GetController("UI_Manager");
    p65.DataClient = Knit.GetController("DataClient");
    p65.SoundController = Knit.GetController("SoundController");
end;

return v1;