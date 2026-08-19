-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Library.Types.AssetItem);
local ItemDisplay = require(ReplicatedStorage.Library.Modules.ItemDisplay);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
u1.__index = u1;

local function isHiddenByDefault(p2, p3) -- Line: 45
    while p2 ~= nil and p2 ~= p3 do
        if p2:IsA("GuiObject") and not p2.Visible then
            return true;
        end;

        p2 = p2.Parent;
    end;

    return false;
end;

local function addChannel(p4, p5, p6) -- Line: 57
    if p5 >= 1 then
        return;
    end;

    table.insert(p4, {
        Original = p5,
        Apply = p6
    });
end;

local function addTextLabelChannels(p7, u8) -- Line: 67
    local TextTransparency = u8.TextTransparency;

    local function v10(p9) -- Line: 68
        -- upvalues: u8 (copy)
        u8.TextTransparency = p9;
    end;

    if TextTransparency < 1 then
        table.insert(p7, {
            Original = TextTransparency,
            Apply = v10
        });
    end;

    local TextStrokeTransparency = u8.TextStrokeTransparency;

    local function v12(p11) -- Line: 71
        -- upvalues: u8 (copy)
        u8.TextStrokeTransparency = p11;
    end;

    if TextStrokeTransparency >= 1 then
        return;
    end;

    table.insert(p7, {
        Original = TextStrokeTransparency,
        Apply = v12
    });
end;

local function addTextButtonChannels(p13, u14) -- Line: 76
    local TextTransparency = u14.TextTransparency;

    local function v16(p15) -- Line: 77
        -- upvalues: u14 (copy)
        u14.TextTransparency = p15;
    end;

    if TextTransparency < 1 then
        table.insert(p13, {
            Original = TextTransparency,
            Apply = v16
        });
    end;

    local TextStrokeTransparency = u14.TextStrokeTransparency;

    local function v18(p17) -- Line: 80
        -- upvalues: u14 (copy)
        u14.TextStrokeTransparency = p17;
    end;

    if TextStrokeTransparency >= 1 then
        return;
    end;

    table.insert(p13, {
        Original = TextStrokeTransparency,
        Apply = v18
    });
end;

local function addTextBoxChannels(p19, u20) -- Line: 85
    local TextTransparency = u20.TextTransparency;

    local function v22(p21) -- Line: 86
        -- upvalues: u20 (copy)
        u20.TextTransparency = p21;
    end;

    if TextTransparency < 1 then
        table.insert(p19, {
            Original = TextTransparency,
            Apply = v22
        });
    end;

    local TextStrokeTransparency = u20.TextStrokeTransparency;

    local function v24(p23) -- Line: 89
        -- upvalues: u20 (copy)
        u20.TextStrokeTransparency = p23;
    end;

    if TextStrokeTransparency >= 1 then
        return;
    end;

    table.insert(p19, {
        Original = TextStrokeTransparency,
        Apply = v24
    });
end;

local function addImageLabelChannel(p25, u26) -- Line: 94
    local ImageTransparency = u26.ImageTransparency;

    local function v28(p27) -- Line: 95
        -- upvalues: u26 (copy)
        u26.ImageTransparency = p27;
    end;

    if ImageTransparency >= 1 then
        return;
    end;

    table.insert(p25, {
        Original = ImageTransparency,
        Apply = v28
    });
end;

local function addImageButtonChannel(p29, u30) -- Line: 100
    local ImageTransparency = u30.ImageTransparency;

    local function v32(p31) -- Line: 101
        -- upvalues: u30 (copy)
        u30.ImageTransparency = p31;
    end;

    if ImageTransparency >= 1 then
        return;
    end;

    table.insert(p29, {
        Original = ImageTransparency,
        Apply = v32
    });
end;

local function captureFadeChannels(p33) -- Line: 106
    -- upvalues: isHiddenByDefault (copy), addTextLabelChannels (copy), addTextButtonChannels (copy), addTextBoxChannels (copy)
    local v34 = {};

    for _, descendant in ipairs(p33:GetDescendants()) do
        if not isHiddenByDefault(descendant, p33) then
            if descendant:IsA("GuiObject") then
                local BackgroundTransparency = descendant.BackgroundTransparency;

                local function v36(p35) -- Line: 114
                    -- upvalues: descendant (copy)
                    descendant.BackgroundTransparency = p35;
                end;

                if BackgroundTransparency < 1 then
                    table.insert(v34, {
                        Original = BackgroundTransparency,
                        Apply = v36
                    });
                end;

                if descendant:IsA("TextLabel") then
                    addTextLabelChannels(v34, descendant);
                elseif descendant:IsA("TextButton") then
                    addTextButtonChannels(v34, descendant);
                elseif descendant:IsA("TextBox") then
                    addTextBoxChannels(v34, descendant);
                elseif descendant:IsA("ImageLabel") then
                    local ImageTransparency = descendant.ImageTransparency;

                    local function v38(p37) -- Line: 95
                        -- upvalues: descendant (copy)
                        descendant.ImageTransparency = p37;
                    end;

                    if ImageTransparency < 1 then
                        table.insert(v34, {
                            Original = ImageTransparency,
                            Apply = v38
                        });
                    end;
                elseif descendant:IsA("ImageButton") then
                    local ImageTransparency = descendant.ImageTransparency;

                    local function v40(p39) -- Line: 101
                        -- upvalues: descendant (copy)
                        descendant.ImageTransparency = p39;
                    end;

                    if ImageTransparency < 1 then
                        table.insert(v34, {
                            Original = ImageTransparency,
                            Apply = v40
                        });
                    end;
                end;

                if descendant:IsA("CanvasGroup") then
                    local GroupTransparency = descendant.GroupTransparency;

                    local function v42(p41) -- Line: 132
                        -- upvalues: descendant (copy)
                        descendant.GroupTransparency = p41;
                    end;

                    if GroupTransparency < 1 then
                        table.insert(v34, {
                            Original = GroupTransparency,
                            Apply = v42
                        });
                    end;
                end;
            elseif descendant:IsA("UIStroke") then
                local Transparency = descendant.Transparency;

                local function v44(p43) -- Line: 138
                    -- upvalues: descendant (copy)
                    descendant.Transparency = p43;
                end;

                if Transparency < 1 then
                    table.insert(v34, {
                        Original = Transparency,
                        Apply = v44
                    });
                end;
            end;
        end;
    end;

    return v34;
end;

local function resolveTransparency(p45, p46) -- Line: 147
    return 1 - p46 * (1 - p45);
end;

local function applyFadeAlpha(p47) -- Line: 151
    for _, v in ipairs(p47.Channels) do
        v.Apply(1 - p47.Alpha * (1 - v.Original));
    end;
end;

local function applyEntryTargetVisible(p48) -- Line: 158
    local v49 = p48.RangeVisible and p48.SuppressCount <= 0;
    p48.TargetVisible = v49;

    if v49 then
        p48.Billboard.Enabled = true;
    end;
end;

local function setEntryRangeVisible(p50, p51) -- Line: 166
    p50.RangeVisible = p51;
    local v52 = p50.RangeVisible and p50.SuppressCount <= 0;
    p50.TargetVisible = v52;

    if v52 then
        p50.Billboard.Enabled = true;
    end;
end;

local function stepEntryFade(p53, p54) -- Line: 171
    -- upvalues: applyFadeAlpha (copy)
    local v55 = p53.TargetVisible and 1 or 0;

    if p53.Alpha ~= v55 then
        local v56 = p54 / 0.2;

        if p53.Alpha < v55 then
            p53.Alpha = math.min(p53.Alpha + v56, v55);
        else
            p53.Alpha = math.max(p53.Alpha - v56, v55);
        end;

        applyFadeAlpha(p53);
    end;

    if p53.TargetVisible then
        p53.Billboard.Enabled = true;

        return;
    end;

    if p53.Alpha <= 0 then
        p53.Billboard.Enabled = false;
    end;
end;

function u1.new() -- Line: 194
    -- upvalues: u1 (copy), Trove (copy), RunService (copy), Players (copy), ItemDisplay (copy), stepEntryFade (copy)
    local u57 = setmetatable({}, u1);
    u57._trove = Trove.new();
    u57._entries = {};
    u57._elapsed = 0;
    u57._trove:Add(RunService.Heartbeat:Connect(function(p58) -- Line: 199
        -- upvalues: u57 (copy), Players (ref), ItemDisplay (ref), stepEntryFade (ref)
        local v59 = u57;
        v59._elapsed = v59._elapsed + p58;
        local v60 = u57._elapsed >= 0.15;

        if v60 then
            u57._elapsed = 0;
        end;

        local Character = Players.LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character == nil or not Character:IsA("BasePart") then
            Character = nil;
        end;

        for i, v in pairs(u57._entries) do
            if v60 then
                local PrimaryPart = i.PrimaryPart;

                if PrimaryPart == nil or (i.Parent == nil or Character == nil) then
                    v.RangeVisible = false;
                    local v61 = v.RangeVisible and v.SuppressCount <= 0;
                    v.TargetVisible = v61;

                    if v61 then
                        v.Billboard.Enabled = true;
                    end;
                else
                    local v62 = PrimaryPart.Position - Character.Position;
                    v.RangeVisible = Vector2.new(v62.X, v62.Z).Magnitude <= ItemDisplay.GetDataBillboardMaxDistance();
                    local v63 = v.RangeVisible and v.SuppressCount <= 0;
                    v.TargetVisible = v63;

                    if v63 then
                        v.Billboard.Enabled = true;
                    end;
                end;
            end;

            stepEntryFade(v, p58);
        end;
    end));

    return u57;
end;

function u1.Add(p64, p65, p66, p67) -- Line: 233
    -- upvalues: ItemDisplay (copy), captureFadeChannels (copy), applyFadeAlpha (copy)
    local v68 = ItemDisplay.CreateDataBillboard(p65, p66.Category, p66, p67);
    local v69 = `Asset model {p65.Name} must expose CENTER for its data billboard`;
    assert(v68 ~= nil, v69);
    v68.MaxDistance = 100000;
    local v70 = {
        Alpha = 0,
        RangeVisible = false,
        SuppressCount = 0,
        TargetVisible = false,
        Model = p65,
        Billboard = v68,
        Channels = captureFadeChannels(v68)
    };
    applyFadeAlpha(v70);
    v68.Enabled = false;
    p64._entries[p65] = v70;
end;

function u1.UpdateMoneyPerSecond(p71, p72, p73) -- Line: 256
    -- upvalues: ItemDisplay (copy)
    local v74 = p71._entries[p72];
    local v75 = `Asset model {p72.Name} must have a data billboard before its MPS can update`;
    assert(v74 ~= nil, v75);
    ItemDisplay.SetDataBillboardMoneyPerSecond(v74.Billboard, p73);
end;

function u1.SetSuppressed(p76, p77, p78) -- Line: 266
    local v79 = p76._entries[p77];

    if v79 == nil then
        return;
    end;

    if p78 then
        v79.SuppressCount = v79.SuppressCount + 1;
    elseif v79.SuppressCount > 0 then
        v79.SuppressCount = v79.SuppressCount - 1;
    end;

    local v80 = v79.RangeVisible and v79.SuppressCount <= 0;
    v79.TargetVisible = v80;

    if v80 then
        v79.Billboard.Enabled = true;
    end;
end;

function u1.Remove(p81, p82) -- Line: 280
    local v83 = p81._entries[p82];

    if v83 ~= nil then
        v83.Billboard:Destroy();
        p81._entries[p82] = nil;
    end;
end;

function u1.Destroy(p84) -- Line: 288
    for i in pairs(p84._entries) do
        p84:Remove(i);
    end;

    p84._trove:Destroy();
end;

return u1;