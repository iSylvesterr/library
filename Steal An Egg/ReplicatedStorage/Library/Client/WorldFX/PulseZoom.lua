-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");

local function mergeTables(p1, ...) -- Line: 8
    local v2 = {};

    for _, v in { p1, ... } do
        for i, v3 in v do
            v2[i] = v3;
        end;
    end;

    return v2;
end;

local function evalNumberSequence(p3, p4) -- Line: 18
    if p4 == 0 then
        return p3.Keypoints[1].Value;
    end;

    if p4 == 1 then
        return p3.Keypoints[#p3.Keypoints].Value;
    end;

    for i = 1, #p3.Keypoints - 1 do
        local v5 = p3.Keypoints[i];
        local v6 = p3.Keypoints[i + 1];

        if v5.Time <= p4 and p4 < v6.Time then
            return v5.Value + (v6.Value - v5.Value) * ((p4 - v5.Time) / (v6.Time - v5.Time));
        end;
    end;

    return 0;
end;

local u9 = (function(p7) -- Line: 36, Name: decompressFilter
    -- upvalues: HttpService (copy)
    local v8 = {};

    for i, v in HttpService:JSONDecode(p7) do
        v8[i] = {};

        for i2, v2 in v do
            v8[i][i2] = {};

            for _, v3 in v2 do
                table.insert(v8[i][i2], NumberSequenceKeypoint.new(v3[1], v3[2]));
            end;

            v8[i][i2] = NumberSequence.new(v8[i][i2]);
        end;
    end;

    return v8;
end)("{\"Bloom\":{\"Threshold\":[[0,5],[1,5]]},\"Camera\":{\"RotationZ\":[[0,0.537],[0.07,0.537],[0.199,0.474],[0.301,0.512],[0.499,0.5],[1,0.5]],\"Multiplier\":[[0,0.256],[0.102,0.243],[0.5,0.5],[1,0.5]],\"RotationY\":[[0,0.5],[1,0.5]]},\"Blur\":{\"Size\":[[0,1],[0.198,1],[0.5,0],[1,0]]},\"ColorCorrection\":{\"Contrast\":[[0,1],[0.098,1],[0.701,0],[1,0]],\"Brightness\":[[0,0.45],[0.1,0.45],[0.293,0],[1,0]]}}");

local function renderCameraSequence(p10, p11, p12, p13) -- Line: 56
    -- upvalues: evalNumberSequence (copy)
    local v14 = 0;
    local v15 = 0;
    local v16 = 1;
    local Camera = p13.Camera;

    if Camera then
        if Camera.RotationZ then
            v14 = (evalNumberSequence(Camera.RotationZ, p10) - 0.5) * 180;
        end;

        if Camera.RotationY then
            v15 = (evalNumberSequence(Camera.RotationY, p10) - 0.5) * 180;
        end;

        if Camera.Multiplier then
            v16 = 1 + (evalNumberSequence(Camera.Multiplier, p10) - 0.5);
        end;
    end;

    return p12 * CFrame.Angles(math.rad(v15), 0, 0) * CFrame.Angles(0, 0, (math.rad(v14))), p11 * v16;
end;

local function applyBloomSettings(p17, p18) -- Line: 77
    -- upvalues: evalNumberSequence (copy)
    local v19 = 0;
    local v20 = 2;
    local v21 = 0;
    local v22 = 0;
    local v23 = 0;
    local v24 = 0;

    if p18.Bloom then
        if p18.Bloom.Threshold then
            v20 = 2 * evalNumberSequence(p18.Bloom.Threshold, p17);
        end;

        if p18.Bloom.Size then
            v19 = evalNumberSequence(p18.Bloom.Size, p17);
        end;
    end;

    if p18.Blur and p18.Blur.Size then
        v21 = 24 * evalNumberSequence(p18.Blur.Size, p17);
    end;

    if p18.ColorCorrection then
        if p18.ColorCorrection.Brightness then
            v22 = evalNumberSequence(p18.ColorCorrection.Brightness, p17);
        end;

        if p18.ColorCorrection.Contrast then
            v23 = evalNumberSequence(p18.ColorCorrection.Contrast, p17);
        end;

        if p18.ColorCorrection.Saturation then
            v24 = evalNumberSequence(p18.ColorCorrection.Saturation, p17);
        end;
    end;

    return {
        bloomSize = v19,
        bloomThreshold = v20,
        blur = v21,
        brightness = v22,
        contrast = v23,
        saturation = v24
    };
end;

local function pulseZoomTransform(p25, p26, p27, p28) -- Line: 120
    -- upvalues: renderCameraSequence (copy), u9 (copy), applyBloomSettings (copy), mergeTables (copy)
    if not p28 then
        return {};
    end;

    local u29 = math.clamp(p26 % 0.4 / 0.4, 0, 1);

    return mergeTables({
        cameraCFrameOverwriteFunction = function(p30, p31) -- Line: 130, Name: cameraCFrameOverwriteFunction
            -- upvalues: renderCameraSequence (ref), u29 (copy), u9 (ref)
            local v32, v33 = renderCameraSequence(u29, p31, p30, u9);

            return v32, v33;
        end
    }, (applyBloomSettings(u29, u9)));
end;

local u34 = {
    connection = nil,
    startTime = 0,
    colorCorrection = nil,
    bloom = nil,
    blur = nil,
    previousCameraOverride = nil,
    useGlobalCameraOverride = false,
    baseCameraCFrame = nil,
    baseFieldOfView = nil,
    lastPulseIndex = -1,
    onPulseEnd = nil
};

local function ensureLightingEffects() -- Line: 154
    -- upvalues: u34 (copy), Lighting (copy)
    if not u34.colorCorrection then
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect.Name = "PulseZoomColorCorrection";
        ColorCorrectionEffect.Parent = Lighting;
        u34.colorCorrection = ColorCorrectionEffect;
    end;

    if not u34.bloom then
        local BloomEffect = Instance.new("BloomEffect");
        BloomEffect.Name = "PulseZoomBloom";
        BloomEffect.Parent = Lighting;
        u34.bloom = BloomEffect;
    end;

    if not u34.blur then
        local BlurEffect = Instance.new("BlurEffect");
        BlurEffect.Name = "PulseZoomBlur";
        BlurEffect.Parent = Lighting;
        u34.blur = BlurEffect;
    end;
end;

local function clearLightingEffects() -- Line: 175
    -- upvalues: u34 (copy)
    if u34.colorCorrection then
        u34.colorCorrection:Destroy();
        u34.colorCorrection = nil;
    end;

    if u34.bloom then
        u34.bloom:Destroy();
        u34.bloom = nil;
    end;

    if u34.blur then
        u34.blur:Destroy();
        u34.blur = nil;
    end;
end;

local function applyLightingSettings(p35) -- Line: 190
    -- upvalues: u34 (copy)
    if u34.colorCorrection then
        u34.colorCorrection.Brightness = p35.brightness or 0;
        u34.colorCorrection.Contrast = p35.contrast or 0;
        u34.colorCorrection.Saturation = p35.saturation or 0;
    end;

    if u34.bloom then
        u34.bloom.Intensity = 1;
        u34.bloom.Size = p35.bloomSize or 24;
        u34.bloom.Threshold = p35.bloomThreshold or 2;
    end;

    if u34.blur then
        u34.blur.Size = p35.blur or 0;
    end;
end;

local function applyCameraSettings(p36, p37, p38, p39) -- Line: 206
    if not p37 then
        return;
    end;

    local cameraCFrameOverwriteFunction = p36.cameraCFrameOverwriteFunction;

    if cameraCFrameOverwriteFunction then
        local v40, v41 = cameraCFrameOverwriteFunction(p38 or p37.CFrame, p39 or p37.FieldOfView);

        if v40 then
            p37.CFrame = v40;
        end;

        if v41 then
            p37.FieldOfView = v41;
        end;
    end;
end;

return {
    Play = function(p42) -- Line: 225, Name: Play
        -- upvalues: u34 (copy), ensureLightingEffects (copy), RunService (copy), pulseZoomTransform (copy), applyLightingSettings (copy), Workspace (copy)
        if u34.connection then
            return;
        end;

        local u43 = p42 or {};
        local u44 = u43.applyLighting == nil and true or u43.applyLighting;
        local u45 = u43.useGlobalCameraOverride == true;
        local u46;

        if u43.applyCamera == nil then
            u46 = not u45;
        else
            u46 = u43.applyCamera;
        end;

        u34.startTime = tick();
        u34.useGlobalCameraOverride = u45;
        u34.baseCameraCFrame = nil;
        u34.baseFieldOfView = nil;
        u34.lastPulseIndex = -1;
        u34.onPulseEnd = u43.onPulseEnd;

        if u44 then
            ensureLightingEffects();
        end;

        if u45 then
            u34.previousCameraOverride = _G.cameraCFrameOverwriteFunction;
        end;

        u34.connection = RunService.RenderStepped:Connect(function() -- Line: 247
            -- upvalues: u34 (ref), pulseZoomTransform (ref), u44 (copy), applyLightingSettings (ref), u45 (copy), u46 (copy), u43 (copy), Workspace (ref)
            local v47 = tick() - u34.startTime;
            local v48 = math.floor(v47 / 0.4);

            if v48 ~= u34.lastPulseIndex then
                if u34.lastPulseIndex >= 0 and u34.onPulseEnd then
                    u34.onPulseEnd();
                end;

                u34.lastPulseIndex = v48;
            end;

            local v49 = pulseZoomTransform(nil, v47, nil, true);

            if u44 then
                applyLightingSettings(v49);
            end;

            if u45 then
                _G.cameraCFrameOverwriteFunction = v49.cameraCFrameOverwriteFunction;

                return;
            end;

            if u46 then
                local v50 = u43.camera or Workspace.CurrentCamera;

                if v50 and not u34.baseCameraCFrame then
                    u34.baseCameraCFrame = v50.CFrame;
                    u34.baseFieldOfView = v50.FieldOfView;
                end;

                local baseCameraCFrame = u34.baseCameraCFrame;
                local baseFieldOfView = u34.baseFieldOfView;

                if not v50 then
                    return;
                end;

                local cameraCFrameOverwriteFunction = v49.cameraCFrameOverwriteFunction;

                if cameraCFrameOverwriteFunction then
                    local v51, v52 = cameraCFrameOverwriteFunction(baseCameraCFrame or v50.CFrame, baseFieldOfView or v50.FieldOfView);

                    if v51 then
                        v50.CFrame = v51;
                    end;

                    if v52 then
                        v50.FieldOfView = v52;
                    end;
                end;
            end;
        end);
    end,

    Stop = function() -- Line: 273, Name: Stop
        -- upvalues: u34 (copy)
        if u34.connection then
            u34.connection:Disconnect();
            u34.connection = nil;
        end;

        if u34.useGlobalCameraOverride then
            _G.cameraCFrameOverwriteFunction = u34.previousCameraOverride;
            u34.previousCameraOverride = nil;
            u34.useGlobalCameraOverride = false;
        end;

        u34.baseCameraCFrame = nil;
        u34.baseFieldOfView = nil;
        u34.lastPulseIndex = -1;
        u34.onPulseEnd = nil;

        if u34.colorCorrection then
            u34.colorCorrection:Destroy();
            u34.colorCorrection = nil;
        end;

        if u34.bloom then
            u34.bloom:Destroy();
            u34.bloom = nil;
        end;

        if u34.blur then
            u34.blur:Destroy();
            u34.blur = nil;
        end;
    end,

    transform = pulseZoomTransform
};