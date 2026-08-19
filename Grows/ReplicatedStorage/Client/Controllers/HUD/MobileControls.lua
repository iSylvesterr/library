-- Decompiled with Potassium's decompiler.

game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Info = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info");
ReplicatedStorage:WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Utility");
local Effects = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gui"):WaitForChild("Effects");
local Constants = require(Info:WaitForChild("Constants"));
local CustomEnum = require(Info:WaitForChild("CustomEnum"));
require(Info:WaitForChild("Images"));
local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"));
local Signal = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Signal"));
local v1 = Knit.CreateController({
    Name = "MobileControls"
});
local LocalPlayer = game.Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;
require(LocalPlayer.PlayerScripts.PlayerModule);
require(LocalPlayer.PlayerScripts.PlayerModule.ControlModule.TouchJump);
local MobileButtons = PlayerGui:WaitForChild("MobileUI"):WaitForChild("MobileButtons");
local ButtonTemplate = Effects:WaitForChild("ButtonTemplate");
local u2 = {};
local u3 = nil;
v1.TreePlantButton = Signal.new();

local function isTouchInside(p4, p5) -- Line: 41
    local AbsolutePosition = p4.AbsolutePosition;
    local AbsoluteSize = p4.AbsoluteSize;
    local v6;

    if p5.X >= AbsolutePosition.X and (p5.X <= AbsolutePosition.X + AbsoluteSize.X and p5.Y >= AbsolutePosition.Y) then
        v6 = p5.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v6 = false;
    end;

    return v6;
end;

function v1.UpdateMobileButtons(u7) -- Line: 50
    -- upvalues: CustomEnum (copy), MobileButtons (copy), u2 (copy)
    local u8 = u7.UserInputParser:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
    task.spawn(function() -- Line: 53
        -- upvalues: u8 (copy), MobileButtons (ref), u2 (ref), u7 (copy)
        if not u8 then
            MobileButtons.Visible = false;

            return;
        end;

        MobileButtons.Visible = true;

        for i, v in u2 do
            u7:GenMobileButton(v, i);
        end;
    end);
end;

function v1.SetupButtons(u9) -- Line: 67
    -- upvalues: MobileButtons (copy), u2 (copy), CustomEnum (copy)
    task.spawn(function() -- Line: 68
        -- upvalues: u9 (copy), MobileButtons (ref), u2 (ref), CustomEnum (ref)
        local u10 = u9:GenMobileButton(nil, "PlantTree");
        u10.Parent = MobileButtons;
        u2.PlantTree = u10;
        u10.Button.PressedImage = "";
        u10.Button.Modal = false;
        u10.Button.Active = false;
        game:GetService("UserInputService").InputBegan:Connect(function(p11, p12) -- Line: 77
            -- upvalues: u10 (copy), u9 (ref)
            if p11.UserInputType == Enum.UserInputType.Touch and u10.Visible then
                local Button = u10.Button;
                local Position = p11.Position;
                local AbsolutePosition = Button.AbsolutePosition;
                local AbsoluteSize = Button.AbsoluteSize;
                local v13;

                if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
                    v13 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                else
                    v13 = false;
                end;

                if v13 then
                    print("PLANT TREE");
                    u9.TreePlantButton:Fire();
                end;
            end;
        end);
        u9:PrepareButton(u10.Button);
        u10.Visible = false;
        u9.UserInputParser.InputTypeChanged:Connect(function(p14) -- Line: 89
            -- upvalues: CustomEnum (ref), u9 (ref)
            if p14 == CustomEnum.INPUT_TYPES.MOBILE then
                u9:UpdateMobileButtons();

                return;
            end;

            u9:UpdateMobileButtons();
        end);
        u9:UpdateMobileButtons();
    end);
end;

function v1.GenMobileButton(p15, p16, p17) -- Line: 102
    -- upvalues: Constants (copy), LocalPlayer (copy), Knit (copy), ButtonTemplate (copy), u3 (ref)
    if Constants.MOBILE_BUTTON_DATA[p17] then
        local TouchGui = LocalPlayer.PlayerGui:FindFirstChild("TouchGui");

        while not TouchGui do
            TouchGui = LocalPlayer.PlayerGui:FindFirstChild("TouchGui");
            task.wait(1);
        end;

        local v18 = Constants.MOBILE_BUTTON_DATA[p17];
        local JumpButton = LocalPlayer.PlayerGui:WaitForChild("TouchGui"):WaitForChild("TouchControlFrame"):WaitForChild("JumpButton");
        local X = JumpButton.AbsoluteSize.X;
        local Y = JumpButton.AbsoluteSize.Y;
        local v19 = JumpButton.AbsolutePosition.X + X / 2;
        local v20 = JumpButton.AbsolutePosition.Y + Y / 2;
        local v21 = Knit.GetController("DataClient").currentData.Settings.MobileOffset.Buttons[p17] or {
            x = 0,
            y = 0
        };
        local v22;

        if p16 then
            v22 = p16;
        else
            v22 = ButtonTemplate:Clone();
            v22.Parent = script;
        end;

        v22.Size = UDim2.new(0, X * v18.xScaleSize, 0, Y * v18.yScaleSize);
        v22.Position = UDim2.new(0, v19 + X * v18.xOffsetScale, 0, v20 + Y * v18.yOffsetScale);

        if v18.text then
            v22.Button.TextLabel.Text = p17 == "PlantTree" and u3 or v18.text;
        end;

        v22.Button.Position = UDim2.new(0.5, v21.x, 0.5, v21.y);

        if not p16 then
            v22.Button.Image = v18.image;
            v22.Button.PressedImage = v18.image;
        end;

        return v22;
    end;

    warn("BUTTON ", p17, " NOT SET UP");
end;

function v1.PrepareButton(p23, p24) -- Line: 156
    p24.BackgroundColor3 = Color3.new(0, 0, 0);
    p24.BackgroundTransparency = 0.35;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 100);
    UICorner.Parent = p24;
end;

function v1.getCurrentMobileButtons(p25) -- Line: 164
    -- upvalues: u2 (copy)
    return u2;
end;

function v1.SetTreePlaceText(p26, p27) -- Line: 168
    -- upvalues: u3 (ref), u2 (copy)
    u3 = p27;
    local PlantTree = u2.PlantTree;

    if PlantTree then
        PlantTree = PlantTree.Button:FindFirstChild("TextLabel");
    end;

    if PlantTree then
        PlantTree.Text = p27;
    end;
end;

function v1.SetTreePlaceVisible(p28, p29) -- Line: 175
    -- upvalues: u2 (copy)
    if u2.PlantTree then
        u2.PlantTree.Visible = p29;
    end;
end;

function v1.KnitStart(u30) -- Line: 181
    -- upvalues: CustomEnum (copy)
    u30.DataClient.EV_UPDATE:Connect(function() -- Line: 183
        -- upvalues: u30 (copy), CustomEnum (ref)
        if u30.UserInputParser:getInputType() == CustomEnum.INPUT_TYPES.MOBILE then
            u30:UpdateMobileButtons();
        end;
    end);
    u30.DataClient.EV_FIRST_UPDATE:Once(function() -- Line: 189
        -- upvalues: u30 (copy)
        u30:SetupButtons();
    end);
end;

function v1.KnitInit(p31) -- Line: 194
    -- upvalues: Knit (copy)
    p31.DataClient = Knit.GetController("DataClient");
    p31.UI_Manager = Knit.GetController("UI_Manager");
    p31.UserInputParser = Knit.GetController("UserInputParser");
end;

return v1;