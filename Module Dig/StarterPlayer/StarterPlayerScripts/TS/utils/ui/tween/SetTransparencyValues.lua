-- Decompiled with Potassium's decompiler.

return {
    SetTransparencyValues = function(p1) -- Line: 2
        for _, descendant in p1:GetDescendants() do
            if descendant:IsA("Frame") then
                descendant:SetAttribute("Visible", descendant.Transparency);
            elseif descendant:IsA("TextLabel") then
                descendant:SetAttribute("Visible", descendant.TextTransparency);
            elseif descendant:IsA("TextButton") then
                descendant:SetAttribute("Visible", descendant.TextTransparency);
            elseif descendant:IsA("ImageButton") then
                descendant:SetAttribute("Visible", descendant.ImageTransparency);
            elseif descendant:IsA("ImageLabel") then
                descendant:SetAttribute("Visible", descendant.ImageTransparency);
            elseif descendant:IsA("UIStroke") then
                descendant:SetAttribute("Visible", descendant.Transparency);
            end;
        end;
    end
};