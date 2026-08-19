-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local ServerInfo = ReplicatedStorage:WaitForChild("ServerInfo");
require(Modules.ShopData);
local BountyData = require(Modules.BountyData);
local ItemRarity = require(Modules.ItemRarity);
local PlantData = require(Modules.PlantData);
local TravelingNPCs = Assets:WaitForChild("TravelingNPCs");
local LocalPlayer = Players.LocalPlayer;
local Map = workspace:WaitForChild("World"):WaitForChild("Map", (1 / 0));
Map:WaitForChild("Plots");
local NPCs = Map:WaitForChild("NPCs");
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
PlayerGui:WaitForChild("MainGui"):WaitForChild("Events");
local MERCHANT_ACTIVE = ServerInfo:WaitForChild("MERCHANT_ACTIVE");
local MERCHANT_TIMER = ServerInfo:WaitForChild("MERCHANT_TIMER");

repeat
    task.wait();
until workspace:GetAttribute("Loaded") == true;

local TravelingMerchantCountdown = Map:WaitForChild("TravelingMerchantShop"):WaitForChild("BillboardPart"):WaitForChild("TravelingMerchantCountdown");
local BountyNPC = NPCs:WaitForChild("BountyNPC");
local BountyCooldown = BountyNPC:WaitForChild("BillboardPart"):WaitForChild("BountyCooldown");
local HardBillboardPart = BountyNPC:WaitForChild("HardBillboardPart");
local HardBillboard = script:WaitForChild("HardBillboard");
HardBillboard.Parent = PlayerGui;
HardBillboard.Adornee = HardBillboardPart;
local Frame = HardBillboard:WaitForChild("Frame");
local Title = Frame:WaitForChild("Title");
local Requirements = Frame:WaitForChild("Requirements");
local Claimed = HardBillboard:WaitForChild("Claimed");
local Any = Frame:WaitForChild("Any");
local ViewportFrame = Frame:WaitForChild("ViewportFrame");
local Glow = Frame:WaitForChild("Glow");
local EasyBillboardPart = BountyNPC:WaitForChild("EasyBillboardPart");
local EasyBillboard = script:WaitForChild("EasyBillboard");
EasyBillboard.Parent = PlayerGui;
EasyBillboard.Adornee = EasyBillboardPart;
local Frame2 = EasyBillboard:WaitForChild("Frame");
local Title2 = Frame2:WaitForChild("Title");
local Requirements2 = Frame2:WaitForChild("Requirements");
local Claimed2 = EasyBillboard:WaitForChild("Claimed");
local Any2 = Frame2:WaitForChild("Any");
local ViewportFrame2 = Frame2:WaitForChild("ViewportFrame");
local Glow2 = Frame2:WaitForChild("Glow");

local function spinForever(u1, p2) -- Line: 75
    local u3 = p2 or 4;
    task.spawn(function() -- Line: 78
        -- upvalues: u1 (copy), u3 (ref)
        while u1.Parent do
            local Rotation = u1.Rotation;
            local v4 = 0;

            while v4 < u3 and u1.Parent do
                v4 = v4 + task.wait();
                u1.Rotation = (Rotation + v4 / u3 * 360) % 360;
            end;
        end;
    end);
end;

local u5 = 15 or 4;
task.spawn(function() -- Line: 78
    -- upvalues: Glow2 (copy), u5 (ref)
    while Glow2.Parent do
        local Rotation = Glow2.Rotation;
        local v6 = 0;

        while v6 < u5 and Glow2.Parent do
            v6 = v6 + task.wait();
            Glow2.Rotation = (Rotation + v6 / u5 * 360) % 360;
        end;
    end;
end);
local u7 = 15 or 4;
task.spawn(function() -- Line: 78
    -- upvalues: Glow (copy), u7 (ref)
    while Glow.Parent do
        local Rotation = Glow.Rotation;
        local v8 = 0;

        while v8 < u7 and Glow.Parent do
            v8 = v8 + task.wait();
            Glow.Rotation = (Rotation + v8 / u7 * 360) % 360;
        end;
    end;
end);

local function convertToHMS(p9) -- Line: 95
    local v10 = math.floor(p9 / 60);
    local v11 = p9 % 60;

    if v10 <= 0 then
        return v11 .. "s";
    end;

    return v10 .. "m " .. v11 .. "s";
end;

local function updateMerchantBillboard() -- Line: 104
    -- upvalues: MERCHANT_ACTIVE (copy), TravelingMerchantCountdown (copy), MERCHANT_TIMER (copy)
    if MERCHANT_ACTIVE.Value then
        TravelingMerchantCountdown.Frame.Title.Text = "The traveling merchant leaves in...";
        local Timer = TravelingMerchantCountdown.Frame.Timer;
        local Value = MERCHANT_TIMER.Value;
        local v12 = math.floor(Value / 60);
        local v13 = Value % 60;
        local v14;

        if v12 <= 0 then
            v14 = v13 .. "s";
        else
            v14 = v12 .. "m " .. v13 .. "s";
        end;

        Timer.Text = v14;

        return;
    end;

    TravelingMerchantCountdown.Frame.Title.Text = "A traveling merchant arrives in...";
    local Timer = TravelingMerchantCountdown.Frame.Timer;
    local Value = MERCHANT_TIMER.Value;
    local v15 = math.floor(Value / 60);
    local v16 = Value % 60;
    local v17;

    if v15 <= 0 then
        v17 = v16 .. "s";
    else
        v17 = v15 .. "m " .. v16 .. "s";
    end;

    Timer.Text = v17;
end;

local function updateBountyBillboard(p18) -- Line: 114
    -- upvalues: BountyCooldown (copy)
    if p18 == nil then
        return;
    end;

    local Timer = BountyCooldown.Frame.Timer;
    local v19 = math.floor(p18 / 60);
    local v20 = p18 % 60;
    local v21;

    if v19 <= 0 then
        v21 = v20 .. "s";
    else
        v21 = v19 .. "m " .. v20 .. "s";
    end;

    Timer.Text = v21;
end;

local function removeMerchant() -- Line: 122
    -- upvalues: NPCs (copy)
    for _, child in NPCs:GetChildren() do
        if child.Name == "MerchantNPC" then
            child:Destroy();
        end;
    end;
end;

local function spawnMerchant(p22) -- Line: 130
    -- upvalues: removeMerchant (copy), TravelingNPCs (copy), NPCs (copy)
    removeMerchant();
    local v23 = TravelingNPCs:FindFirstChild(p22);

    if not v23 then
        warn("TravelingMerchantClient: no NPC asset found for \'" .. tostring(p22) .. "\'");

        return;
    end;

    local v24 = v23:Clone();
    v24.Name = "MerchantNPC";
    v24:SetAttribute("MerchantName", p22);
    v24.Parent = NPCs;
end;

local v25, _, _, _ = Remotes.RequestMerchantStock:InvokeServer();

if MERCHANT_ACTIVE.Value and v25 then
    spawnMerchant(v25);
end;

if MERCHANT_ACTIVE.Value then
    TravelingMerchantCountdown.Frame.Title.Text = "The traveling merchant leaves in...";
    local Timer = TravelingMerchantCountdown.Frame.Timer;
    local Value = MERCHANT_TIMER.Value;
    local v26 = math.floor(Value / 60);
    local v27 = Value % 60;
    local v28;

    if v26 <= 0 then
        v28 = v27 .. "s";
    else
        v28 = v26 .. "m " .. v27 .. "s";
    end;

    Timer.Text = v28;
else
    TravelingMerchantCountdown.Frame.Title.Text = "A traveling merchant arrives in...";
    local Timer = TravelingMerchantCountdown.Frame.Timer;
    local Value = MERCHANT_TIMER.Value;
    local v29 = math.floor(Value / 60);
    local v30 = Value % 60;
    local v31;

    if v29 <= 0 then
        v31 = v30 .. "s";
    else
        v31 = v29 .. "m " .. v30 .. "s";
    end;

    Timer.Text = v31;
end;

MERCHANT_TIMER.Changed:Connect(updateMerchantBillboard);
MERCHANT_ACTIVE.Changed:Connect(updateMerchantBillboard);
task.spawn(function() -- Line: 167
    -- upvalues: BountyData (copy), BountyCooldown (copy)
    local v32 = BountyData.getWindowNumber();

    while task.wait(1) do
        local v33 = BountyData.getSecondsRemaining();

        if v33 ~= nil then
            local Timer = BountyCooldown.Frame.Timer;
            local v34 = math.floor(v33 / 60);
            local v35 = v33 % 60;
            local v36;

            if v34 <= 0 then
                v36 = v35 .. "s";
            else
                v36 = v34 .. "m " .. v35 .. "s";
            end;

            Timer.Text = v36;
        end;

        local v37 = BountyData.getWindowNumber();

        if v37 == v32 then
            v37 = v32;
        end;

        v32 = v37;
    end;
end);
Remotes.UpdateTravelingMerchantStock.OnClientEvent:Connect(function(p38, p39) -- Line: 184
    -- upvalues: spawnMerchant (copy), MERCHANT_ACTIVE (copy), TravelingMerchantCountdown (copy), MERCHANT_TIMER (copy)
    spawnMerchant(p38);

    if MERCHANT_ACTIVE.Value then
        TravelingMerchantCountdown.Frame.Title.Text = "The traveling merchant leaves in...";
        local Timer = TravelingMerchantCountdown.Frame.Timer;
        local Value = MERCHANT_TIMER.Value;
        local v40 = math.floor(Value / 60);
        local v41 = Value % 60;
        local v42;

        if v40 <= 0 then
            v42 = v41 .. "s";
        else
            v42 = v40 .. "m " .. v41 .. "s";
        end;

        Timer.Text = v42;

        return;
    end;

    TravelingMerchantCountdown.Frame.Title.Text = "A traveling merchant arrives in...";
    local Timer = TravelingMerchantCountdown.Frame.Timer;
    local Value = MERCHANT_TIMER.Value;
    local v43 = math.floor(Value / 60);
    local v44 = Value % 60;
    local v45;

    if v43 <= 0 then
        v45 = v44 .. "s";
    else
        v45 = v43 .. "m " .. v44 .. "s";
    end;

    Timer.Text = v45;
end);
Remotes.MerchantLeft.OnClientEvent:Connect(function() -- Line: 190
    -- upvalues: removeMerchant (copy), MERCHANT_ACTIVE (copy), TravelingMerchantCountdown (copy), MERCHANT_TIMER (copy)
    removeMerchant();

    if MERCHANT_ACTIVE.Value then
        TravelingMerchantCountdown.Frame.Title.Text = "The traveling merchant leaves in...";
        local Timer = TravelingMerchantCountdown.Frame.Timer;
        local Value = MERCHANT_TIMER.Value;
        local v46 = math.floor(Value / 60);
        local v47 = Value % 60;
        local v48;

        if v46 <= 0 then
            v48 = v47 .. "s";
        else
            v48 = v46 .. "m " .. v47 .. "s";
        end;

        Timer.Text = v48;

        return;
    end;

    TravelingMerchantCountdown.Frame.Title.Text = "A traveling merchant arrives in...";
    local Timer = TravelingMerchantCountdown.Frame.Timer;
    local Value = MERCHANT_TIMER.Value;
    local v49 = math.floor(Value / 60);
    local v50 = Value % 60;
    local v51;

    if v49 <= 0 then
        v51 = v50 .. "s";
    else
        v51 = v49 .. "m " .. v50 .. "s";
    end;

    Timer.Text = v51;
end);

local function clearViewport(p52) -- Line: 198
    p52.CurrentCamera = nil;

    for _, child in p52:GetChildren() do
        if child:IsA("Camera") or child:IsA("WorldModel") then
            child:Destroy();
        end;
    end;
end;

local function setupViewportModel(p53, p54) -- Line: 208
    -- upvalues: clearViewport (copy)
    if not (p53 and p53:IsA("Model")) then
        warn("Invalid viewport model:", p53);

        return nil;
    end;

    clearViewport(p54);
    local Camera = Instance.new("Camera");
    Camera.Name = "ViewportCamera";
    Camera.FieldOfView = 35;
    Camera.Parent = p54;
    p54.CurrentCamera = Camera;
    local WorldModel = Instance.new("WorldModel");
    WorldModel.Name = "ViewportWorld";
    WorldModel.Parent = p54;
    local v55 = p53:Clone();
    v55.Name = "DisplayModel";
    v55.Parent = WorldModel;

    for _, descendant in v55:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
        end;
    end;

    if not (v55.PrimaryPart or v55:FindFirstChildWhichIsA("BasePart", true)) then
        warn("Viewport model contains no BasePart:", v55.Name);
        clearViewport(p54);

        return nil;
    end;

    v55:PivotTo(CFrame.new());
    local v56, v57 = v55:GetBoundingBox();
    local v58 = math.max(v57.X, v57.Y, v57.Z);
    local Position = v56.Position;
    local v59 = math.max((v58 <= 0 and 1 or v58) * 2, 4);
    local v60 = CFrame.Angles(-0.17453292519943295, 3.5779249665883754, 0):VectorToWorldSpace((Vector3.new(0, v57.Y * 0.1, v59)));
    Camera.CFrame = CFrame.lookAt(Position + v60, Position);
    p54.BackgroundTransparency = 1;
    p54.Ambient = Color3.fromRGB(200, 200, 200);
    p54.LightColor = Color3.fromRGB(255, 255, 255);
    p54.LightDirection = Vector3.new(-1, -1, -1);

    return v55;
end;

local function getItemModel(p61) -- Line: 289
    -- upvalues: Assets (copy)
    if not p61 then
        return nil;
    end;

    local Towers = Assets:FindFirstChild("Towers");
    local Plants = Assets:FindFirstChild("Plants");
    local v62 = Towers and Towers:FindFirstChild(p61.Name);

    if v62 then
        Plants = v62;
    elseif Plants then
        Plants = Plants:FindFirstChild(p61.Name);
    end;

    if not Plants then
        warn("No item asset found for:", p61.Name);

        return nil;
    end;

    local ClientModel = Plants:FindFirstChild("ClientModel");

    if ClientModel and ClientModel:IsA("Model") then
        return ClientModel;
    end;

    warn("No valid ClientModel found for:", p61.Name);

    return nil;
end;

local function playIdleAnimation(p63, p64) -- Line: 316
    if not (p63 and p64) then
        return;
    end;

    local v65 = p63:FindFirstChildWhichIsA("AnimationController", true);
    local Animations = p64:FindFirstChild("Animations");

    if not (v65 and Animations) then
        return;
    end;

    local Idle = Animations:FindFirstChild("Idle");

    if not (Idle and Idle:IsA("Animation")) then
        return;
    end;

    local u66 = v65:FindFirstChildWhichIsA("Animator") or Instance.new("Animator");
    u66.Parent = v65;
    local success, result = pcall(function() -- Line: 342
        -- upvalues: u66 (copy), Idle (copy)
        return u66:LoadAnimation(Idle);
    end);

    if not (success and result) then
        warn("Failed to load idle animation for:", p64.Name);

        return;
    end;

    result.Looped = true;
    result:Play();
end;

local function updateBountyViewport(p67, p68, p69) -- Line: 353
    -- upvalues: getItemModel (copy), setupViewportModel (copy), playIdleAnimation (copy)
    if not p69 then
        p67.Visible = false;
        p68.Visible = true;
        p67:ClearAllChildren();
        p67.CurrentCamera = nil;

        return;
    end;

    p68.Visible = false;
    p67.Visible = true;
    local v70 = getItemModel(p69);

    if v70 then
        playIdleAnimation(setupViewportModel(v70, p67), p69);

        return;
    end;

    warn("Could not find ClientModel for:", p69.Name);
    p67.Visible = false;
end;

local RequestBounties = Remotes:WaitForChild("RequestBounties");
local BountiesUpdated = Remotes:WaitForChild("BountiesUpdated");

local function updateBountyBoards() -- Line: 388
    -- upvalues: RequestBounties (copy), Claimed2 (copy), Claimed (copy), PlantData (copy), Title2 (copy), ItemRarity (copy), Requirements2 (copy), Title (copy), Requirements (copy), updateBountyViewport (copy), ViewportFrame2 (copy), Any2 (copy), ViewportFrame (copy), Any (copy)
    local v71 = RequestBounties:InvokeServer();

    if not v71 then
        return;
    end;

    if v71.EasyClaimed and v71.EasyClaimed == true then
        Claimed2.Visible = true;
    else
        Claimed2.Visible = false;
    end;

    if v71.HardClaimed and v71.HardClaimed == true then
        Claimed.Visible = true;
    else
        Claimed.Visible = false;
    end;

    local Easy = v71.Easy;
    local Hard = v71.Hard;

    if not (Easy and Hard) then
        return;
    end;

    local v72 = Easy.PlantName or Easy.Rarity;
    local v73 = Hard.PlantName or Hard.Rarity;
    local MinSize = Easy.MinSize;
    local MinSize2 = Hard.MinSize;
    local Mutations = Easy.Mutations;
    local Mutations2 = Hard.Mutations;

    if not (v72 and v73) then
        return;
    end;

    if not (MinSize and MinSize2) then
        return;
    end;

    if not (Mutations and Mutations2) then
        return;
    end;

    local v74 = PlantData.getData(v72);
    local v75 = PlantData.getData(v73);

    local function buildRequirementText(p76, p77) -- Line: 424
        local v78 = {};

        if p76 and p76 > 1 then
            table.insert(v78, string.format("+%gx Size", p76));
        end;

        if p77 and #p77 > 0 then
            table.insert(v78, table.concat(p77, " + "));
        end;

        return table.concat(v78, ", ");
    end;

    Title2.Text = Easy.PlantName and v72 and v72 or "Any " .. v72;

    if v74 then
        v72 = v74.Rarity.Value or v72;
    end;

    ItemRarity.applyGradient(Title2, v72);
    Requirements2.Text = buildRequirementText(MinSize, Mutations);
    Title.Text = Hard.PlantName and v73 and v73 or "Any " .. v73;

    if v75 then
        v73 = v75.Rarity.Value or v73;
    end;

    ItemRarity.applyGradient(Title, v73);
    Requirements.Text = buildRequirementText(MinSize2, Mutations2);
    updateBountyViewport(ViewportFrame2, Any2, v74);
    updateBountyViewport(ViewportFrame, Any, v75);
end;

updateBountyBoards();
BountiesUpdated.OnClientEvent:Connect(function() -- Line: 483
    -- upvalues: updateBountyBoards (copy)
    updateBountyBoards();
end);