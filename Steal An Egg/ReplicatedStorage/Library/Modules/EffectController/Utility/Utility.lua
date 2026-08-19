-- Decompiled with Potassium's decompiler.

local u1 = {};
local v2 = RaycastParams.new();
v2.FilterType = Enum.RaycastFilterType.Include;
v2.FilterDescendantsInstances = { workspace };
u1.RayParams = v2;

function u1.AddItem(p3, u4, p5) -- Line: 7
    task.delay(p5, function() -- Line: 8
        -- upvalues: u4 (copy)
        if u4.Parent then
            u4:Destroy();
        end;
    end);
end;

function u1.PlaySound(p6, p7, p8) -- Line: 15
    -- upvalues: u1 (copy)
    local v9 = p7:Clone();
    v9.Parent = p8;
    v9:Play();
    u1:AddItem(v9, v9.TimeLength);

    return v9;
end;

function u1.WeldInPlace(p10, p11, p12) -- Line: 23
    if p11 ~= p12 then
        local v13 = CFrame.new(p11.Position);
        local ManualWeld = Instance.new("ManualWeld");
        ManualWeld.Part0 = p11;
        ManualWeld.Part1 = p12;
        ManualWeld.C0 = p11.CFrame:inverse() * v13;
        ManualWeld.C1 = p12.CFrame:inverse() * v13;
        ManualWeld.Parent = p11;
        ManualWeld.Name = "Weld";

        return ManualWeld;
    end;
end;

function u1.CreateLockPart(p14, p15, p16, p17, p18) -- Line: 39
    p15:PivotTo(p16);
    local v19;

    if p18 then
        v19 = workspace.World.ClientEffects:FindFirstChild(p18);
    else
        v19 = p18;
    end;

    if not v19 then
        v19 = script.LOCK:Clone();
        v19.Name = p18 or "LOCK";
        v19.Parent = workspace.World.Visuals;
        v19.Transparency = 1;
    end;

    v19:PivotTo(p16);

    if p17 then
        task.delay(p17, v19.Destroy, v19);
    end;

    v19.Weld.part1 = p15;

    return v19;
end;

function u1.Round(p20, p21, p22, p23) -- Line: 57
    local v24 = p23 ^ p22;

    return math.floor(p21 * v24 + 0.5) / v24;
end;

function u1.HasProperty(p25, u26, u27) -- Line: 62
    return pcall(function() -- Line: 63
        -- upvalues: u26 (copy), u27 (copy)
        local _ = u26[u27];
    end);
end;

return u1;