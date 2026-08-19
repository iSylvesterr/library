-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextService = game:GetService("TextService");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GetOrCreateUIScale = require(ReplicatedStorage.Library.Functions.GetOrCreateUIScale);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local TutorialMessageAnimator = require(ReplicatedStorage.Library.Client.UI.TutorialMessageAnimator);
local Weld = require(ReplicatedStorage.Library.Functions.Weld);
local u1 = {};
u1.__index = u1;
u1.__class = "AssetChatBubbleComponent";
local u2 = Vector2.new(1084, 144);
local u3 = Vector2.new(251, 72);
local u4 = Vector2.new(213.84, 56.4);
local u5 = TweenInfo.new(1.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
local u6 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local ChatBubble = ReplicatedStorage.Assets.Billboards.ChatBubble;
local v7 = ChatBubble:IsA("BillboardGui");
assert(v7, "Assets.Billboards.ChatBubble must be a BillboardGui");
local Frame = ChatBubble.Frame;
local v8 = Frame:IsA("Frame");
assert(v8, "Assets.Billboards.ChatBubble.Frame must be a Frame");
local v9 = Frame.TextLabel:IsA("TextLabel");
assert(v9, "Assets.Billboards.ChatBubble.Frame.TextLabel must be a TextLabel");
local u10 = true;

function u1.new(p11, p12, p13) -- Line: 65
    -- upvalues: Asserts (copy), u1 (copy), Trove (copy)
    Asserts.Model(p11);
    Asserts.BasePart(p12);
    Asserts.boolean(p13);
    local v14 = setmetatable({}, u1);
    v14._trove = Trove.new();
    v14._presentationTrove = nil;
    v14._model = p11;
    v14._centerPart = p12;
    local v15;

    if p13 then
        v15 = nil;
    else
        v15 = p12;
    end;

    v14._adornee = v15;
    v14._billboardScale = math.max(p12.Size.X / 0.49799999594688416, p12.Size.Y / 0.4440000057220459);
    v14._useProxy = p13;
    v14._suppressed = false;

    return v14;
end;

function u1._resolveAdornee(p16) -- Line: 88
    -- upvalues: Weld (copy)
    local _adornee = p16._adornee;

    if _adornee ~= nil then
        return _adornee;
    end;

    assert(p16._useProxy, "A missing chat bubble adornee requires proxy mode");
    local Part = Instance.new("Part");
    Part.Name = "AssetBubbleProxy";
    Part.Size = Vector3.new(0.2, 0.2, 0.2);
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Anchored = false;
    Part.Massless = true;
    Part.CFrame = p16._centerPart.CFrame + Vector3.new(0, -1, 0);
    Part.Parent = p16._model;
    Weld(p16._centerPart, Part);
    p16._trove:Add(Part);
    p16._adornee = Part;

    return Part;
end;

function u1._clearPresentation(p17, p18) -- Line: 113
    local _presentationTrove = p17._presentationTrove;

    if _presentationTrove == nil or p18 ~= nil and _presentationTrove ~= p18 then
        return;
    end;

    p17._presentationTrove = nil;
    _presentationTrove:Destroy();
end;

function u1._scaleBillboard(p19, p20) -- Line: 126
    local Size = p20.Size;
    local _billboardScale = p19._billboardScale;
    p20.Size = UDim2.new(Size.X.Scale * _billboardScale, Size.X.Offset * _billboardScale, Size.Y.Scale * _billboardScale, Size.Y.Offset * _billboardScale);
end;

function u1._fitFrameToText(p21, p22, p23, p24) -- Line: 132
    -- upvalues: u4 (copy), TextService (copy), u3 (copy), u2 (copy)
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
    GetTextBoundsParams.Font = p23.FontFace;
    GetTextBoundsParams.Size = u4.Y;
    GetTextBoundsParams.Width = 10000;
    GetTextBoundsParams.Text = p24;
    local v25 = TextService:GetTextBoundsAsync(GetTextBoundsParams);
    GetTextBoundsParams:Destroy();
    assert(v25.Y > 0, "Chat bubble text must produce positive text bounds");
    local Size = p22.Size;
    local v26;

    if Size.X.Offset == 0 then
        v26 = Size.Y.Offset == 0;
    else
        v26 = false;
    end;

    assert(v26, "ChatBubble.Frame.Size must use scale dimensions");
    local v27 = math.max(u3.X, v25.X + (u3.X - u4.X)) / u2.X;
    p22.Size = UDim2.fromScale(v27, Size.Y.Scale);
end;

function u1.Display(u28, u29, u30) -- Line: 159
    -- upvalues: Asserts (copy), ChatBubble (copy), u10 (ref), Trove (copy), GetOrCreateUIScale (copy), TutorialMessageAnimator (copy), TweenService (copy), u5 (copy), u6 (copy)
    Asserts.string(u29);

    if u28._suppressed then
        if u30 ~= nil then
            u30();
        end;

        return;
    end;

    u28:_clearPresentation(nil);
    local v31 = ChatBubble:Clone();
    local Frame2 = v31.Frame;
    local TextLabel = Frame2.TextLabel;
    local v32 = Frame2:IsA("Frame");
    assert(v32, "Cloned ChatBubble.Frame must be a Frame");
    local v33 = TextLabel:IsA("TextLabel");
    assert(v33, "Cloned ChatBubble.Frame.TextLabel must be a TextLabel");
    u28:_scaleBillboard(v31);
    Frame2.AutomaticSize = Enum.AutomaticSize.None;
    v31.Adornee = u28:_resolveAdornee();
    v31.AlwaysOnTop = u10;
    v31.Parent = u28._model;
    v31.Enabled = true;
    TextLabel.Text = "";
    local u34 = Trove.new();
    u28._presentationTrove = u34;
    u34:Add(v31);
    u34:Add(task.spawn(function() -- Line: 187
        -- upvalues: u28 (copy), u34 (copy), Frame2 (copy), TextLabel (copy), u29 (copy), GetOrCreateUIScale (ref), TutorialMessageAnimator (ref), TweenService (ref), u5 (ref), u6 (ref), u30 (copy)
        if u28._presentationTrove ~= u34 then
            return;
        end;

        u28:_fitFrameToText(Frame2, TextLabel, u29);

        if u28._presentationTrove ~= u34 then
            return;
        end;

        local u35 = GetOrCreateUIScale(Frame2);
        u35.Scale = 0;
        local u36 = TutorialMessageAnimator.new(TextLabel, nil, nil, false);
        u34:Add(function() -- Line: 200
            -- upvalues: u36 (copy)
            u36:Stop();
        end);
        local v37 = TweenService:Create(u35, u5, {
            Scale = 1
        });
        u34:Add(v37);
        u34:Add(task.delay(4, function() -- Line: 206
            -- upvalues: u28 (ref), u34 (ref), TweenService (ref), u35 (copy), u6 (ref), u30 (ref)
            if u28._presentationTrove ~= u34 then
                return;
            end;

            local v38 = TweenService:Create(u35, u6, {
                Scale = 0
            });
            u34:Add(v38);
            u34:Add(v38.Completed:Connect(function() -- Line: 213
                -- upvalues: u28 (ref), u34 (ref), u30 (ref)
                u28:_clearPresentation(u34);

                if u30 ~= nil then
                    u30();
                end;
            end));
            v38:Play();
        end));
        task.delay(0.2, function() -- Line: 222
            -- upvalues: u36 (copy), u29 (ref), TextLabel (ref)
            u36:SetAnimated(u29, TextLabel.TextColor3);
        end);
        v37:Play();
    end));
end;

function u1.SetSuppressed(p39, p40) -- Line: 229
    -- upvalues: Asserts (copy)
    Asserts.boolean(p40);

    if p39._suppressed == p40 then
        return;
    end;

    p39._suppressed = p40;

    if p40 then
        p39:_clearPresentation(nil);
    end;
end;

function u1.SetAlwaysOnTop(p41) -- Line: 241
    -- upvalues: Asserts (copy), u10 (ref)
    Asserts.boolean(p41);
    u10 = p41;
end;

function u1.Destroy(p42) -- Line: 246
    p42:_clearPresentation(nil);
    p42._trove:Destroy();
end;

return u1;