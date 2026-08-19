-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local EnemyVisibilityUtil = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnemyVisibilityUtil;
local u1 = {};
local u2 = nil;

local function _getNpcNetworkOwnership() -- Line: 57
    -- upvalues: u2 (ref), ServerStorage (copy)
    if not u2 then
        u2 = require(ServerStorage.ServerSideCode.AI.Shared.NPCNetworkOwnership);
    end;

    return u2;
end;

function u1.resolvePhysicsRoot(p3) -- Line: 70
    if not (p3 and p3:IsA("Model")) then
        return nil;
    end;

    local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    local PrimaryPart = p3.PrimaryPart;

    if PrimaryPart and PrimaryPart:IsA("BasePart") then
        return PrimaryPart;
    end;

    return nil;
end;

local function _resolveNetworkOwnerPlayer(u4) -- Line: 91
    local success, result = pcall(function() -- Line: 92
        -- upvalues: u4 (copy)
        return u4:GetNetworkOwner();
    end);

    if success and (result and result:IsA("Player")) then
        return result;
    end;

    return nil;
end;

function u1.resolve(p5, p6, p7) -- Line: 109
    -- upvalues: u1 (copy), RunService (copy), u2 (ref), ServerStorage (copy), EnemyVisibilityUtil (copy), Players (copy)
    local v8 = {
        runOnClient = false,
        clientPlayer = nil
    };

    if not (p5 and p5:IsA("Model")) then
        return v8;
    end;

    local u9 = p6 or u1.resolvePhysicsRoot(p5);

    if not u9 then
        return v8;
    end;

    if RunService:IsServer() and (p7 and (p7.syncOwnership == true and p7.entity)) then
        if not u2 then
            u2 = require(ServerStorage.ServerSideCode.AI.Shared.NPCNetworkOwnership);
        end;

        u2.apply(p7.entity);
    end;

    local v10 = EnemyVisibilityUtil.getSingleWhitelistUserId(p5);

    if not v10 then
        return v8;
    end;

    local v11 = Players:GetPlayerByUserId(v10);

    if not (v11 and v11.Parent) then
        return v8;
    end;

    local success, result = pcall(function() -- Line: 92
        -- upvalues: u9 (copy)
        return u9:GetNetworkOwner();
    end);

    if not (success and (result and result:IsA("Player"))) then
        result = nil;
    end;

    return result == v11 and {
        runOnClient = true,
        clientPlayer = v11
    } or v8;
end;

return u1;