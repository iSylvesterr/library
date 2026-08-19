-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local GetData = UtilsSystem.GetData;
local HumanModule = UtilsSystem.HumanModule;
local ResourceUtil = UtilsSystem.ResourceUtil;
local UIMgr = UtilsSystem.UIMgr;
local FXUtil = UtilsSystem.FXUtil;
local Debris = UtilsSystem.Debris;
local LocalPlayer = UtilsSystem.LocalPlayer;
local MonsterDeathFx = UtilsSystem.MonsterDeathFx;
local SystemLogicalEnemy = UtilsSystem.SystemLogicalEnemy;

local function _isLocalPlayerNear(p1, p2) -- Line: 45
    -- upvalues: HumanModule (copy), LocalPlayer (copy)
    local v3 = HumanModule.GetHumanoidRootPart(LocalPlayer);

    if not v3 then
        return false;
    end;

    local v4 = v3.Position - p1;

    return Vector3.new(v4.X, 0, v4.Z).Magnitude <= p2;
end;

local function _tintParticleEmitters(p5, p6) -- Line: 61
    -- upvalues: UIMgr (copy)
    local v7 = UIMgr.GetColor3ByXYD(p6);

    if not v7 then
        return;
    end;

    local v8 = ColorSequence.new(v7);

    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Color = v8;
        end;
    end;
end;

NetWork.RegisterClientRemoteEvent(NetMsg.ENEMY_SPAWN, function(p9) -- Line: 79, Name: _onEnemySpawn
    -- upvalues: GetData (copy), LocalPlayer (copy), HumanModule (copy), ResourceUtil (copy), _tintParticleEmitters (copy), FXUtil (copy), Debris (copy)
    if type(p9) ~= "table" then
        return;
    end;

    local v10 = p9[1];
    local v11 = p9[2];

    if typeof(v10) ~= "Vector3" then
        return;
    end;

    local v12 = type(v11) ~= "number" and 1 or v11;

    if GetData.GetSetting(LocalPlayer, "GraphicsQuality") ~= 1 then
        return;
    end;

    local v13 = HumanModule.GetHumanoidRootPart(LocalPlayer);
    local v14;

    if v13 then
        local v15 = v13.Position - v10;
        v14 = Vector3.new(v15.X, 0, v15.Z).Magnitude <= 300;
    else
        v14 = false;
    end;

    if not v14 then
        return;
    end;

    local v16 = ResourceUtil.GetModel(ResourceUtil.ModelCategory.Effect, "怪物出现");

    if not v16 then
        return;
    end;

    v16:PivotTo(CFrame.new(v10 + Vector3.new(0, 3, 0)));
    v16.Parent = workspace;
    _tintParticleEmitters(v16, v12);
    FXUtil.Emit_Particles_GetDescendants(v16);
    Debris:AddItem(v16, 5);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.NPC_DEATH_FX, function(p17) -- Line: 114
    -- upvalues: MonsterDeathFx (copy)
    MonsterDeathFx.handleIncoming(p17);
end);
SystemLogicalEnemy.Init();
NetWork.RegisterClientRemoteEvent(NetMsg.ENEMY_LOGICAL_SPAWN, function(p18) -- Line: 119
    -- upvalues: SystemLogicalEnemy (copy)
    SystemLogicalEnemy.OnSpawn(p18);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.ENEMY_LOGICAL_TRANSFORM, function(p19) -- Line: 122
    -- upvalues: SystemLogicalEnemy (copy)
    SystemLogicalEnemy.OnTransform(p19);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.ENEMY_LOGICAL_STATE, function(p20) -- Line: 125
    -- upvalues: SystemLogicalEnemy (copy)
    SystemLogicalEnemy.OnState(p20);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.ENEMY_LOGICAL_DEATH, function(p21) -- Line: 128
    -- upvalues: SystemLogicalEnemy (copy)
    SystemLogicalEnemy.OnDeath(p21);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.ENEMY_LOGICAL_DESPAWN, function(p22) -- Line: 131
    -- upvalues: SystemLogicalEnemy (copy)
    SystemLogicalEnemy.OnDespawn(p22);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.ENEMY_LOGICAL_SNAPSHOT, function(p23) -- Line: 134
    -- upvalues: SystemLogicalEnemy (copy)
    SystemLogicalEnemy.OnSnapshot(p23);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.ENEMY_LOGICAL_DISPLACE, function(p24) -- Line: 137
    -- upvalues: SystemLogicalEnemy (copy)
    SystemLogicalEnemy.OnDisplace(p24);
end);