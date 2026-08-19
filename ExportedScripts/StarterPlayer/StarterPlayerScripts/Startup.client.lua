-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Profiler = require(ReplicatedStorage.Shared.Profiler);

local function getTraceback(p1) -- Line: 10
    return debug.traceback(tostring(p1), 2);
end;

local function runPhase(p2, p3, ...) -- Line: 14
    -- upvalues: Profiler (copy), getTraceback (copy)
    Profiler.mark((`Startup.Begin.{p2}`));
    local v4 = table.pack(xpcall(p3, getTraceback, ...));
    Profiler.mark((`Startup.End.{p2}`));

    if v4[1] then
        return true, table.unpack(v4, 2, v4.n);
    end;

    warn((`[Startup] {p2} failed:\n{v4[2]}`));

    return false;
end;

local function runStartupThread(u5, u6) -- Line: 29
    -- upvalues: Profiler (copy)
    task.spawn(function() -- Line: 30
        -- upvalues: u5 (copy), Profiler (ref), u6 (copy)
        debug.setmemorycategory((`Startup.{u5}`));
        Profiler.mark((`Startup.Thread.{u5}`));
        u6();
    end);
end;

local function initialize(p7, p8) -- Line: 37
    -- upvalues: runPhase (copy)
    if typeof(p8) ~= "table" then
        return;
    end;

    local Initialize = p8.Initialize;

    if Initialize then
        runPhase(`Initialize.{p7}`, Initialize);
    end;
end;

local function start(u9, p10) -- Line: 48
    -- upvalues: runPhase (copy), Profiler (copy)
    if typeof(p10) ~= "table" then
        return;
    end;

    local Start = p10.Start;

    if Start then
        local u11 = `Start.{u9}`;

        local function u12() -- Line: 58
            -- upvalues: runPhase (ref), u9 (copy), Start (copy)
            runPhase(`Start.{u9}`, Start);
        end;

        task.spawn(function() -- Line: 30
            -- upvalues: u11 (copy), Profiler (ref), u12 (copy)
            debug.setmemorycategory((`Startup.{u11}`));
            Profiler.mark((`Startup.Thread.{u11}`));
            u12();
        end);
    end;
end;

local function loadController(u13) -- Line: 64
    -- upvalues: Profiler (copy), ReplicatedStorage (copy), runPhase (copy)
    local u14 = Profiler.getInstancePath(u13, ReplicatedStorage);
    local u15 = `Controller.{u14}`;

    local function u23() -- Line: 69
        -- upvalues: u14 (copy), runPhase (ref), u13 (copy), Profiler (ref)
        debug.setmemorycategory((`Startup.Controller.{u14}`));
        local v16, v17 = runPhase(`Require.{u14}`, require, u13);

        if not v16 then
            return;
        end;

        local v18 = u14;
        local v19 = typeof(v17) == "table" and v17.Initialize;

        if v19 then
            runPhase(`Initialize.{v18}`, v19);
        end;

        local u20 = u14;

        if typeof(v17) ~= "table" then
            return;
        end;

        local Start = v17.Start;

        if Start then
            local u21 = `Start.{u20}`;

            local function u22() -- Line: 58
                -- upvalues: runPhase (ref), u20 (copy), Start (copy)
                runPhase(`Start.{u20}`, Start);
            end;

            task.spawn(function() -- Line: 30
                -- upvalues: u21 (copy), Profiler (ref), u22 (copy)
                debug.setmemorycategory((`Startup.{u21}`));
                Profiler.mark((`Startup.Thread.{u21}`));
                u22();
            end);
        end;
    end;

    task.spawn(function() -- Line: 30
        -- upvalues: u15 (copy), Profiler (ref), u23 (copy)
        debug.setmemorycategory((`Startup.{u15}`));
        Profiler.mark((`Startup.Thread.{u15}`));
        u23();
    end);
end;

local function loadObserver(u24) -- Line: 82
    -- upvalues: Profiler (copy), ReplicatedStorage (copy), runPhase (copy)
    local u25 = Profiler.getInstancePath(u24, ReplicatedStorage);
    local u26 = `Observer.{u25}`;

    local function u27() -- Line: 85
        -- upvalues: u25 (copy), runPhase (ref), u24 (copy)
        debug.setmemorycategory((`Startup.Observer.{u25}`));
        runPhase(`Require.{u25}`, require, u24);
    end;

    task.spawn(function() -- Line: 30
        -- upvalues: u26 (copy), Profiler (ref), u27 (copy)
        debug.setmemorycategory((`Startup.{u26}`));
        Profiler.mark((`Startup.Thread.{u26}`));
        u27();
    end);
end;

local function loadInterface(u28) -- Line: 91
    -- upvalues: runPhase (copy), Profiler (copy)
    local function u31() -- Line: 92
        -- upvalues: runPhase (ref), u28 (copy)
        local v29, v30 = runPhase("Require.Interface", require, u28);

        if not v29 then
            return;
        end;

        if typeof(v30) ~= "table" then
            return;
        end;

        if v30.Initialize and not runPhase("Interface.Initialize", v30.Initialize) then
            return;
        end;

        if v30.Start then
            runPhase("Interface.Start", v30.Start);
        end;
    end;

    local u32 = "Interface";
    task.spawn(function() -- Line: 30
        -- upvalues: u32 (copy), Profiler (ref), u31 (copy)
        debug.setmemorycategory((`Startup.{u32}`));
        Profiler.mark((`Startup.Thread.{u32}`));
        u31();
    end);
end;

for _, child in ipairs(ReplicatedStorage.Controllers:GetChildren()) do
    if child:IsA("ModuleScript") then
        local u33 = Profiler.getInstancePath(child, ReplicatedStorage);
        local u34 = `Controller.{u33}`;

        local function u42() -- Line: 69
            -- upvalues: u33 (copy), runPhase (copy), child (copy), Profiler (copy)
            debug.setmemorycategory((`Startup.Controller.{u33}`));
            local v35, v36 = runPhase(`Require.{u33}`, require, child);

            if not v35 then
                return;
            end;

            local v37 = u33;
            local v38 = typeof(v36) == "table" and v36.Initialize;

            if v38 then
                runPhase(`Initialize.{v37}`, v38);
            end;

            local u39 = u33;

            if typeof(v36) ~= "table" then
                return;
            end;

            local Start = v36.Start;

            if Start then
                local u40 = `Start.{u39}`;

                local function u41() -- Line: 58
                    -- upvalues: runPhase (ref), u39 (copy), Start (copy)
                    runPhase(`Start.{u39}`, Start);
                end;

                task.spawn(function() -- Line: 30
                    -- upvalues: u40 (copy), Profiler (ref), u41 (copy)
                    debug.setmemorycategory((`Startup.{u40}`));
                    Profiler.mark((`Startup.Thread.{u40}`));
                    u41();
                end);
            end;
        end;

        task.spawn(function() -- Line: 30
            -- upvalues: u34 (copy), Profiler (copy), u42 (copy)
            debug.setmemorycategory((`Startup.{u34}`));
            Profiler.mark((`Startup.Thread.{u34}`));
            u42();
        end);
    end;
end;

for _, child in ipairs(ReplicatedStorage.Controllers.Observers:GetChildren()) do
    if child:IsA("ModuleScript") then
        local u43 = Profiler.getInstancePath(child, ReplicatedStorage);
        local u44 = `Observer.{u43}`;

        local function u45() -- Line: 85
            -- upvalues: u43 (copy), runPhase (copy), child (copy)
            debug.setmemorycategory((`Startup.Observer.{u43}`));
            runPhase(`Require.{u43}`, require, child);
        end;

        task.spawn(function() -- Line: 30
            -- upvalues: u44 (copy), Profiler (copy), u45 (copy)
            debug.setmemorycategory((`Startup.{u44}`));
            Profiler.mark((`Startup.Thread.{u44}`));
            u45();
        end);
    elseif child:IsA("Folder") then
        for _, child2 in ipairs(child:GetChildren()) do
            if child2:IsA("ModuleScript") then
                local u46 = Profiler.getInstancePath(child2, ReplicatedStorage);
                local u47 = `Observer.{u46}`;

                local function u48() -- Line: 85
                    -- upvalues: u46 (copy), runPhase (copy), child2 (copy)
                    debug.setmemorycategory((`Startup.Observer.{u46}`));
                    runPhase(`Require.{u46}`, require, child2);
                end;

                task.spawn(function() -- Line: 30
                    -- upvalues: u47 (copy), Profiler (copy), u48 (copy)
                    debug.setmemorycategory((`Startup.{u47}`));
                    Profiler.mark((`Startup.Thread.{u47}`));
                    u48();
                end);
            end;
        end;
    end;
end;

local Interface = ReplicatedStorage:WaitForChild("Interface");

local function u51() -- Line: 92
    -- upvalues: runPhase (copy), Interface (copy)
    local v49, v50 = runPhase("Require.Interface", require, Interface);

    if not v49 then
        return;
    end;

    if typeof(v50) ~= "table" then
        return;
    end;

    if v50.Initialize and not runPhase("Interface.Initialize", v50.Initialize) then
        return;
    end;

    if v50.Start then
        runPhase("Interface.Start", v50.Start);
    end;
end;

local u52 = "Interface";
task.spawn(function() -- Line: 30
    -- upvalues: u52 (copy), Profiler (copy), u51 (copy)
    debug.setmemorycategory((`Startup.{u52}`));
    Profiler.mark((`Startup.Thread.{u52}`));
    u51();
end);