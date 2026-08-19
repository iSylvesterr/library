-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = newproxy();
local u2 = newproxy();
local u3 = table.freeze({ "Destroy", "Disconnect", "destroy", "disconnect" });

local function getObjectCleanupFunction(p4, p5) -- Line: 126
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

    if v6 == "Instance" then
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

local function assertPromiseLike(p7) -- Line: 154
    if typeof(p7) ~= "table" or (typeof(p7.getStatus) ~= "function" or (typeof(p7.finally) ~= "function" or typeof(p7.cancel) ~= "function")) then
        error("did not receive a promise as an argument", 3);
    end;
end;

local function assertSignalLike(p8) -- Line: 165
    if typeof(p8) ~= "RBXScriptSignal" and (typeof(p8) ~= "table" or (typeof(p8.Connect) ~= "function" or typeof(p8.Once) ~= "function")) then
        error("did not receive a signal as an argument", 3);
    end;
end;

local u9 = {};
u9.__index = u9;

function u9.new() -- Line: 177
    -- upvalues: u9 (copy)
    local v10 = setmetatable({}, u9);
    v10._objects = {};
    v10._cleaning = false;

    return v10;
end;

function u9.Add(p11, p12, p13) -- Line: 186
    -- upvalues: getObjectCleanupFunction (copy)
    if p11._cleaning then
        error("cannot call trove:Add() while cleaning", 2);
    end;

    local v14 = { p12, (getObjectCleanupFunction(p12, p13)) };
    table.insert(p11._objects, v14);

    return p12;
end;

function u9.Clone(p15, p16) -- Line: 197
    if p15._cleaning then
        error("cannot call trove:Clone() while cleaning", 2);
    end;

    return p15:Add(p16:Clone());
end;

function u9.Construct(p17, p18, ...) -- Line: 205
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

function u9.Connect(p21, p22, p23) -- Line: 221
    if p21._cleaning then
        error("Cannot call trove:Connect() while cleaning", 2);
    end;

    if typeof(p22) ~= "RBXScriptSignal" and (typeof(p22) ~= "table" or (typeof(p22.Connect) ~= "function" or typeof(p22.Once) ~= "function")) then
        error("did not receive a signal as an argument", 3);
    end;

    return p21:Add(p22:Connect(p23));
end;

function u9.Once(u24, p25, u26) -- Line: 236
    if u24._cleaning then
        error("Cannot call trove:Connect() while cleaning", 2);
    end;

    if typeof(p25) ~= "RBXScriptSignal" and (typeof(p25) ~= "table" or (typeof(p25.Connect) ~= "function" or typeof(p25.Once) ~= "function")) then
        error("did not receive a signal as an argument", 3);
    end;

    local u27 = nil;
    u27 = p25:Once(function(...) -- Line: 249
        -- upvalues: u26 (copy), u24 (copy), u27 (ref)
        u26(...);
        u24:Pop(u27);
    end);

    return u24:Add(u27);
end;

function u9.BindToRenderStep(p28, u29, p30, p31) -- Line: 257
    -- upvalues: RunService (copy)
    if p28._cleaning then
        error("cannot call trove:BindToRenderStep() while cleaning", 2);
    end;

    RunService:BindToRenderStep(u29, p30, p31);
    p28:Add(function() -- Line: 264
        -- upvalues: RunService (ref), u29 (copy)
        RunService:UnbindFromRenderStep(u29);
    end);
end;

function u9.AddPromise(u32, u33) -- Line: 269
    if u32._cleaning then
        error("cannot call trove:AddPromise() while cleaning", 2);
    end;

    if typeof(u33) ~= "table" or (typeof(u33.getStatus) ~= "function" or (typeof(u33.finally) ~= "function" or typeof(u33.cancel) ~= "function")) then
        error("did not receive a promise as an argument", 3);
    end;

    if u33:getStatus() == "Started" then
        u33:finally(function() -- Line: 277
            -- upvalues: u32 (copy), u33 (copy)
            if u32._cleaning then
                return;
            end;

            u32:_findAndRemoveFromObjects(u33, false);
        end);
        u32:Add(u33, "cancel");
    end;

    return u33;
end;

function u9.Remove(p34, p35) -- Line: 290
    if p34._cleaning then
        error("cannot call trove:Remove() while cleaning", 2);
    end;

    return p34:_findAndRemoveFromObjects(p35, true);
end;

function u9.Pop(p36, p37) -- Line: 298
    if p36._cleaning then
        error("cannot call trove:Pop() while cleaning", 2);
    end;

    return p36:_findAndRemoveFromObjects(p37, false);
end;

function u9.Extend(p38) -- Line: 306
    -- upvalues: u9 (copy)
    if p38._cleaning then
        error("cannot call trove:Extend() while cleaning", 2);
    end;

    return p38:Construct(u9);
end;

function u9.Clean(p39) -- Line: 314
    if p39._cleaning then
        return;
    end;

    p39._cleaning = true;

    for _, v in p39._objects do
        p39:_cleanupObject(v[1], v[2]);
    end;

    table.clear(p39._objects);
    p39._cleaning = false;
end;

function u9.WrapClean(u40) -- Line: 329
    return function() -- Line: 330
        -- upvalues: u40 (copy)
        u40:Clean();
    end;
end;

function u9._findAndRemoveFromObjects(p41, p42, p43) -- Line: 335
    local _objects = p41._objects;

    for i, v in _objects do
        if v[1] == p42 then
            local v44 = #_objects;
            _objects[i] = _objects[v44];
            _objects[v44] = nil;

            if p43 then
                p41:_cleanupObject(v[1], v[2]);
            end;

            return true;
        end;
    end;

    return false;
end;

function u9._cleanupObject(p45, p46, p47) -- Line: 355
    -- upvalues: u1 (copy), u2 (copy)
    if p47 == u1 then
        task.spawn(p46);

        return;
    end;

    if p47 == u2 then
        pcall(task.cancel, p46);

        return;
    end;

    p46[p47](p46);
end;

function u9.AttachToInstance(u48, p49) -- Line: 365
    if u48._cleaning then
        error("cannot call trove:AttachToInstance() while cleaning", 2);
    elseif not p49:IsDescendantOf(game) then
        error("instance is not a descendant of the game hierarchy", 2);
    end;

    return u48:Connect(p49.Destroying, function() -- Line: 372
        -- upvalues: u48 (copy)
        u48:Destroy();
    end);
end;

function u9.Destroy(p50) -- Line: 377
    p50:Clean();
end;

return {
    new = u9.new
};