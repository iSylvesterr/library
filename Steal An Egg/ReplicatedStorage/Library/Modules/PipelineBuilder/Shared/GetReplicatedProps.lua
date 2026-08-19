-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local TableUtil = require(ReplicatedStorage.Library.Modules.Packages.TableUtil);

return function(p1, p2, p3) -- Line: 15, Name: PatchReplicatedProps
    -- upvalues: Asserts (copy), TableUtil (copy)
    Asserts.optional.table(p2);
    Asserts.optional.string(p3);
    Asserts.optional.table(p1);

    if p3 then
        p2 = TableUtil.Reconcile(p2 or {}, p1[p3]) or p2;
    end;

    return p2;
end;