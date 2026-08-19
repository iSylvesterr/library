-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Boosts = require(ReplicatedStorage.Directory.Boosts);
local Gears = require(ReplicatedStorage.Directory.Gears);

local function clearExistingClones(p1, p2) -- Line: 32
    for _, child in ipairs(p1:GetChildren()) do
        if child ~= p2 and child:IsA("GuiObject") then
            child:Destroy();
        end;
    end;
end;

local function applyGearDisplay(p3, p4, p5, p6) -- Line: 40
    -- upvalues: Gears (copy)
    local v7 = Gears.Directory[p5];

    if not v7 then
        p4.Text = p5;
        p4.TextColor3 = p6;

        if p3 then
            p3.Visible = false;
        end;

        return;
    end;

    p4.Text = "Gives you";
    p4.TextColor3 = p6;
    p4.TextScaled = true;
    p4.Size = UDim2.fromScale(0.7, 1);

    if p3 then
        local Icon = v7.Icon;

        if Icon and Icon ~= "" then
            p3.Main.Image = Icon;
            p3.Visible = true;

            return;
        end;

        p3.Visible = false;
    end;
end;

local function buildBoostDisplay(p8) -- Line: 67
    -- upvalues: Boosts (copy)
    local v9 = {};

    if not p8 then
        return v9;
    end;

    for i, v in pairs(p8) do
        local v10 = Boosts.Directory[i];

        if v10 then
            if i == "SpecialItem" then
                if typeof(v) == "string" and v ~= "" then
                    table.insert(v9, {
                        type = i,
                        value = v,
                        abbreviation = v10.Abbreviation,
                        color = v10.Color
                    });
                end;
            elseif typeof(v) == "number" then
                table.insert(v9, {
                    type = i,
                    value = v,
                    abbreviation = v10.Abbreviation,
                    color = v10.Color
                });
            end;
        end;
    end;

    table.sort(v9, function(p11, p12) -- Line: 99
        if p11.abbreviation == p12.abbreviation then
            return p11.type < p12.type;
        end;

        return p11.abbreviation < p12.abbreviation;
    end);

    return v9;
end;

return function(p13, p14, p15) -- Line: 110
    -- upvalues: buildBoostDisplay (copy), clearExistingClones (copy), applyGearDisplay (copy)
    if not p15 then
        return;
    end;

    local Boosts2 = p13:FindFirstChild("Boosts");

    if not (Boosts2 and Boosts2:IsA("Frame")) then
        return;
    end;

    local Template = Boosts2:FindFirstChild("Template");

    if not (Template and Template:IsA("Frame")) then
        return;
    end;

    local v16 = buildBoostDisplay(p15.boosts);

    if #v16 == 0 then
        return;
    end;

    clearExistingClones(Boosts2, Template);
    local Icon = p13:FindFirstChild("Icon");

    if Icon and Icon:IsA("ImageLabel") then
        local v17 = p15.icon or p15.config and p15.config.Icon;

        if v17 then
            Icon.Image = v17;
        end;
    end;

    local Quantity = p13:FindFirstChild("Quantity", true);

    if Quantity and Quantity:IsA("TextLabel") then
        local v18 = p15.quantity or 0;

        if v18 > 1 then
            Quantity.Visible = true;
            Quantity.Text = "x" .. tostring(v18);
        else
            Quantity.Visible = false;
        end;
    end;

    for i, v in ipairs(v16) do
        local v19 = Template:Clone();
        v19.Name = v.type .. i;
        v19.Visible = true;
        v19.LayoutOrder = i;
        local boost = v19:FindFirstChild("boost");

        if boost and boost:IsA("TextLabel") then
            local icon = v19:FindFirstChild("icon");

            if icon and not icon:IsA("ImageLabel") then
                icon = nil;
            end;

            if v.type == "SpecialItem" and typeof(v.value) == "string" then
                applyGearDisplay(icon, boost, v.value, v.color);
            else
                local v20 = typeof(v.value) ~= "number" and 0 or v.value;
                local v21 = math.round(v20 * 100);
                boost.Text = string.format("%s%d%% %s", v21 >= 0 and "+" or "", v21, v.abbreviation);
                boost.TextColor3 = v.color;

                if icon then
                    icon.Visible = false;
                end;
            end;

            v19.Parent = Boosts2;
        else
            v19:Destroy();
        end;
    end;

    Template.Visible = false;
    p13.Visible = true;
end;