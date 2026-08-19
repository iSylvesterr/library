-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
require(Parent.Types);
local logError = require(Parent.Logging.logError);
local logErrorNonFatal = require(Parent.Logging.logErrorNonFatal);
local unpackType = require(Parent.Animation.unpackType);
local SpringScheduler = require(Parent.Animation.SpringScheduler);
local useDependency = require(Parent.Dependencies.useDependency);
local initDependency = require(Parent.Dependencies.initDependency);
local updateAll = require(Parent.Dependencies.updateAll);
local xtypeof = require(Parent.Utility.xtypeof);
local unwrap = require(Parent.State.unwrap);
local v1 = {};
local u2 = {
    __index = v1
};
local u3 = {
    __mode = "k"
};

function v1.get(p4, p5) -- Line: 30
    -- upvalues: useDependency (copy)
    if p5 ~= false then
        useDependency(p4);
    end;

    return p4._currentValue;
end;

function v1.setPosition(p6, p7) -- Line: 44
    -- upvalues: logError (copy), unpackType (copy), SpringScheduler (copy), updateAll (copy)
    local v8 = typeof(p7);

    if v8 ~= p6._currentType then
        logError("springTypeMismatch", nil, v8, p6._currentType);
    end;

    p6._springPositions = unpackType(p7, v8);
    p6._currentValue = p7;
    SpringScheduler.add(p6);
    updateAll(p6);
end;

function v1.setVelocity(p9, p10) -- Line: 63
    -- upvalues: logError (copy), unpackType (copy), SpringScheduler (copy)
    local v11 = typeof(p10);

    if v11 ~= p9._currentType then
        logError("springTypeMismatch", nil, v11, p9._currentType);
    end;

    p9._springVelocities = unpackType(p10, v11);
    SpringScheduler.add(p9);
end;

function v1.addVelocity(p12, p13) -- Line: 80
    -- upvalues: logError (copy), unpackType (copy), SpringScheduler (copy)
    local v14 = typeof(p13);

    if v14 ~= p12._currentType then
        logError("springTypeMismatch", nil, v14, p12._currentType);
    end;

    local v15 = unpackType(p13, v14);

    for i, v in ipairs(v15) do
        local _springVelocities = p12._springVelocities;
        _springVelocities[i] = _springVelocities[i] + v;
    end;

    SpringScheduler.add(p12);
end;

function v1.update(p16) -- Line: 97
    -- upvalues: unwrap (copy), logErrorNonFatal (copy), unpackType (copy), SpringScheduler (copy)
    local v17 = p16._goalState:get(false);

    if v17 == p16._goalValue then
        local v18 = unwrap(p16._damping);

        if typeof(v18) == "number" then
            if v18 < 0 then
                logErrorNonFatal("invalidSpringDamping", nil, v18);
            else
                p16._currentDamping = v18;
            end;
        else
            logErrorNonFatal("mistypedSpringDamping", nil, (typeof(v18)));
        end;

        local v19 = unwrap(p16._speed);

        if typeof(v19) == "number" then
            if v19 < 0 then
                logErrorNonFatal("invalidSpringSpeed", nil, v19);
            else
                p16._currentSpeed = v19;
            end;
        else
            logErrorNonFatal("mistypedSpringSpeed", nil, (typeof(v19)));
        end;

        return false;
    end;

    p16._goalValue = v17;
    local _currentType = p16._currentType;
    local v20 = typeof(v17);
    p16._currentType = v20;
    local v21 = unpackType(v17, v20);
    local v22 = #v21;
    p16._springGoals = v21;

    if v20 == _currentType then
        if v22 == 0 then
            p16._currentValue = p16._goalValue;

            return true;
        end;

        SpringScheduler.add(p16);

        return false;
    end;

    p16._currentValue = p16._goalValue;
    local v23 = table.create(v22, 0);
    local v24 = table.create(v22, 0);

    for i, v in ipairs(v21) do
        v23[i] = v;
    end;

    p16._springPositions = v23;
    p16._springVelocities = v24;
    SpringScheduler.remove(p16);

    return true;
end;

return function(p25, p26, p27) -- Line: 165, Name: Spring
    -- upvalues: xtypeof (copy), u3 (copy), unwrap (copy), u2 (copy), initDependency (copy)
    local v28 = p26 == nil and 10 or p26;
    local v29 = p27 == nil and 1 or p27;
    local v30 = {
        [p25] = true
    };

    if xtypeof(v28) == "State" then
        v30[v28] = true;
    end;

    if xtypeof(v29) == "State" then
        v30[v29] = true;
    end;

    local v31 = {
        type = "State",
        kind = "Spring",
        _goalValue = nil,
        _currentType = nil,
        _currentValue = nil,
        _springPositions = nil,
        _springGoals = nil,
        _springVelocities = nil,
        dependencySet = v30,
        dependentSet = setmetatable({}, u3),
        _speed = v28,
        _damping = v29,
        _goalState = p25,
        _currentSpeed = unwrap(v28),
        _currentDamping = unwrap(v29)
    };
    local v32 = setmetatable(v31, u2);
    initDependency(v32);
    p25.dependentSet[v32] = true;
    v32:update();

    return v32;
end;