-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Directory = require(ReplicatedStorage.Directory.Assets).Directory;
local u1 = {};

for i, v in pairs(Directory) do
    local BaseHealth = v.BaseHealth;
    local v2 = typeof(BaseHealth) ~= "number" and 100 or BaseHealth;
    local BaseModelScale = v.BaseModelScale;
    local v3 = (typeof(BaseModelScale) ~= "number" or BaseModelScale <= 0) and 1 or BaseModelScale;
    local v4 = math.floor(v2 * 0.5 + 0.5);
    local v5 = math.max(1, v4);
    local v6 = {};
    local v7 = math.floor(v2 + 0.5);
    v6.Base = math.max(1, v7);
    v6.BaseScale = v3;
    v6.Min = v5;
    u1[i] = v6;
end;

return {
    GetDirectory = function() -- Line: 42, Name: GetDirectory
        -- upvalues: u1 (copy)
        return u1;
    end,

    Get = function(p8) -- Line: 46, Name: Get
        -- upvalues: u1 (copy)
        return u1[p8];
    end,

    ComputeMaxHealth = function(p9, p10) -- Line: 50, Name: ComputeMaxHealth
        -- upvalues: u1 (copy)
        local v11 = u1[p9];

        if v11 then
            return math.max(1, v11.Base);
        end;

        local v12 = typeof(p10) == "number" and p10 and p10 or 1;
        local v13 = math.max(v12, 0.1) * 100;
        local v14 = math.floor(v13);

        return math.max(10, v14);
    end
};