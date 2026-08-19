-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local Other = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Other");
local Debris2 = workspace:WaitForChild("Debris");

local function resolveVictimRagdoll(p1) -- Line: 14
    -- upvalues: Players (copy), Debris2 (copy)
    local v2 = Players:GetPlayerByUserId(p1);

    if not v2 then
        return nil;
    end;

    local v3 = Debris2:FindFirstChild(v2.Name);

    if v3 and (v3:IsA("Model") and v3:HasTag("Ragdoll")) then
        return v3;
    end;

    return nil;
end;

return function(p4) -- Line: 28
    -- upvalues: Other (copy), Players (copy), Debris2 (copy), Debris (copy)
    local v5 = tonumber(p4);

    if not v5 then
        return;
    end;

    local ZeusDeath = Other:FindFirstChild("ZeusDeath");

    if not (ZeusDeath and ZeusDeath:IsA("ParticleEmitter")) then
        return;
    end;

    local v6 = Players:GetPlayerByUserId(v5);
    local v7;

    if v6 then
        v7 = Debris2:FindFirstChild(v6.Name);

        if not (v7 and (v7:IsA("Model") and v7:HasTag("Ragdoll"))) then
            v7 = nil;
        end;
    else
        v7 = nil;
    end;

    if not v7 then
        local v8 = os.clock() + 0.5;

        repeat
            if true then
                task.wait(0.05);
                local v9 = Players:GetPlayerByUserId(v5);

                if v9 then
                    v7 = Debris2:FindFirstChild(v9.Name);

                    if not (v7 and (v7:IsA("Model") and v7:HasTag("Ragdoll"))) then
                        v7 = nil;
                    end;
                else
                    v7 = nil;
                end;
            end;
        until v7 or v8 <= os.clock();
    end;

    if not v7 then
        return;
    end;

    local HumanoidRootPart = v7:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local u10 = ZeusDeath:Clone();
    u10.Enabled = false;
    u10.Parent = HumanoidRootPart;
    local v11 = u10:GetAttribute("EmitCount");

    if typeof(v11) == "number" and v11 > 0 then
        u10:Emit(v11);
    else
        u10.Enabled = true;
        task.delay(0.15, function() -- Line: 66
            -- upvalues: u10 (copy)
            if u10 and u10.Parent then
                u10.Enabled = false;
            end;
        end);
    end;

    Debris:AddItem(u10, math.max(u10.Lifetime.Max, 1) + 1);
end;