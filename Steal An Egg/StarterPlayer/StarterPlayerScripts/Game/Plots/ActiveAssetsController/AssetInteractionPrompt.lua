-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = require(ReplicatedStorage.Directory.Assets);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
require(ReplicatedStorage.Library.Types.ActiveAssets);
local AssetDnaProductResolver = require(script.Parent.AssetDnaProductResolver);
local AssetDnaRarityClassification = require(script.Parent.AssetDnaRarityClassification);
local AssetInteractionPromptAnchor = require(script.Parent.AssetInteractionPromptAnchor);
local AssetDnaStealPrompt = require(ReplicatedStorage.Library.Client.AssetDnaStealPrompt);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = {};
u1.__index = u1;

function u1.new(u2, u3, u4, p5) -- Line: 41
    -- upvalues: Asserts (copy), AssetItem (copy), u1 (copy), Trove (copy), Players (copy), Constants (copy), AssetInteractionPromptAnchor (copy), Assets (copy), Lock (copy), Message (copy), AssetDnaProductResolver (copy), AssetDnaRarityClassification (copy), AssetDnaStealPrompt (copy), Network (copy), PromptPurchase (copy)
    Asserts.number(u2);
    Asserts.string(u3);
    Asserts.Model(p5);
    assert(AssetItem.AssetItemData(u4));
    local u6 = setmetatable({}, u1);
    u6._trove = Trove.new();
    u6._activate = nil;
    u6._prompt = nil;
    u6._suppressed = false;

    if u2 == Players.LocalPlayer.UserId or not Constants.ASSET_DNA_STEAL_ENABLED then
        return u6;
    end;

    local PrimaryPart = p5.PrimaryPart;
    local v7 = `Asset model {p5.Name} must have a PrimaryPart`;
    local v8 = assert(PrimaryPart, v7);
    local v9 = AssetInteractionPromptAnchor.Create(p5, v8);
    u6._trove:Add(v9);
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "AssetInteractionPrompt";
    ProximityPrompt.HoldDuration = 0;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.ObjectText = Assets.Directory[u4.Category].DisplayName;
    ProximityPrompt.ActionText = "<font color=\"#FF0000\">Steal</font> DNA 🧬";
    ProximityPrompt.Parent = v9;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.MaxActivationDistance = 14;
    u6._prompt = ProximityPrompt;
    local u10 = Lock();

    function u6._activate() -- Line: 78
        -- upvalues: u10 (copy), u4 (copy), Message (ref), AssetDnaProductResolver (ref), Assets (ref), AssetDnaRarityClassification (ref), AssetDnaStealPrompt (ref), u2 (copy), u3 (copy), Network (ref), PromptPurchase (ref)
        u10(function() -- Line: 79
            -- upvalues: u4 (ref), Message (ref), AssetDnaProductResolver (ref), Assets (ref), AssetDnaRarityClassification (ref), AssetDnaStealPrompt (ref), u2 (ref), u3 (ref), Network (ref), PromptPurchase (ref)
            if u4.IsStolenDNA == true then
                Message.Bottom({
                    Message = "Cannot steal that pets DNA, this pets was already stolen from someone!",
                    Time = 2,
                    Color = Color3.fromRGB(255, 0, 0)
                });

                return;
            end;

            local v11 = AssetDnaProductResolver.GetProductId(u4);

            if v11 == nil then
                Message.Bottom({
                    Message = "This DNA steal product is not configured yet",
                    Time = 2
                });

                return;
            end;

            local v12 = AssetDnaRarityClassification.Resolve(u4, Assets.Directory[u4.Category].Rarity.RarityNumber);

            if AssetDnaStealPrompt.Prompt(u4, v12.SizeRichText) ~= true then
                return;
            end;

            local v13, v14 = Network.Invoke(Network.NET_MAP.ActiveAssets.REQUEST_STEAL_TARGET, {
                ProductId = v11,
                OwnerUserId = u2,
                UID = u3
            });

            if v13 == true then
                PromptPurchase.Prompt(v11, true);

                return;
            end;

            Message.Bottom({
                Time = 2,
                Message = typeof(v14) ~= "string" and "Choose a valid pet to steal DNA from first." or v14
            });
        end);
    end;

    u6._trove:Add(ProximityPrompt.Triggered:Connect(function(p15) -- Line: 117
        -- upvalues: Players (ref), u6 (copy)
        if p15 ~= Players.LocalPlayer then
            return;
        end;

        u6:Activate();
    end));

    return u6;
end;

function u1.Activate(p16) -- Line: 130
    if p16._suppressed then
        return;
    end;

    assert(p16._activate, "Cannot activate DNA steal interaction for the local player\'s asset")();
end;

function u1.SetSuppressed(p17, p18) -- Line: 138
    -- upvalues: Asserts (copy)
    Asserts.boolean(p18);
    p17._suppressed = p18;
    local _prompt = p17._prompt;

    if _prompt ~= nil then
        _prompt.Enabled = not p18;
    end;
end;

function u1.Destroy(p19) -- Line: 147
    p19._trove:Destroy();
end;

return u1;