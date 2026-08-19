-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local v1 = {};
local u2 = game:GetService("RunService"):IsStudio();

local function debugPrint(...) -- Line: 21
    -- upvalues: u2 (copy)
    if u2 then
        print("[MedalClipper]", ...);
    end;
end;

local function base64Encode(p3) -- Line: 27
    local v4 = #p3;
    local v5 = 1;
    local v6 = {};

    while v5 <= v4 do
        local v7 = p3:byte(v5) or 0;
        local v8 = p3:byte(v5 + 1) or 0;
        local v9 = p3:byte(v5 + 2) or 0;
        local v10 = v7 * 65536 + v8 * 256 + v9;
        local v11 = math.floor(v10 / 262144) % 64 + 1;
        local v12 = math.floor(v10 / 4096) % 64 + 1;
        local v13 = math.floor(v10 / 64) % 64 + 1;
        local v14 = v10 % 64 + 1;
        v6[#v6 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v11, v11);
        v6[#v6 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v12, v12);

        if v4 < v5 + 1 then
            v6[#v6 + 1] = "==";
            break;
        end;

        if v4 < v5 + 2 then
            v6[#v6 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v13, v13) .. "=";
            break;
        end;

        v6[#v6 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v13, v13) .. ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v14, v14);
        v5 = v5 + 3;
    end;

    return table.concat(v6);
end;

function v1.TriggerClip(p15, p16, p17, p18) -- Line: 62
    -- upvalues: debugPrint (copy), base64Encode (copy), HttpService (copy)
    local v19 = p18 or {};
    debugPrint("TriggerClip", `eventId={p16}`, `eventName={p17}`, `duration={v19.duration or 30}`, (`captureDelayMs={v19.captureDelayMs or 0}`));
    local v20 = {
        eventId = p16,
        eventName = p17,
        triggerActions = { "SaveClip" },
        clipOptions = {
            duration = v19.duration or 30,
            captureDelayMs = v19.captureDelayMs
        }
    };

    if v19.contextTags and next(v19.contextTags) then
        v20.contextTags = v19.contextTags;
    end;

    print("[_MAPIEvent][v1/event/invoke]", base64Encode(HttpService:JSONEncode({
        gameEvent = v20,
        universeId = game.GameId
    })));
end;

return v1;