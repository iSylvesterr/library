-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local GuiService = v1.GuiService;
local ReplicatedStorage = v1.ReplicatedStorage;
local TweenService = v1.TweenService;
local UserInputService = v1.UserInputService;
local Workspace = v1.Workspace;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants");
local Player = v2.Player;
local PlayerGui = v2.PlayerGui;
local v3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "TutorialNetwork");
local TutorialEvents = v3.TutorialEvents;
local TutorialFunctions = v3.TutorialFunctions;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels");
local DIG_ZONE_TAG = v4.DIG_ZONE_TAG;
local Shovels = v4.Shovels;
local v5 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "tutorial", "TutorialConfig");
local FOLLOW_TUTORIAL_DURATION = v5.FOLLOW_TUTORIAL_DURATION;
local FOLLOW_TUTORIAL_MESSAGE = v5.FOLLOW_TUTORIAL_MESSAGE;
local TUTORIAL_DIG_SPOT_DURATION = v5.TUTORIAL_DIG_SPOT_DURATION;
local TUTORIAL_DIG_SPOT_MESSAGE = v5.TUTORIAL_DIG_SPOT_MESSAGE;
local TUTORIAL_DIG_SPOT_RANGE = v5.TUTORIAL_DIG_SPOT_RANGE;
local TUTORIAL_PEDESTAL_SLOT = v5.TUTORIAL_PEDESTAL_SLOT;
local TUTORIAL_SHOVEL_ID = v5.TUTORIAL_SHOVEL_ID;
local TUTORIAL_TEXTS = v5.TUTORIAL_TEXTS;
local TutorialStep = v5.TutorialStep;
local v6 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands");
local ISLAND_ID_ATTRIBUTE = v6.ISLAND_ID_ATTRIBUTE;
local STARTER_ISLAND_ID = v6.STARTER_ISLAND_ID;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local digZoneAt = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DigZoneSpawn").digZoneAt;
local getStarterIsland = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "getStarterIsland").getStarterIsland;
local u7 = Vector2.new(0.15, 0.1);
local u8 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true);
local u9 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true);
local u10 = setmetatable({}, {
    __tostring = function() -- Line: 63, Name: __tostring
        return "TutorialController";
    end
});
u10.__index = u10;

function u10.new(...) -- Line: 68
    -- upvalues: u10 (ref)
    local v11 = setmetatable({}, u10);

    return v11:constructor(...) or v11;
end;

function u10.constructor(p12, p13, p14) -- Line: 72
    -- upvalues: Janitor (copy)
    p12.plot = p13;
    p12.topButtons = p14;
    p12.uiReady = false;
    p12.stepJanitor = Janitor.new();
    p12.stepListeners = {};
    p12.buyFrameOpen = false;
    p12.lastZoneReport = 0;
end;

function u10.onStart(u15) -- Line: 81
    -- upvalues: TutorialEvents (copy), Player (copy), RuntimeLib (copy), TutorialFunctions (copy)
    TutorialEvents.TutorialStepChanged:connect(function(p16) -- Line: 82
        -- upvalues: u15 (copy)
        return u15:applyState(p16);
    end);
    Player.CharacterAdded:Connect(function() -- Line: 85
        -- upvalues: u15 (copy)
        return u15:onCharacterAdded();
    end);
    task.spawn(function() -- Line: 88
        -- upvalues: u15 (copy)
        return u15:setupUi();
    end);
    task.spawn(RuntimeLib.async(function() -- Line: 91
        -- upvalues: u15 (copy), RuntimeLib (ref), TutorialFunctions (ref)
        while u15.step == nil and u15.pendingState == nil do
            local v17 = RuntimeLib.await(TutorialFunctions.GetTutorialState:invoke():catch(function() -- Line: 93
                return nil;
            end));

            if v17 and (u15.step == nil and u15.pendingState == nil) then
                u15:applyState(v17);

                return;
            end;

            task.wait(1);
        end;
    end));
end;

function u10.setupUi(p18) -- Line: 104
    -- upvalues: WFChain (copy), PlayerGui (copy)
    local v19 = WFChain(PlayerGui, "Tutorial");
    v19.ResetOnSpawn = false;
    p18.tutorialLabel = WFChain(v19, "Tutorial");
    p18.tutorialLabel.Visible = false;
    p18.hud = WFChain(PlayerGui, "HUD");
    p18.pointerFinger = WFChain(p18.hud, "PointerFinger");
    p18.pointerFinger.Visible = false;
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "TutorialPointer";
    ScreenGui.DisplayOrder = 1000;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = PlayerGui;
    p18.pointerFinger.Parent = ScreenGui;
    p18.pointerGui = ScreenGui;
    p18.redArrow = WFChain(p18.hud, "Arrow");
    p18.redArrow.Visible = false;
    p18.leftButtonsFrame = WFChain(p18.hud, "LeftButtons");
    p18.rightButtonsFrame = WFChain(p18.hud, "RightButtons");
    p18.topButtonsFrame = WFChain(p18.hud, "TopButtons");
    p18.hubButton = WFChain(p18.topButtonsFrame, "Hub");
    p18.uiReady = true;
    local pendingState = p18.pendingState;

    if pendingState then
        p18.pendingState = nil;
        p18:applyState(pendingState);
    end;
end;

function u10.isActive(p20) -- Line: 133
    -- upvalues: TutorialStep (copy)
    local v21;

    if p20.step == nil then
        v21 = false;
    else
        v21 = p20.step < TutorialStep.Done;
    end;

    return v21;
end;

function u10.getStep(p22) -- Line: 136
    return p22.step;
end;

function u10.canDig(p23) -- Line: 139
    -- upvalues: TutorialStep (copy)
    return not p23:isActive() or p23.step == TutorialStep.StartDig;
end;

function u10.canClean(p24) -- Line: 142
    -- upvalues: TutorialStep (copy)
    return not p24:isActive() or (p24.step == TutorialStep.GoClean and true or p24.step == TutorialStep.SprayDirt);
end;

function u10.canUsePedestal(p25, p26, p27) -- Line: 145
    -- upvalues: TutorialStep (copy), TUTORIAL_PEDESTAL_SLOT (copy)
    if not p25:isActive() then
        return true;
    end;

    if p27 then
        if p25.step == TutorialStep.PlaceItem then
            p27 = p26 == TUTORIAL_PEDESTAL_SLOT;
        else
            p27 = false;
        end;
    end;

    return p27;
end;

function u10.canBuyGear(p28, p29, p30) -- Line: 151
    -- upvalues: TutorialStep (copy), TUTORIAL_SHOVEL_ID (copy)
    if not p28:isActive() then
        return true;
    end;

    local v31;

    if p28.step == TutorialStep.BuyShovel and p29 == "shovel" then
        v31 = p30 == TUTORIAL_SHOVEL_ID;
    else
        v31 = false;
    end;

    return v31;
end;

function u10.canOpenDialogue(p32) -- Line: 157
    return not p32:isActive();
end;

function u10.notifyFollowTutorial(p33) -- Line: 160
    -- upvalues: Notification (copy), FOLLOW_TUTORIAL_MESSAGE (copy), FOLLOW_TUTORIAL_DURATION (copy)
    Notification.new(FOLLOW_TUTORIAL_MESSAGE, FOLLOW_TUTORIAL_DURATION, "Error", "Red");
end;

function u10.notifyCannotDig(p34) -- Line: 163
    -- upvalues: TutorialStep (copy), Notification (copy), TUTORIAL_DIG_SPOT_MESSAGE (copy), TUTORIAL_DIG_SPOT_DURATION (copy)
    if p34.step == TutorialStep.DetectItem or p34.step == TutorialStep.GoToDigSpot then
        Notification.new(TUTORIAL_DIG_SPOT_MESSAGE, TUTORIAL_DIG_SPOT_DURATION, "Pop", "Light Gray");

        return;
    end;

    p34:notifyFollowTutorial();
end;

function u10.onRevealEnded(p35) -- Line: 170
    -- upvalues: TutorialStep (copy), TutorialEvents (copy)
    if p35.step == TutorialStep.Reveal then
        TutorialEvents.ReportTutorialProgress:fire(TutorialStep.PlaceItem);
    end;
end;

function u10.onNodeSurfaced(p36) -- Line: 175
    -- upvalues: TutorialStep (copy), TutorialEvents (copy)
    if p36.step == TutorialStep.DetectItem then
        TutorialEvents.ReportTutorialProgress:fire(TutorialStep.GoToDigSpot);
    end;
end;

function u10.onStepChanged(u37, u38) -- Line: 180
    u37.stepListeners[u38] = true;

    if u37.step ~= nil then
        task.spawn(u38, u37.step);
    end;

    return function() -- Line: 187
        -- upvalues: u37 (copy), u38 (copy)
        local stepListeners = u37.stepListeners;
        local v39 = u38;
        local v40 = stepListeners[v39] ~= nil;
        stepListeners[v39] = nil;

        return v40;
    end;
end;

function u10.applyState(p41, p42) -- Line: 197
    if not p41.uiReady then
        p41.pendingState = p42;

        return nil;
    end;

    local step = p41.step;
    p41.step = p42.step;
    p41.digSpot = p42.digSpot;

    if p42.itemUid ~= nil then
        p41.itemUid = p42.itemUid;
    end;

    if step == p42.step then
        return nil;
    end;

    p41:renderStep(p42.step, step);

    for i in p41.stepListeners do
        task.spawn(i, p42.step);
    end;
end;

function u10.renderStep(p43, p44, p45) -- Line: 216
    -- upvalues: TutorialStep (copy)
    p43.stepJanitor:Cleanup();
    p43:hideGuide();
    p43:hidePointerFinger();
    p43:hideRedArrow();
    p43.workbenchPosition = nil;
    p43.pedestalPosition = nil;
    p43.shovelStandPosition = nil;
    p43.buyFrameOpen = false;
    local v46 = p44 < TutorialStep.Done;
    p43.leftButtonsFrame.Visible = not v46;
    p43.rightButtonsFrame.Visible = not v46;

    if v46 then
        v46 = p44 ~= TutorialStep.BuyShovel;
    end;

    p43.topButtons:setTutorialHidden(v46);

    if TutorialStep.Done <= p44 then
        if p45 == nil or p45 >= TutorialStep.Done then
            p43:setText(nil);
        else
            p43:showDoneText();
        end;

        return nil;
    end;

    p43:setText(p43:textFor(p44));

    if p44 == TutorialStep.GoToDigZone then
        p43:renderGoToDigZone();

        return;
    end;

    if p44 == TutorialStep.GoToDigSpot then
        p43:renderGoToDigSpot();

        return;
    end;

    if p44 == TutorialStep.StartDig then
        p43:renderStartDig();

        return;
    end;

    if p44 == TutorialStep.GoClean then
        p43:renderGoClean();

        return;
    end;

    if p44 == TutorialStep.PlaceItem then
        p43:renderPlaceItem();

        return;
    end;

    if p44 == TutorialStep.BuyShovel then
        p43:renderBuyShovel();
    end;
end;

function u10.showDoneText(u47) -- Line: 252
    -- upvalues: TutorialStep (copy)
    u47:setText(u47:textFor(TutorialStep.Done));
    local u48 = task.delay(5, function() -- Line: 254
        -- upvalues: u47 (copy)
        return u47:setText(nil);
    end);
    u47.stepJanitor:Add(function() -- Line: 257
        -- upvalues: u48 (copy)
        return task.cancel(u48);
    end, true);
end;

function u10.textFor(p49, p50) -- Line: 261
    -- upvalues: TUTORIAL_TEXTS (copy)
    local v51 = TUTORIAL_TEXTS[p50];

    if not v51 then
        return nil;
    end;

    if p49:isConsole() then
        return v51.console;
    end;

    if p49:isMobile() then
        return v51.mobile;
    end;

    return v51.pc;
end;

function u10.isConsole(p52) -- Line: 274
    -- upvalues: GuiService (copy)
    return GuiService:IsTenFootInterface();
end;

function u10.isMobile(p53) -- Line: 277
    -- upvalues: UserInputService (copy)
    local v54 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not p53:isConsole();

    return v54;
end;

function u10.setText(p55, p56) -- Line: 280
    p55.tutorialLabel.Text = p56 == nil and "" or p56;
    p55.tutorialLabel.Visible = p56 ~= nil;
end;

function u10.onTick(p57) -- Line: 288
    -- upvalues: TutorialStep (copy)
    local step = p57.step;

    if step == nil then
        return nil;
    end;

    if step == TutorialStep.GoToDigZone or step == TutorialStep.DetectItem then
        p57:reportZoneState(step);

        return;
    end;

    if step == TutorialStep.GoToDigSpot or step == TutorialStep.StartDig then
        p57:reportDigSpotState(step);

        return;
    end;

    if step == TutorialStep.GoClean then
        p57:autoEquipNear(p57.workbenchPosition);

        return;
    end;

    if step == TutorialStep.PlaceItem then
        p57:autoEquipNear(p57.pedestalPosition);

        return;
    end;

    if step == TutorialStep.BuyShovel then
        p57:updateBuyShovelPointer();
    end;
end;

function u10.reportZoneState(p58, p59) -- Line: 305
    -- upvalues: TutorialStep (copy), TutorialEvents (copy)
    local v60 = os.clock();

    if v60 - p58.lastZoneReport < 0.25 then
        return nil;
    end;

    local v61 = p58:isInDigZone();

    if p59 ~= TutorialStep.GoToDigZone or not v61 then
        if p59 == TutorialStep.DetectItem and not v61 then
            p58.lastZoneReport = v60;
            TutorialEvents.ReportTutorialProgress:fire(TutorialStep.GoToDigZone);
        end;

        return;
    end;

    p58.lastZoneReport = v60;
    TutorialEvents.ReportTutorialProgress:fire(TutorialStep.DetectItem);
end;

function u10.reportDigSpotState(p62, p63) -- Line: 319
    -- upvalues: Player (copy), TUTORIAL_DIG_SPOT_RANGE (copy), TutorialStep (copy), TutorialEvents (copy)
    local digSpot = p62.digSpot;
    local v64 = os.clock();

    if digSpot == nil or v64 - p62.lastZoneReport < 0.25 then
        return nil;
    end;

    local Character = Player.Character;

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v65;

    if Character == nil then
        v65 = Character;
    else
        v65 = Character:IsA("BasePart");
    end;

    if not v65 then
        return nil;
    end;

    local v66 = Character.Position - digSpot;
    local v67 = math.sqrt(v66.X * v66.X + v66.Z * v66.Z) <= TUTORIAL_DIG_SPOT_RANGE;

    if p63 ~= TutorialStep.GoToDigSpot or not v67 then
        if p63 == TutorialStep.StartDig and not v67 then
            p62.lastZoneReport = v64;
            TutorialEvents.ReportTutorialProgress:fire(TutorialStep.GoToDigSpot);
        end;

        return;
    end;

    p62.lastZoneReport = v64;
    TutorialEvents.ReportTutorialProgress:fire(TutorialStep.StartDig);
end;

function u10.isInDigZone(p68) -- Line: 347
    -- upvalues: Player (copy), digZoneAt (copy)
    local Character = Player.Character;

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v69;

    if Character == nil then
        v69 = Character;
    else
        v69 = Character:IsA("BasePart");
    end;

    if v69 then
        return digZoneAt(Character.Position) ~= nil;
    end;

    return false;
end;

function u10.renderGoToDigZone(u70) -- Line: 362
    -- upvalues: RuntimeLib (copy), TutorialStep (copy)
    task.spawn(RuntimeLib.async(function() -- Line: 363
        -- upvalues: RuntimeLib (ref), u70 (copy), TutorialStep (ref)
        local v71 = RuntimeLib.await(u70.plot:awaitPlot());

        if u70.step ~= TutorialStep.GoToDigZone then
            return nil;
        end;

        local v72 = u70:computeDigTarget(v71);

        if v72 then
            u70:showGuide(v72);
        end;
    end));
end;

function u10.computeDigTarget(p73, p74) -- Line: 374
    -- upvalues: CollectionService (copy), DIG_ZONE_TAG (copy), ISLAND_ID_ATTRIBUTE (copy), STARTER_ISLAND_ID (copy)
    local function _(p75) -- Line: 377
        -- upvalues: ISLAND_ID_ATTRIBUTE (ref), STARTER_ISLAND_ID (ref)
        local v76 = p75:IsA("BasePart") and p75:GetAttribute(ISLAND_ID_ATTRIBUTE) == STARTER_ISLAND_ID;

        return v76;
    end;

    local v77 = nil;

    for i, v in CollectionService:GetTagged(DIG_ZONE_TAG) do
        local _ = i - 1;
        local v78 = v:IsA("BasePart") and v:GetAttribute(ISLAND_ID_ATTRIBUTE) == STARTER_ISLAND_ID;

        if v78 == true then
            v77 = v;
            break;
        end;
    end;

    if not v77 then
        return nil;
    end;

    local Position = p74:GetPivot().Position;
    local v79 = v77.Position.Y + v77.Size.Y * 0.5;
    local v80 = v77.CFrame:PointToObjectSpace(Position);
    local v81 = v77.Size.X >= v77.Size.Z;
    local v82;

    if v81 then
        v82 = v77.Size.X;
    else
        v82 = v77.Size.Z;
    end;

    local v83 = math.max(v82 * 0.5 - 6, 1);
    local v84;

    if v81 then
        v84 = v80.X;
    else
        v84 = v80.Z;
    end;

    local v85 = math.clamp(v84, -v83, v83);
    local CFrame2 = v77.CFrame;
    local v86;

    if v81 then
        v86 = Vector3.new(v85, 0, 0);
    else
        v86 = Vector3.new(0, 0, v85);
    end;

    local v87 = CFrame2:PointToWorldSpace(v86);

    return Vector3.new(v87.X, v79, v87.Z);
end;

function u10.renderGoToDigSpot(p88) -- Line: 401
    if p88.digSpot then
        p88:showGuide(p88.digSpot);
    end;
end;

function u10.renderStartDig(u89) -- Line: 406
    -- upvalues: WFChain (copy), PlayerGui (copy), TutorialStep (copy)
    if not u89:isMobile() then
        return nil;
    end;

    task.spawn(function() -- Line: 410
        -- upvalues: WFChain (ref), PlayerGui (ref), u89 (copy), TutorialStep (ref)
        local v90 = WFChain(PlayerGui, "Mobile", "MobileButtons", "Dig");

        if u89.step ~= TutorialStep.StartDig then
            return nil;
        end;

        u89:showRedArrowAt(v90);
    end);
end;

function u10.renderGoClean(u91) -- Line: 418
    -- upvalues: TutorialStep (copy), RuntimeLib (copy), WFChain (copy)
    local u92 = task.delay(2.5, function() -- Line: 419
        -- upvalues: u91 (copy), TutorialStep (ref)
        if u91.step == TutorialStep.GoClean then
            u91:equipTutorialTool();
        end;
    end);
    u91.stepJanitor:Add(function() -- Line: 424
        -- upvalues: u92 (copy)
        return task.cancel(u92);
    end, true);
    task.spawn(RuntimeLib.async(function() -- Line: 427
        -- upvalues: RuntimeLib (ref), u91 (copy), WFChain (ref), TutorialStep (ref)
        local v93 = WFChain(RuntimeLib.await(u91.plot:awaitPlot()), "Workbench");

        if u91.step ~= TutorialStep.GoClean then
            return nil;
        end;

        u91.workbenchPosition = v93:GetPivot().Position;
        u91:showGuide(u91.workbenchPosition);
    end));
end;

function u10.renderPlaceItem(u94) -- Line: 437
    -- upvalues: TutorialStep (copy), RuntimeLib (copy), WFChain (copy), TUTORIAL_PEDESTAL_SLOT (copy)
    task.defer(function() -- Line: 438
        -- upvalues: u94 (copy), TutorialStep (ref)
        if u94.step == TutorialStep.PlaceItem then
            u94:equipTutorialTool();
        end;
    end);
    task.spawn(RuntimeLib.async(function() -- Line: 443
        -- upvalues: RuntimeLib (ref), u94 (copy), WFChain (ref), TUTORIAL_PEDESTAL_SLOT (ref), TutorialStep (ref)
        local v95 = WFChain(RuntimeLib.await(u94.plot:awaitPlot()), "Plot", "Pedestals", (`Pedestal_{TUTORIAL_PEDESTAL_SLOT}`));

        if u94.step ~= TutorialStep.PlaceItem then
            return nil;
        end;

        u94.pedestalPosition = v95:GetPivot().Position;
        u94:showGuide(u94.pedestalPosition);
    end));
end;

function u10.renderBuyShovel(u96) -- Line: 453
    -- upvalues: TutorialStep (copy), FrameComponent (copy), WFChain (copy), PlayerGui (copy)
    u96:pointFingerAt(u96.hubButton);
    task.spawn(function() -- Line: 455
        -- upvalues: u96 (copy), TutorialStep (ref)
        local v97 = u96:waitForShovelStand();

        if not v97 or u96.step ~= TutorialStep.BuyShovel then
            return nil;
        end;

        u96.shovelStandPosition = v97:GetPivot().Position;
        u96:showGuide(u96.shovelStandPosition);
    end);
    u96.stepJanitor:Add(FrameComponent.onOpened.Event:Connect(function(p98) -- Line: 463
        -- upvalues: u96 (copy), TutorialStep (ref), WFChain (ref), PlayerGui (ref)
        if p98 ~= "BuyFrame" or u96.step ~= TutorialStep.BuyShovel then
            return nil;
        end;

        u96.buyFrameOpen = true;
        u96:setText(nil);
        u96:pointFingerAt((WFChain(PlayerGui, "Main", "BuyFrame", "Yes")));
    end), "Disconnect");
    u96.stepJanitor:Add(FrameComponent.onClosed.Event:Connect(function(p99) -- Line: 472
        -- upvalues: u96 (copy), TutorialStep (ref)
        if p99 ~= "BuyFrame" or u96.step ~= TutorialStep.BuyShovel then
            return nil;
        end;

        u96.buyFrameOpen = false;
        u96:setText(u96:textFor(TutorialStep.BuyShovel));
        u96:updateBuyShovelPointer();
    end), "Disconnect");
end;

function u10.updateBuyShovelPointer(p100) -- Line: 481
    -- upvalues: Player (copy)
    if p100.buyFrameOpen then
        return nil;
    end;

    local shovelStandPosition = p100.shovelStandPosition;
    local Character = Player.Character;

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v101 = not shovelStandPosition;

    if not v101 then
        local v102;

        if Character == nil then
            v102 = Character;
        else
            v102 = Character:IsA("BasePart");
        end;

        v101 = not v102;
    end;

    if v101 then
        return nil;
    end;

    if (Character.Position - shovelStandPosition).Magnitude <= 45 then
        p100:hidePointerFinger();

        return;
    end;

    p100:pointFingerAt(p100.hubButton);
end;

function u10.autoEquipNear(p103, p104) -- Line: 508
    -- upvalues: Player (copy)
    if not p104 then
        return nil;
    end;

    local Character = Player.Character;

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v105;

    if Character == nil then
        v105 = Character;
    else
        v105 = Character:IsA("BasePart");
    end;

    if not v105 then
        return nil;
    end;

    if (Character.Position - p104).Magnitude > 16 then
        return nil;
    end;

    p103:equipTutorialTool();
end;

function u10.equipTutorialTool(p106) -- Line: 531
    -- upvalues: Player (copy)
    local itemUid = p106.itemUid;

    if itemUid == nil then
        return nil;
    end;

    local Character = Player.Character;
    local v107;

    if Character == nil then
        v107 = Character;
    else
        v107 = Character:FindFirstChildOfClass("Humanoid");
    end;

    if not Character or (not v107 or v107.Health <= 0) then
        return nil;
    end;

    local function _(p108) -- Line: 548
        -- upvalues: itemUid (copy)
        local v109 = p108:IsA("Tool") and p108:GetAttribute("inventoryId") == itemUid;

        return v109;
    end;

    local v110 = false;

    for i, child in Character:GetChildren() do
        local _ = i - 1;
        local v111 = child:IsA("Tool") and child:GetAttribute("inventoryId") == itemUid;

        if v111 then
            v110 = true;
            break;
        end;
    end;

    if v110 then
        return nil;
    end;

    local v112 = Player:FindFirstChildOfClass("Backpack");

    if v112 ~= nil then
        local function _(p113) -- Line: 567
            -- upvalues: itemUid (copy)
            local v114 = p113:IsA("Tool") and p113:GetAttribute("inventoryId") == itemUid;

            return v114;
        end;

        v112 = nil;

        for i, child in v112:GetChildren() do
            local _ = i - 1;
            local v115 = child:IsA("Tool") and child:GetAttribute("inventoryId") == itemUid;

            if v115 == true then
                v112 = child;
                break;
            end;
        end;
    end;

    local v116;

    if v112 == nil then
        v116 = v112;
    else
        v116 = v112:IsA("Tool");
    end;

    if v116 then
        v107:EquipTool(v112);
    end;
end;

function u10.showGuide(p117, p118) -- Line: 589
    p117:ensureGuideArrow().CFrame = CFrame.new(p118);
    p117:bindGuideToCharacter();

    if p117.guideBeam then
        p117.guideBeam.Enabled = true;
    end;
end;

function u10.hideGuide(p119) -- Line: 597
    if p119.guideBeam then
        p119.guideBeam.Enabled = false;
    end;
end;

function u10.ensureGuideArrow(p120) -- Line: 602
    -- upvalues: WFChain (copy), ReplicatedStorage (copy), Workspace (copy)
    local guideArrow = p120.guideArrow;

    if guideArrow ~= nil then
        guideArrow = guideArrow.Parent;
    end;

    if guideArrow then
        return p120.guideArrow;
    end;

    local v121 = WFChain(ReplicatedStorage, "Assets", "Arrow"):Clone();
    v121.Anchored = true;
    v121.CanCollide = false;
    v121.CanQuery = false;
    v121.CanTouch = false;
    v121.Parent = Workspace;
    p120.guideArrow = v121;
    local TutorialBeam = v121:FindFirstChild("TutorialBeam");
    local v122;

    if TutorialBeam == nil then
        v122 = TutorialBeam;
    else
        v122 = TutorialBeam:IsA("Beam");
    end;

    if not v122 then
        TutorialBeam = nil;
    end;

    p120.guideBeam = TutorialBeam;
    local v123 = v121:FindFirstChildOfClass("Attachment");

    if p120.guideBeam and v123 then
        p120.guideBeam.Attachment0 = v123;
    end;

    return v121;
end;

function u10.waitForShovelStand(p124) -- Line: 630
    -- upvalues: WFChain (copy), getStarterIsland (copy), Shovels (copy), TUTORIAL_SHOVEL_ID (copy)
    local v125 = WFChain(getStarterIsland(), "NPCs", "Gear", "BuyShovels");
    local displayName = Shovels[TUTORIAL_SHOVEL_ID].displayName;
    local v126 = os.clock() + 30;

    while os.clock() < v126 do
        local v127 = v125:FindFirstChild(displayName, true);
        local v128;

        if v127 == nil then
            v128 = v127;
        else
            v128 = v127:IsA("Model");
        end;

        if v128 then
            return v127;
        end;

        task.wait(0.25);
    end;

    return nil;
end;

function u10.bindGuideToCharacter(p129) -- Line: 647
    -- upvalues: Player (copy)
    local Character = Player.Character;

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v130;

    if Character == nil then
        v130 = Character;
    else
        v130 = Character:IsA("BasePart");
    end;

    if not (v130 and p129.guideBeam) then
        return nil;
    end;

    local TutorialGuideAttachment = Character:FindFirstChild("TutorialGuideAttachment");

    if not TutorialGuideAttachment then
        TutorialGuideAttachment = Instance.new("Attachment");
        TutorialGuideAttachment.Name = "TutorialGuideAttachment";
        TutorialGuideAttachment.Parent = Character;
    end;

    p129.guideBeam.Attachment1 = TutorialGuideAttachment;
end;

function u10.onCharacterAdded(u131) -- Line: 672
    -- upvalues: Player (copy)
    task.spawn(function() -- Line: 673
        -- upvalues: Player (ref), u131 (copy)
        local Character = Player.Character;

        if not Character then
            return nil;
        end;

        Character:WaitForChild("HumanoidRootPart", 10);
        local guideBeam = u131.guideBeam;

        if guideBeam ~= nil then
            guideBeam = guideBeam.Enabled;
        end;

        if guideBeam then
            u131:bindGuideToCharacter();
        end;
    end);
end;

function u10.pointFingerAt(u132, p133) -- Line: 688
    -- upvalues: TweenService (copy), u8 (copy)
    if u132.pointerTarget == p133 and u132.pointerFinger.Visible then
        return nil;
    end;

    u132.pointerTarget = p133;
    local pointerConnection = u132.pointerConnection;

    if pointerConnection ~= nil then
        pointerConnection:Disconnect();
    end;

    u132.pointerConnection = p133:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- Line: 697
        -- upvalues: u132 (copy)
        return u132:updatePointerPosition();
    end);
    u132:updatePointerPosition();
    u132.pointerFinger.Visible = true;
    local pointerTween = u132.pointerTween;

    if pointerTween ~= nil then
        pointerTween:Cancel();
    end;

    u132.pointerFinger.Rotation = 0;
    u132.pointerTween = TweenService:Create(u132.pointerFinger, u8, {
        Rotation = -18
    });
    u132.pointerTween:Play();
end;

function u10.updatePointerPosition(p134) -- Line: 712
    -- upvalues: u7 (copy)
    local pointerTarget = p134.pointerTarget;

    if not pointerTarget then
        return nil;
    end;

    local v135 = pointerTarget.AbsolutePosition + pointerTarget.AbsoluteSize * 0.5;
    local AbsolutePosition = p134.pointerGui.AbsolutePosition;
    p134.pointerFinger.AnchorPoint = u7;
    p134.pointerFinger.Position = UDim2.fromOffset(v135.X - AbsolutePosition.X, v135.Y - AbsolutePosition.Y);
end;

function u10.hidePointerFinger(p136) -- Line: 724
    local pointerTween = p136.pointerTween;

    if pointerTween ~= nil then
        pointerTween:Cancel();
    end;

    p136.pointerTween = nil;
    local pointerConnection = p136.pointerConnection;

    if pointerConnection ~= nil then
        pointerConnection:Disconnect();
    end;

    p136.pointerConnection = nil;
    p136.pointerTarget = nil;

    if p136.pointerFinger then
        p136.pointerFinger.Visible = false;
    end;
end;

function u10.showRedArrowAt(p137, p138) -- Line: 740
    -- upvalues: TweenService (copy), u9 (copy)
    local redArrow = p137.redArrow;
    local v139 = p138.AbsolutePosition + p138.AbsoluteSize * 0.5;
    local AbsolutePosition = p137.hud.AbsolutePosition;
    local v140 = Vector2.new(0.7071067811865476, 0.7071067811865475);
    local v141 = math.max(p138.AbsoluteSize.X, p138.AbsoluteSize.Y) * 1.1;
    local v142 = Vector2.new(v139.X - AbsolutePosition.X, v139.Y - AbsolutePosition.Y) - v140 * v141;
    redArrow.AnchorPoint = Vector2.new(0.5, 0.5);
    redArrow.Rotation = 45;
    redArrow.Position = UDim2.fromOffset(v142.X, v142.Y);
    redArrow.Visible = true;
    local redArrowTween = p137.redArrowTween;

    if redArrowTween ~= nil then
        redArrowTween:Cancel();
    end;

    local v143 = v142 + v140 * 16;
    p137.redArrowTween = TweenService:Create(redArrow, u9, {
        Position = UDim2.fromOffset(v143.X, v143.Y)
    });
    p137.redArrowTween:Play();
end;

function u10.hideRedArrow(p144) -- Line: 767
    local redArrowTween = p144.redArrowTween;

    if redArrowTween ~= nil then
        redArrowTween:Cancel();
    end;

    p144.redArrowTween = nil;

    if p144.redArrow then
        p144.redArrow.Visible = false;
    end;
end;

Reflect.defineMetadata(u10, "identifier", "client/controllers/tutorial/TutorialController@TutorialController");
Reflect.defineMetadata(u10, "flamework:parameters", { "client/controllers/plot/PlotController@PlotController", "client/controllers/ui/TopButtonsController@TopButtonsController" });
Reflect.defineMetadata(u10, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" });
Reflect.decorate(u10, "$:flamework@Controller", Controller, { {} });

return {
    TutorialController = u10
};