-- Decompiled with Potassium's decompiler.

local u1 = {
    NAME = "TreeMountPoint"
};

function u1.get(p2) -- Line: 7
    -- upvalues: u1 (copy)
    if not p2 then
        return nil;
    end;

    local v3 = p2:FindFirstChild(u1.NAME, true);

    if not (v3 and (v3:IsA("BasePart") and v3)) then
        v3 = nil;
    end;

    return v3;
end;

function u1.hide(p4) -- Line: 14
    -- upvalues: u1 (copy)
    local v5 = u1.get(p4);

    if not v5 then
        return;
    end;

    v5.Transparency = 1;
    v5.CanCollide = false;
    v5.CanQuery = false;
    v5.CanTouch = false;

    for _, child in v5:GetChildren() do
        if child:IsA("Decal") or child:IsA("Texture") then
            child:Destroy();
        end;
    end;
end;

function u1.perchCF(p6) -- Line: 27
    -- upvalues: u1 (copy)
    local v7 = u1.get(p6);

    if v7 then
        return v7.CFrame * CFrame.Angles(0, -1.5707963267948966, 0) + v7.CFrame.LookVector * 1;
    end;

    return p6 and (p6:IsA("PVInstance") and p6:GetPivot()) or nil;
end;

return u1;