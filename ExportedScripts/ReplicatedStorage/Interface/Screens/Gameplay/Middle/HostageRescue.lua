-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = {};
local u3 = nil;

local function UpdateTemplateState(p4, p5) -- Line: 37
    p4.Idle.Visible = p5 ~= "Carrying";
    p4.Action.Visible = p5 == "Carrying";
end;

local function ClearFrame(p6) -- Line: 44
    -- upvalues: u2 (copy)
    for _, child in ipairs(p6:GetChildren()) do
        if u2[child] then
            u2[child]:Destroy();
            u2[child] = nil;
        end;
    end;
end;

local function UpdateTemplateSizes() -- Line: 56
    -- upvalues: u3 (ref)
    local v7 = {};

    for _, child in ipairs(u3:GetChildren()) do
        if child:IsA("Frame") then
            table.insert(v7, child);
        end;
    end;

    for _, v in ipairs(v7) do
        v.Size = UDim2.fromScale(1 / #v7, 1);
    end;
end;

local function UpdatePosition(p8) -- Line: 72
    -- upvalues: u3 (ref)
    if not u3 then
        return;
    end;

    u3.Position = UDim2.new(0.029, 0, 0, 240 - (200 - p8 * 200) + 50);
end;

local function UpdateVisibility() -- Line: 93
    -- upvalues: u3 (ref)
    if not u3 then
        return;
    end;

    u3.Visible = workspace:GetAttribute("Gamemode") == "Hostage Rescue";
end;

function u1.CreateTemplate(p9) -- Line: 104
    -- upvalues: ReplicatedStorage (copy), u3 (ref), UpdateTemplateSizes (copy)
    local v10 = ReplicatedStorage.Assets.UI.HostageRescue.Template:Clone();
    v10.Parent = u3;
    UpdateTemplateSizes();

    return v10;
end;

function u1.Initialize(p11, p12) -- Line: 116
    -- upvalues: u3 (ref), DataController (copy), LocalPlayer (copy), UpdateVisibility (copy), GameState (copy), ClearFrame (copy), Observers (copy), Janitor (copy), UpdateTemplateSizes (copy), u1 (copy), u2 (copy)
    u3 = p12;
    DataController.CreateListener(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Hud Size", function(p13) -- Line: 120
        -- upvalues: u3 (ref)
        if not u3 then
            return;
        end;

        u3.Position = UDim2.new(0.029, 0, 0, 240 - (200 - p13 * 200) + 50);
    end);
    local v14 = DataController.Get(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Hud Size") or 1;

    if u3 then
        u3.Position = UDim2.new(0.029, 0, 0, 240 - (200 - v14 * 200) + 50);
    end;

    if u3 then
        u3.Visible = workspace:GetAttribute("Gamemode") == "Hostage Rescue";
    end;

    workspace:GetAttributeChangedSignal("Gamemode"):Connect(UpdateVisibility);
    GameState.ListenToState(function(p15, p16) -- Line: 133
        -- upvalues: ClearFrame (ref), u3 (ref)
        if p16 ~= "Buy Period" and p16 ~= "Warmup" then
            return;
        end;

        ClearFrame(u3);
    end);
    Observers.observeTag("Hostage", function(u17) -- Line: 141
        -- upvalues: Janitor (ref), UpdateTemplateSizes (ref), u1 (ref), u2 (ref)
        local v18 = Janitor.new();
        v18:Add(UpdateTemplateSizes);
        local u19 = v18:Add(u1.CreateTemplate(u17));
        u2[u19] = v18;
        local v20 = u17:GetAttribute("State") or "Idle";
        u19.Idle.Visible = v20 ~= "Carrying";
        u19.Action.Visible = v20 == "Carrying";
        v18:Add(u17:GetAttributeChangedSignal("State"):Connect(function() -- Line: 150
            -- upvalues: u19 (copy), u17 (copy)
            local v21 = u19;
            local v22 = u17:GetAttribute("State") or "Idle";
            v21.Idle.Visible = v22 ~= "Carrying";
            v21.Action.Visible = v22 == "Carrying";
        end));

        return function() -- Line: 154
            -- upvalues: u2 (ref), u19 (copy)
            if u2[u19] then
                u2[u19]:Destroy();
                u2[u19] = nil;
            end;
        end;
    end);
end;

return u1;