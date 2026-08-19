-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local Bag = require(script.Parent.Bag);
local PlayerMirror = require(script.Parent.PlayerMirror);
local u1 = {};
local u2 = CfgFind.GetCfgByName("plrdataConf");
local u3 = { "Attrs", "Attrs_Buff", "属性点属性", "Attrs_Equip" };
local u4 = { {
        tag = "Lucky1",
        add = 0.5
    }, {
        tag = "Lucky2",
        add = 1
    }, {
        tag = "Lucky3",
        add = 1.5
    } };

local function _getPlrAttrValue(p5, p6, p7) -- Line: 50
    if not p5 then
        return nil;
    end;

    local v8 = p5:FindFirstChild(p6);

    if not v8 then
        return nil;
    end;

    local v9 = v8:FindFirstChild(p7);

    if v9 and v9:IsA("NumberValue") then
        return v9;
    end;

    return nil;
end;

local function _getRebirthExpAddMul(p10) -- Line: 74
    local RebirthBonus = p10:FindFirstChild("RebirthBonus");

    if not (RebirthBonus and RebirthBonus:IsA("Folder")) then
        return 1;
    end;

    local ExpAdd = RebirthBonus:FindFirstChild("ExpAdd");

    if not (ExpAdd and ExpAdd:IsA("NumberValue")) then
        return 1;
    end;

    local v11 = tonumber(ExpAdd.Value);

    return (type(v11) ~= "number" or (v11 ~= v11 or v11 <= 0)) and 1 or v11;
end;

function u1.GetRebirthExpAddMul(p12) -- Line: 96
    -- upvalues: _getRebirthExpAddMul (copy)
    return not (p12 and p12:IsA("Player")) and 1 or _getRebirthExpAddMul(p12);
end;

function u1.GetEffectiveTrainAtk(p13) -- Line: 109
    -- upvalues: u1 (copy), EnumMgr (copy)
    if not p13 then
        return 0;
    end;

    local v14 = u1.GetPlrAttr(p13, EnumMgr.PlrAttr.Train_Base);
    local v15 = u1.GetPlrAttr(p13, EnumMgr.PlrAttr.Train_Mul);
    local v16 = (type(v15) ~= "number" or (v15 ~= v15 or v15 < -1)) and 0 or v15;
    local v17 = not p13:IsA("Player") and 1 or u1.GetRebirthExpAddMul(p13);

    return v14 * (1 + v16) * v17;
end;

local function _getPlayerMagicPowerCount(p18) -- Line: 130
    -- upvalues: Bag (copy), EnumMgr (copy)
    return not (p18 and p18:IsA("Player")) and 0 or (Bag.GetItemCountByID(p18, EnumMgr.ItemID.Power) or 0) + (Bag.GetItemCountByID(p18, EnumMgr.ItemID.PowerUsed) or 0);
end;

function u1.GetTotalMagicValue(p19) -- Line: 144
    -- upvalues: u1 (copy), EnumMgr (copy)
    return u1.GetPlrAttr(p19, EnumMgr.PlrAttr.Atk);
end;

function u1.GetCombatAttackPower(p20) -- Line: 153
    -- upvalues: u1 (copy), EnumMgr (copy)
    return not p20 and 0 or u1.GetPlrAttr(p20, EnumMgr.PlrAttr.Atk);
end;

local function _getPassLuckAdd(p21) -- Line: 166
    -- upvalues: u4 (copy), PlayerMirror (copy)
    local v22 = 0;

    for _, v in ipairs(u4) do
        if PlayerMirror.IsHasPass(p21, v.tag) then
            v22 = v22 + v.add;
        end;
    end;

    return v22;
end;

function u1.GetPlrAttr(p23, p24) -- Line: 184
    -- upvalues: EnumMgr (copy), Bag (copy), u2 (copy), u3 (copy), _getPassLuckAdd (copy)
    if not p23 then
        return 0;
    end;

    local v25 = tostring(p24);
    local v26 = tonumber(p24);

    if p23:IsA("Player") and v26 == EnumMgr.PlrAttr.Atk then
        local v27 = not (p23 and p23:IsA("Player")) and 0 or (Bag.GetItemCountByID(p23, EnumMgr.ItemID.Power) or 0) + (Bag.GetItemCountByID(p23, EnumMgr.ItemID.PowerUsed) or 0);
        local v28 = u2[v25] or u2[p24];

        if not v28 or (not v28.Max or v28.Max == "") then
            return v27;
        end;

        local v29 = tonumber(v28.Max);

        return math.clamp(v27, 0, v29);
    end;

    local v30 = 0;

    for _, v in u3 do
        local v31;

        if p23 then
            local v32 = p23:FindFirstChild(v);

            if v32 then
                v31 = v32:FindFirstChild(v25);

                if not (v31 and v31:IsA("NumberValue")) then
                    v31 = nil;
                end;
            else
                v31 = nil;
            end;
        else
            v31 = nil;
        end;

        if v31 then
            v30 = v30 + v31.Value;
        end;
    end;

    if p23:IsA("Player") and v26 == EnumMgr.PlrAttr.Luck then
        v30 = v30 + _getPassLuckAdd(p23);
    end;

    local v33 = u2[v25] or u2[p24];

    if not v33 or (not v33.Max or v33.Max == "") then
        return v30;
    end;

    local v34 = tonumber(v33.Max);

    return math.clamp(v30, 0, v34);
end;

return u1;