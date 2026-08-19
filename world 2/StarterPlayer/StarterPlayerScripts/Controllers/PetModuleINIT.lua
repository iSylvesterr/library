-- Decompiled with Potassium's decompiler.

return {
    Init = function(p1) -- Line: 3, Name: Init
        for _, child in pairs(script.Parent.PetVisualController.ClientPetControllers:GetChildren()) do
            require(child):Init();
        end;
    end
};