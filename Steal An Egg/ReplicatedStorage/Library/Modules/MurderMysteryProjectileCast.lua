-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local v1 = {};

local function buildDirection(p2) -- Line: 41
    local Magnitude = p2.Magnitude;

    if Magnitude <= 0.00001 then
        return nil;
    end;

    return p2 / Magnitude;
end;

local function createNextCFrame(p3, p4, p5) -- Line: 50
    local v6 = p3.Position + p5;

    return CFrame.lookAt(v6, v6 + p4);
end;

local function computeDistanceAlongDirection(p7, p8, p9, p10) -- Line: 55
    local v11 = (p9 - p7):Dot(p8);

    return math.clamp(v11, 0, p10);
end;

local function resolveCastHit(p12, p13, p14, p15, p16, p17, p18) -- Line: 64
    for _ = 1, 16 do
        local v19 = workspace:Blockcast(p12, p13, p14, p15);

        if not v19 then
            return nil;
        end;

        local Instance = v19.Instance;

        if not (Instance and Instance:IsA("BasePart")) then
            return v19;
        end;

        if p17 and p17(Instance, v19) then
            table.insert(p16, Instance);
            p15.FilterDescendantsInstances = p16;
        else
            if not p18 or p18(Instance, v19) then
                return v19;
            end;

            table.insert(p16, Instance);
            p15.FilterDescendantsInstances = p16;
        end;
    end;

    return nil;
end;

function v1.Cast(p20) -- Line: 103
    -- upvalues: RunService (copy), resolveCastHit (copy)
    local Direction = p20.Direction;
    local Magnitude = Direction.Magnitude;
    local v21;

    if Magnitude <= 0.00001 then
        v21 = nil;
    else
        v21 = Direction / Magnitude;
    end;

    if not v21 then
        return {
            DidImpact = false,
            ImpactResult = nil,
            ImpactType = nil,
            TraveledDistance = 0,
            EndCFrame = p20.StartCFrame
        };
    end;

    if p20.Speed <= 0 or p20.MaxDistance <= 0 then
        return {
            DidImpact = false,
            ImpactResult = nil,
            ImpactType = nil,
            TraveledDistance = 0,
            EndCFrame = p20.StartCFrame
        };
    end;

    local v22 = table.clone(p20.CastParams.FilterDescendantsInstances);
    local v23 = table.clone(v22);
    local v24 = table.clone(v22);
    local v25 = RaycastParams.new();
    v25.FilterType = p20.CastParams.FilterType;
    v25.IgnoreWater = p20.CastParams.IgnoreWater;
    v25.CollisionGroup = p20.CastParams.CollisionGroup;
    v25.FilterDescendantsInstances = v23;
    local v26 = RaycastParams.new();
    v26.FilterType = p20.CastParams.FilterType;
    v26.IgnoreWater = p20.CastParams.IgnoreWater;
    v26.CollisionGroup = p20.CastParams.CollisionGroup;
    v26.FilterDescendantsInstances = v24;
    local ShouldIgnoreHit = p20.ShouldIgnoreHit;
    local ShouldStop = p20.ShouldStop;
    local IsTargetHit = p20.IsTargetHit;
    local OnStep = p20.OnStep;
    local v27 = p20.StopHitboxSize or Vector3.new(0.15, 0.15, 0.15);
    local v28 = p20.TargetHitboxSize or p20.HitboxSize;
    local StartCFrame = p20.StartCFrame;
    local v29 = os.clock();
    local v30 = 0;

    while v30 < p20.MaxDistance and not (ShouldStop and ShouldStop()) do
        local v31 = os.clock();
        local v32 = math.max(v31 - v29, 0.004166666666666667);
        local v33 = math.min(p20.Speed * v32, p20.MaxDistance - v30);

        if v33 <= 0 then
            RunService.Heartbeat:Wait();
        else
            local v34 = v21 * v33;
            local v35 = resolveCastHit(StartCFrame, v27, v34, v25, v23, ShouldIgnoreHit, nil);
            local v36 = resolveCastHit(StartCFrame, v28, v34, v26, v24, ShouldIgnoreHit, IsTargetHit);

            if v35 or v36 then
                local v37;

                if v35 then
                    local v38 = (v35.Position - StartCFrame.Position):Dot(v21);
                    v37 = math.clamp(v38, 0, v33);
                else
                    v37 = (1 / 0);
                end;

                local v39;

                if v36 then
                    local v40 = (v36.Position - StartCFrame.Position):Dot(v21);
                    v39 = math.clamp(v40, 0, v33);
                else
                    v39 = (1 / 0);
                end;

                if v39 <= v37 then
                    v35 = v36;
                end;

                return {
                    DidImpact = true,
                    ImpactResult = v35,
                    ImpactType = v39 <= v37 and "Target" or "Stop",
                    EndCFrame = StartCFrame,
                    TraveledDistance = v30 + math.min(v37, v39)
                };
            end;

            local v41 = StartCFrame.Position + v34;
            local v42 = CFrame.lookAt(v41, v41 + v21);

            if OnStep then
                OnStep(StartCFrame, v42, v34, v30 + v33);
            end;

            v30 = v30 + v33;
            RunService.Heartbeat:Wait();
            StartCFrame = v42;
        end;

        v29 = v31;
    end;

    return {
        DidImpact = false,
        ImpactResult = nil,
        ImpactType = nil,
        EndCFrame = StartCFrame,
        TraveledDistance = v30
    };
end;

function v1.GetDefaultStopHitboxSize() -- Line: 236
    return Vector3.new(0.15, 0.15, 0.15);
end;

function v1.IsPlayerCharacterHit(p43) -- Line: 240
    -- upvalues: Players (copy)
    local Parent = p43.Parent;

    if not Parent then
        return false;
    end;

    local v44 = Parent:FindFirstChildOfClass("Humanoid");

    if v44 and v44.Parent then
        return Players:GetPlayerFromCharacter(v44.Parent) ~= nil;
    end;

    local Parent2 = Parent.Parent;

    if not Parent2 then
        return false;
    end;

    local v45 = Parent2:FindFirstChildOfClass("Humanoid");

    if v45 and v45.Parent then
        return Players:GetPlayerFromCharacter(v45.Parent) ~= nil;
    end;

    return false;
end;

return v1;