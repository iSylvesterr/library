-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ToolSetup = require(ReplicatedStorage.Library.Util.ToolSetup);
local ToolCooldownUtil = require(ReplicatedStorage.Library.Util.ToolCooldownUtil);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BodySwap = require(ReplicatedStorage.Directory.Gears._Index.Other.BodySwap);
local BodySwap2 = Constants.NETWORK_MAP.BodySwap;
local COOLDOWN = BodySwap.COOLDOWN;
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = {};
local u4 = nil;
local u5 = Trove.new();

local function playSwapVFX(p6) -- Line: 32
    -- upvalues: Asserts (copy), u1 (copy), ReplicatedStorage (copy)
    Asserts.Player(p6);
    local Character = p6.Character;

    if not Character then
        u1:AtError():Log("[BodySwap] Character not found");

        return;
    end;

    local u7 = {};

    for _, child in pairs(Character:GetChildren()) do
        if child:IsA("BasePart") then
            local v8 = ReplicatedStorage.Assets:FindFirstChild("BeeHit"):Clone();
            v8.Parent = child;
            table.insert(u7, v8);

            for _, child2 in pairs(v8:GetChildren()) do
                if child2:IsA("ParticleEmitter") then
                    child2:Emit(child2:GetAttribute("EmitCount") or 10);
                end;
            end;
        end;
    end;

    task.delay(2, function() -- Line: 56
        -- upvalues: u7 (copy)
        for _, v in ipairs(u7) do
            v:Destroy();
        end;
    end);
end;

local function playSwapSFX() -- Line: 63
end;

local function removePlayerHighlights(p9) -- Line: 66
    -- upvalues: Asserts (copy), u3 (copy)
    Asserts.Player(p9);
    local v10 = u3[p9];

    if v10 then
        for _, v in v10 do
            if v and v.Parent then
                v:Destroy();
            end;
        end;

        u3[p9] = nil;
    end;
end;

local function addPlayerHighlights(p11) -- Line: 80
    -- upvalues: Asserts (copy), removePlayerHighlights (copy), BodySwap (copy), u3 (copy)
    Asserts.Player(p11);
    local Character = p11.Character;

    if not Character then
        return;
    end;

    removePlayerHighlights(p11);
    local Highlight = Instance.new("Highlight");
    Highlight.OutlineColor = BodySwap.HIGHLIGHT_COLOR;
    Highlight.FillTransparency = BodySwap.HIGHLIGHT_FILL_TRANSPARENCY;
    Highlight.OutlineTransparency = BodySwap.HIGHLIGHT_OUTLINE_TRANSPARENCY;
    Highlight.Parent = Character;
    u3[p11] = { Highlight };
end;

local function findClosestTarget() -- Line: 99
    -- upvalues: LocalPlayer (copy), BodySwap (copy), Players (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character.PrimaryPart) then
        return nil;
    end;

    local Position = Character.PrimaryPart.Position;
    local MAX_RANGE = BodySwap.MAX_RANGE;
    local v12 = nil;

    for _, v in Players:GetPlayers() do
        if v ~= LocalPlayer and (v.Character and v.Character.PrimaryPart) then
            local Magnitude = (v.Character.PrimaryPart.Position - Position).Magnitude;

            if Magnitude <= MAX_RANGE then
                v12 = v;
                MAX_RANGE = Magnitude;
            end;
        end;
    end;

    return v12;
end;

local function updateTargeting() -- Line: 123
    -- upvalues: u2 (ref), ToolCooldownUtil (copy), u4 (ref), removePlayerHighlights (copy), findClosestTarget (copy), addPlayerHighlights (copy)
    local v13 = u2:GetCurrentTool();

    if not v13 or ToolCooldownUtil.IsOnCooldown(v13) then
        if u4 then
            removePlayerHighlights(u4);
            u4 = nil;
        end;

        return;
    end;

    local v14 = findClosestTarget();

    if v14 ~= u4 then
        if u4 then
            removePlayerHighlights(u4);
        end;

        if v14 then
            addPlayerHighlights(v14);
        end;

        u4 = v14;
    end;
end;

u2 = ToolSetup.Initialize(BodySwap.DisplayName, {
    onActivated = function(p15) -- Line: 148, Name: onActivated
        -- upvalues: u4 (ref), ToolCooldownUtil (copy), u1 (copy), Network (copy), BodySwap2 (copy)
        if not u4 then
            return;
        end;

        if ToolCooldownUtil.IsOnCooldown(p15) then
            u1:AtInfo():Log("[BodySwap] Tool is on cooldown");

            return;
        end;

        Network.Fire(BodySwap2.REQUEST_SWAP, u4);
    end,

    onEquipped = function(p16) -- Line: 161, Name: onEquipped
        -- upvalues: u5 (copy), RunService (copy), updateTargeting (copy)
        u5:Clean();
        u5:Add(RunService.Heartbeat:Connect(updateTargeting));
    end,

    onUnequipped = function() -- Line: 166, Name: onUnequipped
        -- upvalues: u5 (copy), u4 (ref), u3 (copy), removePlayerHighlights (copy)
        u5:Clean();
        u4 = nil;

        for i in pairs(u3) do
            removePlayerHighlights(i);
        end;
    end
});
Network.Fired(BodySwap2.PLAY_VFX):Connect(function(p17, p18) -- Line: 182
    -- upvalues: Asserts (copy), playSwapVFX (copy), LocalPlayer (copy), ToolSetup (copy), u2 (ref), COOLDOWN (copy)
    Asserts.Player(p17);
    Asserts.Player(p18);
    playSwapVFX(p17);
    playSwapVFX(p18);

    if p17 == LocalPlayer then
        ToolSetup.StartCooldown(u2, COOLDOWN);
    end;
end);
Network.Fired(BodySwap2.PLAY_SFX):Connect(function() -- Line: 194
end);