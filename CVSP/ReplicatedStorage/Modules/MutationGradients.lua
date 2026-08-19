-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local MutationGradients = script:WaitForChild("MutationGradients");
local Bindables = ReplicatedStorage:WaitForChild("Bindables");
local u1 = RunService:IsServer();

return {
    mutateText = function(u2, p3, p4) -- Line: 13, Name: mutateText
        -- upvalues: MutationGradients (copy), u1 (copy), RunService (copy), Bindables (copy)
        if p3 == "Gold" then
            MutationGradients.Gold:Clone().Parent = u2;
        end;

        if p3 == "Rainbow" then
            if p4 and p4.Tool then
                if u1 then
                    u2.TextColor3 = Color3.fromHSV(0, 1, 1);

                    return;
                end;

                local u5 = 0;
                local u6 = 0;
                local u7 = nil;
                u7 = RunService.Heartbeat:Connect(function(p8) -- Line: 30
                    -- upvalues: u6 (ref), u5 (ref), u2 (copy), u7 (ref)
                    u6 = u6 + p8;

                    if u6 < 0.1 then
                        return;
                    end;

                    u5 = u5 + u6 * 0.25;

                    if u5 > 1 then
                        u5 = u5 - 1;
                    end;

                    u6 = 0;
                    local v9 = Color3.fromHSV(u5, 1, 1);

                    if u2 and u2.Parent then
                        u2.TextColor3 = v9;

                        return;
                    end;

                    u7:Disconnect();
                end);
            else
                Bindables.AddRainbowText:Fire(u2);
            end;
        end;

        if p3 == "Moonlit" then
            MutationGradients.Moonlit:Clone().Parent = u2;
        end;

        if p3 == "Chilly" then
            MutationGradients.Chilly:Clone().Parent = u2;
        end;

        if p3 == "Tranquil" then
            MutationGradients.Tranquil:Clone().Parent = u2;
        end;

        if p3 == "Radiant" then
            MutationGradients.Radiant:Clone().Parent = u2;
        end;

        if p3 == "Shocked" then
            MutationGradients.Shocked:Clone().Parent = u2;
        end;

        if p3 == "Reverse" then
            MutationGradients.Reverse:Clone().Parent = u2;
        end;

        if p3 == "Scorched" then
            MutationGradients.Scorched:Clone().Parent = u2;
        end;

        if p3 == "Glitched" then
            MutationGradients.Glitched:Clone().Parent = u2;
        end;

        if p3 == "Toasty" then
            MutationGradients.Toasty:Clone().Parent = u2;
        end;

        if p3 == "Celestial" then
            MutationGradients.Celestial:Clone().Parent = u2;
        end;

        if p3 == "Permafrost" then
            MutationGradients.Permafrost:Clone().Parent = u2;
        end;

        if p3 == "Flipped" then
            MutationGradients.Flipped:Clone().Parent = u2;
        end;

        if p3 == "Taco" then
            MutationGradients.Taco:Clone().Parent = u2;
        end;
    end
};