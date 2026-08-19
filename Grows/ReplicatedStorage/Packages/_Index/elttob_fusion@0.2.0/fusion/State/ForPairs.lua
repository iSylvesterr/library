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

function v1.update(p6) -- Line: 61
    -- upvalues: u3 (copy), captureDependencies (copy), needsDestruction (copy), logWarn (copy), logError (copy), cleanup (copy), parseError (copy), logErrorNonFatal (copy)
    local _inputIsState = p6._inputIsState;
    local v7;

    if _inputIsState then
        v7 = p6._inputTable:get(false);
    else
        v7 = p6._inputTable;
    end;

    local _oldInputTable = p6._oldInputTable;
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

    local _oldOutputTable = p6._oldOutputTable;
    p6._oldOutputTable = p6._outputTable;
    p6._outputTable = _oldOutputTable;
    local _oldOutputTable2 = p6._oldOutputTable;
    local _outputTable = p6._outputTable;
    table.clear(_outputTable);

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

        local v10 = _oldInputTable[i] ~= v;

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
            local v11, v12, v13, v14 = captureDependencies(v9.dependencySet, p6._processor, i, v);

            if v11 then
                if p6._destructor == nil and (needsDestruction(v12) or (needsDestruction(v13) or needsDestruction(v14))) then
                    logWarn("destructorNeededForPairs");
                end;

                if _outputTable[v12] ~= nil then
                    local v15 = nil;
                    local v16 = nil;

                    for i2, v2 in pairs(_keyIOMap) do
                        if v2 == v12 then
                            v15 = v7[i2];

                            if v15 ~= nil then
                                v16 = i2;
                                break;
                            end;
                        end;
                    end;

                    if v16 ~= nil then
                        logError("forPairsKeyCollision", nil, tostring(v12), tostring(v16), tostring(v15), tostring(i), (tostring(v)));
                    end;
                end;

                local v17 = _oldOutputTable2[v12];

                if v17 ~= v13 then
                    local v18 = _meta[v12];

                    if v17 ~= nil then
                        local v19, v20 = xpcall(p6._destructor or cleanup, parseError, v12, v17, v18);

                        if not v19 then
                            logErrorNonFatal("forPairsDestructorError", v20);
                        end;
                    end;

                    _oldOutputTable2[v12] = nil;
                end;

                _oldInputTable[i] = v;
                _keyIOMap[i] = v12;
                _meta[v12] = v14;
                _outputTable[v12] = v13;
                v8 = true;
            else
                local oldDependencySet2 = v9.oldDependencySet;
                v9.oldDependencySet = v9.dependencySet;
                v9.dependencySet = oldDependencySet2;
                logErrorNonFatal("forPairsProcessorError", v12);
            end;
        else
            local v21 = _keyIOMap[i];

            if _outputTable[v21] ~= nil then
                local v22 = nil;
                local v23 = nil;

                for i2, v2 in pairs(_keyIOMap) do
                    if v21 == v2 then
                        v22 = v7[i2];

                        if v22 ~= nil then
                            v23 = i2;
                            break;
                        end;
                    end;
                end;

                if v23 ~= nil then
                    logError("forPairsKeyCollision", nil, tostring(v21), tostring(v23), tostring(v22), tostring(i), (tostring(v)));
                end;
            end;

            _outputTable[v21] = _oldOutputTable2[v21];
        end;

        for i2 in pairs(v9.dependencySet) do
            v9.dependencyValues[i2] = i2:get(false);
            p6.dependencySet[i2] = true;
            i2.dependentSet[p6] = true;
        end;
    end;

    for i, v in pairs(_oldOutputTable2) do
        if _outputTable[i] ~= v then
            local v24 = _meta[i];

            if v ~= nil then
                local v25, v26 = xpcall(p6._destructor or cleanup, parseError, i, v, v24);

                if not v25 then
                    logErrorNonFatal("forPairsDestructorError", v26);
                end;
            end;

            if _outputTable[i] == nil then
                _meta[i] = nil;
                p6._keyData[i] = nil;
            end;

            v8 = true;
        end;
    end;

    for i in pairs(_oldInputTable) do
        if v7[i] == nil then
            _oldInputTable[i] = nil;
            _keyIOMap[i] = nil;
        end;
    end;

    return v8;
end;

return function(p27, p28, p29) -- Line: 273, Name: ForPairs
    -- upvalues: u3 (copy), u2 (copy), initDependency (copy)
    local v30;

    if p27.type == "State" then
        v30 = typeof(p27.get) == "function";
    else
        v30 = false;
    end;

    local v31 = {
        type = "State",
        kind = "ForPairs",
        dependencySet = {},
        dependentSet = setmetatable({}, u3),
        _oldDependencySet = {},
        _processor = p28,
        _destructor = p29,
        _inputIsState = v30,
        _inputTable = p27,
        _oldInputTable = {},
        _outputTable = {},
        _oldOutputTable = {},
        _keyIOMap = {},
        _keyData = {},
        _meta = {}
    };
    local v32 = setmetatable(v31, u2);
    initDependency(v32);
    v32:update();

    return v32;
end;