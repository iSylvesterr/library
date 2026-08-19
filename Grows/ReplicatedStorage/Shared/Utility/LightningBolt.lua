-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local v1 = {};
local u2 = {
    bolts = 1,
    points = 20,
    minWidth = 6,
    maxWidth = 10,
    fadeTime = 0.15,
    growMin = 1,
    growMax = 2,
    jitter = 5,
    color = Color3.fromRGB(180, 210, 255)
};

local function drawSegment(p3, p4, p5, p6, p7, u8, p9) -- Line: 40
    -- upvalues: TweenService (copy)
    local v10 = math.random(p9.Min * 10, p9.Max * 10) * 0.01;
    local Magnitude = (p4 - p3).Magnitude;
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = p7;
    Part.Size = Vector3.new(p6, p6, Magnitude);
    Part.CFrame = CFrame.lookAt(p3, p4) * CFrame.new(0, 0, -Magnitude / 2);
    Part.Parent = p5;
    TweenService:Create(Part, TweenInfo.new(0.055, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, 2, true), {
        Size = Part.Size + Vector3.new(v10, v10, 0)
    }):Play();
    task.delay(0.25, function() -- Line: 62
        -- upvalues: TweenService (ref), Part (copy), u8 (copy), Magnitude (copy)
        TweenService:Create(Part, TweenInfo.new(u8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Transparency = 1,
            Size = Vector3.new(0, 0, Magnitude)
        }):Play();
    end);
end;

function v1.strike(u11, u12, p13) -- Line: 71
    -- upvalues: u2 (copy), Debris (copy), drawSegment (copy)
    local v14 = p13 or {};
    local u15 = v14.color or u2.color;
    local v16 = v14.bolts or u2.bolts;
    local u17 = v14.points or u2.points;
    local u18 = v14.minWidth or u2.minWidth;
    local u19 = v14.maxWidth or u2.maxWidth;
    local u20 = v14.fadeTime or u2.fadeTime;
    local u21 = v14.jitter or u2.jitter;

    if (u12 - u11).Magnitude < 1 then
        return;
    end;

    local u22 = NumberRange.new(v14.growMin or u2.growMin, v14.growMax or u2.growMax);

    for _ = 1, v16 do
        task.spawn(function() -- Line: 88
            -- upvalues: Debris (ref), u20 (copy), u18 (copy), u19 (copy), u17 (copy), u21 (copy), u11 (copy), u12 (copy), drawSegment (ref), u15 (copy), u22 (copy)
            local Model = Instance.new("Model");
            Model.Parent = workspace;
            Debris:AddItem(Model, u20 + 2);
            local v23 = math.random(u18 * 10, u19 * 10) * 0.01;
            local v24 = table.create(u17);

            for i = 1, u17 do
                local v25 = math.random(-u21, u21);
                local v26 = math.random(-u21, u21);
                local v27 = Vector3.new(v25, v26, math.random(-u21, u21));
                v24[i] = u11:Lerp(u12, (i - 1) / (u17 - 1)) + ((i == 1 or i == u17) and Vector3.new(0, 0, 0) or v27);
            end;

            for i = 1, #v24 - 1 do
                local v28 = v23 * (math.random(80, 120) * 0.01);
                drawSegment(v24[i], v24[i + 1], Model, v28, u15, u20, u22);
            end;
        end);
    end;
end;

return v1;