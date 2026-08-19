-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local Constants = require(ReplicatedStorage.Shared.Info.Constants);
local ExpandedRarities = require(ReplicatedStorage.Shared.Info.ExpandedRarities);
local FormatMultiplier = require(ReplicatedStorage.Shared.Utility.FormatMultiplier);
local AbbreviateNumber = require(ReplicatedStorage.Shared.Utility.AbbreviateNumber);
local MutationText = require(ReplicatedStorage.Shared.Utility.MutationText);
local MutationRecolor = require(ReplicatedStorage.Shared.Utility.MutationRecolor);

return {
    build = function(p1) -- Line: 17, Name: build
        -- upvalues: ReplicatedStorage (copy), SeedConfig (copy), MutationRecolor (copy), FormatMultiplier (copy), AbbreviateNumber (copy), MutationText (copy), ExpandedRarities (copy), Constants (copy)
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            Assets = Assets:FindFirstChild("Greedy");
        end;

        if not Assets then
            return nil;
        end;

        local FruitModels = Assets:FindFirstChild("FruitModels");
        local UI = Assets:FindFirstChild("UI");

        if UI then
            UI = UI:FindFirstChild("ItemBillboard");
        end;

        local v2 = SeedConfig.FRUIT_MODEL_NAMES and SeedConfig.FRUIT_MODEL_NAMES[p1.seedType];

        if FruitModels then
            if v2 then
                v2 = FruitModels:FindFirstChild(v2);
            end;
        else
            v2 = FruitModels;
        end;

        if not v2 then
            v2 = Assets:FindFirstChild("Fruits");

            if v2 then
                v2 = v2:FindFirstChild("Fruit");
            end;
        end;

        if not v2 then
            return nil;
        end;

        local v3 = p1.multiplier or 1;
        local Model = Instance.new("Model");
        Model.Name = "FruitDisplay";
        local v4 = v2:Clone();
        MutationRecolor.applyGoldenFruit(v4, p1.mutations);
        local v5 = SeedConfig.CalcFruitScale(p1.seedType, v3);

        if v4:IsA("Model") then
            v4:ScaleTo(v5);
        elseif v4:IsA("BasePart") then
            v4.Size = v4.Size * v5;
        end;

        local v6 = nil;

        for _, v in v4:IsA("BasePart") and { v4 } or v4:GetDescendants() do
            if v:IsA("BasePart") then
                v.Anchored = true;
                v.CanCollide = false;
                v.CanQuery = false;
                v6 = v6 or v;
            end;
        end;

        v4.Parent = Model;
        local v7 = v4:IsA("Model") and v4.PrimaryPart;

        if not v7 or (v7.Name ~= "Base" or not v7) then
            v7 = v6;
        end;

        Model.PrimaryPart = v7;
        local MutationAssets = Assets:FindFirstChild("MutationAssets");

        if MutationAssets then
            MutationAssets = MutationAssets:FindFirstChild("Fruits");
        end;

        if MutationAssets and (v6 and p1.mutations) then
            local v8 = Model.PrimaryPart.Name == "Base" and Model.PrimaryPart.CFrame or select(1, Model:GetBoundingBox());

            for _, v in p1.mutations do
                local v9 = MutationAssets:FindFirstChild(v);

                if v9 then
                    local v10 = v9:Clone();

                    for _, descendant in v10:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            descendant.Anchored = true;
                            descendant.CanCollide = false;
                            descendant.CanQuery = false;
                            descendant.CanTouch = false;
                            descendant.Transparency = 1;
                        end;
                    end;

                    if v10:IsA("BasePart") then
                        v10.Anchored = true;
                        v10.CanCollide = false;
                        v10.Transparency = 1;
                        v10.CFrame = v8;
                    elseif v10:IsA("Model") then
                        local v11 = select(1, v10:GetBoundingBox());
                        v10:PivotTo(v10:GetPivot() + (v8.Position - v11.Position));
                    end;

                    for _, descendant in v10:GetDescendants() do
                        if descendant:IsA("ParticleEmitter") then
                            descendant.Enabled = true;
                        end;
                    end;

                    v10.Parent = Model;
                end;
            end;
        end;

        if UI and v6 then
            local v12 = UI:Clone();
            v12.Adornee = v6;
            v12.Parent = v6;
            local Frame = v12:FindFirstChild("Frame");

            if Frame then
                local v13 = SeedConfig.GetSeed(p1.seedType);
                local v14 = p1.fruitName or (v13 and (v13.fruitName or "Fruit") or "Fruit");
                local Name = Frame:FindFirstChild("Name");

                if Name then
                    Name.Text = string.format("%s (%sx)", v14, FormatMultiplier(v3));
                end;

                local Cost = Frame:FindFirstChild("Cost");

                if Cost then
                    Cost.Text = "$" .. AbbreviateNumber(p1.sellValue or 0);
                    Cost.Visible = true;
                end;

                local Mutation = Frame:FindFirstChild("Mutation");

                if Mutation then
                    MutationText.apply(Mutation, p1.mutations);
                end;

                local Rarity = Frame:FindFirstChild("Rarity");

                if Rarity then
                    local v15 = v13 and v13.rarity or "COMMON";
                    local v16 = ExpandedRarities[v15];
                    local v17;

                    if v16 then
                        v17 = v16.name or v15;
                    else
                        v17 = v15;
                    end;

                    Rarity.Text = v17;
                    local v18 = Constants.RARITY_COLORS[v15];

                    if v18 then
                        Rarity.TextColor3 = v18;
                    end;
                end;
            end;
        end;

        return Model;
    end
};