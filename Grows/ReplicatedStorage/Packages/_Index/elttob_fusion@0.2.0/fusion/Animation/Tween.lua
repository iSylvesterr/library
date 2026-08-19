-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
require(Parent.Types);
local TweenScheduler = require(Parent.Animation.TweenScheduler);
local useDependency = require(Parent.Dependencies.useDependency);
local initDependency = require(Parent.Dependencies.initDependency);
local logError = require(Parent.Logging.logError);
local logErrorNonFatal = require(Parent.Logging.logErrorNonFatal);
local xtypeof = require(Parent.Utility.xtypeof);
local v1 = {};
local u2 = {
    __index = v1
};
local u3 = {
    __mode = "k"
};

function v1.get(p4, p5) -- Line: 27
    -- upvalues: useDependency (copy)
    if p5 ~= false then
        useDependency(p4);
    end;

    return p4._currentValue;
end;

function v1.update(p6) -- Line: 38
    -- upvalues: logErrorNonFatal (copy), TweenScheduler (copy)
    local v7 = p6._goalState:get(false);

    if v7 == p6._nextValue and not p6._currentlyAnimating then
        return false;
    end;

    local _tweenInfo = p6._tweenInfo;

    if p6._tweenInfoIsState then
        _tweenInfo = _tweenInfo:get();
    end;

    if typeof(_tweenInfo) ~= "TweenInfo" then
        logErrorNonFatal("mistypedTweenInfo", nil, (typeof(_tweenInfo)));

        return false;
    end;

    p6._prevValue = p6._currentValue;
    p6._nextValue = v7;
    p6._currentTweenStartTime = os.clock();
    p6._currentTweenInfo = _tweenInfo;
    local v8 = _tweenInfo.DelayTime + _tweenInfo.Time;

    if _tweenInfo.Reverses then
        v8 = v8 + _tweenInfo.Time;
    end;

    p6._currentTweenDuration = v8 * (_tweenInfo.RepeatCount + 1);
    TweenScheduler.add(p6);

    return false;
end;

return function(p9, p10) -- Line: 77, Name: Tween
    -- upvalues: xtypeof (copy), logError (copy), u3 (copy), u2 (copy), initDependency (copy)
    local v11 = p9:get(false);

    if p10 == nil then
        p10 = TweenInfo.new();
    end;

    local v12 = {
        [p9] = true
    };
    local v13 = xtypeof(p10) == "State";

    if v13 then
        v12[p10] = true;
    end;

    local v14;

    if v13 then
        v14 = p10:get();
    else
        v14 = p10;
    end;

    if typeof(v14) ~= "TweenInfo" then
        logError("mistypedTweenInfo", nil, (typeof(v14)));
    end;

    local v15 = {
        type = "State",
        kind = "Tween",
        _currentTweenDuration = 0,
        _currentTweenStartTime = 0,
        _currentlyAnimating = false,
        dependencySet = v12,
        dependentSet = setmetatable({}, u3),
        _goalState = p9,
        _tweenInfo = p10,
        _tweenInfoIsState = v13,
        _prevValue = v11,
        _nextValue = v11,
        _currentValue = v11,
        _currentTweenInfo = p10
    };
    local v16 = setmetatable(v15, u2);
    initDependency(v16);
    p9.dependentSet[v16] = true;

    return v16;
end;