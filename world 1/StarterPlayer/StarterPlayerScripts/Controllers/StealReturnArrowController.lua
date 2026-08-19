-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TutorialUtils = require(script.Parent.TutorialController.TutorialUtils);
local u1 = assert(Players.LocalPlayer);
local Gardens = workspace:WaitForChild("Gardens");
local v2 = {};
local u3 = nil;

local function getHomeSpawnPoint() -- Line: 20
    -- upvalues: u1 (copy), Gardens (copy)
    local v4 = u1:GetAttribute("PlotId");

    if v4 == nil then
        return nil;
    end;

    local v5 = Gardens:FindFirstChild((`Plot{v4}`));

    if not v5 then
        return nil;
    end;

    local SpawnPoint = v5:FindFirstChild("SpawnPoint");

    if SpawnPoint and SpawnPoint:IsA("BasePart") then
        return SpawnPoint;
    end;

    return nil;
end;

local function update() -- Line: 36
    -- upvalues: u1 (copy), u3 (ref), getHomeSpawnPoint (copy), TutorialUtils (copy)
    local v6 = u1:GetAttribute("CarryingStolenFruit") == true;

    if v6 and not u3 then
        local v7 = getHomeSpawnPoint();

        if v7 then
            u3 = TutorialUtils.createArrow(u1, CFrame.new(v7.Position)).destroy;
        end;
    elseif not v6 and u3 then
        u3();
        u3 = nil;
    end;
end;

function v2.Start(p8) -- Line: 50
    -- upvalues: u1 (copy), update (copy)
    u1:GetAttributeChangedSignal("CarryingStolenFruit"):Connect(update);
    update();
end;

return v2;