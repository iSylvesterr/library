-- Decompiled with Potassium's decompiler.

require(script.Types);
local u1 = {};
local u2 = require(script.Internal)(u1);
u1.Disabled = false;
u1.Args = {};
u1.Events = {};

function u1.Init(p3, u4, p5) -- Line: 73
    -- upvalues: u2 (copy), u1 (copy)
    assert(u2._shutdown == false, "Iris.Init() cannot be called once shutdown.");
    assert(u2._started == false and true or p5 == true, "Iris.Init() can only be called once.");

    if u2._started then
        return u1;
    end;

    if p3 == nil then
        p3 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
    end;

    if u4 == nil then
        u4 = game:GetService("RunService").Heartbeat;
    end;

    u2.parentInstance = p3;
    u2._started = true;
    u2._generateRootInstance();
    u2._generateSelectionImageObject();

    for _, v in u2._initFunctions do
        v();
    end;

    task.spawn(function() -- Line: 100
        -- upvalues: u4 (ref), u2 (ref)
        if typeof(u4) == "function" then
            while u2._started do
                local v6 = u4();
                u2._cycle(v6);
            end;
        elseif u4 ~= nil and u4 ~= false then
            u2._eventConnection = u4:Connect(function(...) -- Line: 107
                -- upvalues: u2 (ref)
                u2._cycle(...);
            end);
        end;
    end);

    return u1;
end;

function u1.Shutdown() -- Line: 122
    -- upvalues: u2 (copy)
    u2._started = false;
    u2._shutdown = true;

    if u2._eventConnection then
        u2._eventConnection:Disconnect();
    end;

    u2._eventConnection = nil;

    if u2._rootWidget then
        if u2._rootWidget.Instance then
            u2._widgets.Root.Discard(u2._rootWidget);
        end;

        u2._rootInstance = nil;
    end;

    if u2.SelectionImageObject then
        u2.SelectionImageObject:Destroy();
    end;

    for _, v in u2._connections do
        v:Disconnect();
    end;
end;

function u1.Connect(p7, p8) -- Line: 159
    -- upvalues: u2 (copy)
    if u2._started == false then
        warn("Iris:Connect() was called before calling Iris.Init(); always initialise Iris first.");
    end;

    local u9 = #u2._connectedFunctions + 1;
    u2._connectedFunctions[u9] = p8;

    return function() -- Line: 165
        -- upvalues: u2 (ref), u9 (copy)
        u2._connectedFunctions[u9] = nil;
    end;
end;

function u1.Append(p10) -- Line: 180
    -- upvalues: u2 (copy)
    local v11 = u2._GetParentWidget();
    local v12;

    if u2._config.Parent then
        v12 = u2._config.Parent;
    else
        v12 = u2._widgets[v11.type].ChildAdded(v11, {
            type = "userInstance"
        });
    end;

    p10.Parent = v12;
end;

function u1.End() -- Line: 218
    -- upvalues: u2 (copy)
    if u2._stackIndex == 1 then
        error("Too many calls to Iris.End().", 2);
    end;

    u2._IDStack[u2._stackIndex] = nil;
    local v13 = u2;
    v13._stackIndex = v13._stackIndex - 1;
end;

function u1.ForceRefresh() -- Line: 243
    -- upvalues: u2 (copy)
    u2._globalRefreshRequested = true;
end;

function u1.UpdateGlobalConfig(p14) -- Line: 265
    -- upvalues: u2 (copy), u1 (copy)
    for i, v in p14 do
        u2._rootConfig[i] = v;
    end;

    u1.ForceRefresh();
end;

function u1.PushConfig(p15) -- Line: 290
    -- upvalues: u1 (copy), u2 (copy)
    local v16 = u1.State(-1);

    if v16.value == -1 then
        v16:set(p15);
    elseif u2._deepCompare(v16:get(), p15) == false then
        v16:set(p15);
        u2._refreshStack[u2._refreshLevel] = true;
        local v17 = u2;
        v17._refreshCounter = v17._refreshCounter + 1;
    end;

    local v18 = u2;
    v18._refreshLevel = v18._refreshLevel + 1;
    u2._config = setmetatable(p15, {
        __index = u2._config
    });
end;

function u1.PopConfig() -- Line: 318
    -- upvalues: u2 (copy)
    local v19 = u2;
    v19._refreshLevel = v19._refreshLevel - 1;

    if u2._refreshStack[u2._refreshLevel] == true then
        local v20 = u2;
        v20._refreshCounter = v20._refreshCounter - 1;
        u2._refreshStack[u2._refreshLevel] = nil;
    end;

    u2._config = getmetatable(u2._config).__index;
end;

u1.TemplateConfig = require(script.config);
u1.UpdateGlobalConfig(u1.TemplateConfig.colorDark);
u1.UpdateGlobalConfig(u1.TemplateConfig.sizeDefault);
u1.UpdateGlobalConfig(u1.TemplateConfig.utilityDefault);
u2._globalRefreshRequested = false;

function u1.PushId(p21) -- Line: 354
    -- upvalues: u2 (copy)
    local v22 = typeof(p21) == "string";
    assert(v22, "The ID argument to Iris.PushId() to be a string.");
    u2._newID = true;
    table.insert(u2._pushedIds, p21);
end;

function u1.PopId() -- Line: 367
    -- upvalues: u2 (copy)
    if #u2._pushedIds == 0 then
        return;
    end;

    table.remove(u2._pushedIds);
end;

function u1.SetNextWidgetID(p23) -- Line: 397
    -- upvalues: u2 (copy)
    u2._nextWidgetId = p23;
end;

function u1.State(p24) -- Line: 439
    -- upvalues: u2 (copy), u1 (copy)
    local v25 = u2._getID(2);

    if u2._states[v25] then
        return u2._states[v25];
    end;

    local v26 = {
        ID = v25,
        value = p24,
        lastChangeTick = u1.Internal._cycleTick,
        ConnectedWidgets = {},
        ConnectedFunctions = {}
    };
    setmetatable(v26, u2.StateClass);
    u2._states[v25] = v26;

    return v26;
end;

function u1.WeakState(p27) -- Line: 465
    -- upvalues: u2 (copy), u1 (copy)
    local v28 = u2._getID(2);

    if u2._states[v28] then
        if next(u2._states[v28].ConnectedWidgets) ~= nil then
            return u2._states[v28];
        end;

        u2._states[v28] = nil;
    end;

    local v29 = {
        ID = v28,
        value = p27,
        lastChangeTick = u1.Internal._cycleTick,
        ConnectedWidgets = {},
        ConnectedFunctions = {}
    };
    setmetatable(v29, u2.StateClass);
    u2._states[v28] = v29;

    return v29;
end;

function u1.VariableState(p30, p31) -- Line: 524
    -- upvalues: u2 (copy), u1 (copy)
    local v32 = u2._getID(2);
    local v33 = u2._states[v32];

    if v33 then
        if p30 ~= v33.value then
            v33:set(p30);
        end;

        return v33;
    end;

    local v34 = {
        ID = v32,
        value = p30,
        lastChangeTick = u1.Internal._cycleTick,
        ConnectedWidgets = {},
        ConnectedFunctions = {}
    };
    setmetatable(v34, u2.StateClass);
    u2._states[v32] = v34;
    v34:onChange(p31);

    return v34;
end;

function u1.TableState(u35, u36, u37) -- Line: 604
    -- upvalues: u2 (copy), u1 (copy)
    local v38 = u35[u36];
    local v39 = u2._getID(2);
    local v40 = u2._states[v39];

    if v40 then
        if v38 ~= v40.value then
            v40:set(v38);
        end;

        return v40;
    end;

    local u41 = {
        ID = v39,
        value = v38,
        lastChangeTick = u1.Internal._cycleTick,
        ConnectedWidgets = {},
        ConnectedFunctions = {}
    };
    setmetatable(u41, u2.StateClass);
    u2._states[v39] = u41;
    u41:onChange(function() -- Line: 628
        -- upvalues: u37 (copy), u41 (copy), u35 (copy), u36 (copy)
        if u37 == nil then
            u35[u36] = u41.value;
        elseif u37(u41.value) then
            u35[u36] = u41.value;
        end;
    end);

    return u41;
end;

function u1.ComputedState(p42, u43) -- Line: 657
    -- upvalues: u2 (copy), u1 (copy)
    local v44 = u2._getID(2);

    if u2._states[v44] then
        return u2._states[v44];
    end;

    local u45 = {
        ID = v44,
        value = u43(p42.value),
        lastChangeTick = u1.Internal._cycleTick,
        ConnectedWidgets = {},
        ConnectedFunctions = {}
    };
    setmetatable(u45, u2.StateClass);
    u2._states[v44] = u45;
    p42:onChange(function(p46) -- Line: 673
        -- upvalues: u45 (copy), u43 (copy)
        u45:set(u43(p46));
    end);

    return u45;
end;

u1.ShowDemoWindow = require(script.demoWindow)(u1);
require(script.widgets)(u2);
require(script.API)(u1);

return u1;