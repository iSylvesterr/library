-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GuardAreaLookupUtil = require(ReplicatedStorage.Library.Util.GuardAreaLookupUtil);
local Player = require(ReplicatedStorage.Library.Player);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local u1 = Color3.fromRGB(255, 255, 255);
local PLACED_TRAP = Constants.TAGS_MAP.Traps.PLACED_TRAP;
local LocalPlayer = Players.LocalPlayer;
local __OBJECTS = Workspace.__OBJECTS;
local v2 = __OBJECTS:IsA("Folder");
assert(v2, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v3 = Areas:IsA("Folder");
assert(v3, "Workspace.__OBJECTS.Areas must be a Folder");
local SeparationLine = Areas.SeparationLine;
local v4 = SeparationLine:IsA("BasePart");
assert(v4, "Workspace.__OBJECTS.Areas.SeparationLine must be a BasePart");
local u5 = {};
local u6 = nil;
local u7 = false;

local function getOrCreateState(p8) -- Line: 57
    -- upvalues: u5 (copy)
    local v9 = u5[p8];

    if v9 then
        return v9;
    end;

    local v10 = {
        Highlight = nil,
        Tween = nil,
        FadeOutVersion = 0
    };
    u5[p8] = v10;

    return v10;
end;

local function cancelTween(p11) -- Line: 72
    local Tween2 = p11.Tween;

    if Tween2 then
        p11.Tween = nil;
        Tween2:Cancel();
    end;
end;

local function isOwnedTrap(p12) -- Line: 80
    -- upvalues: LocalPlayer (copy)
    return p12:GetAttribute("Owner") == LocalPlayer.Name;
end;

local function showTrapHighlight(p13) -- Line: 84
    -- upvalues: LocalPlayer (copy), u5 (copy), u1 (copy), Tween (copy)
    if p13:GetAttribute("Owner") ~= LocalPlayer.Name then
        return;
    end;

    local v14 = u5[p13];

    if not v14 then
        v14 = {
            Highlight = nil,
            Tween = nil,
            FadeOutVersion = 0
        };
        u5[p13] = v14;
    end;

    v14.FadeOutVersion = v14.FadeOutVersion + 1;
    local Tween2 = v14.Tween;

    if Tween2 then
        v14.Tween = nil;
        Tween2:Cancel();
    end;

    local TrapGameplayHighlight = p13:FindFirstChild("TrapGameplayHighlight");

    if not (TrapGameplayHighlight and TrapGameplayHighlight:IsA("Highlight")) then
        TrapGameplayHighlight = Instance.new("Highlight");
        TrapGameplayHighlight.Name = "TrapGameplayHighlight";
        TrapGameplayHighlight.Parent = p13;
    end;

    TrapGameplayHighlight.Adornee = p13;
    TrapGameplayHighlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    TrapGameplayHighlight.FillColor = u1;
    TrapGameplayHighlight.FillTransparency = 1;
    TrapGameplayHighlight.OutlineColor = u1;
    TrapGameplayHighlight.OutlineTransparency = 1;
    v14.Highlight = TrapGameplayHighlight;
    v14.Tween = Tween(TrapGameplayHighlight, {
        OutlineTransparency = 0.3
    }, { 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
end;

local function hideTrapHighlight(p15) -- Line: 117
    -- upvalues: u5 (copy), Tween (copy)
    local u16 = u5[p15];

    if not u16 then
        return;
    end;

    local Highlight = u16.Highlight;

    if not Highlight then
        return;
    end;

    u16.FadeOutVersion = u16.FadeOutVersion + 1;
    local FadeOutVersion = u16.FadeOutVersion;
    local Tween2 = u16.Tween;

    if Tween2 then
        u16.Tween = nil;
        Tween2:Cancel();
    end;

    local v17 = Tween(Highlight, {
        OutlineTransparency = 1
    }, { 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
    u16.Tween = v17;
    v17.Completed:Once(function(p18) -- Line: 137
        -- upvalues: u16 (copy), FadeOutVersion (copy), Highlight (copy)
        if p18 ~= Enum.PlaybackState.Completed or u16.FadeOutVersion ~= FadeOutVersion then
            return;
        end;

        if Highlight.Parent then
            Highlight:Destroy();
        end;

        u16.Highlight = nil;
        u16.Tween = nil;
    end);
end;

local function setTrapHighlightsVisible(p19) -- Line: 150
    -- upvalues: u5 (copy), showTrapHighlight (copy), hideTrapHighlight (copy)
    for i in pairs(u5) do
        if p19 then
            showTrapHighlight(i);
        else
            hideTrapHighlight(i);
        end;
    end;
end;

local function cleanupTrap(p20) -- Line: 160
    -- upvalues: u5 (copy)
    local v21 = u5[p20];

    if not v21 then
        return;
    end;

    local Tween2 = v21.Tween;

    if Tween2 then
        v21.Tween = nil;
        Tween2:Cancel();
    end;

    local Highlight = v21.Highlight;

    if Highlight and Highlight.Parent then
        Highlight:Destroy();
    end;

    u5[p20] = nil;
end;

local function trackTrap(u22) -- Line: 174
    -- upvalues: LocalPlayer (copy), u5 (copy), u7 (ref), showTrapHighlight (copy)
    if not u22:IsA("BasePart") then
        return;
    end;

    if u22:GetAttribute("Owner") ~= LocalPlayer.Name then
        return;
    end;

    if not u5[u22] then
        u5[u22] = {
            Highlight = nil,
            Tween = nil,
            FadeOutVersion = 0
        };
    end;

    if u7 then
        showTrapHighlight(u22);
    end;

    u22.Destroying:Once(function() -- Line: 187
        -- upvalues: u22 (copy), u5 (ref)
        local v23 = u22;
        local v24 = u5[v23];

        if not v24 then
            return;
        end;

        local Tween2 = v24.Tween;

        if Tween2 then
            v24.Tween = nil;
            Tween2:Cancel();
        end;

        local Highlight = v24.Highlight;

        if Highlight and Highlight.Parent then
            Highlight:Destroy();
        end;

        u5[v23] = nil;
    end);
end;

local function untrackTrap(p25) -- Line: 192
    -- upvalues: u7 (ref), hideTrapHighlight (copy), u5 (copy)
    if not p25:IsA("BasePart") then
        return;
    end;

    if u7 then
        hideTrapHighlight(p25);

        return;
    end;

    local v26 = u5[p25];

    if not v26 then
        return;
    end;

    local Tween2 = v26.Tween;

    if Tween2 then
        v26.Tween = nil;
        Tween2:Cancel();
    end;

    local Highlight = v26.Highlight;

    if Highlight and Highlight.Parent then
        Highlight:Destroy();
    end;

    u5[p25] = nil;
end;

for _, v in ipairs(CollectionService:GetTagged(PLACED_TRAP)) do
    trackTrap(v);
end;

CollectionService:GetInstanceAddedSignal(PLACED_TRAP):Connect(trackTrap);
CollectionService:GetInstanceRemovedSignal(PLACED_TRAP):Connect(untrackTrap);
RenderStepped(function() -- Line: 211
    -- upvalues: Player (copy), LocalPlayer (copy), u6 (ref), u7 (ref), GuardAreaLookupUtil (copy), SeparationLine (copy), u5 (copy), showTrapHighlight (copy), hideTrapHighlight (copy)
    local v27 = Player.Optional.HumanoidRootPart(LocalPlayer);

    if v27 == nil or not v27:IsA("BasePart") then
        return false;
    end;

    local Position = v27.Position;
    local v28 = u6;
    u6 = Position;

    if v28 ~= nil then
        if GuardAreaLookupUtil.HasCrossedGameplayEntryBoundary(SeparationLine, v28, Position) then
            u7 = true;

            for i in pairs(u5) do
                showTrapHighlight(i);
            end;
        elseif GuardAreaLookupUtil.HasCrossedGameplayExitBoundary(SeparationLine, v28, Position) then
            u7 = false;

            for i in pairs(u5) do
                hideTrapHighlight(i);
            end;
        end;

        return false;
    end;

    u7 = GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, Position);

    if u7 then
        for i in pairs(u5) do
            showTrapHighlight(i);
        end;
    end;

    return false;
end);