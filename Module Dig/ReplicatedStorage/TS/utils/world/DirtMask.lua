-- Decompiled with Potassium's decompiler.

local DirtBudget = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtBudget").DirtBudget;
local u1 = {};

for i = 0, 63 do
    u1[string.sub("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/", i + 1, i + 1)] = i;
end;

local v2 = {};

local function emptyCells() -- Line: 22
    local v3 = false;
    local v4 = 0;
    local v5 = {};

    while true do
        if v3 then
            v4 = v4 + 1;
        else
            v3 = true;
        end;

        if v4 >= 64 then
            return v5;
        end;

        v5[v4 + 1] = 0;
    end;
end;

local function itemParts(p6) -- Line: 41
    local v7 = {};

    if p6:IsA("BasePart") then
        table.insert(v7, p6);
    end;

    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("BasePart") and descendant:FindFirstAncestor("DirtCoat") == nil then
            table.insert(v7, descendant);
        end;
    end;

    return v7;
end;

local function referencePart(p8) -- Line: 54
    local Handle = p8:FindFirstChild("Handle");
    local v9;

    if Handle == nil then
        v9 = Handle;
    else
        v9 = Handle:IsA("BasePart");
    end;

    if v9 then
        return Handle;
    end;

    if p8:IsA("Model") and p8.PrimaryPart then
        return p8.PrimaryPart;
    end;

    if p8:IsA("BasePart") then
        return p8;
    end;

    return p8:FindFirstChildWhichIsA("BasePart", true);
end;

local function extentOf(p10, p11) -- Line: 71
    local v12 = p11 / 2;
    local v13 = math.abs(p10.XVector.X) * v12.X + math.abs(p10.YVector.X) * v12.Y + math.abs(p10.ZVector.X) * v12.Z;
    local v14 = math.abs(p10.XVector.Y) * v12.X + math.abs(p10.YVector.Y) * v12.Y + math.abs(p10.ZVector.Y) * v12.Z;
    local v15 = math.abs(p10.XVector.Z) * v12.X + math.abs(p10.YVector.Z) * v12.Y + math.abs(p10.ZVector.Z) * v12.Z;

    return Vector3.new(v13, v14, v15);
end;

local function axisCell(p16, p17) -- Line: 75
    local v18 = math.floor(p16 / p17 * 4);

    return math.clamp(v18, 0, 3);
end;

function v2.frameFor(p19) -- Line: 78
    -- upvalues: referencePart (copy), itemParts (copy), extentOf (copy)
    local v20 = referencePart(p19);

    if not v20 then
        return nil;
    end;

    local CFrame = v20.CFrame;
    local v21 = nil;
    local v22 = nil;

    for _, v in itemParts(p19) do
        local v23 = CFrame:ToObjectSpace(v.CFrame);
        local v24 = extentOf(v23, v.Size);
        local v25 = v23.Position - v24;
        local v26 = v23.Position + v24;

        if v21 then
            v21 = v21:Min(v25);
        else
            v21 = v25;
        end;

        if v22 then
            v22 = v22:Max(v26);
        else
            v22 = v26;
        end;
    end;

    if not (v21 and v22) then
        return nil;
    end;

    local v27 = v22 - v21;
    local v28 = {
        reference = v20,
        min = v21
    };
    local v29 = math.max(v27.X, 0.001);
    local v30 = math.max(v27.Y, 0.001);
    local v31 = math.max(v27.Z, 0.001);
    v28.size = Vector3.new(v29, v30, v31);

    return v28;
end;

local function cellFor(p32, p33) -- Line: 107
    local v34 = p32.reference.CFrame:PointToObjectSpace(p33) - p32.min;
    local v35 = math.floor(v34.X / p32.size.X * 4);
    local v36 = math.clamp(v35, 0, 3) * 4 * 4;
    local v37 = math.floor(v34.Y / p32.size.Y * 4);
    local v38 = v36 + math.clamp(v37, 0, 3) * 4;
    local v39 = math.floor(v34.Z / p32.size.Z * 4);

    return v38 + math.clamp(v39, 0, 3);
end;

v2.cellFor = cellFor;

function v2.cellOf(p40) -- Line: 114
    local v41 = p40:GetAttribute("DirtCell");

    if type(v41) == "number" then
        return v41;
    end;

    return nil;
end;

function v2.blocksOf(p42) -- Line: 119
    local v43 = {};

    for _, child in p42:GetChildren() do
        if child:IsA("BasePart") then
            table.insert(v43, child);
        end;
    end;

    return v43;
end;

function v2.indexBlocks(p44, u45, u46) -- Line: 129
    -- upvalues: emptyCells (copy), DirtBudget (copy), cellFor (copy)
    local u47 = {
        totals = emptyCells(),
        cleaned = emptyCells()
    };
    DirtBudget.scheduleBatch(p44, function(p48) -- Line: 134
        -- upvalues: cellFor (ref), u45 (copy), u47 (copy)
        local v49 = cellFor(u45, p48.Position);
        p48:SetAttribute("DirtCell", v49);
        local totals = u47.totals;
        local v50 = v49 + 1;
        totals[v50] = totals[v50] + 1;
    end);
    DirtBudget.schedule(function() -- Line: 139
        -- upvalues: u46 (copy), u47 (copy)
        return u46(u47);
    end);
end;

function v2.applyFractions(p51, u52, u53, u54) -- Line: 144
    -- upvalues: DirtBudget (copy)
    local u55 = 0;
    DirtBudget.scheduleBatch(p51, function(p56) -- Line: 146
        -- upvalues: u52 (copy), u53 (copy), u55 (ref)
        if p56.Parent == nil then
            return nil;
        end;

        local v57 = p56:GetAttribute("DirtCell");

        if type(v57) ~= "number" then
            v57 = nil;
        end;

        if v57 == nil then
            return nil;
        end;

        if u52.cleaned[v57 + 1] >= math.round(u53[v57 + 1] * u52.totals[v57 + 1]) then
            return nil;
        end;

        local cleaned = u52.cleaned;
        local v58 = v57 + 1;
        cleaned[v58] = cleaned[v58] + 1;
        u55 = u55 + 1;
        p56:Destroy();
    end);
    DirtBudget.schedule(function() -- Line: 161
        -- upvalues: u54 (copy), u55 (ref)
        return u54(u55);
    end);
end;

function v2.sumOf(p59) -- Line: 166
    local v60 = 0;

    for _, v in p59 do
        v60 = v60 + v;
    end;

    return v60;
end;

function v2.encode(p61) -- Line: 174
    local v62 = false;
    local v63 = 0;
    local v64 = "";

    while true do
        if v62 then
            v63 = v63 + 1;
        else
            v62 = true;
        end;

        if v63 >= 64 then
            return string.gsub(v64, "0+$", "");
        end;

        local v65 = p61.totals[v63 + 1];
        local v66;

        if v65 > 0 then
            local v67 = math.clamp(p61.cleaned[v63 + 1] / v65, 0, 1) * 63;
            v66 = math.round(v67);
        else
            v66 = 0;
        end;

        v64 = v64 .. string.sub("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/", v66 + 1, v66 + 1);
    end;
end;

function v2.decode(p68) -- Line: 199
    -- upvalues: emptyCells (copy), u1 (copy)
    local v69 = emptyCells();
    local v70 = false;
    local v71 = 0;

    while true do
        if v70 then
            v71 = v71 + 1;
        else
            v70 = true;
        end;

        if v71 >= math.min(#p68, 64) then
            return v69;
        end;

        local v72 = u1[string.sub(p68, v71 + 1, v71 + 1)];

        if v72 ~= nil then
            v69[v71 + 1] = v72 / 63;
        end;
    end;
end;

function v2.isValid(p73) -- Line: 226
    -- upvalues: u1 (copy)
    if #p73 > 64 then
        return false;
    end;

    for i = 0, #p73 - 1 do
        if u1[string.sub(p73, i + 1, i + 1)] == nil then
            return false;
        end;
    end;

    return true;
end;

return {
    DirtMask = v2
};