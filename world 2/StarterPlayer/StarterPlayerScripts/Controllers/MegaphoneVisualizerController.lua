-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local u2 = {};
local u3 = 0;
local u4 = 0;
local u5 = 0;
local u6 = 0;

local function loudnessToScale(p7) -- Line: 52
    return math.clamp(p7 / 200, 0, 1) ^ 3 * 1 + 1;
end;

local function isMegaphone(p8) -- Line: 57
    local v9 = p8:IsA("Tool") and p8:GetAttribute("Megaphone") ~= nil;

    return v9;
end;

local function setScale(p10, p11, p12) -- Line: 61
    p10:ScaleTo(p11.baseScale * p12);
end;

local function register(p13) -- Line: 65
    -- upvalues: u2 (copy)
    if u2[p13] then
        return;
    end;

    u2[p13] = {
        scale = 1,
        baseScale = p13:GetScale()
    };
end;

local function unregister(p14) -- Line: 70
    -- upvalues: u2 (copy)
    local v15 = u2[p14];

    if not v15 then
        return;
    end;

    if p14.Parent then
        p14:ScaleTo(v15.baseScale * 1);
    end;

    u2[p14] = nil;
end;

local function onDescendantAdded(p16) -- Line: 79
    -- upvalues: u2 (copy)
    local v17 = p16:IsA("Tool") and p16:GetAttribute("Megaphone") ~= nil;

    if v17 then
        if u2[p16] then
            return;
        end;

        u2[p16] = {
            scale = 1,
            baseScale = p16:GetScale()
        };
    end;
end;

local function update(p18) -- Line: 85
    -- upvalues: u2 (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref)
    for i, v in u2 do
        if i.Parent and i:IsDescendantOf(workspace) then
            local MegaphoneSound = i:FindFirstChild("MegaphoneSound", true);
            local v19 = 0;

            if MegaphoneSound then
                v19 = MegaphoneSound:IsA("Sound") and (MegaphoneSound.PlaybackLoudness or 0) or v19;
            end;

            if v19 > 0 then
                u3 = u3 + v19;
                u4 = u4 + 1;

                if u5 < v19 then
                    u5 = v19;
                end;
            end;

            local v20 = math.clamp(v19 / 200, 0, 1) ^ 3 * 1 + 1;
            local v21 = 1 - math.exp(p18 * -15);
            v.scale = v.scale + (v20 - v.scale) * v21;
            i:ScaleTo(v.baseScale * v.scale);
        else
            local v22 = u2[i];

            if v22 then
                if i.Parent then
                    i:ScaleTo(v22.baseScale * 1);
                end;

                u2[i] = nil;
            end;
        end;
    end;

    local v23 = os.clock();

    if v23 - u6 >= 1 then
        u6 = v23;

        if u4 > 0 then
            local v24 = u3 / u4;
            print(string.format("%s avg loudness=%.1f (scale %.2fx)  peak=%.1f (scale %.2fx)  samples=%d  [ref=%d exp=%d range %.0f..%.0f]", "[Megaphone/Visualizer]", v24, math.clamp(v24 / 200, 0, 1) ^ 3 * 1 + 1, u5, math.clamp(u5 / 200, 0, 1) ^ 3 * 1 + 1, u4, 200, 3, 1, 2));
        end;

        u3 = 0;
        u4 = 0;
        u5 = 0;
    end;
end;

function v1.Init(p25) -- Line: 136
end;

function v1.Start(p26) -- Line: 139
    -- upvalues: u2 (copy), onDescendantAdded (copy), RunService (copy), update (copy)
    for _, descendant in workspace:GetDescendants() do
        local v27 = descendant:IsA("Tool") and descendant:GetAttribute("Megaphone") ~= nil;

        if v27 then
            if not u2[descendant] then
                u2[descendant] = {
                    scale = 1,
                    baseScale = descendant:GetScale()
                };
            end;
        end;
    end;

    workspace.DescendantAdded:Connect(onDescendantAdded);
    RunService.RenderStepped:Connect(update);
end;

return v1;