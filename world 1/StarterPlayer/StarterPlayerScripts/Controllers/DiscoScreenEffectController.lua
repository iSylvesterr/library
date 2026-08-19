-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local EmitDuration = require(ReplicatedStorage.SharedModules.EmitDuration);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local u2 = { "Assets", "Minigames", "Disco" };
local u3 = CFrame.new(0, 0, -1) * CFrame.Angles(0, 3.141592653589793, 0);
local u4 = Enum.RenderPriority.Camera.Value + 1;
local u5 = nil;
local u6 = nil;

local function ResolveTemplate() -- Line: 47
    -- upvalues: ReplicatedStorage (copy), u2 (copy)
    local v7 = ReplicatedStorage;

    for _, v in u2 do
        if v7 then
            v7 = v7:FindFirstChild(v);
        end;
    end;

    if v7 then
        v7 = v7:FindFirstChild("DiscoScreenEffect");
    end;

    if v7 and v7:IsA("PVInstance") then
        return v7;
    end;

    local v8 = table.concat(u2, ".");
    warn((`[DiscoScreenEffectController] ReplicatedStorage.{v8}.DiscoScreenEffect not found (or not a part / model)`));

    return nil;
end;

local function Neutralize(p9) -- Line: 64
    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
        end;
    end;

    if p9:IsA("BasePart") then
        p9.Anchored = true;
        p9.CanCollide = false;
        p9.CanQuery = false;
        p9.CanTouch = false;
    end;
end;

local function LongestLifetime(p10) -- Line: 84
    local v11 = 0;

    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            v11 = math.max(v11, descendant.Lifetime.Max);
        end;
    end;

    return v11;
end;

local function Stop() -- Line: 94
    -- upvalues: u6 (ref), u5 (ref), RunService (copy)
    u6 = nil;
    local v12 = u5;

    if not v12 then
        return;
    end;

    u5 = nil;
    RunService:UnbindFromRenderStep("DiscoScreenEffect");
    v12:Destroy();
end;

local function Play() -- Line: 107
    -- upvalues: ResolveTemplate (copy), u6 (ref), u5 (ref), RunService (copy), Neutralize (copy), u3 (copy), u4 (copy), EmitDuration (copy), LongestLifetime (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local v13 = ResolveTemplate();

    if not v13 then
        return;
    end;

    u6 = nil;
    local v14 = u5;

    if v14 then
        u5 = nil;
        RunService:UnbindFromRenderStep("DiscoScreenEffect");
        v14:Destroy();
    end;

    local u15 = v13:Clone();
    u15.Name = "DiscoScreenEffect";
    Neutralize(u15);
    local u16 = {};
    u5 = u15;
    u6 = u16;
    u15:PivotTo(CurrentCamera.CFrame * u3);
    u15.Parent = CurrentCamera;
    RunService:BindToRenderStep("DiscoScreenEffect", u4, function() -- Line: 134
        -- upvalues: u15 (copy), u3 (ref)
        local CurrentCamera2 = workspace.CurrentCamera;

        if CurrentCamera2 then
            u15:PivotTo(CurrentCamera2.CFrame * u3);
        end;
    end);
    task.spawn(function() -- Line: 141
        -- upvalues: RunService (ref), u6 (ref), u16 (copy), EmitDuration (ref), u15 (copy), LongestLifetime (ref), u5 (ref)
        RunService.RenderStepped:Wait();

        if u6 ~= u16 then
            return;
        end;

        task.wait(EmitDuration(u15) + LongestLifetime(u15) + 0.5);

        if u6 ~= u16 then
            return;
        end;

        u6 = nil;
        local v17 = u5;

        if not v17 then
            return;
        end;

        u5 = nil;
        RunService:UnbindFromRenderStep("DiscoScreenEffect");
        v17:Destroy();
    end);
end;

function v1.Init(p18) -- Line: 158
end;

function v1.Start(p19) -- Line: 160
    -- upvalues: Networking (copy), Play (copy)
    Networking.Disco.Started.OnClientEvent:Connect(Play);
end;

return v1;