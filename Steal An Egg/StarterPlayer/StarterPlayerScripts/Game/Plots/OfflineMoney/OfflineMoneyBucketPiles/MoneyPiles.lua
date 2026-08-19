-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Emit = require(ReplicatedStorage.Library.Functions.Emit);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
u1.__index = u1;
u1.__class = "OfflineGeneratedMoney";
local u2 = Color3.new(1, 1, 1);
local u3 = Log.new();
local BuckPiles = ReplicatedStorage.Assets.Models.BuckPiles;
local v4 = BuckPiles:IsA("Folder");
assert(v4, "ReplicatedStorage.Assets.Models.BuckPiles must be a Folder");
local MoneyCollect = ReplicatedStorage.Assets.VFX.MoneyCollect;
local v5 = MoneyCollect:IsA("Folder");
assert(v5, "ReplicatedStorage.Assets.VFX.MoneyCollect must be a Folder");

function u1.new(u6, p7) -- Line: 75
    -- upvalues: Asserts (copy), u1 (copy), Trove (copy), Signal (copy), BuckPiles (copy)
    Asserts.BasePart(u6);
    Asserts.Instance(p7);
    local u8 = setmetatable({}, u1);
    local Folder = Instance.new("Folder");
    Folder.Name = "LocalOfflineGeneratedMoneyPiles";
    Folder.Parent = p7;
    local v9 = Trove.new();
    u8._trove = v9;
    u8._animationTrove = Trove.new();
    u8._bucketRoot = u6;
    u8._runtimeFolder = Folder;
    u8._stages = {};
    u8._currentStageIndex = 0;
    u8._lastStageCenterCFrame = nil;
    u8._destroyed = false;
    u8._lastAdornee = nil;
    u8.BillboardAdorneeChanged = Signal.new();
    v9:Add(Folder);
    v9:Add(u8._animationTrove);
    v9:Add(u6:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line: 99
        -- upvalues: u8 (copy), u1 (ref), u6 (copy)
        for _, v in ipairs(u8._stages) do
            u1._pivotRootToBucket(v.model, v.rootPart, u6);
        end;
    end));
    local v10 = {};

    for _, child in ipairs(BuckPiles:GetChildren()) do
        if child:IsA("Model") then
            v10[#v10 + 1] = child;
        end;
    end;

    table.sort(v10, function(p11, p12) -- Line: 112
        -- upvalues: u1 (ref)
        return u1._getStageSortIndex(p11) < u1._getStageSortIndex(p12);
    end);
    assert(#v10 == 3, "BuckPiles must contain exactly three stage models");

    for _, v in ipairs(v10) do
        u8._stages[#u8._stages + 1] = u8:_buildStage(v);
    end;

    u8:_hideAllStages();

    return u8;
end;

function u1._getStageSortIndex(p13) -- Line: 130
    local v14 = tonumber(p13.Name);
    local v15 = `BuckPiles stage {p13.Name} must be numerically named`;
    assert(v14, v15);

    return v14;
end;

function u1._readVector3Attribute(p16, p17) -- Line: 136
    -- upvalues: Asserts (copy)
    local v18 = p16:GetAttribute(p17);
    Asserts.Vector3(v18);

    return v18;
end;

function u1._readCFrameAttribute(p19, p20) -- Line: 142
    -- upvalues: Asserts (copy)
    local v21 = p19:GetAttribute(p20);
    Asserts.CFrame(v21);

    return v21;
end;

function u1._getVisibleTransparency(p22) -- Line: 148
    return p22.Transparency >= 1 and 0 or p22.Transparency;
end;

function u1._pivotRootToBucket(p23, p24, p25) -- Line: 152
    local v26 = p23:GetPivot();
    p23:PivotTo(p25.CFrame * p24.CFrame:Inverse() * v26);
end;

function u1._createTopAttachment(p27) -- Line: 158
    -- upvalues: Asserts (copy)
    local GeneratedMoneyTopAttachment = p27:FindFirstChild("GeneratedMoneyTopAttachment");

    if GeneratedMoneyTopAttachment then
        Asserts.Attachment(GeneratedMoneyTopAttachment);

        return GeneratedMoneyTopAttachment;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "GeneratedMoneyTopAttachment";
    Attachment.Parent = p27;

    return Attachment;
end;

function u1._createHighlight(p28) -- Line: 171
    -- upvalues: u2 (copy)
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "OfflineMoneyBucketHighlight";
    Highlight.Adornee = p28;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = u2;
    Highlight.OutlineTransparency = 0;
    Highlight.Enabled = false;
    Highlight.Parent = p28;

    return Highlight;
end;

function u1._syncTopAttachment(p29) -- Line: 184
    local v30, v31 = p29.model:GetBoundingBox();
    p29.topAttachment.Position = p29.mainPart.CFrame:PointToObjectSpace(v30.Position + v30.UpVector * (v31.Y * 0.5));
end;

function u1._collectAnimatedParts(p32, p33) -- Line: 190
    -- upvalues: u1 (copy), u3 (copy)
    local v34 = {};

    for _, descendant in ipairs(p32:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant ~= p33 and (descendant:GetAttribute("OriginalSize") ~= nil or (descendant:GetAttribute("TargetSize") ~= nil or (descendant:GetAttribute("OriginalCFrame") ~= nil or descendant:GetAttribute("TargetCFrame") ~= nil))) then
            v34[#v34 + 1] = {
                part = descendant,
                originalSize = u1._readVector3Attribute(descendant, "OriginalSize"),
                targetSize = u1._readVector3Attribute(descendant, "TargetSize"),
                originalCFrame = u1._readCFrameAttribute(descendant, "OriginalCFrame"),
                targetCFrame = u1._readCFrameAttribute(descendant, "TargetCFrame"),
                visibleTransparency = u1._getVisibleTransparency(descendant)
            };
        end;
    end;

    if #v34 == 0 then
        u3:AtWarning():Log((`BuckPiles stage {p32.Name} has no animated part attributes`));
    end;

    return v34;
end;

function u1._setStageVisible(p35, p36) -- Line: 220
    for _, descendant in ipairs(p35.model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if descendant == p35.rootPart then
                descendant.Transparency = 1;
            else
                local v37 = descendant:GetAttribute("_OfflineGeneratedMoneyVisibleTransparency");
                descendant.Transparency = (not p36 or typeof(v37) ~= "number") and 1 or v37;
            end;
        end;
    end;

    p35.highlight.Enabled = p36;
end;

function u1._resetStageParts(p38) -- Line: 237
    -- upvalues: u1 (copy)
    local CFrame = p38.rootPart.CFrame;

    for _, v in ipairs(p38.animatedParts) do
        v.part.Size = v.originalSize;
        v.part.CFrame = CFrame * v.originalCFrame;
    end;

    u1._syncTopAttachment(p38);
end;

function u1._applyStageAlpha(p39, p40) -- Line: 247
    -- upvalues: u1 (copy)
    local v41 = math.clamp(p40, 0, 1);
    local CFrame = p39.rootPart.CFrame;

    for _, v in ipairs(p39.animatedParts) do
        v.part.Size = v.originalSize:Lerp(v.targetSize, v41);
        v.part.CFrame = CFrame * v.originalCFrame:Lerp(v.targetCFrame, v41);
        v.part.Transparency = v.visibleTransparency;
    end;

    u1._syncTopAttachment(p39);
end;

function u1._buildStage(p42, p43) -- Line: 261
    -- upvalues: Asserts (copy), u1 (copy)
    local v44 = p43:Clone();
    v44.Name = `OfflineGeneratedMoneyStage{p43.Name}`;
    v44.Parent = p42._runtimeFolder;
    local RootPart = v44:FindFirstChild("RootPart");
    Asserts.BasePart(RootPart);
    local Main = v44:FindFirstChild("Main");
    Asserts.BasePart(Main);
    v44.PrimaryPart = RootPart;
    u1._pivotRootToBucket(v44, RootPart, p42._bucketRoot);

    for _, descendant in ipairs(v44:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant:SetAttribute("_OfflineGeneratedMoneyVisibleTransparency", u1._getVisibleTransparency(descendant));

            if descendant == RootPart then
                descendant.Transparency = 1;
            end;

            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
        end;
    end;

    local v45 = {
        index = u1._getStageSortIndex(p43),
        model = v44,
        rootPart = RootPart,
        mainPart = Main,
        highlight = u1._createHighlight(v44),
        topAttachment = u1._createTopAttachment(Main),
        animatedParts = u1._collectAnimatedParts(v44, RootPart)
    };
    u1._resetStageParts(v45);
    u1._setStageVisible(v45, false);

    return v45;
end;

function u1._hideAllStages(p46) -- Line: 307
    -- upvalues: u1 (copy)
    for _, v in ipairs(p46._stages) do
        u1._resetStageParts(v);
        u1._setStageVisible(v, false);
    end;

    p46._currentStageIndex = 0;

    if p46._lastAdornee ~= nil then
        p46._lastAdornee = nil;
        p46.BillboardAdorneeChanged:Fire(nil);
    end;
end;

function u1._fadeOutStages(p47, p48) -- Line: 320
    -- upvalues: TweenService (copy)
    local v49 = false;

    for _, v in ipairs(p47._stages) do
        v.highlight.Enabled = false;

        for _, descendant in ipairs(v.model:GetDescendants()) do
            if descendant:IsA("BasePart") and (descendant ~= v.rootPart and descendant.Transparency < 1) then
                local v50 = TweenService:Create(descendant, TweenInfo.new(p48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 1
                });
                p47._animationTrove:Add(v50);
                v50:Play();
                v49 = true;
            end;
        end;
    end;

    return v49;
end;

function u1._getCollectAllEffectCFrame(p51) -- Line: 345
    local v52;

    if p51._currentStageIndex > 0 then
        v52 = p51._currentStageIndex;
    else
        v52 = nil;
    end;

    local v53;

    if v52 then
        v53 = p51._stages[v52];
    else
        v53 = nil;
    end;

    if v53 then
        return v53.mainPart.CFrame;
    end;

    return p51._lastStageCenterCFrame or p51._bucketRoot.CFrame;
end;

function u1._emitCollectAllCash(p54) -- Line: 351
    -- upvalues: Emit (copy), MoneyCollect (copy)
    Emit(p54, nil, MoneyCollect:GetChildren());
end;

function u1._setProgress(p55, p56) -- Line: 355
    -- upvalues: u1 (copy)
    local v57 = math.clamp(p56, 0, 1);
    local _stages = p55._stages;
    local v58 = #_stages;

    if v58 <= 0 then
        return;
    end;

    if v57 <= 0 then
        p55:_hideAllStages();

        return;
    end;

    local v59 = v57 * v58;
    local v60 = math.floor(v59) + 1;
    local v61 = math.clamp(v60, 1, v58);
    local v62 = v57 >= 1 and 1 or v59 - (v61 - 1);

    for i, v in ipairs(_stages) do
        local v63 = i == v61;
        u1._setStageVisible(v, v63);

        if v63 then
            u1._applyStageAlpha(v, v62);
        else
            u1._resetStageParts(v);
        end;
    end;

    p55._currentStageIndex = v61;
    p55._lastStageCenterCFrame = _stages[v61].mainPart.CFrame;
    local topAttachment = _stages[v61].topAttachment;

    if p55._lastAdornee ~= topAttachment then
        p55._lastAdornee = topAttachment;
        p55.BillboardAdorneeChanged:Fire(topAttachment);
    end;
end;

function u1.UpdateInstant(p64, p65, p66) -- Line: 397
    -- upvalues: Asserts (copy)
    Asserts.finiteNonNegative(p65);
    Asserts.boolean(p66);

    if not p66 or p65 <= 0 then
        p64:_hideAllStages();

        return;
    end;

    local v67 = math.max(p65 - 1, 0) / 999999999;
    p64:_setProgress((math.clamp(v67, 0, 1)));
end;

function u1.PlayCollectReset(u68) -- Line: 416
    -- upvalues: Trove (copy), u1 (copy)
    u68._animationTrove:Destroy();
    u68._animationTrove = Trove.new();
    u68._trove:Add(u68._animationTrove);

    if u68:_fadeOutStages(0.3) then
        u1._emitCollectAllCash(u68:_getCollectAllEffectCFrame());
    end;

    u68._animationTrove:Add(task.delay(0.3, function() -- Line: 426
        -- upvalues: u68 (copy)
        if u68._destroyed then
            return;
        end;

        u68:_hideAllStages();
    end));
end;

function u1.GetBillboardAdornee(p69) -- Line: 435
    return p69._lastAdornee;
end;

function u1.Destroy(p70) -- Line: 439
    p70._destroyed = true;
    p70._trove:Destroy();
end;

return u1;