-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://128615018041574";
local Animation2 = Instance.new("Animation");
Animation2.AnimationId = "rbxassetid://75187187172770";
local GrappleInspect = script.Parent.GrappleInspect;
GrappleInspect.Parent = nil;

function v1.Run(p2) -- Line: 18
    -- upvalues: GrappleInspect (copy), RunService (copy), Animation (copy), Animation2 (copy)
    local _ = p2.Plot;
    local PlayerModel = p2.PlayerModel;
    local Camera = p2.Camera;
    local Trove = p2.Trove;

    if not (PlayerModel and p2.PlayerHumanoid) then
        return;
    end;

    local u3 = GrappleInspect:Clone();
    Trove:Add(u3);
    local v4 = PlayerModel:Clone();
    v4.PrimaryPart = v4.HumanoidRootPart;
    v4:PivotTo(u3.Player:GetPivot());
    v4.Parent = u3;
    local u5 = u3.Player.Hook:Clone();
    u5.Parent = PlayerModel;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = v4["Right Arm"];
    WeldConstraint.Part1 = u5.Handle;
    WeldConstraint.Parent = u5.Handle;
    u3.Player:Destroy();
    v4.Name = "Player";
    u3.Parent = workspace;
    Camera.CameraType = Enum.CameraType.Scriptable;
    local u7 = RunService.RenderStepped:Connect(function(p6) -- Line: 62
        -- upvalues: u3 (copy), Camera (copy)
        if not u3.Parent then
            return;
        end;

        workspace.CurrentCamera.CFrame = u3.Camera.Camera.CFrame;
        Camera.FieldOfView = 35;
    end);
    Trove:Add(u7);
    local v8 = { Animation, Animation2 };
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
    local u11 = u3.Camera.AnimationController.Animator:LoadAnimation(Animation2);
    local v12 = {};
    local u13 = nil;
    local u14 = {
        Impact = script.Sounds.Impact,
        Reel = script.Sounds.Reel,
        Shoot = script.Sounds.Shoot,
        ShootLoop = script.Sounds.ShootLoop
    };
    workspace.CurrentCamera.FieldOfView = 35;
    local v15 = u11:GetMarkerReachedSignal("Clearup");
    table.insert(v12, v15:Connect(function() -- Line: 104
        -- upvalues: u13 (ref), u5 (copy), u9 (copy)
        if u13 then
            u13:Destroy();
        end;

        for _, child in u5.GrapplingHookTip:GetChildren() do
            if child:IsA("BasePart") then
                child.Transparency = 0;
            end;
        end;

        game.TweenService:Create(u9.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play();
    end));
    local u16 = nil;
    local v17 = u11:GetMarkerReachedSignal("Shoot");
    table.insert(v12, v17:Connect(function() -- Line: 122
        -- upvalues: u13 (ref), u5 (copy), u3 (copy), u14 (copy), u16 (ref)
        u13 = u5.GrapplingHookTip:Clone();

        for _, child in u13:GetChildren() do
            child.Anchored = true;
        end;

        u13:BreakJoints();
        u13.Parent = workspace.Temporary;
        game.Debris:AddItem(u13, 5);
        local u18 = u13:GetPivot();
        local WorldPosition = u3.HookPart.Attachment.WorldPosition;
        local u19 = CFrame.new(WorldPosition, WorldPosition + u18.LookVector);
        local v20 = u14.Shoot:Clone();
        game.Debris:AddItem(v20, 4);
        v20.Parent = workspace;
        v20:Play();
        u16 = u14.ShootLoop:Clone();
        u16.Parent = workspace;
        u16.Looped = true;
        u16:Play();
        game.Debris:AddItem(u16, 3);
        task.spawn(function() -- Line: 154
            -- upvalues: u18 (copy), u19 (copy), u13 (ref), u16 (ref), u14 (ref)
            local v21 = 0;

            while v21 < 0.5 do
                v21 = v21 + game:GetService("RunService").Heartbeat:Wait();
                u13:PivotTo((u18:Lerp(u19, v21 / 0.5)));
            end;

            if u16 then
                u16:Destroy();
            end;

            local v22 = u14.Impact:Clone();
            game.Debris:AddItem(v22, 4);
            v22.Parent = workspace;
            v22:Play();
        end);

        for _, child in u5.GrapplingHookTip:GetChildren() do
            if child:IsA("BasePart") then
                child.Transparency = 1;
            end;
        end;

        for _, child in u5.Handle.TipSpawn:GetChildren() do
            if child:IsA("Beam") then
                child.Attachment1 = u13.PrimaryPart.LineAttachment;
                child.Enabled = true;
            elseif child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount") or 1);
            end;
        end;
    end));
    local u23 = nil;
    local v24 = u11:GetMarkerReachedSignal("Land");
    table.insert(v12, v24:Connect(function() -- Line: 196
        -- upvalues: u23 (ref), u14 (copy)
        u23 = u14.Reel:Clone();
        game.Debris:AddItem(u23, 1.5);
        u23.Parent = workspace;
        u23:Play();
        u23.Looped = true;
    end));
    local v25 = u11:GetMarkerReachedSignal("FadeOut");
    table.insert(v12, v25:Connect(function() -- Line: 208
        -- upvalues: u9 (copy)
        game.TweenService:Create(u9.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 0
        }):Play();
    end));
    u10.Looped = true;
    u11.Looped = true;
    u10:Play();
    u11:Play();
    Trove:Add(function() -- Line: 223
        -- upvalues: u23 (ref), u16 (ref), u9 (copy), u7 (ref), u10 (copy), u11 (copy)
        if u23 then
            u23:Destroy();
        end;

        if u16 then
            u16:Destroy();
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

        if u11 then
            u11:Stop();
            u11:Destroy();
        end;
    end);
end;

return v1;