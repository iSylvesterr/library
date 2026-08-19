-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
require(script:WaitForChild("Types"));
local Debris2 = workspace:WaitForChild("Debris");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Sound = require(ReplicatedStorage.Classes.Sound);

local function createDuplicateVent(p1) -- Line: 20
    -- upvalues: Debris2 (copy)
    local v2 = p1:GetPivot();
    p1:SetAttribute("Broken", false);
    p1:RemoveTag("Interactable");
    p1:RemoveTag("Vent");
    local v3 = p1:Clone();
    v3:PivotTo(v2);
    v3.Parent = Debris2;

    for _, child in ipairs(v3:GetChildren()) do
        if child:IsA("BasePart") then
            child.CanCollide = true;
            child.Transparency = 0;
        end;
    end;

    return v3;
end;

local function createBreakPoints(p4) -- Line: 43
    -- upvalues: Debris (copy), Sound (copy)
    local Position = p4:GetPivot().Position;
    local v5 = p4:GetAttribute("Direction");

    for _, child in ipairs(p4:GetChildren()) do
        if child:IsA("BasePart") then
            child.CollisionGroup = "Debris";
            child.Anchored = false;
            local v6 = v5.X * math.random(15, 20);
            local v7 = v5.Y * math.random(15, 20);
            local v8 = v5.Z * math.random(15, 20);
            child:ApplyImpulse((Vector3.new(v6, v7, v8)));
        end;
    end;

    Debris:AddItem(p4, 5);
    Sound.new("Bullet"):PlaySoundAtPosition({
        Name = "Break Metal Vent",
        Class = "Bullet",
        Position = Position
    });
end;

return Observers.observeTag("Vent", function(u9) -- Line: 72
    -- upvalues: Observers (copy), createDuplicateVent (copy), createBreakPoints (copy)
    if u9:IsDescendantOf(workspace) then
        return Observers.observeAttribute(u9, "Broken", function(p10) -- Line: 78
            -- upvalues: createDuplicateVent (ref), u9 (copy), createBreakPoints (ref)
            if p10 then
                createBreakPoints((createDuplicateVent(u9)));
            end;
        end);
    end;
end);