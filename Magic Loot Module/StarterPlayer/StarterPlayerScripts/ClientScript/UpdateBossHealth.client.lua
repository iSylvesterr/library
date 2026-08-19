-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local TranslationHelper = UtilsSystem.TranslationHelper;
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local LocalPlayer = UtilsSystem.LocalPlayer;
local MathMgr = UtilsSystem.MathMgr;
local Monster = workspace:WaitForChild("Monster", (1 / 0));
local LocalMonster = workspace:FindFirstChild("LocalMonster");
local BossHp = LocalPlayer.PlayerGui:WaitForChild("ScreenGui_Full", (1 / 0)):WaitForChild("Top", (1 / 0)):WaitForChild("BossHp", (1 / 0));
local Temp = BossHp:WaitForChild("Temp", (1 / 0));
Temp.Visible = false;
local u1 = 0;
local u2 = {};
local u3 = 0;

local function _resolveAliveStageBoss(p4) -- Line: 66
    -- upvalues: u1 (ref), EnemyVisibilityUtil (copy), LocalPlayer (copy)
    if u1 <= 0 then
        return false, nil;
    end;

    if not (p4:IsA("Model") and p4.Parent) then
        return false, nil;
    end;

    if not EnemyVisibilityUtil.canPlayerSee(p4, LocalPlayer.UserId) then
        return false, nil;
    end;

    if tonumber(p4:GetAttribute("Stage")) ~= u1 then
        return false, nil;
    end;

    local PrimaryPart = p4.PrimaryPart;

    if not PrimaryPart then
        return false, nil;
    end;

    if PrimaryPart:GetAttribute("Boss") ~= true then
        return false, nil;
    end;

    local v5 = p4:FindFirstChildOfClass("Humanoid");

    if v5 and v5.Health > 0 then
        return true, v5;
    end;

    return false, nil;
end;

local function _refreshBossFrame(p6) -- Line: 107
    -- upvalues: TranslationHelper (copy), MathMgr (copy)
    local humanoid = p6.humanoid;
    local frame = p6.frame;
    local MaxHealth = humanoid.MaxHealth;

    if MaxHealth <= 0 then
        return;
    end;

    local v7 = math.clamp(humanoid.Health / MaxHealth, 0, 1);
    local barLayout = p6.barLayout;
    frame.HpBg.HpBar.Size = UDim2.new(barLayout.scaleX * math.max(v7, 0.05), barLayout.offsetX, barLayout.scaleY, barLayout.offsetY);
    TranslationHelper.SetText_UnTrans(frame.Hp, MathMgr.getNumStr(humanoid.Health) .. "/" .. MathMgr.getNumStr(MaxHealth));
end;

local function _removeBossTrack(p8) -- Line: 134
    -- upvalues: u2 (copy)
    local v9 = u2[p8];

    if not v9 then
        return;
    end;

    for _, v in v9.connections do
        v:Disconnect();
    end;

    u2[p8] = nil;
    v9.frame:Destroy();
end;

local function _clearAllBossTracks() -- Line: 152
    -- upvalues: u2 (copy)
    for i in u2 do
        local v10 = u2[i];

        if v10 then
            for _, v in v10.connections do
                v:Disconnect();
            end;

            u2[i] = nil;
            v10.frame:Destroy();
        end;
    end;
end;

local function _trackBossModel(u11, u12) -- Line: 165
    -- upvalues: u2 (copy), _refreshBossFrame (copy), Temp (copy), BossHp (copy), TranslationHelper (copy)
    local Name = u11.Name;

    if u2[Name] then
        _refreshBossFrame(u2[Name]);

        return;
    end;

    local PrimaryPart = u11.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    local v13 = Temp:Clone();
    v13.Visible = true;
    v13.Name = Name;
    v13.Parent = BossHp;
    local v14 = PrimaryPart:GetAttribute("ZhName");

    if typeof(v14) == "string" and v14 ~= "" then
        TranslationHelper.SetText(v13.ZhName, v14);
    end;

    local HpBar = v13.HpBg.HpBar;
    local v15 = {
        scaleX = HpBar.Size.X.Scale,
        offsetX = HpBar.Size.X.Offset,
        scaleY = HpBar.Size.Y.Scale,
        offsetY = HpBar.Size.Y.Offset
    };
    local v16 = {};
    table.insert(v16, u12.HealthChanged:Connect(function() -- Line: 196
        -- upvalues: u2 (ref), Name (copy), u12 (copy), u11 (copy), _refreshBossFrame (ref)
        local v17 = u2[Name];

        if not v17 then
            return;
        end;

        if u12.Health > 0 and u11.Parent then
            _refreshBossFrame(v17);

            return;
        end;

        local v18 = Name;
        local v19 = u2[v18];

        if not v19 then
            return;
        end;

        for _, v in v19.connections do
            v:Disconnect();
        end;

        u2[v18] = nil;
        v19.frame:Destroy();
    end));
    table.insert(v16, u12.Died:Connect(function() -- Line: 207
        -- upvalues: Name (copy), u2 (ref)
        local v20 = Name;
        local v21 = u2[v20];

        if not v21 then
            return;
        end;

        for _, v in v21.connections do
            v:Disconnect();
        end;

        u2[v20] = nil;
        v21.frame:Destroy();
    end));
    table.insert(v16, u11.Destroying:Connect(function() -- Line: 210
        -- upvalues: Name (copy), u2 (ref)
        local v22 = Name;
        local v23 = u2[v22];

        if not v23 then
            return;
        end;

        for _, v in v23.connections do
            v:Disconnect();
        end;

        u2[v22] = nil;
        v23.frame:Destroy();
    end));
    local v24 = {
        frame = v13,
        humanoid = u12,
        connections = v16,
        barLayout = v15
    };
    u2[Name] = v24;
    _refreshBossFrame(v24);
end;

local function _scanFolderForBosses(p25, p26) -- Line: 231
    -- upvalues: _resolveAliveStageBoss (copy), _trackBossModel (copy)
    if not p25 then
        return;
    end;

    for _, child in p25:GetChildren() do
        if child:IsA("Model") then
            local v27, v28 = _resolveAliveStageBoss(child);

            if v27 and v28 then
                p26[child.Name] = true;
                _trackBossModel(child, v28);
            end;
        end;
    end;
end;

local function _syncBossTracks() -- Line: 253
    -- upvalues: u1 (ref), u2 (copy), _scanFolderForBosses (copy), Monster (copy), LocalMonster (ref)
    if u1 <= 0 then
        for i in u2 do
            local v29 = u2[i];

            if v29 then
                for _, v in v29.connections do
                    v:Disconnect();
                end;

                u2[i] = nil;
                v29.frame:Destroy();
            end;
        end;

        return;
    end;

    local v30 = {};
    _scanFolderForBosses(Monster, v30);
    _scanFolderForBosses(LocalMonster or workspace:FindFirstChild("LocalMonster"), v30);

    for i in u2 do
        if not v30[i] then
            local v31 = u2[i];

            if v31 then
                for _, v in v31.connections do
                    v:Disconnect();
                end;

                u2[i] = nil;
                v31.frame:Destroy();
            end;
        end;
    end;
end;

local function _onAggroStageChanged(p32) -- Line: 277
    -- upvalues: u1 (ref), _syncBossTracks (copy)
    local v33 = math.floor(p32);
    u1 = math.max(0, v33);
    _syncBossTracks();
end;

local function _onMonsterChildAdded(u34) -- Line: 288
    -- upvalues: _resolveAliveStageBoss (copy), _trackBossModel (copy)
    if not u34:IsA("Model") then
        return;
    end;

    task.defer(function() -- Line: 293
        -- upvalues: _resolveAliveStageBoss (ref), u34 (copy), _trackBossModel (ref)
        local v35, v36 = _resolveAliveStageBoss(u34);

        if v35 and v36 then
            _trackBossModel(u34, v36);
        end;
    end);
end;

local function _onMonsterChildRemoved(p37) -- Line: 307
    -- upvalues: u2 (copy)
    if p37:IsA("Model") then
        local Name = p37.Name;
        local v38 = u2[Name];

        if not v38 then
            return;
        end;

        for _, v in v38.connections do
            v:Disconnect();
        end;

        u2[Name] = nil;
        v38.frame:Destroy();
    end;
end;

local function _bindMonsterFolder(p39) -- Line: 319
    -- upvalues: _onMonsterChildAdded (copy), _onMonsterChildRemoved (copy), _resolveAliveStageBoss (copy), _trackBossModel (copy)
    p39.ChildAdded:Connect(_onMonsterChildAdded);
    p39.ChildRemoved:Connect(_onMonsterChildRemoved);

    for _, child in p39:GetChildren() do
        if child:IsA("Model") then
            task.defer(function() -- Line: 293
                -- upvalues: _resolveAliveStageBoss (ref), child (copy), _trackBossModel (ref)
                local v40, v41 = _resolveAliveStageBoss(child);

                if v40 and v41 then
                    _trackBossModel(child, v41);
                end;
            end);
        end;
    end;
end;

local DungeonAggroStage = LocalPlayer:WaitForChild("DungeonAggroStage", (1 / 0));
AddListen.NumValueAdd(DungeonAggroStage, _onAggroStageChanged, true);
_bindMonsterFolder(Monster);
task.spawn(function() -- Line: 333
    -- upvalues: LocalMonster (ref), _bindMonsterFolder (copy), _syncBossTracks (copy)
    local LocalMonster2 = workspace:WaitForChild("LocalMonster", 120);

    if not (LocalMonster2 and LocalMonster2:IsA("Folder")) then
        return;
    end;

    LocalMonster = LocalMonster2;
    _bindMonsterFolder(LocalMonster2);
    _syncBossTracks();
end);
RunService.Heartbeat:Connect(function(p42) -- Line: 343
    -- upvalues: u3 (ref), _syncBossTracks (copy)
    u3 = u3 + p42;

    if u3 < 0.2 then
        return;
    end;

    u3 = 0;
    _syncBossTracks();
end);