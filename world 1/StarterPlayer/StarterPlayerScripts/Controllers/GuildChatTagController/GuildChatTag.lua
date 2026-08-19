-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TextChatService = game:GetService("TextChatService");
local v1 = {};
local u2 = false;

local function buildPrefix(p3, p4, p5, p6) -- Line: 18
    local v7 = p4:gsub("<", "&lt;"):gsub(">", "&gt;");
    local v8 = p6 and "⭐ " or "";

    if p3 == "" then
        return string.format("%s<font color=\"%s\">[%s]</font> ", v8, p5, v7);
    end;

    return string.format("%s<font color=\"%s\">[%s]</font> %s", v8, p5, v7, p3);
end;

local function onIncomingMessage(p9) -- Line: 29
    -- upvalues: Players (copy), buildPrefix (copy)
    local TextChatMessageProperties = Instance.new("TextChatMessageProperties");
    local TextSource = p9.TextSource;

    if not TextSource then
        return TextChatMessageProperties;
    end;

    local v10 = Players:GetPlayerByUserId(TextSource.UserId);

    if not v10 then
        return TextChatMessageProperties;
    end;

    local v11 = v10:GetAttribute("GuildTag");

    if typeof(v11) ~= "string" or v11 == "" then
        return TextChatMessageProperties;
    end;

    local v12 = v10:GetAttribute("GuildColor");
    local v13 = (typeof(v12) ~= "string" or v12 == "") and "#6EE7A7" or v12;
    local v14 = v10:GetAttribute("GuildRole") == "Owner";
    TextChatMessageProperties.PrefixText = buildPrefix(p9.PrefixText, v11, v13, v14);

    return TextChatMessageProperties;
end;

function v1.Install() -- Line: 51
    -- upvalues: u2 (ref), TextChatService (copy), onIncomingMessage (copy)
    if u2 then
        return;
    end;

    u2 = true;

    function TextChatService.OnIncomingMessage(p15) -- Line: 57
        -- upvalues: onIncomingMessage (ref)
        return onIncomingMessage(p15);
    end;
end;

return v1;