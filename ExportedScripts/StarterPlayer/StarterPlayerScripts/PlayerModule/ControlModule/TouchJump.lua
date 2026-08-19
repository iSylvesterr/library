-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local GuiService = game:GetService("GuiService");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
local CharacterUtil = require(CommonUtils:WaitForChild("CharacterUtil"));
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"));
local u1 = setmetatable({}, BaseCharacterController);
u1.__index = u1;

function u1.new() -- Line: 50
    -- upvalues: BaseCharacterController (copy), u1 (copy), ConnectionUtil (copy)
    local v2 = BaseCharacterController.new();
    local v3 = setmetatable(v2, u1);
    v3.parentUIFrame = nil;
    v3.jumpButton = nil;
    v3.externallyEnabled = false;
    v3.isJumping = false;
    v3._active = false;
    v3._connectionUtil = ConnectionUtil.new();

    return v3;
end;

function u1._reset(p4) -- Line: 64
    p4.isJumping = false;
    p4.touchObject = nil;

    if p4.jumpButton then
        p4.jumpButton.ImageRectOffset = Vector2.new(1, 146);
    end;
end;

function u1.EnableButton(u5, p6) -- Line: 74
    -- upvalues: GuiService (copy)
    if p6 == u5._active then
        u5:_reset();

        return;
    end;

    if p6 then
        if not u5.jumpButton then
            u5:Create();
        end;

        u5.jumpButton.Visible = false;
        u5._connectionUtil:trackConnection("JUMP_INPUT_ENDED", u5.jumpButton.InputEnded:Connect(function(p7) -- Line: 92
            -- upvalues: u5 (copy)
            if p7 == u5.touchObject then
                u5:_reset();
            end;
        end));
        u5._connectionUtil:trackConnection("MENU_OPENED", GuiService.MenuOpened:Connect(function() -- Line: 102
            -- upvalues: u5 (copy)
            if u5.touchObject then
                u5:_reset();
            end;
        end));
    else
        if u5.jumpButton then
            u5.jumpButton.Visible = false;
        end;

        u5._connectionUtil:disconnect("JUMP_INPUT_ENDED");
        u5._connectionUtil:disconnect("MENU_OPENED");
    end;

    u5:_reset();
    u5._active = p6;
end;

function u1.UpdateEnabled(p8) -- Line: 119
    -- upvalues: CharacterUtil (copy)
    local v9 = CharacterUtil.getChild("Humanoid", "Humanoid");

    if v9 and (p8.externallyEnabled and (v9.JumpPower > 0 and v9:GetStateEnabled(Enum.HumanoidStateType.Jumping))) then
        p8:EnableButton(true);

        return;
    end;

    p8:EnableButton(false);
end;

function u1._setupConfigurations(u10) -- Line: 128
    -- upvalues: CharacterUtil (copy)
    local function update() -- Line: 129
        -- upvalues: u10 (copy)
        u10:UpdateEnabled();
    end;

    local v14 = CharacterUtil.onChild("Humanoid", "Humanoid", function(p11) -- Line: 134
        -- upvalues: u10 (copy), update (copy)
        u10:UpdateEnabled();
        u10._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", p11:GetPropertyChangedSignal("JumpPower"):Connect(update));
        u10._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p11.StateEnabledChanged:Connect(function(p12, p13) -- Line: 142
            -- upvalues: u10 (ref)
            if p12 == Enum.HumanoidStateType.Jumping and p13 ~= u10._active then
                u10:UpdateEnabled();
            end;
        end));
    end);
    u10._connectionUtil:trackConnection("HUMANOID", v14);
end;

function u1.Enable(p15, p16, p17) -- Line: 154
    if p17 then
        p15.parentUIFrame = p17;
    end;

    if p15.externallyEnabled == p16 then
        return;
    end;

    p15.externallyEnabled = p16;
    p15:UpdateEnabled();

    if p16 then
        p15:_setupConfigurations();

        return;
    end;

    p15._connectionUtil:disconnectAll();
end;

function u1.Create(u18) -- Line: 171
    if not u18.parentUIFrame then
        return;
    end;

    if u18.jumpButton then
        u18.jumpButton:Destroy();
        u18.jumpButton = nil;
    end;

    if u18.absoluteSizeChangedConn then
        u18.absoluteSizeChangedConn:Disconnect();
        u18.absoluteSizeChangedConn = nil;
    end;

    u18.jumpButton = Instance.new("ImageButton");
    u18.jumpButton.Name = "JumpButton";
    u18.jumpButton.Visible = false;
    u18.jumpButton.BackgroundTransparency = 1;
    u18.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
    u18.jumpButton.ImageRectOffset = Vector2.new(1, 146);
    u18.jumpButton.ImageRectSize = Vector2.new(144, 144);

    local function ResizeJumpButton() -- Line: 194
        -- upvalues: u18 (copy)
        local v19 = math.min(u18.parentUIFrame.AbsoluteSize.x, u18.parentUIFrame.AbsoluteSize.y) <= 500;
        local v20 = v19 and 70 or 120;
        u18.jumpButton.Size = UDim2.new(0, v20, 0, v20);
        u18.jumpButton.Position = v19 and UDim2.new(1, -(v20 * 1.5 - 10), 1, -v20 - 20) or UDim2.new(1, -(v20 * 1.5 - 10), 1, -v20 * 1.75);
    end;

    ResizeJumpButton();
    u18.absoluteSizeChangedConn = u18.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton);
    u18.touchObject = nil;
    u18.jumpButton.InputBegan:connect(function(p21) -- Line: 208
        -- upvalues: u18 (copy)
        if u18.touchObject or (p21.UserInputType ~= Enum.UserInputType.Touch or p21.UserInputState ~= Enum.UserInputState.Begin) then
            return;
        end;

        u18.touchObject = p21;
        u18.jumpButton.ImageRectOffset = Vector2.new(146, 146);
        u18.isJumping = true;
    end);
    u18.jumpButton.Parent = u18.parentUIFrame;
end;

return u1;