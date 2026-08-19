-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Player = require(ReplicatedStorage.Library.Player);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local TrappedBackpackLock = require(script.Parent.Parent.Parent.GUI.TrappedBackpackLock);
local LocalPlayer = Players.LocalPlayer;
local u1 = Trove.new();
local u2 = false;

local function unequipLocalTools() -- Line: 24
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v3 = Player.Optional.Humanoid(LocalPlayer);

    if v3 then
        v3:UnequipTools();
    end;
end;

local function setTrapBackpackLocked(p4) -- Line: 31
    -- upvalues: u2 (ref), Player (copy), LocalPlayer (copy), TrappedBackpackLock (copy)
    if u2 == p4 then
        local v5 = p4 and Player.Optional.Humanoid(LocalPlayer);

        if v5 then
            v5:UnequipTools();
        end;

        return;
    end;

    u2 = p4;

    if not p4 then
        TrappedBackpackLock.SetLocked(false);

        return;
    end;

    TrappedBackpackLock.SetLocked(true);
    local v6 = Player.Optional.Humanoid(LocalPlayer);

    if v6 then
        v6:UnequipTools();
    end;
end;

local function refreshCharacterTrapState(p7) -- Line: 50
    -- upvalues: u2 (ref), Player (copy), LocalPlayer (copy), TrappedBackpackLock (copy)
    local v8 = p7:GetAttribute("IsTrapped") == true;

    if u2 == v8 then
        local v9 = v8 and Player.Optional.Humanoid(LocalPlayer);

        if v9 then
            v9:UnequipTools();
        end;
    else
        u2 = v8;

        if v8 then
            TrappedBackpackLock.SetLocked(true);
            local v10 = Player.Optional.Humanoid(LocalPlayer);

            if v10 then
                v10:UnequipTools();
            end;
        else
            TrappedBackpackLock.SetLocked(false);
        end;
    end;
end;

local function bindCharacter(u11) -- Line: 54
    -- upvalues: u1 (copy), u2 (ref), TrappedBackpackLock (copy), Player (copy), LocalPlayer (copy)
    u1:Clean();
    u1:Add(function() -- Line: 57
        -- upvalues: u2 (ref), TrappedBackpackLock (ref)
        if u2 == false then
            return;
        end;

        u2 = false;
        TrappedBackpackLock.SetLocked(false);
    end);
    u1:Connect(u11:GetAttributeChangedSignal("IsTrapped"), function() -- Line: 61
        -- upvalues: u11 (copy), u2 (ref), Player (ref), LocalPlayer (ref), TrappedBackpackLock (ref)
        local v12 = u11:GetAttribute("IsTrapped") == true;

        if u2 == v12 then
            local v13 = v12 and Player.Optional.Humanoid(LocalPlayer);

            if v13 then
                v13:UnequipTools();
            end;
        else
            u2 = v12;

            if v12 then
                TrappedBackpackLock.SetLocked(true);
                local v14 = Player.Optional.Humanoid(LocalPlayer);

                if v14 then
                    v14:UnequipTools();
                end;
            else
                TrappedBackpackLock.SetLocked(false);
            end;
        end;
    end);
    u1:Connect(u11.ChildAdded, function(p15) -- Line: 65
        -- upvalues: u2 (ref), Player (ref), LocalPlayer (ref)
        local v16 = u2 and (p15:IsA("Tool") and Player.Optional.Humanoid(LocalPlayer));

        if v16 then
            v16:UnequipTools();
        end;
    end);
    local v17 = u11:GetAttribute("IsTrapped") == true;

    if u2 == v17 then
        local v18 = v17 and Player.Optional.Humanoid(LocalPlayer);

        if v18 then
            v18:UnequipTools();
        end;
    else
        u2 = v17;

        if v17 then
            TrappedBackpackLock.SetLocked(true);
            local v19 = Player.Optional.Humanoid(LocalPlayer);

            if v19 then
                v19:UnequipTools();
            end;
        else
            TrappedBackpackLock.SetLocked(false);
        end;
    end;
end;

LocalPlayer.CharacterAdded:Connect(bindCharacter);
local v20 = Player.Optional.Character(LocalPlayer);

if v20 then
    bindCharacter(v20);
end;