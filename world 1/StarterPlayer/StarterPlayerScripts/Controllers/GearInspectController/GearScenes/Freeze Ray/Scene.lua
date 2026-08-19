-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://135341385465559";
local Animation2 = Instance.new("Animation");
Animation2.AnimationId = "rbxassetid://88915834483502";
local Animation3 = Instance.new("Animation");
Animation3.AnimationId = "rbxassetid://83507025846411";
local FreezeInspect = script.Parent.FreezeInspect;
FreezeInspect.Parent = nil;

function v1.Run(p2) -- Line: 22
    -- upvalues: FreezeInspect (copy), RunService (copy), Animation (copy), Animation2 (copy), Animation3 (copy)
    local _ = p2.Plot;
    local PlayerModel = p2.PlayerModel;
    local Camera = p2.Camera;
    local Trove = p2.Trove;

    if not (PlayerModel and p2.PlayerHumanoid) then
        return;
    end;

    local u3 = FreezeInspect:Clone();
    Trove:Add(u3);
    local v4 = PlayerModel:Clone();
    v4.PrimaryPart = v4.HumanoidRootPart;
    v4:PivotTo(u3.Player1:GetPivot());
    v4.Parent = u3;
    local u5 = u3.Player1["Freeze Ray"]:Clone();
    u5.Parent = v4;
    u3.Player1:Destroy();
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = u5.Handle;
    WeldConstraint.Part1 = v4["Right Arm"];
    WeldConstraint.Parent = v4;
    v4.Name = "Player1";
    u3.Parent = workspace.Terrain;
    Camera.CameraType = Enum.CameraType.Scriptable;
    local u7 = RunService.RenderStepped:Connect(function(p6) -- Line: 66
        -- upvalues: u3 (copy), Camera (copy)
        if not u3.Parent then
            return;
        end;

        workspace.CurrentCamera.CFrame = u3.Camera.Camera.CFrame;
        Camera.FieldOfView = 35;
    end);
    Trove:Add(u7);
    local v8 = { Animation, Animation2, Animation3 };
    game:GetService("ContentProvider"):PreloadAsync(v8);
    local u9 = script.FadeIn:Clone();
    u9.Parent = game.Players.LocalPlayer.PlayerGui;
    u9.Frame.BackgroundTransparency = 0;
    Trove:Add(u9);

    repeat
        task.wait(0.25);
    until game:GetService("ContentProvider").RequestQueueSize == 0;

    if not u3.Parent then
        return;
    end;

    local u10 = v4.Humanoid.Animator:LoadAnimation(Animation);
    local u11 = u3.Player2.Humanoid.Animator:LoadAnimation(Animation2);
    local u12 = u3.Camera.AnimationController.Animator:LoadAnimation(Animation3);
    local v13 = {};
    workspace.CurrentCamera.FieldOfView = 35;
    local u14 = nil;
    p2:ApplyRandomFriendAppearance(u3.Player2, nil, true);

    if not u3.Parent then
        return;
    end;

    local function CreateProjectile() -- Line: 109
        local Part = Instance.new("Part");
        Part.Name = "FreezeRayShot";
        Part.Color = Color3.fromRGB(100, 180, 255);
        Part.Material = Enum.Material.Neon;
        Part.Shape = Enum.PartType.Block;
        Part.Size = Vector3.new(0.3, 0.3, 3);
        Part.TopSurface = Enum.SurfaceType.Smooth;
        Part.BottomSurface = Enum.SurfaceType.Smooth;
        Part.CanCollide = false;
        Part.Anchored = true;
        Part.Locked = true;
        Part.CastShadow = false;
        local PointLight = Instance.new("PointLight");
        PointLight.Color = Color3.fromRGB(100, 180, 255);
        PointLight.Brightness = 1;
        PointLight.Range = 8;
        PointLight.Parent = Part;
        local SelectionBox = Instance.new("SelectionBox");
        SelectionBox.Adornee = Part;
        SelectionBox.Color = BrickColor.new("Toothpaste");
        SelectionBox.Parent = Part;

        return Part;
    end;

    local v15 = u12:GetMarkerReachedSignal("ChargeGun");
    table.insert(v13, v15:Connect(function() -- Line: 140
        -- upvalues: u5 (copy)
        for _, child in u5.EmissivePart:GetChildren() do
            if child:IsA("SurfaceAppearance") then
                game.TweenService:Create(child, TweenInfo.new(0.3), {
                    EmissiveStrength = 4
                }):Play();
                task.delay(0.3, function() -- Line: 145
                    -- upvalues: child (copy)
                    if child then
                        game.TweenService:Create(child, TweenInfo.new(0.2), {
                            EmissiveStrength = 3
                        }):Play();
                    end;
                end);
            elseif child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount") or 1);
                child.Enabled = true;
            end;
        end;

        game.TweenService:Create(u5.Ice.SurfaceAppearance, TweenInfo.new(0.3), {
            EmissiveStrength = 4
        }):Play();
        task.delay(0.3, function() -- Line: 160
            -- upvalues: u5 (ref)
            if u5:FindFirstChild("Ice") and u5.Ice:FindFirstChild("SurfaceAppearance") then
                game.TweenService:Create(u5.Ice.SurfaceAppearance, TweenInfo.new(0.2), {
                    EmissiveStrength = 3
                }):Play();
            end;
        end);
    end));
    local v16 = u12:GetMarkerReachedSignal("Fire");
    table.insert(v13, v16:Connect(function() -- Line: 169
        -- upvalues: u5 (copy), u3 (copy), CreateProjectile (copy)
        for _, descendant in u5:GetDescendants() do
            if descendant:IsA("SurfaceAppearance") then
                game.TweenService:Create(descendant, TweenInfo.new(0.3), {
                    EmissiveStrength = 4
                }):Play();
                task.delay(0.3, function() -- Line: 174
                    -- upvalues: descendant (copy)
                    if descendant then
                        game.TweenService:Create(descendant, TweenInfo.new(0.2), {
                            EmissiveStrength = 3
                        }):Play();
                    end;
                end);
            end;
        end;

        local v17 = game.SoundService.SFX.FreezeRay:Clone();
        v17.TimePosition = 0.1;
        v17:Play();
        v17.Parent = u5.Handle;
        game.Debris:AddItem(v17, 3);

        for _, child in u5.Nozzle.Attachment:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount") or 1);
        end;

        local v18 = CFrame.new(u5.Nozzle.CFrame.Position, u3.Player2.Torso.Position);
        local u19 = CreateProjectile();
        u19.CFrame = v18 + v18.LookVector * 1.5;
        u19.Parent = u3;
        game.Debris:AddItem(u19, 0.15);
        local u20 = 0;
        task.spawn(function() -- Line: 208
            -- upvalues: u20 (ref), u19 (copy)
            while u20 < 0.15 and u19 do
                local v21 = game:GetService("RunService").Heartbeat:Wait();
                u20 = u20 + v21;
                local v22 = u19;
                v22.CFrame = v22.CFrame * CFrame.new(0, 0, -120 * v21);
            end;
        end);
    end));
    local v23 = u12:GetMarkerReachedSignal("Freeze");
    table.insert(v13, v23:Connect(function() -- Line: 218
        -- upvalues: u14 (ref), u3 (copy)
        u14 = game.ReplicatedStorage.Assets.Ice_Part:Clone();
        u14.CFrame = CFrame.new(u3.Player2.Torso.Position);
        local WeldConstraint2 = Instance.new("WeldConstraint");
        WeldConstraint2.Part0 = u14;
        WeldConstraint2.Part1 = u3.Player2.Torso;
        WeldConstraint2.Parent = u14;
        u14.Transparency = 0;
        local v24 = game.SoundService.SFX.Freeze:Clone();
        v24.Parent = u14;
        v24.TimePosition = 0;
        v24.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        v24.Playing = true;
        game.Debris:AddItem(v24, v24.TimeLength * v24.PlaybackSpeed);
        u14.Parent = u3;
        local v25 = script.Highlight:Clone();
        v25.Parent = u14;
        v25.Enabled = true;
        v25.Adornee = u14;
        game.TweenService:Create(v25, TweenInfo.new(0.1), {
            FillTransparency = 1,
            OutlineTransparency = 1
        }):Play();
        game.Debris:AddItem(v25, 0.1);
        task.delay(0.1, function() -- Line: 248
            -- upvalues: u14 (ref)
            game.TweenService:Create(u14, TweenInfo.new(0.1), {
                Transparency = 0.4
            }):Play();
        end);

        for _, child in u14:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount") or 0);
            elseif child:IsA("PointLight") then
                game.TweenService:Create(child, TweenInfo.new(0.1), {
                    Brightness = 6
                }):Play();
                task.delay(0.3, function() -- Line: 258
                    -- upvalues: child (copy)
                    game.TweenService:Create(child, TweenInfo.new(0.1), {
                        Brightness = 1
                    }):Play();
                end);
            end;
        end;
    end));
    local v26 = u12:GetMarkerReachedSignal("PowerDown");
    table.insert(v13, v26:Connect(function() -- Line: 267
        -- upvalues: u5 (copy)
        for _, descendant in u5:GetDescendants() do
            if descendant:IsA("SurfaceAppearance") then
                game.TweenService:Create(descendant, TweenInfo.new(1), {
                    EmissiveStrength = 0
                }):Play();
            end;
        end;
    end));
    local v27 = u12:GetMarkerReachedSignal("Start");
    table.insert(v13, v27:Connect(function() -- Line: 280
        -- upvalues: u5 (copy), u9 (copy), u14 (ref)
        for _, descendant in u5:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant:Clear();
            end;
        end;

        u5.EmissivePart.SurfaceAppearance.EmissiveStrength = 0;
        u5.Ice.SurfaceAppearance.EmissiveStrength = 0;
        game.TweenService:Create(u9.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play();

        if u14 then
            u14:Destroy();
        end;
    end));
    local v28 = u12:GetMarkerReachedSignal("FadeOut");
    table.insert(v13, v28:Connect(function() -- Line: 299
        -- upvalues: u9 (copy)
        game.TweenService:Create(u9.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 0
        }):Play();
    end));
    u10.Looped = true;
    u11.Looped = true;
    u12.Looped = true;
    u10:Play();
    u11:Play();
    u12:Play();
    Camera.FieldOfView = 25;
    Trove:Add(function() -- Line: 317
        -- upvalues: u14 (ref), u9 (copy), u7 (ref), u10 (copy), u12 (copy), u11 (copy)
        if u14 then
            u14:Destroy();
        end;

        if u9 then
            u9:Destroy();
        end;

        if u7 then
            u7:Disconnect();
        end;

        if u10 then
            u10:Stop();
            u10:Destroy();
        end;

        if u12 then
            u12:Stop();
            u12:Destroy();
        end;

        if u11 then
            u11:Stop();
            u11:Destroy();
        end;
    end);
end;

return v1;