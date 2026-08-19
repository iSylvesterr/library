-- Decompiled with Potassium's decompiler.

local u1 = {
    Items = {
        ["Legendary Pet Teleporter"] = {
            Rarity = "Legendary",
            DisplayName = "Legendary Pet Teleporter",
            Description = "Teleports you into a hunt for a wild Legendary pet. Once 5-8 hunters gather you\'re whisked into a private arena to compete for it. Refunded if no hunt forms in time."
        },
        ["Mythic Pet Teleporter"] = {
            Rarity = "Mythic",
            DisplayName = "Mythic Pet Teleporter",
            Description = "Teleports you into a hunt for a wild Mythic pet. Once 5-8 hunters gather you\'re whisked into a private arena to compete for it. Refunded if no hunt forms in time."
        },
        ["Super Pet Teleporter"] = {
            Rarity = "Super",
            DisplayName = "Super Pet Teleporter",
            Description = "Teleports you into a hunt for a wild Super pet. Once 5-8 hunters gather you\'re whisked into a private arena to compete for it. Refunded if no hunt forms in time."
        }
    },
    Order = { "Legendary Pet Teleporter", "Mythic Pet Teleporter", "Super Pet Teleporter" },
    LegacyLureNames = {
        ["Legendary Pet Teleporter"] = "Legendary Pet Lure",
        ["Mythic Pet Teleporter"] = "Mythic Pet Lure",
        ["Super Pet Teleporter"] = "Super Pet Lure"
    }
};

function u1.Get(p2) -- Line: 53
    -- upvalues: u1 (copy)
    return u1.Items[p2];
end;

function u1.ByRarity(p3) -- Line: 59
    -- upvalues: u1 (copy)
    for i, v in u1.Items do
        if v.Rarity == p3 then
            return i;
        end;
    end;

    return nil;
end;

return u1;