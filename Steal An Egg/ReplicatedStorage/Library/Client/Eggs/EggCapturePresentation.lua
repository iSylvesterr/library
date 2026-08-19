-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local u1 = {};
local u25 = {
    ApplySourceClone = function(p2, p3) -- Line: 39, Name: ApplySourceClone
        -- upvalues: Asserts (copy)
        Asserts.Model(p2);
        Asserts.Color3(p3);

        for _, descendant in p2:GetDescendants() do
            if descendant:IsA("SurfaceAppearance") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
                descendant:Destroy();
            elseif descendant:IsA("MeshPart") then
                descendant.TextureID = "";
            elseif descendant:IsA("SpecialMesh") then
                descendant.TextureId = "";
            end;
        end;

        for _, descendant in p2:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Color = Color3.new(1, 1, 1);
                descendant.Material = Enum.Material.Neon;
                descendant.MaterialVariant = "";

                if descendant.Transparency < 1 then
                    for _, v in Enum.NormalId:GetEnumItems() do
                        local Decal = Instance.new("Decal");
                        Decal.Name = "DnaStealWhiteSurface";
                        Decal.Texture = "rbxassetid://6381483576";
                        Decal.Color3 = Color3.new(1, 1, 1);
                        Decal.Transparency = 0;
                        Decal.Face = v;
                        Decal.Parent = descendant;
                    end;
                end;
            end;
        end;

        local PrimaryPart = p2.PrimaryPart;
        Asserts.BasePart(PrimaryPart);
        local PointLight = Instance.new("PointLight");
        PointLight.Name = "DnaStealCaptureGlow";
        PointLight.Color = p3;
        PointLight.Brightness = 3;
        local v4 = p2:GetExtentsSize().Magnitude * 1.5;
        PointLight.Range = math.max(12, v4);
        PointLight.Shadows = false;
        PointLight.Parent = PrimaryPart;
    end,

    BeginEgg = function(p5, p6) -- Line: 83, Name: BeginEgg
        -- upvalues: Asserts (copy), u1 (copy)
        Asserts.Model(p5);
        Asserts.Color3(p6);
        assert(u1[p5] == nil, "Egg capture presentation is already active");
        local v7 = {};
        local v8 = {};
        local v9 = {};
        local v10 = {};
        local v11 = {};
        local v12 = {};

        for _, descendant in p5:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(v8, {
                    Part = descendant,
                    Color = descendant.Color,
                    Material = descendant.Material,
                    MaterialVariant = descendant.MaterialVariant
                });
                descendant.Color = p6;
                descendant.Material = Enum.Material.Neon;
                descendant.MaterialVariant = "";

                if descendant:IsA("MeshPart") then
                    table.insert(v9, {
                        MeshPart = descendant,
                        TextureID = descendant.TextureID
                    });
                    descendant.TextureID = "";
                end;
            elseif descendant:IsA("SurfaceAppearance") then
                local v13 = {
                    Appearance = descendant,
                    Parent = assert(descendant.Parent, "SurfaceAppearance must have a parent")
                };
                table.insert(v10, v13);
                descendant.Parent = nil;
            elseif descendant:IsA("SpecialMesh") then
                table.insert(v11, {
                    Mesh = descendant,
                    TextureId = descendant.TextureId
                });
                descendant.TextureId = "";
            elseif descendant:IsA("Decal") then
                table.insert(v7, {
                    Decal = descendant,
                    Transparency = descendant.Transparency
                });
                descendant.Transparency = 1;
            elseif descendant:IsA("Texture") then
                table.insert(v12, {
                    Texture = descendant,
                    Transparency = descendant.Transparency
                });
                descendant.Transparency = 1;
            end;
        end;

        local PrimaryPart = p5.PrimaryPart;
        Asserts.BasePart(PrimaryPart);
        local PointLight = Instance.new("PointLight");
        PointLight.Name = "DnaStealEggGlow";
        PointLight.Color = p6;
        PointLight.Brightness = 3;
        local v14 = p5:GetExtentsSize().Magnitude * 1.5;
        PointLight.Range = math.max(12, v14);
        PointLight.Shadows = false;
        PointLight.Parent = PrimaryPart;
        u1[p5] = {
            Restored = false,
            Parts = v8,
            Appearances = v10,
            MeshTextures = v9,
            SpecialMeshTextures = v11,
            Decals = v7,
            Textures = v12,
            Light = PointLight
        };
    end,

    UpdateEgg = function(p15, p16) -- Line: 161, Name: UpdateEgg
        -- upvalues: Asserts (copy), u1 (copy)
        Asserts.Model(p15);
        Asserts.Color3(p16);
        local v17 = assert(u1[p15], "Egg capture presentation must be active");

        for _, v in v17.Parts do
            v.Part.Color = p16;
        end;

        v17.Light.Color = p16;
    end,

    UpdateEggBlend = function(p18, p19, p20) -- Line: 171, Name: UpdateEggBlend
        -- upvalues: Asserts (copy), u1 (copy)
        Asserts.Model(p18);
        Asserts.Color3(p19);
        Asserts.finite(p20);
        local v21;

        if p20 >= 0 then
            v21 = p20 <= 1;
        else
            v21 = false;
        end;

        assert(v21, "Egg capture presentation blend alpha must be between zero and one");
        local v22 = assert(u1[p18], "Egg capture presentation must be active");

        for _, v in v22.Parts do
            v.Part.Color = v.Color:Lerp(p19, p20);
        end;

        v22.Light.Color = p19;
        v22.Light.Brightness = p20 * 3;
    end,

    RestoreEggImmediate = function(p23) -- Line: 184, Name: RestoreEggImmediate
        -- upvalues: Asserts (copy), u1 (copy)
        Asserts.Model(p23);
        local v24 = assert(u1[p23], "Egg capture presentation must be active");

        if v24.Restored then
            return;
        end;

        v24.Restored = true;
        u1[p23] = nil;

        for _, v in v24.Parts do
            v.Part.Color = v.Color;
            v.Part.Material = v.Material;
            v.Part.MaterialVariant = v.MaterialVariant;
        end;

        for _, v in v24.MeshTextures do
            v.MeshPart.TextureID = v.TextureID;
        end;

        for _, v in v24.SpecialMeshTextures do
            v.Mesh.TextureId = v.TextureId;
        end;

        for _, v in v24.Decals do
            v.Decal.Transparency = v.Transparency;
        end;

        for _, v in v24.Textures do
            v.Texture.Transparency = v.Transparency;
        end;

        for _, v in v24.Appearances do
            v.Appearance.Parent = v.Parent;
        end;

        v24.Light:Destroy();
    end
};

function u25.FadeAndRestoreEgg(u26, p27, u28, u29, u30) -- Line: 216
    -- upvalues: Asserts (copy), u1 (copy), RenderStepped (copy), Easing (copy), u25 (copy)
    Asserts.Model(u26);
    Asserts.finite(p27);
    Asserts.finite(u28);
    Asserts.finite(u29);
    Asserts.finite(u30);
    assert(p27 > 0, "Egg capture restore duration must be positive");
    assert(u28 > 0, "Egg capture target scale must be positive");
    assert(u29 > 1, "Egg capture pop multiplier must exceed one");
    local v31;

    if u30 > 0 then
        v31 = u30 < 1;
    else
        v31 = false;
    end;

    assert(v31, "Egg capture pop ratio must be between zero and one");
    local u32 = assert(u1[u26], "Egg capture presentation must be active");
    local u33 = {};

    for _, v in u32.Parts do
        u33[v.Part] = v.Part.Color;
    end;

    local Brightness = u32.Light.Brightness;
    RenderStepped(function(p34, p35) -- Line: 239
        -- upvalues: u26 (copy), u1 (ref), u32 (copy), Easing (ref), u33 (copy), Brightness (copy), u30 (copy), u28 (copy), u29 (copy)
        if u26.Parent == nil or u1[u26] ~= u32 then
            return true;
        end;

        local v36 = Easing(p35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for _, v in u32.Parts do
            v.Part.Color = u33[v.Part]:Lerp(v.Color, v36);
        end;

        u32.Light.Brightness = math.lerp(Brightness, 0, v36);

        if p35 < u30 then
            local v37 = Easing(p35 / u30, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
            u26:ScaleTo(u28 * (1 + (u29 - 1) * v37));
        else
            local v38 = Easing((p35 - u30) / (1 - u30), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            u26:ScaleTo(u28 * math.lerp(u29, 1, v38));
        end;

        return nil;
    end, p27, true):Wait();

    if u1[u26] ~= u32 then
        return;
    end;

    u26:ScaleTo(u28);
    u25.RestoreEggImmediate(u26);
end;

return u25;