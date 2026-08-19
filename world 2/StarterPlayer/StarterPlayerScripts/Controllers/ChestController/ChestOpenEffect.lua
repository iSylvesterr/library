-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RarityVisuals = require(ReplicatedStorage.SharedModules.RarityVisuals);
local u1 = {};
local u2 = {};
local Players = game:GetService("Players");

local function FindGround(p3) -- Line: 29
    -- upvalues: Players (copy)
    local v4 = RaycastParams.new();
    v4.FilterType = Enum.RaycastFilterType.Exclude;
    local v5 = {};

    for _, v in Players:GetPlayers() do
        if v.Character then
            table.insert(v5, v.Character);
        end;
    end;

    v4.FilterDescendantsInstances = v5;
    local v6 = workspace:Raycast(p3 + Vector3.new(0, 10, 0), Vector3.new(0, -25, 0), v4);

    if v6 and v6.Instance.Transparency < 1 then
        return v6.Position;
    end;

    return nil;
end;

local function HasPositionConflict(p7) -- Line: 55
    -- upvalues: u2 (copy)
    for _, v in u2 do
        if (p7 - v).Magnitude <= 10 then
            return true;
        end;
    end;

    return false;
end;

function u1.FindDropPosition(p8) -- Line: 69
    -- upvalues: FindGround (copy), u2 (copy)
    local Character = p8.Character;

    if not Character then
        return nil;
    end;

    if not Character.PrimaryPart then
        return nil;
    end;

    local v9 = Character:GetPivot();
    local Position = v9.Position;
    local _, v10, _ = v9:ToOrientation();
    local v11 = v10 + 1.5707963267948966;

    for i = 10, 30 do
        for i2 = 0, 180, 15 do
            for _, v in { -1, 1 } do
                local v12 = math.rad(i2 * v) - v11;
                local v13 = i * math.cos(v12);
                local v14 = i * math.sin(v12);
                local v15 = FindGround(Position + Vector3.new(v13, 0, v14));

                if v15 then
                    local v16 = false;

                    for _, v2 in u2 do
                        if (v15 - v2).Magnitude <= 10 then
                            v16 = true;
                            break;
                        end;
                    end;

                    if not v16 then
                        return v15;
                    end;
                end;
            end;
        end;
    end;

    return nil;
end;

local function ExpoInOut(p17) -- Line: 115
    if p17 == 0 then
        return 0;
    end;

    if p17 == 1 then
        return 1;
    end;

    local v18 = p17 * 2;

    if v18 < 1 then
        return math.pow(2, (v18 - 1) * 10) * 0.5 - 0.0005;
    end;

    return (-math.pow(2, (v18 - 1) * -10) + 2) * 0.50025;
end;

local function ExpoIn(p19) -- Line: 128
    return p19 == 0 and 0 or math.pow(2, (p19 - 1) * 10) - 0.001;
end;

local function BounceOut(p20) -- Line: 133
    if p20 < 0.36363636363636365 then
        return p20 * 7.5625 * p20;
    end;

    if p20 < 0.7272727272727273 then
        local v21 = p20 - 0.5454545454545454;

        return v21 * 7.5625 * v21 + 0.75;
    end;

    if p20 < 0.9090909090909091 then
        local v22 = p20 - 0.8181818181818182;

        return v22 * 7.5625 * v22 + 0.9375;
    end;

    local v23 = p20 - 0.9545454545454546;

    return v23 * 7.5625 * v23 + 0.984375;
end;

local function QuadOut(p24) -- Line: 141
    return p24 * -1 * (p24 - 2);
end;

local u25 = 0;

local function RenderFor(u26, u27) -- Line: 149
    -- upvalues: u25 (ref), RunService (copy)
    u25 = u25 + 1;
    local u28 = ("ChestRS_%d"):format(u25);
    local u29 = 0;
    local u30 = false;
    RunService:BindToRenderStep(u28, Enum.RenderPriority.Last.Value, function(p31) -- Line: 159
        -- upvalues: u30 (ref), u29 (ref), u27 (copy), u26 (copy), RunService (ref), u28 (copy)
        if u30 then
            return;
        end;

        u29 = math.min(u29 + p31, u27);

        if u26(p31, (math.clamp(u29 / u27, 0, 1))) or u27 <= u29 then
            u30 = true;
            RunService:UnbindFromRenderStep(u28);
        end;
    end);

    while not u30 do
        task.wait();
    end;
end;

local function Bezier(u32, u33, u34) -- Line: 181
    return function(p35) -- Line: 182
        -- upvalues: u32 (copy), u33 (copy), u34 (copy)
        local v36 = 1 - p35;

        return v36 * v36 * u32 + v36 * 2 * p35 * u33 + p35 * p35 * u34;
    end;
end;

local function AutoControlPoint(p37, p38) -- Line: 189
    local v39 = (p37 + p38) / 2;
    local Magnitude = ((p37 - p38) * Vector3.new(1, 0, 1)).Magnitude;
    local X = v39.X;
    local v40 = math.max(p37.Y, p38.Y) + Magnitude;

    return Vector3.new(X, v40, v39.Z);
end;

local function LookAtFlat(p41, p42) -- Line: 196
    local v43 = Vector3.new(p42.X, p41.Y, p42.Z);

    if (p41.Position - v43).Magnitude < 0.001 then
        return p41;
    end;

    return CFrame.lookAt(p41.Position, v43);
end;

local function SetModelAnchored(p44) -- Line: 207
    for _, descendant in p44:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CastShadow = false;
            descendant.CanQuery = false;
        end;
    end;
end;

local function SetChestAnchored(p45) -- Line: 219
    local PrimaryPart = p45.PrimaryPart;

    for _, descendant in p45:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = descendant == PrimaryPart;
            descendant.CanCollide = false;
            descendant.CastShadow = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
        end;
    end;
end;

local function PlayOpenAnimation(p46) -- Line: 235
    local v47 = p46:FindFirstChildWhichIsA("Animation", true);

    if not v47 then
        return nil;
    end;

    local v48 = p46:FindFirstChildWhichIsA("Animator", true);

    if not v48 then
        return nil;
    end;

    local u49 = v48:LoadAnimation(v47);
    u49.Priority = Enum.AnimationPriority.Action;
    u49.Looped = false;
    u49:Play();
    local v50 = 0;

    while u49.Length <= 0 and v50 < 2 do
        v50 = v50 + task.wait();
    end;

    local v51 = math.max(u49.Length - 0.05, 0);
    task.delay(v51, function() -- Line: 260
        -- upvalues: u49 (copy)
        if u49.IsPlaying then
            u49:AdjustSpeed(0);
        end;
    end);

    return u49;
end;

local function CaptureVisuals(p52) -- Line: 271
    local v53 = {};

    for _, descendant in p52:GetDescendants() do
        if descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
            table.insert(v53, {
                IsBeam = false,
                Object = descendant,
                Base = descendant.Transparency
            });
        elseif descendant:IsA("Beam") then
            table.insert(v53, {
                Base = 0,
                IsBeam = true,
                Object = descendant
            });
        end;
    end;

    return v53;
end;

local function ApplyFade(p54, p55) -- Line: 288
    for _, v in p54 do
        local v56 = v.Base + (1 - v.Base) * p55;

        if v.IsBeam then
            v.Object.Transparency = NumberSequence.new(v56);
        else
            v.Object.Transparency = v56;
        end;
    end;
end;

local function EmitAttachmentAt(p57, p58) -- Line: 302
    -- upvalues: Debris (copy)
    if not p58 then
        return;
    end;

    local v59 = p58:FindFirstChildWhichIsA("Attachment");

    if not v59 then
        return;
    end;

    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CastShadow = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0, 0, 0);
    Part.CFrame = p57;
    Part.Parent = workspace;
    local v60 = v59:Clone();
    v60.Parent = Part;
    local v61 = 0;

    for _, child in v60:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false;
            local v62 = child:GetAttribute("EmitCount") or child.Rate;
            child:Emit((math.ceil(v62)));
            v61 = math.max(v61, child.Lifetime.Max);
        end;
    end;

    Debris:AddItem(Part, v61 + 0.5);
end;

local function EnsurePrimaryPart(p63) -- Line: 344
    if p63.PrimaryPart then
        return;
    end;

    local Center = p63:FindFirstChild("Center");

    if Center then
        p63.PrimaryPart = Center;

        return;
    end;

    local v64 = p63:FindFirstChildWhichIsA("BasePart", true);

    if v64 then
        p63.PrimaryPart = v64;
    end;
end;

local function EmitAtPosition(p65, p66, p67, p68) -- Line: 370
    -- upvalues: Debris (copy)
    if not p66 then
        return;
    end;

    if typeof(p66) == "Instance" and p66:IsA("Folder") then
        p66 = p66:GetChildren();
    elseif type(p66) ~= "table" then
        return;
    end;

    if #p66 == 0 then
        return;
    end;

    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0, 0, 0);
    Part.CFrame = CFrame.new(p65);
    Part.Parent = workspace;
    local v69 = 0;

    for _, v in p66 do
        if v:IsA("ParticleEmitter") then
            local v70 = v:Clone();
            v70.Enabled = false;

            if p67 then
                v70.Color = ColorSequence.new(p67);
            end;

            v70.Parent = Part;
            local v71 = v70:GetAttribute("EmitCount") or v70.Rate;
            v70:Emit((math.ceil(v71)));
            v69 = math.max(v69, v70.Lifetime.Max);
        end;
    end;

    Debris:AddItem(Part, p68 or v69 + 0.5);
end;

local function PlaySound(p72, p73, p74) -- Line: 424
    -- upvalues: Debris (copy)
    if not p72 then
        return;
    end;

    local v75 = p72:Clone();

    if p74 then
        v75.Volume = p72.Volume * p74;
    end;

    v75.Parent = p73 or workspace;
    v75:Play();
    Debris:AddItem(v75, v75.TimeLength + 1);
end;

local function SetTrailsEnabled(p76, p77) -- Line: 442
    for _, v in p76 do
        if v:IsA("Trail") then
            v.Enabled = p77;
        end;

        for _, descendant in v:GetDescendants() do
            if descendant:IsA("Trail") then
                descendant.Enabled = p77;
            end;
        end;
    end;
end;

local u78 = UDim2.fromScale(5, 5);

local function CreateImageItem(p79, p80) -- Line: 462
    -- upvalues: u78 (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CastShadow = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.CFrame = p80;
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "ItemImageBillboard";
    BillboardGui.Size = u78;
    BillboardGui.StudsOffset = Vector3.new(0, 0, 0);
    BillboardGui.Adornee = Part;
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.Parent = Part;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ItemImage";
    ImageLabel.Image = p79;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Position = UDim2.fromScale(0, 0);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Parent = BillboardGui;

    return Part, 2.5;
end;

function u1.Play(p81) -- Line: 547
    -- upvalues: FindGround (copy), u1 (copy), u2 (copy), SetChestAnchored (copy), Debris (copy), RenderFor (copy), EmitAtPosition (copy), EmitAttachmentAt (copy), PlayOpenAnimation (copy), CreateImageItem (copy), SetModelAnchored (copy), LookAtFlat (copy), CaptureVisuals (copy), ApplyFade (copy), u78 (copy), RarityVisuals (copy), TweenService (copy)
    local Player = p81.Player;
    local v82 = p81.Sounds or {};
    local u83 = p81.GripAngles or CFrame.identity;
    local v84 = p81.IsBestItem == true and 2 or 1;
    local VFX = p81.VFX;
    local v85 = p81.Particles or {};
    local Impact = v85.Impact;

    if not Impact then
        if VFX then
            Impact = VFX:FindFirstChild("Impact");
        else
            Impact = nil;
        end;
    end;

    local Explosion = v85.Explosion;

    if not Explosion then
        if VFX then
            Explosion = VFX:FindFirstChild("Explosion");
        else
            Explosion = nil;
        end;
    end;

    local Trail = v85.Trail;

    if not Trail then
        if VFX then
            Trail = VFX:FindFirstChild("Trail");
        else
            Trail = nil;
        end;
    end;

    local u86;

    if p81.ItemImage == nil then
        u86 = false;
    else
        u86 = p81.ItemImage ~= "";
    end;

    local function GetPlayerPosition() -- Line: 567
        -- upvalues: Player (copy)
        local Character = Player.Character;

        return not (Character and Character.PrimaryPart) and Vector3.new(0, 10, 0) or Character.PrimaryPart.Position;
    end;

    local Character = Player.Character;
    local u87 = not (Character and Character.PrimaryPart) and Vector3.new(0, 10, 0) or Character.PrimaryPart.Position;
    local v88;

    if p81.Position and ((p81.Position - u87).Magnitude < 100 and p81.Position.Magnitude > 1) then
        v88 = FindGround(p81.Position);
    else
        v88 = nil;
    end;

    if not v88 then
        v88 = u1.FindDropPosition(Player);

        if not v88 then
            local Character2 = Player.Character;

            if Character2 and Character2.PrimaryPart then
                local v89 = Character2:GetPivot();
                local v90 = v89.Position + v89.LookVector * 6;
                v88 = FindGround(v90) or v90 + Vector3.new(0, -3, 0);
            else
                v88 = u87;
            end;
        end;
    end;

    table.insert(u2, v88);
    local u91 = p81.ChestModel:Clone();

    if not u91.PrimaryPart then
        local Center = u91:FindFirstChild("Center");

        if Center then
            u91.PrimaryPart = Center;
        else
            local v92 = u91:FindFirstChildWhichIsA("BasePart", true);

            if v92 then
                u91.PrimaryPart = v92;
            end;
        end;
    end;

    SetChestAnchored(u91);
    local v93 = u91:GetExtentsSize().Y / 2;
    local PrimaryPart = u91.PrimaryPart;
    local u94 = {};
    local v95;

    if Trail then
        local Attachment = Instance.new("Attachment");
        Attachment.Name = "TrailBottom";
        Attachment.Position = Vector3.new(0, -PrimaryPart.Size.Y / 2, 0);
        Attachment.Parent = PrimaryPart;
        local Attachment2 = Instance.new("Attachment");
        Attachment2.Name = "TrailTop";
        Attachment2.Position = Vector3.new(0, PrimaryPart.Size.Y / 2, 0);
        Attachment2.Parent = PrimaryPart;
        v95 = Trail:Clone();
        v95.Attachment0 = Attachment;
        v95.Attachment1 = Attachment2;
        v95.Lifetime = 0.5;
        v95.Enabled = false;
        v95.Parent = PrimaryPart;
        table.insert(u94, Attachment);
        table.insert(u94, Attachment2);
        table.insert(u94, v95);
    else
        v95 = nil;
    end;

    u91:PivotTo(CFrame.new(u87));
    u91:ScaleTo(0.001);
    u91.Parent = workspace;
    local Spawn = v82.Spawn;

    if Spawn then
        local v96 = Spawn:Clone();
        v96.Parent = PrimaryPart or workspace;
        v96:Play();
        Debris:AddItem(v96, v96.TimeLength + 1);
    end;

    if v95 then
        v95.Enabled = true;
    end;

    local u97 = Vector3.new(v88.X, v88.Y + v93, v88.Z);
    local v98 = (u87 + u97) / 2;
    local Magnitude = ((u87 - u97) * Vector3.new(1, 0, 1)).Magnitude;
    local X = v98.X;
    local v99 = math.max(u87.Y, u97.Y) + Magnitude;
    local u100 = Vector3.new(X, v99, v98.Z);

    local function u103(p101) -- Line: 182
        -- upvalues: u87 (copy), u100 (copy), u97 (copy)
        local v102 = 1 - p101;

        return v102 * v102 * u87 + v102 * 2 * p101 * u100 + p101 * p101 * u97;
    end;

    local v104 = CFrame.new(u97);
    local v105 = Vector3.new(u87.X, v104.Y, u87.Z);

    if (v104.Position - v105).Magnitude >= 0.001 then
        v104 = CFrame.lookAt(v104.Position, v105);
    end;

    RenderFor(function(p106, p107) -- Line: 673
        -- upvalues: u91 (copy), u103 (copy), u87 (copy), u83 (copy)
        local v108 = math.clamp(p107 * 2, 0, 1);
        local v109;

        if v108 == 0 then
            v109 = 0;
        elseif v108 == 1 then
            v109 = 1;
        else
            local v110 = v108 * 2;

            if v110 < 1 then
                v109 = math.pow(2, (v110 - 1) * 10) * 0.5 - 0.0005;
            else
                v109 = (-math.pow(2, (v110 - 1) * -10) + 2) * 0.50025;
            end;
        end;

        u91:ScaleTo(v109);
        local v111 = 1 - math.cos(p107 * 3.141592653589793 / 2);
        local v112 = CFrame.new(u103(v111));
        local v113 = u87;
        local v114 = Vector3.new(v113.X, v112.Y, v113.Z);

        if (v112.Position - v114).Magnitude >= 0.001 then
            v112 = CFrame.lookAt(v112.Position, v114);
        end;

        u91:PivotTo(v112 * u83);

        return nil;
    end, 0.5);
    u91:ScaleTo(1);
    u91:PivotTo(v104 * u83);
    task.delay(0.5, function() -- Line: 686
        -- upvalues: u94 (ref)
        for _, v in u94 do
            if v then
                v:Destroy();
            end;
        end;

        u94 = {};
    end);
    EmitAtPosition(v88, Impact);
    local Land = v82.Land;

    if Land then
        local v115 = Land:Clone();
        v115.Parent = PrimaryPart or workspace;
        v115:Play();
        Debris:AddItem(v115, v115.TimeLength + 1);
    end;

    local u116 = u91:GetPivot();
    RenderFor(function(p117, p118) -- Line: 707
        -- upvalues: u91 (copy), u116 (copy)
        local v119;

        if p118 < 0.36363636363636365 then
            v119 = p118 * 7.5625 * p118;
        elseif p118 < 0.7272727272727273 then
            local v120 = p118 - 0.5454545454545454;
            v119 = v120 * 7.5625 * v120 + 0.75;
        elseif p118 < 0.9090909090909091 then
            local v121 = p118 - 0.8181818181818182;
            v119 = v121 * 7.5625 * v121 + 0.9375;
        else
            local v122 = p118 - 0.9545454545454546;
            v119 = v122 * 7.5625 * v122 + 0.984375;
        end;

        u91:PivotTo(u116 + Vector3.new(0, 1.5 * (1 - v119), 0));

        return nil;
    end, 0.4);
    u91:PivotTo(u116);
    task.wait(0.5);
    local v123 = u91:GetPivot();
    local Explode = v82.Explode;

    if Explode then
        local v124 = Explode:Clone();

        if v84 then
            v124.Volume = Explode.Volume * v84;
        end;

        v124.Parent = PrimaryPart or workspace;
        v124:Play();
        Debris:AddItem(v124, v124.TimeLength + 1);
    end;

    EmitAttachmentAt(v123, p81.OpenVFX);
    local v125 = PlayOpenAnimation(u91);

    if v125 then
        task.wait(math.max(v125.Length - 0.05, 0) + 0.35);
    else
        task.wait(0.35);
    end;

    local Position = v123.Position;
    local v126, u127, v128;

    if u86 then
        local v129;
        v129, v126 = CreateImageItem(p81.ItemImage, CFrame.new(Position));
        u127 = v129;
        v128 = v129;
        local ItemImageBillboard = v129:FindFirstChild("ItemImageBillboard");

        if ItemImageBillboard then
            ItemImageBillboard.Size = UDim2.fromScale(0, 0);
        end;

        v129.Parent = workspace;
    elseif p81.ItemModel then
        u127 = p81.ItemModel:Clone();

        if not u127.PrimaryPart then
            local Center = u127:FindFirstChild("Center");

            if Center then
                u127.PrimaryPart = Center;
            else
                local v130 = u127:FindFirstChildWhichIsA("BasePart", true);

                if v130 then
                    u127.PrimaryPart = v130;
                end;
            end;
        end;

        SetModelAnchored(u127);
        v126 = u127:GetExtentsSize().Y / 2;
        u127:PivotTo(LookAtFlat(CFrame.new(Position), u87));
        u127.Parent = workspace;
        v128 = u127.PrimaryPart;
    else
        v128 = Instance.new("Part");
        v128.Size = Vector3.new(1, 1, 1);
        v128.Transparency = 1;
        v128.Anchored = true;
        v128.CanCollide = false;
        v128.CFrame = CFrame.new(Position);
        v128.Parent = workspace;
        u127 = v128;
        v126 = 0.5;
    end;

    local u131;

    if u86 then
        u131 = nil;
    else
        u131 = Instance.new("Highlight");
        u131.FillColor = Color3.new(1, 1, 1);
        u131.OutlineColor = Color3.new(1, 1, 1);
        u131.FillTransparency = 0;
        u131.OutlineTransparency = 0;
        u131.DepthMode = Enum.HighlightDepthMode.Occluded;
        u131.Parent = u127;
    end;

    EmitAtPosition(Position, Explosion, p81.RarityColor);
    local u132 = CaptureVisuals(u91);
    RenderFor(function(p133, p134) -- Line: 810
        -- upvalues: ApplyFade (ref), u132 (copy)
        ApplyFade(u132, p134);

        return nil;
    end, 0.45);
    u91:Destroy();
    local u135 = Vector3.new(Position.X, Position.Y + v93 + v126, Position.Z);
    local Reveal = v82.Reveal;

    if Reveal then
        local v136 = Reveal:Clone();
        v136.Parent = v128 or workspace;
        v136:Play();
        Debris:AddItem(v136, v136.TimeLength + 1);
    end;

    EmitAtPosition(u135, Explosion, p81.RarityColor);
    local u137;

    if u86 then
        u137 = u127:FindFirstChild("ItemImageBillboard");
    else
        u137 = nil;
    end;

    RenderFor(function(p138, p139) -- Line: 833
        -- upvalues: Position (copy), u135 (copy), u86 (copy), u127 (ref), u137 (ref), u78 (ref), LookAtFlat (ref), Player (copy), u131 (ref)
        local v140;

        if p139 == 0 then
            v140 = 0;
        elseif p139 == 1 then
            v140 = 1;
        else
            local v141 = p139 * 2;

            if v141 < 1 then
                v140 = math.pow(2, (v141 - 1) * 10) * 0.5 - 0.0005;
            else
                v140 = (-math.pow(2, (v141 - 1) * -10) + 2) * 0.50025;
            end;
        end;

        local v142 = Position:Lerp(u135, v140);

        if u86 then
            u127.CFrame = CFrame.new(v142);

            if u137 then
                local v143 = math.clamp(p139 * 1.5, 0, 1);
                local v144;

                if v143 == 0 then
                    v144 = 0;
                elseif v143 == 1 then
                    v144 = 1;
                else
                    local v145 = v143 * 2;

                    if v145 < 1 then
                        v144 = math.pow(2, (v145 - 1) * 10) * 0.5 - 0.0005;
                    else
                        v144 = (-math.pow(2, (v145 - 1) * -10) + 2) * 0.50025;
                    end;
                end;

                u137.Size = UDim2.fromScale(u78.X.Scale * v144, u78.Y.Scale * v144);
            end;
        else
            local v146 = CFrame.new(v142);
            local Character2 = Player.Character;
            u127:PivotTo(LookAtFlat(v146, not (Character2 and Character2.PrimaryPart) and Vector3.new(0, 10, 0) or Character2.PrimaryPart.Position));

            if u131 then
                u131.FillTransparency = p139;
                u131.OutlineTransparency = p139;
            end;
        end;

        return nil;
    end, 0.6);

    if u131 then
        u131:Destroy();
    end;

    local v147 = nil;

    if not u86 then
        local ItemShine = game.ReplicatedStorage.Assets.VFX:FindFirstChild("ItemShine");
        local v148 = ItemShine and ItemShine:FindFirstChild("Attachment");

        if v148 then
            v148:Clone().Parent = v128;
        end;
    end;

    if p81.BillboardTemplate then
        v147 = p81.BillboardTemplate:Clone();
        local Size = v147.Size;
        v147.Size = UDim2.new(Size.X.Scale * 0.15, Size.X.Offset * 0.15, Size.Y.Scale * 0.15, Size.Y.Offset * 0.15);
        v147.Adornee = v128;
        v147.StudsOffset = Vector3.new(0, v126 + 1.5, 0);
        v147.Parent = u127;
        local Frame = v147:FindFirstChild("Frame");

        if Frame and Frame:IsA("Frame") then
            local ItemName = Frame:FindFirstChild("ItemName");

            if ItemName and ItemName:IsA("TextLabel") then
                ItemName.Text = p81.ItemName;
            end;

            local ItemLuck = Frame:FindFirstChild("ItemLuck");

            if ItemLuck and ItemLuck:IsA("TextLabel") then
                local v149;

                if p81.RarityName and p81.Rarity then
                    v149 = string.format("%s - %.1f%%", p81.RarityName, p81.Rarity * 100);
                elseif p81.RarityName then
                    v149 = p81.RarityName;
                else
                    v149 = not p81.Rarity and "" or string.format("%.1f%%", p81.Rarity * 100);
                end;

                ItemLuck.Text = v149;
                ItemLuck.TextColor3 = p81.RarityColor;
                local v150 = ItemLuck:FindFirstChildWhichIsA("UIGradient");

                if v150 then
                    v150.Color = ColorSequence.new(p81.RarityColor);
                end;

                if p81.RarityName then
                    local u151 = RarityVisuals.ApplyToLabels({ ItemLuck }, p81.RarityName);
                    ItemLuck.AncestryChanged:Connect(function(p152, p153) -- Line: 937
                        -- upvalues: u151 (copy)
                        if not p153 then
                            u151();
                        end;
                    end);
                end;
            end;
        end;

        TweenService:Create(v147, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = Size
        }):Play();
    end;

    local u154;

    if u86 then
        u154 = u127.Position;
    else
        u154 = u127:GetPivot().Position;
    end;

    RenderFor(function(p155, p156) -- Line: 960
        -- upvalues: u154 (ref), u86 (copy), u127 (ref), LookAtFlat (ref), Player (copy)
        local v157 = math.sin(1.5707963267948966 * p156);
        local v158 = -math.abs(v157) * 2;
        local v159 = u154 + Vector3.new(0, v158, 0);

        if u86 then
            u127.CFrame = CFrame.new(v159);
        else
            local v160 = CFrame.new(v159);
            local Character2 = Player.Character;
            u127:PivotTo(LookAtFlat(v160, not (Character2 and Character2.PrimaryPart) and Vector3.new(0, 10, 0) or Character2.PrimaryPart.Position));
        end;

        return nil;
    end, 2.5);

    if v147 then
        local Size = v147.Size;
        TweenService:Create(v147, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(Size.X.Scale * 0.15, Size.X.Offset * 0.15, Size.Y.Scale * 0.15, Size.Y.Offset * 0.15)
        }):Play();
        Debris:AddItem(v147, 0.15);
    end;

    local u161;

    if u86 then
        u161 = u127.Position;
    else
        u161 = u127:GetPivot().Position;
    end;

    local Collect = v82.Collect;

    if Collect then
        local v162 = Collect:Clone();
        v162.Parent = v128 or workspace;
        v162:Play();
        Debris:AddItem(v162, v162.TimeLength + 1);
    end;

    RenderFor(function(p163, p164) -- Line: 999
        -- upvalues: Player (copy), u161 (ref), u86 (copy), u127 (ref), u137 (ref), u78 (ref)
        local Character2 = Player.Character;
        local u165 = not (Character2 and Character2.PrimaryPart) and Vector3.new(0, 10, 0) or Character2.PrimaryPart.Position;
        local u166 = u161;
        local v167 = u161;
        local v168 = (v167 + u165) / 2;
        local Magnitude2 = ((v167 - u165) * Vector3.new(1, 0, 1)).Magnitude;
        local X2 = v168.X;
        local v169 = math.max(v167.Y, u165.Y) + Magnitude2;
        local u170 = Vector3.new(X2, v169, v168.Z);
        local v173 = (function(p171) -- Line: 182
            -- upvalues: u166 (copy), u170 (copy), u165 (copy)
            local v172 = 1 - p171;

            return v172 * v172 * u166 + v172 * 2 * p171 * u170 + p171 * p171 * u165;
        end)(p164);

        if u86 then
            u127.CFrame = CFrame.new(v173);

            if u137 then
                local v174 = 1 - (p164 == 0 and 0 or math.pow(2, (p164 - 1) * 10) - 0.001);
                u137.Size = UDim2.fromScale(u78.X.Scale * v174, u78.Y.Scale * v174);
            end;
        else
            local v175 = Vector3.new(u165.X, v173.Y, u165.Z);
            local v176;

            if (v173 - v175).Magnitude < 0.001 then
                v176 = CFrame.new(v173);
            else
                v176 = CFrame.lookAt(v173, v175);
            end;

            if u127:IsA("Model") then
                u127:PivotTo(v176);
                u127:ScaleTo(1 - (p164 == 0 and 0 or math.pow(2, (p164 - 1) * 10) - 0.001));
            else
                u127.CFrame = v176;
            end;
        end;

        return nil;
    end, 0.5);

    if p81.OnCollected then
        p81.OnCollected();
    end;

    if u86 then
        u127:Destroy();
    else
        u127:Destroy();
    end;

    local v177 = table.find(u2, v88);

    if v177 then
        table.remove(u2, v177);
    end;
end;

function u1.PlayReveal(u178) -- Line: 1082
    -- upvalues: CreateImageItem (copy), SetModelAnchored (copy), LookAtFlat (copy), EmitAtPosition (copy), Debris (copy), RenderFor (copy), u78 (copy), RarityVisuals (copy), TweenService (copy)
    local Player = u178.Player;
    local v179 = u178.Sounds or {};
    local v180 = u178.Particles or {};
    local VFX = u178.VFX;
    local Explosion = v180.Explosion;

    if not Explosion then
        if VFX then
            Explosion = VFX:FindFirstChild("Explosion");
        else
            Explosion = nil;
        end;
    end;

    local function _() -- Line: 1091
        -- upvalues: Player (copy), u178 (copy)
        local Character = Player.Character;

        if Character and Character.PrimaryPart then
            return Character.PrimaryPart.Position;
        end;

        return u178.Position;
    end;

    local Position = u178.Position;
    local u181;

    if u178.ItemImage == nil then
        u181 = false;
    else
        u181 = u178.ItemImage ~= "";
    end;

    local v182, u183, v184;

    if u181 then
        local v185;
        v185, v182 = CreateImageItem(u178.ItemImage, CFrame.new(Position));
        u183 = v185;
        v184 = v185;
        local ItemImageBillboard = v185:FindFirstChild("ItemImageBillboard");

        if ItemImageBillboard then
            ItemImageBillboard.Size = UDim2.fromScale(0, 0);
        end;

        v185.Parent = workspace;
    else
        if not u178.ItemModel then
            return;
        end;

        u183 = u178.ItemModel:Clone();

        if not u183.PrimaryPart then
            local Center = u183:FindFirstChild("Center");

            if Center then
                u183.PrimaryPart = Center;
            else
                local v186 = u183:FindFirstChildWhichIsA("BasePart", true);

                if v186 then
                    u183.PrimaryPart = v186;
                end;
            end;
        end;

        SetModelAnchored(u183);
        v182 = u183:GetExtentsSize().Y / 2;
        local v187 = CFrame.new(Position);
        local Character = Player.Character;
        local v188;

        if Character and Character.PrimaryPart then
            v188 = Character.PrimaryPart.Position;
        else
            v188 = u178.Position;
        end;

        u183:PivotTo(LookAtFlat(v187, v188));
        u183.Parent = workspace;
        v184 = u183.PrimaryPart;
    end;

    local u189;

    if u181 then
        u189 = nil;
    else
        u189 = Instance.new("Highlight");
        u189.FillColor = Color3.new(1, 1, 1);
        u189.OutlineColor = Color3.new(1, 1, 1);
        u189.FillTransparency = 0;
        u189.OutlineTransparency = 0;
        u189.DepthMode = Enum.HighlightDepthMode.Occluded;
        u189.Parent = u183;
    end;

    EmitAtPosition(Position, Explosion, u178.RarityColor);
    local u190 = Vector3.new(Position.X, Position.Y + 3 + v182, Position.Z);
    local Reveal = v179.Reveal;

    if Reveal then
        local v191 = Reveal:Clone();
        v191.Parent = v184 or workspace;
        v191:Play();
        Debris:AddItem(v191, v191.TimeLength + 1);
    end;

    EmitAtPosition(u190, Explosion, u178.RarityColor);
    local u192;

    if u181 then
        u192 = u183:FindFirstChild("ItemImageBillboard");
    else
        u192 = nil;
    end;

    RenderFor(function(p193, p194) -- Line: 1170
        -- upvalues: Position (copy), u190 (copy), u181 (copy), u183 (ref), u192 (ref), u78 (ref), LookAtFlat (ref), Player (copy), u178 (copy), u189 (ref)
        local v195;

        if p194 == 0 then
            v195 = 0;
        elseif p194 == 1 then
            v195 = 1;
        else
            local v196 = p194 * 2;

            if v196 < 1 then
                v195 = math.pow(2, (v196 - 1) * 10) * 0.5 - 0.0005;
            else
                v195 = (-math.pow(2, (v196 - 1) * -10) + 2) * 0.50025;
            end;
        end;

        local v197 = Position:Lerp(u190, v195);

        if u181 then
            u183.CFrame = CFrame.new(v197);

            if u192 then
                local v198 = math.clamp(p194 * 1.5, 0, 1);
                local v199;

                if v198 == 0 then
                    v199 = 0;
                elseif v198 == 1 then
                    v199 = 1;
                else
                    local v200 = v198 * 2;

                    if v200 < 1 then
                        v199 = math.pow(2, (v200 - 1) * 10) * 0.5 - 0.0005;
                    else
                        v199 = (-math.pow(2, (v200 - 1) * -10) + 2) * 0.50025;
                    end;
                end;

                u192.Size = UDim2.fromScale(u78.X.Scale * v199, u78.Y.Scale * v199);
            end;
        else
            local v201 = CFrame.new(v197);
            local Character = Player.Character;
            local v202;

            if Character and Character.PrimaryPart then
                v202 = Character.PrimaryPart.Position;
            else
                v202 = u178.Position;
            end;

            u183:PivotTo(LookAtFlat(v201, v202));

            if u189 then
                u189.FillTransparency = p194;
                u189.OutlineTransparency = p194;
            end;
        end;

        return nil;
    end, 0.6);

    if u189 then
        u189:Destroy();
    end;

    local v203 = nil;

    if not u181 then
        local ItemShine = game.ReplicatedStorage.Assets.VFX:FindFirstChild("ItemShine");
        local v204 = ItemShine and ItemShine:FindFirstChild("Attachment");

        if v204 then
            v204:Clone().Parent = v184;
        end;
    end;

    if u178.BillboardTemplate then
        v203 = u178.BillboardTemplate:Clone();
        local Size = v203.Size;
        v203.Size = UDim2.new(Size.X.Scale * 0.15, Size.X.Offset * 0.15, Size.Y.Scale * 0.15, Size.Y.Offset * 0.15);
        v203.Adornee = v184;
        v203.StudsOffset = Vector3.new(0, v182 + 1.5, 0);
        v203.Parent = u183;
        local Frame = v203:FindFirstChild("Frame");

        if Frame and Frame:IsA("Frame") then
            local ItemName = Frame:FindFirstChild("ItemName");

            if ItemName and ItemName:IsA("TextLabel") then
                ItemName.Text = u178.ItemName;
            end;

            local ItemLuck = Frame:FindFirstChild("ItemLuck");

            if ItemLuck and ItemLuck:IsA("TextLabel") then
                local v205;

                if u178.RarityName and u178.Rarity then
                    v205 = string.format("%s - %.1f%%", u178.RarityName, u178.Rarity * 100);
                elseif u178.RarityName then
                    v205 = u178.RarityName;
                else
                    v205 = not u178.Rarity and "" or string.format("%.1f%%", u178.Rarity * 100);
                end;

                ItemLuck.Text = v205;
                ItemLuck.TextColor3 = u178.RarityColor;
                local v206 = ItemLuck:FindFirstChildWhichIsA("UIGradient");

                if v206 then
                    v206.Color = ColorSequence.new(u178.RarityColor);
                end;

                if u178.RarityName then
                    local u207 = RarityVisuals.ApplyToLabels({ ItemLuck }, u178.RarityName);
                    ItemLuck.AncestryChanged:Connect(function(p208, p209) -- Line: 1265
                        -- upvalues: u207 (copy)
                        if not p209 then
                            u207();
                        end;
                    end);
                end;
            end;
        end;

        TweenService:Create(v203, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = Size
        }):Play();
    end;

    local u210;

    if u181 then
        u210 = u183.Position;
    else
        u210 = u183:GetPivot().Position;
    end;

    RenderFor(function(p211, p212) -- Line: 1288
        -- upvalues: u210 (ref), u181 (copy), u183 (ref), LookAtFlat (ref), Player (copy), u178 (copy)
        local v213 = math.sin(1.5707963267948966 * p212);
        local v214 = -math.abs(v213) * 2;
        local v215 = u210 + Vector3.new(0, v214, 0);

        if u181 then
            u183.CFrame = CFrame.new(v215);
        else
            local v216 = CFrame.new(v215);
            local Character = Player.Character;
            local v217;

            if Character and Character.PrimaryPart then
                v217 = Character.PrimaryPart.Position;
            else
                v217 = u178.Position;
            end;

            u183:PivotTo(LookAtFlat(v216, v217));
        end;

        return nil;
    end, 2.5);

    if v203 then
        local Size = v203.Size;
        TweenService:Create(v203, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(Size.X.Scale * 0.15, Size.X.Offset * 0.15, Size.Y.Scale * 0.15, Size.Y.Offset * 0.15)
        }):Play();
        Debris:AddItem(v203, 0.15);
    end;

    local u218;

    if u181 then
        u218 = u183.Position;
    else
        u218 = u183:GetPivot().Position;
    end;

    local Collect = v179.Collect;

    if Collect then
        local v219 = Collect:Clone();
        v219.Parent = v184 or workspace;
        v219:Play();
        Debris:AddItem(v219, v219.TimeLength + 1);
    end;

    RenderFor(function(p220, p221) -- Line: 1326
        -- upvalues: Player (copy), u178 (copy), u218 (ref), u181 (copy), u183 (ref), u192 (ref), u78 (ref)
        local Character = Player.Character;
        local u222;

        if Character and Character.PrimaryPart then
            u222 = Character.PrimaryPart.Position;
        else
            u222 = u178.Position;
        end;

        local u223 = u218;
        local v224 = u218;
        local v225 = (v224 + u222) / 2;
        local Magnitude = ((v224 - u222) * Vector3.new(1, 0, 1)).Magnitude;
        local X = v225.X;
        local v226 = math.max(v224.Y, u222.Y) + Magnitude;
        local u227 = Vector3.new(X, v226, v225.Z);
        local v230 = (function(p228) -- Line: 182
            -- upvalues: u223 (copy), u227 (copy), u222 (copy)
            local v229 = 1 - p228;

            return v229 * v229 * u223 + v229 * 2 * p228 * u227 + p228 * p228 * u222;
        end)(p221);

        if u181 then
            u183.CFrame = CFrame.new(v230);

            if u192 then
                local v231 = 1 - (p221 == 0 and 0 or math.pow(2, (p221 - 1) * 10) - 0.001);
                u192.Size = UDim2.fromScale(u78.X.Scale * v231, u78.Y.Scale * v231);
            end;
        else
            local v232 = Vector3.new(u222.X, v230.Y, u222.Z);
            local v233;

            if (v230 - v232).Magnitude < 0.001 then
                v233 = CFrame.new(v230);
            else
                v233 = CFrame.lookAt(v230, v232);
            end;

            if u183:IsA("Model") then
                u183:PivotTo(v233);
                u183:ScaleTo(1 - (p221 == 0 and 0 or math.pow(2, (p221 - 1) * 10) - 0.001));
            else
                u183.CFrame = v233;
            end;
        end;

        return nil;
    end, 0.5);

    if u178.OnCollected then
        u178.OnCollected();
    end;

    if u181 then
        u183:Destroy();
    else
        u183:Destroy();
    end;
end;

return u1;