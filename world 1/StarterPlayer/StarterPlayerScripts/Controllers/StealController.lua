-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Networking = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"));
local Environment = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Environment"));
local Gardens = workspace:WaitForChild("Gardens");
require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("SellValueData"));
local FruitValueCalc = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("FruitValueCalc"));
require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("MutationData"));
local Fruits = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Fruits");
local Plants = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Plants");
local Fruits2 = ReplicatedStorage:WaitForChild("PlantGenerationModules"):WaitForChild("Fruits");
ReplicatedStorage:WaitForChild("PlantGenerationModules"):WaitForChild("Plants");
require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("SeedData"));
local PlantVisualizerController = require(script.Parent.PlantVisualizerController);
require(game.ReplicatedStorage.ClientModules.Effects.ChunkDebris);
local StealFlags = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("StealFlags"));
local WerewolfNightData = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("WerewolfNightData"));
local LocalPlayer = Players.LocalPlayer;

local function notifyStealBlocked(p2) -- Line: 45
    require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController):CreateNotification((`{p2 or "That plant"} can't be stolen!`));
end;

local function isStealBlockedTarget(p3) -- Line: 50
    -- upvalues: StealFlags (copy)
    local v4 = p3:GetAttribute("SeedName") or p3:GetAttribute("CorePartName");

    if StealFlags.IsPlantStealable(v4) then
        return false, nil;
    end;

    return true, v4;
end;

local function notifyDefenderCannotSteal() -- Line: 61
    -- upvalues: LocalPlayer (copy), WerewolfNightData (copy)
    if LocalPlayer:GetAttribute(WerewolfNightData.DefenderAttribute) ~= true then
        return false;
    end;

    require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController):CreateNotification("You can only steal as a werewolf!");

    return true;
end;

local function nightOnlyMessage() -- Line: 73
    -- upvalues: WerewolfNightData (copy)
    return WerewolfNightData.IsEnabled() and "You can only steal at night as the Werewolf!" or "You can only steal at night!";
end;

local u5 = RunService:IsStudio() or Environment.env == "Dev";

local function dprint(...) -- Line: 87
    -- upvalues: u5 (copy)
    if u5 then
        print("[StealStack]", ...);
    end;
end;

local function dwarn(...) -- Line: 93
    -- upvalues: u5 (copy)
    if u5 then
        warn("[StealStack]", ...);
    end;
end;

local Debris = game:GetService("Debris");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local u6 = 0;

local function spawnStealPopVFX(p7, p8) -- Line: 115
    -- upvalues: u6 (ref), Assets (copy), Debris (copy)
    if u6 >= 12 then
        return;
    end;

    local u9 = Assets.PopVFXModel:Clone();
    u9:ScaleTo((p8 == nil and 1 or p8) * 0.5);

    if u9:IsA("Model") then
        u9:PivotTo(CFrame.new(p7));
    elseif u9:IsA("BasePart") then
        u9.CFrame = CFrame.new(p7);
    end;

    u9.Parent = workspace;
    u6 = u6 + 1;
    u9.Destroying:Connect(function() -- Line: 134
        -- upvalues: u6 (ref)
        u6 = math.max(0, u6 - 1);
    end);
    task.spawn(function() -- Line: 137
        -- upvalues: u9 (copy)
        task.wait();

        if not (u9 and u9.Parent) then
            return;
        end;

        for _, descendant in u9:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant:Emit(descendant:GetAttribute("EmitCount") or 1);
            end;
        end;
    end);
    Debris:AddItem(u9, 5);
end;

local u10 = nil;
local u11 = nil;
local u12 = false;
local u13 = nil;
local u14 = nil;
local u15 = {};
local u16 = {};
local u17 = {};
local u18 = {};
local u19 = {};
local u20 = nil;
local u21 = nil;
local u22 = false;

local function setModelQueryEnabled(p23, p24) -- Line: 195
    -- upvalues: u5 (copy), dwarn (copy)
    for _, descendant in p23:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant:SetAttribute("_AllowQuery", p24 or nil);
            descendant.CanQuery = p24;
        end;
    end;

    if u5 and p24 then
        local v25 = 0;

        for _, descendant in p23:GetDescendants() do
            if descendant:IsA("BasePart") and descendant.CanQuery ~= true then
                v25 = v25 + 1;
            end;
        end;

        if v25 > 0 then
            dwarn(("setModelQueryEnabled: %d part(s) in %s had CanQuery reverted to false! Raycasts will miss them."):format(v25, p23:GetFullName()));
        end;
    end;
end;

local u26 = {};

local function acquirePlacementLock(p27) -- Line: 232
    -- upvalues: u26 (copy), dwarn (copy)
    local v28 = 0;

    while u26[p27] do
        v28 = v28 + task.wait();

        if v28 > 10 then
            dwarn("acquirePlacementLock: waited >10s for", p27.Name, "- breaking lock (previous placement likely errored)");
            break;
        end;
    end;

    u26[p27] = true;
end;

local function releasePlacementLock(p29) -- Line: 244
    -- upvalues: u26 (copy)
    u26[p29] = nil;
end;

local u30 = false;
local u31 = nil;

local function getBackpackGui() -- Line: 257
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
    end;

    return PlayerGui;
end;

local function lockBackpack() -- Line: 263
    -- upvalues: u30 (ref), LocalPlayer (copy)
    if u30 then
        return;
    end;

    u30 = true;
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
    end;

    if PlayerGui then
        PlayerGui.Enabled = false;
    end;

    local Character = LocalPlayer.Character;
    local v32 = Character and Character:FindFirstChildOfClass("Humanoid");

    if v32 then
        v32:UnequipTools();
    end;
end;

local function unlockBackpack() -- Line: 287
    -- upvalues: u30 (ref), LocalPlayer (copy)
    if not u30 then
        return;
    end;

    u30 = false;
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
    end;

    if PlayerGui then
        PlayerGui.Enabled = true;
    end;
end;

local function isLocalPlayerCarryingStolen() -- Line: 300
    -- upvalues: u19 (copy), LocalPlayer (copy)
    local v33 = u19[LocalPlayer];
    local v34;

    if v33 == nil then
        v34 = false;
    else
        v34 = #v33 > 0;
    end;

    return v34;
end;

local function getCharacterPosition() -- Line: 309
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local u35 = nil;
local u36 = 0;

local function unfreezeCharacterForSteal() -- Line: 329
    -- upvalues: u36 (ref), u35 (ref)
    u36 = u36 + 1;
    local v37 = u35;
    u35 = nil;

    if v37 and v37.Parent then
        v37.Anchored = false;
    end;
end;

local function findFruitModel(p38, p39, p40) -- Line: 338
    -- upvalues: Gardens (copy)
    for _, child in Gardens:GetChildren() do
        local Plants2 = child:FindFirstChild("Plants");

        if Plants2 then
            local v41 = Plants2:FindFirstChild(p38 .. "_" .. p39);

            if v41 then
                local Fruits3 = v41:FindFirstChild("Fruits");

                if Fruits3 then
                    return Fruits3:FindFirstChild(p38 .. "_" .. p39 .. "_" .. p40);
                end;
            end;
        end;
    end;

    return nil;
end;

local function playStealDown(p42) -- Line: 357
    -- upvalues: LocalPlayer (copy), u21 (ref)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v43 = Character:FindFirstChildOfClass("Humanoid");

    if not v43 then
        return;
    end;

    local v44 = v43:FindFirstChildOfClass("Animator");

    if not v44 then
        return;
    end;

    local _ = tick() + 0.5;
    game.ReplicatedStorage.Assets.DigParticle:Clone().Parent = workspace;

    if not u21 then
        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://119994994979267";
        u21 = v44:LoadAnimation(Animation);
        u21.Priority = Enum.AnimationPriority.Action4;
    end;

    if not u21.IsPlaying then
        u21:Play();
    end;
end;

local u45 = 0;

local function playStealKneelOnce() -- Line: 423
    -- upvalues: LocalPlayer (copy), u21 (ref), u45 (ref), u22 (ref)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v46 = Character:FindFirstChildOfClass("Humanoid");

    if not v46 then
        return;
    end;

    local v47 = v46:FindFirstChildOfClass("Animator");

    if not v47 then
        return;
    end;

    if not u21 then
        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://119994994979267";
        u21 = v47:LoadAnimation(Animation);
        u21.Priority = Enum.AnimationPriority.Action4;
        u21.Looped = false;
    end;

    if u21.IsPlaying then
        return;
    end;

    u45 = u45 + 1;
    local u48 = u45;
    u21:Play(0.05);
    task.spawn(function() -- Line: 451
        -- upvalues: u21 (ref), u48 (copy), u45 (ref), u22 (ref)
        u21.Stopped:Wait();

        if u48 == u45 then
            u22 = false;
        end;
    end);
end;

local function playArmsUpAnimation() -- Line: 459
    -- upvalues: LocalPlayer (copy), u20 (ref), u21 (ref)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v49 = Character:FindFirstChildOfClass("Humanoid");

    if not v49 then
        return;
    end;

    local v50 = v49:FindFirstChildOfClass("Animator");

    if not v50 then
        return;
    end;

    if not u20 then
        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://86868346180508";
        u20 = v50:LoadAnimation(Animation);
        u20.Looped = true;
        u20.Priority = Enum.AnimationPriority.Action4;
    end;

    if not u21 then
        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://119994994979267";
        u21 = v50:LoadAnimation(Animation);
        u21.Priority = Enum.AnimationPriority.Action4;
        u21.Looped = false;
    end;

    if not u20.IsPlaying then
        u20:Play(0.6);
    end;
end;

local function stopStealAnimation() -- Line: 500
    -- upvalues: u45 (ref), u22 (ref), u21 (ref)
    u45 = u45 + 1;
    u22 = false;

    if u21 and u21.IsPlaying then
        u21:Stop(0.1);
    end;
end;

local function stopArmsUpAnimation() -- Line: 509
    -- upvalues: u20 (ref)
    if u20 and u20.IsPlaying then
        u20:Stop();
    end;
end;

local function addStolenFruitVisual(p51, u52, u53, u54, p55, u56) -- Line: 515
    -- upvalues: Players (copy), LocalPlayer (copy), u30 (ref), Fruits (copy), Plants (copy), dwarn (copy), u18 (copy), ReplicatedStorage (copy), u19 (copy), acquirePlacementLock (copy), dprint (copy), setModelQueryEnabled (copy), FruitValueCalc (copy), playArmsUpAnimation (copy), u26 (copy)
    local u57 = Players:GetPlayerByUserId(p51);

    if not (u57 and u57.Character) then
        return;
    end;

    if u57 == LocalPlayer and not u30 then
        u30 = true;
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");
        local v58 = PlayerGui and PlayerGui:FindFirstChild("BackpackGui");

        if v58 then
            v58.Enabled = false;
        end;

        local Character = LocalPlayer.Character;
        local v59 = Character and Character:FindFirstChildOfClass("Humanoid");

        if v59 then
            v59:UnequipTools();
        end;
    end;

    local v60 = Fruits:FindFirstChild(u52);
    local u61;

    if v60 then
        u61 = false;
    else
        v60 = Plants:FindFirstChild(u52);
        u61 = true;
    end;

    if not v60 then
        dwarn("addStolenFruitVisual: no asset found for", u52);

        return;
    end;

    local u62 = v60:Clone();

    local function lockPart(u63) -- Line: 538
        if u63:GetAttribute("_StealLocked") then
            return;
        end;

        u63:SetAttribute("_StealLocked", true);
        u63.CanCollide = false;
        u63.CanQuery = false;
        u63.CanTouch = false;
        u63.Massless = true;
        u63:GetPropertyChangedSignal("CanCollide"):Connect(function() -- Line: 547
            -- upvalues: u63 (copy)
            if u63.CanCollide then
                u63.CanCollide = false;
            end;
        end);
        u63:GetPropertyChangedSignal("CanQuery"):Connect(function() -- Line: 554
            -- upvalues: u63 (copy)
            if u63.CanQuery and not u63:GetAttribute("_AllowQuery") then
                u63.CanQuery = false;
            end;
        end);
        u63:GetPropertyChangedSignal("CanTouch"):Connect(function() -- Line: 559
            -- upvalues: u63 (copy)
            if u63.CanTouch then
                u63.CanTouch = false;
            end;
        end);
    end;

    u62.DescendantAdded:Connect(function(p64) -- Line: 564
        -- upvalues: lockPart (copy)
        if p64:IsA("BasePart") then
            lockPart(p64);
        end;
    end);

    for _, descendant in u62:GetDescendants() do
        if descendant:IsA("BasePart") then
            lockPart(descendant);
        end;
    end;

    task.spawn(function() -- Line: 576
        -- upvalues: u18 (ref), u52 (copy), ReplicatedStorage (ref), dwarn (ref), u56 (copy), u62 (copy), u61 (ref), u53 (copy), u54 (copy), u19 (ref), u57 (copy), acquirePlacementLock (ref), dprint (ref), setModelQueryEnabled (ref), LocalPlayer (ref), FruitValueCalc (ref), playArmsUpAnimation (ref), u26 (ref)
        local v65 = u18[u52];

        if not v65 then
            local v66 = ReplicatedStorage.PlantGenerationModules.Plants:FindFirstChild(u52);

            if v66 then
                v65 = require(v66);
            end;
        end;

        if not v65 then
            dwarn("addStolenFruitVisual: no generation module for", u52);

            return;
        end;

        if u56 and u56 ~= "" then
            u62:SetAttribute("Mutation", u56);
        end;

        if u61 then
            v65.InitPlant(u62, u53, u54, os.time());
        else
            v65.InitFruit(u62, u53, u54);
        end;

        repeat
            task.wait();
        until u62:HasTag("InitializationComplete");

        if not u19[u57] then
            u19[u57] = {};
        end;

        local PrimaryPart = u62.PrimaryPart;

        if not PrimaryPart then
            PrimaryPart = u62:FindFirstChild("FruitAnchor", true) or (u62:FindFirstChild("Base", true) or u62:FindFirstChildWhichIsA("BasePart", true));

            if not PrimaryPart then
                dwarn("addStolenFruitVisual: fruit", u52, "has no usable PrimaryPart, destroying");
                u62:Destroy();

                return;
            end;

            u62.PrimaryPart = PrimaryPart;
        end;

        acquirePlacementLock(u57);
        local success, result = pcall(function() -- Line: 627
            -- upvalues: dprint (ref), u52 (ref), u57 (ref), u19 (ref), setModelQueryEnabled (ref), u62 (ref), PrimaryPart (ref), dwarn (ref), LocalPlayer (ref), FruitValueCalc (ref), u54 (ref), u56 (ref), playArmsUpAnimation (ref)
            dprint(("Placing \'%s\' for %s (stack size before: %d)"):format(u52, u57.Name, #u19[u57]));
            setModelQueryEnabled(u62, true);
            local v67 = (1 / 0);

            for _, descendant in u62:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                    local v68 = descendant.Position.Y - descendant.Size.Y / 2;

                    if v68 < v67 then
                        v67 = v68;
                    end;
                end;
            end;

            if v67 == (1 / 0) then
                v67 = PrimaryPart.Position.Y - PrimaryPart.Size.Y / 2;
            end;

            local v69 = CFrame.new(PrimaryPart.Position.X, PrimaryPart.Position.Y - 100, PrimaryPart.Position.Z);
            u62.Parent = workspace;
            local v70 = RaycastParams.new();
            v70.FilterDescendantsInstances = { u62 };
            v70.FilterType = Enum.RaycastFilterType.Include;
            local v71 = workspace:Raycast(v69.Position, Vector3.new(0, 300, 0), v70);
            local v72 = CFrame.new(PrimaryPart.Position.X, v67, PrimaryPart.Position.Z);

            if v71 and v71.Instance then
                v72 = CFrame.new(v71.Position);
                dprint(("Bottom raycast hit \'%s\' at Y=%.2f"):format(v71.Instance.Name, v71.Position.Y));
            else
                dwarn(("Bottom raycast MISSED for \'%s\' - falling back to iterated lowestY=%.2f. If this happens often, the fruit\'s parts aren\'t queryable."):format(u52, v67));
            end;

            setModelQueryEnabled(u62, false);
            local Part = Instance.new("Part");
            Part.Name = "FruitAnchor";
            Part.Size = Vector3.new(0.01, 0.01, 0.01);
            Part.Transparency = 1;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.Massless = true;
            Part.CFrame = v72;
            Part.Parent = u62;
            u62.PrimaryPart = Part;

            for _, descendant in u62:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = false;
                    descendant.CanCollide = false;
                    descendant.CanTouch = false;
                    descendant.Massless = true;
                end;
            end;

            for _, descendant in u62:GetDescendants() do
                if descendant:IsA("BasePart") and descendant ~= Part then
                    local WeldConstraint = Instance.new("WeldConstraint");
                    WeldConstraint.Part0 = Part;
                    WeldConstraint.Part1 = descendant;
                    WeldConstraint.Parent = descendant;
                end;
            end;

            if not u57.Character:FindFirstChild("Head") then
                u62:Destroy();

                return;
            end;

            local HumanoidRootPart = u57.Character:FindFirstChild("HumanoidRootPart");

            if not HumanoidRootPart then
                u62:Destroy();

                return;
            end;

            local v73 = u19[u57];
            local v74 = HumanoidRootPart.CFrame * CFrame.new(0, 0, -2);

            if v73 and #v73 ~= 0 then
                local X = v74.Position.X;
                local Z = v74.Position.Z;
                local v75 = {};

                for _, v in v73 do
                    if v.model and v.model.Parent then
                        table.insert(v75, v.model);
                        setModelQueryEnabled(v.model, true);
                    end;
                end;

                dprint(("Stacking on top of %d carried model(s)"):format(#v75));
                task.wait();
                local v76 = RaycastParams.new();
                v76.FilterDescendantsInstances = v75;
                v76.FilterType = Enum.RaycastFilterType.Include;
                local v77 = HumanoidRootPart.Position.Y + 200;
                local v78 = 0;
                local v79 = (-1 / 0);
                local v80 = nil;

                for i = 0, 4 do
                    for i2 = 0, 4 do
                        local v81 = X - 2 + i * 1;
                        local v82 = Z - 2 + i2 * 1;
                        local v83 = Vector3.new(v81, v77, v82);

                        for _ = 1, 20 do
                            local v84 = workspace:Raycast(v83, Vector3.new(0, -400, 0), v76);

                            if not v84 then
                                break;
                            end;

                            if v84.Instance.Transparency < 1 then
                                v78 = v78 + 1;

                                if v79 < v84.Position.Y then
                                    v79 = v84.Position.Y;
                                    v80 = v84.Instance;
                                end;

                                break;
                            end;

                            v83 = Vector3.new(v81, v84.Position.Y - 0.01, v82);
                        end;
                    end;
                end;

                for _, v in v75 do
                    setModelQueryEnabled(v, false);
                end;

                if v79 > (-1 / 0) then
                    dprint(("Grid raycast: %d/%d columns hit. Highest surface: \'%s\' at Y=%.2f"):format(v78, 25, v80 and v80.Name or "?", v79));
                    Part.CFrame = CFrame.new(X, v79, Z);
                else
                    dwarn(("Grid raycast hit NOTHING above the stack for \'%s\' (stack size %d). Using fallback Y=%.2f. Check that the carried fruits\' parts have CanQuery enabled during the raycast."):format(u52, #v75, HumanoidRootPart.Position.Y + 0.5));
                    Part.CFrame = CFrame.new(X, HumanoidRootPart.Position.Y + 0.5, Z);
                end;
            else
                Part.CFrame = v74;
                dprint(("First fruit in stack -> placed at base ref Y=%.2f"):format(v74.Position.Y));
            end;

            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Parent = Part;
            WeldConstraint.Part0 = Part;
            WeldConstraint.Part1 = HumanoidRootPart;
            table.insert(u19[u57], {
                model = u62,
                stealer = u57
            });
            u62.Parent = u57.Character;
            dprint(("Placed \'%s\' at Y=%.2f (stack size now: %d)"):format(u52, Part.Position.Y, #u19[u57]));

            if u57 == LocalPlayer then
                local v85 = tonumber(LocalPlayer:GetAttribute("StolenCarryValue")) or 0;
                local v86 = #u19[u57] == 1 and 0 or v85;
                local success, result = pcall(FruitValueCalc, u52, u54, u56, LocalPlayer, nil);

                if success and type(result) == "number" then
                    v86 = v86 + result;
                else
                    dwarn("FruitValueCalc failed for", u52, "-", result);
                end;

                LocalPlayer:SetAttribute("StolenCarryValue", v86);
                playArmsUpAnimation();
            end;
        end);
        u26[u57] = nil;

        if not success then
            dwarn("Placement errored for", u52, "-", result);

            if u62 and u62.Parent then
                u62:Destroy();
            end;
        end;
    end);
end;

local u87 = {};
local u88 = false;

local function queueDestroy(p89) -- Line: 878
    -- upvalues: u87 (copy), u88 (ref), RunService (copy)
    if p89.Parent then
        p89.Parent = nil;
    end;

    table.insert(u87, p89);

    if u88 then
        return;
    end;

    u88 = true;
    task.defer(function() -- Line: 889
        -- upvalues: u87 (ref), RunService (ref), u88 (ref)
        while true do
            if #u87 <= 0 then
                u88 = false;

                return;
            end;

            local v90 = os.clock();

            repeat
                local v91 = table.remove(u87);

                if v91 then
                    v91:Destroy();
                end;
            until #u87 == 0 or os.clock() - v90 >= 0.004;

            if #u87 > 0 then
                RunService.Heartbeat:Wait();
            end;
        end;
    end);
end;

local function clearStolenFruitVisuals(p92) -- Line: 906
    -- upvalues: Players (copy), u19 (copy), u87 (copy), u88 (ref), RunService (copy), LocalPlayer (copy), u20 (ref), u45 (ref), u22 (ref), u21 (ref), u30 (ref)
    local v93 = Players:GetPlayerByUserId(p92);

    if not v93 then
        for i, v in u19 do
            if i.UserId == p92 then
                for _, v2 in v do
                    if v2.model and v2.model.Parent then
                        local model = v2.model;

                        if model.Parent then
                            model.Parent = nil;
                        end;

                        table.insert(u87, model);

                        if not u88 then
                            u88 = true;
                            task.defer(function() -- Line: 889
                                -- upvalues: u87 (ref), RunService (ref), u88 (ref)
                                while true do
                                    if #u87 <= 0 then
                                        u88 = false;

                                        return;
                                    end;

                                    local v94 = os.clock();

                                    repeat
                                        local v95 = table.remove(u87);

                                        if v95 then
                                            v95:Destroy();
                                        end;
                                    until #u87 == 0 or os.clock() - v94 >= 0.004;

                                    if #u87 > 0 then
                                        RunService.Heartbeat:Wait();
                                    end;
                                end;
                            end);
                        end;
                    end;
                end;

                u19[i] = nil;

                return;
            end;
        end;

        return;
    end;

    if p92 == LocalPlayer.UserId then
        if u20 and u20.IsPlaying then
            u20:Stop();
        end;

        u45 = u45 + 1;
        u22 = false;

        if u21 and u21.IsPlaying then
            u21:Stop(0.1);
        end;

        if u30 then
            u30 = false;
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

            if PlayerGui then
                PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
            end;

            if PlayerGui then
                PlayerGui.Enabled = true;
            end;
        end;
    end;

    local v96 = u19[v93];

    if v96 then
        for _, v in v96 do
            if v.model and v.model.Parent then
                local model = v.model;

                if model.Parent then
                    model.Parent = nil;
                end;

                table.insert(u87, model);

                if not u88 then
                    u88 = true;
                    task.defer(function() -- Line: 889
                        -- upvalues: u87 (ref), RunService (ref), u88 (ref)
                        while true do
                            if #u87 <= 0 then
                                u88 = false;

                                return;
                            end;

                            local v97 = os.clock();

                            repeat
                                local v98 = table.remove(u87);

                                if v98 then
                                    v98:Destroy();
                                end;
                            until #u87 == 0 or os.clock() - v97 >= 0.004;

                            if #u87 > 0 then
                                RunService.Heartbeat:Wait();
                            end;
                        end;
                    end);
                end;
            end;
        end;

        u19[v93] = nil;
    end;
end;

local function markFruitStolen(p99, p100, p101) -- Line: 940
    -- upvalues: PlantVisualizerController (copy), findFruitModel (copy), u17 (copy)
    local v102;

    if p101 == "" or p101 == nil then
        v102 = PlantVisualizerController:GetSpawnedPlant(p99, p100);
    else
        v102 = findFruitModel(p99, p100, p101);
    end;

    if not v102 then
        return;
    end;

    local u103 = {};

    local function hide(u104, u105, p106) -- Line: 954
        -- upvalues: u103 (copy)
        local success, result = pcall(function() -- Line: 955
            -- upvalues: u104 (copy), u105 (copy)
            return u104[u105];
        end);

        if not success then
            return;
        end;

        table.insert(u103, {
            instance = u104,
            property = u105,
            original = result
        });
        u104[u105] = p106;
    end;

    local u107;

    if v102:IsA("Model") then
        u107 = v102.PrimaryPart or nil;
    else
        u107 = nil;
    end;

    local function processInstance(p108) -- Line: 963
        -- upvalues: u107 (copy), hide (copy)
        if p108.Name == "HarvestPart" then
            return;
        end;

        if p108:HasTag("MutationVFX") then
            return;
        end;

        if p108:IsA("BasePart") then
            if p108 == u107 then
                return;
            end;

            hide(p108, "Transparency", 1);
            hide(p108, "CanCollide", false);

            return;
        end;

        if p108:IsA("Decal") or p108:IsA("Texture") then
            hide(p108, "Transparency", 1);

            return;
        end;

        if p108:IsA("ParticleEmitter") or (p108:IsA("Beam") or p108:IsA("Trail")) then
            hide(p108, "Enabled", false);

            return;
        end;

        if p108:IsA("Light") then
            hide(p108, "Enabled", false);

            return;
        end;

        if p108:IsA("SurfaceGui") or p108:IsA("BillboardGui") then
            hide(p108, "Enabled", false);
        end;
    end;

    if v102:IsA("BasePart") then
        processInstance(v102);
    end;

    for _, descendant in v102:GetDescendants() do
        processInstance(descendant);
    end;

    u17[v102] = u103;

    for _, descendant in v102:GetDescendants() do
        if descendant:IsA("ProximityPrompt") then
            descendant:Destroy();
        end;
    end;
end;

local function restoreFruitAppearance(p109, p110, p111) -- Line: 999
    -- upvalues: PlantVisualizerController (copy), findFruitModel (copy), u17 (copy)
    local v112;

    if p111 == "" or p111 == nil then
        v112 = PlantVisualizerController:GetSpawnedPlant(p109, p110);
    else
        v112 = findFruitModel(p109, p110, p111);
    end;

    if not v112 then
        return;
    end;

    local v113 = u17[v112];

    if v113 then
        for _, v in v113 do
            local instance = v.instance;

            if instance and instance.Parent then
                pcall(function() -- Line: 1015
                    -- upvalues: instance (copy), v (copy)
                    instance[v.property] = v.original;
                end);
            end;
        end;

        u17[v112] = nil;
    end;

    local StolenBillboard = v112:FindFirstChild("StolenBillboard");

    if StolenBillboard then
        StolenBillboard:Destroy();
    end;

    if p111 == "" or p111 == nil then
        PlantVisualizerController:AddHarvestPrompt(v112);
    end;
end;

local function deleteFruitModels(p114) -- Line: 1034
    -- upvalues: findFruitModel (copy), u17 (copy), u87 (copy), u88 (ref), RunService (copy)
    for _, v in p114 do
        local v115 = findFruitModel(v.OwnerUserId, v.PlantId, v.FruitId);

        if v115 then
            u17[v115] = nil;

            if v115.Parent then
                v115.Parent = nil;
            end;

            table.insert(u87, v115);

            if not u88 then
                u88 = true;
                task.defer(function() -- Line: 889
                    -- upvalues: u87 (ref), RunService (ref), u88 (ref)
                    while true do
                        if #u87 <= 0 then
                            u88 = false;

                            return;
                        end;

                        local v116 = os.clock();

                        repeat
                            local v117 = table.remove(u87);

                            if v117 then
                                v117:Destroy();
                            end;
                        until #u87 == 0 or os.clock() - v116 >= 0.004;

                        if #u87 > 0 then
                            RunService.Heartbeat:Wait();
                        end;
                    end;
                end);
            end;
        end;
    end;
end;

local u118 = {};

local function disableOtherStealPrompts(p119) -- Line: 1056
    -- upvalues: CollectionService (copy), u118 (copy)
    for _, v in CollectionService:GetTagged("StealPrompt") do
        if v ~= p119 and (v:IsA("ProximityPrompt") and (v:IsDescendantOf(workspace) and v.Enabled)) then
            v.Enabled = false;
            table.insert(u118, v);
        end;
    end;
end;

local function restoreSuppressedStealPrompts() -- Line: 1067
    -- upvalues: u118 (copy)
    for _, v in u118 do
        if v and v:IsDescendantOf(workspace) then
            v.Enabled = true;
        end;
    end;

    table.clear(u118);
end;

local function cancelCurrentSteal() -- Line: 1076
    -- upvalues: u12 (ref), u10 (ref), u11 (ref), Networking (copy), u14 (ref), u13 (ref), u31 (ref), LocalPlayer (copy), u36 (ref), u35 (ref), restoreSuppressedStealPrompts (copy), u19 (copy), u30 (ref), u45 (ref), u22 (ref), u21 (ref)
    u12 = true;
    local u120 = u10;
    u10 = nil;
    u11 = nil;

    if u120 and u120:IsDescendantOf(workspace) then
        u120.Enabled = false;
        task.defer(function() -- Line: 1083
            -- upvalues: u120 (copy)
            if u120 and u120:IsDescendantOf(workspace) then
                u120.Enabled = true;
            end;
        end);
    end;

    Networking.Steal.CancelSteal:Fire();

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    u13 = nil;

    if not u31 then
        u31 = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls();
    end;

    u36 = u36 + 1;
    local v121 = u35;
    u35 = nil;

    if v121 and v121.Parent then
        v121.Anchored = false;
    end;

    u31:Enable();
    restoreSuppressedStealPrompts();
    local v122 = u19[LocalPlayer];
    local v123;

    if v122 == nil then
        v123 = false;
    else
        v123 = #v122 > 0;
    end;

    if not v123 then
        if u30 then
            u30 = false;
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

            if PlayerGui then
                PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
            end;

            if PlayerGui then
                PlayerGui.Enabled = true;
            end;
        end;

        u45 = u45 + 1;
        u22 = false;

        if u21 and u21.IsPlaying then
            u21:Stop(0.1);
        end;
    end;
end;

local function startMoveDetection() -- Line: 1114
    -- upvalues: u13 (ref), LocalPlayer (copy), cancelCurrentSteal (copy), u14 (ref), RunService (copy)
    local Character = LocalPlayer.Character;
    local v124;

    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            v124 = HumanoidRootPart.Position;
        else
            v124 = nil;
        end;
    else
        v124 = nil;
    end;

    u13 = v124;

    if not u13 then
        cancelCurrentSteal();

        return;
    end;

    if u14 then
        u14:Disconnect();
    end;

    local u125 = os.clock();
    u14 = RunService.Heartbeat:Connect(function() -- Line: 1130
        -- upvalues: LocalPlayer (ref), cancelCurrentSteal (ref), u125 (copy), u13 (ref)
        debug.profilebegin("Controllers/StealController/MoveCheck");
        local Character2 = LocalPlayer.Character;
        local v126;

        if Character2 then
            local HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart then
                v126 = HumanoidRootPart.Position;
            else
                v126 = nil;
            end;
        else
            v126 = nil;
        end;

        if not v126 then
            cancelCurrentSteal();
            debug.profileend();

            return;
        end;

        if os.clock() - u125 < 0.6 then
            u13 = v126;
            debug.profileend();

            return;
        end;

        if (v126 - u13).Magnitude > 5 then
            cancelCurrentSteal();
        end;

        debug.profileend();
    end);
end;

local function applyPulsingHighlight(p127) -- Line: 1156
    -- upvalues: LocalPlayer (copy), u15 (copy)
    if p127 == LocalPlayer then
        return;
    end;

    local v128 = u15[p127];

    if v128 and v128.Parent then
        return;
    end;

    if v128 then
        u15[p127] = nil;
    end;

    local Character = p127.Character;

    if not Character then
        return;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "StealHighlight";
    Highlight.FillColor = Color3.new(1, 0, 0);
    Highlight.OutlineColor = Color3.new(1, 0, 0);
    Highlight.FillTransparency = 0.5;
    Highlight.OutlineTransparency = 1;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.Parent = Character;
    u15[p127] = Highlight;
end;

local function removePulsingHighlight(p129) -- Line: 1182
    -- upvalues: u15 (copy), u16 (copy)
    local v130 = u15[p129];

    if v130 then
        v130:Destroy();
        u15[p129] = nil;
    end;

    local v131 = u16[p129];

    if v131 then
        task.cancel(v131);
        u16[p129] = nil;
    end;
end;

local StealSFX = game.SoundService.SFX.StealSFX;

function v1.Init(p132) -- Line: 1198
    -- upvalues: ProximityPromptService (copy), u12 (ref), LocalPlayer (copy), StealFlags (copy), WerewolfNightData (copy), StealSFX (copy), u10 (ref), u11 (ref), ReplicatedStorage (copy), u31 (ref), disableOtherStealPrompts (copy), u30 (ref), playStealKneelOnce (copy), Networking (copy), startMoveDetection (copy), u14 (ref), u13 (ref), u36 (ref), u35 (ref), restoreSuppressedStealPrompts (copy), u19 (copy), u45 (ref), u22 (ref), u21 (ref), applyPulsingHighlight (copy), u15 (copy), u16 (copy), markFruitStolen (copy), restoreFruitAppearance (copy), deleteFruitModels (copy), addStolenFruitVisual (copy), clearStolenFruitVisuals (copy), spawnStealPopVFX (copy), Players (copy), u26 (copy), UserInputService (copy), RunService (copy), u20 (ref)
    ProximityPromptService.PromptButtonHoldBegan:Connect(function(u133, p134) -- Line: 1199
        -- upvalues: u12 (ref), LocalPlayer (ref), StealFlags (ref), WerewolfNightData (ref), StealSFX (ref), u10 (ref), u11 (ref), ReplicatedStorage (ref), u31 (ref), disableOtherStealPrompts (ref), u30 (ref), playStealKneelOnce (ref), Networking (ref), startMoveDetection (ref), u14 (ref), u13 (ref), u36 (ref), u35 (ref), restoreSuppressedStealPrompts (ref), u19 (ref), u45 (ref), u22 (ref), u21 (ref)
        u12 = false;

        if not u133:HasTag("StealPrompt") then
            return;
        end;

        if p134 ~= LocalPlayer then
            return;
        end;

        local Parent = u133.Parent;

        if not Parent then
            return;
        end;

        local v135 = Parent:FindFirstAncestorWhichIsA("Model");

        if not v135 then
            return;
        end;

        local v136 = v135:GetAttribute("SeedName") or v135:GetAttribute("CorePartName");
        local v137;

        if StealFlags.IsPlantStealable(v136) then
            v137 = false;
            v136 = nil;
        else
            v137 = true;
        end;

        if v137 then
            require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController):CreateNotification((`{v136 or "That plant"} can't be stolen!`));

            return;
        end;

        local v138;

        if LocalPlayer:GetAttribute(WerewolfNightData.DefenderAttribute) == true then
            require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController):CreateNotification("You can only steal as a werewolf!");
            v138 = true;
        else
            v138 = false;
        end;

        if v138 then
            return;
        end;

        local v139 = tonumber(v135:GetAttribute("UserId"));
        local v140 = v135:GetAttribute("PlantId");
        local v141 = v135:GetAttribute("FruitId");
        StealSFX.TimePosition = 0;
        StealSFX.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        StealSFX.Playing = true;

        if not (v139 and v140) then
            return;
        end;

        u10 = u133;
        u11 = v135;
        local Night = ReplicatedStorage:FindFirstChild("Night");

        if not Night or Night.Value ~= true then
            require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController):CreateNotification(WerewolfNightData.IsEnabled() and "You can only steal at night as the Werewolf!" or "You can only steal at night!");
            u10 = nil;
            u11 = nil;

            return;
        end;

        if not u31 then
            u31 = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls();
        end;

        disableOtherStealPrompts(u133);

        if not u30 then
            u30 = true;
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

            if PlayerGui then
                PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
            end;

            if PlayerGui then
                PlayerGui.Enabled = false;
            end;

            local Character = LocalPlayer.Character;
            local v142 = Character and Character:FindFirstChildOfClass("Humanoid");

            if v142 then
                v142:UnequipTools();
            end;
        end;

        playStealKneelOnce();
        Networking.Steal.BeginSteal:Fire(v139, v140, v141 or "");
        startMoveDetection();
        task.spawn(function() -- Line: 1270
            -- upvalues: u11 (ref)
            u11:GetPivot();
            local v143, v144 = u11:GetBoundingBox();
            local Part = Instance.new("Part");
            Part.Size = v144;
            Part.CFrame = v143;
            Part.Anchored = true;
            Part.Transparency = 1;
            Part.CanCollide = false;
            Part.CanQuery = false;
            local v145 = game.ReplicatedStorage.Assets.ShakeParticle:Clone();
            v145.Parent = Part;
            Part.Parent = workspace.Temporary;
            local v146 = u11:GetPivot();
            game.Debris:AddItem(Part, 2);
            local v147 = Vector3.new();
            local v148 = 0;

            while u11 ~= nil do
                local v149 = game:GetService("RunService").Heartbeat:Wait();
                local v150 = u11;

                if not v150 then
                    break;
                end;

                v148 = v148 + v149;
                local v151 = math.clamp(v148 / 0.7, 0, 1);
                Part.CFrame = v143;

                if v150.PrimaryPart and v150.PrimaryPart.Anchored == true then
                    v147 = v147:Lerp(Random.new():NextUnitVector() * 0.4 * v151, v149 * 12);
                    v150:PivotTo(v146 * CFrame.new(v147));
                end;
            end;

            v145.Enabled = false;
            u11:PivotTo(v146);
        end);
        u133.Destroying:Connect(function() -- Line: 1330
            -- upvalues: u10 (ref), u133 (copy), u11 (ref), u14 (ref), u13 (ref), Networking (ref), u31 (ref), LocalPlayer (ref), u36 (ref), u35 (ref), restoreSuppressedStealPrompts (ref), u19 (ref), u30 (ref), u45 (ref), u22 (ref), u21 (ref)
            if u10 == u133 then
                u10 = nil;
                u11 = nil;

                if u14 then
                    u14:Disconnect();
                    u14 = nil;
                end;

                u13 = nil;
                Networking.Steal.CancelSteal:Fire();

                if not u31 then
                    u31 = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls();
                end;

                u36 = u36 + 1;
                local v152 = u35;
                u35 = nil;

                if v152 and v152.Parent then
                    v152.Anchored = false;
                end;

                u31:Enable();
                restoreSuppressedStealPrompts();
                local v153 = u19[LocalPlayer];
                local v154;

                if v153 == nil then
                    v154 = false;
                else
                    v154 = #v153 > 0;
                end;

                if not v154 then
                    if u30 then
                        u30 = false;
                        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

                        if PlayerGui then
                            PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
                        end;

                        if PlayerGui then
                            PlayerGui.Enabled = true;
                        end;
                    end;

                    u45 = u45 + 1;
                    u22 = false;

                    if u21 and u21.IsPlaying then
                        u21:Stop(0.1);
                    end;
                end;
            end;
        end);
    end);
    ProximityPromptService.PromptButtonHoldEnded:Connect(function(u155, p156) -- Line: 1358
        -- upvalues: LocalPlayer (ref), u10 (ref), u11 (ref), u14 (ref), u13 (ref), Networking (ref), u31 (ref), u36 (ref), u35 (ref), restoreSuppressedStealPrompts (ref), u45 (ref), u22 (ref), u21 (ref), u19 (ref), u30 (ref)
        if not u155:HasTag("StealPrompt") then
            return;
        end;

        if p156 ~= LocalPlayer then
            return;
        end;

        task.defer(function() -- Line: 1363
            -- upvalues: u10 (ref), u155 (copy), u11 (ref), u14 (ref), u13 (ref), Networking (ref), u31 (ref), LocalPlayer (ref), u36 (ref), u35 (ref), restoreSuppressedStealPrompts (ref), u45 (ref), u22 (ref), u21 (ref), u19 (ref), u30 (ref)
            if u10 == u155 then
                u10 = nil;
                u11 = nil;

                if u14 then
                    u14:Disconnect();
                    u14 = nil;
                end;

                u13 = nil;
                Networking.Steal.CancelSteal:Fire();

                if not u31 then
                    u31 = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls();
                end;

                u36 = u36 + 1;
                local v157 = u35;
                u35 = nil;

                if v157 and v157.Parent then
                    v157.Anchored = false;
                end;

                u31:Enable();
                restoreSuppressedStealPrompts();
                u45 = u45 + 1;
                u22 = false;

                if u21 and u21.IsPlaying then
                    u21:Stop(0.1);
                end;

                local v158 = u19[LocalPlayer];
                local v159;

                if v158 == nil then
                    v159 = false;
                else
                    v159 = #v158 > 0;
                end;

                if not v159 then
                    if not u30 then
                        return;
                    end;

                    u30 = false;
                    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

                    if PlayerGui then
                        PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
                    end;

                    if PlayerGui then
                        PlayerGui.Enabled = true;
                    end;
                end;
            end;
        end);
    end);
    ProximityPromptService.PromptTriggered:Connect(function(p160, p161) -- Line: 1394
        -- upvalues: LocalPlayer (ref), StealFlags (ref), u12 (ref), WerewolfNightData (ref), ReplicatedStorage (ref), u10 (ref), u11 (ref), u14 (ref), u13 (ref), u19 (ref), u30 (ref), playStealKneelOnce (ref), Networking (ref), u31 (ref), u36 (ref), u35 (ref), restoreSuppressedStealPrompts (ref)
        if not p160:HasTag("StealPrompt") then
            return;
        end;

        if p161 ~= LocalPlayer then
            return;
        end;

        local Parent = p160.Parent;

        if Parent then
            Parent = Parent:FindFirstAncestorWhichIsA("Model");
        end;

        if Parent then
            local v162 = Parent:GetAttribute("SeedName") or Parent:GetAttribute("CorePartName");
            local v163;

            if StealFlags.IsPlantStealable(v162) then
                v163 = false;
                v162 = nil;
            else
                v163 = true;
            end;

            if v163 then
                require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController):CreateNotification((`{v162 or "That plant"} can't be stolen!`));
                u12 = false;

                return;
            end;
        end;

        local v164;

        if LocalPlayer:GetAttribute(WerewolfNightData.DefenderAttribute) == true then
            require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController):CreateNotification("You can only steal as a werewolf!");
            v164 = true;
        else
            v164 = false;
        end;

        if v164 then
            u12 = false;

            return;
        end;

        local Night = ReplicatedStorage:FindFirstChild("Night");

        if not Night or Night.Value ~= true then
            require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController):CreateNotification(WerewolfNightData.IsEnabled() and "You can only steal at night as the Werewolf!" or "You can only steal at night!");
            u10 = nil;
            u11 = nil;
            u12 = false;

            if u14 then
                u14:Disconnect();
                u14 = nil;
            end;

            u13 = nil;
            local v165 = u19[LocalPlayer];
            local v166;

            if v165 == nil then
                v166 = false;
            else
                v166 = #v165 > 0;
            end;

            if not v166 then
                if not u30 then
                    return;
                end;

                u30 = false;
                local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

                if PlayerGui then
                    PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
                end;

                if PlayerGui then
                    PlayerGui.Enabled = true;
                end;
            end;

            return;
        end;

        if p160.HoldDuration == 0 then
            local Parent2 = p160.Parent;

            if not Parent2 then
                return;
            end;

            local v167 = Parent2:FindFirstAncestorWhichIsA("Model");

            if not v167 then
                return;
            end;

            local v168 = tonumber(v167:GetAttribute("UserId"));
            local v169 = v167:GetAttribute("PlantId");
            local v170 = v167:GetAttribute("FruitId");

            if not (v168 and v169) then
                return;
            end;

            playStealKneelOnce();
            Networking.Steal.BeginSteal:Fire(v168, v169, v170 or "");
            Networking.Steal.CompleteSteal:Fire();

            return;
        end;

        if u10 ~= p160 or u12 then
            u12 = false;

            return;
        end;

        if u14 then
            u14:Disconnect();
            u14 = nil;
        end;

        u13 = nil;
        u10 = nil;
        u11 = nil;

        if not u31 then
            u31 = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls();
        end;

        u36 = u36 + 1;
        local v171 = u35;
        u35 = nil;

        if v171 and v171.Parent then
            v171.Anchored = false;
        end;

        u31:Enable();
        restoreSuppressedStealPrompts();
        Networking.Steal.CompleteSteal:Fire();
    end);
    Networking.Steal.StealStarted.OnClientEvent:Connect(function(p172) -- Line: 1507
        -- upvalues: applyPulsingHighlight (ref)
        if p172 and p172:IsA("Player") then
            applyPulsingHighlight(p172);
        end;
    end);
    Networking.Steal.StealCancelled.OnClientEvent:Connect(function(p173) -- Line: 1513
        -- upvalues: u15 (ref), u16 (ref)
        if p173 and p173:IsA("Player") then
            local v174 = u15[p173];

            if v174 then
                v174:Destroy();
                u15[p173] = nil;
            end;

            local v175 = u16[p173];

            if v175 then
                task.cancel(v175);
                u16[p173] = nil;
            end;
        end;
    end);
    Networking.Steal.MarkFruitStolen.OnClientEvent:Connect(markFruitStolen);
    Networking.Steal.RestoreFruitAppearance.OnClientEvent:Connect(restoreFruitAppearance);
    Networking.Steal.DeleteFruitModels.OnClientEvent:Connect(deleteFruitModels);
    Networking.Steal.AddStolenFruitVisual.OnClientEvent:Connect(addStolenFruitVisual);
    Networking.Steal.ClearStolenFruitVisuals.OnClientEvent:Connect(clearStolenFruitVisuals);
    Networking.Steal.PopVFX.OnClientEvent:Connect(function(p176, p177) -- Line: 1526
        -- upvalues: spawnStealPopVFX (ref)
        spawnStealPopVFX(p176, p177);
    end);
    Players.PlayerRemoving:Connect(function(p178) -- Line: 1532
        -- upvalues: u15 (ref), u16 (ref), clearStolenFruitVisuals (ref), u26 (ref)
        local v179 = u15[p178];

        if v179 then
            v179:Destroy();
            u15[p178] = nil;
        end;

        local v180 = u16[p178];

        if v180 then
            task.cancel(v180);
            u16[p178] = nil;
        end;

        clearStolenFruitVisuals(p178.UserId);
        u26[p178] = nil;
    end);
    UserInputService.InputEnded:Connect(function(p181) -- Line: 1539
        -- upvalues: u45 (ref), u22 (ref), u21 (ref)
        if p181.KeyCode ~= Enum.KeyCode.E and p181.KeyCode ~= Enum.KeyCode.ButtonX then
            return;
        end;

        u45 = u45 + 1;
        u22 = false;

        if u21 and u21.IsPlaying then
            u21:Stop(0.1);
        end;
    end);
    RunService.Heartbeat:Connect(function() -- Line: 1544
        -- upvalues: u30 (ref), LocalPlayer (ref)
        debug.profilebegin("Controllers/StealController/Heartbeat");

        if u30 then
            local Character = LocalPlayer.Character;
            local v182 = Character and (Character:FindFirstChildWhichIsA("Tool") and Character:FindFirstChildOfClass("Humanoid"));

            if v182 then
                v182:UnequipTools();
            end;
        end;

        debug.profileend();
    end);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 1562
        -- upvalues: u20 (ref), u21 (ref), u22 (ref), u36 (ref), u35 (ref), u30 (ref), LocalPlayer (ref)
        u20 = nil;
        u21 = nil;
        u22 = false;
        u36 = u36 + 1;
        local v183 = u35;
        u35 = nil;

        if v183 and v183.Parent then
            v183.Anchored = false;
        end;

        if u30 then
            if not u30 then
                return;
            end;

            u30 = false;
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

            if PlayerGui then
                PlayerGui = PlayerGui:FindFirstChild("BackpackGui");
            end;

            if PlayerGui then
                PlayerGui.Enabled = true;
            end;
        end;
    end);
end;

function v1.Start(p184) -- Line: 1578
    -- upvalues: Fruits2 (copy), u18 (copy)
    for _, child in Fruits2:GetChildren() do
        if child:IsA("ModuleScript") then
            u18[child.Name] = require(child);
        end;
    end;
end;

return v1;