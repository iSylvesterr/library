-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local FruitIdentity = require(ReplicatedStorage.SharedModules.FruitIdentity);
local Plants = ReplicatedStorage.PlantGenerationModules.Plants;
local Fruits = ReplicatedStorage.PlantGenerationModules.Fruits;
local Fruits2 = ReplicatedStorage.Assets.Fruits;
SoundService:FindFirstChild("MusicTracks");
local u2 = {};
local v3 = SoundService:FindFirstChild("SFX") and SoundService.SFX:FindFirstChild("OfflineGrowthNormal");
u2.Normal = v3;
local v4 = SoundService:FindFirstChild("SFX") and SoundService.SFX:FindFirstChild("OfflineGrowthIntense");
u2.Intense = v4;
local u5 = {};
local u6 = {};
local u7 = {};

for _, child in Plants:GetChildren() do
    if child:IsA("ModuleScript") then
        u5[child.Name] = require(child);
    end;
end;

for _, child in Fruits:GetChildren() do
    if child:IsA("ModuleScript") then
        u6[child.Name] = require(child);
    end;
end;

for _, v in SeedData do
    u7[v.SeedName] = v;
end;

local function StartGrowthSound(p8) -- Line: 87
    -- upvalues: u2 (copy), TweenService (copy)
    local v9 = u2[p8 and "Intense" or "Normal"];

    if not v9 then
        return nil, nil;
    end;

    v9.Looped = true;
    v9.Volume = 0;
    v9:Stop();
    v9:Play();
    local v10 = TweenService:Create(v9, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = 2
    });
    v10:Play();

    return v9, v10;
end;

local function StopGrowthSound(u11, p12) -- Line: 116
    -- upvalues: TweenService (copy)
    if not u11 then
        return;
    end;

    u11.Looped = false;
    local v13 = TweenService:Create(u11, TweenInfo.new(p12 or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = 0
    });
    v13:Play();
    v13.Completed:Once(function() -- Line: 133
        -- upvalues: u11 (copy)
        if u11.Volume <= 0.01 then
            u11:Stop();
            u11.Volume = 2;
        end;
    end);
end;

local function TweenAge(p14, p15, p16, p17, p18, p19, p20, p21) -- Line: 142
    -- upvalues: TweenService (copy), RunService (copy)
    if p17 <= 0 then
        p14:SetAttribute("Age", p16);

        if p21 then
            p21(p16, 1);
        end;

        return true;
    end;

    local v22 = os.clock();

    while p14.Parent do
        if p20 and p20() then
            return false;
        end;

        local v23 = (os.clock() - v22) / p17;
        local v24 = math.clamp(v23, 0, 1);
        local v25 = TweenService:GetValue(v24, p18, p19);
        local v26 = p15 + (p16 - p15) * v25;
        p14:SetAttribute("Age", v26);

        if p21 then
            p21(v26, v25);
        end;

        if v24 >= 0.5 then
            return true;
        end;

        RunService.Heartbeat:Wait();
    end;

    return false;
end;

function u1.GrowFruits(p27, p28, p29) -- Line: 201
    -- upvalues: FruitIdentity (copy), u6 (copy), Fruits2 (copy), RunService (copy), TweenAge (copy)
    local v30 = p29 or {};
    local u31 = v30.duration or 6;
    local u32 = v30.seed or 0;
    local u33 = v30.sizeMultiplier or 1;
    local u34 = v30.easingStyle or Enum.EasingStyle.Sine;
    local u35 = v30.easingDirection or Enum.EasingDirection.InOut;
    local _cancelled = v30._cancelled;
    local onComplete = v30.onComplete;
    local v36 = FruitIdentity.ResolveFruitName(p27);
    local u37 = FruitIdentity.GetVisualScale(p27);
    local u38 = u6[v36];

    if not u38 then
        return;
    end;

    local u39 = Fruits2:FindFirstChild(v36);

    if not u39 then
        return;
    end;

    local Fruits3 = p28:FindFirstChild("Fruits");

    if not Fruits3 then
        Fruits3 = Instance.new("Folder");
        Fruits3.Name = "Fruits";
        Fruits3.Parent = p28;
    end;

    local FruitSpawnLocations = p28:FindFirstChild("FruitSpawnLocations");

    if not FruitSpawnLocations then
        return;
    end;

    local u40 = u38.GrowData and (u38.GrowData.MaxAge or 100) or 100;
    local v41 = {};

    for i, child in FruitSpawnLocations:GetChildren() do
        if child:IsA("BasePart") then
            if _cancelled and _cancelled() then
                break;
            end;

            table.insert(v41, function() -- Line: 253
                -- upvalues: u39 (copy), i (copy), u40 (copy), u33 (copy), u32 (copy), child (copy), u38 (copy), u37 (copy), RunService (ref), _cancelled (copy), Fruits3 (ref), TweenAge (ref), u31 (copy), u34 (copy), u35 (copy)
                local v42 = u39:Clone();
                v42.Name = ("DisplayFruit_%d"):format(i);
                v42:SetAttribute("Age", 0);
                v42:SetAttribute("MaxAge", u40);
                v42:SetAttribute("SizeMulti", u33);
                v42:SetAttribute("PlantSeed", u32);
                v42:PivotTo(child.CFrame);
                u38.InitFruit(v42, u32 + i, u33 * u37);

                repeat
                    RunService.Heartbeat:Wait();
                until v42:HasTag("InitializationComplete") or _cancelled and _cancelled();

                if _cancelled and _cancelled() then
                    v42:Destroy();

                    return;
                end;

                u38.BeginFruitGrowth(v42);
                v42.Parent = Fruits3;
                TweenAge(v42, 0, u40, u31, u34, u35, nil);

                if _cancelled and _cancelled() then
                    v42:Destroy();
                end;
            end);
        end;
    end;

    local u43 = 0;

    for _, v in v41 do
        task.spawn(function() -- Line: 294
            -- upvalues: v (copy), u43 (ref)
            v();
            u43 = u43 + 1;
        end);
    end;

    while u43 < #v41 do
        RunService.Heartbeat:Wait();
    end;

    if onComplete then
        onComplete();
    end;
end;

require(game.ReplicatedStorage.SharedModules.PlantSizeMultipliers);

function u1.GrowPlant(u44, p45) -- Line: 316
    -- upvalues: u7 (copy), u5 (copy), RunService (copy), StartGrowthSound (copy), TweenAge (copy), StopGrowthSound (copy), u1 (copy), UserInputService (copy)
    local u46 = p45 or {};
    local parent = u46.parent;
    local v47 = u46.position or Vector3.new(0, 0, 0);
    local u48 = u46.seed or 0;
    local _ = u46.sizeMultiplier or 1;
    local u49 = u46.duration or 6;
    local u50 = u46.startAge or 0;
    local endAge = u46.endAge;
    local u51 = u46.easingStyle or Enum.EasingStyle.Sine;
    local u52 = u46.easingDirection or Enum.EasingDirection.InOut;
    local u53 = u46.playSound ~= false;
    local u54 = u46.intense or false;
    local onStep = u46.onStep;
    local onComplete = u46.onComplete;
    local onCancelled = u46.onCancelled;
    assert(parent, "Parent is required");
    local u55 = false;

    local function IsCancelled() -- Line: 345
        -- upvalues: u55 (ref)
        return u55;
    end;

    local v56 = u7[u44];
    assert(v56, ("No seed data found for \'%s\'"):format(u44));
    local u57 = u5[u44];
    assert(u57, ("No generation module found for \'%s\'"):format(u44));
    local u58 = v56.PlantModel:Clone();
    u58:SetAttribute("SeedName", u44);
    u58:SetAttribute("MaxAge", v56.MaxAge or 1);
    u58:SetAttribute("Age", u50);
    u58:PivotTo(CFrame.new(v47));
    u58.Parent = parent;
    local u59 = {};
    local u60 = true;

    local function HidePart(p61) -- Line: 372
        -- upvalues: u60 (ref), u59 (ref)
        if not u60 then
            return;
        end;

        if p61:IsA("BasePart") then
            u59[p61] = p61.Transparency;
            p61.Transparency = 1;
        end;
    end;

    for _, v in u58:QueryDescendants("BasePart") do
        if u60 then
            if v:IsA("BasePart") then
                u59[v] = v.Transparency;
                v.Transparency = 1;
            end;
        end;
    end;

    local u63 = u58.DescendantAdded:Connect(function(p62) -- Line: 384
        -- upvalues: u60 (ref), u59 (ref)
        if not u60 then
            return;
        end;

        if p62:IsA("BasePart") then
            u59[p62] = p62.Transparency;
            p62.Transparency = 1;
        end;
    end);
    local camera = u46.camera;
    local u64, u65, u66, u67, u68;

    if camera then
        u64 = camera.CameraType;
        u65 = camera.CameraSubject;
        u66 = camera.CFrame;
        u67 = camera.FieldOfView;
        camera.CameraType = Enum.CameraType.Scriptable;
        local CFrame2 = camera.CFrame;
        u68 = RunService.Heartbeat:Connect(function() -- Line: 410
            -- upvalues: camera (copy), CFrame2 (copy)
            camera.CameraType = Enum.CameraType.Scriptable;
            camera.CFrame = CFrame2;
        end);
    else
        u68 = nil;
        u67 = nil;
        u66 = nil;
        u64 = nil;
        u65 = nil;
    end;

    local function GetModelBounds() -- Line: 417
        -- upvalues: u58 (copy)
        local Rig = u58:FindFirstChild("Rig");

        if not Rig then
            return pcall(function() -- Line: 432
                -- upvalues: u58 (ref)
                return u58:GetBoundingBox();
            end);
        end;

        Rig.Parent = nil;
        local v69, v70, v71 = pcall(function() -- Line: 424
            -- upvalues: u58 (ref)
            return u58:GetBoundingBox();
        end);
        Rig.Parent = u58;

        return v69, v70, v71;
    end;

    local u72 = nil;
    local v73 = math.random(1, 3);
    local u74 = math.clamp(v73, 1, 3);
    task.spawn(function() -- Line: 447
        -- upvalues: u57 (copy), u58 (copy), u48 (copy), u74 (ref), RunService (ref), u55 (ref), u68 (ref), u60 (ref), u63 (copy), u59 (ref), u50 (copy), endAge (ref), u72 (ref), u53 (copy), StartGrowthSound (ref), u54 (copy), camera (copy), GetModelBounds (copy), TweenAge (ref), u49 (copy), u51 (copy), u52 (copy), IsCancelled (copy), onStep (copy), StopGrowthSound (ref), u46 (ref), u1 (ref), u44 (copy), UserInputService (ref), u67 (ref), onComplete (copy), onCancelled (copy)
        u57.InitPlant(u58, u48, u74, os.time());

        repeat
            RunService.Heartbeat:Wait();
        until u58:HasTag("InitializationComplete") or u55;

        if u55 then
            if u68 then
                u68:Disconnect();
                u68 = nil;
            end;

            u60 = false;
            u63:Disconnect();
            u58:Destroy();

            return;
        end;

        u60 = false;
        u63:Disconnect();

        for i, v in u59 do
            if i and i.Parent then
                i.Transparency = v;
            end;
        end;

        u59 = nil;
        u57.BeginPlantGrowth(u58);
        u58:SetAttribute("Age", u50);

        if endAge == nil then
            endAge = u58:GetAttribute("MaxAge") or 1;
        end;

        u72 = u53 and StartGrowthSound(u54) or nil;
        local Position = u58:GetPivot().Position;
        local v75 = camera.CFrame.Position - Position;
        local v76 = Vector3.new(-v75.X, 0, -v75.Z);
        local Highlight = Instance.new("Highlight");
        Highlight.FillColor = Color3.fromRGB(255, 255, 255);
        Highlight.FillTransparency = 1;
        Highlight.OutlineColor = Color3.fromRGB(0, 0, 0);
        Highlight.OutlineTransparency = 0.75;
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
        Highlight.Parent = u58;
        local Unit = (v76.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v76).Unit;
        local Unit2 = Unit:Cross(Vector3.new(0, 1, 0)).Unit;
        local u77 = Position + Unit * 10;
        local u78 = 7;
        local u79 = 0;
        local u80 = 24;
        local CFrame2 = camera.CFrame;

        local function SmoothAlpha(p81, p82) -- Line: 539
            local v83 = -p81 * math.max(p82, 0.016666666666666666);

            return 1 - math.exp(v83);
        end;

        local function CalculateTargetCameraCFrame(p84, p85, p86, p87) -- Line: 543
            -- upvalues: GetModelBounds (ref), Position (copy), camera (ref), u77 (ref), u78 (ref), u79 (ref), u80 (ref), Unit (ref), Unit2 (copy)
            local v88 = 5;
            local v89 = 0;
            local v90, v91, v92 = GetModelBounds();

            if v90 and (v91 and v92) then
                v88 = math.max(v88, v92.Magnitude * 0.5);
                v89 = math.max(v89, v92.Y * 0.35);
            end;

            local v93 = v90 and (v91 and v91.Position) or Position;
            local v94 = math.rad(camera.FieldOfView * 0.5);
            local v95 = math.max(v88, 5) * 1.4;
            local v96 = math.max(v94, 0.1);
            local v97 = v95 / math.tan(v96) + 8;
            local v98 = math.clamp(v97, 20, 58);
            local v99 = math.max(p87, 0.016666666666666666) * -0.6;
            u77 = u77:Lerp(v93, 1 - math.exp(v99));
            local v100 = math.max(p87, 0.016666666666666666) * -0.4;
            u78 = u78 + (v95 - u78) * (1 - math.exp(v100));
            local v101 = math.max(p87, 0.016666666666666666) * -0.5;
            u79 = u79 + (v89 - u79) * (1 - math.exp(v101));
            local v102 = math.max(p87, 0.016666666666666666) * -0.4;
            u80 = u80 + (v98 - u80) * (1 - math.exp(v102));
            local v103 = math.sin(p86 * 0.55) * 0.075;
            local Unit3 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v103):VectorToWorldSpace(Unit).Unit;
            local v104 = Unit2 * (math.sin(p86 * 0.55 * 0.6) * 1.25);
            local v105 = math.clamp(p84 * 5 + 5 + u79 * 0.12, 4, 12);
            local v106 = math.clamp(1.2 - u79 * 0.08, 0.35, 1.2);
            local v107 = u77 - Unit3 * u80 + Vector3.new(0, v105, 0) + v104;
            local v108 = u77 + Vector3.new(0, v106, 0);

            return CFrame.new(v107, v108);
        end;

        local u109 = false;
        local u110 = false;
        local v111 = os.clock();
        local v112 = 0;
        task.spawn(function() -- Line: 590
            -- upvalues: TweenAge (ref), u58 (ref), u50 (ref), endAge (ref), u49 (ref), u51 (ref), u52 (ref), IsCancelled (ref), onStep (ref), u110 (ref), u109 (ref)
            local v113 = TweenAge(u58, u50, endAge, u49, u51, u52, IsCancelled, onStep);
            u110 = not v113;

            if v113 then
                u58:SetAttribute("Age", endAge);
            end;

            u109 = true;
        end);

        if camera then
            if u68 then
                u68:Disconnect();
                u68 = nil;
            end;

            CFrame2 = CalculateTargetCameraCFrame(0, 0, 0, 0.016666666666666666);
            camera.CFrame = CFrame2;

            while not u109 and (not u55 and u58.Parent) do
                local v114 = os.clock() - v111;
                local v115 = math.clamp(v114 / u49, 0, 1);
                camera.CameraType = Enum.CameraType.Scriptable;
                CFrame2 = CFrame2:Lerp(CalculateTargetCameraCFrame(v115 < 0.5 and v115 * 2 * v115 or 1 - (v115 * -2 + 2) ^ 3 / 2, v115, v114, v112), (math.clamp(((1 - v115) * 0.45 + 0.55) * 0.8 * v112, 0, 0.12)));
                camera.CFrame = CFrame2;
                v112 = RunService.Heartbeat:Wait();
            end;
        end;

        while not u109 do
            RunService.Heartbeat:Wait();
        end;

        local v116 = not u110;

        if camera and v116 then
            StopGrowthSound(u72, 1.5);
            local v117 = u46.idleDuration or 3;
            local v118 = os.clock();
            local _ = 2 + v117;
            task.spawn(function() -- Line: 661
                -- upvalues: u1 (ref), u44 (ref), u58 (ref), u46 (ref), u49 (ref), u48 (ref), u74 (ref), u51 (ref), u52 (ref), IsCancelled (ref)
                u1.GrowFruits(u44, u58, {
                    duration = u46.fruitDuration or u49,
                    seed = u48,
                    sizeMultiplier = u74,
                    easingStyle = u51,
                    easingDirection = u52,
                    _cancelled = IsCancelled
                });
            end);
            local v119, v120, _ = GetModelBounds();
            local v121 = v119 and (v120 and v120.Position) or u58:GetPivot().Position;
            local u122 = 0;
            local u123 = 0;
            local u124 = false;
            local u125 = os.clock();
            local u126 = UserInputService:GetMouseLocation();
            local u127 = 0;
            local u128 = os.clock();
            local u129 = {};
            local u130 = nil;
            local v135 = UserInputService.InputChanged:Connect(function(p131) -- Line: 696
                -- upvalues: u127 (ref), u128 (ref), u129 (ref), u130 (ref), u124 (ref), UserInputService (ref), u126 (ref), u122 (ref), u123 (ref), u125 (ref)
                if p131.UserInputType == Enum.UserInputType.MouseWheel then
                    u127 = math.max(u127 + p131.Position.Z * 4, -8);
                    u128 = os.clock();

                    return;
                end;

                if p131.UserInputType == Enum.UserInputType.Touch then
                    u129[p131] = p131.Position;
                    local v132 = {};

                    for _, v in u129 do
                        table.insert(v132, v);
                    end;

                    if #v132 == 2 then
                        local Magnitude = (v132[1] - v132[2]).Magnitude;

                        if u130 ~= nil then
                            u127 = math.max(u127 + (Magnitude - u130) * 0.18, -8);
                            u128 = os.clock();
                        end;

                        u130 = Magnitude;

                        return;
                    end;

                    u130 = nil;
                end;

                if not u124 then
                    return;
                end;

                if p131.UserInputType ~= Enum.UserInputType.MouseMovement and p131.UserInputType ~= Enum.UserInputType.Touch then
                    return;
                end;

                local v133 = UserInputService:GetMouseLocation();
                local v134 = v133 - u126;
                u126 = v133;
                u122 = u122 - v134.X * 0.4;
                u123 = math.clamp(u123 - v134.Y * 0.4, -30, 30);
                u125 = os.clock();
            end);
            local v137 = UserInputService.InputBegan:Connect(function(p136) -- Line: 741
                -- upvalues: u129 (ref), u124 (ref), u125 (ref), u126 (ref), UserInputService (ref)
                if p136.UserInputType == Enum.UserInputType.MouseButton1 or p136.UserInputType == Enum.UserInputType.Touch then
                    u129[p136] = p136.Position;
                    u124 = true;
                    u125 = os.clock();
                    u126 = UserInputService:GetMouseLocation();
                end;
            end);
            local v140 = UserInputService.InputEnded:Connect(function(p138) -- Line: 750
                -- upvalues: u129 (ref), u130 (ref), u124 (ref)
                if p138.UserInputType == Enum.UserInputType.MouseButton1 or p138.UserInputType == Enum.UserInputType.Touch then
                    u129[p138] = nil;
                    u130 = nil;
                    local v139 = false;

                    for _ in u129 do
                        v139 = true;
                        break;
                    end;

                    if not v139 then
                        u124 = false;
                    end;
                end;
            end);
            local v141 = false;

            while not (u55 or u55) do
                local v142 = os.clock() - v118;
                local v143 = math.clamp(v142 / 2, 0, 1);
                local v144 = os.clock() - v111;

                if not u124 then
                    local v145 = (v142 - 2) / math.max(v117, 0.001);
                    math.clamp(v145, 0, 1);
                end;

                if os.clock() - u128 >= 2.5 then
                    u127 = u127 * (1 - (1 - math.exp(v112 * -2.5)));
                end;

                u127 = math.clamp(u127, -8, 22);
                local v146 = math.clamp(u127 + 0, -8, 40);
                camera.FieldOfView = u67;

                if not u124 and os.clock() - u125 >= 2 then
                    local v147 = 1 - math.exp(v112 * -3.5);
                    u122 = u122 * (1 - v147);
                    u123 = u123 * (1 - v147);
                end;

                if not v141 and 2 + v117 <= v142 then
                    v141 = true;

                    if onComplete then
                        task.spawn(function() -- Line: 812
                            -- upvalues: onComplete (ref), u58 (ref)
                            onComplete(u58);
                        end);
                    end;
                end;

                local v148 = CalculateTargetCameraCFrame(1, 1, v144, v112);
                local v149 = v148:Lerp(CFrame.new(v148.Position + (v121 - v148.Position).Unit * v146 + Vector3.new(0, -1.25, 0), v121 + Vector3.new(0, 0.55, 0)), v143);

                if math.abs(u122) > 0.001 or math.abs(u123) > 0.001 then
                    local v150 = v149.Position - v121;
                    local v151 = CFrame.new(v121) * CFrame.Angles(0, math.rad(u122), 0) * CFrame.Angles(math.rad(u123), 0, 0) * CFrame.new(v150);
                    v149 = CFrame.new(v151.Position, v121 + Vector3.new(0, 0.55, 0));
                end;

                CFrame2 = CFrame2:Lerp(v149, (math.clamp(v112 * 3.2, 0, 0.1)));
                camera.CFrame = CFrame2;
                v112 = RunService.Heartbeat:Wait();
            end;

            v135:Disconnect();
            v137:Disconnect();
            v140:Disconnect();
            u129 = {};
            u130 = nil;
        end;

        if v116 then
            if onComplete then
                onComplete(u58);
            end;

            return;
        end;

        if onCancelled then
            onCancelled(u58);
        end;
    end);

    return function(p152) -- Line: 872
        -- upvalues: u55 (ref), StopGrowthSound (ref), u72 (ref), u60 (ref), u63 (copy), u68 (ref), camera (copy), u64 (ref), u65 (ref), u67 (ref), u66 (ref)
        u55 = true;
        StopGrowthSound(u72, 1.5);
        u60 = false;

        if u63 then
            u63:Disconnect();
        end;

        if u68 then
            u68:Disconnect();
            u68 = nil;
        end;

        if not p152 and camera then
            camera.CameraType = u64;
            camera.CameraSubject = u65;
            camera.FieldOfView = u67;
            camera.CFrame = u66;
        end;
    end;
end;

return u1;