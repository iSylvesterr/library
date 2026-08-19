-- Decompiled with Potassium's decompiler.

local u1 = {};

local function resolveAnimator(p2) -- Line: 7
    if p2:IsA("Animator") then
        return p2;
    end;

    local v3 = p2:IsA("Player") and p2.Character;

    if v3 then
        local v4 = v3:FindFirstChildOfClass("Humanoid");
        local v5 = v4 and v4:FindFirstChildOfClass("Animator");

        if v5 then
            return v5;
        end;

        local v6 = v3:FindFirstChildOfClass("AnimationController");
        local v7 = v6 and v6:FindFirstChildOfClass("Animator");

        if v7 then
            return v7;
        end;
    end;

    if p2:IsA("Humanoid") then
        local v8 = p2:FindFirstChildOfClass("Animator");
        local v9 = `Missing Animator under {p2:GetFullName()}`;
        assert(v8 ~= nil, v9);

        return v8;
    end;

    if p2:IsA("AnimationController") then
        local v10 = p2:FindFirstChildOfClass("Animator");
        local v11 = `Missing Animator under {p2:GetFullName()}`;
        assert(v10 ~= nil, v11);

        return v10;
    end;

    local v12 = p2:FindFirstChildOfClass("Animator");

    if v12 then
        return v12;
    end;

    local v13 = p2:FindFirstChildOfClass("AnimationController");

    if v13 then
        local v14 = v13:FindFirstChildOfClass("Animator");
        local v15 = `Missing Animator under {v13:GetFullName()}`;
        assert(v14 ~= nil, v15);

        return v14;
    end;

    error("No way to animate!");
end;

function u1.ResolveAnimatorFromModel(p16, p17) -- Line: 60
    if p17 ~= nil then
        p16 = p16:WaitForChild(p17);
        local v18 = p16:IsA("Model");
        local v19 = `Animation target child "{p17}" must be a Model`;
        assert(v18, v19);
    end;

    local AnimationController = p16:WaitForChild("AnimationController");
    local v20 = AnimationController:IsA("AnimationController");
    local v21 = `Missing AnimationController under {p16:GetFullName()}`;
    assert(v20, v21);
    local Animator = AnimationController:WaitForChild("Animator");
    local v22 = Animator:IsA("Animator");
    local v23 = `Missing Animator under {AnimationController:GetFullName()}`;
    assert(v22, v23);

    return Animator;
end;

function u1.ResolveOptionalAnimatorFromModel(p24, p25) -- Line: 79
    if p25 ~= nil then
        p24 = p24:FindFirstChild(p25);

        if p24 == nil then
            return nil;
        end;

        local v26 = p24:IsA("Model");
        local v27 = `Animation target child "{p25}" must be a Model`;
        assert(v26, v27);
    end;

    local AnimationController = p24:FindFirstChild("AnimationController");

    if AnimationController == nil then
        return nil;
    end;

    local v28 = AnimationController:IsA("AnimationController");
    local v29 = `Missing AnimationController under {p24:GetFullName()}`;
    assert(v28, v29);
    local Animator = AnimationController:FindFirstChild("Animator");

    if Animator == nil then
        return nil;
    end;

    local v30 = Animator:IsA("Animator");
    local v31 = `Missing Animator under {AnimationController:GetFullName()}`;
    assert(v30, v31);

    return Animator;
end;

u1.ResolveAnimator = resolveAnimator;

function u1.Play(p32, p33, p34, p35, p36, p37) -- Line: 112
    -- upvalues: resolveAnimator (copy)
    local v38 = resolveAnimator(p33);
    local v39;

    if typeof(p32) == "number" or typeof(p32) == "string" then
        v39 = Instance.new("Animation");
        v39.AnimationId = typeof(p32) == "string" and p32 and p32 or "rbxassetid://" .. tostring(p32);
    else
        v39 = p32;
    end;

    local v40 = v38:LoadAnimation(v39);

    if p35 ~= nil then
        v40.Looped = p35 == true;
    end;

    v40:Play(p36, p37, p34 or 1);

    return v40;
end;

return setmetatable(u1, {
    __call = function(p41, ...) -- Line: 140, Name: __call
        -- upvalues: u1 (copy)
        return u1.Play(...);
    end
});