-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Audio = require(ReplicatedStorage.Library.Audio);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Save = require(ReplicatedStorage.Library.Client.Save);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(ReplicatedStorage.Library.Types.Currency);
local ItemUtil = require(ReplicatedStorage.Library.Util.ItemUtil);
local v1 = Log.new();
local u2 = GUI.BuyMultiple();
local Contents = u2.Frame.Contents;
local Close = u2.Frame.Close;
local Buy1 = Contents.Buy1;
local BuyHalf = Contents.BuyHalf;
local BuyMax = Contents.BuyMax;
local Price1 = Contents.Price1;
local PriceHalf = Contents.PriceHalf;
local PriceMax = Contents.PriceMax;
local Desc = Contents.Desc;
local Icon = Contents.Icon;
local GreenGradient = ReplicatedStorage.Assets.UI.Gradients.GreenGradient;
local GreyGradient = ReplicatedStorage.Assets.UI.Gradients.GreyGradient;
local u3 = false;
local u4 = false;
local u5 = {};

local function swapGradient(p6, p7) -- Line: 47
    if not p6:FindFirstChild(p7.Name) then
        local v8 = p6:FindFirstChildOfClass("UIGradient");

        if v8 then
            v8:Destroy();
        end;

        p7:Clone().Parent = p6;
    end;
end;

local function getOwnedCurrencyAmount(p9) -- Line: 57
    -- upvalues: ItemUtil (copy), Save (copy)
    return ItemUtil:GetOwnedAmount(Save.Get() or {}, {
        Type = "Currency",
        Currency = p9
    });
end;

function u5.NewGeneric(p10, p11, p12, u13, u14) -- Line: 68
    -- upvalues: u4 (ref), TabController (copy), Buy1 (copy), BuyHalf (copy), BuyMax (copy), Price1 (copy), PriceHalf (copy), PriceMax (copy), Desc (copy), getOwnedCurrencyAmount (copy), GreenGradient (copy), GreyGradient (copy), Icon (copy), u2 (copy), Audio (copy), Trove (copy), GUI (copy), u3 (ref), Close (copy)
    if u4 or TabController.IsOpen("BuyMultiple") then
        return;
    end;

    u4 = true;

    if #p12 <= 1 then
        Buy1.Visible = true;
        BuyHalf.Visible = false;
        BuyMax.Visible = false;
        Price1.Visible = true;
        PriceHalf.Visible = false;
        PriceMax.Visible = false;
        Buy1.Size = UDim2.new(0.32, 0, 0.15, 25);
        Buy1.Position = UDim2.fromScale(0.5, 0.88);
        Price1.Position = UDim2.new(0.5, 0, 0.8, -10);
    elseif #p12 == 2 then
        Buy1.Visible = true;
        BuyHalf.Visible = true;
        BuyMax.Visible = false;
        Price1.Visible = true;
        PriceHalf.Visible = true;
        PriceMax.Visible = false;
        Buy1.Size = UDim2.new(0.48, 0, 0.15, 25);
        Buy1.Position = UDim2.fromScale(0.25, 0.88);
        Price1.Position = UDim2.new(0.25, 0, 0.8, -10);
        BuyHalf.Size = UDim2.new(0.48, 0, 0.15, 25);
        BuyHalf.Position = UDim2.fromScale(0.75, 0.88);
        PriceHalf.Position = UDim2.new(0.75, 0, 0.8, -10);
    else
        Buy1.Visible = true;
        BuyHalf.Visible = true;
        BuyMax.Visible = true;
        Price1.Visible = true;
        PriceHalf.Visible = true;
        PriceMax.Visible = true;
        Buy1.Size = UDim2.new(0.32, 0, 0.15, 25);
        Buy1.Position = UDim2.fromScale(0.175, 0.88);
        Price1.Position = UDim2.new(0.175, 0, 0.8, -10);
        BuyHalf.Size = UDim2.new(0.32, 0, 0.15, 25);
        BuyHalf.Position = UDim2.fromScale(0.5, 0.88);
        PriceHalf.Position = UDim2.new(0.5, 0, 0.8, -10);
        BuyMax.Size = UDim2.new(0.32, 0, 0.15, 25);
        BuyMax.Position = UDim2.fromScale(0.825, 0.88);
        PriceMax.Position = UDim2.new(0.825, 0, 0.8, -10);
    end;

    Desc.Text = p10;
    Buy1.TextLabel.Text = tostring(p12[1]);
    BuyHalf.TextLabel.Text = tostring(p12[2]);
    BuyMax.TextLabel.Text = tostring(p12[3]);

    if u13 and u14 then
        local v15 = getOwnedCurrencyAmount(u13);
        local v16 = Buy1;
        local v17 = (u14[1] or 0) <= v15 and GreenGradient or GreyGradient;

        if not v16:FindFirstChild(v17.Name) then
            local v18 = v16:FindFirstChildOfClass("UIGradient");

            if v18 then
                v18:Destroy();
            end;

            v17:Clone().Parent = v16;
        end;

        local v19 = BuyHalf;
        local v20 = (u14[2] or 0) <= v15 and GreenGradient or GreyGradient;

        if not v19:FindFirstChild(v20.Name) then
            local v21 = v19:FindFirstChildOfClass("UIGradient");

            if v21 then
                v21:Destroy();
            end;

            v20:Clone().Parent = v19;
        end;

        local v22 = BuyMax;
        local v23 = (u14[3] or 0) <= v15 and GreenGradient or GreyGradient;

        if not v22:FindFirstChild(v23.Name) then
            local v24 = v22:FindFirstChildOfClass("UIGradient");

            if v24 then
                v24:Destroy();
            end;

            v23:Clone().Parent = v22;
        end;

        Icon.Size = UDim2.fromScale(0.8, 0.3);
    else
        local v25 = Buy1;
        local v26 = GreenGradient;

        if not v25:FindFirstChild(v26.Name) then
            local v27 = v25:FindFirstChildOfClass("UIGradient");

            if v27 then
                v27:Destroy();
            end;

            v26:Clone().Parent = v25;
        end;

        local v28 = BuyHalf;
        local v29 = GreenGradient;

        if not v28:FindFirstChild(v29.Name) then
            local v30 = v28:FindFirstChildOfClass("UIGradient");

            if v30 then
                v30:Destroy();
            end;

            v29:Clone().Parent = v28;
        end;

        local v31 = BuyMax;
        local v32 = GreenGradient;

        if not v31:FindFirstChild(v32.Name) then
            local v33 = v31:FindFirstChildOfClass("UIGradient");

            if v33 then
                v33:Destroy();
            end;

            v32:Clone().Parent = v31;
        end;

        PriceHalf.Visible = false;
        PriceMax.Visible = false;
        Price1.Visible = false;
        Icon.Size = UDim2.fromScale(0.8, 0.42);
    end;

    u2.Frame.Contents.Icon.Image = p11;
    Audio.PlayQuestion();

    if TabController.OpenTab(u2.Name) then
        local u34 = Trove.new();

        local function connectActivated(p35, p36) -- Line: 156
            -- upvalues: GUI (ref), u34 (copy)
            local v37 = GUI.ButtonActivated(p35, p36);
            u34:Add(v37.Default);
            u34:Add(v37.Signal);
        end;

        local u38 = nil;
        u3 = true;
        local v39 = GUI.ButtonActivated(Close, function() -- Line: 165, Name: onClose
            -- upvalues: u3 (ref), u38 (ref), TabController (ref)
            if u3 then
                u38 = nil;
                u3 = false;
                TabController.CloseTab();
            end;
        end);
        u34:Add(v39.Default);
        u34:Add(v39.Signal);
        local v40 = GUI.ButtonActivated(Buy1, function() -- Line: 174, Name: onBuy1
            -- upvalues: u13 (copy), u14 (copy), getOwnedCurrencyAmount (ref), u3 (ref), u38 (ref), TabController (ref)
            if u13 and (u14 and getOwnedCurrencyAmount(u13) < (u14[1] or 0)) then
                return;
            end;

            if u3 then
                u38 = 1;
                u3 = false;
                TabController.CloseTab();
            end;
        end);
        u34:Add(v40.Default);
        u34:Add(v40.Signal);
        local v41 = GUI.ButtonActivated(BuyHalf, function() -- Line: 185, Name: onBuyHalf
            -- upvalues: u13 (copy), u14 (copy), getOwnedCurrencyAmount (ref), u3 (ref), u38 (ref), TabController (ref)
            if u13 and (u14 and getOwnedCurrencyAmount(u13) < (u14[2] or 0)) then
                return;
            end;

            if u3 then
                u38 = 2;
                u3 = false;
                TabController.CloseTab();
            end;
        end);
        u34:Add(v41.Default);
        u34:Add(v41.Signal);
        local v42 = GUI.ButtonActivated(BuyMax, function() -- Line: 196, Name: onBuyMax
            -- upvalues: u13 (copy), u14 (copy), getOwnedCurrencyAmount (ref), u3 (ref), u38 (ref), TabController (ref)
            if u13 and (u14 and getOwnedCurrencyAmount(u13) < (u14[3] or 0)) then
                return;
            end;

            if u3 then
                u38 = 3;
                u3 = false;
                TabController.CloseTab();
            end;
        end);
        u34:Add(v42.Default);
        u34:Add(v42.Signal);

        while u3 do
            task.wait();
        end;

        u34:Destroy();

        return u38;
    end;

    u4 = false;
end;

function u5.New(p43, p44, p45, p46, p47) -- Line: 219
    -- upvalues: u5 (copy)
    local v48 = {};

    if p46 > 0 and not table.find(v48, 1) then
        table.insert(v48, 1);
    end;

    local v49 = math.ceil(p46 / 2);

    if v49 > 0 and not table.find(v48, v49) then
        table.insert(v48, v49);
    end;

    if p46 > 0 and not table.find(v48, p46) then
        table.insert(v48, p46);
    end;

    local v50 = {};
    local v51 = {};

    for _, v in ipairs(v48) do
        if #v48 == 1 and v == 1 then
            table.insert(v50, "Buy");
        else
            local v52 = ("Buy %d"):format(v);
            table.insert(v50, v52);
        end;

        table.insert(v51, v * p47);
    end;

    local v53 = u5.NewGeneric(p43, p44, v50, p45, v51);

    if v53 then
        return v48[v53];
    end;

    return nil;
end;

TabController.AddCloseListener(function(p54) -- Line: 269
    -- upvalues: u3 (ref), u4 (ref)
    if p54 == "BuyMultiple" then
        u3 = false;
        u4 = false;
    end;
end);
ButtonFX(Buy1);
ButtonFX(BuyHalf);
ButtonFX(BuyMax);
ButtonFX(Close);
v1:AtInfo():Log("Buy multiple UI initialized");

return u5;