-- Decompiled with Potassium's decompiler.

local Utility = script.Parent.Utility;
require(script.Parent.Types);
local Preload = require(Utility.Preload);
local RandomWeighted = require(Utility.RandomWeighted);
local u1 = {};

local function resume(p2, p3) -- Line: 9
    -- upvalues: u1 (copy)
    p3:Stop();

    for _, v in u1 do
        v:Disconnect();
    end;

    local _controller = p2._controller;

    if _controller:GetCoreActive() then
        return;
    end;

    _controller:SetCoreActive(true);
    _controller:PlayAnimation("Idle");
end;

local function setupAnimEndTrigger(u4, u5) -- Line: 25
    -- upvalues: u1 (copy), resume (copy)
    table.insert(u1, u5.Stopped:Once(function() -- Line: 29
        -- upvalues: resume (ref), u4 (copy), u5 (copy)
        resume(u4, u5);
    end));
    table.insert(u1, u4._humanoid.StateChanged:Once(function() -- Line: 35
        -- upvalues: resume (ref), u4 (copy), u5 (copy)
        resume(u4, u5);
    end));
    table.insert(u1, u4._humanoid.Running:Once(function() -- Line: 41
        -- upvalues: resume (ref), u4 (copy), u5 (copy)
        resume(u4, u5);
    end));
end;

local function deepCopy(p6) -- Line: 47
    -- upvalues: deepCopy (copy)
    local v7 = {};

    for i, v in p6 do
        if type(v) == "table" then
            v7[i] = deepCopy(v);
        else
            v7[i] = v;
        end;
    end;

    return v7;
end;

local v8 = {};
local u9 = {
    __index = v8
};

function v8.Create(p10, p11, p12, p13, p14) -- Line: 74
    -- upvalues: Preload (copy)
    local v15 = p14 or Enum.AnimationPriority.Action;

    if p13 == nil and true or p13 then
        p12 = Preload.preloadAnimArray(p10._animator, p12, p11, v15) or p12;
    end;

    p10._actions[p11] = p12;

    return p12;
end;

function v8.BulkCreate(p16, p17, p18, p19) -- Line: 99
    local v20 = {};

    for i, v in p17 do
        table.insert(v20, p16:Create(i, v, p18, p19));
    end;

    return v20;
end;

function v8.Remove(p21, p22) -- Line: 117
    local v23 = p21._actions[p22];

    if not v23 then
        warn((`Action {p22} has not been created yet. (:Remove)`));

        return;
    end;

    for _, v in v23 do
        v.anim:Stop();
        v.anim:Destroy();
    end;

    p21._actions[p22] = nil;
end;

function v8.StopAll(p24, p25) -- Line: 139
    local v26 = p24._actions[p25];

    if v26 then
        for i = 1, #v26 do
            v26[i].anim:Stop();
        end;

        return;
    end;

    warn((`Action {p25} has not been created yet. (:StopAll)`));
end;

function v8.GetAction(p27, p28) -- Line: 161
    return p27._actions[p28];
end;

function v8.GetRandomActionAnim(p29, p30) -- Line: 172
    -- upvalues: RandomWeighted (copy)
    local v31 = p29._actions[p30];

    if v31 then
        return RandomWeighted(v31);
    end;

    warn((`Action {p30} has not been created yet. (:GetRandomActionAnim)`));
end;

function v8.SetEmoteBindable(u32, p33) -- Line: 191
    -- upvalues: u1 (copy), RandomWeighted (copy), setupAnimEndTrigger (copy)
    function p33.OnInvoke(p34) -- Line: 192
        -- upvalues: u1 (ref), u32 (copy), RandomWeighted (ref), setupAnimEndTrigger (ref)
        for _, v in u1 do
            v:Disconnect();
        end;

        local _controller = u32._controller;

        if _controller:GetPose() ~= "Idle" then
            return false;
        end;

        _controller:SetCoreActive(false);
        local v35;

        if typeof(p34) == "Instance" then
            v35 = p34.Name or p34;
        else
            v35 = p34;
        end;

        if u32._emotes[v35] ~= nil then
            local v36, _, v37 = RandomWeighted(u32._emotes[v35]);
            _controller:StopCore(v37.fadeTime or 0.1);
            v36:Play(0.1, 1, v37.speed or 1);
            setupAnimEndTrigger(u32, v36);

            return true, v36;
        end;

        if typeof(p34) ~= "Instance" or not p34:IsA("Animation") then
            return false;
        end;

        _controller:StopCore();
        local v38 = u32._animator:LoadAnimation(p34);
        v38.Looped = false;
        v38.Priority = Enum.AnimationPriority.Action2;
        v38:Play(0.1, 1, 1);
        setupAnimEndTrigger(u32, v38);
        u32._emotes[p34.Name] = {
            weight = 10,
            id = p34.AnimationId,
            anim = v38
        };

        return true, v38;
    end;
end;

function v8.Destroy(p39) -- Line: 242
    for _, v in p39._actions do
        v:Destroy();
    end;

    setmetatable(p39, nil);
    table.clear(p39);
end;

return {
    new = function(p40, p41, p42, p43) -- Line: 263, Name: new
        -- upvalues: u9 (copy)
        local v44 = p41:FindFirstChildWhichIsA("Animator", true);

        if not v44 then
            error((`Animator not found for rig {p41}`));
        end;

        local v45 = p43 or p41:FindFirstChildWhichIsA("Humanoid", true);

        if not v45 then
            error((`Humanoid not found for rig {p41}`));
        end;

        return setmetatable({
            _controller = p40,
            _animator = v44,
            _humanoid = v45,
            _emotes = p42,
            _actions = {}
        }, u9);
    end
};