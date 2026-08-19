-- Decompiled with Potassium's decompiler.

debug.profilebegin("ActiveAssetsController.CashCollected");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Camera = workspace.Camera;
local u1 = game.Players.LocalPlayer:GetMouse();
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 10
    -- upvalues: u2 (copy), RunService (copy)
    local u3 = {
        filterType = nil,
        collisionGroup = "Default",
        rayLength = 150,
        ticks = 1,
        filterDescendants = {},
        currentPosition = Vector2.new(0, 0),
        previousPosition = Vector2.new(0, 0)
    };
    setmetatable(u3, u2);
    RunService:BindToRenderStep("MeasureMouseMovement", Enum.RenderPriority.Input.Value, function(p4) -- Line: 22
        -- upvalues: u3 (copy)
        if u3.ticks % 2 == 0 then
            u3.currentPosition = u3:GetPosition();
        else
            u3.previousPosition = u3:GetPosition();
        end;

        u3.ticks = u3.ticks % 10 + 1;
    end);

    return u3;
end;

function u2.GetViewSize(p5) -- Line: 34
    -- upvalues: Camera (copy)
    return Camera.ViewportSize;
end;

function u2.GetPosition(p6) -- Line: 38
    -- upvalues: UserInputService (copy)
    return UserInputService:GetMouseLocation();
end;

function u2.GetUnitRay(p7) -- Line: 42
    -- upvalues: Camera (copy)
    local v8 = p7:GetPosition();

    return Camera:ViewportPointToRay(v8.x, v8.y);
end;

function u2.GetOrigin(p9) -- Line: 47
    return p9:GetUnitRay().Origin;
end;

function u2.GetDelta(p10) -- Line: 51
    return p10.currentPosition - p10.previousPosition;
end;

function u2.ScreenPointToRay(p11) -- Line: 55
    local v12 = RaycastParams.new();
    v12.FilterDescendantsInstances = p11.filterDescendants;
    v12.FilterType = p11.filterType;
    v12.CollisionGroup = p11.collisionGroup;

    return v12;
end;

function u2.CastRay(p13) -- Line: 63
    local v14 = p13:ScreenPointToRay();

    return workspace:Raycast(p13:GetOrigin(), p13:GetUnitRay().Direction * p13.rayLength, v14);
end;

function u2.GetHit(p15) -- Line: 68
    local v16 = p15:CastRay();

    return v16 and v16.Position or nil;
end;

function u2.GetTarget(p17) -- Line: 73
    local v18 = p17:CastRay();

    return v18 and v18.Instance or nil;
end;

function u2.GetTargetFilter(p19) -- Line: 78
    return p19.filterDescendants;
end;

function u2.SetTargetFilter(p20, p21) -- Line: 82
    local v22 = typeof(p21);

    if v22 == "Instance" then
        p20.filterDescendants = { p21 };

        return;
    end;

    if v22 == "table" then
        p20.filterDescendants = p21;

        return;
    end;

    error("object expected an instance or a table of instances, received: " .. v22);
end;

function u2.SetCollisionGroup(p23, p24) -- Line: 95
    p23.collisionGroup = p24;
end;

function u2.GetRayLength(p25) -- Line: 99
    return p25.rayLength;
end;

function u2.SetRayLength(p26, p27) -- Line: 103
    local v28 = typeof(p27);
    local v29;

    if v28 == "number" then
        v29 = p27 >= 0;
    else
        v29 = false;
    end;

    assert(v29, "length expected a number, received: " .. v28);
    p26.rayLength = p27;
end;

function u2.GetFilterType(p30) -- Line: 113
    return p30.filterType;
end;

function u2.SetFilterType(p31, p32) -- Line: 117
    local v33 = Enum.RaycastFilterType:GetEnumItems();

    if table.find(v33, p32) then
        p31.filterType = p32;

        return;
    end;

    error("Invalid raycast filter type provided");
end;

function u2.EnableIcon() -- Line: 127
    -- upvalues: UserInputService (copy)
    UserInputService.MouseIconEnabled = true;
end;

function u2.DisableIcon() -- Line: 131
    -- upvalues: UserInputService (copy)
    UserInputService.MouseIconEnabled = false;
end;

function u2.ChangeIcon(p34, p35) -- Line: 135
    -- upvalues: u1 (copy)
    u1.Icon = p35;
end;

return u2;