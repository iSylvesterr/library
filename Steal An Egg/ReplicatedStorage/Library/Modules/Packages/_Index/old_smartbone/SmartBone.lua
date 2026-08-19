-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local CollectionService = game:GetService("CollectionService");

if not game:GetService("RunService"):IsClient() then
    warn("Attempted to initialize SmartBone on Server.");

    return nil;
end;

local Dependencies = script:WaitForChild("Dependencies");
local Components = script:WaitForChild("Components");
local Config = require(Dependencies.Config);
local UnitConversion = require(Dependencies.UnitConversion);
local DefaultSettings = require(Dependencies.DefaultSettings);
local ParticleTree = require(Components.ParticleTree);
local Particle = require(Components.Particle);
local SettingsMath = require(Dependencies.SettingsMath);
local Utilities = require(Dependencies.Utilities);
local u1 = Random.new(12098135901304);
local u2 = CollectionService:GetTagged("SmartBone");
local Debug = Config.Debug;
local u3;

if Debug then
    u3 = Instance.new("Model");
    u3.Name = "SMARTBONE_DEBUGFOLDER";
    u3.Parent = workspace;
    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.fromRGB(255, 0, 0);
    Highlight.OutlineTransparency = 1;
    Highlight.FillTransparency = 0;
    Highlight.Parent = u3;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.Enabled = true;
else
    u3 = nil;
end;

local u4 = {};
local u5 = {};
u5.__index = u5;

function u5.new(p6, p7) -- Line: 119
    -- upvalues: u1 (copy), UnitConversion (copy), u5 (copy), DefaultSettings (copy)
    local v8 = {
        Time = 0,
        WindPreviousPosition = Vector3.new(0, 0, 0),
        Removed = false,
        InRange = false,
        ID = u1:NextInteger(1, 10000000),
        RootPart = p6,
        ParticleTrees = {},
        Connections = {},
        RootList = p7,
        ObjectScale = UnitConversion.Convert(math.abs(p6.Size.X), "Millimeter"),
        RemovedEvent = Instance.new("BindableEvent"),
        Settings = {}
    };
    local v9 = setmetatable(v8, u5);

    for i, v in DefaultSettings do
        v9.Settings[i] = p6:GetAttribute(i) or v;
    end;

    v9.Settings.BlendWeight = 1;
    v9.Settings.UpdateRate = math.floor(v9.Settings.UpdateRate + 0.1);
    v9:Init();
    v9:UpdateParameters(v9.Settings);

    return v9;
end;

function u5.Init(u10) -- Line: 150
    -- upvalues: u4 (copy), Lighting (copy)
    local RootPart = u10.RootPart;
    u4[u10.ID] = u10;
    u10.Connections.AttributeChanged = RootPart.AttributeChanged:ConnectParallel(function(p11) -- Line: 157
        -- upvalues: u10 (copy), RootPart (copy)
        if not u10.Settings[p11] then
            return;
        end;

        u10:UpdateParameters(p11, RootPart:GetAttribute(p11));
    end);
    u10.Connections.LightingAttributeChanged = Lighting.AttributeChanged:ConnectParallel(function(p12) -- Line: 164
        -- upvalues: u10 (copy), Lighting (ref)
        if not u10.Settings[p12] then
            return;
        end;

        u10:UpdateParameters(p12, Lighting:GetAttribute(p12));
    end);

    for _, descendant in RootPart:GetDescendants() do
        if descendant:IsA("Bone") and (descendant.Parent:IsA("Bone") and #descendant:GetChildren() == 0) then
            local v13 = descendant.WorldCFrame + descendant.WorldCFrame.UpVector.Unit * (descendant.WorldPosition - descendant.Parent.WorldPosition).Magnitude;
            local Bone = Instance.new("Bone");
            Bone.Parent = descendant;
            Bone.Name = descendant.Name .. "_Tail";
            Bone.WorldCFrame = v13;
        end;
    end;

    for _, v in u10.RootList do
        u10:AppendParticleTree(v);
    end;

    for _, v in u10.ParticleTrees do
        u10:AppendParticles(v, v.Root, 0, 0);
    end;
end;

function u5.AppendParticleTree(p14, p15) -- Line: 191
    -- upvalues: ParticleTree (copy)
    table.insert(p14.ParticleTrees, ParticleTree.new(p15, p14.RootPart, p14.Settings.Gravity));
end;

function u5.AppendParticles(p16, p17, p18, p19, p20) -- Line: 195
    -- upvalues: Particle (copy), Debug (copy), u3 (ref), Utilities (copy)
    local Settings = p16.Settings;
    local v21 = Particle.new(p18, p17.Root, p16.RootPart, Settings);
    local WorldPosition = p18.WorldPosition;
    v21.Position = p18.WorldPosition;
    v21.LastPosition = WorldPosition;
    v21.ParentIndex = p19;
    v21.BoneLength = p20;
    v21.HeirarchyLength = 0;

    if Debug == true then
        v21.DebugPart = Instance.new("Part");
        v21.DebugPart.Size = Vector3.new(0.1, 0.1, 0.1);
        v21.DebugPart.Anchored = true;
        v21.DebugPart.CanCollide = false;
        v21.DebugPart.CastShadow = false;
        v21.DebugPart.CanTouch = false;
        v21.DebugPart.CanQuery = false;
        v21.DebugPart.Color = Color3.fromRGB(255, 0, 0);
        v21.DebugPart.Parent = u3;
    end;

    if p19 >= 1 then
        p20 = (p17.Particles[p19].Bone.WorldPosition - v21.Position).Magnitude;
        v21.BoneLength = p20;
        v21.Weight = p20 * 0.7;
        v21.HeirarchyLength = Utilities.GetHierarchyLength(p18, p17.Root);
    end;

    if v21.HeirarchyLength <= Settings.AnchorDepth then
        v21.Anchored = true;
    end;

    table.insert(p17.Particles, v21);
    local v22 = #p17.Particles;
    local v23 = p18:GetChildren();

    for i = 1, #v23 do
        local v24 = v23[i];

        if v24:IsA("Bone") then
            p16:AppendParticles(p17, v24, v22, p20);
        end;
    end;
end;

function u5.UpdateParameters(p25, p26, p27) -- Line: 240
    -- upvalues: SettingsMath (copy)
    if not p25.Settings[p26] then
        return;
    end;

    local Settings = p25.Settings;

    if SettingsMath[p26] then
        p27 = SettingsMath[p26](p27);
    end;

    Settings[p26] = p27;
end;

function u5.PreUpdate(p28, p29) -- Line: 247
    local RootPart = p29.RootPart;
    local Root = p29.Root;
    p29.ObjectMove = RootPart.Position - p29.ObjectPreviousPosition;
    p29.ObjectPreviousPosition = RootPart.Position;
    p29.RestGravity = Root.CFrame:PointToWorldSpace(p29.LocalGravity);

    for _, v in p29.Particles do
        v.LastTransformOffset = v.TransformOffset;

        if v.Bone == v.Root then
            v.TransformOffset = RootPart.CFrame * v.RootTransform;
        else
            v.TransformOffset = Root.WorldCFrame * v.Transform;
        end;

        v.LocalTransformOffset = Root.CFrame * v.LocalTransform;
    end;
end;

function u5.UpdateParticles(p30, p31, p32, p33) -- Line: 267
    local Settings = p30.Settings;
    local Damping = Settings.Damping;
    local Gravity = Settings.Gravity;
    local Unit = Settings.Gravity.Unit;
    local v34 = p31.RestGravity:Dot(Unit);
    local v35 = (Gravity - Unit * math.max(v34, 0) + Settings.Force) * (p30.ObjectScale * p32);
    local v36 = p33 == 0 and (p31.ObjectMove or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0);

    for _, v in p31.Particles do
        if v.ParentIndex >= 1 and v.Anchored == false then
            local v37;

            if Settings.WindInfluence > 0 then
                local v38 = p31.WindOffset + (os.clock() - v.HeirarchyLength / 5) + (v.TransformOffset.Position - p31.Root.WorldPosition).Magnitude / 5 * Settings.WindInfluence;
                local v39 = Settings.WindDirection.X + Settings.WindDirection.X * math.sin(v38 * Settings.WindSpeed);
                local v40 = Settings.WindDirection.Y + math.sin(v38 * Settings.WindSpeed) * 0.05;
                local v41 = Settings.WindDirection.Z + Settings.WindDirection.X * math.sin(v38 * Settings.WindSpeed);
                v37 = Vector3.new(v39, v40, v41) / v.BoneLength * Settings.WindInfluence * (Settings.WindStrength / 100 * (math.clamp(v.HeirarchyLength, 1, 10) / 10)) * v.Weight;
                p30.WindPreviousPosition = v37;
            else
                v37 = Vector3.new(0, 0, 0);
            end;

            local v42 = v.Position - v.LastPosition;
            local v43 = v36 * Settings.Inertia;
            v.LastPosition = v.Position + v43;
            v.Position = v.Position + (v42 * (1 - Damping) + v35 + v43 + v37);
        else
            v.LastPosition = v.TransformOffset.Position;
            v.Position = v.TransformOffset.Position;
        end;
    end;
end;

function u5.CorrectParticles(p44, p45, p46) -- Line: 331
    local Settings = p44.Settings;
    local Stiffness = Settings.Stiffness;

    for _, v in p45.Particles do
        local v47 = p45.Particles[v.ParentIndex];

        if v47 and (v.ParentIndex >= 1 and v.Anchored == false) then
            local Magnitude = (v47.TransformOffset.Position - v.TransformOffset.Position).Magnitude;

            if Stiffness > 0 or Settings.Elasticity > 0 then
                local Position = (CFrame.new(v47.Position) * v47.TransformOffset.Rotation * CFrame.new(v.LocalTransformOffset.Position)).Position;
                v.Position = v.Position + (Position - v.Position) * (Settings.Elasticity * p46);

                if Stiffness > 0 then
                    local v48 = Position - v.Position;
                    local Magnitude2 = v48.Magnitude;
                    local v49 = Magnitude * (1 - Stiffness) * 2;

                    if v49 < Magnitude2 then
                        v.Position = v.Position + v48 * ((Magnitude2 - v49) / Magnitude2);
                    end;
                end;
            end;

            local v50 = v47.Position - v.Position;
            local Magnitude2 = v50.Magnitude;

            if Magnitude2 > 0 then
                v.Position = v.Position + v50 * ((Magnitude2 - Magnitude) / Magnitude2);
            end;
        end;
    end;
end;

function u5.SkipUpdateParticles(p51, p52) -- Line: 371
    for _, v in p52.Particles do
        if v.ParentIndex >= 1 and not v.Anchored then
            v.LastPosition = v.LastPosition + p52.ObjectMove;
            v.Position = v.Position + p52.ObjectMove;
            local v53 = p52.Particles[v.ParentIndex];
            local Magnitude = (v53.TransformOffset.Position - v.TransformOffset.Position).Magnitude;
            local Stiffness = p51.Settings.Stiffness;

            if Stiffness > 0 then
                local v54 = v53.Position + CFrame.lookAt(v53.Position, v.Position).LookVector.Unit * (v53.Position - v.Position).Magnitude - v.Position;
                local Magnitude2 = v54.Magnitude;
                local v55 = Magnitude * (1 - Stiffness) * 2;

                if v55 < Magnitude2 then
                    v.Position = v.Position + v54 * ((Magnitude2 - v55) / Magnitude2);
                end;
            end;

            local v56 = v53.Position - v.Position;
            local Magnitude2 = v56.Magnitude;

            if Magnitude < Magnitude2 then
                v.Position = v.Position + v56 * ((Magnitude2 - Magnitude) / Magnitude2);
            end;
        else
            v.LastPosition = v.TransformOffset.Position;
            v.Position = v.TransformOffset.Position;
        end;
    end;
end;

function u5.CalculateTransforms(p57, p58, p59) -- Line: 409
    -- upvalues: Utilities (copy)
    if p57.InRange then
        for _, v in p58.Particles do
            if v.ParentIndex >= 1 and v.Anchored == false then
                local v60 = p58.Particles[v.ParentIndex];
                local Bone = v60.Bone;

                if v60 and (Bone and (Bone:IsA("Bone") and Bone ~= p58.Root)) then
                    local TransformOffset = v60.TransformOffset;
                    local v61 = TransformOffset:PointToObjectSpace(v60.LocalTransformOffset.Position);
                    local v62 = Utilities.GetRotationBetween(TransformOffset.UpVector, v.Position - v60.Position, v61).Rotation * TransformOffset.Rotation;
                    v60.CalculatedWorldCFrame = Bone.WorldCFrame:Lerp(CFrame.new(v60.Position) * v62, 1 - 0.00001 ^ p59);
                end;
            end;
        end;
    end;
end;

function u5.TransformBones(p63, p64) -- Line: 438
    if p63.InRange then
        for _, v in p64.Particles do
            if v.ParentIndex >= 1 and v.Anchored == false then
                local v65 = p64.Particles[v.ParentIndex];
                local Bone = v65.Bone;

                if v65 and (Bone and (Bone:IsA("Bone") and Bone ~= p64.Root)) then
                    if v65.Anchored and p63.Settings.AnchorsRotate == false then
                        Bone.WorldCFrame = v65.TransformOffset;
                    else
                        Bone.WorldCFrame = v65.CalculatedWorldCFrame;
                    end;
                end;
            end;
        end;
    end;
end;

function u5.DEBUG(p66, p67) -- Line: 459
    for _, v in p67.Particles do
        if v then
            v.DebugPart.CFrame = CFrame.new(v.Position);
        end;
    end;
end;

function u5.RunLoop(p68, p69, p70, p71) -- Line: 467
    local v72 = p70 * 10;
    local v73;

    if p71 > 0 then
        p68.Time = p68.Time + p70;

        if 1 / p71 <= p68.Time then
            p68.Time = 0;
            v73 = true;
        else
            v73 = false;
        end;
    else
        v73 = true;
    end;

    if not v73 then
        p68:SkipUpdateParticles(p69);

        return;
    end;

    p68:UpdateParticles(p69, v72, 0);
    p68:CorrectParticles(p69, v72);
end;

function u5.ResetParticles(p74, p75) -- Line: 490
    for _, v in p75.Particles do
        v.LastPosition = v.TransformOffset.Position;
        v.Position = v.TransformOffset.Position;
    end;
end;

function u5.ResetTransforms(p76, p77) -- Line: 497
    for _, v in p77.Particles do
        local v78;

        if v.Bone == v.Root then
            v78 = p77.RootPart.CFrame * v.RootTransform;
        else
            v78 = p77.Root.WorldCFrame * v.Transform;
        end;

        v.Bone.WorldCFrame = v78;
    end;
end;

function u5.UpdateBones(p79, p80, p81) -- Line: 511
    for _, v in p79.ParticleTrees do
        p79:PreUpdate(v, p80);
        p79:RunLoop(v, p80, p81);
        p79:CalculateTransforms(v, p80);
    end;
end;

function u5.Start() -- Line: 519
    -- upvalues: Debug (copy), Utilities (copy), u4 (copy), CollectionService (copy), u2 (copy)
    local LocalPlayer = game.Players.LocalPlayer;
    local Folder = Instance.new("Folder");
    Folder.Name = "Actors";
    Folder.Parent = LocalPlayer:WaitForChild("PlayerScripts");

    local function DebugPrint(p82) -- Line: 526
        -- upvalues: Debug (ref)
        if Debug then
            warn(p82);
        end;
    end;

    local u83 = {};
    local u84 = {};

    local function registerSmartBoneObject(p85) -- Line: 535
        -- upvalues: Utilities (ref), Folder (copy), u83 (copy), u84 (copy), Debug (ref)
        if p85:IsA("BasePart") and (Utilities.WaitForChildOfClass(p85, "Bone", 3) and game.Workspace:IsAncestorOf(p85)) then
            local v86 = {};

            if p85:GetAttribute("Roots") and (p85:GetAttribute("Roots") ~= nil and typeof(p85:GetAttribute("Roots")) == "string") then
                local v87 = string.split(p85:GetAttribute("Roots"), ",");

                for _, v in ipairs(v87) do
                    local v88 = p85:FindFirstChild(v, true);

                    if v88 and v88:IsA("Bone") then
                        table.insert(v86, v88);
                    end;
                end;
            end;

            if #v86 > 0 then
                local Actor = Instance.new("Actor");
                local BindableFunction = Instance.new("BindableFunction");
                BindableFunction.Name = "Event";
                BindableFunction.Parent = Actor;
                local v89 = script.Dependencies.ActorScript:Clone();
                v89.Name = "Runtime";
                v89.Parent = Actor;
                Actor.Parent = Folder;
                v89.Enabled = true;
                u83[p85] = Actor.Event:Invoke(p85, v86);
                Actor.Name = p85.Name .. u83[p85].ID;
                u83[p85].RemovedEvent.Event:Once(function() -- Line: 576
                    -- upvalues: Actor (copy)
                    Actor.Runtime.Enabled = false;
                    Actor:Destroy();
                end);
                table.insert(u84, p85);
                local v90 = "Created new SmartBone Object with ID: " .. u83[p85].ID;

                if Debug then
                    warn(v90);
                end;
            else
                table.insert(u84, p85);
                local v91 = "Failed to create SmartBone Object for " .. p85:GetFullName() .. "! Make sure you have defined the Root Bone(s) for this object!";

                if Debug then
                    warn(v91);
                end;
            end;
        end;
    end;

    local function removeSmartBoneObject(u92) -- Line: 594
        -- upvalues: u83 (copy), Debug (ref), u4 (ref)
        if u83[u92] then
            local v93 = "Removing SmartBone Object with ID: " .. u83[u92].ID;

            if Debug then
                warn(v93);
            end;

            task.spawn(function() -- Line: 597
                -- upvalues: u83 (ref), u92 (copy), u4 (ref)
                for _, v in pairs(u83[u92].Connections) do
                    v:Disconnect();
                end;

                u83[u92].SimulationConnection:Disconnect();
                task.wait();
                u83[u92].RemovedEvent:Destroy();

                for _, v in ipairs(u83[u92].ParticleTrees) do
                    for _, v2 in v.Particles do
                        for _, v3 in v2.RecyclingBin do
                            v3:Destroy();
                        end;
                    end;
                end;

                task.wait();

                if u4[u83[u92].ID] then
                    u4[u83[u92].ID] = nil;
                end;

                u83[u92].Removed = true;
                u83[u92].RemovedEvent:Fire();
                u83[u92] = nil;
            end);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("SmartBone"):Connect(registerSmartBoneObject);
    CollectionService:GetInstanceRemovedSignal("SmartBone"):Connect(removeSmartBoneObject);

    for _, v in pairs(u2) do
        if not (u83[v] or table.find(u84, v)) then
            task.spawn(function() -- Line: 635
                -- upvalues: registerSmartBoneObject (copy), v (copy)
                registerSmartBoneObject(v);
            end);
        end;
    end;
end;

return u5;