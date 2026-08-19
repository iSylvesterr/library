-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local CameraModule = UtilsSystem.CameraModule;
local CollectionService = UtilsSystem.CollectionService;
local HumanModule = UtilsSystem.HumanModule;
local InsMgr = UtilsSystem.InsMgr;
local Log = UtilsSystem.Log;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local SoundModule = UtilsSystem.SoundModule;
local UIMgr = UtilsSystem.UIMgr;
local VisibleMgr = UtilsSystem.VisibleMgr;
local u1 = {};
local u2 = { "Animation", "双锤矮人", "当前手持", "矮人的战斧", "核心2", "Meshes", "岩浆", "FX_WeaponCore", "TrailA" };
local u3 = false;
local u4 = 0;
local u5 = 0;
local u6 = 0;
local u7 = {};
local u8 = false;
local u9 = nil;
local u10 = nil;
local u11 = false;
local u12 = false;
local u13 = nil;
local u14 = false;
local u15 = false;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;

local function _pivotRootTo(p21, p22) -- Line: 133
    if p21:IsA("Model") then
        p21:PivotTo(p22);

        return;
    end;

    if p21:IsA("BasePart") then
        p21.CFrame = p22;

        return;
    end;

    local v23 = {};

    for _, child in ipairs(p21:GetChildren()) do
        if child:IsA("Model") or child:IsA("BasePart") then
            table.insert(v23, child);
        end;
    end;

    if #v23 == 0 then
        return;
    end;

    local v24 = v23[1];
    local v25;

    if v24:IsA("Model") then
        v25 = v24:GetPivot();
    else
        v25 = v24.CFrame;
    end;

    local v26 = p22 * v25:Inverse();

    for _, v in ipairs(v23) do
        if v:IsA("Model") then
            v:PivotTo(v26 * v:GetPivot());
        elseif v:IsA("BasePart") then
            v.CFrame = v26 * v.CFrame;
        end;
    end;
end;

local function _tryGetLocatorCFrame() -- Line: 169
    -- upvalues: Workspace (copy)
    local v27 = Workspace:FindFirstChild("场景");

    if not v27 then
        return nil;
    end;

    local v28 = v27:FindFirstChild("矮人王动画定位");

    if v28 and v28:IsA("CFrameValue") then
        return v28.Value;
    end;

    return nil;
end;

local function _getLocatorCFrame() -- Line: 185
    -- upvalues: Workspace (copy), Log (copy)
    local v29 = Workspace:FindFirstChild("场景");
    local v30;

    if v29 then
        local v31 = v29:FindFirstChild("矮人王动画定位");

        if v31 and v31:IsA("CFrameValue") then
            v30 = v31.Value;
        else
            v30 = nil;
        end;
    else
        v30 = nil;
    end;

    if v30 then
        return v30;
    end;

    if Workspace:FindFirstChild("场景") then
        Log.warn("[DwarfKingAppearPresentation] 缺少定位 CFrameValue: Workspace/场景/矮人王动画定位");

        return nil;
    end;

    Log.warn("[DwarfKingAppearPresentation] 缺少 Workspace/场景");

    return nil;
end;

local function _ensureAnimFolder(p32) -- Line: 204
    if p32.Name ~= "矮人王出场动画" then
        p32.Name = "矮人王出场动画";
    end;

    if p32:FindFirstChild("Animation") then
        return;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "Animation";
    local v33 = {};

    for _, child in ipairs(p32:GetChildren()) do
        table.insert(v33, child);
    end;

    Folder.Parent = p32;

    for _, v in ipairs(v33) do
        v.Parent = Folder;
    end;
end;

local function _findSourceRoot() -- Line: 229
    -- upvalues: Workspace (copy), ReplicatedStorage (copy)
    local v34 = Workspace:FindFirstChild("场景");
    local v35 = v34 and (v34:FindFirstChild("矮人王出场动画") or v34:FindFirstChild("矮人王出场动画", true));

    if v35 then
        return v35;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("MoonAni");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("矮人王出场动画");
    end;

    return Assets or nil;
end;

local function _preparePlayRoot() -- Line: 252
    -- upvalues: Workspace (copy), _ensureAnimFolder (copy), _findSourceRoot (copy)
    local v36 = Workspace:FindFirstChild("矮人王出场动画");

    if v36 and v36.Parent == Workspace then
        _ensureAnimFolder(v36);

        return v36;
    end;

    local v37 = _findSourceRoot();

    if not v37 then
        return nil;
    end;

    local v38 = v37:Clone();
    v38.Name = "矮人王出场动画";
    v38.Parent = Workspace;
    _ensureAnimFolder(v38);

    return v38;
end;

local function _destroySceneSourceRoots() -- Line: 275
    -- upvalues: Workspace (copy)
    local v39 = Workspace:FindFirstChild("场景");

    if not v39 then
        return;
    end;

    local v40 = v39:FindFirstChild("矮人王出场动画") or v39:FindFirstChild("矮人王出场动画", true);

    while v40 do
        v40:Destroy();
        v40 = v39:FindFirstChild("矮人王出场动画") or v39:FindFirstChild("矮人王出场动画", true);
    end;
end;

local function _hideDungeonDoorSurfaceGuis() -- Line: 291
    -- upvalues: u7 (copy), CollectionService (copy), u8 (ref)
    local function hideOnDoor(p41) -- Line: 292
        -- upvalues: u7 (ref)
        if not p41:IsA("Model") then
            return;
        end;

        for _, descendant in p41:GetDescendants() do
            if descendant:IsA("SurfaceGui") then
                if u7[descendant] == nil then
                    u7[descendant] = descendant.Enabled;
                end;

                descendant.Enabled = false;
            end;
        end;
    end;

    for _, v in CollectionService:GetTagged("DungeonFrontDoor") do
        hideOnDoor(v);
    end;

    for _, v in CollectionService:GetTagged("DungeonBackDoor") do
        hideOnDoor(v);
    end;

    u8 = true;
end;

local function _restoreDungeonDoorSurfaceGuis() -- Line: 319
    -- upvalues: u8 (ref), u7 (copy)
    if not u8 then
        return;
    end;

    for i, v in pairs(u7) do
        if i.Parent then
            i.Enabled = v;
        end;
    end;

    table.clear(u7);
    u8 = false;
end;

local function _hideBlackGuiBg() -- Line: 336
    -- upvalues: LocalPlayer (copy), u9 (ref)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return;
    end;

    local BlackGui = PlayerGui:FindFirstChild("BlackGui");

    if not BlackGui then
        return;
    end;

    local BG = BlackGui:FindFirstChild("BG");

    if not (BG and BG:IsA("GuiObject")) then
        return;
    end;

    if u9 == nil then
        u9 = BG.Visible;
    end;

    BG.Visible = false;
end;

local function _restoreBlackGuiBg() -- Line: 359
    -- upvalues: u9 (ref), LocalPlayer (copy)
    if u9 == nil then
        return;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("BlackGui");
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("BG");
    end;

    if PlayerGui and PlayerGui:IsA("GuiObject") then
        PlayerGui.Visible = u9;
    end;

    u9 = nil;
end;

local function _hideOtherPlayers() -- Line: 376
    -- upvalues: u10 (ref), VisibleMgr (copy)
    if u10 ~= nil then
        return;
    end;

    if type(VisibleMgr.HideOtherPlayersLocal) == "function" then
        u10 = VisibleMgr.HideOtherPlayersLocal();
    end;
end;

local function _restoreOtherPlayers() -- Line: 389
    -- upvalues: u10 (ref), VisibleMgr (copy)
    if u10 == nil then
        return;
    end;

    if type(VisibleMgr.RestoreOtherPlayersLocal) == "function" then
        VisibleMgr.RestoreOtherPlayersLocal(u10);
    end;

    u10 = nil;
end;

local function _findVfxFolder(p42) -- Line: 404
    return p42:FindFirstChild("VFX") or p42:FindFirstChild("VFX", true);
end;

local function _findAxeModel(p43) -- Line: 413
    local v44 = p43:FindFirstChild("Animation") or p43:FindFirstChild("Animation", true);

    return v44 and (v44:FindFirstChild("矮人的战斧1") or v44:FindFirstChild("矮人的战斧1", true)) or p43:FindFirstChild("矮人的战斧1", true);
end;

local function _anchorVfx(p45) -- Line: 429
    -- upvalues: VisibleMgr (copy), Log (copy), _findAxeModel (copy)
    local v46 = p45:FindFirstChild("VFX") or p45:FindFirstChild("VFX", true);

    if v46 then
        VisibleMgr.AnchoredAll(v46);
    else
        Log.warn("[DwarfKingAppearPresentation] 未找到 VFX 文件夹:", p45:GetFullName());
    end;

    local v47 = _findAxeModel(p45);

    if v47 then
        VisibleMgr.AnchoredAll(v47);

        return;
    end;

    Log.warn("[DwarfKingAppearPresentation] 未找到战斧:", "Animation/矮人的战斧1", p45:GetFullName());
end;

local function _unanchorAxe(p48) -- Line: 454
    -- upvalues: _findAxeModel (copy), VisibleMgr (copy)
    local v49 = _findAxeModel(p48);

    if not v49 then
        return;
    end;

    VisibleMgr.UnAnchoredAll(v49);
end;

local function _disableRootCollisionTouchQuery(p50) -- Line: 467
    -- upvalues: VisibleMgr (copy)
    VisibleMgr.UnCollideAll(p50);
    VisibleMgr.UnTouchAll(p50);
    VisibleMgr.UnQueryAll(p50);
end;

local function _preloadAtLocator() -- Line: 477
    -- upvalues: Workspace (copy), _preparePlayRoot (copy), _pivotRootTo (copy), _anchorVfx (copy), _destroySceneSourceRoots (copy)
    local v51 = Workspace:FindFirstChild("场景");
    local v52;

    if v51 then
        local v53 = v51:FindFirstChild("矮人王动画定位");

        if v53 and v53:IsA("CFrameValue") then
            v52 = v53.Value;
        else
            v52 = nil;
        end;
    else
        v52 = nil;
    end;

    if not v52 then
        return false;
    end;

    local v54 = _preparePlayRoot();

    if not v54 then
        return false;
    end;

    _pivotRootTo(v54, v52);
    _anchorVfx(v54);
    _destroySceneSourceRoots();

    return true;
end;

local function _destroyMoonSaveClone() -- Line: 496
    -- upvalues: u13 (ref)
    if u13 and u13.Parent then
        u13:Destroy();
    end;

    u13 = nil;
end;

local function _playCgSound() -- Line: 507
    -- upvalues: u3 (ref), SoundModule (copy)
    if u3 then
        return;
    end;

    if type(SoundModule.PlaySoundLocal) ~= "function" then
        return;
    end;

    u3 = true;
    pcall(function() -- Line: 515
        -- upvalues: SoundModule (ref)
        SoundModule:PlaySoundLocal({
            SoundName = "音效-矮人王CG",
            SoundTag = "DwarfKingAppearCG",
            Is2D = true
        });
    end);
end;

local function _stopCgSound() -- Line: 528
    -- upvalues: u4 (ref), u3 (ref), SoundModule (copy)
    u4 = u4 + 1;
    u3 = false;

    if type(SoundModule.StopSoundLocal) ~= "function" then
        return;
    end;

    pcall(function() -- Line: 534
        -- upvalues: SoundModule (ref)
        SoundModule:StopSoundLocal({
            SoundTag = "DwarfKingAppearCG",
            SoundName = "音效-矮人王CG",
            FadeTime = 0.15,
            DestroyAfter = true
        });
    end);
end;

local function _destroyCgSoundTemplate() -- Line: 548
    -- upvalues: SoundService (copy)
    local EFFECT = SoundService:FindFirstChild("EFFECT");

    if EFFECT then
        EFFECT = EFFECT:FindFirstChild("音效-矮人王CG");
    end;

    if EFFECT then
        pcall(function() -- Line: 552
            -- upvalues: EFFECT (copy)
            EFFECT:Destroy();
        end);
    end;
end;

local function _hideAllUi() -- Line: 562
    -- upvalues: u15 (ref), UIMgr (copy)
    if u15 then
        return;
    end;

    if type(UIMgr.HideAllBut) == "function" then
        UIMgr.HideAllBut("");
        u15 = true;
    end;
end;

local function _recoverAllUi() -- Line: 576
    -- upvalues: u15 (ref), UIMgr (copy)
    if not u15 then
        return;
    end;

    if type(UIMgr.RecoverHideUI) == "function" then
        UIMgr.RecoverHideUI();
    end;

    u15 = false;
end;

local function _markCutscenePopOpen() -- Line: 591
    -- upvalues: InsMgr (copy), LocalPlayer (copy), UIMgr (copy)
    InsMgr.GetIns("是否弹窗打开中", "BoolValue", LocalPlayer).Value = true;

    if type(UIMgr.UpdateWorldUi) == "function" then
        UIMgr.UpdateWorldUi();
    end;
end;

local function _disableBlackGuiScreen() -- Line: 603
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return;
    end;

    local BlackGui = PlayerGui:FindFirstChild("BlackGui");

    if BlackGui and BlackGui:IsA("ScreenGui") then
        BlackGui.Enabled = false;
    end;
end;

local function _refreshPopShowAfterCutscene() -- Line: 618
    -- upvalues: LocalPlayer (copy), InsMgr (copy), Workspace (copy), CameraModule (copy), UIMgr (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        local BlackGui = PlayerGui:FindFirstChild("BlackGui");

        if BlackGui and BlackGui:IsA("ScreenGui") then
            BlackGui.Enabled = false;
        end;
    end;

    InsMgr.GetIns("是否弹窗打开中", "BoolValue", LocalPlayer).Value = false;
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        if type(CameraModule.FocusPlayer) == "function" then
            pcall(function() -- Line: 628
                -- upvalues: CameraModule (ref)
                CameraModule.FocusPlayer();
            end);
        end;

        if CurrentCamera.CameraType == Enum.CameraType.Scriptable then
            CurrentCamera.CameraType = Enum.CameraType.Custom;
        end;
    end;

    if type(UIMgr.RefreshPopShowState) == "function" then
        UIMgr.RefreshPopShowState();
    elseif type(UIMgr.UpdateWorldUi) == "function" then
        UIMgr.UpdateWorldUi();
    end;

    if type(UIMgr.UpdateWorldUi) == "function" then
        task.defer(function() -- Line: 645
            -- upvalues: UIMgr (ref)
            UIMgr.UpdateWorldUi();
        end);
    end;
end;

local function _fadeBlackScreen(p55, u56, u57) -- Line: 658
    -- upvalues: u5 (ref), UIMgr (copy)
    local function finish() -- Line: 659
        -- upvalues: u56 (copy), u5 (ref), u57 (copy)
        if u56 ~= u5 then
            return;
        end;

        if u57 then
            u57();
        end;
    end;

    if type(UIMgr.PlayBlackScreenFade) == "function" then
        UIMgr.PlayBlackScreenFade(p55, 0.5, finish);

        return;
    end;

    if u56 ~= u5 then
        return;
    end;

    if u57 then
        u57();
    end;
end;

local function _cancelBlackScreen() -- Line: 678
    -- upvalues: UIMgr (copy)
    if type(UIMgr.CancelBlackScreenFade) == "function" then
        UIMgr.CancelBlackScreenFade(true);
    end;
end;

local function _anchorLocalPlayer() -- Line: 688
    -- upvalues: u16 (ref), HumanModule (copy), LocalPlayer (copy), u17 (ref)
    if u16 ~= nil then
        return;
    end;

    local v58 = HumanModule.GetCharacter(LocalPlayer);

    if not v58 then
        return;
    end;

    local v59 = HumanModule.GetHumanoidRootPart(v58);

    if not v59 then
        return;
    end;

    u16 = v59.Anchored;
    u17 = v59;
    v59.Anchored = true;
end;

local function _tryGetPlayerLocatorCFrame() -- Line: 709
    -- upvalues: Workspace (copy)
    local v60 = Workspace:FindFirstChild("场景");

    if not v60 then
        return nil;
    end;

    local v61 = v60:FindFirstChild("矮人王动画玩家定位");

    if v61 and v61:IsA("CFrameValue") then
        return v61.Value;
    end;

    return nil;
end;

local function _placeAndAnchorLocalPlayer() -- Line: 725
    -- upvalues: u16 (ref), HumanModule (copy), LocalPlayer (copy), u17 (ref), Workspace (copy), Log (copy)
    if u16 == nil then
        local v62 = HumanModule.GetCharacter(LocalPlayer);
        local v63 = v62 and HumanModule.GetHumanoidRootPart(v62);

        if v63 then
            u16 = v63.Anchored;
            u17 = v63;
            v63.Anchored = true;
        end;
    end;

    local v64 = Workspace:FindFirstChild("场景");
    local v65;

    if v64 then
        local v66 = v64:FindFirstChild("矮人王动画玩家定位");

        if v66 and v66:IsA("CFrameValue") then
            v65 = v66.Value;
        else
            v65 = nil;
        end;
    else
        v65 = nil;
    end;

    local v67 = HumanModule.GetCharacter(LocalPlayer);

    if not v67 then
        Log.warn("[DwarfKingAppearPresentation] 本地角色不存在，跳过玩家摆位");

        return;
    end;

    if not v65 then
        Log.warn("[DwarfKingAppearPresentation] 缺少玩家定位 CFrameValue: Workspace/场景/矮人王动画玩家定位");

        return;
    end;

    local v68 = v67:GetPivot().Position.Y - v65.Position.Y;
    v67:PivotTo(v65 + Vector3.new(0, v68, 0));
end;

local function _findByPath(p69, p70) -- Line: 752
    for _, v in ipairs(p70) do
        if not p69 then
            return nil;
        end;

        p69 = p69:FindFirstChild(v);
    end;

    return p69;
end;

local function _findWeaponTrailA(p71) -- Line: 768
    -- upvalues: _findByPath (copy), u2 (copy)
    return _findByPath(p71, u2) or p71:FindFirstChild("TrailA", true);
end;

local function _setWeaponCoreTrailsEnabled(p72, u73, p74) -- Line: 783
    -- upvalues: _findByPath (copy), u2 (copy), Log (copy)
    local v75 = _findByPath(p72, u2) or p72:FindFirstChild("TrailA", true);

    if not v75 then
        if not p74 then
            Log.warn("[DwarfKingAppearPresentation] 未找到 TrailA:", table.concat(u2, "/"));
        end;

        return;
    end;

    local function apply(u76) -- Line: 791
        -- upvalues: u73 (copy)
        if u76:IsA("Trail") or (u76:IsA("Beam") or (u76:IsA("ParticleEmitter") or u76:IsA("Light"))) then
            pcall(function() -- Line: 793
                -- upvalues: u76 (copy), u73 (ref)
                u76.Enabled = u73;
            end);
        end;
    end;

    apply(v75);

    for _, descendant in v75:GetDescendants() do
        apply(descendant);
    end;
end;

local function _scheduleEnableWeaponCoreTrails(u77, u78) -- Line: 810
    -- upvalues: u6 (ref), _setWeaponCoreTrailsEnabled (copy), u5 (ref), u11 (ref)
    u6 = u6 + 1;
    local u79 = u6;
    _setWeaponCoreTrailsEnabled(u77, false);
    task.delay(6, function() -- Line: 815
        -- upvalues: u79 (copy), u6 (ref), u78 (copy), u5 (ref), u11 (ref), _setWeaponCoreTrailsEnabled (ref), u77 (copy)
        if u79 ~= u6 or (u78 ~= u5 or not u11) then
            return;
        end;

        _setWeaponCoreTrailsEnabled(u77, true, true);
    end);
end;

local function _unanchorLocalPlayer() -- Line: 827
    -- upvalues: u16 (ref), u17 (ref), HumanModule (copy), LocalPlayer (copy)
    if u16 == nil then
        u17 = nil;

        return;
    end;

    local v80 = u17;

    if not (v80 and v80.Parent) then
        v80 = HumanModule.GetCharacter(LocalPlayer);

        if v80 then
            v80 = HumanModule.GetHumanoidRootPart(v80);
        end;
    end;

    if v80 then
        v80.Anchored = u16;
    end;

    u16 = nil;
    u17 = nil;
end;

local function _getRootWorldCFrame(p81) -- Line: 849
    if p81:IsA("Model") then
        return p81:GetPivot();
    end;

    if p81:IsA("BasePart") then
        return p81.CFrame;
    end;

    local v82 = p81:FindFirstChildWhichIsA("Model", true);

    if v82 then
        return v82:GetPivot();
    end;

    local v83 = p81:FindFirstChildWhichIsA("BasePart", true);

    if v83 then
        return v83.CFrame;
    end;

    return nil;
end;

local function _saveEntryCamera() -- Line: 871
    -- upvalues: Workspace (copy), u19 (ref), u18 (ref), u20 (ref)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    if u19 ~= nil then
        return;
    end;

    u18 = CurrentCamera.CameraType;
    u19 = CurrentCamera.CFrame;
    u20 = CurrentCamera.FieldOfView;
end;

local function _snapCameraToRoot(p84) -- Line: 889
    -- upvalues: Workspace (copy), _getRootWorldCFrame (copy), Log (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local v85 = _getRootWorldCFrame(p84);

    if not (CurrentCamera and v85) then
        Log.warn("[DwarfKingAppearPresentation] 无法取得摄像机或主节点 CFrame，跳过瞬移");

        return;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.CFrame = v85;
    CurrentCamera.FieldOfView = 80;
end;

local function _restorePlayerCamera() -- Line: 905
    -- upvalues: Workspace (copy), u19 (ref), u20 (ref), CameraModule (copy), u18 (ref), LocalPlayer (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera and u19 then
        CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        CurrentCamera.CFrame = u19;

        if u20 ~= nil then
            CurrentCamera.FieldOfView = u20;
        end;
    end;

    local v86;

    if type(CameraModule.FocusPlayer) == "function" then
        local v87;
        v86, v87 = pcall(function() -- Line: 918
            -- upvalues: CameraModule (ref)
            return CameraModule.FocusPlayer();
        end);

        if v86 then
            v86 = v87 == true;
        end;
    else
        v86 = false;
    end;

    local CurrentCamera2 = Workspace.CurrentCamera;

    if CurrentCamera2 and (not v86 or CurrentCamera2.CameraType == Enum.CameraType.Scriptable) then
        local v88;

        if u18 and u18 ~= Enum.CameraType.Scriptable then
            v88 = u18;
        else
            v88 = Enum.CameraType.Custom;
        end;

        CurrentCamera2.CameraType = v88;
        local v89 = LocalPlayer and LocalPlayer.Character;

        if v89 then
            v89 = v89:FindFirstChildOfClass("Humanoid");
        end;

        if v89 then
            CurrentCamera2.CameraSubject = v89;
        end;
    end;

    u18 = nil;
    u19 = nil;
    u20 = nil;
end;

local function _getItemType(p90) -- Line: 949
    if type(p90) ~= "table" then
        return "";
    end;

    local v91 = p90.Path or p90.path;

    if type(v91) == "table" then
        local v92 = v91.ItemType or v91.itemType;

        if type(v92) == "string" and v92 ~= "" then
            return v92;
        end;

        local v93 = v91.InstanceTypes or v91.instanceTypes;

        if type(v93) == "table" and #v93 > 0 then
            return tostring(v93[#v93]);
        end;
    end;

    return tostring(p90.ItemType or "");
end;

local function _resolvePathInstance(p94) -- Line: 972
    if type(p94) ~= "table" or #p94 == 0 then
        return nil;
    end;

    local v95 = game;

    for _, v in ipairs(p94) do
        if v == "game" then
            v95 = game;
        else
            if not v95 then
                return nil;
            end;

            v95 = v95:FindFirstChild(v);
        end;
    end;

    return v95;
end;

local function _preferredColorProperty(u96, p97) -- Line: 997
    if u96 then
        if u96:IsA("Decal") or u96:IsA("Texture") then
            return "Color3";
        end;

        local success = pcall(function() -- Line: 1002
            -- upvalues: u96 (copy)
            local _ = u96.Color;
        end);
        local success2 = pcall(function() -- Line: 1005
            -- upvalues: u96 (copy)
            local _ = u96.Color3;
        end);

        if success and not success2 then
            return "Color";
        end;

        if success2 and not success then
            return "Color3";
        end;

        if success then
            return "Color";
        end;
    end;

    return (p97 == "Decal" or p97 == "Texture") and "Color3" or "Color";
end;

local function _preferredColorPropertyForItem(p98) -- Line: 1029
    -- upvalues: _getItemType (copy), _resolvePathInstance (copy), _preferredColorProperty (copy)
    local v99 = _getItemType(p98);
    local v100;

    if type(p98) == "table" then
        v100 = p98.Path or (p98.path or nil);
    else
        v100 = nil;
    end;

    local v101;

    if type(v100) == "table" then
        v101 = v100.InstanceNames or (v100.instanceNames or nil);
    else
        v101 = nil;
    end;

    local v102;

    if type(v101) == "table" then
        v102 = _resolvePathInstance(v101);
    else
        v102 = nil;
    end;

    return _preferredColorProperty(v102, v99);
end;

local function _deepRemapColorPropName(p103, p104, p105, p106) -- Line: 1046
    -- upvalues: _deepRemapColorPropName (copy)
    if type(p103) ~= "table" then
        return 0;
    end;

    if p106[p103] then
        return 0;
    end;

    p106[p103] = true;
    local v107 = 0;

    if p103[p104] ~= nil then
        if p103[p105] == nil then
            p103[p105] = p103[p104];
        end;

        p103[p104] = nil;
        v107 = v107 + 1;
    end;

    local v108 = {
        Property = true,
        property = true,
        Name = true,
        name = true,
        Prop = true,
        Target = true,
        TargetProperty = true,
        Default = true
    };

    for i, v in pairs(p103) do
        if v108[i] and v == p104 then
            p103[i] = p105;
            v107 = v107 + 1;
        elseif type(v) == "table" then
            v107 = v107 + _deepRemapColorPropName(v, p104, p105, p106);
        end;
    end;

    return v107;
end;

local function _remapInvalidColor3PropertyInData(p109) -- Line: 1091
    -- upvalues: _preferredColorPropertyForItem (copy), _deepRemapColorPropName (copy)
    if type(p109) ~= "table" then
        return 0;
    end;

    local Items = p109.Items;

    if type(Items) ~= "table" then
        return 0;
    end;

    local v110 = 0;

    for _, v in ipairs(Items) do
        if type(v) == "table" then
            local v111 = _preferredColorPropertyForItem(v);
            local v112 = v111 == "Color" and "Color3" or "Color";
            local v113 = v.Tracks or v.tracks;

            if type(v113) == "table" then
                v110 = v110 + _deepRemapColorPropName(v113, v112, v111, {});
            end;
        end;
    end;

    return v110;
end;

local function _remapInvalidColor3PropertyInstances(u114, p115) -- Line: 1120
    -- upvalues: _preferredColorPropertyForItem (copy)
    local v116 = 0;
    local v117;

    if type(p115) == "table" then
        v117 = p115.Items or nil;
    else
        v117 = nil;
    end;

    local function findItemIndex(p118) -- Line: 1129
        -- upvalues: u114 (copy)
        local Parent = p118.Parent;

        while Parent and Parent ~= u114 do
            local v119 = tonumber(Parent.Name);

            if v119 then
                return v119;
            end;

            Parent = Parent.Parent;
        end;

        return nil;
    end;

    local v120 = {};

    for _, descendant in ipairs(u114:GetDescendants()) do
        if descendant.Name == "Color3" or descendant.Name == "Color" then
            table.insert(v120, descendant);
        end;
    end;

    for _, v in ipairs(v120) do
        local Parent = v.Parent;
        local v121;

        while true do
            if not Parent or Parent == u114 then
                v121 = nil;
                break;
            end;

            v121 = tonumber(Parent.Name);

            if v121 then
                break;
            end;

            Parent = Parent.Parent;
        end;

        local v122 = (not v117 or (not v121 or type(v117[v121]) ~= "table")) and "Color" or _preferredColorPropertyForItem(v117[v121]);

        if v.Name ~= v122 then
            local Parent2 = v.Parent;

            if Parent2 then
                Parent2 = Parent2:FindFirstChild(v122);
            end;

            if Parent2 and Parent2 ~= v then
                v:Destroy();
            else
                v.Name = v122;
            end;

            v116 = v116 + 1;
        end;
    end;

    return v116;
end;

local function _insertRootAfterWorkspace(p123, p124) -- Line: 1175
    if type(p123) ~= "table" then
        return false;
    end;

    for i, v in ipairs(p123) do
        if v == "Workspace" then
            if p123[i + 1] == "矮人王出场动画" then
                return false;
            end;

            table.insert(p123, i + 1, "矮人王出场动画");

            if type(p124) == "table" then
                table.insert(p124, i + 1, "Model");
            end;

            return true;
        end;
    end;

    return false;
end;

local function _rewritePathsInData(p125, p126) -- Line: 1200
    -- upvalues: _insertRootAfterWorkspace (copy), _rewritePathsInData (copy)
    if type(p125) ~= "table" then
        return 0;
    end;

    local v127 = p126 or {};

    if v127[p125] then
        return 0;
    end;

    v127[p125] = true;
    local v128 = 0;

    if type(p125.InstanceNames) == "table" and _insertRootAfterWorkspace(p125.InstanceNames, p125.InstanceTypes) then
        v128 = v128 + 1;
    end;

    if type(p125.Path) == "table" then
        v128 = v128 + _rewritePathsInData(p125.Path, v127);
    end;

    for _, v in pairs(p125) do
        if type(v) == "table" then
            v128 = v128 + _rewritePathsInData(v, v127);
        end;
    end;

    return v128;
end;

local function _decodeMoonJson(u129) -- Line: 1232
    -- upvalues: HttpService (copy)
    local success, result = pcall(function() -- Line: 1233
        -- upvalues: HttpService (ref), u129 (copy)
        return HttpService:JSONDecode(u129);
    end);

    if not success then
        return nil;
    end;

    if type(result) == "string" then
        local success2, result2 = pcall(function() -- Line: 1240
            -- upvalues: HttpService (ref), result (ref)
            return HttpService:JSONDecode(result);
        end);
        result = result2;

        if not success2 then
            return nil;
        end;
    end;

    return result;
end;

local function _prepareMoonSaveWithRootLayer() -- Line: 1254
    -- upvalues: u13 (ref), ReplicatedStorage (copy), Log (copy), _decodeMoonJson (copy), _rewritePathsInData (copy), _remapInvalidColor3PropertyInData (copy), HttpService (copy), _remapInvalidColor3PropertyInstances (copy)
    if u13 and u13.Parent then
        u13:Destroy();
    end;

    u13 = nil;
    local MoonAnimator2Saves = ReplicatedStorage:FindFirstChild("MoonAnimator2Saves");

    if not MoonAnimator2Saves then
        Log.warn("[DwarfKingAppearPresentation] 缺少 ReplicatedStorage/MoonAnimator2Saves");

        return nil;
    end;

    local v130 = MoonAnimator2Saves:FindFirstChild("矮人王出场");

    if not (v130 and v130:IsA("StringValue")) then
        Log.warn("[DwarfKingAppearPresentation] 缺少 Moon 存档:", "矮人王出场");

        return nil;
    end;

    local u131 = _decodeMoonJson(v130.Value);

    if not u131 then
        Log.warn("[DwarfKingAppearPresentation] Moon JSON 解析失败");

        return nil;
    end;

    _rewritePathsInData(u131);
    _remapInvalidColor3PropertyInData(u131);
    local success, result = pcall(function() -- Line: 1277
        -- upvalues: HttpService (ref), u131 (copy)
        return HttpService:JSONEncode(u131);
    end);

    if not success or type(result) ~= "string" then
        Log.warn("[DwarfKingAppearPresentation] Moon JSON 编码失败");

        return nil;
    end;

    local v132 = v130:Clone();
    v132.Name = "矮人王出场" .. "_play_" .. string.gsub(tostring(os.clock()), "%.", "_");
    v132.Value = result;
    _remapInvalidColor3PropertyInstances(v132, u131);
    v132.Parent = MoonAnimator2Saves;
    u13 = v132;

    return v132.Name;
end;

function u1.CleanupSceneResources() -- Line: 1298
    -- upvalues: u4 (ref), u3 (ref), SoundModule (copy), u13 (ref), Workspace (copy), _destroySceneSourceRoots (copy), ReplicatedStorage (copy), SoundService (copy)
    u4 = u4 + 1;
    u3 = false;

    if type(SoundModule.StopSoundLocal) == "function" then
        pcall(function() -- Line: 534
            -- upvalues: SoundModule (ref)
            SoundModule:StopSoundLocal({
                SoundTag = "DwarfKingAppearCG",
                SoundName = "音效-矮人王CG",
                FadeTime = 0.15,
                DestroyAfter = true
            });
        end);
    end;

    if u13 and u13.Parent then
        u13:Destroy();
    end;

    u13 = nil;
    local v133 = Workspace:FindFirstChild("矮人王出场动画");

    if v133 then
        v133:Destroy();
    end;

    _destroySceneSourceRoots();
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("MoonAni");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("矮人王出场动画");
    end;

    if Assets then
        pcall(function() -- Line: 1314
            -- upvalues: Assets (copy)
            Assets:Destroy();
        end);
    end;

    local EFFECT = SoundService:FindFirstChild("EFFECT");

    if EFFECT then
        EFFECT = EFFECT:FindFirstChild("音效-矮人王CG");
    end;

    if EFFECT then
        pcall(function() -- Line: 552
            -- upvalues: EFFECT (copy)
            EFFECT:Destroy();
        end);
    end;
end;

local function _startMoon(p134, u135) -- Line: 1328
    -- upvalues: _prepareMoonSaveWithRootLayer (copy), Log (copy), AnimationModule (copy), u13 (ref), _findAxeModel (copy), VisibleMgr (copy)
    local u136 = _prepareMoonSaveWithRootLayer();

    if not u136 then
        return false;
    end;

    Log.warn("[DwarfKingAppearPresentation] 开始播放 Moon:", u136);

    if type(AnimationModule.PlayMoonAnimator) ~= "function" then
        Log.warn("[DwarfKingAppearPresentation] AnimationModule.PlayMoonAnimator 不可用");

        if u13 and u13.Parent then
            u13:Destroy();
        end;

        u13 = nil;

        return false;
    end;

    local function u137() -- Line: 1342
        -- upvalues: u13 (ref), u135 (copy)
        if u13 and u13.Parent then
            u13:Destroy();
        end;

        u13 = nil;

        if u135 then
            u135();
        end;
    end;

    local success, result = pcall(function() -- Line: 1352
        -- upvalues: AnimationModule (ref), u136 (copy), u137 (copy)
        return type(AnimationModule.PlayMoonAnimatorWithCameraOffset) == "function" and AnimationModule.PlayMoonAnimatorWithCameraOffset(u136, nil, u137) == true and true or AnimationModule.PlayMoonAnimator(u136, nil, u137);
    end);

    if not success or result ~= true then
        if u13 and u13.Parent then
            u13:Destroy();
        end;

        u13 = nil;

        if success then
            Log.warn("[DwarfKingAppearPresentation] 未能开始播放");
        else
            Log.warn("[DwarfKingAppearPresentation] 播放失败:", result);
        end;

        return false;
    end;

    local v138 = _findAxeModel(p134);

    if v138 then
        VisibleMgr.UnAnchoredAll(v138);
    end;

    VisibleMgr.UnCollideAll(p134);
    VisibleMgr.UnTouchAll(p134);
    VisibleMgr.UnQueryAll(p134);

    return true;
end;

function u1.Stop() -- Line: 1381
    -- upvalues: u5 (ref), u4 (ref), u6 (ref), UIMgr (copy), u11 (ref), u13 (ref), u3 (ref), SoundModule (copy), u16 (ref), u17 (ref), HumanModule (copy), LocalPlayer (copy), u15 (ref), _restoreBlackGuiBg (copy), u10 (ref), VisibleMgr (copy), u8 (ref), u7 (copy), _refreshPopShowAfterCutscene (copy), AnimationModule (copy), _restorePlayerCamera (copy)
    u5 = u5 + 1;
    u4 = u4 + 1;
    u6 = u6 + 1;

    if type(UIMgr.CancelBlackScreenFade) == "function" then
        UIMgr.CancelBlackScreenFade(true);
    end;

    if not (u11 or u13) then
        u4 = u4 + 1;
        u3 = false;

        if type(SoundModule.StopSoundLocal) == "function" then
            pcall(function() -- Line: 534
                -- upvalues: SoundModule (ref)
                SoundModule:StopSoundLocal({
                    SoundTag = "DwarfKingAppearCG",
                    SoundName = "音效-矮人王CG",
                    FadeTime = 0.15,
                    DestroyAfter = true
                });
            end);
        end;

        if u16 == nil then
            u17 = nil;
        else
            local v139 = u17;

            if not (v139 and v139.Parent) then
                v139 = HumanModule.GetCharacter(LocalPlayer);

                if v139 then
                    v139 = HumanModule.GetHumanoidRootPart(v139);
                end;
            end;

            if v139 then
                v139.Anchored = u16;
            end;

            u16 = nil;
            u17 = nil;
        end;

        if u15 then
            if type(UIMgr.RecoverHideUI) == "function" then
                UIMgr.RecoverHideUI();
            end;

            u15 = false;
        end;

        _restoreBlackGuiBg();

        if u10 ~= nil then
            if type(VisibleMgr.RestoreOtherPlayersLocal) == "function" then
                VisibleMgr.RestoreOtherPlayersLocal(u10);
            end;

            u10 = nil;
        end;

        if u8 then
            for i, v in pairs(u7) do
                if i.Parent then
                    i.Enabled = v;
                end;
            end;

            table.clear(u7);
            u8 = false;
        end;

        _refreshPopShowAfterCutscene();

        return;
    end;

    u11 = false;

    if type(AnimationModule.StopActiveMoonAnimator) == "function" then
        pcall(function() -- Line: 1398
            -- upvalues: AnimationModule (ref)
            AnimationModule.StopActiveMoonAnimator();
        end);
    end;

    u4 = u4 + 1;
    u3 = false;

    if type(SoundModule.StopSoundLocal) == "function" then
        pcall(function() -- Line: 534
            -- upvalues: SoundModule (ref)
            SoundModule:StopSoundLocal({
                SoundTag = "DwarfKingAppearCG",
                SoundName = "音效-矮人王CG",
                FadeTime = 0.15,
                DestroyAfter = true
            });
        end);
    end;

    if u13 and u13.Parent then
        u13:Destroy();
    end;

    u13 = nil;
    _restorePlayerCamera();

    if u16 == nil then
        u17 = nil;
    else
        local v140 = u17;

        if not (v140 and v140.Parent) then
            v140 = HumanModule.GetCharacter(LocalPlayer);

            if v140 then
                v140 = HumanModule.GetHumanoidRootPart(v140);
            end;
        end;

        if v140 then
            v140.Anchored = u16;
        end;

        u16 = nil;
        u17 = nil;
    end;

    if u15 then
        if type(UIMgr.RecoverHideUI) == "function" then
            UIMgr.RecoverHideUI();
        end;

        u15 = false;
    end;

    _restoreBlackGuiBg();

    if u10 ~= nil then
        if type(VisibleMgr.RestoreOtherPlayersLocal) == "function" then
            VisibleMgr.RestoreOtherPlayersLocal(u10);
        end;

        u10 = nil;
    end;

    if u8 then
        for i, v in pairs(u7) do
            if i.Parent then
                i.Enabled = v;
            end;
        end;

        table.clear(u7);
        u8 = false;
    end;

    _refreshPopShowAfterCutscene();
end;

function u1.HasPlayed() -- Line: 1417
    -- upvalues: u12 (ref), PlayerData (copy), LocalPlayer (copy)
    if u12 then
        return true;
    end;

    local v141 = PlayerData.GetPlrDataByKey(LocalPlayer, { "Record", "矮人王出场" });

    return (tonumber(v141) or 0) > 0;
end;

function u1.Init() -- Line: 1429
    -- upvalues: u14 (ref), PlayerData (copy), LocalPlayer (copy), u1 (copy), Log (copy), Workspace (copy), _preparePlayRoot (copy), _pivotRootTo (copy), _anchorVfx (copy), _destroySceneSourceRoots (copy)
    if u14 then
        return;
    end;

    u14 = true;
    task.spawn(function() -- Line: 1435
        -- upvalues: PlayerData (ref), LocalPlayer (ref), u1 (ref), Log (ref), Workspace (ref), _preparePlayRoot (ref), _pivotRootTo (ref), _anchorVfx (ref), _destroySceneSourceRoots (ref)
        while PlayerData.GetPlrData(LocalPlayer) == nil do
            task.wait(0.5);
        end;

        if not u1.HasPlayed() then
            while not u1.HasPlayed() do
                local v142 = Workspace:FindFirstChild("场景");
                local v143;

                if v142 then
                    local v144 = v142:FindFirstChild("矮人王动画定位");

                    if v144 and v144:IsA("CFrameValue") then
                        v143 = v144.Value;
                    else
                        v143 = nil;
                    end;
                else
                    v143 = nil;
                end;

                local v145;

                if v143 then
                    local v146 = _preparePlayRoot();

                    if v146 then
                        _pivotRootTo(v146, v143);
                        _anchorVfx(v146);
                        _destroySceneSourceRoots();
                        v145 = true;
                    else
                        v145 = false;
                    end;
                else
                    v145 = false;
                end;

                if v145 then
                    Log.warn("[DwarfKingAppearPresentation] 已预加载矮人王出场动画并摆位");

                    return;
                end;

                task.wait(0.5);
            end;

            return;
        end;

        Log.warn("[DwarfKingAppearPresentation] 已播放过，清理场景资源");
        u1.CleanupSceneResources();
    end);
end;

function u1.Play(u147) -- Line: 1460
    -- upvalues: u1 (copy), Log (copy), u11 (ref), _preparePlayRoot (copy), Workspace (copy), _pivotRootTo (copy), _anchorVfx (copy), u5 (ref), _restoreBlackGuiBg (copy), u10 (ref), VisibleMgr (copy), u8 (ref), u7 (copy), _refreshPopShowAfterCutscene (copy), u4 (ref), u6 (ref), _restorePlayerCamera (copy), u16 (ref), u17 (ref), HumanModule (copy), LocalPlayer (copy), u15 (ref), UIMgr (copy), _fadeBlackScreen (copy), u19 (ref), u18 (ref), u20 (ref), _hideBlackGuiBg (copy), _hideDungeonDoorSurfaceGuis (copy), InsMgr (copy), _placeAndAnchorLocalPlayer (copy), _getRootWorldCFrame (copy), u3 (ref), SoundModule (copy), _startMoon (copy), u12 (ref), NetWork (copy), NetMsg (copy), _setWeaponCoreTrailsEnabled (copy)
    if u1.HasPlayed() then
        Log.warn("[DwarfKingAppearPresentation] SystemRecord 已记录，忽略正常播放");
        u1.CleanupSceneResources();

        return false;
    end;

    if u11 then
        return false;
    end;

    local u148 = _preparePlayRoot();

    if not u148 then
        Log.warn("[DwarfKingAppearPresentation] 缺少播放模型: Workspace/矮人王出场动画 或 场景/矮人王出场动画 或 Assets/MoonAni/矮人王出场动画");

        return false;
    end;

    local v149 = Workspace:FindFirstChild("场景");
    local v150;

    if v149 then
        local v151 = v149:FindFirstChild("矮人王动画定位");

        if v151 and v151:IsA("CFrameValue") then
            v150 = v151.Value;
        else
            v150 = nil;
        end;
    else
        v150 = nil;
    end;

    if not v150 then
        if Workspace:FindFirstChild("场景") then
            Log.warn("[DwarfKingAppearPresentation] 缺少定位 CFrameValue: Workspace/场景/矮人王动画定位");
            v150 = nil;
        else
            Log.warn("[DwarfKingAppearPresentation] 缺少 Workspace/场景");
            v150 = nil;
        end;
    end;

    if not v150 then
        return false;
    end;

    _pivotRootTo(u148, v150);
    _anchorVfx(u148);
    u5 = u5 + 1;
    local u152 = u5;

    local function finishPlay() -- Line: 1496
        -- upvalues: u152 (copy), u5 (ref), u11 (ref), _restoreBlackGuiBg (ref), u10 (ref), VisibleMgr (ref), u8 (ref), u7 (ref), _refreshPopShowAfterCutscene (ref), u147 (copy)
        if u152 ~= u5 then
            return;
        end;

        u11 = false;
        _restoreBlackGuiBg();

        if u10 ~= nil then
            if type(VisibleMgr.RestoreOtherPlayersLocal) == "function" then
                VisibleMgr.RestoreOtherPlayersLocal(u10);
            end;

            u10 = nil;
        end;

        if u8 then
            for i, v in pairs(u7) do
                if i.Parent then
                    i.Enabled = v;
                end;
            end;

            table.clear(u7);
            u8 = false;
        end;

        _refreshPopShowAfterCutscene();

        if u147 then
            u147();
        end;
    end;

    local function wrappedComplete() -- Line: 1510
        -- upvalues: u152 (copy), u5 (ref), u4 (ref), u6 (ref), u1 (ref), _restorePlayerCamera (ref), u16 (ref), u17 (ref), HumanModule (ref), LocalPlayer (ref), u15 (ref), UIMgr (ref), _refreshPopShowAfterCutscene (ref), finishPlay (copy), u11 (ref), _restoreBlackGuiBg (ref), u10 (ref), VisibleMgr (ref), u8 (ref), u7 (ref), u147 (copy), _fadeBlackScreen (ref)
        if u152 ~= u5 then
            return;
        end;

        u4 = u4 + 1;
        u6 = u6 + 1;
        local u153 = u152;

        local function u158() -- Line: 1517
            -- upvalues: u152 (ref), u5 (ref), u1 (ref), _restorePlayerCamera (ref), u16 (ref), u17 (ref), HumanModule (ref), LocalPlayer (ref), u15 (ref), UIMgr (ref), _refreshPopShowAfterCutscene (ref), finishPlay (ref), u11 (ref), _restoreBlackGuiBg (ref), u10 (ref), VisibleMgr (ref), u8 (ref), u7 (ref), u147 (ref)
            if u152 ~= u5 then
                return;
            end;

            u1.CleanupSceneResources();
            _restorePlayerCamera();

            if u16 == nil then
                u17 = nil;
            else
                local v154 = u17;

                if not (v154 and v154.Parent) then
                    v154 = HumanModule.GetCharacter(LocalPlayer);

                    if v154 then
                        v154 = HumanModule.GetHumanoidRootPart(v154);
                    end;
                end;

                if v154 then
                    v154.Anchored = u16;
                end;

                u16 = nil;
                u17 = nil;
            end;

            if u15 then
                if type(UIMgr.RecoverHideUI) == "function" then
                    UIMgr.RecoverHideUI();
                end;

                u15 = false;
            end;

            _refreshPopShowAfterCutscene();
            local u155 = u152;
            local u156 = finishPlay;

            local function v157() -- Line: 659
                -- upvalues: u155 (copy), u5 (ref), u156 (copy)
                if u155 ~= u5 then
                    return;
                end;

                if u156 then
                    u156();
                end;
            end;

            if type(UIMgr.PlayBlackScreenFade) == "function" then
                UIMgr.PlayBlackScreenFade(false, 0.5, v157);
            else
                if u155 ~= u5 then
                    return;
                end;

                if u156 then
                    if u152 ~= u5 then
                        return;
                    end;

                    u11 = false;
                    _restoreBlackGuiBg();

                    if u10 ~= nil then
                        if type(VisibleMgr.RestoreOtherPlayersLocal) == "function" then
                            VisibleMgr.RestoreOtherPlayersLocal(u10);
                        end;

                        u10 = nil;
                    end;

                    if u8 then
                        for i, v in pairs(u7) do
                            if i.Parent then
                                i.Enabled = v;
                            end;
                        end;

                        table.clear(u7);
                        u8 = false;
                    end;

                    _refreshPopShowAfterCutscene();

                    if u147 then
                        u147();
                    end;
                end;
            end;
        end;

        local function v159() -- Line: 659
            -- upvalues: u153 (copy), u5 (ref), u158 (copy)
            if u153 ~= u5 then
                return;
            end;

            if u158 then
                u158();
            end;
        end;

        if type(UIMgr.PlayBlackScreenFade) == "function" then
            UIMgr.PlayBlackScreenFade(true, 0.5, v159);
        else
            if u153 ~= u5 then
                return;
            end;

            if u158 then
                if u152 ~= u5 then
                    return;
                end;

                u1.CleanupSceneResources();
                _restorePlayerCamera();

                if u16 == nil then
                    u17 = nil;
                else
                    local v160 = u17;

                    if not (v160 and v160.Parent) then
                        v160 = HumanModule.GetCharacter(LocalPlayer);

                        if v160 then
                            v160 = HumanModule.GetHumanoidRootPart(v160);
                        end;
                    end;

                    if v160 then
                        v160.Anchored = u16;
                    end;

                    u16 = nil;
                    u17 = nil;
                end;

                if u15 then
                    if type(UIMgr.RecoverHideUI) == "function" then
                        UIMgr.RecoverHideUI();
                    end;

                    u15 = false;
                end;

                _refreshPopShowAfterCutscene();
                _fadeBlackScreen(false, u152, finishPlay);
            end;
        end;
    end;

    u11 = true;

    if type(UIMgr.CancelBlackScreenFade) == "function" then
        UIMgr.CancelBlackScreenFade(true);
    end;

    local function u177() -- Line: 1535
        -- upvalues: u152 (copy), u5 (ref), u11 (ref), Workspace (ref), u19 (ref), u18 (ref), u20 (ref), u15 (ref), UIMgr (ref), _hideBlackGuiBg (ref), u10 (ref), VisibleMgr (ref), _hideDungeonDoorSurfaceGuis (ref), InsMgr (ref), LocalPlayer (ref), _placeAndAnchorLocalPlayer (ref), u148 (copy), _getRootWorldCFrame (ref), Log (ref), u3 (ref), SoundModule (ref), u4 (ref), _startMoon (ref), wrappedComplete (copy), u12 (ref), NetWork (ref), NetMsg (ref), u6 (ref), _setWeaponCoreTrailsEnabled (ref), u1 (ref), _restorePlayerCamera (ref), u16 (ref), u17 (ref), HumanModule (ref), _refreshPopShowAfterCutscene (ref), finishPlay (copy), _restoreBlackGuiBg (ref), u8 (ref), u7 (ref), u147 (copy), _fadeBlackScreen (ref)
        if u152 ~= u5 or not u11 then
            return;
        end;

        local CurrentCamera = Workspace.CurrentCamera;

        if CurrentCamera and u19 == nil then
            u18 = CurrentCamera.CameraType;
            u19 = CurrentCamera.CFrame;
            u20 = CurrentCamera.FieldOfView;
        end;

        if not u15 and type(UIMgr.HideAllBut) == "function" then
            UIMgr.HideAllBut("");
            u15 = true;
        end;

        _hideBlackGuiBg();

        if u10 == nil and type(VisibleMgr.HideOtherPlayersLocal) == "function" then
            u10 = VisibleMgr.HideOtherPlayersLocal();
        end;

        _hideDungeonDoorSurfaceGuis();
        InsMgr.GetIns("是否弹窗打开中", "BoolValue", LocalPlayer).Value = true;

        if type(UIMgr.UpdateWorldUi) == "function" then
            UIMgr.UpdateWorldUi();
        end;

        _placeAndAnchorLocalPlayer();
        local CurrentCamera2 = Workspace.CurrentCamera;
        local v161 = _getRootWorldCFrame(u148);

        if CurrentCamera2 and v161 then
            CurrentCamera2.CameraType = Enum.CameraType.Scriptable;
            CurrentCamera2.CFrame = v161;
            CurrentCamera2.FieldOfView = 80;
        else
            Log.warn("[DwarfKingAppearPresentation] 无法取得摄像机或主节点 CFrame，跳过瞬移");
        end;

        if not u3 and type(SoundModule.PlaySoundLocal) == "function" then
            u3 = true;
            pcall(function() -- Line: 515
                -- upvalues: SoundModule (ref)
                SoundModule:PlaySoundLocal({
                    SoundName = "音效-矮人王CG",
                    SoundTag = "DwarfKingAppearCG",
                    Is2D = true
                });
            end);
        end;

        local u162 = u152;
        local u163 = nil;

        local function v164() -- Line: 659
            -- upvalues: u162 (copy), u5 (ref), u163 (copy)
            if u162 ~= u5 then
                return;
            end;

            if u163 then
                u163();
            end;
        end;

        if type(UIMgr.PlayBlackScreenFade) == "function" then
            UIMgr.PlayBlackScreenFade(false, 0.5, v164);
        else
            local _ = u162 == u5;
        end;

        u4 = u4 + 1;
        local u165 = u4;
        task.delay(0.5, function() -- Line: 1552
            -- upvalues: u165 (copy), u4 (ref), u152 (ref), u5 (ref), u11 (ref), _startMoon (ref), u148 (ref), wrappedComplete (ref), u12 (ref), NetWork (ref), NetMsg (ref), u6 (ref), _setWeaponCoreTrailsEnabled (ref), _hideDungeonDoorSurfaceGuis (ref), u1 (ref), _restorePlayerCamera (ref), u16 (ref), u17 (ref), HumanModule (ref), LocalPlayer (ref), u15 (ref), UIMgr (ref), _refreshPopShowAfterCutscene (ref), finishPlay (ref), _restoreBlackGuiBg (ref), u10 (ref), VisibleMgr (ref), u8 (ref), u7 (ref), u147 (ref), _fadeBlackScreen (ref)
            if u165 ~= u4 or (u152 ~= u5 or not u11) then
                return;
            end;

            if not _startMoon(u148, wrappedComplete) then
                if u152 ~= u5 then
                    return;
                end;

                u4 = u4 + 1;
                u6 = u6 + 1;
                local u166 = u152;

                local function u171() -- Line: 1517
                    -- upvalues: u152 (ref), u5 (ref), u1 (ref), _restorePlayerCamera (ref), u16 (ref), u17 (ref), HumanModule (ref), LocalPlayer (ref), u15 (ref), UIMgr (ref), _refreshPopShowAfterCutscene (ref), finishPlay (ref), u11 (ref), _restoreBlackGuiBg (ref), u10 (ref), VisibleMgr (ref), u8 (ref), u7 (ref), u147 (ref)
                    if u152 ~= u5 then
                        return;
                    end;

                    u1.CleanupSceneResources();
                    _restorePlayerCamera();

                    if u16 == nil then
                        u17 = nil;
                    else
                        local v167 = u17;

                        if not (v167 and v167.Parent) then
                            v167 = HumanModule.GetCharacter(LocalPlayer);

                            if v167 then
                                v167 = HumanModule.GetHumanoidRootPart(v167);
                            end;
                        end;

                        if v167 then
                            v167.Anchored = u16;
                        end;

                        u16 = nil;
                        u17 = nil;
                    end;

                    if u15 then
                        if type(UIMgr.RecoverHideUI) == "function" then
                            UIMgr.RecoverHideUI();
                        end;

                        u15 = false;
                    end;

                    _refreshPopShowAfterCutscene();
                    local u168 = u152;
                    local u169 = finishPlay;

                    local function v170() -- Line: 659
                        -- upvalues: u168 (copy), u5 (ref), u169 (copy)
                        if u168 ~= u5 then
                            return;
                        end;

                        if u169 then
                            u169();
                        end;
                    end;

                    if type(UIMgr.PlayBlackScreenFade) == "function" then
                        UIMgr.PlayBlackScreenFade(false, 0.5, v170);
                    else
                        if u168 ~= u5 then
                            return;
                        end;

                        if u169 then
                            if u152 ~= u5 then
                                return;
                            end;

                            u11 = false;
                            _restoreBlackGuiBg();

                            if u10 ~= nil then
                                if type(VisibleMgr.RestoreOtherPlayersLocal) == "function" then
                                    VisibleMgr.RestoreOtherPlayersLocal(u10);
                                end;

                                u10 = nil;
                            end;

                            if u8 then
                                for i, v in pairs(u7) do
                                    if i.Parent then
                                        i.Enabled = v;
                                    end;
                                end;

                                table.clear(u7);
                                u8 = false;
                            end;

                            _refreshPopShowAfterCutscene();

                            if u147 then
                                u147();
                            end;
                        end;
                    end;
                end;

                local function v172() -- Line: 659
                    -- upvalues: u166 (copy), u5 (ref), u171 (copy)
                    if u166 ~= u5 then
                        return;
                    end;

                    if u171 then
                        u171();
                    end;
                end;

                if type(UIMgr.PlayBlackScreenFade) == "function" then
                    UIMgr.PlayBlackScreenFade(true, 0.5, v172);
                else
                    if u166 ~= u5 then
                        return;
                    end;

                    if u171 then
                        if u152 ~= u5 then
                            return;
                        end;

                        u1.CleanupSceneResources();
                        _restorePlayerCamera();

                        if u16 == nil then
                            u17 = nil;
                        else
                            local v173 = u17;

                            if not (v173 and v173.Parent) then
                                v173 = HumanModule.GetCharacter(LocalPlayer);

                                if v173 then
                                    v173 = HumanModule.GetHumanoidRootPart(v173);
                                end;
                            end;

                            if v173 then
                                v173.Anchored = u16;
                            end;

                            u16 = nil;
                            u17 = nil;
                        end;

                        if u15 then
                            if type(UIMgr.RecoverHideUI) == "function" then
                                UIMgr.RecoverHideUI();
                            end;

                            u15 = false;
                        end;

                        _refreshPopShowAfterCutscene();
                        _fadeBlackScreen(false, u152, finishPlay);

                        return;
                    end;
                end;

                return;
            end;

            u12 = true;
            NetWork.FireServer(NetMsg.DWARF_KING_APPEAR_PLAYED);
            local u174 = u148;
            local u175 = u152;
            u6 = u6 + 1;
            local u176 = u6;
            _setWeaponCoreTrailsEnabled(u174, false);
            task.delay(6, function() -- Line: 815
                -- upvalues: u176 (copy), u6 (ref), u175 (copy), u5 (ref), u11 (ref), _setWeaponCoreTrailsEnabled (ref), u174 (copy)
                if u176 ~= u6 or (u175 ~= u5 or not u11) then
                    return;
                end;

                _setWeaponCoreTrailsEnabled(u174, true, true);
            end);
            task.delay(0.5, function() -- Line: 1562
                -- upvalues: u152 (ref), u5 (ref), u11 (ref), _hideDungeonDoorSurfaceGuis (ref)
                if u152 ~= u5 or not u11 then
                    return;
                end;

                _hideDungeonDoorSurfaceGuis();
            end);
        end);
    end;

    local function v178() -- Line: 659
        -- upvalues: u152 (copy), u5 (ref), u177 (copy)
        if u152 ~= u5 then
            return;
        end;

        if u177 then
            u177();
        end;
    end;

    if type(UIMgr.PlayBlackScreenFade) == "function" then
        UIMgr.PlayBlackScreenFade(true, 0.5, v178);
    elseif u152 == u5 and u177 then
        u177();
    end;

    return true;
end;

function u1.IsPlaying() -- Line: 1581
    -- upvalues: u11 (ref)
    return u11 == true;
end;

function u1.BeforeStageSpawn(p179, p180) -- Line: 1591
    -- upvalues: u11 (ref), u1 (copy)
    if type(p180) ~= "function" then
        return;
    end;

    if p179 ~= 3 then
        p180();

        return;
    end;

    if u11 then
        return;
    end;

    if u1.HasPlayed() then
        p180();

        return;
    end;

    if not u1.Play(p180) then
        p180();
    end;
end;

return u1;