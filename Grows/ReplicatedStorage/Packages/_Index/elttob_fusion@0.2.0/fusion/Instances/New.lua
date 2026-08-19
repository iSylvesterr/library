-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local defaultProps = require(Parent.Instances.defaultProps);
local applyInstanceProps = require(Parent.Instances.applyInstanceProps);
local logError = require(Parent.Logging.logError);

return function(u1) -- Line: 14, Name: New
    -- upvalues: logError (copy), defaultProps (copy), applyInstanceProps (copy)
    return function(p2) -- Line: 15
        -- upvalues: u1 (copy), logError (ref), defaultProps (ref), applyInstanceProps (ref)
        local success, result = pcall(Instance.new, u1);

        if not success then
            logError("cannotCreateClass", nil, u1);
        end;

        local v3 = defaultProps[u1];

        if v3 ~= nil then
            for i, v in pairs(v3) do
                result[i] = v;
            end;
        end;

        applyInstanceProps(p2, result);

        return result;
    end;
end;