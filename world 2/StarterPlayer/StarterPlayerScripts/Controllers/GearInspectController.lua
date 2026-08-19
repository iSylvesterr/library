-- Decompiled with Potassium's decompiler.

local u1 = {};
local TweenService = game:GetService("TweenService");
local StarterGui = game:GetService("StarterGui");
local Players = game:GetService("Players");
local u2 = script:WaitForChild("Player"):Clone();
local LocalPlayer = Players.LocalPlayer;

if LocalPlayer and LocalPlayer.UserId then
    task.spawn(function() -- Line: 20
        -- upvalues: Players (copy), LocalPlayer (copy), u2 (copy)
        local success, result = pcall(Players.GetHumanoidDescriptionFromUserIdAsync, Players, LocalPlayer.UserId);

        if success and result then
            u2.Parent = script;
            u2.Humanoid:ApplyDescriptionResetAsync(result);
        end;
    end);
end;

local Trove = require(game.ReplicatedStorage.ClientModules.Trove);
local GuiController = require(script.Parent:WaitForChild("GuiController"));
local SceneApi = require(script:WaitForChild("SceneApi"));
local DevProductController = require(script.Parent:WaitForChild("DevProductController"));
local Networking = require(game.ReplicatedStorage.SharedModules:WaitForChild("Networking"));
local RobuxShopContent = require(game.ReplicatedStorage.SharedModules:WaitForChild("RobuxShopContent"));
local DevProducts = require(game.ReplicatedStorage.SharedModules:WaitForChild("DevProducts"));
local NumberUtils = require(game.ReplicatedStorage.SharedModules:WaitForChild("NumberUtils"));
local GearCinematicBars = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GearCinematicBars");
local BottomBar = GearCinematicBars:WaitForChild("BottomBar");
local TopBar = GearCinematicBars:WaitForChild("TopBar");
local Prizes = GearCinematicBars:WaitForChild("PrizesUI"):WaitForChild("Prizes");
local BuyButton = BottomBar:WaitForChild("BuyButton");
local GiftButton = BottomBar:WaitForChild("GiftButton");
local PlayerSelector = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PlayerSelector");
local GearShopData = require(game.ReplicatedStorage.SharedModules:WaitForChild("GearShopData"));
local Items = game.ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("GearShop"):WaitForChild("Items");
local u3 = {};

for _, v in GearShopData.Data do
    u3[v.ItemName] = v;
end;

local u4 = {};

for _, v in RobuxShopContent.Gears do
    if v.GamepassKey then
        u4[v.Name] = v.GamepassKey;
    end;
end;

if RobuxShopContent.GrapplingHookGear and RobuxShopContent.GrapplingHookGear.GamepassKey then
    u4[RobuxShopContent.GrapplingHookGear.Name] = RobuxShopContent.GrapplingHookGear.GamepassKey;
end;

local u5 = {};
local u6 = false;
local u7 = false;
local BindableEvent = Instance.new("BindableEvent");
local u8 = nil;
local u9 = nil;

local function EnsureOwnershipReady() -- Line: 84
    -- upvalues: u6 (ref), u7 (ref), BindableEvent (copy), Networking (copy), u5 (copy)
    if u6 then
        return;
    end;

    if u7 then
        BindableEvent.Event:Wait();

        return;
    end;

    u7 = true;
    local success, result = pcall(function() -- Line: 92
        -- upvalues: Networking (ref)
        return Networking.GearShop.RequestEquippableState:Fire();
    end);

    if success and (typeof(result) == "table" and typeof(result.OwnedEquippableGears) == "table") then
        for i in result.OwnedEquippableGears do
            u5[i] = true;
        end;
    end;

    u6 = true;
    u7 = false;
    BindableEvent:Fire();
end;

task.spawn(EnsureOwnershipReady);
Networking.GearShop.GearEquipState.OnClientEvent:Connect(function(p10, p11) -- Line: 107
    -- upvalues: u5 (copy), u8 (ref), u9 (ref)
    if type(p10) ~= "string" then
        return;
    end;

    if p11 then
        u5[p10] = true;
    end;

    if p10 == u8 and u9 then
        u9();
    end;
end);
LocalPlayer:GetAttributeChangedSignal("OwnedGamepasses"):Connect(function() -- Line: 117
    -- upvalues: u9 (ref)
    if u9 then
        u9();
    end;
end);

local function IsOneTimePurchase(p12) -- Line: 123
    -- upvalues: u4 (copy), u3 (copy)
    if u4[p12] then
        return true;
    end;

    local v13 = u3[p12];
    local v14;

    if v13 == nil then
        v14 = false;
    else
        v14 = v13.EquippableGear == true;
    end;

    return v14;
end;

local function OwnsGear(p15) -- Line: 129
    -- upvalues: u5 (copy), u4 (copy), LocalPlayer (copy)
    if u5[p15] then
        return true;
    end;

    if not u4[p15] then
        return false;
    end;

    local v16 = LocalPlayer:GetAttribute("OwnedGamepasses");

    if type(v16) ~= "string" or v16 == "" then
        return false;
    end;

    for i in v16:gmatch("[^,]+") do
        if i == p15 then
            return true;
        end;
    end;

    return false;
end;

local function GetRobuxPriceForGear(p17) -- Line: 140
    -- upvalues: u4 (copy), DevProducts (copy), DevProductController (copy)
    local v18 = u4[p17];

    if not v18 then
        local v19 = DevProductController:WaitForPreloadedProductInfo(`Gear:{p17}:1`, 5);

        if v19 and type(v19.PriceInRobux) == "number" then
            return v19.PriceInRobux;
        end;

        return nil;
    end;

    local v20 = DevProducts.GetGamepassByKey(v18);

    if not v20 then
        DevProductController:WaitForGamepassesReady();
        v20 = DevProducts.GetGamepassByKey(v18);
    end;

    if not v20 then
        return nil;
    end;

    if type(v20.PriceInRobux) == "number" then
        return v20.PriceInRobux;
    end;

    return nil;
end;

local u21 = Trove.new();
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = nil;

local function GetSceneCache() -- Line: 186
    -- upvalues: u26 (ref)
    if u26 then
        return u26;
    end;

    u26 = {};

    for _, child in script:WaitForChild("GearScenes"):GetChildren() do
        local v27 = string.lower(child.Name);

        if child:IsA("Folder") or child:IsA("Model") then
            local v28 = child:FindFirstChild("Scene") or child:FindFirstChildWhichIsA("ModuleScript");
            local FakePlot = child:FindFirstChild("FakePlot");

            if v28 and v28:IsA("ModuleScript") then
                u26[v27] = {
                    Module = v28,
                    FakePlot = FakePlot
                };
            end;
        elseif child:IsA("ModuleScript") then
            u26[v27] = {
                FakePlot = nil,
                Module = child
            };
        end;
    end;

    return u26;
end;

local function ResolveScene(p29) -- Line: 219
    -- upvalues: GetSceneCache (copy)
    local v30 = GetSceneCache();
    local default = v30.default;
    local v31 = v30[string.lower(p29)] or default;

    if not v31 then
        return nil, nil;
    end;

    local v32 = v31.FakePlot or (default and default.FakePlot or nil);

    return require(v31.Module), v32;
end;

local function GetInspectableGearNames() -- Line: 230
    -- upvalues: GetSceneCache (copy), u3 (copy)
    local v33 = {};

    for i, _ in GetSceneCache() do
        if i ~= "default" then
            for i2, _ in u3 do
                if string.lower(i2) == i then
                    table.insert(v33, i2);
                    break;
                end;
            end;
        end;
    end;

    return v33;
end;

local function GetProductKeyForGear(p34) -- Line: 248
    -- upvalues: u4 (copy)
    local v35 = u4[p34];

    if v35 then
        return v35, true;
    end;

    return `Gear:{p34}:1`, false;
end;

local function HandleGiftButton(p36, p37, p38) -- Line: 259
    -- upvalues: PlayerSelector (copy), Networking (copy), DevProductController (copy)
    local u39 = nil;
    task.spawn(function() -- Line: 261
        -- upvalues: PlayerSelector (ref), u39 (ref)
        local v40 = PlayerSelector.PlayerSelected.Event:Wait();

        if v40 == nil then
            u39 = "cancelled";

            return;
        end;

        u39 = v40;
    end);
    PlayerSelector:SetAttribute("OnlineOnly", false);
    PlayerSelector.Enabled = true;

    repeat
        task.wait();
    until u39 ~= nil;

    if u39 == "cancelled" then
        return;
    end;

    local success, result = pcall(function() -- Line: 276
        -- upvalues: Networking (ref), u39 (ref)
        Networking.DevProducts.SetGiftTarget:Fire(u39.UserId);
    end);

    if not success then
        warn((`[GearInspectController] SetGiftTarget fire failed ({p36}): {result}`));
    end;

    local u41;

    if p37 then
        u41 = `Gift:{p38}:1`;
    else
        u41 = `{p36}:Gift`;
    end;

    local success2, result2 = pcall(function() -- Line: 285
        -- upvalues: DevProductController (ref), u41 (copy)
        DevProductController:PromptPurchase(u41);
    end);

    if not success2 then
        warn((`[GearInspectController] Gift purchase prompt failed ({u41}): {result2}`));
    end;
end;

local function WirePurchaseButtons(u42) -- Line: 294
    -- upvalues: EnsureOwnershipReady (copy), u4 (copy), BuyButton (copy), u3 (copy), OwnsGear (copy), GetRobuxPriceForGear (copy), NumberUtils (copy), u8 (ref), u9 (ref), u21 (copy), DevProductController (copy), GiftButton (copy), HandleGiftButton (copy)
    EnsureOwnershipReady();
    local u43 = u4[u42];
    local u44;

    if u43 then
        u44 = true;
    else
        u43 = `Gear:{u42}:1`;
        u44 = false;
    end;

    local Price = BuyButton:FindFirstChild("Price");
    local u45;

    if Price then
        u45 = Price:FindFirstChild("TextLabel");
    else
        u45 = Price;
    end;

    local function SetLabel(p46) -- Line: 302
        -- upvalues: Price (copy), u45 (copy)
        if Price and Price.Parent then
            Price.Text = p46;
        end;

        if u45 and u45.Parent then
            u45.Text = p46;
        end;
    end;

    local function ApplyState() -- Line: 311
        -- upvalues: u42 (copy), u4 (ref), u3 (ref), OwnsGear (ref), Price (copy), u45 (copy), GetRobuxPriceForGear (ref), NumberUtils (ref)
        local v47 = u42;
        local v48;

        if u4[v47] then
            v48 = true;
        else
            local v49 = u3[v47];

            if v49 == nil then
                v48 = false;
            else
                v48 = v49.EquippableGear == true;
            end;
        end;

        if v48 and OwnsGear(u42) then
            if Price and Price.Parent then
                Price.Text = "OWNED";
            end;

            if u45 and u45.Parent then
                u45.Text = "OWNED";
            end;

            return;
        end;

        local v50 = GetRobuxPriceForGear(u42);

        if v50 then
            local v51 = `{NumberUtils.FormatWithCommas(v50)}`;

            if Price and Price.Parent then
                Price.Text = v51;
            end;

            if u45 and u45.Parent then
                u45.Text = v51;
            end;
        else
            if Price and Price.Parent then
                Price.Text = "...";
            end;

            if u45 and u45.Parent then
                u45.Text = "...";
            end;
        end;
    end;

    BuyButton.Visible = true;
    ApplyState();
    u8 = u42;
    u9 = ApplyState;
    u21:Add(function() -- Line: 329
        -- upvalues: u8 (ref), u42 (copy), u9 (ref)
        if u8 == u42 then
            u8 = nil;
            u9 = nil;
        end;
    end);
    u21:Add(BuyButton.Activated:Connect(function() -- Line: 336
        -- upvalues: u42 (copy), u4 (ref), u3 (ref), OwnsGear (ref), ApplyState (copy), u44 (copy), DevProductController (ref), u43 (copy)
        local v52 = u42;
        local v53;

        if u4[v52] then
            v53 = true;
        else
            local v54 = u3[v52];

            if v54 == nil then
                v53 = false;
            else
                v53 = v54.EquippableGear == true;
            end;
        end;

        if v53 and OwnsGear(u42) then
            ApplyState();

            return;
        end;

        if u44 then
            DevProductController:PromptGamepassPurchase(u43);

            return;
        end;

        DevProductController:PromptPurchase(u43);
    end));
    u21:Add(GiftButton.Activated:Connect(function() -- Line: 348
        -- upvalues: HandleGiftButton (ref), u43 (copy), u44 (copy), u42 (copy)
        HandleGiftButton(u43, u44, u42);
    end));
end;

local function IsGearInStock(p55) -- Line: 354
    -- upvalues: Items (copy)
    local v56 = Items:FindFirstChild(p55);

    return v56 and v56.Value > 0 and true or false;
end;

local function PopulateGearSidePanel(p57) -- Line: 360
    -- upvalues: GetInspectableGearNames (copy), Items (copy), Prizes (copy), u3 (copy), u21 (copy), u22 (ref), u1 (copy)
    local v58 = {};

    for _, v in GetInspectableGearNames() do
        if v ~= p57 then
            local v59 = Items:FindFirstChild(v);

            if v59 and v59.Value > 0 and true or false then
                table.insert(v58, v);
            end;
        end;
    end;

    local v60 = 1;

    while Prizes:FindFirstChild((`Item{v60}`)) do
        local v61 = Prizes:FindFirstChild((`Item{v60}`));
        local u62 = v58[v60];

        if u62 then
            local v63 = u3[u62];
            v61.Visible = true;

            if v61:FindFirstChild("ItemImage") and (v63 and v63.IMG) then
                v61.ItemImage.Image = v63.IMG;
            end;

            if v61:FindFirstChild("ItemName") then
                v61.ItemName.Text = u62;
            end;

            if v61:FindFirstChild("Odds") then
                v61.Odds.Visible = false;
            end;

            if v61:FindFirstChild("Inspect") then
                u21:Add(v61.Inspect.Activated:Connect(function() -- Line: 389
                    -- upvalues: u22 (ref), u1 (ref), u62 (copy)
                    u1.Inspect({
                        GearName = u62
                    }, u22);
                end));
            end;
        else
            v61.Visible = false;
        end;

        v60 = v60 + 1;
    end;
end;

local function HideBars() -- Line: 403
    -- upvalues: TweenService (copy), BottomBar (copy), TopBar (copy), Prizes (copy)
    TweenService:Create(BottomBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 0)
    }):Play();
    TweenService:Create(TopBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 1)
    }):Play();
    TweenService:Create(Prizes, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(1, 0.5)
    }):Play();
end;

local function ShowBars() -- Line: 410
    -- upvalues: TweenService (copy), BottomBar (copy), TopBar (copy), Prizes (copy)
    TweenService:Create(BottomBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 1)
    }):Play();
    TweenService:Create(TopBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 0)
    }):Play();
    TweenService:Create(Prizes, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        AnchorPoint = Vector2.new(0, 0.5)
    }):Play();
end;

function u1.Stop(p64) -- Line: 417
    -- upvalues: u24 (ref), u21 (copy), HideBars (copy), u25 (ref), u22 (ref), u23 (ref)
    if u24 then
        pcall(u24, true);
        u24 = nil;
    end;

    if u21 then
        u21:Clean();
    end;

    if p64 then
        HideBars();

        if u25 then
            local CurrentCamera = game.Workspace.CurrentCamera;
            CurrentCamera.CameraType = u25.CameraType;
            CurrentCamera.CameraSubject = u25.CameraSubject;
            CurrentCamera.FieldOfView = u25.FieldOfView;
            CurrentCamera.CFrame = u25.CFrame;
            u25 = nil;
        end;

        u22 = nil;
        u23 = nil;
    end;
end;

function u1.Start(p65) -- Line: 450
end;

function u1.Init(p66) -- Line: 454
end;

function u1.Inspect(p67, p68, p69) -- Line: 459
    -- upvalues: u23 (ref), u25 (ref), u1 (copy), GetSceneCache (copy), u21 (copy), u2 (copy), GuiController (copy), u22 (ref), LocalPlayer (copy), StarterGui (copy), PopulateGearSidePanel (copy), WirePurchaseButtons (copy), ShowBars (copy), TopBar (copy), SceneApi (copy), u24 (ref)
    local v70 = p67.GearName or p67.Name;
    u23 = v70;

    if not u25 then
        local CurrentCamera = game.Workspace.CurrentCamera;
        u25 = {
            CameraType = CurrentCamera.CameraType,
            CameraSubject = CurrentCamera.CameraSubject,
            FieldOfView = CurrentCamera.FieldOfView,
            CFrame = CurrentCamera.CFrame
        };
    end;

    u1.Stop(false);
    local v71 = p69 or {};
    local v72 = GetSceneCache();
    local default = v72.default;
    local v73 = v72[string.lower(v70)] or default;
    local v74, v75;

    if v73 then
        v74 = v73.FakePlot or (default and default.FakePlot or nil);
        v75 = require(v73.Module);
    else
        v75 = nil;
        v74 = nil;
    end;

    if not v75 then
        return;
    end;

    if not v74 then
        return;
    end;

    local v76 = v74:Clone();
    v76.Parent = game.Workspace;
    u21:Add(v76);
    local v77 = u2:Clone();
    v77.Parent = v76;
    local Humanoid = v77:WaitForChild("Humanoid");

    if v77.PrimaryPart then
        v77.PrimaryPart.Anchored = false;
        local PlayerSpawn = v76:FindFirstChild("PlayerSpawn", true);

        if PlayerSpawn and PlayerSpawn:IsA("BasePart") then
            v77:PivotTo(PlayerSpawn.CFrame + Vector3.new(0, 3, 0));
        elseif v76.PrimaryPart then
            v77:PivotTo(v76.PrimaryPart.CFrame + Vector3.new(0, v76.PrimaryPart.Size.Y / 2 + 3, 0));
        end;
    end;

    GuiController:Close();

    if p68 then
        u22 = p68;
    end;

    local u78 = {};

    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "GearCinematicBars" then
            u78[child] = child.Enabled;
            child.Enabled = false;
        end;
    end;

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
    u21:Add(function() -- Line: 535
        -- upvalues: StarterGui (ref), LocalPlayer (ref), u78 (copy)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true);
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);

        if LocalPlayer:GetAttribute("CustomChatActive") then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false);
        end;

        for i, v in u78 do
            if i then
                i.Enabled = v;
            end;
        end;
    end);
    PopulateGearSidePanel(v70);
    WirePurchaseButtons(v70);
    ShowBars();
    TopBar.NameLabel.Text = `{string.upper(v70)} GEAR`;
    TopBar.NameLabel.TextLabel.Text = `{string.upper(v70)} GEAR`;
    u21:Add(TopBar.ExitButton.Activated:Connect(function() -- Line: 562
        -- upvalues: u22 (ref), u1 (ref)
        local v79 = u22;
        u1.Stop(true);

        if v79 then
            v79();
        end;
    end));
    math.randomseed(os.clock() * 1000);
    local v80 = SceneApi.new({
        Plot = v76,
        PlayerModel = v77,
        PlayerHumanoid = Humanoid,
        Camera = game.Workspace.CurrentCamera,
        Trove = u21,
        GearData = p67,
        Options = v71
    });
    u24 = v75.Run(v80);
end;

return u1;