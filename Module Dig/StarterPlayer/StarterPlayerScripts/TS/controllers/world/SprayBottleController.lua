-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ContentProvider = v1.ContentProvider;
local Lighting = v1.Lighting;
local Players = v1.Players;
local ReplicatedStorage = v1.ReplicatedStorage;
local TweenService = v1.TweenService;
local UserInputService = v1.UserInputService;
local Workspace = v1.Workspace;
local TestingFlags = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "testing", "TestingFlags").TestingFlags;
local ItemsEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ItemsNetwork").ItemsEvents;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "SprayBottles");
local CLEAN_AREA_EXPONENT = v2.CLEAN_AREA_EXPONENT;
local CLEAN_REFERENCE_AREA = v2.CLEAN_REFERENCE_AREA;
local DEFAULT_SPRAY_ID = v2.DEFAULT_SPRAY_ID;
local SPRAY_TIER_ORDER = v2.SPRAY_TIER_ORDER;
local SprayBottles = v2.SprayBottles;
local DirtBlock = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtBlock").DirtBlock;
local DirtBudget = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtBudget").DirtBudget;
local DirtCoat = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtCoat").DirtCoat;
local DirtMask = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtMask").DirtMask;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u3 = { "Main", "Main2", "Line", "Line2" };
local u4 = CFrame.new(0, -500, 0);
local u5 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u6 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u7 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.65), NumberSequenceKeypoint.new(0.4, 0.72), NumberSequenceKeypoint.new(1, 1) });
local u8 = Color3.fromRGB(255, 255, 255);
local u9 = { Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2 };
local u10 = {
    dissolveRate = 600,
    dissolveRadius = 4,
    beamWidth = 2.5,
    pressurePitch = 1.6
};

local function lerp(p11, p12, p13) -- Line: 114
    return p11 + (p12 - p11) * p13;
end;

local u14 = setmetatable({}, {
    __tostring = function() -- Line: 120, Name: __tostring
        return "SprayBottleController";
    end
});
u14.__index = u14;

function u14.new(...) -- Line: 125
    -- upvalues: u14 (ref)
    local v15 = setmetatable({}, u14);

    return v15:constructor(...) or v15;
end;

function u14.constructor(p16, p17, p18) -- Line: 129
    -- upvalues: SprayBottles (copy), DEFAULT_SPRAY_ID (copy), UserInputService (copy)
    p16.cleanBar = p17;
    p16.data = p18;
    p16.config = SprayBottles.basic;
    p16.equipped = DEFAULT_SPRAY_ID;
    p16.powerful = false;
    p16.revealed = false;
    p16.itemRayParams = RaycastParams.new();
    p16.dirtRayParams = RaycastParams.new();
    p16.yaw = 0;
    p16.pitch = -0.5585053606381855;
    p16.spinAngle = 0;
    p16.spinVelocity = 0;
    p16.spinAnchor = CFrame.new();
    p16.spinBase = CFrame.new();
    p16.spraying = false;
    p16.finishing = false;
    p16.sway = Vector2.zero;
    p16.aimPosition = UserInputService:GetMouseLocation();
    p16.lastAim = UserInputService:GetMouseLocation();
    p16.triggersHeld = {};
    p16.squeeze = 0;
    p16.cleanRatio = 0;
    p16.contactBlocksNearby = false;
    p16.lastDirtContact = 0;
    p16.contactLevel = 0;
    p16.soapBlend = 0;
    p16.dirtBlocks = {};
    p16.dirtTotal = 0;
    p16.dirtToughness = 1;
    p16.dirtAreaBoost = 1;
    p16.sprayedSeconds = 0;
    p16.upgradeHintShown = false;
    p16.hintLevel = 0;
    p16.lastDirtProgress = 0;
    p16.finishListeners = {};
end;

function u14.onStart(u19) -- Line: 166
    -- upvalues: TestingFlags (copy), MiscEvents (copy)
    if not TestingFlags.cleaningTools then
        return nil;
    end;

    u19.itemRayParams.FilterType = Enum.RaycastFilterType.Include;
    u19.dirtRayParams.FilterType = Enum.RaycastFilterType.Include;
    u19:bindInput();
    MiscEvents.SetPowerfulSpray:connect(function(p20) -- Line: 173
        -- upvalues: u19 (copy)
        if u19.powerful == p20 then
            return nil;
        end;

        u19.powerful = p20;
        task.spawn(function() -- Line: 178
            -- upvalues: u19 (ref)
            return u19:rebuildRig();
        end);
    end);
    task.spawn(function() -- Line: 182
        -- upvalues: u19 (copy)
        return u19:rebuildRig();
    end);
end;

function u14.onDataChanged(u21, p22) -- Line: 186
    -- upvalues: TestingFlags (copy)
    if not TestingFlags.cleaningTools then
        return nil;
    end;

    if table.find(p22, "EquippedSpray") == nil then
        return nil;
    end;

    if u21.equipped == u21.data:getData().EquippedSpray then
        return nil;
    end;

    task.spawn(function() -- Line: 196
        -- upvalues: u21 (copy)
        return u21:rebuildRig();
    end);
end;

function u14.graftSprayRig(p23, p24) -- Line: 200
    -- upvalues: WFChain (copy), ReplicatedStorage (copy), u3 (copy)
    if p24:FindFirstChild("Start") then
        return nil;
    end;

    local Sprayer = p24:WaitForChild("Sprayer");
    local Nozzle = p24:WaitForChild("Nozzle");
    local Handle = p24:WaitForChild("Handle");
    local v25 = WFChain(ReplicatedStorage, "Assets", "SprayBottles", "Basic Spray Bottle"):Clone();
    local Plunge = v25:WaitForChild("Plunge");
    local End = Plunge:WaitForChild("End");
    local Muzzle = v25:WaitForChild("Muzzle");
    local v26 = WFChain(v25, "Handle", "spray");
    local RightVector = Sprayer.CFrame.RightVector;

    if RightVector:Dot(Sprayer.Position - Nozzle.Position) < 0 then
        RightVector = RightVector * -1;
    end;

    local v27 = CFrame.lookAt(Sprayer.Position, Sprayer.Position + RightVector);
    local v28 = Sprayer.Position + RightVector * 6.25;
    Plunge.CFrame = CFrame.lookAt(v28, v28 + RightVector) * End.CFrame:Inverse();
    Muzzle.CFrame = v27;

    for _, v in u3 do
        v25:WaitForChild(v).Parent = p24;
    end;

    Plunge.Parent = p24;
    Muzzle.Parent = p24;
    v26.Parent = Handle;
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "Start";
    Attachment.Parent = p24;
    Attachment.CFrame = p24:GetPivot():ToObjectSpace(v27);
    v25:Destroy();
end;

function u14.rebuildRig(p29) -- Line: 236
    -- upvalues: SprayBottles (copy), u10 (copy), WFChain (copy), ReplicatedStorage (copy), Workspace (copy), u3 (copy), u7 (copy), u4 (copy), ContentProvider (copy)
    p29.equipped = p29.data:getData().EquippedSpray;
    local v30 = SprayBottles[p29.equipped];

    if p29.powerful then
        v30 = table.clone(v30);
        setmetatable(v30, nil);

        for i, v in u10 do
            v30[i] = v;
        end;
    end;

    p29.config = v30;
    local rig = p29.rig;

    if rig ~= nil then
        rig.bottle:Destroy();
    end;

    p29.rig = nil;
    local u31 = WFChain(ReplicatedStorage, "Assets", "SprayBottles", v30.assetName):Clone();
    p29:graftSprayRig(u31);
    u31.Parent = Workspace;
    local Plunge = u31:WaitForChild("Plunge");
    local Start = u31:WaitForChild("Start");
    local End = Plunge:WaitForChild("End");
    local Muzzle = u31:WaitForChild("Muzzle");
    local v32 = table.create(#u3);

    local function _(p33) -- Line: 267
        -- upvalues: u31 (copy)
        return u31:WaitForChild(p33);
    end;

    for i, v in u3 do
        local _ = i - 1;
        v32[i] = u31:WaitForChild(v);
    end;

    local Mist = Plunge:WaitForChild("Mist");
    Mist.Brightness = 0.6;
    Mist.LightEmission = 0.2;
    Mist.Transparency = u7;
    Mist.Rate = Mist.Rate * 0.5;
    local Part = Instance.new("Part");
    Part.Name = "MistAnchor";
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CFrame = u4;
    Part.Parent = u31;
    Mist.Parent = Part;
    local v34 = WFChain(u31, "Handle", "spray");
    v34.Looped = true;
    v34.Parent = Muzzle;
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://9120667689";
    Sound.Looped = true;
    Sound.PlaybackSpeed = 1.05;
    Sound.Volume = 0;
    Sound.RollOffMaxDistance = v34.RollOffMaxDistance;
    Sound.Parent = Muzzle;
    local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect");
    EqualizerSoundEffect.HighGain = 3;
    EqualizerSoundEffect.MidGain = 1;
    EqualizerSoundEffect.LowGain = -2;
    EqualizerSoundEffect.Parent = Sound;
    task.spawn(function() -- Line: 305
        -- upvalues: ContentProvider (ref), Sound (copy)
        return ContentProvider:PreloadAsync({ Sound });
    end);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "NozzleStart";
    Attachment.Parent = Muzzle;
    Attachment.WorldCFrame = Start.WorldCFrame;

    for _, v in v32 do
        v.Attachment0 = Attachment;
        v.FaceCamera = true;
    end;

    local v35 = CFrame.lookAt(Start.WorldPosition, End.WorldPosition):ToObjectSpace(u31:GetPivot());

    for _, v in v32 do
        v.Enabled = false;
    end;

    Mist.Enabled = false;
    u31:PivotTo(u4);
    p29.rig = {
        bottle = u31,
        beams = v32,
        plunge = Plunge,
        mistAnchor = Part,
        mist = Mist,
        mistSize = Mist.Size,
        mistRate = Mist.Rate,
        sound = v34,
        soundVolume = v34.Volume * 0.45,
        contact = Sound,
        contactEq = EqualizerSoundEffect,
        pivotFromNozzle = v35
    };

    for _, v in v32 do
        v.Width1 = v30.beamWidth;
    end;

    Plunge.Size = Vector3.new(v30.beamWidth, 0.4, v30.beamWidth);
    Part.Size = Plunge.Size;
    v34.PlaybackSpeed = v30.pressurePitch;
end;

function u14.beginSession(p36, p37, p38) -- Line: 344
    -- upvalues: CLEAN_REFERENCE_AREA (copy), CLEAN_AREA_EXPONENT (copy), Players (copy), Workspace (copy), UserInputService (copy)
    p36.dirtToughness = p38;
    p36.sprayedSeconds = 0;
    local v39, v40 = p37:GetBoundingBox();
    local Position = v39.Position;
    p36.dirtAreaBoost = math.pow(2 * (v40.X * v40.Y + v40.Y * v40.Z + v40.Z * v40.X) / CLEAN_REFERENCE_AREA, 1 - CLEAN_AREA_EXPONENT);
    local v41 = math.max(v40.Magnitude * 0.75, 6);
    p36.pitch = -0.5585053606381855;
    local Character = Players.LocalPlayer.Character;

    if Character ~= nil then
        Character = Character:GetPivot();
    end;

    if Character then
        local v42 = Position - Character.Position;
        p36.yaw = math.atan2(-v42.X, -v42.Z);
    else
        p36.yaw = 0;
    end;

    p36.currentHoldLocal = nil;
    p36.aimDistance = nil;
    p36.finishing = false;
    p36.revealed = false;
    p36.sessionItem = p37;
    p36.sessionContainer = p37:FindFirstChild("DirtCoat", true);
    p36:applyRayFilters(p37);
    p36.spinAngle = 0;
    p36.spinVelocity = 0;
    p36.spinAnchor = CFrame.new(Position);
    p36.spinBase = p36.spinAnchor:Inverse() * p37:GetPivot();
    local v43 = math.max(v40.X, v40.Y, v40.Z) / 2;
    p36.target = {
        center = Position,
        distance = v41,
        radius = v43
    };
    p36:applyDepthOfField(v41, v43);
    p36.dirtCells = nil;
    p36.dirtBlocks = {};
    p36.dirtTotal = 0;
    p36.hintLevel = 0;
    p36.lastDirtProgress = os.clock();
    p36:createHint();
    p36:applyMistScale((math.clamp(v43 / 3, 0.3, 1)));
    local CurrentCamera = Workspace.CurrentCamera;
    local v44;

    if CurrentCamera and UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 then
        v44 = CurrentCamera.ViewportSize / 2;
    else
        v44 = UserInputService:GetMouseLocation();
    end;

    p36.aimPosition = v44;
    p36.lastAim = p36.aimPosition;
    UserInputService.MouseIconEnabled = true;
    p36.cleanBar:show();
end;

function u14.primeDirt(u45, u46, u47) -- Line: 399
    -- upvalues: DirtMask (copy)
    local sessionContainer = u45.sessionContainer;

    if u45.sessionItem ~= u46 or not sessionContainer then
        return nil;
    end;

    local v48 = DirtMask.frameFor(u46);

    if not v48 then
        return nil;
    end;

    local u49 = DirtMask.blocksOf(sessionContainer);
    DirtMask.indexBlocks(u49, v48, function(u50) -- Line: 409
        -- upvalues: u45 (copy), u46 (copy), u47 (copy), u49 (copy), DirtMask (ref)
        if u45.sessionItem ~= u46 then
            return nil;
        end;

        if u47 == nil then
            u45:finishPrime(u46, u49, u50);

            return nil;
        end;

        DirtMask.applyFractions(u49, u50, DirtMask.decode(u47), function() -- Line: 417
            -- upvalues: u45 (ref), u46 (ref), u49 (ref), u50 (copy)
            if u45.sessionItem ~= u46 then
                return nil;
            end;

            u45:finishPrime(u46, u49, u50);
        end);
    end);
end;

function u14.finishPrime(p51, p52, p53, p54) -- Line: 425
    -- upvalues: DirtMask (copy), DirtCoat (copy)
    p51.dirtCells = p54;
    p51.dirtTotal = DirtMask.sumOf(p54.totals);

    local function _(p55) -- Line: 430
        return p55.Parent ~= nil;
    end;

    local v56 = 0;
    local v57 = {};

    for i, v in p53 do
        local _ = i - 1;

        if v.Parent ~= nil == true then
            v56 = v56 + 1;
            v57[v56] = v;
        end;
    end;

    p51.dirtBlocks = v57;

    if p51:cleanedCount() > 0 and not p51.revealed then
        p51.revealed = true;
        DirtCoat.reveal(p52);
    end;

    p51:updateProgress();
    p51:finishWhenClean();
end;

function u14.currentMask(p58) -- Line: 449
    -- upvalues: DirtMask (copy)
    local dirtCells = p58.dirtCells;

    if dirtCells and p58:cleanedCount() ~= 0 then
        return DirtMask.encode(dirtCells);
    end;

    return nil;
end;

function u14.cleanedCount(p59) -- Line: 456
    return p59.dirtTotal - #p59.dirtBlocks;
end;

function u14.updateProgress(p60) -- Line: 459
    local v61 = p60.dirtTotal <= 0 and 0 or p60:cleanedCount() / p60.dirtTotal;
    p60.cleanBar:setProgress(v61);
    local rig = p60.rig;

    if rig then
        rig.sound.PlaybackSpeed = p60.config.pressurePitch * (1 + v61 * 0.35);
    end;
end;

function u14.finishWhenClean(p62) -- Line: 467
    if not p62.dirtCells then
        return nil;
    end;

    if #p62.dirtBlocks == 0 then
        p62:forceFinish();

        return nil;
    end;

    if p62.dirtTotal == 0 or p62:cleanedCount() / p62.dirtTotal < 0.95 then
        return nil;
    end;

    p62:sweepRemaining();
    p62:forceFinish();
end;

function u14.sweepRemaining(p63) -- Line: 481
    -- upvalues: DirtBlock (copy), DirtCoat (copy)
    local v64 = (p63.impactNormal or Vector3.new(0, 1, 0)) * -1;

    for i = #p63.dirtBlocks - 1, 0, -1 do
        local v65 = p63.dirtBlocks[i + 1];
        p63:dropBlock(i);

        if v65.Parent ~= nil then
            p63:recordCleaned(v65);
            DirtBlock.popOff(v65, v64);
        end;
    end;

    if not p63.revealed and p63.sessionItem then
        p63.revealed = true;
        DirtCoat.reveal(p63.sessionItem);
    end;

    p63:updateProgress();
end;

function u14.popAllDirt(p66) -- Line: 498
    -- upvalues: DirtCoat (copy), DirtMask (copy), Workspace (copy), DirtBudget (copy), DirtBlock (copy)
    local sessionContainer = p66.sessionContainer;
    local sessionItem = p66.sessionItem;

    if not (sessionContainer and sessionItem) then
        return nil;
    end;

    if not p66.revealed then
        p66.revealed = true;
        DirtCoat.reveal(sessionItem);
    end;

    local function _(p67) -- Line: 511
        return p67.Anchored;
    end;

    local v68 = 0;
    local v69 = {};

    for i, v in DirtMask.blocksOf(sessionContainer) do
        local _ = i - 1;

        if v.Anchored == true then
            v68 = v68 + 1;
            v69[v68] = v;
        end;
    end;

    for _, v in v69 do
        v.Parent = Workspace;
    end;

    sessionContainer:Destroy();
    p66.sessionContainer = nil;
    p66.dirtBlocks = {};
    DirtBudget.scheduleBatch(v69, function(p70) -- Line: 529
        -- upvalues: DirtBlock (ref)
        if p70.Parent ~= nil then
            DirtBlock.popOff(p70, Vector3.new(0, 0, 0));
        end;
    end);
end;

function u14.recordCleaned(p71, p72) -- Line: 535
    -- upvalues: DirtMask (copy)
    local dirtCells = p71.dirtCells;

    if not dirtCells then
        return nil;
    end;

    local v73 = DirtMask.cellOf(p72);

    if v73 == nil then
        return nil;
    end;

    dirtCells.cleaned[v73 + 1] = math.min(dirtCells.cleaned[v73 + 1] + 1, dirtCells.totals[v73 + 1]);
end;

function u14.applyMistScale(p74, u75) -- Line: 546
    local rig = p74.rig;

    if not rig then
        return nil;
    end;

    rig.mist.Rate = rig.mistRate * u75;
    local Keypoints = rig.mistSize.Keypoints;
    local v76 = table.create(#Keypoints);

    local function _(p77) -- Line: 555
        -- upvalues: u75 (copy)
        return NumberSequenceKeypoint.new(p77.Time, p77.Value * u75, p77.Envelope * u75);
    end;

    for i, v in Keypoints do
        local _ = i - 1;
        v76[i] = NumberSequenceKeypoint.new(v.Time, v.Value * u75, v.Envelope * u75);
    end;

    rig.mist.Size = NumberSequence.new(v76);
end;

function u14.endSession(p78) -- Line: 564
    -- upvalues: u4 (copy), UserInputService (copy)
    p78:clearHint();
    p78.target = nil;
    p78.sessionItem = nil;
    p78.sessionContainer = nil;
    p78.itemRayParams.FilterDescendantsInstances = {};
    p78.dirtRayParams.FilterDescendantsInstances = {};
    p78.dirtCells = nil;
    p78.dirtBlocks = {};
    p78.dirtTotal = 0;
    table.clear(p78.triggersHeld);
    p78:setSprayActive(false);
    p78.currentHoldLocal = nil;
    p78.aimDistance = nil;
    p78:clearDepthOfField();
    local rig = p78.rig;

    if rig ~= nil then
        rig.bottle:PivotTo(u4);
    end;

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
    UserInputService.MouseIconEnabled = true;
    p78.cleanBar:hide();
end;

function u14.applyDepthOfField(p79, p80, p81) -- Line: 587
    -- upvalues: Lighting (copy)
    p79:clearDepthOfField();
    local DepthOfFieldEffect = Instance.new("DepthOfFieldEffect");
    DepthOfFieldEffect.FarIntensity = 0.75;
    DepthOfFieldEffect.NearIntensity = 0.1;
    DepthOfFieldEffect.FocusDistance = p80;
    DepthOfFieldEffect.InFocusRadius = p81 + 3;
    DepthOfFieldEffect.Parent = Lighting;
    p79.dofEffect = DepthOfFieldEffect;
end;

function u14.clearDepthOfField(p82) -- Line: 597
    local dofEffect = p82.dofEffect;

    if dofEffect ~= nil then
        dofEffect:Destroy();
    end;

    p82.dofEffect = nil;
end;

function u14.createHint(p83) -- Line: 604
    -- upvalues: u8 (copy)
    p83:clearHint();
    local sessionContainer = p83.sessionContainer;

    if not sessionContainer then
        return nil;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.FillColor = u8;
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 1;
    Highlight.Enabled = false;
    Highlight.Adornee = sessionContainer;
    Highlight.Parent = sessionContainer;
    p83.hint = Highlight;
end;

function u14.clearHint(p84) -- Line: 620
    local hint = p84.hint;

    if hint ~= nil then
        hint:Destroy();
    end;

    p84.hint = nil;
end;

function u14.updateHint(p85, p86) -- Line: 627
    local hint = p85.hint;

    if not hint then
        return nil;
    end;

    local v87 = os.clock() - p85.lastDirtProgress > 3;
    local hintLevel = p85.hintLevel;
    local v88 = 1 - math.exp(-7 * p86);
    p85.hintLevel = hintLevel + ((v87 and 1 or 0) - hintLevel) * v88;

    if p85.hintLevel < 0.01 then
        hint.Enabled = false;

        return nil;
    end;

    hint.Enabled = true;
    local v89 = os.clock() / 0.85 * 3.141592653589793 * 2;
    local v90 = 0.88 + -0.53 * ((1 - math.cos(v89)) * 0.5);
    hint.FillTransparency = 1 - p85.hintLevel * (1 - v90);
end;

function u14.hasSprayUpgrade(p91) -- Line: 643
    -- upvalues: SPRAY_TIER_ORDER (copy)
    local v92 = (table.find(SPRAY_TIER_ORDER, p91.equipped) or 0) - 1;
    local v93;

    if v92 >= 0 then
        v93 = v92 < #SPRAY_TIER_ORDER - 1;
    else
        v93 = false;
    end;

    return v93;
end;

function u14.projectedCleanSeconds(p94) -- Line: 648
    if p94.dirtTotal == 0 then
        return 0;
    end;

    local v95 = p94:cleanedCount() / p94.dirtTotal;

    return v95 <= 0 and (1 / 0) or p94.sprayedSeconds / v95;
end;

function u14.updateUpgradeHint(p96, p97) -- Line: 655
    -- upvalues: ItemsEvents (copy), Notification (copy)
    if p96.upgradeHintShown or not (p96.spraying and p96.contactBlocksNearby) then
        return nil;
    end;

    local v98 = p96.data:getDataIfLoaded();

    if v98 ~= nil then
        v98 = v98.SprayUpgradeHintSeen;
    end;

    if v98 then
        p96.upgradeHintShown = true;

        return nil;
    end;

    p96.sprayedSeconds = p96.sprayedSeconds + p97;

    if p96.sprayedSeconds < 8 or not p96:hasSprayUpgrade() then
        return nil;
    end;

    if p96:projectedCleanSeconds() < 40 then
        return nil;
    end;

    p96.upgradeHintShown = true;
    ItemsEvents.markSprayUpgradeHintSeen:fire();
    Notification.new("Upgrade spray bottle to go faster!", 4, "Pop", "Light Gray");
end;

function u14.onFinish(p99, p100) -- Line: 678
    p99.finishListeners[p100] = true;
end;

function u14.onRender(p101, p102) -- Line: 683
    -- upvalues: Workspace (copy)
    local rig = p101.rig;
    local target = p101.target;

    if not (rig and target) then
        return nil;
    end;

    if p101.finishing then
        return nil;
    end;

    p101:updateHint(p102);
    p101:updateUpgradeHint(p102);
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    end;

    local v103 = CFrame.fromOrientation(p101.pitch, p101.yaw, 0);
    CurrentCamera.CFrame = v103 + (target.center - v103.LookVector * target.distance);
    local sessionItem = p101.sessionItem;

    if sessionItem then
        p101.spinVelocity = p101.spinVelocity + ((p101.spraying and 0 or 0.6981317007977318) - p101.spinVelocity) * (1 - math.exp(-6 * p102));
        p101.spinAngle = p101.spinAngle + p101.spinVelocity * p102;
        sessionItem:PivotTo(p101.spinAnchor * CFrame.Angles(0, p101.spinAngle, 0) * p101.spinBase);
    end;

    local v104 = p101:computeAim(CurrentCamera, p102);
    local v105 = v104 - p101.lastAim;
    p101.lastAim = v104;
    p101.sway = p101.sway:Lerp(v105, 1 - math.exp(-10 * p102));
    local v106 = CurrentCamera:ViewportPointToRay(v104.X, v104.Y);
    local v107 = (v106.Origin - target.center).Magnitude + target.radius;
    local v108 = v106.Direction * v107;
    local v109 = Workspace:Raycast(v106.Origin, v108, p101.itemRayParams) or Workspace:Raycast(v106.Origin, v108, p101.dirtRayParams);
    local v110;

    if v109 == nil then
        v110 = false;
    else
        v110 = v109.Distance <= v107;
    end;

    if v110 then
        v107 = v109.Distance;
    end;

    local aimDistance = p101.aimDistance;

    if aimDistance ~= nil then
        v107 = aimDistance + (v107 - aimDistance) * (1 - math.exp(-16 * p102));
    end;

    p101.aimDistance = v107;
    local v111 = v106.Origin + v106.Direction * v107;
    local v112 = p101:clampHoldToView(CurrentCamera, v106.Origin + v106.Direction * p101.config.holdDistance + CurrentCamera.CFrame.RightVector * 1 - CurrentCamera.CFrame.UpVector * 0.75);
    local v113 = math.clamp(-p101.sway.X * 0.0045, -0.4886921905584123, 0.4886921905584123);
    local v114 = CurrentCamera.CFrame:PointToObjectSpace(v112);

    if p101.currentHoldLocal then
        v114 = p101.currentHoldLocal:Lerp(v114, 1 - math.exp(-14 * p102));
    end;

    p101.currentHoldLocal = v114;
    local v115 = CurrentCamera.CFrame:PointToWorldSpace(p101.currentHoldLocal);
    p101.squeeze = p101.squeeze + ((p101.spraying and 1 or 0) - p101.squeeze) * (1 - math.exp(-16 * p102));
    local v116 = v115 - (v111 - v115).Unit * (0.35 * p101.squeeze);
    local v117 = CFrame.lookAt(v116, v111) * CFrame.Angles(0, 0, p101.config.barrelRoll + v113);
    rig.bottle:PivotTo(v117 * rig.pivotFromNozzle);

    if p101.spraying then
        if not v110 then
            v109 = nil;
        end;

        p101:updateImpact(rig, v109, v116, v111, p102);
    end;
end;

function u14.computeAim(p118, p119, p120) -- Line: 762
    -- upvalues: UserInputService (copy)
    if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 then
        local v121 = p118:readThumbstick();
        local ViewportSize = p119.ViewportSize;
        local v122 = 1.1 * ViewportSize.Y * p120;
        p118.aimPosition = Vector2.new(math.clamp(p118.aimPosition.X + v121.X * v122, 0, ViewportSize.X), (math.clamp(p118.aimPosition.Y - v121.Y * v122, 0, ViewportSize.Y)));
    else
        p118.aimPosition = UserInputService:GetMouseLocation();
    end;

    return p118.aimPosition;
end;

function u14.readThumbstick(p123) -- Line: 773
    -- upvalues: UserInputService (copy)
    for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
        if v.KeyCode == Enum.KeyCode.Thumbstick1 then
            local v124 = Vector2.new(v.Position.X, v.Position.Y);
            local Magnitude = v124.Magnitude;

            if Magnitude < 0.2 then
                return Vector2.zero;
            end;

            return v124.Unit * ((Magnitude - 0.2) / 0.8);
        end;
    end;

    return Vector2.zero;
end;

function u14.clampHoldToView(p125, p126, p127) -- Line: 789
    local v128 = p126:WorldToViewportPoint(p127);

    if v128.Z <= 0 then
        return p127;
    end;

    local ViewportSize = p126.ViewportSize;
    local v129 = math.clamp(v128.X, ViewportSize.X * 0.12, ViewportSize.X * 0.88);
    local v130 = math.clamp(v128.Y, ViewportSize.Y * 0.16, ViewportSize.Y * 0.84);

    if v129 == v128.X and v130 == v128.Y then
        return p127;
    end;

    local Magnitude = (p127 - p126.CFrame.Position).Magnitude;
    local v131 = p126:ViewportPointToRay(v129, v130);

    return v131.Origin + v131.Direction * Magnitude;
end;

function u14.updateImpact(p132, p133, p134, p135, p136, p137) -- Line: 808
    local Unit = (p136 - p135).Unit;
    local v138;

    if p134 then
        v138 = p134.Normal;
    else
        v138 = Unit * -1;
    end;

    local v139 = p132:smoothImpactNormal(v138, p137);
    local v140 = v139:Cross(Vector3.new(0, 0, 1));

    if v140.Magnitude < 0.001 then
        v140 = v139:Cross(Vector3.new(1, 0, 0));
    end;

    local v141 = CFrame.fromMatrix(p136 + v139 * 0.2, v140.Unit, v139);
    p133.plunge.CFrame = v141;
    p133.mistAnchor.CFrame = v141;
    p133.mist.Enabled = p134 ~= nil;

    if p134 then
        p132:sampleContactSurface(p136);
    else
        p132.contactBlocksNearby = false;
    end;

    local v142 = os.clock();

    if p132.contactBlocksNearby then
        p132.lastDirtContact = v142;
    end;

    local v143 = v142 - p132.lastDirtContact < 0.3 and 1 or 0;
    local contactLevel = p132.contactLevel;
    local v144 = 1 - math.exp(-(p132.contactLevel < v143 and 13 or 6) * p137);
    p132.contactLevel = contactLevel + (v143 - contactLevel) * v144;

    if p132.contactBlocksNearby then
        local soapBlend = p132.soapBlend;
        local cleanRatio = p132.cleanRatio;
        local v145 = 1 - math.exp(-3.5 * p137);
        p132.soapBlend = soapBlend + (cleanRatio - soapBlend) * v145;
    end;

    p133.contact.Volume = p133.soundVolume * (0.75 + -0.35 * p132.soapBlend) * p132.contactLevel;
    p133.contact.PlaybackSpeed = 1.05 + -0.33000000000000007 * p132.soapBlend;
    p133.contactEq.HighGain = 3 + -8 * p132.soapBlend;
    p133.contactEq.MidGain = 1 + 1 * p132.soapBlend;
    p133.contactEq.LowGain = -2 + 6 * p132.soapBlend;

    if not p134 then
        return nil;
    end;

    p132:dissolveAround(p135, p136, Unit, p137);
end;

function u14.smoothImpactNormal(p146, p147, p148) -- Line: 849
    local impactNormal = p146.impactNormal;
    local v149;

    if impactNormal then
        v149 = impactNormal:Lerp(p147, 1 - math.exp(-10 * p148));
    else
        v149 = p147;
    end;

    if v149.Magnitude >= 0.001 then
        p147 = v149.Unit;
    end;

    p146.impactNormal = p147;

    return p147;
end;

function u14.sampleContactSurface(p150, p151) -- Line: 856
    -- upvalues: DirtBlock (copy)
    local v152 = p150.config.dissolveRadius * p150.config.dissolveRadius;
    local v153 = 0;
    local v154 = 0;

    for _, v in p150.dirtBlocks do
        local v155 = v.Position - p151;

        if v152 >= v155:Dot(v155) then
            v153 = v153 + 1;
            v154 = v154 + DirtBlock.cleanliness(v);
        end;
    end;

    p150.contactBlocksNearby = v153 > 0;
    p150.cleanRatio = v153 <= 0 and 0 or v154 / v153;
end;

function u14.dropBlock(p156, p157) -- Line: 873
    p156.dirtBlocks[p157 + 1] = p156.dirtBlocks[#p156.dirtBlocks - 1 + 1];
    local dirtBlocks = p156.dirtBlocks;
    dirtBlocks[#dirtBlocks] = nil;
end;

function u14.dissolveAround(p158, p159, p160, p161, p162) -- Line: 879
    -- upvalues: DirtBlock (copy), DirtCoat (copy)
    local dissolveRadius = p158.config.dissolveRadius;
    local v163 = dissolveRadius * dissolveRadius;
    local v164 = p158.config.beamWidth * 0.6;
    local v165 = math.max(dissolveRadius - v164, 0.001);
    local v166 = p160 - p159;
    local v167 = v166:Dot(v166);

    for i = #p158.dirtBlocks - 1, 0, -1 do
        local v168 = p158.dirtBlocks[i + 1];

        if v168.Parent == nil then
            p158:dropBlock(i);
        else
            local v169 = v168.Position - p159;
            local v170;

            if v167 > 1e-6 then
                local v171 = v169:Dot(v166) / v167;
                v170 = math.clamp(v171, 0, 1);
            else
                v170 = 0;
            end;

            local v172 = v169 - v166 * v170;
            local v173 = v172:Dot(v172);

            if v163 >= v173 then
                p158.lastDirtProgress = os.clock();
                local v174 = math.sqrt(v173);
                local v175 = math.clamp(1 - (v174 - v164) / v165, 0, 1);

                if DirtBlock.dissolve(v168, p158.config.dissolveRate * p158.dirtAreaBoost / p158.dirtToughness * (1 - v174 / dissolveRadius) * p162, v175) then
                    if not p158.revealed and p158.sessionItem then
                        p158.revealed = true;
                        DirtCoat.reveal(p158.sessionItem);
                    end;

                    p158:recordCleaned(v168);
                    DirtBlock.popOff(v168, p161);
                    p158:dropBlock(i);
                end;
            end;
        end;
    end;

    p158:updateProgress();
    p158:finishWhenClean();
end;

function u14.forceFinish(p176) -- Line: 921
    -- upvalues: u4 (copy)
    if p176.finishing then
        return nil;
    end;

    p176.finishing = true;
    p176:clearHint();
    p176:setSprayActive(false);
    p176.cleanBar:hide();
    local rig = p176.rig;

    if rig ~= nil then
        rig.bottle:PivotTo(u4);
    end;

    for i in p176.finishListeners do
        task.spawn(i);
    end;
end;

function u14.halt(p177) -- Line: 937
    -- upvalues: u4 (copy)
    if p177.finishing then
        return nil;
    end;

    p177.finishing = true;
    p177:clearHint();
    p177:setSprayActive(false);
    p177.cleanBar:hide();
    local rig = p177.rig;

    if rig ~= nil then
        rig.bottle:PivotTo(u4);
    end;
end;

function u14.setSprayActive(u178, p179) -- Line: 950
    -- upvalues: TweenService (copy), u5 (copy), u6 (copy)
    local rig = u178.rig;

    if not rig or u178.spraying == p179 then
        return nil;
    end;

    u178.spraying = p179;

    for _, v in rig.beams do
        v.Enabled = p179;
    end;

    local soundFade = u178.soundFade;

    if soundFade ~= nil then
        soundFade:Cancel();
    end;

    local contactFade = u178.contactFade;

    if contactFade ~= nil then
        contactFade:Cancel();
    end;

    if p179 then
        u178.impactNormal = nil;

        if not rig.sound.IsPlaying then
            rig.sound.Volume = 0;
            rig.sound:Play();
        end;

        if not rig.contact.IsPlaying then
            u178.contactLevel = 0;
            u178.soapBlend = 0;
            rig.contact.Volume = 0;
            rig.contact.TimePosition = 0.3;
            rig.contact:Play();
        end;

        u178.soundFade = TweenService:Create(rig.sound, u5, {
            Volume = rig.soundVolume
        });
        u178.soundFade:Play();

        return;
    end;

    rig.mist.Enabled = false;
    local u180 = TweenService:Create(rig.sound, u6, {
        Volume = 0
    });
    u178.soundFade = u180;
    u178.contactFade = TweenService:Create(rig.contact, u6, {
        Volume = 0
    });
    u178.contactFade:Play();
    u180.Completed:Connect(function() -- Line: 994
        -- upvalues: u178 (copy), u180 (copy), rig (copy)
        if u178.soundFade ~= u180 or u178.spraying then
            return nil;
        end;

        rig.sound:Stop();
        rig.contact:Stop();
    end);
    u180:Play();
end;

function u14.bindInput(u181) -- Line: 1004
    -- upvalues: UserInputService (copy), u9 (copy)
    UserInputService.InputBegan:Connect(function(p182, p183) -- Line: 1005
        -- upvalues: u181 (copy), u9 (ref)
        if not u181.target or u181.finishing then
            return nil;
        end;

        local UserInputType = p182.UserInputType;

        if p183 then
            return nil;
        end;

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
            u181:setSprayActive(true);

            return;
        end;

        if table.find(u9, p182.KeyCode) ~= nil then
            u181.triggersHeld[p182.KeyCode] = true;
            u181:setSprayActive(true);
        end;
    end);
    UserInputService.InputEnded:Connect(function(p184) -- Line: 1025
        -- upvalues: u181 (copy), u9 (ref)
        local UserInputType = p184.UserInputType;

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
            u181:setSprayActive(false);

            return;
        end;

        if table.find(u9, p184.KeyCode) ~= nil then
            u181.triggersHeld[p184.KeyCode] = nil;
            local v185 = 0;

            for _ in u181.triggersHeld do
                v185 = v185 + 1;
            end;

            if v185 == 0 then
                u181:setSprayActive(false);
            end;
        end;
    end);
end;

function u14.applyRayFilters(p186, p187) -- Line: 1048
    local sessionContainer = p186.sessionContainer;
    local v188 = {};

    for _, descendant in p187:GetDescendants() do
        if descendant:IsA("BasePart") and not (sessionContainer and descendant:IsDescendantOf(sessionContainer)) then
            table.insert(v188, descendant);
        end;
    end;

    p186.itemRayParams.FilterDescendantsInstances = v188;
    p186.dirtRayParams.FilterDescendantsInstances = sessionContainer and { sessionContainer } or {};
end;

Reflect.defineMetadata(u14, "identifier", "client/controllers/world/SprayBottleController@SprayBottleController");
Reflect.defineMetadata(u14, "flamework:parameters", { "client/controllers/world/CleanBarController@CleanBarController", "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u14, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u14, "$:flamework@Controller", Controller, { {} });

return {
    SprayBottleController = u14
};