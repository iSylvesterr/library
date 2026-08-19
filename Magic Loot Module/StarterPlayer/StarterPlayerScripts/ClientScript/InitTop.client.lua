-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local MathMgr = UtilsSystem.MathMgr;
local TranslationHelper = UtilsSystem.TranslationHelper;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local v1 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small;
local v2 = UDim2.new(0.5, 0, 0, 30);
local u3 = 0;
local v4 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Coin);
local v5 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Rebirth);
local u6 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.LimitBagSize);
local u7 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Power);
local u8 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.PowerUsed);
local u9 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Level);
local LimitBagUsed = LocalPlayer:WaitForChild("LimitBagUsed", (1 / 0));
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", (1 / 0));
local ScreenGui = PlayerGui:WaitForChild("ScreenGui", (1 / 0));
local Top = PlayerGui:WaitForChild("ScreenGui_Full", (1 / 0)):WaitForChild("Top", (1 / 0));
local ButtomLeft = ScreenGui:WaitForChild("Main", (1 / 0)):WaitForChild("ButtomLeft", (1 / 0));
local Label = ButtomLeft:WaitForChild("金币", (1 / 0)):WaitForChild("Label", (1 / 0));
local Label2 = ButtomLeft:WaitForChild("重生", (1 / 0)):WaitForChild("Label", (1 / 0));
local Label3 = ButtomLeft:WaitForChild("临时背包容量", (1 / 0)):WaitForChild("Label", (1 / 0));
local u10 = Top:WaitForChild("经验进度条", (1 / 0));
local Bar = u10:WaitForChild("Bar", (1 / 0));
local u11 = u10:WaitForChild("等级", (1 / 0));
local u12 = u10:WaitForChild("经验", (1 / 0));
local u13 = u10:WaitForChild("PowerFrame", (1 / 0)):WaitForChild("魔力值", (1 / 0));
local u14 = Top:WaitForChild("回城", (1 / 0));
local ImageButton = u14:WaitForChild("ImageButton", (1 / 0));
local InDungeonChallenge = LocalPlayer:WaitForChild("InDungeonChallenge", (1 / 0));

if v1 then
    Top.Position = v2;
end;

AddListen.NumValueAdd(v4, function(p15) -- Line: 91
    -- upvalues: TranslationHelper (copy), Label (copy), MathMgr (copy)
    TranslationHelper.SetText_UnTrans(Label, MathMgr.getNumStr((math.floor(p15))));
end, true);
AddListen.NumValueAdd(v5, function(p16) -- Line: 95
    -- upvalues: TranslationHelper (copy), Label2 (copy), MathMgr (copy)
    TranslationHelper.SetText_UnTrans(Label2, MathMgr.getNumStr((math.floor(p16))));
end, true);

local function _onLimitBagSizeChange() -- Line: 100
    -- upvalues: TranslationHelper (copy), Label3 (copy), LimitBagUsed (copy), u6 (copy)
    TranslationHelper.SetText_UnTrans(Label3, math.floor(LimitBagUsed.Value) .. "/" .. math.floor(u6.Value));
end;

AddListen.NumValueAdd(u6, _onLimitBagSizeChange, true);
AddListen.NumValueAdd(LimitBagUsed, _onLimitBagSizeChange, false);
AddListen.NumValueAdd(u9, function(p17) -- Line: 110
    -- upvalues: TranslationHelper (copy), u11 (copy), MathMgr (copy)
    TranslationHelper.SetText(u11, "等级X", { MathMgr.getNumStr((math.floor(p17))) });
end, true);

local function _onMagicValueChange() -- Line: 117
    -- upvalues: u7 (copy), u8 (copy), TranslationHelper (copy), u13 (copy), MathMgr (copy)
    local v18 = math.floor(u7.Value + u8.Value);
    TranslationHelper.SetText(u13, "魔力值为", { MathMgr.getNumStr(v18) });
end;

AddListen.NumValueAdd(u7, _onMagicValueChange, true);
AddListen.NumValueAdd(u8, _onMagicValueChange, false);

local function _onExpChange() -- Line: 125
    -- upvalues: u7 (copy), u9 (copy), GetData (copy), Bar (copy), TranslationHelper (copy), u12 (copy), MathMgr (copy)
    local Value = u7.Value;
    local v19 = GetData.GetExpByLv(u9.Value);
    local v20 = v19 <= 0 and 1 or math.clamp(Value / v19, 0, 1);
    Bar.Size = UDim2.new(math.max(v20, 0.05), 0, 1, 0);
    TranslationHelper.SetText_UnTrans(u12, MathMgr.getNumStr((math.floor(Value))) .. "/" .. MathMgr.getNumStr((math.floor(v19))));
end;

AddListen.NumValueAdd(u7, _onExpChange);
AddListen.NumValueAdd(u9, _onExpChange, true);
AddListen.NumValueAdd(InDungeonChallenge, function(p21) -- Line: 141
    -- upvalues: u14 (copy), u10 (copy)
    local v22 = p21 > 0;
    u14.Visible = v22;
    u10.Visible = not v22;
end, true);
AddListen.AddMouseCLick(ImageButton, function() -- Line: 147
    -- upvalues: u3 (ref), NetWork (copy), NetMsg (copy)
    local v23 = os.clock();

    if v23 - u3 < 1.5 then
        return;
    end;

    u3 = v23;
    NetWork.FireServer(NetMsg.DUNGEON_RETURN_TOWN);
end, u14);