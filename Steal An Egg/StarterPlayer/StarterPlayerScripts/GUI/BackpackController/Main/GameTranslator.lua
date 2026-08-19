-- Decompiled with Potassium's decompiler.

local LocalizationService = game:GetService("LocalizationService");
local Players = game:GetService("Players");
game.Players.LocalPlayer.PlayerGui:WaitForChild("BackpackGui");
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local BindableEvent = Instance.new("BindableEvent");

local function handlePlayerOrLocaleChanged() -- Line: 14
    -- upvalues: u2 (ref), u3 (ref), BindableEvent (copy)
    if u2 and u2.LocaleId ~= u3 then
        u3 = u2.LocaleId;
        BindableEvent:Fire(u3);
    end;
end;

local function reset() -- Line: 21
    -- upvalues: u1 (ref), u2 (ref), u4 (ref)
    u1 = nil;
    u2 = nil;

    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function getTranslator() -- Line: 31
    -- upvalues: u1 (ref), u2 (ref), Players (copy), LocalizationService (copy), u3 (ref), BindableEvent (copy), u4 (ref), handlePlayerOrLocaleChanged (copy)
    u2 = not u1 and Players.LocalPlayer;

    if u2 then
        u1 = LocalizationService:GetTranslatorForPlayer(u2);

        if u2 and u2.LocaleId ~= u3 then
            u3 = u2.LocaleId;
            BindableEvent:Fire(u3);
        end;

        u4 = u2:GetPropertyChangedSignal("LocaleId"):Connect(handlePlayerOrLocaleChanged);
    end;

    return u1;
end;

local u5 = {};

local function unregisterGui(p6) -- Line: 46
    -- upvalues: u5 (copy)
    u5[p6].connection:Disconnect();
    u5[p6] = nil;
end;

local function makeAncestryChangedHandler(u7, u8) -- Line: 51
    -- upvalues: u5 (copy)
    return function(p9, p10) -- Line: 52
        -- upvalues: u7 (copy), u8 (copy), u5 (ref)
        if game:IsAncestorOf(u7) then
            u8.hasBeenAdded = true;
        elseif u8.hasBeenAdded then
            local v11 = u7;
            u5[v11].connection:Disconnect();
            u5[v11] = nil;
        end;
    end;
end;

local function updateRegistryInfo(p12, p13, p14) -- Line: 63
    p12.context = p13;
    p12.text = p14;
end;

local function makeRegistryInfo(u15, p16, p17) -- Line: 68
    -- upvalues: u5 (copy)
    local u18 = {
        hasBeenAdded = game:IsAncestorOf(u15),
        context = p16,
        text = p17
    };
    u18.connection = u15.AncestryChanged:Connect(function(p19, p20) -- Line: 52
        -- upvalues: u15 (copy), u18 (copy), u5 (ref)
        if game:IsAncestorOf(u15) then
            u18.hasBeenAdded = true;
        elseif u18.hasBeenAdded then
            local v21 = u15;
            u5[v21].connection:Disconnect();
            u5[v21] = nil;
        end;
    end);

    return u18;
end;

local function registerGui(p22, p23, p24) -- Line: 75
    -- upvalues: u5 (copy), makeRegistryInfo (copy)
    if u5[p22] == nil then
        u5[p22] = makeRegistryInfo(p22, p23, p24);

        return;
    end;

    local v25 = u5[p22];
    v25.context = p23;
    v25.text = p24;
end;

local u29 = {
    LocaleChanged = BindableEvent.Event,

    TranslateGameText = function(p26, p27, p28) -- Line: 101, Name: TranslateGameText
        return p28;
    end
};

local function retranslateAll() -- Line: 114
    -- upvalues: u5 (copy), u29 (copy)
    for i, v in pairs(u5) do
        i.Text = u29:TranslateGameText(v.context, v.text);
    end;
end;

function u29.TranslateAndRegister(p30, p31, p32, p33) -- Line: 124
    return p33;
end;

return u29;