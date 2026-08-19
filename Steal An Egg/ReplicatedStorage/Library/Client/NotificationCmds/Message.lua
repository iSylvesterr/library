-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Tween = require(game.ReplicatedStorage.Library.Functions.Tween);
local Audio = require(game.ReplicatedStorage.Library.Audio);
local NotificationInstance = require(script.Parent.NotificationInstance);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Interface = require(script.Types.Interface);
local Message = game.ReplicatedStorage.Assets.UI.Notifications.Bottom.Message;
local u5 = {
    __types = Interface,

    GetTextFromData = function(p1, p2, p3) -- Line: 34, Name: GetTextFromData
        -- upvalues: Asserts (copy)
        Asserts.string(p1);
        Asserts.optional.Color3(p2);
        Asserts.optional.Color3(p3);
        local v4 = p3 and p3:ToHex() or "000000";

        if p2 then
            return ("<stroke color=\"#%s\" joins=\"bevel\" thickness=\"3\" transparency=\"0\"><font color=\"#%s\">%s</font></stroke>"):format(v4, p2:ToHex(), p1);
        end;

        return ("<stroke color=\"#%s\" joins=\"bevel\" thickness=\"3\" transparency=\"0\">%s</stroke>"):format(v4, p1);
    end
};

local function prepareNotif(u6, p7) -- Line: 45
    -- upvalues: Interface (copy), Message (copy), u5 (copy), Audio (copy), Tween (copy)
    assert(Interface.MessageDataInterface(u6));
    local u8 = Message:Clone();
    local Message2 = u6.Message;
    local Shadow = u8.Shadow;
    local Frame = u8.Frame;
    local TextLabel = Frame.TextLabel;
    local UIStroke = TextLabel:FindFirstChild("UIStroke");
    local PreText = Frame:FindFirstChild("PreText");

    if not (PreText and PreText:IsA("TextLabel")) then
        PreText = TextLabel:Clone();
        PreText.Name = "PreText";
        PreText.Parent = Frame;
    end;

    PreText.Visible = false;
    PreText.Text = "";
    PreText.TextColor3 = TextLabel.TextColor3;
    PreText.LayoutOrder = math.max(TextLabel.LayoutOrder + 1, 0);
    PreText.ZIndex = TextLabel.ZIndex;

    if not u6.Color then
        u6.Color = Color3.fromRGB(255, 255, 255);
    end;

    local u9 = nil;

    if u6.Color then
        local success, result = pcall(function() -- Line: 74
            -- upvalues: u6 (copy)
            return u6.Color:ToHex();
        end);

        if success then
            u9 = string.lower(result);
        end;
    end;

    if u6.Size then
        u8.Size = u6.Size;
    end;

    if u6.Gradient then
        u6.Gradient:Clone().Parent = TextLabel;
    end;

    if u6.ShowShadow then
        Shadow.Visible = true;
    else
        Shadow.Visible = false;
    end;

    TextLabel.Text = u5.GetTextFromData(Message2, u6.Color, u6.StrokeColor);
    TextLabel.TextColor3 = u6.Color or TextLabel.TextColor3;

    if UIStroke and u6.StrokeColor then
        UIStroke.Color = u6.StrokeColor;
    end;

    PreText.Text = "";
    PreText.Visible = false;
    PreText.TextColor3 = TextLabel.TextColor3;
    local PreText2 = u6.PreText;

    if PreText2 then
        PreText.Text = u5.GetTextFromData(PreText2.Text, PreText2.Color, PreText2.StrokeColor);
        PreText.Visible = PreText.Text ~= "";
    end;

    if u6.Font then
        TextLabel.FontFace = u6.Font;
    end;

    if u6.Image then
        local Icon = u8.Frame:FindFirstChild("Icon");

        if Icon and Icon:IsA("ImageLabel") then
            Icon.Image = u6.Image;
            Icon.Visible = true;
        end;
    end;

    return u8, function() -- Line: 126, Name: handleNotificationEffects
        -- upvalues: u6 (copy), u9 (ref), Audio (ref), u8 (copy), Shadow (copy), Tween (ref)
        if u6.Sound or u9 ~= "ff0000" then
            if u6.Sound then
                Audio.Play(u6.Sound, script, { 0.9, 1.1 }, 1);
            else
                Audio.Play("rbxassetid://133842042346471", script, { 0.8, 1.2 }, 0.6);
            end;
        else
            Audio.Play(17208372272, script, 1, 1);
        end;

        task.spawn(function() -- Line: 139
            -- upvalues: u8 (ref), Shadow (ref), Tween (ref)
            task.wait(0.65);

            if not (u8 and Shadow) then
                return;
            end;

            Tween(Shadow, {
                ImageTransparency = 1
            }, { 3.1, "Sine", "Out" });
        end);
    end;
end;

local function applyTextDedupe(p10, p11) -- Line: 159
    if p11.PreventDuplicateText then
        p11.DuplicateKey = p10.Message;
    end;
end;

function u5.Top(p12, p13) -- Line: 165
    -- upvalues: prepareNotif (copy), NotificationInstance (copy)
    local v14;

    if p13 then
        v14 = table.clone(p13);
    else
        v14 = nil;
    end;

    local u15;

    if v14 then
        u15 = v14.OnAppear or nil;
    else
        u15 = nil;
    end;

    local u16;

    if v14 then
        u16 = v14.OnComplete or nil;
    else
        u16 = nil;
    end;

    local v17 = v14 or {};
    v17.Time = p12.Time;
    v17.DelayInRound = p12.DelayInRound;

    if v17.PreventDuplicateText then
        v17.DuplicateKey = p12.Message;
    end;

    if v17 then
        v17.OnAppear = nil;
        v17.OnComplete = nil;
    end;

    local v18, u19 = prepareNotif(p12, v17);

    return NotificationInstance.new(NotificationInstance.Locations.Message, v18, function(p20) -- Line: 186, Name: onStart
        -- upvalues: u19 (copy), u15 (copy)
        u19();

        if typeof(u15) == "function" then
            u15(p20);
        end;
    end, v17, function(p21) -- Line: 194, Name: onFinish
        -- upvalues: u16 (copy)
        if typeof(u16) == "function" then
            u16(p21);
        end;
    end);
end;

function u5.Bottom(p22, p23) -- Line: 209
    -- upvalues: prepareNotif (copy), NotificationInstance (copy)
    local v24;

    if p23 then
        v24 = table.clone(p23);
    else
        v24 = nil;
    end;

    local u25;

    if v24 then
        u25 = v24.OnAppear or nil;
    else
        u25 = nil;
    end;

    local u26;

    if v24 then
        u26 = v24.OnComplete or nil;
    else
        u26 = nil;
    end;

    local v27 = v24 or {};
    v27.Time = p22.Time;
    v27.DelayInRound = p22.DelayInRound;

    if v27.PreventDuplicateText then
        v27.DuplicateKey = p22.Message;
    end;

    if v27 then
        v27.OnAppear = nil;
        v27.OnComplete = nil;
    end;

    local v28, u29 = prepareNotif(p22, v27);

    return NotificationInstance.new(NotificationInstance.Locations.Bottom, v28, function(p30) -- Line: 230, Name: onStart
        -- upvalues: u29 (copy), u25 (copy)
        u29();

        if typeof(u25) == "function" then
            u25(p30);
        end;
    end, v27, function(p31) -- Line: 238, Name: onFinish
        -- upvalues: u26 (copy)
        if typeof(u26) == "function" then
            u26(p31);
        end;
    end);
end;

return u5;