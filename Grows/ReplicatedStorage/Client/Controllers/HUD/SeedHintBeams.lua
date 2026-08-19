-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local u1 = { "Pine", "Apple" };
local v2 = Knit.CreateController({
    Name = "SeedHintBeams"
});

function v2.KnitStart(u3) -- Line: 18
    -- upvalues: Maid (copy), Players (copy), ReplicatedStorage (copy), u1 (copy), RunService (copy), CustomEnum (copy), SeedConfig (copy)
    local v4 = Maid.new();
    u3._maid = v4;
    local LocalPlayer = Players.LocalPlayer;
    local ArrowBeam = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("ArrowBeam");
    local u5 = {};

    for _, v in u1 do
        local v6 = ArrowBeam:Clone();
        v6.Name = "SeedHintBeam_" .. v;
        v6.Anchored = true;
        v6.CFrame = CFrame.new(0, -500, 0);
        v6.Parent = workspace;
        local Start = v6:WaitForChild("Start");
        local End = v6:WaitForChild("End");
        local Beam = Start:WaitForChild("Beam");
        Beam.Enabled = false;
        u5[v] = {
            startAtt = Start,
            endAtt = End,
            beam = Beam
        };
        v4:GiveTask(v6);
    end;

    local function nearestSeedHolder(p7) -- Line: 40
        -- upvalues: LocalPlayer (copy)
        local BigField = workspace:FindFirstChild("BigField");

        if BigField then
            BigField = BigField:FindFirstChild("ConveyorSeeds");
        end;

        local v8 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

        if not (BigField and v8) then
            return nil;
        end;

        local v9 = nil;
        local v10 = nil;

        for _, child in BigField:GetChildren() do
            if child:GetAttribute("SeedType") == p7 then
                local Position = child:GetPivot().Position;
                local Magnitude = (Position - v8.Position).Magnitude;

                if not v9 or Magnitude < v9 then
                    v10 = Position;
                    v9 = Magnitude;
                end;
            end;
        end;

        return v10;
    end;

    v4:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 56
        -- upvalues: u3 (copy), LocalPlayer (copy), CustomEnum (ref), u1 (ref), u5 (copy), SeedConfig (ref), nearestSeedHolder (copy)
        local currentData = u3.DataClient.currentData;
        local v11 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
        local v12 = currentData and currentData.Currency and (currentData.Currency[CustomEnum.CURRENCIES.COINS] or 0) or 0;
        local v13;

        if currentData then
            v13 = currentData.SeedBeamHints;
        else
            v13 = currentData;
        end;

        for _, v in u1 do
            local v14 = u5[v];
            local v15 = nil;

            if currentData and (v11 and ((currentData.Rebirth or 0) == 0 and not (v13 and v13[v]))) then
                local v16 = SeedConfig.GetSeed(v);

                if v16 and (v16.plantCost or (1 / 0)) <= v12 then
                    v15 = nearestSeedHolder(v);
                end;
            end;

            if v15 then
                local v17 = Vector3.new(v15.X - v11.Position.X, 0, v15.Z - v11.Position.Z);
                v14.startAtt.WorldPosition = v11.Position + (v17.Magnitude > 1 and v17.Unit or Vector3.new(0, 0, 1)) * 4;
                v14.endAtt.WorldPosition = Vector3.new(v15.X, v11.Position.Y, v15.Z);
                v14.beam.Enabled = true;
            else
                v14.beam.Enabled = false;
            end;
        end;
    end));
end;

function v2.KnitInit(p18) -- Line: 87
    -- upvalues: Knit (copy)
    p18.DataClient = Knit.GetController("DataClient");
end;

return v2;