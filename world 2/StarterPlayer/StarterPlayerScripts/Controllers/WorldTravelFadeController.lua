-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local NotificationController = require(script.Parent.NotificationController);
local SfxController = require(script.Parent.SfxController);
local u1 = {
    StartOrder = 1
};
local u2 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u4 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = 0;
local u9 = nil;

local function stopCoverWatch() -- Line: 90
    -- upvalues: u9 (ref)
    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;
end;

local function build() -- Line: 97
    -- upvalues: u6 (ref), u7 (ref), LocalPlayer (copy), u4 (copy), u5 (ref)
    local v10 = u6;
    local v11 = u7;

    if v10 and (v10.Parent and v11) then
        return v10, v11;
    end;

    local v12 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v12 then
        return nil, nil;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "WorldTravelFade";
    ScreenGui.DisplayOrder = 10000;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Enabled = false;
    local Frame = Instance.new("Frame");
    Frame.Name = "Shade";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.new(0, 0, 0);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Active = true;
    Frame.Parent = ScreenGui;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Caption";
    TextLabel.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel.Position = UDim2.fromScale(0.5, 0.86);
    TextLabel.Size = UDim2.fromScale(0.8, 0.1);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = u4;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 1;
    TextLabel.Text = "";
    TextLabel.Parent = Frame;
    ScreenGui.Parent = v12;
    u5 = ScreenGui;
    u6 = Frame;
    u7 = TextLabel;

    return Frame, TextLabel;
end;

local function showShade(u13, p14) -- Line: 149
    -- upvalues: build (copy), u8 (ref), u5 (ref), TweenService (copy), u2 (copy)
    local v15, u16 = build();

    if not (v15 and u16) then
        return;
    end;

    if u8 ~= u13 then
        return;
    end;

    local u17 = p14 == "" and "Traveling" or `Traveling to {p14}`;
    task.spawn(function() -- Line: 163
        -- upvalues: u8 (ref), u13 (copy), u16 (copy), u17 (copy)
        local v18 = 1;

        while u8 == u13 and u16.Parent do
            u16.Text = u17 .. string.rep(".", v18) .. string.rep(" ", 3 - v18);
            v18 = v18 >= 3 and 1 or v18 + 1;
            task.wait(0.4);
        end;
    end);
    local v19 = u5;

    if v19 then
        v19.Enabled = true;
    end;

    TweenService:Create(v15, u2, {
        BackgroundTransparency = 0
    }):Play();
    TweenService:Create(u16, u2, {
        TextTransparency = 0
    }):Play();
end;

local function watchForCoverDrop(u20, u21) -- Line: 183
    -- upvalues: u9 (ref), LocalPlayer (copy), u8 (ref), showShade (copy)
    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u9 = LocalPlayer:GetAttributeChangedSignal("LoadingScreenCovering"):Connect(function() -- Line: 185
        -- upvalues: u8 (ref), u20 (copy), u9 (ref), LocalPlayer (ref), showShade (ref), u21 (copy)
        if u8 ~= u20 then
            if u9 then
                u9:Disconnect();
                u9 = nil;
            end;

            return;
        end;

        if LocalPlayer:GetAttribute("LoadingScreenCovering") == true then
            return;
        end;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        showShade(u20, u21);
    end);
end;

function u1.Begin(p22, u23, p24) -- Line: 200
    -- upvalues: u8 (ref), LocalPlayer (copy), SfxController (copy), u1 (copy), u9 (ref), showShade (copy)
    u8 = u8 + 1;
    local u25 = u8;
    LocalPlayer:SetAttribute("WorldTravelDestination", u23);

    if p24 and p24 ~= "" then
        SfxController:PlaySFX(p24);
    end;

    task.delay(20, function() -- Line: 215
        -- upvalues: u8 (ref), u25 (copy), u1 (ref)
        if u8 ~= u25 then
            return;
        end;

        u1:Clear("Teleport timed out, try again");
    end);

    if u23 == "" or LocalPlayer:GetAttribute("LoadingScreenCovering") ~= true then
        showShade(u25, u23);

        return;
    end;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u9 = LocalPlayer:GetAttributeChangedSignal("LoadingScreenCovering"):Connect(function() -- Line: 185
        -- upvalues: u8 (ref), u25 (copy), u9 (ref), LocalPlayer (ref), showShade (ref), u23 (copy)
        if u8 ~= u25 then
            if u9 then
                u9:Disconnect();
                u9 = nil;
            end;

            return;
        end;

        if LocalPlayer:GetAttribute("LoadingScreenCovering") == true then
            return;
        end;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        showShade(u25, u23);
    end);
end;

function u1.Clear(p26, p27) -- Line: 237
    -- upvalues: u8 (ref), u9 (ref), LocalPlayer (copy), u6 (ref), u7 (ref), TweenService (copy), u3 (copy), u5 (ref), NotificationController (copy)
    u8 = u8 + 1;
    local u28 = u8;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    LocalPlayer:SetAttribute("WorldTravelDestination", nil);
    local v29 = u6;
    local v30 = u7;

    if v29 and v30 then
        TweenService:Create(v29, u3, {
            BackgroundTransparency = 1
        }):Play();
        local v31 = TweenService:Create(v30, u3, {
            TextTransparency = 1
        });
        v31:Play();
        v31.Completed:Once(function() -- Line: 250
            -- upvalues: u8 (ref), u28 (copy), u5 (ref)
            if u8 ~= u28 then
                return;
            end;

            local v32 = u5;

            if v32 then
                v32.Enabled = false;
            end;
        end);
    end;

    if p27 and p27 ~= "" then
        NotificationController:CreateNotification(p27);
    end;
end;

function u1.Init(p33) -- Line: 267
    -- upvalues: Networking (copy), u1 (copy)
    Networking.Worlds.TravelStarted.OnClientEvent:Connect(function(p34, p35) -- Line: 270
        -- upvalues: u1 (ref)
        u1:Begin(p34, p35);
    end);
    Networking.Worlds.TravelFailed.OnClientEvent:Connect(function(p36) -- Line: 274
        -- upvalues: u1 (ref)
        u1:Clear(p36);
    end);
end;

function u1.Start(p37) -- Line: 279
end;

return u1;