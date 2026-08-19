-- Decompiled with Potassium's decompiler.

local u1 = {};
local Spring2 = require(game.ReplicatedStorage.ClientModules.Spring2);
u1.__index = u1;

function u1.new(p2) -- Line: 5
    -- upvalues: Spring2 (copy), u1 (copy)
    local v3 = Spring2.new(p2:GetPivot().Position);
    v3.Speed = 11;
    v3.Damper = 0.85;
    local v4 = {
        MainRoot = p2,
        Spring = v3,
        Target = p2:GetPivot()
    };
    setmetatable(v4, u1);

    return v4;
end;

function u1.Start(u5) -- Line: 24
    u5.MainRoot.PizzaRig.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Animations.FlyLoop):Play();
    u5.Active = true;
    task.spawn(function() -- Line: 29
        -- upvalues: u5 (copy)
        while u5.Active do
            local v6 = game:GetService("RunService").Heartbeat:Wait();
            local v7 = tick() * 2;
            local v8 = math.rad(v7 * 3);
            local v9 = math.cos(v8) * 0.3;
            local v10 = math.sin(v7 * 2.2) * 0.4;
            local v11 = math.rad(v7 * 1.6);
            local v12 = math.cos(v11) * 0.1;
            local v13 = Vector3.new(v9, v10, v12);
            local v14 = u5.MainRoot:GetPivot():VectorToObjectSpace(v13);
            u5.Spring.Target = u5.MainRoot:GetPivot().Position + v14;
            u5.Spring:Update(v6);
            local Position = u5.Spring.Position;
            local v15 = CFrame.new(Position, Position + u5.MainRoot:GetPivot().LookVector);
            local Angles = CFrame.Angles;
            local v16 = tick() * 2;
            local v17 = math.cos(v16) * 0.06;
            local v18 = tick() * 1.5;
            local v19 = math.sin(v18) * 0.1;
            local v20 = tick() * 2;
            local v21 = v15 * Angles(v17, v19, math.sin(v20) * 0.1);
            u5.MainRoot.PizzaRig:PivotTo(v21);
        end;
    end);
end;

function u1.Stop(p22) -- Line: 57
    p22.Active = false;
end;

return u1;