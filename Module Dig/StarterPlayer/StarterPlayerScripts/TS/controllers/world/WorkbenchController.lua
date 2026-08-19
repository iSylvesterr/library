-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local Players = v1.Players;
local ReplicatedStorage = v1.ReplicatedStorage;
local StarterGui = v1.StarterGui;
local UserInputService = v1.UserInputService;
local Workspace = v1.Workspace;
local TestingFlags = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "testing", "TestingFlags").TestingFlags;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants");
local Player = v2.Player;
local PlayerGui = v2.PlayerGui;
local v3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ItemsNetwork");
local ItemsEvents = v3.ItemsEvents;
local ItemsFunctions = v3.ItemsFunctions;
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local Items = v4.Items;
local itemValueFor = v4.itemValueFor;
local ItemModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "items", "ItemModel").ItemModel;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local v5 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtCoat");
local DirtCoat = v5.DirtCoat;
local FINE_DIRT = v5.FINE_DIRT;
local v6 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "DirtTypes");
local dirtFor = v6.dirtFor;
local dirtForRarity = v6.dirtForRarity;
local TUTORIAL_DIRT_TOUGHNESS = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "tutorial", "TutorialConfig").TUTORIAL_DIRT_TOUGHNESS;
local u7 = {
    condition = "mint",
    oneIn = 150,
    isNew = true,
    kg = Items.goldStatue.averageKg,
    value = itemValueFor("goldStatue", "mint")
};
local u8 = setmetatable({}, {
    __tostring = function() -- Line: 55, Name: __tostring
        return "WorkbenchController";
    end
});
u8.__index = u8;

function u8.new(...) -- Line: 60
    -- upvalues: u8 (ref)
    local v9 = setmetatable({}, u8);

    return v9:constructor(...) or v9;
end;

function u8.constructor(p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20) -- Line: 64
    -- upvalues: Janitor (copy)
    p10.transition = p11;
    p10.sprayBottle = p12;
    p10.itemReveal = p13;
    p10.plot = p14;
    p10.crowd = p15;
    p10.cleanBar = p16;
    p10.tutorial = p17;
    p10.affordNotification = p18;
    p10.data = p19;
    p10.backpackVisibility = p20;
    p10.characterJanitor = Janitor.new();
    p10.cleaning = false;
    p10.finishing = false;
end;

function u8.onStart(u21) -- Line: 79
    -- upvalues: ItemsEvents (copy)
    u21.sprayBottle:onFinish(function() -- Line: 80
        -- upvalues: u21 (copy)
        return u21:onCleanFinished();
    end);
    u21.cleanBar:onExit(function() -- Line: 83
        -- upvalues: u21 (copy)
        return u21:cancelCleaning();
    end);
    ItemsEvents.instantCleaned:connect(function(p22) -- Line: 86
        -- upvalues: u21 (copy)
        return u21:onInstantCleaned(p22);
    end);
    task.spawn(function() -- Line: 89
        -- upvalues: u21 (copy)
        return u21:setup();
    end);
end;

function u8.isCleaning(p23) -- Line: 93
    return p23.cleaning;
end;

function u8.setup(u24) -- Line: 96
    -- upvalues: CollectionService (copy), Player (copy), TestingFlags (copy)
    local v25, u26 = u24.plot:awaitPlotNumber():await();

    if not v25 or u26 == nil then
        return nil;
    end;

    CollectionService:GetInstanceAddedSignal("Dirt"):Connect(function() -- Line: 101
        -- upvalues: u24 (copy)
        return u24:refreshPrompt();
    end);
    CollectionService:GetInstanceRemovedSignal("Dirt"):Connect(function() -- Line: 104
        -- upvalues: u24 (copy)
        return u24:refreshPrompt();
    end);
    u24:bindCharacter(Player.Character);
    Player.CharacterAdded:Connect(function(p27) -- Line: 108
        -- upvalues: u24 (copy)
        return u24:bindCharacter(p27);
    end);
    u24.plot:observePlots(function(p28, p29, p30) -- Line: 111
        -- upvalues: u26 (copy), u24 (copy)
        if p29 == u26 then
            u24:bindWorkbench(p28, p30);
        end;
    end);

    if TestingFlags.autoRevealGoldStatue then
        task.delay(5, function() -- Line: 117
            -- upvalues: u24 (copy)
            return u24:runRevealTest();
        end);
    end;
end;

function u8.bindWorkbench(u31, p32, p33) -- Line: 122
    local Workbench = p32:FindFirstChild("Workbench");
    local v34;

    if Workbench == nil then
        v34 = Workbench;
    else
        v34 = Workbench:FindFirstChild("TableTop");
    end;

    local v35;

    if Workbench == nil then
        v35 = Workbench;
    else
        v35 = Workbench:FindFirstChild("Attachment");

        if v35 ~= nil then
            v35 = v35:FindFirstChildWhichIsA("BillboardGui");
        end;
    end;

    local v36;

    if Workbench == nil then
        v36 = Workbench;
    else
        v36 = Workbench:IsA("Model");
    end;

    local v37 = not v36;

    if not v37 then
        local v38;

        if v34 == nil then
            v38 = v34;
        else
            v38 = v34:IsA("BasePart");
        end;

        v37 = not (v38 and v35);
    end;

    if v37 then
        return nil;
    end;

    u31.workbench = Workbench;
    u31.tableTop = v34;
    u31.billboard = v35;
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.ActionText = "Clean Item";
    ProximityPrompt.ObjectText = "Workbench";
    ProximityPrompt.HoldDuration = 0.5;
    ProximityPrompt.MaxActivationDistance = 10;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt:SetAttribute("Theme", "Workbench");
    ProximityPrompt.Enabled = false;
    ProximityPrompt.Parent = v34;
    u31.prompt = ProximityPrompt;
    p33:Add(ProximityPrompt, "Destroy");
    p33:Add(ProximityPrompt.Triggered:Connect(function() -- Line: 170
        -- upvalues: u31 (copy)
        return u31:onTriggered();
    end), "Disconnect");
    p33:Add(function() -- Line: 173
        -- upvalues: u31 (copy), ProximityPrompt (copy)
        if u31.prompt ~= ProximityPrompt then
            return nil;
        end;

        u31.prompt = nil;
        u31.workbench = nil;
        u31.tableTop = nil;
        u31.billboard = nil;
    end);
    u31:refreshPrompt();
end;

function u8.runRevealTest(u39) -- Line: 184
    -- upvalues: WFChain (copy), ReplicatedStorage (copy), Items (copy), u7 (copy)
    if u39.cleaning then
        return nil;
    end;

    local u40 = WFChain(ReplicatedStorage, "Assets", "Items", Items.goldStatue.displayName);
    local Handle = u40:FindFirstChild("Handle");

    if Handle ~= nil then
        Handle = Handle:IsA("BasePart");
    end;

    if not Handle then
        return nil;
    end;

    u39.cleaning = true;

    if u39.prompt then
        u39.prompt.Enabled = false;
    end;

    u39.transition:play(function() -- Line: 200
        -- upvalues: u39 (copy), u40 (copy), u7 (ref)
        return u39:enterCleaning(u40, "goldStatue", nil, u7);
    end, 0.5);
end;

function u8.onRender(p41) -- Line: 204
    local session = p41.session;

    if not session then
        return nil;
    end;

    for i in session.hiddenParts do
        if i.Parent then
            i.LocalTransparencyModifier = 1;
        end;
    end;
end;

function u8.bindCharacter(u42, p43) -- Line: 215
    if not p43 then
        return nil;
    end;

    u42.characterJanitor:Add(p43.ChildAdded:Connect(function() -- Line: 219
        -- upvalues: u42 (copy)
        return u42:refreshPrompt();
    end), "Disconnect", "childAdded");
    u42.characterJanitor:Add(p43.ChildRemoved:Connect(function() -- Line: 222
        -- upvalues: u42 (copy)
        return u42:refreshPrompt();
    end), "Disconnect", "childRemoved");
    u42:refreshPrompt();
end;

function u8.getHeldDirtyTool(p44) -- Line: 227
    -- upvalues: Player (copy), CollectionService (copy)
    local Character = Player.Character;

    if not Character then
        return nil;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and CollectionService:HasTag(child, "Dirt") then
            return child;
        end;
    end;

    return nil;
end;

function u8.refreshPrompt(u45) -- Line: 239
    if u45.cleaning then
        return nil;
    end;

    task.defer(function() -- Line: 243
        -- upvalues: u45 (copy)
        local prompt = u45.prompt;

        if u45.cleaning or not prompt then
            return nil;
        end;

        prompt.Enabled = u45:getHeldDirtyTool() ~= nil;
    end);
end;

function u8.onTriggered(u46) -- Line: 251
    if u46.cleaning then
        return nil;
    end;

    local prompt = u46.prompt;

    if not prompt then
        return nil;
    end;

    local u47 = u46:getHeldDirtyTool();

    if not u47 then
        return nil;
    end;

    local Handle = u47:FindFirstChild("Handle");

    if Handle ~= nil then
        Handle = Handle:IsA("BasePart");
    end;

    if not Handle then
        return nil;
    end;

    if not u46.tutorial:canClean() then
        u46.tutorial:notifyFollowTutorial();

        return nil;
    end;

    u46.cleaning = true;
    prompt.Enabled = false;
    local u48 = u47:GetAttribute("itemId");
    local u49 = u47:GetAttribute("inventoryId");
    u46.transition:play(function() -- Line: 278
        -- upvalues: u46 (copy), u47 (copy), u48 (copy), u49 (copy)
        return u46:enterCleaning(u47, u48, u49);
    end, 0.5);
end;

function u8.enterCleaning(u50, p51, p52, p53, p54) -- Line: 282
    -- upvalues: Player (copy), PlayerGui (copy), StarterGui (copy), ItemModel (copy), DirtCoat (copy), Workspace (copy), dirtFor (copy), dirtForRarity (copy), FINE_DIRT (copy), Janitor (copy), RuntimeLib (copy), ItemsFunctions (copy), TUTORIAL_DIRT_TOUGHNESS (copy)
    local workbench = u50.workbench;
    local tableTop = u50.tableTop;
    local billboard = u50.billboard;

    if not (workbench and (tableTop and billboard)) then
        u50.cleaning = false;
        u50:refreshPrompt();

        return nil;
    end;

    local Character = Player.Character;
    local v55;

    if Character == nil then
        v55 = Character;
    else
        v55 = Character:FindFirstChildOfClass("Humanoid");
    end;

    local HUD = PlayerGui:WaitForChild("HUD");
    local Enabled = HUD.Enabled;
    HUD.Enabled = false;
    local u56 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack);
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
    u50.backpackVisibility:setHidden("cleaning", true);
    local Enabled2 = billboard.Enabled;
    billboard.Enabled = false;
    u50.crowd:setHidden(true);

    local function v57() -- Line: 306
        -- upvalues: HUD (copy), Enabled (copy), StarterGui (ref), u56 (copy), u50 (copy), billboard (copy), Enabled2 (copy)
        HUD.Enabled = Enabled;
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, u56);
        u50.backpackVisibility:setHidden("cleaning", false);

        if billboard.Parent then
            billboard.Enabled = Enabled2;
        end;
    end;

    local u58 = ItemModel.toModel(p51);

    if v55 ~= nil then
        v55:UnequipTools();
    end;

    if not u58 then
        HUD.Enabled = Enabled;
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, u56);
        u50.backpackVisibility:setHidden("cleaning", false);

        if billboard.Parent then
            billboard.Enabled = Enabled2;
        end;

        u50.crowd:setHidden(false);
        u50.cleaning = false;
        u50:refreshPrompt();

        return nil;
    end;

    if p52 ~= nil then
        ItemModel.applyDisplayRotation(u58, p52);
    end;

    DirtCoat.uncoat(u58);

    for _, descendant in u58:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanQuery = true;
        end;
    end;

    u58.Parent = Workspace;
    local v59;

    if p52 == nil then
        v59 = dirtForRarity("common");
    else
        v59 = dirtFor(p52);
    end;

    local u60;

    if p53 == nil then
        u60 = nil;
    else
        u60 = u50:storedMask(p53);
    end;

    if not p54 then
        local v61 = table.clone(FINE_DIRT);
        setmetatable(v61, nil);
        v61.coverUnderside = false;
        v61.color = v59.color;
        v61.colorJitter = v59.colorJitter;
        v61.material = v59.material;

        function v61.onComplete() -- Line: 346
            -- upvalues: u50 (copy), u58 (copy), u60 (copy)
            return u50.sprayBottle:primeDirt(u58, u60);
        end;

        DirtCoat.coat(u58, v61);
    end;

    local _, v62 = u58:GetBoundingBox();
    local Position = tableTop.Position;
    local v63 = Vector3.new(Position.X, Position.Y + tableTop.Size.Y / 2 + 0.5 + v62.Y / 2, Position.Z);
    local v64 = u50:getBenchFront(workbench, tableTop, Character);
    u58:PivotTo(CFrame.lookAt(v63, v63 + v64));
    local v65 = Janitor.new();
    v65:Add(u58, "Destroy");
    local v66;

    if p54 then
        v66 = RuntimeLib.Promise.resolve(p54);
    elseif p53 == nil then
        v66 = RuntimeLib.Promise.resolve(nil);
    else
        v66 = ItemsFunctions.beginCleaning:invoke(p53):catch(function() -- Line: 359
            return nil;
        end);
    end;

    local v67 = {};
    local v68 = {
        janitor = v65,
        hiddenParts = v67,
        restoreGui = v57,
        itemId = p52,
        inventoryId = p53,
        item = u58,
        result = v66,
        savedMask = u60
    };
    u50.session = v68;
    u50:startProgressSaves(v68);
    u50.affordNotification:setBusy("clean", true);
    u50:hideWorldBillboards(v65);
    u50:hideCharacters(v65, v67);

    if u50.tutorial:isActive() then
        u50.cleanBar:setButtonsHidden(true);
    end;

    local sprayBottle = u50.sprayBottle;
    local v69;

    if u50.tutorial:isActive() then
        v69 = TUTORIAL_DIRT_TOUGHNESS;
    else
        v69 = v59.toughness;
    end;

    sprayBottle:beginSession(u58, v69);

    if p54 then
        task.delay(0.3, function() -- Line: 383
            -- upvalues: u50 (copy)
            return u50.sprayBottle:forceFinish();
        end);
    end;
end;

function u8.storedMask(p70, u71) -- Line: 388
    local v72 = p70.data:getDataIfLoaded();

    if v72 ~= nil then
        local function _(p73) -- Line: 393
            -- upvalues: u71 (copy)
            return p73.uid == u71;
        end;

        v72 = nil;

        for i, v in v72.Inventory do
            local _ = i - 1;

            if v.uid == u71 == true then
                v72 = v;
                break;
            end;
        end;

        if v72 ~= nil then
            v72 = v72.dirtMask;
        end;
    end;

    return v72;
end;

function u8.startProgressSaves(u74, u75) -- Line: 411
    if u75.inventoryId == nil then
        return nil;
    end;

    task.spawn(function() -- Line: 415
        -- upvalues: u74 (copy), u75 (copy)
        while u74.session == u75 do
            task.wait(3);
            u74:saveProgress(u75);
        end;
    end);
end;

function u8.saveProgress(p76, p77) -- Line: 422
    -- upvalues: ItemsEvents (copy)
    local inventoryId = p77.inventoryId;

    if p76.session ~= p77 or (p76.finishing or inventoryId == nil) then
        return nil;
    end;

    local v78 = p76.sprayBottle:currentMask();

    if v78 == nil or v78 == p77.savedMask then
        return nil;
    end;

    p77.savedMask = v78;
    ItemsEvents.saveCleanProgress:fire(inventoryId, v78);
end;

function u8.onCleanFinished(u79) -- Line: 434
    -- upvalues: RuntimeLib (copy), ItemsEvents (copy)
    local session = u79.session;

    if not session or u79.finishing then
        return nil;
    end;

    u79.finishing = true;
    task.spawn(RuntimeLib.async(function() -- Line: 440
        -- upvalues: session (copy), RuntimeLib (ref), ItemsEvents (ref), u79 (copy)
        local itemId = session.itemId;
        local inventoryId = session.inventoryId;
        local v80 = RuntimeLib.await(session.result);

        if inventoryId ~= nil then
            ItemsEvents.finishCleaning:fire(inventoryId);
        end;

        if itemId ~= nil and v80 then
            RuntimeLib.await(u79.itemReveal:play(itemId, v80, session.item));
        end;

        u79.transition:play(function() -- Line: 450
            -- upvalues: u79 (ref)
            u79.itemReveal:dismiss();
            u79:endCleaning();
            u79.tutorial:onRevealEnded();
        end);
    end));
end;

function u8.cancelCleaning(u81) -- Line: 457
    -- upvalues: ItemsEvents (copy)
    if not u81.session or u81.finishing then
        return nil;
    end;

    u81:saveProgress(u81.session);
    u81.finishing = true;
    local inventoryId = u81.session.inventoryId;

    if inventoryId ~= nil then
        ItemsEvents.cancelCleaning:fire(inventoryId);
    end;

    u81.transition:play(function() -- Line: 467
        -- upvalues: u81 (copy)
        return u81:endCleaning();
    end, 0.5);
end;

function u8.onInstantCleaned(u82, p83) -- Line: 471
    -- upvalues: RuntimeLib (copy)
    local session = u82.session;

    if not session or (session.inventoryId ~= p83 or u82.finishing) then
        return nil;
    end;

    u82.finishing = true;
    task.spawn(RuntimeLib.async(function() -- Line: 477
        -- upvalues: u82 (copy), RuntimeLib (ref), session (copy)
        u82.sprayBottle:halt();
        u82.sprayBottle:popAllDirt();
        RuntimeLib.await(RuntimeLib.Promise.delay(0.45));
        local itemId = session.itemId;
        local v84 = itemId ~= nil and RuntimeLib.await(session.result);

        if v84 then
            RuntimeLib.await(u82.itemReveal:play(itemId, v84, session.item));
        end;

        u82.transition:play(function() -- Line: 488
            -- upvalues: u82 (ref)
            u82.itemReveal:dismiss();
            u82:endCleaning();
            u82.tutorial:onRevealEnded();
        end);
    end));
end;

function u8.endCleaning(p85) -- Line: 495
    -- upvalues: Workspace (copy), UserInputService (copy)
    local session = p85.session;

    if not session then
        return nil;
    end;

    p85.session = nil;
    p85.cleanBar:setButtonsHidden(false);
    p85.sprayBottle:endSession();
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
    end;

    UserInputService.MouseIconEnabled = true;
    session.restoreGui();
    p85.crowd:setHidden(false);
    session.janitor:Destroy();
    p85.cleaning = false;
    p85.finishing = false;
    p85.affordNotification:setBusy("clean", false);
    p85:refreshPrompt();
end;

function u8.getBenchFront(p86, p87, p88, p89) -- Line: 516
    local LookVector = p87:GetPivot().LookVector;
    local v90 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local v91 = v90.Magnitude < 0.01 and Vector3.new(0, 0, 1) or v90.Unit;

    if p89 ~= nil then
        p89 = p89:GetPivot().Position;
    end;

    if p89 then
        p89 = v91:Dot(p89 - p88.Position) < 0;
    end;

    if p89 then
        v91 = v91 * -1;
    end;

    return v91;
end;

function u8.hideWorldBillboards(p92, u93) -- Line: 536
    -- upvalues: Players (copy), Workspace (copy)
    local function u95(p94) -- Line: 537
        -- upvalues: Players (ref)
        for _, v in Players:GetPlayers() do
            local Character = v.Character;

            if Character and p94:IsDescendantOf(Character) then
                return true;
            end;
        end;

        return false;
    end;

    local function v97(u96) -- Line: 546
        -- upvalues: u95 (copy), u93 (copy)
        if not u96:IsA("BillboardGui") or (not u96.Enabled or u95(u96)) then
            return nil;
        end;

        u96.Enabled = false;
        u93:Add(function() -- Line: 551
            -- upvalues: u96 (copy)
            if u96.Parent then
                u96.Enabled = true;
            end;
        end, true);
    end;

    for _, descendant in Workspace:GetDescendants() do
        v97(descendant);
    end;

    u93:Add(Workspace.DescendantAdded:Connect(v97), "Disconnect");
end;

function u8.hideCharacters(p98, u99, u100) -- Line: 562
    -- upvalues: Players (copy)
    local function u102(u101) -- Line: 563
        -- upvalues: u100 (copy), u99 (copy)
        if not u101:IsA("BasePart") then
            if u101:IsA("Decal") or u101:IsA("Texture") then
                local Transparency = u101.Transparency;
                u101.Transparency = 1;
                u99:Add(function() -- Line: 585
                    -- upvalues: u101 (copy), Transparency (copy)
                    u101.Transparency = Transparency;

                    return u101.Transparency;
                end, true);

                return;
            end;

            if not (u101:IsA("BillboardGui") or u101:IsA("SurfaceGui")) then
                if u101:IsA("ParticleEmitter") or (u101:IsA("Trail") or (u101:IsA("Beam") or (u101:IsA("Fire") or (u101:IsA("Smoke") or (u101:IsA("Sparkles") or u101:IsA("Light")))))) then
                    local Enabled = u101.Enabled;
                    u101.Enabled = false;
                    u99:Add(function() -- Line: 599
                        -- upvalues: u101 (copy), Enabled (copy)
                        u101.Enabled = Enabled;

                        return u101.Enabled;
                    end, true);
                end;

                return;
            end;

            local Enabled = u101.Enabled;
            u101.Enabled = false;
            u99:Add(function() -- Line: 592
                -- upvalues: u101 (copy), Enabled (copy)
                u101.Enabled = Enabled;

                return u101.Enabled;
            end, true);

            return;
        end;

        u100[u101] = true;
        local CanQuery = u101.CanQuery;
        local CanCollide = u101.CanCollide;
        local Anchored = u101.Anchored;
        u101.CanQuery = false;
        u101.CanCollide = false;
        u101.Anchored = true;
        u99:Add(function() -- Line: 574
            -- upvalues: u101 (copy), CanQuery (copy), CanCollide (copy), Anchored (copy)
            if not u101.Parent then
                return nil;
            end;

            u101.CanQuery = CanQuery;
            u101.CanCollide = CanCollide;
            u101.Anchored = Anchored;
        end, true);
    end;

    local function u104(p103) -- Line: 605
        -- upvalues: u102 (copy), u99 (copy)
        for _, descendant in p103:GetDescendants() do
            u102(descendant);
        end;

        u99:Add(p103.DescendantAdded:Connect(u102), "Disconnect");
    end;

    for _, v in Players:GetPlayers() do
        if v.Character then
            u104(v.Character);
        end;

        u99:Add(v.CharacterAdded:Connect(u104), "Disconnect");
    end;

    u99:Add(Players.PlayerAdded:Connect(function(p105) -- Line: 617
        -- upvalues: u99 (copy), u104 (copy)
        u99:Add(p105.CharacterAdded:Connect(u104), "Disconnect");

        if p105.Character then
            u104(p105.Character);
        end;
    end), "Disconnect");
    u99:Add(function() -- Line: 623
        -- upvalues: u100 (copy)
        for i in u100 do
            if i.Parent then
                i.LocalTransparencyModifier = 0;
            end;
        end;
    end, true);
end;

Reflect.defineMetadata(u8, "identifier", "client/controllers/world/WorkbenchController@WorkbenchController");
Reflect.defineMetadata(u8, "flamework:parameters", { "client/controllers/world/TransitionController@TransitionController", "client/controllers/world/SprayBottleController@SprayBottleController", "client/controllers/world/ItemRevealController@ItemRevealController", "client/controllers/plot/PlotController@PlotController", "client/controllers/npc/CrowdController@CrowdController", "client/controllers/world/CleanBarController@CleanBarController", "client/controllers/tutorial/TutorialController@TutorialController", "client/controllers/ui/AffordNotificationController@AffordNotificationController", "client/controllers/data/DataController@DataController", "client/controllers/ui/BackpackVisibilityController@BackpackVisibilityController" });
Reflect.defineMetadata(u8, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" });
Reflect.decorate(u8, "$:flamework@Controller", Controller, { {} });

return {
    WorkbenchController = u8
};