-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local Players = v1.Players;
local Workspace = v1.Workspace;
local rarityStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "RarityStyles").rarityStyleFor;
local DetectorEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "DetectorNetwork").DetectorEvents;
local RarityBeams = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "RarityBeams").RarityBeams;
local SurfaceScenes = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "SurfaceScene").SurfaceScenes;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors");
local DETECTOR_PING_SECONDS = v2.DETECTOR_PING_SECONDS;
local DETECTOR_SWEEP_SECONDS = v2.DETECTOR_SWEEP_SECONDS;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "DiggingConfig");
local BURIED_SURFACE_SECONDS = v3.BURIED_SURFACE_SECONDS;
local digReachFor = v3.digReachFor;
local DIG_ZONE_TAG = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").DIG_ZONE_TAG;
local RARITY_ORDER = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").RARITY_ORDER;
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil");
local playWorldSound = v4.playWorldSound;
local prewarmWorldSounds = v4.prewarmWorldSounds;
local u5 = CFrame.Angles(-1.5707963267948966, 0, 0);
local u6 = Color3.new(1, 1, 1);
local u7 = setmetatable({}, {
    __tostring = function() -- Line: 41, Name: __tostring
        return "DetectorSweepController";
    end
});
u7.__index = u7;

function u7.new(...) -- Line: 46
    -- upvalues: u7 (ref)
    local v8 = setmetatable({}, u7);

    return v8:constructor(...) or v8;
end;

function u7.constructor(p9, p10, p11) -- Line: 50
    -- upvalues: Players (copy), u6 (copy)
    p9.detector = p10;
    p9.tutorial = p11;
    p9.localPlayer = Players.LocalPlayer;
    p9.nodes = {};
    p9.surfaced = {};
    p9.finished = {};
    p9.groundParams = RaycastParams.new();
    p9.ringColor = u6;
    p9.sweepStartedAt = 0;
    p9.groundFilterDirty = true;
end;

function u7.onStart(u12) -- Line: 62
    -- upvalues: prewarmWorldSounds (copy), CollectionService (copy), DIG_ZONE_TAG (copy), DetectorEvents (copy)
    prewarmWorldSounds({ "DetectorBeep" });
    u12.groundParams.FilterType = Enum.RaycastFilterType.Exclude;
    u12.groundParams.IgnoreWater = true;
    CollectionService:GetInstanceAddedSignal(DIG_ZONE_TAG):Connect(function() -- Line: 66
        -- upvalues: u12 (copy)
        u12.groundFilterDirty = true;

        return u12.groundFilterDirty;
    end);
    CollectionService:GetInstanceRemovedSignal(DIG_ZONE_TAG):Connect(function() -- Line: 70
        -- upvalues: u12 (copy)
        u12.groundFilterDirty = true;

        return u12.groundFilterDirty;
    end);
    DetectorEvents.BuriedNodes:connect(function(p13, p14) -- Line: 74
        -- upvalues: u12 (copy)
        for _, v in p13 do
            u12.nodes[v.id] = v;
        end;

        for _, v in p14 do
            u12.nodes[v] = nil;
            u12:removeSurfaced(v);
        end;
    end);
end;

function u7.nearestSpot(p15, p16) -- Line: 86
    -- upvalues: SurfaceScenes (copy), digReachFor (copy)
    local v17 = (1 / 0);
    local v18 = nil;

    for i, v in p15.surfaced do
        local v19 = p15.nodes[i];

        if v19 ~= nil and SurfaceScenes.isDiggable(v.scene) then
            local Magnitude = (v19.position - p16).Magnitude;

            if digReachFor(v19.itemSize) >= Magnitude and v17 > Magnitude then
                v18 = v19;
                v17 = Magnitude;
            end;
        end;
    end;

    return v18;
end;

function u7.takeMound(p20, p21) -- Line: 105
    -- upvalues: SurfaceScenes (copy)
    local v22 = p20.surfaced[p21];

    if v22 then
        return SurfaceScenes.takeMound(v22.scene);
    end;

    return nil;
end;

function u7.onRender(p23, p24) -- Line: 111
    -- upvalues: DETECTOR_PING_SECONDS (copy), DETECTOR_SWEEP_SECONDS (copy)
    p23:updateSurfaced();
    local v25 = p23.detector:getLocalDefinition();

    if not (v25 and p23.detector:isLocalHeld()) then
        p23:endSweep();

        return nil;
    end;

    local v26 = p23.detector:getLocalCoil();

    if not v26 then
        p23:endSweep();

        return nil;
    end;

    local v27 = os.clock() - p23.sweepStartedAt;

    if p23.sweepStartedAt == 0 or DETECTOR_PING_SECONDS <= v27 then
        p23:beginSweep(v26);
    end;

    local v28 = (os.clock() - p23.sweepStartedAt) / DETECTOR_SWEEP_SECONDS;
    local v29 = math.clamp(v28, 0, 1);
    local v30 = v29 * v25.range;
    p23:detectNearby(v26.Position, v25.range, v30);
    p23:updateRing(p23:groundCFrameAt(v26.Position), v30, v29, p24);
end;

function u7.beginSweep(p31, p32) -- Line: 132
    -- upvalues: u6 (copy), playWorldSound (copy)
    p31.sweepStartedAt = os.clock();
    p31.sweepRarity = nil;
    p31.ringColor = u6;
    playWorldSound("DetectorBeep", {
        volume = 0.12,
        cleanupDelay = 2,
        parent = p32
    });
end;

function u7.endSweep(p33) -- Line: 142
    -- upvalues: u6 (copy)
    p33.sweepStartedAt = 0;
    p33.sweepRarity = nil;
    p33.ringColor = u6;

    if p33.ring then
        p33.ring.Visible = false;
    end;
end;

function u7.detectNearby(p34, p35, p36, p37) -- Line: 150
    local v38 = p36 * p36;
    local v39 = p37 * p37;

    for i, v in p34.nodes do
        local v40 = v.position - p35;
        local v41 = v40.X * v40.X + v40.Z * v40.Z;

        if v38 >= v41 then
            if v41 <= v39 and (p34.sweepRarity == nil or p34:isBetter(v.rarity, p34.sweepRarity)) then
                p34.sweepRarity = v.rarity;
            end;

            p34:surface(i, v);
        end;
    end;
end;

function u7.isBetter(p42, p43, p44) -- Line: 167
    -- upvalues: RARITY_ORDER (copy)
    return (table.find(RARITY_ORDER, p43) or 0) - 1 > (table.find(RARITY_ORDER, p44) or 0) - 1;
end;

function u7.surface(p45, p46, p47) -- Line: 173
    -- upvalues: SurfaceScenes (copy), RarityBeams (copy), playWorldSound (copy)
    if p45.surfaced[p46] ~= nil then
        return nil;
    end;

    local v48 = SurfaceScenes.create(p47.position, p47.rarity, p47.itemSize);
    p45.surfaced[p46] = {
        scene = v48,
        surfacedAt = os.clock()
    };
    local v49 = RarityBeams.beamSound(p47.rarity);
    playWorldSound(v49.key, {
        volume = 1,
        cleanupDelay = 4,
        parent = v48.beams.anchor,
        playbackSpeed = v49.playbackSpeed
    });
    p45.tutorial:onNodeSurfaced();
end;

function u7.updateSurfaced(p50) -- Line: 196
    -- upvalues: SurfaceScenes (copy), BURIED_SURFACE_SECONDS (copy)
    local v51 = 0;

    for _ in p50.surfaced do
        v51 = v51 + 1;
    end;

    if v51 == 0 then
        return nil;
    end;

    local v52 = os.clock();
    local v53 = p50.detector:isDigging();

    for i, v in p50.surfaced do
        if v53 then
            v.surfacedAt = v52;
        elseif not SurfaceScenes.isRetracting(v.scene) and BURIED_SURFACE_SECONDS <= v52 - v.surfacedAt then
            SurfaceScenes.retract(v.scene);
        end;

        if not SurfaceScenes.update(v.scene) then
            table.insert(p50.finished, i);
        end;
    end;

    for _, v in p50.finished do
        p50:removeSurfaced(v);
    end;

    table.clear(p50.finished);
end;

function u7.removeSurfaced(p54, p55) -- Line: 224
    -- upvalues: SurfaceScenes (copy)
    local v56 = p54.surfaced[p55];

    if not v56 then
        return nil;
    end;

    p54.surfaced[p55] = nil;
    SurfaceScenes.destroy(v56.scene);
end;

function u7.groundCFrameAt(p57, p58) -- Line: 236
    -- upvalues: CollectionService (copy), DIG_ZONE_TAG (copy), Workspace (copy), u5 (copy)
    local Character = p57.localPlayer.Character;

    if p57.groundFilterDirty or Character ~= p57.groundFilterCharacter then
        p57.groundFilterDirty = false;
        p57.groundFilterCharacter = Character;
        local v59;

        if Character then
            v59 = {};
            local v60 = #v59;
            local v61 = CollectionService:GetTagged(DIG_ZONE_TAG);
            local v62 = #v61;
            table.move(v61, 1, v62, v60 + 1, v59);
            v59[v60 + v62 + 1] = Character;
        else
            v59 = CollectionService:GetTagged(DIG_ZONE_TAG);
        end;

        p57.groundParams.FilterDescendantsInstances = v59;
    end;

    local v63 = Workspace:Raycast(p58 + Vector3.new(0, 8, 0), Vector3.new(0, -32, 0), p57.groundParams);
    local v64 = not v63 and Vector3.new(0, 1, 0) or v63.Normal;

    if v63 then
        p58 = v63.Position;
    end;

    local v65 = p58 + v64 * 0.3;
    local v66 = Vector3.new(0, 0, 1) - v64 * (Vector3.new(0, 0, 1)):Dot(v64);

    return CFrame.lookAt(v65, v65 + (v66.Magnitude < 0.01 and Vector3.new(1, 0, 0) or v66).Unit, v64) * u5;
end;

function u7.updateRing(p67, p68, p69, p70, p71) -- Line: 273
    -- upvalues: rarityStyleFor (copy), u6 (copy)
    local v72 = p67.ring or p67:createRing();
    local v73;

    if p67.sweepRarity == nil then
        v73 = u6;
    else
        v73 = rarityStyleFor(p67.sweepRarity).color;
    end;

    p67.ringColor = p67.ringColor:Lerp(v73, 1 - math.exp(-12 * p71));
    v72.CFrame = p68;
    v72.Radius = math.max(p69, 0.9);
    v72.InnerRadius = math.max(0, v72.Radius - 0.9);
    v72.Color3 = p67.ringColor;
    v72.Transparency = 0.35 + 0.65 * p70 * p70;
    v72.Visible = true;
end;

function u7.createRing(p74) -- Line: 284
    -- upvalues: Workspace (copy)
    local CylinderHandleAdornment = Instance.new("CylinderHandleAdornment");
    CylinderHandleAdornment.Name = "DetectorSweep";
    CylinderHandleAdornment.Adornee = Workspace.Terrain;
    CylinderHandleAdornment.Height = 0.05;
    CylinderHandleAdornment.AlwaysOnTop = false;
    CylinderHandleAdornment.ZIndex = 0;
    CylinderHandleAdornment.Visible = false;
    CylinderHandleAdornment.Parent = Workspace.Terrain;
    p74.ring = CylinderHandleAdornment;

    return CylinderHandleAdornment;
end;

Reflect.defineMetadata(u7, "identifier", "client/controllers/world/DetectorSweepController@DetectorSweepController");
Reflect.defineMetadata(u7, "flamework:parameters", { "client/controllers/world/DetectorController@DetectorController", "client/controllers/tutorial/TutorialController@TutorialController" });
Reflect.defineMetadata(u7, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" });
Reflect.decorate(u7, "$:flamework@Controller", Controller, { {} });

return {
    DetectorSweepController = u7
};