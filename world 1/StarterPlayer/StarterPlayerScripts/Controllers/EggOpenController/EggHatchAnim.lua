-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Debris = game:GetService("Debris");
local u1 = {
    Intensity = 0.7,
    Duration = 0.5
};
local u2 = {
    Intensity = 0.8,
    Duration = 0.5
};
local u3 = {
    Intensity = 1.2,
    Duration = 0.75,
    Shake = 0.6
};
local u4 = {
    Intensity = 1.2,
    Duration = 0.75,
    Shake = 1
};
local u5 = { u1, u1 };
local u6 = {
    Chance = 0.1,
    PreDelayMin = 0.5,
    PreDelayMax = 1.5,
    PostDelay = 0.5,
    Spec = u1,
    FollowUpSpec = u1
};
local u7 = Random.new();
local u8 = {};
local SpiralTrail = require(game.ReplicatedStorage.ClientModules.SpiralTrail);
local Assets = ReplicatedStorage:WaitForChild("Assets");

local function GetGrowEffectsTemplate() -- Line: 99
    -- upvalues: Assets (copy)
    local EggEffects = Assets:FindFirstChild("EggEffects");

    if EggEffects then
        return EggEffects:FindFirstChild("GrowEffects");
    end;

    return nil;
end;

local function DebugPopVFX(p9) -- Line: 104
end;

local function GetInstancePath(p10) -- Line: 110
    local v11 = { p10.Name };
    local Parent = p10.Parent;

    while Parent and Parent ~= game do
        table.insert(v11, 1, Parent.Name);
        Parent = Parent.Parent;
    end;

    return table.concat(v11, "/");
end;

local function DescribeChildren(p12) -- Line: 120
    local v13 = {};

    for _, child in p12:GetChildren() do
        local v14 = `{child.Name}({child.ClassName})`;
        table.insert(v13, v14);
    end;

    return #v13 == 0 and "(no children)" or table.concat(v13, ", ");
end;

local function Wobble(u15, p16, p17, p18) -- Line: 144
    -- upvalues: u8 (copy), u7 (copy), RunService (copy)
    local v19 = u8[u15];

    if v19 then
        v19.Connection:Disconnect();

        if u15.Parent then
            u15:PivotTo(v19.StartPivot);
        end;

        u8[u15] = nil;
    end;

    local u20 = p16 or 1;
    local u21 = p17 or 0.5;
    local u22 = p18 or 0;
    local v23, v24 = u15:GetBoundingBox();
    u15.WorldPivot = v23 * CFrame.new(0, -v24.Y / 2, 0);
    local u25 = u15:GetPivot();
    local u26 = os.clock();
    local u27 = u7:NextNumber(0, 6.283185307179586);
    local u28 = u7:NextInteger(0, 1) == 0 and 1 or -1;
    local u29 = nil;
    u29 = RunService.Heartbeat:Connect(function() -- Line: 159
        -- upvalues: u15 (copy), u29 (ref), u8 (ref), u26 (copy), u21 (ref), u20 (ref), u28 (copy), u7 (ref), u22 (ref), u25 (copy), u27 (copy)
        if not u15.Parent then
            u29:Disconnect();
            u8[u15] = nil;

            return;
        end;

        local v30 = os.clock() - u26;
        local v31 = math.clamp(v30 / u21, 0, 1);
        local v32 = 1 - v31;
        local v33 = math.sin(v30 * 25) * 0.2617993877991494 * u20 * v32 * u28;
        u15:PivotTo(u25 * CFrame.new(u7:NextNumber(-1, 1) * u22 * u20 * v32, 0, u7:NextNumber(-1, 1) * u22 * u20 * v32) * CFrame.Angles(0, u27, 0) * CFrame.Angles(0, 0, v33) * CFrame.Angles(0, -u27, 0));

        if v31 >= 1 then
            u15:PivotTo(u25);
            u29:Disconnect();
            u8[u15] = nil;
        end;
    end);
    u8[u15] = {
        Connection = u29,
        StartPivot = u25
    };
end;

local function ScaleUp(u34, u35, u36, p37) -- Line: 188
    -- upvalues: u8 (copy), RunService (copy), TweenService (copy)
    local v38 = u8[u34];

    if v38 then
        v38.Connection:Disconnect();

        if u34.Parent then
            u34:PivotTo(v38.StartPivot);
        end;

        u8[u34] = nil;
    end;

    local u39 = p37 or Enum.EasingStyle.Exponential;
    local v40, v41 = u34:GetBoundingBox();
    local u42 = v40.Position.Y - v41.Y / 2;
    local u43 = u34:GetScale();
    local u44 = os.clock();
    local u45 = nil;
    u45 = RunService.Heartbeat:Connect(function() -- Line: 197
        -- upvalues: u34 (copy), u45 (ref), u44 (copy), u36 (copy), TweenService (ref), u39 (ref), u43 (copy), u35 (copy), u42 (copy)
        if not u34.Parent then
            u45:Disconnect();

            return;
        end;

        local v46 = (os.clock() - u44) / u36;
        local v47 = math.clamp(v46, 0, 1);
        local v48 = TweenService:GetValue(v47, u39, Enum.EasingDirection.Out);
        u34:ScaleTo(u43 + (u35 - u43) * v48);
        local v49, v50 = u34:GetBoundingBox();
        local v51 = v49.Position.Y - v50.Y / 2;
        u34:PivotTo(u34:GetPivot() + Vector3.new(0, u42 - v51, 0));

        if v47 >= 1 then
            u45:Disconnect();
        end;
    end);
end;

local function ScaleUpInstant(p52, p53) -- Line: 216
    -- upvalues: u8 (copy)
    local v54 = u8[p52];

    if v54 then
        v54.Connection:Disconnect();

        if p52.Parent then
            p52:PivotTo(v54.StartPivot);
        end;

        u8[p52] = nil;
    end;

    local v55, v56 = p52:GetBoundingBox();
    local v57 = v55.Position.Y - v56.Y / 2;
    p52:ScaleTo(p53);
    local v58, v59 = p52:GetBoundingBox();
    local v60 = v58.Position.Y - v59.Y / 2;
    p52:PivotTo(p52:GetPivot() + Vector3.new(0, v57 - v60, 0));
end;

local function ConfigureVfxPart(p61) -- Line: 251
    p61.Anchored = true;
    p61.CanCollide = false;
    p61.CanQuery = false;
    p61.CanTouch = false;
    p61.Massless = true;
    p61.Transparency = 1;
end;

local function WrapAsScalableModel(p62) -- Line: 260
    if p62:IsA("Model") then
        local v63 = not p62.PrimaryPart and p62:FindFirstChildWhichIsA("BasePart", true);

        if v63 then
            p62.PrimaryPart = v63;
        end;

        for _, descendant in p62:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Massless = true;
                descendant.Transparency = 1;
            end;
        end;

        return p62;
    end;

    local Model = Instance.new("Model");

    if p62:IsA("BasePart") then
        p62.Anchored = true;
        p62.CanCollide = false;
        p62.CanQuery = false;
        p62.CanTouch = false;
        p62.Massless = true;
        p62.Transparency = 1;
        p62.Parent = Model;
        Model.PrimaryPart = p62;

        return Model;
    end;

    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0.1, 0.1, 0.1);
    Part.Parent = Model;
    Model.PrimaryPart = Part;

    for _, child in p62:GetChildren() do
        child.Parent = Part;
    end;

    return Model;
end;

local function CreateScaledVfxClone(p64, p65, p66) -- Line: 298
    -- upvalues: WrapAsScalableModel (copy)
    local v67 = WrapAsScalableModel((p64:Clone()));

    if not v67.PrimaryPart then
        v67:Destroy();

        return nil;
    end;

    local v68 = p65:GetScale();

    if math.abs(v68 - 1) > 0.001 then
        v67:ScaleTo(v68);
    end;

    v67:PivotTo(p66);
    v67.Parent = p65;

    return v67;
end;

local function GetMaxParticleLifetime(p69) -- Line: 316
    local v70 = 1;

    for _, v in p69 do
        v70 = math.max(v70, v.Lifetime.Max);
    end;

    return v70 + 0.5;
end;

local function AddEmitter(p71, p72) -- Line: 324
    if table.find(p71, p72) then
        return;
    end;

    table.insert(p71, p72);
end;

local function CollectLevelEmitters(p73, p74) -- Line: 331
    local v75 = `Level{p74}`;
    local v76 = {};

    if p73.Name == v75 then
        if p73:IsA("ParticleEmitter") and not table.find(v76, p73) then
            table.insert(v76, p73);
        end;

        for _, descendant in p73:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                if not table.find(v76, descendant) then
                    table.insert(v76, descendant);
                end;
            end;
        end;

        return v76;
    end;

    local v77 = p73:FindFirstChild(v75);

    if v77 then
        if v77:IsA("ParticleEmitter") and not table.find(v76, v77) then
            table.insert(v76, v77);
        end;

        for _, descendant in v77:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                if not table.find(v76, descendant) then
                    table.insert(v76, descendant);
                end;
            end;
        end;
    end;

    for _, descendant in p73:GetDescendants() do
        if descendant:IsA("ParticleEmitter") and descendant.Name == v75 then
            if not table.find(v76, descendant) then
                table.insert(v76, descendant);
            end;
        end;
    end;

    return v76;
end;

local function EmitLevelParticles(p78) -- Line: 368
    -- upvalues: GetInstancePath (copy)
    for _, v in p78 do
        if v.Parent then
            local v79 = v:GetAttribute("EmitCount");
            local v80 = type(v79) ~= "number" and 1 or v79;
            ("Emitting %* from %* Enabled=%*"):format(v80, GetInstancePath(v), v.Enabled);
            v:Emit(v80);
        else
            ("Skipping emit, no parent: %*"):format((GetInstancePath(v)));
        end;
    end;
end;

local function PlayPopVFX(p81, p82) -- Line: 381
    -- upvalues: GetInstancePath (copy), Assets (copy), DescribeChildren (copy), CreateScaledVfxClone (copy), CollectLevelEmitters (copy), EmitLevelParticles (copy), Debris (copy)
    ("Start level=%* egg=%*"):format(p82, (p81:GetFullName()));
    local v83 = p81.PrimaryPart or p81:FindFirstChildWhichIsA("BasePart");

    if not v83 then
        return;
    end;

    ("Root part: %* eggScale=%*"):format(GetInstancePath(v83), (p81:GetScale()));
    local EggEffects = Assets:FindFirstChild("EggEffects");

    if not EggEffects then
        return;
    end;

    local EggEffects2 = Assets:FindFirstChild("EggEffects");
    local v84;

    if EggEffects2 then
        v84 = EggEffects2:FindFirstChild("GrowEffects");
    else
        v84 = nil;
    end;

    if not v84 then
        ("Abort: EggEffects.GrowEffects missing. EggEffects children: %*"):format((DescribeChildren(EggEffects)));

        return;
    end;

    ("GrowEffects template: %* (%*) children: %*"):format(GetInstancePath(v84), v84.ClassName, (DescribeChildren(v84)));
    local v85 = CreateScaledVfxClone(v84, p81, v83.CFrame);

    if not v85 then
        return;
    end;

    ("Scaled VFX clone to %* at %* (%*)"):format(p81:GetScale(), GetInstancePath(v85), v85.ClassName);
    local u86 = CollectLevelEmitters(v85, p82);

    if #u86 == 0 then
        ("Abort: no Level%* ParticleEmitters in scaled GrowEffects clone"):format(p82);
        local v87 = {};

        for _, descendant in v84:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                local v88 = `{GetInstancePath(descendant)} EmitCount={descendant:GetAttribute("EmitCount")}`;
                table.insert(v87, v88);
            end;
        end;

        if #v87 ~= 0 then
            ("GrowEffects ParticleEmitters: %*"):format((table.concat(v87, " | ")));
        end;

        v85:Destroy();

        return;
    end;

    for _, v in u86 do
        ("Queued emitter: %* parent=%*"):format(GetInstancePath(v), not v.Parent and "nil" or v.Parent:GetFullName());
    end;

    task.spawn(function() -- Line: 438
        -- upvalues: u86 (copy), EmitLevelParticles (ref)
        task.wait();
        ("Emitting %* emitter(s)"):format(#u86);
        EmitLevelParticles(u86);
    end);
    local v89 = 1;

    for _, v in u86 do
        v89 = math.max(v89, v.Lifetime.Max);
    end;

    local v90 = v89 + 0.5;
    ("Scheduling cleanup in %*s for scaled VFX clone"):format(v90);
    Debris:AddItem(v85, v90);
end;

local function lerp(p91, p92, p93) -- Line: 464
    return p91 + (p92 - p91) * p93;
end;

local function EggSwell(u94, p95, p96) -- Line: 468
    -- upvalues: ScaleUpInstant (copy), u7 (copy), SpiralTrail (copy), TweenService (copy)
    local Highlight = u94:FindFirstChild("Highlight", true);
    local v97 = u94:GetScale();
    local v98 = v97 * 0.7;
    ScaleUpInstant(u94, v97);
    local v99 = u94:GetPivot();
    local v100 = v99 * CFrame.new(0, 4, 0);
    local Angles = CFrame.Angles;
    local v101 = u7:NextNumber(-180, 180);
    local v102 = v100 * Angles(0, math.rad(v101), 0);
    task.delay(0.5, function() -- Line: 487
        -- upvalues: SpiralTrail (ref), u94 (copy)
        SpiralTrail.Init(u94.PrimaryPart, {
            Size = 0.4,
            Offset = 2,
            Time = 0.2,
            Frequency = 1,
            Color = Color3.fromRGB(255, 255, 255)
        });
    end);
    local v103 = 0;

    while v103 < 1.8 do
        v103 = v103 + game:GetService("RunService").Heartbeat:Wait();
        local v104 = (math.sin(v103 / 1.8 * 6.283185307179586) + 1) / 2;
        local v105 = CFrame.Angles(0, math.rad(v104 * (v103 / 1.8 * 360 * 5)), 0);
        local v106 = CFrame.new(u7:NextNumber(-1, 1) * p96 * v103 / 1.8, u7:NextNumber(-1, 1) * p96 * v103 / 1.8, u7:NextNumber(-1, 1) * p96 * v103 / 1.8);

        if v103 < 1.4 then
            u94:PivotTo(v99:Lerp(v102, (TweenService:GetValue(v103 / 1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In))) * v106 * v105);
        else
            u94:PivotTo(v102:Lerp(v99, (TweenService:GetValue((v103 - 1.4) / 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In))) * v106 * v105);
        end;

        if v103 > 0.4 and v103 < 1 then
            local v107 = TweenService:GetValue(v103 - 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
            ScaleUpInstant(u94, v97 + (v98 - v97) * v107);
        elseif v103 > 1 then
            local v108 = TweenService:GetValue((v103 - 1) / 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.InOut);
            ScaleUpInstant(u94, v98 + (p95 - v98) * v108);
        end;

        if v103 < 0.6 then
            Highlight.FillTransparency = TweenService:GetValue(v103 / 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut) * -1 + 1;
            Highlight.OutlineTransparency = TweenService:GetValue(v103 / 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut) * -0.5 + 1;
        elseif v103 > 1 then
            local v109 = v103 - 1.4;
            Highlight.FillTransparency = TweenService:GetValue(v109 / 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut) * 1 + 0;
            Highlight.OutlineTransparency = TweenService:GetValue(v109 / 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut) * 0.5 + 0.5;
        end;
    end;
end;

local function WobbleAndWait(p110, p111, p112, p113, p114) -- Line: 582
    -- upvalues: Wobble (copy), u8 (copy)
    local v115 = p110:GetScale() - 1;
    local v116 = math.abs(v115) > 0.001;

    if not v116 then
        p110:PivotTo(p111);
    end;

    Wobble(p110, p112, p113, p114);
    task.wait(p113);
    local v117 = u8[p110];

    if v117 then
        v117.Connection:Disconnect();

        if p110.Parent then
            p110:PivotTo(v117.StartPivot);
        end;

        u8[p110] = nil;
    end;

    if not v116 then
        p110:PivotTo(p111);
    end;
end;

local function NotifyWobbleBeat(p118, p119) -- Line: 604
    p118.index = p118.index + 1;

    if p119 and p119.onWobbleBeat then
        p119.onWobbleBeat(p118.index);
    end;
end;

local function NotifyGrowStart(p120, p121, p122) -- Line: 611
    if p120 and p120.onGrowStart then
        p120.onGrowStart(p121, p122);
    end;
end;

local function NotifyGrowBeat(p123, p124, p125) -- Line: 617
    if p123 and p123.onGrowBeat then
        p123.onGrowBeat(p124, p125);
    end;
end;

local function PlayWobbleBeat(p126, p127, p128, p129, p130, p131, p132, p133) -- Line: 623
    -- upvalues: WobbleAndWait (copy)
    if not p133 then
        task.wait(p129 or 0.5);
    end;

    if p131 then
        p131();
    end;

    WobbleAndWait(p126, p127, p128.Intensity, p128.Duration, p128.Shake);
    p130.index = p130.index + 1;

    if p132 and p132.onWobbleBeat then
        p132.onWobbleBeat(p130.index);
    end;
end;

local function PlayWobbleBeats(p134, p135, p136, p137, p138, p139, p140, p141) -- Line: 643
    -- upvalues: WobbleAndWait (copy)
    for i, v in p136 do
        local v142;

        if p141 then
            v142 = i == 1;
        else
            v142 = p141;
        end;

        if not v142 then
            task.wait(p137 or 0.5);
        end;

        if p139 then
            p139();
        end;

        WobbleAndWait(p134, p135, v.Intensity, v.Duration, v.Shake);
        p138.index = p138.index + 1;

        if p140 and p140.onWobbleBeat then
            p140.onWobbleBeat(p138.index);
        end;
    end;
end;

local function PlayPreGrowWobbles(p143, p144, p145, p146, p147, p148, p149, p150, p151) -- Line: 667
    -- upvalues: WobbleAndWait (copy)
    if #p145 == 0 then
        if p151 then
            if math.random() >= 0.15 then
                p151();

                return;
            end;

            p147.index = p147.index + 1;

            if p149 and p149.onWobbleBeat then
                p149.onWobbleBeat(p147.index);
            end;
        end;

        return;
    end;

    for i = 1, #p145 - 1 do
        local v152 = p145[i];
        local v153;

        if p150 then
            v153 = i == 1;
        else
            v153 = p150;
        end;

        if not v153 then
            task.wait(p146 or 0.5);
        end;

        if p148 then
            p148();
        end;

        WobbleAndWait(p143, p144, v152.Intensity, v152.Duration, v152.Shake);
        p147.index = p147.index + 1;

        if p149 and p149.onWobbleBeat then
            p149.onWobbleBeat(p147.index);
        end;
    end;

    if p151 then
        local v154 = p145[#p145];

        if p150 then
            p150 = #p145 == 1;
        end;

        if not p150 then
            task.wait(p146 or 0.5);
        end;

        if p148 then
            p148();
        end;

        WobbleAndWait(p143, p144, v154.Intensity, v154.Duration, v154.Shake);
        p147.index = p147.index + 1;

        if p149 and p149.onWobbleBeat then
            p149.onWobbleBeat(p147.index);
        end;

        if math.random() >= 0.15 then
            p151();

            return;
        end;

        p147.index = p147.index + 1;

        if p149 and p149.onWobbleBeat then
            p149.onWobbleBeat(p147.index);
        end;
    elseif math.random() >= 0.15 then
        local v155 = p145[#p145];

        if p150 then
            p150 = #p145 == 1;
        end;

        if not p150 then
            task.wait(p146 or 0.5);
        end;

        if p148 then
            p148();
        end;

        WobbleAndWait(p143, p144, v155.Intensity, v155.Duration, v155.Shake);
        p147.index = p147.index + 1;

        if p149 and p149.onWobbleBeat then
            p149.onWobbleBeat(p147.index);
        end;
    else
        p147.index = p147.index + 1;

        if p149 and p149.onWobbleBeat then
            p149.onWobbleBeat(p147.index);
        end;
    end;
end;

local function PlayNearMissWobbleChain(p156, p157, p158, p159, p160, p161, p162) -- Line: 735
    -- upvalues: u7 (copy), WobbleAndWait (copy)
    local v163;

    if p158.PreDelayMin and p158.PreDelayMax then
        v163 = u7:NextNumber(p158.PreDelayMin, p158.PreDelayMax);
        task.wait(v163 or 0.5);
    else
        v163 = nil;
    end;

    local Spec = p158.Spec;
    task.wait(p159 or 0.5);

    if p161 then
        p161();
    end;

    WobbleAndWait(p156, p157, Spec.Intensity, Spec.Duration, Spec.Shake);
    p160.index = p160.index + 1;

    if p162 and p162.onWobbleBeat then
        p162.onWobbleBeat(p160.index);
    end;

    if p158.FollowUpSpec then
        if v163 then
            task.wait(v163 or 0.5);
        end;

        local FollowUpSpec = p158.FollowUpSpec;
        task.wait(p159 or 0.5);

        if p161 then
            p161();
        end;

        WobbleAndWait(p156, p157, FollowUpSpec.Intensity, FollowUpSpec.Duration, FollowUpSpec.Shake);
        p160.index = p160.index + 1;

        if p162 and p162.onWobbleBeat then
            p162.onWobbleBeat(p160.index);
        end;

        if p158.PostDelay then
            task.wait(p158.PostDelay or 0.5);
        end;
    elseif p158.PostDelay then
        task.wait(p158.PostDelay or 0.5);
    end;
end;

local function PlayChanceWobbleBeat(p164, p165, p166, p167, p168, p169, p170) -- Line: 773
    -- upvalues: PlayNearMissWobbleChain (copy)
    if math.random() > p166.Chance then
        return;
    end;

    PlayNearMissWobbleChain(p164, p165, p166, p167, p168, p169, p170);
end;

local function PlaySharedOpeningPhase(p171, p172, p173, p174, p175) -- Line: 796
    -- upvalues: PlayWobbleBeats (copy), u5 (copy), PlayNearMissWobbleChain (copy), u6 (copy)
    local v176 = {
        index = 0
    };
    PlayWobbleBeats(p171, p172, u5, 0.5, v176, p173, p174, true);

    if p175 then
        PlayNearMissWobbleChain(p171, p172, u6, 0.5, v176, p173, p174);

        return v176;
    end;

    local v177 = u6;

    if math.random() > v177.Chance then
        return v176;
    end;

    PlayNearMissWobbleChain(p171, p172, v177, 0.5, v176, p173, p174);

    return v176;
end;

local function PlayPostFirstGrowFakeOutPhase(p178, p179, p180, p181, p182, p183) -- Line: 842
    -- upvalues: PlayWobbleBeats (copy), u1 (copy), u2 (copy), PlayNearMissWobbleChain (copy), u6 (copy)
    PlayWobbleBeats(p178, p179, { u1, u2 }, 0.7, p180, p181, p182);

    if p183 then
        PlayNearMissWobbleChain(p178, p179, u6, 0.5, p180, p181, p182);

        return;
    end;

    local v184 = u6;

    if math.random() > v184.Chance then
        return;
    end;

    PlayNearMissWobbleChain(p178, p179, v184, 0.5, p180, p181, p182);
end;

local function PlayGrowBeat(p185, p186, p187, p188, p189) -- Line: 886
    -- upvalues: EggSwell (copy), PlayPopVFX (copy)
    task.wait(p188 or 0.5);

    if p189 and p189.onGrowStart then
        p189.onGrowStart(p187, p186);
    end;

    if p187 == 1 then
        EggSwell(p185, p186, 0);
    elseif p187 == 2 then
        EggSwell(p185, p186, 0.2);
    end;

    PlayPopVFX(p185, p187);

    if p189 and p189.onGrowBeat then
        p189.onGrowBeat(p187, p186);
    end;
end;

local function RunNearMissStage(p190, p191, p192, p193, p194, p195, p196) -- Line: 899
    -- upvalues: WobbleAndWait (copy), EggSwell (copy), PlayPopVFX (copy), RunNearMissStage (copy)
    if math.random() > p192.Chance then
        return;
    end;

    if p192.Wobble and (p192.ScaleUp and p192.WobbleAfterScale) then
        if math.random() >= 0.15 then
            local Wobble2 = p192.Wobble;
            task.wait(p193 or 0.5);

            if p195 then
                p195();
            end;

            WobbleAndWait(p190, p191, Wobble2.Intensity, Wobble2.Duration, Wobble2.Shake);
            p194.index = p194.index + 1;

            if p196 and p196.onWobbleBeat then
                p196.onWobbleBeat(p194.index);
            end;

            task.wait(p193 or 0.5);
        else
            p194.index = p194.index + 1;

            if p196 and p196.onWobbleBeat then
                p196.onWobbleBeat(p194.index);
            end;
        end;

        local Scale = p192.ScaleUp.Scale;
        local VfxLevel = p192.ScaleUp.VfxLevel;

        if VfxLevel == 1 then
            EggSwell(p190, Scale, 0);
        elseif VfxLevel == 2 then
            EggSwell(p190, Scale, 0.2);
        end;

        PlayPopVFX(p190, VfxLevel);
        local VfxLevel2 = p192.ScaleUp.VfxLevel;
        local Scale2 = p192.ScaleUp.Scale;

        if p196 and p196.onGrowBeat then
            p196.onGrowBeat(VfxLevel2, Scale2);
        end;

        local WobbleAfterScale = p192.WobbleAfterScale;
        task.wait(p193 or 0.5);

        if p195 then
            p195();
        end;

        WobbleAndWait(p190, p191, WobbleAfterScale.Intensity, WobbleAfterScale.Duration, WobbleAfterScale.Shake);
        p194.index = p194.index + 1;

        if p196 and p196.onWobbleBeat then
            p196.onWobbleBeat(p194.index);
        end;
    elseif p192.Wobble then
        local Wobble2 = p192.Wobble;
        task.wait(p193 or 0.5);

        if p195 then
            p195();
        end;

        WobbleAndWait(p190, p191, Wobble2.Intensity, Wobble2.Duration, Wobble2.Shake);
        p194.index = p194.index + 1;

        if p196 and p196.onWobbleBeat then
            p196.onWobbleBeat(p194.index);
        end;
    end;

    if p192.Nested then
        RunNearMissStage(p190, p191, p192.Nested, p193, p194, p195, p196);
    end;
end;

return table.freeze({
    GROW_SCALE_1 = 2,
    GROW_SCALE_2 = 4,
    GROW_SCALE_3 = 6,
    GROW_STEP_MULT = 2,

    ResolveHatchTargetScale = function(p197, p198) -- Line: 1038, Name: ResolveHatchTargetScale
        return p197 == "Huge" and 6 or (p197 == "Big" and 4 or p198 * 2);
    end,

    NormalPreHatchConfig = {
        InitialWobbles = u5,
        OptionalWobble = u6
    },

    StopWobble = function(p199) -- Line: 133, Name: StopWobble
        -- upvalues: u8 (copy)
        local v200 = u8[p199];

        if v200 then
            v200.Connection:Disconnect();

            if p199.Parent then
                p199:PivotTo(v200.StartPivot);
            end;

            u8[p199] = nil;
        end;
    end,

    Wobble = Wobble,
    ScaleUp = ScaleUp,
    ScaleUpInstant = ScaleUpInstant,

    PopupFadeEffect = function(p201, p202, p203) -- Line: 228, Name: PopupFadeEffect
        -- upvalues: ScaleUp (copy), TweenService (copy), Debris (copy)
        local v204 = p201:GetScale();
        local v205 = p201:GetPivot();
        local v206 = p201:Clone();
        v206:ScaleTo(v204);
        v206:PivotTo(v205);
        v206.Parent = p201.Parent or workspace;
        ScaleUp(v206, p202, 0.5);
        local v207 = TweenInfo.new(p203, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0);

        for _, descendant in v206:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false;
                local v208 = TweenService:Create(descendant, v207, {
                    Transparency = 1
                });
                v208:Play();
                Debris:AddItem(v208, v207.Time);
            end;
        end;

        Debris:AddItem(v206, v207.Time);
    end,

    PlayPopVFX = PlayPopVFX,

    HighlightFlash = function(p209, p210) -- Line: 449, Name: HighlightFlash
        -- upvalues: TweenService (copy), Debris (copy)
        local v211 = TweenInfo.new(p210, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
        local Highlight = Instance.new("Highlight");
        Highlight.OutlineTransparency = 1;
        Highlight.FillColor = Color3.new(1, 1, 1);
        Highlight.FillTransparency = 0;
        Highlight.Parent = p209;
        Highlight.Adornee = p209;
        local v212 = TweenService:Create(Highlight, v211, {
            FillTransparency = 1
        });
        v212:Play();
        Debris:AddItem(v212, v211.Time);
        Debris:AddItem(Highlight, v211.Time);
    end,

    PlayNearMissScale = function(p213, p214, p215) -- Line: 558, Name: PlayNearMissScale
        -- upvalues: EggSwell (copy), PlayPopVFX (copy)
        if p215 == 1 then
            EggSwell(p213, p214, 0);
        elseif p215 == 2 then
            EggSwell(p213, p214, 0.2);
        end;

        PlayPopVFX(p213, p215);
    end,

    Pause = function(p216) -- Line: 578, Name: Pause
        task.wait(p216 or 0.5);
    end,

    WobbleAndWait = WobbleAndWait,

    ResetToLand = function(p217, p218) -- Line: 595, Name: ResetToLand
        -- upvalues: u8 (copy)
        local v219 = u8[p217];

        if v219 then
            v219.Connection:Disconnect();

            if p217.Parent then
                p217:PivotTo(v219.StartPivot);
            end;

            u8[p217] = nil;
        end;

        local v220 = p217:GetScale() - 1;

        if math.abs(v220) <= 0.001 then
            p217:PivotTo(p218);
        end;
    end,

    RunPreHatchSequence = function(p221, p222, p223, p224, p225) -- Line: 939, Name: RunPreHatchSequence
        -- upvalues: WobbleAndWait (copy), PlayNearMissWobbleChain (copy), RunNearMissStage (copy), u8 (copy)
        local v226 = p223.Pause or 0.5;
        local v227 = {
            index = 0
        };

        for i, v in p223.InitialWobbles do
            if i ~= 1 then
                task.wait(v226 or 0.5);
            end;

            if p224 then
                p224();
            end;

            WobbleAndWait(p221, p222, v.Intensity, v.Duration, v.Shake);
            v227.index = v227.index + 1;

            if p225 and p225.onWobbleBeat then
                p225.onWobbleBeat(v227.index);
            end;
        end;

        if p223.OptionalWobble then
            local OptionalWobble = p223.OptionalWobble;

            if math.random() <= OptionalWobble.Chance then
                PlayNearMissWobbleChain(p221, p222, OptionalWobble, v226, v227, p224, p225);
            end;
        end;

        if p223.NearMiss then
            RunNearMissStage(p221, p222, p223.NearMiss, v226, v227, p224, p225);
        end;

        task.wait(v226 or 0.5);
        local v228 = u8[p221];

        if v228 then
            v228.Connection:Disconnect();

            if p221.Parent then
                p221:PivotTo(v228.StartPivot);
            end;

            u8[p221] = nil;
        end;

        local v229 = p221:GetScale() - 1;

        if math.abs(v229) <= 0.001 then
            p221:PivotTo(p222);
        end;
    end,

    RunBigPreHatchSequence = function(p230, p231, p232, p233) -- Line: 982, Name: RunBigPreHatchSequence
        -- upvalues: PlayWobbleBeats (copy), u5 (copy), PlayNearMissWobbleChain (copy), u6 (copy), EggSwell (copy), PlayPopVFX (copy), u1 (copy), u2 (copy), u8 (copy)
        local v234 = {
            index = 0
        };
        PlayWobbleBeats(p230, p231, u5, 0.5, v234, p232, p233, true);
        PlayNearMissWobbleChain(p230, p231, u6, 0.5, v234, p232, p233);
        task.wait(0.5);

        if p233 and p233.onGrowStart then
            p233.onGrowStart(1, 2);
        end;

        EggSwell(p230, 2, 0);
        PlayPopVFX(p230, 1);

        if p233 and p233.onGrowBeat then
            p233.onGrowBeat(1, 2);
        end;

        PlayWobbleBeats(p230, p231, { u1, u2 }, 0.7, v234, p232, p233);
        local v235 = u6;

        if math.random() <= v235.Chance then
            PlayNearMissWobbleChain(p230, p231, v235, 0.5, v234, p232, p233);
        end;

        task.wait(0.5);
        local v236 = u8[p230];

        if v236 then
            v236.Connection:Disconnect();

            if p230.Parent then
                p230:PivotTo(v236.StartPivot);
            end;

            u8[p230] = nil;
        end;

        local v237 = p230:GetScale() - 1;

        if math.abs(v237) <= 0.001 then
            p230:PivotTo(p231);
        end;
    end,

    RunHugePreHatchSequence = function(p238, p239, p240, p241) -- Line: 998, Name: RunHugePreHatchSequence
        -- upvalues: PlayWobbleBeats (copy), u5 (copy), PlayNearMissWobbleChain (copy), u6 (copy), EggSwell (copy), PlayPopVFX (copy), u1 (copy), u2 (copy), u3 (copy), u4 (copy), u8 (copy)
        local v242 = {
            index = 0
        };
        PlayWobbleBeats(p238, p239, u5, 0.5, v242, p240, p241, true);
        PlayNearMissWobbleChain(p238, p239, u6, 0.5, v242, p240, p241);
        task.wait(0.5);

        if p241 and p241.onGrowStart then
            p241.onGrowStart(1, 2);
        end;

        EggSwell(p238, 2, 0);
        PlayPopVFX(p238, 1);

        if p241 and p241.onGrowBeat then
            p241.onGrowBeat(1, 2);
        end;

        PlayWobbleBeats(p238, p239, { u1, u2 }, 0.7, v242, p240, p241);
        PlayNearMissWobbleChain(p238, p239, u6, 0.5, v242, p240, p241);
        task.wait(0.5);

        if p241 and p241.onGrowStart then
            p241.onGrowStart(2, 4);
        end;

        EggSwell(p238, 4, 0.2);
        PlayPopVFX(p238, 2);

        if p241 and p241.onGrowBeat then
            p241.onGrowBeat(2, 4);
        end;

        PlayWobbleBeats(p238, p239, { u3, u4 }, 0.9, v242, p240, p241);
        task.wait(0.5);
        local v243 = u8[p238];

        if v243 then
            v243.Connection:Disconnect();

            if p238.Parent then
                p238:PivotTo(v243.StartPivot);
            end;

            u8[p238] = nil;
        end;

        local v244 = p238:GetScale() - 1;

        if math.abs(v244) <= 0.001 then
            p238:PivotTo(p239);
        end;
    end
});