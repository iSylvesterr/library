-- Decompiled with Potassium's decompiler.

local LocalizationService = game:GetService("LocalizationService");
local PlayerGui = game.Players.LocalPlayer.PlayerGui;
PlayerGui:WaitForChild("BackpackGui");
local Players = game:GetService("Players");
local u1 = nil;

if Players.LocalPlayer == nil then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait();
end;

local u2 = nil;

local function getTranslator() -- Line: 18
    -- upvalues: u2 (ref), PlayerGui (copy), LocalizationService (copy)
    if u2 == nil then
        u2 = PlayerGui.CoreScriptLocalization:GetTranslator(LocalizationService.RobloxLocaleId);
    end;

    return u2;
end;

local u3 = {};

local function getTranslatorForLocale(p4) -- Line: 27
    -- upvalues: u3 (copy), PlayerGui (copy)
    local v5 = u3[p4];

    if v5 then
        return v5;
    end;

    local v6 = PlayerGui.CoreScriptLocalization:GetTranslator(p4);
    u3[p4] = v6;

    return v6;
end;

local function formatByKeyWithFallback(u7, u8, u9) -- Line: 39
    -- upvalues: u1 (ref)
    local success, result = pcall(function() -- Line: 40
        -- upvalues: u9 (copy), u7 (copy), u8 (copy)
        return u9:FormatByKey(u7, u8);
    end);

    if success then
        return result;
    end;

    return u1:FormatByKey(u7, u8);
end;

return {
    FormatByKey = function(p10, p11, p12) -- Line: 53, Name: FormatByKey
        -- upvalues: u2 (ref), PlayerGui (copy), LocalizationService (copy)
        if u2 == nil then
            u2 = PlayerGui.CoreScriptLocalization:GetTranslator(LocalizationService.RobloxLocaleId);
        end;

        return u2:FormatByKey(p11, p12);
    end,

    FormatByKeyForLocale = function(p13, p14, p15, p16) -- Line: 61, Name: FormatByKeyForLocale
        -- upvalues: u3 (copy), PlayerGui (copy)
        local v17 = u3[p15];

        if not v17 then
            v17 = PlayerGui.CoreScriptLocalization:GetTranslator(p15);
            u3[p15] = v17;
        end;

        return v17:FormatByKey(p14, p16);
    end
};