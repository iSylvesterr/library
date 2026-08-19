-- Decompiled with Potassium's decompiler.

local u18 = {
    ofModel = function(p1) -- Line: 7, Name: ofModel
        local v2, v3 = p1:GetBoundingBox();
        local v4 = math.abs(v2.RightVector.X) * v3.X / 2 + math.abs(v2.UpVector.X) * v3.Y / 2 + math.abs(v2.LookVector.X) * v3.Z / 2;
        local v5 = math.abs(v2.RightVector.Z) * v3.X / 2 + math.abs(v2.UpVector.Z) * v3.Y / 2 + math.abs(v2.LookVector.Z) * v3.Z / 2;

        return {
            v2.X - v4,
            v2.X + v4,
            v2.Z - v5,
            v2.Z + v5
        };
    end,

    ofTemplateAt = function(p6, p7) -- Line: 17, Name: ofTemplateAt
        local v8, v9 = p6:GetBoundingBox();
        local v10 = p7 * p6:GetPivot():ToObjectSpace(v8);
        local v11 = math.abs(v10.RightVector.X) * v9.X / 2 + math.abs(v10.UpVector.X) * v9.Y / 2 + math.abs(v10.LookVector.X) * v9.Z / 2;
        local v12 = math.abs(v10.RightVector.Z) * v9.X / 2 + math.abs(v10.UpVector.Z) * v9.Y / 2 + math.abs(v10.LookVector.Z) * v9.Z / 2;

        return {
            v10.X - v11,
            v10.X + v11,
            v10.Z - v12,
            v10.Z + v12
        };
    end,

    ofPoint = function(p13, p14) -- Line: 29, Name: ofPoint
        return {
            p13.X - p14,
            p13.X + p14,
            p13.Z - p14,
            p13.Z + p14
        };
    end,

    overlaps = function(p15, p16) -- Line: 33, Name: overlaps
        local v17;

        if p15[1] <= p16[2] and (p16[1] <= p15[2] and p15[3] <= p16[4]) then
            v17 = p16[3] <= p15[4];
        else
            v17 = false;
        end;

        return v17;
    end
};
local u19 = { "PlotTree_", "PlotDecor_", "PlotEgg_" };
u18.GROUND_SLICE = 6;

function u18.groundSliceBox(p20, p21, p22) -- Line: 42
    -- upvalues: u18 (copy)
    local v23 = p21 + (p22 or u18.GROUND_SLICE);
    local v24 = (1 / 0);
    local v25 = (-1 / 0);
    local v26 = (1 / 0);
    local v27 = (-1 / 0);
    local v28 = false;

    for _, descendant in p20:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local CFrame = descendant.CFrame;
            local Size = descendant.Size;
            local v29 = 0.5 * (math.abs(CFrame.RightVector.Y) * Size.X + math.abs(CFrame.UpVector.Y) * Size.Y + math.abs(CFrame.LookVector.Y) * Size.Z);

            if CFrame.Position.Y - v29 <= v23 then
                local v30 = 0.5 * (math.abs(CFrame.RightVector.X) * Size.X + math.abs(CFrame.UpVector.X) * Size.Y + math.abs(CFrame.LookVector.X) * Size.Z);
                local v31 = 0.5 * (math.abs(CFrame.RightVector.Z) * Size.X + math.abs(CFrame.UpVector.Z) * Size.Y + math.abs(CFrame.LookVector.Z) * Size.Z);
                v24 = math.min(v24, CFrame.Position.X - v30);
                v25 = math.max(v25, CFrame.Position.X + v30);
                v26 = math.min(v26, CFrame.Position.Z - v31);
                v27 = math.max(v27, CFrame.Position.Z + v31);
                v28 = true;
            end;
        end;
    end;

    return v28 and {
        v24,
        v25,
        v26,
        v27
    } or nil;
end;

function u18.collectObstacles(p32, p33, p34) -- Line: 63
    -- upvalues: u19 (copy), u18 (copy)
    local v35 = {};

    if not p32 then
        return v35;
    end;

    for _, child in p32:GetChildren() do
        if child:IsA("Model") then
            for _, v in p34 or u19 do
                if child.Name:sub(1, #v) == v then
                    local v36 = p33 and u18.groundSliceBox(child, p33) or u18.ofModel(child);

                    if v36 then
                        table.insert(v35, v36);
                    end;

                    break;
                end;
            end;
        end;
    end;

    return v35;
end;

u18.TREE_PREFIXES = { "PlotTree_" };

function u18.isClear(p37, p38) -- Line: 85
    -- upvalues: u18 (copy)
    for _, v in p38 do
        if u18.overlaps(p37, v) then
            return false;
        end;
    end;

    return true;
end;

return u18;