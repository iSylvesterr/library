-- Decompiled with Potassium's decompiler.

local PartConstants = require(script.Parent.PartConstants);

return function(p1) -- Line: 10
    -- upvalues: PartConstants (copy)
    function p1.ReapplyLink(p2, p3) -- Line: 15
        -- upvalues: PartConstants (ref)
        local Link = p3.Link;

        if not Link then
            return;
        end;

        if not Link.Parent then
            p3.Link = nil;

            return;
        end;

        local _localWorldCF = p3._localWorldCF;

        if not _localWorldCF then
            return;
        end;

        if not (p3.VisualPart and p3.VisualPart.Parent) then
            return;
        end;

        local Type = p3.Type;

        if Type ~= "Part" and (Type ~= "Model" and Type ~= "Attachment") then
            return;
        end;

        if Type == "Attachment" then
            local Parent = p3.VisualPart.Parent;

            if not Parent then
                return;
            end;

            local v4 = p3.LinkMode == "RigidLocal" and (p3._rigidLocalParentCF or CFrame.new()) or PartConstants.resolveLinkCFrame(Link);
            local v5 = (Parent:IsA("BasePart") and Parent.CFrame or CFrame.new()):ToObjectSpace(v4);

            if p3.LinkMode == "Follow" or p3.LinkMode == "Pivot" then
                v5 = CFrame.new(v5.Position);
            end;

            p3.VisualPart.CFrame = v5 * _localWorldCF;

            return;
        end;

        local v6 = p3.LinkMode == "RigidLocal" and (p3._rigidLocalParentCF or CFrame.new()) or PartConstants.resolveLinkCFrame(Link);
        local Position = v6.Position;
        local LinkMode = p3.LinkMode;
        local v7;

        if LinkMode == "WeldWithoutRotation" then
            local v8 = v6:VectorToWorldSpace(_localWorldCF.Position);
            local v9 = _localWorldCF - _localWorldCF.Position;
            v7 = CFrame.new(Position + v8) * v9;
        elseif LinkMode == "Follow" or LinkMode == "Pivot" then
            v7 = CFrame.new(Position) * _localWorldCF;
        else
            v7 = v6 * _localWorldCF;
        end;

        if Type == "Model" then
            p3.VisualPart:PivotTo(v7);

            return;
        end;

        p3.VisualPart.CFrame = v7;
    end;
end;