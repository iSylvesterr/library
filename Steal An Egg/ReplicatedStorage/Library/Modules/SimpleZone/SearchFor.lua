-- Decompiled with Potassium's decompiler.

local function splitRecursiveProperty(p1) -- Line: 1
    local v2 = p1:split("_");
    local v3 = v2[1];
    local v4;

    if #v2 > 1 then
        v4 = table.concat(v2, "_", 2, #v2);
    else
        v4 = false;
    end;

    return v3, v4;
end;

local function propertyChecker(p5, p6, p7, p8) -- Line: 9
    for i, v in p8 do
        local v9 = i:split("_");
        local v10 = v9[1];
        local v11;

        if #v9 > 1 then
            v11 = table.concat(v9, "_", 2, #v9);
        else
            v11 = false;
        end;

        if v10 == "Parent" and v11 then
            p7(SearchFor({ p5.Parent }, {
                [v11] = v
            }, p6)[p5.Parent]);
        elseif p5:FindFirstChild(v10) and v11 then
            p7(SearchFor({ p5:FindFirstChild(v10) }, {
                [v11] = v
            }, p6)[p5.Parent]);
        elseif v == "Tag" then
            p7(p5:HasTag(v10));
        elseif v10:match("Attribute_") then
            p7(p5:GetAttribute(v10:split("_")[2]) == v);
        else
            p7(p5[v10] == v);
        end;
    end;
end;

function SearchFor(p12, p13, u14)
    -- upvalues: propertyChecker (copy)
    local v15;

    if u14 == nil then
        v15 = false;
    else
        v15 = u14 == "Or" and true or u14 == "And";
    end;

    assert(v15, "Bad mode argument.");
    local u16 = {};

    for _, v in p12 do
        local u17 = false;
        propertyChecker(v, u14, function(p18) -- Line: 52, Name: checkCondition
            -- upvalues: u14 (copy), u16 (copy), v (copy), u17 (ref)
            if p18 and u14 == "Or" then
                table.insert(u16, v);

                return;
            end;

            if not p18 and u14 == "And" then
                u17 = true;
            end;
        end, p13);

        if not u17 and u14 == "And" then
            table.insert(u16, v);
        end;
    end;

    return u16;
end;

return SearchFor;