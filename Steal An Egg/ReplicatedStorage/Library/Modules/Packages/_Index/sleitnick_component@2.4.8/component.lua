-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local Promise = require(script.Parent.Promise);
local Signal = require(script.Parent.Signal);
local Symbol = require(script.Parent.Symbol);
local Trove = require(script.Parent.Trove);
local u1 = RunService:IsServer();
local u2 = { workspace, game:GetService("Players") };
local u3 = Symbol("Ancestors");
local u4 = Symbol("InstancesToComponents");
local u5 = Symbol("LockConstruct");
local u6 = Symbol("Components");
local u7 = Symbol("Trove");
local u8 = Symbol("Extensions");
local u9 = Symbol("ActiveExtensions");
local u10 = Symbol("Starting");
local u11 = Symbol("Started");
local u12 = 0;

local function NextRenderName() -- Line: 193
    -- upvalues: u12 (ref)
    u12 = u12 + 1;

    return "ComponentRender" .. tostring(u12);
end;

local function InvokeExtensionFn(p13, p14) -- Line: 198
    -- upvalues: u9 (copy)
    for _, v in ipairs(p13[u9]) do
        local v15 = v[p14];

        if type(v15) == "function" then
            v15(p13);
        end;
    end;
end;

local function ShouldConstruct(p16) -- Line: 207
    -- upvalues: u9 (copy)
    for _, v in ipairs(p16[u9]) do
        local ShouldConstruct = v.ShouldConstruct;

        if type(ShouldConstruct) == "function" and not ShouldConstruct(p16) then
            return false;
        end;
    end;

    return true;
end;

local function GetActiveExtensions(p17, p18) -- Line: 220
    local v19 = table.create(#p18);
    local v20 = true;

    for _, v in ipairs(p18) do
        local ShouldExtend = v.ShouldExtend;

        if type(ShouldExtend) ~= "function" and true or (ShouldExtend(p17) and true or false) then
            table.insert(v19, v);
        else
            v20 = false;
        end;
    end;

    if v20 then
        return p18;
    end;

    return v19;
end;

local u21 = {};
u21.__index = u21;

function u21.new(u22) -- Line: 299
    -- upvalues: u3 (copy), u2 (copy), u4 (copy), u6 (copy), u5 (copy), u7 (copy), Trove (copy), u8 (copy), u11 (copy), Signal (copy), u21 (copy)
    local v23 = {};
    v23.__index = v23;

    function v23.__tostring() -- Line: 302
        -- upvalues: u22 (copy)
        return "Component<" .. u22.Tag .. ">";
    end;

    v23[u3] = u22.Ancestors or u2;
    v23[u4] = {};
    v23[u6] = {};
    v23[u5] = {};
    v23[u7] = Trove.new();
    v23[u8] = u22.Extensions or {};
    v23[u11] = false;
    v23.Tag = u22.Tag;
    v23.Started = v23[u7]:Construct(Signal);
    v23.Stopped = v23[u7]:Construct(Signal);
    setmetatable(v23, u21);
    v23:_setup();

    return v23;
end;

function u21._instantiate(p24, p25) -- Line: 320
    -- upvalues: u9 (copy), GetActiveExtensions (copy), u8 (copy), ShouldConstruct (copy), InvokeExtensionFn (copy)
    local v26 = setmetatable({}, p24);
    v26.Instance = p25;
    v26[u9] = GetActiveExtensions(v26, p24[u8]);

    if not ShouldConstruct(v26) then
        return nil;
    end;

    InvokeExtensionFn(v26, "Constructing");

    if type(v26.Construct) == "function" then
        v26:Construct();
    end;

    InvokeExtensionFn(v26, "Constructed");

    return v26;
end;

function u21._setup(u27) -- Line: 335
    -- upvalues: u10 (copy), InvokeExtensionFn (copy), RunService (copy), u1 (copy), u12 (ref), u11 (copy), u5 (copy), u4 (copy), u6 (copy), u3 (copy), u7 (copy), CollectionService (copy)
    local u28 = {};

    local function StartComponent(u29) -- Line: 338
        -- upvalues: u10 (ref), InvokeExtensionFn (ref), RunService (ref), u1 (ref), u12 (ref), u11 (ref), u27 (copy)
        u29[u10] = coroutine.running();
        InvokeExtensionFn(u29, "Starting");
        u29:Start();

        if u29[u10] == nil then
            return;
        end;

        InvokeExtensionFn(u29, "Started");
        local v30 = typeof(u29.HeartbeatUpdate) == "function";
        local v31 = typeof(u29.SteppedUpdate) == "function";
        local v32 = typeof(u29.RenderSteppedUpdate) == "function";

        if v30 then
            u29._heartbeatUpdate = RunService.Heartbeat:Connect(function(p33) -- Line: 356
                -- upvalues: u29 (copy)
                u29:HeartbeatUpdate(p33);
            end);
        end;

        if v31 then
            u29._steppedUpdate = RunService.Stepped:Connect(function(p34, p35) -- Line: 362
                -- upvalues: u29 (copy)
                u29:SteppedUpdate(p35);
            end);
        end;

        if v32 and not u1 then
            if u29.RenderPriority then
                u12 = u12 + 1;
                u29._renderName = "ComponentRender" .. tostring(u12);
                RunService:BindToRenderStep(u29._renderName, u29.RenderPriority, function(p36) -- Line: 370
                    -- upvalues: u29 (copy)
                    u29:RenderSteppedUpdate(p36);
                end);
            else
                u29._renderSteppedUpdate = RunService.RenderStepped:Connect(function(p37) -- Line: 374
                    -- upvalues: u29 (copy)
                    u29:RenderSteppedUpdate(p37);
                end);
            end;
        end;

        u29[u11] = true;
        u29[u10] = nil;
        u27.Started:Fire(u29);
    end;

    local function StopComponent(p38) -- Line: 386
        -- upvalues: u10 (ref), RunService (ref), InvokeExtensionFn (ref), u27 (copy)
        if p38[u10] then
            local u39 = p38[u10];

            if coroutine.status(u39) == "normal" then
                task.defer(function() -- Line: 395
                    -- upvalues: u39 (copy)
                    pcall(function() -- Line: 396
                        -- upvalues: u39 (ref)
                        task.cancel(u39);
                    end);
                end);
            else
                pcall(function() -- Line: 391
                    -- upvalues: u39 (copy)
                    task.cancel(u39);
                end);
            end;

            p38[u10] = nil;
        end;

        if p38._heartbeatUpdate then
            p38._heartbeatUpdate:Disconnect();
        end;

        if p38._steppedUpdate then
            p38._steppedUpdate:Disconnect();
        end;

        if p38._renderSteppedUpdate then
            p38._renderSteppedUpdate:Disconnect();
        elseif p38._renderName then
            RunService:UnbindFromRenderStep(p38._renderName);
        end;

        InvokeExtensionFn(p38, "Stopping");
        p38:Stop();
        InvokeExtensionFn(p38, "Stopped");
        u27.Stopped:Fire(p38);
    end;

    local function SafeConstruct(p40, p41) -- Line: 424
        -- upvalues: u27 (copy), u5 (ref)
        if u27[u5][p40] ~= p41 then
            return nil;
        end;

        local v42 = u27:_instantiate(p40);

        if u27[u5][p40] == p41 then
            return v42;
        end;

        return nil;
    end;

    local function TryConstructComponent(u43) -- Line: 435
        -- upvalues: u27 (copy), u4 (ref), u5 (ref), u6 (ref), StartComponent (copy)
        if u27[u4][u43] then
            return;
        end;

        local u44 = (u27[u5][u43] or 0) + 1;
        u27[u5][u43] = u44;
        task.defer(function() -- Line: 442
            -- upvalues: u43 (copy), u44 (ref), u27 (ref), u5 (ref), u4 (ref), u6 (ref), StartComponent (ref)
            local v45 = u43;
            local v46 = u44;
            local u47;

            if u27[u5][v45] == v46 then
                u47 = u27:_instantiate(v45);

                if u27[u5][v45] ~= v46 then
                    u47 = nil;
                end;
            else
                u47 = nil;
            end;

            if not u47 then
                return;
            end;

            u27[u4][u43] = u47;
            table.insert(u27[u6], u47);
            task.defer(function() -- Line: 449
                -- upvalues: u27 (ref), u4 (ref), u43 (ref), u47 (copy), StartComponent (ref)
                if u27[u4][u43] == u47 then
                    StartComponent(u47);
                end;
            end);
        end);
    end;

    local function TryDeconstructComponent(p48) -- Line: 457
        -- upvalues: u27 (copy), u4 (ref), u5 (ref), u6 (ref), u11 (ref), u10 (ref), StopComponent (copy)
        local v49 = u27[u4][p48];

        if not v49 then
            return;
        end;

        u27[u4][p48] = nil;
        u27[u5][p48] = nil;
        local v50 = u27[u6];
        local v51 = table.find(v50, v49);

        if v51 then
            local v52 = #v50;
            v50[v51] = v50[v52];
            v50[v52] = nil;
        end;

        if v49[u11] or v49[u10] then
            task.spawn(StopComponent, v49);
        end;
    end;

    local function StartWatchingInstance(u53) -- Line: 476
        -- upvalues: u28 (copy), u27 (copy), u3 (ref), u7 (ref), u4 (ref), u5 (ref), u6 (ref), StartComponent (copy), TryDeconstructComponent (copy)
        if u28[u53] then
            return;
        end;

        local function IsInAncestorList() -- Line: 480
            -- upvalues: u27 (ref), u3 (ref), u53 (copy)
            for _, v in ipairs(u27[u3]) do
                if u53:IsDescendantOf(v) then
                    return true;
                end;
            end;

            return false;
        end;

        u28[u53] = u27[u7]:Connect(u53.AncestryChanged, function(p54, p55) -- Line: 488
            -- upvalues: u27 (ref), u3 (ref), u53 (copy), u4 (ref), u5 (ref), u6 (ref), StartComponent (ref), TryDeconstructComponent (ref)
            if p55 then
                local v56 = false;

                for _, v in ipairs(u27[u3]) do
                    if u53:IsDescendantOf(v) then
                        v56 = true;
                        break;
                    end;
                end;

                if v56 then
                    local u57 = u53;

                    if u27[u4][u57] then
                        return;
                    end;

                    local u58 = (u27[u5][u57] or 0) + 1;
                    u27[u5][u57] = u58;
                    task.defer(function() -- Line: 442
                        -- upvalues: u57 (copy), u58 (ref), u27 (ref), u5 (ref), u4 (ref), u6 (ref), StartComponent (ref)
                        local v59 = u57;
                        local v60 = u58;
                        local u61;

                        if u27[u5][v59] == v60 then
                            u61 = u27:_instantiate(v59);

                            if u27[u5][v59] ~= v60 then
                                u61 = nil;
                            end;
                        else
                            u61 = nil;
                        end;

                        if not u61 then
                            return;
                        end;

                        u27[u4][u57] = u61;
                        table.insert(u27[u6], u61);
                        task.defer(function() -- Line: 449
                            -- upvalues: u27 (ref), u4 (ref), u57 (ref), u61 (copy), StartComponent (ref)
                            if u27[u4][u57] == u61 then
                                StartComponent(u61);
                            end;
                        end);
                    end);

                    return;
                end;
            end;

            TryDeconstructComponent(u53);
        end);
        local v62 = false;

        for _, v in ipairs(u27[u3]) do
            if u53:IsDescendantOf(v) then
                v62 = true;
                break;
            end;
        end;

        if v62 then
            if u27[u4][u53] then
                return;
            end;

            local u63 = (u27[u5][u53] or 0) + 1;
            u27[u5][u53] = u63;
            task.defer(function() -- Line: 442
                -- upvalues: u53 (copy), u63 (ref), u27 (ref), u5 (ref), u4 (ref), u6 (ref), StartComponent (ref)
                local v64 = u53;
                local v65 = u63;
                local u66;

                if u27[u5][v64] == v65 then
                    u66 = u27:_instantiate(v64);

                    if u27[u5][v64] ~= v65 then
                        u66 = nil;
                    end;
                else
                    u66 = nil;
                end;

                if not u66 then
                    return;
                end;

                u27[u4][u53] = u66;
                table.insert(u27[u6], u66);
                task.defer(function() -- Line: 449
                    -- upvalues: u27 (ref), u4 (ref), u53 (ref), u66 (copy), StartComponent (ref)
                    if u27[u4][u53] == u66 then
                        StartComponent(u66);
                    end;
                end);
            end);
        end;
    end;

    local function InstanceTagged(p67) -- Line: 501
        -- upvalues: StartWatchingInstance (copy)
        StartWatchingInstance(p67);
    end;

    local function InstanceUntagged(p68) -- Line: 505
        -- upvalues: u28 (copy), u27 (copy), u7 (ref), TryDeconstructComponent (copy)
        local v69 = u28[p68];

        if v69 then
            u28[p68] = nil;
            u27[u7]:Remove(v69);
        end;

        TryDeconstructComponent(p68);
    end;

    u27[u7]:Connect(CollectionService:GetInstanceAddedSignal(u27.Tag), InstanceTagged);
    u27[u7]:Connect(CollectionService:GetInstanceRemovedSignal(u27.Tag), InstanceUntagged);
    local v70 = CollectionService:GetTagged(u27.Tag);

    for _, v in ipairs(v70) do
        task.defer(InstanceTagged, v);
    end;
end;

function u21.GetAll(p71) -- Line: 542
    -- upvalues: u6 (copy)
    return p71[u6];
end;

function u21.FromInstance(p72, p73) -- Line: 559
    -- upvalues: u4 (copy)
    return p72[u4][p73];
end;

function u21.WaitForInstance(p74, u75, p76) -- Line: 582
    -- upvalues: u11 (copy), Promise (copy)
    local u77 = p74:FromInstance(u75);

    if u77 and u77[u11] then
        return Promise.resolve(u77);
    end;

    return Promise.fromEvent(p74.Started, function(p78) -- Line: 587
        -- upvalues: u75 (copy), u77 (ref)
        local v79 = p78.Instance == u75;

        if v79 then
            u77 = p78;
        end;

        return v79;
    end):andThen(function() -- Line: 594
        -- upvalues: u77 (ref)
        return u77;
    end):timeout(type(p76) ~= "number" and 60 or p76);
end;

function u21.Construct(p80) -- Line: 614
end;

function u21.Start(p81) -- Line: 631
end;

function u21.Stop(p82) -- Line: 651
end;

function u21.GetComponent(p83, p84) -- Line: 670
    -- upvalues: u4 (copy)
    return p84[u4][p83.Instance];
end;

function u21.Destroy(p85) -- Line: 755
    -- upvalues: u7 (copy)
    p85[u7]:Destroy();
end;

return u21;