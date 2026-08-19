-- Decompiled with Potassium's decompiler.

local v1 = {};
local Styles = script:WaitForChild("Styles");
v1.atlases = { "rbxassetid://108305157720265", "rbxassetid://118563636557682", "rbxassetid://116209031097270" };
v1.font = {
    information = {
        family = "Bold64",
        useEnums = true,
        styles = { "Regular" },
        sizes = { 96, 60, 48, 42, 36, 32, 28, 24, 18, 14, 12, 11, 10, 9, 8 }
    },
    styles = {}
};

for _, v in v1.font.information.styles do
    v1.font.styles[v] = require(Styles:WaitForChild(v));
end;

return v1;