-- Decompiled with Potassium's decompiler.

local v1 = {
    SkillBuffRuntimeTag = {
        FloatLightness = "FloatLightness",
        ThunderMutualDmg = "ThunderMutualDmg",
        ReflectThorns = "ReflectThorns",
        EnwindMoveRoot = "EnwindMoveRoot",
        DarkMagicDot = "DarkMagicDot",
        Stun = "Stun",
        Env_Magma = "Env_Magma",
        ElemAttach_Water = "ElemAttach_Water",
        ElemAttach_Fire = "ElemAttach_Fire",
        ElemAttach_Poison = "ElemAttach_Poison",
        SpaceMirrorCast = "SpaceMirrorCast",
        BeSheep = "BeSheep",
        BodyMorph_Arm = "BodyMorph_Arm",
        BodyMorph_Full = "BodyMorph_Full",
        ExtraProj_Count = "ExtraProj_Count",
        ExtraProj_DmgMul = "ExtraProj_DmgMul",
        GiantDmg = "GiantDmg",
        GiantHp = "GiantHp"
    },
    ElementTp = {
        None = 0,
        Wind = 1,
        Fire = 2,
        Water = 3,
        Earth = 4,
        Dark = 5,
        Light = 6,
        Thunder = 7,
        Ice = 8,
        Poison = 9,
        Space = 10
    },
    SkillTp = {
        Roll = 0,
        Base = 1,
        Skill = 2
    },
    EnemyVisibilityMode = {
        Shared = 1,
        Private = 2
    },
    EnemyDamageSource = {
        PlayerSkill = 1,
        SkillDot = 2,
        ReflectThorns = 3,
        SummonAttack = 4,
        NpcSkill = 5,
        Environment = 6
    },
    PlrAttr = {
        Atk = 1,
        Train_Base = 2,
        Train_Mul = 3,
        Cast_Speed = 4,
        HP = 5,
        HP_P = 6,
        Breath_Heal_P = 7,
        Breath_Heal_CD = 8,
        Move_Speed = 9,
        Jump_Height = 10,
        Crit_Rate = 11,
        Crit_Dmg = 12,
        Dmg_Bonus = 13,
        Dmg_Reduction = 14,
        Skill_Haste = 15,
        Move_Speed_P = 16,
        ExtraProjCount = 17,
        ExtraProjDmgMul = 18,
        Luck = 19
    },
    DmgTp = {
        PlayerDmg = 1,
        PlayerDmgCrit = 2,
        NPCDmg = 3,
        NPCDmgCrit = 4,
        Heal = 5,
        HealCrit = 6,
        Bleed = 7,
        Poison = 8,
        Burn = 9
    },
    TipTp = {
        Normal = 1,
        Error = 2,
        Rainbow = 3
    },
    CameraShakeType = {
        Attack = 1,
        Clash = 2,
        BigClash = 3,
        LongClash = 4,
        MagicHit = 5
    },
    CameraShakeAudience = {
        Attacker = 1,
        Victim = 2,
        Nearby = 3,
        AttackerAndVictim = 4
    },
    ItemID = {
        Coin = 1,
        Rebirth = 2,
        Power = 3,
        Level = 4,
        LimitBagSize = 5,
        PowerUsed = 6,
        ExtraMoveSpeed = 7,
        DinosaurCoin = 8,
        EventTicket = 9
    },
    TaskResetType = {
        Timed = 1,
        Daily = 2,
        Once = 3
    },
    SkillEffectTarget = {
        Enemy = 1,
        Ally = 2,
        Self = 3
    },
    SkillBuffEffectType = {
        Dot = 1,
        StatMod = 2,
        CrowdControl = 3,
        ElementTrait = 4,
        CastTrait = 5,
        DungeonPassive = 6
    },
    ElementTraitKind = {
        CondDmgAmp = 1,
        Dot = 2,
        PeriodicCC = 3,
        TimedDetonate = 4,
        Proximity = 5
    },
    ItemType = {
        Item = 0,
        UseItem = 1,
        Material = 2,
        GamePass = 3,
        Pet = 4,
        Enemy = 5,
        Weapon = 6,
        Armor = 13,
        Broom = 11,
        PetEgg = 7,
        Title = 17,
        Skill = 10,
        Potion = 9,
        SkillBuff = 18
    },
    SettingTempType = {
        Slider = 1,
        Toggle = 2,
        Choose = 3,
        Input = 4
    },
    Rare = {
        Xyd1 = 1,
        Xyd2 = 2,
        Xyd3 = 3,
        Xyd4 = 4,
        Xyd5 = 5,
        Xyd6 = 6,
        Xyd7 = 7,
        Xyd8 = 8,
        Xyd9 = 9,
        Xyd10 = 10
    }
};
setmetatable(v1.Rare, {
    __index = { "常见", "罕见", "稀有", "史诗", "传说", "神话", "秘密", "远古", "至尊", "星界" }
});
v1.RobuxType = {
    RobuxItem = 1,
    GamePass = 2
};
v1.DebugTp = {
    Mail = 1,
    Debug = 2,
    Buff = 3,
    All = 99
};
v1.SettingCategory = {
    Special = 1,
    Sound = 2,
    Display = 3,
    Control = 4,
    Other = 5
};
setmetatable(v1.SettingCategory, {
    __index = { "特殊功能", "声音", "显示", "控制", "其他" }
});
v1.SkillBuffAddTp = {
    RfDur = 1,
    Stack = 2,
    RplCh = 3
};
v1.SkillBuffTypeTp = {
    MoveSpeed = 1,
    OutgoingMul = 2,
    Reflect = 3,
    MoveRoot = 4,
    HardControl = 5,
    DarkMagicDot = 6,
    EnvMagmaDot = 7,
    WetAttach = 8,
    ScorchAttach = 9,
    PoisonAttach = 10,
    SpaceMirrorCast = 11,
    BeSheep = 12,
    BodyMorph = 13,
    ExtraProjCount = 14,
    ExtraProjDmgMul = 15,
    HpFlat = 16
};
v1.DungeonPassiveTp = {
    None = 0,
    DungeonOnce = 1,
    PerStageOnce = 2
};

return v1;