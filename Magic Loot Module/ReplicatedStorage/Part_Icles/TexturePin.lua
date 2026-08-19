-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local GuiHost = require(script.Parent.GuiHost);
local u1 = {};
local u2 = nil;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = newproxy();

local function ensureGui() -- Line: 17
    -- upvalues: u2 (ref), GuiHost (copy)
    if u2 and u2.Parent then
        return u2;
    end;

    local v7 = GuiHost.resolveContainer();

    if not v7 then
        return nil;
    end;

    u2 = Instance.new("ScreenGui");
    u2.Name = "PartIclesTexturePin";
    u2.Archivable = false;
    u2.DisplayOrder = -999;
    u2.IgnoreGuiInset = true;
    u2.ResetOnSpawn = false;
    u2.Parent = v7;

    return u2;
end;

local function _resolveAssetId(p8) -- Line: 32
    if typeof(p8) == "string" then
        if p8 == "" or not p8 then
            p8 = nil;
        end;

        return p8;
    end;

    if typeof(p8) ~= "Instance" then
        return nil;
    end;

    if p8:IsA("Decal") or (p8:IsA("Texture") or (p8:IsA("ParticleEmitter") or (p8:IsA("Beam") or p8:IsA("Trail")))) then
        local Texture = p8.Texture;

        if not Texture or (Texture == "" or not Texture) then
            Texture = nil;
        end;

        return Texture;
    end;

    if p8:IsA("ImageLabel") or p8:IsA("ImageButton") then
        local Image = p8.Image;

        if not Image or (Image == "" or not Image) then
            Image = nil;
        end;

        return Image;
    end;

    if p8:IsA("SpecialMesh") then
        local TextureId = p8.TextureId;

        if not TextureId or (TextureId == "" or not TextureId) then
            TextureId = nil;
        end;

        return TextureId;
    end;

    if p8:IsA("MeshPart") then
        local TextureID = p8.TextureID;

        if not TextureID or (TextureID == "" or not TextureID) then
            TextureID = nil;
        end;

        return TextureID;
    end;
end;

local function _appendAssetIds(u9, p10) -- Line: 49
    -- upvalues: _resolveAssetId (copy)
    if u9:IsA("SurfaceAppearance") then
        for _, v in ipairs({ "ColorMap", "NormalMap", "MetalnessMap", "RoughnessMap" }) do
            local success, result = pcall(function() -- Line: 52
                -- upvalues: u9 (copy), v (copy)
                return u9[v];
            end);

            if success and (result and result ~= "") then
                table.insert(p10, result);
            end;
        end;

        return;
    end;

    local v11 = _resolveAssetId(u9);

    if v11 then
        table.insert(p10, v11);
    end;
end;

function u1.pin(p12, p13) -- Line: 62
    -- upvalues: u6 (copy), _resolveAssetId (copy), u3 (ref), u2 (ref), GuiHost (copy), u4 (ref), u5 (ref), ContentProvider (copy)
    if not p12 then
        return;
    end;

    local v14 = p13 or u6;
    local v15 = type(p12) == "table" and p12 and p12 or { p12 };
    local u16 = {};

    for _, v in ipairs(v15) do
        local v17 = _resolveAssetId(v);

        if v17 then
            if not u3[v17] then
                local v18;

                if u2 and u2.Parent then
                    v18 = u2;
                else
                    local v19 = GuiHost.resolveContainer();

                    if v19 then
                        u2 = Instance.new("ScreenGui");
                        u2.Name = "PartIclesTexturePin";
                        u2.Archivable = false;
                        u2.DisplayOrder = -999;
                        u2.IgnoreGuiInset = true;
                        u2.ResetOnSpawn = false;
                        u2.Parent = v19;
                        v18 = u2;
                    else
                        v18 = nil;
                    end;
                end;

                if not v18 then
                    break;
                end;

                local ImageLabel = Instance.new("ImageLabel");
                ImageLabel.Name = "Pin";
                ImageLabel.Image = v17;
                ImageLabel.Size = UDim2.fromOffset(1, 1);
                ImageLabel.Position = UDim2.fromOffset(0, 0);
                ImageLabel.BackgroundTransparency = 1;
                ImageLabel.ImageTransparency = 0.99;
                ImageLabel.BorderSizePixel = 0;
                ImageLabel.ZIndex = 1;
                ImageLabel.Parent = v18;
                u3[v17] = ImageLabel;
                table.insert(u16, ImageLabel);
            end;

            local v20 = u4[v17];

            if not v20 then
                v20 = {};
                u4[v17] = v20;
            end;

            v20[v14] = true;
            local v21 = u5[v14];

            if not v21 then
                v21 = {};
                u5[v14] = v21;
            end;

            v21[v17] = true;
        end;
    end;

    if #u16 > 0 then
        task.spawn(function() -- Line: 88
            -- upvalues: ContentProvider (ref), u16 (copy)
            pcall(ContentProvider.PreloadAsync, ContentProvider, u16);
        end);
    end;
end;

function u1.pinSubtree(p22) -- Line: 92
    -- upvalues: _appendAssetIds (copy), u1 (copy)
    if not p22 then
        return;
    end;

    local v23 = {};
    _appendAssetIds(p22, v23);
    local success, result = pcall(p22.GetDescendants, p22);

    if success then
        for _, v in ipairs(result) do
            _appendAssetIds(v, v23);
        end;
    end;

    if #v23 > 0 then
        u1.pin(v23, p22);
    end;
end;

function u1.isPinned(p24) -- Line: 103
    -- upvalues: u3 (ref)
    return u3[p24] ~= nil;
end;

function u1.count() -- Line: 105
    -- upvalues: u3 (ref)
    local v25 = 0;

    for _ in pairs(u3) do
        v25 = v25 + 1;
    end;

    return v25;
end;

function u1.unpin(p26, p27) -- Line: 110
    -- upvalues: u6 (copy), _resolveAssetId (copy), u3 (ref), u4 (ref), u5 (ref)
    if not p26 then
        return;
    end;

    local v28 = p27 or u6;
    local v29 = type(p26) == "table" and p26 and p26 or { p26 };

    for _, v in ipairs(v29) do
        local v30 = _resolveAssetId(v);

        if v30 and u3[v30] then
            local v31 = u4[v30];

            if v31 then
                v31[v28] = nil;
            end;

            local v32 = u5[v28];

            if v32 then
                v32[v30] = nil;
            end;

            local v33 = false;

            if v31 then
                for _ in pairs(v31) do
                    v33 = true;
                    break;
                end;
            end;

            if not v33 then
                pcall(u3[v30].Destroy, u3[v30]);
                u3[v30] = nil;
                u4[v30] = nil;
            end;
        end;
    end;
end;

function u1.releaseOwner(p34) -- Line: 131
    -- upvalues: u5 (ref), u4 (ref), u3 (ref)
    if not p34 then
        return;
    end;

    local v35 = u5[p34];

    if not v35 then
        return;
    end;

    for i in pairs(v35) do
        local v36 = u4[i];

        if v36 then
            v36[p34] = nil;
        end;

        local v37 = false;

        if v36 then
            for _ in pairs(v36) do
                v37 = true;
                break;
            end;
        end;

        if not v37 and u3[i] then
            pcall(u3[i].Destroy, u3[i]);
            u3[i] = nil;
            u4[i] = nil;
        end;
    end;

    u5[p34] = nil;
end;

function u1.unpinSubtree(p38) -- Line: 147
    -- upvalues: _appendAssetIds (copy), u1 (copy)
    if not p38 then
        return;
    end;

    local v39 = {};
    _appendAssetIds(p38, v39);
    local success, result = pcall(p38.GetDescendants, p38);

    if success then
        for _, v in ipairs(result) do
            _appendAssetIds(v, v39);
        end;
    end;

    if #v39 > 0 then
        u1.unpin(v39, p38);
    end;
end;

function u1.clear() -- Line: 159
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u2 (ref)
    u3 = {};
    u4 = {};
    u5 = {};

    if u2 then
        pcall(u2.Destroy, u2);
        u2 = nil;
    end;
end;

return u1;