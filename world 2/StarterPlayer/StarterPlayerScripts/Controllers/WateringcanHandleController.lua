-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local WateringCans = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("WateringCans");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = CFrame.new(0, 1.5, -0.75);
local u6 = CFrame.new(0, -0.25, 1.5) * CFrame.Angles(-1.5707963267948966, 0, 0);

function v1.Init(p7) -- Line: 21
end;

local Wateringcan_SFX = game.SoundService.SFX.Wateringcan_SFX;
local Equip = Wateringcan_SFX.Equip;
local Unequip = Wateringcan_SFX.Unequip;

function v1.Start(u8) -- Line: 28
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u8:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p9) -- Line: 33
        -- upvalues: u8 (copy)
        u8:SetupPlayer(p9);
    end);
    Players.PlayerRemoving:Connect(function(p10) -- Line: 37
        -- upvalues: u2 (ref), Players (ref), u8 (copy)
        for i in u2 do
            local v11 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v11 == p10 then
                u8:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p12, p13) -- Line: 48
    p13.Anchored = false;
    p13.CanCollide = false;
    p13.CanQuery = false;
    p13.CanTouch = false;
end;

function v1.DisableVFX(p14, p15) -- Line: 55
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

function v1.ClearHandle(p16, p17) -- Line: 67
    -- upvalues: Unequip (copy)
    local u18 = false;

    for _, child in p17:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 72
                -- upvalues: child (copy), u18 (ref)
                if child then
                    u18 = true;
                    child:Destroy();
                end;
            end);
        end;
    end;

    if u18 then
        Unequip.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Unequip.TimePosition = 0;
        Unequip.Playing = true;
    end;
end;

function v1.HasHandle(p19, p20) -- Line: 87
    for _, child in p20:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u21, u22, p23, p24) -- Line: 96
    -- upvalues: u4 (copy), Equip (copy), WateringCans (copy), HandleScale (copy), LocalPlayer (copy), u5 (copy), u6 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u22] then
        return;
    end;

    u4[u22] = true;
    u21:ClearHandle(u22);
    local v25 = u22:GetAttribute("WateringCan");

    if not v25 then
        u4[u22] = nil;

        return;
    end;

    if not p24 then
        Equip.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Equip.Playing = true;
        Equip.TimePosition = 0;
    end;

    local v26 = WateringCans:FindFirstChild(v25);

    if not v26 then
        u4[u22] = nil;

        return;
    end;

    local v27 = p23:FindFirstChild("Right Arm") or p23:FindFirstChild("RightHand");

    if not v27 then
        u4[u22] = nil;

        return;
    end;

    local v28 = v26:Clone();
    u21:DisableVFX(v28);
    local v29 = p23:GetScale();
    HandleScale.ScaleClone(v28, v29);
    local v30 = LocalPlayer and LocalPlayer.Character == p23;

    if v28:IsA("BasePart") then
        u21:PreparePartForTool(v28);
        v28.Name = "Handle";
        v28.Parent = u22;

        if v30 then
            u22.Grip = HandleScale.ScaleGripTranslation(u5, v29);
        else
            v28.CFrame = v27.CFrame * HandleScale.ScaleGripTranslation(u6, v29);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v28;
            WeldConstraint.Part1 = v27;
            WeldConstraint.Parent = v28;
        end;
    elseif v28:IsA("Model") then
        local PrimaryPart = v28.PrimaryPart;

        if not PrimaryPart then
            v28:Destroy();
            u4[u22] = nil;

            return;
        end;

        for _, descendant in v28:GetDescendants() do
            if descendant:IsA("BasePart") then
                u21:PreparePartForTool(descendant);
            end;
        end;

        for _, descendant in v28:GetDescendants() do
            if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = PrimaryPart;
                WeldConstraint.Part1 = descendant;
                WeldConstraint.Parent = descendant;
            end;
        end;

        v28.Name = "Build";
        v28.Parent = u22;
        PrimaryPart.Name = "Handle";
        PrimaryPart.Parent = u22;

        if v30 then
            u22.Grip = HandleScale.ScaleGripTranslation(u5, v29);
        else
            PrimaryPart.CFrame = v27.CFrame * HandleScale.ScaleGripTranslation(u6, v29);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = v27;
            WeldConstraint.Parent = PrimaryPart;
        end;
    end;

    local Handle = u22:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u22, Handle, function() -- Line: 194
            -- upvalues: u3 (ref), u22 (copy)
            return u3[u22];
        end, function() -- Line: 195
            -- upvalues: u21 (copy), u22 (copy)
            return u21:HasHandle(u22);
        end, function() -- Line: 196
            -- upvalues: u3 (ref), u22 (copy), u21 (copy)
            local v31 = u3[u22];

            if v31 then
                u21:SpawnHandle(u22, v31, true);
            end;
        end);
    end;

    u4[u22] = nil;
end;

function v1.UpdateToolState(p32, p33) -- Line: 205
    -- upvalues: u4 (copy), u3 (copy)
    if u4[p33] then
        return;
    end;

    local v34 = u3[p33];

    if not v34 then
        return;
    end;

    local v35 = p33.Parent == v34;
    local v36 = p32:HasHandle(p33);

    if v35 and not v36 then
        p32:SpawnHandle(p33, v34);

        return;
    end;

    if not v35 and v36 then
        p32:ClearHandle(p33);
    end;
end;

function v1.DisconnectTool(p37, p38) -- Line: 221
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v39 = u2[p38];

    if v39 then
        for _, v in v39 do
            v:Disconnect();
        end;

        u2[p38] = nil;
    end;

    u3[p38] = nil;
    u4[p38] = nil;
end;

function v1.CleanupTool(p40, p41) -- Line: 233
    p40:ClearHandle(p41);
    p40:DisconnectTool(p41);
end;

function v1.IsTrackedTool(p42, p43) -- Line: 238
    return p43:GetAttribute("WateringCan") ~= nil;
end;

function v1.SetupTool(u44, u45, p46) -- Line: 242
    -- upvalues: u3 (copy), u2 (copy)
    u44:DisconnectTool(u45);
    local v47 = {};
    u3[u45] = p46;
    local v48 = u45:GetPropertyChangedSignal("Parent");
    table.insert(v47, v48:Connect(function() -- Line: 248
        -- upvalues: u45 (copy), u3 (ref), u44 (copy)
        task.defer(function() -- Line: 249
            -- upvalues: u45 (ref), u3 (ref), u44 (ref)
            if u45 and u3[u45] then
                u44:UpdateToolState(u45);
            end;
        end);
    end));
    u2[u45] = v47;
    task.defer(function() -- Line: 258
        -- upvalues: u45 (copy), u3 (ref), u44 (copy)
        if u45 and u3[u45] then
            u44:UpdateToolState(u45);
        end;
    end);
end;

function v1.SetupCharacter(u49, u50) -- Line: 265
    -- upvalues: Players (copy), HandleScale (copy)
    task.defer(function() -- Line: 266
        -- upvalues: u50 (copy), u49 (copy), Players (ref), HandleScale (ref)
        if not (u50 and u50.Parent) then
            return;
        end;

        for _, child in u50:GetChildren() do
            if child:IsA("Tool") and u49:IsTrackedTool(child) then
                u49:SetupTool(child, u50);
            end;
        end;

        local v51 = Players:GetPlayerFromCharacter(u50);

        if v51 and v51.Backpack then
            for _, child in v51.Backpack:GetChildren() do
                if child:IsA("Tool") and u49:IsTrackedTool(child) then
                    u49:SetupTool(child, u50);
                end;
            end;
        end;

        u50.ChildAdded:Connect(function(u52) -- Line: 284
            -- upvalues: u49 (ref), u50 (ref)
            if u52:IsA("Tool") and u49:IsTrackedTool(u52) then
                task.defer(function() -- Line: 286
                    -- upvalues: u52 (copy), u50 (ref), u49 (ref)
                    if u52 and (u52.Parent and (u50 and u50.Parent)) then
                        u49:SetupTool(u52, u50);
                    end;
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u50, function(p53) -- Line: 295
            -- upvalues: u49 (ref)
            return u49:IsTrackedTool(p53);
        end, function(p54, p55) -- Line: 296
            -- upvalues: u49 (ref)
            u49:SpawnHandle(p54, p55);
        end);
    end);
end;

function v1.SetupPlayer(u56, u57) -- Line: 300
    -- upvalues: BackpackListener (copy)
    if u57.Character then
        u56:SetupCharacter(u57.Character);
    end;

    u57.CharacterAdded:Connect(function(p58) -- Line: 305
        -- upvalues: u56 (copy)
        u56:SetupCharacter(p58);
    end);
    BackpackListener.bind(u57, function(u59) -- Line: 309
        -- upvalues: u56 (copy), u57 (copy)
        if u59:IsA("Tool") and u56:IsTrackedTool(u59) then
            task.defer(function() -- Line: 311
                -- upvalues: u57 (ref), u59 (copy), u56 (ref)
                local Character = u57.Character;

                if u59 and (u59.Parent and (Character and Character.Parent)) then
                    u56:SetupTool(u59, Character);
                end;
            end);
        end;
    end);
end;

return v1;