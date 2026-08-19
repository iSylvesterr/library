-- Decompiled with Potassium's decompiler.

local PlayerAttr = require(script.PlayerAttr);
local u1 = {
    PlayerAttr = PlayerAttr
};

local function _mergeFlatApi(p2) -- Line: 37
    -- upvalues: u1 (copy)
    for i, v in p2 do
        if type(v) == "function" and u1[i] == nil then
            u1[i] = v;
        end;
    end;
end;

for i, v in PlayerAttr do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

return u1;