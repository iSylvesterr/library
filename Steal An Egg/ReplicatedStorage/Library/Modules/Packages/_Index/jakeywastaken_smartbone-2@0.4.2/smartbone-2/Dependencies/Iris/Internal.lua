-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);

return function(u1) -- Line: 3
    local u2 = {
        _started = false,
        _cycleTick = 0,
        _globalRefreshRequested = false,
        _localRefreshActive = false,
        _widgets = {},
        _widgetCount = 0,
        _stackIndex = 1,
        _rootInstance = nil
    };
    u2._rootWidget = {
        ID = "R",
        type = "Root",
        ZIndex = 0,
        Instance = u2._rootInstance
    };
    u2._lastWidget = u2._rootWidget;
    u2._rootConfig = {};
    u2._config = u2._rootConfig;
    u2._IDStack = { "R" };
    u2._usedIDs = {};
    u2._pushedId = nil;
    u2._nextWidgetId = nil;
    u2._states = {};
    u2._postCycleCallbacks = {};
    u2._connectedFunctions = {};
    u2._cycleCoroutine = coroutine.create(function() -- Line: 49
        -- upvalues: u2 (copy)
        while true do
            for _, v in u2._connectedFunctions do
                local success, result = pcall(v);

                if not success then
                    u2._stackIndex = 1;
                    coroutine.yield(false, result);
                end;

                if u2._stackIndex ~= 1 then
                    u2._stackIndex = 1;
                    error("Callback has too few calls to Iris.End()", 0);
                end;
            end;

            coroutine.yield(true);
        end;
    end);
    local v3 = {};
    v3.__index = v3;

    function v3.get(p4) -- Line: 82
        return p4.value;
    end;

    function v3.set(p5, p6) -- Line: 86
        -- upvalues: u2 (copy)
        if p6 == p5.value then
            return p5.value;
        end;

        p5.value = p6;

        for _, v in p5.ConnectedWidgets do
            u2._widgets[v.type].UpdateState(v);
        end;

        for _, v in p5.ConnectedFunctions do
            v(p6);
        end;

        return p5.value;
    end;

    function v3.onChange(p7, p8) -- Line: 101
        table.insert(p7.ConnectedFunctions, p8);
    end;

    u2.StateClass = v3;

    function u2._cycle() -- Line: 113
        -- upvalues: u1 (copy), u2 (copy)
        if u1.Disabled then
            return;
        end;

        u2._rootWidget.lastCycleTick = u2._cycleTick;

        if u2._rootInstance == nil or u2._rootInstance.Parent == nil then
            u1.ForceRefresh();
        end;

        for _, v in u2._lastVDOM do
            if v.lastCycleTick ~= u2._cycleTick then
                u2._DiscardWidget(v);
            end;
        end;

        u2._lastVDOM = u2._VDOM;
        u2._VDOM = u2._generateEmptyVDOM();
        task.spawn(function() -- Line: 137
            -- upvalues: u2 (ref)
            for _, v in u2._postCycleCallbacks do
                v();
            end;
        end);

        if u2._globalRefreshRequested then
            u2._generateSelectionImageObject();
            u2._globalRefreshRequested = false;

            for _, v in u2._lastVDOM do
                u2._DiscardWidget(v);
            end;

            u2._generateRootInstance();
            u2._lastVDOM = u2._generateEmptyVDOM();
        end;

        local v9 = u2;
        v9._cycleTick = v9._cycleTick + 1;
        u2._widgetCount = 0;
        table.clear(u2._usedIDs);

        if u2.parentInstance:IsA("GuiBase2d") and math.min(u2.parentInstance.AbsoluteSize.X, u2.parentInstance.AbsoluteSize.Y) < 100 then
            error("Iris Parent Instance is too small");
        end;

        if (u2.parentInstance:IsA("GuiBase2d") or u2.parentInstance:IsA("CoreGui") or (u2.parentInstance:IsA("PluginGui") or u2.parentInstance:IsA("PlayerGui"))) == false then
            error("Iris Parent Instance cant contain GUI");
        end;

        if game:GetService("RunService"):IsStudio() then
            for _, v in u2._connectedFunctions do
                v();
            end;

            return;
        end;

        local v10 = coroutine.status(u2._cycleCoroutine);

        if v10 == "suspended" then
            local _, v11, v12 = coroutine.resume(u2._cycleCoroutine);

            if v11 == false then
                error(v12, 0);
            end;
        else
            if v10 == "running" then
                error("Iris cycleCoroutine took to long to yield. Connected functions should not yield.");

                return;
            end;

            error("unrecoverable state");
        end;
    end;

    function u2._NoOp() -- Line: 208
    end;

    function u2.WidgetConstructor(p13, p14) -- Line: 212
        -- upvalues: u2 (copy), u1 (copy)
        local v15 = {
            All = {
                Required = { "Generate", "Discard", "Update", "Args", "Events", "hasChildren", "hasState" },
                Optional = {}
            },
            IfState = {
                Required = { "GenerateState", "UpdateState" },
                Optional = {}
            },
            IfChildren = {
                Required = { "ChildAdded" },
                Optional = { "ChildDiscarded" }
            }
        };
        local v16 = {};

        for _, v in v15.All.Required do
            local v17 = p14[v] ~= nil;
            local v18 = `field {v} is missing from widget {p13}, it is required for all widgets`;
            assert(v17, v18);
            v16[v] = p14[v];
        end;

        for _, v in v15.All.Optional do
            if p14[v] == nil then
                v16[v] = u2._NoOp;
            else
                v16[v] = p14[v];
            end;
        end;

        if p14.hasState then
            for _, v in v15.IfState.Required do
                local v19 = p14[v] ~= nil;
                local v20 = `field {v} is missing from widget {p13}, it is required for all widgets with state`;
                assert(v19, v20);
                v16[v] = p14[v];
            end;

            for _, v in v15.IfState.Optional do
                if p14[v] == nil then
                    v16[v] = u2._NoOp;
                else
                    v16[v] = p14[v];
                end;
            end;
        end;

        if p14.hasChildren then
            for _, v in v15.IfChildren.Required do
                local v21 = p14[v] ~= nil;
                local v22 = `field {v} is missing from widget {p13}, it is required for all widgets with children`;
                assert(v21, v22);
                v16[v] = p14[v];
            end;

            for _, v in v15.IfChildren.Optional do
                if p14[v] == nil then
                    v16[v] = u2._NoOp;
                else
                    v16[v] = p14[v];
                end;
            end;
        end;

        u2._widgets[p13] = v16;
        u1.Args[p13] = v16.Args;
        local v23 = {};

        for i, v in v16.Args do
            v23[v] = i;
        end;

        v16.ArgNames = v23;

        for i, _ in v16.Events do
            if u1.Events[i] == nil then
                u1.Events[i] = function() -- Line: 312
                    -- upvalues: u2 (ref), i (copy)
                    return u2._EventCall(u2._lastWidget, i);
                end;
            end;
        end;
    end;

    function u2._Insert(p24, p25, p26) -- Line: 319
        -- upvalues: u2 (copy)
        local v27 = nil;
        local v28 = u2._getID(3);
        local v29 = u2._widgets[p24];
        local v30 = u2;
        v30._widgetCount = v30._widgetCount + 1;

        if u2._VDOM[v28] then
            return u2._ContinueWidget(v28, p24);
        end;

        local v31 = {};

        if p25 ~= nil then
            for i, v in type(p25) ~= "table" and { p25 } or p25 do
                v31[v29.ArgNames[i]] = v;
            end;
        end;

        table.freeze(v31);

        if u2._lastVDOM[v28] and p24 == u2._lastVDOM[v28].type then
            if u2._localRefreshActive then
                u2._DiscardWidget(u2._lastVDOM[v28]);
            else
                v27 = u2._lastVDOM[v28];
            end;
        end;

        if v27 == nil then
            v27 = u2._GenNewWidget(p24, v31, p26, v28);
        end;

        if u2._deepCompare(v27.providedArguments, v31) == false then
            v27.arguments = u2._deepCopy(v31);
            v27.providedArguments = v31;
            v29.Update(v27);
        end;

        v27.lastCycleTick = u2._cycleTick;

        if v29.hasChildren then
            local v32 = u2;
            v32._stackIndex = v32._stackIndex + 1;
            u2._IDStack[u2._stackIndex] = v27.ID;
        end;

        u2._VDOM[v28] = v27;
        u2._lastWidget = v27;

        return v27;
    end;

    function u2._GenNewWidget(p33, p34, p35, p36) -- Line: 386
        -- upvalues: u2 (copy)
        local v37 = u2._IDStack[u2._stackIndex];
        local v38 = u2._widgets[p33];
        local u39 = {};
        setmetatable(u39, u39);
        u39.ID = p36;
        u39.type = p33;
        u39.parentWidget = u2._VDOM[v37];
        u39.trackedEvents = {};
        u39.ZIndex = u39.parentWidget.ZIndex + u2._widgetCount * 64 + u2._config.ZIndexOffset;
        u39.Instance = v38.Generate(u39);
        local Instance2 = u39.Instance;
        local v40;

        if u2._config.Parent then
            v40 = u2._config.Parent;
        else
            v40 = u2._widgets[u39.parentWidget.type].ChildAdded(u39.parentWidget, u39);
        end;

        Instance2.Parent = v40;
        u39.providedArguments = p34;
        u39.arguments = u2._deepCopy(p34);
        v38.Update(u39);
        local v41;

        if v38.hasState then
            if p35 then
                for i, v in p35 do
                    if type(v) ~= "table" or getmetatable(v) ~= u2.StateClass then
                        p35[i] = u2._widgetState(u39, i, v);
                    end;
                end;

                u39.state = p35;

                for _, v in p35 do
                    v.ConnectedWidgets[u39.ID] = u39;
                end;
            else
                u39.state = {};
            end;

            v38.GenerateState(u39);
            v38.UpdateState(u39);
            u39.stateMT = {};
            setmetatable(u39.state, u39.stateMT);
            u39.__index = u39.state;
            v41 = u39.stateMT;
        else
            v41 = u39;
        end;

        function v41.__index(p42, u43) -- Line: 450
            -- upvalues: u2 (ref), u39 (copy)
            return function() -- Line: 451
                -- upvalues: u2 (ref), u39 (ref), u43 (copy)
                return u2._EventCall(u39, u43);
            end;
        end;

        return u39;
    end;

    function u2._ContinueWidget(p44, p45) -- Line: 458
        -- upvalues: u2 (copy)
        local v46 = u2._VDOM[p44];

        if u2._widgets[p45].hasChildren then
            local v47 = u2;
            v47._stackIndex = v47._stackIndex + 1;
            u2._IDStack[u2._stackIndex] = v46.ID;
        end;

        u2._lastWidget = v46;

        return v46;
    end;

    function u2._DiscardWidget(p48) -- Line: 472
        -- upvalues: u2 (copy)
        local parentWidget = p48.parentWidget;

        if parentWidget then
            u2._widgets[parentWidget.type].ChildDiscarded(parentWidget, p48);
        end;

        u2._widgets[p48.type].Discard(p48);
    end;

    function u2._widgetState(p49, p50, p51) -- Line: 483
        -- upvalues: u2 (copy)
        local v52 = p49.ID .. p50;

        if u2._states[v52] then
            u2._states[v52].ConnectedWidgets[p49.ID] = p49;

            return u2._states[v52];
        end;

        u2._states[v52] = {
            value = p51,
            ConnectedWidgets = {
                [p49.ID] = p49
            },
            ConnectedFunctions = {}
        };
        setmetatable(u2._states[v52], u2.StateClass);

        return u2._states[v52];
    end;

    function u2._EventCall(p53, p54) -- Line: 499
        -- upvalues: u2 (copy)
        local v55 = u2._widgets[p53.type].Events[p54];
        local v56 = `widget {p53.type} has no event of name {p54}`;
        assert(v55 ~= nil, v56);

        if p53.trackedEvents[p54] == nil then
            v55.Init(p53);
            p53.trackedEvents[p54] = true;
        end;

        return v55.Get(p53);
    end;

    function u2._GetParentWidget() -- Line: 511
        -- upvalues: u2 (copy)
        return u2._VDOM[u2._IDStack[u2._stackIndex]];
    end;

    function u2._generateEmptyVDOM() -- Line: 517
        -- upvalues: u2 (copy)
        return {
            R = u2._rootWidget
        };
    end;

    function u2._generateRootInstance() -- Line: 523
        -- upvalues: u2 (copy)
        u2._rootInstance = u2._widgets.Root.Generate(u2._widgets.Root);
        u2._rootInstance.Parent = u2.parentInstance;
        u2._rootWidget.Instance = u2._rootInstance;
    end;

    function u2._generateSelectionImageObject() -- Line: 530
        -- upvalues: u2 (copy)
        if u2.SelectionImageObject then
            u2.SelectionImageObject:Destroy();
        end;

        local Frame = Instance.new("Frame");
        Frame.Position = UDim2.fromOffset(-1, -1);
        Frame.Size = UDim2.new(1, 2, 1, 2);
        Frame.BackgroundColor3 = u2._config.SelectionImageObjectColor;
        Frame.BackgroundTransparency = u2._config.SelectionImageObjectTransparency;
        Frame.BorderSizePixel = 0;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Thickness = 1;
        UIStroke.Color = u2._config.SelectionImageObjectBorderColor;
        UIStroke.Transparency = u2._config.SelectionImageObjectBorderTransparency;
        UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Parent = Frame;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 2);
        UICorner.Parent = Frame;
        u2.SelectionImageObject = Frame;
    end;

    function u2._getID(p57) -- Line: 561
        -- upvalues: u2 (copy)
        if u2._nextWidgetId then
            local _nextWidgetId = u2._nextWidgetId;
            u2._nextWidgetId = nil;

            return _nextWidgetId;
        end;

        local v58 = 1 + (p57 or 1);
        local v59 = debug.info(v58, "l");
        local v60 = "";

        while v59 ~= -1 and v59 ~= nil do
            v60 = v60 .. "+" .. v59;
            v58 = v58 + 1;
            v59 = debug.info(v58, "l");
        end;

        if u2._usedIDs[v60] then
            local _usedIDs = u2._usedIDs;
            _usedIDs[v60] = _usedIDs[v60] + 1;
        else
            u2._usedIDs[v60] = 1;
        end;

        local v61;

        if u2._pushedId then
            v61 = u2._pushedId;
        else
            v61 = u2._usedIDs[v60];
        end;

        return v60 .. ":" .. v61;
    end;

    function u2._deepCompare(p62, p63) -- Line: 588
        -- upvalues: u2 (copy)
        for i, v in p62 do
            local v64 = p63[i];

            if type(v) == "table" then
                if not v64 or type(v64) ~= "table" then
                    return false;
                end;

                if u2._deepCompare(v, v64) == false then
                    return false;
                end;
            elseif type(v) ~= type(v64) or v ~= v64 then
                return false;
            end;
        end;

        return true;
    end;

    function u2._deepCopy(p65) -- Line: 610
        -- upvalues: u2 (copy)
        local v66 = {};

        for i, v in pairs(p65) do
            if type(v) == "table" then
                local v = u2._deepCopy(v);
            end;

            v66[i] = v;
        end;

        return v66;
    end;

    u2._lastVDOM = u2._generateEmptyVDOM();
    u2._VDOM = u2._generateEmptyVDOM();
    u1.Internal = u2;
    u1._config = u2._config;

    return u2;
end;