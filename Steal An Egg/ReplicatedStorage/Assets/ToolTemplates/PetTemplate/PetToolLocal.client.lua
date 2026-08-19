-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Parent = script.Parent;
local GetMouseToWorld = require(ReplicatedStorage.Library.Functions.GetMouseToWorld);
local Manhattan2D = require(ReplicatedStorage.Library.Functions.Manhattan2D);
local PetsService = require(ReplicatedStorage.Library.Modules.PetServices.PetsService);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
Parent.Activated:Connect(function() -- Line: 8
    -- upvalues: GetMouseToWorld (copy), Manhattan2D (copy), PetsService (copy), Parent (copy), Message (copy)
    local v1 = GetMouseToWorld(RaycastParams.new(), 100);

    if v1 then
        local v2 = CFrame.new(v1.Position.X, 0, v1.Position.Z);

        if Manhattan2D(v2.Position, workspace.PetArea) then
            PetsService:EquipPet(Parent:GetAttribute("PET_UUID"), v2);

            return;
        end;

        Message.Bottom({
            Message = "You cannot place your pet here!",
            Time = 0.5
        });
    end;
end);