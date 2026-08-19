-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
require(ReplicatedStorage.SharedModules.Environment);
local ReleaseCountdownController = require(script.Parent.ReleaseCountdownController);
local SfxController = require(script.Parent.SfxController);
local FlashbangVFXController = require(script.Parent.FlashbangVFXController);
local u1 = UDim2.new(0.5, 0, 0.05, 0);
local u2 = UDim2.new(0.5, 0, 0.05, 60);
local u3 = UDim2.new(0.5, 0, 0.2, 0);
local u4 = { 3600, 2700, 1800, 1200, 600, 300 };
local u5 = Color3.new(0, 0, 0);
local u6 = Color3.new(1, 1, 1);
local u7 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u8 = TweenInfo.new(0.5, Enum.EasingStyle.Quad);
local u9 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u10 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u11 = { "SkillPointSFX", "RecordSale" };
local v12 = {};
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = {};
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = {};
local u22 = (1 / 0);
local u23 = false;
local u24 = false;
local u25 = 0;
local u26 = false;
local u27 = 0;
local u28 = false;
local u29 = false;
local u30 = false;
local u31 = "";
local u32 = "";
local u33 = 0;

local function dbg(...) -- Line: 140
end;

local function fmtPopdown(p34) -- Line: 146
    local v35 = math.floor(p34);
    local v36 = math.max(0, v35);
    local v37 = v36 // 3600;
    local v38 = v36 % 3600 // 60;
    local v39 = v36 % 60;

    if v37 > 0 then
        return string.format("%dh %dm %ds", v37, v38, v39);
    end;

    if v38 <= 0 then
        return string.format("%ds", v39);
    end;

    if v39 == 0 then
        return string.format("%dm", v38);
    end;

    return string.format("%dm %ds", v38, v39);
end;

local function escapeRich(p40) -- Line: 164
    return p40:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
end;

local function collectTransparencyTargets(p41) -- Line: 173
    -- upvalues: u17 (ref)
    local u42 = {};

    local function consider(u43, u44) -- Line: 176
        -- upvalues: u42 (copy)
        local success, result = pcall(function() -- Line: 177
            -- upvalues: u43 (copy), u44 (copy)
            return u43[u44];
        end);

        if success and typeof(result) == "number" then
            table.insert(u42, {
                inst = u43,
                prop = u44,
                original = result
            });
        end;
    end;

    local function handle(p45) -- Line: 185
        -- upvalues: consider (copy)
        if p45:IsA("GuiObject") then
            consider(p45, "BackgroundTransparency");
        end;

        if p45:IsA("TextLabel") or (p45:IsA("TextButton") or p45:IsA("TextBox")) then
            consider(p45, "TextTransparency");
            consider(p45, "TextStrokeTransparency");
        end;

        if p45:IsA("ImageLabel") or p45:IsA("ImageButton") then
            consider(p45, "ImageTransparency");
        end;

        if p45:IsA("CanvasGroup") then
            consider(p45, "GroupTransparency");
        end;

        if p45:IsA("UIStroke") then
            consider(p45, "Transparency");
        end;
    end;

    handle(p41);

    for _, descendant in p41:GetDescendants() do
        handle(descendant);
    end;

    u17 = u42;
end;

local function setTransparency(p46) -- Line: 213
    -- upvalues: u17 (ref)
    for _, v in u17 do
        local v47;

        if p46 == nil then
            v47 = v.original;
        else
            v47 = p46;
        end;

        v.inst[v.prop] = v47;
    end;
end;

local function animateTransparency(p48) -- Line: 220
    -- upvalues: u17 (ref), TweenService (copy), u7 (copy)
    for _, v in u17 do
        TweenService:Create(v.inst, u7, {
            [v.prop] = not p48 and 1 or v.original
        }):Play();
    end;
end;

local function playSfx(u49) -- Line: 227
    -- upvalues: SfxController (copy)
    pcall(function() -- Line: 228
        -- upvalues: SfxController (ref), u49 (copy)
        SfxController:PlaySFX(u49);
    end);
end;

local function playRevealFlash() -- Line: 238
    -- upvalues: FlashbangVFXController (copy)
    pcall(function() -- Line: 239
        -- upvalues: FlashbangVFXController (ref)
        FlashbangVFXController:Flash(0.5, 0.5);
    end);
end;

local function playRainbow() -- Line: 249
    -- upvalues: SoundService (copy), Players (copy), TweenService (copy), u9 (copy), u10 (copy)
    pcall(function() -- Line: 250
        -- upvalues: SoundService (ref)
        local Rainbow = SoundService.SFX.SellSFX.Rainbow;
        Rainbow.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Rainbow.TimePosition = 0;
        Rainbow.Playing = true;
    end);
    pcall(function() -- Line: 256
        -- upvalues: Players (ref), TweenService (ref), u9 (ref), u10 (ref)
        local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui");

        if PlayerGui then
            PlayerGui = PlayerGui:FindFirstChild("RadialScreenFlash");
        end;

        if PlayerGui then
            PlayerGui = PlayerGui:FindFirstChild("Rainbow");
        end;

        if not (PlayerGui and PlayerGui:IsA("ImageLabel")) then
            return;
        end;

        TweenService:Create(PlayerGui, u9, {
            ImageTransparency = 0
        }):Play();
        task.delay(u9.Time + 1.4, function() -- Line: 264
            -- upvalues: TweenService (ref), PlayerGui (copy), u10 (ref)
            TweenService:Create(PlayerGui, u10, {
                ImageTransparency = 1
            }):Play();
        end);
    end);
end;

local function setShown(p50, p51) -- Line: 271
    -- upvalues: u30 (ref), dbg (copy), u2 (copy), u1 (copy), u13 (ref), TweenService (copy), u7 (copy), u18 (ref), u3 (copy), u19 (ref), animateTransparency (copy), SfxController (copy)
    if p50 == u30 then
        return;
    end;

    u30 = p50;
    local v52;

    if p50 then
        v52 = u2;
    else
        v52 = u1;
    end;

    dbg(p50 and "POPPING DOWN" or "popping up", "->", (tostring(v52)));
    local v53 = u13;

    if v53 then
        if p50 then
            v53.Visible = true;
        end;

        local v54 = {};
        local v55;

        if p50 then
            v55 = u2;
        else
            v55 = u1;
        end;

        v54.Position = v55;
        TweenService:Create(v53, u7, v54):Play();
    end;

    local v56 = u18;

    if v56 then
        local v57 = {};
        local v58;

        if p50 then
            v58 = u3;
        else
            v58 = u19 or v56.Position;
        end;

        v57.Position = v58;
        TweenService:Create(v56, u7, v57):Play();
    end;

    animateTransparency(p50);

    if p50 and p51 then
        dbg("playing Notification SFX");
        local u59 = "Notification";
        pcall(function() -- Line: 228
            -- upvalues: SfxController (ref), u59 (copy)
            SfxController:PlaySFX(u59);
        end);
    end;
end;

local function resetForEvent(p60, p61) -- Line: 310
    -- upvalues: u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref), u13 (ref), u1 (copy), u14 (ref), u5 (copy), u15 (ref), u17 (ref), dbg (copy)
    u20 = p60;
    u21 = {};
    u22 = p61 + 1;
    u23 = false;
    u24 = false;
    u25 = 0;
    u26 = false;
    u27 = 0;
    u28 = false;
    u29 = false;
    u30 = false;
    u31 = "";
    u32 = "";
    local v62 = u13;

    if v62 then
        v62.Position = u1;
    end;

    if u14 then
        u14.ImageColor3 = u5;
    end;

    if u15 then
        u15.Visible = true;
    end;

    for _, v in u17 do
        v.inst[v.prop] = 1;
    end;

    if p60 ~= nil then
        u23 = true;
        u21[60] = true;
    end;

    dbg("reset for event", tostring(p60), "remaining =", p61, "stayDown =", u23, "joinBanner =", u24);
end;

local function enterLivePhase() -- Line: 350
    -- upvalues: u26 (ref), u27 (ref), u23 (ref), dbg (copy), u14 (ref), TweenService (copy), u8 (copy), u6 (copy), u15 (ref), playRainbow (copy), u11 (copy), SfxController (copy)
    if u26 then
        return;
    end;

    u26 = true;
    u27 = os.clock();
    u23 = true;
    dbg("ENTER LIVE PHASE -> reveal: hide QuestionMark, white tween, rainbow FX + SFX");

    if u14 then
        TweenService:Create(u14, u8, {
            ImageColor3 = u6
        }):Play();
    end;

    if u15 then
        u15.Visible = false;
    end;

    playRainbow();

    for _, v in u11 do
        pcall(function() -- Line: 228
            -- upvalues: SfxController (ref), v (copy)
            SfxController:PlaySFX(v);
        end);
    end;
end;

local function typeWord(p63) -- Line: 378
    if p63 == "" or (p63 == "default" or p63 == "drop") then
        return nil;
    end;

    return string.upper(p63);
end;

local function updateText(p64, p65) -- Line: 385
    -- upvalues: u16 (ref), u26 (ref), fmtPopdown (copy), u31 (ref)
    local v66 = u16;

    if not v66 then
        return;
    end;

    local type = p64.type;
    local v67;

    if type == "" or (type == "default" or type == "drop") then
        v67 = nil;
    else
        v67 = string.upper(type);
    end;

    local v68;

    if u26 then
        v68 = string.format("<font color=\"rgb(255,0,0)\">%s</font> %s is out now!", not v67 and "[NEW]" or "[NEW " .. v67 .. "]", (p64.name:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")));
    else
        v68 = (not v67 and "NEW IN: " or "NEW " .. v67 .. " IN: ") .. string.format("<font color=\"rgb(255,0,0)\">%s</font>", fmtPopdown(p65));
    end;

    if v68 ~= u31 then
        u31 = v68;
        v66.Text = v68;
    end;
end;

local function updateImage(p69) -- Line: 411
    -- upvalues: dbg (copy), u32 (ref), u14 (ref)
    local icon = p69.icon;

    if icon and icon ~= "" then
        if icon ~= u32 then
            u32 = icon;

            if u14 then
                u14.Image = icon;
                dbg("ImageVector.Image set ->", icon);
            end;
        end;

        return;
    end;

    dbg("no icon URL on primary (drop has no reveal/silhouette asset id yet)");
end;

local function update() -- Line: 428
    -- upvalues: u13 (ref), ReleaseCountdownController (copy), u33 (ref), dbg (copy), u20 (ref), resetForEvent (copy), setShown (copy), u30 (ref), u23 (ref), u26 (ref), enterLivePhase (copy), u24 (ref), u25 (ref), u4 (copy), u21 (ref), u22 (ref), u28 (ref), FlashbangVFXController (copy), u29 (ref), u27 (ref), updateText (copy), u32 (ref), u14 (ref)
    if not u13 then
        return;
    end;

    local v70 = os.clock();
    local v71 = ReleaseCountdownController:GetPrimary();

    if not v71 then
        if v70 - u33 >= 2 then
            u33 = v70;
            dbg("GetPrimary() = nil (no active release; waiting for server tick / releasetest)");
        end;

        if u20 ~= nil then
            resetForEvent(nil, (1 / 0));
        end;

        setShown(false, false);

        return;
    end;

    if v71.id ~= u20 then
        resetForEvent(v71.id, v71.remaining);
    end;

    local remaining = v71.remaining;

    if v70 - u33 >= 1 then
        u33 = v70;
        dbg(string.format("id=%s state=%s remaining=%ds shown=%s stayDown=%s live=%s", tostring(v71.id), tostring(v71.state), remaining, tostring(u30), tostring(u23), (tostring(u26))));
    end;

    if v71.state == "live" or remaining <= 0 then
        enterLivePhase();
    elseif not u26 then
        if u24 then
            u24 = false;
            u25 = v70 + 10;
            dbg("join banner: active countdown on entry -> temp popdown for", 10, "s");
        end;

        for _, v in u4 do
            if not u21[v] and (v < u22 and remaining <= v) then
                u21[v] = true;
                u25 = v70 + 10;
                dbg("THRESHOLD crossed:", v, "s -> temp popdown for", 10, "s");
            end;
        end;

        if not u21[60] and (u22 > 60 and remaining <= 60) then
            u21[60] = true;
            u23 = true;
            dbg("FINAL THRESHOLD crossed:", 60, "s -> pop down and stay");
        end;

        if not u28 and remaining <= 1 then
            u28 = true;
            dbg("FLASH lead reached (", remaining, "s) -> reveal flash + FOV");
            pcall(function() -- Line: 239
                -- upvalues: FlashbangVFXController (ref)
                FlashbangVFXController:Flash(0.5, 0.5);
            end);
        end;
    end;

    u22 = remaining;
    local v72;

    if u29 then
        v72 = false;
    elseif u26 then
        v72 = v70 - u27 < 30;

        if not v72 then
            u29 = true;
        end;
    else
        v72 = u23 and true or v70 < u25;
    end;

    setShown(v72, not u26);

    if v72 then
        updateText(v71, remaining);
        local icon = v71.icon;

        if not icon or icon == "" then
            dbg("no icon URL on primary (drop has no reveal/silhouette asset id yet)");

            return;
        end;

        if icon ~= u32 then
            u32 = icon;

            if u14 then
                u14.Image = icon;
                dbg("ImageVector.Image set ->", icon);
            end;
        end;
    end;
end;

local function waitForLoadingScreen() -- Line: 538
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v73 = os.clock() + 120;

    while LocalPlayer:GetAttribute("LoadingScreenDone") ~= true and os.clock() < v73 do
        task.wait(0.1);
    end;
end;

local function setup() -- Line: 546
    -- upvalues: dbg (copy), Players (copy), u13 (ref), u14 (ref), u16 (ref), u18 (ref), u19 (ref), u15 (ref), collectTransparencyTargets (copy), resetForEvent (copy), u17 (ref), waitForLoadingScreen (copy), RunService (copy), update (copy)
    dbg("setup: waiting for PlayerGui.DripUpdateNotification");
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local Popdown_Frame = PlayerGui:WaitForChild("DripUpdateNotification"):WaitForChild("Popdown_Frame");
    local Content = Popdown_Frame:WaitForChild("Frame"):WaitForChild("Content");
    u13 = Popdown_Frame;
    u14 = Content:WaitForChild("ImageVector");
    u16 = Content:WaitForChild("TextLabel");
    local TopNotification = PlayerGui:WaitForChild("TopNotification", 10);

    if TopNotification then
        TopNotification = TopNotification:FindFirstChild("Frame");
    end;

    if TopNotification and TopNotification:IsA("Frame") then
        u18 = TopNotification;
        u19 = TopNotification.Position;
    end;

    local QuestionMark = u14:FindFirstChild("QuestionMark");

    if QuestionMark and QuestionMark:IsA("GuiObject") then
        u15 = QuestionMark;
    end;

    u16.RichText = true;
    collectTransparencyTargets(Popdown_Frame);
    resetForEvent(nil, (1 / 0));
    dbg("setup complete:", #u17, "transparency targets captured; waiting for loading screen");
    waitForLoadingScreen();
    dbg("loading screen done; release reveal loop starting");
    RunService.RenderStepped:Connect(update);
end;

function v12.Init(p74) -- Line: 592
end;

function v12.Start(p75) -- Line: 594
    -- upvalues: setup (copy)
    task.spawn(setup);
end;

return v12;