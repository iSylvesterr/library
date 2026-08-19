-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local u1 = Random;
local BezierUtil = require(script.Parent.BezierUtil);
local v31 = {
    GenerateBezierPoints = function(u2, u3, p4, p5) -- Line: 42, Name: GenerateBezierPoints
        -- upvalues: u1 (copy), TweenService (copy)
        if typeof(u2) ~= "Vector3" then
            if typeof(u2) ~= "Instance" then
                warn("BezierCurve.GenerateBezierPoints: 不支持的起点类型");

                return {};
            end;

            if u2:IsA("BasePart") or u2:IsA("Model") then
                u2 = u2:GetPivot().Position;
            else
                local v6;
                v6, u2 = pcall(function() -- Line: 60
                    -- upvalues: u2 (copy)
                    return u2.Position;
                end);

                if not v6 or typeof(u2) ~= "Vector3" then
                    warn("BezierCurve.GenerateBezierPoints: 无法从起点对象获取位置");

                    return {};
                end;
            end;
        end;

        if typeof(u3) ~= "Vector3" then
            if typeof(u3) ~= "Instance" then
                warn("BezierCurve.GenerateBezierPoints: 不支持的终点类型");

                return {};
            end;

            if u3:IsA("BasePart") or u3:IsA("Model") then
                u3 = u3:GetPivot().Position;
            else
                local v7;
                v7, u3 = pcall(function() -- Line: 82
                    -- upvalues: u3 (copy)
                    return u3.Position;
                end);

                if not v7 or typeof(u3) ~= "Vector3" then
                    warn("BezierCurve.GenerateBezierPoints: 无法从终点对象获取位置");

                    return {};
                end;
            end;
        end;

        local v8 = p4 < 0 and 0 or p4;
        local v9 = p5 or {};
        local v10 = v9.HeightOffset or 0;
        local v11 = v9.HeightOffsetRandom or 0;
        local v12 = v9.SideOffset or 0;
        local v13 = v9.SideOffsetRandom or 0;
        local OffsetDirection = v9.OffsetDirection;
        local v14 = v9.EasingStyle or Enum.EasingStyle.Quad;
        local v15 = v9.EasingDirection or Enum.EasingDirection.In;
        local v16 = v9.RandomOffset or 0;
        local RandomSeed = v9.RandomSeed;
        local v17;

        if RandomSeed then
            v17 = u1.new(RandomSeed);
        else
            v17 = u1.new();
        end;

        local v18 = u3 - u2;
        local v19 = v18.Magnitude > 0.001 and (v18.Unit or Vector3.new(0, 1, 0)) or Vector3.new(0, 1, 0);
        local v20 = v19:Cross(Vector3.new(0, 1, 0));

        if v20.Magnitude < 0.001 then
            v20 = v19:Cross(Vector3.new(1, 0, 0));
        end;

        local Unit = v20.Unit;

        if OffsetDirection then
            Unit = OffsetDirection.Unit;
        end;

        local v21 = {};
        table.insert(v21, u2);

        if v8 > 0 then
            for i = 1, v8 do
                local v22 = i / (v8 + 1);
                local v23 = TweenService:GetValue(v22, v14, v15);
                local v24 = v10 * v23;

                if v11 > 0 then
                    v24 = v24 + v17:NextNumber(-1, 1) * v11 * v23;
                end;

                local v25 = Vector3.new(0, v24, 0);
                local v26 = v12 * v23;

                if v13 > 0 then
                    v26 = v26 + v17:NextNumber(-1, 1) * v13 * v23;
                end;

                local v27;

                if v16 > 0 then
                    local v28 = v17:NextNumber(-1, 1) * v16;
                    local v29 = v17:NextNumber(-1, 1) * v16;
                    local v30 = v17:NextNumber(-1, 1) * v16;
                    v27 = Vector3.new(v28, v29, v30);
                else
                    v27 = Vector3.new(0, 0, 0);
                end;

                table.insert(v21, u2 + v18 * v22 + v25 + Unit * v26 + v27);
            end;
        end;

        table.insert(v21, u3);

        return v21;
    end
};

local function _calculateBezierPoint(p32, p33) -- Line: 214
    -- upvalues: BezierUtil (copy), _calculateBezierPoint (copy)
    if #p32 == 1 then
        return p32[1];
    end;

    local v34 = {};

    for i = 1, #p32 - 1 do
        local v35 = BezierUtil.Lerp(p32[i], p32[i + 1], p33);
        table.insert(v34, v35);
    end;

    return _calculateBezierPoint(v34, p33);
end;

function v31.MultiOrderBezierCurves(u36, u37) -- Line: 247
    -- upvalues: RunService (copy), TweenService (copy), _calculateBezierPoint (copy), Debris (copy)
    if not (u36 and (u36.Frame and (u36.FPS and (u36.Target and u36.Points)))) then
        warn("BezierCurve.MultiOrderBezierCurves: 缺少必需参数");

        return nil;
    end;

    if #u36.Points < 2 then
        warn("BezierCurve.MultiOrderBezierCurves: 至少需要2个控制点");

        return nil;
    end;

    local u38 = {};

    for i, v in ipairs(u36.Points) do
        if typeof(v) == "Vector3" then
            u38[i] = v;
        else
            if typeof(v) ~= "Instance" then
                warn("BezierCurve.MultiOrderBezierCurves: 不支持的点类型，索引:", i, "类型:", (typeof(v)));

                return nil;
            end;

            if v:IsA("BasePart") or v:IsA("Model") then
                u38[i] = v:GetPivot().Position;
            else
                local v39 = v:GetAttribute("Position");

                if v39 and typeof(v39) == "Vector3" then
                    u38[i] = v39;
                else
                    local success, result = pcall(function() -- Line: 286
                        -- upvalues: v (copy)
                        return v.Position;
                    end);

                    if not success or typeof(result) ~= "Vector3" then
                        warn("BezierCurve.MultiOrderBezierCurves: 无法从对象获取位置，索引:", i, "类型:", v.ClassName);

                        return nil;
                    end;

                    u38[i] = result;
                end;
            end;
        end;
    end;

    local u40 = u36.EasingStyle or Enum.EasingStyle.Linear;
    local u41 = u36.EasingDirection or Enum.EasingDirection.In;
    local u42 = u36.UseLookAt or false;
    local u43 = u36.CFrameOffset or CFrame.new();
    local v44 = typeof(u36.Target) == "Instance";
    local u45;

    if u42 then
        u45 = Instance.new("Vector3Value");

        if v44 then
            u45.Parent = u36.Target;
        end;

        u45.Value = Vector3.new(0, 0, 0);
    else
        u45 = nil;
    end;

    local function applyTargetTransform(p46, p47) -- Line: 325
        -- upvalues: u36 (copy), u43 (copy)
        local Target = u36.Target;

        if typeof(Target) ~= "Instance" then
            if type(Target) == "table" and type(Target.PivotTo) == "function" then
                local v48;

                if type(Target.GetPivot) == "function" then
                    v48 = Target:GetPivot();
                elseif Target.CFrame then
                    v48 = Target.CFrame;
                else
                    v48 = CFrame.new();
                end;

                if p47 then
                    Target:PivotTo(CFrame.lookAt(v48.Position, p47, Vector3.new(0, 1, 0)) * u43);
                    local v49;

                    if type(Target.GetPivot) == "function" then
                        v49 = Target:GetPivot();
                    else
                        v49 = Target.CFrame or v48;
                    end;

                    Target:PivotTo(v49.Rotation + p46);

                    return;
                end;

                Target:PivotTo(v48.Rotation * u43 + p46);
            end;

            return;
        end;

        if not Target:IsA("Model") then
            if Target:IsA("BasePart") then
                if p47 then
                    Target.CFrame = CFrame.lookAt(Target.CFrame.Position, p47, Target.CFrame.UpVector) * u43;
                    Target.CFrame = Target.CFrame.Rotation + p46;

                    return;
                end;

                Target.CFrame = Target.CFrame.Rotation * u43 + p46;
            end;

            return;
        end;

        if not p47 then
            Target:PivotTo(Target:GetPivot().Rotation * u43 + p46);

            return;
        end;

        Target:PivotTo(CFrame.lookAt(Target:GetPivot().Position, p47, Vector3.new(0, 1, 0)) * u43);
        Target:PivotTo(Target:GetPivot().Rotation + p46);
    end;

    local u50 = 0;
    local u51 = 1 / u36.FPS;
    local u52 = 0;
    local u53 = nil;
    u53 = RunService.Heartbeat:Connect(function(p54) -- Line: 365
        -- upvalues: u52 (ref), u50 (ref), u51 (copy), u36 (copy), TweenService (ref), u40 (copy), u41 (copy), _calculateBezierPoint (ref), u38 (copy), u42 (copy), u45 (ref), applyTargetTransform (copy), u37 (copy), u53 (ref), Debris (ref)
        u52 = u52 + p54;

        if u52 < u50 * u51 then
            return;
        end;

        if u52 >= u50 * u51 then
            u50 = u52 / u51;
            local v55 = u50 / u36.Frame;
            local v56 = _calculateBezierPoint(u38, (TweenService:GetValue(v55 > 1 and 1 or v55, u40, u41)));

            if u42 then
                u45.Value = v56;
                local LookAtTarget = u36.LookAtTarget;

                if typeof(LookAtTarget) ~= "Vector3" then
                    if typeof(LookAtTarget) == "Instance" then
                        if LookAtTarget:IsA("BasePart") or LookAtTarget:IsA("Model") then
                            LookAtTarget = LookAtTarget:GetPivot().Position;
                        else
                            local v57;
                            v57, LookAtTarget = pcall(function() -- Line: 404
                                -- upvalues: LookAtTarget (copy)
                                return LookAtTarget.Position;
                            end);

                            if v57 then
                                if typeof(LookAtTarget) ~= "Vector3" then
                                    LookAtTarget = v56;
                                end;
                            else
                                LookAtTarget = v56;
                            end;
                        end;
                    else
                        LookAtTarget = v56;
                    end;
                end;

                applyTargetTransform(v56, LookAtTarget);
            else
                applyTargetTransform(v56, nil);
            end;
        end;

        if u50 >= u36.Frame then
            if u37 then
                u37();
            end;

            if u53 then
                u53:Disconnect();
                u53 = nil;
            end;

            if u45 then
                Debris:AddItem(u45, task.wait());
            end;
        end;
    end);

    return u53;
end;

return v31;