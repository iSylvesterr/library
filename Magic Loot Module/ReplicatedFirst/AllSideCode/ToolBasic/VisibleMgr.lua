-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local u1 = {};

local function _setLastTransparency(p2) -- Line: 65
    if p2:GetAttribute("LastTransparency") == nil then
        p2:SetAttribute("LastTransparency", p2.Transparency);
    end;
end;

local function _getRelativePath(p3, p4) -- Line: 78
    local v5 = {};

    while p4 and p4 ~= p3 do
        table.insert(v5, 1, p4.Name);
        p4 = p4.Parent;
    end;

    if p4 == p3 then
        return table.concat(v5, "/");
    end;

    return nil;
end;

local function _findByRelativePath(p6, p7) -- Line: 98
    if p7 == "" then
        return p6;
    end;

    for i in string.gmatch(p7, "[^/]+") do
        p6 = p6:FindFirstChild(i);

        if not p6 then
            return nil;
        end;
    end;

    return p6;
end;

local function _hasTransparencyProperty(p8) -- Line: 116
    return p8:IsA("BasePart") or (p8:IsA("Decal") or p8:IsA("Texture"));
end;

local function _hasEnabledProperty(p9) -- Line: 123
    return p9:IsA("ParticleEmitter") or p9:IsA("Trail") or (p9:IsA("Beam") or p9:IsA("SurfaceGui")) or (p9:IsA("BillboardGui") or p9:IsA("PointLight") or (p9:IsA("ProximityPrompt") or p9:IsA("RopeConstraint")));
end;

local function _captureInitVisualAttributes(p10, p11) -- Line: 140
    -- upvalues: _hasEnabledProperty (copy)
    if (p10:IsA("BasePart") or (p10:IsA("Decal") or p10:IsA("Texture"))) and (p11 or p10:GetAttribute("InitTransparency") == nil) then
        p10:SetAttribute("InitTransparency", p10.Transparency);
    end;

    if _hasEnabledProperty(p10) and (p11 or p10:GetAttribute("InitEnabled") == nil) then
        p10:SetAttribute("InitEnabled", p10.Enabled);
    end;
end;

local function _copyInitVisualAttributes(p12, p13) -- Line: 159
    local v14 = p12:GetAttribute("InitTransparency");

    if v14 ~= nil then
        p13:SetAttribute("InitTransparency", v14);
    end;

    local v15 = p12:GetAttribute("InitEnabled");

    if v15 ~= nil then
        p13:SetAttribute("InitEnabled", v15);
    end;
end;

local function _restoreInitVisualProperties(p16) -- Line: 175
    -- upvalues: _hasEnabledProperty (copy)
    if p16:IsA("BasePart") or (p16:IsA("Decal") or p16:IsA("Texture")) then
        local v17 = p16:GetAttribute("InitTransparency");

        if v17 ~= nil then
            p16.Transparency = v17;
        end;
    end;

    if _hasEnabledProperty(p16) then
        local v18 = p16:GetAttribute("InitEnabled");

        if v18 ~= nil then
            p16.Enabled = v18;
        end;
    end;
end;

local function _shouldStopParticleLoop(p19) -- Line: 196
    local Parent = p19.Parent;

    if not Parent then
        return true;
    end;

    local Parent2 = Parent.Parent;

    if not Parent2 then
        return false;
    end;

    local Parent3 = Parent2.Parent;
    local v20;

    if Parent3 == nil then
        v20 = false;
    else
        v20 = Parent3:IsA("Folder");
    end;

    return v20;
end;

local function _runParticleColorLoop(u21, u22, u23) -- Line: 216
    -- upvalues: RunService (copy)
    task.spawn(function() -- Line: 221
        -- upvalues: u21 (copy), u22 (copy), u23 (copy), RunService (ref)
        while u21.Parent do
            local Parent = u21.Parent;
            local v24;

            if Parent then
                local Parent2 = Parent.Parent;

                if Parent2 then
                    local Parent3 = Parent2.Parent;

                    if Parent3 == nil then
                        v24 = false;
                    else
                        v24 = Parent3:IsA("Folder");
                    end;
                else
                    v24 = false;
                end;
            else
                v24 = true;
            end;

            if v24 then
                return;
            end;

            u21.Color = u23(os.clock() * 0.1 * u22 % 1);
            RunService.Heartbeat:Wait();
        end;
    end);
end;

local function _forEachInSubtree(p25, p26) -- Line: 239
    p26(p25);

    for _, descendant in p25:GetDescendants() do
        p26(descendant);
    end;
end;

function u1.CloseShade(p27) -- Line: 255
    if not p27 then
        return;
    end;

    for _, descendant in pairs(p27:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CastShadow = false;
        end;
    end;
end;

function u1.OpenShade(p28) -- Line: 272
    if not p28 then
        return;
    end;

    for _, descendant in pairs(p28:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CastShadow = true;
        end;
    end;
end;

function u1.DisableTrail(p29) -- Line: 289
    if not p29 then
        return;
    end;

    for _, descendant in pairs(p29:GetDescendants()) do
        if descendant:IsA("Trail") then
            descendant.Enabled = false;
        end;
    end;
end;

function u1.DisableProximityPrompt(p30) -- Line: 306
    if not p30 then
        return;
    end;

    for _, descendant in pairs(p30:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            descendant.Enabled = false;
        end;
    end;
end;

function u1.DisableParticle(p31) -- Line: 323
    if not p31 then
        return;
    end;

    for _, descendant in pairs(p31:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;
    end;
end;

function u1.MasslessAll(p32) -- Line: 345
    -- upvalues: u1 (copy)
    if p32:IsA("BasePart") then
        p32.Massless = true;
    end;

    for _, child in pairs(p32:GetChildren()) do
        u1.MasslessAll(child);
    end;
end;

function u1.PrepareModelForAttach(p33) -- Line: 360
    -- upvalues: u1 (copy)
    u1.UnAnchoredAll(p33);
    u1.UnCollideAll(p33);
    u1.UnTouchAll(p33);
    u1.UnQueryAll(p33);
    u1.MasslessAll(p33);

    return nil;
end;

function u1.UnQueryAll(p34) -- Line: 374
    -- upvalues: u1 (copy)
    if p34:IsA("BasePart") then
        p34.CanQuery = false;
    end;

    for _, child in pairs(p34:GetChildren()) do
        u1.UnQueryAll(child);
    end;
end;

function u1.UnAnchoredAll(p35) -- Line: 388
    -- upvalues: u1 (copy)
    if p35:IsA("BasePart") then
        p35.Anchored = false;
    end;

    for _, child in pairs(p35:GetChildren()) do
        u1.UnAnchoredAll(child);
    end;
end;

function u1.AnchoredAll(p36) -- Line: 402
    -- upvalues: u1 (copy)
    if p36:IsA("BasePart") then
        p36.Anchored = true;
    end;

    for _, child in pairs(p36:GetChildren()) do
        u1.AnchoredAll(child);
    end;
end;

function u1.SetStandinTransparency(p37) -- Line: 420
    local v38 = { "LeftUpperLeg", "LowerTorso", "RightUpperLeg" };
    local v39 = { "LeftFoot", "LeftLowerLeg", "RightFoot", "RightLowerLeg" };

    for _, v in pairs({ "LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "Head" }) do
        local v40 = p37:FindFirstChild(v);

        if v40 and v40:IsA("BasePart") then
            v40.Transparency = 1 - (1 - v40.Transparency) * 1;
        end;
    end;

    for _, v in pairs(v38) do
        local v41 = p37:FindFirstChild(v);

        if v41 and v41:IsA("BasePart") then
            v41.Transparency = 1 - (1 - v41.Transparency) * 0.6;
        end;
    end;

    for _, v in pairs(v39) do
        local v42 = p37:FindFirstChild(v);

        if v42 and v42:IsA("BasePart") then
            v42.Transparency = 1 - (1 - v42.Transparency) * 0.3;
        end;
    end;
end;

function u1.SetTransparency(p43, p44) -- Line: 479
    -- upvalues: u1 (copy)
    local v45 = p44 or 100;

    if p43:IsA("BasePart") then
        p43.Transparency = 1 - (1 - p43.Transparency) * (v45 / 100);
    end;

    for _, child in pairs(p43:GetChildren()) do
        u1.SetTransparency(child, v45);
    end;
end;

function u1.UnTransparencyAll(p46) -- Line: 496
    if p46:IsA("BasePart") then
        p46.Transparency = 1;
    end;

    for _, descendant in pairs(p46:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1;
        end;
    end;
end;

function u1.TransparencyAll(p47) -- Line: 513
    if p47:IsA("BasePart") then
        p47.Transparency = 0;
    end;

    for _, descendant in pairs(p47:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 0;
        end;
    end;
end;

function u1.SpeedDown(p48) -- Line: 534
    for _, descendant in pairs(p48:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end;
end;

function u1.SpeedDownY(p49) -- Line: 548
    for _, descendant in pairs(p49:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.AssemblyLinearVelocity = Vector3.new(0, descendant.AssemblyLinearVelocity.Y, 0);
            descendant.AssemblyAngularVelocity = Vector3.new(0, descendant.AssemblyAngularVelocity.Y, 0);
        end;
    end;
end;

function u1.UnTouchAll(p50) -- Line: 566
    -- upvalues: u1 (copy)
    if p50:IsA("BasePart") then
        p50.CanTouch = false;
    end;

    for _, child in pairs(p50:GetChildren()) do
        u1.UnTouchAll(child);
    end;
end;

function u1.UnCollideAll(p51) -- Line: 580
    -- upvalues: u1 (copy)
    if p51:IsA("BasePart") then
        p51.CanCollide = false;
        p51.CanQuery = false;
    end;

    for _, child in pairs(p51:GetChildren()) do
        u1.UnCollideAll(child);
    end;
end;

function u1.QueryAll(p52) -- Line: 595
    -- upvalues: u1 (copy)
    if p52:IsA("BasePart") then
        p52.CanQuery = true;
    end;

    for _, child in pairs(p52:GetChildren()) do
        u1.QueryAll(child);
    end;
end;

function u1.QueryChildren(p53) -- Line: 609
    if p53:IsA("BasePart") then
        p53.CanQuery = true;
    end;

    for _, child in pairs(p53:GetChildren()) do
        if child:IsA("BasePart") then
            child.CanQuery = true;
        end;
    end;
end;

function u1.CollideAll(p54) -- Line: 625
    -- upvalues: u1 (copy)
    if p54:IsA("BasePart") then
        p54.CanCollide = true;
    end;

    for _, child in pairs(p54:GetChildren()) do
        u1.CollideAll(child);
    end;
end;

function u1.CollideAllR6(p55) -- Line: 640
    if not p55:IsA("Model") then
        return;
    end;

    local Torso = p55:FindFirstChild("Torso");

    if Torso and Torso:IsA("BasePart") then
        Torso.CanCollide = true;
    end;

    local v56 = p55:FindFirstChild("Left Arm");

    if v56 and v56:IsA("BasePart") then
        v56.CanCollide = true;
    end;

    local v57 = p55:FindFirstChild("Right Arm");

    if v57 and v57:IsA("BasePart") then
        v57.CanCollide = true;
    end;

    local v58 = p55:FindFirstChild("Left Leg");

    if v58 and v58:IsA("BasePart") then
        v58.CanCollide = true;
    end;

    local v59 = p55:FindFirstChild("Right Leg");

    if v59 and v59:IsA("BasePart") then
        v59.CanCollide = true;
    end;
end;

local function _getAnimationModule() -- Line: 680
    return require(game.ReplicatedFirst.AllSideCode.UtilsSystem).AnimationModule;
end;

function u1.DieEffectUnHuman(p60) -- Line: 691
    -- upvalues: TweenService (copy)
    if not (p60 and p60:IsA("Model")) then
        return;
    end;

    for _, descendant in p60:GetDescendants() do
        if descendant:IsA("MeshPart") then
            descendant.TextureID = "";
        elseif descendant:IsA("SurfaceAppearance") then
            descendant:Destroy();
        elseif descendant:IsA("Decal") then
            descendant.Transparency = 1;
        end;
    end;

    for _, descendant in p60:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            descendant.Material = Enum.Material.ForceField;
            descendant.Color = Color3.new(1, 1, 1);
            local u61 = TweenService:Create(descendant, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            });
            u61.Completed:Once(function() -- Line: 716
                -- upvalues: u61 (copy)
                u61:Destroy();
            end);
            u61:Play();
        elseif descendant:IsA("Texture") then
            descendant.Transparency = 1;
        end;
    end;
end;

function u1.DieEffect(u62) -- Line: 732
    -- upvalues: u1 (copy)
    if not (u62 and u62:IsA("Model")) then
        return;
    end;

    u1.UnCollideAll(u62);
    local PrimaryPart = u62.PrimaryPart;

    if PrimaryPart then
        PrimaryPart.Anchored = true;
    end;

    local AnimationModule = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).AnimationModule;

    if AnimationModule and AnimationModule.PlayAnimByModel then
        AnimationModule.PlayAnimByModel(u62, "人型死亡R6", 1, nil, nil, nil, 0.2);
    end;

    u62:PivotTo(u62:GetPivot() + Vector3.new(0, 0.5, 0));
    task.delay(1, function() -- Line: 759
        -- upvalues: u62 (copy), u1 (ref)
        if u62.Parent then
            u1.DieEffectUnHuman(u62);
        end;
    end);
end;

function u1.fadeAllTween(p63, p64) -- Line: 776
    -- upvalues: TweenService (copy), u1 (copy)
    local v65 = p64 or 1;

    if p63:IsA("Trail") then
        p63.Enabled = false;
    elseif p63:IsA("RopeConstraint") then
        p63.Enabled = false;
    elseif p63:IsA("SurfaceGui") then
        p63.Enabled = false;
    elseif p63:IsA("PointLight") then
        p63.Enabled = false;
    elseif p63:IsA("ParticleEmitter") then
        p63.Enabled = false;
    elseif p63:IsA("BillboardGui") then
        p63.Enabled = false;
    end;

    if p63:IsA("Texture") then
        if p63:GetAttribute("LastTransparency") == nil then
            p63:SetAttribute("LastTransparency", p63.Transparency);
        end;

        p63.Transparency = v65;
    end;

    if p63:IsA("UnionOperation") or (p63:IsA("Part") or (p63:IsA("MeshPart") or p63:IsA("Decal"))) then
        if p63:GetAttribute("LastTransparency") == nil then
            p63:SetAttribute("LastTransparency", p63.Transparency);
        end;

        TweenService:Create(p63, TweenInfo.new(0.8), {
            Transparency = v65
        }):Play();
    end;

    for _, child in pairs(p63:GetChildren()) do
        u1.fadeAllTween(child, v65);
    end;
end;

function u1.fadeAll(p66, p67) -- Line: 820
    -- upvalues: u1 (copy)
    local v68 = p67 or 1;

    if p66:IsA("Beam") then
        p66.Enabled = false;
    elseif p66:IsA("ProximityPrompt") then
        p66.Enabled = false;
    elseif p66:IsA("Trail") then
        p66.Enabled = false;
    elseif p66:IsA("RopeConstraint") then
        p66.Enabled = false;
    elseif p66:IsA("SurfaceGui") then
        p66.Enabled = false;
    elseif p66:IsA("PointLight") then
        p66.Enabled = false;
    elseif p66:IsA("ParticleEmitter") then
        p66.Enabled = false;
    elseif p66:IsA("BillboardGui") then
        p66.Enabled = false;
    end;

    if p66:IsA("Texture") then
        if p66:GetAttribute("LastTransparency") == nil then
            p66:SetAttribute("LastTransparency", p66.Transparency);
        end;

        p66.Transparency = v68;
    end;

    if p66:IsA("UnionOperation") or (p66:IsA("Part") or p66:IsA("MeshPart")) then
        if p66:GetAttribute("LastTransparency") == nil then
            p66:SetAttribute("LastTransparency", p66.Transparency);
        end;

        p66.Transparency = v68;
    end;

    if p66:IsA("Decal") then
        if p66:GetAttribute("LastTransparency") == nil then
            p66:SetAttribute("LastTransparency", p66.Transparency);
        end;

        p66.Transparency = v68;
    end;

    for _, child in pairs(p66:GetChildren()) do
        u1.fadeAll(child, v68);
    end;
end;

function u1.showAll(p69) -- Line: 873
    -- upvalues: u1 (copy)
    if p69:IsA("Beam") then
        p69.Enabled = true;
    elseif p69:IsA("ProximityPrompt") then
        p69.Enabled = true;
    elseif p69:IsA("Trail") then
        p69.Enabled = true;
    elseif p69:IsA("RopeConstraint") then
        p69.Enabled = true;
    elseif p69:IsA("SurfaceGui") then
        p69.Enabled = true;
    elseif p69:IsA("PointLight") then
        p69.Enabled = true;
    elseif p69:IsA("ParticleEmitter") then
        p69.Enabled = true;
    elseif p69:IsA("BillboardGui") then
        p69.Enabled = true;
    end;

    if p69:IsA("Texture") then
        if p69:GetAttribute("LastTransparency") == nil then
            p69:SetAttribute("LastTransparency", p69.Transparency);
        end;

        local v70 = p69:GetAttribute("LastTransparency");

        if v70 then
            p69.Transparency = v70;
        else
            p69.Transparency = 0;
        end;
    end;

    if p69:IsA("UnionOperation") or (p69:IsA("Part") or p69:IsA("MeshPart")) then
        if p69.Name ~= "touchPart" and (p69.Name ~= "HumanoidRootPart" and (p69.Name ~= "灯光" and p69.Name ~= "碰撞体")) then
            if p69:GetAttribute("LastTransparency") == nil then
                p69:SetAttribute("LastTransparency", p69.Transparency);
            end;

            local v71 = p69:GetAttribute("LastTransparency");

            if v71 then
                p69.Transparency = v71;
            else
                p69.Transparency = 0;
            end;
        end;
    elseif p69:IsA("Decal") then
        if p69:GetAttribute("LastTransparency") == nil then
            p69:SetAttribute("LastTransparency", p69.Transparency);
        end;

        local v72 = p69:GetAttribute("LastTransparency");

        if v72 then
            p69.Transparency = v72;
        else
            p69.Transparency = 0;
        end;
    end;

    for _, child in pairs(p69:GetChildren()) do
        u1.showAll(child);
    end;
end;

function u1.SetPetMass(p73) -- Line: 941
    -- upvalues: u1 (copy)
    if p73:IsA("BasePart") then
        p73.CanCollide = false;
        p73.CanTouch = false;
        p73.Massless = true;
    end;

    for _, child in pairs(p73:GetChildren()) do
        u1.SetPetMass(child);
    end;
end;

function u1.AddItemType(p74, p75) -- Line: 958
    -- upvalues: u1 (copy)
    p74:SetAttribute("type", p75);

    for _, child in pairs(p74:GetChildren()) do
        u1.AddItemType(child, p75);
    end;
end;

function u1.SetOnlyID(p76, p77) -- Line: 971
    p76:SetAttribute("onlyID", p77);
end;

function u1.GetOnlyID(p78) -- Line: 981
    return p78:GetAttribute("onlyID");
end;

function u1.AddOwnerID(p79, p80) -- Line: 991
    -- upvalues: u1 (copy)
    p79:SetAttribute("OwnerID", p80);

    for _, child in pairs(p79:GetChildren()) do
        u1.AddOwnerID(child, p80);
    end;
end;

function u1.SetCollideID(p81, p82) -- Line: 1008
    -- upvalues: u1 (copy)
    if p81:IsA("BasePart") then
        p81.CollisionGroup = p82;
    end;

    for _, child in pairs(p81:GetChildren()) do
        u1.SetCollideID(child, p82);
    end;
end;

function u1.SetPlayerCollideID(p83) -- Line: 1022
    -- upvalues: u1 (copy)
    if not p83 then
        return;
    end;

    if p83:IsA("BasePart") then
        p83.CollisionGroup = "Player";
    end;

    for _, child in pairs(p83:GetChildren()) do
        u1.SetPlayerCollideID(child);
    end;
end;

function u1.SetCollideIDDefault(p84) -- Line: 1040
    -- upvalues: u1 (copy)
    if not p84 then
        return;
    end;

    if p84:IsA("BasePart") then
        p84.CollisionGroup = "Default";
    end;

    for _, child in pairs(p84:GetChildren()) do
        u1.SetCollideIDDefault(child);
    end;
end;

function u1.Weld(p85, p86) -- Line: 1060
    if not p86 then
        return;
    end;

    if p85:IsA("Model") then
        for _, descendant in pairs(p85:GetDescendants()) do
            if descendant:IsA("BasePart") then
                local WeldConstraint = Instance.new("WeldConstraint", descendant);
                WeldConstraint.Part0 = descendant;
                WeldConstraint.Part1 = p86;
            end;
        end;

        return;
    end;

    if p85:IsA("BasePart") then
        local WeldConstraint = Instance.new("WeldConstraint", p85);
        WeldConstraint.Part0 = p85;
        WeldConstraint.Part1 = p86;
    end;
end;

function u1.SelfWeld(p87) -- Line: 1086
    local PrimaryPart = p87.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    for _, descendant in pairs(p87:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local Weld = Instance.new("Weld", descendant);
            Weld.Part0 = PrimaryPart;
            Weld.Part1 = descendant;
            Weld.C1 = descendant.CFrame:Inverse() * PrimaryPart.CFrame * Weld.C0;
        end;
    end;
end;

function u1.RainBowParticle(u88, p89) -- Line: 1109
    -- upvalues: RunService (copy)
    local u90 = p89 or 1;

    local function u93(p91) -- Line: 1111
        local v92 = {};

        for i = 0, 1, 0.1 do
            table.insert(v92, ColorSequenceKeypoint.new(i, Color3.fromHSV((p91 + i * 0.6) % 1, 0.8, 1)));
        end;

        return ColorSequence.new(v92);
    end;

    task.spawn(function() -- Line: 221
        -- upvalues: u88 (copy), u90 (copy), u93 (copy), RunService (ref)
        while u88.Parent do
            local Parent = u88.Parent;
            local v94;

            if Parent then
                local Parent2 = Parent.Parent;

                if Parent2 then
                    local Parent3 = Parent2.Parent;

                    if Parent3 == nil then
                        v94 = false;
                    else
                        v94 = Parent3:IsA("Folder");
                    end;
                else
                    v94 = false;
                end;
            else
                v94 = true;
            end;

            if v94 then
                return;
            end;

            u88.Color = u93(os.clock() * 0.1 * u90 % 1);
            RunService.Heartbeat:Wait();
        end;
    end);
end;

function u1.SecretParticle(u95, p96) -- Line: 1130
    -- upvalues: RunService (copy)
    local u97 = p96 or 1;

    local function u101(p98) -- Line: 1132
        local v99 = {};

        for i = 0, 1, 0.1 do
            local v100 = (p98 + i * 0.6) % 1;
            table.insert(v99, ColorSequenceKeypoint.new(i, Color3.fromHSV(v100, v100, v100 % 0.3)));
        end;

        return ColorSequence.new(v99);
    end;

    task.spawn(function() -- Line: 221
        -- upvalues: u95 (copy), u97 (copy), u101 (copy), RunService (ref)
        while u95.Parent do
            local Parent = u95.Parent;
            local v102;

            if Parent then
                local Parent2 = Parent.Parent;

                if Parent2 then
                    local Parent3 = Parent2.Parent;

                    if Parent3 == nil then
                        v102 = false;
                    else
                        v102 = Parent3:IsA("Folder");
                    end;
                else
                    v102 = false;
                end;
            else
                v102 = true;
            end;

            if v102 then
                return;
            end;

            u95.Color = u101(os.clock() * 0.1 * u97 % 1);
            RunService.Heartbeat:Wait();
        end;
    end);
end;

function u1.FadeCharacterModel(p103, p104, p105, p106, p107) -- Line: 1154
    -- upvalues: TweenService (copy)
    if not (p103 and p103.Parent) then
        return;
    end;

    local u108 = p104 or 1;
    local u109 = TweenInfo.new(p105 or 0.5, p106 or Enum.EasingStyle.Quad, p107 or Enum.EasingDirection.Out);

    local function fadeDescendant(p110) -- Line: 1169
        -- upvalues: TweenService (ref), u109 (copy), u108 (ref)
        if p110.Name == "HumanoidRootPart" then
            return;
        end;

        if p110:IsA("ParticleEmitter") then
            if not p110:GetAttribute("WasEnabled") then
                p110:SetAttribute("WasEnabled", p110.Enabled);
            end;

            p110.Enabled = false;

            return;
        end;

        if p110:IsA("Trail") then
            if not p110:GetAttribute("WasEnabled") then
                p110:SetAttribute("WasEnabled", p110.Enabled);
            end;

            p110.Enabled = false;

            return;
        end;

        if p110:IsA("Beam") then
            if not p110:GetAttribute("WasEnabled") then
                p110:SetAttribute("WasEnabled", p110.Enabled);
            end;

            p110.Enabled = false;

            return;
        end;

        if p110:IsA("SurfaceGui") then
            if not p110:GetAttribute("WasEnabled") then
                p110:SetAttribute("WasEnabled", p110.Enabled);
            end;

            p110.Enabled = false;

            return;
        end;

        if p110:IsA("BillboardGui") then
            if not p110:GetAttribute("WasEnabled") then
                p110:SetAttribute("WasEnabled", p110.Enabled);
            end;

            p110.Enabled = false;

            return;
        end;

        if p110:IsA("BasePart") or (p110:IsA("UnionOperation") or p110:IsA("MeshPart")) then
            if p110:GetAttribute("LastTransparency") == nil then
                p110:SetAttribute("LastTransparency", p110.Transparency);
            end;

            TweenService:Create(p110, u109, {
                Transparency = u108
            }):Play();

            return;
        end;

        if not p110:IsA("Decal") then
            if p110:IsA("Texture") then
                if p110:GetAttribute("LastTransparency") == nil then
                    p110:SetAttribute("LastTransparency", p110.Transparency);
                end;

                TweenService:Create(p110, u109, {
                    Transparency = u108
                }):Play();
            end;

            return;
        end;

        if p110:GetAttribute("LastTransparency") == nil then
            p110:SetAttribute("LastTransparency", p110.Transparency);
        end;

        TweenService:Create(p110, u109, {
            Transparency = u108
        }):Play();
    end;

    for _, descendant in pairs(p103:GetDescendants()) do
        fadeDescendant(descendant);
    end;
end;

function u1.UnFadeCharacterModel(p111, p112, p113, p114) -- Line: 1235
    -- upvalues: TweenService (copy)
    if not (p111 and p111.Parent) then
        return;
    end;

    local u115 = TweenInfo.new(p112 or 0.5, p113 or Enum.EasingStyle.Quad, p114 or Enum.EasingDirection.Out);

    local function unfadeDescendant(p116) -- Line: 1249
        -- upvalues: TweenService (ref), u115 (copy)
        if p116.Name == "HumanoidRootPart" then
            return;
        end;

        if p116:IsA("ParticleEmitter") then
            local v117 = p116:GetAttribute("WasEnabled");

            if v117 ~= nil then
                p116.Enabled = v117;
                p116:SetAttribute("WasEnabled", nil);
            end;
        elseif p116:IsA("Trail") then
            local v118 = p116:GetAttribute("WasEnabled");

            if v118 ~= nil then
                p116.Enabled = v118;
                p116:SetAttribute("WasEnabled", nil);
            end;
        elseif p116:IsA("Beam") then
            local v119 = p116:GetAttribute("WasEnabled");

            if v119 ~= nil then
                p116.Enabled = v119;
                p116:SetAttribute("WasEnabled", nil);
            end;
        elseif p116:IsA("SurfaceGui") then
            local v120 = p116:GetAttribute("WasEnabled");

            if v120 ~= nil then
                p116.Enabled = v120;
                p116:SetAttribute("WasEnabled", nil);
            end;
        elseif p116:IsA("BillboardGui") then
            local v121 = p116:GetAttribute("WasEnabled");

            if v121 ~= nil then
                p116.Enabled = v121;
                p116:SetAttribute("WasEnabled", nil);
            end;
        else
            if p116:IsA("BasePart") or (p116:IsA("UnionOperation") or p116:IsA("MeshPart")) then
                local v122 = p116:GetAttribute("LastTransparency");

                if v122 == nil then
                    TweenService:Create(p116, u115, {
                        Transparency = 0
                    }):Play();

                    return;
                end;

                TweenService:Create(p116, u115, {
                    Transparency = v122
                }):Play();

                return;
            end;

            if p116:IsA("Decal") then
                local v123 = p116:GetAttribute("LastTransparency");

                if v123 == nil then
                    TweenService:Create(p116, u115, {
                        Transparency = 0
                    }):Play();

                    return;
                end;

                TweenService:Create(p116, u115, {
                    Transparency = v123
                }):Play();

                return;
            end;

            if p116:IsA("Texture") then
                local v124 = p116:GetAttribute("LastTransparency");

                if v124 ~= nil then
                    TweenService:Create(p116, u115, {
                        Transparency = v124
                    }):Play();

                    return;
                end;

                TweenService:Create(p116, u115, {
                    Transparency = 0
                }):Play();
            end;
        end;
    end;

    for _, descendant in pairs(p111:GetDescendants()) do
        unfadeDescendant(descendant);
    end;
end;

local function _hideCharacterModelLocal(p125, p126) -- Line: 1331
    for _, descendant in p125:GetDescendants() do
        if descendant:IsA("BasePart") then
            if p126.partLtm[descendant] == nil then
                p126.partLtm[descendant] = descendant.LocalTransparencyModifier;
            end;

            descendant.LocalTransparencyModifier = 1;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            if p126.decalTrans[descendant] == nil then
                p126.decalTrans[descendant] = descendant.Transparency;
            end;

            descendant.Transparency = 1;
        elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            if p126.fxEnabled[descendant] == nil then
                p126.fxEnabled[descendant] = descendant.Enabled;
            end;

            descendant.Enabled = false;
        elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
            if p126.guiEnabled[descendant] == nil then
                p126.guiEnabled[descendant] = descendant.Enabled;
            end;

            descendant.Enabled = false;
        end;
    end;
end;

function u1.HideOtherPlayersLocal() -- Line: 1369
    -- upvalues: RunService (copy), Players (copy), _hideCharacterModelLocal (copy)
    if not RunService:IsClient() then
        return nil;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local v127 = {
        partLtm = {},
        decalTrans = {},
        fxEnabled = {},
        guiEnabled = {}
    };

    for _, v in Players:GetPlayers() do
        if v ~= LocalPlayer then
            local Character = v.Character;

            if Character and Character.Parent then
                _hideCharacterModelLocal(Character, v127);
            end;
        end;
    end;

    return v127;
end;

function u1.RestoreOtherPlayersLocal(p128) -- Line: 1400
    if type(p128) ~= "table" then
        return;
    end;

    local partLtm = p128.partLtm;

    if type(partLtm) == "table" then
        for i, v in pairs(partLtm) do
            if typeof(i) == "Instance" and (i:IsA("BasePart") and i.Parent) then
                i.LocalTransparencyModifier = v;
            end;
        end;
    end;

    local decalTrans = p128.decalTrans;

    if type(decalTrans) == "table" then
        for i, v in pairs(decalTrans) do
            if typeof(i) == "Instance" and (i.Parent and (i:IsA("Decal") or i:IsA("Texture"))) then
                i.Transparency = v;
            end;
        end;
    end;

    local fxEnabled = p128.fxEnabled;

    if type(fxEnabled) == "table" then
        for i, v in pairs(fxEnabled) do
            if typeof(i) == "Instance" and (i.Parent and (i:IsA("ParticleEmitter") or (i:IsA("Trail") or i:IsA("Beam")))) then
                i.Enabled = v;
            end;
        end;
    end;

    local guiEnabled = p128.guiEnabled;

    if type(guiEnabled) == "table" then
        for i, v in pairs(guiEnabled) do
            if typeof(i) == "Instance" and (i.Parent and (i:IsA("BillboardGui") or i:IsA("SurfaceGui"))) then
                i.Enabled = v;
            end;
        end;
    end;
end;

local u129 = {};
local u130 = {};
local u131 = {};
local u132 = {};

function u1.HighLight_FillColor_Blink(p133, p134, p135) -- Line: 1465
    -- upvalues: u131 (copy), u132 (copy), u129 (copy), u130 (copy), TweenService (copy)
    for i, v in pairs(u131) do
        if i == nil or i.Parent == nil then
            local v136 = u132[v];

            if v136 then
                for i2, v2 in pairs(v136) do
                    v2:Disconnect();
                    v136[i2] = nil;
                end;

                u132[v] = nil;
            end;

            local v137 = u129[v];

            if v137 then
                v137:Cancel();
                u129[v] = nil;
            end;

            local v138 = u130[v];

            if v138 then
                v138:Cancel();
                u130[v] = nil;
            end;

            if v then
                v:Destroy();
            end;

            u131[i] = nil;
        end;
    end;

    local u139 = u131[p133];

    if not u139 then
        u139 = Instance.new("Highlight");
        u139.FillTransparency = 1;
        u139.OutlineTransparency = 1;
        u139.Parent = p133;
        u131[p133] = u139;
    end;

    u139.FillColor = p134;
    local v140 = u129[u139];
    local v141 = u130[u139];

    if not u132[u139] then
        u132[u139] = {};
    end;

    if not v141 then
        v141 = TweenService:Create(u139, TweenInfo.new(p135, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            FillTransparency = 1
        });
        table.insert(u132[u139], v141.Completed:Connect(function(p142) -- Line: 1521
            -- upvalues: u139 (ref)
            if p142 == Enum.PlaybackState.Completed then
                u139.FillTransparency = 1;
            end;
        end));
        u130[u139] = v141;
    end;

    if not v140 then
        v140 = TweenService:Create(u139, TweenInfo.new(p135, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            FillTransparency = 0.2
        });
        table.insert(u132[u139], v140.Completed:Connect(function(p143) -- Line: 1537
            -- upvalues: u130 (ref), u139 (ref)
            local v144 = p143 == Enum.PlaybackState.Completed and u130[u139];

            if v144 then
                v144:Play();
            end;
        end));
        u129[u139] = v140;
    end;

    u139.FillTransparency = 1;
    u139.Enabled = true;
    v141:Cancel();
    v140:Cancel();
    v140:Play();
end;

function u1.SnapshotDefaultVisualState(p145) -- Line: 1568
    -- upvalues: _captureInitVisualAttributes (copy)
    if not p145 then
        return;
    end;

    local function _(p146) -- Line: 1572
        -- upvalues: _captureInitVisualAttributes (ref)
        _captureInitVisualAttributes(p146, false);
    end;

    _captureInitVisualAttributes(p145, false);

    for _, descendant in p145:GetDescendants() do
        _captureInitVisualAttributes(descendant, false);
    end;
end;

function u1.SyncDefaultVisualSnapshotFromTemplate(p147, p148) -- Line: 1584
    -- upvalues: u1 (copy), _getRelativePath (copy), _findByRelativePath (copy)
    if not (p147 and p148) then
        return;
    end;

    u1.SnapshotDefaultVisualState(p148);
    local v149 = p148:GetAttribute("InitTransparency");

    if v149 ~= nil then
        p147:SetAttribute("InitTransparency", v149);
    end;

    local v150 = p148:GetAttribute("InitEnabled");

    if v150 ~= nil then
        p147:SetAttribute("InitEnabled", v150);
    end;

    for _, descendant in p148:GetDescendants() do
        local v151 = _getRelativePath(p148, descendant);

        if v151 then
            local v152 = _findByRelativePath(p147, v151);

            if v152 then
                local v153 = descendant:GetAttribute("InitTransparency");

                if v153 ~= nil then
                    v152:SetAttribute("InitTransparency", v153);
                end;

                local v154 = descendant:GetAttribute("InitEnabled");

                if v154 ~= nil then
                    v152:SetAttribute("InitEnabled", v154);
                end;
            end;
        end;
    end;
end;

function u1.RestoreDefaultVisualState(p155) -- Line: 1607
    -- upvalues: _hasEnabledProperty (copy)
    if not p155 then
        return;
    end;

    local function _(p156) -- Line: 1611
        -- upvalues: _hasEnabledProperty (ref)
        if p156:IsA("BasePart") or (p156:IsA("Decal") or p156:IsA("Texture")) then
            local v157 = p156:GetAttribute("InitTransparency");

            if v157 ~= nil then
                p156.Transparency = v157;
            end;
        end;

        if _hasEnabledProperty(p156) then
            local v158 = p156:GetAttribute("InitEnabled");

            if v158 ~= nil then
                p156.Enabled = v158;
            end;
        end;
    end;

    if p155:IsA("BasePart") or (p155:IsA("Decal") or p155:IsA("Texture")) then
        local v159 = p155:GetAttribute("InitTransparency");

        if v159 ~= nil then
            p155.Transparency = v159;
        end;
    end;

    if _hasEnabledProperty(p155) then
        local v160 = p155:GetAttribute("InitEnabled");

        if v160 ~= nil then
            p155.Enabled = v160;
        end;
    end;

    for _, descendant in p155:GetDescendants() do
        if descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
            local v161 = descendant:GetAttribute("InitTransparency");

            if v161 ~= nil then
                descendant.Transparency = v161;
            end;
        end;

        if _hasEnabledProperty(descendant) then
            local v162 = descendant:GetAttribute("InitEnabled");

            if v162 ~= nil then
                descendant.Enabled = v162;
            end;
        end;
    end;
end;

local function _findBridgingConstraints(p163, p164) -- Line: 1627
    local v165 = {};

    for _, descendant in ipairs(p163:GetDescendants()) do
        if descendant:IsA("WeldConstraint") or (descendant:IsA("Weld") or descendant:IsA("Motor6D")) then
            local Part0 = descendant.Part0;
            local Part1 = descendant.Part1;

            if Part0 and (Part1 and (Part0:IsA("BasePart") and (Part1:IsA("BasePart") and Part0:IsDescendantOf(p164) ~= Part1:IsDescendantOf(p164)))) then
                table.insert(v165, descendant);
            end;
        end;
    end;

    return v165;
end;

local function _splitBridgeConstraintSides(p166, p167) -- Line: 1652
    local Part0 = p166.Part0;
    local Part1 = p166.Part1;

    if typeof(Part0) ~= "Instance" or typeof(Part1) ~= "Instance" then
        return nil, nil;
    end;

    if not (Part0:IsA("BasePart") and Part1:IsA("BasePart")) then
        return nil, nil;
    end;

    local v168 = Part0:IsDescendantOf(p167);

    if v168 == Part1:IsDescendantOf(p167) then
        return nil, nil;
    end;

    if v168 then
        return Part0, Part1;
    end;

    return Part1, Part0;
end;

local function _destroyConstraints(p169) -- Line: 1678
    if not p169 then
        return;
    end;

    for _, v in ipairs(p169) do
        if v and v.Parent then
            v:Destroy();
        end;
    end;
end;

local function _restoreBridgeWelds(p170, p171, p172) -- Line: 1697
    if not p170 or (not p171 or (type(p172) ~= "string" or p172 == "")) then
        return;
    end;

    for i, v in ipairs(p171) do
        local anchorPart = v.anchorPart;
        local movingPart = v.movingPart;
        local rel = v.rel;

        if anchorPart and (movingPart and (anchorPart.Parent and (movingPart.Parent and typeof(rel) == "CFrame"))) then
            movingPart.CFrame = anchorPart.CFrame * rel;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Name = i == 1 and p172 and p172 or p172 .. tostring(i);
            WeldConstraint.Part0 = anchorPart;
            WeldConstraint.Part1 = movingPart;
            WeldConstraint.Parent = p170;
        end;
    end;
end;

local function _weldMeshPartsToPrimary(p173, p174, p175, p176) -- Line: 1725
    if not p173 or (not p174 or (not p175 or (type(p176) ~= "string" or p176 == ""))) then
        return 0;
    end;

    local v177 = { p173 };
    local v178 = 1;
    local v179 = 0;

    while v178 <= #v177 do
        local v180 = v177[v178];
        v178 = v178 + 1;

        if v180:IsA("MeshPart") and v180 ~= p174 then
            v179 = v179 + 1;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Name = p176 .. v179;
            WeldConstraint.Part0 = p174;
            WeldConstraint.Part1 = v180;
            WeldConstraint.Parent = p175;
        end;

        for _, child in ipairs(v180:GetChildren()) do
            table.insert(v177, child);
        end;
    end;

    return v179;
end;

local function _destroyWeldsByPrefix(p181, u182) -- Line: 1757
    if not p181 or (type(u182) ~= "string" or u182 == "") then
        return;
    end;

    local u183 = #u182;
    local u184 = {};

    local function consider(p185) -- Line: 1763
        -- upvalues: u183 (copy), u182 (copy), u184 (copy)
        if p185:IsA("WeldConstraint") and string.sub(p185.Name, 1, u183) == u182 then
            table.insert(u184, p185);
        end;
    end;

    if p181:IsA("WeldConstraint") and string.sub(p181.Name, 1, u183) == u182 then
        table.insert(u184, p181);
    end;

    for _, descendant in ipairs(p181:GetDescendants()) do
        if descendant:IsA("WeldConstraint") and string.sub(descendant.Name, 1, u183) == u182 then
            table.insert(u184, descendant);
        end;
    end;

    for _, v in ipairs(u184) do
        v:Destroy();
    end;
end;

local function _getSubtreePrimaryPart(p186, p187) -- Line: 1787
    if p186:IsA("Model") then
        local PrimaryPart = p186.PrimaryPart;

        if PrimaryPart and PrimaryPart:IsA("BasePart") then
            return PrimaryPart;
        end;
    end;

    if p186:IsA("BasePart") then
        return p186;
    end;

    return p187;
end;

local function _destroyChildWeldIfPresent(p188, p189) -- Line: 1807
    if not p188 or (type(p189) ~= "string" or p189 == "") then
        return;
    end;

    local v190 = p188:FindFirstChild(p189);

    if v190 and v190:IsA("WeldConstraint") then
        v190:Destroy();
    end;
end;

local function _applySubtreeRigidDelta(p191, u192) -- Line: 1824
    if not p191 or typeof(u192) ~= "CFrame" then
        return;
    end;

    local function pushPart(p193) -- Line: 1828
        -- upvalues: u192 (copy)
        p193.CFrame = u192 * p193.CFrame;
    end;

    if p191:IsA("BasePart") then
        p191.CFrame = u192 * p191.CFrame;
    end;

    for _, descendant in ipairs(p191:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CFrame = u192 * descendant.CFrame;
        end;
    end;
end;

function u1.BuildBridgeSnapshots(p194, p195) -- Line: 1848
    -- upvalues: _findBridgingConstraints (copy), _splitBridgeConstraintSides (copy)
    local v196 = _findBridgingConstraints(p194, p195);
    local v197 = {};

    for _, v in ipairs(v196) do
        local v198, v199 = _splitBridgeConstraintSides(v, p195);

        if v198 and v199 then
            local v200 = {
                movingPart = v198,
                anchorPart = v199,
                rel = v199.CFrame:ToObjectSpace(v198.CFrame)
            };
            table.insert(v197, v200);
        end;
    end;

    return v197;
end;

function u1.AttachSubtreePrimaryToMount(p201, p202, p203, p204, p205, p206, p207) -- Line: 1876
    -- upvalues: _findBridgingConstraints (copy), _destroyConstraints (copy), _destroyWeldsByPrefix (copy), _applySubtreeRigidDelta (copy), _weldMeshPartsToPrimary (copy)
    if not (p201 and (p202 and (p203 and p203.Parent))) then
        return false;
    end;

    if p202:IsA("Model") then
        local PrimaryPart = p202.PrimaryPart;

        if PrimaryPart and PrimaryPart:IsA("BasePart") then
            p204 = PrimaryPart;
        elseif p202:IsA("BasePart") then
            p204 = p202;
        end;
    elseif p202:IsA("BasePart") then
        p204 = p202;
    end;

    if not (p204 and p204.Parent) then
        return false;
    end;

    local CFrame = p204.CFrame;
    _destroyConstraints((_findBridgingConstraints(p201, p202)));

    if type(p206) == "string" and p206 ~= "" then
        _destroyWeldsByPrefix(p201, p206);
    end;

    _destroyWeldsByPrefix(p201, p205);

    if p201 and (type(p207) == "string" and p207 ~= "") then
        local v208 = p201:FindFirstChild(p207);

        if v208 and v208:IsA("WeldConstraint") then
            v208:Destroy();
        end;
    end;

    _applySubtreeRigidDelta(p202, p203.CFrame * CFrame:Inverse());
    _weldMeshPartsToPrimary(p202, p204, p201, p205);
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Name = p207;
    WeldConstraint.Part0 = p203;
    WeldConstraint.Part1 = p204;
    WeldConstraint.Parent = p201;

    return true;
end;

function u1.RestoreBridgeAndCleanupWelds(p209, p210, p211, p212, p213, p214) -- Line: 1929
    -- upvalues: _destroyWeldsByPrefix (copy), _restoreBridgeWelds (copy)
    if not p209 then
        return;
    end;

    if type(p213) == "string" and p213 ~= "" then
        _destroyWeldsByPrefix(p209, p213);
    end;

    _destroyWeldsByPrefix(p209, p212);

    if p209 and (type(p214) == "string" and p214 ~= "") then
        local v215 = p209:FindFirstChild(p214);

        if v215 and v215:IsA("WeldConstraint") then
            v215:Destroy();
        end;
    end;

    _restoreBridgeWelds(p209, p210, p211);
end;

return u1;