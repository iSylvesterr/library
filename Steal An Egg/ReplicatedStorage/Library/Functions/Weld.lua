-- Decompiled with Potassium's decompiler.

local u6 = {
    Create = function(p1, p2, p3) -- Line: 5, Name: Create
        if p1.Anchored or p2.Anchored then
            local Motor6D = Instance.new("Motor6D");
            Motor6D.Part0 = p1;
            Motor6D.Part1 = p2;
            Motor6D.C0 = p1.CFrame:Inverse() * p2.CFrame;
            Motor6D.Parent = p1;

            return Motor6D;
        end;

        if not p3 then
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = p1;
            WeldConstraint.Part1 = p2;
            WeldConstraint.Parent = p1;

            return WeldConstraint;
        end;

        local ManualWeld = Instance.new("ManualWeld");
        ManualWeld.Part0 = p1;
        ManualWeld.Part1 = p2;
        ManualWeld.C0 = p1.CFrame:Inverse() * p2.CFrame;
        ManualWeld.Parent = p1;

        return ManualWeld;
    end,

    SetC0 = function(p4, p5) -- Line: 35, Name: SetC0
        if p4:IsA("ManualWeld") then
            p4.C0 = p5;

            return;
        end;

        p4.C0 = p5;
    end
};

return setmetatable(u6, {
    __call = function(p7, ...) -- Line: 45, Name: __call
        -- upvalues: u6 (copy)
        return u6.Create(...);
    end
});