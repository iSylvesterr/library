-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local UtilsSystem = require(ReplicatedFirst.AllSideCode.UtilsSystem);
local FXUtil = UtilsSystem.FXUtil;
local SoundModule = UtilsSystem.SoundModule;
local v1 = {};

local function _playEntry(p2) -- Line: 25
    -- upvalues: FXUtil (copy), SoundModule (copy)
    local effectName = p2.effectName;
    local hitPos = p2.hitPos;

    if typeof(effectName) ~= "string" or (effectName == "" or typeof(hitPos) ~= "Vector3") then
        return;
    end;

    local targetScale = p2.targetScale;
    local v3 = (typeof(targetScale) ~= "number" or targetScale <= 0) and 1 or targetScale;
    FXUtil.PlayEffect(effectName, CFrame.new(hitPos), 4, 3, nil, v3);
    local soundNames = p2.soundNames;

    if type(soundNames) ~= "table" then
        return;
    end;

    for _, v in soundNames do
        if typeof(v) == "string" and v ~= "" then
            SoundModule:PlaySoundLocal({
                Is2D = false,
                SoundName = v,
                PlayPosition = hitPos
            });
        end;
    end;
end;

function v1.handleIncoming(p4) -- Line: 60
    -- upvalues: _playEntry (copy)
    if type(p4) ~= "table" then
        return;
    end;

    for _, v in p4 do
        if type(v) == "table" then
            _playEntry(v);
        end;
    end;
end;

return v1;