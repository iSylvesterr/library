-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Functions.E);
local Digit = require(script.Digit);
local u1 = {};
local u2 = {
    Frame = true,
    Digits = true,
    CommaLabels = true,
    Text = true
};
local u3 = {
    ZeroPadding = "number",
    Value = "number",
    Duration = "number",
    Decimals = "number",
    Prefix = "string",
    Suffix = "string",
    Commas = "boolean"
};
local u4 = {
    [Enum.TextXAlignment.Center] = Enum.HorizontalAlignment.Center,
    [Enum.TextXAlignment.Left] = Enum.HorizontalAlignment.Left,
    [Enum.TextXAlignment.Right] = Enum.HorizontalAlignment.Right
};
local Frame = Instance.new("Frame");
local TextLabel = Instance.new("TextLabel");
TextLabel.TextScaled = true;
TextLabel.TextWrapped = true;
TextLabel.TextColor3 = Color3.fromRGB(250, 250, 255);
TextLabel.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json");

local function newSpinner(u5, u6, u7) -- Line: 32
    -- upvalues: Frame (copy), TextLabel (copy), u2 (copy), u4 (copy), u3 (copy), Digit (copy)
    local u8 = {
        Value = 0,
        Duration = 0.2,
        Decimals = 2,
        Prefix = "$",
        Suffix = "",
        Commas = false,
        ZeroPadding = 0,
        Digits = {
            Whole = table.create(3),
            Decimal = table.create(2)
        },
        CommaLabels = table.create(2)
    };
    local u18 = setmetatable({}, {
        __index = function(p9, u10) -- Line: 48, Name: __index
            -- upvalues: u8 (copy), Frame (ref), TextLabel (ref)
            local v11 = u8[u10];

            if v11 then
                return v11;
            end;

            if pcall(function() -- Line: 52
                -- upvalues: Frame (ref), u10 (copy)
                local _ = Frame[u10];
            end) then
                return u8.Frame[u10];
            end;

            local success, result = pcall(function() -- Line: 57
                -- upvalues: TextLabel (ref), u10 (copy)
                return TextLabel[u10];
            end);

            if not success then
                return nil;
            end;

            local v12 = u8.Digits.Whole[1];

            if v12 then
                return v12[u10];
            end;

            return result;
        end,

        __newindex = function(p13, u14, p15) -- Line: 72, Name: __newindex
            -- upvalues: u2 (ref), Frame (ref), u8 (copy), u4 (ref), TextLabel (ref), u3 (ref)
            if u2[u14] then
                warn("Attempted to set read-only value Spinner." .. u14);

                return;
            end;

            if pcall(function() -- Line: 76
                -- upvalues: Frame (ref), u14 (copy)
                local _ = Frame[u14];
            end) then
                local v16 = typeof(Frame[u14]);

                if v16 == "nil" or v16 == typeof(p15) then
                    u8.Frame[u14] = p15;

                    return;
                end;

                warn("Attempted to set Spinner." .. u14 .. " to invalid value (" .. tostring(p15) .. ")");

                return;
            end;

            if u14 == "TextXAlignment" then
                u8.Layout.HorizontalAlignment = u4[p15];

                return;
            end;

            if not pcall(function() -- Line: 96
                -- upvalues: TextLabel (ref), u14 (copy)
                local _ = TextLabel[u14];
            end) then
                if not u3[u14] then
                    return;
                end;

                if typeof(p15) ~= u3[u14] then
                    warn("Attempted to set Spinner." .. u14 .. " to invalid value (" .. tostring(p15) .. ")");

                    return;
                end;

                u8[u14] = p15;
                u8:Update(u14, p15);

                return;
            end;

            local v17 = typeof(TextLabel[u14]);

            if v17 ~= "nil" and v17 ~= typeof(p15) then
                warn("Attempted to set Spinner." .. u14 .. " to invalid value (" .. tostring(p15) .. ")");

                return;
            end;

            for _, v in pairs(u8.Digits.Whole) do
                v[u14] = p15;
            end;

            for _, v in pairs(u8.Digits.Decimal) do
                v[u14] = p15;
            end;

            for _, v in pairs(u8.CommaLabels) do
                v[u14] = p15;
            end;

            u8.PrefixLabel[u14] = p15;
            u8.SuffixLabel[u14] = p15;
            u8.DecimalLabel[u14] = p15;
            u8.NegativeLabel[u14] = p15;
        end
    });

    function u8.Destroy(p19) -- Line: 145
        p19.Frame:Destroy();
        table.clear(p19);
    end;

    function u8.Update(p20, p21, p22) -- Line: 149
        -- upvalues: u8 (copy), Digit (ref), u18 (copy), u5 (copy), u6 (copy), u7 (copy)
        if p21 == "Prefix" then
            u8.PrefixLabel.Text = u8.Prefix;

            return;
        end;

        if p21 == "Suffix" then
            u8.SuffixLabel.Text = u8.Suffix;

            return;
        end;

        local v23 = math.abs(u8.Value);
        local v24 = u8.Value < 0;

        if u8.NegativeLabel then
            u8.NegativeLabel.Visible = v24;
        end;

        local v25 = u8.Decimals > 0 and string.format("%." .. u8.Decimals .. "f", v23) or string.format("%d", v23);
        local v26 = string.split(v25, ".");
        local v27 = v26[1];
        local v28 = v26[2];

        if not v27 then
            return;
        end;

        if u8.ZeroPadding > 0 and #v27 < u8.ZeroPadding then
            v27 = string.format("%0" .. u8.ZeroPadding .. "i", tonumber(v27) or 0);
        end;

        local v29 = #v27;

        for i = 1, v29 do
            local v30 = u8.Digits.Whole[i];

            if v30 then
                v30.Duration = u8.Duration;
                local v31 = string.sub(v27, i, i);
                v30.Value = tonumber(v31);
            else
                local new = Digit.new;
                local v32 = string.sub(v27, i, i);
                local v33 = new(u18, u8, i * 2 - 900, tonumber(v32), u5);
                u8.Digits.Whole[i] = v33;
            end;
        end;

        for i = v29 + 1, #u8.Digits.Whole do
            local v34 = u8.Digits.Whole[i];

            if v34 then
                v34:Destroy();
                u8.Digits.Whole[i] = nil;
            end;
        end;

        if u8.Commas then
            local v35 = v29 * 2 - 900;
            local format = string.format;
            local v36 = math.abs(u8.Value);
            local v37 = 0;

            for i = 0, #format("%d", (math.floor(v36))) - 1, 3 do
                if i ~= 0 then
                    v37 = v37 + 1;
                    local v38 = u8.CommaLabels[v37];

                    if not v38 then
                        v38 = Instance.new("TextLabel");
                        v38.RichText = false;
                        v38.Name = "Comma";
                        v38.BackgroundTransparency = 1;
                        v38.Size = UDim2.new(0, 0, 1, 0);
                        v38.Font = u18.Font;
                        v38.TextColor3 = u18.TextColor3;
                        v38.Text = ",";
                        v38.AutomaticSize = Enum.AutomaticSize.X;

                        if u18.TextSize then
                            v38.TextSize = u18.TextSize;
                            v38.AutomaticSize = Enum.AutomaticSize.X;
                        else
                            v38.TextScaled = true;
                            v38.TextWrapped = true;
                            v38.AutomaticSize = Enum.AutomaticSize.X;
                        end;

                        if u6 then
                            u6:Clone().Parent = v38;
                        end;

                        if u7 then
                            u7:Clone().Parent = v38;
                        end;

                        v38.Parent = u8.Frame;
                        u8.CommaLabels[v37] = v38;
                    end;

                    v38.LayoutOrder = v35 - (i - 1) * 2 - 1;
                end;
            end;

            for i = v37 + 1, #u8.CommaLabels do
                u8.CommaLabels[i]:Destroy();
                u8.CommaLabels[i] = nil;
            end;
        end;

        if v28 then
            if u8.DecimalLabel then
                u8.DecimalLabel.Visible = true;
            end;

            for i = 1, #v28 do
                local v39 = u8.Digits.Decimal[i];

                if v39 then
                    v39.Duration = u8.Duration;
                    local v40 = string.sub(v28, i, i);
                    v39.Value = tonumber(v40);
                else
                    local new = Digit.new;
                    local v41 = string.sub(v28, i, i);
                    local v42 = new(u18, u8, i, tonumber(v41), u5);
                    u8.Digits.Decimal[i] = v42;
                end;
            end;

            for i = #v28 + 1, #u8.Digits.Decimal do
                local v43 = u8.Digits.Decimal[i];

                if v43 then
                    v43:Destroy();
                    u8.Digits.Decimal[i] = nil;
                end;
            end;

            return;
        end;

        if u8.DecimalLabel then
            u8.DecimalLabel.Visible = false;
        end;

        for _, v in ipairs(u8.Digits.Decimal) do
            v:Destroy();
        end;

        table.clear(u8.Digits.Decimal);
    end;

    return u18, u8;
end;

function u1.new(p44, p45, p46) -- Line: 286
    -- upvalues: newSpinner (copy)
    local v47, v48 = newSpinner(p44, p45);
    local Frame2 = Instance.new("Frame");
    Frame2.BackgroundTransparency = 1;
    Frame2.ClipsDescendants = true;
    Frame2.Size = UDim2.new(0, 200, 0, 50);
    Frame2.Position = UDim2.new(0, 0, 0, 0);
    Frame2.ZIndex = p44 and (p44.ZIndex or 1) or 1;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0, 0);
    UIListLayout.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Prefix";
    TextLabel2.LayoutOrder = -1000;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Size = UDim2.new(0, 0, 0.75, 0);
    TextLabel2.Font = v47.Font;
    TextLabel2.TextSize = v47.TextSize;
    TextLabel2.TextColor3 = v47.TextColor3;
    TextLabel2.Text = v47.Prefix;
    TextLabel2.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel2.Parent = Frame2;
    TextLabel2.ZIndex = p44 and (p44.ZIndex or 1) or 1;

    if v48.TextSize then
        TextLabel2.TextSize = v47.TextSize;
        TextLabel2.AutomaticSize = Enum.AutomaticSize.X;
    else
        TextLabel2.TextScaled = true;
        TextLabel2.TextWrapped = true;
        TextLabel2.AutomaticSize = Enum.AutomaticSize.X;
    end;

    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Suffix";
    TextLabel3.LayoutOrder = 1000;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Size = UDim2.new(0, 0, 0.75, 0);
    TextLabel3.Font = v47.Font;
    TextLabel3.TextSize = v47.TextSize;
    TextLabel3.TextColor3 = v47.TextColor3;
    TextLabel3.Text = v47.Suffix;
    TextLabel3.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel3.Parent = Frame2;
    TextLabel3.ZIndex = p44 and (p44.ZIndex or 1) or 1;

    if v48.TextSize then
        TextLabel3.TextSize = v47.TextSize;
        TextLabel3.AutomaticSize = Enum.AutomaticSize.X;
    else
        TextLabel3.TextScaled = true;
        TextLabel3.TextWrapped = true;
        TextLabel3.AutomaticSize = Enum.AutomaticSize.X;
    end;

    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Decimal";
    TextLabel4.LayoutOrder = 0;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.Size = UDim2.new(0, 0, 1, 0);
    TextLabel4.Font = v47.Font;
    TextLabel4.TextSize = v47.TextSize;
    TextLabel4.TextColor3 = v47.TextColor3;
    TextLabel4.Text = ".";
    TextLabel4.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel4.Parent = Frame2;
    TextLabel4.ZIndex = p44 and (p44.ZIndex or 1) or 1;

    if v48.TextSize then
        TextLabel4.TextSize = v47.TextSize;
        TextLabel4.AutomaticSize = Enum.AutomaticSize.X;
    else
        TextLabel4.TextScaled = true;
        TextLabel4.TextWrapped = true;
        TextLabel4.AutomaticSize = Enum.AutomaticSize.X;
    end;

    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Negative";
    TextLabel5.LayoutOrder = -999;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.Size = UDim2.new(0, 0, 1, 0);
    TextLabel5.Font = v47.Font;
    TextLabel5.TextSize = v47.TextSize;
    TextLabel5.TextColor3 = v47.TextColor3;
    TextLabel5.Text = "-";
    TextLabel5.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel5.Parent = Frame2;
    TextLabel5.ZIndex = p44 and p44.ZIndex or 1;

    if v48.TextSize then
        TextLabel5.TextSize = v47.TextSize;
        TextLabel5.AutomaticSize = Enum.AutomaticSize.X;
    else
        TextLabel5.TextScaled = true;
        TextLabel5.TextWrapped = true;
        TextLabel5.AutomaticSize = Enum.AutomaticSize.X;
    end;

    v48.Frame = Frame2;
    v48.Layout = UIListLayout;
    v48.PrefixLabel = TextLabel2;
    v48.SuffixLabel = TextLabel3;
    v48.DecimalLabel = TextLabel4;
    v48.NegativeLabel = TextLabel5;

    if p45 then
        for _, v in ipairs({
            TextLabel2,
            TextLabel3,
            TextLabel4,
            TextLabel5
        }) do
            p45:Clone().Parent = v;
        end;
    end;

    if p46 then
        for _, v in ipairs({
            TextLabel2,
            TextLabel3,
            TextLabel4,
            TextLabel5
        }) do
            p46:Clone().Parent = v;
        end;
    end;

    v47:Update();

    return v47;
end;

function u1.fromGuiObject(p49, p50, p51) -- Line: 410
    -- upvalues: u1 (copy), u4 (copy)
    if typeof(p49) ~= "Instance" then
        error("Invalid");
    end;

    if not p49:IsA("GuiObject") then
        error("Not a GUI object");
    end;

    local v52 = p49:FindFirstChildWhichIsA("UIStroke");
    local v53 = p49:FindFirstChildWhichIsA("UIGradient");

    if v52 then
        p51 = v53;
    end;

    local v54 = u1.new(p49, v52, p51);
    v54.Name = "Spinner_" .. p49.Name;
    v54.SizeConstraint = p49.SizeConstraint;
    v54.Size = p49.Size;
    v54.Position = p49.Position;
    v54.AnchorPoint = p49.AnchorPoint;
    v54.Rotation = p49.Rotation;
    v54.LayoutOrder = p49.LayoutOrder;
    v54.ZIndex = p49.ZIndex;
    v54.Visible = p49.Visible;
    v54.BackgroundColor3 = p49.BackgroundColor3;
    v54.BorderColor3 = p49.BorderColor3;
    v54.BorderSizePixel = p49.BorderSizePixel;
    v54.BackgroundTransparency = p49.BackgroundTransparency;
    v54.AutomaticSize = p49.AutomaticSize;
    v54.ClipsDescendants = false;

    if p49:IsA("TextLabel") or (p49:IsA("TextButton") or p49:IsA("TextBox")) then
        v54.Font = p49.Font;
        v54.TextSize = p49.TextSize;
        v54.TextColor3 = p49.TextColor3;
        v54.TextTransparency = p49.TextTransparency;
        v54.TextStrokeColor3 = p49.TextStrokeColor3;
        v54.TextStrokeTransparency = p49.TextStrokeTransparency;
        v54.Layout.HorizontalAlignment = u4[p49.TextXAlignment];
    end;

    v54.Parent = p49.Parent;
    p49.Visible = false;

    return v54;
end;

return u1;