-- Decompiled with Potassium's decompiler.

local v1 = {};
local Styles = script:WaitForChild("Styles");
v1.atlases = { "rbxassetid://113836536749931", "rbxassetid://106027770515568" };
v1.font = {
    information = {
        family = "Mario256",
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