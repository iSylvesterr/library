-- Decompiled with Potassium's decompiler.

local v1 = {};
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local u2 = {};

local function Track(p3) -- Line: 42
    -- upvalues: u2 (copy)
    if u2[p3] or not (p3:IsA("Model") and p3:IsDescendantOf(workspace)) then
        return;
    end;

    local v4 = p3:GetPivot();
    u2[p3] = {
        Instance = p3,
        Position = v4.Position,
        BaseRotation = v4.Rotation
    };
end;

local function Untrack(p5) -- Line: 56
    -- upvalues: u2 (copy)
    u2[p5] = nil;
end;

local function Step() -- Line: 60
    -- upvalues: u2 (copy)
    local v6 = workspace:GetServerTimeNow() % 5 / 5 * 6.283185307179586;

    for i, v in u2 do
        if i.Parent then
            v.Instance:PivotTo(CFrame.new(v.Position) * CFrame.Angles(0, v6, 0) * v.BaseRotation);
        else
            u2[i] = nil;
        end;
    end;
end;

function v1.Init(p7) -- Line: 75
end;

function v1.Start(p8) -- Line: 77
    -- upvalues: CollectionService (copy), Track (copy), Untrack (copy), RunService (copy), Step (copy)
    for _, v in CollectionService:GetTagged("DiscoBall") do
        Track(v);
    end;

    CollectionService:GetInstanceAddedSignal("DiscoBall"):Connect(Track);
    CollectionService:GetInstanceRemovedSignal("DiscoBall"):Connect(Untrack);
    RunService.RenderStepped:Connect(Step);
end;

return v1;