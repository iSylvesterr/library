-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local function getPackNames() -- Line: 4
    -- upvalues: ReplicatedStorage (copy)
    local Pack_MODULE = ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Pack_MODULE");
    local PackData = require(Pack_MODULE:FindFirstChild("PackData"));
    local v1 = {};

    for i, _ in pairs(PackData) do
        table.insert(v1, i);
    end;

    table.sort(v1);

    return v1;
end;

local u7 = {
    Transform = function(p2) -- Line: 18, Name: Transform
        -- upvalues: getPackNames (copy), Util (copy)
        local v3 = getPackNames();

        return Util.MakeFuzzyFinder(v3)(p2);
    end,

    Validate = function(p4) -- Line: 24, Name: Validate
        return #p4 > 0, "No pack with that name could be found.";
    end,

    Autocomplete = function(p5) -- Line: 28, Name: Autocomplete
        return p5;
    end,

    Parse = function(p6) -- Line: 32, Name: Parse
        return p6[1];
    end
};

return function(p8) -- Line: 37
    -- upvalues: u7 (copy)
    p8:RegisterType("packName", u7);
end;