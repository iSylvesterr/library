-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);

local function evalColorSequence(p1, p2) -- Line: 66
    local v3 = p2 + 1;
    local v4 = {};

    for i = 0, 2 do
        for i2 = 1, #p1 do
            table.insert(v4, {
                Time = p1[i2].Time + i,
                Value = p1[i2].Value
            });
        end;
    end;

    for i = 1, #v4 - 1 do
        local v5 = v4[i];
        local v6 = v4[i + 1];

        if v5.Time <= v3 and v3 < v6.Time then
            local v7 = (v3 - v5.Time) / (v6.Time - v5.Time);

            return Color3.new((v6.Value.R - v5.Value.R) * v7 + v5.Value.R, (v6.Value.G - v5.Value.G) * v7 + v5.Value.G, (v6.Value.B - v5.Value.B) * v7 + v5.Value.B);
        end;
    end;
end;

local function evalNumberSequence(p8, p9) -- Line: 94
    local v10 = p9 + 1;
    local v11 = {};

    for i = 0, 2 do
        for i2 = 1, #p8 do
            table.insert(v11, {
                Time = p8[i2].Time + i,
                Value = p8[i2].Value
            });
        end;
    end;

    for i = 1, #v11 - 1 do
        local v12 = v11[i];
        local v13 = v11[i + 1];

        if v12.Time <= v10 and v10 < v13.Time then
            return v12.Value + (v13.Value - v12.Value) * ((v10 - v12.Time) / (v13.Time - v12.Time));
        end;
    end;
end;

local u14 = {};
u14.__index = u14;
u14.__class = "Gradient";

function u14.new(p15, p16, p17) -- Line: 126
    -- upvalues: RunService (copy), Constants (copy), u14 (copy)
    assert(p15, "UIInstance not provided");
    local v18 = p15:IsA("GuiObject") or p15:IsA("UIStroke");
    assert(v18, "UIInstance is not a GuiObject or UIStroke");
    assert(p16, "ColorSequence not provided");
    assert(p17, "TransparencySequence not provided");
    local v19 = typeof(p16) == "ColorSequence";
    assert(v19, "ColorSequence is not a ColorSequence");
    local v20 = typeof(p17) == "number" and true or typeof(p17) == "NumberSequence";
    assert(v20, "TransparencySequence is not a number or NumberSequence");
    assert(#p16.Keypoints <= 19, "ColorSequence has too many keypoints");

    if typeof(p17) == "NumberSequence" then
        assert(#p17.Keypoints <= 19, "TransparencySequence has too many keypoints");
    end;

    local u21 = {
        UIInstance = p15,
        Instance = p15:FindFirstChildWhichIsA("UIGradient") or Instance.new("UIGradient"),
        IsPaused = false,
        ColorSequenceTarget = p16,
        ColorSequence = p16,
        TrueColorSequence = nil,
        ColorSequenceBlendRate = 1,
        TransparencySequenceTarget = nil,
        TransparencySequence = nil,
        TrueTransparencySequence = nil,
        TransparencySequenceBlendRate = 1,
        Offset = 0,
        OffsetTarget = nil,
        OffsetSpeed = 0,
        OffsetSpeedTarget = 0,
        OffsetAcceleration = 1,
        TransparencyOffset = 0,
        TransparencyOffsetTarget = nil,
        TransparencyOffsetSpeed = 0,
        TransparencyOffsetSpeedTarget = 0,
        TransparencyOffsetAcceleration = 1,
        Rotation = 0,
        RotationSpeed = 0,
        RotationSpeedTarget = 0,
        RotationAcceleration = 0,
        RotationTarget = nil,
        Connection = nil,
        IsText = false,
        StepAccumulator = 0.05
    };

    if typeof(p17) == "number" then
        u21.TransparencySequenceTarget = NumberSequence.new({ NumberSequenceKeypoint.new(0, p17), NumberSequenceKeypoint.new(1, p17) });
    elseif typeof(p17) == "NumberSequence" then
        u21.TransparencySequenceTarget = p17;
    else
        warn("Weird type of data?");
    end;

    u21.TransparencySequence = u21.TransparencySequenceTarget;

    if p15:IsA("TextLabel") or (p15:IsA("TextBox") or p15:IsA("TextButton")) then
        u21.IsText = true;
    end;

    u21.Connection = RunService.Heartbeat:Connect(function(p22) -- Line: 203
        -- upvalues: u21 (copy), Constants (ref)
        if u21.IsPaused then
            return;
        end;

        if Constants.IS_MOBILE then
            local v23 = u21;
            v23.StepAccumulator = v23.StepAccumulator + p22;

            if u21.StepAccumulator < 0.05 then
                return;
            end;

            p22 = u21.StepAccumulator;
            u21.StepAccumulator = 0;
        end;

        debug.profilebegin("Gradient :: Update");

        if not u21.UIInstance or u21.UIInstance.Parent == nil then
            u21:Destroy();

            return;
        end;

        if u21.ColorSequenceBlendRate == 1 then
            u21.ColorSequence = u21.ColorSequenceTarget;
        else
            u21:EqualizeColorSequenceKeypoints();
        end;

        if u21.TransparencySequenceBlendRate == 1 then
            u21.TransparencySequence = u21.TransparencySequenceTarget;
        end;

        if u21.OffsetTarget then
            u21.Offset = u21.Offset + (u21.OffsetTarget - u21.Offset) * u21.OffsetAcceleration;
        else
            u21.OffsetSpeed = u21.OffsetSpeed + (u21.OffsetSpeedTarget - u21.OffsetSpeed) * u21.OffsetAcceleration * p22;
            local v24 = u21;
            v24.Offset = v24.Offset + u21.OffsetSpeed * p22;
        end;

        if u21.TransparencyOffsetTarget then
            u21.TransparencyOffset = u21.TransparencyOffset + (u21.TransparencyOffsetTarget - u21.TransparencyOffset) * u21.TransparencyOffsetAcceleration;
        else
            u21.TransparencyOffsetSpeed = u21.TransparencyOffsetSpeed + (u21.TransparencyOffsetSpeedTarget - u21.TransparencyOffsetSpeed) * u21.TransparencyOffsetAcceleration * p22;
            local v25 = u21;
            v25.TransparencyOffset = v25.TransparencyOffset + u21.TransparencyOffsetSpeed * p22;
        end;

        if u21.RotationTarget then
            u21.Rotation = u21.Rotation + (u21.RotationTarget - u21.Rotation) * u21.RotationAcceleration;
        else
            u21.RotationSpeed = u21.RotationSpeed + (u21.RotationSpeedTarget - u21.RotationSpeed) * u21.RotationAcceleration * p22;
            local v26 = u21;
            v26.Rotation = v26.Rotation + u21.RotationSpeed * p22;
        end;

        u21.Instance.Rotation = u21.Rotation;
        u21.Instance.Color = u21:CalculateTrueColorSequence();
        u21.Instance.Transparency = u21:CalculateTrueTransparencySequence();
        debug.profileend();
    end);
    u21.Instance.Parent = u21.UIInstance;

    return setmetatable(u21, u14);
end;

function u14.SetColorSequence(p27, p28, p29) -- Line: 275
    local v30 = typeof(p28) == "ColorSequence";
    assert(v30, "Sequence argument is nil or not a ColorSequence");
    p27.ColorSequenceBlendRate = p29 or 1;
    p27.ColorSequenceTarget = p28;

    return p27.ColorSequenceTarget;
end;

function u14.SetOffset(p31, p32, p33) -- Line: 284
    local v34 = typeof(p32) == "number";
    assert(v34, "Offset isn\'t a number");
    local v35 = typeof(p33) == "number";
    assert(v35, "Acceleration isn\'t a number");
    p31.OffsetTarget = p32;
    p31.OffsetSpeed = 0;
    p31.OffsetSpeedTarget = 0;
    p31.OffsetAcceleration = math.clamp(p33, 0, 1);
end;

function u14.SetOffsetSpeed(p36, p37, p38) -- Line: 296
    local v39 = typeof(p37) == "number";
    assert(v39, "Offset isn\'t a number");
    local v40 = typeof(p38) == "number";
    assert(v40, "Acceleration isn\'t a number");
    p36.OffsetSpeedTarget = p37;
    p36.OffsetTarget = nil;
    p36.OffsetAcceleration = math.clamp(p38, 0, 1);
end;

function u14.SetRotation(p41, p42, p43) -- Line: 307
    local v44 = typeof(p42) == "number";
    assert(v44, "Offset isn\'t a number");
    local v45 = typeof(p43) == "number";
    assert(v45, "Acceleration isn\'t a number");
    p41.RotationTarget = p42;
    p41.RotationSpeed = 0;
    p41.RotationSpeedTarget = 0;
    p41.RotationAcceleration = math.clamp(p43, 0, 1);
end;

function u14.SetRotationSpeed(p46, p47, p48) -- Line: 319
    local v49 = typeof(p47) == "number";
    assert(v49, "Offset isn\'t a number");
    local v50 = typeof(p48) == "number";
    assert(v50, "Acceleration isn\'t a number");
    p46.RotationSpeedTarget = p47;
    p46.RotationTarget = nil;
    p46.RotationAcceleration = math.clamp(p48, 0, 1);
end;

function u14.SetTransparencyOffset(p51, p52, p53) -- Line: 330
    local v54 = typeof(p52) == "number";
    assert(v54, "Offset isn\'t a number");
    local v55 = typeof(p53) == "number";
    assert(v55, "Acceleration isn\'t a number");
    p51.TransparencyOffsetTarget = p52;
    p51.TransparencyOffsetSpeed = 0;
    p51.TransparencyOffsetSpeedTarget = 0;
    p51.TransparencyOffsetAcceleration = math.clamp(p53, 0, 1);
end;

function u14.SetTransparencyOffsetSpeed(p56, p57, p58) -- Line: 342
    local v59 = typeof(p57) == "number";
    assert(v59, "Offset isn\'t a number");
    local v60 = typeof(p58) == "number";
    assert(v60, "Acceleration isn\'t a number");
    p56.TransparencyOffsetSpeedTarget = p57;
    p56.TransparencyOffsetTarget = nil;
    p56.TransparencyOffsetAcceleration = math.clamp(p58, 0, 1);
end;

function u14.SetTransparencySequence(p61, p62, p63) -- Line: 353
    assert(p62, "Transparency is nil");
    local v64 = typeof(p63) == "number";
    assert(v64, "Acceleration isn\'t a number");

    if typeof(p62) == "number" then
        p61.TransparencyTarget = NumberSequence.new({ NumberSequenceKeypoint.new(0, p62), NumberSequenceKeypoint.new(1, p62) });
    elseif typeof(p62) == "NumberSequence" then
        p61.TransparencyTarget = p62;
    else
        warn("Weird type of data?");
    end;

    p61.TransparencyAcceleration = math.clamp(p63, 0, 1);
end;

function u14.EqualizeColorSequenceKeypoints(p65) -- Line: 373
    -- upvalues: evalColorSequence (copy)
    local Keypoints = p65.ColorSequenceTarget.Keypoints;
    local Keypoints2 = p65.ColorSequence.Keypoints;
    local v66 = {};

    if #Keypoints == #Keypoints2 then
        for _, v in Keypoints do
            local v67 = evalColorSequence(Keypoints2, v.Time):Lerp(v.Value, p65.ColorSequenceBlendRate);
            local v68 = ColorSequenceKeypoint.new(v.Time, v67);
            table.insert(v66, v68);
        end;
    else
        for _, v in Keypoints do
            local v69 = ColorSequenceKeypoint.new(v.Time, evalColorSequence(Keypoints2, v.Time));
            table.insert(v66, v69);
        end;
    end;

    p65.ColorSequence = ColorSequence.new(v66);
end;

function u14.EqualizeTransparencySequenceKeypoints(p70) -- Line: 395
    -- upvalues: evalNumberSequence (copy)
    local Keypoints = p70.TransparencySequenceTarget.Keypoints;
    local Keypoints2 = p70.TransparencySequence.Keypoints;
    local v71 = {};

    if #Keypoints == #Keypoints2 then
        for _, v in Keypoints do
            local v72 = evalNumberSequence(Keypoints2, v.Time):Lerp(v.Value, p70.TransparencySequenceBlendRate);
            local v73 = NumberSequenceKeypoint.new(v.Time, v72);
            table.insert(v71, v73);
        end;
    else
        for _, v in Keypoints do
            local v74 = NumberSequenceKeypoint.new(v.Time, evalNumberSequence(Keypoints2, v.Time));
            table.insert(v71, v74);
        end;
    end;

    print(v71[1].Value, v71[2].Value, v71[3].Value, v71[4].Value, v71[5].Value);
    p70.TransparencySequence = NumberSequence.new(v71);
end;

function u14.CalculateTrueColorSequence(p75) -- Line: 424
    -- upvalues: evalColorSequence (copy)
    local v76 = 100;
    local v77 = 5;
    local v78 = {};

    for _, v in p75.ColorSequence.Keypoints do
        local v79 = ColorSequenceKeypoint.new((v.Time + p75.Offset) % 1, v.Value);

        if v79.Time <= v76 then
            v78[v77 - 1] = v79;
            v77 = v77 - 1;
            v76 = v79.Time;
        else
            v78[#v78 + 1] = v79;
        end;
    end;

    local v80 = {};

    for _, v in v78 do
        table.insert(v80, v);
    end;

    table.sort(v80, function(p81, p82) -- Line: 445
        return p81.Time < p82.Time;
    end);

    if v80[1].Time ~= 0 then
        local v83 = ColorSequenceKeypoint.new(0, evalColorSequence(v80, 0));
        table.insert(v80, 1, v83);
    end;

    if v80[#v80].Time ~= 1 then
        local v84 = ColorSequenceKeypoint.new(1, evalColorSequence(v80, 1));
        table.insert(v80, v84);
    end;

    p75.TrueColorSequence = ColorSequence.new(v80);

    return p75.TrueColorSequence;
end;

function u14.CalculateTrueTransparencySequence(p85) -- Line: 463
    -- upvalues: evalNumberSequence (copy)
    if #p85.TransparencySequenceTarget.Keypoints == 2 and p85.TransparencySequenceTarget.Keypoints[1].Value == p85.TransparencySequenceTarget.Keypoints[2].Value then
        p85.TrueTransparencySequence = p85.TransparencySequenceTarget;

        return p85.TrueTransparencySequence;
    end;

    local v86 = #p85.TransparencySequence.Keypoints + 1;
    local v87 = (1 / 0);
    local v88 = {};

    for _, v in p85.TransparencySequence.Keypoints do
        local v89 = v.Time + p85.TransparencyOffset;

        if v89 > 1 or v89 < 0 then
            v89 = v89 % 1;
        end;

        local v90 = NumberSequenceKeypoint.new(v89, v.Value);

        if v90.Time <= v87 then
            v88[v86 - 1] = v90;
            v86 = v86 - 1;
            v87 = v90.Time;
        else
            v88[#v88 + 1] = v90;
        end;
    end;

    local v91 = {};

    for _, v in v88 do
        table.insert(v91, v);
    end;

    table.sort(v91, function(p92, p93) -- Line: 495
        return p92.Time < p93.Time;
    end);

    if v91[1].Time ~= 0 then
        local v94 = NumberSequenceKeypoint.new(0, evalNumberSequence(v91, 0));
        table.insert(v91, 1, v94);
    end;

    if v91[#v91].Time ~= 1 then
        local v95 = evalNumberSequence(v91, 1);
        local v96 = NumberSequenceKeypoint.new(1, v95);
        table.insert(v91, v96);
    end;

    p85.TrueTransparencySequence = NumberSequence.new(v91);

    return p85.TrueTransparencySequence;
end;

function u14.Pause(p97) -- Line: 514
    p97.IsPaused = true;
end;

function u14.Resume(p98) -- Line: 518
    p98.IsPaused = false;
end;

function u14.Destroy(p99) -- Line: 522
    p99.Connection:Disconnect();

    if p99.Instance then
        p99.Instance:Destroy();
        p99.Instance = nil;
    end;
end;

return table.freeze(u14);