-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextChatService = game:GetService("TextChatService");
local HttpService = game:GetService("HttpService");
local Network = require(ReplicatedStorage.Library.Client.Network);
local ChatMsg = require(ReplicatedStorage.Library.Types.ChatMsg);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local TextChannel = Instance.new("TextChannel");
local u1 = {
    Secret = Rarities.Secret.Gradient,
    Eternal = Rarities.Eternal.Gradient,
    Divine = Rarities.Divine.Gradient
};
local u2 = {};

local function getVipPrefixText(p3) -- Line: 42
    -- upvalues: Players (copy)
    local TextSource = p3.TextSource;

    if not TextSource then
        return nil;
    end;

    local v4 = Players:GetPlayerByUserId(TextSource.UserId);

    if v4 and v4:GetAttribute("MonetizationVipProductOwned") == true then
        return `<font color='#FFC700'>[VIP-OG]</font> {p3.PrefixText}`;
    end;

    return nil;
end;

function u2.New(u5, u6, u7, u8, u9, u10) -- Line: 120
    -- upvalues: TextChatService (copy), TextChannel (copy)
    task.spawn(function() -- Line: 128
        -- upvalues: u6 (copy), u7 (copy), u8 (copy), u9 (copy), TextChatService (ref), u5 (copy), TextChannel (ref), u10 (copy)
        local v11 = u6 or Color3.new(1, 1, 1);
        local v12 = u7 or Enum.Font.GothamBold;
        local v13 = u8 or Enum.FontSize.Size18;

        if u9 then
            v11 = nil;
        end;

        if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = u5,
                Color = v11,
                Font = v12,
                FontSize = v13
            });

            return;
        end;

        local v14 = u5;

        if v11 then
            v14 = string.format("<font color=\'#%s\'>%s</font>", v11:ToHex(), u5);
        end;

        TextChannel:DisplaySystemMessage(v14, u10 or "");
    end);
end;

TextChannel.Name = "GameSystem";
TextChannel.Parent = TextChatService;

function TextChatService.OnIncomingMessage(p15) -- Line: 56
    -- upvalues: Players (copy), TextChatService (copy), HttpService (copy), u1 (copy)
    local TextSource = p15.TextSource;
    local v16;

    if TextSource then
        local v17 = Players:GetPlayerByUserId(TextSource.UserId);

        if v17 and v17:GetAttribute("MonetizationVipProductOwned") == true then
            v16 = `<font color='#FFC700'>[VIP-OG]</font> {p15.PrefixText}`;
        else
            v16 = nil;
        end;
    else
        v16 = nil;
    end;

    if not p15.Metadata then
        if v16 then
            local v18 = TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties();
            v18.PrefixText = v16;

            return v18;
        end;

        return;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, p15.Metadata);

    if not success then
        if v16 then
            local v19 = TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties();
            v19.PrefixText = v16;

            return v19;
        end;

        return;
    end;

    local v20 = u1[result.rarity];

    if v20 then
        local v21 = TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties();
        local v22 = p15.Text:gsub("!", "");

        if v16 then
            v22 = `<font color='#FFC700'>[VIP-OG]</font> {v22}`;
        end;

        v21.PrefixText = v22;
        v21.Text = "!";
        v21.TextColor3 = Color3.new(1, 1, 1);
        v21.PrefixTextProperties = TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties();
        v21.PrefixTextProperties.TextColor3 = Color3.new(1, 1, 1);
        local u23 = v20:Clone();
        u23.Parent = v21.PrefixTextProperties;
        p15.ChatWindowMessageProperties = v21;
        task.delay(10, function() -- Line: 109
            -- upvalues: u23 (copy)
            u23.Enabled = false;
        end);

        return v21;
    end;

    if v16 then
        local v24 = TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties();
        v24.PrefixText = v16;

        return v24;
    end;
end;

Network.Fired(Network.NET_MAP.ChatMsg.DISPLAY_FROM_DATA):Connect(function(p25) -- Line: 167
    -- upvalues: ChatMsg (copy), u2 (copy)
    assert(ChatMsg.AnnounceData(p25));
    u2.New(p25.message, p25.color, p25.font, p25.fontSize, p25.omitColor, p25.metadata);
end);
Network.Fired(Network.NET_MAP.ChatMsg.DISPLAY_FROM_RAW_PARAMS):Connect(function(...) -- Line: 172
    -- upvalues: u2 (copy)
    u2.New(...);
end);
Network.Fired(Network.NET_MAP.ChatMsg.DISPLAY_DEFAULT):Connect(function(p26, p27, p28, p29) -- Line: 177
    -- upvalues: u2 (copy)
    u2.New(p26, nil, p27, p28, true, p29);
end);

return u2;