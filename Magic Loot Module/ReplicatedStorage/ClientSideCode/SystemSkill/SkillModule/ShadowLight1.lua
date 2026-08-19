-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local Log = UtilsSystem.Log;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Dark,
    skillDistanceLimit = 200
};

local function frameSec(p2) -- Line: 60
    return p2 / 60;
end;

local u3 = CFrame.new(0, 2, -12);
local u4 = {
    {
        frame = 0,
        id = "Origin",
        desc = "开场 / 缓存 originCF",
        t = 0
    },
    {
        frame = 14,
        id = "Vignette",
        desc = "Vignette（可选）",
        t = 0.23333333333333334
    },
    {
        frame = 49,
        id = "FX_JumpBurst",
        desc = "1_FX_起跳炸 AbsoluteEmit",
        t = 0.8166666666666667
    },
    {
        frame = 50,
        id = "FX_Ground01",
        desc = "2_FX_Ground_01 AbsoluteEmit",
        t = 0.8333333333333334
    },
    {
        frame = 52,
        id = "FX_BodyEnergy",
        desc = "2_FX_BodyEngry AbsoluteEmit",
        t = 0.8666666666666667
    },
    {
        frame = 55,
        id = "Narr_CrackSmall",
        desc = "叙事：地面和周身细小空间裂缝",
        t = 0.9166666666666666
    },
    {
        frame = 126,
        id = "FX_Absorb3",
        desc = "3_Absorb AbsoluteEmit",
        t = 2.1
    },
    {
        frame = 156,
        id = "FX_RiftLiangBurst",
        desc = "4_空间裂隙_liang_Burst AbsoluteEmit",
        t = 2.6
    },
    {
        frame = 159,
        id = "FX_RiftAnBurst",
        desc = "4_空间裂隙_An_Burst AbsoluteEmit",
        t = 2.65
    },
    {
        frame = 163,
        id = "Narr_CrackOpen",
        desc = "叙事：两边大空间裂缝猛地打开",
        t = 2.716666666666667
    },
    {
        frame = 166,
        id = "FX_Burst3",
        desc = "3_Burst AbsoluteEmit",
        t = 2.7666666666666666
    },
    {
        frame = 180,
        id = "Beam_LiangStart",
        desc = "亮侧 Beam Width0 开始",
        t = 3
    },
    {
        frame = 184,
        id = "FX_LightBall",
        desc = "5_LightBall AbsoluteEmit",
        t = 3.066666666666667
    },
    {
        frame = 185,
        id = "Beam_AnStart",
        desc = "暗侧 Beam Width0 开始",
        t = 3.0833333333333335
    },
    {
        frame = 190,
        id = "FX_DarkBall",
        desc = "5_DarkBall AbsoluteEmit",
        t = 3.1666666666666665
    },
    {
        frame = 195,
        id = "Ball_MotionStart",
        desc = "Part/Part2 运动开始（相对 originCF）",
        t = 3.25
    },
    {
        frame = 226,
        id = "Beam_AnEnd",
        desc = "暗侧 Beam Width0 收束",
        t = 3.7666666666666666
    },
    {
        frame = 228,
        id = "Beam_LiangEnd",
        desc = "亮侧 Beam Width0 收束",
        t = 3.8
    },
    {
        frame = 321,
        id = "Narr_Orbit",
        desc = "叙事：能量球缠绕旋转",
        t = 5.35
    },
    {
        frame = 399,
        id = "Narr_Merge",
        desc = "叙事：两能量球合一缩小",
        t = 6.65
    },
    {
        frame = 401,
        id = "FX_Absorb5",
        desc = "5_Absorb AbsoluteEmit",
        t = 6.683333333333334
    },
    {
        frame = 408,
        id = "FX_FinalBurst",
        desc = "5_FinalBurst AbsoluteEmit",
        t = 6.8
    },
    {
        frame = 498,
        id = "Narr_ChargeCam",
        desc = "叙事：合一球缓扩后冲镜",
        t = 8.3
    },
    {
        frame = 579,
        id = "Narr_Implode",
        desc = "叙事：极致收缩爆开",
        t = 9.65
    },
    {
        frame = 616,
        id = "Narr_Flash",
        desc = "叙事：爆炸冲屏黑白闪",
        t = 10.266666666666667
    },
    {
        frame = 630,
        id = "TimelineEnd",
        desc = "时间轴结束",
        t = 10.5
    }
};
v1.InitialState = "Startup";
v1.ControlOpenState = "Main";
v1.States = {
    Startup = {
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        Duration = 2.1
    },
    Main = {
        OnEnterClient = "Client_EnterMain",
        OnEnterServer = "Server_EnterMain",
        Duration = 4.583333333333333
    },
    Finale = {
        OnEnterClient = "Client_EnterFinale",
        OnEnterServer = "Server_EnterFinale",
        Duration = 3.816666666666667
    },
    Recovery = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery"
    },
    Finished = {
        Duration = 0,
        IsTerminal = true
    },
    Interrupted = {
        Duration = 0,
        IsTerminal = true
    }
};
v1.Transitions = {
    {
        From = "Startup",
        To = "Main",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Main",
        To = "Finale",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Finale",
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
        From = "Main",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Finale",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Recovery",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Main",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Finale",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function cacheOriginCF(p5) -- Line: 153
    -- upvalues: u3 (copy)
    local skillInputData = p5.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if skillInputData then
        skillInputData = skillInputData:FindFirstChild("HumanoidRootPart");
    end;

    local skillRunData = p5.skillRunData;

    if not (skillInputData and skillRunData) then
        return nil;
    end;

    local v6 = skillInputData.CFrame * u3;
    skillRunData._shadowLightOriginCF = v6;

    return v6;
end;

local function stillRunning(p7, p8) -- Line: 173
    local v9;

    if p7.runGeneration == p8 then
        v9 = p7:isRunningFlow();
    else
        v9 = false;
    end;

    return v9;
end;

local function scheduleAnchors(u10, u11, u12) -- Line: 185
    -- upvalues: u4 (copy), Log (copy)
    for _, v in ipairs(u4) do
        task.delay(v.t, function() -- Line: 187
            -- upvalues: u10 (copy), u11 (copy), Log (ref), v (copy), u12 (copy)
            local v13 = u10;
            local v14;

            if u11 == v13.runGeneration then
                v14 = v13:isRunningFlow();
            else
                v14 = false;
            end;

            if not v14 then
                return;
            end;

            Log.print("[ShadowLight1]", string.format("t=%.3fs F%d %s | %s", v.t, v.frame, v.id, v.desc), u12);
        end);
    end;

    return nil;
end;

function v1.Client_EnterStartup(p15) -- Line: 201
    -- upvalues: u3 (copy), Log (copy), scheduleAnchors (copy)
    local runGeneration = p15.runGeneration;
    local skillInputData = p15.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if skillInputData then
        skillInputData = skillInputData:FindFirstChild("HumanoidRootPart");
    end;

    local skillRunData = p15.skillRunData;
    local v16;

    if skillInputData and skillRunData then
        v16 = skillInputData.CFrame * u3;
        skillRunData._shadowLightOriginCF = v16;
    else
        v16 = nil;
    end;

    Log.print("[ShadowLight1] Enter Startup", "originCF=", v16);
    scheduleAnchors(p15, runGeneration, v16);
end;

function v1.Server_EnterStartup(p17) -- Line: 208
    -- upvalues: u3 (copy)
    local skillInputData = p17.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if skillInputData then
        skillInputData = skillInputData:FindFirstChild("HumanoidRootPart");
    end;

    local skillRunData = p17.skillRunData;

    if skillInputData then
        if not skillRunData then
            return;
        end;

        skillRunData._shadowLightOriginCF = skillInputData.CFrame * u3;
    end;
end;

function v1.Client_EnterMain(p18) -- Line: 212
    -- upvalues: Log (copy)
    Log.print("[ShadowLight1] Enter Main");
end;

function v1.Server_EnterMain(p19) -- Line: 216
end;

function v1.Client_EnterFinale(p20) -- Line: 218
    -- upvalues: Log (copy)
    Log.print("[ShadowLight1] Enter Finale");
end;

function v1.Server_EnterFinale(p21) -- Line: 222
end;

function v1.Client_EnterRecovery(p22) -- Line: 224
    -- upvalues: Log (copy)
    Log.print("[ShadowLight1] Enter Recovery");
end;

function v1.Server_EnterRecovery(p23) -- Line: 228
end;

return v1;