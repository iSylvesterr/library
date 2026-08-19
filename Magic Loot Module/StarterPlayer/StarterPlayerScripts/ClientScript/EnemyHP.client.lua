-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local TranslationHelper = UtilsSystem.TranslationHelper;
local InsMgr = UtilsSystem.InsMgr;
local ResourceUtil = UtilsSystem.ResourceUtil;
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local MathMgr = UtilsSystem.MathMgr;
local UIMgr = UtilsSystem.UIMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local v1 = UtilsSystem.AssetRegistry.BuildCatalogPath("BillBoard", "EnemyHp");
local u2 = ResourceUtil.GetTemplate(v1);
local u3 = InsMgr.GetIns("EnemyHP", "Folder", LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)));
local StudsOffset = u2.StudsOffset;
local u4 = 0;
local u5 = {};
local u6 = 0;

local function _resolveHpNodes(p7) -- Line: 81
    local HpBg = p7:FindFirstChild("HpBg");

    if not HpBg then
        local Frame = p7:FindFirstChild("Frame");

        if Frame then
            HpBg = Frame:FindFirstChild("HpBg");
        end;
    end;

    if not (HpBg and HpBg:IsA("Frame")) then
        return nil, nil, nil;
    end;

    local HpBar = HpBg:FindFirstChild("HpBar");
    local Health = HpBg:FindFirstChild("Health");

    if HpBar and (HpBar:IsA("Frame") and (Health and Health:IsA("TextLabel"))) then
        return HpBg, HpBar, Health;
    end;

    return nil, nil, nil;
end;

local function _resolveXydLabel(p8) -- Line: 107
    local Frame = p8:FindFirstChild("Frame");

    if not Frame then
        return nil;
    end;

    local XYD = Frame:FindFirstChild("XYD");

    if XYD and XYD:IsA("TextLabel") then
        return XYD;
    end;

    return nil;
end;

local function _applyXydLabel(p9, p10) -- Line: 126
    -- upvalues: UIMgr (copy)
    if not p10 then
        return;
    end;

    local v11 = p9:GetAttribute("SpecialEnemyConfigId");

    if type(v11) ~= "number" then
        p10.Visible = false;

        return;
    end;

    local v12 = p9:GetAttribute("Xyd");

    if type(v12) ~= "number" then
        p10.Visible = false;

        return;
    end;

    p10.Visible = true;
    UIMgr.setXydLabel(p10, v12);
end;

local function _getMonsterRoot(p13) -- Line: 153
    local PrimaryPart = p13.PrimaryPart;

    if PrimaryPart and PrimaryPart:IsA("BasePart") then
        return PrimaryPart;
    end;

    local HumanoidRootPart = p13:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    return nil;
end;

local function _applyBillboardHeight(p14, u15, p16) -- Line: 175
    -- upvalues: StudsOffset (copy)
    local v17, v18, v19 = pcall(function() -- Line: 177
        -- upvalues: u15 (copy)
        return u15:GetBoundingBox();
    end);
    local v20 = (not v17 or (typeof(v18) ~= "CFrame" or typeof(v19) ~= "Vector3")) and 3 or math.max(1, v18.Position.Y + v19.Y * 0.5 - p16.Position.Y + 0.5);
    p14.StudsOffset = Vector3.new(StudsOffset.X, v20, StudsOffset.Z);
end;

local function _getEnemyStageId(p21) -- Line: 194
    local v22 = tonumber(p21:GetAttribute("Stage"));

    if v22 and v22 > 0 then
        return math.floor(v22);
    end;

    local v23 = tonumber(p21:GetAttribute("SpecialEnemyStageId"));

    if v23 and v23 > 0 then
        return math.floor(v23);
    end;

    return nil;
end;

local function _isEnemyInSameAggroStage(p24) -- Line: 214
    -- upvalues: u4 (ref)
    local v25 = tonumber(p24:GetAttribute("Stage"));
    local v26;

    if v25 and v25 > 0 then
        v26 = math.floor(v25);
    else
        local v27 = tonumber(p24:GetAttribute("SpecialEnemyStageId"));

        if v27 and v27 > 0 then
            v26 = math.floor(v27);
        else
            v26 = nil;
        end;
    end;

    if not v26 then
        return true;
    end;

    if u4 <= 0 then
        return false;
    end;

    return u4 == v26;
end;

local function _resolveTrackableMonster(p28) -- Line: 235
    -- upvalues: EnemyVisibilityUtil (copy), LocalPlayer (copy), u4 (ref)
    if not (p28:IsA("Model") and p28.Parent) then
        return false, nil, nil;
    end;

    if not EnemyVisibilityUtil.canPlayerSee(p28, LocalPlayer.UserId) then
        return false, nil, nil;
    end;

    local v29 = tonumber(p28:GetAttribute("Stage"));
    local v30;

    if v29 and v29 > 0 then
        v30 = math.floor(v29);
    else
        local v31 = tonumber(p28:GetAttribute("SpecialEnemyStageId"));

        if v31 and v31 > 0 then
            v30 = math.floor(v31);
        else
            v30 = nil;
        end;
    end;

    local v32;

    if v30 then
        if u4 <= 0 then
            v32 = false;
        else
            v32 = u4 == v30;
        end;
    else
        v32 = true;
    end;

    if not v32 then
        return false, nil, nil;
    end;

    local PrimaryPart = p28.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        PrimaryPart = p28:FindFirstChild("HumanoidRootPart");

        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            PrimaryPart = nil;
        end;
    end;

    if not PrimaryPart then
        return false, nil, nil;
    end;

    if PrimaryPart:GetAttribute("Boss") == true then
        return false, nil, nil;
    end;

    local v33 = p28:FindFirstChildOfClass("Humanoid");

    if v33 and v33.Health > 0 then
        return true, v33, PrimaryPart;
    end;

    return false, nil, nil;
end;

local function _refreshEnemyHp(p34) -- Line: 271
    -- upvalues: TranslationHelper (copy), MathMgr (copy)
    local humanoid = p34.humanoid;
    local MaxHealth = humanoid.MaxHealth;

    if MaxHealth <= 0 then
        return;
    end;

    local Health = humanoid.Health;
    local v35 = math.clamp(Health / MaxHealth, 0, 1);
    local barLayout = p34.barLayout;
    p34.hpBar.Size = UDim2.new(barLayout.scaleX * v35, barLayout.offsetX, barLayout.scaleY, barLayout.offsetY);
    TranslationHelper.SetText_UnTrans(p34.hpText, MathMgr.getNumStr(Health) .. "/" .. MathMgr.getNumStr(MaxHealth));
end;

local function _removeTrack(p36) -- Line: 299
    -- upvalues: u5 (copy)
    local v37 = u5[p36];

    if not v37 then
        return;
    end;

    v37.connection:Disconnect();
    v37.billboard:Destroy();
    u5[p36] = nil;
end;

local function _trackMonster(u38, u39, p40) -- Line: 318
    -- upvalues: u5 (copy), _applyXydLabel (copy), _refreshEnemyHp (copy), u2 (copy), u3 (copy), _applyBillboardHeight (copy), _resolveHpNodes (copy)
    local v41 = u5[u38];

    if v41 then
        if v41.root ~= p40 then
            v41.billboard.Adornee = p40;
            v41.root = p40;
        end;

        if v41.humanoid ~= u39 then
            v41.humanoid = u39;
        end;

        _applyXydLabel(u38, v41.xydLabel);
        _refreshEnemyHp(v41);

        return;
    end;

    local v42 = u2:Clone();
    v42.Name = "EnemyHp_" .. u38.Name;
    v42.Parent = u3;
    v42.Enabled = true;
    v42.Adornee = p40;
    _applyBillboardHeight(v42, u38, p40);
    local _, v43, v44 = _resolveHpNodes(v42);

    if not (v43 and v44) then
        v42:Destroy();

        return;
    end;

    local Frame = v42:FindFirstChild("Frame");
    local v45;

    if Frame then
        v45 = Frame:FindFirstChild("XYD");

        if not (v45 and v45:IsA("TextLabel")) then
            v45 = nil;
        end;
    else
        v45 = nil;
    end;

    _applyXydLabel(u38, v45);
    local v49 = {
        billboard = v42,
        humanoid = u39,
        root = p40,
        hpBar = v43,
        hpText = v44,
        xydLabel = v45,
        barLayout = {
            scaleX = v43.Size.X.Scale,
            offsetX = v43.Size.X.Offset,
            scaleY = v43.Size.Y.Scale,
            offsetY = v43.Size.Y.Offset
        },
        connection = u39.HealthChanged:Connect(function() -- Line: 357
            -- upvalues: u5 (ref), u38 (copy), u39 (copy), _refreshEnemyHp (ref)
            local v46 = u5[u38];

            if not v46 then
                return;
            end;

            if u39.Health > 0 and u38.Parent then
                _refreshEnemyHp(v46);

                return;
            end;

            local v47 = u38;
            local v48 = u5[v47];

            if not v48 then
                return;
            end;

            v48.connection:Disconnect();
            v48.billboard:Destroy();
            u5[v47] = nil;
        end)
    };
    u5[u38] = v49;
    _refreshEnemyHp(v49);
end;

local Monster = workspace:WaitForChild("Monster", (1 / 0));
local LocalMonster = workspace:FindFirstChild("LocalMonster");

local function _syncAllTracks() -- Line: 391
    -- upvalues: _resolveTrackableMonster (copy), _trackMonster (copy), Monster (copy), LocalMonster (ref), u5 (copy)
    local u50 = {};

    local function scanFolder(p51) -- Line: 394
        -- upvalues: _resolveTrackableMonster (ref), u50 (copy), _trackMonster (ref)
        if not p51 then
            return;
        end;

        for _, child in p51:GetChildren() do
            if child:IsA("Model") then
                local v52, v53, v54 = _resolveTrackableMonster(child);

                if v52 and (v53 and v54) then
                    u50[child] = true;
                    _trackMonster(child, v53, v54);
                end;
            end;
        end;
    end;

    scanFolder(Monster);
    scanFolder(LocalMonster or workspace:FindFirstChild("LocalMonster"));

    for i in u5 do
        if not u50[i] then
            local v55 = u5[i];

            if v55 then
                v55.connection:Disconnect();
                v55.billboard:Destroy();
                u5[i] = nil;
            end;
        end;
    end;
end;

Monster.ChildAdded:Connect(function(u56) -- Line: 421
    -- upvalues: _resolveTrackableMonster (copy), _trackMonster (copy)
    if not u56:IsA("Model") then
        return;
    end;

    task.defer(function() -- Line: 426
        -- upvalues: _resolveTrackableMonster (ref), u56 (copy), _trackMonster (ref)
        local v57, v58, v59 = _resolveTrackableMonster(u56);

        if v57 and (v58 and v59) then
            _trackMonster(u56, v58, v59);
        end;
    end);
end);
Monster.ChildRemoved:Connect(function(p60) -- Line: 434
    -- upvalues: u5 (copy)
    if p60:IsA("Model") then
        local v61 = u5[p60];

        if not v61 then
            return;
        end;

        v61.connection:Disconnect();
        v61.billboard:Destroy();
        u5[p60] = nil;
    end;
end);

local function _onAggroStageChanged(p62) -- Line: 446
    -- upvalues: u4 (ref), _syncAllTracks (copy)
    local v63 = math.floor(p62);
    u4 = math.max(0, v63);
    _syncAllTracks();
end;

local DungeonAggroStage = LocalPlayer:WaitForChild("DungeonAggroStage", (1 / 0));
AddListen.NumValueAdd(DungeonAggroStage, _onAggroStageChanged, true);
task.spawn(function() -- Line: 455
    -- upvalues: LocalMonster (ref), _syncAllTracks (copy), u5 (copy)
    local LocalMonster2 = workspace:WaitForChild("LocalMonster", 120);

    if not (LocalMonster2 and LocalMonster2:IsA("Folder")) then
        return;
    end;

    LocalMonster = LocalMonster2;
    LocalMonster2.ChildAdded:Connect(function(p64) -- Line: 461
        -- upvalues: _syncAllTracks (ref)
        if p64:IsA("Model") then
            task.defer(_syncAllTracks);
        end;
    end);
    LocalMonster2.ChildRemoved:Connect(function(p65) -- Line: 466
        -- upvalues: u5 (ref)
        if p65:IsA("Model") then
            local v66 = u5[p65];

            if not v66 then
                return;
            end;

            v66.connection:Disconnect();
            v66.billboard:Destroy();
            u5[p65] = nil;
        end;
    end);
    _syncAllTracks();
end);
task.defer(_syncAllTracks);
RunService.Heartbeat:Connect(function(p67) -- Line: 476
    -- upvalues: u6 (ref), _syncAllTracks (copy)
    u6 = u6 + p67;

    if u6 < 0.2 then
        return;
    end;

    u6 = 0;
    _syncAllTracks();
end);