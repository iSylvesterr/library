-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local UIMgr = UtilsSystem.UIMgr;
local UIanima = UtilsSystem.UIanima;
local Main = UtilsSystem.LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Main", (1 / 0));
local Window = Main.Left.Window;
local Window2 = Main.Right.Window;
local Event = Main.Left:WaitForChild("Event", (1 / 0));

local function _resolveWindowButton(p1) -- Line: 59
    -- upvalues: Window (copy), Window2 (copy)
    local v2 = Window:FindFirstChild(p1) or Window2:FindFirstChild(p1);

    if not v2 then
        return nil, nil;
    end;

    if v2:IsA("ImageButton") then
        local Frame = v2:FindFirstChild("Frame");

        if Frame and Frame:IsA("GuiObject") then
            return v2, Frame;
        end;

        return v2, v2;
    end;

    local Button = v2:FindFirstChild("Button");

    if not (Button and Button:IsA("ImageButton")) then
        return nil, nil;
    end;

    local Frame = v2:FindFirstChild("Frame");

    if Frame and Frame:IsA("GuiObject") then
        return Button, Frame;
    end;

    return Button, v2;
end;

local function _bindIconHover(p3, u4) -- Line: 94
    -- upvalues: AddListen (copy), UIanima (copy)
    AddListen.AddMouseHover(p3, function() -- Line: 95
        -- upvalues: UIanima (ref), u4 (copy)
        UIanima.BtnIconHoverEnter(u4);
    end, function() -- Line: 97
        -- upvalues: UIanima (ref), u4 (copy)
        UIanima.BtnIconHoverLeave(u4);
    end);
end;

local function _bindWindow(p5, u6, u7) -- Line: 109
    -- upvalues: _resolveWindowButton (copy), AddListen (copy), UIanima (copy), NetWork (copy), NetMsg (copy)
    local v8, v9 = _resolveWindowButton(p5);

    if not v8 then
        return;
    end;

    local Frame = v8:FindFirstChild("Frame");

    if Frame then
        Frame = Frame:FindFirstChild("Icon");
    end;

    if Frame and Frame:IsA("GuiObject") then
        AddListen.AddMouseHover(v8, function() -- Line: 95
            -- upvalues: UIanima (ref), Frame (copy)
            UIanima.BtnIconHoverEnter(Frame);
        end, function() -- Line: 97
            -- upvalues: UIanima (ref), Frame (copy)
            UIanima.BtnIconHoverLeave(Frame);
        end);
    end;

    AddListen.AddMouseCLick(v8, function() -- Line: 121
        -- upvalues: u7 (copy), NetWork (ref), NetMsg (ref), u6 (copy)
        if u7 then
            u7();

            return;
        end;

        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, u6, nil, true, true);
    end, v9);
end;

_bindWindow("商店", "RuboxShop", nil);
_bindWindow("武器", "Weapon", nil);
_bindWindow("防具", "Armor", nil);
_bindWindow("扫帚", "Broom", nil);
_bindWindow("重生", "Rebirth", nil);
_bindWindow("背包", "Bag", nil);
_bindWindow("图鉴", "Index", nil);
(function() -- Line: 136, Name: _bindLeftEventEntry
    -- upvalues: UIMgr (copy), Event (copy), Log (copy), AddListen (copy), UIanima (copy), NetWork (copy), NetMsg (copy)
    local v10 = UIMgr.FindButtonInFrame(Event);

    if not v10 then
        Log.warn("[InitMain] Main.Left.Event 缺少 Btn");

        return;
    end;

    local Icon = Event:FindFirstChild("Icon");

    if Icon and (Icon:IsA("GuiObject") and v10:IsA("ImageButton")) then
        AddListen.AddMouseHover(v10, function() -- Line: 95
            -- upvalues: UIanima (ref), Icon (copy)
            UIanima.BtnIconHoverEnter(Icon);
        end, function() -- Line: 97
            -- upvalues: UIanima (ref), Icon (copy)
            UIanima.BtnIconHoverLeave(Icon);
        end);
    end;

    AddListen.AddMouseCLick(v10, function() -- Line: 146
        -- upvalues: NetWork (ref), NetMsg (ref)
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Event", nil, true, true);
    end, Event);
end)();