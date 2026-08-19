-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local u2 = {};
local u3 = 0;
local u4 = 0;

local function newScheduler(p5) -- Line: 48
    return {
        Connection = nil,
        NeedsCompact = false,
        NeedsSort = false,
        Stepping = false,
        EventName = p5,
        Bindings = {},
        BindingsByName = {},
        StepBindings = {},
        RenderPriorityBindings = {},
        RenderStepNames = {}
    };
end;

local u6 = {
    Heartbeat = newScheduler("Heartbeat"),
    RenderStepped = newScheduler("RenderStepped"),
    Stepped = newScheduler("Stepped"),
    PostSimulation = newScheduler("PostSimulation")
};

local function getTraceback(p7) -- Line: 73
    return debug.traceback(tostring(p7), 2);
end;

local function syncSchedulerConnections(p8) -- Line: 77
    -- upvalues: RunService (copy)
    if p8.EventName ~= "RenderStepped" then
        if #p8.StepBindings == 0 and p8.Connection then
            p8.Connection:Disconnect();
            p8.Connection = nil;
        end;

        return;
    end;

    if #p8.StepBindings == 0 and p8.Connection then
        p8.Connection:Disconnect();
        p8.Connection = nil;
    end;

    for i, v in pairs(p8.RenderStepNames) do
        local v9 = p8.RenderPriorityBindings[i];

        if not v9 or #v9 == 0 then
            RunService:UnbindFromRenderStep(v);
            p8.RenderStepNames[i] = nil;
        end;
    end;
end;

local function rebuildScheduler(p10) -- Line: 100
    -- upvalues: syncSchedulerConnections (copy)
    local v11 = 1;

    for i = 1, #p10.Bindings do
        local v12 = p10.Bindings[i];

        if v12.Connected then
            p10.Bindings[v11] = v12;
            v11 = v11 + 1;
        end;
    end;

    for i = v11, #p10.Bindings do
        p10.Bindings[i] = nil;
    end;

    table.sort(p10.Bindings, function(p13, p14) -- Line: 115
        if p13.Priority == p14.Priority then
            return p13.Sequence < p14.Sequence;
        end;

        return p13.Priority < p14.Priority;
    end);
    table.clear(p10.StepBindings);
    table.clear(p10.RenderPriorityBindings);

    if p10.EventName == "RenderStepped" then
        for _, v in ipairs(p10.Bindings) do
            if v.UsesRenderPriority then
                local v15 = p10.RenderPriorityBindings[v.Priority];

                if not v15 then
                    v15 = {};
                    p10.RenderPriorityBindings[v.Priority] = v15;
                end;

                table.insert(v15, v);
            else
                table.insert(p10.StepBindings, v);
            end;
        end;
    else
        for _, v in ipairs(p10.Bindings) do
            table.insert(p10.StepBindings, v);
        end;
    end;

    p10.NeedsCompact = false;
    p10.NeedsSort = false;
    syncSchedulerConnections(p10);
end;

local function invokeBinding(p16, ...) -- Line: 151
    -- upvalues: getTraceback (copy)
    local v17, v18 = xpcall(p16.Callback, getTraceback, ...);

    if not v17 then
        warn((`[RunServiceController] {p16.EventName} binding "{p16.Name}" failed:\n{v18}`));
    end;
end;

local function getStepBindings(p19, p20) -- Line: 158
    -- upvalues: u2 (copy)
    if p19.EventName ~= "RenderStepped" then
        return p19.StepBindings;
    end;

    if p20 == nil then
        return p19.StepBindings;
    end;

    return p19.RenderPriorityBindings[p20] or u2;
end;

local function stepScheduler(p21, p22, ...) -- Line: 170
    -- upvalues: rebuildScheduler (copy), u2 (copy), invokeBinding (copy)
    if p21.NeedsCompact or p21.NeedsSort then
        rebuildScheduler(p21);
    end;

    p21.Stepping = true;
    local v23;

    if p21.EventName == "RenderStepped" then
        if p22 == nil then
            v23 = p21.StepBindings;
        else
            v23 = p21.RenderPriorityBindings[p22] or u2;
        end;
    else
        v23 = p21.StepBindings;
    end;

    for i = 1, #v23 do
        local v24 = v23[i];

        if v24 and v24.Connected then
            invokeBinding(v24, ...);
        end;
    end;

    p21.Stepping = false;

    if p21.NeedsCompact or p21.NeedsSort then
        rebuildScheduler(p21);
    end;
end;

local function ensureSchedulerConnection(u25, u26, p27) -- Line: 193
    -- upvalues: RunService (copy), stepScheduler (copy)
    if u25.EventName ~= "RenderStepped" then
        if u25.Connection and u25.Connection.Connected then
            return;
        end;

        if u25.EventName == "Heartbeat" then
            u25.Connection = RunService.Heartbeat:Connect(function(p28) -- Line: 221
                -- upvalues: stepScheduler (ref), u25 (copy)
                stepScheduler(u25, nil, p28);
            end);

            return;
        end;

        if u25.EventName == "Stepped" then
            u25.Connection = RunService.Stepped:Connect(function(p29, p30) -- Line: 225
                -- upvalues: stepScheduler (ref), u25 (copy)
                stepScheduler(u25, nil, p29, p30);
            end);

            return;
        end;

        if u25.EventName == "PostSimulation" then
            u25.Connection = RunService.PostSimulation:Connect(function(p31) -- Line: 229
                -- upvalues: stepScheduler (ref), u25 (copy)
                stepScheduler(u25, nil, p31);
            end);
        end;

        return;
    end;

    if not p27 then
        if not (u25.Connection and u25.Connection.Connected) then
            u25.Connection = RunService.RenderStepped:Connect(function(p32) -- Line: 197
                -- upvalues: stepScheduler (ref), u25 (copy)
                stepScheduler(u25, nil, p32);
            end);
        end;

        return;
    end;

    if u25.RenderStepNames[u26] then
        return;
    end;

    local v33 = `RunServiceController.RenderStepped.{u26}`;
    u25.RenderStepNames[u26] = v33;
    RunService:BindToRenderStep(v33, u26, function(p34) -- Line: 210
        -- upvalues: stepScheduler (ref), u25 (copy), u26 (copy)
        stepScheduler(u25, u26, p34);
    end);
end;

local function disconnectBinding(p35, p36) -- Line: 235
    -- upvalues: rebuildScheduler (copy)
    if not p36.Connected then
        return;
    end;

    p36.Connected = false;

    if p35.BindingsByName[p36.Name] == p36 then
        p35.BindingsByName[p36.Name] = nil;
    end;

    p35.NeedsCompact = true;

    if not p35.Stepping then
        rebuildScheduler(p35);
    end;
end;

local function createBinding(p37, p38, p39, p40, p41) -- Line: 251
    -- upvalues: u6 (copy), rebuildScheduler (copy), u3 (ref), ensureSchedulerConnection (copy)
    local v42;

    if type(p38) == "string" then
        v42 = p38 ~= "";
    else
        v42 = false;
    end;

    assert(v42, "RunServiceController binding name must be a non-empty string");
    local v43 = type(p39) == "number";
    assert(v43, "RunServiceController binding priority must be a number");
    local v44 = type(p40) == "function";
    assert(v44, "RunServiceController callback must be a function");
    local u45 = u6[p37];
    local v46 = u45.BindingsByName[p38];

    if v46 and v46.Connected then
        v46.Connected = false;

        if u45.BindingsByName[v46.Name] == v46 then
            u45.BindingsByName[v46.Name] = nil;
        end;

        u45.NeedsCompact = true;

        if not u45.Stepping then
            rebuildScheduler(u45);
        end;
    end;

    u3 = u3 + 1;
    local u47 = {
        Connected = true,
        Name = p38,
        EventName = p37,
        Priority = p39,
        Callback = p40,
        Sequence = u3,
        UsesRenderPriority = p41
    };

    function u47.Disconnect(p48) -- Line: 280
        -- upvalues: u45 (copy), u47 (copy), rebuildScheduler (ref)
        local v49 = u45;
        local v50 = u47;

        if not v50.Connected then
            return;
        end;

        v50.Connected = false;

        if v49.BindingsByName[v50.Name] == v50 then
            v49.BindingsByName[v50.Name] = nil;
        end;

        v49.NeedsCompact = true;

        if not v49.Stepping then
            rebuildScheduler(v49);
        end;
    end;

    function u47.Destroy(p51) -- Line: 284
        -- upvalues: u45 (copy), u47 (copy), rebuildScheduler (ref)
        local v52 = u45;
        local v53 = u47;

        if not v53.Connected then
            return;
        end;

        v53.Connected = false;

        if v52.BindingsByName[v53.Name] == v53 then
            v52.BindingsByName[v53.Name] = nil;
        end;

        v52.NeedsCompact = true;

        if not v52.Stepping then
            rebuildScheduler(v52);
        end;
    end;

    table.insert(u45.Bindings, u47);
    u45.BindingsByName[p38] = u47;
    u45.NeedsSort = true;
    ensureSchedulerConnection(u45, p39, p41);

    return u47;
end;

local function normalizeRenderStepArgs(p54, p55) -- Line: 297
    if p55 == nil then
        return 0, p54, false;
    end;

    return p54, p55, true;
end;

function u1.CreateBindingName(p56) -- Line: 311
    -- upvalues: u4 (ref)
    local v57;

    if type(p56) == "string" then
        v57 = p56 ~= "";
    else
        v57 = false;
    end;

    assert(v57, "RunServiceController binding prefix must be a non-empty string");
    u4 = u4 + 1;

    return `{p56}.{u4}`;
end;

function u1.BindToHeartbeat(p58, p59, p60) -- Line: 318
    -- upvalues: createBinding (copy)
    return createBinding("Heartbeat", p58, p60 or 0, p59, false);
end;

function u1.BindToRenderStep(p61, p62, p63) -- Line: 322
    -- upvalues: createBinding (copy)
    local v64, v65;

    if p63 == nil then
        v64 = 0;
        v65 = false;
    else
        v64 = p62;
        p62 = p63;
        v65 = true;
    end;

    return createBinding("RenderStepped", p61, v64, p62, v65);
end;

function u1.BindToStepped(p66, p67, p68) -- Line: 331
    -- upvalues: createBinding (copy)
    return createBinding("Stepped", p66, p68 or 0, p67, false);
end;

function u1.BindToPostSimulation(p69, p70, p71) -- Line: 339
    -- upvalues: createBinding (copy)
    return createBinding("PostSimulation", p69, p71 or 0, p70, false);
end;

function u1.Unbind(p72, p73) -- Line: 347
    -- upvalues: u6 (copy), rebuildScheduler (copy)
    local v74 = u6[p72].BindingsByName[p73];

    if v74 then
        local v75 = u6[p72];

        if not v74.Connected then
            return;
        end;

        v74.Connected = false;

        if v75.BindingsByName[v74.Name] == v74 then
            v75.BindingsByName[v74.Name] = nil;
        end;

        v75.NeedsCompact = true;

        if not v75.Stepping then
            rebuildScheduler(v75);
        end;
    end;
end;

function u1.UnbindFromRenderStep(p76) -- Line: 354
    -- upvalues: u1 (copy)
    u1.Unbind("RenderStepped", p76);
end;

return u1;