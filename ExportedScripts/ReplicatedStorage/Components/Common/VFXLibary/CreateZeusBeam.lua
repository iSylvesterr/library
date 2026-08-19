-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Other = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Other");
local Debris2 = workspace:WaitForChild("Debris");

local function getNumberAttribute(p1, p2, p3) -- Line: 13
    local v4 = p1:GetAttribute(p2);

    if typeof(v4) == "number" then
        return v4;
    end;

    return p3;
end;

local function getBeamUpVector(p5, p6) -- Line: 22
    local v7 = p6 - p5 * p6:Dot(p5);

    if v7.Magnitude <= 0.001 then
        v7 = Vector3.new(0, 1, 0) - p5 * (Vector3.new(0, 1, 0)):Dot(p5);
    end;

    if v7.Magnitude <= 0.001 then
        v7 = Vector3.new(0, 0, 1) - p5 * (Vector3.new(0, 0, 1)):Dot(p5);
    end;

    return v7.Unit;
end;

local function getBeamCleanupTime(p8) -- Line: 35
    local v9 = 5;

    for _, descendant in ipairs(p8:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local v10 = descendant:GetAttribute("EmitDelay");
            local v11 = (typeof(v10) ~= "number" and 0 or v10) + math.max(descendant.Lifetime.Max, 1) + 1;
            v9 = math.max(v9, v11);
        end;
    end;

    return v9;
end;

return function(p12) -- Line: 48
    -- upvalues: Other (copy), getBeamUpVector (copy), Debris2 (copy), Debris (copy), getBeamCleanupTime (copy)
    local ZeusBeam = Other:FindFirstChild("ZeusBeam");

    if not (ZeusBeam and ZeusBeam:IsA("BasePart")) then
        return nil;
    end;

    local LookVector = p12.CFrame.LookVector;

    if LookVector.Magnitude <= 0.001 then
        return nil;
    end;

    local Unit = LookVector.Unit;
    local v13 = ZeusBeam:Clone();
    v13.CollisionGroup = "Debris";
    v13.CanCollide = false;
    v13.CanQuery = false;
    v13.CanTouch = false;
    v13.Anchored = true;
    local v14 = p12.Position + Unit * (v13.Size.X * 0.5);
    local v15 = getBeamUpVector(Unit, p12.CFrame.UpVector);
    v13.CFrame = CFrame.fromMatrix(v14, Unit, v15);
    v13.Parent = Debris2;

    for _, descendant in ipairs(v13:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local v16 = descendant:GetAttribute("EmitDelay");
            local v17 = typeof(v16) ~= "number" and 0 or v16;
            task.delay(v17, function() -- Line: 76
                -- upvalues: descendant (copy)
                if not descendant.Parent then
                    return;
                end;

                local v18 = descendant:GetAttribute("EmitCount");
                local v19 = typeof(v18) ~= "number" and 0 or v18;

                if v19 > 0 then
                    descendant:Emit(v19);

                    return;
                end;

                descendant.Enabled = true;
                task.delay(0.15, function() -- Line: 86
                    -- upvalues: descendant (ref)
                    if descendant.Parent then
                        descendant.Enabled = false;
                    end;
                end);
            end);
        end;
    end;

    Debris:AddItem(v13, (getBeamCleanupTime(v13)));

    return v13;
end;