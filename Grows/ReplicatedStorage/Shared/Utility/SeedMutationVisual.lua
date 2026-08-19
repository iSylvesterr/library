-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig);
local u9 = {
    applyBillboard = function(p1, p2) -- Line: 15, Name: applyBillboard
        -- upvalues: MutationConfig (copy), CollectionService (copy)
        local v3 = MutationConfig.Get(p2);

        if not (p1 and v3) then
            return;
        end;

        local Frame = p1:FindFirstChild("Frame");
        local v4;

        if Frame then
            v4 = Frame:FindFirstChild("Rarity");
        else
            v4 = Frame;
        end;

        if not v4 or Frame:FindFirstChild("Mutation") then
            return;
        end;

        local v5 = 0;

        for _, child in Frame:GetChildren() do
            if child:IsA("TextLabel") and child.Visible then
                v5 = v5 + 1;
            end;
        end;

        if v5 == 0 then
            return;
        end;

        local v6 = v4:Clone();
        v6.Name = "Mutation";
        v6.LayoutOrder = -1;
        v6.Text = v3.displayName;
        v6.TextColor3 = v3.textColor;
        v6:SetAttribute("rarity", nil);
        CollectionService:RemoveTag(v6, "ShinyTextLabel");
        v6.Parent = Frame;
        local v7 = (v5 + 1) / v5;

        for _, child in Frame:GetChildren() do
            if child:IsA("TextLabel") then
                child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, child.Size.Y.Scale / v7, child.Size.Y.Offset);
            end;
        end;

        local Scale = p1.Size.Y.Scale;
        local v8 = Scale * v7;
        p1.Size = UDim2.new(p1.Size.X.Scale, p1.Size.X.Offset, v8, p1.Size.Y.Offset);
        p1.StudsOffset = p1.StudsOffset + Vector3.new(0, (v8 - Scale) / 2, 0);
    end
};

function u9.attachFX(p10, u11, p12, p13) -- Line: 51
    -- upvalues: MutationConfig (copy), ReplicatedStorage (copy), u9 (copy)
    if not (p10 and (u11 and MutationConfig.Get(p12))) then
        return nil;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("MutationAssets");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("Fruits");
    end;

    if Assets then
        Assets = Assets:FindFirstChild(p12);
    end;

    if not Assets then
        return nil;
    end;

    local v14;

    if p10:IsA("BasePart") then
        v14 = p10.CFrame.Position;
    else
        if not p10:IsA("Model") then
            return nil;
        end;

        v14 = select(1, p10:GetBoundingBox()).Position;
    end;

    local v15 = Assets:Clone();

    if v15:IsA("Model") then
        local v16 = select(1, v15:GetBoundingBox());
        v15:PivotTo(v15:GetPivot() + (v14 - v16.Position));
    elseif v15:IsA("BasePart") then
        v15.CFrame = CFrame.new(v14);
    end;

    local function prepPart(p17) -- Line: 79
        -- upvalues: u11 (copy)
        p17.Transparency = 1;
        p17.Anchored = false;
        p17.CanCollide = false;
        p17.CanQuery = false;
        p17.CanTouch = false;
        p17.Massless = true;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = u11;
        WeldConstraint.Part1 = p17;
        WeldConstraint.Parent = p17;
    end;

    if v15:IsA("BasePart") then
        v15.Transparency = 1;
        v15.Anchored = false;
        v15.CanCollide = false;
        v15.CanQuery = false;
        v15.CanTouch = false;
        v15.Massless = true;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = u11;
        WeldConstraint.Part1 = v15;
        WeldConstraint.Parent = v15;
    end;

    for _, descendant in v15:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1;
            descendant.Anchored = false;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = u11;
            WeldConstraint.Part1 = descendant;
            WeldConstraint.Parent = descendant;
        end;
    end;

    u9.setFXEnabled(v15, p13 == true);
    v15.Name = "SeedMutationFX";
    v15.Parent = u11;

    return v15;
end;

function u9.setFXEnabled(p18, p19) -- Line: 103
    if not p18 then
        return;
    end;

    for _, descendant in p18:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p19;
        end;
    end;
end;

return u9;