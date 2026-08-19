-- Decompiled with Potassium's decompiler.

local u1 = {
    ["Conifer Cone Sapling"] = {
        FruitName = "Conifer Cone",
        VisualScale = 0.7
    }
};

return table.freeze({
    ResolveFruitName = function(p2) -- Line: 22, Name: ResolveFruitName
        -- upvalues: u1 (copy)
        if type(p2) ~= "string" then
            return "";
        end;

        local v3 = u1[p2];

        if v3 then
            return v3.FruitName;
        end;

        return p2;
    end,

    GetVisualScale = function(p4) -- Line: 30, Name: GetVisualScale
        -- upvalues: u1 (copy)
        if type(p4) ~= "string" then
            return 1;
        end;

        local v5 = u1[p4];

        return not v5 and 1 or v5.VisualScale;
    end
});