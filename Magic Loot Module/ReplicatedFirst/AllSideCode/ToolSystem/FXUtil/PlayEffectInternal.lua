-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AssetPaths = UtilsSystem.AssetPaths;
local AssetRegistry = UtilsSystem.AssetRegistry;
local v1 = {};
local u2 = nil;
local u3 = nil;

function v1.setup(p4, p5) -- Line: 24
    -- upvalues: u3 (ref), u2 (ref)
    u3 = p4;
    u2 = p5;
end;

function v1.prepEffectModelForWorldShared(p6, p7) -- Line: 34
    -- upvalues: u2 (ref)
    u2.AnchoredAll(p6);

    if p7 then
        u2.UnTransparencyAll(p6);
    end;

    u2.UnQueryAll(p6);
    u2.UnCollideAll(p6);
    u2.UnTouchAll(p6);
    u2.MasslessAll(p6);
end;

function v1.destroyFxWeldConstraintsRecursive(p8) -- Line: 49
    local v9 = p8:GetDescendants();

    for i = #v9, 1, -1 do
        local v10 = v9[i];

        if v10 and v10:IsA("WeldConstraint") then
            v10:Destroy();
        end;
    end;
end;

function v1.stopPooledVfxAndRecycle(p11) -- Line: 63
    -- upvalues: u3 (ref)
    u3.Stop_All_Emit(p11);
    u3.SetEmittersTrailsBeamsEnabled(p11, false);
    u3.Stop_All_Particles(p11);
    u3.BackPool_Instance(p11);
end;

function v1.cloneModelResEffectModel(p12) -- Line: 75
    -- upvalues: AssetPaths (copy), AssetRegistry (copy)
    if type(p12) ~= "string" or p12 == "" then
        return nil;
    end;

    local v13 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Effect, p12));

    if v13 and v13:IsA("Model") then
        return v13:Clone();
    end;

    return nil;
end;

return v1;