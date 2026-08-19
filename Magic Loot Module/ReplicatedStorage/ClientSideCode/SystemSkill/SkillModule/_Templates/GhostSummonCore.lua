-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local RayCast = UtilsSystem.RayCast;
local RunService = UtilsSystem.RunService;
local SkillCommon = require(script.Parent.SkillCommon);
local u1 = {};
local u2 = {
    sideOffsetStuds = 8,
    groundSurfaceLift = 0.2,
    spawnGroundOffsetY = 3,
    spawnIntroDuration = 2,
    spawnIntroBelowOffset = 15,
    castVfxName = "幽灵船长召唤特效",
    castFollowPartName = "Left Arm",
    formationEnableDuration = 2
};

local function mergeConfig(p3) -- Line: 51
    -- upvalues: u2 (copy)
    local v4 = table.clone(u2);

    for i, v in pairs(p3) do
        v4[i] = v;
    end;

    return v4;
end;

local function setVfxEnabled(p5, p6) -- Line: 59
    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or descendant:IsA("Trail")) then
            descendant.Enabled = p6;
        end;
    end;
end;

local function resolveSideGroundCF(p7, p8, p9, p10, p11) -- Line: 72
    -- upvalues: RayCast (copy)
    local v12 = p8 <= 0 and 1 or p8;
    local v13 = p11 * v12;
    local v14 = p7:PointToWorldSpace((Vector3.new(p9 * p10 * v12, 0, 0)));
    local v15 = RayCast.RayCastDirection(v14, Vector3.new(0, -1, 0), 100, "Ground");

    if v15 then
        return p7.Rotation + v15.Position + Vector3.new(0, v13, 0);
    end;

    return p7.Rotation + v14;
end;

local function playFormationVfx(u16, p17, p18, p19) -- Line: 89
    -- upvalues: setVfxEnabled (copy)
    u16:ScaleTo(p18);
    u16:PivotTo(p17);
    u16.Parent = workspace.Debris;
    setVfxEnabled(u16, true);
    task.delay(p19, function() -- Line: 94
        -- upvalues: u16 (copy), setVfxEnabled (ref)
        if u16 and u16.Parent then
            setVfxEnabled(u16, false);
        end;
    end);
end;

function u1.serverEnterSummon(p20, p21) -- Line: 101
    -- upvalues: u2 (copy), SkillCommon (copy), UtilsSystem (copy), resolveSideGroundCF (copy)
    local character = p20.skillInputData.character;

    if not (character and character.Parent) then
        return;
    end;

    if p20.skillInputData.characterType ~= "NPC" then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local v22 = table.clone(u2);

    for i, v in pairs(p21) do
        v22[i] = v;
    end;

    local v23 = SkillCommon.npcSummonBodySkillScale(p20);
    local v24 = p20.skillInputData.releaseCF or HumanoidRootPart:GetPivot();
    local SystemSummon = UtilsSystem.SystemSummon;

    if not (SystemSummon and SystemSummon.CreateNpcSummon) then
        return;
    end;

    local v25 = v22.summonSkillKey or p20.skillName;
    local v26 = {
        despawnOnOwnerLoseAggro = true,
        summonSkillKey = v25,
        maxCount = v22.summonMaxCount,
        scale = v23,
        spawnGroundOffsetY = v22.spawnGroundOffsetY,
        spawnIntroDuration = v22.spawnIntroDuration,
        spawnIntroBelowOffsetY = v22.spawnIntroBelowOffset
    };
    local v27 = #v22.summonSlots;

    if v22.summonMaxCount and (v25 and SystemSummon.trimNpcSummonsForSkillKey) then
        SystemSummon.trimNpcSummonsForSkillKey(character, v25, v22.summonMaxCount, v27);
    end;

    local sideOffsetStuds = v22.sideOffsetStuds;
    local v28 = v22.groundSurfaceLift or u2.groundSurfaceLift;

    for _, v in v22.summonSlots do
        local v29 = resolveSideGroundCF(v24, v23, v.lateralSign, sideOffsetStuds, v28);
        SystemSummon.CreateNpcSummon(character, v.summonId, v29, v26);
    end;
end;

function u1.clientEnterSummon(u30, p31) -- Line: 147
    -- upvalues: u2 (copy), SkillCommon (copy), setVfxEnabled (copy), RunService (copy), resolveSideGroundCF (copy), playFormationVfx (copy)
    local character = u30.skillInputData.character;

    if not character then
        return;
    end;

    local skillRunData = u30.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    local v32 = table.clone(u2);

    for i, v in pairs(p31) do
        v32[i] = v;
    end;

    local material = skillRunData.material;
    local runGeneration = u30.runGeneration;
    local v33 = SkillCommon.npcSummonBodySkillScale(u30);
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local function stillSummon() -- Line: 167
        -- upvalues: u30 (copy), runGeneration (copy)
        local v34 = u30:isRunningFlow() and u30.runGeneration == runGeneration;

        return v34;
    end;

    local v35 = u30.skillInputData.releaseCF or HumanoidRootPart:GetPivot();
    local u36 = character:FindFirstChild(v32.castFollowPartName);
    local u37 = material[v32.castVfxName];

    if u37 and u36 then
        u37:ScaleTo(v33);
        u37:PivotTo(u36:GetPivot());
        u37.Parent = workspace.Debris;
        setVfxEnabled(u37, true);
        skillRunData.runEvent = skillRunData.runEvent or {};
        skillRunData.runEvent["幽灵船长召唤特效跟随"] = RunService.RenderStepped:Connect(function() -- Line: 182
            -- upvalues: u30 (copy), runGeneration (copy), u37 (copy), u36 (copy)
            local v38 = u30:isRunningFlow() and u30.runGeneration == runGeneration;

            if not v38 then
                return;
            end;

            if u37.Parent and u36.Parent then
                u37:PivotTo(u36:GetPivot());
            end;
        end);
    end;

    local formationEnableDuration = v32.formationEnableDuration;
    local sideOffsetStuds = v32.sideOffsetStuds;
    local v39 = v32.groundSurfaceLift or u2.groundSurfaceLift;

    for _, v in v32.summonSlots do
        local v40 = resolveSideGroundCF(v35, v33, v.lateralSign, sideOffsetStuds, v39);
        SkillCommon.playSoundLocal3D("音效-幽灵船长-幽魂分身法阵", v40.Position);
        local v41 = material[v.formationVfxName];

        if v41 then
            playFormationVfx(v41, v40, v33, formationEnableDuration);
        end;
    end;
end;

local function getCastVfx(p42, p43) -- Line: 205
    -- upvalues: u2 (copy)
    local skillRunData = p42.skillRunData;

    if skillRunData then
        skillRunData = skillRunData.material;
    end;

    if not skillRunData then
        return nil;
    end;

    local v44 = table.clone(u2);

    for i, v in pairs(p43) do
        v44[i] = v;
    end;

    return skillRunData[v44.castVfxName];
end;

local function disableCastVfx(p45, p46) -- Line: 215
    -- upvalues: u2 (copy), setVfxEnabled (copy)
    local skillRunData = p45.skillRunData;

    if skillRunData then
        skillRunData = skillRunData.material;
    end;

    local v47;

    if skillRunData then
        local v48 = table.clone(u2);

        for i, v in pairs(p46) do
            v48[i] = v;
        end;

        v47 = skillRunData[v48.castVfxName];
    else
        v47 = nil;
    end;

    if v47 then
        setVfxEnabled(v47, false);
    end;
end;

local function stopCastFollow(p49) -- Line: 222
    -- upvalues: SkillCommon (copy)
    local skillRunData = p49.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(skillRunData, { "幽灵船长召唤特效跟随" });
end;

function u1.clientExitSummon(p50, p51) -- Line: 230
    -- upvalues: u2 (copy), setVfxEnabled (copy)
    local skillRunData = p50.skillRunData;

    if skillRunData then
        skillRunData = skillRunData.material;
    end;

    local v52;

    if skillRunData then
        local v53 = table.clone(u2);

        for i, v in pairs(p51) do
            v53[i] = v;
        end;

        v52 = skillRunData[v53.castVfxName];
    else
        v52 = nil;
    end;

    if v52 then
        setVfxEnabled(v52, false);
    end;
end;

function u1.clientExitRecovery(p54, p55) -- Line: 234
    -- upvalues: SkillCommon (copy)
    local skillRunData = p54.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(skillRunData, { "幽灵船长召唤特效跟随" });
end;

function u1.attach(p56, p57) -- Line: 238
    -- upvalues: u2 (copy), u1 (copy), setVfxEnabled (copy), SkillCommon (copy)
    local u58 = table.clone(u2);

    for i, v in pairs(p57) do
        u58[i] = v;
    end;

    if u58.summonSkillKey then
        p56.summonSkillKey = u58.summonSkillKey;
    end;

    if u58.summonMaxCount then
        p56.summonMaxCount = u58.summonMaxCount;
    end;

    function p56.Server_EnterSummon(p59) -- Line: 247
        -- upvalues: u1 (ref), u58 (copy)
        u1.serverEnterSummon(p59, u58);
    end;

    function p56.Client_EnterSummon(p60) -- Line: 250
        -- upvalues: u1 (ref), u58 (copy)
        u1.clientEnterSummon(p60, u58);
    end;

    function p56.Client_ExitSummon(p61) -- Line: 253
        -- upvalues: u1 (ref), u58 (copy)
        u1.clientExitSummon(p61, u58);
    end;

    function p56.Client_ExitRecovery(p62) -- Line: 256
        -- upvalues: u1 (ref), u58 (copy)
        u1.clientExitRecovery(p62, u58);
    end;

    local onEnd = p56.onEnd;

    function p56.onEnd(p63) -- Line: 261
        -- upvalues: u58 (copy), u2 (ref), setVfxEnabled (ref), SkillCommon (ref), onEnd (copy)
        local v64 = u58;
        local skillRunData = p63.skillRunData;

        if skillRunData then
            skillRunData = skillRunData.material;
        end;

        local v65;

        if skillRunData then
            local v66 = table.clone(u2);

            for i, v in pairs(v64) do
                v66[i] = v;
            end;

            v65 = skillRunData[v66.castVfxName];
        else
            v65 = nil;
        end;

        if v65 then
            setVfxEnabled(v65, false);
        end;

        local skillRunData2 = p63.skillRunData;

        if skillRunData2 then
            SkillCommon.disconnectRunEventKeys(skillRunData2, { "幽灵船长召唤特效跟随" });
        end;

        if onEnd then
            onEnd(p63);
        end;
    end;
end;

return u1;