-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local TrainGainPop = require(script.Parent.TrainGainPop);
local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = false;
local u7 = {
    UDim2.fromScale(0.25, 0.25),
    UDim2.fromScale(0.75, 0.25),
    UDim2.fromScale(0.25, 0.75),
    UDim2.fromScale(0.75, 0.75),
    UDim2.fromScale(0.5, 0.25),
    UDim2.fromScale(0.5, 0.75),
    UDim2.fromScale(0.25, 0.5),
    UDim2.fromScale(0.75, 0.5)
};

local function _resolveNodes() -- Line: 58
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), LocalPlayer (copy)
    if u2 and (u2.Parent and u3) then
        return u2, u3, u4 or u2;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("UIAnimGui");
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("TranUI");
    end;

    if not (PlayerGui and PlayerGui:IsA("Frame")) then
        return nil, nil, nil;
    end;

    local TrainTemp = PlayerGui:FindFirstChild("TrainTemp");
    local AutoTrain = PlayerGui:FindFirstChild("AutoTrain");

    if TrainTemp and TrainTemp:IsA("Frame") then
        TrainTemp.Visible = false;
    end;

    u2 = PlayerGui;

    if not (TrainTemp and TrainTemp:IsA("Frame")) then
        TrainTemp = nil;
    end;

    u3 = TrainTemp;

    if not (AutoTrain and AutoTrain:IsA("Frame")) then
        AutoTrain = nil;
    end;

    u4 = AutoTrain;

    return u2, u3, u4 or u2;
end;

local function _applyHideTrainUi(p8) -- Line: 85
    -- upvalues: u6 (ref), _resolveNodes (copy)
    u6 = p8 == 1;
    local v9 = _resolveNodes();

    if not v9 then
        return nil;
    end;

    v9.Visible = not u6;

    return nil;
end;

local function _getPopAnimSec() -- Line: 101
    -- upvalues: GetData (copy)
    local v10 = GetData.Train.GetTrainValue("飘字停留秒");
    local v11 = GetData.Train.GetTrainValue("飘字淡出秒");
    local v12 = type(v10) ~= "number" and 0.5 or v10;

    if type(v11) == "number" then
        return v12, v11;
    end;

    return v12, 0.25;
end;

function u1.screenToTranUiPos(p13) -- Line: 114
    -- upvalues: _resolveNodes (copy)
    local v14 = _resolveNodes();

    if not v14 then
        return nil;
    end;

    local AbsolutePosition = v14.AbsolutePosition;
    local AbsoluteSize = v14.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return nil;
    end;

    return UDim2.fromScale((p13.X - AbsolutePosition.X) / AbsoluteSize.X, (p13.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
end;

function u1.pickAutoTrainPopPos() -- Line: 135
    -- upvalues: _resolveNodes (copy), u7 (copy), u5 (ref)
    local _, _, v15 = _resolveNodes();

    if not v15 then
        return nil;
    end;

    local v16 = math.random(1, #u7);

    if u5 and #u7 > 1 then
        while v16 == u5 do
            v16 = math.random(1, #u7);
        end;
    end;

    u5 = v16;

    return u7[v16];
end;

function u1.playManualPop(p17, p18) -- Line: 157
    -- upvalues: u6 (ref), _resolveNodes (copy), u1 (copy), GetData (copy), TrainGainPop (copy)
    if u6 then
        return nil;
    end;

    local v19, v20 = _resolveNodes();

    if not (v19 and v20) then
        return nil;
    end;

    local v21 = UDim2.fromScale(0.5, 0.5);

    if p18 then
        v21 = u1.screenToTranUiPos(p18) or v21;
    end;

    local v22 = GetData.Train.GetTrainValue("飘字停留秒");
    local v23 = GetData.Train.GetTrainValue("飘字淡出秒");
    local v24 = type(v22) ~= "number" and 0.5 or v22;
    local v25 = type(v23) ~= "number" and 0.25 or v23;
    TrainGainPop.Play(v20, v19, p17, v21, {
        randomDirection = true,
        holdSec = v24,
        fadeSec = v25
    });

    return nil;
end;

function u1.playAutoPop(p26) -- Line: 187
    -- upvalues: u6 (ref), _resolveNodes (copy), GetData (copy), TrainGainPop (copy), u1 (copy)
    if u6 then
        return nil;
    end;

    local _, v27, v28 = _resolveNodes();

    if not (v27 and v28) then
        return nil;
    end;

    local v29 = GetData.Train.GetTrainValue("飘字停留秒");
    local v30 = GetData.Train.GetTrainValue("飘字淡出秒");
    local v31 = type(v29) ~= "number" and 0.5 or v29;
    local v32 = type(v30) ~= "number" and 0.25 or v30;
    TrainGainPop.Play(v27, v28, p26, u1.pickAutoTrainPopPos(), {
        randomDirection = true,
        holdSec = v31,
        fadeSec = v32
    });

    return nil;
end;

function u1.InitHideTrainUi() -- Line: 209
    -- upvalues: LocalPlayer (copy), AddListen (copy), _applyHideTrainUi (copy)
    task.spawn(function() -- Line: 210
        -- upvalues: LocalPlayer (ref), AddListen (ref), _applyHideTrainUi (ref)
        local HideTrainUI = LocalPlayer:WaitForChild("Setting", (1 / 0)):WaitForChild("HideTrainUI", (1 / 0));
        LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("UIAnimGui", (1 / 0)):WaitForChild("TranUI", (1 / 0));

        if HideTrainUI and HideTrainUI:IsA("NumberValue") then
            AddListen.NumValueAdd(HideTrainUI, _applyHideTrainUi, true);
        end;
    end);

    return nil;
end;

return u1;