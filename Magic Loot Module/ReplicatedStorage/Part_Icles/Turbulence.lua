-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local PartConstants = require(script.Parent.PartConstants);
local u13 = {
    isLive = function(p1) -- Line: 23, Name: isLive
        -- upvalues: Graph (copy)
        if not p1 then
            return nil;
        end;

        if Graph.IsStatic(p1) and Graph.GetStaticValue(p1, 0) == 0 then
            return nil;
        end;

        return p1;
    end,

    sampleRaw = function(p2, p3, p4, p5, p6, p7) -- Line: 30, Name: sampleRaw
        -- upvalues: Graph (copy)
        local v8 = Graph.QueryPointsWithTime(p7, p2, p3);

        if v8 == 0 then
            return Vector3.new(0, 0, 0);
        end;

        local v9 = p7 * p6 * p5;
        local v10 = v8 * math.noise(v9, p4, 0.17);
        local v11 = v8 * math.noise(v9, p4, 137.7);
        local v12 = v8 * math.noise(v9, p4, 291.3);

        return Vector3.new(v10, v11, v12);
    end
};

local function resolvedAt(p14, p15) -- Line: 41
    -- upvalues: PartConstants (copy), u13 (copy)
    return PartConstants.resolveDisplacement(u13.sampleRaw(p14.Graphs.Turbulence, p14.Seeds.Turbulence, p14._turbSeed, p14.TurbulenceFrequency, p14.LifeTime, p15), p14.DisplacementMode or "Global", p14.SpawnRotation, p14.SpawnEmitterRotation);
end;

function u13.frameDelta(p16, p17) -- Line: 49
    -- upvalues: PartConstants (copy), u13 (copy)
    local v18 = PartConstants.resolveDisplacement(u13.sampleRaw(p16.Graphs.Turbulence, p16.Seeds.Turbulence, p16._turbSeed, p16.TurbulenceFrequency, p16.LifeTime, p17), p16.DisplacementMode or "Global", p16.SpawnRotation, p16.SpawnEmitterRotation);
    local v19 = v18 - p16._prevTurbOff;
    p16._prevTurbOff = v18;

    return v19;
end;

function u13.buildInto(p20, p21) -- Line: 60
    -- upvalues: u13 (copy), Graph (copy), PartConstants (copy)
    local v22 = u13.isLive(p21.Turbulence);
    p20.HasTurbulence = v22 ~= nil;

    if not v22 then
        p20.Graphs.Turbulence = nil;

        return;
    end;

    p20.Graphs.Turbulence = v22;
    p20.Seeds.Turbulence = p20.Seeds.Turbulence or Graph.GenerateSeed(v22);
    p20.TurbulenceFrequency = p21.TurbulenceFrequency or 1;
    p20._turbSeed = p20.Seeds._turbSeed or math.random() * 997 + 0.5;
    p20._prevTurbOff = PartConstants.resolveDisplacement(u13.sampleRaw(p20.Graphs.Turbulence, p20.Seeds.Turbulence, p20._turbSeed, p20.TurbulenceFrequency, p20.LifeTime, 0), p20.DisplacementMode or "Global", p20.SpawnRotation, p20.SpawnEmitterRotation);
end;

function u13.reprime(p23) -- Line: 79
    -- upvalues: PartConstants (copy), u13 (copy)
    if not p23.HasTurbulence then
        return;
    end;

    p23._prevTurbOff = PartConstants.resolveDisplacement(u13.sampleRaw(p23.Graphs.Turbulence, p23.Seeds.Turbulence, p23._turbSeed, p23.TurbulenceFrequency, p23.LifeTime, 0), p23.DisplacementMode or "Global", p23.SpawnRotation, p23.SpawnEmitterRotation);
end;

return u13;