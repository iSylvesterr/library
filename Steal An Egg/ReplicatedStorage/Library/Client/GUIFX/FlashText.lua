-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Client = Library:WaitForChild("Client");
local Settings = require(Client.Settings);
local Functions = require(Library.Functions);
local CacheProperty = require(script.Parent.CacheProperty);
local UIEasingStyle = Settings.UIEasingStyle;

return function(p1, p2) -- Line: 16, Name: FlashText
    -- upvalues: CacheProperty (copy), Functions (copy), UIEasingStyle (copy)
    local v3 = CacheProperty(p1, "TextColor3");

    if v3 == Color3.new(1, 1, 1) then
        p1.TextColor3 = Color3.new(v3.r / 2, v3.g / 2, v3.b / 2);
    else
        p1.TextColor3 = Color3.new(v3.r * 2, v3.g * 2, v3.b * 2);
    end;

    Functions.Tween(p1, {
        TextColor3 = v3
    }, { p2 or 1, UIEasingStyle });
end;