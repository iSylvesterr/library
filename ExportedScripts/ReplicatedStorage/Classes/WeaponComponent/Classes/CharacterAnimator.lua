-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Janitor = require(ReplicatedStorage.Shared.Janitor);

function u1.getAnimation(p2, p3) -- Line: 23
    return p2.Animations[p3];
end;

function u1.adjustAnimationSpeed(p4, p5, p6) -- Line: 29
    local v7 = p4:getAnimation(p5);

    if v7 then
        v7:AdjustSpeed(v7.Length / p6);
    end;
end;

function u1.play(p8, p9, ...) -- Line: 39
    local v10 = p8:getAnimation(p9);
    p8.CurrentAnimation = p9;

    if v10 then
        v10:Play(...);
    end;

    return v10;
end;

function u1.stop(p11, p12, p13) -- Line: 52
    local v14 = p11:getAnimation(p12);

    if v14 and v14.IsPlaying then
        v14:Stop(p13);
    end;
end;

function u1.stopAnimations(p15, p16) -- Line: 60
    for _, v in pairs(p15.Animations) do
        if v.IsPlaying then
            v:Stop(p16 or 0);
        end;
    end;
end;

function u1.unregister(p17, p18) -- Line: 70
    if not p17.Animations[p18] then
        return;
    end;

    local v19 = p17.Animations[p18];

    if v19 then
        if v19.IsPlaying then
            v19:Stop();
        end;

        v19:Destroy();
        p17.Animations[p18] = nil;
    end;

    p17.Janitor:Remove(p18);
end;

function u1.unregisterGroup(p20, ...) -- Line: 91
    for _, v in ipairs({ ... }) do
        p20:unregister(v);
    end;
end;

function u1.register(u21, u22, u23) -- Line: 99
    u21:unregister(u22);
    local success, result = pcall(function() -- Line: 102
        -- upvalues: u21 (copy), u23 (copy)
        return u21.Animator:LoadAnimation(u23);
    end);

    if success then
        u21.Animations[u22] = result;
        u21.Janitor:Add(function() -- Line: 112
            -- upvalues: u21 (copy), u22 (copy)
            if not u21.IsDestroyed then
                u21:unregister(u22);
            end;
        end, true, u22);
    end;
end;

function u1.construct(p24) -- Line: 122
    -- upvalues: GetWeaponProperties (copy)
    if p24.Animator then
        p24:stopAnimations();
        table.clear(p24.Animations);
        p24.Animator = nil;
    end;

    local Character = p24.Player.Character;

    if Character and Character:IsDescendantOf(workspace) then
        local v25 = Character:FindFirstChildWhichIsA("Humanoid", true);

        if not v25 then
            warn((`[CharacterAnimator] Failed to find Humanoid for {p24.Player.Name}`));

            return;
        end;

        p24.Animator = v25:WaitForChild("Animator", 3);

        if not p24.Animator then
            warn((`[CharacterAnimator] Failed to find Animator for {p24.Player.Name}`));

            return;
        end;

        local v26 = GetWeaponProperties(p24.Weapon);

        if v26 and v26.CharacterAnimations then
            for _, child in ipairs(v26.CharacterAnimations:GetChildren()) do
                if child:IsA("Animation") then
                    p24:register(child.Name, child);
                end;
            end;
        end;
    end;
end;

function u1.new(p27, p28) -- Line: 164
    -- upvalues: u1 (copy), Janitor (copy)
    local u29 = setmetatable({}, u1);
    u29.Janitor = Janitor.new();
    u29.IsDestroyed = false;
    u29.Player = p27;
    u29.Animator = nil;
    u29.CurrentAnimation = nil;
    u29.Weapon = p28;
    u29.Animations = {};

    if p27.Character and p27.Character:IsDescendantOf(workspace) then
        u29:construct();
    end;

    u29.Janitor:Add(p27.CharacterAdded:Connect(function() -- Line: 193
        -- upvalues: u29 (copy)
        u29:construct();
    end));

    return u29;
end;

function u1.destroy(p30) -- Line: 204
    if p30.IsDestroyed then
        return;
    end;

    p30.IsDestroyed = true;
    p30:stopAnimations();
    local v31 = {};

    for i, _ in pairs(p30.Animations) do
        table.insert(v31, i);
    end;

    for _, v in ipairs(v31) do
        p30:unregister(v);
    end;

    for i, v in pairs(p30.Animations) do
        if v then
            if v.IsPlaying then
                v:Stop();
            end;

            pcall(function() -- Line: 232
                -- upvalues: v (copy)
                v:Destroy();
            end);
        end;

        p30.Animations[i] = nil;
    end;

    table.clear(p30.Animations);
    p30.Player = nil;
    p30.Animator = nil;
    p30.CurrentAnimation = nil;
    p30.Weapon = nil;
    p30.Janitor:Destroy();
    p30.Janitor = nil;
end;

return u1;