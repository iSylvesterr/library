-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Sprinklers = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Sprinklers");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = CFrame.new(0, 0.5, 0.25);
local u6 = CFrame.new(0, -1.25, 0.5) * CFrame.Angles(-1.5707963267948966, 0, 0);

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
        if child:GetAttribute("ClientHandle") and (child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model"))) then
            child.Parent = nil;
            task.defer(function() -- Line: 68
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p18, p19) -- Line: 77
    for _, child in p19:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u20, u21, p22) -- Line: 86
    -- upvalues: u4 (copy), Sprinklers (copy), HandleScale (copy), LocalPlayer (copy), u5 (copy), u6 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u21] then
        return;
    end;

    u4[u21] = true;
    u20:ClearHandle(u21);
    local v23 = u21:GetAttribute("Sprinkler");

    if not v23 then
        u4[u21] = nil;

        return;
    end;

    local v24 = Sprinklers:FindFirstChild(v23);

    if not v24 then
        u4[u21] = nil;

        return;
    end;

    local v25 = p22:FindFirstChild("Right Arm") or p22:FindFirstChild("RightHand");

    if not v25 then
        u4[u21] = nil;

        return;
    end;

    local v26 = v24:Clone();
    u20:DisableVFX(v26);
    local v27 = p22:GetScale();
    HandleScale.ScaleClone(v26, v27);
    local v28 = LocalPlayer and LocalPlayer.Character == p22;

    if v26:IsA("BasePart") then
        u20:PreparePartForTool(v26);
        v26.Name = "Handle";
        v26:SetAttribute("ClientHandle", true);
        v26.Parent = u21;

        if v28 then
            u21.Grip = HandleScale.ScaleGripTranslation(u5, v27);
        else
            v26.CFrame = v25.CFrame * HandleScale.ScaleGripTranslation(u6, v27);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v26;
            WeldConstraint.Part1 = v25;
            WeldConstraint.Parent = v26;
        end;
    elseif v26:IsA("Model") then
        local PrimaryPart = v26.PrimaryPart;

        if not PrimaryPart then
            v26:Destroy();
            u4[u21] = nil;

            return;
        end;

        for _, descendant in v26:GetDescendants() do
            if descendant:IsA("BasePart") then
                u20:PreparePartForTool(descendant);
            end;
        end;

        for _, descendant in v26:GetDescendants() do
            if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = PrimaryPart;
                WeldConstraint.Part1 = descendant;
                WeldConstraint.Parent = descendant;
            end;
        end;

        v26.Name = "Build";
        v26:SetAttribute("ClientHandle", true);
        v26.Parent = u21;
        PrimaryPart.Name = "Handle";
        PrimaryPart:SetAttribute("ClientHandle", true);
        PrimaryPart.Parent = u21;

        if v28 then
            u21.Grip = HandleScale.ScaleGripTranslation(u5, v27);
        else
            PrimaryPart.CFrame = v25.CFrame * HandleScale.ScaleGripTranslation(u6, v27);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = v25;
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
                u20:SpawnHandle(u21, v29);
            end;
        end);
    end;

    u4[u21] = nil;
end;

function v1.UpdateToolState(p30, p31) -- Line: 192
    -- upvalues: u4 (copy), u3 (copy)
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
        p30:ClearHandle(p31);
    end;
end;

function v1.DisconnectTool(p35, p36) -- Line: 208
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v37 = u2[p36];

    if v37 then
        for _, v in v37 do
            v:Disconnect();
        end;

        u2[p36] = nil;
    end;

    u3[p36] = nil;
    u4[p36] = nil;
end;

function v1.CleanupTool(p38, p39) -- Line: 220
    p38:ClearHandle(p39);
    p38:DisconnectTool(p39);
end;

function v1.IsTrackedTool(p40, p41) -- Line: 225
    return p41:GetAttribute("Sprinkler") ~= nil;
end;

function v1.SetupTool(u42, u43, p44) -- Line: 229
    -- upvalues: u3 (copy), u2 (copy)
    u42:DisconnectTool(u43);
    local v45 = {};
    u3[u43] = p44;
    local v46 = u43:GetPropertyChangedSignal("Parent");
    table.insert(v45, v46:Connect(function() -- Line: 235
        -- upvalues: u43 (copy), u3 (ref), u42 (copy)
        task.defer(function() -- Line: 236
            -- upvalues: u43 (ref), u3 (ref), u42 (ref)
            if u43 and u3[u43] then
                u42:UpdateToolState(u43);
            end;
        end);
    end));
    u2[u43] = v45;
    task.defer(function() -- Line: 245
        -- upvalues: u43 (copy), u3 (ref), u42 (copy)
        if u43 and u3[u43] then
            u42:UpdateToolState(u43);
        end;
    end);
end;

function v1.SetupCharacter(u47, u48) -- Line: 252
    -- upvalues: Players (copy), HandleScale (copy)
    task.defer(function() -- Line: 253
        -- upvalues: u48 (copy), u47 (copy), Players (ref), HandleScale (ref)
        if not (u48 and u48.Parent) then
            return;
        end;

        for _, child in u48:GetChildren() do
            if child:IsA("Tool") and u47:IsTrackedTool(child) then
                u47:SetupTool(child, u48);
            end;
        end;

        local v49 = Players:GetPlayerFromCharacter(u48);

        if v49 and v49.Backpack then
            for _, child in v49.Backpack:GetChildren() do
                if child:IsA("Tool") and u47:IsTrackedTool(child) then
                    u47:SetupTool(child, u48);
                end;
            end;
        end;

        u48.ChildAdded:Connect(function(u50) -- Line: 272
            -- upvalues: u47 (ref), u48 (ref)
            if u50:IsA("Tool") and u47:IsTrackedTool(u50) then
                task.defer(function() -- Line: 274
                    -- upvalues: u50 (copy), u48 (ref), u47 (ref)
                    if u50 and (u50.Parent and (u48 and u48.Parent)) then
                        u47:SetupTool(u50, u48);
                    end;
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u48, function(p51) -- Line: 283
            -- upvalues: u47 (ref)
            return u47:IsTrackedTool(p51);
        end, function(p52, p53) -- Line: 284
            -- upvalues: u47 (ref)
            u47:SpawnHandle(p52, p53);
        end);
    end);
end;

function v1.SetupPlayer(u54, u55) -- Line: 288
    -- upvalues: BackpackListener (copy)
    if u55.Character then
        u54:SetupCharacter(u55.Character);
    end;

    u55.CharacterAdded:Connect(function(p56) -- Line: 293
        -- upvalues: u54 (copy)
        u54:SetupCharacter(p56);
    end);
    BackpackListener.bind(u55, function(u57) -- Line: 297
        -- upvalues: u54 (copy), u55 (copy)
        if u57:IsA("Tool") and u54:IsTrackedTool(u57) then
            task.defer(function() -- Line: 299
                -- upvalues: u55 (ref), u57 (copy), u54 (ref)
                local Character = u55.Character;

                if u57 and (u57.Parent and (Character and Character.Parent)) then
                    u54:SetupTool(u57, Character);
                end;
            end);
        end;
    end);
end;

return v1;