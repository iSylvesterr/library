-- Decompiled with Potassium's decompiler.

local u1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local PlayerStateClient = require(ReplicatedStorage.ClientModules.PlayerStateClient);
local FruitProxyUtil = require(ReplicatedStorage.SharedModules.FruitProxyUtil);
local MagicMailData = require(ReplicatedStorage.SharedModules.MagicMailData);
local MagicMailFlags = require(ReplicatedStorage.SharedModules.Flags.MagicMailFlags);
local MutationData = require(ReplicatedStorage.SharedModules.MutationData);
local AnimatedGradient = require(ReplicatedStorage.SharedModules.AnimatedGradient);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local WeightFormat = require(ReplicatedStorage.SharedModules.WeightFormat);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local MailboxItemCatalog = require(LocalPlayer.PlayerScripts.Controllers.MailboxController.MailboxItemCatalog);

local function styledMutationText(p2) -- Line: 47
    -- upvalues: MutationData (copy)
    local v3 = MutationData.GetMutation(p2);

    if v3 then
        v3 = v3.Gradient;
    end;

    if not (v3 and v3:IsA("UIGradient")) then
        return p2;
    end;

    local Keypoints = v3.Color.Keypoints;
    local v4 = math.ceil(#Keypoints / 2);
    local Value = Keypoints[math.max(1, v4)].Value;

    return `<font color="{string.format("#%02X%02X%02X", math.floor(Value.R * 255 + 0.5), math.floor(Value.G * 255 + 0.5), (math.floor(Value.B * 255 + 0.5)))}">{p2}</font>`;
end;

local u5 = {
    Rare = "UIGradient_Rare",
    Legendary = "UIGradient_Legendary",
    Super = "UIGradient_Super"
};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = {};
local u12 = nil;
local u13 = false;
local u14 = nil;
local u15 = {};
local u16 = {};

local function trackSession(p17) -- Line: 87
    -- upvalues: u11 (copy)
    table.insert(u11, p17);
end;

local function clearSessionConnections() -- Line: 91
    -- upvalues: u11 (copy)
    for _, v in u11 do
        v:Disconnect();
    end;

    table.clear(u11);
end;

local function escrowCount() -- Line: 98
    -- upvalues: u15 (ref)
    local v18 = 0;

    for _ in u15 do
        v18 = v18 + 1;
    end;

    return v18;
end;

local function isPlainPet(p19) -- Line: 123
    local v20;

    if (p19.Mutation == nil or p19.Mutation == "") and (p19.Size == nil or p19.Size == "") then
        v20 = p19.Type == nil and true or p19.Type == "";
    else
        v20 = false;
    end;

    return v20;
end;

local function sendCountFor(p21, p22) -- Line: 130
    -- upvalues: MagicMailFlags (copy)
    if p21 == "Pets" or p21 == "HarvestedFruits" then
        return 1;
    end;

    local v23 = MagicMailFlags.MaxUnitsPerMail:Get()[p21] or 1;

    return math.min(p22, v23);
end;

local function collectEntries(u24) -- Line: 138
    -- upvalues: PlayerStateClient (copy), MagicMailData (copy), u16 (copy), MailboxItemCatalog (copy), MagicMailFlags (copy), FruitProxyUtil (copy), LocalPlayer (copy)
    local u25 = {};
    local v26 = PlayerStateClient:GetLocalReplica();
    local v27 = v26 and v26.Data and v26.Data.Inventory;

    if typeof(v27) == "table" then
        for i in MagicMailData.SendableCategories do
            if i ~= "HarvestedFruits" then
                local v28 = v27[i];

                if typeof(v28) == "table" then
                    if i == "Pets" then
                        local v29 = {};

                        for i2, v in v28 do
                            if typeof(v) == "table" and (v.Id ~= nil and (v.Equipped ~= true and (not u16[i2] and (v.IsFavorite ~= true and u24 >= MagicMailData.ResolveRank(i, i2, v.Name))))) then
                                local v30;

                                if (v.Mutation == nil or v.Mutation == "") and (v.Size == nil or v.Size == "") then
                                    v30 = v.Type == nil and true or v.Type == "";
                                else
                                    v30 = false;
                                end;

                                if v30 and typeof(v.Name) == "string" then
                                    local v31 = v29[v.Name];

                                    if v31 then
                                        v31.Count = v31.Count + 1;
                                    else
                                        v29[v.Name] = {
                                            Count = 1,
                                            Pet = v,
                                            PetId = i2
                                        };
                                    end;
                                else
                                    local v32, v33 = MailboxItemCatalog.Resolve(i, i2, v);
                                    local v34 = {
                                        SendCount = 1,
                                        OwnedCount = 1,
                                        Category = i,
                                        ItemKey = i2,
                                        DisplayName = v32,
                                        Image = v33,
                                        Rarity = MagicMailData.ResolveRarity(i, i2, v.Name),
                                        EntryValue = v
                                    };
                                    table.insert(u25, v34);
                                end;
                            end;
                        end;

                        for _, v in v29 do
                            local v35, v36 = MailboxItemCatalog.Resolve(i, v.PetId, v.Pet);
                            local v37 = {
                                SendCount = 1,
                                Category = i,
                                ItemKey = v.PetId,
                                DisplayName = v35,
                                Image = v36,
                                OwnedCount = v.Count,
                                Rarity = MagicMailData.ResolveRarity(i, v.PetId, v.Pet.Name),
                                EntryValue = v.Pet
                            };
                            table.insert(u25, v37);
                        end;
                    else
                        for i2, v in v28 do
                            if typeof(v) == "number" and (v >= 1 and u24 >= MagicMailData.ResolveRank(i, i2, nil)) then
                                local v38, v39 = MailboxItemCatalog.Resolve(i, i2, nil);
                                local v40 = {
                                    EntryValue = nil,
                                    Category = i,
                                    ItemKey = i2,
                                    DisplayName = v38,
                                    Image = v39
                                };
                                local v41;

                                if i == "Pets" or i == "HarvestedFruits" then
                                    v41 = 1;
                                else
                                    local v42 = MagicMailFlags.MaxUnitsPerMail:Get()[i] or 1;
                                    v41 = math.min(v, v42);
                                end;

                                v40.SendCount = v41;
                                v40.OwnedCount = v;
                                v40.Rarity = MagicMailData.ResolveRarity(i, i2, nil);
                                table.insert(u25, v40);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local function scanFruitContainer(p43) -- Line: 213
        -- upvalues: FruitProxyUtil (ref), MagicMailData (ref), u24 (copy), MailboxItemCatalog (ref), u25 (copy)
        if not p43 then
            return;
        end;

        for _, child in p43:GetChildren() do
            if FruitProxyUtil.IsFruitInstance(child) then
                local v44 = child:GetAttribute("Id");
                local v45 = child:GetAttribute("FruitName");

                if typeof(v44) == "string" and (typeof(v45) == "string" and u24 >= MagicMailData.ResolveRank("HarvestedFruits", v44, v45)) then
                    local v46 = {
                        Id = v44,
                        FruitName = v45,
                        Mutation = child:GetAttribute("Mutation"),
                        Weight = tonumber(child:GetAttribute("Weight"))
                    };
                    local v47, v48 = MailboxItemCatalog.Resolve("HarvestedFruits", v44, v46);
                    local v49 = {
                        Category = "HarvestedFruits",
                        SendCount = 1,
                        OwnedCount = 1,
                        ItemKey = v44,
                        DisplayName = v47,
                        Image = v48,
                        Rarity = MagicMailData.ResolveRarity("HarvestedFruits", v44, v45),
                        EntryValue = v46
                    };
                    table.insert(u25, v49);
                end;
            end;
        end;
    end;

    scanFruitContainer(LocalPlayer:FindFirstChild("Backpack"));
    scanFruitContainer(LocalPlayer.Character);
    table.sort(u25, function(p50, p51) -- Line: 243
        if p50.Category == p51.Category then
            return p50.DisplayName < p51.DisplayName;
        end;

        return p50.Category < p51.Category;
    end);

    return u25;
end;

local function updateStatusLabel(p52) -- Line: 259
    -- upvalues: u10 (ref), u14 (ref), MailboxItemCatalog (copy), WeightFormat (copy)
    if not u10 then
        return;
    end;

    local v53 = u14;

    if not v53 then
        u10.Text = p52 and "You don\'t have anything to send" or "Select an item to send to Garden Valley";

        return;
    end;

    if v53.Category ~= "HarvestedFruits" then
        local v54 = MailboxItemCatalog.Resolve(v53.Category, v53.ItemKey, v53.EntryValue);
        local v55;

        if v53.Count > 1 then
            v55 = `Sending: x{v53.Count} {v54}`;
        else
            v55 = `Sending: {v54}`;
        end;

        u10.Text = v55;

        return;
    end;

    local v56;

    if typeof(v53.EntryValue) == "table" then
        v56 = tonumber(v53.EntryValue.Weight) or nil;
    else
        v56 = nil;
    end;

    local v57 = MailboxItemCatalog.Resolve(v53.Category, v53.ItemKey, v53.EntryValue);
    local v58;

    if v56 then
        v58 = `Sending: {v57} ({WeightFormat.FormatGrams(v56)})`;
    else
        v58 = `Sending: {v57}`;
    end;

    u10.Text = v58;
end;

local function bindTile(p59, u60) -- Line: 278
    -- upvalues: PetTypes (copy), AnimatedGradient (copy), MutationData (copy), WeightFormat (copy), styledMutationText (copy), u14 (ref), u1 (copy), u11 (copy)
    p59.Name = "Item_" .. u60.Category .. ":" .. u60.ItemKey;
    p59.Visible = true;
    p59.Active = true;
    local Sunburst = p59:FindFirstChild("Sunburst");

    if Sunburst and Sunburst:IsA("ImageLabel") then
        Sunburst.Image = u60.Image;
        local EntryValue = u60.EntryValue;
        local v61;

        if u60.Category == "Pets" and typeof(EntryValue) == "table" then
            v61 = EntryValue.Type == PetTypes.Rainbow;
        else
            v61 = false;
        end;

        if v61 then
            AnimatedGradient:AddRainbowColor(Sunburst, "ImageColor3");
        else
            local v62;

            if typeof(EntryValue) == "table" then
                v62 = EntryValue.Mutation or nil;
            else
                v62 = nil;
            end;

            if typeof(v62) == "string" and v62 ~= "" then
                local v63 = MutationData.GetMutation(v62);

                if v63 and v63.Gradient then
                    v63.Gradient:Clone().Parent = Sunburst;
                end;
            end;
        end;
    end;

    local AmountTextLabel = p59:FindFirstChild("AmountTextLabel");

    if AmountTextLabel and AmountTextLabel:IsA("TextLabel") then
        if u60.Category == "HarvestedFruits" then
            local v64;

            if typeof(u60.EntryValue) == "table" then
                v64 = tonumber(u60.EntryValue.Weight) or nil;
            else
                v64 = nil;
            end;

            AmountTextLabel.Text = not v64 and "" or WeightFormat.FormatGrams(v64);
            AmountTextLabel.Visible = v64 ~= nil;
        elseif u60.Category == "Pets" then
            AmountTextLabel.Text = "x" .. tostring(u60.OwnedCount);
            AmountTextLabel.Visible = u60.OwnedCount > 1;
        else
            AmountTextLabel.Text = "x" .. tostring(u60.OwnedCount);
            AmountTextLabel.Visible = true;
        end;
    end;

    local v65;

    if u60.Category == "HarvestedFruits" then
        local EntryValue = u60.EntryValue;
        local v66 = {};
        local v67;

        if typeof(EntryValue) == "table" then
            v67 = tonumber(EntryValue.Weight) or nil;
        else
            v67 = nil;
        end;

        if v67 then
            table.insert(v66, WeightFormat.FormatGrams(v67));
        end;

        local v68;

        if typeof(EntryValue) == "table" then
            v68 = EntryValue.Mutation or nil;
        else
            v68 = nil;
        end;

        if typeof(v68) == "string" and v68 ~= "" then
            local v69 = styledMutationText(v68);
            table.insert(v66, v69);
        end;

        if #v66 > 0 then
            v65 = table.concat(v66, " - ");
        else
            v65 = nil;
        end;
    elseif u60.Category == "Pets" then
        local EntryValue = u60.EntryValue;
        local v70 = {};

        if typeof(EntryValue) == "table" then
            if typeof(EntryValue.Mutation) == "string" and EntryValue.Mutation ~= "" then
                local v71 = styledMutationText(EntryValue.Mutation);
                table.insert(v70, v71);
            end;

            if typeof(EntryValue.Size) == "string" and EntryValue.Size ~= "" then
                table.insert(v70, EntryValue.Size);
            end;

            if EntryValue.Type == PetTypes.Rainbow then
                table.insert(v70, "<font color=\"#FF5555\">R</font><font color=\"#FFAA33\">a</font><font color=\"#FFE14A\">i</font><font color=\"#66DD55\">n</font><font color=\"#55BBFF\">b</font><font color=\"#7788FF\">o</font><font color=\"#BB66FF\">w</font>");
            end;
        end;

        table.insert(v70, "Sends 1 per mail");
        v65 = table.concat(v70, " - ");
    else
        v65 = u60.SendCount <= 1 and "Sends 1 per mail" or `Sends x{u60.SendCount} per mail`;
    end;

    p59:SetAttribute("ItemToolTip", u60.DisplayName);
    p59:SetAttribute("ItemToolTipImage", u60.Image);
    p59:SetAttribute("ItemToolTipRarity", u60.Rarity or "");

    if v65 then
        p59:SetAttribute("ItemToolTipSubtitle", v65);
    end;

    local v73 = p59.Activated:Connect(function() -- Line: 380
        -- upvalues: u14 (ref), u60 (copy), u1 (ref)
        local v72 = u14;

        if v72 and (v72.Category == u60.Category and v72.ItemKey == u60.ItemKey) then
            u14 = nil;
        else
            u14 = {
                Category = u60.Category,
                ItemKey = u60.ItemKey,
                Count = u60.SendCount,
                EntryValue = u60.EntryValue
            };
        end;

        u1:_rebuildGrid();
    end);
    table.insert(u11, v73);
end;

function u1._rebuildGrid(p74) -- Line: 396
    -- upvalues: u7 (ref), u8 (ref), u9 (ref), u12 (ref), MagicMailData (copy), collectEntries (copy), u14 (ref), bindTile (copy), updateStatusLabel (copy)
    local v75 = u7;

    if not (v75 and (u8 and u9)) then
        return;
    end;

    if not u12 then
        return;
    end;

    local v76 = MagicMailData.Get(u12);

    if not v76 then
        return;
    end;

    for _, child in v75:GetChildren() do
        if child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    local v77 = collectEntries(v76.MaxSendableRank);

    if u14 then
        local v78 = false;

        for _, v in v77 do
            if v.Category == u14.Category and v.ItemKey == u14.ItemKey then
                v78 = true;
                break;
            end;
        end;

        if not v78 then
            u14 = nil;
        end;
    end;

    for _, v in v77 do
        local v79;

        if u14 == nil or u14.Category ~= v.Category then
            v79 = false;
        else
            v79 = u14.ItemKey == v.ItemKey;
        end;

        local v80;

        if v79 then
            v80 = u9;
        else
            v80 = u8;
        end;

        local v81 = v80:Clone();
        bindTile(v81, v);
        v81.Parent = v75;
    end;

    updateStatusLabel(#v77 == 0);
end;

local function applyTierChrome(p82) -- Line: 438
    -- upvalues: u6 (ref), u5 (copy)
    if not u6 then
        return;
    end;

    local Frame = u6:FindFirstChild("Frame");

    if Frame then
        Frame = Frame:FindFirstChild("Header");
    end;

    if not Frame then
        return;
    end;

    for _, v in u5 do
        local v83 = Frame:FindFirstChild(v);

        if v83 and v83:IsA("UIGradient") then
            v83.Enabled = u5[p82.Rarity] == v;
        end;
    end;

    local UIGradient_Tan = Frame:FindFirstChild("UIGradient_Tan");

    if UIGradient_Tan and UIGradient_Tan:IsA("UIGradient") then
        UIGradient_Tan.Enabled = u5[p82.Rarity] == nil;
    end;

    local TextLabel = Frame:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = p82.DisplayName;

        for _, descendant in TextLabel:GetDescendants() do
            if descendant:IsA("TextLabel") then
                descendant.Text = p82.DisplayName;
            end;
        end;
    end;
end;

local function closeUI() -- Line: 470
    -- upvalues: u11 (copy), u14 (ref), u12 (ref), u6 (ref), GuiController (copy)
    for _, v in u11 do
        v:Disconnect();
    end;

    table.clear(u11);
    u14 = nil;
    u12 = nil;

    if u6 and u6.Enabled then
        GuiController:Close();
    end;
end;

local function openFor(p84) -- Line: 479
    -- upvalues: u6 (ref), MagicMailData (copy), MagicMailFlags (copy), NotificationController (copy), u11 (copy), GuiController (copy), u14 (ref), u12 (ref), applyTierChrome (copy), u1 (copy), u15 (ref), PlayerStateClient (copy), LocalPlayer (copy)
    if not u6 then
        return;
    end;

    local v85 = MagicMailData.Get(p84);

    if not v85 then
        return;
    end;

    if not MagicMailFlags.Enabled:Get() then
        NotificationController:CreateNotification("Magic Mail is currently unavailable.");

        return;
    end;

    for _, v in u11 do
        v:Disconnect();
    end;

    table.clear(u11);
    GuiController:Open("MagicMailUI", nil, { "HUD" });

    if not u6.Enabled then
        return;
    end;

    u14 = nil;
    u12 = p84;
    applyTierChrome(v85);
    u1:_rebuildGrid();
    local v86 = MagicMailFlags.EscrowCap:Get();
    local v87 = 0;

    for _ in u15 do
        v87 = v87 + 1;
    end;

    if v86 <= v87 then
        NotificationController:CreateNotification((`Your Magic Mail storage is full ({v86})! Claim items in Garden Valley first.`));
    end;

    local v88 = PlayerStateClient:GetLocalReplica();

    if v88 then
        local v91 = v88:OnChange(function(p89, p90) -- Line: 517
            -- upvalues: u6 (ref), u1 (ref)
            if not (u6 and u6.Enabled) then
                return;
            end;

            if typeof(p90) == "table" and p90[1] == "Inventory" then
                u1:_rebuildGrid();
            end;
        end);
        table.insert(u11, v91);
    end;

    local Backpack = LocalPlayer:FindFirstChild("Backpack");

    if Backpack then
        local v92 = Backpack.ChildAdded:Connect(function() -- Line: 528
            -- upvalues: u6 (ref), u1 (ref)
            task.defer(function() -- Line: 529
                -- upvalues: u6 (ref), u1 (ref)
                if u6 and u6.Enabled then
                    u1:_rebuildGrid();
                end;
            end);
        end);
        table.insert(u11, v92);
        local v93 = Backpack.ChildRemoved:Connect(function() -- Line: 535
            -- upvalues: u6 (ref), u1 (ref)
            task.defer(function() -- Line: 536
                -- upvalues: u6 (ref), u1 (ref)
                if u6 and u6.Enabled then
                    u1:_rebuildGrid();
                end;
            end);
        end);
        table.insert(u11, v93);
    end;
end;

local function sendSelected() -- Line: 545
    -- upvalues: u13 (ref), u12 (ref), u14 (ref), NotificationController (copy), Networking (copy), PlayerStateClient (copy), u11 (copy), u6 (ref), GuiController (copy), u1 (copy)
    if u13 then
        return;
    end;

    local u94 = u12;
    local u95 = u14;

    if not (u94 and u95) then
        NotificationController:CreateNotification("Select an item to send first!");

        return;
    end;

    u13 = true;
    task.spawn(function() -- Line: 555
        -- upvalues: Networking (ref), u94 (copy), u95 (copy), u13 (ref), NotificationController (ref), u14 (ref), PlayerStateClient (ref), u11 (ref), u12 (ref), u6 (ref), GuiController (ref), u1 (ref)
        local v96, v97, v98 = pcall(function() -- Line: 556
            -- upvalues: Networking (ref), u94 (ref), u95 (ref)
            return Networking.MagicMail.Send:Fire(u94, u95.Category, u95.ItemKey, u95.Count);
        end);
        u13 = false;

        if not v96 then
            NotificationController:CreateNotification("Try again");

            return;
        end;

        if typeof(v98) == "string" and v98 ~= "" then
            NotificationController:CreateNotification(v98);
        end;

        if v97 then
            u14 = nil;
            local v99 = PlayerStateClient:GetLocalReplica();
            local v100 = v99 and (v99.Data and v99.Data.Inventory) and v99.Data.Inventory.MagicMails;

            if (typeof(v100) == "table" and v100[u94] or 0) <= 0 then
                for _, v in u11 do
                    v:Disconnect();
                end;

                table.clear(u11);
                u14 = nil;
                u12 = nil;

                if u6 and u6.Enabled then
                    GuiController:Close();
                end;
            else
                u1:_rebuildGrid();
            end;
        end;
    end);
end;

function u1.Init(p101) -- Line: 587
end;

function u1.Start(p102) -- Line: 590
    -- upvalues: u6 (ref), PlayerGui (copy), u7 (ref), u8 (ref), u9 (ref), u10 (ref), closeUI (copy), sendSelected (copy), Networking (copy), u16 (copy), u1 (copy), Worlds (copy), openFor (copy), u15 (ref), GuiController (copy), u11 (copy), u14 (ref), u12 (ref)
    u6 = PlayerGui:WaitForChild("MagicMailUI", 30);

    if not u6 then
        warn("[MagicMailController] MagicMailUI missing from PlayerGui");

        return;
    end;

    local Frame = u6:WaitForChild("Frame");
    u7 = Frame:WaitForChild("ScrollingFrame");
    u8 = Frame:WaitForChild("PropSelectionTemplate");
    u9 = Frame:WaitForChild("PropSelectionSelectedTemplate");
    local TextLabel = Frame:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        u10 = TextLabel;
    end;

    local ExitButton = Frame:FindFirstChild("ExitButton", true);

    if ExitButton and ExitButton:IsA("GuiButton") then
        ExitButton.Active = true;
        ExitButton.Activated:Connect(closeUI);
    end;

    local AcceptButton = Frame:FindFirstChild("AcceptButton");

    if AcceptButton and AcceptButton:IsA("GuiButton") then
        AcceptButton.Active = true;
        AcceptButton.Activated:Connect(sendSelected);
    end;

    Networking.Pets.PetEquipped.OnClientEvent:Connect(function(p103) -- Line: 619
        -- upvalues: u16 (ref), u6 (ref), u1 (ref)
        if typeof(p103) ~= "string" then
            return;
        end;

        u16[p103] = true;

        if u6 and u6.Enabled then
            u1:_rebuildGrid();
        end;
    end);
    Networking.Pets.PetUnequipped.OnClientEvent:Connect(function(p104) -- Line: 626
        -- upvalues: u16 (ref), u6 (ref), u1 (ref)
        if typeof(p104) ~= "string" then
            return;
        end;

        u16[p104] = nil;

        if u6 and u6.Enabled then
            u1:_rebuildGrid();
        end;
    end);
    task.spawn(function() -- Line: 633
        -- upvalues: Networking (ref), u16 (ref)
        local success, result = pcall(function() -- Line: 634
            -- upvalues: Networking (ref)
            return Networking.Pets.GetEquippedPets:Fire();
        end);

        if success and typeof(result) == "table" then
            for _, v in result do
                if typeof(v) == "table" and typeof(v.Id) == "string" then
                    u16[v.Id] = true;
                end;
            end;
        end;
    end);
    Networking.MagicMail.OpenSendUI.OnClientEvent:Connect(function(p105) -- Line: 646
        -- upvalues: Worlds (ref), openFor (ref)
        if typeof(p105) ~= "string" then
            return;
        end;

        if not Worlds.Current.Features.MagicMailSend then
            return;
        end;

        openFor(p105);
    end);
    Networking.MagicMail.Updated.OnClientEvent:Connect(function(p106) -- Line: 652
        -- upvalues: u15 (ref)
        if typeof(p106) == "table" then
            u15 = p106;
        end;
    end);
    GuiController.GuiUnfocusedSignal:Connect(function(p107) -- Line: 660
        -- upvalues: u6 (ref), u11 (ref), u14 (ref), u12 (ref)
        if p107 == u6 then
            for _, v in u11 do
                v:Disconnect();
            end;

            table.clear(u11);
            u14 = nil;
            u12 = nil;
        end;
    end);
end;

return u1;