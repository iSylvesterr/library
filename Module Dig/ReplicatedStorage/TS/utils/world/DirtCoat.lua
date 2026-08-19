-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;
local DirtBudget = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtBudget").DirtBudget;
local v1 = Color3.fromRGB(160, 156, 92);
local Sand = Enum.Material.Sand;
local u2 = {
    spacing = 0.55,
    spacingRatio = 0.11,
    minSpacing = 0.25,
    maxSpacing = 2.5,
    overlap = 1.6,
    embed = 0.35,
    inflate = 0.6,
    rotationJitter = 0.5235987755982988,
    colorJitter = 0.06,
    containerName = "DirtCoat",
    weld = true,
    castShadow = true,
    canQuery = false,
    hideTarget = true,
    coverUnderside = true,
    sizeRange = {
        min = 0.8,
        max = 1.45
    },
    color = v1,
    material = Sand
};
local v3 = {
    spacingRatio = 0.1,
    minSpacing = 0.22,
    maxSpacing = 1.6,
    weld = false,
    castShadow = false,
    canQuery = true
};
local v4 = table.clone(v3);
setmetatable(v4, nil);
v4.spacingRatio = 0.22;
v4.minSpacing = 0.32;
v4.maxSpacing = 2.4;
local u5 = { Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, 1) };
local v6 = {};
local u7 = {};

local function _(p8, p9) -- Line: 58
    return p8 + math.random() * (p9 - p8);
end;

local function u17(p10, p11) -- Line: 61
    local v12 = (p10.X + p10.Y + p10.Z) / 3;
    local v13 = math.sqrt(2 * (p10.X * p10.Y + p10.Y * p10.Z + p10.Z * p10.X) / 2000);
    local v14 = math.max(p11.minSpacing, v13);
    local v15 = v12 * p11.spacingRatio;
    local v16 = math.max(p11.maxSpacing, v14);

    return math.clamp(v15, v14, v16);
end;

local function _(p18, p19) -- Line: 68
    local v20 = 1 + (math.random() * 2 - 1) * p19;

    return Color3.new(math.clamp(p18.R * v20, 0, 1), math.clamp(p18.G * v20, 0, 1), (math.clamp(p18.B * v20, 0, 1)));
end;

local function u24(p21, p22) -- Line: 72
    if p21:IsA("BasePart") then
        return { p21 };
    end;

    local v23 = {};

    for _, descendant in p21:GetDescendants() do
        if descendant:IsA("BasePart") and descendant:FindFirstAncestor(p22) == nil then
            table.insert(v23, descendant);
        end;
    end;

    return v23;
end;

local function u31(p25, p26) -- Line: 84
    local v27 = p26 / 2;
    local v28 = math.abs(p25.XVector.X) * v27.X + math.abs(p25.YVector.X) * v27.Y + math.abs(p25.ZVector.X) * v27.Z;
    local v29 = math.abs(p25.XVector.Y) * v27.X + math.abs(p25.YVector.Y) * v27.Y + math.abs(p25.ZVector.Y) * v27.Z;
    local v30 = math.abs(p25.XVector.Z) * v27.X + math.abs(p25.YVector.Z) * v27.Y + math.abs(p25.ZVector.Z) * v27.Z;

    return Vector3.new(v28, v29, v30);
end;

local function u44(p32, p33) -- Line: 94
    -- upvalues: u31 (copy)
    if p32:IsA("BasePart") then
        return {
            reference = p32,
            relative = CFrame.new(),
            size = p32.Size
        };
    end;

    local function _(p34) -- Line: 103
        return p34.Name == "Handle";
    end;

    local v35 = nil;

    for i, v in p33 do
        local _ = i - 1;

        if v.Name == "Handle" == true then
            v35 = v;
            break;
        end;
    end;

    if v35 == nil then
        v35 = p33[1];
    end;

    if not v35 then
        return nil;
    end;

    if p32:IsA("Model") then
        local v36, v37 = p32:GetBoundingBox();

        return {
            reference = v35,
            relative = v35.CFrame:ToObjectSpace(v36),
            size = v37
        };
    end;

    local CFrame2 = v35.CFrame;
    local v38 = nil;
    local v39 = nil;

    for _, v in p33 do
        local v40 = CFrame2:ToObjectSpace(v.CFrame);
        local v41 = u31(v40, v.Size);
        local v42 = v40.Position - v41;
        local v43 = v40.Position + v41;

        if v38 then
            v38 = v38:Min(v42);
        else
            v38 = v42;
        end;

        if v39 then
            v39 = v39:Max(v43);
        else
            v39 = v43;
        end;
    end;

    return v38 and v39 and {
        reference = v35,
        relative = CFrame.new((v38 + v39) / 2),
        size = v39 - v38
    } or nil;
end;

local function u61(p45, p46) -- Line: 157
    -- upvalues: u5 (copy)
    local v47 = { p45.size.X / 2, p45.size.Y / 2, p45.size.Z / 2 };
    local v48 = {};

    for i = 0, 2 do
        local v49 = (i + 1) % 3;
        local v50 = (i + 2) % 3;
        local v51 = v47[v49 + 1];
        local v52 = v47[v50 + 1];
        local v53 = v47[i + 1] * 2 + 8;

        for _, v in { 1, -1 } do
            local v54 = p45.relative:VectorToWorldSpace(u5[i + 1] * -v) * v53;
            local v55 = -v51;
            local v56 = false;

            while true do
                if true then
                    if v56 then
                        v55 = v55 + p46;
                    else
                        v56 = true;
                    end;
                end;

                if v55 > v51 + 0.001 then
                    break;
                end;

                local v57 = -v52;
                local v58 = false;

                while true do
                    if true then
                        if v58 then
                            v57 = v57 + p46;
                        else
                            v58 = true;
                        end;
                    end;

                    if v57 > v52 + 0.001 then
                        break;
                    end;

                    local v59 = {
                        0,
                        0,
                        0,
                        [i + 1] = v * (v47[i + 1] + 4),
                        [v49 + 1] = v55,
                        [v50 + 1] = v57
                    };
                    local v60 = {
                        localOrigin = p45.relative:PointToWorldSpace((Vector3.new(v59[1], v59[2], v59[3]))),
                        localDirection = v54
                    };
                    table.insert(v48, v60);
                end;
            end;
        end;
    end;

    return v48;
end;

local function u67(p62, p63, p64, p65) -- Line: 212
    -- upvalues: Workspace (copy)
    local CFrame2 = p63.CFrame;
    local v66 = Workspace:Raycast(CFrame2:PointToWorldSpace(p62.localOrigin), CFrame2:VectorToWorldSpace(p62.localDirection), p64);

    if not (v66 and v66.Instance:IsA("BasePart")) then
        return nil;
    end;

    if not p65 and v66.Normal.Y <= -0.5 then
        return nil;
    end;

    local Instance2 = v66.Instance;

    return {
        localPosition = Instance2.CFrame:PointToObjectSpace(v66.Position),
        localNormal = Instance2.CFrame:VectorToObjectSpace(v66.Normal),
        instance = Instance2
    };
end;

local function u91(p68, p69) -- Line: 228
    local Part = Instance.new("Part");
    Part.Shape = Enum.PartType.Block;
    Part.Material = p69.material;
    Part.CanCollide = false;
    Part.CanQuery = p69.canQuery;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.CastShadow = p69.castShadow;
    local color = p69.color;
    local colorJitter = p69.colorJitter;
    local v70 = 1 + (math.random() * 2 - 1) * colorJitter;
    Part.Color = Color3.new(math.clamp(color.R * v70, 0, 1), math.clamp(color.G * v70, 0, 1), (math.clamp(color.B * v70, 0, 1)));
    local v71 = p68.instance.CFrame:PointToWorldSpace(p68.localPosition);
    local v72 = p68.instance.CFrame:VectorToWorldSpace(p68.localNormal);
    local v73 = v72:Cross(Vector3.new(0, 0, 1));

    if v73.Magnitude < 0.001 then
        v73 = v72:Cross(Vector3.new(1, 0, 0));
    end;

    local Unit = v73.Unit;
    local v74 = 1 / (p69.spacing * 3);
    local v75 = 0.5 + math.noise(v71.X * v74, v71.Y * v74, v71.Z * v74);
    local v76 = math.clamp(v75, 0, 1);
    local v77 = p69.spacing * p69.overlap * (1 + v76 * p69.inflate);
    local min = p69.sizeRange.min;
    local max = p69.sizeRange.max;
    local v78 = v77 * (min + math.random() * (max - min));
    local min2 = p69.sizeRange.min;
    local max2 = p69.sizeRange.max;
    local v79 = v77 * (min2 + math.random() * (max2 - min2));
    local min3 = p69.sizeRange.min;
    local max3 = p69.sizeRange.max;
    local v80 = v77 * (min3 + math.random() * (max3 - min3));
    local v81 = Vector3.new(v78, v79, v80);
    Part.Size = v81;
    local v82 = CFrame.fromMatrix(v71, Unit, v72);
    local v83 = math.random() * 3.141592653589793 * 2;
    local v84 = (math.random() * 2 - 1) * p69.rotationJitter;
    local v85 = (math.random() * 2 - 1) * p69.rotationJitter;
    local v86 = v82 * CFrame.Angles(v84, v83, v85);
    local v87 = p69.spacing * 0.35;
    local v88 = v72:Cross(Unit);
    local v89 = (math.random() * 2 - 1) * v87;
    local v90 = v88 * ((math.random() * 2 - 1) * v87);
    Part.CFrame = v86 + (Unit * v89 + v90) + v72 * (v81.Y * 0.5 * (v76 * p69.inflate - p69.embed));
    Part:SetAttribute("DirtEmbed", p69.embed);

    return Part;
end;

local function u93(p92) -- Line: 270
    for _, v in p92 do
        if v:GetAttribute("DirtCoatOriginalTransparency") == nil then
            v:SetAttribute("DirtCoatOriginalTransparency", v.Transparency);
        end;

        v.Transparency = 1;
    end;
end;

local function snapWelds(p94) -- Line: 278
    -- upvalues: Workspace (copy)
    local v95 = {};
    local v96 = {};

    for _, child in p94:GetChildren() do
        if child:IsA("BasePart") then
            local v97 = child:FindFirstChildOfClass("Weld");
            local v98;

            if v97 == nil then
                v98 = v97;
            else
                v98 = v97.Part0;
            end;

            if v98 then
                table.insert(v95, child);
                table.insert(v96, v97.Part0.CFrame * v97.C0);
            end;
        end;
    end;

    if #v95 > 0 then
        Workspace:BulkMoveTo(v95, v96);
    end;
end;

v6.snapWelds = snapWelds;

function v6.hide(p99, p100) -- Line: 303
    -- upvalues: u2 (copy), u93 (copy), u24 (copy)
    if p100 == nil then
        p100 = u2.containerName;
    end;

    u93((u24(p99, p100)));
end;

local function reveal(p101, p102) -- Line: 310
    -- upvalues: u2 (copy), u24 (copy)
    if p102 == nil then
        p102 = u2.containerName;
    end;

    for _, v in u24(p101, p102) do
        local v103 = v:GetAttribute("DirtCoatOriginalTransparency");

        if type(v103) == "number" then
            v.Transparency = v103;
            v:SetAttribute("DirtCoatOriginalTransparency", nil);
        end;
    end;
end;

v6.reveal = reveal;

function v6.uncoat(p104, p105) -- Line: 323
    -- upvalues: u2 (copy), u7 (copy), reveal (copy)
    if p105 == nil then
        p105 = u2.containerName;
    end;

    local v106 = p104:FindFirstChild(p105);

    if v106 then
        v106:Destroy();
    end;

    local v107 = u7[p104];

    if v107 then
        u7[p104] = nil;
        v107:Destroy();
    end;

    reveal(p104, p105);
end;

local function coat(u108, p109) -- Line: 341
    -- upvalues: u2 (copy), u7 (copy), u24 (copy), u44 (copy), u17 (copy), u93 (copy), u91 (copy), snapWelds (copy), DirtBudget (copy), u61 (copy), u67 (copy)
    local u110 = table.clone(u2);
    setmetatable(u110, nil);

    if p109 then
        for i, v in p109 do
            u110[i] = v;
        end;
    end;

    local v111 = u108:FindFirstChild(u110.containerName);

    if v111 then
        v111:Destroy();
    end;

    local v112 = u7[u108];

    if v112 then
        u7[u108] = nil;
        v112:Destroy();
    end;

    local u113 = u24(u108, u110.containerName);
    local u114 = u44(u108, u113);
    local Model = Instance.new("Model");
    Model.Name = u110.containerName;

    if not u114 then
        Model.Parent = u108;
        local onComplete = u110.onComplete;

        if onComplete ~= nil then
            onComplete();
        end;

        return Model;
    end;

    if p109 ~= nil then
        p109 = p109.spacing;
    end;

    if p109 == nil then
        p109 = u17(u114.size, u110);
    end;

    u110.spacing = p109;
    local weld = u110.weld;

    if weld then
        u7[u108] = Model;
    else
        Model.Parent = u108;
    end;

    local function _() -- Line: 389
        -- upvalues: weld (copy), Model (copy), u108 (copy), u7 (ref)
        if not weld then
            return Model.Parent ~= nil;
        end;

        local v115 = u7[u108] == Model and u108:IsDescendantOf(game);

        return v115;
    end;

    local u116 = RaycastParams.new();
    u116.FilterType = Enum.RaycastFilterType.Include;
    u116.FilterDescendantsInstances = u113;
    u116.IgnoreWater = true;

    if u110.hideTarget and not weld then
        u93(u113);
    end;

    local function u120(p117) -- Line: 407
        -- upvalues: weld (copy), Model (copy), u108 (copy), u7 (ref), u91 (ref), u110 (copy)
        local v118;

        if weld then
            v118 = u7[u108] == Model and u108:IsDescendantOf(game);
        else
            v118 = Model.Parent ~= nil;
        end;

        if not v118 then
            return nil;
        end;

        local v119 = u91(p117, u110);
        v119.Parent = Model;

        if not u110.weld then
            v119.Anchored = true;

            return;
        end;

        local Weld = Instance.new("Weld");
        Weld.Part0 = p117.instance;
        Weld.Part1 = v119;
        Weld.C0 = p117.instance.CFrame:ToObjectSpace(v119.CFrame);
        Weld.Parent = v119;
        v119.Anchored = false;
    end;

    local onComplete = u110.onComplete;
    local u121 = {};

    local function u124() -- Line: 426
        -- upvalues: weld (copy), u108 (copy), u7 (ref), Model (copy), snapWelds (ref), u110 (copy), u93 (ref), u113 (copy), onComplete (copy)
        if weld then
            local v122 = u7[u108] == Model;

            if v122 then
                u7[u108] = nil;
            end;

            if v122 and u108:IsDescendantOf(game) then
                snapWelds(Model);

                if u110.hideTarget then
                    u93(u113);
                end;

                Model.Parent = u108;
            else
                Model:Destroy();
            end;
        end;

        local v123 = onComplete;

        if v123 ~= nil then
            v123();
        end;
    end;

    DirtBudget.scheduleBatch(u61(u114, u110.spacing), function(p125) -- Line: 449
        -- upvalues: weld (copy), Model (copy), u108 (copy), u7 (ref), u67 (ref), u114 (copy), u116 (copy), u110 (copy), u121 (copy)
        local v126;

        if weld then
            v126 = u7[u108] == Model and u108:IsDescendantOf(game);
        else
            v126 = Model.Parent ~= nil;
        end;

        if not v126 then
            return nil;
        end;

        local v127 = u67(p125, u114.reference, u116, u110.coverUnderside);

        if v127 then
            table.insert(u121, v127);
        end;
    end);
    DirtBudget.schedule(function() -- Line: 458
        -- upvalues: weld (copy), Model (copy), u108 (copy), u7 (ref), DirtBudget (ref), u121 (copy), u120 (copy), u124 (copy)
        local v128;

        if weld then
            v128 = u7[u108] == Model and u108:IsDescendantOf(game);
        else
            v128 = Model.Parent ~= nil;
        end;

        if v128 then
            DirtBudget.scheduleBatch(u121, u120);
        end;

        DirtBudget.schedule(u124);
    end);

    return Model;
end;

v6.coat = coat;

function v6.coatDetached(u129, u130) -- Line: 467
    -- upvalues: u2 (copy), u24 (copy), u7 (copy), u93 (copy), DirtBudget (copy), Workspace (copy), coat (copy)
    local v131;

    if u130 == nil then
        v131 = u130;
    else
        v131 = u130.containerName;
    end;

    if v131 == nil then
        v131 = u2.containerName;
    end;

    local u132;

    if u130 == nil then
        u132 = u130;
    else
        u132 = u130.onComplete;
    end;

    local u133 = u24(u129, v131);

    local function _(p134) -- Line: 484
        return p134.Name == "Handle";
    end;

    local u135 = nil;

    for i, v in u133 do
        local _ = i - 1;

        if v.Name == "Handle" == true then
            u135 = v;
            break;
        end;
    end;

    if u135 == nil then
        u135 = u133[1];
    end;

    if not u135 then
        if u132 ~= nil then
            u132();
        end;

        return nil;
    end;

    local v136 = u129:FindFirstChild(v131);

    if v136 then
        v136:Destroy();
    end;

    local v137 = u7[u129];

    if v137 then
        u7[u129] = nil;
        v137:Destroy();
    end;

    local Model = Instance.new("Model");
    Model.Name = "DirtProxy";
    u7[u129] = Model;

    local function _() -- Line: 522
        -- upvalues: u129 (copy), u7 (ref), Model (copy)
        return u7[u129] == Model;
    end;

    local function _() -- Line: 526
        -- upvalues: u129 (copy), u7 (ref), Model (copy)
        local v138 = u7[u129] == Model and u129:IsDescendantOf(game);

        return v138;
    end;

    local function _() -- Line: 529
        -- upvalues: u129 (copy), u7 (ref), Model (copy), u132 (copy)
        if u7[u129] == Model then
            u7[u129] = nil;
        end;

        Model:Destroy();
        local v139 = u132;

        if v139 ~= nil then
            v139();
        end;
    end;

    local CFrame2 = u135.CFrame;
    local u140 = CFrame.new(Vector3.new(0, -10000, 0));
    local u141 = nil;
    local u142 = nil;

    local function u148() -- Line: 544
        -- upvalues: u142 (ref), u129 (copy), u7 (ref), Model (copy), u132 (copy), u93 (ref), u133 (copy), DirtBudget (ref), u140 (copy), u135 (copy)
        if u142 then
            local v143 = u7[u129] == Model and u129:IsDescendantOf(game);

            if v143 then
                u7[u129] = nil;
                u142.Parent = u129;
                Model:Destroy();
                u93(u133);
                DirtBudget.scheduleBatch(u142:GetChildren(), function(p144) -- Line: 554
                    -- upvalues: u140 (ref), u135 (ref)
                    if not p144:IsA("BasePart") or p144.Parent == nil then
                        return nil;
                    end;

                    local v145 = u140:ToObjectSpace(p144.CFrame);
                    p144.CFrame = u135.CFrame * v145;
                    p144.Anchored = false;
                    local Weld = Instance.new("Weld");
                    Weld.Part0 = u135;
                    Weld.Part1 = p144;
                    Weld.C0 = v145;
                    Weld.Parent = p144;
                end);
                DirtBudget.schedule(function() -- Line: 567
                    -- upvalues: u132 (ref)
                    local v146 = u132;

                    if v146 ~= nil then
                        v146 = v146();
                    end;

                    return v146;
                end);

                return;
            end;
        end;

        if u7[u129] == Model then
            u7[u129] = nil;
        end;

        Model:Destroy();
        local v147 = u132;

        if v147 ~= nil then
            v147();
        end;

        return nil;
    end;

    DirtBudget.scheduleBatch(u133, function(p149) -- Line: 575
        -- upvalues: u129 (copy), u7 (ref), Model (copy), CFrame2 (copy), u140 (copy), u135 (copy), u141 (ref)
        local v150 = u7[u129] == Model and u129:IsDescendantOf(game);

        if not v150 then
            return nil;
        end;

        local v151 = p149:Clone();

        for _, child in v151:GetChildren() do
            child:Destroy();
        end;

        v151.Anchored = true;
        v151.CanCollide = false;
        v151.CanTouch = false;
        v151.CanQuery = true;
        v151.CastShadow = false;
        v151.Transparency = 1;
        v151.CFrame = u140 * CFrame2:ToObjectSpace(p149.CFrame);
        v151.Parent = Model;

        if p149 == u135 then
            u141 = v151;
        end;
    end);
    DirtBudget.schedule(function() -- Line: 596
        -- upvalues: u141 (ref), u129 (copy), u7 (ref), Model (copy), u132 (copy), Workspace (ref), u130 (copy), u148 (copy), u142 (ref), coat (ref)
        if u141 then
            local v152 = u7[u129] == Model and u129:IsDescendantOf(game);

            if v152 then
                Model.PrimaryPart = u141;
                Model.Parent = Workspace;
                local v153 = {};

                if u130 then
                    for i, v in u130 do
                        v153[i] = v;
                    end;
                end;

                v153.weld = false;
                v153.hideTarget = false;
                v153.onComplete = u148;
                u142 = coat(Model, v153);

                return;
            end;
        end;

        if u7[u129] == Model then
            u7[u129] = nil;
        end;

        Model:Destroy();
        local v154 = u132;

        if v154 ~= nil then
            v154();
        end;

        return nil;
    end);
end;

return {
    SAND_COLOR = v1,
    SAND_MATERIAL = Sand,
    FINE_DIRT = v3,
    TOOL_DIRT = v4,
    DirtCoat = v6
};