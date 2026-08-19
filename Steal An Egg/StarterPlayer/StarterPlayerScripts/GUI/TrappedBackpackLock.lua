-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local HideImportantUI = require(ReplicatedStorage.Library.Client.HideImportantUI);
local Main = require(script.Parent.BackpackController.Main);
local u1 = GUI.Backpack();
local u2 = false;
local u3 = nil;

return {
    SetLocked = function(p4) -- Line: 32, Name: SetLocked
        -- upvalues: u2 (ref), u3 (ref), Main (copy), u1 (copy), HideImportantUI (copy)
        if u2 == p4 then
            return;
        end;

        u2 = p4;

        if p4 then
            u3 = Main:GetBackpackEnabled();
            Main:SetBackpackEnabled(false);
            u1.Enabled = false;

            return;
        end;

        local v5 = u3;
        u3 = nil;

        if v5 == nil then
            return;
        end;

        Main:SetBackpackEnabled(v5);

        if v5 and HideImportantUI:IsUnLocked() then
            u1.Enabled = true;
        end;
    end
};