-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent;
local u1 = {
    [-1] = "#ffff00",
    [0] = "#ff0004",
    [1] = "#eb04f6",
    [2] = "#4545fa",
    [3] = "#06f8fe",
    [4] = "#00f900",
    [5] = "#ffff00",
    [6] = "#ff0004",
    [7] = "#eb04f6",
    [8] = "#4545fa",
    [9] = "#06f8fe",
    [10] = "#00f900"
};
Parent.Rotation = 0;

local function refresh(p2) -- Line: 24
    -- upvalues: u1 (copy), Parent (copy)
    local v3 = p2 + 1;
    local v4 = {};

    for i, v in pairs(u1) do
        local v5 = i * 0.2;

        if p2 - v5 >= 0 and p2 - v5 <= 0.2 then
            v4[#v4 + 1] = ColorSequenceKeypoint.new(0, Color3.fromHex(v));
        elseif v5 - v3 >= 0 and v5 - v3 <= 0.2 then
            v4[#v4 + 1] = ColorSequenceKeypoint.new(1, Color3.fromHex(v));
        elseif p2 < v5 and v5 < v3 then
            local v6 = v5 - p2;

            if v6 > 1 then
                v6 = v6 - 1;
            end;

            v4[#v4 + 1] = ColorSequenceKeypoint.new(v6, Color3.fromHex(v));
        end;
    end;

    table.sort(v4, function(p7, p8) -- Line: 52
        return p7.Time < p8.Time;
    end);
    Parent.Color = ColorSequence.new(v4);
end;

local u9 = 0;
RunService.Heartbeat:Connect(function(p10) -- Line: 62
    -- upvalues: u9 (ref), refresh (copy)
    u9 = u9 - p10;
    local v11 = u9 / 3 - 0.2;

    if v11 >= -0.2 then
        refresh(v11);

        return;
    end;

    u9 = 3.6;
end);