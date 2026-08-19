-- Decompiled with Potassium's decompiler.

return {
    setRobuxBuyGradients = function(p1, p2) -- Line: 10, Name: setRobuxBuyGradients
        local Purple = p1:FindFirstChild("Purple");

        if Purple and Purple:IsA("UIGradient") then
            Purple.Enabled = p2;
        end;

        local Grey = p1:FindFirstChild("Grey");

        if Grey and Grey:IsA("UIGradient") then
            Grey.Enabled = not p2;
        end;
    end
};