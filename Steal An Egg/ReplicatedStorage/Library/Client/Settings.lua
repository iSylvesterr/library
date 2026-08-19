-- Decompiled with Potassium's decompiler.

local v1 = {};

for _, v in ipairs({ "Inventory", "Settings" }) do
    v1[v] = true;
end;

return {
    CoinGrabDistance = 300,
    MusicVolume = 1,
    SoundsVolume = 0.5,
    SupportsVR = false,
    SupportsPortrait = false,
    ForcedPortrait = false,
    Scale9Slice = true,
    ScaleStrokes = true,
    ScalePadding = false,
    ScaleLists = false,
    ScaleGrids = false,
    ScaleRichText = true,
    ScaleScrollbars = false,
    UIEasingStyle = "Sine",
    StatsNoFreeze = v1
};