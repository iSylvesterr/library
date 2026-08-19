-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local InsMgr = UtilsSystem.InsMgr;
local RunService = UtilsSystem.RunService;
local v1 = {};
local u2 = { {
        Dev = 79237731812628,
        Test = 139516448392360,
        Official = 133188236593503
    } };
local PlaceId = game.PlaceId;
local u3 = "Official";
local u4 = 1;

local function _logWarn(...) -- Line: 72
    -- upvalues: UtilsSystem (copy)
    local Log = UtilsSystem.Log;

    if Log then
        Log.warn(...);
    end;
end;

(function() -- Line: 82, Name: _resolveWorldContext
    -- upvalues: u2 (copy), PlaceId (copy), u3 (ref), u4 (ref)
    for i, v in pairs(u2) do
        for i2, v2 in pairs(v) do
            if v2 ~= 0 and v2 == PlaceId then
                u3 = i2;
                u4 = i;

                return;
            end;
        end;
    end;
end)();

function v1.GetServerType() -- Line: 105
    -- upvalues: u3 (ref)
    return u3;
end;

function v1.IsDebugEnabled() -- Line: 118
    -- upvalues: u3 (ref), RunService (copy)
    if u3 == "Official" then
        return false;
    end;

    return RunService:IsStudio() and true or false;
end;

function v1.GetCurWorld() -- Line: 132
    -- upvalues: u4 (ref)
    return u4;
end;

function v1.GetSceneId() -- Line: 143
    -- upvalues: u3 (ref)
    return u3 == "Dev" and 1 or 2;
end;

function v1.RegisterNetWork() -- Line: 154
    -- upvalues: NetWork (copy), NetMsg (copy), _logWarn (copy), InsMgr (copy)
    NetWork.RegisterServerRemoteEvent(NetMsg.PRIVATE_SERVER_OWNER_ID, function(p5, p6) -- Line: 155
        -- upvalues: _logWarn (ref), InsMgr (ref)
        if not (p5 and p5:IsA("Player")) then
            _logWarn("[WorldUtil] PRIVATE_SERVER_OWNER_ID invalid player");

            return;
        end;

        local v7 = tonumber(p6);

        if v7 then
            InsMgr.GetIns("私人服务器玩家id", "NumberValue", workspace).Value = v7;

            return;
        end;

        _logWarn("[WorldUtil] PRIVATE_SERVER_OWNER_ID invalid data:", p6);
    end);
end;

if RunService:IsServer() then
    v1.RegisterNetWork();
end;

return v1;