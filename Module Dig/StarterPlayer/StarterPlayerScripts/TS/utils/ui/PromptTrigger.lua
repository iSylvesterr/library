-- Decompiled with Potassium's decompiler.

return {
    getOrCreatePromptTrigger = function(p1) -- Line: 11, Name: getOrCreatePromptTrigger
        local PromptTrigger = p1:FindFirstChild("PromptTrigger");

        if PromptTrigger and PromptTrigger:IsA("BasePart") then
            return PromptTrigger;
        end;

        local v2, v3 = p1:GetBoundingBox();
        local Part = Instance.new("Part");
        Part.Name = "PromptTrigger";
        Part.Size = v3;
        Part.CFrame = v2;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Transparency = 1;
        Part.Massless = true;
        Part.Parent = p1;

        return Part;
    end
};