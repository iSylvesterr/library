-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};

local function isCooldownActive(p4) -- Line: 24
    local v5 = p4:GetAttribute("CooldownEnd");

    if typeof(v5) == "number" and os.clock() < v5 then
        return true, v5;
    end;

    return false, nil;
end;

local function recordOriginal(p6, p7) -- Line: 32
    if p6.Originals[p7] == nil then
        p6.Originals[p7] = p7.Transparency;
    end;
end;

local function tweenPart(p8, p9, p10) -- Line: 38
    -- upvalues: TweenService (copy)
    TweenService:Create(p8, TweenInfo.new(p10, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Transparency = p9
    }):Play();
end;

local function applyCooldownVisual(p11, p12) -- Line: 43
    -- upvalues: tweenPart (copy)
    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("BasePart") then
            if p12.Originals[descendant] == nil then
                p12.Originals[descendant] = descendant.Transparency;
            end;

            tweenPart(descendant, 1, 0);
        end;
    end;
end;

local function restoreOriginals(p13) -- Line: 52
    -- upvalues: tweenPart (copy)
    for i, v in p13.Originals do
        if i.Parent then
            tweenPart(i, v, 0);
        end;
    end;
end;

local function endCooldown(p14) -- Line: 60
    -- upvalues: u2 (copy), restoreOriginals (copy)
    local v15 = u2[p14];

    if not (v15 and v15.Active) then
        return;
    end;

    v15.Active = false;

    if v15.ReleaseTask then
        v15.ReleaseTask = nil;
    end;

    restoreOriginals(v15);
end;

local function scheduleRelease(u16, p17) -- Line: 70
    -- upvalues: u2 (copy), scheduleRelease (copy), restoreOriginals (copy)
    local v18 = u2[u16];

    if not v18 then
        return;
    end;

    if v18.ReleaseTask then
        v18.ReleaseTask = nil;
    end;

    v18.ReleaseTask = task.delay(p17 - os.clock(), function() -- Line: 80
        -- upvalues: u16 (copy), scheduleRelease (ref), u2 (ref), restoreOriginals (ref)
        local v19 = u16:GetAttribute("CooldownEnd");

        if typeof(v19) == "number" and os.clock() < v19 then
            scheduleRelease(u16, v19);

            return;
        end;

        local v20 = u2[u16];

        if v20 then
            if not v20.Active then
                return;
            end;

            v20.Active = false;

            if v20.ReleaseTask then
                v20.ReleaseTask = nil;
            end;

            restoreOriginals(v20);
        end;
    end);
end;

local function startCooldown(p21, p22) -- Line: 91
    -- upvalues: u2 (copy), applyCooldownVisual (copy), scheduleRelease (copy)
    local v23 = u2[p21];

    if not v23 then
        return;
    end;

    applyCooldownVisual(p21, v23);
    v23.Active = true;
    scheduleRelease(p21, p22);
end;

local function disposeTracker(p24) -- Line: 100
    -- upvalues: u2 (copy)
    local v25 = u2[p24];

    if not v25 then
        return;
    end;

    if v25.AttributeConn then
        v25.AttributeConn:Disconnect();
    end;

    if v25.DescendantConn then
        v25.DescendantConn:Disconnect();
    end;

    if v25.AncestryConn then
        v25.AncestryConn:Disconnect();
    end;

    v25.ReleaseTask = nil;
    u2[p24] = nil;
end;

local function ensureTracker(u26) -- Line: 111
    -- upvalues: u2 (copy), applyCooldownVisual (copy), scheduleRelease (copy), restoreOriginals (copy), tweenPart (copy)
    local v27 = u2[u26];

    if v27 then
        return v27;
    end;

    local u28 = {
        Active = false,
        Originals = {}
    };
    u2[u26] = u28;
    u28.AttributeConn = u26:GetAttributeChangedSignal("CooldownEnd"):Connect(function() -- Line: 121
        -- upvalues: u26 (copy), u2 (ref), applyCooldownVisual (ref), scheduleRelease (ref), restoreOriginals (ref)
        local v29 = u26:GetAttribute("CooldownEnd");
        local v30;

        if typeof(v29) == "number" and os.clock() < v29 then
            v30 = true;
        else
            v30 = false;
            v29 = nil;
        end;

        if not (v30 and v29) then
            local v31 = u2[u26];

            if v31 then
                if not v31.Active then
                    return;
                end;

                v31.Active = false;

                if v31.ReleaseTask then
                    v31.ReleaseTask = nil;
                end;

                restoreOriginals(v31);
            end;

            return;
        end;

        local v32 = u26;
        local v33 = u2[v32];

        if not v33 then
            return;
        end;

        applyCooldownVisual(v32, v33);
        v33.Active = true;
        scheduleRelease(v32, v29);
    end);
    u28.DescendantConn = u26.DescendantAdded:Connect(function(p34) -- Line: 131
        -- upvalues: u28 (copy), tweenPart (ref)
        if not u28.Active then
            return;
        end;

        if not p34:IsA("BasePart") then
            return;
        end;

        local v35 = u28;

        if v35.Originals[p34] == nil then
            v35.Originals[p34] = p34.Transparency;
        end;

        tweenPart(p34, 1, 0);
    end);
    u28.AncestryConn = u26.AncestryChanged:Connect(function() -- Line: 138
        -- upvalues: u26 (copy), u2 (ref)
        if not u26:IsDescendantOf(game) then
            local v36 = u26;
            local v37 = u2[v36];

            if not v37 then
                return;
            end;

            if v37.AttributeConn then
                v37.AttributeConn:Disconnect();
            end;

            if v37.DescendantConn then
                v37.DescendantConn:Disconnect();
            end;

            if v37.AncestryConn then
                v37.AncestryConn:Disconnect();
            end;

            v37.ReleaseTask = nil;
            u2[v36] = nil;
        end;
    end);
    local v38 = u26:GetAttribute("CooldownEnd");
    local v39;

    if typeof(v38) == "number" and os.clock() < v38 then
        v39 = true;
    else
        v39 = false;
        v38 = nil;
    end;

    if v39 and v38 then
        local v40 = u2[u26];

        if not v40 then
            return u28;
        end;

        applyCooldownVisual(u26, v40);
        v40.Active = true;
        scheduleRelease(u26, v38);
    end;

    return u28;
end;

local function bindTool(u41) -- Line: 154
    -- upvalues: ensureTracker (copy), u3 (copy)
    if not u41:IsA("Tool") then
        return;
    end;

    if not u41:GetAttribute("Flashbang") then
        return;
    end;

    ensureTracker(u41);

    if not u3[u41] then
        u3[u41] = u41.Activated:Connect(function() -- Line: 161
            -- upvalues: u41 (copy)
            local v42 = u41:GetAttribute("CooldownEnd");

            if typeof(v42) == "number" and os.clock() < v42 then
                return;
            end;

            u41:SetAttribute("CooldownEnd", os.clock() + 15);
        end);
    end;
end;

local function watchContainer(p43) -- Line: 170
    -- upvalues: bindTool (copy)
    for _, child in p43:GetChildren() do
        if child:IsA("Tool") then
            bindTool(child);
        end;
    end;

    p43.ChildAdded:Connect(function(p44) -- Line: 176
        -- upvalues: bindTool (ref)
        if p44:IsA("Tool") then
            bindTool(p44);
        end;
    end);
end;

function v1.Init(p45) -- Line: 183
end;

function v1.Start(p46) -- Line: 185
    -- upvalues: LocalPlayer (copy), watchContainer (copy)
    watchContainer((LocalPlayer:WaitForChild("Backpack")));

    if LocalPlayer.Character then
        watchContainer(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p47) -- Line: 192
        -- upvalues: watchContainer (ref)
        watchContainer(p47);
    end);
end;

return v1;