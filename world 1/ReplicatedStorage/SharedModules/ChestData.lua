-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};

function u1.GetData(p3) -- Line: 7
    -- upvalues: u2 (copy)
    if u2[p3] then
        return u2[p3];
    end;

    local u4 = script:FindFirstChild(p3);

    if not (u4 and u4:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 19
        -- upvalues: u4 (copy)
        return require(u4);
    end);

    if success then
        u2[p3] = result;

        return result;
    end;

    warn((`Chest module require failed ({p3}): {result}`));

    return nil;
end;

function u1.GetRandomItem(p5) -- Line: 33
    -- upvalues: u1 (copy)
    local v6 = u1.GetData(p5);

    if not v6 or (not v6.Items or #v6.Items == 0) then
        return nil;
    end;

    local v7 = 0;

    for _, v in v6.Items do
        v7 = v7 + v.Chance;
    end;

    if v7 <= 0 then
        return nil;
    end;

    local v8 = math.random() * v7;
    local v9 = 0;

    for _, v in v6.Items do
        v9 = v9 + v.Chance;

        if v8 <= v9 then
            return v;
        end;
    end;

    return v6.Items[#v6.Items];
end;

function u1.GetAllChests() -- Line: 63
    -- upvalues: u1 (copy)
    local v10 = {};

    for _, child in script:GetChildren() do
        if child:IsA("ModuleScript") then
            local v11 = u1.GetData(child.Name);

            if v11 then
                table.insert(v10, v11);
            end;
        end;
    end;

    return v10;
end;

return u1;