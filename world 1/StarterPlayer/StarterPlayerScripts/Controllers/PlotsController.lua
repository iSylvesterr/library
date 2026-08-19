-- Decompiled with Potassium's decompiler.

local v1 = {};
local LocalPlayer = game.Players.LocalPlayer;
game:GetService("TweenService");
local Gardens = workspace:WaitForChild("Gardens");
local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"));
local ExpansionPrices = require(game.ReplicatedStorage.SharedData.ExpansionPrices);
local GardenFlags = require(game.ReplicatedStorage.SharedModules.Flags.GardenFlags);
local GuildContestFlags = require(game.ReplicatedStorage.SharedModules.Flags.GuildContestFlags);
local NumberUtils = require(game.ReplicatedStorage.SharedModules.NumberUtils);
local Worlds = require(game.ReplicatedStorage.SharedModules.Worlds);
local WerewolfNightData = require(game.ReplicatedStorage.SharedModules.WerewolfNightData);
local PlayerStateClient = require(game:GetService("ReplicatedStorage"):WaitForChild("ClientModules"):WaitForChild("PlayerStateClient"));
local Controllers = game.StarterPlayer.StarterPlayerScripts.Controllers;
local FlashbangVFXController = require(Controllers.FlashbangVFXController);
require(Controllers.NotificationController);
local u2 = require("./SfxController");
local ABTests = require(game:GetService("ReplicatedStorage").UserGenerated.ABTests);

function v1.Init(p3) -- Line: 19
end;

local u4 = UDim2.new(0.65, 0, 0.4, 0);
local u5 = UDim2.new(0.6, 0, 0.7, 0);
local u6 = UDim2.new(0.2, 0, 0.4, 0);
local u7 = {};
local u8 = {};
local u9 = {};

local function disconnectLikesConnections(p10) -- Line: 36
    -- upvalues: u7 (copy)
    local v11 = u7[p10];

    if not v11 then
        return;
    end;

    for _, v in v11 do
        v:Disconnect();
    end;

    u7[p10] = nil;
end;

local function setLikesLayoutActive(p12, p13) -- Line: 47
    -- upvalues: u8 (copy)
    if p13 then
        local v14 = u8[p12];

        if v14 then
            if not p12:FindFirstChildWhichIsA("UIListLayout") then
                v14.Parent = p12;
            end;

            u8[p12] = nil;
        end;
    else
        local v15 = p12:FindFirstChildWhichIsA("UIListLayout");

        if v15 then
            u8[p12] = v15:Clone();
            v15:Destroy();
        end;
    end;
end;

local function applyLikes(p16, u17, u18) -- Line: 65
    -- upvalues: u7 (copy), u9 (copy), u8 (copy), ABTests (copy), u4 (copy), u5 (copy), u6 (copy)
    local Name = p16.Name;
    local v19 = u7[Name];

    if v19 then
        for _, v in v19 do
            v:Disconnect();
        end;

        u7[Name] = nil;
    end;

    local Likes = u17:FindFirstChild("Likes");
    local Player = u17:FindFirstChild("Player");
    local ImageLabel = u17:FindFirstChild("ImageLabel");

    if Player and (Player:IsA("GuiObject") and (ImageLabel and (ImageLabel:IsA("GuiObject") and not u9[u17]))) then
        u9[u17] = {
            PlayerPosition = Player.Position,
            PlayerSize = Player.Size,
            ImagePosition = ImageLabel.Position
        };
    end;

    local function restoreNormal() -- Line: 81
        -- upvalues: u17 (copy), u8 (ref), Likes (copy), u9 (ref), Player (copy), ImageLabel (copy)
        local v20 = u17;
        local v21 = u8[v20];

        if v21 then
            if not v20:FindFirstChildWhichIsA("UIListLayout") then
                v21.Parent = v20;
            end;

            u8[v20] = nil;
        end;

        if Likes and Likes:IsA("GuiObject") then
            Likes.Visible = false;
        end;

        local v22 = u9[u17];

        if v22 then
            if Player and Player:IsA("GuiObject") then
                Player.Position = v22.PlayerPosition;
                Player.Size = v22.PlayerSize;
            end;

            if ImageLabel and ImageLabel:IsA("GuiObject") then
                ImageLabel.Position = v22.ImagePosition;
            end;
        end;
    end;

    if not u18 then
        restoreNormal();

        return;
    end;

    local function render() -- Line: 103
        -- upvalues: ABTests (ref), restoreNormal (copy), u17 (copy), u8 (ref), Player (copy), u4 (ref), u5 (ref), ImageLabel (copy), u6 (ref), Likes (copy), u18 (copy)
        if ABTests.GetJobAttribute("Garden.Likes.Enabled", false) ~= true then
            restoreNormal();

            return;
        end;

        local v23 = u17;
        local v24 = v23:FindFirstChildWhichIsA("UIListLayout");

        if v24 then
            u8[v23] = v24:Clone();
            v24:Destroy();
        end;

        if Player and Player:IsA("GuiObject") then
            Player.Position = u4;
            Player.Size = u5;
        end;

        if ImageLabel and ImageLabel:IsA("GuiObject") then
            ImageLabel.Position = u6;
        end;

        if Likes and Likes:IsA("TextLabel") then
            local v25 = u18:GetAttribute("GardenLikes");
            Likes.Text = `👍 {typeof(v25) ~= "number" and 0 or v25}`;
            Likes.Visible = true;
        end;
    end;

    render();
    u7[p16.Name] = { u18:GetAttributeChangedSignal("GardenLikes"):Connect(render), ABTests.JobUpdated:Connect(render) };
end;

local u26 = {};
local u27 = {};
local u28 = nil;

local function disconnectExpandSignConnections() -- Line: 136
    -- upvalues: u27 (copy)
    for _, v in u27 do
        v:Disconnect();
    end;

    table.clear(u27);
end;

local function clearExpandSignGui() -- Line: 143
    -- upvalues: u27 (copy), u28 (ref)
    for _, v in u27 do
        v:Disconnect();
    end;

    table.clear(u27);

    if u28 then
        u28:Destroy();
        u28 = nil;
    end;
end;

local function getNextExpansionData(p29) -- Line: 179
    -- upvalues: ExpansionPrices (copy)
    return ExpansionPrices[p29 + 1];
end;

local function getNextExpansionPrice(p30, p31) -- Line: 184
    -- upvalues: GardenFlags (copy)
    return GardenFlags.ExpansionPriceOverrides:Get()[tostring(p30 + 1)] or p31.Price;
end;

local Night = game.ReplicatedStorage.Night;
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local u32 = require(game.ReplicatedStorage.SharedModules.Environment).placeType == "FirstSession";
local u33 = {};

local function UpdateTag(p34) -- Line: 195
    -- upvalues: WerewolfNightData (copy), Night (copy), u32 (copy), LocalPlayer (copy), NotificationController (copy)
    if WerewolfNightData.IsEnabled() then
        p34.PlayerFrame.Unlocked.Visible = false;
        p34.PlayerFrame.fade.Visible = false;
        p34.PlayerFrame.toptext.Visible = false;

        return;
    end;

    local Adornee = p34.Adornee;
    local v35 = Adornee and Adornee.Parent and Adornee.Parent.Parent;

    if v35 == nil then
        return;
    end;

    local v36 = v35:GetAttribute("Owner");

    if v36 == nil then
        return;
    end;

    local v37 = game.Players:FindFirstChild(v36);

    if Night.Value == false then
        p34.PlayerFrame.Unlocked.Visible = false;
        p34.PlayerFrame.fade.Visible = false;
        p34.PlayerFrame.toptext.Visible = false;

        return;
    end;

    if v37 == nil then
        return;
    end;

    if v37:GetAttribute("IsInOwnGarden") == true then
        if p34.PlayerFrame.Unlocked.Visible == true and (u32 and v37 == LocalPlayer) then
            NotificationController:CreateNotification("Garden Locked!🔒");
        end;

        p34.PlayerFrame.Unlocked.Visible = false;
        p34.PlayerFrame.fade.Visible = false;
        p34.PlayerFrame.toptext.Visible = false;

        return;
    end;

    if p34.PlayerFrame.Unlocked.Visible == false and (u32 and v37 == LocalPlayer) then
        NotificationController:CreateNotification("Garden Unlocked!🔓");
    end;

    p34.PlayerFrame.Unlocked.Visible = true;
    p34.PlayerFrame.fade.Visible = true;
    p34.PlayerFrame.toptext.Visible = true;
end;

local function setExpandSignModelVisible(p38, p39) -- Line: 166
    for _, descendant in p38:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = p39 and 0 or 1;
            descendant.CanCollide = p39;
        elseif descendant:IsA("Decal") then
            descendant.Transparency = p39 and 0 or 1;
        elseif descendant:IsA("SurfaceGui") or descendant:IsA("BillboardGui") then
            descendant.Enabled = p39;
        end;
    end;
end;

local function getExpandSignTemplate(p40) -- Line: 151
    local SurfaceGui = p40:FindFirstChild("SurfaceGui");

    if SurfaceGui and (SurfaceGui:IsA("BillboardGui") or SurfaceGui:IsA("SurfaceGui")) then
        return SurfaceGui;
    end;

    for _, child in p40:GetChildren() do
        if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
            return child;
        end;
    end;

    return nil;
end;

for _, v in pairs(u33) do
    UpdateTag(v);
end;

Night:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 247
    -- upvalues: u33 (copy), UpdateTag (copy)
    for _, v in pairs(u33) do
        UpdateTag(v);
    end;
end);

function v1.Start(p41) -- Line: 253
    -- upvalues: LocalPlayer (copy), u33 (copy), UpdateTag (copy), applyLikes (copy), u26 (copy), GuildContestFlags (copy), u27 (copy), u28 (ref), Gardens (copy), setExpandSignModelVisible (copy), getExpandSignTemplate (copy), PlayerStateClient (copy), Worlds (copy), ExpansionPrices (copy), GardenFlags (copy), NumberUtils (copy), u2 (copy), FlashbangVFXController (copy), Networking (copy), NotificationController (copy)
    local function setOwnerSign(p42) -- Line: 254
        -- upvalues: LocalPlayer (ref), u33 (ref), UpdateTag (ref), applyLikes (ref), u26 (ref), GuildContestFlags (ref)
        local Signs = p42:FindFirstChild("Signs");

        if Signs then
            Signs = Signs:FindFirstChild("Garden");
        end;

        if not Signs then
            return;
        end;

        local SurfaceGui = Signs:FindFirstChild("SurfaceGui", true);

        if not SurfaceGui then
            return;
        end;

        local Player = SurfaceGui:FindFirstChild("Player");

        if not (Player and Player:FindFirstChild("TextLabel")) then
            return;
        end;

        local u43 = p42:GetAttribute("Owner") or "";
        local v44 = p42:GetAttribute("OwnerUserId");
        local u45 = game.Players:FindFirstChild(u43);

        if not u45 and typeof(v44) == "number" then
            u45 = game.Players:GetPlayerByUserId(v44);
        end;

        local Parent = SurfaceGui.Parent;
        local Part = Parent.Parent.Part;
        local u46 = LocalPlayer.PlayerGui:FindFirstChild(p42.Name) or script.BillboardGui:Clone();
        u46.ResetOnSpawn = false;
        u46.Parent = LocalPlayer.PlayerGui;
        u46.Adornee = p42.Visual.PRIM;
        u46.Name = p42.Name;
        SurfaceGui.Enabled = true;
        Parent.Transparency = 0;
        Parent.CanCollide = true;
        Part.Transparency = 0;
        Part.CanCollide = true;
        u46.Enabled = true;
        table.insert(u33, u46);

        if u45 then
            u45:GetAttributeChangedSignal("IsInOwnGarden"):Connect(function() -- Line: 296
                -- upvalues: UpdateTag (ref), u46 (copy)
                UpdateTag(u46);
            end);
        end;

        UpdateTag(u46);

        if typeof(v44) == "number" then
            if u45 then
                u43 = u45.DisplayName or u43;
            end;

            local function applyOwnerLabel() -- Line: 318
                -- upvalues: u45 (ref), GuildContestFlags (ref), SurfaceGui (copy), u46 (copy), u43 (copy), LocalPlayer (ref)
                local v47 = u45 and u45:GetAttribute("GuildTag");
                local v48 = u45 and u45:GetAttribute("GuildTagColor");
                local v49 = u45 and u45:GetAttribute("GuildColor");

                if typeof(v48) ~= "string" or v48 == "" then
                    v48 = (typeof(v49) ~= "string" or v49 == "") and "#FFFFFF" or v49;
                end;

                local v50 = u45 and u45:GetAttribute("GuildRole") == "Owner";
                local v51 = v50 and (typeof(v47) == "string" and v47 ~= "") and "⭐ " or "";
                local v52 = (typeof(v47) ~= "string" or v47 == "") and "" or `{v51}<font color="{v48}">[{v47}]</font> `;
                local v53 = GuildContestFlags.GardenRankBadgeMaxRank:Get();
                local v54 = u45 and u45:GetAttribute("GuildRank");
                local v55 = u45 and u45:GetAttribute("GuildLastRank");

                if typeof(v54) == "number" and v54 > 0 then
                    v55 = v54;
                elseif typeof(v55) ~= "number" or v55 <= 0 then
                    v55 = nil;
                end;

                local v56 = (v53 <= 0 or (not v55 or v55 > v53)) and "" or `<font color="#FFD700">[#{v55}]</font> `;
                SurfaceGui.Player.TextLabel.RichText = true;
                u46.PlayerFrame.Title.RichText = true;
                SurfaceGui.Player.TextLabel.Text = `{v56}{v52}{u43}'s Garden`;
                u46.PlayerFrame.Title.Text = u45 == LocalPlayer and `{v56}{v52}Your Garden` or `{v56}{v52}{u43}'s Garden`;
            end;

            applyOwnerLabel();
            SurfaceGui.ImageLabel.Image = `rbxthumb://type=AvatarHeadShot&id={v44}&w=150&h=150`;
            SurfaceGui.ImageLabel.Visible = true;
            u46.PlayerFrame.Headshot.Image = `rbxthumb://type=AvatarHeadShot&id={v44}&w=420&h=420`;
            applyLikes(p42, SurfaceGui, u45);

            if u45 then
                u45:GetAttributeChangedSignal("GuildTag"):Connect(applyOwnerLabel);
                u45:GetAttributeChangedSignal("GuildColor"):Connect(applyOwnerLabel);
                u45:GetAttributeChangedSignal("GuildTagColor"):Connect(applyOwnerLabel);
                u45:GetAttributeChangedSignal("GuildRole"):Connect(applyOwnerLabel);
                u45:GetAttributeChangedSignal("GuildRank"):Connect(applyOwnerLabel);
                u45:GetAttributeChangedSignal("GuildLastRank"):Connect(applyOwnerLabel);
            end;

            if u26[p42.Name] then
                u26[p42.Name]:Disconnect();
            end;
        else
            SurfaceGui.Player.TextLabel.Text = "Empty Garden";
            SurfaceGui.ImageLabel.Image = "";
            SurfaceGui.ImageLabel.Visible = false;
            u46.PlayerFrame.Title.Text = "Empty Garden";
            u46.PlayerFrame.Headshot.Image = "";
            u46.Enabled = false;
            applyLikes(p42, SurfaceGui, nil);

            if u26[p42.Name] then
                u26[p42.Name]:Disconnect();
                u26[p42.Name] = nil;
            end;
        end;
    end;

    local u57 = false;

    local function setupPlots() -- Line: 393
        -- upvalues: u27 (ref), u28 (ref), LocalPlayer (ref), Gardens (ref), u57 (ref), setOwnerSign (copy), setExpandSignModelVisible (ref), getExpandSignTemplate (ref), PlayerStateClient (ref), Worlds (ref), ExpansionPrices (ref), GardenFlags (ref), NumberUtils (ref), u2 (ref), FlashbangVFXController (ref), Networking (ref), NotificationController (ref)
        for _, v in u27 do
            v:Disconnect();
        end;

        table.clear(u27);

        if u28 then
            u28:Destroy();
            u28 = nil;
        end;

        local v58 = LocalPlayer:GetAttribute("PlotId");

        for _, child in Gardens:GetChildren() do
            if not u57 then
                setOwnerSign(child);
                child:GetAttributeChangedSignal("Owner"):Connect(function() -- Line: 400
                    -- upvalues: setOwnerSign (ref), child (copy)
                    setOwnerSign(child);
                end);
                child:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- Line: 403
                    -- upvalues: setOwnerSign (ref), child (copy)
                    setOwnerSign(child);
                end);
            end;

            local v59;

            if v58 then
                v59 = child.Name == `Plot{v58}`;
            else
                v59 = v58;
            end;

            local Signs = child:FindFirstChild("Signs");

            if Signs then
                Signs = Signs:FindFirstChild("Expand");
            end;

            if Signs then
                setExpandSignModelVisible(Signs, v59 == true);
            end;

            if Signs then
                Signs = Signs:FindFirstChild("CorePart");
            end;

            local v60;

            if Signs then
                v60 = getExpandSignTemplate(Signs);
            else
                v60 = Signs;
            end;

            if v59 then
                if workspace:GetAttribute("SkillPointsOn") == true then
                    local SkillData = LocalPlayer:WaitForChild("SkillData", 5);
                    local u61;

                    if SkillData then
                        u61 = SkillData:WaitForChild("SkillPoints", 5);
                    else
                        u61 = SkillData;
                    end;

                    local u62;

                    if SkillData then
                        u62 = SkillData:WaitForChild("BaseSpeed", 5);
                    else
                        u62 = SkillData;
                    end;

                    local u63;

                    if SkillData then
                        u63 = SkillData:WaitForChild("BaseJump", 5);
                    else
                        u63 = SkillData;
                    end;

                    local u64;

                    if SkillData then
                        u64 = SkillData:WaitForChild("ShovelPower", 5);
                    else
                        u64 = SkillData;
                    end;

                    local u65 = SkillData and SkillData:WaitForChild("MaxBackpack", 5);

                    if u61 and (u62 and (u63 and (u64 and u65))) then
                        local BillboardGui = child.Signs.Garden.CorePart.Notification.BillboardGui;
                        local Notification = BillboardGui.Notification;

                        local function updateSkillPointUI() -- Line: 432
                            -- upvalues: u61 (copy), u62 (copy), u63 (copy), u64 (copy), u65 (copy), BillboardGui (copy), Notification (copy)
                            local v66 = u61.Value >= math.min(u62.Value, u63.Value, u64.Value, u65.Value);
                            BillboardGui.Enabled = v66;
                            Notification.Visible = v66;
                        end;

                        local v67 = u61.Value >= math.min(u62.Value, u63.Value, u64.Value, u65.Value);
                        BillboardGui.Enabled = v67;
                        Notification.Visible = v67;
                        u61.Changed:Connect(updateSkillPointUI);
                        u62.Changed:Connect(updateSkillPointUI);
                        u63.Changed:Connect(updateSkillPointUI);
                        u64.Changed:Connect(updateSkillPointUI);
                        u65.Changed:Connect(updateSkillPointUI);
                    end;
                else
                    local Notification = child.Signs.Garden.CorePart:FindFirstChild("Notification");

                    if Notification then
                        Notification = Notification:FindFirstChildWhichIsA("BillboardGui");
                    end;

                    if Notification then
                        Notification.Enabled = false;
                        local Notification2 = Notification:FindFirstChild("Notification");

                        if Notification2 and Notification2:IsA("GuiObject") then
                            Notification2.Visible = false;
                        end;
                    end;
                end;

                if Signs and v60 then
                    local v68 = v60:Clone();
                    v60:Destroy();
                    v68.Name = "ExpandSignGui";
                    v68.ResetOnSpawn = false;
                    v68.Parent = LocalPlayer.PlayerGui;
                    v68.Adornee = Signs;
                    v68.Enabled = true;
                    u28 = v68;
                    local TextButton = v68:FindFirstChild("TextButton", true);
                    local TextLabel = v68:FindFirstChild("TextLabel", true);

                    if TextButton and (TextButton:IsA("GuiButton") and (TextLabel and TextLabel:IsA("TextLabel"))) then
                        local u69 = PlayerStateClient:WaitForLocalReplica(30);
                        local u70 = Worlds.WaitForWalletStat(LocalPlayer, 30);

                        if u70 then
                            local u71 = true;

                            local function updateExpandSign() -- Line: 485
                                -- upvalues: u69 (copy), ExpansionPrices (ref), GardenFlags (ref), TextButton (copy), u70 (copy), TextLabel (copy), NumberUtils (ref), Worlds (ref)
                                local v72 = u69 and (u69.Data.OwnedExpansions or 1) or 1;
                                local v73 = ExpansionPrices[v72 + 1];

                                if not v73 then
                                    TextButton.Active = false;
                                    TextButton.BackgroundColor3 = Color3.new(1, 0, 0);
                                    TextLabel.Text = "MAX";

                                    return;
                                end;

                                local v74 = GardenFlags.ExpansionPriceOverrides:Get()[tostring(v72 + 1)] or v73.Price;
                                TextButton.Active = true;
                                local v75;

                                if v74 <= u70.Value then
                                    v75 = Color3.new(0, 0.666667, 0);
                                else
                                    v75 = Color3.new(1, 0, 0);
                                end;

                                TextButton.BackgroundColor3 = v75;
                                TextLabel.Text = NumberUtils.Abbreviate(v74) .. Worlds.Current.CurrencySuffix;
                            end;

                            table.insert(u27, TextButton.Activated:Connect(function() -- Line: 503
                                -- upvalues: LocalPlayer (ref), u71 (ref), u69 (copy), ExpansionPrices (ref), GardenFlags (ref), u70 (copy), u2 (ref), FlashbangVFXController (ref), Networking (ref), NotificationController (ref)
                                if LocalPlayer:GetAttribute("LoadingScreenActive") then
                                    return;
                                end;

                                if LocalPlayer:GetAttribute("IsStealingFruit") or LocalPlayer:GetAttribute("CarryingStolenFruit") then
                                    return;
                                end;

                                if not u71 then
                                    return;
                                end;

                                local v76 = u69 and (u69.Data.OwnedExpansions or 1) or 1;
                                local v77 = ExpansionPrices[v76 + 1];

                                if not v77 then
                                    return;
                                end;

                                if (GardenFlags.ExpansionPriceOverrides:Get()[tostring(v76 + 1)] or v77.Price) > u70.Value then
                                    u2:PlaySFX("Failed");
                                    NotificationController:CreateNotification("You can\'t afford this!");

                                    return;
                                end;

                                u71 = false;
                                u2:PlaySFX("Purchase");
                                FlashbangVFXController:Flash(0.5);
                                task.spawn(function() -- Line: 518
                                    -- upvalues: Networking (ref), u71 (ref)
                                    task.wait(0.5);
                                    Networking.Actions.ExpandGarden:Fire();
                                    u71 = true;
                                end);
                            end));
                            local v78 = u70:GetPropertyChangedSignal("Value");
                            table.insert(u27, v78:Connect(updateExpandSign));
                            table.insert(u27, GardenFlags.ExpansionPriceOverrides.Changed:Connect(updateExpandSign));
                            table.insert(u27, GardenFlags.ExpansionPriceOverrides.Loaded:Connect(updateExpandSign));

                            if u69 then
                                table.insert(u27, u69:OnSet({ "OwnedExpansions" }, updateExpandSign));
                            end;

                            updateExpandSign();
                        end;
                    end;
                end;
            end;
        end;

        u57 = true;
    end;

    setupPlots();
    LocalPlayer:GetAttributeChangedSignal("PlotId"):Connect(setupPlots);
end;

return v1;