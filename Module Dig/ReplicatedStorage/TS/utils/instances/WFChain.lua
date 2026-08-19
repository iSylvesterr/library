-- Decompiled with Potassium's decompiler.

return {
    WFChain = function(p1, ...) -- Line: 10, Name: WFChain
        for _, v in { ... } do
            p1 = p1:WaitForChild(v);
        end;

        return p1;
    end
};