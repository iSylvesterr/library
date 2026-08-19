-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(script.Parent.Parent.types);
local read = require(script.Parent.read);
local writePacket = require(script.Parent.bufferWriter).writePacket;

local function onClientEvent(p1, p2) -- Line: 10
    -- upvalues: read (copy)
    read(p1, p2);
end;

local function create() -- Line: 15
    return {
        cursor = 0,
        size = 256,
        references = {},
        buff = buffer.create(256)
    };
end;

local function dump(p3) -- Line: 24
    local cursor = p3.cursor;
    local v4 = buffer.create(cursor);
    buffer.copy(v4, 0, p3.buff, 0, cursor);

    if #p3.references > 0 then
        return v4, p3.references;
    end;

    return v4, nil;
end;

local u5 = create();
local u6 = create();

return {
    sendReliable = function(p7, p8, p9) -- Line: 39, Name: sendReliable
        -- upvalues: u5 (ref), writePacket (copy)
        u5 = writePacket(u5, p7, p8, p9);
    end,

    sendUnreliable = function(p10, p11, p12) -- Line: 43, Name: sendUnreliable
        -- upvalues: u6 (ref), writePacket (copy)
        u6 = writePacket(u6, p10, p11, p12);
    end,

    start = function() -- Line: 47, Name: start
        -- upvalues: ReplicatedStorage (copy), onClientEvent (copy), RunService (copy), u5 (ref), u6 (ref)
        local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable");
        ByteNetReliable.OnClientEvent:Connect(onClientEvent);
        local ByteNetUnreliable = ReplicatedStorage:WaitForChild("ByteNetUnreliable");
        ByteNetUnreliable.OnClientEvent:Connect(onClientEvent);
        RunService.Heartbeat:Connect(function() -- Line: 54
            -- upvalues: u5 (ref), ByteNetReliable (copy), u6 (ref), ByteNetUnreliable (copy)
            if u5.cursor > 0 then
                local v13 = u5;
                local cursor = v13.cursor;
                local v14 = buffer.create(cursor);
                buffer.copy(v14, 0, v13.buff, 0, cursor);
                local v15;

                if #v13.references > 0 then
                    v15 = v13.references;
                else
                    v15 = nil;
                end;

                ByteNetReliable:FireServer(v14, v15);
                u5.cursor = 0;
                table.clear(u5.references);
            end;

            if u6.cursor > 0 then
                local v16 = u6;
                local cursor = v16.cursor;
                local v17 = buffer.create(cursor);
                buffer.copy(v17, 0, v16.buff, 0, cursor);
                local v18;

                if #v16.references > 0 then
                    v18 = v16.references;
                else
                    v18 = nil;
                end;

                ByteNetUnreliable:FireServer(v17, v18);
                u6.cursor = 0;
                table.clear(u6.references);
            end;
        end);
    end
};