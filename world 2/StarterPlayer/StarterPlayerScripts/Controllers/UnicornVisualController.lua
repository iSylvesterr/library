-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {
    Color3.fromRGB(241, 131, 255),
    Color3.fromRGB(193, 131, 255),
    Color3.fromRGB(152, 121, 255),
    Color3.fromRGB(133, 141, 255),
    Color3.fromRGB(112, 162, 255)
};
local u2 = {};

local function BuildHornRainbowState(p3) -- Line: 39
    local v4 = {};

    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v5 = descendant:GetAttribute("HornIndex");

            if typeof(v5) == "number" and (v5 >= 1 and v5 <= 7) then
                local v6, v7, v8 = Color3.toHSV(descendant.Color);
                table.insert(v4, {
                    Instance = descendant,
                    OrigHue = v6,
                    Sat = v7,
                    Val = v8
                });
            end;
        end;
    end;

    return v4;
end;

local function UpdateHornRainbow(p9, p10) -- Line: 57
    local v11 = p9.StartOffset - p10 * 0.5;

    for _, v in p9.HornParts do
        v.Instance.Color = Color3.fromHSV((v.OrigHue + v11) % 1, v.Sat, v.Val);
    end;
end;

local function BuildHairState(p12) -- Line: 66
    local v13 = {};

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("BasePart") and descendant:GetAttribute("UnicornHair") ~= nil then
            table.insert(v13, descendant);
        end;
    end;

    return v13;
end;

local function UpdateHair(p14, p15) -- Line: 76
    -- upvalues: u1 (copy)
    if #p14.HairParts == 0 then
        return;
    end;

    local v16 = #u1;
    local v17 = (p15 * 0.3333333333333333 + p14.StartOffset) * v16;
    local v18 = math.floor(v17);
    local v19 = v18 % v16;
    local v20 = u1[v19 + 1]:Lerp(u1[(v19 + 1) % v16 + 1], v17 - v18);

    for _, v in p14.HairParts do
        v.Color = v20;
    end;
end;

local function UnregisterUnicorn(p21) -- Line: 92
    -- upvalues: u2 (copy)
    u2[p21] = nil;
end;

local function RegisterUnicorn(u22) -- Line: 96
    -- upvalues: u2 (copy), BuildHornRainbowState (copy), BuildHairState (copy)
    if u2[u22] then
        return;
    end;

    u2[u22] = {
        Model = u22,
        StartOffset = math.random(),
        HornParts = BuildHornRainbowState(u22),
        HairParts = BuildHairState(u22)
    };
    u22.AncestryChanged:Connect(function(p23, p24) -- Line: 107
        -- upvalues: u22 (copy), u2 (ref)
        if p24 == nil then
            u2[u22] = nil;
        end;
    end);
end;

local function OnModelChildAdded(p25) -- Line: 112
    -- upvalues: RegisterUnicorn (copy)
    if not p25:IsA("Model") then
        return;
    end;

    if p25.Name ~= "Unicorn" then
        return;
    end;

    RegisterUnicorn(p25);
end;

return {
    StartOrder = 7,

    Init = function(p26) -- Line: 122, Name: Init
    end,

    Start = function(p27) -- Line: 124, Name: Start
        -- upvalues: RegisterUnicorn (copy), OnModelChildAdded (copy), RunService (copy), u2 (copy), UpdateHornRainbow (copy), UpdateHair (copy)
        local _PetVisualClient = workspace:WaitForChild("_PetVisualClient", 30);

        if not _PetVisualClient then
            return;
        end;

        local Models = _PetVisualClient:WaitForChild("Models", 30);

        if not Models then
            return;
        end;

        for _, child in Models:GetChildren() do
            if child:IsA("Model") then
                if child.Name == "Unicorn" then
                    RegisterUnicorn(child);
                end;
            end;
        end;

        Models.ChildAdded:Connect(OnModelChildAdded);
        RunService:BindToRenderStep("UnicornVisual", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 135
            -- upvalues: u2 (ref), UpdateHornRainbow (ref), UpdateHair (ref)
            local v28 = os.clock();

            for _, v in u2 do
                UpdateHornRainbow(v, v28);
                UpdateHair(v, v28);
            end;
        end);
    end
};