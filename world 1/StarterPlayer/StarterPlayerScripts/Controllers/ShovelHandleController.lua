-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Shovel = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Shovel");
local KingName = ReplicatedStorage.ServerValues.KingName;
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local SFX = game.SoundService:FindFirstChild("SFX");

if SFX then
    SFX = SFX:FindFirstChild("Shovel_SFX");
end;

local u2;

if SFX then
    u2 = SFX:FindFirstChild("Equip");
else
    u2 = SFX;
end;

if SFX then
    SFX = SFX:FindFirstChild("Unequip");
end;

local LocalPlayer = Players.LocalPlayer;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = CFrame.new(0, 0, 0);
local u7 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);

local function ScaleGripTranslation(p8, p9) -- Line: 31
    return CFrame.new(p8.Position * p9) * p8.Rotation;
end;

local u10 = {};
local u11 = nil;

local function applyKingVisual(p12) -- Line: 39
    -- upvalues: u10 (copy)
    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("BasePart") and not u10[descendant] then
            u10[descendant] = {
                Material = descendant.Material,
                MaterialVariant = descendant.MaterialVariant,
                Color = descendant.Color
            };
            descendant.Material = Enum.Material.Foil;
            descendant.MaterialVariant = "";
            descendant.Color = Color3.fromRGB(255, 200, 0);
        end;
    end;
end;

local function removeKingVisual() -- Line: 54
    -- upvalues: u10 (copy)
    for i, v in u10 do
        if i.Parent then
            i.Material = v.Material;
            i.MaterialVariant = v.MaterialVariant;
            i.Color = v.Color;
        end;
    end;

    table.clear(u10);
end;

local function updateKingVisual() -- Line: 65
    -- upvalues: LocalPlayer (copy), removeKingVisual (copy), u11 (ref), KingName (copy), applyKingVisual (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        removeKingVisual();
        u11 = nil;

        return;
    end;

    local v13 = Character:FindFirstChildWhichIsA("Tool");

    if KingName.Value ~= LocalPlayer.Name or not (v13 and v13:GetAttribute("Shovel")) then
        removeKingVisual();
        u11 = nil;

        return;
    end;

    if u11 ~= v13 then
        removeKingVisual();
    end;

    u11 = v13;
    applyKingVisual(v13);
end;

function v1.Init(p14) -- Line: 88
    -- upvalues: KingName (copy), updateKingVisual (copy)
    KingName:GetPropertyChangedSignal("Value"):Connect(updateKingVisual);
end;

function v1.Start(u15) -- Line: 92
    -- upvalues: Players (copy), u3 (copy)
    for _, v in Players:GetPlayers() do
        u15:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p16) -- Line: 97
        -- upvalues: u15 (copy)
        u15:SetupPlayer(p16);
    end);
    Players.PlayerRemoving:Connect(function(p17) -- Line: 101
        -- upvalues: u3 (ref), Players (ref), u15 (copy)
        for i in u3 do
            local v18 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v18 == p17 then
                u15:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p19, p20, p21) -- Line: 112
    p20.Anchored = false;
    p20.CanCollide = false;
    p20.CanQuery = false;
    p20.CanTouch = p21 == true;
end;

function v1.DisableVFX(p22, p23) -- Line: 119
    for _, descendant in p23:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Light") then
            descendant.Enabled = false;
        end;
    end;
end;

function v1.ClearHandle(p24, p25) -- Line: 131
    -- upvalues: u11 (ref), u10 (copy)
    if p25 == u11 then
        table.clear(u10);
        u11 = nil;
    end;

    for _, child in p25:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 141
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p26, p27) -- Line: 150
    for _, child in p27:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u28, u29, p30, p31) -- Line: 159
    -- upvalues: u5 (copy), Shovel (copy), HandleScale (copy), LocalPlayer (copy), u2 (copy), u6 (copy), u7 (copy), HeldHandleSelfHeal (copy), u4 (copy), updateKingVisual (copy)
    if u5[u29] then
        return;
    end;

    u5[u29] = true;
    u28:ClearHandle(u29);
    local v32 = p30:FindFirstChild("Right Arm") or p30:FindFirstChild("RightHand");

    if not v32 then
        u5[u29] = nil;

        return;
    end;

    local v33 = Shovel:Clone();
    u28:DisableVFX(v33);
    local v34 = p30:GetScale();

    if math.abs(v34 - 1) > 0.0001 then
        if v33:IsA("Model") then
            v33:ScaleTo(v34);
        elseif v33:IsA("BasePart") then
            v33.Size = v33.Size * v34;
        end;
    end;

    local v35 = p30:GetScale();
    HandleScale.ScaleClone(v33, v35);
    local v36 = LocalPlayer and LocalPlayer.Character == p30;
    local HumanoidRootPart = p30:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and (u2 and not p31) then
        local v37 = u2:Clone();
        v37.Parent = HumanoidRootPart;
        v37.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        v37:Play();
        game.Debris:AddItem(v37, v37.TimeLength <= 0 and 2 or v37.TimeLength / v37.PlaybackSpeed);
    end;

    if v33:IsA("BasePart") then
        u28:PreparePartForTool(v33, v36);
        v33.Name = "Handle";
        v33.Parent = u29;

        if v36 then
            u29.Grip = HandleScale.ScaleGripTranslation(u6, v35);
        else
            v33.CFrame = v32.CFrame * HandleScale.ScaleGripTranslation(u7, v35);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v33;
            WeldConstraint.Part1 = v32;
            WeldConstraint.Parent = v33;
        end;
    elseif v33:IsA("Model") then
        local PrimaryPart = v33.PrimaryPart;

        if not PrimaryPart then
            v33:Destroy();
            u5[u29] = nil;

            return;
        end;

        for _, descendant in v33:GetDescendants() do
            if descendant:IsA("BasePart") then
                u28:PreparePartForTool(descendant, v36);
            end;
        end;

        for _, descendant in v33:GetDescendants() do
            if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = PrimaryPart;
                WeldConstraint.Part1 = descendant;
                WeldConstraint.Parent = descendant;
            end;
        end;

        v33.Name = "Build";
        v33.Parent = u29;
        PrimaryPart.Name = "Handle";
        PrimaryPart.Parent = u29;

        if v36 then
            u29.Grip = HandleScale.ScaleGripTranslation(u6, v35);
        else
            PrimaryPart.CFrame = v32.CFrame * HandleScale.ScaleGripTranslation(u7, v35);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = v32;
            WeldConstraint.Parent = PrimaryPart;
        end;
    end;

    local Handle = u29:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u29, Handle, function() -- Line: 259
            -- upvalues: u4 (ref), u29 (copy)
            return u4[u29];
        end, function() -- Line: 260
            -- upvalues: u28 (copy), u29 (copy)
            return u28:HasHandle(u29);
        end, function() -- Line: 261
            -- upvalues: u4 (ref), u29 (copy), u28 (copy)
            local v38 = u4[u29];

            if v38 then
                u28:SpawnHandle(u29, v38, true);
            end;
        end);
    end;

    u5[u29] = nil;

    if v36 then
        updateKingVisual();
    end;
end;

function v1.UpdateToolState(p39, p40) -- Line: 275
    -- upvalues: u5 (copy), u4 (copy), SFX (copy)
    if u5[p40] then
        return;
    end;

    local v41 = u4[p40];

    if not v41 then
        return;
    end;

    local v42 = p40.Parent == v41;
    local v43 = p39:HasHandle(p40);

    if v42 and not v43 then
        p39:SpawnHandle(p40, v41);

        return;
    end;

    if not v42 and v43 then
        local HumanoidRootPart = v41:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and SFX then
            local v44 = SFX:Clone();
            v44.Parent = HumanoidRootPart;
            v44.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            v44:Play();
            game.Debris:AddItem(v44, v44.TimeLength <= 0 and 2 or v44.TimeLength / v44.PlaybackSpeed);
        end;

        p39:ClearHandle(p40);
    end;
end;

function v1.DisconnectTool(p45, p46) -- Line: 305
    -- upvalues: u3 (copy), u4 (copy), u5 (copy)
    local v47 = u3[p46];

    if v47 then
        for _, v in v47 do
            v:Disconnect();
        end;

        u3[p46] = nil;
    end;

    u4[p46] = nil;
    u5[p46] = nil;
end;

function v1.CleanupTool(p48, p49) -- Line: 317
    p48:ClearHandle(p49);
    p48:DisconnectTool(p49);
end;

function v1.IsTrackedTool(p50, p51) -- Line: 322
    return p51:GetAttribute("Shovel") ~= nil;
end;

function v1.SetupTool(u52, u53, p54) -- Line: 326
    -- upvalues: u4 (copy), u3 (copy)
    u52:DisconnectTool(u53);
    local v55 = {};
    u4[u53] = p54;
    local v56 = u53:GetPropertyChangedSignal("Parent");
    table.insert(v55, v56:Connect(function() -- Line: 332
        -- upvalues: u53 (copy), u4 (ref), u52 (copy)
        task.defer(function() -- Line: 333
            -- upvalues: u53 (ref), u4 (ref), u52 (ref)
            if u53 and u4[u53] then
                u52:UpdateToolState(u53);
            end;
        end);
    end));
    u3[u53] = v55;
    task.defer(function() -- Line: 342
        -- upvalues: u53 (copy), u4 (ref), u52 (copy)
        if u53 and u4[u53] then
            u52:UpdateToolState(u53);
        end;
    end);
end;

function v1.SetupCharacter(u57, u58) -- Line: 349
    -- upvalues: Players (copy), HandleScale (copy)
    task.defer(function() -- Line: 350
        -- upvalues: u58 (copy), u57 (copy), Players (ref), HandleScale (ref)
        if not (u58 and u58.Parent) then
            return;
        end;

        for _, child in u58:GetChildren() do
            if child:IsA("Tool") and u57:IsTrackedTool(child) then
                u57:SetupTool(child, u58);
            end;
        end;

        local v59 = Players:GetPlayerFromCharacter(u58);

        if v59 and v59.Backpack then
            for _, child in v59.Backpack:GetChildren() do
                if child:IsA("Tool") and u57:IsTrackedTool(child) then
                    u57:SetupTool(child, u58);
                end;
            end;
        end;

        u58.ChildAdded:Connect(function(u60) -- Line: 369
            -- upvalues: u57 (ref), u58 (ref)
            if u60:IsA("Tool") and u57:IsTrackedTool(u60) then
                task.defer(function() -- Line: 371
                    -- upvalues: u60 (copy), u58 (ref), u57 (ref)
                    if u60 and (u60.Parent and (u58 and u58.Parent)) then
                        u57:SetupTool(u60, u58);
                    end;
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u58, function(p61) -- Line: 380
            -- upvalues: u57 (ref)
            return u57:IsTrackedTool(p61);
        end, function(p62, p63) -- Line: 381
            -- upvalues: u57 (ref)
            u57:SpawnHandle(p62, p63);
        end);
    end);
end;

function v1.SetupPlayer(u64, u65) -- Line: 385
    -- upvalues: BackpackListener (copy)
    if u65.Character then
        u64:SetupCharacter(u65.Character);
    end;

    u65.CharacterAdded:Connect(function(p66) -- Line: 390
        -- upvalues: u64 (copy)
        u64:SetupCharacter(p66);
    end);
    BackpackListener.bind(u65, function(u67) -- Line: 394
        -- upvalues: u64 (copy), u65 (copy)
        if u67:IsA("Tool") and u64:IsTrackedTool(u67) then
            task.defer(function() -- Line: 396
                -- upvalues: u65 (ref), u67 (copy), u64 (ref)
                local Character = u65.Character;

                if u67 and (u67.Parent and (Character and Character.Parent)) then
                    u64:SetupTool(u67, Character);
                end;
            end);
        end;
    end);
end;

return v1;