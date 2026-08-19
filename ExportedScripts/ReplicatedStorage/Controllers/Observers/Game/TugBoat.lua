-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);

local function UpdateBoat(p1, p2, p3, p4) -- Line: 19
    p3[1] = p3[1] + p2;
    local Handle = p1.Handle;

    if not (Handle and Handle:IsDescendantOf(workspace)) then
        return;
    end;

    if not p4[1] then
        p4[1] = Handle.CFrame;
    end;

    local v5 = p4[1];
    local v6 = p3[1];
    local v7 = math.sin(v6 * 0.8) * 0.05235987755982989;
    local v8 = math.cos(v6 * 0.8 * 0.7) * 0.05235987755982989 * 0.8;
    local v9 = math.sin(v6 * 0.5) * 0.15;
    local v10 = math.sin(v6 * 1.2) * 0.1;
    local v11 = v5.LookVector * v9 + Vector3.new(0, v10, 0);
    local v12 = v5.Position + v11;
    local v13 = CFrame.Angles(v7, 0, 0);
    local v14 = CFrame.Angles(0, 0, v8);
    local v15 = v5 * v13 * v14;
    Handle.CFrame = v15 + (v12 - v15.Position);
end;

return Observers.observeTag("TugBoat", function(u16) -- Line: 64
    -- upvalues: Janitor (copy), RunServiceController (copy), UpdateBoat (copy)
    if u16:IsDescendantOf(workspace) then
        local u17 = Janitor.new();
        local u18 = { nil };
        local u19 = { 0 };
        local v20 = RunServiceController.CreateBindingName("Observers.Game.TugBoat.Update");
        u17:Add(RunServiceController.BindToHeartbeat(v20, function(p21) -- Line: 75
            -- upvalues: UpdateBoat (ref), u16 (copy), u19 (copy), u18 (copy)
            UpdateBoat(u16, p21, u19, u18);
        end));

        return function() -- Line: 80
            -- upvalues: u17 (copy)
            u17:Destroy();
        end;
    end;
end);