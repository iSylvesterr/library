-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://115826940676460";
local Animation2 = Instance.new("Animation");
Animation2.AnimationId = "rbxassetid://94444226083144";
local Animation3 = Instance.new("Animation");
Animation3.AnimationId = "rbxassetid://130479531142776";
local HoseInspect = script.Parent.HoseInspect;
HoseInspect.Parent = nil;

function v1.Run(p2) -- Line: 24
    -- upvalues: HoseInspect (copy), RunService (copy), Animation (copy), Animation2 (copy), Animation3 (copy)
    local _ = p2.Plot;
    local PlayerModel = p2.PlayerModel;
    local Camera = p2.Camera;
    local Trove = p2.Trove;

    if not (PlayerModel and p2.PlayerHumanoid) then
        return;
    end;

    local u3 = HoseInspect:Clone();
    Trove:Add(u3);
    local v4 = PlayerModel:Clone();
    v4.PrimaryPart = v4.HumanoidRootPart;
    v4:PivotTo(u3.Player1:GetPivot());
    v4.Parent = u3;
    local u5 = u3.Player1["Power Hose"]:Clone();
    u5.Parent = v4;
    local v6 = u3.Player1.PowerWasherBack:Clone();
    v6.Parent = v4;
    v6:SetPrimaryPartCFrame(v4.Torso.CFrame);
    u3.Player1:Destroy();
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = u5.Handle;
    WeldConstraint.Part1 = v4["Right Arm"];
    WeldConstraint.Parent = v4;
    local WeldConstraint2 = Instance.new("WeldConstraint");
    WeldConstraint2.Part0 = v6.Prim;
    WeldConstraint2.Part1 = v4.Torso;
    WeldConstraint2.Parent = v4;
    v4.Name = "Player1";
    u3.Parent = workspace.Terrain;
    Camera.CameraType = Enum.CameraType.Scriptable;
    local u8 = RunService.RenderStepped:Connect(function(p7) -- Line: 78
        -- upvalues: u3 (copy), Camera (copy)
        if not u3.Parent then
            return;
        end;

        workspace.CurrentCamera.CFrame = u3.Camera.Camera.CFrame;
        Camera.FieldOfView = 35;
    end);
    Trove:Add(u8);
    local v9 = { Animation, Animation2, Animation3 };
    game:GetService("ContentProvider"):PreloadAsync(v9);
    local u10 = script.FadeIn:Clone();
    u10.Parent = game.Players.LocalPlayer.PlayerGui;
    u10.Frame.BackgroundTransparency = 0;
    Trove:Add(u10);

    repeat
        task.wait(0.25);
    until game:GetService("ContentProvider").RequestQueueSize == 0;

    if not u3.Parent then
        return;
    end;

    local u11 = v4.Humanoid.Animator:LoadAnimation(Animation);
    local u12 = u3.Player2.Humanoid.Animator:LoadAnimation(Animation2);
    local u13 = u3.Camera.AnimationController.Animator:LoadAnimation(Animation3);
    local v14 = {};
    workspace.CurrentCamera.FieldOfView = 20;
    p2:ApplyRandomFriendAppearance(u3.Player2, nil, true);

    if not u3.Parent then
        return;
    end;

    local v15 = nil;
    local u16 = nil;
    local u17 = nil;

    local function ReplaceWithManipulableWeld(p18, p19, p20) -- Line: 128
        local v21 = p20.CFrame:Inverse() * p19.CFrame;
        local Parent = p18.Parent;
        p18:Destroy();
        local Weld = Instance.new("Weld");
        Weld.Name = "PowerHose_WaterWeld";
        Weld.Part0 = p20;
        Weld.Part1 = p19;
        Weld.C0 = v21;
        Weld.C1 = CFrame.new();
        Weld.Parent = Parent;

        return Weld, v21, CFrame.new();
    end;

    local Water = v6:FindFirstChild("Water");
    local Size = Water.Size;
    local u26, v27 = (function(p22) -- Line: 149, Name: FindWeldForWater
        local v23 = {};
        local Parent = p22.Parent;
        local v24 = Parent and Parent:FindFirstChild("Prim");

        if v24 then
            table.insert(v23, v24);
        end;

        table.insert(v23, p22);

        if Parent then
            table.insert(v23, Parent);
        end;

        local v25 = p22:FindFirstAncestorWhichIsA("Model");

        if v25 then
            table.insert(v23, v25);
        end;

        for _, v in v23 do
            for _, v2 in (v == p22 or v == Parent) and v:GetChildren() or v:GetDescendants() do
                if v2:IsA("WeldConstraint") then
                    if v2.Part0 == p22 then
                        return v2, v2.Part1;
                    end;

                    if v2.Part1 == p22 then
                        return v2, v2.Part0;
                    end;
                end;

                if v2:IsA("JointInstance") and (v2.Part0 == p22 or v2.Part1 == p22) then
                    return v2, v2.Part0 == p22 and v2.Part1 or v2.Part0;
                end;
            end;
        end;

        return nil, nil;
    end)(Water);

    if u26 then
        local _ = u26.Parent;

        if u26:IsA("WeldConstraint") then
            u26, u16, u17 = ReplaceWithManipulableWeld(u26, Water, v27);
        elseif u26:IsA("JointInstance") then
            u16 = u26.C0;
            u17 = u26.C1;
        else
            u26 = v15;
        end;
    else
        u26 = v15;
    end;

    local function SetWaterLevel(p28, p29, p30, p31, p32) -- Line: 215
        -- upvalues: Water (copy)
        local v33 = p29.Y * math.clamp(p32, 0, 1);
        local v34 = math.max(v33, 0.001);
        Water.Size = Vector3.new(p29.X, v34, p29.Z);
        local v35 = (p29.Y - v34) / 2;

        if p28 then
            p28.C0 = p30 * CFrame.new(0, -v35, 0);
        end;
    end;

    local v36 = u26;
    local v37 = Size;
    local v38 = u16;
    local v39 = math.max(v37.Y * 1, 0.001);
    Water.Size = Vector3.new(v37.X, v39, v37.Z);
    local v40 = (v37.Y - v39) / 2;

    if v36 then
        v36.C0 = v38 * CFrame.new(0, -v40, 0);
    end;

    local u41 = nil;
    local v42 = u13:GetMarkerReachedSignal("Start");
    table.insert(v14, v42:Connect(function() -- Line: 239
        -- upvalues: u41 (ref), u10 (copy), u5 (copy), u26 (ref), Size (ref), u16 (ref), u17 (ref), Water (copy)
        if u41 then
            u41:Destroy();
        end;

        game.TweenService:Create(u10.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play();

        for _, child in u5.Nozzle.VFX:GetChildren() do
            child.Enabled = false;
            child:Clear();
        end;

        local v43 = u26;
        local v44 = Size;
        local v45 = u16;
        local v46 = math.max(v44.Y * 1, 0.001);
        Water.Size = Vector3.new(v44.X, v46, v44.Z);
        local v47 = (v44.Y - v46) / 2;

        if v43 then
            v43.C0 = v45 * CFrame.new(0, -v47, 0);
        end;
    end));
    local v48 = u13:GetMarkerReachedSignal("Fire");
    table.insert(v14, v48:Connect(function() -- Line: 254
        -- upvalues: u5 (copy), u41 (ref), u13 (copy), u26 (ref), Size (ref), u16 (ref), u17 (ref), Water (copy)
        for _, child in u5.Nozzle.VFX:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount") or 3);
            child.Enabled = true;
        end;

        u41 = game.SoundService.SFX.PowerHose:Clone();
        u41.Parent = u5.Nozzle;
        u41.TimePosition = 0;
        u41.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        u41.Playing = true;
        game.Debris:AddItem(u41, u41.TimeLength * u41.PlaybackSpeed);
        task.spawn(function() -- Line: 271
            -- upvalues: u13 (ref), u26 (ref), Size (ref), u16 (ref), u17 (ref), Water (ref)
            local v49 = 0;

            while u13 and v49 < 3 do
                v49 = v49 + game:GetService("RunService").Heartbeat:Wait();
                local v50 = u26;
                local v51 = Size;
                local v52 = u16;
                local v53 = 1 - math.clamp(v49 / 3, 0, 1);
                local v54 = v51.Y * math.clamp(v53, 0, 1);
                local v55 = math.max(v54, 0.001);
                Water.Size = Vector3.new(v51.X, v55, v51.Z);
                local v56 = (v51.Y - v55) / 2;

                if v50 then
                    v50.C0 = v52 * CFrame.new(0, -v56, 0);
                end;
            end;
        end);
    end));
    local v57 = u13:GetMarkerReachedSignal("OffScreenTurnOff");
    table.insert(v14, v57:Connect(function() -- Line: 287
        -- upvalues: u5 (copy)
        for _, child in u5.Nozzle.VFX:GetChildren() do
            child.Enabled = false;
        end;
    end));
    local v58 = u13:GetMarkerReachedSignal("FadeOut");
    table.insert(v14, v58:Connect(function() -- Line: 292
        -- upvalues: u10 (copy)
        game.TweenService:Create(u10.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 0
        }):Play();
    end));
    u11.Looped = true;
    u12.Looped = true;
    u13.Looped = true;
    u11:Play();
    u12:Play();
    u13:Play();
    Camera.FieldOfView = 20;
    Trove:Add(function() -- Line: 311
        -- upvalues: u10 (copy), u8 (ref), u11 (copy), u13 (copy), u12 (copy)
        if u10 then
            u10:Destroy();
        end;

        if u8 then
            u8:Disconnect();
        end;

        if u11 then
            u11:Stop();
            u11:Destroy();
        end;

        if u13 then
            u13:Stop();
            u13:Destroy();
        end;

        if u12 then
            u12:Stop();
            u12:Destroy();
        end;
    end);
end;

return v1;