-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local TextChatService = game:GetService("TextChatService");
local UserInputService = game:GetService("UserInputService");
game:GetService("TextService");
local CollectionService = game:GetService("CollectionService");
local Info = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info");
require(Info:WaitForChild("CustomEnum"));
require(Info:WaitForChild("Images"));
local Knit = require(ReplicatedStorage.Packages.Knit);
local v1 = Knit.CreateController({
    Name = "NotificationController"
});
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;

local function notificationComponent(p7) -- Line: 36
    -- upvalues: TweenService (copy), Debris (copy)
    local Frame = Instance.new("Frame");
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 0);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "BG";
    ImageLabel.Image = "rbxassetid://86079325127942";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.ImageTransparency = 0.65;
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Rotation = 0;
    ImageLabel.ImageColor3 = Color3.fromRGB(0, 0, 0);
    ImageLabel.Size = UDim2.fromScale(0, 1);
    ImageLabel.ZIndex = 4;
    ImageLabel.Parent = Frame;

    if p7 ~= nil then
        ImageLabel.Visible = false;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Name = "label";
    TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0);
    TextLabel.TextScaled = true;
    TextLabel.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.Text = "";

    if p7 == nil then
        TextLabel.FontFace = Font.fromName("ComicNeueAngular", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        TextLabel.Size = UDim2.fromScale(0.05, 1);
    else
        TextLabel.FontFace = Font.fromName("ComicNeueAngular", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        TextLabel.Size = UDim2.fromScale(1, 1);
        TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
        TextLabel.TextStrokeTransparency = 0;
    end;

    TextLabel.ZIndex = 7;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 2;
    UIStroke.Parent = TextLabel;
    TextLabel.Parent = Frame;
    local u8 = TweenInfo.new(0.2, Enum.EasingStyle.Sine);

    return Frame, function(p9) -- Line: 87, Name: onAppear
        -- upvalues: TweenService (ref), Frame (copy), u8 (copy), Debris (ref)
        local v10 = {
            Size = UDim2.fromScale(1, 0.9)
        };
        local v11 = TweenService:Create(Frame, u8, p9 ~= nil and {
            Size = UDim2.fromScale(1, 0.2)
        } or v10);
        v11:Play();
        Debris:AddItem(v11, 2);
    end, function() -- Line: 97, Name: destroy
        -- upvalues: TweenService (ref), TextLabel (copy), u8 (copy), ImageLabel (copy), Debris (ref)
        local v12 = TweenService:Create(TextLabel, u8, {
            TextTransparency = 1
        });
        local v13 = TweenService:Create(TextLabel.UIStroke, u8, {
            Transparency = 1
        });
        local v14 = TweenService:Create(ImageLabel, u8, {
            ImageTransparency = 1
        });
        v12:Play();
        v13:Play();
        v14:Play();
        Debris:AddItem(v12, 1);
        Debris:AddItem(v13, 1);
        Debris:AddItem(v14, 1);
    end;
end;

function v1.SendNotification(p15, p16, p17, p18, p19, p20, p21, p22, p23) -- Line: 115
    -- upvalues: u3 (ref), Knit (copy), notificationComponent (copy), u5 (ref), u6 (ref), Debris (copy)
    while u3:FindFirstChild("LoadScreen") do
        task.wait(0.5);
    end;

    while Knit.GetController("WormRollController"):GetOngoing() do
        task.wait(0.5);
    end;

    if p19 == false then
        p19 = nil;
    end;

    local v24 = p19 == nil and 4 or 2;
    local v25, v26, v27 = notificationComponent(p19);
    v25.label.TextColor3 = p18 or Color3.new(0, 255, 0);
    v25.label.RichText = p23 == true;
    v25.label.Text = p16;

    if p19 == nil then
        v25.Parent = u5;
        v25.LayoutOrder = 0;

        for _, child in pairs(u5:GetChildren()) do
            if child ~= v25 and child:IsA("Frame") then
                child.LayoutOrder = (child.LayoutOrder or 1) + 1;
            end;
        end;

        if p21 == true then
            p15.UI_Manager:AddEmitterTemplate(u5, UDim2.new(0.5, 0, 0.5, 0), p15.UI_Manager.PARTICLE_TEMPLATES.SCRAP_BURST, {
                zIndex = 2,
                amt = p22,
                size = NumberRange.new(40, 50)
            });
        end;
    else
        v25.Parent = u6;
        v25.LayoutOrder = 0;

        for _, child in pairs(u6:GetChildren()) do
            if child ~= v25 and child:IsA("Frame") then
                child.LayoutOrder = (child.LayoutOrder or 1) + 1;
            end;
        end;
    end;

    v25.Visible = false;
    v25.Size = UDim2.fromScale(1, 0.9);
    v25.BG.Size = UDim2.new(0, math.floor(v25.label.AbsoluteSize.X) + 80, 1.5, 0);
    v25.BG.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    v25.Size = UDim2.fromScale(1, 0);
    v25.Visible = true;
    v26(p19);
    task.delay(v24, v27);
    Debris:AddItem(v25, v24 + 0.2);
end;

function v1.SendSpecialSeedNotification(p28, p29, p30, p31) -- Line: 200
    -- upvalues: u3 (ref), Knit (copy), CollectionService (copy), TweenService (copy), Debris (copy), u5 (ref)
    while u3:FindFirstChild("LoadScreen") do
        task.wait(0.5);
    end;

    while Knit.GetController("WormRollController"):GetOngoing() do
        task.wait(0.5);
    end;

    local u32 = p28.specialSeedDisplayTemplate:Clone();
    u32.TextElements.SeedName:SetAttribute("rarity", p30);
    CollectionService:AddTag(u32.TextElements.SeedName, "ShinyTextLabel");
    local u33 = TweenInfo.new(0.2, Enum.EasingStyle.Sine);

    local function v35() -- Line: 219
        -- upvalues: TweenService (ref), u32 (copy), u33 (copy), Debris (ref)
        local v34 = TweenService:Create(u32, u33, {
            Size = UDim2.fromScale(1, 0.9)
        });
        v34:Play();
        Debris:AddItem(v34, 2);
    end;

    local function v43() -- Line: 227
        -- upvalues: TweenService (ref), u32 (copy), u33 (copy), Debris (ref)
        local v36 = TweenService:Create(u32.TextElements.Beginning, u33, {
            TextTransparency = 1
        });
        local v37 = TweenService:Create(u32.TextElements.Beginning.UIStroke, u33, {
            Transparency = 1
        });
        local v38 = TweenService:Create(u32.TextElements.SeedName, u33, {
            TextTransparency = 1
        });
        local v39 = TweenService:Create(u32.TextElements.SeedName.UIStroke, u33, {
            Transparency = 1
        });
        local v40 = TweenService:Create(u32.TextElements.Ending, u33, {
            TextTransparency = 1
        });
        local v41 = TweenService:Create(u32.TextElements.Ending.UIStroke, u33, {
            Transparency = 1
        });
        local v42 = TweenService:Create(u32.BG, u33, {
            ImageTransparency = 1
        });
        v36:Play();
        v38:Play();
        v40:Play();
        v37:Play();
        v39:Play();
        v41:Play();
        v42:Play();
        Debris:AddItem(v36, 1);
        Debris:AddItem(v38, 1);
        Debris:AddItem(v40, 1);
        Debris:AddItem(v37, 1);
        Debris:AddItem(v39, 1);
        Debris:AddItem(v41, 1);
        Debris:AddItem(v42, 1);
    end;

    u32.TextElements.SeedName.Text = p29 .. " Seed";
    u32.TextElements.Ending.Text = " has spawned!";
    u32.Parent = u5;
    u32.Size = UDim2.fromScale(1, 0.9);
    local v44 = u32.TextElements.Beginning.AbsoluteSize.X + u32.TextElements.SeedName.AbsoluteSize.X + u32.TextElements.Ending.AbsoluteSize.X;
    local X = u32.TextElements.AbsoluteSize.X;
    u32.TextElements.AnchorPoint = Vector2.new(0.5, 0.5);
    u32.TextElements.Position = UDim2.new(0.5, -(v44 / 2) + X / 2, 0.5, 0);
    u32.Size = UDim2.fromScale(1, 0);
    u32.LayoutOrder = 0;

    for _, child in pairs(u5:GetChildren()) do
        if child ~= u32 and child:IsA("Frame") then
            child.LayoutOrder = (child.LayoutOrder or 1) + 1;
        end;
    end;

    u32.Visible = true;
    v35();
    task.delay(p31, v43);
    Debris:AddItem(u32, p31 + 0.2);
end;

function v1.SendChatNotification(p45, p46) -- Line: 297
    -- upvalues: TextChatService (copy)
    TextChatService.TextChannels.RBXSystem:DisplaySystemMessage((`[Server]: {p46}`));
end;

function v1.KnitStart(u47) -- Line: 302
    -- upvalues: u2 (ref), Knit (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref), UserInputService (copy)
    u2 = Knit.GetService("NotificationService");
    u3 = game.Players.LocalPlayer:WaitForChild("PlayerGui");
    u4 = u3:WaitForChild("Other");
    u5 = u4:WaitForChild("Notifications");
    u6 = u4:WaitForChild("Feedback");
    u47.specialSeedDisplayTemplate = u5:WaitForChild("SpecialSeedDisplay");
    u47.specialSeedDisplayTemplate.Parent = script;
    u47.UI_Manager = Knit.GetController("UI_Manager");
    u2.SendNotification:Connect(function(p48, p49, p50, p51, p52, p53) -- Line: 315
        -- upvalues: u47 (copy)
        u47:SendNotification(p48, p49, p50, p51, p52, nil, nil, p53);
    end);
    u2.SendSpecialSeedNotification:Connect(function(p54, p55, p56) -- Line: 320
        -- upvalues: u47 (copy)
        u47:SendSpecialSeedNotification(p54, p55, p56);
    end);
    u2.SendChatNotification:Connect(function(...) -- Line: 324
        -- upvalues: u47 (copy)
        u47:SendChatNotification(...);
    end);
    UserInputService.InputBegan:Connect(function(p57, p58) -- Line: 329
        -- upvalues: u47 (copy)
        if p58 then
            return;
        end;

        if p57.KeyCode == Enum.KeyCode.L then
            u47:SendNotification("Sample notification triggered!", 3, Color3.fromRGB(255, 255, 0));
        end;
    end);
end;

return v1;