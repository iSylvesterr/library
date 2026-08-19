-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};

local function resolvePlatform(p4) -- Line: 52
    if p4:IsA("BasePart") then
        return p4;
    end;

    if p4:IsA("Model") then
        return p4.PrimaryPart or p4:FindFirstChildWhichIsA("BasePart", true);
    end;

    return nil;
end;

local function currentAngle(p5) -- Line: 64
    local v6 = tonumber(p5:GetAttribute("RotationsPerSecond")) or 0.125;

    if p5:GetAttribute("Reverse") == true then
        v6 = -v6;
    end;

    local v7 = tonumber(p5:GetAttribute("RotationStartTime")) or 0;

    return v6 * 6.283185307179586 * (workspace:GetServerTimeNow() - v7);
end;

local function activate(p8) -- Line: 74
    -- upvalues: u2 (copy), currentAngle (copy)
    if u2[p8] then
        return;
    end;

    local v9;

    if p8:IsA("BasePart") then
        v9 = p8;
    elseif p8:IsA("Model") then
        v9 = p8.PrimaryPart or p8:FindFirstChildWhichIsA("BasePart", true);
    else
        v9 = nil;
    end;

    if not v9 then
        return;
    end;

    local v10 = p8:IsA("Model");
    local v11;

    if v10 then
        v11 = p8:GetPivot();
    else
        v11 = v9.CFrame;
    end;

    local v12 = RaycastParams.new();
    v12.FilterType = Enum.RaycastFilterType.Include;
    v12.FilterDescendantsInstances = { p8 };
    v12.IgnoreWater = true;
    u2[p8] = {
        Object = p8,
        IsModel = v10,
        Platform = v9,
        BaseCFrame = v11,
        PivotPos = v11.Position,
        StandParams = v12,
        LastAngle = currentAngle(p8)
    };
end;

local function addObject(u13) -- Line: 102
    -- upvalues: u2 (copy), u3 (copy), activate (copy)
    if u2[u13] or u3[u13] then
        return;
    end;

    local v14;

    if u13:IsA("BasePart") then
        v14 = u13;
    elseif u13:IsA("Model") then
        v14 = u13.PrimaryPart or u13:FindFirstChildWhichIsA("BasePart", true);
    else
        v14 = nil;
    end;

    if not v14 then
        return;
    end;

    if u13:GetAttribute("RotationStartTime") == nil then
        u3[u13] = u13:GetAttributeChangedSignal("RotationStartTime"):Connect(function() -- Line: 116
            -- upvalues: u13 (copy), u3 (ref), activate (ref)
            if u13:GetAttribute("RotationStartTime") == nil then
                return;
            end;

            local v15 = u3[u13];

            if v15 then
                v15:Disconnect();
                u3[u13] = nil;
            end;

            activate(u13);
        end);

        return;
    end;

    activate(u13);
end;

local function removeObject(p16) -- Line: 129
    -- upvalues: u2 (copy), u3 (copy)
    u2[p16] = nil;
    local v17 = u3[p16];

    if v17 then
        v17:Disconnect();
        u3[p16] = nil;
    end;
end;

local function isStandingOn(p18, p19) -- Line: 138
    return workspace:Raycast(p19.Position, Vector3.new(0, -6, 0), p18.StandParams) ~= nil;
end;

local function step() -- Line: 143
    -- upvalues: LocalPlayer (copy), u2 (copy), currentAngle (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (Character and Character:IsA("BasePart")) then
        Character = nil;
    end;

    for i, v in u2 do
        if i.Parent then
            local v20 = currentAngle(i);
            local PivotPos = v.PivotPos;
            local v21 = CFrame.new(PivotPos) * CFrame.Angles(0, v20, 0) * CFrame.new(-PivotPos);

            if v.IsModel then
                i:PivotTo(v21 * v.BaseCFrame);
            else
                v.Platform.CFrame = v21 * v.BaseCFrame;
            end;

            if Character and workspace:Raycast(Character.Position, Vector3.new(0, -6, 0), v.StandParams) ~= nil then
                local v22 = v20 - v.LastAngle;
                local v23 = CFrame.new(PivotPos) * CFrame.Angles(0, v22, 0) * CFrame.new(-PivotPos);
                Character.CFrame = v23 * Character.CFrame;
                Character.AssemblyLinearVelocity = v23:VectorToWorldSpace(Character.AssemblyLinearVelocity);
            end;

            v.LastAngle = v20;
        else
            u2[i] = nil;
        end;
    end;
end;

function v1.Init(p24) -- Line: 177
end;

function v1.Start(p25) -- Line: 179
    -- upvalues: CollectionService (copy), addObject (copy), removeObject (copy), RunService (copy), step (copy)
    for _, v in CollectionService:GetTagged("JandelsBeanstalkRotating") do
        addObject(v);
    end;

    CollectionService:GetInstanceAddedSignal("JandelsBeanstalkRotating"):Connect(addObject);
    CollectionService:GetInstanceRemovedSignal("JandelsBeanstalkRotating"):Connect(removeObject);
    RunService.RenderStepped:Connect(step);
end;

return v1;