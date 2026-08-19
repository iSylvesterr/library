-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicaClient = require(ReplicatedStorage.ClientModules.ReplicaClient);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = {};
local u4 = false;

local function flushReady() -- Line: 14
    -- upvalues: u2 (ref), u3 (copy)
    if not u2 then
        return;
    end;

    for _, v in ipairs(u3) do
        task.spawn(v, u2);
    end;

    table.clear(u3);
end;

local function ensureStarted() -- Line: 24
    -- upvalues: u4 (ref), ReplicaClient (copy), LocalPlayer (copy), u2 (ref), flushReady (copy)
    if u4 then
        return;
    end;

    u4 = true;
    ReplicaClient.OnNew("PlayerState", function(p5) -- Line: 30
        -- upvalues: LocalPlayer (ref), u2 (ref), flushReady (ref)
        if p5.Tags and p5.Tags.UserId == LocalPlayer.UserId then
            u2 = p5;
            flushReady();
        end;
    end);
    ReplicaClient.RequestData();
end;

function v1.GetLocalReplica(p6) -- Line: 40
    -- upvalues: u4 (ref), ReplicaClient (copy), LocalPlayer (copy), u2 (ref), flushReady (copy)
    if not u4 then
        u4 = true;
        ReplicaClient.OnNew("PlayerState", function(p7) -- Line: 30
            -- upvalues: LocalPlayer (ref), u2 (ref), flushReady (ref)
            if p7.Tags and p7.Tags.UserId == LocalPlayer.UserId then
                u2 = p7;
                flushReady();
            end;
        end);
        ReplicaClient.RequestData();
    end;

    return u2;
end;

function v1.OnLocalReplica(p8, p9) -- Line: 45
    -- upvalues: u4 (ref), ReplicaClient (copy), LocalPlayer (copy), u2 (ref), flushReady (copy), u3 (copy)
    if not u4 then
        u4 = true;
        ReplicaClient.OnNew("PlayerState", function(p10) -- Line: 30
            -- upvalues: LocalPlayer (ref), u2 (ref), flushReady (ref)
            if p10.Tags and p10.Tags.UserId == LocalPlayer.UserId then
                u2 = p10;
                flushReady();
            end;
        end);
        ReplicaClient.RequestData();
    end;

    if u2 then
        task.spawn(p9, u2);

        return;
    end;

    table.insert(u3, p9);
end;

function v1.WaitForLocalReplica(p11, p12) -- Line: 54
    -- upvalues: u4 (ref), ReplicaClient (copy), LocalPlayer (copy), u2 (ref), flushReady (copy)
    if not u4 then
        u4 = true;
        ReplicaClient.OnNew("PlayerState", function(p13) -- Line: 30
            -- upvalues: LocalPlayer (ref), u2 (ref), flushReady (ref)
            if p13.Tags and p13.Tags.UserId == LocalPlayer.UserId then
                u2 = p13;
                flushReady();
            end;
        end);
        ReplicaClient.RequestData();
    end;

    if u2 then
        return u2;
    end;

    local v14 = os.clock();

    while not u2 and os.clock() - v14 < (p12 or 30) do
        task.wait();
    end;

    return u2;
end;

return v1;