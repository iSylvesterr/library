-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Chests = Assets:WaitForChild("Chests");
local Pets = Assets:WaitForChild("Pets");
local ChestData = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("ChestData"));
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local RarityVisuals = require(ReplicatedStorage.SharedModules.RarityVisuals);
local ChestOpenEffect = require(script:WaitForChild("ChestOpenEffect"));
local LocalPlayer = Players.LocalPlayer;
local u2 = 0;
local u3 = {};
local u4 = Color3.fromRGB(255, 215, 0);
local CrateSFX = SoundService.SFX.CrateSFX;
local u5 = {
    Spawn = CrateSFX.CrateSpawn,
    Land = CrateSFX.CrateLand,
    Explode = CrateSFX.CrateExplode,
    Reveal = CrateSFX.CrateReward,
    Collect = CrateSFX.CrateCollect
};
local CrateVFX = Assets.VFX.CrateVFX;
local ChestVFX = Assets.VFX.ChestVFX;

local function ResolveChestTemplate(p6) -- Line: 47
    -- upvalues: ChestData (copy), Chests (copy)
    local v7 = ChestData.GetData(p6);

    if v7 then
        v7 = v7.Model;
    end;

    if v7 then
        local v8 = Chests:FindFirstChild(v7);

        if v8 and v8:IsA("Model") then
            return v8;
        end;
    end;

    local v9 = Chests:FindFirstChild(p6);

    if v9 and v9:IsA("Model") then
        return v9;
    end;

    return nil;
end;

local function ResolveGripAngles(p10) -- Line: 70
    -- upvalues: ChestData (copy)
    local v11 = ChestData.GetData(p10);

    if v11 then
        v11 = v11.GripAngles;
    end;

    if typeof(v11) == "Vector3" then
        return CFrame.Angles(math.rad(v11.X), math.rad(v11.Y), (math.rad(v11.Z)));
    end;

    return CFrame.identity;
end;

local function ResolveReveal(p12) -- Line: 84
    -- upvalues: Pets (copy)
    if p12.IsPet then
        local v13 = p12.RawName or p12.Name;
        local v14 = Pets:FindFirstChild(v13);

        if v14 and v14:IsA("Model") then
            return v14, nil;
        end;

        warn((`No pet model for {v13}, revealing the icon instead`));
    end;

    return nil, p12.Image;
end;

local function ResolveOpenVFX(p15) -- Line: 103
    -- upvalues: ChestVFX (copy)
    if p15.Tier == nil and not p15.IsBestItem then
        return ChestVFX.Normal;
    end;

    return ChestVFX.Rare;
end;

local function BuildConfig(p16, p17, p18) -- Line: 113
    -- upvalues: Pets (copy), ChestData (copy), RarityVisuals (copy), u4 (copy), Assets (copy), ChestVFX (copy), CrateVFX (copy), u5 (copy)
    local WonItem = p17.WonItem;
    local v19, v20, v21, v22, v23, v24, v25;

    if WonItem.IsPet then
        local v26 = WonItem.RawName or WonItem.Name;
        v19 = Pets:FindFirstChild(v26);

        if v19 and v19:IsA("Model") then
            v20 = nil;
            v21 = {
                Player = p16,
                Position = p17.DropPosition,
                ChestModel = p18
            };
            v22 = ChestData.GetData(WonItem.ChestName);

            if v22 then
                v22 = v22.GripAngles;
            end;

            if typeof(v22) == "Vector3" then
                v23 = CFrame.Angles(math.rad(v22.X), math.rad(v22.Y), (math.rad(v22.Z)));
            else
                v23 = CFrame.identity;
            end;

            v21.GripAngles = v23;
            v21.ItemModel = v19;
            v21.ItemImage = v20;
            v21.ItemName = WonItem.Name;
            v21.RarityName = WonItem.Rarity;

            if WonItem.Rarity then
                v24 = RarityVisuals.GetStaticColor(WonItem.Rarity);
            else
                v24 = u4;
            end;

            v21.RarityColor = v24;
            v21.Rarity = (WonItem.Chance or 0) / 100;
            v21.IsBestItem = WonItem.IsBestItem;
            v21.BillboardTemplate = Assets.BillboardUIs.CrateItemBillboard;

            if WonItem.Tier == nil and not WonItem.IsBestItem then
                v25 = ChestVFX.Normal;
            else
                v25 = ChestVFX.Rare;
            end;

            v21.OpenVFX = v25;
            v21.Particles = {
                Impact = CrateVFX.Impact:GetChildren(),
                Explosion = CrateVFX.Explosion:GetChildren(),
                Trail = CrateVFX.Trail.Trail
            };
            v21.Sounds = u5;

            return v21;
        end;

        warn((`No pet model for {v26}, revealing the icon instead`));
    end;

    v20 = WonItem.Image;
    v19 = nil;
    v21 = {
        Player = p16,
        Position = p17.DropPosition,
        ChestModel = p18
    };
    v22 = ChestData.GetData(WonItem.ChestName);

    if v22 then
        v22 = v22.GripAngles;
    end;

    if typeof(v22) == "Vector3" then
        v23 = CFrame.Angles(math.rad(v22.X), math.rad(v22.Y), (math.rad(v22.Z)));
    else
        v23 = CFrame.identity;
    end;

    v21.GripAngles = v23;
    v21.ItemModel = v19;
    v21.ItemImage = v20;
    v21.ItemName = WonItem.Name;
    v21.RarityName = WonItem.Rarity;

    if WonItem.Rarity then
        v24 = RarityVisuals.GetStaticColor(WonItem.Rarity);
    else
        v24 = u4;
    end;

    v21.RarityColor = v24;
    v21.Rarity = (WonItem.Chance or 0) / 100;
    v21.IsBestItem = WonItem.IsBestItem;
    v21.BillboardTemplate = Assets.BillboardUIs.CrateItemBillboard;

    if WonItem.Tier == nil and not WonItem.IsBestItem then
        v25 = ChestVFX.Normal;
    else
        v25 = ChestVFX.Rare;
    end;

    v21.OpenVFX = v25;
    v21.Particles = {
        Impact = CrateVFX.Impact:GetChildren(),
        Explosion = CrateVFX.Explosion:GetChildren(),
        Trail = CrateVFX.Trail.Trail
    };
    v21.Sounds = u5;

    return v21;
end;

function v1.Init(p27) -- Line: 143
end;

function v1.Start(u28) -- Line: 147
    -- upvalues: LocalPlayer (copy), Networking (copy), ResolveChestTemplate (copy), ChestOpenEffect (copy), BuildConfig (copy)
    local function OnCharacter(p29) -- Line: 148
        -- upvalues: u28 (copy)
        p29.ChildAdded:Connect(function(p30) -- Line: 149
            -- upvalues: u28 (ref)
            if p30:IsA("Tool") and p30:GetAttribute("Chest") then
                u28:BindChestTool(p30);
            end;
        end);

        for _, child in p29:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("Chest") then
                u28:BindChestTool(child);
            end;
        end;
    end;

    if LocalPlayer.Character then
        OnCharacter(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(OnCharacter);
    Networking.Chest.ReplicateOpenChest.OnClientEvent:Connect(function(u31, u32) -- Line: 172
        -- upvalues: LocalPlayer (ref), ResolveChestTemplate (ref), ChestOpenEffect (ref), BuildConfig (ref)
        if u31 == LocalPlayer then
            return;
        end;

        if not (u32 and u32.WonItem) then
            return;
        end;

        local u33 = ResolveChestTemplate(u32.WonItem.ChestName);

        if not u33 then
            return;
        end;

        task.spawn(function() -- Line: 181
            -- upvalues: ChestOpenEffect (ref), BuildConfig (ref), u31 (copy), u32 (copy), u33 (copy)
            local success, result = pcall(function() -- Line: 182
                -- upvalues: ChestOpenEffect (ref), BuildConfig (ref), u31 (ref), u32 (ref), u33 (ref)
                ChestOpenEffect.Play((BuildConfig(u31, u32, u33)));
            end);

            if not success then
                warn((`ChestOpenEffect.Play error: {result}`));
            end;
        end);
    end);
end;

function v1.BindChestTool(u34, u35) -- Line: 195
    -- upvalues: u3 (copy)
    if u3[u35] then
        return;
    end;

    u3[u35] = true;
    u35.Activated:Connect(function() -- Line: 200
        -- upvalues: u35 (copy), u34 (copy)
        local v36 = u35:GetAttribute("Chest");

        if not v36 then
            return;
        end;

        u34:OpenChest(v36);
    end);
    u35.Destroying:Connect(function() -- Line: 209
        -- upvalues: u3 (ref), u35 (copy)
        u3[u35] = nil;
    end);
end;

function v1.OpenChest(p37, u38) -- Line: 215
    -- upvalues: u2 (ref), Networking (copy), ResolveChestTemplate (copy), ChestOpenEffect (copy), BuildConfig (copy), LocalPlayer (copy)
    if u2 >= 10 then
        return;
    end;

    u2 = u2 + 1;
    local success, result = pcall(function() -- Line: 223
        -- upvalues: Networking (ref), u38 (copy)
        return Networking.Chest.OpenChest:Fire(u38);
    end);

    if not success then
        warn((`OpenChest invoke errored ({u38}): {result}`));
        u2 = u2 - 1;

        return;
    end;

    if not (result and (result.Success and result.WonItem)) then
        u2 = u2 - 1;

        return;
    end;

    local u39 = ResolveChestTemplate(result.WonItem.ChestName);

    if u39 then
        task.spawn(function() -- Line: 249
            -- upvalues: ChestOpenEffect (ref), BuildConfig (ref), LocalPlayer (ref), result (copy), u39 (copy), u2 (ref)
            local success2, result2 = pcall(function() -- Line: 250
                -- upvalues: ChestOpenEffect (ref), BuildConfig (ref), LocalPlayer (ref), result (ref), u39 (ref)
                ChestOpenEffect.Play((BuildConfig(LocalPlayer, result, u39)));
            end);

            if not success2 then
                warn((`ChestOpenEffect.Play error: {result2}`));
            end;

            u2 = u2 - 1;
        end);

        return;
    end;

    warn((`No chest model for {result.WonItem.ChestName}`));
    u2 = u2 - 1;
end;

return v1;