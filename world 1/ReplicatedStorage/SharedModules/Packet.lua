-- Decompiled with Potassium's decompiler.

local Signal = require(script.Signal);
local Task = require(script.Task);
local Types = require(script.Types);
local u1 = {
    UseBuffers = true,
    DebugOutgoing = false,
    DebugOutgoingInterval = 5,
    DebugOutgoingTop = 10
};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Reads = Types.Reads;
local Writes = Types.Writes;
local Import = Types.Import;
local Export = Types.Export;
local Truncate = Types.Truncate;
local Ended = Types.Ended;
local NumberU8 = Reads.NumberU8;
local NumberU82 = Writes.NumberU8;
local NumberU16 = Reads.NumberU16;
local NumberU162 = Writes.NumberU16;
local u7 = {};
local u8 = {};
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = {
    BufferLength = 128,
    BufferOffset = 0,
    InstancesOffset = 0,
    Buffer = buffer.create(128),
    Instances = {}
};
local u15 = nil;
local u16 = 0;
local u17 = nil;

local function getReporter() -- Line: 60
    -- upvalues: RunService (copy), u17 (ref)
    if RunService:IsServer() ~= true then
        return nil;
    end;

    if u17 == nil then
        local success, result = pcall(function() -- Line: 65
            return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
        end);

        if not success then
            result = false;
        end;

        u17 = result;
    end;

    if u17 then
        return u17;
    end;

    return nil;
end;

local function getFrameByteCap() -- Line: 72
    -- upvalues: RunService (copy), u17 (ref)
    local v18;

    if RunService:IsServer() == true then
        if u17 == nil then
            local success, result = pcall(function() -- Line: 65
                return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
            end);

            if not success then
                result = false;
            end;

            u17 = result;
        end;

        if u17 then
            v18 = u17;
        else
            v18 = nil;
        end;
    else
        v18 = nil;
    end;

    return not v18 and 64000 or v18.GetFrameByteCap();
end;

local function packetShouldBlock(p19) -- Line: 76
    -- upvalues: RunService (copy), u17 (ref)
    local v20;

    if RunService:IsServer() == true then
        if u17 == nil then
            local success, result = pcall(function() -- Line: 65
                return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
            end);

            if not success then
                result = false;
            end;

            u17 = result;
        end;

        if u17 then
            v20 = u17;
        else
            v20 = nil;
        end;
    else
        v20 = nil;
    end;

    return not v20 and true or v20.ShouldBlock(p19);
end;

local function reportAbuse(p21, p22, p23) -- Line: 80
    -- upvalues: RunService (copy), u17 (ref)
    local v24;

    if RunService:IsServer() == true then
        if u17 == nil then
            local success, result = pcall(function() -- Line: 65
                return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
            end);

            if not success then
                result = false;
            end;

            u17 = result;
        end;

        if u17 then
            v24 = u17;
        else
            v24 = nil;
        end;
    else
        v24 = nil;
    end;

    if v24 then
        v24.Report(p21, "Packet", p22, p23);
    end;
end;

local function debugOutgoingIncrement(p25) -- Line: 87
    -- upvalues: u1 (copy), RunService (copy), u15 (ref), u16 (ref)
    if u1.DebugOutgoing ~= true or RunService:IsServer() ~= true then
        return;
    end;

    local v26 = u15;

    if v26 == nil then
        v26 = {};
        u15 = v26;
        u16 = os.clock();
    end;

    v26[p25] = (v26[p25] or 0) + 1;
    local v27 = os.clock();

    if (u1.DebugOutgoingInterval or 5) > v27 - u16 then
        return;
    end;

    u16 = v27;
    local v28 = {};

    for i, v in v26 do
        v28[#v28 + 1] = { i, v };
    end;

    table.sort(v28, function(p29, p30) -- Line: 112
        return p29[2] > p30[2];
    end);
    local v31 = {};

    for i = 1, math.min(u1.DebugOutgoingTop or 10, #v28) do
        local v32 = v28[i];
        v31[#v31 + 1] = v32[1] .. "=" .. tostring(v32[2]);
    end;

    table.clear(v26);
end;

local function Constructor(p33, p34, ...) -- Line: 128
    -- upvalues: u8 (copy), u7 (copy), RunService (copy), u13 (ref), Signal (copy), u12 (ref), u2 (ref)
    local v35 = u8[p34];

    if v35 then
        return v35;
    end;

    local v36 = setmetatable({}, u7);
    v36.Name = p34;

    if RunService:IsServer() then
        v36.Id = u13;
        v36.OnServerEvent = Signal();
        u12:SetAttribute(p34, u13);
        u8[u13] = v36;
        u13 = u13 + 1;
    else
        v36.Id = u12:GetAttribute(p34);
        v36.OnClientEvent = Signal();

        if v36.Id then
            u8[v36.Id] = v36;
        end;
    end;

    local v37, v38 = u2(table.pack(...));
    v36.Reads = v37;
    v36.Writes = v38;
    u8[v36.Name] = v36;

    return v36;
end;

u7.__index = u7;
u7.Type = "Packet";

function u7.Response(p39, ...) -- Line: 154
    -- upvalues: u2 (ref)
    p39.ResponseTimeout = p39.ResponseTimeout or 10;
    local v40, v41 = u2(table.pack(...));
    p39.ResponseReads = v40;
    p39.ResponseWrites = v41;

    return p39;
end;

function u7.Fire(p42, ...) -- Line: 160
    -- upvalues: u1 (copy), RunService (copy), u11 (ref), Import (copy), u14 (ref), NumberU162 (copy), NumberU82 (copy), Task (copy), u6 (ref), u5 (ref), Export (copy), u12 (ref)
    if not u1.UseBuffers then
        if not p42.ResponseReads then
            u12:FireServer(p42.Id, ...);

            return;
        end;

        if RunService:IsServer() then
            error("You must use FireClient(player)", 2);
        end;

        local v43 = nil;

        for _ = 1, 128 do
            v43 = u11[u11.Index];

            if not v43 then
                break;
            end;

            u11.Index = (u11.Index + 1) % 128;
        end;

        if v43 then
            error("Cannot have more than 128 yielded threads", 2);
        end;

        u11[u11.Index] = {
            Yielded = coroutine.running(),
            Timeout = Task:Delay(p42.ResponseTimeout, u6, u11, u11.Index, p42.ResponseTimeoutValue)
        };
        u12:FireServer(p42.Id, u11.Index, ...);
        u11.Index = (u11.Index + 1) % 128;

        return coroutine.yield();
    end;

    if not p42.ResponseReads then
        Import(u14);
        NumberU162(p42.Id);
        u5(p42.Writes, { ... });
        u14 = Export();

        return;
    end;

    if RunService:IsServer() then
        error("You must use FireClient(player)", 2);
    end;

    local v44 = nil;

    for _ = 1, 128 do
        v44 = u11[u11.Index];

        if not v44 then
            break;
        end;

        u11.Index = (u11.Index + 1) % 128;
    end;

    if v44 then
        error("Cannot have more than 128 yielded threads", 2);
    end;

    Import(u14);
    NumberU162(p42.Id);
    NumberU82(u11.Index);
    u11[u11.Index] = {
        Yielded = coroutine.running(),
        Timeout = Task:Delay(p42.ResponseTimeout, u6, u11, u11.Index, p42.ResponseTimeoutValue)
    };
    u11.Index = (u11.Index + 1) % 128;
    u5(p42.Writes, { ... });
    u14 = Export();

    return coroutine.yield();
end;

function u7.FireClient(p45, p46, ...) -- Line: 206
    -- upvalues: u1 (copy), debugOutgoingIncrement (copy), u10 (ref), Import (copy), u9 (ref), NumberU162 (copy), NumberU82 (copy), Task (copy), u6 (ref), u5 (ref), Export (copy), u12 (ref)
    if p46.Parent == nil then
        return;
    end;

    if u1.UseBuffers then
        if not p45.ResponseReads then
            debugOutgoingIncrement(p45.Name);
            Import(u9[p46] or {
                BufferLength = 128,
                BufferOffset = 0,
                InstancesOffset = 0,
                Buffer = buffer.create(128),
                Instances = {}
            });
            NumberU162(p45.Id);
            u5(p45.Writes, { ... });
            u9[p46] = Export();

            return;
        end;

        debugOutgoingIncrement(p45.Name);
        local v47 = u10[p46];

        if v47 == nil then
            v47 = {
                Index = 0
            };
            u10[p46] = v47;
        end;

        local v48 = nil;

        for _ = 1, 128 do
            v48 = v47[v47.Index];

            if not v48 then
                break;
            end;

            v47.Index = (v47.Index + 1) % 128;
        end;

        if not v48 then
            Import(u9[p46] or {
                BufferLength = 128,
                BufferOffset = 0,
                InstancesOffset = 0,
                Buffer = buffer.create(128),
                Instances = {}
            });
            NumberU162(p45.Id);
            NumberU82(v47.Index);
            v47[v47.Index] = {
                Yielded = coroutine.running(),
                Timeout = Task:Delay(p45.ResponseTimeout, u6, v47, v47.Index, p45.ResponseTimeoutValue)
            };
            v47.Index = (v47.Index + 1) % 128;
            u5(p45.Writes, { ... });
            u9[p46] = Export();

            return coroutine.yield();
        end;

        error("Cannot have more than 128 yielded threads", 2);

        return;
    end;

    if not p45.ResponseReads then
        debugOutgoingIncrement(p45.Name);
        u12:FireClient(p46, p45.Id, ...);

        return;
    end;

    debugOutgoingIncrement(p45.Name);
    local v49 = u10[p46];

    if v49 == nil then
        v49 = {
            Index = 0
        };
        u10[p46] = v49;
    end;

    local v50 = nil;

    for _ = 1, 128 do
        v50 = v49[v49.Index];

        if not v50 then
            break;
        end;

        v49.Index = (v49.Index + 1) % 128;
    end;

    if not v50 then
        v49[v49.Index] = {
            Yielded = coroutine.running(),
            Timeout = Task:Delay(p45.ResponseTimeout, u6, v49, v49.Index, p45.ResponseTimeoutValue)
        };
        u12:FireClient(p46, p45.Id, v49.Index, ...);
        v49.Index = (v49.Index + 1) % 128;

        return coroutine.yield();
    end;

    error("Cannot have more than 128 yielded threads", 2);
end;

function u7.FireAllClients(p51, ...) -- Line: 256
    -- upvalues: RunService (copy), u1 (copy), debugOutgoingIncrement (copy), Import (copy), u14 (ref), NumberU162 (copy), u5 (ref), Export (copy), u12 (ref)
    if not RunService:IsServer() then
        error("FireAllClients can only be called from the server", 2);
    end;

    if p51.ResponseReads then
        error("Cannot use FireAllClients with packets that expect a response", 2);
    end;

    if not u1.UseBuffers then
        debugOutgoingIncrement(p51.Name);
        u12:FireAllClients(p51.Id, ...);

        return;
    end;

    debugOutgoingIncrement(p51.Name);
    Import(u14);
    NumberU162(p51.Id);
    u5(p51.Writes, { ... });
    u14 = Export();
end;

function u7.Serialize(p52, ...) -- Line: 271
    -- upvalues: Import (copy), u5 (ref), Truncate (copy)
    Import({
        BufferLength = 128,
        BufferOffset = 0,
        InstancesOffset = 0,
        Buffer = buffer.create(128),
        Instances = {}
    });
    u5(p52.Writes, { ... });

    return Truncate();
end;

function u7.Deserialize(p53, p54, p55) -- Line: 277
    -- upvalues: Import (copy), u4 (ref)
    Import({
        BufferOffset = 0,
        InstancesOffset = 0,
        Buffer = p54,
        BufferLength = buffer.len(p54),
        Instances = p55 or {}
    });

    return u4(p53.Reads);
end;

u2 = function(p56) -- Line: 284, Name: ParametersToFunctions
    -- upvalues: u3 (ref), Reads (copy), Writes (copy)
    local v57 = table.create(#p56);
    local v58 = table.create(#p56);

    for i, v in ipairs(p56) do
        if type(v) == "table" then
            local v59, v60 = u3(v);
            v57[i] = v59;
            v58[i] = v60;
        else
            local v61 = Writes[v];
            v57[i] = Reads[v];
            v58[i] = v61;
        end;
    end;

    return v57, v58;
end;

u3 = function(p62) -- Line: 296, Name: TableToFunctions
    -- upvalues: u3 (ref), Reads (copy), Writes (copy), NumberU16 (copy), NumberU162 (copy)
    if #p62 == 1 then
        local v63 = p62[1];
        local u64, u65;

        if type(v63) == "table" then
            u64, u65 = u3(v63);
        else
            u64 = Reads[v63];
            u65 = Writes[v63];
        end;

        return function() -- Line: 305
            -- upvalues: NumberU16 (ref), u64 (ref)
            local v66 = NumberU16();
            local v67 = table.create(v66);

            for i = 1, v66 do
                v67[i] = u64();
            end;

            return v67;
        end, function(p68) -- Line: 311
            -- upvalues: NumberU162 (ref), u65 (ref)
            NumberU162(#p68);

            for _, v in p68 do
                u65(v);
            end;
        end;
    end;

    local u69 = {};

    for i, _ in p62 do
        table.insert(u69, i);
    end;

    table.sort(u69);
    local u70 = table.create(#u69);
    local u71 = table.create(#u69);

    for i, v in u69 do
        local v72 = p62[v];

        if type(v72) == "table" then
            local v73, v74 = u3(v72);
            u70[i] = v73;
            u71[i] = v74;
        else
            local v75 = Writes[v72];
            u70[i] = Reads[v72];
            u71[i] = v75;
        end;
    end;

    return function() -- Line: 327
        -- upvalues: u70 (copy), u69 (copy)
        local v76 = {};

        for i, v in u70 do
            v76[u69[i]] = v();
        end;

        return v76;
    end, function(p77) -- Line: 332
        -- upvalues: u71 (copy), u69 (copy)
        for i, v in u71 do
            v(p77[u69[i]]);
        end;
    end;
end;

u4 = function(p78) -- Line: 339, Name: ReadParameters
    local v79 = table.create(#p78);

    for i, v in p78 do
        v79[i] = v();
    end;

    return table.unpack(v79);
end;

u5 = function(p80, p81) -- Line: 345, Name: WriteParameters
    for i, v in p80 do
        v(p81[i]);
    end;
end;

u6 = function(p82, p83, p84) -- Line: 349, Name: Timeout
    local v85 = p82[p83];

    if not v85 then
        return;
    end;

    pcall(task.defer, v85.Yielded, p84);
    p82[p83] = nil;
end;

if RunService:IsServer() then
    u9 = {};
    u10 = {};
    u13 = 0;
    u12 = Instance.new("RemoteEvent", script);
    local u86 = {};
    local u87 = false;
    local u90 = task.spawn(function() -- Line: 381
        -- upvalues: u87 (ref), u14 (ref), u12 (ref), u9 (ref), u86 (copy)
        while true do
            coroutine.yield();
            u87 = false;

            if u14.BufferOffset > 0 then
                local v88 = buffer.create(u14.BufferOffset);
                buffer.copy(v88, 0, u14.Buffer, 0, u14.BufferOffset);

                if u14.InstancesOffset == 0 then
                    u12:FireAllClients(v88);
                else
                    u12:FireAllClients(v88, u14.Instances);
                    u14.InstancesOffset = 0;
                    table.clear(u14.Instances);
                end;

                u14.BufferOffset = 0;
            end;

            for i, v in u9 do
                local v89 = buffer.create(v.BufferOffset);
                buffer.copy(v89, 0, v.Buffer, 0, v.BufferOffset);

                if v.InstancesOffset == 0 then
                    u12:FireClient(i, v89);
                else
                    u12:FireClient(i, v89, v.Instances);
                end;
            end;

            table.clear(u9);
            table.clear(u86);
        end;
    end);

    local function u95(p91, p92, p93, ...) -- Line: 411
        -- upvalues: RunService (copy), Import (copy), u9 (ref), NumberU162 (copy), NumberU82 (copy), u5 (ref), Export (copy)
        if p91.OnServerInvoke == nil then
            RunService:IsStudio();

            return;
        end;

        local v94 = { p91.OnServerInvoke(p92, ...) };

        if p92.Parent == nil then
            return;
        end;

        Import(u9[p92] or {
            BufferLength = 128,
            BufferOffset = 0,
            InstancesOffset = 0,
            Buffer = buffer.create(128),
            Instances = {}
        });
        NumberU162(p91.Id);
        NumberU82(p93 + 128);
        u5(p91.ResponseWrites, v94);
        u9[p92] = Export();
    end;

    local function u113(p96, u97, u98) -- Line: 422
        -- upvalues: u86 (copy), RunService (copy), u17 (ref), Import (copy), Ended (copy), NumberU16 (copy), u8 (copy), NumberU8 (copy), Task (copy), u95 (copy), u4 (ref), u10 (ref)
        local v99 = u86[p96] or 0;
        local v100 = buffer.len(u97);
        local u101 = v99 + math.max(v100, 800);
        local v102;

        if RunService:IsServer() == true then
            if u17 == nil then
                local success, result = pcall(function() -- Line: 65
                    return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
                end);

                if not success then
                    result = false;
                end;

                u17 = result;
            end;

            if u17 then
                v102 = u17;
            else
                v102 = nil;
            end;
        else
            v102 = nil;
        end;

        if (not v102 and 64000 or v102.GetFrameByteCap()) < u101 then
            local function v103() -- Line: 425
                -- upvalues: u101 (copy), u97 (copy), u17 (ref), u98 (copy)
                return {
                    Bytes = u101,
                    BufferLen = buffer.len(u97),
                    BufferHex = u17.BufferHexPrefix(u97),
                    InstanceCount = u98 and #u98 or 0
                };
            end;

            local v104;

            if RunService:IsServer() == true then
                if u17 == nil then
                    local success, result = pcall(function() -- Line: 65
                        return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
                    end);

                    if not success then
                        result = false;
                    end;

                    u17 = result;
                end;

                if u17 then
                    v104 = u17;
                else
                    v104 = nil;
                end;
            else
                v104 = nil;
            end;

            if v104 then
                v104.Report(p96, "Packet", "oversize", v103);
            end;

            local v105;

            if RunService:IsServer() == true then
                if u17 == nil then
                    local success, result = pcall(function() -- Line: 65
                        return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
                    end);

                    if not success then
                        result = false;
                    end;

                    u17 = result;
                end;

                if u17 then
                    v105 = u17;
                else
                    v105 = nil;
                end;
            else
                v105 = nil;
            end;

            if not v105 and true or v105.ShouldBlock("oversize") then
                return;
            end;
        end;

        u86[p96] = u101;
        Import({
            BufferOffset = 0,
            InstancesOffset = 0,
            Buffer = u97,
            BufferLength = buffer.len(u97),
            Instances = u98 or {}
        });

        while Ended() == false do
            local u106 = NumberU16();
            local v107 = u8[u106];

            if not v107 then
                local function v108() -- Line: 443
                    -- upvalues: u106 (copy), u97 (copy), u17 (ref), u98 (copy)
                    return {
                        PacketId = u106,
                        BufferLen = buffer.len(u97),
                        BufferHex = u17.BufferHexPrefix(u97),
                        InstanceCount = u98 and #u98 or 0
                    };
                end;

                local v109;

                if RunService:IsServer() == true then
                    if u17 == nil then
                        local success, result = pcall(function() -- Line: 65
                            return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
                        end);

                        if not success then
                            result = false;
                        end;

                        u17 = result;
                    end;

                    if u17 then
                        v109 = u17;
                    else
                        v109 = nil;
                    end;
                else
                    v109 = nil;
                end;

                if v109 then
                    v109.Report(p96, "Packet", "unknown_packet", v108);

                    return;
                end;

                break;
            end;

            if v107.ResponseReads then
                local v110 = NumberU8();

                if v110 < 128 then
                    Task:Defer(u95, v107, p96, v110, u4(v107.Reads));
                else
                    local v111 = v110 - 128;
                    local v112 = u10[p96][v111];

                    if v112 then
                        task.cancel(v112.Timeout);
                        task.defer(v112.Yielded, u4(v107.ResponseReads));
                        u10[p96][v111] = nil;
                    elseif not RunService:IsStudio() then
                        u4(v107.ResponseReads);
                    end;
                end;
            else
                v107.OnServerEvent:Fire(p96, u4(v107.Reads));
            end;
        end;
    end;

    local function u118(p114, p115, p116, ...) -- Line: 475
        -- upvalues: RunService (copy), u12 (ref)
        if p114.OnServerInvoke == nil then
            RunService:IsStudio();

            return;
        end;

        local v117 = { p114.OnServerInvoke(p115, ...) };

        if p115.Parent == nil then
            return;
        end;

        u12:FireClient(p115, p114.Id, p116 + 128, table.unpack(v117));
    end;

    local function u129(p119, u120, ...) -- Line: 482
        -- upvalues: u8 (copy), u17 (ref), RunService (copy), Task (copy), u118 (copy)
        local v121 = u8[u120];

        if not v121 then
            local u122 = table.pack(...);

            local function v123() -- Line: 486
                -- upvalues: u17 (ref), u120 (copy), u122 (copy)
                return {
                    Unbuffered = true,
                    PacketId = u17.SafePreview(u120),
                    Args = u17.PreviewPacked(u122)
                };
            end;

            local v124;

            if RunService:IsServer() == true then
                if u17 == nil then
                    local success, result = pcall(function() -- Line: 65
                        return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
                    end);

                    if not success then
                        result = false;
                    end;

                    u17 = result;
                end;

                if u17 then
                    v124 = u17;
                else
                    v124 = nil;
                end;
            else
                v124 = nil;
            end;

            if v124 then
                v124.Report(p119, "Packet", "unknown_packet", v123);
            end;

            return;
        end;

        if not v121.ResponseReads then
            v121.OnServerEvent:Fire(p119, ...);

            return;
        end;

        local v125 = { ... };
        local u126 = table.remove(v125, 1);

        if type(u126) == "number" and (u126 >= 0 and (u126 < 128 and u126 % 1 == 0)) then
            Task:Defer(u118, v121, p119, u126, table.unpack(v125));

            return;
        end;

        local function v127() -- Line: 499
            -- upvalues: u17 (ref), u120 (copy), u126 (copy)
            return {
                Unbuffered = true,
                PacketId = u17.SafePreview(u120),
                ThreadIndexType = typeof(u126),
                ThreadIndexPreview = u17.SafePreview(u126)
            };
        end;

        local v128;

        if RunService:IsServer() == true then
            if u17 == nil then
                local success, result = pcall(function() -- Line: 65
                    return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
                end);

                if not success then
                    result = false;
                end;

                u17 = result;
            end;

            if u17 then
                v128 = u17;
            else
                v128 = nil;
            end;
        else
            v128 = nil;
        end;

        if v128 then
            v128.Report(p119, "Packet", "bad_id_type", v127);
        end;
    end;

    u12.OnServerEvent:Connect(function(p130, u131, ...) -- Line: 515
        -- upvalues: u113 (copy), u1 (copy), u17 (ref), RunService (copy), u129 (copy)
        local v132, u133;

        if typeof(u131) == "buffer" then
            v132, u133 = pcall(u113, p130, u131, ...);
        else
            if u1.UseBuffers then
                local u134 = table.pack(...);

                local function v135() -- Line: 521
                    -- upvalues: u131 (copy), u17 (ref), u134 (copy)
                    return {
                        Arg1Type = typeof(u131),
                        Arg1Preview = u17.SafePreview(u131),
                        Args = u17.PreviewPacked(u134)
                    };
                end;

                local v136;

                if RunService:IsServer() == true then
                    if u17 == nil then
                        local success, result = pcall(function() -- Line: 65
                            return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
                        end);

                        if not success then
                            result = false;
                        end;

                        u17 = result;
                    end;

                    if u17 then
                        v136 = u17;
                    else
                        v136 = nil;
                    end;
                else
                    v136 = nil;
                end;

                if v136 then
                    v136.Report(p130, "Packet", "unbuffered", v135);
                end;

                return;
            end;

            v132, u133 = pcall(u129, p130, u131, ...);
        end;

        if not v132 then
            warn((`[Packet] Server event handler errored for {p130.Name}: {u133}`));

            local function v138() -- Line: 534
                -- upvalues: u17 (ref), u133 (ref), u131 (copy)
                local v137 = {
                    Error = u17.SanitizeString((tostring(u133))),
                    Arg1Type = typeof(u131)
                };

                if typeof(u131) ~= "buffer" then
                    v137.Arg1Preview = u17.SafePreview(u131);

                    return v137;
                end;

                v137.BufferLen = buffer.len(u131);
                v137.BufferHex = u17.BufferHexPrefix(u131);

                return v137;
            end;

            local v139;

            if RunService:IsServer() == true then
                if u17 == nil then
                    local success, result = pcall(function() -- Line: 65
                        return require(game:GetService("ServerScriptService").ServerModules.RemoteAbuseReporter);
                    end);

                    if not success then
                        result = false;
                    end;

                    u17 = result;
                end;

                if u17 then
                    v139 = u17;
                else
                    v139 = nil;
                end;
            else
                v139 = nil;
            end;

            if v139 then
                v139.Report(p130, "Packet", "handler_error", v138);
            end;
        end;
    end);
    Players.PlayerRemoving:Connect(function(p140) -- Line: 550
        -- upvalues: u9 (ref), u10 (ref), u86 (copy)
        u9[p140] = nil;
        u10[p140] = nil;
        u86[p140] = nil;
    end);

    if u1.UseBuffers then
        RunService.Heartbeat:Connect(function(p141) -- Line: 557
            -- upvalues: u87 (ref), u90 (copy)
            if u87 then
                return;
            end;

            u87 = true;
            task.defer(u90);
        end);
    end;
else
    u11 = {
        Index = 0
    };
    u12 = script:WaitForChild("RemoteEvent");
    local u142 = 0;
    local u143 = false;
    local u145 = task.spawn(function() -- Line: 572
        -- upvalues: u143 (ref), u14 (ref), u12 (ref)
        while true do
            repeat
                coroutine.yield();
                u143 = false;
            until u14.BufferOffset > 0;

            local v144 = buffer.create(u14.BufferOffset);
            buffer.copy(v144, 0, u14.Buffer, 0, u14.BufferOffset);

            if u14.InstancesOffset == 0 then
                u12:FireServer(v144);
            else
                u12:FireServer(v144, u14.Instances);
                u14.InstancesOffset = 0;
                table.clear(u14.Instances);
            end;

            u14.BufferOffset = 0;
        end;
    end);

    local function u149(p146, p147, ...) -- Line: 591
        -- upvalues: Import (copy), u14 (ref), NumberU162 (copy), NumberU82 (copy), u5 (ref), Export (copy)
        if p146.OnClientInvoke == nil then
            return;
        end;

        local v148 = { p146.OnClientInvoke(...) };
        Import(u14);
        NumberU162(p146.Id);
        NumberU82(p147 + 128);
        u5(p146.ResponseWrites, v148);
        u14 = Export();
    end;

    local function u153(p150, p151, ...) -- Line: 601
        -- upvalues: u12 (ref)
        if p150.OnClientInvoke == nil then
            return;
        end;

        local v152 = { p150.OnClientInvoke(...) };
        u12:FireServer(p150.Id, p151 + 128, table.unpack(v152));
    end;

    local function u160(p154, ...) -- Line: 607
        -- upvalues: u8 (copy), Task (copy), u153 (copy), u11 (ref)
        local v155 = u8[p154];

        if not v155 then
            return;
        end;

        if v155.ResponseReads then
            local v156 = { ... };
            local v157 = table.remove(v156, 1);

            if v157 < 128 then
                Task:Defer(u153, v155, v157, table.unpack(v156));

                return;
            end;

            local v158 = v157 - 128;
            local v159 = u11[v158];

            if v159 then
                task.cancel(v159.Timeout);
                pcall(task.defer, v159.Yielded, table.unpack(v156));
                u11[v158] = nil;
            end;
        else
            v155.OnClientEvent:Fire(...);
        end;
    end;

    local function u165(p161) -- Line: 634
        -- upvalues: NumberU8 (copy), Task (copy), u149 (copy), u4 (ref), u11 (ref)
        if not p161.ResponseReads then
            p161.OnClientEvent:Fire(u4(p161.Reads));

            return;
        end;

        local v162 = NumberU8();

        if v162 < 128 then
            Task:Defer(u149, p161, v162, u4(p161.Reads));

            return;
        end;

        local v163 = v162 - 128;
        local v164 = u11[v163];

        if not v164 then
            u4(p161.ResponseReads);

            return;
        end;

        task.cancel(v164.Timeout);
        pcall(task.defer, v164.Yielded, u4(p161.ResponseReads));
        u11[v163] = nil;
    end;

    u12.OnClientEvent:Connect(function(p166, ...) -- Line: 666
        -- upvalues: Import (copy), Ended (copy), u8 (copy), NumberU16 (copy), u165 (copy), u160 (copy)
        if typeof(p166) == "buffer" then
            local v167 = select(1, ...);
            Import({
                BufferOffset = 0,
                InstancesOffset = 0,
                Buffer = p166,
                BufferLength = buffer.len(p166),
                Instances = v167 or {}
            });

            while true do
                local v168 = Ended() == false and u8[NumberU16()];

                if not v168 then
                    break;
                end;

                local success, result = pcall(u165, v168);

                if not success then
                    warn("Packet: dropped the rest of a batched client buffer -- " .. tostring(result));

                    return;
                end;
            end;
        else
            u160(p166, ...);
        end;
    end);
    u12.AttributeChanged:Connect(function(p169) -- Line: 689
        -- upvalues: u8 (copy), u12 (ref)
        local v170 = u8[p169];

        if v170 then
            if v170.Id then
                u8[v170.Id] = nil;
            end;

            v170.Id = u12:GetAttribute(p169);

            if v170.Id then
                u8[v170.Id] = v170;
            end;
        end;
    end);

    if u1.UseBuffers then
        RunService.Heartbeat:Connect(function(p171) -- Line: 699
            -- upvalues: u142 (ref), u143 (ref), u145 (copy)
            u142 = u142 + p171;

            if u142 > 0.016666666666666666 then
                u142 = u142 % 0.016666666666666666;

                if u143 then
                    return;
                end;

                u143 = true;
                task.defer(u145);
            end;
        end);
    end;
end;

local v172 = setmetatable(Types.Types, {
    __call = Constructor
});
v172.Settings = u1;

return v172;