-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Skins = ReplicatedStorage:WaitForChild("Skins");
local u1 = {
    Rainbow = {}
};

function u1.Rainbow.SkinAdded(p2, p3, p4) -- Line: 12
    p3:AddTag("RainbowPart");
end;

function u1.Rainbow.SkinRemoved(p5, p6, p7) -- Line: 16
    p6:RemoveTag("RainbowPart");
end;

local u8 = {
    Debug = {
        ColorsList = {
            SkinIndex1 = Color3.fromRGB(0, 85, 0),
            SkinIndex2 = Color3.fromRGB(97, 78, 51),
            SkinIndex3 = Color3.fromRGB(0, 0, 0)
        },
        MaterialList = {
            SkinIndex1 = Enum.Material.Grass,
            SkinIndex2 = Enum.Material.Mud,
            SkinIndex3 = Enum.Material.Marble
        },
        MaterialVariantList = {},
        SkinFunctionList = {
            SkinIndex3 = "Rainbow"
        }
    }
};
local u9 = { "Color", "Material", "Transparency", "Reflectance", "MaterialVariant" };
local v10 = {};

for _, child in Skins:GetChildren() do
    local Name = child.Name;

    if not u8[Name] then
        local v11 = {
            SkinFunctionList = {}
        };

        for _, v in u9 do
            v11[("%sList"):format(v)] = {};
        end;

        u8[Name] = v11;
    end;

    local v12 = u8[Name];

    if v12 then
        for _, child2 in child:GetChildren() do
            if child2:IsA("BasePart") then
                local Name2 = child2.Name;

                for _, v in u9 do
                    v12[("%sList"):format(v)][Name2] = child2[v];
                end;

                local v13 = child2:GetAttribute("SkinFunction");

                if v13 then
                    v12.SkinFunctionList[Name2] = v13;
                end;
            end;
        end;
    else
        warn("Somehow no skin data??");

        if Constants.IS_STUDIO then
            error((`SkinService: No skin data for {Name}`));
        end;
    end;
end;

function v10.SetSkin(p14, p15, p16) -- Line: 81
    -- upvalues: u8 (copy), u9 (copy), u1 (copy), Skins (copy)
    if not p15 then
        return warn("SkinService:SetSkin | No ParentModel provided!");
    end;

    p14:RemoveSkin(p15);
    local v17 = u8[p16];

    if not v17 then
        return warn(`SkinService:SetSkin | {p16} does not exist as a skin!`);
    end;

    p15:SetAttribute("CurrentSkin", p16);

    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v18 = descendant:GetAttribute("SkinIndex");

            if v18 then
                for _, v in u9 do
                    local v19 = v17[("%sList"):format(v)];

                    if v19 then
                        local v20 = v19[v18];

                        if v20 ~= nil then
                            descendant:SetAttribute(`SkinPrevious{v}`, descendant[v]);
                            descendant[v] = v20;
                        end;
                    end;
                end;

                local v21 = v17.SkinFunctionList[v18];

                if v21 then
                    v21 = u1[v21];
                end;

                if v21 then
                    v21:SkinAdded(descendant, p16);
                end;
            end;
        end;
    end;

    local v22 = Skins:FindFirstChild(p16);

    if v22 then
        for _, descendant in v22:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                local Name = descendant.Name;

                for _, descendant2 in p15:GetDescendants() do
                    if descendant2:GetAttribute("VfxIndex") == Name then
                        local Parent = descendant2.Parent;

                        if Parent then
                            descendant2:Destroy();
                            descendant:Clone().Parent = Parent;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function v10.RemoveSkin(p23, p24) -- Line: 135
    -- upvalues: u8 (copy), u9 (copy), u1 (copy)
    local v25 = p24:GetAttribute("CurrentSkin");

    if not v25 then
        return;
    end;

    local v26 = u8[v25];

    if not v26 then
        return warn(`SkinService:RemoveSkin | {v25} does not exist as a skin!`);
    end;

    for _, descendant in p24:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v27 = descendant:GetAttribute("SkinIndex");

            if v27 then
                for _, v in u9 do
                    if v26[`{v}List`] then
                        local v28 = `SkinPrevious{v}`;
                        local v29 = descendant:GetAttribute(v28);

                        if v29 then
                            descendant[v] = v29;
                            descendant:SetAttribute(v28, nil);
                        end;
                    end;
                end;

                local v30 = v26.SkinFunctionList[v27];

                if v30 then
                    v30 = u1[v30];
                end;

                if v30 then
                    v30:SkinRemoved(descendant, v25);
                end;
            end;
        end;
    end;

    p24:SetAttribute("CurrentSkin", nil);
end;

return v10;