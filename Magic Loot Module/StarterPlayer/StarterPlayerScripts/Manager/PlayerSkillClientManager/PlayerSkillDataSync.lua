-- Decompiled with Potassium's decompiler.

local PlayerData = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).PlayerData;
local SkillSlotConfig = require(script.Parent.SkillSlotConfig);
local PlayerSkillBinding = require(script.Parent.PlayerSkillBinding);
local v1 = {};
local u2 = nil;

function v1.setMobileSkillsVisualCallback(p3) -- Line: 26
    -- upvalues: u2 (ref)
    u2 = p3;
end;

function v1.connect() -- Line: 33
    -- upvalues: PlayerData (copy), SkillSlotConfig (copy), PlayerSkillBinding (copy), u2 (ref)
    PlayerData.ListenClientSync(function(p4, p5) -- Line: 34
        -- upvalues: SkillSlotConfig (ref), PlayerSkillBinding (ref), u2 (ref)
        local v6 = SkillSlotConfig.normalizeUpdateKey(p4);

        if v6 == "InputSettings" then
            SkillSlotConfig.rebuildKeyMap();

            return;
        end;

        if v6 == "skills" then
            PlayerSkillBinding.syncSkillPotencyFromPlayerData();

            if u2 then
                u2();
            end;
        end;
    end);
end;

return v1;