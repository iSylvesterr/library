-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EmitDescendants = require(script.Parent.EmitDescendants);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local AddDebris = require(script.Parent.AddDebris);
local Weld = require(script.Parent.Weld);
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local u1 = t.interface({
    AddToDebris = t.optional(t.boolean),
    DestroyDelay = t.optional(t.number),
    AutoParentLikeOriginal = t.optional(t.union(t.boolean, t.literal("Debris"))),
    WeldToPart = t.optional(t.instanceIsA("BasePart")),
    OptimizeForMobile = t.optional(t.boolean),
    Properties = t.optional(t.interface({
        Position = t.optional(t.Vector3),
        CFrame = t.optional(t.CFrame),
        Parent = t.optional(t.Instance)
    }))
});

return function(p2, p3) -- Line: 46
    -- upvalues: Asserts (copy), u1 (copy), __DEBRIS (copy), AddDebris (copy), Weld (copy), EmitDescendants (copy)
    Asserts.BasePart(p2);
    local v4 = p3 or {};
    assert(u1(v4));
    local v5 = p2:Clone();

    if v4.Properties then
        for i, v in v4.Properties do
            v5[i] = v;
        end;
    end;

    if v4.AutoParentLikeOriginal then
        local v6;

        if v4.AutoParentLikeOriginal == "Debris" then
            v6 = __DEBRIS;
        else
            v6 = p2.Parent or __DEBRIS;
        end;

        v5.Parent = v6;
    end;

    if v4.AddToDebris then
        AddDebris(v5, v4.DestroyDelay or 10);
    end;

    if v4.WeldToPart then
        v5.CFrame = v4.WeldToPart.CFrame;
        v5.Anchored = false;
        Weld(v5, v4.WeldToPart);
    end;

    EmitDescendants(v5, v4.OptimizeForMobile);

    return v5;
end;