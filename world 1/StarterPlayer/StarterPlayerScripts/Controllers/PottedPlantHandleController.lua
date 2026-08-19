-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 7
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local FruitIdentity = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("FruitIdentity"));
local PotScale = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("PotScale"));
local Plants = ReplicatedStorage.PlantGenerationModules.Plants;
local Fruits = ReplicatedStorage.PlantGenerationModules.Fruits;
local Plants2 = ReplicatedStorage.Assets.Plants;
local Fruits2 = ReplicatedStorage.Assets.Fruits;
local POT = ReplicatedStorage.Assets.POT;
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = CFrame.new(0, -0.5, 0.25) * CFrame.Angles(1.5707963267948966, 0, 0);

local function SetModelAnchored(p7) -- Line: 31
    for _, v in p7:QueryDescendants("BasePart") do
        v.Anchored = true;
        v.CanCollide = false;
        v.CastShadow = false;
        v.CanQuery = false;
        v.CanTouch = false;
    end;
end;

local function PreparePartForTool(p8) -- Line: 42
    p8.Anchored = false;
    p8.CanCollide = false;
    p8.CanQuery = false;
    p8.CanTouch = false;
    p8.Massless = true;
end;

local function WeldTo(p9, p10) -- Line: 51
    for _, v in p10:QueryDescendants("BasePart") do
        if v ~= p9 then
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = p9;
            WeldConstraint.Part1 = v;
            WeldConstraint.Parent = v;
        end;
    end;
end;

function v1.Init(p11) -- Line: 62
    -- upvalues: Plants (copy), u2 (copy), Fruits (copy)
    for _, child in Plants:GetChildren() do
        if child:IsA("ModuleScript") then
            u2[`Plant_{child.Name}`] = require(child);
        end;
    end;

    for _, child in Fruits:GetChildren() do
        if child:IsA("ModuleScript") then
            u2[`Fruit_{child.Name}`] = require(child);
        end;
    end;
end;

function v1.IsTrackedTool(p12, p13) -- Line: 79
    return p13:GetAttribute("PottedPlant") == true;
end;

function v1.HasHandle(p14, p15) -- Line: 84
    -- upvalues: u4 (copy)
    local v16 = u4[p15];
    local v17;

    if v16 == nil or v16.Pot == nil then
        v17 = false;
    else
        v17 = v16.Pot.Parent ~= nil;
    end;

    return v17;
end;

function v1.ClearHandle(p18, p19) -- Line: 92
    -- upvalues: u4 (copy)
    local v20 = u4[p19];

    if v20 then
        v20.Cancelled = true;

        if v20.Pot and v20.Pot.Parent then
            v20.Pot:Destroy();
        end;

        if v20.PlantModel and v20.PlantModel.Parent then
            v20.PlantModel:Destroy();
        end;

        u4[p19] = nil;
    end;
end;

function v1.SpawnHandle(u21, u22, u23) -- Line: 106
    -- upvalues: u5 (copy), Plants2 (copy), u2 (copy), Fruits2 (copy), POT (copy), PotScale (copy), Players (copy), u4 (copy), ReplicatedStorage (copy), FruitIdentity (copy), WeldTo (copy), LocalPlayer (copy), u6 (copy), HeldHandleSelfHeal (copy)
    if u5[u22] then
        return;
    end;

    u5[u22] = true;
    u21:ClearHandle(u22);
    local v24 = u22:GetAttribute("PlantName");
    local v25 = u22:GetAttribute("Seed");
    local v26 = u22:GetAttribute("Age") or 0;
    local v27 = u22:GetAttribute("MaxAge") or 100;
    local v28 = u22:GetAttribute("SizeMultiplier") or 1;
    local v29 = u22:GetAttribute("Mutation");

    if not (v24 and v25) then
        u5[u22] = nil;

        return;
    end;

    local v30 = Plants2:FindFirstChild(v24);
    local v31 = u2[`Plant_{v24}`];
    local v32;

    if v30 then
        v32 = false;
    else
        v30 = Fruits2:FindFirstChild(v24);
        v31 = u2[`Fruit_{v24}`];
        v32 = true;
    end;

    if not (v30 and v31) then
        u5[u22] = nil;

        return;
    end;

    local v33 = u23:FindFirstChild("Right Arm") or u23:FindFirstChild("RightHand");

    if not v33 then
        u5[u22] = nil;

        return;
    end;

    local v34 = POT:Clone();
    v34.Name = "PottedPlantVisual";
    local v35 = PotScale.Get(v24);

    if v35 ~= 1 then
        v34:ScaleTo(v35);
    end;

    for _, v in v34:QueryDescendants("BasePart") do
        v.Anchored = true;
        v.CanCollide = false;
        v.CastShadow = false;
        v.CanQuery = false;
        v.CanTouch = false;
    end;

    local PlantRoot = v34:FindFirstChild("PlantRoot", true);

    if not PlantRoot then
        v34:Destroy();
        u5[u22] = nil;

        return;
    end;

    v34:SetAttribute("Owner", Players:GetPlayerFromCharacter(u23) and (Players:GetPlayerFromCharacter(u23).UserId or 0) or 0);
    v34.Parent = game.Workspace.PottedPlantVisuals;
    local u36 = {
        Anchor = nil,
        PlantModel = nil,
        Cancelled = false,
        Pot = v34,
        Character = u23
    };
    u4[u22] = u36;

    local function IsCancelledOrCleanup() -- Line: 189
        -- upvalues: u36 (copy), u22 (copy), u23 (copy), u4 (ref), u5 (ref)
        if not u36.Cancelled and (u22.Parent == u23 and u23.Parent) then
            return false;
        end;

        u36.Cancelled = true;

        if u36.Pot and u36.Pot.Parent then
            u36.Pot:Destroy();
        end;

        if u36.PlantModel and u36.PlantModel.Parent then
            u36.PlantModel:Destroy();
        end;

        if u4[u22] == u36 then
            u4[u22] = nil;
        end;

        u5[u22] = nil;

        return true;
    end;

    local v37 = v30:Clone();
    u36.PlantModel = v37;
    v37:SetAttribute("Age", v26);
    v37:SetAttribute("MaxAge", v27);

    if v29 and v29 ~= "" then
        v37:SetAttribute("Mutation", v29);
    end;

    for _, v in v37:QueryDescendants("BasePart") do
        v.Anchored = true;
        v.CanCollide = false;
        v.CastShadow = false;
        v.CanQuery = false;
        v.CanTouch = false;
    end;

    v37:PivotTo(PlantRoot.WorldCFrame);
    (v32 and v31.InitFruit or v31.InitPlant)(v37, v25, v28, u22:GetAttribute("PlantedAt") or os.time());

    if IsCancelledOrCleanup() then
        return;
    end;

    v37.Parent = workspace;
    local v38 = 0;

    repeat
        v38 = v38 + task.wait();

        if IsCancelledOrCleanup() then
            return;
        end;
    until v37:HasTag("InitializationComplete") or v38 > 5;

    (v32 and v31.BeginFruitGrowth or v31.BeginPlantGrowth)(v37);
    task.wait();

    if IsCancelledOrCleanup() then
        return;
    end;

    local Fruits3 = ReplicatedStorage.Assets.Fruits;
    local FruitSpawnLocations = v37:FindFirstChild("FruitSpawnLocations");

    if FruitSpawnLocations then
        local v39 = FruitSpawnLocations:GetChildren();

        if #v39 > 0 then
            local v40 = FruitIdentity.ResolveFruitName(v24);
            local v41 = FruitIdentity.GetVisualScale(v24);
            local v42 = Fruits3:FindFirstChild(v40);
            local v43 = u2[`Fruit_{v40}`];

            if v42 and v43 then
                local v44 = nil;
                local u45 = u22:GetAttribute("SavedFruitsJSON");
                local v46;

                if u45 and u45 ~= "" then
                    local v47;
                    v47, v46 = pcall(function() -- Line: 294
                        -- upvalues: u45 (copy)
                        return game:GetService("HttpService"):JSONDecode(u45);
                    end);

                    if v47 and v46 then
                        if #v46 <= 0 then
                            v46 = v44;
                        end;
                    else
                        v46 = v44;
                    end;
                else
                    v46 = v44;
                end;

                if v46 then
                    for _, v in v46 do
                        local v48 = FruitSpawnLocations:FindFirstChild((tostring(v.SpawnLocationIndex))) or v39[v.SpawnLocationIndex];

                        if v48 then
                            local v49 = v42:Clone();
                            v49:SetAttribute("Age", v27);
                            v49:SetAttribute("MaxAge", v27);

                            if v.Mutation and v.Mutation ~= "" then
                                v49:SetAttribute("Mutation", v.Mutation);
                            end;

                            v49.Parent = v37;
                            v49:SetAttribute("PlantSeed", v25);
                            v43.InitFruit(v49, v.Seed, (v.SizeMultiplier or 1) * v41);
                            local v50 = 0;

                            repeat
                                v50 = v50 + task.wait();

                                if IsCancelledOrCleanup() then
                                    return;
                                end;
                            until v49:HasTag("InitializationComplete") or v50 > 5;

                            v43.BeginFruitGrowth(v49);
                            task.wait();

                            if IsCancelledOrCleanup() then
                                return;
                            end;

                            if v.OvertimeGrowth and v.OvertimeGrowth > 1 then
                                v49:ScaleTo(v.OvertimeGrowth);
                            end;

                            v49:PivotTo(v48.CFrame);
                        end;
                    end;
                else
                    for _, v in v39 do
                        local v51 = v42:Clone();
                        v51:SetAttribute("Age", v27);
                        v51:SetAttribute("MaxAge", v27);
                        v51.Parent = v37;
                        v51:SetAttribute("PlantSeed", v25);
                        v43.InitFruit(v51, math.random(1, 999999), v28 * v41);
                        local v52 = 0;

                        repeat
                            v52 = v52 + task.wait();

                            if IsCancelledOrCleanup() then
                                return;
                            end;
                        until v51:HasTag("InitializationComplete") or v52 > 5;

                        v43.BeginFruitGrowth(v51);
                        task.wait();

                        if IsCancelledOrCleanup() then
                            return;
                        end;

                        v51:PivotTo(v.CFrame);
                    end;
                end;
            end;
        end;
    end;

    if IsCancelledOrCleanup() then
        return;
    end;

    v37.Parent = v34;
    local PrimaryPart = v34.PrimaryPart;

    if not PrimaryPart then
        v34:Destroy();
        v37:Destroy();

        if u4[u22] == u36 then
            u4[u22] = nil;
        end;

        u5[u22] = nil;

        return;
    end;

    for _, v in v34:QueryDescendants("BasePart") do
        v.Anchored = false;
        v.CanCollide = false;
        v.CanQuery = false;
        v.CanTouch = false;
        v.Massless = true;
    end;

    WeldTo(PrimaryPart, v34);
    WeldTo(PrimaryPart, v37);
    local Part = Instance.new("Part");
    Part.Name = "Handle";
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.Parent = u22;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = Part;
    WeldConstraint.Part1 = v33;
    WeldConstraint.Parent = Part;
    PrimaryPart.CFrame = v33.CFrame * CFrame.new(0, -2, 0.5) * CFrame.Angles(-1.5707963267948966, 0, 0);
    local WeldConstraint2 = Instance.new("WeldConstraint");
    WeldConstraint2.Part0 = PrimaryPart;
    WeldConstraint2.Part1 = v33;
    WeldConstraint2.Parent = PrimaryPart;

    if Players:GetPlayerFromCharacter(u23) == LocalPlayer then
        u22.Grip = u6;
    end;

    u36.Anchor = PrimaryPart;
    HeldHandleSelfHeal.WatchHandle(u22, PrimaryPart, function() -- Line: 434
        -- upvalues: u4 (ref), u22 (copy)
        local v53 = u4[u22];

        if v53 then
            v53 = v53.Character;
        end;

        return v53;
    end, function() -- Line: 438
        -- upvalues: u21 (copy), u22 (copy)
        return u21:HasHandle(u22);
    end, function() -- Line: 439
        -- upvalues: u4 (ref), u22 (copy), u21 (copy)
        local v54 = u4[u22];

        if v54 then
            v54 = v54.Character;
        end;

        if v54 then
            u21:SpawnHandle(u22, v54);
        end;
    end);
    u5[u22] = nil;
end;

function v1.UpdateToolState(p55, p56) -- Line: 449
    -- upvalues: u5 (copy), u4 (copy)
    if u5[p56] then
        return;
    end;

    local v57 = u4[p56] and u4[p56].Character or p55:GetCharacterForTool(p56);

    if not v57 then
        return;
    end;

    local v58 = p56.Parent == v57;
    local v59 = p55:HasHandle(p56);

    if v58 and not v59 then
        p55:SpawnHandle(p56, v57);

        return;
    end;

    if not v58 and v59 then
        p55:ClearHandle(p56);
    end;
end;

function v1.GetCharacterForTool(p60, p61) -- Line: 466
    -- upvalues: Players (copy)
    for _, v in Players:GetPlayers() do
        if v.Character and p61:IsDescendantOf(v.Character) then
            return v.Character;
        end;

        if v.Backpack and p61:IsDescendantOf(v.Backpack) then
            return v.Character;
        end;
    end;

    return nil;
end;

function v1.SetupTool(u62, u63, u64) -- Line: 479
    -- upvalues: u3 (copy)
    local u65 = {};
    local v66 = u63:GetPropertyChangedSignal("Parent");
    table.insert(u65, v66:Connect(function() -- Line: 483
        -- upvalues: u63 (copy), u62 (copy), u64 (copy)
        task.defer(function() -- Line: 484
            -- upvalues: u63 (ref), u62 (ref), u64 (ref)
            if not (u63 and u63.Parent) then
                u62:ClearHandle(u63);

                return;
            end;

            local v67 = u63.Parent == u64;
            local v68 = u62:HasHandle(u63);

            if v67 and not v68 then
                u62:SpawnHandle(u63, u64);

                return;
            end;

            if not v67 and v68 then
                u62:ClearHandle(u63);
            end;
        end);
    end));
    table.insert(u65, u63.Destroying:Connect(function() -- Line: 500
        -- upvalues: u62 (copy), u63 (copy), u65 (copy), u3 (ref)
        u62:ClearHandle(u63);

        for _, v in u65 do
            v:Disconnect();
        end;

        u3[u63] = nil;
    end));
    u3[u63] = u65;
    task.defer(function() -- Line: 509
        -- upvalues: u63 (copy), u64 (copy), u62 (copy)
        if u63 and u63.Parent == u64 then
            u62:SpawnHandle(u63, u64);
        end;
    end);
end;

function v1.SetupCharacter(u69, u70) -- Line: 517
    -- upvalues: Players (copy)
    local v71 = Players:GetPlayerFromCharacter(u70);

    local function CheckTool(p72) -- Line: 521
        -- upvalues: u69 (copy), u70 (copy)
        if p72:IsA("Tool") and u69:IsTrackedTool(p72) then
            u69:SetupTool(p72, u70);
        end;
    end;

    for _, child in u70:GetChildren() do
        if child:IsA("Tool") and u69:IsTrackedTool(child) then
            u69:SetupTool(child, u70);
        end;
    end;

    u70.ChildAdded:Connect(CheckTool);
    u70.ChildRemoved:Connect(function(p73) -- Line: 534
        -- upvalues: u69 (copy)
        if p73:IsA("Tool") then
            u69:ClearHandle(p73);
        end;
    end);

    if v71 and v71.Backpack then
        for _, child in v71.Backpack:GetChildren() do
            if child:IsA("Tool") and u69:IsTrackedTool(child) then
                u69:SetupTool(child, u70);
            end;
        end;
    end;
end;

local function SetupTrackedToolFromBackpack(p74, p75, p76) -- Line: 546
    if not p76:IsA("Tool") then
        return;
    end;

    if not p74:IsTrackedTool(p76) then
        return;
    end;

    local Character = p75.Character;

    if not Character then
        return;
    end;

    p74:SetupTool(p76, Character);
end;

function v1.Start(u77) -- Line: 554
    -- upvalues: BackpackListener (copy), Players (copy)
    local function bindPlayer(u78) -- Line: 555
        -- upvalues: u77 (copy), BackpackListener (ref)
        if u78.Character then
            u77:SetupCharacter(u78.Character);
        end;

        u78.CharacterAdded:Connect(function(p79) -- Line: 557
            -- upvalues: u77 (ref)
            u77:SetupCharacter(p79);
        end);
        BackpackListener.bind(u78, function(p80) -- Line: 563
            -- upvalues: u77 (ref), u78 (copy)
            local v81 = u77;

            if not p80:IsA("Tool") then
                return;
            end;

            if not v81:IsTrackedTool(p80) then
                return;
            end;

            local Character = u78.Character;

            if not Character then
                return;
            end;

            v81:SetupTool(p80, Character);
        end);
    end;

    for _, v in Players:GetPlayers() do
        bindPlayer(v);
    end;

    Players.PlayerAdded:Connect(bindPlayer);
end;

return v1;