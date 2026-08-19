-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Knit = require(ReplicatedStorage.Packages.Knit);
local PetConfig = require(ReplicatedStorage.Shared.Info.PetConfig);
local PetAssets = require(ReplicatedStorage.Shared.Utility.PetAssets);
local Constants = require(ReplicatedStorage.Shared.Info.Constants);
require(ReplicatedStorage.Shared.Utility.AbbreviateNumber);
local v1 = Knit.CreateController({
    Name = "PetShopController"
});

local function renderModelViewport(p2, p3, p4) -- Line: 16
    for _, child in p2:GetChildren() do
        if child:IsA("Model") or child:IsA("Camera") then
            child:Destroy();
        end;
    end;

    if not p3 then
        return;
    end;

    local ImageLabel = p2.Parent:FindFirstChild("ImageLabel");

    if ImageLabel then
        ImageLabel.Visible = false;
    end;

    p2.ZIndex = 3;
    local v5 = p3:Clone();

    for _, descendant in v5:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
        end;

        if descendant:IsA("Script") or (descendant:IsA("LocalScript") or descendant:IsA("ProximityPrompt")) then
            descendant:Destroy();
        end;
    end;

    local v6, v7 = v5:GetBoundingBox();
    v5:PivotTo(v5:GetPivot() + (Vector3.new(0, 0, 0) - v6.Position));

    if p4 then
        v5:PivotTo(CFrame.Angles(0, p4, 0) * v5:GetPivot());
    end;

    v5.Parent = p2;
    local Camera = Instance.new("Camera");
    Camera.FieldOfView = 40;
    local v8 = v7.Magnitude * 1.1 + 2;
    Camera.CFrame = CFrame.lookAt(Vector3.new(v8 * 0.7, v7.Y * 0.5 + v8 * 0.4, v8 * 0.7), Vector3.new(0, 0, 0));
    Camera.Parent = p2;
    p2.CurrentCamera = Camera;
    p2.Ambient = Color3.fromRGB(200, 200, 200);
    p2.LightColor = Color3.new(1, 1, 1);
end;

local function renderAnimatedPet(p9, p10) -- Line: 48
    -- upvalues: PetConfig (copy), PetAssets (copy), renderModelViewport (copy)
    local v11 = PetConfig.GetPet(p10);
    local v12 = v11 and v11.rig and PetAssets.resolveRig(v11.rig);

    if not (v12 and v11.idleAnim) then
        renderModelViewport(p9, PetAssets.resolvePet(p10));

        return;
    end;

    for _, child in p9:GetChildren() do
        if child:IsA("Model") or (child:IsA("Camera") or child:IsA("WorldModel")) then
            child:Destroy();
        end;
    end;

    local ImageLabel = p9.Parent:FindFirstChild("ImageLabel");

    if ImageLabel then
        ImageLabel.Visible = false;
    end;

    p9.ZIndex = 3;
    local WorldModel = Instance.new("WorldModel");
    WorldModel.Parent = p9;
    local v13 = v12:Clone();
    local v14 = {};

    for _, descendant in v13:GetDescendants() do
        if descendant:IsA("Motor6D") then
            if descendant.Part0 then
                v14[descendant.Part0] = true;
            end;

            if descendant.Part1 then
                v14[descendant.Part1] = true;
            end;
        end;
    end;

    for _, descendant in v13:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.CanCollide = false;

            if v14[descendant] then
                descendant.Transparency = 1;
            end;
        end;

        if descendant:IsA("Script") or (descendant:IsA("LocalScript") or descendant:IsA("ProximityPrompt")) then
            descendant:Destroy();
        end;
    end;

    if v13.PrimaryPart then
        v13.PrimaryPart.Anchored = true;
    end;

    local v15, v16 = v13:GetBoundingBox();
    v13:PivotTo(v13:GetPivot() + (Vector3.new(0, 0, 0) - v15.Position));
    v13:PivotTo(CFrame.Angles(0, -1.5707963267948966, 0) * v13:GetPivot());
    v13.Parent = WorldModel;
    local v17 = v13:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController");
    local u18 = v17:FindFirstChildOfClass("Animator") or Instance.new("Animator");
    u18.Parent = v17;
    v17.Parent = v13;
    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://" .. tostring(v11.idleAnim);
    local success, result = pcall(function() -- Line: 99
        -- upvalues: u18 (copy), Animation (copy)
        return u18:LoadAnimation(Animation);
    end);

    if success and result then
        result.Looped = true;
        result:Play(0);
    end;

    local Camera = Instance.new("Camera");
    Camera.FieldOfView = 40;
    local v19 = v16.Magnitude * 1.1 + 2;
    Camera.CFrame = CFrame.lookAt(Vector3.new(v19 * 0.7, v16.Y * 0.5 + v19 * 0.4, v19 * 0.7), Vector3.new(0, 0, 0));
    Camera.Parent = p9;
    p9.CurrentCamera = Camera;
    p9.Ambient = Color3.fromRGB(200, 200, 200);
    p9.LightColor = Color3.new(1, 1, 1);
end;

local function applyTicketPrice(p20, p21) -- Line: 116
    local Price = p20:FindFirstChild("Price");
    local Tickets = p20:FindFirstChild("Tickets");

    if Price then
        Price.Text = tostring(p21);
    end;

    if Price and Tickets then
        local v22 = #tostring(p21);
        local v23 = 0.447;
        local v24 = 0.5;

        if v22 <= 1 then
            v23 = 0.56;
            v24 = 0.615;
        elseif v22 == 2 then
            v23 = 0.507;
            v24 = 0.561;
        end;

        Tickets.Position = UDim2.new(v23, 0, 0.5, 0);
        Price.Position = UDim2.new(v24, 0, 0.5, 0);
    end;
end;

function v1.KnitStart(u25) -- Line: 130
    -- upvalues: Players (copy), Knit (copy), PetConfig (copy), applyTicketPrice (copy), Constants (copy), renderAnimatedPet (copy), renderModelViewport (copy), PetAssets (copy)
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local u26 = Knit.GetService("PetsService");
    local UI_Manager = u25.UI_Manager;
    local DataClient = u25.DataClient;
    local SoundController = u25.SoundController;
    local u27 = nil;
    local Windows = PlayerGui:WaitForChild("Windows");
    local PetShop = Windows:WaitForChild("PetShop");
    local Exit = PetShop.Top:WaitForChild("Exit");
    local Button = PetShop.Top:WaitForChild("GetTicketsButton"):WaitForChild("Button");
    local ItemHolder = PetShop.Content:WaitForChild("EggList"):WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder");
    local EggContent = Windows:WaitForChild("EggContent");
    local Exit2 = EggContent.Top:WaitForChild("Exit");
    local Cash = EggContent.Top:FindFirstChild("Cash");
    local Pets = EggContent.Content:WaitForChild("Pets");
    local BuyButton = EggContent:FindFirstChild("BuyButton");
    local u28 = BuyButton and BuyButton:FindFirstChild("Button");
    local u29 = ItemHolder:WaitForChild("Cell"):Clone();

    for _, child in ItemHolder:GetChildren() do
        if child:IsA("Frame") and child.Name == "Cell" then
            child:Destroy();
        end;
    end;

    local u30 = Pets:WaitForChild("Egg"):Clone();

    for _, child in Pets:GetChildren() do
        if child:IsA("Frame") and child.Name == "Egg" then
            child:Destroy();
        end;
    end;

    local u31 = nil;

    local function buyEgg(p32) -- Line: 166
        -- upvalues: u26 (copy), SoundController (copy), LocalPlayer (copy)
        local v33, v34 = u26:BuyEgg(p32):await();

        if v33 and v34 then
            SoundController:PlaySound("ShopBuy", LocalPlayer);
        end;
    end;

    local u35 = {};

    local function clearHoverCells() -- Line: 179
        -- upvalues: u35 (ref), u25 (copy)
        for _, v in u35 do
            u25.HoverDescriptions:RemoveHoverCell(v);
        end;

        u35 = {};
    end;

    EggContent:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 186
        -- upvalues: EggContent (copy), clearHoverCells (copy)
        if EggContent.Visible == false then
            clearHoverCells();
        end;
    end);

    local function showEggContent(p36) -- Line: 192
        -- upvalues: PetConfig (ref), u31 (ref), Cash (copy), u28 (ref), applyTicketPrice (ref), clearHoverCells (copy), Pets (copy), u30 (copy), u25 (copy), u35 (ref), Constants (ref), renderAnimatedPet (ref), UI_Manager (copy), EggContent (copy)
        local v37 = PetConfig.Eggs[p36];

        if not v37 then
            return;
        end;

        u31 = p36;

        if Cash then
            Cash.Text = string.upper(v37.displayName .. " EGG");
        end;

        if u28 then
            applyTicketPrice(u28, v37.price);
        end;

        clearHoverCells();

        for _, child in Pets:GetChildren() do
            if child:IsA("Frame") and child.Name == "Egg" then
                child:Destroy();
            end;
        end;

        for i, v in PetConfig.GetEggChances(p36) do
            local v38 = u30:Clone();
            v38.LayoutOrder = i;
            local v39 = PetConfig.GetPet(v.pet);
            u25.HoverDescriptions:SetupHoverCell(v38, tostring(v39.trait), nil, function() -- Line: 212
            end, true);
            table.insert(u35, v38);
            local PetName = v38:FindFirstChild("PetName");

            if PetName then
                PetName.Text = v.pet;

                if v39 then
                    v39 = Constants.RARITY_COLORS[v39.rarity];
                end;

                if v39 then
                    PetName.TextColor3 = v39;
                end;
            end;

            local Chance = v38:FindFirstChild("Chance");

            if Chance then
                Chance.Text = string.format("%.2f%%", v.chance * 100);
            end;

            local ViewportFrame = v38:FindFirstChild("ViewportFrame");

            if ViewportFrame then
                renderAnimatedPet(ViewportFrame, v.pet);
            end;

            v38.Parent = Pets;
        end;

        UI_Manager:OpenWindow(EggContent, true);
    end;

    UI_Manager:AddBounceButton(Exit2, 1.05, true);
    Exit2.Activated:Connect(function() -- Line: 237
        -- upvalues: UI_Manager (copy), EggContent (copy), u25 (copy)
        UI_Manager:CloseWindow(EggContent, true);

        if u25.OpenShop then
            u25.OpenShop();
        end;
    end);

    if u28 then
        UI_Manager:AddBounceButton(u28, 1.05, false);
        u28.Activated:Connect(function() -- Line: 243
            -- upvalues: u31 (ref), u26 (copy), SoundController (copy), LocalPlayer (copy)
            if u31 then
                local v40, v41 = u26:BuyEgg(u31):await();

                if v40 and v41 then
                    SoundController:PlaySound("ShopBuy", LocalPlayer);
                end;
            end;
        end);
    end;

    local function populate() -- Line: 252
        -- upvalues: ItemHolder (copy), PetConfig (ref), u29 (copy), Constants (ref), renderModelViewport (ref), PetAssets (ref), applyTicketPrice (ref), UI_Manager (copy), u26 (copy), SoundController (copy), LocalPlayer (copy), showEggContent (copy)
        for _, child in ItemHolder:GetChildren() do
            if child:IsA("Frame") and child.Name == "Cell" then
                child:Destroy();
            end;
        end;

        for i, v in PetConfig.EggOrder do
            local v42 = PetConfig.Eggs[v];

            if v42 then
                local v43 = u29:Clone();
                v43.LayoutOrder = i;

                if v43:FindFirstChild("Line1") then
                    v43.Line1.Text = v42.displayName;
                    local v44 = Constants.RARITY_COLORS[v42.rarity];

                    if v44 then
                        v43.Line1.TextColor3 = v44;
                    end;
                end;

                if v43:FindFirstChild("Line2") then
                    v43.Line2.Text = "Egg";
                end;

                local v45 = v43:FindFirstChild("NO STOCK");

                if v45 then
                    v45.Visible = false;
                end;

                local Stock = v43:FindFirstChild("Stock");

                if Stock then
                    Stock.Visible = false;
                end;

                local Egg = v43:FindFirstChild("Egg");

                if Egg then
                    Egg = Egg:FindFirstChild("ViewportFrame");
                end;

                if Egg then
                    renderModelViewport(Egg, PetAssets.resolveEgg(v), 3.141592653589793);
                end;

                local Button2 = v43.BuyButton.Button;
                applyTicketPrice(Button2, v42.price);
                UI_Manager:AddBounceButton(Button2, 1.05, false);
                Button2.Activated:Connect(function() -- Line: 284
                    -- upvalues: v (copy), u26 (ref), SoundController (ref), LocalPlayer (ref)
                    local v46, v47 = u26:BuyEgg(v):await();

                    if v46 and v47 then
                        SoundController:PlaySound("ShopBuy", LocalPlayer);
                    end;
                end);
                local InfoButton = v43:FindFirstChild("InfoButton");

                if InfoButton then
                    InfoButton = InfoButton:FindFirstChild("Button");
                end;

                if InfoButton then
                    UI_Manager:AddBounceButton(InfoButton, 1.1, false);
                    InfoButton.Activated:Connect(function() -- Line: 290
                        -- upvalues: showEggContent (ref), v (copy)
                        showEggContent(v);
                    end);
                end;

                v43.Parent = ItemHolder;
            end;
        end;
    end;

    local AddSlots = PetShop.Top:FindFirstChild("AddSlots");
    local u48;

    if AddSlots then
        u48 = AddSlots:FindFirstChild("Button");
    else
        u48 = AddSlots;
    end;

    local function refreshEggSlots() -- Line: 304
        -- upvalues: AddSlots (copy), u48 (copy)
        if not AddSlots then
            return;
        end;

        AddSlots.Visible = true;
        local v49 = u48 and u48:FindFirstChild("Identifier");

        if v49 and v49:IsA("TextLabel") then
            v49.Text = "+1 EGG SLOT";
        end;
    end;

    function u25.OpenShop() -- Line: 311
        -- upvalues: populate (copy), AddSlots (copy), u48 (copy), UI_Manager (copy), PetShop (copy), u27 (ref), u26 (copy)
        populate();

        if AddSlots then
            AddSlots.Visible = true;
            local v50 = u48 and u48:FindFirstChild("Identifier");

            if v50 and v50:IsA("TextLabel") then
                v50.Text = "+1 EGG SLOT";
            end;
        end;

        UI_Manager:OpenWindow(PetShop, true);

        if u27 and u27.Enabled then
            u27.Enabled = false;
            u26:MarkOpened();
        end;
    end;

    if u48 then
        UI_Manager:AddBounceButton(u48, 1.05, false);
        u48.Activated:Connect(function() -- Line: 324
            -- upvalues: u26 (copy)
            u26:PromptSlotPurchase("Egg");
        end);
    end;

    UI_Manager:AddBounceButton(Exit, 1.05, true);
    Exit.Activated:Connect(function() -- Line: 330
        -- upvalues: UI_Manager (copy), PetShop (copy)
        UI_Manager:CloseWindow(PetShop, true);
    end);
    UI_Manager:AddBounceButton(Button, 1.05, false);
    Button.Activated:Connect(function() -- Line: 334
        -- upvalues: UI_Manager (copy), PetShop (copy), LocalPlayer (copy), Knit (ref)
        UI_Manager:CloseWindow(PetShop, true);
        local MarketStand = workspace.BigField:FindFirstChild("MarketStand");
        local v51;

        if MarketStand then
            v51 = MarketStand:FindFirstChild("MarketTP");
        else
            v51 = MarketStand;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if v51 and Character then
            local v52 = v51.Position + Vector3.new(0, 3, 0);
            local PromptHolder = MarketStand:FindFirstChild("PromptHolder");
            local v53 = PromptHolder and PromptHolder.Position or v51.Position + v51.CFrame.LookVector * 4;
            Character.CFrame = CFrame.lookAt(v52, (Vector3.new(v53.X, v52.Y, v53.Z)));
            Character.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        end;

        local v54 = Knit.GetController("FarmersMarketController");

        if v54 and v54.OpenMarket then
            v54.OpenMarket();
        end;
    end);
    task.spawn(function() -- Line: 355
        -- upvalues: u27 (ref), DataClient (copy), populate (copy), AddSlots (copy), u48 (copy), UI_Manager (copy), PetShop (copy), u26 (copy)
        local PetStand = workspace:WaitForChild("BigField"):WaitForChild("PetStand", 30);

        if not PetStand then
            return;
        end;

        local PromptHolder = PetStand:WaitForChild("PromptHolder", 10);
        local u55;

        if PromptHolder then
            u55 = PromptHolder:WaitForChild("ProximityPrompt", 10);
        else
            u55 = PromptHolder;
        end;

        if not u55 then
            return;
        end;

        local RebirthReq = PromptHolder:FindFirstChild("RebirthReq");
        u27 = PromptHolder:FindFirstChild("Alert");

        local function refreshStand() -- Line: 364
            -- upvalues: DataClient (ref), RebirthReq (copy), u55 (copy), u27 (ref)
            local currentData = DataClient.currentData;
            local v56 = (currentData and (currentData.Rebirth or 0) or 0) >= 2;

            if RebirthReq then
                RebirthReq.Enabled = not v56;
            end;

            u55.Enabled = v56;

            if u27 then
                if v56 then
                    if currentData then
                        currentData = currentData.OpenedPetShop == true;
                    end;

                    v56 = not currentData;
                end;

                u27.Enabled = v56;
            end;
        end;

        local currentData = DataClient.currentData;
        local v57 = (currentData and (currentData.Rebirth or 0) or 0) >= 2;

        if RebirthReq then
            RebirthReq.Enabled = not v57;
        end;

        u55.Enabled = v57;

        if u27 then
            if v57 then
                if currentData then
                    currentData = currentData.OpenedPetShop == true;
                end;

                v57 = not currentData;
            end;

            u27.Enabled = v57;
        end;

        DataClient.EV_UPDATE:Connect(refreshStand);
        u55.Triggered:Connect(function() -- Line: 376
            -- upvalues: DataClient (ref), populate (ref), AddSlots (ref), u48 (ref), UI_Manager (ref), PetShop (ref), u27 (ref), u26 (ref)
            if (DataClient.currentData and DataClient.currentData.Rebirth or 0) >= 2 then
                populate();

                if AddSlots then
                    AddSlots.Visible = true;
                    local v58 = u48 and u48:FindFirstChild("Identifier");

                    if v58 and v58:IsA("TextLabel") then
                        v58.Text = "+1 EGG SLOT";
                    end;
                end;

                UI_Manager:OpenWindow(PetShop, true);

                if u27 and u27.Enabled then
                    u27.Enabled = false;
                    u26:MarkOpened();
                end;
            end;
        end);
    end);
end;

function v1.KnitInit(p59) -- Line: 382
    -- upvalues: Knit (copy)
    p59.UI_Manager = Knit.GetController("UI_Manager");
    p59.DataClient = Knit.GetController("DataClient");
    p59.SoundController = Knit.GetController("SoundController");
    p59.HoverDescriptions = Knit.GetController("HoverDescriptions");
end;

return v1;