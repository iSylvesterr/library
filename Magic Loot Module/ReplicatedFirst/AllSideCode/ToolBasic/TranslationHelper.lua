-- Decompiled with Potassium's decompiler.

local LanguageCfg = require(script.LanguageCfg);
local u1 = {};
local u2 = {
    TextLabel = true,
    TextBox = true,
    ProximityPrompt = true
};

local function _isTextInstance(p3) -- Line: 46
    -- upvalues: u2 (copy)
    for i in pairs(u2) do
        if p3:IsA(i) then
            return true;
        end;
    end;

    return false;
end;

local function _setTextContent(p4, p5, p6) -- Line: 62
    if p6 then
        p5 = p5 .. p6 or p5;
    end;

    if p4:IsA("ProximityPrompt") then
        p4.ActionText = p5;

        return;
    end;

    if p4:IsA("TextBox") then
        p4.PlaceholderText = p5;

        return;
    end;

    if p4:IsA("TextLabel") then
        p4.Text = p5;
    end;
end;

local function _clearTextContent(p7) -- Line: 79
    if p7:IsA("ProximityPrompt") then
        p7.ActionText = "";

        return;
    end;

    if p7:IsA("TextBox") then
        p7.PlaceholderText = "";

        return;
    end;

    if p7:IsA("TextLabel") then
        p7.Text = "";
    end;
end;

local function _clearLocalizationAttributes(p8) -- Line: 94
    p8:SetAttribute("_key", nil);
    p8:SetAttribute("_maxIndex", nil);

    for i in pairs(p8:GetAttributes()) do
        if string.sub(i, 1, 4) == "_arg" then
            p8:SetAttribute(i, nil);
        end;
    end;
end;

local function _getArgsMaxIndex(p9) -- Line: 111
    local v10 = 0;

    for i in pairs(p9) do
        if typeof(i) == "number" and v10 < i then
            v10 = i;
        end;
    end;

    return v10;
end;

function u1.GetLocaleId() -- Line: 130
    -- upvalues: LanguageCfg (copy)
    return LanguageCfg.GetLocaleId();
end;

function u1.SetLocaleId(p11) -- Line: 139
    -- upvalues: LanguageCfg (copy)
    LanguageCfg.SetLocaleId(p11);
end;

function u1.TranslateByKey(p12, p13) -- Line: 150
    -- upvalues: LanguageCfg (copy)
    return (not p12 or p12 == "") and "" or LanguageCfg.FormatByKey(p12, p13);
end;

function u1.SetText(p14, p15, p16, p17) -- Line: 167
    -- upvalues: u2 (copy), _clearLocalizationAttributes (copy), _getArgsMaxIndex (copy), LanguageCfg (copy)
    if not p14 then
        return;
    end;

    local v18 = false;

    for i in pairs(u2) do
        if p14:IsA(i) then
            v18 = true;
            break;
        end;
    end;

    if not v18 then
        return;
    end;

    if not p14:HasTag("代码本地化") then
        p14:AddTag("代码本地化");
    end;

    _clearLocalizationAttributes(p14);
    p14:SetAttribute("_key", p15);

    if p16 then
        p14:SetAttribute("_maxIndex", (_getArgsMaxIndex(p16)));

        for i, v in pairs(p16) do
            if typeof(v) == "table" then
                p14:SetAttribute("_arg_table" .. i, v[1]);
            else
                p14:SetAttribute("_arg" .. i, v);
            end;
        end;
    end;

    if p15 then
        local v19, v20 = LanguageCfg.FormatByKey(p15, p16);
        p14.AutoLocalize = v20;

        if v19 then
            if p17 then
                v19 = v19 .. p17 or v19;
            end;

            if p14:IsA("ProximityPrompt") then
                p14.ActionText = v19;

                return;
            end;

            if p14:IsA("TextBox") then
                p14.PlaceholderText = v19;

                return;
            end;

            if p14:IsA("TextLabel") then
                p14.Text = v19;
            end;
        end;

        return;
    end;

    warn("本地化错误 - 键值为空", p14.Name, p14.Parent and (p14.Parent.Name or "?") or "?", p14.Parent and p14.Parent.Parent and (p14.Parent.Parent.Name or "?") or "?", p14.Parent and (p14.Parent.Parent and p14.Parent.Parent.Parent) and (p14.Parent.Parent.Parent.Name or "?") or "?", p14.Parent and (p14.Parent.Parent and (p14.Parent.Parent.Parent and p14.Parent.Parent.Parent.Parent)) and (p14.Parent.Parent.Parent.Parent.Name or "?") or "?");

    if p14:IsA("ProximityPrompt") then
        p14.ActionText = "";

        return;
    end;

    if p14:IsA("TextBox") then
        p14.PlaceholderText = "";

        return;
    end;

    if p14:IsA("TextLabel") then
        p14.Text = "";
    end;
end;

function u1.SetRawText(p21, p22) -- Line: 228
    -- upvalues: u2 (copy)
    if not p21 then
        return;
    end;

    local v23 = false;

    for i in pairs(u2) do
        if p21:IsA(i) then
            v23 = true;
            break;
        end;
    end;

    if not v23 then
        return;
    end;

    if p21:IsA("ProximityPrompt") then
        return;
    end;

    if p21:IsA("TextBox") then
        p21.AutoLocalize = false;
        p21.Text = p22;

        return;
    end;

    p21.AutoLocalize = false;
    p21.Text = p22;
end;

function u1.SetText_UnTrans(p24, p25, p26) -- Line: 255
    -- upvalues: u1 (copy)
    u1.SetRawText(p24, p25);
end;

function u1.CheckTranslateByKey(p27, p28) -- Line: 266
    -- upvalues: LanguageCfg (copy)
    if p27 then
        return LanguageCfg.FormatByKey(p27, p28) ~= "未本地化-" .. p27;
    end;

    return nil;
end;

function u1.SetLabel(p29) -- Line: 285
    -- upvalues: u2 (copy), u1 (copy)
    if not p29 then
        return;
    end;

    local v30 = false;

    for i in pairs(u2) do
        if p29:IsA(i) then
            v30 = true;
            break;
        end;
    end;

    if v30 then
        u1.SetText(p29, p29.Name);
    end;
end;

return u1;