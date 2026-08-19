-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");

local function _createLightningPart(p2) -- Line: 29
    local Part = Instance.new("Part");
    Part.Shape = Enum.PartType.Cylinder;
    Part.Color = p2;
    Part.Material = Enum.Material.Neon;
    Part.CanTouch = false;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.Anchored = true;
    Part.Transparency = 1;
    Part.CastShadow = false;
    Part.Parent = workspace;

    return Part;
end;

local function _oneLightning(p3, p4, p5, p6) -- Line: 52
    local v7 = CFrame.lookAt((p4 + p5) / 2, p5);
    p3.Size = Vector3.new((p4 - p5).Magnitude, p6.Y, p6.Z);
    p3:PivotTo(v7:ToWorldSpace(CFrame.Angles(0, 1.5707963267948966, 0)));
end;

local u8 = {
    Temp = {
        LightNum = 6,
        LightRandomLength = 10,
        LightSizeRangeMax = Vector3.new(4, 4, 4),
        LightSizeRangeMin = Vector3.new(0.1, 0.1, 0.1),
        LightTime = 0.5,
        LightFadeTime = 0.2,
        ShowDtTime = 0.05,
        LightColor = Color3.new(0.835294, 0.835294, 0)
    },
    ["Solo一技能"] = {
        LightNum = 4,
        LightRandomLength = 5,
        LightSizeRangeMax = Vector3.new(4, 4, 4),
        LightSizeRangeMin = Vector3.new(0.1, 0.1, 0.1),
        LightTime = 0.2,
        LightFadeTime = 0.2,
        ShowDtTime = 0.05,
        LightColor = Color3.new(0.360784, 0.701961, 1)
    },
    ["Solo二技能"] = {
        LightNum = 4,
        LightRandomLength = 5,
        LightSizeRangeMax = Vector3.new(4, 4, 4),
        LightSizeRangeMin = Vector3.new(0.1, 0.1, 0.1),
        LightTime = 0.3,
        LightFadeTime = 0.2,
        ShowDtTime = 0.025,
        LightColor = Color3.new(0.360784, 0.701961, 1)
    }
};

function v1.CreateLightning(p9, p10, p11) -- Line: 110
    -- upvalues: u8 (copy), Debris (copy), RunService (copy), TweenService (copy), _oneLightning (copy)
    local v12 = p11 or "Temp";
    local v13 = u8[v12];

    if not v13 then
        warn("未知的闪电类型:", v12);

        return;
    end;

    local LightNum = v13.LightNum;
    local LightColor = v13.LightColor;
    local LightRandomLength = v13.LightRandomLength;
    local LightSizeRangeMin = v13.LightSizeRangeMin;
    local LightSizeRangeMax = v13.LightSizeRangeMax;
    local LightTime = v13.LightTime;
    local LightFadeTime = v13.LightFadeTime;
    local ShowDtTime = v13.ShowDtTime;
    local u14 = CFrame.lookAt(p9, p10);
    local u15 = (p9 - p10).Magnitude / LightNum;
    local u16 = {};

    for i = 1, LightNum do
        local Part = Instance.new("Part");
        Part.Shape = Enum.PartType.Cylinder;
        Part.Color = LightColor;
        Part.Material = Enum.Material.Neon;
        Part.CanTouch = false;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.Anchored = true;
        Part.Transparency = 1;
        Part.CastShadow = false;
        Part.Parent = workspace;
        u16[i] = Part;
    end;

    local u17 = nil;
    local u18 = 0;
    local u19 = false;
    local u20 = nil;

    local function _cleanupLightning() -- Line: 147
        -- upvalues: u19 (ref), u20 (ref), u16 (copy), Debris (ref)
        if u19 then
            return;
        end;

        u19 = true;

        if u20 then
            u20:Disconnect();
            u20 = nil;
        end;

        for _, v in pairs(u16) do
            Debris:AddItem(v, 0);
        end;

        table.clear(u16);
    end;

    u20 = RunService.Heartbeat:Connect(function(p21) -- Line: 162
        -- upvalues: u19 (ref), u18 (ref), LightTime (copy), LightFadeTime (copy), _cleanupLightning (copy), ShowDtTime (copy), LightNum (copy), u16 (copy), u14 (copy), LightRandomLength (copy), u15 (copy), u17 (ref), LightSizeRangeMin (copy), LightSizeRangeMax (copy), TweenService (ref), _oneLightning (ref)
        if u19 then
            return;
        end;

        if u18 >= LightTime + LightFadeTime then
            _cleanupLightning();

            return;
        end;

        local v22 = math.floor(u18 / ShowDtTime);

        for i = 1, LightNum do
            if i <= v22 then
                u16[i].Transparency = 0;
            end;

            local v23;

            if i == 1 then
                v23 = u14:ToWorldSpace(CFrame.new(LightRandomLength * (1 - 2 * math.random()), LightRandomLength * (1 - 2 * math.random()), -u15 * (i - 1)));
            else
                v23 = u17;
            end;

            local v24 = u14:ToWorldSpace(CFrame.new(LightRandomLength * (1 - 2 * math.random()), LightRandomLength * (1 - 2 * math.random()), -u15 * i));
            u17 = v24;
            local v25 = LightSizeRangeMin.Y + math.random() * (LightSizeRangeMax.Y - LightSizeRangeMin.Y);
            local v26 = LightSizeRangeMin.Z + math.random() * (LightSizeRangeMax.Z - LightSizeRangeMin.Z);
            local v27 = Vector3.new(1, v25, v26);

            if LightTime <= u18 then
                v27 = v27 * (1 - TweenService:GetValue(math.clamp((u18 - LightTime) / LightFadeTime, 0, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.Out));
            end;

            _oneLightning(u16[i], v23.Position, v24.Position, v27);
        end;

        u18 = u18 + p21;
    end);
end;

return v1;