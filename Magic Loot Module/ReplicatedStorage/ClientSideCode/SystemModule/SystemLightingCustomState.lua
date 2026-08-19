-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local ReplicatedStorage = UtilsSystem.ReplicatedStorage;
local u1 = { {
        StateName = "用户界面模糊背景",
        IsActive = false,
        StateHighWeight = 100,
        StateLowWeight = 0,
        StateObjectName = "用户界面模糊背景",
        StateObject = nil
    }, {
        StateName = "NPC对话背景模糊",
        IsActive = false,
        StateHighWeight = 90,
        StateLowWeight = 0,
        StateObjectName = "NPC对话背景模糊",
        StateObject = nil
    } };
local u2 = {};
u2.__index = u2;

local function _cloneStateDef(p3) -- Line: 73
    return {
        StateName = p3.StateName,
        IsActive = p3.IsActive,
        StateHighWeight = p3.StateHighWeight,
        StateLowWeight = p3.StateLowWeight,
        StateObjectName = p3.StateObjectName,
        StateObject = p3.StateObject
    };
end;

function u2.new() -- Line: 89
    -- upvalues: u2 (copy), ReplicatedStorage (copy), u1 (copy), Log (copy)
    local v4 = setmetatable({}, u2);
    v4.States = {};
    local LightingStates = ReplicatedStorage.Assets.LightingStates;

    for _, v in u1 do
        local v5 = {
            StateName = v.StateName,
            IsActive = v.IsActive,
            StateHighWeight = v.StateHighWeight,
            StateLowWeight = v.StateLowWeight,
            StateObjectName = v.StateObjectName,
            StateObject = v.StateObject
        };
        local v6 = LightingStates:FindFirstChild(v5.StateObjectName);

        if v6 then
            v5.StateObject = v6;
            v6:SetAttribute("StateHighWeight", v5.StateHighWeight);
            v6:SetAttribute("StateLowWeight", v5.StateLowWeight);
            v4.States[v5.StateName] = v5;
        else
            Log.warn("SystemLightingCustomState: 缺少状态对象", v5.StateName);
        end;
    end;

    return v4;
end;

function u2.setState(p7, p8, p9) -- Line: 117
    local v10 = p7.States[p8];

    if v10 then
        v10.IsActive = p9;
    end;
end;

function u2.hasState(p11, p12) -- Line: 130
    return p11.States[p12] ~= nil;
end;

function u2.isStateActive(p13, p14) -- Line: 140
    local v15 = p13.States[p14];
    local v16;

    if v15 == nil then
        v16 = false;
    else
        v16 = v15.IsActive == true;
    end;

    return v16;
end;

function u2.getCustomStateObjects(p17) -- Line: 150
    local v18 = {};

    for _, v in p17.States do
        if v.IsActive and v.StateObject then
            local ClassName = v.StateObject.ClassName;
            local v19 = v18[ClassName];

            if v19 then
                local v20 = v19:GetAttribute("StateHighWeight") or 0;

                if v20 < v.StateHighWeight then
                    v18[ClassName] = v.StateObject;
                elseif v.StateHighWeight == v20 and (v19:GetAttribute("StateLowWeight") or 0) < v.StateLowWeight then
                    v18[ClassName] = v.StateObject;
                end;
            else
                v18[ClassName] = v.StateObject;
            end;
        end;
    end;

    return v18;
end;

return u2;