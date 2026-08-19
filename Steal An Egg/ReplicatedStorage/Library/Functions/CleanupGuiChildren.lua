-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    for _, child in ipairs(p1:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy();
        end;
    end;
end;