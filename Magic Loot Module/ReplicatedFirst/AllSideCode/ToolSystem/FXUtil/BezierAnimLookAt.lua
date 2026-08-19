-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local _ = Random;
local BezierUtil = require(script.Parent.BezierUtil);
local v32 = {
    LinearBezierCurvesLookAt = function(u1, p2, u3, u4, u5, u6) -- Line: 32, Name: LinearBezierCurvesLookAt
        -- upvalues: RunService (copy), BezierUtil (copy), Debris (copy)
        local Vector3Value = Instance.new("Vector3Value");
        Vector3Value.Parent = u3;
        Vector3Value.Value = Vector3.new(0, 0, 0);

        if typeof(u4) ~= "Vector3" then
            u4 = u4.Position;
        end;

        if typeof(u5) ~= "Vector3" then
            u5 = u5.Position;
        end;

        local u7 = 0;
        local u8 = 1 / p2;
        local u9 = 0;
        local u10 = nil;
        u10 = RunService.Heartbeat:Connect(function(p11) -- Line: 50
            -- upvalues: u9 (ref), u7 (ref), u8 (copy), u1 (copy), Vector3Value (copy), BezierUtil (ref), u4 (ref), u5 (ref), u3 (copy), u6 (copy), u10 (ref), Debris (ref)
            u9 = u9 + p11;

            if u9 < u7 * u8 then
                return;
            end;

            if u9 >= u7 * u8 then
                u7 = u7 + 1;
                Vector3Value.Value = BezierUtil.Lerp(u4, u5, u7 / u1);
                u3.CFrame = CFrame.lookAt(u3.Position, Vector3Value.Value, Vector3.new(0, 1, 0)) * u6;
                u3.Position = Vector3Value.Value;
            end;

            if u1 <= u7 then
                u10:Disconnect();
                u10 = nil;
                Debris:AddItem(Vector3Value, task.wait());
            end;
        end);
    end,

    QuadraticBezierCurvesLookAt = function(u12, p13, u14, u15, u16, u17, u18, u19, p20, p21) -- Line: 89, Name: QuadraticBezierCurvesLookAt
        -- upvalues: RunService (copy), TweenService (copy), BezierUtil (copy), Debris (copy)
        local Vector3Value = Instance.new("Vector3Value");
        Vector3Value.Parent = u14;
        Vector3Value.Value = Vector3.new(0, 0, 0);

        if typeof(u15) ~= "Vector3" then
            u15 = u15.Position;
        end;

        if typeof(u16) ~= "Vector3" then
            u16 = u16.Position;
        end;

        if typeof(u17) ~= "Vector3" then
            u17 = u17.Position;
        end;

        local u22 = p20 or Enum.EasingStyle.Linear;
        local u23 = p21 or Enum.EasingDirection.In;
        local u24 = 0;
        local u25 = 1 / p13;
        local u26 = 0;
        local u27 = nil;
        u27 = RunService.Heartbeat:Connect(function(p28) -- Line: 114
            -- upvalues: u26 (ref), u24 (ref), u25 (copy), u12 (copy), TweenService (ref), u22 (ref), u23 (ref), BezierUtil (ref), u15 (ref), u16 (ref), u17 (ref), Vector3Value (copy), u14 (copy), u18 (copy), u19 (copy), u27 (ref), Debris (ref)
            u26 = u26 + p28;

            if u26 < u24 * u25 then
                return;
            end;

            if u26 >= u24 * u25 then
                u24 = u24 + 1;
                local v29 = TweenService:GetValue(u24 / u12, u22, u23);
                local v30 = BezierUtil.Lerp(u15, u16, v29);
                local v31 = BezierUtil.Lerp(u16, u17, v29);
                Vector3Value.Value = BezierUtil.Lerp(v30, v31, v29);
                u14.CFrame = CFrame.lookAt(u14.CFrame.Position, Vector3Value.Value, u14.CFrame.UpVector) * u18;
                u14.CFrame = u14.CFrame.Rotation + Vector3Value.Value;
            end;

            if u12 < u24 then
                if u19 then
                    u19();
                end;

                u27:Disconnect();
                u27 = nil;
                Debris:AddItem(Vector3Value, task.wait());
            end;
        end);
    end
};

local function _entiretyScale(p33, p34, p35, p36, p37) -- Line: 155
    local v38 = (1 - (p37 - p34.Position).Magnitude / (p37 - p36).Magnitude) * p35;
    local OriSize = p33:FindFirstChild("OriSize");

    if not OriSize then
        OriSize = Instance.new("Vector3Value", p33);
        OriSize.Name = "OriSize";
        OriSize.Value = p33.Size;
    end;

    p33.Size = OriSize.Value * v38;
end;

function v32.QuadraticBezierCurvesScaleChangeLookAt(u39, p40, u41, u42, u43, u44, u45, u46, p47) -- Line: 182
    -- upvalues: RunService (copy), BezierUtil (copy), _entiretyScale (copy), Debris (copy)
    local Vector3Value = Instance.new("Vector3Value");
    Vector3Value.Parent = u41;
    Vector3Value.Value = Vector3.new(0, 0, 0);

    if typeof(u42) ~= "Vector3" then
        u42 = u42.Position;
    end;

    if typeof(u43) ~= "Vector3" then
        u43 = u43.Position;
    end;

    if typeof(u44) ~= "Vector3" then
        u44 = u44.Position;
    end;

    local u48 = 0;
    local u49 = 1 / p40;
    local u50 = 0;
    local u51 = nil;
    u51 = RunService.Heartbeat:Connect(function(p52) -- Line: 204
        -- upvalues: u50 (ref), u48 (ref), u49 (copy), u39 (copy), BezierUtil (ref), u42 (ref), u43 (ref), u44 (ref), Vector3Value (copy), u41 (copy), _entiretyScale (ref), u45 (copy), u46 (copy), u51 (ref), Debris (ref)
        u50 = u50 + p52;

        if u50 < u48 * u49 then
            return;
        end;

        if u50 >= u48 * u49 then
            u48 = u48 + 1;
            local v53 = u48 / u39;
            local v54 = BezierUtil.Lerp(u42, u43, v53);
            local v55 = BezierUtil.Lerp(u43, u44, v53);
            Vector3Value.Value = BezierUtil.Lerp(v54, v55, v53);

            for _, descendant in pairs(u41:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local v56 = descendant:GetAttribute("Scale");

                    if v56 then
                        _entiretyScale(descendant, u41, v56, u42, u44);
                    end;
                end;
            end;

            u41.CFrame = CFrame.lookAt(u41.CFrame.Position, Vector3Value.Value, u41.CFrame.UpVector) * u45;
            u41.CFrame = u41.CFrame.Rotation + Vector3Value.Value;
        end;

        if u39 < u48 then
            if u46 then
                u46();
            end;

            u51:Disconnect();
            u51 = nil;
            Debris:AddItem(Vector3Value, task.wait());
        end;
    end);
end;

function v32.QuadraticBezierCurvesFrontLookAt(u57, p58, u59, u60, u61, u62, u63, u64) -- Line: 258
    -- upvalues: RunService (copy), BezierUtil (copy), Debris (copy)
    local Vector3Value = Instance.new("Vector3Value");
    Vector3Value.Parent = u59;
    Vector3Value.Value = Vector3.new(0, 0, 0);

    if typeof(u60) ~= "Vector3" then
        u60 = u60.Position;
    end;

    if typeof(u61) ~= "Vector3" then
        u61 = u61.Position;
    end;

    if typeof(u62) ~= "Vector3" then
        u62 = u62.Position;
    end;

    local u65 = 0;
    local u66 = 1 / p58;
    local u67 = 0;
    local u68 = nil;
    u68 = RunService.Heartbeat:Connect(function(p69) -- Line: 280
        -- upvalues: u67 (ref), u65 (ref), u66 (copy), u57 (copy), BezierUtil (ref), u60 (ref), u61 (ref), u62 (ref), Vector3Value (copy), u59 (copy), u63 (copy), u64 (copy), u68 (ref), Debris (ref)
        u67 = u67 + p69;

        if u67 < u65 * u66 then
            return;
        end;

        if u67 >= u65 * u66 then
            u65 = u65 + 1;
            local v70 = u65 / u57;
            local v71 = BezierUtil.Lerp(u60, u61, v70);
            local v72 = BezierUtil.Lerp(u61, u62, v70);
            Vector3Value.Value = BezierUtil.Lerp(v71, v72, v70);
            u59:PivotTo(CFrame.lookAt(u59:GetPivot().Position, Vector3Value.Value, Vector3.new(0, 1, 0)) * u63);
            u59:PivotTo(u59:GetPivot().Rotation + Vector3Value.Value);
        end;

        if u57 < u65 then
            if u64 then
                u64();
            end;

            u68:Disconnect();
            u68 = nil;
            Debris:AddItem(Vector3Value, task.wait());
        end;
    end);
end;

function v32.QuadraticBezierCurvesRotate(u73, p74, u75, u76, u77, u78, p79, u80, u81) -- Line: 330
    -- upvalues: RunService (copy), BezierUtil (copy), Debris (copy)
    local Vector3Value = Instance.new("Vector3Value");
    Vector3Value.Parent = u75;
    Vector3Value.Value = Vector3.new(0, 0, 0);

    if typeof(u76) ~= "Vector3" then
        u76 = u76.Position;
    end;

    if typeof(u77) ~= "Vector3" then
        u77 = u77.Position;
    end;

    if typeof(u78) ~= "Vector3" then
        u78 = u78.Position;
    end;

    if typeof(u81) ~= "Vector3" then
        u81 = typeof(u81) ~= "number" and Vector3.new(3600, 0, 0) or Vector3.new(u81, 0, 0);
    end;

    local u82 = 0;
    local u83 = 1 / p74;
    local u84 = 0;
    local u85 = nil;
    u85 = RunService.Heartbeat:Connect(function(p86) -- Line: 361
        -- upvalues: u84 (ref), u82 (ref), u83 (copy), u73 (copy), BezierUtil (ref), u76 (ref), u77 (ref), u78 (ref), Vector3Value (copy), u81 (ref), u75 (copy), u85 (ref), Debris (ref), u80 (copy)
        u84 = u84 + p86;

        if u84 < u82 * u83 then
            return;
        end;

        if u84 >= u82 * u83 then
            u82 = u82 + 1;
            local v87 = u82 / u73;
            local v88 = BezierUtil.Lerp(u76, u77, v87);
            local v89 = BezierUtil.Lerp(u77, u78, v87);
            Vector3Value.Value = BezierUtil.Lerp(v88, v89, v87);
            local v90 = CFrame.Angles(math.rad(u81.X * p86), math.rad(u81.Y * p86), (math.rad(u81.Z * p86)));

            if u75:IsA("Model") then
                u75:PivotTo(u75:GetPivot().Rotation + Vector3Value.Value);
                u75:PivotTo(u75:GetPivot():ToWorldSpace(v90));
            elseif u75:IsA("BasePart") then
                u75.CFrame = u75.CFrame.Rotation + Vector3Value.Value;
                u75.CFrame = u75.CFrame * v90;
            end;
        end;

        if u73 < u82 then
            u85:Disconnect();
            u85 = nil;
            Debris:AddItem(Vector3Value, task.wait());

            if u80 then
                u80();
            end;
        end;
    end);
end;

function v32.QuadraticBezierCurvesFollow(u91, p92, u93, u94, u95, u96, u97, u98, u99) -- Line: 403
    -- upvalues: RunService (copy), Debris (copy), BezierUtil (copy)
    local Vector3Value = Instance.new("Vector3Value");
    Vector3Value.Parent = u93;
    Vector3Value.Value = Vector3.new(0, 0, 0);

    if typeof(u94) ~= "Vector3" then
        u94 = u94.Position;
    end;

    if typeof(u95) ~= "Vector3" then
        u95 = u95.Position;
    end;

    if typeof(u96) ~= "Vector3" then
        u96 = u96.Position;
    end;

    if typeof(u97) ~= "Vector3" then
        u97 = u97.Position;
    end;

    local u100 = 0;
    local u101 = 1 / p92;
    local u102 = 0;
    local u103 = nil;
    u103 = RunService.Heartbeat:Connect(function(p104) -- Line: 430
        -- upvalues: u102 (ref), u100 (ref), u91 (copy), u99 (copy), u103 (ref), Debris (ref), Vector3Value (copy), u101 (copy), BezierUtil (ref), u94 (ref), u95 (ref), u96 (ref), u97 (ref), u93 (copy), u98 (copy)
        u102 = u102 + p104;

        if u91 <= u100 or not u99 then
            u103:Disconnect();
            u103 = nil;
            Debris:AddItem(Vector3Value, task.wait());
        end;

        if u102 < u100 * u101 then
            return;
        end;

        if u102 >= u100 * u101 then
            u100 = u100 + 1;
            local v105 = u100 / u91;
            local v106 = BezierUtil.Lerp(u94, u95, v105);
            local v107 = BezierUtil.Lerp(u95, u96, v105);
            local v108 = BezierUtil.Lerp(u96, u97, v105);
            local v109 = BezierUtil.Lerp(v106, v107, v105);
            local v110 = BezierUtil.Lerp(v107, v108, v105);
            Vector3Value.Value = BezierUtil.Lerp(v109, v110, v105);
            u93.CFrame = CFrame.lookAt(Vector3Value.Value + u99.Position - u98, Vector3Value.Value, Vector3.new(0, 1, 0));
        end;
    end);
end;

function v32.CubicBezierCurvesLookAt(u111, p112, u113, u114, u115, u116, u117, u118) -- Line: 469
    -- upvalues: RunService (copy), BezierUtil (copy), Debris (copy)
    local Vector3Value = Instance.new("Vector3Value");
    Vector3Value.Parent = u113;
    Vector3Value.Value = Vector3.new(0, 0, 0);

    if typeof(u114) ~= "Vector3" then
        u114 = u114.Position;
    end;

    if typeof(u115) ~= "Vector3" then
        u115 = u115.Position;
    end;

    if typeof(u116) ~= "Vector3" then
        u116 = u116.Position;
    end;

    if typeof(u117) ~= "Vector3" then
        u117 = u117.Position;
    end;

    local u119 = 0;
    local u120 = 1 / p112;
    local u121 = 0;
    local u122 = nil;
    u122 = RunService.Heartbeat:Connect(function(p123) -- Line: 497
        -- upvalues: u121 (ref), u119 (ref), u120 (copy), u111 (copy), BezierUtil (ref), u114 (ref), u115 (ref), u116 (ref), u117 (ref), Vector3Value (copy), u113 (copy), u118 (copy), u122 (ref), Debris (ref)
        u121 = u121 + p123;

        if u121 < u119 * u120 then
            return;
        end;

        if u121 >= u119 * u120 then
            u119 = u119 + 1;
            local v124 = u119 / u111;
            local v125 = BezierUtil.Lerp(u114, u115, v124);
            local v126 = BezierUtil.Lerp(u115, u116, v124);
            local v127 = BezierUtil.Lerp(u116, u117, v124);
            local v128 = BezierUtil.Lerp(v125, v126, v124);
            local v129 = BezierUtil.Lerp(v126, v127, v124);
            Vector3Value.Value = BezierUtil.Lerp(v128, v129, v124);
            u113.CFrame = CFrame.lookAt(u113.Position, Vector3Value.Value, Vector3.new(0, 1, 0)) * u118;
            u113.Position = Vector3Value.Value;
        end;

        if u111 < u119 then
            u122:Disconnect();
            u122 = nil;
            Debris:AddItem(Vector3Value, task.wait());
        end;
    end);
end;

function v32.QuadraticBezierCurvesCameraLookAt(u130, p131, u132, u133, u134, u135, u136, u137, u138) -- Line: 564
    -- upvalues: RunService (copy), BezierUtil (copy), Debris (copy)
    local Vector3Value = Instance.new("Vector3Value");
    Vector3Value.Parent = u132;
    Vector3Value.Value = Vector3.new(0, 0, 0);

    if typeof(u133) ~= "Vector3" then
        u133 = u133.Position;
    end;

    if typeof(u134) ~= "Vector3" then
        u134 = u134.Position;
    end;

    if typeof(u135) ~= "Vector3" then
        u135 = u135.Position;
    end;

    local u139 = 0;
    local u140 = 1 / p131;
    local u141 = 0;
    local u142 = nil;
    u142 = RunService.Heartbeat:Connect(function(p143) -- Line: 586
        -- upvalues: u141 (ref), u139 (ref), u140 (copy), u137 (copy), u130 (copy), BezierUtil (ref), u133 (ref), u134 (ref), u135 (ref), Vector3Value (copy), u132 (copy), u136 (copy), u138 (copy), u142 (ref), Debris (ref)
        u141 = u141 + p143;

        if u141 < u139 * u140 then
            return;
        end;

        if u141 >= u139 * u140 and u137 then
            u139 = u139 + 1;
            local v144 = u139 / u130;
            local v145 = BezierUtil.Lerp(u133, u134, v144);
            local v146 = BezierUtil.Lerp(u134, u135, v144);
            Vector3Value.Value = BezierUtil.Lerp(v145, v146, v144);
            u132.CFrame = CFrame.lookAt(u132.CFrame.Position, u137.Position, Vector3.new(0, 1, 0)) * u136;
            u132.CFrame = u132.CFrame.Rotation + Vector3Value.Value;
        end;

        if u130 < u139 or not u137 then
            if u138 then
                u138();
            end;

            u142:Disconnect();
            u142 = nil;
            Debris:AddItem(Vector3Value, task.wait());
        end;
    end);
end;

return v32;