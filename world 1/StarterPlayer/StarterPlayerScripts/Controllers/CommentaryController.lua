-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local u1 = assert(Players.LocalPlayer);
local v2 = {};
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = 0;
local u8 = {};

local function getTypingSfx() -- Line: 59
    -- upvalues: SoundService (copy)
    local NPC_SFX = SoundService:FindFirstChild("NPC_SFX");

    if not NPC_SFX then
        return nil;
    end;

    local v9 = NPC_SFX:FindFirstChild("Jandel") or NPC_SFX:FindFirstChild("NPC_Text");

    if v9 and v9:IsA("Sound") then
        return v9;
    end;

    return nil;
end;

local function makeClickThrough(p10) -- Line: 83
    if p10:IsA("GuiObject") then
        p10.Active = false;
        p10.Selectable = false;
    end;

    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("GuiObject") then
            descendant.Active = false;
            descendant.Selectable = false;
        end;
    end;
end;

local function ensureDimGroup(p11, p12) -- Line: 109
    local DimGroup = p11:FindFirstChild("DimGroup");

    if DimGroup and DimGroup:IsA("CanvasGroup") then
        return DimGroup;
    end;

    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "DimGroup";
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.BorderSizePixel = 0;
    CanvasGroup.Active = false;
    CanvasGroup.Selectable = false;
    CanvasGroup.AnchorPoint = p12.AnchorPoint;
    CanvasGroup.Position = p12.Position;
    CanvasGroup.Size = p12.Size;
    CanvasGroup.Parent = p11;
    p12.AnchorPoint = Vector2.zero;
    p12.Position = UDim2.fromScale(0, 0);
    p12.Size = UDim2.fromScale(1, 1);
    p12.Parent = CanvasGroup;

    return CanvasGroup;
end;

local u13 = nil;

local function bindGui() -- Line: 142
    -- upvalues: u3 (ref), u5 (ref), u1 (copy), u4 (ref), u6 (ref), ensureDimGroup (copy), makeClickThrough (copy), u13 (ref)
    if u3 and (u3.Parent and (u5 and u5.Parent)) then
        return true;
    end;

    local PlayerGui = u1:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return false;
    end;

    local JandelCommentary = PlayerGui:FindFirstChild("JandelCommentary");

    if not (JandelCommentary and JandelCommentary:IsA("ScreenGui")) then
        return false;
    end;

    local Feed = JandelCommentary:FindFirstChild("Feed", true);

    if not (Feed and Feed:IsA("Frame")) then
        return false;
    end;

    local MessageTemplate = Feed:FindFirstChild("MessageTemplate");

    if not (MessageTemplate and MessageTemplate:IsA("Frame")) then
        return false;
    end;

    u4 = JandelCommentary;
    u3 = Feed;
    u5 = MessageTemplate;
    u6 = ensureDimGroup(JandelCommentary, Feed);
    makeClickThrough(Feed);
    u13();

    return true;
end;

local function stripRichTextTags(p14) -- Line: 171
    return p14:gsub("<.->", "");
end;

local function removeRow(p15) -- Line: 175
    -- upvalues: u8 (copy), u4 (ref)
    local v16 = table.find(u8, p15);

    if v16 then
        table.remove(u8, v16);
    end;

    if p15.Parent then
        p15:Destroy();
    end;

    if #u8 == 0 and u4 then
        u4.Enabled = false;
    end;
end;

local function fadeOutRow(u17) -- Line: 193
    -- upvalues: TweenService (copy), u8 (copy), u4 (ref)
    local u18 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    local function fade(u19, u20) -- Line: 196
        -- upvalues: TweenService (ref), u18 (copy)
        return pcall(function() -- Line: 197
            -- upvalues: TweenService (ref), u19 (copy), u18 (ref), u20 (copy)
            TweenService:Create(u19, u18, {
                [u20] = 1
            }):Play();
        end);
    end;

    local u21 = "BackgroundTransparency";
    pcall(function() -- Line: 197
        -- upvalues: TweenService (ref), u17 (copy), u18 (copy), u21 (copy)
        TweenService:Create(u17, u18, {
            [u21] = 1
        }):Play();
    end);

    for _, descendant in u17:GetDescendants() do
        if descendant:IsA("TextLabel") then
            local u22 = "TextTransparency";
            pcall(function() -- Line: 197
                -- upvalues: TweenService (ref), descendant (copy), u18 (copy), u22 (copy)
                TweenService:Create(descendant, u18, {
                    [u22] = 1
                }):Play();
            end);
            local u23 = "TextStrokeTransparency";
            pcall(function() -- Line: 197
                -- upvalues: TweenService (ref), descendant (copy), u18 (copy), u23 (copy)
                TweenService:Create(descendant, u18, {
                    [u23] = 1
                }):Play();
            end);
        elseif descendant:IsA("ImageLabel") then
            local u24 = "ImageTransparency";
            pcall(function() -- Line: 197
                -- upvalues: TweenService (ref), descendant (copy), u18 (copy), u24 (copy)
                TweenService:Create(descendant, u18, {
                    [u24] = 1
                }):Play();
            end);
        elseif descendant:IsA("UIStroke") then
            local u25 = "Transparency";
            pcall(function() -- Line: 197
                -- upvalues: TweenService (ref), descendant (copy), u18 (copy), u25 (copy)
                TweenService:Create(descendant, u18, {
                    [u25] = 1
                }):Play();
            end);
        end;
    end;

    task.delay(0.6, function() -- Line: 215
        -- upvalues: u17 (copy), u8 (ref), u4 (ref)
        local v26 = u17;
        local v27 = table.find(u8, v26);

        if v27 then
            table.remove(u8, v27);
        end;

        if v26.Parent then
            v26:Destroy();
        end;

        if #u8 == 0 and u4 then
            u4.Enabled = false;
        end;
    end);
end;

local function playTypewriter(p28, p29) -- Line: 221
    local v30 = utf8.len((p28.Text:gsub("<.->", ""))) or 0;
    p28.MaxVisibleGraphemes = 0;

    while v30 >= 1 do
        task.wait();

        if not p28.Parent then
            return;
        end;

        if p29 and (p29.TimePosition > 0.07 or not p29.Playing) then
            p29.TimePosition = 0;
            p29.Playing = true;
            p29.PlaybackSpeed = 1 + math.random(-5, 5) / 100;
        end;

        v30 = v30 - 1;
        p28.MaxVisibleGraphemes = p28.MaxVisibleGraphemes + 1;
    end;

    p28.MaxVisibleGraphemes = -1;
end;

local function addRow(p31, p32, p33, p34) -- Line: 246
    -- upvalues: bindGui (copy), u3 (ref), u5 (ref), u4 (ref), u7 (ref), makeClickThrough (copy), u8 (copy), playTypewriter (copy), SoundService (copy), fadeOutRow (copy)
    if not bindGui() then
        return;
    end;

    local v35 = assert(u3);
    local v36 = assert(u5);
    local v37 = assert(u4);
    local u38 = v36:Clone();
    u38.Name = "MessageRow";
    u38.Visible = true;
    u7 = u7 + 1;
    u38.LayoutOrder = u7;
    makeClickThrough(u38);
    local Username = u38:FindFirstChild("Username");

    if Username and Username:IsA("TextLabel") then
        Username.Text = `{p32}:`;
    end;

    local UserImage = u38:FindFirstChild("UserImage");

    if UserImage and UserImage:IsA("ImageLabel") then
        UserImage.Image = `rbxthumb://type=AvatarHeadShot&id={p31}&w={150}&h={150}`;
    end;

    local Verified = u38:FindFirstChild("Verified");

    if Verified and Verified:IsA("ImageLabel") then
        Verified.Visible = p34;
    end;

    local Message = u38:FindFirstChild("Message");

    if Message and Message:IsA("TextLabel") then
        Message.Text = p33;
        Message.MaxVisibleGraphemes = 0;
    end;

    u38.Parent = v35;
    table.insert(u8, u38);
    v37.Enabled = true;

    while #u8 > 4 do
        local v39 = u8[1];
        local v40 = table.find(u8, v39);

        if v40 then
            table.remove(u8, v40);
        end;

        if v39.Parent then
            v39:Destroy();
        end;

        if #u8 == 0 and u4 then
            u4.Enabled = false;
        end;
    end;

    if Message and Message:IsA("TextLabel") then
        task.spawn(function() -- Line: 294
            -- upvalues: playTypewriter (ref), Message (copy), SoundService (ref), u38 (copy), fadeOutRow (ref)
            local NPC_SFX = SoundService:FindFirstChild("NPC_SFX");
            local v41;

            if NPC_SFX then
                v41 = NPC_SFX:FindFirstChild("Jandel") or NPC_SFX:FindFirstChild("NPC_Text");

                if not (v41 and v41:IsA("Sound")) then
                    v41 = nil;
                end;
            else
                v41 = nil;
            end;

            playTypewriter(Message, v41);
            task.wait(12);

            if u38.Parent then
                fadeOutRow(u38);
            end;
        end);

        return;
    end;

    task.delay(12, function() -- Line: 304
        -- upvalues: u38 (copy), fadeOutRow (ref)
        if u38.Parent then
            fadeOutRow(u38);
        end;
    end);
end;

u13 = function() -- Line: 315, Name: refreshDim
    -- upvalues: u6 (ref), u1 (copy), TweenService (copy)
    local v42 = u6;

    if not v42 then
        return;
    end;

    local v43 = u1:GetAttribute("AdminPanelOpen") == true;
    TweenService:Create(v42, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        GroupTransparency = v43 and 0.72 or 0
    }):Play();
end;

function v2.Start(p44) -- Line: 328
    -- upvalues: bindGui (copy), u4 (ref), u1 (copy), u13 (ref), Networking (copy), addRow (copy)
    if bindGui() and u4 then
        u4.Enabled = false;
    end;

    u1:GetAttributeChangedSignal("AdminPanelOpen"):Connect(u13);
    Networking.Commentary.Message.OnClientEvent:Connect(function(p45) -- Line: 336
        -- upvalues: addRow (ref)
        if type(p45) ~= "table" then
            return;
        end;

        local Message = p45.Message;

        if type(Message) ~= "string" or Message == "" then
            return;
        end;

        addRow(type(p45.UserId) ~= "number" and 0 or p45.UserId, (type(p45.Name) ~= "string" or p45.Name == "") and "Jandel" or p45.Name, Message, p45.Verified == true);
    end);
end;

return v2;