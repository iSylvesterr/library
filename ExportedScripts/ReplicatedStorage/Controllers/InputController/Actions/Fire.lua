-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local HintController = require(ReplicatedStorage.Controllers.HintController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local u1 = table.find(GetUserPlatform(), "Mobile") and #GetUserPlatform() <= 1;
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = false;
local u6 = nil;
local u7 = 0;
RunService:BindToRenderStep("FireAction.SameFrameFire", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 47
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), InventoryController (copy), HintController (copy)
    if not u5 then
        return;
    end;

    u5 = false;
    local u8 = u6;
    local u9 = u7;
    u6 = nil;
    u7 = 0;

    if not u8 then
        return;
    end;

    task.spawn(function() -- Line: 64
        -- upvalues: InventoryController (ref), u8 (copy), u9 (copy), HintController (ref)
        local v10 = InventoryController.getCurrentEquipped();

        if not v10 or v10.Identifier ~= u8.Identifier then
            u8.IsBurstShooting = false;

            return;
        end;

        for _ = 1, u9 do
            u8:shoot();

            if u8.Rounds and u8.Rounds <= 0 then
                HintController:createHint("Reload");
            end;

            task.wait(0.075);
        end;

        task.wait(0.15);
        u8.IsBurstShooting = false;
    end);
end);

local function getInputBinding(p11) -- Line: 89
    if p11.KeyCode and p11.KeyCode ~= Enum.KeyCode.Unknown then
        return p11.KeyCode;
    end;

    if p11.UserInputType == Enum.UserInputType.MouseButton1 or (p11.UserInputType == Enum.UserInputType.MouseButton2 or p11.UserInputType == Enum.UserInputType.MouseButton3) then
        return p11.UserInputType;
    end;

    return nil;
end;

local function isGamepadInputType(p12) -- Line: 103
    return (p12 == Enum.UserInputType.Gamepad1 or (p12 == Enum.UserInputType.Gamepad2 or (p12 == Enum.UserInputType.Gamepad3 or (p12 == Enum.UserInputType.Gamepad4 or (p12 == Enum.UserInputType.Gamepad5 or (p12 == Enum.UserInputType.Gamepad6 or p12 == Enum.UserInputType.Gamepad7)))))) and true or p12 == Enum.UserInputType.Gamepad8;
end;

local function isGamepadTriggerInput(p13) -- Line: 114
    -- upvalues: isGamepadInputType (copy)
    local v14 = isGamepadInputType(p13.UserInputType) and (p13.KeyCode == Enum.KeyCode.ButtonR2 and true or p13.KeyCode == Enum.KeyCode.ButtonL2);

    return v14;
end;

local function isAnalogTriggerStillPressed(p15) -- Line: 121
    -- upvalues: isGamepadInputType (copy), UserInputService (copy)
    local KeyCode = p15.KeyCode;

    if KeyCode ~= Enum.KeyCode.ButtonR2 and KeyCode ~= Enum.KeyCode.ButtonL2 then
        return false;
    end;

    local UserInputType = p15.UserInputType;

    if not isGamepadInputType(UserInputType) then
        return false;
    end;

    local v16 = UserInputService:GetGamepadState(UserInputType);

    for _, v in ipairs(v16) do
        if v.KeyCode == KeyCode then
            return v.Position.Z > 0.3;
        end;
    end;

    return false;
end;

return table.freeze({
    Name = "Fire",
    Group = "Default",
    Category = "Weapon Keys",

    Callback = function(p17, p18) -- Line: 145, Name: onInput
        -- upvalues: u1 (copy), LocalPlayer (copy), SpectateController (copy), u4 (ref), CaseSceneController (copy), InspectController (copy), InventoryController (copy), GameState (copy), Router (copy), isGamepadInputType (copy), u2 (ref), u3 (ref), getInputBinding (copy), u5 (ref), u6 (ref), u7 (ref), RunService (copy), HintController (copy), isAnalogTriggerStillPressed (copy)
        if u1 and p18.UserInputType == Enum.UserInputType.MouseButton1 then
            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if LocalPlayer:GetAttribute("IsSpectating") and p17 == Enum.UserInputState.Begin then
            SpectateController.Previous();

            return;
        end;

        if SpectateController.IsLocalPlayerDead() then
            if p17 == Enum.UserInputState.End then
                u4 = false;
            end;

            return;
        end;

        if CaseSceneController.IsActive() or InspectController.IsActive() then
            if p17 == Enum.UserInputState.End then
                u4 = false;
            end;

            return;
        end;

        local u19 = InventoryController.getCurrentEquipped();

        if not (u19 and LocalPlayer.Character) then
            if p17 == Enum.UserInputState.End then
                u4 = false;
            end;

            return;
        end;

        if GameState.GetState() == "Buy Period" then
            if p17 == Enum.UserInputState.End then
                u4 = false;
            end;

            return;
        end;

        Router.broadcastRouter("Cancel Defuse Bomb");

        if p17 == Enum.UserInputState.Begin then
            local v20 = isGamepadInputType(p18.UserInputType) and (p18.KeyCode == Enum.KeyCode.ButtonR2 and true or p18.KeyCode == Enum.KeyCode.ButtonL2);

            if v20 and (u4 and (u19.Properties.Class == "Weapon" and not u19.Properties.Automatic)) then
                return;
            end;

            if v20 then
                u4 = true;
            end;

            local Class = u19.Properties.Class;
            local Slot = u19.Properties.Slot;

            if Class == "C4" then
                u19:shoot();

                return;
            end;

            if Slot == "Grenade" then
                u19:StartThrow();

                return;
            end;

            if Class == "Weapon" then
                if u19.Properties.ShootingOptions == "Revolver" then
                    if u2 then
                        task.cancel(u2);
                        u2 = nil;
                        u3 = nil;
                    end;

                    u19:startRevolverCharge((getInputBinding(p18)));

                    return;
                end;

                u19.IsFireHeld = true;
                u19.FireInputBinding = getInputBinding(p18);
            end;

            local v21 = not u19.IsBurstShooting and (not u19.IsShooting and u19.Properties.FireRate) and tick() - u19.AlternativeSwitchTick > u19.Properties.FireRate;

            if v21 then
                if u2 then
                    task.cancel(u2);
                    u2 = nil;
                    u3 = nil;
                end;

                local v22 = u19.AlternativeShootingOption == "Burst" and 3 or 1;
                u19.IsBurstShooting = v22 == 3;

                if u5 then
                    u19.IsBurstShooting = false;

                    return;
                end;

                u5 = true;
                u6 = u19;
                u7 = v22;

                return;
            end;

            if not u19.Properties.Automatic and (u19.AlternativeShootingOption == "Default" and (u19.IsShooting and u3 ~= u19.Identifier)) then
                if u2 then
                    task.cancel(u2);
                end;

                local NextShotDue = u19.NextShotDue;
                local v23;

                if NextShotDue then
                    local v24 = NextShotDue - os.clock();
                    v23 = math.max(0, v24);
                else
                    v23 = 0;
                end;

                if v23 <= 0.15 then
                    u3 = u19.Identifier;
                    u2 = task.delay(v23, function() -- Line: 288
                        -- upvalues: RunService (ref), u2 (ref), u3 (ref), InventoryController (ref), u19 (copy), HintController (ref)
                        RunService.Heartbeat:Wait();
                        RunService.Heartbeat:Wait();
                        u2 = nil;
                        u3 = nil;
                        local v25 = InventoryController.getCurrentEquipped();

                        if not v25 then
                            return;
                        end;

                        if v25.Identifier ~= u19.Identifier then
                            return;
                        end;

                        if v25.Properties.Automatic then
                            return;
                        end;

                        if v25.AlternativeShootingOption == "Burst" then
                            return;
                        end;

                        if v25.Rounds <= 0 then
                            HintController:createHint("Reload");

                            return;
                        end;

                        v25:shoot();
                    end);
                end;
            end;
        else
            if p17 == Enum.UserInputState.End and u19.Properties.Class == "Weapon" then
                if u19.Properties.ShootingOptions ~= "Revolver" then
                    u4 = false;
                    u19.IsFireHeld = false;
                    u19.FireInputBinding = nil;

                    return;
                end;

                if isAnalogTriggerStillPressed(p18) then
                    return;
                end;

                u4 = false;
                local v26 = u19.Properties.FireModes and u19.Properties.FireModes.Primary;

                if not v26 or v26.CancelOnRelease ~= false then
                    u19:cancelRevolverCharge(false);

                    return;
                end;

                u19.IsFireHeld = false;
                u19.FireInputBinding = nil;

                return;
            end;

            if p17 == Enum.UserInputState.End and u19.Properties.Class == "C4" then
                if isAnalogTriggerStillPressed(p18) then
                    return;
                end;

                u4 = false;
                u19:cancel();

                return;
            end;

            if u19.Properties.Slot == "Grenade" and p17 == Enum.UserInputState.End then
                u4 = false;

                if u19.ThrowStarted and not u19.ThrowFinished then
                    u19:Throw("Far");
                end;

                return;
            end;

            if p17 == Enum.UserInputState.End then
                u4 = false;
            end;
        end;
    end
});