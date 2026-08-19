-- Decompiled with Potassium's decompiler.

local Copy = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).Copy;
local MotionProfileConfig = require(script.Parent.MotionProfileConfig);
local u3 = {
    get = function(p1) -- Line: 22, Name: get
        -- upvalues: MotionProfileConfig (copy), Copy (copy)
        if type(p1) ~= "string" or p1 == "" then
            return nil;
        end;

        local v2 = MotionProfileConfig[p1];

        if type(v2) ~= "table" then
            return nil;
        end;

        if Copy and Copy.deepCopy then
            return Copy.deepCopy(v2);
        end;

        return table.clone(v2);
    end
};

function u3.merge(p4, p5) -- Line: 43
    -- upvalues: u3 (copy)
    local v6 = not p4 and {} or u3.get(p4) or {};

    if type(p5) == "table" then
        for i, v in pairs(p5) do
            if v ~= nil then
                v6[i] = v;
            end;
        end;
    end;

    if v6.mode == nil and v6.profileName ~= nil then
        return nil;
    end;

    return v6;
end;

return u3;