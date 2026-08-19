-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local Debris = game:GetService("Debris");
local v1 = {};
local StarFruitImpact = game:GetService("SoundService"):WaitForChild("SFX"):WaitForChild("StarFruitImpact");

local function SetImpact(p2, p3) -- Line: 17
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p3;
        end;
    end;
end;

local function PlayBeam(p4, p5, u6) -- Line: 26
    -- upvalues: SetImpact (copy), RunService (copy), StarFruitImpact (copy), Debris (copy)
    local u7 = p4:Clone();
    u7.Anchored = true;
    u7.CanCollide = false;
    u7.CanQuery = false;

    for _, descendant in u7:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
        end;
    end;

    u7.CFrame = CFrame.new(u6) * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0);
    u7.Parent = workspace;
    local Att0 = u7:FindFirstChild("Att0", true);
    local Att1 = u7:FindFirstChild("Att1", true);
    local Aura = u7:FindFirstChild("Aura", true);

    if Aura then
        SetImpact(Aura, false);
    end;

    if Att0 and Att1 then
        Att0.WorldPosition = p5;
        local Position = Att1.Position;
        local u8 = u7.CFrame:PointToObjectSpace(p5);
        Att1.Position = u8;
        task.spawn(function() -- Line: 53
            -- upvalues: u7 (copy), RunService (ref), Att1 (copy), u8 (copy), Position (copy), Aura (copy), SetImpact (ref), u6 (copy), StarFruitImpact (ref), Debris (ref)
            local v9 = 0;

            while v9 < 0.35 and u7.Parent do
                v9 = v9 + RunService.Heartbeat:Wait();
                Att1.Position = u8:Lerp(Position, (math.min(v9 / 0.35, 1)));
            end;

            if not u7.Parent then
                return;
            end;

            if Aura then
                SetImpact(Aura, true);
            end;

            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.Transparency = 1;
            Part.Size = Vector3.new(1, 1, 1);
            Part.CFrame = CFrame.new(u6);
            Part.Parent = workspace;
            local v10 = StarFruitImpact:Clone();
            v10.Parent = Part;
            v10:Play();
            v10.Ended:Once(function() -- Line: 74
                -- upvalues: Part (copy)
                Part:Destroy();
            end);
            Debris:AddItem(Part, 10);
        end);
    end;

    task.delay(1.85, function() -- Line: 79
        -- upvalues: u7 (copy), Aura (copy), SetImpact (ref)
        if u7.Parent and Aura then
            SetImpact(Aura, false);
        end;
    end);
    Debris:AddItem(u7, 3.25);
end;

local function IsGrown(p11) -- Line: 86
    local v12 = p11:GetAttribute("Age");
    local v13 = p11:GetAttribute("MaxAge");
    local v14;

    if v12 == nil or v13 == nil then
        v14 = false;
    else
        v14 = v13 <= v12;
    end;

    return v14;
end;

local function SetPlantAura(p15, p16) -- Line: 94
    local Aura = p15:FindFirstChild("Aura");

    if not Aura then
        return;
    end;

    if p16 then
        local v17 = p15:GetAttribute("Age");
        local v18 = p15:GetAttribute("MaxAge");

        if v17 == nil or v18 == nil then
            p16 = false;
        else
            p16 = v18 <= v17;
        end;
    end;

    for _, descendant in Aura:GetDescendants() do
        if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p16;
        end;
    end;
end;

local function IsNight() -- Line: 106
    return workspace:GetAttribute("ActivePhase") == "Night";
end;

local function RefreshPlantAuras() -- Line: 111
    -- upvalues: CollectionService (copy), SetPlantAura (copy)
    local v19 = workspace:GetAttribute("ActivePhase") == "Night";

    for _, v in CollectionService:GetTagged("StarFruitAura") do
        SetPlantAura(v, v19);
    end;
end;

local function TrackPlant(u20) -- Line: 119
    -- upvalues: SetPlantAura (copy)
    SetPlantAura(u20, workspace:GetAttribute("ActivePhase") == "Night");
    u20:GetAttributeChangedSignal("Age"):Connect(function() -- Line: 121
        -- upvalues: SetPlantAura (ref), u20 (copy)
        SetPlantAura(u20, workspace:GetAttribute("ActivePhase") == "Night");
    end);
end;

function v1.Start(p21) -- Line: 127
    -- upvalues: ReplicatedStorage (copy), PlayBeam (copy), CollectionService (copy), SetPlantAura (copy), RefreshPlantAuras (copy), TrackPlant (copy)
    local StarFruitBeam = ReplicatedStorage:WaitForChild("StarFruitBeam");
    local StarFruitBeam2 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("StarFruitBeam");
    StarFruitBeam.OnClientEvent:Connect(function(p22, p23) -- Line: 130
        -- upvalues: PlayBeam (ref), StarFruitBeam2 (copy)
        if typeof(p22) == "Vector3" and typeof(p23) == "Vector3" then
            PlayBeam(StarFruitBeam2, p22, p23);
        end;
    end);

    for _, v in CollectionService:GetTagged("StarFruitAura") do
        SetPlantAura(v, workspace:GetAttribute("ActivePhase") == "Night");
        v:GetAttributeChangedSignal("Age"):Connect(function() -- Line: 121
            -- upvalues: SetPlantAura (ref), v (copy)
            SetPlantAura(v, workspace:GetAttribute("ActivePhase") == "Night");
        end);
    end;

    workspace:GetAttributeChangedSignal("ActivePhase"):Connect(RefreshPlantAuras);
    CollectionService:GetInstanceAddedSignal("StarFruitAura"):Connect(TrackPlant);
end;

return v1;