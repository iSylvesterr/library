-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Fonts = script:WaitForChild("Fonts");
local abs = math.abs;
local max = math.max;
local sub = string.sub;
local rep = string.rep;
local byte = string.byte;
local gsub = string.gsub;
local find = string.find;
local match = string.match;
local upper = string.upper;
local gmatch = string.gmatch;
local sort = table.sort;
local insert = table.insert;
local new = UDim2.new;
local new2 = Color3.new;
local new3 = Vector2.new;
local new4 = Instance.new;
local u1 = new4("ImageLabel");
u1.Size = new(0, 0, 0, 0);
u1.BackgroundTransparency = 1;
u1.ScaleType = Enum.ScaleType.Stretch;
local u2 = {
    Right = true,
    Bottom = true
};
local u3 = {
    Left = true,
    Top = true
};
local u4 = {
    AbsoluteSize = true,
    TextWrapped = true,
    TextScaled = true,
    TextXAlignment = true,
    TextYAlignment = true
};
local u5 = {
    TextTransparency = true,
    TextStrokeTransparency = true,
    BackgroundTransparency = true
};
local u6 = {
    AbsolutePosition = true,
    AbsoluteSize = true,
    Position = true,
    Size = true,
    Rotation = true,
    Parent = true
};
local u7 = {
    FontName = true,
    Style = true
};

local function getAlignMultiplier(p8) -- Line: 81
    -- upvalues: u2 (copy), u3 (copy)
    return u2[p8.Name] and 1 or (u3[p8.Name] and 0 or 0.5);
end;

local function getClosestNumber(u9, p10) -- Line: 85
    -- upvalues: sort (copy), abs (copy)
    sort(p10, function(p11, p12) -- Line: 86
        -- upvalues: u9 (copy), abs (ref)
        return abs(u9 - p11) < abs(u9 - p12);
    end);

    return p10[1];
end;

local function wrapper(u13, u14) -- Line: 92
    local v15 = newproxy(true);
    local v16 = getmetatable(v15);

    function v16.__index(p17, p18) -- Line: 96
        -- upvalues: u14 (copy), u13 (copy)
        return u14[p18] or u13[p18];
    end;

    function v16.__newindex(p19, p20, p21) -- Line: 99
        -- upvalues: u14 (copy), u13 (copy)
        if u14[p20] then
            u14[p20] = p21;

            return;
        end;

        u13[p20] = p21;
    end;

    function v16.__call() -- Line: 106
        -- upvalues: u13 (copy)
        return u13;
    end;

    function v16.__tostring(p22) -- Line: 109
        -- upvalues: u13 (copy)
        return tostring(u13);
    end;

    v16.__metatable = "The metatable is locked.";

    return v15;
end;

local function defaultHide(p23) -- Line: 117
    p23.TextTransparency = 2;
    p23.BackgroundTransparency = 2;
    p23.TextStrokeTransparency = 2;
end;

local function newBackground(u24, p25, p26) -- Line: 123
    -- upvalues: Trove (copy), new4 (copy), new (copy), new2 (copy)
    local v27 = p26 or Trove.new();
    local u28 = new4("Frame", u24);
    u28.Name = "_background";
    u28.Size = new(1, 0, 1, 0);
    u28.BackgroundTransparency = u24.BackgroundTransparency;
    u28.BackgroundColor3 = u24.BackgroundColor3;
    u28.BorderSizePixel = u24.BorderSizePixel;
    u28.BorderColor3 = u24.BorderColor3;
    u28.ZIndex = u24.ZIndex;

    if p25 == "TextButton" then
        v27:Connect(u28.MouseEnter, function() -- Line: 136
            -- upvalues: u24 (copy), u28 (copy), new2 (ref)
            if not u24.AutoButtonColor then
                return;
            end;

            local BackgroundColor3 = u24.BackgroundColor3;
            u28.BackgroundColor3 = new2(BackgroundColor3.r - 0.29411764705882354, BackgroundColor3.g - 0.29411764705882354, BackgroundColor3.b - 0.29411764705882354);
        end);
        v27:Connect(u24.MouseLeave, function() -- Line: 144
            -- upvalues: u24 (copy), u28 (copy)
            if not u24.AutoButtonColor then
                return;
            end;

            u28.BackgroundColor3 = u24.BackgroundColor3;
        end);
    end;

    return u28, v27;
end;

local function split(p29, p30) -- Line: 156
    -- upvalues: find (copy), sub (copy), insert (copy)
    local v31 = 0;
    local v32 = {};

    while true do
        local v33 = find(p29, p30, v31, true);

        if not v33 then
            break;
        end;

        insert(v32, (sub(p29, v31, v33 - 1)));
        v31 = v33 + 1;
    end;

    insert(v32, (sub(p29, v31)));

    return v32;
end;

local function getLines(p34) -- Line: 174
    -- upvalues: gsub (copy), rep (copy), split (copy)
    return split(gsub(p34, "\t", rep(" ", 4)), "\n");
end;

local function getWords(p35, p36) -- Line: 179
    -- upvalues: gsub (copy), rep (copy), split (copy), gmatch (copy), insert (copy)
    debug.profilebegin("CustomFont getWords");
    local v37 = split(gsub(p35, "\t", rep(" ", 4)), "\n");
    local v38 = #v37;
    local v39 = {};

    for i = 1, v38 do
        for i2 in gmatch(v37[i], " *[^%s]+ *") do
            insert(v39, i2);
        end;

        if p36 and i < v38 then
            insert(v39, "\n");
        end;
    end;

    debug.profileend();

    return v39;
end;

local function getStringWidth(p40, p41) -- Line: 201
    -- upvalues: sub (copy), byte (copy)
    debug.profilebegin("CustomFont getStringWidth");
    local v42 = 0;

    for i = 1, #p40 do
        local v43;

        if i + 1 <= #p40 then
            v43 = i + 1;
        else
            v43 = false;
        end;

        local v44 = byte((sub(p40, i, i)));

        if v43 then
            v43 = byte((sub(p40, v43, v43)));
        end;

        v42 = v42 + p41.characters[v44].xadvance + (not (v43 and (p41.kerning[v44] and p41.kerning[v44][v43])) and 0 or p41.kerning[v44][v43].x);
    end;

    debug.profileend();

    return v42;
end;

local function getMaxHeight(p45, p46) -- Line: 222
    -- upvalues: sub (copy), byte (copy)
    debug.profilebegin("CustomFont getMaxHeight");
    local v47 = 0;

    for i = 1, #p45 do
        local v48 = byte((sub(p45, i, i)));
        local v49 = p46.characters[v48].height + p46.characters[v48].yoffset;

        if v47 < v49 then
            v47 = v49;
        end;
    end;

    debug.profileend();

    return v47;
end;

local function wrapText(p50, p51, p52) -- Line: 240
    -- upvalues: getWords (copy), abs (copy), getStringWidth (copy)
    debug.profilebegin("CustomFont wrapText");
    local v53 = getWords(p50, true);
    local v54 = abs(p52.child.AbsoluteSize.x);
    local v55 = 0;
    local v56 = 1;
    local v57 = { "" };

    for i = 1, #v53 do
        local v58 = v53[i];

        if v58 == "\n" then
            v56 = v56 + 1;
            v57[v56] = "";
            v55 = 0;
        else
            local v59 = getStringWidth(v58, p52.styles[p52.style][p51]);

            if v59 + v55 <= v54 then
                v57[v56] = v57[v56] .. v58;
            else
                v56 = v56 + 1;
                v57[v56] = v58;
                v55 = 0;
            end;

            v55 = v55 + v59;
        end;
    end;

    debug.profileend();

    return v57;
end;

function scaleText(p60, p61)
    -- upvalues: sort (copy), wrapText (copy), gsub (copy), rep (copy), split (copy), getMaxHeight (copy), getStringWidth (copy), insert (copy), max (copy), abs (copy)
    debug.profilebegin("CustomFont scaleText");
    local child = p61.child;
    sort(p61.information.sizes, function(p62, p63) -- Line: 273
        return p63 < p62;
    end);
    local v64 = p61.information.sizes[1];
    local v65 = false;

    for i = 1, #p61.information.sizes do
        local v66 = p61.information.sizes[i];
        local v67 = p61.styles[p61.style][v66];
        local v68 = child.TextWrapped and wrapText(p60, v66, p61) or split(gsub(p60, "\t", rep(" ", 4)), "\n");
        local v69 = -v67.firstAdjust;
        local v70 = {};

        for i2 = 1, #v68 do
            local v71 = v68[i2];
            v69 = v69 + getMaxHeight(v71, v67);
            insert(v70, (getStringWidth(v71, v67)));
        end;

        if max(unpack(v70)) <= abs(child.AbsoluteSize.x) and v69 <= abs(child.AbsoluteSize.y) then
            v64 = v66;
            v65 = true;
            break;
        end;
    end;

    local v72 = v65 and v64 and v64 or p61.information.sizes[#p61.information.sizes];
    debug.profileend();

    return v72;
end;

local function drawSprite(p73, p74, p75, p76) -- Line: 307
    -- upvalues: u1 (copy), new3 (copy)
    debug.profilebegin("CustomFont drawSprite");
    local v77 = typeof(p76) == "table";
    local v78 = v77 and p76[1] or u1:Clone();

    if v77 then
        table.remove(p76, 1);
    end;

    local child = p75.child;
    local attached = p75.attached;
    local v79 = p75.styles[p75.style][p75.size];
    local v80 = v79.characters[p73];
    v78.Name = p73;
    v78.ImageColor3 = child.TextColor3;
    v78.ImageTransparency = attached.TextTransparency;
    v78.ZIndex = child.ZIndex;
    v78.Image = p75.atlases[v80.atlas + 1];
    v78.ImageRectSize = new3(v80.width, v80.height);
    v78.ImageRectOffset = new3(v80.x, v80.y);
    local v81, v82;

    if p74 and (v79.kerning[p73] and v79.kerning[p73][p74]) then
        local v83 = v79.kerning[p73][p74];
        v81 = v83.x;
        v82 = v83.y;
    else
        v81 = 0;
        v82 = 0;
    end;

    v78.Position = UDim2.new(0, v81, 0, v80.yoffset + v82);
    v78.Size = UDim2.new(0, v80.width, 0, v80.height);
    local v84 = { v78, v81, v82 + v80.yoffset + v80.height };
    debug.profileend();

    return unpack(v84);
end;

local function drawLine(p85, p86, p87, p88, p89) -- Line: 349
    -- upvalues: sub (copy), byte (copy), drawSprite (copy), new (copy), insert (copy), u2 (copy), u3 (copy), abs (copy)
    debug.profilebegin("CustomFont drawLine");
    local child = p88.child;
    local v90 = #p85;
    local v91 = p88.styles[p88.style][p88.size];
    local v92 = 0;
    local v93 = {};
    local v94 = 0;

    for i = 1, v90 do
        local v95;

        if i + 1 <= v90 then
            v95 = i + 1;
        else
            v95 = false;
        end;

        local v96 = byte((sub(p85, i, i)));
        local v97;

        if v95 then
            v97 = byte((sub(p85, v95, v95)));
        else
            v97 = v95;
        end;

        local v98, v99, v100 = drawSprite(v96, v97, p88, p89);

        if v92 < v100 then
            v92 = v100 or v92;
        end;

        v98.Position = v98.Position + new(0, v94, 0, p86);
        v94 = v94 + (v95 and v91.characters[v96].xadvance or v91.characters[v96].width) + v99;
        insert(v93, v98);
        insert(p87, v98);
    end;

    local TextXAlignment = child.TextXAlignment;
    local v101 = u2[TextXAlignment.Name] and 1 or (u3[TextXAlignment.Name] and 0 or 0.5);
    local v102 = (abs(child.AbsoluteSize.x) - v94) * v101;

    for i = 1, v90 do
        local v103 = v93[i];
        v103.Position = v103.Position + new(0, v102, 0, 0);
    end;

    debug.profileend();

    return unpack({ v94, v92 });
end;

local function drawLines(p104, p105, p106, p107) -- Line: 386
    -- upvalues: wrapText (copy), gsub (copy), rep (copy), split (copy), drawLine (copy), insert (copy), u2 (copy), u3 (copy), abs (copy), new (copy)
    debug.profilebegin("CustomFont drawLines");
    local child = p105.child;

    if child.TextScaled then
        p105.size = scaleText(p104, p105);
    end;

    local v108 = child.TextWrapped and wrapText(p104, p105.size, p105) or split(gsub(p104, "\t", rep(" ", 4)), "\n");
    local v109 = -p105.styles[p105.style][p105.size].firstAdjust;
    local v110 = {};
    local v111 = { 0 };

    for i = 1, #v108 do
        local v112, v113 = drawLine(v108[i], v109, v110, p105, p107);
        v109 = v109 + v113;
        insert(v111, v112);
    end;

    local TextYAlignment = child.TextYAlignment;
    local v114 = u2[TextYAlignment.Name] and 1 or (u3[TextYAlignment.Name] and 0 or 0.5);
    local v115 = (abs(child.AbsoluteSize.y) - v109) * v114;

    for i = 1, #v110 do
        local v116 = v110[i];
        v116.Position = v116.Position + new(0, 0, 0, v115);
        v116.Parent = p106;
    end;

    debug.profileend();

    return v110;
end;

local u126 = {
    new = function(u117) -- Line: 426, Name: new
        local u118 = {};
        local v122 = setmetatable({}, {
            __metatable = "The metatable is locked.",
            __index = u117,

            __newindex = function(p119, p120, p121) -- Line: 430, Name: __newindex
                -- upvalues: u117 (copy), u118 (copy)
                if u117[p120] ~= p121 then
                    u117[p120] = p121;

                    if type(u118[p120]) == "function" then
                        u118[p120](p121);
                    end;
                end;
            end
        });

        function v122.connect(p123, p124, p125) -- Line: 441
            -- upvalues: u118 (copy)
            u118[p124] = p125;
        end;

        return v122;
    end
};
local u127 = {};

function u127.new(p128, u129, u130) -- Line: 450
    -- upvalues: u127 (copy), sort (copy), abs (copy)
    debug.profilebegin("CustomFont Settings.new");
    local u131 = setmetatable({}, {
        __index = u127
    });
    u131.child = u130;
    u131.attached = u129;
    u131.information = p128.font.information;
    u131.atlases = p128.atlases;
    u131.font_kernel = p128;
    u131.styles = p128.font.styles;
    sort(u131.information.sizes, function(p132, p133) -- Line: 464
        return p133 < p132;
    end);
    u131.style = u131.information.styles[1];
    u131.size = u130.TextSize;

    for _, v in next, u131.styles do
        for _, v2 in next, v do
            setmetatable(v2.characters, {
                __index = function(p134, p135) -- Line: 477, Name: __index
                    local v136 = tostring(p135);
                    local v137 = rawget(p134, v136);

                    if v137 then
                        return v137;
                    end;

                    local v138 = tostring(63);

                    return rawget(p134, v138);
                end
            });
        end;

        setmetatable(v, {
            __index = function(p139, p140) -- Line: 492, Name: __index
                -- upvalues: u131 (copy), sort (ref), abs (ref), u130 (copy)
                local u141 = tostring(p140);
                local v142 = rawget(p139, u141);

                if v142 then
                    return v142;
                end;

                local sizes = u131.information.sizes;
                sort(sizes, function(p143, p144) -- Line: 86
                    -- upvalues: u141 (copy), abs (ref)
                    return abs(u141 - p143) < abs(u141 - p144);
                end);
                local v145 = sizes[1];
                u131.size = v145;
                u130.TextSize = v145;
                local v146 = tostring(v145);

                return rawget(p139, v146);
            end
        });
    end;

    setmetatable(u131.styles, {
        __index = function(p147, p148) -- Line: 509, Name: __index
            -- upvalues: u131 (copy), u129 (copy)
            local v149 = rawget(p147, p148);

            if v149 then
                return v149;
            end;

            local v150 = u131.information.styles[1];
            u131.style = v150;
            u129.Style = v150;

            return rawget(p147, v150);
        end
    });
    debug.profileend();

    return u131;
end;

function u127.preload(p151) -- Line: 526
    -- upvalues: ContentProvider (copy)
    if p151.font_kernel.__atlases_loaded then
        return;
    end;

    p151.font_kernel.__atlases_loaded = true;
    pcall(ContentProvider.PreloadAsync, ContentProvider, p151.atlases);
end;

local u193 = {
    new = function(p152, u153, p154) -- Line: 537, Name: new
        -- upvalues: u126 (copy), new4 (copy), Fonts (copy), u127 (copy), Trove (copy), u7 (copy), upper (copy), sub (copy), newBackground (copy), drawLines (copy), u5 (copy), u4 (copy), match (copy), u6 (copy), insert (copy), wrapper (copy)
        debug.profilebegin("CustomFont.new");
        local u155 = u126.new({});

        if type(u153) == "string" or not u153 then
            u153 = new4(u153);
        end;

        local v156 = Fonts:FindFirstChild(p152);
        local v157 = `font module not found for font name: {p152}`;
        local v158 = assert(v156, v157);
        local u159 = u127.new(require(v158), u155, u153);
        u159:preload();
        local u160 = Trove.new();
        local u161 = u160:Extend();
        u155.FontName = p152;
        u155.Style = u159.style;
        u155.TextTransparency = u153.TextTransparency;
        u155.TextStrokeTransparency = u153.TextStrokeTransparency;
        u155.BackgroundTransparency = u153.BackgroundTransparency;
        u155.MaxVisibleGraphemes = u153.MaxVisibleGraphemes;
        u155.TextFits = false;
        local u162 = {};
        local u163 = {};
        local u164 = {};

        for i in next, u7 do
            local v165 = u155[i];
            local v166 = type(v165);
            local v167 = upper((sub(v166, 1, 1))) .. sub(v166, 2) .. "Value";
            local v168 = Instance.new(v167, u153);
            v168.Name = i;
            v168.Value = v165;
            u161:Connect(v168.Changed, function(p169) -- Line: 573
                -- upvalues: u155 (copy), i (copy)
                u155[i] = p169;
            end);
            u162[v168.Name] = v168;
            u163[v168] = true;
        end;

        local u170 = newBackground(u153, p154 and "TextButton", u161);
        u153.MaxVisibleGraphemes = 0;
        u153.TextTransparency = 2;
        u153.BackgroundTransparency = 2;
        u153.TextStrokeTransparency = 2;

        local function cleanWithCache(p171) -- Line: 587
            -- upvalues: u170 (copy)
            local v172 = typeof(p171);
            local v173 = v172 == "number" and p171 and p171 or (v172 == "string" and #p171 or 0);
            local v174 = {};

            for _, child in u170:GetChildren() do
                if child:IsA("ImageLabel") then
                    if #v174 == v173 then
                        child:Destroy();
                    else
                        table.insert(v174, child);
                    end;
                end;
            end;

            return v174;
        end;

        local function drawText() -- Line: 608
            -- upvalues: u164 (ref), drawLines (ref), u153 (copy), u159 (ref), u170 (copy), cleanWithCache (copy)
            debug.profilebegin("CustomFont drawText");
            u164 = drawLines(u153.Text, u159, u170, (cleanWithCache(u153.Text)));
            debug.profileend();
        end;

        u155:connect("TextStrokeTransparency", function(p175) -- Line: 617
            -- upvalues: u164 (ref), drawLines (ref), u153 (copy), u159 (ref), u170 (copy), cleanWithCache (copy)
            debug.profilebegin("CustomFont drawText");
            u164 = drawLines(u153.Text, u159, u170, (cleanWithCache(u153.Text)));
            debug.profileend();
        end);
        u155:connect("BackgroundTransparency", function(p176) -- Line: 621
            -- upvalues: u170 (copy)
            u170.BackgroundTransparency = p176;
        end);
        u155:connect("Style", function(p177) -- Line: 625
            -- upvalues: u159 (ref), u162 (ref), u164 (ref), drawLines (ref), u153 (copy), u170 (copy), cleanWithCache (copy)
            u159.style = p177;
            u162.Style.Value = p177;
            debug.profilebegin("CustomFont drawText");
            u164 = drawLines(u153.Text, u159, u170, (cleanWithCache(u153.Text)));
            debug.profileend();
        end);
        u155:connect("TextTransparency", function(p178) -- Line: 631
            -- upvalues: u164 (ref)
            for i = 1, #u164 do
                u164[i].ImageTransparency = p178;
            end;
        end);
        u155:connect("FontName", function(p179) -- Line: 637
            -- upvalues: Fonts (ref), u159 (ref), u127 (ref), u155 (copy), u153 (copy), u162 (ref), u164 (ref), drawLines (ref), u170 (copy), cleanWithCache (copy)
            local v180 = Fonts:FindFirstChild(p179);

            if not v180 then
                return;
            end;

            u159 = u127.new(require(v180), u155, u153);
            u159:preload();
            u162.FontName.Value = p179;

            if not u153.TextScaled then
                u159.size = u153.TextSize;
            end;

            u159.style = u155.Style;
            debug.profilebegin("CustomFont drawText");
            u164 = drawLines(u153.Text, u159, u170, (cleanWithCache(u153.Text)));
            debug.profileend();
        end);
        u161:Connect(u153.Changed, function(u181) -- Line: 656
            -- upvalues: u5 (ref), u153 (copy), u155 (copy), u159 (ref), u164 (ref), drawLines (ref), u170 (copy), cleanWithCache (copy), u4 (ref), match (ref), u6 (ref)
            if u5[u181] then
                if u153[u181] ~= 2 then
                    u155[u181] = u153[u181];
                end;

                u153[u181] = 2;

                return;
            end;

            if u181 == "TextSize" then
                u159.size = u153[u181];
                debug.profilebegin("CustomFont drawText");
                u164 = drawLines(u153.Text, u159, u170, (cleanWithCache(u153.Text)));
                debug.profileend();

                return;
            end;

            if u181 == "TextColor3" then
                for _, v in next, u164 do
                    v.ImageColor3 = u153[u181];
                end;

                return;
            end;

            if u181 == "ZIndex" then
                u170.ZIndex = u153[u181];

                for _, v in next, u164 do
                    v.ZIndex = u153[u181];
                end;

                return;
            end;

            if u181 == "Text" then
                debug.profilebegin("CustomFont drawText");
                u164 = drawLines(u153.Text, u159, u170, (cleanWithCache(u153.Text)));
                debug.profileend();

                return;
            end;

            if not u4[u181] then
                if not (match(u181, "Text") or u6[u181]) then
                    pcall(function() -- Line: 682
                        -- upvalues: u170 (ref), u181 (copy), u153 (ref)
                        u170[u181] = u153[u181];
                    end);
                end;

                return;
            end;

            if u181 == "TextScaled" and not u153[u181] then
                u159.size = u153.TextSize;
            end;

            debug.profilebegin("CustomFont drawText");
            u164 = drawLines(u153.Text, u159, u170, (cleanWithCache(u153.Text)));
            debug.profileend();
        end);

        if u153:IsA("TextBox") then
            u161:Connect(u153.Focused, function() -- Line: 689
                -- upvalues: u153 (copy)
                if not u153.ClearTextOnFocus then
                    return;
                end;

                u153.Text = "";
            end);
        end;

        function u155.Revert(p182) -- Line: 698
            -- upvalues: u162 (ref), u161 (ref), u170 (copy), u153 (copy), u164 (ref), u163 (ref)
            for _, v in next, u162 do
                v:Destroy();
            end;

            u161:Clean();
            u170:Destroy();
            u153.TextTransparency = p182.TextTransparency;
            u153.BackgroundTransparency = p182.BackgroundTransparency;
            u153.MaxVisibleGraphemes = p182.MaxVisibleGraphemes;
            table.clear(u164);
            table.clear(u163);
            table.clear(u162);
            u163 = nil;
            u162 = nil;
            u161 = nil;

            return u153;
        end;

        function u155.GetChildren(p183) -- Line: 717
            -- upvalues: u153 (copy), u170 (copy), u163 (ref), insert (ref)
            local v184 = next;
            local v185, v186 = u153:GetChildren();
            local v187 = {};

            for _, v in v184, v185, v186 do
                if v ~= u170 and not u163[v] then
                    insert(v187, v);
                end;
            end;

            return v187;
        end;

        function u155.ClearAllChildren(p188) -- Line: 727
            -- upvalues: u153 (copy), u170 (copy), u163 (ref)
            local v189 = next;
            local v190, v191 = u153:GetChildren();

            for _, v in v189, v190, v191 do
                if v ~= u170 and not u163[v] then
                    v:Destroy();
                end;
            end;
        end;

        function u155.Destroy(p192) -- Line: 735
            -- upvalues: u160 (copy)
            p192:Revert();
            u160:Destroy();
        end;

        debug.profilebegin("CustomFont drawText");
        u164 = drawLines(u153.Text, u159, u170, (cleanWithCache(u153.Text)));
        debug.profileend();
        debug.profileend();

        return wrapper(u153, u155);
    end
};

function u193.Replace(p194, p195) -- Line: 746
    -- upvalues: Asserts (copy), u193 (copy)
    local v196 = p195 or "StrokeMario64";
    Asserts.string(v196);
    Asserts.GuiObject(p194);
    local v197 = p194:IsA("TextBox") or (p194:IsA("TextLabel") or p194:IsA("TextButton"));
    local v198 = `CustomFont.Replace expected a TextBox, TextLabel, or TextButton, got {p194.ClassName}`;
    assert(v197, v198);

    return u193.new(v196, p194, p194:IsA("TextButton"));
end;

task.wait();

return u193;