-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Parent = require(script.Parent);
require(script.Parent.Types.Interface);

return {
    SmallestSufficient = function(p1) -- Line: 18, Name: SmallestSufficient
        -- upvalues: Asserts (copy), Parent (copy)
        Asserts.number(p1);
        Asserts.cond(p1 > 0);
        local v2 = nil;
        local v3 = nil;

        for _, v in Parent.Directory do
            local SpeedPowerReward = v.SpeedPowerReward;

            if SpeedPowerReward ~= nil then
                if v2 == nil or v2.SpeedPowerReward < SpeedPowerReward then
                    v2 = v;
                end;

                if p1 <= SpeedPowerReward and (v3 == nil or SpeedPowerReward < v3.SpeedPowerReward) then
                    v3 = v;
                end;
            end;
        end;

        return v3 or assert(v2, "Products directory must contain at least one speed-power product");
    end
};