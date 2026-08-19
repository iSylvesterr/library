-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
game:GetService("LocalizationService");
local _ = UtilsSystem.Players;
local _ = UtilsSystem.ReplicatedStorage;
local _ = UtilsSystem.RunService;
local TranslationHelper = UtilsSystem.TranslationHelper;
local Log = UtilsSystem.Log;
local LocalPlayer = UtilsSystem.LocalPlayer;
local _ = LocalPlayer.PlayerGui;
local CollectionService = UtilsSystem.CollectionService;

local function ChangeText(p1) -- Line: 27
    -- upvalues: TranslationHelper (copy)
    local v2 = p1:GetAttribute("_key");
    local v3 = p1:GetAttribute("_maxIndex");
    local v4;

    if v3 then
        v4 = {};

        for i = 1, v3 do
            if p1:GetAttribute("_arg" .. i) then
                v4[i] = p1:GetAttribute("_arg" .. i);
            elseif p1:GetAttribute("_arg_table" .. i) then
                v4[i] = { p1:GetAttribute("_arg_table" .. i) };
            end;
        end;
    else
        v4 = nil;
    end;

    TranslationHelper.SetText(p1, v2, v4);
end;

LocalPlayer:GetPropertyChangedSignal("LocaleId"):Connect(function() -- Line: 47, Name: OnLocaleIdChanged
    -- upvalues: TranslationHelper (copy), LocalPlayer (copy), Log (copy), CollectionService (copy), ChangeText (copy)
    if TranslationHelper.GetLocaleId() == LocalPlayer.LocaleId then
        return;
    end;

    TranslationHelper.SetLocaleId(LocalPlayer.LocaleId);
    Log.warn("===============切换了本地语言:", TranslationHelper.GetLocaleId());

    for _, v in pairs(CollectionService:GetTagged("代码本地化")) do
        ChangeText(v);
    end;
end);
TranslationHelper.SetLocaleId(LocalPlayer.LocaleId);

local function AddLocalText(p5) -- Line: 68
    -- upvalues: TranslationHelper (copy)
    TranslationHelper.SetText(p5, p5.Name);
end;

for _, v in pairs(CollectionService:GetTagged("本地化")) do
    TranslationHelper.SetText(v, v.Name);
end;

CollectionService:GetInstanceAddedSignal("本地化"):Connect(function(p6) -- Line: 77
    -- upvalues: TranslationHelper (copy)
    TranslationHelper.SetText(p6, p6.Name);
end);

for _, v in pairs(CollectionService:GetTagged("代码本地化")) do
    ChangeText(v);
end;

CollectionService:GetInstanceAddedSignal("代码本地化"):Connect(function(p7) -- Line: 87
    -- upvalues: ChangeText (copy)
    ChangeText(p7);
end);