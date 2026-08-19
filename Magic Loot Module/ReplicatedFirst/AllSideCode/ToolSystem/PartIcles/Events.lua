-- Decompiled with Potassium's decompiler.

local TypeRegistry = require(script.Parent.TypeRegistry);
local EventsCollision = require(script.Parent.EventsCollision);
local EventsPayload = require(script.Parent.EventsPayload);
local EventsSchema = require(script.Parent.EventsSchema);
local Pool = require(script.Parent.Pool);
local u1 = {};
local _ = TypeRegistry.CONFIG_NAME;
local u2 = {};
u1._frameCount = 0;
u1._burstDropped = 0;
u1._burstReportPending = false;
local u3 = false;
local u4 = 0;
local u5 = 0;
local u6 = {};
local u7 = {};
local u8 = 0;

local function nextChainId() -- Line: 49
    -- upvalues: u8 (ref)
    u8 = u8 + 1;

    return u8;
end;

function u1.newChainCtx() -- Line: 54
    -- upvalues: u8 (ref)
    local v9 = {
        Depth = 0
    };
    u8 = u8 + 1;
    v9.ChainId = u8;

    return v9;
end;

function u1.withEmitIndex(p10, p11) -- Line: 59
    if not p10 then
        return {
            EmitIndex = p11
        };
    end;

    local v12 = {
        EmitIndex = p11
    };

    for i, v in pairs(p10) do
        if i ~= "EmitIndex" then
            v12[i] = v;
        end;
    end;

    return v12;
end;

function u1.withEmitIndexAndCount(p13, p14, p15) -- Line: 69
    if not p13 then
        return {
            EmitIndex = p14,
            EmitCount = p15
        };
    end;

    local v16 = {
        EmitIndex = p14,
        EmitCount = p15
    };

    for i, v in pairs(p13) do
        if i ~= "EmitIndex" and i ~= "EmitCount" then
            v16[i] = v;
        end;
    end;

    return v16;
end;

function u1.withEvenOffset(p17, p18, p19, p20, p21, p22, p23) -- Line: 83
    local v24 = {
        EmitIndex = p18,
        EmitCount = p19
    };

    if p17 then
        for i, v in pairs(p17) do
            if i ~= "EmitIndex" and (i ~= "EmitCount" and (i ~= "EvenOffsetIdx_Pos" and (i ~= "EvenOffsetN_Pos" and (i ~= "EvenOffsetIdx_Rot" and i ~= "EvenOffsetN_Rot")))) then
                v24[i] = v;
            end;
        end;
    end;

    if p21 and p21 > 0 then
        v24.EvenOffsetIdx_Pos = p20;
        v24.EvenOffsetN_Pos = p21;
    end;

    if p23 and p23 > 0 then
        v24.EvenOffsetIdx_Rot = p22;
        v24.EvenOffsetN_Rot = p23;
    end;

    return v24;
end;

function u1.descendCtx(p25) -- Line: 107
    if p25 then
        return (p25.EventOriginCF ~= nil or (p25.IgnoreLink ~= nil or (p25.UseFullOrigin ~= nil or p25.EventOriginResolver ~= nil))) and {
            ChainCtx = p25.ChainCtx,
            EmitIndex = p25.EmitIndex,
            EmitCount = p25.EmitCount
        } or p25;
    end;

    return nil;
end;

local success = pcall(function() -- Line: 124
    return Instance.new("ModuleScript").Source;
end);

function u1._compile(p26) -- Line: 126
    -- upvalues: success (copy)
    if not success then
        local success2, result = pcall(require, p26);

        if not success2 then
            return nil, result;
        end;

        if type(result) == "function" then
            return result, nil, nil;
        end;

        return nil, "module must return function(payload)";
    end;

    local v27 = p26:Clone();
    v27.Name = "_CompiledEventModule";
    v27.Archivable = false;
    v27.Parent = p26.Parent;
    local success2, result = pcall(require, v27);

    if not success2 then
        v27:Destroy();

        return nil, result;
    end;

    if type(result) == "function" then
        return result, nil, v27;
    end;

    v27:Destroy();

    return nil, "module must return function(payload)";
end;

function u1._isCacheValid(p28, p29) -- Line: 148
    if not (p28 and (p29 and p29:IsA("ModuleScript"))) then
        return false;
    end;

    if p29.Name ~= "Module" then
        return false;
    end;

    local expectedEventCfg = p28.expectedEventCfg;

    if not (expectedEventCfg and expectedEventCfg.Parent) then
        return false;
    end;

    if expectedEventCfg.Name ~= p28.expectedEventName then
        return false;
    end;

    if expectedEventCfg.Parent and expectedEventCfg.Parent.Name == "Events" then
        return p29.Parent == expectedEventCfg;
    end;

    return false;
end;

function u1._invalidate(p30) -- Line: 159
    -- upvalues: u2 (copy)
    local u31 = u2[p30];

    if not u31 then
        return;
    end;

    if u31.sourceConn then
        u31.sourceConn:Disconnect();
        u31.sourceConn = nil;
    end;

    if u31.ancestryConn then
        u31.ancestryConn:Disconnect();
        u31.ancestryConn = nil;
    end;

    if u31.nameConn then
        u31.nameConn:Disconnect();
        u31.nameConn = nil;
    end;

    if u31.compiledClone then
        pcall(function() -- Line: 166
            -- upvalues: u31 (copy)
            u31.compiledClone:Destroy();
        end);
        u31.compiledClone = nil;
    end;

    u2[p30] = nil;
end;

function u1.compile(u32) -- Line: 173
    -- upvalues: u2 (copy), u1 (copy), success (copy)
    if not (u32 and u32:IsA("ModuleScript")) then
        return nil;
    end;

    local v33 = u2[u32];

    if v33 and (not v33.dirty and u1._isCacheValid(v33, u32)) then
        return v33.fn;
    end;

    if v33 then
        u1._invalidate(u32);
    end;

    local v34, v35, v36 = u1._compile(u32);

    if not v34 then
        u1.reportScriptError(u32, v35);

        return nil;
    end;

    local Parent = u32.Parent;

    if not (Parent and Parent:IsA("Configuration")) then
        v36:Destroy();

        return nil;
    end;

    local v37 = {
        dirty = false,
        fn = v34,
        expectedEventCfg = Parent,
        expectedEventName = Parent.Name,
        compiledClone = v36
    };

    if success then
        v37.sourceConn = u32:GetPropertyChangedSignal("Source"):Connect(function() -- Line: 204
            -- upvalues: u2 (ref), u32 (copy)
            if u2[u32] then
                u2[u32].dirty = true;
            end;
        end);
    end;

    v37.ancestryConn = u32.AncestryChanged:Connect(function() -- Line: 209
        -- upvalues: u1 (ref), u2 (ref), u32 (copy)
        if not u1._isCacheValid(u2[u32], u32) then
            u1._invalidate(u32);
        end;
    end);
    v37.nameConn = u32:GetPropertyChangedSignal("Name"):Connect(function() -- Line: 216
        -- upvalues: u32 (copy)
        if u32.Name ~= "Module" then
            pcall(function() -- Line: 218
                -- upvalues: u32 (ref)
                u32.Name = "Module";
            end);
        end;
    end);
    u2[u32] = v37;

    return v34;
end;

function u1.cleanup() -- Line: 225
    -- upvalues: u2 (copy), u1 (copy), u5 (ref), u4 (ref), u3 (ref), u6 (copy), u7 (copy)
    local v38 = {};

    for i in pairs(u2) do
        table.insert(v38, i);
    end;

    for _, v in ipairs(v38) do
        u1._invalidate(v);
    end;

    u5 = u5 + 1;
    u1._frameCount = 0;
    u1._burstDropped = 0;
    u1._burstReportPending = false;
    u4 = 0;
    u3 = false;
    table.clear(u6);
    table.clear(u7);
end;

function u1._reportBurst() -- Line: 244
    -- upvalues: u1 (copy), u5 (ref)
    local v39 = u1;
    v39._burstDropped = v39._burstDropped + 1;

    if not u1._burstReportPending then
        u1._burstReportPending = true;
        local u40 = u5;
        task.delay(1, function() -- Line: 249
            -- upvalues: u40 (copy), u5 (ref), u1 (ref)
            if u40 ~= u5 then
                return;
            end;

            if u1._burstDropped > 0 then
                warn(("[Part-Icles Events] dropped %d event fires this second."):format(u1._burstDropped));
            end;

            u1._burstDropped = 0;
            u1._burstReportPending = false;
        end);
    end;
end;

function u1.reserveFrameFire() -- Line: 260
    -- upvalues: u1 (copy)
    if u1._frameCount >= 256 then
        u1._reportBurst();

        return false;
    end;

    local v41 = u1;
    v41._frameCount = v41._frameCount + 1;

    return true;
end;

function u1.tickFrame() -- Line: 270
    -- upvalues: u1 (copy)
    u1._frameCount = 0;
end;

function u1.dropDepth(u42) -- Line: 274
    -- upvalues: u4 (ref), u3 (ref), u5 (ref)
    u4 = u4 + 1;

    if not u3 then
        u3 = true;
        local u43 = u5;
        task.delay(1, function() -- Line: 279
            -- upvalues: u43 (copy), u5 (ref), u4 (ref), u42 (copy), u3 (ref)
            if u43 ~= u5 then
                return;
            end;

            if u4 > 0 then
                warn(("[Part-Icles Events] dropped %d event fire(s) this second (chain depth limit reached%s)."):format(u4, u42 and " on " .. u42 or ""));
            end;

            u4 = 0;
            u3 = false;
        end);
    end;
end;

function u1.reportScriptError(p44, p45) -- Line: 291
    local v46 = p44 and p44:GetFullName() or "<destroyed>";
    warn(("[Part-Icles Events] %s\n  %s"):format(v46, (tostring(p45))));
end;

function u1.getWorldCF(p47) -- Line: 297
    local VisualPart = p47.VisualPart;

    if not (VisualPart and VisualPart.Parent) then
        return nil;
    end;

    if VisualPart:IsA("BasePart") then
        return VisualPart.CFrame;
    end;

    if VisualPart:IsA("Attachment") then
        return VisualPart.WorldCFrame;
    end;

    if VisualPart:IsA("Model") then
        return VisualPart:GetPivot();
    end;

    if VisualPart:IsA("PointLight") then
        local Parent = VisualPart.Parent;

        if Parent and Parent:IsA("BasePart") then
            return Parent.CFrame;
        end;

        if Parent and Parent:IsA("Attachment") then
            return Parent.WorldCFrame;
        end;

        return nil;
    end;

    if not VisualPart:IsA("Beam") then
        return nil;
    end;

    local Attachment0 = VisualPart.Attachment0;

    if not Attachment0 then
        return nil;
    end;

    local Attachment1 = VisualPart.Attachment1;

    if Attachment1 then
        return CFrame.new((Attachment0.WorldPosition + Attachment1.WorldPosition) * 0.5);
    end;

    return CFrame.new(Attachment0.WorldPosition);
end;

function u1.getWorldPosition(p48) -- Line: 321
    -- upvalues: u1 (copy)
    local v49 = u1.getWorldCF(p48);

    return v49 and v49.Position or nil;
end;

function u1.getSourceWorldCF(p50) -- Line: 326
    if not (p50 and p50.Parent) then
        return nil;
    end;

    if p50:IsA("BasePart") then
        return p50.CFrame;
    end;

    if p50:IsA("Attachment") then
        return p50.WorldCFrame;
    end;

    if p50:IsA("Model") then
        return p50:GetPivot();
    end;

    if p50:IsA("Beam") then
        local Attachment0 = p50.Attachment0;

        if not Attachment0 then
            return nil;
        end;

        local Attachment1 = p50.Attachment1;

        if Attachment1 then
            return CFrame.new((Attachment0.WorldPosition + Attachment1.WorldPosition) * 0.5);
        end;

        return CFrame.new(Attachment0.WorldPosition);
    end;

    if not p50:IsA("PointLight") then
        return nil;
    end;

    local Parent = p50.Parent;

    if Parent and Parent:IsA("BasePart") then
        return Parent.CFrame;
    end;

    if Parent and Parent:IsA("Attachment") then
        return Parent.WorldCFrame;
    end;

    return nil;
end;

function u1.makeHitParams(p51) -- Line: 355
    -- upvalues: EventsSchema (copy)
    local u52 = RaycastParams.new();
    u52.FilterType = Enum.RaycastFilterType.Exclude;
    local v53 = {};

    if p51.VisualPart then
        table.insert(v53, p51.VisualPart);
    end;

    if p51._sourceItem then
        table.insert(v53, p51._sourceItem);
    end;

    if p51._sourceItem then
        local RenderTemplate = p51._sourceItem:FindFirstChild("RenderTemplate");

        if RenderTemplate then
            table.insert(v53, RenderTemplate);
        end;

        local EmitParent = p51._sourceItem:FindFirstChild("EmitParent");

        if EmitParent and (EmitParent:IsA("ObjectValue") and EmitParent.Value) then
            table.insert(v53, EmitParent.Value);
        end;
    end;

    if p51.VisualPart and (p51.VisualPart:IsA("Attachment") and p51.VisualPart.Parent) then
        table.insert(v53, p51.VisualPart.Parent);
    end;

    if p51._sourceItem then
        local v54 = EventsSchema.readEvent(p51._sourceItem, "OnHit");

        if v54 then
            local u55 = v54:GetAttribute("CollisionGroup");

            if type(u55) == "string" and u55 ~= "" then
                pcall(function() -- Line: 386
                    -- upvalues: u52 (copy), u55 (copy)
                    u52.CollisionGroup = u55;
                end);
            end;

            local ExcludeList = v54:FindFirstChild("ExcludeList");

            if ExcludeList then
                for _, child in ipairs(ExcludeList:GetChildren()) do
                    if child:IsA("ObjectValue") and child.Value then
                        table.insert(v53, child.Value);
                    end;
                end;
            end;
        end;
    end;

    u52.FilterDescendantsInstances = v53;
    u52.IgnoreWater = true;

    return u52;
end;

function u1.makePayload(p56, p57, p58, p59) -- Line: 404
    -- upvalues: EventsPayload (copy), u1 (copy)
    return EventsPayload.build(p57, p58, p59, u1.getWorldCF(p57));
end;

function u1.resolveEmitModeCF(p60, p61, p62) -- Line: 417
    -- upvalues: u1 (copy)
    if p60 == "AtPosition" then
        if p61 and p61._eventName == "OnEmit" then
            local v63 = u1.getWorldCF(p62);

            if v63 then
                return v63;
            end;

            if p62.CurrentPosition then
                return CFrame.new(p62.CurrentPosition);
            end;
        end;

        local v64 = p61.HitPosition or (p61.DeathPosition or p61.EmitPosition);

        if v64 and (p61._eventName == "OnHit" and p61.HitNormal) then
            v64 = v64 + p61.HitNormal * 0.1;
        end;

        return v64 and CFrame.new(v64) or nil;
    end;

    if p60 == "AtSource" then
        return u1.getSourceWorldCF(p62._sourceItem);
    end;

    if p60 ~= "AtCFrame" then
        return nil;
    end;

    local v65 = p61 and p61._eventName == "OnEmit" and u1.getWorldCF(p62);

    if v65 then
        return v65;
    end;

    local v66;

    if p61 then
        v66 = p61.WorldCFrame;
    else
        v66 = p61;
    end;

    if v66 and (p61._eventName == "OnHit" and p61.HitNormal) then
        v66 = v66 + p61.HitNormal * 0.1;
    end;

    return v66 or nil;
end;

function u1._supportsOriginOverride(p67) -- Line: 446
    return p67:IsA("BasePart") or (p67:IsA("Attachment") or p67:IsA("Model"));
end;

local function _newHolderPart() -- Line: 452
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0.001, 0.001, 0.001);
    Part.Archivable = false;

    return Part;
end;

local function _anchorClone(p68) -- Line: 466
    if p68:IsA("BasePart") then
        p68.Anchored = true;
    end;

    for _, descendant in ipairs(p68:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
        end;
    end;
end;

local function _positionClone(p69, p70) -- Line: 475
    if p69:IsA("Model") then
        p69:PivotTo(p70);

        return;
    end;

    if p69:IsA("BasePart") then
        p69.CFrame = p70;

        return;
    end;

    if p69:IsA("Attachment") then
        p69.WorldCFrame = p70;
    end;
end;

local function _getAttachmentHolder(p71) -- Line: 488
    local v72 = p71:GetFolder();
    local _AttachmentHolder = v72:FindFirstChild("_AttachmentHolder");

    if _AttachmentHolder then
        return _AttachmentHolder;
    end;

    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0.001, 0.001, 0.001);
    Part.Archivable = false;
    Part.Name = "_AttachmentHolder";
    Part.CFrame = CFrame.new();
    Part.Parent = v72;

    return Part;
end;

local function _stampAuthoredEnabled(u73) -- Line: 504
    local function visit(u74) -- Line: 505
        if u74:IsA("ParticleEmitter") or u74:IsA("Trail") then
            pcall(function() -- Line: 507
                -- upvalues: u74 (copy)
                u74:SetAttribute("_PartIcleAuthoredEnabled", u74.Enabled);
            end);
        end;
    end;

    if u73:IsA("ParticleEmitter") or u73:IsA("Trail") then
        pcall(function() -- Line: 507
            -- upvalues: u73 (copy)
            u73:SetAttribute("_PartIcleAuthoredEnabled", u73.Enabled);
        end);
    end;

    for _, descendant in ipairs(u73:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            pcall(function() -- Line: 507
                -- upvalues: descendant (copy)
                descendant:SetAttribute("_PartIcleAuthoredEnabled", descendant.Enabled);
            end);
        end;
    end;
end;

local function _restoreAuthoredEnabled(p75) -- Line: 516
    local function v78(u76) -- Line: 517
        if u76:IsA("ParticleEmitter") or u76:IsA("Trail") then
            local u77 = u76:GetAttribute("_PartIcleAuthoredEnabled");
            pcall(function() -- Line: 520
                -- upvalues: u76 (copy), u77 (copy)
                u76.Enabled = u77 == true;
            end);
        end;
    end;

    v78(p75);

    for _, descendant in ipairs(p75:GetDescendants()) do
        v78(descendant);
    end;
end;

local function _killEmittersForRelease(u79) -- Line: 530
    local function _(u80) -- Line: 531
        if u80:IsA("ParticleEmitter") or u80:IsA("Trail") then
            pcall(function() -- Line: 533
                -- upvalues: u80 (copy)
                u80.Enabled = false;
            end);
        end;
    end;

    if u79:IsA("ParticleEmitter") or u79:IsA("Trail") then
        pcall(function() -- Line: 533
            -- upvalues: u79 (copy)
            u79.Enabled = false;
        end);
    end;

    for _, descendant in ipairs(u79:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            pcall(function() -- Line: 533
                -- upvalues: descendant (copy)
                descendant.Enabled = false;
            end);
        end;
    end;
end;

local function _kindFor(p81) -- Line: 543
    return p81:IsA("BasePart") and "Part" or (p81:IsA("Model") and "Model" or (p81:IsA("Folder") and "Model" or (p81:IsA("Attachment") and "Attachment" or (p81:IsA("ParticleEmitter") and "Part" or "Part"))));
end;

local function _computeCloneLifetime(p82) -- Line: 554
    local u83 = 2;

    local function v92(u84) -- Line: 556
        -- upvalues: u83 (ref)
        if not u84:IsA("ParticleEmitter") then
            if u84:IsA("Trail") then
                local v85 = tonumber(u84:GetAttribute("EmitDuration")) or 0;
                local u86 = 2;
                pcall(function() -- Line: 567
                    -- upvalues: u86 (ref), u84 (copy)
                    u86 = math.max(u86, u84.Lifetime);
                end);
                local v87 = v85 + u86 + 0.5;

                if u83 < v87 then
                    u83 = v87;
                end;
            end;

            return;
        end;

        local v88 = tonumber(u84:GetAttribute("EmitDelay")) or 0;
        local v89 = tonumber(u84:GetAttribute("EmitDuration")) or 0;
        local u90 = 2;
        pcall(function() -- Line: 561
            -- upvalues: u90 (ref), u84 (copy)
            u90 = math.max(u90, u84.Lifetime.Max);
        end);
        local v91 = v88 + v89 + u90 + 0.5;

        if u83 < v91 then
            u83 = v91;
        end;
    end;

    v92(p82);

    for _, descendant in ipairs(p82:GetDescendants()) do
        v92(descendant);
    end;

    return u83 > 600 and 600 or u83;
end;

local function _buildEmitClone(u93) -- Line: 591
    -- upvalues: _stampAuthoredEnabled (copy)
    local u94 = nil;

    if u93:IsA("BasePart") then
        u94 = u93:Clone();
        u94.Archivable = false;
    elseif u93:IsA("Model") then
        u94 = u93:Clone();
        u94.Archivable = false;
    elseif u93:IsA("Folder") then
        u94 = Instance.new("Model");
        u94.Archivable = false;
        local v95 = u93:Clone();
        v95.Archivable = false;
        v95.Parent = u94;

        for _, descendant in ipairs(v95:GetDescendants()) do
            if descendant:IsA("BasePart") and not descendant:GetAttribute("_isAnchor") then
                u94.WorldPivot = CFrame.new(descendant.Position);
                break;
            end;
        end;
    elseif u93:IsA("Attachment") then
        u94 = u93:Clone();
    elseif u93:IsA("ParticleEmitter") then
        u94 = Instance.new("Part");
        u94.Anchored = true;
        u94.CanCollide = false;
        u94.CanQuery = false;
        u94.CanTouch = false;
        u94.Massless = true;
        u94.Transparency = 1;
        u94.Size = Vector3.new(0.001, 0.001, 0.001);
        u94.Archivable = false;

        if u93.Parent and u93.Parent:IsA("BasePart") then
            pcall(function() -- Line: 630
                -- upvalues: u94 (copy), u93 (copy)
                u94.Size = u93.Parent.Size;
            end);
        end;

        u93:Clone().Parent = u94;
    end;

    if u94 then
        _stampAuthoredEnabled(u94);
        pcall(function() -- Line: 641
            -- upvalues: u94 (ref)
            u94:SetAttribute("_PartIcleEmit", true);
        end);
    end;

    return u94;
end;

function u1._emitTransformed(p96, p97, u98, u99, u100, p101, p102) -- Line: 650
    -- upvalues: u1 (copy), u6 (copy), u7 (copy)
    local v103 = p101 or u1.newChainCtx();
    local v104 = v103.Depth + 1;

    if (p102 or 4) <= v104 then
        if u99 then
            u99 = u99._eventName;
        end;

        u1.dropDepth(u99);

        return;
    end;

    local v105 = {
        ChainId = v103.ChainId,
        Depth = v104
    };
    local v106 = {
        ChainCtx = v105
    };

    if u98 == "AtTarget" then
        p96:EnableEmit(p97, nil, v106);

        return;
    end;

    if not u1._supportsOriginOverride(p97) then
        local v107 = tostring(u98) .. ":" .. p97.ClassName;

        if not u6[v107] then
            u6[v107] = true;
            warn(("[Part-Icles Events] transformed %s target requires EmitMode=AtTarget"):format(p97.ClassName));
        end;

        return;
    end;

    local u108 = u1.resolveEmitModeCF(u98, u99, u100);

    if u108 then
        if p96.EnableEmitAt then
            p96:EnableEmitAt(p97, u108, {
                IgnoreLink = true,
                ChainCtx = v105,

                OriginResolver = function() -- Line: 690, Name: originResolver
                    -- upvalues: u1 (ref), u98 (copy), u99 (copy), u100 (copy), u108 (copy)
                    return u1.resolveEmitModeCF(u98, u99, u100) or u108;
                end,

                UseFullOrigin = u98 == "AtCFrame"
            });

            return;
        end;

        warn("[Part-Icles Events] EnableEmitAt missing on particle; skipped origin-override emit");

        return;
    end;

    local v109 = tostring(u98);

    if u99 then
        u99 = u99._eventName;
    end;

    local v110 = v109 .. ":" .. tostring(u99);

    if not u7[v110] then
        u7[v110] = true;
        warn(("[Part-Icles Events] EmitMode %q has no resolvable origin (payload position nil)"):format((tostring(u98))));
    end;
end;

function u1.emitTargetInstance(u111, u112, p113, p114, p115, u116, p117) -- Line: 711
    -- upvalues: u1 (copy), _kindFor (copy), Pool (copy), _buildEmitClone (copy), _restoreAuthoredEnabled (copy), _anchorClone (copy), _computeCloneLifetime (copy), _killEmittersForRelease (copy)
    if not (u112 and u112.Parent) then
        return;
    end;

    if p113 == nil or (p113 == "AtTarget" or u112:IsA("Trail")) then
        if u112:GetAttribute("Transformed") then
            u1._emitTransformed(u111, u112, p113, p114, p115, u116, p117);

            return;
        end;

        pcall(function() -- Line: 718
            -- upvalues: u111 (copy), u112 (copy), u116 (copy)
            u111:AbsoluteEmit(u112, false, {
                ChainCtx = u116
            });
        end);

        return;
    end;

    if u112:GetAttribute("Transformed") then
        u1._emitTransformed(u111, u112, p113, p114, p115, u116, p117);

        return;
    end;

    local u118 = u1.resolveEmitModeCF(p113, p114, p115);

    if not u118 then
        pcall(function() -- Line: 730
            -- upvalues: u111 (copy), u112 (copy), u116 (copy)
            u111:AbsoluteEmit(u112, false, {
                ChainCtx = u116
            });
        end);

        return;
    end;

    local u119 = _kindFor(u112);
    local u120 = Pool.acquire(u112, u119);
    local v121;

    if u120 then
        v121 = false;
    else
        u120 = _buildEmitClone(u112);

        if not u120 then
            pcall(function() -- Line: 741
                -- upvalues: u111 (copy), u112 (copy), u116 (copy)
                u111:AbsoluteEmit(u112, false, {
                    ChainCtx = u116
                });
            end);

            return;
        end;

        v121 = true;
    end;

    if not v121 then
        _restoreAuthoredEnabled(u120);
    end;

    if u120:IsA("Attachment") then
        local v122 = u111:GetFolder();
        local _AttachmentHolder = v122:FindFirstChild("_AttachmentHolder");

        if not _AttachmentHolder then
            _AttachmentHolder = Instance.new("Part");
            _AttachmentHolder.Anchored = true;
            _AttachmentHolder.CanCollide = false;
            _AttachmentHolder.CanQuery = false;
            _AttachmentHolder.CanTouch = false;
            _AttachmentHolder.Massless = true;
            _AttachmentHolder.Transparency = 1;
            _AttachmentHolder.Size = Vector3.new(0.001, 0.001, 0.001);
            _AttachmentHolder.Archivable = false;
            _AttachmentHolder.Name = "_AttachmentHolder";
            _AttachmentHolder.CFrame = CFrame.new();
            _AttachmentHolder.Parent = v122;
        end;

        u120.Parent = _AttachmentHolder;
        u120.WorldCFrame = u118;
    else
        _anchorClone(u120);
        local v123 = u120;

        if v123:IsA("Model") then
            v123:PivotTo(u118);
        elseif v123:IsA("BasePart") then
            v123.CFrame = u118;
        elseif v123:IsA("Attachment") then
            v123.WorldCFrame = u118;
        end;

        u120.Parent = u111:GetFolder();
        local v124 = u120;

        if v124:IsA("Model") then
            v124:PivotTo(u118);
        elseif v124:IsA("BasePart") then
            v124.CFrame = u118;
        elseif v124:IsA("Attachment") then
            v124.WorldCFrame = u118;
        end;
    end;

    local u125 = {
        SkipClone = true,
        ChainCtx = u116,
        UseFullOrigin = p113 == "AtCFrame",
        IgnoreLink = p113 == "AtPosition" and true or p113 == "AtCFrame"
    };
    pcall(function() -- Line: 780
        -- upvalues: u111 (copy), u120 (ref), u118 (copy), u125 (copy)
        u111:AbsoluteEmitAt(u120, u118, u125);
    end);
    local v126 = _computeCloneLifetime(u120);
    task.delay(v126, function() -- Line: 785
        -- upvalues: u120 (ref), _killEmittersForRelease (ref), Pool (ref), u112 (copy), u119 (copy)
        if not u120.Parent then
            return;
        end;

        _killEmittersForRelease(u120);
        Pool.release(u120, u112, u119, nil);
    end);
end;

function u1.fire(u127, u128, p129, p130, p131) -- Line: 794
    -- upvalues: u1 (copy), EventsPayload (copy)
    local u132 = p130 or u1.newChainCtx();
    local u133 = u128.Events and u128.Events[p129];

    if not (u133 and u133.Enabled) then
        return;
    end;

    local v134 = tonumber(u133.ChainDepthLimit) or 4;
    local v135 = math.floor(v134);
    local u136 = math.clamp(v135, 1, 32);

    if u136 <= u132.Depth then
        u1.dropDepth(p129);

        return;
    end;

    if not (u133.EmitTarget or u133.Module) then
        return;
    end;

    local u137 = p131 or u1.makePayload(u127, u128, p129, nil);
    u137._eventName = u137._eventName or p129;

    if not u1.reserveFrameFire() then
        return;
    end;

    u137.Source = u137.Source or u128._sourceItem;
    u137.Particle = u137.Particle or u128.VisualPart;
    u137.RenderTemplate = u137.RenderTemplate or u137.Particle;

    if u133.Module then
        function u137.Emit(p138, p139) -- Line: 825
            -- upvalues: u1 (ref), u127 (copy), u133 (copy), u137 (ref), u128 (copy), u132 (ref), u136 (copy)
            u1.emitTargetInstance(u127, p138, p139 or u133.EmitMode, u137, u128, u132, u136);
        end;

        function u137.Kill() -- Line: 828
            -- upvalues: u127 (copy), u128 (copy)
            if u127._killParticle then
                u127:_killParticle(u128, {
                    fireOnDeath = false
                });
            end;
        end;

        EventsPayload.attachSkipSetters(u137, u128);

        function u137.SetColor(p140) -- Line: 835
            -- upvalues: EventsPayload (ref), u128 (copy)
            EventsPayload.applyColor(u128, p140);
        end;

        function u137.SetTransparency(p141) -- Line: 836
            -- upvalues: EventsPayload (ref), u128 (copy)
            EventsPayload.applyTransparency(u128, p141);
        end;

        function u137.Teleport(p142) -- Line: 837
            -- upvalues: EventsPayload (ref), u128 (copy)
            EventsPayload.applyTeleport(u128, p142);
        end;

        EventsPayload.attachAdvancedSetters(u137, u128);

        function u137.SetSpeedMultiplier(p143) -- Line: 839
            -- upvalues: u128 (copy)
            if type(p143) == "number" then
                u128.SpeedMultiplier = p143;
            end;
        end;

        function u137.SetLifetime(p144) -- Line: 844
            -- upvalues: u128 (copy)
            if type(p144) == "number" then
                u128.LifeTime = math.max(0.001, p144);
            end;
        end;
    end;

    if u133.EmitTarget and #u127.ActiveEmits + (u127._lingerVisualCount or 0) < (u127.MAX_ACTIVE_PARTICLES or 1000) then
        u1.emitTargetInstance(u127, u133.EmitTarget, u133.EmitMode, u137, u128, u132, u136);
    end;

    local u145 = u133.Module and u1.compile(u133.Module);

    if u145 then
        task.spawn(function() -- Line: 859
            -- upvalues: u145 (copy), u137 (ref), u1 (ref), u133 (copy)
            local v146, v147 = xpcall(u145, debug.traceback, u137);

            if not v146 then
                u1.reportScriptError(u133.Module, v147);
            end;
        end);
    end;
end;

function u1.afterUpdate(p148, p149, p150, p151) -- Line: 874
    -- upvalues: u1 (copy), EventsCollision (copy)
    if not (p149.Events and p149.Events.OnHit) then
        return;
    end;

    if p149._lastEffectiveDt and p149._lastEffectiveDt < 0 then
        p149.LastHitCheckPos = u1.getWorldPosition(p149);
        p149.LastHitCheckTime = p151;

        return;
    end;

    local v152 = u1.getWorldPosition(p149);

    if not v152 then
        return;
    end;

    if not p149.LastHitCheckPos then
        p149.LastHitCheckPos = v152;
        p149.LastHitCheckTime = p151;

        return;
    end;

    local v153 = p149.Events.OnHit.HitCheckInterval or 0;

    if v153 > 0 and p151 - (p149.LastHitCheckTime or 0) < v153 then
        return;
    end;

    local LastHitCheckPos = p149.LastHitCheckPos;
    local v154 = p151 - (p149.LastHitCheckTime or p151);
    local v155 = v154 <= 0 and 0.016666666666666666 or v154;
    local v156 = v152 - LastHitCheckPos;

    if v156.Magnitude > 0.05 then
        local v157 = workspace:Raycast(LastHitCheckPos, v156, p149.HitParams);

        if v157 then
            if not p149._hitFired then
                local v158 = u1.makePayload(p148, p149, "OnHit", nil);
                v158.HitInstance = v157.Instance;
                v158.Other = v157.Instance;
                v158.HitPosition = v157.Position;
                v158.HitNormal = v157.Normal;
                u1.fire(p148, p149, "OnHit", p149.EventChainCtx, v158);

                if EventsCollision.handle(p148, p149, v157, v156, v155) == "snap" then
                    return;
                end;
            end;
        elseif not p149._collisionStopped then
            p149._hitFired = false;
        end;

        p149.LastHitCheckPos = v152;
        p149.LastHitCheckTime = p151;
    end;
end;

return u1;