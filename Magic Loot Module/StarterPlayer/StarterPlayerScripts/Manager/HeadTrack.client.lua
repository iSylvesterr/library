-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CollectionService = UtilsSystem.CollectionService;
local RunService = UtilsSystem.RunService;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Spring2 = require(game.ReplicatedStorage.ClientSideCode.Tool.TopbarPlus.Icon.Packages.Spring2);
local u1 = {};

local function _getTorso(p2) -- Line: 60
    local v3 = p2:FindFirstChild("UpperTorso") or p2:FindFirstChild("Torso");

    if v3 and v3:IsA("BasePart") then
        return v3;
    end;

    return nil;
end;

local function _waitForTorso(p4, p5) -- Line: 75
    local v6 = 0;

    while v6 < p5 do
        local v7 = p4:FindFirstChild("UpperTorso") or p4:FindFirstChild("Torso");

        if not (v7 and v7:IsA("BasePart")) then
            v7 = nil;
        end;

        if v7 then
            return v7;
        end;

        if not p4.Parent then
            return nil;
        end;

        task.wait(0.1);
        v6 = v6 + 0.1;
    end;

    return nil;
end;

local function _isWithinRadius(p8) -- Line: 97
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
        return false;
    end;

    local HumanoidRootPart = p8:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return false;
    end;

    local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart2 and HumanoidRootPart2:IsA("BasePart") then
        return (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= 15;
    end;

    return false;
end;

local function _isWithinNPCFOV(p9) -- Line: 120
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return false;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return false;
    end;

    local v10 = p9:FindFirstChild("UpperTorso") or p9:FindFirstChild("Torso");

    if not (v10 and v10:IsA("BasePart")) then
        v10 = nil;
    end;

    if not v10 then
        return false;
    end;

    local v11 = HumanoidRootPart.Position - v10.CFrame.Position;
    local v12 = Vector3.new(v11.X, 0, v11.Z);

    return v12.Magnitude == 0 and true or Vector3.new(v10.CFrame.LookVector.X, 0, v10.CFrame.LookVector.Z).Unit:Dot(v12.Unit) >= 0.55;
end;

local function _cleanupNPC(p13) -- Line: 147
    -- upvalues: u1 (copy), Spring2 (copy)
    local v14 = u1[p13];

    if v14 then
        Spring2.stop(v14.neck);
    end;

    u1[p13] = nil;
end;

local function _updateHeadTrack(p15, p16) -- Line: 194
    -- upvalues: LocalPlayer (copy), _isWithinRadius (copy), _isWithinNPCFOV (copy), Spring2 (copy)
    local Character = LocalPlayer.Character;

    if not (Character and (Character:FindFirstChild("Head") and Character:FindFirstChild("HumanoidRootPart"))) then
        return;
    end;

    local HumanoidRootPart = p15:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart2 and HumanoidRootPart2:IsA("BasePart")) then
        return;
    end;

    if not _isWithinRadius(p15) or (not _isWithinNPCFOV(p15) or p15:GetAttribute("DisableHeadTrack")) then
        Spring2.target(p16.neck, 0.9, 2, {
            C0 = p16.defaultC0
        });

        return;
    end;

    local Position = HumanoidRootPart2.Position;
    local v17 = Position - HumanoidRootPart.Position;
    local Magnitude = v17.Magnitude;

    if Magnitude < 0.001 then
        return;
    end;

    local Unit = v17.Unit;
    local v18 = Vector2.new(Unit.X, Unit.Z);
    local v19 = Vector2.new(HumanoidRootPart.CFrame.LookVector.X, HumanoidRootPart.CFrame.LookVector.Z);
    local v20 = v18:Cross(v19);
    local v21 = v18:Dot(v19);
    local v22 = math.atan2(v20, v21);
    local v23 = math.atan((Position.Y - HumanoidRootPart.Position.Y) / Magnitude);
    local v24 = CFrame.new(p16.neck.C0.Position) * CFrame.Angles(v23, v22, 0) * CFrame.Angles(-1.5707963267948966, 0, -3.141592653589793);
    Spring2.target(p16.neck, 0.9, 2, {
        C0 = v24
    });
end;

local function _onInstanceAdded(u25) -- Line: 160
    -- upvalues: u1 (copy), _waitForTorso (copy)
    if not u25:IsA("Model") then
        return;
    end;

    if u1[u25] then
        return;
    end;

    task.spawn(function() -- Line: 168
        -- upvalues: u25 (copy), _waitForTorso (ref), u1 (ref)
        if not u25.Parent then
            return;
        end;

        if u25:GetAttribute("DisableHeadTrack") then
            return;
        end;

        local v26 = _waitForTorso(u25, 10);
        local v27;

        if v26 then
            v27 = v26:WaitForChild("Neck", 10);
        else
            v27 = v26;
        end;

        if v26 and (v27 and not u1[u25]) then
            u1[u25] = {
                torso = v26,
                neck = v27,
                defaultC0 = v27.C0
            };
        end;
    end);
end;

local function _onInstanceRemoved(p28) -- Line: 240
    -- upvalues: u1 (copy), Spring2 (copy)
    if not p28:IsA("Model") then
        return;
    end;

    local v29 = u1[p28];

    if v29 then
        Spring2.stop(v29.neck);
    end;

    u1[p28] = nil;
end;

local function _onHeartbeat(p30) -- Line: 252
    -- upvalues: u1 (copy), Spring2 (copy), _updateHeadTrack (copy)
    for i, v in u1 do
        if i.Parent then
            _updateHeadTrack(i, v);
        else
            local v31 = u1[i];

            if v31 then
                Spring2.stop(v31.neck);
            end;

            u1[i] = nil;
        end;
    end;
end;

for _, v in CollectionService:GetTagged("HeadTrack") do
    task.defer(_onInstanceAdded, v);
end;

CollectionService:GetInstanceAddedSignal("HeadTrack"):Connect(_onInstanceAdded);
CollectionService:GetInstanceRemovedSignal("HeadTrack"):Connect(_onInstanceRemoved);
RunService.Heartbeat:Connect(_onHeartbeat);