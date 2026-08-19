-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local Workspace = v1.Workspace;
local RarityBeams = RuntimeLib.import(script, script.Parent, "RarityBeams").RarityBeams;
local dirtForRarity = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "DirtTypes").dirtForRarity;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "DiggingConfig");
local digReachFor = v2.digReachFor;
local moundRadiusFor = v2.moundRadiusFor;
local DIG_ZONE_TAG = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").DIG_ZONE_TAG;
local PassThroughTag = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "PassThroughTag").PassThroughTag;
local v3 = {};
local u4 = nil;
local u5 = nil;

function v3.create(p6, p7, p8) -- Line: 28
    -- upvalues: Janitor (copy), RarityBeams (copy), u4 (ref), digReachFor (copy), u5 (ref), dirtForRarity (copy)
    local v9 = Janitor.new();
    local v10 = {
        settled = false,
        beamsJanitor = v9,
        beams = RarityBeams.create(p6, p7, p8, v9),
        surfaceCFrame = u4(p6),
        reach = digReachFor(p8),
        mound = {},
        startedAt = os.clock()
    };
    u5(v10, p6, p8, dirtForRarity(p7));

    return v10;
end;

local u11 = nil;
local u12 = nil;

function v3.update(p13) -- Line: 44
    -- upvalues: u11 (ref), u12 (ref)
    if p13.retractingAt ~= nil then
        return u11(p13);
    end;

    if not p13.settled then
        u12(p13);
    end;

    return true;
end;

function v3.retract(p14) -- Line: 54
    if p14.retractingAt ~= nil then
        return nil;
    end;

    p14.retractingAt = os.clock();
    p14.beams:fadeOut();
end;

function v3.isRetracting(p15) -- Line: 62
    return p15.retractingAt ~= nil;
end;

function v3.isDiggable(p16) -- Line: 66
    local v17;

    if p16.retractingAt == nil then
        v17 = #p16.mound > 0;
    else
        v17 = false;
    end;

    return v17;
end;

function v3.isInReach(p18, p19) -- Line: 70
    local v20;

    if p18.retractingAt == nil then
        v20 = #p18.mound > 0;
    else
        v20 = false;
    end;

    if v20 then
        v20 = (p19 - p18.surfaceCFrame.Position).Magnitude <= p18.reach;
    end;

    return v20;
end;

local u21 = nil;

function v3.clearMound(p22) -- Line: 81
    -- upvalues: u21 (ref)
    p22.settled = true;
    u21(p22);
end;

function v3.takeMound(p23) -- Line: 86
    p23.settled = true;
    local mound = p23.mound;
    p23.mound = {};

    return mound;
end;

function v3.destroy(u24) -- Line: 93
    -- upvalues: u21 (ref)
    u21(u24);
    u24.beams:fadeOut();
    task.delay(1, function() -- Line: 96
        -- upvalues: u24 (copy)
        return u24.beamsJanitor:Destroy();
    end);
end;

u21 = function(p25) -- Line: 101, Name: destroyMound
    for _, v in p25.mound do
        v.part:Destroy();
    end;

    table.clear(p25.mound);
end;

u4 = function(p26) -- Line: 107, Name: computeSurfaceCFrame
    -- upvalues: CollectionService (copy), DIG_ZONE_TAG (copy), Workspace (copy)
    local v27 = RaycastParams.new();
    v27.FilterType = Enum.RaycastFilterType.Exclude;
    v27.IgnoreWater = true;
    v27.FilterDescendantsInstances = CollectionService:GetTagged(DIG_ZONE_TAG);
    local v28 = Workspace:Raycast(p26 + Vector3.new(0, 24, 0), Vector3.new(0, -96, 0), v27);
    local v29 = not v28 and Vector3.new(0, 1, 0) or v28.Normal;
    local v30 = Vector3.new(0, 0, 1) - v29 * (Vector3.new(0, 0, 1)):Dot(v29);

    return CFrame.lookAt(p26, p26 + (v30.Magnitude < 0.01 and Vector3.new(1, 0, 0) or v30).Unit, v29);
end;

u5 = function(p31, p32, p33, p34) -- Line: 129, Name: createMound
    -- upvalues: moundRadiusFor (copy), PassThroughTag (copy), Workspace (copy)
    local v35 = moundRadiusFor(p33);
    local v36 = math.floor(v35 * 6);
    local v37 = math.clamp(v36, 12, 30);
    local UpVector = p31.surfaceCFrame.UpVector;
    local RightVector = p31.surfaceCFrame.RightVector;
    local LookVector = p31.surfaceCFrame.LookVector;
    local v38 = false;
    local v39 = 0;

    while true do
        if v38 then
            v39 = v39 + 1;
        else
            v38 = true;
        end;

        if v39 >= v37 then
            return;
        end;

        local v40 = math.random() * 3.141592653589793 * 2;
        local v41 = math.random();
        local v42 = v35 * math.sqrt(v41);
        local v43 = 0.34 + math.random() * math.min(0.72, v35 * 0.25);
        local v44 = 0.24 + math.random() * 0.42;
        local v45 = v43 * (0.7 + math.random() * 0.6);
        local v46 = Vector3.new(v43, v44, v45);
        local v47 = RightVector * (math.cos(v40) * v42);
        local v48 = LookVector * (math.sin(v40) * v42);
        local v49 = CFrame.new(p32 + v47 + v48 + UpVector * (v46.Y * 0.32)) * CFrame.Angles((math.random() - 0.5) * 0.35, math.random() * 3.141592653589793 * 2, (math.random() - 0.5) * 0.35);
        local Part = Instance.new("Part");
        Part.Size = v46 * 0.2;
        Part.Material = p34.material;
        Part.Color = p34.color:Lerp(Color3.new(), math.random() * 0.12);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.CFrame = v49 - UpVector * (v46.Y + 0.45);
        PassThroughTag.applyToPart(Part);
        Part.Parent = Workspace;
        local mound = p31.mound;
        local v50 = {
            part = Part,
            start = Part.CFrame,
            target = v49,
            size = v46,
            phase = math.random() * 3.141592653589793 * 2,
            revealAt = v39 / v37 * 0.82
        };
        table.insert(mound, v50);
    end;
end;

u12 = function(p51) -- Line: 189, Name: updateEmerge
    local v52 = os.clock();
    local v53 = math.clamp((v52 - p51.startedAt) / 1.6, 0, 1);

    if v53 >= 1 then
        p51.settled = true;
    end;

    local RightVector = p51.surfaceCFrame.RightVector;
    local LookVector = p51.surfaceCFrame.LookVector;

    for _, v in p51.mound do
        local v54 = math.clamp((v53 - v.revealAt) / (1 - v.revealAt), 0, 1);
        local v55 = 1 - (1 - v54) ^ 3;
        local v56 = math.sin(v54 * 3.141592653589793) * 0.035;
        local v57 = RightVector * (math.sin(v52 * 42 + v.phase) * v56) + LookVector * (math.cos(v52 * 37 + v.phase) * v56);
        v.part.CFrame = v.start:Lerp(v.target, v55) + v57;
        v.part.Size = v.size * (v55 * 0.8 + 0.2);
    end;
end;

u11 = function(p58) -- Line: 212, Name: updateRetract
    local v59 = (os.clock() - p58.retractingAt) / 0.9;
    local v60 = math.clamp(v59, 0, 1);
    local v61 = v60 * v60;

    for _, v in p58.mound do
        v.part.CFrame = v.target:Lerp(v.start, v61);
        v.part.Size = v.size * (1 - v61 * 0.8);
    end;

    return v60 < 1;
end;

return {
    SurfaceScenes = v3
};