-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Sound = require(ReplicatedStorage.Classes.Sound);
local u1 = Players.LocalPlayer:GetMouse();
local u2 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
local u3 = {};
local u4 = nil;
local u5 = {};

local function setVisualAngle(p6, p7) -- Line: 46
    -- upvalues: u5 (copy)
    local v8 = u5[p6];

    if v8 then
        v8.Angle = p7;
        p6:PivotTo(v8.ClosedPivot * CFrame.Angles(0, p7, 0));
    end;
end;

local function stepVisuals(p9) -- Line: 56
    -- upvalues: u5 (copy), u4 (ref)
    local v10 = false;

    for i, v in pairs(u5) do
        if i.Parent then
            if v.Moving then
                v10 = true;
                local v11 = v.TargetAngle - v.Angle > 0 and 1 or -1;
                local v12 = math.abs(v.TargetAngle - v.StartAngle) / v.Duration;
                local v13 = v.Angle + v11 * v12 * p9;
                local v14;

                if v11 > 0 then
                    v14 = math.min(v13, v.TargetAngle);
                else
                    v14 = math.max(v13, v.TargetAngle);
                end;

                local v15 = u5[i];

                if v15 then
                    v15.Angle = v14;
                    i:PivotTo(v15.ClosedPivot * CFrame.Angles(0, v14, 0));
                end;

                if math.abs(v.TargetAngle - v14) < 0.001 then
                    v.Moving = false;
                end;
            end;
        else
            u5[i] = nil;
        end;
    end;

    if not v10 and u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function ensureRenderConnection() -- Line: 88
    -- upvalues: u4 (ref), RunServiceController (copy), stepVisuals (copy)
    if not u4 then
        u4 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", stepVisuals);
    end;
end;

local function useMouseDoor() -- Line: 96
    -- upvalues: u1 (copy), u3 (copy), Remotes (copy)
    local Target = u1.Target;

    if not Target then
        return;
    end;

    while Target do
        if Target:IsA("Model") and u3[Target] then
            Remotes.BreakableDoor.Use.Send(Target);

            return;
        end;

        Target = Target.Parent;
    end;
end;

u1.Button1Down:Connect(function() -- Line: 114
    -- upvalues: u2 (copy), useMouseDoor (copy)
    if u2 then
        return;
    end;

    useMouseDoor();
end);

local function applyDoorState(p16) -- Line: 124
    -- upvalues: u5 (copy), u4 (ref), RunServiceController (copy), stepVisuals (copy)
    local v17 = u5[p16];

    if not v17 then
        return;
    end;

    local v18 = p16:GetAttribute("DoorAngle") or v17.Angle;
    local v19 = u5[p16];

    if v19 then
        v19.Angle = v18;
        p16:PivotTo(v19.ClosedPivot * CFrame.Angles(0, v18, 0));
    end;

    v17.StartAngle = v18;
    v17.TargetAngle = p16:GetAttribute("DoorTargetAngle") or v18;
    local v20 = p16:GetAttribute("DoorMoveDuration") or 0;
    v17.Duration = math.max(v20, 0.001);
    v17.Elapsed = 0;
    v17.Moving = p16:GetAttribute("DoorMoving") == true;

    if v17.Moving and not u4 then
        u4 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", stepVisuals);
    end;
end;

local function releaseVisualStage(u21, p22) -- Line: 144
    -- upvalues: u5 (copy), Sound (copy), Debris (copy)
    local v23 = u5[u21];

    if not v23 then
        return;
    end;

    local v24 = u21:GetAttribute("BreakDirectionX") or 0;
    local v25 = u21:GetAttribute("BreakDirectionY") or 0;
    local v26 = u21:GetAttribute("BreakDirectionZ") or 0;
    local v27 = Vector3.new(v24, v25, v26);
    local v28 = v27.Magnitude <= 0 and Vector3.new(0, 0, 1) or v27.Unit;
    local v29 = workspace:FindFirstChild("Debris") or workspace;

    for _, v in ipairs(v23.StageParts[p22] or {}) do
        if v.Parent then
            local u30 = v:Clone();
            local u31 = nil;
            u30.Transparency = v23.Transparencies[v] or 0;
            u30.Anchored = false;
            u30.CanCollide = true;
            u30.CanQuery = false;
            u30.CanTouch = true;
            u30.CFrame = v.CFrame;
            u30:SetAttribute("BreakableDoorDebris", true);
            u31 = u30.Touched:Connect(function(p32) -- Line: 173
                -- upvalues: u21 (copy), u31 (ref), Sound (ref), u30 (copy)
                if not p32.CanCollide or (p32:GetAttribute("BreakableDoorDebris") == true or p32:IsDescendantOf(u21)) then
                    return;
                end;

                if u31 then
                    u31:Disconnect();
                    u31 = nil;
                end;

                Sound.new("BreakableDoor"):PlaySoundAtPosition({
                    Class = "BreakableDoor",
                    Name = "Part Hit Ground",
                    Position = u30.Position
                });
            end);
            u30.Parent = v29;
            Debris:AddItem(u30, 8);
            u30:ApplyImpulse((v28 + Vector3.new(0, 0.35, 0)) * u30.AssemblyMass * math.random(20, 35));
        end;
    end;
end;

local function applyStage(p33) -- Line: 203
    -- upvalues: u5 (copy), releaseVisualStage (copy)
    local v34 = u5[p33];

    if not v34 then
        return;
    end;

    local v35 = p33:GetAttribute("Stage") or 0;

    if v35 <= v34.Stage then
        v34.Stage = v35;

        return;
    end;

    for i = v34.Stage + 1, v35 do
        releaseVisualStage(p33, i);
    end;

    v34.Stage = v35;
end;

return Observers.observeTag("BreakableDoor", function(u36) -- Line: 224
    -- upvalues: Janitor (copy), u3 (copy), u5 (copy), applyDoorState (copy), applyStage (copy), u4 (ref)
    if not u36:IsA("Model") then
        return nil;
    end;

    local u37 = Janitor.new();
    u3[u36] = true;
    u5[u36] = {
        StartAngle = 0,
        TargetAngle = 0,
        Duration = 0,
        Elapsed = 0,
        Moving = false,
        ClosedPivot = u36:GetPivot(),
        Angle = u36:GetAttribute("DoorAngle") or 0,
        Stage = u36:GetAttribute("Stage") or 0,
        StageParts = {},
        Transparencies = {}
    };

    for _, child in ipairs(u36:GetChildren()) do
        if child:IsA("BasePart") then
            local v38 = tonumber(child.Name:match("^Stage(%d)Break$"));

            if v38 then
                u5[u36].StageParts[v38] = u5[u36].StageParts[v38] or {};
                table.insert(u5[u36].StageParts[v38], child);
                u5[u36].Transparencies[child] = child.Transparency;
            end;
        end;
    end;

    local Angle = u5[u36].Angle;
    local v39 = u5[u36];

    if v39 then
        v39.Angle = Angle;
        u36:PivotTo(v39.ClosedPivot * CFrame.Angles(0, Angle, 0));
    end;

    applyDoorState(u36);
    u37:Add(u36:GetAttributeChangedSignal("DoorMoveId"):Connect(function() -- Line: 256
        -- upvalues: applyDoorState (ref), u36 (copy)
        applyDoorState(u36);
    end));
    u37:Add(u36:GetAttributeChangedSignal("Stage"):Connect(function() -- Line: 259
        -- upvalues: applyStage (ref), u36 (copy)
        applyStage(u36);
    end));
    u37:Add(function() -- Line: 262
        -- upvalues: u3 (ref), u36 (copy), u5 (ref), u4 (ref)
        u3[u36] = nil;
        u5[u36] = nil;

        if next(u5) == nil and u4 then
            u4:Disconnect();
            u4 = nil;
        end;
    end);

    return function() -- Line: 271
        -- upvalues: u37 (copy)
        u37:Destroy();
    end;
end);