-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");

function Flash(u1, p2, p3, p4, p5)
    -- upvalues: RunService (copy)
    local u6 = p2 or 1;
    local u7 = p3 or 0.5;
    local v8 = p4 or Color3.new(1, 1, 1);

    if not u1 then
        warn("Object is missing");

        return function() -- Line: 12
        end;
    end;

    local v9 = {};

    if u1:IsA("BasePart") and (not p5 or p5(u1)) then
        table.insert(v9, u1);
    end;

    for _, descendant in ipairs(u1:GetDescendants()) do
        if descendant:IsA("BasePart") and (not p5 or p5(descendant)) then
            table.insert(v9, descendant);
        end;
    end;

    local v10 = {
        Enum.NormalId.Back,
        Enum.NormalId.Front,
        Enum.NormalId.Left,
        Enum.NormalId.Right,
        Enum.NormalId.Top,
        Enum.NormalId.Bottom
    };
    local u11 = {};

    for _, v in ipairs(v9) do
        for i = 1, 6 do
            local Decal = Instance.new("Decal");
            Decal.Texture = "rbxassetid://6381483576";
            Decal.Name = "_SELECTIONFX";
            Decal.Transparency = u7;
            Decal.Color3 = v8;
            Decal.Face = v10[i];
            Decal.Parent = v;
            table.insert(u11, Decal);
        end;
    end;

    local u12 = nil;

    local function cleanup() -- Line: 53
        -- upvalues: u12 (ref), u11 (copy)
        if u12 then
            u12:Disconnect();
        end;

        for _, v in ipairs(u11) do
            if v then
                v:Destroy();
            end;
        end;
    end;

    local u13 = 0;
    u12 = RunService.RenderStepped:Connect(function(p14) -- Line: 65
        -- upvalues: u1 (copy), u11 (copy), u13 (ref), u6 (ref), u7 (ref), cleanup (copy)
        if u1 and (u1.Parent and u11[1]) then
            u13 = math.clamp(u13 + p14, 0, u6);
            local v15 = u7 + (1 - u7) * (u13 / u6);

            for _, v in ipairs(u11) do
                if not v then
                    cleanup();

                    return;
                end;

                v.Transparency = v15;
            end;

            if u6 <= u13 then
                cleanup();
            end;
        else
            cleanup();
        end;
    end);

    return cleanup;
end;

return Flash;