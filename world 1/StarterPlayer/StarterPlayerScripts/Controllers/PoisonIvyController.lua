-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local LocalPlayer = Players.LocalPlayer;
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local Signal = require(ReplicatedStorage.ClientModules.Signal);
local FieldOfViewController = require(script.Parent.FieldOfViewController);
local ImpactTouch = game.SoundService.SFX.ImpactTouch;
Signal.new();
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = 0;
local u9 = 0;
local u10 = 0;
local u11 = nil;
local u12 = OverlapParams.new();
u12.FilterType = Enum.RaycastFilterType.Include;
u12.FilterDescendantsInstances = {};

local function rebuildOverlapFilter() -- Line: 49
    -- upvalues: Players (copy), u12 (copy)
    local v13 = {};

    for _, v in Players:GetPlayers() do
        if v.Character then
            table.insert(v13, v.Character);
        end;
    end;

    u12.FilterDescendantsInstances = v13;
end;

Players.PlayerAdded:Connect(rebuildOverlapFilter);
Players.PlayerRemoving:Connect(rebuildOverlapFilter);
task.spawn(function() -- Line: 62
    -- upvalues: rebuildOverlapFilter (copy)
    while true do
        rebuildOverlapFilter();
        task.wait(5);
    end;
end);

function u1.GetPlantFromFruit(p14, p15) -- Line: 69
    local Parent = p15.Parent;

    if Parent and (not Parent or Parent.Name == "Fruits") then
        return Parent.Parent;
    end;
end;

function u1.UpdateAppearance(p16, p17, p18) -- Line: 76
    -- upvalues: TweenService (copy), ReplicatedStorage (copy), CollectionService (copy)
    if not p18 then
        for _, v in CollectionService:GetTagged("PoisonIvyAppearance") do
            if v:IsDescendantOf(p17) then
                v:RemoveTag("PoisonIvyAppearance");

                if v:IsA("ParticleEmitter") then
                    v.Enabled = false;
                    game.Debris:AddItem(v, 1);
                elseif v:IsA("BasePart") then
                    TweenService:Create(v, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                        Size = Vector3.new(0.01, 0.01, 0.01)
                    }):Play();
                    game.Debris:AddItem(v, 0.15);
                end;
            end;
        end;

        for _, v in CollectionService:GetTagged("PoisonIvySwell") do
            if v:IsDescendantOf(p17) then
                v:RemoveTag("PoisonIvySwell");

                if v:GetAttribute("originalSize") and v:GetAttribute("originalColor") then
                    TweenService:Create(v, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                        Size = v:GetAttribute("originalSize"),
                        Color = v:GetAttribute("originalColor")
                    }):Play();
                end;
            end;
        end;

        return;
    end;

    local function applySwell(p19) -- Line: 81
        -- upvalues: TweenService (ref)
        if p19:HasTag("PoisonIvySwell") then
            return false;
        end;

        p19:AddTag("PoisonIvySwell");

        if not p19:GetAttribute("originalSize") then
            p19:SetAttribute("originalSize", p19.Size);
        end;

        if not p19:GetAttribute("originalColor") then
            p19:SetAttribute("originalColor", p19.Color);
        end;

        local v20 = Random.new():NextNumber(1.1, 1.3);
        TweenService:Create(p19, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = p19.Size * v20,
            Color = Color3.new(0.737255, 0.184314, 0.184314)
        }):Play();

        return true;
    end;

    local v21 = {};
    local v22 = 0;

    for _, child in p17:GetChildren() do
        if child:IsA("Part") and (not child:IsA("Part") or child.Transparency == 0) then
            table.insert(v21, child);
            local Part = Instance.new("Part");
            Part.Parent = p17;
            Part.Shape = Enum.PartType.Ball;
            Part.Size = Vector3.new(0.01, 0.01, 0.01);
            local Position = child.Position;
            local v23 = child.Size.X / 2.5;
            local v24 = Random.new();
            Part.Position = Position + Vector3.new(v23, 0, v24:NextNumber(-child.Size.Z / 2.5, child.Size.Z / 2.5));
            Part.Color = Color3.fromRGB(255, 17, 21);
            Part.Anchored = false;
            Part.CanCollide = false;
            Part.CanQuery = false;
            TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = Vector3.new(1, 1, 1) * Random.new():NextNumber(0.35, 0.75)
            }):Play();
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Parent = Part;
            WeldConstraint.Part0 = Part;
            WeldConstraint.Part1 = child;
            Part:AddTag("PoisonIvyAppearance");

            if math.random(1, 3) == 1 and applySwell(child) then
                v22 = v22 + 1;
            end;
        end;
    end;

    if v22 == 0 and #v21 > 0 then
        applySwell(v21[math.random(1, #v21)]);
    end;

    local PoisonIvyVFX = ReplicatedStorage.Assets.VFX.StatusVFX:FindFirstChild("PoisonIvyVFX");

    if PoisonIvyVFX == nil then
        return;
    end;

    for _, child in PoisonIvyVFX:GetChildren() do
        local v25 = child:Clone();
        v25.Parent = p17:FindFirstChild("Torso") or p17.PrimaryPart;
        v25.Enabled = true;
        v25:AddTag("PoisonIvyAppearance");
    end;
end;

function u1.StartLocalPlayerEffects(p26) -- Line: 189
    -- upvalues: u5 (ref), u8 (ref), u9 (ref), u11 (ref), LocalPlayer (copy), u7 (ref), u6 (ref), RunService (copy), u10 (ref), FieldOfViewController (copy)
    if u5 then
        return;
    end;

    u5 = true;
    u8 = tick();
    u9 = 0;
    u11 = nil;
    local v27 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v27 then
        return;
    end;

    u7 = Instance.new("ScreenGui");
    u7.Name = "PoisonIvyScreenEffect";
    u7.IgnoreGuiInset = true;
    u7.ResetOnSpawn = false;
    u7.DisplayOrder = 1000;
    u7.Parent = v27;
    local Frame = Instance.new("Frame");
    Frame.Name = "RedFlash";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(255, 55, 55);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 10;
    Frame.Parent = u7;
    u6 = RunService.RenderStepped:Connect(function() -- Line: 217
        -- upvalues: u8 (ref), LocalPlayer (ref), u7 (ref), Frame (copy), u10 (ref), FieldOfViewController (ref), u9 (ref)
        local v28 = tick() - u8;
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character then
            local v29 = math.sin(v28 * 4) * 0.3 + math.sin(v28 * 7.3) * 0.1;
            local v30 = math.cos(v28 * 5.2) * 0.3 + math.sin(v28 * 9.1) * 0.08;
            Character.CameraOffset = Vector3.new(v29, v30, 0);
        end;

        if u7 and Frame.Parent then
            local v31 = math.sin(v28 * 2.5);
            Frame.BackgroundTransparency = 0.95 - math.max(0, v31) ^ 3 * 0.28;
        end;

        local v32 = math.sin(v28 * 1.8) * 15 + -35;
        u10 = v32;
        FieldOfViewController:SetAdjuster(v32, false);

        if Character and (Character.Health > 0 and v28 - u9 >= 1) then
            u9 = v28;
            Character:TakeDamage(1);
        end;
    end);
end;

function u1.StopLocalPlayerEffects(p33) -- Line: 253
    -- upvalues: u5 (ref), u6 (ref), LocalPlayer (copy), TweenService (copy), u11 (ref), u10 (ref), FieldOfViewController (copy), u7 (ref), Debris (copy)
    if not u5 then
        return;
    end;

    u5 = false;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    local Character = LocalPlayer.Character;
    local v34 = Character and Character:FindFirstChildOfClass("Humanoid");

    if v34 then
        TweenService:Create(v34, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CameraOffset = Vector3.new(0, 0, 0)
        }):Play();
    end;

    local u35 = {};
    u11 = u35;
    local u36 = u10;
    task.spawn(function() -- Line: 279
        -- upvalues: u11 (ref), u35 (copy), FieldOfViewController (ref), u36 (copy), u10 (ref)
        local v37 = tick();

        while u11 == u35 do
            local v38 = (tick() - v37) / 0.5;
            local v39 = math.min(v38, 1);
            FieldOfViewController:SetAdjuster(u36 * (1 - (1 - (1 - v39) ^ 3)), false);

            if v39 >= 1 then
                FieldOfViewController:SetAdjuster(0, false);
                u11 = nil;
                u10 = 0;

                return;
            end;

            task.wait();
        end;
    end);

    if u7 then
        local u40 = u7;
        u7 = nil;
        local RedFlash = u40:FindFirstChild("RedFlash");

        if RedFlash then
            local v41 = TweenInfo.new(0.5);
            local v42 = TweenService:Create(RedFlash, v41, {
                BackgroundTransparency = 1
            });
            v42:Play();
            Debris:AddItem(v42, v41.Time);
            v42.Completed:Connect(function() -- Line: 315
                -- upvalues: u40 (copy)
                u40:Destroy();
            end);

            return;
        end;

        u40:Destroy();
    end;
end;

function u1.ScheduleAppearanceRemoval(p43, u44) -- Line: 324
    -- upvalues: u4 (copy), u1 (copy), LocalPlayer (copy)
    if not u44.Character then
        return;
    end;

    local u45 = {};
    u4[u44] = u45;
    local v46 = Random.new():NextNumber(7, 11);
    task.delay(v46, function() -- Line: 334
        -- upvalues: u4 (ref), u44 (copy), u45 (copy), u1 (ref), LocalPlayer (ref)
        if u4[u44] ~= u45 then
            return;
        end;

        u4[u44] = nil;

        if u44.Character then
            u1:UpdateAppearance(u44.Character, false);
        end;

        if u44 == LocalPlayer then
            u1:StopLocalPlayerEffects();
        end;
    end);
end;

function u1.RegisterPoisonObject(p47, p48) -- Line: 351
    -- upvalues: u2 (copy)
    table.insert(u2, {
        Object = p48
    });
end;

function u1.UnregisterPoisonObject(p49, p50) -- Line: 357
    -- upvalues: u2 (copy)
    for i, v in u2 do
        if v.Object == p50 then
            table.remove(u2, i);

            return;
        end;
    end;
end;

function u1.GetTouchingParts(p51, p52) -- Line: 366
    -- upvalues: Players (copy), u12 (copy), u1 (copy), LocalPlayer (copy), u3 (copy), u4 (copy), ImpactTouch (copy), Networking (copy)
    local Position = p52.Position;
    local v53 = false;

    for _, v in Players:GetPlayers() do
        local Character = v.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character and (Character.Position - Position).Magnitude < 30 then
            v53 = true;
            break;
        end;
    end;

    if not v53 then
        return;
    end;

    local v54 = workspace:GetPartsInPart(p52, u12);

    if #v54 ~= 0 then
        local v55 = {};

        for _, v in v54 do
            if v.Parent then
                local v56 = v:FindFirstAncestorWhichIsA("Model");
                local v57;

                if v56 then
                    v57 = Players:GetPlayerFromCharacter(v56);
                else
                    v57 = nil;
                end;

                if v57 then
                    local v58 = u1:GetPlantFromFruit(p52.Parent);

                    if v58 then
                        local v59 = v58:GetAttribute("UserId");

                        if v59 and (not v59 or v59 ~= LocalPlayer.UserId) then
                            table.insert(v55, v57);

                            if not table.find(u3, v57) then
                                local v60 = u4[v57] ~= nil;
                                u4[v57] = nil;
                                table.insert(u3, v57);

                                if not v60 then
                                    u1:UpdateAppearance(v57.Character, true);
                                end;

                                if v57 == LocalPlayer then
                                    u1:StartLocalPlayerEffects();
                                end;

                                ImpactTouch.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                                ImpactTouch.TimePosition = 0;
                                ImpactTouch.Playing = true;
                                local v61;

                                if p52.Parent then
                                    v61 = p52.Parent:GetAttribute("FruitId") or nil;
                                else
                                    v61 = nil;
                                end;

                                if v61 then
                                    local v62 = p52.Parent and (p52.Parent:GetAttribute("PlantId") or "") or "";
                                    Networking.PoisonIvyService.TouchBegan:Fire(v57.Character, v61, v62);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        return v55;
    end;
end;

function u1.Routine(p63) -- Line: 430
    -- upvalues: u2 (copy), u1 (copy), Players (copy), u3 (copy), Networking (copy)
    local v64 = {};

    for _, v in u2 do
        local v65 = u1:GetTouchingParts(v.Object);

        if v65 and (not v65 or #v65 ~= 0) then
            table.move(v65, 1, #v65, #v64 + 1, v64);
        end;
    end;

    for _, v in Players:GetPlayers() do
        if not table.find(v64, v) then
            local v66 = table.find(u3, v);

            if v66 then
                table.remove(u3, v66);
                u1:ScheduleAppearanceRemoval(v);
                Networking.PoisonIvyService.TouchEnded:Fire(v.Character);
            end;
        end;
    end;
end;

function u1.Init(p67) -- Line: 454
    -- upvalues: CollectionService (copy), u1 (copy)
    for _, v in CollectionService:GetTagged("PoisonIvy") do
        u1:RegisterPoisonObject(v);
    end;

    CollectionService:GetInstanceAddedSignal("PoisonIvy"):Connect(function(p68) -- Line: 459
        -- upvalues: u1 (ref)
        u1:RegisterPoisonObject(p68);
    end);
    CollectionService:GetInstanceRemovedSignal("PoisonIvy"):Connect(function(p69) -- Line: 463
        -- upvalues: u1 (ref)
        u1:UnregisterPoisonObject(p69);
    end);
    task.spawn(function() -- Line: 467
        -- upvalues: u1 (ref)
        while true do
            u1:Routine();
            task.wait(0.5);
        end;
    end);
end;

return u1;