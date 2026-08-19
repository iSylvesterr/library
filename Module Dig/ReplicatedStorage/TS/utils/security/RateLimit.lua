-- Decompiled with Potassium's decompiler.

local Players = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 7, Name: __tostring
        return "RateLimit";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 12
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(u3, p4) -- Line: 16
    -- upvalues: Players (copy)
    u3.cooldown = p4;
    u3.timestamps = {};
    u3.playerRemovingConnection = Players.PlayerRemoving:Connect(function(p5) -- Line: 20
        -- upvalues: u3 (copy)
        u3.timestamps[p5] = nil;
    end);
end;

function u1.isLimited(p6, p7) -- Line: 26
    local v8 = os.clock();
    local v9 = p6.timestamps[p7];

    if v8 - (v9 == nil and 0 or v9) < p6.cooldown then
        return true;
    end;

    p6.timestamps[p7] = v8;

    return false;
end;

function u1.destroy(p10) -- Line: 43
    if p10.playerRemovingConnection then
        p10.playerRemovingConnection:Disconnect();
        p10.playerRemovingConnection = nil;
    end;

    table.clear(p10.timestamps);
end;

return {
    RateLimit = u1
};