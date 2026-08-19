-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");

local function GetParts(p1) -- Line: 5
    local v2 = {};

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v2, descendant);
        end;
    end;

    return v2;
end;

local function WeldToPart(p3, p4) -- Line: 15
    for _, v in p3 do
        if v ~= p4 then
            v:BreakJoints();
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = p4;
            WeldConstraint.Part1 = v;
            WeldConstraint.Parent = p4;
        end;

        v.Anchored = false;
    end;

    p4.Anchored = false;
end;

local function WeldInstance(p5) -- Line: 30
    -- upvalues: GetParts (copy), WeldToPart (copy)
    local v6 = GetParts(p5);

    if #v6 == 0 then
        return;
    end;

    if p5:IsA("Model") and p5.PrimaryPart then
        p5 = p5.PrimaryPart;
    elseif not p5:IsA("BasePart") then
        p5 = v6[1];
    end;

    if not p5 then
        return;
    end;

    WeldToPart(v6, p5);
end;

for _, v in CollectionService:GetTagged("AutoWeld") do
    task.spawn(WeldInstance, v);
end;

CollectionService:GetInstanceAddedSignal("AutoWeld"):Connect(WeldInstance);