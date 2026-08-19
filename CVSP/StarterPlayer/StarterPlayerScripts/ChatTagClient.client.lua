-- Decompiled with Potassium's decompiler.

local TextChatService = game:GetService("TextChatService");
local Players = game:GetService("Players");

local function buildPrefix(p1) -- Line: 10
    local v2 = "";

    if p1:GetAttribute("IsOwner") then
        v2 = v2 .. string.format("<font color=\"%s\">%s</font>", "#6fff00", "[Owner] ");
    end;

    if p1:GetAttribute("IsVip") then
        v2 = v2 .. string.format("<font color=\"%s\">%s</font>", "#24e2ff", "[💎] ");
    end;

    return v2;
end;

function TextChatService.OnIncomingMessage(p3) -- Line: 24
    -- upvalues: Players (copy), buildPrefix (copy)
    if not p3.TextSource then
        return;
    end;

    local v4 = Players:GetPlayerByUserId(p3.TextSource.UserId);

    if v4 then
        local TextChatMessageProperties = Instance.new("TextChatMessageProperties");
        TextChatMessageProperties.PrefixText = buildPrefix(v4) .. p3.PrefixText;

        return TextChatMessageProperties;
    end;
end;