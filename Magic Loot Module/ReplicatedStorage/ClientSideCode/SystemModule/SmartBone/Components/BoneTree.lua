-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Dependencies = script.Parent.Parent:WaitForChild("Dependencies");
require(script.Parent:WaitForChild("Bone"));
local Config = require(Dependencies:WaitForChild("Config"));
local DefaultObjectSettings = require(Dependencies:WaitForChild("DefaultObjectSettings"));
local Gizmo = require(Dependencies:WaitForChild("Debug"):WaitForChild("Gizmo"));
local Utilities = require(Dependencies:WaitForChild("Utilities"));
local u1 = Random.new(1029410295159813);
local SB_VERBOSE_LOG = Utilities.SB_VERBOSE_LOG;
local CollectionService = game:GetService("CollectionService");

local function SafeUnit(p2) -- Line: 51
    return p2.Magnitude == 0 and Vector3.new(0, 0, 0) or p2.Unit;
end;

local function map(p3, p4, p5, p6, p7, p8) -- Line: 60
    local v9 = (p3 - p4) / (p5 - p4) * (p7 - p6) + p6;

    if not p8 then
        return v9;
    end;

    if p6 < p7 then
        if p6 < (v9 < p7 and v9 and v9 or p7) then
            p6 = v9 < p7 and v9 and v9 or (p7 or p6);
        end;

        return p6;
    end;

    if p7 < (v9 < p6 and v9 and v9 or p6) then
        p7 = v9 < p6 and v9 and v9 or (p6 or p7);
    end;

    return p7;
end;

local u10 = {};
u10.__index = u10;

function u10.new(p11, u12, u13) -- Line: 168
    -- upvalues: u1 (copy), u10 (copy), DefaultObjectSettings (copy), CollectionService (copy)
    local v14 = {
        UpdateRate = 0,
        InView = true,
        AccumulatedDelta = 0,
        Destroyed = false,
        IsSkippingUpdates = false,
        InWorkspace = false,
        Force = Vector3.new(0, 0, 0),
        ObjectMove = Vector3.new(0, 0, 0),
        ObjectVelocity = Vector3.new(0, 0, 0),
        ObjectAcceleration = Vector3.new(0, 0, 0),
        WindOffset = u1:NextNumber(0, 1000000),
        Root = p11:IsA("Bone") and p11 and p11 or nil,
        RootPart = u12,
        RootPartSize = u12.Size,
        Bones = {},
        Settings = u13,
        BoundingBoxCFrame = u12.CFrame,
        BoundingBoxSize = u12.Size,
        ObjectPreviousPosition = u12.Position
    };
    local u15 = setmetatable(v14, u10);
    u15.InWorkspace = u12:IsDescendantOf(workspace);
    u15.DestroyConnection = u12.AncestryChanged:ConnectParallel(function() -- Line: 196
        -- upvalues: u12 (copy), u15 (copy)
        if not u12:IsDescendantOf(game) then
            u15.Destroyed = true;
        end;

        u15.InWorkspace = u12:IsDescendantOf(workspace);
    end);
    u15.AttributeConnection = u12.AttributeChanged:ConnectParallel(function(p16) -- Line: 204
        -- upvalues: u13 (copy), u12 (copy), DefaultObjectSettings (ref)
        u13[p16] = u12:GetAttribute(p16) or DefaultObjectSettings[p16];
    end);
    u15.TagConnection = CollectionService:GetInstanceRemovedSignal("SmartBone"):Connect(function(p17) -- Line: 209
        -- upvalues: u12 (copy), u15 (copy)
        if p17 ~= u12 then
            return;
        end;

        u15.Destroyed = true;
    end);

    return u15;
end;

function u10.UpdateBoundingBox(p18) -- Line: 244
    if not p18.InView then
        p18.BoundingBoxCFrame = p18.RootPart.CFrame;
        p18.BoundingBoxSize = p18.RootPart.Size;

        return;
    end;

    local v19 = Vector3.new(inf, inf, inf);
    local v20 = Vector3.new(-inf, -inf, -inf);

    for _, v in p18.Bones do
        local v21 = v.Position + (v.Position - v.LastPosition);
        v19 = v19:Min(v21);
        v20 = v20:Max(v21);
    end;

    p18.BoundingBoxCFrame = CFrame.new((v19 + v20) * 0.5);
    p18.BoundingBoxSize = p18.RootPartSize:Max(v20 - v19);
end;

function u10.UpdateThrottling(p22, p23) -- Line: 281
    local Settings = p22.Settings;
    local Magnitude = (p23 - workspace.CurrentCamera.CFrame.Position).Magnitude;

    if Settings.ActivationDistance < Magnitude then
        p22.UpdateRate = 0;

        return;
    end;

    local ThrottleDistance = Settings.ThrottleDistance;
    local v24 = (Magnitude - ThrottleDistance) / (Settings.ActivationDistance - ThrottleDistance) * 1 + 0;
    p22.UpdateRate = Settings.UpdateRate * (1 - ((v24 < 1 and v24 and v24 or 1) > 0 and (v24 < 1 and v24 and v24 or 1) or 0));
end;

function u10.PreUpdate(p25, p26) -- Line: 302
    local Position = p25.RootPart.CFrame.Position;
    local ObjectVelocity = p25.ObjectVelocity;
    p25.ObjectMove = Position - p25.ObjectPreviousPosition;
    p25.ObjectVelocity = p25.ObjectMove;
    p25.ObjectAcceleration = ObjectVelocity - p25.ObjectVelocity;
    p25.ObjectPreviousPosition = Position;
    p25.RootPartSize = p25.RootPart.Size;
    p25:UpdateThrottling(Position);
    p25:UpdateBoundingBox();

    for _, v in p25.Bones do
        v:PreUpdate(p25);
    end;
end;

function u10.StepPhysics(p27, p28) -- Line: 327
    -- upvalues: Lighting (copy), DefaultObjectSettings (copy)
    local Settings = p27.Settings;
    local v29 = Settings.Gravity + Settings.Force;

    if Settings.MatchWorkspaceWind == true then
        local GlobalWind = workspace.GlobalWind;
        Settings.WindDirection = GlobalWind.Magnitude == 0 and Vector3.new(0, 0, 0) or GlobalWind.Unit;
        Settings.WindSpeed = GlobalWind.Magnitude;
    else
        local v30 = Lighting:GetAttribute("WindDirection") or DefaultObjectSettings.WindDirection;
        local v31 = Lighting:GetAttribute("WindSpeed") or DefaultObjectSettings.WindSpeed;
        Settings.WindDirection = v30.Magnitude == 0 and Vector3.new(0, 0, 0) or v30.Unit;
        Settings.WindSpeed = v31;
    end;

    Settings.WindStrength = Lighting:GetAttribute("WindStrength") or DefaultObjectSettings.WindStrength;

    for _, v in p27.Bones do
        v:StepPhysics(p27, v29, p28);
    end;
end;

function u10.Constrain(p32, p33, p34) -- Line: 357
    for _, v in p32.Bones do
        v:Constrain(p32, p33, p34);
    end;
end;

function u10.SkipUpdate(p35) -- Line: 367
    for _, v in p35.Bones do
        v:SkipUpdate();
    end;

    p35.IsSkippingUpdates = true;
end;

function u10.SolveTransform(p36, p37) -- Line: 379
    for _, v in p36.Bones do
        v:SolveTransform(p36, p37);
    end;

    p36.IsSkippingUpdates = false;
end;

function u10.ApplyTransform(p38) -- Line: 391
    for _, v in p38.Bones do
        v:ApplyTransform(p38);
    end;
end;

function u10.DrawDebug(p39, p40, p41, p42, p43, p44, p45, p46, p47) -- Line: 409
    -- upvalues: Gizmo (copy)
    local v48 = Color3.fromRGB(248, 168, 20);
    local v49 = Color3.fromRGB(76, 208, 223);
    local v50 = Color3.fromRGB(255, 89, 89);
    local v51 = Color3.new(1, 0, 0);
    local v52 = Color3.new(0, 1, 0);
    local v53 = Color3.new(0, 0, 1);

    if p47 then
        local v54 = p39.RootPart.Position + Vector3.new(0, p39.RootPart.Size.Y * 0.5 + 1, 0);
        Gizmo.SetStyle(v51, 0, true);
        Gizmo.Arrow:Draw(v54, v54 + p39.ObjectMove, 0.025, 0.1, 6);
        Gizmo.SetStyle(v52, 0, true);
        Gizmo.Arrow:Draw(v54, v54 + p39.ObjectVelocity, 0.025, 0.1, 6);
        Gizmo.SetStyle(v53, 0, true);
        Gizmo.Arrow:Draw(v54, v54 + p39.ObjectAcceleration, 0.025, 0.1, 6);
    end;

    Gizmo.PushProperty("AlwaysOnTop", false);

    if p45 then
        Gizmo.PushProperty("Color3", v49);
        Gizmo.Box:Draw(p39.BoundingBoxCFrame, p39.BoundingBoxSize, true);
    end;

    if p44 then
        Gizmo.PushProperty("Color3", v49);
        Gizmo.Box:Draw(p39.RootPart.CFrame, p39.RootPart.Size, true);
        Gizmo.SetStyle(v50, 0.75, false);
        Gizmo.VolumeBox:Draw(p39.RootPart.CFrame, p39.RootPart.Size);
        Gizmo.PushProperty("Transparency", 0);
    end;

    for i, v in p39.Bones do
        local Position = v.Bone.TransformedWorldCFrame.Position;
        local v55 = p39.Bones[v.ParentIndex];
        v:DrawDebug(p39, p40, p41, p42, p43, p46);

        if p41 and i ~= 1 then
            Gizmo.PushProperty("Color3", v48);
            Gizmo.Ray:Draw(v55.Bone.TransformedWorldCFrame.Position, Position);
        end;
    end;
end;

function u10.DrawOverlay(p56, p57) -- Line: 474
    -- upvalues: Config (copy)
    if Config.DEBUG_OVERLAY_TREE_INFO or Config.DEBUG_OVERLAY_TREE_OBJECTS then
        p57.Text((`Root Part: {p56.RootPart.Name}`));
        p57.Text((`Root Bone: {p56.Root.Name}`));
        p57.Text((`Root Part Size: {string.format("%.3f, %.3f, %.3f", p56.RootPart.Size.X, p56.RootPart.Size.Y, p56.RootPart.Size.Z)}`));
    end;

    if Config.DEBUG_OVERLAY_TREE_INFO or Config.DEBUG_OVERLAY_TREE_NUMERICS then
        p57.Text((`Update Rate: {string.format("%.3f", p56.UpdateRate)}`));
        p57.Text((`In View: {p56.InView}`));
        p57.Text((`Accumulated Delta: {string.format("%.3f", p56.AccumulatedDelta)}`));
        p57.Text((`Force: {string.format("%.3f, %.3f, %.3f", p56.Force.X, p56.Force.Y, p56.Force.Z)}`));
    end;

    local v58 = Color3.new(0.486275, 0.431373, 1);
    local v59 = Color3.new(1, 1, 1);

    if Config.DEBUG_OVERLAY_BONE then
        for i, v in p56.Bones do
            if Config.DEBUG_OVERLAY_MAX_BONES > 0 and Config.DEBUG_OVERLAY_BONE_OFFSET + Config.DEBUG_OVERLAY_MAX_BONES <= i then
                break;
            end;

            if i >= Config.DEBUG_OVERLAY_BONE_OFFSET then
                p57.Begin(`Bone {i}`, v58, v59);
                v:DrawOverlay(p57);
                p57.End();
            end;
        end;
    end;
end;

function u10.Destroy(p60) -- Line: 510
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG("Destroy BoneTree");
    task.synchronize();
    p60.DestroyConnection:Disconnect();
    p60.AttributeConnection:Disconnect();
    p60.TagConnection:Disconnect();

    for _, v in p60.Bones do
        v:Destroy();
    end;

    setmetatable(p60, nil);
    task.desynchronize();
end;

return u10;