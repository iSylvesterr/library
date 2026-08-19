-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local ScreenHost = require(script.Parent.ScreenHost);
local Pool = require(script.Parent.Pool);
local StaticPass = require(script.Parent.StaticPass);

return function(u1) -- Line: 12
    -- upvalues: ScreenHost (copy), ContentProvider (copy), Graph (copy), Range (copy), StaticPass (copy), Pool (copy)
    local u2 = {};

    local function resolveImageParent(p3, p4) -- Line: 18
        -- upvalues: ScreenHost (ref)
        if p3.EmitParent then
            return p3.EmitParent;
        end;

        if p4 then
            local Parent = p4.Parent;

            while Parent and Parent ~= game do
                if Parent:GetAttribute("_PartIcleEmit") then
                    return p4.Parent;
                end;

                Parent = Parent.Parent;
            end;
        end;

        return ScreenHost.get();
    end;

    local function gatherFlipbookDecals(p5) -- Line: 31
        if not p5 then
            return nil;
        end;

        local v6 = {};

        for _, child in ipairs(p5:GetChildren()) do
            if child:IsA("Decal") then
                table.insert(v6, child);
            end;
        end;

        table.sort(v6, function(p7, p8) -- Line: 37
            local v9 = tonumber(p7.Name);
            local v10 = tonumber(p8.Name);

            if v9 and v10 then
                return v9 < v10;
            end;

            return p7.Name < p8.Name;
        end);

        return #v6 > 0 and v6 and v6 or nil;
    end;

    local function preloadEmitAssets(p11, p12) -- Line: 46
        -- upvalues: ContentProvider (ref)
        local u13 = {};

        if p12 then
            for _, v in ipairs(p12) do
                table.insert(u13, v);
            end;
        end;

        if p11.Image and p11.Image ~= "" then
            table.insert(u13, p11.Image);
        end;

        if #u13 == 0 then
            return;
        end;

        task.spawn(function() -- Line: 51
            -- upvalues: ContentProvider (ref), u13 (copy)
            pcall(ContentProvider.PreloadAsync, ContentProvider, u13);
        end);
    end;

    local function preloadAndWait(p14, p15, p16, p17) -- Line: 56
        -- upvalues: ContentProvider (ref)
        if not (p14 and p15) then
            return;
        end;

        local _preloadedAssets = p14._preloadedAssets;

        if not _preloadedAssets then
            return;
        end;

        if _preloadedAssets[p15] then
            return;
        end;

        local v18 = {};

        if p17 then
            for _, v in ipairs(p17) do
                table.insert(v18, v);
            end;
        end;

        if p16.Image and p16.Image ~= "" then
            table.insert(v18, p16.Image);
        end;

        _preloadedAssets[p15] = true;

        if #v18 == 0 then
            return;
        end;

        pcall(ContentProvider.PreloadAsync, ContentProvider, v18);
    end;

    local function resolveFrame(p19, p20, p21) -- Line: 71
        if p20 <= 0 then
            return 0;
        end;

        local FlipbookMode = p19.FlipbookMode;
        local v22;

        if FlipbookMode == Enum.ParticleFlipbookMode.OneShot then
            local v23 = p19.LifeTime > 0 and (math.min(1, p21 / p19.LifeTime) or 1) or 1;
            local v24 = math.floor(v23 * p20);
            v22 = math.min(v24, p20 - 1);
        elseif FlipbookMode == Enum.ParticleFlipbookMode.PingPong then
            local v25 = (p19.LifeTime > 0 and (math.min(1, p21 / p19.LifeTime) or 1) or 1) * 2;
            local v26;

            if v25 <= 1 then
                v26 = math.floor(v25 * p20);
            else
                v26 = math.floor((2 - v25) * p20);
            end;

            local v27 = math.min(v26, p20 - 1);
            v22 = math.max(0, v27);
        elseif FlipbookMode == Enum.ParticleFlipbookMode.Random then
            local v28 = p19.FlipbookFramerate or 24;
            local v29 = math.floor(p21 / (v28 > 0 and 1 / v28 or 1));

            if p19._lastRandomInterval ~= v29 then
                p19._lastRandomInterval = v29;
                p19._currentRandomFrame = math.random(0, p20 - 1);
            end;

            v22 = p19._currentRandomFrame or math.random(0, p20 - 1);
        else
            v22 = math.floor(p21 * p19.FlipbookFramerate + (p19.FlipbookStartOffset or 0) * p20) % p20;
        end;

        if p19.FlipbookReverse then
            v22 = p20 - 1 - v22;
        end;

        return v22;
    end;

    local function applyFlipbookFrame(p30, p31) -- Line: 102
        -- upvalues: resolveFrame (copy)
        if not p30.FlipbookFramerate or p30.FlipbookFramerate <= 0 then
            return;
        end;

        if p30.FlipbookSource == "Decals" and p30.FlipbookDecals then
            local v32 = #p30.FlipbookDecals;

            if v32 == 0 then
                return;
            end;

            local v33 = resolveFrame(p30, v32, p31);

            if v33 == p30._lastFlipbookFrame then
                return;
            end;

            p30._lastFlipbookFrame = v33;
            local v34 = p30.FlipbookDecals[v33 + 1];

            if v34 and v34.Texture then
                p30.VisualPart.Image = v34.Texture;
            end;
        elseif p30.FlipbookSource == "Spritesheet" then
            local v35 = math.max(1, p30.GridCols or 1);
            local v36 = math.max(1, p30.GridRows or 1);
            local v37 = resolveFrame(p30, v35 * v36, p31);
            local SheetSize = p30.SheetSize;

            if not SheetSize then
                return;
            end;

            if v37 == p30._lastFlipbookFrame then
                return;
            end;

            p30._lastFlipbookFrame = v37;
            local v38 = SheetSize.X / v35;
            local v39 = SheetSize.Y / v36;
            p30.VisualPart.ImageRectSize = Vector2.new(v38, v39);
            p30.VisualPart.ImageRectOffset = Vector2.new(v37 % v35 * v38, math.floor(v37 / v35) * v39);
        end;
    end;

    local function _simulateForward2D(p40, p41, p42, p43, p44) -- Line: 133
        -- upvalues: Graph (ref)
        local v45 = p43 / 60;
        local X = (p40.ImgAcceleration or Vector2.new()).X;
        local Y = (p40.ImgAcceleration or Vector2.new()).Y;
        local v46 = p40.ImgDrag or 0;
        local v47 = 0;
        local v48 = 0;
        local v49 = 0;
        local v50 = 0;

        for i = 1, 60 do
            local v51 = not p40.ImgSpeed and 0 or Graph.QueryPointsWithTime(i / 60, p40.ImgSpeed, p44.ImgSpeed) * 100;
            v48 = v48 + X * 100 * v45;
            v47 = v47 + Y * 100 * v45;

            if v46 > 0 then
                local v52 = math.max(0, 1 - v46 * v45);
                v48 = v48 * v52;
                v47 = v47 * v52;
            end;

            v49 = v49 + (v51 * p41 + v48) * v45;
            v50 = v50 + (v51 * p42 + v47) * v45;
        end;

        return v49, v50, v48, v47;
    end;

    function u1._computeImageLabelEndState(p53, p54, p55, p56, p57, p58) -- Line: 160
        -- upvalues: _simulateForward2D (copy)
        return _simulateForward2D(p54, p55, p56, p57, p58);
    end;

    local function buildImageLabelPData(p59, p60, p61, p62) -- Line: 165
        -- upvalues: gatherFlipbookDecals (copy), Range (ref), Graph (ref), u2 (copy), _simulateForward2D (copy), StaticPass (ref)
        local v63 = gatherFlipbookDecals(p59.ImageFlipbooks);
        local v64 = p59.ImgSpreadAngle or 0;
        local v65 = (p59.ImgEmissionAngle or 90) + (math.random() * 2 - 1) * v64;
        local v66 = math.rad(v65);
        local v67 = math.cos(v66);
        local v68 = -math.sin(v66);
        local v69 = Range.RandomValueFromRange(p59.Lifetime);
        local v70 = v69 <= 0 and 0.001 or v69;
        local v71 = {
            ImageTransparency = p59.ImageTransparency and (Graph.GenerateSeed(p59.ImageTransparency) or {}) or {},
            BackgroundTransparency = p59.BackgroundTransparency and (Graph.GenerateSeed(p59.BackgroundTransparency) or {}) or {},
            ImgSpeed = p59.ImgSpeed and (Graph.GenerateSeed(p59.ImgSpeed) or {}) or {},
            ImgRotSpeed = p59.ImgRotSpeed and (Graph.GenerateSeed(p59.ImgRotSpeed) or {}) or {},
            SizeScaleX = p59.SizeScaleX and (Graph.GenerateSeed(p59.SizeScaleX) or {}) or {},
            SizeScaleY = p59.SizeScaleY and (Graph.GenerateSeed(p59.SizeScaleY) or {}) or {},
            Timescale = p59.ImgTimescale and (Graph.GenerateSeed(p59.ImgTimescale) or {}) or {}
        };
        local v72 = Range.RandomValueFromRange(p59.ImgRotRange or NumberRange.new(0));
        local v73 = p59.ImgSizeUDim or UDim2.fromOffset(100, 100);

        if p59.ImageTransparency then
            p60.ImageTransparency = Graph.QueryPointsWithTime(0, p59.ImageTransparency, v71.ImageTransparency);
        end;

        if p59.BackgroundTransparency then
            p60.BackgroundTransparency = Graph.QueryPointsWithTime(0, p59.BackgroundTransparency, v71.BackgroundTransparency);
        end;

        if p59.ImageColor3 then
            p60.ImageColor3 = Graph.QueryColorPointWithTime(0, p59.ImageColor3);
        end;

        if p59.BackgroundColor3 then
            p60.BackgroundColor3 = Graph.QueryColorPointWithTime(0, p59.BackgroundColor3);
        end;

        p60.Image = p59.Image or "";
        p60.ScaleType = p59.ImgScaleType or Enum.ScaleType.Stretch;
        p60.ResampleMode = p59.ImgResampleMode or Enum.ResamplerMode.Default;
        p60.AnchorPoint = p59.ImgAnchorPoint or Vector2.new(0.5, 0.5);
        p60.ZIndex = p59.ImgZIndex or 1;
        p60.Rotation = v72;
        local v74 = p59.SizeScaleX and (Graph.QueryPointsWithTime(0, p59.SizeScaleX, v71.SizeScaleX) or 1) or 1;
        local v75 = p59.SizeScaleY and (Graph.QueryPointsWithTime(0, p59.SizeScaleY, v71.SizeScaleY) or 1) or 1;
        p60.Size = UDim2.new(v73.X.Scale * v74, v73.X.Offset * v74, v73.Y.Scale * v75, v73.Y.Offset * v75);
        p60.Position = p59.ImgPosition or UDim2.fromScale(0.5, 0.5);
        local v76 = not p59.ImgFlipbookFramerate and 10 or Range.RandomValueFromRange(p59.ImgFlipbookFramerate);
        local v77 = p59.ImgFlipbookStartRandom and (p59.ImgFlipbookMode or Enum.ParticleFlipbookMode.Loop) == Enum.ParticleFlipbookMode.Loop;
        local v78 = 0;
        local v79 = 0;
        local SheetSize = p59.SheetSize;
        local v80 = p59.ImgFlipbookSource or "Decals";

        if v80 == "Spritesheet" and (not SheetSize and (p59.Image and (p59.Image ~= "" and not u2[p59.Image]))) then
            u2[p59.Image] = true;
            warn(string.format("Part-Icles: Spritesheet flipbook  -  sheet dimensions unknown for %s. Emit will render full sheet until dimensions resolve.", p59.Image));
        end;

        if v80 == "Decals" then
            p60.ImageRectSize = Vector2.new(0, 0);
            p60.ImageRectOffset = Vector2.new(0, 0);

            if v63 and #v63 > 0 then
                local v81 = #v63;

                if v77 then
                    v78 = math.random(0, v81 - 1);
                    v79 = v78 / v81;
                end;

                local v82 = v63[v78 + 1];

                if v82 and (v82.Texture and v82.Texture ~= "") then
                    p60.Image = v82.Texture;
                end;
            end;
        elseif v80 == "Spritesheet" and SheetSize then
            local v83 = math.max(1, p59.ImgGridCols or 1);
            local v84 = math.max(1, p59.ImgGridRows or 1);
            local v85 = v83 * v84;

            if v77 and v85 > 0 then
                v78 = math.random(0, v85 - 1);
                v79 = v78 / v85;
            end;

            local v86 = SheetSize.X / v83;
            local v87 = SheetSize.Y / v84;
            p60.ImageRectSize = Vector2.new(v86, v87);
            p60.ImageRectOffset = Vector2.new(v78 % v83 * v86, math.floor(v78 / v83) * v87);
        end;

        local v88 = {
            Type = "ImageLabel",
            VisualPart = p60,
            StartTime = os.clock(),
            LifeTime = v70,
            TotalKeyFrames = math.max(1, p59.TotalKeyFrames or 100),
            CurrentStep = 0,
            PartLife = p59.PartLife or 0,
            BasePosition = p59.ImgPosition or UDim2.fromScale(0.5, 0.5),
            BaseSize = v73,
            DirX = v67,
            DirY = v68,
            EnvVelX = 0,
            EnvVelY = 0,
            PosX = 0,
            PosY = 0,
            AccelX = (p59.ImgAcceleration or Vector2.new()).X,
            AccelY = (p59.ImgAcceleration or Vector2.new()).Y,
            Drag = p59.ImgDrag or 0,
            InitialRotation = v72,
            RotMode = p59.ImgRotMode or "OverLife",
            AccRot = 0,
            InvertMotion = p59.ImgInvertMotion or false,
            Graphs = {
                ImageTransparency = p59.ImageTransparency,
                BackgroundTransparency = p59.BackgroundTransparency,
                ImgSpeed = p59.ImgSpeed,
                ImgRotSpeed = p59.ImgRotSpeed,
                SizeScaleX = p59.SizeScaleX,
                SizeScaleY = p59.SizeScaleY,
                ImageColor3 = p59.ImageColor3,
                BackgroundColor3 = p59.BackgroundColor3,
                Timescale = p59.ImgTimescale
            },
            Seeds = v71,
            _effectiveElapsed = Graph.InitialEffectiveElapsed(p59.ImgTimescale, v71.Timescale, v70),
            FlipbookSource = p59.ImgFlipbookSource or "Decals",
            FlipbookMode = p59.ImgFlipbookMode or Enum.ParticleFlipbookMode.Loop,
            FlipbookFramerate = v76,
            FlipbookStartOffset = v79,
            FlipbookReverse = p59.ImgFlipbookReverse or false,
            FlipbookDecals = v63,
            SheetSize = SheetSize,
            GridCols = p59.ImgGridCols or 8,
            GridRows = p59.ImgGridRows or 1,
            IsAnimate = p62 or nil,
            AnimateItem = p62 and p61 and p61 or nil
        };

        if p59.ImgInvertMotion then
            local v89, v90, v91, v92 = _simulateForward2D(p59, v67, v68, v70, v71);
            v88.PosX = v89;
            v88.PosY = v90;
            v88.EnvVelX = v91;
            v88.EnvVelY = v92;
            v88._effectiveElapsed = v70;
            v88._invertDtSign = -1;
        end;

        StaticPass.apply(v88);

        if v88._staticSizeScaleX and v88._staticSizeScaleY then
            v88._staticSizeScaleX = nil;
            v88._staticSizeScaleY = nil;
        end;

        return v88;
    end;

    function u1.EmitImageLabel(p93, p94, p95, p96) -- Line: 342
        -- upvalues: preloadAndWait (copy), Pool (ref), buildImageLabelPData (copy), u1 (copy), preloadEmitAssets (copy), resolveImageParent (copy)
        local v97 = p93:GetData(p94);

        if not (v97 and v97.RenderTemplate) then
            return;
        end;

        preloadAndWait(p93, v97.RenderTemplate, v97, nil);
        local v98 = Pool.acquireOrClone(v97.RenderTemplate, "ImageLabel", v97.Pool);
        v98.Archivable = false;
        v98.Visible = true;
        local ImageFlipbooks = v98:FindFirstChild("ImageFlipbooks");

        if ImageFlipbooks then
            ImageFlipbooks:Destroy();
        end;

        local v99 = buildImageLabelPData(v97, v98, p94, false);
        v99.Link = p95;
        v99._sourceItem = p94;
        u1._seedTsOverride(v99, p94);
        v99.Events = v97.Events;

        if v97.Pool ~= false then
            v99._sourceRT = v97.RenderTemplate;
            v99._poolKind = "ImageLabel";
        end;

        preloadEmitAssets(v97, v99.FlipbookDecals);
        v98.Parent = resolveImageParent(v97, p94);
        p93:_registerEmit(v99, p96);

        for _, descendant in v98:GetDescendants() do
            if descendant:GetAttribute("Transformed") and descendant:IsA("ImageLabel") then
                p93:EnableEmit(descendant, nil, p96);
            end;
        end;
    end;

    function u1.EmitImageLabelAnimate(p100, p101, p102, p103) -- Line: 376
        -- upvalues: preloadAndWait (copy), buildImageLabelPData (copy), u1 (copy), preloadEmitAssets (copy), resolveImageParent (copy)
        if p100.ActiveAnimates[p101] then
            return;
        end;

        local v104 = p100:GetData(p101);

        if not (v104 and v104.RenderTemplate) then
            return;
        end;

        preloadAndWait(p100, v104.RenderTemplate, v104, nil);
        local v105 = v104.RenderTemplate:Clone();
        v105.Archivable = false;
        v105.Visible = true;
        v105:SetAttribute("_PartIcleEmit", true);
        local ImageFlipbooks = v105:FindFirstChild("ImageFlipbooks");

        if ImageFlipbooks then
            ImageFlipbooks:Destroy();
        end;

        local v106 = buildImageLabelPData(v104, v105, p101, true);
        v106.Link = p102;
        v106._sourceItem = p101;
        u1._seedTsOverride(v106, p101);
        v106.Events = v104.Events;
        preloadEmitAssets(v104, v106.FlipbookDecals);
        v105.Parent = resolveImageParent(v104, p101);
        p100.ActiveAnimates[p101] = v106;
        p100:_registerEmit(v106, p103);

        for _, descendant in v105:GetDescendants() do
            if descendant:GetAttribute("Transformed") and descendant:IsA("ImageLabel") then
                p100:EnableEmit(descendant, nil, p103);
            end;
        end;
    end;

    function u1.UpdateImageLabel(p107, p108, p109, p110) -- Line: 408
        -- upvalues: Graph (ref), applyFlipbookFrame (copy)
        local VisualPart = p108.VisualPart;

        if not (VisualPart and VisualPart.Parent) then
            return true;
        end;

        if p108.TotalKeyFrames <= 0 then
            return true;
        end;

        local v111 = math.max((p110 - p108.StartTime) / p108.LifeTime, 0);
        local v112 = math.min(v111, 1);
        local v113;

        if p108._tsOverride == nil or p110 >= (p108._tsOverrideUntil or 0) then
            v113 = p108.Graphs.Timescale and (Graph.QueryPointsWithTime(v112, p108.Graphs.Timescale, p108.Seeds.Timescale) or 1) or 1;
        else
            v113 = p108._tsOverride;
        end;

        local v114 = p109 * v113;

        if p108._invertDtSign then
            v114 = v114 * p108._invertDtSign;
        end;

        local LifeTime = p108.LifeTime;
        local v115 = p108._effectiveElapsed or 0;
        local v116 = v115 + (p108._timeFrozen and 0 or v114);
        local v117 = v116 < 0 and 0 or v116;

        if LifeTime < v117 then
            v117 = LifeTime;
        end;

        p108._effectiveElapsed = v117;
        local v118 = v117 / LifeTime;
        local v119 = v118 > 1 and 1 or v118;
        local Graphs = p108.Graphs;
        local Seeds = p108.Seeds;
        p108.AccumulatedDT = (p108.AccumulatedDT or 0) + (v117 - v115);
        local v120 = math.floor((v119 < 0 and 0 or v119) * p108.TotalKeyFrames);

        if v120 ~= p108.CurrentStep then
            local AccumulatedDT = p108.AccumulatedDT;
            p108.AccumulatedDT = 0;
            p108.CurrentStep = v120;
            local v121 = v120 / p108.TotalKeyFrames;
            local v122 = 0;

            if p108._staticImgSpeed then
                v122 = p108._staticImgSpeed * 100;
            elseif Graphs.ImgSpeed then
                v122 = Graph.QueryPointsWithTime(v121, Graphs.ImgSpeed, Seeds.ImgSpeed) * 100;
            end;

            if v122 ~= 0 and p108.Drag > 0 then
                v122 = v122 * math.exp(-p108.Drag * v117);
            end;

            p108.EnvVelX = p108.EnvVelX + p108.AccelX * 100 * AccumulatedDT;
            p108.EnvVelY = p108.EnvVelY + p108.AccelY * 100 * AccumulatedDT;

            if p108.Drag > 0 then
                local v123 = math.max(0, 1 - p108.Drag * AccumulatedDT);
                p108.EnvVelX = p108.EnvVelX * v123;
                p108.EnvVelY = p108.EnvVelY * v123;
            end;

            local v124 = v122 * p108.DirY + p108.EnvVelY;
            p108.PosX = p108.PosX + (v122 * p108.DirX + p108.EnvVelX) * AccumulatedDT;
            p108.PosY = p108.PosY + v124 * AccumulatedDT;
            local BasePosition = p108.BasePosition;
            VisualPart.Position = UDim2.new(BasePosition.X.Scale, BasePosition.X.Offset + p108.PosX, BasePosition.Y.Scale, BasePosition.Y.Offset + p108.PosY);
            local v125 = nil;

            if p108._staticImgRotSpeed then
                v125 = p108._staticImgRotSpeed;
            elseif Graphs.ImgRotSpeed then
                v125 = Graph.QueryPointsWithTime(v121, Graphs.ImgRotSpeed, Seeds.ImgRotSpeed);
            end;

            if v125 then
                local v126;

                if p108.RotMode == "Speed" then
                    p108.AccRot = p108.AccRot + v125 * AccumulatedDT;
                    v126 = p108.InitialRotation + p108.AccRot;
                else
                    v126 = p108.InitialRotation + v125;
                end;

                if v126 ~= p108._lastRotation then
                    VisualPart.Rotation = v126;
                    p108._lastRotation = v126;
                end;
            end;

            if (p108._staticSizeScaleX or Graphs.SizeScaleX or (p108._staticSizeScaleY or Graphs.SizeScaleY)) and not p108.SkipSize then
                local v127 = p108._staticSizeScaleX or (Graphs.SizeScaleX and (Graph.QueryPointsWithTime(v121, Graphs.SizeScaleX, Seeds.SizeScaleX) or 1) or 1);
                local v128 = p108._staticSizeScaleY or (Graphs.SizeScaleY and (Graph.QueryPointsWithTime(v121, Graphs.SizeScaleY, Seeds.SizeScaleY) or 1) or 1);

                if v127 ~= p108._lastSizeX or v128 ~= p108._lastSizeY then
                    local BaseSize = p108.BaseSize;
                    VisualPart.Size = UDim2.new(BaseSize.X.Scale * v127, BaseSize.X.Offset * v127, BaseSize.Y.Scale * v128, BaseSize.Y.Offset * v128);
                    p108._lastSizeX = v127;
                    p108._lastSizeY = v128;
                end;
            end;

            if Graphs.ImageTransparency and not p108.SkipTransparency then
                VisualPart.ImageTransparency = Graph.QueryPointsWithTime(v121, Graphs.ImageTransparency, Seeds.ImageTransparency);
            end;

            if Graphs.BackgroundTransparency and not p108.SkipTransparency then
                VisualPart.BackgroundTransparency = Graph.QueryPointsWithTime(v121, Graphs.BackgroundTransparency, Seeds.BackgroundTransparency);
            end;

            if Graphs.ImageColor3 and not p108.SkipColor then
                VisualPart.ImageColor3 = Graph.QueryColorPointWithTime(v121, Graphs.ImageColor3);
            end;

            if Graphs.BackgroundColor3 and not p108.SkipColor then
                VisualPart.BackgroundColor3 = Graph.QueryColorPointWithTime(v121, Graphs.BackgroundColor3);
            end;
        end;

        applyFlipbookFrame(p108, v117);

        return v112 >= 1 and (LifeTime <= v117 or v117 <= 0);
    end;

    function u1._refreshImageLabelAnimateNonSpatial(p129, p130, p131) -- Line: 539
        -- upvalues: Range (ref), gatherFlipbookDecals (copy), Graph (ref)
        if not p131 then
            return;
        end;

        local v132 = p131.ImgSpreadAngle or 0;
        local v133 = (p131.ImgEmissionAngle or 90) + (math.random() * 2 - 1) * v132;
        local v134 = math.rad(v133);
        local v135 = math.cos(v134);
        local v136 = -math.sin(v134);
        p130.DirX = v135;
        p130.DirY = v136;

        if p131.ImgAcceleration then
            p130.AccelX = p131.ImgAcceleration.X;
            p130.AccelY = p131.ImgAcceleration.Y;
        end;

        if p131.ImgDrag ~= nil then
            p130.Drag = p131.ImgDrag;
        end;

        if p131.ImgPosition then
            p130.BasePosition = p131.ImgPosition;
        end;

        if p131.ImgSizeUDim then
            p130.BaseSize = p131.ImgSizeUDim;
        end;

        if p131.ImgRotMode then
            p130.RotMode = p131.ImgRotMode;
        end;

        if p131.ImgRotRange then
            p130.InitialRotation = Range.RandomValueFromRange(p131.ImgRotRange);
        end;

        if p131.ImgFlipbookSource then
            p130.FlipbookSource = p131.ImgFlipbookSource;
        end;

        if p131.ImgFlipbookMode then
            p130.FlipbookMode = p131.ImgFlipbookMode;
        end;

        if p131.ImgFlipbookFramerate then
            p130.FlipbookFramerate = Range.RandomValueFromRange(p131.ImgFlipbookFramerate);
        end;

        if p131.ImgFlipbookReverse ~= nil then
            p130.FlipbookReverse = p131.ImgFlipbookReverse;
        end;

        if p131.ImgGridCols then
            p130.GridCols = p131.ImgGridCols;
        end;

        if p131.ImgGridRows then
            p130.GridRows = p131.ImgGridRows;
        end;

        if p131.SheetSize ~= nil then
            p130.SheetSize = p131.SheetSize;
        end;

        if p131.ImageFlipbooks then
            p130.FlipbookDecals = gatherFlipbookDecals(p131.ImageFlipbooks);
        end;

        if p131.ImgTimescale and p130.Graphs then
            p130.Graphs.Timescale = p131.ImgTimescale;
            p130.Seeds.Timescale = Graph.GenerateSeed(p131.ImgTimescale);
        end;
    end;
end;