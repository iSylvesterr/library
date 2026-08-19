-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Highlights = workspace:WaitForChild("__OBJECTS"):WaitForChild("Highlights");
local v1 = {
    ByColor = table.freeze({
        White = Highlights:WaitForChild("White"),
        Black = Highlights:WaitForChild("Black"),
        Rainbow = Highlights:WaitForChild("Rainbow")
    })
};
local v2 = {};
v1.SchemaValidation = v2;
v2.AllHighlightColors = t.union(t.literal("White"), t.literal("Black"), t.literal("Rainbow"));

return v1;