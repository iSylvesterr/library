-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local rarityStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "constants", "ui", "RarityStyles").rarityStyleFor;
local weightStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "constants", "ui", "WeightStyles").weightStyleFor;
local TextGradient = RuntimeLib.import(script, script.Parent.Parent, "gradient", "TextGradient").TextGradient;
local Conditions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Conditions").Conditions;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local formatKg = v1.formatKg;
local UNKNOWN_ITEM_NAME = v1.UNKNOWN_ITEM_NAME;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "TextEffectTags");
local RAINBOW_SEQUENCE = v2.RAINBOW_SEQUENCE;
local RAINBOW_TAG = v2.RAINBOW_TAG;
local formatWithCommas = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatWithCommas").formatWithCommas;
local u3 = Color3.new(1, 1, 1);
local u4 = {
    poor = Color3.fromRGB(150, 145, 135),
    ok = Color3.fromRGB(120, 205, 255),
    good = Color3.fromRGB(88, 255, 130),
    great = Color3.fromRGB(255, 205, 70),
    perfect = Color3.fromRGB(255, 120, 200),
    mint = Color3.fromRGB(255, 255, 255)
};
local v13 = {
    applyCondition = function(p5, p6, p7) -- Line: 26, Name: applyCondition
        -- upvalues: Conditions (copy), u4 (copy), TextGradient (copy), RAINBOW_SEQUENCE (copy), RAINBOW_TAG (copy), u3 (copy)
        local v8 = p7 == nil and "Condition: " or p7;
        local displayName = Conditions[p6].displayName;

        if p6 == "mint" then
            p5.TextColor3 = u4.mint;

            return TextGradient.applyHighlight(p5, v8, displayName, RAINBOW_SEQUENCE, RAINBOW_TAG);
        end;

        TextGradient.clear(p5);
        local v9 = u4[p6];
        local v10 = math.floor(v9.R * 255 + 0.5);
        local v11 = math.floor(v9.G * 255 + 0.5);
        local v12 = math.floor(v9.B * 255 + 0.5);
        p5.TextColor3 = u3;
        p5.RichText = true;
        p5.Text = `{v8}<font color="rgb({v10},{v11},{v12})">{displayName}</font>`;

        return nil;
    end
};

local function conditionSegment(p14) -- Line: 46
    -- upvalues: Conditions (copy), RAINBOW_SEQUENCE (copy), RAINBOW_TAG (copy), u4 (copy)
    local displayName = Conditions[p14].displayName;

    return p14 == "mint" and {
        text = displayName,
        gradient = RAINBOW_SEQUENCE,
        animationTag = RAINBOW_TAG
    } or {
        text = displayName,
        color = u4[p14]
    };
end;

v13.conditionSegment = conditionSegment;

function v13.applyConditionTransition(p15, p16, p17) -- Line: 58
    -- upvalues: TextGradient (copy), conditionSegment (copy)
    TextGradient.applySegments(p15, {
        conditionSegment(p16),
        {
            text = " -> "
        },
        (conditionSegment(p17))
    });
end;

function v13.applyNewCondition(p18, p19) -- Line: 64
    -- upvalues: TextGradient (copy), conditionSegment (copy)
    TextGradient.applySegments(p18, {
        {
            text = "New Condition: "
        },
        (conditionSegment(p19))
    });
end;

function v13.unknownRaritySegment(p20) -- Line: 70
    -- upvalues: rarityStyleFor (copy), UNKNOWN_ITEM_NAME (copy)
    local v21 = rarityStyleFor(p20);

    return {
        text = `1 in {UNKNOWN_ITEM_NAME}`,
        color = v21.color,
        gradient = v21.gradient,
        rotation = v21.rotation,
        animationTag = v21.animationTag
    };
end;

function v13.applyRarity(p22, p23, p24) -- Line: 81
    -- upvalues: rarityStyleFor (copy), formatWithCommas (copy), u3 (copy), TextGradient (copy)
    local v25 = rarityStyleFor(p24);
    p22.RichText = false;
    p22.Text = `1 in {formatWithCommas(p23)}`;

    if not v25.gradient then
        TextGradient.clear(p22);
        p22.TextColor3 = v25.color;

        return;
    end;

    p22.TextColor3 = u3;
    local rotation = v25.rotation;
    TextGradient.apply(p22, v25.gradient, rotation == nil and 0 or rotation, v25.animationTag);
end;

function v13.applyName(p26, p27, p28) -- Line: 100
    -- upvalues: rarityStyleFor (copy), u3 (copy), TextGradient (copy)
    local v29 = rarityStyleFor(p28);
    p26.RichText = false;
    p26.Text = p27;

    if not v29.gradient then
        TextGradient.clear(p26);
        p26.TextColor3 = v29.color;

        return;
    end;

    p26.TextColor3 = u3;
    local rotation = v29.rotation;
    TextGradient.apply(p26, v29.gradient, rotation == nil and 0 or rotation, v29.animationTag);
end;

function v13.applyStyledValue(p30, p31, p32, p33, p34) -- Line: 119
    -- upvalues: u3 (copy), TextGradient (copy)
    local v35 = p34 == nil and "" or p34;
    p30.TextColor3 = u3;

    if p33.gradient then
        local v36 = TextGradient.applyHighlight(p30, p31, p32, p33.gradient, p33.animationTag, v35);
        local rotation = p33.rotation;
        v36.gradient.Rotation = rotation == nil and 0 or rotation;

        return v36;
    end;

    TextGradient.clear(p30);
    local v37 = math.floor(p33.color.R * 255 + 0.5);
    local v38 = math.floor(p33.color.G * 255 + 0.5);
    local v39 = math.floor(p33.color.B * 255 + 0.5);
    p30.RichText = true;
    p30.Text = `{p31}<font color="rgb({v37},{v38},{v39})">{p32}</font>{v35}`;

    return nil;
end;

function v13.applyItemName(p40, p41, p42, p43) -- Line: 142
    -- upvalues: weightStyleFor (copy), formatKg (copy), rarityStyleFor (copy), TextGradient (copy), u3 (copy)
    local v44 = weightStyleFor(p42);
    local v45 = ` <font color="rgb({math.floor(v44.color.R * 255 + 0.5)},{math.floor(v44.color.G * 255 + 0.5)},{math.floor(v44.color.B * 255 + 0.5)})">[{formatKg(p42)}KG]</font>`;
    local v46 = rarityStyleFor(p43);

    if v46.gradient then
        return TextGradient.applyHighlight(p40, "", p41, v46.gradient, v46.animationTag, v45);
    end;

    local v47 = math.floor(v46.color.R * 255 + 0.5);
    local v48 = math.floor(v46.color.G * 255 + 0.5);
    local v49 = math.floor(v46.color.B * 255 + 0.5);
    TextGradient.clear(p40);
    p40.RichText = true;
    p40.TextColor3 = u3;
    p40.Text = `<font color="rgb({v47},{v48},{v49})">{p41}</font>{v45}`;

    return nil;
end;

return {
    CONDITION_COLORS = u4,
    ItemLabelStyles = v13
};