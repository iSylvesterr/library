-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
require(Parent.Types);
local captureDependencies = require(Parent.Dependencies.captureDependencies);
local initDependency = require(Parent.Dependencies.initDependency);
local useDependency = require(Parent.Dependencies.useDependency);
local parseError = require(Parent.Logging.parseError);
local logErrorNonFatal = require(Parent.Logging.logErrorNonFatal);
local logError = require(Parent.Logging.logError);
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

function v1.get(p4, p5) -- Line: 36
    -- upvalues: useDependency (copy)
    if p5 ~= false then
        useDependency(p4);
    end;

    return p4._outputTable;
end;

function v1.update(p6) -- Line: 62
    -- upvalues: u3 (copy), captureDependencies (copy), needsDestruction (copy), logWarn (copy), logError (copy), cleanup (copy), parseError (copy), logErrorNonFatal (copy)
    local _inputIsState = p6._inputIsState;
    local v7;

    if _inputIsState then
        v7 = p6._inputTable:get(false);
    else
        v7 = p6._inputTable;
    end;

    local _oldInputTable = p6._oldInputTable;
    local _outputTable = p6._outputTable;
    local _keyOIMap = p6._keyOIMap;
    local _keyIOMap = p6._keyIOMap;
    local _meta = p6._meta;
    local v8 = false;

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
        local v9 = p6._keyData[i];

        if v9 == nil then
            v9 = {
                dependencySet = setmetatable({}, u3),
                oldDependencySet = setmetatable({}, u3),
                dependencyValues = setmetatable({}, u3)
            };
            p6._keyData[i] = v9;
        end;

        local v10 = _oldInputTable[i] == nil;

        if v10 == false then
            for i2, v2 in pairs(v9.dependencyValues) do
                if v2 ~= i2:get(false) then
                    v10 = true;
                    break;
                end;
            end;
        end;

        if v10 then
            local oldDependencySet = v9.oldDependencySet;
            v9.oldDependencySet = v9.dependencySet;
            v9.dependencySet = oldDependencySet;
            table.clear(v9.dependencySet);
            local v11, v12, v13 = captureDependencies(v9.dependencySet, p6._processor, i);

            if v11 then
                if p6._destructor == nil and (needsDestruction(v12) or needsDestruction(v13)) then
                    logWarn("destructorNeededForKeys");
                end;

                local v14 = _keyOIMap[v12];
                local v15 = _keyIOMap[i];

                if v14 ~= i and v7[v14] ~= nil then
                    logError("forKeysKeyCollision", nil, tostring(v12), tostring(v14), (tostring(v12)));
                end;

                if v15 ~= v12 and _keyOIMap[v15] == i then
                    local v16, v17 = xpcall(p6._destructor or cleanup, parseError, v15, _meta[v15]);

                    if not v16 then
                        logErrorNonFatal("forKeysDestructorError", v17);
                    end;

                    _keyOIMap[v15] = nil;
                    _outputTable[v15] = nil;
                    _meta[v15] = nil;
                end;

                _oldInputTable[i] = v;
                _meta[v12] = v13;
                _keyOIMap[v12] = i;
                _keyIOMap[i] = v12;
                _outputTable[v12] = v;
                v8 = true;
            else
                local oldDependencySet2 = v9.oldDependencySet;
                v9.oldDependencySet = v9.dependencySet;
                v9.dependencySet = oldDependencySet2;
                logErrorNonFatal("forKeysProcessorError", v12);
            end;
        end;

        for i2 in pairs(v9.dependencySet) do
            v9.dependencyValues[i2] = i2:get(false);
            p6.dependencySet[i2] = true;
            i2.dependentSet[p6] = true;
        end;
    end;

    for i, v in pairs(_keyOIMap) do
        if v7[v] == nil then
            local v18, v19 = xpcall(p6._destructor or cleanup, parseError, i, _meta[i]);

            if not v18 then
                logErrorNonFatal("forKeysDestructorError", v19);
            end;

            _oldInputTable[v] = nil;
            _meta[i] = nil;
            _keyOIMap[i] = nil;
            _keyIOMap[v] = nil;
            _outputTable[i] = nil;
            p6._keyData[v] = nil;
            v8 = true;
        end;
    end;

    return v8;
end;

return function(p20, p21, p22) -- Line: 212, Name: ForKeys
    -- upvalues: u3 (copy), u2 (copy), initDependency (copy)
    local v23;

    if p20.type == "State" then
        v23 = typeof(p20.get) == "function";
    else
        v23 = false;
    end;

    local v24 = {
        type = "State",
        kind = "ForKeys",
        dependencySet = {},
        dependentSet = setmetatable({}, u3),
        _oldDependencySet = {},
        _processor = p21,
        _destructor = p22,
        _inputIsState = v23,
        _inputTable = p20,
        _oldInputTable = {},
        _outputTable = {},
        _keyOIMap = {},
        _keyIOMap = {},
        _keyData = {},
        _meta = {}
    };
    local v25 = setmetatable(v24, u2);
    initDependency(v25);
    v25:update();

    return v25;
end;