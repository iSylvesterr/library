-- Decompiled with Potassium's decompiler.

return {
    retypeInstance = function(p1, p2) -- Line: 17
        local u3 = Instance.new(p2);

        local function _(p4) -- Line: 21
            -- upvalues: u3 (copy)
            p4.Parent = u3;

            return p4.Parent;
        end;

        for i, child in p1:GetChildren() do
            local _ = i - 1;
            child.Parent = u3;
            local _ = child.Parent;
        end;

        u3.Name = p1.Name;
        u3.Parent = p1.Parent;
        p1:Destroy();

        return u3;
    end
};