-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local ItemUI = require(ReplicatedStorage.Library.Client.UI.ItemUI);
local BrainrotItem = require(ReplicatedStorage.Library.Items.BrainrotItem);
local Rainbow = require(ReplicatedStorage.Library.Client.GUIFX.Rainbow);
local FormatFigures = require(ReplicatedStorage.Library.Functions.FormatFigures);
local BrainrotEggIconScaleUtil = require(ReplicatedStorage.Library.Util.BrainrotEggIconScaleUtil);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Save = require(ReplicatedStorage.Library.Client.Save);
local u1 = Vector2.new(2.5, 4);
local u2 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.08);
local u3 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local Assets = ReplicatedStorage.Assets;
local u4 = {};
u4.__index = u4;

local function computeNormalizedOdds(p5) -- Line: 56
    local v6 = {};

    if not p5 then
        return v6;
    end;

    local v7 = 0;

    for _, v in ipairs(p5) do
        local v8 = v[2];

        if typeof(v8) == "number" and v8 > 0 then
            v7 = v7 + v8;
        end;
    end;

    if v7 <= 0 then
        return v6;
    end;

    for _, v in ipairs(p5) do
        local v9 = v[1];
        local v10 = v[2];

        if typeof(v9) == "string" and (typeof(v10) == "number" and v10 > 0) then
            v6[v9] = v10 / v7;
        end;
    end;

    return v6;
end;

local function clearBrainrotSlots(p11) -- Line: 87
    for _, child in ipairs(p11:GetChildren()) do
        if child:IsA("GuiObject") then
            local v12 = child:GetAttribute("_OddsSlot") == true;
            local v13 = child.Name == "BrainrotInfo";
            local v14 = child:FindFirstChild("Chance") and child:FindFirstChild("Holder");

            if v12 or (v13 or v14) then
                child:Destroy();
            end;
        end;
    end;
end;

local function clearGradients(p15) -- Line: 101
    for _, child in ipairs(p15:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy();
        end;
    end;
end;

local function applyRainbowChance(p16) -- Line: 109
    -- upvalues: Rainbow (copy)
    Rainbow(p16, "TextColor3");
    p16.Text = "??";
end;

local function applyChanceLabel(p17, p18) -- Line: 114
    -- upvalues: Rainbow (copy), FormatFigures (copy)
    if p18 < 0.1 then
        Rainbow(p17, "TextColor3");
        p17.Text = "??";

        return;
    end;

    local v19 = math.pow(0.9315, p18) * 94.2467 / 100;
    local v20 = math.clamp(v19, 0, 1);
    local v21, v22, v23 = Color3.fromRGB(49, 255, 39):Lerp(Color3.fromRGB(255, 75, 39), v20):ToHSV();
    p17.TextColor3 = Color3.fromHSV(v21, v22, v23 * 2);
    p17.Text = `{FormatFigures(p18, 3, 5)}%`;
end;

local function setBillboardSize(p24, p25, p26) -- Line: 126
    -- upvalues: u1 (copy), TweenService (copy), u2 (copy)
    local v27 = UDim2.fromScale(math.max(p25, 1) * u1.X, u1.Y);

    if not p26 then
        p24.Size = v27;

        return v27;
    end;

    p24.Size = UDim2.new();
    TweenService:Create(p24, u2, {
        Size = v27
    }):Play();

    return v27;
end;

local function populateOdds(p28, p29, p30, p31) -- Line: 141
    -- upvalues: Save (copy), clearBrainrotSlots (copy), Assets (copy), Rarities (copy), BrainrotItem (copy), ItemUI (copy), BrainrotEggIconScaleUtil (copy), Simple (copy), applyChanceLabel (copy), clearGradients (copy)
    local v32 = Save.Get();
    local Brainrots = p28.Frame.Brainrots;
    clearBrainrotSlots(Brainrots);

    for _, v in ipairs(p29) do
        local v33 = v[1];

        if typeof(v33) == "string" and v33 ~= "" then
            local v34 = (p30[v33] or 0) * 100;
            local v35 = Assets.UI.Eggs.BrainrotInfo:Clone();
            v35:SetAttribute("_OddsSlot", true);
            local v36;

            if Rarities[v33] then
                v36 = nil;
            else
                v36 = BrainrotItem(v33);
            end;

            if v36 then
                local v37 = Assets.UI.Eggs.Brainrot:Clone();
                local v38 = ItemUI.Create(v36, {
                    NoActionMenu = true,
                    NoOverlay = true,
                    NoButtonFX = true,
                    HideQuantity = true,
                    HideStrength = true
                });
                local Icon = v38:FindFirstChild("Icon");

                if Icon and Icon:IsA("ImageLabel") then
                    BrainrotEggIconScaleUtil.ApplyIconScaleToImageLabel(Icon, p31);

                    if v32 and v32.Index then
                        Icon.ImageColor3 = v32.Index[v36:GetId()] ~= nil and Color3.new(1, 1, 1) or Color3.new(0, 0, 0);
                    end;
                end;

                v37.LayoutOrder = 9999 - v34 * 20;
                local v39 = v36:Directory();
                v37.Weight.Text = Simple.FormatCompact((v39 and (v39.ModelWeight or 0) or 0) * (p31 or 1)) .. "kg";
                applyChanceLabel(v37.Chance, v34);
                v38.Parent = v37;
                v37.Parent = v35.Holder;
                v35.Chance.Visible = false;
                v35.Name = v36:GetId();
            else
                local v40 = Rarities[v33];

                if v40 then
                    local v41 = v40.DisplayName or v33;
                    local RarityHolder = v35:FindFirstChild("RarityHolder");
                    local v42;

                    if RarityHolder then
                        v42 = RarityHolder:FindFirstChild("RarityLabel");
                    else
                        v42 = nil;
                    end;

                    local v43;

                    if v42 then
                        v43 = v42:FindFirstChild("Label");
                    else
                        v43 = nil;
                    end;

                    v35.Holder.Visible = false;

                    if RarityHolder and RarityHolder:IsA("GuiObject") then
                        RarityHolder.Visible = true;
                        clearGradients(RarityHolder);

                        if v40.Gradient then
                            v40.Gradient:Clone().Parent = RarityHolder;
                        end;
                    end;

                    if v42 and v42:IsA("TextLabel") then
                        v42.Text = v41;
                        v42.TextColor3 = v40.Color;
                    end;

                    if v43 and v43:IsA("TextLabel") then
                        v43.Text = v41;
                        v43.TextColor3 = v40.Color;
                    end;

                    v35.Chance.Visible = true;
                    applyChanceLabel(v35.Chance, v34);
                    v35.Name = v41;
                end;
            end;

            v35.LayoutOrder = 1;
            v35.Parent = Brainrots;
        end;
    end;
end;

local function stopSizeTween(p44) -- Line: 231
    local _sizeTween = p44._sizeTween;

    if _sizeTween then
        _sizeTween:Cancel();
        p44._sizeTween = nil;
    end;

    local _sizeTweenConn = p44._sizeTweenConn;

    if _sizeTweenConn then
        _sizeTweenConn:Disconnect();
        p44._sizeTweenConn = nil;
    end;
end;

local function playShowAnimation(u45, u46) -- Line: 245
    -- upvalues: TweenService (copy), u2 (copy)
    local _sizeTween = u45._sizeTween;

    if _sizeTween then
        _sizeTween:Cancel();
        u45._sizeTween = nil;
    end;

    local _sizeTweenConn = u45._sizeTweenConn;

    if _sizeTweenConn then
        _sizeTweenConn:Disconnect();
        u45._sizeTweenConn = nil;
    end;

    local u47 = u45._targetSize or u46.Size;

    if not u45._shouldAnimate then
        u46.Enabled = true;
        u46.Size = u47;

        return;
    end;

    u46.Enabled = true;
    u46.Size = UDim2.new();
    local u48 = TweenService:Create(u46, u2, {
        Size = u47
    });
    u45._sizeTween = u48;
    u45._sizeTweenConn = u48.Completed:Connect(function() -- Line: 262
        -- upvalues: u45 (copy), u48 (copy), u46 (copy), u47 (copy)
        if u45._sizeTween ~= u48 then
            return;
        end;

        u45._sizeTween = nil;
        u45._sizeTweenConn = nil;
        u46.Size = u47;
    end);
    u48:Play();
end;

local function playHideAnimation(u49, u50) -- Line: 274
    -- upvalues: TweenService (copy), u3 (copy)
    local _sizeTween = u49._sizeTween;

    if _sizeTween then
        _sizeTween:Cancel();
        u49._sizeTween = nil;
    end;

    local _sizeTweenConn = u49._sizeTweenConn;

    if _sizeTweenConn then
        _sizeTweenConn:Disconnect();
        u49._sizeTweenConn = nil;
    end;

    if not u49._shouldAnimate then
        u50.Enabled = false;
        u50.Size = u49._targetSize or u50.Size;

        return;
    end;

    local u51 = u49._targetSize or u50.Size;
    u50.Enabled = true;
    local u52 = TweenService:Create(u50, u3, {
        Size = UDim2.new()
    });
    u49._sizeTween = u52;
    u49._sizeTweenConn = u52.Completed:Connect(function() -- Line: 291
        -- upvalues: u49 (copy), u52 (copy), u50 (copy), u51 (copy)
        if u49._sizeTween ~= u52 then
            return;
        end;

        u49._sizeTween = nil;
        u49._sizeTweenConn = nil;

        if not u49._visible then
            u50.Enabled = false;
        end;

        u50.Size = u51;
    end);
    u52:Play();
end;

local function shouldDestroyBillboard(p53) -- Line: 308
    if not p53 then
        return true;
    end;

    if not p53.dropTable or #p53.dropTable == 0 then
        return true;
    end;

    local parent = p53.parent;

    return not (parent and parent.Parent);
end;

function u4.new(p54) -- Line: 325
    -- upvalues: u4 (copy)
    local v55 = setmetatable({
        _billboard = nil,
        _visible = false,
        _destroyed = false,
        _targetSize = nil,
        _sizeTween = nil,
        _sizeTweenConn = nil,
        _shouldAnimate = true,
        _config = p54
    }, u4);

    if p54 then
        v55:Update(p54);
    end;

    return v55;
end;

function u4._destroyBillboard(p56) -- Line: 344
    local _billboard = p56._billboard;

    if _billboard then
        local _sizeTween = p56._sizeTween;

        if _sizeTween then
            _sizeTween:Cancel();
            p56._sizeTween = nil;
        end;

        local _sizeTweenConn = p56._sizeTweenConn;

        if _sizeTweenConn then
            _sizeTweenConn:Disconnect();
            p56._sizeTweenConn = nil;
        end;

        _billboard:Destroy();
        p56._billboard = nil;
    end;

    p56._targetSize = nil;
end;

function u4.GetBillboard(p57) -- Line: 354
    return p57._billboard;
end;

function u4.SetVisible(p58, p59) -- Line: 358
    -- upvalues: playShowAnimation (copy), playHideAnimation (copy)
    if p58._destroyed then
        return;
    end;

    if p58._visible == p59 then
        return;
    end;

    p58._visible = p59;
    local _billboard = p58._billboard;

    if not _billboard then
        return;
    end;

    if p59 then
        playShowAnimation(p58, _billboard);

        return;
    end;

    playHideAnimation(p58, _billboard);
end;

function u4.Update(p60, p61) -- Line: 381
    -- upvalues: computeNormalizedOdds (copy), Assets (copy), populateOdds (copy), setBillboardSize (copy)
    if p60._destroyed then
        return;
    end;

    p60._config = p61;
    local v62;

    if p61 and (p61.dropTable and #p61.dropTable ~= 0) then
        local parent = p61.parent;
        v62 = not (parent and parent.Parent);
    else
        v62 = true;
    end;

    if v62 then
        p60:_destroyBillboard();

        return;
    end;

    local dropTable = p61.dropTable;
    local v63 = p61.normalizedOdds or computeNormalizedOdds(dropTable);
    local _billboard = p60._billboard;
    local v64 = _billboard == nil;

    if not _billboard then
        _billboard = Assets.UI.Eggs.EggInfo:Clone();
        assert(_billboard, "luau");
        _billboard.Enabled = p60._visible;
        p60._billboard = _billboard;
    end;

    assert(_billboard, "luau");
    local _sizeTween = p60._sizeTween;

    if _sizeTween then
        _sizeTween:Cancel();
        p60._sizeTween = nil;
    end;

    local _sizeTweenConn = p60._sizeTweenConn;

    if _sizeTweenConn then
        _sizeTweenConn:Disconnect();
        p60._sizeTweenConn = nil;
    end;

    _billboard.MaxDistance = p61.maxDistance or 75;
    _billboard.StudsOffset = p61.studsOffsetWorldSpace or Vector3.new(0, 0, 0);
    _billboard.Frame.Title.Text = p61.title or "Lucky Block";
    local adornee = p61.adornee;

    if adornee and adornee.Parent then
        _billboard.Adornee = adornee;
    else
        _billboard.Adornee = p61.parent;
    end;

    _billboard.Parent = p61.parent;
    populateOdds(_billboard, dropTable, v63, p61.scale);
    local v65 = p61.animate ~= false;
    p60._shouldAnimate = v65;
    p60._targetSize = setBillboardSize(_billboard, #dropTable, v64 and v65);
    _billboard.Enabled = p60._visible;
end;

function u4.Destroy(p66) -- Line: 430
    if p66._destroyed then
        return;
    end;

    p66._destroyed = true;
    p66._config = nil;
    p66:_destroyBillboard();
end;

return u4;