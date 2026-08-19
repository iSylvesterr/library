-- Decompiled with Potassium's decompiler.

local v1 = {};
local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);

local function collectParts(p2) -- Line: 24
    local v3 = {};

    if p2:IsA("BasePart") then
        table.insert(v3, p2);
    end;

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v3, descendant);
        end;
    end;

    return v3;
end;

local function playPoof(p4) -- Line: 37
    -- upvalues: ReplicatedStorage (copy), collectParts (copy), Debris (copy)
    local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Poof");
    end;

    if not Assets then
        return;
    end;

    local u5 = Assets:Clone();
    local v6 = collectParts(u5);

    for _, v in v6 do
        v.Anchored = false;
        v.CanCollide = false;
        v.CanQuery = false;
        v.CanTouch = false;
        v.Massless = true;
    end;

    if u5:IsA("BasePart") then
        u5.CFrame = HumanoidRootPart.CFrame;
    elseif u5:IsA("Model") then
        u5:PivotTo(HumanoidRootPart.CFrame);
    end;

    u5.Parent = p4;

    for _, v in v6 do
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v;
        WeldConstraint.Part1 = HumanoidRootPart;
        WeldConstraint.Parent = v;
    end;

    task.spawn(function() -- Line: 81
        -- upvalues: u5 (copy)
        task.wait();

        if not u5.Parent then
            return;
        end;

        for _, descendant in u5:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                local v7;

                if descendant.Rate > 0 then
                    local v8 = math.floor(descendant.Rate);
                    v7 = math.max(3, v8) or 5;
                else
                    v7 = 5;
                end;

                descendant:Emit(v7);
            end;
        end;
    end);
    Debris:AddItem(u5, 5);
end;

function v1.Init(p9) -- Line: 97
end;

function v1.Start(p10) -- Line: 99
    -- upvalues: Networking (copy), playPoof (copy)
    Networking.Werewolf.Transformed.OnClientEvent:Connect(function(p11) -- Line: 100
        -- upvalues: playPoof (ref)
        if typeof(p11) ~= "Instance" or not p11:IsA("Player") then
            return;
        end;

        local Character = p11.Character;

        if Character then
            playPoof(Character);
        end;
    end);
end;

return v1;