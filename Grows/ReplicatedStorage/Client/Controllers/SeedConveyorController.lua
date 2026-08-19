-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local ExpandedRarities = require(ReplicatedStorage.Shared.Info.ExpandedRarities);
local Constants = require(ReplicatedStorage.Shared.Info.Constants);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local AbbreviateNumber = require(ReplicatedStorage.Shared.Utility.AbbreviateNumber);
local SeedMutationVisual = require(ReplicatedStorage.Shared.Utility.SeedMutationVisual);
local v1 = Knit.CreateController({
    Name = "SeedConveyorController"
});
local u2 = {
    COMMON = Color3.fromHex("1EFF00"),
    RARE = Color3.fromHex("0070DD"),
    EPIC = Color3.fromHex("A335EE"),
    LEGENDARY = Color3.fromHex("FF0000"),
    MYTHIC = Color3.fromHex("FFD700"),
    CELESTIAL = Color3.fromRGB(12, 45, 138),
    SECRET = Color3.fromRGB(180, 40, 230),
    DIVINE = Color3.fromRGB(255, 240, 180)
};
local u3 = nil;
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = {};
local u10 = nil;

local function canLikelyBuy(p11) -- Line: 52
    -- upvalues: u10 (ref), CustomEnum (copy), Constants (copy)
    local v12 = u10 and u10.currentData;

    if not v12 then
        return true;
    end;

    if p11.plantCost > 0 and (v12.Currency and (v12.Currency[CustomEnum.CURRENCIES.COINS] or 0) or 0) < p11.plantCost then
        return false;
    end;

    for _, v in v12.Inventory and (v12.Inventory.Hotbar or {}) or {} do
        if v and v.empty == true then
            return true;
        end;
    end;

    return #(v12.Inventory and v12.Inventory.Storage or {}) < Constants.STORAGE_MAX_SIZE;
end;

local function setSeedVisible(p13, u14) -- Line: 67
    local function apply(p15) -- Line: 68
        -- upvalues: u14 (copy)
        if u14 then
            p15.Transparency = p15:GetAttribute("__origTransparency") or 0;

            return;
        end;

        p15:SetAttribute("__origTransparency", p15.Transparency);
        p15.Transparency = 1;
    end;

    if p13:IsA("BasePart") then
        if u14 then
            p13.Transparency = p13:GetAttribute("__origTransparency") or 0;
        else
            p13:SetAttribute("__origTransparency", p13.Transparency);
            p13.Transparency = 1;
        end;
    end;

    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("BasePart") then
            if u14 then
                descendant.Transparency = descendant:GetAttribute("__origTransparency") or 0;
            else
                descendant:SetAttribute("__origTransparency", descendant.Transparency);
                descendant.Transparency = 1;
            end;
        end;
    end;
end;

local function alignAndWeldToHolder(p16, p17) -- Line: 82
    local v18 = p17.CFrame * CFrame.new(0, -p17.Size.Y / 2, 0);

    if not p16:IsA("BasePart") then
        if p16:IsA("Model") then
            local _, v19 = p16:GetBoundingBox();
            p16:PivotTo(v18 * CFrame.new(0, v19.Y / 2, 0));

            for _, descendant in p16:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = false;
                    descendant.CanCollide = false;
                    local WeldConstraint = Instance.new("WeldConstraint");
                    WeldConstraint.Part0 = p17;
                    WeldConstraint.Part1 = descendant;
                    WeldConstraint.Parent = descendant;
                end;
            end;
        end;

        return;
    end;

    p16.CFrame = v18 * CFrame.new(0, p16.Size.Y / 2, 0);
    p16.Anchored = false;
    p16.CanCollide = false;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p17;
    WeldConstraint.Part1 = p16;
    WeldConstraint.Parent = p16;
end;

local function destroyHolder(p20) -- Line: 109
    -- upvalues: u9 (copy)
    local v21 = u9[p20];

    if not v21 then
        return;
    end;

    u9[p20] = nil;

    if v21.holderClone and v21.holderClone.Parent then
        v21.holderClone:Destroy();
    end;
end;

function v1._buildHolder(u22, u23) -- Line: 119
    -- upvalues: SeedConfig (copy), u3 (ref), u6 (ref), u5 (ref), u4 (copy), alignAndWeldToHolder (copy), setSeedVisible (copy), SeedMutationVisual (copy), u9 (copy), canLikelyBuy (copy), ExpandedRarities (copy), u2 (copy), CollectionService (copy), AbbreviateNumber (copy)
    local u24 = SeedConfig.GetSeed(u23.seedKey);

    if not u24 then
        return;
    end;

    local v25 = u3:Clone();
    local v26 = nil;

    if v25:IsA("BasePart") then
        v26 = v25;
    elseif v25:IsA("Model") then
        v26 = v25.PrimaryPart or v25:FindFirstChildWhichIsA("BasePart");
    end;

    if not v26 then
        v25:Destroy();

        return;
    end;

    v26.Transparency = 1;
    v26.Anchored = true;
    v26.CanCollide = false;
    v26.CFrame = CFrame.new(u6);
    v25:SetAttribute("SeedType", u23.seedKey);
    v25:SetAttribute("Rarity", u23.rarity);
    v25:SetAttribute("Mutation", u23.mutation);
    v25:SetAttribute("SpawnId", u23.spawnId);
    v25.Parent = u5;
    local v27 = u4[SeedConfig.SEED_MODEL_NAMES[u23.seedKey] or u23.seedKey .. "Seed"];
    local v28, v29;

    if v27 then
        v28 = v27:Clone();
        v28.Parent = v25;
        alignAndWeldToHolder(v28, v26);
        setSeedVisible(v28, false);
        v29 = SeedMutationVisual.attachFX(v28, v26, u23.mutation, false);
    else
        v28 = nil;
        v29 = nil;
    end;

    local ProximityPrompt = v25:FindFirstChild("ProximityPrompt", true);

    if ProximityPrompt then
        ProximityPrompt.ActionText = "Buy";
        ProximityPrompt.ObjectText = SeedConfig.SeedDisplayName(u23.seedKey);
        ProximityPrompt.MaxActivationDistance = 25;
        ProximityPrompt.RequiresLineOfSight = false;
        ProximityPrompt.HoldDuration = 0;
        ProximityPrompt.Enabled = false;
        ProximityPrompt.Triggered:Connect(function() -- Line: 168
            -- upvalues: u9 (ref), u23 (copy), ProximityPrompt (copy), canLikelyBuy (ref), u24 (copy), u22 (copy)
            local v30 = u9[u23.spawnId];

            if not v30 or v30.purchasing then
                return;
            end;

            v30.purchasing = true;
            ProximityPrompt.Enabled = false;

            if canLikelyBuy(u24) then
                u22.SoundController:PlaySound("SeedPickup");
            end;

            local v31, v32 = u22.SeedConveyorService:RequestPurchase(u23.spawnId):await();

            if v31 and v32 then
                local spawnId = u23.spawnId;
                local v33 = u9[spawnId];

                if not v33 then
                    return;
                end;

                u9[spawnId] = nil;

                if v33.holderClone and v33.holderClone.Parent then
                    v33.holderClone:Destroy();
                end;
            else
                v30.purchasing = false;

                if v30.shown and u9[u23.spawnId] then
                    ProximityPrompt.Enabled = true;
                end;
            end;
        end);
    end;

    local BillboardGui = v25:FindFirstChild("BillboardGui");

    if BillboardGui then
        BillboardGui.Enabled = false;
        local Frame = BillboardGui:FindFirstChild("Frame");

        if Frame then
            local v34 = ExpandedRarities[u23.rarity];
            local v35 = v34 and v34.name or u23.rarity;
            local Name = Frame:FindFirstChild("Name");

            if Name and Name:IsA("TextLabel") then
                Name.Text = SeedConfig.SeedDisplayName(u23.seedKey);
            end;

            local Rarity = Frame:FindFirstChild("Rarity");

            if Rarity and Rarity:IsA("TextLabel") then
                Rarity.Text = v35;
                local v36 = u2[u23.rarity];

                if v36 then
                    Rarity.TextColor3 = v36;
                end;

                Rarity:SetAttribute("rarity", u23.rarity);
                CollectionService:AddTag(Rarity, "ShinyTextLabel");
            end;

            local Cost = Frame:FindFirstChild("Cost");

            if Cost and Cost:IsA("TextLabel") then
                Cost.Text = u24.plantCost == 0 and "FREE" or "$" .. AbbreviateNumber(u24.plantCost);
                Cost.Visible = true;
            end;
        end;

        SeedMutationVisual.applyBillboard(BillboardGui, u23.mutation);
    end;

    u9[u23.spawnId] = {
        shown = false,
        purchasing = false,
        holderClone = v25,
        holderPart = v26,
        modelClone = v28,
        mutationFX = v29,
        prompt = ProximityPrompt,
        billboard = BillboardGui,
        startTime = u23.startTime,
        travelDuration = u23.travelDuration
    };
end;

function v1._step(p37) -- Line: 240
    -- upvalues: u9 (copy), u6 (ref), u7 (ref), u8 (ref), setSeedVisible (copy), SeedMutationVisual (copy)
    local v38 = workspace:GetServerTimeNow();

    for i, v in u9 do
        local v39 = v38 - v.startTime;

        if v.travelDuration <= v39 then
            local v40 = u9[i];

            if v40 then
                u9[i] = nil;

                if v40.holderClone and v40.holderClone.Parent then
                    v40.holderClone:Destroy();
                end;
            end;
        else
            local v41;

            if v39 <= 0 then
                v41 = u6;
            elseif v39 < 0.6 then
                v41 = u6:Lerp(u7, v39 / 0.6);
            else
                v41 = u7:Lerp(u8, (math.clamp((v39 - 0.6) / (v.travelDuration - 0.6), 0, 1)));
            end;

            v.holderPart.CFrame = CFrame.new(v41);

            if not v.shown and v39 >= 0.36 then
                v.shown = true;

                if v.modelClone then
                    setSeedVisible(v.modelClone, true);
                end;

                SeedMutationVisual.setFXEnabled(v.mutationFX, true);

                if v.billboard then
                    v.billboard.Enabled = true;
                end;

                if v.prompt and not v.purchasing then
                    v.prompt.Enabled = true;
                end;
            end;
        end;
    end;
end;

function v1.KnitStart(u42) -- Line: 273
    -- upvalues: Knit (copy), u10 (ref), u5 (ref), ReplicatedStorage (copy), u3 (ref), u4 (copy), u8 (ref), u6 (ref), u7 (ref), u9 (copy), RunService (copy)
    u42.SeedConveyorService = Knit.GetService("SeedConveyorService");
    u42.SoundController = Knit.GetController("SoundController");
    u10 = Knit.GetController("DataClient");
    u5 = workspace:WaitForChild("BigField"):WaitForChild("ConveyorSeeds");
    local SeedSpawner = u5:WaitForChild("SeedSpawner");
    local SeedDestroyer = u5:WaitForChild("SeedDestroyer");
    local Greedy = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy");
    u3 = Greedy:WaitForChild("SeedHolder");

    for _, child in Greedy:WaitForChild("Seeds"):GetChildren() do
        u4[child.Name] = child;
    end;

    local Position = SeedSpawner.Position;
    u8 = Vector3.new(SeedDestroyer.Position.X, Position.Y, SeedDestroyer.Position.Z);
    local v43 = u8 - Position;
    u6 = Position - Vector3.new(0, 3, 0);
    u7 = Position + (v43.Magnitude > 0 and v43.Unit or Vector3.new(0, 0, 0)) * 3;
    u42.SeedConveyorService.SeedSpawned:Connect(function(p44) -- Line: 298
        -- upvalues: u42 (copy)
        u42:_buildHolder(p44);
    end);
    u42.SeedConveyorService.SeedPurchased:Connect(function(p45) -- Line: 303
        -- upvalues: u9 (ref)
        local v46 = u9[p45];

        if not v46 then
            return;
        end;

        u9[p45] = nil;

        if v46.holderClone and v46.holderClone.Parent then
            v46.holderClone:Destroy();
        end;
    end);
    RunService.Heartbeat:Connect(function() -- Line: 307
        -- upvalues: u42 (copy)
        u42:_step();
    end);
end;

function v1.KnitInit(p47) -- Line: 312
end;

return v1;