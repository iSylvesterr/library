-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ConfigController = require(ReplicatedStorage.Controllers.ConfigController);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Missions = require(ReplicatedStorage.Database.Custom.GameStats.Missions);
local ConfigKeys = require(ReplicatedStorage.Database.Custom.ConfigKeys);
require(ReplicatedStorage.Database.Custom.Types);
local u1 = Color3.fromRGB(255, 255, 255);
local u2 = UDim2.fromScale(0.5, -1.5);
local u3 = UDim2.fromScale(0.1, 1);
local u4 = UDim2.fromScale(0.5, 0.5);
local u5 = UDim2.fromScale(8, 1);
local u6 = {
    hourly = Color3.fromRGB(208, 182, 68),
    daily = Color3.fromRGB(21, 208, 11),
    weekly = Color3.fromRGB(76, 154, 255),
    monthly = Color3.fromRGB(160, 68, 191)
};
local u7 = Color3.fromRGB(255, 255, 255);
local u8 = {
    hourly = "HOURLY MISSION",
    daily = "DAILY MISSION",
    weekly = "WEEKLY MISSION",
    monthly = "MONTHLY MISSION"
};
local v9 = {};
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = {};
local u18 = {};
local u19 = false;
local u20 = {};
local u21 = false;
local u22 = nil;

local function CommaNumber(p23) -- Line: 98
    return tostring(p23):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function ColorToHex(p24) -- Line: 104
    return string.format("#%02X%02X%02X", math.round(p24.R * 255), math.round(p24.G * 255), (math.round(p24.B * 255)));
end;

local function GetMissionKey(p25) -- Line: 115
    return `{p25.MissionId}:{p25.CreatedAt}`;
end;

local function GetCreditRewardAmount(p26, p27) -- Line: 121
    -- upvalues: ConfigKeys (copy), ConfigController (copy)
    local v28 = ConfigKeys.Shared.MissionCreditRewardMultipliers[p26];
    local v29 = not v28 and 1 or ConfigController.GetRewardMultiplier(v28);

    return math.round(p27 * v29);
end;

local function CancelActiveTweens() -- Line: 129
    -- upvalues: u17 (copy)
    for _, v in u17 do
        v:Cancel();
    end;

    table.clear(u17);
end;

local function PlayTween(p30, p31, p32) -- Line: 138
    -- upvalues: TweenService (copy), u17 (copy)
    local v33 = TweenService:Create(p30, p31, p32);
    table.insert(u17, v33);
    v33:Play();

    return v33;
end;

local function SetTextLabelTransparent(p34, p35) -- Line: 147
    local v36 = p35 and 1 or 0;
    p34.TextTransparency = v36;
    p34.TextStrokeTransparency = v36;
end;

local function SetImageLabelTransparent(p37, p38) -- Line: 155
    p37.ImageTransparency = p38 and 1 or 0;
end;

local function SetContentTransparent(p39) -- Line: 161
    -- upvalues: u12 (ref), u13 (ref), u14 (ref), u15 (ref)
    if u12 then
        local v40 = u12;
        local v41 = p39 and 1 or 0;
        v40.TextTransparency = v41;
        v40.TextStrokeTransparency = v41;
    end;

    if u13 then
        local v42 = u13;
        local v43 = p39 and 1 or 0;
        v42.TextTransparency = v43;
        v42.TextStrokeTransparency = v43;
    end;

    if u14 then
        u14.ImageTransparency = p39 and 1 or 0;
    end;

    if u15 then
        u15.ImageTransparency = p39 and 1 or 0;
    end;
end;

local function ResetFramePresentation() -- Line: 178
    -- upvalues: u17 (copy), u11 (ref), u2 (copy), u3 (copy), u12 (ref), u13 (ref), u14 (ref), u15 (ref)
    for _, v in u17 do
        v:Cancel();
    end;

    table.clear(u17);

    if u11 then
        u11.Position = u2;
        u11.Size = u3;
    end;

    if u12 then
        local v44 = u12;
        v44.TextTransparency = 1;
        v44.TextStrokeTransparency = 1;
    end;

    if u13 then
        local v45 = u13;
        v45.TextTransparency = 1;
        v45.TextStrokeTransparency = 1;
    end;

    if u14 then
        u14.ImageTransparency = 1;
    end;

    if u15 then
        u15.ImageTransparency = 1;
    end;
end;

local function ApplyHUDColor() -- Line: 191
    -- upvalues: u11 (ref), GetPreferenceColor (copy)
    if u11 then
        u11.BackgroundColor3 = GetPreferenceColor();
    end;
end;

local function IsMissionsNotificationsEnabled() -- Line: 199
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return DataController.Get(LocalPlayer, "Settings.Game.HUD.Enable Missions Notifications") ~= false;
end;

local function ShowEntry(p46, u47) -- Line: 205
    -- upvalues: u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u17 (copy), u1 (copy), u16 (ref), u15 (ref), GetPreferenceColor (copy), u2 (copy), u3 (copy), Router (copy), u4 (copy), TweenService (copy), u5 (copy)
    if not (u10 and (u11 and (u12 and (u13 and u14)))) then
        return;
    end;

    for _, v in u17 do
        v:Cancel();
    end;

    table.clear(u17);
    u12.RichText = true;
    u12.TextColor3 = u1;
    u12.Text = `<font color="{p46.colorHex}">{p46.typeLabel}</font> COMPLETED`;
    u13.Text = p46.objective;

    if p46.creditAmount then
        u14.Image = "rbxassetid://129921992230064";

        if u16 then
            u16.Text = `x{tostring(p46.creditAmount):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
        end;
    end;

    u14.Visible = p46.creditAmount ~= nil;

    if u15 then
        u15.Visible = p46.creditAmount ~= nil;
    end;

    if u11 then
        u11.BackgroundColor3 = GetPreferenceColor();
    end;

    u11.Position = u2;
    u11.Size = u3;

    if u12 then
        local v48 = u12;
        v48.TextTransparency = 1;
        v48.TextStrokeTransparency = 1;
    end;

    if u13 then
        local v49 = u13;
        v49.TextTransparency = 1;
        v49.TextStrokeTransparency = 1;
    end;

    if u14 then
        u14.ImageTransparency = 1;
    end;

    if u15 then
        u15.ImageTransparency = 1;
    end;

    u10.Visible = true;
    Router.broadcastRouter("RunInterfaceSound", "Mission Completed");
    local v50 = TweenService:Create(u11, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
        Position = u4
    });
    table.insert(u17, v50);
    v50:Play();
    v50.Completed:Once(function(p51) -- Line: 242
        -- upvalues: u10 (ref), u11 (ref), u5 (ref), TweenService (ref), u17 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u47 (copy)
        if p51 ~= Enum.PlaybackState.Completed then
            return;
        end;

        task.delay(0.1, function() -- Line: 247
            -- upvalues: u10 (ref), u11 (ref), u5 (ref), TweenService (ref), u17 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u47 (ref)
            if not (u10 and (u10.Visible and u11)) then
                return;
            end;

            local v52 = TweenInfo.new(0.5, Enum.EasingStyle.Linear);
            local v53 = TweenService:Create(u11, v52, {
                Size = u5
            });
            table.insert(u17, v53);
            v53:Play();

            if u12 then
                local v54 = TweenService:Create(u12, v52, {
                    TextTransparency = 0,
                    TextStrokeTransparency = 0
                });
                table.insert(u17, v54);
                v54:Play();
            end;

            if u13 then
                local v55 = TweenService:Create(u13, v52, {
                    TextTransparency = 0,
                    TextStrokeTransparency = 0
                });
                table.insert(u17, v55);
                v55:Play();
            end;

            if u14 then
                local v56 = TweenService:Create(u14, v52, {
                    ImageTransparency = 0
                });
                table.insert(u17, v56);
                v56:Play();
            end;

            if u15 then
                local v57 = TweenService:Create(u15, v52, {
                    ImageTransparency = 0
                });
                table.insert(u17, v57);
                v57:Play();
            end;

            task.delay(0.5, u47);
        end);
    end);
end;

local function FinishDisplay() -- Line: 282
    -- upvalues: u20 (copy), u21 (ref), u22 (ref), u10 (ref), u17 (copy), u11 (ref), u2 (copy), u3 (copy), u12 (ref), u13 (ref), u14 (ref), u15 (ref)
    table.remove(u20, 1);
    u21 = false;

    if #u20 > 0 then
        u22();

        return;
    end;

    if u10 then
        u10.Visible = false;

        for _, v in u17 do
            v:Cancel();
        end;

        table.clear(u17);

        if u11 then
            u11.Position = u2;
            u11.Size = u3;
        end;

        if u12 then
            local v58 = u12;
            v58.TextTransparency = 1;
            v58.TextStrokeTransparency = 1;
        end;

        if u13 then
            local v59 = u13;
            v59.TextTransparency = 1;
            v59.TextStrokeTransparency = 1;
        end;

        if u14 then
            u14.ImageTransparency = 1;
        end;

        if u15 then
            u15.ImageTransparency = 1;
        end;
    end;
end;

u22 = function() -- Line: 295, Name: ProcessQueue
    -- upvalues: u21 (ref), u20 (copy), u10 (ref), u17 (copy), u11 (ref), u2 (copy), u3 (copy), u12 (ref), u13 (ref), u14 (ref), u15 (ref), ShowEntry (copy), FinishDisplay (copy)
    if u21 then
        return;
    end;

    local v60 = u20[1];

    if not v60 then
        if u10 then
            u10.Visible = false;

            for _, v in u17 do
                v:Cancel();
            end;

            table.clear(u17);

            if u11 then
                u11.Position = u2;
                u11.Size = u3;
            end;

            if u12 then
                local v61 = u12;
                v61.TextTransparency = 1;
                v61.TextStrokeTransparency = 1;
            end;

            if u13 then
                local v62 = u13;
                v62.TextTransparency = 1;
                v62.TextStrokeTransparency = 1;
            end;

            if u14 then
                u14.ImageTransparency = 1;
            end;

            if u15 then
                u15.ImageTransparency = 1;
            end;
        end;

        return;
    end;

    u21 = true;
    ShowEntry(v60, function() -- Line: 310
        -- upvalues: FinishDisplay (ref)
        task.delay(4.5, FinishDisplay);
    end);
end;

local function BuildEntry(p63) -- Line: 317
    -- upvalues: Missions (copy), ConfigKeys (copy), ConfigController (copy), u8 (copy), u6 (copy), u7 (copy)
    local v64 = Missions.GetMissionDefinition(p63.MissionId);

    if not v64 then
        return nil;
    end;

    local Type = v64.Type;
    local v65 = nil;
    local v66 = v64.Rewards and v64.Rewards[1];

    if v66 and (v66.type == "Credits" and typeof(v66.amount) == "number") then
        local amount = v66.amount;
        local v67 = ConfigKeys.Shared.MissionCreditRewardMultipliers[Type];
        local v68 = not v67 and 1 or ConfigController.GetRewardMultiplier(v67);
        v65 = math.round(amount * v68);
    end;

    local v69 = {
        typeLabel = u8[Type] or "MISSION"
    };
    local v70 = u6[Type] or u7;
    v69.colorHex = string.format("#%02X%02X%02X", math.round(v70.R * 255), math.round(v70.G * 255), (math.round(v70.B * 255)));
    v69.objective = v64.DisplayName or v64.MissionId;
    v69.creditAmount = v65;

    return v69;
end;

local function EnqueueDisplayEntry(p71) -- Line: 340
    -- upvalues: u20 (copy), u22 (ref)
    table.insert(u20, p71);
    u22();
end;

local function OnMissionsChanged(p72) -- Line: 347
    -- upvalues: u18 (copy), u19 (ref), DataController (copy), LocalPlayer (copy), BuildEntry (copy), u20 (copy), u22 (ref)
    if typeof(p72) ~= "table" then
        return;
    end;

    local v73 = {};

    for _, v in ipairs(p72) do
        if typeof(v) == "table" and typeof(v.MissionId) == "string" then
            local v74 = `{v.MissionId}:{v.CreatedAt}`;
            v73[v74] = true;

            if (v.Progress or 0) >= (v.Target or (1 / 0)) and not v.IsClaimed and not u18[v74] then
                u18[v74] = true;

                if u19 and DataController.Get(LocalPlayer, "Settings.Game.HUD.Enable Missions Notifications") ~= false then
                    local v75 = BuildEntry(v);

                    if v75 then
                        table.insert(u20, v75);
                        u22();
                    end;
                end;
            end;
        end;
    end;

    for i in pairs(u18) do
        if not v73[i] then
            u18[i] = nil;
        end;
    end;

    u19 = true;
end;

function v9.Initialize(p76, p77) -- Line: 389
    -- upvalues: u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u16 (ref), u15 (ref), u17 (copy), u2 (copy), u3 (copy), DataController (copy), LocalPlayer (copy), OnMissionsChanged (copy), GetPreferenceColor (copy)
    u10 = p77;
    u11 = p77:FindFirstChild("Frame");
    local v78 = u11 and u11:FindFirstChild("Container");
    local v79;

    if v78 then
        v79 = v78:FindFirstChild("Info");
    else
        v79 = v78;
    end;

    local v80;

    if v78 then
        v80 = v78:FindFirstChild("Reward");
    else
        v80 = v78;
    end;

    local v81;

    if v79 then
        v81 = v79:FindFirstChild("Title");
    else
        v81 = v79;
    end;

    u12 = v81;

    if v79 then
        v79 = v79:FindFirstChild("Objective");
    end;

    u13 = v79;

    if v80 then
        v80 = v80:FindFirstChild("Icon");
    end;

    u14 = v80;
    local v82 = u14 and u14:FindFirstChild("Amount");
    u16 = v82;

    if v78 then
        for _, descendant in v78:GetDescendants() do
            if descendant:IsA("ImageLabel") and descendant ~= u14 then
                u15 = descendant;
                break;
            end;
        end;
    end;

    if not (u11 and (u12 and (u13 and u14))) then
        warn("[MissionCompleted] Missing expected UI elements; popup disabled.");

        return;
    end;

    p77.Visible = false;

    for _, v in u17 do
        v:Cancel();
    end;

    table.clear(u17);

    if u11 then
        u11.Position = u2;
        u11.Size = u3;
    end;

    if u12 then
        local v83 = u12;
        v83.TextTransparency = 1;
        v83.TextStrokeTransparency = 1;
    end;

    if u13 then
        local v84 = u13;
        v84.TextTransparency = 1;
        v84.TextStrokeTransparency = 1;
    end;

    if u14 then
        u14.ImageTransparency = 1;
    end;

    if u15 then
        u15.ImageTransparency = 1;
    end;

    DataController.CreateListener(LocalPlayer, "Missions", OnMissionsChanged);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 419
        -- upvalues: u10 (ref), u11 (ref), GetPreferenceColor (ref)
        if u10 and (u10.Visible and u11) then
            u11.BackgroundColor3 = GetPreferenceColor();
        end;
    end);
end;

return v9;