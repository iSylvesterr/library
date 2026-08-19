-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = { "76099628114697", "82845108244626", "5699970573", "82529943149929", "95251360273062", "139372286111626", "140544781392739", "117139860023809", "121737262679159", "133225734824749", "2772396665", "138261345688132", "78510679369473", "103026003876984", "9113072521", "9118090712", "1845231195", "108019748679059", "114143160379594", "97188619237121" };
local u2 = FastFlags.Replicated("Game.Megaphone.DiceSoundIds", Asserts.Array(Asserts.String), u1);

return table.freeze({
    GetPool = function() -- Line: 57, Name: GetPool
        -- upvalues: u2 (copy)
        return u2:Get();
    end,

    Random = function() -- Line: 61, Name: Random
        -- upvalues: u2 (copy), u1 (copy)
        local v3 = u2:Get();

        if #v3 == 0 then
            v3 = u1;
        end;

        return #v3 == 0 and "" or v3[math.random(#v3)];
    end
});