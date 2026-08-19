-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");

local function ResolveBirdAsset() -- Line: 12
    -- upvalues: Assets (copy)
    local Pets = Assets:FindFirstChild("Pets");

    return Pets and Pets:FindFirstChild("Robin") or Assets:WaitForChild("Robin");
end;

local Pets = Assets:FindFirstChild("Pets");
local u2 = Pets and Pets:FindFirstChild("Robin") or Assets:WaitForChild("Robin");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local LocalPlayer = Players.LocalPlayer;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = CFrame.Angles(0, 0, -1.5707963267948966);

function v1.Init(p7) -- Line: 36
end;

function v1.Start(u8) -- Line: 40
    -- upvalues: Players (copy), u3 (copy)
    for _, v in Players:GetPlayers() do
        u8:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p9) -- Line: 46
        -- upvalues: u8 (copy)
        u8:SetupPlayer(p9);
    end);
    Players.PlayerRemoving:Connect(function(p10) -- Line: 51
        -- upvalues: u3 (ref), Players (ref), u8 (copy)
        for i in u3 do
            local v11 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v11 == p10 then
                u8:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p12, p13) -- Line: 63
    p13.Anchored = false;
    p13.CanCollide = false;
    p13.CanQuery = false;
    p13.CanTouch = false;
    p13.Massless = true;
end;

function v1.DisableVFX(p14, p15) -- Line: 72
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

function v1.ClearHandle(p16, p17) -- Line: 85
    for _, child in p17:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 89
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p18, p19) -- Line: 97
    for _, child in p19:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u20, u21, p22) -- Line: 105
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

    if not u21:GetAttribute("Bird") then
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

    local Animations = v24:FindFirstChild("Animations");
    local v28;

    if Animations then
        v28 = Animations:FindFirstChild("Fly");
    else
        v28 = nil;
    end;

    local u29 = v28 or v24:FindFirstChild("Fly");
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

    if u29 and u29:IsA("Animation") then
        local success, result = pcall(function() -- Line: 201
            -- upvalues: u27 (ref), u29 (ref)
            return u27:LoadAnimation(u29);
        end);

        if success and result then
            result.Looped = true;
            result:Play(0);
        end;
    end;

    local Handle = u21:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u21, Handle, function() -- Line: 214
            -- upvalues: u4 (ref), u21 (copy)
            return u4[u21];
        end, function() -- Line: 215
            -- upvalues: u20 (copy), u21 (copy)
            return u20:HasHandle(u21);
        end, function() -- Line: 216
            -- upvalues: u4 (ref), u21 (copy), u20 (copy)
            local v30 = u4[u21];

            if v30 then
                u20:SpawnHandle(u21, v30);
            end;
        end);
    end;

    u5[u21] = nil;
end;

function v1.UpdateToolState(p31, p32) -- Line: 226
    -- upvalues: u5 (copy), u4 (copy)
    if u5[p32] then
        return;
    end;

    local v33 = u4[p32];

    if not v33 then
        return;
    end;

    local v34 = p32.Parent == v33;
    local v35 = p31:HasHandle(p32);

    if v34 and not v35 then
        p31:SpawnHandle(p32, v33);

        return;
    end;

    if not v34 and v35 then
        p31:ClearHandle(p32);
    end;
end;

function v1.DisconnectTool(p36, p37) -- Line: 246
    -- upvalues: u3 (copy), u4 (copy), u5 (copy)
    local v38 = u3[p37];

    if v38 then
        for _, v in v38 do
            v:Disconnect();
        end;

        u3[p37] = nil;
    end;

    u4[p37] = nil;
    u5[p37] = nil;
end;

function v1.CleanupTool(p39, p40) -- Line: 259
    p39:ClearHandle(p40);
    p39:DisconnectTool(p40);
end;

function v1.IsTrackedTool(p41, p42) -- Line: 265
    return p42:GetAttribute("Bird") ~= nil;
end;

function v1.SetupTool(u43, u44, p45) -- Line: 270
    -- upvalues: u4 (copy), u3 (copy)
    u43:DisconnectTool(u44);
    local v46 = {};
    u4[u44] = p45;
    local v47 = u44:GetPropertyChangedSignal("Parent");
    table.insert(v46, v47:Connect(function() -- Line: 278
        -- upvalues: u44 (copy), u4 (ref), u43 (copy)
        task.defer(function() -- Line: 279
            -- upvalues: u44 (ref), u4 (ref), u43 (ref)
            if u44 and u4[u44] then
                u43:UpdateToolState(u44);
            end;
        end);
    end));
    u3[u44] = v46;
    task.defer(function() -- Line: 290
        -- upvalues: u44 (copy), u4 (ref), u43 (copy)
        if u44 and u4[u44] then
            u43:UpdateToolState(u44);
        end;
    end);
end;

function v1.SetupCharacter(u48, u49) -- Line: 298
    -- upvalues: Players (copy)
    task.defer(function() -- Line: 299
        -- upvalues: u49 (copy), u48 (copy), Players (ref)
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

        u49.ChildAdded:Connect(function(u51) -- Line: 320
            -- upvalues: u48 (ref), u49 (ref)
            if u51:IsA("Tool") and u48:IsTrackedTool(u51) then
                task.defer(function() -- Line: 322
                    -- upvalues: u51 (copy), u49 (ref), u48 (ref)
                    if u51 and (u51.Parent and (u49 and u49.Parent)) then
                        u48:SetupTool(u51, u49);
                    end;
                end);
            end;
        end);
    end);
end;

function v1.SetupPlayer(u52, u53) -- Line: 333
    -- upvalues: BackpackListener (copy)
    if u53.Character then
        u52:SetupCharacter(u53.Character);
    end;

    u53.CharacterAdded:Connect(function(p54) -- Line: 339
        -- upvalues: u52 (copy)
        u52:SetupCharacter(p54);
    end);
    BackpackListener.bind(u53, function(u55) -- Line: 344
        -- upvalues: u52 (copy), u53 (copy)
        if u55:IsA("Tool") and u52:IsTrackedTool(u55) then
            task.defer(function() -- Line: 346
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