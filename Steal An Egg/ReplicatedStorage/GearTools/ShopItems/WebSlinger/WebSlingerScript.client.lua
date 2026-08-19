-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);
local LocalPlayer = Players.LocalPlayer;
local Parent = script.Parent;
local WebSlingerRemote = Parent.WebSlingerRemote;
local u1 = LocalPlayer:GetMouse();

local function buildRaycastParams() -- Line: 74
    -- upvalues: LocalPlayer (copy)
    local v2 = RaycastParams.new();
    v2.FilterType = Enum.RaycastFilterType.Exclude;
    v2.IgnoreWater = true;
    local v3 = {};
    local Character = LocalPlayer.Character;

    if Character then
        table.insert(v3, Character);
    end;

    v2.FilterDescendantsInstances = v3;

    return v2;
end;

local function resolveHitTarget(p4) -- Line: 89
    -- upvalues: Players (copy), LocalPlayer (copy)
    if not p4 then
        return nil, nil;
    end;

    while p4 and not (p4:IsA("Model") or p4:FindFirstChildWhichIsA("Humanoid")) do
        p4 = p4.Parent;
    end;

    if not p4 then
        return nil, nil;
    end;

    local v5 = Players:GetPlayerFromCharacter(p4);

    if v5 and v5 ~= LocalPlayer then
        return v5, "PlayerType";
    end;

    return nil, nil;
end;

Parent.Activated:Connect(function() -- Line: 111, Name: onActivated
    -- upvalues: ToolGameplayGuard (copy), Parent (copy), LocalPlayer (copy), Workspace (copy), u1 (copy), resolveHitTarget (copy), WebSlingerRemote (copy)
    if not ToolGameplayGuard.CanActivateLocal(Parent) then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not (Character and Character.PrimaryPart) then
        return;
    end;

    if not Workspace.CurrentCamera then
        return;
    end;

    local Handle = Parent.Handle;
    local v6 = u1.Hit.Position - Handle.Position;

    if v6.Magnitude == 0 then
        return;
    end;

    local Unit = v6.Unit;
    local v7 = RaycastParams.new();
    v7.FilterType = Enum.RaycastFilterType.Exclude;
    v7.IgnoreWater = true;
    local v8 = {};
    local Character2 = LocalPlayer.Character;

    if Character2 then
        table.insert(v8, Character2);
    end;

    v7.FilterDescendantsInstances = v8;
    local v9 = Workspace:Raycast(Handle.Position, Unit * 12, v7);
    local v10;

    if v9 then
        v10 = v9.Instance or nil;
    else
        v10 = nil;
    end;

    local v11, v12 = resolveHitTarget(v10);
    WebSlingerRemote:FireServer({
        type = "fire",
        target = v11,
        targetType = v12,
        aimDirection = Unit,
        hitDistance = not v9 and 20 or math.min(v9.Distance, 20)
    });
end);
Parent.Unequipped:Connect(function() -- Line: 153, Name: onUnequipped
    -- upvalues: WebSlingerRemote (copy)
    WebSlingerRemote:FireServer({
        type = "disconnect"
    });
end);