-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local v1 = {
    INTERVAL = {
        FAST = 0.1,
        HALF = 0.5,
        SEC = 1,
        SEC_30 = 30,
        SEC_120 = 120,
        SEC_300 = 300
    }
};
local u2 = {};
local u3 = nil;
local u4 = RunService:IsServer();

local function _validateRegisterArgs(p5, p6) -- Line: 103
    -- upvalues: u4 (copy)
    if not u4 then
        warn("[UpdateModule] Register 仅可在服务端调用");

        return false;
    end;

    if type(p5) ~= "number" or p5 <= 0 then
        warn("[UpdateModule] interval 必须为正数:", p5);

        return false;
    end;

    if type(p6) == "function" then
        return true;
    end;

    warn("[UpdateModule] callback 必须为 function");

    return false;
end;

local function _invokeEntryCallback(p7, u8) -- Line: 127
    local callback = p7.callback;

    if p7.spawn then
        task.spawn(function() -- Line: 130
            -- upvalues: callback (copy), u8 (copy)
            local success, result = pcall(callback, u8);

            if not success then
                warn("[UpdateModule] callback 执行失败:", result);
            end;
        end);

        return;
    end;

    local success, result = pcall(callback, u8);

    if not success then
        warn("[UpdateModule] callback 执行失败:", result);
    end;
end;

local function _onHeartbeat(p9) -- Line: 148
    -- upvalues: u2 (copy), _invokeEntryCallback (copy)
    for _, v in u2 do
        v.elapsed = v.elapsed + p9;

        if v.elapsed >= v.interval then
            local elapsed = v.elapsed;
            v.elapsed = v.elapsed - v.interval;
            _invokeEntryCallback(v, elapsed);
        end;
    end;
end;

function v1.Register(p10, p11, p12) -- Line: 170
    -- upvalues: _validateRegisterArgs (copy), u2 (copy)
    if not _validateRegisterArgs(p10, p11) then
        return;
    end;

    local v13 = 0;
    local v14 = false;

    if p12 then
        if p12.initialElapsed ~= nil then
            if type(p12.initialElapsed) ~= "number" or p12.initialElapsed < 0 then
                warn("[UpdateModule] initialElapsed 必须为非负数:", p12.initialElapsed);

                return;
            end;

            v13 = p12.initialElapsed;
        end;

        if p12.spawn ~= nil then
            v14 = p12.spawn;
        end;
    end;

    table.insert(u2, {
        interval = p10,
        elapsed = v13,
        callback = p11,
        spawn = v14
    });
end;

function v1.Start() -- Line: 202
    -- upvalues: u4 (copy), u3 (ref), RunService (copy), _onHeartbeat (copy)
    if not u4 then
        return;
    end;

    if u3 then
        return;
    end;

    u3 = RunService.Heartbeat:Connect(_onHeartbeat);
end;

return v1;