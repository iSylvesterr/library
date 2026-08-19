-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local AssetPaths = UtilsSystem.AssetPaths;
local AssetRegistry = UtilsSystem.AssetRegistry;
local BezierCurve = UtilsSystem.BezierCurve;
local FXUtil = UtilsSystem.FXUtil;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SoundModule = UtilsSystem.SoundModule;
local u1 = {};
local Action4 = Enum.AnimationPriority.Action4;
local u2 = {
    {
        animName = "魔法弹1",
        startupResName = "普攻一段起手",
        trailResName = "普攻魔杖尾迹",
        projectileResName = "普攻魔法弹",
        explosionResName = "普攻爆炸",
        explosionLightResName = "普攻爆炸灯",
        castSound = "玩家普攻-施法1",
        flySound = "玩家普攻-飞行1",
        expSound = "玩家普攻-爆炸1",
        bezierSeed = 10000,
        startupDuration = 0.2,
        maxFlyTime = 0.5,
        flySpeed = 200,
        nearEndWaitSec = 0.47
    },
    {
        animName = "魔法弹2",
        startupResName = "普攻二段起手",
        trailResName = "普攻魔杖尾迹",
        projectileResName = "普攻魔法弹",
        explosionResName = "普攻爆炸",
        explosionLightResName = "普攻爆炸灯",
        castSound = "玩家普攻-施法2",
        flySound = "玩家普攻-飞行2",
        expSound = "玩家普攻-爆炸2",
        bezierSeed = 20004,
        startupDuration = 0.15,
        maxFlyTime = 0.5,
        flySpeed = 200,
        nearEndWaitSec = 0.43
    },
    {
        animName = "魔法弹3",
        startupResName = "普攻三段起手",
        trailResName = "普攻魔杖尾迹",
        projectileResName = "普攻魔法弹",
        explosionResName = "普攻爆炸",
        explosionLightResName = "普攻爆炸灯",
        castSound = "玩家普攻-施法3",
        flySound = "玩家普攻-飞行3",
        expSound = "玩家普攻-爆炸3",
        bezierSeed = 30000,
        startupDuration = 0.13,
        maxFlyTime = 0.5,
        flySpeed = 200,
        nearEndWaitSec = 0.78
    }
};

local function _cloneStageWithAnim(p3, p4, p5) -- Line: 115
    local v6 = table.clone(p3);
    v6.animName = p4;

    if type(p5) == "number" and p5 > 0 then
        v6.nearEndWaitSec = p5;
    end;

    return v6;
end;

local u7 = {};
local v8 = table.clone(u2[2]);
v8.animName = "骑扫帚训练1";
v8.nearEndWaitSec = 0.43;
local v9 = table.clone(u2[3]);
v9.animName = "骑扫帚训练2";
v9.nearEndWaitSec = 1;
u7[1], u7[2] = v8, v9;

local function _cloneSkillModel(p10) -- Line: 150
    -- upvalues: AssetPaths (copy), AssetRegistry (copy)
    local v11 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, p10));

    if v11 and v11:IsA("Model") then
        return v11:Clone();
    end;

    return nil;
end;

local function _resolveWandTipCF(p12) -- Line: 164
    local v13 = p12:FindFirstChild("当前手持");

    if v13 then
        v13 = v13:FindFirstChildOfClass("Model");
    end;

    if v13 then
        v13 = v13:FindFirstChild("魔杖尖端");
    end;

    if not v13 then
        return nil;
    end;

    if v13:IsA("BasePart") then
        return v13:GetPivot();
    end;

    if v13:IsA("Model") then
        return v13:GetPivot();
    end;

    if v13:IsA("Attachment") then
        return v13.WorldCFrame;
    end;

    return nil;
end;

local function _resolveWandTipInst(p14) -- Line: 189
    local v15 = p14:FindFirstChild("当前手持");

    if v15 then
        v15 = v15:FindFirstChildOfClass("Model");
    end;

    if v15 then
        v15 = v15:FindFirstChild("魔杖尖端");
    end;

    return v15;
end;

local function _applyProjectileSpawnVisual(p16) -- Line: 201
    -- upvalues: FXUtil (copy)
    local v17 = p16:FindFirstChild("灯");

    if v17 then
        v17 = v17:FindFirstChild("PointLight");
    end;

    if v17 and v17:IsA("PointLight") then
        v17.Brightness = 0;
        FXUtil.Tween_Instance(v17, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Brightness = 0.3
        });
    end;

    local v18 = p16:FindFirstChild("Enabled1_普攻1");
    local v19;

    if v18 then
        v19 = v18:FindFirstChild("Enabled1_L_1");
    else
        v19 = v18;
    end;

    if v18 then
        v18 = v18:FindFirstChild("Enabled1_R_1");
    end;

    if v19 and (v18 and (v19:IsA("Attachment") and v18:IsA("Attachment"))) then
        FXUtil.Tween_Attachment_CFrame(v19, v18, 0.3, Vector3.new(0, 0, 1.89));
    end;

    FXUtil.Start_All_Emit(p16, 2);

    for _, descendant in p16:GetDescendants() do
        if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true;
        end;
    end;

    return nil;
end;

local function _fadeOutProjectile(p20) -- Line: 233
    -- upvalues: FXUtil (copy), Debris (copy)
    if not p20.Parent then
        return nil;
    end;

    FXUtil.Stop_All_Emit(p20);

    for _, descendant in p20:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;
    end;

    Debris:AddItem(p20, 0.2);

    return nil;
end;

local function _playExplosion(p21, p22, p23) -- Line: 255
    -- upvalues: AssetPaths (copy), AssetRegistry (copy), FXUtil (copy), Debris (copy), SoundModule (copy), _fadeOutProjectile (copy)
    local v24 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, p22.explosionResName));
    local v25;

    if v24 and v24:IsA("Model") then
        v25 = v24:Clone();
    else
        v25 = nil;
    end;

    if v25 then
        v25.Parent = workspace.Debris;
        v25:PivotTo(p21);
        FXUtil.Emit_Particles_GetDescendants(v25, true);
        Debris:AddItem(v25, 2);
    end;

    SoundModule:PlaySoundLocal({
        Is2D = false,
        SoundName = p22.expSound,
        PlayPosition = p21.Position
    });

    if p23 and p23.Parent then
        _fadeOutProjectile(p23);
    end;

    return nil;
end;

local function _flyProjectile(u26, p27, p28, u29, u30, u31) -- Line: 287
    -- upvalues: BezierCurve (copy), _playExplosion (copy), _fadeOutProjectile (copy)
    local Position = p27.Position;
    local Position2 = p28.Position;
    local v32 = tonumber(u29.flySpeed) or 200;
    local v33 = tonumber(u29.maxFlyTime) or 0.5;
    local v34 = tonumber(u29.bezierSeed) or 10000;
    local Magnitude = (Position2 - Position).Magnitude;
    local v35 = math.min(Magnitude / v32, v33);

    if Magnitude > 0.0001 and v35 * v32 < Magnitude then
        Position2 = Position + (Position2 - Position).Unit * (v35 * v32);
    end;

    local v36 = BezierCurve.GenerateBezierPoints(Position, Position2, 8, {
        HeightOffsetRandom = 0,
        RandomSeed = v34,
        SideOffsetRandom = math.min((Position2 - Position).Magnitude * 0.1, 16),
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });
    local u37 = CFrame.new(Position2);
    BezierCurve.MultiOrderBezierCurves({
        FPS = 60,
        Frame = (v35 < 0.001 and 0.001 or v35) * 60,
        Points = v36,
        Target = u26,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, function() -- Line: 326
        -- upvalues: u26 (copy), u37 (copy), u30 (copy), _playExplosion (ref), u29 (copy), _fadeOutProjectile (ref), u31 (copy)
        local v38;

        if u26.Parent then
            v38 = u26:GetPivot();
        else
            v38 = u37;
        end;

        if u30 then
            _playExplosion(v38, u29, u26);
        else
            _fadeOutProjectile(u26);
        end;

        if u31 then
            u31(v38);
        end;
    end);

    return nil;
end;

local function _isLocalOnBroom() -- Line: 345
    -- upvalues: GetData (copy), LocalPlayer (copy)
    return GetData.GetIsFly(LocalPlayer);
end;

local function _getActiveStages() -- Line: 354
    -- upvalues: GetData (copy), LocalPlayer (copy), u7 (copy), u2 (copy)
    if GetData.GetIsFly(LocalPlayer) then
        return u7;
    end;

    return u2;
end;

local function _stopOtherBroomTrainAnims(p39, p40) -- Line: 368
    -- upvalues: u7 (copy), AnimationModule (copy)
    for _, v in ipairs(u7) do
        local animName = v.animName;

        if type(animName) == "string" and animName ~= p40 then
            AnimationModule.StopAnim(p39, animName, 0);
        end;
    end;

    return nil;
end;

local function _playStageAnim(p41, p42, p43) -- Line: 386
    -- upvalues: _stopOtherBroomTrainAnims (copy), AnimationModule (copy), Action4 (copy)
    local animName = p42.animName;

    if type(animName) ~= "string" or animName == "" then
        return nil;
    end;

    if p43 then
        _stopOtherBroomTrainAnims(p41, animName);
    end;

    return AnimationModule.PlayAnim(p41, animName, 1, nil, nil, Action4, p43 and 0 or 0.1);
end;

function u1.GetNearEndWaitSec(p44) -- Line: 414
    -- upvalues: GetData (copy), LocalPlayer (copy), u7 (copy), u2 (copy)
    local v45;

    if GetData.GetIsFly(LocalPlayer) then
        v45 = u7;
    else
        v45 = u2;
    end;

    local v46 = math.floor(p44);
    local v47 = v45[math.clamp(v46, 1, #v45)];
    local v48;

    if v47 then
        v48 = v47.nearEndWaitSec;
    else
        v48 = v47;
    end;

    local v49 = tonumber(v48);

    if type(v49) == "number" and v49 > 0 then
        return v49;
    end;

    local v50;

    if v47 then
        v50 = v47.startupDuration;
    else
        v50 = v47;
    end;

    local v51 = tonumber(v50) or 0;

    if v47 then
        v47 = v47.maxFlyTime;
    end;

    local v52 = tonumber(v47) or 0.5;

    return math.max(0.05, v51 + v52);
end;

function u1.GetChainWaitSec(p53) -- Line: 432
    -- upvalues: u1 (copy)
    return u1.GetNearEndWaitSec(p53);
end;

function u1.GetStageCount() -- Line: 441
    -- upvalues: GetData (copy), LocalPlayer (copy), u7 (copy), u2 (copy)
    local v54;

    if GetData.GetIsFly(LocalPlayer) then
        v54 = u7;
    else
        v54 = u2;
    end;

    return #v54;
end;

function u1.PlayStrike(u55) -- Line: 451
    -- upvalues: GetData (copy), LocalPlayer (copy), u7 (copy), u2 (copy), u1 (copy), _stopOtherBroomTrainAnims (copy), AnimationModule (copy), Action4 (copy), _resolveWandTipCF (copy), SoundModule (copy), AssetPaths (copy), AssetRegistry (copy), RunService (copy), Debris (copy), FXUtil (copy), _applyProjectileSpawnVisual (copy), _flyProjectile (copy)
    if type(u55) ~= "table" then
        return nil;
    end;

    local character = u55.character;

    if not (character and character.Parent) then
        return nil;
    end;

    local goalCF = u55.goalCF;

    if typeof(goalCF) ~= "CFrame" then
        return nil;
    end;

    local v56 = GetData.GetIsFly(LocalPlayer);
    local v57;

    if v56 then
        v57 = u7;
    else
        v57 = u2;
    end;

    local v58 = tonumber(u55.stageIndex) or 1;
    local v59 = math.floor(v58);
    local v60 = math.clamp(v59, 1, #v57);
    local u61 = v57[v60];
    local u62 = u55.playExplosion ~= false;
    local v63 = u1.GetNearEndWaitSec(v60);
    local v64 = character:FindFirstChildOfClass("Humanoid");

    if v64 then
        v64 = v64:FindFirstChildOfClass("Animator");
    end;

    if v64 then
        local animName = u61.animName;
        local v65;

        if type(animName) == "string" and animName ~= "" then
            if v56 then
                _stopOtherBroomTrainAnims(v64, animName);
            end;

            v65 = AnimationModule.PlayAnim(v64, animName, 1, nil, nil, Action4, v56 and 0 or 0.1);
        else
            v65 = nil;
        end;

        if v56 and (type(v65) == "number" and v65 > 0) then
            v63 = v65 / 1;
        end;
    end;

    local v66 = character:FindFirstChild("当前手持");
    local u67 = v66 and v66:FindFirstChildOfClass("Model");

    if u67 then
        u67 = u67:FindFirstChild("魔杖尖端");
    end;

    local u68 = _resolveWandTipCF(character);

    if not u68 then
        local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            u68 = HumanoidRootPart.CFrame;
        end;
    end;

    if not u68 then
        return {
            nearEndWaitSec = v63,
            stageIndex = v60
        };
    end;

    SoundModule:PlaySoundLocal({
        Is2D = false,
        SoundName = u61.castSound,
        PlayPosition = u68.Position
    });
    local v69 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, u61.trailResName));
    local u70;

    if v69 and v69:IsA("Model") then
        u70 = v69:Clone();
    else
        u70 = nil;
    end;

    local u71 = nil;

    if u70 then
        u70.Parent = workspace.Debris;

        for _, descendant in u70:GetDescendants() do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        if u67 then
            u71 = RunService.RenderStepped:Connect(function() -- Line: 509
                -- upvalues: u70 (copy), u67 (copy), _resolveWandTipCF (ref), character (copy)
                if not (u70.Parent and u67.Parent) then
                    return;
                end;

                local v72 = _resolveWandTipCF(character);

                if v72 then
                    u70:PivotTo(v72);
                end;
            end);
        end;

        Debris:AddItem(u70, (tonumber(u61.startupDuration) or 0) + 1.5);
    end;

    local v73 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, u61.startupResName));
    local v74;

    if v73 and v73:IsA("Model") then
        v74 = v73:Clone();
    else
        v74 = nil;
    end;

    if v74 then
        v74:PivotTo(u68);
        v74.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v74, true);
        Debris:AddItem(v74, 1.2);
    end;

    local v75 = tonumber(u61.startupDuration) or 0;
    task.delay(v75, function() -- Line: 531
        -- upvalues: u71 (ref), u70 (copy), character (copy), _resolveWandTipCF (ref), u68 (ref), u61 (copy), AssetPaths (ref), AssetRegistry (ref), u55 (copy), goalCF (copy), _applyProjectileSpawnVisual (ref), SoundModule (ref), _flyProjectile (ref), u62 (copy)
        if u71 then
            u71:Disconnect();
            u71 = nil;
        end;

        if u70 and u70.Parent then
            for _, descendant in u70:GetDescendants() do
                if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end;

        if not character.Parent then
            return;
        end;

        local v76 = _resolveWandTipCF(character) or u68;
        local v77 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, u61.projectileResName));
        local v78;

        if v77 and v77:IsA("Model") then
            v78 = v77:Clone();
        else
            v78 = nil;
        end;

        if not v78 then
            if u55.onLanded then
                u55.onLanded(goalCF);
            end;

            return;
        end;

        v78.Parent = workspace.Debris;
        v78:PivotTo(v76);
        _applyProjectileSpawnVisual(v78);
        SoundModule:PlaySoundLocal({
            Is2D = false,
            SoundName = u61.flySound,
            PlayPosition = v76.Position
        });
        _flyProjectile(v78, v76, goalCF, u61, u62, u55.onLanded);
    end);

    return {
        nearEndWaitSec = v63,
        stageIndex = v60
    };
end;

return u1;