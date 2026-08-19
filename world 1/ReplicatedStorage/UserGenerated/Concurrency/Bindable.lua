-- Decompiled with Potassium's decompiler.

local function ErrorHandler(p1) -- Line: 107
    warn((`{tostring(p1)}\nStack Begin\n{debug.traceback(nil, 3)}Stack End`));
end;

local function WCall(p2, ...) -- Line: 111
    -- upvalues: ErrorHandler (copy)
    return xpcall(p2, ErrorHandler, ...);
end;

local function FindRight(p3, p4) -- Line: 122
    local v5 = #p3;
    local v6 = 1;
    local v7 = false;

    while v6 <= v5 do
        local v8 = v6 + (v5 - v6) // 2;
        local v9 = p3[v8].Pr - p4.Pr;

        if v9 > 0 then
            v5 = v8 - 1;
        elseif v9 < 0 then
            v6 = v8 + 1;
        else
            v6 = v8 + 1;
            v7 = true;
        end;
    end;

    return v7 and v6 and v6 or -v6;
end;

local function FindLeft(p10, p11) -- Line: 149
    local v12 = #p10;
    local v13 = 1;
    local v14 = false;

    while v13 <= v12 do
        local v15 = v13 + (v12 - v13) // 2;
        local v16 = p10[v15].Pr - p11.Pr;

        if v16 > 0 then
            v12 = v15 - 1;
        elseif v16 < 0 then
            v13 = v15 + 1;
        else
            v12 = v15 - 1;
            v14 = true;
        end;
    end;

    return v14 and v13 and v13 or -v13;
end;

local function InsertRight(p17, p18) -- Line: 175
    -- upvalues: FindRight (copy)
    local v19 = FindRight(p17, p18);
    local v20 = math.abs(v19);
    table.insert(p17, v20, p18);

    return v20;
end;

local function Remove(p21, p22) -- Line: 188
    -- upvalues: FindLeft (copy)
    local v23 = FindLeft(p21, p22);

    if v23 > 0 then
        for i = v23, #p21 do
            if p21[i] == p22 then
                table.remove(p21, i);

                return true;
            end;
        end;
    end;

    return false;
end;

local function Connection_Disconnect(p24) -- Line: 209
    -- upvalues: Remove (copy)
    local Ow = p24.Ow;

    if Ow ~= nil then
        p24.Ow = nil;

        if not Remove(Ow.Cs, p24) then
            warn("BindableConnectionDisconnect");
        end;

        for _, v in ipairs(p24.Wt) do
            task.spawn(v);
        end;

        table.clear(p24.Wt);
    end;
end;

local v27 = table.freeze({
    IsConnected = function(p25) -- Line: 205, Name: Connection_IsConnected
        return p25.Ow ~= nil;
    end,

    Disconnect = Connection_Disconnect,

    GetPriority = function(p26) -- Line: 223, Name: Connection_GetPriority
        return p26.Pr;
    end
});
local u28 = table.freeze({
    __index = v27
});

local function Connection_new(p29, p30, p31) -- Line: 235
    -- upvalues: u28 (copy)
    return setmetatable({
        Ow = p29,
        Cb = p30,
        Pr = p31,
        Wt = {}
    }, u28);
end;

local v74 = table.freeze({
    Fire = function(p32, ...) -- Line: 278, Name: Bindable_Fire
        local Cs = p32.Cs;
        local v33 = 1;

        while v33 <= #Cs do
            local v34 = Cs[v33];
            task.spawn(v34.Cb, ...);

            if Cs[v33] == v34 then
                v33 = v33 + 1;
            end;
        end;
    end,

    FireAndWait = function(p35, ...) -- Line: 292, Name: Bindable_FireAndWait
        -- upvalues: WCall (copy)
        local Cs = p35.Cs;

        if #Cs == 0 then
            return;
        end;

        local u36 = 1;
        local u37 = coroutine.running();

        local function executor(p38, ...) -- Line: 299
            -- upvalues: WCall (ref), u36 (ref), u37 (copy)
            WCall(p38, ...);
            u36 = u36 - 1;

            if u36 == 0 then
                task.spawn(u37);
            end;
        end;

        local v39 = 1;

        while v39 <= #Cs do
            local v40 = Cs[v39];
            u36 = u36 + 1;
            task.spawn(executor, v40.Cb, ...);

            if Cs[v39] == v40 then
                v39 = v39 + 1;
            end;
        end;

        u36 = u36 - 1;

        if u36 > 0 then
            coroutine.yield();
        end;
    end,

    FireSync = function(p41, ...) -- Line: 321, Name: Bindable_FireSync
        -- upvalues: WCall (copy)
        local Cs = p41.Cs;
        local v42 = 1;

        while v42 <= #Cs do
            local v43 = Cs[v42];
            WCall(v43.Cb, ...);

            if Cs[v42] == v43 then
                v42 = v42 + 1;
            end;
        end;
    end,

    Invoke = function(p44, ...) -- Line: 333, Name: Bindable_Invoke
        local Cs = p44.Cs;

        if #Cs >= 1 then
            return Cs[1].Cb(...);
        end;

        error("Invoke");
    end,

    Connect = function(p45, p46, p47) -- Line: 261, Name: Bindable_Connect
        -- upvalues: u28 (copy), FindRight (copy)
        local v48;

        if p47 == nil then
            v48 = true;
        elseif type(p47) == "number" then
            v48 = p47 == p47;
        else
            v48 = false;
        end;

        assert(v48);
        local v49 = p47 or (1 / 0);
        local v50 = setmetatable({
            Ow = p45,
            Cb = p46,
            Pr = v49,
            Wt = {}
        }, u28);

        if v49 == (1 / 0) then
            table.insert(p45.Cs, v50);

            return v50;
        end;

        local Cs = p45.Cs;
        local v51 = FindRight(Cs, v50);
        local v52 = math.abs(v51);
        table.insert(Cs, v52, v50);

        return v50;
    end,

    Wait = function(p53) -- Line: 344, Name: Bindable_Wait
        -- upvalues: Connection_Disconnect (copy), u28 (copy)
        local u54 = coroutine.running();
        local u55 = true;
        local u56 = nil;

        local function v58(...) -- Line: 348
            -- upvalues: u56 (ref), u54 (copy), u55 (ref), Connection_Disconnect (ref)
            local v57 = table.find(u56.Wt, u54);

            if v57 then
                table.remove(u56.Wt, v57);
            end;

            u55 = false;
            Connection_Disconnect(u56);
            task.spawn(u54, ...);
        end;

        assert(true);
        local v59 = setmetatable({
            Pr = (1 / 0),
            Ow = p53,
            Cb = v58,
            Wt = {}
        }, u28);
        table.insert(p53.Cs, v59);
        u56 = v59;
        table.insert(u56.Wt, u54);
        local v60 = table.pack(coroutine.yield());

        if u55 then
            error("Disconnected");
        end;

        return table.unpack(v60);
    end,

    Once = function(p61, u62, p63) -- Line: 365, Name: Bindable_Once
        -- upvalues: Connection_Disconnect (copy), u28 (copy), FindRight (copy)
        local u64 = nil;

        local function v65(...) -- Line: 371
            -- upvalues: Connection_Disconnect (ref), u64 (ref), u62 (copy)
            Connection_Disconnect(u64);

            return u62(...);
        end;

        local v66;

        if p63 == nil then
            v66 = true;
        elseif type(p63) == "number" then
            v66 = p63 == p63;
        else
            v66 = false;
        end;

        assert(v66);
        local v67 = p63 or (1 / 0);
        local v68 = setmetatable({
            Ow = p61,
            Cb = v65,
            Pr = v67,
            Wt = {}
        }, u28);

        if v67 == (1 / 0) then
            table.insert(p61.Cs, v68);
        else
            local Cs = p61.Cs;
            local v69 = FindRight(Cs, v68);
            local v70 = math.abs(v69);
            table.insert(Cs, v70, v68);
        end;

        u64 = v68;

        return u64;
    end,

    DisconnectAll = function(p71) -- Line: 378, Name: Bindable_DisconnectAll
        -- upvalues: Connection_Disconnect (copy)
        local Cs = p71.Cs;

        for i = #Cs, 1, -1 do
            Connection_Disconnect(Cs[i]);
        end;
    end,

    GetSize = function(p72) -- Line: 385, Name: Bindable_GetSize
        return #p72.Cs;
    end,

    IsEmpty = function(p73) -- Line: 389, Name: Bindable_IsEmpty
        return #p73.Cs == 0;
    end
});
local u75 = table.freeze({
    __index = v74
});

return table.freeze({
    new = function(p76) -- Line: 408, Name: new
        -- upvalues: u75 (copy)
        return table.freeze((setmetatable({
            Cs = {}
        }, u75)));
    end,

    IsA = function(p77) -- Line: 421, Name: IsA
        -- upvalues: u75 (copy)
        local v78;

        if type(p77) == "table" then
            v78 = getmetatable(p77) == u75;
        else
            v78 = false;
        end;

        return v78;
    end,

    Assert = function(p79) -- Line: 425, Name: Assert
        -- upvalues: u75 (copy)
        local v80;

        if type(p79) == "table" then
            v80 = getmetatable(p79) == u75;
        else
            v80 = false;
        end;

        if not v80 then
            error("Bindable", 2);
        end;

        return p79;
    end,

    IsAConnection = function(p81) -- Line: 249, Name: Connection_IsA
        -- upvalues: u28 (copy)
        local v82;

        if type(p81) == "table" then
            v82 = getmetatable(p81) == u28;
        else
            v82 = false;
        end;

        return v82;
    end,

    AssertConnection = function(p83) -- Line: 253, Name: Connection_Assert
        -- upvalues: u28 (copy)
        local v84;

        if type(p83) == "table" then
            v84 = getmetatable(p83) == u28;
        else
            v84 = false;
        end;

        if not v84 then
            error("Connection", 2);
        end;

        return p83;
    end
});