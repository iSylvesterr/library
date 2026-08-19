-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 0
};
local SoundService = game:GetService("SoundService");
local MusicTracks = SoundService:FindFirstChild("MusicTracks");
local u2 = SoundService:FindFirstChild("Master") and SoundService.Master:FindFirstChild("GameMusic");

local function patch(p3) -- Line: 47
    -- upvalues: u2 (copy), MusicTracks (copy), SoundService (copy)
    if p3.SoundGroup ~= nil then
        return;
    end;

    if p3.Name == "MegaphoneSound" then
        return;
    end;

    if p3.Name == "BoomboxSound" then
        return;
    end;

    if u2 and (MusicTracks and p3:IsDescendantOf(MusicTracks)) then
        p3.SoundGroup = u2;

        return;
    end;

    p3.SoundGroup = SoundService:FindFirstChild("SFXGroup");
end;

function v1.Init(p4) -- Line: 60
    -- upvalues: u2 (copy), MusicTracks (copy), SoundService (copy)
    game.DescendantAdded:Connect(function(p5) -- Line: 64
        -- upvalues: u2 (ref), MusicTracks (ref), SoundService (ref)
        if p5:IsA("Sound") then
            if p5.SoundGroup ~= nil then
                return;
            end;

            if p5.Name == "MegaphoneSound" then
                return;
            end;

            if p5.Name == "BoomboxSound" then
                return;
            end;

            if u2 and (MusicTracks and p5:IsDescendantOf(MusicTracks)) then
                p5.SoundGroup = u2;

                return;
            end;

            p5.SoundGroup = SoundService:FindFirstChild("SFXGroup");
        end;
    end);

    for _, descendant in game:GetDescendants() do
        if descendant:IsA("Sound") then
            if descendant.SoundGroup == nil then
                if descendant.Name ~= "MegaphoneSound" then
                    if descendant.Name ~= "BoomboxSound" then
                        if u2 and (MusicTracks and descendant:IsDescendantOf(MusicTracks)) then
                            descendant.SoundGroup = u2;
                        else
                            descendant.SoundGroup = SoundService:FindFirstChild("SFXGroup");
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

return v1;