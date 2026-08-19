-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local GuiService = game:GetService("GuiService");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
local CharacterUtil = require(CommonUtils:WaitForChild("CharacterUtil"));
local u1 = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserTouchJumpHeightDisable");
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"));
local u2 = setmetatable({}, BaseCharacterController);
u2.__index = u2;

function u2.new() -- Line: 54
    -- upvalues: BaseCharacterController (copy), u2 (copy), ConnectionUtil (copy)
    local v3 = BaseCharacterController.new();
    local v4 = setmetatable(v3, u2);
    v4.parentUIFrame = nil;
    v4.jumpButton = nil;
    v4.externallyEnabled = false;
    v4.isJumping = false;
    v4._active = false;
    v4._connectionUtil = ConnectionUtil.new();

    return v4;
end;

function u2._reset(p5) -- Line: 68
    p5.isJumping = false;
    p5.touchObject = nil;

    if p5.jumpButton then
        p5.jumpButton.ImageRectOffset = Vector2.new(1, 146);
    end;
end;

function u2.EnableButton(u6, p7) -- Line: 79
    -- upvalues: u1 (copy), GuiService (copy)
    if p7 == u6._active then
        if not u1 then
            u6:_reset();
        end;

        return;
    end;

    if p7 then
        if not u6.jumpButton then
            u6:Create();
        end;

        u6.jumpButton.Visible = true;
        u6._connectionUtil:trackConnection("JUMP_INPUT_ENDED", u6.jumpButton.InputEnded:Connect(function(p8) -- Line: 97
            -- upvalues: u6 (copy)
            if p8 == u6.touchObject then
                u6:_reset();
            end;
        end));
        u6._connectionUtil:trackConnection("MENU_OPENED", GuiService.MenuOpened:Connect(function() -- Line: 107
            -- upvalues: u6 (copy)
            if u6.touchObject then
                u6:_reset();
            end;
        end));
    else
        if u6.jumpButton then
            u6.jumpButton.Visible = false;
        end;

        u6._connectionUtil:disconnect("JUMP_INPUT_ENDED");
        u6._connectionUtil:disconnect("MENU_OPENED");
    end;

    u6:_reset();
    u6._active = p7;
end;

function u2.UpdateEnabled(p9) -- Line: 124
    -- upvalues: CharacterUtil (copy), u1 (copy)
    local v10 = CharacterUtil.getChild("Humanoid", "Humanoid");

    if u1 then
        if v10 and p9.externallyEnabled and (v10.UseJumpPower and v10.JumpPower > 0 or not v10.UseJumpPower and v10.JumpHeight > 0) and v10:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
            p9:EnableButton(true);

            return;
        end;

        p9:EnableButton(false);

        return;
    end;

    if v10 and (p9.externallyEnabled and (v10.JumpPower > 0 and v10:GetStateEnabled(Enum.HumanoidStateType.Jumping))) then
        p9:EnableButton(true);

        return;
    end;

    p9:EnableButton(false);
end;

function u2._setupConfigurations(u11) -- Line: 141
    -- upvalues: CharacterUtil (copy), u1 (copy)
    local function update() -- Line: 142
        -- upvalues: u11 (copy)
        u11:UpdateEnabled();
    end;

    local v15 = CharacterUtil.onChild("Humanoid", "Humanoid", function(p12) -- Line: 147
        -- upvalues: u11 (copy), u1 (ref), update (copy)
        u11:UpdateEnabled();

        if u1 then
            u11:_reset();
        end;

        u11._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", p12:GetPropertyChangedSignal("JumpPower"):Connect(update));

        if u1 then
            u11._connectionUtil:trackConnection("HUMANOID_JUMP_HEIGHT", p12:GetPropertyChangedSignal("JumpHeight"):Connect(update));
        end;

        u11._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p12.StateEnabledChanged:Connect(function(p13, p14) -- Line: 164
            -- upvalues: u11 (ref)
            if p13 == Enum.HumanoidStateType.Jumping and p14 ~= u11._active then
                u11:UpdateEnabled();
            end;
        end));
    end);
    u11._connectionUtil:trackConnection("HUMANOID", v15);
end;

function u2.Enable(p16, p17, p18) -- Line: 176
    if p18 then
        p16.parentUIFrame = p18;
    end;

    if p16.externallyEnabled == p17 then
        return;
    end;

    p16.externallyEnabled = p17;
    p16:UpdateEnabled();

    if p17 then
        p16:_setupConfigurations();

        return;
    end;

    p16._connectionUtil:disconnectAll();
end;

function u2.Create(u19) -- Line: 193
    if not u19.parentUIFrame then
        return;
    end;

    if u19.jumpButton then
        u19.jumpButton:Destroy();
        u19.jumpButton = nil;
    end;

    if u19.absoluteSizeChangedConn then
        u19.absoluteSizeChangedConn:Disconnect();
        u19.absoluteSizeChangedConn = nil;
    end;

    u19.jumpButton = Instance.new("ImageButton");
    u19.jumpButton.Name = "JumpButton";
    u19.jumpButton.Visible = false;
    u19.jumpButton.BackgroundTransparency = 1;
    u19.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
    u19.jumpButton.ImageRectOffset = Vector2.new(1, 146);
    u19.jumpButton.ImageRectSize = Vector2.new(144, 144);

    local function ResizeJumpButton() -- Line: 216
        -- upvalues: u19 (copy)
        local v20 = math.min(u19.parentUIFrame.AbsoluteSize.x, u19.parentUIFrame.AbsoluteSize.y) <= 500;
        local v21 = v20 and 70 or 120;
        u19.jumpButton.Size = UDim2.new(0, v21, 0, v21);
        u19.jumpButton.Position = v20 and UDim2.new(1, -(v21 * 1.5 - 10), 1, -v21 - 20) or UDim2.new(1, -(v21 * 1.5 - 10), 1, -v21 * 1.75);
    end;

    ResizeJumpButton();
    u19.absoluteSizeChangedConn = u19.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton);
    u19.touchObject = nil;
    u19.jumpButton.InputBegan:connect(function(p22) -- Line: 230
        -- upvalues: u19 (copy)
        if u19.touchObject or (p22.UserInputType ~= Enum.UserInputType.Touch or p22.UserInputState ~= Enum.UserInputState.Begin) then
            return;
        end;

        u19.touchObject = p22;
        u19.jumpButton.ImageRectOffset = Vector2.new(146, 146);
        u19.isJumping = true;
    end);
    u19.jumpButton.Parent = u19.parentUIFrame;
end;

return u2;