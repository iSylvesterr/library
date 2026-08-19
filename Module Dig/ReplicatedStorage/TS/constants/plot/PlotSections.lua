-- Decompiled with Potassium's decompiler.

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService:IsStudio() and false;
local u2 = {
    Polishing = {
        unlockCost = v1 and 1 or 1500000
    }
};

return {
    SECTION_ID_ATTRIBUTE = "SectionId",
    SECTION_UNLOCKED_ATTRIBUTE = "Unlocked",
    PLOT_COMPONENTS_FOLDER = "PlotComponents",
    SECTIONS_FOLDER = "Sections",

    isPlotSectionId = function(p3) -- Line: 24, Name: isPlotSectionId
        -- upvalues: u2 (copy)
        local v4 = type(p3) == "string" and u2[p3] ~= nil;

        return v4;
    end,

    TEST_CHEAP_POLISHING = v1,
    PlotSections = u2,
    PLOT_SECTION_ORDER = { "Polishing" }
};