-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
require(ReplicatedStorage.Database.Custom.Types);
local LevelsIcon = require(ReplicatedStorage.Database.Custom.GameStats.LevelsIcon);
local Settings = require(ReplicatedStorage.Interface.Screens.Menu.Settings);
local Report = require(script.Parent.Parent.Report);
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    ["Show Player Crosshairs"] = true,
    ["Show my crosshair when spectating bots"] = true
};
local u3 = { {
        maxLevel = 5,
        title = "Recruit"
    }, {
        maxLevel = 10,
        title = "Private"
    }, {
        maxLevel = 15,
        title = "Corporal"
    }, {
        maxLevel = 20,
        title = "Sergeant"
    }, {
        maxLevel = 25,
        title = "Master Sergeant"
    }, {
        maxLevel = 30,
        title = "Lieutenant"
    }, {
        maxLevel = 35,
        title = "Captain"
    }, {
        maxLevel = 40,
        title = "Global Elite"
    } };
local u4 = nil;
local u5 = nil;
local u6 = {};
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;

local function getRankTitle(p13) -- Line: 48
    -- upvalues: u3 (copy)
    for _, v in ipairs(u3) do
        if p13 <= v.maxLevel then
            return v.title;
        end;
    end;

    return "Global Elite";
end;

local function getBadgeIconFromItem(p14) -- Line: 57
    -- upvalues: Skins (copy)
    if typeof(p14) ~= "table" or p14.Name ~= "Badge" then
        return "";
    end;

    local v15 = Skins.GetSkinInformation(p14.Name, p14.Skin);

    return v15 and (Skins.GetWearImageForFloat(v15, p14.Float or 0.9999) or v15.imageAssetId or "") or "";
end;

local function collectPinLabels(p16) -- Line: 70
    local v17 = {};

    for _, child in p16:GetChildren() do
        if child:IsA("ImageLabel") and child.Name == "Pin" then
            table.insert(v17, child);
        end;
    end;

    table.sort(v17, function(p18, p19) -- Line: 78
        return p18.LayoutOrder < p19.LayoutOrder;
    end);

    return v17;
end;

local function getEquippedBadgeId(p20, p21, p22) -- Line: 85
    if typeof(p22) ~= "table" or not p21 then
        return nil;
    end;

    local v23 = p22[p21];

    if typeof(v23) ~= "table" or typeof(v23.Equipped) ~= "table" then
        return nil;
    end;

    local v24 = v23.Equipped["Equipped Badge"];

    if typeof(v24) == "string" and v24 ~= "" then
        return v24;
    end;

    return nil;
end;

local function populatePins(p25) -- Line: 103
    -- upvalues: DataController (copy), Skins (copy), u6 (ref)
    local v26 = p25:GetAttribute("Team");
    local v27, v28 = DataController.Get(p25, "Loadout", "Inventory");
    local v29;

    if typeof(v27) == "table" and v26 then
        local v30 = v27[v26];

        if typeof(v30) == "table" and typeof(v30.Equipped) == "table" then
            v29 = v30.Equipped["Equipped Badge"];

            if typeof(v29) ~= "string" or v29 == "" then
                v29 = nil;
            end;
        else
            v29 = nil;
        end;
    else
        v29 = nil;
    end;

    local v31 = nil;

    if v29 and typeof(v28) == "table" then
        for _, v in ipairs(v28) do
            if typeof(v) == "table" and (v._id == v29 and (v.Name == "Badge" and typeof(v.Skin) == "string")) then
                v31 = v.Skin;
                break;
            end;
        end;
    end;

    local v32 = nil;
    local v33 = {};
    local v34 = {};

    if typeof(v28) == "table" then
        for _, v in ipairs(v28) do
            if typeof(v) == "table" and (v.Name == "Badge" and (typeof(v.Skin) == "string" and (v.Skin ~= "" and not v34[v.Skin]))) then
                local v35;

                if typeof(v) == "table" and v.Name == "Badge" then
                    local v36 = Skins.GetSkinInformation(v.Name, v.Skin);
                    v35 = v36 and (Skins.GetWearImageForFloat(v36, v.Float or 0.9999) or (v36.imageAssetId or "")) or "";
                else
                    v35 = "";
                end;

                if v35 ~= "" then
                    v34[v.Skin] = true;

                    if v31 and v.Skin == v31 then
                        v32 = v35;
                    else
                        table.insert(v33, v35);
                    end;
                end;
            end;
        end;
    end;

    for i, v in ipairs(u6) do
        local v37;

        if i == 1 then
            v37 = v32;
        else
            v37 = v33[i - 1];
        end;

        if v37 then
            v.Image = v37;
            v.Visible = true;
        else
            v.Visible = false;
        end;
    end;
end;

local function populateLevel(p38) -- Line: 164
    -- upvalues: u7 (ref), u8 (ref), u9 (ref), DataController (copy), u3 (copy), LevelsIcon (copy)
    if not (u7 and (u8 and u9)) then
        return;
    end;

    local v39 = DataController.Get(p38, "Level");
    local v40, v41, v42;

    if typeof(v39) == "table" then
        v40 = v39.Level or 1;
        v41 = v39.Experience or 0;
        v42 = v39.NextExperienceRequirement or 1000;
    else
        v40 = 1;
        v42 = 1000;
        v41 = 0;
    end;

    local v43 = v40;
    local v44 = "Global Elite";

    for _, v in ipairs(u3) do
        if v40 <= v.maxLevel then
            v44 = v.title;
            break;
        end;
    end;

    u7.Text = `[{v44} Rank {v43}]`;
    u8.Image = LevelsIcon[tostring(v43)] or "";
    local v45 = v41 / math.max(v42, 1);
    local v46 = math.clamp(v45, 0, 1);
    local Y = u9.Size.Y;
    u9.Size = UDim2.new(v46, 0, Y.Scale, Y.Offset);
end;

local function updateActionButtons(p47) -- Line: 188
    -- upvalues: u10 (ref), LocalPlayer (copy), u11 (ref)
    if u10 then
        local v48;

        if p47 == nil then
            v48 = false;
        else
            v48 = p47 ~= LocalPlayer;
        end;

        u10.Active = v48;
    end;

    if u11 then
        u11.Visible = true;
        u11.Active = p47 ~= nil;
    end;
end;

local function copyPlayerCrosshair(p49) -- Line: 199
    -- upvalues: LocalPlayer (copy), DataController (copy), u2 (copy), Settings (copy)
    if p49 == LocalPlayer then
        return;
    end;

    local v50 = DataController.Get(p49, "Settings.Game.Crosshair");

    if typeof(v50) ~= "table" then
        return;
    end;

    for i, v in pairs(v50) do
        if not u2[i] then
            Settings.SettingChanged("Game", i, v);
        end;
    end;
end;

function v1.Bind(p51) -- Line: 216
    -- upvalues: u4 (ref), u5 (ref), u7 (ref), u8 (ref), u9 (ref), u6 (ref), collectPinLabels (copy), u10 (ref), ActivateButton (copy), u12 (ref), copyPlayerCrosshair (copy), u11 (ref), LocalPlayer (copy), Report (copy)
    local Info = p51:FindFirstChild("Info");
    local v52;

    if Info then
        v52 = Info:FindFirstChild("Player");
    else
        v52 = Info;
    end;

    local v53;

    if Info then
        v53 = Info:FindFirstChild("Pins");
    else
        v53 = Info;
    end;

    local v54;

    if Info then
        v54 = Info:FindFirstChild("Level");
    else
        v54 = Info;
    end;

    local v55;

    if v54 then
        v55 = v54:FindFirstChild("LevelBar");
    else
        v55 = v54;
    end;

    if v52 then
        v52 = v52:FindFirstChild("Avatar");
    end;

    u4 = v52;

    if Info then
        Info = Info:FindFirstChild("Username");
    end;

    u5 = Info;
    local v56;

    if v54 then
        v56 = v54:FindFirstChild("TextLabel");
    else
        v56 = v54;
    end;

    u7 = v56;

    if v54 then
        v54 = v54:FindFirstChild("Rank");
    end;

    u8 = v54;

    if v55 then
        v55 = v55:FindFirstChild("Current");
    end;

    u9 = v55;
    u6 = not (v53 and v53:IsA("Frame")) and {} or collectPinLabels(v53);
    local CopyCrosshair = p51:FindFirstChild("CopyCrosshair");

    if CopyCrosshair and CopyCrosshair:IsA("ImageButton") then
        u10 = CopyCrosshair;
        ActivateButton(CopyCrosshair);
        CopyCrosshair.MouseButton1Click:Connect(function() -- Line: 235
            -- upvalues: u12 (ref), copyPlayerCrosshair (ref)
            if u12 then
                copyPlayerCrosshair(u12);
            end;
        end);
    end;

    local Report2 = p51:FindFirstChild("Report");

    if Report2 and Report2:IsA("ImageButton") then
        u11 = Report2;
        ActivateButton(Report2);
        Report2.MouseButton1Click:Connect(function() -- Line: 246
            -- upvalues: u12 (ref), LocalPlayer (ref), Report (ref)
            if u12 and u12 ~= LocalPlayer then
                Report.Open(u12);
            end;
        end);
    end;
end;

function v1.Populate(p57) -- Line: 254
    -- upvalues: u12 (ref), u10 (ref), LocalPlayer (copy), u11 (ref), u4 (ref), u5 (ref), populatePins (copy), populateLevel (copy)
    u12 = p57;

    if u10 then
        local v58;

        if p57 == nil then
            v58 = false;
        else
            v58 = p57 ~= LocalPlayer;
        end;

        u10.Active = v58;
    end;

    if u11 then
        u11.Visible = true;
        u11.Active = p57 ~= nil;
    end;

    if u4 then
        u4.Image = `rbxthumb://type=AvatarHeadShot&id={p57.UserId}&w=150&h=150`;
    end;

    if u5 then
        u5.Text = p57.Name;
    end;

    populatePins(p57);
    populateLevel(p57);
end;

function v1.Reset() -- Line: 269
    -- upvalues: u12 (ref), u10 (ref), u11 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u4 (ref), u5 (ref)
    u12 = nil;

    if u10 then
        u10.Active = false;
    end;

    if u11 then
        u11.Visible = true;
        u11.Active = false;
    end;

    for _, v in u6 do
        v.Visible = false;
    end;

    if u7 then
        u7.Text = "";
    end;

    if u8 then
        u8.Image = "";
    end;

    if u9 then
        local Y = u9.Size.Y;
        u9.Size = UDim2.new(0, 0, Y.Scale, Y.Offset);
    end;

    if u4 then
        u4.Image = "";
    end;

    if u5 then
        u5.Text = "";
    end;
end;

return v1;