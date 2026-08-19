-- Decompiled with Potassium's decompiler.

repeat
    task.wait(0.3);
until game.Players.LocalPlayer;

local Trove = require(game.ReplicatedStorage.ClientModules.Trove);
game:GetService("TweenService");
game:GetService("StarterGui");
local Controllers = game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("Controllers");
local SeedInspectController = require(Controllers:WaitForChild("SeedInspectController"));
local SeedPackData = require(game.ReplicatedStorage.SharedModules.SeedPackData);
local Worlds = require(game.ReplicatedStorage.SharedModules.Worlds);
local SeedData = game.ReplicatedStorage.SharedModules.SeedData;
local CinematicBars = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CinematicBars");
CinematicBars:WaitForChild("BottomBar");
CinematicBars:WaitForChild("TopBar");
local PrizesUI = CinematicBars:WaitForChild("PrizesUI");
local Prizes = PrizesUI:WaitForChild("Prizes");

local function DefaultPackName() -- Line: 39
    -- upvalues: SeedPackData (copy), Worlds (copy)
    for _, v in SeedPackData.Data do
        if v.Seeds and Worlds.EntryAvailableHere(v) then
            return v.PackName;
        end;
    end;

    return nil;
end;

local u1 = Trove.new();

local function Populate(p2) -- Line: 51
    -- upvalues: u1 (copy), SeedPackData (copy), Prizes (copy), SeedData (copy), SeedInspectController (copy)
    u1:Clean();

    if not p2 then
        return;
    end;

    local v3 = SeedPackData.GetData(p2);

    if not (v3 and v3.Seeds) then
        return;
    end;

    local v4 = table.clone(v3.Seeds);
    table.sort(v4, function(p5, p6) -- Line: 64
        return p5.Chance > p6.Chance;
    end);

    for _, child in pairs(Prizes:GetChildren()) do
        if child:IsA("Frame") then
            local Inspect = child:FindFirstChild("Inspect");

            if Inspect then
                local v7 = tonumber(child.Name:sub(5));

                if v7 then
                    local u8 = v4[v7];
                    child.Visible = u8 ~= nil;

                    if u8 then
                        child.Odds.Text = tostring(u8.Chance) .. "%";
                        child.ItemName.Text = u8.SeedName;
                        child.ItemImage.Image = SeedData.SeedImages[u8.SeedName].Value;
                        u1:Add(Inspect.Activated:Connect(function() -- Line: 92
                            -- upvalues: SeedInspectController (ref), u8 (copy)
                            SeedInspectController.Inspect(u8);
                        end));
                    end;
                end;
            end;
        end;
    end;
end;

Populate(PrizesUI:GetAttribute("PackName") or DefaultPackName());
PrizesUI:GetAttributeChangedSignal("PackName"):Connect(function() -- Line: 100
    -- upvalues: Populate (copy), PrizesUI (copy), DefaultPackName (copy)
    Populate(PrizesUI:GetAttribute("PackName") or DefaultPackName());
end);