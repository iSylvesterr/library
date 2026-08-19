-- Decompiled with Potassium's decompiler.

local packetIDs = require(script.Parent.Parent.namespaces.packetIDs);
local readRefs = require(script.Parent.readRefs);
local u1 = packetIDs.ref();
local u2 = nil;

local function functionPasser(p3, ...) -- Line: 9
    -- upvalues: u2 (ref)
    local v4 = u2;
    u2 = nil;
    p3(...);
    u2 = v4;
end;

local function yielder() -- Line: 16
    -- upvalues: functionPasser (copy)
    while true do
        functionPasser(coroutine.yield());
    end;
end;

local function runListener(p5, ...) -- Line: 22
    -- upvalues: u2 (ref), yielder (copy)
    if u2 == nil then
        u2 = coroutine.create(yielder);
        coroutine.resume(u2);
    end;

    task.spawn(u2, p5, ...);
end;

return function(p6, p7, p8) -- Line: 31
    -- upvalues: readRefs (copy), u1 (copy), runListener (copy)
    local v9 = buffer.len(p6);
    readRefs.set(p7);
    local v10 = 0;

    while v10 < v9 do
        local v11 = u1[buffer.readu8(p6, v10)];
        local v12 = v10 + 1;
        local v13, v14 = v11.reader(p6, v12);
        v10 = v12 + v14;

        for _, v in v11.getListeners() do
            runListener(v, v13, p8);
        end;
    end;
end;