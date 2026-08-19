-- Decompiled with Potassium's decompiler.

local v1 = {};
v1.__index = v1;
local CollectionService = game:GetService("CollectionService");
local u2 = {
    GuidedSearch = "GS",
    LinearSearch = "LS"
};

function v1.new(p3, p4) -- Line: 22
    -- upvalues: CollectionService (copy), u2 (copy)
    local v5 = typeof(p3) == "table" and p3 and p3 or {};
    local v6 = typeof(p4) == "table" and p4 and p4 or {};

    for _, v in CollectionService:GetTagged("(Library):(Functions):[UtilityPackageInjector]:Query") do
        if v:IsA("ModuleScript") and not table.find(v6, v.Name) then
            v5[u2[v.Name] or v.Name] = require(v);
        end;
    end;

    return v5;
end;

return v1;