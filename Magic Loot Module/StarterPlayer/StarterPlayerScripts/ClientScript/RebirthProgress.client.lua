-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local TranslationHelper = UtilsSystem.TranslationHelper;
local u1 = Color3.fromHex("#ffd259");
local u2 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Level);
local u3 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Rebirth);
local u4 = LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Main", (1 / 0)):WaitForChild("Left", (1 / 0)):WaitForChild("Window", (1 / 0)):WaitForChild("重生", (1 / 0)):WaitForChild("重生进度", (1 / 0));
local TextColor3 = u4.TextColor3;

local function _calcRebirthProgressPercent() -- Line: 46
    -- upvalues: u3 (copy), u2 (copy), CfgFind (copy)
    local v5 = math.floor(u3.Value);
    local v6 = math.floor(u2.Value);
    local v7 = CfgFind.GetCfgByNameAndID("rebirthConf", v5 + 1);

    if not v7 then
        return 100;
    end;

    local v8 = tonumber(v7.LvNeed) or 0;
    local v9 = math.floor(v8);

    if v9 <= 0 then
        return 100;
    end;

    if v9 == 1 then
        return v6 >= 1 and 100 or 0;
    end;

    local v10 = math.floor((v6 - 1) / (v9 - 1) * 100);

    return math.clamp(v10, 0, 100);
end;

local function _refreshRebirthProgress() -- Line: 71
    -- upvalues: _calcRebirthProgressPercent (copy), TranslationHelper (copy), u4 (copy), u1 (copy), TextColor3 (copy)
    local v11 = _calcRebirthProgressPercent();
    TranslationHelper.SetText_UnTrans(u4, (`{v11}%`));

    if v11 >= 100 then
        u4.TextColor3 = u1;

        return;
    end;

    u4.TextColor3 = TextColor3;
end;

AddListen.NumValueAdd(u2, _refreshRebirthProgress, true);
AddListen.NumValueAdd(u3, _refreshRebirthProgress, true);