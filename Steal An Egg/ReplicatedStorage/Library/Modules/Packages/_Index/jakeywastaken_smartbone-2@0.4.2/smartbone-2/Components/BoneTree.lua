-- Decompiled with Potassium's decompiler.

local u1 = Random.new(1029410295159813);
local Lighting = game:GetService("Lighting");
local Dependencies = script.Parent.Parent:WaitForChild("Dependencies");
require(script.Parent:WaitForChild("Bone"));
local Config = require(Dependencies:WaitForChild("Config"));
local DefaultObjectSettings = require(Dependencies:WaitForChild("DefaultObjectSettings"));
local Gizmo = require(Dependencies:WaitForChild("Gizmo"));
local Utilities = require(Dependencies:WaitForChild("Utilities"));

if game:GetService("RunService"):IsStudio() or Config.ALLOW_LIVE_GAME_DEBUG then
    Gizmo.Init();
end;

local SB_VERBOSE_LOG = Utilities.SB_VERBOSE_LOG;

local function SafeUnit(p2) -- Line: 54
    return p2.Magnitude == 0 and Vector3.new(0, 0, 0) or p2.Unit;
end;

local function map(p3, p4, p5, p6, p7, p8) -- Line: 63
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

function u10.new(p11, u12) -- Line: 178
    -- upvalues: u1 (copy), u10 (copy), DefaultObjectSettings (copy)
    local v13 = {
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
        Settings = {},
        BoundingBoxCFrame = u12.CFrame,
        BoundingBoxSize = u12.Size,
        ObjectPreviousPosition = u12.Position
    };
    local u14 = setmetatable(v13, u10);
    u14.InWorkspace = u12:IsDescendantOf(workspace);
    u14.DestroyConnection = u12.AncestryChanged:ConnectParallel(function() -- Line: 206
        -- upvalues: u12 (copy), u14 (copy)
        if not u12:IsDescendantOf(game) then
            u14.Destroyed = true;
        end;

        u14.InWorkspace = u12:IsDescendantOf(workspace);
    end);
    u14.AttributeConnection = u12.AttributeChanged:ConnectParallel(function(p15) -- Line: 214
        -- upvalues: u14 (copy), u12 (copy), DefaultObjectSettings (ref)
        u14.Settings[p15] = u12:GetAttribute(p15) or DefaultObjectSettings[p15];
    end);

    return u14;
end;

function u10.UpdateBoundingBox(p16) -- Line: 225
    if not p16.InView then
        p16.BoundingBoxCFrame = p16.RootPart.CFrame;
        p16.BoundingBoxSize = p16.RootPart.Size;

        return;
    end;

    local v17 = Vector3.new(inf, inf, inf);
    local v18 = Vector3.new(-inf, -inf, -inf);

    for _, v in p16.Bones do
        local v19 = v.Position + (v.Position - v.LastPosition);
        v17 = v17:Min(v19);
        v18 = v18:Max(v19);
    end;

    p16.BoundingBoxCFrame = CFrame.new((v17 + v18) * 0.5);
    p16.BoundingBoxSize = p16.RootPartSize:Max(v18 - v17);
end;

function u10.UpdateThrottling(p20, p21) -- Line: 268
    local Settings = p20.Settings;
    local Magnitude = (p21 - workspace.CurrentCamera.CFrame.Position).Magnitude;

    if Settings.ActivationDistance < Magnitude then
        p20.UpdateRate = 0;

        return;
    end;

    local ThrottleDistance = Settings.ThrottleDistance;
    local v22 = (Magnitude - ThrottleDistance) / (Settings.ActivationDistance - ThrottleDistance) * 1 + 0;
    p20.UpdateRate = Settings.UpdateRate * (1 - ((v22 < 1 and v22 and v22 or 1) > 0 and (v22 < 1 and v22 and v22 or 1) or 0));
end;

function u10.PreUpdate(p23, p24) -- Line: 292
    local Position = p23.RootPart.CFrame.Position;
    local ObjectVelocity = p23.ObjectVelocity;
    p23.ObjectMove = Position - p23.ObjectPreviousPosition;
    p23.ObjectVelocity = p23.ObjectMove;
    p23.ObjectAcceleration = ObjectVelocity - p23.ObjectVelocity;
    p23.ObjectPreviousPosition = Position;
    p23.RootPartSize = p23.RootPart.Size;
    p23:UpdateThrottling(Position);
    p23:UpdateBoundingBox();

    for _, v in p23.Bones do
        v:PreUpdate(p23);
    end;
end;

function u10.StepPhysics(p25, p26) -- Line: 319
    -- upvalues: Lighting (copy), DefaultObjectSettings (copy)
    local Settings = p25.Settings;
    local v27 = (Settings.Gravity + Settings.Force) * p26;

    if Settings.MatchWorkspaceWind == true then
        local GlobalWind = workspace.GlobalWind;
        Settings.WindDirection = GlobalWind.Magnitude == 0 and Vector3.new(0, 0, 0) or GlobalWind.Unit;
        Settings.WindSpeed = GlobalWind.Magnitude;
    else
        local v28 = Lighting:GetAttribute("WindDirection") or DefaultObjectSettings.WindDirection;
        local v29 = Lighting:GetAttribute("WindSpeed") or DefaultObjectSettings.WindSpeed;
        Settings.WindDirection = v28.Magnitude == 0 and Vector3.new(0, 0, 0) or v28.Unit;
        Settings.WindSpeed = v29;
    end;

    Settings.WindStrength = Lighting:GetAttribute("WindStrength") or DefaultObjectSettings.WindStrength;

    for _, v in p25.Bones do
        v:StepPhysics(p25, v27, p26);
    end;
end;

function u10.Constrain(p30, p31, p32) -- Line: 351
    for _, v in p30.Bones do
        v:Constrain(p30, p31, p32);
    end;
end;

function u10.SkipUpdate(p33) -- Line: 363
    for _, v in p33.Bones do
        v:SkipUpdate();
    end;

    p33.IsSkippingUpdates = true;
end;

function u10.SolveTransform(p34, p35) -- Line: 377
    for _, v in p34.Bones do
        v:SolveTransform(p34, p35);
    end;

    p34.IsSkippingUpdates = false;
end;

function u10.ApplyTransform(p36) -- Line: 391
    for _, v in p36.Bones do
        v:ApplyTransform(p36);
    end;
end;

function u10.DrawDebug(p37, p38, p39, p40, p41, p42, p43, p44, p45) -- Line: 411
    -- upvalues: Gizmo (copy)
    local v46 = Color3.fromRGB(248, 168, 20);
    local v47 = Color3.fromRGB(76, 208, 223);
    local v48 = Color3.fromRGB(255, 89, 89);
    local v49 = Color3.new(1, 0, 0);
    local v50 = Color3.new(0, 1, 0);
    local v51 = Color3.new(0, 0, 1);

    if p45 then
        local v52 = p37.RootPart.Position + Vector3.new(0, p37.RootPart.Size.Y * 0.5 + 1, 0);
        Gizmo.SetStyle(v49, 0, true);
        Gizmo.Arrow:Draw(v52, v52 + p37.ObjectMove, 0.025, 0.1, 6);
        Gizmo.SetStyle(v50, 0, true);
        Gizmo.Arrow:Draw(v52, v52 + p37.ObjectVelocity, 0.025, 0.1, 6);
        Gizmo.SetStyle(v51, 0, true);
        Gizmo.Arrow:Draw(v52, v52 + p37.ObjectAcceleration, 0.025, 0.1, 6);
    end;

    Gizmo.PushProperty("AlwaysOnTop", false);

    if p43 then
        Gizmo.PushProperty("Color3", v47);
        Gizmo.Box:Draw(p37.BoundingBoxCFrame, p37.BoundingBoxSize, true);
    end;

    if p42 then
        Gizmo.PushProperty("Color3", v47);
        Gizmo.Box:Draw(p37.RootPart.CFrame, p37.RootPart.Size, true);
        Gizmo.SetStyle(v48, 0.75, false);
        Gizmo.VolumeBox:Draw(p37.RootPart.CFrame, p37.RootPart.Size);
        Gizmo.PushProperty("Transparency", 0);
    end;

    for i, v in p37.Bones do
        local Position = v.Bone.TransformedWorldCFrame.Position;
        local v53 = p37.Bones[v.ParentIndex];
        v:DrawDebug(p37, p38, p39, p40, p41, p44);

        if p39 and i ~= 1 then
            Gizmo.PushProperty("Color3", v46);
            Gizmo.Ray:Draw(v53.Bone.TransformedWorldCFrame.Position, Position);
        end;
    end;
end;

function u10.DrawOverlay(p54, p55) -- Line: 478
    -- upvalues: Config (copy)
    if Config.DEBUG_OVERLAY_TREE_INFO or Config.DEBUG_OVERLAY_TREE_OBJECTS then
        p55.Text((`Root Part: {p54.RootPart.Name}`));
        p55.Text((`Root Bone: {p54.Root.Name}`));
        p55.Text((`Root Part Size: {string.format("%.3f, %.3f, %.3f", p54.RootPart.Size.X, p54.RootPart.Size.Y, p54.RootPart.Size.Z)}`));
    end;

    if Config.DEBUG_OVERLAY_TREE_INFO or Config.DEBUG_OVERLAY_TREE_NUMERICS then
        p55.Text((`Update Rate: {string.format("%.3f", p54.UpdateRate)}`));
        p55.Text((`In View: {p54.InView}`));
        p55.Text((`Accumulated Delta: {string.format("%.3f", p54.AccumulatedDelta)}`));
        p55.Text((`Force: {string.format("%.3f, %.3f, %.3f", p54.Force.X, p54.Force.Y, p54.Force.Z)}`));
    end;

    local v56 = Color3.new(0.486275, 0.431373, 1);
    local v57 = Color3.new(1, 1, 1);

    if Config.DEBUG_OVERLAY_BONE then
        for i, v in p54.Bones do
            if Config.DEBUG_OVERLAY_MAX_BONES > 0 and Config.DEBUG_OVERLAY_BONE_OFFSET + Config.DEBUG_OVERLAY_MAX_BONES <= i then
                break;
            end;

            if i >= Config.DEBUG_OVERLAY_BONE_OFFSET then
                p55.Begin(`Bone {i}`, v56, v57);
                v:DrawOverlay(p55);
                p55.End();
            end;
        end;
    end;
end;

function u10.Destroy(p58) -- Line: 521
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG("Destroy BoneTree");
    task.synchronize();
    p58.DestroyConnection:Disconnect();
    p58.AttributeConnection:Disconnect();

    for _, v in p58.Bones do
        v:Destroy();
    end;

    setmetatable(p58, nil);
    task.desynchronize();
end;

return u10;