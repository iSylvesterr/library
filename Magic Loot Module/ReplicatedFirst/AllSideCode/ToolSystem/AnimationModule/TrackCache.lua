-- Decompiled with Potassium's decompiler.

local InsMgr = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).InsMgr;
local Animation = require(script.Parent.Animation);
local AnimationState = require(script.Parent.AnimationState);
local u3 = {
    RBX_ASSET_PREFIX = "rbxassetid://",
    TIME_POSITION_EPSILON = 0.001,

    IsValidAnimationName = function(p1) -- Line: 29, Name: IsValidAnimationName
        local v2;

        if typeof(p1) == "string" then
            v2 = p1 ~= "";
        else
            v2 = false;
        end;

        return v2;
    end
};

local function _formatAnimationAssetId(p4) -- Line: 38
    return "http://www.roblox.com/asset/?id=" .. p4;
end;

local function _getConfiguredAnimID(p5) -- Line: 47
    -- upvalues: Animation (copy)
    local v6 = Animation[p5];

    if type(v6) == "number" then
        return v6;
    end;

    return nil;
end;

local function _cleanupAnimationMarkerEvents(p7, p8) -- Line: 60
    -- upvalues: AnimationState (copy)
    if not AnimationState.animationMarkerConnections[p7] then
        AnimationState.animationMarkerConnections[p7] = {};
    end;

    if AnimationState.animationMarkerConnections[p7][p8] then
        for i, v in pairs(AnimationState.animationMarkerConnections[p7][p8]) do
            v:Disconnect();
            AnimationState.animationMarkerConnections[p7][p8][i] = nil;
        end;

        return;
    end;

    AnimationState.animationMarkerConnections[p7][p8] = {};
end;

local function _getAnimationTrack(u9, p10) -- Line: 81
    -- upvalues: AnimationState (copy), Animation (copy), InsMgr (copy)
    if not AnimationState.animationTrackCache[u9] then
        AnimationState.animationTrackCache[u9] = {};
        AnimationState.animatorDestroyConnections[u9] = u9.Destroying:Connect(function() -- Line: 84
            -- upvalues: AnimationState (ref), u9 (copy)
            AnimationState.CleanupAnimator(u9);
        end);
    end;

    if AnimationState.animationTrackCache[u9][p10] then
        return AnimationState.animationTrackCache[u9][p10];
    end;

    local v11 = Animation[p10];

    if type(v11) ~= "number" then
        v11 = nil;
    end;

    if not v11 then
        warn("动画配置中未找到", p10, "的 ID");

        return nil;
    end;

    local v12 = InsMgr.GetIns(p10, "Animation", u9);
    v12.AnimationId = "http://www.roblox.com/asset/?id=" .. v11;
    AnimationState.animationTrackCache[u9][p10] = u9:LoadAnimation(v12);

    return AnimationState.animationTrackCache[u9][p10];
end;

local function _bindKeyframeEvents(p13, p14, p15, p16, p17) -- Line: 114
    -- upvalues: _cleanupAnimationMarkerEvents (copy), AnimationState (copy)
    if not (p16 and p17) then
        return;
    end;

    _cleanupAnimationMarkerEvents(p13, p14);

    for i, v in ipairs(p16) do
        local u18 = p17[i];

        if u18 then
            AnimationState.animationMarkerConnections[p13][p14][v] = p15:GetMarkerReachedSignal(v):Connect(function(p19) -- Line: 131
                -- upvalues: u18 (copy)
                u18();
            end);
        end;
    end;
end;

function u3.HasAnimationConfig(p20) -- Line: 143
    -- upvalues: u3 (copy), Animation (copy)
    if u3.IsValidAnimationName(p20) then
        return Animation[p20] ~= nil;
    end;

    return false;
end;

function u3.GetConfiguredAnimID(p21) -- Line: 155
    -- upvalues: Animation (copy)
    local v22 = Animation[p21];

    if type(v22) == "number" then
        return v22;
    end;

    return nil;
end;

function u3.FormatAnimationAssetId(p23) -- Line: 164
    return "http://www.roblox.com/asset/?id=" .. p23;
end;

function u3.FindAnimatorFromModel(p24) -- Line: 173
    local v25 = p24:FindFirstChildOfClass("Humanoid") or p24:FindFirstChildOfClass("AnimationController");

    if v25 then
        return v25:FindFirstChildOfClass("Animator");
    end;

    return nil;
end;

function u3.GetCachedTrack(p26, p27) -- Line: 190
    -- upvalues: AnimationState (copy)
    local v28 = AnimationState.animationTrackCache[p26];

    if v28 then
        v28 = v28[p27];
    end;

    return v28;
end;

function u3.GetAnimatorTrackCache(p29) -- Line: 200
    -- upvalues: AnimationState (copy)
    return AnimationState.animationTrackCache[p29];
end;

function u3.LoadAndConfigureTrack(p30, p31, p32, p33, p34, p35, p36, p37) -- Line: 216
    -- upvalues: u3 (copy), _getAnimationTrack (copy), _bindKeyframeEvents (copy)
    if not u3.IsValidAnimationName(p31) then
        return nil;
    end;

    if not u3.HasAnimationConfig(p31) then
        warn("未找到动画配置:", p31);

        return nil;
    end;

    local success, result = pcall(_getAnimationTrack, p30, p31);

    if not success then
        warn("加载动画轨道失败:", p31, result);

        return nil;
    end;

    if not result then
        warn("加载动画轨道失败:", p31);

        return nil;
    end;

    _bindKeyframeEvents(p30, p31, result, p33, p34);

    if p35 then
        result.Priority = p35;
    end;

    if p36 and not result.IsPlaying then
        result:Play(p37);
    end;

    result:AdjustSpeed(p32);

    return result;
end;

function u3.BindEndFunc(u38, u39, u40) -- Line: 266
    -- upvalues: u3 (copy), AnimationState (copy), Animation (copy)
    if not u3.IsValidAnimationName(u39) then
        return;
    end;

    if not u3.HasAnimationConfig(u39) then
        warn("未找到动画配置:", u39);

        return;
    end;

    if not AnimationState.animationEndConnections[u38] then
        AnimationState.animationEndConnections[u38] = {};
    end;

    if AnimationState.animationEndConnections[u38][u39] then
        AnimationState.animationEndConnections[u38][u39]:Disconnect();
        AnimationState.animationEndConnections[u38][u39] = nil;
    end;

    if not u40 then
        return;
    end;

    local v41 = u3.GetCachedTrack(u38, u39);

    if not v41 then
        local v42 = Animation[u39];

        if type(v42) ~= "number" then
            v42 = nil;
        end;

        if not v42 then
            return;
        end;

        local v43 = "http://www.roblox.com/asset/?id=" .. v42;

        for _, v in pairs(u38:GetPlayingAnimationTracks()) do
            if v.Animation.AnimationId == v43 or v.Name == u39 then
                v41 = v;
                break;
            end;
        end;
    end;

    if v41 then
        if not v41.Looped then
            AnimationState.animationEndConnections[u38][u39] = v41.Ended:Connect(function() -- Line: 306
                -- upvalues: AnimationState (ref), u38 (copy), u39 (copy), u40 (copy)
                if AnimationState.animationEndConnections[u38] and AnimationState.animationEndConnections[u38][u39] then
                    AnimationState.animationEndConnections[u38][u39]:Disconnect();
                    AnimationState.animationEndConnections[u38][u39] = nil;
                end;

                if u40 then
                    u40();
                end;
            end);
        end;
    else
        warn("未找到动画轨道:", u39, "，请确保动画已播放");
    end;
end;

return u3;