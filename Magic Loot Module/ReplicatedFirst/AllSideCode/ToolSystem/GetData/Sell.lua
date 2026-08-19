-- Decompiled with Potassium's decompiler.

local PlayerMirror = require(script.Parent.PlayerMirror);
local u3 = {
    GetGoldAdd = function(p1) -- Line: 34, Name: GetGoldAdd
        if not p1 then
            return 1;
        end;

        local RebirthBonus = p1:FindFirstChild("RebirthBonus");

        if not (RebirthBonus and RebirthBonus:IsA("Folder")) then
            return 1;
        end;

        local GoldAdd = RebirthBonus:FindFirstChild("GoldAdd");

        if not (GoldAdd and GoldAdd:IsA("NumberValue")) then
            return 1;
        end;

        local v2 = tonumber(GoldAdd.Value);

        return (type(v2) ~= "number" or (v2 ~= v2 or v2 <= 0)) and 1 or v2;
    end
};

function u3.GetSellPrice(p4, p5) -- Line: 60
    -- upvalues: u3 (copy), PlayerMirror (copy)
    if not p5 then
        return 0;
    end;

    local v6 = tonumber(p5.GoldValue) or 0;
    local v7 = math.max(0, v6);

    if v7 <= 0 then
        return 0;
    end;

    local v8 = 1;
    local v9;

    if p4 then
        v9 = u3.GetGoldAdd(p4);

        if PlayerMirror.IsHasPass(p4, "DoubleCoins") then
            v8 = 2;
        end;
    else
        v9 = 1;
    end;

    return math.floor(v7 * v9 * v8);
end;

return u3;