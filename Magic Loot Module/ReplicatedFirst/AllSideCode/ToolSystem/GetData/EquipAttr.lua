-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local v1 = {};

local function _mergeAttrs(p2, p3) -- Line: 24
    if type(p3) ~= "table" then
        return nil;
    end;

    for i, v in pairs(p3) do
        if type(i) == "number" and type(v) == "number" then
            p2[i] = (p2[i] or 0) + v;
        end;
    end;

    return nil;
end;

function v1.GetEquipAttrs(p4) -- Line: 42
    -- upvalues: UtilsSystem (copy), _mergeAttrs (copy)
    local v5 = {};

    if not p4 then
        return v5;
    end;

    local SystemWeapon = UtilsSystem.SystemWeapon;

    if SystemWeapon and SystemWeapon.GetWeaponAttrs then
        _mergeAttrs(v5, SystemWeapon.GetWeaponAttrs(p4));
    end;

    local SystemArmor = UtilsSystem.SystemArmor;

    if SystemArmor and SystemArmor.GetArmorAttrs then
        _mergeAttrs(v5, SystemArmor.GetArmorAttrs(p4));
    end;

    local SystemBroom = UtilsSystem.SystemBroom;

    if SystemBroom and SystemBroom.GetBroomAttrs then
        _mergeAttrs(v5, SystemBroom.GetBroomAttrs(p4));
    end;

    return v5;
end;

return v1;