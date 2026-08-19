-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local ServerClock = require(ReplicatedStorage.ClientModules.ServerClock);
local Asserts = require(ReplicatedStorage.SharedModules.Guild.Asserts);
local IconPool = require(ReplicatedStorage.SharedModules.Guild.IconPool);
local MarketplaceServiceHelper = require(ReplicatedStorage.UserGenerated.Roblox.MarketplaceServiceHelper);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local ColorPickerGuildController = require(LocalPlayer.PlayerScripts.Controllers.ColorPickerGuildController);
local MAX_NAME_LENGTH = Asserts.MAX_NAME_LENGTH;
local _ = Asserts.MIN_TAG_LENGTH;
local MAX_TAG_LENGTH = Asserts.MAX_TAG_LENGTH;
local MAX_DESCRIPTION_LENGTH = Asserts.MAX_DESCRIPTION_LENGTH;
local u1 = Color3.fromRGB(110, 231, 167);
local u2 = {
    [1] = true,
    [13] = true
};
local v3 = {
    StartOrder = 9
};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = "";
local u19 = "";
local u20 = "";
local u21 = u1;
local u22 = u1;
local u23 = u1;
local DEFAULT_ICON_ID = IconPool.DEFAULT_ICON_ID;
local u24 = 0;
local u25 = false;

local function utf8Len(p26) -- Line: 92
    return utf8.len(p26) or #p26;
end;

local function utf8Truncate(p27, p28) -- Line: 96
    local v29 = utf8.len(p27);

    if not v29 or v29 <= p28 then
        return p27;
    end;

    local v30 = utf8.offset(p27, p28 + 1);

    if v30 then
        return string.sub(p27, 1, v30 - 1);
    end;

    return string.sub(p27, 1, p28);
end;

local function trim(p31) -- Line: 106
    return string.gsub(p31, "^%s*(.-)%s*$", "%1");
end;

local function color3ToHex(p32) -- Line: 110
    local format = string.format;
    local v33 = math.floor(p32.R * 255 + 0.5);
    local v34 = math.clamp(v33, 0, 255);
    local v35 = math.floor(p32.G * 255 + 0.5);
    local v36 = math.clamp(v35, 0, 255);
    local v37 = math.floor(p32.B * 255 + 0.5);

    return format("#%02X%02X%02X", v34, v36, (math.clamp(v37, 0, 255)));
end;

local function hexToColor3(p38) -- Line: 119
    -- upvalues: u1 (copy)
    if typeof(p38) ~= "string" or p38 == "" then
        return u1;
    end;

    if string.sub(p38, 1, 1) == "#" then
        p38 = string.sub(p38, 2);
    end;

    if #p38 ~= 6 then
        return u1;
    end;

    local v39 = string.sub(p38, 1, 2);
    local v40 = tonumber(v39, 16);
    local v41 = string.sub(p38, 3, 4);
    local v42 = tonumber(v41, 16);
    local v43 = string.sub(p38, 5, 6);
    local v44 = tonumber(v43, 16);

    if v40 and (v42 and v44) then
        return Color3.fromRGB(v40, v42, v44);
    end;

    return u1;
end;

local function color3Equal(p45, p46) -- Line: 130
    local v47;

    if math.abs(p45.R - p46.R) < 0.001 and math.abs(p45.G - p46.G) < 0.001 then
        v47 = math.abs(p45.B - p46.B) < 0.001;
    else
        v47 = false;
    end;

    return v47;
end;

local function formatCooldownDH(p48) -- Line: 139
    local v49 = math.floor(p48 + 0.5);
    local v50 = math.max(0, v49);
    local v51 = v50 // 86400;
    local v52 = (v50 - v51 * 86400) // 3600;

    return string.format("%dd %dh", v51, v51 <= 0 and v52 <= 0 and 1 or v52);
end;

local function isNameDirty() -- Line: 150
    -- upvalues: u17 (ref), u18 (ref)
    if not u17 then
        return false;
    end;

    local v53;

    if string.gsub(u18, "^%s*(.-)%s*$", "%1") == u17.Name then
        v53 = false;
    else
        v53 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    end;

    return v53;
end;

local function isTagDirty() -- Line: 155
    -- upvalues: u17 (ref), u19 (ref)
    if not u17 then
        return false;
    end;

    local v54;

    if string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) == u17.Tag then
        v54 = false;
    else
        v54 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
    end;

    return v54;
end;

local function isDescriptionDirty() -- Line: 160
    -- upvalues: u17 (ref), u20 (ref)
    if not u17 then
        return false;
    end;

    local v55;

    if string.gsub(u20, "^%s*(.-)%s*$", "%1") == u17.Description then
        v55 = false;
    else
        v55 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
    end;

    return v55;
end;

local function isNameColorDirty() -- Line: 167
    -- upvalues: u17 (ref), u21 (ref)
    if not u17 then
        return false;
    end;

    local v56 = u21;
    local Color = u17.Color;
    local v57;

    if math.abs(v56.R - Color.R) < 0.001 and math.abs(v56.G - Color.G) < 0.001 then
        v57 = math.abs(v56.B - Color.B) < 0.001;
    else
        v57 = false;
    end;

    return not v57;
end;

local function isTagColorDirty() -- Line: 172
    -- upvalues: u17 (ref), u22 (ref)
    if not u17 then
        return false;
    end;

    local v58 = u22;
    local TagColor = u17.TagColor;
    local v59;

    if math.abs(v58.R - TagColor.R) < 0.001 and math.abs(v58.G - TagColor.G) < 0.001 then
        v59 = math.abs(v58.B - TagColor.B) < 0.001;
    else
        v59 = false;
    end;

    return not v59;
end;

local function isDescriptionColorDirty() -- Line: 177
    -- upvalues: u17 (ref), u23 (ref)
    if not u17 then
        return false;
    end;

    local v60 = u23;
    local DescriptionColor = u17.DescriptionColor;
    local v61;

    if math.abs(v60.R - DescriptionColor.R) < 0.001 and math.abs(v60.G - DescriptionColor.G) < 0.001 then
        v61 = math.abs(v60.B - DescriptionColor.B) < 0.001;
    else
        v61 = false;
    end;

    return not v61;
end;

local function isIconDirty() -- Line: 182
    -- upvalues: u17 (ref), DEFAULT_ICON_ID (ref)
    if u17 then
        return DEFAULT_ICON_ID ~= u17.IconId;
    end;

    return false;
end;

local function hasAnyChanges() -- Line: 187
    -- upvalues: u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref)
    local v62;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v62 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v62 = false;
    end;

    if not v62 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v62 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v62 = false;
        end;

        if not v62 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v62 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v62 = false;
            end;

            if not v62 then
                if u17 then
                    local v63 = u21;
                    local Color = u17.Color;
                    local v64;

                    if math.abs(v63.R - Color.R) < 0.001 and math.abs(v63.G - Color.G) < 0.001 then
                        v64 = math.abs(v63.B - Color.B) < 0.001;
                    else
                        v64 = false;
                    end;

                    v62 = not v64;
                else
                    v62 = false;
                end;

                if not v62 then
                    if u17 then
                        local v65 = u22;
                        local TagColor = u17.TagColor;
                        local v66;

                        if math.abs(v65.R - TagColor.R) < 0.001 and math.abs(v65.G - TagColor.G) < 0.001 then
                            v66 = math.abs(v65.B - TagColor.B) < 0.001;
                        else
                            v66 = false;
                        end;

                        v62 = not v66;
                    else
                        v62 = false;
                    end;

                    if not v62 then
                        if u17 then
                            local v67 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v68;

                            if math.abs(v67.R - DescriptionColor.R) < 0.001 and math.abs(v67.G - DescriptionColor.G) < 0.001 then
                                v68 = math.abs(v67.B - DescriptionColor.B) < 0.001;
                            else
                                v68 = false;
                            end;

                            v62 = not v68;
                        else
                            v62 = false;
                        end;

                        if not v62 then
                            if not u17 then
                                return false;
                            end;

                            v62 = DEFAULT_ICON_ID ~= u17.IconId;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v62;
end;

local function updateConfirmFade() -- Line: 193
    -- upvalues: u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref)
    if not u13 then
        return;
    end;

    local v69;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v69 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v69 = false;
    end;

    if not v69 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v69 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v69 = false;
        end;

        if not v69 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v69 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v69 = false;
            end;

            if not v69 then
                if u17 then
                    local v70 = u21;
                    local Color = u17.Color;
                    local v71;

                    if math.abs(v70.R - Color.R) < 0.001 and math.abs(v70.G - Color.G) < 0.001 then
                        v71 = math.abs(v70.B - Color.B) < 0.001;
                    else
                        v71 = false;
                    end;

                    v69 = not v71;
                else
                    v69 = false;
                end;

                if not v69 then
                    if u17 then
                        local v72 = u22;
                        local TagColor = u17.TagColor;
                        local v73;

                        if math.abs(v72.R - TagColor.R) < 0.001 and math.abs(v72.G - TagColor.G) < 0.001 then
                            v73 = math.abs(v72.B - TagColor.B) < 0.001;
                        else
                            v73 = false;
                        end;

                        v69 = not v73;
                    else
                        v69 = false;
                    end;

                    if not v69 then
                        if u17 then
                            local v74 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v75;

                            if math.abs(v74.R - DescriptionColor.R) < 0.001 and math.abs(v74.G - DescriptionColor.G) < 0.001 then
                                v75 = math.abs(v74.B - DescriptionColor.B) < 0.001;
                            else
                                v75 = false;
                            end;

                            v69 = not v75;
                        else
                            v69 = false;
                        end;

                        if not v69 then
                            if u17 then
                                v69 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v69 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13.Visible = not v69;
end;

local function loadSnapshotFromServer() -- Line: 202
    -- upvalues: Networking (copy), ServerClock (copy), Asserts (copy), hexToColor3 (copy)
    local success, result = pcall(function() -- Line: 203
        -- upvalues: Networking (ref)
        return Networking.Guild.GetMyGuild:Fire();
    end);

    if not success or typeof(result) ~= "table" then
        return nil;
    end;

    local Guild = result.Guild;

    if typeof(Guild) ~= "table" then
        return nil;
    end;

    local v76 = 0;
    local LastNameChangedAt = Guild.LastNameChangedAt;

    if typeof(LastNameChangedAt) == "number" and LastNameChangedAt > 0 then
        local v77 = ServerClock.Now() - LastNameChangedAt;

        if v77 < 604800 then
            v76 = 604800 - v77;
        end;
    end;

    local IconId = Guild.IconId;

    if typeof(IconId) ~= "number" or IconId <= 0 then
        IconId = Asserts.DEFAULT_ICON_ID;
    end;

    local v78 = {
        Name = tostring(Guild.Name or ""),
        Tag = tostring(Guild.Tag or ""),
        Description = tostring(Guild.Description or ""),
        Color = hexToColor3(Guild.Color),
        TagColor = hexToColor3(Guild.TagColor or Guild.Color),
        DescriptionColor = hexToColor3(Guild.DescriptionColor or Guild.Color),
        IconId = IconId
    };
    local v79;

    if typeof(result.Role) == "string" then
        v79 = result.Role;
    else
        v79 = nil;
    end;

    v78.Role = v79;
    v78.NameCooldownRemainingAtFetch = v76;
    v78.FetchedAtClock = os.clock();

    return v78;
end;

local function reflectIconUI() -- Line: 248
    -- upvalues: u14 (ref), Asserts (copy), DEFAULT_ICON_ID (ref), u16 (ref)
    if u14 then
        u14.Image = Asserts.IconAssetString(DEFAULT_ICON_ID);
    end;

    if u16 then
        u16.Text = Asserts.IsPoolIcon(DEFAULT_ICON_ID) and "" or tostring(DEFAULT_ICON_ID);
    end;
end;

local function applySnapshotToFields(p80) -- Line: 257
    -- upvalues: u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref), u6 (ref), u7 (ref), u8 (ref), u14 (ref), Asserts (copy), u16 (ref), u13 (ref)
    u17 = p80;
    u18 = p80.Name;
    u19 = p80.Tag;
    u20 = p80.Description;
    u21 = p80.Color;
    u22 = p80.TagColor;
    u23 = p80.DescriptionColor;
    DEFAULT_ICON_ID = p80.IconId;

    if u6 then
        u6.Text = p80.Name;
        u6.TextColor3 = p80.Color;
    end;

    if u7 then
        u7.Text = p80.Tag;
        u7.TextColor3 = p80.TagColor;
    end;

    if u8 then
        u8.Text = p80.Description;
        u8.TextColor3 = p80.DescriptionColor;
    end;

    if u14 then
        u14.Image = Asserts.IconAssetString(DEFAULT_ICON_ID);
    end;

    if u16 then
        u16.Text = Asserts.IsPoolIcon(DEFAULT_ICON_ID) and "" or tostring(DEFAULT_ICON_ID);
    end;

    if not u13 then
        return;
    end;

    local v81;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v81 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v81 = false;
    end;

    if not v81 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v81 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v81 = false;
        end;

        if not v81 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v81 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v81 = false;
            end;

            if not v81 then
                if u17 then
                    local v82 = u21;
                    local Color = u17.Color;
                    local v83;

                    if math.abs(v82.R - Color.R) < 0.001 and math.abs(v82.G - Color.G) < 0.001 then
                        v83 = math.abs(v82.B - Color.B) < 0.001;
                    else
                        v83 = false;
                    end;

                    v81 = not v83;
                else
                    v81 = false;
                end;

                if not v81 then
                    if u17 then
                        local v84 = u22;
                        local TagColor = u17.TagColor;
                        local v85;

                        if math.abs(v84.R - TagColor.R) < 0.001 and math.abs(v84.G - TagColor.G) < 0.001 then
                            v85 = math.abs(v84.B - TagColor.B) < 0.001;
                        else
                            v85 = false;
                        end;

                        v81 = not v85;
                    else
                        v81 = false;
                    end;

                    if not v81 then
                        if u17 then
                            local v86 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v87;

                            if math.abs(v86.R - DescriptionColor.R) < 0.001 and math.abs(v86.G - DescriptionColor.G) < 0.001 then
                                v87 = math.abs(v86.B - DescriptionColor.B) < 0.001;
                            else
                                v87 = false;
                            end;

                            v81 = not v87;
                        else
                            v81 = false;
                        end;

                        if not v81 then
                            if u17 then
                                v81 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v81 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13.Visible = not v81;
end;

local function clampNameText() -- Line: 285
    -- upvalues: u6 (ref), MAX_NAME_LENGTH (copy), u18 (ref), u13 (ref), u17 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref)
    if not u6 then
        return;
    end;

    local v88 = string.gsub(u6.Text, "[^A-Za-z0-9 _\'%-]", "");
    local v89 = MAX_NAME_LENGTH;
    local v90 = utf8.len(v88);

    if v90 and v90 > v89 then
        local v91 = utf8.offset(v88, v89 + 1);

        if v91 then
            v88 = string.sub(v88, 1, v91 - 1);
        else
            v88 = string.sub(v88, 1, v89);
        end;
    end;

    if v88 ~= u6.Text then
        u6.Text = v88;
    end;

    u18 = u6.Text;

    if not u13 then
        return;
    end;

    local v92;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v92 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v92 = false;
    end;

    if not v92 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v92 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v92 = false;
        end;

        if not v92 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v92 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v92 = false;
            end;

            if not v92 then
                if u17 then
                    local v93 = u21;
                    local Color = u17.Color;
                    local v94;

                    if math.abs(v93.R - Color.R) < 0.001 and math.abs(v93.G - Color.G) < 0.001 then
                        v94 = math.abs(v93.B - Color.B) < 0.001;
                    else
                        v94 = false;
                    end;

                    v92 = not v94;
                else
                    v92 = false;
                end;

                if not v92 then
                    if u17 then
                        local v95 = u22;
                        local TagColor = u17.TagColor;
                        local v96;

                        if math.abs(v95.R - TagColor.R) < 0.001 and math.abs(v95.G - TagColor.G) < 0.001 then
                            v96 = math.abs(v95.B - TagColor.B) < 0.001;
                        else
                            v96 = false;
                        end;

                        v92 = not v96;
                    else
                        v92 = false;
                    end;

                    if not v92 then
                        if u17 then
                            local v97 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v98;

                            if math.abs(v97.R - DescriptionColor.R) < 0.001 and math.abs(v97.G - DescriptionColor.G) < 0.001 then
                                v98 = math.abs(v97.B - DescriptionColor.B) < 0.001;
                            else
                                v98 = false;
                            end;

                            v92 = not v98;
                        else
                            v92 = false;
                        end;

                        if not v92 then
                            if u17 then
                                v92 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v92 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13.Visible = not v92;
end;

local function clampTagText() -- Line: 298
    -- upvalues: u7 (ref), MAX_TAG_LENGTH (copy), u19 (ref), u13 (ref), u17 (ref), u18 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref)
    if not u7 then
        return;
    end;

    local v99 = string.upper(u7.Text);
    local v100 = string.gsub(v99, "[^A-Z0-9]", "");
    local v101 = MAX_TAG_LENGTH;
    local v102 = utf8.len(v100);

    if v102 and v102 > v101 then
        local v103 = utf8.offset(v100, v101 + 1);

        if v103 then
            v100 = string.sub(v100, 1, v103 - 1);
        else
            v100 = string.sub(v100, 1, v101);
        end;
    end;

    if v100 ~= u7.Text then
        u7.Text = v100;
    end;

    u19 = u7.Text;

    if not u13 then
        return;
    end;

    local v104;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v104 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v104 = false;
    end;

    if not v104 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v104 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v104 = false;
        end;

        if not v104 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v104 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v104 = false;
            end;

            if not v104 then
                if u17 then
                    local v105 = u21;
                    local Color = u17.Color;
                    local v106;

                    if math.abs(v105.R - Color.R) < 0.001 and math.abs(v105.G - Color.G) < 0.001 then
                        v106 = math.abs(v105.B - Color.B) < 0.001;
                    else
                        v106 = false;
                    end;

                    v104 = not v106;
                else
                    v104 = false;
                end;

                if not v104 then
                    if u17 then
                        local v107 = u22;
                        local TagColor = u17.TagColor;
                        local v108;

                        if math.abs(v107.R - TagColor.R) < 0.001 and math.abs(v107.G - TagColor.G) < 0.001 then
                            v108 = math.abs(v107.B - TagColor.B) < 0.001;
                        else
                            v108 = false;
                        end;

                        v104 = not v108;
                    else
                        v104 = false;
                    end;

                    if not v104 then
                        if u17 then
                            local v109 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v110;

                            if math.abs(v109.R - DescriptionColor.R) < 0.001 and math.abs(v109.G - DescriptionColor.G) < 0.001 then
                                v110 = math.abs(v109.B - DescriptionColor.B) < 0.001;
                            else
                                v110 = false;
                            end;

                            v104 = not v110;
                        else
                            v104 = false;
                        end;

                        if not v104 then
                            if u17 then
                                v104 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v104 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13.Visible = not v104;
end;

local function clampDescriptionText() -- Line: 313
    -- upvalues: u8 (ref), MAX_DESCRIPTION_LENGTH (copy), u20 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref)
    if not u8 then
        return;
    end;

    local v111 = string.gsub(u8.Text, "[^ -~]", "");
    local v112 = MAX_DESCRIPTION_LENGTH;
    local v113 = utf8.len(v111);

    if v113 and v113 > v112 then
        local v114 = utf8.offset(v111, v112 + 1);

        if v114 then
            v111 = string.sub(v111, 1, v114 - 1);
        else
            v111 = string.sub(v111, 1, v112);
        end;
    end;

    if v111 ~= u8.Text then
        u8.Text = v111;
    end;

    u20 = u8.Text;

    if not u13 then
        return;
    end;

    local v115;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v115 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v115 = false;
    end;

    if not v115 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v115 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v115 = false;
        end;

        if not v115 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v115 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v115 = false;
            end;

            if not v115 then
                if u17 then
                    local v116 = u21;
                    local Color = u17.Color;
                    local v117;

                    if math.abs(v116.R - Color.R) < 0.001 and math.abs(v116.G - Color.G) < 0.001 then
                        v117 = math.abs(v116.B - Color.B) < 0.001;
                    else
                        v117 = false;
                    end;

                    v115 = not v117;
                else
                    v115 = false;
                end;

                if not v115 then
                    if u17 then
                        local v118 = u22;
                        local TagColor = u17.TagColor;
                        local v119;

                        if math.abs(v118.R - TagColor.R) < 0.001 and math.abs(v118.G - TagColor.G) < 0.001 then
                            v119 = math.abs(v118.B - TagColor.B) < 0.001;
                        else
                            v119 = false;
                        end;

                        v115 = not v119;
                    else
                        v115 = false;
                    end;

                    if not v115 then
                        if u17 then
                            local v120 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v121;

                            if math.abs(v120.R - DescriptionColor.R) < 0.001 and math.abs(v120.G - DescriptionColor.G) < 0.001 then
                                v121 = math.abs(v120.B - DescriptionColor.B) < 0.001;
                            else
                                v121 = false;
                            end;

                            v115 = not v121;
                        else
                            v115 = false;
                        end;

                        if not v115 then
                            if u17 then
                                v115 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v115 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13.Visible = not v115;
end;

local function applyNameColor(p122) -- Line: 327
    -- upvalues: u21 (ref), u6 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref)
    u21 = p122;

    if u6 then
        u6.TextColor3 = p122;
    end;

    if not u13 then
        return;
    end;

    local v123;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v123 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v123 = false;
    end;

    if not v123 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v123 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v123 = false;
        end;

        if not v123 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v123 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v123 = false;
            end;

            if not v123 then
                if u17 then
                    local v124 = u21;
                    local Color = u17.Color;
                    local v125;

                    if math.abs(v124.R - Color.R) < 0.001 and math.abs(v124.G - Color.G) < 0.001 then
                        v125 = math.abs(v124.B - Color.B) < 0.001;
                    else
                        v125 = false;
                    end;

                    v123 = not v125;
                else
                    v123 = false;
                end;

                if not v123 then
                    if u17 then
                        local v126 = u22;
                        local TagColor = u17.TagColor;
                        local v127;

                        if math.abs(v126.R - TagColor.R) < 0.001 and math.abs(v126.G - TagColor.G) < 0.001 then
                            v127 = math.abs(v126.B - TagColor.B) < 0.001;
                        else
                            v127 = false;
                        end;

                        v123 = not v127;
                    else
                        v123 = false;
                    end;

                    if not v123 then
                        if u17 then
                            local v128 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v129;

                            if math.abs(v128.R - DescriptionColor.R) < 0.001 and math.abs(v128.G - DescriptionColor.G) < 0.001 then
                                v129 = math.abs(v128.B - DescriptionColor.B) < 0.001;
                            else
                                v129 = false;
                            end;

                            v123 = not v129;
                        else
                            v123 = false;
                        end;

                        if not v123 then
                            if u17 then
                                v123 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v123 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13.Visible = not v123;
end;

local function applyTagColor(p130) -- Line: 333
    -- upvalues: u22 (ref), u7 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u23 (ref), DEFAULT_ICON_ID (ref)
    u22 = p130;

    if u7 then
        u7.TextColor3 = p130;
    end;

    if not u13 then
        return;
    end;

    local v131;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v131 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v131 = false;
    end;

    if not v131 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v131 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v131 = false;
        end;

        if not v131 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v131 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v131 = false;
            end;

            if not v131 then
                if u17 then
                    local v132 = u21;
                    local Color = u17.Color;
                    local v133;

                    if math.abs(v132.R - Color.R) < 0.001 and math.abs(v132.G - Color.G) < 0.001 then
                        v133 = math.abs(v132.B - Color.B) < 0.001;
                    else
                        v133 = false;
                    end;

                    v131 = not v133;
                else
                    v131 = false;
                end;

                if not v131 then
                    if u17 then
                        local v134 = u22;
                        local TagColor = u17.TagColor;
                        local v135;

                        if math.abs(v134.R - TagColor.R) < 0.001 and math.abs(v134.G - TagColor.G) < 0.001 then
                            v135 = math.abs(v134.B - TagColor.B) < 0.001;
                        else
                            v135 = false;
                        end;

                        v131 = not v135;
                    else
                        v131 = false;
                    end;

                    if not v131 then
                        if u17 then
                            local v136 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v137;

                            if math.abs(v136.R - DescriptionColor.R) < 0.001 and math.abs(v136.G - DescriptionColor.G) < 0.001 then
                                v137 = math.abs(v136.B - DescriptionColor.B) < 0.001;
                            else
                                v137 = false;
                            end;

                            v131 = not v137;
                        else
                            v131 = false;
                        end;

                        if not v131 then
                            if u17 then
                                v131 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v131 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13.Visible = not v131;
end;

local function applyDescriptionColor(p138) -- Line: 339
    -- upvalues: u23 (ref), u8 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), DEFAULT_ICON_ID (ref)
    u23 = p138;

    if u8 then
        u8.TextColor3 = p138;
    end;

    if not u13 then
        return;
    end;

    local v139;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v139 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v139 = false;
    end;

    if not v139 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v139 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v139 = false;
        end;

        if not v139 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v139 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v139 = false;
            end;

            if not v139 then
                if u17 then
                    local v140 = u21;
                    local Color = u17.Color;
                    local v141;

                    if math.abs(v140.R - Color.R) < 0.001 and math.abs(v140.G - Color.G) < 0.001 then
                        v141 = math.abs(v140.B - Color.B) < 0.001;
                    else
                        v141 = false;
                    end;

                    v139 = not v141;
                else
                    v139 = false;
                end;

                if not v139 then
                    if u17 then
                        local v142 = u22;
                        local TagColor = u17.TagColor;
                        local v143;

                        if math.abs(v142.R - TagColor.R) < 0.001 and math.abs(v142.G - TagColor.G) < 0.001 then
                            v143 = math.abs(v142.B - TagColor.B) < 0.001;
                        else
                            v143 = false;
                        end;

                        v139 = not v143;
                    else
                        v139 = false;
                    end;

                    if not v139 then
                        if u17 then
                            local v144 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v145;

                            if math.abs(v144.R - DescriptionColor.R) < 0.001 and math.abs(v144.G - DescriptionColor.G) < 0.001 then
                                v145 = math.abs(v144.B - DescriptionColor.B) < 0.001;
                            else
                                v145 = false;
                            end;

                            v139 = not v145;
                        else
                            v139 = false;
                        end;

                        if not v139 then
                            if u17 then
                                v139 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v139 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13.Visible = not v139;
end;

local function rollDiceIcon() -- Line: 349
    -- upvalues: IconPool (copy), DEFAULT_ICON_ID (ref), u24 (ref), u14 (ref), Asserts (copy), u16 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref)
    local v146 = IconPool.GetPool();

    if #v146 == 0 then
        return;
    end;

    local v147 = math.random(#v146);

    if #v146 > 1 and v146[v147] == DEFAULT_ICON_ID then
        v147 = v147 % #v146 + 1;
    end;

    u24 = u24 + 1;
    DEFAULT_ICON_ID = v146[v147];

    if u14 then
        u14.Image = Asserts.IconAssetString(DEFAULT_ICON_ID);
    end;

    if u16 then
        u16.Text = Asserts.IsPoolIcon(DEFAULT_ICON_ID) and "" or tostring(DEFAULT_ICON_ID);
    end;

    if not u13 then
        return;
    end;

    local v148;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v148 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v148 = false;
    end;

    if not v148 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v148 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v148 = false;
        end;

        if not v148 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v148 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v148 = false;
            end;

            if not v148 then
                if u17 then
                    local v149 = u21;
                    local Color = u17.Color;
                    local v150;

                    if math.abs(v149.R - Color.R) < 0.001 and math.abs(v149.G - Color.G) < 0.001 then
                        v150 = math.abs(v149.B - Color.B) < 0.001;
                    else
                        v150 = false;
                    end;

                    v148 = not v150;
                else
                    v148 = false;
                end;

                if not v148 then
                    if u17 then
                        local v151 = u22;
                        local TagColor = u17.TagColor;
                        local v152;

                        if math.abs(v151.R - TagColor.R) < 0.001 and math.abs(v151.G - TagColor.G) < 0.001 then
                            v152 = math.abs(v151.B - TagColor.B) < 0.001;
                        else
                            v152 = false;
                        end;

                        v148 = not v152;
                    else
                        v148 = false;
                    end;

                    if not v148 then
                        if u17 then
                            local v153 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v154;

                            if math.abs(v153.R - DescriptionColor.R) < 0.001 and math.abs(v153.G - DescriptionColor.G) < 0.001 then
                                v154 = math.abs(v153.B - DescriptionColor.B) < 0.001;
                            else
                                v154 = false;
                            end;

                            v148 = not v154;
                        else
                            v148 = false;
                        end;

                        if not v148 then
                            if u17 then
                                v148 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v148 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13.Visible = not v148;
end;

local function validateCustomImage(p155) -- Line: 368
    -- upvalues: u14 (ref), Asserts (copy), DEFAULT_ICON_ID (ref), u16 (ref), NotificationController (copy), u24 (ref), MarketplaceServiceHelper (copy), GuiController (copy), u2 (copy), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref)
    if string.match(p155, "^%s*$") then
        if u14 then
            u14.Image = Asserts.IconAssetString(DEFAULT_ICON_ID);
        end;

        if u16 then
            u16.Text = Asserts.IsPoolIcon(DEFAULT_ICON_ID) and "" or tostring(DEFAULT_ICON_ID);
        end;

        return;
    end;

    local u156 = tonumber(string.match(p155, "rbxassetid://(%d+)")) or tonumber(string.match(p155, "^%s*(%d+)%s*$"));

    if not u156 then
        if u14 then
            u14.Image = Asserts.IconAssetString(DEFAULT_ICON_ID);
        end;

        if u16 then
            u16.Text = Asserts.IsPoolIcon(DEFAULT_ICON_ID) and "" or tostring(DEFAULT_ICON_ID);
        end;

        NotificationController:CreateNotification("That\'s not a valid roblox image id!");

        return;
    end;

    if u156 == DEFAULT_ICON_ID then
        if u14 then
            u14.Image = Asserts.IconAssetString(DEFAULT_ICON_ID);
        end;

        if u16 then
            u16.Text = Asserts.IsPoolIcon(DEFAULT_ICON_ID) and "" or tostring(DEFAULT_ICON_ID);
        end;

        return;
    end;

    u24 = u24 + 1;
    local u157 = u24;
    task.spawn(function() -- Line: 391
        -- upvalues: MarketplaceServiceHelper (ref), u156 (copy), u157 (copy), u24 (ref), GuiController (ref), u2 (ref), u14 (ref), Asserts (ref), DEFAULT_ICON_ID (ref), u16 (ref), NotificationController (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref)
        local success, result = pcall(MarketplaceServiceHelper.GetInfoAsync, u156, Enum.InfoType.Asset);

        if u157 ~= u24 then
            return;
        end;

        if not GuiController:IsOpen("EditGuild") then
            return;
        end;

        if success then
            if typeof(result) == "table" then
                success = u2[result.AssetTypeId] == true;
            else
                success = false;
            end;
        end;

        if not success then
            if u14 then
                u14.Image = Asserts.IconAssetString(DEFAULT_ICON_ID);
            end;

            if u16 then
                u16.Text = Asserts.IsPoolIcon(DEFAULT_ICON_ID) and "" or tostring(DEFAULT_ICON_ID);
            end;

            NotificationController:CreateNotification("That\'s not a valid roblox image id!");

            return;
        end;

        DEFAULT_ICON_ID = u156;

        if u14 then
            u14.Image = Asserts.IconAssetString(DEFAULT_ICON_ID);
        end;

        if u16 then
            u16.Text = Asserts.IsPoolIcon(DEFAULT_ICON_ID) and "" or tostring(DEFAULT_ICON_ID);
        end;

        if not u13 then
            return;
        end;

        local v158;

        if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
            v158 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v158 = false;
        end;

        if not v158 then
            if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
                v158 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v158 = false;
            end;

            if not v158 then
                if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                    v158 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
                else
                    v158 = false;
                end;

                if not v158 then
                    if u17 then
                        local v159 = u21;
                        local Color = u17.Color;
                        local v160;

                        if math.abs(v159.R - Color.R) < 0.001 and math.abs(v159.G - Color.G) < 0.001 then
                            v160 = math.abs(v159.B - Color.B) < 0.001;
                        else
                            v160 = false;
                        end;

                        v158 = not v160;
                    else
                        v158 = false;
                    end;

                    if not v158 then
                        if u17 then
                            local v161 = u22;
                            local TagColor = u17.TagColor;
                            local v162;

                            if math.abs(v161.R - TagColor.R) < 0.001 and math.abs(v161.G - TagColor.G) < 0.001 then
                                v162 = math.abs(v161.B - TagColor.B) < 0.001;
                            else
                                v162 = false;
                            end;

                            v158 = not v162;
                        else
                            v158 = false;
                        end;

                        if not v158 then
                            if u17 then
                                local v163 = u23;
                                local DescriptionColor = u17.DescriptionColor;
                                local v164;

                                if math.abs(v163.R - DescriptionColor.R) < 0.001 and math.abs(v163.G - DescriptionColor.G) < 0.001 then
                                    v164 = math.abs(v163.B - DescriptionColor.B) < 0.001;
                                else
                                    v164 = false;
                                end;

                                v158 = not v164;
                            else
                                v158 = false;
                            end;

                            if not v158 then
                                if u17 then
                                    v158 = DEFAULT_ICON_ID ~= u17.IconId;
                                else
                                    v158 = false;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        u13.Visible = not v158;
    end);
end;

local function notifyEditError(p165) -- Line: 414
    -- upvalues: NotificationController (copy)
    if typeof(p165) == "string" and string.sub(p165, 1, 14) == "name_cooldown:" then
        local v166 = string.sub(p165, 15);
        local v167 = (tonumber(v166) or 0) + 0.5;
        local v168 = math.floor(v167);
        local v169 = math.max(0, v168);
        local v170 = v169 // 86400;
        local v171 = (v169 - v170 * 86400) // 3600;
        NotificationController:CreateNotification((`You can change your name in {string.format("%dd %dh", v170, v170 <= 0 and v171 <= 0 and 1 or v171)}`));

        return;
    end;

    if p165 == "name_cooldown" then
        NotificationController:CreateNotification("You can change your name in 7d 0h");

        return;
    end;

    if p165 == "no_changes" then
        NotificationController:CreateNotification("Nothing to save");

        return;
    end;

    if p165 == "not_leader" then
        NotificationController:CreateNotification("Only the guild leader can edit");

        return;
    end;

    if p165 == "guild_not_found" then
        NotificationController:CreateNotification("Couldn\'t find your guild");

        return;
    end;

    if p165 == "invalid_name" then
        NotificationController:CreateNotification("That guild name isn\'t allowed");

        return;
    end;

    if p165 == "name_too_long" then
        NotificationController:CreateNotification("Guild name is too long");

        return;
    end;

    if p165 == "name_taken" then
        NotificationController:CreateNotification("That guild name is taken");

        return;
    end;

    if p165 == "name_filtered" then
        NotificationController:CreateNotification("Guild name not allowed, try another!");

        return;
    end;

    if p165 == "invalid_tag" then
        NotificationController:CreateNotification("Guild tag must be 2-5 letters/digits");

        return;
    end;

    if p165 == "tag_taken" then
        NotificationController:CreateNotification("That guild tag is taken");

        return;
    end;

    if p165 == "tag_filtered" then
        NotificationController:CreateNotification("Guild tag not allowed, try another!");

        return;
    end;

    if p165 == "invalid_color" then
        NotificationController:CreateNotification("That name color isn\'t valid");

        return;
    end;

    if p165 == "invalid_tag_color" then
        NotificationController:CreateNotification("That tag color isn\'t valid");

        return;
    end;

    if p165 == "invalid_description_color" then
        NotificationController:CreateNotification("That description color isn\'t valid");

        return;
    end;

    if p165 == "invalid_icon" then
        NotificationController:CreateNotification("That\'s not a valid roblox image id!");

        return;
    end;

    if p165 == "invalid_description" then
        NotificationController:CreateNotification("That description isn\'t allowed");

        return;
    end;

    if p165 == "description_too_long" then
        NotificationController:CreateNotification("Guild description is too long");

        return;
    end;

    if p165 == "description_filtered" then
        NotificationController:CreateNotification("Description not allowed, try another!");

        return;
    end;

    if p165 == "filter_unavailable" then
        NotificationController:CreateNotification("Couldn\'t verify that text right now - try again in a moment!");

        return;
    end;

    if p165 then
        NotificationController:CreateNotification((`Failed to save guild ({p165})`));

        return;
    end;

    NotificationController:CreateNotification("Failed to save guild");
end;

local function checkLocalCooldown() -- Line: 476
    -- upvalues: u17 (ref), u18 (ref), NotificationController (copy)
    if not u17 then
        return true;
    end;

    local v172;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v172 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v172 = false;
    end;

    if not v172 then
        return true;
    end;

    local v173 = os.clock() - u17.FetchedAtClock;
    local v174 = u17.NameCooldownRemainingAtFetch - v173;

    if v174 <= 0 then
        return true;
    end;

    local v175 = math.floor(v174 + 0.5);
    local v176 = math.max(0, v175);
    local v177 = v176 // 86400;
    local v178 = (v176 - v177 * 86400) // 3600;
    NotificationController:CreateNotification((`You can change your name in {string.format("%dd %dh", v177, v177 <= 0 and v178 <= 0 and 1 or v178)}`));

    return false;
end;

local function fireSave() -- Line: 492
    -- upvalues: u25 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref), NotificationController (copy), checkLocalCooldown (copy), Networking (copy), notifyEditError (copy), loadSnapshotFromServer (copy), applySnapshotToFields (copy), GuiController (copy)
    if u25 then
        return;
    end;

    if not u17 then
        return;
    end;

    local v179;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v179 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v179 = false;
    end;

    if not v179 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v179 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v179 = false;
        end;

        if not v179 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v179 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v179 = false;
            end;

            if not v179 then
                if u17 then
                    local v180 = u21;
                    local Color = u17.Color;
                    local v181;

                    if math.abs(v180.R - Color.R) < 0.001 and math.abs(v180.G - Color.G) < 0.001 then
                        v181 = math.abs(v180.B - Color.B) < 0.001;
                    else
                        v181 = false;
                    end;

                    v179 = not v181;
                else
                    v179 = false;
                end;

                if not v179 then
                    if u17 then
                        local v182 = u22;
                        local TagColor = u17.TagColor;
                        local v183;

                        if math.abs(v182.R - TagColor.R) < 0.001 and math.abs(v182.G - TagColor.G) < 0.001 then
                            v183 = math.abs(v182.B - TagColor.B) < 0.001;
                        else
                            v183 = false;
                        end;

                        v179 = not v183;
                    else
                        v179 = false;
                    end;

                    if not v179 then
                        if u17 then
                            local v184 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v185;

                            if math.abs(v184.R - DescriptionColor.R) < 0.001 and math.abs(v184.G - DescriptionColor.G) < 0.001 then
                                v185 = math.abs(v184.B - DescriptionColor.B) < 0.001;
                            else
                                v185 = false;
                            end;

                            v179 = not v185;
                        else
                            v179 = false;
                        end;

                        if not v179 then
                            if u17 then
                                v179 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v179 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    if not v179 then
        NotificationController:CreateNotification("Nothing to save");

        return;
    end;

    if not checkLocalCooldown() then
        return;
    end;

    local v186;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v186 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v186 = false;
    end;

    local u187 = not v186 and "" or string.gsub(u18, "^%s*(.-)%s*$", "%1");
    local v188;

    if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
        v188 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v188 = false;
    end;

    local u189 = not v188 and "" or string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1")));
    local v190;

    if u17 then
        local v191 = u21;
        local Color = u17.Color;
        local v192;

        if math.abs(v191.R - Color.R) < 0.001 and math.abs(v191.G - Color.G) < 0.001 then
            v192 = math.abs(v191.B - Color.B) < 0.001;
        else
            v192 = false;
        end;

        v190 = not v192;
    else
        v190 = false;
    end;

    local u193;

    if v190 then
        local v194 = u21;
        local format = string.format;
        local v195 = math.floor(v194.R * 255 + 0.5);
        local v196 = math.clamp(v195, 0, 255);
        local v197 = math.floor(v194.G * 255 + 0.5);
        local v198 = math.clamp(v197, 0, 255);
        local v199 = math.floor(v194.B * 255 + 0.5);
        u193 = format("#%02X%02X%02X", v196, v198, (math.clamp(v199, 0, 255)));
    else
        u193 = "";
    end;

    local v200;

    if u17 then
        local v201 = u22;
        local TagColor = u17.TagColor;
        local v202;

        if math.abs(v201.R - TagColor.R) < 0.001 and math.abs(v201.G - TagColor.G) < 0.001 then
            v202 = math.abs(v201.B - TagColor.B) < 0.001;
        else
            v202 = false;
        end;

        v200 = not v202;
    else
        v200 = false;
    end;

    local u203;

    if v200 then
        local v204 = u22;
        local format = string.format;
        local v205 = math.floor(v204.R * 255 + 0.5);
        local v206 = math.clamp(v205, 0, 255);
        local v207 = math.floor(v204.G * 255 + 0.5);
        local v208 = math.clamp(v207, 0, 255);
        local v209 = math.floor(v204.B * 255 + 0.5);
        u203 = format("#%02X%02X%02X", v206, v208, (math.clamp(v209, 0, 255)));
    else
        u203 = "";
    end;

    local v210;

    if u17 then
        v210 = DEFAULT_ICON_ID ~= u17.IconId;
    else
        v210 = false;
    end;

    local u211 = not v210 and 0 or DEFAULT_ICON_ID;
    local v212;

    if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
        v212 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v212 = false;
    end;

    local u213 = not v212 and "" or string.gsub(u20, "^%s*(.-)%s*$", "%1");
    local v214;

    if u17 then
        local v215 = u23;
        local DescriptionColor = u17.DescriptionColor;
        local v216;

        if math.abs(v215.R - DescriptionColor.R) < 0.001 and math.abs(v215.G - DescriptionColor.G) < 0.001 then
            v216 = math.abs(v215.B - DescriptionColor.B) < 0.001;
        else
            v216 = false;
        end;

        v214 = not v216;
    else
        v214 = false;
    end;

    local u217;

    if v214 then
        local v218 = u23;
        local format = string.format;
        local v219 = math.floor(v218.R * 255 + 0.5);
        local v220 = math.clamp(v219, 0, 255);
        local v221 = math.floor(v218.G * 255 + 0.5);
        local v222 = math.clamp(v221, 0, 255);
        local v223 = math.floor(v218.B * 255 + 0.5);
        u217 = format("#%02X%02X%02X", v220, v222, (math.clamp(v223, 0, 255)));
    else
        u217 = "";
    end;

    u25 = true;
    task.spawn(function() -- Line: 513
        -- upvalues: Networking (ref), u187 (copy), u189 (copy), u193 (copy), u203 (copy), u211 (copy), u213 (copy), u217 (copy), u25 (ref), NotificationController (ref), notifyEditError (ref), loadSnapshotFromServer (ref), applySnapshotToFields (ref), GuiController (ref)
        local v224, v225, v226 = pcall(function() -- Line: 514
            -- upvalues: Networking (ref), u187 (ref), u189 (ref), u193 (ref), u203 (ref), u211 (ref), u213 (ref), u217 (ref)
            return Networking.Guild.EditGuild:Fire(u187, u189, u193, u203, u211, u213, u217);
        end);
        u25 = false;

        if not v224 then
            NotificationController:CreateNotification("Failed to save guild");

            return;
        end;

        if not v225 then
            notifyEditError(typeof(v226) == "string" and v226 and v226 or nil);

            return;
        end;

        NotificationController:CreateNotification("Saved guild changes");
        local v227 = loadSnapshotFromServer();

        if v227 then
            applySnapshotToFields(v227);
        end;

        if GuiController:IsOpen("EditGuild") then
            GuiController:Open("ViewGuildPage", nil, { "HUD" });

            if GuiController:IsOpen("EditGuild") then
                GuiController:Close();
            end;
        end;
    end);
end;

local function ResolveRefs(u228) -- Line: 554
    -- upvalues: u5 (ref), u6 (ref), u9 (ref), u7 (ref), u10 (ref), u8 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref)
    local function deep(p229) -- Line: 555
        -- upvalues: u228 (copy)
        return u228:FindFirstChild(p229, true);
    end;

    local function resolveField(p230) -- Line: 562
        -- upvalues: u228 (copy)
        local v231 = u228:FindFirstChild(p230, true);

        if not v231 then
            return nil, nil;
        end;

        local v232 = nil;
        local UsernameGuild = v231:FindFirstChild("UsernameGuild");
        local v233;

        if UsernameGuild then
            v233 = UsernameGuild:FindFirstChild("TextBox");

            if v233 then
                if not v233:IsA("TextBox") then
                    v233 = v232;
                end;
            else
                v233 = v232;
            end;
        else
            v233 = v232;
        end;

        local v234 = nil;
        local ColorPickerGuildNameButton = v231:FindFirstChild("ColorPickerGuildNameButton");

        if ColorPickerGuildNameButton then
            if not ColorPickerGuildNameButton:IsA("GuiButton") then
                ColorPickerGuildNameButton = v234;
            end;
        else
            ColorPickerGuildNameButton = v234;
        end;

        return v233, ColorPickerGuildNameButton;
    end;

    local v235 = u228:FindFirstChild("CloseButton", true) or u228:FindFirstChild("ExitButton", true);

    if v235 and v235:IsA("GuiButton") then
        u5 = v235;
    end;

    local v236, v237 = resolveField("GuildName");
    u6 = v236;
    u9 = v237;
    local v238, v239 = resolveField("GuildTag");
    u7 = v238;
    u10 = v239;
    local v240, v241 = resolveField("GuildDescription");
    u8 = v240;
    u11 = v241;
    local ConfirmButton = u228:FindFirstChild("ConfirmButton", true);

    if ConfirmButton and ConfirmButton:IsA("GuiButton") then
        u12 = ConfirmButton;
        local Fade = ConfirmButton:FindFirstChild("Fade");

        if Fade and Fade:IsA("GuiObject") then
            u13 = Fade;
        end;
    end;

    local GuildImagePreview = u228:FindFirstChild("GuildImagePreview", true);

    if GuildImagePreview then
        local GuildImage = GuildImagePreview:FindFirstChild("GuildImage", true);

        if GuildImage and GuildImage:IsA("ImageLabel") then
            u14 = GuildImage;
        end;

        local DiceButton = GuildImagePreview:FindFirstChild("DiceButton", true);

        if DiceButton then
            if DiceButton:IsA("GuiButton") then
                u15 = DiceButton;
            else
                local v242 = DiceButton:FindFirstChildOfClass("ImageButton") or DiceButton:FindFirstChildOfClass("TextButton");

                if v242 then
                    u15 = v242;
                end;
            end;
        end;

        local TextBox = GuildImagePreview:FindFirstChild("TextBox", true);

        if TextBox and TextBox:IsA("TextBox") then
            u16 = TextBox;
        end;
    end;
end;

local function BindCloseButton() -- Line: 615
    -- upvalues: u5 (ref), GuiController (copy)
    if not u5 then
        return;
    end;

    u5.MouseButton1Click:Connect(function() -- Line: 617
        -- upvalues: GuiController (ref)
        if not GuiController:IsOpen("EditGuild") then
            return;
        end;

        GuiController:Open("ViewGuildPage", nil, { "HUD" });

        if GuiController:IsOpen("EditGuild") then
            GuiController:Close();
        end;
    end);
end;

local function BindTextBoxes() -- Line: 630
    -- upvalues: u6 (ref), clampNameText (copy), u7 (ref), clampTagText (copy), u8 (ref), clampDescriptionText (copy)
    if u6 then
        u6.ClearTextOnFocus = false;
        u6:GetPropertyChangedSignal("Text"):Connect(clampNameText);
    end;

    if u7 then
        u7.ClearTextOnFocus = false;
        u7:GetPropertyChangedSignal("Text"):Connect(clampTagText);
    end;

    if u8 then
        u8.ClearTextOnFocus = false;
        u8:GetPropertyChangedSignal("Text"):Connect(clampDescriptionText);
    end;
end;

local function BindColorPickers() -- Line: 645
    -- upvalues: u9 (ref), ColorPickerGuildController (copy), u21 (ref), u6 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref), GuiController (copy), u10 (ref), u7 (ref), u11 (ref), u8 (ref)
    if u9 then
        u9.MouseButton1Click:Connect(function() -- Line: 647
            -- upvalues: ColorPickerGuildController (ref), u21 (ref), u6 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref), GuiController (ref)
            ColorPickerGuildController:RequestColor(u21, function(p243) -- Line: 648
                -- upvalues: u21 (ref), u6 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref), GuiController (ref)
                if p243 then
                    u21 = p243;

                    if u6 then
                        u6.TextColor3 = p243;
                    end;

                    if u13 then
                        local v244;

                        if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
                            v244 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
                        else
                            v244 = false;
                        end;

                        if not v244 then
                            if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
                                v244 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
                            else
                                v244 = false;
                            end;

                            if not v244 then
                                if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                                    v244 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
                                else
                                    v244 = false;
                                end;

                                if not v244 then
                                    if u17 then
                                        local v245 = u21;
                                        local Color = u17.Color;
                                        local v246;

                                        if math.abs(v245.R - Color.R) < 0.001 and math.abs(v245.G - Color.G) < 0.001 then
                                            v246 = math.abs(v245.B - Color.B) < 0.001;
                                        else
                                            v246 = false;
                                        end;

                                        v244 = not v246;
                                    else
                                        v244 = false;
                                    end;

                                    if not v244 then
                                        if u17 then
                                            local v247 = u22;
                                            local TagColor = u17.TagColor;
                                            local v248;

                                            if math.abs(v247.R - TagColor.R) < 0.001 and math.abs(v247.G - TagColor.G) < 0.001 then
                                                v248 = math.abs(v247.B - TagColor.B) < 0.001;
                                            else
                                                v248 = false;
                                            end;

                                            v244 = not v248;
                                        else
                                            v244 = false;
                                        end;

                                        if not v244 then
                                            if u17 then
                                                local v249 = u23;
                                                local DescriptionColor = u17.DescriptionColor;
                                                local v250;

                                                if math.abs(v249.R - DescriptionColor.R) < 0.001 and math.abs(v249.G - DescriptionColor.G) < 0.001 then
                                                    v250 = math.abs(v249.B - DescriptionColor.B) < 0.001;
                                                else
                                                    v250 = false;
                                                end;

                                                v244 = not v250;
                                            else
                                                v244 = false;
                                            end;

                                            if not v244 then
                                                if u17 then
                                                    v244 = DEFAULT_ICON_ID ~= u17.IconId;
                                                else
                                                    v244 = false;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        u13.Visible = not v244;
                    end;
                end;

                if not GuiController:IsOpen("EditGuild") then
                    GuiController:Open("EditGuild", nil, { "HUD" });
                end;
            end);
        end);
    end;

    if u10 then
        u10.MouseButton1Click:Connect(function() -- Line: 658
            -- upvalues: ColorPickerGuildController (ref), u22 (ref), u7 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u23 (ref), DEFAULT_ICON_ID (ref), GuiController (ref)
            ColorPickerGuildController:RequestColor(u22, function(p251) -- Line: 659
                -- upvalues: u22 (ref), u7 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u23 (ref), DEFAULT_ICON_ID (ref), GuiController (ref)
                if p251 then
                    u22 = p251;

                    if u7 then
                        u7.TextColor3 = p251;
                    end;

                    if u13 then
                        local v252;

                        if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
                            v252 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
                        else
                            v252 = false;
                        end;

                        if not v252 then
                            if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
                                v252 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
                            else
                                v252 = false;
                            end;

                            if not v252 then
                                if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                                    v252 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
                                else
                                    v252 = false;
                                end;

                                if not v252 then
                                    if u17 then
                                        local v253 = u21;
                                        local Color = u17.Color;
                                        local v254;

                                        if math.abs(v253.R - Color.R) < 0.001 and math.abs(v253.G - Color.G) < 0.001 then
                                            v254 = math.abs(v253.B - Color.B) < 0.001;
                                        else
                                            v254 = false;
                                        end;

                                        v252 = not v254;
                                    else
                                        v252 = false;
                                    end;

                                    if not v252 then
                                        if u17 then
                                            local v255 = u22;
                                            local TagColor = u17.TagColor;
                                            local v256;

                                            if math.abs(v255.R - TagColor.R) < 0.001 and math.abs(v255.G - TagColor.G) < 0.001 then
                                                v256 = math.abs(v255.B - TagColor.B) < 0.001;
                                            else
                                                v256 = false;
                                            end;

                                            v252 = not v256;
                                        else
                                            v252 = false;
                                        end;

                                        if not v252 then
                                            if u17 then
                                                local v257 = u23;
                                                local DescriptionColor = u17.DescriptionColor;
                                                local v258;

                                                if math.abs(v257.R - DescriptionColor.R) < 0.001 and math.abs(v257.G - DescriptionColor.G) < 0.001 then
                                                    v258 = math.abs(v257.B - DescriptionColor.B) < 0.001;
                                                else
                                                    v258 = false;
                                                end;

                                                v252 = not v258;
                                            else
                                                v252 = false;
                                            end;

                                            if not v252 then
                                                if u17 then
                                                    v252 = DEFAULT_ICON_ID ~= u17.IconId;
                                                else
                                                    v252 = false;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        u13.Visible = not v252;
                    end;
                end;

                if not GuiController:IsOpen("EditGuild") then
                    GuiController:Open("EditGuild", nil, { "HUD" });
                end;
            end);
        end);
    end;

    if u11 then
        u11.MouseButton1Click:Connect(function() -- Line: 668
            -- upvalues: ColorPickerGuildController (ref), u23 (ref), u8 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), DEFAULT_ICON_ID (ref), GuiController (ref)
            ColorPickerGuildController:RequestColor(u23, function(p259) -- Line: 669
                -- upvalues: u23 (ref), u8 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), DEFAULT_ICON_ID (ref), GuiController (ref)
                if p259 then
                    u23 = p259;

                    if u8 then
                        u8.TextColor3 = p259;
                    end;

                    if u13 then
                        local v260;

                        if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
                            v260 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
                        else
                            v260 = false;
                        end;

                        if not v260 then
                            if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
                                v260 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
                            else
                                v260 = false;
                            end;

                            if not v260 then
                                if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                                    v260 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
                                else
                                    v260 = false;
                                end;

                                if not v260 then
                                    if u17 then
                                        local v261 = u21;
                                        local Color = u17.Color;
                                        local v262;

                                        if math.abs(v261.R - Color.R) < 0.001 and math.abs(v261.G - Color.G) < 0.001 then
                                            v262 = math.abs(v261.B - Color.B) < 0.001;
                                        else
                                            v262 = false;
                                        end;

                                        v260 = not v262;
                                    else
                                        v260 = false;
                                    end;

                                    if not v260 then
                                        if u17 then
                                            local v263 = u22;
                                            local TagColor = u17.TagColor;
                                            local v264;

                                            if math.abs(v263.R - TagColor.R) < 0.001 and math.abs(v263.G - TagColor.G) < 0.001 then
                                                v264 = math.abs(v263.B - TagColor.B) < 0.001;
                                            else
                                                v264 = false;
                                            end;

                                            v260 = not v264;
                                        else
                                            v260 = false;
                                        end;

                                        if not v260 then
                                            if u17 then
                                                local v265 = u23;
                                                local DescriptionColor = u17.DescriptionColor;
                                                local v266;

                                                if math.abs(v265.R - DescriptionColor.R) < 0.001 and math.abs(v265.G - DescriptionColor.G) < 0.001 then
                                                    v266 = math.abs(v265.B - DescriptionColor.B) < 0.001;
                                                else
                                                    v266 = false;
                                                end;

                                                v260 = not v266;
                                            else
                                                v260 = false;
                                            end;

                                            if not v260 then
                                                if u17 then
                                                    v260 = DEFAULT_ICON_ID ~= u17.IconId;
                                                else
                                                    v260 = false;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        u13.Visible = not v260;
                    end;
                end;

                if not GuiController:IsOpen("EditGuild") then
                    GuiController:Open("EditGuild", nil, { "HUD" });
                end;
            end);
        end);
    end;
end;

local function BindConfirmButton() -- Line: 679
    -- upvalues: u12 (ref), fireSave (copy)
    if not u12 then
        return;
    end;

    u12.MouseButton1Click:Connect(fireSave);
end;

local function BindImagePicker() -- Line: 684
    -- upvalues: u15 (ref), rollDiceIcon (copy), u16 (ref), validateCustomImage (copy)
    if u15 then
        u15.MouseButton1Click:Connect(rollDiceIcon);
    end;

    if u16 then
        u16.ClearTextOnFocus = false;
        u16.FocusLost:Connect(function() -- Line: 690
            -- upvalues: u16 (ref), validateCustomImage (ref)
            if not u16 then
                return;
            end;

            validateCustomImage(u16.Text);
        end);
    end;
end;

local function OnFocus() -- Line: 697
    -- upvalues: u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref), loadSnapshotFromServer (copy), NotificationController (copy), applySnapshotToFields (copy)
    local v267;

    if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
        v267 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
    else
        v267 = false;
    end;

    if not v267 then
        if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
            v267 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
        else
            v267 = false;
        end;

        if not v267 then
            if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                v267 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v267 = false;
            end;

            if not v267 then
                if u17 then
                    local v268 = u21;
                    local Color = u17.Color;
                    local v269;

                    if math.abs(v268.R - Color.R) < 0.001 and math.abs(v268.G - Color.G) < 0.001 then
                        v269 = math.abs(v268.B - Color.B) < 0.001;
                    else
                        v269 = false;
                    end;

                    v267 = not v269;
                else
                    v267 = false;
                end;

                if not v267 then
                    if u17 then
                        local v270 = u22;
                        local TagColor = u17.TagColor;
                        local v271;

                        if math.abs(v270.R - TagColor.R) < 0.001 and math.abs(v270.G - TagColor.G) < 0.001 then
                            v271 = math.abs(v270.B - TagColor.B) < 0.001;
                        else
                            v271 = false;
                        end;

                        v267 = not v271;
                    else
                        v267 = false;
                    end;

                    if not v267 then
                        if u17 then
                            local v272 = u23;
                            local DescriptionColor = u17.DescriptionColor;
                            local v273;

                            if math.abs(v272.R - DescriptionColor.R) < 0.001 and math.abs(v272.G - DescriptionColor.G) < 0.001 then
                                v273 = math.abs(v272.B - DescriptionColor.B) < 0.001;
                            else
                                v273 = false;
                            end;

                            v267 = not v273;
                        else
                            v267 = false;
                        end;

                        if not v267 then
                            if u17 then
                                v267 = DEFAULT_ICON_ID ~= u17.IconId;
                            else
                                v267 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    if v267 then
        return;
    end;

    task.spawn(function() -- Line: 708
        -- upvalues: loadSnapshotFromServer (ref), NotificationController (ref), applySnapshotToFields (ref)
        local v274 = loadSnapshotFromServer();

        if v274 then
            applySnapshotToFields(v274);

            return;
        end;

        NotificationController:CreateNotification("Couldn\'t load your guild");
    end);
end;

function v3.Init(p275) -- Line: 719
end;

function v3.Start(p276) -- Line: 721
    -- upvalues: PlayerGui (copy), u4 (ref), ResolveRefs (copy), u5 (ref), GuiController (copy), BindTextBoxes (copy), BindColorPickers (copy), u12 (ref), fireSave (copy), u15 (ref), rollDiceIcon (copy), u16 (ref), validateCustomImage (copy), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref), loadSnapshotFromServer (copy), NotificationController (copy), applySnapshotToFields (copy)
    task.spawn(function() -- Line: 722
        -- upvalues: PlayerGui (ref), u4 (ref), ResolveRefs (ref), u5 (ref), GuiController (ref), BindTextBoxes (ref), BindColorPickers (ref), u12 (ref), fireSave (ref), u15 (ref), rollDiceIcon (ref), u16 (ref), validateCustomImage (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref), loadSnapshotFromServer (ref), NotificationController (ref), applySnapshotToFields (ref)
        local EditGuild = PlayerGui:WaitForChild("EditGuild", 30);

        if not (EditGuild and EditGuild:IsA("ScreenGui")) then
            return;
        end;

        u4 = EditGuild;
        EditGuild.Enabled = false;
        ResolveRefs(EditGuild);

        if u5 then
            u5.MouseButton1Click:Connect(function() -- Line: 617
                -- upvalues: GuiController (ref)
                if not GuiController:IsOpen("EditGuild") then
                    return;
                end;

                GuiController:Open("ViewGuildPage", nil, { "HUD" });

                if GuiController:IsOpen("EditGuild") then
                    GuiController:Close();
                end;
            end);
        end;

        BindTextBoxes();
        BindColorPickers();

        if u12 then
            u12.MouseButton1Click:Connect(fireSave);
        end;

        if u15 then
            u15.MouseButton1Click:Connect(rollDiceIcon);
        end;

        if u16 then
            u16.ClearTextOnFocus = false;
            u16.FocusLost:Connect(function() -- Line: 690
                -- upvalues: u16 (ref), validateCustomImage (ref)
                if not u16 then
                    return;
                end;

                validateCustomImage(u16.Text);
            end);
        end;

        if u13 then
            local v277;

            if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
                v277 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
            else
                v277 = false;
            end;

            if not v277 then
                if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
                    v277 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
                else
                    v277 = false;
                end;

                if not v277 then
                    if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                        v277 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
                    else
                        v277 = false;
                    end;

                    if not v277 then
                        if u17 then
                            local v278 = u21;
                            local Color = u17.Color;
                            local v279;

                            if math.abs(v278.R - Color.R) < 0.001 and math.abs(v278.G - Color.G) < 0.001 then
                                v279 = math.abs(v278.B - Color.B) < 0.001;
                            else
                                v279 = false;
                            end;

                            v277 = not v279;
                        else
                            v277 = false;
                        end;

                        if not v277 then
                            if u17 then
                                local v280 = u22;
                                local TagColor = u17.TagColor;
                                local v281;

                                if math.abs(v280.R - TagColor.R) < 0.001 and math.abs(v280.G - TagColor.G) < 0.001 then
                                    v281 = math.abs(v280.B - TagColor.B) < 0.001;
                                else
                                    v281 = false;
                                end;

                                v277 = not v281;
                            else
                                v277 = false;
                            end;

                            if not v277 then
                                if u17 then
                                    local v282 = u23;
                                    local DescriptionColor = u17.DescriptionColor;
                                    local v283;

                                    if math.abs(v282.R - DescriptionColor.R) < 0.001 and math.abs(v282.G - DescriptionColor.G) < 0.001 then
                                        v283 = math.abs(v282.B - DescriptionColor.B) < 0.001;
                                    else
                                        v283 = false;
                                    end;

                                    v277 = not v283;
                                else
                                    v277 = false;
                                end;

                                if not v277 then
                                    if u17 then
                                        v277 = DEFAULT_ICON_ID ~= u17.IconId;
                                    else
                                        v277 = false;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            u13.Visible = not v277;
        end;

        GuiController.GuiFocusedSignal:Connect(function(p284) -- Line: 737
            -- upvalues: EditGuild (copy), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), DEFAULT_ICON_ID (ref), loadSnapshotFromServer (ref), NotificationController (ref), applySnapshotToFields (ref)
            if p284 == EditGuild then
                local v285;

                if u17 and string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= u17.Name then
                    v285 = string.gsub(u18, "^%s*(.-)%s*$", "%1") ~= "";
                else
                    v285 = false;
                end;

                if not v285 then
                    if u17 and string.upper((string.gsub(u19, "^%s*(.-)%s*$", "%1"))) ~= u17.Tag then
                        v285 = string.gsub(u19, "^%s*(.-)%s*$", "%1") ~= "";
                    else
                        v285 = false;
                    end;

                    if not v285 then
                        if u17 and string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= u17.Description then
                            v285 = string.gsub(u20, "^%s*(.-)%s*$", "%1") ~= "";
                        else
                            v285 = false;
                        end;

                        if not v285 then
                            if u17 then
                                local v286 = u21;
                                local Color = u17.Color;
                                local v287;

                                if math.abs(v286.R - Color.R) < 0.001 and math.abs(v286.G - Color.G) < 0.001 then
                                    v287 = math.abs(v286.B - Color.B) < 0.001;
                                else
                                    v287 = false;
                                end;

                                v285 = not v287;
                            else
                                v285 = false;
                            end;

                            if not v285 then
                                if u17 then
                                    local v288 = u22;
                                    local TagColor = u17.TagColor;
                                    local v289;

                                    if math.abs(v288.R - TagColor.R) < 0.001 and math.abs(v288.G - TagColor.G) < 0.001 then
                                        v289 = math.abs(v288.B - TagColor.B) < 0.001;
                                    else
                                        v289 = false;
                                    end;

                                    v285 = not v289;
                                else
                                    v285 = false;
                                end;

                                if not v285 then
                                    if u17 then
                                        local v290 = u23;
                                        local DescriptionColor = u17.DescriptionColor;
                                        local v291;

                                        if math.abs(v290.R - DescriptionColor.R) < 0.001 and math.abs(v290.G - DescriptionColor.G) < 0.001 then
                                            v291 = math.abs(v290.B - DescriptionColor.B) < 0.001;
                                        else
                                            v291 = false;
                                        end;

                                        v285 = not v291;
                                    else
                                        v285 = false;
                                    end;

                                    if not v285 then
                                        if u17 then
                                            v285 = DEFAULT_ICON_ID ~= u17.IconId;
                                        else
                                            v285 = false;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

                if v285 then
                    return;
                end;

                task.spawn(function() -- Line: 708
                    -- upvalues: loadSnapshotFromServer (ref), NotificationController (ref), applySnapshotToFields (ref)
                    local v292 = loadSnapshotFromServer();

                    if v292 then
                        applySnapshotToFields(v292);

                        return;
                    end;

                    NotificationController:CreateNotification("Couldn\'t load your guild");
                end);
            end;
        end);
    end);
end;

return v3;