-- Decompiled with Potassium's decompiler.

local Functions = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Functions");
local BinarySearch = require(Functions.BinarySearch);
local wcall = require(Functions.wcall);
local Asserts = require(Functions.Parent.Asserts);
local u1 = {
    DefaultPriority = 0
};
local u2 = {};

local function compareFn(p3, p4) -- Line: 50
    return p3._priority - p4._priority;
end;

function u2.Disconnect(p5) -- Line: 55
    -- upvalues: BinarySearch (copy), compareFn (copy)
    p5._fn = nil;
    local _container = p5._container;

    if _container then
        p5._container = nil;
        BinarySearch.Remove(_container._list, compareFn, p5);
    end;
end;

function u2.IsConnected(p6) -- Line: 65
    return p6._container ~= nil;
end;

local u37 = {
    _safeBackwardPropagateCallback = function(p7, p8, ...) -- Line: 72, Name: _safeBackwardPropagateCallback
        -- upvalues: Asserts (copy)
        Asserts.func(p8);

        for i = #p7._list, 1, -1 do
            local v9 = p7._list[i];

            if v9 then
                p8(v9, ...);
            end;
        end;

        return p7;
    end,

    Connect = function(p10, p11, p12) -- Line: 88
        -- upvalues: Asserts (copy), u1 (copy), u2 (copy), BinarySearch (copy), compareFn (copy)
        Asserts.func(p11);
        local v13 = p12 == nil and true or type(p12) == "number";
        assert(v13, "Priority must be a number or nil");
        local v14 = setmetatable({
            _container = p10,
            _priority = p12 or u1.DefaultPriority,
            _fn = p11
        }, {
            __index = u2
        });
        BinarySearch.InsertRight(p10._list, compareFn, v14);

        return v14;
    end,

    Wait = function(p15, p16) -- Line: 105
        local u17 = nil;
        local u18 = nil;
        u18 = p15:Connect(function(...) -- Line: 109
            -- upvalues: u18 (ref), u17 (ref)
            u18:Disconnect();

            if not u17 then
                u17 = table.pack(...);
            end;
        end, p16);

        while not u17 and u18:IsConnected() do
            task.wait();
        end;

        u18:Disconnect();

        return table.unpack(u17 or {});
    end,

    WaitTimed = function(p19, p20, p21) -- Line: 125
        -- upvalues: Asserts (copy)
        Asserts.number(p20);
        local u22 = nil;
        local u23 = nil;
        u23 = p19:Connect(function(...) -- Line: 131
            -- upvalues: u23 (ref), u22 (ref)
            u23:Disconnect();

            if not u22 then
                u22 = table.pack(...);
            end;
        end, p21);
        local v24 = os.clock() + p20;

        while not u22 and (u23:IsConnected() and os.clock() < v24) do
            task.wait();
        end;

        u23:Disconnect();

        return table.unpack(u22 or {});
    end,

    UnprotectedInvokeSync = function(p25, ...) -- Line: 149
        p25:_safeBackwardPropagateCallback(function(p26, ...) -- Line: 150
            local _fn = p26._fn;

            if _fn then
                local v27 = table.pack(_fn(...));

                if #v27 > 0 then
                    return table.unpack(v27);
                end;
            end;
        end, ...);
    end,

    InvokeSync = function(p28, ...) -- Line: 162
        -- upvalues: wcall (copy)
        p28:_safeBackwardPropagateCallback(function(p29, ...) -- Line: 163
            -- upvalues: wcall (ref)
            local _fn = p29._fn;

            if _fn then
                local v30, v31 = table.unpack(wcall(_fn, ...));

                if v30 and v31 then
                    return v31;
                end;
            end;
        end, ...);
    end,

    FireAsync = function(p32, ...) -- Line: 175
        p32:_safeBackwardPropagateCallback(function(p33, ...) -- Line: 176
            local _fn = p33._fn;

            if _fn then
                task.spawn(_fn, ...);
            end;
        end, ...);
    end,

    Clean = function(p34) -- Line: 185
        p34:_safeBackwardPropagateCallback(function(p35) -- Line: 186
            p35:Disconnect();
        end);
        table.clear(p34._list);
    end,

    Destroy = function(p36) -- Line: 194
        p36:Clean();
        table.clear(p36);
        setmetatable(p36, nil);
    end
};

function u1.new() -- Line: 201
    -- upvalues: u37 (copy)
    return setmetatable({
        _list = {}
    }, {
        __index = u37
    });
end;

function u1.IsA(p38) -- Line: 210
    -- upvalues: u37 (copy)
    if type(p38) ~= "table" then
        return false;
    end;

    local v39 = getmetatable(p38);
    local v40;

    if type(v39) == "table" then
        v40 = v39.__index == u37;
    else
        v40 = false;
    end;

    return v40;
end;

return u1;