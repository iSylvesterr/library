-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local SequenceManager = UtilsSystem.SequenceManager;
local v1 = {};
local u2 = {
    {
        name = "Main",
        frameDuration = 2.4,
        startFrame = 1,
        baseAlpha = 1,
        speedMul = 1,
        scale = 1,
        zIndex = 1,
        rotation = 0,
        tint = Color3.fromRGB(255, 255, 255)
    },
    {
        name = "Fast",
        frameDuration = 1.5,
        startFrame = 7,
        baseAlpha = 0.95,
        speedMul = 1.15,
        scale = 1.02,
        zIndex = 2,
        rotation = 0,
        tint = Color3.fromRGB(230, 250, 255)
    },
    {
        name = "Slow",
        frameDuration = 3.75,
        startFrame = 4,
        baseAlpha = 0.7,
        speedMul = 0.85,
        scale = 1.06,
        zIndex = 3,
        rotation = 180,
        tint = Color3.fromRGB(255, 255, 255)
    }
};
local u3 = nil;
local u4 = {};
local u5 = false;
local u6 = 0;
local u7 = 0;
local u8 = 0;
local u9 = 0;
local u10 = 0;
local u11 = 0;
local u12 = false;
local u13 = 0;
local u14 = nil;

local function _lerp(p15, p16, p17) -- Line: 160
    return p15 + (p16 - p15) * p17;
end;

local function _ensureUi() -- Line: 168
    -- upvalues: u3 (ref), u4 (copy), Players (copy), Log (copy), u2 (copy)
    if u3 and (u3.Parent and #u4 > 0) then
        return true;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        Log.warn("[SpeedLineFX] 无 LocalPlayer，无法创建 UI");

        return false;
    end;

    local v18 = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5);

    if not v18 then
        Log.warn("[SpeedLineFX] 无 PlayerGui");

        return false;
    end;

    local SpeedLineFX = v18:FindFirstChild("SpeedLineFX");

    if SpeedLineFX then
        SpeedLineFX:Destroy();
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "SpeedLineFX";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 80;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Enabled = false;
    ScreenGui.Parent = v18;
    u3 = ScreenGui;
    table.clear(u4);

    for _, v in ipairs(u2) do
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Name = v.name;
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.BorderSizePixel = 0;
        ImageLabel.Size = UDim2.fromScale(1, 1);
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageLabel.ScaleType = Enum.ScaleType.Stretch;
        ImageLabel.ImageTransparency = 1;
        ImageLabel.ImageColor3 = v.tint;
        ImageLabel.ZIndex = v.zIndex;
        ImageLabel.Rotation = v.rotation;
        ImageLabel.Visible = false;
        ImageLabel.Parent = ScreenGui;
        local UIScale = Instance.new("UIScale");
        UIScale.Scale = v.scale;
        UIScale.Parent = ImageLabel;
        table.insert(u4, {
            config = v,
            imageLabel = ImageLabel,
            uiScale = UIScale
        });
    end;

    return true;
end;

local function _effectiveIntensity(p19) -- Line: 240
    -- upvalues: u13 (ref)
    if p19 <= 0 then
        return 0;
    end;

    local v20 = p19 * (math.sin(u13 * 3.141592653589793 * 2 * 0.55) * 0.06 + 1);

    return math.clamp(v20, 0, 1);
end;

local function _applyIntensityToLayers() -- Line: 251
    -- upvalues: u7 (ref), u13 (ref), u4 (copy), SequenceManager (copy)
    local v21 = u7;
    local v22;

    if v21 <= 0 then
        v22 = 0;
    else
        local v23 = v21 * (math.sin(u13 * 3.141592653589793 * 2 * 0.55) * 0.06 + 1);
        v22 = math.clamp(v23, 0, 1);
    end;

    local v24 = v22 * 0.6000000000000001 + 0.7;

    for _, v in ipairs(u4) do
        local v25 = 1 - math.min(1, v.config.baseAlpha * v22 * 1.2);
        SequenceManager:SetLayerTransparency(v.imageLabel, v25);
        SequenceManager:SetPlaybackSpeed(v.imageLabel, v24 * v.config.speedMul);
    end;
end;

local function _startLayers() -- Line: 266
    -- upvalues: u5 (ref), u4 (copy), SequenceManager (copy)
    if u5 then
        return;
    end;

    for _, v in ipairs(u4) do
        local imageLabel = v.imageLabel;
        imageLabel.Visible = true;
        imageLabel.ImageTransparency = 1;
        SequenceManager:PlaySequenceEx(imageLabel, "加速线", {
            loop = true,
            pingPong = true,
            mode = "Crossfade",
            crossfadeSec = 0.045,
            layerTransparency = 1,
            frameDuration = v.config.frameDuration,
            startFrame = v.config.startFrame,
            speedScale = v.config.speedMul * 0.7
        });
    end;

    u5 = true;
end;

local function _stopLayers() -- Line: 293
    -- upvalues: u4 (copy), SequenceManager (copy), u5 (ref), u3 (ref)
    for _, v in ipairs(u4) do
        SequenceManager:StopSequence(v.imageLabel);
        v.imageLabel.Visible = false;
        v.imageLabel.ImageTransparency = 1;
    end;

    u5 = false;

    if u3 then
        u3.Enabled = false;
    end;
end;

local function _disconnectUpdate() -- Line: 309
    -- upvalues: u14 (ref)
    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;
end;

local function _onUpdate(p26) -- Line: 320
    -- upvalues: u13 (ref), u9 (ref), u8 (ref), u7 (ref), u10 (ref), u11 (ref), u12 (ref), _stopLayers (copy), u14 (ref), u6 (ref), _applyIntensityToLayers (copy)
    u13 = u13 + p26;

    if u9 > 0 then
        u9 = u9 - p26;
        local v27 = math.max(u8, 0.0001);
        local v28 = (v27 - math.max(u9, 0)) / v27;
        local v29 = math.clamp(v28, 0, 1);
        local v30 = u10;
        u7 = v30 + (u11 - v30) * (v29 * v29 * (3 - v29 * 2));

        if u9 <= 0 then
            u7 = u11;
            u9 = 0;

            if u12 and u7 <= 0 then
                _stopLayers();
                u12 = false;

                if u14 then
                    u14:Disconnect();
                    u14 = nil;
                end;

                return;
            end;
        end;
    else
        u7 = u6;
    end;

    _applyIntensityToLayers();
end;

local function _ensureUpdateConnection() -- Line: 350
    -- upvalues: u14 (ref), RunService (copy), _onUpdate (copy)
    if u14 then
        return;
    end;

    u14 = RunService.Heartbeat:Connect(_onUpdate);
end;

local function _beginFade(p31, p32, p33) -- Line: 363
    -- upvalues: u12 (ref), u6 (ref), u10 (ref), u7 (ref), u11 (ref), u8 (ref), u9 (ref), _applyIntensityToLayers (copy), _stopLayers (copy), u14 (ref), RunService (copy), _onUpdate (copy)
    u12 = p33;
    u6 = math.clamp(p31, 0, 1);
    u10 = u7;
    u11 = u6;
    local v34 = math.max(p32, 0);
    u8 = v34;
    u9 = v34;

    if v34 > 0 then
        if u14 then
            return;
        end;

        u14 = RunService.Heartbeat:Connect(_onUpdate);

        return;
    end;

    u7 = u6;
    _applyIntensityToLayers();

    if p33 and u7 <= 0 then
        _stopLayers();
        u12 = false;

        if u14 then
            u14:Disconnect();
            u14 = nil;
        end;
    else
        if u14 then
            return;
        end;

        u14 = RunService.Heartbeat:Connect(_onUpdate);
    end;
end;

function v1.Preload() -- Line: 396
    -- upvalues: SequenceManager (copy)
    SequenceManager:Preload("加速线");

    return nil;
end;

function v1.Show(p35, p36) -- Line: 407
    -- upvalues: RunService (copy), Log (copy), _ensureUi (copy), u3 (ref), _startLayers (copy), u12 (ref), u6 (ref), u10 (ref), u7 (ref), u11 (ref), u8 (ref), u9 (ref), _applyIntensityToLayers (copy), u14 (ref), _onUpdate (copy)
    if not RunService:IsClient() then
        Log.warn("[SpeedLineFX] 仅客户端可用");

        return nil;
    end;

    if not _ensureUi() then
        return nil;
    end;

    local v37 = p35 == nil and 1 or math.clamp(p35, 0, 1);
    local v38 = p36 == nil and 0.12 or math.max(p36, 0);

    if u3 then
        u3.Enabled = true;
    end;

    _startLayers();
    u12 = false;
    u6 = math.clamp(v37, 0, 1);
    u10 = u7;
    u11 = u6;
    local v39 = math.max(v38, 0);
    u8 = v39;
    u9 = v39;

    if v39 <= 0 then
        u7 = u6;
        _applyIntensityToLayers();

        if not u14 then
            u14 = RunService.Heartbeat:Connect(_onUpdate);
        end;
    elseif not u14 then
        u14 = RunService.Heartbeat:Connect(_onUpdate);
    end;

    return nil;
end;

function v1.SetIntensity(p40) -- Line: 435
    -- upvalues: u5 (ref), u3 (ref), u12 (ref), u6 (ref), u10 (ref), u7 (ref), u11 (ref), u8 (ref), u9 (ref), u14 (ref), RunService (copy), _onUpdate (copy)
    if typeof(p40) ~= "number" then
        return nil;
    end;

    if not (u5 or u3 and u3.Enabled) then
        return nil;
    end;

    local v41 = math.clamp(p40, 0, 1);
    u12 = false;
    u6 = math.clamp(v41, 0, 1);
    u10 = u7;
    u11 = u6;
    u8 = 0.08;
    u9 = 0.08;

    if not u14 then
        u14 = RunService.Heartbeat:Connect(_onUpdate);
    end;

    return nil;
end;

function v1.Hide(p42) -- Line: 454
    -- upvalues: u5 (ref), u7 (ref), _stopLayers (copy), u14 (ref), u12 (ref), u6 (ref), u10 (ref), u11 (ref), u8 (ref), u9 (ref), _applyIntensityToLayers (copy), RunService (copy), _onUpdate (copy)
    if not u5 and u7 <= 0 then
        _stopLayers();

        if u14 then
            u14:Disconnect();
            u14 = nil;
        end;

        return nil;
    end;

    local v43 = p42 == nil and 0.2 or math.max(p42, 0);
    u12 = true;
    u6 = 0;
    u10 = u7;
    u11 = u6;
    local v44 = math.max(v43, 0);
    u8 = v44;
    u9 = v44;

    if v44 <= 0 then
        u7 = u6;
        _applyIntensityToLayers();

        if u7 <= 0 then
            _stopLayers();
            u12 = false;

            if u14 then
                u14:Disconnect();
                u14 = nil;
            end;
        elseif not u14 then
            u14 = RunService.Heartbeat:Connect(_onUpdate);
        end;
    elseif not u14 then
        u14 = RunService.Heartbeat:Connect(_onUpdate);
    end;

    return nil;
end;

function v1.GetIntensity() -- Line: 471
    -- upvalues: u7 (ref)
    return u7;
end;

function v1.GetSequenceName() -- Line: 479
    return "加速线";
end;

return v1;