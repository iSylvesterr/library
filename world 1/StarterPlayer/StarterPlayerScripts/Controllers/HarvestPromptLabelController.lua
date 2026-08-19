-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 11
};
local ProximityPromptService = game:GetService("ProximityPromptService");
local SharedModules = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules");
local SeedData = require(SharedModules:WaitForChild("SeedData"));
local RarityVisuals = require(SharedModules:WaitForChild("RarityVisuals"));
local MutationData = require(SharedModules:WaitForChild("MutationData"));
local WeightFormat = require(SharedModules:WaitForChild("WeightFormat"));
local u2 = nil;
local u3 = UDim2.fromOffset(220, 64);
local u4 = Vector2.new(0, -1);
local u5 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
local u6 = Color3.fromRGB(0, 0, 0);
local u7 = Color3.new(1, 1, 1);
local u8 = Color3.new(1, 1, 1);
local u9 = {};
local u10 = {};
local u11 = {};

local function color3ToHex(p12) -- Line: 101
    return string.format("#%02X%02X%02X", math.floor(p12.R * 255 + 0.5), math.floor(p12.G * 255 + 0.5), (math.floor(p12.B * 255 + 0.5)));
end;

local function getMutationColor(p13) -- Line: 110
    -- upvalues: u10 (copy), MutationData (copy)
    local v14 = u10[p13];

    if v14 then
        return v14;
    end;

    local v15 = Color3.new(1, 1, 1);
    local v16 = MutationData.GetMutation(p13);

    if v16 and v16.Gradient then
        local Keypoints = v16.Gradient.Color.Keypoints;

        if Keypoints[1] then
            v15 = Keypoints[1].Value;
        end;
    end;

    u10[p13] = v15;

    return v15;
end;

local function splitMutations(p17) -- Line: 131
    if type(p17) ~= "string" or p17 == "" then
        return {};
    end;

    local v18 = {};

    for i in string.gmatch(p17, "[^%+%,]+") do
        local v19 = string.gsub(i, "^%s*(.-)%s*$", "%1");

        if v19 ~= "" then
            table.insert(v18, v19);
        end;
    end;

    return v18;
end;

local function buildMutationsRichText(p20) -- Line: 144
    -- upvalues: color3ToHex (copy), u7 (copy), u10 (copy), MutationData (copy)
    local v21 = string.format("<font color=\"%s\"> + </font>", color3ToHex(u7));
    local v22 = {};

    for _, v in p20 do
        local v23 = u10[v];

        if not v23 then
            v23 = Color3.new(1, 1, 1);
            local v24 = MutationData.GetMutation(v);

            if v24 and v24.Gradient then
                local Keypoints = v24.Gradient.Color.Keypoints;

                if Keypoints[1] then
                    v23 = Keypoints[1].Value;
                end;
            end;

            u10[v] = v23;
        end;

        local v25 = string.format("#%02X%02X%02X", math.floor(v23.R * 255 + 0.5), math.floor(v23.G * 255 + 0.5), (math.floor(v23.B * 255 + 0.5)));
        table.insert(v22, string.format("<font color=\"%s\">%s</font>", v25, v));
    end;

    return table.concat(v22, v21);
end;

local function findFruitModel(p26) -- Line: 158
    local Parent = p26.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        return nil, nil;
    end;

    local Parent2 = Parent.Parent;

    while Parent2 do
        if Parent2:IsA("Model") then
            return Parent2, Parent;
        end;

        Parent2 = Parent2.Parent;
    end;

    return nil, nil;
end;

local function clearGradient(p27) -- Line: 173
    local v28 = p27:FindFirstChildOfClass("UIGradient");

    if v28 then
        v28:Destroy();
    end;
end;

local function computeWeightSuffix(p29) -- Line: 182
    -- upvalues: u2 (ref), u8 (copy), WeightFormat (copy)
    if not u2 then
        return "";
    end;

    local v30 = u2:CalculateFruitWeight(p29);

    if not v30 and u2.CalculatePlantWeight then
        v30 = u2:CalculatePlantWeight(p29);
    end;

    if not v30 then
        return "";
    end;

    local v31 = u8;

    return string.format(" <font color=\"%s\">⚖️ %s</font>", string.format("#%02X%02X%02X", math.floor(v31.R * 255 + 0.5), math.floor(v31.G * 255 + 0.5), (math.floor(v31.B * 255 + 0.5))), WeightFormat.FormatGrams(v30));
end;

local function refreshWeight(p32) -- Line: 199
    -- upvalues: computeWeightSuffix (copy)
    if not p32.namePrefix then
        return;
    end;

    p32.nameLabel.Text = p32.namePrefix .. computeWeightSuffix(p32.fruit);
end;

local function refreshContent(p33) -- Line: 204
    -- upvalues: u9 (copy), splitMutations (copy), computeWeightSuffix (copy), MutationData (copy), u8 (copy), RarityVisuals (copy), buildMutationsRichText (copy)
    local fruit = p33.fruit;
    local v34 = fruit:GetAttribute("CorePartName");
    local v35 = fruit:GetAttribute("SeedName");

    if type(v34) ~= "string" or v34 == "" then
        v34 = (type(v35) ~= "string" or v35 == "") and "?" or v35;
    end;

    local v36 = u9[v34];
    local v37 = (not v36 or type(v36.Rarity) ~= "string") and "Common" or v36.Rarity;
    local v38 = p33.nameLabel:FindFirstChildOfClass("UIGradient");

    if v38 then
        v38:Destroy();
    end;

    local v39 = splitMutations(fruit:GetAttribute("Mutation"));
    local v40 = computeWeightSuffix(fruit);

    if #v39 == 1 then
        local v41 = MutationData.GetMutation(v39[1]);

        if v41 and v41.Gradient then
            p33.nameLabel.TextColor3 = u8;
            v41.Gradient:Clone().Parent = p33.nameLabel;
        else
            p33.nameLabel.TextColor3 = u8;
            local format = string.format;
            local v42 = RarityVisuals.GetStaticColor(v37);
            v34 = format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math.floor(v42.R * 255 + 0.5), math.floor(v42.G * 255 + 0.5), (math.floor(v42.B * 255 + 0.5))), v34);
        end;
    else
        p33.nameLabel.TextColor3 = u8;
        local format = string.format;
        local v43 = RarityVisuals.GetStaticColor(v37);
        v34 = format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math.floor(v43.R * 255 + 0.5), math.floor(v43.G * 255 + 0.5), (math.floor(v43.B * 255 + 0.5))), v34);
    end;

    p33.namePrefix = v34;
    p33.nameLabel.Text = v34 .. v40;

    if #v39 == 0 then
        p33.mutationsLabel.Text = "";
        p33.mutationsLabel.Visible = false;

        return;
    end;

    p33.mutationsLabel.Text = buildMutationsRichText(v39);
    p33.mutationsLabel.Visible = true;
end;

local function buildBillboard(p44) -- Line: 287
    -- upvalues: u4 (copy), u3 (copy), u5 (copy), u6 (copy)
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "HarvestPromptLabel";
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.ClipsDescendants = false;
    BillboardGui.MaxDistance = 80;
    BillboardGui.SizeOffset = u4;
    BillboardGui.Adornee = p44;
    BillboardGui.Size = u3;
    BillboardGui.Parent = p44;
    local Frame = Instance.new("Frame");
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Parent = BillboardGui;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.RichText = true;
    TextLabel.Name = "Name";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.FontFace = u5;
    TextLabel.LayoutOrder = 1;
    TextLabel.Size = UDim2.new(1, 0, 0.55, 0);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextSize = 24;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    UIStroke.Color = u6;
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
    UIStroke.Thickness = 2;
    UIStroke.Parent = TextLabel;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Mutations";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.BorderSizePixel = 0;
    TextLabel2.FontFace = u5;
    TextLabel2.LayoutOrder = 2;
    TextLabel2.Size = UDim2.new(1, 0, 0.4, 0);
    TextLabel2.RichText = true;
    TextLabel2.Text = "";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextSize = 20;
    TextLabel2.TextWrapped = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Center;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel2.Visible = false;
    TextLabel2.Parent = Frame;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    UIStroke2.Color = u6;
    UIStroke2.LineJoinMode = Enum.LineJoinMode.Round;
    UIStroke2.Thickness = 2;
    UIStroke2.Parent = TextLabel2;

    return BillboardGui, TextLabel, TextLabel2;
end;

local function teardownEntry(p45) -- Line: 369
    -- upvalues: u11 (copy)
    local v46 = u11[p45];

    if not v46 then
        return;
    end;

    u11[p45] = nil;

    if v46.mutationConn then
        v46.mutationConn:Disconnect();
    end;

    if v46.promptAncestryConn then
        v46.promptAncestryConn:Disconnect();
    end;

    if v46.fruitAncestryConn then
        v46.fruitAncestryConn:Disconnect();
    end;

    if v46.billboard then
        v46.billboard:Destroy();
    end;
end;

local function handlePromptShown(u47) -- Line: 380
    -- upvalues: u11 (copy), findFruitModel (copy), buildBillboard (copy), refreshContent (copy), teardownEntry (copy), u2 (ref), computeWeightSuffix (copy)
    if u11[u47] then
        return;
    end;

    local v48, v49 = findFruitModel(u47);

    if not (v48 and v49) then
        return;
    end;

    local v50, v51, v52 = buildBillboard(v49);
    local u53 = {
        billboard = v50,
        nameLabel = v51,
        mutationsLabel = v52,
        adornee = v49,
        fruit = v48
    };
    u11[u47] = u53;
    refreshContent(u53);
    u53.mutationConn = v48:GetAttributeChangedSignal("Mutation"):Connect(function() -- Line: 401
        -- upvalues: u11 (ref), u47 (copy), u53 (copy), refreshContent (ref)
        if u11[u47] ~= u53 then
            return;
        end;

        refreshContent(u53);
    end);
    u53.promptAncestryConn = u47.AncestryChanged:Connect(function(p54, p55) -- Line: 409
        -- upvalues: teardownEntry (ref), u47 (copy)
        if not p55 then
            teardownEntry(u47);
        end;
    end);
    u53.fruitAncestryConn = v48.AncestryChanged:Connect(function(p56, p57) -- Line: 412
        -- upvalues: teardownEntry (ref), u47 (copy)
        if not p57 then
            teardownEntry(u47);
        end;
    end);

    if u2 and u2:IsGrowsForeverFruit(v48) then
        task.spawn(function() -- Line: 421
            -- upvalues: u11 (ref), u47 (copy), u53 (copy), computeWeightSuffix (ref)
            while u11[u47] == u53 do
                task.wait(0.5);

                if u11[u47] ~= u53 then
                    break;
                end;

                local v58 = u53;

                if v58.namePrefix then
                    v58.nameLabel.Text = v58.namePrefix .. computeWeightSuffix(v58.fruit);
                end;
            end;
        end);
    end;
end;

local function handlePromptHidden(p59) -- Line: 431
    -- upvalues: teardownEntry (copy)
    teardownEntry(p59);
end;

function v1.Init(p60) -- Line: 437
    -- upvalues: SeedData (copy), u9 (copy)
    for _, v in SeedData do
        if type(v) == "table" and type(v.SeedName) == "string" then
            u9[v.SeedName] = v;
        end;
    end;
end;

function v1.Start(p61) -- Line: 445
    -- upvalues: u2 (ref), ProximityPromptService (copy), handlePromptShown (copy), teardownEntry (copy)
    u2 = require(script.Parent.FruitVisualizerController);
    ProximityPromptService.PromptShown:Connect(function(p62) -- Line: 450
        -- upvalues: handlePromptShown (ref)
        if not p62:HasTag("HarvestPrompt") then
            return;
        end;

        handlePromptShown(p62);
    end);
    ProximityPromptService.PromptHidden:Connect(function(p63) -- Line: 455
        -- upvalues: teardownEntry (ref)
        if not p63:HasTag("HarvestPrompt") then
            return;
        end;

        teardownEntry(p63);
    end);
end;

return v1;