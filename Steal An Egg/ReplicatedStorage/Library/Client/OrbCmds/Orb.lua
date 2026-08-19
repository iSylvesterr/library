-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Library = ReplicatedStorage:WaitForChild("Library");
local Items = Library:WaitForChild("Items");
local Types = Library:WaitForChild("Types");
local CurrencyOrb = script:WaitForChild("CurrencyOrb");
local OrbCollect = Assets:WaitForChild("Particles"):WaitForChild("Orbs"):WaitForChild("OrbCollect");
local FallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight;
local Functions = require(Library.Functions);
local CurrencyItem = require(Items.CurrencyItem);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Currency = require(ReplicatedStorage.Directory.Currency);
local InstanceCache = require(Library.Modules.Packages.InstanceCache);
local Variables = require(Library.Variables);
local Orbs = require(Types.Orbs);
local CoinSounds = require(script.CoinSounds);
local u1 = workspace.StreamingEnabled and (1 / 0) or 400;
local Orbs2 = workspace:WaitForChild("__OBJECTS"):WaitForChild("Orbs");
local u2 = Random.new();
local LocalPlayer = Players.LocalPlayer;
local u3 = RaycastParams.new();
u3.FilterDescendantsInstances = {};
u3.FilterType = Enum.RaycastFilterType.Exclude;
u3.IgnoreWater = true;
u3.CollisionGroup = "Orbs";
u3.RespectCanCollide = true;
local u4 = {
    DefaultPickupDistance = 70,
    CollectDistance = 2.5,
    CombineDistance = 16,
    CombineDelay = 0.8,
    BillboardDistance = 800,
    CollectAnimationDuration = 0.6,
    CollectAnimationHeight = 12,
    CollectAnimationSpin = 1.5707963267948966,
    SoundDistance = u1
};

local function setEffectsEnabled(p5, p6) -- Line: 101
    debug.profilebegin("SetEffectsEnabled");

    for _, descendant in ipairs(p5:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            descendant.Enabled = p6;
        end;
    end;

    debug.profileend();
end;

function u4.new(p7, p8, p9, p10, p11, p12, p13) -- Line: 125
    -- upvalues: u4 (copy), Orbs2 (copy), Functions (copy), u2 (copy), Orbs (copy), setEffectsEnabled (copy)
    local v14, v15, v16, v17, v18, v19 = u4.CreatePart(p9, p10);
    v14.Name = tostring(p7);

    for _, v in ipairs(v15) do
        v.Enabled = false;
        v.Lifetime = NumberRange.new(20);
        v.TimeScale = 0;
    end;

    local v20 = v14.PivotOffset:Inverse();
    v14:PivotTo(p11);
    v14.Parent = Orbs2;

    for _, v in ipairs(v15) do
        v:Emit(1);
    end;

    local Type = p10.Type;
    local AssemblyMass = v14.AssemblyMass;
    local CurrentPhysicalProperties = v14.CurrentPhysicalProperties;
    local v21 = v14:GetAttribute("CrossSectionalArea");

    if not v21 then
        local AverageCrossSectionalArea = Functions.AverageCrossSectionalArea;
        local v22;

        if v14:IsA("Part") then
            v22 = v14.Shape;
        else
            v22 = Enum.PartType.Block;
        end;

        v21 = AverageCrossSectionalArea(v22, v14.Size);
    end;

    local v23 = v21 * (v14:GetAttribute("CrossSectionalAreaMultiplier") or 1);
    local v24 = v14:GetAttribute("DragCoefficient") or 0.7;
    local v25 = p10.PickupDelay or u2:NextNumber(0.5, 2.1);
    local v26 = v25 + u4.CombineDelay;
    local v27 = nil;

    if Type == Orbs.Types.Orb then
        assert(#p9 == 1, "Orb items count must equal 1");
        local v28 = p9[1];

        if v28:IsA("Currency") then
            v27 = v28:GetId();
        end;
    else
        error("Unexpected orb type");
    end;

    if v17 then
        task.defer(setEffectsEnabled, v14, true);
    end;

    return setmetatable({
        _destroyed = false,
        _anchored = false,
        _nextParentCheck = 0,
        _dt = 0,
        _collected = false,
        _isAnimating = false,
        _animStart = 0,
        _id = p7,
        _timestamp = p8,
        _items = p9,
        _typeNumber = Type,
        _contentType = v16,
        _part = v14,
        _maybePartCache = v17,
        _pivotOffsetInv = v20,
        _cframeRender = p11,
        _currencyType = p13,
        _cframePhysics = p11,
        _velocity = p12,
        _assemblyMass = AssemblyMass,
        _dragCoefficient = v24,
        _crossSectionalArea = v23,
        _physicalProperties = CurrentPhysicalProperties,
        _pickupDelay = v25,
        _pickupDistanceOverride = v19 or p10.OverridePickupDistance,
        _combineDelay = v26,
        _combineKey = v27,
        _combinedIds = {},
        _staticParticles = v15,
        _lootTierIndex = p10.Index,
        _collectDistanceOverride = v18,
        _animStartCFrame = p11
    }, {
        __index = u4
    });
end;

function u4.RenderStepped(p29, p30, p31, p32, p33, p34, p35, p36, p37) -- Line: 236
    -- upvalues: FallenPartsDestroyHeight (copy), Orbs (copy), u4 (copy), u1 (copy)
    debug.profilebegin("Orb :: RenderStepped");
    local v38 = p31 - p29._timestamp;

    if p29._destroyed then
        return false;
    end;

    if p29._cframePhysics.Position.Y < FallenPartsDestroyHeight or Orbs.DespawnTime <= v38 then
        debug.profileend();

        return false;
    end;

    if p29._nextParentCheck <= v38 then
        p29._nextParentCheck = v38 + 2.5 + 5 * math.random();

        if not p29._part.Parent then
            debug.profileend();

            return false;
        end;
    end;

    local v39, v40;

    if p35 then
        v39 = p35.Position - p29._pivotOffsetInv.Position;
        v40 = (p29._cframePhysics.Position - v39).Magnitude;
    else
        v39 = Vector3.new(0, 0, 0);
        v40 = (1 / 0);
    end;

    local v41 = nil;
    local v42, v43;

    if p29._pickupDelay <= v38 and (not v41 and p35) then
        v42 = true;

        if p37 or p29._pickupDistanceOverride then
            p36 = p29._pickupDistanceOverride or 9999999;
            v43 = v40;
        else
            v43 = v40;
        end;
    else
        p34 = v41;
        v42 = false;
        v39 = nil;
        v43 = nil;
    end;

    local v44 = p29._collectDistanceOverride or u4.CollectDistance;
    local v45 = false;

    if v43 then
        if p37 and (v42 and (v39 and v43 > 150)) then
            p29:Collect(nil, nil, true);
            debug.profileend();

            return false;
        end;

        if v43 <= v44 then
            p29:Collect(p34);

            return false;
        end;

        if v43 <= v44 + p36 then
            p29._anchored = false;
            v45 = true;
        end;
    end;

    if not v45 and u1 < v40 then
        p29._anchored = true;
    end;

    if not p29._anchored then
        p29:SimulatePhysics(p30, v38, p32, p33, v39, p36);
    end;

    debug.profileend();

    return true;
end;

function u4.Combine(p46, p47) -- Line: 333
    -- upvalues: Orbs (copy)
    if p46 == p47 then
        return false;
    end;

    if p46._destroyed then
        return false;
    end;

    if p46._collected then
        return false;
    end;

    if p47._destroyed then
        return false;
    end;

    if p47._collected then
        return false;
    end;

    local _typeNumber = p46._typeNumber;

    if _typeNumber ~= p47._typeNumber then
        return false;
    end;

    if p46._contentType ~= p47._contentType then
        return false;
    end;

    if _typeNumber ~= Orbs.Types.Orb then
        return false;
    end;

    local v48 = p46._items[1];
    local v49 = p47._items[1];

    if not v48:IsLikeExact(v49) then
        return false;
    end;

    if v48:GetMaxAmount() < v48:GetAmount() + v49:GetAmount() then
        return false;
    end;

    p47:Destroy();
    table.insert(p46._combinedIds, p47._id);

    for _, v in ipairs(p47._combinedIds) do
        table.insert(p46._combinedIds, v);
    end;

    local v50 = v48:GetOrbIcon();
    v48:SetAmount(v48:GetAmount() + v49:GetAmount());
    local v51 = v48:GetOrbIcon();

    if v50 ~= v51 then
        for _, v in ipairs(p46._staticParticles) do
            v.Texture = v51;
        end;
    end;

    return true;
end;

function u4.Collect(p52, p53, p54, p55) -- Line: 403
    -- upvalues: CurrencyItem (copy), Functions (copy), LocalPlayer (copy), u4 (copy), CoinSounds (copy), Variables (copy), OrbCollect (copy)
    if p52._destroyed then
        return;
    end;

    if p52._collected then
        return;
    end;

    p52._collected = true;
    local v56 = p54 and p54.Position or p52._cframePhysics.Position;
    local v57 = true;

    for _, v in ipairs(p52._items) do
        local v58 = CurrencyItem:TryCast(v);

        if v58 and not p55 then
            if v57 and Functions.VerifyPlayerMagnitude(LocalPlayer, v56, u4.SoundDistance) then
                CoinSounds.Queue(v58:GetId(), p52._lootTierIndex);
                v57 = false;
            end;
        else
            warn("Invalid item");
        end;
    end;

    if p53 and not Variables.PotatoMode then
        local v59 = nil;

        if p53:IsA("Model") then
            p53 = p53.PrimaryPart;
        elseif not p53:IsA("BasePart") then
            p53 = v59;
        end;

        if p53 then
            local v60 = p53:FindFirstChild(OrbCollect.Name, true);

            if not v60 then
                v60 = OrbCollect:Clone();
                v60.Parent = p53;
            end;

            v60:Emit(1);
        end;
    end;
end;

local function computeImpact(p61, p62, p63, p64, p65) -- Line: 478
    local v66 = (p64.Elasticity * p64.ElasticityWeight + p65.Elasticity * p65.ElasticityWeight) / (p64.ElasticityWeight + p65.ElasticityWeight);
    local v67 = (p64.Friction * p64.FrictionWeight + p65.Friction * p65.FrictionWeight) / (p64.FrictionWeight + p65.FrictionWeight);
    local v68 = p61:Dot(p62) * p62;

    return (v68 - 2 * v68:Dot(p62) * p62) * v66, (p61 - v68) * (1 - v67);
end;

local function computeMotion(p69, p70, p71, p72, p73) -- Line: 510
    local v74 = math.clamp(p72 * p73 ^ 2, 0, 1);
    local v75 = p70 - p70 * v74;
    local v76 = p71 - p71 * v74;

    return p69 + v75 * p73 + v76 * 0.5 * p73 ^ 2, v75 + v76 * p73;
end;

function u4.SimulatePhysics(p77, p78, p79, p80, p81, p82, p83) -- Line: 536
    -- upvalues: u4 (copy), Functions (copy), u3 (copy), computeImpact (copy)
    debug.profilebegin("Orb :: SimulatePhysics");
    local _assemblyMass = p77._assemblyMass;
    local _physicalProperties = p77._physicalProperties;
    local v84 = p78 + p77._dt;
    local Position = p77._cframePhysics.Position;
    local _velocity = p77._velocity;

    for _ = 1, p81 do
        if v84 <= 0.001 then
            break;
        end;

        local v85 = math.min(v84, 0.06666666666666667);
        local v86, v87 = p77:ComputeAcceleration(p80);
        local v88;

        if p82 then
            local v89 = p82 - Position;
            local Magnitude = v89.Magnitude;

            if Magnitude > 0.001 and Magnitude <= (p77._collectDistanceOverride or u4.CollectDistance) + p83 then
                local v90 = math.max(p83, 150);
                v88 = v89 * (math.clamp((v90 - Magnitude) / v90, 0, 1) ^ 2 * 100 + 40) / Magnitude;

                if Magnitude < v88.Magnitude * v85 then
                    v88 = v88 * Magnitude / (v88.Magnitude * v85);
                end;

                v86 = Vector3.new(0, 0, 0);
                v87 = 0;
            else
                v88 = _velocity;
            end;
        else
            v88 = _velocity;
        end;

        local v91 = math.clamp(v87 * v85 ^ 2, 0, 1);
        local v92 = v88 - v88 * v91;
        local v93 = v86 - v86 * v91;
        local v94 = Position + v92 * v85 + v93 * 0.5 * v85 ^ 2;
        _velocity = v92 + v93 * v85;
        local v95 = v94 - Position;
        local Magnitude = v95.Magnitude;

        if Magnitude ~= Magnitude then
            _velocity = v88;
            break;
        end;

        if Magnitude <= 0.001 then
            v84 = 0;
            break;
        end;

        if v95.Y >= 0 then
            Position = v94;
            v84 = 0;
            break;
        end;

        local v96 = Functions.SafeRaycast(Position, v95, u3, 0.001);

        if not v96 then
            Position = v94;
            v84 = 0;
            break;
        end;

        local Normal = v96.Normal;
        local Position2 = v96.Position;
        local v97 = Functions.GetMaterialPhysicalProperties(v96.Material);
        local v98 = math.clamp(v96.Distance * v85 / Magnitude, 0, v85);
        local v99 = math.clamp(v87 * v98 ^ 2, 0, 1);
        local v100 = v88 - v88 * v99;
        local v101 = v86 - v86 * v99;
        local _ = Position + v100 * v98 + v101 * 0.5 * v98 ^ 2;
        local v102, v103 = computeImpact(v100 + v101 * v98, Normal, _assemblyMass, _physicalProperties, v97);
        _velocity = v102 + v103;
        v84 = v84 - v98;

        if v98 <= 0.001 then
            Position = Position2;
            v84 = 0;
            break;
        end;

        Position = Position2;
    end;

    if _velocity.Magnitude < 0.001 then
        p77._anchored = true;
        v84 = 0;
    end;

    p77._dt = v84;
    p77._cframePhysics = CFrame.new(Position) * p77._cframePhysics.Rotation;
    p77._velocity = _velocity;
    debug.profileend();
end;

function u4.RenderParticles(p104, p105, p106) -- Line: 648
    local Magnitude = (p104._cframePhysics.Position - p105).Magnitude;

    if Magnitude < 500 then
        local v107 = NumberSequence.new(1 + 9 * Magnitude * p106);

        for _, v in ipairs(p104._staticParticles) do
            v.Size = v107;
        end;
    end;
end;

function u4.Destroy(p108) -- Line: 662
    -- upvalues: setEffectsEnabled (copy), Functions (copy)
    if p108._destroyed then
        return false;
    end;

    p108._destroyed = true;

    if p108._part then
        if p108._maybePartCache then
            setEffectsEnabled(p108._part, false);
            p108._maybePartCache:ReturnPart(p108._part);
        else
            Functions.AddDebris(p108._part);
        end;
    end;

    return true;
end;

function u4.ComputeAcceleration(p109, p110) -- Line: 685
    return Vector3.new(0, -p110, 0), 0.5 * p109._dragCoefficient * 1.225 * p109._crossSectionalArea;
end;

function u4.ComputeInitialCFrame(p111) -- Line: 695
    -- upvalues: Asserts (copy)
    Asserts.table(p111);
    Asserts.Vector3(p111.pos);
    local v112 = CFrame.new(p111.pos);

    if v112 then
        v112 = v112 * CFrame.new(0, 0.25, 0);
    end;

    return v112;
end;

function u4.ComputeInitialVelocity(p113, p114, p115) -- Line: 713
    -- upvalues: u2 (copy)
    local v116;

    if p115.CustomVelocity then
        v116 = p115.CustomVelocity;
    else
        v116 = nil;
    end;

    if not v116 and p114 then
        local v117 = p114.Position - p113.Position;

        if Vector2.new(v117.X, v117.Z).Magnitude < 50 then
            local v118 = math.atan2(v117.Y, v117.X) + 6.283185307179586 * u2:NextNumber(-0.25, 0.25);
            local v119 = u2:NextNumber(7, 11);
            local v120 = v119 * math.cos(v118);
            local v121 = v119 * math.sin(v118);
            v116 = Vector3.new(v120, 50, v121);
        end;
    end;

    if not v116 then
        local v122 = u2:NextNumber(-10, 10);
        v116 = Vector3.new(v122, 50, u2:NextNumber(-10, 10));
    end;

    return v116 * (p115.VelocityMultiplier or 1);
end;

local function prepareInstance(p123) -- Line: 738
    p123.CanCollide = false;
    p123.CanQuery = false;
    p123.CanTouch = false;
    p123.CastShadow = false;
    p123.Anchored = true;
    p123.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    p123.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p123.CollisionGroup = "Orbs";
    p123.PivotOffset = CFrame.new(0, p123.Size.Y * -0.5, 0);

    return p123;
end;

function u4.CreatePart(p124, p125) -- Line: 757
    -- upvalues: Orbs (copy), InstanceCache (copy), CurrencyOrb (copy), u2 (copy)
    if p125.Type == Orbs.Types.Orb then
        local v126 = p124[1];

        if v126:IsA("Currency") then
            local v127 = v126:GetOrbInstance();
            local v128 = nil;
            local v129 = nil;
            local v130;

            if v127 then
                if InstanceCache.is(v127) then
                    v130 = v127:GetPart();
                    v130.CanCollide = false;
                    v130.CanQuery = false;
                    v130.CanTouch = false;
                    v130.CastShadow = false;
                    v130.Anchored = true;
                    v130.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                    v130.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                    v130.CollisionGroup = "Orbs";
                    v130.PivotOffset = CFrame.new(0, v130.Size.Y * -0.5, 0);
                else
                    v130 = v127:Clone();
                    v130.CanCollide = false;
                    v130.CanQuery = false;
                    v130.CanTouch = false;
                    v130.CastShadow = false;
                    v130.Anchored = true;
                    v130.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                    v130.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                    v130.CollisionGroup = "Orbs";
                    v130.PivotOffset = CFrame.new(0, v130.Size.Y * -0.5, 0);
                    v127 = v129;
                end;
            else
                v130 = CurrencyOrb:Clone();
                v128 = v130.Center.Item;
                v128.Texture = v126:GetOrbIcon();
                v128.ZOffset = v128.ZOffset + u2:NextNumber(0, 0.1);
                v127 = v129;
            end;

            if p125.ColorOverride then
                v130.Color = p125.ColorOverride;
            end;

            return v130, v128 and { v128 } or {}, 1, v127, v126:GetCollectDistanceOverride(), v126:GetPickupDistanceOverride();
        end;
    end;

    error("unimplemented orb type");
end;

task.spawn(function() -- Line: 803
    -- upvalues: setEffectsEnabled (copy), Currency (copy), InstanceCache (copy)
    local function softDisableEffectsInCache(p131) -- Line: 806
        -- upvalues: setEffectsEnabled (ref)
        local CacheHolder = p131.CacheHolder;
        local v132 = os.clock();

        for _, child in ipairs(CacheHolder:GetChildren()) do
            setEffectsEnabled(child, false);

            if os.clock() - v132 >= 0.002 then
                task.wait();
                v132 = os.clock();
            end;
        end;
    end;

    for _, v in pairs(Currency.Directory) do
        local Instance = v.Instance;

        if InstanceCache.is(Instance) then
            softDisableEffectsInCache(Instance);
        end;
    end;
end);

return u4;