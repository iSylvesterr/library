-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ContentProvider = v1.ContentProvider;
local Players = v1.Players;
local ReplicatedStorage = v1.ReplicatedStorage;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "DetectorNetwork");
local DetectorEvents = v2.DetectorEvents;
local DetectorFunctions = v2.DetectorFunctions;
local FirstPersonGear = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "character", "FirstPersonGear").FirstPersonGear;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors");
local Detectors = v3.Detectors;
local NO_DETECTOR = v3.NO_DETECTOR;
local isDetectorId = v3.isDetectorId;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u4 = CFrame.new(
    0.2539093,
    -0.3508163,
    -1.3844943,
    0.801367402,
    0.598132014,
    0.00691708736,
    -0.306664646,
    0.420737624,
    -0.853777885,
    -0.51358217,
    0.682068706,
    0.520591378
);
local u5 = setmetatable({}, {
    __tostring = function() -- Line: 25, Name: __tostring
        return "DetectorController";
    end
});
u5.__index = u5;

function u5.new(...) -- Line: 30
    -- upvalues: u5 (ref)
    local v6 = setmetatable({}, u5);

    return v6:constructor(...) or v6;
end;

function u5.constructor(p7, p8, p9) -- Line: 34
    -- upvalues: Players (copy)
    p7.data = p8;
    p7.shovel = p9;
    p7.localPlayer = Players.LocalPlayer;
    p7.rigs = {};
    p7.serverHeld = {};
    p7.detectorIds = {};
    p7.buildTokens = {};
    p7.digging = false;
end;

function u5.onStart(u10) -- Line: 44
    -- upvalues: DetectorEvents (copy), Players (copy), DetectorFunctions (copy)
    u10:preloadAnimations();
    DetectorEvents.DetectorStateChanged:connect(function(p11, p12) -- Line: 46
        -- upvalues: u10 (copy)
        return u10:onRemoteState(p11, p12);
    end);
    DetectorEvents.DetectorChanged:connect(function(p13, p14) -- Line: 49
        -- upvalues: u10 (copy)
        return u10:onRemoteDetectorChanged(p13, p14);
    end);

    for _, v in Players:GetPlayers() do
        u10:onPlayerAdded(v);
    end;

    Players.PlayerAdded:Connect(function(p15) -- Line: 55
        -- upvalues: u10 (copy)
        return u10:onPlayerAdded(p15);
    end);
    Players.PlayerRemoving:Connect(function(p16) -- Line: 58
        -- upvalues: u10 (copy)
        u10:destroyRig(p16);
        u10.detectorIds[p16.UserId] = nil;
        u10.buildTokens[p16] = nil;
    end);
    task.spawn(function() -- Line: 67
        -- upvalues: DetectorFunctions (ref), u10 (copy), Players (ref)
        for _, v in DetectorFunctions.GetDetectorStates:invoke():expect() do
            if v.held then
                u10.serverHeld[v.userId] = true;
            end;

            u10.detectorIds[v.userId] = v.detectorId;
        end;

        for _, v in Players:GetPlayers() do
            if v ~= u10.localPlayer then
                local v17 = u10.rigs[v];

                if v17 and v17.def == u10:definitionFor(u10:detectorIdFor(v)) then
                    local v18 = u10.serverHeld[v.UserId] ~= nil;

                    if v17.held ~= v18 then
                        u10:setHeld(v17, v18);
                    end;
                else
                    u10:rebuildRig(v);
                end;
            end;
        end;
    end);
end;

function u5.onDataChanged(p19, p20) -- Line: 98
    if table.find(p20, "EquippedDetector") == nil then
        return nil;
    end;

    local localRig = p19.localRig;

    if localRig ~= nil then
        localRig = localRig.def;
    end;

    if localRig == p19:definitionFor(p19:getLocalDetectorId()) then
        return nil;
    end;

    p19:rebuildRig(p19.localPlayer);
end;

function u5.onRender(p21) -- Line: 111
    p21:evaluateLocalHold();
end;

function u5.setDigging(p22, p23) -- Line: 114
    if p22.digging == p23 then
        return nil;
    end;

    p22.digging = p23;
    p22:evaluateLocalHold();
end;

function u5.isLocalHeld(p24) -- Line: 121
    local localRig = p24.localRig;

    if localRig ~= nil then
        localRig = localRig.held;
    end;

    return localRig == true;
end;

function u5.isDigging(p25) -- Line: 128
    return p25.digging;
end;

function u5.getLocalCoil(p26) -- Line: 131
    local localRig = p26.localRig;

    if localRig ~= nil then
        localRig = localRig.coil;
    end;

    return localRig;
end;

function u5.getLocalGearParts(p27) -- Line: 138
    local localRig = p27.localRig;

    if localRig ~= nil then
        localRig = localRig.parts;
    end;

    return localRig;
end;

function u5.getLocalDefinition(p28) -- Line: 145
    local localRig = p28.localRig;

    if localRig ~= nil then
        localRig = localRig.def;
    end;

    return localRig;
end;

function u5.definitionFor(p29, p30) -- Line: 152
    -- upvalues: isDetectorId (copy), Detectors (copy)
    if isDetectorId(p30) then
        return Detectors[p30];
    end;

    return nil;
end;

function u5.getLocalDetectorId(p31) -- Line: 155
    -- upvalues: NO_DETECTOR (copy)
    local v32 = p31.data:getDataIfLoaded();

    if v32 ~= nil then
        v32 = v32.EquippedDetector;
    end;

    if v32 == nil then
        v32 = NO_DETECTOR;
    end;

    return v32;
end;

function u5.detectorIdFor(p33, p34) -- Line: 166
    -- upvalues: NO_DETECTOR (copy)
    if p34 == p33.localPlayer then
        return p33.data:getData().EquippedDetector;
    end;

    local v35 = p33.detectorIds[p34.UserId];

    if v35 == nil then
        v35 = NO_DETECTOR;
    end;

    return v35;
end;

function u5.evaluateLocalHold(p36) -- Line: 181
    -- upvalues: DetectorEvents (copy)
    local localRig = p36.localRig;

    if not localRig then
        p36.shovel:setDetectorHeld(false);

        return nil;
    end;

    local v37 = not p36.digging and p36.shovel:canHoldGear();

    if localRig.held ~= v37 then
        p36:setHeld(localRig, v37);
        DetectorEvents.SetDetectorHeld:fire(v37);
    end;

    p36.shovel:setDetectorHeld(v37);
end;

function u5.preloadAnimations(p38) -- Line: 194
    -- upvalues: Detectors (copy), ContentProvider (copy)
    local u39 = {};

    for _, v in pairs(Detectors) do
        local Animation = Instance.new("Animation");
        Animation.AnimationId = v.holdAnimationId;
        table.insert(u39, Animation);
    end;

    task.spawn(function() -- Line: 201
        -- upvalues: ContentProvider (ref), u39 (copy)
        ContentProvider:PreloadAsync(u39);

        for _, v in u39 do
            v:Destroy();
        end;
    end);
end;

function u5.onRemoteDetectorChanged(p40, p41, p42) -- Line: 208
    -- upvalues: Players (copy)
    p40.detectorIds[p41] = p42;

    if p41 == p40.localPlayer.UserId then
        return nil;
    end;

    local v43 = Players:GetPlayerByUserId(p41);
    local v44;

    if v43 then
        local v45 = p40.rigs[v43];

        if v45 ~= nil then
            v45 = v45.def;
        end;

        v44 = v45 ~= p40:definitionFor(p42);
    else
        v44 = v43;
    end;

    if v44 then
        p40:rebuildRig(v43);
    end;
end;

function u5.onRemoteState(p46, p47, p48) -- Line: 229
    -- upvalues: Players (copy)
    if p47 == p46.localPlayer.UserId then
        return nil;
    end;

    if p48 then
        p46.serverHeld[p47] = true;
    else
        p46.serverHeld[p47] = nil;
    end;

    local v49 = Players:GetPlayerByUserId(p47);

    if not v49 then
        return nil;
    end;

    local v50 = p46.rigs[v49];

    if v50 and v50.held ~= p48 then
        p46:setHeld(v50, p48);
    end;
end;

function u5.onPlayerAdded(u51, u52) -- Line: 251
    if u52.Character then
        task.spawn(function() -- Line: 253
            -- upvalues: u51 (copy), u52 (copy)
            return u51:buildRig(u52, u52.Character);
        end);
    end;

    u52.CharacterAdded:Connect(function(p53) -- Line: 257
        -- upvalues: u51 (copy), u52 (copy)
        return u51:buildRig(u52, p53);
    end);
    u52.CharacterRemoving:Connect(function() -- Line: 260
        -- upvalues: u51 (copy), u52 (copy)
        return u51:destroyRig(u52);
    end);
end;

function u5.rebuildRig(u54, u55) -- Line: 264
    local Character = u55.Character;

    if Character then
        task.spawn(function() -- Line: 267
            -- upvalues: u54 (copy), u55 (copy), Character (copy)
            return u54:buildRig(u55, Character);
        end);
    end;
end;

function u5.buildRig(p56, p57, p58) -- Line: 272
    -- upvalues: WFChain (copy), ReplicatedStorage (copy), u4 (copy), FirstPersonGear (copy)
    p56:destroyRig(p57);
    local v59 = p56.buildTokens[p57];
    local v60 = (v59 == nil and 0 or v59) + 1;
    p56.buildTokens[p57] = v60;
    local v61 = p56:definitionFor(p56:detectorIdFor(p57));

    if not v61 then
        return nil;
    end;

    local Humanoid = p58:WaitForChild("Humanoid", 10);
    local HumanoidRootPart = p58:WaitForChild("HumanoidRootPart", 10);
    local UpperTorso = p58:WaitForChild("UpperTorso", 10);
    local RightHand = p58:WaitForChild("RightHand", 10);

    if not (Humanoid and (HumanoidRootPart and (UpperTorso and RightHand))) then
        return nil;
    end;

    if p57.Character ~= p58 or p56.buildTokens[p57] ~= v60 then
        return nil;
    end;

    local v62 = WFChain(ReplicatedStorage, "Assets", "Detectors", v61.assetName):Clone();
    local v63 = {};
    local v64 = nil;

    for _, descendant in v62:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.Massless = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            table.insert(v63, descendant);

            if v64 == nil then
                v64 = descendant;
            end;
        end;
    end;

    if v64 == nil then
        v62:Destroy();

        return nil;
    end;

    local v65 = v62:GetPivot():ToObjectSpace(v64.CFrame);
    local v66 = CFrame.new(v61.gripNudge) * u4:ToObjectSpace(v61.equippedPivotC0 * v65);

    for _, descendant in v62:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= v64 then
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v64;
            WeldConstraint.Part1 = descendant;
            WeldConstraint.Parent = v64;
        end;
    end;

    if p57.Character ~= p58 or p56.buildTokens[p57] ~= v60 then
        v62:Destroy();

        return nil;
    end;

    v62.Name = v61.assetName;
    local v67 = FirstPersonGear.attach(v62, p58);
    local v68 = nil;

    if p57 == p56.localPlayer then
        local Animator = Humanoid:WaitForChild("Animator", 10);

        if Animator then
            v68 = p56:loadLoopTrack(Animator, v61.holdAnimationId);
        end;
    end;

    local v69 = {
        held = false,
        def = v61,
        holder = v67,
        root = v64,
        parts = v63,
        coil = p56:findCoil(v62) or v64,
        rootRelPivot = v65,
        gripC0 = v66,
        hrp = HumanoidRootPart,
        upperTorso = UpperTorso,
        rightHand = RightHand,
        track = v68
    };
    p56.rigs[p57] = v69;

    if p57 ~= p56.localPlayer then
        p56:setHeld(v69, p56.serverHeld[p57.UserId] ~= nil);

        return;
    end;

    p56.localRig = v69;
    p56:setHeld(v69, false);
    p56:evaluateLocalHold();
end;

function u5.findCoil(p70, p71) -- Line: 386
    local Coil = p71:FindFirstChild("Coil");

    if not Coil then
        return nil;
    end;

    local v72 = 0;
    local v73 = nil;

    for _, descendant in Coil:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v74 = descendant.Size.X * descendant.Size.Y * descendant.Size.Z;

            if v74 > v72 then
                v73 = descendant;
                v72 = v74;
            end;
        end;
    end;

    return v73;
end;

function u5.loadLoopTrack(p75, p76, p77) -- Line: 406
    local Animation = Instance.new("Animation");
    Animation.AnimationId = p77;
    local v78 = p76:LoadAnimation(Animation);
    v78.Priority = Enum.AnimationPriority.Action;
    v78.Looped = true;
    Animation:Destroy();

    return v78;
end;

function u5.setHeld(p79, p80, p81) -- Line: 415
    p80.held = p81;

    if p81 then
        p79:weldTo(p80, p80.rightHand, p80.gripC0);
        local track = p80.track;

        if track ~= nil then
            track:Play(0.05);
        end;
    else
        p79:weldTo(p80, p80.upperTorso, p80.def.sidePivotC0 * p80.rootRelPivot);
        local track = p80.track;

        if track ~= nil then
            track:Stop(0.05);
        end;
    end;
end;

function u5.weldTo(p82, p83, p84, p85) -- Line: 436
    local weld = p83.weld;

    if weld ~= nil then
        weld:Destroy();
    end;

    local Weld = Instance.new("Weld");
    Weld.Part0 = p84;
    Weld.Part1 = p83.root;
    Weld.C0 = p85;
    Weld.Parent = p83.root;
    p83.weld = Weld;
end;

function u5.destroyRig(p86, p87) -- Line: 448
    -- upvalues: DetectorEvents (copy)
    local v88 = p86.rigs[p87];

    if not v88 then
        return nil;
    end;

    if v88 == p86.localRig and v88.held then
        DetectorEvents.SetDetectorHeld:fire(false);
    end;

    local track = v88.track;

    if track ~= nil then
        track:Stop();
    end;

    local track2 = v88.track;

    if track2 ~= nil then
        track2:Destroy();
    end;

    v88.holder:Destroy();
    p86.rigs[p87] = nil;

    if v88 == p86.localRig then
        p86.localRig = nil;
        p86.shovel:setDetectorHeld(false);
    end;
end;

Reflect.defineMetadata(u5, "identifier", "client/controllers/world/DetectorController@DetectorController");
Reflect.defineMetadata(u5, "flamework:parameters", { "client/controllers/data/DataController@DataController", "client/controllers/world/ShovelController@ShovelController" });
Reflect.defineMetadata(u5, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u5, "$:flamework@Controller", Controller, { {} });

return {
    DetectorController = u5
};