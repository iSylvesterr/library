-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = require(ReplicatedStorage.Packages.Knit).CreateController({
    Name = "StandFruitBillboardController"
});

local function collectStandFruits() -- Line: 18
    local v2 = {};
    local BigField = workspace:FindFirstChild("BigField");

    if BigField then
        BigField = BigField:FindFirstChild("PlayerPlots");
    end;

    if not BigField then
        return v2;
    end;

    for _, child in BigField:GetChildren() do
        if child:IsA("Model") and child.Name:match("^PlayerPlot") then
            for _, child2 in child:GetChildren() do
                if child2:IsA("Model") and child2.Name:match("^PlotDecor_") then
                    for _, descendant in child2:GetDescendants() do
                        if descendant.Name == "FruitDisplay" and descendant:IsA("Model") then
                            local v3 = descendant:FindFirstChildWhichIsA("BillboardGui", true);
                            local v4 = descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart");

                            if v3 and v4 then
                                table.insert(v2, {
                                    billboard = v3,
                                    part = v4
                                });
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v2;
end;

function v1.KnitStart(p5) -- Line: 43
    -- upvalues: Players (copy), RunService (copy), collectStandFruits (copy)
    local LocalPlayer = Players.LocalPlayer;
    RunService.Heartbeat:Connect(function() -- Line: 46
        -- upvalues: LocalPlayer (copy), collectStandFruits (ref)
        local CurrentCamera = workspace.CurrentCamera;
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character then
            Character = Character.Position;
        end;

        local v6 = collectStandFruits();
        local v7 = nil;
        local v8 = 0.97;

        if CurrentCamera and Character then
            local Position = CurrentCamera.CFrame.Position;
            local LookVector = CurrentCamera.CFrame.LookVector;

            for _, v in v6 do
                if (v.part.Position - Character).Magnitude <= 35 then
                    local v9 = v.part.Position - Position;
                    local Magnitude = v9.Magnitude;

                    if Magnitude > 1 then
                        local v10 = LookVector:Dot(v9 / Magnitude);

                        if v8 < v10 then
                            v7 = v;
                            v8 = v10;
                        end;
                    end;
                end;
            end;
        end;

        for _, v in v6 do
            v.billboard.Enabled = v == v7;
        end;
    end);
end;

function v1.KnitInit(p11) -- Line: 75
end;

return v1;