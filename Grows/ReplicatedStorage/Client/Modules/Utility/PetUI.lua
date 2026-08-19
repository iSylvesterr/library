-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PetConfig = require(ReplicatedStorage.Shared.Info.PetConfig);
local PetAssets = require(ReplicatedStorage.Shared.Utility.PetAssets);
local Constants = require(ReplicatedStorage.Shared.Info.Constants);
local AbbreviateNumber = require(ReplicatedStorage.Shared.Utility.AbbreviateNumber);
local u8 = {
    renderPet = function(p1, p2) -- Line: 13, Name: renderPet
        -- upvalues: PetAssets (copy)
        if not p1 then
            return;
        end;

        for _, child in p1:GetChildren() do
            if child:IsA("Model") or child:IsA("Camera") then
                child:Destroy();
            end;
        end;

        local v3 = PetAssets.resolvePet(p2);

        if not v3 then
            return;
        end;

        local ZIndex = p1.ZIndex;
        local Parent = p1.Parent;

        while Parent and Parent:IsA("GuiObject") do
            ZIndex = math.max(ZIndex, Parent.ZIndex);
            Parent = Parent.Parent;
        end;

        p1.ZIndex = ZIndex + 1;
        local v4 = v3:Clone();

        for _, descendant in v4:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
            end;

            if descendant:IsA("Script") or (descendant:IsA("LocalScript") or descendant:IsA("ProximityPrompt")) then
                descendant:Destroy();
            end;
        end;

        local v5, v6 = v4:GetBoundingBox();
        v4:PivotTo(v4:GetPivot() + (Vector3.new(0, 0, 0) - v5.Position));
        v4:PivotTo(CFrame.Angles(0, -1.5707963267948966, 0) * v4:GetPivot());
        v4.Parent = p1;
        local Camera = Instance.new("Camera");
        Camera.FieldOfView = 40;
        local v7 = v6.Magnitude * 1.1 + 2;
        Camera.CFrame = CFrame.lookAt(Vector3.new(v7 * 0.7, v6.Y * 0.5 + v7 * 0.4, v7 * 0.7), Vector3.new(0, 0, 0));
        Camera.Parent = p1;
        p1.CurrentCamera = Camera;
        p1.Ambient = Color3.fromRGB(200, 200, 200);
        p1.LightColor = Color3.new(1, 1, 1);
    end
};

function u8.renderAnimatedPet(p9, p10) -- Line: 53
    -- upvalues: PetConfig (copy), PetAssets (copy), u8 (copy)
    if not p9 then
        return;
    end;

    local v11 = PetConfig.GetPet(p10);
    local v12 = v11 and v11.rig and PetAssets.resolveRig(v11.rig);

    if not (v12 and v11.idleAnim) then
        u8.renderPet(p9, p10);

        return;
    end;

    for _, child in p9:GetChildren() do
        if child:IsA("Model") or (child:IsA("Camera") or child:IsA("WorldModel")) then
            child:Destroy();
        end;
    end;

    local ZIndex = p9.ZIndex;
    local Parent = p9.Parent;

    while Parent and Parent:IsA("GuiObject") do
        ZIndex = math.max(ZIndex, Parent.ZIndex);
        Parent = Parent.Parent;
    end;

    p9.ZIndex = ZIndex + 1;
    local WorldModel = Instance.new("WorldModel");
    WorldModel.Parent = p9;
    local v13 = v12:Clone();
    local v14 = {};

    for _, descendant in v13:GetDescendants() do
        if descendant:IsA("Motor6D") then
            if descendant.Part0 then
                v14[descendant.Part0] = true;
            end;

            if descendant.Part1 then
                v14[descendant.Part1] = true;
            end;
        end;
    end;

    for _, descendant in v13:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.CanCollide = false;

            if v14[descendant] then
                descendant.Transparency = 1;
            end;
        end;

        if descendant:IsA("Script") or (descendant:IsA("LocalScript") or descendant:IsA("ProximityPrompt")) then
            descendant:Destroy();
        end;
    end;

    if v13.PrimaryPart then
        v13.PrimaryPart.Anchored = true;
    end;

    local v15, v16 = v13:GetBoundingBox();
    v13:PivotTo(v13:GetPivot() + (Vector3.new(0, 0, 0) - v15.Position));
    v13:PivotTo(CFrame.Angles(0, -1.5707963267948966, 0) * v13:GetPivot());
    v13.Parent = WorldModel;
    local v17 = v13:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController");
    local u18 = v17:FindFirstChildOfClass("Animator") or Instance.new("Animator");
    u18.Parent = v17;
    v17.Parent = v13;
    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://" .. tostring(v11.idleAnim);
    local success, result = pcall(function() -- Line: 110
        -- upvalues: u18 (copy), Animation (copy)
        return u18:LoadAnimation(Animation);
    end);

    if success and result then
        result.Looped = true;
        result:Play(0);
    end;

    local Camera = Instance.new("Camera");
    Camera.FieldOfView = 40;
    local v19 = v16.Magnitude * 1.1 + 2;
    Camera.CFrame = CFrame.lookAt(Vector3.new(v19 * 0.7, v16.Y * 0.5 + v19 * 0.4, v19 * 0.7), Vector3.new(0, 0, 0));
    Camera.Parent = p9;
    p9.CurrentCamera = Camera;
    p9.Ambient = Color3.fromRGB(200, 200, 200);
    p9.LightColor = Color3.new(1, 1, 1);
end;

function u8.setBar(p20, p21, p22, p23) -- Line: 127
    if not p20 then
        return;
    end;

    local PetName = p20:FindFirstChild("PetName");

    if p23 and (PetName and PetName:IsA("TextLabel")) then
        PetName.Text = p23;
    end;

    local LevelBar = p20:FindFirstChild("LevelBar");
    local v24;

    if LevelBar then
        v24 = LevelBar:FindFirstChild("FillBar");
    else
        v24 = LevelBar;
    end;

    if v24 then
        v24.Size = UDim2.new(math.clamp(p21, 0, 1), 0, v24.Size.Y.Scale, v24.Size.Y.Offset);
    end;

    if LevelBar then
        LevelBar = LevelBar:FindFirstChild("Value");
    end;

    if LevelBar and LevelBar:IsA("TextLabel") then
        LevelBar.Text = p22;
    end;
end;

function u8.applyBars(p25, p26) -- Line: 143
    -- upvalues: PetConfig (copy), u8 (copy), AbbreviateNumber (copy)
    if not p25 then
        return;
    end;

    local v27 = p26.maxHunger or PetConfig.GetMaxHunger(p26.petType);
    local v28 = p26.hunger or 0;
    u8.setBar(p25:FindFirstChild("Hunger"), v27 > 0 and (v28 / v27 or 0) or 0, string.format("%s/%s", AbbreviateNumber(v28), AbbreviateNumber(v27)), "Hunger");
    local v29 = p26.level or 0;
    local v30 = PetConfig.GetXpRequired(v29);
    local v31 = p26.xp or 0;
    u8.setBar(p25:FindFirstChild("Level"), v30 > 0 and (v31 / v30 or 0) or 0, string.format("%s/%s", AbbreviateNumber(v31), AbbreviateNumber(v30)), "Level " .. tostring(v29));
end;

function u8.rarityColour(p32) -- Line: 165
    -- upvalues: PetConfig (copy), Constants (copy)
    local v33 = PetConfig.GetPet(p32);

    if v33 then
        v33 = Constants.RARITY_COLORS[v33.rarity];
    end;

    return v33;
end;

function u8.titleFor(p34) -- Line: 171
    -- upvalues: PetConfig (copy), Constants (copy)
    local v35 = PetConfig.GetPet(p34);

    if not v35 then
        return p34;
    end;

    local v36 = Constants.RARITY_COLORS[v35.rarity];
    local v37 = v35.rarity:sub(1, 1) .. v35.rarity:sub(2):lower();

    if v36 then
        return string.format("%s <font color=\"rgb(%d,%d,%d)\">[%s]</font>", p34, math.round(v36.R * 255), math.round(v36.G * 255), math.round(v36.B * 255), v37);
    end;

    return string.format("%s [%s]", p34, v37);
end;

return u8;