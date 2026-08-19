-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Functions = ReplicatedStorage:WaitForChild("Library"):WaitForChild("Functions");
local KeyToString = require(Functions:WaitForChild("KeyToString"));
local InstanceCheck = require(Functions:WaitForChild("InstanceCheck"));
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);

local function processKey(p1, p2) -- Line: 23
    local v3 = p1:gsub("^(.-)%s*|%s*", "");

    if p2.keyParser then
        v3 = p2.keyParser(v3);

        if not v3 then
            p2.warn(("Invalid key: %s"):format(p1));

            return;
        end;
    end;

    return v3;
end;

return function(p4, u5, p6) -- Line: 38
    -- upvalues: Asserts (copy), InstanceCheck (copy), KeyToString (copy), Constants (copy)
    Asserts.Instance(p4);
    Asserts.table(u5);
    Asserts.optional.table(p6);
    local u7 = p6 or {};
    local u8 = u7.rootName or "script";
    local u9 = u7.typeCast and (("::%s"):format(u7.typeCast) or "") or "";
    local u10 = u7.warn or warn;
    u7.warn = u10;
    u5.__lazy_directory = true;
    u5.__lazy_cache = {};
    local u11 = true;
    local u12 = {};

    local function injectMetadata(p13, p14, p15) -- Line: 56
        -- upvalues: u7 (copy)
        if u7.shouldInject and type(p15) == "table" then
            if p15._id == nil then
                p15._id = p14;
            end;

            if p15._script == nil then
                p15._script = p13;
            end;
        end;
    end;

    local function applyLazyMetatable(p16) -- Line: 67
        -- upvalues: u11 (ref), u8 (copy), InstanceCheck (ref), u7 (copy)
        local u17 = typeof(p16) == "table" and p16 or {
            __lazy_directory = true,
            __lazy_cache = {}
        };

        if not u17.__lazy_directory or u17.__lazy_directory_loaded then
            return u17;
        end;

        u17.__lazy_directory_loaded = true;

        return setmetatable(u17, {
            __metatable = "Locked",

            __index = function(p18, p19) -- Line: 76, Name: __index
                -- upvalues: u17 (ref), u11 (ref), u8 (ref), InstanceCheck (ref), u7 (ref)
                local v20 = u17.__lazy_cache[p19];

                if not (v20 or u11) then
                    error(("Unknown entry \'%s\', for \'%s\'"):format(tostring(p19), u8));
                end;

                if u11 or not InstanceCheck(v20, "ModuleScript") then
                    return v20;
                end;

                local v21 = require(v20);
                u17.__lazy_cache[p19] = nil;
                rawset(p18, p19, v21);

                if u7.shouldInject and type(v21) == "table" then
                    if v21._id == nil then
                        v21._id = p19;
                    end;

                    if v21._script == nil then
                        v21._script = v20;
                    end;
                end;

                return v21;
            end,

            __newindex = function(p22, p23, p24) -- Line: 95, Name: __newindex
                -- upvalues: u11 (ref), u17 (ref)
                if not u11 then
                    error(("Tried to set key \'%s\' on read-only table!"):format(p23));
                end;

                rawset(u17, p23, p24);
            end
        });
    end;

    applyLazyMetatable(u5);

    local function loadModule(p25, p26, p27, p28, p29) -- Line: 109
        -- upvalues: u7 (copy), u5 (copy), applyLazyMetatable (copy), loadModule (copy), u12 (ref), KeyToString (ref), u9 (copy), Constants (ref), u10 (copy)
        local v30 = p27 or 0;

        if p25:GetAttribute("NOLOAD") then
            return;
        end;

        if not p25:IsA("Folder") then
            if p25:IsA("ModuleScript") then
                local Name = p25.Name;
                local v31 = u7;
                local v32 = Name:gsub("^(.-)%s*|%s*", "");

                if v31.keyParser then
                    v32 = v31.keyParser(v32);

                    if not v32 then
                        v31.warn(("Invalid key: %s"):format(Name));
                        v32 = nil;
                    end;
                end;

                if not v32 then
                    return;
                end;

                if p29[v32] then
                    u10(("Duplicate entry: %s"):format(v32));
                else
                    p29[v32] = true;
                    local v33 = p28[v32];

                    if not v33 then
                        if not u7.noPrint then
                            local v34 = KeyToString(v32);
                            table.insert(u12, ("[%s] = require(%s:WaitForChild(\"%s\"))%s"):format(v34, p26, p25.Name, u9));
                        end;

                        p28.__lazy_cache[v32] = p25;

                        return;
                    end;

                    if u7.shouldInject and type(v33) == "table" then
                        if v33._id == nil then
                            v33._id = v32;
                        end;

                        if v33._script == nil then
                            v33._script = p25;
                        end;
                    end;

                    local v35 = os.clock();
                    local v36 = require(p25);
                    local v37 = (os.clock() - v35) * 1000;
                    local v38 = math.ceil(v37);

                    if v38 >= 25 and Constants.IS_STUDIO then
                        u10("[SlowModule]", p25, ("%dms"):format(v38));
                    end;

                    if v33 ~= v36 then
                        return u10(("Mismatched entry: %s"):format(v32));
                    end;
                end;
            end;

            return;
        end;

        if u7.maxDepth and u7.maxDepth <= v30 then
            return;
        end;

        local v39 = u5;
        local v40 = ("%s:WaitForChild(\"%s\")"):format(p26, p25.Name);

        if u7.structureDirectories then
            local Name = p25.Name;
            local v41 = u7;
            local v42 = Name:gsub("^(.-)%s*|%s*", "");

            if v41.keyParser then
                v42 = v41.keyParser(v42);

                if not v42 then
                    v41.warn(("Invalid key: %s"):format(Name));
                    v42 = nil;
                end;
            end;

            p28[v42] = p28[v42] or applyLazyMetatable();
            v39 = p28[v42];
            p29 = {};
        end;

        for _, child in ipairs(p25:GetChildren()) do
            loadModule(child, v40, v30 + 1, v39, p29);
        end;
    end;

    local v43 = {};

    for _, child in ipairs(p4:GetChildren()) do
        loadModule(child, u8, 0, u5, v43);
    end;

    for i in pairs(u5) do
        if not (v43[i] or i:match("__lazy_")) then
            u10(("Unknown entry: %s"):format(i));
        end;
    end;

    if #u12 > 0 and not u7.noPrint then
        table.sort(u12);
        u10(("Unadded entries: \n\n%s\n"):format(table.concat(u12, ",\n") .. ",\n"));
    end;

    u12 = nil;
    u11 = nil;

    return u5;
end;