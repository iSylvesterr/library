-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local _ = UtilsSystem.CfgFind;
local HumanModule = UtilsSystem.HumanModule;
local PlayerData = UtilsSystem.PlayerData;
local Players = UtilsSystem.Players;
local u29 = {
    GetPlayerByID = function(p1) -- Line: 36, Name: GetPlayerByID
        -- upvalues: Players (copy)
        local v2 = tonumber(p1);

        if v2 then
            return Players:GetPlayerByUserId(v2);
        end;

        return nil;
    end,

    FindNearestPlayer = function(p3, p4) -- Line: 50, Name: FindNearestPlayer
        -- upvalues: Players (copy)
        if typeof(p3) ~= "Vector3" then
            return nil;
        end;

        local v5 = tonumber(p4);

        if not v5 or v5 <= 0 then
            return nil;
        end;

        local v6 = nil;

        for _, v in Players:GetPlayers() do
            local Character = v.Character;

            if Character then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                    local Magnitude = (HumanoidRootPart.Position - p3).Magnitude;

                    if Magnitude <= v5 then
                        v6 = HumanoidRootPart;
                        v5 = Magnitude;
                    end;
                end;
            end;
        end;

        return v6;
    end,

    GetSetting = function(p7, p8) -- Line: 83, Name: GetSetting
        -- upvalues: RunService (copy), PlayerData (copy)
        if not p7 or (type(p8) ~= "string" or p8 == "") then
            return nil;
        end;

        local Setting = p7:FindFirstChild("Setting");

        if Setting then
            local v9 = Setting:FindFirstChild(p8);

            if v9 and v9:IsA("NumberValue") then
                return v9.Value;
            end;
        end;

        if RunService:IsClient() then
            local v10 = PlayerData.GetPlrDataByKey(p7, { "Setting", p8 });

            if v10 ~= nil then
                return tonumber(v10);
            end;
        end;

        return nil;
    end,

    IsHasPass = function(p11, p12) -- Line: 112, Name: IsHasPass
        if not p11 or (type(p12) ~= "string" or p12 == "") then
            return false;
        end;

        local GamePass = p11:FindFirstChild("GamePass");

        if not GamePass then
            return false;
        end;

        local v13 = GamePass:FindFirstChild(p12);

        if v13 and v13:IsA("NumberValue") then
            return v13.Value > 0;
        end;

        return false;
    end,

    IsPlrInPotionFlow = function(p14) -- Line: 136, Name: IsPlrInPotionFlow
        if not p14 then
            return false;
        end;

        local v15 = p14:FindFirstChild("进入炼药游戏");

        if v15 and (v15:IsA("NumberValue") and v15.Value ~= 0) then
            return true;
        end;

        local v16 = p14:FindFirstChild("材料选择中");
        local v17;

        if v16 == nil then
            v17 = false;
        else
            v17 = v16:IsA("BoolValue") and v16.Value == true;
        end;

        return v17;
    end,

    GetExpByLv = function(p18) -- Line: 154, Name: GetExpByLv
        local v19 = 1.095 ^ (p18 - 1) * 45;
        local v20 = math.log10(v19);
        local v21 = 10 ^ (math.floor(v20) - 2);
        local v22 = math.floor(v19 / v21 + 0.5) * v21;

        return math.floor(v22);
    end,

    parseGuideName = function(p23) -- Line: 167, Name: parseGuideName
        local v24 = tostring(p23);
        local v25 = string.find(v24, "|", 1, true);

        if not v25 then
            return v24, 1;
        end;

        local v26 = string.sub(v24, 1, v25 - 1);
        local v27 = string.sub(v24, v25 + 1):match("^%s*(.-)%s*$");
        local v28 = tonumber(v27) or 1;

        return v26, v28 < 1 and 1 or v28;
    end
};

function u29.GetGuideStageCfg(p30, p31) -- Line: 190
    -- upvalues: u29 (copy)
    local Cfg = (type(p31) ~= "table" and {} or p31).Cfg;

    if type(Cfg) ~= "table" then
        return nil;
    end;

    local v32, v33 = u29.parseGuideName(p30);
    local v34 = Cfg[v32];

    if type(v34) ~= "table" then
        return nil;
    end;

    local v35 = v34[tostring(v33)] or v34["1"];

    if type(v35) == "table" then
        return v35;
    end;

    return nil;
end;

function u29.IsGuideStageEnemy(p36, p37, p38) -- Line: 216
    -- upvalues: u29 (copy)
    local v39 = u29.GetGuideStageCfg(p36, p37);
    local v40;

    if v39 == nil or v39.enemy == nil then
        v40 = false;
    else
        v40 = v39.enemy == p38;
    end;

    return v40;
end;

function u29.IsGuideStageBestDrop(p41, p42) -- Line: 228
    -- upvalues: u29 (copy)
    local v43 = u29.GetGuideStageCfg(p41, p42);

    if not v43 then
        return false;
    end;

    local bestDrop = v43.bestDrop;
    local v44;

    if bestDrop == nil or bestDrop == false then
        v44 = false;
    else
        v44 = bestDrop ~= 0;
    end;

    return v44;
end;

function u29.FindGuideEnemyPart(p45, p46) -- Line: 244
    -- upvalues: HumanModule (copy), CollectionService (copy)
    if not p45 or p46 == nil then
        return nil;
    end;

    local EntitiesPos = workspace:FindFirstChild("EntitiesPos");
    local v47;

    if EntitiesPos then
        v47 = EntitiesPos:FindFirstChild((tostring(p46)));
    else
        v47 = nil;
    end;

    local v48 = HumanModule.GetHumanoidRootPart(p45);

    if not v48 then
        if v47 and v47:IsA("BasePart") then
            return v47;
        end;

        return nil;
    end;

    local v49 = (1 / 0);
    local v50 = nil;

    for _, v in ipairs(CollectionService:GetTagged("Enemy")) do
        if v:IsA("BasePart") then
            local Parent = v.Parent;

            if Parent and Parent:GetAttribute("ID") == p46 then
                local Magnitude = (v.Position - v48.Position).Magnitude;

                if Magnitude < v49 then
                    v50 = v;
                    v49 = Magnitude;
                end;
            end;
        end;
    end;

    if v50 then
        return v50;
    end;

    if v47 and v47:IsA("BasePart") then
        return v47;
    end;

    return nil;
end;

function u29.FindBestClientDropPart() -- Line: 293
    local DropsClient = workspace:FindFirstChild("DropsClient");

    if not DropsClient then
        return nil;
    end;

    local v51 = -1;
    local v52 = nil;

    for _, child in DropsClient:GetChildren() do
        for _, child2 in child:GetChildren() do
            if child2:IsA("Model") then
                local PrimaryPart = child2.PrimaryPart;

                if PrimaryPart and PrimaryPart:IsA("BasePart") then
                    local v53 = tonumber(child2:GetAttribute("GoldValue")) or 0;

                    if v51 < v53 then
                        v52 = PrimaryPart;
                        v51 = v53;
                    end;
                end;
            end;
        end;
    end;

    return v52;
end;

function u29.WaitRedPointValue(p54, p55) -- Line: 328
    if not p54 then
        error("GetData.WaitRedPointValue: plr is required");
    end;

    if type(p55) ~= "string" or p55 == "" then
        error("GetData.WaitRedPointValue: redName is required");
    end;

    return p54:WaitForChild("RedPoint", (1 / 0)):WaitForChild(p55, (1 / 0));
end;

function u29.GetRedPointValue(p56, p57) -- Line: 345
    if not p56 or (type(p57) ~= "string" or p57 == "") then
        return 0;
    end;

    local RedPoint = p56:FindFirstChild("RedPoint");

    if not (RedPoint and RedPoint:IsA("Folder")) then
        return 0;
    end;

    local v58 = RedPoint:FindFirstChild(p57);

    if not (v58 and v58:IsA("NumberValue")) then
        return 0;
    end;

    local v59 = tonumber(v58.Value) or 0;
    local v60 = math.floor(v59);

    return math.max(0, v60);
end;

function u29.IsRedPointActive(p61, p62) -- Line: 366
    -- upvalues: u29 (copy)
    return u29.GetRedPointValue(p61, p62) > 0;
end;

function u29.GetIsFly(p63) -- Line: 375
    if not (p63 and p63.Parent) then
        return false;
    end;

    local v64 = p63:FindFirstChild("飞行状态");

    if v64 and v64:IsA("BoolValue") then
        return v64.Value == true;
    end;

    return false;
end;

function u29.IsInDungeonChallenge(p65) -- Line: 393
    if not (p65 and p65.Parent) then
        return false;
    end;

    local InDungeonChallenge = p65:FindFirstChild("InDungeonChallenge");

    if InDungeonChallenge and InDungeonChallenge:IsA("NumberValue") then
        return InDungeonChallenge.Value > 0;
    end;

    return false;
end;

return u29;