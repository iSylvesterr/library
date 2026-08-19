-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Parent = script.Parent;
local MedusaHeadRemote = script.Parent.MedusaHeadRemote;
local u1 = 0;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local Ring = ReplicatedStorage.Assets.Extra.Ring;
local Attack = script:FindFirstChild("Attack");
local Idle = script:FindFirstChild("Idle");
local Scream = Parent.Handle.Scream;
local u5 = nil;
local GetPlayerFromTool = require(ReplicatedStorage.Library.Functions.GetPlayerFromTool);
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);

local function getAnimator(p6) -- Line: 31
    local Character = p6.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    return Character and Character:FindFirstChildOfClass("Animator") or nil;
end;

local function playIdle(p7) -- Line: 37
    -- upvalues: u5 (ref), Idle (copy)
    if u5 then
        return;
    end;

    if not Idle then
        return;
    end;

    local Character = p7.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    local v8 = Character and Character:FindFirstChildOfClass("Animator") or nil;

    if not v8 then
        return;
    end;

    u5 = v8:LoadAnimation(Idle);
    u5.Looped = true;
    u5:Play();
end;

local function playHitAnimation(p9) -- Line: 56
    -- upvalues: Attack (copy)
    if not Attack then
        return;
    end;

    local Character = p9.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    local v10 = Character and Character:FindFirstChildOfClass("Animator") or nil;

    if not v10 then
        return;
    end;

    local v11 = v10:LoadAnimation(Attack);
    v11.Looped = false;
    v11.Priority = Enum.AnimationPriority.Action;
    v11:Play();
end;

local function stopIdle() -- Line: 72
    -- upvalues: u5 (ref)
    if not u5 then
        return;
    end;

    pcall(function() -- Line: 77
        -- upvalues: u5 (ref)
        u5:Stop();
        u5:Destroy();
    end);
    u5 = nil;
end;

local function updateRadiusIndicatorPosition() -- Line: 85
    -- upvalues: u2 (ref), u4 (ref)
    if not u2 then
        return;
    end;

    local v12 = u4 and u4.Character;

    if v12 then
        v12 = v12.PrimaryPart;
    end;

    if not v12 then
        return;
    end;

    u2.CFrame = CFrame.new(v12.Position + Vector3.new(0, -3.1, 0));
end;

local function disconnectRadiusUpdater() -- Line: 99
    -- upvalues: u3 (ref)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function removeRadiusIndicator() -- Line: 106
    -- upvalues: u2 (ref), u3 (ref), TweenService (copy)
    if not u2 then
        return;
    end;

    local u13 = u2;
    u2 = nil;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    local v14 = TweenService:Create(u13, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1,
        Size = Vector3.new(0, 0.5, 0)
    });
    v14.Completed:Connect(function() -- Line: 121
        -- upvalues: u13 (copy)
        u13:Destroy();
    end);
    v14:Play();
end;

local function createRadiusIndicator() -- Line: 128
    -- upvalues: u2 (ref), Ring (copy), u4 (ref), u3 (ref), RunService (copy), updateRadiusIndicatorPosition (copy), TweenService (copy)
    if u2 then
        return;
    end;

    assert(Ring, "[MedusaHead] Ring template missing");
    local v15 = Ring:Clone();
    v15.Name = "MedusaRadiusIndicator";
    v15.Size = Vector3.new(0, 0.5, 0);
    v15.Material = Enum.Material.Neon;
    v15.BrickColor = BrickColor.new("Really red");
    v15.CanCollide = false;
    v15.Anchored = true;
    v15.Transparency = 1;
    v15.Parent = workspace;
    u2 = v15;

    if u2 then
        local v16 = u4 and u4.Character;

        if v16 then
            v16 = v16.PrimaryPart;
        end;

        if v16 then
            u2.CFrame = CFrame.new(v16.Position + Vector3.new(0, -3.1, 0));
        end;
    end;

    u3 = RunService.Heartbeat:Connect(updateRadiusIndicatorPosition);
    TweenService:Create(v15, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0.3,
        Size = Vector3.new(40, 0.5, 40)
    }):Play();
end;

local function onEquipped() -- Line: 182
    -- upvalues: GetPlayerFromTool (copy), Parent (copy), u4 (ref), u5 (ref), Idle (copy), createRadiusIndicator (copy)
    local v17 = GetPlayerFromTool(Parent);

    if v17 then
        u4 = v17;

        if not u5 and Idle then
            local Character = v17.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            local v18 = Character and Character:FindFirstChildOfClass("Animator") or nil;

            if v18 then
                u5 = v18:LoadAnimation(Idle);
                u5.Looped = true;
                u5:Play();
            end;
        end;

        createRadiusIndicator();
    end;
end;

local function onUnequipped() -- Line: 191
    -- upvalues: u5 (ref), u4 (ref), removeRadiusIndicator (copy)
    if u5 then
        pcall(function() -- Line: 77
            -- upvalues: u5 (ref)
            u5:Stop();
            u5:Destroy();
        end);
        u5 = nil;
    end;

    u4 = nil;
    removeRadiusIndicator();
end;

Parent.Activated:Connect(function() -- Line: 158, Name: onActivated
    -- upvalues: ToolGameplayGuard (copy), Parent (copy), GetPlayerFromTool (copy), u1 (ref), Attack (copy), MedusaHeadRemote (copy), Scream (copy)
    if not ToolGameplayGuard.CanActivateLocal(Parent) then
        warn("cannot activate");

        return;
    end;

    local v19 = GetPlayerFromTool(Parent);

    if not v19 then
        return;
    end;

    local v20 = tick();

    if v20 - u1 < 30 then
        if not Attack then
            return;
        end;

        local Character = v19.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        local v21 = Character and Character:FindFirstChildOfClass("Animator") or nil;

        if not v21 then
            return;
        end;

        local v22 = v21:LoadAnimation(Attack);
        v22.Looped = false;
        v22.Priority = Enum.AnimationPriority.Action;
        v22:Play();

        return;
    end;

    u1 = v20;
    MedusaHeadRemote:FireServer();
    Scream:Play();

    if not Attack then
        return;
    end;

    local Character = v19.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    local v23 = Character and Character:FindFirstChildOfClass("Animator") or nil;

    if not v23 then
        return;
    end;

    local v24 = v23:LoadAnimation(Attack);
    v24.Looped = false;
    v24.Priority = Enum.AnimationPriority.Action;
    v24:Play();
end);
Parent.Equipped:Connect(onEquipped);
Parent.Unequipped:Connect(onUnequipped);
Parent.Destroying:Connect(function() -- Line: 201
    -- upvalues: u5 (ref), u4 (ref), removeRadiusIndicator (copy)
    if u5 then
        pcall(function() -- Line: 77
            -- upvalues: u5 (ref)
            u5:Stop();
            u5:Destroy();
        end);
        u5 = nil;
    end;

    u4 = nil;
    removeRadiusIndicator();
end);