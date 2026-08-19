-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local Lighting = v1.Lighting;
local TweenService = v1.TweenService;
local Workspace = v1.Workspace;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "RarityStyles");
local RARITY_TIER_COUNT = v2.RARITY_TIER_COUNT;
local rarityStyleFor = v2.rarityStyleFor;
local rarityTierIndex = v2.rarityTierIndex;
local applyGoldGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "GoldGradient").applyGoldGradient;
local TextGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "TextGradient").TextGradient;
local ItemLabelStyles = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "itemLabels", "ItemLabelStyles").ItemLabelStyles;
local tweenAndDestroy = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "tween", "playAndDestroy").tweenAndDestroy;
local Items = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").Items;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "TextEffectTags");
local DIVINE_SEQUENCE = v3.DIVINE_SEQUENCE;
local DIVINE_TEXT_TAG = v3.DIVINE_TEXT_TAG;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local formatWithCommas = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatWithCommas").formatWithCommas;
local playSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playSound;
local u4 = Color3.new(1, 1, 1);
local u5 = { 0.112, 0.176, 0.272 };
local u6 = { "??.", "?.?", ".??", "???" };

local function _(p7) -- Line: 111
    return TweenInfo.new(p7, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
end;

local function _(p8) -- Line: 114
    return TweenInfo.new(p8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
end;

local u9 = setmetatable({}, {
    __tostring = function() -- Line: 120, Name: __tostring
        return "ItemRevealController";
    end
});
u9.__index = u9;

function u9.new(...) -- Line: 125
    -- upvalues: u9 (ref)
    local v10 = setmetatable({}, u9);

    return v10:constructor(...) or v10;
end;

function u9.constructor(p11) -- Line: 129
    p11.camStart = CFrame.new();
    p11.camTarget = CFrame.new();
    p11.camElapsed = 0;
    p11.camDuration = 1;
    p11.baseCFrame = CFrame.new();
    p11.centerStart = Vector3.new(0, 0, 0);
    p11.centerTarget = Vector3.new(0, 0, 0);
    p11.centerElapsed = 0;
    p11.centerDuration = 1;
    p11.itemSpin = 0;
    p11.spinVelocity = 0;
    p11.fovPunch = 0;
    p11.shakeMagnitude = 0;
    p11.shakeSeed = 0;
end;

function u9.onStart(p12) -- Line: 145
    -- upvalues: WFChain (copy), PlayerGui (copy)
    p12.screen = WFChain(PlayerGui, "ItemReveal");
    local v13 = WFChain(p12.screen, "Frame");
    p12.discovered = p12:setupLabel(v13, "NewItemDiscovered", 0);
    p12.itemName = p12:setupLabel(v13, "Name", 1);
    p12.condition = p12:setupLabel(v13, "Condition", 2);
    p12.rarity = p12:setupLabel(v13, "Rarity", 3);
    p12.money = p12:setupLabel(v13, "MoneyPerSecond", 4);
    p12.screen.Enabled = false;
end;

function u9.setupLabel(p14, p15, p16, p17) -- Line: 155
    -- upvalues: WFChain (copy)
    local v18 = WFChain(p15, p16);
    v18.LayoutOrder = p17;
    local v19 = WFChain(v18, "UIStroke");
    local UIScale = Instance.new("UIScale");
    UIScale.Parent = v18;

    return {
        label = v18,
        stroke = v19,
        scale = UIScale,
        strokeTransparency = v19.Transparency
    };
end;

function u9.onRender(p20, p21) -- Line: 168
    -- upvalues: Workspace (copy)
    local cinematic = p20.cinematic;

    if not cinematic then
        return nil;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    end;

    p20.camElapsed = p20.camElapsed + p21;
    p20.centerElapsed = p20.centerElapsed + p21;
    p20.spinVelocity = p20.spinVelocity + (0.4188790204786391 - p20.spinVelocity) * (1 - math.exp(-0.85 * p21));
    p20.itemSpin = p20.itemSpin + p20.spinVelocity * p21;
    local v22 = 1 - (1 - math.clamp(p20.camElapsed / p20.camDuration, 0, 1)) ^ 3;
    local v23 = p20.camStart:Lerp(p20.camTarget, v22);
    p20.baseCFrame = v23;
    p20.fovPunch = p20.fovPunch + (0 - p20.fovPunch) * (1 - math.exp(-9 * p21));
    CurrentCamera.FieldOfView = cinematic.baseFov - p20.fovPunch;
    local v24;

    if p20.shakeMagnitude > 0.001 then
        p20.shakeMagnitude = math.max(0, p20.shakeMagnitude - 3.4 * p21);
        local v25 = os.clock() * 24;
        local v26 = math.noise(v25, p20.shakeSeed) * 0.019198621771937627 * p20.shakeMagnitude;
        local v27 = math.noise(v25, p20.shakeSeed + 7.3) * 0.019198621771937627 * p20.shakeMagnitude;
        local v28 = math.noise(v25, p20.shakeSeed + 21.7) * 0.019198621771937627 * p20.shakeMagnitude;
        v24 = v23 * CFrame.Angles(v26, v27, v28);
    else
        v24 = v23;
    end;

    CurrentCamera.CFrame = v24;
    local v29 = 1 - (1 - math.clamp(p20.centerElapsed / p20.centerDuration, 0, 1)) ^ 3;
    local v30 = os.clock() * 1.7;
    local v31 = math.sin(v30) * cinematic.radius * 0.03;
    local v32 = p20.centerStart:Lerp(p20.centerTarget, v29) + Vector3.new(0, v31, 0);
    cinematic.item:PivotTo(CFrame.new(v32) * CFrame.Angles(0, p20.itemSpin, 0) * cinematic.spinBase);
    cinematic.depthOfField.FocusDistance = (v23.Position - v32).Magnitude;
end;

u9.play = RuntimeLib.async(function(u33, p34, p35, p36) -- Line: 215
    -- upvalues: RuntimeLib (copy), playSound (copy), TextGradient (copy), DIVINE_SEQUENCE (copy), DIVINE_TEXT_TAG (copy), Items (copy)
    u33:setupCinematic(p34, p36);
    u33:prime(p34, p35.kg);
    RuntimeLib.await(u33:playFinishBeat());
    u33:beginRevealPhase();
    RuntimeLib.await(RuntimeLib.Promise.delay(0.28));
    u33:popIn(u33.itemName);
    u33:fovKick(5);
    u33:shake(0.35);
    playSound("RevealPop", {
        volume = 0.55,
        playbackSpeed = 1.25
    });

    if p35.isNew then
        task.delay(0.12, function() -- Line: 229
            -- upvalues: TextGradient (ref), u33 (copy), DIVINE_SEQUENCE (ref), DIVINE_TEXT_TAG (ref), playSound (ref)
            TextGradient.apply(u33.discovered.label, DIVINE_SEQUENCE, 0, DIVINE_TEXT_TAG);
            u33:popIn(u33.discovered);
            playSound("RevealDiscovered", {
                volume = 0.55
            });
        end);
    end;

    RuntimeLib.await(RuntimeLib.Promise.delay(0.44));
    u33:popIn(u33.condition, 0.2);
    RuntimeLib.await(RuntimeLib.Promise.delay(0.24));
    RuntimeLib.await(u33:playConditionShuffle(p35.condition));
    u33:revealCondition(p35.condition);
    u33:onConditionReveal(p35.condition);
    RuntimeLib.await(RuntimeLib.Promise.delay(0.32));
    RuntimeLib.await(u33:playRarityOdometer(p35.oneIn, Items[p34].rarity));
    u33:onRarityLand(Items[p34].rarity);
    RuntimeLib.await(RuntimeLib.Promise.delay(0.28));
    u33:revealMoney(p35.value);
    RuntimeLib.await(u33:holdAndPulse(p35, Items[p34].rarity));
end);

function u9.revealMoney(p37, p38) -- Line: 250
    -- upvalues: applyGoldGradient (copy), formatAbbrevMoney (copy), playSound (copy)
    local money = p37.money;
    money.label.RichText = false;
    applyGoldGradient(money.label);
    money.label.Text = formatAbbrevMoney(p38);
    p37:popIn(money);
    p37:fovKick(6);
    p37:shake(0.3);
    playSound("RevealPop", {
        volume = 0.55,
        playbackSpeed = 1.4
    });
end;

function u9.setupCinematic(p39, p40, p41) -- Line: 263
    -- upvalues: Workspace (copy), u4 (copy), Lighting (copy), tweenAndDestroy (copy), rarityStyleFor (copy), Items (copy)
    p39:teardownCinematic();
    p39.itemSpin = 0;
    p39.spinVelocity = 0.4188790204786391;
    p39.fovPunch = 0;
    p39.shakeMagnitude = 0;
    p39.shakeSeed = math.random() * 100;

    if not p41 then
        return nil;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    local v42 = p39:computeItemBounds(p41);
    local v43 = v42[1];
    local v44 = v42[2];
    local Magnitude = v44.Magnitude;
    local v45 = math.max(Magnitude * 3, 7);
    local v46 = v43 + Vector3.new(0, v45, 0);
    local CFrame2 = CurrentCamera.CFrame;
    local Position = CFrame2.Position;
    local v47 = Vector3.new(Position.X - v46.X, 0, Position.Z - v46.Z);
    local v48 = v46 + (v47.Magnitude <= 0.001 and Vector3.new(0, 0, 1) or v47.Unit) * p39:framingDistance(CurrentCamera, v44);
    local v49 = CFrame.lookAt(v48, v46);
    p39.camStart = CFrame2;
    p39.camTarget = CFrame2;
    p39.camElapsed = 0;
    p39.camDuration = 0.48;
    p39.baseCFrame = CFrame2;
    p39.centerStart = v43;
    p39.centerTarget = v43;
    p39.centerElapsed = 0;
    p39.centerDuration = 0.48;
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Brightness = 0;
    ColorCorrectionEffect.Contrast = 0;
    ColorCorrectionEffect.Saturation = 0;
    ColorCorrectionEffect.TintColor = u4;
    ColorCorrectionEffect.Parent = Lighting;
    local DepthOfFieldEffect = Instance.new("DepthOfFieldEffect");
    DepthOfFieldEffect.InFocusRadius = 6;
    DepthOfFieldEffect.FocusDistance = (v48 - v46).Magnitude;
    DepthOfFieldEffect.NearIntensity = 0;
    DepthOfFieldEffect.FarIntensity = 0;
    DepthOfFieldEffect.Parent = Lighting;
    tweenAndDestroy(DepthOfFieldEffect, TweenInfo.new(0.44, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        NearIntensity = 0.2,
        FarIntensity = 0.55
    });
    p39.cinematic = {
        item = p41,
        center = v43,
        liftedCenter = v46,
        heroCFrame = v49,
        radius = Magnitude,
        spinBase = CFrame.new(v43):Inverse() * p41:GetPivot(),
        baseFov = CurrentCamera.FieldOfView,
        colorCorrection = ColorCorrectionEffect,
        depthOfField = DepthOfFieldEffect,
        tint = rarityStyleFor(Items[p40].rarity).color
    };
end;

u9.playFinishBeat = RuntimeLib.async(function(p50) -- Line: 333
    -- upvalues: playSound (copy), RuntimeLib (copy)
    p50:ccFlash(0.4, 0, false);
    playSound("RevealFinish", {
        volume = 0.45
    });
    RuntimeLib.await(RuntimeLib.Promise.delay(0.48));
end);

function u9.beginRevealPhase(p51) -- Line: 340
    -- upvalues: playSound (copy)
    local cinematic = p51.cinematic;

    if not cinematic then
        return nil;
    end;

    p51.camStart = p51.baseCFrame;
    p51.camTarget = cinematic.heroCFrame;
    p51.camElapsed = 0;
    p51.camDuration = 0.44;
    p51.centerStart = cinematic.center;
    p51.centerTarget = cinematic.liftedCenter;
    p51.centerElapsed = 0;
    p51.centerDuration = 0.44;
    p51.spinVelocity = 18.84955592153876;
    playSound("RevealLift", {
        volume = 0.45
    });
end;

function u9.framingDistance(p52, p53, p54) -- Line: 358
    local v55 = math.rad(p53.FieldOfView) / 2;
    local ViewportSize = p53.ViewportSize;
    local v56 = math.tan(v55) * (ViewportSize.X / ViewportSize.Y);
    local v57 = math.atan(v56);
    local v58 = math.sqrt(p54.X ^ 2 + p54.Z ^ 2);
    local v59 = p54.Y / (math.tan(v55) * 0.55);
    local v60 = v58 / (math.tan(v57) * 0.55);

    return math.max(v59, v60, 4);
end;

function u9.computeItemBounds(p61, p62) -- Line: 365
    local v63 = Vector3.new(inf, inf, inf);
    local v64 = Vector3.new(-inf, -inf, -inf);
    local v65 = false;

    for _, descendant in p62:GetDescendants() do
        if descendant:IsA("BasePart") and not descendant:FindFirstAncestor("DirtCoat") then
            local CFrame2 = descendant.CFrame;
            local v66 = descendant.Size / 2;
            v65 = true;

            for _, v in { -1, 1 } do
                for _, v4 in { -1, 1 } do
                    for _, v5 in { -1, 1 } do
                        local v67 = CFrame2:PointToWorldSpace((Vector3.new(v66.X * v, v66.Y * v4, v66.Z * v5)));
                        local v68 = math.min(v63.X, v67.X);
                        local v69 = math.min(v63.Y, v67.Y);
                        local v70 = math.min(v63.Z, v67.Z);
                        v63 = Vector3.new(v68, v69, v70);
                        local v71 = math.max(v64.X, v67.X);
                        local v72 = math.max(v64.Y, v67.Y);
                        local v73 = math.max(v64.Z, v67.Z);
                        v64 = Vector3.new(v71, v72, v73);
                    end;
                end;
            end;
        end;
    end;

    if v65 then
        return { (v63 + v64) / 2, (v64 - v63) / 2 };
    end;

    local v74, v75 = p62:GetBoundingBox();

    return { v74.Position, v75 / 2 };
end;

function u9.teardownCinematic(p76) -- Line: 397
    -- upvalues: Workspace (copy), tweenAndDestroy (copy)
    local cinematic = p76.cinematic;

    if not cinematic then
        return nil;
    end;

    p76.cinematic = nil;
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera.FieldOfView = cinematic.baseFov;
    end;

    cinematic.colorCorrection:Destroy();
    tweenAndDestroy(cinematic.depthOfField, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        NearIntensity = 0,
        FarIntensity = 0
    });
    task.delay(0.2, function() -- Line: 412
        -- upvalues: cinematic (copy)
        return cinematic.depthOfField:Destroy();
    end);
end;

function u9.fovKick(p77, p78) -- Line: 416
    p77.fovPunch = math.max(p77.fovPunch, p78);
end;

function u9.shake(p79, p80) -- Line: 419
    p79.shakeMagnitude = math.max(p79.shakeMagnitude, p80);
end;

function u9.ccFlash(p81, p82, p83, p84) -- Line: 422
    -- upvalues: u4 (copy), tweenAndDestroy (copy)
    local cinematic = p81.cinematic;

    if not cinematic then
        return nil;
    end;

    local colorCorrection = cinematic.colorCorrection;
    colorCorrection.Brightness = p82;
    colorCorrection.Contrast = p83;
    local v85;

    if p84 then
        v85 = cinematic.tint:Lerp(u4, 0.5);
    else
        v85 = u4;
    end;

    colorCorrection.TintColor = v85;
    tweenAndDestroy(colorCorrection, TweenInfo.new(0.176, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Brightness = 0,
        Contrast = 0,
        TintColor = u4
    });
end;

function u9.onConditionReveal(p86, p87) -- Line: 437
    -- upvalues: playSound (copy)
    p86:fovKick(p87 == "mint" and 14 or 9);
    p86:shake(p87 == "mint" and 0.9 or (p87 == "good" and 0.6 or 0.4));
    p86:ccFlash(p87 == "mint" and 0.3 or 0.18, p87 == "mint" and 0.2 or 0.1, p87 == "mint");

    if p87 == "mint" then
        playSound("RevealMint", {
            volume = 0.75
        });

        return;
    end;

    playSound("RevealDing", {
        volume = 0.55,
        playbackSpeed = p87 == "good" and 1.15 or (p87 == "poor" and 0.9 or 1)
    });
end;

function u9.onRarityLand(p88, p89) -- Line: 452
    -- upvalues: rarityTierIndex (copy), RARITY_TIER_COUNT (copy), playSound (copy)
    local v90 = rarityTierIndex(p89);
    local v91 = v90 / (RARITY_TIER_COUNT - 1);
    p88:fovKick(7 + 9 * v91);
    p88:shake(0.5 + v91 * 0.8);
    p88:ccFlash(0.18 + v91 * 0.3, 0.1 + v91 * 0.18, v91 > 0.5);
    playSound(v90 >= 5 and "RevealLandHigh" or (v90 >= 3 and "RevealLandMid" or "RevealLandLow"), {
        volume = 0.5 + v91 * 0.4,
        playbackSpeed = 0.95 + v91 * 0.15
    });
end;

function u9.prime(p92, p93, p94) -- Line: 464
    -- upvalues: TextGradient (copy), ItemLabelStyles (copy), Items (copy), u4 (copy), rarityStyleFor (copy), formatWithCommas (copy), applyGoldGradient (copy)
    p92.highlight = nil;

    for _, v in p92:entries() do
        TextGradient.clear(v.label);
        v.label.TextTransparency = 1;
        v.stroke.Transparency = 1;
        v.label.Rotation = 0;
        v.scale.Scale = 0;
    end;

    ItemLabelStyles.applyItemName(p92.itemName.label, Items[p93].displayName, p94, Items[p93].rarity);
    p92.discovered.label.TextColor3 = u4;
    p92.condition.label.TextColor3 = u4;
    p92.condition.label.Text = "Condition: ???";
    p92.rarity.label.TextColor3 = rarityStyleFor(Items[p93].rarity).color;
    p92.rarity.label.Text = `1 in {formatWithCommas(2)}`;
    p92.money.label.RichText = false;
    applyGoldGradient(p92.money.label);
    p92.money.label.Text = "0¢";
    p92.screen.Enabled = true;
end;

function u9.entries(p95) -- Line: 484
    return {
        p95.discovered,
        p95.itemName,
        p95.condition,
        p95.rarity,
        p95.money
    };
end;

function u9.popIn(p96, p97, p98) -- Line: 487
    -- upvalues: tweenAndDestroy (copy)
    local v99 = p98 == nil and 0.28 or p98;
    p97.scale.Scale = 0;
    p97.label.Rotation = -4;
    tweenAndDestroy(p97.scale, TweenInfo.new(v99, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    });
    tweenAndDestroy(p97.label, TweenInfo.new(v99, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Rotation = 0
    });
    tweenAndDestroy(p97.label, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    });
    tweenAndDestroy(p97.stroke, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = p97.strokeTransparency
    });
end;

u9.flash = RuntimeLib.async(function(p100, p101, p102) -- Line: 506
    -- upvalues: tweenAndDestroy (copy), playSound (copy), RuntimeLib (copy)
    local v103 = false;
    local v104 = 0;

    while true do
        if v103 then
            v104 = v104 + 1;
        else
            v103 = true;
        end;

        if v104 >= p102 then
            return;
        end;

        p101.scale.Scale = 1.12;
        p101.label.TextTransparency = 0.5;
        tweenAndDestroy(p101.scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 1
        });
        tweenAndDestroy(p101.label, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        });
        playSound("Tick", {
            volume = 0.4,
            playbackSpeed = v104 * 0.12 + 1.4
        });
        RuntimeLib.await(RuntimeLib.Promise.delay(0.112));
    end;
end);
u9.playConditionShuffle = RuntimeLib.async(function(p105, p106) -- Line: 535
    -- upvalues: u6 (copy), playSound (copy), RuntimeLib (copy), u5 (copy)
    local label = p105.condition.label;
    local v107 = (p106 == "mint" and 0.64 or (p106 == "good" and 0.32 or 0)) + 1.6;
    local v108 = os.clock();
    local v109 = 0;
    local v110 = 0.144;

    while os.clock() - v108 < v107 do
        label.Text = `Condition: {u6[v109 % #u6 + 1]}`;
        label.Rotation = (math.random() * 2 - 1) * 2;
        v109 = v109 + 1;
        local v111 = (os.clock() - v108) / v107;
        playSound("Tick", {
            volume = 0.28,
            playbackSpeed = math.clamp(v111, 0, 1) * 1.1 + 0.95
        });
        RuntimeLib.await(RuntimeLib.Promise.delay(v110));
        v110 = math.max(v110 * 0.88, 0.036);
    end;

    label.Rotation = 0;

    if p106 ~= "mint" then
        if p106 == "good" then
            RuntimeLib.await(p105:flash(p105.condition, 2));
        end;

        return;
    end;

    for _, v in u5 do
        label.Text = `Condition: {u6[v109 % #u6 + 1]}`;
        v109 = v109 + 1;
        playSound("Tick", {
            volume = 0.4,
            playbackSpeed = v109 * 0.04 + 0.75
        });
        RuntimeLib.await(RuntimeLib.Promise.delay(v));
    end;

    label.Text = "Condition: ???";
    RuntimeLib.await(p105:flash(p105.condition, 3));
end);

function u9.revealCondition(p112, p113) -- Line: 571
    -- upvalues: ItemLabelStyles (copy), tweenAndDestroy (copy)
    local condition = p112.condition;
    p112.highlight = ItemLabelStyles.applyCondition(condition.label, p113);
    condition.scale.Scale = p113 == "mint" and 1.35 or 1.25;
    tweenAndDestroy(condition.scale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    });
end;

u9.playRarityOdometer = RuntimeLib.async(function(p114, p115, p116) -- Line: 579
    -- upvalues: tweenAndDestroy (copy), formatWithCommas (copy), rarityStyleFor (copy), playSound (copy), RuntimeLib (copy), ItemLabelStyles (copy), rarityTierIndex (copy)
    local rarity = p114.rarity;
    local label = rarity.label;
    tweenAndDestroy(label, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    });
    tweenAndDestroy(rarity.stroke, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = rarity.strokeTransparency
    });

    if p115 > 2 then
        tweenAndDestroy(rarity.scale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        });
        local v117 = math.log(p115) * 0.176 + 0.32;
        local v118 = math.clamp(v117, 0.4, 1.44);
        local v119 = os.clock();
        local v120 = 0;
        local v121 = 2;
        local v122 = 0;

        while v120 < 1 do
            local v123 = os.clock();
            v120 = math.min((v123 - v119) / v118, 1);
            local v124 = math.floor(2 + (p115 - 2) * (1 - (1 - v120) ^ 3) + 0.5);

            if v124 == v121 then
                v123 = v122;
                v124 = v121;
            else
                label.Text = `1 in {formatWithCommas(v124)}`;
                label.TextColor3 = rarityStyleFor(p116).color;

                if v123 - v122 >= 0.05 then
                    playSound("Tick", {
                        volume = 0.32,
                        playbackSpeed = v120 * 1.1 + 0.9
                    });
                else
                    v123 = v122;
                end;
            end;

            if v120 < 1 then
                RuntimeLib.await(RuntimeLib.Promise.delay(0.03333333333333333));
                v122 = v123;
                v121 = v124;
            else
                v122 = v123;
                v121 = v124;
            end;
        end;
    end;

    ItemLabelStyles.applyRarity(label, p115, p116);
    rarity.scale.Scale = 1.15 + rarityTierIndex(p116) * 0.04;
    tweenAndDestroy(rarity.scale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    });
end);
u9.holdAndPulse = RuntimeLib.async(function(p125, p126, p127) -- Line: 625
    -- upvalues: rarityTierIndex (copy), TweenService (copy), RuntimeLib (copy)
    local v128 = (p126.condition == "mint" and 1.04 or (p126.condition == "good" and 0.4 or 0)) + 0.96;
    local v129 = rarityTierIndex(p127) >= 6 and 2 or 0;
    local v130 = math.max(v128, v129);

    local function _(p131) -- Line: 631
        return p131.scale.Scale > 0.001;
    end;

    local v132 = 0;
    local v133 = {};

    for i, v in p125:entries() do
        local _ = i - 1;

        if v.scale.Scale > 0.001 == true then
            v132 = v132 + 1;
            v133[v132] = v;
        end;
    end;

    local u134 = TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
    local v135 = table.create(#v133);

    local function _(p136) -- Line: 646
        -- upvalues: TweenService (ref), u134 (copy)
        return TweenService:Create(p136.scale, u134, {
            Scale = 1.015
        });
    end;

    for i, v in v133 do
        local _ = i - 1;
        v135[i] = TweenService:Create(v.scale, u134, {
            Scale = 1.015
        });
    end;

    for _, v in v135 do
        v:Play();
    end;

    RuntimeLib.await(RuntimeLib.Promise.delay(v130));

    for _, v in v135 do
        v:Cancel();
        v:Destroy();
    end;

    for _, v in v133 do
        v.scale.Scale = 1;
    end;
end);

function u9.dismiss(p137) -- Line: 668
    -- upvalues: TextGradient (copy)
    local highlight = p137.highlight;

    if highlight ~= nil then
        highlight.destroy();
    end;

    p137.highlight = nil;

    for _, v in p137:entries() do
        TextGradient.clear(v.label);
        v.label.TextTransparency = 1;
        v.stroke.Transparency = 1;
        v.scale.Scale = 0;
    end;

    p137.screen.Enabled = false;
    p137:teardownCinematic();
end;

Reflect.defineMetadata(u9, "identifier", "client/controllers/world/ItemRevealController@ItemRevealController");
Reflect.defineMetadata(u9, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" });
Reflect.decorate(u9, "$:flamework@Controller", Controller, { {} });

return {
    ItemRevealController = u9
};