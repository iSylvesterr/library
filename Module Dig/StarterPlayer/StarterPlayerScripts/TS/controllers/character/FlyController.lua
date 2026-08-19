-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ContextActionService = v1.ContextActionService;
local Players = v1.Players;
local RunService = v1.RunService;
local UserInputService = v1.UserInputService;
local Workspace = v1.Workspace;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 19, Name: __tostring
        return "FlyController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 24
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4) -- Line: 28
    -- upvalues: Janitor (copy)
    p4.enabled = false;
    p4.janitor = Janitor.new();
end;

function u2.onStart(u5) -- Line: 32
    -- upvalues: MiscEvents (copy), Players (copy)
    MiscEvents.SetFlyEnabled:connect(function(p6) -- Line: 33
        -- upvalues: u5 (copy)
        if p6 then
            u5:enable();

            return;
        end;

        u5:disable();
    end);
    Players.LocalPlayer.CharacterRemoving:Connect(function() -- Line: 40
        -- upvalues: u5 (copy)
        if u5.enabled then
            u5:teardownCharacter();
        end;
    end);
    Players.LocalPlayer.CharacterAdded:Connect(function() -- Line: 45
        -- upvalues: u5 (copy)
        if u5.enabled then
            task.spawn(function() -- Line: 47
                -- upvalues: u5 (ref)
                return u5:setupCharacter();
            end);
        end;
    end);
end;

function u2.enable(u7) -- Line: 53
    if u7.enabled then
        return nil;
    end;

    u7.enabled = true;
    task.spawn(function() -- Line: 58
        -- upvalues: u7 (copy)
        return u7:setupCharacter();
    end);
end;

function u2.disable(p8) -- Line: 62
    if not p8.enabled then
        return nil;
    end;

    p8.enabled = false;
    p8:teardownCharacter();
end;

function u2.setupCharacter(p9) -- Line: 69
    -- upvalues: Players (copy), Workspace (copy), UserInputService (copy), RunService (copy), ContextActionService (copy)
    local Character = Players.LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 10);
    local Humanoid = Character:WaitForChild("Humanoid", 10);

    if not (HumanoidRootPart and Humanoid) then
        return nil;
    end;

    if not p9.enabled then
        return nil;
    end;

    p9:teardownCharacter();
    Humanoid.PlatformStand = true;
    local BodyVelocity = Instance.new("BodyVelocity");
    BodyVelocity.MaxForce = Vector3.new(inf, inf, inf);
    BodyVelocity.Velocity = Vector3.new(0, 0, 0);
    BodyVelocity.P = 1250;
    BodyVelocity.Parent = HumanoidRootPart;
    local BodyGyro = Instance.new("BodyGyro");
    BodyGyro.MaxTorque = Vector3.new(inf, inf, inf);
    BodyGyro.P = 9000;
    BodyGyro.D = 500;
    BodyGyro.CFrame = HumanoidRootPart.CFrame;
    BodyGyro.Parent = HumanoidRootPart;
    local u10 = Vector3.new(0, 0, 0);

    local function u12() -- Line: 96
        -- upvalues: Workspace (ref), UserInputService (ref)
        local CurrentCamera = Workspace.CurrentCamera;

        if not CurrentCamera then
            return Vector3.new(0, 0, 0);
        end;

        local v11 = Vector3.new(0, 0, 0);

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            v11 = v11 + CurrentCamera.CFrame.LookVector;
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            v11 = v11 - CurrentCamera.CFrame.LookVector;
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            v11 = v11 + CurrentCamera.CFrame.RightVector;
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            v11 = v11 - CurrentCamera.CFrame.RightVector;
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            v11 = v11 + Vector3.new(0, 1, 0);
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            v11 = v11 - Vector3.new(0, 1, 0);
        end;

        if v11.Magnitude > 0 then
            v11 = v11.Unit * 80;
        end;

        return v11;
    end;

    local v14 = RunService.Heartbeat:Connect(function(p13) -- Line: 137
        -- upvalues: Workspace (ref), u12 (copy), u10 (ref), BodyVelocity (copy), HumanoidRootPart (copy), BodyGyro (copy)
        local CurrentCamera = Workspace.CurrentCamera;

        if not CurrentCamera then
            return nil;
        end;

        u10 = u10:Lerp(u12(), (math.clamp(p13 * 8, 0, 1)));
        BodyVelocity.Velocity = u10;
        BodyGyro.CFrame = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + CurrentCamera.CFrame.LookVector);
    end);
    ContextActionService:BindAction("AdminFly", function() -- Line: 151
        return Enum.ContextActionResult.Sink;
    end, false, Enum.PlayerActions.CharacterJump);
    p9.janitor:Add(v14, "Disconnect");
    p9.janitor:Add(function() -- Line: 155
        -- upvalues: BodyVelocity (copy), BodyGyro (copy), ContextActionService (ref), Humanoid (copy)
        BodyVelocity:Destroy();
        BodyGyro:Destroy();
        ContextActionService:UnbindAction("AdminFly");

        if Humanoid.Parent then
            Humanoid.PlatformStand = false;
        end;
    end);
end;

function u2.teardownCharacter(p15) -- Line: 164
    p15.janitor:Cleanup();
end;

Reflect.defineMetadata(u2, "identifier", "client/controllers/character/FlyController@FlyController");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    FlyController = u2
};