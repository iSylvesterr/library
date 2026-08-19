-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local AnimationModule = UtilsSystem.AnimationModule;
local u1 = {};
u1.__index = u1;
local u2 = CFrame.new(0, 2, 8);

local function _toCameraCFrame(p3) -- Line: 106
    if not p3 then
        return CFrame.new(0, 0, 0);
    end;

    if typeof(p3) == "Vector3" then
        return CFrame.new(p3);
    end;

    return p3;
end;

local function _clearShowModels(p4) -- Line: 121
    for _, child in p4:GetChildren() do
        if child:IsA("WorldModel") then
            for _, child2 in child:GetChildren() do
                if child2:IsA("Model") then
                    child2:Destroy();
                end;
            end;
        elseif child:IsA("Model") then
            child:Destroy();
        end;
    end;
end;

local function _readCameraOffsetFrom(p5) -- Line: 141
    local v6 = p5:GetAttribute("CameraOffset");

    if typeof(v6) == "CFrame" then
        return v6;
    end;

    local v7 = p5:IsA("Model") and p5.PrimaryPart;

    if v7 then
        local v8 = v7:GetAttribute("CameraOffset");

        if typeof(v8) == "CFrame" then
            return v8;
        end;
    end;

    return nil;
end;

function u1.ResolveShowModelCamera(p9) -- Line: 168
    -- upvalues: u2 (copy)
    p9:PivotTo(CFrame.new());
    local v10 = p9:GetAttribute("CameraOffset");

    if typeof(v10) ~= "CFrame" then
        if p9:IsA("Model") then
            local PrimaryPart = p9.PrimaryPart;

            if PrimaryPart then
                v10 = PrimaryPart:GetAttribute("CameraOffset");

                if typeof(v10) ~= "CFrame" then
                    v10 = nil;
                end;
            else
                v10 = nil;
            end;
        else
            v10 = nil;
        end;
    end;

    if v10 then
        return v10;
    end;

    local v11 = p9:GetAttribute("Head");

    if typeof(v11) == "CFrame" then
        return v11;
    end;

    if typeof(v11) == "Vector3" then
        return CFrame.new(v11);
    end;

    local Head = p9:FindFirstChild("Head");

    if Head and Head:IsA("BasePart") then
        return CFrame.lookAt(Vector3.new(0, 0, -7), Head.Position);
    end;

    local Torso = p9:FindFirstChild("Torso");

    if Torso and Torso:IsA("BasePart") then
        return CFrame.lookAt(Vector3.new(0, 0, -7), Torso.Position);
    end;

    return u2;
end;

function u1.new(p12, p13, p14, p15) -- Line: 204
    -- upvalues: _clearShowModels (copy), u1 (copy), InsMgr (copy)
    _clearShowModels(p12);
    local v16 = setmetatable({}, u1);
    v16.viewportFrame = p12;
    v16.viewportCamera = InsMgr.GetIns("Camera", "Camera", v16.viewportFrame);
    v16.worldModel = InsMgr.GetIns("WorldModel", "WorldModel", v16.viewportFrame);
    v16.shadowViewportFrame = nil;
    v16.viewPortModelanimationName = nil;

    if p13 then
        v16.showModel = p13;
        v16.showModel:PivotTo(p15 or CFrame.new(0, 0, 0));
        v16.showModel.Parent = v16.worldModel;
    end;

    local viewportCamera = v16.viewportCamera;

    if p14 then
        if typeof(p14) == "Vector3" then
            p14 = CFrame.new(p14);
        end;
    else
        p14 = CFrame.new(0, 0, 0);
    end;

    viewportCamera.CFrame = p14;
    v16.viewportFrame.CurrentCamera = v16.viewportCamera;

    return v16;
end;

function u1.SetShowModel(p17, p18, p19, p20) -- Line: 238
    -- upvalues: _clearShowModels (copy)
    if not p18 then
        return;
    end;

    p17:CloseViewportFrameModelAnimation();
    _clearShowModels(p17.viewportFrame);
    p17.showModel = p18;
    p17.showModel:PivotTo(p20 or CFrame.new(0, 0, 0));
    p17.showModel.Parent = p17.worldModel;
    local viewportCamera = p17.viewportCamera;

    if p19 then
        if typeof(p19) == "Vector3" then
            p19 = CFrame.new(p19);
        end;
    else
        p19 = CFrame.new(0, 0, 0);
    end;

    viewportCamera.CFrame = p19;
end;

function u1.destroy(p21) -- Line: 258
    p21:CloseViewportFrameModelAnimation();

    if p21.showModel then
        p21.showModel:Destroy();
        p21.showModel = nil;
    end;

    if p21.shadowViewportFrame then
        p21.shadowViewportFrame:Destroy();
        p21.shadowViewportFrame = nil;
    end;

    if p21.viewportFrame then
        p21.viewportFrame.CurrentCamera = nil;
    end;
end;

function u1.SetViewportFrameColor(p22, p23, p24) -- Line: 279
    p22.viewportFrame.ImageColor3 = p23;
    p22.viewportFrame.ImageTransparency = p24;
end;

function u1.CreateViewportFrameShadow(p25, p26) -- Line: 290
    if p25.shadowViewportFrame then
        p25.shadowViewportFrame:Destroy();
    end;

    local v27 = p25.viewportFrame:Clone();
    v27.Name = p25.viewportFrame.Name .. "Shadow";
    v27.Parent = p25.viewportFrame.Parent;
    v27.ImageColor3 = Color3.new(0, 0, 0);
    v27.ImageTransparency = 0;
    v27.ZIndex = -1;
    local Position = p25.viewportFrame.Position;
    v27.Position = UDim2.new(Position.X.Scale, Position.X.Offset + p26.X.Offset, Position.Y.Scale, Position.Y.Offset + p26.Y.Offset);
    p25.shadowViewportFrame = v27;

    return v27;
end;

function u1.SetViewportFrameModelAnimation(p28, p29) -- Line: 316
    -- upvalues: AnimationModule (copy)
    if not p29 then
        return;
    end;

    if p28.viewPortModelanimationName == p29 then
        return;
    end;

    p28:CloseViewportFrameModelAnimation();
    p28.viewPortModelanimationName = p29;

    if p28.showModel then
        AnimationModule.PlayAnimByModel(p28.showModel, p28.viewPortModelanimationName);
    end;
end;

function u1.CloseViewportFrameModelAnimation(p30) -- Line: 334
    -- upvalues: AnimationModule (copy)
    local viewPortModelanimationName = p30.viewPortModelanimationName;
    p30.viewPortModelanimationName = nil;

    if viewPortModelanimationName and p30.showModel then
        AnimationModule.StopAnimByModel(p30.showModel, viewPortModelanimationName);
    end;
end;

function u1.SetViewportFrameCameraFOV(p31, p32) -- Line: 347
    p31.viewportCamera.FieldOfView = p32;
end;

function u1.SetViewportFrameLight(p33, p34, p35, p36) -- Line: 358
    p33.viewportCamera.Ambient = p34;
    p33.viewportCamera.LightColor = p35;
    p33.viewportCamera.LightDirection = p36;
end;

return u1;