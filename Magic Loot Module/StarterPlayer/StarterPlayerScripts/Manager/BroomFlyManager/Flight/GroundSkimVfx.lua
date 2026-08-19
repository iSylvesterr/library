-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local FXUtil = UtilsSystem.FXUtil;
local ResRestore = UtilsSystem.ResRestore;
local ResourceUtil = UtilsSystem.ResourceUtil;
local ModelCategory = ResourceUtil.ModelCategory;
local u1 = nil;
local u2 = nil;

local function _getWaterVfxTemplate() -- Line: 26
    -- upvalues: u1 (ref), ResourceUtil (copy), ModelCategory (copy)
    if u1 and u1.Parent then
        return u1;
    end;

    local v3 = ResourceUtil.GetModel(ModelCategory.Effect, "扫帚水花", {
        clone = false
    });

    if v3 and v3:IsA("Model") then
        u1 = v3;

        return u1;
    end;

    local v4 = game.ReplicatedStorage:FindFirstChild("ModelRes") and game.ReplicatedStorage.ModelRes:FindFirstChild("Effect");

    if v4 then
        v4 = v4:FindFirstChild("扫帚水花");
    end;

    if not (v4 and v4:IsA("Model")) then
        return nil;
    end;

    u1 = v4;

    return u1;
end;

local function _getLandVfxTemplate() -- Line: 45
    -- upvalues: u2 (ref), ResourceUtil (copy), ModelCategory (copy)
    if u2 and u2.Parent then
        return u2;
    end;

    local v5 = ResourceUtil.GetModel(ModelCategory.Effect, "扫帚烟尘", {
        clone = false
    });

    if v5 and v5:IsA("Model") then
        u2 = v5;

        return u2;
    end;

    local v6 = game.ReplicatedStorage:FindFirstChild("ModelRes") and game.ReplicatedStorage.ModelRes:FindFirstChild("Effect");

    if v6 then
        v6 = v6:FindFirstChild("扫帚烟尘");
    end;

    if not (v6 and v6:IsA("Model")) then
        return nil;
    end;

    u2 = v6;

    return u2;
end;

local u7 = {};
local u8 = {};
u8.__index = u8;

local function getSkimVfxEntry(p9) -- Line: 132
    -- upvalues: u7 (copy)
    local v10 = u7[p9];

    if not v10 then
        v10 = {
            water = nil,
            solid = nil
        };
        u7[p9] = v10;
    end;

    return v10;
end;

local function stopSkimVfxModel(p11) -- Line: 141
    -- upvalues: FXUtil (copy)
    if not p11 then
        return;
    end;

    FXUtil.Stop_All_Emit(p11);
    FXUtil.SetEmittersTrailsBeamsEnabled(p11, false);
    FXUtil.OffEnableVfx(p11);
    FXUtil.Stop_All_Particles(p11);
end;

local function recycleSkimVfxModel(u12) -- Line: 152
    -- upvalues: FXUtil (copy)
    if not u12 then
        return;
    end;

    if u12 then
        FXUtil.Stop_All_Emit(u12);
        FXUtil.SetEmittersTrailsBeamsEnabled(u12, false);
        FXUtil.OffEnableVfx(u12);
        FXUtil.Stop_All_Particles(u12);
    end;

    task.delay(2, function() -- Line: 158
        -- upvalues: u12 (copy), FXUtil (ref)
        if u12.Parent then
            FXUtil.BackPool_Instance(u12);
        end;
    end);
end;

local function clearSkimVfxEntry(p13) -- Line: 165
    -- upvalues: u7 (copy), FXUtil (copy)
    if not p13 then
        return;
    end;

    local v14 = u7[p13];

    if not v14 then
        return;
    end;

    local water = v14.water;
    local solid = v14.solid;
    v14.water = nil;
    v14.solid = nil;
    u7[p13] = nil;

    if water then
        if water then
            FXUtil.Stop_All_Emit(water);
            FXUtil.SetEmittersTrailsBeamsEnabled(water, false);
            FXUtil.OffEnableVfx(water);
            FXUtil.Stop_All_Particles(water);
        end;

        task.delay(2, function() -- Line: 158
            -- upvalues: water (copy), FXUtil (ref)
            if water.Parent then
                FXUtil.BackPool_Instance(water);
            end;
        end);
    end;

    if not solid then
        return;
    end;

    if solid then
        FXUtil.Stop_All_Emit(solid);
        FXUtil.SetEmittersTrailsBeamsEnabled(solid, false);
        FXUtil.OffEnableVfx(solid);
        FXUtil.Stop_All_Particles(solid);
    end;

    task.delay(2, function() -- Line: 158
        -- upvalues: solid (copy), FXUtil (ref)
        if solid.Parent then
            FXUtil.BackPool_Instance(solid);
        end;
    end);
end;

function u8.GetSkimHeightRange(p15) -- Line: 188
    return p15 <= 0 and {
        min = 0,
        max = 0
    } or {
        min = 0.5,
        max = p15 * 1.2
    };
end;

function u8.IsGroundSkimming(p16, p17, p18) -- Line: 206
    -- upvalues: u8 (copy)
    if not p16 or p17 <= 0 then
        return false;
    end;

    local v19 = p18 or u8.GetSkimHeightRange(p17);

    if v19.min > v19.max then
        return false;
    end;

    local v20;

    if v19.min <= p16 then
        v20 = p16 <= v19.max;
    else
        v20 = false;
    end;

    return v20;
end;

function u8.HasSkimSpeed(p21) -- Line: 227
    return p21 > 1;
end;

function u8.ShouldActivateVfx(p22, p23, p24) -- Line: 239
    -- upvalues: u8 (copy)
    local v25 = p22 and u8.HasSkimSpeed(p23) and p24 ~= nil;

    return v25;
end;

function u8.ResolveEffectState(p26, p27, p28) -- Line: 255
    -- upvalues: u8 (copy)
    return not u8.ShouldActivateVfx(p26, p27, p28) and "Off" or p28;
end;

function u8.ClassifySurface(p29, p30) -- Line: 273
    return p29 == Enum.Material.Water and "Water" or (p29 and p29 ~= Enum.Material.Air and "Solid" or (p30 and "Solid" or nil));
end;

function u8.ComputeVerticalGroundDistance(p31, p32) -- Line: 293
    return math.max(0, p31.Y - p32.Y);
end;

function u8.BuildSkimVfxCFrame(p33, p34, p35) -- Line: 305
    local v36 = (not p34 or p34.Magnitude <= 0.01) and Vector3.new(0, 1, 0) or p34.Unit;
    local v37 = Vector3.new(0, 0, -1);

    if p35 then
        local HumanoidRootPart = p35:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            local v38 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z);

            if v38.Magnitude > 0.01 then
                v37 = v38.Unit;
            end;
        end;
    end;

    local v39 = v37 - v36 * v37:Dot(v36);

    if v39.Magnitude < 0.01 then
        return CFrame.new(p33) * CFrame.fromMatrix(Vector3.new(0, 0, 0), Vector3.new(1, 0, 0), v36);
    end;

    return CFrame.lookAt(p33, p33 + v39.Unit, v36);
end;

function u8.BuildProbeFromRaycast(p40, p41, p42) -- Line: 341
    -- upvalues: u8 (copy)
    local v43 = {
        distance = nil,
        isAnchored = false,
        surfaceKind = nil,
        hitInstance = nil,
        hitMaterial = nil,
        hitPosition = nil,
        hitNormal = nil,
        forwardBlocked = p42
    };

    if p40 then
        v43.hitInstance = p40.Instance;
        v43.hitMaterial = p40.Material;
        v43.hitPosition = p40.Position;
        v43.hitNormal = p40.Normal;
        local Instance = p40.Instance;

        if Instance:IsA("BasePart") then
            v43.isAnchored = Instance.Anchored;
        else
            v43.isAnchored = true;
        end;

        v43.distance = u8.ComputeVerticalGroundDistance(p41, p40.Position);
        v43.surfaceKind = u8.ClassifySurface(p40.Material, p40.Instance);
    end;

    return v43;
end;

function u8.new(p44) -- Line: 381
    -- upvalues: u8 (copy)
    return setmetatable({
        _isGroundSkimming = false,
        _effectState = "Off",
        _character = p44
    }, u8);
end;

function u8.GetIsGroundSkimming(p45) -- Line: 395
    return p45._isGroundSkimming;
end;

function u8.GetIsVfxActive(p46) -- Line: 404
    return p46._effectState ~= "Off";
end;

function u8.GetActiveSurfaceKind(p47) -- Line: 413
    if p47._effectState == "Off" then
        return nil;
    end;

    return p47._effectState;
end;

function u8.GetEffectState(p48) -- Line: 425
    return p48._effectState;
end;

function u8._CreateSkimVfxForCharacter(p49, p50, p51, p52) -- Line: 437
    -- upvalues: u7 (copy), FXUtil (copy), ResRestore (copy)
    if not p51 then
        return nil;
    end;

    local v53 = u7[p50];

    if not v53 then
        v53 = {
            water = nil,
            solid = nil
        };
        u7[p50] = v53;
    end;

    local v54;

    if p52 == "Water" then
        v54 = v53.water;
    else
        v54 = v53.solid;
    end;

    if v54 then
        return v54;
    end;

    local v55 = FXUtil.GetInstance_From_Pool(p51);

    if not (v55 and v55:IsA("Model")) then
        return nil;
    end;

    if ResRestore and ResRestore.Restore then
        ResRestore.Restore(v55);
    end;

    for _, descendant in pairs(v55:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or descendant:IsA("Trail")) then
            descendant.Enabled = true;
        end;
    end;

    v55.Parent = workspace.Debris;
    FXUtil.EmitOnceThenEnableContinuous(v55);

    if p52 == "Water" then
        v53.water = v55;

        return v55;
    end;

    v53.solid = v55;

    return v55;
end;

function u8._UpdateSkimVfxPosition(p56, p57) -- Line: 480
    -- upvalues: u7 (copy), u8 (copy)
    if not (p57 and p57.hitPosition) then
        return;
    end;

    local _character = p56._character;

    if not _character then
        return;
    end;

    local v58 = u7[_character];

    if not v58 then
        return;
    end;

    local v59 = u8.BuildSkimVfxCFrame(p57.hitPosition, p57.hitNormal, _character);

    if v58.water and v58.water.Parent then
        v58.water:PivotTo(v59);
    end;

    if v58.solid and v58.solid.Parent then
        v58.solid:PivotTo(v59);
    end;
end;

function u8._EnableWaterSkimVfx(p60, p61, p62) -- Line: 510
    -- upvalues: _getWaterVfxTemplate (copy)
    if not p61 then
        return;
    end;

    if p60:_CreateSkimVfxForCharacter(p61, _getWaterVfxTemplate(), "Water") and p62 then
        p60:_UpdateSkimVfxPosition(p62);
    end;
end;

function u8._DisableWaterSkimVfx(p63) -- Line: 525
    -- upvalues: u7 (copy), FXUtil (copy)
    local _character = p63._character;

    if not _character then
        return;
    end;

    local v64 = u7[_character];

    if not (v64 and v64.water) then
        return;
    end;

    local water = v64.water;
    v64.water = nil;

    if not water then
        return;
    end;

    if water then
        FXUtil.Stop_All_Emit(water);
        FXUtil.SetEmittersTrailsBeamsEnabled(water, false);
        FXUtil.OffEnableVfx(water);
        FXUtil.Stop_All_Particles(water);
    end;

    task.delay(2, function() -- Line: 158
        -- upvalues: water (copy), FXUtil (ref)
        if water.Parent then
            FXUtil.BackPool_Instance(water);
        end;
    end);
end;

function u8._EnableSolidSkimVfx(p65, p66, p67) -- Line: 547
    -- upvalues: _getLandVfxTemplate (copy)
    if not p66 then
        return;
    end;

    if p65:_CreateSkimVfxForCharacter(p66, _getLandVfxTemplate(), "Solid") and p67 then
        p65:_UpdateSkimVfxPosition(p67);
    end;
end;

function u8._DisableSolidSkimVfx(p68) -- Line: 562
    -- upvalues: u7 (copy), FXUtil (copy)
    local _character = p68._character;

    if not _character then
        return;
    end;

    local v69 = u7[_character];

    if not (v69 and v69.solid) then
        return;
    end;

    local solid = v69.solid;
    v69.solid = nil;

    if not solid then
        return;
    end;

    if solid then
        FXUtil.Stop_All_Emit(solid);
        FXUtil.SetEmittersTrailsBeamsEnabled(solid, false);
        FXUtil.OffEnableVfx(solid);
        FXUtil.Stop_All_Particles(solid);
    end;

    task.delay(2, function() -- Line: 158
        -- upvalues: solid (copy), FXUtil (ref)
        if solid.Parent then
            FXUtil.BackPool_Instance(solid);
        end;
    end);
end;

function u8._TransitionToState(p70, p71, p72, p73) -- Line: 583
    if p71 == p72 then
        return;
    end;

    if p71 == "Water" then
        p70:_DisableWaterSkimVfx();
    elseif p71 == "Solid" then
        p70:_DisableSolidSkimVfx();
    end;

    if p72 == "Water" then
        p70:_EnableWaterSkimVfx(p70._character, p73);

        return;
    end;

    if p72 == "Solid" then
        p70:_EnableSolidSkimVfx(p70._character, p73);
    end;
end;

function u8.Update(p74, p75, p76, p77, p78) -- Line: 620
    -- upvalues: u8 (copy)
    local v79 = u8.IsGroundSkimming(p75, p76);
    local v80;

    if v79 and (p77 and p77.surfaceKind) then
        v80 = p77.surfaceKind;
    else
        v80 = nil;
    end;

    local v81 = u8.ResolveEffectState(v79, p78, v80);
    p74._isGroundSkimming = v79;

    if v81 == p74._effectState then
        if v81 ~= "Off" then
            p74:_UpdateSkimVfxPosition(p77);
        end;

        return;
    end;

    local _effectState = p74._effectState;
    p74._effectState = v81;
    p74:_TransitionToState(_effectState, v81, p77);
end;

function u8.Reset(p82) -- Line: 652
    -- upvalues: u7 (copy), FXUtil (copy)
    local _effectState = p82._effectState;
    p82._isGroundSkimming = false;
    p82._effectState = "Off";
    p82:_TransitionToState(_effectState, "Off", nil);
    local _character = p82._character;

    if not _character then
        return;
    end;

    local v83 = u7[_character];

    if not v83 then
        return;
    end;

    local water = v83.water;
    local solid = v83.solid;
    v83.water = nil;
    v83.solid = nil;
    u7[_character] = nil;

    if water then
        if water then
            FXUtil.Stop_All_Emit(water);
            FXUtil.SetEmittersTrailsBeamsEnabled(water, false);
            FXUtil.OffEnableVfx(water);
            FXUtil.Stop_All_Particles(water);
        end;

        task.delay(2, function() -- Line: 158
            -- upvalues: water (copy), FXUtil (ref)
            if water.Parent then
                FXUtil.BackPool_Instance(water);
            end;
        end);
    end;

    if not solid then
        return;
    end;

    if solid then
        FXUtil.Stop_All_Emit(solid);
        FXUtil.SetEmittersTrailsBeamsEnabled(solid, false);
        FXUtil.OffEnableVfx(solid);
        FXUtil.Stop_All_Particles(solid);
    end;

    task.delay(2, function() -- Line: 158
        -- upvalues: solid (copy), FXUtil (ref)
        if solid.Parent then
            FXUtil.BackPool_Instance(solid);
        end;
    end);
end;

return u8;