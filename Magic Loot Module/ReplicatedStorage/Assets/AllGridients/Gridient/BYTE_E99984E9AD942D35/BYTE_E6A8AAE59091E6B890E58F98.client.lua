-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent;
local u1 = {
    [-1] = "#7e0404",
    [0] = "#9a0505",
    [1] = "#fc0000",
    [2] = "#9a0505",
    [3] = "#7e0404",
    [4] = "#7e0404",
    [5] = "#9a0505",
    [6] = "#fc0000",
    [7] = "#9a0505",
    [8] = "#7e0404"
};

local function refresh(p2) -- Line: 22
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

    table.sort(v4, function(p7, p8) -- Line: 54
        return p7.Time < p8.Time;
    end);
    Parent.Color = ColorSequence.new(v4);
end;

local u9 = 0;
RunService.Heartbeat:Connect(function(p10) -- Line: 64
    -- upvalues: u9 (ref), refresh (copy)
    u9 = u9 - p10;
    local v11 = u9 / 2 - 0.25;

    if v11 >= -0.25 then
        refresh(v11);

        return;
    end;

    u9 = 2.5;
end);