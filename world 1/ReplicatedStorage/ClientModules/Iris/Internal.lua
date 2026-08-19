-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);

return function(u1) -- Line: 3
    local u2 = {
        _version = " 2.5.1 ",
        _started = false,
        _shutdown = false,
        _cycleTick = 0,
        _deltaTime = 0,
        _globalRefreshRequested = false,
        _refreshCounter = 0,
        _refreshLevel = 1,
        _refreshStack = table.create(16),
        _widgets = {},
        _stackIndex = 1,
        _rootInstance = nil
    };
    u2._rootWidget = {
        ID = "R",
        type = "Root",
        ZIndex = 0,
        ZOffset = 0,
        Instance = u2._rootInstance
    };
    u2._lastWidget = u2._rootWidget;
    u2._rootConfig = {};
    u2._config = u2._rootConfig;
    u2._IDStack = { "R" };
    u2._usedIDs = {};
    u2._pushedIds = {};
    u2._newID = false;
    u2._nextWidgetId = nil;
    u2._states = {};
    u2._postCycleCallbacks = {};
    u2._connectedFunctions = {};
    u2._connections = {};
    u2._initFunctions = {};
    u2._fullErrorTracebacks = game:GetService("RunService"):IsStudio();
    u2._cycleCoroutine = coroutine.create(function() -- Line: 73
        -- upvalues: u2 (copy)
        while u2._started do
            for _, v in u2._connectedFunctions do
                debug.profilebegin("Iris/Connection");
                local success, result = pcall(v);
                debug.profileend();

                if not success then
                    u2._stackIndex = 1;
                    coroutine.yield(false, result);
                end;
            end;

            coroutine.yield(true);
        end;
    end);
    local v3 = {};
    v3.__index = v3;

    function v3.get(p4) -- Line: 131
        return p4.value;
    end;

    function v3.set(p5, p6, p7) -- Line: 144
        -- upvalues: u1 (copy), u2 (copy)
        if p6 == p5.value and p7 ~= true then
            return p5.value;
        end;

        p5.value = p6;
        p5.lastChangeTick = u1.Internal._cycleTick;

        for _, v in p5.ConnectedWidgets do
            if v.lastCycleTick ~= -1 then
                u2._widgets[v.type].UpdateState(v);
            end;
        end;

        for _, v in p5.ConnectedFunctions do
            v(p6);
        end;

        return p5.value;
    end;

    function v3.onChange(u8, p9) -- Line: 176
        local u10 = #u8.ConnectedFunctions + 1;
        u8.ConnectedFunctions[u10] = p9;

        return function() -- Line: 179
            -- upvalues: u8 (copy), u10 (copy)
            u8.ConnectedFunctions[u10] = nil;
        end;
    end;

    function v3.changed(p11) -- Line: 191
        -- upvalues: u2 (copy)
        return p11.lastChangeTick + 1 == u2._cycleTick;
    end;

    u2.StateClass = v3;

    function u2._cycle(p12) -- Line: 209
        -- upvalues: u1 (copy), u2 (copy)
        if u1.Disabled then
            return;
        end;

        u2._rootWidget.lastCycleTick = u2._cycleTick;

        if u2._rootInstance == nil or u2._rootInstance.Parent == nil then
            u1.ForceRefresh();
        end;

        for _, v in u2._lastVDOM do
            if v.lastCycleTick ~= u2._cycleTick and v.lastCycleTick ~= -1 then
                u2._DiscardWidget(v);
            end;
        end;

        setmetatable(u2._lastVDOM, {
            __mode = "kv"
        });
        u2._lastVDOM = u2._VDOM;
        u2._VDOM = u2._generateEmptyVDOM();
        task.spawn(function() -- Line: 235
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

        local v13 = u2;
        v13._cycleTick = v13._cycleTick + 1;
        u2._deltaTime = p12;
        table.clear(u2._usedIDs);

        if (u2.parentInstance:IsA("GuiBase2d") or u2.parentInstance:IsA("BasePlayerGui")) == false then
            error("The Iris parent instance will not display any GUIs.");
        end;

        if u2._fullErrorTracebacks then
            for _, v in u2._connectedFunctions do
                v();
            end;
        else
            local v14 = coroutine.status(u2._cycleCoroutine);

            if v14 == "suspended" then
                local _, v15, v16 = coroutine.resume(u2._cycleCoroutine);

                if v15 == false then
                    error(v16, 0);
                end;
            elseif v14 == "running" then
                error("Iris cycleCoroutine took to long to yield. Connected functions should not yield.");
            else
                error("unrecoverable state");
            end;
        end;

        if u2._stackIndex ~= 1 then
            u2._stackIndex = 1;
            error("Too few calls to Iris.End().", 0);
        end;

        if #u2._pushedIds ~= 0 then
            error("Too few calls to Iris.PopId().", 0);
        end;
    end;

    function u2._NoOp() -- Line: 322
    end;

    function u2.WidgetConstructor(p17, p18) -- Line: 336
        -- upvalues: u2 (copy), u1 (copy)
        local v19 = {
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
        local v20 = {};

        for _, v in v19.All.Required do
            local v21 = p18[v] ~= nil;
            local v22 = `field {v} is missing from widget {p17}, it is required for all widgets`;
            assert(v21, v22);
            v20[v] = p18[v];
        end;

        for _, v in v19.All.Optional do
            if p18[v] == nil then
                v20[v] = u2._NoOp;
            else
                v20[v] = p18[v];
            end;
        end;

        if p18.hasState then
            for _, v in v19.IfState.Required do
                local v23 = p18[v] ~= nil;
                local v24 = `field {v} is missing from widget {p17}, it is required for all widgets with state`;
                assert(v23, v24);
                v20[v] = p18[v];
            end;

            for _, v in v19.IfState.Optional do
                if p18[v] == nil then
                    v20[v] = u2._NoOp;
                else
                    v20[v] = p18[v];
                end;
            end;
        end;

        if p18.hasChildren then
            for _, v in v19.IfChildren.Required do
                local v25 = p18[v] ~= nil;
                local v26 = `field {v} is missing from widget {p17}, it is required for all widgets with children`;
                assert(v25, v26);
                v20[v] = p18[v];
            end;

            for _, v in v19.IfChildren.Optional do
                if p18[v] == nil then
                    v20[v] = u2._NoOp;
                else
                    v20[v] = p18[v];
                end;
            end;
        end;

        u2._widgets[p17] = v20;
        u1.Args[p17] = v20.Args;
        local v27 = {};

        for i, v in v20.Args do
            v27[v] = i;
        end;

        v20.ArgNames = v27;

        for i, _ in v20.Events do
            if u1.Events[i] == nil then
                u1.Events[i] = function() -- Line: 427
                    -- upvalues: u2 (ref), i (copy)
                    return u2._EventCall(u2._lastWidget, i);
                end;
            end;
        end;
    end;

    function u2._Insert(p28, p29, p30) -- Line: 445
        -- upvalues: u2 (copy)
        local v31 = u2._getID(3);
        local v32 = u2._widgets[p28];

        if u2._VDOM[v31] then
            return u2._ContinueWidget(v31, p28);
        end;

        local v33 = {};

        if p29 ~= nil then
            for i, v in type(p29) ~= "table" and { p29 } or p29 do
                local v34 = `Widget Arguments must be a positive number, not {i} of type {typeof(i)} for {v}.`;
                assert(i > 0, v34);
                v33[v32.ArgNames[i]] = v;
            end;
        end;

        table.freeze(v33);
        local v35 = u2._lastVDOM[v31];

        if v35 and (p28 == v35.type and u2._refreshCounter > 0) then
            u2._DiscardWidget(v35);
            v35 = nil;
        end;

        if v35 == nil then
            v35 = u2._GenNewWidget(p28, v33, p30, v31);
        end;

        local parentWidget = v35.parentWidget;

        if v35.type ~= "Window" and v35.type ~= "Tooltip" then
            if v35.ZIndex ~= parentWidget.ZOffset then
                parentWidget.ZUpdate = true;
            end;

            if parentWidget.ZUpdate then
                v35.ZIndex = parentWidget.ZOffset;

                if v35.Instance then
                    v35.Instance.ZIndex = v35.ZIndex;
                    v35.Instance.LayoutOrder = v35.ZIndex;
                end;
            end;
        end;

        if parentWidget.type == "Table" then
            parentWidget._rowCycles[parentWidget._rowIndex] = u2._cycleTick;
        end;

        if u2._deepCompare(v35.providedArguments, v33) == false then
            v35.arguments = u2._deepCopy(v33);
            v35.providedArguments = v33;
            v32.Update(v35);
        end;

        v35.lastCycleTick = u2._cycleTick;
        parentWidget.ZOffset = parentWidget.ZOffset + 1;

        if v32.hasChildren then
            v35.ZOffset = 0;
            v35.ZUpdate = false;
            local v36 = u2;
            v36._stackIndex = v36._stackIndex + 1;
            u2._IDStack[u2._stackIndex] = v35.ID;
        end;

        u2._VDOM[v31] = v35;
        u2._lastWidget = v35;

        return v35;
    end;

    function u2._GenNewWidget(p37, p38, p39, p40) -- Line: 546
        -- upvalues: u2 (copy)
        local v41 = u2._VDOM[u2._IDStack[u2._stackIndex]];
        local v42 = u2._widgets[p37];
        local u43 = {};
        setmetatable(u43, u43);
        u43.ID = p40;
        u43.type = p37;
        u43.parentWidget = v41;
        u43.trackedEvents = {};
        u43.ZIndex = v41.ZOffset;
        u43.Instance = v42.Generate(u43);
        local parentWidget = u43.parentWidget;

        if u2._config.Parent then
            u43.Instance.Parent = u2._config.Parent;
        else
            u43.Instance.Parent = u2._widgets[parentWidget.type].ChildAdded(parentWidget, u43);
        end;

        u43.providedArguments = p38;
        u43.arguments = u2._deepCopy(p38);
        v42.Update(u43);
        local v44;

        if v42.hasState then
            if p39 then
                for i, v in p39 do
                    if type(v) ~= "table" or getmetatable(v) ~= u2.StateClass then
                        p39[i] = u2._widgetState(u43, i, v);
                    end;

                    p39[i].lastChangeTick = u2._cycleTick;
                end;

                u43.state = p39;

                for _, v in p39 do
                    v.ConnectedWidgets[u43.ID] = u43;
                end;
            else
                u43.state = {};
            end;

            v42.GenerateState(u43);
            v42.UpdateState(u43);
            u43.stateMT = {};
            setmetatable(u43.state, u43.stateMT);
            u43.__index = u43.state;
            v44 = u43.stateMT;
        else
            v44 = u43;
        end;

        function v44.__index(p45, u46) -- Line: 612
            -- upvalues: u2 (ref), u43 (copy)
            return function() -- Line: 613
                -- upvalues: u2 (ref), u43 (ref), u46 (copy)
                return u2._EventCall(u43, u46);
            end;
        end;

        return u43;
    end;

    function u2._ContinueWidget(p47, p48) -- Line: 631
        -- upvalues: u2 (copy)
        local v49 = u2._VDOM[p47];

        if u2._widgets[p48].hasChildren then
            local v50 = u2;
            v50._stackIndex = v50._stackIndex + 1;
            u2._IDStack[u2._stackIndex] = v49.ID;
        end;

        u2._lastWidget = v49;

        return v49;
    end;

    function u2._DiscardWidget(p51) -- Line: 654
        -- upvalues: u2 (copy)
        local parentWidget = p51.parentWidget;

        if parentWidget then
            u2._widgets[parentWidget.type].ChildDiscarded(parentWidget, p51);
        end;

        u2._widgets[p51.type].Discard(p51);
        p51.lastCycleTick = -1;
    end;

    function u2._widgetState(p52, p53, p54) -- Line: 679
        -- upvalues: u2 (copy)
        local v55 = p52.ID .. p53;

        if u2._states[v55] then
            u2._states[v55].ConnectedWidgets[p52.ID] = p52;
            u2._states[v55].lastChangeTick = u2._cycleTick;

            return u2._states[v55];
        end;

        local v56 = {
            ID = v55,
            value = p54,
            lastChangeTick = u2._cycleTick,
            ConnectedWidgets = {
                [p52.ID] = p52
            },
            ConnectedFunctions = {}
        };
        setmetatable(v56, u2.StateClass);
        u2._states[v55] = v56;

        return v56;
    end;

    function u2._EventCall(p57, p58) -- Line: 709
        -- upvalues: u2 (copy)
        local v59 = u2._widgets[p57.type].Events[p58];
        local v60 = `widget {p57.type} has no event of name {p58}`;
        assert(v59 ~= nil, v60);

        if p57.trackedEvents[p58] == nil then
            v59.Init(p57);
            p57.trackedEvents[p58] = true;
        end;

        return v59.Get(p57);
    end;

    function u2._GetParentWidget() -- Line: 728
        -- upvalues: u2 (copy)
        return u2._VDOM[u2._IDStack[u2._stackIndex]];
    end;

    function u2._generateEmptyVDOM() -- Line: 742
        -- upvalues: u2 (copy)
        return {
            R = u2._rootWidget
        };
    end;

    function u2._generateRootInstance() -- Line: 755
        -- upvalues: u2 (copy)
        u2._rootInstance = u2._widgets.Root.Generate(u2._widgets.Root);
        u2._rootInstance.Parent = u2.parentInstance;
        u2._rootWidget.Instance = u2._rootInstance;
    end;

    function u2._generateSelectionImageObject() -- Line: 769
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
        u2._utility.UIStroke(Frame, 1, u2._config.SelectionImageObjectBorderColor, u2._config.SelectionImageObjectBorderTransparency);
        u2._utility.UICorner(Frame, 2);
        u2.SelectionImageObject = Frame;
    end;

    function u2._getID(p61) -- Line: 799
        -- upvalues: u2 (copy)
        if u2._nextWidgetId then
            local _nextWidgetId = u2._nextWidgetId;
            u2._nextWidgetId = nil;

            return _nextWidgetId;
        end;

        local v62 = 1 + (p61 or 1);
        local v63 = debug.info(v62, "l");
        local v64 = "";

        while v63 ~= -1 and v63 ~= nil do
            v64 = v64 .. "+" .. v63;
            v62 = v62 + 1;
            v63 = debug.info(v62, "l");
        end;

        local v65 = u2._usedIDs[v64];
        local v66;

        if v65 then
            local _usedIDs = u2._usedIDs;
            _usedIDs[v64] = _usedIDs[v64] + 1;
            v66 = v65 + 1;
        else
            u2._usedIDs[v64] = 1;
            v66 = 1;
        end;

        if #u2._pushedIds == 0 then
            return v64 .. ":" .. v66;
        end;

        if not u2._newID then
            return v64 .. ":" .. v66 .. ":" .. table.concat(u2._pushedIds, "\\");
        end;

        u2._newID = false;

        return v64 .. "::" .. table.concat(u2._pushedIds, "\\");
    end;

    function u2._deepCompare(p67, p68) -- Line: 846
        -- upvalues: u2 (copy)
        for i, v in p67 do
            local v69 = p68[i];

            if type(v) == "table" then
                if not v69 or type(v69) ~= "table" then
                    return false;
                end;

                if u2._deepCompare(v, v69) == false then
                    return false;
                end;
            elseif type(v) ~= type(v69) or v ~= v69 then
                return false;
            end;
        end;

        return true;
    end;

    function u2._deepCopy(p70) -- Line: 877
        -- upvalues: u2 (copy)
        local v71 = table.clone(p70);

        for i, v in p70 do
            if type(v) == "table" then
                v71[i] = u2._deepCopy(v);
            end;
        end;

        return v71;
    end;

    u2._lastVDOM = u2._generateEmptyVDOM();
    u2._VDOM = u2._generateEmptyVDOM();
    u1.Internal = u2;
    u1._config = u2._config;

    return u2;
end;