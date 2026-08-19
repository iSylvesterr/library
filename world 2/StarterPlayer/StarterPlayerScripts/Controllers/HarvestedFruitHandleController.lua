-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local Environment = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Environment"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local MutationController = require(script.Parent.MutationController);
local Handles = game.Workspace.Handles;
local Hold_Above = script.Hold_Above;
local Fruits = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Fruits");
local Plants = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Plants");
local Fruits2 = ReplicatedStorage:WaitForChild("PlantGenerationModules"):WaitForChild("Fruits");
local Plants2 = ReplicatedStorage:WaitForChild("PlantGenerationModules"):WaitForChild("Plants");
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = CFrame.new(0, -0.5, 0.25);
local u8 = CFrame.new(0, -1.25, -0.5) * CFrame.Angles(-1.5707963267948966, 0, 0);

local function ApplyDecayFade(p9, p10) -- Line: 38
    if not p10 or p10 <= 0 then
        return;
    end;

    local v11 = p10 > 1 and 1 or p10;
    local v12 = 0;

    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v13, v14, v15 = Color3.toHSV(descendant.Color);
            descendant.Color = Color3.fromHSV(v13, v14 * (1 - v11 * 0.75), v15);
            v12 = v12 + 1;
        end;
    end;
end;

local u16 = RunService:IsStudio() or Environment.env == "Dev";

local function debugLog(...) -- Line: 60
    -- upvalues: u16 (copy)
    if u16 then
        print("[FruitHandle]", ...);
    end;
end;

local function debugWarn(...) -- Line: 66
    -- upvalues: u16 (copy)
    if u16 then
        warn("[FruitHandle]", ...);
    end;
end;

local function enableModelQuery(p17) -- Line: 91
    -- upvalues: u16 (copy), debugWarn (copy)
    local v18 = {};

    for _, descendant in p17:GetDescendants() do
        if descendant:IsA("BasePart") then
            v18[descendant] = descendant.CanQuery;
            descendant:SetAttribute("_AllowQuery", true);
            descendant.CanQuery = true;
        end;
    end;

    if u16 then
        local v19 = 0;

        for i in v18 do
            if i.CanQuery ~= true then
                v19 = v19 + 1;
            end;
        end;

        if v19 > 0 then
            debugWarn(("enableModelQuery: %d part(s) in %s had CanQuery reverted! Bottom raycast will miss them."):format(v19, p17:GetFullName()));
        end;
    end;

    return v18;
end;

local function restoreModelQuery(p20) -- Line: 117
    for i, v in p20 do
        if i and i.Parent then
            i:SetAttribute("_AllowQuery", nil);
            i.CanQuery = v;
        end;
    end;
end;

function v1.Init(p21) -- Line: 126
    -- upvalues: Fruits2 (copy), u6 (copy), Plants2 (copy)
    for _, child in Fruits2:GetChildren() do
        if child:IsA("ModuleScript") then
            u6[`Fruit_{child.Name}`] = require(child);
        end;
    end;

    for _, child in Plants2:GetChildren() do
        if child:IsA("ModuleScript") then
            u6[`Plant_{child.Name}`] = require(child);
        end;
    end;
end;

function v1.Start(u22) -- Line: 140
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u22:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p23) -- Line: 145
        -- upvalues: u22 (copy)
        u22:SetupPlayer(p23);
    end);
    Players.PlayerRemoving:Connect(function(p24) -- Line: 149
        -- upvalues: u2 (ref), Players (ref), u22 (copy)
        for i in u2 do
            local v25 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v25 == p24 then
                u22:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p26, p27) -- Line: 160
    p27.Anchored = false;
    p27.CanCollide = false;
    p27.CanQuery = false;
    p27.CanTouch = false;
    p27.Massless = true;
end;

function v1.PrepareMushroom(p28, p29) -- Line: 168
    p29.Anchored = false;
    p29.CanCollide = true;
    p29.CanQuery = false;
    p29.CanTouch = true;
    p29.CollisionGroup = "OnlyPlayers";
    p29.AssemblyLinearVelocity = Vector3.new(0, 100, 0);
    local v30 = script.Mushroom:Clone();
    v30.Parent = p29;
    v30.Enabled = true;
    p29.Massless = true;
end;

function v1.ClearHandle(p31, p32) -- Line: 181
    -- upvalues: debugLog (copy), u4 (copy)
    debugLog("ClearHandle called for tool:", p32.Name);

    for _, child in p32:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 187
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;

    local v33 = u4[p32];

    if v33 then
        if v33.animTrack then
            v33.animTrack:Stop();
            v33.animTrack = nil;
        end;

        if v33.model and v33.model.Parent then
            v33.model:Destroy();
        end;

        if v33.handle and v33.handle.Parent then
            v33.handle:Destroy();
        end;

        u4[p32] = nil;
    end;
end;

function v1.HasHandle(p34, p35) -- Line: 211
    -- upvalues: u4 (copy)
    local v36 = u4[p35];

    return v36 and (v36.handle and v36.handle.Parent) and true or false;
end;

function v1.GetModelMetrics(p37, p38) -- Line: 219
    -- upvalues: debugWarn (copy), debugLog (copy)
    local v39, v40 = p38:GetBoundingBox();
    local Position = v39.Position;
    local v41 = (1 / 0);
    local v42 = (-1 / 0);

    for _, descendant in p38:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local v43 = descendant.Position.Y - descendant.Size.Y / 2;
            local v44 = descendant.Position.Y + descendant.Size.Y / 2;

            if v43 >= v41 then
                v43 = v41;
            end;

            if v42 < v44 then
                v42 = v44;
                v41 = v43;
            else
                v41 = v43;
            end;
        end;
    end;

    if v41 == (1 / 0) or v42 == (-1 / 0) then
        debugWarn(("GetModelMetrics: \'%s\' has no visible parts right now - falling back to bounding box (size %.1f x %.1f x %.1f)"):format(p38.Name, v40.X, v40.Y, v40.Z));
        v41 = Position.Y - v40.Y / 2;
        v42 = Position.Y + v40.Y / 2;
    end;

    local v45 = v42 - v41;
    local v46 = Vector3.new(Position.X, v41, Position.Z);
    local v47 = (v40.X > 8 or v45 > 8) and true or v40.Z > 8;
    debugLog(("GetModelMetrics \'%s\': height=%.2f bounds=(%.1f, %.1f, %.1f) oversized=%s"):format(p38.Name, v45, v40.X, v40.Y, v40.Z, (tostring(v47))));

    return v45, v46, v47;
end;

function v1.WaitForAttributes(p48, u49, p50) -- Line: 264
    -- upvalues: debugLog (copy), debugWarn (copy)
    local function ready() -- Line: 265
        -- upvalues: u49 (copy)
        local v51;

        if u49:GetAttribute("FruitName") == nil then
            v51 = false;
        else
            v51 = u49:GetAttribute("Seed") ~= nil;
        end;

        return v51;
    end;

    local v52;

    if u49:GetAttribute("FruitName") == nil then
        v52 = false;
    else
        v52 = u49:GetAttribute("Seed") ~= nil;
    end;

    if v52 then
        return true;
    end;

    debugLog("Waiting for attributes to replicate on tool:", u49.Name);
    local u53 = false;
    local BindableEvent = Instance.new("BindableEvent");
    local v55 = u49.AttributeChanged:Connect(function() -- Line: 285
        -- upvalues: u49 (copy), u53 (ref), BindableEvent (copy)
        local v54;

        if u49:GetAttribute("FruitName") == nil then
            v54 = false;
        else
            v54 = u49:GetAttribute("Seed") ~= nil;
        end;

        if v54 then
            u53 = true;
            BindableEvent:Fire();
        end;
    end);
    local v56;

    if u49:GetAttribute("FruitName") == nil then
        v56 = false;
    else
        v56 = u49:GetAttribute("Seed") ~= nil;
    end;

    if v56 then
        u53 = true;
        v55:Disconnect();
        BindableEvent:Destroy();

        return true;
    end;

    task.delay(p50, function() -- Line: 300
        -- upvalues: u53 (ref), BindableEvent (copy)
        if not u53 then
            BindableEvent:Fire();
        end;
    end);
    BindableEvent.Event:Wait();
    v55:Disconnect();
    BindableEvent:Destroy();

    if not u53 then
        debugWarn("TIMEOUT waiting for attributes on tool:", u49.Name);
    end;

    return u53;
end;

function v1.SpawnHandle(u57, u58, p59, p60) -- Line: 317
    -- upvalues: u5 (copy), Players (copy), LocalPlayer (copy), debugWarn (copy), Fruits (copy), Plants (copy), u6 (copy), MutationController (copy), ApplyDecayFade (copy), debugLog (copy), enableModelQuery (copy), restoreModelQuery (copy), Handles (copy), u4 (copy), HandleScale (copy), u7 (copy), Hold_Above (copy), u8 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u5[u58] then
        return;
    end;

    u5[u58] = true;
    u57:ClearHandle(u58);
    local v61 = Players:GetPlayerFromCharacter(p59) == LocalPlayer;

    if not u57:WaitForAttributes(u58, 5) then
        debugWarn("SpawnHandle ABORTED - attributes never replicated. Tool:", u58.Name);
        u5[u58] = nil;

        return;
    end;

    local v62 = u58:GetAttribute("FruitName");
    local v63 = u58:GetAttribute("Seed");
    local v64 = u58:GetAttribute("SizeMultiplier") or 1;
    local _ = u58:GetAttribute("OvertimeGrowth") or 1;
    local v65 = u58:GetAttribute("Mutation");
    local v66 = u58:GetAttribute("DecayAlpha");

    if not (v62 and v63) then
        u5[u58] = nil;

        return;
    end;

    local v67 = Fruits:FindFirstChild(v62) or Plants:FindFirstChild(v62);

    if not v67 then
        debugWarn("SpawnHandle: no asset template for", v62);
        u5[u58] = nil;

        return;
    end;

    local v68 = v67.Parent.Name == Fruits.Name;
    local v69 = u6[v68 and `Fruit_{v62}` or `Plant_{v62}`];

    if not v69 then
        debugWarn("SpawnHandle: no generation module for", v62);
        u5[u58] = nil;

        return;
    end;

    local v70 = p59:FindFirstChild("Right Arm") or p59:FindFirstChild("RightHand");

    if not v70 then
        debugWarn("SpawnHandle: character has no Right Arm / RightHand");
        u5[u58] = nil;

        return;
    end;

    local v71 = p59:GetScale();
    local v72 = v67:Clone();
    v72:SetAttribute("MaxAge", 100000);
    v72:SetAttribute("Age", 100000);

    if v65 and v65 ~= "" then
        v72:SetAttribute("Mutation", v65);
    end;

    v69[v68 and "InitFruit" or "InitPlant"](v72, v63, v64, os.time());
    local v73 = 0;

    repeat
        v73 = v73 + task.wait();
    until v72:HasTag("InitializationComplete") or v73 > 5;

    if v73 > 5 then
        debugWarn("SpawnHandle: initialization timed out for", v62, "- metrics below may be measured mid-init");
    end;

    v69[v68 and "BeginFruitGrowth" or "BeginPlantGrowth"](v72);
    local HarvestPrompt = v72:FindFirstChild("HarvestPrompt", true);

    if HarvestPrompt and HarvestPrompt:IsA("ProximityPrompt") then
        HarvestPrompt:Destroy();
    end;

    MutationController:ApplyMutation(v72);

    if not v65 or v65 == "" then
        ApplyDecayFade(v72, v66);
    end;

    local v74, _, v75 = u57:GetModelMetrics(v72);
    local PrimaryPart = v72.PrimaryPart;

    if not PrimaryPart then
        debugWarn("SpawnHandle: fruit has no PrimaryPart after init:", v62);
        v72:Destroy();
        u5[u58] = nil;

        return;
    end;

    local Part = Instance.new("Part");
    Part.Name = "FruitAnchor";
    Part.Size = Vector3.new(0.01, 0.01, 0.01);
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    local v76 = v72:GetAttribute("FlipWhenHeld") == true and true or ({
        Strawberry = true
    })[v62] == true;

    if v76 then
        local v77 = v72:GetBoundingBox();
        local v78 = CFrame.Angles(3.141592653589793, 0, 0);

        for _, descendant in v72:GetDescendants() do
            if descendant:IsA("BasePart") then
                local v79 = v77:ToObjectSpace(descendant.CFrame);
                descendant.CFrame = v77 * v78 * v79;
            end;
        end;

        debugLog(("\'%s\' flipped 180 around bounding-box center BEFORE bottom detection"):format(v62));
    end;

    local v80 = (1 / 0);
    local v81 = nil;

    for _, descendant in v72:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local v82 = descendant.Position.Y - descendant.Size.Y / 2;

            if v82 < v80 then
                v81 = descendant;
                v80 = v82;
            end;
        end;
    end;

    if v80 == (1 / 0) then
        v80 = PrimaryPart.Position.Y - PrimaryPart.Size.Y / 2;
        debugWarn("SpawnHandle: no visible parts when finding bottom of", v62, "- using PrimaryPart fallback Y =", v80);
    end;

    v72.Parent = workspace;
    local v83 = enableModelQuery(v72);
    local v84 = RaycastParams.new();
    v84.FilterDescendantsInstances = { v72 };
    v84.FilterType = Enum.RaycastFilterType.Include;
    local v85 = CFrame.new(PrimaryPart.Position.X, v80, PrimaryPart.Position.Z);
    local v86 = Vector3.new(PrimaryPart.Position.X, PrimaryPart.Position.Y - 100, PrimaryPart.Position.Z);

    for _ = 1, 20 do
        local v87 = workspace:Raycast(v86, Vector3.new(0, 300, 0), v84);

        if not v87 then
            debugWarn(("SpawnHandle: bottom raycast MISSED for \'%s\' - using iterated lowestY=%.2f (part: %s). If this is frequent, check the asset\'s CanQuery/Transparency."):format(v62, v80, v81 and v81.Name or "?"));
            break;
        end;

        if v87.Instance.Transparency < 1 then
            v85 = CFrame.new(v87.Position);
            debugLog(("SpawnHandle: bottom raycast hit \'%s\' at Y=%.2f for \'%s\'%s"):format(v87.Instance.Name, v87.Position.Y, v62, v76 and " (post-flip geometry)" or ""));
            break;
        end;

        v86 = Vector3.new(v86.X, v87.Position.Y + 0.01, v86.Z);
    end;

    restoreModelQuery(v83);
    Part.CFrame = v85 * CFrame.new(0, 0.5, 0);
    Part.Parent = v72;
    local Part2 = Instance.new("Part");
    Part2.Transparency = 1;
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.Size = Vector3.new(1, 1, 1);
    Part2.Parent = game.Workspace.Temporary;
    local v88 = u58.Parent and u58.Parent:FindFirstChild("HumanoidRootPart");
    local v89;

    if v88 then
        v89 = v88.CFrame or v85;
    else
        v89 = v85;
    end;

    Part2.CFrame = v89;
    local Default = game.SoundService.SFX.FruitSFX.Default;

    if v65 and v65 ~= "" then
        for _, child in pairs(game.SoundService.SFX.FruitSFX:GetChildren()) do
            if child.Name == v65 then
                Default = child;
                break;
            end;
        end;
    end;

    local v90 = Default:Clone();
    v90.Parent = Part2;
    v90.PlaybackSpeed = 1 + math.random(-15, 15) / 100;

    if v75 then
        v90.Volume = v90.Volume * 1.75;
    end;

    v90.Playing = not p60;
    game.Debris:AddItem(Part2, v90.TimeLength * v90.PlaybackSpeed);
    v72.PrimaryPart = Part;

    for _, descendant in v72:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant:HasTag("MuhsroomTop") then
                u57:PrepareMushroom(descendant);
            else
                u57:PreparePartForTool(descendant);
            end;
        end;
    end;

    local v91 = v72:GetAttribute("HeldYOffset");
    local v92 = type(v91) ~= "number" and (({
        ["Moon Bloom"] = 1,
        ["Dragon\'s Breath"] = 1,
        Bamboo = 3
    })[v62] or 0) or v91;

    for _, descendant in v72:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= Part then
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = Part;
            WeldConstraint.Part1 = descendant;
            WeldConstraint.Parent = descendant;
        end;
    end;

    v72.Name = "Build";
    v72.Parent = Handles;
    u4[u58] = {
        handle = Part,
        model = v72
    };
    local Part3 = Instance.new("Part");
    Part3.Name = "Handle";
    Part3.Size = Vector3.new(1, 1, 1);
    Part3.Transparency = 1;
    Part3.CanCollide = false;
    Part3.CanQuery = false;
    Part3.CanTouch = false;
    Part3.Massless = true;
    Part3.Parent = u58;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Parent = Part3;
    WeldConstraint.Part0 = Part3;
    WeldConstraint.Part1 = v70;

    if v61 then
        u58.Grip = HandleScale.ScaleGripTranslation(u7, v71);
    end;

    if v75 then
        debugLog(("\'%s\' is OVERSIZED (height %.2f vs threshold %d) -> hold-above"):format(v62, v74, 8));
        Part.CFrame = v85 * CFrame.new(0, -0.5, 0);
        local Head = p59:FindFirstChild("Head");

        if Head then
            local v93 = p59:FindFirstChildOfClass("Humanoid");

            if v93 then
                local u94 = v93:FindFirstChildOfClass("Animator");

                if u94 and Hold_Above then
                    local success, result = pcall(function() -- Line: 641
                        -- upvalues: u94 (copy), Hold_Above (ref)
                        return u94:LoadAnimation(Hold_Above);
                    end);

                    if success and result then
                        result.Looped = true;
                        result.Priority = Enum.AnimationPriority.Action4;
                        result:Play();
                        u4[u58].animTrack = result;
                    else
                        debugWarn("Hold-above animation failed to load:", result);
                    end;
                end;
            end;

            Part.CFrame = Head.CFrame * HandleScale.ScaleGripTranslation(CFrame.new(0, v92 + 1, 0), v71);
            local WeldConstraint2 = Instance.new("WeldConstraint");
            WeldConstraint2.Part0 = Part;
            WeldConstraint2.Part1 = Head;
            WeldConstraint2.Parent = Part;
        else
            debugWarn("Oversized fruit but no Head found - falling back to arm hold");
            Part.CFrame = v70.CFrame * HandleScale.ScaleGripTranslation(u8, v71);
            local WeldConstraint2 = Instance.new("WeldConstraint");
            WeldConstraint2.Part0 = Part;
            WeldConstraint2.Part1 = v70;
            WeldConstraint2.Parent = Part;
        end;
    else
        debugLog(("\'%s\' is normal-sized (height %.2f) -> arm hold"):format(v62, v74));
        Part.CFrame = v70.CFrame * HandleScale.ScaleGripTranslation(u8, v71);
        local WeldConstraint2 = Instance.new("WeldConstraint");
        WeldConstraint2.Part0 = Part;
        WeldConstraint2.Part1 = v70;
        WeldConstraint2.Parent = Part;
    end;

    HeldHandleSelfHeal.WatchHandle(u58, Part, function() -- Line: 691
        -- upvalues: u3 (ref), u58 (copy)
        return u3[u58];
    end, function() -- Line: 692
        -- upvalues: u57 (copy), u58 (copy)
        return u57:HasHandle(u58);
    end, function() -- Line: 693
        -- upvalues: u3 (ref), u58 (copy), u57 (copy)
        local v95 = u3[u58];

        if v95 then
            u57:SpawnHandle(u58, v95, true);
        end;
    end);
    debugLog("SpawnHandle complete for:", u58.Name);
    u5[u58] = nil;

    if u58.Parent ~= p59 then
        u57:ClearHandle(u58);
    end;
end;

function v1.UpdateToolState(p96, p97) -- Line: 706
    -- upvalues: u5 (copy), u3 (copy)
    if u5[p97] then
        return;
    end;

    local v98 = u3[p97];

    if not v98 then
        return;
    end;

    local v99 = p97.Parent == v98;
    local v100 = p96:HasHandle(p97);

    if v99 and not v100 then
        p96:SpawnHandle(p97, v98);

        return;
    end;

    if not v99 and v100 then
        p96:ClearHandle(p97);
    end;
end;

function v1.DisconnectTool(p101, p102) -- Line: 722
    -- upvalues: u2 (copy), u3 (copy), u5 (copy)
    local v103 = u2[p102];

    if v103 then
        for _, v in v103 do
            v:Disconnect();
        end;

        u2[p102] = nil;
    end;

    u3[p102] = nil;
    u5[p102] = nil;
end;

function v1.CleanupTool(p104, p105) -- Line: 734
    p104:ClearHandle(p105);
    p104:DisconnectTool(p105);
end;

function v1.IsTrackedTool(p106, p107) -- Line: 739
    return p107:GetAttribute("HarvestedFruit") == true;
end;

function v1.SetupTool(u108, u109, p110) -- Line: 743
    -- upvalues: u3 (copy), u2 (copy)
    u108:DisconnectTool(u109);
    local v111 = {};
    u3[u109] = p110;
    local v112 = u109:GetPropertyChangedSignal("Parent");
    table.insert(v111, v112:Connect(function() -- Line: 749
        -- upvalues: u109 (copy), u108 (copy), u3 (ref)
        task.defer(function() -- Line: 750
            -- upvalues: u109 (ref), u108 (ref), u3 (ref)
            if not u109 then
                return;
            end;

            if u109.Parent then
                if u3[u109] then
                    u108:UpdateToolState(u109);
                end;

                return;
            end;

            u108:ClearHandle(u109);
        end);
    end));
    table.insert(v111, u109.Destroying:Connect(function() -- Line: 764
        -- upvalues: u108 (copy), u109 (copy)
        u108:CleanupTool(u109);
    end));
    u2[u109] = v111;
    task.defer(function() -- Line: 770
        -- upvalues: u109 (copy), u3 (ref), u108 (copy)
        if u109 and u3[u109] then
            u108:UpdateToolState(u109);
        end;
    end);
end;

function v1.DisconnectAllFruitTools(p113) -- Line: 777
    -- upvalues: u2 (copy)
    for i in u2 do
        p113:DisconnectTool(i);
    end;
end;

function v1.CleanupAllToolsForCharacter(p114, p115) -- Line: 783
    -- upvalues: u3 (copy), Handles (copy)
    for i, v in u3 do
        if v == p115 then
            p114:CleanupTool(i);
        end;
    end;

    for _, child in Handles:GetChildren() do
        if child.Name == "Build" and child:IsA("Model") then
            local PrimaryPart = child.PrimaryPart;

            if PrimaryPart then
                for _, descendant in PrimaryPart:GetDescendants() do
                    if descendant:IsA("WeldConstraint") then
                        local Part1 = descendant.Part1;

                        if Part1 and Part1:IsDescendantOf(p115) then
                            child:Destroy();
                            break;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function v1.SetupCharacter(u116, u117) -- Line: 810
    -- upvalues: u4 (copy), Players (copy), HandleScale (copy)
    u117.ChildRemoved:Connect(function(p118) -- Line: 813
        -- upvalues: u4 (ref), u116 (copy)
        if p118:IsA("Tool") and u4[p118] then
            u116:CleanupTool(p118);
        end;
    end);
    u117.Destroying:Connect(function() -- Line: 822
        -- upvalues: u116 (copy), u117 (copy)
        u116:CleanupAllToolsForCharacter(u117);
    end);
    task.defer(function() -- Line: 826
        -- upvalues: u117 (copy), u116 (copy), Players (ref), HandleScale (ref)
        if not (u117 and u117.Parent) then
            return;
        end;

        for _, child in u117:GetChildren() do
            if child:IsA("Tool") then
                if u116:IsTrackedTool(child) then
                    u116:SetupTool(child, u117);
                else
                    u116:ListenForTrackedAttribute(child, u117);
                end;
            end;
        end;

        local v119 = Players:GetPlayerFromCharacter(u117);

        if v119 and v119.Backpack then
            for _, child in v119.Backpack:GetChildren() do
                if child:IsA("Tool") then
                    if u116:IsTrackedTool(child) then
                        u116:SetupTool(child, u117);
                    else
                        u116:ListenForTrackedAttribute(child, u117);
                    end;
                end;
            end;
        end;

        u117.ChildAdded:Connect(function(u120) -- Line: 855
            -- upvalues: u117 (ref), u116 (ref)
            if u120:IsA("Tool") then
                task.defer(function() -- Line: 857
                    -- upvalues: u120 (copy), u117 (ref), u116 (ref)
                    if not (u120 and (u120.Parent and (u117 and u117.Parent))) then
                        return;
                    end;

                    if u116:IsTrackedTool(u120) then
                        u116:SetupTool(u120, u117);

                        return;
                    end;

                    u116:ListenForTrackedAttribute(u120, u117);
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u117, function(p121) -- Line: 870
            -- upvalues: u116 (ref)
            return u116:IsTrackedTool(p121);
        end, function(p122, p123) -- Line: 871
            -- upvalues: u116 (ref)
            u116:SpawnHandle(p122, p123);
        end);
    end);
end;

function v1.ListenForTrackedAttribute(u124, u125, u126) -- Line: 877
    -- upvalues: u2 (copy)
    if u2[u125] then
        return;
    end;

    local u127 = nil;
    u127 = u125.AttributeChanged:Connect(function(p128) -- Line: 882
        -- upvalues: u124 (copy), u125 (copy), u127 (ref), u126 (copy)
        if p128 == "HarvestedFruit" and u124:IsTrackedTool(u125) then
            u127:Disconnect();
            task.defer(function() -- Line: 885
                -- upvalues: u125 (ref), u126 (ref), u124 (ref)
                if u125 and (u125.Parent and (u126 and u126.Parent)) then
                    u124:SetupTool(u125, u126);
                end;
            end);
        end;
    end);
    u125.Destroying:Once(function() -- Line: 894
        -- upvalues: u127 (ref)
        if u127.Connected then
            u127:Disconnect();
        end;
    end);

    if u124:IsTrackedTool(u125) then
        u127:Disconnect();
        task.defer(function() -- Line: 903
            -- upvalues: u125 (copy), u126 (copy), u124 (copy)
            if u125 and (u125.Parent and (u126 and u126.Parent)) then
                u124:SetupTool(u125, u126);
            end;
        end);
    end;
end;

function v1.SetupPlayer(u129, u130) -- Line: 911
    -- upvalues: BackpackListener (copy)
    if u130.Character then
        u129:SetupCharacter(u130.Character);
    end;

    u130.CharacterAdded:Connect(function(p131) -- Line: 916
        -- upvalues: u129 (copy)
        u129:SetupCharacter(p131);
    end);
    BackpackListener.bind(u130, function(u132) -- Line: 923
        -- upvalues: u130 (copy), u129 (copy)
        if not u132:IsA("Tool") then
            return;
        end;

        task.defer(function() -- Line: 925
            -- upvalues: u130 (ref), u132 (copy), u129 (ref)
            local Character = u130.Character;

            if not (u132 and (u132.Parent and (Character and Character.Parent))) then
                return;
            end;

            if u129:IsTrackedTool(u132) then
                u129:SetupTool(u132, Character);

                return;
            end;

            u129:ListenForTrackedAttribute(u132, Character);
        end);
    end);
end;

return v1;