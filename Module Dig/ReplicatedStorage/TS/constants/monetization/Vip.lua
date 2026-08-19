-- Decompiled with Potassium's decompiler.

return {
    VIP_GAMEPASS_NAME = "VIP",
    VIP_ATTRIBUTE = "VIP",
    VIP_LUCK_MULTIPLIER = 2,
    VIP_TIP_MULTIPLIER = 2,
    VIP_TOURIST_SHIRT = "rbxassetid://16962629916",
    VIP_TOURIST_PANTS = "rbxassetid://17015951309",

    hasVip = function(p1) -- Line: 8, Name: hasVip
        local v2;

        if p1 == nil then
            v2 = false;
        else
            v2 = table.find(p1.Gamepasses, "VIP") ~= nil;
        end;

        return v2;
    end
};