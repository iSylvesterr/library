-- Decompiled with Potassium's decompiler.

local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ParseAssetId = require(ReplicatedStorage.Library.Functions.ParseAssetId);

return function(p1, p2, p3) -- Line: 20
    -- upvalues: ParseAssetId (copy), SoundService (copy)
    if type(p2) == "string" then
        p2 = ParseAssetId(p2);
    end;

    local v4 = type(p2) == "number";
    assert(v4, "Music sound id must resolve to a number");
    assert(p2 > 0, "Music sound id must be greater than 0");
    local Music = script.Parent.Music;
    local v5 = Music:IsA("Folder");
    assert(v5, "Expected Audio.Music folder");
    local GameMusic = SoundService.Music.GameMusic;
    local v6 = GameMusic:IsA("SoundGroup");
    assert(v6, "Expected SoundService.Music sound group");
    local Sound = Instance.new("Sound");
    Sound.Name = p1;
    Sound.SoundId = ("rbxassetid://%d"):format(p2);
    Sound.Volume = 0;
    Sound.Looped = p3;
    Sound.SoundGroup = GameMusic;
    Sound.Parent = Music;

    return Sound;
end;