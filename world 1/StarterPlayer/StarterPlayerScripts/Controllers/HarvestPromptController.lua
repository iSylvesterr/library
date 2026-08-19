-- Decompiled with Potassium's decompiler.

local v1 = {};
local CollectionService = game:GetService("CollectionService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local DevProductController = require(game.Players.LocalPlayer.PlayerScripts.Controllers.DevProductController);
local HarvestFlags = require(ReplicatedStorage.SharedModules.Flags.HarvestFlags);
local PlantBehaviorRules = require(ReplicatedStorage.SharedModules.PlantBehaviorRules);
local MessagePrompt = require(ReplicatedStorage.ClientModules.MessagePrompt);
local u2 = nil;
local u3 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local HoldToCollect = PlayerGui:WaitForChild("HoldToCollect");
local Collect = HoldToCollect:WaitForChild("Collect");
local HoldToSteal = PlayerGui:WaitForChild("HoldToSteal");
local Collect2 = HoldToSteal:WaitForChild("Collect");
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = 0;

local function isBlockedBambooSteal(p13) -- Line: 56
    local v14 = p13:HasTag("StealPrompt") and p13.HoldDuration > 0;

    return v14;
end;

local function triggerPromptProgrammatically(u15) -- Line: 60
    u15:InputHoldBegin();

    if u15.HoldDuration > 0 then
        task.delay(u15.HoldDuration + 0.05, function() -- Line: 63
            -- upvalues: u15 (copy)
            if u15 and u15:IsDescendantOf(workspace) then
                u15:InputHoldEnd();
            end;
        end);

        return;
    end;

    u15:InputHoldEnd();
end;

local u16 = {};

local function requestForeverHarvest(u17, u18) -- Line: 78
    -- upvalues: LocalPlayer (copy), u16 (copy), MessagePrompt (copy), u2 (ref)
    if LocalPlayer:GetAttribute("LoadingScreenActive") then
        return;
    end;

    local u19 = `{u17}:{u18 or ""}`;

    if u16[u19] then
        return;
    end;

    u16[u19] = true;
    task.spawn(function() -- Line: 89
        -- upvalues: MessagePrompt (ref), u16 (ref), u19 (copy), u2 (ref), u17 (copy), u18 (copy)
        local v20 = MessagePrompt.Prompt({
            message = "This will grow forever, are you sure you want to harvest now? <font color=\"#4CFF4C\">Bigger = higher payout!</font>",
            titleOverride = "Harvest?",
            yield = true,
            hideClose = true,
            options = MessagePrompt.Choices.YesNo
        });
        u16[u19] = nil;

        if v20 then
            u2.Garden.CollectFruit:Fire(u17, u18 or "");
        end;
    end);
end;

local u30 = {
    {
        name = "Harvest",
        tag = "HarvestPrompt",
        holding = false,
        pressing = false,
        activateOnTrigger = true,
        ui = HoldToCollect,
        button = Collect,
        visible = {},
        queue = {},

        perform = function(p21, p22, p23, p24) -- Line: 116, Name: perform
            -- upvalues: PlantBehaviorRules (copy), requestForeverHarvest (copy), u2 (ref)
            if p22 and PlantBehaviorRules.GrowsForever(p22:GetAttribute("CorePartName")) then
                requestForeverHarvest(p23, p24);

                return;
            end;

            u2.Garden.CollectFruit:Fire(p23, p24 or "");
        end
    },
    {
        name = "Steal",
        tag = "StealPrompt",
        holding = false,
        pressing = false,
        activateOnTrigger = false,
        ui = HoldToSteal,
        button = Collect2,
        visible = {},
        queue = {},

        gate = function() -- Line: 125, Name: isNight
            -- upvalues: ReplicatedStorage (copy)
            local Night = ReplicatedStorage:FindFirstChild("Night");
            local v25;

            if Night == nil then
                v25 = false;
            else
                v25 = Night.Value == true;
            end;

            return v25;
        end,

        perform = function(p26, p27, p28, p29) -- Line: 141, Name: perform
            -- upvalues: triggerPromptProgrammatically (copy)
            triggerPromptProgrammatically(p26);
        end
    }
};

local function getChannelForPrompt(p31) -- Line: 148
    -- upvalues: u30 (copy)
    for _, v in u30 do
        if p31:HasTag(v.tag) then
            return v;
        end;
    end;

    return nil;
end;

local function getCharacterPosition() -- Line: 157
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

local function getModelForPrompt(p32) -- Line: 171
    local Parent = p32.Parent;

    if Parent then
        return Parent:FindFirstAncestorWhichIsA("Model");
    end;

    return nil;
end;

local function getClosestPointOnPart(p33, p34) -- Line: 180
    local v35 = p33.CFrame:PointToObjectSpace(p34);
    local v36 = p33.Size * 0.5;
    local v37 = math.clamp(v35.X, -v36.X, v36.X);
    local v38 = math.clamp(v35.Y, -v36.Y, v36.Y);
    local v39 = math.clamp(v35.Z, -v36.Z, v36.Z);
    local v40 = Vector3.new(v37, v38, v39);

    return p33.CFrame:PointToWorldSpace(v40);
end;

local function getBestPromptPosition(p41, p42) -- Line: 193
    -- upvalues: getClosestPointOnPart (copy)
    local v43 = (1 / 0);
    local v44 = nil;

    for _, v in p41 do
        if v.Parent then
            local v45 = getClosestPointOnPart(v, p42);
            local Magnitude = (p42 - v45).Magnitude;

            if Magnitude < v43 then
                v44 = v45;
                v43 = Magnitude;
            end;
        end;
    end;

    if not v44 then
        return nil;
    end;

    local v46 = p42 - v44;

    return v44 + (v46.Magnitude < 0.0001 and Vector3.new(0, 1, 0) or v46.Unit) * 0.75;
end;

local function rebuildHarvestPartCache(p47) -- Line: 222
    -- upvalues: CollectionService (copy)
    local v48 = {};

    for _, descendant in p47:GetDescendants() do
        if descendant:IsA("BasePart") and (descendant.Name ~= "HarvestPart" and not CollectionService:HasTag(descendant, "MutationVFX")) then
            table.insert(v48, descendant);
        end;
    end;

    return v48;
end;

local function getModelBoundingRadius(p49) -- Line: 232
    -- upvalues: CollectionService (copy)
    local Position = p49:GetPivot().Position;
    local v50 = 0;

    for _, descendant in p49:GetDescendants() do
        if descendant:IsA("BasePart") and not CollectionService:HasTag(descendant, "MutationVFX") then
            local v51 = descendant.Size * 0.5;
            local CFrame2 = descendant.CFrame;

            for _, v in { -1, 1 } do
                for _, v2 in { -1, 1 } do
                    for _, v3 in { -1, 1 } do
                        local Magnitude = (CFrame2:PointToWorldSpace((Vector3.new(v * v51.X, v2 * v51.Y, v3 * v51.Z))) - Position).Magnitude;

                        if v50 < Magnitude then
                            v50 = Magnitude;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v50 > 0 and v50 and v50 or select(2, p49:GetBoundingBox()).Magnitude * 0.5;
end;

local function getOrCreateModelHarvestPart(p52) -- Line: 251
    local HarvestPart = p52:FindFirstChild("HarvestPart");

    if HarvestPart and HarvestPart:IsA("BasePart") then
        return HarvestPart;
    end;

    local v53 = p52.PrimaryPart or p52:FindFirstChildWhichIsA("BasePart");

    if not v53 then
        return nil;
    end;

    local Part = Instance.new("Part");
    Part.Name = "HarvestPart";
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CFrame = v53.CFrame;
    Part.Parent = p52;

    return Part;
end;

local function destroyCurrentHighlight() -- Line: 276
    -- upvalues: u9 (ref), u10 (ref)
    if u9 then
        u9:Destroy();
        u9 = nil;
    end;

    u10 = nil;
end;

local function applyHighlightToModel(p54) -- Line: 284
    -- upvalues: u10 (ref), u9 (ref)
    if u10 == p54 and (u9 and u9.Parent) then
        return;
    end;

    if u9 then
        u9:Destroy();
        u9 = nil;
    end;

    u10 = nil;
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "ActiveHarvestHighlight";
    Highlight.Adornee = p54;
    Highlight.FillColor = Color3.fromRGB(255, 224, 94);
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255);
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 0.5;
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.Parent = p54;
    u9 = Highlight;
    u10 = p54;
end;

local function updateActivePromptHighlight() -- Line: 305
    -- upvalues: LocalPlayer (copy), u9 (ref), u10 (ref), u4 (copy), u5 (copy), applyHighlightToModel (copy)
    local Character = LocalPlayer.Character;
    local v55;

    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            v55 = HumanoidRootPart.Position;
        else
            v55 = nil;
        end;
    else
        v55 = nil;
    end;

    if not v55 then
        if u9 then
            u9:Destroy();
            u9 = nil;
        end;

        u10 = nil;

        return;
    end;

    local v56 = (1 / 0);
    local v57 = nil;

    for i in u4 do
        if i:IsDescendantOf(workspace) and i.Enabled then
            local Parent = i.Parent;
            local v58;

            if Parent then
                v58 = Parent:FindFirstAncestorWhichIsA("Model");
            else
                v58 = nil;
            end;

            if v58 then
                local v59 = u5[i];
                local v60 = v59 and v59.boundingRadius or 0;
                local v61 = (v55 - v58:GetPivot().Position).Magnitude - v60;

                if v61 < v56 then
                    v57 = i;
                    v56 = v61;
                end;
            end;
        end;
    end;

    if not v57 then
        if u9 then
            u9:Destroy();
            u9 = nil;
        end;

        u10 = nil;

        return;
    end;

    local Parent = v57.Parent;
    local v62;

    if Parent then
        v62 = Parent:FindFirstAncestorWhichIsA("Model");
    else
        v62 = nil;
    end;

    if v62 then
        applyHighlightToModel(v62);

        return;
    end;

    if u9 then
        u9:Destroy();
        u9 = nil;
    end;

    u10 = nil;
end;

local function isSmartPrompt(p63) -- Line: 346
    return p63:HasTag("HarvestPrompt") or (p63:HasTag("StealPrompt") or p63:HasTag("GrowPrompt"));
end;

local function trackSmartPrompt(u64) -- Line: 352
    -- upvalues: u5 (copy), getOrCreateModelHarvestPart (copy), rebuildHarvestPartCache (copy), getModelBoundingRadius (copy), u6 (copy), u4 (copy), u30 (copy), updateActivePromptHighlight (copy), u11 (ref)
    if u5[u64] then
        return;
    end;

    if not u64:IsDescendantOf(workspace) then
        return;
    end;

    local Parent = u64.Parent;
    local u65;

    if Parent then
        u65 = Parent:FindFirstAncestorWhichIsA("Model");
    else
        u65 = nil;
    end;

    local Parent2 = u64.Parent;

    if not (u65 and (Parent2 and Parent2:IsA("BasePart"))) then
        return;
    end;

    u64.MaxActivationDistance = 10;
    local v66;

    if Parent2.Name == "HarvestPart" then
        v66 = Parent2;
    else
        v66 = getOrCreateModelHarvestPart(u65);

        if v66 then
            u64.Parent = v66;
        else
            v66 = Parent2;
        end;
    end;

    local u67 = {
        needsSnap = true,
        rebuildPending = false,
        model = u65,
        part = v66,
        parts = rebuildHarvestPartCache(u65),
        boundingRadius = getModelBoundingRadius(u65),
        cachedPivot = u65:GetPivot().Position,
        pivotRefreshedAt = os.clock(),
        lastPositionedAt = os.clock()
    };

    local function refreshParts(p68) -- Line: 390
        -- upvalues: u67 (copy), u5 (ref), u64 (copy), u65 (copy), rebuildHarvestPartCache (ref), getModelBoundingRadius (ref)
        if p68 and not p68:IsA("BasePart") then
            return;
        end;

        if u67.rebuildPending then
            return;
        end;

        u67.rebuildPending = true;
        task.defer(function() -- Line: 394
            -- upvalues: u67 (ref), u5 (ref), u64 (ref), u65 (ref), rebuildHarvestPartCache (ref), getModelBoundingRadius (ref)
            u67.rebuildPending = false;

            if not (u5[u64] and u65.Parent) then
                return;
            end;

            u67.parts = rebuildHarvestPartCache(u65);
            u67.boundingRadius = getModelBoundingRadius(u65);
        end);
    end;

    u67.partsConn = u65.DescendantAdded:Connect(refreshParts);
    u67.partsRemovedConn = u65.DescendantRemoving:Connect(refreshParts);
    u5[u64] = u67;
    u64.Destroying:Once(function() -- Line: 407
        -- upvalues: u5 (ref), u64 (copy), u6 (ref), u4 (ref), u30 (ref), updateActivePromptHighlight (ref), u11 (ref)
        local v69 = u5[u64];

        if v69 then
            if v69.partsConn then
                v69.partsConn:Disconnect();
            end;

            if v69.partsRemovedConn then
                v69.partsRemovedConn:Disconnect();
            end;
        end;

        u5[u64] = nil;
        u6[u64] = nil;
        u4[u64] = nil;

        for _, v in u30 do
            v.visible[u64] = nil;
        end;

        updateActivePromptHighlight();
        u11();
    end);
end;

local function untrackSmartPrompt(p70, p71) -- Line: 424
    -- upvalues: u7 (ref), u8 (ref), u5 (copy), u6 (copy)
    if p71.partsConn then
        p71.partsConn:Disconnect();
    end;

    if p71.partsRemovedConn then
        p71.partsRemovedConn:Disconnect();
    end;

    if u7 == p70 then
        u7 = nil;
    end;

    if u8 == p70 then
        u8 = nil;
    end;

    u5[p70] = nil;
    u6[p70] = nil;
end;

local function positionSmartPrompt(p72, p73, p74, p75) -- Line: 433
    -- upvalues: u7 (ref), u8 (ref), u5 (copy), u6 (copy), getBestPromptPosition (copy)
    local model = p73.model;
    local part = p73.part;

    if not (model and (model:IsDescendantOf(workspace) and (part and part.Parent))) then
        if p73.partsConn then
            p73.partsConn:Disconnect();
        end;

        if p73.partsRemovedConn then
            p73.partsRemovedConn:Disconnect();
        end;

        if u7 == p72 then
            u7 = nil;
        end;

        if u8 == p72 then
            u8 = nil;
        end;

        u5[p72] = nil;
        u6[p72] = nil;

        return;
    end;

    local Position = model:GetPivot().Position;
    p73.cachedPivot = Position;
    p73.pivotRefreshedAt = p75;

    if math.max(24, p72.MaxActivationDistance + 8) < (Position - p74).Magnitude - (p73.boundingRadius or 0) then
        return;
    end;

    local v76 = getBestPromptPosition(p73.parts, p74);

    if not v76 then
        return;
    end;

    if p73.needsSnap then
        part.CFrame = CFrame.new(v76);
        p73.needsSnap = false;
    else
        local v77 = math.clamp(p75 - (p73.lastPositionedAt or p75), 0, 0.5) * 18;
        local v78 = math.clamp(v77, 0, 1);
        local v79 = part.Position:Lerp(v76, v78);
        part.CFrame = CFrame.new(v79);
    end;

    p73.lastPositionedAt = p75;
end;

local function updateSmartPromptPositions(p80) -- Line: 471
    -- upvalues: LocalPlayer (copy), u7 (ref), u5 (copy), u8 (ref), u6 (copy), u4 (copy), positionSmartPrompt (copy)
    local Character = LocalPlayer.Character;
    local v81;

    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            v81 = HumanoidRootPart.Position;
        else
            v81 = nil;
        end;
    else
        v81 = nil;
    end;

    if not v81 then
        return;
    end;

    local v82 = os.clock();
    local v83 = 0;
    local v84, v85;

    if u7 then
        v84 = u7;
        v85 = u5[u7];

        if not v85 then
            v84, v85 = next(u5);
        end;
    else
        v84, v85 = next(u5);
    end;

    while v84 and v83 < 300 do
        local v86, v87 = next(u5, v84);

        if v84:IsDescendantOf(workspace) then
            if v82 - (v85.pivotRefreshedAt or 0) > 1 then
                local model = v85.model;

                if model and model.Parent then
                    v85.cachedPivot = model:GetPivot().Position;
                end;

                v85.pivotRefreshedAt = v82;
            end;

            local v88 = math.max(24, v84.MaxActivationDistance + 8) + (v85.boundingRadius or 0) + 16;
            local v89 = v85.cachedPivot - v81;

            if v89:Dot(v89) <= v88 * v88 then
                u6[v84] = true;
            else
                u6[v84] = nil;
            end;
        else
            if v85.partsConn then
                v85.partsConn:Disconnect();
            end;

            if v85.partsRemovedConn then
                v85.partsRemovedConn:Disconnect();
            end;

            if u7 == v84 then
                u7 = nil;
            end;

            if u8 == v84 then
                u8 = nil;
            end;

            u5[v84] = nil;
            u6[v84] = nil;
        end;

        v83 = v83 + 1;
        v85 = v87;
        v84 = v86;
    end;

    u7 = v84;

    for i in u4 do
        local v90 = u5[i];

        if v90 then
            positionSmartPrompt(i, v90, v81, v82);
        end;
    end;

    local v91 = 0;
    local v92 = u8;

    if v92 and u6[v92] == nil then
        v92 = nil;
    end;

    local v93 = v92 or next(u6);

    while v93 and v91 < 40 do
        local v94 = next(u6, v93);

        if not u4[v93] then
            local v95 = u5[v93];

            if v95 then
                positionSmartPrompt(v93, v95, v81, v82);
            else
                u6[v93] = nil;
            end;
        end;

        v91 = v91 + 1;
        v93 = v94;
    end;

    u8 = v93;
end;

local function isMobile() -- Line: 552
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
end;

local function u99(p96) -- Line: 556
    -- upvalues: UserInputService (copy)
    if not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) then
        p96.ui.Enabled = false;

        return;
    end;

    p96.ui.Enabled = true;

    if p96.gate and not p96.gate() then
        p96.button.Visible = false;

        return;
    end;

    if p96.pressing then
        p96.button.Visible = true;

        return;
    end;

    local v97 = false;

    for i in p96.visible do
        if i:IsDescendantOf(workspace) and i.Enabled then
            local v98 = i:HasTag("StealPrompt") and i.HoldDuration > 0;

            if not v98 then
                v97 = true;
                break;
            end;
        end;
    end;

    p96.button.Visible = v97;
end;

u11 = function() -- Line: 584
    -- upvalues: u30 (copy), u99 (ref)
    for _, v in u30 do
        u99(v);
    end;
end;

local function activatePrompt(p100, u101) -- Line: 590
    -- upvalues: HarvestFlags (copy)
    if p100.gate and not p100.gate() then
        return false;
    end;

    if not u101:IsDescendantOf(workspace) then
        return false;
    end;

    if not u101.Enabled then
        return false;
    end;

    if u101:GetAttribute("Collected") then
        return false;
    end;

    local v102 = u101:HasTag("StealPrompt") and u101.HoldDuration > 0;

    if v102 then
        return false;
    end;

    local Parent = u101.Parent;

    if not Parent then
        return false;
    end;

    local v103 = Parent:FindFirstAncestorWhichIsA("Model");

    if not v103 then
        return false;
    end;

    local v104 = v103:GetAttribute("PlantId");
    local v105 = v103:GetAttribute("FruitId");

    if p100.activateOnTrigger and not v104 then
        return false;
    end;

    u101:SetAttribute("Collected", true);
    local v106 = u101.HoldDuration <= 0 and 0 or u101.HoldDuration + 0.1;
    local v107 = HarvestFlags.ClientCollectCooldown:Get();
    local v108 = math.max(v107, v106);
    task.delay(v108, function() -- Line: 615
        -- upvalues: u101 (copy)
        if u101 and u101:IsDescendantOf(workspace) then
            u101:SetAttribute("Collected", nil);
        end;
    end);
    p100.perform(u101, v103, v104, v105);

    return true;
end;

local function enqueue(p109, p110) -- Line: 626
    if not table.find(p109.queue, p110) then
        table.insert(p109.queue, p110);
    end;
end;

local function dequeue(p111) -- Line: 632
    if #p111.queue == 0 then
        return nil;
    end;

    return table.remove(p111.queue, 1);
end;

local function getHoldLoopInterval(p112, p113) -- Line: 640
    -- upvalues: HarvestFlags (copy)
    if p112.tag ~= "HarvestPrompt" then
        return HarvestFlags.ClientCollectInterval:Get();
    end;

    local v114 = HarvestFlags.ClientCollectRampDuration:Get();
    local v115;

    if v114 > 0 then
        local v116 = (os.clock() - p113) / v114;
        v115 = math.clamp(v116, 0, 1);
    else
        v115 = 1;
    end;

    local v117 = HarvestFlags.ClientCollectRampStartInterval:Get();
    local v118 = HarvestFlags.ClientCollectRampEndInterval:Get();

    return math.lerp(v117, v118, v115);
end;

local function runHoldLoop(u119) -- Line: 654
    -- upvalues: ProximityPromptService (copy), activatePrompt (copy), getHoldLoopInterval (copy)
    if u119.holding then
        return;
    end;

    u119.holding = true;

    for i in u119.visible do
        if not table.find(u119.queue, i) then
            table.insert(u119.queue, i);
        end;
    end;

    local v122 = ProximityPromptService.PromptShown:Connect(function(p120) -- Line: 662
        -- upvalues: u119 (copy)
        if p120:HasTag(u119.tag) then
            local v121 = u119;

            if not table.find(v121.queue, p120) then
                table.insert(v121.queue, p120);
            end;
        end;
    end);
    local v123 = os.clock();

    while u119.holding do
        if #u119.queue == 0 then
            for i in u119.visible do
                if not table.find(u119.queue, i) then
                    table.insert(u119.queue, i);
                end;
            end;
        end;

        local v124;

        if #u119.queue == 0 then
            v124 = nil;
        else
            v124 = table.remove(u119.queue, 1);
        end;

        if v124 then
            activatePrompt(u119, v124);
        end;

        task.wait(getHoldLoopInterval(u119, v123));
    end;

    v122:Disconnect();
    table.clear(u119.queue);
end;

local function setButtonPressed(p125, p126) -- Line: 687
    -- upvalues: TweenService (copy), u3 (copy)
    local buttonScale = p125.buttonScale;

    if not buttonScale then
        return;
    end;

    TweenService:Create(buttonScale, u3, {
        Scale = p126 and 0.9 or 1
    }):Play();
end;

local function stopHoldLoop(p127) -- Line: 695
    -- upvalues: TweenService (copy), u3 (copy), u99 (ref)
    p127.holding = false;
    p127.pressing = false;
    local buttonScale = p127.buttonScale;

    if buttonScale then
        TweenService:Create(buttonScale, u3, {
            Scale = 1
        }):Play();
    end;

    u99(p127);
end;

local function stopAllHoldLoops() -- Line: 702
    -- upvalues: u30 (copy), TweenService (copy), u3 (copy), u99 (ref)
    for _, v in u30 do
        v.holding = false;
        v.pressing = false;
        local buttonScale = v.buttonScale;

        if buttonScale then
            TweenService:Create(buttonScale, u3, {
                Scale = 1
            }):Play();
        end;

        u99(v);
    end;
end;

local function beginKeyboardHoldWatch(p128) -- Line: 708
    -- upvalues: UserInputService (copy), runHoldLoop (copy)
    local u129 = false;
    local u130 = nil;
    u130 = UserInputService.InputEnded:Connect(function(p131) -- Line: 711
        -- upvalues: u130 (ref), u129 (ref)
        if p131.KeyCode == Enum.KeyCode.E or p131.KeyCode == Enum.KeyCode.ButtonX then
            u130:Disconnect();
            u129 = true;
        end;
    end);
    task.wait(0.5);

    if not u129 then
        u130:Disconnect();
        runHoldLoop(p128);
    end;
end;

local function bindChannelButton(u132) -- Line: 726
    -- upvalues: TweenService (copy), u3 (copy), u99 (ref), activatePrompt (copy), runHoldLoop (copy)
    local button = u132.button;

    if not button:IsA("GuiButton") then
        return;
    end;

    if not button:FindFirstChildOfClass("UIAspectRatioConstraint") then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
        UIAspectRatioConstraint.AspectRatio = 1;
        UIAspectRatioConstraint.Parent = button;
    end;

    local v133 = button:FindFirstChildOfClass("UIScale");

    if not v133 then
        v133 = Instance.new("UIScale");
        v133.Parent = button;
    end;

    u132.buttonScale = v133;
    button.MouseButton1Down:Connect(function() -- Line: 749
        -- upvalues: u132 (copy), TweenService (ref), u3 (ref), u99 (ref), activatePrompt (ref), button (copy), runHoldLoop (ref)
        u132.pressing = true;
        local buttonScale = u132.buttonScale;

        if buttonScale then
            TweenService:Create(buttonScale, u3, {
                Scale = 0.9
            }):Play();
        end;

        u99(u132);

        for i in u132.visible do
            activatePrompt(u132, i);
        end;

        local u134 = false;
        local v135 = button.MouseButton1Up:Once(function() -- Line: 760
            -- upvalues: u134 (ref)
            u134 = true;
        end);
        task.wait(0.5);

        if v135.Connected then
            v135:Disconnect();
        end;

        if not u134 then
            runHoldLoop(u132);
        end;
    end);
    button.MouseButton1Up:Connect(function() -- Line: 775
        -- upvalues: u132 (copy), TweenService (ref), u3 (ref), u99 (ref)
        local v136 = u132;
        v136.holding = false;
        v136.pressing = false;
        local buttonScale = v136.buttonScale;

        if buttonScale then
            TweenService:Create(buttonScale, u3, {
                Scale = 1
            }):Play();
        end;

        u99(v136);
    end);
    button.MouseLeave:Connect(function() -- Line: 779
        -- upvalues: u132 (copy), TweenService (ref), u3 (ref)
        local buttonScale = u132.buttonScale;

        if not buttonScale then
            return;
        end;

        TweenService:Create(buttonScale, u3, {
            Scale = 1
        }):Play();
    end);
end;

function v1.Init(p137) -- Line: 784
    -- upvalues: u2 (ref), ReplicatedStorage (copy), u11 (ref), CollectionService (copy), trackSmartPrompt (copy), ProximityPromptService (copy), u4 (copy), updateActivePromptHighlight (copy), u30 (copy), u99 (ref), bindChannelButton (copy), activatePrompt (copy), UserInputService (copy), beginKeyboardHoldWatch (copy), DevProductController (copy), TweenService (copy), u3 (copy), stopAllHoldLoops (copy), LocalPlayer (copy), RunService (copy), updateSmartPromptPositions (copy), u12 (ref)
    u2 = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"));
    u11();
    task.spawn(function() -- Line: 789
        -- upvalues: ReplicatedStorage (ref), u11 (ref)
        local Night = ReplicatedStorage:WaitForChild("Night", 10);

        if Night then
            Night.Changed:Connect(u11);
        end;
    end);

    for _, v in { "HarvestPrompt", "StealPrompt", "GrowPrompt" } do
        for _, v2 in CollectionService:GetTagged(v) do
            if v2:IsA("ProximityPrompt") then
                trackSmartPrompt(v2);
            end;
        end;

        CollectionService:GetInstanceAddedSignal(v):Connect(function(p138) -- Line: 803
            -- upvalues: trackSmartPrompt (ref)
            if p138:IsA("ProximityPrompt") then
                trackSmartPrompt(p138);
            end;
        end);
    end;

    ProximityPromptService.PromptShown:Connect(function(p139) -- Line: 810
        -- upvalues: trackSmartPrompt (ref), u4 (ref), updateActivePromptHighlight (ref), u30 (ref), u99 (ref)
        if p139:HasTag("HarvestPrompt") or (p139:HasTag("StealPrompt") or p139:HasTag("GrowPrompt")) then
            trackSmartPrompt(p139);
            u4[p139] = true;
            updateActivePromptHighlight();
        end;

        for _, v in u30 do
            if p139:HasTag(v.tag) then
                break;
            end;
        end;

        if v then
            v.visible[p139] = true;
            u99(v);
        end;
    end);
    ProximityPromptService.PromptHidden:Connect(function(p140) -- Line: 824
        -- upvalues: u30 (ref), u99 (ref), u4 (ref), updateActivePromptHighlight (ref)
        for _, v in u30 do
            if p140:HasTag(v.tag) then
                break;
            end;
        end;

        if v then
            v.visible[p140] = nil;
            u99(v);
        end;

        if p140:HasTag("HarvestPrompt") or (p140:HasTag("StealPrompt") or p140:HasTag("GrowPrompt")) then
            u4[p140] = nil;
            updateActivePromptHighlight();
        end;
    end);

    for _, v in u30 do
        bindChannelButton(v);
    end;

    ProximityPromptService.PromptTriggered:Connect(function(p141) -- Line: 841
        -- upvalues: u30 (ref), activatePrompt (ref)
        for _, v in u30 do
            if p141:HasTag(v.tag) then
                break;
            end;
        end;

        if v and v.activateOnTrigger then
            activatePrompt(v, p141);
        end;
    end);
    ProximityPromptService.PromptTriggered:Connect(function(p142) -- Line: 848
        -- upvalues: u30 (ref), UserInputService (ref), beginKeyboardHoldWatch (ref)
        for _, v in u30 do
            if p142:HasTag(v.tag) then
                break;
            end;
        end;

        if not v then
            return;
        end;

        if not (UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonX)) then
            return;
        end;

        beginKeyboardHoldWatch(v);
    end);
    ProximityPromptService.PromptTriggered:Connect(function(p143) -- Line: 859
        -- upvalues: u2 (ref), DevProductController (ref)
        if p143:HasTag("GrowPrompt") then
            local Parent = p143.Parent;
            local v144;

            if Parent then
                v144 = Parent:FindFirstAncestorWhichIsA("Model");
            else
                v144 = nil;
            end;

            if not v144 then
                return;
            end;

            local v145 = v144:GetAttribute("PlantId");

            if not v145 then
                return;
            end;

            u2.GrowPlant:Fire(v145);
            DevProductController:PromptPurchase("Standalone:Grow Plant:1");
        end;
    end);
    UserInputService.InputBegan:Connect(function(p146, p147) -- Line: 870
        -- upvalues: u30 (ref), beginKeyboardHoldWatch (ref)
        if p146.KeyCode ~= Enum.KeyCode.E and p146.KeyCode ~= Enum.KeyCode.ButtonX then
            return;
        end;

        for _, v in u30 do
            if next(v.visible) ~= nil then
                task.spawn(beginKeyboardHoldWatch, v);
            end;
        end;
    end);
    UserInputService.InputEnded:Connect(function(p148) -- Line: 880
        -- upvalues: u30 (ref), TweenService (ref), u3 (ref), u99 (ref)
        if p148.KeyCode == Enum.KeyCode.E or p148.KeyCode == Enum.KeyCode.ButtonX then
            for _, v in u30 do
                v.holding = false;
                v.pressing = false;
                local buttonScale = v.buttonScale;

                if buttonScale then
                    TweenService:Create(buttonScale, u3, {
                        Scale = 1
                    }):Play();
                end;

                u99(v);
            end;
        end;
    end);
    UserInputService.InputEnded:Connect(function(p149) -- Line: 886
        -- upvalues: u30 (ref), TweenService (ref), u3 (ref), u99 (ref)
        if p149.UserInputType == Enum.UserInputType.Touch then
            for _, v in u30 do
                v.holding = false;
                v.pressing = false;
                local buttonScale = v.buttonScale;

                if buttonScale then
                    TweenService:Create(buttonScale, u3, {
                        Scale = 1
                    }):Play();
                end;

                u99(v);
            end;
        end;
    end);
    UserInputService.WindowFocusReleased:Connect(stopAllHoldLoops);
    updateActivePromptHighlight();
    u11();
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 897
        -- upvalues: updateActivePromptHighlight (ref), u11 (ref)
        task.defer(function() -- Line: 898
            -- upvalues: updateActivePromptHighlight (ref), u11 (ref)
            updateActivePromptHighlight();
            u11();
        end);
    end);
    RunService.Heartbeat:Connect(function(p150) -- Line: 904
        -- upvalues: updateSmartPromptPositions (ref), u12 (ref), updateActivePromptHighlight (ref)
        debug.profilebegin("Controllers/HarvestPromptController/Heartbeat");
        updateSmartPromptPositions(p150);
        u12 = u12 + 1;

        if u12 >= 3 then
            u12 = 0;
            updateActivePromptHighlight();
        end;

        debug.profileend();
    end);
end;

function v1.Start(p151) -- Line: 916
end;

return v1;