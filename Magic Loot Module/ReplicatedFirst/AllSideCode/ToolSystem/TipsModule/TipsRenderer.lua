-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local TextService = game:GetService("TextService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local TipsConfig = require(script.Parent.TipsConfig);
local TipsTemplateBuilder = require(script.Parent.TipsTemplateBuilder);
local InsMgr = UtilsSystem.InsMgr;
local UIMgr = UtilsSystem.UIMgr;
local ObjectPoolUtil = UtilsSystem.ObjectPoolUtil;
local u1 = {};
local u2 = 0;
local u3 = false;
local u4 = nil;
local u5 = {};
local u6 = {};

local function _ensureClientReady() -- Line: 42
    -- upvalues: RunService (copy), u3 (ref), u4 (ref), UtilsSystem (copy)
    if not RunService:IsClient() then
        warn("TipsRenderer 仅客户端可用");

        return false;
    end;

    if u3 then
        return true;
    end;

    u4 = UtilsSystem.Players.LocalPlayer;
    u3 = true;

    return true;
end;

local function _getTipsFrame() -- Line: 61
    -- upvalues: RunService (copy), u3 (ref), u4 (ref), UtilsSystem (copy)
    local v7;

    if RunService:IsClient() then
        if u3 then
            v7 = true;
        else
            u4 = UtilsSystem.Players.LocalPlayer;
            u3 = true;
            v7 = true;
        end;
    else
        warn("TipsRenderer 仅客户端可用");
        v7 = false;
    end;

    if not (v7 and u4) then
        return nil;
    end;

    local PlayerGui = u4:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return nil;
    end;

    local TipsGui = PlayerGui:FindFirstChild("TipsGui");

    if TipsGui then
        return TipsGui:FindFirstChild("NewTipsFrame");
    end;

    return nil;
end;

local function _segmentStyleScore(p8) -- Line: 89
    if typeof(p8.TextColor) == "Color3" then
        return 100;
    end;

    local UIGradientString = p8.UIGradientString;

    if UIGradientString == nil or UIGradientString == "提示白" then
        return 0;
    end;

    if type(UIGradientString) ~= "number" then
        local v9 = tostring(UIGradientString);

        if tonumber(v9) == nil then
            return 10;
        end;
    end;

    return 50;
end;

local function _mergeTipSegments(p10) -- Line: 109
    if #p10 == 0 then
        return nil;
    end;

    if #p10 == 1 then
        return p10[1];
    end;

    local v11 = "";
    local v12 = p10[1];
    local v13;

    if typeof(v12.TextColor) == "Color3" then
        v13 = 100;
    else
        local UIGradientString = v12.UIGradientString;

        if UIGradientString == nil or UIGradientString == "提示白" then
            v13 = 0;
        elseif type(UIGradientString) == "number" then
            v13 = 50;
        else
            local v14 = tostring(UIGradientString);
            v13 = tonumber(v14) == nil and 10 or 50;
        end;
    end;

    for _, v in ipairs(p10) do
        v11 = v11 .. (v.Text or "");
        local v15;

        if typeof(v.TextColor) == "Color3" then
            v15 = 100;
        else
            local UIGradientString = v.UIGradientString;

            if UIGradientString == nil or UIGradientString == "提示白" then
                v15 = 0;
            elseif type(UIGradientString) == "number" then
                v15 = 50;
            else
                local v16 = tostring(UIGradientString);
                v15 = tonumber(v16) == nil and 10 or 50;
            end;
        end;

        if v13 < v15 then
            v12 = v;
            v13 = v15;
        end;
    end;

    local v17 = {};

    for i, v in pairs(v12) do
        v17[i] = v;
    end;

    v17.Text = v11;

    return v17;
end;

local function _collectTipLabels(p18) -- Line: 143
    local v19 = {};

    for _, child in p18:GetChildren() do
        if child:IsA("TextLabel") then
            table.insert(v19, child);
        end;
    end;

    return v19;
end;

local function _removeTipImmediate(p20) -- Line: 158
    -- upvalues: u6 (copy), u5 (copy)
    local v21 = u6[p20];

    if v21 then
        task.cancel(v21);
        u6[p20] = nil;
    end;

    u5[p20] = nil;
    p20:Destroy();
end;

local function _enforceTipLimit(p22) -- Line: 173
    -- upvalues: _collectTipLabels (copy), TipsConfig (copy), u6 (copy), u5 (copy)
    local v23 = _collectTipLabels(p22);

    if #v23 <= TipsConfig.MAX_SHOW_NUMBER then
        return;
    end;

    table.sort(v23, function(p24, p25) -- Line: 179
        return p24.LayoutOrder < p25.LayoutOrder;
    end);

    for i = 1, #v23 - TipsConfig.MAX_SHOW_NUMBER do
        local v26 = v23[i];
        local v27 = u6[v26];

        if v27 then
            task.cancel(v27);
            u6[v26] = nil;
        end;

        u5[v26] = nil;
        v26:Destroy();
    end;
end;

local function _showTextTween(p28) -- Line: 197
    -- upvalues: TweenService (copy), TipsConfig (copy)
    p28.TextScaled = true;
    local Size = p28.Size;
    p28.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0);
    local u29 = TweenService:Create(p28, TweenInfo.new(TipsConfig.TWEEN_TEXT_DURATION, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = Size
    });
    u29.Completed:Once(function() -- Line: 207
        -- upvalues: u29 (copy)
        u29:Destroy();
    end);
    u29:Play();
end;

local function _hideTextTween(u30) -- Line: 218
    -- upvalues: u5 (copy), TipsConfig (copy), TweenService (copy), u6 (copy), ObjectPoolUtil (copy)
    if u5[u30] then
        return;
    end;

    u5[u30] = true;
    local v31 = TweenInfo.new(TipsConfig.TWEEN_TEXT_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local u32 = TweenService:Create(u30, v31, {
        TextTransparency = 1
    });
    local v33 = u30:FindFirstChildOfClass("UIStroke");
    local u34;

    if v33 and v33.Enabled then
        u34 = TweenService:Create(v33, v31, {
            Transparency = 1
        });
        u34:Play();
    else
        u34 = nil;
    end;

    u32.Completed:Once(function() -- Line: 234
        -- upvalues: u32 (copy), u34 (ref), u5 (ref), u30 (copy), u6 (ref), ObjectPoolUtil (ref)
        u32:Destroy();

        if u34 then
            u34:Destroy();
        end;

        u5[u30] = nil;
        u6[u30] = nil;
        ObjectPoolUtil.backToPool(u30);
    end);
    u32:Play();
end;

local function _setTextSize(p35) -- Line: 255
    -- upvalues: TextService (copy), TipsConfig (copy)
    local v36 = TextService:GetTextSize(p35.Text, p35.TextSize, p35.Font, TipsConfig.TEXT_BOUNDS) + Vector2.new(1, 1);
    p35.Size = UDim2.new(0, v36.X, p35.Size.Y.Scale, p35.TextSize);
end;

local function _createText(p37) -- Line: 271
    -- upvalues: TipsConfig (copy), ObjectPoolUtil (copy), InsMgr (copy), UIMgr (copy)
    local v38 = TipsConfig.getPoolTemplate(TipsConfig.POOL_TEXT_TEMP);

    if not v38 then
        return nil;
    end;

    local v39 = ObjectPoolUtil.getObjectFromPool(v38);

    if not v39 then
        return nil;
    end;

    v39.AnchorPoint = Vector2.new(0.5, 0.5);
    v39.Text = p37.Text or "";
    v39.Font = p37.Font or Enum.Font.MontserratBold;
    v39.TextScaled = false;
    v39.TextWrapped = false;
    v39.AutomaticSize = Enum.AutomaticSize.None;
    v39.TextSize = p37.TextSize or 20;
    v39.BackgroundTransparency = 1;
    v39.TextTransparency = 0;
    local v40 = InsMgr.GetIns("UIStroke", "UIStroke", v39);

    if p37.UIStorke and p37.UIStorke > 0 then
        v40.Thickness = p37.UIStorke or 2;
        v40.Transparency = p37.UIStorkeTransparency or 0;
        v40.Color = p37.UIStorkeColor or Color3.new(0, 0, 0);
        v40.Enabled = true;
    else
        v40.Enabled = false;
    end;

    if typeof(p37.TextColor) == "Color3" then
        v39.TextColor3 = p37.TextColor;
        local v41 = v39:FindFirstChildOfClass("UIGradient");

        if v41 then
            v41.Enabled = false;

            return v39;
        end;
    elseif p37.UIGradientString then
        v39.TextColor3 = Color3.new(1, 1, 1);
        UIMgr.AddGradientColor(p37.UIGradientString, v39, true);
        local v42 = v39:FindFirstChildOfClass("UIGradient");

        if v42 then
            v42.Enabled = true;

            return v39;
        end;
    else
        local v43 = v39:FindFirstChildOfClass("UIGradient");

        if v43 then
            v43.Enabled = false;
        end;
    end;

    return v39;
end;

local u44 = false;

local function _cleanupLegacyBgTips(p45) -- Line: 332
    -- upvalues: u44 (ref)
    if u44 then
        return;
    end;

    u44 = true;

    for _, child in p45:GetChildren() do
        if child:IsA("Frame") and child.Name == "BGTemp" then
            child:Destroy();
        end;
    end;
end;

local function _resolveDisplayDuration(p46) -- Line: 354
    -- upvalues: TipsConfig (copy)
    local v47 = tonumber(p46);

    if v47 and v47 > 0 then
        return v47;
    end;

    return TipsConfig.DISPLAY_DURATION;
end;

function u1.createTip(p48, p49) -- Line: 368
    -- upvalues: RunService (copy), u3 (ref), u4 (ref), UtilsSystem (copy), _cleanupLegacyBgTips (copy), _mergeTipSegments (copy), _createText (copy), u2 (ref), _showTextTween (copy), _enforceTipLimit (copy), TipsConfig (copy), u6 (copy), _hideTextTween (copy)
    local v50;

    if RunService:IsClient() then
        if u3 then
            v50 = true;
        else
            u4 = UtilsSystem.Players.LocalPlayer;
            u3 = true;
            v50 = true;
        end;
    else
        warn("TipsRenderer 仅客户端可用");
        v50 = false;
    end;

    local v51;

    if v50 and u4 then
        local PlayerGui = u4:FindFirstChild("PlayerGui");

        if PlayerGui then
            local TipsGui = PlayerGui:FindFirstChild("TipsGui");

            if TipsGui then
                v51 = TipsGui:FindFirstChild("NewTipsFrame");
            else
                v51 = nil;
            end;
        else
            v51 = nil;
        end;
    else
        v51 = nil;
    end;

    if not v51 then
        return;
    end;

    _cleanupLegacyBgTips(v51);
    local v52 = _mergeTipSegments(p48);

    if not v52 then
        return;
    end;

    local u53 = _createText(v52);

    if not u53 then
        return;
    end;

    u2 = u2 + 1;
    u53.LayoutOrder = u2;
    u53.Parent = v51;
    _showTextTween(u53);
    _enforceTipLimit(v51);
    local delay = task.delay;
    local v54 = tonumber(p49);

    if not v54 or v54 <= 0 then
        v54 = TipsConfig.DISPLAY_DURATION;
    end;

    u6[u53] = delay(v54, function() -- Line: 395
        -- upvalues: u6 (ref), u53 (copy), _hideTextTween (ref)
        u6[u53] = nil;

        if u53.Parent then
            _hideTextTween(u53);
        end;
    end);
end;

function u1.templateTip(p55, p56, p57, p58) -- Line: 412
    -- upvalues: TipsConfig (copy), u1 (copy)
    local v59 = TipsConfig.copyTemplate(p56);

    if not v59 then
        return;
    end;

    v59.Text = p55;

    if p58 ~= nil then
        v59.UIGradientString = p58;
        v59.TextColor = nil;
    end;

    u1.createTip({ v59 }, p57);
end;

function u1.showFromServerTemplate(p60) -- Line: 437
    -- upvalues: TipsTemplateBuilder (copy), u1 (copy)
    local v61 = TipsTemplateBuilder.buildFromServerData(p60);

    if v61 then
        u1.createTip(v61);
    end;
end;

return u1;