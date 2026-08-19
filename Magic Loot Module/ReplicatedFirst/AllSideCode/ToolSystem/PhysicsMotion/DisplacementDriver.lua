-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local TweenService = UtilsSystem.TweenService;
local RunService = UtilsSystem.RunService;
local RayCast = UtilsSystem.RayCast;
local MotionResolve = require(script.Parent.MotionResolve);
local MotionRegistry = require(script.Parent.MotionRegistry);
local v1 = {};

local function _resolveGoalPosition(p2, p3, p4) -- Line: 30
    if typeof(p2.targetPosition) == "Vector3" then
        if p2.plane == "xyz" then
            return p2.targetPosition;
        end;

        return Vector3.new(p2.targetPosition.X, p3.Position.Y, p2.targetPosition.Z);
    end;

    local v5 = tonumber(p2.distance);

    if not v5 or (v5 <= 0 or p4.Magnitude < 0.0001) then
        return nil;
    end;

    local v6 = p4 * v5;

    if p2.plane == "xyz" then
        return p3.Position + v6;
    end;

    return Vector3.new(p3.Position.X + v6.X, p3.Position.Y, p3.Position.Z + v6.Z);
end;

local function _clipByCollision(p7, p8, p9) -- Line: 57
    -- upvalues: RayCast (copy)
    local v10 = p9 - p8;

    if v10.Magnitude < 0.0001 then
        return CFrame.new(p8), false;
    end;

    local v11 = RayCast.GetRayCastParams("All", {
        ignoreWater = true,
        instances = p7:GetDescendants()
    });
    local v12 = workspace:Raycast(p8, v10, v11);

    if not v12 then
        return CFrame.new(p9), false;
    end;

    local v13 = math.max((v12.Position - p8).Magnitude - 0.05, 0);

    return CFrame.new(p8 + v10.Unit * v13), true;
end;

function v1.start(u14, u15, u16, u17, u18, u19) -- Line: 90
    -- upvalues: MotionResolve (copy), _resolveGoalPosition (copy), MotionRegistry (copy), RunService (copy), TweenService (copy), _clipByCollision (copy)
    local u20 = _resolveGoalPosition(u14, u15, (MotionResolve.resolveWorldDirection(u14, u15)));
    local duration = u14.duration;

    if not u20 or duration <= 0 then
        if u19 then
            u19("invalid");
        end;

        return function() -- Line: 105
        end;
    end;

    local u21 = u15:GetPivot();
    local Position = u21.Position;
    local _ = CFrame.new(u20) * (u21 - u21.Position);
    local u22 = false;
    local u23 = false;
    local u24 = nil;
    local u25 = 0;

    local function finish(p26) -- Line: 117
        -- upvalues: u23 (ref), u24 (ref), MotionRegistry (ref), u15 (copy), u18 (copy), u17 (copy), u19 (copy)
        if u23 then
            return;
        end;

        u23 = true;

        if u24 then
            u24:Disconnect();
            u24 = nil;
        end;

        MotionRegistry.release(u15, u18, u17);

        if u19 then
            u19(p26);
        end;
    end;

    local function cancel() -- Line: 132
        -- upvalues: u22 (ref), u23 (ref), u24 (ref), MotionRegistry (ref), u15 (copy), u18 (copy), u17 (copy), u19 (copy)
        if u22 or u23 then
            return;
        end;

        u22 = true;

        if u23 then
            return;
        end;

        u23 = true;

        if u24 then
            u24:Disconnect();
            u24 = nil;
        end;

        MotionRegistry.release(u15, u18, u17);

        if u19 then
            u19("cancel");
        end;
    end;

    u24 = RunService.Heartbeat:Connect(function(p27) -- Line: 140
        -- upvalues: u22 (ref), u23 (ref), MotionRegistry (ref), u15 (copy), u18 (copy), u17 (copy), u16 (copy), u24 (ref), u19 (copy), u25 (ref), duration (copy), TweenService (ref), u14 (copy), Position (copy), u20 (copy), _clipByCollision (ref), u21 (copy)
        if u22 or u23 then
            return;
        end;

        if not (MotionRegistry.isGenCurrent(u15, u18, u17) and u16.Parent) then
            if not u22 then
                if u23 then
                    return;
                end;

                u22 = true;

                if u23 then
                    return;
                end;

                u23 = true;

                if u24 then
                    u24:Disconnect();
                    u24 = nil;
                end;

                MotionRegistry.release(u15, u18, u17);

                if u19 then
                    u19("cancel");
                end;
            end;

            return;
        end;

        u25 = u25 + p27;
        local v28 = math.clamp(u25 / duration, 0, 1);
        local v29 = Position:Lerp(u20, (TweenService:GetValue(v28, u14.easingStyle, u14.easingDirection)));
        local v30, v31 = _clipByCollision(u16, u15.Position, v29);
        u16:PivotTo(v30 * (u21 - u21.Position));

        if v31 or v28 >= 1 then
            local v32 = v31 and "blocked" or "complete";

            if u23 then
                return;
            end;

            u23 = true;

            if u24 then
                u24:Disconnect();
                u24 = nil;
            end;

            MotionRegistry.release(u15, u18, u17);

            if u19 then
                u19(v32);
            end;
        end;
    end);

    return cancel;
end;

return v1;