-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = RunService:IsServer();
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Bindables = ReplicatedStorage:WaitForChild("Bindables");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local ClientEffectsModules = ReplicatedStorage:WaitForChild("ClientEffectsModules");
local MutationEffects = ClientEffectsModules:WaitForChild("EffectAssets"):WaitForChild("MutationEffects");
local u2 = {};
local u3 = { "Head", "Body", "RightArm", "LeftArm", "RightLeg", "LeftLeg", "RightBackLeg", "RightFrontLeg", "LeftBackLeg", "LeftFrontLeg", "BackRightLeg", "FrontRightLeg", "BackLeftLeg", "FrontLeftLeg", "UpperBody", "LowerBody" };
local u4 = { "LeftEye", "RightEye", "Face", "Eye", "SmallFace", "Eyes" };

for _, v in ipairs({ "Hole" }) do
    u2[v] = true;
end;

local function collectBodyParts(p5) -- Line: 40
    -- upvalues: u3 (copy), u2 (copy)
    local v6 = {};

    for _, v in ipairs(u3) do
        local v7 = p5:FindFirstChild(v);

        if v7 then
            if v7:IsA("Model") then
                for _, descendant in v7:GetDescendants() do
                    if (descendant:IsA("BasePart") or descendant:IsA("UnionOperation")) and not u2[descendant.Name] then
                        table.insert(v6, descendant);
                    end;
                end;
            end;

            if (v7:IsA("BasePart") or v7:IsA("UnionOperation")) and not u2[v7.Name] then
                table.insert(v6, v7);
            end;
        end;
    end;

    return v6;
end;

local function enablePartColor(p8) -- Line: 62
    if p8:IsA("UnionOperation") then
        p8.UsePartColor = true;
    end;
end;

local function weldToPrimaryPart(p9, p10) -- Line: 68
    if p9.PrimaryPart == nil then
        p9:GetPropertyChangedSignal("PrimaryPart"):Wait();
    end;

    p10.Anchored = false;
    p10.Position = p9.PrimaryPart.Position;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p10;
    WeldConstraint.Part1 = p9.PrimaryPart;
    WeldConstraint.Parent = p10;
end;

local function lerpHue(p11, p12, p13) -- Line: 81
    local v14 = p12 - p11;

    if v14 > 0.5 then
        v14 = v14 - 1;
    end;

    if v14 < -0.5 then
        v14 = v14 + 1;
    end;

    return (p11 + v14 * p13) % 1;
end;

local function tintBodyParts(p15, p16, p17, p18) -- Line: 89
    local v19 = p17 or 1;
    local v20 = p18 or 1;

    for _, v in ipairs(p15) do
        if v:IsA("UnionOperation") then
            v.UsePartColor = true;
        end;

        local v21, v22, v23 = v.Color:ToHSV();
        local v24 = p16 - v21;

        if v24 > 0.5 then
            v24 = v24 - 1;
        end;

        if v24 < -0.5 then
            v24 = v24 + 1;
        end;

        v.Color = Color3.fromHSV((v21 + v24 * v19) % 1, v22, v23 * v20);
    end;
end;

local u107 = {
    Gold = function(p25, p26) -- Line: 104, Name: Gold
        -- upvalues: Assets (copy), MutationEffects (copy), collectBodyParts (copy)
        local GoldTexture = Assets.Textures.GoldTexture;
        local Gold = MutationEffects.Gold;
        Gold.Sparkle:Clone().Parent = p25.PrimaryPart;
        Gold.Shine:Clone().Parent = p25.PrimaryPart;

        for _, v in ipairs((collectBodyParts(p25))) do
            for _, child in GoldTexture:Clone():GetChildren() do
                child.Transparency = v.Transparency;
                child.Parent = v;
            end;
        end;
    end,

    Rainbow = function(p27, p28) -- Line: 120, Name: Rainbow
        -- upvalues: MutationEffects (copy), collectBodyParts (copy), u1 (copy), RunService (copy), Bindables (copy)
        local v29 = MutationEffects.Rainbow.RainbowEffect:Clone();

        if p27.PrimaryPart == nil then
            p27:GetPropertyChangedSignal("PrimaryPart"):Wait();
        end;

        v29.Anchored = false;
        v29.Position = p27.PrimaryPart.Position;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v29;
        WeldConstraint.Part1 = p27.PrimaryPart;
        WeldConstraint.Parent = v29;
        v29.Parent = p27.PrimaryPart;
        local u30 = collectBodyParts(p27);

        for _, v in ipairs(u30) do
            v.Material = Enum.Material.SmoothPlastic;

            if v:IsA("UnionOperation") then
                v.UsePartColor = true;
            end;
        end;

        if not (p28 and p28.Tool) then
            Bindables.AddRainbowParts:Fire(u30);

            return;
        end;

        if u1 then
            for _, v in ipairs(u30) do
                v.Color = Color3.fromHSV(0, 1, 1);
            end;

            return;
        end;

        local u31 = 0;
        local u32 = 0;
        local u33 = nil;
        u33 = RunService.Heartbeat:Connect(function(p34) -- Line: 144
            -- upvalues: u32 (ref), u31 (ref), u30 (copy), u33 (ref)
            u32 = u32 + p34;

            if u32 < 0.1 then
                return;
            end;

            u31 = (u31 + u32 * 0.25) % 1;
            u32 = 0;
            local v35 = Color3.fromHSV(u31, 1, 1);

            for i = #u30, 1, -1 do
                local v36 = u30[i];

                if v36 and v36.Parent then
                    v36.Color = v35;
                else
                    table.remove(u30, i);
                end;
            end;

            if #u30 == 0 then
                u33:Disconnect();
            end;
        end);
    end,

    Disco = function(p37, p38) -- Line: 168, Name: Disco
        -- upvalues: collectBodyParts (copy), u1 (copy), RunService (copy), Bindables (copy)
        local u39 = collectBodyParts(p37);

        for _, v in ipairs(u39) do
            if v:IsA("UnionOperation") then
                v.UsePartColor = true;
            end;
        end;

        if not (p38 and p38.Tool) then
            Bindables.AddDiscoParts:Fire(u39);

            return;
        end;

        if u1 then
            for _, v in ipairs(u39) do
                v.Color = Color3.fromHSV(0, 1, 1);
            end;

            return;
        end;

        local u40 = {
            Color3.fromHSV(0, 1, 1),
            Color3.fromHSV(0.16666666666666666, 1, 1),
            Color3.fromHSV(0.3333333333333333, 1, 1),
            Color3.fromHSV(0.5, 1, 1),
            Color3.fromHSV(0.6666666666666666, 1, 1),
            Color3.fromHSV(0.8333333333333334, 1, 1)
        };
        local u41 = 1;
        local u42 = 0;

        local function darkenColor(p43, p44) -- Line: 197
            local v45, v46, v47 = Color3.toHSV(p43);

            return Color3.fromHSV(v45, v46, v47 * p44);
        end;

        local u48 = nil;
        u48 = RunService.Heartbeat:Connect(function(p49) -- Line: 203
            -- upvalues: u42 (ref), u41 (ref), u40 (copy), u39 (copy), u48 (ref)
            u42 = u42 + p49;

            if u42 < 0.75 then
                return;
            end;

            u42 = u42 % 0.75;
            u41 = u41 % #u40 + 1;
            local v50 = u40[u41];

            for i = #u39, 1, -1 do
                local v51 = u39[i];

                if v51 and v51.Parent then
                    local v52;

                    if v51.Name == "Darker" then
                        local v53, v54, v55 = Color3.toHSV(v50);
                        v52 = Color3.fromHSV(v53, v54, v55 * 0.75) or v50;
                    else
                        v52 = v50;
                    end;

                    v51.Color = v52;
                else
                    table.remove(u39, i);
                end;
            end;

            if #u39 == 0 then
                u48:Disconnect();
            end;
        end);
    end,

    Moonlit = function(p56, p57) -- Line: 229, Name: Moonlit
        -- upvalues: MutationEffects (copy), tintBodyParts (copy), collectBodyParts (copy)
        local Moonlit = MutationEffects:WaitForChild("Moonlit");
        local v58 = Moonlit.Swirls:Clone();

        if p56.PrimaryPart == nil then
            p56:GetPropertyChangedSignal("PrimaryPart"):Wait();
        end;

        v58.Anchored = false;
        v58.Position = p56.PrimaryPart.Position;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v58;
        WeldConstraint.Part1 = p56.PrimaryPart;
        WeldConstraint.Parent = v58;
        v58.Parent = p56.PrimaryPart;
        Moonlit.Moons:Clone().Parent = p56.PrimaryPart;
        tintBodyParts(collectBodyParts(p56), 0.725, 0.85, 0.75);
    end,

    Celestial = function(p59, p60) -- Line: 241, Name: Celestial
        -- upvalues: MutationEffects (copy), tintBodyParts (copy), collectBodyParts (copy)
        local Celestial = MutationEffects:WaitForChild("Celestial");
        local v61 = Celestial.Swirls:Clone();

        if p59.PrimaryPart == nil then
            p59:GetPropertyChangedSignal("PrimaryPart"):Wait();
        end;

        v61.Anchored = false;
        v61.Position = p59.PrimaryPart.Position;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v61;
        WeldConstraint.Part1 = p59.PrimaryPart;
        WeldConstraint.Parent = v61;
        v61.Parent = p59.PrimaryPart;
        Celestial.Energy:Clone().Parent = p59.PrimaryPart;
        tintBodyParts(collectBodyParts(p59), 0.74, 0.85, 1);
    end,

    Glitched = function(p62, p63) -- Line: 253, Name: Glitched
        -- upvalues: MutationEffects (copy), collectBodyParts (copy), u1 (copy), RunService (copy), Bindables (copy)
        for _, child in MutationEffects:WaitForChild("Glitched"):GetChildren() do
            child:Clone().Parent = p62.PrimaryPart;
        end;

        local u64 = collectBodyParts(p62);

        for _, v in ipairs(u64) do
            if v:IsA("UnionOperation") then
                v.UsePartColor = true;
            end;
        end;

        if not (p63 and p63.Tool) then
            Bindables.AddDiscoParts:Fire(u64);

            return;
        end;

        if u1 then
            for _, v in ipairs(u64) do
                v.Color = Color3.fromHSV(0, 1, 1);
            end;

            return;
        end;

        local u65 = {
            Color3.fromHSV(0, 1, 1),
            Color3.fromHSV(0.16666666666666666, 1, 1),
            Color3.fromHSV(0.3333333333333333, 1, 1),
            Color3.fromHSV(0.5, 1, 1),
            Color3.fromHSV(0.6666666666666666, 1, 1),
            Color3.fromHSV(0.8333333333333334, 1, 1)
        };
        local u66 = 1;
        local u67 = 0;

        local function _(p68, p69) -- Line: 289
            local v70, v71, v72 = Color3.toHSV(p68);

            return Color3.fromHSV(v70, v71, v72 * p69);
        end;

        local u73 = nil;
        u73 = RunService.Heartbeat:Connect(function(p74) -- Line: 295
            -- upvalues: u67 (ref), u66 (ref), u65 (copy), u64 (copy), u73 (ref)
            u67 = u67 + p74;

            if u67 < 0.75 then
                return;
            end;

            u67 = u67 % 0.75;
            u66 = u66 % #u65 + 1;
            local v75 = u65[u66];

            for i = #u64, 1, -1 do
                local v76 = u64[i];

                if v76 and v76.Parent then
                    local v77;

                    if v76.Name == "Darker" then
                        local v78, v79, v80 = Color3.toHSV(v75);
                        v77 = Color3.fromHSV(v78, v79, v80 * 0.75) or v75;
                    else
                        v77 = v75;
                    end;

                    v76.Color = v77;
                else
                    table.remove(u64, i);
                end;
            end;

            if #u64 == 0 then
                u73:Disconnect();
            end;
        end);
    end,

    Scorched = function(p81, p82) -- Line: 321, Name: Scorched
        -- upvalues: MutationEffects (copy), tintBodyParts (copy), collectBodyParts (copy)
        for _, child in MutationEffects:WaitForChild("Scorched"):GetChildren() do
            child:Clone().Parent = p81.PrimaryPart;
        end;

        tintBodyParts(collectBodyParts(p81), 0.98, 0.8, 0.75);
    end,

    Toasty = function(p83, p84) -- Line: 333, Name: Toasty
        -- upvalues: MutationEffects (copy), tintBodyParts (copy), collectBodyParts (copy)
        for _, child in MutationEffects:WaitForChild("Toasty"):GetChildren() do
            child:Clone().Parent = p83.PrimaryPart;
        end;

        tintBodyParts(collectBodyParts(p83), 0.1, 0.8, 0.9);
    end,

    Shocked = function(p85, p86) -- Line: 345, Name: Shocked
        -- upvalues: MutationEffects (copy), collectBodyParts (copy)
        for _, child in MutationEffects:WaitForChild("Shocked"):GetChildren() do
            child:Clone().Parent = p85.PrimaryPart;
        end;

        local v87 = collectBodyParts(p85);

        for _, v in ipairs(v87) do
            v.Material = Enum.Material.Neon;
        end;
    end,

    Flipped = function(p88, p89) -- Line: 359, Name: Flipped
        -- upvalues: MutationEffects (copy), tintBodyParts (copy), collectBodyParts (copy)
        if p88:GetAttribute("FlippedApplied") then
            return;
        end;

        if p88.PrimaryPart == nil then
            p88:GetPropertyChangedSignal("PrimaryPart"):Wait();
        end;

        local PrimaryPart = p88.PrimaryPart;
        local Y = PrimaryPart.CFrame:PointToObjectSpace(p88.PrimaryPart.CFrame.Position).Y;
        local v90 = CFrame.new(0, 2 * Y, 0) * CFrame.Angles(0, 0, 3.141592653589793);
        local v91 = false;

        for _, descendant in p88:GetDescendants() do
            if descendant:IsA("Motor6D") or descendant:IsA("Weld") then
                if descendant.Part0 == PrimaryPart then
                    descendant.C0 = v90 * descendant.C0;
                    v91 = true;
                elseif descendant.Part1 == PrimaryPart then
                    descendant.C1 = v90 * descendant.C1;
                    v91 = true;
                end;
            end;
        end;

        if not v91 then
            local CFrame2 = PrimaryPart.CFrame;

            for _, descendant in p88:GetDescendants() do
                if descendant:IsA("BasePart") and (descendant ~= PrimaryPart and descendant.Anchored) then
                    descendant.CFrame = CFrame2 * v90 * CFrame2:ToObjectSpace(descendant.CFrame);
                    v91 = true;
                end;
            end;
        end;

        if v91 then
            p88:SetAttribute("FlippedApplied", true);
        end;

        MutationEffects:WaitForChild("Flipped").FlipParticle:Clone().Parent = p88.PrimaryPart;
        tintBodyParts(collectBodyParts(p88), 0.35, 0.6, 0.8);
    end,

    Radiant = function(p92, p93) -- Line: 415, Name: Radiant
        -- upvalues: MutationEffects (copy), collectBodyParts (copy)
        local v94 = MutationEffects:WaitForChild("Radiant").Radiant:Clone();

        if p92.PrimaryPart == nil then
            p92:GetPropertyChangedSignal("PrimaryPart"):Wait();
        end;

        v94.Anchored = false;
        v94.Position = p92.PrimaryPart.Position;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v94;
        WeldConstraint.Part1 = p92.PrimaryPart;
        WeldConstraint.Parent = v94;
        v94.Parent = p92.PrimaryPart;
        local v95 = collectBodyParts(p92);

        for _, v in ipairs(v95) do
            v.Material = Enum.Material.Neon;

            if v:IsA("UnionOperation") then
                v.UsePartColor = true;
            end;

            v.Color = Color3.new(1, 1, 1);

            if v.Transparency == 0 then
                v.Transparency = 0.4;
            end;
        end;
    end,

    Chilly = function(p96, p97) -- Line: 433, Name: Chilly
        -- upvalues: MutationEffects (copy), tintBodyParts (copy), collectBodyParts (copy)
        local Chilly = MutationEffects:WaitForChild("Chilly");
        local v98 = Chilly.SnowyCloud:Clone();

        if p96.PrimaryPart == nil then
            p96:GetPropertyChangedSignal("PrimaryPart"):Wait();
        end;

        v98.Anchored = false;
        v98.Position = p96.PrimaryPart.Position;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v98;
        WeldConstraint.Part1 = p96.PrimaryPart;
        WeldConstraint.Parent = v98;
        Chilly.Snowflake1:Clone().Parent = p96.PrimaryPart;
        Chilly.Snowflake2:Clone().Parent = p96.PrimaryPart;
        v98.Parent = p96.PrimaryPart;
        tintBodyParts(collectBodyParts(p96), 0.55, 0.8);
    end,

    Permafrost = function(p99, p100) -- Line: 447, Name: Permafrost
        -- upvalues: MutationEffects (copy), tintBodyParts (copy), collectBodyParts (copy)
        MutationEffects:WaitForChild("Permafrost").Attachment:Clone().Parent = p99.PrimaryPart;
        tintBodyParts(collectBodyParts(p99), 0.57, 0.925);
    end,

    Tranquil = function(p101, p102) -- Line: 456, Name: Tranquil
        -- upvalues: MutationEffects (copy), u4 (copy)
        local Tranquil = MutationEffects:WaitForChild("Tranquil");

        for _, v in ipairs({ "Word1", "Word2", "Word3", "Word4", "Ring" }) do
            Tranquil[v]:Clone().Parent = p101.PrimaryPart;
        end;

        local v103 = {};

        for _, v in ipairs(u4) do
            v103[v] = true;
        end;

        for _, child in ipairs(p101:GetChildren()) do
            if v103[child.Name] and (child:IsA("BasePart") or child:IsA("UnionOperation")) then
                if child:IsA("UnionOperation") then
                    child.UsePartColor = true;
                end;

                child.Color = Color3.new(1, 0.952941, 0.870588);
                child.Material = Enum.Material.Neon;
            end;
        end;
    end,

    Taco = function(p104, p105) -- Line: 477, Name: Taco
        -- upvalues: ClientEffectsModules (copy), MutationEffects (copy)
        local Taco = ClientEffectsModules:WaitForChild("EffectAssets"):WaitForChild("Taco");
        local Taco2 = MutationEffects:WaitForChild("Taco");

        if Taco and Taco2 then
            local v106 = Taco:Clone();
            v106.Position = p104.PrimaryPart.Position;
            v106.Position = v106.Position + Vector3.new(0, p104.PrimaryPart.Size.Y / 2, 0);
            v106.Anchored = false;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = p104.PrimaryPart;
            WeldConstraint.Part1 = v106;
            WeldConstraint.Parent = v106;
            v106.Parent = p104.PrimaryPart;
            Taco2:WaitForChild("TacoEffect"):Clone().Parent = p104.PrimaryPart;
        end;
    end
};
local v112 = {
    renderMutation = function(p108, p109, p110) -- Line: 501, Name: renderMutation
        -- upvalues: u107 (copy)
        local v111 = u107[p109];

        if not v111 then
            return;
        end;

        v111(p108, p110);
    end
};
local u113 = {
    Rainbow = true,
    Disco = true,
    Glitched = true
};

function v112.isAnimated(p114) -- Line: 519
    -- upvalues: u113 (copy)
    return u113[p114] == true;
end;

function v112.animateModel(p115, p116) -- Line: 530
    -- upvalues: u1 (copy), u113 (copy), collectBodyParts (copy), RunService (copy)
    if u1 then
        return function() -- Line: 531
        end;
    end;

    if not u113[p116] then
        return function() -- Line: 532
        end;
    end;

    local u117 = collectBodyParts(p115);

    for _, v in ipairs(u117) do
        if v:IsA("UnionOperation") then
            v.UsePartColor = true;
        end;

        if p116 == "Rainbow" then
            v.Material = Enum.Material.SmoothPlastic;
        end;
    end;

    if #u117 == 0 then
        return function() -- Line: 542
        end;
    end;

    local u118 = nil;

    if p116 == "Rainbow" then
        local u119 = 0;
        local u120 = 0;
        u118 = RunService.Heartbeat:Connect(function(p121) -- Line: 554
            -- upvalues: u120 (ref), u119 (ref), u117 (copy), u118 (ref)
            u120 = u120 + p121;

            if u120 < 0.1 then
                return;
            end;

            u119 = (u119 + u120 * 0.25) % 1;
            u120 = 0;
            local v122 = Color3.fromHSV(u119, 1, 1);

            for i = #u117, 1, -1 do
                local v123 = u117[i];

                if v123 and v123.Parent then
                    v123.Color = v122;
                else
                    table.remove(u117, i);
                end;
            end;

            if #u117 == 0 then
                u118:Disconnect();
            end;
        end);
    else
        local u124 = {
            Color3.fromHSV(0, 1, 1),
            Color3.fromHSV(0.16666666666666666, 1, 1),
            Color3.fromHSV(0.3333333333333333, 1, 1),
            Color3.fromHSV(0.5, 1, 1),
            Color3.fromHSV(0.6666666666666666, 1, 1),
            Color3.fromHSV(0.8333333333333334, 1, 1)
        };
        local u125 = 1;
        local u126 = 0;

        local function _(p127, p128) -- Line: 583
            local v129, v130, v131 = Color3.toHSV(p127);

            return Color3.fromHSV(v129, v130, v131 * p128);
        end;

        u118 = RunService.Heartbeat:Connect(function(p132) -- Line: 587
            -- upvalues: u126 (ref), u125 (ref), u124 (copy), u117 (copy), u118 (ref)
            u126 = u126 + p132;

            if u126 < 0.75 then
                return;
            end;

            u126 = u126 % 0.75;
            u125 = u125 % #u124 + 1;
            local v133 = u124[u125];

            for i = #u117, 1, -1 do
                local v134 = u117[i];

                if v134 and v134.Parent then
                    local v135;

                    if v134.Name == "Darker" then
                        local v136, v137, v138 = Color3.toHSV(v133);
                        v135 = Color3.fromHSV(v136, v137, v138 * 0.75) or v133;
                    else
                        v135 = v133;
                    end;

                    v134.Color = v135;
                else
                    table.remove(u117, i);
                end;
            end;

            if #u117 == 0 then
                u118:Disconnect();
            end;
        end);
    end;

    return function() -- Line: 605
        -- upvalues: u118 (ref)
        if u118 then
            u118:Disconnect();
            u118 = nil;
        end;
    end;
end;

return v112;