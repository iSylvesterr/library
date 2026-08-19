-- Decompiled with Potassium's decompiler.

local v1 = { 7627847305, 71552399, 8095632868, 9568431755, 1787623041, 6785965, 4925297398, 1848784060, 1836038679, 7805349940, 5455502981, 1833666230, 2882755487, 2213470865, 95217455, 10618378026, 327423121, 10916243, 101628045, 1866562571, 425901043 };
local u2 = {};

for _, v in v1 do
    u2[v] = true;
end;

return table.freeze({
    List = v1,

    IsAllowed = function(p3) -- Line: 42, Name: IsAllowed
        -- upvalues: u2 (copy)
        return u2[p3] == true;
    end
});