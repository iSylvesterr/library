-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Trowel = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Trowel");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local Trowel_SFX = game.SoundService.SFX.Trowel_SFX;
local Equip = Trowel_SFX.Equip;
local Unequip = Trowel_SFX.Unequip;
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = CFrame.new(0, 0, 0);
local u6 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);

function v1.Init(p7) -- Line: 27
end;

function v1.Start(u8) -- Line: 30
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u8:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p9) -- Line: 35
        -- upvalues: u8 (copy)
        u8:SetupPlayer(p9);
    end);
    Players.PlayerRemoving:Connect(function(p10) -- Line: 39
        -- upvalues: u2 (ref), Players (ref), u8 (copy)
        for i in u2 do
            local v11 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v11 == p10 then
                u8:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p12, p13) -- Line: 50
    p13.Anchored = false;
    p13.CanCollide = false;
    p13.CanQuery = false;
    p13.CanTouch = false;
end;

function v1.DisableVFX(p14, p15) -- Line: 57
    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Light") then
            descendant.Enabled = false;
        end;
    end;
end;

function v1.ClearHandle(p16, p17) -- Line: 69
    for _, child in p17:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 73
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p18, p19) -- Line: 82
    for _, child in p19:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u20, u21, p22, p23) -- Line: 91
    -- upvalues: u4 (copy), Trowel (copy), HandleScale (copy), LocalPlayer (copy), Equip (copy), u5 (copy), u6 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u21] then
        return;
    end;

    u4[u21] = true;
    u20:ClearHandle(u21);
    local v24 = p22:FindFirstChild("Right Arm") or p22:FindFirstChild("RightHand");

    if not v24 then
        u4[u21] = nil;

        return;
    end;

    local v25 = Trowel:Clone();
    u20:DisableVFX(v25);
    local v26 = p22:GetScale();
    HandleScale.ScaleClone(v25, v26);
    local v27 = LocalPlayer and LocalPlayer.Character == p22;
    local HumanoidRootPart = p22:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and not p23 then
        local v28 = Equip:Clone();
        v28.Parent = HumanoidRootPart;
        v28.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        v28.Playing = true;
        game.Debris:AddItem(v28, v28.PlaybackSpeed * v28.TimeLength);
    end;

    if v25:IsA("BasePart") then
        u20:PreparePartForTool(v25);
        v25.Name = "Handle";
        v25.Parent = u21;

        if v27 then
            u21.Grip = HandleScale.ScaleGripTranslation(u5, v26);
        else
            v25.CFrame = v24.CFrame * HandleScale.ScaleGripTranslation(u6, v26);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v25;
            WeldConstraint.Part1 = v24;
            WeldConstraint.Parent = v25;
        end;
    elseif v25:IsA("Model") then
        local PrimaryPart = v25.PrimaryPart;

        if not PrimaryPart then
            v25:Destroy();
            u4[u21] = nil;

            return;
        end;

        for _, descendant in v25:GetDescendants() do
            if descendant:IsA("BasePart") then
                u20:PreparePartForTool(descendant);
            end;
        end;

        for _, descendant in v25:GetDescendants() do
            if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = PrimaryPart;
                WeldConstraint.Part1 = descendant;
                WeldConstraint.Parent = descendant;
            end;
        end;

        v25.Name = "Build";
        v25.Parent = u21;
        PrimaryPart.Name = "Handle";
        PrimaryPart.Parent = u21;

        if v27 then
            u21.Grip = HandleScale.ScaleGripTranslation(u5, v26);
        else
            PrimaryPart.CFrame = v24.CFrame * HandleScale.ScaleGripTranslation(u6, v26);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = v24;
            WeldConstraint.Parent = PrimaryPart;
        end;
    end;

    local Handle = u21:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u21, Handle, function() -- Line: 181
            -- upvalues: u3 (ref), u21 (copy)
            return u3[u21];
        end, function() -- Line: 182
            -- upvalues: u20 (copy), u21 (copy)
            return u20:HasHandle(u21);
        end, function() -- Line: 183
            -- upvalues: u3 (ref), u21 (copy), u20 (copy)
            local v29 = u3[u21];

            if v29 then
                u20:SpawnHandle(u21, v29, true);
            end;
        end);
    end;

    u4[u21] = nil;
end;

function v1.UpdateToolState(p30, p31) -- Line: 192
    -- upvalues: u4 (copy), u3 (copy), Unequip (copy)
    if u4[p31] then
        return;
    end;

    local v32 = u3[p31];

    if not v32 then
        return;
    end;

    local v33 = p31.Parent == v32;
    local v34 = p30:HasHandle(p31);

    if v33 and not v34 then
        p30:SpawnHandle(p31, v32);

        return;
    end;

    if not v33 and v34 then
        local HumanoidRootPart = v32:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            local v35 = Unequip:Clone();
            v35.Parent = HumanoidRootPart;
            v35.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            v35.Playing = true;
            game.Debris:AddItem(v35, v35.PlaybackSpeed * v35.TimeLength);
        end;

        p30:ClearHandle(p31);
    end;
end;

function v1.DisconnectTool(p36, p37) -- Line: 219
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v38 = u2[p37];

    if v38 then
        for _, v in v38 do
            v:Disconnect();
        end;

        u2[p37] = nil;
    end;

    u3[p37] = nil;
    u4[p37] = nil;
end;

function v1.CleanupTool(p39, p40) -- Line: 231
    p39:ClearHandle(p40);
    p39:DisconnectTool(p40);
end;

function v1.IsTrackedTool(p41, p42) -- Line: 236
    return p42:GetAttribute("Trowel") ~= nil;
end;

function v1.SetupTool(u43, u44, p45) -- Line: 240
    -- upvalues: u3 (copy), u2 (copy)
    u43:DisconnectTool(u44);
    local v46 = {};
    u3[u44] = p45;
    local v47 = u44:GetPropertyChangedSignal("Parent");
    table.insert(v46, v47:Connect(function() -- Line: 246
        -- upvalues: u44 (copy), u3 (ref), u43 (copy)
        task.defer(function() -- Line: 247
            -- upvalues: u44 (ref), u3 (ref), u43 (ref)
            if u44 and u3[u44] then
                u43:UpdateToolState(u44);
            end;
        end);
    end));
    u2[u44] = v46;
    task.defer(function() -- Line: 256
        -- upvalues: u44 (copy), u3 (ref), u43 (copy)
        if u44 and u3[u44] then
            u43:UpdateToolState(u44);
        end;
    end);
end;

function v1.SetupCharacter(u48, u49) -- Line: 263
    -- upvalues: Players (copy), HandleScale (copy)
    task.defer(function() -- Line: 264
        -- upvalues: u49 (copy), u48 (copy), Players (ref), HandleScale (ref)
        if not (u49 and u49.Parent) then
            return;
        end;

        for _, child in u49:GetChildren() do
            if child:IsA("Tool") and u48:IsTrackedTool(child) then
                u48:SetupTool(child, u49);
            end;
        end;

        local v50 = Players:GetPlayerFromCharacter(u49);

        if v50 and v50.Backpack then
            for _, child in v50.Backpack:GetChildren() do
                if child:IsA("Tool") and u48:IsTrackedTool(child) then
                    u48:SetupTool(child, u49);
                end;
            end;
        end;

        u49.ChildAdded:Connect(function(u51) -- Line: 283
            -- upvalues: u48 (ref), u49 (ref)
            if u51:IsA("Tool") and u48:IsTrackedTool(u51) then
                task.defer(function() -- Line: 285
                    -- upvalues: u51 (copy), u49 (ref), u48 (ref)
                    if u51 and (u51.Parent and (u49 and u49.Parent)) then
                        u48:SetupTool(u51, u49);
                    end;
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u49, function(p52) -- Line: 294
            -- upvalues: u48 (ref)
            return u48:IsTrackedTool(p52);
        end, function(p53, p54) -- Line: 295
            -- upvalues: u48 (ref)
            u48:SpawnHandle(p53, p54);
        end);
    end);
end;

function v1.SetupPlayer(u55, u56) -- Line: 299
    -- upvalues: BackpackListener (copy)
    if u56.Character then
        u55:SetupCharacter(u56.Character);
    end;

    u56.CharacterAdded:Connect(function(p57) -- Line: 304
        -- upvalues: u55 (copy)
        u55:SetupCharacter(p57);
    end);
    BackpackListener.bind(u56, function(u58) -- Line: 308
        -- upvalues: u55 (copy), u56 (copy)
        if u58:IsA("Tool") and u55:IsTrackedTool(u58) then
            task.defer(function() -- Line: 310
                -- upvalues: u56 (ref), u58 (copy), u55 (ref)
                local Character = u56.Character;

                if u58 and (u58.Parent and (Character and Character.Parent)) then
                    u55:SetupTool(u58, Character);
                end;
            end);
        end;
    end);
end;

return v1;