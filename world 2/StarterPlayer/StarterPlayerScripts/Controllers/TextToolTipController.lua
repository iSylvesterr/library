-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local u2 = LocalPlayer:GetMouse();
local TextTooltip = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Tooltip"):WaitForChild("TextTooltip");
local u3 = nil;
local u4 = false;
local u5 = nil;
local HoverSFX = game.SoundService.SFX.HoverSFX;
local u6 = nil;

local function resolveTextLabel(p7) -- Line: 18
    if p7:IsA("TextLabel") or p7:IsA("TextButton") then
        return p7;
    end;

    for _, v in { "Text", "TextLabel", "Label", "Title", "Desc", "Description" } do
        local v8 = p7:FindFirstChild(v);

        if v8 and (v8:IsA("TextLabel") or v8:IsA("TextButton")) then
            return v8;
        end;
    end;

    return p7:FindFirstChildWhichIsA("TextLabel", true) or p7:FindFirstChildWhichIsA("TextButton", true);
end;

local function isElementVisible(p9) -- Line: 31
    while p9 do
        if p9:IsA("GuiObject") and not p9.Visible then
            return false;
        end;

        if p9:IsA("ScreenGui") and not p9.Enabled then
            return false;
        end;

        p9 = p9.Parent;
    end;

    return true;
end;

local function Update(p10) -- Line: 45
    -- upvalues: u5 (ref), HoverSFX (copy), u6 (ref)
    if u5 == p10 then
        return;
    end;

    HoverSFX.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    HoverSFX.TimePosition = 0;
    HoverSFX.Playing = true;
    u5 = p10;

    if u6 then
        u6.Text = p10;
    end;
end;

function v1.TrackUI(p11, u12) -- Line: 57
    -- upvalues: u3 (ref), u4 (ref), u5 (ref)
    u12.MouseEnter:Connect(function() -- Line: 58
        -- upvalues: u3 (ref), u12 (copy), u4 (ref)
        u3 = u12;
        u4 = true;
    end);
    u12.MouseLeave:Connect(function() -- Line: 62
        -- upvalues: u3 (ref), u12 (copy), u4 (ref), u5 (ref)
        if u3 == u12 then
            u4 = false;
            u3 = nil;
            u5 = nil;
        end;
    end);
    u12:GetAttributeChangedSignal("TextToolTip"):Connect(function() -- Line: 70
        -- upvalues: u12 (copy), u3 (ref), u4 (ref)
        if not u12:GetAttribute("TextToolTip") and u3 == u12 then
            u4 = false;
            u3 = nil;
        end;
    end);
    u12.Destroying:Connect(function() -- Line: 79
        -- upvalues: u3 (ref), u12 (copy), u4 (ref)
        if u3 == u12 then
            u4 = false;
            u3 = nil;
        end;
    end);
end;

function v1.Start(u13) -- Line: 87
    -- upvalues: LocalPlayer (copy), u6 (ref), resolveTextLabel (copy), TextTooltip (copy), RunService (copy), u4 (ref), u3 (ref), isElementVisible (copy), u5 (ref), HoverSFX (copy), u2 (copy)
    local PlayerGui = LocalPlayer.PlayerGui;
    u6 = resolveTextLabel(TextTooltip);

    local function shouldTrack(p14) -- Line: 92
        local v15 = p14:IsA("GuiObject") and p14:GetAttribute("TextToolTip") ~= nil;

        return v15;
    end;

    for _, descendant in PlayerGui:GetDescendants() do
        local v16 = descendant:IsA("GuiObject") and descendant:GetAttribute("TextToolTip") ~= nil;

        if v16 then
            u13:TrackUI(descendant);
        end;
    end;

    PlayerGui.DescendantAdded:Connect(function(p17) -- Line: 101
        -- upvalues: u13 (copy)
        local v18 = p17:IsA("GuiObject") and p17:GetAttribute("TextToolTip") ~= nil;

        if v18 then
            u13:TrackUI(p17);
        end;
    end);
    TextTooltip.Visible = false;
    RunService.Heartbeat:Connect(function() -- Line: 108
        -- upvalues: u4 (ref), u3 (ref), isElementVisible (ref), TextTooltip (ref), u5 (ref), HoverSFX (ref), u6 (ref), u2 (ref)
        if not (u4 and u3) then
            TextTooltip.Visible = false;

            return;
        end;

        if not isElementVisible(u3) then
            TextTooltip.Visible = false;
            u4 = false;
            u3 = nil;
            u5 = nil;

            return;
        end;

        local v19 = u3:GetAttribute("TextToolTip");

        if type(v19) ~= "string" then
            TextTooltip.Visible = false;

            return;
        end;

        if u5 ~= v19 then
            HoverSFX.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            HoverSFX.TimePosition = 0;
            HoverSFX.Playing = true;
            u5 = v19;

            if u6 then
                u6.Text = v19;
            end;
        end;

        TextTooltip.AnchorPoint = Vector2.new(0, 0);
        TextTooltip.Position = UDim2.new(0, u2.X, 0, u2.Y - TextTooltip.AbsoluteSize.Y - 8);
        TextTooltip.Visible = true;
    end);
end;

function v1.Init(p20) -- Line: 135
end;

return v1;