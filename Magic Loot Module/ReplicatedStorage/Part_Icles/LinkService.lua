-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local PartConstants = require(script.Parent.PartConstants);
local u1 = RunService:IsClient() and RunService.PreRender or RunService.Heartbeat;
local v2 = {
    _active = false,
    _connection = nil,
    _links = {},
    _anchorSnapshot = {},
    _warnedNotActive = false
};
local u3 = {
    Weld = true,
    Follow = true,
    Pivot = true,
    WeldWithoutRotation = true
};

local function _readPart1CF(p4) -- Line: 45
    if p4:IsA("Model") then
        local success, result = pcall(p4.GetPivot, p4);

        return success and result and result or CFrame.new();
    end;

    if p4:IsA("Attachment") then
        return p4.WorldCFrame;
    end;

    return p4.CFrame;
end;

local function _classifyPart1(p5) -- Line: 55
    return p5:IsA("Model") and "Model" or (p5:IsA("Attachment") and "Attachment" or "Part");
end;

function v2._captureAndAnchor(p6, p7) -- Line: 64
    if p7:IsA("BasePart") then
        local Anchored = p7.Anchored;
        p7.Anchored = true;

        return Anchored;
    end;

    if not p7:IsA("Model") then
        return nil;
    end;

    local v8 = {};

    for _, descendant in ipairs(p7:GetDescendants()) do
        if descendant:IsA("BasePart") then
            v8[descendant] = descendant.Anchored;
            descendant.Anchored = true;
        end;
    end;

    return v8;
end;

function v2._restoreAnchor(p9, p10) -- Line: 83
    local v11 = p9._anchorSnapshot[p10];
    p9._anchorSnapshot[p10] = nil;

    if v11 == nil then
        return;
    end;

    if p10:IsA("BasePart") and p10.Parent then
        p10.Anchored = v11;

        return;
    end;

    if p10:IsA("Model") and type(v11) == "table" then
        for i, v in pairs(v11) do
            if i.Parent then
                i.Anchored = v;
            end;
        end;
    end;
end;

function v2.Activate(u12) -- Line: 99
    -- upvalues: u1 (copy)
    if u12._active then
        return;
    end;

    u12._active = true;
    u12._connection = u1:Connect(function(p13) -- Line: 102
        -- upvalues: u12 (copy)
        u12:_tick(p13);
    end);
end;

function v2.Deactivate(p14) -- Line: 108
    if not p14._active then
        return;
    end;

    p14._active = false;

    if p14._connection then
        p14._connection:Disconnect();
        p14._connection = nil;
    end;

    for i in pairs(p14._links) do
        p14._links[i] = nil;
        p14:_restoreAnchor(i);
    end;
end;

function v2.Link(p15, p16, p17, p18, p19) -- Line: 125
    -- upvalues: u3 (copy), PartConstants (copy)
    if not (p16 and p17) then
        return;
    end;

    if p16 == p17 then
        return;
    end;

    if not (p16:IsA("BasePart") or (p16:IsA("Model") or p16:IsA("Attachment"))) then
        return;
    end;

    if not (p16.Parent and p17.Parent) then
        return;
    end;

    local v20 = not u3[p18] and "Weld" or p18;

    if not (p15._active or p15._warnedNotActive) then
        p15._warnedNotActive = true;
        warn("[Part-Icles LinkService] Link called before Activate(); the link won\'t update until you call LinkService:Activate(). This warning fires once.");
    end;

    local v21 = PartConstants.resolveLinkCFrame(p17);
    local v22;

    if p16:IsA("Model") then
        local success, result = pcall(p16.GetPivot, p16);
        v22 = success and result and result or CFrame.new();
    elseif p16:IsA("Attachment") then
        v22 = p16.WorldCFrame;
    else
        v22 = p16.CFrame;
    end;

    if p15._anchorSnapshot[p16] == nil and not p15._links[p16] then
        p15._anchorSnapshot[p16] = p15:_captureAndAnchor(p16);
    else
        p15:_captureAndAnchor(p16);
    end;

    p15._links[p16] = {
        target = p17,
        mode = v20,
        offsetCF = v21:ToObjectSpace(v22),
        rotation = v22.Rotation,
        expiresAt = p19 and os.clock() + p19 or nil,
        partKind = p16:IsA("Model") and "Model" or (p16:IsA("Attachment") and "Attachment" or "Part")
    };
end;

function v2.Clear(p23, p24) -- Line: 159
    if not p23._links[p24] then
        return;
    end;

    p23._links[p24] = nil;
    p23:_restoreAnchor(p24);
end;

function v2.IsLinked(p25, p26) -- Line: 166
    return p25._links[p26] ~= nil;
end;

function v2._tick(p27, p28) -- Line: 170
    -- upvalues: PartConstants (copy)
    local v29 = os.clock();

    for i, v in pairs(p27._links) do
        if i.Parent and v.target.Parent then
            if v.expiresAt and v.expiresAt <= v29 then
                p27:Clear(i);
            else
                local v30 = PartConstants.resolveLinkCFrame(v.target);
                local u31;

                if v.mode == "Weld" then
                    u31 = v30 * v.offsetCF;
                else
                    u31 = CFrame.new((v30 * v.offsetCF).Position) * v.rotation;
                end;

                if v.partKind == "Model" then
                    pcall(function() -- Line: 189
                        -- upvalues: i (copy), u31 (ref)
                        i:PivotTo(u31);
                    end);
                elseif v.partKind == "Attachment" then
                    local Parent = i.Parent;

                    if Parent and Parent:IsA("BasePart") then
                        i.CFrame = Parent.CFrame:ToObjectSpace(u31);
                    end;
                else
                    i.CFrame = u31;
                end;
            end;
        else
            p27:Clear(i);
        end;
    end;
end;

return v2;