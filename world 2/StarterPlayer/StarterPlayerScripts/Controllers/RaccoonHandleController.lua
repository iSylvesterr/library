-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");

local function ResolveRaccoonAsset() -- Line: 10
    -- upvalues: Assets (copy)
    local Pets = Assets:FindFirstChild("Pets");

    return Pets and Pets:FindFirstChild("Raccoon") or Assets:WaitForChild("Raccoon");
end;

local Pets = Assets:FindFirstChild("Pets");
local u2 = Pets and Pets:FindFirstChild("Raccoon") or Assets:WaitForChild("Raccoon");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local LocalPlayer = Players.LocalPlayer;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = CFrame.Angles(1.5707963267948966, 1.5707963267948966, 0);

function v1.Init(p7) -- Line: 29
end;

function v1.Start(u8) -- Line: 32
    -- upvalues: Players (copy), u3 (copy)
    for _, v in Players:GetPlayers() do
        u8:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p9) -- Line: 37
        -- upvalues: u8 (copy)
        u8:SetupPlayer(p9);
    end);
    Players.PlayerRemoving:Connect(function(p10) -- Line: 41
        -- upvalues: u3 (ref), Players (ref), u8 (copy)
        for i in u3 do
            local v11 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v11 == p10 then
                u8:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p12, p13) -- Line: 52
    p13.Anchored = false;
    p13.CanCollide = false;
    p13.CanQuery = false;
    p13.CanTouch = false;
end;

function v1.DisableVFX(p14, p15) -- Line: 59
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

function v1.ClearHandle(p16, p17) -- Line: 71
    for _, child in p17:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 75
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p18, p19) -- Line: 84
    for _, child in p19:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u20, u21, p22) -- Line: 93
    -- upvalues: u5 (copy), u2 (copy), LocalPlayer (copy), u6 (copy), HeldHandleSelfHeal (copy), u4 (copy)
    if u5[u21] then
        return;
    end;

    u5[u21] = true;
    u20:ClearHandle(u21);
    local v23 = p22:FindFirstChild("Right Arm") or p22:FindFirstChild("RightHand");

    if not v23 then
        u5[u21] = nil;

        return;
    end;

    if not u21:GetAttribute("Raccoon") then
        u5[u21] = nil;

        return;
    end;

    local v24 = u2:Clone();
    u20:DisableVFX(v24);
    local v25 = LocalPlayer and LocalPlayer.Character == p22;
    local PrimaryPart = v24.PrimaryPart;

    if not PrimaryPart then
        v24:Destroy();
        u5[u21] = nil;

        return;
    end;

    for _, descendant in v24:GetDescendants() do
        if descendant:IsA("BasePart") then
            u20:PreparePartForTool(descendant);
        end;
    end;

    local v26 = v24:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController");
    local u27 = v26:FindFirstChildOfClass("Animator");

    if not u27 then
        u27 = Instance.new("Animator");
        u27.Parent = v26;
    end;

    local Idle = v24:FindFirstChild("Idle");

    if not Idle then
        local Animations = v24:FindFirstChild("Animations");

        if Animations then
            Idle = Animations:FindFirstChild("Idle");
        end;
    end;

    v24.Name = "Build";
    v24.Parent = u21;
    PrimaryPart.Name = "Handle";
    PrimaryPart.Parent = u21;
    v26.Parent = PrimaryPart;
    u21.Grip = u6;

    if not v25 then
        PrimaryPart.CFrame = v23.CFrame * CFrame.new(0, -1, 0) * u6;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v23;
        WeldConstraint.Part1 = PrimaryPart;
        WeldConstraint.Parent = PrimaryPart;
    end;

    if Idle and Idle:IsA("Animation") then
        local success, result = pcall(function() -- Line: 179
            -- upvalues: u27 (ref), Idle (ref)
            return u27:LoadAnimation(Idle);
        end);

        if success and result then
            result.Looped = true;
            result:Play(0);
        end;
    end;

    local Handle = u21:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u21, Handle, function() -- Line: 191
            -- upvalues: u4 (ref), u21 (copy)
            return u4[u21];
        end, function() -- Line: 192
            -- upvalues: u20 (copy), u21 (copy)
            return u20:HasHandle(u21);
        end, function() -- Line: 193
            -- upvalues: u4 (ref), u21 (copy), u20 (copy)
            local v28 = u4[u21];

            if v28 then
                u20:SpawnHandle(u21, v28);
            end;
        end);
    end;

    u5[u21] = nil;
end;

function v1.UpdateToolState(p29, p30) -- Line: 202
    -- upvalues: u5 (copy), u4 (copy)
    if u5[p30] then
        return;
    end;

    local v31 = u4[p30];

    if not v31 then
        return;
    end;

    local v32 = p30.Parent == v31;
    local v33 = p29:HasHandle(p30);

    if v32 and not v33 then
        p29:SpawnHandle(p30, v31);

        return;
    end;

    if not v32 and v33 then
        p29:ClearHandle(p30);
    end;
end;

function v1.DisconnectTool(p34, p35) -- Line: 218
    -- upvalues: u3 (copy), u4 (copy), u5 (copy)
    local v36 = u3[p35];

    if v36 then
        for _, v in v36 do
            v:Disconnect();
        end;

        u3[p35] = nil;
    end;

    u4[p35] = nil;
    u5[p35] = nil;
end;

function v1.CleanupTool(p37, p38) -- Line: 230
    p37:ClearHandle(p38);
    p37:DisconnectTool(p38);
end;

function v1.IsTrackedTool(p39, p40) -- Line: 235
    return p40:GetAttribute("Raccoon") ~= nil;
end;

function v1.SetupTool(u41, u42, p43) -- Line: 239
    -- upvalues: u4 (copy), u3 (copy)
    u41:DisconnectTool(u42);
    local v44 = {};
    u4[u42] = p43;
    local v45 = u42:GetPropertyChangedSignal("Parent");
    table.insert(v44, v45:Connect(function() -- Line: 245
        -- upvalues: u42 (copy), u4 (ref), u41 (copy)
        task.defer(function() -- Line: 246
            -- upvalues: u42 (ref), u4 (ref), u41 (ref)
            if u42 and u4[u42] then
                u41:UpdateToolState(u42);
            end;
        end);
    end));
    u3[u42] = v44;
    task.defer(function() -- Line: 255
        -- upvalues: u42 (copy), u4 (ref), u41 (copy)
        if u42 and u4[u42] then
            u41:UpdateToolState(u42);
        end;
    end);
end;

function v1.SetupCharacter(u46, u47) -- Line: 262
    -- upvalues: Players (copy)
    task.defer(function() -- Line: 263
        -- upvalues: u47 (copy), u46 (copy), Players (ref)
        if not (u47 and u47.Parent) then
            return;
        end;

        for _, child in u47:GetChildren() do
            if child:IsA("Tool") and u46:IsTrackedTool(child) then
                u46:SetupTool(child, u47);
            end;
        end;

        local v48 = Players:GetPlayerFromCharacter(u47);

        if v48 and v48.Backpack then
            for _, child in v48.Backpack:GetChildren() do
                if child:IsA("Tool") and u46:IsTrackedTool(child) then
                    u46:SetupTool(child, u47);
                end;
            end;
        end;

        u47.ChildAdded:Connect(function(u49) -- Line: 282
            -- upvalues: u46 (ref), u47 (ref)
            if u49:IsA("Tool") and u46:IsTrackedTool(u49) then
                task.defer(function() -- Line: 284
                    -- upvalues: u49 (copy), u47 (ref), u46 (ref)
                    if u49 and (u49.Parent and (u47 and u47.Parent)) then
                        u46:SetupTool(u49, u47);
                    end;
                end);
            end;
        end);
    end);
end;

function v1.SetupPlayer(u50, u51) -- Line: 294
    -- upvalues: BackpackListener (copy)
    if u51.Character then
        u50:SetupCharacter(u51.Character);
    end;

    u51.CharacterAdded:Connect(function(p52) -- Line: 299
        -- upvalues: u50 (copy)
        u50:SetupCharacter(p52);
    end);
    BackpackListener.bind(u51, function(u53) -- Line: 303
        -- upvalues: u50 (copy), u51 (copy)
        if u53:IsA("Tool") and u50:IsTrackedTool(u53) then
            task.defer(function() -- Line: 305
                -- upvalues: u51 (ref), u53 (copy), u50 (ref)
                local Character = u51.Character;

                if u53 and (u53.Parent and (Character and Character.Parent)) then
                    u50:SetupTool(u53, Character);
                end;
            end);
        end;
    end);
end;

return v1;