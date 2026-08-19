-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local u1 = {};
local u2 = {};
local Players = game:GetService("Players");

local function FindGround(p3) -- Line: 23
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

local function HasPositionConflict(p7) -- Line: 49
    -- upvalues: u2 (copy)
    for _, v in u2 do
        if (p7 - v).Magnitude <= 10 then
            return true;
        end;
    end;

    return false;
end;

function u1.FindDropPosition(p8) -- Line: 63
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

local function ExpoInOut(p17) -- Line: 109
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

local function ExpoIn(p19) -- Line: 122
    return p19 == 0 and 0 or math.pow(2, (p19 - 1) * 10) - 0.001;
end;

local function BounceOut(p20) -- Line: 127
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

local function QuadOut(p24) -- Line: 135
    return p24 * -1 * (p24 - 2);
end;

local u25 = 0;

local function RenderFor(u26, u27) -- Line: 143
    -- upvalues: u25 (ref), RunService (copy)
    u25 = u25 + 1;
    local u28 = ("CrateRS_%d"):format(u25);
    local u29 = 0;
    local u30 = false;
    RunService:BindToRenderStep(u28, Enum.RenderPriority.Last.Value, function(p31) -- Line: 153
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

local function Bezier(u32, u33, u34) -- Line: 175
    return function(p35) -- Line: 176
        -- upvalues: u32 (copy), u33 (copy), u34 (copy)
        local v36 = 1 - p35;

        return v36 * v36 * u32 + v36 * 2 * p35 * u33 + p35 * p35 * u34;
    end;
end;

local function AutoControlPoint(p37, p38) -- Line: 183
    local v39 = (p37 + p38) / 2;
    local Magnitude = ((p37 - p38) * Vector3.new(1, 0, 1)).Magnitude;
    local X = v39.X;
    local v40 = math.max(p37.Y, p38.Y) + Magnitude;

    return Vector3.new(X, v40, v39.Z);
end;

local function LookAtFlat(p41, p42) -- Line: 190
    local v43 = Vector3.new(p42.X, p41.Y, p42.Z);

    if (p41.Position - v43).Magnitude < 0.001 then
        return p41;
    end;

    return CFrame.lookAt(p41.Position, v43);
end;

local function SetModelAnchored(p44) -- Line: 201
    for _, descendant in p44:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CastShadow = false;
            descendant.CanQuery = false;
        end;
    end;
end;

local function EnsurePrimaryPart(p45) -- Line: 213
    if p45.PrimaryPart then
        return;
    end;

    local Center = p45:FindFirstChild("Center");

    if Center then
        p45.PrimaryPart = Center;

        return;
    end;

    local v46 = p45:FindFirstChildWhichIsA("BasePart", true);

    if v46 then
        p45.PrimaryPart = v46;
    end;
end;

local function EmitAtPosition(p47, p48, p49, p50) -- Line: 239
    -- upvalues: Debris (copy)
    if not p48 then
        return;
    end;

    if typeof(p48) == "Instance" and p48:IsA("Folder") then
        p48 = p48:GetChildren();
    elseif type(p48) ~= "table" then
        return;
    end;

    if #p48 == 0 then
        return;
    end;

    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0, 0, 0);
    Part.CFrame = CFrame.new(p47);
    Part.Parent = workspace;
    local v51 = 0;

    for _, v in p48 do
        if v:IsA("ParticleEmitter") then
            local v52 = v:Clone();
            v52.Enabled = false;

            if p49 then
                v52.Color = ColorSequence.new(p49);
            end;

            v52.Parent = Part;
            local v53 = v52:GetAttribute("EmitCount") or v52.Rate;
            v52:Emit((math.ceil(v53)));
            v51 = math.max(v51, v52.Lifetime.Max);
        end;
    end;

    Debris:AddItem(Part, p50 or v51 + 0.5);
end;

local function PlaySound(p54, p55, p56) -- Line: 293
    -- upvalues: Debris (copy)
    if not p54 then
        return;
    end;

    local v57 = p54:Clone();

    if p56 then
        v57.Volume = p54.Volume * p56;
    end;

    v57.Parent = p55 or workspace;
    v57:Play();
    Debris:AddItem(v57, v57.TimeLength + 1);
end;

local function SetTrailsEnabled(p58, p59) -- Line: 311
    for _, v in p58 do
        if v:IsA("Trail") then
            v.Enabled = p59;
        end;

        for _, descendant in v:GetDescendants() do
            if descendant:IsA("Trail") then
                descendant.Enabled = p59;
            end;
        end;
    end;
end;

local u60 = UDim2.fromScale(5, 5);

local function CreateImageItem(p61, p62) -- Line: 332
    -- upvalues: u60 (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CastShadow = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.CFrame = p62;
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "ItemImageBillboard";
    BillboardGui.Size = u60;
    BillboardGui.StudsOffset = Vector3.new(0, 0, 0);
    BillboardGui.Adornee = Part;
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.Parent = Part;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ItemImage";
    ImageLabel.Image = p61;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Position = UDim2.fromScale(0, 0);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Parent = BillboardGui;

    return Part, 2.5;
end;

local _ = game.SoundService.SFX.CrateSFX;

function u1.Play(p63) -- Line: 422
    -- upvalues: FindGround (copy), u1 (copy), u2 (copy), SetModelAnchored (copy), Debris (copy), RenderFor (copy), LookAtFlat (copy), EmitAtPosition (copy), CreateImageItem (copy), u60 (copy), TweenService (copy)
    local Player = p63.Player;
    local v64 = p63.Sounds or {};
    local v65 = math.clamp(1 - (p63.Rarity or 0.5), 0, 1);
    local v66 = p63.IsBestItem == true;
    local v67 = v66 and 2 or 1;
    local v68;

    if v66 then
        v68 = 1.5 + math.random() * 1.5;
    else
        v68 = nil;
    end;

    local VFX = p63.VFX;
    local v69 = p63.Particles or {};
    local Impact = v69.Impact;

    if not Impact then
        if VFX then
            Impact = VFX:FindFirstChild("Impact");
        else
            Impact = nil;
        end;
    end;

    local Explosion = v69.Explosion;

    if not Explosion then
        if VFX then
            Explosion = VFX:FindFirstChild("Explosion");
        else
            Explosion = nil;
        end;
    end;

    local Trail = v69.Trail;

    if not Trail then
        if VFX then
            Trail = VFX:FindFirstChild("Trail");
        else
            Trail = nil;
        end;
    end;

    local u70;

    if p63.ItemImage == nil then
        u70 = false;
    else
        u70 = p63.ItemImage ~= "";
    end;

    local function GetPlayerPosition() -- Line: 447
        -- upvalues: Player (copy)
        local Character = Player.Character;

        return not (Character and Character.PrimaryPart) and Vector3.new(0, 10, 0) or Character.PrimaryPart.Position;
    end;

    local Character = Player.Character;
    local u71 = not (Character and Character.PrimaryPart) and Vector3.new(0, 10, 0) or Character.PrimaryPart.Position;
    local v72;

    if p63.Position and ((p63.Position - u71).Magnitude < 100 and p63.Position.Magnitude > 1) then
        v72 = FindGround(p63.Position);
    else
        v72 = nil;
    end;

    if not v72 then
        v72 = u1.FindDropPosition(Player);

        if not v72 then
            local Character2 = Player.Character;

            if Character2 and Character2.PrimaryPart then
                local v73 = Character2:GetPivot();
                local v74 = v73.Position + v73.LookVector * 6;
                v72 = FindGround(v74) or v74 + Vector3.new(0, -3, 0);
            else
                v72 = u71;
            end;
        end;
    end;

    table.insert(u2, v72);
    local u75 = p63.CrateModel:Clone();

    if not u75.PrimaryPart then
        local Center = u75:FindFirstChild("Center");

        if Center then
            u75.PrimaryPart = Center;
        else
            local v76 = u75:FindFirstChildWhichIsA("BasePart", true);

            if v76 then
                u75.PrimaryPart = v76;
            end;
        end;
    end;

    SetModelAnchored(u75);
    local u77 = u75:GetExtentsSize().Y / 2;
    local PrimaryPart = u75.PrimaryPart;
    local u78 = {};
    local v79;

    if Trail then
        local Attachment = Instance.new("Attachment");
        Attachment.Name = "TrailBottom";
        Attachment.Position = Vector3.new(0, -PrimaryPart.Size.Y / 2, 0);
        Attachment.Parent = PrimaryPart;
        local Attachment2 = Instance.new("Attachment");
        Attachment2.Name = "TrailTop";
        Attachment2.Position = Vector3.new(0, PrimaryPart.Size.Y / 2, 0);
        Attachment2.Parent = PrimaryPart;
        v79 = Trail:Clone();
        v79.Attachment0 = Attachment;
        v79.Attachment1 = Attachment2;
        v79.Lifetime = 0.5;
        v79.Enabled = false;
        v79.Parent = PrimaryPart;
        table.insert(u78, Attachment);
        table.insert(u78, Attachment2);
        table.insert(u78, v79);
    else
        v79 = nil;
    end;

    u75:PivotTo(CFrame.new(u71));
    u75:ScaleTo(0.001);
    u75.Parent = workspace;
    local Spawn = v64.Spawn;

    if Spawn then
        local v80 = Spawn:Clone();
        v80.Parent = PrimaryPart or workspace;
        v80:Play();
        Debris:AddItem(v80, v80.TimeLength + 1);
    end;

    if v79 then
        v79.Enabled = true;
    end;

    local u81 = Vector3.new(v72.X, v72.Y + u77, v72.Z);
    local v82 = (u71 + u81) / 2;
    local Magnitude = ((u71 - u81) * Vector3.new(1, 0, 1)).Magnitude;
    local X = v82.X;
    local v83 = math.max(u71.Y, u81.Y) + Magnitude;
    local u84 = Vector3.new(X, v83, v82.Z);

    local function u87(p85) -- Line: 176
        -- upvalues: u71 (copy), u84 (copy), u81 (copy)
        local v86 = 1 - p85;

        return v86 * v86 * u71 + v86 * 2 * p85 * u84 + p85 * p85 * u81;
    end;

    local v88 = CFrame.new(u81);
    local v89 = Vector3.new(u71.X, v88.Y, u71.Z);

    if (v88.Position - v89).Magnitude >= 0.001 then
        v88 = CFrame.lookAt(v88.Position, v89);
    end;

    RenderFor(function(p90, p91) -- Line: 563
        -- upvalues: u75 (copy), LookAtFlat (ref), u87 (copy), u71 (copy)
        local v92 = math.clamp(p91 * 2, 0, 1);
        local v93;

        if v92 == 0 then
            v93 = 0;
        elseif v92 == 1 then
            v93 = 1;
        else
            local v94 = v92 * 2;

            if v94 < 1 then
                v93 = math.pow(2, (v94 - 1) * 10) * 0.5 - 0.0005;
            else
                v93 = (-math.pow(2, (v94 - 1) * -10) + 2) * 0.50025;
            end;
        end;

        u75:ScaleTo(v93);
        local v95 = 1 - math.cos(p91 * 3.141592653589793 / 2);
        u75:PivotTo(LookAtFlat(CFrame.new(u87(v95)), u71));

        return nil;
    end, 0.5);
    u75:ScaleTo(1);
    u75:PivotTo(v88);
    task.delay(0.5, function() -- Line: 576
        -- upvalues: u78 (ref)
        for _, v in u78 do
            if v then
                v:Destroy();
            end;
        end;

        u78 = {};
    end);
    EmitAtPosition(v72, Impact);
    local Land = v64.Land;

    if Land then
        local v96 = Land:Clone();
        v96.Parent = PrimaryPart or workspace;
        v96:Play();
        Debris:AddItem(v96, v96.TimeLength + 1);
    end;

    local u97 = u75:GetPivot();
    RenderFor(function(p98, p99) -- Line: 597
        -- upvalues: u75 (copy), u97 (copy)
        local v100;

        if p99 < 0.36363636363636365 then
            v100 = p99 * 7.5625 * p99;
        elseif p99 < 0.7272727272727273 then
            local v101 = p99 - 0.5454545454545454;
            v100 = v101 * 7.5625 * v101 + 0.75;
        elseif p99 < 0.9090909090909091 then
            local v102 = p99 - 0.8181818181818182;
            v100 = v102 * 7.5625 * v102 + 0.9375;
        else
            local v103 = p99 - 0.9545454545454546;
            v100 = v103 * 7.5625 * v103 + 0.984375;
        end;

        u75:PivotTo(u97 + Vector3.new(0, 1.5 * (1 - v100), 0));

        return nil;
    end, 0.4);
    u75:PivotTo(u97);
    task.wait(0.5);
    local u104 = u75:GetPivot();
    local u105 = 15 * (v65 * 1.2 + 0.15);
    local u106 = v68 or v65 * 0.5 + 1;
    local Shake = v64.Shake;

    if Shake then
        local v107 = Shake:Clone();
        v107.Parent = PrimaryPart or workspace;
        v107:Play();
        Debris:AddItem(v107, v107.TimeLength + 1);
    end;

    RenderFor(function(p108, p109) -- Line: 620
        -- upvalues: u105 (copy), u106 (copy), u77 (copy), u75 (copy), u104 (copy)
        local v110 = math.min(p109 * 2, 1);
        local v111 = math.max((p109 - 0.6) / 0.4, 0);
        local v112 = v110 * -1 * (v110 - 2) * (1 - v111 * -1 * (v111 - 2));
        local v113 = p109 * 1.2 * 5;
        local v114 = u105 * math.sin(6.283185307179586 * v113) * v112;
        local v115 = math.rad(v114);
        local v116 = u105 * 0.6 * math.sin(6.283185307179586 * v113 * 1.3) * v112;
        local v117 = math.rad(v116);
        local v118 = u105 * 0.3 * math.cos(6.283185307179586 * v113 * 1.7) * v112;
        local v119 = math.rad(v118);
        local v120 = 0.22499999999999998 * math.sin(6.283185307179586 * v113 * 0.8) * v112;
        local v121 = 0.12 * math.cos(6.283185307179586 * v113 * 1.1) * v112;
        local v122 = 1 + (u106 - 1) * v112;
        u75:ScaleTo(v122);
        u75:PivotTo(u104 * CFrame.fromOrientation(v115, v117, v119) + Vector3.new(v121, v120 + u77 * (v122 - 1), 0));

        return nil;
    end, 1.8 * (v65 * 1 + 0.3) * (v66 and 2 or 1));
    u75:ScaleTo(1);
    u75:PivotTo(u104);
    local Position = u104.Position;
    local v123, u124, v125;

    if u70 then
        local v126;
        v126, v123 = CreateImageItem(p63.ItemImage, CFrame.new(Position));
        u124 = v126;
        v125 = v126;
        local ItemImageBillboard = v126:FindFirstChild("ItemImageBillboard");

        if ItemImageBillboard then
            ItemImageBillboard.Size = UDim2.fromScale(0, 0);
        end;

        v126.Parent = workspace;
    elseif p63.ItemModel then
        u124 = p63.ItemModel:Clone();

        if not u124.PrimaryPart then
            local Center = u124:FindFirstChild("Center");

            if Center then
                u124.PrimaryPart = Center;
            else
                local v127 = u124:FindFirstChildWhichIsA("BasePart", true);

                if v127 then
                    u124.PrimaryPart = v127;
                end;
            end;
        end;

        SetModelAnchored(u124);
        v123 = u124:GetExtentsSize().Y / 2;
        u124:PivotTo(LookAtFlat(CFrame.new(Position), u71));
        u124.Parent = workspace;
        v125 = u124.PrimaryPart;
    else
        v125 = Instance.new("Part");
        v125.Size = Vector3.new(1, 1, 1);
        v125.Transparency = 1;
        v125.Anchored = true;
        v125.CanCollide = false;
        v125.CFrame = CFrame.new(Position);
        v125.Parent = workspace;
        u124 = v125;
        v123 = 0.5;
    end;

    local u128;

    if u70 then
        u128 = nil;
    else
        u128 = Instance.new("Highlight");
        u128.FillColor = Color3.new(1, 1, 1);
        u128.OutlineColor = Color3.new(1, 1, 1);
        u128.FillTransparency = 0;
        u128.OutlineTransparency = 0;
        u128.DepthMode = Enum.HighlightDepthMode.Occluded;
        u128.Parent = u124;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.new(1, 1, 1);
    Highlight.OutlineColor = Color3.new(1, 1, 1);
    Highlight.FillTransparency = 0;
    Highlight.OutlineTransparency = 0;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.Parent = u75;
    local Explosion2 = v64.Explosion;

    if Explosion2 then
        local v129 = Explosion2:Clone();

        if v67 then
            v129.Volume = Explosion2.Volume * v67;
        end;

        v129.Parent = PrimaryPart or workspace;
        v129:Play();
        Debris:AddItem(v129, v129.TimeLength + 1);
    end;

    EmitAtPosition(Position, Explosion, p63.RarityColor);
    RenderFor(function(p130, p131) -- Line: 733
        -- upvalues: u75 (copy), Highlight (copy)
        u75:ScaleTo(1 + p131 * 0.5);
        Highlight.FillTransparency = p131;
        Highlight.OutlineTransparency = p131;

        for _, descendant in u75:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = p131;
            end;
        end;

        return nil;
    end, 0.25);
    u75:Destroy();
    local u132 = Vector3.new(Position.X, Position.Y + u77 + v123, Position.Z);
    local Reveal = v64.Reveal;

    if Reveal then
        local v133 = Reveal:Clone();
        v133.Parent = v125 or workspace;
        v133:Play();
        Debris:AddItem(v133, v133.TimeLength + 1);
    end;

    EmitAtPosition(u132, Explosion, p63.RarityColor);
    local u134;

    if u70 then
        u134 = u124:FindFirstChild("ItemImageBillboard");
    else
        u134 = nil;
    end;

    RenderFor(function(p135, p136) -- Line: 768
        -- upvalues: Position (copy), u132 (copy), u70 (copy), u124 (ref), u134 (ref), u60 (ref), LookAtFlat (ref), Player (copy), u128 (ref)
        local v137;

        if p136 == 0 then
            v137 = 0;
        elseif p136 == 1 then
            v137 = 1;
        else
            local v138 = p136 * 2;

            if v138 < 1 then
                v137 = math.pow(2, (v138 - 1) * 10) * 0.5 - 0.0005;
            else
                v137 = (-math.pow(2, (v138 - 1) * -10) + 2) * 0.50025;
            end;
        end;

        local v139 = Position:Lerp(u132, v137);

        if u70 then
            u124.CFrame = CFrame.new(v139);

            if u134 then
                local v140 = math.clamp(p136 * 1.5, 0, 1);
                local v141;

                if v140 == 0 then
                    v141 = 0;
                elseif v140 == 1 then
                    v141 = 1;
                else
                    local v142 = v140 * 2;

                    if v142 < 1 then
                        v141 = math.pow(2, (v142 - 1) * 10) * 0.5 - 0.0005;
                    else
                        v141 = (-math.pow(2, (v142 - 1) * -10) + 2) * 0.50025;
                    end;
                end;

                u134.Size = UDim2.fromScale(u60.X.Scale * v141, u60.Y.Scale * v141);
            end;
        else
            local v143 = CFrame.new(v139);
            local Character2 = Player.Character;
            u124:PivotTo(LookAtFlat(v143, not (Character2 and Character2.PrimaryPart) and Vector3.new(0, 10, 0) or Character2.PrimaryPart.Position));

            if u128 then
                u128.FillTransparency = p136;
                u128.OutlineTransparency = p136;
            end;
        end;

        return nil;
    end, 0.6);

    if u128 then
        u128:Destroy();
    end;

    local v144 = nil;

    if not u70 then
        local ItemShine = game.ReplicatedStorage.Assets.VFX:FindFirstChild("ItemShine");
        local v145 = ItemShine and ItemShine:FindFirstChild("Attachment");

        if v145 then
            v145:Clone().Parent = v125;
        end;
    end;

    if p63.BillboardTemplate then
        v144 = p63.BillboardTemplate:Clone();
        local Size = v144.Size;
        v144.Size = UDim2.new(Size.X.Scale * 0.15, Size.X.Offset * 0.15, Size.Y.Scale * 0.15, Size.Y.Offset * 0.15);
        v144.Adornee = v125;
        v144.StudsOffset = Vector3.new(0, v123 + 1.5, 0);
        v144.Parent = u124;
        local Frame = v144:FindFirstChild("Frame");

        if Frame and Frame:IsA("Frame") then
            local ItemName = Frame:FindFirstChild("ItemName");

            if ItemName and ItemName:IsA("TextLabel") then
                ItemName.Text = p63.ItemName;
            end;

            local ItemLuck = Frame:FindFirstChild("ItemLuck");

            if ItemLuck and ItemLuck:IsA("TextLabel") then
                local v146;

                if p63.Rarity then
                    v146 = string.format("%s - %.1f%%", p63.RarityName, p63.Rarity * 100);
                else
                    v146 = p63.RarityName;
                end;

                ItemLuck.Text = v146;
                ItemLuck.TextColor3 = p63.RarityColor;
                local v147 = ItemLuck:FindFirstChildWhichIsA("UIGradient");

                if v147 then
                    v147.Color = ColorSequence.new(p63.RarityColor);
                end;
            end;
        end;

        TweenService:Create(v144, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = Size
        }):Play();
    end;

    local u148;

    if u70 then
        u148 = u124.Position;
    else
        u148 = u124:GetPivot().Position;
    end;

    RenderFor(function(p149, p150) -- Line: 877
        -- upvalues: u148 (ref), u70 (copy), u124 (ref), LookAtFlat (ref), Player (copy)
        local v151 = math.sin(1.5707963267948966 * p150);
        local v152 = -math.abs(v151) * 2;
        local v153 = u148 + Vector3.new(0, v152, 0);

        if u70 then
            u124.CFrame = CFrame.new(v153);
        else
            local v154 = CFrame.new(v153);
            local Character2 = Player.Character;
            u124:PivotTo(LookAtFlat(v154, not (Character2 and Character2.PrimaryPart) and Vector3.new(0, 10, 0) or Character2.PrimaryPart.Position));
        end;

        return nil;
    end, 2.5);

    if v144 then
        local Size = v144.Size;
        TweenService:Create(v144, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(Size.X.Scale * 0.15, Size.X.Offset * 0.15, Size.Y.Scale * 0.15, Size.Y.Offset * 0.15)
        }):Play();
        Debris:AddItem(v144, 0.15);
    end;

    local u155;

    if u70 then
        u155 = u124.Position;
    else
        u155 = u124:GetPivot().Position;
    end;

    local Collect = v64.Collect;

    if Collect then
        local v156 = Collect:Clone();
        v156.Parent = v125 or workspace;
        v156:Play();
        Debris:AddItem(v156, v156.TimeLength + 1);
    end;

    RenderFor(function(p157, p158) -- Line: 916
        -- upvalues: Player (copy), u155 (ref), u70 (copy), u124 (ref), u134 (ref), u60 (ref)
        local Character2 = Player.Character;
        local u159 = not (Character2 and Character2.PrimaryPart) and Vector3.new(0, 10, 0) or Character2.PrimaryPart.Position;
        local u160 = u155;
        local v161 = u155;
        local v162 = (v161 + u159) / 2;
        local Magnitude2 = ((v161 - u159) * Vector3.new(1, 0, 1)).Magnitude;
        local X2 = v162.X;
        local v163 = math.max(v161.Y, u159.Y) + Magnitude2;
        local u164 = Vector3.new(X2, v163, v162.Z);
        local v167 = (function(p165) -- Line: 176
            -- upvalues: u160 (copy), u164 (copy), u159 (copy)
            local v166 = 1 - p165;

            return v166 * v166 * u160 + v166 * 2 * p165 * u164 + p165 * p165 * u159;
        end)(p158);

        if u70 then
            u124.CFrame = CFrame.new(v167);

            if u134 then
                local v168 = 1 - (p158 == 0 and 0 or math.pow(2, (p158 - 1) * 10) - 0.001);
                u134.Size = UDim2.fromScale(u60.X.Scale * v168, u60.Y.Scale * v168);
            end;
        else
            local v169 = Vector3.new(u159.X, v167.Y, u159.Z);
            local v170;

            if (v167 - v169).Magnitude < 0.001 then
                v170 = CFrame.new(v167);
            else
                v170 = CFrame.lookAt(v167, v169);
            end;

            if u124:IsA("Model") then
                u124:PivotTo(v170);
                u124:ScaleTo(1 - (p158 == 0 and 0 or math.pow(2, (p158 - 1) * 10) - 0.001));
            else
                u124.CFrame = v170;
            end;
        end;

        return nil;
    end, 0.5);

    if p63.OnCollected then
        p63.OnCollected();
    end;

    if u70 then
        u124:Destroy();
    else
        u124:Destroy();
    end;

    local v171 = table.find(u2, v72);

    if v171 then
        table.remove(u2, v171);
    end;
end;

return u1;