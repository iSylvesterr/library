-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Directory.Assets.Types.Interface);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Assets = require(ReplicatedStorage.Directory.Assets);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local u1 = UDim2.fromScale(0.77, 0.77);
local u2 = UDim2.fromScale(0.85, 0.85);
local u3 = UDim2.fromScale(0.5, 0.5);
local u4 = Vector2.new(0.5, 0.5);
local u5 = {};

local function clearShapedIcon(p6) -- Line: 36
    local AssetIconShapeLayer = p6:FindFirstChild("AssetIconShapeLayer");

    if AssetIconShapeLayer ~= nil then
        AssetIconShapeLayer:Destroy();
    end;
end;

local function clearOverlay(p7) -- Line: 43
    local RainbowOverlayImage = p7:FindFirstChild("RainbowOverlayImage");

    if RainbowOverlayImage and RainbowOverlayImage:IsA("ImageLabel") then
        RainbowOverlayImage:Destroy();
    end;
end;

local function getSizeMutationIconZoom(p8) -- Line: 50
    return 1, nil;
end;

local function hasRainbowMutation(p9) -- Line: 54
    -- upvalues: Mutations (copy)
    local Rainbow = Mutations.GetMutationsMap().Rainbow;

    return p9.BaseMutation == Rainbow and true or table.find(p9.Mutations, Rainbow) ~= nil;
end;

local function hasMutation(p10, p11) -- Line: 59
    return p10.BaseMutation == p11 and true or table.find(p10.Mutations, p11) ~= nil;
end;

local function resolveIconImage(p12, p13) -- Line: 63
    -- upvalues: Mutations (copy)
    local v14 = Mutations.GetMutationsMap();
    local MutationIcons = p12.MutationIcons;

    if MutationIcons == nil then
        return p12.Icon or "";
    end;

    local Golden = v14.Golden;

    if (p13.BaseMutation == Golden and true or table.find(p13.Mutations, Golden) ~= nil) and MutationIcons[v14.Golden] ~= nil then
        return MutationIcons[v14.Golden];
    end;

    local Silver = v14.Silver;

    return (p13.BaseMutation ~= Silver and table.find(p13.Mutations, Silver) == nil or MutationIcons[v14.Silver] == nil) and (p12.Icon or "") or MutationIcons[v14.Silver];
end;

function u5.ApplyRainbowOverlay(p15, p16) -- Line: 88
    -- upvalues: Asserts (copy), Rarity (copy), u3 (copy), u4 (copy)
    Asserts.ImageLabel(p15);
    Asserts.string(p16);
    local v17 = Rarity.Rarities.Rainbow.Gradient:Clone();
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "RainbowOverlayImage";
    ImageLabel.Image = p16;
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Position = u3;
    ImageLabel.AnchorPoint = u4;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.ZIndex = p15.ZIndex + 1;
    ImageLabel.Parent = p15;
    v17.Parent = ImageLabel;

    return ImageLabel;
end;

function u5.Clear(p18) -- Line: 111
    -- upvalues: Asserts (copy)
    Asserts.ImageLabel(p18);
    local RainbowOverlayImage = p18:FindFirstChild("RainbowOverlayImage");

    if RainbowOverlayImage and RainbowOverlayImage:IsA("ImageLabel") then
        RainbowOverlayImage:Destroy();
    end;

    local AssetIconShapeLayer = p18:FindFirstChild("AssetIconShapeLayer");

    if AssetIconShapeLayer ~= nil then
        AssetIconShapeLayer:Destroy();
    end;

    p18.ImageTransparency = 0;
end;

function u5.SetVisualState(p19, p20, p21) -- Line: 119
    -- upvalues: Asserts (copy)
    Asserts.ImageLabel(p19);
    Asserts.Color3(p20);
    Asserts.number(p21);
    p19.ImageColor3 = p20;
    p19.ImageTransparency = p21;
    local AssetIconShapeLayer = p19:FindFirstChild("AssetIconShapeLayer");

    if AssetIconShapeLayer == nil then
        return;
    end;

    for _, descendant in ipairs(AssetIconShapeLayer:GetDescendants()) do
        if descendant:IsA("ImageLabel") then
            descendant.ImageTransparency = p21;

            if descendant.Name == "IconStrokeImage" and p20 ~= Color3.fromRGB(0, 0, 0) then
                descendant.ImageColor3 = Color3.fromRGB(0, 0, 0);
            else
                descendant.ImageColor3 = p20;
            end;
        end;
    end;
end;

function u5.Apply(p22, p23) -- Line: 146
    -- upvalues: Asserts (copy), AssetItem (copy), Assets (copy), resolveIconImage (copy), u5 (copy), Mutations (copy), u3 (copy), u4 (copy), u2 (copy), u1 (copy)
    Asserts.ImageLabel(p22);
    assert(AssetItem.AssetItemData(p23));
    local v24 = Assets.Directory[p23.Category];
    local v25 = `Unknown asset icon category "{p23.Category}"`;
    assert(v24 ~= nil, v25);
    local v26 = resolveIconImage(v24, p23);
    local v27 = 1;
    local v28 = nil or UDim2.fromScale(0, 0);
    assert(v28, "luau");
    u5.Clear(p22);
    p22.BackgroundTransparency = 1;
    p22.ScaleType = Enum.ScaleType.Fit;

    if v27 <= 1 then
        p22.Image = v26;
        p22.ImageTransparency = 0;
        local Rainbow = Mutations.GetMutationsMap().Rainbow;

        if p23.BaseMutation == Rainbow and true or table.find(p23.Mutations, Rainbow) ~= nil then
            u5.ApplyRainbowOverlay(p22, v24.WhiteImage or v26);
        end;

        return;
    end;

    p22.Image = "";
    p22.ImageTransparency = 1;
    local Frame = Instance.new("Frame");
    Frame.Name = "AssetIconShapeLayer";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Position = u3;
    Frame.AnchorPoint = u4;
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = p22.ZIndex;
    Frame.Parent = p22;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "IconStrokeFrame";
    CanvasGroup.Size = u2;
    CanvasGroup.Position = u3;
    CanvasGroup.AnchorPoint = u4;
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.ClipsDescendants = true;
    CanvasGroup.ZIndex = p22.ZIndex;
    CanvasGroup.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "IconStrokeImage";
    ImageLabel.Image = v26;
    ImageLabel.ImageColor3 = Color3.fromRGB(0, 0, 0);
    ImageLabel.Size = UDim2.fromScale(v27, v27);
    ImageLabel.Position = u3 + v28;
    ImageLabel.AnchorPoint = u4;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.ZIndex = p22.ZIndex;
    ImageLabel.Parent = CanvasGroup;
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "IconClipFrame";
    CanvasGroup2.Size = u1;
    CanvasGroup2.Position = u3;
    CanvasGroup2.AnchorPoint = u4;
    CanvasGroup2.BackgroundTransparency = 1;
    CanvasGroup2.ClipsDescendants = true;
    CanvasGroup2.ZIndex = p22.ZIndex + 1;
    CanvasGroup2.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "IconImage";
    ImageLabel2.Image = v26;
    ImageLabel2.Size = UDim2.fromScale(v27, v27);
    ImageLabel2.Position = u3 + v28;
    ImageLabel2.AnchorPoint = u4;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.ZIndex = p22.ZIndex + 1;
    ImageLabel2.Parent = CanvasGroup2;
    local Rainbow = Mutations.GetMutationsMap().Rainbow;

    if p23.BaseMutation == Rainbow and true or table.find(p23.Mutations, Rainbow) ~= nil then
        u5.ApplyRainbowOverlay(ImageLabel2, v24.WhiteImage or v26);
    end;
end;

local function scaleIconSize(p29, p30, p31) -- Line: 233
    return UDim2.new(p29.X.Scale * p30, p29.X.Offset * p30, p29.Y.Scale * p31, p29.Y.Offset * p31);
end;

function u5.BindHoverSquashEffect(p32, u33, u34) -- Line: 237
    -- upvalues: Asserts (copy), Trove (copy), Tween (copy)
    Asserts.GuiObject(p32);
    Asserts.ImageLabel(u33);
    Asserts.optional.func(u34);
    local u35 = nil;
    local Size = u33.Size;
    local v36 = Trove.new();

    local function updateIconsScaleType(p37) -- Line: 259
        -- upvalues: u33 (copy)
        local v38 = { u33 };

        for _, descendant in ipairs(u33:GetDescendants()) do
            if descendant:IsA("ImageLabel") then
                table.insert(v38, descendant);
            end;
        end;

        for _, v in ipairs(v38) do
            v.ScaleType = p37;
        end;
    end;

    local function resetAssetIconHoverState(p39) -- Line: 272
        -- upvalues: u35 (ref), u33 (copy), Size (copy), updateIconsScaleType (copy)
        if u35 then
            u35:Cancel();
            u35:Destroy();
            u35 = nil;
        end;

        if u33 then
            local v40 = p39 or Size;

            if v40 then
                u33.Size = v40;
            end;

            updateIconsScaleType(Enum.ScaleType.Fit);
        end;
    end;

    local function restoreAssetIconHover(p41) -- Line: 283
        -- upvalues: u33 (copy), Size (copy), u35 (ref), updateIconsScaleType (copy), Tween (ref)
        if not (u33 and Size) then
            if u35 then
                u35:Cancel();
                u35:Destroy();
                u35 = nil;
            end;

            if u33 then
                local v42 = Size;

                if v42 then
                    u33.Size = v42;
                end;

                updateIconsScaleType(Enum.ScaleType.Fit);
            end;

            return;
        end;

        if u35 then
            u35:Cancel();
            u35:Destroy();
            u35 = nil;
        end;

        local v43 = Size;

        if p41 == false then
            if u35 then
                u35:Cancel();
                u35:Destroy();
                u35 = nil;
            end;

            if u33 then
                local v44 = v43 or Size;

                if v44 then
                    u33.Size = v44;
                end;

                updateIconsScaleType(Enum.ScaleType.Fit);
            end;

            return;
        end;

        u35 = Tween(u33, {
            Size = v43
        }, { 0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out });
        assert(u35, "luau");
        u35.Completed:Once(function(p45) -- Line: 303
            -- upvalues: updateIconsScaleType (ref), u35 (ref)
            if p45 == Enum.PlaybackState.Cancelled then
                return;
            end;

            updateIconsScaleType(Enum.ScaleType.Fit);
            u35 = nil;
        end);
        u35:Play();
    end;

    local function playAssetIconHoverSquash() -- Line: 313
        -- upvalues: u33 (copy), u34 (copy), u35 (ref), updateIconsScaleType (copy), Tween (ref), Size (copy)
        if not u33 or u34 and not u34() then
            return;
        end;

        if u35 then
            u35:Cancel();
            u35:Destroy();
            u35 = nil;
        end;

        updateIconsScaleType(Enum.ScaleType.Stretch);
        local v46 = {};
        local v47 = Size;
        v46.Size = UDim2.new(v47.X.Scale * 1.2, v47.X.Offset * 1.2, v47.Y.Scale * 0.43, v47.Y.Offset * 0.43);
        u35 = Tween(u33, v46, { 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
        assert(u35, "luau");
        u35:Play();
    end;

    v36:Add(function() -- Line: 251, Name: stopAssetIconHoverTween
        -- upvalues: u35 (ref)
        if u35 then
            u35:Cancel();
            u35:Destroy();
            u35 = nil;
        end;
    end);
    v36:Connect(p32.MouseEnter, playAssetIconHoverSquash);
    v36:Connect(p32.MouseLeave, restoreAssetIconHover);
    v36:Connect(p32.InputEnded, function(p48) -- Line: 333
        -- upvalues: restoreAssetIconHover (copy)
        if p48.UserInputType == Enum.UserInputType.MouseButton1 or p48.UserInputType == Enum.UserInputType.Touch then
            restoreAssetIconHover();
        end;
    end);

    return v36, restoreAssetIconHover;
end;

return u5;