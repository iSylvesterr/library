-- Decompiled with Potassium's decompiler.

local function trySwap(u1, u2, u3, u4) -- Line: 1
    pcall(function() -- Line: 2
        -- upvalues: u1 (copy), u2 (copy), u3 (copy), u4 (copy)
        if u1[u2] == u3 then
            u1[u2] = u4;
        end;
    end);
end;

local function swap(u5, u6, u7) -- Line: 9
    if u5:IsA("Model") then
        if u5.PrimaryPart == u6 then
            u5.PrimaryPart = u7;
        end;
    elseif u5:IsA("ObjectValue") and u5.Value == u6 then
        u5.Value = u7;
    end;

    local u8 = "Part0";
    pcall(function() -- Line: 2
        -- upvalues: u5 (copy), u8 (copy), u6 (copy), u7 (copy)
        if u5[u8] == u6 then
            u5[u8] = u7;
        end;
    end);
    local u9 = "Part1";
    pcall(function() -- Line: 2
        -- upvalues: u5 (copy), u9 (copy), u6 (copy), u7 (copy)
        if u5[u9] == u6 then
            u5[u9] = u7;
        end;
    end);
    local u10 = "Adornee";
    pcall(function() -- Line: 2
        -- upvalues: u5 (copy), u10 (copy), u6 (copy), u7 (copy)
        if u5[u10] == u6 then
            u5[u10] = u7;
        end;
    end);

    for i, v in pairs(u5:GetAttributes()) do
        if v == u6 then
            u5:SetAttribute(i, u7);
        end;
    end;
end;

return function(p11, p12, p13) -- Line: 27
    -- upvalues: swap (copy)
    swap(p11, p12, p13);

    for _, descendant in ipairs(p11:GetDescendants()) do
        swap(descendant, p12, p13);
    end;
end;