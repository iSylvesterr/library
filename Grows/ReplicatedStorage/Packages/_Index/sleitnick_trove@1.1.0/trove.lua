-- Decompiled with Potassium's decompiler.

local u1 = newproxy();
local u2 = newproxy();
local u3 = { "Destroy", "Disconnect", "destroy", "disconnect" };
local RunService = game:GetService("RunService");

local function GetObjectCleanupFunction(p4, p5) -- Line: 11
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

    error("Failed to get cleanup function for object " .. v6 .. ": " .. tostring(p4), 3);
end;

local function AssertPromiseLike(p7) -- Line: 35
    if typeof(p7) ~= "table" or (typeof(p7.getStatus) ~= "function" or (typeof(p7.finally) ~= "function" or typeof(p7.cancel) ~= "function")) then
        error("Did not receive a Promise as an argument", 3);
    end;
end;

local u8 = {};
u8.__index = u8;

function u8.new() -- Line: 58
    -- upvalues: u8 (copy)
    local v9 = setmetatable({}, u8);
    v9._objects = {};
    v9._cleaning = false;

    return v9;
end;

function u8.Extend(p10) -- Line: 84
    -- upvalues: u8 (copy)
    if p10._cleaning then
        error("Cannot call trove:Extend() while cleaning", 2);
    end;

    return p10:Construct(u8);
end;

function u8.Clone(p11, p12) -- Line: 95
    if p11._cleaning then
        error("Cannot call trove:Clone() while cleaning", 2);
    end;

    return p11:Add(p12:Clone());
end;

function u8.Construct(p13, p14, ...) -- Line: 135
    if p13._cleaning then
        error("Cannot call trove:Construct() while cleaning", 2);
    end;

    local v15 = nil;
    local v16 = type(p14);

    if v16 == "table" then
        v15 = p14.new(...);
    elseif v16 == "function" then
        v15 = p14(...);
    end;

    return p13:Add(v15);
end;

function u8.Connect(p17, p18, p19) -- Line: 164
    if p17._cleaning then
        error("Cannot call trove:Connect() while cleaning", 2);
    end;

    return p17:Add(p18:Connect(p19));
end;

function u8.BindToRenderStep(p20, u21, p22, p23) -- Line: 184
    -- upvalues: RunService (copy)
    if p20._cleaning then
        error("Cannot call trove:BindToRenderStep() while cleaning", 2);
    end;

    RunService:BindToRenderStep(u21, p22, p23);
    p20:Add(function() -- Line: 189
        -- upvalues: RunService (ref), u21 (copy)
        RunService:UnbindFromRenderStep(u21);
    end);
end;

function u8.AddPromise(u24, u25) -- Line: 217
    if u24._cleaning then
        error("Cannot call trove:AddPromise() while cleaning", 2);
    end;

    if typeof(u25) ~= "table" or (typeof(u25.getStatus) ~= "function" or (typeof(u25.finally) ~= "function" or typeof(u25.cancel) ~= "function")) then
        error("Did not receive a Promise as an argument", 3);
    end;

    if u25:getStatus() == "Started" then
        u25:finally(function() -- Line: 223
            -- upvalues: u24 (copy), u25 (copy)
            if u24._cleaning then
                return;
            end;

            u24:_findAndRemoveFromObjects(u25, false);
        end);
        u24:Add(u25, "cancel");
    end;

    return u25;
end;

function u8.Add(p26, p27, p28) -- Line: 282
    -- upvalues: GetObjectCleanupFunction (copy)
    if p26._cleaning then
        error("Cannot call trove:Add() while cleaning", 2);
    end;

    local v29 = { p27, (GetObjectCleanupFunction(p27, p28)) };
    table.insert(p26._objects, v29);

    return p27;
end;

function u8.Remove(p30, p31) -- Line: 301
    if p30._cleaning then
        error("Cannot call trove:Remove() while cleaning", 2);
    end;

    return p30:_findAndRemoveFromObjects(p31, true);
end;

function u8.Clean(p32) -- Line: 314
    if p32._cleaning then
        return;
    end;

    p32._cleaning = true;

    for _, v in p32._objects do
        p32:_cleanupObject(v[1], v[2]);
    end;

    table.clear(p32._objects);
    p32._cleaning = false;
end;

function u8._findAndRemoveFromObjects(p33, p34, p35) -- Line: 326
    local _objects = p33._objects;

    for i, v in ipairs(_objects) do
        if v[1] == p34 then
            local v36 = #_objects;
            _objects[i] = _objects[v36];
            _objects[v36] = nil;

            if p35 then
                p33:_cleanupObject(v[1], v[2]);
            end;

            return true;
        end;
    end;

    return false;
end;

function u8._cleanupObject(p37, p38, p39) -- Line: 342
    -- upvalues: u1 (copy), u2 (copy)
    if p39 == u1 then
        p38();

        return;
    end;

    if p39 == u2 then
        pcall(task.cancel, p38);

        return;
    end;

    p38[p39](p38);
end;

function u8.AttachToInstance(u40, p41) -- Line: 365
    if u40._cleaning then
        error("Cannot call trove:AttachToInstance() while cleaning", 2);
    elseif not p41:IsDescendantOf(game) then
        error("Instance is not a descendant of the game hierarchy", 2);
    end;

    return u40:Connect(p41.Destroying, function() -- Line: 371
        -- upvalues: u40 (copy)
        u40:Destroy();
    end);
end;

function u8.Destroy(p42) -- Line: 379
    p42:Clean();
end;

return u8;