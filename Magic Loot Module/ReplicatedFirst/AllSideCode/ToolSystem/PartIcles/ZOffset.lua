-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 6
    function p1.ApplyZOffset(p2, p3, p4) -- Line: 10
        local ZOffset = p3.ZOffset;

        if not ZOffset or ZOffset == 0 then
            return;
        end;

        if not p4 then
            return;
        end;

        if not (p3.VisualPart and p3.VisualPart.Parent) then
            return;
        end;

        local Type = p3.Type;

        if Type ~= "Part" and (Type ~= "Model" and Type ~= "Attachment") then
            return;
        end;

        local v5 = Type == "Model";
        local v6 = p3._postUpdateCF or (v5 and p3.VisualPart:GetPivot() or p3.VisualPart.CFrame);
        local v7;

        if Type == "Attachment" then
            v7 = p3.VisualPart.Parent;

            if v7 and v7:IsA("BasePart") then
                v6 = v7.CFrame * v6;
            else
                v7 = nil;
            end;
        else
            v7 = nil;
        end;

        local Position = v6.Position;
        local v8 = p4 - Position;
        local Magnitude = v8.Magnitude;

        if Magnitude < 0.001 then
            return;
        end;

        local v9 = CFrame.new(Position + v8 / Magnitude * ZOffset) * (v6 - Position);

        if v7 then
            v9 = v7.CFrame:ToObjectSpace(v9);
        end;

        if v5 then
            p3.VisualPart:PivotTo(v9);

            return;
        end;

        p3.VisualPart.CFrame = v9;
    end;
end;