-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);

local function GetWeaponProperties(p2) -- Line: 32
    -- upvalues: ReplicatedStorage (copy)
    local v3 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p2);

    if not (v3 and v3:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, v3);

    return success and result and result or nil;
end;

function u1.UpdateVisibility(p4, p5) -- Line: 49
    -- upvalues: LocalPlayer (copy)
    if (p5 or LocalPlayer:GetAttribute("Team")) == p4.CurrentTeam then
        if p4.Model.Parent == nil and p4.OriginalParent then
            p4.Model.Parent = p4.OriginalParent;
        end;

        return;
    end;

    p4.Model.Parent = nil;
end;

function u1.new(p6, p7, p8) -- Line: 62
    -- upvalues: u1 (copy), Janitor (copy), Colors (copy), Skins (copy), ReplicatedStorage (copy), Rarities (copy)
    local v9 = {
        Weapon = p6:GetAttribute("Weapon"),
        Skin = p6:GetAttribute("Skin")
    };
    local u10 = setmetatable(v9, u1);
    u10.Janitor = Janitor.new();
    u10.Identifier = p7;
    u10.CurrentTeam = p6:GetAttribute("Team");
    u10.IsDanger = p6:GetAttribute("IsDanger");
    u10.OriginalParent = p6.Parent;
    u10.Model = p6;
    u10:UpdateVisibility(p8);
    task.delay(0.016666666666666666, function() -- Line: 86
        -- upvalues: Colors (ref), u10 (copy), Skins (ref), ReplicatedStorage (ref), Rarities (ref)
        local v11 = Colors["Team Color"][u10.CurrentTeam];
        u10.Model.Name = u10.Identifier;

        if v11 then
            local v12 = u10.Model:FindFirstChildOfClass("BillboardGui");

            if v12 and v12:IsDescendantOf(workspace) then
                local v13;

                if typeof(u10.Weapon) == "string" and (u10.Weapon ~= "" and typeof(u10.Skin) == "string") then
                    v13 = u10.Skin ~= "";
                else
                    v13 = false;
                end;

                v12.Info.Visible = not u10.IsDanger and not v13;
                v12.Danger.Visible = u10.IsDanger and not v13;
                v12.Weapon.Visible = v13;

                if v12.Info.Visible then
                    v12.Info.ImageColor3 = v11;

                    return;
                end;

                if v13 then
                    local Weapon = u10.Weapon;
                    local v14 = Skins.GetSkinInformation(Weapon, u10.Skin);
                    local v15 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Weapon);
                    local v16;

                    if v15 and v15:IsA("ModuleScript") then
                        local success, result = pcall(require, v15);
                        v16 = success and result and result or nil;
                    else
                        v16 = nil;
                    end;

                    local v17;

                    if v14 then
                        v17 = Rarities[v14.rarity];
                    else
                        v17 = v14;
                    end;

                    if not (v14 and (v16 and v17)) then
                        v12.Weapon.Visible = false;
                        v12.Info.Visible = not u10.IsDanger;
                        v12.Danger.Visible = u10.IsDanger;

                        if v12.Info.Visible then
                            v12.Info.ImageColor3 = v11;
                        end;

                        return;
                    end;

                    v12.Weapon.Icon.ImageColor3 = v17.Color;
                    v12.Weapon.Icon.Image = v16.Icon;
                end;
            end;
        end;
    end);

    return u10;
end;

function u1.Destroy(p18) -- Line: 135
    p18.Janitor:Destroy();
end;

return u1;