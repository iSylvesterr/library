-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local u2 = RunService:IsServer();
local u3 = {};

local function logPacket(p4, p5, u6, p7) -- Line: 64
    -- upvalues: DebugFlags (copy), HttpService (copy), u2 (copy)
    if not DebugFlags.IsEnabled("NetworkPackets") then
        return;
    end;

    local success, result = pcall(function() -- Line: 69
        -- upvalues: HttpService (ref), u6 (copy)
        return HttpService:JSONEncode(u6);
    end);
    local v8 = not success and "unknown" or string.format("%.3f KB", #result / 1024);
    local v9 = not p7 and "" or ` | Player: {p7.Name}`;
    print(string.format("%s %s %s | Size: %s%s | Data: %s", u2 and "[SERVER]" or "[CLIENT]", p4, p5, v8, v9, not success and "{}" or result));
end;

local function getPlayersInRange(p10, p11) -- Line: 89
    -- upvalues: Players (copy)
    local v12 = {};

    for _, v in ipairs(Players:GetPlayers()) do
        local Character = v.Character;
        local v13;

        if Character then
            v13 = Character:FindFirstChild("HumanoidRootPart");
        else
            v13 = nil;
        end;

        if v13 and (v13:IsA("BasePart") and (v13.Position - p10).Magnitude <= p11) then
            table.insert(v12, v);
        end;
    end;

    return v12;
end;

local function getRootFolder() -- Line: 106
    -- upvalues: ReplicatedStorage (copy), u2 (copy)
    local NetworkRemotes = ReplicatedStorage:FindFirstChild("NetworkRemotes");

    if NetworkRemotes and NetworkRemotes:IsA("Folder") then
        return NetworkRemotes;
    end;

    if not u2 then
        return ReplicatedStorage:WaitForChild("NetworkRemotes");
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "NetworkRemotes";
    Folder.Parent = ReplicatedStorage;

    return Folder;
end;

local function getNamespaceFolder(p14) -- Line: 122
    -- upvalues: ReplicatedStorage (copy), u2 (copy)
    local NetworkRemotes = ReplicatedStorage:FindFirstChild("NetworkRemotes");

    if not (NetworkRemotes and NetworkRemotes:IsA("Folder")) then
        if u2 then
            NetworkRemotes = Instance.new("Folder");
            NetworkRemotes.Name = "NetworkRemotes";
            NetworkRemotes.Parent = ReplicatedStorage;
        else
            NetworkRemotes = ReplicatedStorage:WaitForChild("NetworkRemotes");
        end;
    end;

    local v15 = NetworkRemotes:FindFirstChild(p14);

    if v15 and v15:IsA("Folder") then
        return v15;
    end;

    if not u2 then
        return NetworkRemotes:WaitForChild(p14);
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = p14;
    Folder.Parent = NetworkRemotes;

    return Folder;
end;

local function createRemoteForReliability(p16, p17) -- Line: 139
    local u18 = p17 == "Unreliable" and "UnreliableRemoteEvent" or "RemoteEvent";
    local success, result = pcall(function() -- Line: 146
        -- upvalues: u18 (copy)
        return Instance.new(u18);
    end);
    local v19 = success and result and result or Instance.new("RemoteEvent");
    v19.Name = p16;

    return v19;
end;

local function getPacketRemote(p20, p21, p22) -- Line: 160
    -- upvalues: getNamespaceFolder (copy), u2 (copy), createRemoteForReliability (copy)
    local v23 = getNamespaceFolder(p20);
    local v24 = v23:FindFirstChild(p21);

    if v24 then
        return v24;
    end;

    if not u2 then
        return v23:WaitForChild(p21);
    end;

    local v25 = createRemoteForReliability(p21, p22);
    v25.Parent = v23;

    return v25;
end;

local function sendImmediatePacketRejectionFeedback(p26, p27, p28, p29, p30, p31) -- Line: 180
    -- upvalues: u2 (copy), getNamespaceFolder (copy), logPacket (copy)
    if not u2 then
        return;
    end;

    if p26 == "Store" and p27 == "OpenCase" then
        local v32 = getNamespaceFolder("Store");
        local CaseOpenDenied = v32:FindFirstChild("CaseOpenDenied");

        if not CaseOpenDenied then
            if u2 then
                local u33 = "RemoteEvent";
                local success, result = pcall(function() -- Line: 146
                    -- upvalues: u33 (copy)
                    return Instance.new(u33);
                end);
                CaseOpenDenied = success and result and result or Instance.new("RemoteEvent");
                CaseOpenDenied.Name = "CaseOpenDenied";
                CaseOpenDenied.Parent = v32;
            else
                CaseOpenDenied = v32:WaitForChild("CaseOpenDenied");
            end;
        end;

        local v34;

        if typeof(p29) == "table" and typeof(p29.RequestId) == "string" then
            v34 = p29.RequestId;
        else
            v34 = nil;
        end;

        local v35 = {
            Reason = p30,
            RequestId = v34
        };
        local v36;

        if p31 then
            local v37 = math.round(p31 * 1000);
            v36 = math.max(0, v37) or nil;
        else
            v36 = nil;
        end;

        v35.RetryAfterMs = v36;
        logPacket("OUTGOING", "Store.CaseOpenDenied", v35, p28);
        CaseOpenDenied:FireClient(p28, v35);
    end;
end;

local function canPassRateLimit(p38, p39, p40) -- Line: 207
    -- upvalues: u3 (copy)
    local maximum_requests_per_second = p40.maximum_requests_per_second;
    local v41 = maximum_requests_per_second == nil and 10 or maximum_requests_per_second;

    if v41 <= 0 then
        return true, nil;
    end;

    local v42 = os.clock();
    local v43 = u3[p38];

    if not v43 then
        v43 = {};
        u3[p38] = v43;
    end;

    local v44 = v43[p39];
    local v45 = math.max(1, v41);

    if not v44 then
        v44 = {
            tokens = v45,
            lastRefill = v42
        };
        v43[p39] = v44;
    end;

    local v46 = v42 - v44.lastRefill;

    if v46 > 0 then
        v44.tokens = math.min(v45, v44.tokens + v46 * v41);
        v44.lastRefill = v42;
    end;

    if v44.tokens < 1 then
        return false, (1 - v44.tokens) / v41;
    end;

    v44.tokens = v44.tokens - 1;

    return true, nil;
end;

local function canPassMiddleware(p47, p48, p49) -- Line: 253
    local middleware = p47.middleware;

    return (not middleware or middleware(p48, p49)) and true or false;
end;

local function isFiniteNumber(p50) -- Line: 262
    local v51;

    if typeof(p50) == "number" and (p50 == p50 and p50 ~= (1 / 0)) then
        v51 = p50 ~= (-1 / 0);
    else
        v51 = false;
    end;

    return v51;
end;

local function isInteger(p52) -- Line: 269
    local v53;

    if typeof(p52) == "number" and (p52 == p52 and p52 ~= (1 / 0)) then
        v53 = p52 ~= (-1 / 0);
    else
        v53 = false;
    end;

    if v53 then
        v53 = p52 == math.floor(p52);
    end;

    return v53;
end;

local function u55(p54) -- Line: 273
    return true;
end;

local function compileValidator(p56) -- Line: 277
    -- upvalues: u55 (copy), compileValidator (copy)
    if p56 == nil then
        return u55;
    end;

    if type(p56) ~= "table" then
        return u55;
    end;

    local _kind = p56._kind;

    if _kind == nil then
        return u55;
    end;

    if _kind == "Unknown" then
        return u55;
    end;

    if _kind == "Nothing" then
        return function(p57) -- Line: 296
            return p57 == nil;
        end;
    end;

    if _kind == "String" then
        return function(p58) -- Line: 302
            return typeof(p58) == "string";
        end;
    end;

    if _kind == "Bool" then
        return function(p59) -- Line: 308
            return typeof(p59) == "boolean";
        end;
    end;

    if _kind == "Instance" then
        return function(p60) -- Line: 314
            return typeof(p60) == "Instance";
        end;
    end;

    if _kind == "CFrame" then
        return function(p61) -- Line: 320
            return typeof(p61) == "CFrame";
        end;
    end;

    if _kind == "Vec3" then
        return function(p62) -- Line: 326
            return typeof(p62) == "Vector3";
        end;
    end;

    if _kind == "Vec2" then
        return function(p63) -- Line: 332
            return typeof(p63) == "Vector2";
        end;
    end;

    if _kind == "Float32" or _kind == "Float64" then
        return function(p64) -- Line: 338
            local v65;

            if typeof(p64) == "number" and (p64 == p64 and p64 ~= (1 / 0)) then
                v65 = p64 ~= (-1 / 0);
            else
                v65 = false;
            end;

            return v65;
        end;
    end;

    if _kind == "Uint8" then
        return function(p66) -- Line: 344
            local v67;

            if typeof(p66) == "number" and (p66 == p66 and p66 ~= (1 / 0)) then
                v67 = p66 ~= (-1 / 0);
            else
                v67 = false;
            end;

            if v67 then
                v67 = p66 == math.floor(p66);
            end;

            if v67 then
                if p66 >= 0 then
                    v67 = p66 <= 255;
                else
                    v67 = false;
                end;
            end;

            return v67;
        end;
    end;

    if _kind == "Uint16" then
        return function(p68) -- Line: 350
            local v69;

            if typeof(p68) == "number" and (p68 == p68 and p68 ~= (1 / 0)) then
                v69 = p68 ~= (-1 / 0);
            else
                v69 = false;
            end;

            if v69 then
                v69 = p68 == math.floor(p68);
            end;

            if v69 then
                if p68 >= 0 then
                    v69 = p68 <= 65535;
                else
                    v69 = false;
                end;
            end;

            return v69;
        end;
    end;

    if _kind == "Uint32" then
        return function(p70) -- Line: 356
            local v71;

            if typeof(p70) == "number" and (p70 == p70 and p70 ~= (1 / 0)) then
                v71 = p70 ~= (-1 / 0);
            else
                v71 = false;
            end;

            if v71 then
                v71 = p70 == math.floor(p70);
            end;

            if v71 then
                if p70 >= 0 then
                    v71 = p70 <= 4294967295;
                else
                    v71 = false;
                end;
            end;

            return v71;
        end;
    end;

    if _kind == "Int8" then
        return function(p72) -- Line: 362
            local v73;

            if typeof(p72) == "number" and (p72 == p72 and p72 ~= (1 / 0)) then
                v73 = p72 ~= (-1 / 0);
            else
                v73 = false;
            end;

            if v73 then
                v73 = p72 == math.floor(p72);
            end;

            if v73 then
                if p72 >= -128 then
                    v73 = p72 <= 127;
                else
                    v73 = false;
                end;
            end;

            return v73;
        end;
    end;

    if _kind == "Int16" then
        return function(p74) -- Line: 368
            local v75;

            if typeof(p74) == "number" and (p74 == p74 and p74 ~= (1 / 0)) then
                v75 = p74 ~= (-1 / 0);
            else
                v75 = false;
            end;

            if v75 then
                v75 = p74 == math.floor(p74);
            end;

            if v75 then
                if p74 >= -32768 then
                    v75 = p74 <= 32767;
                else
                    v75 = false;
                end;
            end;

            return v75;
        end;
    end;

    if _kind == "Int32" then
        return function(p76) -- Line: 374
            local v77;

            if typeof(p76) == "number" and (p76 == p76 and p76 ~= (1 / 0)) then
                v77 = p76 ~= (-1 / 0);
            else
                v77 = false;
            end;

            if v77 then
                v77 = p76 == math.floor(p76);
            end;

            if v77 then
                if p76 >= -2147483648 then
                    v77 = p76 <= 2147483647;
                else
                    v77 = false;
                end;
            end;

            return v77;
        end;
    end;

    if _kind == "Optional" then
        local u78 = compileValidator(p56.value);

        return function(p79) -- Line: 381
            -- upvalues: u78 (copy)
            return p79 == nil and true or u78(p79);
        end;
    end;

    if _kind == "Array" then
        local u80 = compileValidator(p56.value);

        return function(p81) -- Line: 391
            -- upvalues: u80 (copy)
            if typeof(p81) ~= "table" then
                return false;
            end;

            local v82 = #p81;

            for i, v in pairs(p81) do
                if typeof(i) ~= "number" or (i < 1 or (v82 < i or i % 1 ~= 0)) then
                    return false;
                end;

                if not u80(v) then
                    return false;
                end;
            end;

            for i = 1, v82 do
                if p81[i] == nil then
                    return false;
                end;
            end;

            return true;
        end;
    end;

    if _kind == "Map" then
        local u83 = compileValidator(p56.key);
        local u84 = compileValidator(p56.value);

        return function(p85) -- Line: 419
            -- upvalues: u83 (copy), u84 (copy)
            if typeof(p85) ~= "table" then
                return false;
            end;

            for i, v in pairs(p85) do
                if not (u83(i) and u84(v)) then
                    return false;
                end;
            end;

            return true;
        end;
    end;

    if _kind ~= "Struct" then
        return u55;
    end;

    local value = p56.value;

    if typeof(value) ~= "table" then
        return function(p86) -- Line: 437
            return typeof(p86) == "table";
        end;
    end;

    local u87 = {};
    local u88 = {};

    for i, v in pairs(value) do
        if typeof(i) == "string" then
            u87[i] = compileValidator(v);
            local v89;

            if type(v) == "table" then
                v89 = v._kind == "Optional";
            else
                v89 = false;
            end;

            u88[i] = not v89;
        end;
    end;

    return function(p90) -- Line: 451
        -- upvalues: u87 (copy), u88 (copy)
        if typeof(p90) ~= "table" then
            return false;
        end;

        for i, v in pairs(u87) do
            local v91 = p90[i];

            if v91 == nil then
                if u88[i] then
                    return false;
                end;
            elseif not v(v91) then
                return false;
            end;
        end;

        for i, _ in pairs(p90) do
            if typeof(i) ~= "string" or u87[i] == nil then
                return false;
            end;
        end;

        return true;
    end;
end;

function v1.DefinePacket(p92) -- Line: 483
    return p92;
end;

function v1.DefineNamespace(p93, p94) -- Line: 487
    return p94();
end;

function v1.CreatePacket(u95, u96, p97, p98) -- Line: 491
    -- upvalues: compileValidator (copy), getNamespaceFolder (copy), u2 (copy), createRemoteForReliability (copy), logPacket (copy), Players (copy), getPlayersInRange (copy), canPassRateLimit (copy), sendImmediatePacketRejectionFeedback (copy)
    local u99 = p98 or {};
    local u100;

    if u99.name and u99.name ~= "" then
        u100 = u99.name;
    else
        u100 = `{u95}.{u96}`;
    end;

    local v101;

    if p97 then
        v101 = p97.Value;
    else
        v101 = p97;
    end;

    local u102 = compileValidator(v101);
    local ReliabilityType = p97.ReliabilityType;
    local v103 = getNamespaceFolder(u95);
    local u104 = v103:FindFirstChild(u96);

    if not u104 then
        if u2 then
            u104 = createRemoteForReliability(u96, ReliabilityType);
            u104.Parent = v103;
        else
            u104 = v103:WaitForChild(u96);
        end;
    end;

    local u124 = {
        Send = function(p105) -- Line: 508, Name: Send
            -- upvalues: u2 (ref), logPacket (ref), u100 (copy), Players (ref), u104 (copy)
            if u2 then
                return;
            end;

            logPacket("OUTGOING", u100, p105, Players.LocalPlayer);
            u104:FireServer(p105);
        end,

        SendTo = function(p106, p107) -- Line: 517, Name: SendTo
            -- upvalues: u2 (ref), logPacket (ref), u100 (copy), u104 (copy)
            if not u2 then
                return;
            end;

            if not p107 then
                return;
            end;

            logPacket("OUTGOING", u100, p106, p107);
            u104:FireClient(p107, p106);
        end,

        SendToAll = function(p108) -- Line: 530, Name: SendToAll
            -- upvalues: u2 (ref), logPacket (ref), u100 (copy), u104 (copy)
            if not u2 then
                return;
            end;

            logPacket("OUTGOING", u100, p108, nil);
            u104:FireAllClients(p108);
        end,

        SendToAllExcept = function(p109, p110) -- Line: 539, Name: SendToAllExcept
            -- upvalues: u2 (ref), Players (ref), u104 (copy), logPacket (ref), u100 (copy)
            if not u2 then
                return;
            end;

            for _, v in ipairs(Players:GetPlayers()) do
                if v ~= p110 then
                    u104:FireClient(v, p109);
                end;
            end;

            logPacket("OUTGOING", u100, p109, nil);
        end,

        SendToList = function(p111, p112) -- Line: 553, Name: SendToList
            -- upvalues: u2 (ref), u104 (copy), logPacket (ref), u100 (copy)
            if not u2 then
                return;
            end;

            if not p112 or #p112 == 0 then
                return;
            end;

            for _, v in ipairs(p112) do
                if v then
                    u104:FireClient(v, p111);
                end;
            end;

            logPacket("OUTGOING", u100, p111, nil);
        end,

        SendToProximity = function(p113, p114) -- Line: 571, Name: SendToProximity
            -- upvalues: u2 (ref), getPlayersInRange (ref), u104 (copy), logPacket (ref), u100 (copy)
            if not u2 then
                return;
            end;

            local v115 = getPlayersInRange(p114.position, p114.range or 60);

            for _, v in ipairs(v115) do
                u104:FireClient(v, p113);
            end;

            if #v115 > 0 then
                logPacket("OUTGOING", u100, p113, nil);
            end;
        end,

        Listen = function(u116) -- Line: 588, Name: Listen
            -- upvalues: u2 (ref), u104 (copy), canPassRateLimit (ref), u100 (copy), u99 (copy), sendImmediatePacketRejectionFeedback (ref), u95 (copy), u96 (copy), u102 (copy), logPacket (ref)
            if u2 then
                local u121 = u104.OnServerEvent:Connect(function(p117, p118) -- Line: 590
                    -- upvalues: canPassRateLimit (ref), u100 (ref), u99 (ref), sendImmediatePacketRejectionFeedback (ref), u95 (ref), u96 (ref), u102 (ref), logPacket (ref), u116 (copy)
                    local v119, v120 = canPassRateLimit(p117, u100, u99);

                    if not v119 then
                        sendImmediatePacketRejectionFeedback(u95, u96, p117, p118, "RateLimited", v120);

                        return;
                    end;

                    if not u102(p118) then
                        return;
                    end;

                    local middleware = u99.middleware;

                    if middleware and not middleware(p118, p117) then
                        return;
                    end;

                    logPacket("INCOMING", u100, p118, p117);
                    u116(p118, p117);
                end);

                return function() -- Line: 615
                    -- upvalues: u121 (copy)
                    u121:Disconnect();
                end;
            end;

            local u123 = u104.OnClientEvent:Connect(function(p122) -- Line: 620
                -- upvalues: u102 (ref), logPacket (ref), u100 (ref), u116 (copy)
                if not u102(p122) then
                    return;
                end;

                logPacket("INCOMING", u100, p122, nil);
                u116(p122, nil);
            end);

            return function() -- Line: 628
                -- upvalues: u123 (copy)
                u123:Disconnect();
            end;
        end
    };

    function u124.Connect(p125) -- Line: 633
        -- upvalues: u124 (copy)
        return u124.Listen(p125);
    end;

    function u124.Wait() -- Line: 637
        -- upvalues: u2 (ref), u104 (copy)
        if not u2 then
            return u104.OnClientEvent:Wait(), nil;
        end;

        local v126, v127 = u104.OnServerEvent:Wait();

        return v127, v126;
    end;

    return u124;
end;

v1.Nothing = table.freeze({
    _kind = "Nothing"
});
v1.Unknown = table.freeze({
    _kind = "Unknown"
});
v1.String = table.freeze({
    _kind = "String"
});
v1.Bool = table.freeze({
    _kind = "Bool"
});
v1.Instance = table.freeze({
    _kind = "Instance"
});
v1.CFrame = table.freeze({
    _kind = "CFrame"
});
v1.Vec3 = table.freeze({
    _kind = "Vec3"
});
v1.Vec2 = table.freeze({
    _kind = "Vec2"
});
v1.Float32 = table.freeze({
    _kind = "Float32"
});
v1.Float64 = table.freeze({
    _kind = "Float64"
});
v1.Uint8 = table.freeze({
    _kind = "Uint8"
});
v1.Uint16 = table.freeze({
    _kind = "Uint16"
});
v1.Uint32 = table.freeze({
    _kind = "Uint32"
});
v1.Int8 = table.freeze({
    _kind = "Int8"
});
v1.Int16 = table.freeze({
    _kind = "Int16"
});
v1.Int32 = table.freeze({
    _kind = "Int32"
});

function v1.Array(p128) -- Line: 668
    return {
        _kind = "Array",
        value = p128
    };
end;

function v1.Map(p129, p130) -- Line: 672
    return {
        _kind = "Map",
        key = p129,
        value = p130
    };
end;

function v1.Struct(p131) -- Line: 676
    return {
        _kind = "Struct",
        value = p131
    };
end;

function v1.Optional(p132) -- Line: 680
    return {
        _kind = "Optional",
        value = p132
    };
end;

if u2 then
    Players.PlayerRemoving:Connect(function(p133) -- Line: 685
        -- upvalues: u3 (copy)
        u3[p133] = nil;
    end);
end;

return v1;