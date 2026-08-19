-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u1 = {};
local u2 = nil;

local function isPointInsidePart(p3, p4) -- Line: 37
    local v5 = p4.CFrame:PointToObjectSpace(p3);
    local v6 = p4.Size / 2;
    local v7;

    if math.abs(v5.X) <= v6.X and math.abs(v5.Y) <= v6.Y then
        v7 = math.abs(v5.Z) <= v6.Z;
    else
        v7 = false;
    end;

    return v7;
end;

local function stopHeartbeatIfIdle() -- Line: 48
    -- upvalues: u1 (copy), u2 (ref)
    if next(u1) == nil and u2 then
        u2:Disconnect();
        u2 = nil;
    end;
end;

local function stepZones(p8) -- Line: 57
    -- upvalues: Workspace (copy), u1 (copy), u2 (ref)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CFrame.Position;
    end;

    for i, v in pairs(u1) do
        if i:IsDescendantOf(Workspace) then
            if CurrentCamera then
                v.StepAccumulator = v.StepAccumulator + p8;

                if v.StepAccumulator >= 0.06666666666666667 then
                    local StepAccumulator = v.StepAccumulator;
                    v.StepAccumulator = 0;
                    local v9 = math.min(1, StepAccumulator * 3);
                    local v10 = i.CFrame:PointToObjectSpace(CurrentCamera);
                    local v11 = i.Size / 2;
                    local v12;

                    if math.abs(v10.X) <= v11.X and math.abs(v10.Y) <= v11.Y then
                        v12 = math.abs(v10.Z) <= v11.Z;
                    else
                        v12 = false;
                    end;

                    for _, v2 in ipairs(v.SoundDataList) do
                        local v13 = v12 and (v2.MaximumVolume or 0) or 0;
                        local Volume = v2.GlobalSound.Volume;
                        local v14 = v13 - Volume;

                        if math.abs(v14) <= 0.002 then
                            if Volume ~= v13 then
                                v2.GlobalSound.Volume = v13;
                            end;

                            v2.CurrentVolume = v13;
                        else
                            local v15 = Volume + v14 * v9;
                            v2.GlobalSound.Volume = v15;
                            v2.CurrentVolume = v15;
                        end;
                    end;
                end;
            end;
        else
            u1[i] = nil;
        end;
    end;

    if next(u1) == nil and u2 then
        u2:Disconnect();
        u2 = nil;
    end;
end;

local function ensureHeartbeat() -- Line: 106
    -- upvalues: u2 (ref), RunServiceController (copy), stepZones (copy)
    if u2 then
        return;
    end;

    u2 = RunServiceController.BindToHeartbeat("Observers.Game.AmbiencePart.UpdateZones", stepZones);
end;

return Observers.observeTag("AmbiencePart", function(u16) -- Line: 117
    -- upvalues: Janitor (copy), SoundService (copy), u1 (copy), u2 (ref), RunServiceController (copy), stepZones (copy)
    if not u16:IsDescendantOf(workspace) then
        return function() -- Line: 120
        end;
    end;

    local v17 = {};

    for _, child in u16:GetChildren() do
        if child:IsA("Sound") then
            table.insert(v17, child);
        end;
    end;

    if #v17 <= 0 then
        return function() -- Line: 135
        end;
    end;

    local u18 = Janitor.new();
    local v19 = {};

    for _, v in v17 do
        local v20 = u18:Add(v:Clone());
        v20.RollOffMode = Enum.RollOffMode.Inverse;
        v20.RollOffMaxDistance = 10000;
        v20.RollOffMinDistance = 10000;
        v20.Parent = SoundService;
        v20.PlayOnRemove = false;
        v20.Volume = 0;
        v20:Play();
        table.insert(v19, {
            CurrentVolume = 0,
            MaximumVolume = v.Volume > 0 and v.Volume or 1,
            GlobalSound = v20
        });
    end;

    u1[u16] = {
        StepAccumulator = 0,
        Part = u16,
        SoundDataList = v19
    };

    if not u2 then
        u2 = RunServiceController.BindToHeartbeat("Observers.Game.AmbiencePart.UpdateZones", stepZones);
    end;

    u18:Add(function() -- Line: 169
        -- upvalues: u1 (ref), u16 (copy), u2 (ref)
        u1[u16] = nil;

        if next(u1) == nil and u2 then
            u2:Disconnect();
            u2 = nil;
        end;
    end);

    return function() -- Line: 175
        -- upvalues: u18 (copy)
        u18:Cleanup();
    end;
end);