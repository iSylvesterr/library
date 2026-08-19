-- Decompiled with Potassium's decompiler.

local Event = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Event", (1 / 0));
local v1 = Event:FindFirstChild("ContentClip") or Event;

return {
    UIRoot = Event,
    Tab = v1._Tab,
    Buy = v1.Main._Buy,
    Hatch = v1.Main._Hatch,
    Shop = v1.Main._Shop,
    Task = v1.Main._Task,
    CurTitle = v1.Top._CurTitle,
    EndTime = v1.Top._EndTime,
    Exit = v1.Top._Exit,
    MoneyShow = v1.Top._MoneyShow,
    TabTemp = v1._Tab._TabTemp,
    RobuxBuyTemp = v1.Main._Buy._RobuxBuyTemp,
    HatchBtns = v1.Main._Hatch._HatchBtns,
    HatchFrame1 = v1.Main._Hatch._HatchFrame1,
    HatchFrame2 = v1.Main._Hatch._HatchFrame2,
    HatchFrame3 = v1.Main._Hatch._HatchFrame3,
    BigFrame = v1.Main._Shop._BigFrame,
    SmallFrame = v1.Main._Shop._SmallFrame,
    TaskTemp = v1.Main._Task._TaskTemp,
    TaskTitleTemp = v1.Main._Task._TaskTitleTemp,
    HatchBtn1 = v1.Main._Hatch._HatchBtns._HatchBtn1,
    HatchBtn2 = v1.Main._Hatch._HatchBtns._HatchBtn2,
    HatchBtn3 = v1.Main._Hatch._HatchBtns._HatchBtn3,
    HatchBigTemp = v1.Main._Hatch._HatchFrame1._HatchBigTemp,
    HatchMiddleTemp = v1.Main._Hatch._HatchFrame2._HatchMiddleTemp,
    HatchSmallTemp = v1.Main._Hatch._HatchFrame3._HatchSmallTemp,
    ["进度条"] = v1.Main._Hatch["进度条Frame"]["_进度条"],
    BigTemp = v1.Main._Shop._BigFrame._BigTemp,
    Temp = v1.Main._Shop._SmallFrame._Temp,
    ["在线领取抽奖券提示"] = v1.Main._Hatch["进度条Frame"]["_进度条"]["_在线领取抽奖券提示"]
};