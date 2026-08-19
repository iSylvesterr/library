-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local NetChannel = require(game.ReplicatedFirst.AllSideCode.ToolBasic.NetChannel);
local NetPipeConfig = require(game.ReplicatedFirst.AllSideCode.ToolBasic.NetPipeConfig);
local NetChannelMap = require(game.ReplicatedFirst.AllSideCode.ToolBasic.NetChannelMap);
local v1 = {};
local u2 = {
    RemoteEvent = "RemoteEvent",
    RemoteFunction = "RemoteFunction",
    BindableEvent = "Event",
    BindableFunction = "Function"
};
local u3 = { "RemoteEvent", "RemoteFunction", "BindableEvent", "BindableFunction" };
local u4 = RunService:IsServer();
local u5 = RunService:IsClient();
local u6 = RunService:IsStudio();
local u7 = false;
local u8 = {
    RemoteEvent = {},
    RemoteFunction = {},
    BindableEvent = {},
    BindableFunction = {}
};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = {};

local function _logWarn(...) -- Line: 137
    -- upvalues: UtilsSystem (copy)
    local Log = UtilsSystem.Log;

    if Log then
        Log.warn(...);
    end;
end;

local function _getMsgInstance(p16, p17) -- Line: 150
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:WaitForChild("Msg"):WaitForChild(p16):WaitForChild(p17);
end;

local function _handleMissingHandler(p18, p19) -- Line: 161
    -- upvalues: u6 (copy), _logWarn (copy)
    local v20 = string.format("[NetWork] 未注册 %s: %s", p19, (tostring(p18)));

    if u6 then
        error(v20);
    end;

    _logWarn(v20);
end;

local function _assertUnique(p21, p22, p23) -- Line: 175
    if p21[p22] ~= nil then
        error(string.format("[NetWork] 重复注册 %s: %s", p23, (tostring(p22))));
    end;
end;

local function _isValidInboundPlayer(p24) -- Line: 186
    local v25;

    if typeof(p24) == "Instance" then
        v25 = p24:IsA("Player") and p24.Parent ~= nil;
    else
        v25 = false;
    end;

    return v25;
end;

local function _extractMiddlewareData(p26, p27) -- Line: 196
    return p26[not (p27 and p27.middlewareDataIndex) and 1 or p27.middlewareDataIndex];
end;

local function _passServerRemoteMiddleware(p28, p29, p30, p31) -- Line: 212
    -- upvalues: UtilsSystem (copy)
    if p31 and (p31.skipRateLimit and p31.skipCheatDetection) then
        return true;
    end;

    local RequestRateLimit = UtilsSystem.RequestRateLimit;

    if not RequestRateLimit then
        return true;
    end;

    local v32;

    if p31 then
        v32 = p31.skipCheatDetection;
    else
        v32 = p31;
    end;

    if not v32 and RequestRateLimit.IsCheatDetectionEnabled(p29) then
        local v33 = RequestRateLimit.DetectDataAnomaly(p30);

        if v33 and RequestRateLimit.RecordCheatAndCheck(p28, p29, v33) then
            return false;
        end;

        if RequestRateLimit.DetectRequestPatternAnomaly(p28.UserId) and RequestRateLimit.RecordCheatAndCheck(p28, p29, "request_pattern_abnormal") then
            return false;
        end;
    end;

    return p31 and p31.skipRateLimit and true or RequestRateLimit.CheckRateLimit(p28, p29);
end;

local function _safeCall(p34, ...) -- Line: 251
    return pcall(p34, ...);
end;

local function _resolveChannelId(p35) -- Line: 260
    -- upvalues: NetChannelMap (copy), NetChannel (copy)
    return NetChannelMap[p35] or NetChannel.DEFAULT;
end;

local function _resolveRegisterChannelId(p36, p37) -- Line: 270
    -- upvalues: NetChannelMap (copy), NetChannel (copy)
    local v38 = NetChannelMap[p36];
    local v39 = p37 or (v38 or NetChannel.DEFAULT);

    if p37 and (v38 and p37 ~= v38) then
        error(string.format("[NetWork] Register channel 与 NetChannelMap 不一致: %s, options=%s, map=%s", tostring(p36), tostring(p37), (tostring(v38))));
    end;

    return v39;
end;

local function _loadAllPipeInstances() -- Line: 291
    -- upvalues: NetPipeConfig (copy), u8 (copy), u2 (copy), NetChannel (copy), ReplicatedStorage (copy), _logWarn (copy), u3 (copy)
    for i, v in NetPipeConfig.channels do
        for i2, v2 in v do
            if not u8[i2][i] then
                local v40 = u2[i2];
                local v41;

                if i == NetChannel.DEFAULT then
                    v41 = ReplicatedStorage:WaitForChild("Msg"):WaitForChild(v40):WaitForChild(v2);
                    u8[i2][i] = v41;
                end;

                v41 = ReplicatedStorage:WaitForChild("Msg"):WaitForChild(v40):FindFirstChild(v2);

                if v41 then
                    u8[i2][i] = v41;
                else
                    _logWarn("[NetWork] 可选 Channel 实例未找到，已跳过:", i, i2, v2);
                end;
            end;
        end;
    end;

    for _, v in u3 do
        if not u8[v][NetChannel.DEFAULT] then
            error(string.format("[NetWork] Default 通道缺少管道实例: %s", v));
        end;
    end;
end;

local function _resolvePipeInstance(p42, p43) -- Line: 335
    -- upvalues: NetChannelMap (copy), NetChannel (copy), u8 (copy), u6 (copy), _logWarn (copy)
    local v44 = NetChannelMap[p43] or NetChannel.DEFAULT;
    local v45 = u8[p42][v44];

    if v45 then
        return v45;
    end;

    if v44 ~= NetChannel.DEFAULT and u6 then
        _logWarn("[NetWork] Channel 缺少管道配置，已回落 Default:", v44, p42);
    end;

    return u8[p42][NetChannel.DEFAULT];
end;

local function _dispatchServerRemoteEvent(p46, p47, ...) -- Line: 355
    -- upvalues: u10 (copy), u6 (copy), _logWarn (copy), _passServerRemoteMiddleware (copy), _safeCall (copy)
    if p47 then
        local v48;

        if typeof(p46) == "Instance" then
            v48 = p46:IsA("Player") and p46.Parent ~= nil;
        else
            v48 = false;
        end;

        if v48 then
            local v49 = u10[p47];

            if not v49 then
                local v50 = string.format("[NetWork] 未注册 %s: %s", "ServerRemoteEvent", (tostring(p47)));

                if u6 then
                    error(v50);
                end;

                _logWarn(v50);

                return;
            end;

            local options = v49.options;

            if not _passServerRemoteMiddleware(p46, p47, ({ ... })[not (options and options.middlewareDataIndex) and 1 or options.middlewareDataIndex], v49.options) then
                return;
            end;

            local v51, v52 = _safeCall(v49.handler, p46, ...);

            if not v51 then
                _logWarn("[NetWork] ServerRemoteEvent 处理失败:", p47, v52);
            end;
        end;
    end;
end;

local function _dispatchServerRemoteFunction(p53, p54, ...) -- Line: 385
    -- upvalues: u12 (copy), u6 (copy), _logWarn (copy), _passServerRemoteMiddleware (copy), _safeCall (copy)
    if p54 then
        local v55;

        if typeof(p53) == "Instance" then
            v55 = p53:IsA("Player") and p53.Parent ~= nil;
        else
            v55 = false;
        end;

        if v55 then
            local v56 = u12[p54];

            if not v56 then
                local v57 = string.format("[NetWork] 未注册 %s: %s", "ServerRemoteFunction", (tostring(p54)));

                if u6 then
                    error(v57);
                end;

                _logWarn(v57);

                return nil;
            end;

            local options = v56.options;

            if not _passServerRemoteMiddleware(p53, p54, ({ ... })[not (options and options.middlewareDataIndex) and 1 or options.middlewareDataIndex], v56.options) then
                return nil;
            end;

            local v58, v59 = _safeCall(v56.handler, p53, ...);

            if v58 then
                return v59;
            end;

            _logWarn("[NetWork] ServerRemoteFunction 处理失败:", p54, v59);

            return nil;
        end;
    end;

    return nil;
end;

local function _dispatchClientRemoteEvent(p60, ...) -- Line: 415
    -- upvalues: u11 (copy), u15 (copy), _logWarn (copy), _safeCall (copy)
    if not p60 then
        return;
    end;

    local v61 = u11[p60];

    if v61 then
        local v62, v63 = _safeCall(v61, ...);

        if not v62 then
            _logWarn("[NetWork] ClientRemoteEvent 处理失败:", p60, v63);
        end;

        return;
    end;

    local v64 = u15[p60];

    if not v64 then
        v64 = {};
        u15[p60] = v64;
    end;

    if #v64 >= 32 then
        _logWarn("[NetWork] ClientRemoteEvent 待处理队列已满，丢弃:", p60);

        return;
    end;

    table.insert(v64, table.pack(...));
end;

local function _dispatchBindableEvent(p65, ...) -- Line: 446
    -- upvalues: u13 (copy), u6 (copy), _logWarn (copy), _safeCall (copy)
    if not p65 then
        return;
    end;

    local v66 = u13[p65];

    if v66 then
        local v67, v68 = _safeCall(v66, ...);

        if not v67 then
            _logWarn("[NetWork] BindableEvent 处理失败:", p65, v68);
        end;

        return;
    end;

    local v69 = string.format("[NetWork] 未注册 %s: %s", "BindableEvent", (tostring(p65)));

    if u6 then
        error(v69);
    end;

    _logWarn(v69);
end;

local function _dispatchBindableFunction(p70, ...) -- Line: 469
    -- upvalues: u14 (copy), u6 (copy), _logWarn (copy), _safeCall (copy)
    if not p70 then
        return nil;
    end;

    local v71 = u14[p70];

    if v71 then
        local v72, v73 = _safeCall(v71, ...);

        if v72 then
            return v73;
        end;

        _logWarn("[NetWork] BindableFunction 处理失败:", p70, v73);

        return nil;
    end;

    local v74 = string.format("[NetWork] 未注册 %s: %s", "BindableFunction", (tostring(p70)));

    if u6 then
        error(v74);
    end;

    _logWarn(v74);

    return nil;
end;

local function _bindRemoteEventInstance(p75) -- Line: 492
    -- upvalues: u9 (copy), u4 (copy), _dispatchServerRemoteEvent (copy), u5 (copy), _dispatchClientRemoteEvent (copy)
    if u9[p75] then
        return;
    end;

    u9[p75] = true;

    if u4 then
        p75.OnServerEvent:Connect(function(p76, p77, ...) -- Line: 499
            -- upvalues: _dispatchServerRemoteEvent (ref)
            _dispatchServerRemoteEvent(p76, p77, ...);
        end);
    end;

    if u5 then
        p75.OnClientEvent:Connect(function(p78, ...) -- Line: 505
            -- upvalues: _dispatchClientRemoteEvent (ref)
            _dispatchClientRemoteEvent(p78, ...);
        end);
    end;
end;

local function _bindRemoteFunctionInstance(p79) -- Line: 515
    -- upvalues: u9 (copy), u4 (copy), _dispatchServerRemoteFunction (copy), u5 (copy), u6 (copy), _logWarn (copy)
    if u9[p79] then
        return;
    end;

    u9[p79] = true;

    if u4 then
        function p79.OnServerInvoke(p80, p81, ...) -- Line: 522
            -- upvalues: _dispatchServerRemoteFunction (ref)
            return _dispatchServerRemoteFunction(p80, p81, ...);
        end;
    end;

    if u5 then
        function p79.OnClientInvoke(p82, ...) -- Line: 528
            -- upvalues: u6 (ref), _logWarn (ref)
            local v83 = string.format("[NetWork] 禁止服务端→客户端 RemoteFunction: %s（请改用 FireClient）", (tostring(p82)));

            if u6 then
                error(v83);
            end;

            _logWarn(v83);

            return nil;
        end;
    end;
end;

local function _bindBindableEventInstance(p84) -- Line: 546
    -- upvalues: u9 (copy), _dispatchBindableEvent (copy)
    if u9[p84] then
        return;
    end;

    u9[p84] = true;
    p84.Event:Connect(function(p85, ...) -- Line: 552
        -- upvalues: _dispatchBindableEvent (ref)
        _dispatchBindableEvent(p85, ...);
    end);
end;

local function _bindBindableFunctionInstance(p86) -- Line: 561
    -- upvalues: u9 (copy), _dispatchBindableFunction (copy)
    if u9[p86] then
        return;
    end;

    u9[p86] = true;

    function p86.OnInvoke(p87, ...) -- Line: 567
        -- upvalues: _dispatchBindableFunction (ref)
        return _dispatchBindableFunction(p87, ...);
    end;
end;

local function _bindAllPipeListeners() -- Line: 575
    -- upvalues: u8 (copy), _bindRemoteEventInstance (copy), u9 (copy), u4 (copy), _dispatchServerRemoteFunction (copy), u5 (copy), u6 (copy), _logWarn (copy), _dispatchBindableEvent (copy), _dispatchBindableFunction (copy)
    for _, v in u8.RemoteEvent do
        _bindRemoteEventInstance(v);
    end;

    for _, v in u8.RemoteFunction do
        if not u9[v] then
            u9[v] = true;

            if u4 then
                function v.OnServerInvoke(p88, p89, ...) -- Line: 522
                    -- upvalues: _dispatchServerRemoteFunction (ref)
                    return _dispatchServerRemoteFunction(p88, p89, ...);
                end;
            end;

            if u5 then
                function v.OnClientInvoke(p90, ...) -- Line: 528
                    -- upvalues: u6 (ref), _logWarn (ref)
                    local v91 = string.format("[NetWork] 禁止服务端→客户端 RemoteFunction: %s（请改用 FireClient）", (tostring(p90)));

                    if u6 then
                        error(v91);
                    end;

                    _logWarn(v91);

                    return nil;
                end;
            end;
        end;
    end;

    for _, v in u8.BindableEvent do
        if not u9[v] then
            u9[v] = true;
            v.Event:Connect(function(p92, ...) -- Line: 552
                -- upvalues: _dispatchBindableEvent (ref)
                _dispatchBindableEvent(p92, ...);
            end);
        end;
    end;

    for _, v in u8.BindableFunction do
        if not u9[v] then
            u9[v] = true;

            function v.OnInvoke(p93, ...) -- Line: 567
                -- upvalues: _dispatchBindableFunction (ref)
                return _dispatchBindableFunction(p93, ...);
            end;
        end;
    end;
end;

local function _ensureInitialized() -- Line: 593
    -- upvalues: u7 (ref), _loadAllPipeInstances (copy), _bindAllPipeListeners (copy)
    if u7 then
        return;
    end;

    u7 = true;
    _loadAllPipeInstances();
    _bindAllPipeListeners();
end;

function v1.RegisterServerRemoteEvent(p94, p95, p96) -- Line: 612
    -- upvalues: NetChannelMap (copy), NetChannel (copy), u10 (copy)
    local v97;

    if p96 then
        v97 = p96.channel;
    else
        v97 = p96;
    end;

    local v98 = NetChannelMap[p94];
    local v99 = v97 or (v98 or NetChannel.DEFAULT);

    if v97 and (v98 and v97 ~= v98) then
        error(string.format("[NetWork] Register channel 与 NetChannelMap 不一致: %s, options=%s, map=%s", tostring(p94), tostring(v97), (tostring(v98))));
    end;

    if u10[p94] ~= nil then
        error(string.format("[NetWork] 重复注册 %s: %s", "ServerRemoteEvent", (tostring(p94))));
    end;

    u10[p94] = {
        pipeKind = "RemoteEvent",
        handler = p95,
        options = p96,
        channelId = v99
    };
end;

function v1.RegisterClientRemoteEvent(p100, p101) -- Line: 632
    -- upvalues: u11 (copy), u15 (copy), _safeCall (copy), _logWarn (copy)
    if u11[p100] ~= nil then
        error(string.format("[NetWork] 重复注册 %s: %s", "ClientRemoteEvent", (tostring(p100))));
    end;

    u11[p100] = p101;
    local v102 = u15[p100];

    if not v102 then
        return;
    end;

    u15[p100] = nil;

    for _, v in ipairs(v102) do
        local v103, v104 = _safeCall(p101, table.unpack(v, 1, v.n));

        if not v103 then
            _logWarn("[NetWork] ClientRemoteEvent 回放失败:", p100, v104);
        end;
    end;
end;

function v1.RegisterServerRemoteFunction(p105, p106, p107) -- Line: 655
    -- upvalues: NetChannelMap (copy), NetChannel (copy), u12 (copy)
    local v108;

    if p107 then
        v108 = p107.channel;
    else
        v108 = p107;
    end;

    local v109 = NetChannelMap[p105];
    local v110 = v108 or (v109 or NetChannel.DEFAULT);

    if v108 and (v109 and v108 ~= v109) then
        error(string.format("[NetWork] Register channel 与 NetChannelMap 不一致: %s, options=%s, map=%s", tostring(p105), tostring(v108), (tostring(v109))));
    end;

    if u12[p105] ~= nil then
        error(string.format("[NetWork] 重复注册 %s: %s", "ServerRemoteFunction", (tostring(p105))));
    end;

    u12[p105] = {
        pipeKind = "RemoteFunction",
        handler = p106,
        options = p107,
        channelId = v110
    };
end;

function v1.RegisterBindableEvent(p111, p112, p113) -- Line: 676
    -- upvalues: NetChannelMap (copy), NetChannel (copy), u13 (copy)
    if p113 then
        p113 = p113.channel;
    end;

    local v114 = NetChannelMap[p111];

    if not (p113 or v114) then
        local _ = NetChannel.DEFAULT;
    end;

    if p113 and (v114 and p113 ~= v114) then
        error(string.format("[NetWork] Register channel 与 NetChannelMap 不一致: %s, options=%s, map=%s", tostring(p111), tostring(p113), (tostring(v114))));
    end;

    if u13[p111] ~= nil then
        error(string.format("[NetWork] 重复注册 %s: %s", "BindableEvent", (tostring(p111))));
    end;

    u13[p111] = p112;
end;

function v1.RegisterBindableFunction(p115, p116, p117) -- Line: 692
    -- upvalues: NetChannelMap (copy), NetChannel (copy), u14 (copy)
    if p117 then
        p117 = p117.channel;
    end;

    local v118 = NetChannelMap[p115];

    if not (p117 or v118) then
        local _ = NetChannel.DEFAULT;
    end;

    if p117 and (v118 and p117 ~= v118) then
        error(string.format("[NetWork] Register channel 与 NetChannelMap 不一致: %s, options=%s, map=%s", tostring(p115), tostring(p117), (tostring(v118))));
    end;

    if u14[p115] ~= nil then
        error(string.format("[NetWork] 重复注册 %s: %s", "BindableFunction", (tostring(p115))));
    end;

    u14[p115] = p116;
end;

function v1.FireServer(p119, ...) -- Line: 711
    -- upvalues: u5 (copy), u7 (ref), _loadAllPipeInstances (copy), _bindAllPipeListeners (copy), NetChannelMap (copy), NetChannel (copy), u8 (copy), u6 (copy), _logWarn (copy)
    if not u5 then
        error("[NetWork] FireServer 仅客户端可用");
    end;

    if not u7 then
        u7 = true;
        _loadAllPipeInstances();
        _bindAllPipeListeners();
    end;

    local v120 = NetChannelMap[p119] or NetChannel.DEFAULT;
    local v121 = u8.RemoteEvent[v120];

    if not v121 then
        if v120 ~= NetChannel.DEFAULT and u6 then
            _logWarn("[NetWork] Channel 缺少管道配置，已回落 Default:", v120, "RemoteEvent");
        end;

        v121 = u8.RemoteEvent[NetChannel.DEFAULT];
    end;

    v121:FireServer(p119, ...);
end;

function v1.FireClient(p122, p123, ...) -- Line: 726
    -- upvalues: u4 (copy), u7 (ref), _loadAllPipeInstances (copy), _bindAllPipeListeners (copy), NetChannelMap (copy), NetChannel (copy), u8 (copy), u6 (copy), _logWarn (copy)
    if not u4 then
        error("[NetWork] FireClient 仅服务端可用");
    end;

    if not u7 then
        u7 = true;
        _loadAllPipeInstances();
        _bindAllPipeListeners();
    end;

    local v124 = NetChannelMap[p123] or NetChannel.DEFAULT;
    local v125 = u8.RemoteEvent[v124];

    if not v125 then
        if v124 ~= NetChannel.DEFAULT and u6 then
            _logWarn("[NetWork] Channel 缺少管道配置，已回落 Default:", v124, "RemoteEvent");
        end;

        v125 = u8.RemoteEvent[NetChannel.DEFAULT];
    end;

    v125:FireClient(p122, p123, ...);
end;

function v1.FireAllClients(p126, ...) -- Line: 740
    -- upvalues: u4 (copy), u7 (ref), _loadAllPipeInstances (copy), _bindAllPipeListeners (copy), NetChannelMap (copy), NetChannel (copy), u8 (copy), u6 (copy), _logWarn (copy)
    if not u4 then
        error("[NetWork] FireAllClients 仅服务端可用");
    end;

    if not u7 then
        u7 = true;
        _loadAllPipeInstances();
        _bindAllPipeListeners();
    end;

    local v127 = NetChannelMap[p126] or NetChannel.DEFAULT;
    local v128 = u8.RemoteEvent[v127];

    if not v128 then
        if v127 ~= NetChannel.DEFAULT and u6 then
            _logWarn("[NetWork] Channel 缺少管道配置，已回落 Default:", v127, "RemoteEvent");
        end;

        v128 = u8.RemoteEvent[NetChannel.DEFAULT];
    end;

    v128:FireAllClients(p126, ...);
end;

function v1.InvokeServer(p129, ...) -- Line: 755
    -- upvalues: u5 (copy), u7 (ref), _loadAllPipeInstances (copy), _bindAllPipeListeners (copy), NetChannelMap (copy), NetChannel (copy), u8 (copy), u6 (copy), _logWarn (copy)
    if not u5 then
        error("[NetWork] InvokeServer 仅客户端可用");
    end;

    if not u7 then
        u7 = true;
        _loadAllPipeInstances();
        _bindAllPipeListeners();
    end;

    local v130 = NetChannelMap[p129] or NetChannel.DEFAULT;
    local v131 = u8.RemoteFunction[v130];

    if not v131 then
        if v130 ~= NetChannel.DEFAULT and u6 then
            _logWarn("[NetWork] Channel 缺少管道配置，已回落 Default:", v130, "RemoteFunction");
        end;

        v131 = u8.RemoteFunction[NetChannel.DEFAULT];
    end;

    return v131:InvokeServer(p129, ...);
end;

function v1.FireBindable(p132, ...) -- Line: 769
    -- upvalues: u7 (ref), _loadAllPipeInstances (copy), _bindAllPipeListeners (copy), NetChannelMap (copy), NetChannel (copy), u8 (copy), u6 (copy), _logWarn (copy)
    if not u7 then
        u7 = true;
        _loadAllPipeInstances();
        _bindAllPipeListeners();
    end;

    local v133 = NetChannelMap[p132] or NetChannel.DEFAULT;
    local v134 = u8.BindableEvent[v133];

    if not v134 then
        if v133 ~= NetChannel.DEFAULT and u6 then
            _logWarn("[NetWork] Channel 缺少管道配置，已回落 Default:", v133, "BindableEvent");
        end;

        v134 = u8.BindableEvent[NetChannel.DEFAULT];
    end;

    v134:Fire(p132, ...);
end;

function v1.InvokeBindable(p135, ...) -- Line: 781
    -- upvalues: u7 (ref), _loadAllPipeInstances (copy), _bindAllPipeListeners (copy), NetChannelMap (copy), NetChannel (copy), u8 (copy), u6 (copy), _logWarn (copy)
    if not u7 then
        u7 = true;
        _loadAllPipeInstances();
        _bindAllPipeListeners();
    end;

    local v136 = NetChannelMap[p135] or NetChannel.DEFAULT;
    local v137 = u8.BindableFunction[v136];

    if not v137 then
        if v136 ~= NetChannel.DEFAULT and u6 then
            _logWarn("[NetWork] Channel 缺少管道配置，已回落 Default:", v136, "BindableFunction");
        end;

        v137 = u8.BindableFunction[NetChannel.DEFAULT];
    end;

    return v137:Invoke(p135, ...);
end;

function v1.Init() -- Line: 794
    -- upvalues: u7 (ref), _loadAllPipeInstances (copy), _bindAllPipeListeners (copy)
    if u7 then
        return;
    end;

    u7 = true;
    _loadAllPipeInstances();
    _bindAllPipeListeners();
end;

v1.NetMsg = NetMsg;

return v1;