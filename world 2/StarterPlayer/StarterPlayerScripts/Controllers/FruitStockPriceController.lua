-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local SellValueData = require(ReplicatedStorage.SharedModules.SellValueData);
local SeedShopEnabled = require(ReplicatedStorage.SharedModules.SeedShopEnabled);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local GuiController = require(script.Parent.GuiController);
local FruitImages = ReplicatedStorage.SharedModules.SeedData:FindFirstChild("FruitImages");
local u1 = {};

for _, v in SeedData do
    u1[v.SeedName] = v;
end;

local v2 = {};
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = {};
local u8 = 0;
local u9 = 0;
local u10 = 600;
local u11 = 0;
local u12 = "";

local function nowUnix() -- Line: 76
    -- upvalues: u11 (ref)
    return os.time() + u11;
end;

local function fruitImage(p13) -- Line: 80
    -- upvalues: FruitImages (copy)
    if not FruitImages then
        return nil;
    end;

    local v14 = FruitImages:FindFirstChild(p13);

    if v14 and v14:IsA("StringValue") then
        return v14.Value;
    end;

    return nil;
end;

local function formatMultiplier(p15, p16) -- Line: 95
    local v17 = math.floor(p15 * 100 + 0.5) / 100;

    if v17 == math.floor(v17) then
        return string.format("X%d", v17);
    end;

    return "X" .. string.format("%.2f", v17):gsub("0+$", ""):gsub("%.$", "");
end;

local function applyTierVisuals(p18, p19, p20) -- Line: 111
    local Harvest = p18:FindFirstChild("Harvest");
    local Harvest2 = p19:FindFirstChild("Harvest");
    local v21 = Harvest and Harvest:IsA("UIStroke");

    if not v21 then
        if Harvest2 then
            v21 = Harvest2:IsA("UIGradient");
        else
            v21 = Harvest2;
        end;
    end;

    local v22;

    if p20 == "mega" then
        v22 = true;
    elseif p20 == "harvest" then
        v22 = not v21;
    else
        v22 = false;
    end;

    local Big = p18:FindFirstChild("Big");
    local Mega = p18:FindFirstChild("Mega");

    if Big and Big:IsA("UIStroke") then
        Big.Enabled = p20 == "big";
    end;

    if Mega and Mega:IsA("UIStroke") then
        Mega.Enabled = v22;
    end;

    if Harvest and Harvest:IsA("UIStroke") then
        Harvest.Enabled = p20 == "harvest";
    end;

    local Big2 = p19:FindFirstChild("Big");
    local Mega2 = p19:FindFirstChild("Mega");

    if Big2 and Big2:IsA("UIGradient") then
        Big2.Enabled = p20 == "big";
    end;

    if Mega2 and Mega2:IsA("UIGradient") then
        Mega2.Enabled = v22;
    end;

    if Harvest2 and Harvest2:IsA("UIGradient") then
        Harvest2.Enabled = p20 == "harvest";
    end;
end;

local function buildCard(p23, p24, p25) -- Line: 142
    -- upvalues: u4 (ref), u3 (ref), FruitImages (copy), formatMultiplier (copy), applyTierVisuals (copy)
    local v26 = u4;
    local v27 = u3;

    if not (v26 and v27) then
        return;
    end;

    local v28 = v26:Clone();
    v28.Name = "FruitCard";
    v28.LayoutOrder = p25;
    v28.Visible = true;
    v28:SetAttribute("SeedToolTip", p23);
    local Frame = v28:FindFirstChild("Frame");

    if Frame then
        local FruitVector = Frame:FindFirstChild("FruitVector");
        local v29;

        if FruitImages then
            local v30 = FruitImages:FindFirstChild(p23);

            if v30 and v30:IsA("StringValue") then
                v29 = v30.Value;
            else
                v29 = nil;
            end;
        else
            v29 = nil;
        end;

        if FruitVector and (FruitVector:IsA("ImageLabel") and v29) then
            FruitVector.Image = v29;
        end;

        local Multiplier = Frame:FindFirstChild("Multiplier");

        if Multiplier and Multiplier:IsA("TextLabel") then
            Multiplier.Text = formatMultiplier(p24.multiplier, p24.tier);
            applyTierVisuals(Frame, Multiplier, p24.tier);
        end;
    end;

    v28.Parent = v27;
end;

local u31 = {
    harvest = -3000,
    mega = -2000,
    big = -1000,
    normal = 0
};

local function rebuildCards() -- Line: 185
    -- upvalues: u3 (ref), u4 (ref), SellValueData (copy), u1 (copy), Worlds (copy), SeedShopEnabled (copy), u7 (ref), u31 (copy), buildCard (copy)
    local v32 = u3;
    local v33 = u4;

    if not (v32 and v33) then
        return;
    end;

    for _, child in v32:GetChildren() do
        if child:IsA("Frame") and (child ~= v33 and child.Name == "FruitCard") then
            child:Destroy();
        end;
    end;

    local v34 = {};

    for i in SellValueData do
        local v35 = u1[i];

        if (v35 == nil or Worlds.EntryAvailableHere(v35)) and SeedShopEnabled.IsSeedEnabled(i) then
            table.insert(v34, i);
        end;
    end;

    table.sort(v34, function(p36, p37) -- Line: 219
        -- upvalues: SellValueData (ref)
        local v38 = SellValueData[p36];
        local v39 = SellValueData[p37];

        if v38 == v39 then
            return p36 < p37;
        end;

        return v39 < v38;
    end);

    for i, v in v34 do
        local v40 = u7[v] or {
            multiplier = 1,
            tier = "normal"
        };
        buildCard(v, v40, i + (u31[v40.tier] or 0));
    end;
end;

local function applySnapshot(p41) -- Line: 235
    -- upvalues: u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), rebuildCards (copy)
    if typeof(p41) ~= "table" then
        return;
    end;

    local v42 = {};

    if typeof(p41.entries) == "table" then
        for i, v in p41.entries do
            if typeof(i) == "string" and typeof(v) == "table" then
                v42[i] = {
                    multiplier = typeof(v.multiplier) ~= "number" and 1 or v.multiplier,
                    tier = typeof(v.tier) ~= "string" and "normal" or v.tier
                };
            end;
        end;
    end;

    u7 = v42;

    if typeof(p41.lastRefreshUnix) == "number" then
        u8 = p41.lastRefreshUnix;
    end;

    if typeof(p41.nextRefreshUnix) == "number" then
        u9 = p41.nextRefreshUnix;
    end;

    if typeof(p41.cycleSeconds) == "number" and p41.cycleSeconds > 0 then
        u10 = p41.cycleSeconds;
    end;

    if typeof(p41.server_now_unix) == "number" then
        u11 = p41.server_now_unix - os.time();
    end;

    rebuildCards();
end;

local function formatRefresh(p43) -- Line: 266
    local v44 = math.floor(p43);
    local v45 = math.max(0, v44);

    return string.format("%dm %02ds", v45 // 60, v45 % 60);
end;

local function updateRefresh() -- Line: 274
    -- upvalues: u11 (ref), u6 (ref), u8 (ref), u10 (ref), u5 (ref), u9 (ref), u12 (ref)
    local v46 = os.time() + u11;

    if u6 then
        local v47 = u10 <= 0 and 0 or math.clamp((v46 - u8) / u10, 0, 1);
        u6.Offset = Vector2.new(v47, 0);
    end;

    if u5 then
        local v48 = math.max(0, u9 - v46);
        local v49 = math.floor(v48);
        local v50 = math.max(0, v49);
        local v51 = "Refresh in " .. string.format("%dm %02ds", v50 // 60, v50 % 60);

        if v51 ~= u12 then
            u12 = v51;
            u5.Text = v51;
        end;
    end;
end;

local function setup() -- Line: 295
    -- upvalues: Players (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref), GuiController (copy), Networking (copy), applySnapshot (copy), RunService (copy), updateRefresh (copy)
    local FruitStockPrice = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("FruitStockPrice");
    local Frame = FruitStockPrice:WaitForChild("Frame");
    local Header = Frame:WaitForChild("Header");
    local RefreshIn = Header:WaitForChild("RefreshIn");

    if FruitStockPrice:IsA("ScreenGui") then
        FruitStockPrice.Enabled = false;
    end;

    u3 = Frame:WaitForChild("ScrollingFrame");
    u4 = u3:WaitForChild("Template");
    u5 = RefreshIn:WaitForChild("Timer");
    u6 = RefreshIn:FindFirstChildOfClass("UIGradient");
    u4.Visible = false;
    local v52 = u3:FindFirstChildOfClass("UIGridLayout");

    if v52 then
        v52.SortOrder = Enum.SortOrder.LayoutOrder;
    end;

    local ExitButton = Header:FindFirstChild("ExitButton");

    if ExitButton and ExitButton:IsA("GuiButton") then
        ExitButton.Activated:Connect(function() -- Line: 322
            -- upvalues: GuiController (ref)
            GuiController:Close();
        end);
    end;

    Networking.FruitStock.Snapshot.OnClientEvent:Connect(applySnapshot);
    local success, result = pcall(function() -- Line: 329
        -- upvalues: Networking (ref)
        return Networking.FruitStock.Request:Fire();
    end);

    if success then
        applySnapshot(result);
    end;

    RunService.RenderStepped:Connect(function() -- Line: 336
        -- upvalues: FruitStockPrice (copy), updateRefresh (ref)
        if FruitStockPrice.Enabled then
            updateRefresh();
        end;
    end);
end;

function v2.Init(p53) -- Line: 345
end;

function v2.Start(p54) -- Line: 347
    -- upvalues: setup (copy)
    task.spawn(setup);
end;

return v2;