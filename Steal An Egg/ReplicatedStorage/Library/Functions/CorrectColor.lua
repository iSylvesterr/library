-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local VecToColor = require(script.Parent.VecToColor);
local ColorToVec = require(script.Parent.ColorToVec);
local RobloxSaturation = require(script.Parent.RobloxSaturation);

return function(p1) -- Line: 6
    -- upvalues: Lighting (copy), ColorToVec (copy), VecToColor (copy), RobloxSaturation (copy)
    local Brightness = Lighting.Brightness;
    local v2 = ColorToVec(Lighting.Ambient):Max(ColorToVec(Lighting.OutdoorAmbient));
    local v3 = ColorToVec(Color3.fromRGB(255, 255, 255));
    local v4 = Lighting:FindFirstChildOfClass("ColorCorrectionEffect");
    local v5, v6;

    if v4 and v4.Enabled then
        v5 = v4.Brightness;
        v6 = v4.Saturation;
        v3 = ColorToVec(v4.TintColor);
    else
        v6 = 0;
        v5 = 0;
    end;

    return VecToColor(ColorToVec(RobloxSaturation(VecToColor(ColorToVec(p1) * Brightness * v2 * v3 * (v5 + 1)), v6)));
end;