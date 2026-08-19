-- Decompiled with Potassium's decompiler.

return {
    isUiVisible = function(p1) -- Line: 9, Name: isUiVisible
        local Parent = p1.Parent;

        while Parent ~= nil do
            if Parent:IsA("ScreenGui") or (Parent:IsA("SurfaceGui") or Parent:IsA("BillboardGui")) then
                return Parent.Enabled;
            end;

            if Parent:IsA("GuiObject") and not Parent.Visible then
                return false;
            end;

            Parent = Parent.Parent;
        end;

        return true;
    end
};