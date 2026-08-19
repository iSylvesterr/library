-- Decompiled with Potassium's decompiler.

local SoundService = game:GetService("SoundService");
local v8 = {
    PlaySound = function(p1, p2, p3) -- Line: 12, Name: PlaySound
        -- upvalues: SoundService (copy)
        local v4 = nil;

        if typeof(p2) == "Instance" then
            if p2:IsA("Sound") then
                v4 = p2;
            end;
        end;

        if not v4 then
            return warn((`Sound not found for {p2}`));
        end;

        if not p3 then
            SoundService:PlayLocalSound(v4);

            return v4;
        end;

        local Part = Instance.new("Part");
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Massless = true;
        Part.Anchored = true;
        Part.Parent = workspace;
        Part.Transparency = 1;
        Part.Position = p3;
        local v5 = v4:Clone();
        v5.Parent = Part;
        local v6 = os.clock();

        while not v5.IsLoaded and os.clock() - v6 < 2 do
            task.wait();
        end;

        if v5.IsLoaded then
            v5:Play();
        else
            Part:Destroy();
        end;

        v5.Ended:Once(function() -- Line: 51
            -- upvalues: Part (copy)
            Part:Destroy();
        end);

        return v4;
    end,

    UpdateOST = function(p7) -- Line: 58, Name: UpdateOST
    end,

    Start = function() -- Line: 59, Name: Start
    end
};
v8.Start();

return v8;