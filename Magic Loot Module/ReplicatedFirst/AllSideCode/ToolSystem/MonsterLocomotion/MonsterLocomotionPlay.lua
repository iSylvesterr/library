-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local u1 = {};
local Movement = Enum.AnimationPriority.Movement;
local u2 = {};
local u3 = {};
local u4 = {};

function u1.findRuntimeNpcModel(p5) -- Line: 38
    -- upvalues: UtilsSystem (copy), Workspace (copy)
    local SystemLogicalEnemy = UtilsSystem.SystemLogicalEnemy;
    local v6 = SystemLogicalEnemy and SystemLogicalEnemy.GetModel and SystemLogicalEnemy.GetModel(p5);

    if v6 then
        return v6;
    end;

    local LocalMonster = Workspace:FindFirstChild("LocalMonster");

    if LocalMonster then
        local v7 = LocalMonster:FindFirstChild(p5);

        if v7 and v7:IsA("Model") then
            return v7;
        end;
    end;

    local Monster = Workspace:FindFirstChild("Monster");

    if Monster then
        local v8 = Monster:FindFirstChild(p5);

        if v8 and v8:IsA("Model") then
            return v8;
        end;
    end;

    local Summons = Workspace:FindFirstChild("Summons");

    if Summons then
        local v9 = Summons:FindFirstChild(p5);

        if v9 and v9:IsA("Model") then
            return v9;
        end;
    end;

    return nil;
end;

local function _stopCurrentLoco(p10, p11, p12) -- Line: 81
    -- upvalues: u3 (copy), AnimationModule (copy)
    local v13 = u3[p11];

    if v13 and v13 ~= "" then
        AnimationModule.StopAnimByModel(p10, v13, p12);
    end;

    u3[p11] = nil;
end;

local function _findAnimator(p14) -- Line: 95
    local v15 = p14:FindFirstChildOfClass("Humanoid") or p14:FindFirstChildOfClass("AnimationController");

    if v15 then
        return v15:FindFirstChildOfClass("Animator");
    end;

    return nil;
end;

function u1.playOnModel(p16, p17) -- Line: 111
    -- upvalues: u3 (copy), AnimationModule (copy), Movement (copy)
    if not p16 or type(p17) ~= "table" then
        return false;
    end;

    local v18 = p17.monsterId ~= nil and tostring(p17.monsterId) or p16.Name;
    local v19 = typeof(p17.fadeTime) == "number" and (p17.fadeTime or 0.2) or 0.2;
    local animName = p17.animName;

    if typeof(animName) ~= "string" or animName == "" then
        local v20 = u3[v18];

        if v20 and v20 ~= "" then
            AnimationModule.StopAnimByModel(p16, v20, v19);
        end;

        u3[v18] = nil;

        return true;
    end;

    local v21 = p16:FindFirstChildOfClass("Humanoid") or p16:FindFirstChildOfClass("AnimationController");
    local v22;

    if v21 then
        v22 = v21:FindFirstChildOfClass("Animator");
    else
        v22 = nil;
    end;

    if not v22 then
        return false;
    end;

    local v23 = u3[v18];

    if v23 and (v23 ~= "" and v23 ~= animName) then
        AnimationModule.StopAnimByModel(p16, v23, v19);
    end;

    local v24 = typeof(p17.speed) == "number" and (p17.speed or 1) or 1;
    local v25 = v24 <= 0 and 1 or v24;
    local v26 = AnimationModule.LoadAnimationTrack(v22, animName, v25, nil, nil, Movement, v19);

    if not v26 then
        return false;
    end;

    v26.Looped = true;
    v26.Priority = Movement;
    v26:AdjustSpeed(v25);

    if v26.IsPlaying then
        if v23 ~= animName then
            v26.Looped = true;
        end;
    else
        v26:Play(v19);
        v26.Looped = true;
    end;

    u3[v18] = animName;

    return true;
end;

function u1.playFromPayload(p27) -- Line: 173
    -- upvalues: u2 (copy), u1 (copy), u4 (copy)
    if type(p27) ~= "table" then
        return false;
    end;

    local v28;

    if p27.monsterId == nil then
        v28 = nil;
    else
        v28 = tostring(p27.monsterId) or nil;
    end;

    if not v28 then
        return false;
    end;

    local serverTime = p27.serverTime;

    if typeof(serverTime) == "number" then
        local v29 = u2[v28];

        if typeof(v29) == "number" and serverTime < v29 then
            return false;
        end;

        u2[v28] = serverTime;
    end;

    local v30 = u1.findRuntimeNpcModel(v28);

    if v30 then
        u4[v28] = nil;

        return u1.playOnModel(v30, p27);
    end;

    u4[v28] = p27;

    return false;
end;

function u1.flushPending(p31) -- Line: 206
    -- upvalues: u4 (copy), u1 (copy)
    local v32 = tostring(p31);
    local v33 = u4[v32];

    if not v33 then
        return false;
    end;

    u4[v32] = nil;

    return u1.playFromPayload(v33);
end;

return u1;