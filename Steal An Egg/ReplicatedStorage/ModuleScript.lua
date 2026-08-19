-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActiveAssetModels = ReplicatedStorage:WaitForChild("ActiveAssetModels");
local AssetModels = ReplicatedStorage:WaitForChild("AssetModels");

local function findPart(p1, p2) -- Line: 7
    for _, descendant in ipairs(p1:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Name == p2 then
            return descendant;
        end;
    end;

    return nil;
end;

local v3 = 0;
local v4 = 0;

for _, child in ipairs(ActiveAssetModels:GetChildren()) do
    if child:IsA("Model") then
        local v5 = AssetModels:FindFirstChild(child.Name);

        if v5 and v5:IsA("Model") then
            local v6 = findPart(child, "CENTER");
            local v7 = findPart(child, "AnimRoot");
            local v8 = findPart(v5, "AnimRoot");

            if v6 and (v7 and v8) then
                local v9 = v7.CFrame:ToObjectSpace(v6.CFrame);
                local v10 = findPart(v5, "CENTER");

                if not v10 then
                    v10 = v6:Clone();
                    v10.Parent = v5;
                end;

                v10.CFrame = v8.CFrame * v9;

                if v10:IsA("BasePart") then
                    v10.Anchored = v6.Anchored;
                    v10.Size = v6.Size;
                    v10.Transparency = v6.Transparency;
                    v10.CanCollide = v6.CanCollide;
                end;

                print("Updated CENTER for:", v5.Name);
                v3 = v3 + 1;
            else
                warn(("Missing parts for %s (CENTER/AnimRoot)"):format(child.Name));
                v4 = v4 + 1;
            end;
        else
            warn("No matching target model for:", child.Name);
            v4 = v4 + 1;
        end;
    end;
end;

print(("Done. Updated: %d, Skipped: %d"):format(v3, v4));