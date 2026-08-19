-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local ReplicatedStorage = v1.ReplicatedStorage;
local StarterGui = v1.StarterGui;
local TweenService = v1.TweenService;
local UserInputService = v1.UserInputService;
local Workspace = v1.Workspace;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants");
local Player = v2.Player;
local PlayerGui = v2.PlayerGui;
local rarityStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "RarityStyles").rarityStyleFor;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local v3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ShovelNetwork");
local ShovelEvents = v3.ShovelEvents;
local ShovelFunctions = v3.ShovelFunctions;
local RarityBeams = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "RarityBeams").RarityBeams;
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "DiggingConfig");
local DIG_ATTEMPT_INTERVAL = v4.DIG_ATTEMPT_INTERVAL;
local DIG_CLICK_ENERGY_DECAY = v4.DIG_CLICK_ENERGY_DECAY;
local DIG_CLICK_ENERGY_GAIN = v4.DIG_CLICK_ENERGY_GAIN;
local DIG_EFFECTIVE_CLICK_BURST = v4.DIG_EFFECTIVE_CLICK_BURST;
local DIG_EFFECTIVE_CLICKS_PER_SECOND = v4.DIG_EFFECTIVE_CLICKS_PER_SECOND;
local DIG_EXCLAMATION_ENABLED = v4.DIG_EXCLAMATION_ENABLED;
local DIG_INPUT_SEND_INTERVAL = v4.DIG_INPUT_SEND_INTERVAL;
local DIG_INTENT_WINDOW = v4.DIG_INTENT_WINDOW;
local DIG_LOSE_THRESHOLD = v4.DIG_LOSE_THRESHOLD;
local DIG_POWER_DEFAULT = v4.DIG_POWER_DEFAULT;
local DIG_POWER_MAX_SECONDS = v4.DIG_POWER_MAX_SECONDS;
local DIG_POWER_MIN_STOP_SECONDS = v4.DIG_POWER_MIN_STOP_SECONDS;
local DIG_POWER_TIERS = v4.DIG_POWER_TIERS;
local DIG_PROGRESS_START = v4.DIG_PROGRESS_START;
local DIG_REVEAL_SECONDS = v4.DIG_REVEAL_SECONDS;
local DIG_WIN_THRESHOLD = v4.DIG_WIN_THRESHOLD;
local MOUND_MIN_RADIUS = v4.MOUND_MIN_RADIUS;
local digPowerAt = v4.digPowerAt;
local digTierFor = v4.digTierFor;
local isDigImpossible = v4.isDigImpossible;
local moundRadiusFor = v4.moundRadiusFor;
local DIG_ZONE_TAG = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").DIG_ZONE_TAG;
local v5 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "DirtTypes");
local dirtFor = v5.dirtFor;
local dirtForRarity = v5.dirtForRarity;
local BackpackCapacity = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "inventory", "BackpackCapacity").BackpackCapacity;
local v6 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local itemNameFor = v6.itemNameFor;
local Items = v6.Items;
local TUTORIAL_PROGRESS_FLOOR = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "tutorial", "TutorialConfig").TUTORIAL_PROGRESS_FLOOR;
local CFrameUtils = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "cframe", "CFrameUtils").CFrameUtils;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local ItemModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "items", "ItemModel").ItemModel;
local v7 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil");
local playSound = v7.playSound;
local playWorldSound = v7.playWorldSound;
local prewarmWorldSounds = v7.prewarmWorldSounds;
local v8 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtCoat");
local DirtCoat = v8.DirtCoat;
local TOOL_DIRT = v8.TOOL_DIRT;
local PassThroughTag = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "PassThroughTag").PassThroughTag;

local function _(p9, p10) -- Line: 117
    return math.max(p9, p10.luck);
end;

local u11 = 1;
local u12 = { "DirtThrow1", "DirtThrow2", "DirtThrow3" };
local u13 = { "ShovelImpact1", "ShovelImpact2", "ShovelImpact3" };

for i = 1, #DIG_POWER_TIERS do
    local _ = i - 1;
    u11 = math.max(u11, DIG_POWER_TIERS[i].luck);
end;

local u14 = CFrame.new(0, -500, 0);

local function u21(p15) -- Line: 137
    local v16, v17, v18 = p15:ToHSV();
    local v19 = Color3.fromHSV(v16, math.max(v17 - 0.28, 0), (math.min(v18 + 0.12, 1)));
    local v20 = Color3.fromHSV(v16, math.min(v17 + 0.06, 1), v18);

    return ColorSequence.new({ ColorSequenceKeypoint.new(0, v19), ColorSequenceKeypoint.new(1, v20) });
end;

local function _(p22, p23) -- Line: 143
    return UDim2.new(p22.X.Scale * p23, p22.X.Offset * p23, p22.Y.Scale * p23, p22.Y.Offset * p23);
end;

local u24 = setmetatable({}, {
    __tostring = function() -- Line: 149, Name: __tostring
        return "DigController";
    end
});
u24.__index = u24;

function u24.new(...) -- Line: 154
    -- upvalues: u24 (ref)
    local v25 = setmetatable({}, u24);

    return v25:constructor(...) or v25;
end;

function u24.constructor(p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36) -- Line: 158
    -- upvalues: UserInputService (copy)
    p26.shovel = p27;
    p26.detector = p28;
    p26.bar = p29;
    p26.music = p30;
    p26.data = p31;
    p26.tutorial = p32;
    p26.affordNotification = p33;
    p26.backpackVisibility = p34;
    p26.sweep = p35;
    p26.surfacedItems = p36;
    p26.starting = false;
    p26.intentUntil = 0;
    p26.nextAttemptAt = 0;
    p26.isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
end;

function u24.onStart(u37) -- Line: 174
    -- upvalues: u13 (copy), u12 (copy), prewarmWorldSounds (copy), UserInputService (copy), Player (copy)
    u37:setupMobileButton();
    local v38 = {};
    local v39 = #v38;
    local v40 = #u13;
    table.move(u13, 1, v40, v39 + 1, v38);
    table.move(u12, 1, #u12, v39 + v40 + 1, v38);
    prewarmWorldSounds(v38);
    u37.shovel:onDigHit(function() -- Line: 183
        -- upvalues: u37 (copy)
        return u37:onDigHitMarker();
    end);
    u37.shovel:onThrowDirt(function() -- Line: 186
        -- upvalues: u37 (copy)
        return u37:onThrowDirtMarker();
    end);
    UserInputService.InputBegan:Connect(function(p41, p42) -- Line: 189
        -- upvalues: u37 (copy)
        local UserInputType = p41.UserInputType;
        local v43 = UserInputType == Enum.UserInputType.MouseButton1 and true or UserInputType == Enum.UserInputType.Touch;
        local v44 = p41.KeyCode == Enum.KeyCode.ButtonR2;
        local v45 = v44 or p41.KeyCode == Enum.KeyCode.ButtonL2;
        local session = u37.session;

        if session ~= nil then
            session = session.phase;
        end;

        if session == "power" then
            if v43 or v44 then
                u37:stopPower();
            end;
        else
            local session2 = u37.session;

            if session2 ~= nil then
                session2 = session2.phase;
            end;

            if session2 == "minigame" then
                if v43 or v45 then
                    u37:onDigInput();
                end;
            elseif not (p42 or u37.session) and (v43 and not u37.isMobile or v44) then
                u37:requestSession();
            end;
        end;
    end);
    Player.CharacterRemoving:Connect(function() -- Line: 218
        -- upvalues: u37 (copy)
        return u37:abortSession();
    end);
end;

function u24.setupMobileButton(u46) -- Line: 222
    -- upvalues: WFChain (copy), PlayerGui (copy)
    local v47 = WFChain(PlayerGui, "Mobile");

    if not u46.isMobile then
        v47.Enabled = false;

        return nil;
    end;

    local v48 = WFChain(v47, "MobileButtons");
    local v49 = WFChain(v48, "Dig");
    v48.Visible = true;
    v49.Visible = false;
    v49.Activated:Connect(function() -- Line: 232
        -- upvalues: u46 (copy)
        if u46.session then
            return nil;
        end;

        u46:requestSession();
    end);
    u46.mobileDigButton = v49;
end;

function u24.updateMobileButton(p50) -- Line: 240
    -- upvalues: FrameComponent (copy)
    local mobileDigButton = p50.mobileDigButton;

    if not mobileDigButton then
        return nil;
    end;

    local v51;

    if FrameComponent.activeFrame == nil then
        v51 = p50.shovel:canDig() and not p50.session and not p50.starting;
    else
        v51 = false;
    end;

    mobileDigButton.Visible = v51;
end;

function u24.onRender(p52, p53) -- Line: 247
    -- upvalues: Workspace (copy)
    p52:updateMobileButton();
    p52:updateDigIntent();
    local session = p52.session;

    if not session then
        return nil;
    end;

    session.fovPunch = session.fovPunch * math.exp(-9 * p53);
    session.itemKick = session.itemKick * math.exp(-14 * p53);
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera.FieldOfView = session.baseFov + session.fovPunch;
    end;

    p52:updateDebris(session);

    if session.phase == "power" then
        p52:updatePowerBar(session);
        p52:animatePowerLabel(session, p53);
        p52:updateDomeMound(session, p53);

        return;
    end;

    if session.phase == "revealing" then
        p52:updateMoundReveal(session);

        return;
    end;

    if session.phase == "minigame" then
        p52:updateMinigame(session, p53);

        return;
    end;

    if session.phase == "loss" then
        p52:updateLoss(session);
    end;
end;

function u24.isBusyDigging(p54) -- Line: 273
    return p54.session ~= nil and true or (p54.starting or p54.intentUntil > os.clock());
end;

function u24.requestSession(p55) -- Line: 276
    -- upvalues: DIG_INTENT_WINDOW (copy)
    p55.intentUntil = os.clock() + DIG_INTENT_WINDOW;
    p55:attemptDig();
end;

function u24.updateDigIntent(p56) -- Line: 280
    if p56.intentUntil == 0 then
        return nil;
    end;

    if p56.session then
        p56.intentUntil = 0;

        return nil;
    end;

    if os.clock() >= p56.intentUntil then
        p56:abandonIntent();

        return;
    end;

    p56:attemptDig();
end;

function u24.abandonIntent(p57) -- Line: 294
    -- upvalues: Notification (copy)
    p57.intentUntil = 0;
    Notification.new("Find a dig spot to dig!", 3, "Pop", "Light Gray");
end;

function u24.hasDigSpotNear(p58, p59) -- Line: 298
    return p58.sweep:nearestSpot(p59) ~= nil and true or p58.surfacedItems:hasDigSpotNear(p59);
end;

function u24.attemptDig(u60) -- Line: 301
    -- upvalues: Player (copy), BackpackCapacity (copy), Notification (copy), DIG_ATTEMPT_INTERVAL (copy), RuntimeLib (copy), ShovelFunctions (copy)
    local v61 = os.clock();

    if u60.session or u60.starting then
        return nil;
    end;

    local Character = Player.Character;
    local u62;

    if Character == nil then
        u62 = Character;
    else
        u62 = Character:FindFirstChildOfClass("Humanoid");
    end;

    local u63;

    if Character == nil then
        u63 = Character;
    else
        u63 = Character:FindFirstChild("HumanoidRootPart");
    end;

    local u64 = u60.shovel:getLocalZone();
    local v65;

    if Character == nil then
        v65 = Character;
    else
        local function _(p66) -- Line: 323
            local v67 = p66:IsA("Tool") and p66:GetAttribute("inventoryId") ~= nil;

            return v67;
        end;

        v65 = false;

        for i, child in Character:GetChildren() do
            local _ = i - 1;
            local v68 = child:IsA("Tool") and child:GetAttribute("inventoryId") ~= nil;

            if v68 then
                v65 = true;
                break;
            end;
        end;
    end;

    local v69 = not Character or (not u62 or u62.Health <= 0);

    if not v69 then
        local v70;

        if u63 == nil then
            v70 = u63;
        else
            v70 = u63:IsA("BasePart");
        end;

        v69 = not v70 or (not u64 or v65);
    end;

    if v69 then
        u60.intentUntil = 0;

        return nil;
    end;

    if not u60.tutorial:canDig() then
        u60.intentUntil = 0;
        u60.tutorial:notifyCannotDig();

        return nil;
    end;

    local v71 = u60.data:getDataIfLoaded();

    if v71 and BackpackCapacity.isFull(v71.Inventory) then
        u60.intentUntil = 0;
        Notification.new("No more backpack space!", 2, "Error", "Red");

        return nil;
    end;

    local v72 = u60.surfacedItems:hasDigSpotNear(u63.Position);
    local v73;

    if v72 then
        v73 = nil;
    else
        v73 = u60.sweep:nearestSpot(u63.Position);
    end;

    if not (v72 or v73) then
        u60:abandonIntent();

        return nil;
    end;

    if v61 < u60.nextAttemptAt then
        return nil;
    end;

    u60.nextAttemptAt = v61 + DIG_ATTEMPT_INTERVAL;

    if v73 then
        u60.intentUntil = 0;
        u60:beginBuriedDig(v73, Character, u62, u63, u64);

        return nil;
    end;

    u60.starting = true;
    task.spawn(RuntimeLib.async(function() -- Line: 378
        -- upvalues: RuntimeLib (ref), ShovelFunctions (ref), u60 (copy), u63 (copy), Player (ref), Character (copy), u64 (copy), u62 (copy)
        local u74 = RuntimeLib.await(ShovelFunctions.BeginDig:invoke():catch(function() -- Line: 379
            return nil;
        end));
        u60.starting = false;

        if not u74 then
            if not u60:hasDigSpotNear(u63.Position) then
                u60:abandonIntent();
            end;

            return nil;
        end;

        u60.intentUntil = 0;

        if u60.session or (Player.Character ~= Character or u60.shovel:getLocalZone() ~= u64) then
            task.spawn(function() -- Line: 391
                -- upvalues: ShovelFunctions (ref), u74 (copy)
                return ShovelFunctions.ResolveDig:invoke(u74.sessionId, false, 0);
            end);

            return nil;
        end;

        u60:beginSession(u74, Character, u62, u63, u64);
    end));
end;

function u24.beginBuriedDig(u75, u76, p77, p78, p79, p80) -- Line: 399
    -- upvalues: RuntimeLib (copy), ShovelFunctions (copy)
    local u81 = u75:openSession(p77, p78, p79, p80);

    if not u81 then
        return nil;
    end;

    u75:prepareSurfaced(u81, u76.position, u76.id, u76.rarity);
    task.spawn(RuntimeLib.async(function() -- Line: 405
        -- upvalues: RuntimeLib (ref), ShovelFunctions (ref), u76 (copy), u75 (copy), u81 (copy)
        local u82 = RuntimeLib.await(ShovelFunctions.BeginDig:invoke(u76.id):catch(function() -- Line: 406
            return nil;
        end));

        if u75.session ~= u81 then
            if u82 then
                task.spawn(function() -- Line: 411
                    -- upvalues: ShovelFunctions (ref), u82 (copy)
                    return ShovelFunctions.ResolveDig:invoke(u82.sessionId, false, 0);
                end);
            end;

            return nil;
        end;

        local v83;

        if u82 == nil then
            v83 = u82;
        else
            v83 = u82.surfaced;
        end;

        if not (v83 and u82.difficulty) then
            u75:endSession(u81);

            return nil;
        end;

        u81.sessionId = u82.sessionId;
        u75:confirmSurfaced(u81, {
            power = 0,
            sessionId = u82.sessionId,
            itemId = u82.surfaced.itemId,
            kg = u82.surfaced.kg,
            oneIn = u82.surfaced.oneIn,
            difficulty = u82.difficulty
        });
    end));
end;

function u24.beginSession(u84, u85, p86, p87, p88, p89) -- Line: 440
    -- upvalues: ShovelFunctions (copy), Items (copy), MOUND_MIN_RADIUS (copy), DIG_POWER_DEFAULT (copy), DIG_POWER_MAX_SECONDS (copy)
    local u90 = u84:openSession(p86, p87, p88, p89);

    if not u90 then
        task.spawn(function() -- Line: 443
            -- upvalues: ShovelFunctions (ref), u85 (copy)
            return ShovelFunctions.ResolveDig:invoke(u85.sessionId, false, 0);
        end);

        return nil;
    end;

    u90.sessionId = u85.sessionId;
    u90.powerStartedAt = u85.powerStartedAt;

    if u85.surfaced and u85.difficulty then
        u84:prepareSurfaced(u90, u85.surfaced.position, u85.surfaced.id, Items[u85.surfaced.itemId].rarity);
        u84:confirmSurfaced(u90, {
            power = 0,
            sessionId = u85.sessionId,
            itemId = u85.surfaced.itemId,
            kg = u85.surfaced.kg,
            oneIn = u85.surfaced.oneIn,
            difficulty = u85.difficulty
        });

        return nil;
    end;

    local v91 = u84:computeDigSurface(u90, MOUND_MIN_RADIUS);
    u90.digPoint = v91;
    u84:faceDigPoint(u90);
    u84:createMound(u90, v91, Vector3.new(1, 1, 1));
    u84:createDebrisPool(u90);

    if u85.rolled and u85.difficulty then
        u84:applyDigResult(u90, {
            sessionId = u85.sessionId,
            itemId = u85.rolled.itemId,
            kg = u85.rolled.kg,
            oneIn = u85.rolled.oneIn,
            power = DIG_POWER_DEFAULT,
            difficulty = u85.difficulty
        });

        return nil;
    end;

    if not u84:createPowerBar(u90) then
        u84:finish(false);

        return nil;
    end;

    task.delay(DIG_POWER_MAX_SECONDS, function() -- Line: 482
        -- upvalues: u84 (copy), u90 (copy)
        if u84.session == u90 and (u90.phase == "power" and not u90.powerStopping) then
            u84:stopPower(true);
        end;
    end);
end;

function u24.prepareSurfaced(p92, p93, p94, p95, p96) -- Line: 488
    -- upvalues: dirtForRarity (copy)
    p93.dirt = dirtForRarity(p96);
    p93.surfacedPosition = p94;
    p93.surfacedId = p95;
    p93.moundTarget = 1;
    p93.moundProgress = 1;
    p93.phase = "minigame";
    p93.digPoint = p92:computeFixedDigSurface(p93, p94);
    p92:faceDigPoint(p93);
    p92:createDebrisPool(p93);
    p92.bar:show();
end;

function u24.confirmSurfaced(p97, p98, p99) -- Line: 500
    -- upvalues: ShovelEvents (copy)
    p98.result = p99;
    p98.difficulty = p99.difficulty;

    if not p97:createDigSite(p98) then
        p97:finish(false);

        return nil;
    end;

    p97:updateDomeMound(p98, 1);

    if p98.pendingClicks > 0 then
        p98.progress = math.min(1, p98.progress + p98.pendingClicks * p99.difficulty.clickPower);
        p98.pendingClicks = 0;
        p97.bar:setProgress(p98.progress);
    end;

    p97:updateItemPosition(p98);
    ShovelEvents.DigReady:fire(p99.sessionId);
end;

function u24.openSession(u100, p101, u102, u103, p104) -- Line: 516
    -- upvalues: Workspace (copy), Janitor (copy), PlayerGui (copy), StarterGui (copy), dirtForRarity (copy), DIG_PROGRESS_START (copy), DIG_EFFECTIVE_CLICK_BURST (copy), MOUND_MIN_RADIUS (copy)
    u100.detector:setDigging(true);

    if not u100.shovel:beginDigging(true) then
        u100.detector:setDigging(false);

        return nil;
    end;

    u100.affordNotification:setBusy("dig", true);
    local CurrentCamera = Workspace.CurrentCamera;
    local v105;

    if CurrentCamera == nil then
        v105 = CurrentCamera;
    else
        v105 = CurrentCamera.FieldOfView;
    end;

    local u106 = v105 == nil and 70 or v105;
    local v107 = Janitor.new();
    local HUD = PlayerGui:WaitForChild("HUD");
    local Enabled = HUD.Enabled;
    local u108 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack);
    local u109 = true;

    local function v110() -- Line: 539
        -- upvalues: u109 (ref), HUD (copy), Enabled (copy), StarterGui (ref), u108 (copy), u100 (copy)
        if not u109 then
            return nil;
        end;

        u109 = false;

        if HUD.Parent then
            HUD.Enabled = Enabled;
        end;

        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, u108);
        u100.backpackVisibility:setHidden("dig", false);
    end;

    HUD.Enabled = false;
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
    u100.backpackVisibility:setHidden("dig", true);
    local Anchored = u103.Anchored;
    local AutoRotate = u102.AutoRotate;
    local CFrame2 = u103.CFrame;
    local u111 = true;

    local function v112() -- Line: 557
        -- upvalues: u111 (ref), u103 (copy), CFrame2 (copy), Anchored (copy), u102 (copy), AutoRotate (copy)
        if not u111 then
            return nil;
        end;

        u111 = false;

        if u103.Parent then
            u103.CFrame = CFrame2;
            u103.Anchored = Anchored;
        end;

        if u102.Parent then
            u102.AutoRotate = AutoRotate;
        end;
    end;

    u103.Anchored = true;
    u102.AutoRotate = false;
    v107:Add(function() -- Line: 572
        -- upvalues: u111 (ref), u103 (copy), CFrame2 (copy), Anchored (copy), u102 (copy), AutoRotate (copy), u109 (ref), HUD (copy), Enabled (copy), StarterGui (ref), u108 (copy), u100 (copy), CurrentCamera (copy), u106 (copy)
        if u111 then
            u111 = false;

            if u103.Parent then
                u103.CFrame = CFrame2;
                u103.Anchored = Anchored;
            end;

            if u102.Parent then
                u102.AutoRotate = AutoRotate;
            end;
        end;

        if u109 then
            u109 = false;

            if HUD.Parent then
                HUD.Enabled = Enabled;
            end;

            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, u108);
            u100.backpackVisibility:setHidden("dig", false);
        end;

        if CurrentCamera then
            CurrentCamera.FieldOfView = u106;
        end;

        u100.detector:setDigging(false);
        u100.shovel:endDigging();
        u100.bar:hide();
    end, true);
    local v113 = {
        janitor = v107,
        powerStartedAt = 0,
        phase = "power",
        character = p101,
        root = u103,
        area = p104,
        surfaceCFrame = p104.CFrame,
        dirt = dirtForRarity("common"),
        restoreMovement = v112,
        restoreGui = v110,
        baseFov = u106,
        progress = DIG_PROGRESS_START,
        clickEnergy = 0,
        clickCredits = DIG_EFFECTIVE_CLICK_BURST,
        digAnimationSpeed = 1,
        totalClicks = 0,
        pendingClicks = 0,
        lastInputSent = 0,
        fovPunch = 0,
        itemKick = 0,
        mound = {},
        moundProgress = 0,
        moundTarget = 0,
        moundRadius = MOUND_MIN_RADIUS,
        baseMoundCount = 0,
        extraMoundBlocks = 0,
        hadDigHit = false,
        power = 0,
        powerStopping = false,
        powerTierIndex = -1,
        powerLabelPop = 0,
        debris = {},
        debrisIndex = 0,
        lastImpactSound = 0,
        lastThrowSound = 0,
        revealStarted = 0,
        finishStarted = 0
    };
    u100.session = v113;

    return v113;
end;

function u24.createPowerBar(p114, p115) -- Line: 624
    -- upvalues: WFChain (copy), ReplicatedStorage (copy), u21 (copy), DIG_POWER_TIERS (copy)
    local v116 = WFChain(ReplicatedStorage, "Assets", "WorldUI", "PowerBar"):Clone();
    v116.Size = UDim2.new(0, 300, 0, 428);
    local v117 = WFChain(v116, "Frame", "Bar");
    local v118 = WFChain(v117, "Inner");
    v118.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = 90;
    UIGradient.Color = u21(DIG_POWER_TIERS[1].color);
    UIGradient.Parent = v118;
    p115.powerFill = UIGradient;

    for i = 1, #DIG_POWER_TIERS - 1 do
        local v119 = DIG_POWER_TIERS[i + 1];
        local Frame = Instance.new("Frame");
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = UDim2.fromScale(0.5, 1 - v119.minPower);
        Frame.Size = UDim2.new(1, 0, 0, 4);
        Frame.BorderSizePixel = 0;
        Frame.BackgroundColor3 = v119.color;
        Frame.ZIndex = v118.ZIndex + 1;
        Frame.Parent = v117;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel.Position = UDim2.new(0.5, 0, 0, -4);
    TextLabel.Size = UDim2.new(3.2, 0, 0, 28);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 1;
    TextLabel.Text = "";
    TextLabel.ZIndex = v118.ZIndex + 2;
    TextLabel.Parent = v117;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 2.6;
    UIStroke.Color = Color3.fromRGB(18, 18, 18);
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    UIStroke.Parent = TextLabel;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Rotation = 90;
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 196, 196)) });
    UIGradient2.Parent = TextLabel;
    v116.Adornee = p115.root;
    v116.Parent = p115.root;
    p115.janitor:Add(v116, "Destroy");
    p115.powerGui = v116;
    p115.powerInner = v118;
    p115.powerLabel = TextLabel;
    p114:updatePowerBar(p115);

    return true;
end;

function u24.updatePowerBar(p120, p121) -- Line: 675
    -- upvalues: digPowerAt (copy), Workspace (copy), digTierFor (copy)
    local powerInner = p121.powerInner;
    local v122;

    if powerInner == nil then
        v122 = powerInner;
    else
        v122 = powerInner.Parent;
    end;

    if not v122 or p121.powerStopping then
        return nil;
    end;

    p121.power = digPowerAt(Workspace:GetServerTimeNow() - p121.powerStartedAt);
    local v123 = digTierFor(p121.power);
    powerInner.Size = UDim2.fromScale(1, p121.power);
    p120:applyPowerTier(p121, v123);
end;

function u24.applyPowerTier(p124, p125, p126) -- Line: 693
    -- upvalues: DIG_POWER_TIERS (copy), playSound (copy), u21 (copy)
    local powerLabel = p125.powerLabel;
    local v127;

    if powerLabel == nil then
        v127 = powerLabel;
    else
        v127 = powerLabel.Parent;
    end;

    if not v127 then
        return nil;
    end;

    local v128 = 0;

    for i = 0, #DIG_POWER_TIERS - 1 do
        if DIG_POWER_TIERS[i + 1] == p126 then
            v128 = i;
        end;
    end;

    if v128 ~= p125.powerTierIndex then
        if p125.powerTierIndex < v128 and v128 > 0 then
            p125.powerLabelPop = 1.35;
            playSound("Tick", {
                volume = 0.22,
                cleanupDelay = 1,
                playbackSpeed = v128 * 0.2 + 1
            });
        end;

        p125.powerTierIndex = v128;
        local powerFill = p125.powerFill;

        if powerFill ~= nil then
            powerFill = powerFill.Parent;
        end;

        if powerFill then
            p125.powerFill.Color = u21(p126.color);
        end;
    end;

    powerLabel.Text = string.format("x%d", p126.luck);
    powerLabel.TextColor3 = p126.color;
end;

function u24.animatePowerLabel(p129, p130, p131) -- Line: 729
    local powerLabel = p130.powerLabel;
    local v132;

    if powerLabel == nil then
        v132 = powerLabel;
    else
        v132 = powerLabel.Parent;
    end;

    if not v132 then
        return nil;
    end;

    p130.powerLabelPop = p130.powerLabelPop * math.exp(-9 * p131);
    local v133 = 1 + p130.powerLabelPop;
    powerLabel.Size = UDim2.new(3.2 * v133, 0, 0, (math.round(28 * v133)));
end;

function u24.stopPower(u134, u135) -- Line: 742
    -- upvalues: Workspace (copy), DIG_POWER_MIN_STOP_SECONDS (copy), DIG_POWER_DEFAULT (copy), digPowerAt (copy), digTierFor (copy), u21 (copy)
    if u135 == nil then
        u135 = false;
    end;

    local session = u134.session;

    if not session or (session.phase ~= "power" or session.powerStopping) then
        return nil;
    end;

    local u136 = Workspace:GetServerTimeNow();

    if not u135 and u136 - session.powerStartedAt < DIG_POWER_MIN_STOP_SECONDS then
        return nil;
    end;

    session.powerStopping = true;
    local v137;

    if u135 then
        v137 = DIG_POWER_DEFAULT;
    else
        v137 = digPowerAt(u136 - session.powerStartedAt);
    end;

    session.power = v137;
    local v138 = digTierFor(session.power);
    local powerInner = session.powerInner;
    local v139;

    if powerInner == nil then
        v139 = powerInner;
    else
        v139 = powerInner.Parent;
    end;

    if v139 then
        powerInner.Size = UDim2.fromScale(1, session.power);
        local powerFill = session.powerFill;

        if powerFill ~= nil then
            powerFill = powerFill.Parent;
        end;

        if powerFill then
            session.powerFill.Color = u21(v138.color);
        end;
    end;

    local powerLabel = session.powerLabel;
    local v140;

    if powerLabel == nil then
        v140 = powerLabel;
    else
        v140 = powerLabel.Parent;
    end;

    if v140 then
        powerLabel.Text = string.format("x%d", v138.luck);
        powerLabel.TextColor3 = v138.color;
    end;

    session.powerLabelPop = 1.89;
    u134:showLuckIndicator(session);
    task.spawn(function() -- Line: 783
        -- upvalues: u134 (copy), session (copy), u136 (copy), u135 (ref)
        local v141 = u134:requestStopPower(session, u136, u135);

        if u134.session ~= session then
            return nil;
        end;

        if not v141 then
            u134:abortSession();

            return nil;
        end;

        u134:applyDigResult(session, v141);
    end);
end;

function u24.applyDigResult(p142, p143, p144) -- Line: 795
    -- upvalues: dirtFor (copy)
    p143.result = p144;
    p143.difficulty = p144.difficulty;
    p143.dirt = dirtFor(p144.itemId);

    for _, v in p143.mound do
        p142:paintDirt(p143.dirt, v.part, 0.12);
    end;

    local powerGui = p143.powerGui;

    if powerGui ~= nil then
        powerGui:Destroy();
    end;

    p143.powerGui = nil;
    p143.powerInner = nil;
    p143.powerLabel = nil;

    if not p142:createDigSite(p143) then
        p142:finish(false);

        return nil;
    end;

    p142:revealFound(p143);
end;

function u24.requestStopPower(p145, p146, p147, p148) -- Line: 815
    -- upvalues: ShovelFunctions (copy)
    local sessionId = p146.sessionId;

    if sessionId == nil then
        return nil;
    end;

    for _ = 0, 3 do
        local v149, v150 = ShovelFunctions.StopPower:invoke(sessionId, p147, p148):await();

        if v149 then
            return v150;
        end;

        task.wait(0.35);
    end;

    return nil;
end;

function u24.showLuckIndicator(u151, p152) -- Line: 829
    -- upvalues: digTierFor (copy), u11 (copy), WFChain (copy), ReplicatedStorage (copy), TweenService (copy)
    local root = p152.root;

    if not root.Parent then
        return nil;
    end;

    local v153 = digTierFor(p152.power);
    local v154 = math.clamp((v153.luck - 1) / (u11 - 1), 0, 1);
    local u155 = WFChain(ReplicatedStorage, "Assets", "WorldUI", "LuckIndicator"):Clone();
    local u156 = WFChain(u155, "Frame", "TextLabel");
    local u157 = u156:FindFirstChildOfClass("UIStroke");
    u156.Text = string.format("%dX LUCK", v153.luck);
    u156.TextColor3 = v153.color;
    u156.TextTransparency = 1;
    local Size = u156.Size;
    local v158 = v154 * 0.35 + 0.65;
    u156.Size = UDim2.new(Size.X.Scale * v158, Size.X.Offset * v158, Size.Y.Scale * v158, Size.Y.Offset * v158);

    if u157 then
        u157.Transparency = 1;
    end;

    local Size2 = u155.Size;
    local v159 = v154 * 0.44999999999999996 + 0.55;
    local u160 = UDim2.new(Size2.X.Scale * v159, Size2.X.Offset * v159, Size2.Y.Scale * v159, Size2.Y.Offset * v159);
    u155.Size = UDim2.new(u160.X.Scale * 0.5, u160.X.Offset * 0.5, u160.Y.Scale * 0.5, u160.Y.Offset * 0.5);
    u155.StudsOffset = Vector3.new(0, 2.6, 0);
    u155.Adornee = root;
    u155.Parent = root;
    TweenService:Create(u155, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        StudsOffset = Vector3.new(0, v154 * 2.9 + 1.3 + 2.6, 0)
    }):Play();
    TweenService:Create(u155, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(u160.X.Scale * 1.08, u160.X.Offset * 1.08, u160.Y.Scale * 1.08, u160.Y.Offset * 1.08)
    }):Play();
    u151:fadeLuckLabel(u156, u157, 0, 0.16, Enum.EasingDirection.Out);
    task.delay(0.16, function() -- Line: 860
        -- upvalues: u155 (copy), TweenService (ref), u160 (copy)
        if not u155.Parent then
            return nil;
        end;

        TweenService:Create(u155, TweenInfo.new(0.18400000000000002, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = u160
        }):Play();
    end);
    task.delay(0.62, function() -- Line: 868
        -- upvalues: u155 (copy), TweenService (ref), u160 (copy), u151 (copy), u156 (copy), u157 (copy)
        if not u155.Parent then
            return nil;
        end;

        local v161 = TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        local v162 = {};
        local v163 = u160;
        v162.Size = UDim2.new(v163.X.Scale * 1.12, v163.X.Offset * 1.12, v163.Y.Scale * 1.12, v163.Y.Offset * 1.12);
        TweenService:Create(u155, v161, v162):Play();
        u151:fadeLuckLabel(u156, u157, 1, 0.38, Enum.EasingDirection.In).Completed:Once(function() -- Line: 876
            -- upvalues: u155 (ref)
            return u155:Destroy();
        end);
    end);
end;

function u24.fadeLuckLabel(p164, p165, p166, p167, p168, p169) -- Line: 881
    -- upvalues: TweenService (copy)
    local v170 = TweenInfo.new(p168, Enum.EasingStyle.Quad, p169);
    local v171 = TweenService:Create(p165, v170, {
        TextTransparency = p167
    });
    v171:Play();

    if p166 then
        TweenService:Create(p166, v170, {
            Transparency = p167
        }):Play();
    end;

    return v171;
end;

function u24.revealFound(p172, p173) -- Line: 894
    -- upvalues: RarityBeams (copy), Items (copy), playWorldSound (copy)
    p173.phase = "revealing";
    p173.revealStarted = os.clock();
    p173.fovPunch = 7;

    if p173.digPoint and (p173.result and (p173.itemSize and p173.surfacedPosition == nil)) then
        p173.beams = RarityBeams.create(p173.digPoint, Items[p173.result.itemId].rarity, p173.itemSize, p173.janitor);
    end;

    p172:showExclamation(p173);
    p172.music:duck();
    local v174 = RarityBeams.beamSound(not p173.result and "common" or Items[p173.result.itemId].rarity);
    playWorldSound(v174.key, {
        volume = 1,
        cleanupDelay = 4,
        parent = p173.itemRoot or p173.root,
        playbackSpeed = v174.playbackSpeed
    });
end;

function u24.createDigSite(p175, p176) -- Line: 911
    -- upvalues: WFChain (copy), ReplicatedStorage (copy), Items (copy), ItemModel (copy), itemNameFor (copy), Workspace (copy), CFrameUtils (copy), TOOL_DIRT (copy), DirtCoat (copy), moundRadiusFor (copy)
    local result = p176.result;

    if not result then
        return false;
    end;

    local v177 = WFChain(ReplicatedStorage, "Assets", "Items", Items[result.itemId].displayName);
    local u178 = ItemModel.build(v177, result.itemId, result.kg);
    local v179;

    if u178 == nil then
        v179 = u178;
    else
        v179 = u178.PrimaryPart;
    end;

    if not (u178 and v179) then
        return false;
    end;

    for _, descendant in u178:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = true;
            descendant.CanTouch = false;
        end;
    end;

    local v180, v181 = u178:GetBoundingBox();
    v179.PivotOffset = v179.PivotOffset * CFrame.new(u178:GetPivot():ToObjectSpace(v180).Position);
    u178.Name = itemNameFor(result.itemId, result.kg);
    u178.Parent = Workspace;
    p176.janitor:Add(u178, "Destroy");
    local v182;

    if p176.surfacedPosition == nil then
        v182 = p175:computeDigSurface(p176, math.max(v181.X, v181.Z) * 0.5);
    else
        v182 = p175:computeFixedDigSurface(p176, p176.surfacedPosition);
    end;

    p176.digPoint = v182;
    local UpVector = p176.surfaceCFrame.UpVector;
    local v183 = CFrameUtils.emergeOrientation(UpVector, v181);
    local v184 = math.max(v181.X, v181.Y, v181.Z) * 0.5;
    local v185 = v182 - UpVector * (v184 + math.max(0.45, (v181.X + v181.Y + v181.Z) / 3 * 0.08));
    p176.item = u178;
    p176.itemRoot = v179;
    p176.itemSize = v181;
    p176.buriedCFrame = CFrame.new(v185) * v183;
    p176.emergedCFrame = CFrame.new(v182 + UpVector * (v184 + 0.15)) * v183;
    u178:PivotTo(p176.buriedCFrame);
    local v186 = table.clone(TOOL_DIRT);
    setmetatable(v186, nil);
    v186.weld = true;
    v186.canQuery = false;
    v186.color = p176.dirt.color;
    v186.colorJitter = p176.dirt.colorJitter;
    v186.material = p176.dirt.material;

    function v186.onComplete() -- Line: 969
        -- upvalues: u178 (copy)
        for _, descendant in u178:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.CanQuery = false;
            end;
        end;
    end;

    DirtCoat.coat(u178, v186);
    local v187;

    if p176.surfacedId == nil then
        v187 = nil;
    else
        v187 = p175:takeSurfacedMound(p176.surfacedId);
    end;

    if v187 == nil or #v187 <= 0 then
        p175:createMound(p176, v182, v181);
    else
        for _, v in v187 do
            p176.janitor:Add(v.part, "Destroy");
        end;

        p176.mound = v187;
        p176.moundRadius = math.max(p176.moundRadius, moundRadiusFor(v181));
    end;

    p176.baseMoundCount = #p176.mound;

    return true;
end;

function u24.takeSurfacedMound(p188, p189) -- Line: 990
    return p188.sweep:takeMound(p189) or p188.surfacedItems:takeMound(p189);
end;

function u24.faceDigPoint(p190, p191) -- Line: 993
    local Position = p191.root.Position;
    local surfaceCFrame = p191.surfaceCFrame;
    p191.root.CFrame = CFrame.lookAt(Position, Position + surfaceCFrame.LookVector, surfaceCFrame.UpVector);
end;

function u24.computeDigSurface(p192, p193, p194) -- Line: 999
    -- upvalues: Workspace (copy)
    local area = p193.area;
    local v195 = area.CFrame:PointToObjectSpace(p193.root.Position + p193.root.CFrame.LookVector * 4.5);
    local v196 = area.Size * 0.5;
    local v197 = math.min(p194, v196.X * 0.5);
    local v198 = math.min(p194, v196.Z * 0.5);
    local CFrame2 = area.CFrame;
    local v199 = math.clamp(v195.X, -v196.X + v197, v196.X - v197);
    local Y = v196.Y;
    local v200 = math.clamp(v195.Z, -v196.Z + v198, v196.Z - v198);
    local v201 = CFrame2:PointToWorldSpace((Vector3.new(v199, Y, v200)));
    local v202 = RaycastParams.new();
    v202.FilterType = Enum.RaycastFilterType.Exclude;
    v202.IgnoreWater = true;
    local v203;

    if p193.item then
        v203 = { p193.character, area, p193.item };
    else
        v203 = { p193.character, area };
    end;

    v202.FilterDescendantsInstances = v203;
    local v204 = Workspace:Raycast(v201 + Vector3.new(0, 24, 0), Vector3.new(0, -96, 0), v202);

    if v204 then
        v201 = v204.Position;
    end;

    local v205;

    if v204 then
        v205 = v204.Normal;
    else
        v205 = area.CFrame.UpVector;
    end;

    local LookVector = p193.root.CFrame.LookVector;
    local v206 = LookVector - v205 * LookVector:Dot(v205);

    if v206.Magnitude < 0.01 then
        local LookVector2 = area.CFrame.LookVector;
        v206 = LookVector2 - v205 * LookVector2:Dot(v205);
    end;

    p193.surfaceCFrame = CFrame.lookAt(v201, v201 + (v206.Magnitude < 0.01 and Vector3.new(0, 0, 1) or v206).Unit, v205);

    return v201;
end;

function u24.computeFixedDigSurface(p207, p208, p209) -- Line: 1037
    -- upvalues: CollectionService (copy), DIG_ZONE_TAG (copy), Workspace (copy)
    local v210 = RaycastParams.new();
    v210.FilterType = Enum.RaycastFilterType.Exclude;
    v210.IgnoreWater = true;
    local v211 = { p208.character };
    local v212 = #v211;
    local v213 = CollectionService:GetTagged(DIG_ZONE_TAG);
    local v214 = #v213;
    table.move(v213, 1, v214, v212 + 1, v211);
    local v215 = p208.item and { p208.item } or {};
    table.move(v215, 1, #v215, v212 + v214 + 1, v211);
    v210.FilterDescendantsInstances = v211;
    local v216 = Workspace:Raycast(p209 + Vector3.new(0, 24, 0), Vector3.new(0, -96, 0), v210);
    local v217;

    if v216 then
        v217 = v216.Normal;
    else
        v217 = p208.area.CFrame.UpVector;
    end;

    local v218 = p209 - p208.root.Position;
    local v219 = v218 - v217 * v218:Dot(v217);

    if v219.Magnitude < 0.01 then
        local LookVector = p208.root.CFrame.LookVector;
        v219 = LookVector - v217 * LookVector:Dot(v217);
    end;

    p208.surfaceCFrame = CFrame.lookAt(p209, p209 + (v219.Magnitude < 0.01 and Vector3.new(0, 0, 1) or v219).Unit, v217);

    return p209;
end;

function u24.paintDirt(p220, p221, p222, p223) -- Line: 1078
    p222.Material = p221.material;
    p222.Color = p221.color:Lerp(Color3.new(), math.random() * p223);
end;

function u24.createMound(p224, p225, p226, p227) -- Line: 1082
    -- upvalues: moundRadiusFor (copy)
    local v228 = moundRadiusFor(p227);
    local v229 = math.floor(v228 * 6);
    local v230 = math.clamp(v229, 12, 30);
    p225.moundRadius = math.max(p225.moundRadius, v228);
    local v231 = #p225.mound;
    local v232 = false;

    while true do
        if v232 then
            v231 = v231 + 1;
        else
            v232 = true;
        end;

        if v231 >= v230 then
            return;
        end;

        p224:createMoundBlock(p225, p226, v228, v231 / v230 * 0.82, 0);
    end;
end;

function u24.createMoundBlock(p233, p234, p235, p236, p237, p238) -- Line: 1102
    -- upvalues: PassThroughTag (copy), Workspace (copy)
    local UpVector = p234.surfaceCFrame.UpVector;
    local RightVector = p234.surfaceCFrame.RightVector;
    local LookVector = p234.surfaceCFrame.LookVector;
    local v239 = math.random() * 3.141592653589793 * 2;
    local v240 = math.random();
    local v241 = p236 * math.sqrt(v240);
    local v242 = 0.34 + math.random() * math.min(0.72, p236 * 0.25);
    local v243 = 0.24 + math.random() * 0.42;
    local v244 = v242 * (0.7 + math.random() * 0.6);
    local v245 = Vector3.new(v242, v243, v244);
    local v246 = RightVector * (math.cos(v239) * v241);
    local v247 = LookVector * (math.sin(v239) * v241);
    local v248 = CFrame.new(p235 + v246 + v247 + UpVector * (v245.Y * (0.32 + p238))) * CFrame.Angles((math.random() - 0.5) * 0.35, math.random() * 3.141592653589793 * 2, (math.random() - 0.5) * 0.35);
    local Part = Instance.new("Part");
    Part.Size = v245 * 0.2;
    p233:paintDirt(p234.dirt, Part, 0.12);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.CFrame = v248 - UpVector * (v245.Y + 0.45);
    PassThroughTag.applyToPart(Part);
    Part.Parent = Workspace;
    p234.janitor:Add(Part, "Destroy");
    local v249 = {
        part = Part,
        start = Part.CFrame,
        target = v248,
        size = v245,
        phase = math.random() * 3.141592653589793 * 2,
        revealAt = p237
    };
    table.insert(p234.mound, v249);

    return v249;
end;

function u24.createDebrisPool(p250, p251) -- Line: 1147
    -- upvalues: u14 (copy), PassThroughTag (copy), Workspace (copy)
    for _ = 0, 71 do
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        p250:paintDirt(p251.dirt, Part, 0);
        Part.Transparency = 1;
        Part.CFrame = u14;
        PassThroughTag.applyToPart(Part);
        Part.Parent = Workspace;
        p251.janitor:Add(Part, "Destroy");
        table.insert(p251.debris, {
            active = false,
            bornAt = 0,
            lifetime = 0,
            collisionAt = 0,
            part = Part
        });
    end;
end;

function u24.emitDirt(p252, p253) -- Line: 1172
    -- upvalues: DIG_LOSE_THRESHOLD (copy), DIG_WIN_THRESHOLD (copy)
    local digPoint = p253.digPoint;

    if not digPoint or #p253.debris == 0 then
        return nil;
    end;

    local v254 = p252:feedbackIntensity(p253);
    math.clamp((p253.progress - DIG_LOSE_THRESHOLD) / (DIG_WIN_THRESHOLD - DIG_LOSE_THRESHOLD), 0, 1);
    local v255 = math.floor(v254 * 7) + 3;
    local UpVector = p253.surfaceCFrame.UpVector;
    local v256 = p253.root.CFrame.LookVector * -1;
    local v257 = v256 - UpVector * v256:Dot(UpVector);

    if v257.Magnitude < 0.01 then
        v257 = p253.surfaceCFrame.LookVector * -1;
    end;

    local Unit = v257.Unit;
    local RightVector = p253.root.CFrame.RightVector;
    local v258 = RightVector - UpVector * RightVector:Dot(UpVector);

    if v258.Magnitude < 0.01 then
        v258 = p253.surfaceCFrame.RightVector;
    end;

    local Unit2 = v258.Unit;
    local v259 = false;
    local v260 = 0;

    while true do
        if v259 then
            v260 = v260 + 1;
        else
            v259 = true;
        end;

        if v260 >= v255 then
            return;
        end;

        local v261 = p253.debris[p253.debrisIndex + 1];
        p253.debrisIndex = (p253.debrisIndex + 1) % #p253.debris;
        local Unit3 = (Unit + Unit2 * ((math.random() - 0.5) * (0.6 + v254))).Unit;
        local v262 = 0.14 + math.random() * (0.18 + v254 * 0.28);
        local part = v261.part;
        part.Anchored = true;
        part.CanCollide = false;
        part.CollisionGroup = "Characters";
        p252:paintDirt(p253.dirt, part, 0.14);
        local v263 = v262 * (0.75 + math.random() * 0.5);
        local v264 = v262 * (0.75 + math.random() * 0.5);
        part.Size = Vector3.new(v263, v262, v264);
        part.Transparency = 0;
        local v265 = digPoint + UpVector * (0.45 + v262 + math.random() * 0.3);
        local v266 = (math.random() - 0.5) * (0.25 + v254 * 0.5);
        part.CFrame = CFrame.new(v265 + Unit2 * v266) * CFrame.Angles(math.random() * 3.141592653589793, math.random() * 3.141592653589793, math.random() * 3.141592653589793);
        part.Anchored = false;
        part.AssemblyLinearVelocity = UpVector * (14 + v254 * 28 + math.random() * 7) + Unit3 * (10 + v254 * 20 + math.random() * 6);
        local v267 = (math.random() - 0.5) * (14 + v254 * 18);
        local v268 = (math.random() - 0.5) * (14 + v254 * 18);
        local v269 = (math.random() - 0.5) * (14 + v254 * 18);
        part.AssemblyAngularVelocity = Vector3.new(v267, v268, v269);
        v261.active = true;
        v261.bornAt = os.clock();
        v261.lifetime = 1.2 + math.random() * 0.9000000000000001;
        v261.collisionAt = v261.bornAt + 0.14;
    end;
end;

function u24.feedbackIntensity(p270, p271) -- Line: 1247
    -- upvalues: DIG_LOSE_THRESHOLD (copy), DIG_WIN_THRESHOLD (copy)
    local v272 = math.clamp((p271.progress - DIG_LOSE_THRESHOLD) / (DIG_WIN_THRESHOLD - DIG_LOSE_THRESHOLD), 0, 1);

    return math.clamp(0.25 + p271.clickEnergy * 0.55 + v272 * 0.2, 0.25, 1);
end;

function u24.updateDebris(p273, p274) -- Line: 1251
    -- upvalues: u14 (copy)
    local v275 = os.clock();

    for _, v in p274.debris do
        if v.active then
            local v276 = (v275 - v.bornAt) / v.lifetime;

            if v276 >= 1 then
                v.active = false;
                v.part.Anchored = true;
                v.part.CanCollide = false;
                v.part.Transparency = 1;
                v.part.CFrame = u14;
            else
                if not v.part.CanCollide and v.collisionAt <= v275 then
                    v.part.CanCollide = true;
                end;

                v.part.Transparency = math.clamp((v276 - 0.68) / 0.32, 0, 1);
            end;
        end;
    end;
end;

function u24.onDigHitMarker(p277) -- Line: 1272
    -- upvalues: playWorldSound (copy), u13 (copy)
    local session = p277.session;

    if not session or (session.phase == "finishing" or (session.phase == "success" or session.phase == "loss")) then
        return nil;
    end;

    if session.phase == "minigame" then
        session.hadDigHit = true;
        session.moundTarget = math.min(1, session.moundTarget + 0.2);
    end;

    local v278 = os.clock();
    local v279 = p277:feedbackIntensity(session);
    session.itemKick = 0.45 + v279 * 0.55;
    session.fovPunch = math.min(5, session.fovPunch + 0.25 + v279 * 0.55);

    if v278 - session.lastImpactSound < 0.09 / (0.75 + v279 * 0.75) then
        return nil;
    end;

    session.lastImpactSound = v278;
    playWorldSound(u13[math.random(0, #u13 - 1) + 1], {
        cleanupDelay = 3,
        parent = session.root,
        volume = 0.3 + v279 * 0.38,
        playbackSpeed = 1 + v279 * 0.18 + math.random() * 0.12
    });
end;

function u24.addMoundDirt(p280, p281) -- Line: 1296
    -- upvalues: TweenService (copy)
    local digPoint = p281.digPoint;

    if not digPoint or p281.extraMoundBlocks >= 30 then
        return nil;
    end;

    local v282 = math.min(3, 30 - p281.extraMoundBlocks);
    local v283 = false;
    local v284 = 0;

    while true do
        if v283 then
            v284 = v284 + 1;
        else
            v283 = true;
        end;

        if v284 >= v282 then
            return;
        end;

        local v285 = p280:createMoundBlock(p281, digPoint, p281.moundRadius, 0, 0.15 + p281.extraMoundBlocks / 30 * 0.45);
        p281.extraMoundBlocks = p281.extraMoundBlocks + 1;
        local v286 = TweenService:Create(v285.part, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            CFrame = v285.target,
            Size = v285.size
        });
        p281.janitor:Add(v286, "Cancel");
        v286:Play();
    end;
end;

function u24.onThrowDirtMarker(p287) -- Line: 1326
    -- upvalues: playWorldSound (copy), u12 (copy)
    local session = p287.session;

    if not session or (session.phase == "finishing" or (session.phase == "success" or session.phase == "loss")) then
        return nil;
    end;

    if session.phase == "minigame" then
        p287:addMoundDirt(session);
    end;

    local v288 = p287:feedbackIntensity(session);
    p287:emitDirt(session);
    local v289 = os.clock();

    if v289 - session.lastThrowSound < 0.09 / (0.75 + v288 * 0.75) then
        return nil;
    end;

    session.lastThrowSound = v289;
    playWorldSound(u12[math.random(0, #u12 - 1) + 1], {
        cleanupDelay = 3,
        parent = session.itemRoot or session.root,
        volume = 0.08 + v288 * 0.27,
        playbackSpeed = 1 + v288 * 0.16 + math.random() * 0.12
    });
end;

function u24.showExclamation(u290, u291) -- Line: 1348
    -- upvalues: DIG_EXCLAMATION_ENABLED (copy), WFChain (copy), ReplicatedStorage (copy), rarityStyleFor (copy), Items (copy), TweenService (copy)
    if not DIG_EXCLAMATION_ENABLED then
        return nil;
    end;

    local result = u291.result;
    local Head = u291.character:WaitForChild("Head", 5);
    local v292 = not result;

    if not v292 then
        local v293;

        if Head == nil then
            v293 = Head;
        else
            v293 = Head:IsA("BasePart");
        end;

        v292 = not v293;
    end;

    if v292 then
        return nil;
    end;

    local u294 = WFChain(ReplicatedStorage, "Assets", "WorldUI", "ExclamationPoint"):Clone();
    local Size = u294.Size;
    local u295 = WFChain(u294, "Frame", "Image");
    u295.ImageColor3 = rarityStyleFor(Items[result.itemId].rarity).color;
    u295.Rotation = -18;
    u294.Size = UDim2.fromScale(0, 0);
    u294.Adornee = Head;
    u294.Parent = Head;
    u291.janitor:Add(u294, "Destroy");
    local v296 = TweenService:Create(u294, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = Size
    });
    local v297 = TweenService:Create(u295, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Rotation = 13
    });
    u291.janitor:Add(v296, "Cancel");
    u291.janitor:Add(v297, "Cancel");
    v296:Play();
    v297:Play();
    task.delay(0.18, function() -- Line: 1384
        -- upvalues: u290 (copy), u291 (copy), u294 (copy), u295 (copy)
        return u290:setExclamationRotation(u291, u294, u295, -7, 0.14);
    end);
    task.delay(0.32, function() -- Line: 1387
        -- upvalues: u290 (copy), u291 (copy), u294 (copy), u295 (copy)
        return u290:setExclamationRotation(u291, u294, u295, 0, 0.2);
    end);
    task.delay(1.1, function() -- Line: 1390
        -- upvalues: u290 (copy), u291 (copy), u294 (copy), TweenService (ref)
        if u290.session ~= u291 or not u294.Parent then
            return nil;
        end;

        local v298 = TweenService:Create(u294, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromScale(0, 0)
        });
        u291.janitor:Add(v298, "Cancel");
        u291.janitor:Add(v298.Completed:Once(function() -- Line: 1398
            -- upvalues: u294 (ref)
            return u294:Destroy();
        end), "Disconnect");
        v298:Play();
    end);
end;

function u24.setExclamationRotation(p299, p300, p301, p302, p303, p304) -- Line: 1404
    -- upvalues: TweenService (copy)
    if p299.session ~= p300 or not p301.Parent then
        return nil;
    end;

    local v305 = TweenService:Create(p302, TweenInfo.new(p304, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = p303
    });
    p300.janitor:Add(v305, "Cancel");
    v305:Play();
end;

function u24.updateDomeMound(p306, p307, p308) -- Line: 1414
    local v309 = math.min(p308, 0.1) * -40;
    local v310 = 1 - math.exp(v309);
    p307.moundProgress = p307.moundProgress + (p307.moundTarget - p307.moundProgress) * v310;
    local moundProgress = p307.moundProgress;
    local RightVector = p307.surfaceCFrame.RightVector;
    local LookVector = p307.surfaceCFrame.LookVector;
    local v311;

    if p307.baseMoundCount > 0 then
        v311 = p307.baseMoundCount;
    else
        v311 = #p307.mound;
    end;

    local v312 = false;
    local v313 = 0;

    while true do
        if v312 then
            v313 = v313 + 1;
        else
            v312 = true;
        end;

        if v313 >= v311 then
            return;
        end;

        local v314 = p307.mound[v313 + 1];
        local v315 = math.clamp((moundProgress - v314.revealAt) / (1 - v314.revealAt), 0, 1);
        local v316 = 1 - (1 - v315) ^ 3;
        local v317 = math.sin(v315 * 3.141592653589793) * 0.035;
        local v318 = os.clock() * 42 + v314.phase;
        local v319 = RightVector * (math.sin(v318) * v317);
        local v320 = os.clock() * 37 + v314.phase;
        local v321 = v319 + LookVector * (math.cos(v320) * v317);
        v314.part.CFrame = v314.start:Lerp(v314.target, v316) + v321;
        v314.part.Size = v314.size * (v316 * 0.8 + 0.2);
    end;
end;

function u24.updateMoundReveal(p322, p323) -- Line: 1449
    -- upvalues: DIG_REVEAL_SECONDS (copy), DIG_PROGRESS_START (copy), ShovelEvents (copy)
    local v324 = (os.clock() - p323.revealStarted) / DIG_REVEAL_SECONDS;

    if math.clamp(v324, 0, 1) < 1 then
        return nil;
    end;

    p323.phase = "minigame";
    p323.progress = DIG_PROGRESS_START;
    p322:updateItemPosition(p323);

    if p323.sessionId ~= nil then
        ShovelEvents.DigReady:fire(p323.sessionId);
    end;

    p322.bar:show();
end;

function u24.updateMinigame(p325, p326, p327) -- Line: 1462
    -- upvalues: DIG_CLICK_ENERGY_DECAY (copy), DIG_EFFECTIVE_CLICK_BURST (copy), DIG_EFFECTIVE_CLICKS_PER_SECOND (copy), TUTORIAL_PROGRESS_FLOOR (copy), DIG_INPUT_SEND_INTERVAL (copy), DIG_LOSE_THRESHOLD (copy), isDigImpossible (copy), Notification (copy)
    local difficulty = p326.difficulty;
    p326.clickEnergy = math.max(0, p326.clickEnergy - DIG_CLICK_ENERGY_DECAY * p327);
    p326.clickCredits = math.min(DIG_EFFECTIVE_CLICK_BURST, p326.clickCredits + DIG_EFFECTIVE_CLICKS_PER_SECOND * p327);

    if difficulty then
        p326.progress = math.max(0, p326.progress - difficulty.decay * p327);

        if p325.tutorial:isActive() then
            p326.progress = math.max(p326.progress, TUTORIAL_PROGRESS_FLOOR);
        end;
    end;

    local v328 = os.clock();

    if p326.totalClicks > 0 and DIG_INPUT_SEND_INTERVAL <= v328 - p326.lastInputSent then
        p325:flushInput(p326);
    end;

    if not p326.hadDigHit and (p326.firstDigAt ~= nil and (v328 - p326.firstDigAt > 0.75 and p326.moundTarget < 1)) then
        p326.moundTarget = math.min(1, p326.moundTarget + p327 / 2.5);
    end;

    p325:updateDomeMound(p326, p327);
    p325:updateDigAnimationSpeed(p326, p327);
    p325.bar:setProgress(p326.progress);
    p325:updateItemPosition(p326);

    if difficulty and p326.progress <= DIG_LOSE_THRESHOLD then
        if isDigImpossible(difficulty) then
            Notification.new("You need a stronger shovel to dig this!", 3, "None", "Red");
        end;

        p325:finish(false);
    end;
end;

function u24.updateDigAnimationSpeed(p329, p330, p331) -- Line: 1490
    local v332 = 0.12 + p330.clickEnergy * 3.88;
    local digAnimationSpeed = p330.digAnimationSpeed;
    local v333 = v332 - p330.digAnimationSpeed;
    local v334 = -(p330.digAnimationSpeed < v332 and 18 or 1.6) * math.min(p331, 0.1);
    p330.digAnimationSpeed = digAnimationSpeed + v333 * (1 - math.exp(v334));
    p329.shovel:setDigSpeed(p330.digAnimationSpeed);
end;

function u24.onDigInput(p335) -- Line: 1496
    -- upvalues: DIG_CLICK_ENERGY_GAIN (copy), playSound (copy), DIG_WIN_THRESHOLD (copy)
    local session = p335.session;

    if not session or (session.phase ~= "minigame" or session.clickCredits < 1) then
        return nil;
    end;

    local difficulty = session.difficulty;
    session.clickCredits = session.clickCredits - 1;

    if session.firstDigAt == nil then
        session.firstDigAt = os.clock();
    end;

    if difficulty then
        session.progress = math.min(1, session.progress + difficulty.clickPower);
    else
        session.pendingClicks = session.pendingClicks + 1;
    end;

    session.clickEnergy = math.min(1, session.clickEnergy + DIG_CLICK_ENERGY_GAIN);
    session.totalClicks = session.totalClicks + 1;
    session.fovPunch = math.min(5, session.fovPunch + 1.15);
    p335.bar:kick();
    p335.bar:setProgress(session.progress);
    p335:updateItemPosition(session);
    playSound("Tick", {
        cleanupDelay = 2,
        volume = 0.2 + session.progress * 0.18,
        playbackSpeed = 1 + session.progress * 0.25 + math.random() * 0.1
    });

    if difficulty and DIG_WIN_THRESHOLD <= session.progress then
        p335:finish(true);
    end;
end;

function u24.updateItemPosition(p336, p337) -- Line: 1526
    -- upvalues: DIG_PROGRESS_START (copy), DIG_WIN_THRESHOLD (copy)
    local item = p337.item;
    local buriedCFrame = p337.buriedCFrame;
    local emergedCFrame = p337.emergedCFrame;

    if not (item and (buriedCFrame and emergedCFrame)) then
        return nil;
    end;

    local v338 = math.clamp((p337.progress - DIG_PROGRESS_START) / (DIG_WIN_THRESHOLD - DIG_PROGRESS_START), 0, 1);
    local v339 = math.pow(v338, 1.25);
    local v340 = 7 + p337.clickEnergy * 8;
    local v341 = v339 * (0.015 + p337.clickEnergy * 0.035 + p337.itemKick * 0.045);
    local v342 = v339 * math.rad(1 + p337.clickEnergy * 2.5 + p337.itemKick * 3.5);
    local v343 = os.clock();
    local RightVector = p337.surfaceCFrame.RightVector;
    local v344 = math.sin(v343 * v340) * v341;
    local UpVector = p337.surfaceCFrame.UpVector;
    local v345 = math.sin(v343 * v340 * 1.37);
    local v346 = math.abs(v345) * v341 * 0.45;
    item:PivotTo((buriedCFrame:Lerp(emergedCFrame, v339) + (RightVector * v344 + UpVector * v346)) * CFrame.Angles(math.sin(v343 * v340 * 0.83) * v342, 0, math.sin(v343 * v340) * v342));
end;

function u24.isResolving(p347, p348) -- Line: 1548
    return (p348.phase == "finishing" or p348.phase == "success") and true or p348.phase == "loss";
end;

function u24.finish(u349, u350) -- Line: 1551
    local session = u349.session;

    if not session or u349:isResolving(session) then
        return nil;
    end;

    session.phase = "finishing";
    u349.bar:hide();
    u349.shovel:endDigging();
    session.restoreGui();
    u349:flushInput(session);
    task.spawn(function() -- Line: 1561
        -- upvalues: u349 (copy), session (copy), u350 (copy)
        local v351 = u349:requestResolve(session, u350);

        if u349.session ~= session then
            return nil;
        end;

        if u350 and v351 then
            u349:playSuccess(session);

            return;
        end;

        u349:playLoss(session);
    end);
end;

function u24.requestResolve(p352, p353, p354) -- Line: 1573
    -- upvalues: ShovelFunctions (copy)
    local sessionId = p353.sessionId;

    if sessionId == nil then
        return false;
    end;

    for _ = 0, 3 do
        local v355, v356 = ShovelFunctions.ResolveDig:invoke(sessionId, p354, p353.totalClicks):await();

        if v355 then
            return v356;
        end;

        task.wait(0.35);
    end;

    return false;
end;

function u24.playSuccess(u357, u358) -- Line: 1587
    -- upvalues: playSound (copy)
    u358.restoreMovement();
    local itemRoot = u358.itemRoot;

    if not itemRoot then
        u357:endSession(u358);

        return nil;
    end;

    u358.phase = "success";
    u358.fovPunch = 10;
    local beams = u358.beams;

    if beams ~= nil then
        beams:fadeOut();
    end;

    u357:sinkMound(u358);

    for _, descendant in u358.item:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "Characters";
            descendant.Anchored = false;
            descendant.CanTouch = false;
        end;
    end;

    itemRoot.CanCollide = true;
    itemRoot.AssemblyLinearVelocity = u358.root.CFrame.LookVector * -6 + u358.surfaceCFrame.UpVector * 14;
    local v359 = (math.random() - 0.5) * 7;
    local v360 = (math.random() - 0.5) * 9;
    local v361 = (math.random() - 0.5) * 7;
    itemRoot.AssemblyAngularVelocity = Vector3.new(v359, v360, v361);
    playSound("RevealPop", {
        volume = 0.9,
        cleanupDelay = 4,
        playbackSpeed = 1 + math.random() * 0.14
    });
    task.delay(0.55, function() -- Line: 1619
        -- upvalues: u357 (copy), u358 (copy)
        return u357:endSession(u358);
    end);
end;

function u24.playLoss(p362, p363) -- Line: 1623
    -- upvalues: playSound (copy)
    p363.phase = "loss";
    p363.finishStarted = os.clock();
    local item = p363.item;

    if item ~= nil then
        item = item:GetPivot();
    end;

    p363.lossStartCFrame = item;
    local beams = p363.beams;

    if beams ~= nil then
        beams:fadeOut();
    end;

    p362:sinkMound(p363);
    playSound("Error", {
        volume = 0.45,
        cleanupDelay = 3,
        playbackSpeed = 1 + math.random() * 0.1
    });
end;

function u24.updateLoss(p364, p365) -- Line: 1642
    local v366 = (os.clock() - p365.finishStarted) / 0.7;
    local v367 = math.clamp(v366, 0, 1);

    if p365.item and (p365.lossStartCFrame and p365.buriedCFrame) then
        p365.item:PivotTo(p365.lossStartCFrame:Lerp(p365.buriedCFrame - p365.surfaceCFrame.UpVector * 1.5, v367 * v367));
    end;

    if v367 >= 1 then
        p364:endSession(p365);
    end;
end;

function u24.sinkMound(p368, p369) -- Line: 1654
    -- upvalues: TweenService (copy)
    local UpVector = p369.surfaceCFrame.UpVector;

    for _, v in p369.mound do
        local v370 = TweenService:Create(v.part, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            CFrame = v.target - UpVector * (v.size.Y + 0.7),
            Size = v.size * 0.2
        });
        p369.janitor:Add(v370, "Cancel");
        v370:Play();
    end;
end;

function u24.abortSession(p371) -- Line: 1671
    -- upvalues: ShovelFunctions (copy)
    p371.starting = false;
    local session = p371.session;

    if not session then
        return nil;
    end;

    local sessionId = session.sessionId;

    if sessionId ~= nil and not p371:isResolving(session) then
        task.spawn(function() -- Line: 1679
            -- upvalues: ShovelFunctions (ref), sessionId (copy), session (copy)
            return ShovelFunctions.ResolveDig:invoke(sessionId, false, session.totalClicks);
        end);
    end;

    p371:endSession(session);
end;

function u24.flushInput(p372, p373) -- Line: 1685
    -- upvalues: ShovelEvents (copy)
    local sessionId = p373.sessionId;

    if sessionId == nil or p373.totalClicks == 0 then
        return nil;
    end;

    p373.lastInputSent = os.clock();
    ShovelEvents.DigInput:fire(sessionId, p373.totalClicks);
end;

function u24.endSession(p374, p375) -- Line: 1693
    -- upvalues: Workspace (copy)
    if p374.session ~= p375 then
        return nil;
    end;

    p374.session = nil;
    p374.affordNotification:setBusy("dig", false);
    p374.music:restore();
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera.FieldOfView = p375.baseFov;
    end;

    p375.janitor:Destroy();
end;

Reflect.defineMetadata(u24, "identifier", "client/controllers/world/DigController@DigController");
Reflect.defineMetadata(u24, "flamework:parameters", { "client/controllers/world/ShovelController@ShovelController", "client/controllers/world/DetectorController@DetectorController", "client/controllers/world/DigBarController@DigBarController", "client/controllers/misc/MusicController@MusicController", "client/controllers/data/DataController@DataController", "client/controllers/tutorial/TutorialController@TutorialController", "client/controllers/ui/AffordNotificationController@AffordNotificationController", "client/controllers/ui/BackpackVisibilityController@BackpackVisibilityController", "client/controllers/world/DetectorSweepController@DetectorSweepController", "client/controllers/world/SurfacedItemController@SurfacedItemController" });
Reflect.defineMetadata(u24, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" });
Reflect.decorate(u24, "$:flamework@Controller", Controller, { {} });

return {
    DigController = u24
};