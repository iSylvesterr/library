-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local Range = require(script.Parent.Range);
local v11 = {
    GetSortedTextures = function(p1) -- Line: 9, Name: GetSortedTextures
        -- upvalues: ContentProvider (copy)
        local v2 = {};

        for _, child in pairs(p1:GetChildren()) do
            if child:IsA("Decal") or child:IsA("Texture") then
                table.insert(v2, child);
            end;
        end;

        if #v2 == 0 then
            return {};
        end;

        table.sort(v2, function(p3, p4) -- Line: 18
            return (tonumber(p3.Name) or 0) < (tonumber(p4.Name) or 0);
        end);
        local u5 = {};

        for _, v in ipairs(v2) do
            table.insert(u5, v.Texture);
        end;

        if #u5 > 0 then
            task.spawn(function() -- Line: 29
                -- upvalues: ContentProvider (ref), u5 (copy)
                ContentProvider:PreloadAsync(u5);
            end);
        end;

        return u5;
    end,

    GetSortedBeamTextures = function(p6) -- Line: 38, Name: GetSortedBeamTextures
        -- upvalues: ContentProvider (copy)
        local v7 = {};

        for _, child in pairs(p6:GetChildren()) do
            if child:IsA("Decal") then
                table.insert(v7, child);
            end;
        end;

        if #v7 == 0 then
            return {};
        end;

        table.sort(v7, function(p8, p9) -- Line: 47
            return (tonumber(p8.Name) or 0) < (tonumber(p9.Name) or 0);
        end);
        local u10 = {};

        for _, v in ipairs(v7) do
            table.insert(u10, v.Texture);
        end;

        if #u10 > 0 then
            task.spawn(function() -- Line: 57
                -- upvalues: ContentProvider (ref), u10 (copy)
                ContentProvider:PreloadAsync(u10);
            end);
        end;

        return u10;
    end
};
local u12 = false;

local function _writeFrame(u13, u14, u15) -- Line: 67
    -- upvalues: u12 (ref)
    local success, result = pcall(function() -- Line: 68
        -- upvalues: u13 (copy), u14 (copy), u15 (copy)
        u13[u14] = u15;
    end);

    if not success and (u14 == "ColorMap" and not u12) then
        u12 = true;
        warn(("[Part-Icles] SurfaceAppearance flipbook ColorMap write failed (%s). ColorMap is PluginSecurity  -  SurfaceAppearance flipbooks only animate in plugin context. For runtime games, use Decal / Texture flipbooks instead."):format((tostring(result))));
    end;
end;

local function _texProp(p16) -- Line: 79
    return p16 and p16:IsA("SurfaceAppearance") and "ColorMap" or (p16 and p16:IsA("MeshPart") and "TextureID" or "Texture");
end;

local function _loop(u17, p18, u19, u20, u21) -- Line: 88
    -- upvalues: Range (copy), _writeFrame (copy)
    if #u19 == 0 then
        return;
    end;

    local v22 = Range.RandomValueFromRange(p18.FlipbookFramerate);
    local u23 = 1 / ((not v22 or v22 < 0.1) and 0.1 or v22);
    local u24 = #u19;
    local FlipbookReverse = p18.FlipbookReverse;
    local u25 = p18.FlipbookStartRandom and (math.random(0, u24 - 1) or 0) or 0;
    local u26 = os.clock();
    local u27 = u20 and u20:IsA("SurfaceAppearance") and "ColorMap" or (u20 and u20:IsA("MeshPart") and "TextureID" or "Texture");
    task.spawn(function() -- Line: 101
        -- upvalues: u26 (copy), u21 (copy), u20 (copy), u17 (copy), u23 (copy), u25 (copy), u24 (copy), FlipbookReverse (copy), _writeFrame (ref), u27 (copy), u19 (copy)
        local v28 = -1;

        while os.clock() - u26 < u21 * 4 do
            if not (u20 and u20.Parent) then
                return;
            end;

            if u17 and not (u17.VisualPart and u17.VisualPart.Parent) then
                return;
            end;

            local v29 = u17 and u17._effectiveElapsed or os.clock() - u26;
            local v30 = (math.floor(v29 / u23) + u25) % u24 + 1;

            if FlipbookReverse then
                v30 = u24 - v30 + 1;
            end;

            if v30 == v28 then
                v30 = v28;
            else
                _writeFrame(u20, u27, u19[v30]);
            end;

            task.wait();
            v28 = v30;
        end;
    end);
end;

local function _oneShot(u31, p32, u33, u34, u35) -- Line: 120
    -- upvalues: _writeFrame (copy)
    if #u33 == 0 then
        return;
    end;

    local u36 = #u33;
    local FlipbookReverse = p32.FlipbookReverse;
    local u37 = p32.FlipbookStartRandom and (math.random(0, u36 - 1) or 0) or 0;
    local u38 = os.clock();
    local u39 = u34 and u34:IsA("SurfaceAppearance") and "ColorMap" or (u34 and u34:IsA("MeshPart") and "TextureID" or "Texture");
    task.spawn(function() -- Line: 129
        -- upvalues: u38 (copy), u35 (copy), u34 (copy), u31 (copy), u36 (copy), u37 (copy), FlipbookReverse (copy), _writeFrame (ref), u39 (copy), u33 (copy)
        local v40 = -1;

        while os.clock() - u38 < u35 * 4 do
            if not (u34 and u34.Parent) then
                return;
            end;

            if u31 and not (u31.VisualPart and u31.VisualPart.Parent) then
                break;
            end;

            local v41 = u31 and u31._effectiveElapsed or os.clock() - u38;
            local v42 = math.floor(v41 / u35 * u36) + 1;
            local v43 = (math.min(v42, u36) - 1 + u37) % u36 + 1;

            if FlipbookReverse then
                v43 = u36 - v43 + 1;
            end;

            if v43 == v40 then
                v43 = v40;
            else
                _writeFrame(u34, u39, u33[v43]);
            end;

            task.wait();
            v40 = v43;
        end;

        if u34 and u34.Parent then
            local v44 = (u36 - 1 + u37) % u36 + 1;

            if FlipbookReverse then
                v44 = u36 - v44 + 1;
            end;

            _writeFrame(u34, u39, u33[v44]);
        end;
    end);
end;

function v11.Flip(p45, p46, p47, p48, p49) -- Line: 155
    -- upvalues: _loop (copy), _oneShot (copy)
    if not (p46 and p46.FlipbookMode) then
        return;
    end;

    if p46.FlipbookMode == Enum.ParticleFlipbookMode.Loop then
        _loop(p45, p46, p47, p48, p49);

        return;
    end;

    if p46.FlipbookMode == Enum.ParticleFlipbookMode.OneShot then
        _oneShot(p45, p46, p47, p48, p49);
    end;
end;

function v11.FlipBeam(p50, p51, p52, p53, p54) -- Line: 165
    -- upvalues: _loop (copy), _oneShot (copy)
    if not (p51 and (p52 and p51.FlipbookMode)) then
        return;
    end;

    local FlipbookMode = p51.FlipbookMode;

    if FlipbookMode == Enum.ParticleFlipbookMode.Loop then
        _loop(p50, p51, p52, p53, p54);

        return;
    end;

    if FlipbookMode == Enum.ParticleFlipbookMode.OneShot then
        _oneShot(p50, p51, p52, p53, p54);
    end;
end;

return v11;