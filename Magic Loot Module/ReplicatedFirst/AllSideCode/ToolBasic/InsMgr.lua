-- Decompiled with Potassium's decompiler.

return {
    GetIns = function(p1, p2, p3) -- Line: 15, Name: GetIns
        local v4 = p3:FindFirstChild((tostring(p1)));

        if v4 then
            return v4;
        end;

        local v5 = Instance.new(p2, p3);
        v5.Name = p1;

        return v5;
    end,

    FindByDotPath = function(p6, p7) -- Line: 35, Name: FindByDotPath
        if not p6 or (type(p7) ~= "string" or p7 == "") then
            return nil;
        end;

        for i, v in ipairs(string.split(p7, ".")) do
            if i == 1 and (v == "Workspace" or v == "workspace") then
                p6 = workspace;
            else
                p6 = p6:FindFirstChild(v);

                if not p6 then
                    return nil;
                end;
            end;
        end;

        return p6;
    end
};