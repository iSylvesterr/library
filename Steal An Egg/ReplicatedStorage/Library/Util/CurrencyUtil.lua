-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Currency = require(Library.Directory.Currency);
local Functions = require(Library.Functions);
local Signal = require(Library.Signal);
local Variables = require(Library.Variables);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BigNum = require(Modules.BigNum);
local u1 = BigNum.new(1000000);
local t = require(Modules.Packages.t);
local u2 = {};
local u3 = t.union(t.string, t.map(t.string, t.number));

function u2.SetupPriceFrame(p4, p5, p6, p7) -- Line: 24
    -- upvalues: Asserts (copy), u3 (copy), Assets (copy), u2 (copy), Functions (copy), Variables (copy)
    Asserts.Instance(p4);
    assert(u3(p5));
    local v8 = nil;

    for _, child in ipairs(p4:GetChildren()) do
        if not (child:IsA("UIListLayout") or child:IsA("UIPadding")) then
            if child:IsA("Frame") then
                v8 = child:Clone();
            end;

            child:Destroy();
        end;
    end;

    local v9 = v8 or Assets.UI.Currency.PriceFrameSub:Clone();

    if type(p5) == "string" then
        Asserts.number(p6);
        p5 = {
            [p5] = p6
        };
    end;

    local v10 = {};

    for i, v in pairs(p5) do
        local v11 = u2.NumberToTiers(i, v, p7 or 2);
        local v12 = Functions.DictionaryLength(v11);

        for i2, v2 in pairs(v11) do
            local v13 = v9:Clone();
            local imageOutlineTextOverride = i2.imageOutlineTextOverride;

            if imageOutlineTextOverride then
                v13.Icon.Visible = false;
            else
                v13.Icon.Image = i2.imageOutline;
            end;

            local v14 = v2 == 0 and "FREE!" or Functions.NumberShorten(v2);

            if imageOutlineTextOverride then
                v13.Amount.Text = string.format(imageOutlineTextOverride, v14);
            else
                v13.Amount.Text = v14;
            end;

            v13.Amount.TextColor3 = i2.textColor;
            v13.Name = i;
            v13.Visible = true;
            v13.LayoutOrder = v12 - i2.Order;
            v13.Parent = p4;
            table.insert(v10, v13);
        end;
    end;

    local v15 = Variables.Mobile and p4:FindFirstChildOfClass("UIListLayout");

    if v15 then
        v15.Padding = UDim.new(0, 2);
    end;

    return p4, v10;
end;

function u2.GetTierInfo(p16, p17, p18) -- Line: 92
    -- upvalues: Currency (copy)
    local v19 = Currency[p16];
    local v20 = nil;

    for i, v in ipairs(v19.Tiers) do
        local v21 = i < #v19.Tiers;

        if v21 and (v.value <= p17 and p17 < v19.Tiers[i + 1].value) or not v21 then
            v20 = v;
            break;
        end;
    end;

    local v22 = v20 or v19.Tiers[1];
    local v23 = v22.value > 0 and (v22.value or 1) or 1;
    local v24;

    if p18 == nil and true or p18 then
        local format = string.format;
        local v25 = math.floor(p17 / v23);
        v24 = tonumber(format("%.2f", v25));
    else
        v24 = tonumber(string.format("%.2f", p17 / v23));
    end;

    return v22, v24;
end;

function u2.NumberToTiers(p26, p27, p28) -- Line: 125
    -- upvalues: Currency (copy), BigNum (copy), u1 (copy)
    local v29 = Currency[p26];
    local Tiers = v29.Tiers;
    local v30 = #Tiers;

    if v30 == 1 or p27 == 0 then
        return {
            [Tiers[1]] = p27
        };
    end;

    if v29 == Currency.Coins then
        local v31 = BigNum.new((math.round(p27)));
        local v32 = {};

        for i, v in ipairs(Tiers) do
            local v33;

            if i == v30 then
                v33 = v31;
            else
                v31, v33 = BigNum.__div(v31, u1);
            end;

            local v34 = tostring(v33);
            local v35 = tonumber(v34);
            local v36 = assert(v35);

            if v36 > 0 then
                v32[v] = v36;
            end;
        end;

        local v37;

        if p28 then
            v37 = {};
            local v38 = 0;

            for i = #Tiers, 1, -1 do
                local v39 = Tiers[i];
                local v40 = v32[v39];

                if v40 then
                    v37[v39] = v40;
                    v38 = v38 + 1;

                    if v38 >= p28 then
                        break;
                    end;
                end;
            end;
        else
            v37 = v32;
        end;

        return v37;
    end;

    local v41 = BigNum.new(p27);
    local v42 = {};
    local v43 = 0;

    for i = #Tiers, 1, -1 do
        local v44 = Tiers[i];
        local v45 = v44.valueBig or BigNum.new(v44.value);
        v44.valueBig = v45;
        local v46 = v41 / v45;
        local v47 = tostring(v46);
        local v48 = tonumber(v47);
        local v49 = assert(v48);

        if v49 > 0 then
            v42[v44] = v49;
            v43 = v43 + 1;

            if p28 and v43 >= p28 then
                break;
            end;
        end;

        v41 = v41 - v46 * v45;
    end;

    return v42;
end;

function u2.GetTierFromName(p50, p51) -- Line: 193
    -- upvalues: Currency (copy)
    for _, v in ipairs(Currency[p50].Tiers) do
        if v.tierName == p51 then
            return v;
        end;
    end;

    return nil;
end;

function u2.RainFromItem(p52, p53, p54) -- Line: 203
    -- upvalues: u2 (copy)
    local v55 = u2.NumberToTiers(p53:GetId(), p53:GetAmount(), p54 or 2);
    local v56 = {};

    for i, _ in pairs(v55) do
        table.insert(v56, i.tierName);
    end;

    u2.Rain(p52, unpack(v56));
end;

function u2.Rain(p57, ...) -- Line: 213
    -- upvalues: Currency (copy), RunService (copy), Signal (copy)
    local v58 = { ... };
    local v59 = {};

    for _, v in pairs(Currency) do
        for _, v2 in ipairs(v.Tiers) do
            if table.find(v58, v2.tierName) then
                local v60 = {
                    Texture = v2.imageOutline
                };
                v60.LightEmission = v2.rainData and v2.rainData.LightEmission;
                v60.SizeScalar = v2.rainData and v2.rainData.SizeScalar;
                table.insert(v59, v60);
            end;
        end;
    end;

    if #v59 == 0 then
        return;
    end;

    if RunService:IsClient() then
        Signal.Fire("Currency_Rain", v59);

        return;
    end;

    local ServerScriptService = game:GetService("ServerScriptService");
    local Network = require(ServerScriptService.Library.Services.Network);
    assert(p57, "Player not found");
    Network.Fire("Currency_Rain", p57, v59);
end;

return u2;