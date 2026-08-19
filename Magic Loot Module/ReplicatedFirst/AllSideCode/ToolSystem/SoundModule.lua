-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;

return {
    PlaySound = function(p1, p2, p3) -- Line: 161, Name: PlaySound
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireClient(p2, NetMsg.PLAY_SOUND, p3);
    end,

    StopSound = function(p4, p5, p6) -- Line: 170, Name: StopSound
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireClient(p5, NetMsg.STOP_SOUND, p6);
    end,

    PlaySoundLocal = function(p7, p8) -- Line: 178, Name: PlaySoundLocal
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireBindable(NetMsg.PLAY_SOUND, p8);
    end,

    StopSoundLocal = function(p9, p10) -- Line: 186, Name: StopSoundLocal
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireBindable(NetMsg.STOP_SOUND, p10);
    end
};