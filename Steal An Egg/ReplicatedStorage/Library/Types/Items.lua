-- Decompiled with Potassium's decompiler.

local Functions = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Functions");
local ArrayToSet = require(Functions.ArrayToSet);
local v1 = { "_fu", "_cu", "_ct", "_oc", "_ol", "_tr" };
local v2 = { "_am", "_lk", "_to", "_uq" };
local v3 = { "_am", "_lk" };

return {
    PointlessUniquesList = v1,
    PointlessUniques = ArrayToSet(v1),
    StackKeyIgnoredFieldsList = v2,
    StackKeyIgnoredFields = ArrayToSet(v2),
    ExactStackKeyIgnoredFieldsList = v3,
    ExactStackKeyIgnoredFields = ArrayToSet(v3)
};