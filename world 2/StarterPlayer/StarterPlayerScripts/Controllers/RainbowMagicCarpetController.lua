-- Decompiled with Potassium's decompiler.

local u1 = {
    StartOrder = 6
};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local u2 = {};
local u3 = {};
local u4 = false;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;

local function IsAlive() -- Line: 30
    -- upvalues: u6 (ref), u7 (ref), u8 (ref)
    local v11 = u6 and u6.Parent and (u7 and u7.Parent);

    if v11 then
        if u7.Health > 0 then
            v11 = u8 and u8.Parent;
        else
            v11 = false;
        end;
    end;

    return v11;
end;

local function DisableJump(p12) -- Line: 36
    -- upvalues: u9 (ref), u7 (ref)
    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    if p12 and u7 then
        u9 = u7:GetPropertyChangedSignal("Jump"):Connect(function() -- Line: 42
            -- upvalues: u7 (ref)
            u7.Jump = false;
        end);
    end;
end;

local function ResetHumanoid() -- Line: 48
    -- upvalues: u7 (ref), u9 (ref)
    if u7 then
        u7.PlatformStand = false;
        u7.AutoRotate = true;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;
    end;
end;

local function CleanFlightBodies() -- Line: 57
    -- upvalues: u8 (ref)
    if u8 and u8.Parent then
        for _, v in { "FlightSpin", "FlightPower", "FlightHold" } do
            local v13 = u8:FindFirstChild(v);

            if v13 then
                v13:Destroy();
            end;
        end;
    end;
end;

local function StopAllAnimations() -- Line: 66
    -- upvalues: u2 (ref), u3 (copy)
    for _, v in u2 do
        if v.AnimationTrack then
            v.AnimationTrack:Stop();
        end;
    end;

    u2 = {};

    for i, v in u3 do
        pcall(function() -- Line: 76
            -- upvalues: v (copy)
            v:Destroy();
        end);
        u3[i] = nil;
    end;
end;

local function HandleFlightControl() -- Line: 81
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), u10 (ref), u4 (ref), u9 (ref), u5 (ref), CurrentCamera (copy)
    local v14 = u6 and u6.Parent and (u7 and u7.Parent);

    if v14 then
        if u7.Health > 0 then
            v14 = u8 and u8.Parent;
        else
            v14 = false;
        end;
    end;

    if not v14 then
        return;
    end;

    if u10 then
        u10:Disconnect();
    end;

    u10 = u8.ChildAdded:Connect(function(p15) -- Line: 88
        -- upvalues: u4 (ref), u8 (ref), u7 (ref), u9 (ref), u5 (ref), u6 (ref), CurrentCamera (ref)
        if u4 then
            return;
        end;

        if p15.Name ~= "FlightHold" then
            return;
        end;

        local FlightSpin = u8:FindFirstChild("FlightSpin");
        local FlightPower = u8:FindFirstChild("FlightPower");
        local FlightHold = u8:FindFirstChild("FlightHold");

        if not (FlightSpin and (FlightPower and FlightHold)) then
            return;
        end;

        u4 = true;
        u7.PlatformStand = true;
        u7.AutoRotate = false;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        if u7 then
            u9 = u7:GetPropertyChangedSignal("Jump"):Connect(function() -- Line: 42
                -- upvalues: u7 (ref)
                u7.Jump = false;
            end);
        end;

        u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

        while u4 and (u5 and (FlightSpin.Parent and (FlightPower.Parent and FlightHold.Parent))) do
            local v16 = u6 and u6.Parent and (u7 and u7.Parent);

            if v16 then
                if u7.Health > 0 then
                    v16 = u8 and u8.Parent;
                else
                    v16 = false;
                end;
            end;

            if not v16 then
                break;
            end;

            local v17 = CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(0, 0, -1));
            local v18 = CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(-1, 0, 0));
            local v19 = CFrame.new(Vector3.new(0, 0, 0), CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)):VectorToObjectSpace(u7.MoveDirection);
            local v20 = v17 * 90 * -v19.Z + v18 * 60 * -v19.X;
            FlightSpin.CFrame = CFrame.new(Vector3.new(0, 0, 0), v17);

            if v20.Magnitude < 1 then
                FlightHold.MaxForce = Vector3.new(1, 1, 1) * FlightHold.P;
                FlightPower.MaxForce = Vector3.new(0, 0, 0);
                FlightHold.Position = u8.Position;
            else
                FlightHold.MaxForce = Vector3.new(0, 0, 0);
                FlightPower.MaxForce = Vector3.new(1, 1, 1) * FlightPower.P * 100;
            end;

            FlightPower.Velocity = v20;
            task.wait(0.016666666666666666);
        end;

        u4 = false;
        local v21 = u6 and u6.Parent and (u7 and u7.Parent);

        if v21 then
            if u7.Health > 0 then
                v21 = u8 and u8.Parent;
            else
                v21 = false;
            end;
        end;

        if v21 then
            u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

            if u7 then
                u7.PlatformStand = false;
                u7.AutoRotate = true;

                if u9 then
                    u9:Disconnect();
                    u9 = nil;
                end;
            end;

            u7:ChangeState(Enum.HumanoidStateType.Freefall);
        end;
    end);
end;

function u1.Init(p22) -- Line: 141
end;

function u1.Equip(p23) -- Line: 144
    -- upvalues: u5 (ref), u6 (ref), LocalPlayer (copy), u7 (ref), u8 (ref), u9 (ref), HandleFlightControl (copy)
    if u5 then
        return;
    end;

    u6 = LocalPlayer.Character;

    if not u6 then
        return;
    end;

    u7 = u6:FindFirstChildOfClass("Humanoid");
    u8 = u6:FindFirstChild("HumanoidRootPart");
    u5 = true;
    local v24 = u6 and u6.Parent and (u7 and u7.Parent);

    if v24 then
        if u7.Health > 0 then
            v24 = u8 and u8.Parent;
        else
            v24 = false;
        end;
    end;

    if not v24 then
        u5 = false;

        return;
    end;

    if u7 then
        u7.PlatformStand = false;
        u7.AutoRotate = true;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;
    end;

    if u8 then
        u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    task.spawn(HandleFlightControl);
end;

function u1.Unequip(p25) -- Line: 170
    -- upvalues: u5 (ref), u4 (ref), StopAllAnimations (copy), u10 (ref), u7 (ref), u9 (ref), CleanFlightBodies (copy)
    if not u5 then
        return;
    end;

    u4 = false;
    u5 = false;
    StopAllAnimations();

    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    if u7 then
        u7.PlatformStand = false;
        u7.AutoRotate = true;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;
    end;

    CleanFlightBodies();
end;

Networking.Carpet.Equip.OnClientEvent:Connect(function() -- Line: 187
    -- upvalues: u1 (copy)
    u1:Equip();
end);
Networking.Carpet.Unequip.OnClientEvent:Connect(function() -- Line: 191
    -- upvalues: u1 (copy)
    u1:Unequip();
end);
Networking.Carpet.PlayAnimation.OnClientEvent:Connect(function(p26) -- Line: 195
    -- upvalues: u5 (ref), u7 (ref), u3 (copy), u2 (ref)
    if not (u5 and u7) then
        return;
    end;

    local v27 = game.ReplicatedStorage.Assets:FindFirstChild(p26, true);

    if not v27 then
        return;
    end;

    local v28 = u7:FindFirstChildOfClass("Animator") or u7:WaitForChild("Animator", 5);

    if not v28 then
        return;
    end;

    local v29 = u3[v27];

    if v29 then
        v29:Stop();
    else
        v29 = v28:LoadAnimation(v27);
        u3[v27] = v29;
    end;

    for i = #u2, 1, -1 do
        if u2[i].Animation == v27 then
            table.remove(u2, i);
        end;
    end;

    table.insert(u2, {
        Animation = v27,
        AnimationTrack = v29
    });
    v29:Play();
end);
Networking.Carpet.StopAnimation.OnClientEvent:Connect(function(p30) -- Line: 224
    -- upvalues: u2 (ref)
    for i = #u2, 1, -1 do
        if u2[i].Animation.Name == p30 then
            u2[i].AnimationTrack:Stop();
            table.remove(u2, i);
        end;
    end;
end);
Networking.Carpet.Activated.OnClientEvent:Connect(function(p31) -- Line: 233
    -- upvalues: u5 (ref), u4 (ref), CleanFlightBodies (copy), u7 (ref), u9 (ref), u6 (ref), u8 (ref)
    if not u5 then
        return;
    end;

    if not p31 then
        u4 = false;
        CleanFlightBodies();

        if u7 then
            u7.PlatformStand = false;
            u7.AutoRotate = true;

            if u9 then
                u9:Disconnect();
                u9 = nil;
            end;
        end;

        local v32 = u6 and u6.Parent and (u7 and u7.Parent);

        if v32 then
            if u7.Health > 0 then
                v32 = u8 and u8.Parent;
            else
                v32 = false;
            end;
        end;

        if v32 then
            u7:ChangeState(Enum.HumanoidStateType.Freefall);
        end;
    end;
end);

local function newCarpetModel(p33) -- Line: 253
    -- upvalues: RunService (copy)
    local TargetFloat = p33:WaitForChild("TargetFloat");
    local Carpet = p33:WaitForChild("Carpet");
    local Value = TargetFloat.Value;

    if not Value then
        repeat
            task.wait();
        until TargetFloat.Value or not p33:IsDescendantOf(workspace);

        Value = TargetFloat.Value;
    end;

    if not Value then
        return;
    end;

    local HumanoidRootPart = Value:WaitForChild("HumanoidRootPart");
    local RootJoint = HumanoidRootPart:WaitForChild("RootJoint");
    local u34 = {};

    for _, child in Carpet:GetChildren() do
        if child:IsA("Bone") then
            u34[child] = child.CFrame;
        end;
    end;

    local function UpdateBones(p35, p36) -- Line: 278
        -- upvalues: u34 (copy)
        for i, v in u34 do
            local X = v.Position.X;
            local v37 = p36 * math.sin(1.0471975511965976 * X + p35);
            local v38 = p36 * 1.0471975511965976 * math.cos(1.0471975511965976 * X + p35);
            local v39 = math.atan(v38);
            i.CFrame = v * CFrame.new(0, v37, 0) * CFrame.Angles(0, 0, v39);
        end;
    end;

    local X = Carpet:WaitForChild("Bone_04").CFrame.Position.X;
    local C0 = RootJoint.C0;
    local Name = Value.Name;
    local u40 = 0;
    local u41 = 0;
    RunService:BindToRenderStep("CarpetSway" .. Name, Enum.RenderPriority.Character.Value + 1, function(p42) -- Line: 296
        -- upvalues: HumanoidRootPart (copy), u41 (ref), u40 (ref), UpdateBones (copy), X (copy), RootJoint (copy), C0 (copy)
        u41 = u41 + ((HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 1 and 1 or 0) - u41) * math.min(p42 * 4, 1);
        local v43 = u41 * 0.3 + 0.2;
        u40 = u40 + (u41 * 3 + 1) * p42;
        UpdateBones(u40, v43);
        local v44 = v43 * math.sin(1.0471975511965976 * X + u40);
        local v45 = v43 * 1.0471975511965976 * math.cos(1.0471975511965976 * X + u40);
        local v46 = math.atan(v45);
        RootJoint.C0 = C0 * CFrame.new(0, 0.5, v44 + 0.1) * CFrame.Angles(-v46, 0, 0);
    end);

    repeat
        task.wait();
    until not (game.CollectionService:HasTag(p33, "RainbowCarpet") and p33:IsDescendantOf(workspace));

    RunService:UnbindFromRenderStep("CarpetSway" .. Name);
    RootJoint.C0 = C0;
end;

game.CollectionService:GetInstanceRemovedSignal("RainbowCarpet"):Connect(function(p47) -- Line: 320
end);
game.CollectionService:GetInstanceAddedSignal("RainbowCarpet"):Connect(newCarpetModel);

for _, v in game.CollectionService:GetTagged("RainbowCarpet") do
    task.spawn(newCarpetModel, v);
end;

return u1;