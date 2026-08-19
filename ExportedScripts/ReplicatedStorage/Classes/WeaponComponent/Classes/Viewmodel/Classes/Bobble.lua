-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Spring = require(ReplicatedStorage.Shared.Spring);
local CurrentCamera = workspace.CurrentCamera;
local u2 = Vector2.new(0.02, 0.015) / 50;

local function removeY(p3) -- Line: 37
    return p3 * Vector3.new(1, 0, 1);
end;

local function toVector3(p4) -- Line: 41
    return Vector3.new(p4.X, p4.Y, 0);
end;

local function toggleScopeVisibility(p5, p6) -- Line: 45
    for _, descendant in pairs(p5:GetDescendants()) do
        if descendant:IsA("MeshPart") then
            descendant.Transparency = p6 == true and 0 or 1;
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = p6;
        end;
    end;
end;

local function applySkinToScope(p7, p8) -- Line: 55
    if not (p7 and p8) then
        return;
    end;

    if p7.ClassName ~= "Model" or p8.ClassName ~= "Model" then
        return;
    end;

    local function clearSurfaceAppearances(p9) -- Line: 59
        for _, child in pairs(p9:GetChildren()) do
            if child.ClassName == "SurfaceAppearance" then
                child:Destroy();
            end;
        end;
    end;

    for _, child in pairs(p7:GetChildren()) do
        local v10 = p8:FindFirstChild(child.Name);

        if v10 then
            local v11 = v10:FindFirstChildWhichIsA("SurfaceAppearance");

            if v11 then
                local v12 = v11:Clone();
                v12.Name = v10.Name;
                clearSurfaceAppearances(child);
                v12.Parent = child;
            end;
        end;
    end;
end;

function u1.addScopeKick(p13) -- Line: 83
    if p13.IsDestroyed or not p13.ScopeSpring then
        return;
    end;

    p13.ScopeSpring:impulse(Vector2.new(5, 1));
end;

function u1.getMovementVelocity(p14) -- Line: 92
    -- upvalues: CurrentCamera (copy)
    local Character = p14.Character;

    if Character then
        local AssemblyLinearVelocity = Character.PrimaryPart.AssemblyLinearVelocity;

        if AssemblyLinearVelocity.Magnitude > 0.1 then
            local v15 = AssemblyLinearVelocity.Unit * math.min(AssemblyLinearVelocity.Magnitude, 50);

            return v15, CurrentCamera.CFrame:VectorToObjectSpace(v15);
        end;
    end;

    return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
end;

function u1.getNextCFrame(p16, p17) -- Line: 112
    -- upvalues: CurrentCamera (copy), u2 (copy)
    if p16.IsDestroyed or not (p16.MovementShiftSpring and (p16.CameraShiftSpring and (p16.BobbleSpring and p16.ScopeSpring))) then
        return CFrame.identity, Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
    end;

    local v18 = (p17 <= 0 or p17 ~= p17) and 0.016666666666666666 or p17;
    local v19, v20 = p16:getMovementVelocity();
    local v21 = v20 * Vector3.new(1, 0, 1);
    local Magnitude = v19.Magnitude;
    local Magnitude2 = (v19 * Vector3.new(1, 0, 1)).Magnitude;
    local CFrame2 = CurrentCamera.CFrame;
    local v22, v23, _ = CFrame2:ToObjectSpace(p16.LastCameraCFrame):ToOrientation();
    local v24 = Vector2.new(v22, v23) / v18;
    local v25 = p16.RenderTime + v18 * Magnitude * 0.1;
    local v26 = Vector3.new(0.0011111111, 0.0011111111, 0) * Vector3.new(v24.Y, -v24.X, 0);
    local X = v21.X;
    local v27 = math.abs(v21.X);
    local v28 = math.abs(v20.Z);
    local v29 = math.max(v27, v28);
    local v30 = Vector3.new(0.0004, 0.0007, 0.0011) * Vector3.new(X, -Magnitude2, v29);
    local v31 = Vector2.new(math.sin(v25 * 3.141592653589793 * 2), (math.sin(v25 * 3.141592653589793 * 4))) * (u2 * 0.5) * Magnitude2;

    if p16.IsInAir then
        v30 = v30 + Vector3.new(0, -0.02, 0);
        v31 = v31 * 0.3;
    end;

    p16.MovementShiftSpring:setGoal(v30);
    p16.CameraShiftSpring:setGoal(v26 ~= v26 and Vector3.new(0, 0, 0) or v26);
    p16.BobbleSpring:setGoal(v31);
    local v32;

    if p16.IsAiming then
        v32 = Vector2.zero;
    else
        v32 = Vector2.zero;
    end;

    p16.ScopeSpring:setGoal(v32);
    p16.MovementShiftSpring:update(v18);
    p16.CameraShiftSpring:update(v18);
    p16.BobbleSpring:update(v18);
    p16.ScopeSpring:update(v18);
    p16.LastCameraCFrame = CFrame2;
    p16.RenderTime = v25;
    local v33 = p16.MovementShiftSpring:getPosition();
    local v34 = p16.CameraShiftSpring:getPosition();
    local v35 = p16.BobbleSpring:getPosition();
    local v36 = Vector3.new(v35.X, v35.Y, 0);
    local v37 = p16.ScopeSpring:getPosition();
    local v38 = math.rad(-v33.X * 250);
    local v39;

    if p16.IsAiming then
        v39 = 0.08726646259971647;
        v38 = 0;
    else
        v39 = 0;
    end;

    local v40 = Vector3.new(v37.X, v37.Y, 0);

    return CFrame.new(v33 + v34 + v36) * CFrame.Angles(0, v39, v38), v36 + v33, v40;
end;

function u1.setIsAiming(p41, p42) -- Line: 208
    p41.IsAiming = p42;
end;

function u1.stateChanged(p43, p44, p45) -- Line: 214
    if p45 == Enum.HumanoidStateType.Freefall or p45 == Enum.HumanoidStateType.Jumping then
        p43.IsInAir = true;

        return;
    end;

    if p44 == Enum.HumanoidStateType.Freefall or p44 == Enum.HumanoidStateType.Jumping then
        p43.IsInAir = false;
    end;
end;

function u1.setModel(p46, p47) -- Line: 227
    -- upvalues: CurrentCamera (copy), toggleScopeVisibility (copy), applySkinToScope (copy)
    if not p47 then
        return;
    end;

    if p46.Scope then
        p46.Scope:Destroy();
        p46.Scope = nil;
    end;

    if p46.ScopeReticlePart then
        p46.ScopeReticlePart:Destroy();
        p46.ScopeReticlePart = nil;
    end;

    local Name = p47.Name;

    if Name == "AUG" or Name == "SG 553" then
        local Weapon = p47:FindFirstChild("Weapon");

        if Weapon and Weapon:FindFirstChild("ScopeSplit") then
            local ScopeSplit = Weapon.ScopeSplit;
            local Part = ScopeSplit:FindFirstChild("Part");

            if Part then
                p46.ScopeReticlePart = p46.Janitor:Add(Part:Clone());

                if p46.ScopeReticlePart then
                    p46.ScopeReticlePart.Parent = CurrentCamera;
                end;
            end;

            p46.Scope = p46.Janitor:Add(ScopeSplit:Clone());

            if p46.Scope then
                p46.Scope.Parent = CurrentCamera;
                toggleScopeVisibility(p46.Scope, false);
            end;

            local v48 = Name == "AUG" and p46.Scope and p46.Scope:FindFirstChild("Part");

            if v48 then
                local SurfaceGui = v48:FindFirstChild("SurfaceGui");
                local v49 = SurfaceGui and SurfaceGui:FindFirstChild("Frame");

                if v49 then
                    v49.Visible = false;
                end;
            end;

            if p46.Scope then
                applySkinToScope(p46.Scope, Weapon);
            end;

            ScopeSplit:Destroy();
        end;
    end;
end;

function u1.new(p50, p51) -- Line: 281
    -- upvalues: u1 (copy), Janitor (copy), Spring (copy), CurrentCamera (copy)
    local u52 = setmetatable({}, u1);
    u52.Janitor = Janitor.new();
    u52.IsDestroyed = false;
    u52.Character = p50.Character or p50.Player and p50.Player.Character;
    u52.IsAiming = false;
    u52.CameraShiftSpring = Spring.new(0.7, 18, Vector3.new(0, 0, 0));
    u52.MovementShiftSpring = Spring.new(1, 15, Vector3.new(0, 0, 0));
    u52.BobbleSpring = Spring.new(1, 20, Vector2.zero);
    u52.ScopeSpring = Spring.new(1, 20, Vector2.zero);
    u52.AimRotationOffset = CFrame.Angles(0, 0, 0);
    u52.AimPositionOffset = CFrame.new(0, 0, 0);
    u52.LastCameraCFrame = CurrentCamera.CFrame;
    u52.CharacterSpeed = 0;
    u52.RenderTime = 0;
    u52.IsInAir = false;
    local v53 = u52.Character and u52.Character:FindFirstChild("Humanoid");

    if v53 then
        local v54 = v53.StateChanged:Connect(function(...) -- Line: 323
            -- upvalues: u52 (copy)
            if not u52.IsDestroyed then
                u52:stateChanged(...);
            end;
        end);
        u52.Janitor:Add(v54);
    end;

    u52.Janitor:Add(p50.Player.CharacterAdded:Connect(function(p55) -- Line: 333
        -- upvalues: u52 (copy)
        u52.Character = p55;
        local v56 = p55:FindFirstChildOfClass("Humanoid");

        if not v56 then
            local v57 = tick();

            repeat
                task.wait(0.1);
                v56 = p55:FindFirstChildOfClass("Humanoid");
            until v56 or tick() - v57 > 5;
        end;

        if v56 then
            u52.Janitor:Add(v56.StateChanged:Connect(function(...) -- Line: 344
                -- upvalues: u52 (ref)
                if not u52.IsDestroyed then
                    u52:stateChanged(...);
                end;
            end));
        end;
    end));

    if p51 then
        u52:setModel(p51);
    end;

    return u52;
end;

function u1.destroy(p58) -- Line: 364
    if p58.IsDestroyed then
        return;
    end;

    p58.IsDestroyed = true;
    p58.Janitor:Destroy();
    p58.Janitor = nil;

    if p58.CameraShiftSpring then
        p58.CameraShiftSpring = nil;
    end;

    if p58.MovementShiftSpring then
        p58.MovementShiftSpring = nil;
    end;

    if p58.BobbleSpring then
        p58.BobbleSpring = nil;
    end;

    if p58.ScopeSpring then
        p58.ScopeSpring = nil;
    end;

    p58.Character = nil;
    p58.Scope = nil;
    p58.ScopeReticlePart = nil;
    p58.AimRotationOffset = nil;
    p58.AimPositionOffset = nil;
end;

return u1;