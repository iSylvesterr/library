-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local Constants = require(ReplicatedStorage.Shared.Info.Constants);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local KeycodeToString = require(ReplicatedStorage.Client.Modules.Utility.KeycodeToString);
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local Images = require(ReplicatedStorage.Shared.Info.Images);
local FormatMultiplier = require(ReplicatedStorage.Shared.Utility.FormatMultiplier);
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig);
local PetConfig = require(ReplicatedStorage.Shared.Info.PetConfig);
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local HUD = PlayerGui:WaitForChild("HUD");
local Hotbar = HUD:WaitForChild("Hotbar");
local LowerSection = Hotbar:WaitForChild("LowerSection");
local LowerHotbarSlots = LowerSection:WaitForChild("LowerHotbarSlots");
local Inner = LowerSection:WaitForChild("Inventory"):WaitForChild("Inner");
local SearchBox = Inner:WaitForChild("Search"):WaitForChild("SearchBox");
local Title = Inner:WaitForChild("Title");
local InvFull = Inner:WaitForChild("InvFull");
local Favorites = Inner:WaitForChild("Favorites");
local SortButtons = Inner:WaitForChild("SortButtons");
local Button = SortButtons:WaitForChild("All"):WaitForChild("Button");
local Button2 = SortButtons:WaitForChild("Fruit"):WaitForChild("Button");
local Button3 = SortButtons:WaitForChild("Seeds"):WaitForChild("Button");
local Button4 = SortButtons:WaitForChild("Trees"):WaitForChild("Button");
local Button5 = SortButtons:WaitForChild("Decor"):WaitForChild("Button");
local Pets = SortButtons:FindFirstChild("Pets");

if Pets then
    Pets = Pets:FindFirstChild("Button");
end;

local ItemHolder = Inner:WaitForChild("ItemHolder"):WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder");
local Slot = ItemHolder:WaitForChild("Slot");
Slot.Parent = script;
local Exit = Inner:WaitForChild("Exit");
local ItemDescriptions = PlayerGui:WaitForChild("Overlay"):WaitForChild("ItemDescriptions");
local Slot2 = LowerHotbarSlots:WaitForChild("Slot");
Slot2.Parent = script;
local u1 = {};
local u2 = {};
local u3 = nil;
local u4 = nil;
local u5 = true;
local u6 = nil;
local u7 = nil;
local u8 = "ALL";
local u9 = "DONT_CARE";
local u10 = false;
local u11 = false;
local u12 = nil;
local Position = Inner.Position;
local u13 = Inner.Position + UDim2.fromOffset(0, Inner.AbsoluteSize.Y * 1.1);
local v14 = Knit.CreateController({
    Name = "HotbarController"
});

local function checkWithinBounds(p15, p16, p17) -- Line: 118
    -- upvalues: Inner (copy)
    if p16.Visible ~= true then
        return false;
    end;

    if not p17 then
        if p15.Y > Inner.AbsoluteSize.Y + Inner.AbsolutePosition.Y then
            return false;
        end;

        if p15.Y < Inner.AbsolutePosition.Y then
            return false;
        end;
    end;

    local v18;

    if p15.X >= p16.AbsolutePosition.X and (p15.X <= p16.AbsolutePosition.X + p16.AbsoluteSize.X and p15.Y >= p16.AbsolutePosition.Y) then
        v18 = p15.Y <= p16.AbsolutePosition.Y + p16.AbsoluteSize.Y;
    else
        v18 = false;
    end;

    return v18;
end;

function v14.PulseCell(p19, p20) -- Line: 135
    -- upvalues: u1 (copy)
    if u1[p20] then
        p19.UI_Manager:ForcePulseWave(u1[p20].item.Slot);
    end;
end;

function v14.OpenInventory(p21, p22) -- Line: 145
    -- upvalues: u10 (ref), u12 (ref), Maid (copy), Inner (copy), u8 (ref), u9 (ref), SearchBox (copy), Position (copy), u11 (ref), u13 (copy), TweenService (copy)
    if u10 == true then
        return;
    end;

    u10 = true;
    p21.UI_Manager:CloseOpenWindowsQuick(true);

    if u12 then
        u12:Destroy();
    end;

    u12 = Maid.new();
    Inner.Visible = true;
    u8 = "ALL";
    u9 = "DONT_CARE";
    SearchBox.Text = "";
    p21:UpdateUI();

    if p22 then
        Inner.Position = Position;

        return;
    end;

    u11 = true;
    Inner.Position = u13;
    local u23 = TweenService:Create(Inner, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = Position
    });
    u23:Play();
    u12:GiveTask(u23.Completed:Once(function() -- Line: 178
        -- upvalues: u11 (ref)
        u11 = false;
    end));
    u12:GiveTask(function() -- Line: 182
        -- upvalues: u23 (copy)
        if u23 then
            u23:Cancel();
        end;
    end);
end;

function v14.CloseInventory(u24, p25) -- Line: 187
    -- upvalues: u10 (ref), u12 (ref), Maid (copy), Inner (copy), u11 (ref), Position (copy), TweenService (copy), u13 (copy)
    if u10 == false then
        return;
    end;

    u10 = false;

    if u12 then
        u12:Destroy();
    end;

    u12 = Maid.new();

    if p25 then
        Inner.Visible = false;

        return;
    end;

    u11 = true;
    Inner.Position = Position;
    local u26 = TweenService:Create(Inner, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = u13
    });
    u26:Play();
    u12:GiveTask(u26.Completed:Once(function() -- Line: 210
        -- upvalues: Inner (ref), u24 (copy), u11 (ref)
        Inner.Visible = false;
        u24:UpdateUI();
        u11 = false;
    end));
    u12:GiveTask(function() -- Line: 216
        -- upvalues: u26 (copy)
        if u26 then
            u26:Cancel();
        end;
    end);
end;

function v14.ToggleInventory(p27) -- Line: 221
    -- upvalues: u10 (ref)
    if u10 then
        p27:CloseInventory(false);

        return;
    end;

    p27:OpenInventory(false);
end;

function v14.RenderCellContents(p28, p29, p30) -- Line: 234
    -- upvalues: MutationConfig (copy), SeedConfig (copy), PetConfig (copy), FormatMultiplier (copy), u10 (ref), u7 (ref)
    local item = p29.item;

    if p30.empty == true then
        item.Slot.ToolName.Text = "";
    else
        if p30.itemType == "Axe" then
            p29.itemName = "Axe (Pick Up Trees)";
        elseif p30.itemType == "Fruit" then
            local v31 = p30.multiplier or 1;
            p29.itemName = string.format("%s%s (%.1fx)", p30.fruitName or "Fruit", MutationConfig.NameSuffix(p30.mutations), v31);
        elseif p30.itemType == "Seed" then
            local v32 = p30.count or 1;
            p29.itemName = SeedConfig.SeedDisplayName(p30.seedType) .. MutationConfig.NameSuffix(p30.mutation and ({ p30.mutation } or nil) or nil) .. (v32 > 1 and string.format(" (x%d)", v32) or "");
        elseif p30.itemType == "Decor" then
            local v33 = p30.count or 1;
            p29.itemName = v33 > 1 and string.format("%s (x%d)", p30.furnitureId or "Decor", v33) or (p30.furnitureId or "Decor");
        elseif p30.itemType == "Egg" then
            local v34 = PetConfig.Eggs[p30.eggId];
            local v35 = v34 and v34.displayName .. " Egg" or "Egg";
            local v36 = p30.count or 1;

            if v36 > 1 then
                v35 = string.format("%s (x%d)", v35, v36) or v35;
            end;

            p29.itemName = v35;
        elseif p30.itemType == "Pet" then
            p29.itemName = string.format("%s [%s]", tostring(p30.petType), (tostring(p30.petName)));
        elseif p30.isDead then
            local v37 = SeedConfig.GetSeed(p30.seedType);
            local v38 = p30.multiplier or 1;
            p29.itemName = string.format("Dead %s%s (%sx)", v37.displayName, MutationConfig.NameSuffix(p30.mutations), FormatMultiplier(v38));
        else
            local v39 = SeedConfig.GetSeed(p30.seedType);
            p29.itemName = string.format("%s%s (%sx)", v39.displayName, MutationConfig.NameSuffix(p30.mutations), FormatMultiplier(p30.multiplier));
        end;

        item.Slot.ToolName.Text = p29.itemName;
    end;

    if u10 and not p30.empty then
        item.Slot.BackgroundTransparency = 0;
        item.Slot.BackgroundColor3 = Color3.fromHex("#222222");
    else
        item.Slot.BackgroundTransparency = 0.35;
        item.Slot.BackgroundColor3 = Color3.fromHex("#000000");
    end;

    if u10 and p30.favorited then
        item.Slot.Heart.Visible = true;
    else
        item.Slot.Heart.Visible = false;
    end;

    local v40;

    if p30.empty then
        v40 = false;
    else
        v40 = u7 == p30.id;
    end;

    if not v40 then
        item.Slot.UIStroke.Enabled = false;

        return;
    end;

    item.Slot.UIStroke.Transparency = 0;
    item.Slot.UIStroke.Enabled = true;
end;

function v14.UpdateUI(u41) -- Line: 315
    -- upvalues: u1 (copy), Maid (copy), Slot2 (copy), LowerHotbarSlots (copy), KeycodeToString (copy), CustomEnum (copy), UserInputService (copy), u10 (ref), u6 (ref), u4 (ref), u5 (ref), SearchBox (copy), u2 (copy), Slot (copy), ItemHolder (copy), u8 (ref), u9 (ref), Button (copy), Button2 (copy), Button3 (copy), Button4 (copy), Button5 (copy), Pets (copy), Title (copy), Favorites (copy), Images (copy), Constants (copy), InvFull (copy)
    if not u41.DataClient.currentData then
        return;
    end;

    local Hotbar2 = u41.DataClient.currentData.Inventory.Hotbar;
    local u42 = 1;

    while u42 <= #Hotbar2 do
        if not u1[u42] then
            u1[u42] = {};
            u1[u42].maid = Maid.new();
            u1[u42].item = Slot2:Clone();
            u1[u42].item.Parent = LowerHotbarSlots;
            u1[u42].touchStartedTime = 0;
            u1[u42].favoritedTime = 0;
            u41.UI_Manager:AddPulseV2(u1[u42].item.Slot, 1.3, nil, {
                zIndex = 515,
                curveAmt = UDim.new(0.15, 0)
            });
            u1[u42].item.Slot.KeyBind.Text = u42;
            u1[u42].item.Slot.Cross.Visible = false;
            u1[u42].item.Slot.Cooldown.Visible = false;
            u41.UI_Manager:AddBounceButton(u1[u42].item.Slot, 1.1);
            u1[u42].maid:GiveTask(function() -- Line: 355
                -- upvalues: u1 (ref), u42 (copy), u41 (copy)
                if u1[u42].item then
                    u41.UI_Manager:RemovePulseV2(u1[u42].item.Slot);
                    u41.UI_Manager:RemoveBounceButton(u1[u42].item.Slot);
                    u1[u42].item:Destroy();
                end;
            end);

            local function updateKeybindDisplay() -- Line: 364
                -- upvalues: u1 (ref), u42 (copy), u41 (copy), KeycodeToString (ref), CustomEnum (ref)
                if not u1[u42] then
                    return;
                end;

                if not u41.DataClient.currentData then
                    return;
                end;

                local v43 = u41.DataClient.currentData.Settings.Keybinds.Hotbar[u42];
                u1[u42].item.Slot.KeyBind.Text = v43 and KeycodeToString(Enum.KeyCode[v43]) or "";
                u1[u42].item.Slot.KeyBind.Visible = u41.UserInputParser:getInputType() == CustomEnum.INPUT_TYPES.DESKTOP;
            end;

            updateKeybindDisplay();
            u1[u42].maid:GiveTask(u41.DataClient.EV_UPDATE:Connect(updateKeybindDisplay));
            u1[u42].maid:GiveTask(u41.UserInputParser.InputTypeChanged:Connect(updateKeybindDisplay));

            u1[u42].hotbarFunction = function() -- Line: 380
                -- upvalues: u41 (copy), u42 (copy)
                u41.ToolService.ToggleEquip:Fire(true, u42);
            end;

            u1[u42].maid:GiveTask(UserInputService.InputBegan:Connect(function(p44, p45) -- Line: 387
                -- upvalues: u41 (copy), u42 (copy), u1 (ref)
                if p45 then
                    return;
                end;

                if not u41.DataClient.currentData then
                    return;
                end;

                if p44.UserInputType == Enum.UserInputType.Keyboard and p44.KeyCode.Name == u41.DataClient.currentData.Settings.Keybinds.Hotbar[u42] then
                    u41.UI_Manager:Bounce(u1[u42].item.Slot);
                    u1[u42].hotbarFunction();
                end;
            end));
        end;

        local v46 = u41.DataClient.currentData.Inventory.Hotbar[u42];
        u41:RenderCellContents(u1[u42], v46);

        if u10 then
            u1[u42].item.Visible = true;
        elseif v46.empty then
            u1[u42].item.Visible = false;
        else
            u1[u42].item.Visible = true;
        end;

        u1[u42].item.Slot.Visible = true;

        if u6 and (u4 == u42 and u5 == true) then
            u1[u42].item.Slot.Visible = false;
        end;

        u42 = u42 + 1;
    end;

    local v47 = #u1;

    while #Hotbar2 + 1 <= v47 do
        u1[v47].maid:Destroy();
        table.remove(u1, v47);
        v47 = v47 - 1;
    end;

    local Text = SearchBox.Text;

    if Text and Text ~= "" then
        local v48 = string.gsub(Text, "%%", "");
        local v49 = string.gsub(v48, "%(", "");
        Text = string.gsub(v49, "%[", "");
    end;

    local Storage = u41.DataClient.currentData.Inventory.Storage;
    local u50 = 1;

    while u50 <= #Storage do
        if not u2[u50] then
            u2[u50] = {};
            u2[u50].maid = Maid.new();
            u2[u50].item = Slot:Clone();
            u2[u50].item.Parent = ItemHolder;
            u2[u50].touchStartedTime = 0;
            u2[u50].favoritedTime = 0;
            u41.UI_Manager:AddBounceButton(u2[u50].item.Slot, 1.1);
            u2[u50].maid:GiveTask(function() -- Line: 469
                -- upvalues: u2 (ref), u50 (copy), u41 (copy)
                if u2[u50] and u2[u50].item then
                    u41.UI_Manager:RemoveBounceButton(u2[u50].item.Slot);
                    u2[u50].item:Destroy();
                end;
            end);

            u2[u50].storageFunction = function() -- Line: 478
                -- upvalues: u41 (copy), u50 (copy)
                u41.ToolService.ToggleEquip:Fire(false, u50);
            end;
        end;

        local v51 = u41.DataClient.currentData.Inventory.Storage[u50];
        u41:RenderCellContents(u2[u50], v51);
        u2[u50].item.Visible = true;

        if v51.itemType == "Fruit" then
            if u8 ~= "ALL" and u8 ~= "FRUIT" then
                u2[u50].item.Visible = false;
            end;
        elseif v51.itemType == "Seed" then
            if u8 ~= "ALL" and u8 ~= "SEEDS" then
                u2[u50].item.Visible = false;
            end;
        elseif v51.itemType == "Decor" then
            if u8 ~= "ALL" and u8 ~= "DECOR" then
                u2[u50].item.Visible = false;
            end;
        elseif v51.itemType == "Egg" or v51.itemType == "Pet" then
            if u8 ~= "ALL" and u8 ~= "PETS" then
                u2[u50].item.Visible = false;
            end;
        elseif v51.isDead then
            if u8 ~= "ALL" and u8 ~= "TREES" then
                u2[u50].item.Visible = false;
            end;
        elseif u8 ~= "ALL" and u8 ~= "TREES" then
            u2[u50].item.Visible = false;
        end;

        if u9 == "FAVS" then
            if v51.favorited ~= true then
                u2[u50].item.Visible = false;
            end;
        elseif u9 == "NO_FAVS" and v51.favorited == true then
            u2[u50].item.Visible = false;
        end;

        if Text and (Text ~= "" and not string.find(string.upper(u2[u50].itemName or ""), string.upper(Text))) then
            u2[u50].item.Visible = false;
        end;

        u2[u50].item.Slot.Visible = true;

        if u6 and (u4 == u50 and u5 == false) then
            u2[u50].item.Slot.Visible = false;
        end;

        u50 = u50 + 1;
    end;

    local v52 = #u2;

    while #Storage + 1 <= v52 do
        u2[v52].maid:Destroy();
        table.remove(u2, v52);
        v52 = v52 - 1;
    end;

    Button.SelectedHighlight.Enabled = false;
    Button2.SelectedHighlight.Enabled = false;
    Button3.SelectedHighlight.Enabled = false;
    Button4.SelectedHighlight.Enabled = false;
    Button5.SelectedHighlight.Enabled = false;

    if Pets then
        Pets.SelectedHighlight.Enabled = false;
    end;

    if u8 == "ALL" then
        Title.Text = "All Items";
        Button.SelectedHighlight.Enabled = true;
    elseif u8 == "FRUIT" then
        Title.Text = "Fruit";
        Button2.SelectedHighlight.Enabled = true;
    elseif u8 == "TREES" then
        Title.Text = "Trees";
        Button4.SelectedHighlight.Enabled = true;
    elseif u8 == "SEEDS" then
        Title.Text = "Seeds";
        Button3.SelectedHighlight.Enabled = true;
    elseif u8 == "DECOR" then
        Title.Text = "Decor";
        Button5.SelectedHighlight.Enabled = true;
    elseif u8 == "PETS" then
        Title.Text = "Pets";

        if Pets then
            Pets.SelectedHighlight.Enabled = true;
        end;
    else
        Title.Text = "";
    end;

    if u9 == "DONT_CARE" then
        Favorites.Heart.Image = Images.HEART_EMPTY;
        Favorites.Title.Text = "All";
    elseif u9 == "FAVS" then
        Favorites.Heart.Image = Images.HEART_FILLED;
        Favorites.Title.Text = "Favorites";
    else
        Favorites.Heart.Image = Images.HEART_CROSSED;
        Favorites.Title.Text = "Not Favorites";
    end;

    if #Storage < Constants.STORAGE_MAX_SIZE - 10 then
        InvFull.Visible = false;

        return;
    end;

    InvFull.Visible = true;
    InvFull.Text = "Inventory Space " .. #Storage .. "/" .. Constants.STORAGE_MAX_SIZE;

    if #Storage >= Constants.STORAGE_MAX_SIZE then
        InvFull.TextColor3 = Color3.new(1, 0, 0);

        return;
    end;

    InvFull.TextColor3 = Color3.new(1, 1, 0);
end;

function v14.KnitStart(u53) -- Line: 624
    -- upvalues: Hotbar (copy), LowerSection (copy), LowerHotbarSlots (copy), u7 (ref), Button (copy), Button3 (copy), Button2 (copy), Button4 (copy), Button5 (copy), Pets (copy), u8 (ref), Favorites (copy), u9 (ref), Exit (copy), u3 (ref), u4 (ref), Constants (copy), CustomEnum (copy), u10 (ref), UserInputService (copy), HUD (copy), u1 (copy), u5 (ref), u11 (ref), u2 (copy), checkWithinBounds (copy), u6 (ref), ItemDescriptions (copy), Inner (copy), SearchBox (copy)
    Hotbar.Visible = true;
    LowerSection.Visible = true;
    LowerHotbarSlots.Visible = true;
    u53.DataClient.EV_UPDATE:Connect(function() -- Line: 629
        -- upvalues: u53 (copy)
        u53:UpdateUI();
    end);
    u53.ToolService.SelectedItemID:Observe(function(p54) -- Line: 633
        -- upvalues: u7 (ref), u53 (copy)
        u7 = p54;
        u53:UpdateUI();
    end);
    u53.UI_Manager:AddBounceButton(Button, 1.1);
    u53.UI_Manager:AddBounceButton(Button3, 1.1);
    u53.UI_Manager:AddBounceButton(Button2, 1.1);
    u53.UI_Manager:AddBounceButton(Button4, 1.1);
    u53.UI_Manager:AddBounceButton(Button5, 1.1);

    if Pets then
        u53.UI_Manager:AddBounceButton(Pets, 1.1);
    end;

    Button.Activated:Connect(function() -- Line: 646
        -- upvalues: u8 (ref), u53 (copy)
        u8 = "ALL";
        u53:UpdateUI();
    end);
    Button3.Activated:Connect(function() -- Line: 651
        -- upvalues: u8 (ref), u53 (copy)
        u8 = "SEEDS";
        u53:UpdateUI();
    end);
    Button2.Activated:Connect(function() -- Line: 656
        -- upvalues: u8 (ref), u53 (copy)
        u8 = "FRUIT";
        u53:UpdateUI();
    end);
    Button4.Activated:Connect(function() -- Line: 661
        -- upvalues: u8 (ref), u53 (copy)
        u8 = "TREES";
        u53:UpdateUI();
    end);
    Button5.Activated:Connect(function() -- Line: 666
        -- upvalues: u8 (ref), u53 (copy)
        u8 = "DECOR";
        u53:UpdateUI();
    end);

    if Pets then
        Pets.Activated:Connect(function() -- Line: 672
            -- upvalues: u8 (ref), u53 (copy)
            u8 = "PETS";
            u53:UpdateUI();
        end);
    end;

    Favorites.Activated:Connect(function() -- Line: 678
        -- upvalues: u9 (ref), u53 (copy)
        if u9 == "DONT_CARE" then
            u9 = "FAVS";
        elseif u9 == "FAVS" then
            u9 = "NO_FAVS";
        else
            u9 = "DONT_CARE";
        end;

        u53:UpdateUI();
    end);
    u53.UI_Manager:AddBounceButton(Exit, 1.1);
    Exit.Activated:Connect(function() -- Line: 690
        -- upvalues: u53 (copy)
        u53:CloseInventory(false);
    end);

    local function tryFavorite(p55, p56, p57) -- Line: 695
        -- upvalues: u53 (copy)
        p55.favoritedTime = os.clock();
        u53.InventoryService.FavoriteItem:Fire(p56, p57);

        return true;
    end;

    local function doubleClickCheck(p58, p59, p60) -- Line: 715
        -- upvalues: u3 (ref), u4 (ref), Constants (ref), u53 (copy), CustomEnum (ref), u10 (ref)
        local v61 = os.clock();
        local v62;

        if u3 == u4 and (v61 - p58.touchStartedTime <= Constants.DOUBLE_TAP_TIME and (u53.UserInputParser:getInputType() == CustomEnum.INPUT_TYPES.MOBILE and u10)) then
            p58.favoritedTime = os.clock();
            u53.InventoryService.FavoriteItem:Fire(p59, p60);
            v62 = true;
        else
            v62 = false;
        end;

        p58.touchStartedTime = v61;

        return v62;
    end;

    local function longPressCheck(p63, p64, p65) -- Line: 734
        -- upvalues: Constants (ref), u53 (copy), CustomEnum (ref), u10 (ref)
        local v66;

        if os.clock() - p63.touchStartedTime > Constants.LONG_PRESS_TIME and (u53.UserInputParser:getInputType() == CustomEnum.INPUT_TYPES.MOBILE and u10) then
            p63.favoritedTime = os.clock();
            u53.InventoryService.FavoriteItem:Fire(p64, p65);
            v66 = true;
        else
            v66 = false;
        end;

        return v66;
    end;

    UserInputService.InputBegan:Connect(function(p67, p68) -- Line: 750
        -- upvalues: u53 (copy), u4 (ref), HUD (ref), u1 (ref), u5 (ref), doubleClickCheck (copy), u10 (ref), u11 (ref), u2 (ref), checkWithinBounds (ref)
        if not u53.DataClient.currentData then
            return;
        end;

        local v69 = p67.UserInputType == Enum.UserInputType.MouseButton2;

        if p67.UserInputType == Enum.UserInputType.MouseButton1 or (p67.UserInputType == Enum.UserInputType.Touch or v69) then
            u4 = nil;

            if not HUD.Enabled then
                return;
            end;

            for i, v in u1 do
                if v.item.Visible then
                    local Position2 = p67.Position;
                    local Slot3 = v.item.Slot;
                    local v70;

                    if Slot3.Visible == true and (Position2.X >= Slot3.AbsolutePosition.X and (Position2.X <= Slot3.AbsolutePosition.X + Slot3.AbsoluteSize.X and Position2.Y >= Slot3.AbsolutePosition.Y)) then
                        v70 = Position2.Y <= Slot3.AbsolutePosition.Y + Slot3.AbsoluteSize.Y;
                    else
                        v70 = false;
                    end;

                    if v70 then
                        if v69 then
                            u1[i].favoritedTime = os.clock();
                            u53.InventoryService.FavoriteItem:Fire(true, i);
                        else
                            u4 = i;
                            u5 = true;
                            doubleClickCheck(u1[i], true, i);
                        end;

                        break;
                    end;
                end;
            end;

            if u10 and not u11 then
                for i, v in u2 do
                    if v.item.Visible and checkWithinBounds(p67.Position, v.item.Slot, false) then
                        if v69 then
                            u1[i].favoritedTime = os.clock();
                            u53.InventoryService.FavoriteItem:Fire(false, i);

                            return;
                        end;

                        u4 = i;
                        u5 = false;
                        doubleClickCheck(u2[i], false, i);

                        return;
                    end;
                end;
            end;
        elseif p67.UserInputType == Enum.UserInputType.Keyboard and p67.KeyCode.Name == u53.DataClient.currentData.Settings.Keybinds.Inventory then
            u53:ToggleInventory();
        end;
    end);
    UserInputService.InputChanged:Connect(function(p71, p72) -- Line: 801
        -- upvalues: u4 (ref), u5 (ref), u1 (ref), u2 (ref), u6 (ref), checkWithinBounds (ref), ItemDescriptions (ref), u53 (copy)
        if (p71.UserInputType == Enum.UserInputType.MouseMovement or p71.UserInputType == Enum.UserInputType.Touch) and u4 then
            local v73;

            if u5 then
                v73 = u1[u4].item.Slot;
            else
                v73 = u2[u4].item.Slot;
            end;

            if u6 then
                u6.Position = UDim2.fromOffset(p71.Position.X, p71.Position.Y);

                return;
            end;

            if not checkWithinBounds(p71.Position, v73, u5) then
                u6 = v73:Clone();

                if u6:FindFirstChild("KeyBind") then
                    u6.KeyBind:Destroy();
                end;

                if u6:FindFirstChild("Cooldown") then
                    u6.Cooldown:Destroy();
                end;

                u6.Active = false;
                u6.Interactable = false;
                u6.Parent = ItemDescriptions;
                local AbsoluteSize = v73.AbsoluteSize;
                u6.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y);
                u6.Position = UDim2.fromOffset(p71.Position.X, p71.Position.Y);
                u53:UpdateUI();
            end;
        end;
    end);
    UserInputService.InputEnded:Connect(function(p74, p75) -- Line: 836
        -- upvalues: u4 (ref), u1 (ref), u5 (ref), Constants (ref), u53 (copy), CustomEnum (ref), u10 (ref), u2 (ref), checkWithinBounds (ref), Inner (ref), u3 (ref), u6 (ref), SearchBox (ref)
        if p74.UserInputType ~= Enum.UserInputType.MouseButton1 and p74.UserInputType ~= Enum.UserInputType.Touch then
            if p74.UserInputType == Enum.UserInputType.Keyboard and SearchBox:IsFocused() then
                u53:UpdateUI();
            end;

            return;
        end;

        if not u4 then
            return;
        end;

        local v76 = false;

        for i, v in u1 do
            if v.item.Visible then
                local Position2 = p74.Position;
                local Slot3 = v.item.Slot;
                local v77;

                if Slot3.Visible == true and (Position2.X >= Slot3.AbsolutePosition.X and (Position2.X <= Slot3.AbsolutePosition.X + Slot3.AbsoluteSize.X and Position2.Y >= Slot3.AbsolutePosition.Y)) then
                    v77 = Position2.Y <= Slot3.AbsolutePosition.Y + Slot3.AbsoluteSize.Y;
                else
                    v77 = false;
                end;

                if v77 then
                    v76 = true;

                    if u4 == i and u5 then
                        local v78 = u1[i];
                        local v79;

                        if os.clock() - v78.touchStartedTime > Constants.LONG_PRESS_TIME and (u53.UserInputParser:getInputType() == CustomEnum.INPUT_TYPES.MOBILE and u10) then
                            v78.favoritedTime = os.clock();
                            u53.InventoryService.FavoriteItem:Fire(true, i);
                            v79 = true;
                        else
                            v79 = false;
                        end;

                        if not v79 then
                            u1[i].hotbarFunction();
                        end;
                    else
                        u53.InventoryService.MoveItemTo:Fire(u5, u4, true, i);
                    end;

                    break;
                end;
            end;
        end;

        for i, v in u2 do
            if v.item.Visible and (checkWithinBounds(p74.Position, v.item.Slot, false) and (u4 == i and not u5)) then
                v76 = true;
                local v80 = u2[i];
                local v81;

                if os.clock() - v80.touchStartedTime > Constants.LONG_PRESS_TIME and (u53.UserInputParser:getInputType() == CustomEnum.INPUT_TYPES.MOBILE and u10) then
                    v80.favoritedTime = os.clock();
                    u53.InventoryService.FavoriteItem:Fire(false, i);
                    v81 = true;
                else
                    v81 = false;
                end;

                if not v81 then
                    u2[i].storageFunction();
                end;

                break;
            end;
        end;

        if not v76 and (u5 and (u10 and checkWithinBounds(p74.Position, Inner, false))) then
            u53.InventoryService.MoveItemTo:Fire(u5, u4, false, nil);
        end;

        u3 = u4;
        u4 = nil;

        if u6 then
            u6:Destroy();
        end;

        u6 = nil;
        u53:UpdateUI();
    end);
    SearchBox.FocusLost:Connect(function() -- Line: 896
        -- upvalues: u53 (copy)
        u53:UpdateUI();
    end);
end;

function v14.KnitInit(p82) -- Line: 901
    -- upvalues: Knit (copy)
    p82.DataClient = Knit.GetController("DataClient");
    p82.UI_Manager = Knit.GetController("UI_Manager");
    p82.UserInputParser = Knit.GetController("UserInputParser");
    p82.NotificationController = Knit.GetController("NotificationController");
    p82.ToolService = Knit.GetService("ToolService");
    p82.InventoryService = Knit.GetService("InventoryService");
end;

return v14;