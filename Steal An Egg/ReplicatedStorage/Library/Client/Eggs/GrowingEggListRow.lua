-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
require(ReplicatedStorage.Library.Client.Eggs.Types);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Color3.fromRGB(166, 255, 111);
local u2 = TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local v3 = {};

local function stopPulse(p4) -- Line: 28
    local PulseTween = p4.PulseTween;
    p4.PulseTween = nil;

    if PulseTween ~= nil then
        PulseTween:Cancel();
        PulseTween:Destroy();
    end;

    p4.HatchButton.BackgroundColor3 = p4.OriginalHatchColor;
end;

local function startPulse(p5) -- Line: 39
    -- upvalues: TweenService (copy), u2 (copy), u1 (copy)
    if p5.PulseTween ~= nil then
        return;
    end;

    local v6 = TweenService:Create(p5.HatchButton, u2, {
        BackgroundColor3 = u1
    });
    p5.PulseTween = v6;
    v6:Play();
end;

local function updateButtonState(p7, p8, p9) -- Line: 51
    -- upvalues: TweenService (copy), u2 (copy), u1 (copy)
    p7.GrowButton.Visible = not p8 and p9;
    p7.GrowButton.Active = not p8 and p9;
    p7.HatchButton.Visible = p8;
    p7.HatchButton.Active = p8;

    if p8 then
        if p7.PulseTween ~= nil then
            return;
        end;

        local v10 = TweenService:Create(p7.HatchButton, u2, {
            BackgroundColor3 = u1
        });
        p7.PulseTween = v10;
        v10:Play();

        return;
    end;

    local PulseTween = p7.PulseTween;
    p7.PulseTween = nil;

    if PulseTween ~= nil then
        PulseTween:Cancel();
        PulseTween:Destroy();
    end;

    p7.HatchButton.BackgroundColor3 = p7.OriginalHatchColor;
end;

function v3.Mount(p11, p12, u13, u14, u15) -- Line: 68
    -- upvalues: Trove (copy)
    local v16 = p11:Clone();
    v16.Name = u13;
    v16.Visible = true;
    v16.Parent = p12;
    local GrowButton = v16.Main_Frame.BevelEffect.GrowButton;
    local HatchButton = v16.Main_Frame.HatchButton;
    HatchButton.Visible = false;
    local v17 = Trove.new();
    local u18 = {
        PulseTween = nil,
        Uid = u13,
        Root = v16,
        GrowButton = GrowButton,
        HatchButton = HatchButton,
        OriginalHatchColor = HatchButton.BackgroundColor3,
        Trove = v17
    };
    v17:Add(v16);
    v17:Add(function() -- Line: 96
        -- upvalues: u18 (copy)
        local v19 = u18;
        local PulseTween = v19.PulseTween;
        v19.PulseTween = nil;

        if PulseTween ~= nil then
            PulseTween:Cancel();
            PulseTween:Destroy();
        end;

        v19.HatchButton.BackgroundColor3 = v19.OriginalHatchColor;
    end);
    v17:Connect(GrowButton.Activated, function() -- Line: 99
        -- upvalues: u14 (copy), u13 (copy)
        u14(u13);
    end);
    v17:Connect(HatchButton.Activated, function() -- Line: 102
        -- upvalues: u15 (copy), u13 (copy)
        u15(u13);
    end);

    return u18;
end;

function v3.Update(p20, p21, p22, p23, p24, p25) -- Line: 109
    -- upvalues: TweenService (copy), u2 (copy), u1 (copy)
    local Main_Frame = p20.Root.Main_Frame;
    Main_Frame.Image.Image = p21;
    Main_Frame.ProgressBar.Frame.Size = UDim2.fromScale(p22, 1);
    Main_Frame.ProgressBar.TextLabel.Text = p23;
    Main_Frame.ProgressBar.Visible = not p24;
    p20.GrowButton.Visible = not p24 and p25;
    p20.GrowButton.Active = not p24 and p25;
    p20.HatchButton.Visible = p24;
    p20.HatchButton.Active = p24;

    if p24 then
        if p20.PulseTween ~= nil then
            return;
        end;

        local v26 = TweenService:Create(p20.HatchButton, u2, {
            BackgroundColor3 = u1
        });
        p20.PulseTween = v26;
        v26:Play();

        return;
    end;

    local PulseTween = p20.PulseTween;
    p20.PulseTween = nil;

    if PulseTween ~= nil then
        PulseTween:Cancel();
        PulseTween:Destroy();
    end;

    p20.HatchButton.BackgroundColor3 = p20.OriginalHatchColor;
end;

function v3.Destroy(p27) -- Line: 126
    p27.Trove:Destroy();
end;

return v3;