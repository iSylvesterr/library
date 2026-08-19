-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("UserInputService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local FertilizerConfig = require(ReplicatedStorage.Shared.Info.FertilizerConfig);
local WormConfig = require(ReplicatedStorage.Shared.Info.WormConfig);
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig);
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local AbbreviateNumber = require(ReplicatedStorage.Shared.Utility.AbbreviateNumber);
local u1 = Color3.fromRGB(0, 255, 0);
local u2 = Color3.fromRGB(255, 0, 0);
local u3 = Color3.fromRGB(255, 204, 0);

local function colorTag(p4, p5) -- Line: 35
    return string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", p5.R * 255, p5.G * 255, p5.B * 255, p4);
end;

local function goldTag(p6) -- Line: 40
    -- upvalues: colorTag (copy), u3 (copy)
    return colorTag(p6, u3);
end;

local function trimNumber(p7) -- Line: 45
    local v8 = string.format("%.2f", p7);

    if v8:find("%.") then
        v8 = v8:gsub("0+$", ""):gsub("%.$", "");
    end;

    return v8;
end;

local v9 = Knit.CreateController({
    Name = "SeedPlantController"
});

local function getEquippedSeedTool(p10) -- Line: 55
    local Character = p10.Character;

    if not Character then
        return nil;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("IsSeed") then
            return child;
        end;
    end;

    return nil;
end;

function v9.KnitStart(u11) -- Line: 66
    -- upvalues: Maid (copy), Players (copy), Knit (copy), getEquippedSeedTool (copy), SeedConfig (copy), FertilizerConfig (copy), CustomEnum (copy), u1 (copy), AbbreviateNumber (copy), u2 (copy), WormConfig (copy), MutationConfig (copy), u3 (copy), colorTag (copy), goldTag (copy), RunService (copy)
    local u12 = Maid.new();
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local u13 = Knit.GetService("PlayerPlotService");
    local u14 = Knit.GetService("PlantRoundService");
    local UI_Manager = u11.UI_Manager;
    local DataClient = u11.DataClient;
    local FertilizerSelect = PlayerGui:WaitForChild("Windows"):WaitForChild("FertilizerSelect");
    local Content = FertilizerSelect:WaitForChild("Content");
    local Fertilizers = Content:WaitForChild("Fertilizers");
    local Exit = FertilizerSelect:WaitForChild("Top"):WaitForChild("Exit");
    local Worms = Content:WaitForChild("Worms");
    local ItemHolder = Worms:WaitForChild("WormsListScrolling"):WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder");
    local u15 = ItemHolder:WaitForChild("WormCell"):Clone();
    ItemHolder.WormCell:Destroy();
    local UIListLayout = ItemHolder:WaitForChild("UIListLayout");
    local StartSpacer = ItemHolder:WaitForChild("StartSpacer");
    local EndSpacer = ItemHolder:WaitForChild("EndSpacer");
    local u16 = nil;
    local u17 = false;

    local function getRebirth() -- Line: 93
        -- upvalues: DataClient (copy)
        local currentData = DataClient.currentData;

        return currentData and currentData.Rebirth or 0;
    end;

    local u18 = nil;

    local function closeUI() -- Line: 100
        -- upvalues: u17 (ref), UI_Manager (copy), FertilizerSelect (copy)
        if not u17 then
            return;
        end;

        u17 = false;
        UI_Manager:CloseWindow(FertilizerSelect, true);
    end;

    local function openUI() -- Line: 106
        -- upvalues: getEquippedSeedTool (ref), LocalPlayer (copy), DataClient (copy), u14 (copy), SeedConfig (ref), FertilizerConfig (ref), CustomEnum (ref), Fertilizers (copy), u1 (ref), AbbreviateNumber (ref), u2 (ref), u18 (ref), u17 (ref), UI_Manager (copy), FertilizerSelect (copy)
        local v19 = getEquippedSeedTool(LocalPlayer);

        if not v19 then
            return;
        end;

        local currentData = DataClient.currentData;

        if (currentData and currentData.Rebirth or 0) < 1 then
            u14:StartRound(v19:GetAttribute("SeedType") or "Oak", "None");

            return;
        end;

        local v20 = v19:GetAttribute("SeedType") or "Oak";
        local v21 = SeedConfig.GetSeed(v20);
        local v22 = FertilizerConfig.GetSeedValue(v20, v21 and v21.plantCost or 0);
        local currentData2 = DataClient.currentData;
        local v23 = currentData2 and currentData2.Rebirth or 0;
        local v24 = DataClient.currentData and (DataClient.currentData.Currency and DataClient.currentData.Currency[CustomEnum.CURRENCIES.COINS]) or 0;

        for _, v in FertilizerConfig.Order do
            local v25 = Fertilizers:FindFirstChild(v);

            if v25 then
                v25 = v25:FindFirstChild("Button");
            end;

            if v25 then
                local v26 = not FertilizerConfig.IsUnlocked(v, v23);
                local Locked = v25:FindFirstChild("Locked");
                local Price = v25:FindFirstChild("Price");

                if Locked then
                    Locked.Visible = v26;
                end;

                if Price then
                    if v26 then
                        Price.Visible = false;
                    else
                        Price.Visible = true;

                        if v == "None" then
                            Price.Visible = false;
                        else
                            local v27 = FertilizerConfig.GetCost(v, v22, v20);

                            if v27 <= 0 then
                                Price.Text = "FREE";
                                Price.TextColor3 = u1;
                            else
                                Price.Text = "$" .. AbbreviateNumber(v27);
                                Price.TextColor3 = v27 <= v24 and u1 or u2;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        u18();
        u17 = true;
        UI_Manager:OpenWindow(FertilizerSelect, true);
    end;

    local function getUIOpen() -- Line: 159
        -- upvalues: u17 (ref)
        return u17;
    end;

    local u28 = Maid.new();
    u12:GiveTask(u28);
    local u29 = {};

    for i, v in WormConfig.Order do
        u29[v] = i;
    end;

    local function wormDescription(p30) -- Line: 173
        -- upvalues: WormConfig (ref), MutationConfig (ref), u3 (ref), colorTag (ref), goldTag (ref)
        local v31 = WormConfig.GetMutation(p30.wormType);
        local v32 = {};

        if v31 then
            local v33 = MutationConfig.TopColor({ v31 }) or u3;
            table.insert(v32, string.format("Grants %s mutation", colorTag(v31, v33)));
        end;

        if p30.mult then
            local format = string.format;
            local v34 = string.format("%.2f", p30.mult);

            if v34:find("%.") then
                v34 = v34:gsub("0+$", ""):gsub("%.$", "");
            end;

            table.insert(v32, format("Multiplies crash point by %s", goldTag(v34 .. "x")));
        end;

        return table.concat(v32, ". ");
    end;

    u18 = function() -- Line: 187, Name: refreshWorms
        -- upvalues: u28 (copy), ItemHolder (copy), DataClient (copy), u29 (copy), Worms (copy), WormConfig (ref), u15 (copy), MutationConfig (ref), UI_Manager (copy), u11 (copy), wormDescription (copy), getUIOpen (copy), u17 (ref), getEquippedSeedTool (ref), LocalPlayer (copy), FertilizerSelect (copy), u14 (copy), UIListLayout (copy), StartSpacer (copy), EndSpacer (copy)
        u28:DoCleaning();

        for _, child in ItemHolder:GetChildren() do
            if child:IsA("GuiObject") and (child.Name ~= "StartSpacer" and child.Name ~= "EndSpacer") then
                child:Destroy();
            end;
        end;

        local v35 = table.clone(DataClient.currentData and DataClient.currentData.Worms or {});
        table.sort(v35, function(p36, p37) -- Line: 194
            -- upvalues: u29 (ref)
            local v38 = u29[p36.wormType] or 0;
            local v39 = u29[p37.wormType] or 0;

            if v38 == v39 then
                return p36.id < p37.id;
            end;

            return v39 < v38;
        end);
        Worms.Visible = #v35 > 0;

        for i, v in v35 do
            local v40 = WormConfig.Get(v.wormType);

            if v40 then
                local v41 = u15:Clone();
                v41.Name = v.id;
                v41.LayoutOrder = i;
                local Button = v41:FindFirstChild("Button");
                local v42;

                if Button then
                    v42 = Button:FindFirstChild("Icon");
                else
                    v42 = Button;
                end;

                local v43;

                if Button then
                    v43 = Button:FindFirstChild("WormName");
                else
                    v43 = Button;
                end;

                local v44;

                if Button then
                    v44 = Button:FindFirstChild("LuckyIcon");
                else
                    v44 = Button;
                end;

                if v42 then
                    v42.Image = v40.icon;
                end;

                if v43 then
                    v43.Text = WormConfig.DisplayName(v);
                    local v45 = v.mult ~= nil;
                    local v46 = MutationConfig.TopColor(v40.mutation and { v40.mutation } or nil);

                    if v45 then
                        v43.TextColor3 = Color3.new(1, 1, 1);
                    elseif v46 then
                        v43.TextColor3 = v46;
                    end;

                    local v47 = v43:FindFirstChildOfClass("UIGradient");

                    if v47 then
                        v47.Enabled = v45;
                    end;
                end;

                if v44 then
                    v44.Visible = v.mult ~= nil;
                end;

                v41.Parent = ItemHolder;

                if Button then
                    UI_Manager:AddBounceButton(Button, 1.05, false);
                    u11.HoverDescriptions:SetupHoverCell(Button, tostring(wormDescription(v)), getUIOpen, function() -- Line: 235
                        -- upvalues: u17 (ref), getEquippedSeedTool (ref), LocalPlayer (ref), UI_Manager (ref), FertilizerSelect (ref), u14 (ref), v (copy)
                        if not u17 then
                            return;
                        end;

                        local v48 = getEquippedSeedTool(LocalPlayer);

                        if v48 then
                            if u17 then
                                u17 = false;
                                UI_Manager:CloseWindow(FertilizerSelect, true);
                            end;

                            u14:StartRound(v48:GetAttribute("SeedType"), "None", v.id);

                            return;
                        end;

                        if not u17 then
                            return;
                        end;

                        u17 = false;
                        UI_Manager:CloseWindow(FertilizerSelect, true);
                    end, false);
                    u28:GiveTask(function() -- Line: 242
                        -- upvalues: u11 (ref), Button (copy)
                        u11.HoverDescriptions:RemoveHoverCell(Button);
                    end);
                end;
            end;
        end;

        if #v35 > 6 then
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
            StartSpacer.Visible = true;
            EndSpacer.Visible = true;

            return;
        end;

        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        StartSpacer.Visible = false;
        EndSpacer.Visible = false;
    end;

    local function fertDescription(p49) -- Line: 260
        -- upvalues: goldTag (ref), FertilizerConfig (ref)
        local format = string.format;
        local v50 = FertilizerConfig.GetMult(p49);
        local v51 = string.format("%.2f", v50);

        if v51:find("%.") then
            v51 = v51:gsub("0+$", ""):gsub("%.$", "");
        end;

        return format("Multiplies crash point by %s", goldTag(v51 .. "x"));
    end;

    for _, v in FertilizerConfig.Order do
        local v52 = Fertilizers:FindFirstChild(v);

        if v52 then
            v52 = v52:FindFirstChild("Button");
        end;

        if v52 then
            UI_Manager:AddBounceButton(v52, 1.05, false);
            u11.HoverDescriptions:SetupHoverCell(v52, tostring(fertDescription(v)), getUIOpen, function() -- Line: 271
                -- upvalues: u17 (ref), FertilizerConfig (ref), v (copy), DataClient (copy), getEquippedSeedTool (ref), LocalPlayer (copy), UI_Manager (copy), FertilizerSelect (copy), u14 (copy)
                if not u17 then
                    return;
                end;

                local currentData = DataClient.currentData;

                if not FertilizerConfig.IsUnlocked(v, currentData and currentData.Rebirth or 0) then
                    return;
                end;

                local v53 = getEquippedSeedTool(LocalPlayer);

                if v53 then
                    if u17 then
                        u17 = false;
                        UI_Manager:CloseWindow(FertilizerSelect, true);
                    end;

                    u14:StartRound(v53:GetAttribute("SeedType"), v);

                    return;
                end;

                if not u17 then
                    return;
                end;

                u17 = false;
                UI_Manager:CloseWindow(FertilizerSelect, true);
            end, false);
        end;
    end;

    UI_Manager:AddBounceButton(Exit, 1.05, true);
    u12:GiveTask(Exit.Activated:Connect(closeUI));
    local u54 = Knit.GetController("PlantRoundController");
    local u55 = nil;
    u12:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 291
        -- upvalues: u16 (ref), getEquippedSeedTool (ref), LocalPlayer (copy), u54 (copy), u55 (ref), u17 (ref), UI_Manager (copy), FertilizerSelect (copy)
        if not u16 then
            return;
        end;

        local v56 = getEquippedSeedTool(LocalPlayer) ~= nil and (not u54.localRoundVisible or u54.localGhostGrowing);

        if v56 ~= u55 then
            u55 = v56;
            u16.Enabled = v56;

            if not v56 and u17 then
                if not u17 then
                    return;
                end;

                u17 = false;
                UI_Manager:CloseWindow(FertilizerSelect, true);
            end;
        end;
    end));
    local u57 = false;

    local function resolvePlot(p58) -- Line: 307
        -- upvalues: u57 (ref), u16 (ref), u12 (copy), openUI (copy)
        if u57 then
            return;
        end;

        local v59 = workspace:WaitForChild("BigField"):WaitForChild("PlayerPlots"):WaitForChild("PlayerPlot" .. p58, 15);

        if not v59 then
            return;
        end;

        local SeedPlot = v59:WaitForChild("SeedPlot", 15);

        if SeedPlot then
            SeedPlot = SeedPlot:WaitForChild("PlotTP", 15);
        end;

        if SeedPlot then
            SeedPlot = SeedPlot:WaitForChild("PlantSeedPrompt", 15);
        end;

        if not SeedPlot then
            return;
        end;

        u57 = true;
        u16 = SeedPlot;
        u12:GiveTask(u16.Triggered:Connect(function() -- Line: 319
            -- upvalues: openUI (ref)
            openUI();
        end));
    end;

    u12:GiveTask(u13.PlotAssigned:Connect(resolvePlot));
    task.spawn(function() -- Line: 325
        -- upvalues: u13 (copy), resolvePlot (copy)
        local v60, v61 = u13:GetMyPlot():await();

        if v60 and v61 then
            resolvePlot(v61);
        end;
    end);
    u11._maid = u12;
end;

function v9.KnitInit(p62) -- Line: 335
    -- upvalues: Knit (copy)
    p62.UI_Manager = Knit.GetController("UI_Manager");
    p62.DataClient = Knit.GetController("DataClient");
    p62.HoverDescriptions = Knit.GetController("HoverDescriptions");
end;

return v9;