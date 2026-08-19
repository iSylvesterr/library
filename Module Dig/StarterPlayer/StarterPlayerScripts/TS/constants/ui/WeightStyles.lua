-- Decompiled with Potassium's decompiler.

local v1 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 214, 92)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 245, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 165, 40)) });
local v2 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 230, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 250, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 190, 255)) });
local v3 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 95, 205)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 250)), ColorSequenceKeypoint.new(1, Color3.fromRGB(185, 70, 255)) });
local u4 = {
    {
        minKg = 0,
        color = Color3.fromRGB(222, 166, 118)
    },
    {
        minKg = 10,
        color = Color3.fromRGB(205, 210, 220)
    },
    {
        minKg = 35,
        color = Color3.fromRGB(255, 200, 70),
        gradient = v1
    },
    {
        minKg = 100,
        color = Color3.fromRGB(170, 230, 255),
        gradient = v2
    },
    {
        minKg = 300,
        color = Color3.fromRGB(255, 130, 235),
        gradient = v3
    }
};

return {
    weightStyleFor = function(p5) -- Line: 24, Name: weightStyleFor
        -- upvalues: u4 (copy)
        local v6 = u4[1];

        for _, v in u4 do
            if v.minKg > p5 then
                break;
            end;

            v6 = v;
        end;

        return v6;
    end,

    WEIGHT_STYLES = u4
};