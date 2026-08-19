-- Decompiled with Potassium's decompiler.

return {
    SetTransparency = function(p1, p2, p3) -- Line: 10, Name: SetTransparency
        local function setTransparency(p4, p5) -- Line: 12
            if not p4:IsA("BasePart") then
                return;
            end;

            p4.Transparency = p5;
        end;

        if p1:CheckIfPVInstance(p2) then
            if p2:IsA("BasePart") and p2:IsA("BasePart") then
                p2.Transparency = p3;
            end;

            for _, descendant in p2:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Transparency = p3;
                end;

                if descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
                    descendant.Enabled = p3 == 0;
                end;
            end;
        end;
    end,

    GetCFrame = function(p6, p7) -- Line: 31, Name: GetCFrame
        if p6:CheckIfPVInstance(p7) then
            if p7:IsA("BasePart") then
                return p7.CFrame;
            end;

            if p7:IsA("Model") then
                return p7:GetBoundingBox();
            end;
        end;

        error("would have errored in PVInstanceUtl:CheckIfPVInstance() already");
    end,

    SetCFrame = function(p8, p9, p10) -- Line: 46, Name: SetCFrame
        if p8:CheckIfPVInstance(p9) then
            if p9:IsA("BasePart") then
                p9.CFrame = p10;

                return;
            end;

            if p9:IsA("Model") then
                assert(p9.PrimaryPart, "Models passed to PVInstanceUtl:SetCFrame() require a primary part");
                p9:PivotTo(p10);
            end;
        end;
    end,

    CheckIfPVInstance = function(p11, p12) -- Line: 59, Name: CheckIfPVInstance
        assert(p12, "PVInstance:CheckIfPVInstance(): Argument nil");
        local v13 = p12:IsA("PVInstance");
        local v14 = `PVInstanceUtl:GetCFrame() can only be passed a PVInstance (Model or BasePart), got {p12.ClassName}`;
        assert(v13, v14);

        return true;
    end
};