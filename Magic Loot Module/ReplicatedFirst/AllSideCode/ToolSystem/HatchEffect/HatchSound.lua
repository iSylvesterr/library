-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local EnumMgr = UtilsSystem.EnumMgr;
local u2 = {
    play = function(p1) -- Line: 20, Name: play
        -- upvalues: SoundModule (copy)
        SoundModule:PlaySoundLocal({
            Is2D = true,
            SoundName = p1
        });
    end
};

function u2.playResult(p3) -- Line: 31
    -- upvalues: EnumMgr (copy), u2 (copy)
    local v4 = math.clamp(p3, 1, EnumMgr.Rare.Xyd10);
    u2.play("音效-抽蛋-稀有度" .. v4);
end;

return u2;