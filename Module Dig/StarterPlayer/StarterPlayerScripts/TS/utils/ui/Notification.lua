-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ReplicatedStorage = v1.ReplicatedStorage;
local TweenService = v1.TweenService;
local Colors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "Colors").Colors;
local playSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playSound;
local playAndDestroy = RuntimeLib.import(script, script.Parent, "tween", "playAndDestroy").playAndDestroy;
local TextGradient = RuntimeLib.import(script, script.Parent, "gradient", "TextGradient").TextGradient;
local u2 = {
    Pop = 0.4
};
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 17, Name: __tostring
        return "Notification";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 22
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(u5, p6, p7, p8, p9, p10, p11, p12, p13) -- Line: 26
    -- upvalues: u3 (ref), ReplicatedStorage (copy), Colors (copy), PlayerGui (copy)
    local v14 = p9 == nil and "White" or p9;
    local v15 = p11 == nil and "Notification" or p11;
    local v16 = p12 == nil and "Frame" or p12;
    u5.duration = p7;
    u5.count = 1;

    if type(p6) == "string" then
        u5.text = p6;
    else
        u5.segments = p6;
        local v17 = table.create(#p6);

        local function _(p18) -- Line: 48
            return p18.text;
        end;

        for i, v in p6 do
            local _ = i - 1;
            v17[i] = v.text;
        end;

        u5.text = table.concat(v17, "");
    end;

    local function _(p19) -- Line: 59
        -- upvalues: u5 (copy)
        return p19.text == u5.text;
    end;

    local v20 = nil;

    for i, v in u3.active do
        local _ = i - 1;

        if v.text == u5.text == true then
            v20 = v;
            break;
        end;
    end;

    if v20 then
        v20:bump();

        return nil;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets ~= nil then
        Assets = Assets:FindFirstChild("ScreenUI");

        if Assets ~= nil then
            Assets = Assets:FindFirstChild(v15);
        end;
    end;

    local v21;

    if Assets == nil then
        v21 = Assets;
    else
        v21 = Assets:IsA("Frame");
    end;

    if not v21 then
        return nil;
    end;

    Assets.ZIndex = 50;
    u5.sound = p8 == nil and "Notification" or p8;
    u5.frame = Assets:Clone();
    local TextLabel = u5.frame:WaitForChild("TextLabel", 10);

    if not TextLabel then
        u5.frame:Destroy();

        return nil;
    end;

    u5.label = TextLabel;
    u5.frame.Visible = false;
    u5.uiScale = Instance.new("UIScale");
    u5.uiScale.Scale = 0;
    u5.uiScale.Parent = u5.frame;
    u5.label.RichText = true;
    local label = u5.label;

    if typeof(v14) ~= "Color3" then
        v14 = Colors[v14];
    end;

    label.TextColor3 = v14;

    if p13 ~= nil then
        local FontFace = u5.label.FontFace;
        u5.label.FontFace = Font.new(FontFace.Family, FontFace.Weight, p13);
    end;

    if p10 then
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Color = p10;
        UIGradient.Rotation = 90;
        UIGradient.Parent = u5.label;
    end;

    local Notifications = PlayerGui:FindFirstChild("Notifications");

    if Notifications ~= nil then
        Notifications = Notifications:FindFirstChild(v16);
    end;

    local v22;

    if Notifications == nil then
        v22 = Notifications;
    else
        v22 = Notifications:IsA("Frame");
    end;

    if not v22 then
        u5.frame:Destroy();
        u5.frame = nil;

        return nil;
    end;

    u5.frame.Parent = Notifications;
    table.insert(u3.active, u5);
    u5:updateText();
    u5:animateIn();
    u5:startTimer();
end;

function u3.updateText(p23) -- Line: 138
    -- upvalues: TextGradient (copy)
    if not p23.label then
        return nil;
    end;

    local v24 = p23.count <= 1 and "" or ` (x{p23.count})`;

    if not p23.segments then
        p23.label.Text = `{p23.text}{v24}`;

        return nil;
    end;

    local label = p23.label;
    local v25;

    if v24 == "" then
        v25 = p23.segments;
    else
        v25 = {};
        local v26 = #v25;
        local segments = p23.segments;
        local v27 = #segments;
        table.move(segments, 1, v27, v26 + 1, v25);
        v25[v26 + v27 + 1] = {
            text = v24
        };
    end;

    TextGradient.applySegments(label, v25);
end;

function u3.bump(p28) -- Line: 165
    p28.count = p28.count + 1;
    p28:startTimer();
    p28:updateText();
    p28:animateIn();
end;

function u3.startTimer(u29) -- Line: 171
    if u29.destroyTimer then
        task.cancel(u29.destroyTimer);
    end;

    u29.destroyTimer = task.delay(u29.duration, function() -- Line: 175
        -- upvalues: u29 (copy)
        return u29:animateOut();
    end);
end;

function u3.animateIn(p30) -- Line: 179
    -- upvalues: playAndDestroy (copy), TweenService (copy), u2 (copy), playSound (copy)
    if not (p30.uiScale and p30.frame) then
        return nil;
    end;

    p30.frame.Visible = true;
    playAndDestroy(TweenService:Create(p30.uiScale, TweenInfo.new(0.3), {
        Scale = 1.2
    }));

    if p30.sound and p30.sound ~= "None" then
        local sound = p30.sound;
        local v31 = {};
        local v32 = u2[p30.sound];
        v31.volume = v32 == nil and 1 or v32;
        playSound(sound, v31);
    end;
end;

function u3.animateOut(u33) -- Line: 199
    -- upvalues: TweenService (copy), u3 (ref)
    if not (u33.uiScale and u33.frame) then
        return nil;
    end;

    local u34 = TweenService:Create(u33.uiScale, TweenInfo.new(0.3), {
        Scale = 0
    });
    u34:Play();
    u34.Completed:Once(function() -- Line: 207
        -- upvalues: u34 (copy), u33 (copy), u3 (ref)
        u34:Destroy();
        local frame = u33.frame;

        if frame ~= nil then
            frame:Destroy();
        end;

        local function _(p35) -- Line: 216
            -- upvalues: u33 (ref)
            return p35 ~= u33;
        end;

        local v36 = 0;
        local v37 = {};

        for i, v in u3.active do
            local _ = i - 1;

            if v ~= u33 == true then
                v36 = v36 + 1;
                v37[v36] = v;
            end;
        end;

        u3.active = v37;
    end);
end;

u3.active = {};

return {
    Notification = u3
};