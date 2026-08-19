-- Decompiled with Potassium's decompiler.

local GamepadService = game:GetService("GamepadService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local DPadUp = Enum.KeyCode.DPadUp;
local u1 = {};
local u2 = nil;

function u1.start(p3) -- Line: 19
    -- upvalues: u2 (ref), DPadUp (copy), GuiService (copy), UserInputService (copy), u1 (copy), GamepadService (copy)
    u2 = p3;
    local v4;

    if u2.highlightKey == nil then
        v4 = DPadUp;
    else
        v4 = u2.highlightKey;
    end;

    u2.highlightKey = v4;
    u2.highlightIcon = false;
    task.delay(1, function() -- Line: 27
        -- upvalues: u2 (ref), GuiService (ref), DPadUp (ref), UserInputService (ref), u1 (ref), GamepadService (ref)
        local iconsDictionary = u2.iconsDictionary;

        local function getIconFromSelectedObject() -- Line: 30
            -- upvalues: GuiService (ref), iconsDictionary (copy)
            local SelectedObject = GuiService.SelectedObject;

            if SelectedObject then
                SelectedObject = SelectedObject:GetAttribute("CorrespondingIconUID");
            end;

            if SelectedObject then
                SelectedObject = iconsDictionary[SelectedObject];
            end;

            return SelectedObject;
        end;

        local u5 = nil;
        local u6 = DPadUp ~= u2.highlightKey;
        local u7 = DPadUp ~= u2.highlightKey;
        local Selection = require(script.Parent.Parent.Elements.Selection);

        local function updateSelectedObject() -- Line: 42
            -- upvalues: GuiService (ref), iconsDictionary (copy), UserInputService (ref), Selection (copy), u2 (ref), u5 (ref), u7 (ref), u6 (ref), u1 (ref)
            local SelectedObject = GuiService.SelectedObject;

            if SelectedObject then
                SelectedObject = SelectedObject:GetAttribute("CorrespondingIconUID");
            end;

            if SelectedObject then
                SelectedObject = iconsDictionary[SelectedObject];
            end;

            local GamepadEnabled = UserInputService.GamepadEnabled;

            if not SelectedObject then
                local v8;

                if GamepadEnabled and not u6 then
                    v8 = u2.highlightKey;
                else
                    v8 = nil;
                end;

                if not u5 then
                    u5 = u1.getIconToHighlight();
                end;

                if v8 == u2.highlightKey then
                    u6 = true;
                end;

                if u5 then
                    u5:setIndicator(v8);
                end;

                return;
            end;

            if GamepadEnabled then
                local v9 = SelectedObject:getInstance("ClickRegion");
                local selection = SelectedObject.selection;

                if not selection then
                    selection = SelectedObject.janitor:add(Selection(u2));
                    selection:SetAttribute("IgnoreVisibilityUpdater", true);
                    selection.Parent = SelectedObject.widget;
                    SelectedObject.selection = selection;
                    SelectedObject:refreshAppearance(selection);
                end;

                v9.SelectionImageObject = selection.Selection;
            end;

            if u5 and u5 ~= SelectedObject then
                u5:setIndicator();
            end;

            local v10;

            if GamepadEnabled and not (u7 or SelectedObject.parentIconUID) then
                v10 = Enum.KeyCode.ButtonB;
            else
                v10 = nil;
            end;

            u5 = SelectedObject;
            u2.lastHighlightedIcon = SelectedObject;
            SelectedObject:setIndicator(v10);
        end;

        GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(updateSelectedObject);
        local Gamepad = Enum.PreferredInput.Gamepad;

        local function preferredInputChanged() -- Line: 90
            -- upvalues: UserInputService (ref), Gamepad (copy), u6 (ref), u7 (ref), updateSelectedObject (copy)
            if UserInputService.PreferredInput ~= Gamepad then
                u6 = false;
                u7 = false;
            end;

            updateSelectedObject();
        end;

        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(preferredInputChanged);

        if UserInputService.PreferredInput ~= Gamepad then
            u6 = false;
            u7 = false;
        end;

        updateSelectedObject();
        UserInputService.InputBegan:Connect(function(p11, p12) -- Line: 106
            -- upvalues: GuiService (ref), iconsDictionary (copy), u2 (ref), u1 (ref), GamepadService (ref)
            if p11.UserInputType ~= Enum.UserInputType.MouseButton1 then
                if p11.KeyCode ~= u2.highlightKey then
                    return;
                end;

                local v13 = u1.getIconToHighlight();

                if v13 then
                    if GamepadService.GamepadCursorEnabled then
                        task.wait(0.2);
                        GamepadService:DisableGamepadCursor();
                    end;

                    GuiService.SelectedObject = v13:getInstance("ClickRegion");
                end;

                return;
            end;

            local SelectedObject = GuiService.SelectedObject;

            if SelectedObject then
                SelectedObject = SelectedObject:GetAttribute("CorrespondingIconUID");
            end;

            if SelectedObject then
                SelectedObject = iconsDictionary[SelectedObject];
            end;

            if SelectedObject then
                GuiService.SelectedObject = nil;
            end;
        end);
    end);
end;

function u1.getIconToHighlight() -- Line: 133
    -- upvalues: u2 (ref)
    local iconsDictionary = u2.iconsDictionary;
    local v14 = u2.highlightIcon or u2.lastHighlightedIcon;

    if not v14 then
        local v15 = nil;

        for _, v in pairs(iconsDictionary) do
            if not v.parentIconUID and (not v15 or v.widget.AbsolutePosition.X < v15) then
                v15 = v.widget.AbsolutePosition.X;
                v14 = v;
            end;
        end;
    end;

    return v14;
end;

function u1.registerButton(u16) -- Line: 155
    -- upvalues: UserInputService (copy), GamepadService (copy), GuiService (copy)
    local u17 = false;
    u16.InputBegan:Connect(function(p18) -- Line: 161
        -- upvalues: u17 (ref)
        u17 = true;
        task.wait();
        task.wait();
        u17 = false;
    end);
    local u21 = UserInputService.InputBegan:Connect(function(p19) -- Line: 170
        -- upvalues: u17 (ref), GamepadService (ref), GuiService (ref), u16 (copy)
        task.wait();

        if p19.KeyCode == Enum.KeyCode.ButtonA and u17 then
            task.wait(0.2);
            GamepadService:DisableGamepadCursor();
            GuiService.SelectedObject = u16;

            return;
        end;

        local v20 = GuiService.SelectedObject == u16;
        local Name = p19.KeyCode.Name;

        if table.find({ "ButtonB", "ButtonSelect" }, Name) and (v20 and (Name ~= "ButtonSelect" or GamepadService.GamepadCursorEnabled)) then
            GuiService.SelectedObject = nil;
        end;
    end);
    u16.Destroying:Once(function() -- Line: 191
        -- upvalues: u21 (copy)
        u21:Disconnect();
    end);
end;

return u1;