-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local MutationRenderer = require(Modules:WaitForChild("MutationRenderer"));
local ItemNameParser = require(Modules:WaitForChild("ItemNameParser"));
local ItemRarity = require(Modules:WaitForChild("ItemRarity"));
local u1 = {};
local u2 = {};

local function getAnimatedMutations(p3) -- Line: 38
    -- upvalues: MutationRenderer (copy), ItemNameParser (copy)
    local u4 = {};
    local u5 = {};

    local function add(p6) -- Line: 42
        -- upvalues: u5 (copy), MutationRenderer (ref), u4 (copy)
        if p6 and (p6 ~= "" and (not u5[p6] and MutationRenderer.isAnimated(p6))) then
            u5[p6] = true;
            table.insert(u4, p6);
        end;
    end;

    local v7 = p3:GetAttribute("AnimatedMutations");

    if type(v7) == "string" then
        for i in string.gmatch(v7, "([^,]+)") do
            local v8 = i:match("^%s*(.-)%s*$");

            if v8 and (v8 ~= "" and (not u5[v8] and MutationRenderer.isAnimated(v8))) then
                u5[v8] = true;
                table.insert(u4, v8);
            end;
        end;
    end;

    local v9, v10, _, v11 = ItemNameParser(p3.Name);

    if v9 and (v9 and (v9 ~= "" and (not u5[v9] and MutationRenderer.isAnimated(v9)))) then
        u5[v9] = true;
        table.insert(u4, v9);
    end;

    if v10 then
        for i in string.gmatch(v10, "([^,]+)") do
            local v12 = i:match("^%s*(.-)%s*$");

            if v12 and (v12 ~= "" and (not u5[v12] and MutationRenderer.isAnimated(v12))) then
                u5[v12] = true;
                table.insert(u4, v12);
            end;
        end;
    end;

    if v11 and (string.find(v11, "Disco Capybara") and (not u5.Disco and MutationRenderer.isAnimated("Disco"))) then
        u5.Disco = true;
        table.insert(u4, "Disco");
    end;

    return u4;
end;

local u13 = {
    Godly = true,
    Secret = true
};
local u14 = {};

local function findRarityLabel(p15) -- Line: 87
    local v16 = p15:FindFirstChildWhichIsA("BillboardGui", true);

    if v16 then
        v16 = v16:FindFirstChild("Frame");
    end;

    if v16 then
        v16 = v16:FindFirstChild("Rarity");
    end;

    if not (v16 and (v16:IsA("TextLabel") and v16)) then
        v16 = nil;
    end;

    return v16;
end;

local function startToolRarity(u17) -- Line: 94
    -- upvalues: u14 (copy), startToolRarity (copy), u13 (copy), ItemRarity (copy)
    if u14[u17] then
        return;
    end;

    local v18 = u17:FindFirstChildWhichIsA("BillboardGui", true);
    local u19 = v18 and v18:FindFirstChild("Frame");

    if u19 then
        u19 = u19:FindFirstChild("Rarity");
    end;

    if not (u19 and (u19:IsA("TextLabel") and u19)) then
        u19 = nil;
    end;

    if not u19 then
        if not u14[u17] then
            local u20 = nil;
            u20 = u17.DescendantAdded:Connect(function(p21) -- Line: 103
                -- upvalues: u17 (copy), u20 (ref), startToolRarity (ref)
                if p21:IsA("BillboardGui") or p21.Name == "Rarity" then
                    local v22 = u17:FindFirstChildWhichIsA("BillboardGui", true);

                    if v22 then
                        v22 = v22:FindFirstChild("Frame");
                    end;

                    if v22 then
                        v22 = v22:FindFirstChild("Rarity");
                    end;

                    if not (v22 and (v22:IsA("TextLabel") and v22)) then
                        v22 = nil;
                    end;

                    if v22 then
                        u20:Disconnect();
                        startToolRarity(u17);
                    end;
                end;
            end);
            u17.Destroying:Connect(function() -- Line: 111
                -- upvalues: u20 (ref)
                u20:Disconnect();
            end);
        end;

        return;
    end;

    local Text = u19.Text;

    if not u13[Text] then
        return;
    end;

    u14[u17] = true;
    ItemRarity.applyGradient(u19, Text, {
        Tool = true
    });
    u17.Destroying:Connect(function() -- Line: 126
        -- upvalues: u14 (ref), u17 (copy), ItemRarity (ref), u19 (copy)
        u14[u17] = nil;
        ItemRarity.stopRainbow(u19);
    end);
end;

local function stopTool(p23) -- Line: 132
    -- upvalues: u1 (copy)
    local v24 = u1[p23];

    if v24 then
        v24();
        u1[p23] = nil;
    end;
end;

local function forgetTool(p25) -- Line: 142
    -- upvalues: u1 (copy), u2 (copy), u14 (copy)
    local v26 = u1[p25];

    if v26 then
        v26();
        u1[p25] = nil;
    end;

    u2[p25] = nil;
    u14[p25] = nil;
end;

local function startTool(u27) -- Line: 148
    -- upvalues: u1 (copy), getAnimatedMutations (copy), u2 (copy), startTool (copy), MutationRenderer (copy), u14 (copy)
    if not u27:IsA("Tool") then
        return;
    end;

    if u1[u27] then
        return;
    end;

    local v28 = getAnimatedMutations(u27);

    if #v28 == 0 then
        if not u2[u27] then
            u2[u27] = true;
            u27:GetAttributeChangedSignal("AnimatedMutations"):Connect(function() -- Line: 159
                -- upvalues: u27 (copy), u1 (ref), startTool (ref)
                if u27.Parent and not u1[u27] then
                    startTool(u27);
                end;
            end);
        end;

        return;
    end;

    local v29 = u27:FindFirstChild("Model") or u27;

    if v29:IsA("Model") and not v29.PrimaryPart then
        v29:GetPropertyChangedSignal("PrimaryPart"):Wait();

        if not u27.Parent then
            return;
        end;
    end;

    local u30 = {};

    for _, v in ipairs(v28) do
        table.insert(u30, MutationRenderer.animateModel(v29, v));
    end;

    u1[u27] = function() -- Line: 184
        -- upvalues: u30 (copy)
        for _, v in ipairs(u30) do
            pcall(v);
        end;
    end;

    u27.Destroying:Connect(function() -- Line: 190
        -- upvalues: u27 (copy), u1 (ref), u2 (ref), u14 (ref)
        local v31 = u27;
        local v32 = u1[v31];

        if v32 then
            v32();
            u1[v31] = nil;
        end;

        u2[v31] = nil;
        u14[v31] = nil;
    end);
end;

local function watchContainer(p33) -- Line: 196
    -- upvalues: startTool (copy), startToolRarity (copy), u1 (copy)
    for _, child in ipairs(p33:GetChildren()) do
        if child:IsA("Tool") then
            task.spawn(startTool, child);
            task.spawn(startToolRarity, child);
        end;
    end;

    p33.ChildAdded:Connect(function(p34) -- Line: 203
        -- upvalues: startTool (ref), startToolRarity (ref)
        if p34:IsA("Tool") then
            task.spawn(startTool, p34);
            task.spawn(startToolRarity, p34);
        end;
    end);
    p33.ChildRemoved:Connect(function(p35) -- Line: 209
        -- upvalues: u1 (ref)
        local v36 = p35:IsA("Tool") and u1[p35];

        if v36 then
            v36();
            u1[p35] = nil;
        end;
    end);
end;

local function watchPlayer(p37) -- Line: 217
    -- upvalues: watchContainer (copy)
    local function onCharacter(p38) -- Line: 218
        -- upvalues: watchContainer (ref)
        watchContainer(p38);
    end;

    if p37.Character then
        watchContainer(p37.Character);
    end;

    p37.CharacterAdded:Connect(onCharacter);
    local v39 = p37:FindFirstChildOfClass("Backpack");

    if v39 then
        watchContainer(v39);
    end;

    p37.ChildAdded:Connect(function(p40) -- Line: 230
        -- upvalues: watchContainer (ref)
        if p40:IsA("Backpack") then
            watchContainer(p40);
        end;
    end);
end;

for _, v in ipairs(Players:GetPlayers()) do
    watchPlayer(v);
end;

Players.PlayerAdded:Connect(watchPlayer);