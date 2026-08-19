-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local v1 = {};
local NotificationInstance = require(script.Parent.NotificationInstance);
local Functions = require(game.ReplicatedStorage.Library.Functions);
local ItemUI = require(game.ReplicatedStorage.Library.Client.UI.ItemUI);
local Audio = require(game.ReplicatedStorage.Library.Audio);
local Asserts = require(game.ReplicatedStorage.Library.Asserts);
local AddDebris = require(ReplicatedStorage.Library.Functions.AddDebris);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local Item2 = game.ReplicatedStorage.Assets.UI.Notifications.Bottom.Item2;
local Items = game.ReplicatedStorage.Assets.UI.Items;
local u2 = {};
local u3 = Functions.Debounce();

local function animateItemNotification(u4, u5) -- Line: 27
    -- upvalues: u3 (copy), Rarity (copy), Audio (copy), Functions (copy), AddDebris (copy), RunService (copy)
    u3(0.15, function() -- Line: 29
        -- upvalues: u5 (copy), Rarity (ref), Audio (ref)
        local Item = u5.Item;

        if Item and Item:GetRarity().RarityNumber >= Rarity.Rarities.Cosmic.RarityNumber then
            Audio.Play("rbxassetid://73352992887992", script, 1, 1);

            return;
        end;

        Audio.Play("rbxassetid://103957546380416", script, 1, 2);
    end);
    local v6 = nil;

    if v6 and tick() - v6 < 2 then
        return;
    end;

    tick();
    u4.Glow.ImageTransparency = 0;
    Functions.Tween(u4.Glow, {
        ImageTransparency = 1
    }, { 2, "Sine", "InOut" });
    u4.Glow.UIScale.Scale = 3;
    Functions.Tween(u4.Glow.UIScale, {
        Scale = 1
    }, { 2, "Expo", "Out" });
    local ImageTransparency = u4.Frame.ItemHolder.glow.ImageTransparency;
    u4.Frame.ItemHolder.glow.ImageTransparency = 1;
    Functions.Tween(u4.Frame.ItemHolder.glow, {
        ImageTransparency = ImageTransparency
    }, { 1.5, "Sine", "Out" });
    local Frame = u4:FindFirstChild("Frame");

    if not Frame then
        return;
    end;

    local function createItemEcho() -- Line: 65
        -- upvalues: u4 (copy), Frame (copy), Functions (ref), AddDebris (ref), RunService (ref)
        if not (u4 and Frame) then
            return;
        end;

        local AbsoluteSize = u4.Frame.ItemHolder.AbsoluteSize;
        local u7 = game.ReplicatedStorage.Assets.UI.OTHER.ItemEcho:Clone();
        u7.AnchorPoint = Vector2.new(0.5, 0.5);
        u7.ZIndex = 1;
        u7.BackgroundColor3 = Color3.new(1, 1, 1);
        u7.Size = UDim2.new(0, AbsoluteSize.X * 1.2, 0, AbsoluteSize.Y * 1.2);

        if not (u4 and Frame) then
            return;
        end;

        u7.Parent = u4.Frame:FindFirstAncestorOfClass("ScreenGui");
        local u8 = Functions.Tween(u7, {
            ImageTransparency = 1,
            Size = UDim2.new(0, AbsoluteSize.X * 2.2, 0, AbsoluteSize.Y * 2.2)
        }, { 0.4, "Sine", "Out" });
        u8.Completed:Connect(function() -- Line: 86
            -- upvalues: AddDebris (ref), u7 (copy)
            AddDebris(u7);
        end);
        task.spawn(function() -- Line: 90
            -- upvalues: u4 (ref), u7 (copy), Frame (ref), u8 (copy), RunService (ref)
            local AbsolutePosition = u4.Frame.ItemHolder.AbsolutePosition;
            local AbsoluteSize2 = u4.Frame.ItemHolder.AbsoluteSize;

            while u7 and u7.Parent do
                if not (u4 and Frame) then
                    u8:Cancel();

                    return;
                end;

                if u4 and u4.Parent then
                    AbsolutePosition = u4.Frame.ItemHolder.AbsolutePosition;
                    AbsoluteSize2 = u4.Frame.ItemHolder.AbsoluteSize;
                end;

                u7.Position = UDim2.new(0, AbsolutePosition.X + AbsoluteSize2.X / 2, 0, AbsolutePosition.Y + AbsoluteSize2.Y / 2 * 1.75);
                RunService.RenderStepped:Wait();
            end;
        end);
    end;

    local u9 = nil;
    Frame.Destroying:Once(function() -- Line: 118
        -- upvalues: u9 (ref)
        if not u9 then
            return;
        end;

        task.cancel(u9);
    end);
    u9 = task.spawn(function() -- Line: 126
        -- upvalues: createItemEcho (copy), u4 (copy), Frame (copy)
        task.wait(0.1);
        createItemEcho();
        task.wait(0.1);
        createItemEcho();
        task.wait(0.1);
        createItemEcho();
        task.wait(0.1);
        task.wait(1);

        if not (u4 and Frame) then
            return;
        end;

        createItemEcho();
    end);
end;

local function createEntry(p10) -- Line: 145
    -- upvalues: Item2 (copy), Items (copy), ReplicatedStorage (copy), ItemUI (copy), Functions (copy)
    local Item = p10.Item;
    local v11 = p10.RarityOverride or Item:GetRarity();
    local v12 = Item:IsA("PowerUp");
    local v13 = Item2.Entry:Clone();
    v13.Frame.ItemHolder:FindFirstChild("Item"):Destroy();
    v13.Frame.ItemHolder:FindFirstChildOfClass("UIGradient"):Destroy();
    v13.Frame.ItemHolder.glow:FindFirstChildOfClass("UIGradient"):Destroy();
    v13.TextLabel.Text = v12 and "NEW POWER UP!" or (Item:GetAmount() > 1 and "New Items!" or "New Item!");
    v13.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    (v12 and Items.NewPowerUp or Items.NewItem):Clone().Parent = v13.TextLabel;

    if v12 then
        v13.TextLabel.Size = UDim2.fromScale(2, 0.275);
        v13.TextLabel.FontFace = Font.fromEnum(Enum.Font.LuckiestGuy);
        v13.TextLabel.FontFace.Weight = Enum.FontWeight.Bold;
    end;

    local Gradient = v11.Gradient;
    local v14;

    if v11.DisplayName == "Basic" then
        Gradient = ReplicatedStorage.Assets.UI.Gradients.LightGreyGradient;
        v14 = true;
    else
        v14 = false;
    end;

    local v15 = {
        NoActionMenu = true,
        HideQuantity = false,
        HideStrength = true,
        NoButtonFX = true,
        ShowCurrencyBag = true,
        NoLoadingAnimation = true,
        NoScribble = v14
    };

    if Item:GetAmount() == 1 and not Item:IsA("Currency") then
        v15.HideQuantity = true;
    end;

    local v16 = ItemUI.Create(Item, v15);
    Instance.new("UIAspectRatioConstraint").Parent = v16;
    v16.Size = UDim2.new(1, 0, 1, 0);
    v16.Parent = v13.Frame.ItemHolder;
    Gradient:Clone().Parent = v13.Frame.ItemHolder;
    Gradient:Clone().Parent = v13.Frame.ItemHolder.coreImage;
    Gradient:Clone().Parent = v13.Frame.ItemHolder.glow;
    local UIScale = Instance.new("UIScale");
    UIScale.Scale = 1.35;
    UIScale.Parent = v13;
    v13.AnchorPoint = Vector2.new(0.5, 0.5);
    Functions.Tween(UIScale, {
        Scale = 1
    }, { 0.35, "Back", "Out" });

    return v13;
end;

local function processBottomQueue() -- Line: 210
    -- upvalues: u2 (copy), Item2 (copy), createEntry (copy), Functions (copy), animateItemNotification (copy), NotificationInstance (copy)
    local v17 = math.min(4, #u2);
    local v18 = Item2:Clone();
    v18.Entry:Destroy();
    local u19 = {};
    local v20 = nil;
    local v21 = false;

    for _ = 1, v17 do
        local v22 = u2[1];
        table.remove(u2, 1);
        local v23 = createEntry(v22.config);
        v23.Parent = v18;
        table.insert(u19, {
            frame = v23,
            config = v22.config
        });

        if v22.superConfig and (v22.superConfig.Time and (not v20 or v22.superConfig.Time < 0)) then
            v20 = v22.superConfig;
        end;

        if v22.superConfig and v22.superConfig.Force then
            v20 = v22.superConfig;
            v21 = true;
        end;
    end;

    if v20 then
        v20 = Functions.DeepCopyUnsafe(v20);
        v20.Force = v21;
    end;

    NotificationInstance.new(NotificationInstance.Locations.Bottom, v18, function() -- Line: 245, Name: triggerAnimations
        -- upvalues: u19 (copy), animateItemNotification (ref)
        for _, v in ipairs(u19) do
            animateItemNotification(v.frame, v.config);
        end;
    end, v20);
end;

function v1.pushToFrame(p24, p25) -- Line: 254
    -- upvalues: createEntry (copy), animateItemNotification (copy)
    local v26 = createEntry(p24.config);
    p25.created = tick();
    v26.Parent = p25.frame;
    animateItemNotification(v26, p24.config);
end;

local function tryAppendToBottom(p27) -- Line: 264
    -- upvalues: NotificationInstance (copy), createEntry (copy), animateItemNotification (copy)
    local v28 = NotificationInstance.GetBottomRenders();
    local v29 = {};

    for _, v in ipairs(v28) do
        if v.created and not v.tweening then
            table.insert(v29, {
                data = v,
                sort = v.created
            });
        end;
    end;

    table.sort(v29, function(p30, p31) -- Line: 274
        return p30.sort < p31.sort;
    end);

    for _, v in ipairs(v29) do
        local data = v.data;

        if data.frame.Name == "Item2" then
            local v32 = 0;

            for _, child in ipairs(data.frame:GetChildren()) do
                if child:IsA("GuiObject") then
                    v32 = v32 + 1;
                end;
            end;

            if v32 < 4 then
                data.created = tick();
                local v33 = createEntry(p27.config);
                v33.Parent = data.frame;
                animateItemNotification(v33, p27.config);

                return true;
            end;
        end;
    end;

    return false;
end;

function v1.Bottom(p34, p35) -- Line: 300
    -- upvalues: Asserts (copy), tryAppendToBottom (copy), u2 (copy)
    Asserts.table(p34);
    Asserts.table(p34.Item);
    local v36 = {
        config = p34,
        superConfig = p35
    };

    if not tryAppendToBottom(v36) and #u2 < 16 then
        table.insert(u2, v36);
    end;

    return nil;
end;

task.spawn(function() -- Line: 316
    -- upvalues: u2 (copy), processBottomQueue (copy)
    while true do
        while #u2 ~= 0 do
            processBottomQueue();
            task.wait(0.25);
        end;

        task.wait();
    end;
end);

return v1;