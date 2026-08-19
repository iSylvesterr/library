-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TextChatService = game:GetService("TextChatService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TipsModule = UtilsSystem.TipsModule;

if not UtilsSystem.WorldUtil.IsDebugEnabled() then
    return;
end;

local LocalPlayer = Players.LocalPlayer;
local u1 = 0;

local function _parseTestDataUserId(p2) -- Line: 47
    if typeof(p2) ~= "string" or p2 == "" then
        return nil;
    end;

    local v3 = string.match(p2, "^%s*(.-)%s*$") or p2;

    return string.match(v3, "^/testdata%s+(%d+)%s*$") or string.match(v3, "^(%d+)%s*$");
end;

local function _requestReplaceData(p4) -- Line: 67
    -- upvalues: TipsModule (copy), LocalPlayer (copy), u1 (ref), Log (copy), NetWork (copy), NetMsg (copy)
    local v5 = tonumber(p4);

    if not v5 or v5 <= 0 then
        TipsModule.ErrorTips(LocalPlayer, "用法: /testdata 玩家UserId");

        return;
    end;

    if v5 == LocalPlayer.UserId then
        TipsModule.ErrorTips(LocalPlayer, "不能替换为自己的数据");

        return;
    end;

    local v6 = os.clock();

    if v6 - u1 < 3 then
        return;
    end;

    u1 = v6;
    Log.print("[GMChat] 请求替换数据, targetUserId=", v5);
    NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "替换数据", { p4 });
end;

local function _tryHandleTestDataMessage(p7) -- Line: 95
    -- upvalues: _parseTestDataUserId (copy), TipsModule (copy), LocalPlayer (copy), Log (copy), _requestReplaceData (copy)
    local v8 = string.match(p7, "^%s*(.-)%s*$") or p7;

    if not string.match(v8, "^/testdata") then
        return false;
    end;

    local v9 = _parseTestDataUserId(v8);

    if v9 then
        _requestReplaceData(v9);

        return true;
    end;

    TipsModule.ErrorTips(LocalPlayer, "用法: /testdata 玩家UserId");
    Log.warn("[GMChat] 指令格式错误:", v8);

    return true;
end;

local TextChatCommand = Instance.new("TextChatCommand");
TextChatCommand.Name = "GMChat_TestData";
TextChatCommand.PrimaryAlias = "/testdata";
TextChatCommand.Parent = TextChatService;
TextChatCommand.Triggered:Connect(function(p10, p11) -- Line: 119, Name: _onTestDataCommand
    -- upvalues: _parseTestDataUserId (copy), TipsModule (copy), LocalPlayer (copy), _requestReplaceData (copy)
    local v12 = tostring(p11 or "");
    local v13 = _parseTestDataUserId("/testdata" .. " " .. v12) or _parseTestDataUserId(v12);

    if v13 then
        _requestReplaceData(v13);

        return;
    end;

    TipsModule.ErrorTips(LocalPlayer, "用法: /testdata 玩家UserId");
end);
LocalPlayer.Chatted:Connect(function(p14) -- Line: 135
    -- upvalues: _tryHandleTestDataMessage (copy)
    _tryHandleTestDataMessage(p14);
end);
Log.print("[GMChat] 已启用 /testdata 指令");