-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(255, 0, 255)
};

return function(u2, p3, p4) -- Line: 15
    -- upvalues: u1 (copy), RunService (copy)
    local u5 = p3 or 3;
    local u6 = p4 or u1;
    assert(u5, "luau");
    assert(u6, "luau");
    local u7 = true;
    local u8 = #u6;
    local u9 = 1 / u8;
    task.spawn(function() -- Line: 26
        -- upvalues: RunService (ref), u2 (copy), u7 (ref), u5 (ref), u8 (copy), u6 (ref), u9 (copy)
        local u10 = nil;
        u10 = RunService.Heartbeat:Connect(function() -- Line: 28
            -- upvalues: u2 (ref), u7 (ref), u5 (ref), u8 (ref), u6 (ref), u9 (ref), u10 (ref)
            if not (u2 and (u2.Parent and u7)) then
                u10:Disconnect();

                return;
            end;

            local v11 = tick() % u5 / u5;
            local v12 = {};
            local v13 = false;

            for i = 1, u8 + 1 do
                local v14 = v11 + (i - 1) / u8;

                if v14 > 1 then
                    v14 = v14 - 1;
                end;

                v13 = (v14 == 0 or v14 == 1) and true or v13;
                table.insert(v12, ColorSequenceKeypoint.new(v14, u6[i] or u6[i - u8]));
            end;

            if not v13 then
                local v15 = (1 - v11) / u9 + 1;
                local v16 = math.floor(v15);
                local v17 = math.ceil(v15);
                local v18 = u6[math.clamp(v16, 1, u8)]:Lerp(u6[math.clamp(v17, 1, u8)] or u6[1], v15 % 1);
                table.insert(v12, ColorSequenceKeypoint.new(0, v18));
                table.insert(v12, ColorSequenceKeypoint.new(1, v18));
            end;

            table.sort(v12, function(p19, p20) -- Line: 58
                return p19.Time < p20.Time;
            end);
            u2.Color = ColorSequence.new(v12);
        end);
    end);

    return function() -- Line: 68
        -- upvalues: u7 (ref)
        u7 = false;
    end;
end;