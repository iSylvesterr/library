-- Decompiled with Potassium's decompiler.

local u1 = Color3.fromRGB(185, 187, 192);
local u2 = Color3.fromRGB(70, 68, 63);
local Unit = (Vector3.new(-0.45, -0.55, -1)).Unit;
local u3 = { Vector3.new(-1, -1, -1), Vector3.new(1, -1, -1), Vector3.new(-1, 1, -1), Vector3.new(1, 1, -1), Vector3.new(-1, -1, 1), Vector3.new(1, -1, 1), Vector3.new(-1, 1, 1), Vector3.new(1, 1, 1) };
local v4 = {};
local u5 = nil;

function v4.replace(p6) -- Line: 17
    -- upvalues: u1 (copy), u2 (copy), u5 (ref)
    local ViewportFrame = Instance.new("ViewportFrame");
    ViewportFrame.Name = "ItemView";
    ViewportFrame.AnchorPoint = p6.AnchorPoint;
    ViewportFrame.Position = p6.Position;
    ViewportFrame.Size = p6.Size;
    ViewportFrame.SizeConstraint = p6.SizeConstraint;
    ViewportFrame.ZIndex = p6.ZIndex;
    ViewportFrame.BackgroundTransparency = 1;
    ViewportFrame.Ambient = u1;
    ViewportFrame.LightColor = u2;
    local Camera = Instance.new("Camera");
    Camera.Parent = ViewportFrame;
    ViewportFrame.CurrentCamera = Camera;

    for _, child in p6:GetChildren() do
        child.Parent = ViewportFrame;
    end;

    ViewportFrame.Parent = p6.Parent;
    p6:Destroy();
    ViewportFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 36
        -- upvalues: u5 (ref), ViewportFrame (copy)
        return u5(ViewportFrame);
    end);

    return ViewportFrame;
end;

function v4.setModel(p7, p8, p9, p10) -- Line: 42
    -- upvalues: u5 (ref)
    local v11 = p7:FindFirstChildOfClass("Model");

    if v11 ~= nil then
        v11:Destroy();
    end;

    if not p8 then
        return nil;
    end;

    p7:SetAttribute("ViewYaw", p9 == nil and 0 or p9);
    p7:SetAttribute("ViewZoom", p10 == nil and 1 or p10);
    p8:PivotTo(CFrame.new());
    p8.Parent = p7;
    u5(p7);
end;

local u12 = nil;

u5 = function(p13) -- Line: 64, Name: refit
    -- upvalues: u12 (ref)
    local v14 = p13:FindFirstChildOfClass("Model");
    local CurrentCamera = p13.CurrentCamera;

    if not (v14 and CurrentCamera) then
        return nil;
    end;

    u12(CurrentCamera, p13, v14, p13:GetAttribute("ViewYaw"), p13:GetAttribute("ViewZoom"));
end;

u12 = function(p15, p16, p17, p18, p19) -- Line: 72, Name: aimCamera
    -- upvalues: u3 (copy), Unit (copy)
    local v20, v21 = p17:GetBoundingBox();
    local Position = v20.Position;
    local v22 = v21 / 2;
    local v23 = v21.X <= v21.Z and Vector3.new(1, 0, 0) or Vector3.new(0, 0, 1);
    local v24 = v20:VectorToWorldSpace(Vector3.new(0, 1, 0));
    local v25 = v20:VectorToWorldSpace(v23);
    local v26 = CFrame.lookAt(Position + v25, Position, v24);
    local v27 = math.rad(p18);
    local v28 = v26:VectorToWorldSpace(CFrame.Angles(0, v27, 0):VectorToWorldSpace(Vector3.new(0, 0, 1)));
    local v29 = Position + v28;
    local v30 = CFrame.lookAt(v29, Position, v24) - v29;
    local AbsoluteSize = p16.AbsoluteSize;
    local v31 = math.rad(p15.FieldOfView) / 2;
    local v32 = math.tan(v31);
    local v33;

    if AbsoluteSize.Y > 0 then
        v33 = v32 * AbsoluteSize.X / AbsoluteSize.Y;
    else
        v33 = v32;
    end;

    local v34 = 0;

    for _, v in u3 do
        local v35 = v30:VectorToObjectSpace(v20:VectorToWorldSpace(v22 * v));
        local v36 = math.abs(v35.X) / v33 + v35.Z;
        local v37 = math.abs(v35.Y) / v32 + v35.Z;
        v34 = math.max(v34, v36, v37);
    end;

    p15.CFrame = v30 + (Position + v28 * (v34 * 1.02 / p19));
    p16.LightDirection = v30:VectorToWorldSpace(Unit);
end;

return {
    ModelViewport = v4
};