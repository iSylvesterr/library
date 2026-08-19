-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Directory.Gears.Types.ToolConfigs);
local Gears = require(ReplicatedStorage.Directory.Gears);
local u1 = {};

for _, v in pairs(Gears.Directory) do
    if v.ToolController == "Gun" then
        table.insert(u1, v._id);
    end;
end;

table.freeze(u1);

return {
    GetAvailableGuns = function() -- Line: 28, Name: GetAvailableGuns
        -- upvalues: u1 (copy)
        return table.clone(u1);
    end
};