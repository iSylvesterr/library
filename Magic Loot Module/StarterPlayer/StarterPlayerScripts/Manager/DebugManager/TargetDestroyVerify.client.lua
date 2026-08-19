-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local WorldUtil = UtilsSystem.WorldUtil;
local Log = UtilsSystem.Log;
local u1 = CFrame.new(0, -1000, 0);

if not WorldUtil.IsDebugEnabled() then
    return;
end;

local u2 = 0;
local u3 = nil;
local u4 = nil;

local function _isFeatureEnabled() -- Line: 48
    -- upvalues: Workspace (copy)
    return Workspace:GetAttribute("EnableTargetDestroyVerify") == true;
end;

local function _stopPositionHold() -- Line: 57
    -- upvalues: u3 (ref), u4 (ref)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u4 = nil;
end;

local function _startPositionHold(p5) -- Line: 71
    -- upvalues: u3 (ref), u4 (ref), RunService (copy), u1 (copy)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u4 = nil;
    local u6 = os.clock() + 5;
    u4 = p5;
    u3 = RunService.Heartbeat:Connect(function() -- Line: 77
        -- upvalues: u6 (copy), u3 (ref), u4 (ref), u1 (ref)
        if u6 <= os.clock() then
            if u3 then
                u3:Disconnect();
                u3 = nil;
            end;

            u4 = nil;

            return;
        end;

        local u7 = u4;

        if u7 and u7.Parent then
            pcall(function() -- Line: 87
                -- upvalues: u7 (copy), u1 (ref)
                u7:PivotTo(u1);
            end);

            return;
        end;

        if u3 then
            u3:Disconnect();
            u3 = nil;
        end;

        u4 = nil;
    end);
end;

local function _pivotCurrentTargetToDestroyZone() -- Line: 98
    -- upvalues: Workspace (copy), ReplicatedStorage (copy), u1 (copy), Log (copy), u3 (ref), u4 (ref), RunService (copy)
    if Workspace:GetAttribute("EnableTargetDestroyVerify") ~= true then
        return;
    end;

    local NowTargetCurrent = ReplicatedStorage:FindFirstChild("NowTargetCurrent");

    if not (NowTargetCurrent and NowTargetCurrent:IsA("ObjectValue")) then
        return;
    end;

    local Value = NowTargetCurrent.Value;

    if typeof(Value) ~= "Instance" or not Value:IsA("BasePart") then
        return;
    end;

    local u8 = Value:FindFirstAncestorOfClass("Model");

    if not u8 then
        return;
    end;

    local success, result = pcall(function() -- Line: 118
        -- upvalues: u8 (copy), u1 (ref)
        u8:PivotTo(u1);
    end);

    if not success then
        Log.warn("[TargetDestroyVerify] PivotTo failed:", u8.Name, result);

        return;
    end;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u4 = nil;
    local u9 = os.clock() + 5;
    u4 = u8;
    u3 = RunService.Heartbeat:Connect(function() -- Line: 77
        -- upvalues: u9 (copy), u3 (ref), u4 (ref), u1 (ref)
        if u9 <= os.clock() then
            if u3 then
                u3:Disconnect();
                u3 = nil;
            end;

            u4 = nil;

            return;
        end;

        local u10 = u4;

        if u10 and u10.Parent then
            pcall(function() -- Line: 87
                -- upvalues: u10 (copy), u1 (ref)
                u10:PivotTo(u1);
            end);

            return;
        end;

        if u3 then
            u3:Disconnect();
            u3 = nil;
        end;

        u4 = nil;
    end);
    Log.print("[TargetDestroyVerify] client PivotTo destroy zone (hold 5s):", u8.Name);
end;

UserInputService.InputBegan:Connect(function(p11, p12) -- Line: 130
    -- upvalues: Workspace (copy), u2 (ref), _pivotCurrentTargetToDestroyZone (copy)
    if p12 then
        return;
    end;

    if p11.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return;
    end;

    if Workspace:GetAttribute("EnableTargetDestroyVerify") ~= true then
        return;
    end;

    local v13 = os.clock();

    if v13 - u2 < 0.1 then
        return;
    end;

    u2 = v13;
    _pivotCurrentTargetToDestroyZone();
end);
Log.print("[TargetDestroyVerify] loaded; set workspace.EnableTargetDestroyVerify=true to enable");