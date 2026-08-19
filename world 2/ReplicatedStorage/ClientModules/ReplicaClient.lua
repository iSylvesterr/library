-- Decompiled with Potassium's decompiler.

local ReplicaShared = game.ReplicatedStorage.ReplicaShared;
local Remote = require(ReplicaShared.Remote);
local Signal = require(ReplicaShared.Signal);
local Maid = require(ReplicaShared.Maid);
local u1 = {};
local CollectionService = game:GetService("CollectionService");
game:GetService("ReplicatedStorage");
game:GetService("Players");
local u2 = false;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = Remote.New("ReplicaRequestData");
local v9 = Remote.New("ReplicaSet");
local v10 = Remote.New("ReplicaSetValues");
local v11 = Remote.New("ReplicaTableInsert");
local v12 = Remote.New("ReplicaTableRemove");
local v13 = Remote.New("ReplicaWrite");
local u14 = Remote.New("ReplicaSignal");
local v15 = Remote.New("ReplicaParent");
local v16 = Remote.New("ReplicaCreate");
local v17 = Remote.New("ReplicaBind");
local v18 = Remote.New("ReplicaDestroy");
local u19 = Remote.New("ReplicaSignalUnreliable", true);
local u20 = {};
local u21 = false;

local function LoadWriteLib(p22) -- Line: 112
    -- upvalues: u20 (copy)
    local v23 = u20[p22];

    if v23 ~= nil then
        return v23;
    end;

    local v24 = require(p22);
    local v25 = {};

    for i, v in pairs(v24) do
        table.insert(v25, { i, v });
    end;

    table.sort(v25, function(p26, p27) -- Line: 128
        return p26[1] < p27[1];
    end);
    local v28 = {};

    for i, v in ipairs(v25) do
        local v29 = {
            Name = v[1],
            Id = i,
            fn = v[2]
        };
        v28[v[1]] = v29;
        v28[i] = v29;
    end;

    u20[p22] = v28;

    return v28;
end;

local u30 = nil;

local function AcquireRunnerThreadAndCallEventHandler(p31, ...) -- Line: 178
    -- upvalues: u30 (ref)
    local v32 = u30;
    u30 = nil;
    p31(...);
    u30 = v32;
end;

local function RunEventHandlerInFreeThread(...) -- Line: 186
    -- upvalues: AcquireRunnerThreadAndCallEventHandler (copy)
    AcquireRunnerThreadAndCallEventHandler(...);

    while true do
        AcquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local u33 = {
    IsReady = false,
    OnLocalReady = Signal.New()
};
u33.__index = u33;

local function ReplicaNew(p34, p35) -- Line: 199
    -- upvalues: LoadWriteLib (copy), u5 (copy), u4 (copy), Signal (copy), Maid (copy), u1 (copy), u33 (copy)
    local v36;

    if p35[5] == nil then
        v36 = nil;
    else
        v36 = LoadWriteLib(p35[5]);
    end;

    local v37 = u5[p35[4]] or u4[p35[4]];
    local v38 = {
        BoundInstance = nil,
        Tags = p35[2],
        Data = p35[3],
        Id = p34,
        Token = p35[1],
        Parent = v37,
        Children = {},
        OnClientEvent = Signal.New(),
        Maid = Maid.New(u1),
        self_creation = p35,
        write_lib = v36,
        set_listeners = {},
        write_listeners = {},
        changed_listeners = Signal.New()
    };
    local v39 = setmetatable(v38, u33);

    if v37 ~= nil then
        v37.Children[v39] = true;
    end;

    return v39;
end;

function u33.RequestData() -- Line: 238
    -- upvalues: u2 (ref), u8 (copy), u33 (copy)
    if u2 == true then
        return;
    end;

    u2 = true;
    task.spawn(function() -- Line: 246
        -- upvalues: u8 (ref), u33 (ref)
        u8:FireServer();

        while task.wait(2) and u33.IsReady ~= true do
            u8:FireServer();
        end;
    end);
end;

function u33.OnNew(p40, u41) -- Line: 261
    -- upvalues: u7 (copy), Signal (copy), u3 (copy), u30 (ref), RunEventHandlerInFreeThread (copy)
    if type(p40) ~= "string" then
        error((`[{script.Name}]: "token" must be a string`));
    end;

    local v42 = u7[p40];

    if v42 == nil then
        v42 = Signal.New();
        u7[p40] = v42;
    end;

    local v43 = u3[p40];
    local u44 = v42:Connect(u41);

    if v43 ~= nil then
        local u45 = {};

        for i in pairs(v43) do
            u45[i] = true;
        end;

        task.defer(function() -- Line: 285
            -- upvalues: u45 (copy), u44 (copy), u30 (ref), RunEventHandlerInFreeThread (ref), u41 (copy)
            for i in pairs(u45) do
                if u44.IsConnected ~= true then
                    break;
                end;

                if not u30 then
                    u30 = coroutine.create(RunEventHandlerInFreeThread);
                end;

                task.spawn(u30, u41, i);
            end;
        end);
    end;

    return u44;
end;

function u33.FromId(p46) -- Line: 303
    -- upvalues: u4 (copy)
    return u4[p46];
end;

function u33.Test() -- Line: 307
    -- upvalues: u3 (copy), u4 (copy), u5 (copy), u6 (copy)
    return {
        TokenReplicas = u3,
        Replicas = u4,
        BindReplicas = u5,
        BindInstances = u6
    };
end;

function u33.OnSet(p47, p48, p49) -- Line: 316
    -- upvalues: Signal (copy)
    local v50 = table.concat(p48, ".");
    local v51 = p47.set_listeners[v50];

    if v51 == nil then
        v51 = Signal.New();
        p47.set_listeners[v50] = v51;
    end;

    return v51:Connect(p49);
end;

function u33.OnWrite(p52, p53, p54) -- Line: 327
    -- upvalues: Signal (copy)
    local v55 = p52.write_listeners[p53];

    if v55 == nil then
        v55 = Signal.New();
        p52.write_listeners[p53] = v55;
    end;

    return v55:Connect(p54);
end;

function u33.OnChange(p56, p57) -- Line: 337
    return p56.changed_listeners:Connect(p57);
end;

function u33.GetChild(p58, p59) -- Line: 341
    if type(p59) ~= "string" then
        error((`[{script.Name}]: "token" must be a string`));
    end;

    for i in pairs(p58.Children) do
        if i.Token == p59 then
            return i;
        end;
    end;

    return nil;
end;

function u33.FireServer(p60, ...) -- Line: 353
    -- upvalues: u14 (copy)
    u14:FireServer(p60.Id, ...);
end;

function u33.UFireServer(p61, ...) -- Line: 357
    -- upvalues: u19 (copy)
    u19:FireServer(p61.Id, ...);
end;

function u33.Identify(p62) -- Line: 361
    local v63 = "";
    local v64 = true;

    for i, v in pairs(p62.Tags) do
        v63 = v63 .. `{v64 == true and "" or ";"}{tostring(i)}={tostring(v)}`;
        v64 = false;
    end;

    return `[Id:{p62.Id};Token:{p62.Token};Tags:[{v63}]]`;
end;

function u33.IsActive(p65) -- Line: 371
    return p65.Maid:IsActive();
end;

function u33.Set(p66, p67, p68) -- Line: 375
    -- upvalues: u21 (ref)
    if u21 ~= true then
        error((`[{script.Name}]: "Set()" can't be called outside of WriteLibs client-side`));
    end;

    local Data = p66.Data;

    for i = 1, #p67 - 1 do
        Data = Data[p67[i]];
    end;

    local v69 = p67[#p67];
    local v70 = Data[v69];
    Data[v69] = p68;

    if next(p66.set_listeners) ~= nil then
        local v71 = p66.set_listeners[table.concat(p67, ".")];

        if v71 ~= nil then
            v71:Fire(p68, v70);
        end;
    end;

    p66.changed_listeners:Fire("Set", p67, p68, v70);
end;

function u33.SetValues(p72, p73, p74) -- Line: 403
    -- upvalues: u21 (ref)
    if u21 ~= true then
        error((`[{script.Name}]: "SetValues()" can't be called outside of WriteLibs client-side`));
    end;

    local Data = p72.Data;

    for _, v in ipairs(p73) do
        Data = Data[v];
    end;

    for i, v in pairs(p74) do
        Data[i] = v;
    end;

    p72.changed_listeners:Fire("SetValues", p73, p74);
end;

function u33.TableInsert(p75, p76, p77, p78) -- Line: 425
    -- upvalues: u21 (ref)
    if u21 ~= true then
        error((`[{script.Name}]: "TableInsert()" can't be called outside of WriteLibs client-side`));
    end;

    local Data = p75.Data;

    for _, v in ipairs(p76) do
        Data = Data[v];
    end;

    if p78 == nil then
        table.insert(Data, p77);
        p78 = #Data;
    else
        table.insert(Data, p78, p77);
    end;

    p75.changed_listeners:Fire("TableInsert", p76, p77, p78);

    return p78;
end;

function u33.TableRemove(p79, p80, p81) -- Line: 452
    -- upvalues: u21 (ref)
    if u21 ~= true then
        error((`[{script.Name}]: "TableRemove()" can't be called outside of WriteLibs client-side`));
    end;

    local Data = p79.Data;

    for _, v in ipairs(p80) do
        Data = Data[v];
    end;

    local v82 = table.remove(Data, p81);
    p79.changed_listeners:Fire("TableRemove", p80, v82, p81);

    return v82;
end;

function u33.Write(p83, p84, ...) -- Line: 474
    -- upvalues: u21 (ref)
    if u21 ~= true then
        error((`[{script.Name}]: "Write()" can't be called outside of WriteLibs client-side`));
    end;

    local v85 = table.pack(p83.write_lib[p84].fn(p83, ...));
    local v86 = p83.write_listeners[p84];

    if v86 ~= nil then
        v86:Fire(...);
    end;

    return table.unpack(v85);
end;

local function DestroyReplica(p87, p88) -- Line: 496
    -- upvalues: DestroyReplica (copy), u3 (copy), u4 (copy), u5 (copy), u1 (copy)
    for i in pairs(p87.Children) do
        DestroyReplica(i, true);
    end;

    if p88 ~= true and p87.Parent ~= nil then
        p87.Parent.Children[p87] = nil;
    end;

    local Id = p87.Id;
    local v89 = u3[p87.Token];

    if v89 ~= nil then
        v89[p87] = nil;
    end;

    if u4[Id] == p87 then
        u4[Id] = nil;
    end;

    if u5[Id] == p87 then
        u5[Id] = nil;
    end;

    p87.Maid:Unlock(u1);
    p87.Maid:Cleanup();
    p87.BoundInstance = nil;
end;

local function ReplicaToBindBuffer(p90, p91) -- Line: 528
    -- upvalues: ReplicaNew (copy), u5 (copy), ReplicaToBindBuffer (copy), DestroyReplica (copy)
    local v92 = ReplicaNew(p90.Id, p90.self_creation);
    u5[p90.Id] = v92;

    for i in pairs(p90.Children) do
        ReplicaToBindBuffer(i, true);
    end;

    if p91 ~= true then
        DestroyReplica(p90);
    end;

    return v92;
end;

local function ReplicaFromBindBuffer(p93, p94) -- Line: 549
    -- upvalues: u5 (copy), u3 (copy), u4 (copy), ReplicaFromBindBuffer (copy), u7 (copy)
    local v95;

    if p94 == nil then
        p94 = {};
        v95 = true;
    else
        v95 = false;
    end;

    u5[p93.Id] = nil;
    local Token = p93.Token;
    local v96 = u3[Token];

    if v96 == nil then
        v96 = {};
        u3[Token] = v96;
    end;

    v96[p93] = true;
    u4[p93.Id] = p93;
    table.insert(p94, p93);

    for i in pairs(p93.Children) do
        ReplicaFromBindBuffer(i, p94);
    end;

    if v95 == true then
        for _, v in ipairs(p94) do
            local v97 = u7[v.Token];

            if v97 ~= nil then
                v97:Fire(v);
            end;
        end;
    end;
end;

local function CreationScan(p98, p99, p100) -- Line: 588
    -- upvalues: CreationScan (copy)
    local v101 = p98[p100];

    if v101 ~= nil then
        table.sort(v101, function(p102, p103) -- Line: 592
            return p102.Id < p103.Id;
        end);

        for _, v in ipairs(v101) do
            p99(v.Id, v.SelfCreation);
            CreationScan(p98, p99, v.Id);
        end;
    end;
end;

local function BreadthCreationSort(p104, p105, p106) -- Line: 604
    -- upvalues: CreationScan (copy)
    local v107 = {};
    local v108 = {};
    local v109 = {};

    if type(p104[1]) == "table" then
        for _, v in ipairs(p104) do
            for i, v2 in pairs(v) do
                local v110 = {
                    Id = tonumber(i),
                    SelfCreation = v2
                };
                local v111 = v2[4];

                if v111 == 0 or v110.Id == p105 then
                    table.insert(v107, v110);
                elseif v[tostring(v111)] == nil then
                    table.insert(v109, v110);
                else
                    local v112 = v108[v111];

                    if v112 == nil then
                        v112 = {};
                        v108[v111] = v112;
                    end;

                    table.insert(v112, v110);
                end;
            end;
        end;
    else
        for i, v in pairs(p104) do
            local v113 = {
                Id = tonumber(i),
                SelfCreation = v
            };
            local v114 = v[4];

            if v114 == 0 or v113.Id == p105 then
                table.insert(v107, v113);
            elseif p104[tostring(v114)] == nil then
                table.insert(v109, v113);
            else
                local v115 = v108[v114];

                if v115 == nil then
                    v115 = {};
                    v108[v114] = v115;
                end;

                table.insert(v115, v113);
            end;
        end;
    end;

    table.sort(v107, function(p116, p117) -- Line: 655
        return p116.Id < p117.Id;
    end);
    local v118 = {};

    for _, v in ipairs(v107) do
        p106(v.Id, v.SelfCreation);
        CreationScan(v108, p106, v.Id);
    end;

    if #v109 ~= 0 then
        local v119 = `[{script.Name}]: GROUP REPLICATION ERROR - Missing parents for:\n`;

        for i = 1, math.min(#v109, 50) do
            local v120 = v109[i];
            local SelfCreation = v120.SelfCreation;
            local v121 = "";
            local v122 = true;

            for i2, v in pairs(SelfCreation[2]) do
                v121 = v121 .. `{v122 == true and "" or ";"}{tostring(i2)}={tostring(v)}`;
                v122 = false;
            end;

            v119 = v119 .. `[Id:{v120.Id};ParentId:{SelfCreation[4]};Token:{SelfCreation[1]};Tags:[{v121}]]\n`;
        end;

        if #v109 > 50 then
            v119 = v119 .. `(hiding {50 - #v109} more)\n`;
        end;

        local _ = v119 .. "Traceback:\n" .. debug.traceback();
    end;

    return v118;
end;

local function GetInternalReplica(p123) -- Line: 695
    -- upvalues: u4 (copy), u5 (copy)
    local v124 = u4[p123] or u5[p123];

    if v124 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p123}]`));
    end;

    return v124;
end;

u8.OnClientEvent:Connect(function() -- Line: 705
    -- upvalues: u33 (copy)
    if u33.IsReady == true then
        return;
    end;

    u33.IsReady = true;
    u33.OnLocalReady:Fire();
end);
v9.OnClientEvent:Connect(function(p125, p126, p127) -- Line: 716
    -- upvalues: u4 (copy), u5 (copy), u21 (ref)
    local v128 = u4[p125] or u5[p125];

    if v128 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p125}]`));
    end;

    u21 = true;
    local success, result = pcall(v128.Set, v128, p126, p127);
    u21 = false;

    if success ~= true then
        error(`[{script.Name}]: Error while updating replica:\n{v128:Identify()}\n` .. result);
    end;
end);
v10.OnClientEvent:Connect(function(p129, p130, p131) -- Line: 726
    -- upvalues: u4 (copy), u5 (copy), u21 (ref)
    local v132 = u4[p129] or u5[p129];

    if v132 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p129}]`));
    end;

    u21 = true;
    local success, result = pcall(v132.SetValues, v132, p130, p131);
    u21 = false;

    if success ~= true then
        error(`[{script.Name}]: Error while updating replica:\n{v132:Identify()}\n` .. result);
    end;
end);
v11.OnClientEvent:Connect(function(p133, p134, p135, p136) -- Line: 736
    -- upvalues: u4 (copy), u5 (copy), u21 (ref)
    local v137 = u4[p133] or u5[p133];

    if v137 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p133}]`));
    end;

    u21 = true;
    local success, result = pcall(v137.TableInsert, v137, p134, p135, p136);
    u21 = false;

    if success ~= true then
        error(`[{script.Name}]: Error while updating replica:\n{v137:Identify()}\n` .. result);
    end;
end);
v12.OnClientEvent:Connect(function(p138, p139, p140) -- Line: 746
    -- upvalues: u4 (copy), u5 (copy), u21 (ref)
    local v141 = u4[p138] or u5[p138];

    if v141 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p138}]`));
    end;

    u21 = true;
    local success, result = pcall(v141.TableRemove, v141, p139, p140);
    u21 = false;

    if success ~= true then
        error(`[{script.Name}]: Error while updating replica:\n{v141:Identify()}\n` .. result);
    end;
end);
v13.OnClientEvent:Connect(function(p142, p143, ...) -- Line: 756
    -- upvalues: u4 (copy), u5 (copy), u21 (ref)
    local v144 = u4[p142] or u5[p142];

    if v144 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p142}]`));
    end;

    u21 = true;
    local success, result = pcall(v144.Write, v144, v144.write_lib[p143].Name, ...);
    u21 = false;

    if success ~= true then
        error(`[{script.Name}]: Error while updating replica:\n{v144:Identify()}\n` .. result);
    end;
end);

local function RemoteSignalHandle(p145, ...) -- Line: 767
    -- upvalues: u4 (copy), u5 (copy)
    local v146 = u4[p145] or u5[p145];

    if v146 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p145}]`));
    end;

    v146.OnClientEvent:Fire(...);
end;

u14.OnClientEvent:Connect(RemoteSignalHandle);
u19.OnClientEvent:Connect(RemoteSignalHandle);
v15.OnClientEvent:Connect(function(p147, p148) -- Line: 775
    -- upvalues: u4 (copy), u5 (copy), ReplicaFromBindBuffer (copy), ReplicaToBindBuffer (copy)
    local v149 = u4[p147] or u5[p147];

    if v149 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p147}]`));
    end;

    local Parent = v149.Parent;
    local v150 = u4[p148] or u5[p148];

    if v150 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p148}]`));
    end;

    Parent.Children[v149] = nil;
    v150.Children[v149] = true;
    v149.Parent = v150;
    v149.self_creation[4] = p148;

    if u5[Parent.Id] == nil or u4[p148] == nil then
        if u4[Parent.Id] ~= nil and u5[p148] ~= nil then
            ReplicaToBindBuffer(v149);
        end;

        return;
    end;

    ReplicaFromBindBuffer(v149);
end);
v16.OnClientEvent:Connect(function(p151, p152) -- Line: 796
    -- upvalues: BreadthCreationSort (copy), ReplicaNew (copy), u6 (copy), u5 (copy), u3 (copy), u4 (copy), u7 (copy)
    local u153 = {};
    BreadthCreationSort(p151, p152, function(p154, p155) -- Line: 800
        -- upvalues: ReplicaNew (ref), u6 (ref), u5 (ref), u3 (ref), u4 (ref), u153 (copy)
        local v156 = p155[4];
        local v157 = ReplicaNew(p154, p155);
        local v158 = false;

        if v156 == 0 then
            if v157.Tags.Bind == true then
                local v159 = u6[p154];
                v157.BoundInstance = v159;
                v158 = v159 == nil and true or v158;
            end;
        else
            v158 = u5[v156] ~= nil and true or v158;
        end;

        if v158 == true then
            u5[p154] = v157;

            return;
        end;

        local Token = v157.Token;
        local v160 = u3[Token];

        if v160 == nil then
            v160 = {};
            u3[Token] = v160;
        end;

        v160[v157] = true;
        u4[p154] = v157;
        table.insert(u153, v157);
    end);

    for _, v in ipairs(u153) do
        local v161 = u7[v.Token];

        if v161 ~= nil then
            v161:Fire(v);
        end;
    end;
end);
v17.OnClientEvent:Connect(function(p162) -- Line: 855
    -- upvalues: u4 (copy), u5 (copy), u6 (copy), ReplicaToBindBuffer (copy)
    local v163 = u4[p162] or u5[p162];

    if v163 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p162}]`));
    end;

    v163.Tags.Bind = true;
    local v164 = u6[p162];
    v163.BoundInstance = v164;

    if v164 == nil then
        ReplicaToBindBuffer(v163);
    end;
end);
v18.OnClientEvent:Connect(function(p165) -- Line: 869
    -- upvalues: u4 (copy), u5 (copy), DestroyReplica (copy)
    local v166 = u4[p165] or u5[p165];

    if v166 == nil then
        error((`[{script.Name}]: Received update for missing replica [Id:{p165}]`));
    end;

    DestroyReplica(v166);
end);

local function OnBindInstanceAdded(p167) -- Line: 876
    -- upvalues: u6 (copy), u5 (copy), ReplicaFromBindBuffer (copy)
    local Value = p167.Value;
    local Parent = p167.Parent;
    u6[Value] = Parent;
    local v168 = u5[Value];

    if v168 ~= nil then
        v168.BoundInstance = Parent;
        ReplicaFromBindBuffer(v168);
    end;
end;

local function OnBindInstanceRemoved(p169) -- Line: 891
    -- upvalues: u6 (copy), u4 (copy), ReplicaToBindBuffer (copy)
    local Value = p169.Value;
    u6[Value] = nil;
    local v170 = u4[Value];

    if v170 ~= nil then
        ReplicaToBindBuffer(v170);
    end;
end;

CollectionService:GetInstanceAddedSignal("REPLICA"):Connect(function(p171) -- Line: 904
    -- upvalues: u6 (copy), u5 (copy), ReplicaFromBindBuffer (copy)
    if p171:IsA("NumberValue") == true then
        local Value = p171.Value;
        local Parent = p171.Parent;
        u6[Value] = Parent;
        local v172 = u5[Value];

        if v172 ~= nil then
            v172.BoundInstance = Parent;
            ReplicaFromBindBuffer(v172);
        end;
    end;
end);
CollectionService:GetInstanceRemovedSignal("REPLICA"):Connect(function(p173) -- Line: 910
    -- upvalues: u6 (copy), u4 (copy), ReplicaToBindBuffer (copy)
    if p173:IsA("NumberValue") == true then
        local Value = p173.Value;
        u6[Value] = nil;
        local v174 = u4[Value];

        if v174 ~= nil then
            ReplicaToBindBuffer(v174);
        end;
    end;
end);

for _, v in pairs(CollectionService:GetTagged("REPLICA")) do
    if v:IsA("NumberValue") == true then
        local Value = v.Value;
        local Parent = v.Parent;
        u6[Value] = Parent;
        local v175 = u5[Value];

        if v175 ~= nil then
            v175.BoundInstance = Parent;
            ReplicaFromBindBuffer(v175);
        end;
    end;
end;

return u33;