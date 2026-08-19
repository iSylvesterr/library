-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 7
    function p1.ApplyOrientation(p2, p3, p4, p5) -- Line: 14
        local Orientation = p3.Orientation;

        if not Orientation or Orientation == "None" then
            return;
        end;

        if not (p3.VisualPart and p3.VisualPart.Parent) then
            return;
        end;

        local Type = p3.Type;

        if Type ~= "Part" and (Type ~= "Model" and Type ~= "Attachment") then
            return;
        end;

        local v6 = Type == "Model";
        local v7 = p3._postUpdateCF or (v6 and p3.VisualPart:GetPivot() or p3.VisualPart.CFrame);
        local v8;

        if Type == "Attachment" then
            v8 = p3.VisualPart.Parent;

            if v8 and v8:IsA("BasePart") then
                v7 = v8.CFrame * v7;
            else
                v8 = nil;
            end;
        else
            v8 = nil;
        end;

        local Position = v7.Position;
        local v9;

        if p3._lastOrientPos then
            v9 = (Position - p3._lastOrientPos) / math.max(p4, 0.0001);
        else
            v9 = p3.BaseDirection or Vector3.new(-0, -0, -1);
        end;

        p3._lastOrientPos = Position;
        local v10;

        if Orientation == "FacingCamera" then
            if not p5 then
                return;
            end;

            local v11 = p5 - Position;

            if v11.Magnitude < 0.001 then
                return;
            end;

            v10 = CFrame.lookAt(Vector3.new(0, 0, 0), v11.Unit);
        elseif Orientation == "FacingCameraWorldUp" then
            if not p5 then
                return;
            end;

            local v12 = p5 - Position;
            local v13 = Vector3.new(v12.X, 0, v12.Z);

            if v13.Magnitude < 0.001 then
                return;
            end;

            v10 = CFrame.lookAt(Vector3.new(0, 0, 0), v13.Unit, Vector3.new(0, 1, 0));
        elseif Orientation == "VelocityParallel" then
            if p3.VelocityVectored then
                return;
            end;

            if v9.Magnitude < 0.001 then
                return;
            end;

            local v14 = p5 and (p5 - Position or Vector3.new(0, 1, 0)) or Vector3.new(0, 1, 0);
            v10 = CFrame.lookAt(Vector3.new(0, 0, 0), v9.Unit, (v14.Magnitude < 0.001 and Vector3.new(0, 1, 0) or v14).Unit);
        else
            if Orientation ~= "VelocityPerpendicular" then
                if not p3._orientWarned then
                    p3._orientWarned = true;
                    warn("Part-Icles: unknown Orientation \'" .. tostring(p3.Orientation) .. "\' on emitted particle  -  falling back to identity.");
                end;

                return;
            end;

            if v9.Magnitude < 0.001 then
                return;
            end;

            local Unit = v9.Unit;
            local v15 = Unit:Cross(Vector3.new(0, 1, 0));

            if v15.Magnitude < 0.001 then
                v15 = Unit:Cross(Vector3.new(1, 0, 0));
            end;

            v10 = CFrame.lookAt(Vector3.new(0, 0, 0), v15.Unit, Unit);
        end;

        local v16 = CFrame.new(Position) * v10 * (v7 - Position);

        if v8 then
            v16 = v8.CFrame:ToObjectSpace(v16);
        end;

        if v6 then
            p3.VisualPart:PivotTo(v16);

            return;
        end;

        p3.VisualPart.CFrame = v16;
    end;
end;