-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
require(script:WaitForChild("Types"));
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);

local function CreateTween(p1, p2) -- Line: 20
    -- upvalues: TweenService (copy)
    if not (p2 and (p2.Parent and p2:IsDescendantOf(workspace))) then
        return;
    end;

    local PointA = p2:WaitForChild("PointA", 5);
    local PointB = p2:WaitForChild("PointB", 5);

    if not (PointA and PointB) then
        warn((`[VertigoCar] Model "{p2.Name}" is missing PointA or PointB attachments`));

        return;
    end;

    if not (p2 and (p2.Parent and p2:IsDescendantOf(workspace))) then
        return;
    end;

    local WorldPosition = PointA.WorldPosition;
    local WorldPosition2 = PointB.WorldPosition;
    local Magnitude = (WorldPosition2 - WorldPosition).Magnitude;

    if Magnitude <= 0 then
        return;
    end;

    local v3 = TweenService:Create(p2, TweenInfo.new(Magnitude / 42, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Position = WorldPosition2
    });
    p1:Add(v3, "Cancel");

    while p2 and (p2.Parent and p2:IsDescendantOf(workspace)) do
        p2.Position = WorldPosition;

        if not (p2 and (p2.Parent and p2:IsDescendantOf(workspace))) then
            break;
        end;

        v3:Play();
        v3.Completed:Wait();

        if not (p2 and (p2.Parent and p2:IsDescendantOf(workspace))) then
            break;
        end;
    end;
end;

return Observers.observeTag("VertigoCar", function(u4) -- Line: 99
    -- upvalues: Janitor (copy), CreateTween (copy)
    u4.Anchored = true;

    if not u4:IsDescendantOf(workspace) then
        return function() -- Line: 116
        end;
    end;

    local u5 = Janitor.new();
    u5:Add(u4);
    u5:Add(task.spawn(function() -- Line: 107
        -- upvalues: CreateTween (ref), u5 (copy), u4 (copy)
        CreateTween(u5, u4);
    end));

    return function() -- Line: 112
        -- upvalues: u5 (copy)
        u5:Destroy();
    end;
end);