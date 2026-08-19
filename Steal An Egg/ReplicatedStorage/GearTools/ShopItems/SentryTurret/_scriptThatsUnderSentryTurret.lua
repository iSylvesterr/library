-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local GameplayToolGuard = require(ServerScriptService.Library.Tools.Internal.GameplayToolGuard);
local Player = require(ReplicatedStorage.Library.Player);
local Ragdoll = require(ReplicatedStorage.Library.Modules.Ragdoll);
local Parent = script.Parent;
local Parent2 = Parent.Parent;
local v1 = Parent2:IsA("Model");
assert(v1, "Sentry turret script parent must be inside the sentry Model");
local u2 = 0;
local u3 = false;

local function getOwnerPlayer() -- Line: 54
    -- upvalues: Parent2 (copy), Players (copy)
    local v4 = Parent2:GetAttribute("Owner");

    if typeof(v4) ~= "string" then
        return nil;
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        if v.Name == v4 then
            return v;
        end;
    end;

    return nil;
end;

local function getPlayerTarget(p5, p6, p7) -- Line: 68
    -- upvalues: GameplayToolGuard (copy), Player (copy)
    if p5 == p7 or not GameplayToolGuard.IsPlayerInGameplayArea(p5) then
        return nil;
    end;

    local Character = p5.Character;
    local v8 = Player.Optional.Humanoid(p5);
    local v9 = Player.Optional.HumanoidRootPart(p5);

    if Character == nil or (v8 == nil or (v9 == nil or v8.Health <= 0)) then
        return nil;
    end;

    local Magnitude = (v9.Position - p6).Magnitude;

    return Magnitude <= 50 and {
        Player = p5,
        Character = Character,
        Root = v9,
        Distance = Magnitude
    } or nil;
end;

local function lookAt(p10) -- Line: 110
    -- upvalues: Parent (copy), Parent2 (copy)
    local Position = Parent.Position;
    local Position2 = p10.Position;
    local v11 = Vector3.new(Position2.X, Position.Y, Position2.Z);
    Parent.CFrame = CFrame.new(Position, v11);
    Parent2.Main.CFrame = Parent.CFrame + Parent.CFrame.LookVector * 1.6;
    local Main = Parent2.Main;
    Main.CFrame = Main.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);
    Parent2.Shotpart.CFrame = Parent.CFrame + Parent.CFrame.LookVector * 1.6;
    local Shotpart = Parent2.Shotpart;
    Shotpart.CFrame = Shotpart.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);
    Parent2.Scanner.CFrame = Parent.CFrame + Parent.CFrame.LookVector * 1.6;
    local Scanner = Parent2.Scanner;
    Scanner.CFrame = Scanner.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0);
end;

local function findPlayerFromHit(p12) -- Line: 124
    -- upvalues: Players (copy)
    local Parent3 = p12.Parent;

    while Parent3 ~= nil do
        if Parent3:IsA("Model") then
            local v13 = Players:GetPlayerFromCharacter(Parent3);

            if v13 ~= nil then
                return v13, Parent3;
            end;
        end;

        Parent3 = Parent3.Parent;
    end;

    return nil, nil;
end;

local function applyPlayerHit(p14, p15) -- Line: 138
    -- upvalues: getOwnerPlayer (copy), GameplayToolGuard (copy), Player (copy), Parent (copy), Ragdoll (copy)
    local v16 = getOwnerPlayer();

    if v16 == nil or (p14 == v16 or not GameplayToolGuard.IsPlayerInGameplayArea(p14)) then
        return;
    end;

    local v17 = Player.Optional.HumanoidRootPart(p14);

    if v17 == nil then
        return;
    end;

    Ragdoll.TimedRagdoll(p15, 2, (Parent.CFrame.LookVector * 50 + Vector3.new(5, 10, 5)) * v17.AssemblyMass);
    GameplayToolGuard.DropHeldEggFromPlayerHit(p14);
end;

local function createBullet() -- Line: 156
    -- upvalues: Parent (copy), Workspace (copy)
    local Part = Instance.new("Part");
    Part.Name = "Bullet";
    Part.Size = Vector3.new(0.5, 0.5, 1);
    Part.Material = Enum.Material.Neon;
    Part.BrickColor = BrickColor.new("Really red");
    Part.CanCollide = false;
    Part.Shape = Enum.PartType.Ball;
    Part.CFrame = Parent.CFrame + Parent.CFrame.LookVector * 2;
    Part.Parent = Workspace;
    local BodyVelocity = Instance.new("BodyVelocity");
    BodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000);
    BodyVelocity.Velocity = Parent.CFrame.LookVector * 100;
    BodyVelocity.Parent = Part;

    return Part;
end;

local function shoot(p18) -- Line: 175
    -- upvalues: Parent (copy), lookAt (copy), createBullet (copy), findPlayerFromHit (copy), Player (copy), applyPlayerHit (copy), Debris (copy), u2 (ref)
    Parent.Bang:Play();
    lookAt(p18.Root);
    local u19 = createBullet();
    local u20 = {};
    u19.Touched:Connect(function(p21) -- Line: 181
        -- upvalues: u19 (copy), findPlayerFromHit (ref), Player (ref), u20 (copy), applyPlayerHit (ref)
        if u19.Parent == nil then
            return;
        end;

        local v22, v23 = findPlayerFromHit(p21);

        if v22 == nil or v23 == nil then
            return;
        end;

        local v24 = Player.Optional.Humanoid(v22);

        if v24 == nil or u20[v24] == true then
            return;
        end;

        u20[v24] = true;
        applyPlayerHit(v22, v23);
        u19:Destroy();
    end);
    Debris:AddItem(u19, 3);
    u2 = os.clock();
end;

local function tweenTextTransparency(p25, p26, p27) -- Line: 205
    -- upvalues: TweenService (copy)
    return TweenService:Create(p25, TweenInfo.new(p27, Enum.EasingStyle.Linear), {
        TextTransparency = p26
    });
end;

local function pulseText(p28) -- Line: 213
    -- upvalues: TweenService (copy)
    local v29 = TweenService:Create(p28, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
        TextTransparency = 0.3
    });
    local u30 = TweenService:Create(p28, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
        TextTransparency = 0
    });
    v29:Play();
    v29.Completed:Once(function() -- Line: 217
        -- upvalues: u30 (copy)
        u30:Play();
    end);
end;

task.spawn(function() -- Line: 222, Name: createCountdownBillboard
    -- upvalues: Parent (copy), pulseText (copy), u3 (ref), TweenService (copy), Parent2 (copy)
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "CountdownBillboard";
    BillboardGui.Size = UDim2.fromScale(6, 2);
    BillboardGui.StudsOffset = Vector3.new(0, 5, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.MaxDistance = 40;
    BillboardGui.Parent = Parent;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BackgroundColor3 = Color3.new(0, 0, 0);
    TextLabel.BorderSizePixel = 0;
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.SourceSansBold;
    TextLabel.Parent = BillboardGui;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 2.5;
    UIStroke.Parent = TextLabel;

    for i = 5, 1, -1 do
        TextLabel.Text = `Sentry ready in {i}s`;
        TextLabel.TextColor3 = Color3.new(1, 1, 1);
        task.wait(1);
    end;

    TextLabel.Text = "";
    pulseText(TextLabel);
    task.wait(0.1);
    BillboardGui.StudsOffset = Vector3.new(0, 4, 0);
    u3 = true;

    for i = 60, 1, -1 do
        TextLabel.Text = `{i}s`;
        TextLabel.TextColor3 = Color3.new(1, 0, 0);

        if i <= 10 then
            pulseText(TextLabel);
        end;

        task.wait(1);
    end;

    local v31 = TweenService:Create(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
        TextTransparency = 1,
        BackgroundTransparency = 1
    });
    v31:Play();
    v31.Completed:Once(function() -- Line: 273
        -- upvalues: BillboardGui (copy), Parent2 (ref)
        BillboardGui:Destroy();

        if Parent2.Parent ~= nil then
            Parent2:Destroy();
        end;
    end);
end);

local function getNearestTarget() -- Line: 93
    -- upvalues: getOwnerPlayer (copy), GameplayToolGuard (copy), Parent (copy), Players (copy), getPlayerTarget (copy)
    local v32 = getOwnerPlayer();

    if v32 == nil or not GameplayToolGuard.IsPlayerInGameplayArea(v32) then
        return nil;
    end;

    local Position = Parent.Position;
    local v33 = nil;

    for _, v in ipairs(Players:GetPlayers()) do
        local v34 = getPlayerTarget(v, Position, v32);

        if v34 ~= nil and (v33 == nil or v34.Distance < v33.Distance) then
            v33 = v34;
        end;
    end;

    return v33;
end;

while Parent2.Parent ~= nil do
    if u3 then
        local v35 = getNearestTarget();

        if v35 ~= nil then
            lookAt(v35.Root);

            if os.clock() - u2 >= 1 then
                shoot(v35);
            end;
        end;
    end;

    task.wait(0.1);
end;