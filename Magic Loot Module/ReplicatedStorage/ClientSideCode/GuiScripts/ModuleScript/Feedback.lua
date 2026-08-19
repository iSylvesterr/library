-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local MathMgr = UtilsSystem.MathMgr;
local AddListen = UtilsSystem.AddListen;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIanima = UtilsSystem.UIanima;
local UIMgr = UtilsSystem.UIMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local u1 = {};
local Feedback = LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Feedback", (1 / 0));
local Frame = Feedback:WaitForChild("Frame");
local Box = Frame.Code.Input.Box;
local Button = Frame.Code.Button;
local Waiting = Frame.Code.Waiting;
local Button2 = Feedback.BG.Exit.Button;
local u2 = Frame.Code.Input["字数"];
local u3 = (SystemGameConfig.GetValue({ "Feedback", "反馈CD分钟" }) or 0) * 60;
local u4 = false;

local function _getReportTime() -- Line: 68
    -- upvalues: LocalPlayer (copy)
    local reportTime = LocalPlayer:FindFirstChild("reportTime");

    return not reportTime and 0 or reportTime.Value;
end;

local function _utf8CharCount(p5) -- Line: 81
    return utf8.len(p5) or 0;
end;

local function _refreshCharCount() -- Line: 89
    -- upvalues: Box (copy), TranslationHelper (copy), u2 (copy)
    local v6 = utf8.len(Box.Text) or 0;
    TranslationHelper.SetRawText(u2, "(" .. v6 .. "/" .. 256 .. ")");

    if v6 < 20 or v6 > 256 then
        u2.TextColor3 = Color3.new(1, 0, 0);

        return;
    end;

    u2.TextColor3 = Color3.new(0, 1, 0);
end;

local function _checkCooldown() -- Line: 103
    -- upvalues: Workspace (copy), LocalPlayer (copy), u3 (copy)
    local v7 = Workspace:GetServerTimeNow();
    local reportTime = LocalPlayer:FindFirstChild("reportTime");
    local v8 = u3 - (v7 - (not reportTime and 0 or reportTime.Value));

    if v8 > 0 then
        return true, v8;
    end;

    return false, nil;
end;

local function _validateInput() -- Line: 117
    -- upvalues: Box (copy)
    local v9 = utf8.len(Box.Text) or 0;

    if v9 < 20 then
        return false, "反馈文本不得少于多少";
    end;

    if v9 > 256 then
        return false, "反馈文本不得多余多少";
    end;

    return true, nil;
end;

local function _submitFeedback() -- Line: 131
    -- upvalues: Workspace (copy), LocalPlayer (copy), u3 (copy), MathMgr (copy), TipsModule (copy), Box (copy), u4 (ref), Waiting (copy), Button (copy), NetWork (copy), NetMsg (copy), TranslationHelper (copy), _refreshCharCount (copy)
    local v10 = Workspace:GetServerTimeNow();
    local reportTime = LocalPlayer:FindFirstChild("reportTime");
    local v11 = u3 - (v10 - (not reportTime and 0 or reportTime.Value));
    local v12;

    if v11 > 0 then
        v12 = true;
    else
        v12 = false;
        v11 = nil;
    end;

    if v12 then
        local v13 = { (MathMgr.getNumStr_0((math.abs((v11 or 0) / 60)))) };
        TipsModule.showTips(LocalPlayer, "反馈CD中", v13);

        return;
    end;

    local v14 = utf8.len(Box.Text) or 0;
    local v15, v16;

    if v14 < 20 then
        v15 = false;
        v16 = "反馈文本不得少于多少";
    elseif v14 > 256 then
        v15 = false;
        v16 = "反馈文本不得多余多少";
    else
        v15 = true;
        v16 = nil;
    end;

    if not v15 then
        if v16 == "反馈文本不得少于多少" then
            TipsModule.showTips(LocalPlayer, v16, { MathMgr.getNumStr(20) });

            return;
        end;

        if v16 == "反馈文本不得多余多少" then
            TipsModule.showTips(LocalPlayer, v16, { MathMgr.getNumStr(256) });
        end;

        return;
    end;

    if u4 then
        return;
    end;

    local Text = Box.Text;

    if Text == "" then
        return;
    end;

    Waiting.Visible = true;
    Button.Visible = false;
    u4 = true;

    if NetWork.InvokeServer(NetMsg.SUBMIT_FEEDBACK, Text) == true then
        TipsModule.showTips(LocalPlayer, "感谢你的反馈");
        TranslationHelper.SetRawText(Box, "");
        _refreshCharCount();
    end;

    u4 = false;
    Button.Visible = true;
    Waiting.Visible = false;
end;

AddListen.AddMouseCLick(Button2, function() -- Line: 178
    -- upvalues: u1 (copy)
    u1:closeUi();
end, Button2);
Box.InputEnded:Connect(_refreshCharCount);
Box.FocusLost:Connect(function() -- Line: 183
    -- upvalues: _refreshCharCount (copy)
    _refreshCharCount();
end);
AddListen.AddMouseCLick(Button, function() -- Line: 187
    -- upvalues: _submitFeedback (copy)
    _submitFeedback();
end, Button);
Button.Visible = true;
Waiting.Visible = false;

function u1.updateUi(p17) -- Line: 202
end;

function u1.openUi(p18) -- Line: 209
    -- upvalues: UIMgr (copy), TranslationHelper (copy), Box (copy), _refreshCharCount (copy)
    UIMgr.SetMainUIVisible(false);
    TranslationHelper.SetText(Box, "请在这输入反馈");
    _refreshCharCount();
end;

function u1.closeUi(p19) -- Line: 219
    -- upvalues: UIMgr (copy), UIanima (copy), Feedback (copy)
    UIMgr.SetMainUIVisible(true);
    UIanima.PopBack(Feedback);
end;

return u1;