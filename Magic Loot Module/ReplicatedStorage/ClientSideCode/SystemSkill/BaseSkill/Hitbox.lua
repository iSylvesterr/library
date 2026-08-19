-- Decompiled with Potassium's decompiler.

require(game.ReplicatedFirst.AllSideCode.Class.Class);
local HitQueryContext = require(script.Parent.HitQueryContext);
local HitboxDebug = require(game.ReplicatedFirst.AllSideCode.ToolSystem.HitboxDebug);
local HitboxLogicConfig = require(script.Parent.HitboxLogicConfig);
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Hitbox = game.ReplicatedStorage.ModelRes.Hitbox;
local u1 = OverlapParams.new();
u1.CollisionGroup = "Hitbox";
local u2 = {
    Player = {
        Enemy = true,
        Summon = true
    },
    Mirror = {
        Enemy = true,
        Summon = true
    },
    NPC = {
        Player = true,
        Summon = true
    },
    Summon = {
        Enemy = true
    }
};
local u3 = CFrame.new(0, -5000, 0);

local function matchesTargetGroup(p4, p5) -- Line: 46
    return p5 == "Broken" and true or p4[p5] == true;
end;

local function radiusFromSize(p6) -- Line: 50
    return math.max(p6.X, p6.Y, p6.Z) * 0.5;
end;

local function resolveDetectionMode(p7) -- Line: 60
    -- upvalues: HitboxLogicConfig (copy)
    if not HitboxLogicConfig.enabled then
        return true, nil;
    end;

    if HitboxLogicConfig.FORCE_PART_BY_NAME[p7] then
        return true, nil;
    end;

    local v8 = HitboxLogicConfig.LOGIC_SHAPE_BY_PART_NAME[p7];

    if v8 == "Ball" or v8 == "Block" then
        return false, v8;
    end;

    return true, nil;
end;

local function createLogicProxy(u9) -- Line: 79
    return setmetatable({}, {
        __index = function(p10, p11) -- Line: 90, Name: __index
            -- upvalues: u9 (copy)
            if p11 == "Position" then
                return u9.cframe.Position;
            end;

            if p11 == "CFrame" then
                return u9.cframe;
            end;

            if p11 == "Size" then
                return u9.size;
            end;

            if p11 == "Shape" then
                return u9.shapeEnum;
            end;

            if p11 == "Parent" then
                return nil;
            end;

            if p11 == "_logicDestroyed" then
                return u9.destroyed == true;
            end;

            if p11 == "Transparency" then
                return 1;
            end;

            if p11 == "Name" then
                return u9.name;
            end;

            if p11 == "CanCollide" or (p11 == "CanTouch" or p11 == "CanQuery") then
                return false;
            end;

            return p11 == "CollisionGroup" and "Hitbox" or (p11 == "PivotTo" and function(p12, p13) -- Line: 113
                -- upvalues: u9 (ref)
                if u9.destroyed then
                    return;
                end;

                u9.cframe = p13;
            end or (p11 == "IsA" and function(p14, p15) -- Line: 120
                return false;
            end or (p11 == "Destroy" and function() -- Line: 124
                -- upvalues: u9 (ref)
                u9.destroyed = true;
            end or (p11 == "GetPivot" and function() -- Line: 128
                -- upvalues: u9 (ref)
                return u9.cframe;
            end or nil))));
        end,

        __newindex = function(p16, p17, p18) -- Line: 134, Name: __newindex
            -- upvalues: u9 (copy)
            if p17 == "Size" then
                u9.size = p18;
                u9.radius = math.max(p18.X, p18.Y, p18.Z) * 0.5;

                return;
            end;

            if p17 == "CFrame" then
                u9.cframe = p18;

                return;
            end;

            if p17 == "Shape" then
                u9.shapeEnum = p18;

                if p18 == Enum.PartType.Ball then
                    u9.logicShape = "Ball";
                    local size = u9.size;
                    u9.radius = math.max(size.X, size.Y, size.Z) * 0.5;

                    return;
                end;

                if p18 == Enum.PartType.Block then
                    u9.logicShape = "Block";
                end;
            else
                if p17 == "Name" then
                    u9.name = p18;

                    return;
                end;

                if p17 ~= "Transparency" and (p17 ~= "Parent" and (p17 ~= "CanCollide" and (p17 ~= "CanTouch" and (p17 ~= "CanQuery" and (p17 ~= "CollisionGroup" and (p17 ~= "Color" and p17 == "Material")))))) then
                end;
            end;
        end
    });
end;

local u19 = {};
u19.__index = u19;

function u19.buildObstacleIgnoreList(...) -- Line: 177
    local v20 = {};

    for i = 1, select("#", ...) do
        local v21 = select(i, ...);

        if typeof(v21) == "Instance" then
            table.insert(v20, v21);
        end;
    end;

    return v20;
end;

function u19.isPhysicalPart(p22) -- Line: 193
    local v23;

    if typeof(p22) == "Instance" then
        v23 = p22:IsA("BasePart");
    else
        v23 = false;
    end;

    return v23;
end;

function u19.new(p24) -- Line: 202
    -- upvalues: HitboxLogicConfig (copy), u19 (copy), u2 (copy), Hitbox (copy), HitboxDebug (copy), u3 (copy), createLogicProxy (copy)
    local PartName = p24.PartName;
    local v25, v26;

    if HitboxLogicConfig.enabled and not HitboxLogicConfig.FORCE_PART_BY_NAME[PartName] then
        v25 = HitboxLogicConfig.LOGIC_SHAPE_BY_PART_NAME[PartName];

        if v25 == "Ball" or v25 == "Block" then
            v26 = false;
        else
            v26 = true;
            v25 = nil;
        end;
    else
        v26 = true;
        v25 = nil;
    end;

    local v27 = setmetatable({}, u19);
    v27.hitboxOwnerId = p24.hitboxOwnerId;
    v27.hitboxOwnerType = p24.hitboxOwnerType;
    v27.hitboxIndex = p24.hitboxIndex;
    v27.skillName = p24.skillName;
    v27.skillID = p24.skillID;
    v27.combatSeed = p24.combatSeed;
    v27._hitCounter = 0;
    v27.hitHistory = {};
    v27._activationHitCount = 0;
    v27.hitPolicy = p24.hitPolicy or nil;
    v27.partName = PartName;
    v27._usePhysicalPart = v26;
    v27._debugVisualPart = nil;
    v27.targetCollisionGroups = u2[v27.hitboxOwnerType];

    if not v27.targetCollisionGroups then
        error("不支持的 hitboxOwnerType: " .. tostring(v27.hitboxOwnerType));
    end;

    v27.checkedParts = {};
    v27.isActive = false;
    v27.hitEffectName = p24.EffectName;
    v27.hitSoundName = p24.SoundName;
    v27.hitSuppressPresentation = p24.SuppressHitPresentation == true;
    v27.hitPhysicsEffectName = p24.PhysicsEffectName;

    if not v26 then
        local v28;

        if v25 == "Ball" then
            v28 = Enum.PartType.Ball;
        else
            v28 = Enum.PartType.Block;
        end;

        local v29 = {
            size = Vector3.new(1, 1, 1),
            destroyed = false,
            cframe = u3,
            radius = 0.5,
            logicShape = v25,
            shapeEnum = v28,
            name = "Hitbox" .. tostring(p24.hitboxIndex)
        };
        v27._logicState = v29;
        v27.hitbox = createLogicProxy(v29);

        return v27;
    end;

    local v30 = Hitbox:FindFirstChild(PartName);

    if not v30 then
        error("hitbox预制体不存在: " .. tostring(PartName));
    end;

    v27.hitbox = v30:Clone();
    v27.hitbox.Parent = workspace.Debris;
    HitboxDebug.applyPartTransparency(v27.hitbox, v27.skillID, false);
    v27.hitbox.CanCollide = false;
    v27.hitbox.CanTouch = false;
    v27.hitbox.CanQuery = true;
    v27.hitbox.Name = "Hitbox" .. p24.hitboxIndex;
    v27.hitbox.CollisionGroup = "Hitbox";
    v27._logicState = nil;

    return v27;
end;

function u19.hasPhysicalPart(p31) -- Line: 270
    -- upvalues: u19 (copy)
    local v32;

    if p31._usePhysicalPart == true then
        v32 = u19.isPhysicalPart(p31.hitbox);
    else
        v32 = false;
    end;

    return v32;
end;

function u19.getWorldCenter(p33) -- Line: 279
    -- upvalues: u19 (copy), u3 (copy)
    if p33._logicState then
        return p33._logicState.cframe.Position;
    end;

    local hitbox = p33.hitbox;

    if u19.isPhysicalPart(hitbox) then
        return hitbox.Position;
    end;

    return u3.Position;
end;

function u19.getWorldCFrame(p34) -- Line: 295
    -- upvalues: u19 (copy), u3 (copy)
    if p34._logicState then
        return p34._logicState.cframe;
    end;

    local hitbox = p34.hitbox;

    if u19.isPhysicalPart(hitbox) then
        return hitbox:GetPivot();
    end;

    return u3;
end;

local function _syncDebugVisual(p35, p36) -- Line: 311
    -- upvalues: HitboxDebug (copy)
    if p35._usePhysicalPart or not p35._logicState then
        return;
    end;

    if not (p36 and HitboxDebug.shouldShow(p35.skillID)) then
        if p35._debugVisualPart then
            p35._debugVisualPart:Destroy();
            p35._debugVisualPart = nil;
        end;

        return;
    end;

    local _debugVisualPart = p35._debugVisualPart;

    if not (_debugVisualPart and _debugVisualPart.Parent) then
        _debugVisualPart = Instance.new("Part");
        _debugVisualPart.Name = "HitboxDebugVisual";
        _debugVisualPart.Anchored = true;
        _debugVisualPart.CanCollide = false;
        _debugVisualPart.CanTouch = false;
        _debugVisualPart.CanQuery = false;
        _debugVisualPart.CastShadow = false;
        _debugVisualPart.Parent = workspace.Debris;
        p35._debugVisualPart = _debugVisualPart;
    end;

    local _logicState = p35._logicState;
    _debugVisualPart.Shape = _logicState.shapeEnum;
    _debugVisualPart.Size = _logicState.size;
    _debugVisualPart.CFrame = _logicState.cframe;
    HitboxDebug.applyPartTransparency(_debugVisualPart, p35.skillID, true);
end;

function u19.check(p37) -- Line: 346
    -- upvalues: _syncDebugVisual (copy), u1 (copy), HitQueryContext (copy), RunService (copy), UtilsSystem (copy)
    local v38 = {};

    if not p37.isActive then
        return nil;
    end;

    _syncDebugVisual(p37, true);
    local v39;

    if p37:hasPhysicalPart() then
        v39 = workspace:GetPartsInPart(p37.hitbox, u1);
    else
        local _logicState = p37._logicState;

        if not _logicState then
            return nil;
        end;

        if _logicState.logicShape == "Ball" then
            v39 = workspace:GetPartBoundsInRadius(_logicState.cframe.Position, _logicState.radius, u1);
        else
            v39 = workspace:GetPartBoundsInBox(_logicState.cframe, _logicState.size, u1);
        end;
    end;

    local parryInjectAttackerModel = p37.parryInjectAttackerModel;

    if parryInjectAttackerModel then
        if parryInjectAttackerModel.Parent then
            local PrimaryPart = parryInjectAttackerModel.PrimaryPart;

            if PrimaryPart and PrimaryPart:IsA("BasePart") then
                table.insert(v39, PrimaryPart);
            end;
        end;

        p37.parryInjectAttackerModel = nil;
    end;

    for _, v in v39 do
        local CollisionGroup = v.CollisionGroup;

        if CollisionGroup == "Broken" and true or p37.targetCollisionGroups[CollisionGroup] == true then
            local Parent = v.Parent;

            if Parent then
                local v40;

                if Parent:IsA("Model") then
                    if v.CollisionGroup == "Broken" then
                        Parent = Parent.Parent;

                        if Parent and Parent:IsA("Model") then
                            if not p37.checkedParts[Parent] then
                                v40 = HitQueryContext.create(p37, Parent, nil);

                                if HitQueryContext.isDetectableTarget(v40) then
                                    p37.checkedParts[Parent] = true;
                                    v38[Parent] = v;
                                end;
                            end;
                        end;
                    elseif not p37.checkedParts[Parent] then
                        v40 = HitQueryContext.create(p37, Parent, nil);

                        if HitQueryContext.isDetectableTarget(v40) then
                            p37.checkedParts[Parent] = true;
                            v38[Parent] = v;
                        end;
                    end;
                else
                    Parent = Parent.Parent;

                    if Parent and Parent:IsA("Model") then
                        if v.CollisionGroup == "Broken" then
                            Parent = Parent.Parent;

                            if Parent and Parent:IsA("Model") then
                                if not p37.checkedParts[Parent] then
                                    v40 = HitQueryContext.create(p37, Parent, nil);

                                    if HitQueryContext.isDetectableTarget(v40) then
                                        p37.checkedParts[Parent] = true;
                                        v38[Parent] = v;
                                    end;
                                end;
                            end;
                        elseif not p37.checkedParts[Parent] then
                            v40 = HitQueryContext.create(p37, Parent, nil);

                            if HitQueryContext.isDetectableTarget(v40) then
                                p37.checkedParts[Parent] = true;
                                v38[Parent] = v;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    if RunService:IsServer() and (p37.hitboxOwnerType == "Player" or p37.hitboxOwnerType == "Mirror") then
        local SystemEnemy = UtilsSystem.SystemEnemy;

        if SystemEnemy and SystemEnemy.collectLogicalOverlapHits then
            local v41 = "Block";
            local v42 = CFrame.new();
            local v43 = Vector3.new(4, 4, 4);

            if p37:hasPhysicalPart() and p37.hitbox then
                v42 = p37.hitbox:GetPivot();
                v43 = p37.hitbox.Size;

                if p37.hitbox.Shape == Enum.PartType.Ball then
                    v41 = "Ball";
                end;
            elseif p37._logicState then
                v42 = p37._logicState.cframe;
                v43 = p37._logicState.size;

                if p37._logicState.logicShape == "Ball" then
                    v41 = "Ball";
                else
                    v41 = "Block";
                end;
            end;

            for i, v in SystemEnemy.collectLogicalOverlapHits(v42, v43, v41, p37.checkedParts) do
                if not p37.checkedParts[i] then
                    local v44 = HitQueryContext.create(p37, i, nil);

                    if HitQueryContext.isDetectableTarget(v44) then
                        p37.checkedParts[i] = true;
                        v38[i] = v;
                    end;
                end;
            end;
        end;
    end;

    return v38;
end;

function u19.start(p45, p46) -- Line: 457
    -- upvalues: HitboxDebug (copy), _syncDebugVisual (copy)
    if p46 ~= false then
        p45:resetCheckedParts();
    end;

    p45._activationHitCount = 0;
    p45._cameraShakeCount = 0;
    p45.hitHistory = {};
    p45.isActive = true;

    if p45:hasPhysicalPart() then
        HitboxDebug.applyPartTransparency(p45.hitbox, p45.skillID, true);

        return;
    end;

    _syncDebugVisual(p45, true);
end;

function u19.stop(p47) -- Line: 476
    -- upvalues: HitboxDebug (copy)
    p47.isActive = false;
    p47.parryInjectAttackerModel = nil;

    if p47:hasPhysicalPart() then
        HitboxDebug.applyPartTransparency(p47.hitbox, p47.skillID, false);

        return;
    end;

    if not p47._usePhysicalPart then
        if not p47._logicState then
            return;
        end;

        if p47._debugVisualPart then
            p47._debugVisualPart:Destroy();
            p47._debugVisualPart = nil;
        end;
    end;
end;

function u19.resetCheckedParts(p48) -- Line: 490
    p48.checkedParts = {};
end;

function u19.recordHit(p49, p50, p51) -- Line: 500
    if p50 then
        p49.hitHistory[p50] = p51;
    end;

    p49._activationHitCount = (p49._activationHitCount or 0) + 1;
end;

function u19.destroy(p52) -- Line: 511
    p52:resetCheckedParts();
    p52.parryInjectAttackerModel = nil;
    p52.isActive = false;

    if p52._debugVisualPart then
        p52._debugVisualPart:Destroy();
        p52._debugVisualPart = nil;
    end;

    if p52:hasPhysicalPart() then
        p52.hitbox:Destroy();
    elseif p52.hitbox and p52.hitbox.Destroy then
        p52.hitbox:Destroy();
    end;

    p52._logicState = nil;
    p52.hitbox = nil;
end;

return u19;