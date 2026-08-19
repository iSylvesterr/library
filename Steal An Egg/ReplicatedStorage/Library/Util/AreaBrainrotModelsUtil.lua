-- Decompiled with Potassium's decompiler.

return {
    GetBrainrotModel = function(p1) -- Line: 5, Name: GetBrainrotModel
        local WorldAssetMobs = workspace:FindFirstChild("WorldAssetMobs");

        if not WorldAssetMobs then
            return nil;
        end;

        for _, child in ipairs(WorldAssetMobs:GetChildren()) do
            if child:IsA("Model") and child:GetAttribute("SpawnId") == p1 then
                return child;
            end;
        end;

        return nil;
    end,

    GetTopPosition = function(p2) -- Line: 22, Name: GetTopPosition
        local v3 = p2:GetPivot();
        local v4 = p2:GetExtentsSize();

        return v3.Position + Vector3.new(0, v4.Y * 0.5, 0);
    end
};