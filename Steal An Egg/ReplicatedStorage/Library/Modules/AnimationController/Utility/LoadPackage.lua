-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local InsertService = game:GetService("InsertService");
local Players = game:GetService("Players");
local u1 = {
    fall = "Freefall",
    jump = "Jumping",
    run = "Run",
    walk = "Walk",
    idle = "Idle",
    sit = "Seated",
    swim = "Swimming",
    swimidle = "SwimIdle",
    climb = "Climbing"
};

local function loadAnimations(p2, p3) -- Line: 18
    -- upvalues: InsertService (copy), u1 (copy)
    if p3 == 0 then
        return;
    end;

    for _, descendant in InsertService:LoadAsset(p3):GetDescendants() do
        if descendant:IsA("Animation") then
            local v4 = not descendant:FindFirstChild("Weight") and 10 or descendant.Weight.Value;
            local v5 = u1[descendant.Parent.Name];
            p2[v5] = p2[v5] or {};
            local v6 = p2[v5];
            local v7 = {
                id = string.match(descendant.AnimationId, "http://www.roblox.com/asset/%?id%=(%d+)"),
                weight = v4
            };
            table.insert(v6, v7);
        end;
    end;
end;

local function loadEmoteAnimations(p8) -- Line: 44
    -- upvalues: InsertService (copy)
    if p8 ~= 0 then
        local v9 = {};

        for _, descendant in InsertService:LoadAsset(p8):GetDescendants() do
            if descendant:IsA("Animation") then
                local v10 = not descendant:FindFirstChild("Weight") and 10 or descendant.Weight.Value;
                local v11 = {
                    looped = false,
                    id = string.match(descendant.AnimationId, "http://www.roblox.com/asset/%?id%=(%d+)"),
                    weight = v10
                };
                table.insert(v9, v11);
            end;
        end;

        return v9;
    end;
end;

local u12 = {};
local u13 = {};

local function getPlayerAnimPackage(p14) -- Line: 75
    -- upvalues: u12 (copy), loadAnimations (copy)
    if u12[p14] then
        return;
    end;

    local Character = p14.Character;

    if not Character then
        return;
    end;

    local v15 = Character:FindFirstChildWhichIsA("HumanoidDescription", true);

    if v15 then
        u12[p14] = os.clock();
        local v16 = {};
        loadAnimations(v16, v15.RunAnimation);
        loadAnimations(v16, v15.WalkAnimation);
        loadAnimations(v16, v15.ClimbAnimation);
        loadAnimations(v16, v15.SwimAnimation);
        loadAnimations(v16, v15.JumpAnimation);
        loadAnimations(v16, v15.FallAnimation);

        return v16;
    end;
end;

local function getPlayerEmotePackage(p17) -- Line: 103
    -- upvalues: u13 (copy), Players (copy), loadEmoteAnimations (copy)
    if not u13[p17] then
        local v18 = {};

        for _, v in Players:GetCharacterAppearanceInfoAsync(p17.UserId).emotes do
            v18[v.assetName] = loadEmoteAnimations(v.assetId);
        end;

        return v18;
    end;
end;

local function cooldownLoop(p19) -- Line: 118
    while task.wait(5) do
        for i, v in p19 do
            if os.clock() - v > script.Parent.Parent:GetAttribute("AsyncRequestCooldown") then
                p19[i] = nil;
            end;
        end;
    end;
end;

if not RunService:IsServer() then
    return nil;
end;

task.spawn(cooldownLoop, u12);
task.spawn(cooldownLoop, u13);

return {
    getPlayerAnimPackage = getPlayerAnimPackage,
    getPlayerEmotePackage = getPlayerEmotePackage
};