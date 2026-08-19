-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local PetConfig = require(ReplicatedStorage.Shared.Info.PetConfig);
local PetUI = require(ReplicatedStorage.Client.Modules.Utility.PetUI);
local v1 = Knit.CreateController({
    Name = "ActivePetsController"
});

function v1.KnitStart(u2) -- Line: 13
    -- upvalues: Players (copy), Knit (copy), PetConfig (copy), PetUI (copy), RunService (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local u3 = Knit.GetService("PlayerPlotService");
    local UI_Manager = u2.UI_Manager;
    local ActivePets = PlayerGui:WaitForChild("Windows"):WaitForChild("ActivePets");
    local v4 = ActivePets.Top and ActivePets.Top:FindFirstChild("Exit");
    local u5 = ActivePets.Top and ActivePets.Top:FindFirstChild("Timer");
    local ItemHolder = ActivePets.Content:WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder");
    local u6 = ItemHolder:WaitForChild("Row"):Clone();

    for _, child in ItemHolder:GetChildren() do
        if child:IsA("Frame") and child.Name == "Row" then
            child:Destroy();
        end;
    end;

    local u7 = {};

    local function clearRows() -- Line: 33
        -- upvalues: u7 (ref)
        for _, v in u7 do
            v.frame:Destroy();
        end;

        u7 = {};
    end;

    local function refreshTitle(p8) -- Line: 38
        -- upvalues: u5 (copy), u2 (copy), PetConfig (ref)
        if not u5 then
            return;
        end;

        local currentData = u2.DataClient.currentData;
        local v9 = (currentData and (currentData.Gamepasses and currentData.Gamepasses.EMOTE_VIP) and currentData.Gamepasses.EMOTE_VIP.Owned) == true;

        if currentData then
            currentData = currentData.PetSlots;
        end;

        local v10 = PetConfig.EffectivePetSlots(currentData, v9);
        u5.Text = string.format("ACTIVE PETS: %d/%d", p8, v10);
    end;

    local u11 = ActivePets.Top and ActivePets.Top:FindFirstChild("AddSlots");
    local u12;

    if u11 then
        u12 = u11:FindFirstChild("Button");
    else
        u12 = u11;
    end;

    local function refreshAddSlots() -- Line: 50
        -- upvalues: u11 (copy), u2 (copy), PetConfig (ref), u12 (copy)
        if not u11 then
            return;
        end;

        local currentData = u2.DataClient.currentData;
        u11.Visible = PetConfig.CanBuySlot(currentData and currentData.PetSlots or PetConfig.DefaultPetSlots, PetConfig.MaxPetSlots);
        local v13 = u12 and u12:FindFirstChild("Identifier");

        if v13 and v13:IsA("TextLabel") then
            v13.Text = "+1 SLOT";
        end;
    end;

    local function buildRows(p14) -- Line: 59
        -- upvalues: clearRows (copy), refreshTitle (copy), u6 (copy), PetUI (ref), UI_Manager (copy), u3 (copy), Knit (ref), ItemHolder (copy), u7 (ref)
        clearRows();
        refreshTitle(#p14);

        for i, v in p14 do
            local u15 = u6:Clone();
            u15.LayoutOrder = i;
            local Pet = u15.LeftSide:FindFirstChild("Pet");
            local v16;

            if Pet then
                v16 = Pet:FindFirstChild("PetName");
            else
                v16 = Pet;
            end;

            if v16 then
                v16.Text = string.format("%s [%s]", v.petType, (tostring(v.petName)));
            end;

            local renderPet = PetUI.renderPet;

            if Pet then
                Pet = Pet:FindFirstChild("ViewportFrame");
            end;

            renderPet(Pet, v.petType);
            PetUI.applyBars(u15:FindFirstChild("Bars"), v);
            local id = v.id;

            local function wire(p17, p18) -- Line: 73
                -- upvalues: u15 (copy), UI_Manager (ref)
                local v19 = u15:FindFirstChild(p17);

                if v19 then
                    v19 = v19:FindFirstChild("Button");
                end;

                if not v19 then
                    return;
                end;

                UI_Manager:AddBounceButton(v19, 1.05, false);
                v19.Activated:Connect(p18);
            end;

            local function v20() -- Line: 80
                -- upvalues: u3 (ref), id (copy)
                u3:FeedPet(id);
            end;

            local Feed = u15:FindFirstChild("Feed");

            if Feed then
                Feed = Feed:FindFirstChild("Button");
            end;

            if Feed then
                UI_Manager:AddBounceButton(Feed, 1.05, false);
                Feed.Activated:Connect(v20);
            end;

            local function v22() -- Line: 81
                -- upvalues: Knit (ref), id (copy)
                local v21 = Knit.GetController("ViewPetController");

                if v21 and v21.Open then
                    v21.Open(id);
                end;
            end;

            local View = u15:FindFirstChild("View");

            if View then
                View = View:FindFirstChild("Button");
            end;

            if View then
                UI_Manager:AddBounceButton(View, 1.05, false);
                View.Activated:Connect(v22);
            end;

            local function v23() -- Line: 85
                -- upvalues: u3 (ref), id (copy)
                u3:PickupPet(id);
            end;

            local PickUp = u15:FindFirstChild("PickUp");

            if PickUp then
                PickUp = PickUp:FindFirstChild("Button");
            end;

            if PickUp then
                UI_Manager:AddBounceButton(PickUp, 1.05, false);
                PickUp.Activated:Connect(v23);
            end;

            u15.Parent = ItemHolder;
            u7[id] = {
                frame = u15,
                petType = v.petType
            };
        end;
    end;

    local function refresh(p24) -- Line: 93
        -- upvalues: refreshAddSlots (copy), u3 (copy), u7 (ref), buildRows (copy), PetUI (ref)
        refreshAddSlots();
        local v25, v26 = u3:GetPlacedPets():await();

        if not (v25 and v26) then
            return;
        end;

        local v27 = p24 or false;

        if not v27 then
            local v28 = 0;

            for _, v in v26 do
                v28 = v28 + 1;

                if not u7[v.id] then
                    v27 = true;
                    break;
                end;
            end;

            local v29 = 0;

            for _ in u7 do
                v29 = v29 + 1;
            end;

            if v28 ~= v29 then
                v27 = true;
            end;
        end;

        if v27 then
            buildRows(v26);

            return;
        end;

        for _, v in v26 do
            local v30 = u7[v.id];

            if v30 then
                PetUI.applyBars(v30.frame:FindFirstChild("Bars"), v);
            end;
        end;
    end;

    if u12 then
        UI_Manager:AddBounceButton(u12, 1.05, false);
        u12.Activated:Connect(function() -- Line: 122
            -- upvalues: Knit (ref)
            Knit.GetService("PetsService"):PromptSlotPurchase("Pet");
        end);
    end;

    function u2.Open() -- Line: 127
        -- upvalues: refresh (copy), UI_Manager (copy), ActivePets (copy)
        refresh(true);
        UI_Manager:OpenWindow(ActivePets, true);
    end;

    if v4 then
        UI_Manager:AddBounceButton(v4, 1.05, true);
        v4.Activated:Connect(function() -- Line: 135
            -- upvalues: UI_Manager (copy), ActivePets (copy)
            UI_Manager:CloseWindow(ActivePets, true);
        end);
    end;

    task.spawn(function() -- Line: 139
        -- upvalues: PlayerGui (copy), UI_Manager (copy), u2 (copy), ActivePets (copy), refresh (copy)
        local HUD = PlayerGui:WaitForChild("HUD", 20);

        if HUD then
            HUD = HUD:FindFirstChild("SideMenus");
        end;

        if HUD then
            HUD = HUD:FindFirstChild("Right");
        end;

        if HUD then
            HUD = HUD:FindFirstChild("Buttons");
        end;

        if HUD then
            HUD = HUD:FindFirstChild("Pets");
        end;

        if HUD then
            HUD = HUD:FindFirstChild("Button");
        end;

        if HUD then
            UI_Manager:AddBounceButton(HUD, 1.1, false);
            HUD.Activated:Connect(function() -- Line: 149
                -- upvalues: u2 (ref), ActivePets (ref), UI_Manager (ref), refresh (ref)
                if not u2.DataClient.currentData then
                    return;
                end;

                if u2.DataClient.currentData.Rebirth < 2 then
                    u2.NotificationController:SendNotification(string.format("Unlocks at Rebirth 2"), 3, Color3.new(1, 1, 1));

                    return;
                end;

                if ActivePets.Visible then
                    UI_Manager:CloseWindow(ActivePets, true);

                    return;
                end;

                refresh(true);
                UI_Manager:OpenWindow(ActivePets, true);
            end);
        end;
    end);
    local u31 = 0;
    RunService.Heartbeat:Connect(function(p32) -- Line: 166
        -- upvalues: ActivePets (copy), u31 (ref), refresh (copy)
        if not ActivePets.Visible then
            return;
        end;

        u31 = u31 + p32;

        if u31 < 1 then
            return;
        end;

        u31 = 0;
        refresh(false);
    end);
end;

function v1.KnitInit(p33) -- Line: 175
    -- upvalues: Knit (copy)
    p33.UI_Manager = Knit.GetController("UI_Manager");
    p33.DataClient = Knit.GetController("DataClient");
    p33.NotificationController = Knit.GetController("NotificationController");
end;

return v1;