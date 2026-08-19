-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 11
};
local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Skybox = require(game.ReplicatedStorage.ClientModules.Skybox);
local u2 = {
    Brightness = 12,
    EnvironmentDiffuseScale = 0.133,
    EnvironmentSpecularScale = 0.24,
    ClockTime = 18.3,
    ExposureCompensation = 0,
    GeographicLatitude = 33.69,
    Ambient = Color3.fromRGB(102, 104, 252),
    ColorShift_Bottom = Color3.fromRGB(233, 191, 241),
    ColorShift_Top = Color3.fromRGB(247, 188, 255),
    OutdoorAmbient = Color3.fromRGB(119, 151, 255)
};
local u3 = false;
local u4 = {};
local u5 = nil;
local u6 = false;
local u7 = nil;
local u8 = nil;

local function GetSky() -- Line: 79
    -- upvalues: u8 (ref), ReplicatedStorage (copy)
    if u8 then
        return u8;
    end;

    local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

    if Skybox2 then
        Skybox2 = Skybox2:FindFirstChild("Disco");
    end;

    if Skybox2 and Skybox2:IsA("Sky") then
        u8 = Skybox2;
    end;

    return u8;
end;

local function SaveLighting() -- Line: 91
    -- upvalues: u6 (ref), u4 (copy), u2 (copy), Lighting (copy), u5 (ref)
    if u6 then
        return;
    end;

    u6 = true;
    table.clear(u4);

    for i in u2 do
        u4[i] = Lighting[i];
    end;

    u5 = Lighting.GlobalShadows;
end;

local function ApplyLighting() -- Line: 104
    -- upvalues: u7 (ref), Lighting (copy), TweenService (copy), u2 (copy)
    workspace:SetAttribute("TimeFrozen", true);

    if u7 then
        u7:Cancel();
        u7:Destroy();
    end;

    Lighting.GlobalShadows = true;
    local v9 = TweenService:Create(Lighting, TweenInfo.new(3, Enum.EasingStyle.Sine), u2);
    u7 = v9;
    v9:Play();
end;

local function RestoreLighting() -- Line: 118
    -- upvalues: u6 (ref), u7 (ref), u5 (ref), Lighting (copy), TweenService (copy), u4 (copy)
    if not u6 then
        return;
    end;

    u6 = false;
    workspace:SetAttribute("TimeFrozen", nil);

    if u7 then
        u7:Cancel();
        u7:Destroy();
    end;

    if u5 ~= nil then
        Lighting.GlobalShadows = u5;
    end;

    local v10 = TweenService:Create(Lighting, TweenInfo.new(3, Enum.EasingStyle.Sine), u4);
    u7 = v10;
    v10:Play();
end;

local function BeginDisco() -- Line: 139
    -- upvalues: u3 (ref), u6 (ref), u4 (copy), u2 (copy), Lighting (copy), u5 (ref), ApplyLighting (copy), u8 (ref), ReplicatedStorage (copy), Skybox (copy)
    if u3 then
        return;
    end;

    u3 = true;

    if not u6 then
        u6 = true;
        table.clear(u4);

        for i in u2 do
            u4[i] = Lighting[i];
        end;

        u5 = Lighting.GlobalShadows;
    end;

    ApplyLighting();
    local v11;

    if u8 then
        v11 = u8;
    else
        local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

        if Skybox2 then
            Skybox2 = Skybox2:FindFirstChild("Disco");
        end;

        if Skybox2 and Skybox2:IsA("Sky") then
            u8 = Skybox2;
        end;

        v11 = u8;
    end;

    if v11 then
        Skybox.SetOrder(v11, 4);

        return;
    end;

    warn("[DiscoLightingController] no Sky named \"Disco\" under ReplicatedStorage.Assets.Skybox");
end;

local function EndDisco() -- Line: 156
    -- upvalues: u3 (ref), RestoreLighting (copy), u8 (ref), ReplicatedStorage (copy), Skybox (copy)
    if not u3 then
        return;
    end;

    u3 = false;
    RestoreLighting();
    local v12;

    if u8 then
        v12 = u8;
    else
        local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

        if Skybox2 then
            Skybox2 = Skybox2:FindFirstChild("Disco");
        end;

        if Skybox2 and Skybox2:IsA("Sky") then
            u8 = Skybox2;
        end;

        v12 = u8;
    end;

    if v12 then
        Skybox.SetOrder(v12, 0);
    end;
end;

local function Refresh() -- Line: 172
    -- upvalues: u3 (ref), u6 (ref), u4 (copy), u2 (copy), Lighting (copy), u5 (ref), ApplyLighting (copy), u8 (ref), ReplicatedStorage (copy), Skybox (copy), RestoreLighting (copy)
    if workspace:GetAttribute("InDisco") ~= true then
        if not u3 then
            return;
        end;

        u3 = false;
        RestoreLighting();
        local v13;

        if u8 then
            v13 = u8;
        else
            local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

            if Skybox2 then
                Skybox2 = Skybox2:FindFirstChild("Disco");
            end;

            if Skybox2 and Skybox2:IsA("Sky") then
                u8 = Skybox2;
            end;

            v13 = u8;
        end;

        if v13 then
            Skybox.SetOrder(v13, 0);
        end;

        return;
    end;

    if u3 then
        return;
    end;

    u3 = true;

    if not u6 then
        u6 = true;
        table.clear(u4);

        for i in u2 do
            u4[i] = Lighting[i];
        end;

        u5 = Lighting.GlobalShadows;
    end;

    ApplyLighting();
    local v14;

    if u8 then
        v14 = u8;
    else
        local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

        if Skybox2 then
            Skybox2 = Skybox2:FindFirstChild("Disco");
        end;

        if Skybox2 and Skybox2:IsA("Sky") then
            u8 = Skybox2;
        end;

        v14 = u8;
    end;

    if v14 then
        Skybox.SetOrder(v14, 4);

        return;
    end;

    warn("[DiscoLightingController] no Sky named \"Disco\" under ReplicatedStorage.Assets.Skybox");
end;

function v1.Init(p15) -- Line: 181
end;

function v1.Start(p16) -- Line: 183
    -- upvalues: Refresh (copy), u3 (ref), ApplyLighting (copy), u6 (ref), u4 (copy), u2 (copy), Lighting (copy), u5 (ref), u8 (ref), ReplicatedStorage (copy), Skybox (copy), RestoreLighting (copy)
    workspace:GetAttributeChangedSignal("InDisco"):Connect(Refresh);

    local function reclaim() -- Line: 193
        -- upvalues: u3 (ref), ApplyLighting (ref)
        if not u3 then
            return;
        end;

        task.delay(0.5, function() -- Line: 197
            -- upvalues: u3 (ref), ApplyLighting (ref)
            if u3 then
                ApplyLighting();
            end;
        end);
    end;

    workspace:GetAttributeChangedSignal("ActivePhase"):Connect(reclaim);
    workspace:GetAttributeChangedSignal("ActiveWeather"):Connect(reclaim);

    if workspace:GetAttribute("InDisco") ~= true then
        if not u3 then
            return;
        end;

        u3 = false;
        RestoreLighting();
        local v17;

        if u8 then
            v17 = u8;
        else
            local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

            if Skybox2 then
                Skybox2 = Skybox2:FindFirstChild("Disco");
            end;

            if Skybox2 and Skybox2:IsA("Sky") then
                u8 = Skybox2;
            end;

            v17 = u8;
        end;

        if v17 then
            Skybox.SetOrder(v17, 0);
        end;

        return;
    end;

    if u3 then
        return;
    end;

    u3 = true;

    if not u6 then
        u6 = true;
        table.clear(u4);

        for i in u2 do
            u4[i] = Lighting[i];
        end;

        u5 = Lighting.GlobalShadows;
    end;

    ApplyLighting();
    local v18;

    if u8 then
        v18 = u8;
    else
        local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

        if Skybox2 then
            Skybox2 = Skybox2:FindFirstChild("Disco");
        end;

        if Skybox2 and Skybox2:IsA("Sky") then
            u8 = Skybox2;
        end;

        v18 = u8;
    end;

    if v18 then
        Skybox.SetOrder(v18, 4);

        return;
    end;

    warn("[DiscoLightingController] no Sky named \"Disco\" under ReplicatedStorage.Assets.Skybox");
end;

return v1;