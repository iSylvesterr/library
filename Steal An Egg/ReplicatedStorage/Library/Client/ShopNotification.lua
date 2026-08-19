-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {};
local u2 = {
    [Rarity.Rarities.Cosmic] = true,
    [Rarity.Rarities.Secret] = true,
    [Rarity.Rarities.Eternal] = true,
    [Rarity.Rarities.Divine] = true
};
local u3 = {};

function v1.CheckStock(p4, p5, p6, p7) -- Line: 25
    -- upvalues: u3 (copy), u2 (copy), Message (copy)
    local v8 = u3[p4];

    if not v8 then
        v8 = {};
        u3[p4] = v8;
    end;

    local v9 = v8[p5];
    v8[p5] = p7;

    if v9 == nil then
        return;
    end;

    if p7 > 0 and v9 <= 0 then
        local Rarity2 = p6.Rarity;

        if Rarity2 and u2[Rarity2] then
            local Color = Rarity2.Color;
            Message.Top({
                Time = 5,
                Message = string.format("%s is in the %s!", p6.DisplayName, p4),
                Color = Color,
                Image = p6.Icon
            });
        end;
    end;
end;

return v1;