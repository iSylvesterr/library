-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Bindables = game:GetService("ReplicatedStorage"):WaitForChild("Bindables");
local u1 = {};
local u2 = {};
local u3 = 0;
local u14 = {
    TextLabel = function(p4, p5) -- Line: 14, Name: TextLabel
        p4.TextColor3 = p5;
    end,

    TextButton = function(p6, p7) -- Line: 15, Name: TextButton
        p6.BackgroundColor3 = p7;
    end,

    ImageButton = function(p8, p9) -- Line: 16, Name: ImageButton
        p8.BackgroundColor3 = p9;
    end,

    Frame = function(p10, p11) -- Line: 17, Name: Frame
        p10.BackgroundColor3 = p11;
    end,

    UIStroke = function(p12, p13) -- Line: 18, Name: UIStroke
        p12.Color = p13;
    end
};
RunService.Heartbeat:Connect(function(p15) -- Line: 21
    -- upvalues: u3 (ref), u1 (copy), u2 (copy), u14 (copy)
    u3 = (u3 + 0.3 * p15) % 1;
    local v16 = Color3.fromHSV(u3, 1, 1);

    for i = #u1, 1, -1 do
        local v17 = u1[i];

        if v17 and v17.Parent then
            v17.Color = v16;
        else
            table.remove(u1, i);
        end;
    end;

    for i = #u2, 1, -1 do
        local v18 = u2[i];

        if v18 and v18.Parent then
            local v19 = u14[v18.ClassName];

            if v19 then
                v19(v18, v16);
            end;
        else
            table.remove(u2, i);
        end;
    end;
end);
Bindables.AddRainbowParts.Event:Connect(function(p20) -- Line: 46
    -- upvalues: u1 (copy)
    local v21 = typeof(p20) == "table" and p20 and p20 or { p20 };

    for _, v in ipairs(v21) do
        if not table.find(u1, v) then
            table.insert(u1, v);
        end;
    end;
end);
Bindables.RemoveRainbowParts.Event:Connect(function(p22) -- Line: 56
    -- upvalues: u1 (copy)
    local v23 = typeof(p22) == "table" and p22 and p22 or { p22 };

    for _, v in ipairs(v23) do
        local v24 = table.find(u1, v);

        if v24 then
            table.remove(u1, v24);
        end;
    end;
end);
Bindables.AddRainbowText.Event:Connect(function(p25) -- Line: 65
    -- upvalues: u2 (copy)
    local v26 = typeof(p25) == "table" and p25 and p25 or { p25 };

    for _, v in ipairs(v26) do
        if not table.find(u2, v) then
            table.insert(u2, v);
        end;
    end;
end);
Bindables.RemoveRainbowText.Event:Connect(function(p27) -- Line: 75
    -- upvalues: u2 (copy)
    local v28 = typeof(p27) == "table" and p27 and p27 or { p27 };

    for _, v in ipairs(v28) do
        local v29 = table.find(u2, v);

        if v29 then
            table.remove(u2, v29);
        end;
    end;
end);