-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local Config = require(script.Parent.Config);
local v1 = {};

local function cubic(p2, p3, p4, p5, p6) -- Line: 29
    local v7 = 1 - p2;

    return v7 ^ 3 * p3 + v7 ^ 2 * 3 * p2 * p4 + v7 * 3 * p2 ^ 2 * p5 + p2 ^ 3 * p6;
end;

local function curveY(p8, p9, p10, p11, p12, p13, p14, p15, p16) -- Line: 34
    local v17 = 0;
    local v18 = 1;

    for _ = 1, 16 do
        local v19 = (v17 + v18) * 0.5;
        local v20 = 1 - v19;

        if v20 ^ 3 * p9 + v20 ^ 2 * 3 * v19 * p11 + v20 * 3 * v19 ^ 2 * p13 + v19 ^ 3 * p15 < p8 then
            v17 = v19;
        else
            v18 = v19;
        end;
    end;

    local v21 = (v17 + v18) * 0.5;
    local v22 = 1 - v21;

    return v22 ^ 3 * p10 + v22 ^ 2 * 3 * v21 * p12 + v22 * 3 * v21 ^ 2 * p14 + v21 ^ 3 * p16;
end;

local function basicCurve(p23) -- Line: 58
    -- upvalues: curveY (copy)
    local v24 = math.clamp(p23, 0, 1);

    if v24 <= 0.474 then
        return curveY(v24, 0, 0, 0.2, 0, 0.307, -0.003, 0.474, 0.56);
    end;

    return curveY(v24, 0.474, 0.56, 0.599, 0.981, 0.7, 1, 1, 1);
end;

local function arcCurve(p25) -- Line: 66
    -- upvalues: curveY (copy)
    return curveY(math.clamp(p25, 0, 1), 0, 0, 0.25, 0.6, 0.5, 1, 1, 1);
end;

local function settleCurve(p26) -- Line: 70
    -- upvalues: curveY (copy)
    return curveY(math.clamp(p26, 0, 1), 0, 0, 0.45, 0.05, 0.8, 0.4, 1, 1);
end;

local function destroyOrbs(p27) -- Line: 74
    for _, v in ipairs(p27) do
        v.Part:Destroy();
    end;
end;

function v1.Play(u28, u29) -- Line: 84
    -- upvalues: Asserts (copy), BBFromModelVisibleOnly (copy), Config (copy), RenderStepped (copy), basicCurve (copy), curveY (copy)
    Asserts.Model(u28);
    Asserts.Model(u29);
    local u30, v31 = BBFromModelVisibleOnly(u28);
    local u32 = u28:GetPivot();
    local u33 = u28:GetScale();
    local u34 = Config.AbsorptionSeconds / Config.OrbReferenceDuration;
    local v35 = math.max(1, v31.Magnitude / Config.OrbReferencePetMagnitude);
    local v36 = math.sqrt(v35);
    local v37 = Random.new(math.random(1, 1000000));
    local u38 = table.create(Config.OrbCount);

    for _ = 1, Config.OrbCount do
        local v39, v40, v41 = Config.OrbColor:ToHSV();
        local v42 = v39 + v37:NextNumber(-0.1, 0.1) * 0.3;
        local v43 = v41 - v37:NextNumber(0, 0.1);
        local v44 = v40 - v37:NextNumber(0, 0.6);
        local v45 = v37:NextNumber(0, 0.8) * u34;
        local v46 = (1.26 + v37:NextNumber(0, 0.8)) * u34;
        local v47 = v31 * 0.5;
        local v48 = v37:NextNumber(-v47.X, v47.X);
        local v49 = v37:NextNumber(-v47.Y, v47.Y);
        local v50 = u30:PointToWorldSpace((Vector3.new(v48, v49, v37:NextNumber(-v47.Z, v47.Z))));
        local v51 = Vector3.new(1, 1, 1) * v37:NextNumber(Config.OrbBaseSizeMin, Config.OrbBaseSizeMax) * v36;
        local Part = Instance.new("Part");
        Part.Name = "DnaStealOrb";
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Shape = Enum.PartType.Ball;
        Part.Size = Vector3.new(0, 0, 0);
        Part.Color = Color3.fromHSV(v42, v44, v43):Lerp(Color3.new(1, 1, 1), 0.3);
        Part.Parent = workspace;
        local v52 = {
            Part = Part,
            StartPosition = v50,
            Size = v51,
            SpawnTime = v45,
            EndTime = v46,
            RotationSpeed = v37:NextNumber(-3.141592653589793, 3.141592653589793)
        };
        table.insert(u38, v52);
    end;

    local CloneCaptureStartSeconds = Config.CloneCaptureStartSeconds;
    local u53 = Config.AbsorptionSeconds - CloneCaptureStartSeconds;
    assert(u53 > 0, "Clone capture must begin before absorption ends");
    RenderStepped(function(p54, p55) -- Line: 136
        -- upvalues: u28 (copy), u29 (copy), Config (ref), BBFromModelVisibleOnly (ref), CloneCaptureStartSeconds (copy), u53 (copy), basicCurve (ref), u33 (copy), u32 (copy), u38 (copy), u34 (copy), curveY (ref), u30 (copy)
        if u28.Parent == nil or u29.Parent == nil then
            return true;
        end;

        local v56 = p55 * Config.AbsorptionSeconds;
        local Position = BBFromModelVisibleOnly(u29).Position;
        local v57 = basicCurve((math.clamp((v56 - CloneCaptureStartSeconds) / u53, 0, 1)));
        u28:ScaleTo((math.max(Config.MinScale, u33 * (1 - v57))));
        u28:PivotTo(CFrame.new(u32.Position:Lerp(Position, v57)) * u32.Rotation * CFrame.Angles(1.5707963267948966 * v57, 0, 0));

        for _, v in ipairs(u38) do
            local v58 = (v56 - v.SpawnTime) / math.max(0.3 * u34, 0.001);
            local v59 = math.clamp(v58, 0, 1);
            local v60 = (v56 - v.SpawnTime) / math.max(v.EndTime - v.SpawnTime, 0.001);
            local v61 = math.clamp(v60, 0, 1);
            local v62 = basicCurve(v61);
            local v63 = curveY(math.clamp(v61, 0, 1), 0, 0, 0.45, 0.05, 0.8, 0.4, 1, 1);
            local v64 = u30.Position + (v.StartPosition - u30.Position) * math.lerp(1.4, 1, v59);
            local v65 = v64:Lerp(Position, v62);
            local v66 = curveY(math.clamp(v61, 0, 1), 0, 0, 0.25, 0.6, 0.5, 1, 1, 1);
            local v67 = v64:Lerp(v65, v62) + Vector3.new(0, 1, 0) * (v66 * 0.1 * (1 - v63));
            v.Part.CFrame = CFrame.Angles(0, v.RotationSpeed * v56, 0) + v67;
            v.Part.Size = v.Size * v59 * (1 - v61) * 1.9;
        end;

        return nil;
    end, Config.AbsorptionSeconds, true):Wait();

    for _, v in ipairs(u38) do
        v.Part:Destroy();
    end;

    if u28.Parent ~= nil then
        u28:Destroy();
    end;
end;

return v1;