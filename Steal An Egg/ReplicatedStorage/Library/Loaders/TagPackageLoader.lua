-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local u1 = RunService:IsServer();

if not (u1 or game:IsLoaded()) then
    game.Loaded:Wait();
end;

local Private = script.Private;
local Functions = ReplicatedStorage.Library.Functions;
local UtilityPackageInjector = require(Functions.UtilityPackageInjector);
local Database = require(Private.Database);
local Templates = require(Private.Templates);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local InstanceCheck = require(Functions.InstanceCheck);
local Bootstrapper = require(script.Parent.Bootstrapper);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u2 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u3 = os.clock();
local u4 = "";
local u5 = setmetatable({}, {
    __mod = "k"
});
local u6 = t.optional(t.union(t.string, t.table));
local u7 = UtilityPackageInjector.new(nil, Database.Exclude_Protocol);
u7.__index = u7;

function u7.new(p8, p9) -- Line: 62
    -- upvalues: Asserts (copy), u6 (copy), UtilityPackageInjector (copy), Database (copy), u7 (copy)
    Asserts.string(p8);
    assert(u6(p9));
    local v10 = UtilityPackageInjector.new({
        __tagPackageLoader_ecosystem = {
            __master_logger = {},
            Flag = p8,
            Directories = {},
            Logger = p9
        }
    }, Database.Exclude_Protocol);

    return setmetatable(v10, u7);
end;

function u7.Get_Logs(p11) -- Line: 86
    -- upvalues: u3 (copy), u4 (ref)
    return `({(os.clock() - u3) * 1000})ms:{u4}`;
end;

function u7.Extract_Token(p12, p13) -- Line: 90
    -- upvalues: InstanceCheck (copy), HttpService (copy)
    if InstanceCheck(p13, "ModuleScript") then
        return p13:GetAttribute("__overwrite") or p13:GetAttribute("__guid") and HttpService:GenerateGUID(false) or p13.Name;
    end;
end;

function u7.Read_Logger(p14) -- Line: 100
    -- upvalues: Templates (copy)
    local Logger = p14.__tagPackageLoader_ecosystem.Logger;

    if typeof(Logger) ~= "table" or not Logger then
        if typeof(Logger) == "string" then
            Logger = Templates[Logger];
        else
            Logger = false;
        end;
    end;

    if not Logger then
        p14.__tagPackageLoader_ecosystem.Logger = "All_Extensions";
    end;

    return Logger or Templates.All_Extensions;
end;

function u7.Bootstrap_Directory(p15, p16, p17, ...) -- Line: 111
    -- upvalues: Bootstrapper (copy)
    local v18;

    if p17 then
        v18 = p15.__tagPackageLoader_ecosystem.Directories;
    else
        v18 = p17;
    end;

    if p17 and v18[p16] then
        return v18[p16];
    end;

    local v19;

    if typeof(p16) == "string" then
        v19 = p15[p16];
    else
        v19 = false;
    end;

    if typeof(v19) == "table" then
        local v20 = Bootstrapper.new(v19):Bootstrap(...);

        if p17 then
            v18[p16] = v20;
        end;

        return v20;
    end;
end;

function u7.Bootstrap_All(p21, ...) -- Line: 130
    local __master_logger = p21.__tagPackageLoader_ecosystem.__master_logger;

    if typeof(__master_logger) ~= "table" then
        return warn("The initialization must happen before bootstrapping all");
    end;

    for _, v in __master_logger do
        p21:Bootstrap_Directory(v, true, ...);
    end;

    return __master_logger;
end;

function u7.Load(u22, p23) -- Line: 143
    -- upvalues: CollectionService (copy), u5 (copy), u4 (ref), u1 (copy), u2 (copy)
    local v24 = {};
    u22.__tagPackageLoader_ecosystem.__master_logger = v24;
    local u25 = 0;
    local v26 = {};
    local u27 = 0;

    for _, v in u22:Read_Logger() do
        local v28;

        if typeof(v) == "string" then
            v28 = CollectionService:GetTagged(u22.__tagPackageLoader_ecosystem.Flag .. v);
        else
            v28 = false;
        end;

        if typeof(v28) == "table" and #v28 ~= 0 then
            local v29 = not u22[v];
            local v30 = `Attempt to load directory: "{v}", multiple times`;
            assert(v29, v30);
            v26[v] = v28;
            u22[v] = {};
            table.insert(v24, v);
            u25 = u25 + #v28;
        end;
    end;

    local v31 = `Attempt to load an empty module directory: [{table.concat(u22:Read_Logger(), ", ")}]`;
    assert(u25 > 0, v31);

    for i, v in v26 do
        local u32 = u22[i];

        for i2 = 1, #v do
            local function perform() -- Line: 174
                -- upvalues: v (copy), i2 (copy), i (copy), u5 (ref), u32 (copy), u27 (ref), u22 (copy), u4 (ref), u1 (ref), u25 (ref), u2 (ref)
                local v33 = os.clock();
                local u34 = false;
                local u35 = v[i2];
                local v36;

                if u35 then
                    v36 = u35:IsA("ModuleScript");
                else
                    v36 = u35;
                end;

                local v37 = `Attempt to load a non-module script: "{u35:GetFullName()}" in directory: "{i}"`;
                assert(v36, v37);
                local v38 = u5[u35];

                if typeof(v38) == "table" then
                    u32[v38.Key] = v38.Result;
                    u27 = u27 + 1;

                    return;
                end;

                local u39 = u22:Extract_Token(u35);

                if not u39 then
                    return;
                end;

                task.delay(5, function() -- Line: 202
                    -- upvalues: u34 (ref), u35 (copy), u4 (ref)
                    if u34 then
                        return;
                    end;

                    local v40 = `TagPackageLoader:Load("{u35:GetFullName()}") taking longer than expected`;
                    warn(v40);
                    u4 = u4 .. (v40 or "") .. "\n";
                end);
                local Name = u35.Name;
                debug.setmemorycategory(Name);
                local u41 = true;
                local u42 = nil;
                local u43 = `[TagPackageLoader] REQUIRE {u35.Name} failed: %ERROR`;
                xpcall(function() -- Line: 220, Name: requireModule
                    -- upvalues: u35 (copy), u32 (ref), u39 (copy), u5 (ref)
                    local v44 = require(u35);
                    u32[u39] = v44;
                    u5[u35] = {
                        Result = v44,
                        Key = u39
                    };
                end, function(p45) -- Line: 227
                    -- upvalues: u43 (copy), u41 (ref), u42 (ref)
                    local v46 = u43:gsub("%%ERROR", (tostring(p45)));
                    u41 = false;
                    u42 = v46;
                    local v47 = debug.traceback();
                    warn("ERROR: " .. u42 .. "\n" .. v47);
                end);

                if not u41 then
                    debug.setmemorycategory("post-TagPackageLoader-error");
                    error(u42);
                end;

                u34 = true;
                local v48 = (os.clock() - v33) * 1000;
                u4 = u4 .. "\n" .. (`[{u1 and "Server" or "Client"} TagPackageLoader] Module "{Name}" finished requiring under "{i}". ({math.floor(v48)} ms)` or "") .. "\n";
                local v49 = (debug.info(2, "s") or "unknown"):split(".");
                debug.setmemorycategory(v49[#v49]);
                u27 = u27 + 1;

                if u27 ~= u25 then
                    return;
                end;

                u2:AtTrace():SepLog();
                u2:AtTrace():Log((`\nSuccessfully loaded directories, ({u27}/{u25}): [{table.concat(u22:Read_Logger(), ", ")}]`));
                u2:AtTrace():SepLog();
            end;

            if p23 then
                perform();
            else
                task.spawn(perform);
            end;

            if i2 % 400 == 0 then
                task.wait();
            end;
        end;
    end;

    return u22;
end;

return u7;