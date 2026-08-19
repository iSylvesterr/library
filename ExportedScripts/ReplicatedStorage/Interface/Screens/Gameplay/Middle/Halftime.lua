-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local u2 = nil;
local u3 = 0;

local function hideHalftime() -- Line: 21
    -- upvalues: u3 (ref), u2 (ref)
    u3 = u3 + 1;
    u2.Visible = false;
end;

local function normalizeTeam(p4) -- Line: 26
    return (p4 == "Counter-Terrorists" or p4 == "CT") and "Counter-Terrorists" or ((p4 == "Terrorists" or p4 == "T") and "Terrorists" or nil);
end;

local function getContextText(p5) -- Line: 38
    return p5 == "Counter-Terrorists" and "Playing as Counter-Terrorists" or (p5 == "Terrorists" and "Playing as Terrorists" or nil);
end;

local function getHeader() -- Line: 50
    -- upvalues: u2 (ref)
    if not u2 then
        return nil;
    end;

    local Title = u2:FindFirstChild("Title");

    if Title then
        return Title:FindFirstChild("Header") or nil;
    end;

    return nil;
end;

local function getContextLabel(p6) -- Line: 68
    local Context = p6:FindFirstChild("Context");

    if Context and Context:IsA("TextLabel") then
        return Context;
    end;

    return nil;
end;

local function updateHeaderTeamVisibility(u7, p8) -- Line: 77
    local v9 = p8 == "Counter-Terrorists";
    local v10 = not v9;
    local u11 = false;

    local function setVisibleIfGuiObject(p12, p13) -- Line: 82
        -- upvalues: u7 (copy), u11 (ref)
        local v14 = u7:FindFirstChild(p12);

        if v14 and v14:IsA("GuiObject") then
            v14.Visible = p13;
            u11 = true;
        end;
    end;

    local CT = u7:FindFirstChild("CT");

    if CT and CT:IsA("GuiObject") then
        CT.Visible = v9;
        u11 = true;
    end;

    local T = u7:FindFirstChild("T");

    if T and T:IsA("GuiObject") then
        T.Visible = v10;
        u11 = true;
    end;

    local PlayingCT = u7:FindFirstChild("PlayingCT");

    if PlayingCT and PlayingCT:IsA("GuiObject") then
        PlayingCT.Visible = v9;
        u11 = true;
    end;

    local PlayingT = u7:FindFirstChild("PlayingT");

    if PlayingT and PlayingT:IsA("GuiObject") then
        PlayingT.Visible = v10;
        u11 = true;
    end;

    return u11;
end;

local function showHalftime(p15, p16) -- Line: 98
    -- upvalues: u3 (ref), u2 (ref), updateHeaderTeamVisibility (copy)
    local v17 = (p15 == "Counter-Terrorists" or p15 == "CT") and "Counter-Terrorists" or ((p15 == "Terrorists" or p15 == "T") and "Terrorists" or nil);

    if not v17 then
        warn(("[Halftime] Unsupported NextTeam value: %s"):format((tostring(p15))));
        u3 = u3 + 1;
        u2.Visible = false;

        return false;
    end;

    local v18 = v17 == "Counter-Terrorists" and "Playing as Counter-Terrorists" or (v17 == "Terrorists" and "Playing as Terrorists" or nil);

    if not v18 then
        warn(("[Halftime] Unsupported NextTeam value: %s"):format((tostring(p15))));
        u3 = u3 + 1;
        u2.Visible = false;

        return false;
    end;

    local v19;

    if u2 then
        local Title = u2:FindFirstChild("Title");

        if Title then
            v19 = Title:FindFirstChild("Header") or nil;
        else
            v19 = nil;
        end;
    else
        v19 = nil;
    end;

    if not v19 then
        warn("[Halftime] Missing Title.Header");
        u3 = u3 + 1;
        u2.Visible = false;

        return false;
    end;

    local Context = v19:FindFirstChild("Context");

    if not (Context and Context:IsA("TextLabel")) then
        Context = nil;
    end;

    if not (updateHeaderTeamVisibility(v19, v17) or Context) then
        warn("[Halftime] Missing Title.Header CT/T + PlayingCT/PlayingT visuals and Context TextLabel");
        u3 = u3 + 1;
        u2.Visible = false;

        return false;
    end;

    if Context then
        Context.Text = v18;
    end;

    u3 = u3 + 1;
    local u20 = u3;
    u2.Visible = true;

    if p16 ~= nil then
        local v21 = tonumber(p16) or 0;
        local v22 = math.max(v21, 0);
        task.delay(v22, function() -- Line: 139
            -- upvalues: u20 (copy), u3 (ref), u2 (ref)
            if u20 ~= u3 then
                return;
            end;

            u2.Visible = false;
        end);
    end;

    return true;
end;

function v1.Show(p23, p24) -- Line: 153
    -- upvalues: u2 (ref), showHalftime (copy)
    if u2 then
        return showHalftime(p23, p24);
    end;

    warn("[Halftime] Frame is not initialized");

    return false;
end;

function v1.Hide() -- Line: 162
    -- upvalues: u2 (ref), u3 (ref)
    if not u2 then
        return;
    end;

    u3 = u3 + 1;
    u2.Visible = false;
end;

function v1.Initialize(p25, p26) -- Line: 170
    -- upvalues: u2 (ref), GameState (copy), u3 (ref)
    u2 = p26;
    u2.Visible = false;
    GameState.ListenToState(function(p27, p28) -- Line: 174
        -- upvalues: u3 (ref), u2 (ref)
        if p28 == "Buy Period" or p28 == "Round In Progress" then
            u3 = u3 + 1;
            u2.Visible = false;
        end;
    end);
end;

return v1;