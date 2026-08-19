-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils");
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "luck", "ServerLuckTiers");

local function cyclicSequence(u3) -- Line: 7
    local v4 = table.create(#u3);

    local function _(p5, p6) -- Line: 10
        -- upvalues: u3 (copy)
        return ColorSequenceKeypoint.new(p6 / #u3, p5);
    end;

    for i, v in u3 do
        v4[i] = ColorSequenceKeypoint.new((i - 1) / #u3, v);
    end;

    local v7 = ColorSequenceKeypoint.new(1, u3[1]);
    table.insert(v4, v7);

    return ColorSequence.new(v4);
end;

local function style(p8, p9, p10) -- Line: 22
    -- upvalues: cyclicSequence (copy)
    return {
        tag = p8,
        colors = p9,
        speed = p10,
        sequence = cyclicSequence(p9)
    };
end;

local v11 = ColorSequence.new(v2.SERVER_LUCK_COLOR, v2.SERVER_LUCK_HIGHLIGHT_COLOR);
local v12 = {};
local v13 = { Color3.fromRGB(180, 0, 255), Color3.fromRGB(255, 0, 223) };
v12[2] = {
    tag = "ServerLuck2Text",
    speed = 0.18,
    colors = v13,
    sequence = cyclicSequence(v13)
};
local v14 = { Color3.fromRGB(160, 0, 255), Color3.fromRGB(220, 60, 255), Color3.fromRGB(255, 0, 223) };
v12[4] = {
    tag = "ServerLuck4Text",
    speed = 0.26,
    colors = v14,
    sequence = cyclicSequence(v14)
};
local v15 = {
    Color3.fromRGB(140, 0, 255),
    Color3.fromRGB(200, 80, 255),
    Color3.fromRGB(255, 120, 240),
    Color3.fromRGB(255, 0, 223)
};
v12[8] = {
    tag = "ServerLuck8Text",
    speed = 0.34,
    colors = v15,
    sequence = cyclicSequence(v15)
};
local v16 = {
    Color3.fromRGB(130, 0, 255),
    Color3.fromRGB(210, 90, 255),
    Color3.fromRGB(255, 240, 255),
    Color3.fromRGB(255, 0, 210)
};
v12[16] = {
    tag = "ServerLuck16Text",
    speed = 0.45,
    colors = v16,
    sequence = cyclicSequence(v16)
};
local v17 = {
    Color3.fromRGB(120, 20, 255),
    Color3.fromRGB(255, 80, 230),
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(200, 0, 255)
};
v12[32] = {
    tag = "ServerLuck32Text",
    speed = 0.6,
    colors = v17,
    sequence = cyclicSequence(v17)
};
local v18 = {
    Color3.fromRGB(90, 30, 255),
    Color3.fromRGB(190, 60, 255),
    Color3.fromRGB(255, 90, 235),
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(140, 120, 255)
};
v12[64] = {
    tag = "ServerLuck64Text",
    speed = 0.8,
    colors = v18,
    sequence = cyclicSequence(v18)
};
local v19 = {
    Color3.fromRGB(90, 30, 200),
    Color3.fromRGB(255, 60, 190),
    Color3.fromRGB(120, 200, 255),
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(200, 0, 255)
};
v12[128] = {
    tag = "ServerLuck128Text",
    speed = 1.1,
    colors = v19,
    sequence = cyclicSequence(v19)
};

return {
    SERVER_LUCK_GRADIENT_ROTATION = -90,
    SERVER_LUCK_TITLE_SEQUENCE = v11,
    SERVER_LUCK_STYLES = v12,
    SERVER_LUCK_TEXT_EFFECTS = v1.values(v12)
};