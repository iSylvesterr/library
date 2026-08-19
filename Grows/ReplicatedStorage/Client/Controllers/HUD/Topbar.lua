-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Icon = require(Packages:WaitForChild("Icon"));
local Knit = require(Packages:WaitForChild("Knit"));
local Signal = require(Packages:WaitForChild("Signal"));
require(ReplicatedStorage.Shared.Info.CustomEnum);
local v1 = Knit.CreateController({
    Name = "TopbarController"
});
v1.DebugToggle = Signal.new();
Icon.modifyBaseTheme({
    { "IconLabel", "FontFace", Font.new("BuilderSans", Enum.FontWeight.Bold) },
    { "IconLabel", "TextSize", 20 }
});
local SettingsSimple = Players.LocalPlayer.PlayerGui:WaitForChild("Windows"):WaitForChild("SettingsSimple");

function v1.KnitInit(p2) -- Line: 40
    -- upvalues: Knit (copy)
    p2.UI_Manager = Knit.GetController("UI_Manager");
    p2.HotbarController = Knit.GetController("HotbarController");
end;

function v1.KnitStart(u3) -- Line: 45
    -- upvalues: Icon (copy), SettingsSimple (copy)
    Icon.new():setImage(131456359260980):setCaption("Open Settings"):bindEvent("deselected", function() -- Line: 50
        -- upvalues: u3 (copy), SettingsSimple (ref)
        u3.UI_Manager:ToggleWindow(SettingsSimple, true);
    end):oneClick();
    Icon.new():setImage(136007455575706):setCaption("Open Inventory"):bindEvent("deselected", function() -- Line: 58
        -- upvalues: u3 (copy)
        u3.HotbarController:ToggleInventory();
    end):oneClick();
end;

function v1.AddDebug(u4) -- Line: 64
    -- upvalues: Icon (copy)
    Icon.new():setImage(560667850):setCaption("Open Debug Menu"):bindEvent("deselected", function() -- Line: 68
        -- upvalues: u4 (copy)
        u4.DebugToggle:Fire();
    end):oneClick();
end;

return v1;