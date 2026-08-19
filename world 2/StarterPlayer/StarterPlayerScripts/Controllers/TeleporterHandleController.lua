-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Teleporter = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Teleporter");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = CFrame.new(0, 0, 0);
local u6 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);

function v1.Init(p7) -- Line: 20
end;

function v1.Start(u8) -- Line: 23
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u8:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p9) -- Line: 28
        -- upvalues: u8 (copy)
        u8:SetupPlayer(p9);
    end);
    Players.PlayerRemoving:Connect(function(p10) -- Line: 32
        -- upvalues: u2 (ref), Players (ref), u8 (copy)
        for i in u2 do
            local v11 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v11 == p10 then
                u8:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p12, p13, p14) -- Line: 43
    p13.Anchored = false;
    p13.CanCollide = false;
    p13.CanQuery = false;
    p13.CanTouch = p14 == true;
end;

function v1.DisableVFX(p15, p16) -- Line: 50
    for _, descendant in p16:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Light") then
            descendant.Enabled = false;
        end;
    end;
end;

function v1.ClearHandle(p17, p18) -- Line: 62
    for _, child in p18:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 66
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p19, p20) -- Line: 75
    for _, child in p20:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u21, u22, p23) -- Line: 84
    -- upvalues: u4 (copy), Teleporter (copy), LocalPlayer (copy), u5 (copy), u6 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u22] then
        return;
    end;

    u4[u22] = true;
    u21:ClearHandle(u22);
    local v24 = p23:FindFirstChild("Right Arm") or p23:FindFirstChild("RightHand");

    if not v24 then
        u4[u22] = nil;

        return;
    end;

    local v25 = Teleporter:Clone();
    u21:DisableVFX(v25);
    local v26 = LocalPlayer and LocalPlayer.Character == p23;

    if v25:IsA("BasePart") then
        u21:PreparePartForTool(v25, v26);
        v25.Name = "Handle";
        v25.Parent = u22;

        if v26 then
            u22.Grip = u5;
        else
            v25.CFrame = v24.CFrame * u6;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v25;
            WeldConstraint.Part1 = v24;
            WeldConstraint.Parent = v25;
        end;
    elseif v25:IsA("Model") then
        local PrimaryPart = v25.PrimaryPart;

        if not PrimaryPart then
            v25:Destroy();
            u4[u22] = nil;

            return;
        end;

        for _, descendant in v25:GetDescendants() do
            if descendant:IsA("BasePart") then
                u21:PreparePartForTool(descendant, v26);
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
        v25.Parent = u22;
        PrimaryPart.Name = "Handle";
        PrimaryPart.Parent = u22;

        if v26 then
            u22.Grip = u5;
        else
            PrimaryPart.CFrame = v24.CFrame * u6;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = v24;
            WeldConstraint.Parent = PrimaryPart;
        end;
    end;

    local Handle = u22:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u22, Handle, function() -- Line: 161
            -- upvalues: u3 (ref), u22 (copy)
            return u3[u22];
        end, function() -- Line: 162
            -- upvalues: u21 (copy), u22 (copy)
            return u21:HasHandle(u22);
        end, function() -- Line: 163
            -- upvalues: u3 (ref), u22 (copy), u21 (copy)
            local v27 = u3[u22];

            if v27 then
                u21:SpawnHandle(u22, v27);
            end;
        end);
    end;

    u4[u22] = nil;
end;

function v1.UpdateToolState(p28, p29) -- Line: 172
    -- upvalues: u4 (copy), u3 (copy)
    if u4[p29] then
        return;
    end;

    local v30 = u3[p29];

    if not v30 then
        return;
    end;

    local v31 = p29.Parent == v30;
    local v32 = p28:HasHandle(p29);

    if v31 and not v32 then
        p28:SpawnHandle(p29, v30);

        return;
    end;

    if not v31 and v32 then
        p28:ClearHandle(p29);
    end;
end;

function v1.DisconnectTool(p33, p34) -- Line: 188
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v35 = u2[p34];

    if v35 then
        for _, v in v35 do
            v:Disconnect();
        end;

        u2[p34] = nil;
    end;

    u3[p34] = nil;
    u4[p34] = nil;
end;

function v1.CleanupTool(p36, p37) -- Line: 200
    p36:ClearHandle(p37);
    p36:DisconnectTool(p37);
end;

function v1.IsTrackedTool(p38, p39) -- Line: 205
    return p39:GetAttribute("Teleporter") ~= nil;
end;

function v1.SetupTool(u40, u41, p42) -- Line: 209
    -- upvalues: u3 (copy), u2 (copy)
    u40:DisconnectTool(u41);
    local v43 = {};
    u3[u41] = p42;
    local v44 = u41:GetPropertyChangedSignal("Parent");
    table.insert(v43, v44:Connect(function() -- Line: 215
        -- upvalues: u41 (copy), u3 (ref), u40 (copy)
        task.defer(function() -- Line: 216
            -- upvalues: u41 (ref), u3 (ref), u40 (ref)
            if u41 and u3[u41] then
                u40:UpdateToolState(u41);
            end;
        end);
    end));
    u2[u41] = v43;
    task.defer(function() -- Line: 225
        -- upvalues: u41 (copy), u3 (ref), u40 (copy)
        if u41 and u3[u41] then
            u40:UpdateToolState(u41);
        end;
    end);
end;

function v1.SetupCharacter(u45, u46) -- Line: 232
    -- upvalues: Players (copy)
    task.defer(function() -- Line: 233
        -- upvalues: u46 (copy), u45 (copy), Players (ref)
        if not (u46 and u46.Parent) then
            return;
        end;

        for _, child in u46:GetChildren() do
            if child:IsA("Tool") and u45:IsTrackedTool(child) then
                u45:SetupTool(child, u46);
            end;
        end;

        local v47 = Players:GetPlayerFromCharacter(u46);

        if v47 and v47.Backpack then
            for _, child in v47.Backpack:GetChildren() do
                if child:IsA("Tool") and u45:IsTrackedTool(child) then
                    u45:SetupTool(child, u46);
                end;
            end;
        end;

        u46.ChildAdded:Connect(function(u48) -- Line: 252
            -- upvalues: u45 (ref), u46 (ref)
            if u48:IsA("Tool") and u45:IsTrackedTool(u48) then
                task.defer(function() -- Line: 254
                    -- upvalues: u48 (copy), u46 (ref), u45 (ref)
                    if u48 and (u48.Parent and (u46 and u46.Parent)) then
                        u45:SetupTool(u48, u46);
                    end;
                end);
            end;
        end);
    end);
end;

function v1.SetupPlayer(u49, u50) -- Line: 264
    -- upvalues: BackpackListener (copy)
    if u50.Character then
        u49:SetupCharacter(u50.Character);
    end;

    u50.CharacterAdded:Connect(function(p51) -- Line: 269
        -- upvalues: u49 (copy)
        u49:SetupCharacter(p51);
    end);
    BackpackListener.bind(u50, function(u52) -- Line: 273
        -- upvalues: u49 (copy), u50 (copy)
        if u52:IsA("Tool") and u49:IsTrackedTool(u52) then
            task.defer(function() -- Line: 275
                -- upvalues: u50 (ref), u52 (copy), u49 (ref)
                local Character = u50.Character;

                if u52 and (u52.Parent and (Character and Character.Parent)) then
                    u49:SetupTool(u52, Character);
                end;
            end);
        end;
    end);
end;

return v1;