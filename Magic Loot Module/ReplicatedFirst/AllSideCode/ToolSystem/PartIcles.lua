-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Particles = require(script.Particles);
local u1 = {
    Beam = {},
    _focused = true,
    _unfocusedAt = 0
};

if RunService:IsClient() then
    u1._focusConn = UserInputService.WindowFocused:Connect(function() -- Line: 110
        -- upvalues: u1 (copy)
        u1._focused = true;
        u1._unfocusedAt = 0;
    end);
    u1._blurConn = UserInputService.WindowFocusReleased:Connect(function() -- Line: 111
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
require(script.TrailEmitter)(u1);
require(script.ScreenEmit)(u1);
require(script.ImageEmit)(u1);
require(script.LinkTrack)(u1);
require(script.Orientation)(u1);
require(script.ZOffset)(u1);
require(script.Engine)(u1);
require(script.Lifecycle)(u1);

function u1._warnIfNotActivated(p2, p3) -- Line: 163
    if p2.Connection then
        return;
    end;

    if p2._notActivatedWarned then
        return;
    end;

    p2._notActivatedWarned = true;
    warn(string.format("[Part-Icles] :%s() called before :Activate()  -  particles will not update until the engine is activated. Call Particle:Activate() once at startup.", p3));
end;

function u1._applyEmitVisualPasses(p4, p5) -- Line: 174
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

function u1.Emit(p8, u9, p10, p11) -- Line: 195
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
        task.delay(u9:GetAttribute("EmitDelay") or 0, function() -- Line: 227
            -- upvalues: u9 (copy), u15 (ref)
            if not (u9 and u9.Parent) then
                return;
            end;

            u9.Enabled = true;
            task.delay(u15, function() -- Line: 230
                -- upvalues: u9 (ref)
                if u9 and u9.Parent then
                    u9.Enabled = false;
                end;
            end);
        end);
    end;
end;

local Duration = require(script.Duration);

function u1.await(p21) -- Line: 272
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

function u1._absoluteEmitFire(p22, u23, p24, p25) -- Line: 282
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

                local function doEmit() -- Line: 333
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

    local function v36() -- Line: 305
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

function u1.AbsoluteEmit(p37, p38, p39, p40) -- Line: 372
    -- upvalues: Duration (copy)
    p37:_warnIfNotActivated("AbsoluteEmit");

    if not p38 then
        return 0;
    end;

    p37:_absoluteEmitFire(p38, p39, p40);

    return Duration.computeMaxDuration(p38, 0);
end;

function u1.AbsoluteEmitAt(u41, u42, u43, p44) -- Line: 417
    -- upvalues: Duration (copy), Particles (copy)
    u41:_warnIfNotActivated("AbsoluteEmitAt");

    if not (u42 and u43) then
        return 0;
    end;

    local u45 = p44 or {};
    local v46 = Duration.computeMaxDuration(u42, 0);
    local u47;

    if u45.LinkOverride == true then
        u47 = u45.Link ~= nil;
    else
        u47 = false;
    end;

    if u42:GetAttribute("Transformed") then
        if u45.Link ~= nil then
            u41:SetLink(u42, u45.Link, u45.LinkMode or "Weld");
        end;

        if u45.EmitParent ~= nil then
            u41:SetEmitParent(u42, u45.EmitParent);
        end;

        local v48 = {
            ChainCtx = u45.ChainCtx,
            UseFullOrigin = u45.UseFullOrigin ~= false,
            IgnoreLink = u45.IgnoreLink == true
        };

        if not u47 then
            v48.EventOriginCF = u43;
            v48.EventOriginResolver = u45.OriginResolver;
        end;

        u41:EnableEmit(u42, nil, v48);

        return v46;
    end;

    if not (u42:IsA("BasePart") or (u42:IsA("Model") or u42:IsA("Attachment"))) then
        return 0;
    end;

    local v49 = nil;
    local u50;

    if u42:IsA("Model") then
        local v51;
        v51, u50 = pcall(u42.GetPivot, u42);

        if not v51 then
            u50 = v49;
        end;
    elseif u42:IsA("BasePart") then
        u50 = u42.CFrame;
    elseif u42:IsA("Attachment") then
        u50 = u42.WorldCFrame;
    else
        u50 = v49;
    end;

    local function readWorldCF(p52) -- Line: 462
        if p52:IsA("Model") then
            local success, result = pcall(p52.GetPivot, p52);

            return success and result and result or nil;
        end;

        if p52:IsA("Attachment") then
            return p52.WorldCFrame;
        end;

        if p52:IsA("BasePart") then
            return p52.CFrame;
        end;

        return nil;
    end;

    local function originFor(p53) -- Line: 469
        -- upvalues: u50 (ref), u43 (copy), readWorldCF (copy)
        if not u50 then
            return u43;
        end;

        local v54 = readWorldCF(p53);

        if v54 then
            return u43 * u50:ToObjectSpace(v54);
        end;

        return u43;
    end;

    local function ctxFor(p55) -- Line: 476
        -- upvalues: u45 (ref), u47 (copy), u50 (ref), u43 (copy), readWorldCF (copy)
        local v56 = {
            ChainCtx = u45.ChainCtx,
            UseFullOrigin = u45.UseFullOrigin ~= false,
            IgnoreLink = u45.IgnoreLink == true
        };

        if not u47 then
            local v57;

            if u50 then
                local v58 = readWorldCF(p55);

                if v58 then
                    v57 = u43 * u50:ToObjectSpace(v58);
                else
                    v57 = u43;
                end;
            else
                v57 = u43;
            end;

            v56.EventOriginCF = v57;
            v56.EventOriginResolver = u45.OriginResolver;
        end;

        return v56;
    end;

    if (u45.ApplyToAll or u47) and (u45.Link ~= nil or u45.EmitParent ~= nil) then
        local function applyAuthoring(p59) -- Line: 493
            -- upvalues: u45 (ref), u41 (copy), applyAuthoring (copy)
            if p59:GetAttribute("Transformed") then
                if u45.Link ~= nil then
                    u41:SetLink(p59, u45.Link, u45.LinkMode or "Weld");
                end;

                if u45.EmitParent ~= nil then
                    u41:SetEmitParent(p59, u45.EmitParent);
                end;
            end;

            for _, child in p59:GetChildren() do
                applyAuthoring(child);
            end;
        end;

        applyAuthoring(u42);
    end;

    local function walkTransformed(p60) -- Line: 510
        -- upvalues: u41 (copy), u45 (ref), u47 (copy), u50 (ref), u43 (copy), readWorldCF (copy), walkTransformed (copy)
        if not p60:GetAttribute("Transformed") then
            for _, child in p60:GetChildren() do
                walkTransformed(child);
            end;

            return;
        end;

        local v61 = {
            ChainCtx = u45.ChainCtx,
            UseFullOrigin = u45.UseFullOrigin ~= false,
            IgnoreLink = u45.IgnoreLink == true
        };

        if not u47 then
            local v62;

            if u50 then
                local v63 = readWorldCF(p60);

                if v63 then
                    v62 = u43 * u50:ToObjectSpace(v63);
                else
                    v62 = u43;
                end;
            else
                v62 = u43;
            end;

            v61.EventOriginCF = v62;
            v61.EventOriginResolver = u45.OriginResolver;
        end;

        u41:EnableEmit(p60, nil, v61);
    end;

    walkTransformed(u42);

    if u45.SkipClone then
        Particles.EnableEmit(u42, u41:_makeAliveCheck());

        return v46;
    end;

    local function _underTransformedAncestor(p64) -- Line: 533
        -- upvalues: u42 (copy)
        local Parent = p64.Parent;

        while Parent and Parent ~= u42 do
            if Parent:GetAttribute("Transformed") then
                return true;
            end;

            Parent = Parent.Parent;
        end;

        return false;
    end;

    local v65 = false;

    for _, descendant in ipairs(u42:GetDescendants()) do
        if (descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam"))) and not (descendant:GetAttribute("Transformed") or _underTransformedAncestor(descendant)) then
            v65 = true;
            break;
        end;
    end;

    if not v65 then
        return v46;
    end;

    local success, result = pcall(u42.Clone, u42);

    if not (success and result) then
        return v46;
    end;

    pcall(function() -- Line: 553
        -- upvalues: result (copy)
        result.Archivable = false;
    end);

    for _, descendant in ipairs(result:GetDescendants()) do
        if descendant:GetAttribute("Transformed") then
            pcall(function() -- Line: 559
                -- upvalues: descendant (copy)
                descendant:Destroy();
            end);
        end;
    end;

    if result:IsA("BasePart") then
        pcall(function() -- Line: 563
            -- upvalues: result (copy)
            result.Anchored = true;
        end);
    end;

    for _, descendant in ipairs(result:GetDescendants()) do
        if descendant:IsA("BasePart") then
            pcall(function() -- Line: 565
                -- upvalues: descendant (copy)
                descendant.Anchored = true;
            end);
        end;
    end;

    if u45.UseFullOrigin == false and u50 then
        u43 = CFrame.new(u43.Position) * u50.Rotation;
    end;

    if result:IsA("Model") then
        pcall(function() -- Line: 575
            -- upvalues: result (copy), u43 (ref)
            result:PivotTo(u43);
        end);
    elseif result:IsA("BasePart") then
        pcall(function() -- Line: 577
            -- upvalues: result (copy), u43 (ref)
            result.CFrame = u43;
        end);
    elseif result:IsA("Attachment") then
        pcall(function() -- Line: 579
            -- upvalues: result (copy)
            result:Destroy();
        end);

        return v46;
    end;

    result.Parent = u41:GetFolder();
    u41:_absoluteEmitFire(result, nil, nil);
    task.delay(v46 or 60, function() -- Line: 591
        -- upvalues: result (copy)
        if result and result.Parent then
            pcall(function() -- Line: 592
                -- upvalues: result (ref)
                result:Destroy();
            end);
        end;
    end);

    return v46;
end;

local TexturePin = require(script.TexturePin);

local function _isPreloadable(p66) -- Line: 612
    return p66:GetAttribute("Transformed") or (p66:IsA("ParticleEmitter") or p66:IsA("Trail"));
end;

local function _walk(p67, u68, u69) -- Line: 613
    if not p67 then
        return;
    end;

    local function visit(p70) -- Line: 615
        -- upvalues: u68 (copy), u69 (copy), visit (copy)
        if (p70:GetAttribute("Transformed") or (p70:IsA("ParticleEmitter") or p70:IsA("Trail"))) and (u68 or p70:GetAttribute("PreloadTexture") == true) then
            u69(p70);
        end;

        for _, child in p70:GetChildren() do
            visit(child);
        end;
    end;

    visit(p67);
end;

function u1.Preload(p71, p72, u73) -- Line: 624
    -- upvalues: TexturePin (copy)
    local pinSubtree = TexturePin.pinSubtree;

    if not p72 then
        return;
    end;

    local function u75(p74) -- Line: 615
        -- upvalues: u73 (copy), pinSubtree (copy), u75 (copy)
        if (p74:GetAttribute("Transformed") or (p74:IsA("ParticleEmitter") or p74:IsA("Trail"))) and (u73 or p74:GetAttribute("PreloadTexture") == true) then
            pinSubtree(p74);
        end;

        for _, child in p74:GetChildren() do
            u75(child);
        end;
    end;

    u75(p72);
end;

function u1.Deload(p76, p77, u78) -- Line: 626
    -- upvalues: TexturePin (copy)
    local unpinSubtree = TexturePin.unpinSubtree;

    if not p77 then
        return;
    end;

    local function u80(p79) -- Line: 615
        -- upvalues: u78 (copy), unpinSubtree (copy), u80 (copy)
        if (p79:GetAttribute("Transformed") or (p79:IsA("ParticleEmitter") or p79:IsA("Trail"))) and (u78 or p79:GetAttribute("PreloadTexture") == true) then
            unpinSubtree(p79);
        end;

        for _, child in p79:GetChildren() do
            u80(child);
        end;
    end;

    u80(p77);
end;

u1.LinkService = require(script.LinkService);

function u1.SetLink(p81, u82, p83, u84) -- Line: 639
    if not (u82 and u82:GetAttribute("Transformed")) then
        return;
    end;

    if p83 == "camera" then
        pcall(function() -- Line: 642
            -- upvalues: u82 (copy)
            u82:SetAttribute("LinkSource", "Camera");
        end);
    elseif p83 == nil then
        pcall(function() -- Line: 644
            -- upvalues: u82 (copy)
            u82:SetAttribute("LinkSource", "None");
        end);
        local Link = u82:FindFirstChild("Link");

        if Link and Link:IsA("ObjectValue") then
            Link.Value = nil;
        end;
    elseif typeof(p83) == "Instance" then
        local Link = u82:FindFirstChild("Link");

        if not Link then
            Link = Instance.new("ObjectValue");
            Link.Name = "Link";
            Link.Parent = u82;
        end;

        Link.Value = p83;
        pcall(function() -- Line: 655
            -- upvalues: u82 (copy)
            u82:SetAttribute("LinkSource", "Object");
        end);
    end;

    if u84 then
        pcall(function() -- Line: 657
            -- upvalues: u82 (copy), u84 (copy)
            u82:SetAttribute("LinkMode", u84);
        end);
    end;
end;

function u1.SetEmitParent(p85, p86, p87) -- Line: 662
    if not (p86 and p86:GetAttribute("Transformed")) then
        return;
    end;

    if p87 == nil then
        local EmitParent = p86:FindFirstChild("EmitParent");

        if EmitParent then
            pcall(function() -- Line: 666
                -- upvalues: EmitParent (copy)
                EmitParent:Destroy();
            end);
        end;

        return;
    end;

    if typeof(p87) ~= "Instance" then
        return;
    end;

    local EmitParent = p86:FindFirstChild("EmitParent");

    if not EmitParent then
        EmitParent = Instance.new("ObjectValue");
        EmitParent.Name = "EmitParent";
        EmitParent.Parent = p86;
    end;

    EmitParent.Value = p87;
end;

return u1;