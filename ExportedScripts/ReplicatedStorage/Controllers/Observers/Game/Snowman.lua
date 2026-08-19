-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
require(script:WaitForChild("Types"));
local Debris2 = workspace:WaitForChild("Debris");
local Observers = require(ReplicatedStorage.Packages.Observers);

local function createDuplicateSnowman(p1) -- Line: 17
    -- upvalues: Debris2 (copy)
    local v2 = p1:GetPivot();
    p1:SetAttribute("Broken", false);
    p1:RemoveTag("Snowman");
    p1:RemoveTag("Interactable");
    local v3 = p1:Clone();
    v3:PivotTo(v2);
    v3.Parent = Debris2;

    for _, child in ipairs(v3:GetChildren()) do
        if child.Name == "Head" then
            child.CanCollide = true;
            child.Transparency = 0;
        end;
    end;

    return v3;
end;

local function createBreakPoints(p4) -- Line: 40
    -- upvalues: Debris (copy)
    local v5 = p4:GetAttribute("Direction");

    for _, child in ipairs(p4:GetChildren()) do
        if child.Name == "Head" then
            child.CollisionGroup = "Debris";
            child.Anchored = false;
            child.Massless = true;

            if v5 then
                child:ApplyImpulse(math.random(30, 40) * v5);
            end;
        end;
    end;

    Debris:AddItem(p4, 10);
end;

return Observers.observeTag("Snowman", function(u6) -- Line: 61
    -- upvalues: Observers (copy), createDuplicateSnowman (copy), createBreakPoints (copy)
    if u6:IsDescendantOf(workspace) then
        return Observers.observeAttribute(u6, "Broken", function(p7) -- Line: 67
            -- upvalues: createDuplicateSnowman (ref), u6 (copy), createBreakPoints (ref)
            if p7 then
                createBreakPoints((createDuplicateSnowman(u6)));
            end;
        end);
    end;
end);