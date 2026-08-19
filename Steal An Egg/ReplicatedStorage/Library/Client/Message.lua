-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Audio = require(ReplicatedStorage.Library.Audio);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local CircularBar = require(ReplicatedStorage.Library.Client.GUIFX.CircularBar);
local ItemUI = require(ReplicatedStorage.Library.Client.UI.ItemUI);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Functions = require(ReplicatedStorage.Library.Functions);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Variables = require(ReplicatedStorage.Library.Variables);
local v1 = Log.new();
local Backpack = Constants.NETWORK_MAP.Backpack;
local GreenGradient = ReplicatedStorage.Assets.UI.Gradients.GreenGradient;
local GreyGradient = ReplicatedStorage.Assets.UI.Gradients.GreyGradient;
local u2 = GUI.Message();
local Contents = u2.Frame.Contents;
local Close = u2.Frame.Close;
local No = Contents.No;
local Yes = Contents.Yes;
local CircularBar2 = Yes.CircularBar;
local Ok = Contents.Ok;
local Option1 = Contents.Option1;
local Option2 = Contents.Option2;
local Desc = Contents.Desc;
local CustomDesc = Contents.CustomDesc;
local CustomHolder = Contents.CustomHolder;
local Title = u2.Frame.Top.Title;
local CustomIcon = Contents.CustomIcon;
local CurrencyCoins = Contents.CurrencyCoins;
local u3 = false;
local u4 = false;
local u5 = {};
Desc.RichText = true;
CustomDesc.RichText = true;

function u5.New(p6, p7, p8, p9) -- Line: 103
    -- upvalues: Save (copy), u3 (ref), TabController (copy), Variables (copy), Audio (copy), Close (copy), Yes (copy), No (copy), Ok (copy), Option1 (copy), Option2 (copy), CustomHolder (copy), CustomIcon (copy), CustomDesc (copy), Desc (copy), CurrencyCoins (copy), Title (copy), Functions (copy), ItemUI (copy), Trove (copy), Signal (copy), GUI (copy), u2 (copy), CircularBar2 (copy), GreenGradient (copy), GreyGradient (copy), u4 (ref), CircularBar (copy)
    if not Save.Get() or (u3 or TabController.IsOpen("Message")) then
        return;
    end;

    u3 = true;
    local v10 = p7 == nil and true or type(p7) == "table";
    local u11 = p7 == true;
    local v12 = type(p7) == "string";
    local u13 = v10 and p7 and p7 or (u11 and p8 and p8 or (v12 and p9 and p9 or {}));
    local v14 = u13.title ~= nil and true or u13.err == true;
    local v15 = u13.icon ~= nil and true or u13.err == true;
    local v16 = u13.item ~= nil and true or u13.items ~= nil;
    local u17 = u13.timedLock ~= nil;
    local timedLock = u13.timedLock;
    local v18 = u13.err == true and "Oops!" or (u13.title or "");
    local v19 = u13.err and not u13.icon and "" or (u13.icon or "");
    local v20 = u13.iconColor or Color3.fromRGB(255, 255, 255);
    local v21;

    if u13.reopen then
        v21 = u13.reopen() or nil;
    else
        v21 = nil;
    end;

    local currencyData = u13.currencyData;
    local sound = u13.sound;
    local soundVolume = u13.soundVolume;
    local closeOnSuccess = u13.closeOnSuccess;
    local tradeAllowed = u13.tradeAllowed;
    local dontRestore = u13.dontRestore;
    local u22 = tick();
    local v23 = nil;
    local v24;

    if u13.items then
        v24 = u13.items;
    else
        v24 = u13.item and { u13.item } or v23;
    end;

    if u17 and not u11 then
        error("timedLock can only be used on yes/no messages");
    end;

    if Variables.Trading and not tradeAllowed then
        u3 = false;

        return;
    end;

    if not sound then
        if v10 then
            Audio.PlayStatement();
        else
            Audio.PlayQuestion();
        end;
    end;

    if sound then
        Audio.Play(sound, script, 1, soundVolume or 1);
    end;

    Close.Visible = v10 or u11;
    Yes.Visible = u11;
    No.Visible = u11;
    Ok.Visible = v10;
    Option1.Visible = v12;
    Option2.Visible = v12;
    CustomHolder.Visible = v16;
    CustomIcon.Visible = v15;
    CustomDesc.Visible = v15 or (currencyData or v16);
    Desc.Visible = not v15 and (not currencyData and not v16);
    CurrencyCoins.Visible = currencyData;
    CustomIcon.ImageColor3 = v20;
    CustomIcon.Image = v15 and v19 and v19 or "";
    Desc.Text = p6;
    CustomDesc.Text = p6;
    Title.Text = v14 and v18 and v18 or "Hey!";
    local v25 = {};

    if v16 and v24 then
        CustomHolder.ClipsDescendants = #v24 > 3;
        Functions.CleanupGuiChildren(CustomHolder);

        for _, v in ipairs(v24) do
            local v26 = ItemUI.Create(v, {
                NoButtonFX = true,
                NoActionMenu = true,
                ShowCurrencyBag = true,
                HideQuantity = (u13.quantityOverride or v:GetAmount()) == 1,
                QuantityOverride = u13.quantityOverride
            });
            Instance.new("UIAspectRatioConstraint").Parent = v26;
            v26.Parent = CustomHolder;
            table.insert(v25, v26);
        end;

        if #v25 > 3 then
            CustomHolder.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
        else
            CustomHolder.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        end;

        Functions.AutomaticCanvasSize(CustomHolder);
    end;

    local v27 = TabController.Get();

    if TabController.OpenTab("Message", nil, nil, Variables.Trading and tradeAllowed == true) then
        local u28 = nil;
        local u29 = true;
        local u30 = false;
        local u31 = Trove.new();
        local u32 = u31:Add(Signal.new());

        local function complete(p33, p34) -- Line: 233
            -- upvalues: u29 (ref), u28 (ref), u30 (ref), u32 (copy)
            if not u29 then
                return;
            end;

            u28 = p33;
            u30 = p34;
            u29 = false;
            u32:Fire();
        end;

        local function connectActivated(p35, p36) -- Line: 242
            -- upvalues: GUI (ref), u31 (copy)
            local v37 = GUI.ButtonActivated(p35, p36);
            u31:Add(v37.Default);
            u31:Add(v37.Signal);
        end;

        local v39 = GUI.ButtonActivated(Close, function() -- Line: 248
            -- upvalues: u11 (copy), u29 (ref), u28 (ref), u30 (ref), u32 (copy)
            local v38;

            if u11 then
                v38 = false;
            else
                v38 = nil;
            end;

            if not u29 then
                return;
            end;

            u28 = v38;
            u30 = false;
            u29 = false;
            u32:Fire();
        end);
        u31:Add(v39.Default);
        u31:Add(v39.Signal);
        u31:Add(u2.Changed:Connect(function(p40) -- Line: 251
            -- upvalues: u2 (ref), u11 (copy), u29 (ref), u28 (ref), u30 (ref), u32 (copy)
            if p40 == "Enabled" and not u2.Enabled then
                local v41;

                if u11 then
                    v41 = false;
                else
                    v41 = nil;
                end;

                if not u29 then
                    return;
                end;

                u28 = v41;
                u30 = false;
                u29 = false;
                u32:Fire();
            end;
        end));
        local v42 = GUI.ButtonActivated(Ok, function() -- Line: 256
            -- upvalues: u13 (copy), u29 (ref), u28 (ref), u30 (ref), u32 (copy)
            if not u29 then
                return;
            end;

            u28 = u13.confirmOnOk == true and true or nil;
            u30 = true;
            u29 = false;
            u32:Fire();
        end);
        u31:Add(v42.Default);
        u31:Add(v42.Signal);
        local v43 = GUI.ButtonActivated(Yes, function() -- Line: 259
            -- upvalues: u17 (copy), timedLock (copy), u22 (copy), u29 (ref), u28 (ref), u30 (ref), u32 (copy)
            if not u17 or timedLock < tick() - u22 then
                if not u29 then
                    return;
                end;

                u28 = true;
                u30 = true;
                u29 = false;
                u32:Fire();
            end;
        end);
        u31:Add(v43.Default);
        u31:Add(v43.Signal);
        local v44 = GUI.ButtonActivated(No, function() -- Line: 264
            -- upvalues: u29 (ref), u28 (ref), u30 (ref), u32 (copy)
            if not u29 then
                return;
            end;

            u28 = false;
            u30 = false;
            u29 = false;
            u32:Fire();
        end);
        u31:Add(v44.Default);
        u31:Add(v44.Signal);
        local v45 = GUI.ButtonActivated(Option1, function() -- Line: 267
            -- upvalues: u29 (ref), u28 (ref), u30 (ref), u32 (copy)
            if not u29 then
                return;
            end;

            u28 = 1;
            u30 = false;
            u29 = false;
            u32:Fire();
        end);
        u31:Add(v45.Default);
        u31:Add(v45.Signal);
        local v46 = GUI.ButtonActivated(Option2, function() -- Line: 270
            -- upvalues: u29 (ref), u28 (ref), u30 (ref), u32 (copy)
            if not u29 then
                return;
            end;

            u28 = 2;
            u30 = false;
            u29 = false;
            u32:Fire();
        end);
        u31:Add(v46.Default);
        u31:Add(v46.Signal);

        if u17 then
            Functions.GradientSwap(Yes, GreyGradient);
            task.spawn(function() -- Line: 278
                -- upvalues: u4 (ref), CircularBar (ref), CircularBar2 (ref), u29 (ref), u22 (copy), timedLock (copy), u17 (copy), Functions (ref), Yes (ref), GreenGradient (ref)
                if not u4 then
                    CircularBar(CircularBar2);
                    u4 = true;
                end;

                CircularBar2.Visible = true;

                while u29 do
                    local v47 = tick() - u22;
                    CircularBar2:SetAttribute("Progress", 1 - math.clamp(v47, 0, timedLock) / timedLock);

                    if u17 and timedLock < tick() - u22 then
                        break;
                    end;

                    task.wait();
                end;

                CircularBar2.Visible = false;
                Functions.GradientSwap(Yes, GreenGradient);
            end);
        else
            CircularBar2.Visible = false;
            Functions.GradientSwap(Yes, GreenGradient);
        end;

        u32:Wait();
        u31:Destroy();

        for _, v in ipairs(v25) do
            v:Destroy();
        end;

        if v27 and not dontRestore then
            if u30 and closeOnSuccess then
                TabController.CloseTab();
            else
                TabController.OpenTab(v27, true);
            end;
        elseif v21 then
            TabController.OpenTab(v21, true);
        else
            TabController.CloseTab();
        end;

        u3 = false;

        return u28;
    end;

    u3 = false;
end;

function u5.StandardError() -- Line: 331
    -- upvalues: u5 (copy)
    return u5.New("Something went wrong.", {
        title = "Oops!",
        err = true
    });
end;

function u5.StandardSuccess() -- Line: 342
    -- upvalues: u5 (copy)
    return u5.New("Success!");
end;

function u5.Error(p48) -- Line: 351
    -- upvalues: u5 (copy)
    if p48 then
        return u5.New(p48, {
            err = true
        });
    end;

    return u5.StandardError();
end;

ButtonFX(Ok);
ButtonFX(Yes);
ButtonFX(No);
ButtonFX(Option1);
ButtonFX(Option2);
ButtonFX(Close);
Network.Fired("Message"):Connect(function(...) -- Line: 372
    -- upvalues: u5 (copy)
    u5.New(...);
end);

Network.Invoked(Backpack.PROMPT_FULL_INVENTORY_SELL).OnInvoke = function(p49) -- Line: 376
    -- upvalues: u5 (copy)
    return u5.New(p49, true) == true;
end;

v1:AtInfo():Log("Message UI initialized");

return u5;