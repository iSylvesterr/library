-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Audio = require(ReplicatedStorage.Library.Audio);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Normal = require(ReplicatedStorage.Directory.Sounds.Languages.Alphabet._Index.Normal);
local u2 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u3 = {
    Color = "TextColor3",
    StrokeColor = "TextStrokeColor3",
    ImageColor = "ImageColor3"
};
u1.ColorShortcuts = {};
u1.ColorShortcuts.White = Color3.new(1, 1, 1);
u1.ColorShortcuts.Black = Color3.new(0, 0, 0);
u1.ColorShortcuts.Red = Color3.new(1, 0.4, 0.4);
u1.ColorShortcuts.Green = Color3.new(0.4, 1, 0.4);
u1.ColorShortcuts.Blue = Color3.new(0.4, 0.4, 1);
u1.ColorShortcuts.Cyan = Color3.new(0.4, 0.85, 1);
u1.ColorShortcuts.Orange = Color3.new(1, 0.5, 0.2);
u1.ColorShortcuts.Yellow = Color3.new(1, 0.9, 0.2);
u1.ImageShortcuts = {};
u1.ImageShortcuts.Eggplant = 639588687;
u1.ImageShortcuts.Thinking = 955646496;
u1.ImageShortcuts.Sad = 947900188;
u1.ImageShortcuts.Happy = 414889555;
u1.ImageShortcuts.Despicable = 711674643;
local v4 = {};
u1.MarkupShortcuts = v4;
v4.Font = {
    Start = "<Font=%s>",
    End = "<Font=/>"
};
v4.Img = {
    Start = "<Img=%s>",
    End = "<Img=/>"
};
v4.AnimateStepTime = {
    Start = "<AnimateStepTime=%s>",
    End = "<AnimateStepTime=/>"
};
v4.AnimateYield = {
    Start = "<AnimateYield=%s>",
    End = "<AnimateYield=/>"
};
v4.TextColor3 = {
    Start = "<TextColor3=%s>",
    End = "<TextColor3=/>"
};
v4.Color = {
    Start = "<Color=%s>",
    End = "<Color=/>"
};
v4.AnimateStepFrequency = {
    Start = "<AnimateStepFrequency=%s>",
    End = "<AnimateStepFrequency=/>"
};
v4.AnimateStyleTime = {
    Start = "<AnimateStyleTime=%s>",
    End = "<AnimateStyleTime=/>"
};
v4.AnimateStyle = {
    Start = "<AnimateStyle=%s>",
    End = "<AnimateStyle=/>"
};
v4.FadeAnimateStyle = {
    Start = "<AnimateStepFrequency=1><AnimateStyleTime=.6><AnimateStyle=Fade>",
    End = "<AnimateStepFrequency=/><AnimateStyleTime=/><AnimateStyle=/>"
};
v4.AppearAnimateStyle = {
    Start = "<AnimateStepFrequency=1><AnimateStyleTime=.6><AnimateStyle=Appear>",
    End = "<AnimateStepFrequency=/><AnimateStyleTime=/><AnimateStyle=/>"
};
v4.WiggleAnimateStyle = {
    Start = "<AnimateStepFrequency=1><AnimateStyleTime=.6><AnimateStyle=Wiggle>",
    End = "<AnimateStepFrequency=/><AnimateStyleTime=/><AnimateStyle=/>"
};
v4.SwingAnimateStyle = {
    Start = "<AnimateStepFrequency=1><AnimateStyleTime=.6><AnimateStyle=Swing>",
    End = "<AnimateStepFrequency=/><AnimateStyleTime=/><AnimateStyle=/>"
};
v4.RainbowAnimateStyle = {
    Start = "<AnimateStepFrequency=1><AnimateStyleTime=.6><AnimateStyle=Rainbow>",
    End = "<AnimateStepFrequency=/><AnimateStyleTime=/><AnimateStyle=/>"
};
v4.SpinAnimateStyle = {
    Start = "<AnimateStepFrequency=1><AnimateStyleTime=.6><AnimateStyle=Spin>",
    End = "<AnimateStepFrequency=/><AnimateStyleTime=/><AnimateStyle=/>"
};
local u5 = {
    ContainerHorizontalAlignment = "Left",
    ContainerVerticalAlignment = "Center",
    TextYAlignment = "Bottom",
    TextScaled = true,
    TextScaleRelativeTo = "Frame",
    TextScale = 0.4,
    TextSize = 20,
    Font = "FredokaOne",
    TextColor3 = "White",
    TextStrokeColor3 = "Black",
    TextTransparency = 0,
    TextStrokeTransparency = 1,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ImageColor3 = "White",
    ImageTransparency = 0,
    ImageRectOffset = "0,0",
    ImageRectSize = "0,0",
    AnimateStepTime = 0.025,
    AnimateStepGrouping = "Letter",
    AnimateStepFrequency = 1,
    AnimateYield = 0,
    AnimateStyle = "Appear",
    AnimateStyleTime = 0.5,
    AnimateStyleNumPeriods = 3,
    AnimateStyleAmplitude = 0.5,
    Punctuations = "[,%.%!%?]",
    PunctuationDelay = 0.2,
    PunctuationEnabled = true,
    TypingSound = "rbxassetid://91414159854126",
    SyllableRegistry = nil,
    CustomLayerSize = nil,
    UITextStrokeThickness = 2.6
};
local u27 = {
    Appear = function(p6) -- Line: 388, Name: Appear
        p6.Visible = true;
    end,

    Fade = function(p7, p8, p9) -- Line: 392, Name: Fade
        p7.Visible = true;

        if p7:IsA("TextLabel") then
            p7.TextTransparency = 1 - p8 * (1 - p9.TextTransparency);

            return;
        end;

        if p7:IsA("ImageLabel") then
            p7.ImageTransparency = 1 - p8 * (1 - p9.ImageTransparency);
        end;
    end,

    Wiggle = function(p10, p11, p12) -- Line: 401, Name: Wiggle
        p10.Visible = true;
        local v13 = p12.InitialSize.Y.Offset * (1 - p11) * p12.AnimateStyleAmplitude;
        p10.Position = p12.InitialPosition + UDim2.new(0, 0, 0, math.sin(p11 * 3.141592653589793 * 2 * p12.AnimateStyleNumPeriods) * v13 / 2);
    end,

    Swing = function(p14, p15, p16) -- Line: 408, Name: Swing
        p14.Visible = true;
        local v17 = 90 * (1 - p15) * p16.AnimateStyleAmplitude;
        p14.Rotation = math.sin(p15 * 3.141592653589793 * 2 * p16.AnimateStyleNumPeriods) * v17;
    end,

    Spin = function(p18, p19, p20) -- Line: 414, Name: Spin
        p18.Visible = true;
        p18.Position = p20.InitialPosition + UDim2.new(0, p20.InitialSize.X.Offset / 2, 0, p20.InitialSize.Y.Offset / 2);
        p18.AnchorPoint = Vector2.new(0.5, 0.5);
        p18.Rotation = p19 * p20.AnimateStyleNumPeriods * 360;
    end,

    Rainbow = function(p21, p22, p23) -- Line: 422, Name: Rainbow
        p21.Visible = true;
        local v24 = Color3.fromHSV(p22 * p23.AnimateStyleNumPeriods % 1, 1, 1);

        if p21:IsA("TextLabel") then
            local v25 = getColorFromString(p23.TextColor3);
            p21.TextColor3 = Color3.new(v24.r + p22 * (v25.r - v24.r), v24.g + p22 * (v25.g - v24.g), v24.b + p22 * (v25.b - v24.b));

            return;
        end;

        local v26 = getColorFromString(p23.ImageColor3);
        p21.ImageColor3 = Color3.new(v24.r + p22 * (v26.r - v24.r), v24.g + p22 * (v26.g - v24.g), v24.b + p22 * (v26.b - v24.b));
    end
};
local TextService = game:GetService("TextService");
local RunService = game:GetService("RunService");
local u28 = 0;

function getLayerCollector(p29)
    if not p29 then
        return nil;
    end;

    if p29:IsA("LayerCollector") then
        return p29;
    end;

    if p29 and p29.Parent then
        return getLayerCollector(p29.Parent);
    end;

    return nil;
end;

function getColorFromString(p30)
    -- upvalues: u1 (copy)
    if u1.ColorShortcuts[p30] then
        return u1.ColorShortcuts[p30];
    end;

    local v31, v32, v33 = p30:match("(%d+),(%d+),(%d+)");

    return Color3.new(v31 / 255, v32 / 255, v33 / 255);
end;

function getVector2FromString(p34)
    local v35, v36 = p34:match("(%d+),(%d+)");

    return Vector2.new(v35, v36);
end;

function setHorizontalAlignment(p37, p38)
    if p38 == "Left" then
        p37.AnchorPoint = Vector2.new(0, 0);
        p37.Position = UDim2.new(0, 0, 0, 0);

        return;
    end;

    if p38 ~= "Center" then
        if p38 == "Right" then
            p37.AnchorPoint = Vector2.new(1, 0);
            p37.Position = UDim2.new(1, 0, 0, 0);
        end;

        return;
    end;

    p37.AnchorPoint = Vector2.new(0.5, 0);
    p37.Position = UDim2.new(0.5, 0, 0, 0);
end;

function u1.New(p39, u40, p41, p42, p43, p44, u45, u46) -- Line: 485
    -- upvalues: Asserts (copy), u5 (copy), u3 (copy), u2 (copy), TextService (copy), u1 (copy), u28 (ref), RunService (copy), u27 (copy), Normal (copy), Audio (copy), ReplicatedFirst (copy)
    Asserts.optional.string(u46);

    for _, child in pairs(u40:GetChildren()) do
        child:Destroy();
    end;

    local u47 = p43 == nil and true or p43;

    if u45 == nil then
        u45 = u5.PunctuationEnabled and u5.PunctuationDelay or false;
    elseif (typeof(u45) ~= "number" or not u45) and u45 then
        u45 = u5.PunctuationDelay;
    end;

    local u48 = {};
    local u49 = {};

    if p44 then
        p41 = p44.Text;
        p42 = p44.StartingProperties;
    end;

    local u50 = {};
    local u51 = {};
    local u52 = {};
    local u53 = 0;
    local u54 = false;
    local TextLabel = Instance.new("TextLabel");
    local UIStroke = Instance.new("UIStroke");
    local ImageLabel = Instance.new("ImageLabel");
    local u55 = getLayerCollector(u40);
    UIStroke.Thickness = u5.UITextStrokeThickness;
    UIStroke.Parent = TextLabel;
    TextLabel.FontFace.Weight = Enum.FontWeight.Bold;
    TextLabel.AutoLocalize = false;
    local u56 = nil;
    local u57 = nil;

    local function applyMarkup(p58, p59) -- Line: 535
        -- upvalues: u3 (ref), u49 (copy), u48 (ref), u56 (ref), u50 (copy), u5 (ref), u57 (ref), u2 (ref)
        local v60 = u3[p58] or p58;

        if p59 == "/" then
            if u49[v60] then
                p59 = u49[v60];
            else
                warn("Attempt to default <" .. v60 .. "> to value with no default");
            end;
        end;

        if tonumber(p59) then
            p59 = tonumber(p59);
        elseif p59 == "false" or p59 == "true" then
            p59 = p59 == "true";
        end;

        u48[v60] = p59;

        if u56(v60, p59) then
            return true;
        end;

        if v60 == "ContainerHorizontalAlignment" and u50[#u50] then
            setHorizontalAlignment(u50[#u50].Container, p59);
        else
            if u5[v60] then
                return true;
            end;

            if v60 ~= "Img" then
                u2:AtWarning():Log((`Unknown property <{v60}> with value <{p59}>. This will not be applied.`));

                return false;
            end;

            u57(p59);
        end;

        return true;
    end;

    u56 = function(u61, p62, p63) -- Line: 567, Name: applyProperty
        -- upvalues: TextLabel (copy), ImageLabel (copy)
        local u64 = nil;
        local v65 = false;

        for _, v in pairs(p63 and { p63 } or { TextLabel, ImageLabel }) do
            if pcall(function() -- Line: 571
                -- upvalues: u64 (ref), v (copy), u61 (copy)
                u64 = typeof(v[u61]);
            end) then
                if u64 == "Color3" then
                    v[u61] = getColorFromString(p62);
                elseif u64 == "Vector2" then
                    v[u61] = getVector2FromString(p62);
                else
                    v[u61] = p62;
                end;

                v65 = true;
            end;
        end;

        return v65;
    end;

    for i, v in pairs(u5) do
        applyMarkup(i, v);
        u49[u3[i] or i] = u48[u3[i] or i];
    end;

    for i, v in pairs(p42 or {}) do
        applyMarkup(i, v);
        u49[u3[i] or i] = u48[u3[i] or i];
    end;

    if p44 then
        u48 = p44.OverflowPickupProperties;

        for i, v in pairs(u48) do
            applyMarkup(i, v);
        end;
    end;

    local function getTextSize() -- Line: 605
        -- upvalues: u48 (ref), u55 (copy), u40 (copy)
        if u48.TextScaled ~= true then
            return u48.TextSize;
        end;

        local v66 = nil;

        if u48.TextScaleRelativeTo == "Screen" then
            v66 = u55.AbsoluteSize.Y;
        elseif u48.TextScaleRelativeTo == "Frame" then
            v66 = u40.AbsoluteSize.Y;
        end;

        return math.min(u48.TextScale * v66, 100);
    end;

    local u67 = 0;

    local function newLine() -- Line: 620
        -- upvalues: u50 (copy), u67 (ref), u47 (ref), u48 (ref), u55 (copy), u40 (copy), u54 (ref), u51 (copy), u53 (ref)
        local v68 = u50[#u50];

        if v68 then
            u67 = u67 + v68.Size.Y.Offset;

            if not u47 then
                local v69;

                if u48.TextScaled == true then
                    local v70 = nil;

                    if u48.TextScaleRelativeTo == "Screen" then
                        v70 = u55.AbsoluteSize.Y;
                    elseif u48.TextScaleRelativeTo == "Frame" then
                        v70 = u40.AbsoluteSize.Y;
                    end;

                    v69 = math.min(u48.TextScale * v70, 100);
                else
                    v69 = u48.TextSize;
                end;

                if u67 + v69 > u40.AbsoluteSize.Y then
                    u54 = true;

                    return;
                end;
            end;
        end;

        local Frame = Instance.new("Frame");
        Frame.Name = string.format("Line%03d", #u50 + 1);
        Frame.Size = UDim2.new(0, 0, 0, 0);
        Frame.BackgroundTransparency = 1;
        local Frame2 = Instance.new("Frame", Frame);
        Frame2.Name = "Container";
        Frame2.Size = UDim2.new(0, 0, 0, 0);
        Frame2.BackgroundTransparency = 1;
        setHorizontalAlignment(Frame2, u48.ContainerHorizontalAlignment);
        Frame.Parent = u40;
        table.insert(u50, Frame);
        u51[#u50] = {};
        u53 = 0;
    end;

    newLine();

    local function addFrameProperties(p71) -- Line: 647
        -- upvalues: u52 (copy), u48 (ref)
        u52[p71] = table.clone(u48);
        u52[p71].InitialSize = p71.Size;
        u52[p71].InitialPosition = p71.Position;
        u52[p71].InitialAnchorPoint = p71.AnchorPoint;
    end;

    local function formatLabel(p72, p73, p74, p75) -- Line: 654
        -- upvalues: u50 (copy), u48 (ref), u53 (ref), u40 (copy), u51 (copy), newLine (copy), u52 (copy)
        local v76 = u50[#u50];
        local v77 = tostring(u48.TextYAlignment);

        if v77 == "Top" then
            p72.Position = UDim2.new(0, u53, 0, 0);
            p72.AnchorPoint = Vector2.new(0, 0);
        elseif v77 == "Center" then
            p72.Position = UDim2.new(0, u53, 0.5, 0);
            p72.AnchorPoint = Vector2.new(0, 0.5);
        elseif v77 == "Bottom" then
            p72.Position = UDim2.new(0, u53, 1, 0);
            p72.AnchorPoint = Vector2.new(0, 1);
        end;

        u53 = u53 + p74;

        if u53 > u40.AbsoluteSize.X and u53 ~= p74 then
            p72:Destroy();
            local v78 = u51[#u50][#u51[#u50]];

            if v78:IsA("TextLabel") and v78.Text == " " then
                v76.Container.Size = UDim2.new(0, u53 - p74 - v78.Size.X.Offset, 1, 0);
                v78:Destroy();
                table.remove(u51[#u50]);
            end;

            newLine();
            p75();

            return;
        end;

        p72.Size = UDim2.new(0, p74, 0, p73);
        v76.Container.Size = UDim2.new(0, u53, 1, 0);
        v76.Size = UDim2.new(1, 0, 0, (math.max(v76.Size.Y.Offset, p73)));
        p72.Name = string.format("Group%03d", #u51[#u50] + 1);
        p72.Parent = v76.Container;
        table.insert(u51[#u50], p72);
        u52[p72] = table.clone(u48);
        u52[p72].InitialSize = p72.Size;
        u52[p72].InitialPosition = p72.Position;
        u52[p72].InitialAnchorPoint = p72.AnchorPoint;
        u48.AnimateYield = 0;
    end;

    local function printText(u79) -- Line: 694
        -- upvalues: newLine (copy), u53 (ref), u48 (ref), u55 (copy), u40 (copy), TextService (ref), TextLabel (copy), u52 (copy), formatLabel (ref), u54 (ref), printText (ref)
        if u79 == "\n" then
            newLine();

            return;
        end;

        if u79 == " " and u53 == 0 then
            return;
        end;

        local v80;

        if u48.TextScaled == true then
            local v81 = nil;

            if u48.TextScaleRelativeTo == "Screen" then
                v81 = u55.AbsoluteSize.Y;
            elseif u48.TextScaleRelativeTo == "Frame" then
                v81 = u40.AbsoluteSize.Y;
            end;

            v80 = math.min(u48.TextScale * v81, 100);
        else
            v80 = u48.TextSize;
        end;

        local X = TextService:GetTextSize(u79, v80, TextLabel.Font, Vector2.new(u55.AbsoluteSize.X, v80)).X;
        local v82 = TextLabel:Clone();
        v82.TextScaled = false;
        v82.TextSize = v80;
        v82.Text = u79;
        v82.TextTransparency = 1;
        v82.TextStrokeTransparency = 1;
        v82.TextWrapped = false;
        local v83 = 1;
        local v84 = 0;

        for i, v in utf8.graphemes(u79) do
            local v85 = string.sub(u79, i, v);
            local X2 = TextService:GetTextSize(v85, v80, TextLabel.Font, Vector2.new(u55.AbsoluteSize.X, v80)).X;
            local v86 = TextLabel:Clone();
            v86.Text = v85;
            v86.TextScaled = false;
            v86.TextSize = v80;
            v86.Position = UDim2.new(0, v84, 0, 0);
            v86.Size = UDim2.new(0, X2 + 3, 0, v80);
            v86.Name = string.format("Char%03d", v83);
            v86.Parent = v82;
            v86.Visible = false;
            u52[v86] = table.clone(u48);
            u52[v86].InitialSize = v86.Size;
            u52[v86].InitialPosition = v86.Position;
            u52[v86].InitialAnchorPoint = v86.AnchorPoint;
            v84 = v84 + X2;
            v83 = v83 + 1;
        end;

        formatLabel(v82, v80, X, function() -- Line: 750
            -- upvalues: u54 (ref), printText (ref), u79 (copy)
            if not u54 then
                printText(u79);
            end;
        end);
    end;

    u57 = function(u87) -- Line: 757, Name: printImage
        -- upvalues: u48 (ref), u55 (copy), u40 (copy), ImageLabel (copy), u1 (ref), formatLabel (ref), u54 (ref), u57 (ref)
        local v88;

        if u48.TextScaled == true then
            local v89 = nil;

            if u48.TextScaleRelativeTo == "Screen" then
                v89 = u55.AbsoluteSize.Y;
            elseif u48.TextScaleRelativeTo == "Frame" then
                v89 = u40.AbsoluteSize.Y;
            end;

            v88 = math.min(u48.TextScale * v89, 100);
        else
            v88 = u48.TextSize;
        end;

        local v90 = ImageLabel:Clone();

        if u1.ImageShortcuts[u87] then
            v90.Image = typeof(u1.ImageShortcuts[u87]) == "number" and "rbxassetid://" .. u1.ImageShortcuts[u87] or u1.ImageShortcuts[u87];
        else
            v90.Image = "rbxassetid://" .. u87;
        end;

        v90.Size = UDim2.new(0, v88, 0, v88);
        v90.Visible = false;
        formatLabel(v90, v88, v88, function() -- Line: 773
            -- upvalues: u54 (ref), u57 (ref), u87 (copy)
            if not u54 then
                u57(u87);
            end;
        end);
    end;

    local function printSeries(p91) -- Line: 780
        -- upvalues: applyMarkup (ref), printText (ref)
        for _, v in pairs(p91) do
            local v92, v93 = string.match(v, "<(.+)=(.+)>");

            if v92 and v93 then
                if not applyMarkup(v92, v93) then
                    warn("Could not apply markup: ", v);
                end;
            else
                printText(v);
            end;
        end;
    end;

    local v94 = #p41;
    local v95 = {};
    local v96;

    if p44 then
        v96 = p44.OverflowPickupIndex;
    else
        v96 = 1;
    end;

    local v97;

    while true do
        if not v96 or v96 > v94 then
            v97 = v96;
            break;
        end;

        local v98;
        v97, v98 = string.find(p41, "<.->", v96);
        local v99, v100 = string.find(p41, "[ \t\n]", v96);
        local v101;

        if v97 and (v98 and (not v99 or v97 < v99)) then
            v101 = nil;
        else
            v97 = v99 or v94 + 1;
            v98 = v100 or v94 + 1;
            v101 = true;
        end;

        local v102;

        if v96 < v97 then
            v102 = string.sub(p41, v96, v97 - 1) or nil;
        else
            v102 = nil;
        end;

        local v103;

        if v97 <= v94 then
            v103 = string.sub(p41, v97, v98) or nil;
        else
            v103 = nil;
        end;

        table.insert(v95, v102);

        if v101 then
            printSeries(v95);

            if u54 then
                v97 = v96;
                break;
            end;

            printSeries({ v103 });

            if u54 then
                break;
            end;

            v95 = {};
        else
            table.insert(v95, v103);
        end;

        v96 = v98 + 1;
    end;

    if not u54 then
        printSeries(v95);
    end;

    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.HorizontalAlignment = u48.ContainerHorizontalAlignment;
    UIListLayout.VerticalAlignment = u48.ContainerVerticalAlignment;
    UIListLayout.Parent = u40;
    local X = u40.AbsoluteSize.X;
    local v104 = 0;
    local v105 = 0;

    for _, v in pairs(u50) do
        v104 = v104 + v.Size.Y.Offset;
        local Container = v.Container;
        local v106 = nil;
        local v107 = nil;

        if Container.AnchorPoint.X == 0 then
            v106 = Container.Position.X.Offset;
            v107 = Container.Size.X.Offset;
        elseif Container.AnchorPoint.X == 0.5 then
            v106 = v.AbsoluteSize.X / 2 - Container.Size.X.Offset / 2;
            v107 = v.AbsoluteSize.X / 2 + Container.Size.X.Offset / 2;
        elseif Container.AnchorPoint.X == 1 then
            v106 = v.AbsoluteSize.X - Container.Size.X.Offset;
            v107 = v.AbsoluteSize.X;
        end;

        X = math.min(X, v106);
        v105 = math.max(v105, v107);
    end;

    u28 = u28 + 1;
    local u108 = false;
    local u109 = false;
    local u110 = false;
    local u111 = "TextAnimation" .. u28;
    local u112 = {};

    local function updateAnimations() -- Line: 876
        -- upvalues: u109 (ref), u112 (ref), u108 (ref), RunService (ref), u111 (copy), u27 (ref)
        if (not u109 or #u112 ~= 0) and not u108 then
            local v113 = tick();

            for i = #u112, 1, -1 do
                local v114 = u112[i];
                local Settings = v114.Settings;
                local v115 = u27[Settings.AnimateStyle];

                if not v115 then
                    warn("No animation style found for: ", Settings.AnimateStyle, ", defaulting to Appear");
                    v115 = u27.Appear;
                end;

                local v116 = math.min((v113 - v114.Start) / Settings.AnimateStyleTime, 1);
                v115(v114.Char, v116, Settings);
                local v117 = v114.Char:FindFirstChildWhichIsA("UIStroke");

                if v117 then
                    v117.Transparency = v114.Char.TextTransparency;
                end;

                if v116 >= 1 then
                    table.remove(u112, i);
                end;
            end;

            return;
        end;

        u108 = true;
        RunService:UnbindFromRenderStep(u111);
        u112 = {};
    end;

    local function setFrameToDefault(p118) -- Line: 906
        -- upvalues: u52 (copy), u56 (ref)
        p118.Position = u52[p118].InitialPosition;
        p118.Size = u52[p118].InitialSize;
        p118.AnchorPoint = u52[p118].InitialAnchorPoint;

        for i, v in pairs(u52[p118]) do
            u56(i, v, p118);
        end;
    end;

    local function setGroupVisible(p119, p120) -- Line: 915
        -- upvalues: setFrameToDefault (copy)
        p119.Visible = p120;

        for _, child in pairs(p119:GetChildren()) do
            if child:IsA("UIStroke") then
                child.Enabled = p120;
            else
                child.Visible = p120;

                if p120 then
                    setFrameToDefault(child);
                end;
            end;
        end;

        if p120 and p119:IsA("ImageLabel") then
            setFrameToDefault(p119);
        end;
    end;

    local function animate(p121) -- Line: 933
        -- upvalues: u108 (ref), RunService (ref), u111 (copy), updateAnimations (copy), u51 (copy), u112 (ref), u110 (ref), u52 (copy), Normal (ref), Audio (ref), u46 (copy), u5 (ref), ReplicatedFirst (ref), u45 (copy), u109 (ref)
        u108 = false;
        RunService:BindToRenderStep(u111, Enum.RenderPriority.Last.Value, updateAnimations);
        local u122 = nil;
        local u123 = nil;
        local u124 = nil;
        local v125 = nil;

        for _, v in pairs(u51) do
            for _, v2 in pairs(v) do
                v2.Visible = false;

                for _, child in pairs(v2:GetChildren()) do
                    if child:IsA("UIStroke") then
                        child.Enabled = false;
                    else
                        child.Visible = false;
                    end;
                end;
            end;
        end;

        local function animateCharacter(p126, p127) -- Line: 949
            -- upvalues: u112 (ref)
            local v128 = p126:FindFirstChildWhichIsA("UIStroke");

            if v128 then
                v128.Transparency = 1;
            end;

            local v129 = {
                Char = p126,
                Settings = p127,
                Start = tick()
            };
            table.insert(u112, v129);
        end;

        local function yield() -- Line: 957
            -- upvalues: u110 (ref), u122 (ref), u123 (ref), u124 (ref)
            if not u110 and (u122 % u123 == 0 and u124 >= 0) then
                wait(u124 > 0 and u124 or nil);
            end;
        end;

        for _, v in pairs(u51) do
            for _, v2 in pairs(v) do
                local v130 = u52[v2];
                u122 = (v130.AnimateStepGrouping ~= v125 or v130.AnimateStepFrequency ~= u123) and 0 or u122;
                v125 = v130.AnimateStepGrouping;
                u124 = v130.AnimateStepTime;
                u123 = v130.AnimateStepFrequency;

                if v130.AnimateYield > 0 then
                    wait(v130.AnimateYield);
                end;

                if v125 == "Word" or v125 == "All" then
                    if v2:IsA("TextLabel") then
                        v2.Visible = true;

                        for _, child in pairs(v2:GetChildren()) do
                            local v131 = u52[child];
                            local v132 = child:FindFirstChildWhichIsA("UIStroke");

                            if v132 then
                                v132.Transparency = 1;
                            end;

                            local v133 = {
                                Char = child,
                                Settings = v131,
                                Start = tick()
                            };
                            table.insert(u112, v133);
                        end;
                    else
                        local v134 = v2:FindFirstChildWhichIsA("UIStroke");

                        if v134 then
                            v134.Transparency = 1;
                        end;

                        local v135 = {
                            Char = v2,
                            Settings = v130,
                            Start = tick()
                        };
                        table.insert(u112, v135);
                    end;

                    if v125 == "Word" then
                        u122 = u122 + 1;

                        if not u110 and (u122 % u123 == 0 and u124 >= 0) then
                            wait(u124 > 0 and u124 or nil);
                        end;
                    end;
                elseif v125 == "Letter" then
                    if v2:IsA("TextLabel") then
                        v2.Visible = true;
                        local _ = v2.Text;
                        local v136 = 1;

                        while true do
                            local v137 = v2:FindFirstChild(string.format("Char%03d", v136));

                            if not v137 then
                                break;
                            end;

                            local v138 = u52[v137];
                            local v139 = v137:FindFirstChildWhichIsA("UIStroke");

                            if v139 then
                                v139.Transparency = 1;
                            end;

                            local v140 = {
                                Char = v137,
                                Settings = v138,
                                Start = tick()
                            };
                            table.insert(u112, v140);
                            u122 = u122 + 1;
                            local Text = v137.Text;

                            if Text ~= " " then
                                local v141 = Normal[string.lower(Text)];

                                if v141 then
                                    Audio.ScheduleAndPlay(v141.Sound:Clone(), nil, v141.Sound.Parent);
                                else
                                    Audio.Play(u46 or u5.TypingSound, ReplicatedFirst);
                                end;
                            end;

                            if u45 and string.match(Text, u5.Punctuations) then
                                task.wait(u45);
                            end;

                            if not u110 and (u122 % u123 == 0 and u124 >= 0) then
                                local v142;

                                if u124 > 0 then
                                    v142 = u124 or nil;
                                else
                                    v142 = nil;
                                end;

                                wait(v142);
                            end;

                            if u108 then
                                return;
                            end;

                            v136 = v136 + 1;
                        end;
                    else
                        local v143 = v2:FindFirstChildWhichIsA("UIStroke");

                        if v143 then
                            v143.Transparency = 1;
                        end;

                        local v144 = {
                            Char = v2,
                            Settings = v130,
                            Start = tick()
                        };
                        table.insert(u112, v144);
                        u122 = u122 + 1;

                        if not u110 and (u122 % u123 == 0 and u124 >= 0) then
                            wait(u124 > 0 and u124 or nil);
                        end;
                    end;
                else
                    warn("Invalid step grouping: ", v125);
                end;

                if u108 then
                    return;
                end;
            end;
        end;

        u109 = true;

        if p121 then
            while #u112 > 0 do
                RunService.RenderStepped:Wait();
            end;
        end;
    end;

    local v145 = {
        Overflown = u54,
        OverflowPickupIndex = v97,
        StartingProperties = p42,
        OverflowPickupProperties = u48,
        Text = p41
    };

    if p44 then
        p44.NextTextObject = v145;
    end;

    v145.ContentSize = Vector2.new(v105 - X, v104);

    function v145.Animate(p146, p147) -- Line: 1072
        -- upvalues: animate (copy)
        if p147 then
            animate(true);
        else
            coroutine.wrap(animate)();
        end;

        if p146.NextTextObject then
            p146.NextTextObject:Animate(p147);
        end;
    end;

    function v145.Show(p148, p149) -- Line: 1083
        -- upvalues: u110 (ref), u108 (ref), u51 (copy), setGroupVisible (copy)
        if p149 then
            u110 = true;
        else
            u108 = true;

            for _, v in pairs(u51) do
                for _, v2 in pairs(v) do
                    setGroupVisible(v2, true);
                end;
            end;
        end;

        if p148.NextTextObject then
            p148.NextTextObject:Show(p149);
        end;
    end;

    function v145.Hide(p150) -- Line: 1099
        -- upvalues: u108 (ref), u51 (copy)
        u108 = true;

        for _, v in pairs(u51) do
            for _, v2 in pairs(v) do
                v2.Visible = false;

                for _, child in pairs(v2:GetChildren()) do
                    if child:IsA("UIStroke") then
                        child.Enabled = false;
                    else
                        child.Visible = false;
                    end;
                end;
            end;
        end;

        if p150.NextTextObject then
            p150.NextTextObject:Hide();
        end;
    end;

    function v145.Destroy(p151) -- Line: 1111
        -- upvalues: RunService (ref), u111 (copy)
        p151:Hide();
        RunService:UnbindFromRenderStep(u111);
        table.clear(p151);
    end;

    return v145;
end;

function u1.ContinueOverflow(p152, p153, p154) -- Line: 1120
    -- upvalues: u1 (copy)
    return u1:New(p153, nil, nil, false, p154);
end;

return u1;