-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
UserSettings():GetService("UserGameSettings");
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"));
local u1 = setmetatable({}, BaseCharacterController);
u1.__index = u1;

function u1.new() -- Line: 20
    -- upvalues: BaseCharacterController (copy), u1 (copy)
    local v2 = BaseCharacterController.new();
    local v3 = setmetatable(v2, u1);
    v3.isFollowStick = false;
    v3.thumbstickFrame = nil;
    v3.moveTouchObject = nil;
    v3.onTouchMovedConn = nil;
    v3.onTouchEndedConn = nil;
    v3.screenPos = nil;
    v3.stickImage = nil;
    v3.thumbstickSize = nil;

    return v3;
end;

function u1.Enable(p4, p5, p6) -- Line: 35
    if p5 == nil then
        return false;
    end;

    local v7 = p5 and true or false;

    if p4.enabled == v7 then
        return true;
    end;

    p4.moveVector = Vector3.new(0, 0, 0);
    p4.isJumping = false;

    if v7 then
        if not p4.thumbstickFrame then
            p4:Create(p6);
        end;

        p4.thumbstickFrame.Visible = true;
    else
        p4.thumbstickFrame.Visible = false;
        p4:OnInputEnded();
    end;

    p4.enabled = v7;
end;

function u1.OnInputEnded(p8) -- Line: 56
    p8.thumbstickFrame.Position = p8.screenPos;
    p8.stickImage.Position = UDim2.new(0, p8.thumbstickFrame.Size.X.Offset / 2 - p8.thumbstickSize / 4, 0, p8.thumbstickFrame.Size.Y.Offset / 2 - p8.thumbstickSize / 4);
    p8.moveVector = Vector3.new(0, 0, 0);
    p8.isJumping = false;
    p8.thumbstickFrame.Position = p8.screenPos;
    p8.moveTouchObject = nil;
end;

function u1.Create(u9, u10) -- Line: 65
    -- upvalues: UserInputService (copy), GuiService (copy)
    if u9.thumbstickFrame then
        u9.thumbstickFrame:Destroy();
        u9.thumbstickFrame = nil;

        if u9.onTouchMovedConn then
            u9.onTouchMovedConn:Disconnect();
            u9.onTouchMovedConn = nil;
        end;

        if u9.onTouchEndedConn then
            u9.onTouchEndedConn:Disconnect();
            u9.onTouchEndedConn = nil;
        end;

        if u9.absoluteSizeChangedConn then
            u9.absoluteSizeChangedConn:Disconnect();
            u9.absoluteSizeChangedConn = nil;
        end;
    end;

    u9.thumbstickFrame = Instance.new("Frame");
    u9.thumbstickFrame.Name = "ThumbstickFrame";
    u9.thumbstickFrame.Active = true;
    u9.thumbstickFrame.Visible = false;
    u9.thumbstickFrame.BackgroundTransparency = 1;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "OuterImage";
    ImageLabel.Image = "rbxasset://textures/ui/TouchControlsSheet.png";
    ImageLabel.ImageRectOffset = Vector2.new();
    ImageLabel.ImageRectSize = Vector2.new(220, 220);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Position = UDim2.new(0, 0, 0, 0);
    u9.stickImage = Instance.new("ImageLabel");
    u9.stickImage.Name = "StickImage";
    u9.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png";
    u9.stickImage.ImageRectOffset = Vector2.new(220, 0);
    u9.stickImage.ImageRectSize = Vector2.new(111, 111);
    u9.stickImage.BackgroundTransparency = 1;
    u9.stickImage.ZIndex = 2;

    local function ResizeThumbstick() -- Line: 105
        -- upvalues: u10 (copy), u9 (copy), ImageLabel (copy)
        local v11 = math.min(u10.AbsoluteSize.X, u10.AbsoluteSize.Y) <= 500;
        u9.thumbstickSize = v11 and 70 or 120;
        u9.screenPos = v11 and UDim2.new(0, u9.thumbstickSize / 2 - 10, 1, -u9.thumbstickSize - 20) or UDim2.new(0, u9.thumbstickSize / 2, 1, -u9.thumbstickSize * 1.75);
        u9.thumbstickFrame.Size = UDim2.new(0, u9.thumbstickSize, 0, u9.thumbstickSize);
        u9.thumbstickFrame.Position = u9.screenPos;
        ImageLabel.Size = UDim2.new(0, u9.thumbstickSize, 0, u9.thumbstickSize);
        u9.stickImage.Size = UDim2.new(0, u9.thumbstickSize / 2, 0, u9.thumbstickSize / 2);
        u9.stickImage.Position = UDim2.new(0, u9.thumbstickSize / 2 - u9.thumbstickSize / 4, 0, u9.thumbstickSize / 2 - u9.thumbstickSize / 4);
    end;

    ResizeThumbstick();
    u9.absoluteSizeChangedConn = u10:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick);
    ImageLabel.Parent = u9.thumbstickFrame;
    u9.stickImage.Parent = u9.thumbstickFrame;
    local u12 = nil;

    local function DoMove(p13) -- Line: 127
        -- upvalues: u9 (copy)
        local v14 = p13 / (u9.thumbstickSize / 2);
        local magnitude = v14.magnitude;
        local v15;

        if magnitude < 0.05 then
            v15 = Vector3.new();
        else
            local v16 = v14.unit * math.min(1, (magnitude - 0.05) / 0.95);
            v15 = Vector3.new(v16.X, 0, v16.Y);
        end;

        u9.moveVector = v15;
    end;

    local function MoveStick(p17) -- Line: 145
        -- upvalues: u12 (ref), u9 (copy)
        local v18 = Vector2.new(p17.X - u12.X, p17.Y - u12.Y);
        local magnitude = v18.magnitude;
        local v19 = u9.thumbstickFrame.AbsoluteSize.X / 2;

        if u9.isFollowStick and v19 < magnitude then
            local v20 = v18.unit * v19;
            u9.thumbstickFrame.Position = UDim2.new(0, p17.X - u9.thumbstickFrame.AbsoluteSize.X / 2 - v20.X, 0, p17.Y - u9.thumbstickFrame.AbsoluteSize.Y / 2 - v20.Y);
        else
            local v21 = math.min(magnitude, v19);
            v18 = v18.unit * v21;
        end;

        u9.stickImage.Position = UDim2.new(0, v18.X + u9.stickImage.AbsoluteSize.X / 2, 0, v18.Y + u9.stickImage.AbsoluteSize.Y / 2);
    end;

    u9.thumbstickFrame.InputBegan:Connect(function(p22) -- Line: 162
        -- upvalues: u9 (copy), u12 (ref)
        if u9.moveTouchObject or (p22.UserInputType ~= Enum.UserInputType.Touch or p22.UserInputState ~= Enum.UserInputState.Begin) then
            return;
        end;

        u9.moveTouchObject = p22;
        u9.thumbstickFrame.Position = UDim2.new(0, p22.Position.X - u9.thumbstickFrame.Size.X.Offset / 2, 0, p22.Position.Y - u9.thumbstickFrame.Size.Y.Offset / 2);
        u12 = Vector2.new(u9.thumbstickFrame.AbsolutePosition.X + u9.thumbstickFrame.AbsoluteSize.X / 2, u9.thumbstickFrame.AbsolutePosition.Y + u9.thumbstickFrame.AbsoluteSize.Y / 2);
        Vector2.new(p22.Position.X - u12.X, p22.Position.Y - u12.Y);
    end);
    u9.onTouchMovedConn = UserInputService.TouchMoved:Connect(function(p23, p24) -- Line: 177
        -- upvalues: u9 (copy), u12 (ref), MoveStick (copy)
        if p23 == u9.moveTouchObject then
            u12 = Vector2.new(u9.thumbstickFrame.AbsolutePosition.X + u9.thumbstickFrame.AbsoluteSize.X / 2, u9.thumbstickFrame.AbsolutePosition.Y + u9.thumbstickFrame.AbsoluteSize.Y / 2);
            local v25 = Vector2.new(p23.Position.X - u12.X, p23.Position.Y - u12.Y) / (u9.thumbstickSize / 2);
            local magnitude = v25.magnitude;
            local v26;

            if magnitude < 0.05 then
                v26 = Vector3.new();
            else
                local v27 = v25.unit * math.min(1, (magnitude - 0.05) / 0.95);
                v26 = Vector3.new(v27.X, 0, v27.Y);
            end;

            u9.moveVector = v26;
            MoveStick(p23.Position);
        end;
    end);
    u9.onTouchEndedConn = UserInputService.TouchEnded:Connect(function(p28, p29) -- Line: 187
        -- upvalues: u9 (copy)
        if p28 == u9.moveTouchObject then
            u9:OnInputEnded();
        end;
    end);
    GuiService.MenuOpened:Connect(function() -- Line: 193
        -- upvalues: u9 (copy)
        if u9.moveTouchObject then
            u9:OnInputEnded();
        end;
    end);
    u9.thumbstickFrame.Parent = u10;
end;

return u1;