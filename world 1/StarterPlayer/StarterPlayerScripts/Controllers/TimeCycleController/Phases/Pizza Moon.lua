-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Players = game:GetService("Players");
game:GetService("SoundService");
require(ReplicatedStorage.SharedModules.Networking);
local _ = Players.LocalPlayer;
local CamShake = require(ReplicatedStorage.ClientModules.CamShake);
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
require(game.StarterPlayer.StarterPlayerScripts.Controllers.FieldOfViewController);
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
require(game.StarterPlayer.StarterPlayerScripts.Controllers.MusicController);
require(game.ReplicatedStorage.ClientModules.Reticule);
local PizzaMoon = ReplicatedStorage.Assets:WaitForChild("PizzaMoon");
local Skybox = require(game.ReplicatedStorage.ClientModules.Skybox);
local PizzaGuy = require(script.PizzaGuy);
local PizzaSkybox = game.ReplicatedStorage.Assets.Skybox.PizzaSkybox;
require(game.ReplicatedStorage.ClientModules.ButtonMash);
require(game.ReplicatedStorage.ClientModules.RagdollModule);
require(game.ReplicatedStorage.SharedModules.Networking);
local Bezier = require(game.ReplicatedStorage.ClientModules.Bezier);

local function lerp(p2, p3, p4) -- Line: 42
    return p2 + (p3 - p2) * p4;
end;

local u5 = {
    ClockTime = 24
};
local u6 = {
    Brightness = 0.5,
    EnvironmentDiffuseScale = 1,
    ClockTime = 9,
    Ambient = Color3.fromRGB(141, 117, 158),
    ColorShift_Bottom = Color3.fromRGB(30, 95, 199),
    ColorShift_Top = Color3.fromRGB(250, 208, 124),
    OutdoorAmbient = Color3.fromRGB(184, 43, 255)
};

local function ScaleModelTo(p7, p8, p9, p10, p11) -- Line: 63
    -- upvalues: TweenService (copy)
    local v12 = p7:GetScale();
    local v13 = p10 or Enum.EasingStyle.Linear;
    local v14 = p11 or Enum.EasingDirection.InOut;
    local v15 = 0;

    while v15 < p9 do
        v15 = v15 + task.wait(0);
        local v16 = TweenService:GetValue(math.clamp(v15 / p9, 0.01, 1), v13, v14);
        p7:ScaleTo(v12 + (p8 - v12) * v16);
    end;
end;

local u17 = nil;
local u18 = game.SoundService.SFX.ShakeLoop:Clone();

local function startUpdateLoop() -- Line: 93
    -- upvalues: Skybox (copy), PizzaSkybox (copy), LightingController (copy), u6 (copy), PizzaMoon (copy)
    game.TweenService:Create(workspace.Terrain.Clouds, TweenInfo.new(1), {
        Cover = 0
    }):Play();
    task.delay(1, function() -- Line: 98
        -- upvalues: Skybox (ref), PizzaSkybox (ref), LightingController (ref), u6 (ref), PizzaMoon (ref)
        Skybox.SetOrder(PizzaSkybox, 2);
        LightingController:TransitionTo(u6, 1);
        PizzaMoon.Parent = workspace;
    end);
    local u19 = {};
    local u20 = {};

    for _, child in PizzaMoon.FloatingVeg:GetChildren() do
        u19[child] = {
            direction = Random.new():NextUnitVector(),
            offset = Random.new():NextNumber(0, 400)
        };
        u20[child] = child:GetPivot();
        local new = CFrame.new;
        local v21 = tick() * 90 + u19[child].offset;
        local v22 = math.rad(v21);
        local v23 = new(0, math.sin(v22) * 10, 0) * u20[child];
        local Angles = CFrame.Angles;
        local v24 = math.round(u19[child].direction.X) * tick() * 360;
        local v25 = math.rad(v24);
        local v26 = math.round(u19[child].direction.Y) * tick() * 360;
        local v27 = math.rad(v26);
        local v28 = math.round(u19[child].direction.Z) * tick() * 360;
        child:PivotTo(v23 * Angles(v25, v27, (math.rad(v28))));
    end;

    local u29 = PizzaMoon.FloatingVeg:GetPivot();
    local u30 = CFrame.new(0, -300, 0) * u29;
    task.spawn(function() -- Line: 129
        -- upvalues: u30 (copy), u29 (copy), PizzaMoon (ref), u19 (copy), u20 (copy)
        local v31 = 0;

        while v31 < 2 do
            v31 = v31 + task.wait(0.025);
            local v32 = u30:Lerp(u29, (game.TweenService:GetValue(v31 / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)));
            PizzaMoon.FloatingVeg:PivotTo(v32);
        end;

        while isActive do
            for _, child in PizzaMoon.FloatingVeg:GetChildren() do
                local new = CFrame.new;
                local v33 = tick() * 90 + u19[child].offset;
                local v34 = math.rad(v33);
                local v35 = new(0, math.sin(v34) * 10, 0) * u20[child];
                local Angles = CFrame.Angles;
                local v36 = math.round(u19[child].direction.X) * tick() * 360;
                local v37 = math.rad(v36);
                local v38 = math.round(u19[child].direction.Y) * tick() * 360;
                local v39 = math.rad(v38);
                local v40 = math.round(u19[child].direction.Z) * tick() * 360;
                child:PivotTo(v35 * Angles(v37, v39, (math.rad(v40))));
            end;

            task.wait(0.025);
        end;
    end);
end;

local function stopUpdateLoop() -- Line: 160
    -- upvalues: TweenService (copy), CamShake (copy), u17 (ref), u18 (copy), PizzaMoon (copy), ReplicatedStorage (copy), Skybox (copy), PizzaSkybox (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Parent = game.Lighting;
    game.Debris:AddItem(ColorCorrectionEffect, 5);
    game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.2), {
        FieldOfView = 95
    }):Play();
    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.4), {
        Brightness = 1.5,
        Contrast = 0.2,
        Saturation = 0.5,
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play();
    CamShake:Shake(CamShake.Presets.Explosion);

    if u17 then
        u17:Destroy();
        u17 = nil;
    end;

    u18:Stop();
    u18.Volume = 0;
    CamShake:StopSustained(3);
    game.SoundService:PlayLocalSound(game.SoundService.SFX.Snap);
    task.delay(0.4, function() -- Line: 179
        -- upvalues: TweenService (ref), ColorCorrectionEffect (copy)
        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(2), {
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 255, 255)
        }):Play();
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(2), {
            FieldOfView = 70
        }):Play();
    end);
    game.TweenService:Create(workspace.Terrain.Clouds, TweenInfo.new(1), {
        Cover = 0.5
    }):Play();
    PizzaMoon.Parent = ReplicatedStorage.Assets;
    Skybox.SetOrder(PizzaSkybox, 0);
end;

local u41 = PizzaGuy.new(PizzaMoon.PizzaGuy);

function v1.Start(p42, p43, p44) -- Line: 191
    -- upvalues: LightingController (copy), u5 (copy), startUpdateLoop (copy), NotificationController (copy), u41 (copy), Bezier (copy), PizzaMoon (copy)
    if isActive then
        return;
    end;

    isActive = true;
    LightingController:TransitionTo(u5, 1);
    task.wait(1);
    task.spawn(function() -- Line: 200
        -- upvalues: startUpdateLoop (ref)
        startUpdateLoop();
    end);

    local function Color(p45, p46) -- Line: 203
        return "<font color=\"#" .. p46:ToHex() .. "\">" .. p45 .. "</font>";
    end;

    NotificationController:CreateNotification(("<font color=\"#" .. Color3.fromRGB(255, 60, 60):ToHex() .. "\">PIZZA PARTY!!</font>") .. " Leave your garden for the deliveries to begin!", nil, 7);
    local ActivePizzaTarget = workspace:WaitForChild("ActivePizzaTarget");
    u41:Start();
    local u47 = nil;

    local function getControlPoints(p48, p49, p50, p51) -- Line: 220
        -- upvalues: Bezier (ref)
        local v52 = p49 - p48;
        local v53 = Vector3.new(-v52.Z, 0, v52.X);

        if v53.Magnitude > 0 then
            v53 = v53.Unit;
        end;

        if p51 then
            v53 = -v53 or v53;
        end;

        return Bezier.new(p48, p48 + v52 * 0.25 + v53 * p50, p49 - v52 * 0.25 - v53 * p50, p49);
    end;

    local function newTarget(p54, p55, p56, p57) -- Line: 235
        -- upvalues: PizzaMoon (ref), u47 (ref), getControlPoints (copy)
        local Position = PizzaMoon.PizzaGuy:GetPivot().Position;

        if u47:IsDescendantOf(workspace.Gardens) then
            p55 = p55 + Vector3.new(0, 24, 0);
        end;

        local Magnitude = (Position - p55).Magnitude;
        local v58 = getControlPoints(Position, p55, Magnitude * p56, p57);
        local v59 = Magnitude / (p54 or 5);
        local v60 = 0;

        while v60 < v59 and u47 == u47 do
            local v61 = game.TweenService:GetValue(math.clamp(v60 / v59, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
            local v62 = v58:CalculatePositionAt(v61);
            local v63 = v58:CalculatePositionAt(v61 + 0.01);
            local v64 = CFrame.new(v62, v63);
            local v65 = math.clamp(v60 / 2, 0, 1);
            local v66 = PizzaMoon.PizzaGuy:GetPivot().LookVector:Lerp(v64.LookVector, v65);
            local new = CFrame.new;
            local v67 = tick() * 180;
            local v68 = math.rad(v67);
            local v69 = new(0, math.sin(v68) * 1, 0);
            PizzaMoon.PizzaGuy:PivotTo(CFrame.new(v62, v62 + v66) * v69);
            v60 = v60 + task.wait(0.025);
        end;
    end;

    local function loopAroundPlot(p70) -- Line: 280
        -- upvalues: ActivePizzaTarget (copy), PizzaMoon (ref), u47 (ref), newTarget (copy)
        local p = (p70.CFrame * CFrame.new(-p70.Size.X / 2, 0, 0)).p;
        local p2 = (p70.CFrame * CFrame.new(p70.Size.X / 2, 0, 0)).p;
        local v71 = true;

        if ActivePizzaTarget.Value then
            PizzaMoon.PizzaGuy.PizzaRig.PizzaSlot.Pizza.Enabled = true;
        end;

        while u47 == p70 do
            local _ = PizzaMoon.PizzaGuy:GetPivot().Position;
            local v72 = v71 and p2 and p2 or p;
            v71 = not v71;
            newTarget(20, v72, 0.4, v71);
        end;

        PizzaMoon.PizzaGuy.PizzaRig.PizzaSlot.Pizza.Enabled = false;
    end;

    task.spawn(function() -- Line: 304
        -- upvalues: ActivePizzaTarget (copy), PizzaMoon (ref), u47 (ref), newTarget (copy), loopAroundPlot (copy)
        while isActive do
            task.wait(1);
            local u73 = ActivePizzaTarget.Value or PizzaMoon:WaitForChild("Center");

            if u47 ~= u73 then
                u47 = u73;
                newTarget(40, u47:GetPivot().Position, 0.8);
                task.spawn(function() -- Line: 323
                    -- upvalues: loopAroundPlot (ref), u73 (ref)
                    loopAroundPlot(u73);
                end);
            end;
        end;
    end);
end;

function v1.End(p74) -- Line: 335
    -- upvalues: stopUpdateLoop (copy)
    if not isActive then
        return;
    end;

    isActive = false;
    stopUpdateLoop();
end;

return v1;