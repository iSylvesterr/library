-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    Werewolf = "Werewolf 🐺",
    Defender = "Defender 🛡️"
};
local u3 = {
    Werewolf = Color3.fromRGB(255, 60, 60),
    Defender = Color3.fromRGB(70, 220, 90)
};
local u4 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
local u5 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u6 = { "WerewolfGrowl1", "WerewolfGrowl2", "WerewolfGrowl3" };
local u7 = nil;
local u8 = nil;

local function destroyActive() -- Line: 61
    -- upvalues: u8 (ref), u7 (ref)
    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u7 then
        u7:Destroy();
        u7 = nil;
    end;
end;

local u9 = {};

local function getWerewolfSound(p10) -- Line: 74
    -- upvalues: SoundService (copy), u9 (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if not SFX then
        return nil;
    end;

    local Werewolf = SFX:FindFirstChild("Werewolf");

    if Werewolf then
        Werewolf = Werewolf:FindFirstChild(p10);
    end;

    if Werewolf and Werewolf:IsA("Sound") then
        return Werewolf;
    end;

    for _, descendant in SFX:GetDescendants() do
        if descendant:IsA("Sound") and descendant.Name == p10 then
            return descendant;
        end;
    end;

    if not u9[p10] then
        u9[p10] = true;
        warn((`[WerewolfRoleReveal] missing sound "{p10}" -- expected SoundService.SFX.Werewolf.{p10}`));
    end;

    return nil;
end;

local function playSound2D(p11) -- Line: 105
    -- upvalues: getWerewolfSound (copy), SoundService (copy)
    local v12 = getWerewolfSound(p11);

    if not v12 then
        return;
    end;

    local u13 = v12:Clone();
    u13.Looped = false;
    u13.Parent = SoundService;
    u13:Play();
    u13.Ended:Once(function() -- Line: 114
        -- upvalues: u13 (copy)
        u13:Destroy();
    end);
end;

local function makeRow(p14, p15, p16) -- Line: 119
    -- upvalues: u4 (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.BackgroundTransparency = 1;
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.Size = UDim2.new(1, 0, 0, 96);
    TextLabel.FontFace = u4;
    TextLabel.Text = p14;
    TextLabel.TextColor3 = p15;
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0);
    TextLabel.TextStrokeTransparency = 0;
    TextLabel.Visible = false;
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint.MaxTextSize = 64;
    UITextSizeConstraint.Parent = TextLabel;
    TextLabel.Parent = p16;

    return TextLabel;
end;

local function buildRoles(p17) -- Line: 142
    local v18 = table.create(24);
    local v19 = p17 == "Werewolf" and "Defender" or "Werewolf";

    for i = 1, 23 do
        local v20;

        if i % 2 == 1 then
            v20 = v19;
        else
            v20 = p17;
        end;

        v18[i] = v20;
    end;

    v18[24] = p17;

    return v18;
end;

local function play(u21, p22, u23) -- Line: 152
    -- upvalues: u8 (ref), u7 (ref), LocalPlayer (copy), buildRoles (copy), makeRow (copy), u2 (copy), u3 (copy), getWerewolfSound (copy), playSound2D (copy), u6 (copy), TweenService (copy), u5 (copy), RunService (copy)
    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u7 then
        u7:Destroy();
        u7 = nil;
    end;

    local v24 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v24 then
        return;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "WerewolfRoleReveal";
    ScreenGui.DisplayOrder = 500;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Enabled = true;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Window";
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.new(0.7, 0, 0, 211);
    CanvasGroup.ClipsDescendants = true;
    CanvasGroup.GroupTransparency = 0;
    CanvasGroup.Parent = ScreenGui;
    local v25 = buildRoles(u21);
    local u26 = table.create(24);

    for i, v in v25 do
        u26[i] = makeRow(u2[v], u3[v], CanvasGroup);
    end;

    ScreenGui.Parent = v24;
    u7 = ScreenGui;
    local u27 = 0;
    local v28;

    if p22 then
        v28 = getWerewolfSound("RoleTick");
    else
        v28 = nil;
    end;

    local u29;

    if v28 then
        u29 = v28:Clone();
        u29.Looped = false;
        u29.Parent = ScreenGui;
    else
        u29 = nil;
    end;

    local u30 = 0;

    local function render(p31) -- Line: 212
        -- upvalues: u26 (copy)
        for i, v in u26 do
            local v32 = p31 - (i - 1);
            local v33 = math.abs(v32);

            if v33 > 1.15 then
                v.Visible = false;
            else
                v.Visible = true;
                v.Position = UDim2.new(0.5, 0, 0.5, (math.round(v32 * 96)));
                local v34 = math.clamp(v33 / 1.15, 0, 1);
                v.TextTransparency = v34;
                v.TextStrokeTransparency = v34;
            end;
        end;
    end;

    local function finish() -- Line: 228
        -- upvalues: u8 (ref), u26 (copy), u21 (copy), playSound2D (ref), u6 (ref), u23 (copy), u7 (ref), ScreenGui (copy), TweenService (ref), CanvasGroup (copy), u5 (ref)
        if u8 then
            u8:Disconnect();
            u8 = nil;
        end;

        for i, v in u26 do
            if i == 24 then
                v.Visible = true;
                v.Position = UDim2.new(0.5, 0, 0.5, 0);
                v.TextTransparency = 0;
                v.TextStrokeTransparency = 0;
            else
                v.Visible = false;
            end;
        end;

        if u21 == "Werewolf" then
            playSound2D(u6[math.random(#u6)]);
        else
            playSound2D("Defend");
        end;

        task.delay(u23, function() -- Line: 253
            -- upvalues: u7 (ref), ScreenGui (ref), TweenService (ref), CanvasGroup (ref), u5 (ref)
            if u7 ~= ScreenGui then
                return;
            end;

            local u35 = TweenService:Create(CanvasGroup, u5, {
                GroupTransparency = 1
            });
            u35.Completed:Once(function() -- Line: 258
                -- upvalues: u35 (copy), u7 (ref), ScreenGui (ref)
                u35:Destroy();

                if u7 == ScreenGui then
                    u7 = nil;
                end;

                ScreenGui:Destroy();
            end);
            u35:Play();
        end);
    end;

    if not p22 then
        finish();

        return;
    end;

    render(0);
    u8 = RunService.RenderStepped:Connect(function(p36) -- Line: 279
        -- upvalues: u7 (ref), ScreenGui (copy), u27 (ref), render (copy), u30 (ref), u29 (ref), finish (copy)
        if u7 ~= ScreenGui then
            return;
        end;

        u27 = math.min(u27 + p36, 3);
        local v37 = (1 - (1 - u27 / 3) ^ 5) * 23;
        render(v37);
        local v38 = math.floor(v37);
        local v39 = math.min(v38, 23);

        if u30 < v39 then
            u30 = v39;

            if v39 < 23 and u29 then
                u29.TimePosition = 0;
                u29:Play();
            end;
        end;

        if u27 >= 3 then
            finish();
        end;
    end);
end;

function v1.Init(p40) -- Line: 311
end;

function v1.Start(p41) -- Line: 313
    -- upvalues: Networking (copy), u2 (copy), play (copy)
    Networking.Werewolf.Reveal.OnClientEvent:Connect(function(p42, p43, p44) -- Line: 314
        -- upvalues: u2 (ref), play (ref)
        if u2[p42] == nil then
            return;
        end;

        play(p42, p43 == true, (type(p44) ~= "number" or p44 <= 0) and 3 or p44);
    end);
end;

return v1;