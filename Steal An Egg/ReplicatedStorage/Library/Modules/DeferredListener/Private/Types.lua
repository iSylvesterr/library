-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Modules.Packages.Promise);
require(ReplicatedStorage.Library.Modules.Packages.Trove);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
require(ReplicatedStorage.Library.Functions.TableInjectAutoRemovalBehavior);

return {
    SoftAutoRemoveProtocol = t.interface({
        removeFrom = t.table,
        indexOverride = t.optional(t.any)
    })
};