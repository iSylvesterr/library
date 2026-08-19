-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local u2 = LocalPlayer:GetMouse();
local u3 = {};
local u4 = false;
local u5 = false;
local u6 = nil;
local u7 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
local u8 = {};

local function CancelActiveTweens() -- Line: 20
    -- upvalues: u8 (copy)
    for _, v in u8 do
        v:Cancel();
    end;

    table.clear(u8);
end;

local function TweenTransparency(p9, p10) -- Line: 27
    -- upvalues: u8 (copy), TweenService (copy), u7 (copy)
    for _, v in u8 do
        v:Cancel();
    end;

    table.clear(u8);
    local v11 = TweenService:Create(p9, u7, {
        TextTransparency = p10
    });
    v11:Play();
    table.insert(u8, v11);
    local v12 = p9:FindFirstChildOfClass("UIStroke");

    if v12 then
        local v13 = TweenService:Create(v12, u7, {
            Transparency = p10
        });
        v13:Play();
        table.insert(u8, v13);
    end;
end;

local function SetupUI(u14, p15) -- Line: 42
    -- upvalues: u3 (copy), u4 (ref), u6 (ref)
    if u3[u14] then
        return;
    end;

    u3[u14] = p15;
    u14:GetAttributeChangedSignal("HoverDescription"):Connect(function() -- Line: 47
        -- upvalues: u3 (ref), u14 (copy), u4 (ref), u6 (ref)
        u3[u14] = u14:GetAttribute("HoverDescription");

        if u4 and u6 == u14 then
            u6 = u14;
        end;
    end);
    u14.MouseEnter:Connect(function() -- Line: 54
        -- upvalues: u6 (ref), u14 (copy), u4 (ref)
        u6 = u14;
        u4 = true;
    end);
    u14.MouseLeave:Connect(function() -- Line: 59
        -- upvalues: u6 (ref), u14 (copy), u4 (ref)
        if u6 == u14 then
            u4 = false;
        end;
    end);
    u14.Destroying:Connect(function() -- Line: 65
        -- upvalues: u3 (ref), u14 (copy), u6 (ref), u4 (ref)
        u3[u14] = nil;

        if u6 == u14 then
            u4 = false;
            u6 = nil;
        end;
    end);
end;

function v1.Start(p16) -- Line: 74
    -- upvalues: LocalPlayer (copy), SetupUI (copy), RunService (copy), u4 (ref), u6 (ref), u3 (copy), u2 (copy), u5 (ref), TweenTransparency (copy)
    local HoverUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HoverUI");

    for _, descendant in LocalPlayer.PlayerGui:GetDescendants() do
        if descendant:GetAttribute("HoverDescription") then
            SetupUI(descendant, descendant:GetAttribute("HoverDescription"));
        end;
    end;

    LocalPlayer.PlayerGui.DescendantAdded:Connect(function(p17) -- Line: 83
        -- upvalues: SetupUI (ref)
        if p17:GetAttribute("HoverDescription") then
            SetupUI(p17, p17:GetAttribute("HoverDescription"));
        end;
    end);
    local u18 = script.Time:Clone();
    local TXT = u18.TXT;
    u18.Parent = HoverUI;
    RunService.Heartbeat:Connect(function() -- Line: 93
        -- upvalues: u4 (ref), u6 (ref), u3 (ref), TXT (copy), u18 (copy), u2 (ref), u5 (ref), TweenTransparency (ref)
        if u4 and u6 then
            local v19 = u3[u6] or "";
            TXT.Text = v19;
            u18.Text = v19;
            u18.Position = UDim2.new(0, u2.X - u18.AbsoluteSize.X / 2, 0, u2.Y);

            if not u5 then
                TweenTransparency(TXT, 0);
                u5 = true;
            end;
        elseif u5 then
            TweenTransparency(TXT, 1);
            u5 = false;
        end;
    end);
end;

return v1;