-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Icon = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "topbar-plus", "out").Icon;
local u1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils");
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local admins = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "cmdr", "admins").admins;
local SprayBottles = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "SprayBottles").SprayBottles;
local Detectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors").Detectors;
local Shovels = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").Shovels;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local Items = v2.Items;
local RARITY_ORDER = v2.RARITY_ORDER;
local Colors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "Colors").Colors;

return {
    setup = function() -- Line: 15, Name: setup
        -- upvalues: Player (copy), admins (copy), ReplicatedStorage (copy), u1 (copy), Colors (copy), Items (copy), RARITY_ORDER (copy), Shovels (copy), SprayBottles (copy), Detectors (copy), Icon (copy)
        if table.find(admins, Player.UserId) == nil then
            return nil;
        end;

        local CmdrClient = ReplicatedStorage:WaitForChild("CmdrClient", 30);

        if not CmdrClient then
            return nil;
        end;

        local u3 = require(CmdrClient);
        u3:SetEnabled(true);
        u3:SetActivationKeys({});
        local u4 = u1.keys(Colors);
        u3.Registry:RegisterType("notificationColor", {
            DisplayName = "notificationColor",

            Transform = function(u5) -- Line: 30, Name: Transform
                -- upvalues: u4 (copy)
                local function _(p6) -- Line: 32
                    -- upvalues: u5 (copy)
                    return string.lower(p6) == string.lower(u5);
                end;

                local v7 = nil;

                for i, v in u4 do
                    local _ = i - 1;

                    if string.lower(v) == string.lower(u5) == true then
                        v7 = v;
                        break;
                    end;
                end;

                if v7 ~= nil then
                    u5 = v7;
                end;

                return u5;
            end,

            Validate = function(p8) -- Line: 49, Name: Validate
                -- upvalues: u4 (copy)
                if table.find(u4, p8) == nil then
                    return false, `Valid colors: {table.concat(u4, ", ")}`;
                end;

                return true, "";
            end,

            Autocomplete = function(u9) -- Line: 56, Name: Autocomplete
                -- upvalues: u4 (copy)
                local function _(p10) -- Line: 59
                    -- upvalues: u9 (copy)
                    local v11 = string.lower(p10);

                    return string.sub(v11, 1, #u9) == string.lower(u9);
                end;

                local v12 = 0;
                local v13 = {};

                for i, v in u4 do
                    local _ = i - 1;
                    local v14 = string.lower(v);

                    if string.sub(v14, 1, #u9) == string.lower(u9) == true then
                        v12 = v12 + 1;
                        v13[v12] = v;
                    end;
                end;

                return v13;
            end,

            Parse = function(p15) -- Line: 74, Name: Parse
                return p15;
            end
        });
        u3.Registry:RegisterType("itemId", u3.Util.MakeEnumType("itemId", u1.keys(Items)));
        local Registry = u3.Registry;
        local Util = u3.Util;
        local v16 = {};
        table.move(RARITY_ORDER, 1, #RARITY_ORDER, #v16 + 1, v16);
        Registry:RegisterType("itemRarity", Util.MakeEnumType("itemRarity", v16));
        u3.Registry:RegisterType("shovelId", u3.Util.MakeEnumType("shovelId", u1.keys(Shovels)));
        u3.Registry:RegisterType("sprayId", u3.Util.MakeEnumType("sprayId", u1.keys(SprayBottles)));
        u3.Registry:RegisterType("detectorId", u3.Util.MakeEnumType("detectorId", u1.keys(Detectors)));
        u3.Registry:RegisterHook("BeforeRun", function(p17) -- Line: 88
            -- upvalues: admins (ref)
            return table.find(admins, p17.Executor.UserId) == nil and "You don\'t have permission to run this command." or nil;
        end);
        local u18 = nil;
        u18 = Icon.new():setLabel("CMDR"):bindEvent("selected", function() -- Line: 93
            -- upvalues: u18 (ref), u3 (copy)
            u18:deselect();
            u3:Toggle();
        end):align("Right"):setOrder(4);
    end
};