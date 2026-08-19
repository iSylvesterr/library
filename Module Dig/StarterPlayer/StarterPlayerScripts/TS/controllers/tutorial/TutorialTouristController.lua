-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;
local TutorialEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "TutorialNetwork").TutorialEvents;
local showTipBillboard = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "TipBillboard").showTipBillboard;
local VISIT_WALK_SPEED = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "npc", "VisitorConstants").VISIT_WALK_SPEED;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "tutorial", "TutorialConfig");
local TUTORIAL_PEDESTAL_SLOT = v1.TUTORIAL_PEDESTAL_SLOT;
local TUTORIAL_TOURIST_ARRIVE_SECONDS = v1.TUTORIAL_TOURIST_ARRIVE_SECONDS;
local TUTORIAL_TOURIST_COUNT = v1.TUTORIAL_TOURIST_COUNT;
local TUTORIAL_TOURIST_ENTER_STAGGER_MAX = v1.TUTORIAL_TOURIST_ENTER_STAGGER_MAX;
local TUTORIAL_TOURIST_ENTER_STAGGER_MIN = v1.TUTORIAL_TOURIST_ENTER_STAGGER_MIN;
local TUTORIAL_TOURIST_FADE_SECONDS = v1.TUTORIAL_TOURIST_FADE_SECONDS;
local TUTORIAL_TOURIST_LIFETIME = v1.TUTORIAL_TOURIST_LIFETIME;
local TUTORIAL_TOURIST_MAX_SPEED = v1.TUTORIAL_TOURIST_MAX_SPEED;
local TUTORIAL_TOURIST_SPREAD = v1.TUTORIAL_TOURIST_SPREAD;
local TutorialStep = v1.TutorialStep;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local VisitPath = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "npc", "VisitPath").VisitPath;

local function yawTowards(p2, p3, p4, p5) -- Line: 35
    return math.atan2(-(p4 - p2), -(p5 - p3));
end;

local function cumulativeTimes(p6, p7) -- Line: 38
    local v8 = {};
    local v9 = 0;

    for i = 0, #p6 - 2 do
        local v10 = p6[i + 2].X - p6[i + 1].X;
        local v11 = p6[i + 2].Z - p6[i + 1].Z;
        local v12 = math.sqrt(v10 * v10 + v11 * v11);
        table.insert(v8, v12);
        v9 = v9 + v12;
    end;

    local v13 = 0;
    local v14 = { 0 };

    for _, v in v8 do
        v13 = v13 + (v9 <= 0 and 0 or v / v9 * p7);
        table.insert(v14, v13);
    end;

    return v14;
end;

local function pathLength(p15) -- Line: 57
    local v16 = 0;

    for i = 0, #p15 - 2 do
        local v17 = p15[i + 2].X - p15[i + 1].X;
        local v18 = p15[i + 2].Z - p15[i + 1].Z;
        v16 = v16 + math.sqrt(v17 * v17 + v18 * v18);
    end;

    return v16;
end;

local u19 = setmetatable({}, {
    __tostring = function() -- Line: 69, Name: __tostring
        return "TutorialTouristController";
    end
});
u19.__index = u19;

function u19.new(...) -- Line: 74
    -- upvalues: u19 (ref)
    local v20 = setmetatable({}, u19);

    return v20:constructor(...) or v20;
end;

function u19.constructor(p21, p22, p23, p24) -- Line: 78
    p21.tutorial = p22;
    p21.crowd = p23;
    p21.plot = p24;
    p21.tourists = {};
    p21.spawning = false;
    p21.visitRequested = false;
    p21.retiring = false;
end;

function u19.onStart(u25) -- Line: 87
    -- upvalues: TutorialEvents (copy), showTipBillboard (copy)
    u25.tutorial:onStepChanged(function(p26) -- Line: 88
        -- upvalues: u25 (copy)
        return u25:onStep(p26);
    end);
    TutorialEvents.TutorialTouristPaid:connect(function(p27, p28) -- Line: 91
        -- upvalues: u25 (copy), showTipBillboard (ref)
        local u29 = u25.tourists[p27 + 1];

        if not u29 then
            return nil;
        end;

        showTipBillboard(u29.rig.root.Position, p28);
        task.delay(1, function() -- Line: 97
            -- upvalues: u25 (ref), u29 (copy)
            return u25:sendHome(u29);
        end);
    end);
end;

function u19.onStep(p30, p31) -- Line: 102
    -- upvalues: TutorialStep (copy)
    if p31 == TutorialStep.PlaceItem then
        p30:ensureTourists();

        return;
    end;

    if p31 ~= TutorialStep.Tourists then
        if TutorialStep.Tourists < p31 then
            p30:beginRetirement();
        end;

        return;
    end;

    p30.visitRequested = true;
    p30:ensureTourists();
    p30:sendTouristsToPlot();
end;

function u19.ensureTourists(u32) -- Line: 113
    -- upvalues: RuntimeLib (copy), WFChain (copy), Workspace (copy), TUTORIAL_TOURIST_COUNT (copy)
    if u32.spawning or #u32.tourists ~= 0 then
        return nil;
    end;

    u32.spawning = true;
    task.spawn(RuntimeLib.async(function() -- Line: 118
        -- upvalues: RuntimeLib (ref), u32 (copy), WFChain (ref), Workspace (ref), TUTORIAL_TOURIST_COUNT (ref)
        local v33 = RuntimeLib.await(u32.plot:awaitPlot());
        local v34 = WFChain(v33, "Plot", "Nodes", "JunctionNode");
        local v35 = WFChain(v33, "Plot", "Nodes", "WalkwayNode");
        local v36 = Vector3.new(v34.Position.X - v35.Position.X, 0, v34.Position.Z - v35.Position.Z);
        local v37 = v34.Position + (v36.Magnitude <= 0.001 and Vector3.new(0, 0, 1) or v36.Unit) * 12;
        local Folder = Instance.new("Folder");
        Folder.Name = "TutorialTourists";
        Folder.Parent = Workspace;
        u32.folder = Folder;

        for i = 0, TUTORIAL_TOURIST_COUNT - 1 do
            local v38 = u32.crowd:createRig(7907 + os.time() + i, `Tourist_{i}`, Folder);

            while not v38 do
                task.wait(0.5);
                v38 = u32.crowd:createRig(7907 + os.time() + i, `Tourist_{i}`, Folder);
            end;

            local v39 = math.random() * 2 * 3.141592653589793;
            local v40 = 2 + math.random() * 4;
            local v41 = v37.X + math.cos(v39) * v40;
            local v42 = v37.Z + math.sin(v39) * v40;
            local v43 = u32.crowd:groundYAt(v41, v42, v37.Y);
            v38.groundY = v43;
            v38.targetGroundY = v43;
            v38.sampleX = v41;
            v38.sampleZ = v42;
            v38.root.CFrame = CFrame.new(v41, v43 + v38.rootOffset, v42);
            table.insert(u32.tourists, {
                mode = "wander",
                roaming = false,
                wanderPauseUntil = 0,
                walkStartedAt = 0,
                walkDuration = 0,
                walkSpeed = 8,
                rig = v38,
                home = v37,
                x = v41,
                z = v42,
                waypoints = {},
                times = {},
                viewSpot = v37,
                pedestalPosition = v37
            });
        end;

        u32.spawning = false;

        if u32.visitRequested then
            u32:sendTouristsToPlot();
        end;
    end));
end;

function u19.sendTouristsToPlot(u44) -- Line: 172
    -- upvalues: RuntimeLib (copy), TUTORIAL_TOURIST_ENTER_STAGGER_MIN (copy), TUTORIAL_TOURIST_ENTER_STAGGER_MAX (copy)
    if u44.spawning or #u44.tourists == 0 then
        return nil;
    end;

    task.spawn(RuntimeLib.async(function() -- Line: 176
        -- upvalues: RuntimeLib (ref), u44 (copy), TUTORIAL_TOURIST_ENTER_STAGGER_MIN (ref), TUTORIAL_TOURIST_ENTER_STAGGER_MAX (ref)
        local u45 = RuntimeLib.await(u44.plot:awaitPlot());
        local u46 = 0;

        local function _(u47, u48) -- Line: 181
            -- upvalues: u46 (ref), TUTORIAL_TOURIST_ENTER_STAGGER_MIN (ref), TUTORIAL_TOURIST_ENTER_STAGGER_MAX (ref), u44 (ref), u45 (copy)
            if u48 > 0 then
                u46 = u46 + (TUTORIAL_TOURIST_ENTER_STAGGER_MIN + math.random() * (TUTORIAL_TOURIST_ENTER_STAGGER_MAX - TUTORIAL_TOURIST_ENTER_STAGGER_MIN));
            end;

            task.delay(u46, function() -- Line: 185
                -- upvalues: u44 (ref), u45 (ref), u47 (copy), u48 (copy)
                return u44:startApproach(u45, u47, u48);
            end);
        end;

        for i, v in u44.tourists do
            local u49 = i - 1;

            if u49 > 0 then
                u46 = u46 + (TUTORIAL_TOURIST_ENTER_STAGGER_MIN + math.random() * (TUTORIAL_TOURIST_ENTER_STAGGER_MAX - TUTORIAL_TOURIST_ENTER_STAGGER_MIN));
            end;

            task.delay(u46, function() -- Line: 185
                -- upvalues: u44 (ref), u45 (copy), v (copy), u49 (copy)
                return u44:startApproach(u45, v, u49);
            end);
        end;
    end));
end;

function u19.startApproach(p50, p51, p52, p53) -- Line: 195
    -- upvalues: TUTORIAL_TOURIST_COUNT (copy), TUTORIAL_TOURIST_SPREAD (copy), VisitPath (copy), TUTORIAL_PEDESTAL_SLOT (copy), pathLength (copy), TUTORIAL_TOURIST_ARRIVE_SECONDS (copy), TUTORIAL_TOURIST_MAX_SPEED (copy), cumulativeTimes (copy)
    if p52.mode ~= "wander" or p50.tourists[p53 + 1] ~= p52 then
        return nil;
    end;

    local v54 = VisitPath.build(p51, TUTORIAL_PEDESTAL_SLOT, p52.x, p52.z, (p53 - (TUTORIAL_TOURIST_COUNT - 1) / 2) * TUTORIAL_TOURIST_SPREAD);

    if not v54 then
        return nil;
    end;

    local v55 = pathLength(v54.waypoints);
    local v56 = math.max(TUTORIAL_TOURIST_ARRIVE_SECONDS, v55 / TUTORIAL_TOURIST_MAX_SPEED);
    p52.mode = "approach";
    p52.waypoints = v54.waypoints;
    p52.times = cumulativeTimes(v54.waypoints, v56);
    p52.walkStartedAt = os.clock();
    p52.walkDuration = v56;
    p52.walkSpeed = v56 <= 0 and 8 or v55 / v56;
    p52.viewSpot = v54.waypoints[#v54.waypoints];
    p52.pedestalPosition = v54.pedestalPosition;
end;

function u19.sendHome(p57, p58) -- Line: 215
    -- upvalues: pathLength (copy), VISIT_WALK_SPEED (copy), cumulativeTimes (copy)
    if p58.mode ~= "view" then
        return nil;
    end;

    local v59 = {};

    for i = #p58.waypoints - 1, 0, -1 do
        table.insert(v59, p58.waypoints[i + 1]);
    end;

    local v60 = pathLength(v59) / VISIT_WALK_SPEED;
    local v61 = math.max(v60, 0.1);
    p58.mode = "return";
    p58.waypoints = v59;
    p58.times = cumulativeTimes(v59, v61);
    p58.walkStartedAt = os.clock();
    p58.walkDuration = v61;
    p58.walkSpeed = VISIT_WALK_SPEED;
end;

function u19.beginRetirement(u62) -- Line: 233
    -- upvalues: TUTORIAL_TOURIST_LIFETIME (copy)
    if u62.retiring or #u62.tourists == 0 then
        return nil;
    end;

    u62.retiring = true;
    task.delay(TUTORIAL_TOURIST_LIFETIME, function() -- Line: 238
        -- upvalues: u62 (copy)
        return u62:fadeOut();
    end);
end;

function u19.onRender(p63, p64) -- Line: 242
    if #p63.tourists == 0 then
        return nil;
    end;

    local v65 = os.clock();

    for _, v in p63.tourists do
        if v.mode == "wander" then
            p63:updateWander(v, v65, p64);
        elseif v.mode == "view" then
            p63:updateView(v, p64);
        else
            p63:updateWalk(v, v65, p64);
        end;
    end;
end;

function u19.pickWanderTarget(p66, p67) -- Line: 257
    local v68 = math.random() * 2 * 3.141592653589793;

    if not p67.roaming then
        local v69 = math.random() * 6;
        local home = p67.home;
        local v70 = math.cos(v68) * v69;
        local v71 = math.sin(v68) * v69;

        return home + Vector3.new(v70, 0, v71);
    end;

    local v72 = 8 + math.random() * 8;
    local v73 = p67.x + math.cos(v68) * v72;
    local v74 = p67.z + math.sin(v68) * v72;
    local v75 = p66.crowd:getArea();

    if v75 then
        v73 = math.clamp(v73, v75.centerX - v75.halfX, v75.centerX + v75.halfX);
        v74 = math.clamp(v74, v75.centerZ - v75.halfZ, v75.centerZ + v75.halfZ);
    end;

    return Vector3.new(v73, p67.home.Y, v74);
end;

function u19.updateWander(p76, p77, p78, p79) -- Line: 275
    local wanderTarget = p77.wanderTarget;

    if not wanderTarget then
        if p77.wanderPauseUntil <= p78 then
            p77.wanderTarget = p76:pickWanderTarget(p77);
        end;

        p76.crowd:moveRig(p77.rig, p77.x, p77.z, p77.rig.yaw, false, p79, p77.home.Y, 8);

        return nil;
    end;

    local v80 = wanderTarget.X - p77.x;
    local v81 = wanderTarget.Z - p77.z;
    local v82 = math.sqrt(v80 * v80 + v81 * v81);

    if v82 <= 0.5 then
        p77.wanderTarget = nil;
        p77.wanderPauseUntil = p78 + 0.75 + math.random() * 1.25;
        p76.crowd:moveRig(p77.rig, p77.x, p77.z, p77.rig.yaw, false, p79, p77.home.Y, 8);

        return nil;
    end;

    local v83 = math.min(8 * p79, v82);
    p77.x = p77.x + v80 / v82 * v83;
    p77.z = p77.z + v81 / v82 * v83;
    local v84 = math.atan2(-(wanderTarget.X - p77.x), -(wanderTarget.Z - p77.z));
    p76.crowd:moveRig(p77.rig, p77.x, p77.z, v84, true, p79, p77.home.Y, 8);
end;

function u19.updateWalk(p85, p86, p87, p88) -- Line: 299
    local v89 = p87 - p86.walkStartedAt;

    if p86.walkDuration <= v89 then
        if p86.mode == "approach" then
            p86.mode = "view";
            p86.x = p86.viewSpot.X;
            p86.z = p86.viewSpot.Z;
            p85:updateView(p86, p88);
        else
            local v90 = p86.waypoints[#p86.waypoints];
            p86.mode = "wander";
            p86.roaming = true;
            p86.x = v90.X;
            p86.z = v90.Z;
            p86.wanderTarget = nil;
            p86.wanderPauseUntil = p87 + 0.75;
        end;

        return nil;
    end;

    local waypoints = p86.waypoints;
    local times = p86.times;
    local v91 = 0;

    while v91 < #times - 2 and times[v91 + 2] <= v89 do
        v91 = v91 + 1;
    end;

    local v92 = waypoints[v91 + 1];
    local v93 = waypoints[v91 + 2];
    local v94 = math.max(times[v91 + 2] - times[v91 + 1], 0.0001);
    local v95 = v92:Lerp(v93, (math.clamp((v89 - times[v91 + 1]) / v94, 0, 1)));
    p86.x = v95.X;
    p86.z = v95.Z;
    local v96 = math.atan2(-(v93.X - v92.X), -(v93.Z - v92.Z));
    p85.crowd:moveRig(p86.rig, v95.X, v95.Z, v96, true, p88, v95.Y, p86.walkSpeed);
end;

function u19.updateView(p97, p98, p99) -- Line: 335
    local v100 = math.atan2(-(p98.pedestalPosition.X - p98.viewSpot.X), -(p98.pedestalPosition.Z - p98.viewSpot.Z));
    p97.crowd:moveRig(p98.rig, p98.x, p98.z, v100, false, p99, p98.viewSpot.Y, p98.walkSpeed);
end;

function u19.fadeOut(p101) -- Line: 339
    -- upvalues: TUTORIAL_TOURIST_FADE_SECONDS (copy)
    local folder = p101.folder;
    p101.folder = nil;

    for _, v in p101.tourists do
        p101.crowd:retireRig(v.rig, v.walkSpeed, TUTORIAL_TOURIST_FADE_SECONDS);
    end;

    table.clear(p101.tourists);
    p101.visitRequested = false;
    p101.retiring = false;

    if not folder then
        return nil;
    end;

    task.delay(TUTORIAL_TOURIST_FADE_SECONDS, function() -- Line: 351
        -- upvalues: folder (copy)
        return folder:Destroy();
    end);
end;

Reflect.defineMetadata(u19, "identifier", "client/controllers/tutorial/TutorialTouristController@TutorialTouristController");
Reflect.defineMetadata(u19, "flamework:parameters", { "client/controllers/tutorial/TutorialController@TutorialController", "client/controllers/npc/CrowdController@CrowdController", "client/controllers/plot/PlotController@PlotController" });
Reflect.defineMetadata(u19, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" });
Reflect.decorate(u19, "$:flamework@Controller", Controller, { {} });

return {
    TutorialTouristController = u19
};