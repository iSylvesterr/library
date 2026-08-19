-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local RunService = v1.RunService;
local SERVER_LUCK_TEXT_EFFECTS = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "ServerLuckStyles").SERVER_LUCK_TEXT_EFFECTS;
local isUiVisible = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "UiVisibility").isUiVisible;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "TextEffectTags");
local COSMIC_COLORS = v2.COSMIC_COLORS;
local COSMIC_TEXT_TAG = v2.COSMIC_TEXT_TAG;
local DISCO_TEXT_TAG = v2.DISCO_TEXT_TAG;
local DIVINE_PLATFORM_TAG = v2.DIVINE_PLATFORM_TAG;
local DIVINE_TEXT_TAG = v2.DIVINE_TEXT_TAG;
local EMBER_COLORS = v2.EMBER_COLORS;
local EMBER_TEXT_TAG = v2.EMBER_TEXT_TAG;
local ETERNAL_COLORS = v2.ETERNAL_COLORS;
local ETERNAL_TEXT_TAG = v2.ETERNAL_TEXT_TAG;
local PRISMATIC_TEXT_TAG = v2.PRISMATIC_TEXT_TAG;
local RADIANT_COLORS = v2.RADIANT_COLORS;
local RADIANT_TEXT_TAG = v2.RADIANT_TEXT_TAG;
local RAINBOW_PLATFORM_TAG = v2.RAINBOW_PLATFORM_TAG;
local RAINBOW_TAG = v2.RAINBOW_TAG;
local SECRET_PLATFORM_TAG = v2.SECRET_PLATFORM_TAG;
local SECRET_TEXT_TAG = v2.SECRET_TEXT_TAG;
local SHINY_GOLD_COLORS = v2.SHINY_GOLD_COLORS;
local SHINY_GOLD_TEXT_TAG = v2.SHINY_GOLD_TEXT_TAG;
local TRANSCENDENT_COLORS = v2.TRANSCENDENT_COLORS;
local TRANSCENDENT_TEXT_TAG = v2.TRANSCENDENT_TEXT_TAG;
local v3 = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 165, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 100, 255),
    Color3.fromRGB(130, 0, 255)
};
local v4 = { Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0) };
local v5 = { Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 200, 60) };
local u6 = {
    {
        speed = 0.3,
        tag = RAINBOW_TAG,
        colors = v3
    },
    {
        speed = 0.3,
        tag = SECRET_TEXT_TAG,
        colors = v4
    },
    {
        speed = 0.3,
        tag = DIVINE_TEXT_TAG,
        colors = v5
    },
    {
        speed = 0.3,
        tag = DISCO_TEXT_TAG,
        colors = {
            Color3.fromRGB(0, 130, 255),
            Color3.fromRGB(255, 100, 200),
            Color3.fromRGB(255, 230, 50),
            Color3.fromRGB(0, 210, 200)
        }
    },
    {
        speed = 0.3,
        tag = PRISMATIC_TEXT_TAG,
        colors = { Color3.fromRGB(150, 50, 255), Color3.fromRGB(255, 100, 200), Color3.fromRGB(100, 200, 255) }
    },
    {
        speed = 0.45,
        tag = RADIANT_TEXT_TAG,
        colors = RADIANT_COLORS
    },
    {
        speed = 0.5,
        tag = SHINY_GOLD_TEXT_TAG,
        colors = SHINY_GOLD_COLORS
    },
    {
        speed = 0.38,
        tag = EMBER_TEXT_TAG,
        colors = EMBER_COLORS
    },
    {
        speed = 0.22,
        tag = COSMIC_TEXT_TAG,
        colors = COSMIC_COLORS
    },
    {
        speed = 0.24,
        tag = ETERNAL_TEXT_TAG,
        colors = ETERNAL_COLORS
    },
    {
        speed = 0.26,
        tag = TRANSCENDENT_TEXT_TAG,
        colors = TRANSCENDENT_COLORS
    }
};
table.move(SERVER_LUCK_TEXT_EFFECTS, 1, #SERVER_LUCK_TEXT_EFFECTS, #u6 + 1, u6);
local u7 = {
    {
        speed = 0.3,
        tag = RAINBOW_PLATFORM_TAG,
        colors = v3
    },
    {
        speed = 0.3,
        tag = SECRET_PLATFORM_TAG,
        colors = v4
    },
    {
        speed = 0.3,
        tag = DIVINE_PLATFORM_TAG,
        colors = v5
    }
};

local function lerpColor(p8, p9, p10) -- Line: 98
    return Color3.new(p8.R + (p9.R - p8.R) * p10, p8.G + (p9.G - p8.G) * p10, p8.B + (p9.B - p8.B) * p10);
end;

local function colorAt(p11, p12) -- Line: 101
    -- upvalues: lerpColor (copy)
    local v13 = #p11;
    local v14 = p12 % 1 * v13;
    local v15 = math.floor(v14) % v13;

    return lerpColor(p11[v15 + 1], p11[(v15 + 1) % v13 + 1], v14 - math.floor(v14));
end;

local function buildSlidingSequence(p16, p17) -- Line: 108
    local v18 = #p16;
    local v19 = p17 % 1;
    local v20 = #p16;
    local v21 = (1 - v19) % 1 * v20;
    local v22 = math.floor(v21) % v20;
    local v23 = p16[v22 + 1];
    local v24 = p16[(v22 + 1) % v20 + 1];
    local v25 = v21 - math.floor(v21);
    local v26 = Color3.new(v23.R + (v24.R - v23.R) * v25, v23.G + (v24.G - v23.G) * v25, v23.B + (v24.B - v23.B) * v25);
    local v27 = { ColorSequenceKeypoint.new(0, v26), ColorSequenceKeypoint.new(1, v26) };
    local v28 = false;
    local v29 = 0;

    while true do
        if v28 then
            v29 = v29 + 1;
        else
            v28 = true;
        end;

        if v29 >= v18 then
            table.sort(v27, function(p30, p31) -- Line: 132
                return p30.Time < p31.Time;
            end);

            return ColorSequence.new(v27);
        end;

        local v32 = (v29 / v18 + v19) % 1;

        if v32 > 0.001 and v32 < 0.999 then
            local v33 = ColorSequenceKeypoint.new(v32, p16[v29 + 1]);
            table.insert(v27, v33);
        end;
    end;
end;

local u34 = setmetatable({}, {
    __tostring = function() -- Line: 147, Name: __tostring
        return "RainbowTextController";
    end
});
u34.__index = u34;

function u34.new(...) -- Line: 152
    -- upvalues: u34 (ref)
    local v35 = setmetatable({}, u34);

    return v35:constructor(...) or v35;
end;

function u34.constructor(p36) -- Line: 156
    p36.gradientTracks = {};
    p36.partTracks = {};
    p36.hidden = {};
    p36.visibilityElapsed = 0;
    p36.frameElapsed = 0;
end;

function u34.onStart(u37) -- Line: 163
    -- upvalues: u6 (copy), CollectionService (copy), u7 (copy), RunService (copy)
    for _, v in u6 do
        local u38 = {};
        table.insert(u37.gradientTracks, {
            effect = v,
            gradients = u38
        });

        for _, v6 in CollectionService:GetTagged(v.tag) do
            u37:onTagged(v6, u38);
        end;

        CollectionService:GetInstanceAddedSignal(v.tag):Connect(function(p39) -- Line: 175
            -- upvalues: u37 (copy), u38 (copy)
            return u37:onTagged(p39, u38);
        end);
        CollectionService:GetInstanceRemovedSignal(v.tag):Connect(function(p40) -- Line: 178
            -- upvalues: u37 (copy), u38 (copy)
            return u37:onUntagged(p40, u38);
        end);
    end;

    for _, v in u7 do
        local u41 = {};
        table.insert(u37.partTracks, {
            effect = v,
            parts = u41
        });

        for _, v6 in CollectionService:GetTagged(v.tag) do
            if v6:IsA("BasePart") then
                u41[v6] = true;
            end;
        end;

        CollectionService:GetInstanceAddedSignal(v.tag):Connect(function(p42) -- Line: 195
            -- upvalues: u41 (copy)
            if p42:IsA("BasePart") then
                u41[p42] = true;
            end;
        end);
        CollectionService:GetInstanceRemovedSignal(v.tag):Connect(function(p43) -- Line: 201
            -- upvalues: u41 (copy)
            if p43:IsA("BasePart") then
                u41[p43] = nil;
            end;
        end);
    end;

    RunService.Heartbeat:Connect(function(p44) -- Line: 208
        -- upvalues: u37 (copy)
        return u37:animate(p44);
    end);
end;

function u34.onTagged(p45, p46, p47) -- Line: 212
    local v48 = p46:FindFirstChildWhichIsA("UIGradient");

    if v48 then
        p47[v48] = true;
    end;
end;

function u34.onUntagged(p49, p50, p51) -- Line: 218
    local v52 = p50:FindFirstChildWhichIsA("UIGradient");

    if v52 then
        p51[v52] = nil;
    end;
end;

function u34.animatePartSet(p53, p54, p55) -- Line: 224
    local v56 = {};

    for i in p54 do
        if i.Parent then
            i.Color = p55;
        else
            table.insert(v56, i);
        end;
    end;

    for _, v in v56 do
        p54[v] = nil;
    end;
end;

function u34.animateSet(p57, p58, p59) -- Line: 237
    local v60 = {};

    for i in p58 do
        if i.Parent then
            if p57.hidden[i] == nil then
                i.Color = p59;
            end;
        else
            table.insert(v60, i);
        end;
    end;

    for _, v in v60 do
        p58[v] = nil;
    end;
end;

function u34.refreshVisibility(p61) -- Line: 253
    -- upvalues: isUiVisible (copy)
    table.clear(p61.hidden);

    for _, v in p61.gradientTracks do
        for i in v.gradients do
            if i.Parent ~= nil and not isUiVisible(i) then
                p61.hidden[i] = true;
            end;
        end;
    end;
end;

function u34.animate(p62, p63) -- Line: 263
    -- upvalues: buildSlidingSequence (copy), colorAt (copy)
    p62.visibilityElapsed = p62.visibilityElapsed + p63;
    p62.frameElapsed = p62.frameElapsed + p63;

    if p62.frameElapsed < 0.03333333333333333 then
        return nil;
    end;

    p62.frameElapsed = 0;

    if p62.visibilityElapsed >= 0.25 then
        p62.visibilityElapsed = 0;
        p62:refreshVisibility();
    end;

    local v64 = os.clock();

    for _, v in p62.gradientTracks do
        local v65 = 0;

        for _ in v.gradients do
            v65 = v65 + 1;
        end;

        if v65 ~= 0 then
            p62:animateSet(v.gradients, buildSlidingSequence(v.effect.colors, v64 * v.effect.speed));
        end;
    end;

    for _, v in p62.partTracks do
        local v66 = 0;

        for _ in v.parts do
            v66 = v66 + 1;
        end;

        if v66 ~= 0 then
            p62:animatePartSet(v.parts, colorAt(v.effect.colors, v64 * v.effect.speed));
        end;
    end;
end;

Reflect.defineMetadata(u34, "identifier", "client/controllers/ui/RainbowTextController@RainbowTextController");
Reflect.defineMetadata(u34, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u34, "$:flamework@Controller", Controller, { {} });

return {
    RainbowTextController = u34
};