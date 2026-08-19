-- Decompiled with Potassium's decompiler.

local u1 = {
    Order = { "Dewy", "Dusty", "Frosted", "Shocked", "Charged", "Infested", "Radioactive", "Slimy", "Golden", "Scaled", "Cosmic", "Huge" },
    Mutations = {
        Dewy = {
            displayName = "Dewy",
            mult = 2,
            burstFX = "MistyBurst",
            textColor = Color3.fromRGB(0, 170, 255)
        },
        Dusty = {
            displayName = "Dusty",
            mult = 3,
            burstFX = "DustyBurst",
            textColor = Color3.fromRGB(220, 179, 132)
        },
        Frosted = {
            displayName = "Frosted",
            mult = 3,
            burstFX = "FrostyBurst",
            textColor = Color3.fromRGB(224, 245, 255)
        },
        Shocked = {
            displayName = "Shocked",
            mult = 2.5,
            textColor = Color3.fromRGB(255, 255, 127)
        },
        Charged = {
            displayName = "Charged",
            mult = 7.5,
            textColor = Color3.fromRGB(123, 252, 252)
        },
        Radioactive = {
            displayName = "Radioactive",
            mult = 5,
            burstFX = "RadioactiveBurst",
            textColor = Color3.fromRGB(0, 170, 0)
        },
        Golden = {
            displayName = "Golden",
            mult = 25,
            burstFX = "GoldenBurst",
            textColor = Color3.fromRGB(255, 204, 0)
        },
        Cosmic = {
            displayName = "Cosmic",
            mult = 100,
            burstFX = "CosmicBurst",
            textColor = Color3.fromRGB(170, 0, 255)
        },
        Infested = {
            displayName = "Infested",
            mult = 3,
            textColor = Color3.fromRGB(130, 85, 85)
        },
        Slimy = {
            displayName = "Slimy",
            mult = 10,
            textColor = Color3.fromRGB(85, 255, 127)
        },
        Scaled = {
            displayName = "Scaled",
            mult = 50,
            burstFX = "ScaledBurst",
            textColor = Color3.fromRGB(39, 70, 45)
        },
        Huge = {
            displayName = "HUGE",
            mult = 1,
            sizeMutation = true,
            textColor = Color3.fromRGB(255, 176, 196)
        }
    }
};

function u1.Get(p2) -- Line: 103
    -- upvalues: u1 (copy)
    return p2 and u1.Mutations[p2] or nil;
end;

function u1.GetMult(p3) -- Line: 107
    -- upvalues: u1 (copy)
    local v4 = u1.Mutations[p3];

    return v4 and v4.mult or 1;
end;

function u1.ProductMult(p5) -- Line: 114
    -- upvalues: u1 (copy)
    if not p5 then
        return 1;
    end;

    local v6 = 1;

    for _, v in p5 do
        v6 = v6 * u1.GetMult(v);
    end;

    return v6;
end;

function u1.Sanitize(p7) -- Line: 125
    -- upvalues: u1 (copy)
    local v8 = {};

    if type(p7) ~= "table" then
        return v8;
    end;

    local v9 = {};

    for _, v in p7 do
        if u1.Mutations[v] and not v9[v] then
            v9[v] = true;
        end;
    end;

    for _, v in u1.Order do
        if v9[v] then
            table.insert(v8, v);
        end;
    end;

    return v8;
end;

function u1.OrderKeys(p10) -- Line: 143
    -- upvalues: u1 (copy)
    return u1.Sanitize(p10);
end;

function u1.NameSuffix(p11) -- Line: 148
    -- upvalues: u1 (copy)
    local v12 = u1.OrderKeys(p11);

    if #v12 == 0 then
        return "";
    end;

    local v13 = {};

    for _, v in v12 do
        table.insert(v13, u1.Mutations[v].displayName);
    end;

    return " (" .. table.concat(v13, ", ") .. ")";
end;

function u1.TopColor(p14) -- Line: 159
    -- upvalues: u1 (copy)
    local v15 = nil;
    local v16 = nil;

    if not p14 then
        return nil;
    end;

    for _, v in p14 do
        local v17 = u1.Mutations[v];

        if v17 and (not v16 or v16 < v17.mult) then
            v16 = v17.mult;
            v15 = v17;
        end;
    end;

    return v15 and v15.textColor or nil;
end;

return u1;