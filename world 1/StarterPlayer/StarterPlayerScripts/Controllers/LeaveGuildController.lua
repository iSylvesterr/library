-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local MessagePrompt = require(ReplicatedStorage.ClientModules.MessagePrompt);
local NotificationController = require(Players.LocalPlayer.PlayerScripts.Controllers.NotificationController);
local v1 = {
    StartOrder = 9
};

local function HexFromMaybe(p2) -- Line: 24
    if typeof(p2) ~= "string" or p2 == "" then
        return "#FFFFFF";
    end;

    if string.sub(p2, 1, 1) == "#" then
        return p2;
    end;

    return "#" .. p2;
end;

local function EscapeRichText(p3) -- Line: 34
    local v4 = string.gsub(p3, "&", "&amp;");
    local v5 = string.gsub(v4, "<", "&lt;");
    local v6 = string.gsub(v5, ">", "&gt;");

    return string.gsub(v6, "\"", "&quot;");
end;

local function BuildMessage(p7, p8, p9, p10) -- Line: 42
    -- upvalues: EscapeRichText (copy)
    local v11 = EscapeRichText(p7);
    local v12 = EscapeRichText(p8);

    return string.format("Are you sure you want to %s <font color=\"%s\">%s</font> <font color=\"%s\">[%s]</font>?", p10 and "disband" or "leave", p9, v11, p9, v12);
end;

local function FireLeave(u13, u14) -- Line: 52
    -- upvalues: Networking (copy), NotificationController (copy)
    task.spawn(function() -- Line: 53
        -- upvalues: Networking (ref), u14 (copy), NotificationController (ref), u13 (copy)
        local v15, v16, v17 = pcall(function() -- Line: 54
            -- upvalues: Networking (ref)
            return Networking.Guild.Leave:Fire();
        end);

        if v15 and v16 then
            NotificationController:CreateNotification(string.format("%s %s", u14 and "Disbanded" or "Left", u13));

            return;
        end;

        NotificationController:CreateNotification((typeof(v17) ~= "string" or v17 == "") and (u14 and "Could not disband guild" or "Could not leave guild") or v17);
    end);
end;

function v1.Open(p18, p19) -- Line: 83
    -- upvalues: MessagePrompt (copy), EscapeRichText (copy), Networking (copy), NotificationController (copy)
    local u20 = p19 and typeof(p19.Name) == "string" and (p19.Name or "Guild Name") or "Guild Name";
    local u21 = p19 and typeof(p19.Tag) == "string" and (p19.Tag or "TAG") or "TAG";
    local u22;

    if p19 then
        u22 = p19.Color;
    else
        u22 = p19;
    end;

    if typeof(u22) == "string" and u22 ~= "" then
        if string.sub(u22, 1, 1) ~= "#" then
            u22 = "#" .. u22;
        end;
    else
        u22 = "#FFFFFF";
    end;

    local u23;

    if p19 == nil then
        u23 = false;
    else
        u23 = p19.IsOwner == true;
    end;

    task.spawn(function() -- Line: 97
        -- upvalues: MessagePrompt (ref), u20 (copy), u21 (copy), u22 (copy), u23 (copy), EscapeRichText (ref), Networking (ref), NotificationController (ref)
        local Prompt = MessagePrompt.Prompt;
        local v24 = {
            yield = true,
            dontRestoreOnSuccess = true
        };
        local v25 = u22;
        local v26 = EscapeRichText(u20);
        local v27 = EscapeRichText(u21);
        v24.message = string.format("Are you sure you want to %s <font color=\"%s\">%s</font> <font color=\"%s\">[%s]</font>?", u23 and "disband" or "leave", v25, v26, v25, v27);
        v24.titleOverride = u23 and "Disband Guild" or "Leave Guild";
        v24.options = MessagePrompt.Choices.YesNo;

        if Prompt(v24) then
            local u28 = u20;
            local u29 = u23;
            task.spawn(function() -- Line: 53
                -- upvalues: Networking (ref), u29 (copy), NotificationController (ref), u28 (copy)
                local v30, v31, v32 = pcall(function() -- Line: 54
                    -- upvalues: Networking (ref)
                    return Networking.Guild.Leave:Fire();
                end);

                if v30 and v31 then
                    NotificationController:CreateNotification(string.format("%s %s", u29 and "Disbanded" or "Left", u28));

                    return;
                end;

                NotificationController:CreateNotification((typeof(v32) ~= "string" or v32 == "") and (u29 and "Could not disband guild" or "Could not leave guild") or v32);
            end);
        end;
    end);
end;

function v1.Close(p33) -- Line: 116
end;

function v1.Init(p34) -- Line: 118
end;

function v1.Start(p35) -- Line: 120
end;

return v1;