-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = require(ReplicatedStorage.Packages.Knit).CreateController({
    Name = "OwnerPortraitController"
});

function v1.KnitStart(p2) -- Line: 16
    -- upvalues: Players (copy), RunService (copy)
    local LocalPlayer = Players.LocalPlayer;
    local u3 = {};

    local function track(u4) -- Line: 21
        -- upvalues: u3 (copy)
        if u3[u4] then
            return;
        end;

        task.spawn(function() -- Line: 23
            -- upvalues: u4 (copy), u3 (ref)
            local OwnerPortrait = u4:WaitForChild("OwnerPortrait", 20);

            if OwnerPortrait then
                OwnerPortrait = OwnerPortrait:WaitForChild("Billboard", 10);
            end;

            if OwnerPortrait then
                OwnerPortrait = OwnerPortrait:WaitForChild("Frame", 10);
            end;

            if OwnerPortrait then
                OwnerPortrait = OwnerPortrait:WaitForChild("PlayerPortrait", 10);
            end;

            local SeedPlot = u4:WaitForChild("SeedPlot", 20);

            if SeedPlot then
                SeedPlot = SeedPlot:WaitForChild("PlotTP", 10);
            end;

            if OwnerPortrait and (SeedPlot and u4.Parent) then
                u3[u4] = {
                    image = OwnerPortrait,
                    seedPart = SeedPlot
                };
            end;
        end);
    end;

    local PlayerPlots = workspace:WaitForChild("BigField"):WaitForChild("PlayerPlots");

    for _, child in PlayerPlots:GetChildren() do
        if child:IsA("Model") and child.Name:match("^PlayerPlot") then
            if not u3[child] then
                task.spawn(function() -- Line: 23
                    -- upvalues: child (copy), u3 (copy)
                    local OwnerPortrait = child:WaitForChild("OwnerPortrait", 20);

                    if OwnerPortrait then
                        OwnerPortrait = OwnerPortrait:WaitForChild("Billboard", 10);
                    end;

                    if OwnerPortrait then
                        OwnerPortrait = OwnerPortrait:WaitForChild("Frame", 10);
                    end;

                    if OwnerPortrait then
                        OwnerPortrait = OwnerPortrait:WaitForChild("PlayerPortrait", 10);
                    end;

                    local SeedPlot = child:WaitForChild("SeedPlot", 20);

                    if SeedPlot then
                        SeedPlot = SeedPlot:WaitForChild("PlotTP", 10);
                    end;

                    if OwnerPortrait and (SeedPlot and child.Parent) then
                        u3[child] = {
                            image = OwnerPortrait,
                            seedPart = SeedPlot
                        };
                    end;
                end);
            end;
        end;
    end;

    PlayerPlots.ChildAdded:Connect(function(u5) -- Line: 40
        -- upvalues: u3 (copy)
        if u5:IsA("Model") and u5.Name:match("^PlayerPlot") then
            if u3[u5] then
                return;
            end;

            task.spawn(function() -- Line: 23
                -- upvalues: u5 (copy), u3 (ref)
                local OwnerPortrait = u5:WaitForChild("OwnerPortrait", 20);

                if OwnerPortrait then
                    OwnerPortrait = OwnerPortrait:WaitForChild("Billboard", 10);
                end;

                if OwnerPortrait then
                    OwnerPortrait = OwnerPortrait:WaitForChild("Frame", 10);
                end;

                if OwnerPortrait then
                    OwnerPortrait = OwnerPortrait:WaitForChild("PlayerPortrait", 10);
                end;

                local SeedPlot = u5:WaitForChild("SeedPlot", 20);

                if SeedPlot then
                    SeedPlot = SeedPlot:WaitForChild("PlotTP", 10);
                end;

                if OwnerPortrait and (SeedPlot and u5.Parent) then
                    u3[u5] = {
                        image = OwnerPortrait,
                        seedPart = SeedPlot
                    };
                end;
            end);
        end;
    end);
    PlayerPlots.ChildRemoved:Connect(function(p6) -- Line: 43
        -- upvalues: u3 (copy)
        u3[p6] = nil;
    end);
    RunService.Heartbeat:Connect(function() -- Line: 47
        -- upvalues: LocalPlayer (copy), u3 (copy)
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character then
            Character = Character.Position;
        end;

        for i, v in u3 do
            if i.Parent and (v.image.Parent and v.seedPart.Parent) then
                if Character then
                    v.image.Visible = (v.seedPart.Position - Character).Magnitude > 60;
                end;
            else
                u3[i] = nil;
            end;
        end;
    end);
end;

function v1.KnitInit(p7) -- Line: 62
end;

return v1;