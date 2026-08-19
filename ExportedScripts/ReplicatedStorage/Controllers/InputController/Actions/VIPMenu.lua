-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;
local u2 = 0;

local function getVIPMenu() -- Line: 23
    -- upvalues: u1 (ref), ReplicatedStorage (copy)
    if u1 then
        return u1;
    end;

    local success, result = pcall(function() -- Line: 28
        -- upvalues: ReplicatedStorage (ref)
        return require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu);
    end);

    if success then
        u1 = result;

        return u1;
    end;

    warn((`Failed to load VIPMenu module: {tostring(result)}`));

    return nil;
end;

local function toggleVIPMenu() -- Line: 43
    -- upvalues: u2 (ref), LocalPlayer (copy), u1 (ref), ReplicatedStorage (copy)
    local v3 = os.clock();

    if v3 - u2 < 0.15 then
        return;
    end;

    u2 = v3;

    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        return;
    end;

    local v4;

    if u1 then
        v4 = u1;
    else
        local success, result = pcall(function() -- Line: 28
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu);
        end);

        if success then
            u1 = result;
            v4 = u1;
        else
            warn((`Failed to load VIPMenu module: {tostring(result)}`));
            v4 = nil;
        end;
    end;

    if v4 then
        v4.toggleFrame();
    end;
end;

return table.freeze({
    Name = "VIP Menu",
    Group = "Default",
    Category = "UI Keys",
    BindPriority = Enum.ContextActionPriority.High.Value + 1,

    Callback = function(p5, p6) -- Line: 63, Name: onInput
        -- upvalues: u2 (ref), LocalPlayer (copy), u1 (ref), ReplicatedStorage (copy)
        if p5 ~= Enum.UserInputState.Begin then
            return;
        end;

        local v7 = os.clock();

        if v7 - u2 < 0.15 then
            return;
        end;

        u2 = v7;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        local v8;

        if u1 then
            v8 = u1;
        else
            local success, result = pcall(function() -- Line: 28
                -- upvalues: ReplicatedStorage (ref)
                return require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu);
            end);

            if success then
                u1 = result;
                v8 = u1;
            else
                warn((`Failed to load VIPMenu module: {tostring(result)}`));
                v8 = nil;
            end;
        end;

        if v8 then
            v8.toggleFrame();
        end;
    end
});