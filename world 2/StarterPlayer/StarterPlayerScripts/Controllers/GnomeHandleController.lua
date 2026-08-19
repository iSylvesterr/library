-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Gnome = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gnome");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = CFrame.new(0, 0, 0);
local u6 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);

function v1.Init(p7) -- Line: 21
end;

function v1.Start(u8) -- Line: 24
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u8:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p9) -- Line: 29
        -- upvalues: u8 (copy)
        u8:SetupPlayer(p9);
    end);
    Players.PlayerRemoving:Connect(function(p10) -- Line: 33
        -- upvalues: u2 (ref), Players (ref), u8 (copy)
        for i in u2 do
            local v11 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v11 == p10 then
                u8:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p12, p13) -- Line: 44
    p13.Anchored = false;
    p13.CanCollide = false;
    p13.CanQuery = false;
    p13.CanTouch = false;
end;

function v1.DisableVFX(p14, p15) -- Line: 51
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

function v1.ClearHandle(p16, p17) -- Line: 63
    for _, child in p17:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 67
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p18, p19) -- Line: 76
    for _, child in p19:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u20, u21, p22) -- Line: 85
    -- upvalues: u4 (copy), Gnome (copy), HandleScale (copy), LocalPlayer (copy), u5 (copy), u6 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u21] then
        return;
    end;

    u4[u21] = true;
    u20:ClearHandle(u21);
    local v23 = p22:FindFirstChild("Right Arm") or p22:FindFirstChild("RightHand");

    if not v23 then
        u4[u21] = nil;

        return;
    end;

    if not u21:GetAttribute("Gnome") then
        u4[u21] = nil;

        return;
    end;

    local v24 = Gnome:Clone();
    u20:DisableVFX(v24);
    local v25 = p22:GetScale();
    HandleScale.ScaleClone(v24, v25);
    local v26 = LocalPlayer and LocalPlayer.Character == p22;
    local PrimaryPart = v24.PrimaryPart;

    if not PrimaryPart then
        v24:Destroy();
        u4[u21] = nil;

        return;
    end;

    for _, descendant in v24:GetDescendants() do
        if descendant:IsA("BasePart") then
            u20:PreparePartForTool(descendant);
        end;
    end;

    for _, descendant in v24:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = descendant;
            WeldConstraint.Parent = descendant;
        end;
    end;

    v24.Name = "Build";
    v24.Parent = u21;
    PrimaryPart.Name = "Handle";
    PrimaryPart.Parent = u21;

    if v26 then
        u21.Grip = HandleScale.ScaleGripTranslation(u5, v25);
    else
        PrimaryPart.CFrame = v23.CFrame * HandleScale.ScaleGripTranslation(u6, v25);
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = PrimaryPart;
        WeldConstraint.Part1 = v23;
        WeldConstraint.Parent = PrimaryPart;
    end;

    local Handle = u21:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u21, Handle, function() -- Line: 155
            -- upvalues: u3 (ref), u21 (copy)
            return u3[u21];
        end, function() -- Line: 156
            -- upvalues: u20 (copy), u21 (copy)
            return u20:HasHandle(u21);
        end, function() -- Line: 157
            -- upvalues: u3 (ref), u21 (copy), u20 (copy)
            local v27 = u3[u21];

            if v27 then
                u20:SpawnHandle(u21, v27);
            end;
        end);
    end;

    u4[u21] = nil;
end;

function v1.UpdateToolState(p28, p29) -- Line: 166
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

function v1.DisconnectTool(p33, p34) -- Line: 182
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

function v1.CleanupTool(p36, p37) -- Line: 194
    p36:ClearHandle(p37);
    p36:DisconnectTool(p37);
end;

function v1.IsTrackedTool(p38, p39) -- Line: 199
    return p39:GetAttribute("Gnome") ~= nil;
end;

function v1.SetupTool(u40, u41, p42) -- Line: 203
    -- upvalues: u3 (copy), u2 (copy)
    u40:DisconnectTool(u41);
    local v43 = {};
    u3[u41] = p42;
    local v44 = u41:GetPropertyChangedSignal("Parent");
    table.insert(v43, v44:Connect(function() -- Line: 209
        -- upvalues: u41 (copy), u3 (ref), u40 (copy)
        task.defer(function() -- Line: 210
            -- upvalues: u41 (ref), u3 (ref), u40 (ref)
            if u41 and u3[u41] then
                u40:UpdateToolState(u41);
            end;
        end);
    end));
    u2[u41] = v43;
    task.defer(function() -- Line: 219
        -- upvalues: u41 (copy), u3 (ref), u40 (copy)
        if u41 and u3[u41] then
            u40:UpdateToolState(u41);
        end;
    end);
end;

function v1.SetupCharacter(u45, u46) -- Line: 226
    -- upvalues: Players (copy), HandleScale (copy)
    task.defer(function() -- Line: 227
        -- upvalues: u46 (copy), u45 (copy), Players (ref), HandleScale (ref)
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

        u46.ChildAdded:Connect(function(u48) -- Line: 246
            -- upvalues: u45 (ref), u46 (ref)
            if u48:IsA("Tool") and u45:IsTrackedTool(u48) then
                task.defer(function() -- Line: 248
                    -- upvalues: u48 (copy), u46 (ref), u45 (ref)
                    if u48 and (u48.Parent and (u46 and u46.Parent)) then
                        u45:SetupTool(u48, u46);
                    end;
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u46, function(p49) -- Line: 257
            -- upvalues: u45 (ref)
            return u45:IsTrackedTool(p49);
        end, function(p50, p51) -- Line: 258
            -- upvalues: u45 (ref)
            u45:SpawnHandle(p50, p51);
        end);
    end);
end;

function v1.SetupPlayer(u52, u53) -- Line: 262
    -- upvalues: BackpackListener (copy)
    if u53.Character then
        u52:SetupCharacter(u53.Character);
    end;

    u53.CharacterAdded:Connect(function(p54) -- Line: 267
        -- upvalues: u52 (copy)
        u52:SetupCharacter(p54);
    end);
    BackpackListener.bind(u53, function(u55) -- Line: 271
        -- upvalues: u52 (copy), u53 (copy)
        if u55:IsA("Tool") and u52:IsTrackedTool(u55) then
            task.defer(function() -- Line: 273
                -- upvalues: u53 (ref), u55 (copy), u52 (ref)
                local Character = u53.Character;

                if u55 and (u55.Parent and (Character and Character.Parent)) then
                    u52:SetupTool(u55, Character);
                end;
            end);
        end;
    end);
end;

return v1;