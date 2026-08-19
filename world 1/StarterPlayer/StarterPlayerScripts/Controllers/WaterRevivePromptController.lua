-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local GearShopData = require(ReplicatedStorage.SharedModules.GearShopData);
local PlayerStateClient = require(ReplicatedStorage.ClientModules.PlayerStateClient);
local PlantLifecycleHandler = require(game.Players.LocalPlayer.PlayerScripts.Controllers.PlantLifecycleHandler);
local v1 = {
    StartOrder = 5
};
local u2 = 0;

for _, v in GearShopData.Data do
    if v.ItemName == "Common Watering Can" then
        u2 = v.Cost;
        break;
    end;
end;

local u3 = UDim2.fromScale(4, 4);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Click = SoundService.SFX.Click;
local u4 = {};
local u5 = nil;

for _, v in SeedData do
    u4[v.SeedName] = v;
end;

local u6 = nil;
local u7 = nil;
local u8 = 1;
local u9 = 0.25;
local u10 = nil;
local u11 = nil;

local function GetCharacterPosition() -- Line: 60
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function IsHoldingWateringCan() -- Line: 68
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return false;
    end;

    local v12 = Character:FindFirstChildWhichIsA("Tool");

    if typeof(v12) == "Instance" then
        return v12:GetAttribute("WateringCan") ~= nil;
    end;

    return false;
end;

local function HasSheckles() -- Line: 79
    -- upvalues: u5 (ref), u2 (ref)
    if u5 then
        return u2 < (u5.Data.Sheckles or 0);
    end;

    return false;
end;

local function HasWateringCanInStock() -- Line: 84
    -- upvalues: ReplicatedStorage (copy), GearShopData (copy)
    local StockValues = ReplicatedStorage:FindFirstChild("StockValues");

    if not StockValues then
        return false;
    end;

    local GearShop = StockValues:FindFirstChild("GearShop");

    if not GearShop then
        return false;
    end;

    local Items = GearShop:FindFirstChild("Items");

    if not Items then
        return false;
    end;

    for _, v in GearShopData.Data do
        if v.ItemType == "Watering Can" then
            local v13 = Items:FindFirstChild(v.ItemName);

            if v13 and v13.Value > 0 then
                return true;
            end;
        end;
    end;

    return false;
end;

local function HasEverWatered() -- Line: 99
    -- upvalues: u5 (ref)
    if u5 then
        return u5.Data.HasWateredPlants == true;
    end;

    return false;
end;

local function IsPlantDecaying(p14, p15) -- Line: 104
    -- upvalues: u4 (copy), PlantLifecycleHandler (copy)
    if not p14.PrimeStartedAt or p14.PrimeStartedAt <= 0 then
        return false;
    end;

    if p14.Mutation then
        return false;
    end;

    local v16 = u4[p14.SeedName];

    if not (v16 and v16.PrimeTime) then
        return false;
    end;

    if v16.AlwaysPrime then
        return false;
    end;

    local v17, v18 = string.match(p15, "^(%d+)_(.+)$");

    if not (v17 and v18) then
        return false;
    end;

    local v19 = PlantLifecycleHandler:GetDecayAlpha(tonumber(v17), v18);
    local v20;

    if v19 == nil then
        v20 = false;
    else
        v20 = v19 > 0.5;
    end;

    return v20;
end;

local function IsLocalPlayerPlant(p21) -- Line: 121
    -- upvalues: LocalPlayer (copy)
    local v22 = string.match(p21, "^(%d+)_");

    if v22 then
        return tonumber(v22) == LocalPlayer.UserId;
    end;

    return false;
end;

local function CreateBillboard(p23) -- Line: 127
    -- upvalues: u3 (copy), Click (copy), ReplicatedStorage (copy), PlayerGui (copy)
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "WaterRevivePrompt";
    BillboardGui.Size = u3;
    BillboardGui.StudsOffset = Vector3.new(0, 4, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.ResetOnSpawn = false;
    BillboardGui.Active = true;
    BillboardGui.Adornee = p23.PrimaryPart;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "ReviveButton";
    ImageButton.Image = "rbxassetid://119733290955630";
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.ImageTransparency = 1;
    ImageButton.Parent = BillboardGui;
    ImageButton.Activated:Connect(function() -- Line: 145
        -- upvalues: Click (ref), ReplicatedStorage (ref)
        Click.TimePosition = 0;
        Click.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Click:Play();
        local Notify = ReplicatedStorage:FindFirstChild("Notify");

        if Notify then
            Notify:Fire("Water this plant to revive it!");
        end;
    end);
    BillboardGui.Parent = PlayerGui;

    return BillboardGui;
end;

local function SetBillboardTransparency(p24, p25) -- Line: 160
    local ReviveButton = p24:FindFirstChild("ReviveButton");

    if ReviveButton then
        ReviveButton.ImageTransparency = p25;
    end;
end;

local function DestroyBillboard() -- Line: 167
    -- upvalues: u6 (ref), u7 (ref), u8 (ref)
    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    u7 = nil;
    u8 = 1;
end;

function v1.Init(p26) -- Line: 178
end;

function v1.Start(p27) -- Line: 181
    -- upvalues: u5 (ref), PlayerStateClient (copy), RunService (copy), LocalPlayer (copy), u6 (ref), u7 (ref), u8 (ref), u2 (ref), HasWateringCanInStock (copy), u9 (ref), PlantLifecycleHandler (copy), IsPlantDecaying (copy), u11 (ref), u10 (ref), CreateBillboard (copy)
    task.spawn(function() -- Line: 182
        -- upvalues: u5 (ref), PlayerStateClient (ref)
        u5 = PlayerStateClient:WaitForLocalReplica(30);
    end);
    RunService.Heartbeat:Connect(function(p28) -- Line: 186
        -- upvalues: u5 (ref), LocalPlayer (ref), u6 (ref), u7 (ref), u8 (ref), u2 (ref), HasWateringCanInStock (ref), u9 (ref), PlantLifecycleHandler (ref), IsPlantDecaying (ref), u11 (ref), u10 (ref), CreateBillboard (ref)
        if not u5 then
            return;
        end;

        if LocalPlayer:GetAttribute("SecondTimePlayer") ~= true then
            if u6 then
                u6:Destroy();
                u6 = nil;
            end;

            u7 = nil;
            u8 = 1;

            return;
        end;

        local v29;

        if u5 then
            v29 = u5.Data.HasWateredPlants == true;
        else
            v29 = false;
        end;

        if v29 then
            if u6 then
                u6:Destroy();
                u6 = nil;
            end;

            u7 = nil;
            u8 = 1;

            return;
        end;

        local v30;

        if u5 then
            v30 = u2 < (u5.Data.Sheckles or 0);
        else
            v30 = false;
        end;

        if not v30 then
            if u6 then
                u6:Destroy();
                u6 = nil;
            end;

            u7 = nil;
            u8 = 1;

            return;
        end;

        if not HasWateringCanInStock() then
            if u6 then
                u6:Destroy();
                u6 = nil;
            end;

            u7 = nil;
            u8 = 1;

            return;
        end;

        local Character = LocalPlayer.Character;
        local v31;

        if Character then
            local v32 = Character:FindFirstChildWhichIsA("Tool");

            if typeof(v32) == "Instance" then
                v31 = v32:GetAttribute("WateringCan") ~= nil;
            else
                v31 = false;
            end;
        else
            v31 = false;
        end;

        if v31 then
            if u6 then
                u8 = math.clamp(u8 + p28 * 3, 0, 1);
                local v33 = u8;
                local ReviveButton = u6:FindFirstChild("ReviveButton");

                if ReviveButton then
                    ReviveButton.ImageTransparency = v33;
                end;

                if u8 >= 1 then
                    if u6 then
                        u6:Destroy();
                        u6 = nil;
                    end;

                    u7 = nil;
                    u8 = 1;
                end;
            end;

            return;
        end;

        local Character2 = LocalPlayer.Character;
        local v34;

        if Character2 then
            local HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart then
                v34 = HumanoidRootPart.Position;
            else
                v34 = nil;
            end;
        else
            v34 = nil;
        end;

        if not v34 then
            if u6 then
                u6:Destroy();
                u6 = nil;
            end;

            u7 = nil;
            u8 = 1;

            return;
        end;

        u9 = u9 + p28;

        if u9 >= 0.25 then
            u9 = 0;
            local v35 = 30;
            local v36 = nil;
            local v37 = nil;

            for i, v in PlantLifecycleHandler:GetActiveEntries() do
                local v38 = string.match(i, "^(%d+)_");
                local v39;

                if v38 then
                    v39 = tonumber(v38) == LocalPlayer.UserId;
                else
                    v39 = false;
                end;

                if v39 then
                    local Model = v.Model;

                    if Model and Model.Parent then
                        local v40 = IsPlantDecaying(v, i);

                        if Model:GetAttribute("Decaying") ~= v40 then
                            Model:SetAttribute("Decaying", v40);
                        end;

                        if v40 and Model.PrimaryPart then
                            local Magnitude = (Model.PrimaryPart.Position - v34).Magnitude;

                            if Magnitude < v35 then
                                v37 = Model;
                                v36 = i;
                                v35 = Magnitude;
                            end;
                        end;
                    end;
                end;
            end;

            u11 = v36;
            u10 = v37;
        end;

        local v41 = u11;
        local v42 = u10;

        if v42 and not v42.Parent then
            v41 = nil;
            v42 = nil;
            u11 = nil;
            u10 = nil;
        end;

        if not (v42 and v41) then
            if u6 then
                u8 = math.clamp(u8 + p28 * 3, 0, 1);
                local v43 = u8;
                local ReviveButton = u6:FindFirstChild("ReviveButton");

                if ReviveButton then
                    ReviveButton.ImageTransparency = v43;
                end;

                if u8 >= 1 then
                    if u6 then
                        u6:Destroy();
                        u6 = nil;
                    end;

                    u7 = nil;
                    u8 = 1;
                end;
            end;

            return;
        end;

        if u7 ~= v42 then
            if u6 then
                u6:Destroy();
                u6 = nil;
            end;

            u7 = nil;
            u8 = 1;
            u6 = CreateBillboard(v42);
            u7 = v42;
            u8 = 1;
        end;

        u8 = math.clamp(u8 - p28 * 3, 0, 1);

        if u6 then
            local v44 = u8;
            local ReviveButton = u6:FindFirstChild("ReviveButton");

            if ReviveButton then
                ReviveButton.ImageTransparency = v44;
            end;
        end;
    end);
end;

return v1;