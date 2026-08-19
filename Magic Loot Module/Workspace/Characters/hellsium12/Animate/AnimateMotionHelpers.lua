-- Decompiled with Potassium's decompiler.

return {
    create = function(p1) -- Line: 35, Name: create
        local character = p1.character;
        local hrp = p1.hrp;
        local humanoid = p1.humanoid;
        local setting = p1.setting;
        local userAnimateScaleRun = p1.userAnimateScaleRun;
        local u2 = "Forward";
        local u3 = setting.DIR_HYSTERESIS or 10;

        return {
            getRigScale = function() -- Line: 49, Name: getRigScale
                -- upvalues: userAnimateScaleRun (copy), character (copy)
                return not userAnimateScaleRun and 1 or character:GetScale();
            end,

            getRunAnimationSpeed = function(p4, p5) -- Line: 62, Name: getRunAnimationSpeed
                -- upvalues: userAnimateScaleRun (copy), character (copy), setting (copy)
                local v6 = 1;
                local v7 = not userAnimateScaleRun and 1 or character:GetScale();

                if p5 == "Walk" then
                    return p4 / setting.WALK_ACTION_SCALE_SPEED / v7;
                end;

                if p5 == "Run" then
                    return p4 / setting.RUN_ACTION_SCALE_SPEED / v7;
                end;

                if p5 == "Climb" then
                    v6 = p4 / setting.CLIMB_ACTION_SCALE_SPEED / v7;
                end;

                return v6;
            end,

            getRelativeMoveDirection = function() -- Line: 79, Name: getRelativeMoveDirection
                -- upvalues: hrp (copy), humanoid (copy), u2 (ref), u3 (copy)
                local LookVector = hrp:GetPivot().LookVector;
                local MoveDirection = humanoid.MoveDirection;
                local v8 = Vector3.new(MoveDirection.X, 0, MoveDirection.Z);

                if v8.Magnitude < 0.01 then
                    return u2;
                end;

                local v9 = Vector3.new(LookVector.X, 0, LookVector.Z);

                if v8.Magnitude > 0 then
                    v8 = v8.Unit or v8;
                end;

                if v9.Magnitude > 0 then
                    v9 = v9.Unit or v9;
                end;

                local v10 = v8:Dot(v9);
                local v11 = math.clamp(v10, -1, 1);
                local v12 = math.acos(v11);
                local v13 = v8:Cross(v9);
                local v14 = math.deg(v12);

                if v13.Y < 0 then
                    v14 = -v14;
                end;

                local v15 = u3;
                local v16 = u2;

                if u2 == "Forward" then
                    v16 = 30 + v15 <= v14 and "Right" or (v14 <= -30 - v15 and "Left" or ((150 - v15 <= v14 or v14 < -150 + v15) and "Back" or v16));
                elseif u2 == "Right" then
                    v16 = v14 < 30 - v15 and "Forward" or (150 - v15 <= v14 and "Back" or v16);
                elseif u2 == "Left" then
                    v16 = -30 + v15 < v14 and "Forward" or (v14 <= -150 + v15 and "Back" or v16);
                elseif u2 == "Back" then
                    v16 = -30 + v15 <= v14 and v14 < 30 - v15 and "Forward" or (v14 < 150 - v15 and v14 >= 30 and "Right" or (-150 + v15 < v14 and v14 <= -30 and "Left" or v16));
                end;

                u2 = v16;

                return v16;
            end
        };
    end
};