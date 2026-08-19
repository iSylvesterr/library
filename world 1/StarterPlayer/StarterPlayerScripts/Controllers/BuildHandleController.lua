-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Build = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Build");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = CFrame.new(0, 0, 0);
local u6 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);

local function PlaySFX(p7, p8) -- Line: 25
    -- upvalues: SoundService (copy)
    local HumanoidRootPart = p7:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = p8;
    Sound.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound.Parent = HumanoidRootPart;
    Sound:Play();
    game.Debris:AddItem(Sound, Sound.TimeLength / Sound.PlaybackSpeed + 1);
end;

function v1.Init(p9) -- Line: 37
end;

function v1.Start(u10) -- Line: 40
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u10:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p11) -- Line: 45
        -- upvalues: u10 (copy)
        u10:SetupPlayer(p11);
    end);
    Players.PlayerRemoving:Connect(function(p12) -- Line: 49
        -- upvalues: u2 (ref), Players (ref), u10 (copy)
        for i in u2 do
            local v13 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v13 == p12 then
                u10:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p14, p15) -- Line: 60
    p15.Anchored = false;
    p15.CanCollide = false;
    p15.CanQuery = false;
    p15.CanTouch = false;
end;

function v1.DisableVFX(p16, p17) -- Line: 67
    for _, descendant in p17:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Light") then
            descendant.Enabled = false;
        end;
    end;
end;

function v1.ClearHandle(p18, p19) -- Line: 79
    for _, child in p19:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 83
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p20, p21) -- Line: 92
    for _, child in p21:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u22, u23, p24, p25) -- Line: 101
    -- upvalues: u4 (copy), Build (copy), HandleScale (copy), LocalPlayer (copy), PlaySFX (copy), u5 (copy), u6 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u23] then
        return;
    end;

    u4[u23] = true;
    u22:ClearHandle(u23);
    local v26 = p24:FindFirstChild("Right Arm") or p24:FindFirstChild("RightHand");

    if not v26 then
        u4[u23] = nil;

        return;
    end;

    local v27 = Build:Clone();
    u22:DisableVFX(v27);
    local v28 = p24:GetScale();
    HandleScale.ScaleClone(v27, v28);
    local v29 = LocalPlayer and LocalPlayer.Character == p24;

    if not p25 then
        PlaySFX(p24, "rbxassetid://91013210534200");
    end;

    if v27:IsA("BasePart") then
        u22:PreparePartForTool(v27);
        v27.Name = "Handle";
        v27.Parent = u23;

        if v29 then
            u23.Grip = HandleScale.ScaleGripTranslation(u5, v28);
        else
            v27.CFrame = v26.CFrame * HandleScale.ScaleGripTranslation(u6, v28);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v27;
            WeldConstraint.Part1 = v26;
            WeldConstraint.Parent = v27;
        end;
    elseif v27:IsA("Model") then
        local PrimaryPart = v27.PrimaryPart;

        if not PrimaryPart then
            v27:Destroy();
            u4[u23] = nil;

            return;
        end;

        for _, descendant in v27:GetDescendants() do
            if descendant:IsA("BasePart") then
                u22:PreparePartForTool(descendant);
            end;
        end;

        for _, descendant in v27:GetDescendants() do
            if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = PrimaryPart;
                WeldConstraint.Part1 = descendant;
                WeldConstraint.Parent = descendant;
            end;
        end;

        v27.Name = "Build";
        v27.Parent = u23;
        PrimaryPart.Name = "Handle";
        PrimaryPart.Parent = u23;

        if v29 then
            u23.Grip = HandleScale.ScaleGripTranslation(u5, v28);
        else
            PrimaryPart.CFrame = v26.CFrame * HandleScale.ScaleGripTranslation(u6, v28);
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = v26;
            WeldConstraint.Parent = PrimaryPart;
        end;
    end;

    local Handle = u23:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u23, Handle, function() -- Line: 185
            -- upvalues: u3 (ref), u23 (copy)
            return u3[u23];
        end, function() -- Line: 186
            -- upvalues: u22 (copy), u23 (copy)
            return u22:HasHandle(u23);
        end, function() -- Line: 187
            -- upvalues: u3 (ref), u23 (copy), u22 (copy)
            local v30 = u3[u23];

            if v30 then
                u22:SpawnHandle(u23, v30, true);
            end;
        end);
    end;

    u4[u23] = nil;
end;

function v1.UpdateToolState(p31, p32) -- Line: 196
    -- upvalues: u4 (copy), u3 (copy), PlaySFX (copy)
    if u4[p32] then
        return;
    end;

    local v33 = u3[p32];

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
        PlaySFX(v33, "rbxassetid://134987769896663");
        p31:ClearHandle(p32);
    end;
end;

function v1.DisconnectTool(p36, p37) -- Line: 213
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

function v1.CleanupTool(p39, p40) -- Line: 225
    p39:ClearHandle(p40);
    p39:DisconnectTool(p40);
end;

function v1.IsTrackedTool(p41, p42) -- Line: 230
    return p42:GetAttribute("Build") ~= nil;
end;

function v1.SetupTool(u43, u44, p45) -- Line: 234
    -- upvalues: u3 (copy), u2 (copy)
    u43:DisconnectTool(u44);
    local v46 = {};
    u3[u44] = p45;
    local v47 = u44:GetPropertyChangedSignal("Parent");
    table.insert(v46, v47:Connect(function() -- Line: 240
        -- upvalues: u44 (copy), u3 (ref), u43 (copy)
        task.defer(function() -- Line: 241
            -- upvalues: u44 (ref), u3 (ref), u43 (ref)
            if u44 and u3[u44] then
                u43:UpdateToolState(u44);
            end;
        end);
    end));
    u2[u44] = v46;
    task.defer(function() -- Line: 250
        -- upvalues: u44 (copy), u3 (ref), u43 (copy)
        if u44 and u3[u44] then
            u43:UpdateToolState(u44);
        end;
    end);
end;

function v1.SetupCharacter(u48, u49) -- Line: 257
    -- upvalues: Players (copy), HandleScale (copy)
    task.defer(function() -- Line: 258
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

        u49.ChildAdded:Connect(function(u51) -- Line: 277
            -- upvalues: u48 (ref), u49 (ref)
            if u51:IsA("Tool") and u48:IsTrackedTool(u51) then
                task.defer(function() -- Line: 279
                    -- upvalues: u51 (copy), u49 (ref), u48 (ref)
                    if u51 and (u51.Parent and (u49 and u49.Parent)) then
                        u48:SetupTool(u51, u49);
                    end;
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u49, function(p52) -- Line: 288
            -- upvalues: u48 (ref)
            return u48:IsTrackedTool(p52);
        end, function(p53, p54) -- Line: 289
            -- upvalues: u48 (ref)
            u48:SpawnHandle(p53, p54);
        end);
    end);
end;

function v1.SetupPlayer(u55, u56) -- Line: 293
    -- upvalues: BackpackListener (copy)
    if u56.Character then
        u55:SetupCharacter(u56.Character);
    end;

    u56.CharacterAdded:Connect(function(p57) -- Line: 298
        -- upvalues: u55 (copy)
        u55:SetupCharacter(p57);
    end);
    BackpackListener.bind(u56, function(u58) -- Line: 302
        -- upvalues: u55 (copy), u56 (copy)
        if u58:IsA("Tool") and u55:IsTrackedTool(u58) then
            task.defer(function() -- Line: 304
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