-- Decompiled with Potassium's decompiler.

local Promise = require(script.Parent.Promise);
local RunService = game:GetService("RunService");
local u1 = {
    Promise = Promise
};

local function isPlugin(p2) -- Line: 13
    -- upvalues: RunService (copy)
    local v3 = RunService:IsStudio() and p2:FindFirstAncestorWhichIsA("Plugin") ~= nil;

    return v3;
end;

function u1.getModule(p4, p5, p6) -- Line: 17
    -- upvalues: RunService (copy)
    local v7;

    if p6 == nil then
        v7 = "@rbxts";
    else
        v7 = p5;
        p5 = p6;
    end;

    if RunService:IsRunning() and RunService:IsClient() then
        local v8 = RunService:IsStudio() and p4:FindFirstAncestorWhichIsA("Plugin") ~= nil;

        if not (v8 or game:IsLoaded()) then
            game.Loaded:Wait();
        end;
    end;

    while true do
        local node_modules = p4:FindFirstChild("node_modules");

        if node_modules then
            local v9 = node_modules:FindFirstChild(v7);
            local v10 = v9 and v9:FindFirstChild(p5);

            if v10 then
                return v10;
            end;
        end;

        p4 = p4.Parent;

        if p4 == nil then
            error("roblox-ts: " .. "Could not find module: " .. p5, 2);

            return;
        end;
    end;
end;

local u11 = {};
local u12 = {};

function u1.import(p13, p14, ...) -- Line: 51
    -- upvalues: u11 (copy), u12 (copy), u1 (copy)
    for i = 1, select("#", ...) do
        p14 = p14:WaitForChild((select(i, ...)));
    end;

    if p14.ClassName ~= "ModuleScript" then
        error("roblox-ts: " .. "Failed to import! Expected ModuleScript, got " .. p14.ClassName, 2);
    end;

    u11[p13] = p14;
    local v15 = p14;
    local v16 = 0;

    while p14 do
        v16 = v16 + 1;
        p14 = u11[p14];

        if p14 == v15 then
            local Name = p14.Name;

            for _ = 1, v16 do
                p14 = u11[p14];
                Name = Name .. "  ⇒ " .. p14.Name;
            end;

            error("roblox-ts: " .. "Failed to import! Detected a circular dependency chain: " .. Name, 2);
        end;
    end;

    if not u12[v15] then
        if _G[v15] then
            error("roblox-ts: " .. "Invalid module access! Do you have multiple TS runtimes trying to import this? " .. v15:GetFullName(), 2);
        end;

        _G[v15] = u1;
        u12[v15] = true;
    end;

    local v17 = require(v15);

    if u11[p13] == v15 then
        u11[p13] = nil;
    end;

    return v17;
end;

function u1.instanceof(p18, p19) -- Line: 111
    if type(p19) == "table" and type(p19.instanceof) == "function" then
        return p19.instanceof(p18);
    end;

    if type(p18) == "table" then
        local v20 = getmetatable(p18);

        while v20 ~= nil do
            if v20 == p19 then
                return true;
            end;

            local v21 = getmetatable(v20);

            if v21 then
                v20 = v21.__index;
            else
                v20 = nil;
            end;
        end;
    end;

    return false;
end;

function u1.async(u22) -- Line: 136
    -- upvalues: Promise (copy)
    return function(...) -- Line: 137
        -- upvalues: Promise (ref), u22 (copy)
        local u23 = select("#", ...);
        local u24 = { ... };

        return Promise.new(function(u25, u26) -- Line: 140
            -- upvalues: u22 (ref), u24 (copy), u23 (copy)
            coroutine.wrap(function() -- Line: 141
                -- upvalues: u22 (ref), u24 (ref), u23 (ref), u25 (copy), u26 (copy)
                local success, result = pcall(u22, unpack(u24, 1, u23));

                if success then
                    u25(result);

                    return;
                end;

                u26(result);
            end)();
        end);
    end;
end;

function u1.await(p27) -- Line: 153
    -- upvalues: Promise (copy)
    if not Promise.is(p27) then
        return p27;
    end;

    local v28, v29 = p27:awaitStatus();

    if v28 == Promise.Status.Resolved then
        return v29;
    end;

    if v28 == Promise.Status.Rejected then
        error(v29, 2);

        return;
    end;

    error("The awaited Promise was cancelled", 2);
end;

local function bit_sign(p30) -- Line: 170
    if bit32.btest(p30, 2147483648) then
        return p30 - 4294967296;
    end;

    return p30;
end;

function u1.bit_lrsh(p31, p32) -- Line: 179
    local v33 = bit32.arshift(p31, p32);

    if bit32.btest(v33, 2147483648) then
        return v33 - 4294967296;
    end;

    return v33;
end;

u1.TRY_RETURN = 1;
u1.TRY_BREAK = 2;
u1.TRY_CONTINUE = 3;

function u1.try(p34, p35, p36) -- Line: 187
    -- upvalues: u1 (copy)
    local v37, v38, v39 = pcall(p34);
    local v40;

    if v37 then
        v40 = nil;
    else
        v40 = v38;
        v38 = nil;
    end;

    local v41 = nil;
    local v42, v43, v44, v45;

    if v37 or not p35 then
        v42 = v41;
        v43 = v39;
        v44 = v38;
        v45 = true;
    else
        v45, v42, v43 = pcall(p35, v40);

        if v45 then
            v44 = v42;
            v42 = v41;
        else
            v44 = nil;
        end;

        if not v44 then
            v43 = v39;
            v44 = v38;
        end;
    end;

    local v46, v47;

    if p36 then
        v46, v47 = p36();

        if not v46 then
            v47 = v43;
            v46 = v44;
        end;
    else
        v47 = v43;
        v46 = v44;
    end;

    if v46 ~= u1.TRY_RETURN and (v46 ~= u1.TRY_BREAK and v46 ~= u1.TRY_CONTINUE) then
        if not v45 then
            error(v42, 2);
        end;

        if not (v37 or p35) then
            error(v40, 2);
        end;
    end;

    return v46, v47;
end;

function u1.generator(p48) -- Line: 240
    local u49 = coroutine.create(p48);

    return {
        next = function(...) -- Line: 243, Name: next
            -- upvalues: u49 (copy)
            if coroutine.status(u49) == "dead" then
                return {
                    done = true
                };
            end;

            local v50, v51 = coroutine.resume(u49, ...);

            if v50 == false then
                error(v51, 2);
            end;

            return {
                value = v51,
                done = coroutine.status(u49) == "dead"
            };
        end
    };
end;

return u1;