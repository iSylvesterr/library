-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local Packages = ReplicatedStorage:WaitForChild("Packages");
ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animations");
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local Knit = require(Packages:WaitForChild("Knit"));
local Signal = require(Packages:WaitForChild("Signal"));
require(Packages:WaitForChild("Maid"));
local PlayerGui = Knit.Player:WaitForChild("PlayerGui");
local v1 = Knit.CreateController({
    Name = "UserInputParser",
    InputTypeChanged = Signal.new()
});

function v1.getInputType(p2) -- Line: 26
    return p2.currentInputType;
end;

function v1.updateInputType(p3, p4, p5) -- Line: 30
    -- upvalues: CustomEnum (copy)
    if p5 or p4 ~= p3.currentInputType then
        p3.currentInputType = p4;
        p3.InputTypeChanged:Fire(p3.currentInputType);
        print("new input type", p3.currentInputType);

        if p4 == CustomEnum.INPUT_TYPES.MOBILE then
            p3.InventoryService.MobileModeChange:Fire(true);

            return;
        end;

        p3.InventoryService.MobileModeChange:Fire(false);
    end;
end;

function v1.parseLastInputType(p6, p7) -- Line: 45
    -- upvalues: CustomEnum (copy)
    if p7 == Enum.UserInputType.Touch then
        p6:updateInputType(CustomEnum.INPUT_TYPES.MOBILE);

        return;
    end;

    if p7 == Enum.UserInputType.Keyboard or (p7 == Enum.UserInputType.MouseButton1 or (p7 == Enum.UserInputType.MouseButton2 or p7 == Enum.UserInputType.MouseButton3)) then
        p6:updateInputType(CustomEnum.INPUT_TYPES.DESKTOP);

        return;
    end;

    if p7 == Enum.UserInputType.Gamepad1 then
        p6:updateInputType(CustomEnum.INPUT_TYPES.CONSOLE);
    end;
end;

function v1.parseBaseInputType(p8, p9) -- Line: 63
    -- upvalues: GuiService (copy), CustomEnum (copy), UserInputService (copy)
    if GuiService:IsTenFootInterface() then
        p8:updateInputType(CustomEnum.INPUT_TYPES.CONSOLE, p9);

        return;
    end;

    if UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        p8:updateInputType(CustomEnum.INPUT_TYPES.DESKTOP, p9);

        return;
    end;

    p8:updateInputType(CustomEnum.INPUT_TYPES.MOBILE, p9);
end;

function v1.KnitStart(u10) -- Line: 76
    -- upvalues: UserInputService (copy), PlayerGui (copy)
    u10.currentInputType = nil;
    UserInputService.LastInputTypeChanged:Connect(function(p11) -- Line: 79
        -- upvalues: u10 (copy)
        u10:parseLastInputType(p11);
    end);
    UserInputService.InputBegan:Connect(function(p12) -- Line: 82
        -- upvalues: u10 (copy)
        u10:parseLastInputType(p12.UserInputType);
    end);
    task.spawn(function() -- Line: 86
        -- upvalues: u10 (copy)
        for _ = 1, 10 do
            u10:parseBaseInputType();
            task.wait(0.5);
        end;
    end);
    PlayerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() -- Line: 93
        -- upvalues: u10 (copy)
        u10:parseBaseInputType(true);
    end);
end;

function v1.KnitInit(p13) -- Line: 98
    -- upvalues: Knit (copy)
    p13.InventoryService = Knit.GetService("InventoryService");
end;

return v1;