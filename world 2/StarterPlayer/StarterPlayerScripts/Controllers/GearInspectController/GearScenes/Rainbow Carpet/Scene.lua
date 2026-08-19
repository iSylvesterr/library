-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://70712271927105";
local Animation2 = Instance.new("Animation");
Animation2.AnimationId = "rbxassetid://88608854229717";
local Animation3 = Instance.new("Animation");
Animation3.AnimationId = "rbxassetid://90165627812936";
local CarpetInspect = script.Parent.CarpetInspect;
CarpetInspect.Parent = nil;

function v1.Run(p2) -- Line: 20
    -- upvalues: CarpetInspect (copy), RunService (copy), Animation (copy), Animation2 (copy), Animation3 (copy)
    local _ = p2.Plot;
    local PlayerModel = p2.PlayerModel;
    local Camera = p2.Camera;
    local Trove = p2.Trove;

    if not (PlayerModel and p2.PlayerHumanoid) then
        return;
    end;

    local u3 = CarpetInspect:Clone();
    Trove:Add(u3);
    local v4 = PlayerModel:Clone();
    v4.PrimaryPart = v4.HumanoidRootPart;
    v4:PivotTo(u3.Player:GetPivot());
    v4.Parent = u3;
    u3.Player:Destroy();
    v4.Name = "Player";
    u3.Parent = workspace.Terrain;
    Camera.CameraType = Enum.CameraType.Scriptable;
    local u6 = RunService.RenderStepped:Connect(function(p5) -- Line: 67
        -- upvalues: u3 (copy), Camera (copy)
        if not u3.Parent then
            return;
        end;

        workspace.CurrentCamera.CFrame = u3.Camera.Camera.CFrame;
        Camera.FieldOfView = 35;
    end);
    Trove:Add(u6);
    u3.Carpet:FindFirstChildOfClass("AnimationController");
    local v7 = { Animation, Animation2, Animation3 };
    game:GetService("ContentProvider"):PreloadAsync(v7);
    local u8 = script.FadeIn:Clone();
    u8.Parent = game.Players.LocalPlayer.PlayerGui;
    u8.Frame.BackgroundTransparency = 0;
    Trove:Add(u8);

    repeat
        task.wait(0.25);
    until game:GetService("ContentProvider").RequestQueueSize == 0;

    if not u3.Parent then
        return;
    end;

    local u9 = v4.Humanoid.Animator:LoadAnimation(Animation);
    local u10 = u3.Carpet.AnimationController.Animator:LoadAnimation(Animation2);
    local u11 = u3.Camera.AnimationController.Animator:LoadAnimation(Animation3);
    local v12 = {};
    workspace.CurrentCamera.FieldOfView = 35;
    local v13 = u11:GetMarkerReachedSignal("Clearup");
    table.insert(v12, v13:Connect(function() -- Line: 102
        -- upvalues: u8 (copy)
        game.TweenService:Create(u8.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play();
    end));
    local v14 = u11:GetMarkerReachedSignal("TurnOffFaceCamera");
    table.insert(v12, v14:Connect(function() -- Line: 112
        -- upvalues: u3 (copy)
        for _, descendant in u3.Carpet.Carpet.Bone:GetDescendants() do
            if descendant:IsA("Trail") then
                descendant.FaceCamera = false;
            end;
        end;
    end));
    local v15 = u11:GetMarkerReachedSignal("Start");
    table.insert(v12, v15:Connect(function() -- Line: 124
        -- upvalues: u3 (copy)
        for _, descendant in u3.Carpet.Carpet.Bone:GetDescendants() do
            if descendant:IsA("Trail") then
                descendant.FaceCamera = true;
                descendant.Enabled = true;
            elseif descendant:IsA("ParticleEmitter") then
                descendant:Clear();
                descendant.Enabled = true;
            end;
        end;
    end));
    local v16 = u11:GetMarkerReachedSignal("FadeOut");
    table.insert(v12, v16:Connect(function() -- Line: 138
        -- upvalues: u8 (copy), u3 (copy)
        game.TweenService:Create(u8.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 0
        }):Play();

        for _, descendant in u3.Carpet.Carpet.Bone:GetDescendants() do
            if descendant:IsA("Trail") then
                descendant.Enabled = false;
            elseif descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end));
    u9.Looped = true;
    u10.Looped = true;
    u11.Looped = true;
    u9:Play();
    u10:Play();
    u11:Play();
    Camera.FieldOfView = 25;
    Trove:Add(function() -- Line: 162
        -- upvalues: u8 (copy), u6 (ref), u9 (copy), u11 (copy), u10 (copy)
        if u8 then
            u8:Destroy();
        end;

        if u6 then
            u6:Disconnect();
        end;

        if u9 then
            u9:Stop();
            u9:Destroy();
        end;

        if u11 then
            u11:Stop();
            u11:Destroy();
        end;

        if u10 then
            u10:Stop();
            u10:Destroy();
        end;
    end);
end;

return v1;