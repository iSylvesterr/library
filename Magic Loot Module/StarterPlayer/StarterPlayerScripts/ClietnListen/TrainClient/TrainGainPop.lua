-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local MathMgr = UtilsSystem.MathMgr;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIanima = UtilsSystem.UIanima;
local v1 = {};

local function _resolveNumLabel(p2) -- Line: 28
    local CanvasGroup = p2:FindFirstChild("CanvasGroup");

    if CanvasGroup then
        local Num = CanvasGroup:FindFirstChild("Num");

        if Num and Num:IsA("TextLabel") then
            return Num;
        end;
    end;

    local Num = p2:FindFirstChild("Num", true);

    if Num and Num:IsA("TextLabel") then
        return Num;
    end;

    return nil;
end;

local function _formatGainText(p3) -- Line: 49
    -- upvalues: MathMgr (copy)
    local v4 = tonumber(p3) or 0;
    local v5 = math.floor(v4);

    return v5 <= 0 and "+0" or "+" .. MathMgr.getNumStr(v5);
end;

function v1.Play(p6, p7, p8, p9, p10) -- Line: 73
    -- upvalues: _resolveNumLabel (copy), TranslationHelper (copy), MathMgr (copy), UIanima (copy)
    if not (p6 and p7) then
        return nil;
    end;

    local v11 = tonumber(p8);

    if not v11 or v11 <= 0 then
        return nil;
    end;

    local v12 = p6:Clone();
    v12.Name = "TrainGainPop";
    v12.Visible = true;
    v12.BackgroundTransparency = p6.BackgroundTransparency;
    v12.AnchorPoint = Vector2.new(0.5, 0.5);
    v12.Position = p9 or UDim2.fromScale(0.5, 0.5);
    local v13 = _resolveNumLabel(v12);

    if v13 then
        local SetText_UnTrans = TranslationHelper.SetText_UnTrans;
        local v14 = tonumber(v11) or 0;
        local v15 = math.floor(v14);
        SetText_UnTrans(v13, v15 <= 0 and "+0" or "+" .. MathMgr.getNumStr(v15));
    end;

    v12.Parent = p7;
    local PlayFrameFloatPop = UIanima.PlayFrameFloatPop;
    local v16 = {
        startScale = 1.35,
        goalSize = p6.Size
    };
    local v17;

    if p10 then
        v17 = p10.holdSec;
    else
        v17 = p10;
    end;

    v16.holdSec = v17;
    local v18;

    if p10 then
        v18 = p10.fadeSec;
    else
        v18 = p10;
    end;

    v16.fadeSec = v18;
    v16.randomDirection = p10 == nil and true or p10.randomDirection ~= false;
    PlayFrameFloatPop(v12, v16);

    return v12;
end;

return v1;