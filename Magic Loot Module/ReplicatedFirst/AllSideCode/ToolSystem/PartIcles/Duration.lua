-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local u1 = {};

local function resolveDuration(p2) -- Line: 15
    if p2 == nil then
        return 0;
    end;

    if typeof(p2) == "number" then
        return p2;
    end;

    local v3 = {};

    for i in tostring(p2):gmatch("[^,]+") do
        local v4 = tonumber(i:match("^%s*(.-)%s*$"));

        if v4 then
            table.insert(v3, v4);
        end;
    end;

    if #v3 == 0 then
        return 0;
    end;

    if #v3 == 1 then
        return v3[1];
    end;

    return math.max(v3[1], v3[2]);
end;

function u1.computeTrueLifetime(p5, p6, p7) -- Line: 32
    -- upvalues: Graph (copy)
    if not p5 or p5 <= 0 then
        return 0;
    end;

    if not p6 then
        return p5;
    end;

    if Graph.IsStatic(p6) then
        local v8 = Graph.GetStaticValue(p6, 1);

        if v8 == 1 then
            return p5;
        end;

        if v8 == 0 then
            return nil;
        end;

        if v8 > 0 then
            return p5 / v8;
        end;

        return p5 / -v8;
    end;

    local v9 = p7 or {};
    local v10 = Graph.QueryPointsWithTime(0, p6, v9) < 0;
    local v11 = p5 / 200;
    local v12 = v10 and p5 and p5 or 0;
    local v13 = 0;

    for i = 1, 200 do
        local v14 = v12 + Graph.QueryPointsWithTime(i / 200, p6, v9) * v11;

        if not v10 and p5 <= v14 then
            return v13 + (p5 - v12) / (v14 - v12) * v11;
        end;

        if v10 and v14 <= 0 then
            return v13 + v12 / (v12 - v14) * v11;
        end;

        v13 = v13 + v11;
        v12 = v14;
    end;

    local v15 = Graph.QueryPointsWithTime(1, p6, v9);

    if v10 then
        if v15 >= 0 then
            return nil;
        end;

        return v13 + v12 / -v15;
    end;

    if v15 <= 0 then
        return nil;
    end;

    return v13 + (p5 - v12) / v15;
end;

function u1.computeItemLifecycle(p16) -- Line: 85
    -- upvalues: resolveDuration (copy), u1 (copy)
    if not p16:GetAttribute("Transformed") then
        if not p16:IsA("ParticleEmitter") then
            if p16:IsA("Trail") then
                local v17 = p16:GetAttribute("EmitDelay") or 0;
                local v18 = resolveDuration(p16:GetAttribute("EmitDuration"));

                return v18 > 0 and {
                    infinite = false,
                    emitDelay = v17,
                    emitDur = v18,
                    lifecycle = p16.Lifetime or 0
                } or nil;
            end;

            if not p16:IsA("Beam") then
                return nil;
            end;

            local v19 = tonumber(p16:GetAttribute("EmitDelay")) or 0;
            local v20 = tonumber(p16:GetAttribute("EmitDuration")) or 0;

            return v20 > 0 and {
                lifecycle = 0,
                infinite = false,
                emitDelay = v19,
                emitDur = v20
            } or nil;
        end;

        local v21 = p16:GetAttribute("EmitCount");
        local v22 = tonumber(p16:GetAttribute("EmitDelay")) or 0;
        local v23 = tonumber(p16:GetAttribute("EmitDuration")) or 0;

        if (v21 == nil and 1 or v21) <= 0 and v23 <= 0 then
            return nil;
        end;

        local Lifetime = p16.Lifetime;

        return {
            infinite = false,
            emitDelay = v22,
            emitDur = v23,
            lifecycle = typeof(Lifetime) == "NumberRange" and (Lifetime.Max or 0) or 0
        };
    end;

    local PartIcleProperties = p16:FindFirstChild("PartIcleProperties");
    local v24 = p16:GetAttribute("EmitDelay") or 0;
    local v25 = resolveDuration(p16:GetAttribute("EmitDuration"));
    local v26 = p16:GetAttribute("EmitCount");
    local v27 = p16:GetAttribute("EmissionMode") or "Emit";
    local v28 = p16:GetAttribute("AnimateLoop") == true;

    if v27 == "Animate" and (v28 and v25 <= 0) then
        return {
            emitDur = 0,
            lifecycle = 0,
            infinite = true,
            emitDelay = v24
        };
    end;

    if (v26 == nil and 1 or v26) <= 0 and v25 <= 0 and v27 ~= "Animate" then
        return nil;
    end;

    local v29;

    if PartIcleProperties then
        v29 = PartIcleProperties:GetAttribute("Lifetime");
    else
        v29 = PartIcleProperties;
    end;

    local v30 = 0;

    if typeof(v29) == "NumberRange" then
        v29 = v29.Max;
    elseif type(v29) ~= "number" then
        v29 = v30;
    end;

    local v31;

    if PartIcleProperties then
        v31 = PartIcleProperties:GetAttribute("Timescale");
    else
        v31 = PartIcleProperties;
    end;

    local v32 = u1.computeTrueLifetime(v29, v31, nil);

    if v32 == nil then
        return {
            lifecycle = 0,
            infinite = true,
            emitDelay = v24,
            emitDur = v25
        };
    end;

    local v33 = PartIcleProperties and PartIcleProperties:GetAttribute("PartLife") or 0;

    if v27 == "Animate" then
        if v25 < v32 then
            v25 = v32;
        end;
    end;

    return {
        infinite = false,
        emitDelay = v24,
        emitDur = v25,
        lifecycle = v32 + v33
    };
end;

function u1.computeMaxDuration(p34, p35) -- Line: 151
    -- upvalues: u1 (copy)
    if not p34 then
        return 0;
    end;

    local v36 = p35 or 0;
    local v37 = u1.computeItemLifecycle(p34);
    local v38 = 0;
    local v39 = false;

    if v37 then
        if v37.infinite then
            return nil;
        end;

        v38 = v36 + v37.emitDelay + v37.emitDur + v37.lifecycle;
        v36 = v36 + v37.emitDelay;
        p34:GetAttribute("Transformed");
    elseif p34:GetAttribute("Transformed") then
        v39 = true;
    end;

    if not v39 then
        for _, child in ipairs(p34:GetChildren()) do
            if child.Name == "RenderTemplate" then
                for _, descendant in ipairs(child:GetDescendants()) do
                    if descendant:GetAttribute("Transformed") then
                        local v40 = u1.computeMaxDuration(descendant, v36);

                        if v40 == nil then
                            return nil;
                        end;

                        if v38 < v40 then
                            v38 = v40;
                        end;
                    end;
                end;
            else
                local v41 = u1.computeMaxDuration(child, v36);

                if v41 == nil then
                    return nil;
                end;

                if v38 < v41 then
                    v38 = v41;
                end;
            end;
        end;
    end;

    return v38;
end;

return u1;