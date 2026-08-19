-- Decompiled with Potassium's decompiler.

local EnumMgr = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr;
local Bag = require(script.Parent.Bag);

return {
    CanMeetLoginAdvancePrerequisite = function(p1) -- Line: 40, Name: CanMeetLoginAdvancePrerequisite
        -- upvalues: Bag (copy), EnumMgr (copy)
        if not (p1 and p1.Parent) then
            return false;
        end;

        local v2 = Bag.GetItemCountByID(p1, EnumMgr.ItemID.Rebirth) or 0;

        return math.floor(v2) >= 1;
    end,

    GetLoginAdvanceNeedRebirth = function() -- Line: 53, Name: GetLoginAdvanceNeedRebirth
        return 1;
    end
};