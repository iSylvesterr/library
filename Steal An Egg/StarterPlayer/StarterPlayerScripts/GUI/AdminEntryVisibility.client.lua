-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AdminEntryVisibility = require(ReplicatedStorage.Library.Client.AdminEntryVisibility);
local v1 = require(ReplicatedStorage.Library.Client.GUI).PlayerGui();

local function bindAdminPanelEntry(p2) -- Line: 25
    -- upvalues: AdminEntryVisibility (copy)
    if p2.Name ~= "AdminPanel" then
        return;
    end;

    local v3 = p2:IsA("ScreenGui");
    assert(v3, "PlayerGui.AdminPanel must be a ScreenGui");
    local Toggle = p2.Toggle;
    local v4 = Toggle:IsA("TextButton");
    assert(v4, "PlayerGui.AdminPanel.Toggle must be a TextButton");
    Toggle.Visible = AdminEntryVisibility.IsAdminPanelVisible();
    AdminEntryVisibility.Changed:Connect(function(p5) -- Line: 33
        -- upvalues: Toggle (copy)
        if Toggle.Parent ~= nil then
            Toggle.Visible = p5;
        end;
    end);
end;

for _, child in v1:GetChildren() do
    bindAdminPanelEntry(child);
end;

v1.ChildAdded:Connect(bindAdminPanelEntry);