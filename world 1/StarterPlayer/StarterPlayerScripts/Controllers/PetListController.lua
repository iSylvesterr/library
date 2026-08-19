-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local Worlds = require(game.ReplicatedStorage.SharedModules.Worlds);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local PetSlotPrices = require(ReplicatedStorage.SharedData.PetSlotPrices);
local AnimatedGradient = require(ReplicatedStorage.SharedModules.AnimatedGradient);
local Gradients = ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("RarityData"):WaitForChild("Gradients");
local LocalPlayer = Players.LocalPlayer;
local GuiController = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Controllers"):WaitForChild("GuiController"));
local u1 = {
    Common = Color3.fromRGB(180, 180, 180),
    Uncommon = Color3.fromRGB(60, 200, 70),
    Rare = Color3.fromRGB(60, 130, 255),
    Epic = Color3.fromRGB(160, 60, 220),
    Legendary = Color3.fromRGB(255, 215, 0),
    Mythic = Color3.fromRGB(220, 40, 40)
};
local u2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(140, 0, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 200))
});
local u3 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
local Common = u1.Common;
local v4 = {
    StartOrder = 4
};
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = {};
local u10 = {};

local function refreshScreenGuiEnabled() -- Line: 105
    -- upvalues: u7 (ref), u10 (copy), u9 (copy)
    if not u7 then
        return;
    end;

    u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
end;

local u11 = {};
local u12 = 0;

local function refreshHeader() -- Line: 120
    -- upvalues: u11 (copy), LocalPlayer (copy), PetSlotPrices (copy), u12 (ref)
    if #u11 == 0 then
        return;
    end;

    local v13 = LocalPlayer:GetAttribute("MaxEquippedPets");
    local v14 = `{u12}/{type(v13) == "number" and (v13 > 0 and math.floor(v13)) or PetSlotPrices.BaseMax} Active`;

    for _, v in u11 do
        v.Text = v14;
    end;
end;

local function recountEquipped() -- Line: 130
    -- upvalues: u10 (copy), u12 (ref), u11 (copy), LocalPlayer (copy), PetSlotPrices (copy)
    local v15 = 0;

    for _ in u10 do
        v15 = v15 + 1;
    end;

    u12 = v15;

    if #u11 == 0 then
        return;
    end;

    local v16 = LocalPlayer:GetAttribute("MaxEquippedPets");
    local v17 = `{u12}/{type(v16) == "number" and (v16 > 0 and math.floor(v16)) or PetSlotPrices.BaseMax} Active`;

    for _, v in u11 do
        v.Text = v17;
    end;
end;

local function applyRarityToLabel(p18, p19) -- Line: 139
    -- upvalues: u1 (copy), u2 (copy), u3 (copy), Common (copy)
    local v20 = u1[p19];

    if v20 then
        p18.TextColor3 = v20;

        return;
    end;

    if p19 ~= "Super" and p19 ~= "Secret" then
        p18.TextColor3 = Common;

        return;
    end;

    p18.TextColor3 = Color3.new(1, 1, 1);

    for _, child in p18:GetChildren() do
        if child:IsA("UIGradient") then
            child:Destroy();
        end;
    end;

    local UIGradient = Instance.new("UIGradient");
    local v21;

    if p19 == "Super" then
        v21 = u2;
    else
        v21 = u3;
    end;

    UIGradient.Color = v21;
    UIGradient.Parent = p18;
end;

local function applyRarityToBothLabels(p22, p23) -- Line: 174
    -- upvalues: applyRarityToLabel (copy)
    if p22:IsA("TextLabel") and not (p23 == "Super" and true or p23 == "Secret") then
        applyRarityToLabel(p22, p23);
    end;

    for _, child in p22:GetChildren() do
        if child:IsA("TextLabel") then
            applyRarityToLabel(child, p23);
        end;
    end;
end;

local function applyRainbowToLabel(p24) -- Line: 188
    -- upvalues: AnimatedGradient (copy), u2 (copy)
    p24.TextColor3 = Color3.new(1, 1, 1);

    for _, child in p24:GetChildren() do
        if child:IsA("UIGradient") then
            AnimatedGradient:Remove(child);
            child:Destroy();
        end;
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = u2;
    UIGradient.Parent = p24;
    AnimatedGradient:Add(UIGradient);
end;

local function applyRainbowToBothLabels(p25) -- Line: 206
    -- upvalues: applyRainbowToLabel (copy)
    for _, child in p25:GetChildren() do
        if child:IsA("TextLabel") then
            applyRainbowToLabel(child);
        end;
    end;
end;

local function setLabelText(p26, p27) -- Line: 214
    if p26:IsA("TextLabel") then
        p26.Text = p27;
    end;

    for _, child in p26:GetChildren() do
        if child:IsA("TextLabel") then
            child.Text = p27;
        end;
    end;
end;

local function showPetInfo(p28, p29, p30) -- Line: 239
    -- upvalues: u8 (ref), PetData (copy), GuiController (copy), PetTypes (copy), AnimatedGradient (copy), Gradients (copy), u2 (copy)
    if not u8 then
        return;
    end;

    local v31 = PetData[p28] or {};
    local v32 = PetData.GetImage(p28, p29);
    local v33 = v31.Rarity or "Common";
    local v34 = PetData.GetDescription(p28, p29, p30);
    local MainFrame = u8:FindFirstChild("MainFrame");

    if MainFrame then
        MainFrame = MainFrame:FindFirstChild("Content");
    end;

    if MainFrame then
        MainFrame = MainFrame:FindFirstChild("Info");
    end;

    if not MainFrame then
        GuiController:Open("PetInfo");

        return;
    end;

    local ImageDisplay = MainFrame:FindFirstChild("ImageDisplay");

    if ImageDisplay then
        ImageDisplay = ImageDisplay:FindFirstChild("PetImage");
    end;

    if ImageDisplay and ImageDisplay:IsA("ImageLabel") then
        ImageDisplay.Image = v32;

        if p30 == PetTypes.Rainbow then
            AnimatedGradient:AddRainbowColor(ImageDisplay, "ImageColor3");
        else
            AnimatedGradient:Remove(ImageDisplay);
        end;
    end;

    local v35 = PetData.GetDisplayName(p28, p29);
    local PetName = MainFrame:FindFirstChild("PetName");

    if PetName and PetName:IsA("TextLabel") then
        PetName.Text = v35;
        local TextLabel = PetName:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = v35;
        end;
    end;

    local Description = MainFrame:FindFirstChild("Description");

    if Description and Description:IsA("TextLabel") then
        Description.Text = v34;
    end;

    local Rarity = MainFrame:FindFirstChild("Rarity");

    if Rarity then
        for _, child in Rarity:GetChildren() do
            if child:IsA("UIGradient") then
                child:Destroy();
            end;
        end;

        local v36 = Gradients:FindFirstChild(v33);

        if v36 then
            v36:Clone().Parent = Rarity;
        end;

        local Rarity_Text = Rarity:FindFirstChild("Rarity_Text");

        if Rarity_Text and Rarity_Text:IsA("TextLabel") then
            Rarity_Text.Text = v33;
            local TextLabel = Rarity_Text:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = v33;
            end;
        end;
    end;

    local PetType = MainFrame:FindFirstChild("PetType");

    if PetType and PetType:IsA("Frame") then
        local v37 = PetTypes.GetDisplayText(p30);
        local v38 = PetType:FindFirstChildOfClass("UIGradient");

        if v37 then
            PetType.Visible = true;
            local PetType_Text = PetType:FindFirstChild("PetType_Text");

            if PetType_Text and PetType_Text:IsA("TextLabel") then
                PetType_Text.Text = v37;
                local TextLabel = PetType_Text:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.Text = v37;
                end;
            end;

            if v38 then
                v38.Color = u2;
                AnimatedGradient:Add(v38);
            end;
        else
            PetType.Visible = false;

            if v38 then
                AnimatedGradient:Remove(v38);
            end;
        end;
    end;

    GuiController:Open("PetInfo");
end;

function v4.ShowPetInfo(p39, p40, p41, p42) -- Line: 353
    -- upvalues: showPetInfo (copy)
    showPetInfo(p40, p41, p42);
end;

local function destroyClone(p43) -- Line: 357
    -- upvalues: u10 (copy), u12 (ref), u11 (copy), LocalPlayer (copy), PetSlotPrices (copy), u7 (ref), u9 (copy)
    local v44 = u10[p43];

    if v44 then
        u10[p43] = nil;
        v44:Destroy();
        local v45 = 0;

        for _ in u10 do
            v45 = v45 + 1;
        end;

        u12 = v45;

        if #u11 ~= 0 then
            local v46 = LocalPlayer:GetAttribute("MaxEquippedPets");
            local v47 = `{u12}/{type(v46) == "number" and (v46 > 0 and math.floor(v46)) or PetSlotPrices.BaseMax} Active`;

            for _, v in u11 do
                v.Text = v47;
            end;
        end;

        if not u7 then
            return;
        end;

        u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
    end;
end;

local function buildClone(u48) -- Line: 367
    -- upvalues: u5 (ref), u6 (ref), u10 (copy), PetData (copy), PetTypes (copy), AnimatedGradient (copy), setLabelText (copy), applyRainbowToBothLabels (copy), applyRarityToBothLabels (copy), u12 (ref), u11 (copy), LocalPlayer (copy), PetSlotPrices (copy), u7 (ref), u9 (copy), Networking (copy), showPetInfo (copy)
    if not (u5 and u6) then
        return;
    end;

    if u10[u48.Id] then
        return;
    end;

    local v49 = PetData[u48.Name] or {};
    local v50 = PetData.GetImage(u48.Name, u48.Size);
    local v51 = v49.Rarity or "Common";
    local v52 = u5:Clone();
    v52.Name = `PetEntry_{u48.Id}`;
    v52.Visible = true;
    local Main_Frame = v52:FindFirstChild("Main_Frame");

    if not Main_Frame then
        v52:Destroy();

        return;
    end;

    local v53 = u48.Type == PetTypes.Rainbow;
    local PetImage = Main_Frame:FindFirstChild("PetImage");

    if PetImage and PetImage:IsA("ImageLabel") then
        PetImage.Image = v50;

        if v53 then
            AnimatedGradient:AddRainbowColor(PetImage, "ImageColor3");
        end;
    end;

    local TextLabel = Main_Frame:FindFirstChild("TextLabel");

    if TextLabel then
        setLabelText(TextLabel, PetData.GetDisplayName(u48.Name, u48.Size));

        if v53 then
            applyRainbowToBothLabels(TextLabel);
        else
            applyRarityToBothLabels(TextLabel, v51);
        end;
    end;

    local Unequip = Main_Frame:FindFirstChild("Unequip");

    if Unequip and Unequip:IsA("GuiButton") then
        Unequip.Activated:Connect(function() -- Line: 410
            -- upvalues: u48 (copy), u10 (ref), u12 (ref), u11 (ref), LocalPlayer (ref), PetSlotPrices (ref), u7 (ref), u9 (ref), Networking (ref)
            local Id = u48.Id;
            local v54 = u10[Id];

            if v54 then
                u10[Id] = nil;
                v54:Destroy();
                local v55 = 0;

                for _ in u10 do
                    v55 = v55 + 1;
                end;

                u12 = v55;

                if #u11 ~= 0 then
                    local v56 = LocalPlayer:GetAttribute("MaxEquippedPets");
                    local v57 = `{u12}/{type(v56) == "number" and (v56 > 0 and math.floor(v56)) or PetSlotPrices.BaseMax} Active`;

                    for _, v in u11 do
                        v.Text = v57;
                    end;
                end;

                if u7 then
                    u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
                end;
            end;

            Networking.Pets.RequestUnequip:Fire(u48.Id);
        end);
    end;

    local InfoFrame = Main_Frame:FindFirstChild("InfoFrame");

    if InfoFrame then
        InfoFrame = InfoFrame:FindFirstChild("InfoButton");
    end;

    if InfoFrame and InfoFrame:IsA("GuiButton") then
        InfoFrame.Activated:Connect(function() -- Line: 426
            -- upvalues: showPetInfo (ref), u48 (copy)
            showPetInfo(u48.Name, u48.Size, u48.Type);
        end);
    end;

    v52.Parent = u6;
    u10[u48.Id] = v52;
    local v58 = 0;

    for _ in u10 do
        v58 = v58 + 1;
    end;

    u12 = v58;

    if #u11 ~= 0 then
        local v59 = LocalPlayer:GetAttribute("MaxEquippedPets");
        local v60 = `{u12}/{type(v59) == "number" and (v59 > 0 and math.floor(v59)) or PetSlotPrices.BaseMax} Active`;

        for _, v in u11 do
            v.Text = v60;
        end;
    end;

    if not u7 then
        return;
    end;

    u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
end;

local function rebuildAllFromList(p61) -- Line: 437
    -- upvalues: u10 (copy), u12 (ref), u11 (copy), LocalPlayer (copy), PetSlotPrices (copy), u7 (ref), u9 (copy), buildClone (copy)
    for i in u10 do
        local v62 = u10[i];

        if v62 then
            u10[i] = nil;
            v62:Destroy();
            local v63 = 0;

            for _ in u10 do
                v63 = v63 + 1;
            end;

            u12 = v63;

            if #u11 ~= 0 then
                local v64 = LocalPlayer:GetAttribute("MaxEquippedPets");
                local v65 = `{u12}/{type(v64) == "number" and (v64 > 0 and math.floor(v64)) or PetSlotPrices.BaseMax} Active`;

                for _, v in u11 do
                    v.Text = v65;
                end;
            end;

            if u7 then
                u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
            end;
        end;
    end;

    if type(p61) ~= "table" then
        return;
    end;

    for _, v in p61 do
        if type(v) == "table" and type(v.Id) == "string" then
            buildClone(v);
        end;
    end;
end;

function v4.Start(p66) -- Line: 452
    -- upvalues: LocalPlayer (copy), u7 (ref), u8 (ref), GuiController (copy), u6 (ref), u5 (ref), u11 (copy), PetSlotPrices (copy), Worlds (copy), Networking (copy), u12 (ref), buildClone (copy), u10 (copy), u9 (copy), rebuildAllFromList (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local PetList = PlayerGui:WaitForChild("PetList", 30);

    if not PetList then
        return;
    end;

    if PetList:IsA("ScreenGui") then
        u7 = PetList;
        u7.Enabled = false;
    end;

    local PetInfo = PlayerGui:WaitForChild("PetInfo", 10);

    if PetInfo and PetInfo:IsA("ScreenGui") then
        u8 = PetInfo;
        u8.Enabled = false;
        local MainFrame = PetInfo:FindFirstChild("MainFrame");

        if MainFrame then
            MainFrame = MainFrame:FindFirstChild("Header");
        end;

        if MainFrame then
            MainFrame = MainFrame:FindFirstChild("ExitButton");
        end;

        if MainFrame and MainFrame:IsA("GuiButton") then
            MainFrame.Activated:Connect(function() -- Line: 483
                -- upvalues: GuiController (ref)
                GuiController:Close();
            end);
        end;
    end;

    local Frame = PetList:WaitForChild("Frame", 10);
    local v67;

    if Frame then
        v67 = Frame:WaitForChild("Notepad", 10);
    else
        v67 = Frame;
    end;

    local v68;

    if v67 then
        v68 = v67:WaitForChild("ScrollingFrame", 10);
    else
        v68 = v67;
    end;

    local v69;

    if v68 then
        v69 = v68:WaitForChild("Template", 10);
    else
        v69 = v68;
    end;

    if not (Frame and (v67 and (v68 and v69))) then
        return;
    end;

    if not v69:IsA("GuiObject") then
        return;
    end;

    u6 = v68;
    u5 = v69;
    v69.Visible = false;
    local Header = Frame:FindFirstChild("Header");

    if Header then
        Header = Header:FindFirstChild("TextLabel");
    end;

    if Header and Header:IsA("TextLabel") then
        table.insert(u11, Header);

        for _, child in Header:GetChildren() do
            if child:IsA("TextLabel") then
                table.insert(u11, child);
            end;
        end;
    end;

    local u70 = {};

    local function getMaxSlots() -- Line: 522
        -- upvalues: LocalPlayer (ref), PetSlotPrices (ref)
        local v71 = LocalPlayer:GetAttribute("MaxEquippedPets");

        if type(v71) == "number" and v71 > 0 then
            return math.floor(v71);
        end;

        return PetSlotPrices.BaseMax;
    end;

    local function refreshPriceLabels() -- Line: 528
        -- upvalues: LocalPlayer (ref), PetSlotPrices (ref), u70 (copy), Worlds (ref)
        local v72 = LocalPlayer:GetAttribute("MaxEquippedPets");
        local v73;

        if type(v72) == "number" and v72 > 0 then
            v73 = math.floor(v72);
        else
            v73 = PetSlotPrices.BaseMax;
        end;

        local v74 = PetSlotPrices.GetNextPrice(v73);
        local v75 = not v74 and "MAX" or PetSlotPrices.AbbreviatePrice(v74);

        if v75 == "MAX" then
            for _, v in u70 do
                v.Text = "MAX SLOTS";
            end;

            return;
        end;

        for _, v in u70 do
            v.Text = "+1 MAX [" .. tostring(v75) .. Worlds.Current.CurrencySuffix .. "]";
        end;
    end;

    local v76 = Frame:FindFirstChild("MaxSlot", true) or Frame:FindFirstChild("HeaderMaxSlot", true) or (PetList:FindFirstChild("MaxSlot", true) or PetList:FindFirstChild("HeaderMaxSlot", true));
    local v77 = nil;

    if v76 then
        if v76:IsA("GuiButton") then
            v77 = v76;
        else
            for _, descendant in v76:GetDescendants() do
                if descendant:IsA("GuiButton") then
                    v77 = descendant;
                    break;
                end;
            end;
        end;
    end;

    if v76 then
        local Purchase = v76:FindFirstChild("Purchase");

        if Purchase then
            for _, descendant in Purchase:GetDescendants() do
                if descendant:IsA("TextLabel") then
                    table.insert(u70, descendant);
                end;
            end;

            local _ = #u70 == 0;
        end;

        if v77 then
            v77.Activated:Connect(function() -- Line: 596
                -- upvalues: Networking (ref)
                Networking.Pets.RequestPurchasePetSlot:Fire();
            end);
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("MaxEquippedPets"):Connect(function() -- Line: 603
        -- upvalues: u11 (ref), LocalPlayer (ref), PetSlotPrices (ref), u12 (ref), refreshPriceLabels (copy)
        if #u11 ~= 0 then
            local v78 = LocalPlayer:GetAttribute("MaxEquippedPets");
            local v79 = `{u12}/{type(v78) == "number" and (v78 > 0 and math.floor(v78)) or PetSlotPrices.BaseMax} Active`;

            for _, v in u11 do
                v.Text = v79;
            end;
        end;

        refreshPriceLabels();
    end);

    if #u11 ~= 0 then
        local v80 = LocalPlayer:GetAttribute("MaxEquippedPets");
        local v81 = `{u12}/{type(v80) == "number" and (v80 > 0 and math.floor(v80)) or PetSlotPrices.BaseMax} Active`;

        for _, v in u11 do
            v.Text = v81;
        end;
    end;

    refreshPriceLabels();
    Networking.Pets.PetEquipped.OnClientEvent:Connect(function(p82, p83) -- Line: 615
        -- upvalues: buildClone (ref)
        if type(p82) ~= "string" then
            return;
        end;

        if type(p83) ~= "table" then
            return;
        end;

        p83.Id = p83.Id or p82;
        p83.Name = p83.Name or "Pet";
        buildClone(p83);
    end);
    Networking.Pets.PetUnequipped.OnClientEvent:Connect(function(p84) -- Line: 625
        -- upvalues: u10 (ref), u12 (ref), u11 (ref), LocalPlayer (ref), PetSlotPrices (ref), u7 (ref), u9 (ref)
        if type(p84) ~= "string" then
            return;
        end;

        local v85 = u10[p84];

        if v85 then
            u10[p84] = nil;
            v85:Destroy();
            local v86 = 0;

            for _ in u10 do
                v86 = v86 + 1;
            end;

            u12 = v86;

            if #u11 ~= 0 then
                local v87 = LocalPlayer:GetAttribute("MaxEquippedPets");
                local v88 = `{u12}/{type(v87) == "number" and (v87 > 0 and math.floor(v87)) or PetSlotPrices.BaseMax} Active`;

                for _, v in u11 do
                    v.Text = v88;
                end;
            end;

            if not u7 then
                return;
            end;

            u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
        end;
    end);

    local function trackToolPet(u89) -- Line: 630
        -- upvalues: u9 (ref), u7 (ref), u10 (ref)
        local function update() -- Line: 631
            -- upvalues: u89 (copy), u9 (ref), u7 (ref), u10 (ref)
            local v90 = u89:GetAttribute("PetId");

            if type(v90) == "string" and v90 ~= "" then
                u9[v90] = true;

                if not u7 then
                    return;
                end;

                u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
            end;
        end;

        local v91 = u89:GetAttribute("PetId");

        if type(v91) == "string" and v91 ~= "" then
            u9[v91] = true;

            if u7 then
                u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
            end;
        end;

        u89:GetAttributeChangedSignal("PetId"):Connect(update);
    end;

    local function untrackToolPet(p92) -- Line: 642
        -- upvalues: u9 (ref), u7 (ref), u10 (ref)
        local v93 = p92:GetAttribute("PetId");

        if type(v93) ~= "string" or v93 == "" then
            return;
        end;

        u9[v93] = nil;

        if not u7 then
            return;
        end;

        u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
    end;

    local function watchContainer(p94) -- Line: 649
        -- upvalues: u9 (ref), u7 (ref), u10 (ref)
        for _, child in p94:GetChildren() do
            if child:IsA("Tool") then
                local function v96() -- Line: 631
                    -- upvalues: child (copy), u9 (ref), u7 (ref), u10 (ref)
                    local v95 = child:GetAttribute("PetId");

                    if type(v95) == "string" and v95 ~= "" then
                        u9[v95] = true;

                        if not u7 then
                            return;
                        end;

                        u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
                    end;
                end;

                local v97 = child:GetAttribute("PetId");

                if type(v97) == "string" and v97 ~= "" then
                    u9[v97] = true;

                    if u7 then
                        u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
                    end;
                end;

                child:GetAttributeChangedSignal("PetId"):Connect(v96);
            end;
        end;

        p94.ChildAdded:Connect(function(u98) -- Line: 653
            -- upvalues: u9 (ref), u7 (ref), u10 (ref)
            if u98:IsA("Tool") then
                local function v100() -- Line: 631
                    -- upvalues: u98 (copy), u9 (ref), u7 (ref), u10 (ref)
                    local v99 = u98:GetAttribute("PetId");

                    if type(v99) == "string" and v99 ~= "" then
                        u9[v99] = true;

                        if not u7 then
                            return;
                        end;

                        u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
                    end;
                end;

                local v101 = u98:GetAttribute("PetId");

                if type(v101) == "string" and v101 ~= "" then
                    u9[v101] = true;

                    if u7 then
                        u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
                    end;
                end;

                u98:GetAttributeChangedSignal("PetId"):Connect(v100);
            end;
        end);
        p94.ChildRemoved:Connect(function(p102) -- Line: 656
            -- upvalues: u9 (ref), u7 (ref), u10 (ref)
            if p102:IsA("Tool") then
                local v103 = p102:GetAttribute("PetId");

                if type(v103) == "string" then
                    if v103 == "" then
                        return;
                    end;

                    u9[v103] = nil;

                    if not u7 then
                        return;
                    end;

                    u7.Enabled = next(u10) ~= nil and true or next(u9) ~= nil;
                end;
            end;
        end);
    end;

    task.spawn(function() -- Line: 661
        -- upvalues: LocalPlayer (ref), watchContainer (copy)
        local Backpack = LocalPlayer:WaitForChild("Backpack", 30);

        if Backpack then
            watchContainer(Backpack);
        end;
    end);

    local function onCharacter(p104) -- Line: 666
        -- upvalues: watchContainer (copy)
        watchContainer(p104);
    end;

    if LocalPlayer.Character then
        watchContainer(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(onCharacter);
    task.spawn(function() -- Line: 677
        -- upvalues: Networking (ref), rebuildAllFromList (ref)
        local success, result = pcall(function() -- Line: 678
            -- upvalues: Networking (ref)
            return Networking.Pets.GetEquippedPets:Fire();
        end);

        if success and type(result) == "table" then
            rebuildAllFromList(result);
        end;
    end);
end;

return v4;