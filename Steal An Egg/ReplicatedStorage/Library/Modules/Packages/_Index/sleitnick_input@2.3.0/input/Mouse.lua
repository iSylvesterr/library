-- Decompiled with Potassium's decompiler.

local Signal = require(script.Parent.Parent.Signal);
local Trove = require(script.Parent.Parent.Trove);
local UserInputService = game:GetService("UserInputService");
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 81
    -- upvalues: u1 (copy), Trove (copy), Signal (copy), UserInputService (copy)
    local u2 = setmetatable({}, u1);
    u2._trove = Trove.new();
    u2.LeftDown = u2._trove:Construct(Signal);
    u2.LeftUp = u2._trove:Construct(Signal);
    u2.RightDown = u2._trove:Construct(Signal);
    u2.RightUp = u2._trove:Construct(Signal);
    u2.MiddleDown = u2._trove:Construct(Signal);
    u2.MiddleUp = u2._trove:Construct(Signal);
    u2.Scrolled = u2._trove:Construct(Signal);
    u2.Moved = u2._trove:Construct(Signal);
    u2._trove:Connect(UserInputService.InputBegan, function(p3, p4) -- Line: 95
        -- upvalues: u2 (copy)
        if p4 then
            return;
        end;

        if p3.UserInputType == Enum.UserInputType.MouseButton1 then
            u2.LeftDown:Fire();

            return;
        end;

        if p3.UserInputType == Enum.UserInputType.MouseButton2 then
            u2.RightDown:Fire();

            return;
        end;

        if p3.UserInputType == Enum.UserInputType.MouseButton3 then
            u2.MiddleDown:Fire();
        end;
    end);
    u2._trove:Connect(UserInputService.InputEnded, function(p5, p6) -- Line: 108
        -- upvalues: u2 (copy)
        if p6 then
            return;
        end;

        if p5.UserInputType == Enum.UserInputType.MouseButton1 then
            u2.LeftUp:Fire();

            return;
        end;

        if p5.UserInputType == Enum.UserInputType.MouseButton2 then
            u2.RightUp:Fire();

            return;
        end;

        if p5.UserInputType == Enum.UserInputType.MouseButton3 then
            u2.MiddleUp:Fire();
        end;
    end);
    u2._trove:Connect(UserInputService.InputChanged, function(p7, p8) -- Line: 121
        -- upvalues: u2 (copy)
        if p8 then
            return;
        end;

        if p7.UserInputType ~= Enum.UserInputType.MouseMovement then
            if p7.UserInputType == Enum.UserInputType.MouseWheel then
                u2.Scrolled:Fire(p7.Position.Z);
            end;

            return;
        end;

        local Position = p7.Position;
        u2.Moved:Fire(Vector2.new(Position.X, Position.Y));
    end);

    return u2;
end;

function u1.IsLeftDown(p9) -- Line: 139
    -- upvalues: UserInputService (copy)
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1);
end;

function u1.IsRightDown(p10) -- Line: 146
    -- upvalues: UserInputService (copy)
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2);
end;

function u1.IsMiddleDown(p11) -- Line: 153
    -- upvalues: UserInputService (copy)
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3);
end;

function u1.GetPosition(p12) -- Line: 160
    -- upvalues: UserInputService (copy)
    return UserInputService:GetMouseLocation();
end;

function u1.GetDelta(p13) -- Line: 174
    -- upvalues: UserInputService (copy)
    return UserInputService:GetMouseDelta();
end;

function u1.GetRay(p14, p15) -- Line: 182
    -- upvalues: UserInputService (copy)
    local v16 = p15 or UserInputService:GetMouseLocation();

    return workspace.CurrentCamera:ViewportPointToRay(v16.X, v16.Y);
end;

function u1.Raycast(p17, p18, p19, p20) -- Line: 209
    local v21 = p17:GetRay(p20);

    return workspace:Raycast(v21.Origin, v21.Direction * (p19 or 1000), p18);
end;

function u1.Project(p22, p23, p24) -- Line: 241
    local v25 = p22:GetRay(p24);

    return v25.Origin + v25.Direction.Unit * (p23 or 1000);
end;

function u1.Lock(p26) -- Line: 255
    -- upvalues: UserInputService (copy)
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition;
end;

function u1.LockCenter(p27) -- Line: 266
    -- upvalues: UserInputService (copy)
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
end;

function u1.Unlock(p28) -- Line: 273
    -- upvalues: UserInputService (copy)
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
end;

function u1.Destroy(p29) -- Line: 280
    p29._trove:Destroy();
end;

return u1;