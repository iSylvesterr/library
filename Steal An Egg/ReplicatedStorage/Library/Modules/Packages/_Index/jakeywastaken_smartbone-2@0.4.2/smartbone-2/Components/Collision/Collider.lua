-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Dependencies = script.Parent.Parent.Parent:WaitForChild("Dependencies");
local Colliders = script.Parent:WaitForChild("Colliders");
local Box = require(Colliders:WaitForChild("Box"));
local Capsule = require(Colliders:WaitForChild("Capsule"));
local Cylinder = require(Colliders:WaitForChild("Cylinder"));
local Sphere = require(Colliders:WaitForChild("Sphere"));
local Config = require(script.Parent.Parent.Parent:WaitForChild("Dependencies"):WaitForChild("Config"));
local SB_VERBOSE_LOG = require(script.Parent.Parent.Parent:WaitForChild("Dependencies"):WaitForChild("Utilities")).SB_VERBOSE_LOG;
local Gizmo = require(Dependencies:WaitForChild("Gizmo"));

if game:GetService("RunService"):IsStudio() or Config.ALLOW_LIVE_GAME_DEBUG or Config.ALLOW_LIVE_GAME_DEBUG then
    Gizmo.Init();
end;

local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 76
    -- upvalues: HttpService (copy), u1 (copy)
    local v2 = {
        Type = "Box",
        Scale = Vector3.new(0, 0, 0),
        Offset = Vector3.new(0, 0, 0),
        Rotation = Vector3.new(0, 0, 0),
        Radius = 0,
        PreviousScale = Vector3.new(0, 0, 0),
        PreviousOffset = Vector3.new(0, 0, 0),
        PreviousRotation = Vector3.new(0, 0, 0),
        PreviousObjectPosition = Vector3.new(0, 0, 0),
        PreviousObjectRotation = Vector3.new(0, 0, 0),
        m_Object = nil,
        InNarrowphase = false,
        Size = Vector3.new(0, 0, 0),
        Transform = CFrame.identity,
        GUID = HttpService:GenerateGUID(false)
    };

    return setmetatable(v2, u1);
end;

function u1.SetObject(p3, p4) -- Line: 105
    p3.m_Object = p4;
    p3:UpdateTransform();
end;

function u1.UpdateTransform(p5) -- Line: 112
    local m_Object = p5.m_Object;
    local CFrame2 = m_Object.CFrame;
    local Size = m_Object.Size;
    local Rotation = p5.Rotation;
    local v6 = Size * p5.Offset;
    local v7 = Size * p5.Scale;
    local v8 = CFrame.Angles(Rotation.X * 0.017453, Rotation.Y * 0.017453, Rotation.Z * 0.017453);
    p5.Transform = CFrame2 * CFrame.new(v6) * v8;
    p5.Size = v7;
    local v9 = (math.max(v7.X, v7.Y, v7.Z) * 0.5) ^ 2 * 2;
    p5.Radius = math.sqrt(v9);
end;

function u1.GetClosestPoint(p10, p11, p12) -- Line: 139
    -- upvalues: Box (copy), Capsule (copy), Sphere (copy), Cylinder (copy)
    if p10.m_Object == nil then
        return;
    end;

    p10.InNarrowphase = false;

    if (p11 - p10.Transform.Position).Magnitude - p12 <= p10.Radius then
        p10.InNarrowphase = true;
        local Type = p10.Type;
        local v13, v14, v15;

        if Type == "Box" then
            v13, v14, v15 = Box(p10.Transform, p10.Size, p11, p12);
        else
            v13 = nil;
            v14 = nil;
            v15 = nil;
        end;

        if Type == "Capsule" then
            v13, v14, v15 = Capsule(p10.Transform, p10.Size, p11, p12);
        end;

        if Type == "Sphere" then
            v13, v14, v15 = Sphere(p10.Transform, p10.Size, p11, p12);
        end;

        if Type == "Cylinder" then
            v13, v14, v15 = Cylinder(p10.Transform, p10.Size, p11, p12);
        end;

        return v13, v14, v15;
    end;
end;

function u1.Step(p16) -- Line: 184
    p16:UpdateTransform();
end;

function u1.DrawDebug(p17, p18, p19, p20, p21, p22) -- Line: 198
    -- upvalues: Gizmo (copy)
    local v23 = Color3.new(0.509803, 0.933333, 0.42745);
    local v24 = Color3.new(0.90196, 0.784313, 0.513725);
    local v25 = Color3.new(1, 0, 1);
    local v26 = Color3.new(0, 1, 1);
    local v27 = Color3.new(1, 0.3, 0.3);
    local Type = p17.Type;
    local Transform = p17.Transform;
    local Size = p17.Size;

    if p18.m_Awake then
        v25 = v23;
    elseif not p21 then
        v25 = v23;
    end;

    if p17.InNarrowphase == false then
        if not p22 then
            v26 = v24;
        end;
    else
        v26 = v24;
    end;

    if p20 then
        Gizmo.SetStyle(v27, 0, false);
        Gizmo.Sphere:Draw(Transform, p17.Radius, 25, 360);
    end;

    if Type == "Box" then
        Gizmo.SetStyle(v25, 0, false);
        Gizmo.Box:Draw(Transform, Size);

        if p19 then
            Gizmo.SetStyle(v26, 0.75, false);
            Gizmo.VolumeBox:Draw(Transform, Size);
            Gizmo.PushProperty("Transparency", 0);
        end;

        return;
    end;

    if Type == "Capsule" then
        local v28 = (Size.Y < Size.Z and Size.Y or Size.Z) * 0.5;
        local X = Size.X;
        local v29 = Transform * CFrame.Angles(1.5707963267948966, -1.5707963267948966, 0);
        Gizmo.SetStyle(v25, 0, false);
        Gizmo.Capsule:Draw(v29, v28, X, 15);

        if p19 then
            local v30 = v29.Position + v29.UpVector * (X * 0.5);
            local v31 = v29.Position - v29.UpVector * (X * 0.5);
            Gizmo.SetStyle(v26, 0.75, false);
            Gizmo.VolumeCylinder:Draw(Transform, v28, X);
            Gizmo.VolumeSphere:Draw(CFrame.new(v30), v28);
            Gizmo.VolumeSphere:Draw(CFrame.new(v31), v28);
            Gizmo.PushProperty("Transparency", 0);
        end;

        return;
    end;

    if Type == "Sphere" then
        local v32 = math.min(Size.X, Size.Y, Size.Z) * 0.5;
        Gizmo.SetStyle(v25, 0, false);
        Gizmo.Sphere:Draw(Transform, v32, 15, 360);

        if p19 then
            Gizmo.SetStyle(v26, 0.75, false);
            Gizmo.VolumeSphere:Draw(Transform, v32);
            Gizmo.PushProperty("Transparency", 0);
        end;

        return;
    end;

    if Type ~= "Cylinder" then
        return;
    end;

    local v33 = (Size.Y < Size.Z and Size.Y or Size.Z) * 0.5;
    Gizmo.SetStyle(v25, 0, false);
    Gizmo.Cylinder:Draw(Transform * CFrame.Angles(0, 0, 1.5707963267948966), v33, Size.X, 15);

    if p19 then
        Gizmo.SetStyle(v26, 0.75, false);
        Gizmo.VolumeCylinder:Draw(Transform * CFrame.Angles(0, -1.5707963267948966, 0), v33, Size.X, 0, 360);
        Gizmo.PushProperty("Transparency", 0);
    end;
end;

function u1.Destroy(p34) -- Line: 290
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG((`Collider destroying, object: {p34.m_Object}`));
    setmetatable(p34, nil);
end;

return u1;