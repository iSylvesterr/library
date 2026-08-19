-- Decompiled with Potassium's decompiler.

local u1 = CFrame.new(Vector3.new(1000000000, 1000000000, 1000000000));
local v2 = {};

local function disableTrails(u3) -- Line: 25
    if u3:IsA("Trail") then
        pcall(function() -- Line: 27
            -- upvalues: u3 (copy)
            if u3:GetAttribute("_pooledTrailEnabled") == nil then
                u3:SetAttribute("_pooledTrailEnabled", u3.Enabled);
            end;

            if u3:GetAttribute("_pooledTrailLifetime") == nil then
                u3:SetAttribute("_pooledTrailLifetime", u3.Lifetime);
            end;

            u3.Lifetime = 0;
            u3.Enabled = false;
        end);

        return;
    end;

    for _, descendant in ipairs(u3:GetDescendants()) do
        if descendant:IsA("Trail") then
            pcall(function() -- Line: 41
                -- upvalues: descendant (copy)
                if descendant:GetAttribute("_pooledTrailEnabled") == nil then
                    descendant:SetAttribute("_pooledTrailEnabled", descendant.Enabled);
                end;

                if descendant:GetAttribute("_pooledTrailLifetime") == nil then
                    descendant:SetAttribute("_pooledTrailLifetime", descendant.Lifetime);
                end;

                descendant.Lifetime = 0;
                descendant.Enabled = false;
            end);
        end;
    end;
end;

local function restoreTrails(u4) -- Line: 56
    if u4:IsA("Trail") then
        pcall(function() -- Line: 58
            -- upvalues: u4 (copy)
            local v5 = u4:GetAttribute("_pooledTrailLifetime");

            if v5 ~= nil then
                u4.Lifetime = v5;
            end;

            u4:SetAttribute("_pooledTrailLifetime", nil);
            local v6 = u4:GetAttribute("_pooledTrailEnabled");

            if v6 ~= nil then
                u4.Enabled = v6 == true;
            end;

            u4:SetAttribute("_pooledTrailEnabled", nil);
        end);

        return;
    end;

    for _, descendant in ipairs(u4:GetDescendants()) do
        if descendant:IsA("Trail") then
            pcall(function() -- Line: 70
                -- upvalues: descendant (copy)
                local v7 = descendant:GetAttribute("_pooledTrailLifetime");

                if v7 ~= nil then
                    descendant.Lifetime = v7;
                end;

                descendant:SetAttribute("_pooledTrailLifetime", nil);
                local v8 = descendant:GetAttribute("_pooledTrailEnabled");

                if v8 ~= nil then
                    descendant.Enabled = v8 == true;
                end;

                descendant:SetAttribute("_pooledTrailEnabled", nil);
            end);
        end;
    end;
end;

local function cancelNativeDescendants(p9) -- Line: 87
    for _, descendant in ipairs(p9:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            pcall(function() -- Line: 90
                -- upvalues: descendant (copy)
                descendant:SetAttribute("_PartIcleNativeEmitGen", (descendant:GetAttribute("_PartIcleNativeEmitGen") or 0) + 1);
                descendant:SetAttribute("_PartIcleNativeDurationGen", (descendant:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1);
                descendant.Enabled = false;
            end);
        end;
    end;
end;

function v2.hide(u10, p11) -- Line: 101
    -- upvalues: disableTrails (copy), cancelNativeDescendants (copy), u1 (copy)
    if not (u10 and u10.Parent) then
        return;
    end;

    if p11 == "Part" then
        disableTrails(u10);
        cancelNativeDescendants(u10);

        if u10:IsA("BasePart") then
            pcall(function() -- Line: 110
                -- upvalues: u10 (copy), u1 (ref)
                u10.CFrame = u1;
            end);
        end;
    else
        if p11 == "Model" or p11 == "Lightning" then
            disableTrails(u10);
            cancelNativeDescendants(u10);
            pcall(function() -- Line: 119
                -- upvalues: u10 (copy), u1 (ref)
                u10:PivotTo(u1);
            end);

            return;
        end;

        if p11 == "Rocks" or p11 == "Rope" then
            disableTrails(u10);
            cancelNativeDescendants(u10);

            for _, child in ipairs(u10:GetChildren()) do
                if child:IsA("BasePart") then
                    pcall(function() -- Line: 131
                        -- upvalues: child (copy), u1 (ref)
                        child.Anchored = true;
                        child.CanCollide = false;
                        child.CanTouch = false;
                        child.CFrame = u1;
                    end);
                end;
            end;

            return;
        end;

        if p11 == "Beam" then
            pcall(function() -- Line: 143
                -- upvalues: u10 (copy)
                if u10:GetAttribute("_pooledBeamColor") == nil then
                    u10:SetAttribute("_pooledBeamColor", u10.Color);
                end;

                if u10:GetAttribute("_pooledBeamTransparency") == nil then
                    u10:SetAttribute("_pooledBeamTransparency", u10.Transparency);
                end;

                u10.Enabled = false;
            end);

            return;
        end;

        if p11 == "PointLight" then
            pcall(function() -- Line: 154
                -- upvalues: u10 (copy)
                u10.Enabled = false;
            end);

            return;
        end;

        if p11 == "Highlight" then
            pcall(function() -- Line: 157
                -- upvalues: u10 (copy)
                u10.Enabled = false;
            end);

            return;
        end;

        if p11 == "TrailEmitter" then
            pcall(function() -- Line: 160
                -- upvalues: u10 (copy)
                u10.Enabled = false;
            end);

            return;
        end;

        if p11 == "ImageLabel" then
            pcall(function() -- Line: 166
                -- upvalues: u10 (copy)
                u10.Visible = false;
            end);

            return;
        end;

        if p11 == "Attachment" then
            disableTrails(u10);
            cancelNativeDescendants(u10);
        end;
    end;
end;

function v2.show(u12, p13) -- Line: 181
    if not (u12 and u12.Parent) then
        return;
    end;

    if p13 == "Beam" then
        pcall(function() -- Line: 188
            -- upvalues: u12 (copy)
            local v14 = u12:GetAttribute("_pooledBeamColor");

            if v14 ~= nil then
                u12.Color = v14;
            end;

            u12:SetAttribute("_pooledBeamColor", nil);
            local v15 = u12:GetAttribute("_pooledBeamTransparency");

            if v15 ~= nil then
                u12.Transparency = v15;
            end;

            u12:SetAttribute("_pooledBeamTransparency", nil);
            u12.Enabled = true;
        end);

        return;
    end;

    if p13 == "PointLight" or (p13 == "Highlight" or p13 == "TrailEmitter") then
        pcall(function() -- Line: 198
            -- upvalues: u12 (copy)
            u12.Enabled = true;
        end);

        return;
    end;

    if p13 == "ImageLabel" then
        pcall(function() -- Line: 200
            -- upvalues: u12 (copy)
            u12.Visible = true;
        end);
    end;
end;

function v2.restoreTrails(p16, p17) -- Line: 207
    -- upvalues: restoreTrails (copy)
    if not (p16 and p16.Parent) then
        return;
    end;

    if p17 == "Part" or (p17 == "Model" or (p17 == "Attachment" or (p17 == "Lightning" or (p17 == "Rocks" or p17 == "Rope")))) then
        restoreTrails(p16);
    end;
end;

return v2;