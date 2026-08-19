-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Particles = require(script.Particles);
local PlayHandle = require(script.PlayHandle);
local u1 = {
    Beam = {},
    _focused = true,
    _unfocusedAt = 0
};

if RunService:IsClient() then
    u1._focusConn = UserInputService.WindowFocused:Connect(function() -- Line: 114
        -- upvalues: u1 (copy)
        u1._focused = true;
        u1._unfocusedAt = 0;
    end);
    u1._blurConn = UserInputService.WindowFocusReleased:Connect(function() -- Line: 115
        -- upvalues: u1 (copy)
        u1._focused = false;
        u1._unfocusedAt = os.clock();
    end);
end;

u1.ActiveEmits = {};
u1.ActiveLoops = {};
u1.ActiveAnimates = {};
u1.ActiveChainLoops = {};
u1._evenCycleStore = {};
u1.Connection = nil;
u1._CachedFolder = nil;
u1._engineGen = 0;
u1.MAX_ACTIVE_PARTICLES = 1000;
u1._capWarnLastAt = 0;
u1._lingerVisualCount = 0;
u1._preloadedAssets = setmetatable({}, {
    __mode = "k"
});
require(script.GetData)(u1);
require(script.Transform)(u1);
require(script.Update)(u1);
require(script.UpdateBeam)(u1);
require(script.Timescale)(u1);
require(script.Emit)(u1);
require(script.EmitAnimate)(u1);
require(script.EmitModel)(u1);
require(script.UpdateModel)(u1);
require(script.PointLight)(u1);
require(script.Highlight)(u1);
require(script.Lightning)(u1);
require(script.CameraShake)(u1);
require(script.Rocks)(u1);
require(script.Rope)(u1);
require(script.TrailEmitter)(u1);
require(script.ScreenEmit)(u1);
require(script.ImageEmit)(u1);
require(script.LinkTrack)(u1);
require(script.Orientation)(u1);
require(script.ZOffset)(u1);
require(script.Engine)(u1);
require(script.EngineReplay)(u1);
require(script.PreSimulate)(u1);
require(script.RegisterEmit)(u1);
require(script.Lifecycle)(u1);

function u1._warnIfNotActivated(p2, p3) -- Line: 178
    if p2.Connection then
        return;
    end;

    if p2._notActivatedWarned then
        return;
    end;

    p2._notActivatedWarned = true;
    warn(string.format("[Part-Icles] :%s() called before :Activate()  -  particles will not update until the engine is activated. Call Particle:Activate() once at startup.", p3));
end;

function u1._applyEmitVisualPasses(p4, p5) -- Line: 189
    local Type = p5.Type;

    if Type ~= "Part" and (Type ~= "Model" and Type ~= "Attachment") then
        return;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CFrame.Position;
    end;

    local v6 = p5.Orientation and p5.Orientation ~= "None";
    local v7 = p5.ZOffset and p5.ZOffset ~= 0;

    if v6 or v7 then
        p5._postUpdateCF = Type == "Model" and p5.VisualPart:GetPivot() or p5.VisualPart.CFrame;
    end;

    if v6 then
        p4:ApplyOrientation(p5, 0.016666666666666666, CurrentCamera);
    end;

    if v7 then
        p4:ApplyZOffset(p5, CurrentCamera);
    end;
end;

function u1.Emit(p8, u9, p10, p11) -- Line: 210
    -- upvalues: u1 (copy)
    if not (u9 and u9.Parent) then
        return;
    end;

    p8:_warnIfNotActivated("Emit");
    local v12 = p8.MAX_ACTIVE_PARTICLES or 1000;

    if v12 <= #p8.ActiveEmits + (p8._lingerVisualCount or 0) then
        local v13 = os.clock();

        if v13 - (p8._capWarnLastAt or 0) >= 1 then
            p8._capWarnLastAt = v13;
            warn(("[Part-Icles] active particle cap (%d) reached  -  new emits skipped (user Module code still runs)."):format(v12));
        end;

        return;
    end;

    if u9:IsA("Beam") and u9:FindFirstChild("PartIcleProperties") then
        p8:EmitBeam(u9, p10, p11);

        return;
    end;

    if not u9:IsA("Beam") and (not u9:IsA("Trail") or u9:FindFirstChild("PartIcleProperties")) then
        if u9:IsA("Trail") then
            p8:EmitTrail(u9, p10, p11);

            return;
        end;

        if u9:IsA("PointLight") then
            p8:EmitPointLight(u9, p10, p11);

            return;
        end;

        if u9:IsA("Highlight") then
            p8:EmitHighlight(u9, p10, p11);

            return;
        end;

        if u9:IsA("Attachment") then
            p8:EmitAttachment(u9, p10, p11);

            return;
        end;

        if u9:IsA("Model") then
            p8:EmitModel(u9, p10, p11);

            return;
        end;

        if u9:IsA("BlurEffect") then
            p8:EmitBlur(u9, p10, p11);

            return;
        end;

        if u9:IsA("BloomEffect") then
            p8:EmitBloom(u9, p10, p11);

            return;
        end;

        if u9:IsA("ColorCorrectionEffect") then
            p8:EmitColorCorrection(u9, p10, p11);

            return;
        end;

        if u9:IsA("Atmosphere") then
            p8:EmitAtmosphere(u9, p10, p11);

            return;
        end;

        if u9:IsA("ImageLabel") then
            p8:EmitImageLabel(u9, p10, p11);

            return;
        end;

        if u1._isLightning(u9) then
            p8:EmitLightning(u9, p10, p11);

            return;
        end;

        if u1._isCameraShake(u9) then
            p8:EmitCameraShake(u9, p10, p11);

            return;
        end;

        if u1._isRocks(u9) then
            p8:EmitRocks(u9, p10, p11);

            return;
        end;

        if u1._isRope(u9) then
            p8:EmitRope(u9, p10, p11);

            return;
        end;

        if u9:IsA("BasePart") then
            p8:EmitPart(u9, p10, p11);
        end;

        return;
    end;

    local v14 = u9:GetAttribute("EmitDuration");
    local u15 = 0;

    if typeof(v14) == "number" then
        u15 = v14;
    elseif v14 ~= nil then
        local v16, v17 = tostring(v14):match("([%-%.%d]+)%s*,%s*([%-%.%d]+)");
        local v18;

        if v16 and v17 then
            local v19 = tonumber(v16) or 0;
            local v20 = tonumber(v17) or 0;
            u15 = math.max(v19, v20);

            if not u15 then
                v18 = tostring(v14);
                u15 = tonumber(v18) or 0;
            end;
        else
            v18 = tostring(v14);
            u15 = tonumber(v18) or 0;
        end;
    end;

    if u15 > 0 then
        task.delay(u9:GetAttribute("EmitDelay") or 0, function() -- Line: 242
            -- upvalues: u9 (copy), u15 (ref)
            if not (u9 and u9.Parent) then
                return;
            end;

            u9.Enabled = true;
            task.delay(u15, function() -- Line: 245
                -- upvalues: u9 (ref)
                if u9 and u9.Parent then
                    u9.Enabled = false;
                end;
            end);
        end);
    end;
end;

local Duration = require(script.Duration);

function u1.await(p21) -- Line: 296
    if p21 == nil then
        return;
    end;

    if type(p21) ~= "number" then
        return;
    end;

    if p21 <= 0 then
        return;
    end;

    task.wait(p21);
end;

function u1._absoluteEmitFire(p22, u23, p24, p25) -- Line: 306
    -- upvalues: Particles (copy)
    if u23:GetAttribute("Transformed") then
        p22:EnableEmit(u23, nil, p25);

        return;
    end;

    local u26 = p22:_makeAliveCheck();

    if not u23:IsA("ParticleEmitter") then
        if u23:IsA("Trail") then
            if p24 then
                return;
            end;

            Particles.EnableEmitSingle(u23, u26);

            return;
        end;

        if u23:IsA("Beam") then
            if p24 then
                return;
            end;

            local u27 = tonumber(u23:GetAttribute("EmitDuration")) or 0;
            local v28 = tonumber(u23:GetAttribute("EmitDelay")) or 0;

            if u27 > 0 then
                local u29 = Particles.ReadNativeGen(u23);

                local function doEmit() -- Line: 357
                    -- upvalues: u26 (copy), Particles (ref), u23 (copy), u29 (copy), u27 (copy)
                    if not (u26() and Particles.IsNativeGenCurrent(u23, u29)) then
                        return;
                    end;

                    Particles.SetEnabledForDuration(u23, u27);
                end;

                if v28 > 0 then
                    task.delay(v28, doEmit);

                    return;
                end;

                if u26() then
                    if not Particles.IsNativeGenCurrent(u23, u29) then
                        return;
                    end;

                    Particles.SetEnabledForDuration(u23, u27);
                end;
            end;

            return;
        end;

        local v30;

        if u23:IsA("BasePart") or u23:IsA("Attachment") then
            v30 = not p24;
        else
            v30 = u23:IsA("Model") and not p24;
        end;

        if v30 then
            Particles.EnableEmit(u23, u26);
        end;

        local v31 = v30 or p24;

        for _, child in u23:GetChildren() do
            if not u23:IsA("BasePart") or (not child:IsA("BasePart") or child:GetAttribute("Transformed")) then
                p22:_absoluteEmitFire(child, v31, p25);
            end;
        end;

        return;
    end;

    if p24 then
        return;
    end;

    local u32 = tonumber(u23:GetAttribute("EmitCount")) or 1;
    local v33 = tonumber(u23:GetAttribute("EmitDelay")) or 0;
    local u34 = tonumber(u23:GetAttribute("EmitDuration")) or 0;

    if u32 <= 0 and u34 <= 0 then
        return;
    end;

    local u35 = Particles.ReadNativeGen(u23);

    local function v36() -- Line: 329
        -- upvalues: u26 (copy), Particles (ref), u23 (copy), u35 (copy), u32 (copy), u34 (copy)
        if not (u26() and Particles.IsNativeGenCurrent(u23, u35)) then
            return;
        end;

        if u32 > 0 then
            u23:Emit(u32);
        end;

        if u34 > 0 then
            Particles.SetEnabledForDuration(u23, u34);
        end;
    end;

    if v33 > 0 then
        task.delay(v33, v36);

        return;
    end;

    v36();
end;

function u1.AbsoluteEmit(p37, p38, p39, p40) -- Line: 396
    -- upvalues: Duration (copy)
    p37:_warnIfNotActivated("AbsoluteEmit");

    if not p38 then
        return 0;
    end;

    p37:_absoluteEmitFire(p38, p39, p40);

    return Duration.computeMaxDuration(p38, 0);
end;

function u1.AbsoluteEmitAt(u41, u42, u43, p44) -- Line: 441
    -- upvalues: Duration (copy), PlayHandle (copy), Particles (copy)
    u41:_warnIfNotActivated("AbsoluteEmitAt");

    if not (u42 and u43) then
        return nil, 0;
    end;

    local u45 = p44 or {};
    local v46 = Duration.computeMaxDuration(u42, 0);
    local u47 = {
        Alive = true,
        Loops = {},
        Clones = {},
        Duration = v46
    };
    local v48 = PlayHandle.new(u41, u47);
    local u49;

    if u45.LinkOverride == true then
        u49 = u45.Link ~= nil;
    else
        u49 = false;
    end;

    if u42:GetAttribute("Transformed") then
        if u45.Link ~= nil then
            u41:SetLink(u42, u45.Link, u45.LinkMode or "Weld");
        end;

        if u45.EmitParent ~= nil then
            u41:SetEmitParent(u42, u45.EmitParent);
        end;

        local v50 = {
            ChainCtx = u45.ChainCtx,
            UseFullOrigin = u45.UseFullOrigin ~= false,
            IgnoreLink = u45.IgnoreLink == true,
            _playToken = u47
        };

        if not u49 then
            v50.EventOriginCF = u43;
            v50.EventOriginResolver = u45.OriginResolver;
        end;

        u41:EnableEmit(u42, nil, v50);

        return v48, v46;
    end;

    if not (u42:IsA("BasePart") or (u42:IsA("Model") or u42:IsA("Attachment"))) then
        return nil, 0;
    end;

    local v51 = nil;
    local u52;

    if u42:IsA("Model") then
        local v53;
        v53, u52 = pcall(u42.GetPivot, u42);

        if not v53 then
            u52 = v51;
        end;
    elseif u42:IsA("BasePart") then
        u52 = u42.CFrame;
    elseif u42:IsA("Attachment") then
        u52 = u42.WorldCFrame;
    else
        u52 = v51;
    end;

    local function readWorldCF(p54) -- Line: 493
        if p54:IsA("Model") then
            local success, result = pcall(p54.GetPivot, p54);

            return success and result and result or nil;
        end;

        if p54:IsA("Attachment") then
            return p54.WorldCFrame;
        end;

        if p54:IsA("BasePart") then
            return p54.CFrame;
        end;

        return nil;
    end;

    local function originFor(p55) -- Line: 500
        -- upvalues: u52 (ref), u43 (copy), readWorldCF (copy)
        if not u52 then
            return u43;
        end;

        local v56 = readWorldCF(p55);

        if v56 then
            return u43 * u52:ToObjectSpace(v56);
        end;

        return u43;
    end;

    local function ctxFor(p57) -- Line: 507
        -- upvalues: u45 (ref), u47 (copy), u49 (copy), u52 (ref), u43 (copy), readWorldCF (copy)
        local v58 = {
            ChainCtx = u45.ChainCtx,
            UseFullOrigin = u45.UseFullOrigin ~= false,
            IgnoreLink = u45.IgnoreLink == true,
            _playToken = u47
        };

        if not u49 then
            local v59;

            if u52 then
                local v60 = readWorldCF(p57);

                if v60 then
                    v59 = u43 * u52:ToObjectSpace(v60);
                else
                    v59 = u43;
                end;
            else
                v59 = u43;
            end;

            v58.EventOriginCF = v59;
            v58.EventOriginResolver = u45.OriginResolver;
        end;

        return v58;
    end;

    if (u45.ApplyToAll or u49) and (u45.Link ~= nil or u45.EmitParent ~= nil) then
        local function applyAuthoring(p61) -- Line: 525
            -- upvalues: u45 (ref), u41 (copy), applyAuthoring (copy)
            if p61:GetAttribute("Transformed") then
                if u45.Link ~= nil then
                    u41:SetLink(p61, u45.Link, u45.LinkMode or "Weld");
                end;

                if u45.EmitParent ~= nil then
                    u41:SetEmitParent(p61, u45.EmitParent);
                end;
            end;

            for _, child in p61:GetChildren() do
                applyAuthoring(child);
            end;
        end;

        applyAuthoring(u42);
    end;

    local function walkTransformed(p62) -- Line: 542
        -- upvalues: u41 (copy), ctxFor (copy), walkTransformed (copy)
        if p62:GetAttribute("Transformed") then
            u41:EnableEmit(p62, nil, (ctxFor(p62)));

            return;
        end;

        for _, child in p62:GetChildren() do
            walkTransformed(child);
        end;
    end;

    walkTransformed(u42);

    if u45.SkipClone then
        Particles.EnableEmit(u42, u41:_makeAliveCheck());

        return v48, v46;
    end;

    local function _underTransformedAncestor(p63) -- Line: 565
        -- upvalues: u42 (copy)
        local Parent = p63.Parent;

        while Parent and Parent ~= u42 do
            if Parent:GetAttribute("Transformed") then
                return true;
            end;

            Parent = Parent.Parent;
        end;

        return false;
    end;

    local v64 = false;

    for _, descendant in ipairs(u42:GetDescendants()) do
        if (descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam"))) and not (descendant:GetAttribute("Transformed") or _underTransformedAncestor(descendant)) then
            v64 = true;
            break;
        end;
    end;

    if not v64 then
        return v48, v46;
    end;

    local success, result = pcall(u42.Clone, u42);

    if not (success and result) then
        return v48, v46;
    end;

    pcall(function() -- Line: 585
        -- upvalues: result (copy)
        result.Archivable = false;
    end);

    for _, descendant in ipairs(result:GetDescendants()) do
        if descendant:GetAttribute("Transformed") then
            pcall(function() -- Line: 591
                -- upvalues: descendant (copy)
                descendant:Destroy();
            end);
        end;
    end;

    if result:IsA("BasePart") then
        pcall(function() -- Line: 595
            -- upvalues: result (copy)
            result.Anchored = true;
        end);
    end;

    for _, descendant in ipairs(result:GetDescendants()) do
        if descendant:IsA("BasePart") then
            pcall(function() -- Line: 597
                -- upvalues: descendant (copy)
                descendant.Anchored = true;
            end);
        end;
    end;

    if u45.UseFullOrigin == false and u52 then
        u43 = CFrame.new(u43.Position) * u52.Rotation;
    end;

    if result:IsA("Model") then
        pcall(function() -- Line: 607
            -- upvalues: result (copy), u43 (ref)
            result:PivotTo(u43);
        end);
    elseif result:IsA("BasePart") then
        pcall(function() -- Line: 609
            -- upvalues: result (copy), u43 (ref)
            result.CFrame = u43;
        end);
    elseif result:IsA("Attachment") then
        pcall(function() -- Line: 611
            -- upvalues: result (copy)
            result:Destroy();
        end);

        return v48, v46;
    end;

    result.Parent = u41:GetFolder();
    table.insert(u47.Clones, result);
    u41:_absoluteEmitFire(result, nil, nil);
    task.delay(v46 or 60, function() -- Line: 625
        -- upvalues: result (copy)
        if result and result.Parent then
            pcall(function() -- Line: 626
                -- upvalues: result (ref)
                result:Destroy();
            end);
        end;
    end);

    return v48, v46;
end;

local TexturePin = require(script.TexturePin);

local function _isPreloadable(p65) -- Line: 646
    return p65:GetAttribute("Transformed") or (p65:IsA("ParticleEmitter") or p65:IsA("Trail"));
end;

local function _walk(p66, u67, u68) -- Line: 647
    if not p66 then
        return;
    end;

    local function visit(p69) -- Line: 649
        -- upvalues: u67 (copy), u68 (copy), visit (copy)
        if (p69:GetAttribute("Transformed") or (p69:IsA("ParticleEmitter") or p69:IsA("Trail"))) and (u67 or p69:GetAttribute("PreloadTexture") == true) then
            u68(p69);
        end;

        for _, child in p69:GetChildren() do
            visit(child);
        end;
    end;

    visit(p66);
end;

function u1.Preload(p70, p71, u72) -- Line: 658
    -- upvalues: TexturePin (copy)
    local pinSubtree = TexturePin.pinSubtree;

    if not p71 then
        return;
    end;

    local function u74(p73) -- Line: 649
        -- upvalues: u72 (copy), pinSubtree (copy), u74 (copy)
        if (p73:GetAttribute("Transformed") or (p73:IsA("ParticleEmitter") or p73:IsA("Trail"))) and (u72 or p73:GetAttribute("PreloadTexture") == true) then
            pinSubtree(p73);
        end;

        for _, child in p73:GetChildren() do
            u74(child);
        end;
    end;

    u74(p71);
end;

function u1.Deload(p75, p76, u77) -- Line: 660
    -- upvalues: TexturePin (copy)
    local unpinSubtree = TexturePin.unpinSubtree;

    if not p76 then
        return;
    end;

    local function u79(p78) -- Line: 649
        -- upvalues: u77 (copy), unpinSubtree (copy), u79 (copy)
        if (p78:GetAttribute("Transformed") or (p78:IsA("ParticleEmitter") or p78:IsA("Trail"))) and (u77 or p78:GetAttribute("PreloadTexture") == true) then
            unpinSubtree(p78);
        end;

        for _, child in p78:GetChildren() do
            u79(child);
        end;
    end;

    u79(p76);
end;

u1.LinkService = require(script.LinkService);

function u1.SetLink(p80, u81, p82, u83) -- Line: 673
    if not (u81 and u81:GetAttribute("Transformed")) then
        return;
    end;

    if p82 == "camera" then
        pcall(function() -- Line: 676
            -- upvalues: u81 (copy)
            u81:SetAttribute("LinkSource", "Camera");
        end);
    elseif p82 == nil then
        pcall(function() -- Line: 678
            -- upvalues: u81 (copy)
            u81:SetAttribute("LinkSource", "None");
        end);
        local Link = u81:FindFirstChild("Link");

        if Link and Link:IsA("ObjectValue") then
            Link.Value = nil;
        end;
    elseif typeof(p82) == "Instance" then
        local Link = u81:FindFirstChild("Link");

        if not Link then
            Link = Instance.new("ObjectValue");
            Link.Name = "Link";
            Link.Parent = u81;
        end;

        Link.Value = p82;
        pcall(function() -- Line: 689
            -- upvalues: u81 (copy)
            u81:SetAttribute("LinkSource", "Object");
        end);
    end;

    if u83 then
        pcall(function() -- Line: 691
            -- upvalues: u81 (copy), u83 (copy)
            u81:SetAttribute("LinkMode", u83);
        end);
    end;
end;

function u1.SetEmitParent(p84, p85, p86) -- Line: 696
    if not (p85 and p85:GetAttribute("Transformed")) then
        return;
    end;

    if p86 == nil then
        local EmitParent = p85:FindFirstChild("EmitParent");

        if EmitParent then
            pcall(function() -- Line: 700
                -- upvalues: EmitParent (copy)
                EmitParent:Destroy();
            end);
        end;

        return;
    end;

    if typeof(p86) ~= "Instance" then
        return;
    end;

    local EmitParent = p85:FindFirstChild("EmitParent");

    if not EmitParent then
        EmitParent = Instance.new("ObjectValue");
        EmitParent.Name = "EmitParent";
        EmitParent.Parent = p85;
    end;

    EmitParent.Value = p86;
end;

return u1;