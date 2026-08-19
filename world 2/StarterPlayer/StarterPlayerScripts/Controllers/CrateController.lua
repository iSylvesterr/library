-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.RollController);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local CrateOpenEffect = require(script:WaitForChild("CrateOpenEffect"));
local LocalPlayer = Players.LocalPlayer;
local u2 = 0;
local u3 = {};
local u4 = 0;

local function ResolveCrateModel(p5) -- Line: 27
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage.Assets;
    local GuildCrates = Assets:FindFirstChild("GuildCrates");

    if GuildCrates then
        local v6 = GuildCrates:FindFirstChild(p5);

        if v6 and v6:IsA("Model") then
            return v6;
        end;
    end;

    local Crates = Assets.Crates;
    local v7 = Crates:FindFirstChild(p5);

    if v7 and v7:IsA("Model") then
        return v7;
    end;

    local v8 = Crates:FindFirstChild("Arch Crate");

    if v8 and v8:IsA("Model") then
        return v8;
    end;

    return nil;
end;

function v1.Init(p9) -- Line: 49
end;

local CrateSFX = game.SoundService.SFX.CrateSFX;
local u10 = {
    Spawn = CrateSFX.CrateSpawn,
    Land = CrateSFX.CrateLand,
    Shake = CrateSFX.CrateShake,
    Explode = CrateSFX.CrateExplode,
    Reveal = CrateSFX.CrateReward,
    Collect = CrateSFX.CrateCollect
};

function v1.Start(u11) -- Line: 63
    -- upvalues: LocalPlayer (copy), Networking (copy), ResolveCrateModel (copy), CrateOpenEffect (copy), ReplicatedStorage (copy), u10 (copy)
    local function onCharacter(p12) -- Line: 64
        -- upvalues: u11 (copy)
        p12.ChildAdded:Connect(function(p13) -- Line: 65
            -- upvalues: u11 (ref)
            if p13:IsA("Tool") and p13:GetAttribute("Crate") then
                u11:BindCrateTool(p13);
            end;
        end);

        for _, child in p12:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("Crate") then
                u11:BindCrateTool(child);
            end;
        end;
    end;

    if LocalPlayer.Character then
        onCharacter(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(onCharacter);
    Networking.Crate.ReplicateOpenCrate.OnClientEvent:Connect(function(p14, p15) -- Line: 85
        -- upvalues: LocalPlayer (ref), ResolveCrateModel (ref), CrateOpenEffect (ref), ReplicatedStorage (ref), u10 (ref)
        if p14 == LocalPlayer then
            return;
        end;

        local v16 = ResolveCrateModel(p15.WonItem.CrateName);

        if not v16 then
            return;
        end;

        CrateOpenEffect.Play({
            RarityName = "Legendary",
            Rarity = 0.01,
            Player = p14,
            Position = p15.DropPosition,
            CrateModel = v16,
            ItemImage = p15.WonItem.Image,
            ItemName = p15.WonItem.Name,
            RarityColor = Color3.fromRGB(255, 215, 0),
            IsBestItem = p15.WonItem.IsBestItem,
            BillboardTemplate = ReplicatedStorage.Assets.BillboardUIs.CrateItemBillboard,
            Particles = {
                Impact = ReplicatedStorage.Assets.VFX.CrateVFX.Impact:GetChildren(),
                Explosion = ReplicatedStorage.Assets.VFX.CrateVFX.Explosion:GetChildren(),
                Trail = ReplicatedStorage.Assets.VFX.CrateVFX.Trail.Trail
            },
            Sounds = u10,

            OnCollected = function() -- Line: 109, Name: OnCollected
            end
        });
    end);
end;

function v1.BindCrateTool(u17, u18) -- Line: 116
    -- upvalues: u3 (copy)
    if u3[u18] then
        return;
    end;

    u3[u18] = true;
    u18.Destroying:Connect(function() -- Line: 122
        -- upvalues: u3 (ref), u18 (copy)
        u3[u18] = nil;
    end);
    u18.Activated:Connect(function() -- Line: 126
        -- upvalues: u18 (copy), u17 (copy)
        local v19 = u18:GetAttribute("Crate");

        if not v19 then
            return;
        end;

        u17:OpenCrate(v19);
    end);
end;

function v1.OpenCrate(p20, u21) -- Line: 134
    -- upvalues: u4 (ref), u2 (ref), Networking (copy), ResolveCrateModel (copy), CrateOpenEffect (copy), LocalPlayer (copy), ReplicatedStorage (copy), u10 (copy)
    local v22 = workspace:GetServerTimeNow();

    if v22 - u4 < 0.1 then
        return;
    end;

    u4 = v22;

    if u2 >= 10 then
        return;
    end;

    u2 = u2 + 1;
    local success, result = pcall(function() -- Line: 146
        -- upvalues: Networking (ref), u21 (copy)
        return Networking.Crate.OpenCrate:Fire(u21);
    end);

    if not (success and (result and result.Success)) then
        if not success then
            warn((`[CrateController] OpenCrate invoke errored ({u21}): {result}`));
        end;

        u2 = u2 - 1;

        return;
    end;

    local u23 = ResolveCrateModel(result.WonItem.CrateName);

    if u23 then
        task.spawn(function() -- Line: 157
            -- upvalues: CrateOpenEffect (ref), LocalPlayer (ref), result (copy), u23 (copy), ReplicatedStorage (ref), u10 (ref), u2 (ref)
            local success2, result2 = pcall(function() -- Line: 158
                -- upvalues: CrateOpenEffect (ref), LocalPlayer (ref), result (ref), u23 (ref), ReplicatedStorage (ref), u10 (ref)
                CrateOpenEffect.Play({
                    RarityName = "Legendary",
                    Player = LocalPlayer,
                    Position = result.DropPosition,
                    CrateModel = u23,
                    ItemImage = result.WonItem.Image,
                    ItemName = result.WonItem.Name,
                    RarityColor = Color3.fromRGB(255, 215, 0),
                    Rarity = result.WonItem.Chance / 100,
                    IsBestItem = result.WonItem.IsBestItem,
                    BillboardTemplate = ReplicatedStorage.Assets.BillboardUIs.CrateItemBillboard,
                    Particles = {
                        Impact = ReplicatedStorage.Assets.VFX.CrateVFX.Impact:GetChildren(),
                        Explosion = ReplicatedStorage.Assets.VFX.CrateVFX.Explosion:GetChildren(),
                        Trail = ReplicatedStorage.Assets.VFX.CrateVFX.Trail.Trail
                    },
                    Sounds = u10
                });
            end);

            if not success2 then
                warn((`CrateOpenEffect.Play error: {result2}`));
            end;

            u2 = u2 - 1;
        end);

        return;
    end;

    u2 = u2 - 1;
end;

return v1;