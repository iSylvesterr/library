-- Decompiled with Potassium's decompiler.

local v1 = {};
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local SeedData = require(game.ReplicatedStorage.SharedModules.SeedData);
require(script.Parent.Parent);
local Gardens = game.Workspace.Gardens;

local function castGroundRay(p2, p3) -- Line: 15
    local v4 = game.Workspace:Raycast(p2, p3, nil);

    if not v4 then
        return v4, 0;
    end;

    if not v4.Instance then
        return v4, 0;
    end;

    if v4.Instance.Transparency < 0.99 then
        return v4, 0;
    end;

    local v5 = RaycastParams.new();
    v5.FilterType = (nil).FilterType;
    v5.IgnoreWater = (nil).IgnoreWater;
    v5.RespectCanCollide = (nil).RespectCanCollide;
    v5.FilterDescendantsInstances = (nil).FilterDescendantsInstances;
    v5:AddToFilter(v4.Instance);

    for i = 1, 8 do
        local v6 = game.Workspace:Raycast(p2, p3, v5);

        if not v6 then
            return v6, i;
        end;

        if not v6.Instance then
            return v6, i;
        end;

        if v6.Instance.Transparency < 0.99 then
            return v6, i;
        end;

        v5:AddToFilter(v6.Instance);
    end;

    return nil, 8;
end;

local function returnConstraints(p7) -- Line: 47
    return p7.PetPivot, p7.PetAlignPos, p7.PetAlignOri;
end;

function v1.Init(p8) -- Line: 57
    -- upvalues: Networking (copy), Gardens (copy), SeedData (copy)
    function Networking.ReturnNearestFruit.ReturnNearestFruit.OnClientInvoke(p9, p10) -- Line: 58
        -- upvalues: Gardens (ref), SeedData (ref)
        local v11 = game.Players:FindFirstChild(p10);

        if not (v11 and v11.Parent) then
            return nil;
        end;

        local v12 = v11:GetAttribute("PlotId");

        if not v12 then
            return nil;
        end;

        local v13 = Gardens:FindFirstChild("Plot" .. v12);

        if not v13 then
            return nil;
        end;

        local v14 = (1 / 0);
        local v15 = nil;

        for _, child in pairs(v13.Plants:GetChildren()) do
            local v16 = nil;

            for _, v in pairs(SeedData) do
                if v.SeedName == child:GetAttribute("SeedName") then
                    v16 = v;
                    break;
                end;
            end;

            if v16 then
                if v16.IsSingleHarvest == true then
                    local Magnitude = (child.PrimaryPart.Position - p9).Magnitude;

                    if Magnitude < v14 then
                        v15 = child;
                        v14 = Magnitude;
                    end;
                else
                    for _, child2 in pairs(child.Fruits:GetChildren()) do
                        local Magnitude = (child2.PrimaryPart.Position - p9).Magnitude;

                        if Magnitude < v14 then
                            v15 = child2;
                            v14 = Magnitude;
                        end;
                    end;
                end;
            end;
        end;

        if v15 then
            return v15.Name, v15.PrimaryPart.Position;
        end;
    end;

    Networking.Raccoon.RaccoonWalkToPoint.OnClientEvent:Connect(function(p17, p18, p19, p20) -- Line: 98
    end);
end;

function v1.PlayerEnteredGarden(p21) -- Line: 104
end;

return v1;