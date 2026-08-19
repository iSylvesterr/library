-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local AnimationModule = UtilsSystem.AnimationModule;
local HumanModule = UtilsSystem.HumanModule;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local u1 = {};

local function _stopHeldItemAnims(p2) -- Line: 30
    -- upvalues: AnimationModule (copy)
    AnimationModule.StopAnimByModel(p2, "拿药水", 0.1);
    AnimationModule.StopAnimByModel(p2, "手持材料动作", 0.1);

    return nil;
end;

local function _applyHeldTypeForPlayer(p3, p4) -- Line: 42
    -- upvalues: HumanModule (copy), ItemType (copy), AnimationModule (copy)
    local v5 = HumanModule.GetCharacter(p3);

    if not v5 then
        return nil;
    end;

    if p4 == ItemType.Potion or p4 == ItemType.Material then
        AnimationModule.StopAnimByModel(v5, "手持材料动作", 0.1);
        AnimationModule.PlayAnimByModel(v5, "拿药水", 1, nil, nil, Enum.AnimationPriority.Action, 0.1);

        return nil;
    end;

    AnimationModule.StopAnimByModel(v5, "拿药水", 0.1);
    AnimationModule.StopAnimByModel(v5, "手持材料动作", 0.1);

    return nil;
end;

local function _bindPlayer(u6) -- Line: 85
    -- upvalues: u1 (copy), AddListen (copy), _applyHeldTypeForPlayer (copy)
    if u1[u6] then
        return nil;
    end;

    local v7 = u6:WaitForChild("当前手持类型", (1 / 0));

    if not (v7 and v7:IsA("NumberValue")) then
        return nil;
    end;

    u1[u6] = AddListen.NumValueAdd(v7, function(p8) -- Line: 95
        -- upvalues: _applyHeldTypeForPlayer (ref), u6 (copy)
        _applyHeldTypeForPlayer(u6, p8);
    end, true);
    u6.CharacterAdded:Connect(function() -- Line: 99
        -- upvalues: u6 (copy), _applyHeldTypeForPlayer (ref)
        local v9 = u6:FindFirstChild("当前手持类型");

        if v9 and v9:IsA("NumberValue") then
            _applyHeldTypeForPlayer(u6, v9.Value);
        end;
    end);

    return nil;
end;

local function _unbindPlayer(p10) -- Line: 71
    -- upvalues: u1 (copy)
    local v11 = u1[p10];

    if v11 then
        v11:Disconnect();
        u1[p10] = nil;
    end;

    return nil;
end;

for _, v in ipairs(Players:GetPlayers()) do
    task.spawn(_bindPlayer, v);
end;

Players.PlayerAdded:Connect(function(p12) -- Line: 112
    -- upvalues: _bindPlayer (copy)
    task.spawn(_bindPlayer, p12);
end);
Players.PlayerRemoving:Connect(_unbindPlayer);