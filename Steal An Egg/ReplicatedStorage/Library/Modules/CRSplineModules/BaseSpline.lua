-- Decompiled with Potassium's decompiler.

local u1 = TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local AddDebris = require(ReplicatedStorage.Library.Functions.AddDebris);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local FuncWrapper = require(ReplicatedStorage.Library.Modules.FuncWrapper);
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 78
    -- upvalues: u2 (copy)
    local v3 = setmetatable({}, u2);
    v3.LengthSegments = 1000;
    v3.Length = 0;
    local v4 = {
        UpdatedBindable = Instance.new("BindableEvent")
    };
    v3._Bindables = v4;
    v3.Updated = v4.UpdatedBindable.Event;
    v3._LengthCache = {};

    return v3;
end;

function u2.DebugDrawSpline(p5, p6, p7, p8, p9) -- Line: 100
    -- upvalues: AddDebris (copy)
    local v10 = p7 or workspace:WaitForChild("__DEBRIS");
    local v11 = p8 or Color3.new(1, 0, 0);
    local Folder = Instance.new("Folder");
    Folder.Name = "SplineDebug";
    Folder.Parent = v10;
    local v12 = {};

    for i = 0, p6 do
        table.insert(v12, p5:Position(i / p6));
    end;

    for _, v in ipairs(v12) do
        local Part = Instance.new("Part");
        Part.Shape = Enum.PartType.Ball;
        Part.Size = Vector3.new(0.2, 0.2, 0.2);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = v11;
        Part.CFrame = CFrame.new(v);
        Part.Parent = Folder;
    end;

    for i = 1, #v12 - 1 do
        local v13 = v12[i];
        local v14 = v12[i + 1];
        local Part = Instance.new("Part");
        Part.Size = Vector3.new(0.1, 0.1, (v13 - v14).Magnitude);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = v11;
        Part.CFrame = CFrame.lookAt((v13 + v14) / 2, v14) * CFrame.Angles(1.5707963267948966, 0, 0);
        Part.Parent = Folder;
    end;

    for _, v in p5.Points do
        if typeof(v) ~= "number" then
            local Part = Instance.new("Part");

            if typeof(v) == "Instance" then
                local v = v.Position or v;
            end;

            Part.Position = v;
            Part.Shape = Enum.PartType.Ball;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.Anchored = true;
            Part.Material = Enum.Material.Neon;
            Part.Color = Color3.fromRGB(255, 0, 0);
            Part.Parent = Folder;
        end;
    end;

    AddDebris(Folder, p9 or 60);

    return Folder;
end;

function u2.Position(p15, p16) -- Line: 169
    error("This is a prototype function, it should never be called from the BaseSpline!");
end;

function u2.Velocity(p17, p18) -- Line: 178
    error("This is a prototype function, it should never be called from the BaseSpline!");
end;

function u2.Acceleration(p19, p20) -- Line: 187
    error("This is a prototype function, it should never be called from the BaseSpline!");
end;

function u2.Normal(p21, p22) -- Line: 196
    local v23 = p21:Acceleration(p22);

    if typeof(v23) ~= "Vector3" then
        error("BaseSpline:Normal() only works with Vector3 constructed splines!");
    end;

    return v23.Unit;
end;

function u2.Curvature(p24, p25) -- Line: 209
    local v26 = p24:Velocity(p25);
    local v27 = p24:Acceleration(p25);

    if typeof(v26) ~= "Vector3" or typeof(v27) ~= "Vector3" then
        error("BaseSpline:Curvature() only works with Vector3 constructed splines!");
    end;

    return v26:Cross(v27).Magnitude / v26.Magnitude ^ 3;
end;

function u2._UpdateLength(p28) -- Line: 224
    local LengthSegments = p28.LengthSegments;
    local v29 = 1 / (LengthSegments + 1);
    local v30 = 0;
    local v31 = {};

    for i = 0, LengthSegments + 1 do
        local v32 = p28:Position(i * v29);
        local v33 = p28:Position((i + 1) * v29);
        table.insert(v31, {
            t = v29 * i,
            l = v30
        });

        if i == LengthSegments + 1 then
            break;
        end;

        v30 = v30 + (type(v33 - v32) == "number" and math.abs(v33 - v32) or (v33 - v32).Magnitude);
    end;

    p28.Length = v30;
    p28._LengthCache = v31;
    p28._Bindables.UpdatedBindable:Fire();
end;

function u2.ArcLength(p34, p35) -- Line: 254
    local _LengthCache = p34._LengthCache;

    if #_LengthCache == 0 then
        return 0;
    end;

    local v36 = nil;
    local v37 = nil;

    if p35 < 0 then
        v36 = _LengthCache[1];
        v37 = _LengthCache[2];
    elseif p35 > 1 then
        v36 = _LengthCache[#_LengthCache - 1];
        v37 = _LengthCache[#_LengthCache];
    else
        for i = 1, #_LengthCache - 1 do
            local v38 = _LengthCache[i];
            local v39 = _LengthCache[i + 1];

            if v38.t <= p35 and p35 <= v39.t then
                v37 = v39;
                v36 = v38;
                break;
            end;
        end;
    end;

    return v36.l + (v37.l - v36.l) * ((p35 - v36.t) / (v37.t - v36.t));
end;

function u2.TransformRelativeToLength(p40, p41) -- Line: 288
    local _LengthCache = p40._LengthCache;

    if #_LengthCache == 0 then
        return 0;
    end;

    local v42 = nil;
    local v43 = nil;
    local v44 = p40.Length * p41;

    if v44 < 0 then
        v42 = _LengthCache[0];
        v43 = _LengthCache[1];
    elseif _LengthCache[#_LengthCache].l < v44 then
        v42 = _LengthCache[#_LengthCache - 1];
        v43 = _LengthCache[#_LengthCache];
    else
        for i = 1, #_LengthCache - 1 do
            local v45 = _LengthCache[i];
            local v46 = _LengthCache[i + 1];

            if v45.l <= v44 and v44 <= v46.l then
                v43 = v46;
                v42 = v45;
                break;
            end;
        end;
    end;

    return v42.t + (v43.t - v42.t) * ((v44 - v42.l) / (v43.l - v42.l));
end;

local u47 = {};
u47.__index = u47;

function u47.new(p48, p49, p50, p51, p52) -- Line: 354
    -- upvalues: Asserts (copy), u47 (copy), FuncWrapper (copy), Trove (copy), u1 (copy), Signal (copy)
    Asserts.table(p49);
    Asserts.BasePart(p48);
    Asserts.optional.TweenInfo(p50);
    Asserts.optional.func(p51);
    Asserts.optional.boolean(p52);
    local v53 = setmetatable({}, u47);
    v53._funcWrapper = FuncWrapper.CreateWrapper(v53);
    v53._trove = Trove.new();
    v53.TweenInfo = p50 or u1;
    v53.Completed = v53._trove:Add(Signal.new());
    v53.Started = v53._trove:Add(Signal.new());
    v53.Playing = false;
    v53.Object = p48;
    v53.RenderCFrame = p48.CFrame;
    v53.AnimationCFrame = v53.RenderCFrame;
    v53.Destroyed = false;
    v53._spline = p49;
    v53._relativeToLength = p52;
    v53._transformFn = p51;
    v53._progress = 0;
    v53._nextParentCheck = 0;
    v53:_init();

    return v53;
end;

function u47.is(p54) -- Line: 394
    -- upvalues: u47 (copy)
    local v55;

    if type(p54) == "table" then
        v55 = getmetatable(p54) == u47;
    else
        v55 = false;
    end;

    return v55;
end;

function u47.GetProgress(p56) -- Line: 398
    return p56._progress;
end;

function u47.Step(p57, p58) -- Line: 402
    -- upvalues: TweenService (copy)
    p57._progress = p57._progress + p58;

    if not p57.Playing or (not p57.Object or p57.Destroyed) then
        return false;
    end;

    if p57._progress >= p57.TweenInfo.Time then
        p57.Playing = false;
        p57.Completed:Fire(Enum.PlaybackState.Completed);

        return false;
    end;

    if p57._nextParentCheck <= p57._progress then
        p57._nextParentCheck = p57._progress + 2.5 + 5 * math.random();

        if not p57.Object.Parent then
            return false;
        end;
    end;

    local v59 = TweenService:GetValue(p57._progress / p57.TweenInfo.Time, p57.TweenInfo.EasingStyle, p57.TweenInfo.EasingDirection);

    if p57._relativeToLength then
        v59 = p57._spline:TransformRelativeToLength(v59) or v59;
    end;

    local v60 = p57._spline:Position(v59);
    local Unit = p57._spline:Velocity(v59).Unit;
    local v61 = p57._spline:Normal(v59);
    local v62 = CFrame.lookAt(v60, v60 + Unit, v61);

    if p57._transformFn then
        v62 = p57._transformFn(v62, v59, {
            Position = v60,
            Direction = Unit,
            Normal = v61,
            Progress = p57._progress,
            Dt = p58
        });
    end;

    p57.AnimationCFrame = v62;

    return true;
end;

function u47.Play(p63) -- Line: 450
    assert(not p63.Destroyed, "Attempt to play a destroyed catmull rom spline tween wrapper");
    assert(p63.Object, "Tweened object missing or nil");
    assert(p63.Object.Parent, "Tweened object parent, is nil, tween operation declined");

    if p63.Playing then
        return;
    end;

    p63._progress = 0;
    p63.Playing = true;
    p63.Started:Fire();
end;

function u47.Cancel(p64) -- Line: 464
    if not p64.Playing then
        return;
    end;

    p64.Playing = false;
    p64.Completed:Fire(Enum.PlaybackState.Cancelled);
end;

function u47.Destroy(p65) -- Line: 472
    if p65.Destroyed then
        return;
    end;

    p65.Destroyed = true;
    p65:Cancel();
    p65._trove:Destroy();
end;

function u47._init(p66) -- Line: 482
    p66._trove:Connect(p66.Object.Destroying, p66._funcWrapper(p66.Destroy));
end;

function u2.CreateTween(p67, p68, p69, p70, p71) -- Line: 486
    -- upvalues: u47 (copy)
    return u47.new(p68, p67, p69, p71, p70);
end;

return u2;