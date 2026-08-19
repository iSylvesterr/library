-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GetOrCreateUIScale = require(ReplicatedStorage.Library.Functions.GetOrCreateUIScale);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local Guards = Constants.NETWORK_MAP.Guards;
local u1 = Color3.fromRGB(255, 64, 64);
local u2 = Color3.fromRGB(48, 255, 105);
local u3 = Log.new();
local u4 = GUI.GetMoreSpeedOnHit();
local Frame = u4.Frame;
local v5 = Frame:IsA("Frame");
assert(v5, "PlayerGui.GetMoreSpeedOnHit.Frame must be a Frame");
local Button = Frame.Button;
local v6 = Button:IsA("GuiButton");
assert(v6, "PlayerGui.GetMoreSpeedOnHit.Frame.Button must be a GuiButton");
local Frame2 = Button.Frame;
local v7 = Frame2:IsA("Frame");
assert(v7, "PlayerGui.GetMoreSpeedOnHit.Frame.Button.Frame must be a Frame");
local Title = Frame2.Title;
local v8 = Title:IsA("TextLabel");
assert(v8, "PlayerGui.GetMoreSpeedOnHit.Frame.Button.Frame.Title must be a TextLabel");
local u9 = GetOrCreateUIScale(Frame2);
local Position = Frame.Position;
local u10 = UDim2.new(Position.X.Scale, Position.X.Offset, -0.4, Position.Y.Offset);
local TextColor3 = Title.TextColor3;
local Scale = u9.Scale;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = 0;

local function playPositionTween(p15, p16) -- Line: 55
    -- upvalues: u11 (ref), Tween (copy), Frame (copy)
    if u11 ~= nil then
        u11:Cancel();
    end;

    u11 = Tween(Frame, {
        Position = p15
    }, { 0.4, "Back", p16 });

    return u11;
end;

local function stopTitlePulse() -- Line: 63
    -- upvalues: u12 (ref)
    local v17 = u12;

    if v17 == nil then
        return;
    end;

    u12 = nil;
    v17:Destroy();
end;

local function startTitlePulse() -- Line: 73
    -- upvalues: u12 (ref), Title (copy), TextColor3 (copy), u9 (copy), Scale (copy), Trove (copy), Tween (copy), u2 (copy)
    local v18 = u12;

    if v18 ~= nil then
        u12 = nil;
        v18:Destroy();
    end;

    Title.TextColor3 = TextColor3;
    u9.Scale = Scale;
    local u19 = Trove.new();
    u12 = u19;
    u19:Add(function() -- Line: 80
        -- upvalues: Title (ref), TextColor3 (ref), u9 (ref), Scale (ref)
        Title.TextColor3 = TextColor3;
        u9.Scale = Scale;
    end);
    u19:Add(task.spawn(function() -- Line: 84
        -- upvalues: u12 (ref), u19 (copy), Title (ref), TextColor3 (ref), u9 (ref), Scale (ref), Tween (ref), u2 (ref)
        while u12 == u19 do
            Title.TextColor3 = TextColor3;
            u9.Scale = Scale;
            local v20 = Tween(Title, {
                TextColor3 = u2
            }, { 0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
            local v21 = Tween(u9, {
                Scale = Scale * 1.3
            }, { 0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
            u19:Add(v20);
            u19:Add(v21);
            v21.Completed:Wait();

            if u12 ~= u19 then
                break;
            end;

            local v22 = Tween(Title, {
                TextColor3 = TextColor3
            }, { 0.62, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out });
            local v23 = Tween(u9, {
                Scale = Scale
            }, { 0.62, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out });
            u19:Add(v22);
            u19:Add(v23);
            v23.Completed:Wait();
            Title.TextColor3 = TextColor3;
            u9.Scale = Scale;
        end;
    end));
end;

local function showOffer(p24, p25) -- Line: 124
    -- upvalues: u14 (ref), u13 (ref), Title (copy), Simple (copy), Frame (copy), u10 (copy), startTitlePulse (copy), u4 (copy), playPositionTween (copy), Position (copy), u12 (ref)
    u14 = u14 + 1;
    local u26 = u14;
    u13 = p24;
    Title.Text = `+{Simple.FormatCompact(p25, ".#")}`;
    Frame.Position = u10;
    startTitlePulse();
    u4.Enabled = true;
    playPositionTween(Position, "Out");
    task.delay(6, function() -- Line: 134
        -- upvalues: u26 (copy), u14 (ref), playPositionTween (ref), u10 (ref), u12 (ref), u13 (ref), u4 (ref)
        if u26 ~= u14 then
            return;
        end;

        playPositionTween(u10, "In").Completed:Once(function() -- Line: 139
            -- upvalues: u26 (ref), u14 (ref), u12 (ref), u13 (ref), u4 (ref)
            if u26 ~= u14 then
                return;
            end;

            local v27 = u12;

            if v27 ~= nil then
                u12 = nil;
                v27:Destroy();
            end;

            u13 = nil;
            u4.Enabled = false;
        end);
    end);
end;

u4.Enabled = false;
Title.TextColor3 = TextColor3;
u9.Scale = Scale;
ButtonFX(Button, nil, function() -- Line: 157
    -- upvalues: u13 (ref), u3 (copy), PromptPurchase (copy)
    local v28 = u13;

    if v28 == nil then
        u3:AtWarning():Log("GetMoreSpeedOnHit button activated without an active product");

        return;
    end;

    PromptPurchase.Prompt(v28, true);
end);
Network.Fired(Guards.SPEED_HIT_WARNING):Connect(function() -- Line: 166
    -- upvalues: Message (copy), u1 (copy)
    Message.Bottom({
        Message = "You don\'t have enough speed!",
        Time = 2,
        Color = u1
    });
end);
Network.Fired(Guards.SPEED_HIT_OFFER):Connect(showOffer);