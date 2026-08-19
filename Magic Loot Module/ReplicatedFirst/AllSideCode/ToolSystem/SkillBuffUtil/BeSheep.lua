-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local FXUtil = UtilsSystem.FXUtil;
local TipsModule = UtilsSystem.TipsModule;
local VisibleMgr = UtilsSystem.VisibleMgr;
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local Log = UtilsSystem.Log;
local Apply = require(script.Parent.Apply);
local BeSheep = require(script.Parent.Handlers.BeSheep);
local u1;

if RunService:IsClient() then
    u1 = require(script.Parent.PolymorphPresentation);
else
    u1 = nil;
end;

local u6 = {
    playPresentation = function(p2) -- Line: 42, Name: playPresentation
        -- upvalues: RunService (copy), u1 (ref)
        if not (RunService:IsClient() and (p2 and p2:IsA("Model"))) then
            return;
        end;

        if not u1 then
            u1 = require(script.Parent.PolymorphPresentation);
        end;

        u1.PlayOnEnemy(p2);
    end,

    isExcludedTarget = function(p3) -- Line: 57, Name: isExcludedTarget
        -- upvalues: BeSheep (copy)
        return BeSheep.isExcludedTarget(p3);
    end,

    isPolymorphActive = function(p4) -- Line: 66, Name: isPolymorphActive
        local v5;

        if p4 == nil then
            v5 = false;
        else
            v5 = p4:GetAttribute("PolymorphActive") == true;
        end;

        return v5;
    end
};

local function _forceUnanchorAndBind(p7, p8) -- Line: 75
    -- upvalues: VisibleMgr (copy)
    VisibleMgr.PrepareModelForAttach(p7);

    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
            descendant.Massless = true;
            local v9 = descendant:GetPropertyChangedSignal("Anchored");
            table.insert(p8, v9:Connect(function() -- Line: 87
                -- upvalues: descendant (copy)
                if descendant.Anchored then
                    descendant.Anchored = false;
                end;
            end));
        elseif descendant:IsA("WeldConstraint") or descendant:IsA("Weld") then
            local Part0 = descendant.Part0;
            local Part1 = descendant.Part1;
            local v10;

            if Part0 == nil then
                v10 = false;
            else
                v10 = Part0:IsDescendantOf(p7);
            end;

            local v11;

            if Part1 == nil then
                v11 = false;
            else
                v11 = Part1:IsDescendantOf(p7);
            end;

            if v10 ~= v11 then
                descendant:Destroy();
            end;
        end;
    end;
end;

local function _disconnectConns(p12) -- Line: 110
    for _, v in p12 do
        v:Disconnect();
    end;

    table.clear(p12);
end;

function u6.playCasterSuccessFx(u13, p14) -- Line: 123
    -- upvalues: RunService (copy), _forceUnanchorAndBind (copy), FXUtil (copy), Log (copy)
    if not (RunService:IsClient() and (u13 and u13:IsA("Model"))) then
        return;
    end;

    if not p14 then
        return;
    end;

    local HumanoidRootPart = p14:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local u15 = {};
    _forceUnanchorAndBind(u13, u15);
    local PrimaryPart = u13.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        PrimaryPart = u13:FindFirstChildWhichIsA("BasePart", true);
    end;

    if not PrimaryPart then
        for _, v in u15 do
            v:Disconnect();
        end;

        table.clear(u15);
        FXUtil.BackPool_Instance(u13);

        return;
    end;

    u13.PrimaryPart = PrimaryPart;
    u13:PivotTo(HumanoidRootPart:GetPivot());
    u13.Parent = p14;
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

    for _, descendant in u13:GetDescendants() do
        if descendant:IsA("WeldConstraint") and (descendant.Part0 == HumanoidRootPart or descendant.Part1 == HumanoidRootPart) then
            descendant:Destroy();
        end;
    end;

    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Name = "BeSheepSuccessFxWeld";
    WeldConstraint.Part0 = HumanoidRootPart;
    WeldConstraint.Part1 = PrimaryPart;
    WeldConstraint.Parent = PrimaryPart;
    _forceUnanchorAndBind(u13, u15);
    local v16 = 0;

    for _, descendant in u13:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Anchored then
            v16 = v16 + 1;
            descendant.Anchored = false;
        end;
    end;

    if v16 > 0 then
        Log.warn("[BeSheep] 变羊术_成功特效焊后仍有 Anchored Part，已再次清除", v16, u13:GetFullName());
    end;

    u13:SetAttribute("BeSheepSuccessFxBound", true);
    FXUtil.Emit_Particles_GetDescendants(u13, true);
    task.delay(2, function() -- Line: 184
        -- upvalues: u15 (copy), u13 (copy), PrimaryPart (ref), FXUtil (ref)
        local v17 = u15;

        for _, v in v17 do
            v:Disconnect();
        end;

        table.clear(v17);

        if u13 and u13.Parent then
            local v18 = PrimaryPart and PrimaryPart:FindFirstChild("BeSheepSuccessFxWeld");

            if v18 then
                v18:Destroy();
            end;

            FXUtil.BackPool_Instance(u13);
        end;
    end);
end;

function u6.playCasterSuccessFxFromMaterial(p19, p20) -- Line: 202
    -- upvalues: u6 (copy)
    if not p19 then
        return;
    end;

    local v21 = p19["变羊术_成功特效"];

    if not (v21 and v21:IsA("Model")) then
        return;
    end;

    p19["变羊术_成功特效"] = nil;
    u6.playCasterSuccessFx(v21, p20);
end;

local function _resolveCasterUserId(p22) -- Line: 219
    if not p22 then
        return nil;
    end;

    local v23 = tonumber(p22.casterUserId) or tonumber(p22.attackerPlayerId);

    if v23 and v23 > 0 then
        return v23;
    end;

    local attacker = p22.attacker;

    if typeof(attacker) == "Instance" and attacker:IsA("Player") then
        return attacker.UserId;
    end;

    return nil;
end;

function u6.tryApplyToEnemy(p24, p25, p26, p27) -- Line: 245
    -- upvalues: RunService (copy), EnemyVisibilityUtil (copy), u6 (copy), Players (copy), TipsModule (copy), Apply (copy)
    if not (RunService:IsServer() and (p24 and p24.Parent)) then
        return false;
    end;

    local v28;

    if p26 then
        v28 = tonumber(p26.casterUserId) or tonumber(p26.attackerPlayerId);

        if not v28 or v28 <= 0 then
            local attacker = p26.attacker;

            if typeof(attacker) == "Instance" and attacker:IsA("Player") then
                v28 = attacker.UserId;
            else
                v28 = nil;
            end;
        end;
    else
        v28 = nil;
    end;

    if typeof(v28) ~= "number" or not EnemyVisibilityUtil.canPlayerInteract(p24, v28) then
        return false;
    end;

    if u6.isExcludedTarget(p24) then
        if p27 and (p27 ~= "" and p26) then
            local v29 = nil;
            local attacker = p26.attacker;

            if typeof(attacker) == "Instance" and attacker:IsA("Player") then
                v29 = attacker;
            elseif typeof(p26.casterUserId) == "number" then
                v29 = Players:GetPlayerByUserId(p26.casterUserId);
            end;

            if v29 then
                TipsModule.NormalTips(v29, p27);
            end;
        end;

        return false;
    end;

    if u6.isPolymorphActive(p24) then
        return false;
    end;

    Apply.ApplySkillBuffsToDefender(p24, p25, p26);

    return true;
end;

return u6;