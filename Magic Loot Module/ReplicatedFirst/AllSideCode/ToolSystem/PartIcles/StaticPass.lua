-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local v1 = {};
local u2 = {
    Part = { { "Speed", "_staticSpeed", 0 }, { "Brightness", "_staticBrightness", 1 }, { "Transparency", "_staticTransparency", 0 }, { "SizeX", "_staticSizeX", 1 }, { "SizeY", "_staticSizeY", 1 }, { "SizeZ", "_staticSizeZ", 1 }, { "RotSpeedX", "_staticRotSpeedX", 0 }, { "RotSpeedY", "_staticRotSpeedY", 0 }, { "RotSpeedZ", "_staticRotSpeedZ", 0 }, { "PosOffsetX", "_staticPosOffsetX", 0 }, { "PosOffsetY", "_staticPosOffsetY", 0 }, { "PosOffsetZ", "_staticPosOffsetZ", 0 }, { "AccelStrength", "_staticAccelStrength", 0 } },
    Attachment = { { "Speed", "_staticSpeed", 0 }, { "RotSpeedX", "_staticRotSpeedX", 0 }, { "RotSpeedY", "_staticRotSpeedY", 0 }, { "RotSpeedZ", "_staticRotSpeedZ", 0 }, { "PosOffsetX", "_staticPosOffsetX", 0 }, { "PosOffsetY", "_staticPosOffsetY", 0 }, { "PosOffsetZ", "_staticPosOffsetZ", 0 } },
    Model = { { "Speed", "_staticSpeed", 0 }, { "Scale", "_staticScale", 1 }, { "RotSpeedX", "_staticRotSpeedX", 0 }, { "RotSpeedY", "_staticRotSpeedY", 0 }, { "RotSpeedZ", "_staticRotSpeedZ", 0 }, { "PosOffsetX", "_staticPosOffsetX", 0 }, { "PosOffsetY", "_staticPosOffsetY", 0 }, { "PosOffsetZ", "_staticPosOffsetZ", 0 } },
    ImageLabel = { { "ImageTransparency", "_staticImageTransparency", 0 }, { "BackgroundTransparency", "_staticBackgroundTransparency", 0 }, { "ImgSpeed", "_staticImgSpeed", 0 }, { "ImgRotSpeed", "_staticImgRotSpeed", 0 }, { "SizeScaleX", "_staticSizeScaleX", 1 }, { "SizeScaleY", "_staticSizeScaleY", 1 } }
};

function v1.apply(p3) -- Line: 67
    -- upvalues: u2 (copy), Graph (copy)
    if not (p3 and p3.Type) then
        return;
    end;

    local v4 = u2[p3.Type];

    if not v4 then
        return;
    end;

    local Graphs = p3.Graphs;

    if not Graphs then
        return;
    end;

    for _, v in ipairs(v4) do
        local v5 = v[1];
        local v6 = v[2];
        local v7 = v[3];
        local v8 = Graphs[v5];

        if v8 and Graph.IsStatic(v8) then
            p3[v6] = Graph.GetStaticValue(v8, v7);
            Graphs[v5] = nil;
        else
            p3[v6] = nil;
        end;
    end;
end;

function v1.restoreFromFreshData(p9, p10) -- Line: 90
    -- upvalues: u2 (copy)
    if not (p9 and (p10 and p9.Type)) then
        return;
    end;

    local v11 = u2[p9.Type];

    if not v11 then
        return;
    end;

    local Graphs = p9.Graphs;

    if not Graphs then
        return;
    end;

    for _, v in ipairs(v11) do
        local v12 = v[1];

        if Graphs[v12] == nil and p10[v12] then
            Graphs[v12] = p10[v12];
        end;
    end;
end;

return v1;