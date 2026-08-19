-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {};
local u2 = nil;

local function ColorToHex(p3) -- Line: 46
    return string.format("#%02X%02X%02X", math.floor(p3.R * 255 + 0.5), math.floor(p3.G * 255 + 0.5), (math.floor(p3.B * 255 + 0.5)));
end;

local function EscapeRichText(p4) -- Line: 55
    local v5 = string.gsub(p4, "&", "&amp;");
    local v6 = string.gsub(v5, "<", "&lt;");
    local v7 = string.gsub(v6, ">", "&gt;");
    local v8 = string.gsub(v7, "\"", "&quot;");

    return string.gsub(v8, "\'", "&apos;");
end;

local function Render(p9) -- Line: 64
    -- upvalues: EscapeRichText (copy)
    local Label = p9.Label;

    if not Label.Parent then
        return;
    end;

    local HexColors = p9.HexColors;
    local v10 = #HexColors;

    if v10 == 0 then
        return;
    end;

    if v10 == 1 then
        Label.RichText = false;
        Label.TextColor3 = p9.Colors[1];
        Label.Text = p9.Plain;

        return;
    end;

    Label.RichText = true;
    local v11 = 0;
    local v12 = {};

    for i, v in utf8.graphemes(p9.Plain) do
        local v13 = EscapeRichText((string.sub(p9.Plain, i, v)));
        v12[#v12 + 1] = `<font color="{HexColors[(v11 + p9.Offset) % v10 + 1]}">{v13}</font>`;
        v11 = v11 + 1;
    end;

    Label.Text = table.concat(v12);
end;

local function EnsureLoop() -- Line: 91
    -- upvalues: u2 (ref), RunService (copy), u1 (copy), Render (copy)
    if u2 then
        return;
    end;

    u2 = RunService.Heartbeat:Connect(function() -- Line: 93
        -- upvalues: u1 (ref), Render (ref)
        local v14 = os.clock();

        for i in u1 do
            if #i.HexColors > 1 and v14 >= i.NextStep then
                i.NextStep = v14 + i.Interval;
                i.Offset = i.Offset + (i.Reverse and -1 or 1);
                Render(i);
            end;
        end;
    end);
end;

local function ApplyConfig(p15, p16) -- Line: 105
    local Colors = p16.Colors;
    p15.Colors = Colors;
    local v17 = table.create(#Colors);

    for i, v in Colors do
        v17[i] = string.format("#%02X%02X%02X", math.floor(v.R * 255 + 0.5), math.floor(v.G * 255 + 0.5), (math.floor(v.B * 255 + 0.5)));
    end;

    p15.HexColors = v17;
    p15.Interval = p16.Interval or 0.5;
    p15.Reverse = p16.Reverse == true;
    p15.NextStep = os.clock() + p15.Interval;
end;

return table.freeze({
    Apply = function(p18, p19) -- Line: 121, Name: Apply
        -- upvalues: ApplyConfig (copy), Render (copy), u1 (copy), u2 (ref), RunService (copy)
        local v20;

        if typeof(p18) == "Instance" then
            v20 = p18:IsA("TextLabel");
        else
            v20 = false;
        end;

        assert(v20, "AnimatedTextGradient.Apply expects a TextLabel");
        local u21 = {
            Offset = 0,
            Interval = 0.5,
            Reverse = false,
            NextStep = 0,
            Label = p18,
            Plain = p18.Text,
            Colors = {},
            HexColors = {}
        };
        ApplyConfig(u21, p19);
        Render(u21);
        u1[u21] = true;

        if not u2 then
            u2 = RunService.Heartbeat:Connect(function() -- Line: 93
                -- upvalues: u1 (ref), Render (ref)
                local v22 = os.clock();

                for i in u1 do
                    if #i.HexColors > 1 and v22 >= i.NextStep then
                        i.NextStep = v22 + i.Interval;
                        i.Offset = i.Offset + (i.Reverse and -1 or 1);
                        Render(i);
                    end;
                end;
            end);
        end;

        return {
            SetText = function(p23, p24) -- Line: 141, Name: SetText
                -- upvalues: u21 (copy), Render (ref)
                u21.Plain = p24;
                Render(u21);
            end,

            SetConfig = function(p25, p26) -- Line: 145, Name: SetConfig
                -- upvalues: ApplyConfig (ref), u21 (copy), Render (ref)
                ApplyConfig(u21, p26);
                Render(u21);
            end,

            Destroy = function(p27) -- Line: 149, Name: Destroy
                -- upvalues: u1 (ref), u21 (copy), u2 (ref)
                u1[u21] = nil;

                if next(u1) == nil and u2 then
                    u2:Disconnect();
                    u2 = nil;
                end;
            end
        };
    end
});