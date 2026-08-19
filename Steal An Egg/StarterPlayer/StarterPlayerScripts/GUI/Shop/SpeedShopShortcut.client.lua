-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local v1 = GUI.Shop();
local v2 = GUI.Money();
local ScrollingFrame = v1.Frame.Main.ScrollingFrame;
local SpeedTop = ScrollingFrame.SpeedTop;
local ImageButton = v2.Bottom.Frame.SpeedValue.ImageLabel.ImageButton;
local v3 = ImageButton:IsA("GuiButton");
assert(v3, "Expected Money.Bottom.Frame.SpeedValue.ImageLabel.ImageButton to be a GuiButton");

local function centerShopScrollingFrameAt(p4, p5) -- Line: 31
    -- upvalues: Asserts (copy), ScrollingFrame (copy)
    Asserts.number(p5);
    local v6 = p4.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y + p5 - ScrollingFrame.AbsoluteWindowSize.Y / 2;
    local v7 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y);
    ScrollingFrame.CanvasPosition = Vector2.new(ScrollingFrame.CanvasPosition.X, (math.clamp(v6, 0, v7)));
end;

local function centerSpeedTopBottom() -- Line: 45
    -- upvalues: centerShopScrollingFrameAt (copy), SpeedTop (copy)
    centerShopScrollingFrameAt(SpeedTop, SpeedTop.AbsoluteSize.Y);
end;

local function openShopThenCenter(u8) -- Line: 49
    -- upvalues: TabController (copy)
    task.spawn(function() -- Line: 50
        -- upvalues: TabController (ref), u8 (copy)
        TabController.OpenTab("Shop");
        task.wait();
        task.wait();
        u8();
    end);
end;

ButtonFX(ImageButton, nil, function() -- Line: 62
    -- upvalues: centerSpeedTopBottom (copy), TabController (copy)
    local u9 = centerSpeedTopBottom;
    task.spawn(function() -- Line: 50
        -- upvalues: TabController (ref), u9 (copy)
        TabController.OpenTab("Shop");
        task.wait();
        task.wait();
        u9();
    end);
end);