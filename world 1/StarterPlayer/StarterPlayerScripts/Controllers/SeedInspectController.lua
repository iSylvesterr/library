-- Decompiled with Potassium's decompiler.

local u1 = {};
local TweenService = game:GetService("TweenService");
local StarterGui = game:GetService("StarterGui");
local Players = game:GetService("Players");
local u2 = script.Player:Clone();
u2.Parent = game.Workspace;
local LocalPlayer = game.Players.LocalPlayer;

if LocalPlayer and LocalPlayer.UserId then
    task.spawn(function() -- Line: 18
        -- upvalues: Players (copy), LocalPlayer (copy), u2 (copy)
        local success, result = pcall(Players.GetHumanoidDescriptionFromUserIdAsync, Players, LocalPlayer.UserId);

        if success and result then
            u2.Humanoid:ApplyDescriptionResetAsync(result);
        end;
    end);
end;

task.spawn(function() -- Line: 29
    -- upvalues: u2 (copy)
    task.wait(0.5);
    u2.Parent = script.FakePlot;
end);
local Trove = require(game.ReplicatedStorage.ClientModules.Trove);
local DisplayPlantGrowthController = require(script.Parent:WaitForChild("DisplayPlantGrowthController"));
local GuiController = require(script.Parent:WaitForChild("GuiController"));
local Worlds = require(game.ReplicatedStorage.SharedModules.Worlds);

local function applyWorldGroundTint(p3) -- Line: 52
    -- upvalues: Worlds (copy)
    local Theme = Worlds.Theme;

    if not Theme then
        return;
    end;

    local TopLayer = p3:FindFirstChild("TopLayer");

    if TopLayer and TopLayer:IsA("BasePart") then
        TopLayer.Color = Theme.Ground;
    end;

    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") then
            local Parent = descendant.Parent;

            if Parent and string.find(Parent.Name, "BedSection", 1, true) then
                descendant.Color = Theme.GroundBed;
            end;
        end;
    end;
end;

local LocalPlayer2 = Players.LocalPlayer;
local CinematicBars = LocalPlayer2:WaitForChild("PlayerGui"):WaitForChild("CinematicBars");
local BottomBar = CinematicBars:WaitForChild("BottomBar");
local TopBar = CinematicBars:WaitForChild("TopBar");
local Prizes = CinematicBars:WaitForChild("PrizesUI"):WaitForChild("Prizes");
local FakePlot = script.FakePlot;
local u4 = Trove.new();
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = { "http://www.roblox.com/asset/?id=182435998", "http://www.roblox.com/asset/?id=182491037", "http://www.roblox.com/asset/?id=182491065", "http://www.roblox.com/asset/?id=182436842", "http://www.roblox.com/asset/?id=182491248", "http://www.roblox.com/asset/?id=182491277", "http://www.roblox.com/asset/?id=182436935", "http://www.roblox.com/asset/?id=182491368", "http://www.roblox.com/asset/?id=182491423" };

local function startSporadicDancer(u10, u11) -- Line: 117
    -- upvalues: u9 (copy)
    local u12 = u10:FindFirstChildOfClass("Animator") or u10:WaitForChild("Animator", 5);

    local function preload(p13) -- Line: 120
        -- upvalues: u12 (copy)
        local Animation = Instance.new("Animation");
        Animation.AnimationId = p13;
        local v14 = u12:LoadAnimation(Animation);
        Animation:Destroy();

        return v14;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = "http://www.roblox.com/asset/?id=180435571";
    local u15 = u12:LoadAnimation(Animation);
    Animation:Destroy();
    local Animation2 = Instance.new("Animation");
    Animation2.AnimationId = "http://www.roblox.com/asset/?id=125750702";
    local u16 = u12:LoadAnimation(Animation2);
    Animation2:Destroy();
    local Animation3 = Instance.new("Animation");
    Animation3.AnimationId = "http://www.roblox.com/asset/?id=180436148";
    local v17 = u12:LoadAnimation(Animation3);
    Animation3:Destroy();
    local u18 = v17;
    local u19 = {};

    for i, v in ipairs(u9) do
        local Animation4 = Instance.new("Animation");
        Animation4.AnimationId = v;
        local v20 = u12:LoadAnimation(Animation4);
        Animation4:Destroy();
        u19[i] = v20;
    end;

    local u21 = "dance";
    local u22 = nil;

    local function stopAll() -- Line: 141
        -- upvalues: u15 (copy), u16 (copy), u18 (copy), u19 (copy)
        u15:Stop(0);
        u16:Stop(0);
        u18:Stop(0);

        for _, v in ipairs(u19) do
            v:Stop(0);
        end;
    end;

    local function pickNewDanceIndex() -- Line: 150
        -- upvalues: u19 (copy), u22 (ref)
        local v23 = math.random(1, #u19);

        while v23 == u22 and #u19 > 1 do
            v23 = math.random(1, #u19);
        end;

        u22 = v23;

        return v23;
    end;

    local function startDance() -- Line: 159
        -- upvalues: stopAll (copy), u19 (copy), pickNewDanceIndex (copy)
        stopAll();
        u19[pickNewDanceIndex()]:Play(0.1);
    end;

    for _, v in ipairs(u19) do
        v.KeyframeReached:Connect(function(p24) -- Line: 165
            -- upvalues: v (copy)
            if p24 == "End" and v.IsPlaying then
                v:Play(0);
            end;
        end);
    end;

    u15.KeyframeReached:Connect(function(p25) -- Line: 172
        -- upvalues: u15 (copy)
        if p25 == "End" and u15.IsPlaying then
            u15:Play(0);
        end;
    end);
    u10.Jumping:Connect(function() -- Line: 178
        -- upvalues: u21 (ref), u18 (copy), u15 (copy), u16 (copy)
        if u21 ~= "jumping" then
            return;
        end;

        u18:Stop(0);
        u15:Stop(0);
        u16:Play(0);
    end);
    u10.FreeFalling:Connect(function() -- Line: 185
        -- upvalues: u21 (ref), u16 (copy), u18 (copy)
        if u21 ~= "jumping" then
            return;
        end;

        u16:Stop(0);
        u18:Play(0.1);
    end);
    u10.StateChanged:Connect(function(p26, p27) -- Line: 191
        -- upvalues: u21 (ref), u16 (copy), u18 (copy), u15 (copy)
        if u21 ~= "jumping" then
            return;
        end;

        if p27 == Enum.HumanoidStateType.Landed then
            u16:Stop(0);
            u18:Stop(0);
            u15:Play(0.1);
        end;
    end);

    local function doJumpBurst() -- Line: 200
        -- upvalues: u21 (ref), stopAll (copy), u15 (copy), u11 (copy), u10 (copy)
        u21 = "jumping";
        stopAll();
        u15:Play(0);

        for _ = 1, math.random(4, 10) do
            if not u11.Parent then
                return;
            end;

            u10.Jump = true;
            task.wait(math.random(8, 25) / 100);
        end;

        task.wait(0.3);
    end;

    local function doDancePhase() -- Line: 213
        -- upvalues: u21 (ref), stopAll (copy), u11 (copy), u19 (copy), pickNewDanceIndex (copy)
        u21 = "dance";
        stopAll();
        local v28 = math.random(6, 14);
        local v29 = 0;

        while v29 < v28 and u11.Parent do
            stopAll();
            u19[pickNewDanceIndex()]:Play(0.1);
            local v30 = math.random(20, 50) / 10;

            if v28 < v29 + v30 then
                v30 = v28 - v29;
            end;

            task.wait(v30);
            v29 = v29 + v30;
        end;
    end;

    u21 = "dance";
    stopAll();
    u19[pickNewDanceIndex()]:Play(0.1);
    task.wait(math.random(4, 8));

    while u11.Parent do
        doJumpBurst();

        if not u11.Parent then
            break;
        end;

        doDancePhase();

        if not u11.Parent then
            break;
        end;

        task.wait(math.random(3, 10) / 10);
    end;

    stopAll();
end;

local function HideBars() -- Line: 246
    -- upvalues: TweenService (copy), BottomBar (copy), TopBar (copy), Prizes (copy)
    TweenService:Create(BottomBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 0)
    }):Play();
    TweenService:Create(TopBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 1)
    }):Play();
    TweenService:Create(Prizes, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(1, 0.5)
    }):Play();
end;

local function ShowBars() -- Line: 253
    -- upvalues: TweenService (copy), BottomBar (copy), TopBar (copy), Prizes (copy)
    TweenService:Create(BottomBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 1)
    }):Play();
    TweenService:Create(TopBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 0)
    }):Play();
    TweenService:Create(Prizes, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 0.5)
    }):Play();
end;

function u1.Stop(p31) -- Line: 260
    -- upvalues: u7 (ref), u4 (copy), HideBars (copy), u8 (ref), u5 (ref), u6 (ref)
    if u7 then
        u7(true);
        u7 = nil;
    end;

    if u4 then
        u4:Clean();
    end;

    if p31 then
        HideBars();

        if u8 then
            local CurrentCamera = game.Workspace.CurrentCamera;
            CurrentCamera.CameraType = u8.CameraType;
            CurrentCamera.CameraSubject = u8.CameraSubject;
            CurrentCamera.FieldOfView = u8.FieldOfView;
            CurrentCamera.CFrame = u8.CFrame;
            u8 = nil;
        end;

        u5 = nil;
        u6 = nil;
    end;
end;

function u1.Start(p32) -- Line: 295
end;

function u1.Init(p33) -- Line: 299
end;

function u1.Inspect(p34, p35, p36) -- Line: 304
    -- upvalues: u6 (ref), u8 (ref), u1 (copy), FakePlot (copy), applyWorldGroundTint (copy), startSporadicDancer (copy), u4 (copy), GuiController (copy), u5 (ref), LocalPlayer2 (copy), StarterGui (copy), ShowBars (copy), TopBar (copy), DisplayPlantGrowthController (copy), u7 (ref)
    local SeedName = p34.SeedName;
    u6 = SeedName;

    if not u8 then
        local CurrentCamera = game.Workspace.CurrentCamera;
        u8 = {
            CameraType = CurrentCamera.CameraType,
            CameraSubject = CurrentCamera.CameraSubject,
            FieldOfView = CurrentCamera.FieldOfView,
            CFrame = CurrentCamera.CFrame
        };
    end;

    u1.Stop(false);
    local v37 = p36 or {};
    local v38 = FakePlot:Clone();
    applyWorldGroundTint(v38);
    v38.Parent = game.Workspace;
    local Player = v38:WaitForChild("Player");
    local Humanoid = Player:WaitForChild("Humanoid");
    task.spawn(function() -- Line: 340
        -- upvalues: Player (copy), startSporadicDancer (ref), Humanoid (copy)
        Player.HumanoidRootPart.Anchored = false;
        startSporadicDancer(Humanoid, Player);
    end);
    u4:Add(v38);
    GuiController:Close();

    if p35 then
        u5 = p35;
    end;

    local u39 = {};

    for _, child in LocalPlayer2.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "CinematicBars" then
            u39[child] = child.Enabled;
            child.Enabled = false;
        end;
    end;

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
    u4:Add(function() -- Line: 373
        -- upvalues: StarterGui (ref), LocalPlayer2 (ref), u39 (copy)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true);
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);

        if LocalPlayer2:GetAttribute("CustomChatActive") then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false);
        end;

        for i, v in u39 do
            if i then
                i.Enabled = v;
            end;
        end;
    end);
    ShowBars();
    TopBar.NameLabel.Text = `{string.upper(SeedName)} SEED`;
    TopBar.NameLabel.TextLabel.Text = `{string.upper(SeedName)} SEED`;
    u4:Add(TopBar.ExitButton.Activated:Connect(function() -- Line: 396
        -- upvalues: u5 (ref), u1 (ref)
        local v40 = u5;
        u1.Stop(true);

        if v40 then
            v40();
        end;
    end));
    math.randomseed(os.clock() * 1000);
    u7 = DisplayPlantGrowthController.GrowPlant(SeedName, {
        duration = v37.duration or 10,
        fruitDuration = v37.fruitDuration or 30,
        idleDuration = v37.idleDuration or 10,
        startAge = v37.startAge or 0,
        endAge = v37.endAge or 75,
        intense = v37.intense or true,
        easingStyle = v37.easingStyle or Enum.EasingStyle.Quad,
        easingDirection = v37.easingDirection or Enum.EasingDirection.InOut,
        camera = game.Workspace.CurrentCamera,
        seed = v37.seed or math.random(0, 2147483647),
        position = v38.PrimaryPart.Position + Vector3.new(0, v38.PrimaryPart.Size.Y / 2, 0),
        parent = v38,
        onStep = v37.onStep,
        onComplete = v37.onComplete,
        onCancelled = v37.onCancelled
    });
end;

return u1;