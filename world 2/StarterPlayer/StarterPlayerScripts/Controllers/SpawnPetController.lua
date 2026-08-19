-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 7
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local LocalPlayer = Players.LocalPlayer;
local SharedModules = ReplicatedStorage:WaitForChild("SharedModules");
local Networking = require(SharedModules:WaitForChild("Networking"));
local Worlds = require(SharedModules:WaitForChild("Worlds"));
local RarityVisuals = require(SharedModules:WaitForChild("RarityVisuals"));
local PetModules = require(SharedModules:WaitForChild("PetModules"));
local PetSizes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetSizes"));
local PetTypes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetTypes"));
local ButterflyWingColors = require(SharedModules:WaitForChild("ButterflyWingColors"));
local PetLeaveTimer = ReplicatedStorage.Assets.PetLeaveTimer;
local PetCostTimer = ReplicatedStorage.Assets.PetCostTimer;
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Pets = Assets:FindFirstChild("Pets");

local function currencySymbol() -- Line: 63
    -- upvalues: LocalPlayer (copy), Worlds (copy)
    local v2 = LocalPlayer:GetAttribute("PetHuntOriginWorld");
    local v3 = type(v2) == "string" and Worlds.Worlds[v2];

    if v3 then
        return v3.CurrencySuffix;
    end;

    return Worlds.Current.CurrencySuffix;
end;

local u4 = {
    [2] = UDim2.new(0.2, 0, 0.722, 0),
    [3] = UDim2.new(0.3, 0, 0.722, 0),
    [4] = UDim2.new(0.375, 0, 0.722, 0),
    [5] = UDim2.new(0.5, 0, 0.722, 0),
    [6] = UDim2.new(0.575, 0, 0.722, 0),
    [7] = UDim2.new(0.65, 0, 0.722, 0)
};
local u5 = {};
local u6 = nil;

local function formatWithCommas(p7) -- Line: 132
    local v8 = math.abs(p7);
    local v9 = math.floor(v8);
    local v10 = tostring(v9);
    local v11;

    repeat
        v10, v11 = string.gsub(v10, "^(%d+)(%d%d%d)", "%1,%2");
    until v11 == 0;

    return v10;
end;

local function formatPrice(p12) -- Line: 142
    -- upvalues: LocalPlayer (copy), Worlds (copy), formatWithCommas (copy)
    local v13 = LocalPlayer:GetAttribute("PetHuntOriginWorld");
    local v14 = type(v13) == "string" and Worlds.Worlds[v13];
    local v15;

    if v14 then
        v15 = v14.CurrencySuffix;
    else
        v15 = Worlds.Current.CurrencySuffix;
    end;

    return v15 .. formatWithCommas(p12);
end;

local function digitCount(p16) -- Line: 146
    local v17 = math.abs(p16);
    local v18 = math.floor(v17);

    return #tostring(v18);
end;

local function costSizeForDigits(p19) -- Line: 150
    -- upvalues: u4 (copy)
    if p19 <= 2 then
        return u4[2];
    end;

    if u4[p19] then
        return u4[p19];
    end;

    return UDim2.new((p19 - 7) * 0.075 + 0.65, 0, 0.722, 0);
end;

local u20 = {
    [2] = UDim2.new(0.225, 0, 0.722, 0),
    [3] = UDim2.new(0.3, 0, 0.722, 0),
    [4] = UDim2.new(0.56, 0, 0.722, 0),
    [5] = UDim2.new(0.56, 0, 0.722, 0)
};

local function timerSizeForChars(p21) -- Line: 164
    -- upvalues: u20 (copy)
    if p21 <= 2 then
        return u20[2];
    end;

    if p21 >= 5 then
        return u20[5];
    end;

    return u20[p21];
end;

local function formatRemainingTime(p22) -- Line: 170
    local v23 = math.ceil(p22);
    local v24 = math.max(0, v23);

    if v24 < 60 then
        return string.format("%ds", v24);
    end;

    local v25 = math.floor(v24 / 60);
    local v26 = v24 % 60;

    if v26 == 0 then
        return string.format("%dm", v25);
    end;

    return string.format("%dm %ds", v25, v26);
end;

local function getOrCreateSpawnsFolder() -- Line: 183
    -- upvalues: u6 (ref)
    if u6 and u6.Parent then
        return u6;
    end;

    local Map = workspace:WaitForChild("Map", 30);
    local WildPetSpawns = Map:FindFirstChild("WildPetSpawns");

    if WildPetSpawns and WildPetSpawns:IsA("Folder") then
        u6 = WildPetSpawns;
    else
        u6 = Instance.new("Folder");
        u6.Name = "WildPetSpawns";
        u6.Parent = Map;
    end;

    return u6;
end;

local function getOrCreateTemporaryFolder() -- Line: 197
    local Temporary = workspace:FindFirstChild("Temporary");

    if Temporary and Temporary:IsA("Folder") then
        return Temporary;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "Temporary";
    Folder.Parent = workspace;

    return Folder;
end;

local function playPoofVFX(p27) -- Line: 206
    -- upvalues: Assets (copy), Debris (copy)
    local Poof = Assets:FindFirstChild("Poof");

    if not Poof then
        return;
    end;

    local u28 = Poof:Clone();

    if u28:IsA("BasePart") then
        u28.Anchored = true;
        u28.CanCollide = false;
        u28.CanQuery = false;
        u28.CanTouch = false;
        u28.Massless = true;
        u28.CFrame = p27;
    elseif u28:IsA("Model") then
        for _, descendant in u28:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Massless = true;
            end;
        end;

        u28:PivotTo(p27);
    end;

    local Temporary = workspace:FindFirstChild("Temporary");

    if not (Temporary and Temporary:IsA("Folder")) then
        Temporary = Instance.new("Folder");
        Temporary.Name = "Temporary";
        Temporary.Parent = workspace;
    end;

    u28.Parent = Temporary;
    task.spawn(function() -- Line: 233
        -- upvalues: u28 (copy)
        task.wait();

        if not (u28 and u28.Parent) then
            return;
        end;

        for _, descendant in u28:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                local v29;

                if descendant.Rate > 0 then
                    local v30 = math.floor(descendant.Rate);
                    v29 = math.max(3, v30) or 5;
                else
                    v29 = 5;
                end;

                descendant:Emit(v29);
            end;
        end;
    end);
    Debris:AddItem(u28, 5);
end;

local function emitPopVFX(u31) -- Line: 245
    -- upvalues: Assets (copy), Debris (copy)
    local PopVFXModel = Assets:FindFirstChild("PopVFXModel");

    if not PopVFXModel then
        return;
    end;

    local u32 = PopVFXModel:Clone();

    if u32:IsA("Model") then
        pcall(function() -- Line: 250
            -- upvalues: u32 (copy), u31 (copy)
            u32:PivotTo(CFrame.new(u31));
        end);
    elseif u32:IsA("BasePart") then
        u32.CFrame = CFrame.new(u31);
    end;

    u32.Parent = workspace;
    task.spawn(function() -- Line: 256
        -- upvalues: u32 (copy)
        task.wait();

        if not (u32 and u32.Parent) then
            return;
        end;

        for _, descendant in u32:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant:Emit(descendant:GetAttribute("EmitCount") or 1);
            end;
        end;
    end);
    Debris:AddItem(u32, 5);
end;

local function play3DSound(p33, p34) -- Line: 268
    -- upvalues: SoundService (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.CFrame = CFrame.new(p34);
    Part.Parent = workspace;
    local Sound = Instance.new("Sound");
    Sound.SoundId = p33;
    Sound.Volume = 1;
    Sound.RollOffMaxDistance = 200;
    Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound.Parent = Part;
    task.spawn(function() -- Line: 286
        -- upvalues: Sound (copy), Part (copy)
        if not Sound.IsLoaded then
            Sound.Loaded:Wait();
        end;

        Sound:Play();
        local v35 = math.max(Sound.PlaybackSpeed * Sound.TimeLength, 0.5);
        task.wait(v35 + 0.1);

        if Part and Part.Parent then
            Part:Destroy();
        end;
    end);
end;

local function purgeModelForces(p36) -- Line: 295
    for _, descendant in p36:GetDescendants() do
        if descendant:IsA("BodyMover") or (descendant:IsA("VectorForce") or (descendant:IsA("Torque") or (descendant:IsA("LinearVelocity") or (descendant:IsA("AngularVelocity") or (descendant:IsA("AlignPosition") or descendant:IsA("AlignOrientation")))))) then
            descendant:Destroy();
        elseif descendant:IsA("BasePart") then
            descendant.Massless = true;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.Anchored = false;
            descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end;
end;

local function clonePetTorsoChildrenInto(p37) -- Line: 313
    -- upvalues: Assets (copy)
    local PetTorso = Assets:FindFirstChild("PetTorso");

    if not PetTorso then
        return nil;
    end;

    local v38 = nil;

    for _, child in PetTorso:GetChildren() do
        local v39 = child:Clone();
        v39.Parent = p37;

        if v39.Name == "Tame" and v39:IsA("ParticleEmitter") then
            v39.Enabled = false;
            v38 = v39;
        end;
    end;

    return v38;
end;

local function setLabelChain(u40, u41) -- Line: 328
    if not u40 then
        return;
    end;

    pcall(function() -- Line: 330
        -- upvalues: u40 (copy), u41 (copy)
        u40.Text = u41;
    end);
    local TextLabel = u40:FindFirstChild("TextLabel");

    if TextLabel then
        pcall(function() -- Line: 332
            -- upvalues: TextLabel (copy), u41 (copy)
            TextLabel.Text = u41;
        end);
    end;
end;

local function collectRarityLabels(p42, p43) -- Line: 335
    if not p42 then
        return;
    end;

    table.insert(p43, p42);
    local TextLabel = p42:FindFirstChild("TextLabel");

    if TextLabel then
        table.insert(p43, TextLabel);
    end;
end;

local function configureInfoBillboard(p44, p45, p46) -- Line: 342
    local Info_BB = p44:FindFirstChild("Info_BB");

    if Info_BB then
        Info_BB:Destroy();
    end;

    return function() -- Line: 345
    end;
end;

local function modelHeight(p47) -- Line: 348
    local v48 = (-1 / 0);
    local v49 = (1 / 0);

    for _, descendant in p47:GetDescendants() do
        if descendant:IsA("BasePart") then
            local Y = (descendant.CFrame * CFrame.new(0, descendant.Size.Y * 0.5, 0)).Y;
            local Y2 = (descendant.CFrame * CFrame.new(0, -descendant.Size.Y * 0.5, 0)).Y;

            if v48 >= Y then
                Y = v48;
            end;

            if Y2 < v49 then
                v49 = Y2;
                v48 = Y;
            else
                v48 = Y;
            end;
        end;
    end;

    return v48 == (-1 / 0) and 0 or v48 - v49;
end;

local function attachFloatingBillboards(p50, p51) -- Line: 363
    -- upvalues: modelHeight (copy), PetCostTimer (copy), PetLeaveTimer (copy)
    local v52 = modelHeight(p50);
    local v53 = nil;
    local v54 = nil;
    local v55 = {};
    local v56;

    if PetCostTimer then
        v56 = PetCostTimer:Clone();

        if v56:IsA("BillboardGui") then
            v56.StudsOffset = Vector3.new(0, v52 + 1, 0);
            v56.Adornee = p51;
            v56.Parent = p51;
            local TextLabel = v56:FindFirstChild("TextLabel");

            if TextLabel then
                if TextLabel:IsA("GuiObject") then
                    v54 = TextLabel;
                end;
            end;

            if TextLabel and TextLabel:IsA("TextLabel") then
                table.insert(v55, TextLabel);
            end;

            if TextLabel then
                local TextLabel2 = TextLabel:FindFirstChild("TextLabel");

                if TextLabel2 and TextLabel2:IsA("TextLabel") then
                    table.insert(v55, TextLabel2);
                end;
            end;
        else
            v56:Destroy();
            v56 = v53;
        end;
    else
        v56 = v53;
    end;

    local v57 = nil;
    local v58 = nil;
    local v59 = {};
    local v60;

    if PetLeaveTimer then
        v60 = PetLeaveTimer:Clone();

        if v60:IsA("BillboardGui") then
            v60.StudsOffset = Vector3.new(0, v52 + 1 + 1.5, 0);
            v60.Adornee = p51;
            v60.Parent = p51;
            local TextLabel = v60:FindFirstChild("TextLabel");

            if TextLabel then
                if TextLabel:IsA("GuiObject") then
                    v58 = TextLabel;
                end;
            end;

            if TextLabel and TextLabel:IsA("TextLabel") then
                table.insert(v59, TextLabel);
            end;

            if TextLabel then
                local TextLabel2 = TextLabel:FindFirstChild("TextLabel");

                if TextLabel2 and TextLabel2:IsA("TextLabel") then
                    table.insert(v59, TextLabel2);

                    return v56, v54, v55, v60, v58, v59;
                end;
            end;
        else
            v60:Destroy();
            v60 = v57;
        end;
    else
        v60 = v57;
    end;

    return v56, v54, v55, v60, v58, v59;
end;

local function updateCost(p61) -- Line: 425
    -- upvalues: LocalPlayer (copy), Worlds (copy), formatWithCommas (copy), u4 (copy)
    local RefPart = p61.RefPart;

    if not (RefPart and RefPart.Parent) then
        return;
    end;

    local CostGui = p61.CostGui;

    if not CostGui then
        return;
    end;

    local v62 = RefPart:GetAttribute("OwnerUserId");

    if type(v62) == "number" and v62 == LocalPlayer.UserId then
        if CostGui.Enabled then
            CostGui.Enabled = false;
        end;

        return;
    end;

    if not CostGui.Enabled then
        CostGui.Enabled = true;
    end;

    local v63 = RefPart:GetAttribute("Price");

    if type(v63) ~= "number" then
        return;
    end;

    local v64 = LocalPlayer:GetAttribute("PetHuntOriginWorld");
    local v65 = type(v64) == "string" and Worlds.Worlds[v64];
    local v66;

    if v65 then
        v66 = v65.CurrencySuffix;
    else
        v66 = Worlds.Current.CurrencySuffix;
    end;

    local v67 = v66 .. formatWithCommas(v63);

    if v67 ~= p61.LastCostText then
        p61.LastCostText = v67;

        for _, v in p61.CostLabels do
            if v and v.Parent then
                v.Text = v67;
            end;
        end;
    end;

    local CostSizeTarget = p61.CostSizeTarget;

    if CostSizeTarget then
        local v68 = math.abs(v63);
        local v69 = math.floor(v68);
        local v70 = #tostring(v69);
        local u71;

        if v70 <= 2 then
            u71 = u4[2];
        elseif u4[v70] then
            u71 = u4[v70];
        else
            u71 = UDim2.new((v70 - 7) * 0.075 + 0.65, 0, 0.722, 0);
        end;

        if CostSizeTarget.Size ~= u71 then
            pcall(function() -- Line: 453
                -- upvalues: CostSizeTarget (copy), u71 (copy)
                CostSizeTarget.Size = u71;
            end);
        end;
    end;
end;

local function updateTimer(p72) -- Line: 458
    -- upvalues: formatRemainingTime (copy), u20 (copy)
    local RefPart = p72.RefPart;

    if not (RefPart and RefPart.Parent) then
        return;
    end;

    local TimerGui = p72.TimerGui;

    if not TimerGui then
        return;
    end;

    if RefPart:GetAttribute("NoTimer") == true then
        if TimerGui.Enabled then
            TimerGui.Enabled = false;
        end;

        return;
    end;

    local v73 = RefPart:GetAttribute("OwnerUserId");

    if type(v73) == "number" and v73 ~= 0 then
        if TimerGui.Enabled then
            TimerGui.Enabled = false;
        end;

        return;
    end;

    if not TimerGui.Enabled then
        TimerGui.Enabled = true;
    end;

    local v74 = RefPart:GetAttribute("SpawnedAt");
    local v75 = RefPart:GetAttribute("Lifetime");

    if type(v74) ~= "number" or type(v75) ~= "number" then
        return;
    end;

    local v76 = formatRemainingTime(v74 + v75 - workspace:GetServerTimeNow());

    if v76 == p72.LastTimerText then
        return;
    end;

    p72.LastTimerText = v76;

    for _, v in p72.TimerLabels do
        if v and v.Parent then
            v.Text = v76;
        end;
    end;

    local TimerSizeTarget = p72.TimerSizeTarget;

    if TimerSizeTarget then
        local v77 = #v76;
        local u78;

        if v77 <= 2 then
            u78 = u20[2];
        elseif v77 >= 5 then
            u78 = u20[5];
        else
            u78 = u20[v77];
        end;

        if TimerSizeTarget.Size ~= u78 then
            pcall(function() -- Line: 492
                -- upvalues: TimerSizeTarget (copy), u78 (copy)
                TimerSizeTarget.Size = u78;
            end);
        end;
    end;
end;

local function refreshPromptForLocalPlayer(p79) -- Line: 497
    -- upvalues: LocalPlayer (copy)
    local v80 = p79.RefPart:GetAttribute("OwnerUserId");
    p79.Prompt.Enabled = v80 ~= LocalPlayer.UserId;
end;

local function refreshPromptPrice(p81) -- Line: 502
    -- upvalues: LocalPlayer (copy), Worlds (copy), formatWithCommas (copy)
    local v82 = p81.RefPart:GetAttribute("Price");

    if type(v82) == "number" then
        local Prompt = p81.Prompt;
        local v83 = LocalPlayer:GetAttribute("PetHuntOriginWorld");
        local v84 = type(v83) == "string" and Worlds.Worlds[v83];
        local v85;

        if v84 then
            v85 = v84.CurrencySuffix;
        else
            v85 = Worlds.Current.CurrencySuffix;
        end;

        Prompt.ObjectText = v85 .. formatWithCommas(v82);
    end;
end;

local function groundAlignToRefPart(p86, p87) -- Line: 509
    local v88 = (1 / 0);

    for _, descendant in p86:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local CFrame2 = descendant.CFrame;
            local v89 = descendant.Size.X * 0.5;
            local v90 = descendant.Size.Y * 0.5;
            local v91 = descendant.Size.Z * 0.5;

            for i = -1, 1, 2 do
                for i2 = -1, 1, 2 do
                    local Y = (CFrame2 * CFrame.new(i * v89, i2 * v90, -1 * v91)).Y;

                    if Y >= v88 then
                        Y = v88;
                    end;

                    v88 = (CFrame2 * CFrame.new(i * v89, i2 * v90, 1 * v91)).Y;

                    if v88 >= Y then
                        v88 = Y;
                    end;
                end;
            end;
        end;
    end;

    if v88 == (1 / 0) then
        return;
    end;

    local v92 = p87.Position.Y - p87.Size.Y * 0.5 - v88;

    if math.abs(v92) > 0.001 then
        p86:PivotTo(p86:GetPivot() + Vector3.new(0, v92, 0));
    end;
end;

local function computeFootOffset(p93) -- Line: 535
    local Y = p93:GetPivot().Position.Y;
    local v94 = (1 / 0);

    for _, descendant in p93:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local CFrame2 = descendant.CFrame;
            local v95 = descendant.Size.X * 0.5;
            local v96 = descendant.Size.Y * 0.5;
            local v97 = descendant.Size.Z * 0.5;

            for i = -1, 1, 2 do
                for i2 = -1, 1, 2 do
                    local Y2 = (CFrame2 * CFrame.new(i * v95, i2 * v96, -1 * v97)).Y;

                    if Y2 >= v94 then
                        Y2 = v94;
                    end;

                    v94 = (CFrame2 * CFrame.new(i * v95, i2 * v96, 1 * v97)).Y;

                    if v94 >= Y2 then
                        v94 = Y2;
                    end;
                end;
            end;
        end;
    end;

    return v94 == (1 / 0) and 0 or Y - v94;
end;

local function loadAnimations(u98, p99, p100) -- Line: 558
    local v101 = p100 and p100.Animations or {};
    local v102 = {};
    local v103 = {};

    for _, child in p99:GetChildren() do
        if child:IsA("Animation") then
            v102[child.Name] = child;
        end;
    end;

    local Animations = p99:FindFirstChild("Animations");

    if Animations then
        for _, child in Animations:GetChildren() do
            if child:IsA("Animation") then
                v102[child.Name] = child;
            end;
        end;
    end;

    for _, v in v101 do
        local u104 = v102[v];

        if u104 then
            local success, result = pcall(function() -- Line: 574
                -- upvalues: u98 (copy), u104 (copy)
                return u98:LoadAnimation(u104);
            end);

            if success and result then
                result.Looped = true;
                v103[v] = result;
            end;
        end;
    end;

    return v103;
end;

local u105 = { "Idle", "GroundIdle", "Fly" };
local u106 = { "Walk", "Fly", "GroundIdle" };

local function switchAnimation(p107, p108) -- Line: 593
    -- upvalues: PetModules (copy), u105 (copy), u106 (copy)
    if p107.CurrentState == p108 then
        return;
    end;

    p107.CurrentState = p108;

    for _, v in p107.Tracks do
        if v.IsPlaying then
            v:Stop(0.2);
        end;
    end;

    local v109 = PetModules[p107.PetName];
    local v110 = v109 and v109.Animations or {};
    local v111 = nil;

    if p108 == "idle" then
        v111 = u105;
    elseif p108 == "walking" then
        v111 = u106;
    end;

    if v111 then
        for _, v in v111 do
            local v112 = v110[v];

            if v112 and p107.Tracks[v112] then
                p107.Tracks[v112]:Play(0.2);
                break;
            end;
        end;
    end;

    if p108 == "walking" then
        p107.NeedYawSnap = true;
    end;
end;

local function isWalkingState(p113) -- Line: 622
    return p113 == "walking_to_garden" and true or p113 == "wandering_walking";
end;

local function setupVisual(u114) -- Line: 626
    -- upvalues: PetModules (copy), Pets (copy), ButterflyWingColors (copy), purgeModelForces (copy), PetSizes (copy), groundAlignToRefPart (copy), computeFootOffset (copy), clonePetTorsoChildrenInto (copy), attachFloatingBillboards (copy), LocalPlayer (copy), Worlds (copy), formatWithCommas (copy), getOrCreateSpawnsFolder (copy), PetTypes (copy), loadAnimations (copy), updateCost (copy), updateTimer (copy), switchAnimation (copy), Networking (copy), u5 (copy)
    local v115 = u114:GetAttribute("PetName");

    if type(v115) ~= "string" or v115 == "" then
        return nil;
    end;

    local v116 = PetModules[v115];

    if not v116 then
        return nil;
    end;

    local v117 = Pets:FindFirstChild(v116.AssetName);

    if not (v117 and v117:IsA("Model")) then
        return nil;
    end;

    local v118 = u114:GetAttribute("Rarity");
    local v119 = (type(v118) ~= "string" or v118 == "") and "Common" or v118;
    local v120 = v117:Clone();
    v120.Name = "WildPet_" .. v115 .. "_" .. u114.Name;
    v120:SetAttribute("PetName", v115);
    v120:SetAttribute("PetSize", u114:GetAttribute("PetSize"));
    v120:SetAttribute("PetType", u114:GetAttribute("PetType"));
    ButterflyWingColors.ApplyToModel(v120, u114.Name);
    local PrimaryPart = v120.PrimaryPart;

    if not PrimaryPart then
        PrimaryPart = v120:FindFirstChild("RootPart") or v120:FindFirstChildWhichIsA("BasePart");

        if PrimaryPart then
            v120.PrimaryPart = PrimaryPart;
        end;
    end;

    if not PrimaryPart then
        v120:Destroy();

        return nil;
    end;

    purgeModelForces(v120);
    PrimaryPart.Anchored = true;
    local Pivot = v116.Pivot;
    local identity = CFrame.identity;

    if typeof(Pivot) == "Vector3" then
        identity = CFrame.Angles(math.rad(Pivot.X), math.rad(Pivot.Y), (math.rad(Pivot.Z)));
    end;

    v120:PivotTo(u114.CFrame * identity);
    local v121 = PetSizes.GetScale(u114:GetAttribute("PetSize"), {
        Big = v116.BigScale,
        Huge = v116.HugeScale
    });

    if v121 ~= 1 then
        v120:ScaleTo(v121);
    end;

    groundAlignToRefPart(v120, u114);
    local v122 = computeFootOffset(v120);
    local v123 = clonePetTorsoChildrenInto(PrimaryPart);
    local Info_BB = PrimaryPart:FindFirstChild("Info_BB");

    if Info_BB then
        Info_BB:Destroy();
    end;

    local function v124() -- Line: 345
    end;

    local v125, v126, v127, v128, v129, v130 = attachFloatingBillboards(v120, PrimaryPart);
    local v131 = PrimaryPart:FindFirstChildOfClass("AnimationController") or v120:FindFirstChildOfClass("AnimationController");

    if not v131 then
        v131 = Instance.new("AnimationController");
        v131.Parent = v120;
    end;

    local v132 = v131:FindFirstChildOfClass("Animator");

    if not v132 then
        v132 = Instance.new("Animator");
        v132.Parent = v131;
    end;

    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "BuyPrompt";
    ProximityPrompt.ActionText = "Buy";
    local v133 = u114:GetAttribute("Price") or 0;
    local v134 = LocalPlayer:GetAttribute("PetHuntOriginWorld");
    local v135 = type(v134) == "string" and Worlds.Worlds[v134];
    local v136;

    if v135 then
        v136 = v135.CurrencySuffix;
    else
        v136 = Worlds.Current.CurrencySuffix;
    end;

    ProximityPrompt.ObjectText = v136 .. formatWithCommas(v133);
    ProximityPrompt.HoldDuration = 1;
    ProximityPrompt.MaxActivationDistance = 12;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.Parent = PrimaryPart;
    v120.Parent = getOrCreateSpawnsFolder();

    if u114:GetAttribute("PetType") == PetTypes.Rainbow then
        v120:AddTag("PetRainbow");
    end;

    local v137 = loadAnimations(v132, v120, v116);
    local v138 = v116.IsFlying == true;
    local v139;

    if v138 then
        v139 = v116.AlwaysFlying == true;
    else
        v139 = v138;
    end;

    local v140 = v138 and ((v116.AirHeight or 5) * 0.6 or 0) or 0;
    local u141 = {
        RefPart = u114,
        PetName = v115,
        Rarity = v119,
        Model = v120,
        Primary = PrimaryPart,
        Animator = v132,
        Tracks = v137,
        CurrentState = "",
        CurrentCF = PrimaryPart.CFrame,
        LastYaw = 0,
        NeedYawSnap = true,
        FootOffset = v122,
        LastGroundY = nil,
        Prompt = ProximityPrompt,
        TameParticle = v123,
        Connections = {},
        RarityCleanup = v124,
        CostGui = v125,
        CostSizeTarget = v126,
        CostLabels = v127,
        LastCostText = "",
        TimerGui = v128,
        TimerSizeTarget = v129,
        TimerLabels = v130,
        LastTimerText = "",
        IsFlying = v138,
        AlwaysFlying = v139,
        AirHeight = v140,
        LandDuration = v138 and (v116.LandDuration or 0.8) or 0.8,
        TakeoffDuration = v138 and v116.TakeoffDuration or 0.8,
        FlightPhase = v139 and "Flying" or "Grounded",
        FlightHeight = v139 and v140 and v140 or 0,
        FlightPhaseStartedAt = os.clock(),
        LandingStartHeight = nil
    };
    updateCost(u141);
    updateTimer(u141);
    local v142 = u114:GetAttribute("State");
    switchAnimation(u141, (v142 == "walking_to_garden" and true or v142 == "wandering_walking") and "walking" or "idle");
    local v143 = u141.RefPart:GetAttribute("OwnerUserId");
    u141.Prompt.Enabled = v143 ~= LocalPlayer.UserId;
    local v144 = u141.RefPart:GetAttribute("Price");

    if type(v144) == "number" then
        local Prompt = u141.Prompt;
        local v145 = LocalPlayer:GetAttribute("PetHuntOriginWorld");
        local v146 = type(v145) == "string" and Worlds.Worlds[v145];
        local v147;

        if v146 then
            v147 = v146.CurrencySuffix;
        else
            v147 = Worlds.Current.CurrencySuffix;
        end;

        Prompt.ObjectText = v147 .. formatWithCommas(v144);
    end;

    local Connections = u141.Connections;
    local v148 = u114:GetAttributeChangedSignal("OwnerUserId");
    table.insert(Connections, v148:Connect(function() -- Line: 767
        -- upvalues: u141 (copy), LocalPlayer (ref), updateTimer (ref), updateCost (ref)
        local v149 = u141;
        local v150 = v149.RefPart:GetAttribute("OwnerUserId");
        v149.Prompt.Enabled = v150 ~= LocalPlayer.UserId;
        updateTimer(u141);
        updateCost(u141);
    end));
    local Connections2 = u141.Connections;
    local v151 = u114:GetAttributeChangedSignal("Price");
    table.insert(Connections2, v151:Connect(function() -- Line: 773
        -- upvalues: updateCost (ref), u141 (copy), LocalPlayer (ref), Worlds (ref), formatWithCommas (ref)
        updateCost(u141);
        local v152 = u141;
        local v153 = v152.RefPart:GetAttribute("Price");

        if type(v153) == "number" then
            local Prompt = v152.Prompt;
            local v154 = LocalPlayer:GetAttribute("PetHuntOriginWorld");
            local v155 = type(v154) == "string" and Worlds.Worlds[v154];
            local v156;

            if v155 then
                v156 = v155.CurrencySuffix;
            else
                v156 = Worlds.Current.CurrencySuffix;
            end;

            Prompt.ObjectText = v156 .. formatWithCommas(v153);
        end;
    end));
    local Connections3 = u141.Connections;
    local v157 = u114:GetAttributeChangedSignal("State");
    table.insert(Connections3, v157:Connect(function() -- Line: 777
        -- upvalues: u114 (copy), switchAnimation (ref), u141 (copy)
        local v158 = u114:GetAttribute("State");
        switchAnimation(u141, (v158 == "walking_to_garden" and true or v158 == "wandering_walking") and "walking" or "idle");
    end));
    table.insert(u141.Connections, ProximityPrompt.Triggered:Connect(function(p159) -- Line: 781
        -- upvalues: LocalPlayer (ref), Networking (ref), u114 (copy)
        if p159 ~= LocalPlayer then
            return;
        end;

        Networking.Pets.WildPetTame:Fire(u114);
    end));
    u5[u114] = u141;

    return u141;
end;

local function teardownVisual(p160) -- Line: 790
    -- upvalues: u5 (copy), playPoofVFX (copy)
    local u161 = u5[p160];

    if not u161 then
        return;
    end;

    u5[p160] = nil;

    if u161.Model and u161.Model.Parent then
        local success, result = pcall(function() -- Line: 796
            -- upvalues: u161 (copy)
            return u161.Model:GetBoundingBox();
        end);

        if success and result then
            playPoofVFX(result);
        end;
    end;

    for _, v in u161.Connections do
        pcall(function() -- Line: 805
            -- upvalues: v (copy)
            v:Disconnect();
        end);
    end;

    pcall(u161.RarityCleanup);

    for _, v in u161.Tracks do
        pcall(function() -- Line: 809
            -- upvalues: v (copy)
            v:Stop(0);
        end);
    end;

    if u161.Model and u161.Model.Parent then
        u161.Model:Destroy();
    end;
end;

local u162 = RaycastParams.new();
u162.FilterType = Enum.RaycastFilterType.Exclude;
u162.IgnoreWater = false;
u162.RespectCanCollide = false;
local u163 = RaycastParams.new();
u163.FilterType = Enum.RaycastFilterType.Exclude;
u163.IgnoreWater = false;
u163.RespectCanCollide = false;

local function refreshGroundRayFilter() -- Line: 824
    -- upvalues: u6 (ref), Players (copy), u162 (copy)
    local v164 = {};

    if u6 and u6.Parent then
        table.insert(v164, u6);
    end;

    local Map = workspace:FindFirstChild("Map");
    local v165;

    if Map then
        v165 = Map:FindFirstChild("WildPetRef");
    else
        v165 = Map;
    end;

    if v165 then
        table.insert(v164, v165);
    end;

    if Map then
        Map = Map:FindFirstChild("PetSpawn");
    end;

    if Map then
        table.insert(v164, Map);
    end;

    for _, v in Players:GetPlayers() do
        if v.Character then
            table.insert(v164, v.Character);
        end;
    end;

    u162.FilterDescendantsInstances = v164;
end;

local function castGroundY(p166, p167) -- Line: 840
    -- upvalues: u162 (copy), u163 (copy)
    local v168 = Vector3.new(p166.X, p167 + 10, p166.Z);
    local v169 = workspace:Raycast(v168, Vector3.new(0, -35, 0), u162);

    if not (v169 and v169.Instance) then
        return nil;
    end;

    local Instance2 = v169.Instance;

    if Instance2.Transparency < 0.99 and Instance2.CanCollide then
        return v169.Position.Y;
    end;

    local v170 = table.clone(u162.FilterDescendantsInstances);
    table.insert(v170, Instance2);
    u163.FilterDescendantsInstances = v170;

    for _ = 1, 8 do
        local v171 = workspace:Raycast(v168, Vector3.new(0, -35, 0), u163);

        if not (v171 and v171.Instance) then
            return nil;
        end;

        local Instance3 = v171.Instance;

        if Instance3.Transparency < 0.99 and Instance3.CanCollide then
            return v171.Position.Y;
        end;

        table.insert(v170, Instance3);
        u163.FilterDescendantsInstances = v170;
    end;

    return nil;
end;

local function stepWildFlight(p172, p173) -- Line: 873
    local v174 = p172.AlwaysFlying or p172.CurrentState == "walking";
    local FlightPhase = p172.FlightPhase;

    if FlightPhase == "Grounded" then
        p172.FlightHeight = 0;

        if v174 then
            p172.FlightPhaseStartedAt = p173;
            FlightPhase = "Takeoff";
        end;
    elseif FlightPhase == "Takeoff" then
        local v175 = math.clamp((p173 - p172.FlightPhaseStartedAt) / p172.TakeoffDuration, 0, 1);
        p172.FlightHeight = p172.AirHeight * v175;

        if v174 then
            if v175 >= 1 then
                p172.FlightHeight = p172.AirHeight;
                FlightPhase = "Flying";
            end;
        else
            p172.FlightPhaseStartedAt = p173;
            p172.LandingStartHeight = p172.FlightHeight;
            FlightPhase = "Landing";
        end;
    elseif FlightPhase == "Flying" then
        p172.FlightHeight = p172.AirHeight;

        if not v174 then
            p172.FlightPhaseStartedAt = p173;
            p172.LandingStartHeight = p172.AirHeight;
            FlightPhase = "Landing";
        end;
    elseif FlightPhase == "Landing" then
        local v176 = math.clamp((p173 - p172.FlightPhaseStartedAt) / p172.LandDuration, 0, 1);
        p172.FlightHeight = (p172.LandingStartHeight or p172.AirHeight) * (1 - v176);

        if v174 then
            p172.FlightPhaseStartedAt = p173;
            FlightPhase = "Takeoff";
        elseif v176 >= 1 then
            p172.FlightHeight = 0;
            FlightPhase = "Grounded";
        end;
    end;

    p172.FlightPhase = FlightPhase;

    return p172.FlightHeight;
end;

local u177 = 0;

local function updateVisuals(p178) -- Line: 921
    -- upvalues: u177 (ref), u5 (copy), updateTimer (copy), castGroundY (copy), stepWildFlight (copy), PetModules (copy)
    local v179 = math.min(1, p178 * 25);
    u177 = u177 + p178;
    local v180 = u177 >= 0.25;

    if v180 then
        u177 = 0;
    end;

    for i, v in u5 do
        if i.Parent then
            if v180 then
                updateTimer(v);
            end;

            local Model = v.Model;

            if Model and Model.PrimaryPart then
                local Position = i.Position;
                local v181 = castGroundY(Position, Position.Y) or (v.LastGroundY or Position.Y);
                local v182 = v.LastGroundY or v181;
                local v183 = math.clamp(p178 * 18, 0, 1);
                local v184 = v182 + (v181 - v182) * v183;
                v.LastGroundY = v184;
                local v185 = Vector3.new(Position.X, v184 + v.FootOffset, Position.Z);

                if v.IsFlying then
                    local v186 = stepWildFlight(v, os.clock());
                    v185 = v185 + Vector3.new(0, v186, 0);
                end;

                local Position2 = v.CurrentCF.Position;
                local v187 = Position2:Lerp(v185, v179);
                local v188 = v185.X - Position2.X;
                local v189 = v185.Z - Position2.Z;
                local v190;

                if v188 * v188 + v189 * v189 > 0.01 then
                    v190 = v.CurrentState == "walking";
                else
                    v190 = false;
                end;

                local LastYaw = v.LastYaw;

                if v190 then
                    LastYaw = math.atan2(-v188, -v189);
                end;

                if v.NeedYawSnap and v190 then
                    v.LastYaw = LastYaw;
                    v.NeedYawSnap = false;
                else
                    local v191 = (LastYaw - v.LastYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;
                    local v192 = math.clamp(p178 * 12, 0, 1);
                    v.LastYaw = v.LastYaw + v191 * v192;
                end;

                local v193 = PetModules[v.PetName];

                if v193 then
                    v193 = v193.Pivot;
                end;

                local identity = CFrame.identity;

                if typeof(v193) == "Vector3" then
                    identity = CFrame.Angles(math.rad(v193.X), math.rad(v193.Y), (math.rad(v193.Z)));
                end;

                local v194 = CFrame.new(v187) * CFrame.Angles(0, v.LastYaw, 0) * identity;
                v.CurrentCF = v194;
                Model.PrimaryPart.CFrame = v194;
            end;
        end;
    end;
end;

local function getLocalHandPosition() -- Line: 978
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local v195 = Character:FindFirstChild("RightHand") or (Character:FindFirstChild("Right Arm") or Character:FindFirstChild("HumanoidRootPart"));

    if v195 and v195:IsA("BasePart") then
        return v195.Position;
    end;

    return nil;
end;

local function onPetBought(p196, p197) -- Line: 988
    -- upvalues: emitPopVFX (copy), play3DSound (copy), u5 (copy), LocalPlayer (copy), getLocalHandPosition (copy)
    if typeof(p196) ~= "Instance" or not p196:IsA("BasePart") then
        return;
    end;

    emitPopVFX(p196.Position);
    play3DSound("rbxassetid://82832537745906", p196.Position);
    local v198 = u5[p196];

    if v198 and (v198.TameParticle and v198.TameParticle.Parent) then
        v198.TameParticle:Emit(math.random(3, 4));
    end;

    local v199 = p197 == LocalPlayer.UserId and getLocalHandPosition();

    if v199 then
        emitPopVFX(v199);
    end;
end;

local function playCollectedSoundOn(p200) -- Line: 1005
    -- upvalues: SoundService (copy)
    if not (p200 and p200.Parent) then
        return;
    end;

    local HumanoidRootPart = (p200.Character or p200.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://88022650354104";
    Sound.Volume = 1;
    Sound.RollOffMaxDistance = 700;
    Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound.Parent = HumanoidRootPart;
    task.spawn(function() -- Line: 1018
        -- upvalues: Sound (copy)
        if not Sound.IsLoaded then
            Sound.Loaded:Wait();
        end;

        Sound:Play();
        local v201 = math.max(Sound.PlaybackSpeed > 0 and Sound.TimeLength / Sound.PlaybackSpeed or 0.5, 0.5);
        task.wait(v201 + 0.1);

        if Sound and Sound.Parent then
            Sound:Destroy();
        end;
    end);
end;

local function onWildPetCollected(p202, p203) -- Line: 1027
    -- upvalues: playCollectedSoundOn (copy), LocalPlayer (copy), getLocalHandPosition (copy), emitPopVFX (copy)
    playCollectedSoundOn(p202);

    if p202 ~= LocalPlayer then
        return;
    end;

    local v204 = getLocalHandPosition();

    if v204 then
        emitPopVFX(v204);
    end;
end;

local function applyOwlAlertHighlight(p205) -- Line: 1037
    -- upvalues: PetTypes (copy), RunService (copy), RarityVisuals (copy), Debris (copy)
    local Model = p205.Model;

    if not (Model and Model.Parent) then
        return;
    end;

    local OwlAlertHighlight = Model:FindFirstChild("OwlAlertHighlight");

    if OwlAlertHighlight then
        OwlAlertHighlight:Destroy();
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "OwlAlertHighlight";
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 0;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.Adornee = Model;
    Highlight.Parent = Model;

    if p205.RefPart:GetAttribute("PetType") ~= PetTypes.Rainbow then
        Highlight.OutlineColor = RarityVisuals.GetStaticColor(p205.Rarity);
        Debris:AddItem(Highlight, 15);

        return;
    end;

    local u206 = nil;
    u206 = RunService.Heartbeat:Connect(function() -- Line: 1054
        -- upvalues: Highlight (copy), u206 (ref)
        if Highlight.Parent then
            Highlight.OutlineColor = Color3.fromHSV(tick() * 0.5 % 1, 1, 1);

            return;
        end;

        u206:Disconnect();
    end);
    task.delay(15, function() -- Line: 1061
        -- upvalues: u206 (ref), Highlight (copy)
        u206:Disconnect();

        if Highlight and Highlight.Parent then
            Highlight:Destroy();
        end;
    end);
end;

local function highlightOwlAlertTarget(p207) -- Line: 1074
    -- upvalues: u5 (copy), applyOwlAlertHighlight (copy)
    local v208 = os.clock() + 5;

    while os.clock() < v208 do
        for i, v in u5 do
            if i.Name == p207 then
                applyOwlAlertHighlight(v);

                return;
            end;
        end;

        task.wait(0.05);
    end;
end;

function v1.Init(p209) -- Line: 1087
end;

function v1.Start(p210) -- Line: 1089
    -- upvalues: getOrCreateSpawnsFolder (copy), refreshGroundRayFilter (copy), Players (copy), setupVisual (copy), teardownVisual (copy), RunService (copy), updateVisuals (copy), Networking (copy), onPetBought (copy), onWildPetCollected (copy), highlightOwlAlertTarget (copy)
    getOrCreateSpawnsFolder();
    refreshGroundRayFilter();
    Players.PlayerAdded:Connect(refreshGroundRayFilter);
    Players.PlayerRemoving:Connect(function(p211) -- Line: 1093
        -- upvalues: refreshGroundRayFilter (ref)
        task.defer(refreshGroundRayFilter);
    end);

    for _, v in Players:GetPlayers() do
        v.CharacterAdded:Connect(function(p212) -- Line: 1095
            -- upvalues: refreshGroundRayFilter (ref)
            refreshGroundRayFilter();
        end);
    end;

    Players.PlayerAdded:Connect(function(p213) -- Line: 1097
        -- upvalues: refreshGroundRayFilter (ref)
        p213.CharacterAdded:Connect(function(p214) -- Line: 1098
            -- upvalues: refreshGroundRayFilter (ref)
            refreshGroundRayFilter();
        end);
    end);
    task.spawn(function() -- Line: 1101
        -- upvalues: setupVisual (ref), teardownVisual (ref)
        local Map = workspace:WaitForChild("Map", 30);

        if not Map then
            return;
        end;

        local function bindFolder(p215) -- Line: 1104
            -- upvalues: setupVisual (ref), teardownVisual (ref)
            for _, child in p215:GetChildren() do
                if child:IsA("BasePart") then
                    setupVisual(child);
                end;
            end;

            p215.ChildAdded:Connect(function(p216) -- Line: 1108
                -- upvalues: setupVisual (ref)
                if p216:IsA("BasePart") then
                    setupVisual(p216);
                end;
            end);
            p215.ChildRemoved:Connect(function(p217) -- Line: 1111
                -- upvalues: teardownVisual (ref)
                if p217:IsA("BasePart") then
                    teardownVisual(p217);
                end;
            end);
        end;

        local WildPetRef = Map:FindFirstChild("WildPetRef");

        if WildPetRef and WildPetRef:IsA("Folder") then
            bindFolder(WildPetRef);

            return;
        end;

        Map.ChildAdded:Connect(function(p218) -- Line: 1119
            -- upvalues: bindFolder (copy)
            if p218.Name == "WildPetRef" and p218:IsA("Folder") then
                bindFolder(p218);
            end;
        end);
    end);
    RunService.Heartbeat:Connect(function(p219) -- Line: 1127
        -- upvalues: updateVisuals (ref)
        updateVisuals(p219);
    end);
    Networking.Pets.WildPetTameResult.OnClientEvent:Connect(function(p220, p221) -- Line: 1131
        -- upvalues: onPetBought (ref)
        pcall(onPetBought, p220, p221);
    end);
    Networking.Pets.WildPetCollected.OnClientEvent:Connect(function(p222, p223) -- Line: 1135
        -- upvalues: onWildPetCollected (ref)
        pcall(onWildPetCollected, p222, p223);
    end);
    Networking.SFX.OwlHoot.OnClientEvent:Connect(function(p224, p225) -- Line: 1139
        -- upvalues: highlightOwlAlertTarget (ref)
        if type(p225) ~= "string" or p225 == "" then
            return;
        end;

        task.spawn(highlightOwlAlertTarget, p225);
    end);
end;

return v1;