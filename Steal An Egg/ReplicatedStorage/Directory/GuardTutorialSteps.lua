-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Types.GuardTutorial);
local u1 = table.freeze({ "StealEgg", "HeadToPen", "EquipEgg", "PlaceEgg", "HatchEgg", "PlacePet", "ExpandPen", "TreadmillIntro" });
local u2 = {};

for i, v in ipairs(u1) do
    u2[v] = i;
end;

table.freeze(u2);
local u4 = {
    GetOrderedStepIds = function() -- Line: 36, Name: GetOrderedStepIds
        -- upvalues: u1 (copy)
        return u1;
    end,

    GetFirstStepId = function() -- Line: 40, Name: GetFirstStepId
        -- upvalues: u1 (copy)
        return u1[1];
    end,

    GetIndex = function(p3) -- Line: 44, Name: GetIndex
        -- upvalues: u2 (copy)
        return u2[p3];
    end
};

function u4.GetNextStepId(p5) -- Line: 48
    -- upvalues: u4 (copy), u1 (copy)
    local v6 = u4.GetIndex(p5);

    if v6 == nil then
        return nil;
    end;

    return u1[v6 + 1];
end;

return u4;