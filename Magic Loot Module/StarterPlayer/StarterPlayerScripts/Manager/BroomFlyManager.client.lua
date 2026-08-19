-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local UserInputService = UtilsSystem.UserInputService;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local Flight = require(script.Flight);
local F = Enum.KeyCode.F;

local function _isOnBroom() -- Line: 22
    -- upvalues: LocalPlayer (copy)
    local v1 = LocalPlayer:FindFirstChild("飞行状态");
    local v2;

    if v1 == nil then
        v2 = false;
    else
        v2 = v1:IsA("BoolValue") and v1.Value == true;
    end;

    return v2;
end;

local function _isStageJumping() -- Line: 31
    -- upvalues: LocalPlayer (copy)
    local StageJumping = LocalPlayer:FindFirstChild("StageJumping");
    local v3;

    if StageJumping == nil then
        v3 = false;
    else
        v3 = StageJumping:IsA("NumberValue") and StageJumping.Value > 0;
    end;

    return v3;
end;

LocalPlayer.CharacterAdded:Connect(function(p4) -- Line: 36, Name: onCharacterAdded
    -- upvalues: Flight (copy)
    Flight.CharacterAdded(p4);
end);

if LocalPlayer.Character then
    Flight.CharacterAdded(LocalPlayer.Character);
end;

UserInputService.InputBegan:Connect(function(p5, p6) -- Line: 45
    -- upvalues: UserInputService (copy), F (copy), LocalPlayer (copy), SystemGameConfig (copy), NetWork (copy), NetMsg (copy)
    if p6 and UserInputService:GetFocusedTextBox() ~= nil then
        return;
    end;

    if p5.UserInputType ~= Enum.UserInputType.Keyboard then
        return;
    end;

    if p5.KeyCode ~= F then
        return;
    end;

    local v7 = LocalPlayer:FindFirstChild("飞行状态");
    local v8;

    if v7 == nil then
        v8 = false;
    else
        v8 = v7:IsA("BoolValue") and v7.Value == true;
    end;

    if not v8 and SystemGameConfig.GetValue({ "Broom", "启用" }) == false then
        return;
    end;

    local v9 = LocalPlayer:FindFirstChild("飞行状态");
    local v10;

    if v9 == nil then
        v10 = false;
    else
        v10 = v9:IsA("BoolValue") and v9.Value == true;
    end;

    if v10 then
        local StageJumping = LocalPlayer:FindFirstChild("StageJumping");
        local v11;

        if StageJumping == nil then
            v11 = false;
        else
            v11 = StageJumping:IsA("NumberValue") and StageJumping.Value > 0;
        end;

        if v11 then
            return;
        end;
    end;

    task.spawn(function() -- Line: 64
        -- upvalues: NetWork (ref), NetMsg (ref)
        local success, result = pcall(function() -- Line: 65
            -- upvalues: NetWork (ref), NetMsg (ref)
            NetWork.InvokeServer(NetMsg.TOGGLE_BROOM);
        end);

        if not success then
            warn("[BroomFlyManager] TOGGLE_BROOM failed:", result);
        end;
    end);
end);