-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Networking = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"));
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local PetModules = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("PetModules"));
local PetSizes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetSizes"));
local PetTypes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetTypes"));
local ButterflyWingColors = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("ButterflyWingColors"));
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = CFrame.fromOrientation(0, 0, -1.5707963267948966);

local function GetSpeciesGrip(p8) -- Line: 62
    -- upvalues: u7 (copy)
    if not p8 then
        return u7;
    end;

    local HandGrip = p8.HandGrip;

    if typeof(HandGrip) == "Vector3" then
        return CFrame.fromOrientation(math.rad(HandGrip.X), math.rad(HandGrip.Y), (math.rad(HandGrip.Z)));
    end;

    return u7;
end;

local function GetSpeciesPivotCFrame(p9) -- Line: 71
    if not p9 then
        return CFrame.identity;
    end;

    local Pivot = p9.Pivot;

    if typeof(Pivot) == "Vector3" then
        return CFrame.Angles(math.rad(Pivot.X), math.rad(Pivot.Y), (math.rad(Pivot.Z)));
    end;

    return CFrame.identity;
end;

local function GetIdleAnimationName(p10) -- Line: 80
    local v11;

    if p10 then
        v11 = p10.Animations;
    else
        v11 = p10;
    end;

    if type(v11) ~= "table" then
        return nil;
    end;

    local HeldAnimation = p10.HeldAnimation;

    if type(HeldAnimation) == "string" and v11[HeldAnimation] then
        return v11[HeldAnimation];
    end;

    if p10.IsFlying then
        return v11.Fly or v11.Idle;
    end;

    return v11.Idle;
end;

local function PlayPetCarry() -- Line: 93
    -- upvalues: LocalPlayer (copy), u5 (ref)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v12 = Character:FindFirstChildOfClass("Humanoid");

    if not v12 then
        return;
    end;

    local v13 = v12:FindFirstChildOfClass("Animator");

    if not v13 then
        return;
    end;

    if not u5 then
        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://72938295589356";
        u5 = v13:LoadAnimation(Animation);
        u5.Looped = true;
        u5.Priority = Enum.AnimationPriority.Action4;
    end;

    if not u5.IsPlaying then
        u5:Play();
    end;
end;

local function StopPetCarry() -- Line: 114
    -- upvalues: u5 (ref)
    if u5 and u5.IsPlaying then
        u5:Stop();
    end;
end;

function v1.Init(p14) -- Line: 120
end;

function v1.Start(u15) -- Line: 123
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u15:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p16) -- Line: 128
        -- upvalues: u15 (copy)
        u15:SetupPlayer(p16);
    end);
    Players.PlayerRemoving:Connect(function(p17) -- Line: 132
        -- upvalues: u2 (ref), Players (ref), u15 (copy)
        for i in u2 do
            local v18 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v18 == p17 then
                u15:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p19, p20) -- Line: 143
    p20.Anchored = false;
    p20.CanCollide = false;
    p20.CanQuery = false;
    p20.CanTouch = false;
    p20.Massless = true;
end;

function v1.DisableVFX(p21, p22) -- Line: 151
    for _, descendant in p22:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Light") then
            descendant.Enabled = false;
        end;
    end;
end;

function v1.ApplyToolInvisibility(p23, p24, p25) -- Line: 168
    for _, descendant in p24:GetDescendants() do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            if p25 then
                if descendant:GetAttribute("OG_Transparency") == nil then
                    descendant:SetAttribute("OG_Transparency", descendant.Transparency);
                end;

                descendant.Transparency = 1;
            else
                local v26 = descendant:GetAttribute("OG_Transparency");

                if v26 ~= nil then
                    descendant.Transparency = v26;
                    descendant:SetAttribute("OG_Transparency", nil);
                end;
            end;
        elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or (descendant:IsA("Beam") or (descendant:IsA("Fire") or (descendant:IsA("Smoke") or (descendant:IsA("Sparkles") or descendant:IsA("Light")))))) then
            if p25 then
                if descendant:GetAttribute("OG_Enabled") == nil then
                    descendant:SetAttribute("OG_Enabled", descendant.Enabled);
                end;

                descendant.Enabled = false;
            else
                local v27 = descendant:GetAttribute("OG_Enabled");

                if v27 ~= nil then
                    descendant.Enabled = v27;
                    descendant:SetAttribute("OG_Enabled", nil);
                end;
            end;
        end;
    end;
end;

function v1.ClearHandle(p28, p29) -- Line: 201
    if p29:HasTag("PetRainbow") then
        p29:RemoveTag("PetRainbow");
    end;

    for _, child in p29:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 210
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p30, p31) -- Line: 217
    for _, child in p31:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.PlaceAboveHead(p32, p33, p34, p35, p36, p37) -- Line: 227
    local Head = p35:FindFirstChild("Head");
    local HumanoidRootPart = p35:FindFirstChild("HumanoidRootPart");

    if not (Head and Head:IsA("BasePart")) then
        return;
    end;

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local v38;

    if p36 then
        local Pivot = p36.Pivot;

        if typeof(Pivot) == "Vector3" then
            v38 = CFrame.Angles(math.rad(Pivot.X), math.rad(Pivot.Y), (math.rad(Pivot.Z)));
        else
            v38 = CFrame.identity;
        end;
    else
        v38 = CFrame.identity;
    end;

    local LookVector = HumanoidRootPart.CFrame.LookVector;
    local v39 = Vector3.new(LookVector.X, 0, LookVector.Z);

    if v39.Magnitude >= 0.001 then
        LookVector = v39;
    end;

    local v40 = Head.Position + Vector3.new(0, p37 * 1 + 1, 0);
    p33:PivotTo(CFrame.lookAt(v40, v40 + LookVector) * v38);
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p34;
    WeldConstraint.Part1 = HumanoidRootPart;
    WeldConstraint.Parent = p34;
end;

function v1.SpawnHandle(u41, u42, p43) -- Line: 255
    -- upvalues: u4 (copy), Assets (copy), PetModules (copy), u7 (copy), PetSizes (copy), LocalPlayer (copy), ButterflyWingColors (copy), PetTypes (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u42] then
        return;
    end;

    u4[u42] = true;
    u41:ClearHandle(u42);
    local v44 = p43:FindFirstChild("Right Arm") or p43:FindFirstChild("RightHand");

    if not v44 then
        u4[u42] = nil;

        return;
    end;

    local v45 = u42:GetAttribute("Pet");

    if type(v45) ~= "string" or v45 == "" then
        u4[u42] = nil;

        return;
    end;

    local Pets = Assets:FindFirstChild("Pets");
    local v46 = Pets and Pets:FindFirstChild(v45) or Assets:FindFirstChild(v45);

    if not (v46 and v46:IsA("Model")) then
        u4[u42] = nil;

        return;
    end;

    local v47 = PetModules[v45];
    local v48;

    if v47 then
        local HandGrip = v47.HandGrip;

        if typeof(HandGrip) == "Vector3" then
            v48 = CFrame.fromOrientation(math.rad(HandGrip.X), math.rad(HandGrip.Y), (math.rad(HandGrip.Z)));
        else
            v48 = u7;
        end;
    else
        v48 = u7;
    end;

    local v49 = PetSizes.Normalize(u42:GetAttribute("PetSize")) ~= nil;
    local v50 = v46:Clone();
    local v51 = PetSizes.GetScale(u42:GetAttribute("PetSize"), v47 and {
        Big = v47.BigScale,
        Huge = v47.HugeScale
    } or nil);

    if v51 ~= 1 then
        v50:ScaleTo(v51);
    end;

    u41:DisableVFX(v50);
    local v52 = LocalPlayer and LocalPlayer.Character == p43;
    local PrimaryPart = v50.PrimaryPart;

    if not PrimaryPart then
        v50:Destroy();
        u4[u42] = nil;

        return;
    end;

    for _, descendant in v50:GetDescendants() do
        if descendant:IsA("BasePart") then
            u41:PreparePartForTool(descendant);
        end;
    end;

    ButterflyWingColors.ApplyToModel(v50, u42:GetAttribute("PetId"));
    local v53 = v50:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController");
    local u54 = v53:FindFirstChildOfClass("Animator");

    if not u54 then
        u54 = Instance.new("Animator");
        u54.Parent = v53;
    end;

    local u55 = nil;
    local v56;

    if v47 then
        v56 = v47.Animations;
    else
        v56 = v47;
    end;

    local v57;

    if type(v56) == "table" then
        local HeldAnimation = v47.HeldAnimation;

        if type(HeldAnimation) == "string" and v56[HeldAnimation] then
            v57 = v56[HeldAnimation];
        elseif v47.IsFlying then
            v57 = v56.Fly or v56.Idle;
        else
            v57 = v56.Idle;
        end;
    else
        v57 = nil;
    end;

    if v57 then
        local Animations = v50:FindFirstChild("Animations");

        if Animations then
            u55 = Animations:FindFirstChild(v57);
        end;

        u55 = u55 or v50:FindFirstChild(v57);
    end;

    v53.Parent = v50;

    if v49 then
        v50.Name = "Build";
        v50.Parent = u42;
        local Part = Instance.new("Part");
        Part.Name = "Handle";
        Part.Size = Vector3.new(1, 1, 1);
        Part.Transparency = 1;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Massless = true;
        Part.Parent = u42;
        u41:PlaceAboveHead(v50, PrimaryPart, p43, v47, v51);
    else
        v50.Name = "Build";
        v50.Parent = u42;
        PrimaryPart.Name = "Handle";
        PrimaryPart.Parent = u42;
        u42.Grip = v48;

        if not v52 then
            local Motor6D = Instance.new("Motor6D");
            Motor6D.Name = "RightGrip";
            Motor6D.Part0 = v44;
            Motor6D.Part1 = PrimaryPart;
            Motor6D.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);
            Motor6D.C1 = CFrame.new(0, 0, 0) * v48;
            Motor6D.Parent = v44;
        end;
    end;

    if u55 and u55:IsA("Animation") then
        local success, result = pcall(function() -- Line: 394
            -- upvalues: u54 (ref), u55 (ref)
            return u54:LoadAnimation(u55);
        end);

        if success and result then
            result.Looped = true;
            result:Play(0);
        end;
    end;

    if u42:GetAttribute("PetType") == PetTypes.Rainbow and not u42:HasTag("PetRainbow") then
        u42:AddTag("PetRainbow");
    end;

    local Handle = u42:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u42, Handle, function() -- Line: 414
            -- upvalues: u3 (ref), u42 (copy)
            return u3[u42];
        end, function() -- Line: 415
            -- upvalues: u41 (copy), u42 (copy)
            return u41:HasHandle(u42);
        end, function() -- Line: 416
            -- upvalues: u3 (ref), u42 (copy), u41 (copy)
            local v58 = u3[u42];

            if v58 then
                u41:SpawnHandle(u42, v58);
            end;
        end);
    end;

    if p43:GetAttribute("Invisible") == true then
        u41:ApplyToolInvisibility(u42, true);
    end;

    u4[u42] = nil;
end;

function v1.UpdateToolState(p59, p60) -- Line: 430
    -- upvalues: u4 (copy), u3 (copy), LocalPlayer (copy), PetSizes (copy), u6 (ref), PlayPetCarry (copy), u5 (ref)
    if u4[p60] then
        return;
    end;

    local v61 = u3[p60];

    if not v61 then
        return;
    end;

    local v62 = p60.Parent == v61;
    local v63 = p59:HasHandle(p60);

    if v62 and not v63 then
        p59:SpawnHandle(p60, v61);
    elseif not v62 and v63 then
        p59:ClearHandle(p60);
    end;

    if not v62 or (v61 ~= LocalPlayer.Character or PetSizes.Normalize(p60:GetAttribute("PetSize")) == nil) then
        if u6 == p60 then
            u6 = nil;

            if u5 and u5.IsPlaying then
                u5:Stop();
            end;
        end;

        return;
    end;

    u6 = p60;
    PlayPetCarry();
end;

function v1.DisconnectTool(p64, p65) -- Line: 456
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v66 = u2[p65];

    if v66 then
        for _, v in v66 do
            v:Disconnect();
        end;

        u2[p65] = nil;
    end;

    u3[p65] = nil;
    u4[p65] = nil;
end;

function v1.CleanupTool(p67, p68) -- Line: 468
    -- upvalues: u6 (ref), u5 (ref)
    if u6 == p68 then
        u6 = nil;

        if u5 and u5.IsPlaying then
            u5:Stop();
        end;
    end;

    p67:ClearHandle(p68);
    p67:DisconnectTool(p68);
end;

function v1.IsTrackedTool(p69, p70) -- Line: 477
    local v71 = p70:GetAttribute("Pet");
    local v72;

    if type(v71) == "string" then
        v72 = v71 ~= "";
    else
        v72 = false;
    end;

    return v72;
end;

function v1.SetupTool(u73, u74, p75) -- Line: 482
    -- upvalues: u3 (copy), Networking (copy), u2 (copy)
    u73:DisconnectTool(u74);
    local v76 = {};
    u3[u74] = p75;
    local v77 = u74:GetPropertyChangedSignal("Parent");
    table.insert(v76, v77:Connect(function() -- Line: 488
        -- upvalues: u74 (copy), u3 (ref), u73 (copy)
        task.defer(function() -- Line: 489
            -- upvalues: u74 (ref), u3 (ref), u73 (ref)
            if u74 and u3[u74] then
                u73:UpdateToolState(u74);
            end;
        end);
    end));
    local u78 = u74:GetAttribute("PetId");

    if type(u78) == "string" and u78 ~= "" then
        table.insert(v76, u74.Activated:Connect(function() -- Line: 502
            -- upvalues: Networking (ref), u78 (copy)
            Networking.Pets.RequestToggleFollower:Fire(u78);
        end));
    end;

    u2[u74] = v76;
    task.defer(function() -- Line: 509
        -- upvalues: u74 (copy), u3 (ref), u73 (copy)
        if u74 and u3[u74] then
            u73:UpdateToolState(u74);
        end;
    end);
end;

function v1.SetupCharacter(u79, u80) -- Line: 516
    -- upvalues: Players (copy), u2 (copy), u3 (copy)
    task.defer(function() -- Line: 517
        -- upvalues: u80 (copy), Players (ref), u79 (copy), u2 (ref), u3 (ref)
        if not (u80 and u80.Parent) then
            return;
        end;

        local v81 = Players:GetPlayerFromCharacter(u80);

        for _, child in u80:GetChildren() do
            if child:IsA("Tool") and u79:IsTrackedTool(child) then
                u79:SetupTool(child, u80);
            end;
        end;

        if v81 and v81.Backpack then
            for _, child in v81.Backpack:GetChildren() do
                if child:IsA("Tool") and u79:IsTrackedTool(child) then
                    u79:SetupTool(child, u80);
                end;
            end;
        end;

        u80.ChildAdded:Connect(function(u82) -- Line: 537
            -- upvalues: u79 (ref), u80 (ref)
            if u82:IsA("Tool") and u79:IsTrackedTool(u82) then
                task.defer(function() -- Line: 539
                    -- upvalues: u82 (copy), u80 (ref), u79 (ref)
                    if u82 and (u82.Parent and (u80 and u80.Parent)) then
                        u79:SetupTool(u82, u80);
                    end;
                end);
            end;
        end);
        u80:GetAttributeChangedSignal("Invisible"):Connect(function() -- Line: 551
            -- upvalues: u80 (ref), u2 (ref), u3 (ref), u79 (ref)
            local v83 = u80:GetAttribute("Invisible") == true;

            for i in u2 do
                if u3[i] == u80 and i.Parent == u80 then
                    u79:ApplyToolInvisibility(i, v83);
                end;
            end;
        end);
    end);
end;

function v1.SetupPlayer(u84, u85) -- Line: 562
    -- upvalues: LocalPlayer (copy), u5 (ref), u6 (ref), BackpackListener (copy)
    if u85.Character then
        u84:SetupCharacter(u85.Character);
    end;

    u85.CharacterAdded:Connect(function(p86) -- Line: 567
        -- upvalues: u85 (copy), LocalPlayer (ref), u5 (ref), u6 (ref), u84 (copy)
        if u85 == LocalPlayer then
            u5 = nil;
            u6 = nil;
        end;

        u84:SetupCharacter(p86);
    end);
    BackpackListener.bind(u85, function(u87) -- Line: 577
        -- upvalues: u84 (copy), u85 (copy)
        if u87:IsA("Tool") and u84:IsTrackedTool(u87) then
            task.defer(function() -- Line: 579
                -- upvalues: u85 (ref), u87 (copy), u84 (ref)
                local Character = u85.Character;

                if u87 and (u87.Parent and (Character and Character.Parent)) then
                    u84:SetupTool(u87, Character);
                end;
            end);
        end;
    end);
end;

return v1;