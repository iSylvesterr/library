-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local u1 = false;

local function getInputBinding(p2) -- Line: 30
    if p2.KeyCode and p2.KeyCode ~= Enum.KeyCode.Unknown then
        return p2.KeyCode;
    end;

    if p2.UserInputType == Enum.UserInputType.MouseButton1 or (p2.UserInputType == Enum.UserInputType.MouseButton2 or p2.UserInputType == Enum.UserInputType.MouseButton3) then
        return p2.UserInputType;
    end;

    return nil;
end;

local function isGamepadInputType(p3) -- Line: 44
    return (p3 == Enum.UserInputType.Gamepad1 or (p3 == Enum.UserInputType.Gamepad2 or (p3 == Enum.UserInputType.Gamepad3 or (p3 == Enum.UserInputType.Gamepad4 or (p3 == Enum.UserInputType.Gamepad5 or (p3 == Enum.UserInputType.Gamepad6 or p3 == Enum.UserInputType.Gamepad7)))))) and true or p3 == Enum.UserInputType.Gamepad8;
end;

local function isGamepadTriggerInput(p4) -- Line: 55
    -- upvalues: isGamepadInputType (copy)
    local v5 = isGamepadInputType(p4.UserInputType) and p4.KeyCode == Enum.KeyCode.ButtonL2;

    return v5;
end;

local function isAnalogTriggerStillPressed(p6) -- Line: 59
    -- upvalues: isGamepadInputType (copy), UserInputService (copy)
    if p6.KeyCode ~= Enum.KeyCode.ButtonL2 then
        return false;
    end;

    local UserInputType = p6.UserInputType;

    if not isGamepadInputType(UserInputType) then
        return false;
    end;

    local v7 = UserInputService:GetGamepadState(UserInputType);

    for _, v in ipairs(v7) do
        if v.KeyCode == p6.KeyCode then
            return v.Position.Z > 0.3;
        end;
    end;

    return false;
end;

return table.freeze({
    Name = "Secondary Fire",
    Group = "Default",
    Category = "Weapon Keys",

    Callback = function(p8, p9) -- Line: 82, Name: onInput
        -- upvalues: LocalPlayer (copy), SpectateController (copy), u1 (ref), CaseSceneController (copy), InspectController (copy), InventoryController (copy), GameState (copy), isGamepadInputType (copy), getInputBinding (copy), isAnalogTriggerStillPressed (copy)
        if LocalPlayer:GetAttribute("IsSpectating") and p8 == Enum.UserInputState.Begin then
            SpectateController.Next();

            return;
        end;

        if SpectateController.IsLocalPlayerDead() then
            if p8 == Enum.UserInputState.End then
                u1 = false;
            end;

            return;
        end;

        if CaseSceneController.IsActive() or InspectController.IsActive() then
            if p8 == Enum.UserInputState.End then
                u1 = false;
            end;

            return;
        end;

        local v10 = InventoryController.getCurrentEquipped();

        if not (LocalPlayer.Character and v10) then
            if p8 == Enum.UserInputState.End then
                u1 = false;
            end;

            return;
        end;

        if v10 and (v10.Properties.Slot == "Grenade" and GameState.GetState() == "Buy Period") then
            return;
        end;

        if p8 == Enum.UserInputState.Begin then
            if v10.Properties.ShootingOptions == "Revolver" then
                local v11 = isGamepadInputType(p9.UserInputType) and p9.KeyCode == Enum.KeyCode.ButtonL2;

                if v11 and u1 then
                    return;
                end;

                if v11 then
                    u1 = true;
                end;

                v10:startRevolverSecondaryFire((getInputBinding(p9)));

                return;
            end;

            if v10.Properties.Class == "Grenade" then
                if GameState.GetState() ~= "Buy Period" then
                    v10:StartThrow();
                end;
            else
                if v10.Properties.HasScope then
                    v10:scope(true);

                    return;
                end;

                if v10.Properties.HasSuppressor then
                    if v10.IsSuppressed then
                        v10:removeSuppressor();

                        return;
                    end;

                    v10:addSuppressor();

                    return;
                end;

                if v10.Properties.ShootingOptions == "Burst" then
                    v10:updateFireMode();

                    return;
                end;

                if v10.Properties.Type == "Equipment" and GameState.GetState() ~= "Buy Period" then
                    v10:shoot(true);
                end;
            end;
        else
            if v10.Properties.ShootingOptions == "Revolver" and p8 == Enum.UserInputState.End then
                if isAnalogTriggerStillPressed(p9) then
                    return;
                end;

                u1 = false;
                v10:stopRevolverSecondaryFire();

                return;
            end;

            local _ = v10.Properties.HasScope;

            if v10.Properties.Slot == "Grenade" and p8 == Enum.UserInputState.End then
                u1 = false;

                if GameState.GetState() == "Buy Period" then
                    return;
                end;

                if v10.ThrowStarted and not v10.ThrowFinished then
                    v10:Throw("Near");
                end;
            elseif p8 == Enum.UserInputState.End then
                u1 = false;
            end;
        end;
    end
});