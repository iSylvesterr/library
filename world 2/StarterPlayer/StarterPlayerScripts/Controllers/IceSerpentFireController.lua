-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Debris = game:GetService("Debris");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local v1 = {};
local u2 = {};

local function GetAssets() -- Line: 23
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:FindFirstChild("Assets");
end;

local function FindDragonModel(p3) -- Line: 30
    local _PetVisualClient = workspace:FindFirstChild("_PetVisualClient");

    if _PetVisualClient then
        _PetVisualClient = _PetVisualClient:FindFirstChild("Models");
    end;

    if not _PetVisualClient then
        return nil;
    end;

    local v4 = p3.Parent and p3.Parent.Name;

    for _, child in pairs(_PetVisualClient:GetChildren()) do
        if child:IsA("Model") and (child:GetAttribute("OwnerSlot") == p3.Name and (not v4 or child:GetAttribute("Owner") == v4)) then
            return child;
        end;
    end;

    return nil;
end;

local function FindMouthPart(p5) -- Line: 46
    for _, v in pairs({ "Mouth", "FireOrigin", "Head" }) do
        local v6 = p5:FindFirstChild(v, true);

        if v6 and v6:IsA("BasePart") then
            return v6;
        end;
    end;

    return p5.PrimaryPart;
end;

local function FindFireEmitterTemplate() -- Line: 54
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("VFX");
    end;

    if not Assets then
        return nil;
    end;

    local OtherStorage = Assets:FindFirstChild("OtherStorage");

    if OtherStorage then
        OtherStorage = OtherStorage:FindFirstChild("IceFireEmitter");
    end;

    if OtherStorage and OtherStorage:IsA("Attachment") then
        return OtherStorage;
    end;

    local StatusVFX = Assets:FindFirstChild("StatusVFX");

    if StatusVFX then
        StatusVFX = StatusVFX:FindFirstChild("BurningVFX");
    end;

    if StatusVFX then
        StatusVFX = StatusVFX:FindFirstChild("fire");
    end;

    if StatusVFX and StatusVFX:IsA("ParticleEmitter") then
        return StatusVFX;
    end;

    return nil;
end;

local function GetHRP(p7) -- Line: 71
    if not p7 then
        return nil;
    end;

    local HumanoidRootPart = p7:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    return nil;
end;

local function GetModelScale(u8) -- Line: 82
    local success, result = pcall(function() -- Line: 83
        -- upvalues: u8 (copy)
        return u8:GetScale();
    end);

    return (not success or (type(result) ~= "number" or result <= 0)) and 1 or result;
end;

local function ScaleNumberSequence(p9, p10) -- Line: 90
    local v11 = {};

    for _, v in pairs(p9.Keypoints) do
        table.insert(v11, NumberSequenceKeypoint.new(v.Time, v.Value * p10, v.Envelope * p10));
    end;

    return NumberSequence.new(v11);
end;

local function ScaleBreathVFX(p12, p13) -- Line: 100
    -- upvalues: ScaleNumberSequence (copy)
    if p13 == 1 then
        return;
    end;

    local v14 = p12:GetDescendants();
    table.insert(v14, p12);

    for _, v in pairs(v14) do
        if v:IsA("Beam") then
            v.Width0 = v.Width0 * p13;
            v.Width1 = v.Width1 * p13;
        elseif v:IsA("ParticleEmitter") then
            v.Size = ScaleNumberSequence(v.Size, p13);
        end;
    end;
end;

local function PlayBreathe(p15, p16) -- Line: 115
    local u17 = p15:FindFirstChildOfClass("AnimationController");

    if u17 then
        u17 = u17:FindFirstChildOfClass("Animator");
    end;

    if not u17 then
        return;
    end;

    local Animations = p15:FindFirstChild("Animations");
    local u18 = Animations and Animations:FindFirstChild("Breathe") or p15:FindFirstChild("Breathe");

    if not (u18 and u18:IsA("Animation")) then
        return;
    end;

    local success, result = pcall(function() -- Line: 125
        -- upvalues: u17 (copy), u18 (copy)
        return u17:LoadAnimation(u18);
    end);

    if not (success and result) then
        return;
    end;

    result.Looped = true;
    result.Priority = Enum.AnimationPriority.Action;
    result:Play(0.15);
    task.delay(p16, function() -- Line: 132
        -- upvalues: result (copy)
        if result and result.IsPlaying then
            result:Stop(0.2);
        end;
    end);
end;

local function StartBeam(u19, u20, u21, p22) -- Line: 138
    -- upvalues: FindMouthPart (copy), FindFireEmitterTemplate (copy), ScaleBreathVFX (copy), u2 (copy), PlayBreathe (copy), RunService (copy), Debris (copy)
    local u23 = FindMouthPart(u20);

    if not u23 then
        return;
    end;

    local success, result = pcall(function() -- Line: 83
        -- upvalues: u20 (copy)
        return u20:GetScale();
    end);
    local u24 = (not success or (type(result) ~= "number" or result <= 0)) and 1 or result;
    local Part = Instance.new("Part");
    Part.Name = "IceSerpentFireBeam";
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.Transparency = 1;
    Part.Size = Vector3.new(u24 * 0.2, u24 * 0.2, 1);
    Part.Parent = workspace;
    local u25 = nil;
    local u26 = nil;
    local v27 = FindFireEmitterTemplate();

    if v27 then
        local v28 = v27:Clone();
        v28.Parent = Part;
        ScaleBreathVFX(v28, u24);

        if v28:IsA("Attachment") then
            v28.Position = Vector3.new(0, 0, -0.5);
            local Attachment = Instance.new("Attachment");
            Attachment.Parent = Part;
            u26 = Attachment;
            u25 = v28;

            for _, descendant in pairs(v28:GetDescendants()) do
                if descendant:IsA("Beam") then
                    descendant.Attachment0 = v28;
                    descendant.Attachment1 = Attachment;
                    descendant.Enabled = true;
                end;
            end;
        end;
    end;

    local u29 = {};
    local v30 = u2[u19];

    if v30 and v30.Beam then
        v30.Token = u29;

        if v30.Beam.Parent then
            v30.Beam:Destroy();
        end;
    end;

    u2[u19] = {
        Token = u29,
        Beam = Part
    };
    PlayBreathe(u20, p22);
    local u31 = os.clock() + p22;
    local u32 = nil;
    u32 = RunService.RenderStepped:Connect(function() -- Line: 197
        -- upvalues: u2 (ref), u19 (copy), u29 (copy), u31 (copy), Part (copy), u23 (copy), u32 (ref), u21 (copy), u24 (copy), u25 (ref), u26 (ref)
        local v33 = u2[u19];

        if not v33 or (v33.Token ~= u29 or (u31 <= os.clock() or not (Part.Parent and u23.Parent))) then
            if u32 then
                u32:Disconnect();
            end;

            return;
        end;

        local Position = u23.Position;
        local v34 = u21;
        local v35;

        if v34 then
            v35 = v34:FindFirstChild("HumanoidRootPart");

            if not (v35 and v35:IsA("BasePart")) then
                v35 = nil;
            end;
        else
            v35 = nil;
        end;

        local v36;

        if v35 then
            v36 = v35.Position;
        else
            v36 = Position + u23.CFrame.LookVector * 10;
        end;

        local v37 = math.min((v36 - Position).Magnitude, 60);
        local v38 = v37 < 0.1 and 0.1 or v37;
        Part.Size = Vector3.new(u24 * 0.2, u24 * 0.2, v38);
        Part.CFrame = CFrame.lookAt(Position, v36) * CFrame.new(0, 0, -v38 * 0.5);

        if u25 then
            u25.WorldCFrame = CFrame.lookAt(Position, v36);
        end;

        if u26 then
            u26.WorldPosition = v36;
        end;
    end);
    task.delay(p22, function() -- Line: 219
        -- upvalues: u32 (ref), u2 (ref), u19 (copy), u29 (copy), Part (copy), Debris (ref)
        if u32 then
            u32:Disconnect();
        end;

        local v39 = u2[u19];

        if v39 and v39.Token ~= u29 then
            return;
        end;

        u2[u19] = nil;

        for _, descendant in pairs(Part:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            elseif descendant:IsA("Beam") then
                descendant.Enabled = false;
            end;
        end;

        Debris:AddItem(Part, 2);
    end);
end;

function v1.Init(p40) -- Line: 239
end;

function v1.Start(p41) -- Line: 241
    -- upvalues: Networking (copy), FindDragonModel (copy), StartBeam (copy)
    Networking.IceSerpent.BreathStart.OnClientEvent:Connect(function(p42, p43, p44) -- Line: 242
        -- upvalues: FindDragonModel (ref), StartBeam (ref)
        if typeof(p42) ~= "Instance" then
            return;
        end;

        if type(p44) ~= "number" or p44 <= 0 then
            return;
        end;

        local v45 = FindDragonModel(p42);

        if not v45 then
            return;
        end;

        StartBeam(p42, v45, p43, p44);
    end);
end;

return v1;