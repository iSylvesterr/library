-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "VisitorNetwork");
local VisitorEvents = v1.VisitorEvents;
local VisitorFunctions = v1.VisitorFunctions;
local RigFade = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "RigFade").RigFade;
local showTipBillboard = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "TipBillboard").showTipBillboard;
local VISIT_WALK_SPEED = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "npc", "VisitorConstants").VISIT_WALK_SPEED;
local STARTER_ISLAND_ID = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands").STARTER_ISLAND_ID;
local VisitPath = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "npc", "VisitPath").VisitPath;

local function yawTowards(p2, p3, p4, p5) -- Line: 21
    return math.atan2(-(p4 - p2), -(p5 - p3));
end;

local function cumulativeTimes(p6, p7) -- Line: 24
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

local function walkPose(p15, p16, p17) -- Line: 43
    local v18 = 0;

    while v18 < #p16 - 2 and p16[v18 + 2] <= p17 do
        v18 = v18 + 1;
    end;

    local v19 = p15[v18 + 1];
    local v20 = p15[v18 + 2];
    local v21 = math.max(p16[v18 + 2] - p16[v18 + 1], 0.0001);
    local v22 = v19:Lerp(v20, (math.clamp((p17 - p16[v18 + 1]) / v21, 0, 1)));

    return {
        walking = true,
        x = v22.X,
        z = v22.Z,
        y = v22.Y,
        yaw = math.atan2(-(v20.X - v19.X), -(v20.Z - v19.Z))
    };
end;

local u23 = setmetatable({}, {
    __tostring = function() -- Line: 64, Name: __tostring
        return "VisitorController";
    end
});
u23.__index = u23;

function u23.new(...) -- Line: 69
    -- upvalues: u23 (ref)
    local v24 = setmetatable({}, u23);

    return v24:constructor(...) or v24;
end;

function u23.constructor(p25, p26, p27) -- Line: 73
    p25.crowd = p26;
    p25.islands = p27;
    p25.rigged = {};
    p25.started = false;
    p25.away = false;
    p25.islandTimer = 0;
    p25.resyncing = false;
    p25.resyncQueued = false;
end;

function u23.onStart(u28) -- Line: 83
    -- upvalues: VisitorEvents (copy)
    VisitorEvents.VisitStarted:connect(function(p29) -- Line: 84
        -- upvalues: u28 (copy)
        return u28:onVisitStarted(p29);
    end);
    VisitorEvents.VisitCancelled:connect(function(p30) -- Line: 87
        -- upvalues: u28 (copy)
        return u28:retire(p30);
    end);
    VisitorEvents.VisitPaid:connect(function(p31, p32) -- Line: 90
        -- upvalues: u28 (copy)
        return u28:onVisitPaid(p31, p32);
    end);
    task.spawn(function() -- Line: 93
        -- upvalues: u28 (copy)
        return u28:initialize();
    end);
end;

function u23.initialize(u33) -- Line: 97
    -- upvalues: Workspace (copy)
    local Plots = Workspace:WaitForChild("Plots");
    u33.crowd:start();
    u33.started = true;
    u33:refreshAway();
    Plots.ChildAdded:Connect(function() -- Line: 102
        -- upvalues: u33 (copy)
        return u33:queueResync();
    end);
    Plots.ChildRemoved:Connect(function(p34) -- Line: 105
        -- upvalues: u33 (copy)
        return u33:onPlotRemoved(p34);
    end);
    u33:queueResync();
end;

function u23.queueResync(u35) -- Line: 110
    -- upvalues: VisitorFunctions (copy), Workspace (copy)
    if not u35.started or u35.away then
        return nil;
    end;

    u35.resyncQueued = true;

    if u35.resyncing then
        return nil;
    end;

    u35.resyncing = true;
    task.spawn(function() -- Line: 119
        -- upvalues: u35 (copy), VisitorFunctions (ref), Workspace (ref)
        while true do
            while true do
                if not u35.resyncQueued or u35.away then
                    u35.resyncing = false;

                    return;
                end;

                u35.resyncQueued = false;
                local v36, v37 = VisitorFunctions.requestCrowdState:invoke():await();

                if not v36 or v37 == nil then
                    break;
                end;

                local v38 = 0;

                for _, v in v37.visits do
                    if u35.away then
                        break;
                    end;

                    if u35.rigged[v.visitId] == nil then
                        u35:spawn(v, Workspace:GetServerTimeNow());
                        v38 = v38 + 1;

                        if v38 % 12 == 0 then
                            task.wait();
                        end;
                    end;
                end;
            end;

            u35.resyncQueued = true;
            task.wait(1);
        end;
    end);
end;

function u23.onTick(p39, p40) -- Line: 148
    p39.islandTimer = p39.islandTimer + p40;

    if p39.islandTimer < 0.5 then
        return nil;
    end;

    p39.islandTimer = 0;
    p39:refreshAway();
end;

function u23.refreshAway(p41) -- Line: 156
    -- upvalues: STARTER_ISLAND_ID (copy)
    local v42 = p41.islands:getCurrentIslandId();

    if v42 == nil then
        return nil;
    end;

    local v43 = v42 ~= STARTER_ISLAND_ID;

    if p41.away == v43 then
        return nil;
    end;

    p41.away = v43;

    if not v43 then
        p41:queueResync();

        return nil;
    end;

    for i in p41.rigged do
        p41:despawn(i);
    end;
end;

function u23.onPlotRemoved(p44, p45) -- Line: 174
    local v46 = string.match(p45.Name, "^Plot_(%d+)$");
    local v47 = tonumber(v46);

    if v47 == nil then
        return nil;
    end;

    for i, v in p44.rigged do
        if v.info.plotIndex == v47 then
            p44:despawn(i);
        end;
    end;
end;

function u23.plotFor(p48, p49) -- Line: 185
    -- upvalues: Workspace (copy)
    local Plots = Workspace:FindFirstChild("Plots");

    if Plots ~= nil then
        Plots = Plots:FindFirstChild((`Plot_{p49}`));
    end;

    local v50;

    if Plots == nil then
        v50 = Plots;
    else
        v50 = Plots:IsA("Model");
    end;

    if v50 then
        return Plots;
    end;

    return nil;
end;

function u23.onVisitStarted(p51, p52) -- Line: 197
    -- upvalues: Workspace (copy)
    if p51.away or not p51.started then
        return nil;
    end;

    p51:spawn(p52, Workspace:GetServerTimeNow());
end;

function u23.buildTiming(p53, p54, p55) -- Line: 203
    -- upvalues: VisitPath (copy), cumulativeTimes (copy)
    local v56 = VisitPath.build(p54, p55.slot, p55.startX, p55.startZ, p55.spread);

    if not v56 then
        return nil;
    end;

    local v57 = {};

    for i = #v56.waypoints - 1, 0, -1 do
        table.insert(v57, v56.waypoints[i + 1]);
    end;

    return {
        waypoints = v56.waypoints,
        arriveTimes = cumulativeTimes(v56.waypoints, v56.arriveDuration),
        returnWaypoints = v57,
        returnTimes = cumulativeTimes(v57, v56.arriveDuration),
        arriveDuration = v56.arriveDuration,
        returnDuration = v56.arriveDuration,
        pedestalPosition = v56.pedestalPosition
    };
end;

function u23.spawn(p58, p59, p60) -- Line: 223
    -- upvalues: VISIT_WALK_SPEED (copy), RigFade (copy)
    local v61 = p58:plotFor(p59.plotIndex);

    if not v61 then
        return nil;
    end;

    local v62 = p58.crowd:getFolder();

    if not v62 then
        return nil;
    end;

    local v63 = p58:buildTiming(v61, p59);

    if not v63 then
        return nil;
    end;

    local v64 = p58:poseAt(v63, p59, p60);

    if not v64 then
        return nil;
    end;

    local v65 = p58.crowd:createRig(p59.visitId * 104729, `Visitor_{p59.visitId}`, v62, p59.rich);

    if not v65 then
        return nil;
    end;

    local v66 = p58.crowd:groundYAt(v64.x, v64.z, v64.y);
    v65.groundY = v66;
    v65.targetGroundY = v66;
    v65.sampleX = v64.x;
    v65.sampleZ = v64.z;
    v65.lastX = v64.x;
    v65.lastZ = v64.z;
    v65.yaw = v64.yaw;
    local v67 = CFrame.new(v64.x, v66 + v65.rootOffset, v64.z);
    local v68 = CFrame.Angles(0, v64.yaw, 0);
    v65.root.CFrame = v67 * v68;
    p58.crowd:setWalking(v65, v64.walking, VISIT_WALK_SPEED);

    if p60 - p59.startTime < 0.6 then
        RigFade.fadeIn(v65.model, 0.6);
    end;

    local rigged = p58.rigged;
    local visitId = p59.visitId;
    local v69 = table.clone(v63);
    setmetatable(v69, nil);
    v69.info = p59;
    v69.rig = v65;
    rigged[visitId] = v69;
end;

function u23.retire(p70, p71) -- Line: 267
    -- upvalues: VISIT_WALK_SPEED (copy)
    local v72 = p70.rigged[p71];

    if not v72 then
        return nil;
    end;

    p70.rigged[p71] = nil;
    p70.crowd:retireRig(v72.rig, VISIT_WALK_SPEED, 0.6);
end;

function u23.despawn(p73, p74) -- Line: 279
    local v75 = p73.rigged[p74];

    if not v75 then
        return nil;
    end;

    p73.rigged[p74] = nil;
    v75.rig.model:Destroy();
end;

function u23.onVisitPaid(p76, p77, p78) -- Line: 291
    -- upvalues: showTipBillboard (copy)
    local v79 = p76.rigged[p77];

    if not v79 then
        return nil;
    end;

    showTipBillboard(v79.rig.root.Position, p78);
end;

function u23.onRender(p80, p81) -- Line: 300
    -- upvalues: Workspace (copy), VISIT_WALK_SPEED (copy)
    if next(p80.rigged) == nil then
        return nil;
    end;

    local v82 = Workspace:GetServerTimeNow();
    local v83 = {};

    for i, v in p80.rigged do
        local v84 = p80:poseAt(v, v.info, v82);

        if v84 then
            p80.crowd:moveRig(v.rig, v84.x, v84.z, v84.yaw, v84.walking, p81, v84.y, VISIT_WALK_SPEED);
        else
            table.insert(v83, i);
        end;
    end;

    for _, v in v83 do
        p80:retire(v);
    end;
end;

function u23.poseAt(p85, p86, p87, p88) -- Line: 318
    -- upvalues: walkPose (copy)
    local v89 = p88 - p87.startTime;
    local v90 = p86.arriveDuration + p87.dwell;
    local v91 = v90 + p86.returnDuration;

    if v89 < p86.arriveDuration then
        return walkPose(p86.waypoints, p86.arriveTimes, v89);
    end;

    if v89 < v90 then
        local v92 = p86.waypoints[#p86.waypoints];

        return {
            walking = false,
            x = v92.X,
            z = v92.Z,
            y = v92.Y,
            yaw = math.atan2(-(p86.pedestalPosition.X - v92.X), -(p86.pedestalPosition.Z - v92.Z))
        };
    end;

    if v89 < v91 then
        return walkPose(p86.returnWaypoints, p86.returnTimes, v89 - v90);
    end;

    return nil;
end;

Reflect.defineMetadata(u23, "identifier", "client/controllers/npc/VisitorController@VisitorController");
Reflect.defineMetadata(u23, "flamework:parameters", { "client/controllers/npc/CrowdController@CrowdController", "client/controllers/world/IslandController@IslandController" });
Reflect.defineMetadata(u23, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick", "$:flamework@OnRender" });
Reflect.decorate(u23, "$:flamework@Controller", Controller, { {} });

return {
    VisitorController = u23
};