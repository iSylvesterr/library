-- Decompiled with Potassium's decompiler.

local u8 = {
    resolve = function(p1, p2, p3) -- Line: 12, Name: resolve
        if p1 then
            p1 = p1:GetAttribute(p2);
        end;

        if typeof(p1) ~= "NumberRange" or p1.Min == 0 and p1.Max == 0 then
            local v4 = math.floor(p3 or 12);

            return math.max(1, v4);
        end;

        local v5 = p1.Min + (p1.Max - p1.Min) * math.random();
        local v6 = math.floor(v5 + (v5 >= 0 and 0.5 or -0.5));

        if v6 ~= 0 then
            return v6;
        end;

        local v7 = math.floor(p3 or 12);

        return math.max(1, v7);
    end
};

function u8.step(u9, u10, u11, u12, u13) -- Line: 25
    -- upvalues: u8 (copy)
    local u14 = math.abs(u10);

    local function reroll() -- Line: 27
        -- upvalues: u10 (ref), u8 (ref), u11 (copy), u12 (copy), u13 (copy), u14 (ref), u9 (ref)
        u10 = u8.resolve(u11, u12, u13);
        u14 = math.abs(u10);

        if u10 > 0 then
            u9 = 1;

            return;
        end;

        u9 = u14;
    end;

    if u14 == 0 or u9 == 0 then
        u10 = u8.resolve(u11, u12, u13);
        u14 = math.abs(u10);

        if u10 > 0 then
            u9 = 1;
        else
            u9 = u14;
        end;
    elseif u10 > 0 then
        u9 = u9 + 1;

        if u14 < u9 then
            u10 = u8.resolve(u11, u12, u13);
            u14 = math.abs(u10);

            if u10 > 0 then
                u9 = 1;
            else
                u9 = u14;
            end;
        end;
    else
        u9 = u9 - 1;

        if u9 < 1 then
            u10 = u8.resolve(u11, u12, u13);
            u14 = math.abs(u10);

            if u10 > 0 then
                u9 = 1;
            else
                u9 = u14;
            end;
        end;
    end;

    return u9, u10, u14;
end;

function u8.evenFlags(p15) -- Line: 45
    if p15 then
        return (p15:GetAttribute("PosXEven") or (p15:GetAttribute("PosYEven") or p15:GetAttribute("PosZEven"))) == true, (p15:GetAttribute("RotXEven") or (p15:GetAttribute("RotYEven") or p15:GetAttribute("RotZEven"))) == true;
    end;

    return false, false;
end;

function u8.advance(p16, p17, p18, p19, p20, p21) -- Line: 58
    -- upvalues: u8 (copy)
    local v22 = p16[p17];

    if not v22 then
        v22 = { 0, 0, 0, 0 };
        p16[p17] = v22;
    end;

    local v23 = 0;
    local v24 = 0;
    local v25, v26;

    if p20 and u8.isSet(p18, "PositionEvenCycle") then
        local v27, v28;
        v27, v28, v25 = u8.step(v22[1], v22[2], p18, "PositionEvenCycle", p19);
        v22[1] = v27;
        v22[2] = v28;
        v26 = v22[1];
    else
        v26 = 0;
        v25 = 0;
    end;

    if p21 and u8.isSet(p18, "RotationEvenCycle") then
        local v29, v30;
        v29, v30, v24 = u8.step(v22[3], v22[4], p18, "RotationEvenCycle", p19);
        v22[3] = v29;
        v22[4] = v30;
        v23 = v22[3];
    end;

    return v26, v25, v23, v24;
end;

function u8.isSet(p31, p32) -- Line: 78
    if p31 then
        p31 = p31:GetAttribute(p32);
    end;

    local v33;

    if typeof(p31) == "NumberRange" then
        local v34;

        if p31.Min == 0 then
            v34 = p31.Max == 0;
        else
            v34 = false;
        end;

        v33 = not v34;
    else
        v33 = false;
    end;

    return v33;
end;

function u8.clear(p35, p36) -- Line: 84
    if p35 and p36 ~= nil then
        p35[p36] = nil;
    end;
end;

function u8.ensureIds(u37) -- Line: 94
    if u37:GetAttribute("_EvenCycleId") then
        return;
    end;

    local HttpService = game:GetService("HttpService");
    pcall(function() -- Line: 97
        -- upvalues: u37 (copy), HttpService (copy)
        u37:SetAttribute("_EvenCycleId", HttpService:GenerateGUID(false));
    end);
    local RenderTemplate = u37:FindFirstChild("RenderTemplate");

    if not RenderTemplate then
        return;
    end;

    for _, descendant in ipairs(RenderTemplate:GetDescendants()) do
        if descendant:GetAttribute("Transformed") and not descendant:GetAttribute("_EvenCycleId") then
            pcall(function() -- Line: 102
                -- upvalues: descendant (copy), HttpService (copy)
                descendant:SetAttribute("_EvenCycleId", HttpService:GenerateGUID(false));
            end);
        end;
    end;
end;

return u8;