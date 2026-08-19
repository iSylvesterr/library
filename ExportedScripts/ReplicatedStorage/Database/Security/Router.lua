-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
require(ReplicatedStorage.Shared.Promise);
local u2 = {};

local function waitForRouter(p3, p4) -- Line: 22
    -- upvalues: u2 (copy)
    local v5 = 0;

    while u2[p3] == nil do
        v5 = v5 + task.wait();

        if p4 < v5 then
            break;
        end;
    end;

    return u2[p3];
end;

function v1.broadcastRouter(p6, ...) -- Line: 38
    -- upvalues: waitForRouter (copy)
    local v7 = waitForRouter(p6, 1);

    if v7 then
        return v7(...);
    end;

    warn((`{p6} is not cached in local copy.`));
end;

function v1.observerRouter(p8, p9) -- Line: 51
    -- upvalues: u2 (copy)
    if u2[p8] then
        warn((`{p8} already has a router cached in local copy.`));

        return;
    end;

    u2[p8] = p9;
end;

return v1;