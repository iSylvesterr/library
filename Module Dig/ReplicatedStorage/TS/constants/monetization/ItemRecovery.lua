-- Decompiled with Potassium's decompiler.

local v1 = {
    rare = "Recover Rare",
    epic = "Recover Epic",
    legendary = "Recover Legendary",
    mythic = "Recover Mythic",
    divine = "Recover Divine",
    eternal = "Recover Eternal",
    transcendent = "Recover Transcendent"
};
local u2 = {};

for _, v in require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils").keys(v1) do
    u2[v] = true;
end;

return {
    isRecoverableRarity = function(p3) -- Line: 18, Name: isRecoverableRarity
        -- upvalues: u2 (copy)
        return u2[p3] ~= nil;
    end,

    RECOVERY_PRODUCTS = v1
};