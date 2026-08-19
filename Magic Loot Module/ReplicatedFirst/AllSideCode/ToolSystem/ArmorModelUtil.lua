-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AssetRegistry = UtilsSystem.AssetRegistry;
local InsMgr = UtilsSystem.InsMgr;
local Log = UtilsSystem.Log;
local ResourceUtil = UtilsSystem.ResourceUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local u1 = {};
local u2 = {
    LeftArm = "Left Arm",
    RightArm = "Right Arm",
    LeftLeg = "Left Leg",
    RightLeg = "Right Leg"
};

local function _snapCapeAxisDeg(p3) -- Line: 51
    return math.round(p3 / 90) * 90;
end;

local function _getCapeSnappedOrientationDeg(p4) -- Line: 55
    local v5, v6, v7 = p4:GetPivot():ToOrientation();
    local v8 = math.deg(v5) / 90;
    local v9 = math.round(v8) * 90;
    local v10 = math.deg(v6) / 90;
    local v11 = math.round(v10) * 90;
    local v12 = math.deg(v7) / 90;

    return v9, v11, math.round(v12) * 90;
end;

local function _getCapeMountOffsetFromSnapped(p13, p14, p15) -- Line: 61
    if p13 == 90 and (p14 == 0 and p15 == 0) then
        return CFrame.Angles(0, 0, -1.5707963267948966);
    end;

    return CFrame.Angles(math.rad(p13), math.rad(p14), (math.rad(p15))):Inverse();
end;

local function _stripCapeSmartBone(p16) -- Line: 74
    if p16.Name ~= "Cape" then
        return nil;
    end;

    local PrimaryPart = p16.PrimaryPart;

    if PrimaryPart and PrimaryPart:IsA("BasePart") then
        PrimaryPart:RemoveTag("SmartBone");
    end;

    return nil;
end;

local function _applyCapeSmartBoneAttrs(p17) -- Line: 90
    p17:AddTag("SmartBone");
    p17:SetAttribute("ActivationDistance", 150);
    p17:SetAttribute("AnchorDepth", 1);
    p17:SetAttribute("AnchorsRotate", false);
    p17:SetAttribute("Constraint", "Spring");
    p17:SetAttribute("Damping", 0.1);
    p17:SetAttribute("Elasticity", 1);
    p17:SetAttribute("Inertia", 0);
    p17:SetAttribute("MatchWorkspaceWind", true);
    p17:SetAttribute("WindInfluence", 0);
    p17:SetAttribute("ColliderKey", "");
    p17:SetAttribute("Stiffness", 0.8);
    p17:SetAttribute("ThrottleDistance", 75);
    p17:SetAttribute("WindType", "Hybrid");
    p17:SetAttribute("Gravity", Vector3.new(0, 0, 0));
    p17:SetAttribute("Force", Vector3.new(0, 0, 0));
    p17:SetAttribute("UpdateRate", 30);
    p17:SetAttribute("Radius", 0.2);
    p17:SetAttribute("Roots", "骨骼");

    return nil;
end;

local function _createViewportRigBase() -- Line: 117
    local Model = Instance.new("Model");
    Model.Name = "RigBase";
    local v18 = {
        { "Torso", Vector3.new(2, 2, 1), CFrame.new(0, 0, 0) },
        { "Head", Vector3.new(2, 1, 1), CFrame.new(0, 1.5, 0) },
        { "Left Arm", Vector3.new(1, 2, 1), CFrame.new(-1.5, 0, 0) },
        { "Right Arm", Vector3.new(1, 2, 1), CFrame.new(1.5, 0, 0) },
        { "Left Leg", Vector3.new(1, 2, 1), CFrame.new(-0.5, -2, 0) },
        { "Right Leg", Vector3.new(1, 2, 1), CFrame.new(0.5, -2, 0) }
    };
    local v19 = nil;

    for _, v in ipairs(v18) do
        local v20 = v[1];
        local v21 = v[2];
        local v22 = v[3];
        local Part = Instance.new("Part");
        Part.Name = v20;
        Part.Size = v21;
        Part.CFrame = v22;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Massless = true;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Plastic;
        Part.Color = Color3.fromRGB(120, 120, 120);
        Part.Parent = Model;

        if v20 == "Torso" then
            v19 = Part;
        end;
    end;

    if v19 then
        Model.PrimaryPart = v19;
    end;

    return Model;
end;

function u1.GetSetTemplate(p23) -- Line: 165
    -- upvalues: AssetRegistry (copy), ResourceUtil (copy)
    if type(p23) ~= "string" or p23 == "" then
        return nil;
    end;

    local v24 = AssetRegistry.BuildModelPath(ResourceUtil.ModelCategory.Armor, p23);

    return ResourceUtil.GetTemplate(v24);
end;

function u1.CollectSubModels(p25) -- Line: 178
    local v26 = {};

    if p25:IsA("Folder") or p25:IsA("Model") then
        for _, child in ipairs(p25:GetChildren()) do
            if child:IsA("Model") then
                table.insert(v26, child);
            end;
        end;

        if p25:IsA("Model") and #v26 == 0 then
            table.insert(v26, p25);
        end;
    end;

    return v26;
end;

function u1.ResolveMountPartName(p27) -- Line: 198
    -- upvalues: u2 (copy)
    return p27 == "Cape" and "Torso" or (u2[p27] or p27);
end;

function u1.PrepareSubModelClone(p28) -- Line: 214
    -- upvalues: VisibleMgr (copy)
    VisibleMgr.UnAnchoredAll(p28);
    VisibleMgr.UnCollideAll(p28);
    VisibleMgr.UnTouchAll(p28);
    VisibleMgr.UnQueryAll(p28);

    return nil;
end;

function u1.WeldSubModel(p29, p30) -- Line: 228
    -- upvalues: Log (copy), u1 (copy), InsMgr (copy), _getCapeMountOffsetFromSnapped (copy)
    local PrimaryPart = p29.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        Log.warn("[ArmorModelUtil] 防具子模型无 PrimaryPart:", p29.Name);
        p29:Destroy();

        return false;
    end;

    u1.PrepareSubModelClone(p29);
    local v31 = InsMgr.GetIns("ArmorWeld", "WeldConstraint", p29);

    if p29.Name == "Cape" then
        local v32, v33, v34 = p29:GetPivot():ToOrientation();
        local v35 = math.deg(v32) / 90;
        local v36 = math.round(v35) * 90;
        local v37 = math.deg(v33) / 90;
        local v38 = math.round(v37) * 90;
        local v39 = math.deg(v34) / 90;
        local v40 = math.round(v39) * 90;
        local v41 = _getCapeMountOffsetFromSnapped(v36, v38, v40);

        if v36 == 0 and (v38 == 0 and v40 == 0) then
            p29:PivotTo(p30:GetPivot() * v41);
        else
            p29:PivotTo(p30:GetPivot() * v41 * CFrame.new(Vector3.new(0, -0.83, -0.3)));
        end;

        v31.Part0 = PrimaryPart;
        v31.Part1 = p30;
    else
        p29:PivotTo(p30:GetPivot());
        v31.Part0 = p30;
        v31.Part1 = PrimaryPart;
    end;

    return true;
end;

function u1.ApplyCapeSmartBoneAttrs(p42) -- Line: 260
    -- upvalues: _applyCapeSmartBoneAttrs (copy)
    if not (p42 and p42:IsA("BasePart")) then
        return nil;
    end;

    _applyCapeSmartBoneAttrs(p42);

    return nil;
end;

function u1.StripCapeSmartBone(p43) -- Line: 273
    if p43.Name ~= "Cape" then
        return nil;
    end;

    local PrimaryPart = p43.PrimaryPart;

    if PrimaryPart and PrimaryPart:IsA("BasePart") then
        PrimaryPart:RemoveTag("SmartBone");
    end;

    return nil;
end;

function u1.MountArmorSet(p44, p45, p46) -- Line: 291
    -- upvalues: u1 (copy), _applyCapeSmartBoneAttrs (copy)
    if type(p44) ~= "string" or (p44 == "" or not p45) then
        return false;
    end;

    local v47 = u1.GetSetTemplate(p44);

    if not v47 then
        return false;
    end;

    local v48 = u1.CollectSubModels(v47);

    if #v48 == 0 then
        return false;
    end;

    local v49 = false;

    for _, v in ipairs(v48) do
        local v50 = v:Clone();
        v50.Name = v.Name;

        if p46 and p46.prepareClone then
            p46.prepareClone(v50);
        end;

        local v51 = p45:FindFirstChild((u1.ResolveMountPartName(v50.Name)));

        if v51 and v51:IsA("BasePart") then
            local v52;

            if p46 and p46.parentOf then
                v52 = p46.parentOf(v50) or p45;
            else
                v52 = p45;
            end;

            v50.Parent = v52;

            if u1.WeldSubModel(v50, v51) then
                v49 = true;

                if v50.Name == "Cape" then
                    if p46 and p46.stripCapeSmartBone then
                        if v50.Name == "Cape" then
                            local PrimaryPart = v50.PrimaryPart;

                            if PrimaryPart and PrimaryPart:IsA("BasePart") then
                                PrimaryPart:RemoveTag("SmartBone");
                            end;
                        end;
                    elseif p46 and p46.enableCapeSmartBone then
                        local PrimaryPart = v50.PrimaryPart;

                        if PrimaryPart and PrimaryPart:IsA("BasePart") then
                            _applyCapeSmartBoneAttrs(PrimaryPart);
                        end;
                    end;
                end;
            end;
        else
            v50:Destroy();
        end;
    end;

    return v49;
end;

function u1.BuildViewportShowModel(p53) -- Line: 348
    -- upvalues: _createViewportRigBase (copy), VisibleMgr (copy), u1 (copy)
    if type(p53) ~= "string" or p53 == "" then
        return nil;
    end;

    local Model = Instance.new("Model");
    Model.Name = "ArmorViewportSet";
    local v54 = _createViewportRigBase();
    v54.Parent = Model;
    VisibleMgr.fadeAll(v54, 1);

    if not u1.MountArmorSet(p53, v54, {
        stripCapeSmartBone = true,

        parentOf = function(p55) -- Line: 360, Name: parentOf
            -- upvalues: Model (copy)
            return Model;
        end
    }) then
        Model:Destroy();

        return nil;
    end;

    if v54.PrimaryPart then
        Model.PrimaryPart = v54.PrimaryPart;
    end;

    Model:PivotTo(CFrame.new());

    return Model;
end;

return u1;