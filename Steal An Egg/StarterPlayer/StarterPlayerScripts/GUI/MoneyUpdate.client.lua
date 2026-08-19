-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Commas = require(ReplicatedStorage.Library.Functions.Commas);
local Network = require(ReplicatedStorage.Library.Client.Network);
local SettingsCmds = require(ReplicatedStorage.Library.Client.SettingsCmds);
local UpdateTextAndShadow = require(ReplicatedStorage.Library.Functions.UpdateTextAndShadow);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local MONEY_COLLECTED_EVENT = Network.NET_MAP.ActiveAssets.MONEY_COLLECTED_EVENT;
local u1 = 0;
local u2 = 0;
local u3 = 1;
local u4 = nil;
local u5 = nil;
local u6 = 0;
local CashCollect = SoundService.CashCollect;
local MoneyChange = ReplicatedStorage.Assets.MoneyChange;
local Money = GUI.Money().Bottom.Frame.Money;
local Money2 = Money.Money;
local Frame = Money.Changes.Frame;

local function playCashCollectSound() -- Line: 47
    -- upvalues: SettingsCmds (copy), u2 (ref), u3 (ref), CashCollect (copy)
    if not SettingsCmds.IsEnabled("SFX") then
        return;
    end;

    if tick() - u2 > 2 or u3 >= 3 then
        u3 = 1;
    end;

    u2 = tick();
    CashCollect.TimePosition = 0;
    CashCollect.PlaybackSpeed = u3;
    CashCollect:Play();
    u3 = u3 + 0.07;
end;

local function createMoneyChangeClone() -- Line: 64
    -- upvalues: MoneyChange (copy)
    local v7 = MoneyChange:Clone();
    local Label = v7.Label;
    local UIScale = v7.UIScale;
    local UIStroke = Label.UIStroke;
    local More = Label.More;
    local Less = Label.Less;
    local Icon = v7.Icon;
    Label.TextTransparency = 1;
    UIStroke.Transparency = 1;
    UIScale.Scale = 0;
    Icon.ImageTransparency = 1;

    return v7, Label, UIScale, UIStroke, Icon, More, Less;
end;

local function getTransparencyProperty(p8) -- Line: 81
    return (p8:IsA("ImageLabel") or p8:IsA("ImageButton")) and "ImageTransparency" or ((p8:IsA("TextLabel") or p8:IsA("TextButton")) and "TextTransparency" or (p8:IsA("UIStroke") and "Transparency" or nil));
end;

local function animateNotification(u9, u10, p11, u12, u13) -- Line: 93
    -- upvalues: Tween (copy), getTransparencyProperty (copy), Debris (copy)
    Tween(u10, {
        TextTransparency = 0.25
    }, { 0.5 });
    Tween(u12, {
        Transparency = 0.25
    }, { 0.5 });
    Tween(p11, {
        Scale = 1
    }, { 0.5, Enum.EasingStyle.Back });

    for _, v in ipairs(u13) do
        local v14 = getTransparencyProperty(v);

        if v14 then
            if v14 == "ImageTransparency" then
                v.ImageTransparency = 1;
            elseif v14 == "TextTransparency" then
                v.TextTransparency = 1;
            elseif v14 == "Transparency" then
                v.Transparency = 1;
            end;

            Tween(v, {
                [v14] = 0
            }, { 0.5 });
        end;
    end;

    task.delay(1, function() -- Line: 119
        -- upvalues: Tween (ref), u10 (copy), u12 (copy), u13 (copy), getTransparencyProperty (ref), Debris (ref), u9 (copy)
        Tween(u10, {
            TextTransparency = 1
        }, { 0.75 });
        Tween(u12, {
            Transparency = 1
        }, { 0.75 });

        for _, v in ipairs(u13) do
            local v15 = getTransparencyProperty(v);

            if v15 then
                Tween(v, {
                    [v15] = 1
                }, { 0.75 });
            end;
        end;

        Debris:AddItem(u9, 0.75);
    end);
end;

local function spawnFloatingMoney(p16, p17) -- Line: 134
    -- upvalues: MoneyChange (copy), Simple (copy), Frame (copy), animateNotification (copy)
    local v18 = p16 < 0;
    local v19 = MoneyChange:Clone();
    local Label = v19.Label;
    local UIScale = v19.UIScale;
    local UIStroke = Label.UIStroke;
    local More = Label.More;
    local Less = Label.Less;
    local Icon = v19.Icon;
    Label.TextTransparency = 1;
    UIStroke.Transparency = 1;
    UIScale.Scale = 0;
    Icon.ImageTransparency = 1;

    if More and More:IsA("UIGradient") then
        More.Enabled = not v18;
    end;

    if Less and Less:IsA("UIGradient") then
        Less.Enabled = v18;
    end;

    local FormatCompact = Simple.FormatCompact;
    local v20 = math.abs(p16);
    Label.Text = (v18 and "-" or "+") .. "$" .. FormatCompact(math.round(v20), ".#");
    Icon.Visible = false;
    v19.Parent = Frame;
    animateNotification(v19, Label, UIScale, UIStroke, {});
end;

local function displayMoneyChange(p21, p22, p23) -- Line: 158
    -- upvalues: playCashCollectSound (copy), spawnFloatingMoney (copy)
    if p21 == 0 then
        return;
    end;

    if p21 > 0 and p23 ~= false then
        playCashCollectSound();
    end;

    spawnFloatingMoney(p21, p22);
end;

local function updateMoneyLabels(p24) -- Line: 170
    -- upvalues: Asserts (copy), UpdateTextAndShadow (copy), Money2 (copy)
    Asserts.string(p24);
    UpdateTextAndShadow(Money2, p24);
end;

local function formatMoneyText(p25) -- Line: 175
    -- upvalues: Simple (copy), Commas (copy)
    if p25 > 99999 then
        return "$" .. Simple.FormatCompact(math.round(p25), ".#");
    end;

    return "$" .. Commas((math.round(p25)));
end;

local function cancelMoneyLabelTween() -- Line: 183
    -- upvalues: u4 (ref), u5 (ref)
    if u4 then
        u4:Cancel();
        u4 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;
end;

local function setMoneyLabelValue(p26) -- Line: 195
    -- upvalues: Simple (copy), Commas (copy), Asserts (copy), UpdateTextAndShadow (copy), Money2 (copy)
    local v27;

    if p26 > 99999 then
        v27 = "$" .. Simple.FormatCompact(math.round(p26), ".#");
    else
        v27 = "$" .. Commas((math.round(p26)));
    end;

    Asserts.string(v27);
    UpdateTextAndShadow(Money2, v27);
end;

local function tweenMoneyLabelValue(p28, u29) -- Line: 199
    -- upvalues: u4 (ref), u5 (ref), Simple (copy), Commas (copy), Asserts (copy), UpdateTextAndShadow (copy), Money2 (copy), setMoneyLabelValue (copy), Tween (copy)
    if u4 then
        u4:Cancel();
        u4 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = p28;
    u5 = NumberValue;
    local v30;

    if p28 > 99999 then
        v30 = "$" .. Simple.FormatCompact(math.round(p28), ".#");
    else
        v30 = "$" .. Commas((math.round(p28)));
    end;

    Asserts.string(v30);
    UpdateTextAndShadow(Money2, v30);
    NumberValue.Changed:Connect(setMoneyLabelValue);
    local u31 = Tween(NumberValue, {
        Value = u29
    }, { 0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
    u4 = u31;
    u31.Completed:Once(function(p32) -- Line: 216
        -- upvalues: u4 (ref), u31 (copy), u5 (ref), u29 (copy), Simple (ref), Commas (ref), Asserts (ref), UpdateTextAndShadow (ref), Money2 (ref), NumberValue (copy)
        if u4 ~= u31 then
            return;
        end;

        u4 = nil;
        u5 = nil;

        if p32 == Enum.PlaybackState.Completed then
            local v33 = u29;
            local v34;

            if v33 > 99999 then
                v34 = "$" .. Simple.FormatCompact(math.round(v33), ".#");
            else
                v34 = "$" .. Commas((math.round(v33)));
            end;

            Asserts.string(v34);
            UpdateTextAndShadow(Money2, v34);
        end;

        NumberValue:Destroy();
    end);
end;

local function updateMoney(p35) -- Line: 232
    -- upvalues: Save (copy), u1 (ref), u5 (ref), tweenMoneyLabelValue (copy), u4 (ref), Simple (copy), Commas (copy), Asserts (copy), UpdateTextAndShadow (copy), Money2 (copy), u6 (ref), playCashCollectSound (copy), spawnFloatingMoney (copy)
    local v36 = Save.Get();

    if not v36 then
        return;
    end;

    local Money3 = v36.Money;
    local v37;

    if p35 then
        v37 = p35.forceUpdate;
    else
        v37 = p35;
    end;

    if Money3 == u1 and not v37 then
        return;
    end;

    if not v37 and u1 < Money3 then
        local v38;

        if u5 then
            v38 = u5.Value;
        else
            v38 = u1;
        end;

        tweenMoneyLabelValue(v38, Money3);
    else
        if u4 then
            u4:Cancel();
            u4 = nil;
        end;

        if u5 then
            u5:Destroy();
            u5 = nil;
        end;

        local v39;

        if Money3 > 99999 then
            v39 = "$" .. Simple.FormatCompact(math.round(Money3), ".#");
        else
            v39 = "$" .. Commas((math.round(Money3)));
        end;

        Asserts.string(v39);
        UpdateTextAndShadow(Money2, v39);
    end;

    if not v37 then
        local v40 = Money3 - u1;

        if v40 > 0 and u6 > 0 then
            local v41 = math.min(v40, u6);
            v40 = v40 - v41;
            u6 = u6 - v41;
        end;

        if v40 ~= 0 and ((v40 <= 0 or (not p35 or p35.allowPositiveAnimation == nil or p35.allowPositiveAnimation)) and v40 ~= 0) then
            if v40 > 0 then
                playCashCollectSound();
            end;

            spawnFloatingMoney(v40, nil);
        end;
    end;

    u1 = Money3;
end;

updateMoney({
    forceUpdate = true
});
Save.StatChanged:Connect(function(p42) -- Line: 281
    -- upvalues: updateMoney (copy)
    if p42 == "Money" then
        updateMoney({
            allowPositiveAnimation = false
        });
    end;
end);
Network.Fired(MONEY_COLLECTED_EVENT):Connect(function(p43, p44) -- Line: 288
    -- upvalues: playCashCollectSound (copy), spawnFloatingMoney (copy), u6 (ref)
    if not p43 or p44 then
        return;
    end;

    local v45 = 0;
    local v46 = false;

    for _, v in ipairs(p43) do
        if v and typeof(v.amount) == "number" then
            v45 = v45 + math.max(v.amount, 0);
            local v47 = v.playSound ~= false and not v46;
            local amount = v.amount;
            local icon = v.icon;

            if amount ~= 0 then
                if amount > 0 and v47 ~= false then
                    playCashCollectSound();
                end;

                spawnFloatingMoney(amount, icon);
            end;

            if v.amount > 0 and v47 then
                v46 = true;
            end;
        end;
    end;

    if v45 > 0 then
        u6 = u6 + v45;
    end;
end);