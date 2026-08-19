-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Lighting = game:GetService("Lighting");
local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local TeleportService = game:GetService("TeleportService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

local function teleportArrivalSource() -- Line: 20
    -- upvalues: TeleportService (copy)
    local success, result = pcall(function() -- Line: 21
        -- upvalues: TeleportService (ref)
        return TeleportService:GetLocalPlayerTeleportData();
    end);

    if success and type(result) == "table" then
        local Source = result.Source;

        if type(Source) == "string" then
            return Source;
        end;
    end;

    return nil;
end;

local success, result = pcall(function() -- Line: 21
    -- upvalues: TeleportService (copy)
    return TeleportService:GetLocalPlayerTeleportData();
end);
local v1;

if success and type(result) == "table" then
    v1 = result.Source;

    if type(v1) ~= "string" then
        v1 = nil;
    end;
else
    v1 = nil;
end;

local u2 = v1 == "PetHunt";
local u3 = u2 or (v1 == "WorldTravel" or v1 == "FollowLink");
local u4;

if u2 then
    u4 = not RunService:IsStudio();
else
    u4 = u2;
end;

local function travelDestination() -- Line: 65
    -- upvalues: LocalPlayer (copy)
    local v5 = LocalPlayer:GetAttribute("WorldTravelDestination");

    if type(v5) == "string" and v5 ~= "" then
        return v5;
    end;

    return nil;
end;

local u6 = {
    "Your garden literally grows while you are <b>offline</b>!",
    "The <i>best</i> seeds have a <i>small</i> chance of restocking!",
    "<font color=\"#FFFF00\">Private Servers</font> are free for everyone!",
    "Playing with friends makes the game even more fun!",
    "<font color=\"#FFFF00\">Gold</font> mutations are worth <b>15x</b> more!",
    "There is a small chance for <font color=\"#FF0000\">r</font><font color=\"#FF7F00\">a</font><font color=\"#FFFF00\">i</font><font color=\"#00FF00\">n</font><font color=\"#0000FF\">b</font><font color=\"#4B0082\">o</font><font color=\"#8B00FF\">w</font> mutations worth <b>40x</b> more!",
    "<b>Bigger</b> fruits sell for <b>more</b> money!",
    "Watering cans make plants grow faster, and maybe make seed packs luckier!",
    "Sprinklers <i>passively</i> water nearby plants for you!",
    "You can <b>steal</b> ripe fruits from other players\' gardens!",
    "Watch out for <font color=\"#FF4444\">gnomes</font> and <font color=\"#FF4444\">traps</font> when stealing!",
    "Some plants give <b>multiple harvests</b> per growth cycle!",
    "Mushrooms grant temporary buffs like <b>speed</b> and <b>invisibility</b>!",
    "You can <b>gift</b> harvested fruits to your friends!",
    "Send your favorite content creators gifts through the mail!",
    "Expand your garden up to <b>5 times</b> for maximum growing space!",
    "Fruits need to be ripe for maximum <b>value</b>!",
    "Visit other players\' gardens to see what they are growing!",
    "There is a very small, and we mean <i>small</i> chance a fruit can grow <b>x100000</b> as big",
    "The rarest seeds cost <i>millions</i> but yield legendary harvests!"
};
local u7 = {
    TextLabel = "TextTransparency",
    ImageLabel = "ImageTransparency",
    UIStroke = "Transparency"
};
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = {};
local u12 = {};
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = false;
local u17 = nil;
local u18 = false;
local u19 = nil;
local u20 = false;
local u21 = nil;
local u22 = false;
local u23 = {};
local u24 = nil;
local u25 = false;
local u26 = 0;
local u27 = 0;
local u28 = 0;

local function shuffleClone(p29) -- Line: 131
    local v30 = table.clone(p29);

    for i = #v30, 2, -1 do
        local v31 = math.random(1, i);
        local v32 = v30[i];
        v30[i] = v30[v31];
        v30[v31] = v32;
    end;

    return v30;
end;

local function fadeUpdateText(u33, u34, u35) -- Line: 140
    -- upvalues: TweenService (copy), u22 (ref)
    task.spawn(function() -- Line: 141
        -- upvalues: u35 (copy), TweenService (ref), u33 (copy), u22 (ref), u34 (copy)
        local v36 = TweenInfo.new(u35 / 2, Enum.EasingStyle.Linear);
        local v37 = TweenService:Create(u33, v36, {
            TextTransparency = 1
        });
        v37:Play();
        v37.Completed:Wait();

        if not u22 then
            u33.Text = u34;
            TweenService:Create(u33, v36, {
                TextTransparency = 0
            }):Play();
        end;
    end);
end;

local function popRandomTip() -- Line: 154
    -- upvalues: u23 (ref), shuffleClone (copy), u6 (copy)
    if #u23 == 0 then
        u23 = shuffleClone(u6);
    end;

    return table.remove(u23, #u23);
end;

local function isMobile() -- Line: 161
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
end;

local function collectPreloadAssets() -- Line: 165
    -- upvalues: PlayerGui (copy), ReplicatedStorage (copy)
    local v38 = {};

    for _, child in pairs(PlayerGui:GetChildren()) do
        if child:IsA("ScreenGui") then
            for _, descendant in pairs(child:GetDescendants()) do
                if (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) and (descendant.Image and descendant.Image ~= "") then
                    table.insert(v38, descendant);
                end;
            end;
        end;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        for _, descendant in pairs(Assets:GetDescendants()) do
            if descendant:IsA("ImageLabel") or (descendant:IsA("ImageButton") or (descendant:IsA("Decal") or descendant:IsA("Texture"))) then
                table.insert(v38, descendant);
            elseif descendant:IsA("MeshPart") or descendant:IsA("Sound") then
                table.insert(v38, descendant);
            end;
        end;
    end;

    local SharedModules = ReplicatedStorage:FindFirstChild("SharedModules");

    if SharedModules then
        local v39 = { "GearImages", "PropImages" };
        local SeedData = SharedModules:FindFirstChild("SeedData");

        if SeedData then
            for _, v in pairs({ "SeedImages", "FruitImages", "PlantImages" }) do
                local v40 = SeedData:FindFirstChild(v);

                if v40 then
                    table.insert(v39, v40);
                end;
            end;
        end;

        for _, v in pairs(v39) do
            if typeof(v) == "string" then
                local v = SharedModules:FindFirstChild(v);
            end;

            if v then
                for _, child in pairs(v:GetChildren()) do
                    if child:IsA("StringValue") and child.Value ~= "" then
                        table.insert(v38, child.Value);
                    end;
                end;
            end;
        end;
    end;

    return v38;
end;

local function preloadAssetsAsync() -- Line: 220
    -- upvalues: collectPreloadAssets (copy), u27 (ref), u25 (ref), u26 (ref), ContentProvider (copy), u28 (ref)
    local v41 = collectPreloadAssets();
    u27 = #v41;

    if u27 == 0 then
        u25 = true;
        u26 = 1;

        return;
    end;

    ContentProvider:PreloadAsync(v41, function(p42, p43) -- Line: 230
        -- upvalues: u28 (ref), u26 (ref), u27 (ref)
        u28 = u28 + 1;
        u26 = math.clamp(u28 / u27, 0, 1);
    end);
    u28 = u27;
    u26 = 1;
    u25 = true;
end;

local function hideOtherGui(u44) -- Line: 240
    -- upvalues: u11 (ref), u12 (copy)
    if u44.Enabled then
        u11[u44] = u44.Enabled;
        u44.Enabled = false;
    end;

    u12[u44] = u44:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 245
        -- upvalues: u44 (copy), u11 (ref)
        if u44.Enabled then
            u11[u44] = u44.Enabled;
            u44.Enabled = false;
        end;
    end);
end;

local function hideGuis() -- Line: 253
    -- upvalues: u11 (ref), u13 (ref), PlayerGui (copy), u8 (ref), u12 (copy)
    u11 = {};
    u13 = PlayerGui.ChildAdded:Connect(function(u45) -- Line: 255
        -- upvalues: u8 (ref), u11 (ref), u12 (ref)
        if u45:IsA("ScreenGui") and u45 ~= u8 then
            if u45.Enabled then
                u11[u45] = u45.Enabled;
                u45.Enabled = false;
            end;

            u12[u45] = u45:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 245
                -- upvalues: u45 (copy), u11 (ref)
                if u45.Enabled then
                    u11[u45] = u45.Enabled;
                    u45.Enabled = false;
                end;
            end);
        end;
    end);

    for _, child in pairs(PlayerGui:GetChildren()) do
        if child:IsA("ScreenGui") and child ~= u8 then
            if child.Enabled then
                u11[child] = child.Enabled;
                child.Enabled = false;
            end;

            u12[child] = child:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 245
                -- upvalues: child (copy), u11 (ref)
                if child.Enabled then
                    u11[child] = child.Enabled;
                    child.Enabled = false;
                end;
            end);
        end;
    end;
end;

local function showGuis() -- Line: 267
    -- upvalues: u12 (copy), u13 (ref), u11 (ref)
    for _, v in pairs(u12) do
        v:Disconnect();
    end;

    table.clear(u12);

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    for i, v in pairs(u11) do
        i.Enabled = v;
    end;

    table.clear(u11);
end;

local function getPlayerPlot() -- Line: 282
    -- upvalues: LocalPlayer (copy)
    local v46 = LocalPlayer:GetAttribute("PlotId");

    if not v46 then
        return nil;
    end;

    local Gardens = workspace:FindFirstChild("Gardens");

    if Gardens then
        return Gardens:FindFirstChild("Plot" .. v46);
    end;

    return nil;
end;

local function setCam() -- Line: 290
    -- upvalues: u19 (ref), LocalPlayer (copy), u20 (ref)
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    workspace.CurrentCamera.FieldOfView = 45;

    if not u19 then
        local v47 = LocalPlayer:GetAttribute("PlotId");
        local v48;

        if v47 then
            local Gardens = workspace:FindFirstChild("Gardens");

            if Gardens then
                v48 = Gardens:FindFirstChild("Plot" .. v47);
            else
                v48 = nil;
            end;
        else
            v48 = nil;
        end;

        if v48 then
            local LoadingScreenCam = v48:FindFirstChild("LoadingScreenCam");

            if LoadingScreenCam and LoadingScreenCam:IsA("BasePart") then
                u19 = LoadingScreenCam;
            end;
        end;
    end;

    if not u19 then
        if not u20 then
            workspace.CurrentCamera.CFrame = CFrame.new(239.094, 156.83, -134.733) * CFrame.fromOrientation(-0.2794097599517722, -1.8222633654222395, 0);
        end;

        return;
    end;

    u20 = true;
    workspace.CurrentCamera.CFrame = u19.CFrame;
end;

local function startTransparentBGfx() -- Line: 318
    -- upvalues: u16 (ref), ReplicatedStorage (copy), u15 (ref), u14 (ref), Lighting (copy), u18 (ref), setCam (copy), RunService (copy)
    game.Lighting:WaitForChild("DepthOfField").Enabled = false;
    u16 = true;
    task.spawn(function() -- Line: 327
        -- upvalues: ReplicatedStorage (ref), u15 (ref), u16 (ref), u14 (ref), Lighting (ref)
        local Blur = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("Blur"));
        u15 = Blur;

        if not u16 then
            return;
        end;

        Blur.SetBlur(20);
        u14 = Lighting:FindFirstChild("Blur");
    end);
    u18 = true;
    task.spawn(function() -- Line: 341
        -- upvalues: u18 (ref), setCam (ref), RunService (ref)
        while u18 do
            setCam();
            RunService.RenderStepped:Wait();
        end;
    end);
end;

local function endTransparentBGfx(p49) -- Line: 349
    -- upvalues: u16 (ref), u15 (ref), u14 (ref), u18 (ref), u17 (ref)
    if p49 then
        workspace.CurrentCamera.FieldOfView = 70;
    else
        workspace.CurrentCamera.FieldOfView = 45;
        task.spawn(function() -- Line: 355
            local v50 = os.clock();

            while os.clock() - v50 < 3 do
                local v51 = (os.clock() - v50) / 3;
                local v52 = math.clamp(v51, 0, 1);
                workspace.CurrentCamera.FieldOfView = v52 * 25 + 45;
                task.wait();
            end;

            workspace.CurrentCamera.FieldOfView = 70;
        end);
    end;

    u16 = false;

    if u15 and u14 then
        u15.SetBlur(0, p49 and 0 or 1);
    end;

    u14 = nil;

    if game.Lighting:FindFirstChild("DepthOfField") then
        game.Lighting.DepthOfField.Enabled = true;
    end;

    u18 = false;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom;
end;

local function revealLogo() -- Line: 390
    -- upvalues: u10 (ref), TweenService (copy)
    local LogoImg = u10:FindFirstChild("LogoImg");

    if not LogoImg then
        return;
    end;

    TweenService:Create(LogoImg, TweenInfo.new(1, Enum.EasingStyle.Linear), {
        ImageTransparency = 0
    }):Play();
    task.wait(1);
end;

local function startRotateTween() -- Line: 400
    -- upvalues: u10 (ref), u24 (ref), TweenService (copy)
    local LogoImg = u10:FindFirstChild("LogoImg");

    if LogoImg then
        u24 = TweenService:Create(LogoImg, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, (1 / 0), true), {
            Rotation = 5
        });
        u24:Play();
    end;
end;

local function stopRotateTween() -- Line: 409
    -- upvalues: u24 (ref)
    if u24 then
        u24:Pause();
        u24 = nil;
    end;
end;

local function updateTip(p53) -- Line: 416
    -- upvalues: u10 (ref), u23 (ref), shuffleClone (copy), u6 (copy), TweenService (copy), u22 (ref)
    local TipLabel = u10:FindFirstChild("TipLabel");

    if not TipLabel then
        return;
    end;

    if #u23 == 0 then
        u23 = shuffleClone(u6);
    end;

    local u54 = "[" .. table.remove(u23, #u23) .. "]";

    if not p53 then
        TipLabel.Text = u54;

        return;
    end;

    local u55 = 0.6;
    task.spawn(function() -- Line: 141
        -- upvalues: u55 (copy), TweenService (ref), TipLabel (copy), u22 (ref), u54 (copy)
        local v56 = TweenInfo.new(u55 / 2, Enum.EasingStyle.Linear);
        local v57 = TweenService:Create(TipLabel, v56, {
            TextTransparency = 1
        });
        v57:Play();
        v57.Completed:Wait();

        if not u22 then
            TipLabel.Text = u54;
            TweenService:Create(TipLabel, v56, {
                TextTransparency = 0
            }):Play();
        end;
    end);
end;

local function startTipCycle() -- Line: 428
    -- upvalues: u23 (ref), shuffleClone (copy), u6 (copy), u10 (ref), u21 (ref), TweenService (copy), u22 (ref)
    u23 = shuffleClone(u6);
    local TipLabel = u10:FindFirstChild("TipLabel");

    if TipLabel then
        if #u23 == 0 then
            u23 = shuffleClone(u6);
        end;

        TipLabel.Text = "[" .. table.remove(u23, #u23) .. "]";
    end;

    u21 = task.spawn(function() -- Line: 432
        -- upvalues: u10 (ref), u23 (ref), shuffleClone (ref), u6 (ref), TweenService (ref), u22 (ref)
        while true do
            local u58;

            repeat
                task.wait(7);
                u58 = u10:FindFirstChild("TipLabel");
            until u58;

            if #u23 == 0 then
                u23 = shuffleClone(u6);
            end;

            local u59 = "[" .. table.remove(u23, #u23) .. "]";
            local u60 = 0.6;
            task.spawn(function() -- Line: 141
                -- upvalues: u60 (copy), TweenService (ref), u58 (copy), u22 (ref), u59 (copy)
                local v61 = TweenInfo.new(u60 / 2, Enum.EasingStyle.Linear);
                local v62 = TweenService:Create(u58, v61, {
                    TextTransparency = 1
                });
                v62:Play();
                v62.Completed:Wait();

                if not u22 then
                    u58.Text = u59;
                    TweenService:Create(u58, v61, {
                        TextTransparency = 0
                    }):Play();
                end;
            end);
        end;
    end);
end;

local function endTipCycle() -- Line: 440
    -- upvalues: u22 (ref), u21 (ref)
    u22 = true;

    if u21 then
        task.cancel(u21);
        u21 = nil;
    end;
end;

local function changeAllTransparency(p63, p64) -- Line: 448
    -- upvalues: u10 (ref), u7 (copy), TweenService (copy)
    local v65 = TweenInfo.new(p64, Enum.EasingStyle.Linear);

    for _, descendant in pairs(u10:GetDescendants()) do
        if not descendant:HasTag("Skip") then
            local v66 = u7[descendant.ClassName];

            if v66 then
                TweenService:Create(descendant, v65, {
                    [v66] = p63
                }):Play();
            end;
        end;
    end;
end;

local function hideFrame() -- Line: 462
    -- upvalues: changeAllTransparency (copy), TweenService (copy), u9 (ref)
    changeAllTransparency(1, 1);
    local v67 = TweenService:Create(u9, TweenInfo.new(1, Enum.EasingStyle.Linear), {
        BackgroundTransparency = 1
    });
    v67:Play();
    v67.Completed:Wait();
end;

local function showTravelCaption(p68, p69) -- Line: 482
    if not p68 then
        return;
    end;

    p68.Text = `Transferring you to {p69}...`;
    p68.TextTransparency = 0;
end;

local function waitOutWorldTravel() -- Line: 494
    -- upvalues: LocalPlayer (copy), u10 (ref)
    local v70 = LocalPlayer:GetAttribute("WorldTravelDestination");

    if type(v70) ~= "string" or v70 == "" then
        v70 = nil;
    end;

    if not v70 then
        return;
    end;

    local v71;

    if u10 then
        v71 = u10:FindFirstChild("CounterTxt");
    else
        v71 = nil;
    end;

    if not (v71 and v71:IsA("TextLabel")) then
        v71 = nil;
    end;

    while true do
        local v72 = LocalPlayer:GetAttribute("WorldTravelDestination");

        if type(v72) ~= "string" or v72 == "" then
            v72 = nil;
        end;

        if not v72 then
            return;
        end;

        if v71 then
            v71.Text = `Transferring you to {v72}...`;
            v71.TextTransparency = 0;
        end;

        task.wait();
    end;
end;

local function getLoadingProgress() -- Line: 515
    -- upvalues: CollectionService (copy), LocalPlayer (copy), u25 (ref), u28 (ref), u27 (ref), u26 (ref)
    if not CollectionService:HasTag(LocalPlayer, "PersistentLoaded") then
        return 0, "Loading player data...";
    end;

    if not game:IsLoaded() then
        return 0.05, "Loading game...";
    end;

    if not u25 then
        local v73 = math.min(u28, u27);

        return u26 * 0.2 + 0.05, "Preloading assets... (" .. v73 .. "/" .. u27 .. ")";
    end;

    if not CollectionService:HasTag(LocalPlayer, "ControllersStarted") then
        return 0.25, "Initializing controllers...";
    end;

    if not CollectionService:HasTag(LocalPlayer, "DataLoaded") then
        return 0.35, "Loading player save...";
    end;

    local v74 = LocalPlayer:GetAttribute("GardenLoadingTotal");
    local v75 = LocalPlayer:GetAttribute("GardenLoadingProgress");

    if v74 and v74 > 0 then
        return math.clamp((v75 or 0) / v74, 0, 1) * 0.55 + 0.45, "Spawning garden... (" .. (v75 or 0) .. "/" .. v74 .. ")";
    end;

    return 1, "Ready!";
end;

local u76 = nil;
local BindableEvent = Instance.new("BindableEvent");
local u77 = 0;
local u78 = false;
local u79 = { "Polishing fruits...", "Watering gardens...", "Waking up gnomes...", "Planting seeds...", "Counting leaves..." };

local function startCounter() -- Line: 561
    -- upvalues: u10 (ref), TweenService (copy), preloadAssetsAsync (copy), u76 (ref), getLoadingProgress (copy), u77 (ref), u2 (copy), u78 (ref), u79 (copy), LocalPlayer (copy), BindableEvent (copy)
    local CounterTxt = u10:FindFirstChild("CounterTxt");
    local ProgressBar = u10:FindFirstChild("ProgressBar");

    if CounterTxt then
        TweenService:Create(CounterTxt, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
            TextTransparency = 0
        }):Play();
    end;

    task.spawn(preloadAssetsAsync);
    u76 = task.spawn(function() -- Line: 571
        -- upvalues: getLoadingProgress (ref), u77 (ref), u2 (ref), u78 (ref), u79 (ref), LocalPlayer (ref), CounterTxt (copy), ProgressBar (copy), BindableEvent (ref)
        local v80 = nil;
        local v81 = "Loading...";
        local v82 = 0;
        local v83 = 0;
        local v84 = 1;

        while true do
            local v85, v86 = getLoadingProgress();
            local v87 = os.clock() - u77;

            if u2 and v86 ~= v80 then
                warn((`[LoadingScreen][PetHunt] phase="{v86}" target={math.floor(v85 * 100)}%`));
                v80 = v86;
            end;

            if v85 >= 1 and not u78 then
                u78 = true;
            end;

            if u78 and v87 < 5 then
                local v88 = math.clamp(v87 / 5, 0, 0.95);
                local v89 = math.max(v88, v82);
                v85 = math.min(v85, v89);

                if v83 == 0 or v87 - v83 >= 3 then
                    v86 = u79[v84];
                    v84 = v84 % #u79 + 1;
                    v83 = v87;
                else
                    v86 = u79[(v84 - 2) % #u79 + 1];
                end;
            end;

            local v90 = v82 + math.clamp((v85 - v82) * 0.06, 0.001, 0.015);
            v82 = math.min(v90, v85, 1);

            if v85 - 0.01 > v82 then
                v86 = v81;
            end;

            local v91 = LocalPlayer:GetAttribute("WorldTravelDestination");

            if type(v91) ~= "string" or v91 == "" then
                v91 = nil;
            end;

            if CounterTxt then
                game.TweenService:Create(ProgressBar.Bar, TweenInfo.new(0.05), {
                    Size = UDim2.new(v82, 0, 1, 0)
                }):Play();

                if v91 then
                    local v92 = CounterTxt;

                    if v92 then
                        v92.Text = `Transferring you to {v91}...`;
                        v92.TextTransparency = 0;
                    end;
                else
                    CounterTxt.Text = v86 .. " " .. math.floor(v82 * 100) .. "%";
                end;
            end;

            if v91 then
                task.wait(0.05);
                v81 = v86;
            else
                if u78 and (v87 >= 5 and v82 >= 0.95) then
                    if CounterTxt then
                        CounterTxt.Text = "Ready! 100%";
                    end;

                    game.TweenService:Create(ProgressBar.Bar, TweenInfo.new(0.05), {
                        Size = UDim2.new(1, 0, 1, 0)
                    }):Play();
                    BindableEvent:Fire();

                    return;
                end;

                task.wait(0.05);
                v81 = v86;
            end;
        end;
    end);
end;

local function endCounter() -- Line: 656
    -- upvalues: u76 (ref)
    if u76 then
        task.cancel(u76);
        u76 = nil;
    end;
end;

(function() -- Line: 663, Name: startLoading
    -- upvalues: u8 (ref), LocalPlayer (copy), u9 (ref), u10 (ref), ProximityPromptService (copy), startTransparentBGfx (copy), hideGuis (copy), u77 (ref), startRotateTween (copy), u23 (ref), shuffleClone (copy), u6 (copy), u21 (ref), TweenService (copy), u22 (ref), startCounter (copy), UserInputService (copy), u18 (ref), u76 (ref), u24 (ref), u16 (ref), u15 (ref), u14 (ref), u17 (ref), showGuis (copy), u2 (copy), u4 (copy), RunService (copy), u3 (copy), BindableEvent (copy), u78 (ref), u20 (ref), waitOutWorldTravel (copy), hideFrame (copy), endTransparentBGfx (copy)
    local u93 = game.ReplicatedFirst.LoadingScreenMenu:Clone();
    u93.Parent = workspace;
    u8 = u93:WaitForChild("LoadingGui", 15);
    local u94 = true;
    task.spawn(function() -- Line: 671
        -- upvalues: u94 (ref), u8 (ref), u93 (copy)
        while u94 do
            game:GetService("RunService").RenderStepped:Wait();
            local v95 = math.rad(workspace.CurrentCamera.FieldOfView / 2);
            local v96 = math.tan(v95) * 32;
            local v97 = v96 * (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y);
            u8.CanvasSize = workspace.CurrentCamera.ViewportSize;
            u93.Size = Vector3.new(v97, v96, 0.1);
            u93.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -16);
        end;
    end);

    if not u8 then
        LocalPlayer:SetAttribute("LoadingScreenDone", true);

        return;
    end;

    u9 = u8:FindFirstChild("Variant1Frame");

    if not u9 then
        u8.Enabled = false;
        LocalPlayer:SetAttribute("LoadingScreenDone", true);

        return;
    end;

    u10 = u9:FindFirstChild("InnerFrame");

    if not u10 then
        u8.Enabled = false;
        LocalPlayer:SetAttribute("LoadingScreenDone", true);

        return;
    end;

    LocalPlayer:SetAttribute("LoadingScreenActive", true);
    LocalPlayer:SetAttribute("LoadingScreenCovering", true);
    ProximityPromptService.Enabled = false;
    local u98 = false;

    local function anchorCharacter(p99) -- Line: 714
        -- upvalues: u98 (ref)
        if u98 then
            return;
        end;

        local v100 = p99:FindFirstChild("HumanoidRootPart") or p99:WaitForChild("HumanoidRootPart", 10);

        if u98 then
            return;
        end;

        if v100 and v100:IsA("BasePart") then
            v100.Anchored = true;
        end;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character then
        task.spawn(anchorCharacter, Character);
    end;

    local u101 = LocalPlayer.CharacterAdded:Connect(anchorCharacter);
    startTransparentBGfx();
    hideGuis();
    u8.Enabled = true;
    u9.Visible = true;
    u77 = os.clock();
    startRotateTween();
    u23 = shuffleClone(u6);
    local TipLabel = u10:FindFirstChild("TipLabel");

    if TipLabel then
        if #u23 == 0 then
            u23 = shuffleClone(u6);
        end;

        TipLabel.Text = "[" .. table.remove(u23, #u23) .. "]";
    end;

    u21 = task.spawn(function() -- Line: 432
        -- upvalues: u10 (ref), u23 (ref), shuffleClone (ref), u6 (ref), TweenService (ref), u22 (ref)
        while true do
            local u102;

            repeat
                task.wait(7);
                u102 = u10:FindFirstChild("TipLabel");
            until u102;

            if #u23 == 0 then
                u23 = shuffleClone(u6);
            end;

            local u103 = "[" .. table.remove(u23, #u23) .. "]";
            local u104 = 0.6;
            task.spawn(function() -- Line: 141
                -- upvalues: u104 (copy), TweenService (ref), u102 (copy), u22 (ref), u103 (copy)
                local v105 = TweenInfo.new(u104 / 2, Enum.EasingStyle.Linear);
                local v106 = TweenService:Create(u102, v105, {
                    TextTransparency = 1
                });
                v106:Play();
                v106.Completed:Wait();

                if not u22 then
                    u102.Text = u103;
                    TweenService:Create(u102, v105, {
                        TextTransparency = 0
                    }):Play();
                end;
            end);
        end;
    end);
    startCounter();
    local u107 = false;
    local u108 = false;
    local u109 = false;
    local SkipTxt = u10:FindFirstChild("SkipTxt");
    local u110 = UserInputService.InputBegan:Connect(function() -- Line: 749
        -- upvalues: u109 (ref), u107 (ref)
        if u109 then
            u107 = true;
        end;
    end);

    local function fastTeardown() -- Line: 757
        -- upvalues: LocalPlayer (ref), u94 (ref), u18 (ref), u76 (ref), u22 (ref), u21 (ref), u24 (ref), u110 (copy), u16 (ref), u15 (ref), u14 (ref), u17 (ref), showGuis (ref), u98 (ref), u101 (ref), u2 (ref), ProximityPromptService (ref), u8 (ref), u93 (copy)
        LocalPlayer:SetAttribute("LoadingScreenCovering", false);
        u94 = false;
        u18 = false;

        if u76 then
            task.cancel(u76);
            u76 = nil;
        end;

        u22 = true;

        if u21 then
            task.cancel(u21);
            u21 = nil;
        end;

        if u24 then
            u24:Pause();
            u24 = nil;
        end;

        u110:Disconnect();
        workspace.CurrentCamera.FieldOfView = 70;
        u16 = false;

        if u15 and u14 then
            u15.SetBlur(0, 0);
        end;

        u14 = nil;

        if game.Lighting:FindFirstChild("DepthOfField") then
            game.Lighting.DepthOfField.Enabled = true;
        end;

        u18 = false;

        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom;
        showGuis();
        LocalPlayer:SetAttribute("LoadingScreenActive", false);
        u98 = true;

        if u101 then
            u101:Disconnect();
            u101 = nil;
        end;

        local Character2 = LocalPlayer.Character;
        local v111;

        if Character2 then
            v111 = Character2:FindFirstChild("HumanoidRootPart");
        else
            v111 = Character2;
        end;

        if v111 and v111:IsA("BasePart") then
            if not u2 then
                local v112 = LocalPlayer:GetAttribute("PlotId");
                local v113;

                if v112 then
                    local Gardens = workspace:FindFirstChild("Gardens");

                    if Gardens then
                        v113 = Gardens:FindFirstChild("Plot" .. v112);
                    else
                        v113 = nil;
                    end;
                else
                    v113 = nil;
                end;

                if v113 then
                    v113 = v113:FindFirstChild("SpawnPoint");
                end;

                if v113 then
                    Character2:PivotTo(v113.CFrame);
                end;
            end;

            v111.Anchored = false;
        end;

        ProximityPromptService.Enabled = true;
        u8.Enabled = false;
        u93:Destroy();
        LocalPlayer:SetAttribute("LoadingScreenDone", true);
    end;

    if u4 then
        local v114 = os.clock();

        while workspace:GetAttribute("PetHuntReleased") ~= true and os.clock() - v114 < 90 do
            task.wait();
        end;

        fastTeardown();

        return;
    end;

    if RunService:IsStudio() or u3 then
        task.spawn(function() -- Line: 816
            -- upvalues: u107 (ref), u109 (ref)
            while not u107 do
                if u109 then
                    u107 = true;

                    return;
                end;

                task.wait();
            end;
        end);
    end;

    BindableEvent.Event:Connect(function() -- Line: 827
        -- upvalues: u108 (ref), u10 (ref), TweenService (ref), u22 (ref), SkipTxt (copy)
        u108 = true;
        local CounterTxt = u10:FindFirstChild("CounterTxt");

        if CounterTxt then
            local u115 = 0.6;
            local u116 = "Fully Loaded!";
            task.spawn(function() -- Line: 141
                -- upvalues: u115 (copy), TweenService (ref), CounterTxt (copy), u22 (ref), u116 (copy)
                local v117 = TweenInfo.new(u115 / 2, Enum.EasingStyle.Linear);
                local v118 = TweenService:Create(CounterTxt, v117, {
                    TextTransparency = 1
                });
                v118:Play();
                v118.Completed:Wait();

                if not u22 then
                    CounterTxt.Text = u116;
                    TweenService:Create(CounterTxt, v117, {
                        TextTransparency = 0
                    }):Play();
                end;
            end);
        end;

        if SkipTxt then
            local u119 = SkipTxt;
            local u120 = 0.6;
            local u121 = "";
            task.spawn(function() -- Line: 141
                -- upvalues: u120 (copy), TweenService (ref), u119 (copy), u22 (ref), u121 (copy)
                local v122 = TweenInfo.new(u120 / 2, Enum.EasingStyle.Linear);
                local v123 = TweenService:Create(u119, v122, {
                    TextTransparency = 1
                });
                v123:Play();
                v123.Completed:Wait();

                if not u22 then
                    u119.Text = u121;
                    TweenService:Create(u119, v122, {
                        TextTransparency = 0
                    }):Play();
                end;
            end);
        end;
    end);

    local function elapsedTime() -- Line: 838
        -- upvalues: u77 (ref)
        return os.clock() - u77;
    end;

    while not u108 do
        local v124 = LocalPlayer:GetAttribute("WorldTravelDestination");

        if type(v124) ~= "string" or v124 == "" then
            v124 = nil;
        end;

        if v124 then
            if u109 then
                u109 = false;

                if SkipTxt then
                    local u125 = 0.6;
                    local u126 = "";
                    task.spawn(function() -- Line: 141
                        -- upvalues: u125 (copy), TweenService (ref), SkipTxt (copy), u22 (ref), u126 (copy)
                        local v127 = TweenInfo.new(u125 / 2, Enum.EasingStyle.Linear);
                        local v128 = TweenService:Create(SkipTxt, v127, {
                            TextTransparency = 1
                        });
                        v128:Play();
                        v128.Completed:Wait();

                        if not u22 then
                            SkipTxt.Text = u126;
                            TweenService:Create(SkipTxt, v127, {
                                TextTransparency = 0
                            }):Play();
                        end;
                    end);
                end;
            end;

            task.wait();
        else
            if not u109 and (u78 and (u20 or u2)) and os.clock() - u77 >= 0 then
                u109 = true;

                if SkipTxt then
                    local u129 = 0.6;
                    local u130 = "Click to skip!";
                    task.spawn(function() -- Line: 141
                        -- upvalues: u129 (copy), TweenService (ref), SkipTxt (copy), u22 (ref), u130 (copy)
                        local v131 = TweenInfo.new(u129 / 2, Enum.EasingStyle.Linear);
                        local v132 = TweenService:Create(SkipTxt, v131, {
                            TextTransparency = 1
                        });
                        v132:Play();
                        v132.Completed:Wait();

                        if not u22 then
                            SkipTxt.Text = u130;
                            TweenService:Create(SkipTxt, v131, {
                                TextTransparency = 0
                            }):Play();
                        end;
                    end);
                end;
            end;

            if u107 then
                break;
            end;

            task.wait();
        end;
    end;

    pcall(function() -- Line: 874
        game.SoundService.SFX.Click:Play();
    end);

    if u108 then
        local u133 = "<font color=\'#FFFF00\'>[" .. (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "Tap anywhere to play!" or "Press any key to play!") .. "]</font>";
        local PressAnyTxt = u10:FindFirstChild("PressAnyTxt");

        if PressAnyTxt then
            local u134 = 0.6;
            task.spawn(function() -- Line: 141
                -- upvalues: u134 (copy), TweenService (ref), PressAnyTxt (copy), u22 (ref), u133 (copy)
                local v135 = TweenInfo.new(u134 / 2, Enum.EasingStyle.Linear);
                local v136 = TweenService:Create(PressAnyTxt, v135, {
                    TextTransparency = 1
                });
                v136:Play();
                v136.Completed:Wait();

                if not u22 then
                    PressAnyTxt.Text = u133;
                    TweenService:Create(PressAnyTxt, v135, {
                        TextTransparency = 0
                    }):Play();
                end;
            end);
        end;

        u109 = true;

        while not u107 do
            task.wait();
        end;
    end;

    waitOutWorldTravel();

    if RunService:IsStudio() or u3 then
        fastTeardown();

        return;
    end;

    LocalPlayer:SetAttribute("LoadingScreenCovering", false);
    u94 = false;
    u18 = false;
    local u137 = false;
    task.spawn(function() -- Line: 919
        -- upvalues: u16 (ref), u14 (ref), u15 (ref), LocalPlayer (ref), u137 (ref)
        local v138 = 0;
        local CFrame2 = workspace.CurrentCamera.CFrame;
        local v139 = CFrame2 * CFrame.new(0, -5, -35);
        local v140 = false;
        u16 = false;
        u14 = nil;

        if u15 then
            u15.SetBlur(0, 1.8);
        end;

        while v138 < 2.2 do
            v138 = v138 + game:GetService("RunService").Heartbeat:Wait();
            local _ = v138 / 2.2;

            if v138 > 1.8 and not v140 then
                game.SoundService.SFX.Whoosh:Play();
                v140 = true;
            end;

            local function lerp(p141, p142, p143) -- Line: 948
                return p141 + (p142 - p141) * p143;
            end;

            local v144;

            if v138 < 1.8 then
                local v145 = v138 / 1.8;
                v144 = v145 ^ 4 * 0.08;
                workspace.CurrentCamera.FieldOfView = 45 + 5 * game.TweenService:GetValue(v145, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
            elseif v138 < 2.2 then
                local v146 = (v138 - 1.8) / 0.4;
                workspace.CurrentCamera.FieldOfView = 55 + -15 * game.TweenService:GetValue(v146, Enum.EasingStyle.Back, Enum.EasingDirection.InOut);
                v144 = v146 * v146 * (3 - v146 * 2) * 0.92 + 0.08;
            else
                v144 = 1;
            end;

            workspace.CurrentCamera.CFrame = CFrame2:Lerp(v139, v144);
        end;

        local v147 = CFrame.new(
            0,
            4.70700073,
            12.081604,
            1,
            1.47265382e-8,
            -5.58793545e-8,
            -6.82366663e-12,
            0.966528356,
            0.256560236,
            5.77419996e-8,
            -0.256560266,
            0.966528296
        );
        local Character2 = LocalPlayer.Character;

        if Character2 then
            Character2 = Character2:FindFirstChild("HumanoidRootPart");
        end;

        if Character2 and Character2:IsA("BasePart") then
            local v148 = game.TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CFrame = Character2.CFrame * v147
            });
            v148:Play();
            v148.Completed:Wait();
        end;

        u137 = true;
    end);

    if u76 then
        task.cancel(u76);
        u76 = nil;
    end;

    u22 = true;

    if u21 then
        task.cancel(u21);
        u21 = nil;
    end;

    u110:Disconnect();
    hideFrame();
    task.wait(1);
    task.wait(0.6);
    endTransparentBGfx();

    if u24 then
        u24:Pause();
        u24 = nil;
    end;

    showGuis();
    LocalPlayer:SetAttribute("LoadingScreenActive", false);
    local v149 = os.clock();

    while not u137 and os.clock() - v149 < 2 do
        task.wait();
    end;

    u98 = true;

    if u101 then
        u101:Disconnect();
        u101 = nil;
    end;

    local Character2 = LocalPlayer.Character;
    local v150;

    if Character2 then
        v150 = Character2:FindFirstChild("HumanoidRootPart");
    else
        v150 = Character2;
    end;

    if v150 then
        local v151 = LocalPlayer:GetAttribute("PlotId");
        local v152;

        if v151 then
            local Gardens = workspace:FindFirstChild("Gardens");

            if Gardens then
                v152 = Gardens:FindFirstChild("Plot" .. v151);
            else
                v152 = nil;
            end;
        else
            v152 = nil;
        end;

        if v152 then
            v152 = v152:FindFirstChild("SpawnPoint");
        end;

        if v152 then
            Character2:PivotTo(v152.CFrame);
        end;

        v150.Anchored = false;
    end;

    ProximityPromptService.Enabled = true;
    u8.Enabled = false;
    u93:Destroy();
    LocalPlayer:SetAttribute("LoadingScreenDone", true);
end)();