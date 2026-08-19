-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local ToolCooldownUtil = require(ReplicatedStorage.Library.Util.ToolCooldownUtil);
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);
local LocalPlayer = Players.LocalPlayer;

return {
    Initialize = function(p1, p2) -- Line: 33, Name: Initialize
        -- upvalues: Trove (copy), Asserts (copy), ToolCooldownUtil (copy), ToolGameplayGuard (copy), LocalPlayer (copy)
        local u3 = nil;
        local u4 = nil;
        local u5 = Trove.new();
        local u6 = type(p1) == "string" and ({ p1 } or p1) or p1;
        Asserts.array.string(u6);
        local u7 = p2 or {};

        local function onEquipped(u8) -- Line: 43
            -- upvalues: u3 (ref), Trove (ref), u4 (ref), ToolCooldownUtil (ref), u7 (ref), ToolGameplayGuard (ref), LocalPlayer (ref)
            if u3 then
                u3:Clean();
            end;

            u3 = Trove.new();
            u4 = u8;
            ToolCooldownUtil.InitializeTool(u8);

            if u7 and u7.onEquipped then
                u7.onEquipped(u8);
            end;

            if not u3 then
                return;
            end;

            if u7 and u7.onActivated then
                u3:Add(u8.Activated:Connect(function() -- Line: 62
                    -- upvalues: u7 (ref), ToolGameplayGuard (ref), u8 (copy)
                    if u7 and u7.onActivated then
                        if not ToolGameplayGuard.CanActivateLocal(u8) then
                            return;
                        end;

                        u7.onActivated(u8);
                    end;
                end));
            end;

            u3:Add(LocalPlayer.CharacterRemoving:Connect(function() -- Line: 72
                -- upvalues: u3 (ref)
                if u3 then
                    u3:Clean();
                end;
            end));
        end;

        local function onUnequipped() -- Line: 79
            -- upvalues: u3 (ref), u7 (ref), u4 (ref)
            if u3 then
                u3:Clean();
                u3 = nil;
            end;

            if u7 and u7.onUnequipped then
                u7.onUnequipped();
            end;

            u4 = nil;
        end;

        local function setupToolDetection(p9) -- Line: 92
            -- upvalues: u6 (copy), onEquipped (copy), u3 (ref), u7 (ref), u4 (ref)
            p9.ChildAdded:Connect(function(p10) -- Line: 93
                -- upvalues: u6 (ref), onEquipped (ref)
                if p10:IsA("Tool") and table.find(u6, (p10:GetAttribute("GearName"))) then
                    onEquipped(p10);
                end;
            end);
            p9.ChildRemoved:Connect(function(p11) -- Line: 99
                -- upvalues: u6 (ref), u3 (ref), u7 (ref), u4 (ref)
                if p11:IsA("Tool") and table.find(u6, (p11:GetAttribute("GearName"))) then
                    if u3 then
                        u3:Clean();
                        u3 = nil;
                    end;

                    if u7 and u7.onUnequipped then
                        u7.onUnequipped();
                    end;

                    u4 = nil;
                end;
            end);
            local v12 = p9:FindFirstChildWhichIsA("Tool");

            if v12 and table.find(u6, (v12:GetAttribute("GearName"))) then
                onEquipped(v12);
            end;
        end;

        if LocalPlayer.Character then
            setupToolDetection(LocalPlayer.Character);
        end;

        u5:Add(LocalPlayer.CharacterAdded:Connect(function(p13) -- Line: 115
            -- upvalues: setupToolDetection (copy)
            setupToolDetection(p13);
        end));

        return {
            Cleanup = function() -- Line: 120, Name: Cleanup
                -- upvalues: u5 (copy), u3 (ref)
                u5:Clean();

                if u3 then
                    u3:Clean();
                end;
            end,

            IsActive = function() -- Line: 127, Name: IsActive
                -- upvalues: u4 (ref)
                return u4 ~= nil;
            end,

            GetCurrentTool = function() -- Line: 131, Name: GetCurrentTool
                -- upvalues: u4 (ref)
                return u4;
            end,

            GetCurrentToolGearName = function() -- Line: 135, Name: GetCurrentToolGearName
                -- upvalues: u4 (ref)
                if u4 then
                    return u4:GetAttribute("GearName");
                end;

                return nil;
            end
        };
    end,

    StartCooldown = function(p14, p15) -- Line: 146, Name: StartCooldown
        -- upvalues: ToolCooldownUtil (copy)
        local v16 = p14:GetCurrentTool();

        if v16 and v16.Parent then
            ToolCooldownUtil.StartCooldown(v16, p15);
        end;
    end
};