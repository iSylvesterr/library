-- Decompiled with Potassium's decompiler.

local v1 = {};
local CollectionService = game:GetService("CollectionService");
local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Emit = require(ReplicatedStorage.UserGenerated.VFX.Emit);
local u2 = { "Assets", "Minigames", "Disco" };
local u3 = {};
local u4 = nil;
local u5 = false;

local function ResolveCollectTemplate() -- Line: 98
    -- upvalues: u5 (ref), u4 (ref), ReplicatedStorage (copy), u2 (copy)
    if u5 then
        return u4;
    end;

    u5 = true;
    local v6 = ReplicatedStorage;

    for _, v in u2 do
        if v6 then
            v6 = v6:FindFirstChild(v);
        end;
    end;

    if v6 then
        v6 = v6:FindFirstChild("PartyPointCollect");
    end;

    if v6 and v6:IsA("PVInstance") then
        u4 = v6;

        return v6;
    end;

    local v7 = table.concat(u2, ".");
    warn((`[PartyPointPickupController] ReplicatedStorage.{v7}.PartyPointCollect not found (or not a part / model)`));

    return nil;
end;

local function Neutralize(p8) -- Line: 121
    p8.Anchored = true;
    p8.CanCollide = false;
    p8.CanQuery = false;
    p8.CanTouch = false;
end;

local function PlayCollectBurst(p9) -- Line: 130
    -- upvalues: ResolveCollectTemplate (copy), Emit (copy), Debris (copy)
    local v10 = ResolveCollectTemplate();

    if not v10 then
        return;
    end;

    local v11 = v10:Clone();

    if v11:IsA("BasePart") then
        v11.Anchored = true;
        v11.CanCollide = false;
        v11.CanQuery = false;
        v11.CanTouch = false;
    end;

    for _, descendant in v11:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
        end;
    end;

    v11:PivotTo(CFrame.new(p9) * v11:GetPivot().Rotation);
    v11.Parent = workspace;
    Emit(v11);
    Debris:AddItem(v11, 5);
end;

local function Track(p12) -- Line: 155
    -- upvalues: u3 (copy)
    if u3[p12] or not p12:IsA("PVInstance") then
        return;
    end;

    local v13 = p12:GetPivot();
    local v14 = p12:GetAttribute("PartyPointBobPhase");
    u3[p12] = {
        Collect = nil,
        Instance = p12,
        Origin = v13.Position,
        Rotation = v13.Rotation,
        Phase = type(v14) ~= "number" and 0 or v14 * 2
    };
end;

local function Untrack(p15) -- Line: 172
    -- upvalues: u3 (copy)
    u3[p15] = nil;
end;

local function BeginCollect(p16) -- Line: 181
    -- upvalues: Players (copy), PlayCollectBurst (copy)
    local v17 = p16.Instance:GetAttribute("PartyPointCollectedBy");

    if type(v17) ~= "number" then
        return nil;
    end;

    local v18 = Players:GetPlayerByUserId(v17);

    if not v18 then
        return nil;
    end;

    local v19 = p16.Instance:FindFirstChildWhichIsA("BillboardGui", true);

    if not (v19 and v19:IsA("BillboardGui")) then
        v19 = nil;
    end;

    local v20 = {};

    if v19 then
        for _, descendant in v19:GetDescendants() do
            if descendant:IsA("ImageLabel") then
                table.insert(v20, descendant);
            end;
        end;
    end;

    local v21 = {
        StartedAt = os.clock(),
        Origin = p16.Instance:GetPivot().Position,
        Collector = v18,
        Billboard = v19
    };
    local v22;

    if v19 then
        v22 = v19.Size;
    else
        v22 = UDim2.new();
    end;

    v21.BillboardSize = v22;
    v21.Labels = v20;
    p16.Collect = v21;
    PlayCollectBurst(v21.Origin);

    return v21;
end;

local function StepCollect(p23, p24) -- Line: 224
    local v25 = (os.clock() - p24.StartedAt) / 0.45;
    local v26 = math.clamp(v25, 0, 1);
    local v27 = v26 * v26;
    local v28 = 1 - v27;
    local Character = p24.Collector.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local Origin = p24.Origin;
    local v29;

    if Character and Character:IsA("BasePart") then
        v29 = Character.Position;
    else
        v29 = Origin;
    end;

    local v30 = (Origin + v29) * 0.5 + Vector3.new(0, ((v29 - Origin) * Vector3.new(1, 0, 1)).Magnitude * 0.9, 0);
    p23.Instance:PivotTo(CFrame.new(v28 * v28 * Origin + v28 * 2 * v27 * v30 + v27 * v27 * v29) * p23.Rotation);
    local Billboard = p24.Billboard;

    if Billboard then
        local BillboardSize = p24.BillboardSize;
        Billboard.Size = UDim2.new(BillboardSize.X.Scale * v28, BillboardSize.X.Offset * v28, BillboardSize.Y.Scale * v28, BillboardSize.Y.Offset * v28);
    end;

    local v31 = math.clamp((v26 - 0.45) / 0.55, 0, 1);

    for _, v in p24.Labels do
        v.ImageTransparency = v31;
    end;
end;

local function Step() -- Line: 265
    -- upvalues: u3 (copy), BeginCollect (copy), StepCollect (copy)
    local v32 = workspace:GetServerTimeNow();

    for i, v in u3 do
        if i.Parent then
            local v33 = v.Collect or BeginCollect(v);

            if v33 then
                StepCollect(v, v33);
            else
                local Origin = v.Origin;
                local v34 = math.sin((v32 + v.Phase) * 3.141592653589793) * 0.75;
                v.Instance:PivotTo(CFrame.new(Origin.X, Origin.Y + v34, Origin.Z) * v.Rotation);
            end;
        else
            u3[i] = nil;
        end;
    end;
end;

function v1.Init(p35) -- Line: 288
end;

function v1.Start(p36) -- Line: 290
    -- upvalues: CollectionService (copy), Track (copy), Untrack (copy), RunService (copy), Step (copy)
    for _, v in CollectionService:GetTagged("PartyPointPickup") do
        Track(v);
    end;

    CollectionService:GetInstanceAddedSignal("PartyPointPickup"):Connect(Track);
    CollectionService:GetInstanceRemovedSignal("PartyPointPickup"):Connect(Untrack);
    RunService.RenderStepped:Connect(Step);
end;

return v1;