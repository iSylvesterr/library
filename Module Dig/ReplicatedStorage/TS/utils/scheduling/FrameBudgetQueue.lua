-- Decompiled with Potassium's decompiler.

local RunService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 7, Name: __tostring
        return "FrameBudgetQueue";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 12
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3, p4) -- Line: 16
    p3.budgetMs = p4;
    p3.jobs = {};
end;

function u1.add(p5, p6) -- Line: 20
    p5:addBatch({ p6 }, function(p7) -- Line: 21
        return p7();
    end);
end;

function u1.isDraining(p8) -- Line: 25
    return #p8.jobs > 0;
end;

function u1.addBatch(u9, p10, p11) -- Line: 28
    -- upvalues: RunService (copy)
    if #p10 == 0 then
        return nil;
    end;

    table.insert(u9.jobs, {
        index = 0,
        items = p10,
        handler = p11
    });

    if u9.connection == nil then
        u9.connection = RunService.Heartbeat:Connect(function() -- Line: 40
            -- upvalues: u9 (copy)
            return u9:drain();
        end);
    end;
end;

function u1.drain(p12) -- Line: 45
    local v13 = os.clock() + p12.budgetMs / 1000;

    while #p12.jobs > 0 do
        local v14 = p12.jobs[1];

        while v14.index < #v14.items do
            if v13 <= os.clock() then
                return nil;
            end;

            local v15 = v14.items[v14.index + 1];
            v14.index = v14.index + 1;
            v14.handler(v15);
        end;

        table.remove(p12.jobs, 1);
    end;

    local connection = p12.connection;

    if connection ~= nil then
        connection:Disconnect();
    end;

    p12.connection = nil;
end;

return {
    FrameBudgetQueue = u1
};