-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
require(ReplicatedStorage.Database.Custom.Types);
local SprayPatterns = ReplicatedStorage.Database.Custom.Weapons.SprayPatterns;
local u1 = {};

local function quadraticBezier(p2, p3, p4, p5) -- Line: 26
    local v6 = 1 - p5;

    return v6 * v6 * p2 + v6 * 2 * p5 * p3 + p5 * p5 * p4;
end;

local function cubicBezier(p7, p8, p9, p10, p11) -- Line: 34
    local v12 = 1 - p11;
    local v13 = p11 * p11;
    local v14 = v12 * v12;

    return v14 * v12 * p7 + v14 * 3 * p11 * p8 + v12 * 3 * v13 * p9 + v13 * p11 * p10;
end;

local function getPositionOnPath(p15, p16) -- Line: 49
    if #p15 == 2 then
        return p15[1]:Lerp(p15[2], p16);
    end;

    if #p15 == 3 then
        local v17 = 1 - p16;

        return v17 * v17 * p15[1] + v17 * 2 * p16 * p15[2] + p16 * p16 * p15[3];
    end;

    if #p15 ~= 4 then
        return Vector2.zero;
    end;

    local v18 = 1 - p16;
    local v19 = p16 * p16;
    local v20 = v18 * v18;

    return v20 * v18 * p15[1] + v20 * 3 * p16 * p15[2] + v18 * 3 * v19 * p15[3] + v19 * p16 * p15[4];
end;

local function getKeyframeAtTime(p21, p22) -- Line: 61
    local v23 = 0;

    for _, v in ipairs(p21) do
        local Duration = v.Duration;
        local v24 = v23 + Duration;

        if p22 <= v24 then
            return v, math.clamp((p22 - v23) / Duration, 0, 1);
        end;

        v23 = v24;
    end;

    return nil, nil;
end;

local function getSequenceDuration(p25) -- Line: 78
    local v26 = 0;

    for _, v in ipairs(p25) do
        v26 = v26 + v.Duration;
    end;

    return v26;
end;

local function CreatePattern(p27, p28) -- Line: 91
    -- upvalues: SprayPatterns (copy)
    local FireRate = p28.FireRate;
    local Rounds = p28.Rounds;
    local v29 = {};
    local v30 = SprayPatterns:FindFirstChild(p27);

    if not v30 then
        warn(string.format("%s has no spray pattern part", p27));

        return nil;
    end;

    if #v30:GetChildren() ~= Rounds then
        warn(string.format("%s spray pattern points not equal to magazine size", p27), Rounds, #v30:GetChildren());
    end;

    local v31 = v30[tostring(1)];

    for i = 1, Rounds do
        local v32 = v30[tostring(i)];
        local zero = Vector2.zero;
        local zero2 = Vector2.zero;

        if i > 1 then
            local Position = (v31.WorldCFrame:Inverse() * v30[tostring(i - 1)].WorldCFrame).Position;
            zero = Vector2.new(Position.X, Position.Y);
            local Position2 = (v31.WorldCFrame:Inverse() * v32.WorldCFrame).Position;
            zero2 = Vector2.new(Position2.X, Position2.Y);
        end;

        table.insert(v29, {
            Duration = 1 * FireRate,
            EasingStyle = Enum.EasingStyle.Linear,
            EasingDirection = Enum.EasingDirection.In,
            Path = { zero * 0.5, zero2 * 0.5 }
        });
    end;

    return v29;
end;

local function AppendPattern(u33) -- Line: 133
    -- upvalues: u1 (copy), CreatePattern (copy), getKeyframeAtTime (copy), TweenService (copy), getPositionOnPath (copy)
    u1[u33] = function(p34) -- Line: 134
        -- upvalues: CreatePattern (ref), u33 (copy), getKeyframeAtTime (ref), TweenService (ref), getPositionOnPath (ref)
        local _ = p34.FireRate * p34.Rounds;
        local u35 = CreatePattern(u33, p34);
        local u36 = 0;

        for _, v in ipairs(u35) do
            u36 = u36 + v.Duration;
        end;

        return function(p37) -- Line: 143
            -- upvalues: u36 (copy), getKeyframeAtTime (ref), u35 (copy), TweenService (ref), getPositionOnPath (ref)
            local v38, v39 = getKeyframeAtTime(u35, (math.clamp(p37, 0, u36)));
            local v40 = TweenService:GetValue(v39, v38.EasingStyle, v38.EasingDirection);

            return getPositionOnPath(v38.Path, v40);
        end;
    end;
end;

for _, child in ipairs(SprayPatterns:GetChildren()) do
    local Name = child.Name;

    u1[Name] = function(p41) -- Line: 134
        -- upvalues: CreatePattern (copy), Name (copy), getKeyframeAtTime (copy), TweenService (copy), getPositionOnPath (copy)
        local _ = p41.FireRate * p41.Rounds;
        local u42 = CreatePattern(Name, p41);
        local u43 = 0;

        for _, v in ipairs(u42) do
            u43 = u43 + v.Duration;
        end;

        return function(p44) -- Line: 143
            -- upvalues: u43 (copy), getKeyframeAtTime (ref), u42 (copy), TweenService (ref), getPositionOnPath (ref)
            local v45, v46 = getKeyframeAtTime(u42, (math.clamp(p44, 0, u43)));
            local v47 = TweenService:GetValue(v46, v45.EasingStyle, v45.EasingDirection);

            return getPositionOnPath(v45.Path, v47);
        end;
    end;
end;

return u1;