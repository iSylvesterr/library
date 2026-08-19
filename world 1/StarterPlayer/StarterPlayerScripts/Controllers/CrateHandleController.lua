-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Crates = Assets:WaitForChild("Crates");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = CFrame.new(0, 0, 1);
local u6 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);

local function ResolveCrateTemplate(p7) -- Line: 27
    -- upvalues: Assets (copy), Crates (copy)
    local GuildCrates = Assets:FindFirstChild("GuildCrates");

    if GuildCrates then
        local v8 = GuildCrates:FindFirstChild(p7);

        if v8 and v8:IsA("Model") then
            return v8;
        end;
    end;

    local v9 = Crates:FindFirstChild(p7);

    if v9 and v9:IsA("Model") then
        return v9;
    end;

    local v10 = Crates:FindFirstChild("Arch Crate");

    if v10 and v10:IsA("Model") then
        return v10;
    end;

    return nil;
end;

function v1.Init(p11) -- Line: 48
end;

function v1.Start(u12) -- Line: 51
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u12:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p13) -- Line: 56
        -- upvalues: u12 (copy)
        u12:SetupPlayer(p13);
    end);
    Players.PlayerRemoving:Connect(function(p14) -- Line: 60
        -- upvalues: u2 (ref), Players (ref), u12 (copy)
        for i in u2 do
            local v15 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v15 == p14 then
                u12:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p16, p17) -- Line: 71
    p17.Anchored = false;
    p17.CanCollide = false;
    p17.CanQuery = false;
    p17.CanTouch = false;
end;

function v1.DisableVFX(p18, p19) -- Line: 78
    for _, descendant in p19:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            descendant.Enabled = false;
        elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Light") then
            descendant.Enabled = false;
        end;
    end;
end;

function v1.ClearHandle(p20, p21) -- Line: 91
    for _, child in p21:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 95
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p22, p23) -- Line: 104
    for _, child in p23:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u24, u25, p26) -- Line: 113
    -- upvalues: u4 (copy), ResolveCrateTemplate (copy), HandleScale (copy), LocalPlayer (copy), u5 (copy), u6 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u25] then
        return;
    end;

    u4[u25] = true;
    u24:ClearHandle(u25);
    local v27 = p26:FindFirstChild("Right Arm") or p26:FindFirstChild("RightHand");

    if not v27 then
        u4[u25] = nil;

        return;
    end;

    local v28 = u25:GetAttribute("Crate");

    if not v28 then
        u4[u25] = nil;

        return;
    end;

    local v29 = ResolveCrateTemplate(v28);

    if not v29 then
        u4[u25] = nil;

        return;
    end;

    local v30 = v29:Clone();
    u24:DisableVFX(v30);
    local v31 = p26:GetScale();
    HandleScale.ScaleClone(v30, v31);
    local v32 = LocalPlayer and LocalPlayer.Character == p26;
    local PrimaryPart = v30.PrimaryPart;

    if not PrimaryPart then
        v30:Destroy();
        u4[u25] = nil;

        return;
    end;

    for _, descendant in v30:GetDescendants() do
        if descendant:IsA("BasePart") then
            u24:PreparePartForTool(descendant);
        end;
    end;

    for _, descendant in v30:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = descendant;
            WeldConstraint.Parent = descendant;
        end;
    end;

    v30.Name = "Build";
    v30.Parent = u25;
    PrimaryPart.Name = "Handle";
    PrimaryPart.Parent = u25;

    if v32 then
        u25.Grip = HandleScale.ScaleGripTranslation(u5, v31);
    else
        PrimaryPart.CFrame = v27.CFrame * HandleScale.ScaleGripTranslation(u6, v31);
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = PrimaryPart;
        WeldConstraint.Part1 = v27;
        WeldConstraint.Parent = PrimaryPart;
    end;

    local Handle = u25:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u25, Handle, function() -- Line: 189
            -- upvalues: u3 (ref), u25 (copy)
            return u3[u25];
        end, function() -- Line: 190
            -- upvalues: u24 (copy), u25 (copy)
            return u24:HasHandle(u25);
        end, function() -- Line: 191
            -- upvalues: u3 (ref), u25 (copy), u24 (copy)
            local v33 = u3[u25];

            if v33 then
                u24:SpawnHandle(u25, v33);
            end;
        end);
    end;

    u4[u25] = nil;
end;

function v1.UpdateToolState(p34, p35) -- Line: 200
    -- upvalues: u4 (copy), u3 (copy)
    if u4[p35] then
        return;
    end;

    local v36 = u3[p35];

    if not v36 then
        return;
    end;

    local v37 = p35.Parent == v36;
    local v38 = p34:HasHandle(p35);

    if v37 and not v38 then
        p34:SpawnHandle(p35, v36);

        return;
    end;

    if not v37 and v38 then
        p34:ClearHandle(p35);
    end;
end;

function v1.DisconnectTool(p39, p40) -- Line: 216
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v41 = u2[p40];

    if v41 then
        for _, v in v41 do
            v:Disconnect();
        end;

        u2[p40] = nil;
    end;

    u3[p40] = nil;
    u4[p40] = nil;
end;

function v1.CleanupTool(p42, p43) -- Line: 228
    p42:ClearHandle(p43);
    p42:DisconnectTool(p43);
end;

function v1.IsTrackedTool(p44, p45) -- Line: 233
    return p45:GetAttribute("Crate") ~= nil;
end;

function v1.SetupTool(u46, u47, p48) -- Line: 237
    -- upvalues: u3 (copy), u2 (copy)
    u46:DisconnectTool(u47);
    local v49 = {};
    u3[u47] = p48;
    local v50 = u47:GetPropertyChangedSignal("Parent");
    table.insert(v49, v50:Connect(function() -- Line: 243
        -- upvalues: u47 (copy), u3 (ref), u46 (copy)
        task.defer(function() -- Line: 244
            -- upvalues: u47 (ref), u3 (ref), u46 (ref)
            if u47 and u3[u47] then
                u46:UpdateToolState(u47);
            end;
        end);
    end));
    u2[u47] = v49;
    task.defer(function() -- Line: 253
        -- upvalues: u47 (copy), u3 (ref), u46 (copy)
        if u47 and u3[u47] then
            u46:UpdateToolState(u47);
        end;
    end);
end;

function v1.SetupCharacter(u51, u52) -- Line: 260
    -- upvalues: Players (copy), HandleScale (copy)
    task.defer(function() -- Line: 261
        -- upvalues: u52 (copy), u51 (copy), Players (ref), HandleScale (ref)
        if not (u52 and u52.Parent) then
            return;
        end;

        for _, child in u52:GetChildren() do
            if child:IsA("Tool") and u51:IsTrackedTool(child) then
                u51:SetupTool(child, u52);
            end;
        end;

        local v53 = Players:GetPlayerFromCharacter(u52);

        if v53 and v53.Backpack then
            for _, child in v53.Backpack:GetChildren() do
                if child:IsA("Tool") and u51:IsTrackedTool(child) then
                    u51:SetupTool(child, u52);
                end;
            end;
        end;

        u52.ChildAdded:Connect(function(u54) -- Line: 279
            -- upvalues: u51 (ref), u52 (ref)
            if u54:IsA("Tool") and u51:IsTrackedTool(u54) then
                task.defer(function() -- Line: 281
                    -- upvalues: u54 (copy), u52 (ref), u51 (ref)
                    if u54 and (u54.Parent and (u52 and u52.Parent)) then
                        u51:SetupTool(u54, u52);
                    end;
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u52, function(p55) -- Line: 290
            -- upvalues: u51 (ref)
            return u51:IsTrackedTool(p55);
        end, function(p56, p57) -- Line: 291
            -- upvalues: u51 (ref)
            u51:SpawnHandle(p56, p57);
        end);
    end);
end;

function v1.SetupPlayer(u58, u59) -- Line: 295
    -- upvalues: BackpackListener (copy)
    if u59.Character then
        u58:SetupCharacter(u59.Character);
    end;

    u59.CharacterAdded:Connect(function(p60) -- Line: 300
        -- upvalues: u58 (copy)
        u58:SetupCharacter(p60);
    end);
    BackpackListener.bind(u59, function(u61) -- Line: 307
        -- upvalues: u58 (copy), u59 (copy)
        if u61:IsA("Tool") and u58:IsTrackedTool(u61) then
            task.defer(function() -- Line: 309
                -- upvalues: u59 (ref), u61 (copy), u58 (ref)
                local Character = u59.Character;

                if u61 and (u61.Parent and (Character and Character.Parent)) then
                    u58:SetupTool(u61, Character);
                end;
            end);
        end;
    end);
end;

return v1;