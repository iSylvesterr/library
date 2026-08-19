-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Shared = ReplicatedStorage:WaitForChild("Shared");
ReplicatedStorage:WaitForChild("Client");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Knit = require(Packages.Knit);
local Maid = require(Packages.Maid);
require(Shared.Info.Images);
local CustomEnum = require(Shared.Info.CustomEnum);
local ExpandedRarities = require(Shared.Info.ExpandedRarities);
local StarImages = require(Shared.Info.StarImages);
local ItemHelperFunctions = require(Shared.Utility.ItemHelperFunctions);
local Item = Assets:WaitForChild("Gui"):WaitForChild("Frames"):WaitForChild("Item");
local u2 = {};
local v3 = Color3.new(0.623529, 0.623529, 0.623529);
local v4 = Color3.new(1, 1, 1);
local v5 = Color3.new(0.372549, 0.372549, 0.372549);
local v6 = Color3.new(0.57647, 0.57647, 0.57647);
local u7 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v3), ColorSequenceKeypoint.new(0.5, v4), ColorSequenceKeypoint.new(1, v3) });
local u8 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v5), ColorSequenceKeypoint.new(0.5, v6), ColorSequenceKeypoint.new(1, v5) });
local u9 = nil;
local u10 = nil;

local function evalColorSequence(p11, p12) -- Line: 48
    if p12 == 0 then
        return p11.Keypoints[1].Value;
    end;

    if p12 == 1 then
        return p11.Keypoints[#p11.Keypoints].Value;
    end;

    for i = 1, #p11.Keypoints - 1 do
        local v13 = p11.Keypoints[i];
        local v14 = p11.Keypoints[i + 1];

        if v13.Time <= p12 and p12 < v14.Time then
            local v15 = (p12 - v13.Time) / (v14.Time - v13.Time);

            return Color3.new((v14.Value.R - v13.Value.R) * v15 + v13.Value.R, (v14.Value.G - v13.Value.G) * v15 + v13.Value.G, (v14.Value.B - v13.Value.B) * v15 + v13.Value.B);
        end;
    end;
end;

local function setupRotatingValues() -- Line: 74
    -- upvalues: u9 (ref), TweenService (copy), u10 (ref)
    if not u9 then
        u9 = Instance.new("NumberValue");
        u9.Parent = script;
        TweenService:Create(u9, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
            Value = 1
        }):Play();
    end;

    if not u10 then
        u10 = Instance.new("NumberValue");
        u10.Value = 0.9;
        u10.Parent = script;
        TweenService:Create(u10, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
            Value = 1
        }):Play();
    end;
end;

local function genIcon(p16, p17) -- Line: 114
    -- upvalues: setupRotatingValues (copy), Knit (copy), Item (copy), u2 (copy), Maid (copy), ExpandedRarities (copy), CustomEnum (copy), StarImages (copy), u9 (ref), evalColorSequence (copy), u7 (copy), u8 (copy), u10 (ref)
    setupRotatingValues();
    local u18 = Knit.GetController("UI_Manager");
    local u19 = p16 or Item:Clone();

    if not p16 then
        u19.Parent = script;
    end;

    if u2[u19] then
        u2[u19]:Destroy();
        u2[u19] = nil;
    end;

    u2[u19] = Maid.new();
    u2[u19]:GiveTask(u19.Destroying:Once(function() -- Line: 133
        -- upvalues: u2 (ref), u19 (copy)
        if u2[u19] then
            u2[u19]:Destroy();
            u2[u19] = nil;
        end;
    end));
    p17.zIndex = p17.zIndex or 2;

    for _, descendant in u19:GetDescendants() do
        if descendant:IsA("GuiObject") then
            if not descendant:GetAttribute("OldZ") then
                descendant:SetAttribute("OldZ", descendant.ZIndex);
            end;

            descendant.ZIndex = descendant:GetAttribute("OldZ") + p17.zIndex;
        end;
    end;

    u19.Name = p17.name or "Icon";
    local v20 = p17.colorData or ExpandedRarities[CustomEnum.RARITIES.COMMON];
    u19.Button.BackgroundColor3 = v20.mainColor;
    u19.Button.Inner.BackgroundColor3 = v20.subColor;
    u19.Button.Inner.ImageLabel.Image = p17.image;
    u19.Button.Inner.ImageLabel.Visible = true;
    u19.Button.Inner.Amount.Visible = false;
    u19.Button.Inner.TopBottomText.BottomLine.Visible = false;
    u19.Button.Inner.TopBottomText.TopLine.Visible = false;
    u19.Button.Inner.MidText.TopLine.Visible = false;
    u19.Button.Inner.MidText.BottomLine.Visible = false;

    if p17.iconTextType == CustomEnum.ICON_TEXT_TYPE.AMOUNT then
        u19.Button.Inner.ImageLabel.Size = UDim2.fromScale(0.9, 0.9);

        if p17.amtText then
            u19.Button.Inner.Amount.Text = p17.amtText;
            u19.Button.Inner.Amount.Visible = true;
        end;
    elseif p17.iconTextType == CustomEnum.ICON_TEXT_TYPE.TOP_BOTTOM then
        u19.Button.Inner.ImageLabel.Size = UDim2.fromScale(0.6, 0.6);

        if p17.topText then
            u19.Button.Inner.TopBottomText.TopLine.Visible = true;
            u19.Button.Inner.TopBottomText.TopLine.Text = p17.topText;
        end;

        if p17.botText then
            u19.Button.Inner.TopBottomText.BottomLine.Visible = true;
            u19.Button.Inner.TopBottomText.BottomLine.Text = p17.botText;
        end;
    elseif p17.iconTextType == CustomEnum.ICON_TEXT_TYPE.MID_TEXT then
        u19.Button.Inner.ImageLabel.Visible = false;

        if p17.topText then
            u19.Button.Inner.MidText.TopLine.Visible = true;
            u19.Button.Inner.MidText.TopLine.Text = p17.topText;
        end;

        if p17.botText then
            u19.Button.Inner.MidText.BottomLine.Visible = true;
            u19.Button.Inner.MidText.BottomLine.Text = p17.botText;
        end;
    elseif p17.iconTextType == CustomEnum.ICON_TEXT_TYPE.IMAGE_ONLY then
        u19.Button.Inner.ImageLabel.Size = UDim2.fromScale(0.9, 0.9);
    end;

    local v21, v22 = StarImages(p17.stars);
    u19.Button.Inner.Stars.Visible = v22;
    u19.Button.Inner.Stars.Image = v21;
    u19.Button.Active = p17.interactable;
    u19.Button.Interactable = p17.interactable;

    if p17.shinyIcon then
        local UIGradient = u19.Button.UIGradient;
        local UIGradient2 = u19.Button.Inner.UIGradient;
        u2[u19]:GiveTask(u9.Changed:Connect(function(p23) -- Line: 214
            -- upvalues: evalColorSequence (ref), u7 (ref), u8 (ref), UIGradient (copy), UIGradient2 (copy)
            local v24 = math.clamp((p23 + 0) % 1, 0.01, 0.99);
            local v25 = math.clamp((p23 + 0.5) % 1, 0.01, 0.99);

            local function v28(p26, p27) -- Line: 218
                return p26.Time < p27.Time;
            end;

            local v29 = {
                ColorSequenceKeypoint.new(0, evalColorSequence(u7, v24)),
                ColorSequenceKeypoint.new(v24, evalColorSequence(u7, 0)),
                ColorSequenceKeypoint.new(v25, evalColorSequence(u7, 0.5)),
                ColorSequenceKeypoint.new(1, evalColorSequence(u7, 1 - v24))
            };
            local v30 = {
                ColorSequenceKeypoint.new(0, evalColorSequence(u8, v24)),
                ColorSequenceKeypoint.new(v24, evalColorSequence(u8, 0)),
                ColorSequenceKeypoint.new(v25, evalColorSequence(u8, 0.5)),
                ColorSequenceKeypoint.new(1, evalColorSequence(u8, 1 - v24))
            };
            table.sort(v29, v28);
            table.sort(v30, v28);
            local v31 = ColorSequence.new(v29);
            local v32 = ColorSequence.new(v30);
            UIGradient.Color = v31;
            UIGradient2.Color = v32;
        end));
        local u33 = u18:AddEmitterTemplate(u19.Button.Inner.ImageLabel, UDim2.new(0.5, 0, 0.5, 0), u18.PARTICLE_TEMPLATES.SPARKLE, {});
        u2[u19]:GiveTask(u10.Changed:Connect(function(p34) -- Line: 253
            -- upvalues: u19 (copy)
            u19.Button.Inner.ImageLabel.Size = UDim2.new(p34, 0, p34, 0);
        end));
        u2[u19]:GiveTask(function() -- Line: 257
            -- upvalues: u18 (copy), u33 (copy), u19 (copy), UIGradient (copy), UIGradient2 (copy)
            u18:RemoveEmitter(u33);

            if u19:FindFirstChild("Button") then
                UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1));
                UIGradient2.Color = ColorSequence.new(Color3.new(1, 1, 1));
                u19.Button.Inner.ImageLabel.Size = UDim2.new(0.9, 0, 0.9, 0);
            end;
        end);
    end;

    return u19;
end;

function v1.GenItemIcon(p35, p36, p37, p38, p39) -- Line: 275
    -- upvalues: genIcon (copy), ExpandedRarities (copy), CustomEnum (copy), ItemHelperFunctions (copy)
    local v40 = p36[1];
    local v41 = p36[2];
    local v42 = p36[3];

    if v40 == "EMPTY" then
        return genIcon(p37, {
            image = "",
            amtText = "",
            shinyIcon = false,
            stars = 0,
            name = v40,
            colorData = ExpandedRarities[CustomEnum.RARITIES.COMMON],
            iconTextType = CustomEnum.ICON_TEXT_TYPE.IMAGE_ONLY,
            interactable = p38,
            zIndex = p39
        });
    end;

    local v43 = ItemHelperFunctions:GetItemModule(v40);
    local v44;

    if v41 > 1 then
        v44 = "x" .. v41;
    else
        v44 = nil;
    end;

    return genIcon(p37, {
        name = v40,
        colorData = ExpandedRarities[v43.rarity],
        image = v43.image,
        iconTextType = CustomEnum.ICON_TEXT_TYPE.AMOUNT,
        amtText = v44,
        interactable = p38,
        shinyIcon = v43.shinyIcon,
        zIndex = p39,
        stars = v42.star
    });
end;

function v1.GenCustomIcon(p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55) -- Line: 319
    -- upvalues: CustomEnum (copy), genIcon (copy)
    if p48 == CustomEnum.ICON_TEXT_TYPE.AMOUNT then
        return genIcon(p46, {
            name = "Icon",
            colorData = p50,
            image = p49,
            iconTextType = p48,
            amtText = p51,
            interactable = p47,
            shinyIcon = p53,
            zIndex = p54,
            stars = p55
        });
    end;

    return genIcon(p46, {
        name = "Icon",
        colorData = p50,
        image = p49,
        iconTextType = p48,
        topText = p51,
        botText = p52,
        interactable = p47,
        shinyIcon = p53,
        stars = p55
    });
end;

return v1;