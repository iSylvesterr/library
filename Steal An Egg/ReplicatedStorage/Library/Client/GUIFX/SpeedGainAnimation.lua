-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local Audio = require(ReplicatedStorage.Library.Audio);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Player = require(ReplicatedStorage.Library.Player);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local u1 = TweenInfo.new(0.28, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
local u2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local u4 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u5 = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
local u6 = TweenInfo.new(0.3);
local LocalPlayer = Players.LocalPlayer;
local u7 = {};
local u8 = {};
local u9 = Random.new();
local u10 = {};

local function getTemplate() -- Line: 68
    -- upvalues: GUI (copy)
    local v11 = GUI.SpeedGainAnimation();
    local v12 = v11:IsA("ScreenGui");
    assert(v12, "Speed gain animation owner must be a ScreenGui");
    local Frame = v11.Frame;
    local v13 = Frame:IsA("Frame");
    assert(v13, "Speed gain template Frame must be a Frame");

    return v11, Frame;
end;

local function setPopupTransparency(p14, p15) -- Line: 77
    for _, descendant in ipairs(p14:GetDescendants()) do
        if descendant:IsA("TextLabel") then
            descendant.TextTransparency = p15;
        elseif descendant:IsA("ImageLabel") then
            descendant.ImageTransparency = p15;
        elseif descendant:IsA("UIStroke") then
            descendant.Transparency = p15;
        end;
    end;
end;

local function getOrCreateScale(p16) -- Line: 89
    local v17 = p16:FindFirstChildOfClass("UIScale");

    if v17 then
        return v17;
    end;

    local UIScale = Instance.new("UIScale");
    UIScale.Parent = p16;

    return UIScale;
end;

local function getDefaultStartPosition(p18) -- Line: 100
    return Vector2.new(p18.X * 0.25, p18.Y);
end;

local function getTargetPosition(p19) -- Line: 104
    return p19.AbsolutePosition + p19.AbsoluteSize * 0.5;
end;

local function getControlPoint(p20, p21) -- Line: 108
    -- upvalues: UserInputService (copy), u9 (copy)
    local v22 = p21.X >= p20.X and -1 or 1;
    local v23 = UserInputService.TouchEnabled and 0.4 or 1;
    local v24 = u9:NextNumber(v23 * 90, v23 * 120);
    local v25 = u9:NextNumber(v23 * 100, v23 * 150);

    return (p20 + p21) * 0.5 + Vector2.new(v22 * v24, -v25);
end;

local function quadBezier(p26, p27, p28, p29) -- Line: 120
    local v30 = 1 - p29;

    return p26 * (v30 * v30) + p27 * (v30 * 2 * p29) + p28 * (p29 * p29);
end;

local function pulseTargetLabel(p31) -- Line: 125
    -- upvalues: TweenService (copy), u1 (copy)
    local Parent = p31.Parent;

    if Parent == nil or not Parent:IsA("GuiObject") then
        return;
    end;

    local v32 = Parent:FindFirstChildOfClass("UIScale");

    if not v32 then
        v32 = Instance.new("UIScale");
        v32.Parent = Parent;
    end;

    v32.Scale = 0.7;
    TweenService:Create(v32, u1, {
        Scale = 1
    }):Play();
end;

local function setTargetLabelPulseActive(p33, p34) -- Line: 138
    -- upvalues: u7 (copy), u8 (copy), TweenService (copy), u3 (copy), u2 (copy)
    local Parent = p33.Parent;

    if Parent == nil or not Parent:IsA("GuiObject") then
        return;
    end;

    local u35 = Parent:FindFirstChildOfClass("UIScale");

    if not u35 then
        u35 = Instance.new("UIScale");
        u35.Parent = Parent;
    end;

    if u7[u35] == p34 then
        return;
    end;

    local u36 = (u8[u35] or 0) + 1;
    u8[u35] = u36;
    u7[u35] = p34;

    if p34 then
        task.spawn(function() -- Line: 160
            -- upvalues: u8 (ref), u35 (copy), u36 (copy), TweenService (ref), u2 (ref), u3 (ref)
            while u8[u35] == u36 and u35:IsDescendantOf(game) do
                TweenService:Create(u35, u2, {
                    Scale = 1.06
                }):Play();
                task.wait(0.25);

                if u8[u35] ~= u36 or not u35:IsDescendantOf(game) then
                    break;
                end;

                TweenService:Create(u35, u3, {
                    Scale = 1
                }):Play();
                task.wait(0.25);
            end;
        end);

        return;
    end;

    TweenService:Create(u35, u3, {
        Scale = 1
    }):Play();
end;

local function completeAnimation(p37) -- Line: 179
    if p37 ~= nil then
        p37();
    end;
end;

local function showWalkPlusOne(u38, p39, p40, p41, p42) -- Line: 185
    -- upvalues: Player (copy), LocalPlayer (copy), GUI (copy), u9 (copy), TweenService (copy), u4 (copy), u5 (copy), u6 (copy), pulseTargetLabel (copy)
    local v43 = Player.Optional.HumanoidRootPart(LocalPlayer);

    if v43 == nil then
        return;
    end;

    local v44 = p40 or 1;
    local v45 = Color3.fromRGB(178, 233, 255);

    if v44 >= 100 then
        v45 = Color3.fromRGB(255, 0, 0);
    elseif v44 >= 25 then
        v45 = Color3.fromRGB(255, 67, 199);
    elseif v44 >= 9 then
        v45 = Color3.fromRGB(0, 255, 255);
    elseif v44 > 1 then
        v45 = Color3.fromRGB(255, 238, 0);
    end;

    if p41 == nil then
        p41 = v45;
    end;

    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "PlusOne";
    BillboardGui.Size = UDim2.fromScale(4.5, 1.5);
    BillboardGui.StudsOffset = Vector3.new(0, 1, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.Adornee = v43;
    BillboardGui.Parent = GUI.PlayerGui();
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.new(0, 0, 0, 0);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = BillboardGui;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.05, 0);
    UIListLayout.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Size = UDim2.fromScale(0.3, 0.8);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://99458650446228";
    ImageLabel.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.AspectRatio = 1;
    UIAspectRatioConstraint.Parent = ImageLabel;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Size = UDim2.fromScale(0.6, 0.9);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.TextColor3 = p41;
    TextLabel.Text = p39;
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBlack;
    TextLabel.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 2;
    UIStroke.Parent = TextLabel;
    local v46 = u9:NextInteger(-4, 4);
    local v47 = u9:NextInteger(3, 5);
    local u48 = Vector3.new(v46, v47, u9:NextInteger(-2, 2));
    TweenService:Create(Frame, u4, {
        Size = UDim2.fromScale(1, 1)
    }):Play();
    TweenService:Create(BillboardGui, u5, {
        StudsOffset = u48
    }):Play();

    if p42 ~= nil then
        p42();
    end;

    task.delay(0.5, function() -- Line: 272
        -- upvalues: TweenService (ref), TextLabel (copy), u6 (ref), ImageLabel (copy), UIStroke (copy), BillboardGui (copy), u48 (copy), pulseTargetLabel (ref), u38 (copy)
        TweenService:Create(TextLabel, u6, {
            TextTransparency = 1
        }):Play();
        TweenService:Create(ImageLabel, u6, {
            ImageTransparency = 1
        }):Play();
        TweenService:Create(UIStroke, u6, {
            Transparency = 1
        }):Play();
        TweenService:Create(BillboardGui, u6, {
            StudsOffset = u48 + Vector3.new(0, -1, 0)
        }):Play();
        task.delay(0.35, function() -- Line: 285
            -- upvalues: pulseTargetLabel (ref), u38 (ref), BillboardGui (ref)
            pulseTargetLabel(u38);
            BillboardGui:Destroy();
        end);
    end);
end;

local function playSpeedGainTemplate(p49, p50, p51, p52, p53, p54, p55, p56, p57) -- Line: 292
    -- upvalues: Workspace (copy), GUI (copy), getControlPoint (copy), setPopupTransparency (copy), Audio (copy), RunService (copy), pulseTargetLabel (copy)
    if p50 <= 0 then
        if p57 ~= nil then
            p57();
        end;

        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera == nil then
        if p57 ~= nil then
            p57();
        end;

        return;
    end;

    local v58 = GUI.SpeedGainAnimation();
    local v59 = v58:IsA("ScreenGui");
    assert(v59, "Speed gain animation owner must be a ScreenGui");
    local Frame = v58.Frame;
    local v60 = Frame:IsA("Frame");
    assert(v60, "Speed gain template Frame must be a Frame");
    local v61 = Frame:Clone();
    v61.Name = p51;
    v61.Visible = true;
    v61.AnchorPoint = Vector2.new(0.5, 0.5);
    local CurrentBoost = v61.CurrentBoost;
    local v62 = CurrentBoost:IsA("TextLabel");
    assert(v62, "Speed gain popup CurrentBoost must be a TextLabel");
    local v63 = CurrentBoost:FindFirstChildOfClass("UIScale");

    if not v63 then
        v63 = Instance.new("UIScale");
        v63.Parent = CurrentBoost;
    end;

    CurrentBoost.Text = p52;
    v63.Scale = 0.72;
    local v64 = p55 or 1;
    local ViewportSize = CurrentCamera.ViewportSize;
    local v65;

    if p56 and p56.StartPosition ~= nil then
        v65 = p56.StartPosition;
    else
        v65 = Vector2.new(ViewportSize.X * 0.25, ViewportSize.Y);
    end;

    local v66 = p49.AbsolutePosition + p49.AbsoluteSize * 0.5;
    local v67 = getControlPoint(v65, v66);
    v61.Position = UDim2.fromOffset(v65.X, v65.Y);
    v61.Parent = v58;
    setPopupTransparency(v61, 0);

    if p53 then
        Audio.Play(p53, script, v64);
    end;

    local v68 = os.clock();
    local v69 = 0;

    while v69 < 1 and v61.Parent ~= nil do
        local v70 = (os.clock() - v68) / 0.85;
        v69 = math.min(v70, 1);
        local v71 = 1 - v69;
        local v72 = v65 * (v71 * v71) + v67 * (v71 * 2 * v69) + v66 * (v69 * v69);
        local v73 = math.clamp((v69 - 0.72) / 0.28, 0, 1);
        v61.Position = UDim2.fromOffset(v72.X, v72.Y);
        v63.Scale = math.sin(v69 * 3.141592653589793) * 0.18 + 0.72;
        setPopupTransparency(v61, v73);
        RunService.RenderStepped:Wait();
    end;

    if v61.Parent == nil then
        if p57 ~= nil then
            p57();
        end;

        return;
    end;

    if p54 then
        Audio.Play(p54, script);
    end;

    pulseTargetLabel(p49);
    v61:Destroy();

    if p57 ~= nil then
        p57();
    end;
end;

function u10.HideTemplate() -- Line: 373
    -- upvalues: GUI (copy)
    local v74 = GUI.SpeedGainAnimation();
    local v75 = v74:IsA("ScreenGui");
    assert(v75, "Speed gain animation owner must be a ScreenGui");
    local Frame = v74.Frame;
    local v76 = Frame:IsA("Frame");
    assert(v76, "Speed gain template Frame must be a Frame");
    Frame.Visible = false;
end;

function u10.Play(p77, p78, p79, p80) -- Line: 378
    -- upvalues: playSpeedGainTemplate (copy), TreadmillUtil (copy)
    playSpeedGainTemplate(p77, p78, "SpeedGainPopup", "+" .. TreadmillUtil.FormatSpeedPower(p78) .. " Speed", nil, nil, 1, {
        StartPosition = p79
    }, p80);
end;

function u10.ShowPlusOne(p81, p82, p83, p84) -- Line: 399
    -- upvalues: showWalkPlusOne (copy), TreadmillUtil (copy)
    if p82 <= 0 then
        if p84 ~= nil then
            p84();
        end;

        return;
    end;

    showWalkPlusOne(p81, "+" .. TreadmillUtil.FormatSpeedPower((math.round(p82))), p82, p83, p84);
end;

function u10.SetTargetLabelPulseActive(p85, p86) -- Line: 419
    -- upvalues: setTargetLabelPulseActive (copy)
    setTargetLabelPulseActive(p85, p86);
end;

function u10.PlayWalk(p87, p88, p89, p90) -- Line: 423
    -- upvalues: u10 (copy)
    u10.ShowPlusOne(p87, p88, p89, p90);
end;

return u10;