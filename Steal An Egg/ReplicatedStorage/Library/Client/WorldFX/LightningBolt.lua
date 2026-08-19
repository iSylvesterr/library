-- Decompiled with Potassium's decompiler.

local clock = os.clock;
local Workspace = game:GetService("Workspace");
local RunService = game:GetService("RunService");
local CurrentCamera = Workspace.CurrentCamera;
local Part = Instance.new("Part");
Part.TopSurface = Enum.SurfaceType.Smooth;
Part.BottomSurface = Enum.SurfaceType.Smooth;
Part.Anchored = true;
Part.CanCollide = false;
Part.Locked = true;
Part.CastShadow = false;
Part.Shape = "Cylinder";
Part.Name = "BoltPart";
Part.Material = Enum.Material.Neon;
Part.Color = Color3.new(1, 1, 1);
Part.Transparency = 1;
local u1 = require(script.PartCache).new(Part, 120);
u1:SetCacheParent(CurrentCamera);

local function cubicBezier(p2, p3, p4, p5, p6) -- Line: 21
    return p3 * (1 - p2) ^ 3 + p4 * 3 * p2 * (1 - p2) ^ 2 + p5 * 3 * (1 - p2) * p2 ^ 2 + p6 * p2 ^ 3;
end;

local function discretePulse(p7, p8, p9, p10, p11, p12, p13) -- Line: 25
    local v14 = p10 / (2 * p11) - math.abs((p7 - p8 * p9 + 0.5 * p10) / p11);

    return math.clamp(v14, p12, p13);
end;

local function extrudeCenter(p15) -- Line: 33
    return math.exp(-5000 * (p15 - 0.5) ^ 10);
end;

local u16 = CFrame.lookAt(Vector3.new(), Vector3.new(1, 0, 0)):Inverse();
local u17 = {};
local u18 = {
    __type = "LightningBolt"
};
u18.__index = u18;

function u18.new(p19, p20, p21) -- Line: 45
    -- upvalues: u18 (copy), cubicBezier (copy), discretePulse (copy), extrudeCenter (copy), u1 (copy), clock (copy), u17 (copy)
    local v22 = setmetatable({}, u18);
    v22.Enabled = true;
    v22.Attachment0 = p19;
    v22.Attachment1 = p20;
    v22.CurveSize0 = 0;
    v22.CurveSize1 = 0;
    v22.MinRadius = 0;
    v22.MaxRadius = 2.4;
    v22.Frequency = 1;
    v22.AnimationSpeed = 7;
    v22.Thickness = 1;
    v22.MinThicknessMultiplier = 0.2;
    v22.MaxThicknessMultiplier = 1;
    v22.MinTransparency = 0;
    v22.MaxTransparency = 1;
    v22.PulseSpeed = 2;
    v22.PulseLength = 1000000;
    v22.FadeLength = 0.2;
    v22.ContractFrom = 0.5;
    v22.Color = Color3.new(1, 1, 1);
    v22.ColorOffsetSpeed = 3;
    v22.SpaceCurveFunction = cubicBezier;
    v22.OpacityProfileFunction = discretePulse;
    v22.RadialProfileFunction = extrudeCenter;
    v22._Parts = {};

    for i = 1, p21 or 30 do
        v22._Parts[i] = u1:GetPart();
    end;

    v22._PartsHidden = false;
    v22._DisabledTransparency = 1;
    v22._StartT = clock();
    v22._RanNum = math.random() * 100;
    v22._RefIndex = #u17 + 1;
    v22._Destroyed = false;
    v22._DissipateConnection = nil;
    u17[v22._RefIndex] = v22;

    return v22;
end;

function u18.Destroy(p23) -- Line: 86
    -- upvalues: u17 (copy), u1 (copy)
    if p23._Destroyed then
        return;
    end;

    p23._Destroyed = true;
    u17[p23._RefIndex] = nil;
    local _DissipateConnection = p23._DissipateConnection;

    if _DissipateConnection then
        _DissipateConnection:Disconnect();
        p23._DissipateConnection = nil;
    end;

    for i = 1, #p23._Parts do
        u1:ReturnPart(p23._Parts[i]);
    end;

    table.clear(p23._Parts);
end;

function u18.DestroyDissipate(u24, p25, p26) -- Line: 106
    -- upvalues: clock (copy), RunService (copy)
    if u24._Destroyed or u24._DissipateConnection then
        return;
    end;

    local u27 = p25 or 0.2;
    local u28 = p26 or 0.5;
    local u29 = clock();
    local MinTransparency = u24.MinTransparency;
    local ContractFrom = u24.ContractFrom;
    local u30 = u24.ContractFrom + 1 / (#u24._Parts * u24.FadeLength);
    local MaxRadius = u24.MaxRadius;
    local MinThicknessMultiplier = u24.MinThicknessMultiplier;
    local u31 = nil;
    u31 = RunService.Heartbeat:Connect(function() -- Line: 120
        -- upvalues: u24 (copy), u31 (ref), clock (ref), u29 (copy), MinThicknessMultiplier (copy), u27 (ref), MinTransparency (copy), ContractFrom (copy), u30 (copy), MaxRadius (copy), u28 (ref)
        if u24._Destroyed then
            u31:Disconnect();
            u24._DissipateConnection = nil;

            return;
        end;

        local v32 = clock() - u29;
        u24.MinThicknessMultiplier = MinThicknessMultiplier + (-2 - MinThicknessMultiplier) * v32 / u27;

        if v32 < u27 * 0.4 then
            u24.MinTransparency = MinTransparency + (ContractFrom - MinTransparency) * (v32 / (u27 * 0.4));

            return;
        end;

        if v32 >= u27 then
            if clock() - u24._StartT < (u24.PulseLength + 1) / u24.PulseSpeed then
                u24:Destroy();
            end;

            u31:Disconnect();
            u24._DissipateConnection = nil;

            return;
        end;

        local v33 = (v32 - u27 * 0.4) / (u27 * 0.6);
        u24.MinTransparency = ContractFrom + (u30 - ContractFrom) * v33;
        u24.MaxRadius = MaxRadius * (1 + u28 * v33);
        u24.MinRadius = u24.MinRadius + (u24.MaxRadius - u24.MinRadius) * v33;
    end);
    u24._DissipateConnection = u31;
end;

function u18._UpdateGeometry(p34, p35, p36, p37, p38, p39, p40) -- Line: 148
    -- upvalues: u16 (copy)
    local v41 = p34.OpacityProfileFunction(p36, p37, p34.PulseSpeed, p34.PulseLength, p34.FadeLength, 1 - p34.MaxTransparency, 1 - p34.MinTransparency);
    local v42 = p34.Thickness * p38 * v41;
    local v43 = v42 > 0 and v41 and v41 or 0;
    local v44 = 1 - p34.ContractFrom;
    local v45 = #p34._Parts;

    if v44 < v43 then
        p35.Size = Vector3.new((p40 - p39).Magnitude, v42, v42);
        p35.CFrame = CFrame.lookAt((p39 + p40) * 0.5, p40) * u16;
        p35.Transparency = 1 - v43;

        return;
    end;

    if v44 - 1 / (v45 * p34.FadeLength) >= v43 then
        p35.Transparency = 1;

        return;
    end;

    local v46 = (1 - (v43 - (v44 - 1 / (v45 * p34.FadeLength))) * v45 * p34.FadeLength) * (p36 < p37 * p34.PulseSpeed - 0.5 * p34.PulseLength and 1 or -1);
    local v47 = (1 - math.abs(v46)) * (p40 - p39).Magnitude;
    p35.Size = Vector3.new(v47, v42, v42);
    p35.CFrame = CFrame.lookAt(p39 + (p40 - p39) * (math.max(0, v46) + (1 - math.abs(v46)) * 0.5), p40) * u16;
    p35.Transparency = 1 - v43;
end;

function u18._UpdateColor(p48, p49, p50, p51) -- Line: 183
    if typeof(p48.Color) == "Color3" then
        p49.Color = p48.Color;

        return;
    end;

    local v52 = (p48._RanNum + p50 - p51 * p48.ColorOffsetSpeed) % 1;
    local Keypoints = p48.Color.Keypoints;

    for i = 1, #Keypoints - 1 do
        if Keypoints[i].Time < v52 and v52 < Keypoints[i + 1].Time then
            p49.Color = Keypoints[i].Value:lerp(Keypoints[i + 1].Value, (v52 - Keypoints[i].Time) / (Keypoints[i + 1].Time - Keypoints[i].Time));

            return;
        end;
    end;
end;

function u18._Disable(p53) -- Line: 201
    p53.Enabled = false;

    for _, v in ipairs(p53._Parts) do
        v.Transparency = p53._DisabledTransparency;
    end;
end;

RunService.Heartbeat:Connect(function() -- Line: 208
    -- upvalues: u17 (copy), clock (copy)
    debug.profilebegin("LightningBolt");

    for _, v in pairs(u17) do
        if v.Enabled == true then
            v._PartsHidden = false;
            local MinRadius = v.MinRadius;
            local MaxRadius = v.MaxRadius;
            local _Parts = v._Parts;
            local v54 = #_Parts;
            local _RanNum = v._RanNum;
            local AnimationSpeed = v.AnimationSpeed;
            local Frequency = v.Frequency;
            local MinThicknessMultiplier = v.MinThicknessMultiplier;
            local MaxThicknessMultiplier = v.MaxThicknessMultiplier;
            local v55 = clock() - v._StartT;
            local SpaceCurveFunction = v.SpaceCurveFunction;
            local RadialProfileFunction = v.RadialProfileFunction;
            local v56 = (v.PulseLength + 1) / v.PulseSpeed;
            local Attachment0 = v.Attachment0;
            local Attachment1 = v.Attachment1;
            local WorldPosition = Attachment0.WorldPosition;
            local v57 = Attachment0.WorldPosition + Attachment0.WorldAxis * v.CurveSize0;
            local v58 = Attachment1.WorldPosition - Attachment1.WorldAxis * v.CurveSize1;
            local WorldPosition2 = Attachment1.WorldPosition;
            local v59 = SpaceCurveFunction(0, WorldPosition, v57, v58, WorldPosition2);

            if v55 < v56 then
                local v60 = v59;

                for i = 1, v54 do
                    local v61 = _Parts[i];
                    local v62 = i / v54;
                    local v63 = AnimationSpeed * -v55 + Frequency * 10 * v62 - 0.2 + _RanNum * 4;
                    local v64 = 5 * (AnimationSpeed * 0.01 * -v55 / 10 + Frequency * v62) + _RanNum * 4;
                    local v65 = 0.6283185307179586 * (math.noise(5 * v63, 1.5, v64) + 0.5) + 5.654866776461628 * (math.noise(0.5 * v63, 1.5, 0.1 * v64) + 0.5);
                    local v66 = (MinRadius + (MaxRadius - MinRadius) * (math.noise(3.4, v64, v63) + 0.5)) * RadialProfileFunction(v62);
                    local v67 = MinThicknessMultiplier + (MaxThicknessMultiplier - MinThicknessMultiplier) * (math.noise(2.3, v64, v63) + 0.5);
                    local v68 = SpaceCurveFunction(v62, WorldPosition, v57, v58, WorldPosition2);
                    local v69;

                    if i == v54 then
                        v69 = v68;
                    else
                        local v70 = CFrame.new(v60, v68) * CFrame.Angles(0, 0, v65);
                        local Angles = CFrame.Angles;
                        local v71 = 6.123233995736766e-17 + 0.9999999999999999 * (math.noise(v64, v63, 2.7) + 0.5);
                        local v72 = math.clamp(v71, -1, 1);
                        v69 = (v70 * Angles(math.acos(v72), 0, 0) * CFrame.new(0, 0, -v66)).Position or v68;
                    end;

                    v:_UpdateGeometry(v61, v62, v55, v67, v59, v69);
                    v:_UpdateColor(v61, v62, v55);
                    v60 = v68;
                    v59 = v69;
                end;
            else
                v:Destroy();
            end;
        elseif v._PartsHidden == false then
            v._PartsHidden = true;
            v:_Disable();
        end;
    end;

    debug.profileend();
end);

return u18;