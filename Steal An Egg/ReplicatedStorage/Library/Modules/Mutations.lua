-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TableUtil = require(ReplicatedStorage.Library.Modules.Packages.TableUtil);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Audio = require(ReplicatedStorage.Library.Audio);
local BBFromArray = require(ReplicatedStorage.Library.Functions.BBFromArray);
local CRC32 = require(ReplicatedStorage.Library.Functions.CRC32);
local v2 = {
    Mutation = t.interface({
        Name = t.string,
        DisplayOverride = t.optional(t.string),
        Color = t.Color3,
        ValueMulti = t.number,
        DropWeight = t.number,
        Odds = t.optional(t.number),
        ActiveRunDropWeight = t.optional(t.number),
        SoundFile = t.optional(Audio.__types.SoundFile),
        Icon = t.optional(t.number),
        ForceIconDisplayInUI = t.optional(t.boolean),
        PersonalityOverride = t.optional(t.string),
        _AddFX = t.callback,
        _RemoveFX = t.callback
    })
};
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = Random.new();
local u7 = nil;

local function shouldSkipColoring(p8) -- Line: 91
    return (p8:GetAttribute("MutationsDontModify") == true or (p8:GetAttribute("DontAddTexture") == true or p8:GetAttribute("IsEye") == true)) and true or p8:GetAttribute("MutationFXDontRender") == true;
end;

local function ensureUnionUsePartColor(p9) -- Line: 98
    if not p9:IsA("UnionOperation") then
        return;
    end;

    if p9:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
        p9:SetAttribute("Cleanup_OriginalUserPartColor", p9.UsePartColor);
    end;

    p9.UsePartColor = true;
end;

local function restoreUnionUsePartColor(p10) -- Line: 110
    if not p10:IsA("UnionOperation") then
        return;
    end;

    local v11 = p10:GetAttribute("Cleanup_OriginalUserPartColor");

    if typeof(v11) ~= "boolean" then
        return;
    end;

    p10.UsePartColor = v11;
    p10:SetAttribute("Cleanup_OriginalUserPartColor", nil);
end;

local function getColorRange(p12) -- Line: 124
    local v13 = p12:Lerp(Color3.new(1, 1, 1), 0.35);

    return p12:Lerp(Color3.new(0, 0, 0), 0.35), v13;
end;

local function getRandomizedColor(p14, p15, p16, p17) -- Line: 130
    local v18 = p15:Lerp(Color3.new(1, 1, 1), 0.35);
    local v19 = p16 or p15:Lerp(Color3.new(0, 0, 0), 0.35);
    local v20 = p17 or v18;
    assert(v19, "luau");
    assert(v20, "luau");

    return v19:Lerp(v20, p14:NextNumber());
end;

local function applyRandomizedColor(p21, p22, p23, p24) -- Line: 139
    -- upvalues: u7 (ref), u6 (copy)
    if p21:IsA("UnionOperation") then
        if p21:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
            p21:SetAttribute("Cleanup_OriginalUserPartColor", p21.UsePartColor);
        end;

        p21.UsePartColor = true;
    end;

    local v25 = p22:Lerp(Color3.new(1, 1, 1), 0.35);
    local v26 = p23 or p22:Lerp(Color3.new(0, 0, 0), 0.35);
    local v27 = p24 or v25;
    assert(v26, "luau");
    assert(v27, "luau");
    p21.Color = v26:Lerp(v27, (u7 or u6):NextNumber());

    return p21.Color;
end;

local function getMutationVisualRandomSeed(p28, p29) -- Line: 146
    -- upvalues: CRC32 (copy)
    local v30 = CRC32((`MutationVisual/{p28}/{p29}`));
    local v31 = math.abs(v30) % 2147483647;

    return v31 <= 0 and 1 or v31;
end;

local function getPartVolume(p32) -- Line: 151
    local Size = p32.Size;

    return Size.X * Size.Y * Size.Z;
end;

local function collectMetalSizeGroups(p33) -- Line: 156
    local v34 = {};

    for _, descendant in p33:GetDescendants() do
        if descendant:IsA("BasePart") and (descendant.Transparency < 1 and not descendant:HasTag("Effect")) and (descendant:GetAttribute("MutationsDontModify") ~= true and (descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true) and descendant:GetAttribute("MutationFXDontRender") ~= true) then
            table.insert(v34, descendant);
        end;
    end;

    table.sort(v34, function(p35, p36) -- Line: 169
        local Size = p35.Size;
        local Size2 = p36.Size;

        return Size2.X * Size2.Y * Size2.Z < Size.X * Size.Y * Size.Z;
    end);
    local v37 = {};
    local v38 = 0;

    for _, v in v34 do
        local Size = v.Size;
        local v39 = Size.X * Size.Y * Size.Z;
        local v40 = v37[#v37];

        if v40 and math.abs(v40.partVolume - v39) <= 0.001 then
            table.insert(v40.parts, v);
            v40.weight = v40.weight + v39;
        else
            table.insert(v37, {
                parts = { v },
                partVolume = v39,
                weight = v39
            });
        end;

        v38 = v38 + v39;
    end;

    table.sort(v37, function(p41, p42) -- Line: 191
        return p41.weight > p42.weight;
    end);

    return v37, v38;
end;

local function getSilverMetalPartition(p43, p44) -- Line: 198
    -- upvalues: collectMetalSizeGroups (copy), CRC32 (copy)
    local v45, v46 = collectMetalSizeGroups(p43);
    local new = Random.new;
    local v47 = CRC32((`MutationVisual/{p44}/GoldenSilverPartition`));
    local v48 = math.abs(v47) % 2147483647;
    local v49 = new(v48 <= 0 and 1 or v48);
    local v50 = v46 / 2;
    local v51 = v46 / 2;
    local v52 = {};

    for _, v in v45 do
        local v53;

        if math.abs(v50 - v51) <= 0.001 then
            v53 = v49:NextNumber() < 0.5;
        else
            v53 = v51 < v50;
        end;

        if v53 then
            for _, v3 in v.parts do
                v52[v3] = true;
            end;

            v50 = v50 - v.weight;
        else
            v51 = v51 - v.weight;
        end;
    end;

    return v52;
end;

local function getNamedSurfaceAppearance(p54, p55) -- Line: 226
    local v56 = nil;

    for _, descendant in p54:GetDescendants() do
        if descendant:IsA("SurfaceAppearance") and descendant.Name == p55 then
            local v57 = `{p54:GetFullName()} contains multiple {p55} SurfaceAppearances`;
            assert(v56 == nil, v57);
            v56 = descendant;
        end;
    end;

    local v58 = `{p54:GetFullName()} must contain a {p55} SurfaceAppearance`;
    assert(v56 ~= nil, v58);

    return v56;
end;

local function getTextureOverrideVisualModel(p59) -- Line: 238
    if p59.Name == "Model" then
        return p59;
    end;

    local Model = p59:FindFirstChild("Model");
    local v60;

    if Model == nil then
        v60 = false;
    else
        v60 = Model:IsA("Model");
    end;

    local v61 = `{p59:GetFullName()} enables TexturesOverride but has no direct Model child`;
    assert(v60, v61);

    return Model;
end;

local function getOriginalSurfaceAppearance(p62, p63, p64, p65, p66) -- Line: 251
    local v67 = nil;

    for _, descendant in p62:GetDescendants() do
        if descendant:IsA("SurfaceAppearance") and descendant:GetAttribute("Mutation_OriginalSurfaceAppearance") == true then
            local v68 = `{p62:GetFullName()} contains multiple original SurfaceAppearances`;
            assert(v67 == nil, v68);
            v67 = descendant;
        end;
    end;

    if v67 == nil then
        for _, child in p63:GetChildren() do
            if child:IsA("SurfaceAppearance") and (child ~= p64 and (child ~= p65 and child ~= p66)) then
                local v69 = `{p63:GetFullName()} contains multiple original SurfaceAppearances`;
                assert(v67 == nil, v69);
                v67 = child;
            end;
        end;
    end;

    local v70 = `{p63:GetFullName()} must contain its original SurfaceAppearance`;
    assert(v67 ~= nil, v70);
    v67:SetAttribute("Mutation_OriginalSurfaceAppearance", true);

    return v67;
end;

local function getTextureOverrideBindings(p71) -- Line: 283
    -- upvalues: getNamedSurfaceAppearance (copy), getOriginalSurfaceAppearance (copy)
    local v72 = {};

    if p71:IsA("Model") and p71:GetAttribute("TexturesOverride") == true then
        table.insert(v72, p71);
    end;

    for _, descendant in p71:GetDescendants() do
        if descendant:IsA("Model") and descendant:GetAttribute("TexturesOverride") == true then
            table.insert(v72, descendant);
        end;
    end;

    if #v72 == 0 then
        return nil;
    end;

    local v73 = {};
    local v74 = {};

    for _, v in v72 do
        local v75;

        if v.Name == "Model" then
            v75 = v;
        else
            v75 = v:FindFirstChild("Model");
            local v76;

            if v75 == nil then
                v76 = false;
            else
                v76 = v75:IsA("Model");
            end;

            local v77 = `{v:GetFullName()} enables TexturesOverride but has no direct Model child`;
            assert(v76, v77);
        end;

        if not v73[v75] then
            v73[v75] = true;
            local v78 = v75:FindFirstChildWhichIsA("MeshPart", true);
            local v79 = `{v75:GetFullName()} must contain a MeshPart for texture overrides`;
            assert(v78 ~= nil, v79);
            local v80 = getNamedSurfaceAppearance(v75, "GoldTextureOverride");
            local v81 = getNamedSurfaceAppearance(v75, "SilverTextureOverride");
            local v82 = getNamedSurfaceAppearance(v75, "GoldSilverTextureOverride");
            local v83 = {
                visualModel = v75,
                targetMesh = v78,
                original = getOriginalSurfaceAppearance(v75, v78, v80, v81, v82),
                golden = v80,
                silver = v81,
                goldenSilver = v82
            };
            table.insert(v74, v83);
        end;
    end;

    local v84 = `{p71:GetFullName()} enables TexturesOverride but has no texture override bindings`;
    assert(#v74 > 0, v84);

    return v74;
end;

local function getActiveSurfaceAppearance(p85) -- Line: 326
    local v86 = nil;

    for _, child in p85.targetMesh:GetChildren() do
        if child:IsA("SurfaceAppearance") then
            local v87 = `{p85.targetMesh:GetFullName()} contains multiple active SurfaceAppearances`;
            assert(v86 == nil, v87);
            v86 = child;
        end;
    end;

    local v88 = `{p85.targetMesh:GetFullName()} must contain one active SurfaceAppearance`;
    assert(v86 ~= nil, v88);

    return v86;
end;

local function setActiveSurfaceAppearance(p89, p90) -- Line: 338
    -- upvalues: getActiveSurfaceAppearance (copy)
    local v91 = getActiveSurfaceAppearance(p89);

    if v91 == p90 then
        return;
    end;

    local v92 = v91:HasTag("Cleanup_Rainbow");

    if v92 then
        v91:RemoveTag("RainbowPart");
        v91:RemoveTag("Cleanup_Rainbow");
    end;

    v91.Parent = p89.visualModel;
    p90.Parent = p89.targetMesh;

    if v92 then
        p90:AddTag("RainbowPart");
        p90:AddTag("Cleanup_Rainbow");
    end;
end;

local function applyMetalTextureOverride(p93, p94, p95) -- Line: 359
    -- upvalues: setActiveSurfaceAppearance (copy)
    for _, v in p93 do
        local v96 = p94(v);

        if p95 ~= nil then
            v96:AddTag(p95);
        end;

        setActiveSurfaceAppearance(v, v96);
    end;
end;

local function removeMetalTextureOverride(p97, p98, p99, p100, p101) -- Line: 373
    -- upvalues: setActiveSurfaceAppearance (copy)
    for _, v in p97 do
        local v102 = p98(v);

        if v102:HasTag(p100) then
            v102:RemoveTag(p100);
            local v103 = p99(v);

            if v103:HasTag(p101) then
                setActiveSurfaceAppearance(v, v103);
            else
                setActiveSurfaceAppearance(v, v.original);
            end;
        end;
    end;
end;

local function hasVisualTag(p104, p105) -- Line: 396
    for _, descendant in p104:GetDescendants() do
        if descendant:HasTag(p105) then
            return true;
        end;
    end;

    return false;
end;

local function shouldApplyGoldenSilverCombo(p106, p107) -- Line: 405
    if p107 == "Golden" then
        for _, descendant in p106:GetDescendants() do
            if descendant:HasTag("SilverVisual") then
                return true;
            end;
        end;

        return false;
    end;

    if p107 ~= "Silver" then
        return false;
    end;

    for _, descendant in p106:GetDescendants() do
        if descendant:HasTag("GoldenVisual") then
            return true;
        end;
    end;

    return false;
end;

local function getStoredOriginalColor(p108) -- Line: 447
    local v109 = p108:GetAttribute("OriginalColor");

    if typeof(v109) == "Color3" then
        return v109;
    end;

    return nil;
end;

local function getMaterialByName(p110) -- Line: 456
    for _, v in Enum.Material:GetEnumItems() do
        if v.Name == p110 then
            return v;
        end;
    end;

    return nil;
end;

local function getStoredOriginalMaterial(p111) -- Line: 466
    local v112 = p111:GetAttribute("Mutation_OriginalMaterial");

    if typeof(v112) == "string" then
        for _, v in Enum.Material:GetEnumItems() do
            if v.Name == v112 then
                break;
            end;
        end;

        if v then
            return v;
        end;
    end;

    local v113 = p111:GetAttribute("OriginalMaterial");

    if typeof(v113) == "string" then
        for _, v in Enum.Material:GetEnumItems() do
            if v.Name == v113 then
                break;
            end;
        end;

        if v then
            return v;
        end;
    end;

    local v114 = p111:GetAttribute("Original_Material");

    if typeof(v114) == "string" then
        for _, v in Enum.Material:GetEnumItems() do
            if v.Name == v114 then
                break;
            end;
        end;

        if v then
            return v;
        end;

        return nil;
    end;

    if typeof(v114) == "EnumItem" and v114.EnumType == Enum.Material then
        return v114;
    end;

    return nil;
end;

local function getObjectAnchorPart(p115) -- Line: 496
    if p115:IsA("Model") and p115.PrimaryPart then
        return p115.PrimaryPart;
    end;

    local Handle = p115:FindFirstChild("Handle");

    if Handle and Handle:IsA("BasePart") then
        return Handle;
    end;

    for _, descendant in p115:GetDescendants() do
        if descendant:IsA("BasePart") then
            return descendant;
        end;
    end;

    return nil;
end;

local function tintModel(p116, p117, p118) -- Line: 515
    if not (p116 and p117) then
        return;
    end;

    local v119, v120, _ = p117:ToHSV();
    local v121 = p118 or 1.15;

    for _, descendant in p116:GetDescendants() do
        if descendant:IsA("BasePart") and not descendant:HasTag("NoTint") then
            local v122 = descendant:GetAttribute("OriginalColor");

            if typeof(v122) ~= "Color3" then
                v122 = nil;
            end;

            if not v122 then
                descendant:SetAttribute("OriginalColor", descendant.Color);
            end;

            local _, _, v123 = (v122 or descendant.Color):ToHSV();
            descendant.Color = Color3.fromHSV(v119, v120, v123 ^ v121);
        end;
    end;
end;

local function clearTint(p124) -- Line: 536
    if not p124 then
        return;
    end;

    for _, descendant in p124:GetDescendants() do
        if descendant:IsA("BasePart") and not descendant:HasTag("NoTint") then
            local v125 = descendant:GetAttribute("OriginalColor");

            if typeof(v125) ~= "Color3" then
                v125 = nil;
            end;

            if v125 then
                descendant:SetAttribute("OriginalColor", nil);
                descendant.Color = v125;
            end;
        end;
    end;
end;

local function _setMaterial(p126, p127) -- Line: 553
    if not p126 then
        return;
    end;

    if type(p127) ~= "string" and typeof(p127) ~= "EnumItem" then
        return warn((`MaterialUtil/SetMaterial: Invalid Material type ({p127})`));
    end;

    local v128 = type(p127) == "string" and p127 and p127 or p127.Name;

    for _, v in Enum.Material:GetEnumItems() do
        if v.Name == v128 then
            break;
        end;
    end;

    if not v then
        return warn((`MaterialUtil/SetMaterial: Failed to fetch Material ({v128})`));
    end;

    for _, descendant in p126:GetDescendants() do
        if descendant:IsA("BasePart") then
            if not descendant:GetAttribute("OriginalMaterial") then
                descendant:SetAttribute("OriginalMaterial", v128);
            end;

            descendant.Material = v;
        end;
    end;
end;

local function clearMaterial(p129) -- Line: 577
    -- upvalues: getStoredOriginalMaterial (copy)
    if not p129 then
        return;
    end;

    for _, descendant in p129:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v130 = getStoredOriginalMaterial(descendant);

            if v130 then
                descendant:SetAttribute("OriginalMaterial", nil);
                descendant.Material = v130;
            end;
        end;
    end;
end;

local function setAndSaveMaterial(p131, p132) -- Line: 594
    if not p131:GetAttribute("Mutation_OriginalMaterial") then
        p131:SetAttribute("Mutation_OriginalMaterial", p131.Material.Name);
    end;

    p131.Material = p132;

    return nil;
end;

local function getStoredOriginalMaterialVariant(p133) -- Line: 605
    local v134 = p133:GetAttribute("Mutation_OriginalMaterialVariant");

    if typeof(v134) == "string" then
        return v134;
    end;

    return nil;
end;

local function setAndSaveMaterialVariant(p135, p136) -- Line: 614
    if not p135:GetAttribute("Mutation_OriginalMaterialVariant") then
        p135:SetAttribute("Mutation_OriginalMaterialVariant", p135.MaterialVariant);
    end;

    p135.MaterialVariant = p136;

    return nil;
end;

local function hasMetalVisual(p137) -- Line: 625
    return p137:HasTag("GoldenVisual") or p137:HasTag("SilverVisual");
end;

local function setMetalMaterialVariant(p138) -- Line: 629
    if not p138:GetAttribute("Mutation_OriginalMaterialVariant") then
        p138:SetAttribute("Mutation_OriginalMaterialVariant", p138.MaterialVariant);
    end;

    p138.MaterialVariant = "Custom Stud 100%";
end;

local function applyVFXToFXPartWithTag(p139, p140, p141) -- Line: 695
    -- upvalues: Asserts (copy)
    Asserts.string(p140);
    Asserts.string(p141);
    Asserts.BasePart(p139);
    local v142 = game.ReplicatedStorage.Mutation_FX:FindFirstChild(p140);
    local v143 = `Mutation FX container "{p140}" not found in ReplicatedStorage.Mutation_FX`;
    assert(v142, v143);

    for _, child in v142:GetChildren() do
        local v144 = child:Clone();
        v144.Parent = p139;
        v144:AddTag(p141);
    end;
end;

local function clearFXFromTag(p145, p146) -- Line: 708
    -- upvalues: Asserts (copy)
    Asserts.BasePart(p145);
    Asserts.string(p146);

    for _, child in p145:GetChildren() do
        if child:HasTag(p146) then
            child:Destroy();
        end;
    end;
end;

local u399 = {
    None = {
        Name = "None",
        ValueMulti = 1,
        DropWeight = 0,
        Odds = 0,
        ActiveRunDropWeight = 0,
        Color = Color3.fromRGB(255, 255, 255),

        _AddFX = function() -- Line: 726, Name: _AddFX
        end,

        _RemoveFX = function() -- Line: 727, Name: _RemoveFX
        end
    },
    Rainbow = {
        Name = "Rainbow",
        ValueMulti = 3.5,
        DropWeight = 1,
        Odds = 0.01,
        ActiveRunDropWeight = 0,
        Icon = 85288683002868,
        Color = Color3.fromRGB(255, 0, 255),

        _AddFX = function(p147, p148, p149) -- Line: 737, Name: _AddFX
            -- upvalues: applyVFXToFXPartWithTag (copy), getTextureOverrideBindings (copy), getActiveSurfaceAppearance (copy)
            p147:_RemoveFX(p148, p149);

            if p149 then
                applyVFXToFXPartWithTag(p149, "Rainbow", "Cleanup_RainbowFX");
            end;

            local v150 = getTextureOverrideBindings(p148);

            if v150 == nil then
                for _, descendant in ipairs(p148:GetDescendants()) do
                    if descendant:IsA("BasePart") and not descendant:GetAttribute("DontAddTexture") then
                        if descendant:IsA("UnionOperation") then
                            if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                            end;

                            descendant.UsePartColor = true;
                        end;

                        descendant:AddTag("RainbowPart");
                        descendant:AddTag("Cleanup_Rainbow");

                        if descendant:HasTag("GoldenVisual") or descendant:HasTag("SilverVisual") then
                            if not descendant:GetAttribute("Mutation_OriginalMaterialVariant") then
                                descendant:SetAttribute("Mutation_OriginalMaterialVariant", descendant.MaterialVariant);
                            end;

                            descendant.MaterialVariant = "Custom Stud 100%";
                        end;
                    end;
                end;

                return;
            end;

            for _, v in v150 do
                local v151 = getActiveSurfaceAppearance(v);
                v151:AddTag("RainbowPart");
                v151:AddTag("Cleanup_Rainbow");
            end;
        end,

        _RemoveFX = function(p152, p153, p154) -- Line: 763, Name: _RemoveFX
            -- upvalues: clearFXFromTag (copy), getTextureOverrideBindings (copy)
            if p154 then
                clearFXFromTag(p154, "Cleanup_RainbowFX");
            end;

            local v155 = getTextureOverrideBindings(p153);

            if v155 == nil then
                for _, descendant in ipairs(p153:GetDescendants()) do
                    if descendant:HasTag("Cleanup_Rainbow") and descendant:IsA("BasePart") then
                        if descendant:IsA("UnionOperation") then
                            local v156 = descendant:GetAttribute("Cleanup_OriginalUserPartColor");

                            if typeof(v156) == "boolean" then
                                descendant.UsePartColor = v156;
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil);
                            end;
                        end;

                        descendant:RemoveTag("RainbowPart");
                        descendant:RemoveTag("Cleanup_Rainbow");

                        if descendant:HasTag("GoldenVisual") or descendant:HasTag("SilverVisual") then
                            if not descendant:GetAttribute("Mutation_OriginalMaterialVariant") then
                                descendant:SetAttribute("Mutation_OriginalMaterialVariant", descendant.MaterialVariant);
                            end;

                            descendant.MaterialVariant = "Custom Stud 100%";
                        end;
                    end;
                end;

                return;
            end;

            for _, v in v155 do
                for _, v3 in {
                    v.original,
                    v.golden,
                    v.silver,
                    v.goldenSilver
                } do
                    if v3:HasTag("Cleanup_Rainbow") then
                        v3:RemoveTag("RainbowPart");
                        v3:RemoveTag("Cleanup_Rainbow");
                    end;
                end;
            end;
        end
    },
    Shocked = {
        Name = "Shocked",
        ValueMulti = 1.5,
        IndexSpeedRewardMulti = 1.5,
        DropWeight = 0,
        Odds = 0.07,
        ActiveRunDropWeight = 4,
        Icon = 117017731590981,
        Color = Color3.fromRGB(255, 255, 100),

        _AddFX = function(p157, p158, p159, p160) -- Line: 809, Name: _AddFX
            p157:_RemoveFX(p158, p159);

            if p159 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Shocked:GetChildren() do
                    local v161 = child:Clone();
                    v161.Parent = p159;
                    v161:AddTag("Cleanup_Shock");
                end;
            end;

            if p160 then
                local v162 = game.ReplicatedStorage.Mutation_FX.ThunderLight:Clone();
                v162.Parent = p159;
                v162:AddTag("Cleanup_Shock");
            end;

            for _, descendant in p158:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant:HasTag("Effect") then
                    descendant.Material = Enum.Material.Neon;
                end;
            end;
        end,

        _RemoveFX = function(p163, p164, p165) -- Line: 830, Name: _RemoveFX
            -- upvalues: getStoredOriginalMaterial (copy)
            if p165 then
                for _, child in p165:GetChildren() do
                    if child:HasTag("Cleanup_Shock") then
                        child:Destroy();
                    end;
                end;
            end;

            for _, descendant in p164:GetDescendants() do
                local v166;

                if descendant:IsA("BasePart") then
                    v166 = getStoredOriginalMaterial(descendant);
                else
                    v166 = nil;
                end;

                if descendant:IsA("BasePart") and (v166 and not descendant:HasTag("Effect")) then
                    descendant.Material = v166;
                end;
            end;
        end
    },
    Windstruck = {
        Name = "Windstruck",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(162, 185, 209),

        _AddFX = function(p167, p168, p169) -- Line: 851, Name: _AddFX
            p167:_RemoveFX(p168, p169);

            if p169 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Twisted:GetChildren() do
                    local v170 = child:Clone();
                    v170.Parent = p169;
                    v170:AddTag("Cleanup_Windstruck");
                end;
            end;
        end,

        _RemoveFX = function(p171, p172, p173) -- Line: 861, Name: _RemoveFX
            if p173 then
                for _, child in p173:GetChildren() do
                    if child:HasTag("Cleanup_Windstruck") then
                        child:Destroy();
                    end;
                end;
            end;
        end
    },
    Dawnbound = {
        Name = "Dawnbound",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(255, 213, 0),

        _AddFX = function(p174, p175, p176) -- Line: 876, Name: _AddFX
            p174:_RemoveFX(p175, p176);

            if p176 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Twisted:GetChildren() do
                    local v177 = child:Clone();
                    v177.Parent = p176;
                    v177:AddTag("Cleanup_Dawnbound");
                end;
            end;

            for _, descendant in p175:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant:HasTag("Effect") then
                    descendant.Material = Enum.Material.Neon;
                    descendant.Reflectance = 0.05;
                    descendant:AddTag("DawnboundVisual");
                end;
            end;
        end,

        _RemoveFX = function(p178, p179, p180) -- Line: 893, Name: _RemoveFX
            -- upvalues: getStoredOriginalMaterial (copy)
            if p180 then
                for _, child in p180:GetChildren() do
                    if child:HasTag("Cleanup_Dawnbound") then
                        child:Destroy();
                    end;
                end;
            end;

            for _, descendant in p179:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:HasTag("DawnboundVisual") then
                    descendant.Reflectance = 0;

                    if descendant:IsA("UnionOperation") then
                        if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                            descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                        end;

                        descendant.UsePartColor = true;
                    end;

                    descendant.Color = Color3.fromRGB(255, 255, 255);
                    descendant:RemoveTag("DawnboundVisual");
                    local v181 = getStoredOriginalMaterial(descendant);

                    if v181 then
                        descendant.Material = v181;
                    end;

                    if descendant:IsA("UnionOperation") then
                        local v182 = descendant:GetAttribute("Cleanup_OriginalUserPartColor");

                        if typeof(v182) == "boolean" then
                            descendant.UsePartColor = v182;
                            descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil);
                        end;
                    end;
                end;
            end;
        end
    },
    Twisted = {
        Name = "Twisted",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(191, 191, 191),

        _AddFX = function(p183, p184, p185) -- Line: 921, Name: _AddFX
            p183:_RemoveFX(p184, p185);

            if p185 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Twisted:GetChildren() do
                    local v186 = child:Clone();
                    v186.Parent = p185;
                    v186:AddTag("Cleanup_Twisted");
                end;
            end;
        end,

        _RemoveFX = function(p187, p188, p189) -- Line: 931, Name: _RemoveFX
            if p189 then
                for _, child in p189:GetChildren() do
                    if child:HasTag("Twisted") then
                        child:Destroy();
                    end;
                end;
            end;
        end
    },
    Voidtouched = {
        Name = "Voidtouched",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(225, 0, 255),
        SoundFile = {
            SoundId = 1463566014,
            Data = {
                Volume = 1
            }
        },

        _AddFX = function(p190, p191, p192) -- Line: 947, Name: _AddFX
            p190:_RemoveFX(p191, p192);

            if p192 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Voidtouched:GetChildren() do
                    local v193 = child:Clone();
                    v193.Parent = p192;
                    v193:AddTag("Cleanup_Voidtouched");
                end;
            end;
        end,

        _RemoveFX = function(p194, p195, p196) -- Line: 957, Name: _RemoveFX
            if p196 then
                for _, child in p196:GetChildren() do
                    if child:HasTag("Cleanup_Voidtouched") then
                        child:Destroy();
                    end;
                end;
            end;
        end
    },
    Wet = {
        Name = "Wet",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(64, 164, 223),

        _AddFX = function(p197, p198, p199) -- Line: 972, Name: _AddFX
            p197:_RemoveFX(p198, p199);

            if p199 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Wet:GetChildren() do
                    local v200 = child:Clone();
                    v200.Parent = p199;
                    v200.Enabled = true;
                    v200:AddTag("Cleanup_Wet");
                end;
            end;
        end,

        _RemoveFX = function(p201, p202, p203) -- Line: 983, Name: _RemoveFX
            if p203 then
                for _, child in p203:GetChildren() do
                    if child:HasTag("Cleanup_Wet") then
                        child:Destroy();
                    end;
                end;
            end;
        end
    },
    Chilled = {
        Name = "Chilled",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(135, 206, 250),

        _AddFX = function(p204, p205, p206) -- Line: 998, Name: _AddFX
            p204:_RemoveFX(p205, p206);

            if p206 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Chilled:GetChildren() do
                    local v207 = child:Clone();
                    v207.Parent = p206;
                    v207.Enabled = true;
                    v207:AddTag("Cleanup_Chilled");
                end;
            end;

            for _, child in p205:GetChildren() do
                if child:IsA("BasePart") then
                    child.Reflectance = 0.1;
                end;
            end;
        end,

        _RemoveFX = function(p208, p209, p210) -- Line: 1014, Name: _RemoveFX
            if p210 then
                for _, child in p210:GetChildren() do
                    if child:HasTag("Cleanup_Chilled") then
                        child:Destroy();
                    end;
                end;
            end;

            for _, child in p209:GetChildren() do
                if child:IsA("BasePart") then
                    child.Reflectance = 0;
                end;
            end;
        end
    },
    Frozen = {
        Name = "Frozen",
        ValueMulti = 2,
        IndexSpeedRewardMulti = 3,
        DropWeight = 0,
        Odds = 0.06,
        ActiveRunDropWeight = 3,
        Icon = 106875368516160,
        Color = Color3.fromRGB(108, 184, 255),
        SoundFile = {
            SoundId = 15749927835,
            Data = {
                Volume = 1
            }
        },

        _AddFX = function(p211, p212, p213, p214) -- Line: 1039, Name: _AddFX
            -- upvalues: BBFromArray (copy), getObjectAnchorPart (copy)
            p211:_RemoveFX(p212, p213);
            local v215 = {};
            local v216;

            if p214 then
                v216 = p212:FindFirstChild("HitBox") or p212.PrimaryPart or nil;
            else
                v216 = nil;
            end;

            if p214 and v216 then
                table.insert(v215, v216);
            else
                for _, descendant in p212:GetDescendants() do
                    if descendant:IsA("BasePart") and (descendant.Transparency < 1 and descendant:GetAttribute("MutationFXDontRender") ~= true) then
                        table.insert(v215, descendant);
                    end;
                end;
            end;

            if #v215 == 0 then
                return;
            end;

            local v217, v218 = BBFromArray(v215);
            local Part = Instance.new("Part");
            Part.Name = "FrozenShell";
            Part.Size = v218 + Vector3.new(0.1, 0.1, 0.1);

            if v216 then
                v217 = v216.CFrame or v217;
            end;

            Part.CFrame = v217;
            Part.Anchored = false;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.Massless = true;
            Part.Transparency = 0.5;
            Part.Color = Color3.fromRGB(108, 184, 255);
            Part.Material = Enum.Material.Glass;
            Part:AddTag("Cleanup_Frozen");
            Part:AddTag("Effect");
            local v219 = p213 or getObjectAnchorPart(p212);

            if v219 then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = Part;
                WeldConstraint.Part1 = v219;
                WeldConstraint.Parent = Part;
                Part.Parent = v219;
            else
                Part:Destroy();
            end;

            for _, child in game.ReplicatedStorage.Mutation_FX.Frozen:GetChildren() do
                local v220 = child:Clone();
                v220.Parent = p213;
                v220.Enabled = true;
                v220:AddTag("Cleanup_Frozen");
            end;

            for _, descendant in p212:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Reflectance = 0.3;
                end;
            end;
        end,

        _RemoveFX = function(p221, p222, p223) -- Line: 1100, Name: _RemoveFX
            local function cleanup(p224) -- Line: 1101
                for _, descendant in p224:GetDescendants() do
                    if descendant:HasTag("Cleanup_Frozen") then
                        descendant:Destroy();
                    end;
                end;
            end;

            if p223 then
                cleanup(p223);
            end;

            if p222 then
                cleanup(p222);
            end;

            for _, descendant in p222:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Reflectance = 0;
                end;
            end;
        end
    },
    Choc = {
        Name = "Choc",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(92, 64, 51),

        _AddFX = function(p225, p226, p227) -- Line: 1126, Name: _AddFX
            -- upvalues: u4 (copy)
            p225:_RemoveFX(p226, p227);

            local function LoopThroughObject(p228) -- Line: 1128
                -- upvalues: u4 (ref), LoopThroughObject (copy)
                for _, child in p228:GetChildren() do
                    if child:IsA("BasePart") and not child:GetAttribute("DontAddTexture") then
                        local u229 = {};

                        for _, child2 in game.ReplicatedStorage.Mutation_Textures.Choc:GetChildren() do
                            local v230 = child2:Clone();
                            v230.Parent = child;
                            v230.Transparency = child.Transparency;
                            table.insert(u229, v230);
                            v230:AddTag("Cleanup_Choc");
                        end;

                        u4[child] = child.Changed:Connect(function() -- Line: 1139
                            -- upvalues: child (copy), u4 (ref), u229 (copy)
                            if child.Transparency ~= 0 then
                                return;
                            end;

                            u4[child]:Disconnect();

                            for _, v in u229 do
                                v.Transparency = 0;
                            end;
                        end);
                    elseif child:IsA("Model") then
                        LoopThroughObject(child);
                    end;
                end;
            end;

            LoopThroughObject(p226);
        end,

        _RemoveFX = function(p231, p232, p233) -- Line: 1157, Name: _RemoveFX
            -- upvalues: u4 (copy)
            for _, descendant in p232:GetDescendants() do
                if descendant:HasTag("Cleanup_Choc") then
                    descendant:Destroy();
                end;

                if u4[descendant] then
                    u4[descendant]:Disconnect();
                end;
            end;
        end
    },
    Plasma = {
        Name = "Plasma",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(208, 43, 137),

        _AddFX = function(p234, p235, p236) -- Line: 1173, Name: _AddFX
            -- upvalues: u7 (ref), u6 (copy)
            p234:_RemoveFX(p235, p236);

            if p236 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Plasma:GetChildren() do
                    local v237 = child:Clone();
                    v237.Parent = p236;
                    v237.Enabled = true;
                    v237:AddTag("Cleanup_Plasma");
                end;
            end;

            for _, descendant in p235:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant:HasTag("Effect") and (descendant:GetAttribute("MutationsDontModify") ~= true and (descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true) and descendant:GetAttribute("MutationFXDontRender") ~= true) then
                    local v238 = descendant:GetAttribute("PlasmaColor");

                    if typeof(v238) == "Color3" then
                        local v239 = Color3.fromRGB(163, 0, 92);
                        local v240 = Color3.fromRGB(208, 43, 137);

                        if descendant:IsA("UnionOperation") then
                            if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                            end;

                            descendant.UsePartColor = true;
                        end;

                        local v241 = v238:Lerp(Color3.new(1, 1, 1), 0.35);
                        local v242 = v239 or v238:Lerp(Color3.new(0, 0, 0), 0.35);
                        local v243 = v240 or v241;
                        assert(v242, "luau");
                        assert(v243, "luau");
                        descendant.Color = v242:Lerp(v243, (u7 or u6):NextNumber());
                        local _ = descendant.Color;
                        descendant.Material = Enum.Material.Neon;
                        descendant.Reflectance = 0.05;
                        descendant:AddTag("PlasmaVisual");
                    end;
                end;
            end;
        end,

        _RemoveFX = function(p244, p245, p246) -- Line: 1202, Name: _RemoveFX
            -- upvalues: getStoredOriginalMaterial (copy)
            local function v248(p247) -- Line: 1203
                for _, descendant in p247:GetDescendants() do
                    if descendant:HasTag("Cleanup_Plasma") then
                        descendant:Destroy();
                    end;
                end;
            end;

            if p246 then
                v248(p246);
            end;

            if p245 then
                v248(p245);
            end;

            for _, descendant in p245:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:HasTag("PlasmaVisual") then
                    descendant.Reflectance = 0;

                    if descendant:IsA("UnionOperation") then
                        if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                            descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                        end;

                        descendant.UsePartColor = true;
                    end;

                    descendant.Color = Color3.fromRGB(255, 255, 255);
                    descendant:RemoveTag("PlasmaVisual");
                    local v249 = getStoredOriginalMaterial(descendant);

                    if v249 then
                        descendant.Material = v249;
                    end;

                    if descendant:IsA("UnionOperation") then
                        local v250 = descendant:GetAttribute("Cleanup_OriginalUserPartColor");

                        if typeof(v250) == "boolean" then
                            descendant.UsePartColor = v250;
                            descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil);
                        end;
                    end;
                end;
            end;
        end
    },
    Heavenly = {
        Name = "Heavenly",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(255, 249, 160),

        _AddFX = function(p251, p252, p253) -- Line: 1236, Name: _AddFX
            p251:_RemoveFX(p252, p253);

            if p253 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Heavenly:GetChildren() do
                    local v254 = child:Clone();
                    v254.Parent = p253;
                    v254.Enabled = true;
                    v254:AddTag("Cleanup_Heavenly");
                end;
            end;
        end,

        _RemoveFX = function(p255, p256, p257) -- Line: 1247, Name: _RemoveFX
            local function v259(p258) -- Line: 1248
                for _, descendant in p258:GetDescendants() do
                    if descendant:HasTag("Cleanup_Heavenly") then
                        descendant:Destroy();
                    end;
                end;
            end;

            if p257 then
                v259(p257);
            end;

            if p256 then
                v259(p256);
            end;
        end
    },
    Candy = {
        Name = "Candy",
        ValueMulti = 3.5,
        DropWeight = 0,
        Icon = 71641026228745,
        Color = Color3.fromRGB(255, 0, 234),

        _AddFX = function(p260, p261, p262) -- Line: 1269, Name: _AddFX
            p260:_RemoveFX(p261, p262);

            if p262 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Candy:GetChildren() do
                    local v263 = child:Clone();
                    v263.Parent = p262;
                    v263.Enabled = true;
                    v263:AddTag("Cleanup_Candy");
                end;
            end;
        end,

        _RemoveFX = function(p264, p265, p266) -- Line: 1280, Name: _RemoveFX
            local function v268(p267) -- Line: 1281
                for _, descendant in p267:GetDescendants() do
                    if descendant:HasTag("Cleanup_Candy") then
                        descendant:Destroy();
                    end;
                end;
            end;

            if p266 then
                v268(p266);
            end;

            if p265 then
                v268(p265);
            end;
        end
    },
    Burnt = {
        Name = "Burnt",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(40, 40, 40),
        SoundFile = {
            SoundId = 298181829,
            Data = {
                Volume = 1
            }
        },

        _AddFX = function(p269, p270, p271) -- Line: 1302, Name: _AddFX
            -- upvalues: u7 (ref), u6 (copy)
            p269:_RemoveFX(p270, p271);

            if p271 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Burnt:GetChildren() do
                    local v272 = child:Clone();
                    v272.Parent = p271;
                    v272.Enabled = true;
                    v272:AddTag("Cleanup_Burnt");
                end;
            end;

            for _, descendant in p270:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant:HasTag("Effect") and (descendant:GetAttribute("MutationsDontModify") ~= true and (descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true) and descendant:GetAttribute("MutationFXDontRender") ~= true) then
                    local v273 = descendant:GetAttribute("BurntColor");

                    if typeof(v273) == "Color3" then
                        if descendant:IsA("UnionOperation") then
                            if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                            end;

                            descendant.UsePartColor = true;
                        end;

                        local v274 = v273:Lerp(Color3.new(1, 1, 1), 0.35);
                        local v275 = nil or v273:Lerp(Color3.new(0, 0, 0), 0.35);
                        local v276 = nil or v274;
                        assert(v275, "luau");
                        assert(v276, "luau");
                        descendant.Color = v275:Lerp(v276, (u7 or u6):NextNumber());
                        local _ = descendant.Color;
                        descendant.Material = Enum.Material.Slate;
                        descendant.Reflectance = 0.05;
                        descendant:AddTag("BurntVisual");
                    end;
                end;
            end;
        end,

        _RemoveFX = function(p277, p278, p279) -- Line: 1326, Name: _RemoveFX
            -- upvalues: getStoredOriginalMaterial (copy)
            local function v281(p280) -- Line: 1327
                for _, descendant in p280:GetDescendants() do
                    if descendant:HasTag("Cleanup_Burnt") then
                        descendant:Destroy();
                    end;
                end;
            end;

            if p279 then
                v281(p279);
            end;

            if p278 then
                v281(p278);
            end;

            for _, descendant in p278:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:HasTag("BurntVisual") then
                    descendant.Reflectance = 0;

                    if descendant:IsA("UnionOperation") then
                        if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                            descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                        end;

                        descendant.UsePartColor = true;
                    end;

                    descendant.Color = Color3.fromRGB(255, 255, 255);
                    descendant:RemoveTag("BurntVisual");
                    local v282 = getStoredOriginalMaterial(descendant);

                    if v282 then
                        descendant.Material = v282;
                    end;

                    if descendant:IsA("UnionOperation") then
                        local v283 = descendant:GetAttribute("Cleanup_OriginalUserPartColor");

                        if typeof(v283) == "boolean" then
                            descendant.UsePartColor = v283;
                            descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil);
                        end;
                    end;
                end;
            end;
        end
    },
    Bloodmoon = {
        Name = "Bloodmoon",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(200, 0, 0),

        _AddFX = function(p284, p285, p286) -- Line: 1360, Name: _AddFX
            -- upvalues: u7 (ref), u6 (copy)
            p284:_RemoveFX(p285, p286);

            if p286 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Bloodlit:GetChildren() do
                    local v287 = child:Clone();
                    v287.Parent = p286;
                    v287.Enabled = true;
                    v287:AddTag("Cleanup_Bloodlit");
                    v287:AddTag("Effect");
                end;
            end;

            for _, descendant in p285:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant:HasTag("Effect") and (descendant:GetAttribute("MutationsDontModify") ~= true and (descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true) and descendant:GetAttribute("MutationFXDontRender") ~= true) then
                    local v288 = descendant:GetAttribute("BloodlitColor");

                    if typeof(v288) == "Color3" then
                        local v289 = Color3.fromRGB(148, 0, 0);
                        local v290 = Color3.fromRGB(200, 0, 0);

                        if descendant:IsA("UnionOperation") then
                            if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                            end;

                            descendant.UsePartColor = true;
                        end;

                        local v291 = v288:Lerp(Color3.new(1, 1, 1), 0.35);
                        local v292 = v289 or v288:Lerp(Color3.new(0, 0, 0), 0.35);
                        local v293 = v290 or v291;
                        assert(v292, "luau");
                        assert(v293, "luau");
                        descendant.Color = v292:Lerp(v293, (u7 or u6):NextNumber());
                        local _ = descendant.Color;
                        descendant.Reflectance = 0.3;
                        descendant:AddTag("BloodlitVisual");
                    end;
                end;
            end;
        end,

        _RemoveFX = function(p294, p295, p296) -- Line: 1384, Name: _RemoveFX
            -- upvalues: getStoredOriginalMaterial (copy)
            if p296 then
                for _, child in p296:GetChildren() do
                    if child:HasTag("Cleanup_Bloodlit") then
                        child:Destroy();
                    end;
                end;
            end;

            for _, descendant in p295:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:HasTag("BloodlitVisual") then
                    descendant.Reflectance = 0;
                    descendant:RemoveTag("BloodlitVisual");
                    local v297 = getStoredOriginalMaterial(descendant);

                    if v297 then
                        descendant.Material = v297;
                    end;

                    if descendant:IsA("UnionOperation") then
                        local v298 = descendant:GetAttribute("Cleanup_OriginalUserPartColor");

                        if typeof(v298) == "boolean" then
                            descendant.UsePartColor = v298;
                            descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil);
                        end;
                    end;
                end;
            end;
        end
    },
    Zombified = {
        Name = "Zombified",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(128, 199, 127),

        _AddFX = function(p299, p300, p301) -- Line: 1410, Name: _AddFX
            p299:_RemoveFX(p300, p301);

            if p301 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Zombified:GetChildren() do
                    local v302 = child:Clone();
                    v302.Parent = p301;
                    v302.Enabled = true;
                    v302:AddTag("Cleanup_Zombified");
                    v302:AddTag("Effect");
                end;
            end;

            for _, descendant in p300:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant:HasTag("Effect") then
                    descendant:AddTag("ZombifiedVisual");
                end;
            end;
        end,

        _RemoveFX = function(p303, p304, p305) -- Line: 1427, Name: _RemoveFX
            -- upvalues: getStoredOriginalMaterial (copy)
            if p305 then
                for _, child in p305:GetChildren() do
                    if child:HasTag("Cleanup_Zombified") then
                        child:Destroy();
                    end;
                end;
            end;

            for _, descendant in p304:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:HasTag("ZombifiedVisual") then
                    descendant:RemoveTag("ZombifiedVisual");
                    local v306 = getStoredOriginalMaterial(descendant);

                    if v306 then
                        descendant.Material = v306;
                    end;
                end;
            end;
        end
    },
    Celestial = {
        Name = "Celestial",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(255, 0, 255),

        _AddFX = function(p307, p308, p309) -- Line: 1451, Name: _AddFX
            p307:_RemoveFX(p308, p309);

            if p309 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Celestial:GetChildren() do
                    local v310 = child:Clone();
                    v310.Parent = p309;
                    v310.Enabled = true;
                    v310:AddTag("Cleanup_Celestial");
                    v310:AddTag("Effect");
                end;
            end;

            for _, descendant in p308:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant:HasTag("Effect") then
                    descendant.Reflectance = 0.5;
                    descendant:AddTag("CelestialVisual");
                end;
            end;
        end,

        _RemoveFX = function(p311, p312, p313) -- Line: 1469, Name: _RemoveFX
            -- upvalues: getStoredOriginalMaterial (copy)
            if p313 then
                for _, child in p313:GetChildren() do
                    if child:HasTag("Cleanup_Celestial") then
                        child:Destroy();
                    end;
                end;
            end;

            for _, descendant in p312:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:HasTag("CelestialVisual") then
                    descendant.Reflectance = 0;
                    descendant:RemoveTag("CelestialVisual");
                    local v314 = getStoredOriginalMaterial(descendant);

                    if v314 then
                        descendant.Material = v314;
                    end;
                end;
            end;
        end
    },
    HoneyGlazed = {
        Name = "HoneyGlazed",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(255, 204, 0),

        _AddFX = function(p315, p316, p317) -- Line: 1494, Name: _AddFX
            p315:_RemoveFX(p316, p317);

            if p317 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Honey:GetChildren() do
                    local v318 = child:Clone();
                    v318.Parent = p317;
                    v318.Enabled = true;
                    v318:AddTag("Cleanup_Honey");
                    v318:AddTag("Effect");
                end;
            end;

            for _, descendant in p316:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant:HasTag("Effect") then
                    descendant:AddTag("HoneyVisual");
                end;
            end;
        end,

        _RemoveFX = function(p319, p320, p321) -- Line: 1511, Name: _RemoveFX
            -- upvalues: getStoredOriginalMaterial (copy)
            if p321 then
                for _, child in p321:GetChildren() do
                    if child:HasTag("Cleanup_Honey") then
                        child:Destroy();
                    end;
                end;
            end;

            for _, descendant in p320:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:HasTag("HoneyVisual") then
                    descendant:RemoveTag("HoneyVisual");
                    local v322 = getStoredOriginalMaterial(descendant);

                    if v322 then
                        descendant.Material = v322;
                    end;
                end;
            end;
        end
    },
    Pollinated = {
        Name = "Pollinated",
        ValueMulti = 1,
        DropWeight = 0,
        Color = Color3.fromRGB(255, 170, 0),

        _AddFX = function(p323, p324, p325) -- Line: 1535, Name: _AddFX
            -- upvalues: u7 (ref), u6 (copy)
            p323:_RemoveFX(p324, p325);

            if p325 then
                for _, child in game.ReplicatedStorage.Mutation_FX.Pollinated:GetChildren() do
                    local v326 = child:Clone();
                    v326.Parent = p325;
                    v326.Enabled = true;
                    v326:AddTag("Cleanup_Pollinated");
                    v326:AddTag("Effect");
                end;
            end;

            for _, descendant in p324:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant:HasTag("Effect") and (descendant:GetAttribute("MutationsDontModify") ~= true and (descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true) and descendant:GetAttribute("MutationFXDontRender") ~= true) then
                    local v327 = descendant:GetAttribute("PollinatedColor");

                    if typeof(v327) == "Color3" then
                        local v328 = Color3.fromRGB(177, 118, 0);
                        local v329 = Color3.fromRGB(255, 170, 0);

                        if descendant:IsA("UnionOperation") then
                            if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                            end;

                            descendant.UsePartColor = true;
                        end;

                        local v330 = v327:Lerp(Color3.new(1, 1, 1), 0.35);
                        local v331 = v328 or v327:Lerp(Color3.new(0, 0, 0), 0.35);
                        local v332 = v329 or v330;
                        assert(v331, "luau");
                        assert(v332, "luau");
                        descendant.Color = v331:Lerp(v332, (u7 or u6):NextNumber());
                        local _ = descendant.Color;
                        descendant:AddTag("PollinatedlVisual");
                    end;
                end;
            end;
        end,

        _RemoveFX = function(p333, p334, p335) -- Line: 1563, Name: _RemoveFX
            -- upvalues: getStoredOriginalMaterial (copy)
            if p335 then
                for _, child in p335:GetChildren() do
                    if child:HasTag("Cleanup_Pollinated") then
                        child:Destroy();
                    end;
                end;
            end;

            for _, descendant in p334:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:HasTag("PollinatedlVisual") then
                    descendant:RemoveTag("PollinatedVisual");
                    local v336 = getStoredOriginalMaterial(descendant);

                    if v336 then
                        descendant.Material = v336;
                    end;

                    if descendant:IsA("UnionOperation") then
                        local v337 = descendant:GetAttribute("Cleanup_OriginalUserPartColor");

                        if typeof(v337) == "boolean" then
                            descendant.UsePartColor = v337;
                            descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil);
                        end;
                    end;
                end;
            end;
        end
    },
    Alpha = {
        Name = "Alpha",
        DisplayOverride = "Alpha 😡",
        ValueMulti = 4,
        DropWeight = 0,
        ForceIconDisplayInUI = true,
        Icon = 96324869543458,
        PersonalityOverride = "AGGRESSIVE",
        Color = Color3.fromRGB(252, 0, 0),

        _AddFX = function(p338, p339, p340) -- Line: 1592, Name: _AddFX
            p338:_RemoveFX(p339, p340);
        end,

        _RemoveFX = function(p341, p342, p343) -- Line: 1603, Name: _RemoveFX
        end
    },
    Golden = {
        Name = "Golden",
        ValueMulti = 2.5,
        DropWeight = 4,
        Odds = 0.04,
        ActiveRunDropWeight = 0,
        Icon = 134818382291054,
        Color = Color3.fromRGB(251, 255, 0),

        _AddFX = function(p344, p345, p346) -- Line: 1627, Name: _AddFX
            -- upvalues: applyVFXToFXPartWithTag (copy), getTextureOverrideBindings (copy), applyMetalTextureOverride (copy), u7 (ref), u6 (copy)
            p344:_RemoveFX(p345, p346);

            if p346 then
                applyVFXToFXPartWithTag(p346, "Golden", "Cleanup_GoldenFX");
            end;

            local v347 = getTextureOverrideBindings(p345);

            if v347 == nil then
                for _, descendant in p345:GetDescendants() do
                    if descendant:IsA("BasePart") and not descendant:HasTag("Effect") and (descendant:GetAttribute("MutationsDontModify") ~= true and (descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true) and descendant:GetAttribute("MutationFXDontRender") ~= true) then
                        local v348 = Color3.fromRGB(251, 255, 0);
                        local v349 = Color3.fromRGB(216, 158, 0);
                        local v350 = Color3.fromRGB(251, 255, 0);

                        if descendant:IsA("UnionOperation") then
                            if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                            end;

                            descendant.UsePartColor = true;
                        end;

                        local v351 = v348:Lerp(Color3.new(1, 1, 1), 0.35);
                        local v352 = v349 or v348:Lerp(Color3.new(0, 0, 0), 0.35);
                        local v353 = v350 or v351;
                        assert(v352, "luau");
                        assert(v353, "luau");
                        descendant.Color = v352:Lerp(v353, (u7 or u6):NextNumber());
                        local _ = descendant.Color;
                        local SmoothPlastic = Enum.Material.SmoothPlastic;

                        if not descendant:GetAttribute("Mutation_OriginalMaterial") then
                            descendant:SetAttribute("Mutation_OriginalMaterial", descendant.Material.Name);
                        end;

                        descendant.Material = SmoothPlastic;

                        if not descendant:GetAttribute("Mutation_OriginalMaterialVariant") then
                            descendant:SetAttribute("Mutation_OriginalMaterialVariant", descendant.MaterialVariant);
                        end;

                        descendant.MaterialVariant = "Custom Stud 100%";
                        descendant:AddTag("GoldenVisual");

                        if descendant:IsA("MeshPart") then
                            descendant.TextureID = "";
                        end;
                    elseif descendant:IsA("SurfaceAppearance") and descendant.Parent then
                        local Parent = descendant.Parent;

                        if Parent:GetAttribute("MutationsDontModify") ~= true and (Parent:GetAttribute("DontAddTexture") ~= true and Parent:GetAttribute("IsEye") ~= true) and Parent:GetAttribute("MutationFXDontRender") ~= true then
                            descendant:Destroy();
                        end;
                    end;
                end;

                return;
            end;

            applyMetalTextureOverride(v347, function(p354) -- Line: 1636
                return p354.golden;
            end, "GoldenVisual");
        end,

        _RemoveFX = function(p355, p356, p357) -- Line: 1665, Name: _RemoveFX
            -- upvalues: clearFXFromTag (copy), getTextureOverrideBindings (copy), removeMetalTextureOverride (copy), getStoredOriginalMaterial (copy)
            if p357 then
                clearFXFromTag(p357, "Cleanup_GoldenFX");
            end;

            local v358 = getTextureOverrideBindings(p356);

            if v358 == nil then
                for _, descendant in p356:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant:HasTag("GoldenVisual") then
                        descendant:RemoveTag("GoldenVisual");
                        local v359 = descendant:GetAttribute("Mutation_OriginalColor");

                        if v359 then
                            descendant.Color = v359;
                        end;

                        local v360 = getStoredOriginalMaterial(descendant);

                        if v360 then
                            descendant.Material = v360;
                        end;

                        local v361 = descendant:GetAttribute("Mutation_OriginalMaterialVariant");

                        if typeof(v361) ~= "string" then
                            v361 = nil;
                        end;

                        if v361 then
                            descendant.MaterialVariant = v361;
                        end;

                        if descendant:IsA("UnionOperation") then
                            local v362 = descendant:GetAttribute("Cleanup_OriginalUserPartColor");

                            if typeof(v362) == "boolean" then
                                descendant.UsePartColor = v362;
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil);
                            end;
                        end;
                    end;
                end;

                return;
            end;

            removeMetalTextureOverride(v358, function(p363) -- Line: 1673
                return p363.golden;
            end, function(p364) -- Line: 1676
                return p364.silver;
            end, "GoldenVisual", "SilverVisual");
        end
    },
    Magma = {
        Name = "Magma",
        ValueMulti = 2,
        IndexSpeedRewardMulti = 2,
        Icon = 139648796443816,
        DropWeight = 0,
        Odds = 0.07,
        ActiveRunDropWeight = 5,
        Color = Color3.fromRGB(255, 85, 0),

        _AddFX = function(p365, p366, p367) -- Line: 1716, Name: _AddFX
            -- upvalues: tintModel (copy)
            p365:_RemoveFX(p366, p367);
            tintModel(p366, ({
                GRADIENT = {
                    Color3.fromRGB(255, 4, 0),
                    Color3.fromRGB(255, 0, 117),
                    Color3.fromRGB(255, 0, 146),
                    Color3.fromRGB(227, 18, 0)
                },
                BASE_COLOR = Color3.fromRGB(223, 98, 26)
            }).BASE_COLOR, 1.35);

            if p366.PrimaryPart then
                for _, child in game.ReplicatedStorage.Mutation_FX.Magma:GetChildren() do
                    local v368 = child:Clone();
                    v368.Parent = p366.PrimaryPart;
                    v368:AddTag("cleanup_magma");
                end;
            end;
        end,

        _RemoveFX = function(p369, p370, p371) -- Line: 1739, Name: _RemoveFX
            -- upvalues: clearTint (copy), clearMaterial (copy)
            clearTint(p370);
            clearMaterial(p370);
        end
    },
    Silver = {
        Name = "Silver",
        ValueMulti = 1.2,
        DropWeight = 6,
        Odds = 0.06,
        ActiveRunDropWeight = 0,
        Icon = 108639493197858,
        Color = Color3.fromRGB(192, 192, 192),

        _AddFX = function(p372, p373, p374) -- Line: 1752, Name: _AddFX
            -- upvalues: applyVFXToFXPartWithTag (copy), getTextureOverrideBindings (copy), applyMetalTextureOverride (copy), u7 (ref), u6 (copy)
            p372:_RemoveFX(p373, p374);

            if p374 then
                applyVFXToFXPartWithTag(p374, "Silver", "Cleanup_SilverFX");
            end;

            local v375 = getTextureOverrideBindings(p373);

            if v375 == nil then
                for _, descendant in p373:GetDescendants() do
                    if descendant:IsA("BasePart") and not descendant:HasTag("Effect") and (descendant:GetAttribute("MutationsDontModify") ~= true and (descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true) and descendant:GetAttribute("MutationFXDontRender") ~= true) then
                        local v376 = Color3.fromRGB(192, 192, 192);
                        local v377 = Color3.fromRGB(134, 134, 134);
                        local v378 = Color3.fromRGB(192, 192, 192);

                        if descendant:IsA("UnionOperation") then
                            if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                            end;

                            descendant.UsePartColor = true;
                        end;

                        local v379 = v376:Lerp(Color3.new(1, 1, 1), 0.35);
                        local v380 = v377 or v376:Lerp(Color3.new(0, 0, 0), 0.35);
                        local v381 = v378 or v379;
                        assert(v380, "luau");
                        assert(v381, "luau");
                        descendant.Color = v380:Lerp(v381, (u7 or u6):NextNumber());
                        local _ = descendant.Color;
                        local SmoothPlastic = Enum.Material.SmoothPlastic;

                        if not descendant:GetAttribute("Mutation_OriginalMaterial") then
                            descendant:SetAttribute("Mutation_OriginalMaterial", descendant.Material.Name);
                        end;

                        descendant.Material = SmoothPlastic;

                        if not descendant:GetAttribute("Mutation_OriginalMaterialVariant") then
                            descendant:SetAttribute("Mutation_OriginalMaterialVariant", descendant.MaterialVariant);
                        end;

                        descendant.MaterialVariant = "Custom Stud 100%";
                        descendant:AddTag("SilverVisual");

                        if descendant:IsA("MeshPart") then
                            descendant.TextureID = "";
                        end;
                    elseif descendant:IsA("SurfaceAppearance") and descendant.Parent then
                        local Parent = descendant.Parent;

                        if Parent:GetAttribute("MutationsDontModify") ~= true and (Parent:GetAttribute("DontAddTexture") ~= true and Parent:GetAttribute("IsEye") ~= true) and Parent:GetAttribute("MutationFXDontRender") ~= true then
                            descendant:Destroy();
                        end;
                    end;
                end;

                return;
            end;

            applyMetalTextureOverride(v375, function(p382) -- Line: 1762
                return p382.silver;
            end, "SilverVisual");
        end,

        _RemoveFX = function(p383, p384, p385) -- Line: 1790, Name: _RemoveFX
            -- upvalues: clearFXFromTag (copy), getTextureOverrideBindings (copy), removeMetalTextureOverride (copy), getStoredOriginalMaterial (copy)
            if p385 then
                clearFXFromTag(p385, "Cleanup_SilverFX");
            end;

            local v386 = getTextureOverrideBindings(p384);

            if v386 == nil then
                for _, descendant in p384:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant:HasTag("SilverVisual") then
                        descendant:RemoveTag("SilverVisual");
                        local v387 = descendant:GetAttribute("Mutation_OriginalColor");

                        if v387 then
                            descendant.Color = v387;
                        end;

                        local v388 = getStoredOriginalMaterial(descendant);

                        if v388 then
                            descendant.Material = v388;
                        end;

                        local v389 = descendant:GetAttribute("Mutation_OriginalMaterialVariant");

                        if typeof(v389) ~= "string" then
                            v389 = nil;
                        end;

                        if v389 then
                            descendant.MaterialVariant = v389;
                        end;

                        if descendant:IsA("UnionOperation") then
                            local v390 = descendant:GetAttribute("Cleanup_OriginalUserPartColor");

                            if typeof(v390) == "boolean" then
                                descendant.UsePartColor = v390;
                                descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil);
                            end;
                        end;
                    end;
                end;

                return;
            end;

            removeMetalTextureOverride(v386, function(p391) -- Line: 1798
                return p391.silver;
            end, function(p392) -- Line: 1801
                return p392.golden;
            end, "SilverVisual", "GoldenVisual");
        end
    },
    Scared = {
        Name = "Scared",
        DisplayOverride = "Scared 😨",
        ValueMulti = 2,
        DropWeight = 0,
        ForceIconDisplayInUI = true,
        Icon = 76572417421413,
        PersonalityOverride = "FLEEING",
        Color = Color3.fromRGB(79, 149, 255),

        _AddFX = function(p393, p394, p395) -- Line: 1842, Name: _AddFX
            p393:_RemoveFX(p394, p395);
        end,

        _RemoveFX = function(p396, p397, p398) -- Line: 1846, Name: _RemoveFX
        end
    }
};
local u400 = {};

local function GetFXPart(p401) -- Line: 633
    -- upvalues: Constants (copy), u1 (copy), BBFromArray (copy)
    if not p401 then
        warn("MutationHandler.GetFXPart | No item given!");

        return nil;
    end;

    local FXPart = p401:FindFirstChild("FXPart");

    if FXPart and FXPart:IsA("BasePart") then
        return FXPart;
    end;

    local v402 = nil;

    if p401:IsA("Tool") then
        v402 = p401:FindFirstChild("Handle") or p401:FindFirstChild("Segment1");
    elseif p401:IsA("Model") then
        v402 = p401.PrimaryPart;
    end;

    if not v402 then
        local v403 = `MutationHandler.GetFXPart | No primary part found for item '{p401.Name}'`;

        if Constants.IS_STUDIO then
            error(v403);
        else
            u1:AtError():Log(v403);
        end;

        return nil;
    end;

    local v404 = {};

    for _, descendant in ipairs(p401:GetDescendants()) do
        if descendant:IsA("BasePart") and (descendant.Transparency < 1 and descendant:GetAttribute("MutationFXDontRender") ~= true) then
            table.insert(v404, descendant);
        end;
    end;

    local v405, v406;

    if #v404 > 0 then
        v405, v406 = BBFromArray(v404);
    else
        v405, v406 = p401:GetBoundingBox();
    end;

    local Part = Instance.new("Part");
    Part.Name = "FXPart";
    Part.CFrame = v405;
    Part.Size = v406;
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.Anchored = false;
    Part.Massless = true;
    Part.Parent = p401;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = Part;
    WeldConstraint.Part1 = v402;
    WeldConstraint.Parent = Part;

    return Part;
end;

local function applyGoldenSilverCombo(p407, p408) -- Line: 414
    -- upvalues: getTextureOverrideBindings (copy), setActiveSurfaceAppearance (copy), getSilverMetalPartition (copy), CRC32 (copy)
    local v409 = getTextureOverrideBindings(p407);

    if v409 ~= nil then
        local function _(p410) -- Line: 417
            return p410.goldenSilver;
        end;

        for _, v in v409 do
            setActiveSurfaceAppearance(v, v.goldenSilver);
        end;

        return;
    end;

    local v411 = getSilverMetalPartition(p407, p408);
    local new = Random.new;
    local v412 = CRC32((`MutationVisual/{p408}/Golden`));
    local v413 = math.abs(v412) % 2147483647;
    local v414 = new(v413 <= 0 and 1 or v413);
    local new2 = Random.new;
    local v415 = CRC32((`MutationVisual/{p408}/Silver`));
    local v416 = math.abs(v415) % 2147483647;
    local v417 = new2(v416 <= 0 and 1 or v416);

    for _, descendant in p407:GetDescendants() do
        if descendant:IsA("BasePart") and not descendant:HasTag("Effect") and (descendant:GetAttribute("MutationsDontModify") ~= true and (descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true) and descendant:GetAttribute("MutationFXDontRender") ~= true) then
            local v418 = Color3.fromRGB(251, 255, 0);
            local v419 = Color3.fromRGB(216, 158, 0);
            local v420 = Color3.fromRGB(251, 255, 0);
            local v421 = v418:Lerp(Color3.new(1, 1, 1), 0.35);
            local v422 = v419 or v418:Lerp(Color3.new(0, 0, 0), 0.35);
            local v423 = v420 or v421;
            assert(v422, "luau");
            assert(v423, "luau");
            local v424 = v422:Lerp(v423, v414:NextNumber());
            local v425 = Color3.fromRGB(192, 192, 192);
            local v426 = Color3.fromRGB(134, 134, 134);
            local v427 = Color3.fromRGB(192, 192, 192);
            local v428 = v425:Lerp(Color3.new(1, 1, 1), 0.35);
            local v429 = v426 or v425:Lerp(Color3.new(0, 0, 0), 0.35);
            local v430 = v427 or v428;
            assert(v429, "luau");
            assert(v430, "luau");
            local v431 = v429:Lerp(v430, v417:NextNumber());

            if descendant:IsA("UnionOperation") then
                if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                    descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor);
                end;

                descendant.UsePartColor = true;
            end;

            if v411[descendant] then
                v424 = v431;
            end;

            descendant.Color = v424;
        end;
    end;
end;

for i in u399 do
    u400[i] = i;
end;

local v432 = 0;

for _, v in pairs(u399) do
    if v.Name ~= "None" then
        v432 = v432 + v.DropWeight;
    end;
end;

u399.None.DropWeight = math.max(0, 100 - v432);

if Constants.IS_STUDIO then
    assert(u399.None.DropWeight > 0, "MutationHandler | None mutation must have a non-negative DropWeight");
end;

function u3.FilterMutationsForCombo(p433) -- Line: 1870
    local v434 = table.clone(p433);
    local v435 = table.find(v434, "Frozen");
    local v436 = table.find(v434, "Wet");
    local v437 = table.find(v434, "Chilled");

    if v435 or v436 and v437 then
        if v436 then
            table.remove(v434, v436);
        end;

        if v437 then
            table.remove(v434, v437);
        end;

        if not v435 then
            table.insert(v434, "Frozen");
        end;
    end;

    return v434;
end;

function u3.GetMutations() -- Line: 1891
    -- upvalues: TableUtil (copy), u399 (copy)
    return TableUtil.Copy(u399, true);
end;

function u3.GetMutationsMap() -- Line: 1895
    -- upvalues: u400 (copy)
    return table.clone(u400);
end;

function u3.Exists(p438) -- Line: 1899
    -- upvalues: Asserts (copy), u399 (copy)
    Asserts.string(p438);

    return u399[p438] ~= nil;
end;

function u3.GetMutation(p439) -- Line: 1904
    -- upvalues: u399 (copy), Constants (copy), u1 (copy), TableUtil (copy)
    local v440 = u399[p439];

    if v440 then
        return TableUtil.Copy(v440, true);
    end;

    local v441 = `MutationHandler:GetMutation | Mutation {p439} does not exist`;

    if Constants.IS_STUDIO then
        error(v441);

        return;
    end;

    u1:AtError():Log(v441);
end;

function u3.GetPersonalityOverride(p442) -- Line: 1918
    -- upvalues: Asserts (copy), u399 (copy)
    Asserts.string(p442);
    local v443 = u399[p442];

    if v443 then
        return v443.PersonalityOverride;
    end;

    return nil;
end;

function u3.GetDisplayName(p444) -- Line: 1927
    -- upvalues: Asserts (copy), u3 (copy)
    Asserts.string(p444);
    local v445 = u3.GetMutation(p444);

    if v445 then
        return v445.DisplayOverride or v445.Name;
    end;

    return p444;
end;

function u3.GetVisualOddsMultiplier(p446, p447) -- Line: 1938
    -- upvalues: u399 (copy), u3 (copy)
    local u448 = 1;
    local u449 = {};
    local v450 = {};

    local function addMutation(p451) -- Line: 1943
        -- upvalues: u449 (copy), u399 (ref), u448 (ref)
        if typeof(p451) ~= "string" or (p451 == "" or u449[p451]) then
            return;
        end;

        local v452 = u399[p451];

        if not v452 or (v452.Odds or 0) <= 0 then
            return;
        end;

        u449[p451] = true;
        u448 = u448 * (1 / v452.Odds);
    end;

    if typeof(p447) == "string" and p447 ~= "" then
        table.insert(v450, p447);
    end;

    if typeof(p446) == "table" then
        for _, v in ipairs(p446) do
            table.insert(v450, v);
        end;
    end;

    for _, v in ipairs(u3.FilterMutationsForCombo(v450)) do
        if typeof(v) == "string" and v ~= "" then
            if not u449[v] then
                local v453 = u399[v];

                if v453 then
                    if (v453.Odds or 0) > 0 then
                        u449[v] = true;
                        u448 = u448 * (1 / v453.Odds);
                    end;
                end;
            end;
        end;
    end;

    return u448;
end;

function u3.GetMutationsDropTable() -- Line: 1974
    -- upvalues: u5 (ref), u399 (copy)
    if u5 then
        return u5;
    end;

    local v454 = {};

    for _, v in u399 do
        if v.DropWeight and v.DropWeight >= 0 then
            table.insert(v454, { v.Name, v.DropWeight });
        end;
    end;

    u5 = v454;

    return v454;
end;

function u3.GetTotalMutationsEarningMulti(p455) -- Line: 2008
    -- upvalues: u399 (copy), Constants (copy), u1 (copy)
    local v456 = 1;

    for _, v in p455 do
        local v457 = u399[v];

        if v457 then
            if v457.ValueMulti < 1 then
                local v458 = `MutationHandler:GetTotalMutationsEarningMulti | Mutation {v} multiplier is less than 1 which is invalid for earnings calculation`;

                if Constants.IS_STUDIO then
                    error(v458);
                else
                    u1:AtError():Log(v458);
                end;
            end;

            v456 = v456 + math.max(0, v457.ValueMulti - 1);
        else
            local v459 = `MutationHandler:GetTotalMutationsEarningMulti | Mutation {v} does not exist`;

            if Constants.IS_STUDIO then
                error(v459);
            else
                u1:AtError():Log(v459);
            end;
        end;
    end;

    return math.max(1, v456);
end;

function u3.AddMutationByName(u460, p461, u462, u463) -- Line: 2035
    -- upvalues: Asserts (copy), u399 (copy), GetFXPart (copy), Constants (copy), u1 (copy), u7 (ref), CRC32 (copy), applyGoldenSilverCombo (copy)
    Asserts.string(p461);
    Asserts.Instance(u460);
    Asserts.optional.number(u463);
    local v464 = u399[p461];
    local v465 = `MutationHandler:AddMutationByName | Mutation {p461} does not exist`;
    local u466 = assert(v464, v465);
    local u467 = GetFXPart(u460);

    if not u467 then
        local v468 = `MutationHandler:AddMutationByName | No FX part found for item {u460.Name}`;

        if Constants.IS_STUDIO then
            error(v468);

            return;
        end;

        u1:AtError():Log(v468);

        return;
    end;

    local u469;

    if p461 == "Golden" then
        u469 = false;

        for _, descendant in u460:GetDescendants() do
            if descendant:HasTag("SilverVisual") then
                u469 = true;
                break;
            end;
        end;
    elseif p461 == "Silver" then
        u469 = false;

        for _, descendant in u460:GetDescendants() do
            if descendant:HasTag("GoldenVisual") then
                u469 = true;
                break;
            end;
        end;
    else
        u469 = false;
    end;

    local v470 = u7;
    local v471;

    if u463 == nil then
        v471 = v470;
    else
        local new = Random.new;
        local v472 = CRC32((`MutationVisual/{u463}/{p461}`));
        local v473 = math.abs(v472) % 2147483647;
        v471 = new(v473 <= 0 and 1 or v473);
    end;

    u7 = v471;
    local success, result = pcall(function() -- Line: 2063
        -- upvalues: u466 (copy), u460 (copy), u467 (copy), u462 (copy), u469 (copy), u463 (copy), applyGoldenSilverCombo (ref)
        u466:_AddFX(u460, u467, u462);

        if u469 then
            applyGoldenSilverCombo(u460, (assert(u463, "Golden and Silver combination requires a visual seed")));
        end;
    end);
    u7 = v470;

    if not success then
        error(result, 0);
    end;
end;

function u3.RemoveMutation(p474, p475) -- Line: 2076
    -- upvalues: Asserts (copy), u399 (copy), GetFXPart (copy), Constants (copy), u1 (copy)
    Asserts.string(p475);
    Asserts.Instance(p474);
    local v476 = u399[p475];
    local v477 = `MutationHandler:AddMutationByName | Mutation {p475} does not exist`;
    local v478 = assert(v476, v477);
    local v479 = GetFXPart(p474);

    if v479 then
        v478:_RemoveFX(p474, v479);

        return;
    end;

    local v480 = `MutationHandler:AddMutationByName | No FX part found for item {p474.Name}`;

    if Constants.IS_STUDIO then
        error(v480);

        return;
    end;

    u1:AtError():Log(v480);
end;

function u3.GetItemMutations(p481) -- Line: 2095
    -- upvalues: u3 (copy)
    local v482 = {};

    for _, v in u3.GetMutations() do
        if p481:GetAttribute(v.Name) then
            table.insert(v482, v);
        end;
    end;

    return v482;
end;

function u3.GetMutationsAsString(p483, p484) -- Line: 2105
    -- upvalues: u399 (copy)
    local v485 = "";

    for _, v in u399 do
        local Name = v.Name;

        if p483:GetAttribute(Name) then
            if v485 ~= "" then
                v485 = v485 .. ", ";
            end;

            v485 = v485 .. Name;
        end;
    end;

    if v485 ~= "" and p484 then
        v485 = "[" .. v485 .. "]";
    end;

    return v485;
end;

function u3.ExtractMutationsFromString(p486) -- Line: 2122
    -- upvalues: u3 (copy)
    local v487 = {};

    if not p486 or p486 == "" then
        return v487;
    end;

    local v488 = p486:gsub("%[", ""):gsub("%]", ""):gsub("%s+", "");

    for i in string.gmatch(v488, "([^,]+)") do
        local v489 = false;

        for _, v in u3.GetMutations() do
            if v.Name == i then
                table.insert(v487, v);
                v489 = true;
            end;
        end;

        if not v489 then
            warn(("MutationHandler:ExtractMutationsFromString | Mutation name: %s does not exist"):format(i));
        end;
    end;

    return v487;
end;

function u3.RemoveAllMutations(u490) -- Line: 2148
    -- upvalues: Asserts (copy), GetFXPart (copy), u399 (copy)
    Asserts.Instance(u490);
    local u491 = GetFXPart(u490);

    if not u491 then
        return;
    end;

    for i, v in pairs(u399) do
        if i ~= "None" then
            task.spawn(function() -- Line: 2158
                -- upvalues: v (copy), u490 (copy), u491 (copy)
                v:_RemoveFX(u490, u491);
            end);
        end;
    end;
end;

local v492 = {};

for _, v in u399 do
    if Constants.IS_STUDIO then
        local v493, v494 = v2.Mutation(v);
        local v495 = `MutationHandler | Mutation {v.Name} does not match schema: {v494}`;
        assert(v493, v495);
    end;

    v492[v.Name] = true;
end;

u3.MutationNames = v492;

return u3;