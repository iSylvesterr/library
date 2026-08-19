-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local MoneyPiles = require(script.Parent.MoneyPiles);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
u1.__index = u1;
u1.__class = "OfflineMoneyClaimVisual";
local u2 = Color3.new(1, 1, 1);
local Assets = ReplicatedStorage.Assets;
local ClaimArea = Assets.Models.ClaimArea;
local v3 = ClaimArea:IsA("BasePart");
assert(v3, "ReplicatedStorage.Assets.Models.ClaimArea must be a BasePart");
local OfflineCash = Assets.Billboards.OfflineCash;
local v4 = OfflineCash:IsA("BillboardGui");
assert(v4, "ReplicatedStorage.Assets.Billboards.OfflineCash must be a BillboardGui");

function u1.new(p5, p6, p7) -- Line: 58
    -- upvalues: Asserts (copy), u1 (copy), Trove (copy), ClaimArea (copy), MoneyPiles (copy), OfflineCash (copy)
    Asserts.finiteNonNegative(p5);
    Asserts.BasePart(p6);
    Asserts.Instance(p7);
    local u8 = setmetatable({}, u1);
    local v9 = Trove.new();
    local Model = Instance.new("Model");
    Model.Name = "LocalOfflineMoneyClaim";
    Model.Parent = p7;
    local v10 = ClaimArea:Clone();
    v10.Name = "OfflineMoneyClaimArea";
    v10.CFrame = p6.CFrame + Vector3.new(0, 0.2, 0);
    v10.Anchored = true;
    v10.CanCollide = false;
    v10.CanTouch = false;
    v10.CanQuery = false;
    v10.Parent = Model;
    local u11 = MoneyPiles.new(v10, Model);
    local v12 = OfflineCash:Clone();
    v12.Name = "OfflineMoneyClaimBillboard";
    v12.AlwaysOnTop = true;
    v12.Parent = v10;
    v12.Enabled = true;
    local Money = v12.Money;
    local v13;

    if Money then
        v13 = Money:IsA("TextLabel");
    else
        v13 = Money;
    end;

    assert(v13, "OfflineCash.Money must be a TextLabel");
    u8._trove = v9;
    u8._amount = p5;
    u8._rootModel = Model;
    u8._claimArea = v10;
    u8._generatedMoney = u11;
    u8._billboard = v12;
    u8._billboardBaseSize = v12.Size;
    u8._billboardPulseTween = nil;
    u8._billboardTextBlinkTween = nil;
    u8._billboardPulseActive = false;
    u8._moneyLabel = Money;
    u8._moneyLabelBaseTextColor = u8._moneyLabel.TextColor3;
    v9:Add(Model);
    v9:Add(function() -- Line: 102
        -- upvalues: u11 (copy)
        u11:Destroy();
    end);
    v9:Add(u11.BillboardAdorneeChanged:Connect(function() -- Line: 105
        -- upvalues: u8 (copy)
        u8:_syncBillboardAdornee();
    end));
    u8:Update(p5, p6);

    return u8;
end;

function u1._formatMoney(p14) -- Line: 118
    -- upvalues: Simple (copy)
    return "$" .. Simple.FormatCompact(math.max(p14, 0), "precision-integer");
end;

function u1._scaleBillboardSize(p15, p16) -- Line: 122
    return UDim2.new(p15.X.Scale * p16, math.round(p15.X.Offset * p16), p15.Y.Scale * p16, (math.round(p15.Y.Offset * p16)));
end;

function u1._stopBillboardPulse(p17) -- Line: 131
    p17._billboardPulseActive = false;
    local _billboardPulseTween = p17._billboardPulseTween;

    if _billboardPulseTween then
        _billboardPulseTween:Cancel();
        p17._billboardPulseTween = nil;
    end;

    local _billboardTextBlinkTween = p17._billboardTextBlinkTween;

    if _billboardTextBlinkTween then
        _billboardTextBlinkTween:Cancel();
        p17._billboardTextBlinkTween = nil;
    end;

    p17._billboard.Size = p17._billboardBaseSize;
    p17._moneyLabel.TextColor3 = p17._moneyLabelBaseTextColor;
end;

function u1._syncBillboardPulse(p18) -- Line: 148
    -- upvalues: TweenService (copy), u1 (copy), u2 (copy)
    if not (p18._billboard.Enabled and p18._amount > 0) then
        p18:_stopBillboardPulse();

        return;
    end;

    if p18._billboardPulseActive then
        return;
    end;

    p18._billboardPulseActive = true;
    p18._billboard.Size = p18._billboardBaseSize;
    p18._moneyLabel.TextColor3 = p18._moneyLabelBaseTextColor;
    local v19 = TweenService:Create(p18._billboard, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, -1, true), {
        Size = u1._scaleBillboardSize(p18._billboardBaseSize, 1.75)
    });
    local v20 = TweenService:Create(p18._moneyLabel, TweenInfo.new(0.6400000000000001, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), {
        TextColor3 = u2
    });
    p18._billboardPulseTween = v19;
    p18._billboardTextBlinkTween = v20;
    v19:Play();
    v20:Play();
end;

function u1._syncBillboardAdornee(p21) -- Line: 183
    -- upvalues: OfflineCash (copy)
    p21._billboard.AlwaysOnTop = true;
    local v22 = p21._generatedMoney:GetBillboardAdornee();

    if v22 then
        p21._billboard.Adornee = v22;
        p21._billboard.StudsOffset = OfflineCash.StudsOffset;

        return;
    end;

    p21._billboard.Adornee = p21._claimArea;
    p21._billboard.StudsOffset = Vector3.new(0, 6, 0);
end;

function u1._syncBillboardText(p23) -- Line: 195
    -- upvalues: u1 (copy)
    p23._moneyLabel.RichText = true;
    p23._moneyLabel.Text = `OFFLINE CLAIM! <br/>{u1._formatMoney(p23._amount)}`;
end;

function u1.Update(p24, p25, p26) -- Line: 204
    -- upvalues: Asserts (copy)
    Asserts.finiteNonNegative(p25);
    Asserts.BasePart(p26);
    p24._amount = p25;
    p24._claimArea.CFrame = p26.CFrame + Vector3.new(0, 0.2, 0);
    p24._generatedMoney:UpdateInstant(p25, true);
    p24:_syncBillboardText();
    p24:_syncBillboardAdornee();
    p24._billboard.Enabled = p25 > 0;
    p24:_syncBillboardPulse();
end;

function u1.SetBillboardEnabled(p27, p28) -- Line: 217
    -- upvalues: Asserts (copy)
    Asserts.boolean(p28);

    if p28 then
        p28 = p27._amount > 0;
    end;

    p27._billboard.Enabled = p28;
    p27:_syncBillboardPulse();
end;

function u1.ContainsWorldPosition(p29, p30) -- Line: 223
    -- upvalues: Asserts (copy)
    Asserts.Vector3(p30);
    local v31 = p29._claimArea.CFrame:PointToObjectSpace(p30);
    local v32 = p29._claimArea.Size * 0.5;

    if not p29._claimArea:IsA("Part") or p29._claimArea.Shape ~= Enum.PartType.Cylinder then
        local v33;

        if math.abs(v31.X) < v32.X then
            v33 = math.abs(v31.Z) < v32.Z;
        else
            v33 = false;
        end;

        return v33;
    end;

    local v34 = math.abs(v31.X) < v32.X;
    local v35 = math.min(v32.Y, v32.Z);
    local v36 = v31.Y * v31.Y + v31.Z * v31.Z;

    if v34 then
        v34 = v36 < v35 * v35;
    end;

    return v34;
end;

function u1.PlayClaim(p37) -- Line: 240
    p37._billboard.Enabled = false;
    p37:_stopBillboardPulse();
    p37._generatedMoney:PlayCollectReset();
end;

function u1.Destroy(p38) -- Line: 246
    p38:_stopBillboardPulse();
    p38._trove:Destroy();
end;

return u1;