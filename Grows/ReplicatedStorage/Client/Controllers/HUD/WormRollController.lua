-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local ContentProvider = game:GetService("ContentProvider");
game:GetService("Players");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Shared = ReplicatedStorage:WaitForChild("Shared");
local Info = Shared:WaitForChild("Info");
local Utility = Shared:WaitForChild("Utility");
local Client = ReplicatedStorage:WaitForChild("Client");
Client:WaitForChild("Modules"):WaitForChild("Utility");
Client:WaitForChild("Components");
local Knit = require(Packages:WaitForChild("Knit"));
local Signal = require(Packages:WaitForChild("Signal"));
local Maid = require(Packages:WaitForChild("Maid"));
local Constants = require(Info:WaitForChild("Constants"));
require(Info:WaitForChild("CustomEnum"));
local WormConfig = require(Info:WaitForChild("WormConfig"));
local MutationConfig = require(Info:WaitForChild("MutationConfig"));
local RollWeighted = require(Utility:WaitForChild("RollWeighted"));
local v1 = Knit.CreateController({
    Name = "WormRollController",
    RollOpened = Signal.new(),
    RollClosed = Signal.new()
});
local MysteryRoll = game.Players.LocalPlayer.PlayerGui:WaitForChild("HUD"):WaitForChild("TopButtons"):WaitForChild("Center"):WaitForChild("MysteryRoll");
local MysteryIconBox = MysteryRoll:WaitForChild("MysteryIconBox");
local Icon = MysteryIconBox:WaitForChild("Icon");
Icon.Visible = false;
v1.ICON_DEFAULT_SIZE = Icon.Size;
local Title = MysteryIconBox:WaitForChild("Title");
local FertilizersAdded = MysteryIconBox:WaitForChild("FertilizersAdded");
v1.IMAGES_TO_SHOW = 20;
v1.ICON_SIZE_SMALL = MysteryIconBox.Size;
v1.ICON_SIZE_LARGE = UDim2.fromScale(1, 1);
v1.ZOOM_TWEEN_TIME = 0.2;
v1.ICON_ZOOM_ELASTIC = TweenInfo.new(v1.ZOOM_TWEEN_TIME, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
v1.ICON_ZOOM_SMOOTH = TweenInfo.new(v1.ZOOM_TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = {};
local u3 = {};
local u4 = false;
local u5 = false;
local u6 = Random.new();

local function gcd(p7, p8) -- Line: 72
    -- upvalues: gcd (copy)
    if p8 == 0 then
        return p7;
    end;

    return gcd(p8, p7 % p8);
end;

function v1.easeOutSineCustom(p9, p10) -- Line: 78
    return math.sin(p10 * 0.8444 * 3.141592653589793 / 2) / 0.9702788345770148;
end;

function v1.GetOngoing(p11) -- Line: 84
    -- upvalues: u5 (ref)
    return u5;
end;

function v1.GetItemDisplayData(p12, p13, p14, p15) -- Line: 89
    -- upvalues: WormConfig (copy), MutationConfig (copy)
    local v16 = WormConfig.Worms[p13.id];
    local v17 = WormConfig.AdjustedWormTable[p13.id];
    local v18;

    if v16.mutation then
        v18 = MutationConfig.Get(v16.mutation).textColor;
    else
        v18 = Color3.new(1, 1, 1);
    end;

    local v19 = p14 == nil and "" or "Lucky ";

    if not p15 then
        return {
            id = p13.id,
            image = v16.image,
            name = v19 .. v16.displayName,
            color = v18,
            mult = p14
        };
    end;

    local v20 = math.round(100 / (p15 / v17.weight) * 100) / 100;

    return {
        id = p13.id,
        image = v16.image,
        name = v19 .. v16.displayName,
        color = v18,
        mult = p14,
        chanceText = v20 .. "% chance"
    };
end;

function v1.computeNextItemQue(p21) -- Line: 135
    -- upvalues: WormConfig (copy), RollWeighted (copy), u6 (copy)
    local AdjustedWormTable = WormConfig.AdjustedWormTable;
    local v22 = RollWeighted:totalWeight(AdjustedWormTable);
    local v23 = nil;
    local v24 = {};

    for _ = 1, p21.IMAGES_TO_SHOW do
        local v25, v26;

        repeat
            v26, v25 = RollWeighted:Roll(AdjustedWormTable);
        until v25 ~= v23;

        local v27 = WormConfig.RollLucky(v26.id, u6);

        if v27 then
            v26.mult = v27;
        end;

        local v28 = p21:GetItemDisplayData(v26, v27, v22);
        table.insert(v24, v28);
        v23 = v25;
    end;

    return v24;
end;

function v1.PreloadItemImages(p29) -- Line: 171
    -- upvalues: WormConfig (copy), u2 (copy), Icon (copy), MysteryIconBox (copy), ContentProvider (copy)
    local v30 = {};

    for i, v in WormConfig.Worms do
        u2[i] = {
            image = Icon:Clone()
        };
        u2[i].image.Parent = MysteryIconBox;
        u2[i].image.Image = v.icon;
        table.insert(v30, u2[i].image);
    end;

    ContentProvider:PreloadAsync(v30);
end;

local u31 = {
    hideChances = false,
    hideEndingItem = false
};

function v1.SetupRoll(u32, u33, u34, p35) -- Line: 189
    -- upvalues: Maid (copy), u31 (copy), u2 (copy), TweenService (copy), MysteryIconBox (copy), Title (copy), FertilizersAdded (copy), MysteryRoll (copy), Constants (copy)
    local v36 = Maid.new();
    local u37 = p35 or {};

    for i, v in u31 do
        if not u37[i] then
            u37[i] = v;
        end;
    end;

    local NumberValue = Instance.new("NumberValue");
    NumberValue.Parent = script;
    NumberValue.Value = 0;
    v36:GiveTask(function() -- Line: 204
        -- upvalues: NumberValue (copy)
        if NumberValue then
            NumberValue:Destroy();
        end;
    end);
    local u38 = nil;
    local u39 = 0;
    local u40 = nil;

    local function updateImage() -- Line: 212
        -- upvalues: u32 (copy), NumberValue (copy), u33 (copy), u39 (ref), u37 (ref), u34 (copy), u2 (ref), TweenService (ref), MysteryIconBox (ref), u40 (ref), u38 (ref), Title (ref), FertilizersAdded (ref)
        local v41 = u32:easeOutSineCustom(NumberValue.Value);
        local v42 = math.floor(#u33 * v41) + 1;

        if v42 ~= u39 then
            local v43 = #u33 < v42;
            local v44 = nil;

            if v43 then
                if u37.hideEndingItem ~= true then
                    v44 = u34;
                    local image = u2[u34.id].image;
                    TweenService:Create(MysteryIconBox, u32.ICON_ZOOM_SMOOTH, {
                        Size = u32.ICON_SIZE_LARGE
                    }):Play();
                    u32.UI_Manager:AddShineV3(image, 2, Color3.new(1, 1, 1));
                    u40 = u32.UI_Manager:AddEmitterTemplate(image, UDim2.new(0.5, 0, 0.5, 0), u32.UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
                        zIndex = 1,
                        em_delay = 0.3
                    });
                end;

                u32.SoundController:PlaySound("WormReveal");
            else
                v44 = u33[v42];
            end;

            if u38 and u2[u38] then
                u2[u38].image.Visible = false;
                u2[v44.id].image.LuckyIcon.Visible = false;
            end;

            if v44 then
                u38 = v44.id;
                u2[v44.id].image.Visible = true;

                if u2[v44.id].zoomTween then
                    u2[v44.id].zoomTween:Cancel();
                end;

                u2[v44.id].image.Size = UDim2.fromScale(0, 0);
                u2[v44.id].zoomTween = TweenService:Create(u2[v44.id].image, u32.ICON_ZOOM_ELASTIC, {
                    Size = u32.ICON_DEFAULT_SIZE
                });
                u2[v44.id].zoomTween:Play();

                if v43 then
                    Title.Text = v44.name;
                    Title.RainbowGradient.Enabled = v44.mult ~= nil;

                    if v44.mult == nil then
                        Title.TextColor3 = v44.color;
                    else
                        Title.TextColor3 = Color3.new(1, 1, 1);
                    end;

                    FertilizersAdded.Visible = true;
                else
                    Title.Text = "";
                    Title.RainbowGradient.Enabled = false;
                    Title.TextColor3 = Color3.new(1, 1, 1);
                    FertilizersAdded.Visible = false;
                end;

                u2[v44.id].image.LuckyIcon.Visible = v44.mult ~= nil;
            else
                Title.Visible = false;
            end;
        end;

        u39 = v42;
    end;

    NumberValue.Value = 0;
    v36:GiveTask(NumberValue.Changed:Connect(updateImage));
    updateImage();
    MysteryIconBox.Size = u32.ICON_SIZE_SMALL;
    Title.Visible = true;
    v36:GiveTask(function() -- Line: 312
        -- upvalues: u2 (ref), u38 (ref), MysteryRoll (ref), u32 (copy), u34 (copy), u40 (ref)
        u2[u38].image.Visible = false;
        MysteryRoll.Visible = false;
        u32.RollClosed:Fire();
        u32.UI_Manager:RemoveShineV3(u2[u34.id].image);
        u32.UI_Manager:RemoveEmitter(u40);
    end);
    MysteryRoll.Visible = true;
    u32.RollOpened:Fire();
    TweenService:Create(NumberValue, TweenInfo.new(Constants.CRATE_ROLL_TIME, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Value = 1
    }):Play();
    u32.SoundController:PlaySound("WormOpen");
    u32.SoundController:PlaySound("WormTickFull");

    return v36;
end;

function v1.RollEndProcess(p45) -- Line: 340
    -- upvalues: u3 (copy), u4 (ref), u5 (ref)
    if #u3 <= 0 then
        u4 = false;
        u5 = false;

        return;
    end;

    local v46 = table.remove(u3, 1);
    u4 = false;
    p45:PlayWormRollAnim(v46[1], true);
end;

function v1.PlayWormRollAnim(p47, p48, p49) -- Line: 352
    -- upvalues: u4 (ref), u3 (copy), u5 (ref), WormConfig (copy), RollWeighted (copy), Constants (copy)
    while p47.DataClient.currentData == nil do
        task.wait();
    end;

    if u4 then
        table.insert(u3, { p48 });

        return;
    end;

    u4 = true;

    if not p49 then
        u5 = true;
        p47.UI_Manager:CloseOpenWindowsQuick();
    end;

    local v50 = p47:computeNextItemQue();
    print("ITEM REWARD QUE ", v50);
    local v51 = RollWeighted:totalWeight(WormConfig.AdjustedWormTable);
    local v52 = WormConfig.Worms[p48.wormType];
    print("WIN ", v52, p48);
    local v53 = p47:SetupRoll(v50, p47:GetItemDisplayData(v52, p48.mult, v51), {});
    task.wait(Constants.CRATE_ROLL_TIME);
    task.wait(2.5);
    v53:Destroy();
    p47:RollEndProcess();
end;

function v1.KnitStart(u54) -- Line: 408
    u54:PreloadItemImages();
    u54.WormService.WormGranted:Connect(function(p55) -- Line: 412
        -- upvalues: u54 (copy)
        u54:PlayWormRollAnim(p55, false);
    end);
end;

function v1.KnitInit(p56) -- Line: 418
    -- upvalues: Knit (copy)
    p56.DataClient = Knit.GetController("DataClient");
    p56.UI_Manager = Knit.GetController("UI_Manager");
    p56.SoundController = Knit.GetController("SoundController");
    p56.NotificationController = Knit.GetController("NotificationController");
    p56.WormService = Knit.GetService("WormService");
end;

return v1;