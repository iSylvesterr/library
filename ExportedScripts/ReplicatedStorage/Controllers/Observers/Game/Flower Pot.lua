-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
require(script:WaitForChild("Types"));
local Debris2 = workspace:WaitForChild("Debris");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Sound = require(ReplicatedStorage.Classes.Sound);

local function createDuplicateFlowerPot(p1) -- Line: 20
    -- upvalues: Debris2 (copy)
    local v2 = p1:GetPivot();
    p1:SetAttribute("Broken", false);
    p1:RemoveTag("Flower Pot");
    p1:RemoveTag("Interactable");
    local v3 = p1:Clone();
    v3:PivotTo(v2);
    v3.Parent = Debris2;

    for _, child in ipairs(v3:GetChildren()) do
        if child:IsA("BasePart") then
            child.CanCollide = true;
            child.Transparency = 0;

            if child.Name == "Unbroken" then
                child.Transparency = 1;
            end;
        end;
    end;

    return v3;
end;

local function createBreakPoints(p4) -- Line: 47
    -- upvalues: Debris (copy), Sound (copy)
    local v5 = p4:GetAttribute("Direction");

    for _, child in ipairs(p4:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "Unbroken" then
            child.CollisionGroup = "Debris";
            child.Anchored = false;
            child.Massless = true;
        end;
    end;

    for _, child in ipairs(p4:GetChildren()) do
        if child:IsA("BasePart") then
            child:ApplyImpulse(v5 * math.random(2, 3));
        end;
    end;

    Debris:AddItem(p4, 5);
    Sound.new("Bullet"):playOneTime({
        Name = "Break Flower Pot",
        Parent = p4.PrimaryPart
    });
end;

return Observers.observeTag("Flower Pot", function(u6) -- Line: 79
    -- upvalues: Observers (copy), createDuplicateFlowerPot (copy), createBreakPoints (copy)
    if u6:IsDescendantOf(workspace) then
        return Observers.observeAttribute(u6, "Broken", function(p7) -- Line: 85
            -- upvalues: createDuplicateFlowerPot (ref), u6 (copy), createBreakPoints (ref)
            if p7 then
                createBreakPoints((createDuplicateFlowerPot(u6)));
            end;
        end);
    end;
end);