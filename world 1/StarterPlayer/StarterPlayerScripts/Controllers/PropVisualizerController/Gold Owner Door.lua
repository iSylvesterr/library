-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Trove = require(game.ReplicatedStorage.ClientModules.Trove);
local DoorOpen = game.SoundService.SFX.DoorOpen;

return function(u1) -- Line: 11
    -- upvalues: Players (copy), Trove (copy), CollectionService (copy), DoorOpen (copy), RunService (copy)
    local Core = u1:WaitForChild("Main"):WaitForChild("Core");
    local Parent = Core.Parent;

    while true do
        local v2 = u1:GetAttribute("UserId");
        local u3;

        if typeof(v2) == "number" then
            u3 = Players:GetPlayerByUserId(v2);
        else
            u3 = nil;
        end;

        if not u3 then
            task.wait();
        end;

        if u3 then
            local v4 = Trove.new();
            v4:AttachToInstance(u1);
            local u5 = false;
            local u6 = 0;

            for _, child in Parent:GetChildren() do
                if child:IsA("BasePart") then
                    CollectionService:AddTag(child, "CrowbarDoor");
                    v4:Add(function() -- Line: 30
                        -- upvalues: child (copy), CollectionService (ref)
                        if child.Parent then
                            CollectionService:RemoveTag(child, "CrowbarDoor");
                        end;
                    end);
                end;
            end;

            local function setDoorState(p7) -- Line: 38
                -- upvalues: u5 (ref), DoorOpen (ref), Parent (copy)
                if p7 == u5 then
                    return;
                end;

                u5 = p7;

                if p7 then
                    DoorOpen:Play();
                end;

                for _, child in Parent:GetChildren() do
                    if child:IsA("BasePart") then
                        child.CanCollide = not p7;
                        child.Transparency = p7 and 0.5 or 0;
                    end;
                end;
            end;

            local function isNearFace() -- Line: 52
                -- upvalues: u3 (ref), Core (copy)
                local Character = u3.Character;

                if not Character then
                    return false;
                end;

                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                if not HumanoidRootPart then
                    return false;
                end;

                local v8 = Core.CFrame:PointToObjectSpace(HumanoidRootPart.Position);
                local v9 = Core.Size / 2;
                local v10;

                if math.abs(v8.Z) <= v9.Z + 2 and (math.abs(v8.X) <= v9.X + 2 and math.abs(v8.Y) <= v9.Y + 2) then
                    v10 = math.abs(v8.Z) >= v9.Z - 2;
                else
                    v10 = false;
                end;

                return v10;
            end;

            local u11 = 0;
            v4:Connect(RunService.Heartbeat, function(p12) -- Line: 67
                -- upvalues: u11 (ref), Core (copy), u1 (copy), setDoorState (copy), isNearFace (copy), u6 (ref)
                u11 = u11 + p12;

                if u11 < 0.1 then
                    return;
                end;

                u11 = 0;

                if not Core.Parent then
                    return;
                end;

                if u1:GetAttribute("ForcedOpen") then
                    setDoorState(true);

                    return;
                end;

                local v13 = isNearFace();

                if v13 then
                    u6 = os.clock();
                end;

                setDoorState(v13 or os.clock() - u6 < 2.5);
            end);

            return;
        end;
    end;
end;