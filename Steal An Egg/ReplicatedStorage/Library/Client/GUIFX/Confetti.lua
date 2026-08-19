-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Functions = require(Library.Functions);
local Audio = require(Library.Audio);
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(Library.Functions.RenderStepped);
local v1 = {};
local u2 = {
    Color3.fromRGB(168, 100, 253),
    Color3.fromRGB(41, 205, 255),
    Color3.fromRGB(120, 255, 68),
    Color3.fromRGB(255, 85, 85),
    Color3.fromRGB(253, 255, 106)
};
local u3 = { "rbxassetid://135524199765808" };

function v1.Play(p4) -- Line: 35
    -- upvalues: Asserts (copy), u2 (copy), Functions (copy), Audio (copy), u3 (copy)
    Asserts.optional.table(p4);
    local v5 = p4 or {};
    local u6 = v5.Duration or 5;
    local v7 = v5.VolumeScale or 1;
    local v8 = v5.RateScale or 1;
    local v9 = v5.SpeedScale or 1;
    local v10 = v5.SizeScale or 1;
    local Texture = v5.Texture;
    local v11 = v5.PopUp ~= false;
    local v12 = v5.PopSounds ~= false;
    local v13 = v5.Colors or u2;
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    local v14, v15 = Functions.ComputeScreenSpacePart(5, 1);
    Part.CFrame = v14;
    Part.Size = v15;
    local v16 = Functions.Scaler();
    local u17 = {};
    local v18 = 0;

    for _, v in ipairs(v13) do
        local v19 = script:WaitForChild("ParticleEmitter"):Clone();
        table.insert(u17, v19);
        v18 = math.max(v18, v19.Lifetime.Max / v19.TimeScale);
        v19.Color = ColorSequence.new(v);

        if Texture ~= nil and Texture ~= "" then
            v19.Texture = Texture;
        end;

        v19.ZOffset = v19.ZOffset + (math.random() * 2 - 1) * 0.1;
        v19.Rate = Functions.FixParticleRate(v19.Rate * v8, Part.Position);
        local Speed = v19.Speed;
        v19.Speed = NumberRange.new(Speed.Min * v9, Speed.Max * v9);

        if v10 ~= 1 then
            v16(v19, v10);
        end;

        v19.Enabled = false;
        v19.Parent = Part;
    end;

    Part.Parent = workspace.CurrentCamera;
    local u20 = 0;
    local u21 = false;

    if v11 then
        u20 = 0.75;

        for _, v in ipairs(u17) do
            local v22 = (v:GetAttribute("EmitCount") or 0) * v8;
            local v23 = math.round(v22);

            if v23 > 0 then
                local v24 = v:Clone();
                v24.EmissionDirection = Enum.NormalId.Bottom;
                v24.Speed = NumberRange.new(-30, -20);
                v24.Drag = 2.65;
                v24.Parent = Part;
                v24:Emit(v23);
            end;
        end;

        if v7 > 0 and v12 then
            Audio.Play(u3, workspace.CurrentCamera, { 0.95, 1.05 }, { 1.9 * v7, 2.1 * v7 });
        end;
    else
        u21 = true;

        for _, v in ipairs(u17) do
            v.Enabled = true;
        end;
    end;

    return Functions.RenderStepped(function(p25, p26) -- Line: 125
        -- upvalues: Functions (ref), Part (copy), u20 (ref), u6 (copy), u21 (ref), u17 (copy)
        local v27, v28 = Functions.ComputeScreenSpacePart(5, 1);
        Part.CFrame = v27;
        Part.Size = v28;
        local v29 = u20 <= p26 and p26 < u20 + u6;

        if u21 ~= v29 then
            u21 = v29;

            for _, v in ipairs(u17) do
                v.Enabled = v29;
            end;
        end;
    end, u20 + u6 + v18):Then(function() -- Line: 145
        -- upvalues: Part (copy)
        Part:Destroy();
    end);
end;

return v1;