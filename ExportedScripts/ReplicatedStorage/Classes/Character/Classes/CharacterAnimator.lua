-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CharacterAnimations = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("CharacterAnimations");

local function GetCharacterHumanoid(p2) -- Line: 27
    local v3 = p2:FindFirstChildOfClass("Humanoid");
    local v4 = tick();

    while not v3 do
        v3 = p2:FindFirstChildOfClass("Humanoid");
        task.wait(0.1);

        if tick() - v4 > 5 then
            break;
        end;
    end;

    return v3;
end;

function u1.getAnimation(p5, p6) -- Line: 46
    return p5.Animations[p6];
end;

function u1.adjustAnimationSpeed(p7, p8, p9) -- Line: 52
    local v10 = p7:getAnimation(p8);

    if not v10 then
        return;
    end;

    v10:AdjustSpeed(v10.Length / p9);
end;

function u1.play(p11, p12, ...) -- Line: 63
    local v13 = p11:getAnimation(p12);
    p11.CurrentAnimation = p12;

    if v13 then
        v13:Play(...);

        return v13;
    end;

    local v14 = {};

    for i in pairs(p11.Animations) do
        table.insert(v14, i);
    end;

    return nil;
end;

function u1.stop(p15, p16, ...) -- Line: 85
    local v17 = p15:getAnimation(p16);

    if not (v17 and v17.IsPlaying) then
        return;
    end;

    v17:Stop(...);
end;

function u1.stopAnimations(p18) -- Line: 96
    for _, v in pairs(p18.Animations) do
        if v.IsPlaying then
            v:Stop();
        end;
    end;
end;

function u1.unregister(p19, p20) -- Line: 106
    if p19.Animations[p20] then
        local v21 = p19.Animations[p20];

        if v21.IsPlaying then
            v21:Stop();
        end;

        if p19.Janitor then
            p19.Janitor:Remove(p20);
        end;

        p19.Animations[p20] = nil;
        v21:Destroy();
    end;
end;

function u1.unregisterGroup(p22, ...) -- Line: 125
    for _, v in ipairs({ ... }) do
        p22:unregister(v);
    end;
end;

function u1.register(u23, p24, u25) -- Line: 133
    u23:unregister(p24);
    local success, result = pcall(function() -- Line: 136
        -- upvalues: u23 (copy), u25 (copy)
        return u23.Animator:LoadAnimation(u25);
    end);

    if not success then
        return;
    end;

    u23.Animations[p24] = result;
    u23.Janitor:Add(result, "Destroy", p24);
end;

function u1.construct(p26, p27) -- Line: 149
    -- upvalues: GetCharacterHumanoid (copy), CharacterAnimations (copy)
    local v28 = GetCharacterHumanoid(p27);

    if v28 then
        p26.Animator = v28:WaitForChild("Animator");

        for _, descendant in ipairs(CharacterAnimations:GetDescendants()) do
            if descendant:IsA("Animation") then
                p26:register(descendant.Name, descendant);
            end;
        end;
    end;
end;

function u1.new(p29) -- Line: 166
    -- upvalues: u1 (copy), Janitor (copy)
    local v30 = setmetatable({}, u1);
    v30.Janitor = Janitor.new();
    v30.Animator = nil;
    v30.CurrentAnimation = nil;
    v30.IsDestroyed = false;
    v30.Animations = {};
    v30:construct(p29);

    return v30;
end;

function u1.destroy(p31) -- Line: 192
    if not p31.IsDestroyed then
        p31.IsDestroyed = true;
        p31:stopAnimations();
        local v32 = {};

        for i in pairs(p31.Animations) do
            table.insert(v32, i);
        end;

        for _, v in ipairs(v32) do
            p31:unregister(v);
        end;

        for i, v in pairs(p31.Animations) do
            if v then
                if v.IsPlaying then
                    v:Stop();
                end;

                pcall(function() -- Line: 221
                    -- upvalues: v (copy)
                    v:Destroy();
                end);
            end;

            p31.Animations[i] = nil;
        end;

        table.clear(p31.Animations);

        if p31.Janitor then
            p31.Janitor:Destroy();
            p31.Janitor = nil;
        end;

        p31.CurrentAnimation = nil;
        p31.Animator = nil;
    end;
end;

return u1;