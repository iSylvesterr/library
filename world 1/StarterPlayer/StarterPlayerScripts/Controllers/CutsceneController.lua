-- Decompiled with Potassium's decompiler.

local u1 = {};
local ContentProvider = game:GetService("ContentProvider");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local MusicController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.MusicController);
local LocalPlayer = Players.LocalPlayer;
local u2 = false;
local u3 = {};
local u4 = {};
local u5 = {};

function lerp(p6, p7, p8)
    return p6 + (p7 - p6) * p8;
end;

local function CleanupScene() -- Line: 28
    -- upvalues: u4 (ref), u5 (ref), u2 (ref), MusicController (copy)
    for _, v in u4 do
        v:Destroy();
    end;

    u4 = {};

    for i, v in u5 do
        i.Enabled = v;
    end;

    u5 = {};

    if not u2 then
        MusicController:SetCutsceneMuted(false);
    end;
end;

function u1.Play(u9) -- Line: 49
    -- upvalues: ContentProvider (copy), CleanupScene (copy), u4 (ref), LocalPlayer (copy), u5 (ref), u3 (copy), u2 (ref), MusicController (copy), RunService (copy)
    local Animations = require(u9.Animations);
    local Markers = require(u9.Markers);
    local FoV = require(u9.FoV);
    local v10 = {};
    local v11 = {};

    for i, v in Animations do
        if u9.Rigs:FindFirstChild(i) then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v;
            v10[i] = Animation;
            table.insert(v11, Animation);
        end;
    end;

    ContentProvider:PreloadAsync(v11);

    repeat
        task.wait(0.25);
    until ContentProvider.RequestQueueSize == 0;

    CleanupScene();
    table.insert(u4, u9);

    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") or child:IsA("BillboardGui") then
            u5[child] = child.Enabled;
            child.Enabled = false;
        end;
    end;

    for i, v in v10 do
        local v12 = u9.Rigs:FindFirstChild(i);

        if v12 then
            local v13 = v12:FindFirstChildOfClass("AnimationController") or v12:FindFirstChildOfClass("Humanoid");

            if v13 then
                u3[i] = v13:LoadAnimation(v);

                if i == "Camera" then
                    for i2, v2 in Markers do
                        u3.Camera:GetMarkerReachedSignal(i2):Connect(function() -- Line: 106
                            -- upvalues: v2 (copy), u9 (copy), u3 (ref)
                            v2(u9, u3);
                        end);
                    end;
                end;
            end;
        end;
    end;

    u3.Camera.Stopped:Once(function() -- Line: 114, Name: EndCutscene
        -- upvalues: u2 (ref), Markers (copy), u9 (copy), u3 (ref), CleanupScene (ref)
        if u2 then
            Markers.EndState(u9);
        end;

        u2 = false;

        for _, v in u3 do
            v:Stop(0);
            v:Destroy();
        end;

        CleanupScene();
    end);

    for _, v in u3 do
        v.Looped = false;
        v.Priority = Enum.AnimationPriority.Action4;
        v:Play(0);
    end;

    u2 = true;
    MusicController:SetCutsceneMuted(true);
    local Value = u9.DefaultCamera.Value;
    local CurrentCamera = workspace.CurrentCamera;
    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.CameraSubject = Value;
    local u14 = 0;

    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.AutoRotate = false;
    end;

    game:GetService("StarterGui"):SetCore("ResetButtonCallback", false);
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false);

    local function ResetCamera() -- Line: 155
        -- upvalues: RunService (ref), LocalPlayer (ref), CurrentCamera (copy)
        RunService:UnbindFromRenderStep("Cutscene_Track");
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true);
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);

        if LocalPlayer:GetAttribute("CustomChatActive") then
            game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false);
        end;

        game:GetService("StarterGui"):SetCore("ResetButtonCallback", workspace:GetAttribute("InAdminParty") == true);

        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.AutoRotate = true;
        end;

        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.FieldOfView = 70;
        CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid;
    end;

    local u15 = FoV[1];
    CurrentCamera.FieldOfView = u15;
    RunService:BindToRenderStep("Cutscene_Track", Enum.RenderPriority.Camera.Value - 1, function(p16) -- Line: 178
        -- upvalues: u2 (ref), ResetCamera (copy), CurrentCamera (copy), Value (copy), u14 (ref), FoV (copy), u15 (ref)
        if not u2 then
            return ResetCamera();
        end;

        CurrentCamera.CFrame = Value.CFrame;
        CurrentCamera.Focus = CurrentCamera.CFrame * CFrame.new(0, 0, -5);
        u14 = u14 + p16 * 24;

        if FoV[math.ceil(u14)] and math.ceil(u14) < #FoV then
            local v17 = FoV[math.ceil(u14)];
            CurrentCamera.FieldOfView = u15;
            u15 = lerp(u15, v17, p16 * 11);
        end;
    end);
    task.spawn(function() -- Line: 197
        -- upvalues: u2 (ref), CleanupScene (ref)
        repeat
            task.wait(0.025);
        until u2 == false;

        CleanupScene();
    end);
end;

function u1.Preload(p18, u19) -- Line: 207
    -- upvalues: ContentProvider (copy)
    local u20 = {};

    for i, v in require(p18.Animations) do
        if p18.Rigs:FindFirstChild(i) then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v;
            table.insert(u20, Animation);
        end;
    end;

    for _, descendant in p18:GetDescendants() do
        if descendant:HasTag("Preload") then
            table.insert(u20, descendant);
        end;
    end;

    task.spawn(function() -- Line: 227
        -- upvalues: u20 (copy), u19 (copy), ContentProvider (ref)
        for i = 1, #u20 do
            ContentProvider:PreloadAsync({ u20[i] });
            task.wait(u19 / #u20 + Random.new():NextNumber());
        end;
    end);
end;

function u1.IsPlaying() -- Line: 236
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.Stop() -- Line: 240
    -- upvalues: u2 (ref)
    u2 = false;
end;

local function waitForCutscene(p21) -- Line: 250
    local v22 = game.ReplicatedStorage.Assets.Cutscenes:WaitForChild(p21, 30);

    if not v22 then
        return nil;
    end;

    local v23 = os.clock() + 30;
    local v24 = v22:GetAttribute("ExpectedDescendants");

    while os.clock() < v23 do
        v24 = v24 or v22:GetAttribute("ExpectedDescendants");

        if v24 and v24 <= #v22:GetDescendants() then
            return v22;
        end;

        task.wait(0.1);
    end;

    return nil;
end;

Networking.PlayCutscene.OnClientEvent:Connect(function(p25) -- Line: 268
    -- upvalues: u1 (copy), waitForCutscene (copy), LocalPlayer (copy)
    if u1.IsPlaying() then
        return;
    end;

    local v26 = waitForCutscene(p25);

    if not v26 then
        warn((`[CutsceneController] Cutscene {p25} never fully replicated`));

        return;
    end;

    LocalPlayer:RequestStreamAroundAsync(v26:GetPivot().p);
    local v27 = v26:Clone();
    v27.Parent = workspace;
    u1.Play(v27);
end);

return u1;