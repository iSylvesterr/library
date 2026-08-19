-- Decompiled with Potassium's decompiler.

local v1 = {};

local function BuildFields(p2) -- Line: 15
    local v3 = {};
    local v4;

    if p2:IsA("GuiObject") then
        v3.BackgroundTransparency = p2.BackgroundTransparency;
        v4 = true;
    else
        v4 = false;
    end;

    if p2:IsA("ImageLabel") or p2:IsA("ImageButton") then
        v3.ImageTransparency = p2.ImageTransparency;
        v4 = true;
    end;

    if p2:IsA("TextLabel") or (p2:IsA("TextButton") or p2:IsA("TextBox")) then
        v3.TextTransparency = p2.TextTransparency;
        v4 = true;
    end;

    if v4 then
        return v3;
    end;

    return nil;
end;

function v1.BuildCache(p5) -- Line: 40
    -- upvalues: BuildFields (copy)
    local v6 = {};
    local v7 = BuildFields(p5);

    if v7 then
        v6[p5] = v7;
    end;

    for _, descendant in ipairs(p5:GetDescendants()) do
        local v8 = BuildFields(descendant);

        if v8 then
            v6[descendant] = v8;
        end;
    end;

    return v6;
end;

function v1.Apply(p9, p10, p11) -- Line: 58
    local v12 = math.clamp(p11, 0, 1);

    for i, v in pairs(p10) do
        if i:IsDescendantOf(p9) then
            if v.BackgroundTransparency ~= nil and i:IsA("GuiObject") then
                i.BackgroundTransparency = math.clamp(v.BackgroundTransparency + v12, 0, 1);
            end;

            if v.ImageTransparency ~= nil and (i:IsA("ImageLabel") or i:IsA("ImageButton")) then
                i.ImageTransparency = math.clamp(v.ImageTransparency + v12, 0, 1);
            end;

            if v.TextTransparency ~= nil and (i:IsA("TextLabel") or (i:IsA("TextButton") or i:IsA("TextBox"))) then
                i.TextTransparency = math.clamp(v.TextTransparency + v12, 0, 1);
            end;
        else
            p10[i] = nil;
        end;
    end;
end;

return v1;