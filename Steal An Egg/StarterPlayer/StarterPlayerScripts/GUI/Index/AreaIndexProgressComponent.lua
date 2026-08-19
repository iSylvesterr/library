-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Gears = require(ReplicatedStorage.Directory.Gears);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Types.Interface);
local u1 = {};
u1.__index = u1;
u1.__class = "AreaIndexProgressComponent";
local u2 = Color3.fromRGB(0, 182, 24);
local u3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

function u1.new(p4, p5) -- Line: 42
    -- upvalues: u1 (copy), Trove (copy)
    local v6 = setmetatable({}, u1);
    v6._view = p4;
    v6._onAction = p5;
    v6._sectionId = nil;
    v6._actionEnabled = false;
    v6._defaultEquipBatButtonColor = p4.EquipBat.TextButton.BackgroundColor3;
    v6._defaultEquipBatButtonText = p4.EquipBat.TextLabelFrame.TextLabel.Text;
    v6._progressTween = nil;
    v6._trove = Trove.new();
    v6:_init();

    return v6;
end;

function u1._setProgress(p7, p8) -- Line: 60
    -- upvalues: TweenService (copy), u3 (copy)
    local _progressTween = p7._progressTween;

    if _progressTween then
        _progressTween:Cancel();
        _progressTween:Destroy();
    end;

    local v9 = TweenService:Create(p7._view.ProgressBar.Progress.Fill, u3, {
        Size = UDim2.fromScale(p8, 1)
    });
    p7._progressTween = v9;
    v9:Play();
end;

function u1._render(p10, p11, p12, p13, p14, p15, p16, p17, p18) -- Line: 74
    -- upvalues: Asserts (copy), Gears (copy), u2 (copy)
    Asserts.string(p11);
    Asserts.string(p12);
    Asserts.number(p13);
    Asserts.number(p14);
    Asserts.string(p15);
    Asserts.boolean(p16);
    Asserts.boolean(p17);
    Asserts.boolean(p18);
    p10._sectionId = p11;
    p10._actionEnabled = p18;
    local _view = p10._view;
    local v19 = Gears.Directory[p12];
    local v20;

    if p14 > 0 then
        v20 = p14 <= p13;
    else
        v20 = false;
    end;

    local v21 = p14 == 0 and 0 or math.clamp(p13 / p14, 0, 1);
    _view.ProgressBar.ProgressText.TextLabel.Text = `{p13}/{p14}`;
    _view.ProgressBar.BatImage.Image = v19.Icon;
    _view.EquipBat.BatImage.Image = v19.Icon;
    local v22;

    if p16 then
        v22 = u2;
    else
        v22 = p10._defaultEquipBatButtonColor;
    end;

    _view.EquipBat.TextButton.BackgroundColor3 = v22;
    _view.EquipBat.TextLabelFrame.TextLabel.Text = p15;
    _view.ProgressBar.Visible = not v20;
    _view.EquipBat.Visible = v20;
    _view.EquipBat.NotificationBadge.Visible = v20 and p17;
    p10:_setProgress(v21);
end;

function u1.RenderAreaBat(p23, p24, p25, p26, p27, p28, p29) -- Line: 118
    -- upvalues: Asserts (copy)
    Asserts.string(p24);
    Asserts.string(p25);
    Asserts.number(p26);
    Asserts.number(p27);
    Asserts.boolean(p28);
    Asserts.boolean(p29);
    p23:_render(p24, p25, p26, p27, p29 and "Equipped" or p23._defaultEquipBatButtonText, p29, not p28, not p29);
end;

function u1.RenderGearClaim(p30, p31, p32, p33, p34, p35) -- Line: 146
    -- upvalues: Asserts (copy)
    Asserts.boolean(p35);
    p30:_render(p31, p32, p33, p34, p35 and "CLAIMED!" or "CLAIM!", p35, not p35, not p35);
end;

function u1.Destroy(p36) -- Line: 168
    local _progressTween = p36._progressTween;

    if _progressTween then
        _progressTween:Cancel();
        _progressTween:Destroy();
        p36._progressTween = nil;
    end;

    p36._trove:Destroy();
end;

function u1._init(u37) -- Line: 182
    -- upvalues: ButtonFX (copy)
    u37._trove:Add(ButtonFX(u37._view.EquipBat, nil, function() -- Line: 183
        -- upvalues: u37 (copy)
        local _sectionId = u37._sectionId;

        if _sectionId ~= nil and u37._actionEnabled then
            u37._onAction(_sectionId);
        end;
    end));
end;

return u1;