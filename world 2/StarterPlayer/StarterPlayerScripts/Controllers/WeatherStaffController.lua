-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local WeatherStaffConfig = require(ReplicatedStorage.SharedModules.WeatherStaffConfig);
local Flash = require(ReplicatedStorage.ClientModules.Flash);
local EmitDuration = require(ReplicatedStorage.SharedModules.EmitDuration);
local LocalPlayer = Players.LocalPlayer;

local function dprint(...) -- Line: 24
    print("[WeatherStaff][client]", ...);
end;

local function getStaffSound(p2) -- Line: 33
    -- upvalues: SoundService (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("WeatherStaff");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p2);
    end;

    if SFX and SFX:IsA("Sound") then
        return SFX;
    end;

    return nil;
end;

local function playStaffSound2D(p3) -- Line: 44
    -- upvalues: SoundService (copy), dprint (copy), Debris (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("WeatherStaff");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p3);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        dprint((`sound: "{p3}" not found under SoundService/SFX/WeatherStaff`));

        return;
    end;

    local u4 = SFX:Clone();
    u4.Parent = SoundService;
    u4:Play();
    u4.Ended:Once(function() -- Line: 53
        -- upvalues: u4 (copy)
        u4:Destroy();
    end);
    Debris:AddItem(u4, 15);
end;

local function playStaffSoundAt(p5, p6) -- Line: 60
    -- upvalues: SoundService (copy), dprint (copy), Debris (copy)
    if not p6 then
        return;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("WeatherStaff");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p5);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        dprint((`sound: "{p5}" not found under SoundService/SFX/WeatherStaff`));

        return;
    end;

    local u7 = SFX:Clone();
    u7.Parent = p6;
    u7:Play();
    u7.Ended:Once(function() -- Line: 70
        -- upvalues: u7 (copy)
        u7:Destroy();
    end);
    Debris:AddItem(u7, 15);
end;

local function isLoading() -- Line: 81
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("LoadingScreenActive") == true;
end;

local u8 = nil;

local function stampCooldownDisplay(p9) -- Line: 94
    -- upvalues: u8 (ref)
    if not u8 then
        return;
    end;

    local v10 = u8 - workspace:GetServerTimeNow();

    if v10 > 0 then
        p9:SetAttribute("CooldownEnd", os.clock() + v10);
    end;
end;

local function applyToTool(p11) -- Line: 102
    -- upvalues: LocalPlayer (copy), u8 (ref)
    if p11:GetAttribute("WeatherStaff") == nil then
        return;
    end;

    p11.Enabled = LocalPlayer:GetAttribute("LoadingScreenActive") ~= true;

    if not u8 then
        return;
    end;

    local v12 = u8 - workspace:GetServerTimeNow();

    if v12 > 0 then
        p11:SetAttribute("CooldownEnd", os.clock() + v12);
    end;
end;

local function refreshContainer(p13) -- Line: 108
    -- upvalues: LocalPlayer (copy), u8 (ref)
    if not p13 then
        return;
    end;

    for _, child in p13:GetChildren() do
        if child:IsA("Tool") then
            if child:GetAttribute("WeatherStaff") ~= nil then
                child.Enabled = LocalPlayer:GetAttribute("LoadingScreenActive") ~= true;

                if u8 then
                    local v14 = u8 - workspace:GetServerTimeNow();

                    if v14 > 0 then
                        child:SetAttribute("CooldownEnd", os.clock() + v14);
                    end;
                end;
            end;
        end;
    end;
end;

local function refreshAll() -- Line: 117
    -- upvalues: refreshContainer (copy), LocalPlayer (copy)
    refreshContainer(LocalPlayer:FindFirstChild("Backpack"));
    refreshContainer(LocalPlayer.Character);
end;

local function watchContainer(p15) -- Line: 122
    -- upvalues: refreshContainer (copy), applyToTool (copy)
    refreshContainer(p15);
    p15.ChildAdded:Connect(function(p16) -- Line: 124
        -- upvalues: applyToTool (ref)
        if p16:IsA("Tool") then
            task.defer(applyToTool, p16);
        end;
    end);
end;

local function findStaffTool(p17) -- Line: 132
    if not p17 then
        return nil;
    end;

    for _, child in p17:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("WeatherStaff") ~= nil then
            return child;
        end;
    end;

    return nil;
end;

local u18 = {};

local function getCamera() -- Line: 170
    return workspace.CurrentCamera;
end;

local function releaseEquipLock(p19) -- Line: 174
    if p19.UnequipConn then
        p19.UnequipConn:Disconnect();
        p19.UnequipConn = nil;
    end;

    p19.StaffTool = nil;
end;

local function restoreHidden(p20) -- Line: 184
    if not p20.Hidden then
        return;
    end;

    for _, v in p20.Hidden do
        if v.Inst.Parent then
            v.Inst[v.Prop] = v.Value;
        end;
    end;

    p20.Hidden = nil;
end;

local function hideRealStaff(p21, p22) -- Line: 196
    local v23 = {};

    for _, descendant in p22:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v23, {
                Prop = "LocalTransparencyModifier",
                Inst = descendant,
                Value = descendant.LocalTransparencyModifier
            });
            descendant.LocalTransparencyModifier = 1;
        elseif descendant:IsA("Decal") then
            table.insert(v23, {
                Prop = "Transparency",
                Inst = descendant,
                Value = descendant.Transparency
            });
            descendant.Transparency = 1;
        end;
    end;

    p21.Hidden = v23;
end;

local function buildDummy(p24, p25, p26) -- Line: 216
    local Model = Instance.new("Model");
    Model.Name = "WeatherStaffDummy";
    local v27 = p24:Clone();

    for _, child in v27:GetChildren() do
        child.Parent = Model;
    end;

    v27:Destroy();
    local v28 = Model:FindFirstChild(p25.Name);

    if not (v28 and v28:IsA("BasePart")) then
        v28 = Model:FindFirstChildWhichIsA("BasePart", true);
    end;

    if not (v28 and v28:IsA("BasePart")) then
        Model:Destroy();

        return nil, nil;
    end;

    Model.PrimaryPart = v28;

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

            if descendant ~= v28 then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = v28;
                WeldConstraint.Part1 = descendant;
                WeldConstraint.Parent = v28;
            end;
        end;
    end;

    v28.CFrame = p25.CFrame;
    local RightGrip = p25:FindFirstChild("RightGrip");
    local Weld = Instance.new("Weld");

    if RightGrip and (RightGrip:IsA("Weld") and RightGrip.Part0) then
        Weld.Part0 = RightGrip.Part0;
        Weld.C0 = RightGrip.C0;
        Weld.C1 = RightGrip.C1;
    else
        local v29 = p26:FindFirstChild("RightHand") or p26:FindFirstChild("Right Arm");

        if v29 and v29:IsA("BasePart") then
            Weld.Part0 = v29;
            Weld.C0 = v29.CFrame:ToObjectSpace(p25.CFrame);
        end;
    end;

    if Weld.Part0 then
        Weld.Part1 = v28;
        Weld.Parent = v28;
    else
        Weld:Destroy();
        v28.Anchored = true;
    end;

    Model.Parent = workspace;

    return Model, v28;
end;

local function destroyDummy(p30) -- Line: 285
    if p30.Dummy then
        p30.Dummy:Destroy();
        p30.Dummy = nil;
    end;
end;

local function removeStaffFromHand(p31) -- Line: 295
    if p31.Dummy and p31.Dummy then
        p31.Dummy:Destroy();
        p31.Dummy = nil;
    end;
end;

local function restoreZoom(p32) -- Line: 301
    -- upvalues: LocalPlayer (copy)
    if p32.ZoomRestored then
        return;
    end;

    p32.ZoomRestored = true;

    if p32.ZoomTween then
        p32.ZoomTween:Cancel();
        p32.ZoomTween = nil;
    end;

    local SavedDistance = p32.SavedDistance;
    local SavedMinZoom = p32.SavedMinZoom;
    local SavedMaxZoom = p32.SavedMaxZoom;

    if SavedDistance then
        LocalPlayer.CameraMinZoomDistance = SavedDistance;
        LocalPlayer.CameraMaxZoomDistance = SavedDistance;
    end;

    task.delay(0.1, function() -- Line: 324
        -- upvalues: SavedMinZoom (copy), LocalPlayer (ref), SavedMaxZoom (copy)
        if SavedMinZoom then
            LocalPlayer.CameraMinZoomDistance = SavedMinZoom;
        end;

        if SavedMaxZoom then
            LocalPlayer.CameraMaxZoomDistance = SavedMaxZoom;
        end;
    end);
end;

local function finishCast(p33) -- Line: 336
    -- upvalues: u18 (copy), restoreHidden (copy), restoreZoom (copy)
    local v34 = u18[p33];

    if not v34 then
        return;
    end;

    u18[p33] = nil;

    for _, v in v34.Connections do
        v:Disconnect();
    end;

    if v34.UnequipConn then
        v34.UnequipConn:Disconnect();
        v34.UnequipConn = nil;
    end;

    v34.StaffTool = nil;

    if v34.Dummy then
        v34.Dummy:Destroy();
        v34.Dummy = nil;
    end;

    restoreHidden(v34);

    if v34.IsLocal and not v34.ZoomRestored then
        restoreZoom(v34);
    end;
end;

local function hardCleanup(p35) -- Line: 354
    -- upvalues: u18 (copy), restoreZoom (copy), finishCast (copy)
    local v36 = u18[p35];

    if not v36 then
        return;
    end;

    if v36.ZoomTween then
        v36.ZoomTween:Cancel();
        v36.ZoomTween = nil;
    end;

    if v36.IsLocal and not v36.ZoomRestored then
        restoreZoom(v36);
    end;

    if v36.Orb then
        v36.Orb:Destroy();
        v36.Orb = nil;
    end;

    if v36.Track then
        v36.Track:Stop();
    end;

    finishCast(p35);
end;

local function startCameraSequence(u37) -- Line: 379
    -- upvalues: LocalPlayer (copy), WeatherStaffConfig (copy), TweenService (copy), u18 (copy), playStaffSound2D (copy), Flash (copy), restoreZoom (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    u37.SavedMinZoom = LocalPlayer.CameraMinZoomDistance;
    u37.SavedMaxZoom = LocalPlayer.CameraMaxZoomDistance;
    local Magnitude = (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude;
    u37.SavedDistance = Magnitude;
    LocalPlayer.CameraMinZoomDistance = Magnitude;
    LocalPlayer.CameraMaxZoomDistance = Magnitude;
    local v38 = TweenService:Create(LocalPlayer, TweenInfo.new(WeatherStaffConfig.ZOOM_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        CameraMinZoomDistance = WeatherStaffConfig.ZOOM_DISTANCE,
        CameraMaxZoomDistance = WeatherStaffConfig.ZOOM_DISTANCE
    });
    u37.ZoomTween = v38;
    v38:Play();
    task.delay(WeatherStaffConfig.FLASH_DELAY, function() -- Line: 403
        -- upvalues: u18 (ref), u37 (copy), playStaffSound2D (ref), Flash (ref), WeatherStaffConfig (ref), restoreZoom (ref)
        if u18[u37.Caster] ~= u37 then
            return;
        end;

        playStaffSound2D("WeatherStaffFlash");
        Flash({
            Transparency = 0,
            FadeInTime = WeatherStaffConfig.FLASH_FADE_IN,
            HoldTime = WeatherStaffConfig.FLASH_HOLD,
            FadeOutTime = WeatherStaffConfig.FLASH_FADE_OUT,
            Color = Color3.new(1, 1, 1)
        });
        task.delay(WeatherStaffConfig.FLASH_FADE_IN, function() -- Line: 414
            -- upvalues: u18 (ref), u37 (ref), restoreZoom (ref)
            if u18[u37.Caster] ~= u37 then
                return;
            end;

            restoreZoom(u37);
        end);
    end);
end;

local function findVfxAsset(p39) -- Line: 427
    -- upvalues: WeatherStaffConfig (copy)
    local v40 = p39:FindFirstChild(WeatherStaffConfig.VFX_ASSET_NAME);

    if v40 and v40:IsA("Model") then
        return v40;
    end;

    for _, child in p39:GetChildren() do
        if child:IsA("Model") and string.find(string.lower(child.Name), "weatherstaff", 1, true) then
            return child;
        end;
    end;

    return nil;
end;

local function spawnOrb(u41, u42) -- Line: 440
    -- upvalues: dprint (copy), Networking (copy), ReplicatedStorage (copy), findVfxAsset (copy), WeatherStaffConfig (copy), EmitDuration (copy), Debris (copy), u18 (copy), finishCast (copy), startCameraSequence (copy)
    if u42.Struck then
        dprint("spawnOrb: already struck, ignoring duplicate trigger");

        return;
    end;

    u42.Struck = true;
    dprint("spawnOrb: striking for", u41.Name);

    if u42.IsLocal then
        Networking.WeatherStaff.TriggerWeather:Fire();
    end;

    local ActiveHandle = u42.ActiveHandle;

    if not (ActiveHandle and (ActiveHandle:IsA("BasePart") and ActiveHandle:IsDescendantOf(workspace))) then
        dprint("spawnOrb: ABORT no active staff handle (consumed/unequipped?)");

        return;
    end;

    local GearAssets = ReplicatedStorage.Assets:FindFirstChild("GearAssets");

    if not GearAssets then
        dprint("spawnOrb: ABORT ReplicatedStorage.Assets.GearAssets not found");

        return;
    end;

    local v43 = findVfxAsset(GearAssets);

    if not v43 then
        local v44 = {};

        for _, child in GearAssets:GetChildren() do
            local v45 = `{child.Name} ({child.ClassName})`;
            table.insert(v44, v45);
        end;

        dprint((`spawnOrb: ABORT VFX model not found. Looked for "{WeatherStaffConfig.VFX_ASSET_NAME}". GearAssets children: {table.concat(v44, ", ")}`));

        return;
    end;

    dprint((`spawnOrb: using VFX asset "{v43.Name}"`));
    local v46 = v43:Clone();
    local v47 = v46.PrimaryPart or v46:FindFirstChildWhichIsA("BasePart", true);

    if not v47 then
        dprint("spawnOrb: ABORT cloned asset has no BasePart");
        v46:Destroy();

        return;
    end;

    v46.PrimaryPart = v47;
    local v48 = ActiveHandle:FindFirstChild(WeatherStaffConfig.BOTTOM_ATTACHMENT);
    dprint(`spawnOrb: handle="{ActiveHandle.Name}" attachment="{WeatherStaffConfig.BOTTOM_ATTACHMENT}" found=`, v48 ~= nil);
    local v49;

    if v48 and v48:IsA("Attachment") then
        v49 = v48.WorldPosition;
    else
        v49 = ActiveHandle.Position;
    end;

    v46:PivotTo(CFrame.new(v49) * v46:GetPivot().Rotation);

    for _, descendant in v46:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
        end;
    end;

    v46.Parent = workspace;
    u42.Orb = v46;
    EmitDuration(v46);
    dprint((`spawnOrb: orb parented to workspace, lifetime={WeatherStaffConfig.ORB_LIFETIME}s`));
    Debris:AddItem(v46, WeatherStaffConfig.ORB_LIFETIME);
    task.delay(WeatherStaffConfig.ORB_LIFETIME, function() -- Line: 516
        -- upvalues: u18 (ref), u41 (copy), u42 (copy), finishCast (ref)
        if u18[u41] == u42 then
            u42.Orb = nil;
            finishCast(u41);
        end;
    end);
    task.delay(WeatherStaffConfig.FLASH_DELAY + WeatherStaffConfig.FLASH_FADE_IN, function() -- Line: 525
        -- upvalues: u18 (ref), u41 (copy), u42 (copy)
        if u18[u41] == u42 then
            local v50 = u42;

            if v50.Dummy and v50.Dummy then
                v50.Dummy:Destroy();
                v50.Dummy = nil;
            end;
        end;
    end);

    if u42.IsLocal then
        startCameraSequence(u42);
    end;
end;

local function bindMarker(u51, u52, p53) -- Line: 539
    -- upvalues: dprint (copy), WeatherStaffConfig (copy), spawnOrb (copy)
    dprint((`bindMarker: listening for "{WeatherStaffConfig.STRIKE_MARKER}" marker`));
    local v54 = p53:GetMarkerReachedSignal(WeatherStaffConfig.STRIKE_MARKER):Connect(function() -- Line: 541
        -- upvalues: dprint (ref), spawnOrb (ref), u51 (copy), u52 (copy)
        dprint("marker reached: Strike");
        spawnOrb(u51, u52);
    end);
    table.insert(u52.Connections, v54);
end;

local function scheduleFallback(u55, u56) -- Line: 548
    -- upvalues: WeatherStaffConfig (copy), u18 (copy), dprint (copy), spawnOrb (copy)
    task.delay(WeatherStaffConfig.STRIKE_FALLBACK, function() -- Line: 549
        -- upvalues: u18 (ref), u55 (copy), u56 (copy), dprint (ref), WeatherStaffConfig (ref), spawnOrb (ref)
        if u18[u55] ~= u56 then
            dprint("fallback: cast no longer active, skipping");

            return;
        end;

        dprint((`fallback ({WeatherStaffConfig.STRIKE_FALLBACK}s) firing strike`));
        spawnOrb(u55, u56);
    end);
end;

local function setupEquipLock(u57, u58, u59) -- Line: 562
    -- upvalues: u18 (copy), LocalPlayer (copy)
    if not u59 then
        return;
    end;

    u58.StaffTool = u59;
    u58.UnequipConn = u59.Unequipped:Connect(function() -- Line: 565
        -- upvalues: u18 (ref), u57 (copy), u58 (copy), LocalPlayer (ref), u59 (copy)
        if u18[u57] ~= u58 then
            return;
        end;

        task.defer(function() -- Line: 567
            -- upvalues: u18 (ref), u57 (ref), u58 (ref), LocalPlayer (ref), u59 (ref)
            if u18[u57] ~= u58 then
                return;
            end;

            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character and u59:IsDescendantOf(LocalPlayer) then
                Character:EquipTool(u59);
            end;
        end);
    end);
end;

local function playCast(u60, p61) -- Line: 581
    -- upvalues: dprint (copy), u18 (copy), hardCleanup (copy), LocalPlayer (copy), findStaffTool (copy), u8 (ref), WeatherStaffConfig (copy), buildDummy (copy), hideRealStaff (copy), playStaffSound2D (copy), bindMarker (copy), spawnOrb (copy), playStaffSoundAt (copy), finishCast (copy)
    dprint("playCast received for", typeof(u60) == "Instance" and u60.Name or tostring(u60), "usedLast=", p61);

    if typeof(u60) ~= "Instance" or not u60:IsA("Player") then
        dprint("playCast: ABORT invalid caster");

        return;
    end;

    if u18[u60] then
        hardCleanup(u60);
    end;

    local Character = u60.Character;

    if not Character then
        dprint("playCast: ABORT no character");

        return;
    end;

    local u62 = Character:FindFirstChildOfClass("Humanoid");

    if u62 then
        u62 = u62:FindFirstChildOfClass("Animator");
    end;

    if not u62 then
        dprint("playCast: ABORT no animator");

        return;
    end;

    dprint((`playCast: isLocal={u60 == LocalPlayer}`));
    local u63 = {
        Struck = false,
        ZoomRestored = false,
        Caster = u60,
        IsLocal = u60 == LocalPlayer,
        Connections = {}
    };
    u18[u60] = u63;
    local u64 = findStaffTool(Character);
    local v65 = nil;
    local v66;

    if u64 then
        v66 = u64.PrimaryPart or u64:FindFirstChild("Handle");

        if v66 then
            if not v66:IsA("BasePart") then
                v66 = v65;
            end;
        else
            v66 = v65;
        end;
    else
        v66 = v65;
    end;

    if u63.IsLocal then
        u8 = workspace:GetServerTimeNow() + WeatherStaffConfig.COOLDOWN;

        if u64 and u8 then
            local v67 = u8 - workspace:GetServerTimeNow();

            if v67 > 0 then
                u64:SetAttribute("CooldownEnd", os.clock() + v67);
            end;
        end;
    end;

    if p61 and (u64 and v66) then
        local v68, v69 = buildDummy(u64, v66, Character);

        if v68 and v69 then
            u63.Dummy = v68;
            u63.ActiveHandle = v69;
            hideRealStaff(u63, u64);
            dprint("playCast: built hand-held dummy (last staff in stack)");
        else
            u63.ActiveHandle = v66;
            dprint("playCast: dummy build failed, falling back to real handle");
        end;
    else
        u63.ActiveHandle = v66;

        if u63.IsLocal and (u64 and u64) then
            u63.StaffTool = u64;
            u63.UnequipConn = u64.Unequipped:Connect(function() -- Line: 565
                -- upvalues: u18 (ref), u60 (copy), u63 (copy), LocalPlayer (ref), u64 (copy)
                if u18[u60] ~= u63 then
                    return;
                end;

                task.defer(function() -- Line: 567
                    -- upvalues: u18 (ref), u60 (ref), u63 (ref), LocalPlayer (ref), u64 (ref)
                    if u18[u60] ~= u63 then
                        return;
                    end;

                    local Character2 = LocalPlayer.Character;

                    if Character2 then
                        Character2 = Character2:FindFirstChildOfClass("Humanoid");
                    end;

                    if Character2 and u64:IsDescendantOf(LocalPlayer) then
                        Character2:EquipTool(u64);
                    end;
                end);
            end);
        end;
    end;

    if u63.IsLocal then
        local Animation = Instance.new("Animation");
        Animation.AnimationId = WeatherStaffConfig.ANIM_ID;
        local success, result = pcall(function() -- Line: 659
            -- upvalues: u62 (copy), Animation (copy)
            return u62:LoadAnimation(Animation);
        end);

        if not (success and result) then
            dprint("playCast: ABORT LoadAnimation failed:", result);

            return;
        end;

        result.Priority = Enum.AnimationPriority.Action;
        result.Looped = false;
        u63.Track = result;
        result:Play();
        dprint((`playCast: track playing (length={result.Length})`));
        playStaffSound2D("WeatherStaffActivate");
        local v71 = result.Stopped:Connect(function() -- Line: 677
            -- upvalues: u18 (ref), u60 (copy), u63 (copy)
            if u18[u60] ~= u63 then
                return;
            end;

            local v70 = u63;

            if v70.UnequipConn then
                v70.UnequipConn:Disconnect();
                v70.UnequipConn = nil;
            end;

            v70.StaffTool = nil;
        end);
        table.insert(u63.Connections, v71);
        bindMarker(u60, u63, result);
        task.delay(WeatherStaffConfig.STRIKE_FALLBACK, function() -- Line: 549
            -- upvalues: u18 (ref), u60 (copy), u63 (copy), dprint (ref), WeatherStaffConfig (ref), spawnOrb (ref)
            if u18[u60] ~= u63 then
                dprint("fallback: cast no longer active, skipping");

                return;
            end;

            dprint((`fallback ({WeatherStaffConfig.STRIKE_FALLBACK}s) firing strike`));
            spawnOrb(u60, u63);
        end);
    else
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            HumanoidRootPart = nil;
        end;

        playStaffSoundAt("WeatherStaffActivate", HumanoidRootPart);
        local v73 = u62.AnimationPlayed:Connect(function(p72) -- Line: 694
            -- upvalues: u63 (copy), dprint (ref), bindMarker (ref), u60 (copy)
            if u63.Struck then
                return;
            end;

            local Animation = p72.Animation;

            if not Animation then
                return;
            end;

            if not string.find(Animation.AnimationId, "106056373730791", 1, true) then
                return;
            end;

            dprint("remote viewer: matched replicated cast track");
            bindMarker(u60, u63, p72);
        end);
        table.insert(u63.Connections, v73);
        task.delay(WeatherStaffConfig.STRIKE_FALLBACK, function() -- Line: 549
            -- upvalues: u18 (ref), u60 (copy), u63 (copy), dprint (ref), WeatherStaffConfig (ref), spawnOrb (ref)
            if u18[u60] ~= u63 then
                dprint("fallback: cast no longer active, skipping");

                return;
            end;

            dprint((`fallback ({WeatherStaffConfig.STRIKE_FALLBACK}s) firing strike`));
            spawnOrb(u60, u63);
        end);
    end;

    task.delay(12, function() -- Line: 707
        -- upvalues: u18 (ref), u60 (copy), u63 (copy), finishCast (ref)
        if u18[u60] == u63 then
            finishCast(u60);
        end;
    end);
end;

function v1.Init(p74) -- Line: 717
end;

function v1.Start(p75) -- Line: 719
    -- upvalues: LocalPlayer (copy), refreshContainer (copy), applyToTool (copy), hardCleanup (copy), refreshAll (copy), Networking (copy), playCast (copy), u8 (ref), Players (copy)
    local v76 = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 10);

    if v76 then
        refreshContainer(v76);
        v76.ChildAdded:Connect(function(p77) -- Line: 124
            -- upvalues: applyToTool (ref)
            if p77:IsA("Tool") then
                task.defer(applyToTool, p77);
            end;
        end);
    end;

    if LocalPlayer.Character then
        local Character = LocalPlayer.Character;
        refreshContainer(Character);
        Character.ChildAdded:Connect(function(p78) -- Line: 124
            -- upvalues: applyToTool (ref)
            if p78:IsA("Tool") then
                task.defer(applyToTool, p78);
            end;
        end);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p79) -- Line: 728
        -- upvalues: hardCleanup (ref), LocalPlayer (ref), refreshContainer (ref), applyToTool (ref)
        hardCleanup(LocalPlayer);
        refreshContainer(p79);
        p79.ChildAdded:Connect(function(p80) -- Line: 124
            -- upvalues: applyToTool (ref)
            if p80:IsA("Tool") then
                task.defer(applyToTool, p80);
            end;
        end);
        local v81 = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 10);

        if v81 then
            refreshContainer(v81);
            v81.ChildAdded:Connect(function(p82) -- Line: 124
                -- upvalues: applyToTool (ref)
                if p82:IsA("Tool") then
                    task.defer(applyToTool, p82);
                end;
            end);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("LoadingScreenActive"):Connect(refreshAll);
    Networking.WeatherStaff.PlayCast.OnClientEvent:Connect(playCast);
    Networking.Gear.CooldownsReset.OnClientEvent:Connect(function() -- Line: 746
        -- upvalues: u8 (ref)
        u8 = nil;
    end);
    Players.PlayerRemoving:Connect(function(p83) -- Line: 750
        -- upvalues: hardCleanup (ref)
        hardCleanup(p83);
    end);
end;

return v1;