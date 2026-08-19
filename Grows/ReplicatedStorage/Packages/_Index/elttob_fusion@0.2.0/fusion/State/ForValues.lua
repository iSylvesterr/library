-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
require(Parent.Types);
local captureDependencies = require(Parent.Dependencies.captureDependencies);
local initDependency = require(Parent.Dependencies.initDependency);
local useDependency = require(Parent.Dependencies.useDependency);
local parseError = require(Parent.Logging.parseError);
local logErrorNonFatal = require(Parent.Logging.logErrorNonFatal);
local logWarn = require(Parent.Logging.logWarn);
local cleanup = require(Parent.Utility.cleanup);
local needsDestruction = require(Parent.Utility.needsDestruction);
local v1 = {};
local u2 = {
    __index = v1
};
local u3 = {
    __mode = "k"
};

function v1.get(p4, p5) -- Line: 34
    -- upvalues: useDependency (copy)
    if p5 ~= false then
        useDependency(p4);
    end;

    return p4._outputTable;
end;

function v1.update(p6) -- Line: 59
    -- upvalues: u3 (copy), captureDependencies (copy), needsDestruction (copy), logWarn (copy), cleanup (copy), parseError (copy), logErrorNonFatal (copy)
    local _inputIsState = p6._inputIsState;
    local v7;

    if _inputIsState then
        v7 = p6._inputTable:get(false);
    else
        v7 = p6._inputTable;
    end;

    local _oldValueCache = p6._oldValueCache;
    p6._oldValueCache = p6._valueCache;
    p6._valueCache = _oldValueCache;
    local _valueCache = p6._valueCache;
    local _oldValueCache2 = p6._oldValueCache;
    table.clear(_valueCache);
    local v8 = {};
    local v9 = false;

    for i in pairs(p6.dependencySet) do
        i.dependentSet[p6] = nil;
    end;

    local _oldDependencySet = p6._oldDependencySet;
    p6._oldDependencySet = p6.dependencySet;
    p6.dependencySet = _oldDependencySet;
    table.clear(p6.dependencySet);

    if _inputIsState then
        p6._inputTable.dependentSet[p6] = true;
        p6.dependencySet[p6._inputTable] = true;
    end;

    for i, v in pairs(v7) do
        local v10 = _oldValueCache2[v];
        local v11 = v10 == nil;
        local v12 = nil;
        local v13 = nil;
        local v14 = nil;

        if type(v10) == "table" and #v10 > 0 then
            local v15 = table.remove(v10, #v10);
            v12 = v15.value;
            v13 = v15.valueData;
            v14 = v15.meta;

            if #v10 <= 0 then
                _oldValueCache2[v] = nil;
            end;
        elseif v10 ~= nil then
            _oldValueCache2[v] = nil;
            v11 = true;
        end;

        local v16 = v13 == nil and {
            dependencySet = setmetatable({}, u3),
            oldDependencySet = setmetatable({}, u3),
            dependencyValues = setmetatable({}, u3)
        } or v13;

        if v11 == false then
            for i2, v2 in pairs(v16.dependencyValues) do
                if v2 ~= i2:get(false) then
                    v11 = true;
                    break;
                end;
            end;
        end;

        local v17, v18;

        if v11 then
            local oldDependencySet = v16.oldDependencySet;
            v16.oldDependencySet = v16.dependencySet;
            v16.dependencySet = oldDependencySet;
            table.clear(v16.dependencySet);
            local v19;
            v19, v17, v18 = captureDependencies(v16.dependencySet, p6._processor, v);

            if v19 then
                if p6._destructor == nil and (needsDestruction(v17) or needsDestruction(v18)) then
                    logWarn("destructorNeededForValues");
                end;

                if v12 == nil then
                    v9 = true;
                else
                    local v20, v21 = xpcall(p6._destructor or cleanup, parseError, v12, v14);

                    if v20 then
                        v9 = true;
                    else
                        logErrorNonFatal("forValuesDestructorError", v21);
                        v9 = true;
                    end;
                end;
            else
                local oldDependencySet2 = v16.oldDependencySet;
                v16.oldDependencySet = v16.dependencySet;
                v16.dependencySet = oldDependencySet2;
                logErrorNonFatal("forValuesProcessorError", v17);
                v18 = v14;
                v17 = v12;
            end;
        else
            v18 = v14;
            v17 = v12;
        end;

        local v22 = _valueCache[v];

        if v22 == nil then
            v22 = {};
            _valueCache[v] = v22;
        end;

        table.insert(v22, {
            value = v17,
            valueData = v16,
            meta = v18
        });
        v8[i] = v17;

        for i2 in pairs(v16.dependencySet) do
            v16.dependencyValues[i2] = i2:get(false);
            p6.dependencySet[i2] = true;
            i2.dependentSet[p6] = true;
        end;
    end;

    for _, v in pairs(_oldValueCache2) do
        for _, v2 in ipairs(v) do
            local v23, v24 = xpcall(p6._destructor or cleanup, parseError, v2.value, v2.meta);

            if not v23 then
                logErrorNonFatal("forValuesDestructorError", v24);
            end;

            v9 = true;
        end;

        table.clear(v);
    end;

    p6._outputTable = v8;

    return v9;
end;

return function(p25, p26, p27) -- Line: 213, Name: ForValues
    -- upvalues: u3 (copy), u2 (copy), initDependency (copy)
    local v28;

    if p25.type == "State" then
        v28 = typeof(p25.get) == "function";
    else
        v28 = false;
    end;

    local v29 = {
        type = "State",
        kind = "ForValues",
        dependencySet = {},
        dependentSet = setmetatable({}, u3),
        _oldDependencySet = {},
        _processor = p26,
        _destructor = p27,
        _inputIsState = v28,
        _inputTable = p25,
        _outputTable = {},
        _valueCache = {},
        _oldValueCache = {}
    };
    local v30 = setmetatable(v29, u2);
    initDependency(v30);
    v30:update();

    return v30;
end;