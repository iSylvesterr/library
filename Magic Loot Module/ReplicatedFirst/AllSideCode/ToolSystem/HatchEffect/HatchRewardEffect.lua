-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local UserInputService = game:GetService("UserInputService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local VisibleMgr = UtilsSystem.VisibleMgr;
local FXUtil = UtilsSystem.FXUtil;
local EnumMgr = UtilsSystem.EnumMgr;
local InsMgr = UtilsSystem.InsMgr;
local AnimationModule = UtilsSystem.AnimationModule;
local HatchConfig = require(script.Parent.HatchConfig);
local HatchAnimUtil = require(script.Parent.HatchAnimUtil);
local HatchCamera = require(script.Parent.HatchCamera);
local HatchSound = require(script.Parent.HatchSound);
local v1 = {};

local function _resolveMaxRarity(p2) -- Line: 44
    local v3 = 1;

    for _, v in ipairs(p2) do
        local v4 = v:GetAttribute("xyd");

        if v3 < v4 then
            v3 = v4;
        end;
    end;

    for _, v in ipairs(p2) do
        if v:GetAttribute("xyd") == v3 then
            v:SetAttribute("VFX", 1);

            return v3;
        end;
    end;

    return v3;
end;

local function _createOpenParticles(p5) -- Line: 68
    -- upvalues: HatchConfig (copy), HatchCamera (copy), EnumMgr (copy), VisibleMgr (copy)
    local v6 = HatchConfig.getOpenParticles();

    if not v6 then
        warn("缺少 Hatch/OPEN_particles 资源");

        return nil;
    end;

    local v7 = v6:Clone();
    v7.Parent = HatchCamera.getCamera();
    local v8 = HatchConfig.getGradientFolder();

    for _, descendant in pairs(v7:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            if p5 == EnumMgr.Rare.Xyd5 then
                VisibleMgr.RainBowParticle(descendant, 5);
            elseif p5 == EnumMgr.Rare.Xyd7 then
                VisibleMgr.SecretParticle(descendant, 5);
            else
                local v9;

                if v8 then
                    v9 = v8:FindFirstChild("稀有度底色" .. p5);
                else
                    v9 = v8;
                end;

                if v9 and v9:IsA("UIGradient") then
                    descendant.Color = v9.Color;
                end;
            end;

            descendant.Enabled = true;
            descendant:Emit((math.max(1, descendant.Rate / 2)));
            task.wait();
        end;
    end;

    return v7;
end;

local function _prepareHeroModels(p10) -- Line: 108
    -- upvalues: HatchCamera (copy), HatchConfig (copy), FXUtil (copy), VisibleMgr (copy)
    local v11 = HatchCamera.getCamera();
    local v12 = HatchConfig.getStarEmitter();
    local v13 = {};
    local v14 = {};

    for i, v in ipairs(p10) do
        local v15 = HatchConfig.REWARD_OFFSET[i];

        if v15 then
            for _, descendant in pairs(v:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CastShadow = false;
                    descendant.CanCollide = false;
                end;
            end;

            local v16 = v:FindFirstChildOfClass("Humanoid");

            if v16 then
                v16.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
                v16.HumanoidRootPart.Anchored = true;
            end;

            if i == 1 and v.PrimaryPart then
                local PointLight = Instance.new("PointLight");
                PointLight.Range = 5;
                PointLight.Brightness = 5;
                PointLight.Parent = v.PrimaryPart;
            end;

            if v.PrimaryPart and v12 then
                local v17 = v12:Clone();
                v17.Parent = v.PrimaryPart;
                FXUtil.Emit_Particles_GetDescendants(v17, true);
            end;

            local v18 = HatchCamera.getCameraCFrame();
            v:PivotTo(v18 - v:GetExtentsSize().Z * v18.LookVector);
            v.Parent = v11;
            VisibleMgr.UnCollideAll(v);
            v:ScaleTo(HatchConfig.DEFAULT_REWARD_SCALE);
            local v19 = v:GetExtentsSize().Y / HatchConfig.REWARD_SCREEN_RATIO / 2;
            local v20 = math.rad(v11.FieldOfView) / 2;
            local v21 = v19 / math.tan(v20);
            v14[i] = v;
            v13[i] = v15 + Vector3.new(0, 0, -v21 / HatchConfig.REWARD_DEPTH_DIVISOR);
        else
            warn("奖励偏移缺失，跳过序号", i);
        end;
    end;

    return v14, v13;
end;

local function _playIdleAnimations(p22) -- Line: 169
    -- upvalues: VisibleMgr (copy), InsMgr (copy), AnimationModule (copy)
    for _, v in pairs(p22) do
        local v23 = v:FindFirstChildOfClass("Humanoid");

        if v23 then
            VisibleMgr.UnAnchoredAll(v);
            v.PrimaryPart.Anchored = true;
            local v24 = InsMgr.GetIns("Animator", "Animator", v23);
            local v25 = v:GetAttribute("idle");

            if v25 then
                AnimationModule.PlayAnim(v24, v25);
            end;
        end;
    end;
end;

local function _syncHeroTransforms(p26, p27) -- Line: 192
    -- upvalues: HatchCamera (copy)
    for i, v in ipairs(p26.heroModelTable) do
        local v28 = p26.heroOffsetTable[i];

        if v28 then
            local v29 = HatchCamera.getCameraCFrame() * v28 * p27;
            v:PivotTo(v29);

            if v:GetAttribute("VFX") then
                p26.particleOfOpen:PivotTo(v29);
            end;
        end;
    end;
end;

local function _disconnectSkipInput(p30) -- Line: 213
    if p30.quitEvent then
        p30.quitEvent:Disconnect();
        p30.quitEvent = nil;
    end;
end;

local function _playEndPhase(u31) -- Line: 224
    -- upvalues: HatchAnimUtil (copy), HatchConfig (copy), _syncHeroTransforms (copy), HatchCamera (copy), Debris (copy)
    if u31.ended then
        return;
    end;

    if u31.quitEvent then
        u31.quitEvent:Disconnect();
        u31.quitEvent = nil;
    end;

    u31.ended = true;
    u31.waitSwitch = false;
    u31.rotateSwitch = false;
    HatchAnimUtil.runEasingLoop(HatchConfig.END_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.In, function(p32) -- Line: 238
        -- upvalues: _syncHeroTransforms (ref), u31 (copy), HatchConfig (ref)
        _syncHeroTransforms(u31, CFrame.new(0, p32 * HatchConfig.END_DROP_Y, HatchConfig.END_CAMERA_Z) * CFrame.Angles(0, math.rad(HatchConfig.END_YAW), 0));
    end);
    HatchCamera.restoreZoom();

    for _, v in pairs(u31.heroModelTable) do
        Debris:AddItem(v, 0);
    end;

    if u31.particleOfOpen then
        Debris:AddItem(u31.particleOfOpen, 0);
    end;
end;

local function _bindSkipInput(u33, u34) -- Line: 262
    -- upvalues: UserInputService (copy)
    u33.quitEvent = UserInputService.InputBegan:Connect(function(p35, p36) -- Line: 263
        -- upvalues: u33 (copy), u34 (copy)
        if p36 then
            return;
        end;

        if u33.ended then
            return;
        end;

        if p35.UserInputType == Enum.UserInputType.MouseButton1 or (p35.UserInputType == Enum.UserInputType.Touch or (p35.UserInputType == Enum.UserInputType.Gamepad1 or p35.UserInputType == Enum.UserInputType.Keyboard and p35.KeyCode == Enum.KeyCode.Q)) then
            local v37 = u33;

            if v37.quitEvent then
                v37.quitEvent:Disconnect();
                v37.quitEvent = nil;
            end;

            u34();
        end;
    end);
end;

local function _playRotatePhase(p38) -- Line: 286
    -- upvalues: HatchConfig (copy), TweenService (copy), HatchCamera (copy), RunService (copy), FXUtil (copy)
    local v39 = os.clock();
    local v40 = HatchConfig.ROTATE_DURATION * p38.speedScale;

    while p38.rotateSwitch do
        local v41 = (os.clock() - v39) / v40;
        local v42 = math.clamp(v41, 0, 1);
        local v43 = TweenService:GetValue(v42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
        local v44 = TweenService:GetValue(v42, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);

        for i, v in ipairs(p38.heroModelTable) do
            local v45 = p38.heroOffsetTable[i];

            if v45 then
                local v46 = HatchCamera.getCameraCFrame() * CFrame.new(0, 0, HatchConfig.REWARD_ROTATE_START_Z + HatchConfig.REWARD_ROTATE_MOVE_Z * v44) * v45 * CFrame.Angles(0, math.rad(v43 * 360), 0) * CFrame.Angles(0, 3.141592653589793, 0);
                v:PivotTo(v46);

                if v:GetAttribute("VFX") then
                    p38.particleOfOpen:PivotTo(v46);
                end;
            end;
        end;

        RunService.RenderStepped:Wait();

        if v42 >= 1 then
            FXUtil.Emit_Particles_GetDescendants(p38.particleOfOpen, false);

            return;
        end;
    end;
end;

local function _playWaitPhase(p47, p48, p49) -- Line: 328
    -- upvalues: HatchConfig (copy), HatchCamera (copy), RunService (copy)
    local v50 = os.clock();
    local v51 = HatchConfig.WAIT_DURATION * p47.speedScale;

    while p47.waitSwitch do
        local v52 = (os.clock() - v50) / v51;
        local v53 = math.clamp(v52, 0, 1);

        for i, v in ipairs(p47.heroModelTable) do
            local v54 = p47.heroOffsetTable[i];

            if v54 then
                local v55 = HatchCamera.getCameraCFrame() * CFrame.new(0, 0, HatchConfig.REWARD_WAIT_Z) * v54 * CFrame.Angles(0, math.rad(HatchConfig.END_YAW), 0);
                v:PivotTo(v55);

                if v:GetAttribute("VFX") then
                    p47.particleOfOpen:PivotTo(v55);
                end;
            end;
        end;

        RunService.RenderStepped:Wait();

        if p48 and v53 >= 1 then
            p49();
        end;
    end;
end;

function v1.play(p56, p57, p58) -- Line: 367
    -- upvalues: HatchCamera (copy), _resolveMaxRarity (copy), _createOpenParticles (copy), _prepareHeroModels (copy), Debris (copy), _playIdleAnimations (copy), HatchSound (copy), _playEndPhase (copy), UserInputService (copy), _playRotatePhase (copy), _playWaitPhase (copy)
    if #p56 == 0 then
        return;
    end;

    local v59 = p58 or false;
    HatchCamera.setZoomForHatch();
    local v60 = _resolveMaxRarity(p56);
    local v61 = _createOpenParticles(v60);

    if not v61 then
        HatchCamera.restoreZoom();

        return;
    end;

    local v62, v63 = _prepareHeroModels(p56);

    if #v62 == 0 then
        Debris:AddItem(v61, 0);
        HatchCamera.restoreZoom();

        return;
    end;

    _playIdleAnimations(v62);
    HatchSound.playResult(v60);
    local u64 = {
        rotateSwitch = true,
        waitSwitch = true,
        ended = false,
        quitEvent = nil,
        heroModelTable = v62,
        heroOffsetTable = v63,
        particleOfOpen = v61,
        speedScale = p57 or 1
    };

    local function endAnim() -- Line: 406
        -- upvalues: _playEndPhase (ref), u64 (copy)
        _playEndPhase(u64);
    end;

    if not v59 then
        u64.quitEvent = UserInputService.InputBegan:Connect(function(p65, p66) -- Line: 263
            -- upvalues: u64 (copy), endAnim (copy)
            if p66 then
                return;
            end;

            if u64.ended then
                return;
            end;

            if p65.UserInputType == Enum.UserInputType.MouseButton1 or (p65.UserInputType == Enum.UserInputType.Touch or (p65.UserInputType == Enum.UserInputType.Gamepad1 or p65.UserInputType == Enum.UserInputType.Keyboard and p65.KeyCode == Enum.KeyCode.Q)) then
                local v67 = u64;

                if v67.quitEvent then
                    v67.quitEvent:Disconnect();
                    v67.quitEvent = nil;
                end;

                endAnim();
            end;
        end);
    end;

    _playRotatePhase(u64);

    if u64.ended then
        return;
    end;

    _playWaitPhase(u64, v59, endAnim);
end;

return v1;