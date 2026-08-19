-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local Sound = Instance.new("Sound");
Sound.SoundId = "rbxassetid://84155768909514";
Sound.Volume = 0.05;
Sound.Name = "CrackTemplate";
local Sound2 = Instance.new("Sound");
Sound2.SoundId = "rbxassetid://89998269803036";
Sound2.Volume = 0.05;
Sound2.Name = "ShatterTemplate";
local Sound3 = Instance.new("Sound");
Sound3.SoundId = "rbxassetid://91367338760317";
Sound3.Volume = 1.5;
Sound3.Name = "FreezeSFX";
local Sound4 = Instance.new("Sound");
Sound4.SoundId = "rbxassetid://91367338760317";
Sound4.Volume = 0.6;
Sound4.PlaybackSpeed = 0.7;
Sound4.Name = "ThawSFX";
local u4 = {
    _play = function(p1, p2) -- Line: 36, Name: _play
        -- upvalues: SoundService (copy), Debris (copy)
        local v3 = p1:Clone();

        if p2 then
            v3.PlaybackSpeed = p2;
        end;

        v3.Parent = SoundService;
        v3:Play();
        Debris:AddItem(v3, v3.TimeLength + 0.1);

        return v3;
    end
};

function u4.PlayCrack(p5) -- Line: 53
    -- upvalues: u4 (copy), Sound (copy)
    return u4._play(Sound, p5);
end;

function u4.PlayShatter(p6) -- Line: 57
    -- upvalues: u4 (copy), Sound2 (copy)
    return u4._play(Sound2, p6);
end;

function u4.PlayFreeze() -- Line: 61
    -- upvalues: u4 (copy), Sound3 (copy)
    return u4._play(Sound3, nil);
end;

function u4.PlayThaw() -- Line: 65
    -- upvalues: u4 (copy), Sound4 (copy)
    return u4._play(Sound4, nil);
end;

return u4;