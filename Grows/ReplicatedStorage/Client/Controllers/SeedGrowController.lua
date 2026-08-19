-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local SeedConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("SeedConfig"));
local v1 = Knit.CreateController({
    Name = "SeedGrowController"
});

function v1.KnitStart(p2) -- Line: 26
    -- upvalues: Knit (copy), ReplicatedStorage (copy), SeedConfig (copy), RunService (copy), TweenService (copy)
    local u3 = Knit.GetController("SoundController");
    local v4 = Knit.GetService("SeedConveyorService");
    local ConveyorSeeds = workspace:WaitForChild("BigField"):WaitForChild("ConveyorSeeds");
    local SeedGrowPart = ConveyorSeeds:WaitForChild("SeedGrowPart");
    local SeedSpawner = ConveyorSeeds:WaitForChild("SeedSpawner");
    local SeedSplashFX = ConveyorSeeds:WaitForChild("SeedSplashFX");
    local Seeds = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("Seeds");
    local Position = SeedGrowPart.Position;
    local Position2 = SeedSpawner.Position;
    local u5 = nil;
    local u6 = nil;

    local function getNaturalHeight(p7) -- Line: 47
        if p7:IsA("BasePart") then
            return p7.Size.Y;
        end;

        local v8 = (1 / 0);
        local v9 = (-1 / 0);

        for _, descendant in p7:GetDescendants() do
            if descendant:IsA("BasePart") then
                local v10 = descendant.Size.Y / 2;
                local Y = descendant.Position.Y;
                v8 = math.min(v8, Y - v10);
                v9 = math.max(v9, Y + v10);
            end;
        end;

        return math.max(0.01, v9 - v8);
    end;

    local function playSplash() -- Line: 61
        -- upvalues: SeedSplashFX (copy), u3 (copy)
        for _, descendant in SeedSplashFX:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant:Emit(descendant:GetAttribute("EmitCount") or 15);
            end;
        end;

        u3:PlaySound("SeedDrop", SeedSplashFX, {
            RollOffMaxDistance = 50
        });
    end;

    local function startGrowCycle(p11) -- Line: 70
        -- upvalues: u6 (ref), u5 (ref), SeedConfig (ref), Seeds (copy), ConveyorSeeds (copy), getNaturalHeight (copy), RunService (ref), Position (copy), u3 (copy), SeedGrowPart (copy), Position2 (copy), TweenService (ref), playSplash (copy)
        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        if u5 then
            u5:Destroy();
            u5 = nil;
        end;

        local u12 = Seeds:FindFirstChild(SeedConfig.SEED_MODEL_NAMES[p11] or p11 .. "Seed");

        if not u12 then
            return;
        end;

        local u13 = u12:Clone();
        u13.Name = "GrowingSeed";

        if u13:IsA("BasePart") then
            u13.Anchored = true;
            u13.CanCollide = false;
            u13.CanQuery = false;
            u13.CanTouch = false;
        else
            for _, descendant in u13:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true;
                    descendant.CanCollide = false;
                    descendant.CanQuery = false;
                    descendant.CanTouch = false;
                end;
            end;
        end;

        u13.Parent = ConveyorSeeds;
        u5 = u13;
        local u14 = getNaturalHeight(u12);
        local u15 = os.clock();
        u6 = RunService.Heartbeat:Connect(function() -- Line: 103
            -- upvalues: u5 (ref), u6 (ref), u15 (copy), u13 (copy), u14 (copy), Position (ref), u12 (copy), u3 (ref), SeedGrowPart (ref), Position2 (ref), TweenService (ref), playSplash (ref), RunService (ref)
            if not (u5 and u5.Parent) then
                if u6 then
                    u6:Disconnect();
                    u6 = nil;
                end;

                return;
            end;

            local v16 = (os.clock() - u15) / 2.6;
            local v17 = math.clamp(v16, 0, 1);
            local v18 = math.max(0.001, v17);

            if u13:IsA("Model") then
                u13:ScaleTo(v18);
                u13:PivotTo(CFrame.new(Position) * CFrame.new(0, -(u14 * v18) / 2, 0));
            else
                u13.Size = u12.Size * v18;
                local v19 = u12.Size.Y * v18;
                u13.CFrame = CFrame.new(Position) * CFrame.new(0, -v19 / 2, 0);
            end;

            if v17 >= 1 then
                u6:Disconnect();
                u6 = nil;
                u3:PlaySound("TwigSnap", SeedGrowPart, {
                    RollOffMaxDistance = 62.5
                });
                local u20 = u13:IsA("Model") and u13:GetPivot() or u13.CFrame;
                local u21;

                if u13:IsA("Model") then
                    u21 = CFrame.new(Position.X, Position2.Y + u14 / 2, Position.Z);
                else
                    u21 = CFrame.new(Position.X, Position2.Y + u13.Size.Y / 2, Position.Z);
                end;

                local v22 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

                if u13:IsA("BasePart") then
                    local v23 = TweenService:Create(u13, v22, {
                        CFrame = u21
                    });
                    v23:Play();
                    v23.Completed:Once(function() -- Line: 142
                        -- upvalues: playSplash (ref), u13 (ref), u5 (ref)
                        playSplash();

                        if u13 and u13.Parent then
                            u13:Destroy();
                        end;

                        u5 = nil;
                    end);
                else
                    local u24 = os.clock();
                    local u25 = nil;
                    u25 = RunService.Heartbeat:Connect(function() -- Line: 150
                        -- upvalues: u24 (copy), u13 (ref), u20 (copy), u21 (ref), u25 (ref), playSplash (ref), u5 (ref)
                        local v26 = (os.clock() - u24) / 0.4;
                        local v27 = math.clamp(v26, 0, 1);
                        u13:PivotTo(u20:Lerp(u21, v27 * v27));

                        if v27 >= 1 then
                            u25:Disconnect();
                            playSplash();

                            if u13 and u13.Parent then
                                u13:Destroy();
                            end;

                            u5 = nil;
                        end;
                    end);
                end;
            end;
        end);
    end;

    v4.SeedGrowStarted:Connect(function(p28) -- Line: 165
        -- upvalues: startGrowCycle (copy)
        startGrowCycle(p28);
    end);
end;

function v1.KnitInit(p29) -- Line: 170
end;

return v1;