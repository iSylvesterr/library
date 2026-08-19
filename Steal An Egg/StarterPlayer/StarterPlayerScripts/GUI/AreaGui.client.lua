-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Directory.Areas);
local AreaNotificationTracker = require(script.Parent.Parent.Game.GuardAreas.AreaNotificationTracker);
local GradientSwap = require(ReplicatedStorage.Library.Functions.GradientSwap);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local GuiTransitionGroup = require(ReplicatedStorage.Library.Client.GUIFX.GuiTransitionGroup);
local u1 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u3 = GUI.AreaGui();
local Frame = u3.Frame;
local Main = Frame.Texts.Main;
local Emoji = Frame.Texts.Emoji;
local v4 = {};
local u5 = 0;
local u6 = nil;

local function applyRarityGradient(p7) -- Line: 48
    -- upvalues: GradientSwap (copy), Main (copy)
    GradientSwap(Main, p7.Rarity.Gradient);
end;

local function renderArea(p8) -- Line: 53
    -- upvalues: Main (copy), Emoji (copy), GradientSwap (copy)
    Main.Text = `{p8.DisplayName}`;
    Emoji.Text = `{p8.Emoji}`;
    GradientSwap(Main, p8.Rarity.Gradient);
end;

local function showArea(p9) -- Line: 59
    -- upvalues: u5 (ref), u6 (ref), Main (copy), Emoji (copy), GradientSwap (copy), u3 (copy), u1 (copy), u2 (copy)
    u5 = u5 + 1;
    local u10 = u5;
    local u11 = u6;
    assert(u11 ~= nil, "AreaGui transition group must be initialized before show");
    u11:Cancel();
    Main.Text = `{p9.DisplayName}`;
    Emoji.Text = `{p9.Emoji}`;
    GradientSwap(Main, p9.Rarity.Gradient);
    u11:PrepareHidden();
    u3.Enabled = true;
    u11:TweenVisible(u1);
    task.delay(1, function() -- Line: 71
        -- upvalues: u10 (copy), u5 (ref), u11 (copy), u2 (ref), u3 (ref)
        if u10 ~= u5 then
            return;
        end;

        u11:Cancel();
        u11:TweenHidden(u2);
        task.delay(u2.Time, function() -- Line: 79
            -- upvalues: u10 (ref), u5 (ref), u3 (ref), u11 (ref)
            if u10 ~= u5 then
                return;
            end;

            u3.Enabled = false;
            u11:RestorePositions();
        end);
    end);
end;

local function start() -- Line: 90
    -- upvalues: u6 (ref), GuiTransitionGroup (copy), u3 (copy), AreaNotificationTracker (copy), showArea (copy)
    u6 = GuiTransitionGroup.new(u3, u3, 0.02);
    u3.Enabled = false;
    AreaNotificationTracker.Start(showArea);
end;

function v4.Start() -- Line: 100
    -- upvalues: u6 (ref), GuiTransitionGroup (copy), u3 (copy), AreaNotificationTracker (copy), showArea (copy)
    u6 = GuiTransitionGroup.new(u3, u3, 0.02);
    u3.Enabled = false;
    AreaNotificationTracker.Start(showArea);
end;

v4.Start();