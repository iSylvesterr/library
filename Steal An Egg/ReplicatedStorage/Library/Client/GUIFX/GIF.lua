-- Decompiled with Potassium's decompiler.

local GenerateUID = require(game.ReplicatedStorage.Library.Functions.GenerateUID);
local BindToRenderStep = require(game.ReplicatedStorage.Library.Functions.BindToRenderStep);

return function(u1, p2, p3, p4, p5) -- Line: 9
    -- upvalues: GenerateUID (copy), BindToRenderStep (copy)
    local u6 = p4 or UDim2.new();
    local u7 = p5 or 1;
    local Scale = u1.Size.X.Scale;
    local Scale2 = u1.Size.Y.Scale;
    local u8 = (p2 or 1) / (Scale * Scale2);
    local v9 = GenerateUID();
    local u10 = false;
    local u11 = tick();
    local u12 = 1;
    local u13 = Scale * Scale2;

    if p3 then
        u13 = u13 - p3;
    end;

    local u14 = nil;

    local function CleanupAnimation() -- Line: 34
        -- upvalues: u10 (ref), u14 (ref)
        if u10 then
            return;
        end;

        u10 = true;

        if u14 then
            u14();
            u14 = nil;
        end;
    end;

    u14 = BindToRenderStep(v9, 1, function() -- Line: 45
        -- upvalues: u11 (ref), u8 (copy), u12 (ref), u13 (ref), Scale (copy), u7 (copy), u1 (copy), u6 (copy)
        local v15 = tick();

        if u8 < v15 - u11 then
            u12 = u12 >= u13 and 1 or u12 + 1;
            u11 = v15;
            local v16 = math.floor((u12 - 1) / Scale) * u7;
            u1.Position = UDim2.new(-((u12 - 1) % Scale * u7), 0, -v16, 0) + u6;
        end;
    end);
    u1.AncestryChanged:Connect(function() -- Line: 58
        -- upvalues: u1 (copy), u10 (ref), u14 (ref)
        if not u1.Parent then
            if u10 then
                return;
            end;

            u10 = true;

            if u14 then
                u14();
                u14 = nil;
            end;
        end;
    end);

    return CleanupAnimation;
end;