-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = RunService:IsServer();
local AllSideCode = game:GetService("ReplicatedFirst").AllSideCode;
require(AllSideCode.Interface);
local u2 = {};
local ToolBasic = AllSideCode:FindFirstChild("ToolBasic");
local ToolSystem = AllSideCode:FindFirstChild("ToolSystem");
local u3 = nil;
local u4 = nil;
local u5;

if u1 then
    local ServerStorage = game:GetService("ServerStorage");
    u5 = ServerStorage;
    local ServerSideCode = ServerStorage:FindFirstChild("ServerSideCode");

    if ServerSideCode then
        u3 = ServerSideCode:FindFirstChild("System");
        local AI = ServerSideCode:FindFirstChild("AI");

        if AI then
            u4 = AI:FindFirstChild("Shared");
        end;
    end;
else
    u5 = nil;
end;

local u6 = {
    GameAnalytics = function() -- Line: 111, Name: GameAnalytics
        -- upvalues: u5 (ref)
        if u5 then
            return u5:FindFirstChild("GameAnalytics");
        end;

        return nil;
    end
};
local u7 = {
    SummonAggroSystem = function() -- Line: 121, Name: SummonAggroSystem
        -- upvalues: u4 (ref)
        if u4 then
            return u4:FindFirstChild("SummonAggroSystem");
        end;

        return nil;
    end,

    NPCMotorHumanoid = function() -- Line: 127, Name: NPCMotorHumanoid
        -- upvalues: u4 (ref)
        if u4 then
            return u4:FindFirstChild("NPCMotorHumanoid");
        end;

        return nil;
    end,

    NPCDamageCompliance = function() -- Line: 133, Name: NPCDamageCompliance
        -- upvalues: u4 (ref)
        if u4 then
            return u4:FindFirstChild("NPCDamageCompliance");
        end;

        return nil;
    end,

    LogicalDisplace = function() -- Line: 139, Name: LogicalDisplace
        -- upvalues: u4 (ref)
        if u4 then
            return u4:FindFirstChild("LogicalDisplace");
        end;

        return nil;
    end
};
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local function _getClientSystemPath() -- Line: 155
    -- upvalues: ReplicatedStorage (copy)
    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

    if ClientSideCode then
        return ClientSideCode:FindFirstChild("SystemModule");
    end;

    return nil;
end;

local function _getClientSkillPath() -- Line: 168
    -- upvalues: ReplicatedStorage (copy)
    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

    if ClientSideCode then
        return ClientSideCode:FindFirstChild("SystemSkill");
    end;

    return nil;
end;

local function _getClientSkillModuleBySegments(p8) -- Line: 182
    -- upvalues: ReplicatedStorage (copy)
    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");
    local v9;

    if ClientSideCode then
        v9 = ClientSideCode:FindFirstChild("SystemSkill");
    else
        v9 = nil;
    end;

    for _, v in p8 do
        if not v9 then
            return nil;
        end;

        v9 = v9:FindFirstChild(v);
    end;

    if v9 and v9:IsA("ModuleScript") then
        return v9;
    end;

    return nil;
end;

local u10 = {
    GetSkillData = function() -- Line: 198, Name: GetSkillData
        -- upvalues: _getClientSkillModuleBySegments (copy)
        return _getClientSkillModuleBySegments({ "BaseSkill", "GetSkillData" });
    end,

    BaseSkillClient = function() -- Line: 201, Name: BaseSkillClient
        -- upvalues: _getClientSkillModuleBySegments (copy)
        return _getClientSkillModuleBySegments({ "BaseSkill", "BaseSkillClient" });
    end,

    GroupSkillClient = function() -- Line: 204, Name: GroupSkillClient
        -- upvalues: _getClientSkillModuleBySegments (copy)
        return _getClientSkillModuleBySegments({ "GroupSkill", "GroupSkillClient" });
    end,

    PlayerAimSync = function() -- Line: 207, Name: PlayerAimSync
        -- upvalues: _getClientSkillModuleBySegments (copy)
        return _getClientSkillModuleBySegments({ "BaseSkill", "PlayerAimSync" });
    end,

    AutoCastLookAt = function() -- Line: 210, Name: AutoCastLookAt
        -- upvalues: _getClientSkillModuleBySegments (copy)
        return _getClientSkillModuleBySegments({ "BaseSkill", "AutoCastLookAt" });
    end,

    SkillEventConst = function() -- Line: 213, Name: SkillEventConst
        -- upvalues: _getClientSkillModuleBySegments (copy)
        return _getClientSkillModuleBySegments({ "BaseSkill", "SkillEventConst" });
    end,

    MultThunderTramplePath = function() -- Line: 216, Name: MultThunderTramplePath
        -- upvalues: _getClientSkillModuleBySegments (copy)
        return _getClientSkillModuleBySegments({ "SkillModule", "MultThunderTrample1", "MultThunderTramplePath" });
    end
};

local function _getModuleInstance(p11, p12) -- Line: 228
    return p11:FindFirstChild(p12);
end;

local function _getFXUtilChildModule(p13) -- Line: 238
    -- upvalues: ToolSystem (copy)
    local FXUtil = ToolSystem:FindFirstChild("FXUtil");

    if FXUtil then
        return FXUtil:FindFirstChild(p13);
    end;

    return nil;
end;

local u14 = {
    InsMgr = function() -- Line: 246, Name: InsMgr
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("InsMgr");
    end,

    VisibleMgr = function() -- Line: 247, Name: VisibleMgr
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("VisibleMgr");
    end,

    Log = function() -- Line: 248, Name: Log
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("Log");
    end,

    MathMgr = function() -- Line: 249, Name: MathMgr
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("MathMgr");
    end,

    Copy = function() -- Line: 250, Name: Copy
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("Copy");
    end,

    ObjectPoolUtil = function() -- Line: 251, Name: ObjectPoolUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("ObjectPoolUtil");
    end,

    HumanModule = function() -- Line: 252, Name: HumanModule
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("HumanModule");
    end,

    ResRestore = function() -- Line: 253, Name: ResRestore
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("ResRestore");
    end,

    ViewportFrameModule = function() -- Line: 254, Name: ViewportFrameModule
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("ViewportFrameModule");
    end,

    TimeTransfer = function() -- Line: 255, Name: TimeTransfer
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("TimeTransfer");
    end,

    UISetMgr = function() -- Line: 256, Name: UISetMgr
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("UISetMgr");
    end,

    TranslationHelper = function() -- Line: 257, Name: TranslationHelper
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("TranslationHelper");
    end,

    ConfigInstance = function() -- Line: 258, Name: ConfigInstance
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("ConfigInstance");
    end,

    GameConfig = function() -- Line: 259, Name: GameConfig
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("GameConfig");
    end,

    SpecialEnemySchedule = function() -- Line: 260, Name: SpecialEnemySchedule
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("SpecialEnemySchedule");
    end,

    AssetPaths = function() -- Line: 261, Name: AssetPaths
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("AssetPaths");
    end,

    AssetRegistry = function() -- Line: 262, Name: AssetRegistry
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("AssetRegistry");
    end,

    NetMsg = function() -- Line: 263, Name: NetMsg
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("NetMsg");
    end,

    NetChannel = function() -- Line: 264, Name: NetChannel
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("NetChannel");
    end,

    NetPipeConfig = function() -- Line: 265, Name: NetPipeConfig
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("NetPipeConfig");
    end,

    NetChannelMap = function() -- Line: 266, Name: NetChannelMap
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("NetChannelMap");
    end,

    RankConfig = function() -- Line: 267, Name: RankConfig
        -- upvalues: ToolBasic (copy)
        return ToolBasic:FindFirstChild("RankConfig");
    end
};
local u15 = {
    EnumMgr = function() -- Line: 272, Name: EnumMgr
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("EnumMgr");
    end,

    AnimationModule = function() -- Line: 273, Name: AnimationModule
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("AnimationModule");
    end,

    CfgFind = function() -- Line: 274, Name: CfgFind
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("CfgFind");
    end,

    GetData = function() -- Line: 275, Name: GetData
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("GetData");
    end,

    SetData = function() -- Line: 276, Name: SetData
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("SetData");
    end,

    DeviceType = function() -- Line: 277, Name: DeviceType
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("DeviceType");
    end,

    UIMgr = function() -- Line: 278, Name: UIMgr
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("UIMgr");
    end,

    ScrollUtil = function() -- Line: 279, Name: ScrollUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("ScrollUtil");
    end,

    ShowDetail = function() -- Line: 280, Name: ShowDetail
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("ShowDetail");
    end,

    TipsModule = function() -- Line: 281, Name: TipsModule
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("TipsModule");
    end,

    SoundModule = function() -- Line: 282, Name: SoundModule
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("SoundModule");
    end,

    Check = function() -- Line: 283, Name: Check
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("Check");
    end,

    AssetAcquire = function() -- Line: 284, Name: AssetAcquire
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("AssetAcquire");
    end,

    ResourceUtil = function() -- Line: 285, Name: ResourceUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("ResourceUtil");
    end,

    SkillPreloadUtil = function() -- Line: 286, Name: SkillPreloadUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("SkillPreloadUtil");
    end,

    SkillBuffUtil = function() -- Line: 287, Name: SkillBuffUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("SkillBuffUtil");
    end,

    AddListen = function() -- Line: 288, Name: AddListen
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("AddListen");
    end,

    RequestRateLimit = function() -- Line: 289, Name: RequestRateLimit
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("RequestRateLimit");
    end,

    UIanima = function() -- Line: 290, Name: UIanima
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("UIanima");
    end,

    EquipShopUi = function() -- Line: 291, Name: EquipShopUi
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("EquipShopUi");
    end,

    EquipShop = function() -- Line: 292, Name: EquipShop
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("EquipShop");
    end,

    ArmorModelUtil = function() -- Line: 293, Name: ArmorModelUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("ArmorModelUtil");
    end,

    SequenceManager = function() -- Line: 294, Name: SequenceManager
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("SequenceManager");
    end,

    SpeedLineFX = function() -- Line: 295, Name: SpeedLineFX
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("SpeedLineFX");
    end,

    WorldUtil = function() -- Line: 296, Name: WorldUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("WorldUtil");
    end,

    EnemyVisibilityUtil = function() -- Line: 297, Name: EnemyVisibilityUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("EnemyVisibilityUtil");
    end,

    EnemyLogicalTypes = function() -- Line: 298, Name: EnemyLogicalTypes
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("EnemyLogicalTypes");
    end,

    EnemyLogicalPartOffset = function() -- Line: 299, Name: EnemyLogicalPartOffset
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("EnemyLogicalPartOffset");
    end,

    CharacterMorphUtil = function() -- Line: 300, Name: CharacterMorphUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("CharacterMorphUtil");
    end,

    SoundInstance = function() -- Line: 301, Name: SoundInstance
        -- upvalues: ToolSystem (copy)
        local SoundModule = ToolSystem:FindFirstChild("SoundModule");

        if SoundModule then
            return SoundModule:FindFirstChild("SoundInstance");
        end;

        return nil;
    end,

    FootstepSoundsConfig = function() -- Line: 308, Name: FootstepSoundsConfig
        -- upvalues: ToolSystem (copy)
        local FootstepSound = ToolSystem:FindFirstChild("FootstepSound");

        if FootstepSound then
            return FootstepSound:FindFirstChild("FootstepSoundsConfig");
        end;

        return nil;
    end,

    TipsRenderer = function() -- Line: 315, Name: TipsRenderer
        -- upvalues: ToolSystem (copy)
        local TipsModule = ToolSystem:FindFirstChild("TipsModule");

        if TipsModule then
            return TipsModule:FindFirstChild("TipsRenderer");
        end;

        return nil;
    end,

    TipsDamageTip = function() -- Line: 322, Name: TipsDamageTip
        -- upvalues: ToolSystem (copy)
        local TipsModule = ToolSystem:FindFirstChild("TipsModule");

        if TipsModule then
            return TipsModule:FindFirstChild("DamageTip");
        end;

        return nil;
    end,

    TipsConfig = function() -- Line: 329, Name: TipsConfig
        -- upvalues: ToolSystem (copy)
        local TipsModule = ToolSystem:FindFirstChild("TipsModule");

        if TipsModule then
            return TipsModule:FindFirstChild("TipsConfig");
        end;

        return nil;
    end,

    LocalMagicMissilePresentation = function() -- Line: 336, Name: LocalMagicMissilePresentation
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("LocalMagicMissilePresentation");
    end,

    LocalDrinkPotionPresentation = function() -- Line: 337, Name: LocalDrinkPotionPresentation
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("LocalDrinkPotionPresentation");
    end,

    LocalSkillPresentation = function() -- Line: 338, Name: LocalSkillPresentation
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("LocalSkillPresentation");
    end,

    HeldItemVisualUtil = function() -- Line: 339, Name: HeldItemVisualUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("HeldItemVisualUtil");
    end,

    BezierCurve = function() -- Line: 340, Name: BezierCurve
        -- upvalues: ToolSystem (copy)
        local FXUtil = ToolSystem:FindFirstChild("FXUtil");

        if FXUtil then
            return FXUtil:FindFirstChild("BezierCurve");
        end;

        return nil;
    end,

    BurstStone = function() -- Line: 341, Name: BurstStone
        -- upvalues: ToolSystem (copy)
        local FXUtil = ToolSystem:FindFirstChild("FXUtil");

        if FXUtil then
            return FXUtil:FindFirstChild("BurstStone");
        end;

        return nil;
    end,

    FloorWave = function() -- Line: 342, Name: FloorWave
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("FloorWave");
    end,

    FXUtil = function() -- Line: 343, Name: FXUtil
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("FXUtil");
    end,

    GhostShadow = function() -- Line: 344, Name: GhostShadow
        -- upvalues: ToolSystem (copy)
        local FXUtil = ToolSystem:FindFirstChild("FXUtil");

        if FXUtil then
            return FXUtil:FindFirstChild("GhostShadow");
        end;

        return nil;
    end,

    Lightning = function() -- Line: 345, Name: Lightning
        -- upvalues: ToolSystem (copy)
        local FXUtil = ToolSystem:FindFirstChild("FXUtil");

        if FXUtil then
            return FXUtil:FindFirstChild("Lightning");
        end;

        return nil;
    end,

    PartIcles = function() -- Line: 347, Name: PartIcles
        -- upvalues: ToolSystem (copy)
        local FXUtil = ToolSystem:FindFirstChild("FXUtil");

        if FXUtil then
            return FXUtil:FindFirstChild("PartIcles");
        end;

        return nil;
    end,

    HatchEffect = function() -- Line: 348, Name: HatchEffect
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("HatchEffect");
    end,

    ItemEffect = function() -- Line: 349, Name: ItemEffect
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("ItemEffect");
    end,

    PlayerData = function() -- Line: 350, Name: PlayerData
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("PlayerData");
    end,

    RayCast = function() -- Line: 351, Name: RayCast
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("RayCast");
    end,

    PhysicsMotion = function() -- Line: 352, Name: PhysicsMotion
        -- upvalues: ToolSystem (copy)
        local PhysicsMotion = ToolSystem:FindFirstChild("PhysicsMotion");

        if not PhysicsMotion then
            return nil;
        end;

        local init = PhysicsMotion:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return PhysicsMotion;
    end,

    HitCameraShake = function() -- Line: 363, Name: HitCameraShake
        -- upvalues: ToolSystem (copy)
        local HitCameraShake = ToolSystem:FindFirstChild("HitCameraShake");

        if not HitCameraShake then
            return nil;
        end;

        local init = HitCameraShake:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return HitCameraShake;
    end,

    LogicalDisplaceProfile = function() -- Line: 374, Name: LogicalDisplaceProfile
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("LogicalDisplaceProfile");
    end,

    HitPhysics = function() -- Line: 377, Name: HitPhysics
        -- upvalues: ToolSystem (copy)
        local HitPhysics = ToolSystem:FindFirstChild("HitPhysics");

        if not HitPhysics then
            return nil;
        end;

        local init = HitPhysics:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return HitPhysics;
    end,

    MonsterClientSimulationGate = function() -- Line: 388, Name: MonsterClientSimulationGate
        -- upvalues: ToolSystem (copy)
        local MonsterClientSimulationGate = ToolSystem:FindFirstChild("MonsterClientSimulationGate");

        if not MonsterClientSimulationGate then
            return nil;
        end;

        local init = MonsterClientSimulationGate:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return MonsterClientSimulationGate;
    end,

    SkillFxGate = function() -- Line: 399, Name: SkillFxGate
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("SkillFxGate");
    end,

    SkillHitPresentation = function() -- Line: 400, Name: SkillHitPresentation
        -- upvalues: ToolSystem (copy)
        local SkillHitPresentation = ToolSystem:FindFirstChild("SkillHitPresentation");

        if not SkillHitPresentation then
            return nil;
        end;

        local init = SkillHitPresentation:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return SkillHitPresentation;
    end,

    SkillTelegraph = function() -- Line: 411, Name: SkillTelegraph
        -- upvalues: ToolSystem (copy)
        local SkillTelegraph = ToolSystem:FindFirstChild("SkillTelegraph");

        if not SkillTelegraph then
            return nil;
        end;

        local init = SkillTelegraph:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return SkillTelegraph;
    end,

    NPCCosmeticHit = function() -- Line: 422, Name: NPCCosmeticHit
        -- upvalues: ToolSystem (copy)
        local NPCCosmeticHit = ToolSystem:FindFirstChild("NPCCosmeticHit");

        if not NPCCosmeticHit then
            return nil;
        end;

        local init = NPCCosmeticHit:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return NPCCosmeticHit;
    end,

    MonsterLocomotion = function() -- Line: 433, Name: MonsterLocomotion
        -- upvalues: ToolSystem (copy)
        local MonsterLocomotion = ToolSystem:FindFirstChild("MonsterLocomotion");

        if not MonsterLocomotion then
            return nil;
        end;

        local init = MonsterLocomotion:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return MonsterLocomotion;
    end,

    MonsterDeathFx = function() -- Line: 444, Name: MonsterDeathFx
        -- upvalues: ToolSystem (copy)
        local MonsterDeathFx = ToolSystem:FindFirstChild("MonsterDeathFx");

        if not MonsterDeathFx then
            return nil;
        end;

        local init = MonsterDeathFx:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return MonsterDeathFx;
    end,

    PlayerHitPresentation = function() -- Line: 455, Name: PlayerHitPresentation
        -- upvalues: ToolSystem (copy)
        local PlayerHitPresentation = ToolSystem:FindFirstChild("PlayerHitPresentation");

        if not PlayerHitPresentation then
            return nil;
        end;

        local init = PlayerHitPresentation:FindFirstChild("init");

        if init and init:IsA("ModuleScript") then
            return init;
        end;

        return PlayerHitPresentation;
    end,

    NetWork = function() -- Line: 466, Name: NetWork
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("NetWork");
    end,

    SystemGameConfig = function() -- Line: 467, Name: SystemGameConfig
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("SystemGameConfig");
    end,

    UpdateModule = function() -- Line: 468, Name: UpdateModule
        -- upvalues: ToolSystem (copy)
        return ToolSystem:FindFirstChild("UpdateModule");
    end
};
local u16 = { {
        scope = "ToolBasic",
        name = "NetMsg"
    }, {
        scope = "ToolSystem",
        name = "EnumMgr"
    } };
local u17 = {
    ToolBasic = u14,
    ToolSystem = u15
};
local u18 = {};
local u19 = {};

local function _loadModule(p20, p21, p22, p23, p24, p25) -- Line: 527
    -- upvalues: u18 (copy), u19 (copy)
    if u18[p20] then
        return u18[p20];
    end;

    if u19[p20] then
        warn("检测到潜在的循环引用，模块正在加载中:", p20);
        local v26 = p23 and p23();

        if v26 then
            return require(v26);
        end;

        local v27 = p22 and p22();

        if v27 then
            return require(v27);
        end;

        return nil;
    end;

    if not p22 then
        if p24 then
            warn(p21 .. "不存在:", p20);
        end;

        return nil;
    end;

    local v28 = p22();

    if not v28 then
        if p25 then
            warn(p21 .. "路径不存在:", p20);
        end;

        return nil;
    end;

    u19[p20] = true;
    local success, result = pcall(require, v28);
    u19[p20] = nil;

    if success then
        u18[p20] = result;

        return result;
    end;

    warn("加载" .. p21 .. "失败:", p20, result);

    return nil;
end;

local function _loadToolModule(p29) -- Line: 590
    -- upvalues: u14 (copy), _loadModule (copy)
    local u30 = u14[p29];

    local function resolvePath() -- Line: 592
        -- upvalues: u30 (copy)
        if u30 then
            return u30();
        end;

        return nil;
    end;

    return _loadModule(p29, "工具模块", u30 and resolvePath and resolvePath or nil, resolvePath, true, true);
end;

local function _loadSystemModule(p31) -- Line: 607
    -- upvalues: u15 (copy), _loadModule (copy)
    local u32 = u15[p31];

    local function v33() -- Line: 609
        -- upvalues: u32 (copy)
        if u32 then
            return u32();
        end;

        return nil;
    end;

    return _loadModule(p31, "业务模块", u32 and v33 and v33 or nil, v33, true, true);
end;

local function _eagerLoadWhitelistedModules() -- Line: 623
    -- upvalues: u16 (copy), u17 (copy), u18 (copy), u2 (copy)
    for _, v in u16 do
        local v34 = u17[v.scope];

        if v34 then
            local v35 = v34[v.name];

            if v35 then
                local v36 = v35();

                if v36 then
                    local success, result = pcall(require, v36);

                    if success then
                        u18[v.name] = result;
                        u2[v.name] = result;
                    else
                        warn("[UtilsSystem] 非延迟加载失败:", v.name, result);
                    end;
                else
                    warn("[UtilsSystem] 非延迟白名单模块路径不存在:", v.scope, v.name);
                end;
            else
                warn("[UtilsSystem] 非延迟白名单模块未注册:", v.scope, v.name);
            end;
        else
            warn("[UtilsSystem] 非延迟白名单 scope 无效:", v.scope, v.name);
        end;
    end;
end;

local function _loadServerRootModule(p37) -- Line: 660
    -- upvalues: u1 (copy), u6 (copy), _loadModule (copy)
    if not u1 then
        warn("ServerStorage 根模块仅在服务器端可用:", p37);

        return nil;
    end;

    local u38 = u6[p37];

    local function v39() -- Line: 667
        -- upvalues: u38 (copy)
        if u38 then
            return u38();
        end;

        return nil;
    end;

    return _loadModule(p37, "ServerStorage 根模块", u38 and v39 and v39 or nil, v39, true, true);
end;

local function _loadServerSharedModule(p40) -- Line: 683
    -- upvalues: u1 (copy), u7 (copy), _loadModule (copy)
    if not u1 then
        return nil;
    end;

    local u41 = u7[p40];

    local function v42() -- Line: 689
        -- upvalues: u41 (copy)
        if u41 then
            return u41();
        end;

        return nil;
    end;

    return _loadModule(p40, "服务端 AI 共享模块", u41 and v42 and v42 or nil, v42, true, true);
end;

local function _loadServerSystemModule(u43) -- Line: 705
    -- upvalues: u1 (copy), u3 (ref), _loadModule (copy)
    if not u1 then
        warn("服务器端模块仅在服务器端可用:", u43);

        return nil;
    end;

    if u3 then
        local function v44() -- Line: 715
            -- upvalues: u3 (ref), u43 (copy)
            return u3:FindFirstChild(u43);
        end;

        return _loadModule(u43, "服务器端系统模块", v44, v44, false, false);
    end;

    warn("服务器端系统路径不存在");

    return nil;
end;

local function _getClientSystemModuleScript(p45, p46) -- Line: 729
    if not p45 then
        return nil;
    end;

    local v47 = p45:FindFirstChild(p46);

    if not v47 then
        return nil;
    end;

    if v47:IsA("ModuleScript") then
        return v47;
    end;

    local init = v47:FindFirstChild("init");

    if init and init:IsA("ModuleScript") then
        return init;
    end;

    return nil;
end;

local function _loadClientSystemModule(u48) -- Line: 753
    -- upvalues: ReplicatedStorage (copy), _loadModule (copy)
    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");
    local u49;

    if ClientSideCode then
        u49 = ClientSideCode:FindFirstChild("SystemModule");
    else
        u49 = nil;
    end;

    if u49 then
        return _loadModule(u48, "客户端系统模块", function() -- Line: 760, Name: resolvePath
            -- upvalues: u49 (copy), u48 (copy)
            local v50 = u49;

            if not v50 then
                return nil;
            end;

            local v51 = v50:FindFirstChild(u48);

            if not v51 then
                return nil;
            end;

            if v51:IsA("ModuleScript") then
                return v51;
            end;

            local init = v51:FindFirstChild("init");

            if init and init:IsA("ModuleScript") then
                return init;
            end;

            return nil;
        end, function() -- Line: 768
            -- upvalues: ReplicatedStorage (ref), u48 (copy)
            local ClientSideCode2 = ReplicatedStorage:FindFirstChild("ClientSideCode");
            local v52;

            if ClientSideCode2 then
                v52 = ClientSideCode2:FindFirstChild("SystemModule");
            else
                v52 = nil;
            end;

            if not v52 then
                return nil;
            end;

            local v53 = v52:FindFirstChild(u48);

            if not v53 then
                return nil;
            end;

            if v53:IsA("ModuleScript") then
                return v53;
            end;

            local init = v53:FindFirstChild("init");

            if init and init:IsA("ModuleScript") then
                return init;
            end;

            return nil;
        end, false, false);
    end;

    warn("客户端系统路径不存在");

    return nil;
end;

local function _loadClientSkillModule(p54) -- Line: 782
    -- upvalues: u10 (copy), _loadModule (copy)
    local u55 = u10[p54];

    if not u55 then
        return nil;
    end;

    local function v56() -- Line: 787
        -- upvalues: u55 (copy)
        return u55();
    end;

    return _loadModule(p54, "客户端技能模块", v56, v56, true, true);
end;

local function _getMsgSubFolder(p57) -- Line: 812
    -- upvalues: ReplicatedStorage (copy)
    local v58 = ReplicatedStorage:FindFirstChild("Msg") or ReplicatedStorage:WaitForChild("Msg", 15);

    if v58 then
        return v58:FindFirstChild(p57) or v58:WaitForChild(p57, 15);
    end;

    return nil;
end;

local function _tryMergeMissingMsgChildrenIntoLookup(p59, p60) -- Line: 833
    -- upvalues: _getMsgSubFolder (copy)
    local v61 = _getMsgSubFolder(p60);

    if not v61 then
        return;
    end;

    for _, child in pairs(v61:GetChildren()) do
        if rawget(p59, child.Name) == nil then
            rawset(p59, child.Name, child);
        end;
    end;
end;

local function _attachLazyMsgLookupSync(p62, u63) -- Line: 855
    -- upvalues: _tryMergeMissingMsgChildrenIntoLookup (copy)
    setmetatable(p62, {
        __index = function(p64, p65) -- Line: 860, Name: __index
            -- upvalues: _tryMergeMissingMsgChildrenIntoLookup (ref), u63 (copy)
            if typeof(p65) ~= "string" then
                return nil;
            end;

            local v66 = rawget(p64, p65);

            if v66 ~= nil then
                return v66;
            end;

            _tryMergeMissingMsgChildrenIntoLookup(p64, u63);

            return rawget(p64, p65);
        end
    });

    return p62;
end;

local function _createEventTable(p67) -- Line: 881
    -- upvalues: _getMsgSubFolder (copy)
    local v68 = {};
    local v69 = _getMsgSubFolder(p67);

    if not v69 then
        return v68;
    end;

    for _, child in pairs(v69:GetChildren()) do
        v68[child.Name] = child;
    end;

    return v68;
end;

local v70 = _createEventTable("Event");
local v71 = {};
local u72 = "Event";

function v71.__index(p73, p74) -- Line: 860
    -- upvalues: _tryMergeMissingMsgChildrenIntoLookup (copy), u72 (copy)
    if typeof(p74) ~= "string" then
        return nil;
    end;

    local v75 = rawget(p73, p74);

    if v75 ~= nil then
        return v75;
    end;

    _tryMergeMissingMsgChildrenIntoLookup(p73, u72);

    return rawget(p73, p74);
end;

setmetatable(v70, v71);
u2.Event = v70;
local v76 = _createEventTable("RemoteEvent");
local v77 = {};
local u78 = "RemoteEvent";

function v77.__index(p79, p80) -- Line: 860
    -- upvalues: _tryMergeMissingMsgChildrenIntoLookup (copy), u78 (copy)
    if typeof(p80) ~= "string" then
        return nil;
    end;

    local v81 = rawget(p79, p80);

    if v81 ~= nil then
        return v81;
    end;

    _tryMergeMissingMsgChildrenIntoLookup(p79, u78);

    return rawget(p79, p80);
end;

setmetatable(v76, v77);
u2.RemoteEvent = v76;
local v82 = _createEventTable("RemoteFunction");
local v83 = {};
local u84 = "RemoteFunction";

function v83.__index(p85, p86) -- Line: 860
    -- upvalues: _tryMergeMissingMsgChildrenIntoLookup (copy), u84 (copy)
    if typeof(p86) ~= "string" then
        return nil;
    end;

    local v87 = rawget(p85, p86);

    if v87 ~= nil then
        return v87;
    end;

    _tryMergeMissingMsgChildrenIntoLookup(p85, u84);

    return rawget(p85, p86);
end;

setmetatable(v82, v83);
u2.RemoteFunction = v82;
local v88 = _createEventTable("Function");
local v89 = {};
local u90 = "Function";

function v89.__index(p91, p92) -- Line: 860
    -- upvalues: _tryMergeMissingMsgChildrenIntoLookup (copy), u90 (copy)
    if typeof(p92) ~= "string" then
        return nil;
    end;

    local v93 = rawget(p91, p92);

    if v93 ~= nil then
        return v93;
    end;

    _tryMergeMissingMsgChildrenIntoLookup(p91, u90);

    return rawget(p91, p92);
end;

setmetatable(v88, v89);
u2.Function = v88;
u2.ReplicatedStorage = game:GetService("ReplicatedStorage");
u2.ReplicatedFirst = game:GetService("ReplicatedFirst");
u2.Debris = game:GetService("Debris");
u2.Players = game:GetService("Players");
u2.RunService = RunService;
u2.TeleportService = game:GetService("TeleportService");
u2.UserInputService = game:GetService("UserInputService");
u2.SoundService = game:GetService("SoundService");
u2.GamepadService = game:GetService("GamepadService");
u2.TextChatService = game:GetService("TextChatService");
u2.TweenService = game:GetService("TweenService");
u2.CollectionService = game:GetService("CollectionService");
u2.ScriptContext = game:GetService("ScriptContext");
u2.HttpService = game:GetService("HttpService");
u2.ContentProvider = game:GetService("ContentProvider");
u2.Lighting = game:GetService("Lighting");

if u1 then
    u2.ServerStorage = game:GetService("ServerStorage");
end;

if not u1 and u2.Players then
    u2.LocalPlayer = u2.Players.LocalPlayer;
end;

_eagerLoadWhitelistedModules();
setmetatable(u2, {
    __index = function(p94, p95) -- Line: 944, Name: __index
        -- upvalues: u18 (copy), u14 (copy), _loadToolModule (copy), u15 (copy), _loadSystemModule (copy), u1 (copy), u6 (copy), _loadServerRootModule (copy), u7 (copy), _loadServerSharedModule (copy), u3 (ref), _loadServerSystemModule (copy), ReplicatedStorage (copy), _loadClientSystemModule (copy), u10 (copy), _loadClientSkillModule (copy)
        if u18[p95] then
            return u18[p95];
        end;

        if u14[p95] then
            return _loadToolModule(p95);
        end;

        if u15[p95] then
            return _loadSystemModule(p95);
        end;

        if u1 and u6[p95] then
            return _loadServerRootModule(p95);
        end;

        if u1 and u7[p95] then
            return _loadServerSharedModule(p95);
        end;

        if u1 and u3 then
            local v96 = u3:FindFirstChild(p95);

            if v96 and v96:IsA("ModuleScript") then
                return _loadServerSystemModule(p95);
            end;
        end;

        local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");
        local v97;

        if ClientSideCode then
            v97 = ClientSideCode:FindFirstChild("SystemModule");
        else
            v97 = nil;
        end;

        if v97 then
            local v98;

            if v97 then
                v98 = v97:FindFirstChild(p95);

                if v98 then
                    if not v98:IsA("ModuleScript") then
                        v98 = v98:FindFirstChild("init");

                        if not (v98 and v98:IsA("ModuleScript")) then
                            v98 = nil;
                        end;
                    end;
                else
                    v98 = nil;
                end;
            else
                v98 = nil;
            end;

            if v98 then
                return _loadClientSystemModule(p95);
            end;
        end;

        if u10[p95] then
            return _loadClientSkillModule(p95);
        end;

        return nil;
    end
});

return u2;