-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local LocalPlayer = UtilsSystem.LocalPlayer;
local EnemyLogicalTypes = UtilsSystem.EnemyLogicalTypes;
local u1 = {};

local function modelMatchesTrackId(p2, p3) -- Line: 44
    local v4 = p2:GetAttribute("EntityId");

    return v4 ~= nil and tostring(v4) == p3 and true or p2.Name == p3;
end;

local function walkPath(p5, p6) -- Line: 52
    for _, v in p6 do
        if not p5 then
            return nil;
        end;

        p5 = p5:FindFirstChild(v);
    end;

    return p5;
end;

local function isTrackTargetVisible(p7) -- Line: 77
    -- upvalues: RunService (copy), LocalPlayer (copy), EnemyVisibilityUtil (copy)
    return RunService:IsServer() and true or (not LocalPlayer and true or EnemyVisibilityUtil.canPlayerSee(p7, LocalPlayer.UserId));
end;

local function isCachedEnemyModelValid(p8, p9) -- Line: 93
    -- upvalues: RunService (copy), LocalPlayer (copy), EnemyVisibilityUtil (copy), EnemyLogicalTypes (copy), ServerStorage (copy)
    if p8.Parent then
        local v10 = p8:GetAttribute("EntityId");

        if (v10 ~= nil and tostring(v10) == p9 and true or p8.Name == p9) and (RunService:IsServer() or (not LocalPlayer or EnemyVisibilityUtil.canPlayerSee(p8, LocalPlayer.UserId))) then
            local Monster = workspace:FindFirstChild("Monster");

            if Monster and p8:IsDescendantOf(Monster) then
                return true;
            end;

            local v11 = workspace:FindFirstChild(EnemyLogicalTypes and EnemyLogicalTypes.LOCAL_MONSTER_FOLDER_NAME or "LocalMonster");

            return v11 and p8:IsDescendantOf(v11) and true or (RunService:IsServer() and p8:IsDescendantOf(ServerStorage) and true or false);
        end;
    end;

    return false;
end;

local function findEnemyModelInFolder(p12, p13) -- Line: 119
    -- upvalues: RunService (copy), LocalPlayer (copy), EnemyVisibilityUtil (copy)
    if not p12 then
        return nil;
    end;

    local v14 = p12:FindFirstChild(p13);

    if v14 and v14:IsA("Model") then
        local v15 = v14:GetAttribute("EntityId");

        if (v15 ~= nil and tostring(v15) == p13 and true or v14.Name == p13) and (RunService:IsServer() or (not LocalPlayer or EnemyVisibilityUtil.canPlayerSee(v14, LocalPlayer.UserId))) then
            return v14;
        end;
    end;

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("Model") then
            local v16 = descendant:GetAttribute("EntityId");

            if (v16 ~= nil and tostring(v16) == p13 and true or descendant.Name == p13) and (RunService:IsServer() or (not LocalPlayer or EnemyVisibilityUtil.canPlayerSee(descendant, LocalPlayer.UserId))) then
                return descendant;
            end;
        end;
    end;

    return nil;
end;

local function findRegisteredOrLogicalEnemyModel(p17) -- Line: 140
    -- upvalues: RunService (copy), UtilsSystem (copy), LocalPlayer (copy), EnemyVisibilityUtil (copy)
    if RunService:IsClient() then
        local SystemLogicalEnemy = UtilsSystem.SystemLogicalEnemy;

        if SystemLogicalEnemy and type(SystemLogicalEnemy.GetModel) == "function" then
            local v18 = SystemLogicalEnemy.GetModel(p17);

            if v18 and v18.Parent and (RunService:IsServer() or (not LocalPlayer or EnemyVisibilityUtil.canPlayerSee(v18, LocalPlayer.UserId))) then
                return v18;
            end;
        end;
    elseif RunService:IsServer() then
        local SystemEnemy = UtilsSystem.SystemEnemy;

        if SystemEnemy and type(SystemEnemy.getPackById) == "function" then
            local v19 = SystemEnemy.getPackById(p17);

            if v19 then
                v19 = v19.model;
            end;

            if v19 and v19.Parent then
                return v19;
            end;
        end;
    end;

    return nil;
end;

local function findModelByTrackTargetId(p20) -- Line: 166
    -- upvalues: u1 (copy), isCachedEnemyModelValid (copy), findRegisteredOrLogicalEnemyModel (copy), findEnemyModelInFolder (copy), EnemyLogicalTypes (copy), Players (copy)
    if p20 == nil or p20 == "" then
        return nil;
    end;

    local v21 = tostring(p20);
    local v22 = u1[v21];

    if v22 then
        if isCachedEnemyModelValid(v22, v21) then
            return v22;
        end;

        u1[v21] = nil;
    end;

    local v23 = findRegisteredOrLogicalEnemyModel(v21);

    if v23 then
        u1[v21] = v23;

        return v23;
    end;

    local v24 = findEnemyModelInFolder(workspace:FindFirstChild("Monster"), v21);

    if v24 then
        u1[v21] = v24;

        return v24;
    end;

    local v25 = findEnemyModelInFolder(workspace:FindFirstChild(EnemyLogicalTypes and EnemyLogicalTypes.LOCAL_MONSTER_FOLDER_NAME or "LocalMonster"), v21);

    if v25 then
        u1[v21] = v25;

        return v25;
    end;

    local v26 = nil;

    if type(p20) == "number" then
        v26 = p20;
    elseif type(p20) == "string" and p20:match("^%d+$") then
        v26 = tonumber(p20);
    end;

    if v26 then
        local v27 = Players:GetPlayerByUserId(v26);

        if v27 and (v27.Character and v27.Character.Parent) then
            return v27.Character;
        end;
    end;

    return nil;
end;

local function getWorldPositionByTrackTargetId(p28) -- Line: 256
    -- upvalues: findModelByTrackTargetId (copy)
    local v29;

    if p28 == nil or p28 == "" then
        v29 = false;
    else
        local v30 = findModelByTrackTargetId(p28);

        if v30 and v30.Parent then
            local v31 = v30:FindFirstChildOfClass("Humanoid");
            v29 = (not v31 or v31.Health > 0) and true or false;
        else
            v29 = false;
        end;
    end;

    if not v29 then
        return nil;
    end;

    local v32 = findModelByTrackTargetId(p28);

    if not (v32 and v32.Parent) then
        return nil;
    end;

    local HumanoidRootPart = v32:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    if v32.PrimaryPart then
        return v32.PrimaryPart.Position;
    end;

    return v32:GetPivot().Position;
end;

local function modelFromRootPart(p33) -- Line: 317
    local Parent = p33.Parent;

    while Parent do
        if Parent:IsA("Model") then
            return Parent;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

local function defaultModelPosition(p34) -- Line: 328
    local HumanoidRootPart = p34:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    if p34.PrimaryPart then
        return p34.PrimaryPart.Position;
    end;

    return p34:GetPivot().Position;
end;

local function getTrackTargetIdForSkillInput(p35) -- Line: 349
    -- upvalues: ReplicatedStorage (copy), findModelByTrackTargetId (copy)
    local v36 = p35 or {};
    local v37 = v36.objectValueName or "NowTargetCurrent";
    local v38 = ReplicatedStorage;
    local objectValuePathSegments = v36.objectValuePathSegments;
    local v39;

    if objectValuePathSegments and #objectValuePathSegments > 0 then
        v38 = ReplicatedStorage;

        for _, v in objectValuePathSegments do
            if not v38 then
                v38 = nil;
                break;
            end;

            v38 = v38:FindFirstChild(v);
        end;

        if v38 then
            v39 = v38:FindFirstChild(v37);

            if not (v39 and v39:IsA("ObjectValue")) then
                v39 = nil;
            end;
        else
            v39 = nil;
        end;
    else
        v39 = v38:FindFirstChild(v37);

        if not (v39 and v39:IsA("ObjectValue")) then
            v39 = nil;
        end;
    end;

    local v40;

    if v39 then
        v40 = v39.Value;

        if typeof(v40) ~= "Instance" or not (v40:IsA("BasePart") and v40.Parent) then
            v40 = nil;
        end;
    else
        v40 = nil;
    end;

    if not v40 then
        return nil;
    end;

    local Parent = v40.Parent;

    while true do
        if not Parent then
            Parent = nil;
            break;
        end;

        if Parent:IsA("Model") then
            break;
        end;

        Parent = Parent.Parent;
    end;

    if not Parent then
        return nil;
    end;

    local v41 = Parent:FindFirstChildOfClass("Humanoid");

    if v41 and v41.Health <= 0 then
        return nil;
    end;

    local v42;

    if v36.extractTargetId then
        v42 = v36.extractTargetId(Parent);
    else
        v42 = Parent:GetAttribute("EntityId");

        if v42 == nil then
            v42 = Parent.Name;
        end;
    end;

    local v43;

    if v42 == nil or v42 == "" then
        v43 = false;
    else
        local v44 = findModelByTrackTargetId(v42);

        if v44 and v44.Parent then
            local v45 = v44:FindFirstChildOfClass("Humanoid");
            v43 = (not v45 or v45.Health > 0) and true or false;
        else
            v43 = false;
        end;
    end;

    if v43 then
        return v42;
    end;

    return nil;
end;

local function tryResolveNearestEnemyTrackId(p46, p47) -- Line: 393
    -- upvalues: RunService (copy), UtilsSystem (copy)
    if not (RunService:IsServer() and p46) then
        return nil;
    end;

    local HumanoidRootPart = p46:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local SystemEnemy = UtilsSystem.SystemEnemy;

    if not SystemEnemy or type(SystemEnemy.findNearestAliveRoot) ~= "function" then
        return nil;
    end;

    local v48 = SystemEnemy.findNearestAliveRoot(HumanoidRootPart.Position, 60, p47);

    if not v48 then
        return nil;
    end;

    local Parent = v48.Parent;

    while true do
        if not Parent then
            Parent = nil;
            break;
        end;

        if Parent:IsA("Model") then
            break;
        end;

        Parent = Parent.Parent;
    end;

    if not Parent then
        return nil;
    end;

    local v49 = Parent:GetAttribute("EntityId");

    if v49 == nil then
        return Parent.Name;
    end;

    return v49;
end;

return {
    DEFAULT_OV_NAME = "NowTargetCurrent",

    defaultExtractTrackTargetId = function(p50) -- Line: 66, Name: defaultExtractTrackTargetId
        local v51 = p50:GetAttribute("EntityId");

        if v51 == nil then
            return p50.Name;
        end;

        return v51;
    end,

    findModelByTrackTargetId = findModelByTrackTargetId,
    getWorldPositionByTrackTargetId = getWorldPositionByTrackTargetId,

    findTrackTargetObjectValue = function(p52, p53) -- Line: 295, Name: findTrackTargetObjectValue
        -- upvalues: ReplicatedStorage (copy)
        if p53.getTrackTargetObjectValue and p52 then
            return p53.getTrackTargetObjectValue(p52);
        end;

        local v54 = p53.objectValueName or "NowTargetCurrent";
        local v55 = ReplicatedStorage;
        local objectValuePathSegments = p53.objectValuePathSegments;

        if objectValuePathSegments and #objectValuePathSegments > 0 then
            v55 = ReplicatedStorage;

            for _, v in objectValuePathSegments do
                if not v55 then
                    v55 = nil;
                    break;
                end;

                v55 = v55:FindFirstChild(v);
            end;

            if not v55 then
                return nil;
            end;
        end;

        local v56 = v55:FindFirstChild(v54);

        if v56 and v56:IsA("ObjectValue") then
            return v56;
        end;

        return nil;
    end,

    findNowTargetObjectValue = function(p57) -- Line: 277, Name: findNowTargetObjectValue
        -- upvalues: ReplicatedStorage (copy)
        local v58 = p57.objectValueName or "NowTargetCurrent";
        local v59 = ReplicatedStorage;
        local objectValuePathSegments = p57.objectValuePathSegments;

        if objectValuePathSegments and #objectValuePathSegments > 0 then
            v59 = ReplicatedStorage;

            for _, v in objectValuePathSegments do
                if not v59 then
                    v59 = nil;
                    break;
                end;

                v59 = v59:FindFirstChild(v);
            end;

            if not v59 then
                return nil;
            end;
        end;

        local v60 = v59:FindFirstChild(v58);

        if v60 and v60:IsA("ObjectValue") then
            return v60;
        end;

        return nil;
    end,

    getTargetRootPartFromObjectValue = function(p61) -- Line: 305, Name: getTargetRootPartFromObjectValue
        -- upvalues: ReplicatedStorage (copy)
        local v62 = p61.objectValueName or "NowTargetCurrent";
        local v63 = ReplicatedStorage;
        local objectValuePathSegments = p61.objectValuePathSegments;
        local v64;

        if objectValuePathSegments and #objectValuePathSegments > 0 then
            v63 = ReplicatedStorage;

            for _, v in objectValuePathSegments do
                if not v63 then
                    v63 = nil;
                    break;
                end;

                v63 = v63:FindFirstChild(v);
            end;

            if v63 then
                v64 = v63:FindFirstChild(v62);

                if not (v64 and v64:IsA("ObjectValue")) then
                    v64 = nil;
                end;
            else
                v64 = nil;
            end;
        else
            v64 = v63:FindFirstChild(v62);

            if not (v64 and v64:IsA("ObjectValue")) then
                v64 = nil;
            end;
        end;

        if not v64 then
            return nil;
        end;

        local Value = v64.Value;

        if typeof(Value) == "Instance" and (Value:IsA("BasePart") and Value.Parent) then
            return Value;
        end;

        return nil;
    end,

    getTrackTargetIdForSkillInput = getTrackTargetIdForSkillInput,

    refreshTrackTargetIdForSkillInput = function(p65) -- Line: 380, Name: refreshTrackTargetIdForSkillInput
        -- upvalues: RunService (copy), getTrackTargetIdForSkillInput (copy)
        if RunService:IsServer() then
            return nil;
        end;

        return getTrackTargetIdForSkillInput(p65);
    end,

    isTrackTargetAlive = function(p66) -- Line: 223, Name: isTrackTargetAlive
        -- upvalues: findModelByTrackTargetId (copy)
        if p66 == nil or p66 == "" then
            return false;
        end;

        local v67 = findModelByTrackTargetId(p66);

        if not (v67 and v67.Parent) then
            return false;
        end;

        local v68 = v67:FindFirstChildOfClass("Humanoid");

        return (not v68 or v68.Health > 0) and true or false;
    end,

    sanitizeTrackTargetId = function(p69) -- Line: 243, Name: sanitizeTrackTargetId
        -- upvalues: findModelByTrackTargetId (copy)
        if p69 == nil or p69 == "" then
            return nil;
        end;

        local v70;

        if p69 == nil or p69 == "" then
            v70 = false;
        else
            local v71 = findModelByTrackTargetId(p69);

            if v71 and v71.Parent then
                local v72 = v71:FindFirstChildOfClass("Humanoid");
                v70 = (not v72 or v72.Health > 0) and true or false;
            else
                v70 = false;
            end;
        end;

        if v70 then
            return p69;
        end;

        return nil;
    end,

    resolveTrackTargetIdForProjectileFlying = function(p73, p74, p75, p76, p77) -- Line: 425, Name: resolveTrackTargetIdForProjectileFlying
        -- upvalues: findModelByTrackTargetId (copy), RunService (copy), tryResolveNearestEnemyTrackId (copy)
        if p74 ~= nil then
            p73 = p74.trackTargetId;
        end;

        if p73 == nil or p73 == "" then
            p73 = nil;
        else
            local v78;

            if p73 == nil or p73 == "" then
                v78 = false;
            else
                local v79 = findModelByTrackTargetId(p73);

                if v79 and v79.Parent then
                    local v80 = v79:FindFirstChildOfClass("Humanoid");
                    v78 = (not v80 or v80.Health > 0) and true or false;
                else
                    v78 = false;
                end;
            end;

            if not v78 then
                p73 = nil;
            end;
        end;

        if p73 then
            return p73;
        end;

        if not RunService:IsServer() or (p77 ~= "Player" or type(p76) ~= "number") then
            return nil;
        end;

        local v81 = tryResolveNearestEnemyTrackId(p75, p76);

        if v81 == nil or v81 == "" then
            return nil;
        end;

        local v82;

        if v81 == nil or v81 == "" then
            v82 = false;
        else
            local v83 = findModelByTrackTargetId(v81);

            if v83 and v83.Parent then
                local v84 = v83:FindFirstChildOfClass("Humanoid");
                v82 = (not v84 or v84.Health > 0) and true or false;
            else
                v82 = false;
            end;
        end;

        if v82 then
            return v81;
        end;

        return nil;
    end,

    getLiveTrackedWorldPosition = function(p85, p86, p87) -- Line: 449, Name: getLiveTrackedWorldPosition
        -- upvalues: getWorldPositionByTrackTargetId (copy)
        if p85 == nil or p85 == "" then
            return nil;
        end;

        return getWorldPositionByTrackTargetId(p85);
    end,

    resolveAtCast = function(p88, p89, p90) -- Line: 459, Name: resolveAtCast
        -- upvalues: findModelByTrackTargetId (copy)
        if p88 == nil or p88 == "" then
            p88 = nil;
        else
            local v91;

            if p88 == nil or p88 == "" then
                v91 = false;
            else
                local v92 = findModelByTrackTargetId(p88);

                if v92 and v92.Parent then
                    local v93 = v92:FindFirstChildOfClass("Humanoid");
                    v91 = (not v93 or v93.Health > 0) and true or false;
                else
                    v91 = false;
                end;
            end;

            if not v91 then
                p88 = nil;
            end;
        end;

        if p88 ~= nil then
            local v94 = findModelByTrackTargetId(p88);

            if v94 and v94.Parent then
                local v95;

                if p90.getTargetWorldPosition then
                    v95 = p90.getTargetWorldPosition(v94);
                else
                    local HumanoidRootPart = v94:FindFirstChild("HumanoidRootPart");

                    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                        v95 = HumanoidRootPart.Position;
                    elseif v94.PrimaryPart then
                        v95 = v94.PrimaryPart.Position;
                    else
                        v95 = v94:GetPivot().Position;
                    end;
                end;

                if v95 then
                    return v94, v95, p88;
                end;
            end;
        end;

        return nil, nil, nil;
    end,

    getModelWorldPosition = function(p96, p97) -- Line: 339, Name: getModelWorldPosition
        if p97.getTargetWorldPosition then
            return p97.getTargetWorldPosition(p96);
        end;

        local HumanoidRootPart = p96:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            return HumanoidRootPart.Position;
        end;

        if p96.PrimaryPart then
            return p96.PrimaryPart.Position;
        end;

        return p96:GetPivot().Position;
    end
};