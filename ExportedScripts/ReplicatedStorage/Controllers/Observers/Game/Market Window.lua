-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
require(script:WaitForChild("Types"));
local Debris2 = workspace:WaitForChild("Debris");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Sound = require(ReplicatedStorage.Classes.Sound);

local function createDuplicateWindow(p1) -- Line: 20
    -- upvalues: Debris2 (copy)
    local v2 = p1:GetPivot();
    p1:SetAttribute("Broken", false);
    p1:RemoveTag("Market Window");
    p1:RemoveTag("Interactable");
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
    local v5 = p4:GetAttribute("Direction");

    for _, child in ipairs(p4:GetChildren()) do
        if child:IsA("BasePart") then
            child.CollisionGroup = "Debris";
            child.Anchored = false;
            local v6 = v5.X * math.random(7, 12);
            local v7 = v5.Y * math.random(7, 12);
            local v8 = v5.Z * math.random(7, 12);
            child:ApplyImpulse((Vector3.new(v6, v7, v8)));
        end;
    end;

    Debris:AddItem(p4, 5);
    Sound.new("Bullet"):playOneTime({
        Name = "Break Market Window",
        Parent = p4.PrimaryPart
    });
end;

return Observers.observeTag("Market Window", function(u9) -- Line: 71
    -- upvalues: Observers (copy), createDuplicateWindow (copy), createBreakPoints (copy)
    if u9:IsDescendantOf(workspace) then
        return Observers.observeAttribute(u9, "Broken", function(p10) -- Line: 77
            -- upvalues: createDuplicateWindow (ref), u9 (copy), createBreakPoints (ref)
            if p10 then
                createBreakPoints((createDuplicateWindow(u9)));
            end;
        end);
    end;
end);