-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local _ = UtilsSystem.RayCast;
local _ = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    InitialState = "Startup",
    ControlOpenState = "TearAttack",
    States = {
        Startup = {
            Duration = 0.56,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        TearAttack = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterTearAttack",
            OnEnterServer = "Server_EnterTearAttack",
            OnExitClient = "Client_ExitTearAttack",
            OnExitServer = "Server_ExitTearAttack"
        },
        Recovery = {
            Duration = 0.2,
            OnEnterClient = "Client_EnterRecovery",
            OnEnterServer = "Server_EnterRecovery",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Finished = {
            Duration = 0,
            IsTerminal = true
        },
        Interrupted = {
            Duration = 0,
            IsTerminal = true
        }
    },
    Transitions = {
        {
            From = "Startup",
            To = "TearAttack",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "TearAttack",
            To = "Recovery",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Startup",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "TearAttack",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "TearAttack",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        }
    }
};

local function get_skillScale(p2) -- Line: 81
    local character = p2.skillInputData.character;

    return character and character:GetScale() or 1;
end;

local u3 = CFrame.new(0, 0, -2) * CFrame.Angles(0.017453292519943295, -0, 0);
local u4 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(1, 1, 0) });
local u5 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0, 0) });
local u6 = {
    primary = { { "上面1", "上面Beam" }, { "下面1", "下面Beam" }, { "中间1", "中间Beam" } },
    secondary = { { "上面1", "上面Beam1" }, { "下面1", "下面Beam1" }, { "中间1", "中间Beam1" } },
    tertiary = { { "上面1", "上面Beam1_1" }, { "下面1", "下面Beam1_1" }, { "中间1", "中间Beam1_1" } }
};

local function collect_beams(p7, p8) -- Line: 116
    local v9 = {};

    for _, v in p8 do
        table.insert(v9, p7[v[1]][v[2]]);
    end;

    return v9;
end;

local function for_each_beam(p10, p11) -- Line: 124
    for _, v in p10 do
        p11(v);
    end;
end;

local function set_beams_enabled(p12, u13) -- Line: 130
    local function _(p14) -- Line: 131
        -- upvalues: u13 (copy)
        p14.Enabled = u13;
    end;

    for _, v in p12 do
        v.Enabled = u13;
    end;
end;

local function set_beams_transparency(p15, u16) -- Line: 136
    local function _(p17) -- Line: 137
        -- upvalues: u16 (copy)
        p17.Transparency = u16;
    end;

    for _, v in p15 do
        v.Transparency = u16;
    end;
end;

local function fade_beams(p18, u19, u20, u21, u22) -- Line: 142
    -- upvalues: FXUtil (copy)
    local function _(p23) -- Line: 149
        -- upvalues: FXUtil (ref), u19 (copy), u20 (copy), u21 (copy), u22 (copy)
        FXUtil.Beam_Object_Fade(p23, u19, u20, u21, u22);
    end;

    for _, v in p18 do
        FXUtil.Beam_Object_Fade(v, u19, u20, u21, u22);
    end;
end;

local function fade_beams_then_disable(u24, u25, p26) -- Line: 154
    -- upvalues: u4 (copy), FXUtil (copy)
    local u27 = u4;
    local Linear = Enum.EasingStyle.Linear;
    local In = Enum.EasingDirection.In;

    local function _(p28) -- Line: 149
        -- upvalues: FXUtil (ref), u25 (copy), u27 (copy), Linear (copy), In (copy)
        FXUtil.Beam_Object_Fade(p28, u25, u27, Linear, In);
    end;

    for _, v in u24 do
        FXUtil.Beam_Object_Fade(v, u25, u27, Linear, In);
    end;

    delay(p26, function() -- Line: 156
        -- upvalues: u24 (copy)
        local u29 = false;

        local function _(p30) -- Line: 131
            -- upvalues: u29 (copy)
            p30.Enabled = u29;
        end;

        for _, v in u24 do
            v.Enabled = false;
        end;
    end);
end;

local function get_beam_pivot_cf(p31) -- Line: 161
    -- upvalues: u3 (copy)
    return p31:GetPivot():ToWorldSpace(u3);
end;

local function beam_fade_in(u32, u33, p34) -- Line: 165
    -- upvalues: u5 (copy), FXUtil (copy)
    local function run() -- Line: 166
        -- upvalues: u32 (copy), u33 (copy), u5 (ref), FXUtil (ref)
        local u35 = u33;
        local u36 = u5;
        local Quart = Enum.EasingStyle.Quart;
        local Out = Enum.EasingDirection.Out;

        local function _(p37) -- Line: 149
            -- upvalues: FXUtil (ref), u35 (copy), u36 (copy), Quart (copy), Out (copy)
            FXUtil.Beam_Object_Fade(p37, u35, u36, Quart, Out);
        end;

        for _, v in u32 do
            FXUtil.Beam_Object_Fade(v, u35, u36, Quart, Out);
        end;
    end;

    if p34 and p34 > 0 then
        delay(p34, run);

        return;
    end;

    local u38 = u5;
    local Quart = Enum.EasingStyle.Quart;
    local Out = Enum.EasingDirection.Out;

    local function _(p39) -- Line: 149
        -- upvalues: FXUtil (ref), u33 (copy), u38 (copy), Quart (copy), Out (copy)
        FXUtil.Beam_Object_Fade(p39, u33, u38, Quart, Out);
    end;

    for _, v in u32 do
        FXUtil.Beam_Object_Fade(v, u33, u38, Quart, Out);
    end;
end;

local function BeamEffect(p40, p41) -- Line: 176
    -- upvalues: get_beam_pivot_cf (copy), collect_beams (copy), u6 (copy), u4 (copy), u5 (copy), FXUtil (copy), u3 (copy)
    local HumanoidRootPart = p41:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local u42 = p40.skillRunData.material["熊人抓痕攻击-火"];

    if not (u42 and u42.PrimaryPart) then
        return;
    end;

    u42.Parent = workspace.Debris;
    u42:PivotTo(get_beam_pivot_cf(HumanoidRootPart));
    local PrimaryPart = u42.PrimaryPart;
    local u43 = collect_beams(PrimaryPart, u6.primary);
    local u44 = collect_beams(PrimaryPart, u6.secondary);
    local u45 = collect_beams(PrimaryPart, u6.tertiary);
    local v46 = {};

    for _, v in { u43, u44, u45 } do
        for _, v2 in v do
            table.insert(v46, v2);
        end;
    end;

    local u47 = true;

    local function _(p48) -- Line: 131
        -- upvalues: u47 (copy)
        p48.Enabled = u47;
    end;

    for _, v in v46 do
        v.Enabled = true;
    end;

    local u49 = u4;

    local function _(p50) -- Line: 137
        -- upvalues: u49 (copy)
        p50.Transparency = u49;
    end;

    for _, v in v46 do
        v.Transparency = u49;
    end;

    local u51 = 0.1;

    local function _() -- Line: 166
        -- upvalues: u43 (copy), u51 (copy), u5 (ref), FXUtil (ref)
        local u52 = u51;
        local u53 = u5;
        local Quart = Enum.EasingStyle.Quart;
        local Out = Enum.EasingDirection.Out;

        local function _(p54) -- Line: 149
            -- upvalues: FXUtil (ref), u52 (copy), u53 (copy), Quart (copy), Out (copy)
            FXUtil.Beam_Object_Fade(p54, u52, u53, Quart, Out);
        end;

        for _, v in u43 do
            FXUtil.Beam_Object_Fade(v, u52, u53, Quart, Out);
        end;
    end;

    local u55 = u5;
    local Quart = Enum.EasingStyle.Quart;
    local Out = Enum.EasingDirection.Out;
    local u56 = 0.1;

    local function _(p57) -- Line: 149
        -- upvalues: FXUtil (ref), u56 (copy), u55 (copy), Quart (copy), Out (copy)
        FXUtil.Beam_Object_Fade(p57, u56, u55, Quart, Out);
    end;

    for _, v in u43 do
        FXUtil.Beam_Object_Fade(v, 0.1, u55, Quart, Out);
    end;

    local u58 = 0.1;
    delay(0.05, function() -- Line: 166, Name: run
        -- upvalues: u44 (copy), u58 (copy), u5 (ref), FXUtil (ref)
        local u59 = u58;
        local u60 = u5;
        local Quart2 = Enum.EasingStyle.Quart;
        local Out2 = Enum.EasingDirection.Out;

        local function _(p61) -- Line: 149
            -- upvalues: FXUtil (ref), u59 (copy), u60 (copy), Quart2 (copy), Out2 (copy)
            FXUtil.Beam_Object_Fade(p61, u59, u60, Quart2, Out2);
        end;

        for _, v in u44 do
            FXUtil.Beam_Object_Fade(v, u59, u60, Quart2, Out2);
        end;
    end);
    local u62 = 0.1;
    delay(0.1, function() -- Line: 166, Name: run
        -- upvalues: u45 (copy), u62 (copy), u5 (ref), FXUtil (ref)
        local u63 = u62;
        local u64 = u5;
        local Quart2 = Enum.EasingStyle.Quart;
        local Out2 = Enum.EasingDirection.Out;

        local function _(p65) -- Line: 149
            -- upvalues: FXUtil (ref), u63 (copy), u64 (copy), Quart2 (copy), Out2 (copy)
            FXUtil.Beam_Object_Fade(p65, u63, u64, Quart2, Out2);
        end;

        for _, v in u45 do
            FXUtil.Beam_Object_Fade(v, u63, u64, Quart2, Out2);
        end;
    end);
    delay(0.2, function() -- Line: 208
        -- upvalues: FXUtil (ref), u42 (copy)
        FXUtil.Emit_Particles_GetDescendants(u42, true);
    end);
    local u66 = {
        primary = false,
        secondary = false,
        tertiary = false
    };
    local u67 = false;
    FXUtil.Control_Model_CFrame(u42, function(p68) -- Line: 215
        -- upvalues: u42 (copy), HumanoidRootPart (copy), u3 (ref), u67 (ref), FXUtil (ref), u66 (copy), u45 (copy), u4 (ref), u43 (copy), u44 (copy)
        if u42 then
            local v69 = HumanoidRootPart:GetPivot():ToWorldSpace(u3);

            if not u67 and p68 / 0.4 >= 1.5 then
                u67 = true;
                FXUtil.Uncontrol_Model_CFrame(u42);
            end;

            if not u66.tertiary and p68 > 0.25 then
                u66.tertiary = true;
                local u70 = u45;
                local u71 = u4;
                local Linear = Enum.EasingStyle.Linear;
                local In = Enum.EasingDirection.In;
                local u72 = 0.05;

                local function _(p73) -- Line: 149
                    -- upvalues: FXUtil (ref), u72 (copy), u71 (copy), Linear (copy), In (copy)
                    FXUtil.Beam_Object_Fade(p73, u72, u71, Linear, In);
                end;

                for _, v in u70 do
                    FXUtil.Beam_Object_Fade(v, 0.05, u71, Linear, In);
                end;

                delay(0.15, function() -- Line: 156
                    -- upvalues: u70 (copy)
                    local u74 = false;

                    local function _(p75) -- Line: 131
                        -- upvalues: u74 (copy)
                        p75.Enabled = u74;
                    end;

                    for _, v in u70 do
                        v.Enabled = false;
                    end;
                end);
            end;

            if not u66.primary and p68 > 0.22000000000000003 then
                u66.primary = true;
                local u76 = u43;
                local u77 = u4;
                local Linear = Enum.EasingStyle.Linear;
                local In = Enum.EasingDirection.In;
                local u78 = 0.15;

                local function _(p79) -- Line: 149
                    -- upvalues: FXUtil (ref), u78 (copy), u77 (copy), Linear (copy), In (copy)
                    FXUtil.Beam_Object_Fade(p79, u78, u77, Linear, In);
                end;

                for _, v in u76 do
                    FXUtil.Beam_Object_Fade(v, 0.15, u77, Linear, In);
                end;

                delay(0.2, function() -- Line: 156
                    -- upvalues: u76 (copy)
                    local u80 = false;

                    local function _(p81) -- Line: 131
                        -- upvalues: u80 (copy)
                        p81.Enabled = u80;
                    end;

                    for _, v in u76 do
                        v.Enabled = false;
                    end;
                end);
            end;

            if not u66.secondary and p68 > 0.2 then
                u66.secondary = true;
                local u82 = u44;
                local u83 = u4;
                local Linear = Enum.EasingStyle.Linear;
                local In = Enum.EasingDirection.In;
                local u84 = 0.1;

                local function _(p85) -- Line: 149
                    -- upvalues: FXUtil (ref), u84 (copy), u83 (copy), Linear (copy), In (copy)
                    FXUtil.Beam_Object_Fade(p85, u84, u83, Linear, In);
                end;

                for _, v in u82 do
                    FXUtil.Beam_Object_Fade(v, 0.1, u83, Linear, In);
                end;

                delay(0.15, function() -- Line: 156
                    -- upvalues: u82 (copy)
                    local u86 = false;

                    local function _(p87) -- Line: 131
                        -- upvalues: u86 (copy)
                        p87.Enabled = u86;
                    end;

                    for _, v in u82 do
                        v.Enabled = false;
                    end;
                end);
            end;

            local v88 = math.clamp(p68 / 0.4, 0, 1);
            local v89 = game.TweenService:GetValue(v88, Enum.EasingStyle.Sine, Enum.EasingDirection.In);

            return v69 * CFrame.Angles(0, 0 * v89, 0);
        end;
    end);
end;

function v1.Client_EnterStartup(p90) -- Line: 248
end;

function v1.Server_EnterStartup(p91) -- Line: 252
    local v92 = p91.hitbox[1];

    if v92 and v92.hitbox then
        local character = p91.skillInputData.character;
        local v93 = character and character:GetScale() or 1;
        local v94 = Vector3.new(9, 9, 9 * v93);
        v92.hitbox.Size = v94;
    end;
end;

function v1.Client_EnterTearAttack(p95) -- Line: 263
    -- upvalues: SoundModule (copy), BeamEffect (copy)
    local character = p95.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    SoundModule:PlaySoundLocal({
        SoundName = "技能-熊撕裂攻击",
        Is2D = false,
        PlayPosition = HumanoidRootPart.Position
    });
    BeamEffect(p95, character);
end;

function v1.Client_ExitTearAttack(p96) -- Line: 280
    if p96.skillRunData.runEvent["刀光特效控制"] then
        p96.skillRunData.runEvent["刀光特效控制"]:Disconnect();
        p96.skillRunData.runEvent["刀光特效控制"] = nil;
    end;
end;

function v1.Server_EnterTearAttack(u97) -- Line: 287
    -- upvalues: RunService (copy)
    local u98 = u97.hitbox[1];

    if not u98 then
        return;
    end;

    u98:start();
    local character = u97.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    u97.skillRunData.runEvent["命中盒控制"] = RunService.Heartbeat:Connect(function(p99) -- Line: 296
        -- upvalues: HumanoidRootPart (copy), u98 (copy), u97 (copy)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            local hitbox = u98.hitbox;
            local v100 = HumanoidRootPart:GetPivot();
            local character2 = u97.skillInputData.character;
            hitbox:PivotTo(v100:ToWorldSpace(CFrame.new(0, 0, -1 * (character2 and character2:GetScale() or 1))));
        end;
    end);
end;

function v1.Server_ExitTearAttack(p101) -- Line: 307
    local v102 = p101.hitbox[1];

    if v102 and v102.isActive then
        v102:stop();
    end;

    if p101.skillRunData.runEvent["命中盒控制"] then
        p101.skillRunData.runEvent["命中盒控制"]:Disconnect();
        p101.skillRunData.runEvent["命中盒控制"] = nil;
    end;
end;

function v1.Server_EnterRecovery(p103) -- Line: 319
    p103:releaseControl();
end;

function v1.Client_EnterRecovery(p104) -- Line: 323
end;

v1.SoundList = { "技能-熊撕裂攻击" };
v1.AnimateList = { "熊撕裂攻击" };
v1.ResNameList = { "熊人抓痕攻击-火" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.8,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.33,
        animationName = "熊撕裂攻击",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v1;