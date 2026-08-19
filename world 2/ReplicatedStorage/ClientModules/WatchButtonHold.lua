-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local u1 = nil;
local u2 = 0;

local function updateHolding() -- Line: 19
    -- upvalues: u1 (ref), u2 (ref)
    if not u1 then
        return;
    end;

    local v3 = os.clock();

    if v3 < u1.t or v3 - u2 < u1.interval then
        return;
    end;

    u2 = v3;
    u1.callback(v3 - u1.t);
end;

local function clearHolding() -- Line: 33
    -- upvalues: u1 (ref), u2 (ref)
    if u1 then
        if u1.conn then
            u1.conn:Disconnect();
            u1.conn = nil;
        end;

        local v4 = os.clock();

        if u1.t <= v4 then
            task.spawn(u1.callback, v4 - u1.t, true);
        end;

        u2 = 0;
        u1 = nil;
    end;
end;

UserInputService.InputEnded:Connect(function(p5, p6) -- Line: 50
    -- upvalues: clearHolding (copy)
    if p5.UserInputType == Enum.UserInputType.MouseButton1 or (p5.UserInputType == Enum.UserInputType.Touch or p5.KeyCode == Enum.KeyCode.ButtonA) then
        clearHolding();
    end;
end);

return function(u7, u8, u9) -- Line: 56
    -- upvalues: clearHolding (copy), u1 (ref), RunService (copy), updateHolding (copy)
    local u10 = u7.MouseButton1Down:Connect(function() -- Line: 57
        -- upvalues: clearHolding (ref), u1 (ref), u7 (copy), u9 (copy), u8 (copy), RunService (ref), updateHolding (ref)
        clearHolding();
        u1 = {
            button = u7,
            t = os.clock() + (u9 and u9.minimumHoldTime or 0),
            interval = u9 and u9.interval or 0,
            callback = u8,
            conn = RunService.PostSimulation:Connect(updateHolding)
        };
    end);
    local u11 = u7.MouseButton1Up:Connect(function() -- Line: 69
        -- upvalues: u1 (ref), u7 (copy), clearHolding (ref)
        if u1 and u1.button == u7 then
            clearHolding();
        end;
    end);
    local u12 = u7.Destroying:Once(function() -- Line: 75
        -- upvalues: u1 (ref), u7 (copy), clearHolding (ref)
        if u1 and u1.button == u7 then
            clearHolding();
        end;
    end);

    return function() -- Line: 81
        -- upvalues: u12 (copy), u10 (copy), u11 (copy)
        u12:Disconnect();
        u10:Disconnect();
        u11:Disconnect();
    end;
end;