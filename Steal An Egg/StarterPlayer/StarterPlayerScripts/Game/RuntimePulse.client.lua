-- Decompiled with Potassium's decompiler.

local CoreGui = game:GetService("CoreGui");
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Network = require(ReplicatedStorage.Library.Client.Network);
local u1 = { "dex", "dex explorer", "remote spy", "hydroxide", "dark dex", "simple spy", "owl hub", "rayfield", "infinite yield" };
local RuntimeSync = Constants.NETWORK_MAP.RuntimeSync;
local u2 = nil;
local u3 = 0;
local u4 = {};

local function concealScriptIdentity() -- Line: 50
    -- upvalues: HttpService (copy)
    local v5 = HttpService:GenerateGUID(false);
    local v6 = string.sub(v5, 1, 8);
    script.Name = string.format("Runtime_%s", v6);
end;

local function report(p7, p8) -- Line: 55
    -- upvalues: Network (copy), RuntimeSync (copy)
    Network.Fire(RuntimeSync.REPORT, p7, p8 or {});
end;

local function sendHeartbeat() -- Line: 59
    -- upvalues: u2 (ref), u3 (ref), Network (copy), RuntimeSync (copy)
    local v9 = u2;

    if not v9 then
        return;
    end;

    u3 = u3 + 1;
    Network.Fire(RuntimeSync.HEARTBEAT, {
        challengeId = v9.challengeId,
        nonce = v9.nonce,
        sequence = u3
    });
end;

local function scanCoreGui() -- Line: 73
    -- upvalues: CoreGui (copy), u1 (copy), u4 (copy), Network (copy), RuntimeSync (copy)
    local success, result = pcall(function() -- Line: 74
        -- upvalues: CoreGui (ref)
        return CoreGui:GetChildren();
    end);

    if not success then
        return;
    end;

    for _, v in ipairs(result) do
        local v10 = string.lower(v.Name);

        for _, v2 in ipairs(u1) do
            if string.find(v10, v2, 1, true) and not u4[v10] then
                u4[v10] = true;
                Network.Fire(RuntimeSync.REPORT, "CoreGuiHeuristic", {
                    name = v.Name,
                    className = v.ClassName
                } or {});
                break;
            end;
        end;
    end;
end;

local v11 = HttpService:GenerateGUID(false);
local v12 = string.sub(v11, 1, 8);
script.Name = string.format("Runtime_%s", v12);
Network.Fired(RuntimeSync.CHALLENGE):Connect(function(p13) -- Line: 98
    -- upvalues: u2 (ref)
    u2 = p13;
end);
script:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 102
    -- upvalues: Network (copy), RuntimeSync (copy)
    if not script.Enabled then
        Network.Fire(RuntimeSync.REPORT, "Tamper", {
            reason = "DetectorDisabled",
            severity = 2
        } or {});
    end;
end);
script.Destroying:Connect(function() -- Line: 111
    -- upvalues: Network (copy), RuntimeSync (copy)
    Network.Fire(RuntimeSync.REPORT, "Tamper", {
        reason = "DetectorDestroying",
        severity = 2
    } or {});
end);
task.spawn(function() -- Line: 118
    -- upvalues: u2 (ref), u3 (ref), Network (copy), RuntimeSync (copy), scanCoreGui (copy)
    while true do
        local v14 = u2;

        if v14 then
            u3 = u3 + 1;
            Network.Fire(RuntimeSync.HEARTBEAT, {
                challengeId = v14.challengeId,
                nonce = v14.nonce,
                sequence = u3
            });
        end;

        scanCoreGui();
        local v15 = (not u2 or type(u2.heartbeatInterval) ~= "number") and 4 or math.max(2, u2.heartbeatInterval);
        task.wait(v15);
    end;
end);