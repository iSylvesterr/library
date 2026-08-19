-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local TextGradient = RuntimeLib.import(script, script.Parent, "gradient", "TextGradient").TextGradient;
local restoreStrokeThickness = RuntimeLib.import(script, script.Parent, "StrokeThickness").restoreStrokeThickness;
local SprayBottles = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "SprayBottles").SprayBottles;
local Detectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors").Detectors;
local Shovels = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").Shovels;
local u1 = Color3.fromRGB(255, 85, 85);
local u2 = Color3.fromRGB(255, 205, 65);
local u3 = Color3.fromRGB(85, 230, 120);
local u4 = Color3.fromRGB(85, 205, 255);

local function statGradient(p5) -- Line: 21
    local v6, v7 = p5:ToHSV();

    return ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHSV(v6, v7 * 0.7, 1)), ColorSequenceKeypoint.new(0.55, Color3.fromHSV(v6, math.min(v7 * 1, 1), 0.95)), ColorSequenceKeypoint.new(1, Color3.fromHSV(v6, math.min(v7 * 1.25, 1), 0.72)) });
end;

return {
    GearBenefits = {
        get = function(p8, p9) -- Line: 28, Name: get
            -- upvalues: Shovels (copy), u1 (copy), u4 (copy), Detectors (copy), u2 (copy), u3 (copy), SprayBottles (copy)
            if p8 == "shovel" then
                local v10 = Shovels[p9];

                return {
                    {
                        label = "Power",
                        value = tostring(v10.power),
                        color = u1
                    },
                    {
                        label = "Walk Speed",
                        value = `+{v10.walkSpeedPercent}%`,
                        color = u4
                    }
                };
            end;

            if p8 == "detector" then
                local v11 = Detectors[p9];

                return {
                    {
                        label = "Luck",
                        value = `x{v11.luck}`,
                        color = u2
                    },
                    {
                        label = "Range",
                        value = tostring(v11.range),
                        color = u3
                    }
                };
            end;

            local v12 = SprayBottles[p9];
            local v13 = {};
            local v14 = {
                label = "Power"
            };
            local v15 = math.round(v12.dissolveRate * v12.dissolveRadius * v12.dissolveRadius * 10);
            v14.value = tostring(v15);
            v14.color = u1;
            v13[1], v13[2] = v14, {
    label = "Range",
    value = tostring(v12.rangeRating),
    color = u3
};

            return v13;
        end,

        render = function(u16, u17, p18) -- Line: 65, Name: render
            -- upvalues: TextGradient (copy), statGradient (copy), restoreStrokeThickness (copy)
            for _, child in u16:GetChildren() do
                if child:IsA("TextLabel") and child ~= u17 then
                    child:Destroy();
                end;
            end;

            local function v22(p19, p20) -- Line: 72
                -- upvalues: u17 (copy), TextGradient (ref), statGradient (ref), restoreStrokeThickness (ref), u16 (copy)
                local v21 = u17:Clone();
                v21.Name = p19.label;
                v21.Text = `{p19.label}: {p19.value}`;
                v21.LayoutOrder = p20;
                v21.TextColor3 = Color3.new(1, 1, 1);
                TextGradient.apply(v21, statGradient(p19.color), 90);
                v21.Visible = true;
                restoreStrokeThickness(v21);
                v21.Parent = u16;
            end;

            for i, v in p18 do
                v22(v, i - 1, p18);
            end;
        end
    }
};