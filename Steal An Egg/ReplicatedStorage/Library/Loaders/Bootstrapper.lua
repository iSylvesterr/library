-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Library = ReplicatedStorage.Library;
local Trove = require(Library.Modules.Packages.Trove);
local Signal = require(Library.Modules.Packages.Signal);
local DeepCopyFeatured = require(Library.Functions.DeepCopyFeatured);
local u1 = {
    __script = script,
    __cache = {},
    __creation_locks = {}
};
u1.__index = u1;

function u1.retrive_id(p2, p3) -- Line: 22
    -- upvalues: HttpService (copy)
    if typeof(p2) == "table" then
        local v4 = typeof(p2.__unique_ecosystem_id) == "string" and p2.__unique_ecosystem_id or HttpService:GenerateGUID(false);

        if p3 then
            p2.__unique_ecosystem_id = v4;
        end;

        return v4;
    end;
end;

function u1.determine_group(p5) -- Line: 37
    -- upvalues: u1 (copy)
    if typeof(p5) == "table" then
        local v6 = {};

        for _, v in p5 do
            local v7 = u1.retrive_id(v, true);

            if typeof(v7) == "string" then
                table.insert(v6, v7);
            end;
        end;

        table.sort(v6);

        return table.concat(v6, "|");
    end;
end;

function u1.create_yield_structure(p8) -- Line: 56
    -- upvalues: Signal (copy), DeepCopyFeatured (copy)
    local u9 = {
        __safe_boot = {
            __global_env_ready = false,
            __injection_marker = Signal.new(),
            __original = {},
            __wrapped = {}
        }
    };

    if typeof(p8) == "table" then
        u9 = DeepCopyFeatured(p8, u9, nil, true) or u9;
    end;

    local v10 = {};

    local function Wrapper(u11) -- Line: 69
        -- upvalues: u9 (copy)
        return function(...) -- Line: 70
            -- upvalues: u9 (ref), u11 (copy)
            if not u9.__safe_boot.__global_env_ready then
                u9.__safe_boot.__injection_marker:Wait();
            end;

            return u11(...);
        end;
    end;

    function v10.__index(p12, p13) -- Line: 79
        -- upvalues: u9 (copy)
        local v14 = u9.__safe_boot.__original[p13] or u9.__safe_boot.__wrapped[p13];

        if v14 then
            return v14;
        end;

        local u15 = rawget(u9, p13);

        if typeof(u15) ~= "function" then
            return u15;
        end;

        local function v16(...) -- Line: 70
            -- upvalues: u9 (ref), u15 (copy)
            if not u9.__safe_boot.__global_env_ready then
                u9.__safe_boot.__injection_marker:Wait();
            end;

            return u15(...);
        end;

        u9.__safe_boot.__wrapped[p13] = v16;

        return v16;
    end;

    function v10.__newindex(p17, p18, u19) -- Line: 97
        -- upvalues: u9 (copy)
        if typeof(u19) ~= "function" then
            return rawset(u9, p18, u19);
        end;

        u9.__safe_boot.__original[p18] = u19;

        return rawset(u9, p18, function(...) -- Line: 70
            -- upvalues: u9 (ref), u19 (copy)
            if not u9.__safe_boot.__global_env_ready then
                u9.__safe_boot.__injection_marker:Wait();
            end;

            return u19(...);
        end);
    end;

    return setmetatable(u9, v10);
end;

function u1.new(p20, p21, p22) -- Line: 110
    -- upvalues: u1 (copy), Trove (copy), Signal (copy)
    local v23 = typeof(p20) == "table" and p20 and p20 or {};
    local v24 = typeof(p22) == "string" and p22 and p22 or "CYCLE_ONCE";
    local v25 = typeof(p21) == "string" and p21 and p21 or u1.determine_group(v23);

    if u1.__cache[v25] then
        return u1.__cache[v25];
    end;

    local v26 = Trove.new();
    local v27 = {
        __injected = false,
        __initialized = false,
        __deployed = false,
        __loading = false,
        Directory = v23,
        Group_Id = v25,
        Lifecycle = v24,
        Kernel = v26,
        __ecosystem = {},
        __loaded_signal_marker = v26:Add(Signal.new())
    };
    local v28 = setmetatable(v27, u1);
    u1.__cache[v25] = v28;

    return v28;
end;

function u1.__get_node_state(p29, p30) -- Line: 143
    if typeof(p30) == "table" then
        p30.__bootstrap_port = p30.__bootstrap_port or {};
        p30.__bootstrap_port.__global_ecosystem = p30.__bootstrap_port.__global_ecosystem or {};
        p30.__bootstrap_port[p29.Group_Id] = p30.__bootstrap_port[p29.Group_Id] or {};

        return p30.__bootstrap_port[p29.Group_Id];
    end;
end;

function u1.__verify_port(p31, p32, p33, p34, ...) -- Line: 155
    if typeof(p32) ~= "string" or typeof(p33) ~= "table" then
        return "__exit";
    end;

    local v35 = p31:__get_node_state(p33);
    local v36 = typeof(p34) == "table" and p34 and p34 or {};

    if v36.Global then
        v35 = p33.__bootstrap_port or v35;
    end;

    if typeof(v35) == "table" then
        local v37 = v35[p32];

        if select("#", ...) ~= 0 then
            v35[p32] = ...;
        end;

        if v36.Cache then
            return v37;
        end;

        return v35[p32];
    end;
end;

function u1.__should_process(p38, p39, p40) -- Line: 176
    if typeof(p39) == "table" and (typeof(p40) ~= "string" or not p38:__verify_port(p40, p39, {
        Cache = true
    }, true)) then
        if p40 ~= "__injected" then
            if p38.Lifecycle == "CYCLE_ONCE" then
                return not p38:__verify_port("__global_processed", p39, {
                    Global = true
                });
            end;

            if p38.Lifecycle == "DYNAMIC" then
                return p38:__verify_port("__last_group", p39, {
                    Global = true
                }) ~= p38.Group_Id;
            end;
        end;

        return true;
    end;
end;

function u1.__mark_node_processed(p41, p42) -- Line: 197
    if typeof(p42) ~= "table" then
        return;
    end;

    if p41.Lifecycle == "CYCLE_ONCE" then
        p41:__verify_port("__global_processed", p42, {
            Global = true
        }, true);

        return;
    end;

    if p41.Lifecycle == "DYNAMIC" then
        p41:__verify_port("__last_group", p42, {
            Global = true
        }, p41.Group_Id);
    end;
end;

function u1.__run_lifecycle(p43, p44, p45, p46, ...) -- Line: 210
    if p43[p45] then
        return p43;
    end;

    p43[p45] = true;

    for i, v in pairs(p43.Directory) do
        if p43:__should_process(v, p45) then
            if p46 then
                p43:__mark_node_processed(v);
            end;

            local v47 = v[p44];

            if typeof(v47) == "function" then
                local success, result = pcall(v47, v, ...);

                if success then
                    print(p44 .. " success for module:", i);
                else
                    warn(p44 .. " failed for module:", i, result);
                end;
            end;
        end;
    end;

    return p43;
end;

function u1.Inject(p48) -- Line: 246
    -- upvalues: DeepCopyFeatured (copy)
    if p48.__injected then
        return p48;
    end;

    p48.__injected = true;

    for i, v in pairs(p48.Directory) do
        if p48:__should_process(v, "__injected") then
            DeepCopyFeatured(p48.Directory, v.__bootstrap_port.__global_ecosystem, nil, true, {
                [i] = true
            });

            if typeof(v.__safe_boot) == "table" then
                v.__global_env_ready = true;
                v.__injection_marker:Fire();
            end;
        end;
    end;

    return p48;
end;

function u1.Initialize(p49, ...) -- Line: 268
    return p49:__run_lifecycle("Initialize", "__initialized", false, ...);
end;

function u1.Deploy(p50, ...) -- Line: 272
    return p50:__run_lifecycle("Deploy", "__deployed", true, ...);
end;

function u1.Bootstrap(p51, ...) -- Line: 277
    if p51.__bootstrapped then
        return p51;
    end;

    p51.__bootstrapped = true;
    p51.__loading = true;
    p51:Inject();
    p51:Initialize(...);
    p51:Deploy(...);
    p51.__loading = false;
    p51.__loaded_signal_marker:Fire();

    return p51;
end;

function u1.Destroy(p52) -- Line: 293
    if p52.__loading then
        p52.__loaded_signal_marker:Wait();
    end;

    p52.Kernel:Destroy();
    table.clear(p52);
    setmetatable(p52, nil);
end;

return u1;