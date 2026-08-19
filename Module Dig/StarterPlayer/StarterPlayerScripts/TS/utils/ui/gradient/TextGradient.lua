-- Decompiled with Potassium's decompiler.

local CollectionService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService;
local u1 = Color3.new(1, 1, 1);

local function removeStoredTag(p2) -- Line: 8
    -- upvalues: CollectionService (copy)
    local v3 = p2:GetAttribute("TextGradientTag");

    if type(v3) == "string" then
        CollectionService:RemoveTag(p2, v3);
        p2:SetAttribute("TextGradientTag", nil);
    end;
end;

local function buildOverlay(p4, p5, p6, p7, p8) -- Line: 15
    -- upvalues: u1 (copy), CollectionService (copy)
    local v9 = p4:Clone();
    v9.Name = "TextGradientOverlay";

    for _, child in v9:GetChildren() do
        child:Destroy();
    end;

    v9.AnchorPoint = Vector2.new(0.5, 0.5);
    v9.Position = UDim2.fromScale(0.5, 0.5);
    v9.Size = UDim2.fromScale(1, 1);
    v9.Rotation = 0;
    v9.BackgroundTransparency = 1;
    v9.TextColor3 = u1;
    v9.TextTransparency = 0;
    v9.ZIndex = p4.ZIndex + 1;
    v9.Text = p5;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "TextGradient";
    UIGradient.Color = p6;
    UIGradient.Rotation = p7;
    UIGradient.Parent = v9;
    v9.Parent = p4;

    if p8 ~= nil then
        v9:SetAttribute("TextGradientTag", p8);
        CollectionService:AddTag(v9, p8);
    end;

    return {
        overlay = v9,
        gradient = UIGradient
    };
end;

local function hidden(p10) -- Line: 45
    return `<font transparency="1">{p10}</font>`;
end;

local function solid(p11, p12) -- Line: 48
    return `<font color="rgb({math.floor(p12.R * 255 + 0.5)},{math.floor(p12.G * 255 + 0.5)},{math.floor(p12.B * 255 + 0.5)})">{p11}</font>`;
end;

local v13 = {};
local u14 = nil;

function v13.apply(p15, p16, p17, p18) -- Line: 58
    -- upvalues: u14 (ref), CollectionService (copy)
    u14(p15);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "TextGradient";
    UIGradient.Color = p16;
    UIGradient.Rotation = p17 == nil and 0 or p17;
    UIGradient.Parent = p15;

    if p18 ~= nil then
        p15:SetAttribute("TextGradientTag", p18);
        CollectionService:AddTag(p15, p18);
    end;

    return UIGradient;
end;

u14 = function(p19) -- Line: 75, Name: clear
    -- upvalues: CollectionService (copy)
    local v20 = p19:GetAttribute("TextGradientTag");

    if type(v20) == "string" then
        CollectionService:RemoveTag(p19, v20);
        p19:SetAttribute("TextGradientTag", nil);
    end;

    local TextGradient = p19:FindFirstChild("TextGradient");

    if TextGradient ~= nil then
        TextGradient:Destroy();
    end;

    for _, child in p19:GetChildren() do
        if child.Name == "TextGradientOverlay" then
            local v21 = child:GetAttribute("TextGradientTag");

            if type(v21) == "string" then
                CollectionService:RemoveTag(child, v21);
                child:SetAttribute("TextGradientTag", nil);
            end;

            child:Destroy();
        end;
    end;
end;

v13.clear = u14;

function v13.applySegments(p22, p23) -- Line: 94
    -- upvalues: u14 (ref), u1 (copy), buildOverlay (copy)
    u14(p22);
    p22.RichText = true;
    p22.TextColor3 = u1;
    local v24 = table.create(#p23);

    for i = 0, #p23 - 1 do
        local v25 = p23[i + 1];
        local v26;

        if v25.gradient then
            v26 = `<font transparency="1">{v25.text}</font>`;
        elseif v25.color then
            local text = v25.text;
            local color = v25.color;
            v26 = `<font color="rgb({math.floor(color.R * 255 + 0.5)},{math.floor(color.G * 255 + 0.5)},{math.floor(color.B * 255 + 0.5)})">{text}</font>`;
        else
            v26 = v25.text;
        end;

        v24[i + 1] = v26;
    end;

    p22.Text = table.concat(v24, "");

    for i = 0, #p23 - 1 do
        local v27 = p23[i + 1];

        if v27.gradient then
            local v28 = table.create(#p23);

            for i2 = 0, #p23 - 1 do
                local v29;

                if i2 == i then
                    v29 = p23[i2 + 1].text;
                else
                    v29 = `<font transparency="1">{p23[i2 + 1].text}</font>`;
                end;

                v28[i2 + 1] = v29;
            end;

            local v30 = table.concat(v28, "");
            local rotation = v27.rotation;
            buildOverlay(p22, v30, v27.gradient, rotation == nil and 0 or rotation, v27.animationTag);
        end;
    end;
end;

function v13.applyHighlight(p31, p32, p33, p34, p35, p36) -- Line: 124
    -- upvalues: u14 (ref), buildOverlay (copy), CollectionService (copy)
    local v37 = p36 == nil and "" or p36;
    u14(p31);
    p31.RichText = true;
    p31.Text = `{p32}{`<font transparency="1">{p33}</font>`}{v37}`;
    local v38;

    if v37 == "" then
        v38 = `{`<font transparency="1">{p32}</font>`}{p33}`;
    else
        v38 = `{`<font transparency="1">{p32}</font>`}{p33}{`<font transparency="1">{v37}</font>`}`;
    end;

    local v39 = buildOverlay(p31, v38, p34, 0, p35);
    local overlay = v39.overlay;

    return {
        overlay = overlay,
        gradient = v39.gradient,

        destroy = function() -- Line: 137, Name: destroy
            -- upvalues: overlay (copy), CollectionService (ref)
            local v40 = overlay;
            local v41 = v40:GetAttribute("TextGradientTag");

            if type(v41) == "string" then
                CollectionService:RemoveTag(v40, v41);
                v40:SetAttribute("TextGradientTag", nil);
            end;

            overlay:Destroy();
        end
    };
end;

return {
    TextGradient = v13
};