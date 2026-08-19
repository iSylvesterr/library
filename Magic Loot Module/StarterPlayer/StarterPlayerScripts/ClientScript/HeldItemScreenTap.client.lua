-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local HumanModule = UtilsSystem.HumanModule;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local LocalPlayer = UtilsSystem.LocalPlayer;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local u1 = false;
local u2 = false;
local u3 = nil;
local u4 = 0;
local u5 = 0;

local function _isScreenTapInput(p6) -- Line: 55
    return p6.UserInputType == Enum.UserInputType.MouseButton1 and true or p6.KeyCode == Enum.KeyCode.ButtonR2;
end;

local function _isInTrainGround() -- Line: 67
    -- upvalues: LocalPlayer (copy)
    local InTrainGround = LocalPlayer:FindFirstChild("InTrainGround");

    if InTrainGround and InTrainGround:IsA("BoolValue") then
        return InTrainGround.Value;
    end;

    return false;
end;

local function _canScreenTapNow() -- Line: 80
    -- upvalues: HumanModule (copy), LocalPlayer (copy)
    if not HumanModule.IsPlrCharAlive(LocalPlayer) then
        return false;
    end;

    local v7 = LocalPlayer:FindFirstChild("是否弹窗打开中");

    if v7 and (v7:IsA("BoolValue") and v7.Value) then
        return false;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        return false;
    end;

    return not LocalPlayer:FindFirstChild("退出炼金短暂不允许施法");
end;

local function _getHeldItemTypeValue() -- Line: 107
    -- upvalues: LocalPlayer (copy)
    local v8 = LocalPlayer:FindFirstChild("当前手持类型");

    return not (v8 and v8:IsA("NumberValue")) and 0 or v8.Value;
end;

local function _canSendTrainClick(p9) -- Line: 120
    -- upvalues: u5 (ref)
    if p9 - u5 < 0.15 then
        return false;
    end;

    u5 = p9;

    return true;
end;

local function _getScreenTapDebounceSec() -- Line: 133
    -- upvalues: LocalPlayer (copy), ItemType (copy)
    local v10 = LocalPlayer:FindFirstChild("当前手持类型");

    if (not (v10 and v10:IsA("NumberValue")) and 0 or v10.Value) == ItemType.Weapon then
        local InTrainGround = LocalPlayer:FindFirstChild("InTrainGround");
        local v11;

        if InTrainGround and InTrainGround:IsA("BoolValue") then
            v11 = InTrainGround.Value;
        else
            v11 = false;
        end;

        if not v11 then
            return 0.15;
        end;
    end;

    return 0.08;
end;

local function _tryDrinkHeldPotion() -- Line: 146
    -- upvalues: u1 (ref), LocalPlayer (copy), ItemType (copy), HumanModule (copy), NetWork (copy), NetMsg (copy)
    if u1 then
        return;
    end;

    local v12 = LocalPlayer:FindFirstChild("当前手持类型");

    if (not (v12 and v12:IsA("NumberValue")) and 0 or v12.Value) ~= ItemType.Potion then
        return;
    end;

    local v13, v14 = HumanModule.GetHeldItem(LocalPlayer);

    if not v13 or v14 ~= "Potion" then
        return;
    end;

    if v13:FindFirstChild("已使用过") then
        return;
    end;

    local u15 = v13:GetAttribute("OnlyID");

    if type(u15) ~= "number" or u15 <= 0 then
        return;
    end;

    u1 = true;
    task.spawn(function() -- Line: 170
        -- upvalues: NetWork (ref), NetMsg (ref), u15 (copy), u1 (ref)
        local success, result = pcall(function() -- Line: 171
            -- upvalues: NetWork (ref), NetMsg (ref), u15 (ref)
            return NetWork.InvokeServer(NetMsg.DRINK_POTION, {
                onlyID = u15
            });
        end);
        u1 = false;

        if not success then
            warn("[HeldItemScreenTap] DRINK_POTION InvokeServer failed:", result);
        end;
    end);
end;

local function _tryTrainWithWand() -- Line: 186
    -- upvalues: u2 (ref), u5 (ref), NetWork (copy), NetMsg (copy), u3 (ref)
    if u2 then
        return;
    end;

    local v16 = os.clock();
    local v17;

    if v16 - u5 < 0.15 then
        v17 = false;
    else
        u5 = v16;
        v17 = true;
    end;

    if not v17 then
        return;
    end;

    u2 = true;
    task.spawn(function() -- Line: 195
        -- upvalues: NetWork (ref), NetMsg (ref), u2 (ref), u3 (ref)
        local success, result = pcall(function() -- Line: 196
            -- upvalues: NetWork (ref), NetMsg (ref)
            return NetWork.InvokeServer(NetMsg.TRAIN_MANUAL_CLICK, {});
        end);
        u2 = false;

        if not success then
            return;
        end;

        if type(result) ~= "table" or result.ok ~= true then
            return;
        end;

        local v18 = tonumber(result.gain) or 0;

        if v18 <= 0 then
            return;
        end;

        NetWork.FireBindable(NetMsg.TRAIN_MANUAL_PRESENT, {
            gain = v18,
            screenPos = u3
        });
    end);
end;

local function _onScreenTap() -- Line: 223
    -- upvalues: u4 (ref), LocalPlayer (copy), ItemType (copy), _canScreenTapNow (copy), _tryDrinkHeldPotion (copy), _tryTrainWithWand (copy)
    local v19 = os.clock();
    local v20 = LocalPlayer:FindFirstChild("当前手持类型");
    local v21;

    if (not (v20 and v20:IsA("NumberValue")) and 0 or v20.Value) == ItemType.Weapon then
        local InTrainGround = LocalPlayer:FindFirstChild("InTrainGround");
        local v22;

        if InTrainGround and InTrainGround:IsA("BoolValue") then
            v22 = InTrainGround.Value;
        else
            v22 = false;
        end;

        v21 = v22 and 0.08 or 0.15;
    else
        v21 = 0.08;
    end;

    if v19 - u4 < v21 then
        return;
    end;

    u4 = v19;

    if not _canScreenTapNow() then
        return;
    end;

    local v23 = LocalPlayer:FindFirstChild("当前手持类型");
    local v24 = not (v23 and v23:IsA("NumberValue")) and 0 or v23.Value;

    if v24 == ItemType.Potion then
        _tryDrinkHeldPotion();

        return;
    end;

    if v24 == ItemType.Weapon then
        local InTrainGround = LocalPlayer:FindFirstChild("InTrainGround");
        local v25;

        if InTrainGround and InTrainGround:IsA("BoolValue") then
            v25 = InTrainGround.Value;
        else
            v25 = false;
        end;

        if v25 then
            return;
        end;

        _tryTrainWithWand();
    end;
end;

UserInputService.TouchTapInWorld:Connect(function(p26, p27) -- Line: 248
    -- upvalues: u3 (ref), _onScreenTap (copy)
    if p27 then
        return;
    end;

    u3 = p26;
    _onScreenTap();
end);
UserInputService.InputBegan:Connect(function(p28, p29) -- Line: 256
    -- upvalues: u3 (ref), _onScreenTap (copy)
    if p29 then
        return;
    end;

    if p28.UserInputType ~= Enum.UserInputType.MouseButton1 and p28.KeyCode ~= Enum.KeyCode.ButtonR2 then
        return;
    end;

    if p28.UserInputType == Enum.UserInputType.MouseButton1 then
        u3 = Vector2.new(p28.Position.X, p28.Position.Y);
    end;

    _onScreenTap();
end);