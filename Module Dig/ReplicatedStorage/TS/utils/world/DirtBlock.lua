-- Decompiled with Potassium's decompiler.

local TweenService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService;
local u1 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local v2 = {};

local function readNumber(p3, p4) -- Line: 28
    if type(p3) == "number" then
        return p3;
    end;

    return p4;
end;

local function randomUnit() -- Line: 32
    local v5 = math.random() * 2 - 1;
    local v6 = math.random() * 2 - 1;
    local v7 = math.random() * 2 - 1;

    return Vector3.new(v5, v6, v7).Unit;
end;

local function embedOf(p8) -- Line: 35
    local v9 = p8:GetAttribute("DirtEmbed");

    return type(v9) ~= "number" and 0.35 or v9;
end;

local function hostOf(p10) -- Line: 38
    local Parent = p10.Parent;

    if Parent ~= nil then
        Parent = Parent.Parent;
    end;

    if Parent == nil then
        return nil;
    end;

    if Parent:IsA("BasePart") then
        return Parent;
    end;

    if Parent:IsA("Model") then
        return Parent.PrimaryPart;
    end;

    return nil;
end;

local function capture(p11) -- Line: 55
    if p11:GetAttribute("DirtSize") ~= nil then
        return nil;
    end;

    p11:SetAttribute("DirtColor", p11.Color);
    p11:SetAttribute("DirtSize", p11.Size);
    p11:SetAttribute("DirtSeed", math.random() * 100);
    local Position = p11.Position;
    local UpVector = p11.CFrame.UpVector;
    local v12 = p11.Size.Y * 0.5;
    local v13 = p11:GetAttribute("DirtEmbed");
    local v14 = Position + UpVector * (v12 * (type(v13) ~= "number" and 0.35 or v13));
    local Parent = p11.Parent;

    if Parent ~= nil then
        Parent = Parent.Parent;
    end;

    if Parent == nil then
        Parent = nil;
    elseif not Parent:IsA("BasePart") then
        if Parent:IsA("Model") then
            Parent = Parent.PrimaryPart;
        else
            Parent = nil;
        end;
    end;

    if not Parent then
        p11:SetAttribute("DirtCFrame", p11.CFrame);
        p11:SetAttribute("DirtSurfacePoint", v14);

        return;
    end;

    p11:SetAttribute("DirtHostLocal", true);
    p11:SetAttribute("DirtCFrame", Parent.CFrame:ToObjectSpace(p11.CFrame));
    p11:SetAttribute("DirtSurfacePoint", Parent.CFrame:PointToObjectSpace(v14));
end;

local function anchorHost(p15) -- Line: 76
    if p15:GetAttribute("DirtHostLocal") ~= true then
        return nil;
    end;

    local Parent = p15.Parent;

    if Parent ~= nil then
        Parent = Parent.Parent;
    end;

    if Parent == nil then
        return nil;
    end;

    if Parent:IsA("BasePart") then
        return Parent;
    end;

    if Parent:IsA("Model") then
        return Parent.PrimaryPart;
    end;

    return nil;
end;

local function surfacePoint(p16) -- Line: 79
    local v17 = p16:GetAttribute("DirtSurfacePoint");

    if typeof(v17) ~= "Vector3" then
        return p16.Position;
    end;

    local v18;

    if p16:GetAttribute("DirtHostLocal") == true then
        v18 = p16.Parent;

        if v18 ~= nil then
            v18 = v18.Parent;
        end;

        if v18 == nil then
            v18 = nil;
        elseif not v18:IsA("BasePart") then
            if v18:IsA("Model") then
                v18 = v18.PrimaryPart;
            else
                v18 = nil;
            end;
        end;
    else
        v18 = nil;
    end;

    if v18 then
        return v18.CFrame:PointToWorldSpace(v17);
    end;

    return v17;
end;

local function origCFrame(p19) -- Line: 87
    local v20 = p19:GetAttribute("DirtCFrame");

    if typeof(v20) ~= "CFrame" then
        return p19.CFrame;
    end;

    local v21;

    if p19:GetAttribute("DirtHostLocal") == true then
        v21 = p19.Parent;

        if v21 ~= nil then
            v21 = v21.Parent;
        end;

        if v21 == nil then
            v21 = nil;
        elseif not v21:IsA("BasePart") then
            if v21:IsA("Model") then
                v21 = v21.PrimaryPart;
            else
                v21 = nil;
            end;
        end;
    else
        v21 = nil;
    end;

    if v21 then
        return v21.CFrame * v20;
    end;

    return v20;
end;

local function origColor(p22) -- Line: 95
    local v23 = p22:GetAttribute("DirtColor");

    if typeof(v23) == "Color3" then
        return v23;
    end;

    return p22.Color;
end;

function v2.isFacing(p24, p25) -- Line: 99
    return p24.CFrame.UpVector:Dot(p25) > 0.45;
end;

function v2.cleanliness(p26) -- Line: 103
    local v27 = p26:GetAttribute("Dissolve");
    local v28 = type(v27) ~= "number" and 0 or v27;

    return math.clamp(v28, 0, 1);
end;

function v2.dissolve(p29, p30, p31) -- Line: 107
    -- upvalues: capture (copy)
    capture(p29);
    p29.Anchored = true;
    local v32 = p29:GetAttribute("Dissolve");
    local v33 = type(v32) ~= "number" and 0 or v32;
    local v34 = math.clamp(v33, 0, 1) + p30;
    local v35 = math.min(v34, 1);
    p29:SetAttribute("Dissolve", v35);

    if v35 >= 1 then
        return true;
    end;

    local v36 = p29:GetAttribute("DirtCFrame");

    if typeof(v36) == "CFrame" then
        local v37;

        if p29:GetAttribute("DirtHostLocal") == true then
            v37 = p29.Parent;

            if v37 ~= nil then
                v37 = v37.Parent;
            end;

            if v37 == nil then
                v37 = nil;
            elseif not v37:IsA("BasePart") then
                if v37:IsA("Model") then
                    v37 = v37.PrimaryPart;
                else
                    v37 = nil;
                end;
            end;
        else
            v37 = nil;
        end;

        if v37 then
            v36 = v37.CFrame * v36;
        end;
    else
        v36 = p29.CFrame;
    end;

    local UpVector = v36.UpVector;
    local v38 = p29.Size.Y * 0.5;
    local v39 = p29:GetAttribute("DirtEmbed");
    local v40 = v38 * (type(v39) ~= "number" and 0.35 or v39);
    local v41 = p29:GetAttribute("DirtSurfacePoint");

    if typeof(v41) == "Vector3" then
        local v42;

        if p29:GetAttribute("DirtHostLocal") == true then
            v42 = p29.Parent;

            if v42 ~= nil then
                v42 = v42.Parent;
            end;

            if v42 == nil then
                v42 = nil;
            elseif not v42:IsA("BasePart") then
                if v42:IsA("Model") then
                    v42 = v42.PrimaryPart;
                else
                    v42 = nil;
                end;
            end;
        else
            v42 = nil;
        end;

        if v42 then
            v41 = v42.CFrame:PointToWorldSpace(v41);
        end;
    else
        v41 = p29.Position;
    end;

    local v43 = CFrame.new(v41 - UpVector * v40 + UpVector * (v35 * 0.12)) * v36.Rotation;
    local v44 = (v35 * 0.65 + 0.35) * p31;
    local v45 = os.clock() * 27;
    local v46 = p29:GetAttribute("DirtSeed");
    local v47 = v45 + (type(v46) ~= "number" and 0 or v46);
    p29.CFrame = v43 * CFrame.Angles(math.sin(v47) * 0.19198621771937624 * v44, 0, math.cos(v47 * 1.3) * 0.19198621771937624 * v44) + UpVector * (math.sin(v47 * 0.8) * 0.045 * v44);
    local v48 = p29:GetAttribute("DirtColor");

    if typeof(v48) ~= "Color3" then
        v48 = p29.Color;
    end;

    p29.Color = v48:Lerp(Color3.new(v48.R * 0.55, v48.G * 0.55, v48.B * 0.55), v35);
    p29.Reflectance = v35 * 0.16;

    return false;
end;

function v2.popOff(u49, p50) -- Line: 139
    -- upvalues: TweenService (copy), u1 (copy)
    for _, child in u49:GetChildren() do
        if child:IsA("WeldConstraint") or (child:IsA("Weld") or child:IsA("Motor6D")) then
            child:Destroy();
        end;
    end;

    local v51 = u49:GetAttribute("DirtCFrame");

    if typeof(v51) == "CFrame" then
        local v52;

        if u49:GetAttribute("DirtHostLocal") == true then
            v52 = u49.Parent;

            if v52 ~= nil then
                v52 = v52.Parent;
            end;

            if v52 == nil then
                v52 = nil;
            elseif not v52:IsA("BasePart") then
                if v52:IsA("Model") then
                    v52 = v52.PrimaryPart;
                else
                    v52 = nil;
                end;
            end;
        else
            v52 = nil;
        end;

        if v52 then
            v51 = v52.CFrame * v51;
        end;
    else
        v51 = u49.CFrame;
    end;

    local UpVector = v51.UpVector;
    local v53 = math.random() * 2 - 1;
    local v54 = math.random() * 2 - 1;
    local v55 = math.random() * 2 - 1;
    local v56 = UpVector + p50 * -0.5 + Vector3.new(v53, v54, v55).Unit * 0.4;

    if v56.Magnitude >= 0.001 then
        UpVector = v56.Unit;
    end;

    u49.Anchored = false;
    u49.CanCollide = false;
    u49.CanQuery = false;
    u49.CastShadow = false;
    u49.AssemblyLinearVelocity = UpVector * (17 + math.random() * 11);
    local v57 = math.random() * 2 - 1;
    local v58 = math.random() * 2 - 1;
    local v59 = math.random() * 2 - 1;
    u49.AssemblyAngularVelocity = Vector3.new(v57, v58, v59).Unit * 22;
    local v60 = TweenService:Create(u49, u1, {
        Transparency = 1
    });
    v60.Completed:Connect(function() -- Line: 161
        -- upvalues: u49 (copy)
        return u49:Destroy();
    end);
    v60:Play();
end;

return {
    DirtBlock = v2
};