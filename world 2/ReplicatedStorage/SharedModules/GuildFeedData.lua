-- Decompiled with Potassium's decompiler.

local u1 = {
    Batching = {
        Enabled = true,
        ReactionFlushSeconds = 0.5,
        BroadcastFlushSeconds = 1,
        MaxChangesPerPush = 40
    },
    Kinds = {
        RecordWeight = {
            Id = 1,
            Text = "grew a new record {Detail}kg {Item}"
        },
        FoundPet = {
            Id = 2,
            Text = "found {a} {Item}"
        },
        RareMutation = {
            Id = 3,
            Text = "got {a} {Detail} {Item}"
        },
        BigSale = {
            Id = 4,
            Text = "sold {a} {Item} for {Detail}"
        },
        HatchedEgg = {
            Id = 5,
            Text = "hatched {a} {Item}"
        },
        GiftRequest = {
            Id = 6,
            Text = "is requesting {a} {Item}"
        }
    }
};

function u1.GetKindById(p2) -- Line: 33
    -- upvalues: u1 (copy)
    for i, v in pairs(u1.Kinds) do
        if v.Id == p2 then
            return i, v;
        end;
    end;

    return nil, nil;
end;

u1.RareMutations = {
    Rainbow = true,
    Starstruck = true,
    Aurora = true,
    Glow = true,
    Eclipsed = true,
    Amber = true
};
u1.RarePetRarities = {
    Legendary = true,
    Mythic = true
};
u1.Reactions = {
    MaxPerPlayerPerPost = 3,
    MaxRowsPerPost = 25,
    Emojis = { "🔥", "👍", "😂" }
};
u1.Gifting = {
    Locked = true,
    RequestCooldownSeconds = 21600,
    MaxOpenRequestsPerPlayer = 1,
    DefaultGoal = 10,
    DefaultPerPersonCap = 3,
    MaxGoal = 500,
    MaxAmountPerSend = 100,
    SendCooldownSeconds = 3,
    RequestTtlSeconds = 21600,
    AllowedCategories = {
        Seeds = true,
        Fruits = true,
        Crates = true,
        SeedPacks = true,
        Eggs = true
    },
    ExcludedItems = {
        ["Secret Seed Pack"] = true,
        ["Super Seed Pack"] = true,
        ["Secret Fall Seed Pack"] = true,
        ["Super Fall Seed Pack"] = true,
        ["Test Egg"] = true
    }
};
u1.Feed = {
    MaxPosts = 20,
    PostTtlSeconds = 604800,
    MaxGiftMessages = 30
};

return table.freeze(u1);