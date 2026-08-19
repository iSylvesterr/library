-- Decompiled with Potassium's decompiler.

local v1 = {};

for _, descendant in script:GetDescendants() do
    if descendant:IsA("ModuleScript") then
        v1[descendant.Name] = require(descendant)();
    end;
end;

return v1;