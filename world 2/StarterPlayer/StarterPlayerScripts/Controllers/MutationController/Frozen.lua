-- Decompiled with Potassium's decompiler.

local v1 = {};
local GrowEffects = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("GrowEffects"));
local u2 = Color3.fromRGB(180, 220, 255);
local VFX = script.VFX;
local u3 = {};

local function isInsideFruits(p4, p5) -- Line: 10
    local Parent = p4.Parent;

    while Parent and Parent ~= p5 do
        if Parent.Name == "Fruits" then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function createVFXPart(u6) -- Line: 19
    -- upvalues: u3 (copy), GrowEffects (copy), VFX (copy)
    if u3[u6] then
        return;
    end;

    if not (u6:IsA("Model") and u6.PrimaryPart) then
        return;
    end;

    GrowEffects.AddDescendantsAtBaseline(u6, function() -- Line: 23
        -- upvalues: u6 (copy), VFX (ref), u3 (ref)
        local v7, v8 = u6:GetBoundingBox();
        local PrimaryPart = u6.PrimaryPart;
        local Part = Instance.new("Part");
        Part.Name = "FrozenVFX";
        Part.Size = v8;
        Part.CFrame = v7;
        Part.Transparency = 1;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Anchored = false;
        Part.Massless = true;
        Part:AddTag("MutationVFX");
        Part.Parent = u6;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = PrimaryPart;
        WeldConstraint.Part1 = Part;
        WeldConstraint.Parent = Part;
        local v9 = game.ReplicatedStorage.Assets.Stud_Part:Clone();
        v9.Name = "FrozenFX";
        v9.Size = v8;
        v9.CFrame = v7;
        v9.Transparency = 0.5;
        v9.Color = Color3.fromRGB(160, 210, 255);
        v9.CanCollide = false;
        v9.CanQuery = false;
        v9.CanTouch = false;
        v9.Anchored = false;
        v9.Massless = true;
        v9.Parent = u6;
        local WeldConstraint2 = Instance.new("WeldConstraint");
        WeldConstraint2.Part0 = PrimaryPart;
        WeldConstraint2.Part1 = v9;
        WeldConstraint2.Parent = v9;

        for _, child in VFX:GetChildren() do
            child:Clone().Parent = v9;
        end;

        u3[u6] = v9;
    end);
end;

local function tryCreateVFX(u10) -- Line: 71
    -- upvalues: u3 (copy), GrowEffects (copy), VFX (copy)
    if u10:IsA("Model") and u10.PrimaryPart then
        if u3[u10] then
            return;
        end;

        if u10:IsA("Model") then
            if not u10.PrimaryPart then
                return;
            end;

            GrowEffects.AddDescendantsAtBaseline(u10, function() -- Line: 23
                -- upvalues: u10 (copy), VFX (ref), u3 (ref)
                local v11, v12 = u10:GetBoundingBox();
                local PrimaryPart = u10.PrimaryPart;
                local Part = Instance.new("Part");
                Part.Name = "FrozenVFX";
                Part.Size = v12;
                Part.CFrame = v11;
                Part.Transparency = 1;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.CanTouch = false;
                Part.Anchored = false;
                Part.Massless = true;
                Part:AddTag("MutationVFX");
                Part.Parent = u10;
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = PrimaryPart;
                WeldConstraint.Part1 = Part;
                WeldConstraint.Parent = Part;
                local v13 = game.ReplicatedStorage.Assets.Stud_Part:Clone();
                v13.Name = "FrozenFX";
                v13.Size = v12;
                v13.CFrame = v11;
                v13.Transparency = 0.5;
                v13.Color = Color3.fromRGB(160, 210, 255);
                v13.CanCollide = false;
                v13.CanQuery = false;
                v13.CanTouch = false;
                v13.Anchored = false;
                v13.Massless = true;
                v13.Parent = u10;
                local WeldConstraint2 = Instance.new("WeldConstraint");
                WeldConstraint2.Part0 = PrimaryPart;
                WeldConstraint2.Part1 = v13;
                WeldConstraint2.Parent = v13;

                for _, child in VFX:GetChildren() do
                    child:Clone().Parent = v13;
                end;

                u3[u10] = v13;
            end);
        end;
    end;
end;

local function applyFrozenToPart(p14) -- Line: 77
    -- upvalues: u2 (copy)
    p14.Color = u2;
    p14.Reflectance = 0.4;
end;

function v1.ApplyMutationEffect(u15) -- Line: 82
    -- upvalues: u3 (copy), GrowEffects (copy), VFX (copy), u2 (copy)
    if u15:IsA("Model") and (u15.PrimaryPart and (not u3[u15] and (u15:IsA("Model") and u15.PrimaryPart))) then
        GrowEffects.AddDescendantsAtBaseline(u15, function() -- Line: 23
            -- upvalues: u15 (copy), VFX (ref), u3 (ref)
            local v16, v17 = u15:GetBoundingBox();
            local PrimaryPart = u15.PrimaryPart;
            local Part = Instance.new("Part");
            Part.Name = "FrozenVFX";
            Part.Size = v17;
            Part.CFrame = v16;
            Part.Transparency = 1;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.Anchored = false;
            Part.Massless = true;
            Part:AddTag("MutationVFX");
            Part.Parent = u15;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = Part;
            WeldConstraint.Parent = Part;
            local v18 = game.ReplicatedStorage.Assets.Stud_Part:Clone();
            v18.Name = "FrozenFX";
            v18.Size = v17;
            v18.CFrame = v16;
            v18.Transparency = 0.5;
            v18.Color = Color3.fromRGB(160, 210, 255);
            v18.CanCollide = false;
            v18.CanQuery = false;
            v18.CanTouch = false;
            v18.Anchored = false;
            v18.Massless = true;
            v18.Parent = u15;
            local WeldConstraint2 = Instance.new("WeldConstraint");
            WeldConstraint2.Part0 = PrimaryPart;
            WeldConstraint2.Part1 = v18;
            WeldConstraint2.Parent = v18;

            for _, child in VFX:GetChildren() do
                child:Clone().Parent = v18;
            end;

            u3[u15] = v18;
        end);
    end;

    if u15:IsA("BasePart") then
        u15.Color = u2;
        u15.Reflectance = 0.4;
    end;

    for _, v in u15:QueryDescendants("BasePart") do
        local Parent = v.Parent;
        local v19;

        while true do
            if not Parent or Parent == u15 then
                v19 = false;
                break;
            end;

            if Parent.Name == "Fruits" then
                v19 = true;
                break;
            end;

            Parent = Parent.Parent;
        end;

        if not v19 then
            v.Color = u2;
            v.Reflectance = 0.4;
        end;
    end;

    u15.DescendantAdded:Connect(function(p20) -- Line: 95
        -- upvalues: u15 (copy), u2 (ref), u3 (ref), GrowEffects (ref), VFX (ref)
        if p20:IsA("BasePart") then
            local v21 = u15;
            local Parent = p20.Parent;
            local v22;

            while true do
                if not Parent or Parent == v21 then
                    v22 = false;
                    break;
                end;

                if Parent.Name == "Fruits" then
                    v22 = true;
                    break;
                end;

                Parent = Parent.Parent;
            end;

            if not v22 then
                p20.Color = u2;
                p20.Reflectance = 0.4;
            end;
        end;

        if not u3[u15] then
            local u23 = u15;

            if u23:IsA("Model") and u23.PrimaryPart then
                if u3[u23] then
                    return;
                end;

                if u23:IsA("Model") then
                    if not u23.PrimaryPart then
                        return;
                    end;

                    GrowEffects.AddDescendantsAtBaseline(u23, function() -- Line: 23
                        -- upvalues: u23 (copy), VFX (ref), u3 (ref)
                        local v24, v25 = u23:GetBoundingBox();
                        local PrimaryPart = u23.PrimaryPart;
                        local Part = Instance.new("Part");
                        Part.Name = "FrozenVFX";
                        Part.Size = v25;
                        Part.CFrame = v24;
                        Part.Transparency = 1;
                        Part.CanCollide = false;
                        Part.CanQuery = false;
                        Part.CanTouch = false;
                        Part.Anchored = false;
                        Part.Massless = true;
                        Part:AddTag("MutationVFX");
                        Part.Parent = u23;
                        local WeldConstraint = Instance.new("WeldConstraint");
                        WeldConstraint.Part0 = PrimaryPart;
                        WeldConstraint.Part1 = Part;
                        WeldConstraint.Parent = Part;
                        local v26 = game.ReplicatedStorage.Assets.Stud_Part:Clone();
                        v26.Name = "FrozenFX";
                        v26.Size = v25;
                        v26.CFrame = v24;
                        v26.Transparency = 0.5;
                        v26.Color = Color3.fromRGB(160, 210, 255);
                        v26.CanCollide = false;
                        v26.CanQuery = false;
                        v26.CanTouch = false;
                        v26.Anchored = false;
                        v26.Massless = true;
                        v26.Parent = u23;
                        local WeldConstraint2 = Instance.new("WeldConstraint");
                        WeldConstraint2.Part0 = PrimaryPart;
                        WeldConstraint2.Part1 = v26;
                        WeldConstraint2.Parent = v26;

                        for _, child in VFX:GetChildren() do
                            child:Clone().Parent = v26;
                        end;

                        u3[u23] = v26;
                    end);
                end;
            end;
        end;
    end);
end;

return v1;