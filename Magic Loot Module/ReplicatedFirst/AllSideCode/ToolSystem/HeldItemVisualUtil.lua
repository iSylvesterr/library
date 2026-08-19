-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local Log = UtilsSystem.Log;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local VisibleMgr = UtilsSystem.VisibleMgr;
local CharacterMorphUtil = UtilsSystem.CharacterMorphUtil;
local u1 = {
    WEAPON_HOLSTER_FOLDER_NAME = "装备武器背挂",
    HELD_FOLDER_NAME = "当前手持",
    HOLSTER_MOUNT_LOCAL = CFrame.new(-1.1, -0.7, -0.6) * CFrame.Angles(0, 3.141592653589793, 0),
    HOLSTER_VISUAL_OFFSET = CFrame.Angles(0, 0, 1.0471975511965976),
    ATTR_SLOT_EQUIPPED_WEAPON = "SlotEquippedWeapon",
    ATTR_WEAPON_DISPLAY = "WeaponDisplayMode"
};
local ATTR_SLOT_EQUIPPED_WEAPON = u1.ATTR_SLOT_EQUIPPED_WEAPON;
local ATTR_WEAPON_DISPLAY = u1.ATTR_WEAPON_DISPLAY;

function u1.ComputeGripCFrame(p2, p3) -- Line: 55
    local v4 = p2:FindFirstChild("握点");

    if v4 and v4:IsA("BasePart") then
        return v4.CFrame:Inverse();
    end;

    local Handle = p2:FindFirstChild("Handle");

    if Handle and Handle:IsA("BasePart") then
        return Handle.CFrame:Inverse();
    end;

    if p3 == "Potion" or (p3 == "Material" or p3 == "Cauldron") then
        local PrimaryPart = p2.PrimaryPart;

        if PrimaryPart and PrimaryPart:IsA("BasePart") then
            local v5 = PrimaryPart.Size.Z * 0.5;

            return CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, p3 == "Material" and 0.35 or 0, -v5);
        end;
    end;

    return CFrame.new();
end;

local function _getWeaponSlotScale(p6, p7) -- Line: 82
    -- upvalues: SystemGameConfig (copy)
    local v8 = tonumber(SystemGameConfig.GetValue({ "装备", p6 }));

    if v8 == nil or v8 <= 0 then
        return p7;
    end;

    return v8;
end;

function u1.ApplyWeaponSlotScale(u9, p10, p11) -- Line: 100
    -- upvalues: SystemGameConfig (copy), CharacterMorphUtil (copy), Log (copy)
    local v12 = tonumber(SystemGameConfig.GetValue({ "装备", "槽位武器手持缩放" }));
    local v13 = (v12 == nil or v12 <= 0) and 1 or v12;
    local v14 = tonumber(SystemGameConfig.GetValue({ "装备", "槽位武器背挂缩放" }));
    local u15 = (v14 == nil or v14 <= 0) and 0.6 or v14;

    if p10 == "Hand" then
        u15 = v13;
    end;

    if p11 then
        u15 = u15 * CharacterMorphUtil.GetBodyScaleMul(p11);
    end;

    local success, result = pcall(function() -- Line: 107
        -- upvalues: u9 (copy), u15 (ref)
        u9:ScaleTo(u15);
    end);

    if not success then
        Log.warn("[HeldItemVisualUtil] ScaleTo failed", u9.Name, p10, u15, result);
    end;

    u9:SetAttribute("SlotWeaponScaleMode", p10);

    return nil;
end;

function u1.SetupWeaponMountParts(p16) -- Line: 123
    -- upvalues: InsMgr (copy)
    local v17 = p16:FindFirstChild("Left Arm");
    local v18 = p16:FindFirstChild("Right Arm");
    local Torso = p16:FindFirstChild("Torso");

    if not (v17 and v17:IsA("BasePart")) then
        return false;
    end;

    if not (v18 and v18:IsA("BasePart")) then
        return false;
    end;

    if not (Torso and Torso:IsA("BasePart")) then
        return false;
    end;

    local v19 = InsMgr.GetIns("Left Weapon", "Part", p16);
    v19.CanCollide = false;
    v19.CanTouch = false;
    v19.CanQuery = false;
    v19.Massless = true;
    v19.Size = Vector3.new(0.1, 0.1, 0.1);
    v19.Transparency = 1;
    v19.Anchored = false;
    local v20 = InsMgr.GetIns("Left Weapon", "Motor6D", Torso);
    v20.Part0 = v17;
    v20.Part1 = v19;
    v20.C0 = CFrame.new(0, -1, 0);
    local v21 = InsMgr.GetIns("Right Weapon", "Part", p16);
    v21.CanCollide = false;
    v21.CanTouch = false;
    v21.CanQuery = false;
    v21.Massless = true;
    v21.Size = Vector3.new(0.1, 0.1, 0.1);
    v21.Transparency = 1;
    v21.Anchored = false;
    local v22 = InsMgr.GetIns("Right Weapon", "Motor6D", Torso);
    v22.Part0 = v18;
    v22.Part1 = v21;
    v22.C0 = CFrame.new(0, -1, 0);

    return true;
end;

function u1.EnsureHeldFolder(p23) -- Line: 172
    -- upvalues: InsMgr (copy), u1 (copy)
    return InsMgr.GetIns(u1.HELD_FOLDER_NAME, "Folder", p23);
end;

function u1.EnsureHolsterFolder(p24) -- Line: 182
    -- upvalues: InsMgr (copy), u1 (copy)
    return InsMgr.GetIns(u1.WEAPON_HOLSTER_FOLDER_NAME, "Folder", p24);
end;

function u1.EnsureHolsterMount(p25) -- Line: 192
    -- upvalues: InsMgr (copy), u1 (copy)
    local WeaponHolsterMount = p25:FindFirstChild("WeaponHolsterMount");

    if WeaponHolsterMount and WeaponHolsterMount:IsA("BasePart") then
        return WeaponHolsterMount;
    end;

    local v26 = InsMgr.GetIns("WeaponHolsterMount", "Part", p25);
    v26.Size = Vector3.new(0.1, 0.1, 0.1);
    v26.Transparency = 1;
    v26.CanCollide = false;
    v26.CanTouch = false;
    v26.CanQuery = false;
    v26.Massless = true;
    v26.Anchored = false;
    v26.CFrame = p25.CFrame * u1.HOLSTER_MOUNT_LOCAL;

    if v26:FindFirstChild("WeaponHolsterMountWeld") == nil then
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Name = "WeaponHolsterMountWeld";
        WeldConstraint.Part0 = p25;
        WeldConstraint.Part1 = v26;
        WeldConstraint.Parent = v26;
    end;

    return v26;
end;

function u1.ClearHeldModels(p27) -- Line: 222
    -- upvalues: u1 (copy), CollectionService (copy)
    local v28 = p27:FindFirstChild(u1.HELD_FOLDER_NAME);

    if not v28 then
        return nil;
    end;

    for _, child in ipairs(v28:GetChildren()) do
        if child:IsA("Model") then
            local PrimaryPart = child.PrimaryPart;

            if PrimaryPart and PrimaryPart:IsA("BasePart") then
                CollectionService:RemoveTag(PrimaryPart, "HeldWeapon");
                CollectionService:RemoveTag(PrimaryPart, "HeldPotion");
            end;

            child:Destroy();
        end;
    end;

    return nil;
end;

function u1.FindHolsteredWeapon(p29) -- Line: 246
    -- upvalues: u1 (copy), ATTR_SLOT_EQUIPPED_WEAPON (copy)
    local v30 = p29:FindFirstChild(u1.WEAPON_HOLSTER_FOLDER_NAME);

    if not v30 then
        return nil;
    end;

    for _, child in ipairs(v30:GetChildren()) do
        if child:IsA("Model") and child:GetAttribute(ATTR_SLOT_EQUIPPED_WEAPON) == true then
            return child;
        end;
    end;

    return nil;
end;

function u1.AttachModelToRightWeapon(p31, p32, p33, p34, p35) -- Line: 269
    -- upvalues: u1 (copy), VisibleMgr (copy), ATTR_SLOT_EQUIPPED_WEAPON (copy), ATTR_WEAPON_DISPLAY (copy), InsMgr (copy), CollectionService (copy)
    local v36 = p31:FindFirstChild("Right Weapon");

    if not (v36 and v36:IsA("BasePart")) then
        return false;
    end;

    local PrimaryPart = p32.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        return false;
    end;

    u1.ClearHeldModels(p31);
    VisibleMgr.PrepareModelForAttach(p32);
    VisibleMgr.Weld(p32, PrimaryPart);
    local v37 = p34 or u1.ComputeGripCFrame(p32, p33);
    local v38 = u1.EnsureHeldFolder(p31);

    if p33 == "Weapon" then
        p32:SetAttribute(ATTR_SLOT_EQUIPPED_WEAPON, true);
        p32:SetAttribute(ATTR_WEAPON_DISPLAY, "Hand");
        u1.ApplyWeaponSlotScale(p32, "Hand", p31);
    end;

    p32:PivotTo(v36.CFrame * v37);
    p32.Parent = v38;
    p32:SetAttribute("ItemType", p33);
    local v39 = InsMgr.GetIns("Weapon", "WeldConstraint", p32);
    v39.Part0 = v36;
    v39.Part1 = PrimaryPart;

    if not p35 then
        if p33 == "Weapon" then
            CollectionService:AddTag(PrimaryPart, "HeldWeapon");
        elseif p33 == "Potion" then
            CollectionService:AddTag(PrimaryPart, "HeldPotion");
        end;
    end;

    return true;
end;

function u1.AttachModelToHolster(p40, p41) -- Line: 325
    -- upvalues: u1 (copy), VisibleMgr (copy), ATTR_WEAPON_DISPLAY (copy), ATTR_SLOT_EQUIPPED_WEAPON (copy), CollectionService (copy), InsMgr (copy)
    local Torso = p40:FindFirstChild("Torso");

    if not (Torso and Torso:IsA("BasePart")) then
        return false;
    end;

    local v42 = u1.EnsureHolsterMount(Torso);
    local v43 = u1.EnsureHolsterFolder(p40);
    local PrimaryPart = p41.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        return false;
    end;

    local Weapon = p41:FindFirstChild("Weapon");

    if Weapon then
        Weapon:Destroy();
    end;

    VisibleMgr.PrepareModelForAttach(p41);
    p41.Parent = v43;
    p41:SetAttribute(ATTR_WEAPON_DISPLAY, "Holstered");
    p41:SetAttribute(ATTR_SLOT_EQUIPPED_WEAPON, true);
    p41:SetAttribute("ItemType", "Weapon");
    u1.ApplyWeaponSlotScale(p41, "Holstered", p40);
    local v44 = u1.ComputeGripCFrame(p41, "Weapon");
    p41:PivotTo(v42.CFrame * u1.HOLSTER_VISUAL_OFFSET * v44);
    CollectionService:RemoveTag(PrimaryPart, "HeldWeapon");
    local v45 = InsMgr.GetIns("Weapon", "WeldConstraint", p41);
    v45.Part0 = v42;
    v45.Part1 = PrimaryPart;

    return true;
end;

function u1.MoveModelFromHolsterToHand(p46, p47) -- Line: 366
    -- upvalues: u1 (copy), VisibleMgr (copy), ATTR_WEAPON_DISPLAY (copy), ATTR_SLOT_EQUIPPED_WEAPON (copy), InsMgr (copy), CollectionService (copy)
    local v48 = p47 or u1.FindHolsteredWeapon(p46);

    if not v48 then
        return false;
    end;

    local v49 = p46:FindFirstChild("Right Weapon");

    if not (v49 and v49:IsA("BasePart")) then
        return false;
    end;

    local PrimaryPart = v48.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        return false;
    end;

    local Weapon = v48:FindFirstChild("Weapon");

    if Weapon then
        Weapon:Destroy();
    end;

    VisibleMgr.PrepareModelForAttach(v48);
    u1.ApplyWeaponSlotScale(v48, "Hand", p46);
    local v50 = u1.ComputeGripCFrame(v48, "Weapon");
    local v51 = u1.EnsureHeldFolder(p46);
    v48:PivotTo(v49.CFrame * v50);
    v48.Parent = v51;
    v48:SetAttribute(ATTR_WEAPON_DISPLAY, "Hand");
    v48:SetAttribute(ATTR_SLOT_EQUIPPED_WEAPON, true);
    v48:SetAttribute("ItemType", "Weapon");
    local v52 = InsMgr.GetIns("Weapon", "WeldConstraint", v48);
    v52.Part0 = v49;
    v52.Part1 = PrimaryPart;
    CollectionService:AddTag(PrimaryPart, "HeldWeapon");

    return true;
end;

function u1.SetCharacterAnchored(p53, p54) -- Line: 409
    for _, descendant in p53:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;

            if descendant.Name == "HumanoidRootPart" then
                descendant.Anchored = p54;
            else
                descendant.Anchored = false;
            end;
        end;
    end;

    return nil;
end;

local function _isEffectInstance(p55) -- Line: 435
    return p55:IsA("ParticleEmitter") or p55:IsA("Trail") or (p55:IsA("Beam") or p55:IsA("Light"));
end;

function u1.SetModelHiddenLocal(p56, p57) -- Line: 451
    for _, descendant in p56:GetDescendants() do
        if descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
            if p57 then
                if descendant:GetAttribute("_HeldItemPrevTransparency") == nil then
                    descendant:SetAttribute("_HeldItemPrevTransparency", descendant.Transparency);
                end;

                descendant.Transparency = 1;
            else
                local v58 = descendant:GetAttribute("_HeldItemPrevTransparency");

                if typeof(v58) == "number" then
                    descendant.Transparency = v58;
                    descendant:SetAttribute("_HeldItemPrevTransparency", nil);
                end;
            end;
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or (descendant:IsA("Beam") or descendant:IsA("Light")) then
            if p57 then
                if descendant:GetAttribute("_HeldItemPrevEnabled") == nil then
                    descendant:SetAttribute("_HeldItemPrevEnabled", descendant.Enabled);
                end;

                descendant.Enabled = false;

                if descendant:IsA("ParticleEmitter") then
                    descendant:Clear();
                end;
            else
                local v59 = descendant:GetAttribute("_HeldItemPrevEnabled");

                if typeof(v59) == "boolean" then
                    descendant.Enabled = v59;
                    descendant:SetAttribute("_HeldItemPrevEnabled", nil);
                end;
            end;
        end;
    end;

    return nil;
end;

return u1;