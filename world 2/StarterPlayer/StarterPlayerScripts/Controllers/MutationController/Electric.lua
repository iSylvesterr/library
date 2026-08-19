-- Decompiled with Potassium's decompiler.

local v1 = {};
local GrowEffects = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("GrowEffects"));
local VFX = script.VFX;
local u2 = {};
local u3 = Color3.fromHSV(0, 0, 0);

local function isInsideFruits(p4, p5) -- Line: 13
    local Parent = p4.Parent;

    while Parent and Parent ~= p5 do
        if Parent.Name == "Fruits" then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function createVFXPart(u6) -- Line: 22
    -- upvalues: u2 (copy), GrowEffects (copy), VFX (copy)
    if u2[u6] then
        return;
    end;

    if not (u6:IsA("Model") and u6.PrimaryPart) then
        return;
    end;

    GrowEffects.AddDescendantsAtBaseline(u6, function() -- Line: 26
        -- upvalues: u6 (copy), VFX (ref), u2 (ref)
        local v7, v8 = u6:GetBoundingBox();
        local Part = Instance.new("Part");
        Part.Name = "ElectricVFX";
        Part.Size = v8;
        Part.CFrame = v7;
        Part.Transparency = 1;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Anchored = true;
        Part.Massless = true;
        Part:AddTag("MutationVFX");
        Part.Parent = u6;

        for _, child in VFX:GetChildren() do
            child:Clone().Parent = Part;
        end;

        u2[u6] = Part;
    end);
end;

local function tryCreateVFX(u9) -- Line: 50
    -- upvalues: u2 (copy), GrowEffects (copy), VFX (copy)
    if u9:IsA("Model") and u9.PrimaryPart then
        if u2[u9] then
            return;
        end;

        if u9:IsA("Model") then
            if not u9.PrimaryPart then
                return;
            end;

            GrowEffects.AddDescendantsAtBaseline(u9, function() -- Line: 26
                -- upvalues: u9 (copy), VFX (ref), u2 (ref)
                local v10, v11 = u9:GetBoundingBox();
                local Part = Instance.new("Part");
                Part.Name = "ElectricVFX";
                Part.Size = v11;
                Part.CFrame = v10;
                Part.Transparency = 1;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.CanTouch = false;
                Part.Anchored = true;
                Part.Massless = true;
                Part:AddTag("MutationVFX");
                Part.Parent = u9;

                for _, child in VFX:GetChildren() do
                    child:Clone().Parent = Part;
                end;

                u2[u9] = Part;
            end);
        end;
    end;
end;

local function applyElectricToPart(p12) -- Line: 56
    -- upvalues: u3 (copy)
    p12.Color = u3;
    p12.Reflectance = 25;
    p12.Material = "Plastic";
    p12.MaterialVariant = "";
end;

function v1.ApplyMutationEffect(u13) -- Line: 63
    -- upvalues: u2 (copy), GrowEffects (copy), VFX (copy), u3 (copy)
    if u13:IsA("Model") and (u13.PrimaryPart and (not u2[u13] and (u13:IsA("Model") and u13.PrimaryPart))) then
        GrowEffects.AddDescendantsAtBaseline(u13, function() -- Line: 26
            -- upvalues: u13 (copy), VFX (ref), u2 (ref)
            local v14, v15 = u13:GetBoundingBox();
            local Part = Instance.new("Part");
            Part.Name = "ElectricVFX";
            Part.Size = v15;
            Part.CFrame = v14;
            Part.Transparency = 1;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.Anchored = true;
            Part.Massless = true;
            Part:AddTag("MutationVFX");
            Part.Parent = u13;

            for _, child in VFX:GetChildren() do
                child:Clone().Parent = Part;
            end;

            u2[u13] = Part;
        end);
    end;

    if u13:IsA("BasePart") then
        u13.Color = u3;
        u13.Reflectance = 25;
        u13.Material = "Plastic";
        u13.MaterialVariant = "";
    end;

    for _, v in u13:QueryDescendants("BasePart") do
        local Parent = v.Parent;
        local v16;

        while true do
            if not Parent or Parent == u13 then
                v16 = false;
                break;
            end;

            if Parent.Name == "Fruits" then
                v16 = true;
                break;
            end;

            Parent = Parent.Parent;
        end;

        if not v16 then
            v.Color = u3;
            v.Reflectance = 25;
            v.Material = "Plastic";
            v.MaterialVariant = "";
        end;
    end;

    u13.DescendantAdded:Connect(function(p17) -- Line: 76
        -- upvalues: u13 (copy), u3 (ref), u2 (ref), GrowEffects (ref), VFX (ref)
        if p17:IsA("BasePart") then
            local v18 = u13;
            local Parent = p17.Parent;
            local v19;

            while true do
                if not Parent or Parent == v18 then
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
                p17.Color = u3;
                p17.Reflectance = 25;
                p17.Material = "Plastic";
                p17.MaterialVariant = "";
            end;
        end;

        if not u2[u13] then
            local u20 = u13;

            if u20:IsA("Model") and u20.PrimaryPart then
                if u2[u20] then
                    return;
                end;

                if u20:IsA("Model") then
                    if not u20.PrimaryPart then
                        return;
                    end;

                    GrowEffects.AddDescendantsAtBaseline(u20, function() -- Line: 26
                        -- upvalues: u20 (copy), VFX (ref), u2 (ref)
                        local v21, v22 = u20:GetBoundingBox();
                        local Part = Instance.new("Part");
                        Part.Name = "ElectricVFX";
                        Part.Size = v22;
                        Part.CFrame = v21;
                        Part.Transparency = 1;
                        Part.CanCollide = false;
                        Part.CanQuery = false;
                        Part.CanTouch = false;
                        Part.Anchored = true;
                        Part.Massless = true;
                        Part:AddTag("MutationVFX");
                        Part.Parent = u20;

                        for _, child in VFX:GetChildren() do
                            child:Clone().Parent = Part;
                        end;

                        u2[u20] = Part;
                    end);
                end;
            end;
        end;
    end);
end;

return v1;