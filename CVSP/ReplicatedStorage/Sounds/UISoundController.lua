-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage"):WaitForChild("Sounds");
local PlayingSounds = game:GetService("SoundService"):WaitForChild("PlayingSounds");
local u1 = {
    playingSounds = {}
};

function u1.Play(p2) -- Line: 11
    -- upvalues: PlayingSounds (copy), u1 (copy)
    local v3 = script:FindFirstChild(p2);

    if not v3 then
        warn("UI sound missing:", p2);

        return;
    end;

    local u4 = v3:Clone();
    u4.Parent = PlayingSounds;
    u4:Play();
    u1.playingSounds[u4.Name] = u4;
    u4.Ended:Connect(function() -- Line: 23
        -- upvalues: u4 (copy)
        u4:Destroy();
    end);
end;

function u1.PlayWithPitch(p5, p6) -- Line: 28
    -- upvalues: PlayingSounds (copy), u1 (copy)
    local v7 = script:FindFirstChild(p5);

    if not v7 then
        warn("UI sound missing:", p5);

        return;
    end;

    local u8 = v7:Clone();
    u8.PlaybackSpeed = u8.PlaybackSpeed * p6;
    u8.Parent = PlayingSounds;
    u8:Play();
    u1.playingSounds[u8.Name] = u8;
    u8.Ended:Connect(function() -- Line: 42
        -- upvalues: u8 (copy)
        u8:Destroy();
    end);
end;

function u1.Stop(p9) -- Line: 47
    -- upvalues: u1 (copy)
    local v10 = u1.playingSounds[p9];

    if v10 then
        v10:Stop();
        v10:Destroy();
    end;
end;

return u1;