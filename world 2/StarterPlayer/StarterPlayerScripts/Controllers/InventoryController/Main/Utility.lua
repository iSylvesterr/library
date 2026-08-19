-- Decompiled with Potassium's decompiler.

local u1 = Color3.fromRGB(0, 162, 255);
local u2 = Color3.fromRGB(78, 84, 96);
local u3 = Color3.fromRGB(204, 204, 204);
local u4 = Color3.fromRGB(255, 255, 255);
local u5 = Color3.fromRGB(150, 150, 150);
local HttpService = game:GetService("HttpService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local RunService = game:GetService("RunService");
local PlayerGui = game.Players.LocalPlayer.PlayerGui;
PlayerGui:WaitForChild("BackpackGui");
local ContextActionService = game:GetService("ContextActionService");
local VRService = game:GetService("VRService");
local success, result = pcall(function() -- Line: 39
    return false;
end);
local u6 = success and result;
local u11 = {
    Create = function(u7) -- Line: 48, Name: Create
        return function(p8) -- Line: 49
            -- upvalues: u7 (copy)
            local v9 = Instance.new(u7);
            local v10 = nil;

            for i, v in pairs(p8) do
                if type(i) == "number" then
                    v.Parent = v9;
                elseif i == "Parent" then
                    v10 = v;
                else
                    v9[i] = v;
                end;
            end;

            if v10 then
                v9.Parent = v10;
            end;

            return v9;
        end;
    end
};
local u12 = {};
setmetatable(u12, {
    __mode = "k"
});
local u13 = u11.Create("ImageLabel")({
    Image = "",
    BackgroundTransparency = 1
});

function clamp(p14, p15, p16)
    local v17 = math.min(p15, p16);

    return math.max(p14, v17);
end;

function ClampVector2(p18, p19, p20)
    return Vector2.new(clamp(p18.x, p19.x, p20.x), clamp(p18.y, p19.y, p20.y));
end;

local function Linear(p21, p22, p23, p24) -- Line: 90
    if p24 <= p21 then
        return p22 + p23;
    end;

    return p23 * p21 / p24 + p22;
end;

local function EaseOutQuad(p25, p26, p27, p28) -- Line: 98
    if p28 <= p25 then
        return p26 + p27;
    end;

    local v29 = p25 / p28;

    return p26 - p27 * v29 * (v29 - 2);
end;

local function EaseInOutQuad(p30, p31, p32, p33) -- Line: 107
    if p33 <= p30 then
        return p31 + p32;
    end;

    local v34 = p30 / p33;

    if v34 < 0.5 then
        return 2 * p32 * v34 * v34 + p31;
    end;

    return p31 + p32 * (2 * (2 - v34) * v34 - 1);
end;

function PropertyTweener(u35, u36, u37, u38, u39, u40, u41)
    -- upvalues: RunService (copy)
    local u42 = {
        StartTime = tick()
    };
    u42.EndTime = u42.StartTime + u39;
    u42.Cancelled = false;
    local u43 = false;
    local u44 = 0;

    local function finalize() -- Line: 128
        -- upvalues: u35 (copy), u36 (copy), u40 (copy), u37 (copy), u38 (copy), u43 (ref), u44 (ref), u41 (copy)
        if u35 then
            u35[u36] = u40(1, u37, u38 - u37, 1);
        end;

        u43 = true;
        u44 = 1;

        if u41 then
            u41();
        end;
    end;

    u35[u36] = u40(0, u37, u38 - u37, u39);
    coroutine.wrap(function() -- Line: 141
        -- upvalues: u42 (copy), u35 (copy), u36 (copy), u40 (copy), u37 (copy), u38 (copy), u39 (copy), u44 (ref), RunService (ref), u43 (ref), u41 (copy)
        local v45 = tick();

        while v45 < u42.EndTime and u35 do
            if u42.Cancelled then
                return;
            end;

            u35[u36] = u40(v45 - u42.StartTime, u37, u38 - u37, u39);
            u44 = clamp(0, 1, (v45 - u42.StartTime) / u39);
            RunService.RenderStepped:wait();
            v45 = tick();
        end;

        if u42.Cancelled == false and u35 then
            if u35 then
                u35[u36] = u40(1, u37, u38 - u37, 1);
            end;

            u43 = true;
            u44 = 1;

            if u41 then
                u41();
            end;
        end;
    end)();

    function u42.GetFinal(p46) -- Line: 157
        -- upvalues: u38 (copy)
        return u38;
    end;

    function u42.GetPercentComplete(p47) -- Line: 161
        -- upvalues: u44 (ref)
        return u44;
    end;

    function u42.IsFinished(p48) -- Line: 165
        -- upvalues: u43 (ref)
        return u43;
    end;

    function u42.Finish(p49) -- Line: 169
        -- upvalues: u43 (ref), u35 (copy), u36 (copy), u40 (copy), u37 (copy), u38 (copy), u44 (ref), u41 (copy)
        if not u43 then
            p49:Cancel();

            if u35 then
                u35[u36] = u40(1, u37, u38 - u37, 1);
            end;

            u43 = true;
            u44 = 1;

            if u41 then
                u41();
            end;
        end;
    end;

    function u42.Cancel(p50) -- Line: 176
        -- upvalues: u42 (copy)
        u42.Cancelled = true;
    end;

    return u42;
end;

local function CreateSignal() -- Line: 185
    local v51 = {};
    local BindableEvent = Instance.new("BindableEvent");
    local u52 = nil;
    local u53 = nil;

    function v51.fire(p54, ...) -- Line: 193
        -- upvalues: u52 (ref), u53 (ref), BindableEvent (copy)
        u52 = { ... };
        u53 = select("#", ...);
        BindableEvent:Fire();
    end;

    function v51.connect(p55, u56) -- Line: 199
        -- upvalues: BindableEvent (copy), u52 (ref), u53 (ref)
        if not u56 then
            error("connect(nil)", 2);
        end;

        return BindableEvent.Event:Connect(function() -- Line: 201
            -- upvalues: u56 (copy), u52 (ref), u53 (ref)
            u56(unpack(u52, 1, u53));
        end);
    end;

    function v51.wait(p57) -- Line: 206
        -- upvalues: BindableEvent (copy), u52 (ref), u53 (ref)
        BindableEvent.Event:wait();

        if not u52 then
            error("Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.");
        end;

        return unpack(u52, 1, u53);
    end;

    return v51;
end;

local function getViewportSize() -- Line: 217
    while not workspace.CurrentCamera do
        workspace.Changed:wait();
    end;

    while workspace.CurrentCamera.ViewportSize == Vector2.new(0, 0) or workspace.CurrentCamera.ViewportSize == Vector2.new(1, 1) do
        workspace.CurrentCamera.Changed:wait();
    end;

    return workspace.CurrentCamera.ViewportSize;
end;

local function isSmallTouchScreen() -- Line: 232
    -- upvalues: getViewportSize (copy), UserInputService (copy)
    local v58 = getViewportSize();

    return UserInputService.TouchEnabled and (v58.Y < 500 and true or v58.X < 700);
end;

local function isPortrait() -- Line: 237
    -- upvalues: getViewportSize (copy)
    local v59 = getViewportSize();

    return v59.Y > v59.X;
end;

local function isTenFootInterface() -- Line: 242
    return false;
end;

local function usesSelectedObject() -- Line: 246
    -- upvalues: VRService (copy), UserInputService (copy)
    if VRService.VREnabled then
        return false;
    end;

    return (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
end;

local function isPosOverGui(p60, p61, p62) -- Line: 255
    local x = p61.AbsolutePosition.x;
    local y = p61.AbsolutePosition.y;
    local v63 = y + p61.AbsoluteSize.y;
    local v64;

    if x < p60.x and (p60.x < x + p61.AbsoluteSize.x and y < p60.y) then
        v64 = p60.y < v63;
    else
        v64 = false;
    end;

    return v64;
end;

local function isPosOverGuiWithClipping(p65, p66) -- Line: 263
    local x = p66.AbsolutePosition.x;
    local y = p66.AbsolutePosition.y;
    local v67 = y + p66.AbsoluteSize.y;
    local v68;

    if x < p65.x and (p65.x < x + p66.AbsoluteSize.x and y < p65.y) then
        v68 = p65.y < v67;
    else
        v68 = false;
    end;

    if not v68 then
        return false;
    end;

    local v69;

    while true do
        if p66 == nil or not (p66:IsA("GuiObject") or p66:IsA("LayerCollector")) then
            v69 = not (p66 and p66:IsA("CoreGui"));
            break;
        end;

        if p66:IsA("GuiObject") and not p66.Visible then
            v69 = true;
            break;
        end;

        if p66:IsA("LayerCollector") or p66.ClipsDescendants then
            local x2 = p66.AbsolutePosition.x;
            local y2 = p66.AbsolutePosition.y;
            local v70 = y2 + p66.AbsoluteSize.y;
            local v71;

            if x2 < p65.x and (p65.x < x2 + p66.AbsoluteSize.x and y2 < p65.y) then
                v71 = p65.y < v70;
            else
                v71 = false;
            end;

            if not v71 then
                v69 = true;
                break;
            end;
        end;

        p66 = p66.Parent;
    end;

    return not v69;
end;

local function areGuisIntersecting(p72, p73) -- Line: 296
    local x = p72.AbsolutePosition.x;
    local y = p72.AbsolutePosition.y;
    local v74 = x + p72.AbsoluteSize.x;
    local v75 = y + p72.AbsoluteSize.y;
    local x2 = p73.AbsolutePosition.x;
    local y2 = p73.AbsolutePosition.y;
    local v76;

    if x < x2 + p73.AbsoluteSize.x then
        v76 = x2 < v74;
    else
        v76 = false;
    end;

    local v77;

    if y < y2 + p73.AbsoluteSize.y then
        v77 = y2 < v75;
    else
        v77 = false;
    end;

    return v76 and v77;
end;

local function isGuiVisible(p78, p79) -- Line: 311
    local v80 = p78;
    local v81;

    while true do
        if p78 == nil or not (p78:IsA("GuiObject") or p78:IsA("LayerCollector")) then
            v81 = not (p78 and p78:IsA("CoreGui"));
            break;
        end;

        if p78:IsA("GuiObject") and not p78.Visible then
            v81 = true;
            break;
        end;

        if p78:IsA("LayerCollector") or p78.ClipsDescendants then
            local x = p78.AbsolutePosition.x;
            local y = p78.AbsolutePosition.y;
            local v82 = x + p78.AbsoluteSize.x;
            local v83 = y + p78.AbsoluteSize.y;
            local x2 = v80.AbsolutePosition.x;
            local y2 = v80.AbsolutePosition.y;
            local v84;

            if x < x2 + v80.AbsoluteSize.x then
                v84 = x2 < v82;
            else
                v84 = false;
            end;

            local v85;

            if y < y2 + v80.AbsoluteSize.y then
                v85 = y2 < v83;
            else
                v85 = false;
            end;

            if not (v84 and v85) then
                v81 = true;
                break;
            end;
        end;

        p78 = p78.Parent;
    end;

    return not v81;
end;

local function addHoverState(u86, u87, u88, u89) -- Line: 340
    local function onNormalButtonStateCallback() -- Line: 341
        -- upvalues: u86 (copy), u88 (copy), u87 (copy)
        if u86.Active then
            u88(u87);
        end;
    end;

    local function onHoverButtonStateCallback() -- Line: 346
        -- upvalues: u86 (copy), u89 (copy), u87 (copy)
        if u86.Active then
            u89(u87);
        end;
    end;

    u86.MouseEnter:Connect(onHoverButtonStateCallback);
    u86.SelectionGained:Connect(onHoverButtonStateCallback);
    u86.MouseLeave:Connect(onNormalButtonStateCallback);
    u86.SelectionLost:Connect(onNormalButtonStateCallback);
    u88(u87);
end;

local function addOnResizedCallback(p90, p91) -- Line: 360
    -- upvalues: u12 (copy), getViewportSize (copy)
    u12[p90] = p91;
    local v92 = getViewportSize();
    local v93 = getViewportSize();
    p91(v92, v93.Y > v93.X);
end;

local u94 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
};

local function MakeDefaultButton(p95, p96, u97, u98, u99) -- Line: 376
    -- upvalues: u11 (copy), u94 (copy), UserInputService (copy), GuiService (copy), VRService (copy)
    local v100 = u11.Create("ImageLabel")({
        Image = "",
        BackgroundTransparency = 1
    });
    local u101 = u11.Create("ImageButton")({
        Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        ZIndex = 2,
        Name = p95 .. "Button",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(8, 6, 46, 44),
        Size = p96,
        SelectionImageObject = v100
    });
    u11.Create("BoolValue")({
        Name = "Enabled",
        Value = true,
        Parent = u101
    });

    if u97 then
        u101.MouseButton1Click:Connect(function() -- Line: 404
            -- upvalues: u97 (copy), u94 (ref), UserInputService (ref)
            u97(u94[UserInputService:GetLastInputType()] or false);
        end);
    end;

    local function isPointerInput(p102) -- Line: 409
        return p102.UserInputType == Enum.UserInputType.MouseMovement and true or p102.UserInputType == Enum.UserInputType.Touch;
    end;

    local u103 = nil;

    local function setRowRef(p104) -- Line: 414
        -- upvalues: u103 (ref)
        u103 = p104;
    end;

    local function selectButton() -- Line: 418
        -- upvalues: u99 (copy), u98 (copy), u101 (copy), u103 (ref)
        local v105 = u99;

        if v105 == nil and u98 then
            v105 = u98.HubRef;
        end;

        if v105 and v105.Active or v105 == nil then
            u101.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png";
            local v106 = u101;

            if u103 then
                v106 = u103;
            end;

            if v105 then
                v105:ScrollToFrame(v106);
            end;
        end;
    end;

    local function deselectButton() -- Line: 439
        -- upvalues: u101 (copy)
        u101.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png";
    end;

    u101.InputBegan:Connect(function(p107) -- Line: 443
        -- upvalues: u101 (copy), u99 (copy), u98 (copy), u103 (ref)
        if u101.Selectable and (p107.UserInputType == Enum.UserInputType.MouseMovement or p107.UserInputType == Enum.UserInputType.Touch) then
            local v108 = u99;

            if v108 == nil and u98 then
                v108 = u98.HubRef;
            end;

            if v108 and v108.Active or v108 == nil then
                u101.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png";
                local v109 = u101;

                if u103 then
                    v109 = u103;
                end;

                if v108 then
                    v108:ScrollToFrame(v109);
                end;
            end;
        end;
    end);
    u101.InputEnded:Connect(function(p110) -- Line: 448
        -- upvalues: u101 (copy), GuiService (ref)
        if u101.Selectable and GuiService.SelectedCoreObject ~= u101 and (p110.UserInputType == Enum.UserInputType.MouseMovement or p110.UserInputType == Enum.UserInputType.Touch) then
            u101.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png";
        end;
    end);
    u101.SelectionGained:Connect(function() -- Line: 455
        -- upvalues: u99 (copy), u98 (copy), u101 (copy), u103 (ref)
        local v111 = u99;

        if v111 == nil and u98 then
            v111 = u98.HubRef;
        end;

        if v111 and v111.Active or v111 == nil then
            u101.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png";
            local v112 = u101;

            if u103 then
                v112 = u103;
            end;

            if v111 then
                v111:ScrollToFrame(v112);
            end;
        end;
    end);
    u101.SelectionLost:Connect(function() -- Line: 458
        -- upvalues: u101 (copy)
        u101.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png";
    end);
    GuiService.Changed:Connect(function(p113) -- Line: 462
        -- upvalues: VRService (ref), UserInputService (ref), GuiService (ref), u101 (copy), u99 (copy), u98 (copy), u103 (ref)
        if p113 ~= "SelectedCoreObject" then
            return;
        end;

        local v114;

        if VRService.VREnabled then
            v114 = false;
        else
            v114 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
        end;

        if not v114 then
            return;
        end;

        if GuiService.SelectedCoreObject == nil or GuiService.SelectedCoreObject ~= u101 then
            u101.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png";

            return;
        end;

        if u101.Selectable then
            local v115 = u99;

            if v115 == nil and u98 then
                v115 = u98.HubRef;
            end;

            if v115 and v115.Active or v115 == nil then
                u101.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png";
                local v116 = u101;

                if u103 then
                    v116 = u103;
                end;

                if v115 then
                    v115:ScrollToFrame(v116);
                end;
            end;
        end;
    end);

    return u101, setRowRef;
end;

local function MakeButton(p117, p118, p119, p120, p121, p122) -- Line: 479
    -- upvalues: MakeDefaultButton (copy), u11 (copy), getViewportSize (copy), UserInputService (copy)
    local v123, v124 = MakeDefaultButton(p117, p119, p120, p121, p122);
    local v125 = u11.Create("TextLabel")({
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 24,
        TextScaled = true,
        TextWrapped = true,
        ZIndex = 2,
        Name = p117 .. "TextLabel",
        Size = UDim2.new(1, 0, 1, -8),
        Position = UDim2.new(0, 0, 0, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextYAlignment = Enum.TextYAlignment.Center,
        Font = Enum.Font.SourceSansBold,
        Text = p118,
        Parent = v123
    });
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", v125);
    local v126 = getViewportSize();

    if UserInputService.TouchEnabled and (v126.Y < 500 and true or v126.X < 700) then
        v125.TextSize = 18;
    elseif false then
        v125.TextSize = 36;
    end;

    UITextSizeConstraint.MaxTextSize = v125.TextSize;

    return v123, v125, v124;
end;

local function MakeImageButton(p127, p128, p129, p130, p131, p132, p133) -- Line: 511
    -- upvalues: MakeDefaultButton (copy), u11 (copy)
    local v134, v135 = MakeDefaultButton(p127, p129, p131, p132, p133);

    return v134, u11.Create("ImageLabel")({
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2,
        Name = p127 .. "ImageLabel",
        Size = p130,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = p128,
        Parent = v134
    }), v135;
end;

local function AddButtonRow(p136, p137, p138, p139, p140, p141) -- Line: 530
    -- upvalues: MakeButton (copy), u11 (copy)
    local v142, v143, v144 = MakeButton(p137, p138, p139, p140, p136, p141);
    local v145 = u11.Create("Frame")({
        BackgroundTransparency = 1,
        Name = p137 .. "Row",
        Size = UDim2.new(1, 0, p139.Y.Scale, p139.Y.Offset),
        Parent = p136.Page
    });
    v142.Parent = v145;
    v142.AnchorPoint = Vector2.new(1, 0);
    v142.Position = UDim2.new(1, -20, 0, 0);

    return v145, v142, v143, v144;
end;

local function CreateDropDown(p146, u147, u148) -- Line: 545
    -- upvalues: HttpService (copy), u11 (copy), PlayerGui (copy), VRService (copy), UserInputService (copy), GuiService (copy), ContextActionService (copy), MakeButton (copy)
    local u149 = Color3.fromRGB(178, 178, 178);
    local u150 = Color3.fromRGB(229, 229, 229);
    local u151 = Color3.fromRGB(255, 255, 255);
    local u152 = nil;
    local u153 = {
        CurrentIndex = nil
    };
    Instance.new("BindableEvent").Name = "IndexChanged";

    if type(p146) ~= "table" then
        error("CreateDropDown dropDownStringTable (first arg) is not a table", 2);

        return u153;
    end;

    local BindableEvent = Instance.new("BindableEvent");
    BindableEvent.Name = "IndexChanged";
    local u154 = true;
    local u155 = HttpService:GenerateGUID(false);
    local u156 = nil;
    local u157 = p146;
    local u158 = u11.Create("ImageButton")({
        Name = "DropDownFullscreenFrame",
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 10,
        Active = true,
        Visible = false,
        Selectable = false,
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Parent = PlayerGui.RobloxGui
    });

    local function onVREnabled(p159) -- Line: 592
        -- upvalues: VRService (ref), PlayerGui (ref), u158 (copy), u153 (copy), u157 (ref)
        if p159 ~= "VREnabled" then
            return;
        end;

        if VRService.VREnabled then
            u158.Parent = require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu"):GetGUI();
            u158.BackgroundTransparency = 1;
        else
            u158.Parent = PlayerGui.RobloxGui;
            u158.BackgroundTransparency = 0.2;
        end;

        if u153.UpdateDropDownList then
            u153:UpdateDropDownList(u157);
        end;
    end;

    VRService.Changed:Connect(onVREnabled);
    onVREnabled("VREnabled");
    local u160 = u11.Create("ImageLabel")({
        Name = "DropDownSelectionFrame",
        Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
        BackgroundTransparency = 1,
        ZIndex = 10,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(8, 6, 46, 44),
        Size = UDim2.new(0.6, 0, 0.9, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = u158
    });
    local u161 = u11.Create("ScrollingFrame")({
        Name = "DropDownScrollingFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        Size = UDim2.new(1, -20, 1, -25),
        Position = UDim2.new(0, 10, 0, 10),
        Parent = u160
    });
    local u162 = nil;
    local u163 = false;

    local function u167(p164, p165) -- Line: 640
        -- upvalues: u153 (copy), u154 (ref), u148 (copy), u158 (copy), VRService (ref), UserInputService (ref), GuiService (ref), u152 (ref), u162 (ref), ContextActionService (ref), u155 (copy), u156 (ref), u163 (ref), PlayerGui (ref)
        if p164 ~= nil and p165 ~= Enum.UserInputState.Begin then
            return;
        end;

        u153.DropDownFrame.Selectable = u154;
        u148:SetActive(true);

        if u158.Visible then
            local v166;

            if VRService.VREnabled then
                v166 = false;
            else
                v166 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v166 then
                GuiService.SelectedCoreObject = u152;
            end;
        end;

        u158.Visible = false;

        if u162 then
            u162:Disconnect();
        end;

        ContextActionService:UnbindAction(u155 .. "Action");
        ContextActionService:UnbindAction(u155 .. "FreezeAction");
        u156.Value = u154;
        u163 = false;

        if VRService.VREnabled then
            require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu"):SetSubpanelDepth(u158, 0);
        end;
    end;

    local function u168() -- Line: 664
    end;

    local function u169() -- Line: 666
        -- upvalues: u154 (ref), u153 (copy), u163 (ref), u158 (copy), VRService (ref), PlayerGui (ref), u152 (ref), GuiService (ref), u162 (ref), u151 (copy), u150 (copy), u149 (copy), ContextActionService (ref), u155 (copy), u168 (copy), u167 (copy), u148 (copy), u156 (ref)
        if not u154 then
            return;
        end;

        u153.DropDownFrame.Selectable = false;
        u163 = true;
        u158.Visible = true;

        if VRService.VREnabled then
            require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu"):SetSubpanelDepth(u158, 0.5);
        end;

        u152 = u153.DropDownFrame;

        if u153.CurrentIndex and u153.CurrentIndex > 0 then
            GuiService.SelectedCoreObject = u153.Selections[u153.CurrentIndex];
        end;

        u162 = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- Line: 683
            -- upvalues: u153 (ref), GuiService (ref), u151 (ref), VRService (ref), u150 (ref), u149 (ref)
            for i = 1, #u153.Selections do
                if GuiService.SelectedCoreObject == u153.Selections[i] then
                    u153.Selections[i].TextColor3 = u151;
                else
                    u153.Selections[i].TextColor3 = VRService.VREnabled and u150 or u149;
                end;
            end;
        end);
        ContextActionService:BindActionAtPriority(u155 .. "FreezeAction", u168, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.Keyboard, Enum.UserInputType.Gamepad1);
        ContextActionService:BindActionAtPriority(u155 .. "Action", u167, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape);
        u148:SetActive(false);
        u156.Value = false;
    end;

    u153.DropDownFrame = MakeButton("DropDownFrame", "Choose One", UDim2.new(0.6, 0, 0, 50), u169, nil, u148);
    u153.DropDownFrame.Position = UDim2.new(1, 0, 0.5, 0);
    u153.DropDownFrame.AnchorPoint = Vector2.new(1, 0.5);
    u156 = u153.DropDownFrame.Enabled;
    local DropDownFrameTextLabel = u153.DropDownFrame.DropDownFrameTextLabel;
    DropDownFrameTextLabel.Position = UDim2.new(0, 15, 0, 0);
    DropDownFrameTextLabel.Size = UDim2.new(1, -50, 1, -8);
    DropDownFrameTextLabel.ClipsDescendants = true;
    DropDownFrameTextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    local u170 = u11.Create("ImageLabel")({
        Name = "DropDownImage",
        Image = "rbxasset://textures/ui/Settings/DropDown/DropDown.png",
        BackgroundTransparency = 1,
        ZIndex = 2,
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 15, 0, 10),
        Position = UDim2.new(1, -12, 0.5, 0),
        Parent = u153.DropDownFrame
    });
    u153.DropDownImage = u170;

    local function setSelection(p171) -- Line: 727
        -- upvalues: u153 (copy), DropDownFrameTextLabel (copy), BindableEvent (copy)
        local v172 = false;

        for i, v in pairs(u153.Selections) do
            if i == p171 then
                DropDownFrameTextLabel.Text = v.Text;
                u153.CurrentIndex = i;
                v172 = true;
            end;
        end;

        if v172 then
            BindableEvent:Fire(p171);
        end;
    end;

    local function setSelectionByValue(p173) -- Line: 743
        -- upvalues: u153 (copy), DropDownFrameTextLabel (copy), BindableEvent (copy)
        local v174 = false;

        for i, v in pairs(u153.Selections) do
            if v.Text == p173 then
                DropDownFrameTextLabel.Text = v.Text;
                u153.CurrentIndex = i;
                v174 = true;
            end;
        end;

        if v174 then
            BindableEvent:Fire(u153.CurrentIndex);
        end;

        return v174;
    end;

    local u175 = false;

    local function processInput(p176) -- Line: 761
        -- upvalues: GuiService (ref), u153 (copy), u175 (ref), u169 (copy)
        if p176.UserInputState == Enum.UserInputState.Begin then
            if p176.KeyCode == Enum.KeyCode.Return and (GuiService.SelectedCoreObject == u153.DropDownFrame or u153.SelectionInfo and u153.SelectionInfo[GuiService.SelectedCoreObject]) then
                u175 = true;
            end;
        elseif p176.UserInputState == Enum.UserInputState.End and (p176.KeyCode == Enum.KeyCode.Return and u175) then
            u175 = false;

            if GuiService.SelectedCoreObject == u153.DropDownFrame then
                u169();

                return;
            end;

            if u153.SelectionInfo and u153.SelectionInfo[GuiService.SelectedCoreObject] then
                u153.SelectionInfo[GuiService.SelectedCoreObject].Clicked();
            end;
        end;
    end;

    local function setIsFaded(p177) -- Line: 781
        -- upvalues: u153 (copy)
        if p177 then
            u153.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0.5;
            u153.DropDownFrame.ImageTransparency = 0.5;
            u153.DropDownImage.ImageTransparency = 0.5;

            return;
        end;

        u153.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0;
        u153.DropDownFrame.ImageTransparency = 0;
        u153.DropDownImage.ImageTransparency = 0;
    end;

    u153.IndexChanged = BindableEvent.Event;

    function u153.SetSelectionIndex(p178, p179) -- Line: 797
        -- upvalues: setSelection (copy)
        setSelection(p179);
    end;

    function u153.SetSelectionByValue(p180, p181) -- Line: 801
        -- upvalues: setSelectionByValue (copy)
        return setSelectionByValue(p181);
    end;

    function u153.ResetSelectionIndex(p182) -- Line: 805
        -- upvalues: u153 (copy), DropDownFrameTextLabel (copy), u167 (copy)
        u153.CurrentIndex = nil;
        DropDownFrameTextLabel.Text = "Choose One";
        u167();
    end;

    function u153.GetSelectedIndex(p183) -- Line: 811
        -- upvalues: u153 (copy)
        return u153.CurrentIndex;
    end;

    function u153.SetZIndex(p184, p185) -- Line: 815
        -- upvalues: u153 (copy), u170 (copy), DropDownFrameTextLabel (copy)
        u153.DropDownFrame.ZIndex = p185;
        u170.ZIndex = p185;
        DropDownFrameTextLabel.ZIndex = p185;
    end;

    function u153.SetInteractable(p186, p187) -- Line: 821
        -- upvalues: u154 (ref), u153 (copy), u167 (copy), VRService (ref), u156 (ref), u163 (ref)
        u154 = p187;
        u153.DropDownFrame.Selectable = u154;

        if u154 then
            u153.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0;
            u153.DropDownFrame.ImageTransparency = 0;
            u153.DropDownImage.ImageTransparency = 0;

            if not VRService.VREnabled then
                u153:SetZIndex(2);
            end;
        else
            u167();

            if VRService.VREnabled then
                u153.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0.5;
                u153.DropDownFrame.ImageTransparency = 0.5;
                u153.DropDownImage.ImageTransparency = 0.5;
            else
                u153.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0;
                u153.DropDownFrame.ImageTransparency = 0;
                u153.DropDownImage.ImageTransparency = 0;
            end;

            if not VRService.VREnabled then
                u153:SetZIndex(1);
            end;
        end;

        if p187 then
            p187 = not u163;
        end;

        u156.Value = p187;
    end;

    function u153.UpdateDropDownList(p188, p189) -- Line: 842
        -- upvalues: u157 (ref), u153 (copy), VRService (ref), u11 (ref), u150 (copy), u149 (copy), u161 (copy), u147 (copy), DropDownFrameTextLabel (copy), u151 (copy), u167 (copy), BindableEvent (copy), UserInputService (ref), GuiService (ref), u155 (copy), u158 (copy), u160 (copy)
        u157 = p189;

        if u153.Selections then
            for i = 1, #u153.Selections do
                u153.Selections[i]:Destroy();
            end;
        end;

        u153.Selections = {};
        u153.SelectionInfo = {};
        local VREnabled = VRService.VREnabled;
        local v190 = VREnabled and Enum.Font.SourceSansBold or Enum.Font.SourceSans;
        local v191 = VREnabled and 70 or 50;
        local v192 = v191 + 1;
        local v193 = VREnabled and 36 or 24;
        local u194 = VREnabled and 600 or 400;

        for i, v in pairs(p189) do
            local v195 = u11.Create("Frame")({
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0)
            });
            local u196 = u11.Create("TextButton")({
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                ZIndex = 10,
                Name = "Selection" .. tostring(i),
                Size = UDim2.new(1, -28, 0, v191),
                Position = UDim2.new(0, 14, 0, (i - 1) * v192),
                TextColor3 = VRService.VREnabled and u150 or u149,
                Font = v190,
                TextSize = v193,
                Text = v,
                SelectionImageObject = v195,
                Parent = u161
            });

            if i == u147 then
                u153.CurrentIndex = i;
                DropDownFrameTextLabel.Text = v;
                u196.TextColor3 = u151;
            elseif not u147 and i == 1 then
                u196.TextColor3 = u151;
            end;

            local function v197() -- Line: 896
                -- upvalues: DropDownFrameTextLabel (ref), u196 (copy), u167 (ref), u153 (ref), i (copy), BindableEvent (ref)
                DropDownFrameTextLabel.Text = u196.Text;
                u167();
                u153.CurrentIndex = i;
                BindableEvent:Fire(i);
            end;

            u196.MouseButton1Click:Connect(v197);
            u196.MouseEnter:Connect(function() -- Line: 905
                -- upvalues: VRService (ref), UserInputService (ref), GuiService (ref), u196 (copy)
                local v198;

                if VRService.VREnabled then
                    v198 = false;
                else
                    v198 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
                end;

                if v198 then
                    GuiService.SelectedCoreObject = u196;
                end;
            end);
            u153.Selections[i] = u196;
            u153.SelectionInfo[u196] = {
                Clicked = v197
            };
        end;

        GuiService:RemoveSelectionGroup(u155);
        GuiService:AddSelectionTuple(u155, unpack(u153.Selections));
        u161.CanvasSize = UDim2.new(1, -20, 0, #p189 * v192);

        local function updateDropDownSize() -- Line: 920
            -- upvalues: u161 (ref), u158 (ref), u160 (ref), u194 (copy)
            if u161.CanvasSize.Y.Offset < u158.AbsoluteSize.Y - 10 then
                u160.Size = UDim2.new(0, u194, 0, u161.CanvasSize.Y.Offset + 25);

                return;
            end;

            u160.Size = UDim2.new(0, u194, 0.9, 0);
        end;

        u158.Changed:Connect(function(p199) -- Line: 929
            -- upvalues: updateDropDownSize (copy)
            if p199 ~= "AbsoluteSize" then
                return;
            end;

            updateDropDownSize();
        end);
        updateDropDownSize();
    end;

    u153:UpdateDropDownList(p146);
    u158.MouseButton1Click:Connect(u167);
    u148.PoppedMenu:Connect(function(p200) -- Line: 942
        -- upvalues: u158 (copy), u167 (copy)
        if p200 == u158 then
            u167();
        end;
    end);

    return u153;
end;

local function CreateSelector(p201, u202) -- Line: 952
    -- upvalues: u11 (copy), u13 (copy), u3 (copy), UserInputService (copy), u4 (copy), addHoverState (copy), VRService (copy), GuiService (copy), EaseOutQuad (copy), u5 (copy), u12 (copy), getViewportSize (copy)
    local u203 = 0;
    local u204 = {
        HubRef = nil
    };

    if type(p201) ~= "table" then
        error("CreateSelector selectionStringTable (first arg) is not a table", 2);

        return u204;
    end;

    local BindableEvent = Instance.new("BindableEvent");
    BindableEvent.Name = "IndexChanged";
    local u205 = true;
    u204.CurrentIndex = 0;
    u204.SelectorFrame = u11.Create("ImageButton")({
        Name = "Selector",
        Image = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        ZIndex = 2,
        NextSelectionLeft = u204.SelectorFrame,
        NextSelectionRight = u204.SelectorFrame,
        Size = UDim2.new(0.6, 0, 0, 50),
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        SelectionImageObject = u13
    });
    local u206 = u11.Create("ImageButton")({
        Name = "LeftButton",
        BackgroundTransparency = 1,
        Image = "",
        ZIndex = 3,
        Selectable = false,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0, 50, 0, 50),
        SelectionImageObject = u13,
        Parent = u204.SelectorFrame
    });
    local u207 = u11.Create("ImageButton")({
        Name = "RightButton",
        BackgroundTransparency = 1,
        Image = "",
        ZIndex = 3,
        Selectable = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 50, 0, 50),
        SelectionImageObject = u13,
        Parent = u204.SelectorFrame
    });
    local u208 = u11.Create("ImageLabel")({
        Name = "LeftButton",
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/Settings/Slider/Left.png",
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 18, 0, 30),
        ImageColor3 = u3,
        Parent = u206
    });
    local u209 = u11.Create("ImageLabel")({
        Name = "RightButton",
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/Settings/Slider/Right.png",
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 18, 0, 30),
        ImageColor3 = u3,
        Parent = u207
    });

    if not UserInputService.TouchEnabled then
        local function v211(p210) -- Line: 1043
            -- upvalues: u3 (ref)
            p210.ImageColor3 = u3;
        end;

        local function v213(p212) -- Line: 1044
            -- upvalues: u4 (ref)
            p212.ImageColor3 = u4;
        end;

        addHoverState(u206, u208, v211, v213);
        addHoverState(u207, u209, v211, v213);
    end;

    u204.Selections = {};
    local u214 = {};
    local u215 = {};
    local u216 = u11.Create("ImageButton")({
        Name = "AutoSelectButton",
        BackgroundTransparency = 1,
        Image = "",
        ZIndex = 2,
        Position = UDim2.new(0, u206.Size.X.Offset, 0, 0),
        Size = UDim2.new(1, u206.Size.X.Offset * -2, 1, 0),
        Parent = u204.SelectorFrame,
        SelectionImageObject = u13
    });
    u216.MouseButton1Click:Connect(function() -- Line: 1064
        -- upvalues: u205 (ref), u204 (copy), VRService (ref), UserInputService (ref), GuiService (ref)
        if not u205 then
            return;
        end;

        if #u204.Selections <= 1 then
            return;
        end;

        local v217 = u204.CurrentIndex + 1;
        u204:SetSelectionIndex(#u204.Selections < v217 and 1 or v217);
        local v218;

        if VRService.VREnabled then
            v218 = false;
        else
            v218 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
        end;

        if v218 then
            GuiService.SelectedCoreObject = u204.SelectorFrame;
        end;
    end);
    u215[u216] = true;

    local function u223(p219, p220) -- Line: 1079
        -- upvalues: u204 (copy), u206 (copy), u214 (ref), EaseOutQuad (ref), BindableEvent (copy)
        for i, v in pairs(u204.Selections) do
            local v221 = UDim2.new(0, u206.Size.X.Offset, 0, 0);
            local v222 = UDim2.new(0, u206.Size.X.Offset * p220 * 3, 0, 0);

            if u214[v] then
                v222 = UDim2.new(0, u206.Size.X.Offset * -p220 * 3, 0, 0);
            end;

            if v222.X.Offset < 0 then
                v222 = UDim2.new(0, v222.X.Offset + v.AbsoluteSize.X / 4, 0, 0);
            end;

            if i == p219 then
                u214[v] = true;
                v.Position = v222;
                v.Visible = true;
                PropertyTweener(v, "TextTransparency", 1, 0, 0.165, EaseOutQuad);

                if v:IsDescendantOf(game) then
                    v:TweenPosition(v221, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.15, true);
                else
                    v.Position = v221;
                end;

                u204.CurrentIndex = i;
                BindableEvent:Fire(p219);
            elseif u214[v] then
                u214[v] = false;
                PropertyTweener(v, "TextTransparency", 0, 1, 0.165, EaseOutQuad);

                if v:IsDescendantOf(game) then
                    v:TweenPosition(v222, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.135, true);
                else
                    v.Position = UDim2.new(v222);
                end;
            end;
        end;
    end;

    local function stepFunc(p224, p225) -- Line: 1118
        -- upvalues: u205 (ref), VRService (ref), UserInputService (ref), GuiService (ref), u204 (copy), u223 (copy)
        if not u205 then
            return;
        end;

        if p224 ~= nil and (p224.UserInputType ~= Enum.UserInputType.MouseButton1 and (p224.UserInputType ~= Enum.UserInputType.Gamepad1 and (p224.UserInputType ~= Enum.UserInputType.Gamepad2 and (p224.UserInputType ~= Enum.UserInputType.Gamepad3 and (p224.UserInputType ~= Enum.UserInputType.Gamepad4 and p224.UserInputType ~= Enum.UserInputType.Keyboard))))) then
            return;
        end;

        local v226;

        if VRService.VREnabled then
            v226 = false;
        else
            v226 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
        end;

        if v226 then
            GuiService.SelectedCoreObject = u204.SelectorFrame;
        end;

        local v227 = p225 + u204.CurrentIndex;
        u223(#u204.Selections < v227 and 1 or (v227 < 1 and #u204.Selections or v227), u204.CurrentIndex < v227 and 1 or -1);
    end;

    local u228 = nil;

    local function connectToGuiService() -- Line: 1149
        -- upvalues: u228 (ref), GuiService (ref), u204 (copy), u215 (copy), VRService (ref)
        u228 = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- Line: 1150
            -- upvalues: u204 (ref), GuiService (ref), u215 (ref), VRService (ref)
            if #u204.Selections <= 0 then
                return;
            end;

            if GuiService.SelectedCoreObject == u204.SelectorFrame then
                u204.Selections[u204.CurrentIndex].TextTransparency = 0;

                return;
            end;

            if GuiService.SelectedCoreObject == nil or not u215[GuiService.SelectedCoreObject] then
                u204.Selections[u204.CurrentIndex].TextTransparency = 0.5;

                return;
            end;

            if VRService.VREnabled then
                u204.Selections[u204.CurrentIndex].TextTransparency = 0;

                return;
            end;

            GuiService.SelectedCoreObject = u204.SelectorFrame;
        end);
    end;

    u204.IndexChanged = BindableEvent.Event;

    function u204.SetSelectionIndex(p229, p230) -- Line: 1174
        -- upvalues: u223 (copy)
        u223(p230, 1);
    end;

    function u204.GetSelectedIndex(p231) -- Line: 1178
        -- upvalues: u204 (copy)
        return u204.CurrentIndex;
    end;

    function u204.SetZIndex(p232, p233) -- Line: 1182
        -- upvalues: u206 (copy), u207 (copy), u208 (copy), u209 (copy), u204 (copy)
        u206.ZIndex = p233;
        u207.ZIndex = p233;
        u208.ZIndex = p233;
        u209.ZIndex = p233;

        for i = 1, #u204.Selections do
            u204.Selections[i].ZIndex = p233;
        end;
    end;

    function u204.SetInteractable(p234, p235) -- Line: 1193
        -- upvalues: u205 (ref), u204 (copy), u206 (copy), u207 (copy), u208 (copy), u5 (ref), u209 (copy), u3 (ref)
        u205 = p235;
        u204.SelectorFrame.Selectable = u205;
        u206.Active = u205;
        u207.Active = u205;

        if u205 then
            for _, v in pairs(u204.Selections) do
                v.TextColor3 = Color3.fromRGB(255, 255, 255);
            end;

            u208.ImageColor3 = u3;
            u209.ImageColor3 = u3;

            return;
        end;

        for _, v in pairs(u204.Selections) do
            v.TextColor3 = Color3.fromRGB(49, 49, 49);
        end;

        u208.ImageColor3 = u5;
        u209.ImageColor3 = u5;
    end;

    function u204.UpdateOptions(p236, p237) -- Line: 1215
        -- upvalues: u204 (copy), u214 (ref), u11 (ref), u206 (copy), u202 (copy), u207 (copy)
        for _, v in pairs(u204.Selections) do
            v:Destroy();
        end;

        u214 = {};
        u204.Selections = {};

        for i, v in pairs(p237) do
            local v238 = u11.Create("TextLabel")({
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                TextTransparency = 0.5,
                TextSize = 24,
                ZIndex = 2,
                Visible = false,
                Name = "Selection" .. tostring(i),
                Size = UDim2.new(1, u206.Size.X.Offset * -2, 1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextYAlignment = Enum.TextYAlignment.Center,
                Font = Enum.Font.SourceSans,
                Text = v,
                Parent = u204.SelectorFrame
            });

            if false then
                v238.TextSize = 36;
            end;

            if i == u202 then
                u204.CurrentIndex = i;
                v238.Position = UDim2.new(0, u206.Size.X.Offset, 0, 0);
                v238.Visible = true;
                u214[v238] = true;
            else
                u214[v238] = false;
            end;

            u204.Selections[i] = v238;
        end;

        local v239 = #u204.Selections > 1;
        u206.Visible = v239;
        u207.Visible = v239;
    end;

    VRService.Changed:Connect(function(p240) -- Line: 1264, Name: onVREnabled
        -- upvalues: VRService (ref), u206 (copy), u207 (copy), u216 (copy)
        if p240 ~= "VREnabled" then
            return;
        end;

        local VREnabled = VRService.VREnabled;
        u206.Selectable = VREnabled;
        u207.Selectable = VREnabled;
        u216.Selectable = VREnabled;
    end);
    local VREnabled = VRService.VREnabled;
    u206.Selectable = VREnabled;
    u207.Selectable = VREnabled;
    u216.Selectable = VREnabled;
    u206.InputBegan:Connect(function(p241) -- Line: 1276
        -- upvalues: u205 (ref), VRService (ref), UserInputService (ref), GuiService (ref), u204 (copy), u223 (copy)
        if p241.UserInputType == Enum.UserInputType.Touch then
            if not u205 then
                return;
            end;

            local v242;

            if VRService.VREnabled then
                v242 = false;
            else
                v242 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v242 then
                GuiService.SelectedCoreObject = u204.SelectorFrame;
            end;

            local v243 = -1 + u204.CurrentIndex;
            u223(#u204.Selections < v243 and 1 or (v243 < 1 and #u204.Selections or v243), u204.CurrentIndex < v243 and 1 or -1);
        end;
    end);
    u206.MouseButton1Click:Connect(function() -- Line: 1281
        -- upvalues: UserInputService (ref), u205 (ref), VRService (ref), GuiService (ref), u204 (copy), u223 (copy)
        if not UserInputService.TouchEnabled then
            if not u205 then
                return;
            end;

            local v244;

            if VRService.VREnabled then
                v244 = false;
            else
                v244 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v244 then
                GuiService.SelectedCoreObject = u204.SelectorFrame;
            end;

            local v245 = -1 + u204.CurrentIndex;
            u223(#u204.Selections < v245 and 1 or (v245 < 1 and #u204.Selections or v245), u204.CurrentIndex < v245 and 1 or -1);
        end;
    end);
    u207.InputBegan:Connect(function(p246) -- Line: 1286
        -- upvalues: u205 (ref), VRService (ref), UserInputService (ref), GuiService (ref), u204 (copy), u223 (copy)
        if p246.UserInputType == Enum.UserInputType.Touch then
            if not u205 then
                return;
            end;

            local v247;

            if VRService.VREnabled then
                v247 = false;
            else
                v247 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v247 then
                GuiService.SelectedCoreObject = u204.SelectorFrame;
            end;

            local v248 = 1 + u204.CurrentIndex;
            u223(#u204.Selections < v248 and 1 or (v248 < 1 and #u204.Selections or v248), u204.CurrentIndex < v248 and 1 or -1);
        end;
    end);
    u207.MouseButton1Click:Connect(function() -- Line: 1291
        -- upvalues: UserInputService (ref), u205 (ref), VRService (ref), GuiService (ref), u204 (copy), u223 (copy)
        if not UserInputService.TouchEnabled then
            if not u205 then
                return;
            end;

            local v249;

            if VRService.VREnabled then
                v249 = false;
            else
                v249 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v249 then
                GuiService.SelectedCoreObject = u204.SelectorFrame;
            end;

            local v250 = 1 + u204.CurrentIndex;
            u223(#u204.Selections < v250 and 1 or (v250 < 1 and #u204.Selections or v250), u204.CurrentIndex < v250 and 1 or -1);
        end;
    end);
    local u251 = true;
    u204:UpdateOptions(p201);
    UserInputService.InputBegan:Connect(function(p252) -- Line: 1300
        -- upvalues: u205 (ref), u251 (ref), GuiService (ref), u204 (copy), VRService (ref), UserInputService (ref), u223 (copy)
        if not u205 then
            return;
        end;

        if not u251 then
            return;
        end;

        if p252.UserInputType ~= Enum.UserInputType.Gamepad1 and p252.UserInputType ~= Enum.UserInputType.Keyboard then
            return;
        end;

        if GuiService.SelectedCoreObject ~= u204.SelectorFrame then
            return;
        end;

        if p252.KeyCode ~= Enum.KeyCode.DPadLeft and (p252.KeyCode ~= Enum.KeyCode.Left and p252.KeyCode ~= Enum.KeyCode.A) then
            if p252.KeyCode == Enum.KeyCode.DPadRight or (p252.KeyCode == Enum.KeyCode.Right or p252.KeyCode == Enum.KeyCode.D) then
                if not u205 then
                    return;
                end;

                if p252 ~= nil and (p252.UserInputType ~= Enum.UserInputType.MouseButton1 and (p252.UserInputType ~= Enum.UserInputType.Gamepad1 and (p252.UserInputType ~= Enum.UserInputType.Gamepad2 and (p252.UserInputType ~= Enum.UserInputType.Gamepad3 and (p252.UserInputType ~= Enum.UserInputType.Gamepad4 and p252.UserInputType ~= Enum.UserInputType.Keyboard))))) then
                    return;
                end;

                local v253;

                if VRService.VREnabled then
                    v253 = false;
                else
                    v253 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
                end;

                if v253 then
                    GuiService.SelectedCoreObject = u204.SelectorFrame;
                end;

                local v254 = 1 + u204.CurrentIndex;
                u223(#u204.Selections < v254 and 1 or (v254 < 1 and #u204.Selections or v254), u204.CurrentIndex < v254 and 1 or -1);
            end;

            return;
        end;

        if not u205 then
            return;
        end;

        if p252 ~= nil and (p252.UserInputType ~= Enum.UserInputType.MouseButton1 and (p252.UserInputType ~= Enum.UserInputType.Gamepad1 and (p252.UserInputType ~= Enum.UserInputType.Gamepad2 and (p252.UserInputType ~= Enum.UserInputType.Gamepad3 and (p252.UserInputType ~= Enum.UserInputType.Gamepad4 and p252.UserInputType ~= Enum.UserInputType.Keyboard))))) then
            return;
        end;

        local v255;

        if VRService.VREnabled then
            v255 = false;
        else
            v255 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
        end;

        if v255 then
            GuiService.SelectedCoreObject = u204.SelectorFrame;
        end;

        local v256 = -1 + u204.CurrentIndex;
        u223(#u204.Selections < v256 and 1 or (v256 < 1 and #u204.Selections or v256), u204.CurrentIndex < v256 and 1 or -1);
    end);
    UserInputService.InputChanged:Connect(function(p257) -- Line: 1314
        -- upvalues: u205 (ref), u251 (ref), u203 (ref), GuiService (ref), u204 (copy), stepFunc (copy)
        if not u205 then
            return;
        end;

        if not u251 then
            u203 = 0;

            return;
        end;

        if p257.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return;
        end;

        local SelectedCoreObject = GuiService.SelectedCoreObject;

        if not (SelectedCoreObject and SelectedCoreObject:IsDescendantOf(u204.SelectorFrame.Parent)) then
            return;
        end;

        if p257.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return;
        end;

        if p257.Position.X > 0.8 and (p257.Delta.X > 0 and u203 ~= 1) then
            u203 = 1;
            stepFunc(p257, u203);

            return;
        end;

        if p257.Position.X >= -0.8 or (p257.Delta.X >= 0 or u203 == -1) then
            if math.abs(p257.Position.X) < 0.8 then
                u203 = 0;
            end;

            return;
        end;

        u203 = -1;
        stepFunc(p257, u203);
    end);
    u204.SelectorFrame.AncestryChanged:Connect(function(p258, p259) -- Line: 1337
        -- upvalues: u251 (ref), u228 (ref), GuiService (ref), u204 (copy), u215 (copy), VRService (ref)
        u251 = p259;

        if u251 then
            u228 = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- Line: 1150
                -- upvalues: u204 (ref), GuiService (ref), u215 (ref), VRService (ref)
                if #u204.Selections <= 0 then
                    return;
                end;

                if GuiService.SelectedCoreObject == u204.SelectorFrame then
                    u204.Selections[u204.CurrentIndex].TextTransparency = 0;

                    return;
                end;

                if GuiService.SelectedCoreObject == nil or not u215[GuiService.SelectedCoreObject] then
                    u204.Selections[u204.CurrentIndex].TextTransparency = 0.5;

                    return;
                end;

                if VRService.VREnabled then
                    u204.Selections[u204.CurrentIndex].TextTransparency = 0;

                    return;
                end;

                GuiService.SelectedCoreObject = u204.SelectorFrame;
            end);
        elseif u228 then
            u228:Disconnect();
        end;
    end);

    u12[u204.SelectorFrame] = function(p260, p261) -- Line: 1346, Name: onResized
        -- upvalues: u204 (copy)
        local v262 = p261 and 16 or 24;

        for _, v in pairs(u204.Selections) do
            v.TextSize = v262;
        end;
    end;

    getViewportSize();
    local v263 = getViewportSize();
    local v264 = v263.Y > v263.X and 16 or 24;

    for _, v in pairs(u204.Selections) do
        v.TextSize = v264;
    end;

    u228 = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- Line: 1150
        -- upvalues: u204 (copy), GuiService (ref), u215 (copy), VRService (ref)
        if #u204.Selections <= 0 then
            return;
        end;

        if GuiService.SelectedCoreObject == u204.SelectorFrame then
            u204.Selections[u204.CurrentIndex].TextTransparency = 0;

            return;
        end;

        if GuiService.SelectedCoreObject == nil or not u215[GuiService.SelectedCoreObject] then
            u204.Selections[u204.CurrentIndex].TextTransparency = 0.5;

            return;
        end;

        if VRService.VREnabled then
            u204.Selections[u204.CurrentIndex].TextTransparency = 0;

            return;
        end;

        GuiService.SelectedCoreObject = u204.SelectorFrame;
    end);

    return u204;
end;

local function ShowAlert(p265, p266, u267, u268, p269) -- Line: 1365
    -- upvalues: PlayerGui (copy), VRService (copy), u11 (copy), HttpService (copy), ContextActionService (copy), GuiService (copy), MakeButton (copy), UserInputService (copy)
    local RobloxGui = PlayerGui.RobloxGui;

    if RobloxGui:FindFirstChild("AlertViewFullScreen") then
        return;
    end;

    local u270 = nil;

    local function v273(p271) -- Line: 1374
        -- upvalues: VRService (ref), PlayerGui (ref), RobloxGui (ref), u270 (ref)
        if p271 ~= "VREnabled" then
            return;
        end;

        local v272 = nil;

        if VRService.VREnabled then
            v272 = require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu");
            RobloxGui = v272:GetGUI();
        else
            RobloxGui = PlayerGui.RobloxGui;
        end;

        if u270 and u270.Parent ~= nil then
            u270.Parent = RobloxGui;

            if VRService.VREnabled then
                v272:SetSubpanelDepth(u270, 0.5);
            end;
        end;
    end;

    local u274 = VRService.Changed:Connect(v273);
    Color3.fromRGB(59, 166, 241);
    Color3.fromRGB(255, 255, 255);
    u270 = u11.Create("ImageLabel")({
        Name = "AlertViewBacking",
        Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        ZIndex = 9,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(8, 6, 46, 44),
        Size = UDim2.new(0, 400, 0, 350),
        Position = UDim2.new(0.5, -200, 0.5, -175),
        Parent = RobloxGui
    });
    v273("VREnabled");

    if p269 or VRService.VREnabled then
        u270.ImageTransparency = 0;
    else
        u270.Size = UDim2.new(0.8, 0, 0, 350);
        u270.Position = UDim2.new(0.1, 0, 0.1, 0);
    end;

    if PlayerGui.RobloxGui.AbsoluteSize.Y <= u270.Size.Y.Offset then
        u270.Size = UDim2.new(u270.Size.X.Scale, u270.Size.X.Offset, u270.Size.Y.Scale, PlayerGui.RobloxGui.AbsoluteSize.Y);
        u270.Position = UDim2.new(u270.Position.X.Scale, -u270.Size.X.Offset / 2, 0.5, -u270.Size.Y.Offset / 2);
    end;

    u11.Create("TextLabel")({
        Name = "AlertViewText",
        BackgroundTransparency = 1,
        TextSize = 36,
        TextWrapped = true,
        ZIndex = 10,
        Size = UDim2.new(0.95, 0, 0.6, 0),
        Position = UDim2.new(0.025, 0, 0.05, 0),
        Font = Enum.Font.SourceSansBold,
        Text = p265,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = u270
    });
    u11.Create("ImageLabel")({
        Image = "",
        BackgroundTransparency = 1
    });
    local u275 = HttpService:GenerateGUID(false);

    local function v278(p276, p277) -- Line: 1449
        -- upvalues: VRService (ref), u270 (ref), PlayerGui (ref), u268 (copy), ContextActionService (ref), u275 (copy), GuiService (ref), u267 (copy), u274 (copy)
        if VRService.VREnabled and (p277 == Enum.UserInputState.Begin or p277 == Enum.UserInputState.Cancel) then
            return;
        end;

        if not u270 then
            return;
        end;

        if VRService.VREnabled then
            require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu"):SetSubpanelDepth(u270, 0);
        end;

        u270:Destroy();
        u270 = nil;

        if u268 then
            u268();
        end;

        ContextActionService:UnbindAction(u275);
        GuiService.SelectedCoreObject = nil;

        if u267 then
            u267:ShowBar();
        end;

        if u274 then
            u274:Disconnect();
        end;
    end;

    local v279 = UDim2.new(1, -20, 0, 60);
    local v280 = UDim2.new(0, 10, 0.65, 0);

    if not p269 then
        v279 = UDim2.new(0, 200, 0, 50);
        v280 = UDim2.new(0.5, -100, 0.65, 0);
    end;

    local v281, v282 = MakeButton("AlertViewButton", p266, v279, v278);
    v281.Position = v280;
    v281.NextSelectionLeft = v281;
    v281.NextSelectionRight = v281;
    v281.NextSelectionUp = v281;
    v281.NextSelectionDown = v281;
    v281.ZIndex = 9;
    v282.ZIndex = v281.ZIndex;
    v281.Parent = u270;
    local v283;

    if VRService.VREnabled then
        v283 = false;
    else
        v283 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
    end;

    if v283 then
        GuiService.SelectedCoreObject = v281;
    end;

    GuiService.SelectedCoreObject = v281;
    ContextActionService:BindActionAtPriority(u275, v278, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonA);

    if u267 and not VRService.VREnabled then
        u267:HideBar();
        u267.Pages.CurrentPage:Hide(1, 1);
    end;
end;

local function CreateNewSlider(p284, p285, u286) -- Line: 1506
    -- upvalues: HttpService (copy), u11 (copy), u13 (copy), UserInputService (copy), u4 (copy), u3 (copy), u4 (copy), addHoverState (copy), getViewportSize (copy), u1 (copy), u2 (copy), VRService (copy), GuiService (copy), RunService (copy)
    local u287 = {};
    local u288 = tonumber(p284);
    local u289 = p285;
    local u290 = 0;
    local u291 = nil;
    local u292 = true;
    local u293 = HttpService:GenerateGUID(false);

    if u288 > 0 then
        local BindableEvent = Instance.new("BindableEvent");
        BindableEvent.Name = "ValueChanged";
        u287.SliderFrame = u11.Create("ImageButton")({
            Name = "Slider",
            Image = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            ZIndex = 2,
            NextSelectionLeft = u287.SliderFrame,
            NextSelectionRight = u287.SliderFrame,
            Size = UDim2.new(0.6, 0, 0, 50),
            Position = UDim2.new(1, 0, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            SelectionImageObject = u13
        });
        u287.StepsContainer = u11.Create("Frame")({
            Name = "StepsContainer",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, -100, 1, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = u287.SliderFrame
        });
        local u294 = u11.Create("ImageButton")({
            Name = "LeftButton",
            BackgroundTransparency = 1,
            Image = "",
            ZIndex = 3,
            Selectable = false,
            Active = true,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 50, 0, 50),
            SelectionImageObject = u13,
            Parent = u287.SliderFrame
        });
        local u295 = u11.Create("ImageButton")({
            Name = "RightButton",
            BackgroundTransparency = 1,
            Image = "",
            ZIndex = 3,
            Selectable = false,
            Active = true,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0, 50, 0, 50),
            SelectionImageObject = u13,
            Parent = u287.SliderFrame
        });
        local u296 = u11.Create("ImageLabel")({
            Name = "LeftButton",
            BackgroundTransparency = 1,
            Image = "rbxasset://textures/ui/Settings/Slider/Less.png",
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 30, 0, 30),
            Parent = u294,
            ImageColor3 = UserInputService.TouchEnabled and u4 or u3
        });
        local u297 = u11.Create("ImageLabel")({
            Name = "RightButton",
            BackgroundTransparency = 1,
            Image = "rbxasset://textures/ui/Settings/Slider/More.png",
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 30, 0, 30),
            Parent = u295,
            ImageColor3 = UserInputService.TouchEnabled and u4 or u3
        });

        if not UserInputService.TouchEnabled then
            local function v299(p298) -- Line: 1615
                -- upvalues: u3 (ref)
                p298.ImageColor3 = u3;
            end;

            local function v301(p300) -- Line: 1616
                -- upvalues: u4 (ref)
                p300.ImageColor3 = u4;
            end;

            addHoverState(u294, u296, v299, v301);
            addHoverState(u295, u297, v299, v301);
        end;

        u287.Steps = {};
        local v302 = getViewportSize();
        local _ = UserInputService.TouchEnabled and (v302.Y < 500 and true or v302.X < 700);
        local v303 = 1 / u288;

        for i = 1, u288 do
            local v304 = u11.Create("ImageButton")({
                BackgroundTransparency = 0.36,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Active = false,
                Image = "",
                ZIndex = 3,
                Selectable = false,
                ImageTransparency = 0.36,
                Name = "Step" .. tostring(i),
                BackgroundColor3 = u1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new((i - 1) * v303, 2, 0.5, 0),
                Size = UDim2.new(v303, -4, 0.48, 0),
                Parent = u287.StepsContainer,
                SelectionImageObject = u13
            });

            if u289 < i then
                v304.BackgroundColor3 = u2;
            end;

            if i == 1 or i == u288 then
                v304.BackgroundTransparency = 1;
                v304.ScaleType = Enum.ScaleType.Slice;
                v304.SliceCenter = Rect.new(3, 3, 32, 21);

                if i <= u289 then
                    if i == 1 then
                        v304.Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarLeft.png";
                    else
                        v304.Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarRight.png";
                    end;
                elseif i == 1 then
                    v304.Image = "rbxasset://textures/ui/Settings/Slider/BarLeft.png";
                else
                    v304.Image = "rbxasset://textures/ui/Settings/Slider/BarRight.png";
                end;
            end;

            u287.Steps[#u287.Steps + 1] = v304;
        end;

        local function hideSelection() -- Line: 1680
            -- upvalues: u288 (copy), u287 (copy), u2 (ref)
            for i = 1, u288 do
                u287.Steps[i].BackgroundColor3 = u2;

                if i == 1 then
                    u287.Steps[i].Image = "rbxasset://textures/ui/Settings/Slider/BarLeft.png";
                elseif i == u288 then
                    u287.Steps[i].Image = "rbxasset://textures/ui/Settings/Slider/BarRight.png";
                end;
            end;
        end;

        local function showSelection() -- Line: 1690
            -- upvalues: u288 (copy), u289 (ref), u287 (copy), u1 (ref)
            for i = 1, u288 do
                if u289 < i then
                    break;
                end;

                u287.Steps[i].BackgroundColor3 = u1;

                if i == 1 then
                    u287.Steps[i].Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarLeft.png";
                elseif i == u288 then
                    u287.Steps[i].Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarRight.png";
                end;
            end;
        end;

        local function setCurrentStep(p305) -- Line: 1711
            -- upvalues: u286 (ref), u294 (copy), u295 (copy), u288 (copy), u289 (ref), hideSelection (copy), showSelection (copy), u291 (ref), BindableEvent (copy)
            if not u286 then
                u286 = 0;
            end;

            u294.Visible = true;
            u295.Visible = true;

            if p305 <= u286 then
                p305 = u286;
                u294.Visible = false;
            end;

            if u288 <= p305 then
                p305 = u288;
                u295.Visible = false;
            end;

            if u289 == p305 then
                return;
            end;

            u289 = p305;
            hideSelection();
            showSelection();
            u291 = tick();
            BindableEvent:Fire(u289);
        end;

        local function isActivateEvent(p306) -- Line: 1737
            if not p306 then
                return false;
            end;

            local v307;

            if p306.UserInputType == Enum.UserInputType.MouseButton1 or p306.UserInputType == Enum.UserInputType.Touch then
                v307 = true;
            elseif p306.UserInputType == Enum.UserInputType.Gamepad1 then
                v307 = p306.KeyCode == Enum.KeyCode.ButtonA;
            else
                v307 = false;
            end;

            return v307;
        end;

        local function mouseDownFunc(p308, p309, p310) -- Line: 1741
            -- upvalues: u292 (ref), VRService (ref), UserInputService (ref), GuiService (ref), u287 (copy), u290 (ref), u289 (ref), u288 (copy), setCurrentStep (copy)
            if not u292 then
                return;
            end;

            if p308 == nil then
                return;
            end;

            local v311;

            if p308 then
                if p308.UserInputType == Enum.UserInputType.MouseButton1 or p308.UserInputType == Enum.UserInputType.Touch then
                    v311 = true;
                elseif p308.UserInputType == Enum.UserInputType.Gamepad1 then
                    v311 = p308.KeyCode == Enum.KeyCode.ButtonA;
                else
                    v311 = false;
                end;
            else
                v311 = false;
            end;

            if not v311 then
                return;
            end;

            local v312;

            if VRService.VREnabled then
                v312 = false;
            else
                v312 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v312 and not VRService.VREnabled then
                GuiService.SelectedCoreObject = u287.SliderFrame;
            end;

            if VRService.VREnabled then
                u290 = 0;
            elseif p310 then
                u290 = p309 - u289;
            else
                u290 = 0;
                local u313 = nil;
                local u315 = UserInputService.InputChanged:Connect(function(p314) -- Line: 1761
                    -- upvalues: u288 (ref), u287 (ref), setCurrentStep (ref)
                    if p314.UserInputType ~= Enum.UserInputType.MouseMovement then
                        return;
                    end;

                    local X = p314.Position.X;

                    for i = 1, u288 do
                        local X2 = u287.Steps[i].AbsolutePosition.X;

                        if X2 <= X and X <= X2 + u287.Steps[i].AbsoluteSize.X then
                            setCurrentStep(i);

                            return;
                        end;

                        if i == 1 and X < X2 then
                            setCurrentStep(0);

                            return;
                        end;

                        if i == u288 and X2 <= X then
                            setCurrentStep(i);

                            return;
                        end;
                    end;
                end);
                u313 = UserInputService.InputEnded:Connect(function(p316) -- Line: 1780
                    -- upvalues: u290 (ref), u313 (ref), u315 (ref)
                    local v317;

                    if p316 then
                        if p316.UserInputType == Enum.UserInputType.MouseButton1 or p316.UserInputType == Enum.UserInputType.Touch then
                            v317 = true;
                        elseif p316.UserInputType == Enum.UserInputType.Gamepad1 then
                            v317 = p316.KeyCode == Enum.KeyCode.ButtonA;
                        else
                            v317 = false;
                        end;
                    else
                        v317 = false;
                    end;

                    if not v317 then
                        return;
                    end;

                    u290 = 0;
                    u313:Disconnect();
                    u315:Disconnect();
                end);
            end;

            setCurrentStep(p309);
        end;

        local function mouseUpFunc(p318) -- Line: 1795
            -- upvalues: u292 (ref), u290 (ref)
            if not u292 then
                return;
            end;

            local v319;

            if p318 then
                if p318.UserInputType == Enum.UserInputType.MouseButton1 or p318.UserInputType == Enum.UserInputType.Touch then
                    v319 = true;
                elseif p318.UserInputType == Enum.UserInputType.Gamepad1 then
                    v319 = p318.KeyCode == Enum.KeyCode.ButtonA;
                else
                    v319 = false;
                end;
            else
                v319 = false;
            end;

            if not v319 then
                return;
            end;

            u290 = 0;
        end;

        local function touchClickFunc(p320, p321, p322) -- Line: 1802
            -- upvalues: mouseDownFunc (copy)
            mouseDownFunc(p320, p321, p322);
        end;

        u287.ValueChanged = BindableEvent.Event;

        function u287.SetValue(p323, p324) -- Line: 1809
            -- upvalues: setCurrentStep (copy)
            setCurrentStep(p324);
        end;

        function u287.GetValue(p325) -- Line: 1813
            -- upvalues: u289 (ref)
            return u289;
        end;

        function u287.SetInteractable(p326, p327) -- Line: 1817
            -- upvalues: u290 (ref), u292 (ref), u287 (copy), hideSelection (copy), showSelection (copy)
            u290 = 0;
            u292 = p327;
            u287.SliderFrame.Selectable = p327;

            if u292 then
                showSelection();

                return;
            end;

            hideSelection();
        end;

        function u287.SetZIndex(p328, p329) -- Line: 1828
            -- upvalues: u294 (copy), u295 (copy), u296 (copy), u297 (copy), u287 (copy)
            u294.ZIndex = p329;
            u295.ZIndex = p329;
            u296.ZIndex = p329;
            u297.ZIndex = p329;

            for i = 1, #u287.Steps do
                u287.Steps[i].ZIndex = p329;
            end;
        end;

        function u287.SetMinStep(p330, p331) -- Line: 1839
            -- upvalues: u288 (copy), u286 (ref), u289 (ref), u294 (copy), u295 (copy)
            if p331 >= 0 and p331 <= u288 then
                u286 = p331;
            end;

            if u289 <= u286 then
                u289 = u286;
                u294.Visible = false;
            end;

            if u288 <= u289 then
                u289 = u288;
                u295.Visible = false;
            end;
        end;

        u294.InputBegan:Connect(function(p332) -- Line: 1856
            -- upvalues: u289 (ref), u292 (ref), VRService (ref), UserInputService (ref), GuiService (ref), u287 (copy), u290 (ref), setCurrentStep (copy)
            local v333 = u289 - 1;

            if not u292 then
                return;
            end;

            if p332 == nil then
                return;
            end;

            local v334;

            if p332 then
                if p332.UserInputType == Enum.UserInputType.MouseButton1 or p332.UserInputType == Enum.UserInputType.Touch then
                    v334 = true;
                elseif p332.UserInputType == Enum.UserInputType.Gamepad1 then
                    v334 = p332.KeyCode == Enum.KeyCode.ButtonA;
                else
                    v334 = false;
                end;
            else
                v334 = false;
            end;

            if not v334 then
                return;
            end;

            local v335;

            if VRService.VREnabled then
                v335 = false;
            else
                v335 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v335 and not VRService.VREnabled then
                GuiService.SelectedCoreObject = u287.SliderFrame;
            end;

            if VRService.VREnabled then
                u290 = 0;
            else
                u290 = v333 - u289;
            end;

            setCurrentStep(v333);
        end);
        u294.InputEnded:Connect(function(p336) -- Line: 1857
            -- upvalues: u292 (ref), u290 (ref)
            if not u292 then
                return;
            end;

            local v337;

            if p336 then
                if p336.UserInputType == Enum.UserInputType.MouseButton1 or p336.UserInputType == Enum.UserInputType.Touch then
                    v337 = true;
                elseif p336.UserInputType == Enum.UserInputType.Gamepad1 then
                    v337 = p336.KeyCode == Enum.KeyCode.ButtonA;
                else
                    v337 = false;
                end;
            else
                v337 = false;
            end;

            if not v337 then
                return;
            end;

            u290 = 0;
        end);
        u295.InputBegan:Connect(function(p338) -- Line: 1858
            -- upvalues: u289 (ref), u292 (ref), VRService (ref), UserInputService (ref), GuiService (ref), u287 (copy), u290 (ref), setCurrentStep (copy)
            local v339 = u289 + 1;

            if not u292 then
                return;
            end;

            if p338 == nil then
                return;
            end;

            local v340;

            if p338 then
                if p338.UserInputType == Enum.UserInputType.MouseButton1 or p338.UserInputType == Enum.UserInputType.Touch then
                    v340 = true;
                elseif p338.UserInputType == Enum.UserInputType.Gamepad1 then
                    v340 = p338.KeyCode == Enum.KeyCode.ButtonA;
                else
                    v340 = false;
                end;
            else
                v340 = false;
            end;

            if not v340 then
                return;
            end;

            local v341;

            if VRService.VREnabled then
                v341 = false;
            else
                v341 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v341 and not VRService.VREnabled then
                GuiService.SelectedCoreObject = u287.SliderFrame;
            end;

            if VRService.VREnabled then
                u290 = 0;
            else
                u290 = v339 - u289;
            end;

            setCurrentStep(v339);
        end);
        u295.InputEnded:Connect(function(p342) -- Line: 1859
            -- upvalues: u292 (ref), u290 (ref)
            if not u292 then
                return;
            end;

            local v343;

            if p342 then
                if p342.UserInputType == Enum.UserInputType.MouseButton1 or p342.UserInputType == Enum.UserInputType.Touch then
                    v343 = true;
                elseif p342.UserInputType == Enum.UserInputType.Gamepad1 then
                    v343 = p342.KeyCode == Enum.KeyCode.ButtonA;
                else
                    v343 = false;
                end;
            else
                v343 = false;
            end;

            if not v343 then
                return;
            end;

            u290 = 0;
        end);

        local function v345(p344) -- Line: 1861
            -- upvalues: VRService (ref), u294 (copy), u292 (ref), u295 (copy), u287 (copy), u288 (copy)
            if p344 ~= "VREnabled" then
                return;
            end;

            if VRService.VREnabled then
                u294.Selectable = u292;
                u295.Selectable = u292;
                u287.SliderFrame.Selectable = u292;

                for i = 1, u288 do
                    u287.Steps[i].Selectable = u292;
                    u287.Steps[i].Active = u292;
                end;

                return;
            end;

            u294.Selectable = false;
            u295.Selectable = false;
            u287.SliderFrame.Selectable = u292;

            for i = 1, u288 do
                u287.Steps[i].Selectable = false;
                u287.Steps[i].Active = false;
            end;
        end;

        VRService.Changed:Connect(v345);
        v345("VREnabled");

        local function modifySelection(p346) -- Line: 1701
            -- upvalues: u288 (copy), u287 (copy)
            for i = 1, u288 do
                if i == 1 or i == u288 then
                    u287.Steps[i].ImageTransparency = p346;
                else
                    u287.Steps[i].BackgroundTransparency = p346;
                end;
            end;
        end;

        for i = 1, u288 do
            u287.Steps[i].InputBegan:Connect(function(p347) -- Line: 1888
                -- upvalues: mouseDownFunc (copy), i (copy)
                mouseDownFunc(p347, i);
            end);
            u287.Steps[i].InputEnded:Connect(function(p348) -- Line: 1891
                -- upvalues: u292 (ref), u290 (ref)
                if not u292 then
                    return;
                end;

                local v349;

                if p348 then
                    if p348.UserInputType == Enum.UserInputType.MouseButton1 or p348.UserInputType == Enum.UserInputType.Touch then
                        v349 = true;
                    elseif p348.UserInputType == Enum.UserInputType.Gamepad1 then
                        v349 = p348.KeyCode == Enum.KeyCode.ButtonA;
                    else
                        v349 = false;
                    end;
                else
                    v349 = false;
                end;

                if not v349 then
                    return;
                end;

                u290 = 0;
            end);
        end;

        u287.SliderFrame.InputBegan:Connect(function(p350) -- Line: 1895
            -- upvalues: VRService (ref), GuiService (ref), u287 (copy), mouseDownFunc (copy), u289 (ref)
            if VRService.VREnabled then
                local SelectedCoreObject = GuiService.SelectedCoreObject;

                if not (SelectedCoreObject and SelectedCoreObject:IsDescendantOf(u287.SliderFrame.Parent)) then
                    return;
                end;
            end;

            mouseDownFunc(p350, u289);
        end);
        u287.SliderFrame.InputEnded:Connect(function(p351) -- Line: 1902
            -- upvalues: VRService (ref), GuiService (ref), u287 (copy), u292 (ref), u290 (ref)
            if VRService.VREnabled then
                local SelectedCoreObject = GuiService.SelectedCoreObject;

                if not (SelectedCoreObject and SelectedCoreObject:IsDescendantOf(u287.SliderFrame.Parent)) then
                    return;
                end;
            end;

            if not u292 then
                return;
            end;

            local v352;

            if p351 then
                if p351.UserInputType == Enum.UserInputType.MouseButton1 or p351.UserInputType == Enum.UserInputType.Touch then
                    v352 = true;
                elseif p351.UserInputType == Enum.UserInputType.Gamepad1 then
                    v352 = p351.KeyCode == Enum.KeyCode.ButtonA;
                else
                    v352 = false;
                end;
            else
                v352 = false;
            end;

            if not v352 then
                return;
            end;

            u290 = 0;
        end);

        local function u353() -- Line: 1911
            -- upvalues: u291 (ref), setCurrentStep (copy), u289 (ref), u290 (ref)
            if u291 == nil then
                return;
            end;

            if tick() - u291 >= 0.2 then
                setCurrentStep(u289 + u290);
            end;
        end;

        local u354 = true;
        local u355 = {
            [Enum.KeyCode.Thumbstick1] = true,
            [Enum.KeyCode.DPadLeft] = -1,
            [Enum.KeyCode.DPadRight] = 1,
            [Enum.KeyCode.Left] = -1,
            [Enum.KeyCode.Right] = 1,
            [Enum.KeyCode.A] = -1,
            [Enum.KeyCode.D] = 1,
            [Enum.KeyCode.ButtonA] = true
        };
        UserInputService.InputBegan:Connect(function(p356) -- Line: 1935
            -- upvalues: u292 (ref), u354 (ref), GuiService (ref), u287 (copy), u355 (copy), u290 (ref), setCurrentStep (copy), u289 (ref)
            if not u292 then
                return;
            end;

            if not u354 then
                return;
            end;

            if p356.UserInputType ~= Enum.UserInputType.Gamepad1 and p356.UserInputType ~= Enum.UserInputType.Keyboard then
                return;
            end;

            local SelectedCoreObject = GuiService.SelectedCoreObject;

            if not (SelectedCoreObject and SelectedCoreObject:IsDescendantOf(u287.SliderFrame.Parent)) then
                return;
            end;

            if u355[p356.KeyCode] ~= -1 then
                if u355[p356.KeyCode] == 1 then
                    u290 = 1;
                    setCurrentStep(u289 + 1);
                end;

                return;
            end;

            u290 = -1;
            setCurrentStep(u289 - 1);
        end);
        UserInputService.InputEnded:Connect(function(p357) -- Line: 1952
            -- upvalues: u292 (ref), GuiService (ref), u287 (copy), u355 (copy), u290 (ref)
            if not u292 then
                return;
            end;

            if p357.UserInputType ~= Enum.UserInputType.Gamepad1 and p357.UserInputType ~= Enum.UserInputType.Keyboard then
                return;
            end;

            local SelectedCoreObject = GuiService.SelectedCoreObject;

            if not (SelectedCoreObject and SelectedCoreObject:IsDescendantOf(u287.SliderFrame.Parent)) then
                return;
            end;

            if u355[p357.KeyCode] then
                u290 = 0;
            end;
        end);
        UserInputService.InputChanged:Connect(function(p358) -- Line: 1964
            -- upvalues: u292 (ref), u290 (ref), u354 (ref), GuiService (ref), u287 (copy), setCurrentStep (copy), u289 (ref)
            if not u292 then
                u290 = 0;

                return;
            end;

            if not u354 then
                u290 = 0;

                return;
            end;

            if p358.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            local SelectedCoreObject = GuiService.SelectedCoreObject;

            if not (SelectedCoreObject and SelectedCoreObject:IsDescendantOf(u287.SliderFrame.Parent)) then
                return;
            end;

            if p358.KeyCode ~= Enum.KeyCode.Thumbstick1 then
                return;
            end;

            if p358.Position.X > 0.8 and (p358.Delta.X > 0 and u290 ~= 1) then
                u290 = 1;
                setCurrentStep(u289 + 1);

                return;
            end;

            if p358.Position.X >= -0.8 or (p358.Delta.X >= 0 or u290 == -1) then
                if math.abs(p358.Position.X) < 0.8 then
                    u290 = 0;
                end;

                return;
            end;

            u290 = -1;
            setCurrentStep(u289 - 1);
        end);
        local u359 = false;
        GuiService.Changed:Connect(function(p360) -- Line: 1991
            -- upvalues: GuiService (ref), u287 (copy), modifySelection (copy), u359 (ref), u291 (ref), RunService (ref), u293 (copy), u353 (copy)
            if p360 ~= "SelectedCoreObject" then
                return;
            end;

            local SelectedCoreObject = GuiService.SelectedCoreObject;

            if SelectedCoreObject then
                SelectedCoreObject = SelectedCoreObject:IsDescendantOf(u287.SliderFrame.Parent);
            end;

            if SelectedCoreObject then
                modifySelection(0);

                if not u359 then
                    u359 = true;
                    u291 = tick();
                    RunService:BindToRenderStep(u293, Enum.RenderPriority.Input.Value + 1, u353);
                end;
            else
                modifySelection(0.36);

                if u359 then
                    u359 = false;
                    RunService:UnbindFromRenderStep(u293);
                end;
            end;
        end);
        u287.SliderFrame.AncestryChanged:Connect(function(p361, p362) -- Line: 2012
            -- upvalues: u354 (ref)
            u354 = p362;
        end);
        setCurrentStep(u289);

        return u287;
    end;

    error(
        "CreateNewSlider failed because numOfSteps (first arg) is 0 or negative, please supply a positive integer",
        2
    );
end;

local u363 = 50;
local u364 = {};

local function AddNewRow(u365, u366, p367, p368, p369, p370) -- Line: 2025
    -- upvalues: u364 (copy), u11 (copy), u363 (ref), u13 (copy), u6 (copy), getViewportSize (copy), u12 (copy), CreateNewSlider (copy), CreateSelector (copy), CreateDropDown (copy), VRService (copy), UserInputService (copy), GuiService (copy), PlayerGui (copy)
    local v371 = p367 ~= "TextBox";
    local v372 = not u364[u365] and 0 or u364[u365];
    local u373 = u11.Create("ImageButton")({
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
        ImageTransparency = 1,
        Active = false,
        AutoButtonColor = false,
        ZIndex = 2,
        Selectable = false,
        Name = u366 .. "Frame",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 18, 18),
        Size = UDim2.new(1, 0, 0, u363),
        Position = UDim2.new(0, 0, 0, v372),
        SelectionImageObject = u13,
        Parent = u365.Page
    });
    u373.ImageColor3 = u373.BackgroundColor3;

    if u373 and p370 then
        u373.Position = UDim2.new(u373.Position.X.Scale, u373.Position.X.Offset, u373.Position.Y.Scale, u373.Position.Y.Offset + p370);
    end;

    local u374 = u11.Create("TextLabel")({
        TextSize = 16,
        BackgroundTransparency = 1,
        ZIndex = 2,
        Name = u366 .. "Label",
        Text = u366,
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Parent = u373
    });
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");

    if u6 then
        u374.Size = UDim2.new(0.35, 0, 1, 0);
        u374.TextScaled = true;
        u374.TextWrapped = true;
        UITextSizeConstraint.Parent = u374;
        UITextSizeConstraint.MaxTextSize = 16;
    end;

    if not v371 then
        u374.Text = "";
    end;

    local function onResized(p375, p376) -- Line: 2088
        -- upvalues: u374 (ref), UITextSizeConstraint (copy)
        if p376 then
            u374.TextSize = 16;
        else
            u374.TextSize = 24;
        end;

        UITextSizeConstraint.MaxTextSize = u374.TextSize;
    end;

    getViewportSize();
    local v377 = getViewportSize();

    if v377.Y > v377.X then
        u374.TextSize = 16;
    else
        u374.TextSize = 24;
    end;

    UITextSizeConstraint.MaxTextSize = u374.TextSize;
    u12[u373] = onResized;
    getViewportSize();
    local v378 = getViewportSize();

    if v378.Y > v378.X then
        u374.TextSize = 16;
    else
        u374.TextSize = 24;
    end;

    UITextSizeConstraint.MaxTextSize = u374.TextSize;
    local u379 = nil;
    local u380 = nil;

    if p367 == "Slider" then
        u380 = CreateNewSlider(p368, p369);
        u380.SliderFrame.Parent = u373;
        u379 = u380.SliderFrame;
    elseif p367 == "Selector" then
        u380 = CreateSelector(p368, p369);
        u380.SelectorFrame.Parent = u373;
        u379 = u380.SelectorFrame;
    elseif p367 == "DropDown" then
        u380 = CreateDropDown(p368, p369, u365.HubRef);
        u380.DropDownFrame.Parent = u373;
        u379 = u380.DropDownFrame;
    elseif p367 == "TextBox" then
        local u381 = false;
        local u382 = false;
        local v383 = u11.Create("ImageLabel")({
            Image = "",
            BackgroundTransparency = 1
        });
        u380 = {
            HubRef = nil
        };
        local u384 = u11.Create("TextBox")({
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            TextWrapped = true,
            TextSize = 24,
            ZIndex = 2,
            ClearTextOnFocus = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Size = UDim2.new(0.6, 0, 1, 0),
            Position = UDim2.new(1, 0, 0.5, 0),
            Text = u366,
            TextColor3 = Color3.fromRGB(49, 49, 49),
            TextYAlignment = Enum.TextYAlignment.Top,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.SourceSans,
            SelectionImageObject = v383,
            Parent = u373
        });
        u379 = u384;
        u384.Focused:Connect(function() -- Line: 2146
            -- upvalues: VRService (ref), UserInputService (ref), GuiService (ref), u384 (copy), u366 (copy)
            local v385;

            if VRService.VREnabled then
                v385 = false;
            else
                v385 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v385 then
                GuiService.SelectedCoreObject = u384;
            end;

            if u384.Text == u366 then
                u384.Text = "";
            end;
        end);
        u384.FocusLost:Connect(function(p386, p387) -- Line: 2155
            -- upvalues: u382 (ref)
            u382 = false;
        end);

        if p370 then
            u384.Position = UDim2.new(u384.Position.X.Scale, u384.Position.X.Offset, u384.Position.Y.Scale, u384.Position.Y.Offset + p370);
        end;

        u379.SelectionGained:Connect(function() -- Line: 2163
            -- upvalues: VRService (ref), UserInputService (ref), u384 (copy), u380 (ref), u379 (ref)
            local v388;

            if VRService.VREnabled then
                v388 = false;
            else
                v388 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v388 then
                u384.BackgroundTransparency = 0.1;

                if u380.HubRef then
                    u380.HubRef:ScrollToFrame(u379);
                end;
            end;
        end);
        u379.SelectionLost:Connect(function() -- Line: 2172
            -- upvalues: VRService (ref), UserInputService (ref), u384 (copy)
            local v389;

            if VRService.VREnabled then
                v389 = false;
            else
                v389 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v389 then
                u384.BackgroundTransparency = 0.5;
            end;
        end);

        local function v391(p390) -- Line: 2189
            -- upvalues: GuiService (ref), u379 (ref), u382 (ref), u384 (copy)
            if p390.UserInputState == Enum.UserInputState.Begin and (p390.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == u379) then
                u382 = true;
                u384:CaptureFocus();
            end;
        end;

        u384.MouseEnter:Connect(function() -- Line: 2178
            -- upvalues: PlayerGui (ref), u379 (ref), VRService (ref), UserInputService (ref), u365 (copy), GuiService (ref), u381 (ref)
            local DropDownFullscreenFrame = PlayerGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame");

            if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
                return;
            end;

            local v392 = u379;

            if v392 and (v392.Visible and v392.ZIndex > 1) then
                local v393;

                if VRService.VREnabled then
                    v393 = false;
                else
                    v393 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
                end;

                if v393 and u365.Active then
                    GuiService.SelectedCoreObject = v392;
                    u381 = true;
                end;
            end;
        end);
        UserInputService.InputBegan:Connect(v391);
    elseif p367 == "TextEntry" then
        local u394 = false;
        local u395 = false;
        local v396 = u11.Create("ImageLabel")({
            Image = "",
            BackgroundTransparency = 1
        });
        u380 = {
            HubRef = nil
        };
        local u397 = u11.Create("TextBox")({
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextWrapped = false,
            TextSize = 24,
            ZIndex = 2,
            ClearTextOnFocus = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Size = UDim2.new(0.4, -10, 0, 40),
            Position = UDim2.new(1, 0, 0.5, 0),
            Text = u366,
            TextColor3 = Color3.fromRGB(178, 178, 178),
            TextYAlignment = Enum.TextYAlignment.Center,
            TextXAlignment = Enum.TextXAlignment.Center,
            Font = Enum.Font.SourceSans,
            SelectionImageObject = v396,
            Parent = u373
        });
        u379 = u397;
        u397.Focused:Connect(function() -- Line: 2236
            -- upvalues: VRService (ref), UserInputService (ref), GuiService (ref), u397 (copy), u366 (copy)
            local v398;

            if VRService.VREnabled then
                v398 = false;
            else
                v398 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v398 then
                GuiService.SelectedCoreObject = u397;
            end;

            if u397.Text == u366 then
                u397.Text = "";
            end;
        end);
        u397.FocusLost:Connect(function(p399, p400) -- Line: 2245
            -- upvalues: u395 (ref)
            u395 = false;
        end);

        if p370 then
            u397.Position = UDim2.new(u397.Position.X.Scale, u397.Position.X.Offset, u397.Position.Y.Scale, u397.Position.Y.Offset + p370);
        end;

        u379.SelectionGained:Connect(function() -- Line: 2253
            -- upvalues: VRService (ref), UserInputService (ref), u397 (copy), u380 (ref), u379 (ref)
            local v401;

            if VRService.VREnabled then
                v401 = false;
            else
                v401 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v401 then
                u397.BackgroundTransparency = 0.8;

                if u380.HubRef then
                    u380.HubRef:ScrollToFrame(u379);
                end;
            end;
        end);
        u379.SelectionLost:Connect(function() -- Line: 2262
            -- upvalues: VRService (ref), UserInputService (ref), u397 (copy)
            local v402;

            if VRService.VREnabled then
                v402 = false;
            else
                v402 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v402 then
                u397.BackgroundTransparency = 1;
            end;
        end);

        local function v404(p403) -- Line: 2279
            -- upvalues: GuiService (ref), u379 (ref), u395 (ref), u397 (copy)
            if p403.UserInputState == Enum.UserInputState.Begin and (p403.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == u379) then
                u395 = true;
                u397:CaptureFocus();
            end;
        end;

        u373.MouseEnter:Connect(function() -- Line: 2268
            -- upvalues: PlayerGui (ref), u379 (ref), VRService (ref), UserInputService (ref), u365 (copy), GuiService (ref), u394 (ref)
            local DropDownFullscreenFrame = PlayerGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame");

            if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
                return;
            end;

            local v405 = u379;

            if v405 and (v405.Visible and v405.ZIndex > 1) then
                local v406;

                if VRService.VREnabled then
                    v406 = false;
                else
                    v406 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
                end;

                if v406 and u365.Active then
                    GuiService.SelectedCoreObject = v405;
                    u394 = true;
                end;
            end;
        end);

        function u380.SetZIndex(p407, p408) -- Line: 2291
            -- upvalues: u397 (copy)
            u397.ZIndex = p408;
        end;

        function u380.SetInteractable(p409, p410) -- Line: 2295
            -- upvalues: u397 (copy)
            u397.Selectable = p410;

            if p410 then
                u397.TextColor3 = Color3.fromRGB(178, 178, 178);
                u397.ZIndex = 2;

                return;
            end;

            u397.TextColor3 = Color3.fromRGB(49, 49, 49);
            u397.ZIndex = 1;
        end;

        function u380.SetValue(p411, p412) -- Line: 2306
            -- upvalues: u397 (copy)
            u397.Text = p412;
        end;

        local BindableEvent = Instance.new("BindableEvent");
        BindableEvent.Name = "ValueChanged";
        u397.FocusLost:Connect(function() -- Line: 2313
            -- upvalues: BindableEvent (copy), u397 (copy)
            BindableEvent:Fire(u397.Text);
        end);
        u380.ValueChanged = BindableEvent.Event;
        UserInputService.InputBegan:Connect(v404);
    end;

    u380.Name = u366 .. "ValueChanger";
    local v413 = v372 + u363;

    if p370 then
        v413 = v413 + p370;
    end;

    u364[u365] = v413;

    if v371 then
        u373.MouseEnter:Connect(function() -- Line: 2332
            -- upvalues: PlayerGui (ref), u380 (ref), VRService (ref), UserInputService (ref), u365 (copy), GuiService (ref)
            local DropDownFullscreenFrame = PlayerGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame");

            if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
                return;
            end;

            local v414 = u380.SliderFrame or u380.SliderFrame or u380.DropDownFrame or u380.SelectorFrame;

            if v414 and (v414.Visible and v414.ZIndex > 1) then
                local v415;

                if VRService.VREnabled then
                    v415 = false;
                else
                    v415 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
                end;

                if v415 and u365.Active then
                    GuiService.SelectedCoreObject = v414;
                end;
            end;
        end);
        VRService.Changed:Connect(function(p416) -- Line: 2354, Name: onVREnabled
            -- upvalues: VRService (ref), u373 (ref), u379 (ref), GuiService (ref)
            if p416 == "VREnabled" then
                if VRService.VREnabled then
                    u373.Selectable = true;
                    u373.Active = true;
                    u379.Active = true;
                    GuiService.Changed:Connect(function(p417) -- Line: 2360
                        -- upvalues: GuiService (ref), u373 (ref)
                        if p417 == "SelectedCoreObject" then
                            local SelectedCoreObject = GuiService.SelectedCoreObject;

                            if SelectedCoreObject and (SelectedCoreObject == u373 or SelectedCoreObject:IsDescendantOf(u373)) then
                                u373.ImageTransparency = 0.5;
                                u373.BackgroundTransparency = 1;

                                return;
                            end;

                            u373.ImageTransparency = 1;
                            u373.BackgroundTransparency = 1;
                        end;
                    end);

                    return;
                end;

                u373.Selectable = false;
                u373.Active = false;
            end;
        end);

        if VRService.VREnabled then
            u373.Selectable = true;
            u373.Active = true;
            u379.Active = true;
            GuiService.Changed:Connect(function(p418) -- Line: 2360
                -- upvalues: GuiService (ref), u373 (ref)
                if p418 == "SelectedCoreObject" then
                    local SelectedCoreObject = GuiService.SelectedCoreObject;

                    if SelectedCoreObject and (SelectedCoreObject == u373 or SelectedCoreObject:IsDescendantOf(u373)) then
                        u373.ImageTransparency = 0.5;
                        u373.BackgroundTransparency = 1;

                        return;
                    end;

                    u373.ImageTransparency = 1;
                    u373.BackgroundTransparency = 1;
                end;
            end);
        else
            u373.Selectable = false;
            u373.Active = false;
        end;

        u379.SelectionGained:Connect(function() -- Line: 2381
            -- upvalues: VRService (ref), UserInputService (ref), u373 (ref), u380 (ref)
            local v419;

            if VRService.VREnabled then
                v419 = false;
            else
                v419 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v419 then
                if VRService.VREnabled then
                    u373.ImageTransparency = 0.5;
                    u373.BackgroundTransparency = 1;
                else
                    u373.ImageTransparency = 1;
                    u373.BackgroundTransparency = 0.5;
                end;

                if u380.HubRef then
                    u380.HubRef:ScrollToFrame(u373);
                end;
            end;
        end);
        u379.SelectionLost:Connect(function() -- Line: 2396
            -- upvalues: VRService (ref), UserInputService (ref), u373 (ref)
            local v420;

            if VRService.VREnabled then
                v420 = false;
            else
                v420 = (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
            end;

            if v420 then
                u373.ImageTransparency = 1;
                u373.BackgroundTransparency = 1;
            end;
        end);
    end;

    u365:AddRow(u373, u374, u380, p370, false);
    u380.Selection = u379;

    return u373, u374, u380;
end;

local function AddNewRowObject(p421, p422, p423, p424) -- Line: 2411
    -- upvalues: u364 (copy), u11 (copy), u363 (ref), u13 (copy), u12 (copy), getViewportSize (copy), GuiService (copy), VRService (copy)
    local v425 = not u364[p421] and 0 or u364[p421];
    local u426 = u11.Create("ImageButton")({
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
        ImageTransparency = 1,
        Active = false,
        AutoButtonColor = false,
        ZIndex = 2,
        Selectable = false,
        Name = p422 .. "Frame",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 10, 10),
        Size = UDim2.new(1, 0, 0, u363),
        Position = UDim2.new(0, 0, 0, v425),
        SelectionImageObject = u13,
        Parent = p421.Page
    });
    u426.ImageColor3 = u426.BackgroundColor3;
    u426.SelectionGained:Connect(function() -- Line: 2437
        -- upvalues: u426 (copy)
        u426.BackgroundTransparency = 0.5;
    end);
    u426.SelectionLost:Connect(function() -- Line: 2440
        -- upvalues: u426 (copy)
        u426.BackgroundTransparency = 1;
    end);
    local u427 = u11.Create("TextLabel")({
        TextSize = 16,
        BackgroundTransparency = 1,
        ZIndex = 2,
        Name = p422 .. "Label",
        Text = p422,
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Parent = u426
    });

    u12[u426] = function(p428, p429) -- Line: 2458, Name: onResized
        -- upvalues: u427 (copy)
        if p429 then
            u427.TextSize = 16;

            return;
        end;

        u427.TextSize = 24;
    end;

    getViewportSize();
    local v430 = getViewportSize();

    if v430.Y > v430.X then
        u427.TextSize = 16;
    else
        u427.TextSize = 24;
    end;

    if p424 then
        u426.Position = UDim2.new(u426.Position.X.Scale, u426.Position.X.Offset, u426.Position.Y.Scale, u426.Position.Y.Offset + p424);
    end;

    local v431 = v425 + u363;

    if p424 then
        v431 = v431 + p424;
    end;

    u364[p421] = v431;
    u426.MouseEnter:Connect(function() -- Line: 2479
        -- upvalues: u426 (copy), GuiService (ref)
        if u426.Visible then
            GuiService.SelectedCoreObject = u426;
        end;
    end);
    p423.SelectionImageObject = u13;
    p423.SelectionGained:Connect(function() -- Line: 2488
        -- upvalues: VRService (ref), u426 (copy)
        if VRService.VREnabled then
            u426.ImageTransparency = 0.5;
            u426.BackgroundTransparency = 1;

            return;
        end;

        u426.ImageTransparency = 1;
        u426.BackgroundTransparency = 0.5;
    end);
    p423.SelectionLost:Connect(function() -- Line: 2497
        -- upvalues: u426 (copy)
        u426.ImageTransparency = 1;
        u426.BackgroundTransparency = 1;
    end);
    p423.Parent = u426;
    p421:AddRow(u426, u427, p423, p424, true);

    return u426;
end;

local u513 = {
    Create = function(p432, u433) -- Line: 2511, Name: Create
        return function(p434) -- Line: 2512
            -- upvalues: u433 (copy)
            local v435 = Instance.new(u433);
            local v436 = nil;

            for i, v in pairs(p434) do
                if type(i) == "number" then
                    v.Parent = v435;
                elseif i == "Parent" then
                    v436 = v;
                else
                    v435[i] = v;
                end;
            end;

            if v436 then
                v435.Parent = v436;
            end;

            return v435;
        end;
    end,

    RayPlaneIntersection = function(p437, p438, p439, p440) -- Line: 2533, Name: RayPlaneIntersection
        local unit = p439.unit;
        local Unit = p438.Unit;
        local v441 = unit:Dot(Unit.Direction);

        if v441 == 0 then
            return nil;
        end;

        local v442 = unit:Dot(p440 - Unit.Origin) / v441;

        if v442 < 0 then
            return nil;
        end;

        return Unit.Origin + Unit.Direction * v442;
    end,

    GetEaseLinear = function(p443) -- Line: 2551, Name: GetEaseLinear
        -- upvalues: Linear (copy)
        return Linear;
    end,

    GetEaseOutQuad = function(p444) -- Line: 2554, Name: GetEaseOutQuad
        -- upvalues: EaseOutQuad (copy)
        return EaseOutQuad;
    end,

    GetEaseInOutQuad = function(p445) -- Line: 2557, Name: GetEaseInOutQuad
        -- upvalues: EaseInOutQuad (copy)
        return EaseInOutQuad;
    end,

    CreateNewSlider = function(p446, p447, p448, p449) -- Line: 2561, Name: CreateNewSlider
        -- upvalues: CreateNewSlider (copy)
        return CreateNewSlider(p447, p448, p449);
    end,

    CreateNewSelector = function(p450, p451, p452) -- Line: 2565, Name: CreateNewSelector
        -- upvalues: CreateSelector (copy)
        return CreateSelector(p451, p452);
    end,

    CreateNewDropDown = function(p453, p454, p455) -- Line: 2569, Name: CreateNewDropDown
        -- upvalues: CreateDropDown (copy)
        return CreateDropDown(p454, p455, nil);
    end,

    AddNewRow = function(p456, p457, p458, p459, p460, p461, p462) -- Line: 2573, Name: AddNewRow
        -- upvalues: AddNewRow (copy)
        return AddNewRow(p457, p458, p459, p460, p461, p462);
    end,

    AddNewRowObject = function(p463, p464, p465, p466, p467) -- Line: 2577, Name: AddNewRowObject
        -- upvalues: AddNewRowObject (copy)
        return AddNewRowObject(p464, p465, p466, p467);
    end,

    ShowAlert = function(p468, p469, p470, p471, p472, p473) -- Line: 2581, Name: ShowAlert
        -- upvalues: ShowAlert (copy)
        ShowAlert(p469, p470, p471, p472, p473);
    end,

    IsSmallTouchScreen = function(p474) -- Line: 2585, Name: IsSmallTouchScreen
        -- upvalues: getViewportSize (copy), UserInputService (copy)
        local v475 = getViewportSize();

        return UserInputService.TouchEnabled and (v475.Y < 500 and true or v475.X < 700);
    end,

    IsPortrait = function(p476) -- Line: 2589, Name: IsPortrait
        -- upvalues: getViewportSize (copy)
        local v477 = getViewportSize();

        return v477.Y > v477.X;
    end,

    MakeStyledButton = function(p478, p479, p480, p481, p482, p483, p484) -- Line: 2593, Name: MakeStyledButton
        -- upvalues: MakeButton (copy)
        return MakeButton(p479, p480, p481, p482, p483, p484);
    end,

    MakeStyledImageButton = function(p485, p486, p487, p488, p489, p490, p491, p492) -- Line: 2597, Name: MakeStyledImageButton
        -- upvalues: MakeImageButton (copy)
        return MakeImageButton(p486, p487, p488, p489, p490, p491, p492);
    end,

    AddButtonRow = function(p493, p494, p495, p496, p497, p498, p499) -- Line: 2601, Name: AddButtonRow
        -- upvalues: AddButtonRow (copy)
        return AddButtonRow(p494, p495, p496, p497, p498, p499);
    end,

    CreateSignal = function(p500) -- Line: 2605, Name: CreateSignal
        -- upvalues: CreateSignal (copy)
        return CreateSignal();
    end,

    UsesSelectedObject = function(p501) -- Line: 2609, Name: UsesSelectedObject
        -- upvalues: VRService (copy), UserInputService (copy)
        if VRService.VREnabled then
            return false;
        end;

        return (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and true or false;
    end,

    TweenProperty = function(p502, p503, p504, p505, p506, p507, p508, p509) -- Line: 2613, Name: TweenProperty
        return PropertyTweener(p503, p504, p505, p506, p507, p508, p509);
    end,

    OnResized = function(p510, p511, p512) -- Line: 2617, Name: OnResized
        -- upvalues: addOnResizedCallback (copy)
        return addOnResizedCallback(p511, p512);
    end
};

function u513.FireOnResized(p514) -- Line: 2621
    -- upvalues: getViewportSize (copy), u513 (copy), u12 (copy)
    local v515 = getViewportSize();
    local v516 = u513:IsPortrait();

    for _, v in pairs(u12) do
        v(v515, v516);
    end;
end;

function u513.Lerp(p517, p518, p519, p520) -- Line: 2632
    return (1 - p518) * p519 + p518 * p520;
end;

function u513.Round(p521, p522) -- Line: 2637
    return p522 % 1 >= 0.5 and math.ceil(p522) or math.floor(p522);
end;

return u513;