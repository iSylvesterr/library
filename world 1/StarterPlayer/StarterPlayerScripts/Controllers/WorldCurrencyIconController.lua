-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local v2 = {
    StartOrder = 1
};

for _, v in Worlds.Worlds do
    u1[v.CurrencyIcon] = true;
end;

local Assets = ReplicatedStorage:WaitForChild("Assets");
local u3 = Worlds.WalletIcon(LocalPlayer);

local function swap(p4) -- Line: 50
    -- upvalues: u1 (copy), u3 (ref)
    if not p4:IsA("ImageLabel") then
        return;
    end;

    local Image = p4.Image;

    if u1[Image] and Image ~= u3 then
        p4.Image = u3;
    end;
end;

local function sweep(p5) -- Line: 60
    -- upvalues: u1 (copy), u3 (ref)
    if not p5 then
        return;
    end;

    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("ImageLabel") then
            local Image = descendant.Image;

            if u1[Image] and Image ~= u3 then
                descendant.Image = u3;
            end;
        end;
    end;
end;

local function sweepEverything() -- Line: 69
    -- upvalues: Assets (copy), u1 (copy), u3 (ref), LocalPlayer (copy)
    local v6 = Assets;

    if v6 then
        for _, descendant in v6:GetDescendants() do
            if descendant:IsA("ImageLabel") then
                local Image = descendant.Image;

                if u1[Image] and Image ~= u3 then
                    descendant.Image = u3;
                end;
            end;
        end;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        for _, descendant in PlayerGui:GetDescendants() do
            if descendant:IsA("ImageLabel") then
                local Image = descendant.Image;

                if u1[Image] and Image ~= u3 then
                    descendant.Image = u3;
                end;
            end;
        end;
    end;

    local Map = workspace:FindFirstChild("Map");

    if not Map then
        return;
    end;

    for _, descendant in Map:GetDescendants() do
        if descendant:IsA("ImageLabel") then
            local Image = descendant.Image;

            if u1[Image] and Image ~= u3 then
                descendant.Image = u3;
            end;
        end;
    end;
end;

function v2.Init(p7) -- Line: 75
    -- upvalues: Assets (copy), u1 (copy), u3 (ref)
    local v8 = Assets;

    if not v8 then
        return;
    end;

    for _, descendant in v8:GetDescendants() do
        if descendant:IsA("ImageLabel") then
            local Image = descendant.Image;

            if u1[Image] and Image ~= u3 then
                descendant.Image = u3;
            end;
        end;
    end;
end;

function v2.Start(p9) -- Line: 81
    -- upvalues: LocalPlayer (copy), u1 (copy), u3 (ref), swap (copy), Worlds (copy), Assets (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

    if PlayerGui then
        for _, descendant in PlayerGui:GetDescendants() do
            if descendant:IsA("ImageLabel") then
                local Image = descendant.Image;

                if u1[Image] and Image ~= u3 then
                    descendant.Image = u3;
                end;
            end;
        end;
    end;

    local Map = workspace:FindFirstChild("Map");

    if Map then
        for _, descendant in Map:GetDescendants() do
            if descendant:IsA("ImageLabel") then
                local Image = descendant.Image;

                if u1[Image] and Image ~= u3 then
                    descendant.Image = u3;
                end;
            end;
        end;
    end;

    PlayerGui.DescendantAdded:Connect(swap);
    LocalPlayer:GetAttributeChangedSignal("PetHuntOriginWorld"):Connect(function() -- Line: 94
        -- upvalues: Worlds (ref), LocalPlayer (ref), u3 (ref), Assets (ref), u1 (ref)
        local v10 = Worlds.WalletIcon(LocalPlayer);

        if v10 == u3 then
            return;
        end;

        u3 = v10;
        local v11 = Assets;

        if v11 then
            for _, descendant in v11:GetDescendants() do
                if descendant:IsA("ImageLabel") then
                    local Image = descendant.Image;

                    if u1[Image] and Image ~= u3 then
                        descendant.Image = u3;
                    end;
                end;
            end;
        end;

        local PlayerGui2 = LocalPlayer:FindFirstChild("PlayerGui");

        if PlayerGui2 then
            for _, descendant in PlayerGui2:GetDescendants() do
                if descendant:IsA("ImageLabel") then
                    local Image = descendant.Image;

                    if u1[Image] and Image ~= u3 then
                        descendant.Image = u3;
                    end;
                end;
            end;
        end;

        local Map2 = workspace:FindFirstChild("Map");

        if not Map2 then
            return;
        end;

        for _, descendant in Map2:GetDescendants() do
            if descendant:IsA("ImageLabel") then
                local Image = descendant.Image;

                if u1[Image] and Image ~= u3 then
                    descendant.Image = u3;
                end;
            end;
        end;
    end);
end;

return v2;