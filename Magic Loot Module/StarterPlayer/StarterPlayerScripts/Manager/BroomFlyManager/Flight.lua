-- Decompiled with Potassium's decompiler.

local u1 = {};
local LocalPlayer = game.Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local GetData = UtilsSystem.GetData;
local CameraModule = UtilsSystem.CameraModule;
local u2 = CameraModule.CreateFlightRollTilt({
    enabled = false
});
local u3 = CameraModule.CreateFlightCameraAlign();
local u4 = CameraModule.CreateFlightSpeedFov();
local AnimationModule = UtilsSystem.AnimationModule;
local InsMgr = UtilsSystem.InsMgr;
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local GroundSkimVfx = require(script.GroundSkimVfx);
local FlightSounds = require(script.FlightSounds);
u1.GlideToggled = false;
local u5 = 50;
local u6 = 100;
local u7 = 0;
local u8 = 1;
local u9 = os.clock();
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = Vector3.new(0, 0, 0);
local u22 = nil;
local u23 = false;
local u24 = nil;
local u25 = nil;
local u26 = 0;
local u27 = 0;
local u28 = os.clock();
local u29 = os.clock();
local u30 = 0;
local u31 = false;
local u32 = false;
local u33 = false;
local u34 = false;

local function cameraBasisWithoutRoll(p35) -- Line: 97
    local LookVector = p35.LookVector;

    if LookVector:Dot(LookVector) < 1e-8 then
        return p35;
    end;

    return CFrame.lookAt(p35.Position, p35.Position + LookVector, Vector3.new(0, 1, 0));
end;

local function cameraRelativePlanarDir(p36, p37) -- Line: 111
    -- upvalues: CurrentCamera (copy)
    if math.abs(p36) <= 0.2 and math.abs(p37) <= 0.2 then
        return nil;
    end;

    local CFrame2 = CurrentCamera.CFrame;
    local LookVector = CFrame2.LookVector;

    if LookVector:Dot(LookVector) >= 1e-8 then
        CFrame2 = CFrame.lookAt(CFrame2.Position, CFrame2.Position + LookVector, Vector3.new(0, 1, 0));
    end;

    local v38 = Vector3.new(CFrame2.LookVector.X, 0, CFrame2.LookVector.Z);
    local v39 = Vector3.new(CFrame2.RightVector.X, 0, CFrame2.RightVector.Z);
    local v40 = (v38.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v38.Unit) * p36 + (v39.Magnitude < 0.0001 and Vector3.new(1, 0, 0) or v39.Unit) * p37;

    if v40.Magnitude <= 0.2 then
        return nil;
    end;

    return v40.Unit;
end;

local function getDirectionBasedOnHum(p41) -- Line: 139
    -- upvalues: CurrentCamera (copy), u26 (ref), u27 (ref)
    local CFrame2 = CurrentCamera.CFrame;
    local LookVector = CFrame2.LookVector;

    if LookVector:Dot(LookVector) >= 1e-8 then
        CFrame2 = CFrame.lookAt(CFrame2.Position, CFrame2.Position + LookVector, Vector3.new(0, 1, 0));
    end;

    local Position = CFrame2.Position;
    local LookVector2 = CFrame.new(Position, Position + Vector3.new(CFrame2.LookVector.X, 0, CFrame2.LookVector.Z)).LookVector;
    local LookVector3 = CFrame.new(Position, Position + Vector3.new(CFrame2.RightVector.X, 0, CFrame2.RightVector.Z)).LookVector;
    u26 = p41:Dot(LookVector2);
    u27 = p41:Dot(LookVector3);
end;

local function updateStickMoveDirection(p42) -- Line: 158
    -- upvalues: u21 (ref), cameraRelativePlanarDir (copy)
    local X = p42.X;
    local Y = p42.Y;

    if math.abs(X) <= 0.2 and math.abs(Y) <= 0.2 then
        u21 = Vector3.new(0, 0, 0);

        return;
    end;

    u21 = cameraRelativePlanarDir(Y, X) or Vector3.new(0, 0, 0);
end;

local function resolvePlanarMoveDir() -- Line: 172
    -- upvalues: u22 (ref), u23 (ref), u26 (ref), u27 (ref), u21 (ref), u31 (ref), u33 (ref), u34 (ref), u32 (ref), cameraRelativePlanarDir (copy), u12 (ref), getDirectionBasedOnHum (copy)
    u22 = nil;
    u23 = false;
    u26 = 0;
    u27 = 0;

    if u21.Magnitude > 0.2 then
        u22 = u21.Unit;
    else
        local v43 = cameraRelativePlanarDir((u31 and 1 or 0) + (u33 and -1 or 0), (u34 and 1 or 0) + (u32 and -1 or 0));

        if v43 then
            u22 = v43;
        else
            local v44 = not u12 and Vector3.new(0, 0, 0) or u12.MoveDirection;
            local v45 = Vector3.new(v44.X, 0, v44.Z);

            if v45.Magnitude > 0.2 then
                u22 = v45.Unit;
            end;
        end;
    end;

    if u22 then
        u23 = true;
        getDirectionBasedOnHum(u22);
    end;
end;

local function onInputChanged(p46, p47) -- Line: 201
    -- upvalues: u1 (copy), u21 (ref), cameraRelativePlanarDir (copy)
    if not u1.GlideToggled or p46.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return;
    end;

    local Position = p46.Position;
    local X = Position.X;
    local Y = Position.Y;

    if math.abs(X) <= 0.2 and math.abs(Y) <= 0.2 then
        u21 = Vector3.new(0, 0, 0);

        return;
    end;

    u21 = cameraRelativePlanarDir(Y, X) or Vector3.new(0, 0, 0);
end;

local u48 = nil;
local u49 = false;

local function syncFlightSpeedFovThresholds() -- Line: 212
    -- upvalues: u4 (copy), u6 (ref)
    u4:SyncThresholdsFromMaxSpeed(u6);
end;

local function syncFlightCameraAlignTurn() -- Line: 219
    -- upvalues: u3 (copy)
    u3:SetConfig({
        turnSpeedDeg = 540,
        strafeYawMax = 0,
        responsiveness = 200,
        maxTorque = 500000,
        maxBodyRollRadians = 0.3839724354387525,
        bodyOrientationOffset = CFrame.new()
    });
end;

local function applyFlightParamsFromNowBroom() -- Line: 235
    -- upvalues: u48 (ref), CfgFind (copy), EnumMgr (copy), u5 (ref), u6 (ref), u4 (copy), u3 (copy)
    if not u48 then
        return;
    end;

    local v50 = CfgFind.FindCfgByID(u48.Value, EnumMgr.ItemType.Broom);

    if not v50 then
        return;
    end;

    u5 = v50.addSpeed;
    u6 = v50.maxSpeed;
    u4:SyncThresholdsFromMaxSpeed(u6);
    u3:SetConfig({
        turnSpeedDeg = 540,
        strafeYawMax = 0,
        responsiveness = 200,
        maxTorque = 500000,
        maxBodyRollRadians = 0.3839724354387525,
        bodyOrientationOffset = CFrame.new()
    });
end;

local function ensureNowBroom(p51) -- Line: 254
    -- upvalues: u48 (ref), u49 (ref), LocalPlayer (copy), AddListen (copy), applyFlightParamsFromNowBroom (copy), CfgFind (copy), EnumMgr (copy), u5 (ref), u6 (ref), u4 (copy), u3 (copy)
    if u48 and u48.Parent then
        return u48;
    end;

    if u48 and not u48.Parent then
        u48 = nil;
        u49 = false;
    end;

    local NowBroom = LocalPlayer:FindFirstChild("NowBroom");

    if not NowBroom and (p51 and p51 > 0) then
        NowBroom = LocalPlayer:WaitForChild("NowBroom", p51);
    end;

    if not (NowBroom and NowBroom:IsA("NumberValue")) then
        u48 = nil;

        return nil;
    end;

    u48 = NowBroom;

    if u49 then
        local v52 = u48 and CfgFind.FindCfgByID(u48.Value, EnumMgr.ItemType.Broom);

        if v52 then
            u5 = v52.addSpeed;
            u6 = v52.maxSpeed;
            u4:SyncThresholdsFromMaxSpeed(u6);
            u3:SetConfig({
                turnSpeedDeg = 540,
                strafeYawMax = 0,
                responsiveness = 200,
                maxTorque = 500000,
                maxBodyRollRadians = 0.3839724354387525,
                bodyOrientationOffset = CFrame.new()
            });
        end;
    else
        u49 = true;
        AddListen.NumValueAdd(u48, applyFlightParamsFromNowBroom);
    end;

    return u48;
end;

local u53 = {};
local u54 = RaycastParams.new();
u54.FilterDescendantsInstances = { workspace.Characters, workspace:FindFirstChild("Monster") };
u54.CollisionGroup = "Player";
local u55 = RaycastParams.new();
u55.FilterType = Enum.RaycastFilterType.Include;
u55.IgnoreWater = false;

local function refreshSurfaceRayFilterList() -- Line: 290
    -- upvalues: u55 (copy)
    local v56 = { workspace.Terrain };
    local v57 = workspace:FindFirstChild("场景");

    if v57 then
        table.insert(v56, v57);
    end;

    u55.FilterDescendantsInstances = v56;
end;

local v58 = { workspace.Terrain };
local v59 = workspace:FindFirstChild("场景");

if v59 then
    table.insert(v58, v59);
end;

u55.FilterDescendantsInstances = v58;

local function isLowGraphicsQuality() -- Line: 301
    -- upvalues: GetData (copy), LocalPlayer (copy)
    return GetData.GetSetting(LocalPlayer, "GraphicsQuality") == 0;
end;

local function RaycastSurfaceBelow(p60, p61) -- Line: 308
    -- upvalues: u55 (copy)
    return workspace:Raycast(p60, Vector3.new(0, -p61, 0), u55);
end;

local function ProbeGroundBelow(p62) -- Line: 315
    -- upvalues: u11 (ref), u55 (copy), LocalPlayer (copy), u54 (copy), GroundSkimVfx (copy)
    local Position = u11.Position;
    local v63 = workspace:Raycast(Position, Vector3.new(0, -(p62 or 3), 0), u55);
    local v64 = false;

    if LocalPlayer.Character:GetAttribute("JetFlightMode") == 2 then
        local AssemblyLinearVelocity = u11.AssemblyLinearVelocity;

        if AssemblyLinearVelocity.Magnitude > 0.01 then
            v64 = workspace:Raycast(Position, AssemblyLinearVelocity.Unit * 2, u54) ~= nil;
        end;
    end;

    local v65 = GroundSkimVfx.BuildProbeFromRaycast(v63, Position, v64);

    if v64 then
        v65.isAnchored = true;
    end;

    return v65;
end;

local function CalculateCharacterMass(p66) -- Line: 341
    local Gravity = workspace.Gravity;
    local v67 = 0;

    for _, child in pairs(p66:GetChildren()) do
        if child:IsA("BasePart") then
            v67 = v67 + child:GetMass() * Gravity;
        end;
    end;

    return v67;
end;

local function flattenLook(p68) -- Line: 357
    local v69 = Vector3.new(p68.X, 0, p68.Z);

    return v69.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v69.Unit;
end;

local function signedYawErrorToTarget(p70, p71) -- Line: 372
    local v72 = Vector3.new(p70.X, 0, p70.Z);
    local v73 = v72.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v72.Unit;
    local v74 = Vector3.new(p71.X, 0, p71.Z);
    local v75 = v74.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v74.Unit;
    local Y = v73:Cross(v75).Y;
    local v76 = v73:Dot(v75);
    local v77 = math.clamp(v76, -1, 1);

    return math.atan2(Y, v77);
end;

local function UpdateFlightPhysics(p78) -- Line: 385
    -- upvalues: u12 (ref), u28 (ref), u6 (ref), GetData (copy), LocalPlayer (copy), ProbeGroundBelow (copy), u5 (ref), u7 (ref), u23 (ref), u10 (ref), u4 (copy), u24 (ref), GroundSkimVfx (copy), u8 (ref), u25 (ref), u11 (ref), CurrentCamera (copy), u26 (ref), u13 (ref), u9 (ref), u53 (ref), u22 (ref), u2 (copy), u3 (copy), u29 (ref)
    local v79 = u12:GetAttribute("InplaceCast");
    local v80 = os.clock() - u28 - 0.3;
    local v81 = v80 <= 0 and 0 or 1 - math.clamp(v80 / 1, 0, 1);
    local v82 = os.clock() - u28 <= 1.5 and u6 / 3 or u6;
    local v83 = GetData.GetSetting(LocalPlayer, "GraphicsQuality") == 0;
    local v84 = ProbeGroundBelow(32);
    local distance = v84.distance;
    local v85 = p78 * u5;
    local v86;

    if v79 then
        v86 = u7 - v85 * 100;
    elseif u23 then
        v86 = u7 + v85;
    else
        v86 = u7 - v85 * 100;
    end;

    u7 = math.clamp(v86, 0, v82);

    if u10 then
        u10:SetAttribute("BroomFlightSpeed", u7);
    end;

    u4:SetSpeed(u7, v82);

    if v83 then
        if u24 then
            u24:Reset();
            u24 = nil;
        end;
    elseif not u24 then
        u24 = GroundSkimVfx.new(u10);
    end;

    if u24 then
        u24:Update(distance, u8, v84, u7);
    end;

    if u25 then
        u25:Update(u7, v82, not u24 and "Off" or u24:GetEffectState());
    end;

    local LookVector = u11.CFrame.LookVector;
    local v87 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local v88 = v87.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v87.Unit;
    local v89 = math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1);
    local v90 = math.asin(v89);
    local v91 = u26 > 0.2;
    local v92;

    if v91 then
        v92 = v90 > 0.2617993877991494;
    else
        v92 = v91;
    end;

    if v91 then
        if v90 < -0.2617993877991494 then
            local v93;

            if distance == nil then
                v93 = false;
            else
                v93 = distance <= u8;
            end;

            v91 = not v93;
        else
            v91 = false;
        end;
    end;

    local v94 = 0;

    if v92 then
        v94 = math.clamp((v90 - 0.2617993877991494) / 0.7853981633974483, 0, 1) * 40;
    elseif v91 then
        v94 = -math.clamp((-v90 - 0.2617993877991494) / 0.7853981633974483, 0, 1) * 40;
    end;

    u13.VectorVelocity = Vector3.new(v88.X * u7, v81 * 5 + v94, v88.Z * u7);

    if GroundSkimVfx.IsGroundSkimming(distance, u8) then
        u9 = os.clock();
    end;

    if not v92 and (not v91 and v80 > 0) then
        local Y = u13.VectorVelocity.Y;

        if distance then
            local v95 = u8 - distance;

            if distance < u8 then
                Y = Y + (1 / (u8 / 10) ^ 2 * v95 ^ 2 - 0.25 * Y);
            elseif u8 < distance then
                local v96 = math.clamp((distance - u8) * 4, 0, 40);
                local v97 = math.min(p78 * 8, 1);
                Y = Y + (-v96 - Y) * v97;
            end;
        else
            local v98 = math.min(p78 * 4, 1);
            Y = Y + (-20 - Y) * v98;
        end;

        local VectorVelocity = u13.VectorVelocity;
        u13.VectorVelocity = Vector3.new(VectorVelocity.X, Y, VectorVelocity.Z);
    end;

    if LocalPlayer:GetAttribute("Iced") then
        u13.VectorVelocity = u13.VectorVelocity * 0.5;
    end;

    if not u23 or v79 then
        v79 = u7 > 0.5;
    end;

    if v79 then
        if u53.DethrottleAnim and not u53.DethrottleAnim.IsPlaying then
            u53.DethrottleAnim:Play(0.5);
        end;
    elseif u53.DethrottleAnim and u53.DethrottleAnim.IsPlaying then
        u53.DethrottleAnim:Stop(0.5);
    end;

    local v99;

    if u22 then
        local LookVector2 = u11.CFrame.LookVector;
        local v100 = u22;
        local v101 = Vector3.new(LookVector2.X, 0, LookVector2.Z);
        local v102 = v101.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v101.Unit;
        local v103 = Vector3.new(v100.X, 0, v100.Z);
        local v104 = v103.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v103.Unit;
        local Y = v102:Cross(v104).Y;
        local v105 = v102:Dot(v104);
        local v106 = math.clamp(v105, -1, 1);
        local v107 = math.atan2(Y, v106) / 0.17453292519943295;
        v99 = math.clamp(v107, -1, 1) * 0.3839724354387525;
    else
        v99 = 0;
    end;

    u2:StepRoll(p78, v99);
    local v108 = u2:GetRollAngle();
    local v109;

    if u22 then
        v109 = u22;
    else
        local LookVector2 = u11.CFrame.LookVector;
        local v110 = Vector3.new(LookVector2.X, 0, LookVector2.Z);
        v109 = v110.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v110.Unit;
    end;

    u3:UpdateTowardDirection(p78, v109, v108);

    if u53.SteerRight then
        u53.SteerRight:AdjustWeight(-math.clamp(v108 / 0.08, -1, 0));
    end;

    if u53.SteerLeft then
        u53.SteerLeft:AdjustWeight((math.clamp(v108 / 0.08, 0, 1)));
    end;

    u29 = os.clock() + 0.3;
end;

local function forceExitFlight() -- Line: 547
    -- upvalues: u10 (ref), NetWork (copy), NetMsg (copy)
    if not u10 then
        return;
    end;

    u10:SetAttribute("JetPacking", nil);
    u10:SetAttribute("BroomFlightSpeed", nil);
    NetWork.InvokeServer(NetMsg.DISMOUNT_BROOM);
end;

local function FlightUpdateLoop(p111) -- Line: 560
    -- upvalues: u10 (ref), u12 (ref), NetWork (copy), NetMsg (copy), resolvePlanarMoveDir (copy), UpdateFlightPhysics (copy)
    if u10 and u10:GetAttribute("StageJumpAnimating") then
        return;
    end;

    local v112 = true;

    if u12.Sit or (not u10:GetAttribute("JetPacking") or u12:GetState() == Enum.HumanoidStateType.Swimming) then
        v112 = false;
    elseif u12.Health <= 0 then
        v112 = false;
    end;

    if v112 then
        resolvePlanarMoveDir();
        UpdateFlightPhysics(p111);

        return;
    end;

    if not u10 then
        return;
    end;

    u10:SetAttribute("JetPacking", nil);
    u10:SetAttribute("BroomFlightSpeed", nil);
    NetWork.InvokeServer(NetMsg.DISMOUNT_BROOM);
end;

function InputFunction(p113)
    -- upvalues: UserInputService (copy), u31 (ref), u32 (ref), u33 (ref), u34 (ref)
    if UserInputService:GetFocusedTextBox() ~= nil then
        return;
    end;

    if p113.KeyCode == Enum.KeyCode.W then
        u31 = true;

        return;
    end;

    if p113.KeyCode == Enum.KeyCode.A then
        u32 = true;

        return;
    end;

    if p113.KeyCode == Enum.KeyCode.S then
        u33 = true;

        return;
    end;

    if p113.KeyCode == Enum.KeyCode.D then
        u34 = true;
    end;
end;

function InputEnded(p114)
    -- upvalues: u31 (ref), u32 (ref), u33 (ref), u34 (ref)
    if p114.KeyCode == Enum.KeyCode.W then
        u31 = false;

        return;
    end;

    if p114.KeyCode == Enum.KeyCode.A then
        u32 = false;

        return;
    end;

    if p114.KeyCode == Enum.KeyCode.S then
        u33 = false;

        return;
    end;

    if p114.KeyCode == Enum.KeyCode.D then
        u34 = false;
    end;
end;

local function activateFlight() -- Line: 622
    -- upvalues: u1 (copy), u10 (ref), LocalPlayer (copy), u11 (ref), u12 (ref), u55 (copy), u9 (ref), u27 (ref), u31 (ref), u32 (ref), u33 (ref), u34 (ref), u22 (ref), u23 (ref), u13 (ref), CalculateCharacterMass (copy), u7 (ref), u3 (copy), CurrentCamera (copy), u28 (ref), u30 (ref), u15 (ref), UserInputService (copy), u16 (ref), u17 (ref), onInputChanged (copy), u21 (ref), u18 (ref), RunService (copy), FlightUpdateLoop (copy), u20 (ref), NetWork (copy), NetMsg (copy), u2 (copy), u4 (copy), u6 (ref), u14 (ref), u53 (ref), ensureNowBroom (copy), u48 (ref), CfgFind (copy), EnumMgr (copy), AnimationModule (copy), InsMgr (copy), u19 (ref), u8 (ref), u24 (ref), u25 (ref), GetData (copy), GroundSkimVfx (copy), FlightSounds (copy)
    if u1.GlideToggled then
        return;
    end;

    u10 = LocalPlayer.Character;

    if not (u10 and u10:GetAttribute("JetPacking")) then
        return;
    end;

    u11 = u10:FindFirstChild("HumanoidRootPart");
    u12 = u10:FindFirstChild("Humanoid");

    if not (u11 and u12) then
        return;
    end;

    local v115 = { workspace.Terrain };
    local v116 = workspace:FindFirstChild("场景");

    if v116 then
        table.insert(v115, v116);
    end;

    u55.FilterDescendantsInstances = v115;
    u9 = os.clock() + 1;
    u27 = 0;
    u31 = false;
    u32 = false;
    u33 = false;
    u34 = false;
    u22 = nil;
    u23 = false;
    u13 = Instance.new("LinearVelocity", u11);
    u13.Attachment0 = u11.RootAttachment;
    u13.MaxForce = CalculateCharacterMass(u10) * 4 * 2;
    u13.VectorVelocity = u11.AssemblyLinearVelocity * 0.5 * Vector3.new(1, 0, 1);
    u7 = 0;
    u3:Attach(u11);
    u3:ApplyTakeoffOrientation(CurrentCamera.CFrame);
    u3:SetConfig({
        turnSpeedDeg = 540,
        strafeYawMax = 0,
        responsiveness = 200,
        maxTorque = 500000,
        maxBodyRollRadians = 0.3839724354387525,
        bodyOrientationOffset = CFrame.new()
    });
    u28 = os.clock();
    u30 = 20 + u11.AssemblyLinearVelocity.Magnitude;
    u15 = UserInputService.InputBegan:Connect(InputFunction);
    u16 = UserInputService.InputEnded:Connect(InputEnded);
    u17 = UserInputService.InputChanged:Connect(onInputChanged);
    u21 = Vector3.new(0, 0, 0);
    u18 = RunService.Heartbeat:Connect(FlightUpdateLoop);

    if u20 then
        u20:Disconnect();
    end;

    u20 = u12.StateChanged:Connect(function(p117, p118) -- Line: 670
        -- upvalues: u10 (ref), NetWork (ref), NetMsg (ref)
        if p118 == Enum.HumanoidStateType.Swimming and u10:GetAttribute("JetPacking") then
            if not u10 then
                return;
            end;

            u10:SetAttribute("JetPacking", nil);
            u10:SetAttribute("BroomFlightSpeed", nil);
            NetWork.InvokeServer(NetMsg.DISMOUNT_BROOM);
        end;
    end);
    u2:SetRollAngle(0);
    u2:Enable();
    u4:SyncThresholdsFromMaxSpeed(u6);
    u4:SetSpeed(u7, u6);
    u4:Enable();
    u12.PlatformStand = true;
    u12.AutoRotate = false;

    if u14 == nil then
        u14 = u12.JumpPower;
    end;

    u12.JumpPower = 0;
    u10:SetAttribute("BroomMountDone", false);
    u53 = {};
    ensureNowBroom(0);
    local v119;

    if u48 then
        v119 = CfgFind.FindCfgByID(u48.Value, EnumMgr.ItemType.Broom);
    else
        v119 = nil;
    end;

    local v120 = v119 and (v119.startAni or "骑扫帚起飞") or "骑扫帚起飞";
    local v121 = v119 and v119.flyAni or "骑扫帚待机";

    local function applyAnimId(p122, p123) -- Line: 696
        -- upvalues: AnimationModule (ref)
        local v124 = AnimationModule.GetAnimID(p123);

        if v124 then
            p122.AnimationId = "rbxassetid://" .. v124;
        end;
    end;

    local v125 = InsMgr.GetIns(v120, "Animation", u12);
    local v126 = AnimationModule.GetAnimID(v120);

    if v126 then
        v125.AnimationId = "rbxassetid://" .. v126;
    end;

    u53.FlightStartAnim = u12:LoadAnimation(v125);
    u53.FlightStartAnim.Priority = Enum.AnimationPriority.Action4;
    u53.FlightStartAnim:Play(0.12);
    u53.FlightStartAnim.Stopped:Connect(function() -- Line: 709
        -- upvalues: u10 (ref)
        if u10 and u10.Parent then
            u10:SetAttribute("BroomMountDone", true);
        end;
    end);
    local v127 = InsMgr.GetIns(v121, "Animation", u12);
    local v128 = AnimationModule.GetAnimID(v121);

    if v128 then
        v127.AnimationId = "rbxassetid://" .. v128;
    end;

    u53.GlideAnim = u12:LoadAnimation(v127);
    u53.GlideAnim.Priority = Enum.AnimationPriority.Action3;
    u53.GlideAnim:Play(0.2);
    local v129 = InsMgr.GetIns("骑扫帚右转", "Animation", u12);
    local v130 = AnimationModule.GetAnimID("骑扫帚右转");

    if v130 then
        v129.AnimationId = "rbxassetid://" .. v130;
    end;

    u53.SteerRight = u12:LoadAnimation(v129);
    u53.SteerRight.Priority = Enum.AnimationPriority.Action4;
    u53.SteerRight:Play(0.2, 0, 1);
    local v131 = InsMgr.GetIns("骑扫帚左转", "Animation", u12);
    local v132 = AnimationModule.GetAnimID("骑扫帚左转");

    if v132 then
        v131.AnimationId = "rbxassetid://" .. v132;
    end;

    u53.SteerLeft = u12:LoadAnimation(v131);
    u53.SteerLeft.Priority = Enum.AnimationPriority.Action4;
    u53.SteerLeft:Play(0.2, 0, 1);
    local v133 = InsMgr.GetIns("骑扫帚减速", "Animation", u12);
    local v134 = AnimationModule.GetAnimID("骑扫帚减速");

    if v134 then
        v133.AnimationId = "rbxassetid://" .. v134;
    end;

    u53.DethrottleAnim = u12:LoadAnimation(v133);
    u53.DethrottleAnim.Priority = Enum.AnimationPriority.Action4;

    if u19 then
        u19:Disconnect();
    end;

    u19 = u10:GetAttributeChangedSignal("FlightHeight"):Connect(function() -- Line: 750
        -- upvalues: u8 (ref), u10 (ref)
        u8 = u10:GetAttribute("FlightHeight") or 1;
    end);
    u8 = u10:GetAttribute("FlightHeight") or 1;

    if u24 then
        u24:Reset();
        u24 = nil;
    end;

    if u25 then
        u25:Stop();
    end;

    if GetData.GetSetting(LocalPlayer, "GraphicsQuality") ~= 0 then
        u24 = GroundSkimVfx.new(u10);
    end;

    u25 = FlightSounds.new();
    u31 = UserInputService:IsKeyDown(Enum.KeyCode.W);
    u32 = UserInputService:IsKeyDown(Enum.KeyCode.A);
    u33 = UserInputService:IsKeyDown(Enum.KeyCode.S);
    u34 = UserInputService:IsKeyDown(Enum.KeyCode.D);
end;

function u1.ToggleFlight(p135, p136) -- Line: 779
    -- upvalues: u10 (ref), LocalPlayer (copy), u11 (ref), u12 (ref), u1 (copy), activateFlight (copy), u14 (ref), u18 (ref), u2 (copy), u4 (copy), u15 (ref), u16 (ref), u17 (ref), u21 (ref), u22 (ref), u23 (ref), u31 (ref), u32 (ref), u33 (ref), u34 (ref), u19 (ref), u20 (ref), u13 (ref), u3 (copy), u24 (ref), u25 (ref), u53 (ref), u29 (ref)
    u10 = LocalPlayer.Character;
    u11 = u10:FindFirstChild("HumanoidRootPart");
    u12 = u10:FindFirstChild("Humanoid");

    if p135 == nil then
        p135 = not u1.GlideToggled;
    end;

    if p135 == u1.GlideToggled then
        return;
    end;

    if p135 and (u12.FloorMaterial ~= Enum.Material.Air and p136 ~= true) then
        return;
    end;

    if not p135 or u12.Health > 0 then
        if p135 then
            if not u10:GetAttribute("JetPacking") then
                return;
            end;

            activateFlight();
        else
            u12.PlatformStand = false;
            u12.AutoRotate = true;

            if u14 ~= nil then
                u12.JumpPower = u14;
                u14 = nil;
            end;

            if u18 then
                u18:Disconnect();
                u18 = nil;
            end;

            u2:Disable();
            u4:Disable();

            if u15 then
                u15:Disconnect();
                u15 = nil;
            end;

            if u16 then
                u16:Disconnect();
                u16 = nil;
            end;

            if u17 then
                u17:Disconnect();
                u17 = nil;
            end;

            u21 = Vector3.new(0, 0, 0);
            u22 = nil;
            u23 = false;
            u31 = false;
            u32 = false;
            u33 = false;
            u34 = false;

            if u19 then
                u19:Disconnect();
                u19 = nil;
            end;

            if u20 then
                u20:Disconnect();
                u20 = nil;
            end;

            if u13 then
                u13:Destroy();
                u13 = nil;
            end;

            u3:Detach();

            if u24 then
                u24:Reset();
                u24 = nil;
            end;

            if u25 then
                u25:Stop();
                u25 = nil;
            end;

            for _, v in pairs(u53) do
                if v and typeof(v) == "Instance" then
                    v:Stop();
                    v:Destroy();
                end;
            end;

            u53 = nil;

            if u10 then
                u10:SetAttribute("BroomMountDone", nil);
                u10:SetAttribute("BroomFlightSpeed", nil);
            end;

            if u11 and u11.Parent then
                local _ = u11.CFrame.LookVector;
            end;

            local _ = os.clock() <= u29;
            u12:ChangeState(Enum.HumanoidStateType.GettingUp);
            LocalPlayer:SetAttribute("ForceMouseLock2", nil);
        end;

        u1.GlideToggled = p135;
        LocalPlayer:SetAttribute("ForceMouseLock2", p135);
        LocalPlayer:SetAttribute("BroomFly", p135);
    end;
end;

function u1.CharacterAdded(u137) -- Line: 885
    -- upvalues: ensureNowBroom (copy), u1 (copy)
    task.spawn(function() -- Line: 886
        -- upvalues: ensureNowBroom (ref)
        ensureNowBroom(30);
    end);
    u137:GetAttributeChangedSignal("JetPacking"):Connect(function() -- Line: 890
        -- upvalues: u1 (ref), u137 (copy)
        u1.ToggleFlight(u137:GetAttribute("JetPacking"), true);
    end);
    u1.ToggleFlight(false);
end;

return u1;