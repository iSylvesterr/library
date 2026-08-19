-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Boosts = require(ReplicatedStorage.Directory.Boosts);
local Gears = require(ReplicatedStorage.Directory.Gears);

local function applyGearDisplay(p1, p2, p3, p4) -- Line: 14
    -- upvalues: Gears (copy)
    local v5 = Gears.Directory[p3];

    if not v5 then
        p2.Text = p3;
        p2.TextColor3 = p4;

        if p1 then
            p1.Visible = false;
        end;

        return;
    end;

    p2.Text = "Gives you";
    p2.TextColor3 = p4;
    p2.Size = UDim2.fromScale(0.5, 1);

    if p1 then
        local Icon = v5.Icon;

        if Icon and Icon ~= "" then
            p1.Main.Image = Icon;
            p1.Visible = true;

            return;
        end;

        p1.Visible = false;
    end;
end;

return function(p6, p7, p8) -- Line: 40
    -- upvalues: Boosts (copy), applyGearDisplay (copy)
    if typeof(p8) ~= "table" then
        return;
    end;

    local Type = p8.Type;

    if typeof(Type) ~= "string" or Type == "" then
        return;
    end;

    local v9 = Boosts.Directory[Type];

    if not v9 then
        return;
    end;

    local boost = p6:FindFirstChild("boost");

    if not (boost and boost:IsA("TextLabel")) then
        return;
    end;

    local icon = p6:FindFirstChild("icon");

    if icon and not icon:IsA("ImageLabel") then
        icon = nil;
    end;

    local Value = p8.Value;

    if typeof(Value) ~= "number" then
        if typeof(Value) ~= "string" then
            return;
        end;

        applyGearDisplay(icon, boost, Value, v9.Color);
        p6.Visible = true;

        return;
    end;

    local v10 = math.round(Value * 100);
    boost.Text = string.format("%s%d%% %s", v10 >= 0 and "+" or "", v10, v9.Abbreviation);
    boost.TextColor3 = v9.Color;

    if icon then
        icon.Visible = false;
    end;

    p6.Visible = true;
end;