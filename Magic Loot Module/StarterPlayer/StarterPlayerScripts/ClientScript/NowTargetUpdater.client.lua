-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local DeviceType = UtilsSystem.DeviceType;
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local ResourceUtil = UtilsSystem.ResourceUtil;
local v1 = UtilsSystem.AssetRegistry.BuildModelPath("HighLight", "NowTarget");
local LocalPlayer = Players.LocalPlayer;
local u2 = ResourceUtil.Get(v1);
u2.Parent = LocalPlayer;
local u3 = DeviceType.IsMobile();
local u4 = 0;
local u5 = nil;
local u6 = false;
local u7 = {};
local u8 = 0;
local u9 = {};
local BindableEvent = Instance.new("BindableEvent");
BindableEvent.Name = "NowTargetLost";
BindableEvent.Parent = ReplicatedStorage;
local NowTarget = LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("NowTarget", (1 / 0));
local ImageLabel = NowTarget:FindFirstChild("ImageLabel");

if ImageLabel and not ImageLabel:IsA("ImageLabel") then
    ImageLabel = nil;
end;

local ObjectValue = Instance.new("ObjectValue");
ObjectValue.Name = "NowTargetCurrent";
ObjectValue.Parent = ReplicatedStorage;
local u10 = nil;
local u11 = nil;
local u12 = nil;

local function _addEnemy(p13) -- Line: 104
    -- upvalues: u9 (copy), u8 (ref), u7 (copy)
    if u9[p13] then
        return;
    end;

    u9[p13] = true;
    u8 = u8 + 1;
    u7[u8] = p13;
end;

local function _removeEnemy(p14) -- Line: 118
    -- upvalues: u9 (copy), u8 (ref), u7 (copy)
    if not u9[p14] then
        return;
    end;

    u9[p14] = nil;

    for i = 1, u8 do
        if u7[i] == p14 then
            u7[i] = u7[u8];
            u7[u8] = nil;
            u8 = u8 - 1;

            return;
        end;
    end;
end;

local function _isInStageSafeArea() -- Line: 138
    -- upvalues: u10 (ref), LocalPlayer (copy)
    if not u10 then
        local InStageSafeArea = LocalPlayer:FindFirstChild("InStageSafeArea");

        if not (InStageSafeArea and InStageSafeArea:IsA("NumberValue")) then
            return false;
        end;

        u10 = InStageSafeArea;
    end;

    return u10.Value > 0;
end;

local function _getInDungeonChallenge() -- Line: 155
    -- upvalues: u11 (ref), LocalPlayer (copy)
    if not u11 then
        local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");

        if not (InDungeonChallenge and InDungeonChallenge:IsA("NumberValue")) then
            return 0;
        end;

        u11 = InDungeonChallenge;
    end;

    local v15 = math.floor(u11.Value);

    return math.max(0, v15);
end;

local function _getDungeonAggroStage() -- Line: 172
    -- upvalues: u12 (ref), LocalPlayer (copy)
    if not u12 then
        local DungeonAggroStage = LocalPlayer:FindFirstChild("DungeonAggroStage");

        if not (DungeonAggroStage and DungeonAggroStage:IsA("NumberValue")) then
            return 0;
        end;

        u12 = DungeonAggroStage;
    end;

    local v16 = math.floor(u12.Value);

    return math.max(0, v16);
end;

local function _getEnemyStageId(p17) -- Line: 190
    local v18 = tonumber(p17:GetAttribute("Stage"));

    if v18 and v18 > 0 then
        return math.floor(v18);
    end;

    local v19 = tonumber(p17:GetAttribute("SpecialEnemyStageId"));

    if v19 and v19 > 0 then
        return math.floor(v19);
    end;

    return nil;
end;

local function _isEnemyInSameStage(p20) -- Line: 210
    -- upvalues: u11 (ref), LocalPlayer (copy), u10 (ref), u12 (ref)
    local v21 = tonumber(p20:GetAttribute("Stage"));
    local v22;

    if v21 and v21 > 0 then
        v22 = math.floor(v21);
    else
        local v23 = tonumber(p20:GetAttribute("SpecialEnemyStageId"));

        if v23 and v23 > 0 then
            v22 = math.floor(v23);
        else
            v22 = nil;
        end;
    end;

    if not v22 then
        return true;
    end;

    local v24;

    if not u11 then
        local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");

        if not (InDungeonChallenge and InDungeonChallenge:IsA("NumberValue")) then
            local v24;
            local v25 = 0;

            while true do
                if v25 == 0 then
                    v25 = -1;
                    v24 = 0;
                    v25 = 1;
                    continue;
                elseif v25 == 1 then
                    v25 = -1;

                    if v24 <= 0 then
                        return false;
                    end;

                    local v26;

                    if not u10 then
                        local InStageSafeArea = LocalPlayer:FindFirstChild("InStageSafeArea");

                        if not (InStageSafeArea and InStageSafeArea:IsA("NumberValue")) then
                            v26 = false;

                            if v26 then
                                return false;
                            end;

                            local v27;

                            if not u12 then
                                local DungeonAggroStage = LocalPlayer:FindFirstChild("DungeonAggroStage");

                                if not (DungeonAggroStage and DungeonAggroStage:IsA("NumberValue")) then
                                    v27 = 0;

                                    if v27 <= 0 then
                                        return false;
                                    end;

                                    return v27 == v22;
                                end;

                                u12 = DungeonAggroStage;
                            end;

                            local v28 = math.floor(u12.Value);
                            v27 = math.max(0, v28);
                            goto l0;
                        end;

                        u10 = InStageSafeArea;
                    end;

                    v26 = u10.Value > 0;
                    goto l1;
                else
                    break;
                end;
            end;
        end;

        u11 = InDungeonChallenge;
    end;

    local v29 = math.floor(u11.Value);
    v24 = math.max(0, v29);
    goto l2;
end;

local function _isTargetValid(p30) -- Line: 238
    -- upvalues: EnemyVisibilityUtil (copy), LocalPlayer (copy), u11 (ref), u10 (ref), u12 (ref)
    if not (p30 and p30.Parent) then
        return false;
    end;

    local v31 = p30:IsA("Model") and p30 and p30 or p30.Parent;

    if not v31:IsA("Model") then
        return false;
    end;

    local v32 = v31:FindFirstChildOfClass("Humanoid");

    if not v32 or v32.Health <= 0 then
        return false;
    end;

    if not EnemyVisibilityUtil.canPlayerSee(v31, LocalPlayer.UserId) then
        return false;
    end;

    local v33 = tonumber(v31:GetAttribute("Stage"));
    local v34;

    if v33 and v33 > 0 then
        v34 = math.floor(v33);
    else
        local v35 = tonumber(v31:GetAttribute("SpecialEnemyStageId"));

        if v35 and v35 > 0 then
            v34 = math.floor(v35);
        else
            v34 = nil;
        end;
    end;

    local v36;

    if not v34 then
        v36 = true;

        return v36 and true or false;
    end;

    local v37;

    if not u11 then
        local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");

        if not (InDungeonChallenge and InDungeonChallenge:IsA("NumberValue")) then
            local v37;
            local v38 = 0;

            while true do
                if v38 == 0 then
                    v38 = -1;
                    v37 = 0;
                    v38 = 1;
                    continue;
                elseif v38 == 1 then
                    v38 = -1;

                    if v37 <= 0 then
                        v36 = false;
                    else
                        local v39;

                        if u10 then
                            v39 = u10.Value > 0;
                            goto l2;
                        end;

                        local InStageSafeArea = LocalPlayer:FindFirstChild("InStageSafeArea");

                        if InStageSafeArea and InStageSafeArea:IsA("NumberValue") then
                            u10 = InStageSafeArea;
                            goto l3;
                        end;

                        v39 = false;

                        if not v39 then
                            local v40;

                            if not u12 then
                                local DungeonAggroStage = LocalPlayer:FindFirstChild("DungeonAggroStage");

                                if not (DungeonAggroStage and DungeonAggroStage:IsA("NumberValue")) then
                                    v40 = 0;

                                    if v40 <= 0 then
                                        v36 = false;
                                    else
                                        v36 = v40 == v34;
                                    end;

                                    return v36 and true or false;
                                end;

                                u12 = DungeonAggroStage;
                            end;

                            local v41 = math.floor(u12.Value);
                            v40 = math.max(0, v41);
                            goto l1;
                        end;

                        v36 = false;
                    end;

                    return v36 and true or false;
                else
                    break;
                end;
            end;
        end;

        u11 = InDungeonChallenge;
    end;

    local v42 = math.floor(u11.Value);
    v37 = math.max(0, v42);
    goto l4;
end;

local function _fireTargetLostOnce() -- Line: 267
    -- upvalues: u6 (ref), BindableEvent (copy)
    if u6 then
        return;
    end;

    u6 = true;
    BindableEvent:Fire();
end;

local function _clearTarget(p43) -- Line: 280
    -- upvalues: u5 (ref), ObjectValue (copy), u2 (copy), NowTarget (copy), u6 (ref), BindableEvent (copy)
    local v44 = p43 or {};
    u5 = nil;
    ObjectValue.Value = nil;
    u2.Adornee = nil;

    if v44.hideGui ~= false then
        NowTarget.Adornee = nil;
        NowTarget.Enabled = false;
    end;

    if v44.fireLost then
        if u6 then
            return;
        end;

        u6 = true;
        BindableEvent:Fire();
    end;
end;

local function _updateImageRotation(p45) -- Line: 299
    -- upvalues: ImageLabel (ref)
    if ImageLabel then
        ImageLabel.Rotation = p45 * 120 % 360;
    end;
end;

local function _getWeightedDistanceSq(p46, p47) -- Line: 312
    local v48 = p47.X - p46.X;
    local v49 = (p47.Y - p46.Y) * 2;
    local v50 = p47.Z - p46.Z;

    return v48 * v48 + v49 * v49 + v50 * v50;
end;

local function _refreshCurrentTargetIfInvalid(p51, p52, p53) -- Line: 326
    -- upvalues: u5 (ref), _isTargetValid (copy), ObjectValue (copy), u2 (copy), NowTarget (copy), u6 (ref), BindableEvent (copy), ImageLabel (ref)
    if not u5 then
        return;
    end;

    local v54 = u5;

    if not (v54.Parent and _isTargetValid(v54)) then
        local v55 = {
            fireLost = true
        } or {};
        u5 = nil;
        ObjectValue.Value = nil;
        u2.Adornee = nil;

        if v55.hideGui ~= false then
            NowTarget.Adornee = nil;
            NowTarget.Enabled = false;
        end;

        if v55.fireLost then
            if u6 then
                return;
            end;

            u6 = true;
            BindableEvent:Fire();
        end;

        return;
    end;

    local Position = v54.Position;
    local v56 = Position.X - p52.X;
    local v57 = (Position.Y - p52.Y) * 2;
    local v58 = Position.Z - p52.Z;

    if v56 * v56 + v57 * v57 + v58 * v58 <= 3600 then
        if ImageLabel then
            ImageLabel.Rotation = p53 * 120 % 360;
        end;

        return;
    end;

    local v59 = {
        fireLost = true
    } or {};
    u5 = nil;
    ObjectValue.Value = nil;
    u2.Adornee = nil;

    if v59.hideGui ~= false then
        NowTarget.Adornee = nil;
        NowTarget.Enabled = false;
    end;

    if v59.fireLost then
        if u6 then
            return;
        end;

        u6 = true;
        BindableEvent:Fire();
    end;
end;

local function _scanNearestTarget(p60) -- Line: 351
    -- upvalues: u8 (ref), u7 (copy), _isTargetValid (copy)
    local v61 = (1 / 0);
    local v62 = nil;

    for i = 1, u8 do
        local v63 = u7[i];

        if v63.Parent and _isTargetValid(v63) then
            local Position = v63.Position;
            local v64 = Position.X - p60.X;
            local v65 = (Position.Y - p60.Y) * 2;
            local v66 = Position.Z - p60.Z;
            local v67 = v64 * v64 + v65 * v65 + v66 * v66;

            if v67 <= 3600 and v61 > v67 then
                v62 = v63;
                v61 = v67;
            end;
        end;
    end;

    return v62;
end;

local function _applyTargetVisual(p68, p69, p70) -- Line: 383
    -- upvalues: u5 (ref), u2 (copy), ObjectValue (copy), NowTarget (copy), u6 (ref), ImageLabel (ref), BindableEvent (copy)
    u5 = p68;

    if p68 and p68.Parent then
        u2.Adornee = p68.Parent;
        ObjectValue.Value = p68;
        NowTarget.Adornee = p68;
        NowTarget.Enabled = true;
        u6 = false;

        if ImageLabel then
            ImageLabel.Rotation = p70 * 120 % 360;
        end;
    else
        ObjectValue.Value = nil;
        u2.Adornee = nil;
        NowTarget.Adornee = nil;
        NowTarget.Enabled = false;

        if p69 then
            if u6 then
                return;
            end;

            u6 = true;
            BindableEvent:Fire();
        end;
    end;
end;

local function _updateNowTarget() -- Line: 406
    -- upvalues: LocalPlayer (copy), u10 (ref), u5 (ref), ObjectValue (copy), u2 (copy), NowTarget (copy), u6 (ref), BindableEvent (copy), u3 (copy), u4 (ref), _refreshCurrentTargetIfInvalid (copy), _scanNearestTarget (copy), ImageLabel (ref)
    local v71 = tick();
    local Character = LocalPlayer.Character;
    local v72;

    if Character then
        v72 = Character:FindFirstChild("HumanoidRootPart");
    else
        v72 = Character;
    end;

    if not v72 then
        return;
    end;

    local v73, v74, v75, v76, v77, v78;

    if not u10 then
        local InStageSafeArea = LocalPlayer:FindFirstChild("InStageSafeArea");

        if not (InStageSafeArea and InStageSafeArea:IsA("NumberValue")) then
            v73 = false;

            if v73 then
                if u5 ~= nil then
                    v74 = {
                        fireLost = true
                    } or {};
                    u5 = nil;
                    ObjectValue.Value = nil;
                    u2.Adornee = nil;

                    if v74.hideGui ~= false then
                        NowTarget.Adornee = nil;
                        NowTarget.Enabled = false;
                    end;

                    if v74.fireLost then
                        if u6 then
                            return;
                        end;

                        u6 = true;
                        BindableEvent:Fire();
                    end;
                end;

                return;
            end;

            v75 = v72.Position;

            if u3 then
                u4 = u4 + 1;
                v76 = u4 % 2 == 0;
            else
                v76 = true;
            end;

            if not v76 then
                _refreshCurrentTargetIfInvalid(Character, v75, v71);

                return;
            end;

            v77 = u5 ~= nil;
            v78 = _scanNearestTarget(v75);
            u5 = v78;

            if v78 and v78.Parent then
                u2.Adornee = v78.Parent;
                ObjectValue.Value = v78;
                NowTarget.Adornee = v78;
                NowTarget.Enabled = true;
                u6 = false;

                if ImageLabel then
                    ImageLabel.Rotation = v71 * 120 % 360;

                    return;
                end;
            else
                ObjectValue.Value = nil;
                u2.Adornee = nil;
                NowTarget.Adornee = nil;
                NowTarget.Enabled = false;

                if v77 then
                    if u6 then
                        return;
                    end;

                    u6 = true;
                    BindableEvent:Fire();
                end;
            end;

            return;
        end;

        u10 = InStageSafeArea;
    end;

    v73 = u10.Value > 0;

    if v73 then
        if u5 ~= nil then
            v74 = {
                fireLost = true
            } or {};
            u5 = nil;
            ObjectValue.Value = nil;
            u2.Adornee = nil;

            if v74.hideGui ~= false then
                NowTarget.Adornee = nil;
                NowTarget.Enabled = false;
            end;

            if v74.fireLost then
                if u6 then
                    return;
                end;

                u6 = true;
                BindableEvent:Fire();
            end;
        end;

        return;
    end;

    v75 = v72.Position;

    if u3 then
        u4 = u4 + 1;
        v76 = u4 % 2 == 0;
    else
        v76 = true;
    end;

    if not v76 then
        _refreshCurrentTargetIfInvalid(Character, v75, v71);

        return;
    end;

    v77 = u5 ~= nil;
    v78 = _scanNearestTarget(v75);
    u5 = v78;

    if v78 and v78.Parent then
        u2.Adornee = v78.Parent;
        ObjectValue.Value = v78;
        NowTarget.Adornee = v78;
        NowTarget.Enabled = true;
        u6 = false;

        if ImageLabel then
            ImageLabel.Rotation = v71 * 120 % 360;
        end;
    else
        ObjectValue.Value = nil;
        u2.Adornee = nil;
        NowTarget.Adornee = nil;
        NowTarget.Enabled = false;

        if v77 then
            if u6 then
                return;
            end;

            u6 = true;
            BindableEvent:Fire();
        end;
    end;
end;

for _, v in CollectionService:GetTagged("Enemy") do
    if not u9[v] then
        u9[v] = true;
        u8 = u8 + 1;
        u7[u8] = v;
    end;
end;

CollectionService:GetInstanceAddedSignal("Enemy"):Connect(_addEnemy);
CollectionService:GetInstanceRemovedSignal("Enemy"):Connect(_removeEnemy);
task.spawn(function() -- Line: 447
    -- upvalues: LocalPlayer (copy), u10 (ref), u11 (ref), u12 (ref)
    local InStageSafeArea = LocalPlayer:WaitForChild("InStageSafeArea", (1 / 0));

    if InStageSafeArea and InStageSafeArea:IsA("NumberValue") then
        u10 = InStageSafeArea;
    end;

    local InDungeonChallenge = LocalPlayer:WaitForChild("InDungeonChallenge", (1 / 0));

    if InDungeonChallenge and InDungeonChallenge:IsA("NumberValue") then
        u11 = InDungeonChallenge;
    end;

    local DungeonAggroStage = LocalPlayer:WaitForChild("DungeonAggroStage", (1 / 0));

    if DungeonAggroStage and DungeonAggroStage:IsA("NumberValue") then
        u12 = DungeonAggroStage;
    end;
end);
RunService.Heartbeat:Connect(_updateNowTarget);