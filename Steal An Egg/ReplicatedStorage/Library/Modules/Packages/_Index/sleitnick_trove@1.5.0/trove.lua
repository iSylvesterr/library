-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = newproxy();
local u2 = newproxy();
local u3 = table.freeze({ "Destroy", "Disconnect", "destroy", "disconnect" });

local function GetObjectCleanupFunction(p4, p5) -- Line: 128
    -- upvalues: u1 (copy), u2 (copy), u3 (copy)
    local v6 = typeof(p4);

    if v6 == "function" then
        return u1;
    end;

    if v6 == "thread" then
        return u2;
    end;

    if p5 then
        return p5;
    end;

    if v6 == "Instance" or v6 == "Object" then
        return "Destroy";
    end;

    if v6 == "RBXScriptConnection" then
        return "Disconnect";
    end;

    if v6 == "table" then
        for _, v in u3 do
            if typeof(p4[v]) == "function" then
                return v;
            end;
        end;
    end;

    error(`failed to get cleanup function for object {v6}: {p4}`, 3);
end;

local function AssertPromiseLike(p7) -- Line: 156
    if typeof(p7) ~= "table" or (typeof(p7.getStatus) ~= "function" or (typeof(p7.finally) ~= "function" or typeof(p7.cancel) ~= "function")) then
        error("did not receive a promise as an argument", 3);
    end;
end;

local u8 = {};
u8.__index = u8;

function u8.new() -- Line: 183
    -- upvalues: u8 (copy)
    local v9 = setmetatable({}, u8);
    v9._objects = {};
    v9._cleaning = false;

    return v9;
end;

function u8.is(p10) -- Line: 197
    -- upvalues: u8 (copy)
    if typeof(p10) == "table" then
        return getmetatable(p10) == u8;
    end;

    return false;
end;

function u8.Add(p11, p12, p13) -- Line: 254
    -- upvalues: GetObjectCleanupFunction (copy)
    if p11._cleaning then
        error("cannot call trove:Add() while cleaning", 2);
    end;

    local v14 = { p12, (GetObjectCleanupFunction(p12, p13)) };
    table.insert(p11._objects, v14);

    return p12;
end;

function u8.Clone(p15, p16) -- Line: 276
    if p15._cleaning then
        error("cannot call trove:Clone() while cleaning", 2);
    end;

    return p15:Add(p16:Clone());
end;

function u8.Construct(p17, p18, ...) -- Line: 319
    if p17._cleaning then
        error("Cannot call trove:Construct() while cleaning", 2);
    end;

    local v19 = nil;
    local v20 = type(p18);

    if v20 == "table" then
        v19 = p18.new(...);
    elseif v20 == "function" then
        v19 = p18(...);
    end;

    return p17:Add(v19);
end;

function u8.Connect(p21, p22, p23) -- Line: 352
    if p21._cleaning then
        error("Cannot call trove:Connect() while cleaning", 2);
    end;

    return p21:Add(p22:Connect(p23));
end;

function u8.BindToRenderStep(p24, u25, p26, p27) -- Line: 375
    -- upvalues: RunService (copy)
    if p24._cleaning then
        error("cannot call trove:BindToRenderStep() while cleaning", 2);
    end;

    RunService:BindToRenderStep(u25, p26, p27);
    p24:Add(function() -- Line: 382
        -- upvalues: RunService (ref), u25 (copy)
        RunService:UnbindFromRenderStep(u25);
    end);
end;

function u8.AddPromise(u28, u29) -- Line: 412
    if u28._cleaning then
        error("cannot call trove:AddPromise() while cleaning", 2);
    end;

    if typeof(u29) ~= "table" or (typeof(u29.getStatus) ~= "function" or (typeof(u29.finally) ~= "function" or typeof(u29.cancel) ~= "function")) then
        error("did not receive a promise as an argument", 3);
    end;

    if u29:getStatus() == "Started" then
        u29:finally(function() -- Line: 419
            -- upvalues: u28 (copy), u29 (copy)
            if u28._cleaning then
                return;
            end;

            u28:_findAndRemoveFromObjects(u29, false);
        end);
        u28:Add(u29, "cancel");
    end;

    return u29;
end;

function u8.Remove(p30, p31, ...) -- Line: 444
    if p30._cleaning then
        error("cannot call trove:Remove() while cleaning", 2);
    end;

    return p30:_findAndRemoveFromObjects(p31, true, ...);
end;

function u8.Extend(p32) -- Line: 473
    -- upvalues: u8 (copy)
    if p32._cleaning then
        error("cannot call trove:Extend() while cleaning", 2);
    end;

    return p32:Construct(u8);
end;

function u8.Clean(p33) -- Line: 493
    if p33._cleaning then
        return;
    end;

    p33._cleaning = true;

    for _, v in p33._objects do
        p33:_cleanupObject(v[1], v[2]);
    end;

    table.clear(p33._objects);
    p33._cleaning = false;
end;

function u8.WrapClean(u34) -- Line: 535
    return function() -- Line: 536
        -- upvalues: u34 (copy)
        u34:Clean();
    end;
end;

function u8._findAndRemoveFromObjects(p35, p36, p37, ...) -- Line: 541
    local _objects = p35._objects;

    for i, v in _objects do
        if v[1] == p36 then
            local v38 = #_objects;
            _objects[i] = _objects[v38];
            _objects[v38] = nil;

            if p37 then
                p35:_cleanupObject(v[1], v[2], ...);
            end;

            return true;
        end;
    end;

    return false;
end;

function u8._cleanupObject(p39, p40, p41, ...) -- Line: 561
    -- upvalues: u1 (copy), u2 (copy)
    if p41 == u1 then
        task.spawn(p40);

        return;
    end;

    if p41 == u2 then
        pcall(task.cancel, p40);

        return;
    end;

    if typeof(p41) == "function" then
        p41(p40, ...);

        return;
    end;

    p40[p41](p40);
end;

function u8.AttachToInstance(u42, p43) -- Line: 603
    if u42._cleaning then
        error("cannot call trove:AttachToInstance() while cleaning", 2);
    elseif not p43:IsDescendantOf(game) then
        error("instance is not a descendant of the game hierarchy", 2);
    end;

    return u42:Connect(p43.Destroying, function() -- Line: 610
        -- upvalues: u42 (copy)
        u42:Destroy();
    end);
end;

function u8.Destroy(p44) -- Line: 624
    p44:Clean();
end;

return {
    new = u8.new,
    is = u8.is
};