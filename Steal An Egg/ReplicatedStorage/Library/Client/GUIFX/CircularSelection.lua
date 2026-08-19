-- Decompiled with Potassium's decompiler.

local v1 = {};
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Functions = require(Library.Functions);
local Variables = require(Library.Variables);
local CreateDial = require(script.Parent.CreateDial);
local ConsoleCmds = require(Library.Client.ConsoleCmds);
local u2 = {
    Normal = { "rbxassetid://13744994506", "rbxassetid://13745368416" },
    Huge = { "rbxassetid://15276476580", "rbxassetid://15276518483" }
};
local u3 = { 0.2, Enum.EasingStyle.Circular, Enum.EasingDirection.Out };

local function getDialQuantity(p4) -- Line: 45
    return p4:GetAttribute("Quantity") or 0;
end;

local function isDialTracking(p5) -- Line: 49
    return p5:GetAttribute("Tracking") == true;
end;

local function isSelectionShowing(p6) -- Line: 53
    return p6:GetAttribute("Showing") == true;
end;

task.spawn(function() -- Line: 57
    -- upvalues: ContentProvider (copy), u2 (copy)
    ContentProvider:PreloadAsync(u2.Normal);
    ContentProvider:PreloadAsync(u2.Huge);
end);

function v1.Add(u7, p8, p9, u10, u11, u12) -- Line: 62
    -- upvalues: Assets (copy), Functions (copy), u3 (copy), Variables (copy), u2 (copy), CreateDial (copy), UserInputService (copy), ConsoleCmds (copy), GuiService (copy)
    local u13 = p8 or 1;
    local u14 = p9 or 1;
    local u15 = {
        selected = false,
        selectable = true,
        quantity = 0
    };
    local u16 = false;
    local u17 = Assets.UI.Items.Select:Clone();
    u17.Parent = u7;
    local u18 = {};
    local u19 = nil;
    local u20 = nil;
    local u21 = nil;
    local u22 = nil;
    local u23 = nil;
    local u24 = false;

    local function updateCallback(p25) -- Line: 95
        -- upvalues: u16 (ref), u19 (ref), u15 (copy), u22 (ref), u10 (copy)
        if u16 then
            return;
        end;

        if u19 then
            u15.quantity = u19:GetAttribute("Quantity") or 0;
        elseif u15.selected then
            u15.quantity = 1;
        else
            u15.quantity = 0;
        end;

        if not p25 and u15.quantity ~= u22 then
            task.spawn(function() -- Line: 109
                -- upvalues: u10 (ref), u15 (ref)
                u10(u15);
            end);
            u22 = u15.quantity;
        end;
    end;

    local function updateSelectionVisual() -- Line: 116
        -- upvalues: u16 (ref), u17 (copy), u15 (copy), Functions (ref), u3 (ref), Variables (ref), u12 (copy), u2 (ref)
        if u16 then
            return;
        end;

        u17.Visible = u15.selected;

        if not u15.selected or u17:GetAttribute("Showing") == true then
            if not u15.selected then
                u17:SetAttribute("Showing", false);
            end;

            return;
        end;

        u17:SetAttribute("Showing", true);
        u17.Size = UDim2.fromScale(1.2, 1.2);
        Functions.Tween(u17, {
            Size = UDim2.fromScale(1, 1)
        }, u3);
        task.spawn(function() -- Line: 130
            -- upvalues: Variables (ref), u17 (ref), u12 (ref), u2 (ref), u15 (ref)
            if Variables.Mobile then
                u17.Image = u12 and u2.Huge[1] or u2.Normal[1];
                local u26 = u17:Clone();
                u26.Size = UDim2.fromScale(1, 1);
                u26.Position = UDim2.fromScale(0.5, 0.5);
                u26.AnchorPoint = Vector2.new(0.5, 0.5);
                u26.Image = u12 and u2.Huge[2] or u2.Normal[2];
                u26.Visible = false;
                u26.Parent = u17.Parent;
                u17.Destroying:Connect(function() -- Line: 142
                    -- upvalues: u26 (copy)
                    if u26 then
                        u26:Destroy();
                    end;
                end);

                while u15.selected and u17.Parent and u17:GetAttribute("Showing") == true do
                    local v27 = os.clock() % 1 > 0.5;
                    u26.Visible = v27;
                    u17.Visible = not v27;
                    task.wait();
                end;

                if u26 then
                    u26:Destroy();
                end;
            else
                while u15.selected and u17.Parent and u17:GetAttribute("Showing") == true do
                    local v28 = os.clock() % 1 > 0.5;

                    if u12 then
                        u17.Image = v28 and u2.Huge[1] or u2.Huge[2];
                    else
                        u17.Image = v28 and u2.Normal[1] or u2.Normal[2];
                    end;

                    task.wait();
                end;
            end;
        end);
    end;

    local function bindDialSignals() -- Line: 179
        -- upvalues: u19 (ref), updateCallback (copy), u11 (copy), u15 (copy), updateSelectionVisual (copy), u20 (ref)
        local u29 = u19;
        assert(u29, "CircularSelection.bindDialSignals requires an active dial GUI");
        u29:GetAttributeChangedSignal("Quantity"):Connect(function() -- Line: 183
            -- upvalues: updateCallback (ref), u11 (ref), u15 (ref), updateSelectionVisual (ref)
            updateCallback(not u11);

            if u15.quantity < 1 then
                u15.selected = false;
            else
                u15.selected = true;
            end;

            updateSelectionVisual();
        end);
        u29:GetAttributeChangedSignal("Tracking"):Connect(function() -- Line: 195
            -- upvalues: u11 (ref), u29 (copy), updateCallback (ref)
            if not u11 and u29:GetAttribute("Tracking") ~= true then
                updateCallback();
            end;
        end);
        u29.Destroying:Connect(function() -- Line: 201
            -- upvalues: u19 (ref), u20 (ref), u15 (ref), updateSelectionVisual (ref), u11 (ref), updateCallback (ref)
            local v30 = u19;
            u19 = nil;
            u20 = nil;
            u15.selected = false;
            updateSelectionVisual();

            if v30 and (v30:GetAttribute("Tracking") == true and not u11) then
                updateCallback();
            end;
        end);
    end;

    local function createDial() -- Line: 214
        -- upvalues: CreateDial (ref), u7 (copy), u13 (copy), u14 (copy), u19 (ref), u20 (ref), u21 (ref), u16 (ref), bindDialSignals (copy), updateCallback (copy), u11 (copy)
        local v31, v32, v33 = CreateDial(u7, u13, u14);
        u19 = v31;
        u20 = v32;
        u21 = v33;
        v31:SetAttribute("IsLocked", u16);
        bindDialSignals();
        updateCallback(not u11);
    end;

    local function setSelected(p34) -- Line: 224
        -- upvalues: u16 (ref), u15 (copy), u19 (ref), u20 (ref), updateSelectionVisual (copy), updateCallback (copy), u13 (copy), CreateDial (ref), u7 (copy), u14 (copy), u21 (ref), bindDialSignals (copy), u11 (copy)
        if u16 then
            return;
        end;

        if u15.selected == false and not u15.selectable then
            return;
        end;

        if p34 == nil then
            if u19 and u15.quantity < 1 then
                u15.selected = false;
                local v35 = u20;
                assert(v35, "CircularSelection expected destroyDial when closing an active dial");
                v35();
                u19 = nil;
                u20 = nil;
                updateSelectionVisual();
                updateCallback();

                return;
            end;

            if not u19 and u13 > 1 then
                u15.selected = true;
                updateSelectionVisual();
                local v36, v37, v38 = CreateDial(u7, u13, u14);
                u19 = v36;
                u20 = v37;
                u21 = v38;
                v36:SetAttribute("IsLocked", u16);
                bindDialSignals();
                updateCallback(not u11);

                return;
            end;

            if u13 == 1 then
                u15.selected = not u15.selected;
                updateSelectionVisual();
                updateCallback();
            end;
        else
            u15.selected = p34;

            if u19 and not u15.selected then
                local v39 = u20;
                assert(v39, "CircularSelection expected destroyDial when deselecting an active dial");
                v39();
                u19 = nil;
                u20 = nil;
            end;

            updateSelectionVisual();
            updateCallback();
        end;
    end;

    local function handlePress() -- Line: 273
        -- upvalues: u16 (ref), u23 (ref), u15 (copy), setSelected (copy)
        if u16 then
            return;
        end;

        u23 = u15.selected and tick() or nil;
        setSelected(nil);
    end;

    local function handleRelease() -- Line: 282
        -- upvalues: u16 (ref), u23 (ref), u15 (copy), u19 (ref), u20 (ref), updateSelectionVisual (copy), updateCallback (copy)
        if u16 then
            return;
        end;

        if u23 and (tick() - u23 <= 0.15 and u15.selected) then
            if u16 then
                return;
            end;

            if u15.selected == false and not u15.selectable then
                return;
            end;

            u15.selected = false;

            if u19 and not u15.selected then
                local v40 = u20;
                assert(v40, "CircularSelection expected destroyDial when deselecting an active dial");
                v40();
                u19 = nil;
                u20 = nil;
            end;

            updateSelectionVisual();
            updateCallback();
        end;
    end;

    local function setSelectable(p41) -- Line: 292
        -- upvalues: u16 (ref), u15 (copy), setSelected (copy)
        if u16 then
            return;
        end;

        u15.selectable = p41;

        if not p41 then
            u15.quantity = 0;
        end;

        if u15.selected and not p41 then
            setSelected(nil);
        end;
    end;

    local function cleanup() -- Line: 308
        -- upvalues: u18 (copy), u19 (ref), u20 (ref), u17 (copy)
        for _, v in ipairs(u18) do
            v:Disconnect();
        end;

        if u19 then
            local v42 = u20;
            assert(v42, "CircularSelection expected destroyDial during cleanup");
            v42();
        end;

        u17:Destroy();
    end;

    local function cancelSelection() -- Line: 322
        -- upvalues: u15 (copy), u16 (ref), u19 (ref), u20 (ref), updateSelectionVisual (copy), updateCallback (copy), u7 (copy)
        if u15.selected then
            if not u16 and (u15.selected ~= false or u15.selectable) then
                u15.selected = false;

                if u19 and not u15.selected then
                    local v43 = u20;
                    assert(v43, "CircularSelection expected destroyDial when deselecting an active dial");
                    v43();
                    u19 = nil;
                    u20 = nil;
                end;

                updateSelectionVisual();
                updateCallback();
            end;

            local v44 = u7:FindFirstAncestorOfClass("ScrollingFrame");

            if v44 then
                v44.ScrollingEnabled = true;
            end;
        end;
    end;

    local function setLocked(p45) -- Line: 333
        -- upvalues: u16 (ref), u19 (ref)
        u16 = p45;

        if u19 then
            u19:SetAttribute("IsLocked", p45);
        end;
    end;

    local function setQuantity(p46, p47) -- Line: 341
        -- upvalues: u16 (ref), u15 (copy), u19 (ref), u20 (ref), updateSelectionVisual (copy), updateCallback (copy), u13 (copy), CreateDial (ref), u7 (copy), u14 (copy), u21 (ref), bindDialSignals (copy), u11 (copy)
        if p47 then
            if not u16 and (u15.selected ~= false or u15.selectable) then
                u15.selected = true;

                if u19 and not u15.selected then
                    local v48 = u20;
                    assert(v48, "CircularSelection expected destroyDial when deselecting an active dial");
                    v48();
                    u19 = nil;
                    u20 = nil;
                end;

                updateSelectionVisual();
                updateCallback();
            end;

            if u19 then
                u19:SetAttribute("Quantity", p46);
                updateSelectionVisual();
                updateCallback();
            elseif u13 > 1 then
                local v49, v50, v51 = CreateDial(u7, u13, u14);
                u19 = v49;
                u20 = v50;
                u21 = v51;
                v49:SetAttribute("IsLocked", u16);
                bindDialSignals();
                updateCallback(not u11);
            end;
        end;

        if u21 then
            u21(p46);
        end;
    end;

    if Variables.Console or Variables.Mobile then
        if Variables.Mobile then
            local u52 = nil;
            local u53 = nil;
            table.insert(u18, u7.InputBegan:Connect(function(p54) -- Line: 366
                -- upvalues: u52 (ref), u53 (ref), Functions (ref), u16 (ref), u23 (ref), u15 (copy), setSelected (copy)
                if p54.UserInputType == Enum.UserInputType.Touch and p54.UserInputState == Enum.UserInputState.Begin then
                    if u52 then
                        u52();
                        u52 = nil;
                    end;

                    u53 = tick();
                    u52 = Functions.IntendedTouch(p54, function() -- Line: 377
                        -- upvalues: u52 (ref), u16 (ref), u23 (ref), u15 (ref), setSelected (ref)
                        u52 = nil;

                        if not u16 then
                            u23 = u15.selected and tick() or nil;
                            setSelected(nil);
                        end;
                    end, 0.05);
                end;
            end));
            table.insert(u18, u7.MouseButton1Up:Connect(function() -- Line: 391
                -- upvalues: u52 (ref), u53 (ref), u16 (ref), u23 (ref), u15 (copy), setSelected (copy), u19 (ref), u20 (ref), updateSelectionVisual (copy), updateCallback (copy)
                if u52 then
                    u52();
                    u52 = nil;

                    if u53 and tick() - u53 < 0.05 then
                        u53 = nil;

                        if not u16 then
                            u23 = u15.selected and tick() or nil;
                            setSelected(nil);
                        end;

                        if not u16 and (u23 and (tick() - u23 <= 0.15 and (u15.selected and (not u16 and (u15.selected ~= false or u15.selectable))))) then
                            u15.selected = false;

                            if u19 and not u15.selected then
                                local v55 = u20;
                                assert(v55, "CircularSelection expected destroyDial when deselecting an active dial");
                                v55();
                                u19 = nil;
                                u20 = nil;
                            end;

                            updateSelectionVisual();
                            updateCallback();
                        end;
                    end;
                end;

                u53 = nil;

                if not u16 and (u23 and (tick() - u23 <= 0.15 and u15.selected)) then
                    if u16 then
                        return;
                    end;

                    if u15.selected == false and not u15.selectable then
                        return;
                    end;

                    u15.selected = false;

                    if u19 and not u15.selected then
                        local v56 = u20;
                        assert(v56, "CircularSelection expected destroyDial when deselecting an active dial");
                        v56();
                        u19 = nil;
                        u20 = nil;
                    end;

                    updateSelectionVisual();
                    updateCallback();
                end;
            end));
        elseif Variables.Console then
            table.insert(u18, UserInputService.InputBegan:Connect(function(p57) -- Line: 425
                -- upvalues: ConsoleCmds (ref), u7 (copy), GuiService (ref), u24 (ref), u16 (ref), u23 (ref), u15 (copy), setSelected (copy)
                if not ConsoleCmds.ElementIsVisibleOnScreen(u7) then
                    return;
                end;

                if GuiService.SelectedObject ~= u7 then
                    return;
                end;

                if u24 then
                    return;
                end;

                if p57.KeyCode == Enum.KeyCode.ButtonA then
                    u24 = true;

                    if u16 then
                        return;
                    end;

                    u23 = u15.selected and tick() or nil;
                    setSelected(nil);
                end;
            end));
            table.insert(u18, UserInputService.InputEnded:Connect(function(p58) -- Line: 453
                -- upvalues: ConsoleCmds (ref), u7 (copy), GuiService (ref), u24 (ref), u16 (ref), u23 (ref), u15 (copy), u19 (ref), u20 (ref), updateSelectionVisual (copy), updateCallback (copy)
                if not ConsoleCmds.ElementIsVisibleOnScreen(u7) then
                    return;
                end;

                if GuiService.SelectedObject ~= u7 then
                    return;
                end;

                if not u24 then
                    return;
                end;

                if p58.KeyCode == Enum.KeyCode.ButtonA then
                    u24 = false;

                    if u16 then
                        return;
                    end;

                    if u23 and (tick() - u23 <= 0.15 and u15.selected) then
                        if u16 then
                            return;
                        end;

                        if u15.selected == false and not u15.selectable then
                            return;
                        end;

                        u15.selected = false;

                        if u19 and not u15.selected then
                            local v59 = u20;
                            assert(v59, "CircularSelection expected destroyDial when deselecting an active dial");
                            v59();
                            u19 = nil;
                            u20 = nil;
                        end;

                        updateSelectionVisual();
                        updateCallback();
                    end;
                end;
            end));
        end;
    else
        table.insert(u18, u7.MouseButton1Down:Connect(handlePress));
        table.insert(u18, u7.MouseButton1Up:Connect(handleRelease));
    end;

    return cleanup, cancelSelection, setSelectable, setLocked, setQuantity;
end;

return v1;