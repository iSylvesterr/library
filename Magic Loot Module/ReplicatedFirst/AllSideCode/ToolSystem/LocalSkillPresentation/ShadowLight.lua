-- Decompiled with Potassium's decompiler.

local Log = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).Log;
local u1 = {};

local function frameSec(p2) -- Line: 30
    return p2 / 60;
end;

local u3 = CFrame.new(0, 2, -12);
local u4 = 2.1;
local u5 = 10.5;
local u6 = {
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
local u7 = {};

local function _still(p8) -- Line: 94
    -- upvalues: u7 (copy)
    local v9 = p8.isTokenValid() and u7[p8.token] == p8;

    return v9;
end;

local function _delay(u10, p11, u12) -- Line: 106
    -- upvalues: u7 (copy)
    task.delay(p11, function() -- Line: 107
        -- upvalues: u10 (copy), u7 (ref), u12 (copy)
        local v13 = u10;
        local v14 = v13.isTokenValid() and u7[v13.token] == v13;

        if not v14 then
            return;
        end;

        u12();
    end);

    return nil;
end;

local function _firePresentationDone(p15, p16) -- Line: 123
    if p15.presentationDone then
        return nil;
    end;

    p15.presentationDone = true;

    if p16.onPresentationDone then
        p16.onPresentationDone();
    end;

    return nil;
end;

local function _fireCastDone(p17, p18) -- Line: 141
    if p17.castDone then
        return nil;
    end;

    p17.castDone = true;

    if p18.onCastDone then
        p18.onCastDone();
    end;

    return nil;
end;

function u1.Stop(p19) -- Line: 158
    -- upvalues: u7 (copy)
    if not u7[p19] then
        return nil;
    end;

    u7[p19] = nil;

    return nil;
end;

function u1.Play(u20) -- Line: 173
    -- upvalues: u1 (copy), u3 (copy), u7 (copy), Log (copy), u6 (copy), u4 (copy), u5 (copy)
    local character = u20.character;
    local goalCF = u20.goalCF;
    local token = u20.token;
    local isTokenValid = u20.isTokenValid;

    if not (character and (goalCF and isTokenValid)) then
        return false;
    end;

    u1.Stop(token);
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");
    local v21;

    if HumanoidRootPart then
        v21 = HumanoidRootPart.CFrame * u3;
    else
        v21 = goalCF;
    end;

    local u22 = {
        presentationDone = false,
        castDone = false,
        token = token,
        character = character,
        originCF = v21,
        goalCF = goalCF,
        isTokenValid = isTokenValid
    };
    u7[token] = u22;
    Log.print("[LocalSkillPresentation.ShadowLight] Play", "token=", token, "originCF=", v21);

    for _, v in ipairs(u6) do
        local function u23() -- Line: 201
            -- upvalues: Log (ref), v (copy)
            Log.print("[LocalSkillPresentation.ShadowLight]", string.format("t=%.3fs F%d %s | %s", v.t, v.frame, v.id, v.desc));
        end;

        task.delay(v.t, function() -- Line: 107
            -- upvalues: u22 (copy), u7 (ref), u23 (copy)
            local v24 = u22;
            local v25 = v24.isTokenValid() and u7[v24.token] == v24;

            if not v25 then
                return;
            end;

            u23();
        end);
    end;

    local function u28() -- Line: 209
        -- upvalues: u22 (copy), u20 (copy)
        local v26 = u22;
        local v27 = u20;

        if v26.castDone then
            return;
        end;

        v26.castDone = true;

        if v27.onCastDone then
            v27.onCastDone();
        end;
    end;

    task.delay(u4, function() -- Line: 107
        -- upvalues: u22 (copy), u7 (ref), u28 (copy)
        local v29 = u22;
        local v30 = v29.isTokenValid() and u7[v29.token] == v29;

        if not v30 then
            return;
        end;

        u28();
    end);

    local function u33() -- Line: 213
        -- upvalues: u22 (copy), u20 (copy), u7 (ref), token (copy)
        local v31 = u22;
        local v32 = u20;

        if not v31.presentationDone then
            v31.presentationDone = true;

            if v32.onPresentationDone then
                v32.onPresentationDone();
            end;
        end;

        u7[token] = nil;
    end;

    task.delay(u5, function() -- Line: 107
        -- upvalues: u22 (copy), u7 (ref), u33 (copy)
        local v34 = u22;
        local v35 = v34.isTokenValid() and u7[v34.token] == v34;

        if not v35 then
            return;
        end;

        u33();
    end);

    return true;
end;

return u1;