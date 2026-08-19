-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");

local function _(p1) -- Line: 5
    return string.format("%02i", p1);
end;

return function(p2) -- Line: 12
    local v3 = math.floor(p2 / 60);

    return string.format("%02i", v3) .. ":" .. string.format("%02i", p2 % 60);
end;