-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {};

local function greedyChild(p2) -- Line: 8
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild(p2);
    end;

    return Assets;
end;

function u1.getPetFolder() -- Line: 14
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("Pets");
    end;

    return Assets;
end;

function u1.getEggFolder() -- Line: 18
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("Eggs");
    end;

    return Assets;
end;

function u1.resolvePet(p3) -- Line: 22
    -- upvalues: u1 (copy)
    local v4 = u1.getPetFolder();

    if v4 then
        if p3 then
            p3 = v4:FindFirstChild(p3);
        end;
    else
        p3 = v4;
    end;

    if not (p3 and (p3:IsA("Model") and p3)) then
        p3 = nil;
    end;

    return p3;
end;

function u1.resolveEgg(p5) -- Line: 28
    -- upvalues: u1 (copy)
    local v6 = u1.getEggFolder();

    if v6 then
        if p5 then
            p5 = v6:FindFirstChild(p5);
        end;
    else
        p5 = v6;
    end;

    if not (p5 and (p5:IsA("Model") and p5)) then
        p5 = nil;
    end;

    return p5;
end;

function u1.resolveRig(p7) -- Line: 35
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("PetRigs");
    end;

    if Assets then
        if p7 then
            p7 = Assets:FindFirstChild(p7);
        end;
    else
        p7 = Assets;
    end;

    if not (p7 and (p7:IsA("Model") and p7)) then
        p7 = nil;
    end;

    return p7;
end;

function u1.resolveTemplate(p8, p9) -- Line: 42
    -- upvalues: u1 (copy)
    if p8 == "Egg" then
        return u1.resolveEgg(p9);
    end;

    if p8 == "Pet" then
        return u1.resolvePet(p9);
    end;

    return nil;
end;

function u1.resolveDirt() -- Line: 49
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("PetDirt");
    end;

    if not (Assets and (Assets:IsA("Model") and Assets)) then
        Assets = nil;
    end;

    return Assets;
end;

return u1;