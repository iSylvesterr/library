-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Bindables = game:GetService("ReplicatedStorage"):WaitForChild("Bindables");
local Gradients = script:WaitForChild("Gradients");
local u1 = RunService:IsServer();
local u2 = {
    Common = Color3.fromRGB(213, 213, 213),
    Rare = Color3.fromRGB(0, 213, 255),
    Epic = Color3.fromRGB(106, 0, 255),
    Legendary = Color3.fromRGB(250, 250, 0),
    Mythic = Color3.fromRGB(237, 0, 233),
    Divine = Color3.fromRGB(255, 157, 0),
    Godly = Color3.fromRGB(237, 0, 4),
    Secret = Color3.fromRGB(0, 0, 0),
    Limited = Color3.fromRGB(17, 255, 0),
    Exclusive = Color3.fromRGB(239, 0, 56),
    Premium = Color3.fromRGB(170, 0, 255),
    BOSS = Color3.fromRGB(195, 11, 11)
};
local u3 = {
    Godly = true
};
local u4 = {
    Secret = true
};
local u5 = Color3.new(1, 1, 1);
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};

local function applyColor(p10, p11) -- Line: 56
    local ClassName = p10.ClassName;

    if ClassName == "TextLabel" or ClassName == "TextButton" then
        p10.TextColor3 = p11;

        return;
    end;

    if ClassName == "UIStroke" then
        p10.Color = p11;

        return;
    end;

    if ClassName == "Frame" or (ClassName == "ImageButton" or ClassName == "ImageLabel") then
        p10.BackgroundColor3 = p11;

        return;
    end;

    if ClassName == "Highlight" then
        p10.FillColor = p11;
        p10.OutlineColor = p11;
    end;
end;

local function setWhite(p12) -- Line: 70
    -- upvalues: u5 (copy)
    local v13 = u5;
    local ClassName = p12.ClassName;

    if ClassName == "TextLabel" or ClassName == "TextButton" then
        p12.TextColor3 = v13;

        return;
    end;

    if ClassName == "UIStroke" then
        p12.Color = v13;

        return;
    end;

    if ClassName == "Frame" or (ClassName == "ImageButton" or ClassName == "ImageLabel") then
        p12.BackgroundColor3 = v13;

        return;
    end;

    if ClassName == "Highlight" then
        p12.FillColor = v13;
        p12.OutlineColor = v13;
    end;
end;

function u2.stopRainbow(p14) -- Line: 74
    -- upvalues: u6 (copy), u7 (copy), Bindables (copy)
    local v15 = u6[p14];

    if v15 then
        v15:Disconnect();
        u6[p14] = nil;
    end;

    if u7[p14] then
        u7[p14] = nil;
        Bindables.RemoveRainbowText:Fire(p14);
    end;
end;

local function stopGradient(p16) -- Line: 86
    -- upvalues: u8 (copy), u9 (copy), Bindables (copy)
    local v17 = u8[p16];

    if v17 then
        v17:Disconnect();
        u8[p16] = nil;
    end;

    if u9[p16] then
        u9[p16] = nil;
        Bindables.RemoveSecretGradient:Fire(p16);
    end;
end;

local function clearGradients(p18) -- Line: 98
    for _, child in p18:GetChildren() do
        if child:IsA("UIGradient") then
            child:Destroy();
        end;
    end;
end;

local function buildColorSequence(p19) -- Line: 106
    local v20 = {};

    for i = 0, 5 do
        local v21 = i / 5;
        local v22 = (math.sin((p19 + v21) * 3.141592653589793 * 2) + 1) / 2;
        local v23 = Color3.fromHSV(0, 0, v22);
        table.insert(v20, ColorSequenceKeypoint.new(v21, v23));
    end;

    return ColorSequence.new(v20);
end;

local function makeGradient(p24) -- Line: 117
    -- upvalues: buildColorSequence (copy)
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = 0;
    UIGradient.Color = buildColorSequence(0);
    UIGradient.Parent = p24;

    return UIGradient;
end;

local function animateGradient(u25) -- Line: 133
    -- upvalues: u8 (copy), u9 (copy), Bindables (copy), RunService (copy), buildColorSequence (copy)
    local v26 = u8[u25];

    if v26 then
        v26:Disconnect();
        u8[u25] = nil;
    end;

    if u9[u25] then
        u9[u25] = nil;
        Bindables.RemoveSecretGradient:Fire(u25);
    end;

    local u27 = 0;
    local u28 = 0;

    if u25:IsA("Highlight") then
        u8[u25] = RunService.Heartbeat:Connect(function(p29) -- Line: 138
            -- upvalues: u28 (ref), u27 (ref), u25 (copy), u8 (ref), u9 (ref), Bindables (ref)
            u28 = u28 + p29;

            if u28 < 0.1 then
                return;
            end;

            u27 = (u27 + u28 * 0.75) % 1;
            u28 = 0;

            if u25 and u25.Parent then
                local v30 = (math.sin(u27 * 3.141592653589793 * 2) + 1) / 2;
                local v31 = Color3.fromHSV(0, 0, v30);
                u25.FillColor = v31;
                u25.OutlineColor = v31;

                return;
            end;

            local v32 = u25;
            local v33 = u8[v32];

            if v33 then
                v33:Disconnect();
                u8[v32] = nil;
            end;

            if u9[v32] then
                u9[v32] = nil;
                Bindables.RemoveSecretGradient:Fire(v32);
            end;
        end);
    else
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Rotation = 0;
        UIGradient.Color = buildColorSequence(0);
        UIGradient.Parent = u25;
        u8[u25] = RunService.Heartbeat:Connect(function(p34) -- Line: 154
            -- upvalues: u28 (ref), u27 (ref), u25 (copy), UIGradient (copy), buildColorSequence (ref), u8 (ref), u9 (ref), Bindables (ref)
            u28 = u28 + p34;

            if u28 < 0.1 then
                return;
            end;

            u27 = (u27 + u28 * 1) % 1;
            u28 = 0;

            if u25 and u25.Parent then
                UIGradient.Color = buildColorSequence(u27);

                return;
            end;

            local v35 = u25;
            local v36 = u8[v35];

            if v36 then
                v36:Disconnect();
                u8[v35] = nil;
            end;

            if u9[v35] then
                u9[v35] = nil;
                Bindables.RemoveSecretGradient:Fire(v35);
            end;
        end);
    end;
end;

local function addToSharedGradient(p37) -- Line: 169
    -- upvalues: u8 (copy), u9 (copy), Bindables (copy), buildColorSequence (copy)
    local v38 = u8[p37];

    if v38 then
        v38:Disconnect();
        u8[p37] = nil;
    end;

    if u9[p37] then
        u9[p37] = nil;
        Bindables.RemoveSecretGradient:Fire(p37);
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = 0;
    UIGradient.Color = buildColorSequence(0);
    UIGradient.Parent = p37;
    u9[p37] = true;
    Bindables.AddSecretGradient:Fire(p37);
end;

local function animateRainbow(u39) -- Line: 176
    -- upvalues: u2 (copy), u6 (copy), RunService (copy)
    u2.stopRainbow(u39);
    local u40 = 0;
    local u41 = 0;
    u6[u39] = RunService.Heartbeat:Connect(function(p42) -- Line: 180
        -- upvalues: u41 (ref), u40 (ref), u39 (copy), u2 (ref)
        u41 = u41 + p42;

        if u41 < 0.1 then
            return;
        end;

        u40 = (u40 + u41 * 0.3) % 1;
        u41 = 0;

        if u39 and u39.Parent then
            local v43 = u39;
            local v44 = Color3.fromHSV(u40, 1, 1);
            local ClassName = v43.ClassName;

            if ClassName == "TextLabel" or ClassName == "TextButton" then
                v43.TextColor3 = v44;

                return;
            end;

            if ClassName == "UIStroke" then
                v43.Color = v44;

                return;
            end;

            if ClassName == "Frame" or (ClassName == "ImageButton" or ClassName == "ImageLabel") then
                v43.BackgroundColor3 = v44;

                return;
            end;

            if ClassName == "Highlight" then
                v43.FillColor = v44;
                v43.OutlineColor = v44;
            end;
        else
            u2.stopRainbow(u39);
        end;
    end);
end;

local function addToSharedRainbow(p45) -- Line: 193
    -- upvalues: u2 (copy), u7 (copy), Bindables (copy)
    u2.stopRainbow(p45);
    u7[p45] = true;
    Bindables.AddRainbowText:Fire(p45);
end;

local function applyRarityGradient(p46, p47) -- Line: 199
    -- upvalues: u2 (copy), Gradients (copy)
    if p46:IsA("Highlight") then
        local v48 = u2[p47];

        if v48 then
            p46.FillColor = v48;
            p46.OutlineColor = v48;
        end;

        return;
    end;

    local v49 = Gradients:FindFirstChild(p47);

    if v49 then
        v49:Clone().Parent = p46;

        return;
    end;

    local v50 = u2[p47];

    if v50 then
        local ClassName = p46.ClassName;

        if ClassName == "TextLabel" or ClassName == "TextButton" then
            p46.TextColor3 = v50;

            return;
        end;

        if ClassName == "UIStroke" then
            p46.Color = v50;

            return;
        end;

        if ClassName == "Frame" or (ClassName == "ImageButton" or ClassName == "ImageLabel") then
            p46.BackgroundColor3 = v50;

            return;
        end;

        if ClassName == "Highlight" then
            p46.FillColor = v50;
            p46.OutlineColor = v50;
        end;
    end;
end;

function u2.applyGradient(u51, p52, p53) -- Line: 222
    -- upvalues: u2 (copy), u8 (copy), u9 (copy), Bindables (copy), u5 (copy), clearGradients (copy), u1 (copy), applyRarityGradient (copy), u3 (copy), u6 (copy), RunService (copy), u7 (copy), u4 (copy), animateGradient (copy), buildColorSequence (copy)
    u2.stopRainbow(u51);
    local v54 = u8[u51];

    if v54 then
        v54:Disconnect();
        u8[u51] = nil;
    end;

    if u9[u51] then
        u9[u51] = nil;
        Bindables.RemoveSecretGradient:Fire(u51);
    end;

    local v55 = u5;
    local ClassName = u51.ClassName;

    if ClassName == "TextLabel" or ClassName == "TextButton" then
        u51.TextColor3 = v55;
    elseif ClassName == "UIStroke" then
        u51.Color = v55;
    elseif ClassName == "Frame" or (ClassName == "ImageButton" or ClassName == "ImageLabel") then
        u51.BackgroundColor3 = v55;
    elseif ClassName == "Highlight" then
        u51.FillColor = v55;
        u51.OutlineColor = v55;
    end;

    clearGradients(u51);

    if u1 then
        applyRarityGradient(u51, p52);

        return;
    end;

    if u3[p52] then
        if not (p53 and p53.Tool or u51:IsA("Highlight")) then
            u2.stopRainbow(u51);
            u7[u51] = true;
            Bindables.AddRainbowText:Fire(u51);

            return;
        end;

        u2.stopRainbow(u51);
        local u56 = 0;
        local u57 = 0;
        u6[u51] = RunService.Heartbeat:Connect(function(p58) -- Line: 180
            -- upvalues: u57 (ref), u56 (ref), u51 (copy), u2 (ref)
            u57 = u57 + p58;

            if u57 < 0.1 then
                return;
            end;

            u56 = (u56 + u57 * 0.3) % 1;
            u57 = 0;

            if u51 and u51.Parent then
                local v59 = u51;
                local v60 = Color3.fromHSV(u56, 1, 1);
                local ClassName2 = v59.ClassName;

                if ClassName2 == "TextLabel" or ClassName2 == "TextButton" then
                    v59.TextColor3 = v60;

                    return;
                end;

                if ClassName2 == "UIStroke" then
                    v59.Color = v60;

                    return;
                end;

                if ClassName2 == "Frame" or (ClassName2 == "ImageButton" or ClassName2 == "ImageLabel") then
                    v59.BackgroundColor3 = v60;

                    return;
                end;

                if ClassName2 == "Highlight" then
                    v59.FillColor = v60;
                    v59.OutlineColor = v60;
                end;
            else
                u2.stopRainbow(u51);
            end;
        end);

        return;
    end;

    if not u4[p52] then
        applyRarityGradient(u51, p52);

        return;
    end;

    if p53 and p53.Tool or u51:IsA("Highlight") then
        animateGradient(u51);

        return;
    end;

    local v61 = u8[u51];

    if v61 then
        v61:Disconnect();
        u8[u51] = nil;
    end;

    if u9[u51] then
        u9[u51] = nil;
        Bindables.RemoveSecretGradient:Fire(u51);
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = 0;
    UIGradient.Color = buildColorSequence(0);
    UIGradient.Parent = u51;
    u9[u51] = true;
    Bindables.AddSecretGradient:Fire(u51);
end;

return u2;