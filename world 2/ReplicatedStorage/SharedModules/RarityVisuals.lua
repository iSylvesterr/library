-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {};
local u2 = {
    Common = Color3.fromRGB(170, 170, 170),
    Uncommon = Color3.fromRGB(40, 200, 40),
    Rare = Color3.fromRGB(60, 130, 240),
    Epic = Color3.fromRGB(170, 80, 230),
    Legendary = Color3.fromRGB(245, 200, 60),
    Mythic = Color3.fromRGB(220, 50, 50)
};
local u3 = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 165, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 200, 0),
    Color3.fromRGB(0, 100, 255),
    Color3.fromRGB(180, 0, 220)
};

local function lerpColor(p4, p5, p6) -- Line: 26
    return Color3.new(p4.R + (p5.R - p4.R) * p6, p4.G + (p5.G - p4.G) * p6, p4.B + (p5.B - p4.B) * p6);
end;

local function sampleRainbow(p7) -- Line: 30
    -- upvalues: u3 (copy), lerpColor (copy)
    local v8 = #u3;
    local v9 = p7 % 1 * v8;
    local v10 = math.floor(v9);

    return lerpColor(u3[v10 + 1], u3[(v10 + 1) % v8 + 1], v9 - v10);
end;

local function sampleSecret(p11) -- Line: 40
    -- upvalues: lerpColor (copy)
    local v12;

    if p11 < 0.5 then
        v12 = p11 * 2;
    else
        v12 = (1 - p11) * 2;
    end;

    return lerpColor(Color3.new(1, 1, 1), Color3.new(0, 0, 0), v12);
end;

local function applyColor(p13, u14) -- Line: 45
    for _, v in p13 do
        if v and v.Parent then
            pcall(function() -- Line: 48
                -- upvalues: v (copy), u14 (copy)
                v.TextColor3 = u14;
            end);
            pcall(function() -- Line: 49
                -- upvalues: v (copy), u14 (copy)
                v.TextStrokeColor3 = u14;
            end);
            pcall(function() -- Line: 50
                -- upvalues: v (copy), u14 (copy)
                v.ImageColor3 = u14;
            end);
        end;
    end;
end;

function u1.GetStaticColor(p15) -- Line: 54
    -- upvalues: u2 (copy), sampleRainbow (copy), sampleSecret (copy)
    if u2[p15] then
        return u2[p15];
    end;

    if p15 == "Super" then
        return sampleRainbow(0);
    end;

    if p15 == "Secret" then
        return sampleSecret(0);
    end;

    return Color3.new(1, 1, 1);
end;

local function colorToHex(p16) -- Line: 61
    return string.format("#%02X%02X%02X", math.floor(p16.R * 255 + 0.5), math.floor(p16.G * 255 + 0.5), (math.floor(p16.B * 255 + 0.5)));
end;

function u1.RichText(p17, p18) -- Line: 65
    -- upvalues: u3 (copy), u1 (copy)
    if type(p17) ~= "string" or p17 == "" then
        return p17;
    end;

    if p18 == "Super" then
        local v19 = math.max(1, #p17 - 1);
        local v20 = {};

        for i = 1, #p17 do
            local v21 = #u3;
            local v22 = (i - 1) / v19 % 1 * v21;
            local v23 = math.floor(v22);
            local v24 = v22 - v23;
            local v25 = u3[v23 + 1];
            local v26 = u3[(v23 + 1) % v21 + 1];
            local v27 = Color3.new(v25.R + (v26.R - v25.R) * v24, v25.G + (v26.G - v25.G) * v24, v25.B + (v26.B - v25.B) * v24);
            local v28 = string.format("#%02X%02X%02X", math.floor(v27.R * 255 + 0.5), math.floor(v27.G * 255 + 0.5), (math.floor(v27.B * 255 + 0.5)));
            local format = string.format;
            local v29 = string.sub(p17, i, i);
            table.insert(v20, format("<font color=\"%s\">%s</font>", v28, v29));
        end;

        return table.concat(v20);
    end;

    if p18 ~= "Secret" then
        local format = string.format;
        local v30 = u1.GetStaticColor(p18);

        return format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math.floor(v30.R * 255 + 0.5), math.floor(v30.G * 255 + 0.5), (math.floor(v30.B * 255 + 0.5))), p17);
    end;

    local v31 = Color3.fromRGB(240, 240, 240);
    local v32 = Color3.fromRGB(40, 40, 40);
    local v33 = {};

    for i = 1, #p17 do
        local v34;

        if i % 2 == 1 then
            v34 = v31;
        else
            v34 = v32;
        end;

        local v35 = string.format("#%02X%02X%02X", math.floor(v34.R * 255 + 0.5), math.floor(v34.G * 255 + 0.5), (math.floor(v34.B * 255 + 0.5)));
        local format = string.format;
        local v36 = string.sub(p17, i, i);
        table.insert(v33, format("<font color=\"%s\">%s</font>", v35, v36));
    end;

    return table.concat(v33);
end;

function u1.ApplyToLabels(u37, p38) -- Line: 92
    -- upvalues: RunService (copy), applyColor (copy), sampleRainbow (copy), sampleSecret (copy), u1 (copy)
    if #u37 == 0 then
        return function() -- Line: 93
        end;
    end;

    if p38 == "Super" then
        local u39 = os.clock();
        local u40 = RunService.Heartbeat:Connect(function() -- Line: 97
            -- upvalues: u39 (copy), applyColor (ref), u37 (copy), sampleRainbow (ref)
            applyColor(u37, sampleRainbow((os.clock() - u39) % 3 / 3));
        end);

        return function() -- Line: 101
            -- upvalues: u40 (copy)
            if u40 then
                u40:Disconnect();
            end;
        end;
    end;

    if p38 ~= "Secret" then
        applyColor(u37, u1.GetStaticColor(p38));

        return function() -- Line: 115
        end;
    end;

    local u41 = os.clock();
    local u42 = RunService.Heartbeat:Connect(function() -- Line: 106
        -- upvalues: u41 (copy), applyColor (ref), u37 (copy), sampleSecret (ref)
        applyColor(u37, sampleSecret((os.clock() - u41) % 1.5 / 1.5));
    end);

    return function() -- Line: 110
        -- upvalues: u42 (copy)
        if u42 then
            u42:Disconnect();
        end;
    end;
end;

return u1;