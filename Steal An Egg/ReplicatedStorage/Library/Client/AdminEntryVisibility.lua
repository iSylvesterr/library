-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local u1 = UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled;
local u2 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
local u3 = false;
local u4 = {
    Changed = Signal.new(),

    IsVisible = function() -- Line: 26, Name: IsVisible
        -- upvalues: u1 (copy), u3 (ref)
        return u1 and u3;
    end
};

function u4.IsAdminPanelVisible() -- Line: 30
    -- upvalues: u2 (copy), u4 (copy)
    return game.GameId == 10650210095 and true or (u2 or u4.IsVisible());
end;

UserInputService.InputBegan:Connect(function(p5, p6) -- Line: 38
    -- upvalues: u1 (copy), u3 (ref), u4 (copy)
    if not u1 or (p6 or p5.KeyCode ~= Enum.KeyCode.F8) then
        return;
    end;

    u3 = not u3;
    u4.Changed:Fire(u3);
end);

return u4;