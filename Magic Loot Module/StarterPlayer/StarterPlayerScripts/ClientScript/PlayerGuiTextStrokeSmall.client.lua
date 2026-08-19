-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local LocalPlayer = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).LocalPlayer;
local u1 = false;
local u2 = {};

local function _isTextObject(p3) -- Line: 40
    return p3:IsA("TextLabel") or (p3:IsA("TextButton") or p3:IsA("TextBox"));
end;

local function _isTextStroke(p4) -- Line: 50
    local Parent = p4.Parent;
    local v5;

    if Parent == nil then
        v5 = false;
    else
        v5 = Parent:IsA("TextLabel") or (Parent:IsA("TextButton") or Parent:IsA("TextBox"));
    end;

    return v5;
end;

local function _ensureOriThickness(p6) -- Line: 61
    local v7 = p6:GetAttribute("TextStrokeOriThickness");

    if typeof(v7) == "number" then
        return v7;
    end;

    local Thickness = p6.Thickness;
    p6:SetAttribute("TextStrokeOriThickness", Thickness);

    return Thickness;
end;

local function _applyStroke(p8) -- Line: 77
    -- upvalues: u2 (copy), u1 (ref)
    if not p8.Parent then
        u2[p8] = nil;

        return;
    end;

    local v9 = p8:GetAttribute("TextStrokeOriThickness");

    if typeof(v9) ~= "number" then
        v9 = p8.Thickness;
        p8:SetAttribute("TextStrokeOriThickness", v9);
    end;

    if u1 then
        p8.Thickness = v9 > 2 and 2 or v9;

        return;
    end;

    p8.Thickness = v9;
end;

local function _trackStroke(u10) -- Line: 96
    -- upvalues: u2 (copy), u1 (ref)
    local Parent = u10.Parent;
    local v11;

    if Parent == nil then
        v11 = false;
    else
        v11 = Parent:IsA("TextLabel") or (Parent:IsA("TextButton") or Parent:IsA("TextBox"));
    end;

    if not v11 then
        return;
    end;

    if u2[u10] then
        if not u10.Parent then
            u2[u10] = nil;

            return;
        end;

        local v12 = u10:GetAttribute("TextStrokeOriThickness");

        if typeof(v12) ~= "number" then
            v12 = u10.Thickness;
            u10:SetAttribute("TextStrokeOriThickness", v12);
        end;

        if u1 then
            u10.Thickness = v12 > 2 and 2 or v12;

            return;
        end;

        u10.Thickness = v12;

        return;
    end;

    u2[u10] = true;
    local v13 = u10:GetAttribute("TextStrokeOriThickness");

    if typeof(v13) ~= "number" then
        u10:SetAttribute("TextStrokeOriThickness", u10.Thickness);
    end;

    if u10.Parent then
        local v14 = u10:GetAttribute("TextStrokeOriThickness");

        if typeof(v14) ~= "number" then
            v14 = u10.Thickness;
            u10:SetAttribute("TextStrokeOriThickness", v14);
        end;

        if u1 then
            u10.Thickness = v14 > 2 and 2 or v14;
        else
            u10.Thickness = v14;
        end;
    else
        u2[u10] = nil;
    end;

    u10.Destroying:Connect(function() -- Line: 108
        -- upvalues: u2 (ref), u10 (copy)
        u2[u10] = nil;
    end);
end;

local function _onDescendant(p15) -- Line: 119
    -- upvalues: _trackStroke (copy)
    if p15:IsA("UIStroke") then
        _trackStroke(p15);

        return;
    end;

    if p15:IsA("TextLabel") or (p15:IsA("TextButton") or p15:IsA("TextBox")) then
        for _, child in p15:GetChildren() do
            if child:IsA("UIStroke") then
                _trackStroke(child);
            end;
        end;
    end;
end;

local function _onViewportDisplaySizeChange() -- Line: 136
    -- upvalues: u1 (ref), GuiService (copy), u2 (copy)
    u1 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small;

    for i in u2 do
        if i.Parent then
            local v16 = i:GetAttribute("TextStrokeOriThickness");

            if typeof(v16) ~= "number" then
                v16 = i.Thickness;
                i:SetAttribute("TextStrokeOriThickness", v16);
            end;

            if u1 then
                i.Thickness = v16 > 2 and 2 or v16;
            else
                i.Thickness = v16;
            end;
        else
            u2[i] = nil;
        end;
    end;
end;

local function _watchPlayerGui(p17) -- Line: 149
    -- upvalues: _onDescendant (copy)
    for _, descendant in p17:GetDescendants() do
        _onDescendant(descendant);
    end;

    p17.DescendantAdded:Connect(_onDescendant);
end;

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", (1 / 0));

for _, descendant in PlayerGui:GetDescendants() do
    _onDescendant(descendant);
end;

PlayerGui.DescendantAdded:Connect(_onDescendant);

if GuiService.ViewportDisplaySize == Enum.DisplaySize.Small then
    u1 = true;
else
    u1 = false;
end;

for i in u2 do
    if i.Parent then
        local v18 = i:GetAttribute("TextStrokeOriThickness");

        if typeof(v18) ~= "number" then
            v18 = i.Thickness;
            i:SetAttribute("TextStrokeOriThickness", v18);
        end;

        if u1 then
            i.Thickness = v18 > 2 and 2 or v18;
        else
            i.Thickness = v18;
        end;
    else
        u2[i] = nil;
    end;
end;

GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(_onViewportDisplaySizeChange);