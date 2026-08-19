-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local VisibleMgr = UtilsSystem.VisibleMgr;
local MathMgr = UtilsSystem.MathMgr;
local HumanModule = UtilsSystem.HumanModule;
local GetData = UtilsSystem.GetData;
local PlayerData = UtilsSystem.PlayerData;
local Config = require(script.Parent.Parent.Config);
local ProjectileObjectTracking = require(ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule._Templates.Projectile.ProjectileObjectTracking);
local SkillSyncRouter = ReplicatedStorage.ClientSideCode.SystemSkill.BaseSkill.SkillSyncRouter;
local GroupSkillServer = ReplicatedStorage.ClientSideCode.SystemSkill.GroupSkill.GroupSkillServer;
local u1 = {};
local u2 = {};
local u3 = false;
local u4 = {};

local function getGroupSkillServer() -- Line: 56
    -- upvalues: GroupSkillServer (copy)
    return require(GroupSkillServer);
end;

local function getSkillSyncRouter() -- Line: 60
    -- upvalues: SkillSyncRouter (copy)
    return require(SkillSyncRouter);
end;

local function resolveMirrorAimPos(p5, p6) -- Line: 64
    -- upvalues: ProjectileObjectTracking (copy)
    if p5 then
        local trackTargetId = p5.trackTargetId;
        local v7 = trackTargetId ~= nil and trackTargetId ~= "" and ProjectileObjectTracking.getWorldPositionByTrackTargetId(trackTargetId);

        if v7 then
            return v7;
        end;

        if p5.targetCF then
            return p5.targetCF.Position;
        end;
    end;

    local LookVector = p6.CFrame.LookVector;
    local v8 = Vector3.new(LookVector.X, 0, LookVector.Z);

    if v8.Magnitude > 0.05 then
        return p6.Position + v8.Unit * 5;
    end;

    return p6.Position + Vector3.new(0, 0, -5);
end;

local function flatForwardToAim(p9, p10) -- Line: 85
    local v11 = Vector3.new(p10.X - p9.Position.X, 0, p10.Z - p9.Position.Z);

    if v11.Magnitude > 0.05 then
        return v11.Unit;
    end;

    local LookVector = p9.CFrame.LookVector;
    local v12 = Vector3.new(LookVector.X, 0, LookVector.Z);

    return v12.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v12.Unit;
end;

local function buildMirrorSpawnCF(p13, p14) -- Line: 98
    -- upvalues: MathMgr (copy)
    local v15 = Vector3.new(p14.X - p13.Position.X, 0, p14.Z - p13.Position.Z);
    local v16;

    if v15.Magnitude > 0.05 then
        v16 = v15.Unit;
    else
        local LookVector = p13.CFrame.LookVector;
        local v17 = Vector3.new(LookVector.X, 0, LookVector.Z);
        v16 = v17.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v17.Unit;
    end;

    local Unit = (Vector3.new(0, 1, 0)):Cross(v16).Unit;
    local v18 = p13.Position + Unit * 5;

    return MathMgr.rotLookAtForwardSafe(v16, Vector3.new(0, 1, 0), p13.CFrame.RightVector) + v18;
end;

local function buildMirrorReleaseCF(p19, p20) -- Line: 106
    -- upvalues: MathMgr (copy)
    local Position = p19.Position;
    local v21 = Vector3.new(p20.X - Position.X, 0, p20.Z - Position.Z);

    if v21.Magnitude < 0.05 then
        return p19.CFrame;
    end;

    return MathMgr.rotLookAtForwardSafe(v21, Vector3.new(0, 1, 0), p19.CFrame.RightVector) + Position;
end;

local function resolveLiveCastPotency(p22, p23, p24) -- Line: 117
    -- upvalues: PlayerData (copy)
    local skillPower = p24.skillPower;
    local skillPurity = p24.skillPurity;
    local mpTp = p24.mpTp;

    if not (PlayerData and p23) then
        return skillPower, skillPurity, mpTp;
    end;

    local v25 = PlayerData.GetPlrDataByKey(p22, "skills");

    if v25 then
        v25 = v25[p23];
    end;

    if type(v25) ~= "table" then
        return skillPower, skillPurity, mpTp;
    end;

    if typeof(v25.Power) == "number" then
        skillPower = v25.Power;
    end;

    if typeof(v25.purity) == "number" then
        skillPurity = v25.purity;
    end;

    if type(v25.mpTp) == "string" and v25.mpTp ~= "" then
        mpTp = v25.mpTp;
    end;

    return skillPower, skillPurity, mpTp;
end;

local function resolveCastTraitVfxName(p26) -- Line: 145
    if p26 then
        p26 = p26.Effects;
    end;

    return (type(p26) ~= "string" or p26 == "") and "空间元素_VFX" or p26;
end;

local function broadcastMirrorCastVfx(p27, p28, p29) -- Line: 153
    -- upvalues: SkillSyncRouter (copy)
    require(SkillSyncRouter).broadcastPresentationRelevant(p28, 120, "CastTrait镜像表现", p29, p27);
end;

local function emitOnCasterHrp(p30, p31) -- Line: 158
    -- upvalues: HumanModule (copy), SkillSyncRouter (copy)
    local v32 = HumanModule.GetHumanoidRootPart(p30);

    if not v32 then
        return;
    end;

    local Position = v32.Position;
    local v33 = {
        phase = "proc",
        ownerUserId = p30.UserId,
        vfxName = p31
    };
    require(SkillSyncRouter).broadcastPresentationRelevant(Position, 120, "CastTrait镜像表现", v33, p30);
end;

local function emitOnMirrorHrp(p34, p35, p36, p37, p38) -- Line: 170
    -- upvalues: SkillSyncRouter (copy)
    local HumanoidRootPart = p35:FindFirstChild("HumanoidRootPart");

    if p38 then
        HumanoidRootPart = p38;
    elseif HumanoidRootPart then
        HumanoidRootPart = HumanoidRootPart.Position;
    end;

    if not HumanoidRootPart then
        return;
    end;

    local v39 = {
        phase = p37,
        mirrorName = p35.Name,
        worldPos = HumanoidRootPart,
        vfxName = p36
    };
    require(SkillSyncRouter).broadcastPresentationRelevant(HumanoidRootPart, 120, "CastTrait镜像表现", v39, p34);
end;

local function attachMirrorHighlight(p40) -- Line: 190
    -- upvalues: ReplicatedStorage (copy)
    local ModelRes = ReplicatedStorage:FindFirstChild("ModelRes");

    if ModelRes then
        ModelRes = ModelRes:FindFirstChild("MirrorHightLight");
    end;

    if not (ModelRes and ModelRes:IsA("Highlight")) then
        return;
    end;

    local v41 = ModelRes:Clone();
    v41.Adornee = p40;
    v41.Parent = p40;
end;

local function getSpaceMirrorsFolder() -- Line: 201
    local SpaceMirrors = workspace:FindFirstChild("SpaceMirrors");

    if SpaceMirrors and SpaceMirrors:IsA("Folder") then
        return SpaceMirrors;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "SpaceMirrors";
    Folder.Parent = workspace;

    return Folder;
end;

local function stripRuntimeFromClone(p42) -- Line: 212
    for _, descendant in p42:GetDescendants() do
        if descendant:IsA("Tool") or (descendant:IsA("LocalScript") or descendant:IsA("Script")) then
            descendant:Destroy();
        end;
    end;
end;

local function destroyMirrorGroupSkill(p43) -- Line: 220
    -- upvalues: u2 (copy)
    local v44 = u2[p43];
    u2[p43] = nil;

    if v44 and v44.destroy then
        v44:destroy();
    end;
end;

local function destroyMirrorModel(p45, p46, p47) -- Line: 228
    -- upvalues: emitOnMirrorHrp (copy), u2 (copy), u1 (copy)
    if not (p45 and p45.Parent) then
        return;
    end;

    local HumanoidRootPart = p45:FindFirstChild("HumanoidRootPart");

    if p46 and HumanoidRootPart then
        emitOnMirrorHrp(p46, p45, p47 or "空间元素_VFX", "despawn", HumanoidRootPart.Position);
    end;

    local v48 = u2[p45];
    u2[p45] = nil;

    if v48 and v48.destroy then
        v48:destroy();
    end;

    for i, v in u1 do
        if v == p45 then
            u1[i] = nil;
            break;
        end;
    end;

    p45:Destroy();
end;

function u4.clearMirrorsForPlayer(p49, p50) -- Line: 246
    -- upvalues: u1 (copy), GetData (copy), destroyMirrorModel (copy)
    local v51 = u1[p49];
    u1[p49] = nil;

    if v51 and v51.Parent then
        destroyMirrorModel(v51, GetData.GetPlayerByID(p49), p50);
    end;
end;

local function ensurePlayerCleanupHook() -- Line: 255
    -- upvalues: u3 (ref), Players (copy), u4 (copy)
    if u3 then
        return;
    end;

    u3 = true;
    Players.PlayerRemoving:Connect(function(p52) -- Line: 260
        -- upvalues: u4 (ref)
        u4.clearMirrorsForPlayer(p52.UserId);
    end);
end;

local function resolveMirrorName(p53, p54) -- Line: 265
    local DisplayName = p53.DisplayName;

    if DisplayName == "" then
        DisplayName = p53.Name;
    end;

    local v55 = DisplayName .. "镜像";

    if p54:FindFirstChild(v55) then
        return v55 .. "_" .. p53.UserId;
    end;

    return v55;
end;

local function cloneCharacterModel(p56) -- Line: 277
    local Archivable = p56.Archivable;
    p56.Archivable = true;
    local v57 = p56:Clone();
    p56.Archivable = Archivable;

    if not v57 then
        return nil;
    end;

    v57.Archivable = false;

    return v57;
end;

local function buildMirrorSkillInput(p58, p59, p60) -- Line: 289
    -- upvalues: MathMgr (copy)
    local HumanoidRootPart = p58:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil;
    end;

    local v61 = {
        skipCastTrait = true
    };
    local Position = HumanoidRootPart.Position;
    local v62 = Vector3.new(p60.X - Position.X, 0, p60.Z - Position.Z);
    local v63;

    if v62.Magnitude < 0.05 then
        v63 = HumanoidRootPart.CFrame;
    else
        v63 = MathMgr.rotLookAtForwardSafe(v62, Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.RightVector) + Position;
    end;

    v61.releaseCF = v63;
    local v64;

    if p59 then
        v64 = p59.targetCF;
    else
        v64 = p59;
    end;

    v61.targetCF = v64;
    local v65;

    if p59 then
        v65 = p59.moveDirectionStr;
    else
        v65 = p59;
    end;

    v61.moveDirectionStr = v65;
    local v66;

    if p59 then
        v66 = p59.trackTargetId;
    else
        v66 = p59;
    end;

    v61.trackTargetId = v66;
    local v67;

    if p59 then
        v67 = p59.skillTargetData;
    else
        v67 = p59;
    end;

    v61.skillTargetData = v67;
    local v68;

    if p59 then
        v68 = p59.approachLandWorldPos;
    else
        v68 = p59;
    end;

    v61.approachLandWorldPos = v68;
    local v69;

    if p59 then
        v69 = p59.moveFaceMode;
    else
        v69 = p59;
    end;

    v61.moveFaceMode = v69;
    local v70;

    if p59 then
        v70 = p59.moveFaceWorldPos;
    else
        v70 = p59;
    end;

    v61.moveFaceWorldPos = v70;
    local v71;

    if p59 then
        v71 = p59.multThunderPathPoints;
    else
        v71 = p59;
    end;

    v61.multThunderPathPoints = v71;

    if p59 then
        p59 = p59.multThunderSpawnGround;
    end;

    v61.multThunderSpawnGround = p59;

    return v61;
end;

local function castMirrorSkill(u72, u73, p74, p75, p76, u77) -- Line: 309
    -- upvalues: buildMirrorSkillInput (copy), destroyMirrorModel (copy), GroupSkillServer (copy), u2 (copy), u1 (copy)
    local v78 = buildMirrorSkillInput(u73, p75, p76);

    if not v78 then
        destroyMirrorModel(u73, u72, u77);

        return;
    end;

    local u79 = require(GroupSkillServer).new({
        characterType = "Mirror",
        characterId = u73.Name,
        skillName = p74.skillName,
        skillID = p74.skillID,
        slotIndex = p74.slotIndex,
        skillPower = p74.skillPower,
        skillPurity = p74.skillPurity,
        mpTp = p74.mpTp
    });

    if not u79 then
        destroyMirrorModel(u73, u72, u77);

        return;
    end;

    u2[u73] = u79;
    u79:requestRelease(v78);
    task.delay(20, function() -- Line: 348
        -- upvalues: u1 (ref), u72 (copy), u73 (copy), destroyMirrorModel (ref), u77 (copy)
        if u1[u72.UserId] == u73 then
            destroyMirrorModel(u73, u72, u77);
        end;
    end);
    task.spawn(function() -- Line: 354
        -- upvalues: u73 (copy), u79 (copy), u1 (ref), u72 (copy), destroyMirrorModel (ref), u77 (copy)
        while u73.Parent and #u79.runningRuntimeList > 0 do
            task.wait(0.05);
        end;

        if u1[u72.UserId] == u73 then
            destroyMirrorModel(u73, u72, u77);
        end;
    end);
end;

local function spawnMirrorShell(p80, p81, p82, p83, p84, p85) -- Line: 364
    -- upvalues: u4 (copy), stripRuntimeFromClone (copy), Config (copy), VisibleMgr (copy), MathMgr (copy), ReplicatedStorage (copy), emitOnMirrorHrp (copy), u1 (copy)
    local Character = p80.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil;
    end;

    u4.clearMirrorsForPlayer(p80.UserId, p85);
    local Archivable = Character.Archivable;
    Character.Archivable = true;
    local v86 = Character:Clone();
    Character.Archivable = Archivable;

    if v86 then
        v86.Archivable = false;
    else
        v86 = nil;
    end;

    if not v86 then
        warn("[SpaceMirrorCast] Character:Clone failed (Archivable?) userId=", p80.UserId);

        return nil;
    end;

    local SpaceMirrors = workspace:FindFirstChild("SpaceMirrors");

    if not (SpaceMirrors and SpaceMirrors:IsA("Folder")) then
        SpaceMirrors = Instance.new("Folder");
        SpaceMirrors.Name = "SpaceMirrors";
        SpaceMirrors.Parent = workspace;
    end;

    local DisplayName = p80.DisplayName;

    if DisplayName == "" then
        DisplayName = p80.Name;
    end;

    local v87 = DisplayName .. "镜像";

    if SpaceMirrors:FindFirstChild(v87) then
        v87 = v87 .. "_" .. p80.UserId;
    end;

    v86.Name = v87;
    stripRuntimeFromClone(v86);
    local v88 = v86:FindFirstChildOfClass("Humanoid");

    if v88 then
        v88.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
        v88.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff;
        v88.BreakJointsOnDeath = false;
        v88.PlatformStand = true;
    end;

    local HumanoidRootPart2 = v86:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart2 then
        v86:Destroy();

        return nil;
    end;

    local NameTag = HumanoidRootPart2:FindFirstChild("NameTag");

    if NameTag then
        NameTag:Destroy();
    end;

    v86.PrimaryPart = HumanoidRootPart2;
    v86:SetAttribute("EntityType", "Mirror");
    v86:SetAttribute("OwnerUserId", p80.UserId);
    v86:SetAttribute("OwnerId", p80.UserId);
    v86:SetAttribute("OwnerType", "Player");
    local v89 = Config.mirrorDamageMulFromBuffRow(p81);

    if v89 then
        v86:SetAttribute("MirrorDamageMul", v89);
    end;

    if p82.skillPower ~= nil then
        v86:SetAttribute("SkillPower", p82.skillPower);
    end;

    if p82.skillPurity ~= nil then
        v86:SetAttribute("SkillPurity", p82.skillPurity);
    end;

    if p82.mpTp then
        v86:SetAttribute("MpTp", p82.mpTp);
    end;

    VisibleMgr.UnCollideAll(v86);
    VisibleMgr.MasslessAll(v86);
    VisibleMgr.UnQueryAll(v86);
    local v90 = Vector3.new(p84.X - HumanoidRootPart.Position.X, 0, p84.Z - HumanoidRootPart.Position.Z);
    local v91;

    if v90.Magnitude > 0.05 then
        v91 = v90.Unit;
    else
        local LookVector = HumanoidRootPart.CFrame.LookVector;
        local v92 = Vector3.new(LookVector.X, 0, LookVector.Z);
        v91 = v92.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v92.Unit;
    end;

    local Unit = (Vector3.new(0, 1, 0)):Cross(v91).Unit;
    local v93 = HumanoidRootPart.Position + Unit * 5;
    v86:PivotTo(MathMgr.rotLookAtForwardSafe(v91, Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.RightVector) + v93);
    HumanoidRootPart2.Anchored = true;
    v86.Parent = SpaceMirrors;
    local ModelRes = ReplicatedStorage:FindFirstChild("ModelRes");

    if ModelRes then
        ModelRes = ModelRes:FindFirstChild("MirrorHightLight");
    end;

    if ModelRes and ModelRes:IsA("Highlight") then
        local v94 = ModelRes:Clone();
        v94.Adornee = v86;
        v94.Parent = v86;
    end;

    emitOnMirrorHrp(p80, v86, p85, "spawn");
    u1[p80.UserId] = v86;

    return v86;
end;

function u4.tryProc(u95) -- Line: 449
    -- upvalues: Config (copy), u3 (ref), Players (copy), u4 (copy), HumanModule (copy), SkillSyncRouter (copy), resolveLiveCastPotency (copy), RunService (copy), resolveMirrorAimPos (copy), spawnMirrorShell (copy), castMirrorSkill (copy)
    local v96 = Config.procChanceFromBuffRow(u95.instRow);

    if not v96 or v96 <= 0 then
        return false;
    end;

    local v97 = math.abs(((u95.combatSeed or 0) + u95.buffInstId * 7919) % 2147483647);

    if v96 <= Random.new(v97):NextNumber() then
        return false;
    end;

    local skillName = u95.skillName;
    local skillInputData = u95.skillInputData;

    if type(skillName) ~= "string" or (skillName == "" or not skillInputData) then
        warn("[SpaceMirrorCast] proc ok but missing cast ctx skillId=", u95.skillId);

        return false;
    end;

    local typeRow = u95.typeRow;

    if typeRow then
        typeRow = typeRow.Effects;
    end;

    local u98 = (type(typeRow) ~= "string" or typeRow == "") and "空间元素_VFX" or typeRow;

    if not u3 then
        u3 = true;
        Players.PlayerRemoving:Connect(function(p99) -- Line: 260
            -- upvalues: u4 (ref)
            u4.clearMirrorsForPlayer(p99.UserId);
        end);
    end;

    local plr = u95.plr;
    local v100 = HumanModule.GetHumanoidRootPart(plr);

    if v100 then
        local Position = v100.Position;
        local v101 = {
            phase = "proc",
            ownerUserId = plr.UserId,
            vfxName = u98
        };
        require(SkillSyncRouter).broadcastPresentationRelevant(Position, 120, "CastTrait镜像表现", v101, plr);
    end;

    local v102 = u95.slotIndex or 1;
    local v103, v104, v105 = resolveLiveCastPotency(u95.plr, v102, {
        skillPower = u95.skillPower,
        skillPurity = u95.skillPurity,
        mpTp = u95.mpTp
    });
    local u106 = {
        skillName = skillName,
        skillID = u95.skillId,
        slotIndex = v102,
        skillPower = v103,
        skillPurity = v104,
        mpTp = v105
    };
    task.spawn(function() -- Line: 488
        -- upvalues: u95 (copy), RunService (ref), resolveMirrorAimPos (ref), skillInputData (copy), spawnMirrorShell (ref), u106 (copy), u98 (copy), castMirrorSkill (ref)
        local Character = u95.plr.Character;
        local v107;

        if Character then
            v107 = Character:FindFirstChild("HumanoidRootPart");
        else
            v107 = Character;
        end;

        if not v107 then
            return;
        end;

        for _ = 1, 10 do
            RunService.Heartbeat:Wait();
        end;

        if not (u95.plr.Parent and Character.Parent) then
            return;
        end;

        local v108 = resolveMirrorAimPos(skillInputData, v107);
        local v109 = spawnMirrorShell(u95.plr, u95.instRow, u106, skillInputData, v108, u98);

        if not v109 then
            warn("[SpaceMirrorCast] proc ok but spawn failed skillId=", u95.skillId);

            return;
        end;

        castMirrorSkill(u95.plr, v109, u106, skillInputData, v108, u98);
        warn("[SpaceMirrorCast] proc cast skillId=", u95.skillId, "buffInstId=", u95.buffInstId, "mirror=", v109.Name);
    end);

    return true;
end;

return u4;