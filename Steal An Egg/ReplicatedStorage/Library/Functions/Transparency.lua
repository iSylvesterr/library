-- Decompiled with Potassium's decompiler.

local function applyNumberSequence(p1, p2, p3) -- Line: 13
    local v4 = {};

    for _, v in ipairs(p1.Keypoints) do
        local v5 = v.Value * (1 - p3) + p2 * p3;
        local Envelope = v.Envelope;
        local v6 = math.min(v5, 1 - v5);
        local v7 = math.max(0, v6);
        local v8 = math.min(Envelope, v7);
        table.insert(v4, NumberSequenceKeypoint.new(v.Time, v5, v8));
    end;

    return NumberSequence.new(v4);
end;

return function() -- Line: 38, Name: CreateTransparencyModule
    -- upvalues: applyNumberSequence (copy)
    local u9 = {};

    local function handleTransparency(p10, p11) -- Line: 41
        -- upvalues: u9 (copy)
        local v12 = u9[p10];

        if not v12 then
            v12 = {};
            u9[p10] = v12;
        end;

        if v12[p11] == nil then
            v12[p11] = p10[p11];
        end;

        return v12[p11];
    end;

    local function applyTransparencyToInstance(u13, u14, u15, p16) -- Line: 55
        -- upvalues: u9 (copy), applyNumberSequence (ref), applyTransparencyToInstance (copy)
        if p16 and table.find(p16, u13.ClassName) then
            return;
        end;

        if u13:IsA("BasePart") or (u13:IsA("UIStroke") or (u13:IsA("Texture") or u13:IsA("Decal"))) then
            local v17 = u9[u13];

            if not v17 then
                v17 = {};
                u9[u13] = v17;
            end;

            if v17.Transparency == nil then
                v17.Transparency = u13.Transparency;
            end;

            u13.Transparency = v17.Transparency * (1 - u15) + u14 * u15;
        elseif u13:IsA("ParticleEmitter") or (u13:IsA("Trail") or u13:IsA("Beam")) then
            local v18 = u9[u13];

            if not v18 then
                v18 = {};
                u9[u13] = v18;
            end;

            if v18.Transparency == nil then
                v18.Transparency = u13.Transparency;
            end;

            u13.Transparency = applyNumberSequence(v18.Transparency, u14, u15);
        elseif u13:IsA("GuiObject") then
            for _, v in pairs({ "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency", "ImageTransparency" }) do
                pcall(function() -- Line: 75
                    -- upvalues: u13 (copy), v (copy), u9 (ref), u15 (copy), u14 (copy)
                    local v19 = u13;
                    local v20 = v;
                    local v21 = u9[v19];

                    if not v21 then
                        v21 = {};
                        u9[v19] = v21;
                    end;

                    if v21[v20] == nil then
                        v21[v20] = v19[v20];
                    end;

                    u13[v] = v21[v20] * (1 - u15) + u14 * u15;
                end);
            end;
        end;

        for _, child in ipairs(u13:GetChildren()) do
            applyTransparencyToInstance(child, u14, u15, p16);
        end;
    end;

    return applyTransparencyToInstance;
end;