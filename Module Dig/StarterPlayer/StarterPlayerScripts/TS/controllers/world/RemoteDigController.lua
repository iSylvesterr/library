-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local Players = v1.Players;
local ReplicatedStorage = v1.ReplicatedStorage;
local TweenService = v1.TweenService;
local Workspace = v1.Workspace;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local rarityStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "RarityStyles").rarityStyleFor;
local ShovelEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ShovelNetwork").ShovelEvents;
local RarityBeams = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "RarityBeams").RarityBeams;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "DiggingConfig");
local DIG_EXCLAMATION_ENABLED = v2.DIG_EXCLAMATION_ENABLED;
local DIG_PROGRESS_START = v2.DIG_PROGRESS_START;
local DIG_WIN_THRESHOLD = v2.DIG_WIN_THRESHOLD;
local MOUND_MIN_RADIUS = v2.MOUND_MIN_RADIUS;
local moundRadiusFor = v2.moundRadiusFor;
local DIG_ZONE_TAG = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").DIG_ZONE_TAG;
local dirtFor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "DirtTypes").dirtFor;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local itemNameFor = v3.itemNameFor;
local Items = v3.Items;
local CFrameUtils = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "cframe", "CFrameUtils").CFrameUtils;
local digZoneAt = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DigZoneSpawn").digZoneAt;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local ItemModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "items", "ItemModel").ItemModel;
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtCoat");
local DirtCoat = v4.DirtCoat;
local TOOL_DIRT = v4.TOOL_DIRT;
local PassThroughTag = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "PassThroughTag").PassThroughTag;
local u5 = setmetatable({}, {
    __tostring = function() -- Line: 56, Name: __tostring
        return "RemoteDigController";
    end
});
u5.__index = u5;

function u5.new(...) -- Line: 61
    -- upvalues: u5 (ref)
    local v6 = setmetatable({}, u5);

    return v6:constructor(...) or v6;
end;

function u5.constructor(p7) -- Line: 65
    p7.scenes = {};
end;

function u5.onStart(u8) -- Line: 68
    -- upvalues: ShovelEvents (copy), Players (copy)
    ShovelEvents.DigSceneStart:connect(function(p9, p10, p11, p12, p13, p14) -- Line: 69
        -- upvalues: u8 (copy)
        return u8:startScene(p9, p10, p11, p12, p13, p14 == true);
    end);
    ShovelEvents.DigSceneProgress:connect(function(p15, p16) -- Line: 72
        -- upvalues: u8 (copy)
        return u8:setProgress(p15, p16);
    end);
    ShovelEvents.DigSceneEnd:connect(function(p17, p18) -- Line: 75
        -- upvalues: u8 (copy)
        return u8:endScene(p17, p18);
    end);
    Players.PlayerRemoving:Connect(function(p19) -- Line: 78
        -- upvalues: u8 (copy)
        return u8:cleanup(p19.UserId);
    end);
end;

function u5.onRender(p20, p21) -- Line: 82
    for _, v in p20.scenes do
        if v.ready then
            if v.phase == "digging" then
                v.energy = math.max(0, v.energy - 2.6 * p21);
                v.displayedProgress = v.displayedProgress + (v.targetProgress - v.displayedProgress) * (1 - math.exp(-13 * p21));
                p20:updateDomeMound(v, p21);
                p20:updateItemPosition(v);
            elseif v.phase == "loss" then
                p20:updateLoss(v);
            end;
        end;
    end;
end;

function u5.startScene(u22, u23, u24, u25, p26, p27, p28) -- Line: 97
    -- upvalues: Player (copy), Items (copy), Players (copy), Janitor (copy), dirtFor (copy), MOUND_MIN_RADIUS (copy), DIG_PROGRESS_START (copy), RarityBeams (copy)
    if u23 == Player.UserId or Items[u24] == nil then
        return nil;
    end;

    u22:cleanup(u23);
    local u29 = Players:GetPlayerByUserId(u23);

    if u29 ~= nil then
        u29 = u29.Character;
    end;

    if not u29 then
        return nil;
    end;

    local v30 = Janitor.new();
    u22.scenes[u23] = {
        root = nil,
        area = nil,
        ready = false,
        phase = "digging",
        moundTarget = 1,
        energy = 0,
        finishStarted = 0,
        destroyed = false,
        janitor = v30,
        userId = u23,
        character = u29,
        surfaceCFrame = CFrame.identity,
        dirt = dirtFor(u24),
        surfacedPosition = p27,
        publicSurface = p28,
        mound = {},
        moundProgress = p28 and 1 or 0,
        moundRadius = MOUND_MIN_RADIUS,
        displayedProgress = DIG_PROGRESS_START,
        targetProgress = DIG_PROGRESS_START
    };
    task.spawn(function() -- Line: 137
        -- upvalues: u29 (copy), u22 (copy), u23 (copy), u24 (copy), u25 (copy), RarityBeams (ref), Items (ref)
        local HumanoidRootPart = u29:WaitForChild("HumanoidRootPart", 5);
        local v31 = u22.scenes[u23];
        local v32 = not v31 or v31.character ~= u29;

        if not v32 then
            local v33;

            if HumanoidRootPart == nil then
                v33 = HumanoidRootPart;
            else
                v33 = HumanoidRootPart:IsA("BasePart");
            end;

            v32 = not v33;
        end;

        if v32 then
            u22:cleanup(u23);

            return nil;
        end;

        local v34 = u22:findZone(HumanoidRootPart);

        if not v34 then
            u22:cleanup(u23);

            return nil;
        end;

        v31.root = HumanoidRootPart;
        v31.area = v34;

        if not u22:buildScene(v31, u24, u25) then
            u22:cleanup(u23);

            return nil;
        end;

        v31.ready = true;

        if v31.pendingEnd ~= nil then
            u22:endScene(u23, v31.pendingEnd);

            return nil;
        end;

        if v31.digPoint and (v31.itemSize and not v31.publicSurface) then
            v31.beams = RarityBeams.create(v31.digPoint, Items[u24].rarity, v31.itemSize, v31.janitor);
        end;

        u22:showExclamation(v31, Items[u24].rarity);
    end);
end;

function u5.setProgress(p35, p36, p37) -- Line: 176
    local v38 = p35.scenes[p36];

    if not v38 or v38.phase ~= "digging" then
        return nil;
    end;

    if v38.targetProgress < p37 then
        v38.energy = math.min(1, v38.energy + 0.4);
    end;

    v38.targetProgress = p37;
end;

function u5.endScene(p39, p40, p41) -- Line: 188
    local v42 = p39.scenes[p40];

    if not v42 or v42.phase ~= "digging" then
        return nil;
    end;

    if not v42.ready then
        v42.pendingEnd = p41;

        return nil;
    end;

    if p41 then
        p39:playSuccess(v42);

        return;
    end;

    p39:playLoss(v42);
end;

function u5.buildScene(p43, p44, p45, p46) -- Line: 205
    -- upvalues: ReplicatedStorage (copy), Items (copy), ItemModel (copy), itemNameFor (copy), Workspace (copy), CFrameUtils (copy), TOOL_DIRT (copy), DirtCoat (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets ~= nil then
        Assets = Assets:FindFirstChild("Items");

        if Assets ~= nil then
            Assets = Assets:FindFirstChild(Items[p45].displayName);
        end;
    end;

    local v47;

    if Assets == nil then
        v47 = Assets;
    else
        v47 = Assets:IsA("Tool");
    end;

    if not v47 then
        return false;
    end;

    local u48 = ItemModel.build(Assets, p45, p46);
    local v49;

    if u48 == nil then
        v49 = u48;
    else
        v49 = u48.PrimaryPart;
    end;

    if not (u48 and v49) then
        return false;
    end;

    for _, descendant in u48:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = true;
            descendant.CanTouch = false;
        end;
    end;

    local v50, v51 = u48:GetBoundingBox();
    v49.PivotOffset = v49.PivotOffset * CFrame.new(u48:GetPivot():ToObjectSpace(v50).Position);
    u48.Name = itemNameFor(p45, p46);
    u48.Parent = Workspace;
    p44.janitor:Add(u48, "Destroy");
    p44.item = u48;
    p44.itemRoot = v49;
    p44.itemSize = v51;
    local v52;

    if p44.surfacedPosition == nil then
        v52 = p43:computeDigSurface(p44, math.max(v51.X, v51.Z) * 0.5);
    else
        v52 = p43:computeFixedDigSurface(p44, p44.surfacedPosition);
    end;

    p44.digPoint = v52;
    local UpVector = p44.surfaceCFrame.UpVector;
    local v53 = CFrameUtils.emergeOrientation(UpVector, v51);
    local v54 = math.max(v51.X, v51.Y, v51.Z) * 0.5;
    local v55 = UpVector * (v54 + math.max(0.45, (v51.X + v51.Y + v51.Z) / 3 * 0.08));
    p44.buriedCFrame = CFrame.new(v52 - v55) * v53;
    p44.emergedCFrame = CFrame.new(v52 + UpVector * (v54 + 0.15)) * v53;
    u48:PivotTo(p44.buriedCFrame);
    local v56 = table.clone(TOOL_DIRT);
    setmetatable(v56, nil);
    v56.weld = true;
    v56.canQuery = false;
    v56.color = p44.dirt.color;
    v56.colorJitter = p44.dirt.colorJitter;
    v56.material = p44.dirt.material;

    function v56.onComplete() -- Line: 271
        -- upvalues: u48 (copy)
        for _, descendant in u48:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.CanQuery = false;
            end;
        end;
    end;

    DirtCoat.coat(u48, v56);
    p43:createMound(p44, v52, v51);

    return true;
end;

function u5.computeDigSurface(p57, p58, p59) -- Line: 282
    -- upvalues: Workspace (copy)
    local area = p58.area;
    local v60 = area.CFrame:PointToObjectSpace(p58.root.Position + p58.root.CFrame.LookVector * 4.5);
    local v61 = area.Size * 0.5;
    local v62 = math.min(p59, v61.X * 0.5);
    local v63 = math.min(p59, v61.Z * 0.5);
    local CFrame2 = area.CFrame;
    local v64 = math.clamp(v60.X, -v61.X + v62, v61.X - v62);
    local Y = v61.Y;
    local v65 = math.clamp(v60.Z, -v61.Z + v63, v61.Z - v63);
    local v66 = CFrame2:PointToWorldSpace((Vector3.new(v64, Y, v65)));
    local v67 = RaycastParams.new();
    v67.FilterType = Enum.RaycastFilterType.Exclude;
    v67.IgnoreWater = true;
    local v68;

    if p58.item then
        v68 = { p58.character, area, p58.item };
    else
        v68 = { p58.character, area };
    end;

    v67.FilterDescendantsInstances = v68;
    local v69 = Workspace:Raycast(v66 + Vector3.new(0, 24, 0), Vector3.new(0, -96, 0), v67);

    if v69 then
        v66 = v69.Position;
    end;

    local v70;

    if v69 then
        v70 = v69.Normal;
    else
        v70 = area.CFrame.UpVector;
    end;

    local LookVector = p58.root.CFrame.LookVector;
    local v71 = LookVector - v70 * LookVector:Dot(v70);

    if v71.Magnitude < 0.01 then
        local LookVector2 = area.CFrame.LookVector;
        v71 = LookVector2 - v70 * LookVector2:Dot(v70);
    end;

    p58.surfaceCFrame = CFrame.lookAt(v66, v66 + (v71.Magnitude < 0.01 and Vector3.new(0, 0, 1) or v71).Unit, v70);

    return v66;
end;

function u5.computeFixedDigSurface(p72, p73, p74) -- Line: 320
    -- upvalues: CollectionService (copy), DIG_ZONE_TAG (copy), Workspace (copy)
    local v75 = RaycastParams.new();
    v75.FilterType = Enum.RaycastFilterType.Exclude;
    v75.IgnoreWater = true;
    local v76 = { p73.character };
    local v77 = #v76;
    local v78 = CollectionService:GetTagged(DIG_ZONE_TAG);
    local v79 = #v78;
    table.move(v78, 1, v79, v77 + 1, v76);
    local v80 = p73.item and { p73.item } or {};
    table.move(v80, 1, #v80, v77 + v79 + 1, v76);
    v75.FilterDescendantsInstances = v76;
    local v81 = Workspace:Raycast(p74 + Vector3.new(0, 24, 0), Vector3.new(0, -96, 0), v75);
    local v82;

    if v81 then
        v82 = v81.Normal;
    else
        v82 = p73.area.CFrame.UpVector;
    end;

    local v83 = p74 - p73.root.Position;
    local v84 = v83 - v82 * v83:Dot(v82);

    if v84.Magnitude < 0.01 then
        local LookVector = p73.root.CFrame.LookVector;
        v84 = LookVector - v82 * LookVector:Dot(v82);
    end;

    p73.surfaceCFrame = CFrame.lookAt(p74, p74 + (v84.Magnitude < 0.01 and Vector3.new(0, 0, 1) or v84).Unit, v82);

    return p74;
end;

function u5.createMound(p85, p86, p87, p88) -- Line: 361
    -- upvalues: moundRadiusFor (copy), PassThroughTag (copy), Workspace (copy)
    local v89 = moundRadiusFor(p88);
    local v90 = math.floor(v89 * 6);
    local v91 = math.clamp(v90, 12, 30);
    p86.moundRadius = v89;
    local UpVector = p86.surfaceCFrame.UpVector;
    local RightVector = p86.surfaceCFrame.RightVector;
    local LookVector = p86.surfaceCFrame.LookVector;
    local v92 = false;
    local v93 = 0;

    while true do
        if v92 then
            v93 = v93 + 1;
        else
            v92 = true;
        end;

        if v93 >= v91 then
            return;
        end;

        local v94 = math.random() * 3.141592653589793 * 2;
        local v95 = math.random();
        local v96 = v89 * math.sqrt(v95);
        local v97 = 0.34 + math.random() * math.min(0.72, v89 * 0.25);
        local v98 = 0.24 + math.random() * 0.42;
        local v99 = v97 * (0.7 + math.random() * 0.6);
        local v100 = Vector3.new(v97, v98, v99);
        local v101 = RightVector * (math.cos(v94) * v96);
        local v102 = LookVector * (math.sin(v94) * v96);
        local v103 = CFrame.new(p87 + v101 + v102 + UpVector * (v100.Y * 0.32)) * CFrame.Angles((math.random() - 0.5) * 0.35, math.random() * 3.141592653589793 * 2, (math.random() - 0.5) * 0.35);
        local Part = Instance.new("Part");
        Part.Size = v100 * 0.2;
        Part.Material = p86.dirt.material;
        Part.Color = p86.dirt.color:Lerp(Color3.new(), math.random() * 0.12);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.CFrame = v103 - UpVector * (v100.Y + 0.45);
        PassThroughTag.applyToPart(Part);
        Part.Parent = Workspace;
        p86.janitor:Add(Part, "Destroy");
        local mound = p86.mound;
        local v104 = {
            part = Part,
            start = Part.CFrame,
            target = v103,
            size = v100,
            phase = math.random() * 3.141592653589793 * 2,
            revealAt = v93 / v91 * 0.82
        };
        table.insert(mound, v104);
    end;
end;

function u5.updateDomeMound(p105, p106, p107) -- Line: 423
    local v108 = math.min(p107, 0.1) * -40;
    local v109 = 1 - math.exp(v108);
    p106.moundProgress = p106.moundProgress + (p106.moundTarget - p106.moundProgress) * v109;
    local moundProgress = p106.moundProgress;
    local RightVector = p106.surfaceCFrame.RightVector;
    local LookVector = p106.surfaceCFrame.LookVector;

    for _, v in p106.mound do
        local v110 = math.clamp((moundProgress - v.revealAt) / (1 - v.revealAt), 0, 1);
        local v111 = 1 - (1 - v110) ^ 3;
        local v112 = math.sin(v110 * 3.141592653589793) * 0.035;
        local v113 = os.clock() * 42 + v.phase;
        local v114 = RightVector * (math.sin(v113) * v112);
        local v115 = os.clock() * 37 + v.phase;
        local v116 = v114 + LookVector * (math.cos(v115) * v112);
        v.part.CFrame = v.start:Lerp(v.target, v111) + v116;
        v.part.Size = v.size * (v111 * 0.8 + 0.2);
    end;
end;

function u5.updateItemPosition(p117, p118) -- Line: 444
    -- upvalues: DIG_PROGRESS_START (copy), DIG_WIN_THRESHOLD (copy)
    local item = p118.item;
    local buriedCFrame = p118.buriedCFrame;
    local emergedCFrame = p118.emergedCFrame;

    if not (item and (buriedCFrame and emergedCFrame)) then
        return nil;
    end;

    local v119 = math.clamp((p118.displayedProgress - DIG_PROGRESS_START) / (DIG_WIN_THRESHOLD - DIG_PROGRESS_START), 0, 1);
    local v120 = math.pow(v119, 1.25);
    local v121 = 7 + p118.energy * 8;
    local v122 = v120 * (0.015 + p118.energy * 0.05);
    local v123 = v120 * math.rad(1 + p118.energy * 3.5);
    local v124 = os.clock();
    local RightVector = p118.surfaceCFrame.RightVector;
    local v125 = math.sin(v124 * v121) * v122;
    local UpVector = p118.surfaceCFrame.UpVector;
    local v126 = math.sin(v124 * v121 * 1.37);
    local v127 = math.abs(v126) * v122 * 0.45;
    item:PivotTo((buriedCFrame:Lerp(emergedCFrame, v120) + (RightVector * v125 + UpVector * v127)) * CFrame.Angles(math.sin(v124 * v121 * 0.83) * v123, 0, math.sin(v124 * v121) * v123));
end;

function u5.showExclamation(u128, u129, p130) -- Line: 466
    -- upvalues: DIG_EXCLAMATION_ENABLED (copy), WFChain (copy), ReplicatedStorage (copy), rarityStyleFor (copy), TweenService (copy)
    if not DIG_EXCLAMATION_ENABLED then
        return nil;
    end;

    local Head = u129.character:WaitForChild("Head", 5);
    local destroyed = u129.destroyed;

    if not destroyed then
        local v131;

        if Head == nil then
            v131 = Head;
        else
            v131 = Head:IsA("BasePart");
        end;

        destroyed = not v131;
    end;

    if destroyed then
        return nil;
    end;

    local u132 = WFChain(ReplicatedStorage, "Assets", "WorldUI", "ExclamationPoint"):Clone();
    local Size = u132.Size;
    local u133 = WFChain(u132, "Frame", "Image");
    u133.ImageColor3 = rarityStyleFor(p130).color;
    u133.Rotation = -18;
    u132.Size = UDim2.fromScale(0, 0);
    u132.Adornee = Head;
    u132.Parent = Head;
    u129.janitor:Add(u132, "Destroy");
    local v134 = TweenService:Create(u132, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = Size
    });
    local v135 = TweenService:Create(u133, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Rotation = 13
    });
    u129.janitor:Add(v134, "Cancel");
    u129.janitor:Add(v135, "Cancel");
    v134:Play();
    v135:Play();
    task.delay(0.18, function() -- Line: 501
        -- upvalues: u128 (copy), u129 (copy), u132 (copy), u133 (copy)
        return u128:setExclamationRotation(u129, u132, u133, -7, 0.14);
    end);
    task.delay(0.32, function() -- Line: 504
        -- upvalues: u128 (copy), u129 (copy), u132 (copy), u133 (copy)
        return u128:setExclamationRotation(u129, u132, u133, 0, 0.2);
    end);
    task.delay(1.1, function() -- Line: 507
        -- upvalues: u132 (copy), TweenService (ref)
        if not u132.Parent then
            return nil;
        end;

        local v136 = TweenService:Create(u132, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromScale(0, 0)
        });
        v136.Completed:Once(function() -- Line: 514
            -- upvalues: u132 (ref)
            return u132:Destroy();
        end);
        v136:Play();
    end);
end;

function u5.setExclamationRotation(p137, p138, p139, p140, p141, p142) -- Line: 520
    -- upvalues: TweenService (copy)
    if not p139.Parent then
        return nil;
    end;

    local v143 = TweenService:Create(p140, TweenInfo.new(p142, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = p141
    });
    p138.janitor:Add(v143, "Cancel");
    v143:Play();
end;

function u5.playSuccess(u144, u145) -- Line: 530
    local item = u145.item;
    local itemRoot = u145.itemRoot;

    if not (item and itemRoot) then
        u144:cleanupScene(u145);

        return nil;
    end;

    u145.phase = "success";
    local beams = u145.beams;

    if beams ~= nil then
        beams:fadeOut();
    end;

    u144:sinkMound(u145);

    for _, descendant in item:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "Characters";
            descendant.Anchored = false;
            descendant.CanTouch = false;
        end;
    end;

    itemRoot.CanCollide = true;
    itemRoot.AssemblyLinearVelocity = u145.root.CFrame.LookVector * -6 + u145.surfaceCFrame.UpVector * 14;
    local v146 = (math.random() - 0.5) * 7;
    local v147 = (math.random() - 0.5) * 9;
    local v148 = (math.random() - 0.5) * 7;
    itemRoot.AssemblyAngularVelocity = Vector3.new(v146, v147, v148);
    task.delay(2.2, function() -- Line: 556
        -- upvalues: u144 (copy), u145 (copy)
        return u144:cleanupScene(u145);
    end);
end;

function u5.playLoss(p149, p150) -- Line: 560
    p150.phase = "loss";
    p150.finishStarted = os.clock();
    local item = p150.item;

    if item ~= nil then
        item = item:GetPivot();
    end;

    p150.lossStartCFrame = item;
    local beams = p150.beams;

    if beams ~= nil then
        beams:fadeOut();
    end;

    p149:sinkMound(p150);
end;

function u5.updateLoss(p151, p152) -- Line: 574
    local v153 = (os.clock() - p152.finishStarted) / 0.7;
    local v154 = math.clamp(v153, 0, 1);

    if p152.item and (p152.lossStartCFrame and p152.buriedCFrame) then
        p152.item:PivotTo(p152.lossStartCFrame:Lerp(p152.buriedCFrame - p152.surfaceCFrame.UpVector * 1.5, v154 * v154));
    end;

    if v154 >= 1 then
        p151:cleanupScene(p152);
    end;
end;

function u5.sinkMound(p155, p156) -- Line: 586
    -- upvalues: TweenService (copy)
    local UpVector = p156.surfaceCFrame.UpVector;

    for _, v in p156.mound do
        local v157 = TweenService:Create(v.part, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            CFrame = v.target - UpVector * (v.size.Y + 0.7),
            Size = v.size * 0.2
        });
        p156.janitor:Add(v157, "Cancel");
        v157:Play();
    end;
end;

function u5.findZone(p158, p159) -- Line: 603
    -- upvalues: digZoneAt (copy)
    return digZoneAt(p159.Position);
end;

function u5.cleanup(p160, p161) -- Line: 606
    local v162 = p160.scenes[p161];

    if v162 then
        p160:cleanupScene(v162);
    end;
end;

function u5.cleanupScene(p163, p164) -- Line: 614
    if p164.destroyed then
        return nil;
    end;

    p164.destroyed = true;

    if p163.scenes[p164.userId] == p164 then
        p163.scenes[p164.userId] = nil;
    end;

    p164.janitor:Destroy();
end;

Reflect.defineMetadata(u5, "identifier", "client/controllers/world/RemoteDigController@RemoteDigController");
Reflect.defineMetadata(u5, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" });
Reflect.decorate(u5, "$:flamework@Controller", Controller, { {} });

return {
    RemoteDigController = u5
};