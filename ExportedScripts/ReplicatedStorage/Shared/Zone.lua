-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Heartbeat = RunService.Heartbeat;
local u1 = RunService:IsClient() and Players.LocalPlayer;
game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local enums = require(script.Enum).enums;
local Janitor = require(script.Janitor);
local Signal = require(script.Signal);
local ZonePlusReference = require(script.ZonePlusReference);
local v2 = ZonePlusReference.getObject();
local ZoneController = script.ZoneController;
local Tracker = ZoneController.Tracker;
local CollectiveWorldModel = ZoneController.CollectiveWorldModel;
local u3 = require(ZoneController);
local v4 = game:GetService("RunService"):IsClient() and "Client" or "Server";
local v5;

if v2 then
    v5 = v2:FindFirstChild(v4);
else
    v5 = v2;
end;

if v5 then
    return require(v2.Value);
end;

local u6 = {};
u6.__index = u6;

if not v5 then
    ZonePlusReference.addToReplicatedStorage();
end;

u6.enum = enums;

function u6.new(p7) -- Line: 34
    -- upvalues: u6 (copy), enums (copy), Janitor (copy), HttpService (copy), u3 (copy), Signal (copy), u1 (copy)
    local u8 = {};
    setmetatable(u8, u6);
    local v9 = typeof(p7);

    if v9 ~= "table" and v9 ~= "Instance" then
        error("The zone container must be a model, folder, basepart or table!");
    end;

    u8.accuracy = enums.Accuracy.High;
    u8.autoUpdate = true;
    u8.respectUpdateQueue = true;
    local v10 = Janitor.new();
    u8.janitor = v10;
    u8._updateConnections = v10:add(Janitor.new(), "destroy");
    u8.container = p7;
    u8.zoneParts = {};
    u8.overlapParams = {};
    u8.region = nil;
    u8.volume = nil;
    u8.boundMin = nil;
    u8.boundMax = nil;
    u8.recommendedMaxParts = nil;
    u8.zoneId = HttpService:GenerateGUID();
    u8.activeTriggers = {};
    u8.occupants = {};
    u8.trackingTouchedTriggers = {};
    u8.enterDetection = enums.Detection.Centre;
    u8.exitDetection = enums.Detection.Centre;
    u8._currentEnterDetection = nil;
    u8._currentExitDetection = nil;
    u8.totalPartVolume = 0;
    u8.allZonePartsAreBlocks = true;
    u8.trackedItems = {};
    u8.settingsGroupName = nil;
    u8.worldModel = workspace;
    u8.onItemDetails = {};
    u8.itemsToUntrack = {};
    u3.updateDetection(u8);
    u8.updated = v10:add(Signal.new(), "destroy");
    local v11 = { "player", "part", "localPlayer", "item" };
    local v12 = { "entered", "exited" };

    for _, v in pairs(v11) do
        local u13 = 0;
        local u14 = 0;

        for _, v3 in pairs(v12) do
            local v15 = v10:add(Signal.new(true), "destroy");
            local u16 = v3:sub(1, 1):upper() .. v3:sub(2);
            u8[v .. u16] = v15;
            v15.connectionsChanged:Connect(function(p17) -- Line: 105
                -- upvalues: v (copy), u1 (ref), u16 (copy), u13 (ref), u14 (ref), u3 (ref), u8 (copy)
                if v == "localPlayer" and (not u1 and p17 == 1) then
                    error(("Can only connect to \'localPlayer%s\' on the client!"):format(u16));
                end;

                u13 = u14;
                u14 = u14 + p17;

                if u13 == 0 and u14 > 0 then
                    u3._registerConnection(u8, v, u16);

                    return;
                end;

                if u13 > 0 and u14 == 0 then
                    u3._deregisterConnection(u8, v);
                end;
            end);
        end;
    end;

    u6.touchedConnectionActions = {};

    for _, v in pairs(v11) do
        local u18 = u8[("_%sTouchedZone"):format(v)];

        if u18 then
            u8.trackingTouchedTriggers[v] = {};

            u6.touchedConnectionActions[v] = function(p19) -- Line: 129
                -- upvalues: u18 (copy), u8 (copy)
                u18(u8, p19);
            end;
        end;
    end;

    u8:_update();
    u3._registerZone(u8);
    v10:add(function() -- Line: 140
        -- upvalues: u3 (ref), u8 (copy)
        u3._deregisterZone(u8);
    end, true);

    return u8;
end;

function u6.fromRegion(p20, p21) -- Line: 147
    -- upvalues: u6 (copy)
    local Model = Instance.new("Model");

    local function createCube(p22, p23) -- Line: 150
        -- upvalues: createCube (copy), Model (copy)
        if p23.X <= 2024 and (p23.Y <= 2024 and p23.Z <= 2024) then
            local Part = Instance.new("Part");
            Part.CFrame = p22;
            Part.Size = p23;
            Part.Anchored = true;
            Part.Parent = Model;

            return;
        end;

        local v24 = p23 * 0.25;
        local v25 = p23 * 0.5;
        createCube(p22 * CFrame.new(-v24.X, -v24.Y, -v24.Z), v25);
        createCube(p22 * CFrame.new(-v24.X, -v24.Y, v24.Z), v25);
        createCube(p22 * CFrame.new(-v24.X, v24.Y, -v24.Z), v25);
        createCube(p22 * CFrame.new(-v24.X, v24.Y, v24.Z), v25);
        createCube(p22 * CFrame.new(v24.X, -v24.Y, -v24.Z), v25);
        createCube(p22 * CFrame.new(v24.X, -v24.Y, v24.Z), v25);
        createCube(p22 * CFrame.new(v24.X, v24.Y, -v24.Z), v25);
        createCube(p22 * CFrame.new(v24.X, v24.Y, v24.Z), v25);
    end;

    createCube(p20, p21);
    local v26 = u6.new(Model);
    v26:relocate();

    return v26;
end;

function u6._calculateRegion(p27, p28, p29) -- Line: 179
    local v30 = {
        Min = {},
        Max = {}
    };

    for i, v in pairs(v30) do
        v.Values = {};

        function v.parseCheck(p31, p32) -- Line: 183
            -- upvalues: i (copy)
            if i == "Min" then
                return p31 <= p32;
            end;

            if i == "Max" then
                return p32 <= p31;
            end;
        end;

        function v.parse(p33, p34) -- Line: 190
            for i2, v3 in pairs(p34) do
                if p33.parseCheck(v3, p33.Values[i2] or v3) then
                    p33.Values[i2] = v3;
                end;
            end;
        end;
    end;

    for _, v in pairs(p28) do
        local v35 = v.Size * 0.5;
        local v36 = {
            v.CFrame * CFrame.new(-v35.X, -v35.Y, -v35.Z),
            v.CFrame * CFrame.new(-v35.X, -v35.Y, v35.Z),
            v.CFrame * CFrame.new(-v35.X, v35.Y, -v35.Z),
            v.CFrame * CFrame.new(-v35.X, v35.Y, v35.Z),
            v.CFrame * CFrame.new(v35.X, -v35.Y, -v35.Z),
            v.CFrame * CFrame.new(v35.X, -v35.Y, v35.Z),
            v.CFrame * CFrame.new(v35.X, v35.Y, -v35.Z),
            v.CFrame * CFrame.new(v35.X, v35.Y, v35.Z)
        };

        for _, v3 in pairs(v36) do
            local v37, v38, v39 = v3:GetComponents();
            local v40 = { v37, v38, v39 };
            v30.Min:parse(v40);
            v30.Max:parse(v40);
        end;
    end;

    local function roundToFour(p41) -- Line: 222
        return math.floor((p41 + 2) / 4) * 4;
    end;

    local v42 = {};
    local v43 = {};

    for i, v in pairs(v30) do
        for _, v3 in pairs(v.Values) do
            if not p29 then
                local v3 = math.floor((v3 + (i == "Min" and -2 or 2) + 2) / 4) * 4;
            end;

            table.insert(i == "Min" and v43 and v43 or v42, v3);
        end;
    end;

    local v44 = Vector3.new(unpack(v43));
    local v45 = Vector3.new(unpack(v42));

    return Region3.new(v44, v45), v44, v45;
end;

function u6._displayBounds(p46) -- Line: 245
    if not p46.displayBoundParts then
        p46.displayBoundParts = true;

        for i, v in pairs({
            BoundMin = p46.boundMin,
            BoundMax = p46.boundMax
        }) do
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0.5;
            Part.Size = Vector3.new(1, 1, 1);
            Part.Color = Color3.fromRGB(255, 0, 0);
            Part.CFrame = CFrame.new(v);
            Part.Name = i;
            Part.Parent = workspace;
            p46.janitor:add(Part, "Destroy");
        end;
    end;
end;

function u6._update(u47) -- Line: 264
    -- upvalues: RunService (copy)
    local container = u47.container;
    local v48 = {};
    local u49 = 0;
    u47._updateConnections:clean();
    local v50 = typeof(container);
    local v51 = {};

    if v50 == "table" then
        for _, v in pairs(container) do
            if v:IsA("BasePart") then
                table.insert(v48, v);
            end;
        end;
    elseif v50 == "Instance" then
        if container:IsA("BasePart") then
            table.insert(v48, container);
        else
            table.insert(v51, container);

            for _, descendant in pairs(container:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    table.insert(v48, descendant);
                else
                    table.insert(v51, descendant);
                end;
            end;
        end;
    end;

    u47.zoneParts = v48;
    u47.overlapParams = {};
    local v52 = true;

    for _, v in pairs(v48) do
        local _, result = pcall(function() -- Line: 298
            -- upvalues: v (copy)
            return v.Shape.Name;
        end);

        if result ~= "Block" then
            v52 = false;
        end;
    end;

    u47.allZonePartsAreBlocks = v52;
    local v53 = OverlapParams.new();
    v53.FilterType = Enum.RaycastFilterType.Include;
    v53.MaxParts = #v48;
    v53.FilterDescendantsInstances = v48;
    u47.overlapParams.zonePartsWhitelist = v53;
    local v54 = OverlapParams.new();
    v54.FilterType = Enum.RaycastFilterType.Exclude;
    v54.FilterDescendantsInstances = v48;
    u47.overlapParams.zonePartsIgnorelist = v54;

    local function update() -- Line: 318
        -- upvalues: u47 (copy), u49 (ref), RunService (ref)
        if u47.autoUpdate then
            local u55 = os.clock();

            if u47.respectUpdateQueue then
                u49 = u49 + 1;
                u55 = u55 + 0.1;
            end;

            local u56 = nil;
            u56 = RunService.Heartbeat:Connect(function() -- Line: 326
                -- upvalues: u55 (ref), u56 (ref), u47 (ref), u49 (ref)
                if u55 <= os.clock() then
                    u56:Disconnect();

                    if u47.respectUpdateQueue then
                        u49 = u49 - 1;
                    end;

                    if u49 == 0 and u47.zoneId then
                        u47:_update();
                    end;
                end;
            end);
        end;
    end;

    local function verifyDefaultCollision(p57) -- Line: 340
        local CollisionGroup = p57.CollisionGroup;

        if CollisionGroup ~= "Default" and CollisionGroup ~= "Debris" then
            error("Zone parts must belong to the \'Default\' or \'Debris\' CollisionGroup.");
        end;
    end;

    local v58 = { "Size", "Position" };

    for _, v in pairs(v48) do
        for _, v3 in pairs(v58) do
            u47._updateConnections:add(v:GetPropertyChangedSignal(v3):Connect(update), "Disconnect");
        end;

        local CollisionGroup = v.CollisionGroup;

        if CollisionGroup ~= "Default" and CollisionGroup ~= "Debris" then
            error("Zone parts must belong to the \'Default\' or \'Debris\' CollisionGroup.");
        end;

        u47._updateConnections:add(v:GetPropertyChangedSignal("CollisionGroupId"):Connect(function() -- Line: 352
            -- upvalues: v (copy)
            local CollisionGroup2 = v.CollisionGroup;

            if CollisionGroup2 ~= "Default" and CollisionGroup2 ~= "Debris" then
                error("Zone parts must belong to the \'Default\' or \'Debris\' CollisionGroup.");
            end;
        end), "Disconnect");
    end;

    local v59 = { "ChildAdded", "ChildRemoved" };

    for _, _ in pairs(v51) do
        for _, v in pairs(v59) do
            u47._updateConnections:add(u47.container[v]:Connect(function(p60) -- Line: 359
                -- upvalues: u47 (copy), u49 (ref), RunService (ref)
                if p60:IsA("BasePart") and u47.autoUpdate then
                    local u61 = os.clock();

                    if u47.respectUpdateQueue then
                        u49 = u49 + 1;
                        u61 = u61 + 0.1;
                    end;

                    local u62 = nil;
                    u62 = RunService.Heartbeat:Connect(function() -- Line: 326
                        -- upvalues: u61 (ref), u62 (ref), u47 (ref), u49 (ref)
                        if u61 <= os.clock() then
                            u62:Disconnect();

                            if u47.respectUpdateQueue then
                                u49 = u49 - 1;
                            end;

                            if u49 == 0 and u47.zoneId then
                                u47:_update();
                            end;
                        end;
                    end);
                end;
            end), "Disconnect");
        end;
    end;

    local v63, v64, v65 = u47:_calculateRegion(v48);
    local v66, _, _ = u47:_calculateRegion(v48, true);
    u47.region = v63;
    u47.exactRegion = v66;
    u47.boundMin = v64;
    u47.boundMax = v65;
    local Size = v63.Size;
    u47.volume = Size.X * Size.Y * Size.Z;
    u47:_updateTouchedConnections();
    u47.updated:Fire();
end;

function u6._updateOccupants(p67, p68, p69) -- Line: 395
    local v70 = p67.occupants[p68];

    if not v70 then
        v70 = {};
        p67.occupants[p68] = v70;
    end;

    local v71 = {};

    for i, v in pairs(v70) do
        local v72 = p69[i];

        if v72 == nil or v72 ~= v then
            v70[i] = nil;

            if not v71.exited then
                v71.exited = {};
            end;

            table.insert(v71.exited, i);
        end;
    end;

    for i, _ in pairs(p69) do
        if v70[i] == nil then
            v70[i] = i:IsA("Player") and (i.Character or true) or true;

            if not v71.entered then
                v71.entered = {};
            end;

            table.insert(v71.entered, i);
        end;
    end;

    return v71;
end;

function u6._formTouchedConnection(p73, p74) -- Line: 425
    -- upvalues: Janitor (copy)
    local v75 = "_touchedJanitor" .. p74;
    local v76 = p73[v75];

    if v76 then
        v76:clean();
    else
        p73[v75] = p73.janitor:add(Janitor.new(), "destroy");
    end;

    p73:_updateTouchedConnection(p74);
end;

function u6._updateTouchedConnection(p77, p78) -- Line: 437
    local v79 = p77["_touchedJanitor" .. p78];

    if not v79 then
        return;
    end;

    for _, v in pairs(p77.zoneParts) do
        v79:add(v.Touched:Connect(p77.touchedConnectionActions[p78], p77), "Disconnect");
    end;
end;

function u6._updateTouchedConnections(p80) -- Line: 446
    for i, _ in pairs(p80.touchedConnectionActions) do
        local v81 = p80["_touchedJanitor" .. i];

        if v81 then
            v81:cleanup();
            p80:_updateTouchedConnection(i);
        end;
    end;
end;

function u6._disconnectTouchedConnection(p82, p83) -- Line: 457
    local v84 = "_touchedJanitor" .. p83;
    local v85 = p82[v84];

    if v85 then
        v85:cleanup();
        p82[v84] = nil;
    end;
end;

local function round(p86, p87) -- Line: 466
    return math.round(p86 * 10 ^ p87) * 10 ^ (-p87);
end;

function u6._partTouchedZone(u88, u89) -- Line: 469
    -- upvalues: Janitor (copy), Heartbeat (copy), enums (copy)
    local part = u88.trackingTouchedTriggers.part;

    if part[u89] then
        return;
    end;

    local u90 = 0;
    local u91 = false;
    local Position = u89.Position;
    local u92 = os.clock();
    local u93 = u88.janitor:add(Janitor.new(), "destroy");
    part[u89] = u93;

    if not ({
        Seat = true,
        VehicleSeat = true
    })[u89.ClassName] and ({
        HumanoidRootPart = true
    })[u89.Name] then
        u89.CanTouch = false;
    end;

    local u94 = math.round(u89.Size.X * u89.Size.Y * u89.Size.Z * 100000) * 0.00001;
    u88.totalPartVolume = u88.totalPartVolume + u94;
    u93:add(Heartbeat:Connect(function() -- Line: 487
        -- upvalues: u90 (ref), enums (ref), u88 (copy), u89 (copy), u91 (ref), Position (ref), u92 (ref), u93 (copy)
        local v95 = os.clock();

        if u90 <= v95 then
            local v96 = enums.Accuracy.getProperty(u88.accuracy);
            u90 = v95 + v96;
            local v97 = u88:findPoint(u89.CFrame) or u88:findPart(u89);

            if u91 then
                if not v97 then
                    u91 = false;
                    Position = u89.Position;
                    u92 = os.clock();
                    u88.partExited:Fire(u89);
                end;
            else
                if v97 then
                    u91 = true;
                    u88.partEntered:Fire(u89);

                    return;
                end;

                if (u89.Position - Position).Magnitude > 1.5 and v96 <= v95 - u92 then
                    u93:cleanup();
                end;
            end;
        end;
    end), "Disconnect");
    u93:add(function() -- Line: 518
        -- upvalues: part (copy), u89 (copy), u88 (copy), u94 (copy)
        part[u89] = nil;
        u89.CanTouch = true;
        u88.totalPartVolume = math.round((u88.totalPartVolume - u94) * 100000) * 0.00001;
    end, true);
end;

local u101 = {
    Ball = function(p98) -- Line: 526
        return "GetPartBoundsInRadius", { p98.Position, p98.Size.X };
    end,

    Block = function(p99) -- Line: 529
        return "GetPartBoundsInBox", { p99.CFrame, p99.Size };
    end,

    Other = function(p100) -- Line: 532
        return "GetPartsInPart", { p100 };
    end
};

function u6._getRegionConstructor(p102, u103, p104) -- Line: 536
    -- upvalues: u101 (copy)
    local success, result = pcall(function() -- Line: 537
        -- upvalues: u103 (copy)
        return u103.Shape.Name;
    end);
    local v105 = nil;
    local v106 = nil;

    if success and p102.allZonePartsAreBlocks then
        local v107 = u101[result];

        if v107 then
            v105, v106 = v107(u103);
        end;
    end;

    if not v105 then
        v106 = { u103 };
        v105 = "GetPartsInPart";
    end;

    if p104 then
        table.insert(v106, p104);
    end;

    return v105, v106;
end;

function u6.findLocalPlayer(p108) -- Line: 557
    -- upvalues: u1 (copy)
    if not u1 then
        error("Can only call \'findLocalPlayer\' on the client!");
    end;

    return p108:findPlayer(u1);
end;

function u6._find(p109, p110, p111) -- Line: 564
    -- upvalues: u3 (copy)
    u3.updateDetection(p109);
    local v112 = u3.getTouchingZones(p111, false, p109._currentEnterDetection, u3.trackers[p110]);

    for _, v in pairs(v112) do
        if v == p109 then
            return true;
        end;
    end;

    return false;
end;

function u6.findPlayer(p113, p114) -- Line: 576
    local Character = p114.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character then
        return p113:_find("player", p114.Character);
    end;

    return false;
end;

function u6.findItem(p115, p116) -- Line: 585
    return p115:_find("item", p116);
end;

function u6.findPart(p117, p118) -- Line: 589
    local v119, v120 = p117:_getRegionConstructor(p118, p117.overlapParams.zonePartsWhitelist);
    local v121 = p117.worldModel[v119](p117.worldModel, unpack(v120));

    if #v121 > 0 then
        return true, v121;
    end;

    return false;
end;

function u6.getCheckerPart(p122) -- Line: 599
    -- upvalues: u3 (copy)
    local checkerPart = p122.checkerPart;

    if not checkerPart then
        checkerPart = p122.janitor:add(Instance.new("Part"), "Destroy");
        checkerPart.Size = Vector3.new(0.1, 0.1, 0.1);
        checkerPart.Name = "ZonePlusCheckerPart";
        checkerPart.Anchored = true;
        checkerPart.Transparency = 1;
        checkerPart.CanCollide = false;
        p122.checkerPart = checkerPart;
    end;

    local worldModel = p122.worldModel;

    if worldModel == workspace then
        worldModel = u3.getWorkspaceContainer();
    end;

    if checkerPart.Parent ~= worldModel then
        checkerPart.Parent = worldModel;
    end;

    return checkerPart;
end;

function u6.findPoint(p123, p124) -- Line: 620
    if typeof(p124) == "Vector3" then
        p124 = CFrame.new(p124);
    end;

    local v125 = p123:getCheckerPart();
    v125.CFrame = p124;
    local v126, v127 = p123:_getRegionConstructor(v125, p123.overlapParams.zonePartsWhitelist);
    local v128 = p123.worldModel[v126](p123.worldModel, unpack(v127));

    if #v128 > 0 then
        return true, v128;
    end;

    return false;
end;

function u6._getAll(p129, p130) -- Line: 637
    -- upvalues: u3 (copy)
    u3.updateDetection(p129);
    local v131 = {};
    local v132 = u3._getZonesAndItems(p130, {
        self = true
    }, p129.volume, false, p129._currentEnterDetection)[p129];

    if v132 then
        for i, _ in pairs(v132) do
            table.insert(v131, i);
        end;
    end;

    return v131;
end;

function u6.getPlayers(p133) -- Line: 650
    return p133:_getAll("player");
end;

function u6.getItems(p134) -- Line: 654
    return p134:_getAll("item");
end;

function u6.getParts(p135) -- Line: 658
    local v136 = {};

    if p135.activeTriggers.part then
        for i, _ in pairs(p135.trackingTouchedTriggers.part) do
            table.insert(v136, i);
        end;

        return v136;
    end;

    local v137 = p135.worldModel:GetPartBoundsInBox(p135.region.CFrame, p135.region.Size, p135.overlapParams.zonePartsIgnorelist);

    for _, v in pairs(v137) do
        if p135:findPart(v) then
            table.insert(v136, v);
        end;
    end;

    return v136;
end;

function u6.getRandomPoint(p138) -- Line: 679
    local exactRegion = p138.exactRegion;
    local Size = exactRegion.Size;
    local CFrame2 = exactRegion.CFrame;
    local v139 = Random.new();
    local v140 = nil;
    local v141, v142;

    repeat
        v141 = CFrame2 * CFrame.new(v139:NextNumber(-Size.X / 2, Size.X / 2), v139:NextNumber(-Size.Y / 2, Size.Y / 2), v139:NextNumber(-Size.Z / 2, Size.Z / 2));
        local v143;
        v143, v142 = p138:findPoint(v141);
        v140 = v143 and true or v140;
    until v140;

    return v141.Position, v142;
end;

function u6.setAccuracy(p144, p145) -- Line: 698
    -- upvalues: enums (copy)
    local v146 = tonumber(p145);

    if v146 then
        if not enums.Accuracy.getName(v146) then
            error(("%s is an invalid enumId!"):format(v146));
        end;
    else
        v146 = enums.Accuracy[p145];

        if not v146 then
            error(("\'%s\' is an invalid enumName!"):format(p145));
        end;
    end;

    p144.accuracy = v146;
end;

function u6.setDetection(p147, p148) -- Line: 714
    -- upvalues: enums (copy)
    local v149 = tonumber(p148);

    if v149 then
        if not enums.Detection.getName(v149) then
            error(("%s is an invalid enumId!"):format(v149));
        end;
    else
        v149 = enums.Detection[p148];

        if not v149 then
            error(("\'%s\' is an invalid enumName!"):format(p148));
        end;
    end;

    p147.enterDetection = v149;
    p147.exitDetection = v149;
end;

function u6.trackItem(u150, u151) -- Line: 731
    -- upvalues: Janitor (copy), Tracker (copy)
    local v152 = u151:IsA("BasePart");
    local v153;

    if v152 then
        v153 = false;
    else
        v153 = u151:FindFirstChildOfClass("Humanoid") and u151:FindFirstChild("HumanoidRootPart");
    end;

    assert(v152 or v153, "Only BaseParts or Characters/NPCs can be tracked!");

    if u150.trackedItems[u151] then
        return;
    end;

    if u150.itemsToUntrack[u151] then
        u150.itemsToUntrack[u151] = nil;
    end;

    local v154 = u150.janitor:add(Janitor.new(), "destroy");
    local v155 = {
        janitor = v154,
        item = u151,
        isBasePart = v152,
        isCharacter = v153
    };
    u150.trackedItems[u151] = v155;
    v154:add(u151.AncestryChanged:Connect(function() -- Line: 756
        -- upvalues: u151 (copy), u150 (copy)
        if not u151:IsDescendantOf(game) then
            u150:untrackItem(u151);
        end;
    end), "Disconnect");
    require(Tracker).itemAdded:Fire(v155);
end;

function u6.untrackItem(p156, p157) -- Line: 766
    -- upvalues: Tracker (copy)
    local v158 = p156.trackedItems[p157];

    if v158 then
        v158.janitor:destroy();
    end;

    p156.trackedItems[p157] = nil;
    require(Tracker).itemRemoved:Fire(v158);
end;

function u6.bindToGroup(p159, p160) -- Line: 777
    -- upvalues: u3 (copy)
    p159:unbindFromGroup();
    (u3.getGroup(p160) or u3.setGroup(p160))._memberZones[p159.zoneId] = p159;
    p159.settingsGroupName = p160;
end;

function u6.unbindFromGroup(p161) -- Line: 784
    -- upvalues: u3 (copy)
    if p161.settingsGroupName then
        local v162 = u3.getGroup(p161.settingsGroupName);

        if v162 then
            v162._memberZones[p161.zoneId] = nil;
        end;

        p161.settingsGroupName = nil;
    end;
end;

function u6.relocate(p163) -- Line: 794
    -- upvalues: CollectiveWorldModel (copy)
    if p163.hasRelocated then
        return;
    end;

    local v164 = require(CollectiveWorldModel).setupWorldModel(p163);
    p163.worldModel = v164;
    p163.hasRelocated = true;
    local container = p163.container;

    if typeof(container) == "table" then
        container = Instance.new("Folder");

        for _, v in pairs(p163.zoneParts) do
            v.Parent = container;
        end;
    end;

    p163.relocationContainer = p163.janitor:add(container, "Destroy", "RelocationContainer");
    container.Parent = v164;
end;

function u6._onItemCallback(u165, p166, p167, u168, u169) -- Line: 815
    local v170 = u165.onItemDetails[u168];

    if not v170 then
        v170 = {};
        u165.onItemDetails[u168] = v170;
    end;

    if #v170 == 0 then
        u165.itemsToUntrack[u168] = true;
    end;

    table.insert(v170, u168);
    u165:trackItem(u168);

    local function triggerCallback() -- Line: 827
        -- upvalues: u169 (copy), u165 (copy), u168 (copy)
        u169();

        if u165.itemsToUntrack[u168] then
            u165.itemsToUntrack[u168] = nil;
            u165:untrackItem(u168);
        end;
    end;

    if u165:findItem(u168) == p167 then
        u169();

        if u165.itemsToUntrack[u168] then
            u165.itemsToUntrack[u168] = nil;
            u165:untrackItem(u168);
        end;
    else
        local u171 = nil;
        u171 = u165[p166]:Connect(function(p172) -- Line: 840
            -- upvalues: u171 (ref), u168 (copy), u169 (copy), u165 (copy)
            if u171 and p172 == u168 then
                u171:Disconnect();
                u171 = nil;
                u169();

                if u165.itemsToUntrack[u168] then
                    u165.itemsToUntrack[u168] = nil;
                    u165:untrackItem(u168);
                end;
            end;
        end);
    end;
end;

function u6.onItemEnter(p173, ...) -- Line: 862
    p173:_onItemCallback("itemEntered", true, ...);
end;

function u6.onItemExit(p174, ...) -- Line: 866
    p174:_onItemCallback("itemExited", false, ...);
end;

function u6.destroy(p175) -- Line: 870
    p175:unbindFromGroup();
    p175.janitor:destroy();
end;

u6.Destroy = u6.destroy;

return u6;