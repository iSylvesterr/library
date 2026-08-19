-- Decompiled with Potassium's decompiler.

local u1 = {
    StartOrder = 6,
    State = {
        CulledPlants = {}
    }
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;

function u1.Init(p2) -- Line: 18
end;

function u1.Start(p3) -- Line: 21
    -- upvalues: ReplicatedStorage (copy), u1 (copy), LocalPlayer (copy)
    local PlantVisualizerController = require(script.Parent.PlantVisualizerController);
    local PerfFlags = require(ReplicatedStorage.SharedModules.Flags.PerfFlags);
    local State = u1.State;
    local Plant_Cull_Range = LocalPlayer:WaitForChild("Settings"):WaitForChild("Plant_Cull_Range", 10);

    if not Plant_Cull_Range then
        return;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "CulledPlants";
    Folder.Parent = ReplicatedStorage;
    local Gardens = workspace:WaitForChild("Gardens");

    local function RestorePlant(u4, p5) -- Line: 39
        -- upvalues: Gardens (copy)
        local u6 = Gardens:FindFirstChild(p5);

        if u6 then
            u6 = u6:FindFirstChild("Plants");
        end;

        if u6 then
            return pcall(function() -- Line: 47
                -- upvalues: u4 (copy), u6 (copy)
                u4.Parent = u6;
            end);
        end;

        return false;
    end;

    local function RestoreAll() -- Line: 52
        -- upvalues: State (copy), Folder (copy), Gardens (copy)
        for i, v in State.CulledPlants do
            State.CulledPlants[i] = nil;

            if i.Parent == Folder then
                local u7 = Gardens:FindFirstChild(v);

                if u7 then
                    u7 = u7:FindFirstChild("Plants");
                end;

                if u7 then
                    pcall(function() -- Line: 47
                        -- upvalues: i (copy), u7 (copy)
                        i.Parent = u7;
                    end);
                end;
            end;
        end;
    end;

    task.spawn(function() -- Line: 62
        -- upvalues: LocalPlayer (ref), PerfFlags (copy), Plant_Cull_Range (copy), PlantVisualizerController (copy), State (copy), RestoreAll (copy), Gardens (copy), Folder (copy)
        local v8, v9;

        repeat
            while true do
                task.wait(0.4);

                if LocalPlayer:GetAttribute("AutoQualityActive") == true then
                    v9 = tonumber(LocalPlayer:GetAttribute("AutoQualityCullRange")) or 0;
                else
                    v9 = PerfFlags.PlantCullingManualRangeDisabled:Get() and 0 or Plant_Cull_Range.Value;
                end;

                if v9 > 0 and not PlantVisualizerController:GetOfflineCutsceneState() then
                    break;
                end;

                if next(State.CulledPlants) then
                    RestoreAll();
                end;
            end;

            v8 = workspace.CurrentCamera;
        until v8;

        debug.profilebegin("Controllers/PlantCullingController/Tick");
        local Position = v8.CFrame.Position;
        local X = Position.X;
        local Z = Position.Z;
        local v10 = v9 * v9;
        local v11 = (v9 * 0.9) ^ 2;
        local v12 = 0;
        local v13, v14, v15, v16;

        for i, v in State.CulledPlants do
            if i.Parent then
                if v12 >= 80 then
                    if false then
                        continue;
                    end;

                    for i2, child in Gardens:GetChildren() do
                        if v12 >= 80 then
                            debug.profileend();
                            continue;
                        end;

                        v13 = child:FindFirstChild("Plants");

                        if v13 then
                            for _, child2 in v13:GetChildren() do
                                if v12 >= 80 then
                                    break;
                                end;

                                if child2:IsA("Model") then
                                    v14 = child2:GetPivot().Position;
                                    v15 = v14.X - X;
                                    v16 = v14.Z - Z;

                                    if v10 < v15 * v15 + v16 * v16 and pcall(function() -- Line: 151
                                        -- upvalues: child2 (copy), Folder (ref)
                                        child2.Parent = Folder;
                                    end) then
                                        State.CulledPlants[child2] = child.Name;
                                        v12 = v12 + 1;
                                    end;
                                end;
                            end;
                        end;

                        if false then
                            continue;
                        end;
                    end;

                    debug.profileend();
                    continue;
                end;

                local Position2 = i:GetPivot().Position;
                local v17 = Position2.X - X;
                local v18 = Position2.Z - Z;

                if v17 * v17 + v18 * v18 <= v11 then
                    local u19 = Gardens:FindFirstChild(v);

                    if u19 then
                        u19 = u19:FindFirstChild("Plants");
                    end;

                    local v20;

                    if u19 then
                        v20 = pcall(function() -- Line: 47
                            -- upvalues: i (copy), u19 (copy)
                            i.Parent = u19;
                        end);
                    else
                        v20 = false;
                    end;

                    if v20 then
                        State.CulledPlants[i] = nil;
                        v12 = v12 + 1;
                    end;
                end;
            else
                State.CulledPlants[i] = nil;
            end;
        end;

        local v21, v22, v23;
        v21, v22, v23 = Gardens:GetChildren();

        for i2, child in Gardens:GetChildren() do
            if v12 >= 80 then
                debug.profileend();
                continue;
            end;

            v13 = child:FindFirstChild("Plants");

            if v13 then
                for _, child2 in v13:GetChildren() do
                    if v12 >= 80 then
                        break;
                    end;

                    if child2:IsA("Model") then
                        v14 = child2:GetPivot().Position;
                        v15 = v14.X - X;
                        v16 = v14.Z - Z;

                        if v10 < v15 * v15 + v16 * v16 and pcall(function() -- Line: 151
                            -- upvalues: child2 (copy), Folder (ref)
                            child2.Parent = Folder;
                        end) then
                            State.CulledPlants[child2] = child.Name;
                            v12 = v12 + 1;
                        end;
                    end;
                end;
            end;

            if false then
                continue;
            end;
        end;

        debug.profileend();
        continue;
    end);
end;

return u1;