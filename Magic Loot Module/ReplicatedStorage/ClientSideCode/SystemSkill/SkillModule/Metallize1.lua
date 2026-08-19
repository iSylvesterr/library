-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local HumanModule = UtilsSystem.HumanModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local SkillActionLock = require(script.Parent.Parent.BaseSkill.SkillActionLock);
local SystemPlrAttr = UtilsSystem.SystemPlrAttr;
local GetData = UtilsSystem.GetData;
local VisibleMgr = UtilsSystem.VisibleMgr;
local FXUtil = UtilsSystem.FXUtil;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 0.2,
    skillElementType = ElementTp.None,
    skillDistanceLimit = 0,
    InitialState = "Metallized",
    ControlOpenState = "Recovery",
    States = {
        Metallized = {
            Duration = -1,
            OnEnterClient = "Client_EnterMetallized",
            OnEnterServer = "Server_EnterMetallized",
            OnExitClient = "Client_ExitMetallized",
            OnExitServer = "Server_ExitMetallized"
        },
        Recovery = {
            Duration = 0.1,
            OnEnterClient = "Client_EnterRecovery",
            OnEnterServer = "Server_EnterRecovery",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Finished = {
            Duration = 0,
            IsTerminal = true
        },
        Interrupted = {
            Duration = 0,
            IsTerminal = true
        }
    },
    Transitions = {
        {
            From = "Metallized",
            To = "Recovery",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Metallized",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        }
    }
};

local function isUnderEquippedTool(p2) -- Line: 115
    while p2 and p2 ~= p2.Parent do
        if p2:IsA("Tool") then
            return true;
        end;

        p2 = p2.Parent;
    end;

    return false;
end;

local function isLocalPlayerCaster(p3) -- Line: 127
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return false;
    end;

    local v4;

    if p3.characterType == "Player" then
        v4 = p3.characterId == LocalPlayer.UserId;
    else
        v4 = false;
    end;

    return v4;
end;

local function resolveMetalTemplateMesh(p5) -- Line: 136
    if not p5 then
        return nil;
    end;

    if p5:IsA("MeshPart") then
        return p5;
    end;

    local v6 = p5:FindFirstChild("R6:Rig6");

    if v6 and v6:IsA("MeshPart") then
        return v6;
    end;

    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("MeshPart") then
            return descendant;
        end;
    end;

    return nil;
end;

local function readMaterialVariant(u7) -- Line: 156
    local success, result = pcall(function() -- Line: 157
        -- upvalues: u7 (copy)
        return u7.MaterialVariant;
    end);

    return (not success or type(result) ~= "string") and "" or result;
end;

local function writeMaterialVariant(u8, u9) -- Line: 167
    pcall(function() -- Line: 168
        -- upvalues: u8 (copy), u9 (copy)
        u8.MaterialVariant = u9;
    end);
end;

local function applyTemplateAppearanceToPart(u10, u11) -- Line: 175
    pcall(function() -- Line: 176
        -- upvalues: u10 (copy), u11 (copy)
        u10.Material = u11.Material;
    end);
    local success, result = pcall(function() -- Line: 157
        -- upvalues: u11 (copy)
        return u11.MaterialVariant;
    end);
    local u12 = (not success or type(result) ~= "string") and "" or result;
    pcall(function() -- Line: 168
        -- upvalues: u10 (copy), u12 (copy)
        u10.MaterialVariant = u12;
    end);
    pcall(function() -- Line: 180
        -- upvalues: u10 (copy), u11 (copy)
        u10.Color = u11.Color;
    end);
    pcall(function() -- Line: 183
        -- upvalues: u10 (copy), u11 (copy)
        u10.Reflectance = u11.Reflectance;
    end);

    if u10:IsA("MeshPart") then
        pcall(function() -- Line: 187
            -- upvalues: u10 (copy), u11 (copy)
            u10.TextureID = u11.TextureID;
        end);
    end;
end;

local function applyTemplateToSpecialMesh(u13, u14) -- Line: 194
    pcall(function() -- Line: 195
        -- upvalues: u13 (copy), u14 (copy)
        u13.TextureId = u14.TextureID;
    end);
end;

local function applyMetalLookToCharacter(p15, u16, p17) -- Line: 201
    -- upvalues: isUnderEquippedTool (copy), applyTemplateAppearanceToPart (copy)
    local v18 = {};
    local v19 = {};
    local v20 = {};
    local v21 = {};
    local v22 = {};

    for _, descendant in p15:GetDescendants() do
        if not isUnderEquippedTool(descendant) then
            if descendant:IsA("BasePart") then
                local v23 = descendant:FindFirstChildOfClass("SurfaceAppearance");
                local v24;

                if v23 then
                    v24 = v23:Clone();
                    v23:Destroy();
                else
                    v24 = nil;
                end;

                local v25 = not descendant:IsA("MeshPart") and "" or descendant.TextureID;
                local v26 = {
                    material = descendant.Material
                };
                local success, result = pcall(function() -- Line: 157
                    -- upvalues: descendant (copy)
                    return descendant.MaterialVariant;
                end);
                v26.materialVariant = (not success or type(result) ~= "string") and "" or result;
                v26.color = descendant.Color;
                v26.reflectance = descendant.Reflectance;
                v26.textureId = v25;
                v26.surfaceAppearance = v24;
                v18[descendant] = v26;
                applyTemplateAppearanceToPart(descendant, u16);
            elseif descendant:IsA("SpecialMesh") then
                v19[descendant] = {
                    textureId = descendant.TextureId
                };
                pcall(function() -- Line: 195
                    -- upvalues: descendant (copy), u16 (copy)
                    descendant.TextureId = u16.TextureID;
                end);
            elseif descendant:IsA("Shirt") then
                v20[descendant] = {
                    shirtTemplate = descendant.ShirtTemplate
                };
                descendant.ShirtTemplate = "";
            elseif descendant:IsA("Pants") then
                v20[descendant] = {
                    pantsTemplate = descendant.PantsTemplate
                };
                descendant.PantsTemplate = "";
            elseif descendant:IsA("ShirtGraphic") then
                v20[descendant] = {
                    graphic = descendant.Graphic
                };
                descendant.Graphic = "";
            elseif descendant:IsA("Decal") then
                v21[descendant] = {
                    transparency = descendant.Transparency,
                    texture = descendant.Texture,
                    color3 = descendant.Color3
                };
                descendant.Transparency = 1;
            elseif descendant:IsA("Texture") then
                v22[descendant] = {
                    transparency = descendant.Transparency,
                    texture = descendant.Texture,
                    color3 = descendant.Color3
                };
                descendant.Transparency = 1;
            end;
        end;
    end;

    p17.metallizePartSnapshot = v18;
    p17.metallizeSpecialMeshSnapshot = v19;
    p17.metallizeDecalSnapshot = v21;
    p17.metallizeTextureSnapshot = v22;
    p17.metallizeClothingSnapshot = v20;
    p17.metallizeVisualApplied = true;
end;

local function restoreMetalLookFromSnapshot(p27) -- Line: 276
    if not (p27 and p27.metallizeVisualApplied) then
        return;
    end;

    local metallizePartSnapshot = p27.metallizePartSnapshot;

    if type(metallizePartSnapshot) == "table" then
        for i, v in metallizePartSnapshot do
            if i and (i.Parent and i:IsA("BasePart")) then
                i.Material = v.material;
                local materialVariant = v.materialVariant;
                pcall(function() -- Line: 168
                    -- upvalues: i (copy), materialVariant (copy)
                    i.MaterialVariant = materialVariant;
                end);
                i.Color = v.color;
                i.Reflectance = v.reflectance;

                if i:IsA("MeshPart") then
                    pcall(function() -- Line: 290
                        -- upvalues: i (copy), v (copy)
                        i.TextureID = v.textureId;
                    end);
                end;

                local v28 = i:FindFirstChildOfClass("SurfaceAppearance");

                if v28 then
                    v28:Destroy();
                end;

                if v.surfaceAppearance then
                    v.surfaceAppearance.Parent = i;
                end;
            end;
        end;
    end;

    local metallizeSpecialMeshSnapshot = p27.metallizeSpecialMeshSnapshot;

    if type(metallizeSpecialMeshSnapshot) == "table" then
        for i, v in metallizeSpecialMeshSnapshot do
            if i and (i.Parent and i:IsA("SpecialMesh")) then
                pcall(function() -- Line: 309
                    -- upvalues: i (copy), v (copy)
                    i.TextureId = v.textureId;
                end);
            end;
        end;
    end;

    local metallizeClothingSnapshot = p27.metallizeClothingSnapshot;

    if type(metallizeClothingSnapshot) == "table" then
        for i, v in metallizeClothingSnapshot do
            if i and i.Parent then
                if i:IsA("Shirt") and v.shirtTemplate ~= nil then
                    i.ShirtTemplate = v.shirtTemplate;
                elseif i:IsA("Pants") and v.pantsTemplate ~= nil then
                    i.PantsTemplate = v.pantsTemplate;
                elseif i:IsA("ShirtGraphic") and v.graphic ~= nil then
                    i.Graphic = v.graphic;
                end;
            end;
        end;
    end;

    local metallizeDecalSnapshot = p27.metallizeDecalSnapshot;

    if type(metallizeDecalSnapshot) == "table" then
        for i, v in metallizeDecalSnapshot do
            if i and (i.Parent and i:IsA("Decal")) then
                i.Transparency = v.transparency;
                i.Texture = v.texture;
                i.Color3 = v.color3;
            end;
        end;
    end;

    local metallizeTextureSnapshot = p27.metallizeTextureSnapshot;

    if type(metallizeTextureSnapshot) == "table" then
        for i, v in metallizeTextureSnapshot do
            if i and (i.Parent and i:IsA("Texture")) then
                i.Transparency = v.transparency;
                i.Texture = v.texture;
                i.Color3 = v.color3;
            end;
        end;
    end;

    p27.metallizePartSnapshot = nil;
    p27.metallizeSpecialMeshSnapshot = nil;
    p27.metallizeDecalSnapshot = nil;
    p27.metallizeTextureSnapshot = nil;
    p27.metallizeClothingSnapshot = nil;
    p27.metallizeVisualApplied = nil;
end;

local function freezePlayingAnimations(p29) -- Line: 363
    local v30 = {};
    local v31 = p29:FindFirstChildOfClass("Animator");

    if not v31 then
        return v30;
    end;

    for _, v in v31:GetPlayingAnimationTracks() do
        table.insert(v30, v);
        v:AdjustSpeed(0);
    end;

    return v30;
end;

local function releaseFrozenAnimations(p32) -- Line: 377
    if type(p32) ~= "table" then
        return;
    end;

    for _, v in p32 do
        if v and (v.Parent and v.IsPlaying) then
            v:Stop(0.08);
        end;
    end;
end;

local function resetLocomotionAfterMetallize(p33, p34) -- Line: 389
    local HumanoidRootPart = p33:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    if p34.FloorMaterial ~= Enum.Material.Air then
        p34:ChangeState(Enum.HumanoidStateType.Running);
    end;
end;

local function pauseSmartBonesInCharacter(p35) -- Line: 401
    -- upvalues: CollectionService (copy)
    local v36 = {};

    for _, descendant in p35:GetDescendants() do
        if descendant:IsA("BasePart") and CollectionService:HasTag(descendant, "SmartBone") then
            table.insert(v36, descendant);
            CollectionService:RemoveTag(descendant, "SmartBone");
        end;
    end;

    return v36;
end;

local function resumeSmartBones(p37) -- Line: 413
    -- upvalues: CollectionService (copy)
    if type(p37) ~= "table" then
        return;
    end;

    for _, v in p37 do
        if v and (v.Parent and v:IsA("BasePart")) then
            CollectionService:AddTag(v, "SmartBone");
        end;
    end;
end;

local function anchorCharacterParts(p38, p39) -- Line: 425
    -- upvalues: isUnderEquippedTool (copy)
    for _, descendant in p38:GetDescendants() do
        if descendant:IsA("BasePart") and not isUnderEquippedTool(descendant) then
            descendant.Anchored = true;
        end;
    end;

    p39.metallizeAnchored = true;
end;

local function unanchorCharacterParts(p40, p41) -- Line: 435
    -- upvalues: isUnderEquippedTool (copy), VisibleMgr (copy)
    if p40 and p40.Parent then
        for _, descendant in p40:GetDescendants() do
            if descendant:IsA("BasePart") and not isUnderEquippedTool(descendant) then
                descendant.Anchored = false;
            end;
        end;
    elseif p40 then
        VisibleMgr.UnAnchoredAll(p40);
    end;

    if p41 then
        p41.metallizeAnchored = nil;
    end;
end;

local function getSkillScale(p42) -- Line: 451
    -- upvalues: SkillCommon (copy)
    return SkillCommon.scaleBandFromData(p42, SkillCommon.bandScaleOptsFromSkillData(p42));
end;

local function getMetallizeBuffSec(p43) -- Line: 455
    -- upvalues: SkillCommon (copy)
    return SkillCommon.scaleBandFromData(p43, SkillCommon.bandScaleOptsFromSkillData(p43)) * 2;
end;

local function scheduleMetallizedTimeout(u44, p45) -- Line: 460
    -- upvalues: SkillCommon (copy), SkillEventConst (copy)
    local runGeneration = u44.runGeneration;
    task.delay(p45, function() -- Line: 462
        -- upvalues: SkillCommon (ref), u44 (copy), runGeneration (copy), SkillEventConst (ref)
        if not SkillCommon.isRunningSameGeneration(u44, runGeneration) then
            return;
        end;

        local skillRunData = u44.skillRunData;

        if not skillRunData or (not skillRunData.State or skillRunData.State.current ~= "Metallized") then
            return;
        end;

        u44:TryTransition(SkillEventConst.StateTimeout, nil);
    end);
end;

local function resolveFormationGroundCF(p46) -- Line: 476
    -- upvalues: FXUtil (copy)
    return FXUtil.GetGroundAlignedCF(p46.Position, p46.CFrame.LookVector, "Ground", 3, 0.1) or CFrame.new(p46.Position + Vector3.new(0, 0.1, 0));
end;

local function resolveHaloPivotCF(p47) -- Line: 482
    local v48 = p47:GetPivot();

    return CFrame.new(v48.Position + Vector3.new(0, -1.4, 0)) * (v48 - v48.Position);
end;

local function startGlowFollowEmit(p49, p50, p51) -- Line: 488
    -- upvalues: VisibleMgr (copy), FXUtil (copy)
    VisibleMgr.UnQueryAll(p49);
    p49:PivotTo(p50:GetPivot());
    p49.Parent = p50;
    FXUtil.Emit_Particles_GetDescendants(p49, true);
    p51.metallizeGlowInst = p49;
end;

local function playEndGlowFollowEmit(p52, p53) -- Line: 497
    -- upvalues: VisibleMgr (copy), FXUtil (copy)
    local u54 = p53:Clone();
    VisibleMgr.UnQueryAll(u54);
    u54:PivotTo(p52:GetPivot());
    u54.Parent = p52;
    FXUtil.Emit_Particles_GetDescendants(u54, true);
    task.delay(1.5, function() -- Line: 503
        -- upvalues: u54 (copy)
        if u54.Parent then
            u54:Destroy();
        end;
    end);
end;

local function emitVfxOnce(p55, p56, p57, p58) -- Line: 511
    -- upvalues: VisibleMgr (copy), FXUtil (copy), SkillCommon (copy)
    if not (p55 and p55:IsA("Model")) then
        return;
    end;

    local v59 = p55:Clone();
    VisibleMgr.UnQueryAll(v59);
    v59:PivotTo(p56);
    v59.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v59, true);

    if p58 ~= false then
        SkillCommon.appendRunSpawnList(p57, "metallizeVfxSpawns", v59);
    end;
end;

local function playMetallizeCastVfx(p60, u61) -- Line: 526
    -- upvalues: VisibleMgr (copy), FXUtil (copy), emitVfxOnce (copy), RunService (copy)
    local skillRunData = p60.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    skillRunData.metallizeVfxActive = true;
    local v62 = skillRunData.material["金属化_发光"];

    if v62 and v62:IsA("Model") then
        VisibleMgr.UnQueryAll(v62);
        v62:PivotTo(u61:GetPivot());
        v62.Parent = u61;
        FXUtil.Emit_Particles_GetDescendants(v62, true);
        skillRunData.metallizeGlowInst = v62;
    end;

    emitVfxOnce(skillRunData.material["金属化_法阵"], FXUtil.GetGroundAlignedCF(u61.Position, u61.CFrame.LookVector, "Ground", 3, 0.1) or CFrame.new(u61.Position + Vector3.new(0, 0.1, 0)), skillRunData);
    local u63 = skillRunData.material["金属化_光环"];

    if u63 and u63:IsA("Model") then
        VisibleMgr.UnQueryAll(u63);
        local v64 = u61:GetPivot();
        u63:PivotTo(CFrame.new(v64.Position + Vector3.new(0, -1.4, 0)) * (v64 - v64.Position));
        u63.Parent = workspace.Debris;
        FXUtil.SetEmittersTrailsBeamsEnabled(u63, true);
        skillRunData.metallizeHaloInst = u63;
        skillRunData.runEvent = skillRunData.runEvent or {};

        if skillRunData.runEvent["金属化光环跟随"] then
            skillRunData.runEvent["金属化光环跟随"]:Disconnect();
            skillRunData.runEvent["金属化光环跟随"] = nil;
        end;

        skillRunData.runEvent["金属化光环跟随"] = RunService.Heartbeat:Connect(function() -- Line: 553
            -- upvalues: u63 (copy), u61 (copy)
            if not (u63.Parent and u61.Parent) then
                return;
            end;

            local v65 = u61:GetPivot();
            u63:PivotTo(CFrame.new(v65.Position + Vector3.new(0, -1.4, 0)) * (v65 - v65.Position));
        end);
    end;
end;

local function cleanupMetallizeClientVfx(p66) -- Line: 563
    -- upvalues: FXUtil (copy), playEndGlowFollowEmit (copy)
    local skillRunData = p66.skillRunData;

    if not (skillRunData and skillRunData.metallizeVfxActive) then
        return;
    end;

    skillRunData.metallizeVfxActive = nil;

    if skillRunData.runEvent and skillRunData.runEvent["金属化光环跟随"] then
        skillRunData.runEvent["金属化光环跟随"]:Disconnect();
        skillRunData.runEvent["金属化光环跟随"] = nil;
    end;

    local metallizeGlowInst = skillRunData.metallizeGlowInst;

    if metallizeGlowInst and metallizeGlowInst.Parent then
        metallizeGlowInst.Parent = nil;
    end;

    skillRunData.metallizeGlowInst = nil;
    local metallizeHaloInst = skillRunData.metallizeHaloInst;

    if metallizeHaloInst and metallizeHaloInst.Parent then
        FXUtil.SetEmittersTrailsBeamsEnabled(metallizeHaloInst, false);
        FXUtil.Stop_All_Emit(metallizeHaloInst);
        FXUtil.OffEnableVfx(metallizeHaloInst);
        metallizeHaloInst.Parent = nil;
    end;

    skillRunData.metallizeHaloInst = nil;
    local v67 = p66.skillInputData and p66.skillInputData.character;

    if v67 then
        v67 = v67:FindFirstChild("HumanoidRootPart");
    end;

    local v68 = skillRunData.material and skillRunData.material["金属化_发光"];

    if v67 and (v67:IsA("BasePart") and (v68 and v68:IsA("Model"))) then
        playEndGlowFollowEmit(v67, v68);
    end;
end;

local function cleanupMetallizeClientPose(p69) -- Line: 599
    -- upvalues: SkillActionLock (copy), releaseFrozenAnimations (copy), unanchorCharacterParts (copy), resumeSmartBones (copy), Players (copy), HumanModule (copy)
    local skillRunData = p69.skillRunData;

    if not (skillRunData and skillRunData.metallizePoseActive) then
        return;
    end;

    skillRunData.metallizePoseActive = nil;
    local v70 = p69.skillInputData and p69.skillInputData.character;

    if v70 then
        SkillActionLock.turn_Off_Action_Lock(v70);
        releaseFrozenAnimations(skillRunData.metallizeFrozenTracks);
        unanchorCharacterParts(v70, skillRunData);
        local v71 = v70:FindFirstChildOfClass("Humanoid");

        if v71 then
            v71.AutoRotate = true;
            local HumanoidRootPart = v70:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
            end;

            if v71.FloorMaterial ~= Enum.Material.Air then
                v71:ChangeState(Enum.HumanoidStateType.Running);
            end;
        end;

        resumeSmartBones(skillRunData.metallizePausedSmartBones);
        local LocalPlayer = Players.LocalPlayer;
        local v72;

        if LocalPlayer and p69.characterType == "Player" then
            v72 = p69.characterId == LocalPlayer.UserId;
        else
            v72 = false;
        end;

        if v72 then
            HumanModule.UpdateLocalPlayerSpeed(0.1);
        end;
    end;

    skillRunData.metallizeFrozenTracks = nil;
    skillRunData.metallizePausedSmartBones = nil;
end;

local function cleanupMetallizeClient(p73) -- Line: 626
    -- upvalues: SkillCommon (copy), cleanupMetallizeClientPose (copy), restoreMetalLookFromSnapshot (copy), cleanupMetallizeClientVfx (copy)
    SkillCommon.stopSoundLocalForSkill(p73, "音效-技能-金属化", 0.2);
    cleanupMetallizeClientPose(p73);
    restoreMetalLookFromSnapshot(p73.skillRunData);
    cleanupMetallizeClientVfx(p73);
end;

local function clearWudiIfMetallizeEndedEarly(p74) -- Line: 634
    -- upvalues: GetData (copy)
    local skillRunData = p74.skillRunData;

    if not skillRunData then
        return;
    end;

    local metallizeWudiEndAt = skillRunData.metallizeWudiEndAt;
    skillRunData.metallizeWudiEndAt = nil;

    if type(metallizeWudiEndAt) ~= "number" then
        return;
    end;

    if metallizeWudiEndAt <= workspace:GetServerTimeNow() + 0.02 then
        return;
    end;

    local v75 = GetData.GetPlayerByID(p74.characterId);

    if not v75 then
        return;
    end;

    local v76 = v75:FindFirstChild("闪避无敌");

    if v76 and v76:IsA("NumberValue") then
        v76.Value = 0;
    end;
end;

local function cleanupMetallizeServer(p77) -- Line: 658
    -- upvalues: GetData (copy), unanchorCharacterParts (copy), clearWudiIfMetallizeEndedEarly (copy)
    local v78 = GetData.GetPlayerByID(p77.characterId);

    if v78 then
        v78:SetAttribute("MOVE_SPEED_LOCK", nil);
    end;

    local v79 = p77.skillInputData and p77.skillInputData.character;
    local v80 = v79 and v79:FindFirstChildOfClass("Humanoid");

    if v80 then
        v80.AutoRotate = true;
    end;

    unanchorCharacterParts(v79, p77.skillRunData);
    clearWudiIfMetallizeEndedEarly(p77);
end;

function v1.Client_EnterMetallized(u81) -- Line: 675
    -- upvalues: freezePlayingAnimations (copy), pauseSmartBonesInCharacter (copy), SkillActionLock (copy), anchorCharacterParts (copy), resolveMetalTemplateMesh (copy), applyMetalLookToCharacter (copy), SkillCommon (copy), playMetallizeCastVfx (copy), SkillEventConst (copy)
    local v82 = u81.skillInputData and u81.skillInputData.character;

    if not v82 then
        return;
    end;

    local v83 = v82:FindFirstChildOfClass("Humanoid");

    if not v83 then
        return;
    end;

    local HumanoidRootPart = v82:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local skillRunData = u81.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.metallizePoseActive = true;
    skillRunData.metallizeFrozenTracks = freezePlayingAnimations(v83);
    skillRunData.metallizePausedSmartBones = pauseSmartBonesInCharacter(v82);
    SkillActionLock.turn_On_Action_Lock(v82);
    v83.AutoRotate = false;
    anchorCharacterParts(v82, skillRunData);
    local v84 = resolveMetalTemplateMesh(skillRunData.material and skillRunData.material["金属化"]);

    if v84 then
        applyMetalLookToCharacter(v82, v84, skillRunData);
    else
        warn("[Metallize1] 未找到金属化模板 MeshPart:", "金属化");
    end;

    local v85 = SkillCommon.scaleBandFromData(u81, SkillCommon.bandScaleOptsFromSkillData(u81)) * 2;
    playMetallizeCastVfx(u81, HumanoidRootPart);

    if not SkillCommon.playSoundLocal3DOnPartForSkill(u81, "音效-技能-金属化", HumanoidRootPart, true) then
        SkillCommon.playSoundLocal3D("音效-技能-金属化", HumanoidRootPart.Position);
    end;

    local runGeneration = u81.runGeneration;
    task.delay(v85, function() -- Line: 462
        -- upvalues: SkillCommon (ref), u81 (copy), runGeneration (copy), SkillEventConst (ref)
        if not SkillCommon.isRunningSameGeneration(u81, runGeneration) then
            return;
        end;

        local skillRunData2 = u81.skillRunData;

        if not skillRunData2 or (not skillRunData2.State or skillRunData2.State.current ~= "Metallized") then
            return;
        end;

        u81:TryTransition(SkillEventConst.StateTimeout, nil);
    end);
    SkillCommon.scheduleRunSpawnClear(u81, u81.runGeneration, skillRunData, "metallizeVfxSpawns", v85 + 0.15);
end;

function v1.Client_ExitMetallized(p86) -- Line: 718
    -- upvalues: SkillCommon (copy), cleanupMetallizeClientPose (copy), restoreMetalLookFromSnapshot (copy), cleanupMetallizeClientVfx (copy)
    local skillRunData = p86.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p86, p86.runGeneration, skillRunData, "metallizeVfxSpawns");
    end;

    SkillCommon.stopSoundLocalForSkill(p86, "音效-技能-金属化", 0.2);
    cleanupMetallizeClientPose(p86);
    restoreMetalLookFromSnapshot(p86.skillRunData);
    cleanupMetallizeClientVfx(p86);
end;

function v1.Server_EnterMetallized(u87) -- Line: 726
    -- upvalues: anchorCharacterParts (copy), SkillCommon (copy), SystemPlrAttr (copy), GetData (copy), SkillEventConst (copy)
    local v88 = u87.skillInputData and u87.skillInputData.character;
    local skillRunData = u87.skillRunData;

    if v88 and skillRunData then
        local v89 = v88:FindFirstChildOfClass("Humanoid");

        if v89 then
            v89.AutoRotate = false;
        end;

        anchorCharacterParts(v88, skillRunData);
    end;

    local v90 = SkillCommon.scaleBandFromData(u87, SkillCommon.bandScaleOptsFromSkillData(u87)) * 2;

    if u87.characterType == "Player" then
        SystemPlrAttr.WudiPlr(u87.characterId, v90);
        local v91 = GetData.GetPlayerByID(u87.characterId);

        if v91 then
            v91:SetAttribute("MOVE_SPEED_LOCK", true);
        end;

        if skillRunData then
            skillRunData.metallizeWudiEndAt = workspace:GetServerTimeNow() + v90;
        end;
    end;

    local runGeneration = u87.runGeneration;
    task.delay(v90, function() -- Line: 462
        -- upvalues: SkillCommon (ref), u87 (copy), runGeneration (copy), SkillEventConst (ref)
        if not SkillCommon.isRunningSameGeneration(u87, runGeneration) then
            return;
        end;

        local skillRunData2 = u87.skillRunData;

        if not skillRunData2 or (not skillRunData2.State or skillRunData2.State.current ~= "Metallized") then
            return;
        end;

        u87:TryTransition(SkillEventConst.StateTimeout, nil);
    end);
end;

function v1.Server_ExitMetallized(p92) -- Line: 750
    -- upvalues: cleanupMetallizeServer (copy)
    cleanupMetallizeServer(p92);
end;

function v1.Server_EnterRecovery(p93) -- Line: 755
    p93:releaseControl();
end;

function v1.Client_EnterRecovery(p94) -- Line: 759
end;

function v1.onEnd(p95) -- Line: 763
    -- upvalues: SkillCommon (copy), cleanupMetallizeClientPose (copy), restoreMetalLookFromSnapshot (copy), cleanupMetallizeClientVfx (copy)
    SkillCommon.stopSoundLocalForSkill(p95, "音效-技能-金属化", 0.2);
    cleanupMetallizeClientPose(p95);
    restoreMetalLookFromSnapshot(p95.skillRunData);
    cleanupMetallizeClientVfx(p95);
end;

function v1.onEndServer(p96) -- Line: 767
    -- upvalues: cleanupMetallizeServer (copy)
    cleanupMetallizeServer(p96);
end;

v1.SoundList = { "音效-技能-金属化" };
v1.AnimateList = {};
v1.ResNameList = { "金属化", "金属化_发光", "金属化_法阵", "金属化_光环" };
v1.hitboxConfig = {};
v1.Action = {};
v1.StateActions = {
    Metallized = { {
            action = "LookAt",
            startTime = 0,
            overTime = -1,
            speedType = "MOVE_SPEED_LOCK"
        } }
};

return v1;