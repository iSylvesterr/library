-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 17
    local u2 = setmetatable({}, {
        __mode = "k"
    });

    local function _buildVfxCache(p3) -- Line: 33
        local v4 = {};
        local v5 = {};
        local v6 = {};

        if p3:IsA("ParticleEmitter") then
            table.insert(v4, p3);
        elseif p3:IsA("Beam") then
            table.insert(v5, p3);
        elseif p3:IsA("Trail") then
            table.insert(v6, p3);
        end;

        for _, descendant in p3:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                table.insert(v4, descendant);
            elseif descendant:IsA("Beam") then
                table.insert(v5, descendant);
            elseif descendant:IsA("Trail") then
                table.insert(v6, descendant);
            end;
        end;

        return {
            emitters = v4,
            beams = v5,
            trails = v6
        };
    end;

    function p1.GetVfxCache(p7) -- Line: 69
        -- upvalues: u2 (copy), _buildVfxCache (copy)
        local v8 = u2[p7];

        if v8 then
            return v8;
        end;

        local v9 = _buildVfxCache(p7);
        u2[p7] = v9;

        return v9;
    end;

    function p1.InvalidateVfxCache(p10) -- Line: 85
        -- upvalues: u2 (copy)
        if not p10 then
            return;
        end;

        u2[p10] = nil;
    end;
end;