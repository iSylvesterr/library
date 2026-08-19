-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Bindables = game:GetService("ReplicatedStorage"):WaitForChild("Bindables");
local u1 = {};
local u2 = {};
local u3 = {
    Color3.fromHSV(0, 1, 1),
    Color3.fromHSV(0.16666666666666666, 1, 1),
    Color3.fromHSV(0.3333333333333333, 1, 1),
    Color3.fromHSV(0.5, 1, 1),
    Color3.fromHSV(0.6666666666666666, 1, 1),
    Color3.fromHSV(0.8333333333333334, 1, 1)
};
local u4 = 1;
local u5 = 0;
local u16 = {
    TextLabel = function(p6, p7) -- Line: 26, Name: TextLabel
        p6.TextColor3 = p7;
    end,

    TextButton = function(p8, p9) -- Line: 27, Name: TextButton
        p8.BackgroundColor3 = p9;
    end,

    ImageButton = function(p10, p11) -- Line: 28, Name: ImageButton
        p10.BackgroundColor3 = p11;
    end,

    Frame = function(p12, p13) -- Line: 29, Name: Frame
        p12.BackgroundColor3 = p13;
    end,

    UIStroke = function(p14, p15) -- Line: 30, Name: UIStroke
        p14.Color = p15;
    end
};

local function darkenColor(p17, p18) -- Line: 33
    local v19, v20, v21 = Color3.toHSV(p17);

    return Color3.fromHSV(v19, v20, v21 * p18);
end;

RunService.Heartbeat:Connect(function(p22) -- Line: 38
    -- upvalues: u5 (ref), u4 (ref), u3 (copy), u1 (copy), u2 (copy), u16 (copy)
    u5 = u5 + p22;

    if u5 < 0.75 then
        return;
    end;

    u5 = u5 % 0.75;
    u4 = u4 % #u3 + 1;
    local v23 = u3[u4];

    for i = #u1, 1, -1 do
        local v24 = u1[i];

        if v24 and v24.Parent then
            local v25;

            if v24.Name == "Darker" then
                local v26, v27, v28 = Color3.toHSV(v23);
                v25 = Color3.fromHSV(v26, v27, v28 * 0.75) or v23;
            else
                v25 = v23;
            end;

            v24.Color = v25;
        else
            table.remove(u1, i);
        end;
    end;

    for i = #u2, 1, -1 do
        local v29 = u2[i];

        if v29 and v29.Parent then
            local v30 = u16[v29.ClassName];

            if v30 then
                v30(v29, v23);
            end;
        else
            table.remove(u2, i);
        end;
    end;
end);
Bindables.AddDiscoParts.Event:Connect(function(p31) -- Line: 67
    -- upvalues: u1 (copy)
    local v32 = typeof(p31) == "table" and p31 and p31 or { p31 };

    for _, v in ipairs(v32) do
        if not table.find(u1, v) then
            table.insert(u1, v);
        end;
    end;
end);
Bindables.RemoveDiscoParts.Event:Connect(function(p33) -- Line: 77
    -- upvalues: u1 (copy)
    local v34 = typeof(p33) == "table" and p33 and p33 or { p33 };

    for _, v in ipairs(v34) do
        local v35 = table.find(u1, v);

        if v35 then
            table.remove(u1, v35);
        end;
    end;
end);
Bindables.AddDiscoText.Event:Connect(function(p36) -- Line: 86
    -- upvalues: u2 (copy)
    local v37 = typeof(p36) == "table" and p36 and p36 or { p36 };

    for _, v in ipairs(v37) do
        if not table.find(u2, v) then
            table.insert(u2, v);
        end;
    end;
end);
Bindables.RemoveDiscoText.Event:Connect(function(p38) -- Line: 96
    -- upvalues: u2 (copy)
    local v39 = typeof(p38) == "table" and p38 and p38 or { p38 };

    for _, v in ipairs(v39) do
        local v40 = table.find(u2, v);

        if v40 then
            table.remove(u2, v40);
        end;
    end;
end);