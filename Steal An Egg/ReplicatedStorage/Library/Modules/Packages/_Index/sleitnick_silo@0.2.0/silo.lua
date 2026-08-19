-- Decompiled with Potassium's decompiler.

local TableWatcher = require(script.TableWatcher);
local Util = require(script.Util);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3) -- Line: 86
    -- upvalues: u1 (copy), Util (copy), TableWatcher (copy)
    local v4 = setmetatable({}, u1);
    v4._DefaultState = Util.DeepFreeze(Util.DeepCopy(p2));
    v4._State = Util.DeepFreeze(Util.DeepCopy(p2));
    v4._Modifiers = {};
    v4._Dispatching = false;
    v4._Parent = v4;
    v4._Subscribers = {};
    v4.Actions = {};

    if p3 then
        for i, v in p3 do
            v4._Modifiers[i] = function(p5, p6) -- Line: 101
                -- upvalues: TableWatcher (ref), v (copy)
                local v7 = TableWatcher(p5);
                v(v7, p6);

                return v7();
            end;

            v4.Actions[i] = function(p8) -- Line: 109
                -- upvalues: i (copy)
                return {
                    Name = i,
                    Payload = p8
                };
            end;
        end;
    end;

    return v4;
end;

function u1.combine(p9, p10) -- Line: 126
    -- upvalues: u1 (copy), Util (copy)
    local v11 = {};

    for i, v in p9 do
        if v._Dispatching then
            error("cannot combine silos from a modifier", 2);
        end;

        v11[i] = v:GetState();
    end;

    local v12 = u1.new(Util.Extend(v11, p10 or {}));

    for i, v in p9 do
        v._Parent = v12;

        for i2, v2 in v._Modifiers do
            local v13 = `{i}/{i2}`;

            v12._Modifiers[v13] = function(p14, p15) -- Line: 144
                -- upvalues: Util (ref), i (copy), v2 (copy)
                return Util.Extend(p14, {
                    [i] = v2(p14[i], p15)
                });
            end;
        end;

        for i2 in v.Actions do
            if v12.Actions[i2] ~= nil then
                error(`duplicate action name {i2} found when combining silos`, 2);
            end;

            local u16 = `{i}/{i2}`;

            v.Actions[i2] = function(p17) -- Line: 157
                -- upvalues: u16 (copy)
                return {
                    Name = u16,
                    Payload = p17
                };
            end;

            v12.Actions[i2] = v.Actions[i2];
        end;
    end;

    return v12;
end;

function u1.GetState(p18) -- Line: 177
    if p18._Parent ~= p18 then
        error("can only get state from top-level silo", 2);
    end;

    return p18._State;
end;

function u1.Dispatch(p19, p20) -- Line: 191
    -- upvalues: Util (copy)
    if p19._Dispatching then
        error("cannot dispatch from a modifier", 2);
    end;

    if p19._Parent ~= p19 then
        error("can only dispatch from top-level silo", 2);
    end;

    p19._Dispatching = true;
    local _State = p19._State;
    local v21 = p19._Modifiers[p20.Name];
    local v22;

    if v21 then
        v22 = v21(_State, p20.Payload);
    else
        v22 = _State;
    end;

    p19._Dispatching = false;

    if v22 ~= _State then
        p19._State = Util.DeepFreeze(v22);

        for _, v in p19._Subscribers do
            v(v22, _State);
        end;
    end;
end;

function u1.Subscribe(u23, u24) -- Line: 235
    if u23._Dispatching then
        error("cannot subscribe from within a modifier", 2);
    end;

    if u23._Parent ~= u23 then
        error("can only subscribe on top-level silo", 2);
    end;

    if table.find(u23._Subscribers, u24) then
        error("cannot subscribe same function more than once", 2);
    end;

    table.insert(u23._Subscribers, u24);

    return function() -- Line: 249
        -- upvalues: u23 (copy), u24 (copy)
        local v25 = table.find(u23._Subscribers, u24);

        if not v25 then
            return;
        end;

        table.remove(u23._Subscribers, v25);
    end;
end;

function u1.Watch(p26, u27, u28) -- Line: 276
    local u29 = u27(p26:GetState());
    local v32 = p26:Subscribe(function(p30) -- Line: 279
        -- upvalues: u27 (copy), u29 (ref), u28 (copy)
        local v31 = u27(p30);

        if v31 == u29 then
            return;
        end;

        u29 = v31;
        u28(u29);
    end);
    u28(u29);

    return v32;
end;

function u1.ResetToDefaultState(p33) -- Line: 315
    -- upvalues: Util (copy)
    if p33._Dispatching then
        error("cannot reset state from within a modifier", 2);
    end;

    if p33._Parent ~= p33 then
        error("can only reset state on top-level silo", 2);
    end;

    local _State = p33._State;

    if p33._DefaultState ~= _State then
        p33._State = Util.DeepFreeze(Util.DeepCopy(p33._DefaultState));

        for _, v in p33._Subscribers do
            v(p33._State, _State);
        end;
    end;
end;

return {
    new = u1.new,
    combine = u1.combine
};