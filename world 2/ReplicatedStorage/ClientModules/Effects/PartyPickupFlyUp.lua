-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ScreenResolution = require(ReplicatedStorage.ClientModules.ScreenResolution);
local u1 = Vector2.new(0.5, 0.75);
local u2 = Vector2.new(0.5, 0.42);
local u3 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold);
local u4 = Color3.fromRGB(8, 45, 0);
local u5 = {};
local u6 = nil;

local function GetHolder() -- Line: 121
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer:FindFirstChildOfClass("PlayerGui");
    end;

    if not LocalPlayer then
        return nil;
    end;

    local PartyPickupFlyUpGui = LocalPlayer:FindFirstChild("PartyPickupFlyUpGui");

    if PartyPickupFlyUpGui and PartyPickupFlyUpGui:IsA("ScreenGui") then
        return PartyPickupFlyUpGui;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "PartyPickupFlyUpGui";
    ScreenGui.DisplayOrder = 999;
    ScreenGui.IgnoreGuiInset = false;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = LocalPlayer;

    return ScreenGui;
end;

local function CentreOf(p7) -- Line: 142
    return p7.AbsolutePosition + p7.AbsoluteSize * 0.5;
end;

local function ResolveStart(p8, p9) -- Line: 150
    -- upvalues: Players (copy), u1 (copy)
    local v10 = Players.LocalPlayer and Players.LocalPlayer.Character;

    if v10 then
        v10 = v10:FindFirstChild("HumanoidRootPart");
    end;

    if v10 and v10:IsA("BasePart") then
        local v11, v12 = p8:WorldToScreenPoint(v10.Position);

        if v12 or v11.Z > 0 then
            return Vector2.new(math.clamp(v11.X, 0, p9.X), (math.clamp(v11.Y, 0, p9.Y)));
        end;
    end;

    return p9 * u1;
end;

local function Finish(p13) -- Line: 165
    p13.Label:Destroy();
end;

local function ProgressOf(p14) -- Line: 172
    local Elapsed = p14.Elapsed;
    local Hold = p14.Hold;
    local v15;

    if Hold > 0 then
        v15 = p14.Duration * 0.34;

        if v15 < Elapsed then
            if Elapsed >= v15 + Hold then
                v15 = Elapsed - Hold;
            end;
        else
            v15 = Elapsed;
        end;
    else
        v15 = Elapsed;
    end;

    return math.clamp(v15 / p14.Duration, 0, 1);
end;

local function Step(p16, p17) -- Line: 186
    p16.Elapsed = p16.Elapsed + p17;
    local Elapsed = p16.Elapsed;
    local Hold = p16.Hold;
    local v18;

    if Hold > 0 then
        v18 = p16.Duration * 0.34;

        if v18 < Elapsed then
            if Elapsed >= v18 + Hold then
                v18 = Elapsed - Hold;
            end;
        else
            v18 = Elapsed;
        end;
    else
        v18 = Elapsed;
    end;

    local v19 = math.clamp(v18 / p16.Duration, 0, 1);
    local Target = p16.Target;
    local Finish2 = p16.Finish;

    if Target then
        if not Target.Parent then
            return false;
        end;

        Finish2 = Target.AbsolutePosition + Target.AbsoluteSize * 0.5;
    end;

    local v20 = math.clamp(v19 / p16.TravelTime, 0, 1);
    local v21 = v20 * v20 * (3 - v20 * 2);
    local v22 = 1 - v21;
    local v23 = v22 * v22 * p16.Start + v22 * 2 * v21 * p16.Control + v21 * v21 * Finish2;
    local v24;

    if v19 < 0.16 then
        v24 = math.sin(v19 / 0.16 * 3.141592653589793 * 0.5) * 1.2;
    elseif v19 < 0.34 then
        v24 = (v19 - 0.16) / 0.18000000000000002 * -0.19999999999999996 + 1.2;
    else
        local v25 = (v19 - 0.34) / 0.6599999999999999;
        v24 = 1 - (1 - p16.EndScale) * v25 * v25;
    end;

    local v26 = p16.Size * v24;
    local Label = p16.Label;
    local v27 = math.clamp((v19 - 0.8) / 0.2, 0, 1);
    Label.Position = UDim2.fromOffset(v23.X, v23.Y);
    Label.Size = UDim2.fromOffset(v26, v26);
    Label.Rotation = math.sin(v19 * 3.141592653589793) * p16.Tilt;
    Label.ImageTransparency = v27;
    local Caption = p16.Caption;

    if Caption then
        Caption.TextTransparency = v27;
    end;

    local CaptionStroke = p16.CaptionStroke;

    if CaptionStroke then
        CaptionStroke.Transparency = v27;
    end;

    return v19 < 1;
end;

local function Update(p28) -- Line: 242
    -- upvalues: u5 (copy), Step (copy), u6 (ref)
    for i = #u5, 1, -1 do
        local v29 = u5[i];

        if not Step(v29, p28) then
            v29.Label:Destroy();
            table.remove(u5, i);
        end;
    end;

    if #u5 == 0 and u6 then
        u6:Disconnect();
        u6 = nil;
    end;
end;

local function BuildCaption(p30, p31, p32) -- Line: 259
    -- upvalues: u3 (copy), u4 (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Caption";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.FontFace = u3;
    TextLabel.Position = UDim2.fromScale(0.5, 1.02);
    TextLabel.Size = UDim2.fromScale(2.4, 0.3);
    TextLabel.Text = p31;
    TextLabel.TextColor3 = p32 or Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 3;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = u4;
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.08;
    UIStroke.Parent = TextLabel;
    TextLabel.Parent = p30;

    return TextLabel, UIStroke;
end;

return table.freeze({
    Play = function(p33) -- Line: 294, Name: Play
        -- upvalues: GetHolder (copy), ResolveStart (copy), u2 (copy), BuildCaption (copy), ScreenResolution (copy), u5 (copy), u6 (ref), RunService (copy), Update (copy)
        local CurrentCamera = workspace.CurrentCamera;
        local v34 = GetHolder();

        if not (CurrentCamera and v34) then
            return;
        end;

        local Target = p33.Target;

        if Target and not Target.Parent then
            return;
        end;

        local Origin = p33.Origin;

        if Origin and not Origin.Parent then
            Origin = nil;
        end;

        local ViewportSize = CurrentCamera.ViewportSize;
        local v35;

        if Origin then
            v35 = Origin.AbsolutePosition + Origin.AbsoluteSize * 0.5;
        else
            v35 = ResolveStart(CurrentCamera, ViewportSize);
        end;

        local v36;

        if Target then
            v36 = Target.AbsolutePosition + Target.AbsoluteSize * 0.5;
        else
            v36 = ViewportSize * u2;
        end;

        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Name = "Pickup";
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.BorderSizePixel = 0;
        ImageLabel.Image = p33.Image or "rbxassetid://128109373522532";
        ImageLabel.Position = UDim2.fromOffset(v35.X, v35.Y);
        ImageLabel.Size = UDim2.fromOffset(0, 0);
        ImageLabel.ZIndex = 2;
        ImageLabel.Parent = v34;
        local v37, v38;

        if p33.Text and p33.Text ~= "" then
            v37, v38 = BuildCaption(ImageLabel, p33.Text, p33.TextColor);
        else
            v37 = nil;
            v38 = nil;
        end;

        local v39 = p33.Tilt or 22;
        local v40 = p33.Hold or 0;
        local v41 = {
            Elapsed = 0,
            Label = ImageLabel,
            Caption = v37,
            CaptionStroke = v38,
            Target = Target,
            Start = v35,
            Control = Vector2.new((v35.X + v36.X) * 0.5 + (math.random() * 2 - 1) * ViewportSize.X * 0.07, math.min(v35.Y, v36.Y) - ViewportSize.Y * 0.16),
            Finish = v36
        };

        if math.random() < 0.5 then
            v39 = -v39;
        end;

        v41.Tilt = v39;
        v41.Size = (p33.Size or 70) * ScreenResolution.GetResolutionScale();
        v41.Duration = p33.Duration or 0.75;
        v41.Hold = v40;
        v41.TravelTime = v40 > 0 and 0.34 or 1;
        v41.EndScale = Target and 0.3 or 1.15;
        table.insert(u5, v41);

        if not u6 then
            u6 = RunService.RenderStepped:Connect(Update);
        end;
    end
});