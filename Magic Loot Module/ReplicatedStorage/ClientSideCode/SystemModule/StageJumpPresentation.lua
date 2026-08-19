-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CameraModule = UtilsSystem.CameraModule;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local HumanModule = UtilsSystem.HumanModule;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local SpeedLineFX = UtilsSystem.SpeedLineFX;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local u1 = {};
local u2 = false;
local u3 = false;
local u4 = false;
local u5 = nil;
local u6 = false;
local u7 = false;
local u8 = nil;
local u9 = 0;

local function _resolveSkipFlySpeed() -- Line: 95
    -- upvalues: LocalPlayer (copy), CfgFind (copy), EnumMgr (copy)
    local NowBroom = LocalPlayer:FindFirstChild("NowBroom");
    local v10;

    if NowBroom and NowBroom:IsA("NumberValue") then
        local v11 = tonumber(NowBroom.Value) or 0;
        v10 = math.floor(v11);
    else
        v10 = 0;
    end;

    if v10 > 0 then
        local v12 = CfgFind.FindCfgByID(v10, EnumMgr.ItemType.Broom);

        if v12 then
            v12 = tonumber(v12.skipFlySpeed);
        end;

        if v12 and v12 > 0 then
            return v12;
        end;
    end;

    return 150;
end;

local function _getTeleportStartCFrame() -- Line: 116
    local v13 = workspace:FindFirstChild("场景");

    if not v13 then
        return nil;
    end;

    local v14 = v13:FindFirstChild("传送起点");

    if v14 and v14:IsA("CFrameValue") then
        return v14.Value;
    end;

    return nil;
end;

local function _isOnBroom() -- Line: 133
    -- upvalues: LocalPlayer (copy)
    local v15 = LocalPlayer:FindFirstChild("飞行状态");
    local v16;

    if v15 == nil then
        v16 = false;
    else
        v16 = v15:IsA("BoolValue") and v15.Value == true;
    end;

    return v16;
end;

local function _ensureMounted() -- Line: 143
    -- upvalues: u3 (ref), LocalPlayer (copy), SystemGameConfig (copy), NetWork (copy), NetMsg (copy)
    if u3 then
        return false;
    end;

    local v17 = LocalPlayer:FindFirstChild("飞行状态");
    local v18;

    if v17 == nil then
        v18 = false;
    else
        v18 = v17:IsA("BoolValue") and v17.Value == true;
    end;

    if v18 then
        return true;
    end;

    if SystemGameConfig.GetValue({ "Broom", "启用" }) == false then
        return false;
    end;

    if not pcall(function() -- Line: 156
        -- upvalues: NetWork (ref), NetMsg (ref)
        NetWork.InvokeServer(NetMsg.TOGGLE_BROOM);
    end) then
        return false;
    end;

    local v19 = os.clock() + 1.2;

    while os.clock() < v19 do
        if u3 then
            return false;
        end;

        local v20 = LocalPlayer:FindFirstChild("飞行状态");
        local v21;

        if v20 == nil then
            v21 = false;
        else
            v21 = v20:IsA("BoolValue") and v20.Value == true;
        end;

        if v21 then
            return true;
        end;

        task.wait(0.05);
    end;

    local v22 = not u3;

    if v22 then
        local v23 = LocalPlayer:FindFirstChild("飞行状态");

        if v23 == nil then
            v22 = false;
        else
            v22 = v23:IsA("BoolValue") and v23.Value == true;
        end;
    end;

    return v22;
end;

local function _waitBroomMountDone() -- Line: 181
    -- upvalues: u3 (ref), HumanModule (copy), LocalPlayer (copy)
    if u3 then
        return false;
    end;

    local v24 = HumanModule.GetCharacter(LocalPlayer);

    if not v24 then
        return false;
    end;

    if v24:GetAttribute("BroomMountDone") == true then
        return true;
    end;

    local v25 = os.clock() + 5;

    while os.clock() < v25 do
        if u3 then
            return false;
        end;

        if v24:GetAttribute("BroomMountDone") == true then
            return true;
        end;

        local v26 = LocalPlayer:FindFirstChild("飞行状态");
        local v27;

        if v26 == nil then
            v27 = false;
        else
            v27 = v26:IsA("BoolValue") and v26.Value == true;
        end;

        if not v27 then
            return false;
        end;

        task.wait(0.05);
    end;

    local v28 = not u3 and v24:GetAttribute("BroomMountDone") == true;

    return v28;
end;

local function _stopMoveConn() -- Line: 217
    -- upvalues: u5 (ref)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function _isLocalAlive() -- Line: 229
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character.Parent) then
        return false;
    end;

    local v29 = Character:FindFirstChildOfClass("Humanoid");

    return v29 and v29.Health > 0 and true or false;
end;

local function _requestFlightAbort() -- Line: 246
    -- upvalues: u3 (ref), u5 (ref)
    if u3 then
        return;
    end;

    u3 = true;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function _clearFlightVelocities(p30) -- Line: 260
    p30.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p30.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

    for _, child in p30:GetChildren() do
        if child:IsA("LinearVelocity") then
            child.VectorVelocity = Vector3.new(0, 0, 0);
            child.Enabled = false;
        elseif child:IsA("AlignOrientation") then
            child.Enabled = false;
        end;
    end;
end;

local function _flatLookOf(p31) -- Line: 279
    local LookVector = p31.LookVector;
    local v32 = Vector3.new(LookVector.X, 0, LookVector.Z);

    return v32.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v32.Unit;
end;

local function _cframeFacing(p33, p34) -- Line: 295
    local v35 = Vector3.new(p34.X, 0, p34.Z);

    return CFrame.lookAt(p33, p33 + (v35.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v35.Unit));
end;

local function _lerpFlatLook(p36, p37, p38) -- Line: 313
    local LookVector = CFrame.lookAt(Vector3.new(0, 0, 0), p36):Lerp(CFrame.lookAt(Vector3.new(0, 0, 0), p37), (math.clamp(p38, 0, 1))).LookVector;
    local v39 = Vector3.new(LookVector.X, 0, LookVector.Z);

    return v39.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v39.Unit;
end;

local function _smoothstep(p40) -- Line: 325
    local v41 = math.clamp(p40, 0, 1);

    return v41 * v41 * (3 - v41 * 2);
end;

local function _rampFracs() -- Line: 336
    local v42 = 0.18;
    local v43 = 0.1;

    if v42 + v43 >= 0.95 then
        local v44 = 0.94 / (v42 + v43);
        v42 = v42 * v44;
        v43 = v43 * v44;
    end;

    return v42, v43;
end;

local function _pathProgress(p45) -- Line: 354
    local v46 = math.clamp(p45, 0, 1);
    local v47 = 0.18;
    local v48 = 0.1;

    if v47 + v48 >= 0.95 then
        local v49 = 0.94 / (v47 + v48);
        v47 = v47 * v49;
        v48 = v48 * v49;
    end;

    local v50 = 1 / (1 - v47 / 2 - v48 / 2);

    if v46 <= v47 then
        return v50 * v46 * v46 / (v47 * 2);
    end;

    if 1 - v48 > v46 then
        return v50 * v47 / 2 + v50 * (v46 - v47);
    end;

    local v51 = 1 - v46;

    return 1 - v50 * v51 * v51 / (2 * v48);
end;

local function _speedNormFromT(p52) -- Line: 374
    local v53 = math.clamp(p52, 0, 1);
    local v54 = 0.18;
    local v55 = 0.1;

    if v54 + v55 >= 0.95 then
        local v56 = 0.94 / (v54 + v55);
        v54 = v54 * v56;
        v55 = v55 * v56;
    end;

    if v53 <= v54 then
        return v53 / v54;
    end;

    return 1 - v55 > v53 and 1 or (1 - v53) / v55;
end;

local function _setCruiseSpeedFx(p57) -- Line: 392
    -- upvalues: u9 (ref), u6 (ref), SpeedLineFX (copy)
    u9 = math.clamp(p57, 0, 1);

    if u6 then
        pcall(function() -- Line: 395
            -- upvalues: SpeedLineFX (ref), u9 (ref)
            SpeedLineFX.SetIntensity(u9);
        end);
    end;
end;

local function _hideSpeedLine() -- Line: 406
    -- upvalues: u6 (ref), SpeedLineFX (copy)
    if not u6 then
        pcall(function() -- Line: 409
            -- upvalues: SpeedLineFX (ref)
            SpeedLineFX.Hide(0.2);
        end);

        return;
    end;

    u6 = false;
    pcall(function() -- Line: 415
        -- upvalues: SpeedLineFX (ref)
        SpeedLineFX.Hide(0.2);
    end);
end;

local function _showSpeedLine() -- Line: 425
    -- upvalues: u6 (ref), u9 (ref), SpeedLineFX (copy)
    if u6 then
        return;
    end;

    u6 = true;
    u9 = 0;
    pcall(function() -- Line: 431
        -- upvalues: SpeedLineFX (ref)
        SpeedLineFX.Show(0, 0.12);
    end);
end;

local function _forceDisableJumpFov() -- Line: 441
    -- upvalues: u8 (ref), u7 (ref), CameraModule (copy)
    u8 = nil;
    u7 = false;
    pcall(function() -- Line: 444
        -- upvalues: CameraModule (ref)
        CameraModule.DisableCameraEvent_Helper("跳关飞行影响相机FOV");
    end);
end;

local function _showJumpFov() -- Line: 454
    -- upvalues: u7 (ref), u8 (ref), u9 (ref), CameraModule (copy), TweenService (copy)
    if u7 then
        return;
    end;

    u7 = true;
    local u58 = 0;
    local u59 = false;
    local u60 = 0;
    local u61 = 0;

    u8 = function() -- Line: 465
        -- upvalues: u59 (ref), u60 (ref), u58 (ref), u61 (ref), u9 (ref)
        if u59 then
            return;
        end;

        u59 = true;
        u60 = u58;
        u61 = u9 * 10;
    end;

    if not pcall(function() -- Line: 474
        -- upvalues: CameraModule (ref), u58 (ref), u59 (ref), u9 (ref), u61 (ref), TweenService (ref), u60 (ref), u8 (ref), u7 (ref)
        CameraModule.EnableCameraEvent_Helper("跳关飞行影响相机FOV", function(p62, p63) -- Line: 475
            -- upvalues: u58 (ref), u59 (ref), u9 (ref), u61 (ref), TweenService (ref), u60 (ref), u8 (ref), u7 (ref), CameraModule (ref)
            u58 = u58 + (p63 or 0);
            local v64;

            if u59 then
                local v65 = TweenService:GetValue(math.clamp((u58 - u60) / 0.4, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                v64 = u61 * (1 - v65);

                if v65 >= 1 then
                    u8 = nil;
                    u7 = false;
                    pcall(function() -- Line: 444
                        -- upvalues: CameraModule (ref)
                        CameraModule.DisableCameraEvent_Helper("跳关飞行影响相机FOV");
                    end);

                    return CFrame.new(), 0;
                end;
            else
                v64 = u9 * 10;
                u61 = v64;
            end;

            return CFrame.new(), v64;
        end);
    end) then
        u7 = false;
        u8 = nil;
    end;
end;

local function _hideJumpFov(p66) -- Line: 512
    -- upvalues: u7 (ref), CameraModule (copy), u8 (ref)
    if not u7 then
        pcall(function() -- Line: 514
            -- upvalues: CameraModule (ref)
            CameraModule.DisableCameraEvent_Helper("跳关飞行影响相机FOV");
        end);

        return;
    end;

    if p66 then
        u8 = nil;
        u7 = false;
        pcall(function() -- Line: 444
            -- upvalues: CameraModule (ref)
            CameraModule.DisableCameraEvent_Helper("跳关飞行影响相机FOV");
        end);

        return;
    end;

    local v67 = u8;

    if v67 then
        v67();
        local v68 = os.clock() + 0.4 + 0.2;

        while u7 and os.clock() < v68 do
            task.wait();
        end;
    end;

    if u7 then
        u8 = nil;
        u7 = false;
        pcall(function() -- Line: 444
            -- upvalues: CameraModule (ref)
            CameraModule.DisableCameraEvent_Helper("跳关飞行影响相机FOV");
        end);
    end;
end;

local function _flightHeightAt(p69, p70, p71, p72, p73) -- Line: 549
    if p70 <= 0.001 then
        return p73;
    end;

    local v74 = math.min(100, p70);
    local v75 = p70 - v74;

    if p69 < v75 then
        if v75 <= 0.001 then
            return p72;
        end;

        local v76 = math.clamp(p69 / v75 / 0.15, 0, 1);

        return p71 + (p72 - p71) * v76;
    end;

    local v77 = (p69 - v75) / math.max(v74, 0.001);
    local v78 = math.clamp(v77, 0, 1);

    return p72 + (p73 - p72) * v78;
end;

local function _unitFlatOr(p79, p80) -- Line: 578
    local v81 = Vector3.new(p79.X, 0, p79.Z);

    if v81.Magnitude < 0.001 then
        return p80;
    end;

    return v81.Unit;
end;

local function _flatCrossY(p82, p83) -- Line: 593
    return p82.X * p83.Z - p82.Z * p83.X;
end;

local function _flatAtan2(p84) -- Line: 603
    return math.atan2(p84.Z, p84.X);
end;

local function _isInsideAngleCBA(p85, p86, p87, p88) -- Line: 616
    local v89 = Vector3.new(p85.X - p86.X, 0, p85.Z - p86.Z);
    local v90 = Vector3.new(p87.X - p86.X, 0, p87.Z - p86.Z);
    local v91 = Vector3.new(p88.X - p86.X, 0, p88.Z - p86.Z);

    if v89.Magnitude < 0.001 or (v90.Magnitude < 0.001 or v91.Magnitude < 0.001) then
        return false;
    end;

    local v92 = v89.X * v90.Z - v89.Z * v90.X;

    if math.abs(v92) < 1e-6 then
        return false;
    end;

    local v93 = v91.X * v90.Z - v91.Z * v90.X;
    local v94;

    if (v89.X * v91.Z - v89.Z * v91.X) * v92 >= 0 then
        v94 = v93 * v92 >= 0;
    else
        v94 = false;
    end;

    return v94;
end;

local function _signedSweep(p95, p96, p97) -- Line: 641
    local v98 = p96 - p95;

    if p97 then
        while v98 <= 0 do
            v98 = v98 + 6.283185307179586;
        end;

        while v98 > 6.283185307179586 do
            v98 = v98 - 6.283185307179586;
        end;

        return v98;
    end;

    while v98 >= 0 do
        v98 = v98 - 6.283185307179586;
    end;

    while v98 < -6.283185307179586 do
        v98 = v98 + 6.283185307179586;
    end;

    return v98;
end;

local function _tryBuildMergeArc(p99, p100, p101, p102) -- Line: 679
    -- upvalues: _isInsideAngleCBA (copy)
    local v103 = Vector3.new(p99.X - p100.X, 0, p99.Z - p100.Z);
    local Magnitude = v103.Magnitude;

    if Magnitude < 0.001 then
        return nil;
    end;

    local v104 = Vector3.new(-p102.Z, 0, p102.X);
    local v105;

    if v103:Dot(v104) < 0 then
        v104 = -v104;
        v105 = false;
    else
        v105 = true;
    end;

    local v106 = 2 * v103:Dot(v104);

    if v106 < 0.001 then
        return nil;
    end;

    local v107 = Magnitude * Magnitude / v106;

    if v107 < 0.001 or v107 > 2000 then
        return nil;
    end;

    local v108 = p100 + v104 * v107;

    if _isInsideAngleCBA(p101, p100, p99, v108) then
        return nil;
    end;

    local v109 = p99 - v108;
    local v110 = p100 - v108;

    if v109.Magnitude < 0.001 or v110.Magnitude < 0.001 then
        return nil;
    end;

    local v111 = math.atan2(v109.Z, v109.X);
    local v112 = math.atan2(v110.Z, v110.X) - v111;

    if v105 then
        while v112 <= 0 do
            v112 = v112 + 6.283185307179586;
        end;

        while v112 > 6.283185307179586 do
            v112 = v112 - 6.283185307179586;
        end;
    else
        while v112 >= 0 do
            v112 = v112 - 6.283185307179586;
        end;

        while v112 < -6.283185307179586 do
            v112 = v112 + 6.283185307179586;
        end;
    end;

    local v113 = v107 * math.abs(v112);

    return v113 >= 0.001 and {
        center = v108,
        radius = v107,
        ang0 = v111,
        sweep = v112,
        arcLen = v113,
        mergeFlat = p100
    } or nil;
end;

local function _arcFlatPos(p114, p115) -- Line: 743
    local v116 = math.clamp(p115, 0, 1);
    local v117 = p114.ang0 + p114.sweep * v116;
    local center = p114.center;
    local v118 = math.cos(v117) * p114.radius;
    local v119 = math.sin(v117) * p114.radius;

    return center + Vector3.new(v118, 0, v119);
end;

local function _arcFlatLook(p120, p121, p122) -- Line: 757
    local v123 = math.clamp(p121, 0, 1);
    local v124 = p120.ang0 + p120.sweep * v123;
    local v125 = -math.sin(v124) * p120.sweep;
    local v126 = math.cos(v124) * p120.sweep;
    local v127 = Vector3.new(v125, 0, v126);
    local v128 = Vector3.new(v127.X, 0, v127.Z);

    if v128.Magnitude < 0.001 then
        return p122;
    end;

    return v128.Unit;
end;

local function _lerpFlyAlongRunway(u129, p130, u131) -- Line: 774
    -- upvalues: u5 (ref), _clearFlightVelocities (copy), _tryBuildMergeArc (copy), _resolveSkipFlySpeed (copy), RunService (copy), u3 (ref), LocalPlayer (copy), _pathProgress (copy), u9 (ref), u6 (ref), SpeedLineFX (copy)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    _clearFlightVelocities(u129);
    local Position = u129.Position;
    local Y = Position.Y;
    local v132 = Vector3.new(Position.X, 0, Position.Z);
    local v133 = Vector3.new(p130.X, 0, p130.Z);
    local u134 = Vector3.new(u131.X, 0, u131.Z);
    local v135 = u134 - v133;
    local Magnitude = v135.Magnitude;
    local u136 = Magnitude <= 0.001 and Vector3.new(0, 0, -1) or Vector3.new(v135.X, 0, v135.Z).Unit;
    local v137;

    if Magnitude > 0.001 then
        local v138 = (v132 - v133):Dot(u136) / Magnitude;
        v137 = math.clamp(v138, 0, 1);
    else
        v137 = 0;
    end;

    local u139 = v133 + u136 * (v137 * Magnitude);
    local v140 = Magnitude * (1 - v137);
    local u141 = u131.Y + 5;
    local Y2 = u131.Y;
    local LookVector = u129.CFrame.LookVector;
    local v142 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local u143 = v142.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v142.Unit;

    if v140 <= 0.001 then
        local v144 = Vector3.new(u136.X, 0, u136.Z);
        u129.CFrame = CFrame.lookAt(u131, u131 + (v144.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v144.Unit));

        return;
    end;

    local v145 = math.min(80, v140 * 0.25);
    local v146 = v137 + v145 / math.max(Magnitude, 0.001);
    local v147 = v133 + u136 * (math.clamp(v146, v137, 1) * Magnitude);
    local u148;

    if (v132 - u139).Magnitude >= 2 and v145 > 0.01 then
        u148 = _tryBuildMergeArc(v132, v147, v133, u136);
    else
        u148 = nil;
    end;

    local u149;

    if u148 then
        u149 = u148.arcLen;
        u139 = u148.mergeFlat;
    else
        u149 = 0;
    end;

    local Magnitude2 = (u134 - u139).Magnitude;
    local u150 = math.max(u149 + Magnitude2, 0.001);
    local v151 = u150 / _resolveSkipFlySpeed();
    local u152 = math.max(v151, 0.05);
    local u153 = 0;
    local u154 = false;
    u5 = RunService.Heartbeat:Connect(function(p155) -- Line: 829
        -- upvalues: u3 (ref), u129 (copy), LocalPlayer (ref), u154 (ref), u5 (ref), u153 (ref), u152 (copy), _pathProgress (ref), u9 (ref), u6 (ref), SpeedLineFX (ref), u150 (copy), u148 (ref), u149 (ref), u136 (copy), Magnitude2 (copy), u139 (ref), u134 (copy), Y (copy), u141 (copy), Y2 (copy), u143 (copy), u131 (copy)
        if not u3 and u129.Parent then
            local Character = LocalPlayer.Character;
            local v156;

            if Character and Character.Parent then
                local v157 = Character:FindFirstChildOfClass("Humanoid");
                v156 = v157 and v157.Health > 0 and true or false;
            else
                v156 = false;
            end;

            if v156 then
                u153 = u153 + p155;
                local v158 = math.clamp(u153 / u152, 0, 1);
                local v159 = _pathProgress(v158);
                local v160 = math.clamp(v158, 0, 1);
                local v161 = 0.18;
                local v162 = 0.1;

                if v161 + v162 >= 0.95 then
                    local v163 = 0.94 / (v161 + v162);
                    v161 = v161 * v163;
                    v162 = v162 * v163;
                end;

                local v164;

                if v160 <= v161 then
                    v164 = v160 / v161;
                else
                    v164 = 1 - v162 > v160 and 1 or (1 - v160) / v162;
                end;

                u9 = math.clamp(v164, 0, 1);

                if u6 then
                    pcall(function() -- Line: 395
                        -- upvalues: SpeedLineFX (ref), u9 (ref)
                        SpeedLineFX.SetIntensity(u9);
                    end);
                end;

                local v165 = u150 * v159;
                local v166, v167;

                if u148 and v165 < u149 then
                    local v168 = u149 <= 0.001 and 1 or v165 / u149;
                    local v169 = u148;
                    local v170 = math.clamp(v168, 0, 1);
                    local v171 = v169.ang0 + v169.sweep * v170;
                    local center = v169.center;
                    local v172 = math.cos(v171) * v169.radius;
                    local v173 = math.sin(v171) * v169.radius;
                    v166 = center + Vector3.new(v172, 0, v173);
                    local v174 = u148;
                    v167 = u136;
                    local v175 = math.clamp(v168, 0, 1);
                    local v176 = v174.ang0 + v174.sweep * v175;
                    local v177 = -math.sin(v176) * v174.sweep;
                    local v178 = math.cos(v176) * v174.sweep;
                    local v179 = Vector3.new(v177, 0, v178);
                    local v180 = Vector3.new(v179.X, 0, v179.Z);

                    if v180.Magnitude >= 0.001 then
                        v167 = v180.Unit;
                    end;
                else
                    local v181;

                    if u148 then
                        v181 = math.max(v165 - u149, 0);
                    else
                        v181 = v165;
                    end;

                    v166 = u139:Lerp(u134, Magnitude2 <= 0.001 and 1 or math.clamp(v181 / Magnitude2, 0, 1));
                    v167 = u136;
                end;

                local v182 = u150;
                local v183 = Y;
                local v184 = u141;
                local v185 = Y2;

                if v182 <= 0.001 then
                    v184 = v185;
                else
                    local v186 = math.min(100, v182);
                    local v187 = v182 - v186;

                    if v165 < v187 then
                        if v187 > 0.001 then
                            local v188 = math.clamp(v165 / v187 / 0.15, 0, 1);
                            v184 = v183 + (v184 - v183) * v188;
                        end;
                    else
                        local v189 = (v165 - v187) / math.max(v186, 0.001);
                        local v190 = math.clamp(v189, 0, 1);
                        v184 = v184 + (v185 - v184) * v190;
                    end;
                end;

                local v191 = Vector3.new(v166.X, v184, v166.Z);

                if v158 <= 0.28 then
                    local v192 = math.clamp(v158 / 0.28, 0, 1);
                    local LookVector2 = CFrame.lookAt(Vector3.new(0, 0, 0), u143):Lerp(CFrame.lookAt(Vector3.new(0, 0, 0), v167), (math.clamp(v192 * v192 * (3 - v192 * 2), 0, 1))).LookVector;
                    local v193 = Vector3.new(LookVector2.X, 0, LookVector2.Z);
                    v167 = v193.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v193.Unit;
                end;

                local v194 = Vector3.new(v167.X, 0, v167.Z);
                u129.CFrame = CFrame.lookAt(v191, v191 + (v194.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v194.Unit));

                if v158 >= 1 then
                    local v195 = u131;
                    local v196 = u136;
                    local v197 = Vector3.new(v196.X, 0, v196.Z);
                    u129.CFrame = CFrame.lookAt(v195, v195 + (v197.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v197.Unit));
                    u9 = 0;

                    if u6 then
                        pcall(function() -- Line: 395
                            -- upvalues: SpeedLineFX (ref), u9 (ref)
                            SpeedLineFX.SetIntensity(u9);
                        end);
                    end;

                    u154 = true;

                    if u5 then
                        u5:Disconnect();
                        u5 = nil;
                    end;
                end;

                return;
            end;
        end;

        u154 = true;

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;
    end);

    while not (u154 or u3) do
        task.wait();
    end;
end;

local function _parseLandingPos(p198) -- Line: 891
    if typeof(p198) == "Vector3" then
        return p198;
    end;

    return nil;
end;

function u1.Play(p199, u200) -- Line: 905
    -- upvalues: u2 (ref), NetWork (copy), NetMsg (copy), u3 (ref), LocalPlayer (copy), HumanModule (copy), _requestFlightAbort (copy), u5 (ref), _ensureMounted (copy), _waitBroomMountDone (copy), _clearFlightVelocities (copy), u6 (ref), u9 (ref), SpeedLineFX (copy), _showJumpFov (copy), _lerpFlyAlongRunway (copy), _hideSpeedLine (copy), _hideJumpFov (copy), u7 (ref), CameraModule (copy), u8 (ref)
    if u2 then
        return;
    end;

    local v201 = tonumber(p199) or 0;
    local v202 = math.floor(v201);

    if v202 <= 0 then
        return;
    end;

    if typeof(u200) ~= "Vector3" then
        u200 = nil;
    end;

    local v203 = workspace:FindFirstChild("场景");
    local u204;

    if v203 then
        local v205 = v203:FindFirstChild("传送起点");

        if v205 and v205:IsA("CFrameValue") then
            u204 = v205.Value;
        else
            u204 = nil;
        end;
    else
        u204 = nil;
    end;

    if not (u200 and u204) then
        NetWork.FireServer(NetMsg.STAGE_JUMP_LANDED, v202);

        return;
    end;

    u2 = true;
    u3 = false;
    LocalPlayer:SetAttribute("DungeonJumpOpenThrough", v202 - 1);
    local v206 = HumanModule.GetCharacter(LocalPlayer);
    local v207 = {};

    if v206 then
        v206:SetAttribute("StageJumpAnimating", true);
        local v208 = v206:FindFirstChildOfClass("Humanoid");

        if v208 then
            table.insert(v207, v208.Died:Connect(_requestFlightAbort));
        end;

        table.insert(v207, v206.AncestryChanged:Connect(function(p209, p210) -- Line: 935
            -- upvalues: u3 (ref), u5 (ref)
            if p210 == nil then
                if u3 then
                    return;
                end;

                u3 = true;

                if u5 then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end;
        end));
    end;

    local success, result = pcall(function() -- Line: 942
        -- upvalues: u3 (ref), LocalPlayer (ref), _ensureMounted (ref), _waitBroomMountDone (ref), HumanModule (ref), _clearFlightVelocities (ref), u6 (ref), u9 (ref), SpeedLineFX (ref), _showJumpFov (ref), _lerpFlyAlongRunway (ref), u204 (copy), u200 (copy), _hideSpeedLine (ref), _hideJumpFov (ref), NetWork (ref), NetMsg (ref)
        if not u3 then
            local Character = LocalPlayer.Character;
            local v211;

            if Character and Character.Parent then
                local v212 = Character:FindFirstChildOfClass("Humanoid");
                v211 = v212 and v212.Health > 0 and true or false;
            else
                v211 = false;
            end;

            if v211 then
                if not _ensureMounted() then
                    return;
                end;

                if not _waitBroomMountDone() then
                    return;
                end;

                if not u3 then
                    local Character2 = LocalPlayer.Character;
                    local v213;

                    if Character2 and Character2.Parent then
                        local v214 = Character2:FindFirstChildOfClass("Humanoid");
                        v213 = v214 and v214.Health > 0 and true or false;
                    else
                        v213 = false;
                    end;

                    if v213 then
                        local v215 = HumanModule.GetHumanoidRootPart(LocalPlayer);

                        if not v215 then
                            return;
                        end;

                        _clearFlightVelocities(v215);
                        v215.Anchored = true;

                        if not u6 then
                            u6 = true;
                            u9 = 0;
                            pcall(function() -- Line: 431
                                -- upvalues: SpeedLineFX (ref)
                                SpeedLineFX.Show(0, 0.12);
                            end);
                        end;

                        _showJumpFov();
                        _lerpFlyAlongRunway(v215, u204.Position, u200);
                        _hideSpeedLine();
                        _hideJumpFov(false);

                        if u3 then
                            return;
                        end;

                        pcall(function() -- Line: 978
                            -- upvalues: NetWork (ref), NetMsg (ref)
                            NetWork.InvokeServer(NetMsg.DISMOUNT_BROOM);
                        end);
                    end;
                end;
            end;
        end;
    end);

    for _, v in v207 do
        v:Disconnect();
    end;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    _hideSpeedLine();

    if u7 then
        u8 = nil;
        u7 = false;
        pcall(function() -- Line: 444
            -- upvalues: CameraModule (ref)
            CameraModule.DisableCameraEvent_Helper("跳关飞行影响相机FOV");
        end);
    else
        pcall(function() -- Line: 514
            -- upvalues: CameraModule (ref)
            CameraModule.DisableCameraEvent_Helper("跳关飞行影响相机FOV");
        end);
    end;

    local v216 = HumanModule.GetHumanoidRootPart(LocalPlayer);

    if v216 then
        v216.Anchored = false;
        _clearFlightVelocities(v216);
    end;

    if v206 and v206.Parent then
        v206:SetAttribute("StageJumpAnimating", nil);
    end;

    LocalPlayer:SetAttribute("DungeonJumpOpenThrough", nil);
    local v217 = u3;
    u3 = false;
    u2 = false;

    if not success then
        warn("[StageJumpPresentation] play failed:", result);
    end;

    if v217 then
        NetWork.FireServer(NetMsg.STAGE_JUMP_ABORT);

        return;
    end;

    NetWork.FireServer(NetMsg.STAGE_JUMP_LANDED, v202);
end;

function u1.Init() -- Line: 1023
    -- upvalues: u4 (ref), SpeedLineFX (copy), NetWork (copy), NetMsg (copy), u1 (copy)
    if u4 then
        return;
    end;

    u4 = true;
    pcall(function() -- Line: 1029
        -- upvalues: SpeedLineFX (ref)
        SpeedLineFX.Preload();
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.STAGE_JUMP_START, function(p218, p219) -- Line: 1033
        -- upvalues: u1 (ref)
        u1.Play(p218, p219);
    end);
end;

return u1;