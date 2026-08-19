-- Decompiled with Potassium's decompiler.

return {
    MusicVolumeSet = function(p1, p2) -- Line: 7, Name: MusicVolumeSet
        game.SoundService.Music.Volume = p2;
    end,

    SoundVolumeSet = function(p3, p4) -- Line: 11, Name: SoundVolumeSet
        game.SoundService.SoundEffects.Volume = p4;
    end
};