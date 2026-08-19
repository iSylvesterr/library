-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ArmorModelUtil = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).ArmorModelUtil;
local u1 = {};
local u2 = { "Left Arm", "Right Arm" };
local u3 = { "Left Shoulder", "Right Shoulder" };
local u4 = { "Left Weapon", "Right Weapon" };
local u5 = { {
        sizeX = "CharMorph_ArmSnap_1_SizeX",
        sizeY = "CharMorph_ArmSnap_1_SizeY",
        sizeZ = "CharMorph_ArmSnap_1_SizeZ",
        c1 = "CharMorph_ArmSnap_1_C1",
        weaponC0 = "CharMorph_ArmSnap_1_WeaponC0"
    }, {
        sizeX = "CharMorph_ArmSnap_2_SizeX",
        sizeY = "CharMorph_ArmSnap_2_SizeY",
        sizeZ = "CharMorph_ArmSnap_2_SizeZ",
        c1 = "CharMorph_ArmSnap_2_C1",
        weaponC0 = "CharMorph_ArmSnap_2_WeaponC0"
    } };

local function _getArmModelScale(p6) -- Line: 91
    local Parent = p6.Parent;

    if Parent and Parent:IsA("Model") then
        local v7 = Parent:GetScale();

        if type(v7) == "number" and v7 > 1e-6 then
            return v7;
        end;
    end;

    return 1;
end;

local function _cframeToUnscaled(p8, p9) -- Line: 109
    if p9 <= 1e-6 or math.abs(p9 - 1) < 1e-6 then
        return p8;
    end;

    return CFrame.new(p8.Position / p9) * p8.Rotation;
end;

local function _cframeFromUnscaled(p10, p11) -- Line: 123
    if p11 <= 1e-6 or math.abs(p11 - 1) < 1e-6 then
        return p10;
    end;

    return CFrame.new(p10.Position * p11) * p10.Rotation;
end;

local function _findArmMotor(p12, p13) -- Line: 137
    local v14 = p12:FindFirstChild(p13);

    if v14 and v14:IsA("Motor6D") then
        return v14;
    end;

    return nil;
end;

local function _saveSnapshot(p15, p16, p17, p18) -- Line: 155
    if p15:GetAttribute(p17.sizeY) ~= nil then
        return;
    end;

    local Parent = p15.Parent;
    local v19;

    if Parent and Parent:IsA("Model") then
        local v20 = Parent:GetScale();
        v19 = (type(v20) ~= "number" or v20 <= 1e-6) and 1 or v20;
    else
        v19 = 1;
    end;

    p15:SetAttribute(p17.sizeX, p15.Size.X / v19);
    p15:SetAttribute(p17.sizeY, p15.Size.Y / v19);
    p15:SetAttribute(p17.sizeZ, p15.Size.Z / v19);
    local c1 = p17.c1;
    local C1 = p16.C1;

    if v19 > 1e-6 and math.abs(v19 - 1) >= 1e-6 then
        C1 = CFrame.new(C1.Position / v19) * C1.Rotation;
    end;

    p15:SetAttribute(c1, C1);

    if p18 then
        local weaponC0 = p17.weaponC0;
        local C0 = p18.C0;

        if v19 > 1e-6 and math.abs(v19 - 1) >= 1e-6 then
            C0 = CFrame.new(C0.Position / v19) * C0.Rotation;
        end;

        p15:SetAttribute(weaponC0, C0);
    end;
end;

local function _loadSnapshot(p21, p22) -- Line: 180
    local v23 = p21:GetAttribute(p22.sizeX);
    local v24 = p21:GetAttribute(p22.sizeY);
    local v25 = p21:GetAttribute(p22.sizeZ);
    local v26 = p21:GetAttribute(p22.c1);

    if type(v23) == "number" and (type(v24) == "number" and (type(v25) == "number" and typeof(v26) == "CFrame")) then
        local v27 = p21:GetAttribute(p22.weaponC0);

        if typeof(v27) == "CFrame" then
            return v23, v24, v25, v26, v27;
        end;

        return v23, v24, v25, v26, nil;
    end;

    if type(v24) ~= "number" or typeof(v26) ~= "CFrame" then
        return nil, nil, nil, nil, nil;
    end;

    local Parent = p21.Parent;
    local v28;

    if Parent and Parent:IsA("Model") then
        local v29 = Parent:GetScale();
        v28 = (type(v29) ~= "number" or v29 <= 1e-6) and 1 or v29;
    else
        v28 = 1;
    end;

    local v30 = p21:GetAttribute(p22.weaponC0);
    local v31 = p21.Size.X / v28;
    local v32 = p21.Size.Z / v28;

    if typeof(v30) == "CFrame" then
        return v31, v24, v32, v26, v30;
    end;

    return v31, v24, v32, v26, nil;
end;

local function _clearSnapshot(p33, p34) -- Line: 204
    p33:SetAttribute(p34.sizeX, nil);
    p33:SetAttribute(p34.sizeY, nil);
    p33:SetAttribute(p34.sizeZ, nil);
    p33:SetAttribute(p34.c1, nil);
    p33:SetAttribute(p34.weaponC0, nil);
end;

local function _findRobeArmModel(p35, p36) -- Line: 219
    -- upvalues: u2 (copy)
    local Robe = p35:FindFirstChild("Robe");

    if not (Robe and Robe:IsA("Folder")) then
        return nil;
    end;

    local v37 = Robe:FindFirstChild(u2[p36]);

    if v37 and v37:IsA("Model") then
        return v37;
    end;

    return nil;
end;

local function _findArmorWeld(p38) -- Line: 238
    local ArmorWeld = p38:FindFirstChild("ArmorWeld");

    if not (ArmorWeld and ArmorWeld:IsA("WeldConstraint")) then
        return nil, nil;
    end;

    local Part0 = ArmorWeld.Part0;

    if Part0 and Part0:IsA("BasePart") then
        return ArmorWeld, Part0;
    end;

    return nil, nil;
end;

local function _alignRobeArmToShoulder(p39, p40) -- Line: 257
    local ArmorWeld = p39:FindFirstChild("ArmorWeld");
    local v41;

    if ArmorWeld and ArmorWeld:IsA("WeldConstraint") then
        v41 = ArmorWeld.Part0;

        if not (v41 and v41:IsA("BasePart")) then
            ArmorWeld = nil;
            v41 = nil;
        end;
    else
        ArmorWeld = nil;
        v41 = nil;
    end;

    if not (ArmorWeld and v41) then
        return;
    end;

    local PrimaryPart = p39.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        PrimaryPart = ArmorWeld.Part1;

        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            return;
        end;
    end;

    if PrimaryPart:GetAttribute("CharMorph_RobeOrigWeldOff") == nil then
        PrimaryPart:SetAttribute("CharMorph_RobeOrigWeldOff", v41.CFrame:Inverse() * PrimaryPart.CFrame);
    end;

    local v42 = p40 / 2 - PrimaryPart.Size.Y / 2;
    ArmorWeld.Part1 = nil;
    PrimaryPart.CFrame = v41.CFrame * CFrame.new(0, v42, 0);
    ArmorWeld.Part1 = PrimaryPart;
end;

local function _restoreRobeArmPos(p43) -- Line: 289
    local ArmorWeld = p43:FindFirstChild("ArmorWeld");
    local v44;

    if ArmorWeld and ArmorWeld:IsA("WeldConstraint") then
        v44 = ArmorWeld.Part0;

        if not (v44 and v44:IsA("BasePart")) then
            ArmorWeld = nil;
            v44 = nil;
        end;
    else
        ArmorWeld = nil;
        v44 = nil;
    end;

    if not (ArmorWeld and v44) then
        return;
    end;

    local PrimaryPart = p43.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        PrimaryPart = ArmorWeld.Part1;

        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            return;
        end;
    end;

    local v45 = PrimaryPart:GetAttribute("CharMorph_RobeOrigWeldOff");

    if typeof(v45) ~= "CFrame" then
        return;
    end;

    ArmorWeld.Part1 = nil;
    PrimaryPart.CFrame = v44.CFrame * v45;
    ArmorWeld.Part1 = PrimaryPart;
    PrimaryPart:SetAttribute("CharMorph_RobeOrigWeldOff", nil);
end;

local u46 = setmetatable({}, {
    __mode = "k"
});

local function _cancelArmMorphTweens(p47) -- Line: 325
    -- upvalues: u46 (copy)
    local v48 = u46[p47];

    if not v48 then
        return;
    end;

    u46[p47] = nil;

    for _, v in v48 do
        pcall(function() -- Line: 332
            -- upvalues: v (copy)
            v:Cancel();
            v:Destroy();
        end);
    end;
end;

local function _playArmMorphTween(p49, p50, p51, p52) -- Line: 348
    -- upvalues: TweenService (copy), u46 (copy)
    local u53 = TweenService:Create(p50, p51, p52);
    local v54 = u46[p49];

    if not v54 then
        v54 = {};
        u46[p49] = v54;
    end;

    table.insert(v54, u53);
    u53.Completed:Once(function() -- Line: 356
        -- upvalues: u53 (copy)
        pcall(function() -- Line: 357
            -- upvalues: u53 (ref)
            u53:Destroy();
        end);
    end);
    u53:Play();
end;

function u1.StretchArms(p55, p56, p57) -- Line: 377
    -- upvalues: _cancelArmMorphTweens (copy), u2 (copy), u3 (copy), u5 (copy), u4 (copy), _saveSnapshot (copy), _loadSnapshot (copy), _playArmMorphTween (copy), _alignRobeArmToShoulder (copy)
    if not p55 then
        return;
    end;

    local Torso = p55:FindFirstChild("Torso");

    if not Torso then
        return;
    end;

    if type(p56) ~= "number" or p56 <= 0 then
        return;
    end;

    _cancelArmMorphTweens(p55);
    local v58 = math.max(p56, 0.01);
    local v59 = 1 / math.sqrt(v58);
    local v60 = p57 > 0;
    local v61;

    if v60 then
        v61 = TweenInfo.new(p57, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    else
        v61 = nil;
    end;

    for i, v in u2 do
        local v62 = p55:FindFirstChild(v);

        if v62 and v62:IsA("BasePart") then
            local v63 = Torso:FindFirstChild(u3[i]);

            if not (v63 and v63:IsA("Motor6D")) then
                v63 = nil;
            end;

            if v63 then
                local v64 = u5[i];
                local v65 = nil;
                local v66 = Torso:FindFirstChild(u4[i]);

                if v66 then
                    if not v66:IsA("Motor6D") then
                        v66 = v65;
                    end;
                else
                    v66 = v65;
                end;

                _saveSnapshot(v62, v63, v64, v66);
                local v67, v68, v69, v70 = _loadSnapshot(v62, v64);
                local Parent = v62.Parent;
                local v71;

                if Parent and Parent:IsA("Model") then
                    local v72 = Parent:GetScale();
                    v71 = (type(v72) ~= "number" or v72 <= 1e-6) and 1 or v72;
                else
                    v71 = 1;
                end;

                local v73, v74, v75;

                if v67 and (v68 and v69) then
                    v73 = v67 * v71;
                    v74 = v68 * v71;
                    v75 = v69 * v71;
                else
                    v73 = v62.Size.X;
                    v74 = v62.Size.Y;
                    v75 = v62.Size.Z;
                end;

                local v76 = v74 * v58;

                if typeof(v70) == "CFrame" then
                    if v71 > 1e-6 and math.abs(v71 - 1) >= 1e-6 then
                        v70 = CFrame.new(v70.Position * v71) * v70.Rotation;
                    end;
                else
                    v70 = v63.C1;
                end;

                local v77 = CFrame.new(0, (v76 - v74) * 0.5, 0) * v70;
                local v78;

                if v66 then
                    v78 = CFrame.new(0, -v76 / 2, 0);
                else
                    v78 = nil;
                end;

                local v79 = Vector3.new(v73 * v59, v76, v75 * v59);

                if v60 and v61 then
                    _playArmMorphTween(p55, v62, v61, {
                        Size = v79
                    });
                    _playArmMorphTween(p55, v63, v61, {
                        C1 = v77
                    });

                    if v66 and v78 then
                        _playArmMorphTween(p55, v66, v61, {
                            C0 = v78
                        });
                    end;
                else
                    v62.Size = v79;
                    v63.C1 = v77;

                    if v66 and v78 then
                        v66.C0 = v78;
                    end;
                end;

                local Robe = p55:FindFirstChild("Robe");
                local v80;

                if Robe and Robe:IsA("Folder") then
                    v80 = Robe:FindFirstChild(u2[i]);

                    if not (v80 and v80:IsA("Model")) then
                        v80 = nil;
                    end;
                else
                    v80 = nil;
                end;

                if v80 then
                    _alignRobeArmToShoulder(v80, v76);
                end;
            end;
        else
            warn("[CharacterMorphUtil] 找不到手臂:", v);
        end;
    end;
end;

local function _doRestoreArms(p81) -- Line: 484
    -- upvalues: _cancelArmMorphTweens (copy), u2 (copy), u5 (copy), _loadSnapshot (copy), u3 (copy), u4 (copy), _restoreRobeArmPos (copy), _clearSnapshot (copy)
    _cancelArmMorphTweens(p81);
    local Torso = p81:FindFirstChild("Torso");

    if not Torso then
        return;
    end;

    local v82 = p81:GetScale();
    local v83 = (type(v82) ~= "number" or v82 <= 1e-6) and 1 or v82;

    for i, v in u2 do
        local v84 = p81:FindFirstChild(v);

        if v84 and v84:IsA("BasePart") then
            local v85 = u5[i];
            local v86, v87, v88, v89, v90 = _loadSnapshot(v84, v85);

            if v86 and (v87 and (v88 and v89)) then
                local v91 = Torso:FindFirstChild(u3[i]);

                if not (v91 and v91:IsA("Motor6D")) then
                    v91 = nil;
                end;

                if v91 then
                    v84.Size = Vector3.new(v86 * v83, v87 * v83, v88 * v83);

                    if v83 > 1e-6 and math.abs(v83 - 1) >= 1e-6 then
                        v89 = CFrame.new(v89.Position * v83) * v89.Rotation;
                    end;

                    v91.C1 = v89;
                end;

                if v90 then
                    local v92 = Torso:FindFirstChild(u4[i]);

                    if v92 and v92:IsA("Motor6D") then
                        if v83 > 1e-6 and math.abs(v83 - 1) >= 1e-6 then
                            v90 = CFrame.new(v90.Position * v83) * v90.Rotation;
                        end;

                        v92.C0 = v90;
                    end;
                end;

                local Robe = p81:FindFirstChild("Robe");
                local v93;

                if Robe and Robe:IsA("Folder") then
                    v93 = Robe:FindFirstChild(u2[i]);

                    if not (v93 and v93:IsA("Model")) then
                        v93 = nil;
                    end;
                else
                    v93 = nil;
                end;

                if v93 then
                    _restoreRobeArmPos(v93);
                end;

                _clearSnapshot(v84, v85);
            end;
        end;
    end;
end;

function u1.RestoreArms(p94) -- Line: 537
    -- upvalues: _cancelArmMorphTweens (copy), _doRestoreArms (copy)
    if not p94 then
        return false;
    end;

    _cancelArmMorphTweens(p94);

    if p94:GetAttribute("CharMorph_OrigBodyScale") ~= nil then
        p94:SetAttribute("CharMorph_PendingRestoreArms", true);

        return false;
    end;

    _doRestoreArms(p94);
    p94:SetAttribute("CharMorph_PendingRestoreArms", nil);

    return true;
end;

function u1.SyncRobeArmsToStretch(p95) -- Line: 559
    -- upvalues: u2 (copy), _loadSnapshot (copy), u5 (copy), _alignRobeArmToShoulder (copy)
    if not p95 then
        return;
    end;

    for i, v in u2 do
        local v96 = p95:FindFirstChild(v);

        if v96 and v96:IsA("BasePart") then
            local _, v97 = _loadSnapshot(v96, u5[i]);

            if v97 then
                local Robe = p95:FindFirstChild("Robe");
                local v98;

                if Robe and Robe:IsA("Folder") then
                    v98 = Robe:FindFirstChild(u2[i]);

                    if not (v98 and v98:IsA("Model")) then
                        v98 = nil;
                    end;
                else
                    v98 = nil;
                end;

                if v98 then
                    _alignRobeArmToShoulder(v98, v96.Size.Y);
                end;
            end;
        end;
    end;
end;

local u99 = setmetatable({}, {
    __mode = "k"
});
local u100 = {};
local u101 = {};
local u102 = {};
local v103 = false;

local function _bumpBodyScaleGen(p104) -- Line: 600
    -- upvalues: u99 (copy)
    local v105 = (u99[p104] or 0) + 1;
    u99[p104] = v105;

    return v105;
end;

local function _isBodyScaleGenCurrent(p106, p107) -- Line: 613
    -- upvalues: u99 (copy)
    return u99[p106] == p107;
end;

local function _findCapeModels(p108) -- Line: 622
    local v109 = {};
    local Robe = p108:FindFirstChild("Robe");

    if not Robe then
        return v109;
    end;

    for _, child in Robe:GetChildren() do
        if child:IsA("Model") and child.Name == "Cape" then
            table.insert(v109, child);
        end;
    end;

    return v109;
end;

local function _resumeCapeSmartBone(u110) -- Line: 651
    -- upvalues: ArmorModelUtil (copy)
    local PrimaryPart = u110.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        return;
    end;

    task.defer(function() -- Line: 656
        -- upvalues: u110 (copy), ArmorModelUtil (ref)
        if not (u110 and u110.Parent) then
            return;
        end;

        for _, descendant in u110:GetDescendants() do
            if descendant:IsA("Bone") then
                descendant.Transform = CFrame.Angles(0, 0, 0.001);
            end;
        end;

        task.defer(function() -- Line: 665
            -- upvalues: u110 (ref), ArmorModelUtil (ref)
            if not (u110 and u110.Parent) then
                return;
            end;

            for _, descendant in u110:GetDescendants() do
                if descendant:IsA("Bone") then
                    descendant.Transform = CFrame.identity;
                end;
            end;

            local PrimaryPart2 = u110.PrimaryPart;

            if PrimaryPart2 and (PrimaryPart2:IsA("BasePart") and not PrimaryPart2:HasTag("SmartBone")) then
                ArmorModelUtil.ApplyCapeSmartBoneAttrs(PrimaryPart2);
            end;
        end);
    end);
end;

local function _getFeetBottomY(u111) -- Line: 687
    local v112, v113, v114 = pcall(function() -- Line: 688
        -- upvalues: u111 (copy)
        return u111:GetBoundingBox();
    end);

    if v112 and (typeof(v113) == "CFrame" and typeof(v114) == "Vector3") then
        return v113.Position.Y - v114.Y * 0.5;
    end;

    local HumanoidRootPart = u111:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position.Y - HumanoidRootPart.Size.Y * 0.5;
    end;

    return nil;
end;

local function _isPlayerCharacter(p115) -- Line: 706
    -- upvalues: Players (copy)
    return Players:GetPlayerFromCharacter(p115) ~= nil;
end;

local function _parkBillboardGuis(p116) -- Line: 716
    local v117 = {};

    for _, descendant in p116:GetDescendants() do
        if descendant:IsA("BillboardGui") then
            local Parent = descendant.Parent;

            if Parent then
                table.insert(v117, {
                    gui = descendant,
                    parent = Parent,
                    size = descendant.Size,
                    studsOffset = descendant.StudsOffset,
                    studsOffsetWorldSpace = descendant.StudsOffsetWorldSpace,
                    maxDistance = descendant.MaxDistance
                });
                descendant.Parent = nil;
            end;
        end;
    end;

    return v117;
end;

local function _unparkBillboardGuis(p118) -- Line: 743
    for _, v in ipairs(p118) do
        local gui = v.gui;

        if gui and gui.Parent == nil then
            local parent = v.parent;

            if parent and parent.Parent then
                gui.Size = v.size;
                gui.StudsOffset = v.studsOffset;
                gui.StudsOffsetWorldSpace = v.studsOffsetWorldSpace;
                gui.MaxDistance = v.maxDistance;
                gui.Parent = parent;
            else
                gui:Destroy();
            end;
        end;
    end;
end;

local function _scaleToPreserveBillboards(p119, p120) -- Line: 768
    -- upvalues: _parkBillboardGuis (copy), _unparkBillboardGuis (copy)
    local v121 = _parkBillboardGuis(p119);
    p119:ScaleTo(p120);
    _unparkBillboardGuis(v121);
end;

local function _scaleToKeepFeet(p122, p123, p124) -- Line: 780
    -- upvalues: _parkBillboardGuis (copy), _unparkBillboardGuis (copy), _getFeetBottomY (copy)
    local v125 = _parkBillboardGuis(p122);
    p122:ScaleTo(p123);
    _unparkBillboardGuis(v125);
    local v126 = _getFeetBottomY(p122);

    if v126 then
        local v127 = p124 - v126;

        if math.abs(v127) > 0.0001 then
            p122:PivotTo(p122:GetPivot() + Vector3.new(0, v127, 0));
        end;
    end;

    local HumanoidRootPart = p122:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;
end;

local function _clearVisualScaleAttr(p128) -- Line: 801
    if p128 and p128.Parent then
        p128:SetAttribute("CharMorph_VisualScale", nil);
    end;
end;

local function _applyScaleDeltaLift(p129, p130, p131) -- Line: 813
    if p131 <= p130 + 0.00001 or p130 <= 0.00001 then
        return;
    end;

    local HumanoidRootPart = p129:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local v132 = p131 / p130;
    local v133 = p129:FindFirstChildOfClass("Humanoid");
    local v134 = not v133 and 0 or v133.HipHeight;
    local v135;

    if v134 >= 0.05 then
        v135 = v134 * (1 - 1 / v132);
    else
        v135 = p129:GetExtentsSize().Y * 0.5 * (1 - 1 / v132);
    end;

    if v135 > 0.0001 then
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, v135, 0);
    end;

    local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;

    if AssemblyLinearVelocity.Y > 0 then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
    end;
end;

local function _applyVisualScaleOnClient(p136) -- Line: 843
    -- upvalues: Players (copy), u100 (copy), _parkBillboardGuis (copy), _unparkBillboardGuis (copy), _applyScaleDeltaLift (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer or p136 ~= LocalPlayer.Character then
        return;
    end;

    local v137 = p136:GetAttribute("CharMorph_VisualScale");

    if type(v137) ~= "number" then
        u100[p136] = nil;

        return;
    end;

    local v138 = u100[p136];

    if type(v138) ~= "number" then
        v138 = p136:GetScale();
    end;

    local v139 = p136:GetScale() - v137;

    if math.abs(v139) > 0.00001 then
        local v140 = _parkBillboardGuis(p136);
        p136:ScaleTo(v137);
        _unparkBillboardGuis(v140);
    end;

    _applyScaleDeltaLift(p136, v138, v137);
    u100[p136] = v137;
end;

local function _unbindCharacterScaleWatch(p141) -- Line: 872
    -- upvalues: u101 (copy), u100 (copy)
    local v142 = u101[p141];

    if v142 then
        v142:Disconnect();
        u101[p141] = nil;
    end;

    u100[p141] = nil;
end;

local function _bindCharacterScaleWatch(u143) -- Line: 885
    -- upvalues: u101 (copy), u100 (copy), _applyVisualScaleOnClient (copy)
    local v144 = u101[u143];

    if v144 then
        v144:Disconnect();
        u101[u143] = nil;
    end;

    u100[u143] = nil;
    u101[u143] = u143:GetAttributeChangedSignal("CharMorph_VisualScale"):Connect(function() -- Line: 887
        -- upvalues: _applyVisualScaleOnClient (ref), u143 (copy)
        _applyVisualScaleOnClient(u143);
    end);

    if type(u143:GetAttribute("CharMorph_VisualScale")) == "number" then
        _applyVisualScaleOnClient(u143);
    end;
end;

function u1.ScaleBody(u145, p146, u147) -- Line: 905
    -- upvalues: u99 (copy), Players (copy), _getFeetBottomY (copy), _findCapeModels (copy), ArmorModelUtil (copy), _parkBillboardGuis (copy), _unparkBillboardGuis (copy), _scaleToKeepFeet (copy), TweenService (copy)
    if not (u145 and u145:IsA("Model")) then
        return;
    end;

    if type(p146) ~= "number" or p146 <= 0 then
        return;
    end;

    local u148 = (u99[u145] or 0) + 1;
    u99[u145] = u148;
    local u149 = u145:GetScale();

    if u145:GetAttribute("CharMorph_OrigBodyScale") == nil then
        u145:SetAttribute("CharMorph_OrigBodyScale", u149);
    end;

    local u150 = u145:GetAttribute("CharMorph_OrigBodyScale");

    if type(u150) ~= "number" or u150 <= 0 then
        return;
    end;

    local u151 = u150 * p146;
    local u152 = Players:GetPlayerFromCharacter(u145) ~= nil;
    local u153 = u152 and 0 or (_getFeetBottomY(u145) or u145:GetPivot().Position.Y);
    local u154 = _findCapeModels(u145);

    for _, v in u154 do
        ArmorModelUtil.StripCapeSmartBone(v);
    end;

    local function _finishScale() -- Line: 937
        -- upvalues: u145 (copy), u148 (copy), u99 (ref), u150 (copy), u152 (copy), u151 (copy), _parkBillboardGuis (ref), _unparkBillboardGuis (ref), u154 (copy), ArmorModelUtil (ref)
        if u148 ~= u99[u145] then
            return;
        end;

        if u145:GetAttribute("CharMorph_OrigBodyScale") ~= u150 then
            return;
        end;

        if u152 and u145.Parent then
            local v155 = u145;
            local v156 = _parkBillboardGuis(v155);
            v155:ScaleTo(u151);
            _unparkBillboardGuis(v156);
        end;

        local v157 = u145;

        if v157 and v157.Parent then
            v157:SetAttribute("CharMorph_VisualScale", nil);
        end;

        for _, v in u154 do
            if v and v.Parent then
                local PrimaryPart = v.PrimaryPart;

                if PrimaryPart then
                    if PrimaryPart:IsA("BasePart") then
                        task.defer(function() -- Line: 656
                            -- upvalues: v (copy), ArmorModelUtil (ref)
                            if not (v and v.Parent) then
                                return;
                            end;

                            for _, descendant in v:GetDescendants() do
                                if descendant:IsA("Bone") then
                                    descendant.Transform = CFrame.Angles(0, 0, 0.001);
                                end;
                            end;

                            task.defer(function() -- Line: 665
                                -- upvalues: v (ref), ArmorModelUtil (ref)
                                if not (v and v.Parent) then
                                    return;
                                end;

                                for _, descendant in v:GetDescendants() do
                                    if descendant:IsA("Bone") then
                                        descendant.Transform = CFrame.identity;
                                    end;
                                end;

                                local PrimaryPart2 = v.PrimaryPart;

                                if PrimaryPart2 and (PrimaryPart2:IsA("BasePart") and not PrimaryPart2:HasTag("SmartBone")) then
                                    ArmorModelUtil.ApplyCapeSmartBoneAttrs(PrimaryPart2);
                                end;
                            end);
                        end);
                    end;
                end;
            end;
        end;
    end;

    if u147 <= 0 then
        if u152 then
            u145:SetAttribute("CharMorph_VisualScale", u151);
        else
            _scaleToKeepFeet(u145, u151, u153);
        end;

        _finishScale();

        return;
    end;

    if u152 then
        u145:SetAttribute("CharMorph_VisualScale", u149);
    end;

    task.spawn(function() -- Line: 970
        -- upvalues: u147 (copy), u145 (copy), u148 (copy), u99 (ref), TweenService (ref), u149 (copy), u151 (copy), u152 (copy), _scaleToKeepFeet (ref), u153 (ref), _finishScale (copy)
        local v158 = 0;

        while v158 < u147 do
            local v159 = v158 + task.wait(0.03333333333333333);
            v158 = math.min(v159, u147);

            if u148 ~= u99[u145] then
                return;
            end;

            if not (u145 and u145.Parent) then
                local v160 = u145;

                if v160 and v160.Parent then
                    v160:SetAttribute("CharMorph_VisualScale", nil);
                end;

                return;
            end;

            local v161 = TweenService:GetValue(v158 / u147, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            local v162 = u149 + (u151 - u149) * v161;

            if u152 then
                u145:SetAttribute("CharMorph_VisualScale", v162);
            else
                _scaleToKeepFeet(u145, v162, u153);
            end;
        end;

        _finishScale();
    end);
end;

function u1.RestoreBody(u163, u164) -- Line: 1004
    -- upvalues: u99 (copy), _doRestoreArms (copy), Players (copy), _parkBillboardGuis (copy), _unparkBillboardGuis (copy), _getFeetBottomY (copy), _scaleToKeepFeet (copy)
    if not (u163 and u163:IsA("Model")) then
        return;
    end;

    local v165 = u163:GetAttribute("CharMorph_OrigBodyScale");

    if type(v165) ~= "number" then
        return;
    end;

    local u166 = (u99[u163] or 0) + 1;
    u99[u163] = u166;

    local function _flushPendingRestoreArms() -- Line: 1016
        -- upvalues: u163 (copy), _doRestoreArms (ref)
        if u163:GetAttribute("CharMorph_PendingRestoreArms") then
            _doRestoreArms(u163);
            u163:SetAttribute("CharMorph_PendingRestoreArms", nil);
        end;
    end;

    local function _invokeAligned() -- Line: 1023
        -- upvalues: u163 (copy), u164 (copy)
        local v167 = u163;

        if v167 and v167.Parent then
            v167:SetAttribute("CharMorph_VisualScale", nil);
        end;

        if u164 then
            u164();
        end;
    end;

    u163:SetAttribute("CharMorph_OrigBodyScale", nil);

    if Players:GetPlayerFromCharacter(u163) == nil then
        _scaleToKeepFeet(u163, v165, _getFeetBottomY(u163) or u163:GetPivot().Position.Y);

        if u163:GetAttribute("CharMorph_PendingRestoreArms") then
            _doRestoreArms(u163);
            u163:SetAttribute("CharMorph_PendingRestoreArms", nil);
        end;

        if u163 and u163.Parent then
            u163:SetAttribute("CharMorph_VisualScale", nil);
        end;

        if u164 then
            u164();
        end;

        return;
    end;

    u163:SetAttribute("CharMorph_VisualScale", v165);
    local v168 = _parkBillboardGuis(u163);
    u163:ScaleTo(v165);
    _unparkBillboardGuis(v168);

    if u163:GetAttribute("CharMorph_PendingRestoreArms") then
        _doRestoreArms(u163);
        u163:SetAttribute("CharMorph_PendingRestoreArms", nil);
    end;

    task.delay(0.15, function() -- Line: 1037
        -- upvalues: u163 (copy), u166 (copy), u99 (ref), u164 (copy)
        if u166 ~= u99[u163] then
            return;
        end;

        if not u163.Parent then
            return;
        end;

        local v169 = u163;

        if v169 and v169.Parent then
            v169:SetAttribute("CharMorph_VisualScale", nil);
        end;

        if u164 then
            u164();
        end;
    end);
end;

function u1.IsBodyScaled(p170) -- Line: 1060
    if p170 then
        return p170:GetAttribute("CharMorph_OrigBodyScale") ~= nil and true or type(p170:GetAttribute("CharMorph_VisualScale")) == "number";
    end;

    return false;
end;

function u1.GetBodyScaleMul(p171) -- Line: 1075
    if not p171 then
        return 1;
    end;

    local v172 = p171:GetAttribute("CharMorph_OrigBodyScale");

    if type(v172) ~= "number" or v172 <= 0 then
        return 1;
    end;

    local v173 = p171:GetAttribute("CharMorph_VisualScale");

    if type(v173) ~= "number" then
        v173 = p171:GetScale();
    end;

    return (type(v173) ~= "number" or v173 <= 0) and 1 or v173 / v172;
end;

function u1.SyncCapeToScale(p174) -- Line: 1097
    -- upvalues: u1 (copy), _findCapeModels (copy), ArmorModelUtil (copy)
    if not (p174 and u1.IsBodyScaled(p174)) then
        return;
    end;

    for _, v in _findCapeModels(p174) do
        ArmorModelUtil.StripCapeSmartBone(v);
        local PrimaryPart = v.PrimaryPart;

        if PrimaryPart then
            if PrimaryPart:IsA("BasePart") then
                task.defer(function() -- Line: 656
                    -- upvalues: v (copy), ArmorModelUtil (ref)
                    if not (v and v.Parent) then
                        return;
                    end;

                    for _, descendant in v:GetDescendants() do
                        if descendant:IsA("Bone") then
                            descendant.Transform = CFrame.Angles(0, 0, 0.001);
                        end;
                    end;

                    task.defer(function() -- Line: 665
                        -- upvalues: v (ref), ArmorModelUtil (ref)
                        if not (v and v.Parent) then
                            return;
                        end;

                        for _, descendant in v:GetDescendants() do
                            if descendant:IsA("Bone") then
                                descendant.Transform = CFrame.identity;
                            end;
                        end;

                        local PrimaryPart2 = v.PrimaryPart;

                        if PrimaryPart2 and (PrimaryPart2:IsA("BasePart") and not PrimaryPart2:HasTag("SmartBone")) then
                            ArmorModelUtil.ApplyCapeSmartBoneAttrs(PrimaryPart2);
                        end;
                    end);
                end);
            end;
        end;
    end;
end;

if RunService:IsClient() then
    local function _hookLocalPlayer() -- Line: 1110
        -- upvalues: Players (copy), u102 (copy), _bindCharacterScaleWatch (copy)
        local LocalPlayer = Players.LocalPlayer;

        if not LocalPlayer then
            return;
        end;

        local v175 = u102[LocalPlayer];

        if v175 then
            v175:Disconnect();
            u102[LocalPlayer] = nil;
        end;

        u102[LocalPlayer] = LocalPlayer.CharacterAdded:Connect(_bindCharacterScaleWatch);

        if LocalPlayer.Character then
            _bindCharacterScaleWatch(LocalPlayer.Character);
        end;
    end;

    if not v103 then
        local LocalPlayer = Players.LocalPlayer;

        if not LocalPlayer then
            return u1;
        end;

        local v176 = u102[LocalPlayer];

        if v176 then
            v176:Disconnect();
            u102[LocalPlayer] = nil;
        end;

        u102[LocalPlayer] = LocalPlayer.CharacterAdded:Connect(_bindCharacterScaleWatch);

        if LocalPlayer.Character then
            _bindCharacterScaleWatch(LocalPlayer.Character);
        end;
    end;
end;

return u1;