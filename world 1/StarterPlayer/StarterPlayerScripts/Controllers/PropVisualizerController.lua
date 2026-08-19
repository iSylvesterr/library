-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 4
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GardenSyncController = require(script.Parent.GardenSyncController);
local PlacementGrid = require(ReplicatedStorage.ClientModules.PlacementGrid);
local FakeSeat = require(script.FakeSeat);
local _ = Players.LocalPlayer;
local Gardens = workspace:WaitForChild("Gardens");
local Props = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Props");
local u2 = {};
local u3 = { "Teleport Pad", "Big Teleport Pad", "Huge Teleport Pad" };

function v1.Init(p4) -- Line: 18
end;

function v1.Start(u5) -- Line: 21
    -- upvalues: GardenSyncController (copy)
    GardenSyncController:OnPropAdded(function(p6, p7, p8) -- Line: 22
        -- upvalues: u5 (copy)
        u5:SpawnPropFromData(p6, p7, p8);
    end);
    GardenSyncController:OnPropRemoved(function(p9, p10) -- Line: 26
        -- upvalues: u5 (copy)
        u5:RemovePropById(p9, p10);
    end);
    GardenSyncController:OnPropExtraDataUpdated(function(p11, p12, p13) -- Line: 30
        -- upvalues: u5 (copy)
        u5:UpdatePropExtraData(p11, p12, p13);
    end);
end;

function v1.GetPlayerPlot(p14, p15) -- Line: 35
    -- upvalues: Players (copy), Gardens (copy)
    local v16 = Players:GetPlayerByUserId(p15);

    if not v16 then
        return nil;
    end;

    local v17 = v16:GetAttribute("PlotId");

    if v17 then
        return Gardens:FindFirstChild("Plot" .. v17);
    end;

    return nil;
end;

function v1.GetSpawnPoint(p18, p19) -- Line: 45
    local v20 = p18:GetPlayerPlot(p19);

    if v20 then
        return v20:FindFirstChild("SpawnPoint");
    end;

    return nil;
end;

function v1.GetPropsFolder(p21, p22) -- Line: 52
    local v23 = p21:GetPlayerPlot(p22);

    if not v23 then
        return nil;
    end;

    local Props2 = v23:FindFirstChild("Props");

    if not Props2 then
        Props2 = Instance.new("Folder");
        Props2.Name = "Props";
        Props2.Parent = v23;
    end;

    return Props2;
end;

function v1.SpawnPropFromData(p24, p25, p26, p27) -- Line: 66
    -- upvalues: u2 (copy), Props (copy), u3 (copy), PlacementGrid (copy), FakeSeat (copy)
    local v28 = `{p25}_{p26}`;

    if u2[v28] then
        p24:RemovePropById(p25, p26);
    end;

    local v29 = p24:GetSpawnPoint(p25);

    if not v29 then
        return;
    end;

    local v30 = p24:GetPropsFolder(p25);

    if not v30 then
        return;
    end;

    local PropName = p27.PropName;

    if not PropName then
        return;
    end;

    local v31 = Props:FindFirstChild(PropName);

    if not v31 then
        return;
    end;

    local v32 = v31:Clone();
    v32.Name = p26;
    v32:SetAttribute("PropId", p26);
    v32:SetAttribute("UserId", p25);
    v32:SetAttribute("PropName", PropName);
    v32:SetAttribute("ExtraData", p27.ExtraData or "");

    if v32:IsA("Model") then
        for _, descendant in v32:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;

                if descendant.Transparency >= 0.9 and not table.find(u3, PropName) then
                    descendant.CanQuery = false;
                end;
            end;
        end;

        if v32.PrimaryPart then
            v32.PrimaryPart.CanCollide = false;
        end;
    elseif v32:IsA("BasePart") then
        v32.Anchored = true;

        if v32.Transparency >= 0.9 and not table.find(u3, PropName) then
            v32.CanQuery = false;
        end;
    end;

    v32.Parent = v30;
    local v33 = Vector3.new(p27.Positions.PosX, p27.Positions.PosY, p27.Positions.PosZ);
    local v34 = p27.Positions.Rotation or 0;
    local v35 = v29.CFrame:PointToWorldSpace(v33);
    local v36;

    if p27.V == 2 then
        local v37 = PlacementGrid.GetGardenRotationY(v29);
        v36 = PlacementGrid.PositionModel(v32, v35, v37, v34);
    else
        local v38 = CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, math.rad(v34), 0);
        local _, v39, _ = v29.CFrame:ToWorldSpace(v38):ToEulerAnglesYXZ();
        v36 = CFrame.new(v35) * CFrame.Angles(0, v39, 0);
    end;

    if v32:IsA("Model") then
        v32:PivotTo(v36);
    elseif v32:IsA("BasePart") then
        v32.CFrame = v36;
    end;

    u2[v28] = v32;
    local v40 = script:FindFirstChild(PropName, true);

    if v40 then
        local _, _ = pcall(require(v40), v32);
    end;

    local _, _ = pcall(FakeSeat, v32);
end;

function v1.UpdatePropExtraData(p41, p42, p43, p44) -- Line: 159
    local v45 = p41:GetSpawnedProp(p42, p43);

    if v45 then
        v45:SetAttribute("ExtraData", p44 or "1");
    end;
end;

function v1.RemovePropById(p46, p47, p48) -- Line: 166
    -- upvalues: u2 (copy)
    local v49 = `{p47}_{p48}`;
    local v50 = u2[v49];

    if v50 then
        v50:Destroy();
        u2[v49] = nil;
    end;
end;

function v1.GetSpawnedProp(p51, p52, p53) -- Line: 176
    -- upvalues: u2 (copy)
    return u2[`{p52}_{p53}`];
end;

function v1.GetAllSpawnedProps(p54) -- Line: 181
    -- upvalues: u2 (copy)
    return u2;
end;

return v1;