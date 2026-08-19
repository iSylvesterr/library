-- Decompiled with Potassium's decompiler.

local v1 = {};
local CollectionService = game:GetService("CollectionService");
local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local LastToLeaveData = require(ReplicatedStorage.SharedModules.LastToLeaveData);
local u2 = Color3.fromRGB(255, 120, 40);
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = Vector3.new(0, 0, 0);
local u7 = nil;
local u8 = 0;
local u9 = nil;
local u10 = Vector3.new(0, 0, 0);
local u11 = nil;
local identity = CFrame.identity;
local u12 = 0;
local u13 = -1;
local u14 = nil;
local u15 = 1;
local u16 = {};
local u17 = nil;
local u18 = Vector3.new(0, 0, 0);

local function resolveTemplateChild(p19) -- Line: 119
    -- upvalues: ReplicatedStorage (copy), LastToLeaveData (copy)
    local v20 = ReplicatedStorage;

    for _, v in LastToLeaveData.TemplatePath do
        if v20 then
            v20 = v20:FindFirstChild(v);
        end;
    end;

    if v20 then
        v20 = v20:FindFirstChild(p19);
    end;

    return v20;
end;

local function resolveAsset(p21) -- Line: 127
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild(p21);
    end;

    return Assets;
end;

local function neutralise(p22) -- Line: 132
    p22.Anchored = true;
    p22.CanCollide = false;
    p22.CanQuery = false;
    p22.CanTouch = false;
    p22.Massless = true;
end;

local function destroyObstacles() -- Line: 140
    -- upvalues: u7 (ref), u11 (ref), u17 (ref), u16 (copy), u8 (ref), u13 (ref)
    if u7 then
        u7:Destroy();
        u7 = nil;
    end;

    if u11 then
        u11:Destroy();
        u11 = nil;
    end;

    if u17 then
        u17:Destroy();
        u17 = nil;
    end;

    table.clear(u16);
    u8 = 0;
    u13 = -1;
end;

local function clearArena() -- Line: 158
    -- upvalues: u7 (ref), u11 (ref), u17 (ref), u16 (copy), u8 (ref), u13 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u9 (ref), u10 (ref), identity (ref), u12 (ref), u14 (ref), u15 (ref), u18 (ref)
    if u7 then
        u7:Destroy();
        u7 = nil;
    end;

    if u11 then
        u11:Destroy();
        u11 = nil;
    end;

    if u17 then
        u17:Destroy();
        u17 = nil;
    end;

    table.clear(u16);
    u8 = 0;
    u13 = -1;
    u3 = nil;
    u4 = nil;
    u5 = nil;
    u6 = Vector3.new(0, 0, 0);
    u9 = nil;
    u10 = Vector3.new(0, 0, 0);
    identity = CFrame.identity;
    u12 = 0;
    u14 = nil;
    u15 = 1;
    u18 = Vector3.new(0, 0, 0);
end;

local function resolveArena(p23) -- Line: 180
    -- upvalues: LastToLeaveData (copy), u4 (ref), u5 (ref), u6 (ref), u9 (ref)
    local v24 = tonumber(p23:GetAttribute(LastToLeaveData.StartAttribute));
    local v25 = tonumber(p23:GetAttribute(LastToLeaveData.DurationAttribute));
    local v26 = tonumber(p23:GetAttribute(LastToLeaveData.TornadoSeedAttribute));
    local v27 = tonumber(p23:GetAttribute(LastToLeaveData.SpinnerSeedAttribute));

    if not v24 or (not v25 or (not v26 or (not v27 or v25 <= 0))) then
        return false;
    end;

    u4 = v24;
    u5 = LastToLeaveData.BuildPath(v26, v25);
    u6 = LastToLeaveData.GetObstacleBase(p23);
    u9 = LastToLeaveData.BuildPath(v27, v25);

    return true;
end;

local function stepTornado(p28) -- Line: 199
    -- upvalues: u5 (ref), u7 (ref), resolveTemplateChild (copy), LastToLeaveData (copy), u8 (ref), u6 (ref)
    local v29 = u5;

    if not v29 then
        return;
    end;

    if not u7 then
        local v30 = resolveTemplateChild(LastToLeaveData.TornadoName);

        if not (v30 and v30:IsA("Model")) then
            return;
        end;

        local v31 = v30:Clone();
        v31.Name = LastToLeaveData.TornadoName;

        for _, descendant in v31:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Massless = true;
            end;
        end;

        v31:ScaleTo(LastToLeaveData.TornadoStartScale);
        u8 = LastToLeaveData.TornadoStartScale;
        v31.Parent = workspace;
        u7 = v31;
    end;

    local v32 = u7;

    if not v32 then
        return;
    end;

    local v33 = LastToLeaveData.GetTornadoScale(p28);

    if math.abs(v33 - u8) > 0.0001 then
        v32:ScaleTo(v33);
        u8 = v33;
    end;

    local v34 = u6 + LastToLeaveData.GetPathOffset(v29, p28);
    local v35 = LastToLeaveData.GetSpin(p28, LastToLeaveData.TornadoSpinPeriod);
    v32:PivotTo(CFrame.new(v34) * CFrame.Angles(0, v35, 0));
end;

local function stepSpinner(p36, p37) -- Line: 240
    -- upvalues: u9 (ref), u11 (ref), resolveTemplateChild (copy), LastToLeaveData (copy), identity (ref), u12 (ref), u10 (ref), u13 (ref)
    local v38 = u9;

    if not v38 then
        return;
    end;

    if not u11 then
        local v39 = resolveTemplateChild(LastToLeaveData.SpinnerName);

        if not (v39 and v39:IsA("BasePart")) then
            return;
        end;

        identity = v39.CFrame.Rotation;
        u12 = v39.Transparency;
        u10 = LastToLeaveData.GetSpinnerBase(p36, v39.Size);
        local v40 = v39:Clone();
        v40.Name = LastToLeaveData.SpinnerName;
        v40.Anchored = true;
        v40.CanCollide = false;
        v40.CanQuery = false;
        v40.CanTouch = false;
        v40.Massless = true;
        v40.Transparency = 1;
        u13 = 0;
        v40.Parent = workspace;
        u11 = v40;
    end;

    local v41 = u11;

    if not v41 then
        return;
    end;

    local v42 = LastToLeaveData.GetSpinnerReveal(p37);

    if math.abs(v42 - u13) > 0.001 then
        v41.Transparency = math.lerp(1, u12, v42);
        u13 = v42;
    end;

    v41.CFrame = LastToLeaveData.GetSpinnerPose(u10, v38, identity, p37);
end;

local function resolveMeteors(p43) -- Line: 290
    -- upvalues: u14 (ref), LastToLeaveData (copy), u15 (ref), u18 (ref)
    if u14 then
        return true;
    end;

    local v44 = tonumber(p43:GetAttribute(LastToLeaveData.MeteorSeedAttribute));
    local v45 = tonumber(p43:GetAttribute(LastToLeaveData.DurationAttribute));

    if not v44 or (not v45 or v45 <= 0) then
        return false;
    end;

    u14 = LastToLeaveData.BuildMeteors(v44, v45);
    u15 = 1;
    u18 = LastToLeaveData.GetObstacleBase(p43);

    return true;
end;

local function ensureMeteorFolder() -- Line: 307
    -- upvalues: u17 (ref)
    local v46 = u17;

    if v46 and v46.Parent then
        return v46;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "LastToLeaveMeteors";
    Folder.Parent = workspace;
    u17 = Folder;

    return Folder;
end;

local function cloneMeteorBody() -- Line: 325
    -- upvalues: resolveTemplateChild (copy), LastToLeaveData (copy), ReplicatedStorage (copy)
    local v47 = resolveTemplateChild(LastToLeaveData.MeteorName);

    if not v47 then
        local MeteorBodyAsset = LastToLeaveData.MeteorBodyAsset;
        v47 = ReplicatedStorage:FindFirstChild("Assets");

        if v47 then
            v47 = v47:FindFirstChild(MeteorBodyAsset);
        end;
    end;

    if not v47 then
        return nil;
    end;

    local v48 = v47:Clone();

    if not v48:IsA("PVInstance") then
        v48:Destroy();

        return nil;
    end;

    if v48:IsA("BasePart") then
        v48.Anchored = true;
        v48.CanCollide = false;
        v48.CanQuery = false;
        v48.CanTouch = false;
        v48.Massless = true;
    end;

    for _, descendant in v48:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
        end;
    end;

    return v48;
end;

local function createMarker(p49, p50) -- Line: 349
    -- upvalues: u2 (copy), u17 (ref)
    local Part = Instance.new("Part");
    Part.Name = "MeteorMarker";
    Part.Shape = Enum.PartType.Cylinder;
    Part.Size = Vector3.new(0.05, p49 * 2, p49 * 2);
    Part.CFrame = CFrame.new(p50) * CFrame.Angles(0, 0, 1.5707963267948966);
    Part.Material = Enum.Material.Neon;
    Part.Color = u2;
    Part.Transparency = 0.5;
    Part.CastShadow = false;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    local v51 = u17;

    if not (v51 and v51.Parent) then
        v51 = Instance.new("Folder");
        v51.Name = "LastToLeaveMeteors";
        v51.Parent = workspace;
        u17 = v51;
    end;

    Part.Parent = v51;

    return Part;
end;

local function createFire(p52, p53) -- Line: 375
    -- upvalues: LastToLeaveData (copy), ReplicatedStorage (copy), u17 (ref)
    local MeteorFireAsset = LastToLeaveData.MeteorFireAsset;
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild(MeteorFireAsset);
    end;

    if not (Assets and Assets:IsA("BasePart")) then
        return nil;
    end;

    local v54 = Assets:Clone();
    v54.Anchored = true;
    v54.CanCollide = false;
    v54.CanQuery = false;
    v54.CanTouch = false;
    v54.Massless = true;
    local v55 = p52 * 2;
    v54.Size = Vector3.new(v55, v54.Size.Y, v55);
    v54.CFrame = CFrame.new(p53);
    local v56 = v55 / LastToLeaveData.MeteorFireAssetSize;

    for _, descendant in v54:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Rate = descendant.Rate * (v56 * v56);
        end;
    end;

    local v57 = u17;

    if not (v57 and v57.Parent) then
        v57 = Instance.new("Folder");
        v57.Name = "LastToLeaveMeteors";
        v57.Parent = workspace;
        u17 = v57;
    end;

    v54.Parent = v57;

    return v54;
end;

local function landMeteor(p58) -- Line: 403
    -- upvalues: Debris (copy), createFire (copy)
    p58.Landed = true;
    local Body = p58.Body;

    if Body then
        p58.Body = nil;
        p58.Spinner = nil;
        local BillboardGui = Body:FindFirstChild("BillboardGui", true);

        if BillboardGui and BillboardGui:IsA("BillboardGui") then
            BillboardGui.Enabled = false;
        end;

        local Poof = Body:FindFirstChild("Poof");

        if Poof and Poof:IsA("Sound") then
            Poof:Play();
        end;

        for _, descendant in Body:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                local v59 = descendant:GetAttribute("EmitCount");
                descendant:Emit(type(v59) ~= "number" and 5 or v59);
            elseif descendant:IsA("Trail") then
                descendant.Enabled = false;
            end;
        end;

        Debris:AddItem(Body, 4);
    end;

    local Marker = p58.Marker;

    if Marker then
        Marker:Destroy();
        p58.Marker = nil;
    end;

    p58.Fire = createFire(p58.Record.Radius, p58.Impact + Vector3.new(0, 0.1, 0));
end;

local function extinguishMeteor(p60) -- Line: 444
    -- upvalues: Debris (copy)
    local Fire = p60.Fire;

    if not Fire then
        return;
    end;

    p60.Fire = nil;

    for _, descendant in Fire:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;
    end;

    Debris:AddItem(Fire, 1.5);
end;

local function stepMeteor(p61, p62) -- Line: 462
    -- upvalues: cloneMeteorBody (copy), u17 (ref), createMarker (copy), LastToLeaveData (copy), TweenService (copy), landMeteor (copy), extinguishMeteor (copy)
    local v63 = p62 - p61.Record.At;

    if v63 >= 0 then
        if not p61.Landed then
            landMeteor(p61);
        end;

        if LastToLeaveData.MeteorBurnDuration > v63 then
            return true;
        end;

        extinguishMeteor(p61);

        return false;
    end;

    if not p61.Body then
        local v64 = cloneMeteorBody();

        if not v64 then
            return true;
        end;

        v64:PivotTo(p61.Start);
        local v65 = u17;

        if not (v65 and v65.Parent) then
            v65 = Instance.new("Folder");
            v65.Name = "LastToLeaveMeteors";
            v65.Parent = workspace;
            u17 = v65;
        end;

        v64.Parent = v65;
        p61.Body = v64;
        local BillboardGui = v64:FindFirstChild("BillboardGui", true);

        if BillboardGui then
            BillboardGui = BillboardGui:FindFirstChild("ImageLabel");
        end;

        if BillboardGui and BillboardGui:IsA("ImageLabel") then
            p61.Spinner = BillboardGui;
        end;

        local Travel = v64:FindFirstChild("Travel");

        if Travel and Travel:IsA("Sound") then
            Travel:Play();
        end;

        p61.Marker = createMarker(p61.Record.Radius, p61.Impact + Vector3.new(0, 0.1, 0));
    end;

    local Body = p61.Body;

    if Body then
        local v66 = TweenService:GetValue(math.clamp(1 + v63 / LastToLeaveData.MeteorFallDuration, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        Body:PivotTo(p61.Start:Lerp(CFrame.new(p61.Impact), v66));
    end;

    local Spinner = p61.Spinner;

    if Spinner then
        Spinner.Rotation = p62 * 90;
    end;

    local Marker = p61.Marker;

    if Marker then
        local v67 = math.sin(p62 * 12) * 0.5 + 0.5;
        Marker.Transparency = math.lerp(0.5, 0.85, v67);
    end;

    return true;
end;

local function stepMeteors(p68, p69) -- Line: 530
    -- upvalues: resolveMeteors (copy), u14 (ref), LastToLeaveData (copy), u15 (ref), u18 (ref), u16 (copy), stepMeteor (copy)
    if not resolveMeteors(p68) then
        return;
    end;

    local v70 = u14;

    if not v70 then
        return;
    end;

    local MeteorFallDuration = LastToLeaveData.MeteorFallDuration;
    local MeteorBurnDuration = LastToLeaveData.MeteorBurnDuration;

    while u15 <= #v70 do
        local v71 = v70[u15];

        if p69 < v71.At - MeteorFallDuration then
            break;
        end;

        u15 = u15 + 1;

        if p69 < v71.At + MeteorBurnDuration then
            local v72 = u18 + v71.Offset;
            local v73 = {
                Landed = false,
                Record = v71,
                Impact = v72,
                Start = CFrame.new(v72 + v71.Approach * LastToLeaveData.MeteorFallLateral + Vector3.new(0, LastToLeaveData.MeteorFallHeight, 0))
            };
            table.insert(u16, v73);
        end;
    end;

    for i = #u16, 1, -1 do
        if not stepMeteor(u16[i], p69) then
            table.remove(u16, i);
        end;
    end;
end;

local function step() -- Line: 574
    -- upvalues: u3 (ref), u7 (ref), u11 (ref), u17 (ref), u16 (copy), u8 (ref), u13 (ref), u4 (ref), u5 (ref), u6 (ref), u9 (ref), u10 (ref), identity (ref), u12 (ref), u14 (ref), u15 (ref), u18 (ref), resolveArena (copy), LastToLeaveData (copy), stepTornado (copy), stepSpinner (copy), stepMeteors (copy)
    local v74 = u3;

    if not v74 then
        return;
    end;

    if v74.Parent then
        if not (u4 or resolveArena(v74)) then
            return;
        end;

        local v75 = u4;

        if not v75 then
            return;
        end;

        local v76 = workspace:GetServerTimeNow() - v75;
        local v77 = v76 - LastToLeaveData.ObstacleSpawnDelay;

        if v77 < 0 then
            return;
        end;

        stepTornado(v77);
        stepSpinner(v74, v77);
        stepMeteors(v74, v76);

        return;
    end;

    if u7 then
        u7:Destroy();
        u7 = nil;
    end;

    if u11 then
        u11:Destroy();
        u11 = nil;
    end;

    if u17 then
        u17:Destroy();
        u17 = nil;
    end;

    table.clear(u16);
    u8 = 0;
    u13 = -1;
    u3 = nil;
    u4 = nil;
    u5 = nil;
    u6 = Vector3.new(0, 0, 0);
    u9 = nil;
    u10 = Vector3.new(0, 0, 0);
    identity = CFrame.identity;
    u12 = 0;
    u14 = nil;
    u15 = 1;
    u18 = Vector3.new(0, 0, 0);
end;

local function addArena(p78) -- Line: 605
    -- upvalues: u3 (ref), u7 (ref), u11 (ref), u17 (ref), u16 (copy), u8 (ref), u13 (ref), u4 (ref), u5 (ref), u6 (ref), u9 (ref), u10 (ref), identity (ref), u12 (ref), u14 (ref), u15 (ref), u18 (ref)
    if not p78:IsA("BasePart") then
        return;
    end;

    if u3 ~= p78 then
        if u7 then
            u7:Destroy();
            u7 = nil;
        end;

        if u11 then
            u11:Destroy();
            u11 = nil;
        end;

        if u17 then
            u17:Destroy();
            u17 = nil;
        end;

        table.clear(u16);
        u8 = 0;
        u13 = -1;
        u3 = nil;
        u4 = nil;
        u5 = nil;
        u6 = Vector3.new(0, 0, 0);
        u9 = nil;
        u10 = Vector3.new(0, 0, 0);
        identity = CFrame.identity;
        u12 = 0;
        u14 = nil;
        u15 = 1;
        u18 = Vector3.new(0, 0, 0);
        u3 = p78;
    end;
end;

local function removeArena(p79) -- Line: 617
    -- upvalues: u3 (ref), u7 (ref), u11 (ref), u17 (ref), u16 (copy), u8 (ref), u13 (ref), u4 (ref), u5 (ref), u6 (ref), u9 (ref), u10 (ref), identity (ref), u12 (ref), u14 (ref), u15 (ref), u18 (ref)
    if u3 == p79 then
        if u7 then
            u7:Destroy();
            u7 = nil;
        end;

        if u11 then
            u11:Destroy();
            u11 = nil;
        end;

        if u17 then
            u17:Destroy();
            u17 = nil;
        end;

        table.clear(u16);
        u8 = 0;
        u13 = -1;
        u3 = nil;
        u4 = nil;
        u5 = nil;
        u6 = Vector3.new(0, 0, 0);
        u9 = nil;
        u10 = Vector3.new(0, 0, 0);
        identity = CFrame.identity;
        u12 = 0;
        u14 = nil;
        u15 = 1;
        u18 = Vector3.new(0, 0, 0);
    end;
end;

function v1.Start(p80) -- Line: 625
    -- upvalues: CollectionService (copy), LastToLeaveData (copy), u3 (ref), u7 (ref), u11 (ref), u17 (ref), u16 (copy), u8 (ref), u13 (ref), u4 (ref), u5 (ref), u6 (ref), u9 (ref), u10 (ref), identity (ref), u12 (ref), u14 (ref), u15 (ref), u18 (ref), addArena (copy), removeArena (copy), RunService (copy), step (copy)
    for _, v in CollectionService:GetTagged(LastToLeaveData.ArenaTag) do
        if v:IsA("BasePart") then
            if u3 ~= v then
                if u7 then
                    u7:Destroy();
                    u7 = nil;
                end;

                if u11 then
                    u11:Destroy();
                    u11 = nil;
                end;

                if u17 then
                    u17:Destroy();
                    u17 = nil;
                end;

                table.clear(u16);
                u8 = 0;
                u13 = -1;
                u3 = nil;
                u4 = nil;
                u5 = nil;
                u6 = Vector3.new(0, 0, 0);
                u9 = nil;
                u10 = Vector3.new(0, 0, 0);
                identity = CFrame.identity;
                u12 = 0;
                u14 = nil;
                u15 = 1;
                u18 = Vector3.new(0, 0, 0);
                u3 = v;
            end;
        end;
    end;

    CollectionService:GetInstanceAddedSignal(LastToLeaveData.ArenaTag):Connect(addArena);
    CollectionService:GetInstanceRemovedSignal(LastToLeaveData.ArenaTag):Connect(removeArena);
    RunService.RenderStepped:Connect(step);
end;

return v1;