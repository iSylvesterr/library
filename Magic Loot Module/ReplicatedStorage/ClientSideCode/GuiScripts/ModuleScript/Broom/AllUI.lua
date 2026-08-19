-- Decompiled with Potassium's decompiler.

local Broom = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Broom", (1 / 0));
local v1 = Broom:FindFirstChild("ContentClip") or Broom;

return {
    UIRoot = Broom,
    EquipmentFrame = v1.Main._EquipmentFrame,
    Exit = v1.Top._Exit,
    EquipmentTemp = v1.Main._EquipmentFrame._EquipmentTemp,
    Btns = v1.Main._EquipmentFrame._EquipmentTemp.BottomFrame._Btns,
    BuyBtn = v1.Main._EquipmentFrame._EquipmentTemp.BottomFrame._Btns._BuyBtn,
    EquipBtn = v1.Main._EquipmentFrame._EquipmentTemp.BottomFrame._Btns._EquipBtn,
    JumpBtn = v1.Main._EquipmentFrame._EquipmentTemp.BottomFrame._Btns._JumpBtn,
    RobuxBuyBtn = v1.Main._EquipmentFrame._EquipmentTemp.BottomFrame._Btns._RobuxBuyBtn
};