-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
ReplicatedStorage:WaitForChild("Remotes");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local MutationData = require(Modules.MutationData);
local PlantData = require(Modules.PlantData);
local TowerData = require(Modules.TowerData);
local _ = Players.LocalPlayer;
local Simple = require(Modules.FormatNumber.Simple);
local Map = workspace:WaitForChild("World"):WaitForChild("Map", (1 / 0));
local PottedPlants = Map:WaitForChild("PottedPlants");
local PlacedItems = Map:WaitForChild("PlacedItems");
local Plots = Map:WaitForChild("Plots");

local function ownerHasTotemOfMight(p1) -- Line: 48
    -- upvalues: PlacedItems (copy)
    for _, child in PlacedItems.Server:GetChildren() do
        if child:GetAttribute("Owner") == p1 and child.Name:split(":")[1] == "Totem Of Might" then
            return true;
        end;
    end;

    return false;
end;

local function getBestRegularBaseDps(p2) -- Line: 62
    -- upvalues: PlacedItems (copy), TowerData (copy)
    local v3 = 0;

    for _, child in PlacedItems.Server:GetChildren() do
        if child:GetAttribute("Owner") == p2 then
            local ServerConfiguration = child:FindFirstChild("ServerConfiguration");

            if ServerConfiguration and (ServerConfiguration:FindFirstChild("Type") and ServerConfiguration.Type.Value == "Tower") then
                local v4 = TowerData.getData(child.Name:split(":")[1]);

                if v4 and not v4:FindFirstChild("PercentDamage") then
                    local Value = v4.AttackSpeed.Value;

                    if Value > 0 then
                        local v5 = v4.Damage.Value / Value;

                        if v3 < v5 then
                            v3 = v5;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v3;
end;

local function getEffectiveBaseDamage(p6, p7) -- Line: 81
    -- upvalues: getBestRegularBaseDps (copy)
    local PercentDamage = p7:FindFirstChild("PercentDamage");

    if not PercentDamage then
        return p7.Damage.Value;
    end;

    local v8 = getBestRegularBaseDps(p6);

    if v8 <= 0 then
        return p7.Damage.Value;
    end;

    return v8 * PercentDamage.Value * p7.AttackSpeed.Value;
end;

local function getTowerLane(p9, p10) -- Line: 24
    local TowerArea = p9:FindFirstChild("TowerArea");

    if not TowerArea then
        return nil;
    end;

    local v11 = RaycastParams.new();
    v11.FilterType = Enum.RaycastFilterType.Include;
    v11.FilterDescendantsInstances = { TowerArea };
    local v12 = workspace:Raycast(p10.Position + Vector3.new(0, 5, 0), Vector3.new(0, -100000000, 0), v11);
    local v13 = v12 and (v12.Instance and v12.Instance:FindFirstAncestorWhichIsA("Model"));

    if v13 then
        return tonumber(v13.Name:match("%d+"));
    end;

    return nil;
end;

repeat
    task.wait();
until workspace:GetAttribute("Loaded") == true;

while task.wait(1.5) do
    for _, child in Plots:GetChildren() do
        if child:GetAttribute("Taken") ~= false then
            local CollectionMachine = child:FindFirstChild("CollectionMachine");

            if CollectionMachine then
                local MoneyPerSecondSign = child:FindFirstChild("MoneyPerSecondSign");

                if MoneyPerSecondSign then
                    local v14 = 0;
                    local v15 = 0;

                    for _, child2 in PottedPlants.Server:GetChildren() do
                        if child2:GetAttribute("Owner") == child:GetAttribute("Owner") then
                            local ServerConfiguration = child2:FindFirstChild("ServerConfiguration");

                            if ServerConfiguration then
                                local v16 = PlantData.getData(child2.Name:split(":")[1]);

                                if v16 then
                                    local Mutations = ServerConfiguration:FindFirstChild("Mutations");

                                    if Mutations then
                                        local SizeScaling = ServerConfiguration:FindFirstChild("SizeScaling");

                                        if SizeScaling then
                                            local Variant = ServerConfiguration:FindFirstChild("Variant");

                                            if Variant then
                                                local v17 = MutationData.calculateMoneyPerSecond(v16.MoneyPerSecond.Value, Variant.Value, Mutations.Value, SizeScaling.Value);
                                                local AccumulatedMoney = ServerConfiguration:FindFirstChild("AccumulatedMoney");

                                                if AccumulatedMoney then
                                                    v14 = v14 + AccumulatedMoney.Value;
                                                    v15 = v15 + v17;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;

                    CollectionMachine:WaitForChild("Screen"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel").Text = "$" .. Simple.Format((math.round(v14)));
                    MoneyPerSecondSign:WaitForChild("ScreenPart"):WaitForChild("SurfaceGui"):WaitForChild("MoneyPerSecond").Text = "$" .. Simple.Format((math.round(v15 or 0))) .. "/s";

                    if child:GetAttribute("MoneyGain") then
                        MoneyPerSecondSign:WaitForChild("ScreenPart"):WaitForChild("SurfaceGui"):WaitForChild("Multiplier").Text = "x" .. child:GetAttribute("MoneyGain") .. " Multiplier";
                    end;

                    local Lawnmowers = child:FindFirstChild("Lawnmowers");

                    if Lawnmowers then
                        local v18 = child:GetAttribute("Owner");
                        local v19 = {};

                        for _, child2 in PlacedItems.Server:GetChildren() do
                            if child2:GetAttribute("Owner") == v18 and child2.PrimaryPart then
                                local ServerConfiguration = child2:FindFirstChild("ServerConfiguration");

                                if ServerConfiguration and (ServerConfiguration:FindFirstChild("Type") and ServerConfiguration.Type.Value == "Tower") then
                                    local v20 = TowerData.getData(child2.Name:split(":")[1]);

                                    if v20 then
                                        local Variant = ServerConfiguration:FindFirstChild("Variant");
                                        local Mutations = ServerConfiguration:FindFirstChild("Mutations");
                                        local SizeScaling = ServerConfiguration:FindFirstChild("SizeScaling");

                                        if Variant and (Mutations and SizeScaling) then
                                            local v21 = getTowerLane(child, child2.PrimaryPart);

                                            if v21 then
                                                local PercentDamage = v20:FindFirstChild("PercentDamage");
                                                local v22;

                                                if PercentDamage then
                                                    local v23 = getBestRegularBaseDps(v18);

                                                    if v23 <= 0 then
                                                        v22 = v20.Damage.Value;
                                                    else
                                                        v22 = v23 * PercentDamage.Value * v20.AttackSpeed.Value;
                                                    end;
                                                else
                                                    v22 = v20.Damage.Value;
                                                end;

                                                local v24 = MutationData.calculateDamage(v22, Variant.Value, Mutations.Value, SizeScaling.Value);
                                                local Value = v20.AttackSpeed.Value;

                                                for _, child3 in child2:GetChildren() do
                                                    if child3:IsA("StringValue") and child3.Name == "Boombox" then
                                                        Value = Value * 0.75;
                                                    end;
                                                end;

                                                if Value > 0 then
                                                    v19[v21] = (v19[v21] or 0) + v24 / Value;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        for _, child2 in Lawnmowers:GetChildren() do
                            local v25 = tonumber(child2.Name:match("%d+"));

                            if v25 and child2.PrimaryPart then
                                local DPSInfo = child2.PrimaryPart:FindFirstChild("DPSInfo");

                                if DPSInfo then
                                    local Frame = DPSInfo:FindFirstChild("Frame");

                                    if Frame then
                                        Frame = Frame:FindFirstChild("Price");
                                    end;

                                    if Frame then
                                        Frame.Text = Simple.Format((math.round(v19[v25] or 0))) .. " DPS";
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;