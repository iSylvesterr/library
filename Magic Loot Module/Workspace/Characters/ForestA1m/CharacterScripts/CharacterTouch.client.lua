-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local GetData = UtilsSystem.GetData;
local CollectionService = UtilsSystem.CollectionService;
local EnumMgr = UtilsSystem.EnumMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local InsMgr = UtilsSystem.InsMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local SystemPaidPotionDisplay = UtilsSystem.SystemPaidPotionDisplay;
local TipsModule = UtilsSystem.TipsModule;
local DwarfKingAppearPresentation = UtilsSystem.DwarfKingAppearPresentation;
local Parent = script.Parent.Parent;
local HumanoidRootPart = Parent:WaitForChild("HumanoidRootPart");
local u1 = nil;
local u2 = {};
local u3 = 0;
local u4 = nil;

local function _hasAnyBroom() -- Line: 85
    -- upvalues: PlayerData (copy), LocalPlayer (copy), EnumMgr (copy)
    local v5 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v5) ~= "table" then
        return false;
    end;

    local Broom = EnumMgr.ItemType.Broom;

    for _, v in pairs(v5) do
        if type(v) == "table" and (tonumber(v.tp) == Broom and (tonumber(v.count) or 0) > 0) then
            return true;
        end;
    end;

    return false;
end;

local function _isStillTouch(p6, p7) -- Line: 108
    local v8 = workspace:GetPartsInPart(p6);

    for _, v in pairs(v8) do
        if v == p7 then
            return true;
        end;
    end;

    local v9 = p6:GetTouchingParts();

    for _, v in pairs(v9) do
        if v == p7 then
            return true;
        end;
    end;

    return false;
end;

local function _getRunMaxClear() -- Line: 131
    -- upvalues: LocalPlayer (copy)
    local DungeonRunMaxClear = LocalPlayer:FindFirstChild("DungeonRunMaxClear");

    return not (DungeonRunMaxClear and DungeonRunMaxClear:IsA("NumberValue")) and 0 or math.floor(DungeonRunMaxClear.Value);
end;

local function _isWorldPointInsidePart(p10, p11) -- Line: 146
    local v12 = p10.CFrame:PointToObjectSpace(p11);
    local v13 = p10.Size * 0.5;
    local v14;

    if math.abs(v12.X) <= v13.X and math.abs(v12.Y) <= v13.Y then
        v14 = math.abs(v12.Z) <= v13.Z;
    else
        v14 = false;
    end;

    return v14;
end;

local function _getNextBattleAreaPart() -- Line: 160
    -- upvalues: LocalPlayer (copy)
    local DungeonRunMaxClear = LocalPlayer:FindFirstChild("DungeonRunMaxClear");
    local v15 = (not (DungeonRunMaxClear and DungeonRunMaxClear:IsA("NumberValue")) and 0 or math.floor(DungeonRunMaxClear.Value)) + 1;

    if v15 <= 0 then
        return nil, nil;
    end;

    local v16 = workspace:FindFirstChild("场景");

    if not v16 then
        return nil, nil;
    end;

    local v17 = v16:FindFirstChild((tostring(v15)));

    if not v17 then
        return nil, nil;
    end;

    local v18 = v17:FindFirstChild("战斗区域", true);

    if v18 and v18:IsA("BasePart") then
        return v18, v15;
    end;

    return nil, nil;
end;

local function _pollBattleAreaSpawn() -- Line: 189
    -- upvalues: LocalPlayer (copy), Parent (copy), _getNextBattleAreaPart (copy), DwarfKingAppearPresentation (copy), u4 (ref), HumanoidRootPart (copy), NetWork (copy), NetMsg (copy)
    local StageJumping = LocalPlayer:FindFirstChild("StageJumping");

    if StageJumping and (StageJumping:IsA("NumberValue") and StageJumping.Value == 1) then
        return;
    end;

    if Parent:GetAttribute("StageJumpAnimating") then
        return;
    end;

    local v19, u20 = _getNextBattleAreaPart();
    local v21 = DwarfKingAppearPresentation.IsPlaying();

    if not (v19 and u20) then
        if not v21 then
            u4 = nil;
        end;

        return;
    end;

    local v22 = v19.CFrame:PointToObjectSpace(HumanoidRootPart.Position);
    local v23 = v19.Size * 0.5;
    local v24;

    if math.abs(v22.X) <= v23.X and math.abs(v22.Y) <= v23.Y then
        v24 = math.abs(v22.Z) <= v23.Z;
    else
        v24 = false;
    end;

    if not v24 then
        if not v21 then
            u4 = nil;
        end;

        return;
    end;

    local DungeonRunMaxClear = LocalPlayer:FindFirstChild("DungeonRunMaxClear");
    local v25 = not (DungeonRunMaxClear and DungeonRunMaxClear:IsA("NumberValue")) and 0 or math.floor(DungeonRunMaxClear.Value);
    local v26 = tostring(u20) .. "_" .. tostring(v25);

    if u4 == v26 then
        return;
    end;

    u4 = v26;
    DwarfKingAppearPresentation.BeforeStageSpawn(u20, function() -- Line: 225
        -- upvalues: _getNextBattleAreaPart (ref), u20 (copy), HumanoidRootPart (ref), u4 (ref), NetWork (ref), NetMsg (ref)
        local v27, v28 = _getNextBattleAreaPart();

        if v27 and v28 == u20 then
            local v29 = v27.CFrame:PointToObjectSpace(HumanoidRootPart.Position);
            local v30 = v27.Size * 0.5;
            local v31;

            if math.abs(v29.X) <= v30.X and math.abs(v29.Y) <= v30.Y then
                v31 = math.abs(v29.Z) <= v30.Z;
            else
                v31 = false;
            end;

            if v31 then
                NetWork.FireServer(NetMsg.DUNGEON_SPAWN_STAGE, u20);

                return;
            end;
        end;

        u4 = nil;
    end);
end;

local function _isInDungeon() -- Line: 244
    -- upvalues: LocalPlayer (copy)
    local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");

    if InDungeonChallenge and InDungeonChallenge:IsA("NumberValue") then
        return InDungeonChallenge.Value > 0;
    end;

    return false;
end;

local function _isStillInCurrentTrainZone() -- Line: 257
    -- upvalues: u1 (ref), HumanoidRootPart (copy), GetData (copy)
    if not u1 then
        return false;
    end;

    for _, v in HumanoidRootPart:GetTouchingParts() do
        if v:IsA("BasePart") then
            local v32, v33 = GetData.Train.ResolveTrainFromTouch(v);

            if v32 and (v33 and v32 == u1) then
                return true;
            end;
        end;
    end;

    return false;
end;

local function _clearLocalTrainZone() -- Line: 277
    -- upvalues: u1 (ref)
    u1 = nil;

    return nil;
end;

local function _leaveTrainZone() -- Line: 287
    -- upvalues: u1 (ref), NetWork (copy), NetMsg (copy)
    if not u1 then
        return nil;
    end;

    NetWork.FireServer(NetMsg.TRAIN_ZONE_UPDATE, {
        trainId = nil
    });
    u1 = nil;

    return nil;
end;

local function _showTrainEnterFailTip(p34, p35) -- Line: 303
    -- upvalues: u2 (copy), TipsModule (copy), LocalPlayer (copy), SystemBuyRoblox (copy)
    local v36 = os.clock();

    if v36 - (u2[p34] or 0) < 2 then
        return nil;
    end;

    u2[p34] = v36;

    if p35.needRebirth then
        TipsModule.ErrorTips(LocalPlayer, "重生次数不足");
    elseif p35.needPass and (p35.passOnlyTag and SystemBuyRoblox) then
        SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, p35.passOnlyTag);
    end;

    return nil;
end;

local function _isStageJumpActive() -- Line: 324
    -- upvalues: LocalPlayer (copy), Parent (copy)
    local StageJumping = LocalPlayer:FindFirstChild("StageJumping");

    return StageJumping and (StageJumping:IsA("NumberValue") and StageJumping.Value == 1) and true or (Parent:GetAttribute("StageJumpAnimating") and true or false);
end;

local function _enterTrainZone(p37, p38) -- Line: 342
    -- upvalues: LocalPlayer (copy), Parent (copy), u1 (ref), GetData (copy), _showTrainEnterFailTip (copy), NetWork (copy), NetMsg (copy)
    local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");
    local v39;

    if InDungeonChallenge and InDungeonChallenge:IsA("NumberValue") then
        v39 = InDungeonChallenge.Value > 0;
    else
        v39 = false;
    end;

    if v39 then
        return nil;
    end;

    local StageJumping = LocalPlayer:FindFirstChild("StageJumping");

    if StageJumping and (StageJumping:IsA("NumberValue") and StageJumping.Value == 1) and true or (Parent:GetAttribute("StageJumpAnimating") and true or false) then
        return nil;
    end;

    if u1 == p37 then
        return nil;
    end;

    local v40 = GetData.Train.CanEnterTrainGround(LocalPlayer, p38);

    if not v40.ok then
        _showTrainEnterFailTip(p38, v40);

        return nil;
    end;

    u1 = p37;
    NetWork.FireServer(NetMsg.TRAIN_ZONE_UPDATE, {
        trainId = p38
    });

    return nil;
end;

local function _bindAutoTrainingMirrorClear() -- Line: 367
    -- upvalues: LocalPlayer (copy), u1 (ref)
    task.spawn(function() -- Line: 368
        -- upvalues: LocalPlayer (ref), u1 (ref)
        local IsAutoTraining = LocalPlayer:WaitForChild("IsAutoTraining", (1 / 0));

        if not IsAutoTraining:IsA("BoolValue") then
            return;
        end;

        IsAutoTraining.Changed:Connect(function() -- Line: 373
            -- upvalues: IsAutoTraining (copy), u1 (ref)
            if IsAutoTraining.Value == false then
                u1 = nil;
            end;
        end);
    end);

    return nil;
end;

task.spawn(function() -- Line: 368
    -- upvalues: LocalPlayer (copy), u1 (ref)
    local IsAutoTraining = LocalPlayer:WaitForChild("IsAutoTraining", (1 / 0));

    if not IsAutoTraining:IsA("BoolValue") then
        return;
    end;

    IsAutoTraining.Changed:Connect(function() -- Line: 373
        -- upvalues: IsAutoTraining (copy), u1 (ref)
        if IsAutoTraining.Value == false then
            u1 = nil;
        end;
    end);
end);
RunService.Heartbeat:Connect(function() -- Line: 387
    -- upvalues: u3 (ref), _pollBattleAreaSpawn (copy)
    local v41 = os.clock();

    if v41 - u3 < 0.2 then
        return;
    end;

    u3 = v41;
    _pollBattleAreaSpawn();
end);
HumanoidRootPart.Touched:Connect(function(p42) -- Line: 396
    -- upvalues: LocalPlayer (copy), NetWork (copy), NetMsg (copy), Parent (copy), _hasAnyBroom (copy), TipsModule (copy), InsMgr (copy), GetData (copy), _enterTrainZone (copy), CollectionService (copy), SystemPaidPotionDisplay (copy)
    if not p42 then
        return;
    end;

    if p42:GetAttribute("SafeArea") ~= nil and p42:GetAttribute("Stage") == nil then
        local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");
        local v43;

        if InDungeonChallenge and InDungeonChallenge:IsA("NumberValue") then
            v43 = InDungeonChallenge.Value > 0;
        else
            v43 = false;
        end;

        if v43 then
            NetWork.FireServer(NetMsg.DUNGEON_ABANDON_CHALLENGE);
        end;
    end;

    if p42:GetAttribute("openUI") then
        local StageJumping = LocalPlayer:FindFirstChild("StageJumping");

        if (not StageJumping or (not StageJumping:IsA("NumberValue") or StageJumping.Value ~= 1)) and not Parent:GetAttribute("StageJumpAnimating") then
            local v44 = p42:GetAttribute("openUIData");
            local v45 = p42:GetAttribute("openUI");

            if v45 == "StageJump" and not _hasAnyBroom() then
                TipsModule.ErrorTips(LocalPlayer, "拥有扫帚时才可以使用传送功能", nil);

                return;
            end;

            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");
            local v46 = PlayerGui and PlayerGui:FindFirstChild("ScreenGui");

            if v46 then
                local v47 = v46:FindFirstChild(v45);

                if v47 and v47.Visible then
                    return;
                end;
            end;

            InsMgr.GetIns("openUI", "StringValue", LocalPlayer).Value = v45;
            NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, v45, v44, true);
        end;
    end;

    local v48, v49 = GetData.Train.ResolveTrainFromTouch(p42);

    if v48 and v49 then
        _enterTrainZone(v48, v49);
    end;

    if CollectionService:HasTag(p42, "PaidPotionTouch") and SystemPaidPotionDisplay then
        SystemPaidPotionDisplay.OnEnterZone(p42);
    end;
end);
HumanoidRootPart.TouchEnded:Connect(function(p50) -- Line: 445
    -- upvalues: _isStillTouch (copy), HumanoidRootPart (copy), InsMgr (copy), LocalPlayer (copy), NetWork (copy), NetMsg (copy), GetData (copy), u1 (ref), _isStillInCurrentTrainZone (copy), CollectionService (copy), SystemPaidPotionDisplay (copy)
    if not p50 then
        return;
    end;

    if _isStillTouch(p50, HumanoidRootPart) then
        return;
    end;

    if p50:GetAttribute("openUI") then
        local v51 = p50:GetAttribute("openUI");
        InsMgr.GetIns("openUI", "StringValue", LocalPlayer).Value = "";
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, v51, nil, false);
    end;

    local v52, _ = GetData.Train.ResolveTrainFromTouch(p50);

    if v52 and (u1 == v52 and (not _isStillInCurrentTrainZone() and u1)) then
        NetWork.FireServer(NetMsg.TRAIN_ZONE_UPDATE, {
            trainId = nil
        });
        u1 = nil;
    end;

    if CollectionService:HasTag(p50, "PaidPotionTouch") and SystemPaidPotionDisplay then
        SystemPaidPotionDisplay.OnLeaveZone(p50);
    end;
end);