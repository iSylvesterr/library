-- Decompiled with Potassium's decompiler.

local v1 = {};
local Styles = script:WaitForChild("Styles");
v1.atlases = {
    "rbxassetid://392953276",
    "rbxassetid://392953280",
    "rbxassetid://392953283",
    "rbxassetid://392953290",
    "rbxassetid://392953287",
    "rbxassetid://392953282",
    "rbxassetid://392953288",
    "rbxassetid://392953301",
    "rbxassetid://392953307",
    "rbxassetid://392953298",
    "rbxassetid://392953303",
    "rbxassetid://392953305",
    "rbxassetid://392953309",
    "rbxassetid://392953313",
    "rbxassetid://392953315",
    "rbxassetid://392953317",
    "rbxassetid://393140459",
    "rbxassetid://393140480",
    "rbxassetid://393140472",
    "rbxassetid://393140476",
    "rbxassetid://393140483",
    "rbxassetid://393140490",
    "rbxassetid://393140486",
    "rbxassetid://393140499",
    "rbxassetid://393140510",
    "rbxassetid://392953353",
    "rbxassetid://393140503",
    "rbxassetid://392953351",
    "rbxassetid://392953357",
    "rbxassetid://392953363",
    "rbxassetid://392953360",
    "rbxassetid://392953362",
    "rbxassetid://393055828",
    "rbxassetid://392953667",
    "rbxassetid://393055824",
    "rbxassetid://392953669",
    "rbxassetid://392953672",
    "rbxassetid://393055845",
    "rbxassetid://393055854",
    "rbxassetid://393055846",
    "rbxassetid://393055853",
    "rbxassetid://393055869",
    "rbxassetid://393055875",
    "rbxassetid://393055866",
    "rbxassetid://393055873",
    "rbxassetid://393055880",
    "rbxassetid://393055878",
    "rbxassetid://393140507",
    "rbxassetid://393140512",
    "rbxassetid://393140514",
    "rbxassetid://393055887"
};
v1.font = {
    information = {
        family = "Roboto",
        useEnums = true,
        styles = { "Black", "Black Italic", "Bold", "Bold Italic", "Italic", "Light", "Light Italic", "Medium", "Medium Italic", "Regular", "Thin", "Thin Italic" },
        sizes = { 96, 60, 48, 42, 36, 32, 28, 24, 18, 14, 12, 11, 10, 9, 8 }
    },
    styles = {}
};

for _, v in v1.font.information.styles do
    v1.font.styles[v] = require(Styles:WaitForChild(v));
end;

return v1;