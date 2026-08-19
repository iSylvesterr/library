-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 10, Name: __tostring
        return "RagdollController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 15
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 19
end;

function u1.onStart(p4) -- Line: 21
    -- upvalues: MiscEvents (copy), Players (copy)
    MiscEvents.SetRagdollEnabled:connect(function(p5) -- Line: 22
        -- upvalues: Players (ref)
        local Character = Players.LocalPlayer.Character;

        if not Character then
            return nil;
        end;

        local Humanoid = Character:FindFirstChild("Humanoid");

        if not Humanoid then
            return nil;
        end;

        if p5 then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true);
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true);
            Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll);
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false);
            Humanoid.AutoRotate = false;
            Humanoid.PlatformStand = true;

            return;
        end;

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false);
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true);
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
        Humanoid.PlatformStand = false;
        Humanoid.AutoRotate = true;

        for _, descendant in Character:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
            end;
        end;

        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
        task.delay(0.25, function() -- Line: 66
            -- upvalues: Humanoid (copy)
            if not Humanoid.Parent then
                return nil;
            end;

            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true);
        end);
    end);
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/misc/RagdollController@RagdollController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    RagdollController = u1
};