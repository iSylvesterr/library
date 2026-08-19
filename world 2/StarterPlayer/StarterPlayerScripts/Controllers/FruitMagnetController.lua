-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local MagnetEffect = require(ReplicatedStorage.ClientModules.MagnetEffect);
local MagnetData = require(ReplicatedStorage.SharedModules.MagnetData);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local PlantBehaviorRules = require(ReplicatedStorage.SharedModules.PlantBehaviorRules);
local u1 = {};
local v2 = {};

for _, v in SeedData do
    if v.SeedName then
        u1[v.SeedName] = v.IsSingleHarvest == true;
    end;
end;

local function getFruitMagnetRange() -- Line: 41
    -- upvalues: MagnetData (copy)
    for _, v in MagnetData.Data do
        if v.Name == "Fruit Magnet" then
            return v.Range or 63;
        end;
    end;

    return 63;
end;

local u3 = 63;

for _, v in MagnetData.Data do
    if v.Name == "Fruit Magnet" then
        u3 = v.Range or 63;
        break;
    end;
end;

local u4 = {};
local u5 = {};
local u6 = {};
local u7 = false;

local function isFruitMagnet(p8) -- Line: 67
    local v9 = p8:IsA("Tool") and p8:GetAttribute("FruitMagnet") ~= nil;

    return v9;
end;

local function getModelPosition(u10) -- Line: 74
    if u10:IsA("BasePart") then
        return u10.Position;
    end;

    if u10:IsA("Model") then
        local PrimaryPart = u10.PrimaryPart;

        if PrimaryPart then
            return PrimaryPart.Position;
        end;

        local success, result = pcall(function() -- Line: 83
            -- upvalues: u10 (copy)
            return u10:GetPivot();
        end);

        if success then
            return result.Position;
        end;
    end;

    return nil;
end;

local function isRipe(p11) -- Line: 96
    local v12 = p11:GetAttribute("Age");
    local v13 = p11:GetAttribute("MaxAge");

    return (typeof(v12) ~= "number" or typeof(v13) ~= "number") and true or v13 <= v12;
end;

local function considerCandidate(p14, p15, p16, p17, p18, p19, p20) -- Line: 107
    -- upvalues: getModelPosition (copy)
    local v21 = p15:GetAttribute("Age");
    local v22 = p15:GetAttribute("MaxAge");

    if typeof(v21) == "number" and typeof(v22) == "number" and v22 > v21 then
        return;
    end;

    local v23 = getModelPosition(p15);

    if not v23 then
        return;
    end;

    if p17 < (v23 - p16).Magnitude then
        return;
    end;

    table.insert(p14, {
        ownerUserId = p18,
        plantId = p19,
        fruitId = p20
    });
end;

local function scanFruitInRange(p24, p25) -- Line: 138
    -- upvalues: PlantBehaviorRules (copy), u1 (copy), considerCandidate (copy)
    local v26 = {};
    local Gardens = workspace:FindFirstChild("Gardens");

    if not Gardens then
        return v26;
    end;

    for _, child in Gardens:GetChildren() do
        local Plants = child:FindFirstChild("Plants");

        if Plants then
            for _, child2 in Plants:GetChildren() do
                local v27 = tonumber(child2:GetAttribute("UserId"));
                local v28 = child2:GetAttribute("PlantId");

                if v27 and typeof(v28) == "string" then
                    local v29 = child2:GetAttribute("SeedName");

                    if not PlantBehaviorRules.GrowsForever(v29) then
                        local v30;

                        if typeof(v29) == "string" then
                            v30 = u1[v29] == true;
                        else
                            v30 = false;
                        end;

                        if v30 then
                            considerCandidate(v26, child2, p24, p25, v27, v28, "");
                        else
                            local Fruits = child2:FindFirstChild("Fruits");

                            if Fruits then
                                for _, child3 in Fruits:GetChildren() do
                                    local v31 = child3:GetAttribute("FruitId");

                                    if typeof(v31) == "string" then
                                        considerCandidate(v26, child3, p24, p25, v27, v28, v31);
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v26;
end;

local u32 = {};
local u33 = nil;
local u34 = Color3.fromRGB(0, 255, 0);
local u35 = Color3.fromRGB(255, 40, 40);
local u36 = Color3.fromRGB(255, 200, 0);
local u37 = Color3.fromRGB(255, 255, 255);
local u38 = Color3.fromRGB(90, 90, 90);

local function setDebugHighlight(p39, p40) -- Line: 208
    -- upvalues: u32 (copy)
    local v41 = u32[p39];

    if not v41 or v41.Parent ~= p39 then
        v41 = Instance.new("Highlight");
        v41.Name = "FruitMagnetDebug";
        v41.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
        v41.FillTransparency = 0.4;
        v41.OutlineTransparency = 0;
        v41.Adornee = p39;
        v41.Parent = p39;
        u32[p39] = v41;
    end;

    v41.FillColor = p40;
    v41.OutlineColor = p40;
end;

local function updateDebugSphere(p42, p43) -- Line: 224
    -- upvalues: u33 (ref)
    if not (u33 and u33.Parent) then
        local Part = Instance.new("Part");
        Part.Name = "FruitMagnetRangeDebug";
        Part.Shape = Enum.PartType.Ball;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Material = Enum.Material.ForceField;
        Part.Color = Color3.fromRGB(0, 170, 255);
        Part.Transparency = 0.6;
        Part.Parent = workspace;
        u33 = Part;
    end;

    u33.Size = Vector3.new(p43 * 2, p43 * 2, p43 * 2);
    u33.CFrame = CFrame.new(p42);
end;

local function clearDebugVisuals() -- Line: 243
    -- upvalues: u32 (copy), u33 (ref)
    for _, v in u32 do
        v:Destroy();
    end;

    table.clear(u32);

    if u33 then
        u33:Destroy();
        u33 = nil;
    end;
end;

local function debugVisualizeScan(u44, u45) -- Line: 259
    -- upvalues: updateDebugSphere (copy), u1 (copy), getModelPosition (copy), u37 (copy), u38 (copy), u36 (copy), LocalPlayer (copy), u34 (copy), u35 (copy), u32 (copy)
    updateDebugSphere(u44, u45);
    local u46 = u45 * 1.5;
    local u47 = {};
    local u48 = {
        total = 0,
        inRange = 0,
        collect = 0,
        steal = 0,
        unripeInRange = 0
    };
    local Gardens = workspace:FindFirstChild("Gardens");

    if Gardens then
        for _, child in Gardens:GetChildren() do
            local Plants = child:FindFirstChild("Plants");

            if Plants then
                for _, child2 in Plants:GetChildren() do
                    local u49 = tonumber(child2:GetAttribute("UserId"));
                    local v50 = child2:GetAttribute("PlantId");

                    if u49 and typeof(v50) == "string" then
                        local v51 = child2:GetAttribute("SeedName");
                        local v52;

                        if typeof(v51) == "string" then
                            v52 = u1[v51] == true;
                        else
                            v52 = false;
                        end;

                        local function markModel(p53) -- Line: 282
                            -- upvalues: getModelPosition (ref), u44 (copy), u46 (copy), u47 (copy), u48 (copy), u45 (copy), u37 (ref), u38 (ref), u36 (ref), u49 (copy), LocalPlayer (ref), u34 (ref), u35 (ref), u32 (ref)
                            local v54 = getModelPosition(p53);

                            if not v54 then
                                return;
                            end;

                            local Magnitude = (v54 - u44).Magnitude;

                            if u46 < Magnitude then
                                return;
                            end;

                            u47[p53] = true;
                            local v55 = u48;
                            v55.total = v55.total + 1;
                            local v56 = Magnitude <= u45;
                            local v57 = p53:GetAttribute("Age");
                            local v58 = p53:GetAttribute("MaxAge");
                            local v59 = (typeof(v57) ~= "number" or typeof(v58) ~= "number") and true or v58 <= v57;

                            if v56 then
                                local v60 = u48;
                                v60.inRange = v60.inRange + 1;
                            end;

                            local v61;

                            if v56 then
                                if v59 then
                                    if u49 == LocalPlayer.UserId then
                                        local v62 = u48;
                                        v62.collect = v62.collect + 1;
                                        v61 = u34;
                                    else
                                        local v63 = u48;
                                        v63.steal = v63.steal + 1;
                                        v61 = u35;
                                    end;
                                else
                                    local v64 = u48;
                                    v64.unripeInRange = v64.unripeInRange + 1;
                                    v61 = u36;
                                end;
                            else
                                v61 = v59 and u37 or u38;
                            end;

                            local v65 = u32[p53];

                            if not v65 or v65.Parent ~= p53 then
                                v65 = Instance.new("Highlight");
                                v65.Name = "FruitMagnetDebug";
                                v65.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                                v65.FillTransparency = 0.4;
                                v65.OutlineTransparency = 0;
                                v65.Adornee = p53;
                                v65.Parent = p53;
                                u32[p53] = v65;
                            end;

                            v65.FillColor = v61;
                            v65.OutlineColor = v61;
                        end;

                        if v52 then
                            markModel(child2);
                        else
                            local Fruits = child2:FindFirstChild("Fruits");

                            if Fruits then
                                for _, child3 in Fruits:GetChildren() do
                                    markModel(child3);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local v66 = {};

    for i in u32 do
        if not u47[i] then
            table.insert(v66, i);
        end;
    end;

    for _, v in v66 do
        local v67 = u32[v];

        if v67 then
            v67:Destroy();
        end;

        u32[v] = nil;
    end;

    return u48;
end;

local function isOnCooldown(p68) -- Line: 348
    local v69 = p68:GetAttribute("CooldownEnd");
    local v70;

    if typeof(v69) == "number" then
        v70 = os.clock() < v69;
    else
        v70 = false;
    end;

    return v70;
end;

local function resolveRig(p71) -- Line: 356
    local Handle = p71:FindFirstChild("Handle");

    if Handle and (Handle:IsA("BasePart") and Handle:FindFirstChild("Start")) then
        return Handle;
    end;

    local Start = p71:FindFirstChild("Start", true);

    if Start and (Start.Parent and Start.Parent:IsA("BasePart")) then
        return Start.Parent;
    end;

    return nil;
end;

local function ensureSetup(p72) -- Line: 370
    -- upvalues: u4 (copy), resolveRig (copy), MagnetEffect (copy)
    if u4[p72] then
        return true;
    end;

    local v73 = resolveRig(p72);

    if not v73 then
        for _ = 1, 20 do
            task.wait(0.1);

            if not p72:IsDescendantOf(game) then
                return false;
            end;

            v73 = resolveRig(p72);

            if v73 then
                break;
            end;
        end;
    end;

    if not v73 then
        if p72:IsDescendantOf(game) then
            warn((`[FruitMagnet] tool "{p72.Name}" has no rig part containing "Start" (looked at Handle + child parts). MagnetEffect cannot play -- the tool model needs a part with Start/Glow/Beams.`));
        end;

        return false;
    end;

    for _, v in { "Glow", "Beams" } do
        if not v73:FindFirstChild(v) then
            warn((`[FruitMagnet] tool "{p72.Name}" rig part "{v73.Name}" is missing "{v}" -- MagnetEffect may error.`));
        end;
    end;

    local success, result = pcall(MagnetEffect.Setup, p72);

    if success then
        u4[p72] = true;

        return true;
    end;

    warn((`[FruitMagnet] MagnetEffect.Setup failed for "{p72.Name}": {result}`));
    u4[p72] = false;

    return false;
end;

local function runVacuumSession(p74, p75) -- Line: 427
    -- upvalues: u7 (ref), LocalPlayer (copy), debugVisualizeScan (copy), scanFruitInRange (copy), Networking (copy), u32 (copy), u33 (ref)
    if u7 then
        return;
    end;

    u7 = true;
    local v76 = os.clock();
    local v77 = 0;
    local v78 = {};

    while os.clock() - v76 < p75 do
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character.PrimaryPart;
        end;

        if not Character then
            break;
        end;

        local v79 = debugVisualizeScan(Character.Position, p74);

        if os.clock() - v77 >= 1 then
            v77 = os.clock();
            print(string.format("[FruitMagnet][debug] range=%.0f | nearby=%d inRange=%d -> collect=%d steal=%d unripe=%d", p74, v79.total, v79.inRange, v79.collect, v79.steal, v79.unripeInRange));
        end;

        local v80 = scanFruitInRange(Character.Position, p74);
        local v81 = os.clock();
        local v82 = false;

        for _, v in v80 do
            local v83 = string.format("%d_%s_%s", v.ownerUserId, v.plantId, v.fruitId);
            local v84 = v78[v83];

            if not v84 or v81 - v84 >= 1.5 then
                if v.ownerUserId == LocalPlayer.UserId then
                    v78[v83] = v81;
                    Networking.Garden.CollectFruit:Fire(v.plantId, v.fruitId);
                elseif not v82 then
                    v78[v83] = v81;
                    Networking.Steal.BeginSteal:Fire(v.ownerUserId, v.plantId, v.fruitId);
                    Networking.Steal.CompleteSteal:Fire();
                    v82 = true;
                end;
            end;
        end;

        task.wait(0.1);
    end;

    for _, v in u32 do
        v:Destroy();
    end;

    table.clear(u32);

    if u33 then
        u33:Destroy();
        u33 = nil;
    end;

    u7 = false;
end;

local function playEffect(u85, u86, p87, p88) -- Line: 506
    -- upvalues: u6 (copy), ensureSetup (copy), MagnetEffect (copy), Players (copy)
    if u6[u85] then
        return;
    end;

    if not ensureSetup(u85) then
        return;
    end;

    u6[u85] = true;
    local u89 = p87 * 2;
    task.spawn(function() -- Line: 526
        -- upvalues: MagnetEffect (ref), u86 (copy), u85 (copy), u89 (copy)
        local success, result = pcall(MagnetEffect.Enable, u86, u85, u89);

        if not success then
            warn((`[FruitMagnet] MagnetEffect.Enable errored: {result}`));
        end;
    end);
    local v90 = os.clock();
    local v91 = {};

    while true do
        local v92 = os.clock() - v90 < p88 and u86.PrimaryPart;

        if not v92 then
            break;
        end;

        local Position = v92.Position;
        local v93 = {};

        for _, v in Players:GetPlayers() do
            if v.Character ~= u86 then
                local Character = v.Character;
                local v94;

                if Character then
                    v94 = Character.PrimaryPart;
                else
                    v94 = Character;
                end;

                if v94 and (v94.Position - Position).Magnitude <= p87 then
                    v93[Character] = true;

                    if not v91[Character] then
                        v91[Character] = true;
                        local success, result = pcall(MagnetEffect.AddTarget, u85, Character);

                        if not success then
                            warn((`[FruitMagnet] AddTarget failed for {v.Name}: {result}`));
                        end;
                    end;
                end;
            end;
        end;

        for i in v91 do
            if not v93[i] then
                v91[i] = nil;
                pcall(MagnetEffect.RemoveTarget, u85, i);
            end;
        end;

        task.wait(0.15);
    end;

    local success, result = pcall(MagnetEffect.Disable, u86, u85);

    if not success then
        warn((`[FruitMagnet] MagnetEffect.Disable errored: {result}`));
    end;

    u6[u85] = nil;
end;

local function onActivateBroadcast(p95, p96, p97) -- Line: 587
    -- upvalues: playEffect (copy), u3 (copy), LocalPlayer (copy), runVacuumSession (copy)
    if not (p95 and p95:IsA("Tool")) then
        return;
    end;

    local Parent = p95.Parent;

    if not (Parent and (Parent:IsA("Model") and Parent:FindFirstChildOfClass("Humanoid"))) then
        return;
    end;

    task.spawn(playEffect, p95, Parent, p96 or u3, p97 or 10);

    if Parent == LocalPlayer.Character then
        task.spawn(runVacuumSession, p96 or u3, p97 or 10);
    end;
end;

local function bindTool(u98) -- Line: 610
    -- upvalues: ensureSetup (copy), u5 (copy), u4 (copy), u6 (copy)
    local v99 = u98:IsA("Tool") and u98:GetAttribute("FruitMagnet") ~= nil;

    if not v99 then
        return;
    end;

    task.spawn(ensureSetup, u98);

    if not u5[u98] then
        u5[u98] = u98.Activated:Connect(function() -- Line: 620
            -- upvalues: u98 (copy)
            local v100 = u98:GetAttribute("CooldownEnd");
            local v101;

            if typeof(v100) == "number" then
                v101 = os.clock() < v100;
            else
                v101 = false;
            end;

            if v101 then
                return;
            end;

            u98:SetAttribute("CooldownEnd", os.clock() + 60);
        end);
    end;

    u98.AncestryChanged:Connect(function() -- Line: 630
        -- upvalues: u98 (copy), u5 (ref), u4 (ref), u6 (ref)
        if not u98:IsDescendantOf(game) then
            if u5[u98] then
                u5[u98]:Disconnect();
                u5[u98] = nil;
            end;

            u4[u98] = nil;
            u6[u98] = nil;
        end;
    end);
end;

local function watchContainer(p102) -- Line: 642
    -- upvalues: bindTool (copy)
    for _, child in p102:GetChildren() do
        bindTool(child);
    end;

    p102.ChildAdded:Connect(bindTool);
end;

function v2.Init(p103) -- Line: 649
end;

function v2.Start(p104) -- Line: 651
    -- upvalues: Networking (copy), onActivateBroadcast (copy), LocalPlayer (copy), bindTool (copy)
    Networking.FruitMagnet.Activate.OnClientEvent:Connect(onActivateBroadcast);
    local Backpack = LocalPlayer:WaitForChild("Backpack");

    for _, child in Backpack:GetChildren() do
        bindTool(child);
    end;

    Backpack.ChildAdded:Connect(bindTool);

    if LocalPlayer.Character then
        local Character = LocalPlayer.Character;

        for _, child in Character:GetChildren() do
            bindTool(child);
        end;

        Character.ChildAdded:Connect(bindTool);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p105) -- Line: 660
        -- upvalues: bindTool (ref)
        for _, child in p105:GetChildren() do
            bindTool(child);
        end;

        p105.ChildAdded:Connect(bindTool);
    end);
end;

return v2;