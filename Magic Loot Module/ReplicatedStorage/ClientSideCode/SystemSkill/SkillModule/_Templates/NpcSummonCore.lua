-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local SkillCommon = require(script.Parent.SkillCommon);
local u1 = {};
local u2 = {
    formationForwardOffset = 30,
    spawnGroundOffsetY = 6,
    spawnSummonDelay = 1,
    spawnIntroDuration = 3,
    spawnIntroBelowOffset = 10,
    sphereFlyTime = 0.25,
    formationL4PlayDelay = 0.4,
    formationL4EnableDuration = 2,
    formationVfxName = "召唤法阵1级_Emit和Enable",
    startupSoundDelay = 1.4
};

local function mergeConfig(p3) -- Line: 44
    -- upvalues: u2 (copy)
    local v4 = table.clone(u2);

    for i, v in pairs(p3) do
        v4[i] = v;
    end;

    return v4;
end;

local function playFormationL4Vfx(u5, p6) -- Line: 53
    for _, descendant in u5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or descendant:IsA("Trail")) then
            descendant.Enabled = true;
        end;
    end;

    task.delay(p6, function() -- Line: 59
        -- upvalues: u5 (copy)
        if u5 and u5.Parent then
            for _, descendant in u5:GetDescendants() do
                if descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or descendant:IsA("Trail")) then
                    descendant.Enabled = false;
                end;
            end;
        end;
    end);
end;

local function playTargetBurstVfx(u7, u8) -- Line: 70
    -- upvalues: FXUtil (copy)
    FXUtil.Emit_Particles_GetDescendants(u7, true);
    task.delay(0.5, function() -- Line: 72
        -- upvalues: u7 (copy), u8 (copy)
        if u7 and u7.Parent then
            u8();
        end;
    end);
end;

function u1.serverEnterSummon(u9, p10) -- Line: 79
    -- upvalues: u2 (copy), SkillCommon (copy), UtilsSystem (copy)
    local character = u9.skillInputData.character;

    if not (character and character.Parent) then
        return;
    end;

    if u9.skillInputData.characterType ~= "NPC" then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local u11 = table.clone(u2);

    for i, v in pairs(p10) do
        u11[i] = v;
    end;

    local u12 = SkillCommon.npcSummonBodySkillScale(u9);
    local v13 = u9.skillInputData.releaseCF or HumanoidRootPart:GetPivot();
    local u14 = SkillCommon.resolveSummonFormationCF(v13, u12, {
        forwardOffsetStuds = u11.formationForwardOffset
    });

    local function doSummon() -- Line: 100
        -- upvalues: u9 (copy), UtilsSystem (ref), u11 (copy), u14 (copy), u12 (copy)
        if not u9:isRunningFlow() then
            return;
        end;

        local character2 = u9.skillInputData.character;

        if not (character2 and character2.Parent) then
            return;
        end;

        local SystemSummon = UtilsSystem.SystemSummon;

        if not (SystemSummon and SystemSummon.CreateNpcSummon) then
            return;
        end;

        SystemSummon.CreateNpcSummon(character2, u11.summonId, u14, {
            summonSkillKey = u11.summonSkillKey or u9.skillName,
            maxCount = u11.summonMaxCount,
            scale = u12,
            spawnGroundOffsetY = u11.spawnGroundOffsetY,
            spawnIntroDuration = u11.spawnIntroDuration,
            spawnIntroBelowOffsetY = u11.spawnIntroBelowOffset
        });
    end;

    local v15 = u11.spawnSummonDelay or 0;

    if v15 > 0 then
        task.delay(v15, doSummon);

        return;
    end;

    doSummon();
end;

function u1.clientEnterStartup(u16, p17) -- Line: 130
    -- upvalues: SkillCommon (copy), FXUtil (copy), u2 (copy)
    local character = u16.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    task.delay(0, function() -- Line: 140
        -- upvalues: u16 (copy), SkillCommon (ref), HumanoidRootPart (copy), FXUtil (ref)
        if not u16:isRunningFlow() then
            return;
        end;

        local skillRunData = u16.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local v18 = SkillCommon.npcSummonBodySkillScale(u16);
        local v19 = HumanoidRootPart:GetPivot();
        local v20 = skillRunData.material["召唤法阵A01_起手空间法阵_Emit"];

        if v20 then
            v20:ScaleTo(v18);
            v20:PivotTo(v19);
            v20.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(v20, true);
            SkillCommon.playSoundLocal3D("音效-召唤法术-通用法阵", v20:GetPivot().Position);
        end;
    end);
    local v21 = table.clone(u2);

    for i, v in pairs(p17) do
        v21[i] = v;
    end;

    task.delay(v21.startupSoundDelay or 1.4, function() -- Line: 162
        -- upvalues: SkillCommon (ref), HumanoidRootPart (copy)
        SkillCommon.playSoundLocal3D("音效-召唤法术-通用投掷", HumanoidRootPart:GetPivot().Position);
    end);
end;

function u1.clientEnterSummon(u22, p23) -- Line: 167
    -- upvalues: u2 (copy), SkillCommon (copy), playFormationL4Vfx (copy), FXUtil (copy), RunService (copy)
    local character = u22.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = u22.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    local u24 = table.clone(u2);

    for i, v in pairs(p23) do
        u24[i] = v;
    end;

    local material = skillRunData.material;
    local runGeneration = u22.runGeneration;
    local u25 = SkillCommon.npcSummonBodySkillScale(u22);

    local function stillSummon() -- Line: 186
        -- upvalues: u22 (copy), runGeneration (copy)
        local v26 = u22:isRunningFlow() and u22.runGeneration == runGeneration;

        return v26;
    end;

    local v27 = u22.skillInputData.releaseCF or HumanoidRootPart:GetPivot();
    local u28 = SkillCommon.resolveSummonFormationCF(v27, u25, {
        forwardOffsetStuds = u24.formationForwardOffset
    });
    local Position = u28.Position;
    local u29 = HumanoidRootPart:GetPivot() * CFrame.new(0, 1.5, -1);

    local function scheduleFormationL4() -- Line: 198
        -- upvalues: u24 (copy), u22 (copy), runGeneration (copy), material (copy), u25 (copy), Position (copy), playFormationL4Vfx (ref)
        task.delay(u24.formationL4PlayDelay, function() -- Line: 199
            -- upvalues: u22 (ref), runGeneration (ref), material (ref), u24 (ref), u25 (ref), Position (ref), playFormationL4Vfx (ref)
            local v30 = u22:isRunningFlow() and u22.runGeneration == runGeneration;

            if not v30 then
                return;
            end;

            local v31 = material[u24.formationVfxName];

            if not v31 then
                return;
            end;

            v31:ScaleTo(u25);
            v31:PivotTo(CFrame.new(Position) * v31:GetPivot().Rotation);
            v31.Parent = workspace.Debris;
            playFormationL4Vfx(v31, u24.formationL4EnableDuration);
        end);
    end;

    local v32 = material["召唤法阵A02_起手空间爆点_Emit"];

    if v32 then
        v32:ScaleTo(u25);
        v32:PivotTo(u29);
        v32.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v32, true);
    end;

    local u33 = material["召唤法阵A03_空间球_Enable"];

    if not u33 then
        task.delay(u24.formationL4PlayDelay, function() -- Line: 199
            -- upvalues: u22 (copy), runGeneration (copy), material (copy), u24 (copy), u25 (copy), Position (copy), playFormationL4Vfx (ref)
            local v34 = u22:isRunningFlow() and u22.runGeneration == runGeneration;

            if not v34 then
                return;
            end;

            local v35 = material[u24.formationVfxName];

            if not v35 then
                return;
            end;

            v35:ScaleTo(u25);
            v35:PivotTo(CFrame.new(Position) * v35:GetPivot().Rotation);
            v35.Parent = workspace.Debris;
            playFormationL4Vfx(v35, u24.formationL4EnableDuration);
        end);

        return;
    end;

    u33:ScaleTo(u25);
    u33:PivotTo(u29);
    u33.Parent = workspace.Debris;

    for _, descendant in u33:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            descendant.Enabled = true;
        end;
    end;

    local sphereFlyTime = u24.sphereFlyTime;
    local u36 = 0;
    skillRunData.runEvent = skillRunData.runEvent or {};
    skillRunData.runEvent["召唤空间球飞行"] = RunService.Heartbeat:Connect(function(p37) -- Line: 240
        -- upvalues: u22 (copy), runGeneration (copy), u36 (ref), sphereFlyTime (copy), u33 (copy), u29 (copy), u28 (copy), skillRunData (copy), material (copy), u25 (copy), scheduleFormationL4 (copy), FXUtil (ref), SkillCommon (ref), u24 (copy), Position (copy), playFormationL4Vfx (ref)
        local v38 = u22:isRunningFlow() and u22.runGeneration == runGeneration;

        if not v38 then
            return;
        end;

        u36 = u36 + p37;
        local v39 = math.clamp(u36 / sphereFlyTime, 0, 1);
        u33:PivotTo(u29:Lerp(u28, v39));

        if v39 >= 1 then
            local v40 = skillRunData.runEvent["召唤空间球飞行"];

            if v40 then
                v40:Disconnect();
                skillRunData.runEvent["召唤空间球飞行"] = nil;
            end;

            for _, descendant in u33:GetDescendants() do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
                    descendant.Enabled = false;
                end;
            end;

            local u41 = material["召唤法阵A04_空间爆发_Emit"];

            if u41 then
                u41:ScaleTo(u25);
                u41:PivotTo(CFrame.new(u28.Position));
                u41.Parent = workspace.Debris;
                local u42 = scheduleFormationL4;
                FXUtil.Emit_Particles_GetDescendants(u41, true);
                task.delay(0.5, function() -- Line: 72
                    -- upvalues: u41 (copy), u42 (copy)
                    if u41 and u41.Parent then
                        u42();
                    end;
                end);
                SkillCommon.playSoundLocal3D("音效-召唤法术-通用融合", u28.Position);
                SkillCommon.playSoundLocal3D("音效-召唤法术-召唤物的法阵圈1", u28.Position);
                task.delay(3, function() -- Line: 266
                    -- upvalues: SkillCommon (ref), u28 (ref)
                    SkillCommon.playSoundLocal3D("音效-召唤法术-通用法阵圈消散", u28.Position);
                end);

                return;
            end;

            task.delay(u24.formationL4PlayDelay, function() -- Line: 199
                -- upvalues: u22 (ref), runGeneration (ref), material (ref), u24 (ref), u25 (ref), Position (ref), playFormationL4Vfx (ref)
                local v43 = u22:isRunningFlow() and u22.runGeneration == runGeneration;

                if not v43 then
                    return;
                end;

                local v44 = material[u24.formationVfxName];

                if not v44 then
                    return;
                end;

                v44:ScaleTo(u25);
                v44:PivotTo(CFrame.new(Position) * v44:GetPivot().Rotation);
                v44.Parent = workspace.Debris;
                playFormationL4Vfx(v44, u24.formationL4EnableDuration);
            end);
        end;
    end);
end;

function u1.clientExitSummon(p45) -- Line: 276
    -- upvalues: SkillCommon (copy)
    local skillRunData = p45.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(skillRunData, { "召唤空间球飞行" });
    local v46 = skillRunData.material and skillRunData.material["召唤法阵A03_空间球_Enable"];

    if v46 and v46.Parent then
        for _, descendant in v46:GetDescendants() do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
                descendant.Enabled = false;
            end;
        end;
    end;
end;

function u1.attach(p47, p48) -- Line: 292
    -- upvalues: u2 (copy), u1 (copy)
    local u49 = table.clone(u2);

    for i, v in pairs(p48) do
        u49[i] = v;
    end;

    if u49.summonSkillKey then
        p47.summonSkillKey = u49.summonSkillKey;
    end;

    if u49.summonMaxCount then
        p47.summonMaxCount = u49.summonMaxCount;
    end;

    function p47.Server_EnterSummon(p50) -- Line: 301
        -- upvalues: u1 (ref), u49 (copy)
        u1.serverEnterSummon(p50, u49);
    end;

    function p47.Client_EnterSummon(p51) -- Line: 304
        -- upvalues: u1 (ref), u49 (copy)
        u1.clientEnterSummon(p51, u49);
    end;

    function p47.Client_ExitSummon(p52) -- Line: 307
        -- upvalues: u1 (ref)
        u1.clientExitSummon(p52);
    end;

    function p47.Client_EnterStartup(p53) -- Line: 310
        -- upvalues: u1 (ref), u49 (copy)
        u1.clientEnterStartup(p53, u49);
    end;
end;

return u1;