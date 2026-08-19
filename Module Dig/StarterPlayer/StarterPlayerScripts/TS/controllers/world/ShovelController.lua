-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ContentProvider = v1.ContentProvider;
local Players = v1.Players;
local ReplicatedStorage = v1.ReplicatedStorage;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ShovelNetwork");
local ShovelEvents = v2.ShovelEvents;
local ShovelFunctions = v2.ShovelFunctions;
local FirstPersonGear = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "character", "FirstPersonGear").FirstPersonGear;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels");
local DEFAULT_SHOVEL_ID = v3.DEFAULT_SHOVEL_ID;
local Shovels = v3.Shovels;
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands");
local ISLAND_ID_ATTRIBUTE = v4.ISLAND_ID_ATTRIBUTE;
local isIslandId = v4.isIslandId;
local isIslandUnlocked = v4.isIslandUnlocked;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local digZoneAt = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DigZoneSpawn").digZoneAt;
local u5 = CFrame.new(
    1.567095399,
    0.167916089,
    -1.138629794,
    -0.26422587,
    -0.145200476,
    0.953467906,
    0.962038577,
    -0.109694287,
    0.249896064,
    0.06830465,
    0.983302116,
    0.168672562
);
local u6 = setmetatable({}, {
    __tostring = function() -- Line: 31, Name: __tostring
        return "ShovelController";
    end
});
u6.__index = u6;

function u6.new(...) -- Line: 36
    -- upvalues: u6 (ref)
    local v7 = setmetatable({}, u6);

    return v7:constructor(...) or v7;
end;

function u6.constructor(p8, p9) -- Line: 40
    -- upvalues: Players (copy)
    p8.data = p9;
    p8.localPlayer = Players.LocalPlayer;
    p8.rigs = {};
    p8.serverEquipped = {};
    p8.shovelIds = {};
    p8.buildTokens = {};
    p8.digHitListeners = {};
    p8.throwDirtListeners = {};
    p8.digging = false;
    p8.detectorHeld = false;
end;

function u6.onStart(u10) -- Line: 52
    -- upvalues: ShovelEvents (copy), Players (copy), ShovelFunctions (copy), DEFAULT_SHOVEL_ID (copy), Shovels (copy)
    u10:preloadAnimations();
    ShovelEvents.ShovelStateChanged:connect(function(p11, p12) -- Line: 54
        -- upvalues: u10 (copy)
        return u10:onRemoteState(p11, p12);
    end);
    ShovelEvents.ShovelChanged:connect(function(p13, p14) -- Line: 57
        -- upvalues: u10 (copy)
        return u10:onRemoteShovelChanged(p13, p14);
    end);

    for _, v in Players:GetPlayers() do
        u10:onPlayerAdded(v);
    end;

    Players.PlayerAdded:Connect(function(p15) -- Line: 63
        -- upvalues: u10 (copy)
        return u10:onPlayerAdded(p15);
    end);
    Players.PlayerRemoving:Connect(function(p16) -- Line: 66
        -- upvalues: u10 (copy)
        u10:destroyRig(p16);
        u10.shovelIds[p16.UserId] = nil;
        u10.buildTokens[p16] = nil;
    end);
    task.spawn(function() -- Line: 75
        -- upvalues: ShovelFunctions (ref), u10 (copy), DEFAULT_SHOVEL_ID (ref), Shovels (ref)
        for _, v in ShovelFunctions.GetShovelStates:invoke():expect() do
            if v.equipped then
                u10.serverEquipped[v.userId] = true;
            end;

            u10.shovelIds[v.userId] = v.shovelId;
        end;

        for i, v in u10.rigs do
            if i ~= u10.localPlayer then
                local v17 = u10.shovelIds[i.UserId];

                if v17 == nil then
                    v17 = DEFAULT_SHOVEL_ID;
                end;

                if v.def == Shovels[v17] then
                    local v18 = u10.serverEquipped[i.UserId] ~= nil;

                    if v.equipped ~= v18 then
                        u10:setEquipped(v, v18);
                    end;
                else
                    u10:rebuildRig(i);
                end;
            end;
        end;
    end);
end;

function u6.onDataChanged(p19, p20) -- Line: 112
    -- upvalues: Shovels (copy)
    if table.find(p20, "EquippedShovel") == nil then
        return nil;
    end;

    local localRig = p19.localRig;

    if localRig and localRig.def == Shovels[p19:getLocalShovelId()] then
        return nil;
    end;

    p19:rebuildRig(p19.localPlayer);
end;

function u6.getLocalShovelId(p21) -- Line: 122
    -- upvalues: DEFAULT_SHOVEL_ID (copy)
    local v22 = p21.data:getDataIfLoaded();

    if v22 ~= nil then
        v22 = v22.EquippedShovel;
    end;

    if v22 == nil then
        v22 = DEFAULT_SHOVEL_ID;
    end;

    return v22;
end;

function u6.onRemoteShovelChanged(p23, p24, p25) -- Line: 133
    -- upvalues: Players (copy), Shovels (copy)
    p23.shovelIds[p24] = p25;

    if p24 == p23.localPlayer.UserId then
        return nil;
    end;

    local v26 = Players:GetPlayerByUserId(p24);
    local v27;

    if v26 then
        local v28 = p23.rigs[v26];

        if v28 ~= nil then
            v28 = v28.def;
        end;

        v27 = v28 ~= Shovels[p25];
    else
        v27 = v26;
    end;

    if v27 then
        p23:rebuildRig(v26);
    end;
end;

function u6.rebuildRig(u29, u30) -- Line: 154
    local Character = u30.Character;

    if Character then
        task.spawn(function() -- Line: 157
            -- upvalues: u29 (copy), u30 (copy), Character (copy)
            return u29:buildRig(u30, Character);
        end);
    end;
end;

function u6.onRender(p31) -- Line: 162
    p31:evaluateLocalZone();
end;

function u6.preloadAnimations(p32) -- Line: 165
    -- upvalues: Shovels (copy), ContentProvider (copy)
    local u33 = {};

    for _, v in pairs(Shovels) do
        for _, v5 in { v.holdAnimationId, v.digAnimationId } do
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v5;
            table.insert(u33, Animation);
        end;
    end;

    task.spawn(function() -- Line: 174
        -- upvalues: ContentProvider (ref), u33 (copy)
        ContentProvider:PreloadAsync(u33);

        for _, v in u33 do
            v:Destroy();
        end;
    end);
end;

function u6.evaluateLocalZone(p34) -- Line: 181
    -- upvalues: ShovelEvents (copy)
    local localRig = p34.localRig;

    if not localRig then
        return nil;
    end;

    if p34.digging then
        return nil;
    end;

    local v35 = not p34.detectorHeld and p34:canHoldGear();

    if localRig.equipped == v35 then
        return nil;
    end;

    p34:setEquipped(localRig, v35);
    ShovelEvents.SetShovelEquipped:fire(v35);
end;

function u6.canHoldGear(p36) -- Line: 196
    local Character = p36.localPlayer.Character;
    local v37;

    if Character == nil then
        v37 = Character;
    else
        v37 = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v38 = not Character;

    if not v38 then
        local v39;

        if v37 == nil then
            v39 = v37;
        else
            v39 = v37:IsA("BasePart");
        end;

        v38 = not v39;
    end;

    if v38 then
        return false;
    end;

    local function _(p40) -- Line: 217
        local v41 = p40:IsA("Tool") and p40:GetAttribute("itemId") ~= nil;

        return v41;
    end;

    local v42 = false;

    for i, child in Character:GetChildren() do
        local _ = i - 1;
        local v43 = child:IsA("Tool") and child:GetAttribute("itemId") ~= nil;

        if v43 then
            v42 = true;
            break;
        end;
    end;

    local v44 = not v42 and p36:getZoneAt(v37.Position) ~= nil;

    return v44;
end;

function u6.setDetectorHeld(p45, p46) -- Line: 230
    if p45.detectorHeld == p46 then
        return nil;
    end;

    p45.detectorHeld = p46;
    p45:evaluateLocalZone();
end;

function u6.canDig(p47) -- Line: 237
    local v48;

    if p47.localRig == nil then
        v48 = false;
    else
        v48 = not p47.digging and p47:canHoldGear();
    end;

    return v48;
end;

function u6.isLocalEquipped(p49) -- Line: 240
    local localRig = p49.localRig;

    if localRig ~= nil then
        localRig = localRig.equipped;
    end;

    return localRig == true;
end;

function u6.getLocalGearParts(p50) -- Line: 247
    local localRig = p50.localRig;

    if localRig ~= nil then
        localRig = localRig.parts;
    end;

    return localRig;
end;

function u6.getZoneAt(p51, p52) -- Line: 254
    -- upvalues: digZoneAt (copy), ISLAND_ID_ATTRIBUTE (copy), isIslandId (copy), isIslandUnlocked (copy)
    local v53 = digZoneAt(p52);

    if v53 == nil then
        return nil;
    end;

    local v54 = v53:GetAttribute(ISLAND_ID_ATTRIBUTE);

    if not isIslandId(v54) then
        return nil;
    end;

    local v55 = p51.data:getDataIfLoaded();

    if v55 ~= nil then
        v55 = v55.UnlockedIslands;
    end;

    if isIslandUnlocked(v54, v55) then
        return v53;
    end;

    return nil;
end;

function u6.onRemoteState(p56, p57, p58) -- Line: 269
    -- upvalues: Players (copy)
    if p57 == p56.localPlayer.UserId then
        return nil;
    end;

    if p58 then
        p56.serverEquipped[p57] = true;
    else
        p56.serverEquipped[p57] = nil;
    end;

    local v59 = Players:GetPlayerByUserId(p57);

    if not v59 then
        return nil;
    end;

    local v60 = p56.rigs[v59];

    if v60 and v60.equipped ~= p58 then
        p56:setEquipped(v60, p58);
    end;
end;

function u6.onPlayerAdded(u61, u62) -- Line: 291
    if u62.Character then
        task.spawn(function() -- Line: 293
            -- upvalues: u61 (copy), u62 (copy)
            return u61:buildRig(u62, u62.Character);
        end);
    end;

    u62.CharacterAdded:Connect(function(p63) -- Line: 297
        -- upvalues: u61 (copy), u62 (copy)
        return u61:buildRig(u62, p63);
    end);
    u62.CharacterRemoving:Connect(function() -- Line: 300
        -- upvalues: u61 (copy), u62 (copy)
        return u61:destroyRig(u62);
    end);
end;

function u6.buildRig(u64, p65, p66) -- Line: 304
    -- upvalues: DEFAULT_SHOVEL_ID (copy), Shovels (copy), WFChain (copy), ReplicatedStorage (copy), u5 (copy), FirstPersonGear (copy)
    u64:destroyRig(p65);
    local v67 = u64.buildTokens[p65];
    local v68 = (v67 == nil and 0 or v67) + 1;
    u64.buildTokens[p65] = v68;
    local Humanoid = p66:WaitForChild("Humanoid", 10);
    local HumanoidRootPart = p66:WaitForChild("HumanoidRootPart", 10);
    local UpperTorso = p66:WaitForChild("UpperTorso", 10);
    local RightHand = p66:WaitForChild("RightHand", 10);

    if not (Humanoid and (HumanoidRootPart and (UpperTorso and RightHand))) then
        return nil;
    end;

    local v69;

    if p65 == u64.localPlayer then
        v69 = u64.data:getData().EquippedShovel;
    else
        v69 = u64.shovelIds[p65.UserId];

        if v69 == nil then
            v69 = DEFAULT_SHOVEL_ID;
        end;
    end;

    local v70 = Shovels[v69];

    if p65.Character ~= p66 or u64.buildTokens[p65] ~= v68 then
        return nil;
    end;

    local v71 = WFChain(ReplicatedStorage, "Assets", "Shovels", v70.assetName):Clone();
    local v72 = {};
    local v73 = nil;

    for _, descendant in v71:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.Massless = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            table.insert(v72, descendant);

            if v73 == nil then
                v73 = descendant;
            end;
        end;
    end;

    if v73 == nil then
        v71:Destroy();

        return nil;
    end;

    local v74 = v71:GetPivot():ToObjectSpace(v73.CFrame);
    local v75 = CFrame.new(v70.gripNudge) * u5:ToObjectSpace(v70.equippedPivotC0 * v74);

    for _, descendant in v71:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= v73 then
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v73;
            WeldConstraint.Part1 = descendant;
            WeldConstraint.Parent = v73;
        end;
    end;

    if p65.Character ~= p66 or u64.buildTokens[p65] ~= v68 then
        v71:Destroy();

        return nil;
    end;

    v71.Name = v70.assetName;
    local v76 = FirstPersonGear.attach(v71, p66);
    local v77 = nil;
    local v78 = nil;
    local v79 = {};

    if p65 == u64.localPlayer then
        local Animator = Humanoid:WaitForChild("Animator", 10);

        if Animator then
            v77 = u64:loadLoopTrack(Animator, v70.holdAnimationId);
            v78 = u64:loadLoopTrack(Animator, v70.digAnimationId);
            local v80 = v78:GetMarkerReachedSignal("DirtHit"):Connect(function() -- Line: 401
                -- upvalues: u64 (copy)
                return u64:emitMarker(u64.digHitListeners);
            end);
            local v81 = v78:GetMarkerReachedSignal("ThrowDirt"):Connect(function() -- Line: 404
                -- upvalues: u64 (copy)
                return u64:emitMarker(u64.throwDirtListeners);
            end);
            table.insert(v79, v80);
            table.insert(v79, v81);
        end;
    end;

    local v82 = {
        equipped = false,
        def = v70,
        holder = v76,
        root = v73,
        parts = v72,
        rootRelPivot = v74,
        gripC0 = v75,
        hrp = HumanoidRootPart,
        upperTorso = UpperTorso,
        rightHand = RightHand,
        track = v77,
        digTrack = v78,
        markerConnections = v79
    };
    u64.rigs[p65] = v82;

    if p65 ~= u64.localPlayer then
        u64:setEquipped(v82, u64.serverEquipped[p65.UserId] ~= nil);

        return;
    end;

    u64.localRig = v82;
    u64:setEquipped(v82, false);
    u64:evaluateLocalZone();
end;

function u6.loadLoopTrack(p83, p84, p85) -- Line: 442
    local Animation = Instance.new("Animation");
    Animation.AnimationId = p85;
    local v86 = p84:LoadAnimation(Animation);
    v86.Priority = Enum.AnimationPriority.Action;
    v86.Looped = true;
    Animation:Destroy();

    return v86;
end;

function u6.setEquipped(p87, p88, p89) -- Line: 451
    p88.equipped = p89;

    if p89 then
        p87:weldTo(p88, p88.rightHand, p88.gripC0);

        if p87.digging and p88 == p87.localRig then
            local digTrack = p88.digTrack;

            if digTrack ~= nil then
                digTrack:Play(0.05);
            end;
        else
            local track = p88.track;

            if track ~= nil then
                track:Play(0.05);
            end;
        end;
    else
        p87:weldTo(p88, p88.upperTorso, p88.def.backPivotC0 * p88.rootRelPivot);
        local track = p88.track;

        if track ~= nil then
            track:Stop(0.05);
        end;

        local digTrack = p88.digTrack;

        if digTrack ~= nil then
            digTrack:Stop(0.05);
        end;
    end;
end;

function u6.weldTo(p90, p91, p92, p93) -- Line: 483
    local weld = p91.weld;

    if weld ~= nil then
        weld:Destroy();
    end;

    local Weld = Instance.new("Weld");
    Weld.Part0 = p92;
    Weld.Part1 = p91.root;
    Weld.C0 = p93;
    Weld.Parent = p91.root;
    p91.weld = Weld;
end;

function u6.getLocalZone(p94) -- Line: 495
    local localRig = p94.localRig;

    if localRig then
        return p94:getZoneAt(localRig.hrp.Position);
    end;

    return nil;
end;

function u6.beginDigging(p95, p96) -- Line: 499
    -- upvalues: ShovelEvents (copy)
    if p96 == nil then
        p96 = false;
    end;

    local localRig = p95.localRig;

    if not localRig or p95.digging then
        return false;
    end;

    if not localRig.equipped then
        if not p95:canHoldGear() then
            return false;
        end;

        p95:setEquipped(localRig, true);
        ShovelEvents.SetShovelEquipped:fire(true);
    end;

    p95.digging = true;
    local track = localRig.track;

    if track ~= nil then
        track:Stop(0.05);
    end;

    local digTrack = localRig.digTrack;

    if digTrack ~= nil then
        digTrack:Play(0.05, 1, 1);
    end;

    if p96 then
        local digTrack2 = localRig.digTrack;

        if digTrack2 ~= nil then
            digTrack2:AdjustSpeed(0);
        end;

        local digTrack3 = localRig.digTrack;

        if digTrack3 then
            digTrack3.TimePosition = 0;
        end;
    end;

    return true;
end;

function u6.setDigSpeed(p97, p98) -- Line: 535
    local localRig = p97.localRig;

    if localRig ~= nil then
        local digTrack = localRig.digTrack;

        if digTrack ~= nil then
            digTrack:AdjustSpeed((math.clamp(p98, 0, 4)));
        end;
    end;
end;

function u6.onDigHit(p99, p100) -- Line: 544
    p99.digHitListeners[p100] = true;
end;

function u6.onThrowDirt(p101, p102) -- Line: 549
    p101.throwDirtListeners[p102] = true;
end;

function u6.emitMarker(p103, p104) -- Line: 554
    if not p103.digging then
        return nil;
    end;

    for i in p104 do
        i();
    end;
end;

function u6.endDigging(p105) -- Line: 562
    if not p105.digging then
        return nil;
    end;

    p105.digging = false;
    local localRig = p105.localRig;

    if localRig ~= nil then
        local digTrack = localRig.digTrack;

        if digTrack ~= nil then
            digTrack:Stop(0.05);
        end;
    end;

    local v106;

    if localRig == nil then
        v106 = localRig;
    else
        v106 = localRig.equipped;
    end;

    if v106 then
        local track = localRig.track;

        if track ~= nil then
            track:Play(0.05);
        end;
    end;

    p105:evaluateLocalZone();
end;

function u6.destroyRig(p107, p108) -- Line: 587
    -- upvalues: ShovelEvents (copy)
    local v109 = p107.rigs[p108];

    if not v109 then
        return nil;
    end;

    if v109 == p107.localRig and v109.equipped then
        ShovelEvents.SetShovelEquipped:fire(false);
    end;

    local track = v109.track;

    if track ~= nil then
        track:Stop();
    end;

    local track2 = v109.track;

    if track2 ~= nil then
        track2:Destroy();
    end;

    local digTrack = v109.digTrack;

    if digTrack ~= nil then
        digTrack:Stop();
    end;

    local digTrack2 = v109.digTrack;

    if digTrack2 ~= nil then
        digTrack2:Destroy();
    end;

    for _, v in v109.markerConnections do
        v:Disconnect();
    end;

    v109.holder:Destroy();
    p107.rigs[p108] = nil;

    if v109 == p107.localRig then
        p107.localRig = nil;
        p107.digging = false;
    end;
end;

Reflect.defineMetadata(u6, "identifier", "client/controllers/world/ShovelController@ShovelController");
Reflect.defineMetadata(u6, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u6, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u6, "$:flamework@Controller", Controller, { {} });

return {
    ShovelController = u6
};