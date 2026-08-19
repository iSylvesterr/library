-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent;
local u1 = {
    [-1] = "#3C2A00",
    [0] = "#7C6B26",
    [1] = "#FFF073",
    [2] = "#BFAF4D",
    [3] = "#3C2A00",
    [4] = "#3C2A00",
    [5] = "#7C6B26",
    [6] = "#FFF073",
    [7] = "#BFAF4D",
    [8] = "#3C2A00"
};

if Parent then
    Parent.Rotation = 90;
end;

local function refresh(p2) -- Line: 26
    -- upvalues: Parent (copy), u1 (copy)
    if not Parent then
        return;
    end;

    local v3 = p2 + 1;
    local v4 = {};

    for i, v in pairs(u1) do
        local v5 = i * 0.25;

        if p2 - v5 >= 0 and p2 - v5 <= 0.25 then
            v4[#v4 + 1] = ColorSequenceKeypoint.new(0, Color3.fromHex(v));
        elseif v5 - v3 >= 0 and v5 - v3 <= 0.25 then
            v4[#v4 + 1] = ColorSequenceKeypoint.new(1, Color3.fromHex(v));
        elseif p2 < v5 and v5 < v3 then
            local v6 = v5 - p2;

            if v6 > 1 then
                v6 = v6 - 1;
            end;

            v4[#v4 + 1] = ColorSequenceKeypoint.new(v6, Color3.fromHex(v));
        end;
    end;

    table.sort(v4, function(p7, p8) -- Line: 58
        return p7.Time < p8.Time;
    end);
    Parent.Color = ColorSequence.new(v4);
end;

local u9 = 0;
RunService.Heartbeat:Connect(function(p10) -- Line: 68
    -- upvalues: u9 (ref), refresh (copy)
    u9 = u9 - p10;
    local v11 = u9 / 2 - 0.25;

    if v11 >= -0.25 then
        refresh(v11);

        return;
    end;

    u9 = 2.5;
end);