-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
game:GetService("TweenService");
local BezierUtil = require(script.Parent.BezierUtil);

return {
    LinearBezierCurves = function(u1, p2, u3, u4, u5) -- Line: 25, Name: LinearBezierCurves
        -- upvalues: RunService (copy), BezierUtil (copy)
        if typeof(u4) ~= "Vector3" then
            u4 = u4.Position;
        end;

        if typeof(u5) ~= "Vector3" then
            u5 = u5.Position;
        end;

        local u6 = 0;
        local u7 = 1 / p2;
        local u8 = 0;
        local u9 = nil;
        u9 = RunService.Heartbeat:Connect(function(p10) -- Line: 39
            -- upvalues: u8 (ref), u6 (ref), u7 (copy), u1 (copy), BezierUtil (ref), u4 (ref), u5 (ref), u3 (copy), u9 (ref)
            u8 = u8 + p10;

            if u8 < u6 * u7 then
                return;
            end;

            if u8 >= u6 * u7 then
                u6 = u6 + 1;
                u3.Position = BezierUtil.Lerp(u4, u5, u6 / u1);
            end;

            if u1 <= u6 then
                u9:Disconnect();
                u9 = nil;
            end;
        end);
    end,

    QuadraticBezierCurves = function(u11, p12, u13, u14, u15, u16, u17) -- Line: 71, Name: QuadraticBezierCurves
        -- upvalues: RunService (copy), BezierUtil (copy)
        if typeof(u14) ~= "Vector3" then
            u14 = u14.Position;
        end;

        if typeof(u15) ~= "Vector3" then
            u15 = u15.Position;
        end;

        if typeof(u16) ~= "Vector3" then
            u16 = u16.Position;
        end;

        local u18 = 0;
        local u19 = 1 / p12;
        local u20 = 0;
        local u21 = nil;
        u21 = RunService.Heartbeat:Connect(function(p22) -- Line: 89
            -- upvalues: u20 (ref), u18 (ref), u19 (copy), u11 (copy), BezierUtil (ref), u14 (ref), u15 (ref), u16 (ref), u13 (copy), u21 (ref), u17 (copy)
            u20 = u20 + p22;

            if u20 < u18 * u19 then
                return;
            end;

            if u20 >= u18 * u19 then
                u18 = u20 / u19;
                local v23 = u18 / u11;
                local v24 = BezierUtil.Lerp(u14, u15, v23);
                local v25 = BezierUtil.Lerp(u15, u16, v23);
                local v26 = BezierUtil.Lerp(v24, v25, v23);
                u13:PivotTo(u13:GetPivot().Rotation + v26);
            end;

            if u11 <= u18 then
                u21:Disconnect();
                u21 = nil;

                if u17 then
                    u17();
                end;
            end;
        end);

        return u21;
    end,

    CubicBezierCurves = function(u27, p28, u29, u30, u31, u32, u33) -- Line: 130, Name: CubicBezierCurves
        -- upvalues: RunService (copy), BezierUtil (copy)
        if typeof(u30) ~= "Vector3" then
            u30 = u30.Position;
        end;

        if typeof(u31) ~= "Vector3" then
            u31 = u31.Position;
        end;

        if typeof(u32) ~= "Vector3" then
            u32 = u32.Position;
        end;

        if typeof(u33) ~= "Vector3" then
            u33 = u33.Position;
        end;

        local u34 = 0;
        local u35 = 1 / p28;
        local u36 = 0;
        local u37 = nil;
        u37 = RunService.Heartbeat:Connect(function(p38) -- Line: 152
            -- upvalues: u36 (ref), u34 (ref), u35 (copy), u27 (copy), BezierUtil (ref), u30 (ref), u31 (ref), u32 (ref), u33 (ref), u29 (copy), u37 (ref)
            u36 = u36 + p38;

            if u36 < u34 * u35 then
                return;
            end;

            if u36 >= u34 * u35 then
                u34 = u34 + 1;
                local v39 = u34 / u27;
                local v40 = BezierUtil.Lerp(u30, u31, v39);
                local v41 = BezierUtil.Lerp(u31, u32, v39);
                local v42 = BezierUtil.Lerp(u32, u33, v39);
                local v43 = BezierUtil.Lerp(v40, v41, v39);
                local v44 = BezierUtil.Lerp(v41, v42, v39);
                u29.Position = BezierUtil.Lerp(v43, v44, v39);
            end;

            if u27 <= u34 then
                u37:Disconnect();
                u37 = nil;
            end;
        end);
    end
};