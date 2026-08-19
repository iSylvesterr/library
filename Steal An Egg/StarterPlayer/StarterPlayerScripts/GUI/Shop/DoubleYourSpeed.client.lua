-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Audio = require(ReplicatedStorage.Library.Audio);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Flash = require(ReplicatedStorage.Library.Client.GUIFX.Flash);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
require(ReplicatedStorage.Library.Types.GUI);
local GetPrice = require(ReplicatedStorage.Library.Functions.GetPrice);
local Products = require(ReplicatedStorage.Directory.Products);
require(ReplicatedStorage.Directory.Products.Types.Interface);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Save = require(ReplicatedStorage.Library.Client.Save);
local ScreenResolution = require(ReplicatedStorage.Library.Client.ScreenResolution);
local Shake = require(ReplicatedStorage.Library.Client.Shake);
local Shockwave = require(ReplicatedStorage.Library.Client.GUIFX.Shockwave);
local Sparkles = require(ReplicatedStorage.Library.Client.GUIFX.Sparkles);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {
    Products.Directory.SpeedBoostTier1,
    Products.Directory.SpeedBoostTier2,
    Products.Directory.SpeedBoostTier3,
    Products.Directory.SpeedBoostTier4,
    Products.Directory.SpeedBoostTier5,
    Products.Directory.SpeedBoostTier6,
    Products.Directory.SpeedBoostTier7,
    Products.Directory.SpeedBoostTier8,
    Products.Directory.SpeedBoostTier9,
    Products.Directory.SpeedBoostTier10,
    Products.Directory.SpeedBoostTier11,
    Products.Directory.SpeedBoostTier12
};
local u2 = `ONLY ?{Constants.ROBUX_ICON_STR}`;
local v3 = GUI.Shop();
local v4 = GUI.TreadmillSpeedShop();
local Pack = v3.Frame.Main.ScrollingFrame.DoubleYourSpeed.Pack;
local Pack2 = v4.Frame.Main.ScrollingFrame.DoubleYourSpeed.Pack;
local Button = GUI.SideButtonTools().DoubleYourSpeed.Button;
local Multiplier = Button.Multiplier;
local Text = Button.PriceTag.Text;
local u5 = {
    {
        HasRendered = false,
        LastRenderedSpeedBoostTierIndex = 0,
        Buy = Pack.Buy,
        End = Pack.Multiplier.End,
        Max = Pack.Max,
        Multiplier = Pack.Multiplier,
        Root = v3,
        Start = Pack.Multiplier.Start
    },
    {
        HasRendered = false,
        AlwaysAnimate = true,
        LastRenderedSpeedBoostTierIndex = 0,
        Buy = Pack2.Buy,
        End = Pack2.Multiplier.End,
        Max = Pack2.Max,
        Multiplier = Pack2.Multiplier,
        Root = v4,
        Start = Pack2.Multiplier.Start
    }
};
local u6 = 0;

local function resolveOwnedSpeedBoostTierIndex() -- Line: 107
    -- upvalues: TreadmillUtil (copy), Save (copy)
    return TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get());
end;

local function resolveNextSpeedBoostProduct() -- Line: 111
    -- upvalues: u1 (copy), TreadmillUtil (copy), Save (copy)
    return u1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) + 1];
end;

local function resolveSpeedBoostMultiplierForTierIndex(p7) -- Line: 115
    -- upvalues: u1 (copy)
    local v8 = u1[p7];

    return v8 == nil and 1 or v8.SpeedBoostMultiplier;
end;

local function resolveCurrentAndNextSpeedBoostMultipliers() -- Line: 120
    -- upvalues: TreadmillUtil (copy), Save (copy), u1 (copy)
    local v9 = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get());
    local v10 = u1[v9];
    local v11 = v10 == nil and 1 or v10.SpeedBoostMultiplier;
    local v12 = u1[v9 + 1];
    local v13;

    if v12 == nil then
        v13 = v11;
    else
        v13 = v12.SpeedBoostMultiplier;
    end;

    return v11, v13, v12 == nil;
end;

local function formatSpeedBoostMultiplier(p14) -- Line: 129
    -- upvalues: Asserts (copy), Simple (copy)
    Asserts.number(p14);

    return `x{Simple.FormatCompact(p14, ".#")}`;
end;

local function updateProductPrice(u15, p16) -- Line: 134
    -- upvalues: GetPrice (copy), Constants (copy)
    u15.Visible = true;

    if p16 == nil then
        u15.Text = "MAX";
        u15.Visible = false;

        return;
    end;

    local ProductId = p16.ProductId;

    if ProductId > 0 then
        task.spawn(function() -- Line: 149
            -- upvalues: GetPrice (ref), ProductId (copy), u15 (copy), Constants (ref)
            local v17, v18 = GetPrice(ProductId, true);
            u15.Text = `{Constants.ROBUX_ICON_STR}{not v18 and "???" or tostring(v17)}`;
        end);

        return;
    end;

    u15.Text = "???";
    u15.Visible = false;
end;

local function updateSideButtonPrice(p19) -- Line: 155
    -- upvalues: u6 (ref), Text (copy), u2 (copy), GetPrice (copy), Constants (copy)
    u6 = u6 + 1;
    local u20 = u6;

    if p19 == nil then
        Text.Text = "MAX";

        return;
    end;

    Text.Text = u2;
    local ProductId = p19.ProductId;
    task.spawn(function() -- Line: 165
        -- upvalues: GetPrice (ref), ProductId (copy), u20 (copy), u6 (ref), Text (ref), Constants (ref), u2 (ref)
        local v21, v22 = GetPrice(ProductId, true);

        if u20 ~= u6 then
            return;
        end;

        local v23;

        if v22 then
            v23 = `ONLY {v21}{Constants.ROBUX_ICON_STR}`;
        else
            v23 = u2;
        end;

        Text.Text = v23;
    end);
end;

local function updateDoubleYourSpeedTool() -- Line: 177
    -- upvalues: u1 (copy), TreadmillUtil (copy), Save (copy), Button (copy), Text (copy), Multiplier (copy), u6 (ref), u2 (copy), GetPrice (copy), Constants (copy)
    local v24 = u1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) + 1];
    local v25 = v24 ~= nil;
    Button.Interactable = v25;
    Text.Visible = v25;

    if v24 == nil then
        Multiplier.Text = "MAX";
        u6 = u6 + 1;
        Text.Text = "MAX";

        return;
    end;

    Multiplier.Text = TreadmillUtil.FormatSpeedMultiplier(v24.SpeedBoostMultiplier);
    u6 = u6 + 1;
    local u26 = u6;

    if v24 == nil then
        Text.Text = "MAX";

        return;
    end;

    Text.Text = u2;
    local ProductId = v24.ProductId;
    task.spawn(function() -- Line: 165
        -- upvalues: GetPrice (ref), ProductId (copy), u26 (copy), u6 (ref), Text (ref), Constants (ref), u2 (ref)
        local v27, v28 = GetPrice(ProductId, true);

        if u26 ~= u6 then
            return;
        end;

        local v29;

        if v28 then
            v29 = `ONLY {v27}{Constants.ROBUX_ICON_STR}`;
        else
            v29 = u2;
        end;

        Text.Text = v29;
    end);
end;

local function updateDoubleYourSpeedText(p30, p31, p32) -- Line: 192
    -- upvalues: Asserts (copy), Simple (copy)
    local Start = p30.Start;
    Asserts.number(p31);
    Start.Text = `x{Simple.FormatCompact(p31, ".#")}`;
    local End = p30.End;
    Asserts.number(p32);
    End.Text = `x{Simple.FormatCompact(p32, ".#")}`;
    local Max = p30.Max;
    Asserts.number(p31);
    Max.Text = `{`x{Simple.FormatCompact(p31, ".#")}`} MAX`;
end;

local function updateDoubleYourSpeedVisibility(p33, p34) -- Line: 198
    p33.Multiplier.Visible = not p34;
    p33.Max.Visible = p34;
    p33.Buy.Visible = not p34;
    p33.Buy.Interactable = not p34;
end;

local function playDoubleYourSpeedAnimation(u35, u36, u37) -- Line: 205
    -- upvalues: ScreenResolution (copy), Audio (copy), Tween (copy), Asserts (copy), Simple (copy), Shake (copy), Flash (copy), Shockwave (copy), Sparkles (copy)
    u35.Start.TextWrapped = false;
    u35.End.TextWrapped = false;
    u35.Start.TextScaled = false;
    u35.End.TextScaled = false;
    u35.Start.TextSize = 130 * ScreenResolution.GetScale();
    u35.End.TextSize = 130 * ScreenResolution.GetScale();
    local v38 = u35.End:GetAttribute("OriginalScale");
    local v39 = u35.End:GetAttribute("OriginalThickness");
    local v40 = typeof(v38) == "number";
    assert(v40, "DoubleYourSpeed.Pack.Multiplier.End.OriginalScale must be a number");
    local v41 = typeof(v39) == "number";
    assert(v41, "DoubleYourSpeed.Pack.Multiplier.End.OriginalThickness must be a number");
    task.delay(0.6, function() -- Line: 231
        -- upvalues: Audio (ref)
        Audio.Play("rbxassetid://91650233387983", script, 1, 1.5);
    end);
    Tween(u35.End.UIStroke, {
        Thickness = v39 * 0.15
    }, { 0.6, "Back", "In" });
    Tween(u35.End.UIScale, {
        Scale = v38 * 4
    }, { 0.6, "Back", "In" }).Completed:Wait();
    Tween(u35.End.UIStroke, {
        Thickness = v39 * 0.1
    }, { 0.3, "Sine", "Out" });
    Tween(u35.End.UIScale, {
        Scale = v38 * 6
    }, { 0.3, "Sine", "Out" }).Completed:Wait();
    task.spawn(function() -- Line: 265
        -- upvalues: u37 (copy), u36 (copy), u35 (copy), Asserts (ref), Simple (ref)
        local v42 = u37 - u36;
        local v43 = math.abs(v42);
        local v44 = math.clamp(v43, 1, 15);
        local v45 = math.round(v42 / v44);

        for i = 1, v44 do
            local End = u35.End;
            local v46 = u36 + v45 * i;
            Asserts.number(v46);
            End.Text = `x{Simple.FormatCompact(v46, ".#")}`;
            task.wait(0.025);
        end;

        local End = u35.End;
        local v47 = u37;
        Asserts.number(v47);
        End.Text = `x{Simple.FormatCompact(v47, ".#")}`;
    end);
    local Start = u35.Start;
    Asserts.number(u36);
    Start.Text = `x{Simple.FormatCompact(u36, ".#")}`;
    task.delay(0.075, function() -- Line: 280
        -- upvalues: Shake (ref), Flash (ref), Shockwave (ref), u35 (copy), Sparkles (ref)
        Shake.Create(1, 6, 0.25, false);
        Flash(0, 0.25, Color3.new(1, 1, 1), 0.25);
        Shockwave(u35.End, 1.5, 0.7, 6);
        local v48 = Sparkles(u35.End);
        task.delay(10, v48);
    end);
    Tween(u35.End.UIStroke, {
        Thickness = v39
    }, { 0.075, "Quad", "In" });
    Tween(u35.End.UIScale, {
        Scale = v38
    }, { 0.075, "Quad", "In" }).Completed:Wait();
    u35.End.UIScale.Scale = v38;
    u35.End.UIStroke.Thickness = v39;
end;

local function updateDoubleYourSpeedPack(u49, p50) -- Line: 307
    -- upvalues: TreadmillUtil (copy), Save (copy), u1 (copy), GetPrice (copy), Constants (copy), updateDoubleYourSpeedPack (copy), playDoubleYourSpeedAnimation (copy), Asserts (copy), Simple (copy)
    local v51 = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get());
    local v52 = u1[v51];
    local u53 = v52 == nil and 1 or v52.SpeedBoostMultiplier;
    local v54 = u1[v51 + 1];
    local u55;

    if v54 == nil then
        u55 = u53;
    else
        u55 = v54.SpeedBoostMultiplier;
    end;

    local v56 = v54 == nil;
    u49.Multiplier.Visible = not v56;
    u49.Max.Visible = v56;
    u49.Buy.Visible = not v56;
    u49.Buy.Interactable = not v56;
    local Price = u49.Buy.Price;
    local v57 = u1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) + 1];
    Price.Visible = true;

    if v57 == nil then
        Price.Text = "MAX";
        Price.Visible = false;
    else
        local ProductId = v57.ProductId;

        if ProductId <= 0 then
            Price.Text = "???";
            Price.Visible = false;
        else
            task.spawn(function() -- Line: 149
                -- upvalues: GetPrice (ref), ProductId (copy), Price (copy), Constants (ref)
                local v58, v59 = GetPrice(ProductId, true);
                Price.Text = `{Constants.ROBUX_ICON_STR}{not v59 and "???" or tostring(v58)}`;
            end);
        end;
    end;

    if p50 and (u49.HasRendered and not v56) then
        local u60 = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get());
        task.delay(1.2, function() -- Line: 314
            -- upvalues: u49 (copy), TreadmillUtil (ref), Save (ref), u60 (copy), updateDoubleYourSpeedPack (ref), playDoubleYourSpeedAnimation (ref), u53 (copy), u55 (copy)
            if (u49.AlwaysAnimate or u49.Root.Enabled) and TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) == u60 then
                playDoubleYourSpeedAnimation(u49, u53, u55);

                return;
            end;

            updateDoubleYourSpeedPack(u49, false);
        end);
    else
        local Start = u49.Start;
        Asserts.number(u53);
        Start.Text = `x{Simple.FormatCompact(u53, ".#")}`;
        local End = u49.End;
        Asserts.number(u55);
        End.Text = `x{Simple.FormatCompact(u55, ".#")}`;
        local Max = u49.Max;
        Asserts.number(u53);
        Max.Text = `{`x{Simple.FormatCompact(u53, ".#")}`} MAX`;
    end;

    u49.LastRenderedSpeedBoostTierIndex = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get());
    u49.HasRendered = true;
end;

local function bindDoubleYourSpeedButton(p61) -- Line: 332
    -- upvalues: ButtonFX (copy), u1 (copy), TreadmillUtil (copy), Save (copy), PromptPurchase (copy)
    ButtonFX(p61.Buy, nil, function() -- Line: 333
        -- upvalues: u1 (ref), TreadmillUtil (ref), Save (ref), PromptPurchase (ref)
        local v62 = u1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) + 1];

        if v62 == nil then
            return;
        end;

        PromptPurchase.Prompt(v62.ProductId, true);
    end);
end;

local function updateSpeedBoostProducts() -- Line: 343
    -- upvalues: TreadmillUtil (copy), Save (copy), u5 (copy), updateDoubleYourSpeedPack (copy), u1 (copy), Button (copy), Text (copy), Multiplier (copy), u6 (ref), u2 (copy), GetPrice (copy), Constants (copy)
    local v63 = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get());

    for _, v in ipairs(u5) do
        updateDoubleYourSpeedPack(v, v.Root.Enabled and v63 ~= v.LastRenderedSpeedBoostTierIndex);
    end;

    local v64 = u1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) + 1];
    local v65 = v64 ~= nil;
    Button.Interactable = v65;
    Text.Visible = v65;

    if v64 == nil then
        Multiplier.Text = "MAX";
        u6 = u6 + 1;
        Text.Text = "MAX";

        return;
    end;

    Multiplier.Text = TreadmillUtil.FormatSpeedMultiplier(v64.SpeedBoostMultiplier);
    u6 = u6 + 1;
    local u66 = u6;

    if v64 == nil then
        Text.Text = "MAX";

        return;
    end;

    Text.Text = u2;
    local ProductId = v64.ProductId;
    task.spawn(function() -- Line: 165
        -- upvalues: GetPrice (ref), ProductId (copy), u66 (copy), u6 (ref), Text (ref), Constants (ref), u2 (ref)
        local v67, v68 = GetPrice(ProductId, true);

        if u66 ~= u6 then
            return;
        end;

        local v69;

        if v68 then
            v69 = `ONLY {v67}{Constants.ROBUX_ICON_STR}`;
        else
            v69 = u2;
        end;

        Text.Text = v69;
    end);
end;

if not Save.IsLocalDataLoaded() then
    Save.LoadedStats:Wait();
end;

for _, v in ipairs(u5) do
    ButtonFX(v.Buy, nil, function() -- Line: 333
        -- upvalues: u1 (copy), TreadmillUtil (copy), Save (copy), PromptPurchase (copy)
        local v70 = u1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) + 1];

        if v70 == nil then
            return;
        end;

        PromptPurchase.Prompt(v70.ProductId, true);
    end);
    local v71 = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get());
    local v72 = u1[v71];
    local v73 = v72 == nil and 1 or v72.SpeedBoostMultiplier;
    local v74 = u1[v71 + 1];
    local v75;

    if v74 == nil then
        v75 = v73;
    else
        v75 = v74.SpeedBoostMultiplier;
    end;

    local v76 = v74 == nil;
    v.Multiplier.Visible = not v76;
    v.Max.Visible = v76;
    v.Buy.Visible = not v76;
    v.Buy.Interactable = not v76;
    local Price = v.Buy.Price;
    local v77 = u1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) + 1];
    Price.Visible = true;

    if v77 == nil then
        Price.Text = "MAX";
        Price.Visible = false;
    else
        local ProductId = v77.ProductId;

        if ProductId <= 0 then
            Price.Text = "???";
            Price.Visible = false;
        else
            task.spawn(function() -- Line: 149
                -- upvalues: GetPrice (copy), ProductId (copy), Price (copy), Constants (copy)
                local v78, v79 = GetPrice(ProductId, true);
                Price.Text = `{Constants.ROBUX_ICON_STR}{not v79 and "???" or tostring(v78)}`;
            end);
        end;
    end;

    local Start = v.Start;
    Asserts.number(v73);
    Start.Text = `x{Simple.FormatCompact(v73, ".#")}`;
    local End = v.End;
    Asserts.number(v75);
    End.Text = `x{Simple.FormatCompact(v75, ".#")}`;
    local Max = v.Max;
    Asserts.number(v73);
    Max.Text = `{`x{Simple.FormatCompact(v73, ".#")}`} MAX`;
    v.LastRenderedSpeedBoostTierIndex = TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get());
    v.HasRendered = true;
end;

ButtonFX(Button, nil, function() -- Line: 364
    -- upvalues: u1 (copy), TreadmillUtil (copy), Save (copy), PromptPurchase (copy)
    local v80 = u1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) + 1];

    if v80 == nil then
        return;
    end;

    PromptPurchase.Prompt(v80.ProductId, true);
end);
local v81 = u1[TreadmillUtil.ResolveSpeedBoostTierIndex(Save.Get()) + 1];
local v82 = v81 ~= nil;
Button.Interactable = v82;
Text.Visible = v82;

if v81 == nil then
    Multiplier.Text = "MAX";
    u6 = u6 + 1;
    Text.Text = "MAX";
else
    Multiplier.Text = TreadmillUtil.FormatSpeedMultiplier(v81.SpeedBoostMultiplier);
    u6 = u6 + 1;
    local u83 = u6;

    if v81 == nil then
        Text.Text = "MAX";
    else
        Text.Text = u2;
        local ProductId = v81.ProductId;
        task.spawn(function() -- Line: 165
            -- upvalues: GetPrice (copy), ProductId (copy), u83 (copy), u6 (ref), Text (copy), Constants (copy), u2 (copy)
            local v84, v85 = GetPrice(ProductId, true);

            if u83 ~= u6 then
                return;
            end;

            local v86;

            if v85 then
                v86 = `ONLY {v84}{Constants.ROBUX_ICON_STR}`;
            else
                v86 = u2;
            end;

            Text.Text = v86;
        end);
    end;
end;

Save.ConnectForDataChanged("SpeedBoostTierIndex", updateSpeedBoostProducts);