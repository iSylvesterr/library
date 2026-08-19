-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
require(Modules.Types);
local Symbol = require(Modules.Symbol);
local CreateDeepTraceback = require(Modules.CreateDeepTraceback);
local Computed = require(script.Parent.Computed);
require(script.Parent.Value);
local ForPairs = Symbol.new("ForPairs");

function v1.__call(p2, u3, u4) -- Line: 20
    -- upvalues: Computed (copy), CreateDeepTraceback (copy)
    local u5 = {};
    local u6 = {};

    return Computed(function(p7) -- Line: 25
        -- upvalues: u3 (copy), CreateDeepTraceback (ref), u5 (copy), u4 (copy), u6 (ref)
        local v8 = p7(u3);
        local v9 = {};

        if typeof(v8) ~= "table" then
            error("ForPairs needs a table value to work\n" .. CreateDeepTraceback());
        end;

        for i, v in v8 do
            if u5[i] ~= v then
                u5[i] = v;
                v9[i] = u4(p7, i, v);
            end;
        end;

        for i, v in u5 do
            if v8[i] == v then
                if not v9[i] then
                    v9[i] = u6[i];
                end;
            else
                u5[i] = v8[i];

                if v8[i] then
                    v9[i] = u4(p7, i, v8[i]);
                end;
            end;
        end;

        u6 = v9;

        return v9;
    end);
end;

function v1.__index(p10, p11) -- Line: 60
    -- upvalues: ForPairs (copy)
    if p11 == "__SEAM_INDEX" then
        return ForPairs;
    end;

    return p11 == "__SEAM_CAN_BE_SCOPED" and true or nil;
end;

return setmetatable({}, v1);