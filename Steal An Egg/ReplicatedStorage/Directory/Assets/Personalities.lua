-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LotteryCustom = require(ReplicatedStorage.Library.Functions.LotteryCustom);
require(script.Parent.Types.Personality);
require(ReplicatedStorage.Library.Types.AssetItem);
local DeepFreezeUnsafe = require(ReplicatedStorage.Library.Functions.DeepFreezeUnsafe);
local v1 = table.freeze({
    Normal = "Normal",
    Lazy = "Lazy",
    Loyal = "Loyal",
    Energetic = "Energetic",
    InvertedModel = "InvertedModel",
    Shy = "Shy",
    Scared = "Scared",
    ExtremelyEnergetic = "ExtremelyEnergetic",
    UltraLoyal = "UltraLoyal",
    JumpCrazy = "JumpCrazy"
});
local v2 = {
    RollWeight = 12,
    _id = v1.Energetic,
    Movement = {
        WalkSpeedMin = 9,
        WalkSpeedMax = 20,
        IdleSecondsMin = 0.1,
        IdleSecondsMax = 0.75,
        NearOwnerPreference = 0.2,
        IsolationPreference = 0,
        CurvedWanderChance = 0.62,
        BurstChance = 0.42,
        FollowOwnerInPen = false,
        AmbientJumpRatePerSecond = 0,
        AmbientSpinJumpChance = 0
    },
    Greeting = {
        Chance = 1,
        FirstPlacementChance = 1,
        FirstPlacementNormalChance = 0,
        FirstPlacementNormalJumpCount = 4,
        ReturnOrbitChance = 0.6,
        ReturnNormalJumpCount = 3,
        RandomOrbitChance = 0.2,
        RandomOrbitIntervalSeconds = 45,
        DurationSeconds = 6,
        JumpChancePerSecond = 0.85,
        SpinJumpChance = 0.3,
        Texts = { "😊", "😄", "🥰" }
    },
    Affection = {
        Enabled = true,
        Chance = 0.125,
        IntervalSeconds = 5,
        DurationSeconds = 4.5,
        JumpCount = 5,
        Texts = { "😆", "😄", "😁", "😃", "🤪", "😝", "😜", "😋", "😹", "🙀", "😎" }
    }
};
local Greeting = v2.Greeting;
local u3 = DeepFreezeUnsafe({
    Normal = {
        RollWeight = 37,
        _id = v1.Normal,
        Movement = {
            WalkSpeedMin = 6.5,
            WalkSpeedMax = 12,
            IdleSecondsMin = 1.2,
            IdleSecondsMax = 3.2,
            NearOwnerPreference = 0.14,
            IsolationPreference = 0,
            CurvedWanderChance = 0.16,
            BurstChance = 0.035,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 0,
            FirstPlacementNormalChance = 1,
            FirstPlacementNormalJumpCount = 3,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 2,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 45,
            DurationSeconds = 6,
            JumpChancePerSecond = 0.8,
            SpinJumpChance = 0.08,
            Texts = { "😊", "😄", "🥰" }
        },
        Affection = {
            Enabled = true,
            Chance = 0.16666666666666666,
            IntervalSeconds = 5,
            DurationSeconds = 4,
            JumpCount = 2,
            Texts = { "😊", "😄", "🙂", "☺️", "🥰", "😃", "😁", "🤗" }
        }
    },
    Lazy = {
        RollWeight = 15,
        _id = v1.Lazy,
        Movement = {
            WalkSpeedMin = 2.5,
            WalkSpeedMax = 3.75,
            IdleSecondsMin = 6,
            IdleSecondsMax = 15,
            NearOwnerPreference = 0.025,
            IsolationPreference = 0.08,
            CurvedWanderChance = 0.025,
            BurstChance = 0,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0
        },
        Greeting = {
            Chance = 0,
            FirstPlacementChance = 0,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 0,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 1,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 60,
            DurationSeconds = 3.5,
            JumpChancePerSecond = 0.08,
            SpinJumpChance = 0,
            Texts = { "😊", "😄", "🥰" }
        },
        Affection = {
            Enabled = false,
            Chance = 0,
            IntervalSeconds = 80,
            DurationSeconds = 0,
            JumpCount = 0,
            Texts = { "😴", "🥱", "😪", "😌", "😐", "😑", "😶", "🙃" }
        }
    },
    Loyal = {
        RollWeight = 10,
        _id = v1.Loyal,
        Movement = {
            WalkSpeedMin = 7.5,
            WalkSpeedMax = 10,
            IdleSecondsMin = 0.35,
            IdleSecondsMax = 1.25,
            NearOwnerPreference = 0.9,
            IsolationPreference = 0,
            CurvedWanderChance = 0.08,
            BurstChance = 0.055,
            FollowOwnerInPen = true,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 1,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 3,
            ReturnOrbitChance = 0.45,
            ReturnNormalJumpCount = 2,
            RandomOrbitChance = 0.08,
            RandomOrbitIntervalSeconds = 45,
            DurationSeconds = 6.5,
            JumpChancePerSecond = 0.55,
            SpinJumpChance = 0.06,
            Texts = { "Mama" }
        },
        Affection = {
            Enabled = true,
            Chance = 0.002976190476190476,
            IntervalSeconds = 5,
            DurationSeconds = 5,
            JumpCount = 2,
            Texts = { "🥰", "😍", "😊", "☺️", "🤗", "😚" }
        }
    },
    Energetic = v2,
    InvertedModel = {
        RollWeight = 1.5,
        _id = v1.InvertedModel,
        Movement = v2.Movement,
        Greeting = {
            Chance = Greeting.Chance,
            FirstPlacementChance = Greeting.FirstPlacementChance,
            FirstPlacementNormalChance = Greeting.FirstPlacementNormalChance,
            FirstPlacementNormalJumpCount = Greeting.FirstPlacementNormalJumpCount,
            ReturnOrbitChance = Greeting.ReturnOrbitChance,
            ReturnNormalJumpCount = Greeting.ReturnNormalJumpCount,
            RandomOrbitChance = Greeting.RandomOrbitChance,
            RandomOrbitIntervalSeconds = Greeting.RandomOrbitIntervalSeconds,
            DurationSeconds = Greeting.DurationSeconds,
            JumpChancePerSecond = Greeting.JumpChancePerSecond,
            SpinJumpChance = Greeting.SpinJumpChance,
            Texts = { "//ERRsORijwoR//", "0x?#!@NLL", "01011010???", "▓▒░???░▒▓", "M4M4.EXE???", "##!%$@//", "<???:\'aWsFE>", "1010_=249_0101", "??//V//#" }
        },
        Affection = v2.Affection
    },
    Shy = {
        RollWeight = 10,
        _id = v1.Shy,
        Movement = {
            WalkSpeedMin = 3,
            WalkSpeedMax = 5,
            IdleSecondsMin = 5.5,
            IdleSecondsMax = 14,
            NearOwnerPreference = 0,
            IsolationPreference = 0.95,
            CurvedWanderChance = 0.035,
            BurstChance = 0,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0,
            Retreat = {
                TriggerDistance = 22,
                Chance = 0.85,
                MaxTravelDistance = 16
            }
        },
        Greeting = {
            Chance = 0,
            FirstPlacementChance = 0,
            FirstPlacementBubbleChance = 0,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 0,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 0,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 30,
            DurationSeconds = 0,
            JumpChancePerSecond = 0,
            SpinJumpChance = 0,
            Texts = { "😊" }
        },
        Affection = {
            Enabled = false,
            Chance = 0,
            IntervalSeconds = 50,
            DurationSeconds = 0,
            JumpCount = 0,
            Texts = { "😊", "😄", "🥰" }
        }
    },
    Scared = {
        RollWeight = 5,
        _id = v1.Scared,
        Movement = {
            WalkSpeedMin = 20,
            WalkSpeedMax = 40,
            IdleSecondsMin = 0.8,
            IdleSecondsMax = 4,
            NearOwnerPreference = 0,
            IsolationPreference = 1,
            CurvedWanderChance = 0.03,
            BurstChance = 0,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0,
            Retreat = {
                TriggerDistance = 20,
                Chance = 1
            },
            IdleTremble = {
                Amplitude = 1.5,
                CyclesPerSecond = 16
            }
        },
        Greeting = {
            Chance = 0,
            FirstPlacementChance = 0,
            FirstPlacementBubbleChance = 1,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 0,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 0,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 30,
            DurationSeconds = 0,
            JumpChancePerSecond = 0,
            SpinJumpChance = 0,
            Texts = { "Where is MAMA 😰?" }
        },
        Affection = {
            Enabled = false,
            Chance = 0,
            IntervalSeconds = 50,
            DurationSeconds = 0,
            JumpCount = 0,
            Texts = { "😨", "😰" }
        }
    },
    ExtremelyEnergetic = {
        RollWeight = 3.5,
        _id = v1.ExtremelyEnergetic,
        Movement = {
            WalkSpeedMin = 30,
            WalkSpeedMax = 70,
            IdleSecondsMin = 0.05,
            IdleSecondsMax = 0.2,
            NearOwnerPreference = 0.2,
            IsolationPreference = 0,
            CurvedWanderChance = 0.8,
            BurstChance = 0.7,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 3.5,
            AmbientSpinJumpChance = 0.35
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 1,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 5,
            ReturnOrbitChance = 0.75,
            ReturnNormalJumpCount = 5,
            RandomOrbitChance = 0.35,
            RandomOrbitIntervalSeconds = 30,
            DurationSeconds = 6,
            JumpChancePerSecond = 1.8,
            SpinJumpChance = 0.4,
            Texts = { "🤩", "🤪" }
        },
        Affection = {
            Enabled = true,
            Chance = 0.1,
            IntervalSeconds = 5,
            DurationSeconds = 4.5,
            JumpCount = 7,
            Texts = { "🤩", "😆", "🤪" }
        }
    },
    UltraLoyal = {
        RollWeight = 2.5,
        _id = v1.UltraLoyal,
        Movement = {
            WalkSpeedMin = 10,
            WalkSpeedMax = 16,
            IdleSecondsMin = 0.1,
            IdleSecondsMax = 0.5,
            NearOwnerPreference = 0.98,
            IsolationPreference = 0,
            CurvedWanderChance = 0.12,
            BurstChance = 0.1,
            FollowOwnerInPen = true,
            AmbientJumpRatePerSecond = 0.35,
            AmbientSpinJumpChance = 0.1
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 1,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 4,
            ReturnOrbitChance = 0.9,
            ReturnNormalJumpCount = 3,
            RandomOrbitChance = 0.9,
            RandomOrbitIntervalSeconds = 5,
            DurationSeconds = 6.5,
            JumpChancePerSecond = 0.8,
            SpinJumpChance = 0.1,
            Texts = { "Mama 🤗", "Mama 🥰" }
        },
        Affection = {
            Enabled = true,
            Chance = 0.15151515151515152,
            IntervalSeconds = 5,
            DurationSeconds = 5,
            JumpCount = 3,
            Texts = { "🥰", "🤗" }
        }
    },
    JumpCrazy = {
        RollWeight = 3.5,
        _id = v1.JumpCrazy,
        Movement = {
            WalkSpeedMin = 10,
            WalkSpeedMax = 18,
            IdleSecondsMin = 0.05,
            IdleSecondsMax = 0.3,
            NearOwnerPreference = 0.2,
            IsolationPreference = 0,
            CurvedWanderChance = 0.25,
            BurstChance = 0.1,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 12,
            AmbientSpinJumpChance = 0.5
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 0,
            FirstPlacementNormalChance = 1,
            FirstPlacementNormalJumpCount = 8,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 7,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 30,
            DurationSeconds = 6,
            JumpChancePerSecond = 2,
            SpinJumpChance = 0.5,
            Texts = { "😆", "😄", "😁", "😃", "🤪", "😝", "😜", "😋", "😹", "🙀", "😎" }
        },
        Affection = {
            Enabled = true,
            Chance = 0.1,
            IntervalSeconds = 5,
            DurationSeconds = 4,
            JumpCount = 8,
            Texts = { "😆", "😄", "😁", "😃", "🤪", "😝", "😜", "😋", "😹", "🙀", "😎" }
        }
    }
});
local v4 = table.freeze({
    {
        Personality = v1.Normal,
        Weight = u3[v1.Normal].RollWeight
    },
    {
        Personality = v1.Lazy,
        Weight = u3[v1.Lazy].RollWeight
    },
    {
        Personality = v1.Loyal,
        Weight = u3[v1.Loyal].RollWeight
    },
    {
        Personality = v1.Energetic,
        Weight = u3[v1.Energetic].RollWeight
    },
    {
        Personality = v1.InvertedModel,
        Weight = u3[v1.InvertedModel].RollWeight
    },
    {
        Personality = v1.Shy,
        Weight = u3[v1.Shy].RollWeight
    },
    {
        Personality = v1.Scared,
        Weight = u3[v1.Scared].RollWeight
    },
    {
        Personality = v1.ExtremelyEnergetic,
        Weight = u3[v1.ExtremelyEnergetic].RollWeight
    },
    {
        Personality = v1.UltraLoyal,
        Weight = u3[v1.UltraLoyal].RollWeight
    },
    {
        Personality = v1.JumpCrazy,
        Weight = u3[v1.JumpCrazy].RollWeight
    }
});
local u5 = table.freeze({
    { v1.Normal, u3[v1.Normal].RollWeight },
    { v1.Lazy, u3[v1.Lazy].RollWeight },
    { v1.Loyal, u3[v1.Loyal].RollWeight },
    { v1.Energetic, u3[v1.Energetic].RollWeight },
    { v1.InvertedModel, u3[v1.InvertedModel].RollWeight },
    { v1.Shy, u3[v1.Shy].RollWeight },
    { v1.Scared, u3[v1.Scared].RollWeight },
    { v1.ExtremelyEnergetic, u3[v1.ExtremelyEnergetic].RollWeight },
    { v1.UltraLoyal, u3[v1.UltraLoyal].RollWeight },
    { v1.JumpCrazy, u3[v1.JumpCrazy].RollWeight }
});
local u10 = {
    Personalities = v1,
    Configs = u3,
    RollTable = v4,

    IsPersonality = function(p6) -- Line: 489, Name: IsPersonality
        -- upvalues: u3 (copy)
        return u3[p6] ~= nil;
    end,

    GetConfig = function(p7) -- Line: 493, Name: GetConfig
        -- upvalues: u3 (copy)
        local v8 = u3[p7];
        local v9 = `Unknown asset personality "{p7}"`;
        assert(v8 ~= nil, v9);

        return v8;
    end
};

function u10.Roll(p11) -- Line: 499
    -- upvalues: LotteryCustom (copy), u5 (copy), u10 (copy)
    local v12 = LotteryCustom(p11, u5);
    local v13;

    if typeof(v12) == "string" then
        v13 = u10.IsPersonality(v12);
    else
        v13 = false;
    end;

    assert(v13, "Asset personality roll failed");

    return v12;
end;

function u10.CreateNewItemData(p14, p15, p16) -- Line: 505
    -- upvalues: u10 (copy)
    local v17 = table.clone(p14);
    v17.Mutations = table.clone(p14.Mutations);

    if p16 == nil then
        v17.Personality = u10.Roll(p15);
    else
        local v18 = u10.IsPersonality(p16);
        assert(v18, "Invalid asset personality override");
        v17.Personality = p16;
    end;

    v17.HasBeenFirstPlaced = false;

    return v17;
end;

function u10.ResetFirstPlacementForTransfer(p19) -- Line: 522
    local v20 = table.clone(p19);
    v20.Mutations = table.clone(p19.Mutations);
    v20.HasBeenFirstPlaced = false;

    return v20;
end;

return u10;