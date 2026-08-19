-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local function dprint(...) -- Line: 8
end;

dprint("module loading...");
local GearShopData = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("GearShopData"));
local GearDescriptionData = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("GearDescriptionData"));
local AnimatedGradient = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("AnimatedGradient"));
local Gradients = ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("RarityData"):WaitForChild("Gradients");
local LocalPlayer = Players.LocalPlayer;
local u1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(140, 0, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 200))
});
local v2 = {};
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = false;

local function findGear(p12) -- Line: 64
    -- upvalues: GearShopData (copy)
    for _, v in GearShopData.Data do
        if v.ItemName == p12 then
            return v;
        end;
    end;

    return nil;
end;

local function show() -- Line: 73
    -- upvalues: u10 (ref), u3 (ref)
    if u10 then
        u10:Open("GearInfo");

        return;
    end;

    if u3 then
        u3.Enabled = true;
    end;
end;

local function playClickSFX() -- Line: 85
    local SFX = game:GetService("SoundService"):FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("Click");
    end;

    if SFX and SFX:IsA("Sound") then
        SFX.TimePosition = 0;
        SFX.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        SFX.Playing = true;
    end;
end;

local function hide() -- Line: 96
    -- upvalues: u10 (ref), playClickSFX (copy), u3 (ref)
    if not u10 then
        if u3 then
            u3.Enabled = false;
        end;

        return;
    end;

    u10:Close();
    u10:Open("RobuxShop");
    playClickSFX();
end;

local function setMirroredText(p13, p14) -- Line: 107
    p13.Text = p14;
    local TextLabel = p13:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = p14;
    end;
end;

local function applyRarityFrame(p15, p16) -- Line: 117
    -- upvalues: Gradients (copy), dprint (copy)
    for _, child in p15:GetChildren() do
        if child:IsA("UIGradient") then
            child:Destroy();
        end;
    end;

    local v17 = Gradients:FindFirstChild(p16);

    if v17 then
        v17:Clone().Parent = p15;
    else
        dprint("no rarity gradient found for", p16);
    end;

    local Rarity_Text = p15:FindFirstChild("Rarity_Text");

    if Rarity_Text and Rarity_Text:IsA("TextLabel") then
        Rarity_Text.Text = p16;
        local TextLabel = Rarity_Text:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = p16;
        end;
    end;
end;

local function clearDescriptionGradient(p18) -- Line: 139
    -- upvalues: AnimatedGradient (copy)
    for _, child in p18:GetChildren() do
        if child:IsA("UIGradient") then
            AnimatedGradient:Remove(child);
            child:Destroy();
        end;
    end;
end;

local function applyDescription(p19, p20, p21) -- Line: 151
    -- upvalues: clearDescriptionGradient (copy), u1 (copy), AnimatedGradient (copy), dprint (copy)
    clearDescriptionGradient(p19);
    p19.RichText = true;
    p19.TextColor3 = Color3.new(1, 1, 1);

    if p20 == "Super" then
        p19.Text = p21;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Color = u1;
        UIGradient.Parent = p19;
        AnimatedGradient:Add(UIGradient);
    elseif p20 == "Legendary" then
        p19.Text = `<font color="#FFD700">{p21}</font>`;
    elseif p20 == "Mythic" then
        p19.Text = `<font color="#DC2828">{p21}</font>`;
    else
        p19.Text = p21;
    end;

    dprint("applied description style for rarity", p20);
end;

local function resolveRefs() -- Line: 175
    -- upvalues: u11 (ref), dprint (copy), LocalPlayer (copy), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), hide (copy), u4 (ref)
    if u11 then
        return;
    end;

    u11 = true;
    dprint("resolveRefs: start");
    local GearInfo = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GearInfo", 30);

    if not (GearInfo and GearInfo:IsA("ScreenGui")) then
        dprint("resolveRefs: GearInfo ScreenGui NOT found (or not a ScreenGui)");

        return;
    end;

    dprint("resolveRefs: found GearInfo");
    u3 = GearInfo;
    GearInfo.Enabled = false;
    local MainFrame = GearInfo:FindFirstChild("MainFrame");
    local v22;

    if MainFrame then
        v22 = MainFrame:FindFirstChild("Content");
    else
        v22 = MainFrame;
    end;

    local v23;

    if v22 then
        v23 = v22:FindFirstChild("Info");
    else
        v23 = v22;
    end;

    if not v23 then
        dprint("resolveRefs: MainFrame/Content/Info missing -> mainFrame:", MainFrame, "content:", v22, "info:", v23);

        return;
    end;

    dprint("resolveRefs: found Info");
    local ImageDisplay = v23:FindFirstChild("ImageDisplay");

    if ImageDisplay then
        ImageDisplay = ImageDisplay:FindFirstChild("PetImage");
    end;

    u5 = ImageDisplay;
    u6 = v23:FindFirstChild("PetType");
    u7 = v23:FindFirstChild("Rarity");
    u8 = v23:FindFirstChild("Description");
    u9 = v23:FindFirstChild("PetName");
    dprint("resolveRefs: refs ->", "PetImage:", u5, "PetType:", u6, "Rarity:", u7, "Description:", u8, "PetName:", u9);
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts");

    if PlayerScripts then
        PlayerScripts = PlayerScripts:FindFirstChild("Controllers");
    end;

    if PlayerScripts then
        PlayerScripts = PlayerScripts:FindFirstChild("GuiController");
    end;

    if PlayerScripts then
        local success, result = pcall(require, PlayerScripts);

        if success then
            u10 = result;
            dprint("resolveRefs: GuiController resolved");
        else
            dprint("resolveRefs: GuiController require FAILED ->", result);
        end;
    else
        dprint("resolveRefs: no GuiController module found (will fall back to Enabled toggle)");
    end;

    local ExitButton = GearInfo:FindFirstChild("ExitButton", true);

    if ExitButton and ExitButton:IsA("GuiButton") then
        ExitButton.Activated:Connect(hide);
        dprint("resolveRefs: ExitButton wired");
    else
        dprint("resolveRefs: no ExitButton found");
    end;

    u4 = v23;
    dprint("resolveRefs: done");
end;

function v2.Init(p24) -- Line: 252
    -- upvalues: dprint (copy), resolveRefs (copy)
    dprint(":Init called");
    task.spawn(resolveRefs);
end;

function v2.OpenGearInfo(p25, p26) -- Line: 258
    -- upvalues: dprint (copy), u4 (ref), u11 (ref), resolveRefs (copy), GearShopData (copy), u5 (ref), u9 (ref), u7 (ref), applyRarityFrame (copy), u6 (ref), u8 (ref), GearDescriptionData (copy), applyDescription (copy), clearDescriptionGradient (copy), u10 (ref), u3 (ref)
    dprint(":OpenGearInfo called with", p26);

    if not u4 then
        if not u11 then
            task.spawn(resolveRefs);
        end;

        local v27 = os.clock() + 5;

        while not u4 and os.clock() < v27 do
            task.wait();
        end;
    end;

    if not u4 then
        dprint(":OpenGearInfo aborted -> infoRef is nil (resolveRefs hasn\'t finished or GUI missing)");

        return;
    end;

    for _, v in GearShopData.Data do
        if v.ItemName == p26 then
            break;
        end;
    end;

    if not v then
        warn((`[GearInfoController] No gear named "{p26}" in GearShopData`));

        return;
    end;

    local v28 = v.Rarity or "Common";
    dprint("gear found ->", v.ItemName, "rarity:", v28, "img:", v.IMG);

    if u5 and u5:IsA("ImageLabel") then
        u5.Image = v.IMG or "";
    else
        dprint("skipped image -> petImageRef not an ImageLabel:", u5);
    end;

    if u9 and u9:IsA("TextLabel") then
        local v29 = u9;
        local ItemName = v.ItemName;
        v29.Text = ItemName;
        local TextLabel = v29:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = ItemName;
        end;
    else
        dprint("skipped name -> petNameRef not a TextLabel:", u9);
    end;

    if u7 then
        applyRarityFrame(u7, v28);
    else
        dprint("skipped rarity -> rarityFrameRef is nil");
    end;

    if u6 and u6:IsA("GuiObject") then
        u6.Visible = false;
    end;

    if u8 and u8:IsA("TextLabel") then
        local v30 = GearDescriptionData.Get(p26);

        if v30 then
            u8.Visible = true;
            applyDescription(u8, v28, v30);
        else
            dprint("no description registered for", p26, "-> clearing");
            clearDescriptionGradient(u8);
            u8.Text = "";
        end;
    else
        dprint("skipped description -> descriptionRef not a TextLabel:", u8);
    end;

    if u10 then
        u10:Open("GearInfo");
    elseif u3 then
        u3.Enabled = true;
    end;

    dprint(":OpenGearInfo done");
end;

dprint("module loaded");

return v2;