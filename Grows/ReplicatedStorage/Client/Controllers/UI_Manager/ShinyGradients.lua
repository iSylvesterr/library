-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
require(game.ReplicatedStorage.Packages.Knit);
local Maid = require(game.ReplicatedStorage.Packages.Maid);
require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local _ = game.Players.LocalPlayer;
local u1 = {};
local u2 = {};
local v3 = Color3.fromHex("#1b3071");
local v4 = Color3.fromHex("#b667ff");
local u5 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v3), ColorSequenceKeypoint.new(0.5, v4), ColorSequenceKeypoint.new(1, v3) });
local v6 = Color3.fromHex("#050505");
local v7 = Color3.fromHex("#9d90b0");
local u8 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v6), ColorSequenceKeypoint.new(0.5, v7), ColorSequenceKeypoint.new(1, v6) });
local v9 = Color3.fromHex("#ffe878");
local v10 = Color3.fromHex("#fffff2");
local u11 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v9), ColorSequenceKeypoint.new(0.5, v10), ColorSequenceKeypoint.new(1, v9) });
local v12 = Color3.fromHex("#7bfcfc");
local v13 = Color3.fromHex("#fffff2");
local v14 = Color3.fromHex("#33abe8");
local u15 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, v12),
    ColorSequenceKeypoint.new(0.3, v13),
    ColorSequenceKeypoint.new(0.5, v14),
    ColorSequenceKeypoint.new(0.7, v13),
    ColorSequenceKeypoint.new(1, v12)
});
local v16 = Color3.fromHex("#5E3D26");
local v17 = Color3.fromHex("#6E9A47");
local v18 = Color3.fromHex("#C2B070");
local u19 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, v16),
    ColorSequenceKeypoint.new(0.3, v17),
    ColorSequenceKeypoint.new(0.5, v18),
    ColorSequenceKeypoint.new(0.7, v17),
    ColorSequenceKeypoint.new(1, v16)
});
local v20 = Color3.fromHex("#F2E8C9");
local v21 = Color3.fromHex("#5BC6FF");
local v22 = Color3.fromHex("#FFFFFF");
local u23 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, v20),
    ColorSequenceKeypoint.new(0.3, v21),
    ColorSequenceKeypoint.new(0.5, v22),
    ColorSequenceKeypoint.new(0.7, v21),
    ColorSequenceKeypoint.new(1, v20)
});
local v24 = Color3.new(1, 0, 0);
local v25 = Color3.new(1, 0.5, 0);
local v26 = Color3.new(1, 1, 0);
local v27 = Color3.new(0, 1, 0);
local v28 = Color3.new(0, 1, 1);
local v29 = Color3.new(0, 0.5, 1);
local v30 = Color3.new(0, 0, 1);
local v31 = Color3.new(0.5, 0, 1);
local v32 = Color3.new(1, 0, 1);
local u33 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, v24),
    ColorSequenceKeypoint.new(0.1111111111111111, v25),
    ColorSequenceKeypoint.new(0.2222222222222222, v26),
    ColorSequenceKeypoint.new(0.3333333333333333, v27),
    ColorSequenceKeypoint.new(0.4444444444444444, v28),
    ColorSequenceKeypoint.new(0.5555555555555556, v29),
    ColorSequenceKeypoint.new(0.6666666666666666, v30),
    ColorSequenceKeypoint.new(0.7777777777777778, v31),
    ColorSequenceKeypoint.new(0.8888888888888888, v32),
    ColorSequenceKeypoint.new(1, v24)
});

local function evalColorSequence(p34, p35) -- Line: 111
    if p35 == 0 then
        return p34.Keypoints[1].Value;
    end;

    if p35 == 1 then
        return p34.Keypoints[#p34.Keypoints].Value;
    end;

    for i = 1, #p34.Keypoints - 1 do
        local v36 = p34.Keypoints[i];
        local v37 = p34.Keypoints[i + 1];

        if v36.Time <= p35 and p35 < v37.Time then
            local v38 = (p35 - v36.Time) / (v37.Time - v36.Time);

            return Color3.new((v37.Value.R - v36.Value.R) * v38 + v36.Value.R, (v37.Value.G - v36.Value.G) * v38 + v36.Value.G, (v37.Value.B - v36.Value.B) * v38 + v36.Value.B);
        end;
    end;
end;

local function u41(p39, p40) -- Line: 137
    return p39.Time < p40.Time;
end;

return function(u42) -- Line: 141
    -- upvalues: TweenService (copy), u1 (copy), Maid (copy), u5 (copy), u11 (copy), u8 (copy), u15 (copy), u19 (copy), u23 (copy), evalColorSequence (copy), u41 (copy), u33 (copy), u2 (copy), RunService (copy)
    u42.GRADIENTS = {
        CELESTIAL = "CELESTIAL",
        SECRET = "SECRET",
        DIVINE = "DIVINE",
        CHARGED = "CHARGED",
        ANCIENT = "ANCIENT",
        TRANSCENDENT = "TRANSCENDENT"
    };
    local NumberValue = Instance.new("NumberValue", script);
    TweenService:Create(NumberValue, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
        Value = 1
    }):Play();
    local NumberValue2 = Instance.new("NumberValue", script);
    TweenService:Create(NumberValue2, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
        Value = 1
    }):Play();

    function u42.SetupShinyGradient(p43, u44, p45) -- Line: 168
        -- upvalues: u1 (ref), Maid (ref), u42 (copy), u5 (ref), u11 (ref), u8 (ref), u15 (ref), u19 (ref), u23 (ref), NumberValue (copy), evalColorSequence (ref), u41 (ref)
        if not u44 then
            return;
        end;

        if not u1[u44] then
            u1[u44] = {};
            u1[u44].maid = Maid.new();
            local u46 = nil;

            if p45 == u42.GRADIENTS.CELESTIAL then
                u46 = u5;
            elseif p45 == u42.GRADIENTS.DIVINE then
                u46 = u11;
            elseif p45 == u42.GRADIENTS.SECRET then
                u46 = u8;
            elseif p45 == u42.GRADIENTS.CHARGED then
                u46 = u15;
            elseif p45 == u42.GRADIENTS.ANCIENT then
                u46 = u19;
            elseif p45 == u42.GRADIENTS.TRANSCENDENT then
                u46 = u23;
            end;

            u1[u44].maid:GiveTask(NumberValue.Changed:Connect(function(p47) -- Line: 190
                -- upvalues: evalColorSequence (ref), u46 (ref), u41 (ref), u44 (copy)
                local v48 = math.clamp((p47 + 0) % 1, 0.01, 0.99);
                local v49 = math.clamp((p47 + 0.5) % 1, 0.01, 0.99);
                local v50 = {
                    ColorSequenceKeypoint.new(0, evalColorSequence(u46, v48)),
                    ColorSequenceKeypoint.new(v48, evalColorSequence(u46, 0)),
                    ColorSequenceKeypoint.new(v49, evalColorSequence(u46, 0.5)),
                    ColorSequenceKeypoint.new(1, evalColorSequence(u46, 1 - v48))
                };
                table.sort(v50, u41);
                u44.Color = ColorSequence.new(v50);
            end));
            u1[u44].maid:GiveTask(function() -- Line: 206
            end);

            return u1[u44];
        end;
    end;

    function u42.SetupRainbowShinyGradient(p51, u52, u53, p54) -- Line: 212
        -- upvalues: u1 (ref), Maid (ref), u33 (ref), NumberValue2 (copy), u42 (copy), u23 (ref), NumberValue (copy), u19 (ref), evalColorSequence (ref)
        if not u52 then
            return;
        end;

        if not u1[u52] then
            u1[u52] = {};
            u1[u52].maid = Maid.new();
            local u55 = u33;
            local v56 = NumberValue2;
            local u57 = 1;

            if p54 == u42.GRADIENTS.TRANSCENDENT then
                u55 = u23;
                v56 = NumberValue;
                u57 = -1;
            elseif p54 == u42.GRADIENTS.ANCIENT then
                u55 = u19;
                v56 = NumberValue;
                u57 = -1;
            end;

            u1[u52].maid:GiveTask(v56.Changed:Connect(function(p58) -- Line: 233
                -- upvalues: u57 (ref), u53 (copy), evalColorSequence (ref), u55 (ref), u52 (copy)
                local v59 = p58 * u57;
                local v60 = {};

                for i = 1, 11 do
                    local v61 = math.clamp((v59 + u53 * 0.1 * i) % 1, 0.01, 0.99);
                    local v62 = (i - 1) / 10;

                    if v62 > 1 then
                        warn(v62, i);
                    end;

                    v60[i] = ColorSequenceKeypoint.new(v62, evalColorSequence(u55, v61));
                end;

                u52.Color = ColorSequence.new(v60);
            end));

            return u1[u52];
        end;
    end;

    function u42.RemoveShinyGradient(p63, p64) -- Line: 257
        -- upvalues: u1 (ref)
        if not p64 then
            return;
        end;

        if u1[p64] then
            u1[p64].maid:Destroy();
            u1[p64] = nil;
        end;
    end;

    function u42.SetupStreakShine(p65, u66, u67) -- Line: 265
        -- upvalues: u2 (ref), Maid (ref), RunService (ref), TweenService (ref)
        if not u66 then
            return;
        end;

        if not u2[u66] then
            u2[u66] = {};
            u2[u66].maid = Maid.new();
            local u68 = nil;
            u66.Position = UDim2.fromScale(0, 0);
            u66.ImageTransparency = 0.15;
            local u69 = 0;
            u2[u66].maid:GiveTask(RunService.RenderStepped:Connect(function(p70) -- Line: 278
                -- upvalues: u69 (ref), u68 (ref), u66 (copy), TweenService (ref), u67 (copy)
                u69 = u69 + p70;

                if u69 > 5 then
                    u69 = 0;

                    if u68 then
                        u68:Cancel();
                    end;

                    u66.Position = UDim2.fromScale(0, 0);
                    u68 = TweenService:Create(u66, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        Position = UDim2.fromScale(u67, 0)
                    });
                    u68:Play();
                end;
            end));
            u2[u66].maid:GiveTask(function() -- Line: 294
                -- upvalues: u68 (ref)
                if u68 then
                    u68:Cancel();
                end;
            end);

            return u2[u66];
        end;
    end;

    function u42.RemoveStreakShine(p71, p72) -- Line: 301
        -- upvalues: u2 (ref)
        if not p72 then
            return;
        end;

        if u2[p72] then
            u2[p72].maid:Destroy();
            u2[p72] = nil;
        end;
    end;
end;