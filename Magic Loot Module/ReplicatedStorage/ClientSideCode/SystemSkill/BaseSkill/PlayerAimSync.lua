-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local HumanModule = UtilsSystem.HumanModule;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local LocalPlayer = UtilsSystem.LocalPlayer;
local GetSkillData = require(script.Parent.GetSkillData);
local BaseSkillTargetFind = require(script.Parent.BaseSkillTargetFind);
local ProjectileObjectTracking = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule._Templates.Projectile.ProjectileObjectTracking);
local u1 = {};
local u2 = {};
local u3 = nil;
local u4 = false;
local u5 = false;

local function isPlayerHoldingWeapon(p6) -- Line: 37
    -- upvalues: HumanModule (copy)
    return HumanModule.IsPlrCharAlive(p6) and true or false;
end;

local function horizontalDistanceXZ(p7, p8) -- Line: 45
    local v9 = p7.X - p8.X;
    local v10 = p7.Z - p8.Z;

    return math.sqrt(v9 * v9 + v10 * v10);
end;

function u1.isAutoAimActiveForSkill(p11) -- Line: 56
    -- upvalues: BaseSkillTargetFind (copy), ProjectileObjectTracking (copy), RunService (copy), LocalPlayer (copy), GetSkillData (copy)
    if not p11 then
        return false;
    end;

    if p11.skillTargetData and BaseSkillTargetFind.findTarget(p11.skillTargetData) then
        return true;
    end;

    local skillInputData = p11.skillInputData;

    return skillInputData and (skillInputData.trackTargetId ~= nil and (skillInputData.trackTargetId ~= "" and ProjectileObjectTracking.getWorldPositionByTrackTargetId(skillInputData.trackTargetId))) and true or (RunService:IsClient() and (LocalPlayer and (p11.characterType == "Player" and (p11.characterId == LocalPlayer.UserId and GetSkillData.isLocalPlayerAutoAimActive()))) and true or false);
end;

function u1.getServerBufferedAimCFrame(p12) -- Line: 85
    -- upvalues: u2 (copy)
    local v13 = u2[p12];

    if not v13 then
        return nil;
    end;

    if workspace:GetServerTimeNow() - v13.serverTime > 0.15 then
        return nil;
    end;

    return CFrame.new(v13.pos);
end;

function u1.getClientBufferedAimCFrame() -- Line: 96
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.refreshAimSnapshot(p14) -- Line: 103
    if p14 and p14.skillRunData then
        p14.skillRunData.manualAimSnapshotCF = nil;
    end;

    if p14 and type(p14.getTargetCF) == "function" then
        return p14:getTargetCF();
    end;

    return CFrame.new();
end;

function u1.getOrFreezeManualAimCF(p15, p16) -- Line: 119
    -- upvalues: GetSkillData (copy)
    if p15.characterType == "Mirror" then
        local v17 = p15.skillInputData and p15.skillInputData.targetCF or CFrame.new();
        local skillRunData = p15.skillRunData;

        if skillRunData then
            skillRunData.manualAimSnapshotCF = v17;
        end;

        return v17;
    end;

    local skillRunData = p15.skillRunData;

    if not skillRunData then
        return p15.skillInputData and p15.skillInputData.targetCF or CFrame.new();
    end;

    if skillRunData.manualAimSnapshotCF then
        return skillRunData.manualAimSnapshotCF;
    end;

    if not p16 and (p15.skillInputData and p15.skillInputData.targetCF) then
        p16 = p15.skillInputData.targetCF;
    end;

    local v18 = p16 or CFrame.new();
    local skillModule = p15.skillModule;

    if skillModule then
        skillModule = skillModule.skillDistanceLimit;
    end;

    if skillModule and (p15.skillInputData and p15.skillInputData.releaseCF) then
        v18 = GetSkillData.getLimitedTargetCF(p15.skillInputData.releaseCF, v18, skillModule);
    end;

    skillRunData.manualAimSnapshotCF = v18;

    if p15.skillInputData then
        p15.skillInputData.targetCF = v18;
    end;

    return v18;
end;

function u1.clearServerBuffer(p19) -- Line: 159
    -- upvalues: u2 (copy)
    u2[p19] = nil;
end;

local function validateAndRecordSample(p20, p21, p22) -- Line: 169
    -- upvalues: HumanModule (copy), u2 (copy)
    if typeof(p21) ~= "Vector3" then
        return;
    end;

    if not HumanModule.IsPlrCharAlive(p20) then
        return;
    end;

    local Character = p20.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (Character and Character:IsA("BasePart")) then
        return;
    end;

    local Position = Character.Position;
    local v23 = Position.X - p21.X;
    local v24 = Position.Z - p21.Z;

    if math.sqrt(v23 * v23 + v24 * v24) > 200 then
        return;
    end;

    u2[p20.UserId] = {
        pos = p21,
        serverTime = workspace:GetServerTimeNow()
    };
end;

function u1.RegisterNetWork() -- Line: 193
    -- upvalues: NetWork (copy), NetMsg (copy), validateAndRecordSample (copy)
    NetWork.RegisterServerRemoteEvent(NetMsg.PLAYER_AIM_SAMPLE, function(p25, p26, p27) -- Line: 196
        -- upvalues: validateAndRecordSample (ref)
        validateAndRecordSample(p25, p26, p27);
    end, {
        skipRateLimit = true
    });
end;

function u1.initServer() -- Line: 203
    -- upvalues: u5 (ref), RunService (copy), u1 (copy), Players (copy)
    if u5 or not RunService:IsServer() then
        return;
    end;

    u5 = true;
    u1.RegisterNetWork();
    Players.PlayerRemoving:Connect(function(p28) -- Line: 211
        -- upvalues: u1 (ref)
        u1.clearServerBuffer(p28.UserId);
    end);
end;

function u1.initClient() -- Line: 216
    -- upvalues: RunService (copy), u4 (ref), Players (copy), HumanModule (copy), GetSkillData (copy), u3 (ref), NetWork (copy), NetMsg (copy)
    if not RunService:IsClient() or u4 then
        return;
    end;

    u4 = true;
    RunService.Heartbeat:Connect(function(p29) -- Line: 222
        -- upvalues: Players (ref), HumanModule (ref), GetSkillData (ref), u3 (ref), NetWork (ref), NetMsg (ref)
        local LocalPlayer2 = Players.LocalPlayer;

        if not (LocalPlayer2 and HumanModule.IsPlrCharAlive(LocalPlayer2)) then
            return;
        end;

        if not HumanModule.IsPlrCharAlive(LocalPlayer2) then
            return;
        end;

        if GetSkillData.isLocalPlayerAutoAimActive() then
            return;
        end;

        local v30 = GetSkillData.getLocalPlayerManualAimCFrame();

        if not v30 then
            return;
        end;

        u3 = v30;
        NetWork.FireServer(NetMsg.PLAYER_AIM_SAMPLE, v30.Position, workspace:GetServerTimeNow());
    end);
end;

return u1;