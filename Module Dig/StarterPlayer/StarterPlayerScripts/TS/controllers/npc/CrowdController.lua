-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local ReplicatedStorage = v1.ReplicatedStorage;
local Workspace = v1.Workspace;
local RigFade = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "RigFade").RigFade;
local NpcPreload = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "npc", "NpcPreload").NpcPreload;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Vip");
local VIP_TOURIST_PANTS = v2.VIP_TOURIST_PANTS;
local VIP_TOURIST_SHIRT = v2.VIP_TOURIST_SHIRT;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "npc", "NPCConstants");
local R6_IDLE_ANIM_ID = v3.R6_IDLE_ANIM_ID;
local R6_WALK_ANIM_ID = v3.R6_WALK_ANIM_ID;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local CrowdSim = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "npc", "CrowdSim").CrowdSim;
local getStarterIsland = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "getStarterIsland").getStarterIsland;
local u4 = {
    Color3.fromRGB(255, 204, 158),
    Color3.fromRGB(240, 184, 138),
    Color3.fromRGB(222, 165, 126),
    Color3.fromRGB(198, 134, 88),
    Color3.fromRGB(163, 105, 60),
    Color3.fromRGB(130, 79, 43),
    Color3.fromRGB(89, 55, 34)
};

local function sortedChildren(p5) -- Line: 34
    local v6 = p5:GetChildren();
    table.sort(v6, function(p7, p8) -- Line: 36
        return p7.Name < p8.Name;
    end);

    return v6;
end;

local function createAnimation(p9) -- Line: 41
    local Animation = Instance.new("Animation");
    Animation.AnimationId = `rbxassetid://{p9}`;

    return Animation;
end;

local function createVipShirt() -- Line: 46
    -- upvalues: VIP_TOURIST_SHIRT (copy)
    local Shirt = Instance.new("Shirt");
    Shirt.ShirtTemplate = VIP_TOURIST_SHIRT;

    return Shirt;
end;

local function createVipPants() -- Line: 51
    -- upvalues: VIP_TOURIST_PANTS (copy)
    local Pants = Instance.new("Pants");
    Pants.PantsTemplate = VIP_TOURIST_PANTS;

    return Pants;
end;

local u10 = setmetatable({}, {
    __tostring = function() -- Line: 59, Name: __tostring
        return "CrowdController";
    end
});
u10.__index = u10;

function u10.new(...) -- Line: 64
    -- upvalues: u10 (ref)
    local v11 = setmetatable({}, u10);

    return v11:constructor(...) or v11;
end;

function u10.constructor(p12) -- Line: 68
    -- upvalues: R6_WALK_ANIM_ID (copy), R6_IDLE_ANIM_ID (copy), VIP_TOURIST_SHIRT (copy), VIP_TOURIST_PANTS (copy)
    p12.groundParams = RaycastParams.new();
    p12.fading = {};
    local Animation = Instance.new("Animation");
    Animation.AnimationId = `rbxassetid://{R6_WALK_ANIM_ID}`;
    p12.walkAnimation = Animation;
    local Animation2 = Instance.new("Animation");
    Animation2.AnimationId = `rbxassetid://{R6_IDLE_ANIM_ID}`;
    p12.idleAnimation = Animation2;
    local Shirt = Instance.new("Shirt");
    Shirt.ShirtTemplate = VIP_TOURIST_SHIRT;
    p12.vipShirt = Shirt;
    local Pants = Instance.new("Pants");
    Pants.PantsTemplate = VIP_TOURIST_PANTS;
    p12.vipPants = Pants;
    p12.hidden = false;
    p12.ready = false;
end;

function u10.onStart(u13) -- Line: 78
    task.defer(function() -- Line: 79
        -- upvalues: u13 (copy)
        return u13:preload();
    end);
end;

function u10.preload(p14) -- Line: 83
    -- upvalues: WFChain (copy), ReplicatedStorage (copy), NpcPreload (copy)
    local v15 = WFChain(ReplicatedStorage, "Assets", "NPCs"):GetDescendants();
    local idleAnimation = p14.idleAnimation;
    local vipShirt = p14.vipShirt;
    local vipPants = p14.vipPants;
    table.insert(v15, p14.walkAnimation);
    table.insert(v15, idleAnimation);
    table.insert(v15, vipShirt);
    table.insert(v15, vipPants);
    NpcPreload.preload(v15);
end;

function u10.start(p16) -- Line: 98
    -- upvalues: getStarterIsland (copy), WFChain (copy), Workspace (copy), ReplicatedStorage (copy), CrowdSim (copy)
    if p16.ready then
        return nil;
    end;

    local v17 = getStarterIsland();
    local v18 = WFChain(v17, "WalkArea", "WalkArea");
    local v19 = WFChain(Workspace, "Plots");
    local v20 = WFChain(ReplicatedStorage, "Assets", "NPCs");
    local v21 = WFChain(v20, "Variants");
    local v22 = {
        maleTemplate = WFChain(v20, "MaleRig"),
        femaleTemplate = WFChain(v20, "FemaleRig")
    };
    local v23 = WFChain(v21, "Shirts"):GetChildren();
    table.sort(v23, function(p24, p25) -- Line: 36
        return p24.Name < p25.Name;
    end);
    v22.shirts = v23;
    local v26 = WFChain(v21, "Pants"):GetChildren();
    table.sort(v26, function(p27, p28) -- Line: 36
        return p27.Name < p28.Name;
    end);
    v22.pants = v26;
    local v29 = WFChain(v21, "MaleHair"):GetChildren();
    table.sort(v29, function(p30, p31) -- Line: 36
        return p30.Name < p31.Name;
    end);
    v22.maleHair = v29;
    local v32 = WFChain(v21, "FemaleHair"):GetChildren();
    table.sort(v32, function(p33, p34) -- Line: 36
        return p33.Name < p34.Name;
    end);
    v22.femaleHair = v32;
    p16.area = CrowdSim.areaFromPart(v18);
    p16.pools = v22;
    p16.groundParams.FilterType = Enum.RaycastFilterType.Include;
    p16.groundParams.FilterDescendantsInstances = { v17, v19 };
    p16.groundParams.RespectCanCollide = true;
    local Folder = Instance.new("Folder");
    Folder.Name = "ClientCrowd";
    local v35;

    if p16.hidden then
        v35 = nil;
    else
        v35 = Workspace;
    end;

    Folder.Parent = v35;
    p16.folder = Folder;
    p16.ready = true;
end;

function u10.createRig(p36, p37, p38, p39, p40) -- Line: 126
    if p40 == nil then
        p40 = false;
    end;

    local pools = p36.pools;

    if pools then
        return p36:buildRig(pools, Random.new(p37), p38, p39, p40);
    end;

    return nil;
end;

function u10.buildRig(u41, p42, p43, p44, p45, p46) -- Line: 136
    -- upvalues: u4 (copy)
    local v47 = p43:NextNumber() < 0.5;
    local v48;

    if v47 then
        v48 = p42.maleTemplate;
    else
        v48 = p42.femaleTemplate;
    end;

    local v49;

    if v47 then
        v49 = p42.maleHair;
    else
        v49 = p42.femaleHair;
    end;

    local u50 = v48:Clone();
    u50.Name = p44;
    local HumanoidRootPart = u50:FindFirstChild("HumanoidRootPart");
    local v51 = u50:FindFirstChildOfClass("Humanoid");
    v51.EvaluateStateMachine = false;
    local Animate = u50:FindFirstChild("Animate");

    if Animate ~= nil then
        Animate:Destroy();
    end;

    if p46 then
        u41.vipShirt:Clone().Parent = u50;
        u41.vipPants:Clone().Parent = u50;
    else
        p42.shirts[p43:NextInteger(0, #p42.shirts - 1) + 1]:Clone().Parent = u50;
        p42.pants[p43:NextInteger(0, #p42.pants - 1) + 1]:Clone().Parent = u50;
    end;

    v51:AddAccessory(v49[p43:NextInteger(0, #v49 - 1) + 1]:Clone());
    u41:applySkinTone(u50, u4[p43:NextInteger(0, #u4 - 1) + 1]);
    u41:disableCollisions(u50);
    HumanoidRootPart.Anchored = true;
    u50.DescendantAdded:Connect(function(p52) -- Line: 160
        -- upvalues: u41 (copy)
        if p52:IsA("BasePart") then
            u41:disablePartCollision(p52);
        end;
    end);
    u50.Parent = p45;
    task.defer(function() -- Line: 166
        -- upvalues: u41 (copy), u50 (copy)
        return u41:disableCollisions(u50);
    end);
    local v53 = v51:FindFirstChildOfClass("Animator");

    return {
        yaw = 0,
        groundY = 0,
        targetGroundY = 0,
        sampleX = 0,
        sampleZ = 0,
        blendX = 0,
        blendZ = 0,
        pendingBlend = false,
        lastX = 0,
        lastZ = 0,
        model = u50,
        root = HumanoidRootPart,
        walkTrack = u41:loadTrack(v53, u41.walkAnimation),
        idleTrack = u41:loadTrack(v53, u41.idleAnimation),
        rootOffset = u50:FindFirstChild("Left Leg").Size.Y + HumanoidRootPart.Size.Y / 2
    };
end;

function u10.applySkinTone(p54, p55, p56) -- Line: 188
    local v57 = p55:FindFirstChildOfClass("BodyColors");
    v57.HeadColor3 = p56;
    v57.TorsoColor3 = p56;
    v57.LeftArmColor3 = p56;
    v57.RightArmColor3 = p56;
    v57.LeftLegColor3 = p56;
    v57.RightLegColor3 = p56;
end;

function u10.disablePartCollision(p58, p59) -- Line: 197
    p59.CanCollide = false;
    p59.CanQuery = false;
    p59.CanTouch = false;
    p59.Massless = true;
    p59.CollisionGroup = "Characters";
end;

function u10.disableCollisions(p60, p61) -- Line: 204
    for _, descendant in p61:GetDescendants() do
        if descendant:IsA("BasePart") then
            p60:disablePartCollision(descendant);
        end;
    end;
end;

function u10.loadTrack(p62, p63, p64) -- Line: 211
    local v65 = p63:LoadAnimation(p64);
    v65.Looped = true;

    return v65;
end;

function u10.groundYAt(p66, p67, p68, p69) -- Line: 216
    -- upvalues: Workspace (copy)
    local v70 = p69 + 50 - 150;
    local v71 = p69 + 50;

    for _ = 0, 4 do
        local v72 = Workspace:Raycast(Vector3.new(p67, v71, p68), Vector3.new(0, v70 - v71, 0), p66.groundParams);

        if not v72 then
            return p69;
        end;

        if not p66:isWalkthrough(v72.Instance) then
            return v72.Position.Y;
        end;

        v71 = v72.Position.Y - 0.05;
    end;

    return p69;
end;

function u10.isWalkthrough(p73, p74) -- Line: 231
    -- upvalues: Workspace (copy), CollectionService (copy)
    while p74 and p74 ~= Workspace do
        if CollectionService:HasTag(p74, "NPCWalkthrough") then
            return true;
        end;

        p74 = p74.Parent;
    end;

    return false;
end;

function u10.setHidden(p75, p76) -- Line: 241
    -- upvalues: Workspace (copy)
    p75.hidden = p76;

    if p75.folder then
        local v77;

        if p76 then
            v77 = nil;
        else
            v77 = Workspace;
        end;

        p75.folder.Parent = v77;
    end;
end;

function u10.getArea(p78) -- Line: 247
    return p78.area;
end;

function u10.getFolder(p79) -- Line: 250
    return p79.folder;
end;

function u10.setWalking(p80, p81, p82, p83) -- Line: 253
    if p81.walking ~= p82 then
        p81.walking = p82;

        if p82 then
            p81.idleTrack:Stop();
            p81.walkTrack:Play();
            p81.walkScale = nil;
        else
            p81.walkTrack:Stop();
            p81.idleTrack:Play();
        end;
    end;

    if not p82 or p83 == nil then
        return nil;
    end;

    local v84 = p83 / 16;

    if p81.walkScale ~= v84 then
        p81.walkScale = v84;
        p81.walkTrack:AdjustSpeed(v84);
    end;
end;

function u10.moveRig(p85, p86, p87, p88, p89, p90, p91, p92, p93) -- Line: 274
    if math.abs(p87 - p86.sampleX) > 1.5 or math.abs(p88 - p86.sampleZ) > 1.5 then
        p86.targetGroundY = p85:groundYAt(p87, p88, p92);
        p86.sampleX = p87;
        p86.sampleZ = p88;
    end;

    p86.groundY = p86.groundY + (p86.targetGroundY - p86.groundY) * math.min(p91 * 10, 1);
    p86.yaw = p86.yaw + ((p89 - p86.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(p91 * 8, 1);

    if p86.pendingBlend then
        p86.pendingBlend = false;
        local v94 = p86.root.Position.X - p87;
        local v95 = p86.root.Position.Z - p88;
        local v96 = math.sqrt(v94 * v94 + v95 * v95) <= 8;
        p86.blendX = not v96 and 0 or v94;
        p86.blendZ = not v96 and 0 or v95;
    end;

    local v97 = math.min(p91 * 5, 1);
    p86.blendX = p86.blendX - p86.blendX * v97;
    p86.blendZ = p86.blendZ - p86.blendZ * v97;
    local v98 = CFrame.new(p87 + p86.blendX, p86.groundY + p86.rootOffset, p88 + p86.blendZ);
    local v99 = CFrame.Angles(0, p86.yaw, 0);
    p86.root.CFrame = v98 * v99;
    p86.lastX = p87;
    p86.lastZ = p88;
    p85:setWalking(p86, p90, p93);
end;

function u10.retireRig(p100, p101, p102, p103) -- Line: 301
    -- upvalues: RigFade (copy)
    RigFade.fadeOut(p101.model, p103);
    local v104 = p101.walking == true;
    local fading = p100.fading;
    local v105 = {
        rig = p101,
        x = p101.lastX,
        z = p101.lastZ,
        dirX = not v104 and 0 or -math.sin(p101.yaw),
        dirZ = not v104 and 0 or -math.cos(p101.yaw),
        walking = v104,
        speed = p102,
        expiresAt = os.clock() + p103
    };
    table.insert(fading, v105);
end;

function u10.onRender(p106, p107) -- Line: 317
    if #p106.fading == 0 then
        return nil;
    end;

    local v108 = os.clock();

    for i = #p106.fading - 1, 0, -1 do
        local v109 = p106.fading[i + 1];

        if v109.expiresAt <= v108 then
            v109.rig.model:Destroy();
            local fading = p106.fading;
            local v110 = i + 1;
            local v111 = #fading;

            if fading[v110] ~= nil then
                fading[v110] = fading[v111];
                fading[v111] = nil;
            end;
        else
            local v112 = v109.speed * p107;
            v109.x = v109.x + v109.dirX * v112;
            v109.z = v109.z + v109.dirZ * v112;
            p106:moveRig(v109.rig, v109.x, v109.z, v109.rig.yaw, v109.walking, p107, v109.rig.groundY, v109.speed);
        end;
    end;
end;

Reflect.defineMetadata(u10, "identifier", "client/controllers/npc/CrowdController@CrowdController");
Reflect.defineMetadata(u10, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" });
Reflect.decorate(u10, "$:flamework@Controller", Controller, { {} });

return {
    CrowdController = u10
};