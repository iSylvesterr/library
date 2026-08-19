-- Decompiled with Potassium's decompiler.

local u1 = {};
local ContextActionService = game:GetService("ContextActionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local MainGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui");
require(script:WaitForChild("Types"));
local SceneRegistry = require(script:WaitForChild("SceneRegistry"));
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local CurrentCamera = workspace.CurrentCamera;
local u2 = false;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = Janitor.new();
local u8 = false;
local u9 = nil;
local u10 = {};
local u11 = false;
local u12 = nil;
local u13 = nil;
local u14 = 0;
local u15 = nil;
local u16 = {};
local u17 = nil;
local u18 = nil;

local function DebugLog(...) -- Line: 77
end;

local u19 = false;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = 0;
local u24 = 1;
local u25 = 0;
local u26 = nil;
local u27 = false;
local u28 = false;

local function hideMenuFrames() -- Line: 102
    -- upvalues: MenuState (copy), u2 (ref), MenuSceneController (copy)
    MenuState.EnterCaseScene();
    local v29 = MenuState.GetMenuFrame();

    if not v29 then
        return;
    end;

    u2 = MenuSceneController.IsActive();

    if u2 then
        MenuSceneController.HideMenuScene(true, true);
        MenuSceneController.SetMusicVolumeMultiplier(0.5, 0.5);
    end;

    MenuState.SetBlurEnabled(false);
    v29.BackgroundTransparency = 1;
    local Pattern = v29:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = false;
    end;

    local Top = v29:FindFirstChild("Top");

    if Top then
        Top.Visible = false;
    end;

    local Store = v29:FindFirstChild("Store");

    if Store then
        Store.Visible = true;
    end;

    for _, child in v29:GetChildren() do
        if child:IsA("Frame") and (child.Name ~= "Top" and (child.Name ~= "Store" and child.Name ~= "OpenCase")) then
            child.Visible = false;
        end;
    end;
end;

local function hideViewmodel(p30) -- Line: 153
    -- upvalues: u10 (ref)
    for _, descendant in p30:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Transparency < 1 then
                descendant:SetAttribute("_CaseScenePrevTransparency", descendant.Transparency);
                descendant.Transparency = 1;
            end;
        elseif descendant:IsA("SurfaceGui") then
            if descendant.Enabled then
                descendant:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", true);
                descendant.Enabled = false;
            end;
        elseif descendant:IsA("Texture") and descendant.Transparency < 1 then
            descendant:SetAttribute("_CaseScenePrevTransparency", descendant.Transparency);
            descendant.Transparency = 1;
        end;
    end;

    table.insert(u10, p30);
end;

local function hideViewmodels() -- Line: 178
    -- upvalues: u10 (ref), u5 (ref), CurrentCamera (copy), hideViewmodel (copy)
    u10 = {};
    local v31 = u5 and u5.AssetFolder or nil;

    for _, child in CurrentCamera:GetChildren() do
        if child:IsA("Model") and child.Name ~= v31 then
            hideViewmodel(child);
        end;
    end;
end;

local function showViewmodels() -- Line: 188
    -- upvalues: u10 (ref)
    for _, v in u10 do
        if v and v.Parent then
            for _, descendant in v:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local v32 = descendant:GetAttribute("_CaseScenePrevTransparency");

                    if v32 ~= nil then
                        descendant.Transparency = v32;
                        descendant:SetAttribute("_CaseScenePrevTransparency", nil);
                    end;
                elseif descendant:IsA("SurfaceGui") then
                    if descendant:GetAttribute("_CaseScenePrevSurfaceGuiEnabled") ~= nil then
                        descendant.Enabled = true;
                        descendant:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", nil);
                    end;
                elseif descendant:IsA("Texture") then
                    local v33 = descendant:GetAttribute("_CaseScenePrevTransparency");

                    if v33 == nil then
                        descendant.Transparency = 0.3;
                    else
                        descendant.Transparency = v33;
                        descendant:SetAttribute("_CaseScenePrevTransparency", nil);
                    end;
                end;
            end;
        end;
    end;

    u10 = {};
end;

local function applyCaseFog(p34) -- Line: 224
    -- upvalues: Lighting (copy)
    local CaseFog = p34:FindFirstChild("CaseFog", true);

    if not (CaseFog and CaseFog:IsA("Atmosphere")) then
        return;
    end;

    for _, child in Lighting:GetChildren() do
        if child:IsA("Atmosphere") then
            child:Destroy();
        end;
    end;

    CaseFog:Clone().Parent = Lighting;
end;

local function restoreLightingAfterSkippedFrameRestore() -- Line: 239
    -- upvalues: MenuSceneController (copy), u2 (ref)
    if workspace:FindFirstChild("Map") then
        MenuSceneController.ApplyMapLighting();

        return;
    end;

    if u2 then
        MenuSceneController.ApplyMenuSceneLighting();
    end;
end;

local function restoreMenuFrames() -- Line: 251
    -- upvalues: MenuState (copy), u2 (ref), MenuSceneController (copy)
    local v35 = MenuState.GetMenuFrame();

    if not (v35 and v35.Visible) then
        u2 = false;
        MenuState.ExitCaseScene();
        MenuSceneController.ApplyMapLighting();

        return;
    end;

    local v36 = MenuState.GetScreenBeforeCaseScene();
    local v37 = u2;
    u2 = false;
    MenuState.ExitCaseScene();

    if v37 then
        MenuSceneController.ShowMenuScene();
        MenuSceneController.SetMusicVolumeMultiplier(1, 0.5);
    else
        MenuSceneController.ApplyMapLighting();
    end;

    local Top = v35:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;

    if v36 then
        local v38 = v35:FindFirstChild(v36);

        if v38 then
            v38.Visible = true;
            local v39;

            if v36 == "Dashboard" then
                v39 = false;
            else
                v39 = v36 ~= "Play";
            end;

            MenuState.SetBlurEnabled(v39);
            v35.BackgroundTransparency = v39 and 0.15 or 1;
            local Pattern = v35:FindFirstChild("Pattern");

            if Pattern then
                Pattern.Visible = not v39;
            end;
        end;
    else
        local Dashboard = v35:FindFirstChild("Dashboard");

        if Dashboard then
            Dashboard.Visible = true;
        end;

        MenuState.SetBlurEnabled(false);
        v35.BackgroundTransparency = 1;
        local Pattern = v35:FindFirstChild("Pattern");

        if Pattern then
            Pattern.Visible = true;
        end;
    end;
end;

local function cleanupCaseModel(p40) -- Line: 324
    local CaseMod = p40:FindFirstChild("CaseMod");

    if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
        CaseMod:Destroy();
    end;
end;

local function setupCaseModel(p41, p42) -- Line: 338
    -- upvalues: ReplicatedStorage (copy)
    local CaseMod = p41:FindFirstChild("CaseMod");

    if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
        CaseMod:Destroy();
    end;

    local CaseModels = ReplicatedStorage.Assets:FindFirstChild("CaseModels");

    if not CaseModels then
        warn("[CaseSceneController]: CaseModels folder not found in ReplicatedStorage.Assets");

        return nil;
    end;

    local v43 = CaseModels:FindFirstChild(p42);

    if not v43 then
        warn("[CaseSceneController]: Case model not found for case: " .. p42);

        return nil;
    end;

    local v44 = v43:Clone();
    v44.Name = "CaseMod";
    v44:SetAttribute("IsDynamicModel", true);
    local CasePivot = p41:FindFirstChild("CasePivot");

    if CasePivot then
        v44:PivotTo(CasePivot.CFrame);
        v44.Parent = p41;

        return v44;
    end;

    warn("[CaseSceneController]: CasePivot not found in CaseScene");
    v44.Parent = p41;

    return v44;
end;

local function getCameraPosition(p45) -- Line: 381
    -- upvalues: u3 (ref)
    if not u3 then
        return nil;
    end;

    local Camera = u3:FindFirstChild("Camera");

    if not Camera then
        return nil;
    end;

    if p45 == "Inspecting" then
        return Camera:FindFirstChild("Inspecting");
    end;

    if p45 == "Unboxing" then
        return Camera:FindFirstChild("Unboxing");
    end;

    return nil;
end;

local function startCameraLerp(p46, p47) -- Line: 402
    -- upvalues: u9 (ref), u3 (ref), CurrentCamera (copy), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref)
    local v48 = u9;
    local v49;

    if u3 then
        local Camera = u3:FindFirstChild("Camera");

        if Camera then
            if v48 == "Inspecting" then
                v49 = Camera:FindFirstChild("Inspecting");
            elseif v48 == "Unboxing" then
                v49 = Camera:FindFirstChild("Unboxing");
            else
                v49 = nil;
            end;
        else
            v49 = nil;
        end;
    else
        v49 = nil;
    end;

    local v50;

    if v49 then
        v50 = v49.CFrame;
    else
        v50 = CurrentCamera.CFrame;
    end;

    u11 = true;
    u12 = v50;
    u13 = p46.CFrame;
    u14 = tick();
    u15 = p47;
end;

local function findAnimationController(p51, p52) -- Line: 416
    local v53;

    if p52.InteractionType == "Drag" then
        v53 = p51:FindFirstChild("Pack");
    else
        v53 = p51:FindFirstChild("CaseMod");
    end;

    if not v53 then
        return nil;
    end;

    local v54 = v53:FindFirstChildOfClass("AnimationController");

    if not v54 then
        return nil;
    end;

    local v55 = v54:FindFirstChildOfClass("Animator");

    if not v55 then
        v55 = Instance.new("Animator");
        v55.Parent = v54;
    end;

    return v55;
end;

local function loadAnimations(p56, p57, p58) -- Line: 443
    -- upvalues: findAnimationController (copy), u17 (ref), u16 (ref)
    local v59 = nil;

    if p57.InteractionType == "Click" and p58 then
        local v60 = p58:FindFirstChildOfClass("AnimationController");

        if v60 then
            v59 = v60:FindFirstChildOfClass("Animator");

            if not v59 then
                v59 = Instance.new("Animator");
                v59.Parent = v60;
            end;
        end;
    end;

    local v61 = v59 or findAnimationController(p56, p57);

    if not v61 then
        warn("[CaseSceneController]: No animator found for scene");

        return;
    end;

    u17 = v61;

    for i, v in p57.Animations do
        if v then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v;
            u16[i] = v61:LoadAnimation(Animation);
            Animation:Destroy();
        end;
    end;
end;

local function setEffectsEnabled(p62, p63) -- Line: 483
    if not p62 then
        return;
    end;

    for _, descendant in p62:GetDescendants() do
        if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p63;
        end;
    end;
end;

local function getCaseMod() -- Line: 494
    -- upvalues: u3 (ref)
    local v64 = u3 and u3:FindFirstChild("CaseMod");

    return v64;
end;

local function enableCaseEffects() -- Line: 498
    -- upvalues: u3 (ref), setEffectsEnabled (copy)
    local v65 = u3 and u3:FindFirstChild("CaseMod");

    if not v65 then
        return;
    end;

    setEffectsEnabled(v65:FindFirstChild("IdleEffect"), true);
    setEffectsEnabled(v65:FindFirstChild("OpeningEffect"), false);
    setEffectsEnabled(v65:FindFirstChild("EffectsPart"), true);
end;

local function disableCaseEffects() -- Line: 509
    -- upvalues: u3 (ref), setEffectsEnabled (copy)
    local v66 = u3 and u3:FindFirstChild("CaseMod");

    if not v66 then
        return;
    end;

    setEffectsEnabled(v66:FindFirstChild("IdleEffect"), false);
    setEffectsEnabled(v66:FindFirstChild("OpeningEffect"), false);
    setEffectsEnabled(v66:FindFirstChild("EffectsPart"), false);
end;

local function enableOpeningEffects() -- Line: 520
    -- upvalues: u3 (ref), setEffectsEnabled (copy)
    local v67 = u3 and u3:FindFirstChild("CaseMod");

    if not v67 then
        return;
    end;

    setEffectsEnabled(v67:FindFirstChild("OpeningEffect"), true);
    setEffectsEnabled(v67:FindFirstChild("IdleEffect"), false);
end;

local function setupKeyframeSounds(p68, p69) -- Line: 530
    -- upvalues: Router (copy), u7 (copy)
    for i, v in p69 do
        u7:Add((p68:GetMarkerReachedSignal(i):Connect(function() -- Line: 532
            -- upvalues: Router (ref), v (copy)
            Router.broadcastRouter("RunStoreSound", v);
        end)));
    end;
end;

local function playInspectAnimations() -- Line: 541
    -- upvalues: u16 (ref), enableCaseEffects (copy), u5 (ref), setupKeyframeSounds (copy), Router (copy), u7 (copy), u3 (ref)
    if not (u16.CaseFall and u16.CloseIdle) then
        return;
    end;

    enableCaseEffects();
    local CaseFall = u16.CaseFall;
    local v70 = u5 and u5.AnimationKeyframeSounds and u5.AnimationKeyframeSounds.CaseFall;

    if v70 then
        setupKeyframeSounds(CaseFall, v70);
    else
        local u71 = u5 and (u5.Sounds and u5.Sounds.Drop) or "Case Fall";
        u7:Add((CaseFall:GetMarkerReachedSignal("Dropped"):Connect(function() -- Line: 562
            -- upvalues: Router (ref), u71 (copy)
            Router.broadcastRouter("RunStoreSound", u71);
        end)));
    end;

    u7:Add((CaseFall:GetMarkerReachedSignal(v70 and v70.Drop and "Drop" or "Dropped"):Connect(function() -- Line: 573
        -- upvalues: u3 (ref)
        local v72 = u3 and u3:FindFirstChild("DropParticle");

        if v72 then
            for _, child in v72:GetChildren() do
                if child:IsA("ParticleEmitter") then
                    local v73 = child:GetAttribute("EmitCount");

                    if typeof(v73) == "number" and v73 > 0 then
                        child:Emit(v73);
                    end;
                end;
            end;
        end;
    end)));
    CaseFall:Play();
    u16.CloseIdle.Looped = true;
    u16.CloseIdle:Play();
end;

local function playOpeningAnimations() -- Line: 597
    -- upvalues: u16 (ref), u5 (ref), setupKeyframeSounds (copy), Router (copy), u3 (ref), setEffectsEnabled (copy)
    if not u16.CaseOpening then
        return;
    end;

    if u16.CloseIdle then
        u16.CloseIdle:Stop();
    end;

    local CaseOpening = u16.CaseOpening;
    local v74 = u5 and u5.AnimationKeyframeSounds and u5.AnimationKeyframeSounds.CaseOpening;

    if v74 then
        setupKeyframeSounds(CaseOpening, v74);
    else
        Router.broadcastRouter("RunStoreSound", u5 and (u5.Sounds and u5.Sounds.Opening) or "Case Opening");
    end;

    local v75 = u3 and u3:FindFirstChild("CaseMod");

    if v75 then
        setEffectsEnabled(v75:FindFirstChild("OpeningEffect"), true);
        setEffectsEnabled(v75:FindFirstChild("IdleEffect"), false);
    end;

    CaseOpening:Play();

    if u16.OpenIdle then
        u16.OpenIdle.Looped = true;
        u16.OpenIdle:Play();
    end;
end;

local function stopAllAnimations() -- Line: 635
    -- upvalues: u16 (ref), u18 (ref)
    for _, v in u16 do
        if v.IsPlaying then
            v:Stop();
        end;
    end;

    if u18 then
        u18:Stop();
        u18:Destroy();
        u18 = nil;
    end;
end;

local function finishCharmOpeningAndStartRoll() -- Line: 652
    -- upvalues: DebugLog (copy), u18 (ref), u22 (ref), u26 (ref), MainGui (copy), u16 (ref), u20 (ref), u5 (ref), Router (copy)
    DebugLog("finishCharmOpeningAndStartRoll called");

    if u18 then
        u18:Stop();
    end;

    u22 = nil;

    if u26 then
        u26.Enabled = false;
    end;

    local CameraPerspective = MainGui:FindFirstChild("CameraPerspective");

    if CameraPerspective then
        CameraPerspective.Interactable = true;
    end;

    local PackOpening = u16.PackOpening;
    DebugLog("  packOpeningTrack:", PackOpening and "exists" or "nil");
    DebugLog("  CharmDragCallback:", u20 and "exists" or "nil");

    if not PackOpening then
        DebugLog("  No packOpeningTrack, calling callback directly");

        if u20 then
            local v76 = u20;
            u20 = nil;
            DebugLog("  Calling CharmDragCallback");
            v76();
        end;

        return;
    end;

    Router.broadcastRouter("RunStoreSound", not (u5 and (u5.Sounds and u5.Sounds.DragLoop)) and "Charm Drag Loop" or u5.Sounds.DragLoop);

    if not PackOpening.IsPlaying then
        PackOpening:Play();
    end;

    PackOpening:AdjustSpeed(1);
    PackOpening.Looped = false;
    local v77 = math.max(0, PackOpening.Length - PackOpening.TimePosition - 0.1);
    task.delay(v77, function() -- Line: 701
        -- upvalues: PackOpening (copy), u20 (ref)
        if not PackOpening.IsPlaying then
            return;
        end;

        PackOpening:AdjustSpeed(0);
        PackOpening.TimePosition = PackOpening.Length * 0.99;

        if u20 then
            local v78 = u20;
            u20 = nil;
            v78();
        end;
    end);
end;

local function updateCharmAnimationProgress(p79, p80) -- Line: 719
    -- upvalues: u16 (ref), u25 (ref), u19 (ref), finishCharmOpeningAndStartRoll (copy), u18 (ref), u22 (ref), u23 (ref)
    local PackOpening = u16.PackOpening;

    if not PackOpening then
        return;
    end;

    local v81 = math.clamp(p79, 0, 1);
    local v82;

    if u25 > 0 then
        v82 = u25;
    else
        v82 = PackOpening.Length;
    end;

    if not PackOpening.IsPlaying then
        PackOpening:Play();
        PackOpening:AdjustSpeed(0);
    end;

    PackOpening.TimePosition = v82 * v81;

    if v81 >= 1 then
        u19 = false;
        finishCharmOpeningAndStartRoll();
    end;

    if u18 and p80 then
        local v83 = not u22 and 0 or (p80 - u22).Magnitude;
        u22 = p80;

        if v83 > 0.001 then
            u23 = tick();

            if not u18.IsPlaying then
                u18:Play();
            end;

            u18.PlaybackSpeed = math.clamp(v83 * 20, 0, 0.7) + 0.8;
        end;
    end;
end;

local function setupCharmDragDetector(p84) -- Line: 766
    -- upvalues: u3 (ref), ContextActionService (copy), u27 (ref), u20 (ref), u19 (ref), u21 (ref), u24 (ref), u16 (ref), u5 (ref), u25 (ref), MainGui (copy), u26 (ref), u7 (copy), u28 (ref), RunServiceController (copy), u22 (ref), u23 (ref), u18 (ref), ReplicatedStorage (copy), finishCharmOpeningAndStartRoll (copy), updateCharmAnimationProgress (copy), UserInputService (copy), u8 (ref), u9 (ref), Router (copy)
    if not u3 then
        return;
    end;

    local Pack = u3:FindFirstChild("Pack");

    if not Pack then
        warn("[CaseSceneController]: Pack not found in CharmScene");

        return;
    end;

    local Drag = Pack:FindFirstChild("Drag");

    if not Drag then
        warn("[CaseSceneController]: Drag part not found in Pack");

        return;
    end;

    local u85 = Drag:FindFirstChildOfClass("DragDetector");

    if not u85 then
        warn("[CaseSceneController]: DragDetector not found on Drag part");

        return;
    end;

    ContextActionService:UnbindAction("Fire");
    ContextActionService:UnbindAction("Secondary Fire");
    u27 = true;
    u20 = p84;
    u19 = false;
    u21 = Drag.Position;
    u24 = u85.MaxDragTranslation.Magnitude;

    if u24 <= 0 then
        u24 = 1;
    end;

    local PackOpening = u16.PackOpening;

    if PackOpening then
        local u86 = not (u5 and (u5.DragSettings and u5.DragSettings.EndKeyframe)) and "DragEndPoint" or u5.DragSettings.EndKeyframe;
        local success, result = pcall(function() -- Line: 817
            -- upvalues: PackOpening (copy), u86 (ref)
            return PackOpening:GetTimeOfKeyframe(u86);
        end);

        if success and result then
            u25 = result;
        else
            u25 = PackOpening.Length;
            warn("[CaseSceneController]: " .. u86 .. " keyframe not found, using full animation length");
        end;
    end;

    u85.Enabled = true;
    local CameraPerspective = MainGui:FindFirstChild("CameraPerspective");

    if CameraPerspective then
        CameraPerspective.Interactable = false;
    end;

    local v87 = Drag:FindFirstChildOfClass("SurfaceGui");

    if v87 then
        v87.Enabled = true;
        u26 = v87;
        local v88 = v87:FindFirstChildOfClass("Frame");
        local u89 = v88 and v88:FindFirstChildOfClass("ImageLabel");

        if u89 then
            u7:Add(v88.MouseEnter:Connect(function() -- Line: 849
                -- upvalues: u28 (ref), u89 (copy)
                u28 = true;
                u89.ImageTransparency = 1;
            end), "Disconnect", "CharmImageHoverEnter");
            u7:Add(v88.MouseLeave:Connect(function() -- Line: 859
                -- upvalues: u28 (ref), u89 (copy)
                u28 = false;
                u89.ImageTransparency = 0;
            end), "Disconnect", "CharmImageHoverLeave");
            local u90 = 0;
            u7:Add(RunServiceController.BindToRenderStep("CaseSceneController.CharmImageBreathing", function(p91) -- Line: 871
                -- upvalues: u28 (ref), u90 (ref), u89 (copy)
                if u28 then
                    return;
                end;

                u90 = u90 + p91 * 2;
                u89.ImageTransparency = (math.sin(u90) + 1) / 2 * 0.2;
            end), "Disconnect", "CharmImageBreathing");
        end;
    end;

    u7:Add(u85.DragStart:Connect(function() -- Line: 892
        -- upvalues: u19 (ref), u22 (ref), Drag (copy), u23 (ref), u18 (ref), u5 (ref), ReplicatedStorage (ref), Pack (copy), u7 (ref)
        u19 = true;
        u22 = Drag.Position;
        u23 = tick();

        if not u18 then
            local v92 = not (u5 and (u5.Sounds and u5.Sounds.DragStart)) and "Charm Drag Start" or u5.Sounds.DragStart;
            local v93 = require(ReplicatedStorage.Database.Audio.Store)[v92];

            if v93 and (v93.Identifiers and v93.Identifiers[1]) then
                local Sound = Instance.new("Sound");
                Sound.Name = "DragProgress";
                Sound.SoundId = "rbxassetid://" .. v93.Identifiers[1];
                Sound.Volume = v93.Properties.Volume or 1;
                Sound.Looped = true;
                Sound.PlaybackSpeed = 0.8;
                Sound.Parent = Pack;
                u18 = Sound;
                u7:Add(Sound, "Destroy");
            end;
        end;
    end), "Disconnect", "CharmDragStart");
    u7:Add(RunServiceController.BindToHeartbeat("CaseSceneController.CharmDragSoundCheck", function() -- Line: 925
        -- upvalues: u19 (ref), u18 (ref), u23 (ref)
        if u19 and (u18 and (u18.IsPlaying and tick() - u23 > 0.05)) then
            u18:Stop();
        end;
    end), "Disconnect", "CharmDragSoundCheck");
    u7:Add(u85.DragContinue:Connect(function() -- Line: 939
        -- upvalues: u19 (ref), u21 (ref), Drag (copy), u24 (ref), u5 (ref), u85 (copy), finishCharmOpeningAndStartRoll (ref), updateCharmAnimationProgress (ref)
        if not (u19 and u21) then
            return;
        end;

        local v94 = math.clamp((Drag.Position - u21).Magnitude / u24, 0, 1);

        if (not (u5 and (u5.DragSettings and u5.DragSettings.Threshold)) and 0.5 or u5.DragSettings.Threshold) > v94 then
            updateCharmAnimationProgress(v94, Drag.Position);

            return;
        end;

        u19 = false;
        u85.Enabled = false;

        if u21 then
            Drag.Position = u21;
        end;

        finishCharmOpeningAndStartRoll();
    end), "Disconnect", "CharmDragContinue");
    u7:Add(u85.DragEnd:Connect(function() -- Line: 974
        -- upvalues: u19 (ref), u21 (ref), u18 (ref), Drag (copy), u24 (ref), u5 (ref), u85 (copy), finishCharmOpeningAndStartRoll (ref), u16 (ref), u22 (ref)
        if not (u19 and u21) then
            return;
        end;

        u19 = false;

        if u18 then
            u18:Stop();
        end;

        local v95 = math.clamp((Drag.Position - u21).Magnitude / u24, 0, 1);
        Drag.Position = u21;

        if (not (u5 and (u5.DragSettings and u5.DragSettings.Threshold)) and 0.8 or math.max(u5.DragSettings.Threshold, 0.8)) <= v95 then
            u85.Enabled = false;
            finishCharmOpeningAndStartRoll();

            return;
        end;

        local PackOpening2 = u16.PackOpening;

        if PackOpening2 then
            PackOpening2.TimePosition = 0;
        end;

        u22 = nil;
    end), "Disconnect", "CharmDragEnd");
    u7:Add(UserInputService.InputBegan:Connect(function(p96, p97) -- Line: 1013
        -- upvalues: u8 (ref), u9 (ref), u85 (copy), u19 (ref), u21 (ref), Drag (copy), u18 (ref), u5 (ref), Router (ref), finishCharmOpeningAndStartRoll (ref)
        if not u8 or u9 ~= "Unboxing" then
            return;
        end;

        local v98 = p96.UserInputType == Enum.UserInputType.Gamepad1;
        local v99 = p96.UserInputType == Enum.UserInputType.Keyboard;

        if v99 and p97 then
            return;
        end;

        if v98 then
            v98 = p96.KeyCode == Enum.KeyCode.ButtonX and true or p96.KeyCode == Enum.KeyCode.ButtonA;
        end;

        if v99 then
            v99 = p96.KeyCode == Enum.KeyCode.Return and true or p96.KeyCode == Enum.KeyCode.Space;
        end;

        if v98 or v99 then
            u85.Enabled = false;

            if u19 then
                u19 = false;

                if u21 then
                    Drag.Position = u21;
                end;
            end;

            if u18 then
                u18:Stop();
            end;

            Router.broadcastRouter("RunStoreSound", not (u5 and (u5.Sounds and u5.Sounds.DragStart)) and "Charm Drag Start" or u5.Sounds.DragStart);
            finishCharmOpeningAndStartRoll();
        end;
    end), "Disconnect", "CharmControllerSkip");
end;

local function cleanupCharmDrag() -- Line: 1064
    -- upvalues: u27 (ref), Router (copy), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u28 (ref)
    if u27 then
        Router.broadcastRouter("RebindKeybinds");
        u27 = false;
    end;

    u19 = false;
    u20 = nil;
    u21 = nil;
    u22 = nil;
    u23 = 0;
    u24 = 1;
    u25 = 0;
    u26 = nil;
    u28 = false;
end;

function u1.ShowCaseScene(p100, p101) -- Line: 1085
    -- upvalues: DebugLog (copy), u8 (ref), SceneRegistry (copy), u4 (ref), u5 (ref), u6 (ref), u3 (ref), u9 (ref), CurrentCamera (copy), hideMenuFrames (copy), u2 (ref), MenuSceneController (copy), applyCaseFog (copy), hideViewmodels (copy), u7 (copy), hideViewmodel (copy), setupCaseModel (copy), loadAnimations (copy), playInspectAnimations (copy), CameraController (copy), RunServiceController (copy), u11 (ref), u12 (ref), u13 (ref), u14 (ref), TweenService (copy), u15 (ref), disableCaseEffects (copy), u27 (ref), Router (copy), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u28 (ref), stopAllAnimations (copy), u16 (ref), u17 (ref)
    DebugLog("ShowCaseScene called");
    DebugLog("  caseType:", p100 or "nil");
    DebugLog("  caseName:", p101 or "nil");
    DebugLog("  IsCaseSceneActive:", u8);

    if u8 then
        DebugLog("  BLOCKED: Scene already active");

        return;
    end;

    local v102 = SceneRegistry.GetSceneForCaseType(p100 or "Case");
    DebugLog("  sceneName:", v102);
    local u103 = SceneRegistry.GetConfig(v102);

    if not u103 then
        warn("[CaseSceneController]: No config found for scene: " .. v102);
        DebugLog("  BLOCKED: No config found");

        return;
    end;

    DebugLog("  config.AssetFolder:", u103.AssetFolder);
    DebugLog("  config.InteractionType:", u103.InteractionType);
    u4 = v102;
    u5 = u103;
    u6 = p101;
    local v104 = workspace:FindFirstChild(u103.AssetFolder);

    if not v104 then
        warn("[CaseSceneController]: Scene not found in workspace: " .. u103.AssetFolder);
        u4 = nil;
        u5 = nil;
        u6 = nil;

        return;
    end;

    u3 = v104;
    local v105 = u103.InteractionType == "Drag" and v104:FindFirstChild("Pack");

    if v105 then
        local Drag = v105:FindFirstChild("Drag");
        local v106 = Drag and Drag:FindFirstChildOfClass("SurfaceGui");

        if v106 then
            v106.Enabled = false;
        end;
    end;

    u9 = "Inspecting";
    local v107;

    if u3 then
        local Camera = u3:FindFirstChild("Camera");

        if Camera then
            v107 = Camera:FindFirstChild("Inspecting");
        else
            v107 = nil;
        end;
    else
        v107 = nil;
    end;

    if not v107 then
        warn("[CaseSceneController]: Scene missing Camera.Inspecting");
        u3 = nil;
        u4 = nil;
        u5 = nil;
        u9 = nil;

        return;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.CFrame = v107.CFrame;
    CurrentCamera.Focus = v107.CFrame;
    hideMenuFrames();

    if not u2 then
        MenuSceneController.ApplyMenuSceneLighting();
    end;

    applyCaseFog(v104);
    hideViewmodels();
    u7:Add(CurrentCamera.ChildAdded:Connect(function(p108) -- Line: 1165
        -- upvalues: u103 (copy), hideViewmodel (ref)
        if p108:IsA("Model") and p108.Name ~= u103.AssetFolder then
            hideViewmodel(p108);
        end;
    end), "Disconnect", "ViewmodelListener");
    local v109;

    if p101 and u103.InteractionType == "Click" then
        v109 = setupCaseModel(v104, p101);
    else
        v109 = nil;
    end;

    loadAnimations(v104, u103, v109);

    if u103.InteractionType == "Click" then
        playInspectAnimations();
    end;

    CameraController.setFOVLock("CaseScene", true, 50);
    CameraController.setForceLockOverride("CaseScene", true);
    RunServiceController.BindToRenderStep("CaseSceneController.CameraUpdate", Enum.RenderPriority.Camera.Value + 10, function() -- Line: 1195
        -- upvalues: u3 (ref), CurrentCamera (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), TweenService (ref), u15 (ref), u9 (ref)
        if u3 then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable;

            if u11 and (u12 and u13) then
                local v110 = (tick() - u14) / 0.8;
                local v111 = math.min(v110, 1);
                CurrentCamera.CFrame = u12:Lerp(u13, (TweenService:GetValue(v111, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)));
                CurrentCamera.Focus = CurrentCamera.CFrame;

                if v111 >= 1 then
                    u11 = false;
                    CurrentCamera.CFrame = u13;

                    if u15 then
                        local v112 = u15;
                        u15 = nil;
                        v112();
                    end;

                    u12 = nil;
                    u13 = nil;
                end;
            else
                local v113 = u9;
                local v114;

                if u3 then
                    local Camera = u3:FindFirstChild("Camera");

                    if Camera then
                        if v113 == "Inspecting" then
                            v114 = Camera:FindFirstChild("Inspecting");
                        elseif v113 == "Unboxing" then
                            v114 = Camera:FindFirstChild("Unboxing");
                        else
                            v114 = nil;
                        end;
                    else
                        v114 = nil;
                    end;
                else
                    v114 = nil;
                end;

                if v114 then
                    CurrentCamera.CFrame = v114.CFrame;
                    CurrentCamera.Focus = v114.CFrame;
                end;
            end;
        end;
    end);
    u7:Add(function() -- Line: 1239
        -- upvalues: RunServiceController (ref)
        RunServiceController.UnbindFromRenderStep("CaseSceneController.CameraUpdate");
    end, true, "CameraUpdate");
    u7:Add(function() -- Line: 1244
        -- upvalues: DebugLog (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), u15 (ref), disableCaseEffects (ref), u27 (ref), Router (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u28 (ref), u3 (ref), stopAllAnimations (ref), u16 (ref), u17 (ref)
        DebugLog("CaseSceneCleanup running");
        u9 = nil;
        u11 = false;
        u12 = nil;
        u13 = nil;
        u15 = nil;
        disableCaseEffects();

        if u27 then
            Router.broadcastRouter("RebindKeybinds");
            u27 = false;
        end;

        u19 = false;
        u20 = nil;
        u21 = nil;
        u22 = nil;
        u23 = 0;
        u24 = 1;
        u25 = 0;
        u26 = nil;
        u28 = false;

        if u3 then
            local CaseMod = u3:FindFirstChild("CaseMod");

            if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
                CaseMod:Destroy();
            end;
        end;

        stopAllAnimations();
        u16 = {};
        u17 = nil;
        DebugLog("CaseSceneCleanup complete");
    end, true, "CaseSceneCleanup");
    u8 = true;
    DebugLog("ShowCaseScene complete, IsCaseSceneActive = true");
end;

function u1.TransitionToUnboxing(u115) -- Line: 1272
    -- upvalues: DebugLog (copy), u8 (ref), u3 (ref), u5 (ref), u9 (ref), playOpeningAnimations (copy), CurrentCamera (copy), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), setupCharmDragDetector (copy)
    DebugLog("TransitionToUnboxing called");
    DebugLog("  IsCaseSceneActive:", u8);
    DebugLog("  CurrentScene:", u3 and "exists" or "nil");
    DebugLog("  CurrentSceneConfig:", u5 and "exists" or "nil");
    DebugLog("  CurrentCaseSceneState:", u9 or "nil");
    DebugLog("  callback:", u115 and "provided" or "nil");

    if not (u8 and (u3 and u5)) then
        DebugLog("  BLOCKED: Scene not active or missing config");

        return;
    end;

    if u9 == "Unboxing" then
        DebugLog("  BLOCKED: Already in Unboxing state");

        return;
    end;

    local v116;

    if u3 then
        local Camera = u3:FindFirstChild("Camera");

        if Camera then
            v116 = Camera:FindFirstChild("Unboxing");
        else
            v116 = nil;
        end;
    else
        v116 = nil;
    end;

    if not v116 then
        warn("[CaseSceneController]: Scene missing Camera.Unboxing");
        DebugLog("  BLOCKED: Missing Camera.Unboxing");

        return;
    end;

    DebugLog("  InteractionType:", u5.InteractionType);

    if u5.InteractionType == "Click" then
        DebugLog("  Playing opening animations and starting camera lerp");
        playOpeningAnimations();
        local v117 = u9;
        local v118;

        if u3 then
            local Camera = u3:FindFirstChild("Camera");

            if Camera then
                if v117 == "Inspecting" then
                    v118 = Camera:FindFirstChild("Inspecting");
                elseif v117 == "Unboxing" then
                    v118 = Camera:FindFirstChild("Unboxing");
                else
                    v118 = nil;
                end;
            else
                v118 = nil;
            end;
        else
            v118 = nil;
        end;

        local v119;

        if v118 then
            v119 = v118.CFrame;
        else
            v119 = CurrentCamera.CFrame;
        end;

        u11 = true;
        u12 = v119;
        u13 = v116.CFrame;
        u14 = tick();
        u15 = u115;
    else
        DebugLog("  Starting camera lerp, will setup drag detector after");

        local function v120() -- Line: 1305
            -- upvalues: DebugLog (ref), setupCharmDragDetector (ref), u115 (copy)
            DebugLog("  Camera lerp complete, setting up drag detector");
            setupCharmDragDetector(u115);
        end;

        local v121 = u9;
        local v122;

        if u3 then
            local Camera = u3:FindFirstChild("Camera");

            if Camera then
                if v121 == "Inspecting" then
                    v122 = Camera:FindFirstChild("Inspecting");
                elseif v121 == "Unboxing" then
                    v122 = Camera:FindFirstChild("Unboxing");
                else
                    v122 = nil;
                end;
            else
                v122 = nil;
            end;
        else
            v122 = nil;
        end;

        local v123;

        if v122 then
            v123 = v122.CFrame;
        else
            v123 = CurrentCamera.CFrame;
        end;

        u11 = true;
        u12 = v123;
        u13 = v116.CFrame;
        u14 = tick();
        u15 = v120;
    end;

    u9 = "Unboxing";
    DebugLog("  TransitionToUnboxing complete, CurrentCaseSceneState = Unboxing");
end;

function u1.TransitionToInspecting(p124) -- Line: 1317
    -- upvalues: u8 (ref), u3 (ref), u9 (ref), CurrentCamera (copy), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref)
    if not (u8 and u3) then
        return;
    end;

    if u9 == "Inspecting" then
        return;
    end;

    local v125;

    if u3 then
        local Camera = u3:FindFirstChild("Camera");

        if Camera then
            v125 = Camera:FindFirstChild("Inspecting");
        else
            v125 = nil;
        end;
    else
        v125 = nil;
    end;

    if not v125 then
        warn("[CaseSceneController]: Scene missing Camera.Inspecting");

        return;
    end;

    local v126 = u9;
    local v127;

    if u3 then
        local Camera = u3:FindFirstChild("Camera");

        if Camera then
            if v126 == "Inspecting" then
                v127 = Camera:FindFirstChild("Inspecting");
            elseif v126 == "Unboxing" then
                v127 = Camera:FindFirstChild("Unboxing");
            else
                v127 = nil;
            end;
        else
            v127 = nil;
        end;
    else
        v127 = nil;
    end;

    local v128;

    if v127 then
        v128 = v127.CFrame;
    else
        v128 = CurrentCamera.CFrame;
    end;

    u11 = true;
    u12 = v128;
    u13 = v125.CFrame;
    u14 = tick();
    u15 = p124;
    u9 = "Inspecting";
end;

function u1.HideCaseScene(p129) -- Line: 1342
    -- upvalues: DebugLog (copy), u8 (ref), u7 (copy), CurrentCamera (copy), CameraController (copy), Constants (copy), ReplicatedStorage (copy), restoreMenuFrames (copy), MenuSceneController (copy), u2 (ref), MenuState (copy), showViewmodels (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u9 (ref)
    DebugLog("HideCaseScene called");
    DebugLog("  IsCaseSceneActive:", u8);
    DebugLog("  skipFrameRestore:", p129 or false);

    if not u8 then
        DebugLog("  BLOCKED: Scene not active");

        return;
    end;

    DebugLog("  Running CaseSceneJanitor:Cleanup()");
    u7:Cleanup();
    CurrentCamera.CameraType = Enum.CameraType.Custom;
    CameraController.setFOVLock("CaseScene", false);
    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    local v130 = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance();

    if v130 then
        v130:UpdateScopeState();
    end;

    CameraController.setForceLockOverride("CaseScene", false);

    if p129 then
        if workspace:FindFirstChild("Map") then
            MenuSceneController.ApplyMapLighting();
        elseif u2 then
            MenuSceneController.ApplyMenuSceneLighting();
        end;

        MenuState.ExitCaseScene();
        u2 = false;
    else
        restoreMenuFrames();
    end;

    showViewmodels();
    u3 = nil;
    u4 = nil;
    u5 = nil;
    u6 = nil;
    u8 = false;
    u9 = nil;
    DebugLog("HideCaseScene complete, IsCaseSceneActive = false");
end;

function u1.IsActive() -- Line: 1389
    -- upvalues: u8 (ref)
    return u8;
end;

function u1.GetCurrentState() -- Line: 1395
    -- upvalues: u9 (ref)
    return u9;
end;

function u1.GetSceneName() -- Line: 1401
    -- upvalues: u4 (ref)
    return u4;
end;

function u1.GetSceneConfig() -- Line: 1407
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.ApplyCaseSceneLighting() -- Line: 1413
    -- upvalues: u8 (ref), u3 (ref), MenuSceneController (copy), applyCaseFog (copy)
    if not (u8 and u3) then
        return;
    end;

    MenuSceneController.ApplyMenuSceneLighting();
    applyCaseFog(u3);
end;

function u1.WaitForOpeningAnimation() -- Line: 1426
    -- upvalues: u16 (ref)
    local CaseOpening = u16.CaseOpening;

    if not CaseOpening then
        return;
    end;

    if CaseOpening.IsPlaying then
        CaseOpening.Stopped:Wait();
    end;
end;

function u1.Initialize() -- Line: 1441
    -- upvalues: ReplicatedStorage (copy), SceneRegistry (copy), UserInputService (copy), u8 (ref), u1 (copy), Router (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if not Assets then
        warn("[CaseSceneController]: Assets folder not found in ReplicatedStorage");

        return;
    end;

    local function setupScene(p131) -- Line: 1449
        -- upvalues: Assets (copy)
        local v132 = Assets:FindFirstChild(p131);

        if not v132 then
            return;
        end;

        local v133 = nil;

        for _, child in v132:GetChildren() do
            if child:IsA("Model") then
                v133 = child;
                break;
            end;
        end;

        if not v133 then
            warn("[CaseSceneController]: No model found in Assets." .. p131);

            return;
        end;

        local v134 = v133:Clone();
        v134.Name = p131;
        v134.Parent = workspace;
    end;

    for _, v in SceneRegistry.GetAllSceneNames() do
        local v135 = SceneRegistry.GetConfig(v);

        if v135 then
            setupScene(v135.AssetFolder);
        end;
    end;

    UserInputService.InputBegan:Connect(function(p136, p137) -- Line: 1482
        -- upvalues: u8 (ref), u1 (ref)
        if p137 then
            return;
        end;

        if p136.KeyCode == Enum.KeyCode.Escape and u8 then
            u1.HideCaseScene();
        end;
    end);
    Router.observerRouter("CaseSceneShow", function(p138, p139) -- Line: 1493
        -- upvalues: u1 (ref)
        u1.ShowCaseScene(p138, p139);
    end);
    Router.observerRouter("CaseSceneUnboxing", function(p140) -- Line: 1497
        -- upvalues: u1 (ref)
        u1.TransitionToUnboxing(p140);
    end);
    Router.observerRouter("CaseSceneClose", function() -- Line: 1501
        -- upvalues: u1 (ref)
        u1.HideCaseScene();
    end);
    Router.observerRouter("CaseSceneCloseForGameEnd", function() -- Line: 1505
        -- upvalues: u1 (ref)
        u1.HideCaseScene(true);
    end);
end;

function u1.Start() -- Line: 1510
end;

Router.observerRouter("IsCaseSceneRolling", function() -- Line: 1518
    -- upvalues: u1 (copy)
    local v141 = u1.IsActive() and u1.GetCurrentState() == "Unboxing";

    return v141;
end);

return u1;