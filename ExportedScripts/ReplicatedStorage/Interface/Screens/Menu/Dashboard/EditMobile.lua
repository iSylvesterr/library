-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local Mobile = require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = false;
local u6 = false;
local u7 = Mobile.GetDefaultLayout();
local u8 = Mobile.GetDefaultLayout();
local u9 = false;
local u10 = {};
local u11 = {};
local u12 = nil;
local u13 = nil;

local function IsTouchInputType(p14) -- Line: 62
    return p14 == Enum.UserInputType.Touch;
end;

local function IsMobilePlatform() -- Line: 66
    -- upvalues: GetUserPlatform (copy)
    local v15 = GetUserPlatform();
    local v16;

    if table.find(v15, "Mobile") == nil then
        v16 = false;
    else
        v16 = #v15 <= 1;
    end;

    return v16;
end;

local function ShouldShowMobileHUDEditor(p17) -- Line: 71
    -- upvalues: GetUserPlatform (copy), UserInputService (copy)
    local v18 = GetUserPlatform();
    local v19;

    if table.find(v18, "Mobile") == nil then
        v19 = false;
    else
        v19 = #v18 <= 1;
    end;

    return v19 or (p17 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch;
end;

local function DeepCopyLayout(p20) -- Line: 77
    -- upvalues: Mobile (copy)
    local v21 = {};

    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        local v22 = p20[v] or Mobile.GetDefaultButtonLayout(v);
        v21[v] = {
            Position = {
                X = v22.Position.X,
                Y = v22.Position.Y
            },
            Size = {
                X = v22.Size.X,
                Y = v22.Size.Y
            }
        };
    end;

    return v21;
end;

local function GetInputGuiPosition(p23) -- Line: 97
    -- upvalues: GuiService (copy)
    local v24 = GuiService:GetGuiInset();

    return Vector2.new(p23.Position.X - v24.X, p23.Position.Y - v24.Y);
end;

local function GetInputScreenPosition(p25) -- Line: 104
    return Vector2.new(p25.Position.X, p25.Position.Y);
end;

local function SetChildFrameVisible(p26, p27, p28) -- Line: 110
    if not p26 then
        return;
    end;

    local v29 = p26:FindFirstChild(p27);

    if v29 and v29:IsA("Frame") then
        v29.Visible = p28;
    end;
end;

local function PlayUIClick() -- Line: 122
    -- upvalues: Router (copy)
    Router.broadcastRouter("RunInterfaceSound", "UI Click");
end;

local function GetEditMobileEntryButton() -- Line: 128
    -- upvalues: u3 (ref)
    local v30 = u3;

    if not v30 then
        return nil;
    end;

    local Holder = v30:FindFirstChild("Holder");

    if not (Holder and Holder:IsA("Frame")) then
        return nil;
    end;

    local EditMobile = Holder:FindFirstChild("EditMobile");

    if EditMobile and EditMobile:IsA("Frame") then
        return EditMobile:FindFirstChild("EditMobile");
    end;

    return nil;
end;

local function GetEditMobileFrame() -- Line: 149
    -- upvalues: u4 (ref), u3 (ref)
    local v31 = u4;

    if v31 and v31.Parent then
        return v31;
    end;

    local v32 = u3;

    if not v32 then
        return nil;
    end;

    local EditMobile = v32:FindFirstChild("EditMobile");

    if EditMobile then
        v32 = EditMobile;
    elseif v32.Name ~= "EditMobile" then
        v32 = EditMobile;
    end;

    u4 = v32;

    return v32;
end;

local function GetDashboardContainerFrame() -- Line: 170
    -- upvalues: u3 (ref)
    local v33 = u3;

    if not v33 then
        return nil;
    end;

    local Container = v33:FindFirstChild("Container");

    if Container and Container:IsA("Frame") then
        return Container;
    end;

    return nil;
end;

local function GetDashboardHolderFrame() -- Line: 186
    -- upvalues: u3 (ref)
    local v34 = u3;

    if not v34 then
        return nil;
    end;

    local Holder = v34:FindFirstChild("Holder");

    if Holder and Holder:IsA("Frame") then
        return Holder;
    end;

    return nil;
end;

local function GetMenuTopFrame() -- Line: 202
    -- upvalues: u2 (ref)
    local v35 = u2;

    if not v35 then
        return nil;
    end;

    local Menu = v35:FindFirstChild("Menu");

    if not (Menu and Menu:IsA("Frame")) then
        return nil;
    end;

    local Top = Menu:FindFirstChild("Top");

    if Top and Top:IsA("Frame") then
        return Top;
    end;

    return nil;
end;

local function GetEditorButtonsFrame() -- Line: 223
    -- upvalues: u4 (ref), u3 (ref)
    local v36 = u4;

    if not (v36 and v36.Parent) then
        v36 = u3;

        if v36 then
            local EditMobile = v36:FindFirstChild("EditMobile");

            if EditMobile then
                v36 = EditMobile;
            elseif v36.Name ~= "EditMobile" then
                v36 = EditMobile;
            end;

            u4 = v36;
        else
            v36 = nil;
        end;
    end;

    if v36 then
        return v36:FindFirstChild("MobileButtons");
    end;

    return nil;
end;

local function GetGameplayMobileButtonsFrame() -- Line: 233
    -- upvalues: u2 (ref)
    local v37 = u2;

    if not v37 then
        return nil;
    end;

    local Gameplay = v37:FindFirstChild("Gameplay");

    if not Gameplay then
        return nil;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");

    if not Middle then
        return nil;
    end;

    local MobileButtons = Middle:FindFirstChild("MobileButtons");

    if MobileButtons and MobileButtons:IsA("Frame") then
        return MobileButtons;
    end;

    return nil;
end;

local function ApplyEditorButtonLayout(p38) -- Line: 259
    -- upvalues: u4 (ref), u3 (ref), u8 (ref)
    local v39 = u4;

    if not (v39 and v39.Parent) then
        v39 = u3;

        if v39 then
            local EditMobile = v39:FindFirstChild("EditMobile");

            if EditMobile then
                v39 = EditMobile;
            elseif v39.Name ~= "EditMobile" then
                v39 = EditMobile;
            end;

            u4 = v39;
        else
            v39 = nil;
        end;
    end;

    local v40;

    if v39 then
        v40 = v39:FindFirstChild("MobileButtons");
    else
        v40 = nil;
    end;

    if not v40 then
        return;
    end;

    local v41 = v40:FindFirstChild(p38);
    local v42 = u8[p38];

    if not (v41 and v42) then
        return;
    end;

    v41.Position = UDim2.fromScale(v42.Position.X, v42.Position.Y);
    v41.Size = UDim2.fromScale(v42.Size.X, v42.Size.Y);
end;

local function ApplyEditorLayout() -- Line: 277
    -- upvalues: Mobile (copy), ApplyEditorButtonLayout (copy)
    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        ApplyEditorButtonLayout(v);
    end;
end;

local function AreLayoutsEqual(p43, p44) -- Line: 285
    -- upvalues: Mobile (copy)
    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        local v45 = p43[v] or Mobile.GetDefaultButtonLayout(v);
        local v46 = p44[v] or Mobile.GetDefaultButtonLayout(v);

        if v45.Position.X ~= v46.Position.X or (v45.Position.Y ~= v46.Position.Y or (v45.Size.X ~= v46.Size.X or v45.Size.Y ~= v46.Size.Y)) then
            return false;
        end;
    end;

    return true;
end;

local function SetDashboardEditorVisibility(p47) -- Line: 304
    -- upvalues: u4 (ref), u3 (ref), GetMenuTopFrame (copy), MenuState (copy)
    local v48 = u4;

    if not (v48 and v48.Parent) then
        v48 = u3;

        if v48 then
            local EditMobile = v48:FindFirstChild("EditMobile");

            if EditMobile then
                v48 = EditMobile;
            elseif v48.Name ~= "EditMobile" then
                v48 = EditMobile;
            end;

            u4 = v48;
        else
            v48 = nil;
        end;
    end;

    if v48 then
        v48.Visible = p47;

        if v48 then
            local Action = v48:FindFirstChild("Action");

            if Action and Action:IsA("Frame") then
                Action.Visible = p47;
            end;
        end;

        if v48 then
            local Notification = v48:FindFirstChild("Notification");

            if Notification and Notification:IsA("Frame") then
                Notification.Visible = p47;
            end;
        end;

        if v48 then
            local MobileButtons = v48:FindFirstChild("MobileButtons");

            if MobileButtons and MobileButtons:IsA("Frame") then
                MobileButtons.Visible = p47;
            end;
        end;

        if v48 then
            local GameDashboard = v48:FindFirstChild("GameDashboard");

            if GameDashboard and GameDashboard:IsA("Frame") then
                GameDashboard.Visible = false;
            end;
        end;
    end;

    local v49 = GetMenuTopFrame();

    if v49 then
        if p47 then
            v49.Visible = false;
        elseif not (MenuState.IsInspectActive() or MenuState.IsCaseSceneActive()) then
            v49.Visible = true;
        end;
    end;

    local v50 = u3;
    local v51;

    if v50 then
        v51 = v50:FindFirstChild("Container");

        if not (v51 and v51:IsA("Frame")) then
            v51 = nil;
        end;
    else
        v51 = nil;
    end;

    if v51 then
        v51.Visible = not p47;
    end;

    local v52 = u3;
    local v53;

    if v52 then
        v53 = v52:FindFirstChild("Holder");

        if not (v53 and v53:IsA("Frame")) then
            v53 = nil;
        end;
    else
        v53 = nil;
    end;

    if v53 then
        v53.Visible = not p47;
    end;

    local v54 = u3;
    local v55 = not p47;

    if v54 then
        local Left = v54:FindFirstChild("Left");

        if Left and Left:IsA("Frame") then
            Left.Visible = v55;
        end;
    end;

    local v56 = u3;
    local v57 = not p47;

    if not v56 then
        return;
    end;

    local Right = v56:FindFirstChild("Right");

    if Right and Right:IsA("Frame") then
        Right.Visible = v57;
    end;
end;

local function EnforceEditorVisibilityLock() -- Line: 340
    -- upvalues: u5 (ref), GetMenuTopFrame (copy), u3 (ref)
    if not u5 then
        return;
    end;

    local v58 = GetMenuTopFrame();

    if v58 and v58.Visible then
        v58.Visible = false;
    end;

    local v59 = u3;
    local v60;

    if v59 then
        v60 = v59:FindFirstChild("Container");

        if not (v60 and v60:IsA("Frame")) then
            v60 = nil;
        end;
    else
        v60 = nil;
    end;

    if v60 and v60.Visible then
        v60.Visible = false;
    end;

    local v61 = u3;
    local v62;

    if v61 then
        v62 = v61:FindFirstChild("Holder");

        if not (v62 and v62:IsA("Frame")) then
            v62 = nil;
        end;
    else
        v62 = nil;
    end;

    if v62 and v62.Visible then
        v62.Visible = false;
    end;

    local v63 = u3;

    if v63 then
        local Left = v63:FindFirstChild("Left");

        if Left and Left:IsA("Frame") then
            Left.Visible = false;
        end;
    end;

    local v64 = u3;

    if not v64 then
        return;
    end;

    local Right = v64:FindFirstChild("Right");

    if Right and Right:IsA("Frame") then
        Right.Visible = false;
    end;
end;

local function ConnectEditorVisibilityGuards() -- Line: 366
    -- upvalues: u9 (ref), GetMenuTopFrame (copy), u3 (ref), EnforceEditorVisibilityLock (copy)
    if u9 then
        return;
    end;

    local v65 = GetMenuTopFrame();
    local v66 = u3;
    local v67;

    if v66 then
        v67 = v66:FindFirstChild("Container");

        if not (v67 and v67:IsA("Frame")) then
            v67 = nil;
        end;
    else
        v67 = nil;
    end;

    local v68 = u3;
    local v69;

    if v68 then
        v69 = v68:FindFirstChild("Holder");

        if not (v69 and v69:IsA("Frame")) then
            v69 = nil;
        end;
    else
        v69 = nil;
    end;

    if not (v65 or (v67 or v69)) then
        return;
    end;

    u9 = true;

    if v65 then
        v65:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 381
            -- upvalues: EnforceEditorVisibilityLock (ref)
            EnforceEditorVisibilityLock();
        end);
    end;

    if v67 then
        v67:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 386
            -- upvalues: EnforceEditorVisibilityLock (ref)
            EnforceEditorVisibilityLock();
        end);
    end;

    if v69 then
        v69:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 391
            -- upvalues: EnforceEditorVisibilityLock (ref)
            EnforceEditorVisibilityLock();
        end);
    end;

    local v70 = u3;

    if v70 then
        for _, v in ipairs({ "Left", "Right" }) do
            local v71 = v70:FindFirstChild(v);

            if v71 and v71:IsA("Frame") then
                v71:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 401
                    -- upvalues: EnforceEditorVisibilityLock (ref)
                    EnforceEditorVisibilityLock();
                end);
            end;
        end;
    end;
end;

local function ClearEditorInteractionState() -- Line: 411
    -- upvalues: u10 (ref), u11 (ref), u12 (ref), u13 (ref)
    u10 = {};
    u11 = {};
    u12 = nil;
    u13 = nil;
end;

local function RemoveTouchFromButton(p72) -- Line: 420
    -- upvalues: u10 (ref), u11 (ref)
    local v73 = u10[p72];

    if not v73 then
        return nil;
    end;

    u10[p72] = nil;
    local v74 = u11[v73];

    if v74 then
        v74[p72] = nil;

        if next(v74) == nil then
            u11[v73] = nil;
        end;
    end;

    return v73;
end;

local function GetButtonTouches(p75) -- Line: 440
    -- upvalues: u11 (ref)
    local v76 = u11[p75];

    if not v76 then
        return {};
    end;

    local v77 = {};

    for i in pairs(v76) do
        table.insert(v77, i);
    end;

    return v77;
end;

local function UpdateEditorButtonLayout(p78, p79) -- Line: 455
    -- upvalues: u8 (ref), Mobile (copy), ApplyEditorButtonLayout (copy)
    u8[p78] = Mobile.ClampButtonLayout(p79);
    ApplyEditorButtonLayout(p78);
end;

local function StartEditorDrag(p80, p81) -- Line: 462
    -- upvalues: u8 (ref), u13 (ref), u12 (ref), GuiService (copy)
    local v82 = u8[p80];

    if not v82 then
        return;
    end;

    u13 = nil;
    local v83 = {
        buttonName = p80,
        input = p81
    };
    local v84 = GuiService:GetGuiInset();
    v83.startPosition = Vector2.new(p81.Position.X - v84.X, p81.Position.Y - v84.Y);
    v83.startLayout = {
        Position = {
            X = v82.Position.X,
            Y = v82.Position.Y
        },
        Size = {
            X = v82.Size.X,
            Y = v82.Size.Y
        }
    };
    u12 = v83;
end;

local function StartEditorPinch(p85, p86, p87) -- Line: 488
    -- upvalues: u8 (ref), u4 (ref), u3 (ref), u12 (ref), u13 (ref)
    local v88 = u8[p85];

    if not v88 then
        return;
    end;

    local v89 = u4;

    if not (v89 and v89.Parent) then
        v89 = u3;

        if v89 then
            local EditMobile = v89:FindFirstChild("EditMobile");

            if EditMobile then
                v89 = EditMobile;
            elseif v89.Name ~= "EditMobile" then
                v89 = EditMobile;
            end;

            u4 = v89;
        else
            v89 = nil;
        end;
    end;

    local v90;

    if v89 then
        v90 = v89:FindFirstChild("MobileButtons");
    else
        v90 = nil;
    end;

    if not v90 then
        return;
    end;

    local AbsoluteSize = v90.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local v91 = Vector2.new(p86.Position.X, p86.Position.Y);
    local AbsolutePosition = v90.AbsolutePosition;
    local Magnitude = (Vector2.new(p87.Position.X, p87.Position.Y) - v91).Magnitude;
    local v92 = math.max(Magnitude, 1);
    local v93 = Vector2.new((v91.X - AbsolutePosition.X) / AbsoluteSize.X, (v91.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
    local v94 = v88.Size.Y <= 0 and 0.5 or (v93.Y - v88.Position.Y) / v88.Size.Y;
    u12 = nil;
    u13 = {
        buttonName = p85,
        anchorInput = p86,
        scaleInput = p87,
        anchorLocalScale = Vector2.new(math.clamp(v88.Size.X <= 0 and 0.5 or (v93.X - v88.Position.X) / v88.Size.X, 0, 1), (math.clamp(v94, 0, 1))),
        lastDistance = v92,
        lastLayout = {
            Position = {
                X = v88.Position.X,
                Y = v88.Position.Y
            },
            Size = {
                X = v88.Size.X,
                Y = v88.Size.Y
            }
        }
    };
end;

local function TryStartEditorPinchWithSecondTouch(p95) -- Line: 546
    -- upvalues: u12 (ref), u13 (ref), StartEditorPinch (copy)
    local v96 = u12;

    if not v96 or u13 then
        return;
    end;

    if v96.input == p95 then
        return;
    end;

    StartEditorPinch(v96.buttonName, v96.input, p95);
end;

local function RefreshEditorInteraction(p97) -- Line: 560
    -- upvalues: u13 (ref), GetButtonTouches (copy), u12 (ref), StartEditorDrag (copy)
    if u13 and u13.buttonName == p97 then
        return;
    end;

    local v98 = GetButtonTouches(p97);

    if #v98 <= 0 then
        if u12 and u12.buttonName == p97 then
            u12 = nil;
        end;

        if u13 and u13.buttonName == p97 then
            u13 = nil;
        end;

        return;
    end;

    local v99 = v98[1];
    local v100 = u12;

    if v100 and v100.buttonName == p97 then
        for _, v in ipairs(v98) do
            if v == v100.input then
                v99 = v;
                break;
            end;
        end;
    end;

    StartEditorDrag(p97, v99);
end;

local function UpdateDragFromInput(p101) -- Line: 592
    -- upvalues: u12 (ref), u4 (ref), u3 (ref), u8 (ref), GuiService (copy), Mobile (copy), ApplyEditorButtonLayout (copy)
    local v102 = u12;

    if not v102 or p101 ~= v102.input then
        return;
    end;

    local v103 = u4;

    if not (v103 and v103.Parent) then
        v103 = u3;

        if v103 then
            local EditMobile = v103:FindFirstChild("EditMobile");

            if EditMobile then
                v103 = EditMobile;
            elseif v103.Name ~= "EditMobile" then
                v103 = EditMobile;
            end;

            u4 = v103;
        else
            v103 = nil;
        end;
    end;

    local v104;

    if v103 then
        v104 = v103:FindFirstChild("MobileButtons");
    else
        v104 = nil;
    end;

    local v105 = u8[v102.buttonName];

    if not (v104 and v105) then
        return;
    end;

    local AbsoluteSize = v104.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local v106 = GuiService:GetGuiInset();
    local v107 = Vector2.new(p101.Position.X - v106.X, p101.Position.Y - v106.Y) - v102.startPosition;
    local buttonName = v102.buttonName;
    u8[buttonName] = Mobile.ClampButtonLayout({
        Position = {
            X = v102.startLayout.Position.X + v107.X / AbsoluteSize.X,
            Y = v102.startLayout.Position.Y + v107.Y / AbsoluteSize.Y
        },
        Size = {
            X = v105.Size.X,
            Y = v105.Size.Y
        }
    });
    ApplyEditorButtonLayout(buttonName);
end;

local function UpdatePinchFromInput(p108) -- Line: 628
    -- upvalues: u13 (ref), u4 (ref), u3 (ref), u8 (ref), Mobile (copy), ApplyEditorButtonLayout (copy)
    local v109 = u13;

    if not v109 then
        return;
    end;

    if p108 ~= v109.scaleInput and p108 ~= v109.anchorInput then
        return;
    end;

    local anchorInput = v109.anchorInput;
    local v110 = Vector2.new(anchorInput.Position.X, anchorInput.Position.Y);
    local scaleInput = v109.scaleInput;
    local v111 = Vector2.new(scaleInput.Position.X, scaleInput.Position.Y);
    local v112 = math.max((v111 - v110).Magnitude, 1);
    local v113 = v112 / math.max(v109.lastDistance, 1);
    local v114 = v109.lastLayout.Size.X * v113;
    local v115 = v109.lastLayout.Size.Y * v113;
    local v116 = u4;

    if not (v116 and v116.Parent) then
        v116 = u3;

        if v116 then
            local EditMobile = v116:FindFirstChild("EditMobile");

            if EditMobile then
                v116 = EditMobile;
            elseif v116.Name ~= "EditMobile" then
                v116 = EditMobile;
            end;

            u4 = v116;
        else
            v116 = nil;
        end;
    end;

    local v117;

    if v116 then
        v117 = v116:FindFirstChild("MobileButtons");
    else
        v117 = nil;
    end;

    if not v117 then
        return;
    end;

    local AbsoluteSize = v117.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local AbsolutePosition = v117.AbsolutePosition;
    local v118 = Vector2.new((v110.X - AbsolutePosition.X) / AbsoluteSize.X, (v110.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
    local v119 = v118.X - v109.anchorLocalScale.X * v114;
    local v120 = v118.Y - v109.anchorLocalScale.Y * v115;

    if v119 ~= v119 or v120 ~= v120 then
        local v121 = (v110 + v111) * 0.5;
        local v122 = Vector2.new((v121.X - AbsolutePosition.X) / AbsoluteSize.X, (v121.Y - AbsolutePosition.Y) / AbsoluteSize.Y);
        v119 = v122.X - v114 / 2;
        v120 = v122.Y - v115 / 2;
    end;

    local buttonName = v109.buttonName;
    u8[buttonName] = Mobile.ClampButtonLayout({
        Position = {
            X = v119,
            Y = v120
        },
        Size = {
            X = v114,
            Y = v115
        }
    });
    ApplyEditorButtonLayout(buttonName);
    local v123 = u8[v109.buttonName];

    if v123 then
        v109.lastLayout = {
            Position = {
                X = v123.Position.X,
                Y = v123.Position.Y
            },
            Size = {
                X = v123.Size.X,
                Y = v123.Size.Y
            }
        };
    end;

    v109.lastDistance = v112;
end;

local function LoadEditorStateFromProfile() -- Line: 703
    -- upvalues: DataController (copy), LocalPlayer (copy), u7 (ref), Mobile (copy), u8 (ref), DeepCopyLayout (copy), ApplyEditorButtonLayout (copy)
    local v124 = DataController.Get(LocalPlayer, "MobileButtons");
    u7 = Mobile.SanitizeLayout(v124);
    u8 = DeepCopyLayout(u7);

    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        ApplyEditorButtonLayout(v);
    end;
end;

local function ConnectEditorButtonGesture(p125) -- Line: 714
    -- upvalues: u5 (ref), u13 (ref), u12 (ref), u10 (ref), u11 (ref), RefreshEditorInteraction (copy)
    local Name = p125.Name;
    p125.InputBegan:Connect(function(p126) -- Line: 716
        -- upvalues: u5 (ref), u13 (ref), u12 (ref), Name (copy), u10 (ref), u11 (ref), RefreshEditorInteraction (ref)
        if not u5 then
            return;
        end;

        if p126.UserInputType ~= Enum.UserInputType.Touch or p126.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        local v127 = u13 and u13.buttonName or u12 and u12.buttonName;

        if v127 and v127 ~= Name then
            return;
        end;

        u10[p126] = Name;
        u11[Name] = u11[Name] or {};
        u11[Name][p126] = true;
        RefreshEditorInteraction(Name);
    end);
end;

local function PopulateEditorButtons() -- Line: 739
    -- upvalues: u4 (ref), u3 (ref), GetGameplayMobileButtonsFrame (copy), Mobile (copy), u5 (ref), u13 (ref), u12 (ref), u10 (ref), u11 (ref), RefreshEditorInteraction (copy)
    local v128 = u4;

    if not (v128 and v128.Parent) then
        v128 = u3;

        if v128 then
            local EditMobile = v128:FindFirstChild("EditMobile");

            if EditMobile then
                v128 = EditMobile;
            elseif v128.Name ~= "EditMobile" then
                v128 = EditMobile;
            end;

            u4 = v128;
        else
            v128 = nil;
        end;
    end;

    local v129;

    if v128 then
        v129 = v128:FindFirstChild("MobileButtons");
    else
        v129 = nil;
    end;

    local v130 = GetGameplayMobileButtonsFrame();

    if not (v129 and v130) then
        return;
    end;

    for _, child in ipairs(v129:GetChildren()) do
        if child:IsA("GuiButton") then
            child:Destroy();
        end;
    end;

    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        local v131 = v130:FindFirstChild(v);

        if v131 and v131:IsA("GuiButton") then
            local v132 = v131:Clone();
            v132.Visible = true;
            local Use = v132:FindFirstChild("Use");

            if Use and Use:IsA("GuiObject") then
                Use.Visible = true;
            end;

            local Defuse = v132:FindFirstChild("Defuse");

            if Defuse and Defuse:IsA("GuiObject") then
                Defuse.Visible = false;
            end;

            v132.Parent = v129;
            local Name = v132.Name;
            v132.InputBegan:Connect(function(p133) -- Line: 716
                -- upvalues: u5 (ref), u13 (ref), u12 (ref), Name (copy), u10 (ref), u11 (ref), RefreshEditorInteraction (ref)
                if not u5 then
                    return;
                end;

                if p133.UserInputType ~= Enum.UserInputType.Touch or p133.UserInputState ~= Enum.UserInputState.Begin then
                    return;
                end;

                local v134 = u13 and u13.buttonName or u12 and u12.buttonName;

                if v134 and v134 ~= Name then
                    return;
                end;

                u10[p133] = Name;
                u11[Name] = u11[Name] or {};
                u11[Name][p133] = true;
                RefreshEditorInteraction(Name);
            end);
        end;
    end;
end;

local function SetEditorMode(p135) -- Line: 780
    -- upvalues: u5 (ref), SetDashboardEditorVisibility (copy), u10 (ref), u11 (ref), u12 (ref), u13 (ref)
    u5 = p135;
    SetDashboardEditorVisibility(p135);

    if not p135 then
        u10 = {};
        u11 = {};
        u12 = nil;
        u13 = nil;
    end;
end;

local function EnterMobileHUDEditor() -- Line: 790
    -- upvalues: GetUserPlatform (copy), UserInputService (copy), u5 (ref), u6 (ref), DataController (copy), LocalPlayer (copy), Router (copy), u10 (ref), u11 (ref), u12 (ref), u13 (ref), PopulateEditorButtons (copy), u7 (ref), Mobile (copy), u8 (ref), DeepCopyLayout (copy), ApplyEditorButtonLayout (copy), SetDashboardEditorVisibility (copy)
    local v136 = GetUserPlatform();
    local v137;

    if table.find(v136, "Mobile") == nil then
        v137 = false;
    else
        v137 = #v136 <= 1;
    end;

    if not v137 and UserInputService:GetLastInputType() ~= Enum.UserInputType.Touch then
        return;
    end;

    if u5 or u6 then
        return;
    end;

    u6 = true;
    local success = pcall(function() -- Line: 800
        -- upvalues: DataController (ref), LocalPlayer (ref)
        DataController.WaitForDataLoaded(LocalPlayer);
    end);
    u6 = false;

    if not success then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Profile data is still loading. Please try again.");

        return;
    end;

    u10 = {};
    u11 = {};
    u12 = nil;
    u13 = nil;
    PopulateEditorButtons();
    local v138 = DataController.Get(LocalPlayer, "MobileButtons");
    u7 = Mobile.SanitizeLayout(v138);
    u8 = DeepCopyLayout(u7);

    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        ApplyEditorButtonLayout(v);
    end;

    u5 = true;
    SetDashboardEditorVisibility(true);
end;

local function ExitMobileHUDEditor(p139) -- Line: 818
    -- upvalues: u5 (ref), u8 (ref), DeepCopyLayout (copy), u7 (ref), Mobile (copy), ApplyEditorButtonLayout (copy), SetDashboardEditorVisibility (copy), u10 (ref), u11 (ref), u12 (ref), u13 (ref)
    if not u5 then
        return;
    end;

    if not p139 then
        u8 = DeepCopyLayout(u7);

        for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
            ApplyEditorButtonLayout(v);
        end;
    end;

    u5 = false;
    SetDashboardEditorVisibility(false);
    u10 = {};
    u11 = {};
    u12 = nil;
    u13 = nil;
end;

local function UpdateEditMobileButtonVisibility(p140) -- Line: 833
    -- upvalues: GetEditMobileEntryButton (copy), GetUserPlatform (copy), UserInputService (copy), u5 (ref), u8 (ref), DeepCopyLayout (copy), u7 (ref), Mobile (copy), ApplyEditorButtonLayout (copy), SetDashboardEditorVisibility (copy), u10 (ref), u11 (ref), u12 (ref), u13 (ref), MenuState (copy)
    local v141 = GetEditMobileEntryButton();
    local v142;

    if v141 then
        v142 = v141.Parent;
    else
        v142 = v141;
    end;

    local v143 = GetUserPlatform();
    local v144;

    if table.find(v143, "Mobile") == nil then
        v144 = false;
    else
        v144 = #v143 <= 1;
    end;

    local v145 = v144 or (p140 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch;

    if v141 then
        v141.Visible = v145;
    end;

    if v142 and v142:IsA("GuiObject") then
        v142.Visible = v145;
    end;

    if v145 or not u5 then
        if not (v145 or (MenuState.IsInspectActive() or MenuState.IsCaseSceneActive())) then
            SetDashboardEditorVisibility(false);
        end;

        return;
    end;

    if not u5 then
        return;
    end;

    u8 = DeepCopyLayout(u7);

    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        ApplyEditorButtonLayout(v);
    end;

    u5 = false;
    SetDashboardEditorVisibility(false);
    u10 = {};
    u11 = {};
    u12 = nil;
    u13 = nil;
end;

local function ResetEditorToDefaults() -- Line: 854
    -- upvalues: u8 (ref), Mobile (copy), ApplyEditorButtonLayout (copy)
    u8 = Mobile.GetDefaultLayout();

    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        ApplyEditorButtonLayout(v);
    end;
end;

local function HideEditorSliderTemplates() -- Line: 861
    -- upvalues: u4 (ref), u3 (ref)
    local v146 = u4;

    if not (v146 and v146.Parent) then
        v146 = u3;

        if v146 then
            local EditMobile = v146:FindFirstChild("EditMobile");

            if EditMobile then
                v146 = EditMobile;
            elseif v146.Name ~= "EditMobile" then
                v146 = EditMobile;
            end;

            u4 = v146;
        else
            v146 = nil;
        end;
    end;

    if not v146 then
        return;
    end;

    local Notification = v146:FindFirstChild("Notification");

    if not Notification then
        return;
    end;

    local Frame = Notification:FindFirstChild("Frame");

    if not Frame then
        return;
    end;

    for _, child in ipairs(Frame:GetChildren()) do
        if child:IsA("Frame") and child.Name == "SliderTemplate" then
            child.Visible = false;
        end;
    end;
end;

local function ConnectEditorButtonGestures() -- Line: 886
    -- upvalues: u4 (ref), u3 (ref), u5 (ref), u13 (ref), u12 (ref), u10 (ref), u11 (ref), RefreshEditorInteraction (copy)
    local v147 = u4;

    if not (v147 and v147.Parent) then
        v147 = u3;

        if v147 then
            local EditMobile = v147:FindFirstChild("EditMobile");

            if EditMobile then
                v147 = EditMobile;
            elseif v147.Name ~= "EditMobile" then
                v147 = EditMobile;
            end;

            u4 = v147;
        else
            v147 = nil;
        end;
    end;

    local v148;

    if v147 then
        v148 = v147:FindFirstChild("MobileButtons");
    else
        v148 = nil;
    end;

    if not v148 then
        return;
    end;

    for _, child in ipairs(v148:GetChildren()) do
        if child:IsA("GuiButton") then
            local Name = child.Name;
            child.InputBegan:Connect(function(p149) -- Line: 716
                -- upvalues: u5 (ref), u13 (ref), u12 (ref), Name (copy), u10 (ref), u11 (ref), RefreshEditorInteraction (ref)
                if not u5 then
                    return;
                end;

                if p149.UserInputType ~= Enum.UserInputType.Touch or p149.UserInputState ~= Enum.UserInputState.Begin then
                    return;
                end;

                local v150 = u13 and u13.buttonName or u12 and u12.buttonName;

                if v150 and v150 ~= Name then
                    return;
                end;

                u10[p149] = Name;
                u11[Name] = u11[Name] or {};
                u11[Name][p149] = true;
                RefreshEditorInteraction(Name);
            end);
        end;
    end;
end;

local function ApplyLayoutToGameplayButtons(p151) -- Line: 901
    -- upvalues: GetGameplayMobileButtonsFrame (copy), Mobile (copy)
    local v152 = GetGameplayMobileButtonsFrame();

    if not v152 then
        return;
    end;

    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        local v153 = v152:FindFirstChild(v);
        local v154 = p151[v];

        if v153 and (v153:IsA("GuiButton") and v154) then
            v153.Position = UDim2.fromScale(v154.Position.X, v154.Position.Y);
            v153.Size = UDim2.fromScale(v154.Size.X, v154.Size.Y);
        end;
    end;
end;

local function CommitEditorChanges() -- Line: 919
    -- upvalues: Mobile (copy), u8 (ref), DeepCopyLayout (copy), u7 (ref), ApplyLayoutToGameplayButtons (copy), Remotes (copy)
    local v155 = Mobile.SanitizeLayout(u8);
    u8 = DeepCopyLayout(v155);
    u7 = DeepCopyLayout(v155);
    ApplyLayoutToGameplayButtons(v155);
    Remotes.Player.UpdateMobileButtons.Send({
        Layout = v155
    });
end;

local function HasEditorLayoutChanges() -- Line: 935
    -- upvalues: Mobile (copy), u8 (ref), u7 (ref), AreLayoutsEqual (copy)
    return not AreLayoutsEqual(Mobile.SanitizeLayout(u8), (Mobile.SanitizeLayout(u7)));
end;

local function ConnectActionButton(p156, p157, p158) -- Line: 943
    -- upvalues: ActivateButton (copy)
    local v159 = p156:FindFirstChild(p157);

    if not (v159 and v159:IsA("GuiButton")) then
        return;
    end;

    ActivateButton(v159);
    v159.MouseButton1Click:Connect(p158);
end;

local function HandleConfirmPressed() -- Line: 955
    -- upvalues: u5 (ref), Router (copy), Mobile (copy), u8 (ref), u7 (ref), AreLayoutsEqual (copy), SetDashboardEditorVisibility (copy), u10 (ref), u11 (ref), u12 (ref), u13 (ref), CommitEditorChanges (copy)
    if not u5 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");

    if AreLayoutsEqual(Mobile.SanitizeLayout(u8), (Mobile.SanitizeLayout(u7))) then
        if not u5 then
            return;
        end;

        u5 = false;
        SetDashboardEditorVisibility(false);
        u10 = {};
        u11 = {};
        u12 = nil;
        u13 = nil;

        return;
    end;

    CommitEditorChanges();

    if not u5 then
        return;
    end;

    u5 = false;
    SetDashboardEditorVisibility(false);
    u10 = {};
    u11 = {};
    u12 = nil;
    u13 = nil;
end;

local function HandleResetPressed() -- Line: 972
    -- upvalues: u5 (ref), Router (copy), u8 (ref), Mobile (copy), ApplyEditorButtonLayout (copy)
    if not u5 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    u8 = Mobile.GetDefaultLayout();

    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        ApplyEditorButtonLayout(v);
    end;
end;

local function HandleBackPressed() -- Line: 982
    -- upvalues: u5 (ref), Router (copy), u8 (ref), DeepCopyLayout (copy), u7 (ref), Mobile (copy), ApplyEditorButtonLayout (copy), SetDashboardEditorVisibility (copy), u10 (ref), u11 (ref), u12 (ref), u13 (ref)
    if not u5 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");

    if not u5 then
        return;
    end;

    u8 = DeepCopyLayout(u7);

    for _, v in ipairs(Mobile.REQUIRED_BUTTONS) do
        ApplyEditorButtonLayout(v);
    end;

    u5 = false;
    SetDashboardEditorVisibility(false);
    u10 = {};
    u11 = {};
    u12 = nil;
    u13 = nil;
end;

local function SetupEditMobileEntryButton() -- Line: 992
    -- upvalues: GetEditMobileEntryButton (copy), ActivateButton (copy), Router (copy), EnterMobileHUDEditor (copy)
    local v160 = GetEditMobileEntryButton();

    if not v160 then
        return;
    end;

    ActivateButton(v160);
    v160.MouseButton1Click:Connect(function() -- Line: 999
        -- upvalues: Router (ref), EnterMobileHUDEditor (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        EnterMobileHUDEditor();
    end);
end;

local function SetupEditorControls() -- Line: 1007
    -- upvalues: u4 (ref), u3 (ref), HandleConfirmPressed (copy), ActivateButton (copy), HandleResetPressed (copy), HandleBackPressed (copy), HideEditorSliderTemplates (copy), ConnectEditorButtonGestures (copy)
    local v161 = u4;

    if not (v161 and v161.Parent) then
        v161 = u3;

        if v161 then
            local EditMobile = v161:FindFirstChild("EditMobile");

            if EditMobile then
                v161 = EditMobile;
            elseif v161.Name ~= "EditMobile" then
                v161 = EditMobile;
            end;

            u4 = v161;
        else
            v161 = nil;
        end;
    end;

    if not v161 then
        return;
    end;

    local Action = v161:FindFirstChild("Action");

    if Action and Action:IsA("Frame") then
        local v162 = HandleConfirmPressed;
        local Confirm = Action:FindFirstChild("Confirm");

        if Confirm and Confirm:IsA("GuiButton") then
            ActivateButton(Confirm);
            Confirm.MouseButton1Click:Connect(v162);
        end;

        local v163 = HandleResetPressed;
        local Reset = Action:FindFirstChild("Reset");

        if Reset and Reset:IsA("GuiButton") then
            ActivateButton(Reset);
            Reset.MouseButton1Click:Connect(v163);
        end;

        local v164 = HandleBackPressed;
        local Back = Action:FindFirstChild("Back");

        if Back and Back:IsA("GuiButton") then
            ActivateButton(Back);
            Back.MouseButton1Click:Connect(v164);
        end;
    end;

    HideEditorSliderTemplates();
    ConnectEditorButtonGestures();
end;

local function ConnectGlobalInputHandlers() -- Line: 1026
    -- upvalues: UserInputService (copy), UpdateEditMobileButtonVisibility (copy), u5 (ref), u12 (ref), u13 (ref), StartEditorPinch (copy), UpdatePinchFromInput (copy), UpdateDragFromInput (copy), u10 (ref), u11 (ref), StartEditorDrag (copy), RefreshEditorInteraction (copy)
    UserInputService.LastInputTypeChanged:Connect(function(p165) -- Line: 1027
        -- upvalues: UpdateEditMobileButtonVisibility (ref)
        UpdateEditMobileButtonVisibility(p165);
    end);
    UserInputService.InputBegan:Connect(function(p166) -- Line: 1031
        -- upvalues: u5 (ref), u12 (ref), u13 (ref), StartEditorPinch (ref)
        if not u5 then
            return;
        end;

        if p166.UserInputType ~= Enum.UserInputType.Touch or p166.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        local v167 = u12;

        if v167 then
            if u13 then
                return;
            end;

            if v167.input == p166 then
                return;
            end;

            StartEditorPinch(v167.buttonName, v167.input, p166);
        end;
    end);
    UserInputService.InputChanged:Connect(function(p168) -- Line: 1042
        -- upvalues: u5 (ref), u13 (ref), UpdatePinchFromInput (ref), u12 (ref), UpdateDragFromInput (ref)
        if not u5 then
            return;
        end;

        if p168.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        if u13 then
            UpdatePinchFromInput(p168);

            return;
        end;

        if u12 then
            UpdateDragFromInput(p168);
        end;
    end);
    UserInputService.InputEnded:Connect(function(p169) -- Line: 1059
        -- upvalues: u13 (ref), u10 (ref), u11 (ref), u12 (ref), StartEditorDrag (ref), RefreshEditorInteraction (ref)
        if p169.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local v170 = false;
        local v171 = nil;
        local v172 = u13;
        local v173;

        if v172 and (p169 == v172.anchorInput or p169 == v172.scaleInput) then
            v173 = v172.buttonName;

            if p169 == v172.scaleInput then
                v171 = v172.anchorInput;
                v170 = true;
            end;

            u13 = nil;
        else
            v173 = nil;
        end;

        local v174 = u10[p169];

        if v174 then
            u10[p169] = nil;
            local v175 = u11[v174];

            if v175 then
                v175[p169] = nil;

                if next(v175) == nil then
                    u11[v174] = nil;
                end;
            end;
        else
            v174 = nil;
        end;

        local v176 = u12;

        if v176 and p169 == v176.input then
            u12 = nil;
        end;

        local v177 = v174 or v173;

        if v170 and (v171 and (v177 and u10[v171] == v177)) then
            StartEditorDrag(v177, v171);
        end;

        if v177 then
            RefreshEditorInteraction(v177);
        end;
    end);
end;

function v1.Initialize(p178, p179) -- Line: 1101
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), ConnectEditorVisibilityGuards (copy), SetDashboardEditorVisibility (copy), UpdateEditMobileButtonVisibility (copy), UserInputService (copy), GetEditMobileEntryButton (copy), ActivateButton (copy), Router (copy), EnterMobileHUDEditor (copy), SetupEditorControls (copy), ConnectGlobalInputHandlers (copy)
    u2 = p178;
    local EditMobile = p179:FindFirstChild("EditMobile");
    local v180;

    if p179.Name == "EditMobile" then
        v180 = p179.Parent;

        if v180 then
            if not v180:IsA("Frame") then
                v180 = p179;
            end;
        else
            v180 = p179;
        end;
    else
        v180 = p179;
        p179 = EditMobile;
    end;

    u3 = v180;
    u4 = p179;
    ConnectEditorVisibilityGuards();
    SetDashboardEditorVisibility(false);
    UpdateEditMobileButtonVisibility(UserInputService:GetLastInputType());
    local v181 = GetEditMobileEntryButton();

    if v181 then
        ActivateButton(v181);
        v181.MouseButton1Click:Connect(function() -- Line: 999
            -- upvalues: Router (ref), EnterMobileHUDEditor (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            EnterMobileHUDEditor();
        end);
    end;

    SetupEditorControls();
    ConnectGlobalInputHandlers();
end;

function v1.ShouldShowEntryButton(p182) -- Line: 1129
    -- upvalues: GetUserPlatform (copy), UserInputService (copy)
    local v183 = GetUserPlatform();
    local v184;

    if table.find(v183, "Mobile") == nil then
        v184 = false;
    else
        v184 = #v183 <= 1;
    end;

    return v184 or (p182 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch;
end;

function v1.Open() -- Line: 1135
    -- upvalues: EnterMobileHUDEditor (copy)
    EnterMobileHUDEditor();
end;

return v1;