-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local Asserts = require(ReplicatedStorage.SharedModules.Guild.Asserts);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local DevProductController = require(LocalPlayer.PlayerScripts.Controllers.DevProductController);
local ColorPickerGuildController = require(LocalPlayer.PlayerScripts.Controllers.ColorPickerGuildController);
local MIN_NAME_LENGTH = Asserts.MIN_NAME_LENGTH;
local MAX_NAME_LENGTH = Asserts.MAX_NAME_LENGTH;
local MIN_TAG_LENGTH = Asserts.MIN_TAG_LENGTH;
local MAX_TAG_LENGTH = Asserts.MAX_TAG_LENGTH;
local MAX_DESCRIPTION_LENGTH = Asserts.MAX_DESCRIPTION_LENGTH;
local v1 = Color3.fromRGB(255, 255, 255);
local v2 = Color3.fromRGB(255, 255, 255);
local v3 = Color3.fromRGB(255, 255, 255);
local v4 = {
    StartOrder = 7
};
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
local u18 = nil;
local u19 = nil;
local u20 = v1;
local u21 = v2;
local u22 = v3;
local u23 = false;

local function utf8Len(p24) -- Line: 72
    return utf8.len(p24) or #p24;
end;

local function utf8Truncate(p25, p26) -- Line: 76
    local v27 = utf8.len(p25);

    if not v27 or v27 <= p26 then
        return p25;
    end;

    local v28 = utf8.offset(p25, p26 + 1);

    if v28 then
        return string.sub(p25, 1, v28 - 1);
    end;

    return string.sub(p25, 1, p26);
end;

local function color3ToHex(p29) -- Line: 86
    local format = string.format;
    local v30 = math.floor(p29.R * 255 + 0.5);
    local v31 = math.clamp(v30, 0, 255);
    local v32 = math.floor(p29.G * 255 + 0.5);
    local v33 = math.clamp(v32, 0, 255);
    local v34 = math.floor(p29.B * 255 + 0.5);

    return format("#%02X%02X%02X", v31, v33, (math.clamp(v34, 0, 255)));
end;

local function trim(p35) -- Line: 95
    return string.gsub(p35, "^%s*(.-)%s*$", "%1");
end;

local function getName() -- Line: 99
    -- upvalues: u7 (ref)
    return not u7 and "" or string.gsub(u7.Text, "^%s*(.-)%s*$", "%1");
end;

local function getTag() -- Line: 104
    -- upvalues: u9 (ref)
    return not u9 and "" or string.gsub(u9.Text, "^%s*(.-)%s*$", "%1");
end;

local function isNameValid() -- Line: 109
    -- upvalues: u7 (ref), MIN_NAME_LENGTH (copy), MAX_NAME_LENGTH (copy)
    local v36 = not u7 and "" or string.gsub(u7.Text, "^%s*(.-)%s*$", "%1");
    local v37 = utf8.len(v36) or #v36;
    local v38;

    if MIN_NAME_LENGTH <= v37 then
        v38 = v37 <= MAX_NAME_LENGTH;
    else
        v38 = false;
    end;

    return v38;
end;

local function isTagValid() -- Line: 115
    -- upvalues: u9 (ref), MIN_TAG_LENGTH (copy), MAX_TAG_LENGTH (copy)
    local v39 = not u9 and "" or string.gsub(u9.Text, "^%s*(.-)%s*$", "%1");
    local v40 = utf8.len(v39) or #v39;
    local v41;

    if MIN_TAG_LENGTH <= v40 then
        v41 = v40 <= MAX_TAG_LENGTH;
    else
        v41 = false;
    end;

    return v41;
end;

local function getDescription() -- Line: 121
    -- upvalues: u11 (ref)
    return not u11 and "" or string.gsub(u11.Text, "^%s*(.-)%s*$", "%1");
end;

local function isDescriptionValid() -- Line: 126
    -- upvalues: u11 (ref), MAX_DESCRIPTION_LENGTH (copy)
    local v42 = not u11 and "" or string.gsub(u11.Text, "^%s*(.-)%s*$", "%1");
    local v43 = utf8.len(v42) or #v42;
    local v44;

    if v43 >= 1 then
        v44 = v43 <= MAX_DESCRIPTION_LENGTH;
    else
        v44 = false;
    end;

    return v44;
end;

local function isFormValid() -- Line: 134
    -- upvalues: u7 (ref), MIN_NAME_LENGTH (copy), MAX_NAME_LENGTH (copy), u9 (ref), MIN_TAG_LENGTH (copy), MAX_TAG_LENGTH (copy), u11 (ref), MAX_DESCRIPTION_LENGTH (copy)
    local v45 = not u7 and "" or string.gsub(u7.Text, "^%s*(.-)%s*$", "%1");
    local v46 = utf8.len(v45) or #v45;
    local v47;

    if MIN_NAME_LENGTH <= v46 then
        v47 = v46 <= MAX_NAME_LENGTH;
    else
        v47 = false;
    end;

    if v47 then
        local v48 = not u9 and "" or string.gsub(u9.Text, "^%s*(.-)%s*$", "%1");
        local v49 = utf8.len(v48) or #v48;

        if MIN_TAG_LENGTH <= v49 then
            v47 = v49 <= MAX_TAG_LENGTH;
        else
            v47 = false;
        end;

        if v47 then
            local v50 = not u11 and "" or string.gsub(u11.Text, "^%s*(.-)%s*$", "%1");
            local v51 = utf8.len(v50) or #v50;

            if v51 >= 1 then
                v47 = v51 <= MAX_DESCRIPTION_LENGTH;
            else
                v47 = false;
            end;
        end;
    end;

    return v47;
end;

local function setLabelChain(p52, p53) -- Line: 138
    if not p52 then
        return;
    end;

    p52.Text = p53;

    for _, descendant in p52:GetDescendants() do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            descendant.Text = p53;
        end;
    end;
end;

local function updateCounter(p54, p55, p56) -- Line: 148
    -- upvalues: setLabelChain (copy)
    if not p54 then
        return;
    end;

    setLabelChain(p54, (`({p55}/{p56})`));
end;

local function applyNameColor(p57) -- Line: 153
    -- upvalues: u20 (ref), u7 (ref)
    u20 = p57;

    if u7 then
        u7.TextColor3 = p57;
    end;
end;

local function applyTagColor(p58) -- Line: 160
    -- upvalues: u21 (ref), u9 (ref)
    u21 = p58;

    if u9 then
        u9.TextColor3 = p58;
    end;
end;

local function applyDescriptionColor(p59) -- Line: 167
    -- upvalues: u22 (ref), u11 (ref)
    u22 = p59;

    if u11 then
        u11.TextColor3 = p59;
    end;
end;

local function updateCreateBlock() -- Line: 174
    -- upvalues: u17 (ref), u7 (ref), MIN_NAME_LENGTH (copy), MAX_NAME_LENGTH (copy), u9 (ref), MIN_TAG_LENGTH (copy), MAX_TAG_LENGTH (copy), u11 (ref), MAX_DESCRIPTION_LENGTH (copy)
    if not u17 then
        return;
    end;

    local v60 = not u7 and "" or string.gsub(u7.Text, "^%s*(.-)%s*$", "%1");
    local v61 = utf8.len(v60) or #v60;
    local v62;

    if MIN_NAME_LENGTH <= v61 then
        v62 = v61 <= MAX_NAME_LENGTH;
    else
        v62 = false;
    end;

    if v62 then
        local v63 = not u9 and "" or string.gsub(u9.Text, "^%s*(.-)%s*$", "%1");
        local v64 = utf8.len(v63) or #v63;

        if MIN_TAG_LENGTH <= v64 then
            v62 = v64 <= MAX_TAG_LENGTH;
        else
            v62 = false;
        end;

        if v62 then
            local v65 = not u11 and "" or string.gsub(u11.Text, "^%s*(.-)%s*$", "%1");
            local v66 = utf8.len(v65) or #v65;

            if v66 >= 1 then
                v62 = v66 <= MAX_DESCRIPTION_LENGTH;
            else
                v62 = false;
            end;
        end;
    end;

    u17.Visible = not v62;
end;

local function clampNameText() -- Line: 183
    -- upvalues: u7 (ref), MAX_NAME_LENGTH (copy), u13 (ref), setLabelChain (copy), u17 (ref), MIN_NAME_LENGTH (copy), u9 (ref), MIN_TAG_LENGTH (copy), MAX_TAG_LENGTH (copy), u11 (ref), MAX_DESCRIPTION_LENGTH (copy)
    if not u7 then
        return;
    end;

    local v67 = string.gsub(u7.Text, "[^A-Za-z0-9 _\'%-]", "");
    local v68 = MAX_NAME_LENGTH;
    local v69 = utf8.len(v67);

    if v69 and v69 > v68 then
        local v70 = utf8.offset(v67, v68 + 1);

        if v70 then
            v67 = string.sub(v67, 1, v70 - 1);
        else
            v67 = string.sub(v67, 1, v68);
        end;
    end;

    if v67 ~= u7.Text then
        u7.Text = v67;
    end;

    local v71 = u13;
    local Text = u7.Text;
    local v72 = utf8.len(Text) or #Text;
    local v73 = MAX_NAME_LENGTH;

    if v71 then
        setLabelChain(v71, (`({v72}/{v73})`));
    end;

    if not u17 then
        return;
    end;

    local v74 = not u7 and "" or string.gsub(u7.Text, "^%s*(.-)%s*$", "%1");
    local v75 = utf8.len(v74) or #v74;
    local v76;

    if MIN_NAME_LENGTH <= v75 then
        v76 = v75 <= MAX_NAME_LENGTH;
    else
        v76 = false;
    end;

    if v76 then
        local v77 = not u9 and "" or string.gsub(u9.Text, "^%s*(.-)%s*$", "%1");
        local v78 = utf8.len(v77) or #v77;

        if MIN_TAG_LENGTH <= v78 then
            v76 = v78 <= MAX_TAG_LENGTH;
        else
            v76 = false;
        end;

        if v76 then
            local v79 = not u11 and "" or string.gsub(u11.Text, "^%s*(.-)%s*$", "%1");
            local v80 = utf8.len(v79) or #v79;

            if v80 >= 1 then
                v76 = v80 <= MAX_DESCRIPTION_LENGTH;
            else
                v76 = false;
            end;
        end;
    end;

    u17.Visible = not v76;
end;

local function clampTagText() -- Line: 196
    -- upvalues: u9 (ref), MAX_TAG_LENGTH (copy), u14 (ref), setLabelChain (copy), u17 (ref), u7 (ref), MIN_NAME_LENGTH (copy), MAX_NAME_LENGTH (copy), MIN_TAG_LENGTH (copy), u11 (ref), MAX_DESCRIPTION_LENGTH (copy)
    if not u9 then
        return;
    end;

    local v81 = string.upper(u9.Text);
    local v82 = string.gsub(v81, "[^A-Z0-9]", "");
    local v83 = MAX_TAG_LENGTH;
    local v84 = utf8.len(v82);

    if v84 and v84 > v83 then
        local v85 = utf8.offset(v82, v83 + 1);

        if v85 then
            v82 = string.sub(v82, 1, v85 - 1);
        else
            v82 = string.sub(v82, 1, v83);
        end;
    end;

    if v82 ~= u9.Text then
        u9.Text = v82;
    end;

    local v86 = u14;
    local Text = u9.Text;
    local v87 = utf8.len(Text) or #Text;
    local v88 = MAX_TAG_LENGTH;

    if v86 then
        setLabelChain(v86, (`({v87}/{v88})`));
    end;

    if not u17 then
        return;
    end;

    local v89 = not u7 and "" or string.gsub(u7.Text, "^%s*(.-)%s*$", "%1");
    local v90 = utf8.len(v89) or #v89;
    local v91;

    if MIN_NAME_LENGTH <= v90 then
        v91 = v90 <= MAX_NAME_LENGTH;
    else
        v91 = false;
    end;

    if v91 then
        local v92 = not u9 and "" or string.gsub(u9.Text, "^%s*(.-)%s*$", "%1");
        local v93 = utf8.len(v92) or #v92;

        if MIN_TAG_LENGTH <= v93 then
            v91 = v93 <= MAX_TAG_LENGTH;
        else
            v91 = false;
        end;

        if v91 then
            local v94 = not u11 and "" or string.gsub(u11.Text, "^%s*(.-)%s*$", "%1");
            local v95 = utf8.len(v94) or #v94;

            if v95 >= 1 then
                v91 = v95 <= MAX_DESCRIPTION_LENGTH;
            else
                v91 = false;
            end;
        end;
    end;

    u17.Visible = not v91;
end;

local function clampDescriptionText() -- Line: 212
    -- upvalues: u11 (ref), MAX_DESCRIPTION_LENGTH (copy), u15 (ref), setLabelChain (copy), u17 (ref), u7 (ref), MIN_NAME_LENGTH (copy), MAX_NAME_LENGTH (copy), u9 (ref), MIN_TAG_LENGTH (copy), MAX_TAG_LENGTH (copy)
    if not u11 then
        return;
    end;

    local v96 = string.gsub(u11.Text, "[^ -~]", "");
    local v97 = MAX_DESCRIPTION_LENGTH;
    local v98 = utf8.len(v96);

    if v98 and v98 > v97 then
        local v99 = utf8.offset(v96, v97 + 1);

        if v99 then
            v96 = string.sub(v96, 1, v99 - 1);
        else
            v96 = string.sub(v96, 1, v97);
        end;
    end;

    if v96 ~= u11.Text then
        u11.Text = v96;
    end;

    local v100 = u15;
    local Text = u11.Text;
    local v101 = utf8.len(Text) or #Text;
    local v102 = MAX_DESCRIPTION_LENGTH;

    if v100 then
        setLabelChain(v100, (`({v101}/{v102})`));
    end;

    if not u17 then
        return;
    end;

    local v103 = not u7 and "" or string.gsub(u7.Text, "^%s*(.-)%s*$", "%1");
    local v104 = utf8.len(v103) or #v103;
    local v105;

    if MIN_NAME_LENGTH <= v104 then
        v105 = v104 <= MAX_NAME_LENGTH;
    else
        v105 = false;
    end;

    if v105 then
        local v106 = not u9 and "" or string.gsub(u9.Text, "^%s*(.-)%s*$", "%1");
        local v107 = utf8.len(v106) or #v106;

        if MIN_TAG_LENGTH <= v107 then
            v105 = v107 <= MAX_TAG_LENGTH;
        else
            v105 = false;
        end;

        if v105 then
            local v108 = not u11 and "" or string.gsub(u11.Text, "^%s*(.-)%s*$", "%1");
            local v109 = utf8.len(v108) or #v108;

            if v109 >= 1 then
                v105 = v109 <= MAX_DESCRIPTION_LENGTH;
            else
                v105 = false;
            end;
        end;
    end;

    u17.Visible = not v105;
end;

local function notifyServerError(p110) -- Line: 227
    -- upvalues: NotificationController (copy)
    if p110 == "name_filtered" or p110 == "invalid_name" then
        NotificationController:CreateNotification("Guild name not allowed, try another!");

        return;
    end;

    if p110 == "tag_filtered" or p110 == "invalid_tag" then
        NotificationController:CreateNotification("Guild tag not allowed, try another!");

        return;
    end;

    if p110 == "name_too_long" then
        NotificationController:CreateNotification("Guild name is too long");

        return;
    end;

    if p110 == "name_taken" then
        NotificationController:CreateNotification("That guild name is taken");

        return;
    end;

    if p110 == "tag_taken" then
        NotificationController:CreateNotification("That guild tag is taken");

        return;
    end;

    if p110 == "already_in_guild" then
        NotificationController:CreateNotification("You\'re already in a guild!");

        return;
    end;

    if p110 == "no_creation_token" then
        NotificationController:CreateNotification("You need to purchase Guild Creation first");

        return;
    end;

    if p110 == "invalid_description" then
        NotificationController:CreateNotification("That description isn\'t allowed");

        return;
    end;

    if p110 == "description_too_long" then
        NotificationController:CreateNotification("Guild description is too long");

        return;
    end;

    if p110 == "description_filtered" then
        NotificationController:CreateNotification("Description not allowed, try another!");

        return;
    end;

    if p110 == "filter_unavailable" then
        NotificationController:CreateNotification("Couldn\'t verify that text right now - try again in a moment!");

        return;
    end;

    if p110 then
        NotificationController:CreateNotification((`Failed to create guild ({p110})`));

        return;
    end;

    NotificationController:CreateNotification("Failed to create guild");
end;

local function notifySuccess(p111, p112) -- Line: 259
    -- upvalues: u20 (ref), u21 (ref), NotificationController (copy)
    local v113 = u20;
    local format = string.format;
    local v114 = math.floor(v113.R * 255 + 0.5);
    local v115 = math.clamp(v114, 0, 255);
    local v116 = math.floor(v113.G * 255 + 0.5);
    local v117 = math.clamp(v116, 0, 255);
    local v118 = math.floor(v113.B * 255 + 0.5);
    local v119 = format("#%02X%02X%02X", v115, v117, (math.clamp(v118, 0, 255)));
    local v120 = u21;
    local format2 = string.format;
    local v121 = math.floor(v120.R * 255 + 0.5);
    local v122 = math.clamp(v121, 0, 255);
    local v123 = math.floor(v120.G * 255 + 0.5);
    local v124 = math.clamp(v123, 0, 255);
    local v125 = math.floor(v120.B * 255 + 0.5);
    local v126 = format2("#%02X%02X%02X", v122, v124, (math.clamp(v125, 0, 255)));
    NotificationController:CreateNotification((string.format("Created Guild: <font color=\"%s\">%s</font> [<font color=\"%s\">%s</font>]", v119, p111, v126, p112)));
end;

local function fireCreate(u127, u128, u129) -- Line: 270
    -- upvalues: Networking (copy), u20 (ref), u21 (ref), color3ToHex (copy), u22 (ref), u23 (ref), NotificationController (copy), notifyServerError (copy), GuiController (copy)
    task.spawn(function() -- Line: 272
        -- upvalues: Networking (ref), u127 (copy), u128 (copy), u20 (ref), u21 (ref), u129 (copy), color3ToHex (ref), u22 (ref), u23 (ref), NotificationController (ref), notifyServerError (ref), GuiController (ref)
        local v143, v144, v145 = pcall(function() -- Line: 273
            -- upvalues: Networking (ref), u127 (ref), u128 (ref), u20 (ref), u21 (ref), u129 (ref), color3ToHex (ref), u22 (ref)
            local CreateGuild = Networking.Guild.CreateGuild;
            local v130 = u20;
            local format = string.format;
            local v131 = math.floor(v130.R * 255 + 0.5);
            local v132 = math.clamp(v131, 0, 255);
            local v133 = math.floor(v130.G * 255 + 0.5);
            local v134 = math.clamp(v133, 0, 255);
            local v135 = math.floor(v130.B * 255 + 0.5);
            local v136 = format("#%02X%02X%02X", v132, v134, (math.clamp(v135, 0, 255)));
            local v137 = u21;
            local format2 = string.format;
            local v138 = math.floor(v137.R * 255 + 0.5);
            local v139 = math.clamp(v138, 0, 255);
            local v140 = math.floor(v137.G * 255 + 0.5);
            local v141 = math.clamp(v140, 0, 255);
            local v142 = math.floor(v137.B * 255 + 0.5);

            return CreateGuild:Fire(u127, u128, v136, format2("#%02X%02X%02X", v139, v141, (math.clamp(v142, 0, 255))), u129, color3ToHex(u22));
        end);
        u23 = false;

        if not v143 then
            NotificationController:CreateNotification("Failed to create guild");

            return;
        end;

        if not v144 then
            local v146 = typeof(v145) == "string" and v145 and v145 or nil;

            if v146 == "name_taken" then
                NotificationController:CreateNotification("That guild name is already taken, but don\'t worry - your next creation is free!");

                return;
            end;

            if v146 == "tag_taken" then
                NotificationController:CreateNotification("That guild tag is already taken, but don\'t worry - your next creation is free!");

                return;
            end;

            notifyServerError(v146);

            return;
        end;

        local v147 = u20;
        local format = string.format;
        local v148 = math.floor(v147.R * 255 + 0.5);
        local v149 = math.clamp(v148, 0, 255);
        local v150 = math.floor(v147.G * 255 + 0.5);
        local v151 = math.clamp(v150, 0, 255);
        local v152 = math.floor(v147.B * 255 + 0.5);
        local v153 = format("#%02X%02X%02X", v149, v151, (math.clamp(v152, 0, 255)));
        local v154 = u21;
        local format2 = string.format;
        local v155 = math.floor(v154.R * 255 + 0.5);
        local v156 = math.clamp(v155, 0, 255);
        local v157 = math.floor(v154.G * 255 + 0.5);
        local v158 = math.clamp(v157, 0, 255);
        local v159 = math.floor(v154.B * 255 + 0.5);
        local v160 = format2("#%02X%02X%02X", v156, v158, (math.clamp(v159, 0, 255)));
        NotificationController:CreateNotification((string.format("Created Guild: <font color=\"%s\">%s</font> [<font color=\"%s\">%s</font>]", v153, u127, v160, u128)));
        GuiController:Open("ViewGuildPage", nil, { "HUD" });

        if GuiController:IsOpen("CreateGuild") then
            GuiController:Close();
        end;
    end);
end;

local function promptCreatePurchase(u161, u162, u163) -- Line: 323
    -- upvalues: DevProductController (copy), Networking (copy), u20 (ref), u21 (ref), color3ToHex (copy), u22 (ref), u23 (ref), NotificationController (copy), notifyServerError (copy), GuiController (copy)
    local u164 = false;
    local u165 = false;
    local v167 = DevProductController.PurchaseComplete:Connect(function(p166) -- Line: 331
        -- upvalues: u165 (ref), u164 (ref)
        if p166 == "Guild:Guild Creation:1" then
            u165 = true;
            u164 = true;
        end;
    end);
    local v170 = DevProductController.PurchaseFailed:Connect(function(p168, p169) -- Line: 337
        -- upvalues: u164 (ref)
        if p168 == "Guild:Guild Creation:1" then
            u164 = true;
        end;
    end);
    local v172 = DevProductController.PurchaseCancelled:Connect(function(p171) -- Line: 342
        -- upvalues: u164 (ref)
        if p171 == "Guild:Guild Creation:1" then
            u164 = true;
        end;
    end);
    local v173, v174 = DevProductController:PromptPurchase("Guild:Guild Creation:1");

    if v173 then
        if v174 ~= "Prompted Robux" and not u164 then
            u165 = true;
            u164 = true;
        end;
    else
        u164 = true;
    end;

    local v175 = os.clock();

    while not u164 and os.clock() - v175 < 60 do
        task.wait(0.1);
    end;

    if v167 then
        v167:Disconnect();
    end;

    if v170 then
        v170:Disconnect();
    end;

    if v172 then
        v172:Disconnect();
    end;

    if u165 then
        task.spawn(function() -- Line: 272
            -- upvalues: Networking (ref), u161 (copy), u162 (copy), u20 (ref), u21 (ref), u163 (copy), color3ToHex (ref), u22 (ref), u23 (ref), NotificationController (ref), notifyServerError (ref), GuiController (ref)
            local v189, v190, v191 = pcall(function() -- Line: 273
                -- upvalues: Networking (ref), u161 (ref), u162 (ref), u20 (ref), u21 (ref), u163 (ref), color3ToHex (ref), u22 (ref)
                local CreateGuild = Networking.Guild.CreateGuild;
                local v176 = u20;
                local format = string.format;
                local v177 = math.floor(v176.R * 255 + 0.5);
                local v178 = math.clamp(v177, 0, 255);
                local v179 = math.floor(v176.G * 255 + 0.5);
                local v180 = math.clamp(v179, 0, 255);
                local v181 = math.floor(v176.B * 255 + 0.5);
                local v182 = format("#%02X%02X%02X", v178, v180, (math.clamp(v181, 0, 255)));
                local v183 = u21;
                local format2 = string.format;
                local v184 = math.floor(v183.R * 255 + 0.5);
                local v185 = math.clamp(v184, 0, 255);
                local v186 = math.floor(v183.G * 255 + 0.5);
                local v187 = math.clamp(v186, 0, 255);
                local v188 = math.floor(v183.B * 255 + 0.5);

                return CreateGuild:Fire(u161, u162, v182, format2("#%02X%02X%02X", v185, v187, (math.clamp(v188, 0, 255))), u163, color3ToHex(u22));
            end);
            u23 = false;

            if not v189 then
                NotificationController:CreateNotification("Failed to create guild");

                return;
            end;

            if not v190 then
                local v192 = typeof(v191) == "string" and v191 and v191 or nil;

                if v192 == "name_taken" then
                    NotificationController:CreateNotification("That guild name is already taken, but don\'t worry - your next creation is free!");

                    return;
                end;

                if v192 == "tag_taken" then
                    NotificationController:CreateNotification("That guild tag is already taken, but don\'t worry - your next creation is free!");

                    return;
                end;

                notifyServerError(v192);

                return;
            end;

            local v193 = u20;
            local format = string.format;
            local v194 = math.floor(v193.R * 255 + 0.5);
            local v195 = math.clamp(v194, 0, 255);
            local v196 = math.floor(v193.G * 255 + 0.5);
            local v197 = math.clamp(v196, 0, 255);
            local v198 = math.floor(v193.B * 255 + 0.5);
            local v199 = format("#%02X%02X%02X", v195, v197, (math.clamp(v198, 0, 255)));
            local v200 = u21;
            local format2 = string.format;
            local v201 = math.floor(v200.R * 255 + 0.5);
            local v202 = math.clamp(v201, 0, 255);
            local v203 = math.floor(v200.G * 255 + 0.5);
            local v204 = math.clamp(v203, 0, 255);
            local v205 = math.floor(v200.B * 255 + 0.5);
            local v206 = format2("#%02X%02X%02X", v202, v204, (math.clamp(v205, 0, 255)));
            NotificationController:CreateNotification((string.format("Created Guild: <font color=\"%s\">%s</font> [<font color=\"%s\">%s</font>]", v199, u161, v206, u162)));
            GuiController:Open("ViewGuildPage", nil, { "HUD" });

            if GuiController:IsOpen("CreateGuild") then
                GuiController:Close();
            end;
        end);
    else
        u23 = false;
    end;
end;

local function tryCreate() -- Line: 377
    -- upvalues: u23 (ref), u7 (ref), u9 (ref), u11 (ref), NotificationController (copy), MIN_NAME_LENGTH (copy), MAX_NAME_LENGTH (copy), MIN_TAG_LENGTH (copy), MAX_TAG_LENGTH (copy), MAX_DESCRIPTION_LENGTH (copy), LocalPlayer (copy), Networking (copy), notifyServerError (copy), u20 (ref), u21 (ref), color3ToHex (copy), u22 (ref), GuiController (copy), promptCreatePurchase (copy)
    if u23 then
        return;
    end;

    local u207 = not u7 and "" or string.gsub(u7.Text, "^%s*(.-)%s*$", "%1");
    local u208 = not u9 and "" or string.gsub(u9.Text, "^%s*(.-)%s*$", "%1");
    local u209 = not u11 and "" or string.gsub(u11.Text, "^%s*(.-)%s*$", "%1");
    local v210 = utf8.len(u207) or #u207;
    local v211 = utf8.len(u208) or #u208;
    local v212 = utf8.len(u209) or #u209;

    if v210 < 1 then
        NotificationController:CreateNotification("Enter a guild name first!");

        return;
    end;

    if v210 < MIN_NAME_LENGTH or MAX_NAME_LENGTH < v210 then
        NotificationController:CreateNotification((`Guild name must be {MIN_NAME_LENGTH}-{MAX_NAME_LENGTH} characters`));

        return;
    end;

    if v211 < MIN_TAG_LENGTH or MAX_TAG_LENGTH < v211 then
        NotificationController:CreateNotification("Guild tag must be 2-5 characters");

        return;
    end;

    if v212 < 1 then
        NotificationController:CreateNotification("Enter a guild description first!");

        return;
    end;

    if MAX_DESCRIPTION_LENGTH < v212 then
        NotificationController:CreateNotification("Guild description is too long");

        return;
    end;

    if LocalPlayer:GetAttribute("GuildId") ~= nil then
        NotificationController:CreateNotification("You\'re already in a guild!");

        return;
    end;

    u23 = true;
    task.spawn(function() -- Line: 420
        -- upvalues: Networking (ref), u207 (copy), u208 (copy), u209 (copy), u23 (ref), NotificationController (ref), notifyServerError (ref), u20 (ref), u21 (ref), color3ToHex (ref), u22 (ref), GuiController (ref), promptCreatePurchase (ref)
        local v213, v214, v215, v216 = pcall(function() -- Line: 421
            -- upvalues: Networking (ref), u207 (ref), u208 (ref), u209 (ref)
            return Networking.Guild.CheckCreateAvailability:Fire(u207, u208, u209);
        end);

        if not v213 then
            u23 = false;
            NotificationController:CreateNotification("Failed to create guild");

            return;
        end;

        if not v214 then
            u23 = false;
            notifyServerError(typeof(v215) == "string" and v215 and v215 or nil);

            return;
        end;

        if not v216 then
            promptCreatePurchase(u207, u208, u209);

            return;
        end;

        local u217 = u207;
        local u218 = u208;
        local u219 = u209;
        task.spawn(function() -- Line: 272
            -- upvalues: Networking (ref), u217 (copy), u218 (copy), u20 (ref), u21 (ref), u219 (copy), color3ToHex (ref), u22 (ref), u23 (ref), NotificationController (ref), notifyServerError (ref), GuiController (ref)
            local v233, v234, v235 = pcall(function() -- Line: 273
                -- upvalues: Networking (ref), u217 (ref), u218 (ref), u20 (ref), u21 (ref), u219 (ref), color3ToHex (ref), u22 (ref)
                local CreateGuild = Networking.Guild.CreateGuild;
                local v220 = u20;
                local format = string.format;
                local v221 = math.floor(v220.R * 255 + 0.5);
                local v222 = math.clamp(v221, 0, 255);
                local v223 = math.floor(v220.G * 255 + 0.5);
                local v224 = math.clamp(v223, 0, 255);
                local v225 = math.floor(v220.B * 255 + 0.5);
                local v226 = format("#%02X%02X%02X", v222, v224, (math.clamp(v225, 0, 255)));
                local v227 = u21;
                local format2 = string.format;
                local v228 = math.floor(v227.R * 255 + 0.5);
                local v229 = math.clamp(v228, 0, 255);
                local v230 = math.floor(v227.G * 255 + 0.5);
                local v231 = math.clamp(v230, 0, 255);
                local v232 = math.floor(v227.B * 255 + 0.5);

                return CreateGuild:Fire(u217, u218, v226, format2("#%02X%02X%02X", v229, v231, (math.clamp(v232, 0, 255))), u219, color3ToHex(u22));
            end);
            u23 = false;

            if not v233 then
                NotificationController:CreateNotification("Failed to create guild");

                return;
            end;

            if not v234 then
                local v236 = typeof(v235) == "string" and v235 and v235 or nil;

                if v236 == "name_taken" then
                    NotificationController:CreateNotification("That guild name is already taken, but don\'t worry - your next creation is free!");

                    return;
                end;

                if v236 == "tag_taken" then
                    NotificationController:CreateNotification("That guild tag is already taken, but don\'t worry - your next creation is free!");

                    return;
                end;

                notifyServerError(v236);

                return;
            end;

            local v237 = u20;
            local format = string.format;
            local v238 = math.floor(v237.R * 255 + 0.5);
            local v239 = math.clamp(v238, 0, 255);
            local v240 = math.floor(v237.G * 255 + 0.5);
            local v241 = math.clamp(v240, 0, 255);
            local v242 = math.floor(v237.B * 255 + 0.5);
            local v243 = format("#%02X%02X%02X", v239, v241, (math.clamp(v242, 0, 255)));
            local v244 = u21;
            local format2 = string.format;
            local v245 = math.floor(v244.R * 255 + 0.5);
            local v246 = math.clamp(v245, 0, 255);
            local v247 = math.floor(v244.G * 255 + 0.5);
            local v248 = math.clamp(v247, 0, 255);
            local v249 = math.floor(v244.B * 255 + 0.5);
            local v250 = format2("#%02X%02X%02X", v246, v248, (math.clamp(v249, 0, 255)));
            NotificationController:CreateNotification((string.format("Created Guild: <font color=\"%s\">%s</font> [<font color=\"%s\">%s</font>]", v243, u217, v250, u218)));
            GuiController:Open("ViewGuildPage", nil, { "HUD" });

            if GuiController:IsOpen("CreateGuild") then
                GuiController:Close();
            end;
        end);
    end);
end;

local function ResolveRefs(p251) -- Line: 449
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), u13 (ref), u9 (ref), u10 (ref), u14 (ref), u11 (ref), u12 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref)
    local MainPage = p251:FindFirstChild("MainPage");

    if not MainPage then
        return;
    end;

    local Header = MainPage:FindFirstChild("Header");

    if Header then
        local ExitButton = Header:FindFirstChild("ExitButton");

        if ExitButton and ExitButton:IsA("GuiButton") then
            u6 = ExitButton;
        end;
    end;

    local Content = MainPage:FindFirstChild("Content");

    if Content then
        local Name = Content:FindFirstChild("Name");

        if Name then
            local TextField = Name:FindFirstChild("TextField");

            if TextField then
                local TextBox = TextField:FindFirstChild("TextBox");

                if TextBox and TextBox:IsA("TextBox") then
                    u7 = TextBox;
                end;
            end;

            local ColorPickerButton = Name:FindFirstChild("ColorPickerButton");

            if ColorPickerButton and ColorPickerButton:IsA("GuiButton") then
                u8 = ColorPickerButton;
            end;

            local CharacterCounter = Name:FindFirstChild("CharacterCounter");

            if CharacterCounter and CharacterCounter:IsA("TextLabel") then
                u13 = CharacterCounter;
            end;
        end;

        local Tag = Content:FindFirstChild("Tag");

        if Tag then
            local TextField = Tag:FindFirstChild("TextField");

            if TextField then
                local TextBox = TextField:FindFirstChild("TextBox");

                if TextBox and TextBox:IsA("TextBox") then
                    u9 = TextBox;
                end;
            end;

            local ColorPickerButton = Tag:FindFirstChild("ColorPickerButton");

            if ColorPickerButton and ColorPickerButton:IsA("GuiButton") then
                u10 = ColorPickerButton;
            end;

            local CharacterCounter = Tag:FindFirstChild("CharacterCounter");

            if CharacterCounter and CharacterCounter:IsA("TextLabel") then
                u14 = CharacterCounter;
            end;
        end;

        local Description = Content:FindFirstChild("Description");

        if Description then
            local TextField = Description:FindFirstChild("TextField");

            if TextField then
                local TextBox = TextField:FindFirstChild("TextBox");

                if TextBox and TextBox:IsA("TextBox") then
                    u11 = TextBox;
                end;
            end;

            local ColorPickerButton = Description:FindFirstChild("ColorPickerButton");

            if ColorPickerButton and ColorPickerButton:IsA("GuiButton") then
                u12 = ColorPickerButton;
            end;

            local CharacterCounter = Description:FindFirstChild("CharacterCounter");

            if CharacterCounter and CharacterCounter:IsA("TextLabel") then
                u15 = CharacterCounter;
            end;
        end;
    end;

    local CreateButton = MainPage:FindFirstChild("CreateButton");

    if CreateButton and CreateButton:IsA("GuiButton") then
        u16 = CreateButton;
        local CreateBlock = CreateButton:FindFirstChild("CreateBlock");

        if CreateBlock and CreateBlock:IsA("GuiObject") then
            u17 = CreateBlock;
        end;

        local TextLabel = CreateButton:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            u18 = TextLabel;
            local TextLabel2 = TextLabel:FindFirstChild("TextLabel");

            if TextLabel2 and TextLabel2:IsA("TextLabel") then
                u19 = TextLabel2;
            end;
        end;
    end;
end;

local function BindTextBoxes() -- Line: 539
    -- upvalues: u7 (ref), u20 (ref), clampNameText (copy), u9 (ref), u21 (ref), clampTagText (copy), u11 (ref), u22 (ref), clampDescriptionText (copy)
    if u7 then
        u7.ClearTextOnFocus = false;
        u7.TextColor3 = u20;
        u7:GetPropertyChangedSignal("Text"):Connect(clampNameText);
        clampNameText();
    end;

    if u9 then
        u9.ClearTextOnFocus = false;
        u9.TextColor3 = u21;
        u9:GetPropertyChangedSignal("Text"):Connect(clampTagText);
        clampTagText();
    end;

    if u11 then
        u11.ClearTextOnFocus = false;
        u11.TextColor3 = u22;
        u11:GetPropertyChangedSignal("Text"):Connect(clampDescriptionText);
        clampDescriptionText();
    end;
end;

local function BindColorPickers() -- Line: 560
    -- upvalues: u8 (ref), ColorPickerGuildController (copy), u20 (ref), u7 (ref), GuiController (copy), u10 (ref), u21 (ref), u9 (ref), u12 (ref), u22 (ref), u11 (ref)
    if u8 then
        u8.MouseButton1Click:Connect(function() -- Line: 562
            -- upvalues: ColorPickerGuildController (ref), u20 (ref), u7 (ref), GuiController (ref)
            ColorPickerGuildController:RequestColor(u20, function(p252) -- Line: 563
                -- upvalues: u20 (ref), u7 (ref), GuiController (ref)
                if p252 then
                    u20 = p252;

                    if u7 then
                        u7.TextColor3 = p252;
                    end;
                end;

                if not GuiController:IsOpen("CreateGuild") then
                    GuiController:Open("CreateGuild", nil, { "HUD" });
                end;
            end);
        end);
    end;

    if u10 then
        u10.MouseButton1Click:Connect(function() -- Line: 575
            -- upvalues: ColorPickerGuildController (ref), u21 (ref), u9 (ref), GuiController (ref)
            ColorPickerGuildController:RequestColor(u21, function(p253) -- Line: 576
                -- upvalues: u21 (ref), u9 (ref), GuiController (ref)
                if p253 then
                    u21 = p253;

                    if u9 then
                        u9.TextColor3 = p253;
                    end;
                end;

                if not GuiController:IsOpen("CreateGuild") then
                    GuiController:Open("CreateGuild", nil, { "HUD" });
                end;
            end);
        end);
    end;

    if u12 then
        u12.MouseButton1Click:Connect(function() -- Line: 587
            -- upvalues: ColorPickerGuildController (ref), u22 (ref), u11 (ref), GuiController (ref)
            ColorPickerGuildController:RequestColor(u22, function(p254) -- Line: 588
                -- upvalues: u22 (ref), u11 (ref), GuiController (ref)
                if p254 then
                    u22 = p254;

                    if u11 then
                        u11.TextColor3 = p254;
                    end;
                end;

                if not GuiController:IsOpen("CreateGuild") then
                    GuiController:Open("CreateGuild", nil, { "HUD" });
                end;
            end);
        end);
    end;
end;

local function BindInviteButtons() -- Line: 600
end;

local function BindCreateButton() -- Line: 605
    -- upvalues: u16 (ref), setLabelChain (copy), u18 (ref), u19 (ref), tryCreate (copy)
    if not u16 then
        return;
    end;

    u16.MouseEnter:Connect(function() -- Line: 608
        -- upvalues: setLabelChain (ref), u18 (ref), u19 (ref)
        setLabelChain(u18, "99 R$");
        setLabelChain(u19, "99 R$");
    end);
    u16.MouseLeave:Connect(function() -- Line: 612
        -- upvalues: setLabelChain (ref), u18 (ref), u19 (ref)
        setLabelChain(u18, "Create");
        setLabelChain(u19, "Create");
    end);
    u16.MouseButton1Click:Connect(tryCreate);
end;

local function BindExitButton() -- Line: 619
    -- upvalues: u6 (ref), GuiController (copy)
    if not u6 then
        return;
    end;

    u6.MouseButton1Click:Connect(function() -- Line: 621
        -- upvalues: GuiController (ref)
        if GuiController:IsOpen("CreateGuild") then
            GuiController:Close();
        end;
    end);
end;

local function ResetOnOpen() -- Line: 628
    -- upvalues: setLabelChain (copy), u18 (ref), u19 (ref), u17 (ref), u7 (ref), MIN_NAME_LENGTH (copy), MAX_NAME_LENGTH (copy), u9 (ref), MIN_TAG_LENGTH (copy), MAX_TAG_LENGTH (copy), u11 (ref), MAX_DESCRIPTION_LENGTH (copy)
    setLabelChain(u18, "Create");
    setLabelChain(u19, "Create");

    if not u17 then
        return;
    end;

    local v255 = not u7 and "" or string.gsub(u7.Text, "^%s*(.-)%s*$", "%1");
    local v256 = utf8.len(v255) or #v255;
    local v257;

    if MIN_NAME_LENGTH <= v256 then
        v257 = v256 <= MAX_NAME_LENGTH;
    else
        v257 = false;
    end;

    if v257 then
        local v258 = not u9 and "" or string.gsub(u9.Text, "^%s*(.-)%s*$", "%1");
        local v259 = utf8.len(v258) or #v258;

        if MIN_TAG_LENGTH <= v259 then
            v257 = v259 <= MAX_TAG_LENGTH;
        else
            v257 = false;
        end;

        if v257 then
            local v260 = not u11 and "" or string.gsub(u11.Text, "^%s*(.-)%s*$", "%1");
            local v261 = utf8.len(v260) or #v260;

            if v261 >= 1 then
                v257 = v261 <= MAX_DESCRIPTION_LENGTH;
            else
                v257 = false;
            end;
        end;
    end;

    u17.Visible = not v257;
end;

function v4.Init(p262) -- Line: 637
end;

function v4.Start(p263) -- Line: 639
    -- upvalues: PlayerGui (copy), u5 (ref), ResolveRefs (copy), u6 (ref), GuiController (copy), BindTextBoxes (copy), BindColorPickers (copy), BindCreateButton (copy), setLabelChain (copy), u18 (ref), u19 (ref), u17 (ref), u7 (ref), trim (copy), MIN_NAME_LENGTH (copy), MAX_NAME_LENGTH (copy), u9 (ref), MIN_TAG_LENGTH (copy), MAX_TAG_LENGTH (copy), u11 (ref), MAX_DESCRIPTION_LENGTH (copy)
    task.spawn(function() -- Line: 640
        -- upvalues: PlayerGui (ref), u5 (ref), ResolveRefs (ref), u6 (ref), GuiController (ref), BindTextBoxes (ref), BindColorPickers (ref), BindCreateButton (ref), setLabelChain (ref), u18 (ref), u19 (ref), u17 (ref), u7 (ref), trim (ref), MIN_NAME_LENGTH (ref), MAX_NAME_LENGTH (ref), u9 (ref), MIN_TAG_LENGTH (ref), MAX_TAG_LENGTH (ref), u11 (ref), MAX_DESCRIPTION_LENGTH (ref)
        local CreateGuild = PlayerGui:WaitForChild("CreateGuild", 30);

        if not (CreateGuild and CreateGuild:IsA("ScreenGui")) then
            return;
        end;

        u5 = CreateGuild;
        CreateGuild.Enabled = false;
        ResolveRefs(CreateGuild);

        if u6 then
            u6.MouseButton1Click:Connect(function() -- Line: 621
                -- upvalues: GuiController (ref)
                if GuiController:IsOpen("CreateGuild") then
                    GuiController:Close();
                end;
            end);
        end;

        BindTextBoxes();
        BindColorPickers();
        BindCreateButton();
        GuiController.GuiFocusedSignal:Connect(function(p264) -- Line: 654
            -- upvalues: CreateGuild (copy), setLabelChain (ref), u18 (ref), u19 (ref), u17 (ref), u7 (ref), trim (ref), MIN_NAME_LENGTH (ref), MAX_NAME_LENGTH (ref), u9 (ref), MIN_TAG_LENGTH (ref), MAX_TAG_LENGTH (ref), u11 (ref), MAX_DESCRIPTION_LENGTH (ref)
            if p264 == CreateGuild then
                setLabelChain(u18, "Create");
                setLabelChain(u19, "Create");

                if not u17 then
                    return;
                end;

                local v265 = not u7 and "" or trim(u7.Text);
                local v266 = utf8.len(v265) or #v265;
                local v267;

                if MIN_NAME_LENGTH <= v266 then
                    v267 = v266 <= MAX_NAME_LENGTH;
                else
                    v267 = false;
                end;

                if v267 then
                    local v268 = not u9 and "" or trim(u9.Text);
                    local v269 = utf8.len(v268) or #v268;

                    if MIN_TAG_LENGTH <= v269 then
                        v267 = v269 <= MAX_TAG_LENGTH;
                    else
                        v267 = false;
                    end;

                    if v267 then
                        local v270 = not u11 and "" or trim(u11.Text);
                        local v271 = utf8.len(v270) or #v270;

                        if v271 >= 1 then
                            v267 = v271 <= MAX_DESCRIPTION_LENGTH;
                        else
                            v267 = false;
                        end;
                    end;
                end;

                u17.Visible = not v267;
            end;
        end);
    end);
end;

return v4;