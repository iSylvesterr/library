-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local TranslationHelper = UtilsSystem.TranslationHelper;
local v1 = {};
local LocalPlayer = Players.LocalPlayer;

local function _findDesInContainer(p2) -- Line: 39
    if not p2 then
        return nil;
    end;

    local PotionDetail = p2:FindFirstChild("PotionDetail");

    if not PotionDetail then
        return nil;
    end;

    local Des = PotionDetail:FindFirstChild("Des");

    if Des and Des:IsA("TextLabel") then
        return Des;
    end;

    return nil;
end;

local function _getDesLabel() -- Line: 58
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return nil;
    end;

    local ScreenGui = PlayerGui:FindFirstChild("ScreenGui");

    if ScreenGui then
        ScreenGui = ScreenGui:FindFirstChild("Detail");
    end;

    local v3;

    if ScreenGui then
        local PotionDetail = ScreenGui:FindFirstChild("PotionDetail");

        if PotionDetail then
            v3 = PotionDetail:FindFirstChild("Des");

            if not (v3 and v3:IsA("TextLabel")) then
                v3 = nil;
            end;
        else
            v3 = nil;
        end;
    else
        v3 = nil;
    end;

    if v3 then
        return v3;
    end;

    local ScreenGui_Full = PlayerGui:FindFirstChild("ScreenGui_Full");

    if ScreenGui_Full then
        ScreenGui_Full = ScreenGui_Full:FindFirstChild("Detail");
    end;

    local v4;

    if ScreenGui_Full then
        local PotionDetail = ScreenGui_Full:FindFirstChild("PotionDetail");

        if PotionDetail then
            v4 = PotionDetail:FindFirstChild("Des");

            if not (v4 and v4:IsA("TextLabel")) then
                v4 = nil;
            end;
        else
            v4 = nil;
        end;
    else
        v4 = nil;
    end;

    if v4 then
        return v4;
    end;

    local Detail = PlayerGui:FindFirstChild("Detail");

    if not Detail then
        return nil;
    end;

    local PotionDetail = Detail:FindFirstChild("PotionDetail");

    if not PotionDetail then
        return nil;
    end;

    local Des = PotionDetail:FindFirstChild("Des");

    if Des and Des:IsA("TextLabel") then
        return Des;
    end;

    return nil;
end;

local function _applyDes(p5) -- Line: 81
    -- upvalues: _getDesLabel (copy), Log (copy), TranslationHelper (copy)
    if type(p5) ~= "table" then
        return;
    end;

    local v6 = _getDesLabel();

    if v6 then
        TranslationHelper.SetText(v6, p5.Des);

        return;
    end;

    Log.warn("PotionDetail: 缺少 Detail/PotionDetail/Des");
end;

function v1.ShowByCfgID(p7, p8) -- Line: 99
    -- upvalues: _getDesLabel (copy), Log (copy), TranslationHelper (copy)
    if type(p7) ~= "table" then
        return;
    end;

    local v9 = _getDesLabel();

    if v9 then
        TranslationHelper.SetText(v9, p7.Des);

        return;
    end;

    Log.warn("PotionDetail: 缺少 Detail/PotionDetail/Des");
end;

function v1.ShowByData(p10, p11, p12) -- Line: 110
    -- upvalues: _getDesLabel (copy), Log (copy), TranslationHelper (copy)
    if type(p11) ~= "table" then
        return;
    end;

    local v13 = _getDesLabel();

    if v13 then
        TranslationHelper.SetText(v13, p11.Des);

        return;
    end;

    Log.warn("PotionDetail: 缺少 Detail/PotionDetail/Des");
end;

function v1.HoldShow(p14, p15, p16) -- Line: 121
    -- upvalues: _getDesLabel (copy), Log (copy), TranslationHelper (copy)
    if type(p15) ~= "table" then
        return;
    end;

    local v17 = _getDesLabel();

    if v17 then
        TranslationHelper.SetText(v17, p15.Des);

        return;
    end;

    Log.warn("PotionDetail: 缺少 Detail/PotionDetail/Des");
end;

return v1;