-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Network = require(ReplicatedStorage.Library.Client.Network);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Products = require(ReplicatedStorage.Directory.Products);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local ServerLuck = require(ReplicatedStorage.Library.Types.ServerLuck);
local ServerLuck2 = require(ReplicatedStorage.Library.Globals.Constants).NETWORK_MAP.ServerLuck;
local FormatDuration = require(ReplicatedStorage.Library.Functions.FormatDuration);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GetPrice = require(ReplicatedStorage.Library.Functions.GetPrice);

if Constants.IS_STUDIO then
    assert(Products.Directory.ServerLuck_X2, "ServerLuck_X2 product not found in Products directory");
    assert(Products.Directory.ServerLuck_X4, "ServerLuck_X4 product not found in Products directory");
    assert(Products.Directory.ServerLuck_X8, "ServerLuck_X8 product not found in Products directory");
end;

local u1 = GUI.ServerLuck();
local ExpiresIn = u1:WaitForChild("ExpiresIn");
local BuyButton = u1:WaitForChild("BuyButton");
local Price = BuyButton:WaitForChild("Price");
local Available = u1:WaitForChild("Available");
local u2 = Available:WaitForChild("1");
local u3 = Available:WaitForChild("2");
local ButtonsWithExtension = u1:WaitForChild("ButtonsWithExtension");
local List = ButtonsWithExtension:WaitForChild("List");
local u4 = List:WaitForChild("15Min");
local u5 = List:WaitForChild("30Min");
local u6 = {
    Multiplier = 1
};

local function getNextMultiplier(p7) -- Line: 43
    return p7 < 2 and 2 or (p7 < 4 and 4 or 8);
end;

local function updateLuckTimer(p8) -- Line: 53
    -- upvalues: FormatDuration (copy), ExpiresIn (copy)
    ExpiresIn.Text = p8 <= 0 and "<font color=\"rgb(255, 0, 0)\">15 mins</font>" or `<stroke color="rgb(0,0,0)" joins="round" thickness="2"><font color="rgb(255, 0, 0)">{FormatDuration(p8)}</font></stroke>`;
end;

local function updateUI() -- Line: 65
    -- upvalues: u6 (ref), FormatDuration (copy), ExpiresIn (copy), u1 (copy), ButtonsWithExtension (copy), u2 (copy), u3 (copy), Products (copy), GetPrice (copy), Price (copy), u4 (copy), u5 (copy)
    local v9;

    if u6.ExpiresAt then
        local v10 = u6.ExpiresAt - workspace:GetServerTimeNow();
        v9 = math.max(0, v10);
    else
        v9 = 0;
    end;

    ExpiresIn.Text = v9 <= 0 and "<font color=\"rgb(255, 0, 0)\">15 mins</font>" or `<stroke color="rgb(0,0,0)" joins="round" thickness="2"><font color="rgb(255, 0, 0)">{FormatDuration(v9)}</font></stroke>`;
    u1.Available.Visible = u6.Multiplier ~= 8;
    u1.MaxedOut.Visible = u6.Multiplier == 8;
    ButtonsWithExtension.Visible = u6.Multiplier > 1;

    if u6.Multiplier < 8 then
        local Multiplier = u6.Multiplier;
        local v11 = Multiplier < 2 and 2 or (Multiplier < 4 and 4 or 8);
        u2.Text = `<stroke color="rgb(0,0,0)" joins="round" thickness="2">{u6.Multiplier}<font color="rgb(56, 232, 57)"></font></stroke>x`;
        u3.Text = `<stroke color="rgb(0,0,0)" joins="round" thickness="2"><font color="rgb(56, 232, 57)">{v11}</font></stroke>x`;
        local v12 = Products.Directory[`ServerLuck_X{v11}`];

        if v12 then
            Price.Text = `{GetPrice(v12.ProductId, true)}`;
        end;

        if ButtonsWithExtension.Visible then
            local ServerLuck_Extend15 = Products.Directory.ServerLuck_Extend15;

            if ServerLuck_Extend15 then
                u4.Text = `{GetPrice(ServerLuck_Extend15.ProductId, true)}`;
            end;

            local ServerLuck_Extend30 = Products.Directory.ServerLuck_Extend30;

            if ServerLuck_Extend30 then
                u5.Text = `{GetPrice(ServerLuck_Extend30.ProductId, true)}`;
            end;
        end;
    else
        Price.Text = "Maxed";
    end;
end;

ButtonFX(BuyButton, nil, function() -- Line: 105
    -- upvalues: u6 (ref), Products (copy), PromptPurchase (copy)
    if u6.Multiplier < 8 then
        local Multiplier = u6.Multiplier;
        local v13 = Products.Directory[`ServerLuck_X{Multiplier < 2 and 2 or (Multiplier < 4 and 4 or 8)}`];

        if v13 then
            PromptPurchase.Prompt(v13.ProductId, true);
        end;
    end;
end);
ButtonFX(u4, nil, function() -- Line: 115
    -- upvalues: u6 (ref), Products (copy), PromptPurchase (copy)
    local v14 = u6.Multiplier > 1 and Products.Directory.ServerLuck_Extend15;

    if v14 then
        PromptPurchase.Prompt(v14.ProductId, true);
    end;
end);
ButtonFX(u5, nil, function() -- Line: 124
    -- upvalues: u6 (ref), Products (copy), PromptPurchase (copy)
    local v15 = u6.Multiplier > 1 and Products.Directory.ServerLuck_Extend30;

    if v15 then
        PromptPurchase.Prompt(v15.ProductId, true);
    end;
end);
Network.Fired(ServerLuck2.STATE_UPDATED):Connect(function(p16) -- Line: 133
    -- upvalues: ServerLuck (copy), u6 (ref), updateUI (copy)
    if ServerLuck.State(p16) then
        u6 = p16;
        updateUI();
    end;
end);
local success, result = pcall(function() -- Line: 140
    -- upvalues: Network (copy), ServerLuck2 (copy)
    return Network.Invoke(ServerLuck2.GET_STATE);
end);

if success and (type(result) == "table" and ServerLuck.State(result)) then
    u6 = result;
    updateUI();
end;

RunService.Heartbeat:Connect(function() -- Line: 148
    -- upvalues: u6 (ref), updateUI (copy)
    if u6.ExpiresAt then
        updateUI();
    end;
end);