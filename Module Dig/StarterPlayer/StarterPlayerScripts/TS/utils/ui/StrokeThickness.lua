-- Decompiled with Potassium's decompiler.

return {
    restoreStrokeThickness = function(p1) -- Line: 3, Name: restoreStrokeThickness
        for _, descendant in p1:GetDescendants() do
            if descendant:IsA("UIStroke") then
                local v2 = descendant:GetAttribute("OriginalThickness");

                if type(v2) == "number" then
                    descendant.Thickness = v2;
                end;
            end;
        end;
    end
};