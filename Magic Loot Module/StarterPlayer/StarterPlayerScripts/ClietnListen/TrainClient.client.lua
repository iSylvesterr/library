-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TrainBillboard = require(script.TrainBillboard);
local TrainCrystalLockVisual = require(script.TrainCrystalLockVisual);
local TrainFxPresentation = require(script.TrainFxPresentation);
local TrainUiBridge = require(script.TrainUiBridge);

local function _isInDungeonChallenge() -- Line: 34
    -- upvalues: LocalPlayer (copy)
    local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");

    if InDungeonChallenge and InDungeonChallenge:IsA("NumberValue") then
        return InDungeonChallenge.Value > 0;
    end;

    return false;
end;

local function _bindDungeonLeaveTrain() -- Line: 101
    -- upvalues: LocalPlayer (copy), NetWork (copy), NetMsg (copy)
    task.spawn(function() -- Line: 102
        -- upvalues: LocalPlayer (ref), NetWork (ref), NetMsg (ref)
        local InDungeonChallenge = LocalPlayer:WaitForChild("InDungeonChallenge", (1 / 0));
        InDungeonChallenge.Changed:Connect(function() -- Line: 104
            -- upvalues: InDungeonChallenge (copy), NetWork (ref), NetMsg (ref)
            if InDungeonChallenge.Value > 0 then
                NetWork.FireServer(NetMsg.TRAIN_ZONE_UPDATE, {
                    trainId = nil
                });
            end;
        end);
    end);

    return nil;
end;

TrainBillboard.Init();
TrainFxPresentation.InitCrystalTriggerFx();
TrainCrystalLockVisual.Init();
TrainUiBridge.InitHideTrainUi();
(function() -- Line: 47, Name: _bindClientRemotes
    -- upvalues: NetWork (copy), NetMsg (copy), TrainUiBridge (copy), GetData (copy), TrainFxPresentation (copy), LocalPlayer (copy)
    NetWork.RegisterClientRemoteEvent(NetMsg.TRAIN_AUTO_TICK, function(p1) -- Line: 48
        -- upvalues: TrainUiBridge (ref)
        if type(p1) ~= "table" then
            return;
        end;

        local v2 = tonumber(p1.gain) or 0;

        if v2 > 0 then
            TrainUiBridge.playAutoPop(v2);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.TRAIN_STATE_SYNC, function(p3) -- Line: 58
        -- upvalues: GetData (ref), TrainFxPresentation (ref)
        if type(p3) ~= "table" then
            return;
        end;

        if p3.isAutoTraining == true then
            local v4 = tonumber(p3.trainId) or 0;

            if v4 > 0 then
                local v5 = GetData.Train.FindZonePartByTrainId(v4);
                TrainFxPresentation.SetActiveTrainPart(v5);
                TrainFxPresentation.StartAutoTrainPresentation(v4);
            end;

            return;
        end;

        TrainFxPresentation.StopAutoTrainPresentation();
        TrainFxPresentation.SetActiveTrainPart(nil);
    end);
    NetWork.RegisterBindableEvent(NetMsg.TRAIN_MANUAL_PRESENT, function(p6) -- Line: 76
        -- upvalues: TrainUiBridge (ref), LocalPlayer (ref), TrainFxPresentation (ref)
        if type(p6) ~= "table" then
            return;
        end;

        local v7 = tonumber(p6.gain) or 0;

        if v7 <= 0 then
            return;
        end;

        local screenPos = p6.screenPos;

        if typeof(screenPos) ~= "Vector2" then
            screenPos = nil;
        end;

        TrainUiBridge.playManualPop(v7, screenPos);
        local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");
        local v8;

        if InDungeonChallenge and InDungeonChallenge:IsA("NumberValue") then
            v8 = InDungeonChallenge.Value > 0;
        else
            v8 = false;
        end;

        if not v8 then
            TrainFxPresentation.TryPlayManualSelfStrike();
        end;
    end);

    return nil;
end)();
task.spawn(function() -- Line: 102
    -- upvalues: LocalPlayer (copy), NetWork (copy), NetMsg (copy)
    local InDungeonChallenge = LocalPlayer:WaitForChild("InDungeonChallenge", (1 / 0));
    InDungeonChallenge.Changed:Connect(function() -- Line: 104
        -- upvalues: InDungeonChallenge (copy), NetWork (ref), NetMsg (ref)
        if InDungeonChallenge.Value > 0 then
            NetWork.FireServer(NetMsg.TRAIN_ZONE_UPDATE, {
                trainId = nil
            });
        end;
    end);
end);