-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local VisibleMgr = UtilsSystem.VisibleMgr;
local FXUtil = UtilsSystem.FXUtil;
local HatchConfig = require(script.Parent.HatchConfig);
local HatchAnimUtil = require(script.Parent.HatchAnimUtil);
local HatchCamera = require(script.Parent.HatchCamera);
local HatchSound = require(script.Parent.HatchSound);
local u1 = Random.new();
local v2 = {};

local function _createStarModels(p3, p4) -- Line: 30
    -- upvalues: HatchConfig (copy), HatchCamera (copy), VisibleMgr (copy)
    local v5 = HatchConfig.getStarParticles();

    if not v5 then
        warn("缺少 Hatch/star_particles 资源");

        return nil, nil;
    end;

    local v6 = HatchCamera.getCamera();
    local v7 = {};
    local v8 = {};

    for i = 1, p4 do
        local v9 = p3:Clone();
        local v10 = v5:Clone();
        v9.Parent = v6;
        v10:PivotTo(v9:GetPivot());
        v10.Parent = v9;
        VisibleMgr.UnCollideAll(v9);
        VisibleMgr.AnchoredAll(v9);
        v9:ScaleTo(HatchConfig.DEFAULT_SCALE);
        v9:SetAttribute("OriScale", v9:GetScale());

        if i == 1 and v9.PrimaryPart then
            local PointLight = Instance.new("PointLight");
            PointLight.Range = 5;
            PointLight.Brightness = 5;
            PointLight.Parent = v9.PrimaryPart;
        end;

        v7[i] = v9;
        v8[i] = HatchConfig.STAR_OFFSET[i] * CFrame.Angles(0, 3.141592653589793, 0);
    end;

    return v7, v8;
end;

local function _playFall(u11, u12, p13) -- Line: 73
    -- upvalues: HatchSound (copy), HatchAnimUtil (copy), HatchConfig (copy), HatchCamera (copy)
    HatchSound.play("抽蛋_掉落");
    HatchAnimUtil.runEasingLoop(HatchConfig.FALL_TIME * p13, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, function(p14) -- Line: 79
        -- upvalues: HatchCamera (ref), u11 (copy), HatchConfig (ref), u12 (copy)
        local v15 = HatchCamera.getCameraCFrame();

        for i, v in ipairs(u11) do
            v:PivotTo(v15:ToWorldSpace(CFrame.new(0, HatchConfig.FALL_DISTANCE - p14 * HatchConfig.FALL_DISTANCE, HatchConfig.CONTAINER_DISTANCE_FROM_CAMERA + p14 * HatchConfig.FALL_DISTANCE) * u12[i]));
        end;
    end);
end;

local function _playShake(u16, u17, p18) -- Line: 102
    -- upvalues: HatchConfig (copy), FXUtil (copy), HatchSound (copy), u1 (copy), HatchAnimUtil (copy), HatchCamera (copy)
    local u19 = CFrame.new(0, 0, HatchConfig.BOX_SHAKE_OFFSET_Z);

    for i = 1, HatchConfig.SHAKE_COUNT do
        for _, v in pairs(u16) do
            FXUtil.Emit_Particles_GetDescendants(v.star_particles, true);
        end;

        local v20 = HatchConfig.SHAKE_SOUND_NAMES[i];

        if v20 then
            HatchSound.play(v20);
        end;

        local u21 = i % 2 == 0 and u1:NextNumber(-45, -25) or u1:NextNumber(25, 45);
        local v22 = 1 / math.max(i * 6, 10) * p18;
        HatchAnimUtil.runEasingLoop(v22, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, function(p23) -- Line: 120
            -- upvalues: HatchCamera (ref), u16 (copy), u19 (copy), u17 (copy), u21 (copy)
            local v24 = HatchCamera.getCameraCFrame();

            for i2, v in ipairs(u16) do
                v:PivotTo(v24 * u19 * u17[i2] * CFrame.new(0.1 * p23, 0, 0) * CFrame.Angles(0, 0, (math.rad(u21 * p23))));
            end;
        end);
        local v25 = HatchConfig.SHAKE_RESTORE_STEP / math.max(i * 0.7, 1) * p18;
        HatchAnimUtil.runEasingLoop(v25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function(p26) -- Line: 134
            -- upvalues: HatchCamera (ref), u16 (copy), u19 (copy), u17 (copy), u21 (copy)
            local v27 = HatchCamera.getCameraCFrame();

            for i2, v in ipairs(u16) do
                v:PivotTo(v27 * u19 * u17[i2] * CFrame.new(0.1 - 0.1 * p26, 0, 0) * CFrame.Angles(0, 0, (math.rad(u21 - p26 * u21))));
            end;
        end);
    end;

    HatchAnimUtil.runEasingLoop(HatchConfig.RESTORE_TIME * p18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function(p28) -- Line: 148
        -- upvalues: HatchCamera (ref), u16 (copy), u19 (copy), u17 (copy)
        local v29 = HatchCamera.getCameraCFrame();

        for i, v in ipairs(u16) do
            v:ScaleTo(v:GetAttribute("OriScale") * (1 - p28 * 0.8));
            v:PivotTo(v29 * u19 * u17[i]);
        end;
    end);
end;

local function _playEnlargeAndDestroy(u30, u31, p32) -- Line: 163
    -- upvalues: HatchConfig (copy), HatchSound (copy), HatchAnimUtil (copy), HatchCamera (copy), Debris (copy)
    local u33 = CFrame.new(0, 0, HatchConfig.BOX_SHAKE_OFFSET_Z);
    HatchSound.play("抽蛋_放大");
    HatchAnimUtil.runEasingLoop(HatchConfig.ENLARGE_TIME * p32, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, function(p34) -- Line: 167
        -- upvalues: HatchCamera (ref), u30 (copy), u33 (copy), u31 (copy)
        local v35 = HatchCamera.getCameraCFrame();

        for i, v in ipairs(u30) do
            v:ScaleTo(v:GetAttribute("OriScale") * (1 + p34 * 1.5));
            v:PivotTo(v35 * u33 * u31[i]);
        end;
    end);

    for _, v in ipairs(u30) do
        Debris:AddItem(v, 0);
    end;
end;

function v2.play(p36, p37, p38) -- Line: 187
    -- upvalues: HatchConfig (copy), HatchCamera (copy), _createStarModels (copy), HatchSound (copy), HatchAnimUtil (copy), _playShake (copy), _playEnlargeAndDestroy (copy)
    local v39 = p38 or 1;
    local v40 = math.clamp(p37, 1, HatchConfig.MAX_HATCH_TIME);
    HatchCamera.setZoomForHatch();
    local u41, u42 = _createStarModels(p36, v40);

    if not (u41 and u42) then
        HatchCamera.restoreZoom();

        return false;
    end;

    HatchSound.play("抽蛋_掉落");
    HatchAnimUtil.runEasingLoop(HatchConfig.FALL_TIME * v39, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, function(p43) -- Line: 79
        -- upvalues: HatchCamera (ref), u41 (copy), HatchConfig (ref), u42 (copy)
        local v44 = HatchCamera.getCameraCFrame();

        for i, v in ipairs(u41) do
            v:PivotTo(v44:ToWorldSpace(CFrame.new(0, HatchConfig.FALL_DISTANCE - p43 * HatchConfig.FALL_DISTANCE, HatchConfig.CONTAINER_DISTANCE_FROM_CAMERA + p43 * HatchConfig.FALL_DISTANCE) * u42[i]));
        end;
    end);
    _playShake(u41, u42, v39);
    _playEnlargeAndDestroy(u41, u42, v39);

    return true;
end;

return v2;