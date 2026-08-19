-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local Modules = ReplicatedStorage:WaitForChild("Modules");
local ClientEffectsModules = ReplicatedStorage:WaitForChild("ClientEffectsModules");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local TowerData = require(Modules.TowerData);
local PlantData = require(Modules.PlantData);
local Effects = require(ClientEffectsModules.Effects);
local World = workspace:WaitForChild("World", (1 / 0));
local PlacedItems = World.Map.PlacedItems;
local Plants = World.Map.Plants;
local PottedPlants = World.Map.PottedPlants;
local NPCs = World.Map.NPCs;
local Client = PlacedItems:WaitForChild("Client");
local Server = PlacedItems:WaitForChild("Server");
local Client2 = Plants:WaitForChild("Client");
local Server2 = Plants:WaitForChild("Server");
local Client3 = PottedPlants:WaitForChild("Client");
local TowerAttack = Remotes:WaitForChild("TowerAttack");

repeat
    task.wait();
until workspace:GetAttribute("Loaded") == true;

local u1 = {};

local function setAnimation(p2, p3) -- Line: 40
    -- upvalues: TowerData (copy), PlantData (copy), u1 (copy)
    local v4 = p2.Name:split(":")[1];
    local v5 = TowerData.getData(v4) or PlantData.getData(v4);

    if not v5 then
        return;
    end;

    local AnimationController = p2:WaitForChild("AnimationController");
    local Animations = v5:FindFirstChild("Animations");

    if not Animations then
        return;
    end;

    local v6 = Animations:FindFirstChild(p3);

    if v6 then
        local v7 = AnimationController:FindFirstChild("Animator") or Instance.new("Animator", AnimationController);
        u1[p2] = u1[p2] or {};

        if u1[p2][p3] then
            return u1[p2][p3];
        end;

        local v8 = v7:LoadAnimation(v6);
        v8.Name = p3;
        u1[p2][p3] = v8;

        return v8;
    end;
end;

local function playAnimation(p9, p10, p11) -- Line: 66
    -- upvalues: setAnimation (copy)
    local v12 = setAnimation(p9, p10);

    if not v12 then
        warn("AssetAnimator: no track \'", p10, "\' on", p9);

        return;
    end;

    v12:AdjustSpeed(p11 or 1);

    if not v12.IsPlaying then
        v12:Play();
    end;
end;

local function watchPlantWalkPause(u13, p14) -- Line: 90
    -- upvalues: u1 (copy)
    local function setPaused(p15) -- Line: 91
        -- upvalues: u1 (ref), u13 (copy)
        local v16 = u1[u13] and u1[u13].Walk;

        if not v16 then
            return;
        end;

        v16:AdjustSpeed(p15 and 0 or 1);
    end;

    if p14:FindFirstChild("Stopped") then
        local v17 = u1[u13] and u1[u13].Walk;

        if v17 then
            v17:AdjustSpeed(0);
        end;
    end;

    p14.ChildAdded:Connect(function(p18) -- Line: 101
        -- upvalues: u1 (ref), u13 (copy)
        if p18.Name == "Stopped" and p18:IsA("BoolValue") then
            local v19 = u1[u13] and u1[u13].Walk;

            if not v19 then
                return;
            end;

            v19:AdjustSpeed(0);
        end;
    end);
    p14.ChildRemoved:Connect(function(p20) -- Line: 107
        -- upvalues: u1 (ref), u13 (copy)
        if p20.Name == "Stopped" and p20:IsA("BoolValue") then
            local v21 = u1[u13] and u1[u13].Walk;

            if not v21 then
                return;
            end;

            v21:AdjustSpeed(1);
        end;
    end);
end;

local u22 = {};
game:GetService("RunService");
local u23 = {};
local u24 = {
    Desktop = 250,
    Console = 200,
    Tablet = 150,
    Phone = 80
};

local function getFreezeDistance() -- Line: 150
    -- upvalues: LocalPlayer (copy), u24 (copy)
    return u24[LocalPlayer:GetAttribute("DeviceTier") or "Desktop"] or 250;
end;

local function registerLod(p25, p26, p27, p28, p29) -- Line: 156
    -- upvalues: u23 (copy)
    u23[p25] = {
        serverModel = p26,
        kind = p27,
        baseSpeed = p28,
        animName = p29
    };
end;

local function updateLodBaseSpeed(p30, p31) -- Line: 167
    -- upvalues: u23 (copy)
    local v32 = u23[p30];

    if v32 then
        v32.baseSpeed = p31;
    end;
end;

local function getAttackSpeedMultiplier(p33) -- Line: 172
    local v34 = 1;

    for _, child in p33:GetChildren() do
        if child:IsA("StringValue") and child.Name == "Boombox" then
            v34 = v34 + 1;
        end;
    end;

    return v34;
end;

local function childAdded(u35) -- Line: 185
    -- upvalues: TowerData (copy), Client (copy), Server (copy), u22 (copy), getAttackSpeedMultiplier (copy), u23 (copy), setAnimation (copy), Client2 (copy), Server2 (copy), watchPlantWalkPause (copy), Client3 (copy)
    local Name = u35.Name;
    local v36 = Name:split(":")[1];
    local v37 = TowerData.getData(v36);

    if Client:FindFirstChild(Name) and v37 then
        local u38 = Server:FindFirstChild(Name);
        local v39;

        if u38 then
            v39 = u38:FindFirstChild("ServerConfiguration");
        else
            v39 = u38;
        end;

        if not v39 then
            return;
        end;

        u22[Name] = {
            model = u35,
            effectName = v37.AttackEffectName.Value or "RockThrow"
        };

        local function refreshIdleSpeed() -- Line: 203
            -- upvalues: getAttackSpeedMultiplier (ref), u38 (copy), u35 (copy), u23 (ref), setAnimation (ref)
            local v40 = getAttackSpeedMultiplier(u38);
            local v41 = u23[u35];

            if v41 then
                v41.baseSpeed = v40;
            end;

            local v42 = u35;
            local v43 = setAnimation(v42, "Idle");

            if not v43 then
                warn("AssetAnimator: no track \'", "Idle", "\' on", v42);

                return;
            end;

            v43:AdjustSpeed(v40 or 1);

            if not v43.IsPlaying then
                v43:Play();
            end;
        end;

        u38.ChildAdded:Connect(function(p44) -- Line: 211
            -- upvalues: getAttackSpeedMultiplier (ref), u38 (copy), u35 (copy), u23 (ref), setAnimation (ref)
            if p44:IsA("StringValue") and p44.Name == "Boombox" then
                local v45 = getAttackSpeedMultiplier(u38);
                local v46 = u23[u35];

                if v46 then
                    v46.baseSpeed = v45;
                end;

                local v47 = u35;
                local v48 = setAnimation(v47, "Idle");

                if not v48 then
                    warn("AssetAnimator: no track \'", "Idle", "\' on", v47);

                    return;
                end;

                v48:AdjustSpeed(v45 or 1);

                if not v48.IsPlaying then
                    v48:Play();
                end;
            end;
        end);
        u38.ChildRemoved:Connect(function(p49) -- Line: 214
            -- upvalues: getAttackSpeedMultiplier (ref), u38 (copy), u35 (copy), u23 (ref), setAnimation (ref)
            if p49:IsA("StringValue") and p49.Name == "Boombox" then
                local v50 = getAttackSpeedMultiplier(u38);
                local v51 = u23[u35];

                if v51 then
                    v51.baseSpeed = v50;
                end;

                local v52 = u35;
                local v53 = setAnimation(v52, "Idle");

                if not v53 then
                    warn("AssetAnimator: no track \'", "Idle", "\' on", v52);

                    return;
                end;

                v53:AdjustSpeed(v50 or 1);

                if not v53.IsPlaying then
                    v53:Play();
                end;
            end;
        end);
        u23[u35] = {
            kind = "Idle",
            animName = "Idle",
            serverModel = u38,
            baseSpeed = getAttackSpeedMultiplier(u38)
        };
        local v54 = getAttackSpeedMultiplier(u38);
        local v55 = u23[u35];

        if v55 then
            v55.baseSpeed = v54;
        end;

        local v56 = setAnimation(u35, "Idle");

        if not v56 then
            warn("AssetAnimator: no track \'", "Idle", "\' on", u35);

            return;
        end;

        v56:AdjustSpeed(v54 or 1);

        if not v56.IsPlaying then
            v56:Play();
        end;
    else
        if Client2:FindFirstChild(Name) then
            local v57 = setAnimation(u35, "Walk");

            if v57 then
                v57:AdjustSpeed(1);

                if not v57.IsPlaying then
                    v57:Play();
                end;
            else
                warn("AssetAnimator: no track \'", "Walk", "\' on", u35);
            end;

            local v58 = Server2:FindFirstChild(Name);

            if v58 then
                watchPlantWalkPause(u35, v58);
            end;

            u23[u35] = {
                kind = "Plant",
                baseSpeed = 1,
                animName = "Walk",
                serverModel = v58
            };

            return;
        end;

        if Client3:FindFirstChild(Name) then
            local v59 = setAnimation(u35, "Idle");

            if v59 then
                v59:AdjustSpeed(1);

                if not v59.IsPlaying then
                    v59:Play();
                end;
            else
                warn("AssetAnimator: no track \'", "Idle", "\' on", u35);
            end;

            u23[u35] = {
                serverModel = nil,
                kind = "PottedPlant",
                baseSpeed = 1,
                animName = "Idle"
            };
        end;
    end;
end;

local function childRemoved(p60) -- Line: 251
    -- upvalues: u1 (copy), u22 (copy), u23 (copy)
    local v61 = u1[p60];

    if v61 then
        for _, v in pairs(v61) do
            pcall(function() -- Line: 255
                -- upvalues: v (copy)
                v:Stop();
                v:Destroy();
            end);
        end;

        u1[p60] = nil;
    end;

    u22[p60.Name] = nil;
    u23[p60] = nil;
end;

local function watchFolder(p62) -- Line: 270
    -- upvalues: childAdded (copy), childRemoved (copy)
    p62.ChildAdded:Connect(function(p63) -- Line: 271
        -- upvalues: childAdded (ref)
        task.spawn(childAdded, p63);
    end);
    p62.ChildRemoved:Connect(childRemoved);

    for _, child in p62:GetChildren() do
        task.spawn(childAdded, child);
    end;
end;

watchFolder(Client);
watchFolder(Client2);
watchFolder(Client3);
local u64 = {};
task.spawn(function() -- Line: 294
    -- upvalues: LocalPlayer (copy), u24 (copy), u23 (copy), u64 (copy), u1 (copy)
    while true do
        local v65;

        repeat
            task.wait(0.4);
            v65 = workspace.CurrentCamera;
        until v65;

        local Position = v65.CFrame.Position;
        local v66 = u24[LocalPlayer:GetAttribute("DeviceTier") or "Desktop"] or u24.Desktop;

        for i, v in pairs(u23) do
            if i.Parent then
                local PrimaryPart = i.PrimaryPart;

                if PrimaryPart and (v.kind ~= "Plant" or not (v.serverModel and v.serverModel:FindFirstChild("Stopped"))) then
                    local v67 = v66 < (PrimaryPart.Position - Position).Magnitude;

                    if u64[i] ~= v67 then
                        u64[i] = v67;
                        local v68 = u1[i] and u1[i][v.animName];

                        if v68 then
                            v68:AdjustSpeed(v67 and 0 or v.baseSpeed);
                        end;
                    end;
                end;
            else
                u23[i] = nil;
                u64[i] = nil;
            end;
        end;
    end;
end);

local function animateNPC(p69) -- Line: 341
    local AnimationController = p69:WaitForChild("AnimationController");
    local Animations = p69:WaitForChild("Animations");

    if Animations then
        Animations = Animations:FindFirstChild("Idle");
    end;

    if AnimationController and Animations then
        (AnimationController:FindFirstChild("Animator") or Instance.new("Animator", AnimationController)):LoadAnimation(Animations):Play();
    end;
end;

for _, child in NPCs:GetChildren() do
    animateNPC(child);
end;

NPCs.ChildAdded:Connect(function(p70) -- Line: 356
    -- upvalues: animateNPC (copy)
    animateNPC(p70);
end);
TowerAttack.OnClientEvent:Connect(function(p71, p72) -- Line: 365
    -- upvalues: u22 (copy), Client2 (copy), setAnimation (copy), Effects (copy)
    local v73 = u22[p71];

    if not v73 then
        return;
    end;

    local model = v73.model;
    local v74 = Client2:FindFirstChild(p72);

    if not (v74 and (model.PrimaryPart and v74.PrimaryPart)) then
        return;
    end;

    local Position = model.PrimaryPart.Position;
    local Position2 = v74.PrimaryPart.Position;
    model.PrimaryPart.CFrame = CFrame.lookAt(Position, (Vector3.new(Position2.X, Position.Y, Position2.Z)));
    local v75 = setAnimation(model, "Attack");

    if v75 then
        v75:AdjustSpeed(1);

        if not v75.IsPlaying then
            v75:Play();
        end;
    else
        warn("AssetAnimator: no track \'", "Attack", "\' on", model);
    end;

    Effects.Play(v73.effectName, {
        TowerPosition = Position,
        TargetPosition = Position2,
        Target = v74,
        TowerID = p71
    });
end);
Remotes:WaitForChild("ClientReady"):FireServer();