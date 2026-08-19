-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Spring = require(ReplicatedStorage.Shared.Spring);
local u2 = Spring.new(1, 2.5, 1);
local u3 = Spring.new(0.85, 0.5, Vector2.zero);
local None = Enum.HumanoidStateType.None;
local u4 = 0;
local u5 = nil;
local u6 = nil;
local u7 = nil;

local function getMovementSpeed(p8) -- Line: 48
    return p8.PrimaryPart and Vector3.new(p8.PrimaryPart.AssemblyLinearVelocity.X, 0, p8.PrimaryPart.AssemblyLinearVelocity.Z).Magnitude or 0;
end;

local function isCharacterMoving(p9) -- Line: 54
    return (p9.PrimaryPart and Vector3.new(p9.PrimaryPart.AssemblyLinearVelocity.X, 0, p9.PrimaryPart.AssemblyLinearVelocity.Z).Magnitude or 0) > 0.1;
end;

local function isCharacterJumping(p10) -- Line: 60
    local v11 = p10:FindFirstChildOfClass("Humanoid");

    if v11 then
        local v12 = v11:GetState();

        if v12 == Enum.HumanoidStateType.Jumping or v12 == Enum.HumanoidStateType.Freefall then
            return true;
        end;
    end;

    return false;
end;

function u1.toggle(p13) -- Line: 77
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u2 (copy), u4 (ref)
    u5.Visible = p13;
    u5.Blur.Visible = true;
    local v14 = p13 and 3 or 1;
    local v15 = p13 and 4 or 2;

    if u6 and u6.Parent then
        u6.ZIndex = v14;
    end;

    if u7 and u7.Parent then
        u7.ZIndex = v15;
    end;

    if not p13 then
        u4 = 0;

        return;
    end;

    u2:setPosition(1);
    u2:setGoal(0);
    u4 = tick();
end;

function u1.updateMovementSharpness(p16, p17) -- Line: 101
    -- upvalues: InventoryController (copy), u2 (copy), u4 (ref)
    local v18 = p16.PrimaryPart and (Vector3.new(p16.PrimaryPart.AssemblyLinearVelocity.X, 0, p16.PrimaryPart.AssemblyLinearVelocity.Z).Magnitude or 0) or 0;
    local v19 = math.min(v18, 3) / 3;
    local v20 = InventoryController.getCurrentEquipped();
    local v21 = v20 and v20.Properties;

    if v21 then
        if v20.Properties.AimingOptions == "SniperScope" and (v20.Properties.MuzzleType == "Sniper" and (v20.Properties.Spread.Range.Min == 0 and v20.Properties.Spread.PerShot == 0)) then
            v21 = v20.Properties.Spread.MovementMultiplier == 2;
        else
            v21 = false;
        end;
    end;

    local v22 = false;

    if v21 then
        local v23 = p16:FindFirstChildOfClass("Humanoid");
        local v24;

        if v23 then
            local v25 = v23:GetState();
            v24 = v25 == Enum.HumanoidStateType.Jumping or v25 == Enum.HumanoidStateType.Freefall;
        else
            v24 = false;
        end;

        if v24 and p16.PrimaryPart then
            v22 = math.abs(p16.PrimaryPart.AssemblyLinearVelocity.Y) <= 3;
        end;
    end;

    if p17 then
        u2:setPosition(1);
        u2:setGoal(0);
        u4 = tick();

        return;
    end;

    local v26 = p16:FindFirstChildOfClass("Humanoid");
    local v27;

    if v26 then
        local v28 = v26:GetState();
        v27 = v28 == Enum.HumanoidStateType.Jumping or v28 == Enum.HumanoidStateType.Freefall;
    else
        v27 = false;
    end;

    if not v27 then
        if v19 > 0.1 then
            u2:setPosition(v19);

            return;
        end;

        if tick() - u4 > 1.2 then
            u2:reset(0);
        end;

        return;
    end;

    if not (v21 and v22) then
        u2:setPosition(1);

        return;
    end;

    u2:setPosition(0);
    u2:setGoal(0);
end;

function u1.updateScope(p29, p30) -- Line: 151
    -- upvalues: None (ref), u1 (copy), CharacterController (copy), u3 (copy), u5 (ref), u2 (copy)
    local v31 = p29:FindFirstChildOfClass("Humanoid");

    if not v31 then
        return;
    end;

    if v31 and v31.Health > 0 then
        local v32 = v31:GetState();
        local v33;

        if None == Enum.HumanoidStateType.Freefall or None == Enum.HumanoidStateType.Jumping then
            v33 = v32 == Enum.HumanoidStateType.Running and true or v32 == Enum.HumanoidStateType.Landed;
        else
            v33 = false;
        end;

        u1.updateMovementSharpness(p29, v33);
        None = v32;

        if (p29.PrimaryPart and (Vector3.new(p29.PrimaryPart.AssemblyLinearVelocity.X, 0, p29.PrimaryPart.AssemblyLinearVelocity.Z).Magnitude or 0) or 0) > 0.1 then
            local v34 = p29.PrimaryPart and Vector3.new(p29.PrimaryPart.AssemblyLinearVelocity.X, 0, p29.PrimaryPart.AssemblyLinearVelocity.Z).Magnitude or 0;
            local v35 = math.min(v34, 3);
            local v36 = CharacterController.GetCrouchState() and 0.5 or (CharacterController.GetWalkState() and 0.75 or 1);
            local new = Vector2.new;
            local v37 = tick() * 3.141592653589793 * 1.75 * v36;
            local v38 = math.sin(v37);
            local v39 = tick() * 3.141592653589793 * 2.75 * v36;
            u3:setPosition(new(v38, (math.sin(v39))) * v35 * 1.5);
            local v40 = u3:getPosition();
            u5.Position = UDim2.new(0.5, v40.X, 0.5, v40.Y);
        else
            u3:reset(Vector2.zero);
            u5.Position = UDim2.fromScale(0.5, 0.5);
        end;

        u5.Blur.ImageTransparency = 1 - u2:getPosition();
        u5.Sharp.ImageTransparency = u2:getPosition();
    end;
end;

function u1.Initialize(p41, p42) -- Line: 207
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), RunServiceController (copy), LocalPlayer (copy), InventoryController (copy), SpectateController (copy), u2 (copy), u3 (copy), u1 (copy)
    u5 = p42;
    local v43 = p42.Parent and p42.Parent.Parent;

    if v43 then
        u6 = v43:FindFirstChild("Bottom");
        u7 = v43:FindFirstChild("Top");

        if u6 then
            u6.ZIndex = 1;
        end;

        if u7 then
            u7.ZIndex = 2;
        end;
    end;

    RunServiceController.BindToRenderStep("UI.SniperScope.Update", function(p44) -- Line: 218
        -- upvalues: LocalPlayer (ref), InventoryController (ref), SpectateController (ref), u2 (ref), u3 (ref), u1 (ref), u5 (ref), u6 (ref), u7 (ref)
        local v45 = LocalPlayer:GetAttribute("IsSpectating") == true;
        local Character = LocalPlayer.Character;
        local v46;

        if Character then
            v46 = Character:FindFirstChild("Humanoid");
        else
            v46 = Character;
        end;

        if v45 then
            v46 = v45;
        elseif Character then
            if v46 then
                v46 = v46.Health > 0;
            end;
        else
            v46 = Character;
        end;

        if v46 then
            local v47 = InventoryController.getCurrentEquipped();
            local v48 = SpectateController.GetCurrentSpectateInstance();
            local v49 = false;

            if v45 and v48 then
                if v48.CurrentEquipped then
                    local Name = v48.CurrentEquipped.Name;

                    if (Name == "AWP" and true or Name == "SSG 08") and v48.PerspectiveState == "First-Person" then
                        v49 = (v48.Player:GetAttribute("ScopeIncrement") or 0) > 0;
                        Character = v48.Character;
                    end;
                end;
            else
                v49 = v47 and v47.IsAiming and v47.Properties.AimingOptions == "SniperScope";
            end;

            u2:update(p44);
            u3:update(p44);

            if v49 and Character then
                u1.updateScope(Character, p44);

                if not u5.Visible then
                    u1.toggle(true);
                end;
            elseif u5.Visible then
                u1.toggle(false);
            end;
        elseif u5.Visible then
            u1.toggle(false);
        end;

        if not u5.Visible then
            if u6 and u6.Parent then
                u6.ZIndex = 1;
            end;

            if u7 and u7.Parent then
                u7.ZIndex = 2;
            end;
        end;
    end);
end;

return u1;