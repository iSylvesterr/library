-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local u1 = assert(Players.LocalPlayer);
local v2 = {};
local u3 = nil;

local function getNotificationController() -- Line: 20
    -- upvalues: u3 (ref)
    if not u3 then
        local success, result = pcall(function() -- Line: 22
            return require(script.Parent:WaitForChild("NotificationController"));
        end);

        if success then
            u3 = result;
        end;
    end;

    return u3;
end;

local u4 = nil;

local function isHome() -- Line: 34
    -- upvalues: u1 (copy)
    return u1:GetAttribute("IsInOwnGarden") == true;
end;

local function dismiss() -- Line: 38
    -- upvalues: u4 (ref)
    if not u4 then
        return;
    end;

    u4:Dismiss();
    u4 = nil;
end;

local function buildText(p5, p6, p7, p8) -- Line: 44
    if p7 > 1 then
        p5 = `{p7} players`;
    end;

    local v9;

    if p6 == 1 and p8 ~= "" then
        v9 = `your {p8}`;
    else
        v9 = `{p6} of your crops`;
    end;

    return `<font color="#FF5555">{p5} stole {v9}!</font>`;
end;

local function show(p10, p11, p12, p13) -- Line: 54
    -- upvalues: u1 (copy), u4 (ref), u3 (ref)
    if u1:GetAttribute("IsInOwnGarden") == true then
        if not u4 then
            return;
        end;

        u4:Dismiss();
        u4 = nil;

        return;
    end;

    if p12 > 1 then
        p10 = `{p12} players`;
    end;

    local v14;

    if p11 == 1 and p13 ~= "" then
        v14 = `your {p13}`;
    else
        v14 = `{p11} of your crops`;
    end;

    local v15 = `<font color="#FF5555">{p10} stole {v14}!</font>`;

    if u4 then
        u4:SetText(v15);

        return;
    end;

    if not u3 then
        local success, result = pcall(function() -- Line: 22
            return require(script.Parent:WaitForChild("NotificationController"));
        end);

        if success then
            u3 = result;
        end;
    end;

    local v16 = u3;

    if not v16 then
        return;
    end;

    u4 = v16:CreateStickyNotification(v15);
end;

function v2.Start(p17) -- Line: 75
    -- upvalues: Networking (copy), show (copy), dismiss (copy), u1 (copy), u4 (ref)
    Networking.Steal.StolenFromAlert.OnClientEvent:Connect(function(p18, p19, p20, p21) -- Line: 76
        -- upvalues: show (ref)
        show(p18, p19, p20, p21);
    end);
    Networking.Steal.StolenFromCleared.OnClientEvent:Connect(dismiss);
    u1:GetAttributeChangedSignal("IsInOwnGarden"):Connect(function() -- Line: 84
        -- upvalues: u1 (ref), u4 (ref)
        if u1:GetAttribute("IsInOwnGarden") == true then
            if not u4 then
                return;
            end;

            u4:Dismiss();
            u4 = nil;
        end;
    end);
    task.spawn(function() -- Line: 94
        -- upvalues: u4 (ref), u1 (ref)
        while true do
            repeat
                task.wait(1);
            until u4 and (u1:GetAttribute("IsInOwnGarden") == true and u4);

            u4:Dismiss();
            u4 = nil;
        end;
    end);
end;

return v2;