-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local WindStaffConfig = require(ReplicatedStorage.SharedModules.WindStaffConfig);
local EmitDuration = require(ReplicatedStorage.SharedModules.EmitDuration);
local LocalPlayer = Players.LocalPlayer;
local ANIM_NUMERIC_ID = WindStaffConfig.ANIM_NUMERIC_ID;

local function getStaffSound(p2) -- Line: 31
    -- upvalues: SoundService (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("WindStaff");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p2);
    end;

    if SFX and SFX:IsA("Sound") then
        return SFX;
    end;

    return nil;
end;

local function playStaffSound2D(p3) -- Line: 42
    -- upvalues: SoundService (copy), Debris (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("WindStaff");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p3);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        return;
    end;

    local u4 = SFX:Clone();
    u4.Looped = false;
    u4.Parent = SoundService;
    u4:Play();
    u4.Ended:Once(function() -- Line: 49
        -- upvalues: u4 (copy)
        u4:Destroy();
    end);
    Debris:AddItem(u4, 30);
end;

local u5 = nil;

local function stopWindLoop() -- Line: 58
    -- upvalues: u5 (ref)
    if u5 then
        u5:Stop();
        u5:Destroy();
        u5 = nil;
    end;
end;

local function startWindLoop() -- Line: 66
    -- upvalues: u5 (ref), SoundService (copy)
    if u5 then
        u5:Stop();
        u5:Destroy();
        u5 = nil;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("WindStaff");
    end;

    if SFX then
        SFX = SFX:FindFirstChild("WindStaffLoop");
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        return;
    end;

    local v6 = SFX:Clone();
    v6.Looped = true;
    v6.Parent = SoundService;
    v6:Play();
    u5 = v6;
end;

local function isLoading() -- Line: 82
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("LoadingScreenActive") == true;
end;

local u7 = nil;

local function cooldownEnd() -- Line: 92
    -- upvalues: LocalPlayer (copy), u7 (ref)
    local v8 = LocalPlayer:GetAttribute("WindStaffCooldownEnd");
    local v9 = type(v8) ~= "number" and 0 or v8;

    return math.max(v9, u7 or 0);
end;

local function stampCooldownDisplay(p10) -- Line: 103
    -- upvalues: LocalPlayer (copy), u7 (ref)
    local v11 = LocalPlayer:GetAttribute("WindStaffCooldownEnd");
    local v12 = type(v11) ~= "number" and 0 or v11;
    local v13 = math.max(v12, u7 or 0);
    local v14 = v13 <= 0 and 0 or v13 - workspace:GetServerTimeNow();
    p10:SetAttribute("CooldownEnd", v14 <= 0 and 0 or os.clock() + v14);
end;

local function applyToTool(p15) -- Line: 109
    -- upvalues: LocalPlayer (copy), u7 (ref)
    if p15:GetAttribute("WindStaff") == nil then
        return;
    end;

    p15.Enabled = LocalPlayer:GetAttribute("LoadingScreenActive") ~= true;
    local v16 = LocalPlayer:GetAttribute("WindStaffCooldownEnd");
    local v17 = type(v16) ~= "number" and 0 or v16;
    local v18 = math.max(v17, u7 or 0);
    local v19 = v18 <= 0 and 0 or v18 - workspace:GetServerTimeNow();
    p15:SetAttribute("CooldownEnd", v19 <= 0 and 0 or os.clock() + v19);
end;

local function refreshContainer(p20) -- Line: 115
    -- upvalues: LocalPlayer (copy), u7 (ref)
    if not p20 then
        return;
    end;

    for _, child in p20:GetChildren() do
        if child:IsA("Tool") then
            if child:GetAttribute("WindStaff") ~= nil then
                child.Enabled = LocalPlayer:GetAttribute("LoadingScreenActive") ~= true;
                local v21 = LocalPlayer:GetAttribute("WindStaffCooldownEnd");
                local v22 = type(v21) ~= "number" and 0 or v21;
                local v23 = math.max(v22, u7 or 0);
                local v24 = v23 <= 0 and 0 or v23 - workspace:GetServerTimeNow();
                child:SetAttribute("CooldownEnd", v24 <= 0 and 0 or os.clock() + v24);
            end;
        end;
    end;
end;

local function refreshAll() -- Line: 124
    -- upvalues: refreshContainer (copy), LocalPlayer (copy)
    refreshContainer(LocalPlayer:FindFirstChild("Backpack"));
    refreshContainer(LocalPlayer.Character);
end;

local function watchContainer(p25) -- Line: 129
    -- upvalues: refreshContainer (copy), applyToTool (copy)
    refreshContainer(p25);
    p25.ChildAdded:Connect(function(p26) -- Line: 131
        -- upvalues: applyToTool (ref)
        if p26:IsA("Tool") then
            task.defer(applyToTool, p26);
        end;
    end);
end;

local function findStaffTool(p27) -- Line: 139
    if not p27 then
        return nil;
    end;

    for _, child in p27:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("WindStaff") ~= nil then
            return child;
        end;
    end;

    return nil;
end;

local u28 = {};

local function releaseEquipLock(p29) -- Line: 168
    if p29.UnequipConn then
        p29.UnequipConn:Disconnect();
        p29.UnequipConn = nil;
    end;

    p29.StaffTool = nil;
end;

local function restoreHidden(p30) -- Line: 177
    if not p30.Hidden then
        return;
    end;

    for _, v in p30.Hidden do
        if v.Inst.Parent then
            v.Inst[v.Prop] = v.Value;
        end;
    end;

    p30.Hidden = nil;
end;

local function hideRealStaff(p31, p32) -- Line: 189
    local v33 = {};

    for _, descendant in p32:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v33, {
                Prop = "LocalTransparencyModifier",
                Inst = descendant,
                Value = descendant.LocalTransparencyModifier
            });
            descendant.LocalTransparencyModifier = 1;
        elseif descendant:IsA("Decal") then
            table.insert(v33, {
                Prop = "Transparency",
                Inst = descendant,
                Value = descendant.Transparency
            });
            descendant.Transparency = 1;
        end;
    end;

    p31.Hidden = v33;
end;

local function buildDummy(p34, p35, p36) -- Line: 209
    local Model = Instance.new("Model");
    Model.Name = "WindStaffDummy";
    local v37 = p34:Clone();

    for _, child in v37:GetChildren() do
        child.Parent = Model;
    end;

    v37:Destroy();
    local v38 = Model:FindFirstChild(p35.Name);

    if not (v38 and v38:IsA("BasePart")) then
        v38 = Model:FindFirstChildWhichIsA("BasePart", true);
    end;

    if not (v38 and v38:IsA("BasePart")) then
        Model:Destroy();

        return nil;
    end;

    Model.PrimaryPart = v38;

    for _, descendant in Model:GetDescendants() do
        if descendant:IsA("BaseScript") then
            descendant:Destroy();
        end;
    end;

    for _, descendant in Model:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;

            if descendant ~= v38 then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = v38;
                WeldConstraint.Part1 = descendant;
                WeldConstraint.Parent = v38;
            end;
        end;
    end;

    v38.CFrame = p35.CFrame;
    local RightGrip = p35:FindFirstChild("RightGrip");
    local Weld = Instance.new("Weld");

    if RightGrip and (RightGrip:IsA("Weld") and RightGrip.Part0) then
        Weld.Part0 = RightGrip.Part0;
        Weld.C0 = RightGrip.C0;
        Weld.C1 = RightGrip.C1;
    else
        local v39 = p36:FindFirstChild("RightHand") or p36:FindFirstChild("Right Arm");

        if v39 and v39:IsA("BasePart") then
            Weld.Part0 = v39;
            Weld.C0 = v39.CFrame:ToObjectSpace(p35.CFrame);
        end;
    end;

    if Weld.Part0 then
        Weld.Part1 = v38;
        Weld.Parent = v38;
    else
        Weld:Destroy();
        v38.Anchored = true;
    end;

    Model.Parent = workspace;

    return Model;
end;

local function destroyDummy(p40) -- Line: 278
    if p40.Dummy then
        p40.Dummy:Destroy();
        p40.Dummy = nil;
    end;
end;

local function removeStaffFromHand(p41) -- Line: 286
    if p41.Dummy and p41.Dummy then
        p41.Dummy:Destroy();
        p41.Dummy = nil;
    end;
end;

local function finishCast(p42) -- Line: 293
    -- upvalues: u28 (copy), restoreHidden (copy)
    local v43 = u28[p42];

    if not v43 then
        return;
    end;

    u28[p42] = nil;

    for _, v in v43.Connections do
        v:Disconnect();
    end;

    if v43.UnequipConn then
        v43.UnequipConn:Disconnect();
        v43.UnequipConn = nil;
    end;

    v43.StaffTool = nil;

    if v43.Dummy then
        v43.Dummy:Destroy();
        v43.Dummy = nil;
    end;

    restoreHidden(v43);
end;

local function hardCleanup(p44) -- Line: 307
    -- upvalues: u28 (copy), finishCast (copy)
    local v45 = u28[p44];

    if not v45 then
        return;
    end;

    if v45.Track then
        v45.Track:Stop();
    end;

    finishCast(p44);
end;

local function onStrike(u46, u47) -- Line: 319
    -- upvalues: EmitDuration (copy), Networking (copy), WindStaffConfig (copy), u28 (copy), finishCast (copy)
    if u47.Struck then
        return;
    end;

    u47.Struck = true;
    local StaffTool = u47.StaffTool;

    if StaffTool then
        StaffTool = StaffTool:FindFirstChild("Explosion", true);
    end;

    if StaffTool then
        EmitDuration(StaffTool);
    end;

    if u47.IsLocal then
        Networking.WindStaff.TriggerTornado:Fire();
    end;

    task.delay(WindStaffConfig.STAFF_REMOVE_DELAY, function() -- Line: 337
        -- upvalues: u28 (ref), u46 (copy), u47 (copy), finishCast (ref)
        if u28[u46] == u47 then
            local v48 = u47;

            if v48.Dummy and v48.Dummy then
                v48.Dummy:Destroy();
                v48.Dummy = nil;
            end;

            finishCast(u46);
        end;
    end);
end;

local function bindMarker(u49, u50, p51) -- Line: 345
    -- upvalues: WindStaffConfig (copy), onStrike (copy)
    local v52 = p51:GetMarkerReachedSignal(WindStaffConfig.STRIKE_MARKER):Connect(function() -- Line: 346
        -- upvalues: onStrike (ref), u49 (copy), u50 (copy)
        onStrike(u49, u50);
    end);
    table.insert(u50.Connections, v52);
end;

local function scheduleFallback(u53, u54) -- Line: 352
    -- upvalues: WindStaffConfig (copy), u28 (copy), onStrike (copy)
    task.delay(WindStaffConfig.STRIKE_FALLBACK, function() -- Line: 353
        -- upvalues: u28 (ref), u53 (copy), u54 (copy), onStrike (ref)
        if u28[u53] ~= u54 then
            return;
        end;

        onStrike(u53, u54);
    end);
end;

local function setupEquipLock(u55, u56, u57) -- Line: 362
    -- upvalues: u28 (copy), LocalPlayer (copy)
    if not u57 then
        return;
    end;

    u56.StaffTool = u57;
    u56.UnequipConn = u57.Unequipped:Connect(function() -- Line: 365
        -- upvalues: u28 (ref), u55 (copy), u56 (copy), LocalPlayer (ref), u57 (copy)
        if u28[u55] ~= u56 then
            return;
        end;

        task.defer(function() -- Line: 367
            -- upvalues: u28 (ref), u55 (ref), u56 (ref), LocalPlayer (ref), u57 (ref)
            if u28[u55] ~= u56 then
                return;
            end;

            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character and u57:IsDescendantOf(LocalPlayer) then
                Character:EquipTool(u57);
            end;
        end);
    end);
end;

local function playCast(u58, p59) -- Line: 381
    -- upvalues: u28 (copy), finishCast (copy), LocalPlayer (copy), findStaffTool (copy), u7 (ref), WindStaffConfig (copy), playStaffSound2D (copy), buildDummy (copy), hideRealStaff (copy), onStrike (copy), ANIM_NUMERIC_ID (copy)
    if typeof(u58) ~= "Instance" or not u58:IsA("Player") then
        return;
    end;

    local v60 = u28[u58] and u28[u58];

    if v60 then
        if v60.Track then
            v60.Track:Stop();
        end;

        finishCast(u58);
    end;

    local Character = u58.Character;

    if not Character then
        return;
    end;

    local u61 = Character:FindFirstChildOfClass("Humanoid");

    if u61 then
        u61 = u61:FindFirstChildOfClass("Animator");
    end;

    if not u61 then
        return;
    end;

    local u62 = {
        Struck = false,
        Caster = u58,
        IsLocal = u58 == LocalPlayer,
        Connections = {}
    };
    u28[u58] = u62;
    local u63 = findStaffTool(Character);
    u62.StaffTool = u63;
    local v64 = nil;
    local v65;

    if u63 then
        v65 = u63.PrimaryPart or u63:FindFirstChild("Handle");

        if v65 then
            if not v65:IsA("BasePart") then
                v65 = v64;
            end;
        else
            v65 = v64;
        end;
    else
        v65 = v64;
    end;

    if u62.IsLocal then
        u7 = workspace:GetServerTimeNow() + WindStaffConfig.COOLDOWN;

        if u63 then
            local v66 = LocalPlayer:GetAttribute("WindStaffCooldownEnd");
            local v67 = type(v66) ~= "number" and 0 or v66;
            local v68 = math.max(v67, u7 or 0);
            local v69 = v68 <= 0 and 0 or v68 - workspace:GetServerTimeNow();
            u63:SetAttribute("CooldownEnd", v69 <= 0 and 0 or os.clock() + v69);
        end;

        playStaffSound2D("WindStaffCast");
    end;

    if p59 and (u63 and v65) then
        local v70 = buildDummy(u63, v65, Character);

        if v70 then
            u62.Dummy = v70;
            hideRealStaff(u62, u63);
        end;
    elseif u62.IsLocal and (u63 and u63) then
        u62.StaffTool = u63;
        u62.UnequipConn = u63.Unequipped:Connect(function() -- Line: 365
            -- upvalues: u28 (ref), u58 (copy), u62 (copy), LocalPlayer (ref), u63 (copy)
            if u28[u58] ~= u62 then
                return;
            end;

            task.defer(function() -- Line: 367
                -- upvalues: u28 (ref), u58 (ref), u62 (ref), LocalPlayer (ref), u63 (ref)
                if u28[u58] ~= u62 then
                    return;
                end;

                local Character2 = LocalPlayer.Character;

                if Character2 then
                    Character2 = Character2:FindFirstChildOfClass("Humanoid");
                end;

                if Character2 and u63:IsDescendantOf(LocalPlayer) then
                    Character2:EquipTool(u63);
                end;
            end);
        end);
    end;

    if u62.IsLocal then
        local Animation = Instance.new("Animation");
        Animation.AnimationId = WindStaffConfig.ANIM_ID;
        local success, result = pcall(function() -- Line: 442
            -- upvalues: u61 (copy), Animation (copy)
            return u61:LoadAnimation(Animation);
        end);

        if not (success and result) then
            return;
        end;

        result.Priority = Enum.AnimationPriority.Action;
        result.Looped = false;
        u62.Track = result;
        result:Play();
        local v72 = result.Stopped:Connect(function() -- Line: 453
            -- upvalues: u28 (ref), u58 (copy), u62 (copy)
            if u28[u58] ~= u62 then
                return;
            end;

            local v71 = u62;

            if v71.UnequipConn then
                v71.UnequipConn:Disconnect();
                v71.UnequipConn = nil;
            end;

            v71.StaffTool = nil;
        end);
        table.insert(u62.Connections, v72);
        local v73 = result:GetMarkerReachedSignal(WindStaffConfig.STRIKE_MARKER):Connect(function() -- Line: 346
            -- upvalues: onStrike (ref), u58 (copy), u62 (copy)
            onStrike(u58, u62);
        end);
        table.insert(u62.Connections, v73);
        task.delay(WindStaffConfig.STRIKE_FALLBACK, function() -- Line: 353
            -- upvalues: u28 (ref), u58 (copy), u62 (copy), onStrike (ref)
            if u28[u58] ~= u62 then
                return;
            end;

            onStrike(u58, u62);
        end);
    else
        local v78 = u61.AnimationPlayed:Connect(function(p74) -- Line: 466
            -- upvalues: u62 (copy), ANIM_NUMERIC_ID (ref), u58 (copy), WindStaffConfig (ref), onStrike (ref)
            if u62.Struck then
                return;
            end;

            local Animation = p74.Animation;

            if not Animation then
                return;
            end;

            if not string.find(Animation.AnimationId, ANIM_NUMERIC_ID, 1, true) then
                return;
            end;

            local u75 = u58;
            local u76 = u62;
            local v77 = p74:GetMarkerReachedSignal(WindStaffConfig.STRIKE_MARKER):Connect(function() -- Line: 346
                -- upvalues: onStrike (ref), u75 (copy), u76 (copy)
                onStrike(u75, u76);
            end);
            table.insert(u76.Connections, v77);
        end);
        table.insert(u62.Connections, v78);
        task.delay(WindStaffConfig.STRIKE_FALLBACK, function() -- Line: 353
            -- upvalues: u28 (ref), u58 (copy), u62 (copy), onStrike (ref)
            if u28[u58] ~= u62 then
                return;
            end;

            onStrike(u58, u62);
        end);
    end;

    task.delay(WindStaffConfig.MAX_CAST_LIFETIME, function() -- Line: 478
        -- upvalues: u28 (ref), u58 (copy), u62 (copy), finishCast (ref)
        if u28[u58] == u62 then
            finishCast(u58);
        end;
    end);
end;

local u79 = nil;

local function stopOrbit() -- Line: 495
    -- upvalues: u79 (ref)
    local v80 = u79;

    if not v80 then
        return;
    end;

    u79 = nil;

    if v80.Conn then
        v80.Conn:Disconnect();
    end;

    if v80.Align then
        v80.Align:Destroy();
    end;

    if v80.Attachment then
        v80.Attachment:Destroy();
    end;
end;

local function startOrbit(u81, u82, u83, u84, u85) -- Line: 510
    -- upvalues: u79 (ref), LocalPlayer (copy), WindStaffConfig (copy), RunService (copy)
    if typeof(u81) ~= "Vector3" then
        return;
    end;

    local v86 = u79;

    if v86 then
        u79 = nil;

        if v86.Conn then
            v86.Conn:Disconnect();
        end;

        if v86.Align then
            v86.Align:Destroy();
        end;

        if v86.Attachment then
            v86.Attachment:Destroy();
        end;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (Character and Character:IsA("BasePart")) then
        return;
    end;

    local v87 = Character.Position - u81;
    local u88 = math.atan2(v87.Z, v87.X);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "WindStaffOrbitAttachment";
    Attachment.Parent = Character;
    local AlignPosition = Instance.new("AlignPosition");
    AlignPosition.Name = "WindStaffOrbit";
    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
    AlignPosition.Attachment0 = Attachment;
    AlignPosition.RigidityEnabled = false;
    AlignPosition.ForceLimitMode = Enum.ForceLimitMode.Magnitude;
    AlignPosition.MaxForce = WindStaffConfig.ORBIT_MAX_FORCE;
    AlignPosition.MaxVelocity = (1 / 0);
    AlignPosition.Responsiveness = WindStaffConfig.ORBIT_RESPONSIVENESS;
    AlignPosition.Position = Character.Position;
    AlignPosition.Parent = Character;
    local u89 = {
        Align = AlignPosition,
        Attachment = Attachment
    };
    u79 = u89;
    local u90 = 0;
    u89.Conn = RunService.Heartbeat:Connect(function(p91) -- Line: 542
        -- upvalues: u79 (ref), u89 (copy), u85 (copy), LocalPlayer (ref), AlignPosition (copy), u90 (ref), u88 (copy), u84 (copy), u81 (copy), WindStaffConfig (ref), u83 (copy), u82 (copy)
        if u79 ~= u89 then
            return;
        end;

        if u85 <= workspace:GetServerTimeNow() then
            local v92 = u79;

            if not v92 then
                return;
            end;

            u79 = nil;

            if v92.Conn then
                v92.Conn:Disconnect();
            end;

            if v92.Align then
                v92.Align:Destroy();
            end;

            if v92.Attachment then
                v92.Attachment:Destroy();
            end;

            return;
        end;

        if not (LocalPlayer.Character and (AlignPosition.Parent and AlignPosition.Parent:IsDescendantOf(workspace))) then
            local v93 = u79;

            if not v93 then
                return;
            end;

            u79 = nil;

            if v93.Conn then
                v93.Conn:Disconnect();
            end;

            if v93.Align then
                v93.Align:Destroy();
            end;

            if v93.Attachment then
                v93.Attachment:Destroy();
            end;

            return;
        end;

        u90 = u90 + p91;
        local v94 = u88 + u84 * u90;
        local v95 = u81.Y + math.sin(u90 * WindStaffConfig.ORBIT_VERTICAL_SPEED) * u83;
        local v96 = u81.X + math.cos(v94) * u82;
        local v97 = u81.Z + math.sin(v94) * u82;
        AlignPosition.Position = Vector3.new(v96, v95, v97);
    end);
end;

function v1.Init(p98) -- Line: 568
end;

function v1.Start(p99) -- Line: 570
    -- upvalues: LocalPlayer (copy), refreshContainer (copy), applyToTool (copy), u28 (copy), finishCast (copy), u79 (ref), refreshAll (copy), Networking (copy), u7 (ref), playCast (copy), startOrbit (copy), stopOrbit (copy), startWindLoop (copy), u5 (ref), playStaffSound2D (copy), Players (copy)
    local v100 = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 10);

    if v100 then
        refreshContainer(v100);
        v100.ChildAdded:Connect(function(p101) -- Line: 131
            -- upvalues: applyToTool (ref)
            if p101:IsA("Tool") then
                task.defer(applyToTool, p101);
            end;
        end);
    end;

    if LocalPlayer.Character then
        local Character = LocalPlayer.Character;
        refreshContainer(Character);
        Character.ChildAdded:Connect(function(p102) -- Line: 131
            -- upvalues: applyToTool (ref)
            if p102:IsA("Tool") then
                task.defer(applyToTool, p102);
            end;
        end);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p103) -- Line: 579
        -- upvalues: LocalPlayer (ref), u28 (ref), finishCast (ref), u79 (ref), refreshContainer (ref), applyToTool (ref)
        local v104 = LocalPlayer;
        local v105 = u28[v104];

        if v105 then
            if v105.Track then
                v105.Track:Stop();
            end;

            finishCast(v104);
        end;

        local v106 = u79;

        if v106 then
            u79 = nil;

            if v106.Conn then
                v106.Conn:Disconnect();
            end;

            if v106.Align then
                v106.Align:Destroy();
            end;

            if v106.Attachment then
                v106.Attachment:Destroy();
            end;
        end;

        refreshContainer(p103);
        p103.ChildAdded:Connect(function(p107) -- Line: 131
            -- upvalues: applyToTool (ref)
            if p107:IsA("Tool") then
                task.defer(applyToTool, p107);
            end;
        end);
        local v108 = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 10);

        if v108 then
            refreshContainer(v108);
            v108.ChildAdded:Connect(function(p109) -- Line: 131
                -- upvalues: applyToTool (ref)
                if p109:IsA("Tool") then
                    task.defer(applyToTool, p109);
                end;
            end);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("LoadingScreenActive"):Connect(refreshAll);
    LocalPlayer:GetAttributeChangedSignal("WindStaffCooldownEnd"):Connect(refreshAll);
    Networking.Gear.CooldownsReset.OnClientEvent:Connect(function() -- Line: 598
        -- upvalues: u7 (ref)
        u7 = nil;
    end);
    Networking.WindStaff.PlayCast.OnClientEvent:Connect(playCast);
    Networking.WindStaff.StartOrbit.OnClientEvent:Connect(startOrbit);
    Networking.WindStaff.StopOrbit.OnClientEvent:Connect(stopOrbit);
    Networking.WindStaff.TornadoStarted.OnClientEvent:Connect(startWindLoop);
    Networking.WindStaff.TornadoEnded.OnClientEvent:Connect(function() -- Line: 608
        -- upvalues: u5 (ref), playStaffSound2D (ref)
        if u5 then
            u5:Stop();
            u5:Destroy();
            u5 = nil;
        end;

        playStaffSound2D("WindStaffEnd");
    end);
    Players.PlayerRemoving:Connect(function(p110) -- Line: 613
        -- upvalues: u28 (ref), finishCast (ref)
        local v111 = u28[p110];

        if not v111 then
            return;
        end;

        if v111.Track then
            v111.Track:Stop();
        end;

        finishCast(p110);
    end);
end;

return v1;