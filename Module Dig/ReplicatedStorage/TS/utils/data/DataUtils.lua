-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local u1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils");
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService;
local DataTemplate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "DataTemplate").DataTemplate;

local function isTable(p2) -- Line: 9
    return type(p2) == "table";
end;

local function hasNumericKeys(p3) -- Line: 13
    local v4, v5, v6;
    v4, v5, v6 = pairs(p3);
    local v7, v8;

    if type(v4) == "function" then
        v7 = v4(v5, v8);
    else
        v7 = next(v4, v8);
    end;

    v8 = v7;

    return type(v7) == "number";
end;

local function diffValue(p9, p10) -- Line: 19
    -- upvalues: diffValue (copy)
    if type(p9) ~= "table" or type(p10) ~= "table" then
        if p9 == p10 then
            return nil;
        end;

        return p10;
    end;

    local v11 = {};
    local v12 = false;

    for i, v in pairs(p10) do
        local v13 = diffValue(p9[i], v);

        if v13 ~= nil then
            v11[tostring(i)] = v13;
            v12 = true;
        end;
    end;

    for i in pairs(p9) do
        if p10[i] == nil then
            v11[tostring(i)] = "__DEL__";
            v12 = true;
        end;
    end;

    if not v12 then
        return nil;
    end;

    local v14 = {
        k = v11
    };
    local v15;

    for i in pairs(p9) do
        v15 = type(i) == "number";
        break;
    end;

    v15 = false;

    if v15 then
        v14.n = true;
    else
        local v16;

        for i in pairs(p10) do
            v16 = type(i) == "number";
            break;
        end;

        v16 = false;

        if v16 then
            v14.n = true;
        end;
    end;

    return v14;
end;

local function applyPatch(p17, p18) -- Line: 51
    -- upvalues: applyPatch (copy)
    local k = p18.k;

    if type(k) ~= "table" then
        return nil;
    end;

    local v19 = p18.n == true;

    for i, v in pairs(k) do
        if v19 then
            local i = tonumber(i);
        end;

        if i ~= nil then
            if v == "__DEL__" then
                p17[i] = nil;
            else
                local v20 = p17[i];

                if type(v) == "table" and type(v20) == "table" then
                    applyPatch(v20, v);
                else
                    p17[i] = v;
                end;
            end;
        end;
    end;
end;

return {
    DataUtils = {
        detectChanges = function(p21, p22) -- Line: 77, Name: detectChanges
            -- upvalues: u1 (copy), diffValue (copy)
            local v23 = {};
            local v24 = {};

            for _, v in u1.keys(p22) do
                local v25 = diffValue(p21[v], p22[v]);

                if v25 ~= nil then
                    v23[v] = v25;
                    table.insert(v24, v);
                end;
            end;

            return {
                partialData = v23,
                changedKeys = v24
            };
        end,

        clonePlayerData = function(u26) -- Line: 96, Name: clonePlayerData
            -- upvalues: HttpService (copy), DataTemplate (copy)
            local success, result = pcall(function() -- Line: 97
                -- upvalues: HttpService (ref), u26 (copy)
                return HttpService:JSONDecode(HttpService:JSONEncode(u26));
            end);

            if success then
                return result;
            end;

            local v27 = table.clone(DataTemplate);
            setmetatable(v27, nil);

            return v27;
        end,

        mergePartialUpdate = function(p28, p29) -- Line: 111, Name: mergePartialUpdate
            -- upvalues: applyPatch (copy)
            for i, v in pairs(p29) do
                local v30 = p28[i];

                if type(v) == "table" and type(v30) == "table" then
                    applyPatch(v30, v);
                else
                    p28[i] = v;
                end;
            end;

            return p28;
        end,

        validatePartialData = function(p31) -- Line: 124, Name: validatePartialData
            -- upvalues: u1 (copy)
            if type(p31) ~= "table" then
                return false;
            end;

            for _, v in u1.keys(p31) do
                if #v == 0 then
                    return false;
                end;
            end;

            return true;
        end
    }
};