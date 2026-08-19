-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);

return function(u1) -- Line: 3
    local u2 = u1.State(true);
    local u3 = u1.State(false);
    local u4 = u1.State(false);
    local u5 = u1.State(false);
    local u6 = u1.State(false);
    local u7 = u1.State(false);
    local u8 = u1.State(false);
    local u9 = u1.State(false);
    local u10 = u1.State(Color3.fromRGB(115, 140, 152));
    local u11 = u1.State(0);
    table.insert(u1.Internal._initFunctions, function() -- Line: 15
        -- upvalues: u10 (copy), u11 (copy), u1 (copy), u9 (copy)
        local Frame = Instance.new("Frame");
        Frame.Name = "Background";
        Frame.Size = UDim2.fromScale(1, 1);
        Frame.BackgroundColor3 = u10.value;
        Frame.BackgroundTransparency = u11.value;
        local u12;

        if u1._config.UseScreenGUIs then
            u12 = Instance.new("ScreenGui");
            u12.Name = "Iris_Background";
            u12.IgnoreGuiInset = true;
            u12.DisplayOrder = u1._config.DisplayOrderOffset - 1;
            u12.ScreenInsets = Enum.ScreenInsets.None;
            u12.Enabled = true;
            Frame.Parent = u12;
        else
            Frame.ZIndex = u1._config.DisplayOrderOffset - 1;
            u12 = Frame;
        end;

        u10:onChange(function(p13) -- Line: 37
            -- upvalues: Frame (copy)
            Frame.BackgroundColor3 = p13;
        end);
        u11:onChange(function(p14) -- Line: 40
            -- upvalues: Frame (copy)
            Frame.BackgroundTransparency = p14;
        end);
        u9:onChange(function(p15) -- Line: 44
            -- upvalues: u12 (ref), u1 (ref)
            if p15 then
                u12.Parent = u1.Internal.parentInstance;

                return;
            end;

            u12.Parent = nil;
        end);
    end);

    local function helpMarker(p16) -- Line: 53
        -- upvalues: u1 (copy)
        u1.PushConfig({
            TextColor = u1._config.TextDisabledColor
        });
        local v17 = u1.Text({ "(?)" });
        u1.PopConfig();
        u1.PushConfig({
            ContentWidth = UDim.new(0, 350)
        });

        if v17.hovered() then
            u1.Tooltip({ p16 });
        end;

        u1.PopConfig();
    end;

    local function textAndHelpMarker(p18, p19) -- Line: 65
        -- upvalues: u1 (copy), helpMarker (copy)
        u1.SameLine();
        u1.Text({ p18 });
        helpMarker(p19);
        u1.End();
    end;

    local u86 = {
        Basic = function() -- Line: 76, Name: Basic
            -- upvalues: u1 (copy)
            u1.Tree({ "Basic" });
            u1.SeparatorText({ "Basic" });
            local v20 = u1.State(1);
            u1.Button({ "Button" });
            u1.SmallButton({ "SmallButton" });
            u1.Text({ "Text" });
            u1.TextWrapped({ string.rep("Text Wrapped ", 5) });
            u1.TextColored({ "Colored Text", Color3.fromRGB(255, 128, 0) });
            u1.Text({ "Rich Text: <b>bold text</b> <i>italic text</i> <u>underline text</u> <s>strikethrough text</s> <font color= \"rgb(240, 40, 10)\">red text</font> <font size=\"32\">bigger text</font>", true, nil, true });
            u1.SameLine();
            u1.RadioButton({ "Index \'1\'", 1 }, {
                index = v20
            });
            u1.RadioButton({ "Index \'two\'", "two" }, {
                index = v20
            });

            if u1.RadioButton({ "Index \'false\'", false }, {
                index = v20
            }).active() == false and u1.SmallButton({ "Select last" }).clicked() then
                v20:set(false);
            end;

            u1.End();
            u1.Text({ "The Index is: " .. tostring(v20.value) });
            u1.SeparatorText({ "Inputs" });
            u1.InputNum({});
            u1.DragNum({});
            u1.SliderNum({});
            u1.End();
        end,

        Image = function() -- Line: 117, Name: Image
            -- upvalues: u1 (copy)
            u1.Tree({ "Image" });
            u1.SeparatorText({ "Image Controls" });
            local v21 = u1.State("rbxasset://textures/ui/common/robux.png");
            local v22 = u1.State(UDim2.fromOffset(100, 100));
            local v23 = u1.State(Rect.new(0, 0, 0, 0));
            local v24 = u1.State(Enum.ScaleType.Stretch);
            local v25 = u1.State(false);
            local v27 = u1.ComputedState(v25, function(p26) -- Line: 127
                return p26 and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default;
            end);
            local v28 = u1.State(u1._config.ImageColor);
            local v29 = u1.State(u1._config.ImageTransparency);
            u1.InputColor4({ "Image Tint" }, {
                color = v28,
                transparency = v29
            });
            u1.Combo({ "Asset" }, {
                index = v21
            });
            u1.Selectable({ "Robux Small", "rbxasset://textures/ui/common/robux.png" }, {
                index = v21
            });
            u1.Selectable({ "Robux Large", "rbxasset://textures//ui/common/robux@3x.png" }, {
                index = v21
            });
            u1.Selectable({ "Loading Texture", "rbxasset://textures//loading/darkLoadingTexture.png" }, {
                index = v21
            });
            u1.Selectable({ "Hue-Saturation Gradient", "rbxasset://textures//TagEditor/huesatgradient.png" }, {
                index = v21
            });
            u1.Selectable({ "famfamfam.png (WHY?)", "rbxasset://textures//TagEditor/famfamfam.png" }, {
                index = v21
            });
            u1.End();
            u1.SliderUDim2({
                "Image Size",
                nil,
                nil,
                UDim2.new(1, 240, 1, 240)
            }, {
                number = v22
            });
            u1.SliderRect({
                "Image Rect",
                nil,
                nil,
                Rect.new(256, 256, 256, 256)
            }, {
                number = v23
            });
            u1.Combo({ "Scale Type" }, {
                index = v24
            });
            u1.Selectable({ "Stretch", Enum.ScaleType.Stretch }, {
                index = v24
            });
            u1.Selectable({ "Fit", Enum.ScaleType.Fit }, {
                index = v24
            });
            u1.Selectable({ "Crop", Enum.ScaleType.Crop }, {
                index = v24
            });
            u1.End();
            u1.Checkbox({ "Pixelated" }, {
                isChecked = v25
            });
            u1.PushConfig({
                ImageColor = v28:get(),
                ImageTransparency = v29:get()
            });
            u1.Image({
                v21:get(),
                v22:get(),
                v23:get(),
                v24:get(),
                v27:get()
            });
            u1.PopConfig();
            u1.SeparatorText({ "Tile" });
            local v30 = u1.State(UDim2.fromScale(0.5, 0.5));
            u1.SliderUDim2({
                "Tile Size",
                nil,
                nil,
                UDim2.new(1, 240, 1, 240)
            }, {
                number = v30
            });
            u1.PushConfig({
                ImageColor = v28:get(),
                ImageTransparency = v29:get()
            });
            u1.Image({
                "rbxasset://textures/grid2.png",
                v22:get(),
                nil,
                Enum.ScaleType.Tile,
                v27:get(),
                v30:get()
            });
            u1.PopConfig();
            u1.SeparatorText({ "Slice" });
            local v31 = u1.State(1);
            u1.SliderNum({ "Image Slice Scale", 0.1, 0.1, 5 }, {
                number = v31
            });
            u1.PushConfig({
                ImageColor = v28:get(),
                ImageTransparency = v29:get()
            });
            u1.Image({
                "rbxasset://textures/ui/chatBubble_blue_notify_bkg.png",
                v22:get(),
                nil,
                Enum.ScaleType.Slice,
                v27:get(),
                nil,
                Rect.new(12, 12, 56, 56),
                1
            }, v31:get());
            u1.PopConfig();
            u1.SeparatorText({ "Image Button" });
            local v32 = u1.State(0);
            u1.SameLine();
            u1.PushConfig({
                ImageColor = v28:get(),
                ImageTransparency = v29:get()
            });

            if u1.ImageButton({ "rbxasset://textures/AvatarCompatibilityPreviewer/add.png", UDim2.fromOffset(20, 20) }).clicked() then
                v32:set(v32.value + 1);
            end;

            u1.PopConfig();
            u1.Text({ (`Click count: {v32.value}`) });
            u1.End();
            u1.End();
        end,

        Selectable = function() -- Line: 211, Name: Selectable
            -- upvalues: u1 (copy)
            u1.Tree({ "Selectable" });
            local v33 = u1.State(2);
            u1.Selectable({ "Selectable #1", 1 }, {
                index = v33
            });
            u1.Selectable({ "Selectable #2", 2 }, {
                index = v33
            });

            if u1.Selectable({ "Double click Selectable", 3, true }, {
                index = v33
            }).doubleClicked() then
                v33:set(3);
            end;

            u1.Selectable({ "Impossible to select", 4, true }, {
                index = v33
            });

            if u1.Button({ "Select last" }).clicked() then
                v33:set(4);
            end;

            u1.Selectable({ "Independent Selectable" });
            u1.End();
        end,

        Combo = function() -- Line: 231, Name: Combo
            -- upvalues: u1 (copy)
            u1.Tree({ "Combo" });
            u1.PushConfig({
                ContentWidth = UDim.new(1, -200)
            });
            local v34 = u1.State("No Selection");
            u1.SameLine();
            local v35 = u1.Checkbox({ "No Preview" });
            local v36 = u1.Checkbox({ "No Button" });

            if v35.checked() and v36.isChecked.value == true then
                v36.isChecked:set(false);
            end;

            if v36.checked() and v35.isChecked.value == true then
                v35.isChecked:set(false);
            end;

            u1.End();
            u1.Combo({ "Basic Usage", v36.isChecked:get(), v35.isChecked:get() }, {
                index = v34
            });
            u1.Selectable({ "Select 1", "One" }, {
                index = v34
            });
            u1.Selectable({ "Select 2", "Two" }, {
                index = v34
            });
            u1.Selectable({ "Select 3", "Three" }, {
                index = v34
            });
            u1.End();
            u1.ComboArray({ "Using ComboArray" }, {
                index = "No Selection"
            }, { "Red", "Green", "Blue" });
            local v37 = {};

            for i = 1, 50 do
                local v38 = tostring(i);
                table.insert(v37, v38);
            end;

            u1.ComboArray({ "Height Test" }, {
                index = "1"
            }, v37);
            local v39 = u1.State("7 AM");
            u1.Combo({ "Combo with Inner widgets" }, {
                index = v39
            });
            u1.Tree({ "Morning Shifts" });
            u1.Selectable({ "Shift at 7 AM", "7 AM" }, {
                index = v39
            });
            u1.Selectable({ "Shift at 11 AM", "11 AM" }, {
                index = v39
            });
            u1.Selectable({ "Shift at 3 PM", "3 PM" }, {
                index = v39
            });
            u1.End();
            u1.Tree({ "Night Shifts" });
            u1.Selectable({ "Shift at 6 PM", "6 PM" }, {
                index = v39
            });
            u1.Selectable({ "Shift at 9 PM", "9 PM" }, {
                index = v39
            });
            u1.End();
            u1.End();
            local v40 = u1.ComboEnum({ "Using ComboEnum" }, {
                index = Enum.UserInputState.Begin
            }, Enum.UserInputState);
            u1.Text({ "Selected: " .. v40.index:get().Name });
            u1.PopConfig();
            u1.End();
        end,

        Tree = function() -- Line: 294, Name: Tree
            -- upvalues: u1 (copy), helpMarker (copy)
            u1.Tree({ "Trees" });
            u1.Tree({ "Tree using SpanAvailWidth", true });
            helpMarker("SpanAvailWidth determines if the Tree is selectable from its entire with, or only the text area");
            u1.End();
            local v41 = u1.Tree({ "Tree with Children" });
            u1.Text({ "Im inside the first tree!" });
            u1.Button({ "Im a button inside the first tree!" });
            u1.Tree({ "Im a tree inside the first tree!" });
            u1.Text({ "I am the innermost text!" });
            u1.End();
            u1.End();
            u1.Checkbox({ "Toggle above tree" }, {
                isChecked = v41.state.isUncollapsed
            });
            u1.End();
        end,

        CollapsingHeader = function() -- Line: 320, Name: CollapsingHeader
            -- upvalues: u1 (copy)
            u1.Tree({ "Collapsing Headers" });
            u1.CollapsingHeader({ "A header" });
            u1.Text({ "This is under the first header!" });
            u1.End();
            local v42 = u1.State(false);
            u1.CollapsingHeader({ "Another header" }, {
                isUncollapsed = v42
            });

            if u1.Button({ "Shhh... secret button!" }).clicked() then
                v42:set(true);
            end;

            u1.End();
            u1.End();
        end,

        Group = function() -- Line: 341, Name: Group
            -- upvalues: u1 (copy)
            u1.Tree({ "Groups" });
            u1.SameLine();
            u1.Group();
            u1.Text({ "I am in group A" });
            u1.Button({ "Im also in A" });
            u1.End();
            u1.Separator();
            u1.Group();
            u1.Text({ "I am in group B" });
            u1.Button({ "Im also in B" });
            u1.Button({ "Also group B" });
            u1.End();
            u1.End();
            u1.End();
        end,

        Tab = function() -- Line: 368, Name: Tab
            -- upvalues: u1 (copy)
            u1.Tree({ "Tabs" });
            u1.Tree({ "Simple" });
            u1.TabBar();
            u1.Tab({ "Apples" });
            u1.Text({ "Who loves apples?" });
            u1.End();
            u1.Tab({ "Broccoli" });
            u1.Text({ "And what about broccoli?" });
            u1.End();
            u1.Tab({ "Carrots" });
            u1.Text({ "But carrots are the best." });
            u1.End();
            u1.End();
            u1.Separator();
            u1.Text({ "Very important questions." });
            u1.End();
            u1.Tree({ "Closable" });
            local v43 = u1.State(true);
            local v44 = u1.State(true);
            local v45 = u1.State(true);
            u1.TabBar();
            u1.Tab({ "🍎", true }, {
                isOpened = v43
            });
            u1.Text({ "Who loves apples?" });

            if u1.Button({ "I don\'t like apples." }).clicked() then
                v43:set(false);
            end;

            u1.End();
            u1.Tab({ "🥦", true }, {
                isOpened = v44
            });
            u1.Text({ "And what about broccoli?" });

            if u1.Button({ "Not for me." }).clicked() then
                v44:set(false);
            end;

            u1.End();
            u1.Tab({ "🥕", true }, {
                isOpened = v45
            });
            u1.Text({ "But carrots are the best." });

            if u1.Button({ "I disagree with you." }).clicked() then
                v45:set(false);
            end;

            u1.End();
            u1.End();
            u1.Separator();

            if u1.Button({ "Actually, let me reconsider it." }).clicked() then
                v43:set(true);
                v44:set(true);
                v45:set(true);
            end;

            u1.End();
            u1.End();
        end,

        Indent = function() -- Line: 443, Name: Indent
            -- upvalues: u1 (copy)
            u1.Tree({ "Indents" });
            u1.Text({ "Not Indented" });
            u1.Indent();
            u1.Text({ "Indented" });
            u1.Indent({ 7 });
            u1.Text({ "Indented by 7 more pixels" });
            u1.End();
            u1.Indent({ -7 });
            u1.Text({ "Indented by 7 less pixels" });
            u1.End();
            u1.End();
            u1.End();
        end,

        Input = function() -- Line: 465, Name: Input
            -- upvalues: u1 (copy), helpMarker (copy)
            u1.Tree({ "Input" });
            local v46 = u1.State(false);
            local v47 = u1.State(false);
            local v48 = u1.State(0);
            local v49 = u1.State(100);
            local v50 = u1.State(1);
            local v51 = u1.State("%d");
            u1.PushConfig({
                ContentWidth = UDim.new(1, -120)
            });
            local v52 = u1.InputNum({
                [u1.Args.InputNum.Text] = "Input Number",
                [u1.Args.InputNum.NoButtons] = v47.value,
                [u1.Args.InputNum.Min] = v48.value,
                [u1.Args.InputNum.Max] = v49.value,
                [u1.Args.InputNum.Increment] = v50.value,
                [u1.Args.InputNum.Format] = { v51.value }
            });
            u1.PopConfig();
            u1.Text({ "The Value is: " .. v52.number.value });

            if u1.Button({ "Randomize Number" }).clicked() then
                v52.number:set(math.random(1, 99));
            end;

            local v53 = u1.Checkbox({ "NoField" }, {
                isChecked = v46
            });
            local v54 = u1.Checkbox({ "NoButtons" }, {
                isChecked = v47
            });

            if v53.checked() and v54.isChecked.value == true then
                v54.isChecked:set(false);
            end;

            if v54.checked() and v53.isChecked.value == true then
                v53.isChecked:set(false);
            end;

            u1.PushConfig({
                ContentWidth = UDim.new(1, -120)
            });
            u1.InputVector2({ "InputVector2" });
            u1.InputVector3({ "InputVector3" });
            u1.InputUDim({ "InputUDim" });
            u1.InputUDim2({ "InputUDim2" });
            local v55 = u1.State(false);
            local v56 = u1.State(false);
            local v57 = u1.State(Color3.new());
            local v58 = u1.State(0);
            u1.SliderNum({ "Transparency", 0.01, 0, 1 }, {
                number = v58
            });
            u1.InputColor3({ "InputColor3", v55:get(), v56:get() }, {
                color = v57
            });
            u1.InputColor4({ "InputColor4", v55:get(), v56:get() }, {
                color = v57,
                transparency = v58
            });
            u1.SameLine();
            u1.Text({ (`#{v57:get():ToHex()}`) });
            u1.Checkbox({ "Use Floats" }, {
                isChecked = v55
            });
            u1.Checkbox({ "Use HSV" }, {
                isChecked = v56
            });
            u1.End();
            u1.PopConfig();
            u1.Separator();
            u1.SameLine();
            u1.Text({ "Slider Numbers" });
            helpMarker("ctrl + click slider number widgets to input a number");
            u1.End();
            u1.PushConfig({
                ContentWidth = UDim.new(1, -120)
            });
            u1.SliderNum({ "Slide Int", 1, 1, 8 });
            u1.SliderNum({ "Slide Float", 0.01, 0, 100 });
            u1.SliderNum({ "Small Numbers", 0.001, -2, 1, "%f radians" });
            u1.SliderNum({ "Odd Ranges", 0.001, -3.141592653589793, 3.141592653589793, "%f radians" });
            u1.SliderNum({ "Big Numbers", 10000, 100000, 10000000 });
            u1.SliderNum({ "Few Numbers", 1, 0, 3 });
            u1.PopConfig();
            u1.Separator();
            u1.SameLine();
            u1.Text({ "Drag Numbers" });
            helpMarker("ctrl + click or double click drag number widgets to input a number, hold shift/alt while dragging to increase/decrease speed");
            u1.End();
            u1.PushConfig({
                ContentWidth = UDim.new(1, -120)
            });
            u1.DragNum({ "Drag Int" });
            u1.DragNum({ "Slide Float", 0.001, -10, 10 });
            u1.DragNum({ "Percentage", 1, 0, 100, "%d %%" });
            u1.PopConfig();
            u1.End();
        end,

        InputText = function() -- Line: 548, Name: InputText
            -- upvalues: u1 (copy)
            u1.Tree({ "Input Text" });
            local v59 = u1.InputText({ "Input Text Test", "Input Text here" });
            u1.Text({ "The text is: " .. v59.text.value });
            u1.End();
        end,

        MultiInput = function() -- Line: 557, Name: MultiInput
            -- upvalues: u1 (copy)
            u1.Tree({ "Multi-Component Input" });
            local v60 = u1.State(Vector2.new());
            local v61 = u1.State((Vector3.new()));
            local v62 = u1.State(UDim.new());
            local v63 = u1.State(UDim2.new());
            local v64 = u1.State(Color3.new());
            local v65 = u1.State(Rect.new(0, 0, 0, 0));
            u1.SeparatorText({ "Input" });
            u1.InputVector2({}, {
                number = v60
            });
            u1.InputVector3({}, {
                number = v61
            });
            u1.InputUDim({}, {
                number = v62
            });
            u1.InputUDim2({}, {
                number = v63
            });
            u1.InputRect({}, {
                number = v65
            });
            u1.SeparatorText({ "Drag" });
            u1.DragVector2({}, {
                number = v60
            });
            u1.DragVector3({}, {
                number = v61
            });
            u1.DragUDim({}, {
                number = v62
            });
            u1.DragUDim2({}, {
                number = v63
            });
            u1.DragRect({}, {
                number = v65
            });
            u1.SeparatorText({ "Slider" });
            u1.SliderVector2({}, {
                number = v60
            });
            u1.SliderVector3({}, {
                number = v61
            });
            u1.SliderUDim({}, {
                number = v62
            });
            u1.SliderUDim2({}, {
                number = v63
            });
            u1.SliderRect({}, {
                number = v65
            });
            u1.SeparatorText({ "Color" });
            u1.InputColor3({}, {
                color = v64
            });
            u1.InputColor4({}, {
                color = v64
            });
            u1.End();
        end,

        Tooltip = function() -- Line: 599, Name: Tooltip
            -- upvalues: u1 (copy)
            u1.PushConfig({
                ContentWidth = UDim.new(0, 250)
            });
            u1.Tree({ "Tooltip" });

            if u1.Text({ "Hover over me to reveal a tooltip" }).hovered() then
                u1.Tooltip({ "I am some helpful tooltip text" });
            end;

            local v66 = u1.State("Hello ");
            local v67 = u1.State(1);

            if u1.InputNum({ "# of repeat", 1, 1, 50 }, {
                number = v67
            }).numberChanged() then
                v66:set(string.rep("Hello ", v67:get()));
            end;

            if u1.Checkbox({ "Show dynamic text tooltip" }).state.isChecked.value then
                u1.Tooltip({ v66:get() });
            end;

            u1.End();
            u1.PopConfig();
        end,

        Plotting = function() -- Line: 619, Name: Plotting
            -- upvalues: u1 (copy)
            u1.Tree({ "Plotting" });
            u1.SeparatorText({ "Progress" });
            local v68 = os.clock() * 15;
            local v69 = u1.State(0);
            local v70 = math.abs(v68 % 100 - 50) - 7.5;
            v69:set(math.clamp(v70, 0, 35) / 35);
            u1.ProgressBar({ "Progress Bar" }, {
                progress = v69
            });
            local ProgressBar = u1.ProgressBar;
            local v71 = {};
            local v72 = v69:get() * 1753;
            v71[1], v71[2] = "Progress Bar", `{math.floor(v72)}/1753`;
            ProgressBar(v71, {
                progress = v69
            });
            u1.SeparatorText({ "Graphs" });
            local v73 = u1.State({ 0.5, 0.8, 0.2, 0.9, 0.1, 0.6, 0.4, 0.7, 0.3, 0 });
            u1.PlotHistogram({ "Histogram", 100, 0, 1, "random" }, {
                values = v73
            });
            u1.PlotLines({ "Lines", 100, 0, 1, "random" }, {
                values = v73
            });
            local v74 = u1.State("Cos");
            local v75 = u1.State(37);
            local v76 = u1.State(0);
            local v77 = u1.State({});
            local v78 = u1.State(0);
            local v79 = u1.Checkbox({ "Animate" });
            local v80 = u1.ComboArray({ "Plotting Function" }, {
                index = v74
            }, { "Sin", "Cos", "Tan", "Saw" });
            local v81 = u1.SliderNum({ "Samples", 1, 1, 145, "%d samples" }, {
                number = v75
            });

            if u1.SliderNum({ "Baseline", 0.1, -1, 1 }, {
                number = v76
            }).numberChanged() then
                v77:set(v77.value, true);
            end;

            if v79.state.isChecked.value or (v80.closed() or (v81.numberChanged() or #v77.value == 0)) then
                if v79.state.isChecked.value then
                    v78:set(v78.value + u1.Internal._deltaTime);
                end;

                local v82 = math.floor(v78.value * 30) - 1;
                local value = v74.value;
                table.clear(v77.value);

                for i = 1, v75.value do
                    if value == "Sin" then
                        local value2 = v77.value;
                        local v83 = math.rad((i + v82) * 5);
                        value2[i] = math.sin(v83);
                    elseif value == "Cos" then
                        local value2 = v77.value;
                        local v84 = math.rad((i + v82) * 5);
                        value2[i] = math.cos(v84);
                    elseif value == "Tan" then
                        local value2 = v77.value;
                        local v85 = math.rad((i + v82) * 5);
                        value2[i] = math.tan(v85);
                    elseif value == "Saw" then
                        v77.value[i] = i % 2 == v82 % 2 and 1 or -1;
                    end;
                end;

                v77:set(v77.value, true);
            end;

            u1.PlotHistogram({
                "Histogram",
                100,
                -1,
                1,
                "",
                v76:get()
            }, {
                values = v77
            });
            u1.PlotLines({ "Lines", 100, -1, 1 }, {
                values = v77
            });
            u1.End();
        end
    };
    local u87 = { "Basic", "Image", "Selectable", "Combo", "Tree", "CollapsingHeader", "Group", "Tab", "Indent", "Input", "MultiInput", "InputText", "Tooltip", "Plotting" };

    local function recursiveTree() -- Line: 687
        -- upvalues: u1 (copy), recursiveTree (copy)
        if u1.Tree({ "Recursive Tree" }).state.isUncollapsed.value then
            recursiveTree();
        end;

        u1.End();
    end;

    local function recursiveWindow(p88) -- Line: 697
        -- upvalues: u1 (copy), recursiveWindow (copy)
        u1.Window({ "Recursive Window" }, {
            size = u1.State(Vector2.new(175, 100)),
            isOpened = p88
        });
        local v89 = u1.Checkbox({ "Recurse Again" });
        u1.End();

        if v89.isChecked.value then
            recursiveWindow(v89.isChecked);
        end;
    end;

    local function runtimeInfo() -- Line: 711
        -- upvalues: u1 (copy), u4 (copy), helpMarker (copy)
        local v90 = u1.Window({ "Runtime Info" }, {
            isOpened = u4
        });
        local _lastVDOM = u1.Internal._lastVDOM;
        local _states = u1.Internal._states;
        local v91 = u1.State(3);
        local v92 = u1.State(0);
        local v93 = u1.State(os.clock());
        u1.SameLine();
        u1.InputNum({
            [u1.Args.InputNum.Text] = "",
            [u1.Args.InputNum.Format] = "%d Seconds",
            [u1.Args.InputNum.Max] = 10
        }, {
            number = v91
        });

        if u1.Button({ "Disable" }).clicked() then
            u1.Disabled = true;
            task.delay(v91:get(), function() -- Line: 726
                -- upvalues: u1 (ref)
                u1.Disabled = false;
            end);
        end;

        u1.End();
        local v94 = os.clock();
        v92.value = v92.value + (v94 - v93.value - v92.value) * 0.2;
        v93.value = v94;
        u1.Text({ string.format("Average %.3f ms/frame (%.1f FPS)", v92.value * 1000, 1 / v92.value) });
        u1.Text({ string.format("Window Position: (%d, %d), Window Size: (%d, %d)", v90.position.value.X, v90.position.value.Y, v90.size.value.X, v90.size.value.Y) });
        u1.SameLine();
        u1.Text({ "Enter an ID to learn more about it." });
        helpMarker("every widget and state has an ID which Iris tracks to remember which widget is which. below lists all widgets and states, with their respective IDs");
        u1.End();
        u1.PushConfig({
            ItemWidth = UDim.new(1, -150)
        });
        local value = u1.InputText({ "ID field" }, {
            text = u1.State(v90.ID)
        }).state.text.value;
        u1.PopConfig();
        u1.Indent();
        local v95 = _lastVDOM[value];
        local v96 = _states[value];

        if v95 then
            u1.Table({ 1 });
            u1.Text({ string.format("The ID, \"%s\", is a widget", value) });
            u1.NextRow();
            u1.Text({ string.format("Widget is type: %s", v95.type) });
            u1.NextRow();
            u1.Tree({ "Widget has Args:" }, {
                isUncollapsed = u1.State(true)
            });

            for i, v in v95.arguments do
                u1.Text({ i .. " - " .. tostring(v) });
            end;

            u1.End();
            u1.NextRow();

            if v95.state then
                u1.Tree({ "Widget has State:" }, {
                    isUncollapsed = u1.State(true)
                });

                for i, v in v95.state do
                    u1.Text({ i .. " - " .. tostring(v.value) });
                end;

                u1.End();
            end;

            u1.End();
        elseif v96 then
            u1.Table({ 1 });
            u1.Text({ string.format("The ID, \"%s\", is a state", value) });
            u1.NextRow();
            u1.Text({ string.format("Value is type: %s, Value = %s", typeof(v96.value), (tostring(v96.value))) });
            u1.NextRow();
            u1.Tree({ "state has connected widgets:" }, {
                isUncollapsed = u1.State(true)
            });

            for i, v in v96.ConnectedWidgets do
                u1.Text({ i .. " - " .. v.type });
            end;

            u1.End();
            u1.NextRow();
            u1.Text({ string.format("state has: %d connected functions", #v96.ConnectedFunctions) });
            u1.End();
        else
            u1.Text({ string.format("The ID, \"%s\", is not a state or widget", value) });
        end;

        u1.End();

        if u1.Tree({ "Widgets" }).state.isUncollapsed.value then
            local v97 = 0;
            local v98 = "";

            for _, v in _lastVDOM do
                v97 = v97 + 1;
                v98 = v98 .. "\n" .. v.ID .. " - " .. v.type;
            end;

            u1.Text({ "Number of Widgets: " .. v97 });
            u1.Text({ v98 });
        end;

        u1.End();

        if u1.Tree({ "States" }).state.isUncollapsed.value then
            local v99 = 0;
            local v100 = "";

            for i, v in _states do
                v99 = v99 + 1;
                v100 = v100 .. "\n" .. i .. " - " .. tostring(v.value);
            end;

            u1.Text({ "Number of States: " .. v99 });
            u1.Text({ v100 });
        end;

        u1.End();
        u1.End();
    end;

    local function debugPanel() -- Line: 841
        -- upvalues: u1 (copy), u8 (copy)
        u1.Window({ "Debug Panel" }, {
            isOpened = u8
        });
        u1.CollapsingHeader({ "Widgets" });
        u1.SeparatorText({ "GuiService" });
        u1.Text({ (`GuiOffset: {u1.Internal._utility.GuiOffset}`) });
        u1.Text({ (`MouseOffset: {u1.Internal._utility.MouseOffset}`) });
        u1.SeparatorText({ "UserInputService" });
        u1.Text({ (`MousePosition: {u1.Internal._utility.UserInputService:GetMouseLocation()}`) });
        u1.Text({ (`MouseLocation: {u1.Internal._utility.getMouseLocation()}`) });
        u1.Text({ (`Left Control: {u1.Internal._utility.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)}`) });
        u1.Text({ (`Right Control: {u1.Internal._utility.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)}`) });
        u1.End();
        u1.End();
    end;

    local function recursiveMenu() -- Line: 862
        -- upvalues: u1 (copy), recursiveMenu (copy)
        if u1.Menu({ "Recursive" }).state.isOpened.value then
            u1.MenuItem({ "New", Enum.KeyCode.N, Enum.ModifierKey.Ctrl });
            u1.MenuItem({ "Open", Enum.KeyCode.O, Enum.ModifierKey.Ctrl });
            u1.MenuItem({ "Save", Enum.KeyCode.S, Enum.ModifierKey.Ctrl });
            u1.Separator();
            u1.MenuToggle({ "Autosave" });
            u1.MenuToggle({ "Checked" });
            u1.Separator();
            u1.Menu({ "Options" });
            u1.MenuItem({ "Red" });
            u1.MenuItem({ "Yellow" });
            u1.MenuItem({ "Green" });
            u1.MenuItem({ "Blue" });
            u1.Separator();
            recursiveMenu();
            u1.End();
        end;

        u1.End();
    end;

    local function mainMenuBar() -- Line: 883
        -- upvalues: u1 (copy), recursiveMenu (copy), u2 (copy), u3 (copy), u6 (copy), u7 (copy), u4 (copy), u5 (copy), u8 (copy)
        u1.MenuBar();
        u1.Menu({ "File" });
        u1.MenuItem({ "New", Enum.KeyCode.N, Enum.ModifierKey.Ctrl });
        u1.MenuItem({ "Open", Enum.KeyCode.O, Enum.ModifierKey.Ctrl });
        u1.MenuItem({ "Save", Enum.KeyCode.S, Enum.ModifierKey.Ctrl });
        recursiveMenu();

        if u1.MenuItem({ "Quit", Enum.KeyCode.Q, Enum.ModifierKey.Alt }).clicked() then
            u2:set(false);
        end;

        u1.End();
        u1.Menu({ "Examples" });
        u1.MenuToggle({ "Recursive Window" }, {
            isChecked = u3
        });
        u1.MenuToggle({ "Windowless" }, {
            isChecked = u6
        });
        u1.MenuToggle({ "Main Menu Bar" }, {
            isChecked = u7
        });
        u1.End();
        u1.Menu({ "Tools" });
        u1.MenuToggle({ "Runtime Info" }, {
            isChecked = u4
        });
        u1.MenuToggle({ "Style Editor" }, {
            isChecked = u5
        });
        u1.MenuToggle({ "Debug Panel" }, {
            isChecked = u8
        });
        u1.End();
        u1.End();
    end;

    local function mainMenuBarExample() -- Line: 917
        -- upvalues: mainMenuBar (copy)
        mainMenuBar();
    end;

    local function u120() -- Line: 932
        -- upvalues: u1 (copy), helpMarker (copy), u5 (copy)
        local v117 = {
            { "Sizing", function() -- Line: 936
                    -- upvalues: u1 (ref), helpMarker (ref)
                    local u101 = u1.State({});
                    u1.SameLine();

                    if u1.Button({ "Update" }).clicked() then
                        u1.UpdateGlobalConfig(u101.value);
                        u101:set({});
                    end;

                    helpMarker("Update the global config with these changes.");
                    u1.End();

                    local function SliderInput(p102, p103) -- Line: 950
                        -- upvalues: u1 (ref), u101 (copy)
                        local v104 = u1[p102](p103, {
                            number = u1.WeakState(u1._config[p103[1]])
                        });

                        if v104.numberChanged() then
                            u101.value[p103[1]] = v104.number:get();
                        end;
                    end;

                    local function BooleanInput(p105) -- Line: 957
                        -- upvalues: u1 (ref), u101 (copy)
                        local v106 = u1.Checkbox(p105, {
                            isChecked = u1.WeakState(u1._config[p105[1]])
                        });

                        if v106.checked() or v106.unchecked() then
                            u101.value[p105[1]] = v106.isChecked:get();
                        end;
                    end;

                    u1.SeparatorText({ "Main" });
                    SliderInput("SliderVector2", {
                        "WindowPadding",
                        nil,
                        Vector2.zero,
                        Vector2.new(20, 20)
                    });
                    SliderInput("SliderVector2", {
                        "WindowResizePadding",
                        nil,
                        Vector2.zero,
                        Vector2.new(20, 20)
                    });
                    SliderInput("SliderVector2", {
                        "FramePadding",
                        nil,
                        Vector2.zero,
                        Vector2.new(20, 20)
                    });
                    SliderInput("SliderVector2", {
                        "ItemSpacing",
                        nil,
                        Vector2.zero,
                        Vector2.new(20, 20)
                    });
                    SliderInput("SliderVector2", {
                        "ItemInnerSpacing",
                        nil,
                        Vector2.zero,
                        Vector2.new(20, 20)
                    });
                    SliderInput("SliderVector2", {
                        "CellPadding",
                        nil,
                        Vector2.zero,
                        Vector2.new(20, 20)
                    });
                    SliderInput("SliderNum", { "IndentSpacing", 1, 0, 36 });
                    SliderInput("SliderNum", { "ScrollbarSize", 1, 0, 20 });
                    SliderInput("SliderNum", { "GrabMinSize", 1, 0, 20 });
                    u1.SeparatorText({ "Borders & Rounding" });
                    SliderInput("SliderNum", { "FrameBorderSize", 0.1, 0, 1 });
                    SliderInput("SliderNum", { "WindowBorderSize", 0.1, 0, 1 });
                    SliderInput("SliderNum", { "PopupBorderSize", 0.1, 0, 1 });
                    SliderInput("SliderNum", { "SeparatorTextBorderSize", 1, 0, 20 });
                    SliderInput("SliderNum", { "FrameRounding", 1, 0, 12 });
                    SliderInput("SliderNum", { "GrabRounding", 1, 0, 12 });
                    SliderInput("SliderNum", { "PopupRounding", 1, 0, 12 });
                    u1.SeparatorText({ "Widgets" });
                    SliderInput("SliderVector2", {
                        "DisplaySafeAreaPadding",
                        nil,
                        Vector2.zero,
                        Vector2.new(20, 20)
                    });
                    SliderInput("SliderVector2", {
                        "SeparatorTextPadding",
                        nil,
                        Vector2.zero,
                        Vector2.new(36, 36)
                    });
                    SliderInput("SliderUDim", {
                        "ItemWidth",
                        nil,
                        UDim.new(),
                        UDim.new(1, 200)
                    });
                    SliderInput("SliderUDim", {
                        "ContentWidth",
                        nil,
                        UDim.new(),
                        UDim.new(1, 200)
                    });
                    SliderInput("SliderNum", { "ImageBorderSize", 1, 0, 12 });
                    local v107 = u1.ComboEnum({ "WindowTitleAlign" }, {
                        index = u1.WeakState(u1._config.WindowTitleAlign)
                    }, Enum.LeftRight);

                    if v107.closed() then
                        u101.value.WindowTitleAlign = v107.index:get();
                    end;

                    BooleanInput({ "RichText" });
                    BooleanInput({ "TextWrapped" });
                    u1.SeparatorText({ "Config" });
                    BooleanInput({ "UseScreenGUIs" });
                    SliderInput("DragNum", { "DisplayOrderOffset", 1, 0 });
                    SliderInput("DragNum", { "ZIndexOffset", 1, 0 });
                    SliderInput("SliderNum", { "MouseDoubleClickTime", 0.1, 0, 5 });
                    SliderInput("SliderNum", { "MouseDoubleClickMaxDist", 0.1, 0, 20 });
                end },
            { "Colors", function() -- Line: 1007
                    -- upvalues: u1 (ref), helpMarker (ref)
                    local v108 = u1.State({});
                    u1.SameLine();

                    if u1.Button({ "Update" }).clicked() then
                        u1.UpdateGlobalConfig(v108.value);
                        v108:set({});
                    end;

                    helpMarker("Update the global config with these changes.");
                    u1.End();

                    for _, v in { "Text", "TextDisabled", "WindowBg", "PopupBg", "Border", "BorderActive", "ScrollbarGrab", "TitleBg", "TitleBgActive", "TitleBgCollapsed", "MenubarBg", "FrameBg", "FrameBgHovered", "FrameBgActive", "Button", "ButtonHovered", "ButtonActive", "Image", "SliderGrab", "SliderGrabActive", "Header", "HeaderHovered", "HeaderActive", "SelectionImageObject", "SelectionImageObjectBorder", "TableBorderStrong", "TableBorderLight", "TableRowBg", "TableRowBgAlt", "NavWindowingHighlight", "NavWindowingDimBg", "Separator", "CheckMark" } do
                        local v109 = u1.InputColor4({ v }, {
                            color = u1.WeakState(u1._config[v .. "Color"]),
                            transparency = u1.WeakState(u1._config[v .. "Transparency"])
                        });

                        if v109.numberChanged() then
                            v108.value[v .. "Color"] = v109.color:get();
                            v108.value[v .. "Transparency"] = v109.transparency:get();
                        end;
                    end;
                end },
            { "Fonts", function() -- Line: 1070
                    -- upvalues: u1 (ref), helpMarker (ref)
                    local v110 = u1.State({});
                    u1.SameLine();

                    if u1.Button({ "Update" }).clicked() then
                        u1.UpdateGlobalConfig(v110.value);
                        v110:set({});
                    end;

                    helpMarker("Update the global config with these changes.");
                    u1.End();
                    local v111 = {
                        ["Code (default)"] = Font.fromEnum(Enum.Font.Code),
                        ["Ubuntu (template)"] = Font.fromEnum(Enum.Font.Ubuntu),
                        Arial = Font.fromEnum(Enum.Font.Arial),
                        Highway = Font.fromEnum(Enum.Font.Highway),
                        Roboto = Font.fromEnum(Enum.Font.Roboto),
                        ["Roboto Mono"] = Font.fromEnum(Enum.Font.RobotoMono),
                        ["Noto Sans"] = Font.new("rbxassetid://12187370747"),
                        ["Builder Sans"] = Font.fromEnum(Enum.Font.BuilderSans),
                        ["Builder Mono"] = Font.new("rbxassetid://16658246179"),
                        Sono = Font.new("rbxassetid://12187374537")
                    };
                    u1.Text({ (`Current Font: {u1._config.TextFont.Family} Weight: {u1._config.TextFont.Weight} Style: {u1._config.TextFont.Style}`) });
                    u1.SeparatorText({ "Size" });
                    local v112 = u1.SliderNum({ "Font Size", 1, 4, 20 }, {
                        number = u1.WeakState(u1._config.TextSize)
                    });

                    if v112.numberChanged() then
                        v110.value.TextSize = v112.state.number:get();
                    end;

                    u1.SeparatorText({ "Properties" });
                    local v113 = u1.WeakState(u1._config.TextFont.Family);
                    local v114 = u1.ComboEnum({ "Font Weight" }, {
                        index = u1.WeakState(u1._config.TextFont.Weight)
                    }, Enum.FontWeight);
                    local v115 = u1.ComboEnum({ "Font Style" }, {
                        index = u1.WeakState(u1._config.TextFont.Style)
                    }, Enum.FontStyle);
                    u1.SeparatorText({ "Fonts" });

                    for i, v in v111 do
                        local v116 = Font.new(v.Family, v114.state.index.value, v115.state.index.value);
                        u1.SameLine();
                        u1.PushConfig({
                            TextFont = v116
                        });

                        if u1.Selectable({ `{i} | "The quick brown fox jumps over the lazy dog."`, v116.Family }, {
                            index = v113
                        }).selected() then
                            v110.value.TextFont = v116;
                        end;

                        u1.PopConfig();
                        u1.End();
                    end;
                end }
        };
        u1.Window({ "Style Editor" }, {
            isOpened = u5
        });
        u1.Text({ "Customize the look of Iris in realtime." });
        local v118 = u1.State("Dark Theme");

        if u1.ComboArray({ "Theme" }, {
            index = v118
        }, { "Dark Theme", "Light Theme" }).closed() then
            if v118.value == "Dark Theme" then
                u1.UpdateGlobalConfig(u1.TemplateConfig.colorDark);
            elseif v118.value == "Light Theme" then
                u1.UpdateGlobalConfig(u1.TemplateConfig.colorLight);
            end;
        end;

        local v119 = u1.State("Classic Size");

        if u1.ComboArray({ "Size" }, {
            index = v119
        }, { "Classic Size", "Larger Size" }).closed() then
            if v119.value == "Classic Size" then
                u1.UpdateGlobalConfig(u1.TemplateConfig.sizeDefault);
            elseif v119.value == "Larger Size" then
                u1.UpdateGlobalConfig(u1.TemplateConfig.sizeClear);
            end;
        end;

        u1.SameLine();

        if u1.Button({ "Revert" }).clicked() then
            u1.UpdateGlobalConfig(u1.TemplateConfig.colorDark);
            u1.UpdateGlobalConfig(u1.TemplateConfig.sizeDefault);
            v118:set("Dark Theme");
            v119:set("Classic Size");
        end;

        helpMarker("Reset Iris to the default theme and size.");
        u1.End();
        u1.TabBar();

        for i, v in ipairs(v117) do
            u1.Tab({ v[1] });
            v117[i][2]();
            u1.End();
        end;

        u1.End();
        u1.Separator();
        u1.End();
    end;

    local function widgetEventInteractivity() -- Line: 1189
        -- upvalues: u1 (copy)
        u1.CollapsingHeader({ "Widget Event Interactivity" });
        local v121 = u1.State(0);

        if u1.Button({ "Click to increase Number" }).clicked() then
            v121:set(v121:get() + 1);
        end;

        u1.Text({ "The Number is: " .. v121:get() });
        u1.Separator();
        local v122 = u1.State(false);
        local v123 = u1.State("clicked");
        u1.SameLine();
        u1.RadioButton({ "clicked", "clicked" }, {
            index = v123
        });
        u1.RadioButton({ "rightClicked", "rightClicked" }, {
            index = v123
        });
        u1.RadioButton({ "doubleClicked", "doubleClicked" }, {
            index = v123
        });
        u1.RadioButton({ "ctrlClicked", "ctrlClicked" }, {
            index = v123
        });
        u1.End();
        u1.SameLine();

        if u1.Button({ v123:get() .. " to reveal text" })[v123:get()]() then
            v122:set(not v122:get());
        end;

        if v122:get() then
            u1.Text({ "Here i am!" });
        end;

        u1.End();
        u1.Separator();
        local v124 = u1.State(0);
        u1.SameLine();

        if u1.Button({ "Click to show text for 20 frames" }).clicked() then
            v124:set(20);
        end;

        if v124:get() > 0 then
            u1.Text({ "Here i am!" });
        end;

        u1.End();
        local v125 = v124:get() - 1;
        v124:set((math.max(0, v125)));
        u1.Text({ "Text Timer: " .. v124:get() });
        local v126 = u1.Checkbox({ "Event-tracked checkbox" });
        u1.Indent();
        u1.Text({ "unchecked: " .. tostring(v126.unchecked()) });
        u1.Text({ "checked: " .. tostring(v126.checked()) });
        u1.End();
        u1.SameLine();

        if u1.Button({ "Hover over me" }).hovered() then
            u1.Text({ "The button is hovered" });
        end;

        u1.End();
        u1.End();
    end;

    local function widgetStateInteractivity() -- Line: 1260
        -- upvalues: u1 (copy)
        u1.CollapsingHeader({ "Widget State Interactivity" });
        local v127 = u1.Checkbox({ "Widget-Generated State" });
        u1.Text({ (`isChecked: {v127.state.isChecked.value}\n`) });
        local v128 = u1.State(false);
        local v129 = u1.Checkbox({ "User-Generated State" }, {
            isChecked = v128
        });
        u1.Text({ (`isChecked: {v129.state.isChecked.value}\n`) });
        local v130 = u1.Checkbox({ "Widget Coupled State" });
        local v131 = u1.Checkbox({ "Coupled to above Checkbox" }, {
            isChecked = v130.state.isChecked
        });
        u1.Text({ (`isChecked: {v131.state.isChecked.value}\n`) });
        local v132 = u1.State(false);
        u1.Checkbox({ "Widget and Code Coupled State" }, {
            isChecked = v132
        });

        if u1.Button({ "Click to toggle above checkbox" }).clicked() then
            v132:set(not v132:get());
        end;

        u1.Text({ (`isChecked: {v132.value}\n`) });
        local v133 = u1.State(true);
        local v135 = u1.ComputedState(v133, function(p134) -- Line: 1283
            return not p134;
        end);
        u1.Checkbox({ "ComputedState (dynamic coupling)" }, {
            isChecked = v133
        });
        u1.Checkbox({ "Inverted of above checkbox" }, {
            isChecked = v135
        });
        u1.Text({ (`isChecked: {v135.value}\n`) });
        u1.End();
    end;

    local function dynamicStyle() -- Line: 1293
        -- upvalues: u1 (copy), helpMarker (copy)
        u1.CollapsingHeader({ "Dynamic Styles" });
        local v136 = u1.State(0);
        u1.SameLine();

        if u1.Button({ "Change Color" }).clicked() then
            v136:set(math.random());
        end;

        local Text = u1.Text;
        local v137 = {};
        local v138 = v136:get() * 255;
        v137[1] = "Hue: " .. math.floor(v138);
        Text(v137);
        helpMarker("Using PushConfig with a changing value, this can be done with any config field");
        u1.End();
        u1.PushConfig({
            TextColor = Color3.fromHSV(v136:get(), 1, 1)
        });
        u1.Text({ "Text with a unique and changable color" });
        u1.PopConfig();
        u1.End();
    end;

    local function tablesDemo() -- Line: 1314
        -- upvalues: u1 (copy), helpMarker (copy)
        local v139 = u1.State(false);
        u1.CollapsingHeader({ "Tables & Columns" }, {
            isUncollapsed = v139
        });

        if v139.value == false then
            u1.End();

            return;
        end;

        u1.Tree({ "Basic" });
        u1.SameLine();
        u1.Text({ "Table using NextColumn syntax:" });
        helpMarker("calling Iris.NextColumn() in the inner loop,\nwhich automatically goes to the next row at the end.");
        u1.End();
        u1.Table({ 3 });

        for i = 1, 4 do
            for i2 = 1, 3 do
                u1.Text({ (`Row: {i}, Column: {i2}`) });
                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.Text({ "" });
        u1.SameLine();
        u1.Text({ "Table using NextColumn and NextRow syntax:" });
        helpMarker("Calling Iris.NextColumn() in the inner loop and Iris.NextRow() in the outer loop,\nto acehieve a visually identical result. Technically they are not the same.");
        u1.End();
        u1.Table({ 3 });

        for i = 1, 4 do
            for i2 = 1, 3 do
                u1.Text({ (`Row: {i}, Column: {i2}`) });
                u1.NextColumn();
            end;

            u1.NextRow();
        end;

        u1.End();
        u1.End();
        u1.Tree({ "Headers, borders and backgrounds" });
        local v140 = u1.State(0);
        local v141 = u1.State(false);
        local v142 = u1.State(false);
        local v143 = u1.State(true);
        local v144 = u1.State(true);
        u1.Checkbox({ "Table header row" }, {
            isChecked = v141
        });
        u1.Checkbox({ "Table row backgrounds" }, {
            isChecked = v142
        });
        u1.Checkbox({ "Table outer border" }, {
            isChecked = v143
        });
        u1.Checkbox({ "Table inner borders" }, {
            isChecked = v144
        });
        u1.SameLine();
        u1.Text({ "Cell contents" });
        u1.RadioButton({ "Text", 0 }, {
            index = v140
        });
        u1.RadioButton({ "Fill button", 1 }, {
            index = v140
        });
        u1.End();
        u1.Table({
            3,
            v141.value,
            v142.value,
            v143.value,
            v144.value
        });
        u1.SetHeaderColumnIndex(1);

        for i = 0, 4 do
            for i2 = 1, 3 do
                if v140.value == 0 then
                    u1.Text({ (`Cell ({i2}, {i})`) });
                else
                    u1.Button({ `Cell ({i2}, {i})`, UDim2.fromScale(1, 0) });
                end;

                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.End();
        u1.Tree({ "Sizing" });
        local v145 = u1.State(false);
        local v146 = u1.State(false);
        u1.Checkbox({ "Resizable" }, {
            isChecked = v145
        });
        u1.Checkbox({ "Limit Table Width" }, {
            isChecked = v146
        });
        u1.SeparatorText({ "stretch, equal" });
        u1.Table({
            3,
            false,
            true,
            true,
            true,
            v145.value
        });

        for _ = 1, 3 do
            for _ = 1, 3 do
                u1.Text({ "stretch" });
                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.Table({
            3,
            false,
            true,
            true,
            true,
            v145.value
        });

        for _ = 1, 3 do
            for i = 1, 3 do
                u1.Text({ string.rep(string.char(i + 64), i * 4) });
                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.SeparatorText({ "stretch, proportional" });
        u1.Table({
            3,
            false,
            true,
            true,
            true,
            v145.value,
            false,
            true
        });

        for _ = 1, 3 do
            for _ = 1, 3 do
                u1.Text({ "stretch" });
                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.Table({
            3,
            false,
            true,
            true,
            true,
            v145.value,
            false,
            true
        });

        for _ = 1, 3 do
            for i = 1, 3 do
                u1.Text({ string.rep(string.char(i + 64), i * 4) });
                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.SeparatorText({ "fixed, equal" });
        u1.Table({
            3,
            false,
            true,
            true,
            true,
            v145.value,
            true,
            false,
            v146.value
        });

        for _ = 1, 3 do
            for _ = 1, 3 do
                u1.Text({ "fixed" });
                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.Table({
            3,
            false,
            true,
            true,
            true,
            v145.value,
            true,
            false,
            v146.value
        });

        for _ = 1, 3 do
            for i = 1, 3 do
                u1.Text({ string.rep(string.char(i + 64), i * 4) });
                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.SeparatorText({ "fixed, proportional" });
        u1.Table({
            3,
            false,
            true,
            true,
            true,
            v145.value,
            true,
            true,
            v146.value
        });

        for _ = 1, 3 do
            for _ = 1, 3 do
                u1.Text({ "fixed" });
                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.Table({
            3,
            false,
            true,
            true,
            true,
            v145.value,
            true,
            true,
            v146.value
        });

        for _ = 1, 3 do
            for i = 1, 3 do
                u1.Text({ string.rep(string.char(i + 64), i * 4) });
                u1.NextColumn();
            end;
        end;

        u1.End();
        u1.End();
        u1.Tree({ "Resizable" });
        local v147 = u1.State(4);
        local v148 = u1.State(3);
        local v149 = u1.State(false);
        local v150 = u1.State(true);
        local v151 = u1.State(true);
        local v152 = u1.State(true);
        local v153 = u1.State(true);
        local v154 = u1.State(false);
        local v155 = u1.State(false);
        local v156 = u1.State(false);
        local v157 = u1.State(false);
        local v158 = u1.State(false);
        local u159 = u1.State(table.create(10, 100));
        u1.SliderNum({ "Num Columns", 1, 1, 10 }, {
            number = v147
        });
        u1.SliderNum({ "Number of rows", 1, 0, 100 }, {
            number = v148
        });
        u1.SameLine();
        u1.RadioButton({ "Buttons", true }, {
            index = v149
        });
        u1.RadioButton({ "Text", false }, {
            index = v149
        });
        u1.End();
        u1.Table({ 3 });
        u1.Checkbox({ "Show Header Row" }, {
            isChecked = v150
        });
        u1.NextColumn();
        u1.Checkbox({ "Show Row Backgrounds" }, {
            isChecked = v151
        });
        u1.NextColumn();
        u1.Checkbox({ "Show Outer Border" }, {
            isChecked = v152
        });
        u1.NextColumn();
        u1.Checkbox({ "Show Inner Border" }, {
            isChecked = v153
        });
        u1.NextColumn();
        u1.Checkbox({ "Resizable" }, {
            isChecked = v154
        });
        u1.NextColumn();
        u1.Checkbox({ "Fixed Width" }, {
            isChecked = v155
        });
        u1.NextColumn();
        u1.Checkbox({ "Proportional Width" }, {
            isChecked = v156
        });
        u1.NextColumn();
        u1.Checkbox({ "Limit Table Width" }, {
            isChecked = v157
        });
        u1.NextColumn();
        u1.Checkbox({ "Add extra" }, {
            isChecked = v158
        });
        u1.NextColumn();
        u1.End();

        for i = 1, v147.value do
            local v160 = v155.value == true and 1 or 0.05;
            local v161 = v155.value == true and 2 or 0.05;
            local v162 = v155.value == true and 480 or 1;
            u1.SliderNum({
                `Column {i} Width`,
                v160,
                v161,
                v162
            }, {
                number = u1.TableState(u159.value, i, function(p163) -- Line: 1567
                    -- upvalues: u159 (copy), i (copy)
                    u159.value[i] = p163;
                    u159:set(u159.value, true);

                    return false;
                end)
            });
        end;

        u1.PushConfig({
            NumColumns = v147.value
        });
        u1.Table({
            v147.value,
            v150.value,
            v151.value,
            v152.value,
            v153.value,
            v154.value,
            v155.value,
            v156.value,
            v157.value
        }, {
            widths = u159
        });
        u1.SetHeaderColumnIndex(1);

        for i = 0, v148:get() do
            for i2 = 1, v147.value do
                if i == 0 then
                    if v149.value then
                        u1.Button({ (`H: {i2}`) });
                    else
                        u1.Text({ (`H: {i2}`) });
                    end;
                elseif v149.value then
                    u1.Button({ (`R: {i}, C: {i2}`) });
                    u1.Button({ string.rep("...", i2) });
                else
                    u1.Text({ (`R: {i}, C: {i2}`) });
                    u1.Text({ string.rep("...", i2) });
                end;

                u1.NextColumn();
            end;
        end;

        if v158.value then
            u1.Text({ "A really long piece of text!" });
        end;

        u1.End();
        u1.PopConfig();
        u1.End();
        u1.End();
    end;

    local function layoutDemo() -- Line: 1629
        -- upvalues: u1 (copy), helpMarker (copy)
        u1.CollapsingHeader({ "Widget Layout" });
        u1.Tree({ "Widget Alignment" });
        u1.Text({ "Iris.SameLine has optional argument supporting horizontal and vertical alignments." });
        u1.Text({ "This allows widgets to be place anywhere on the line." });
        u1.Separator();
        u1.SameLine();
        u1.Text({ "By default child widgets will be aligned to the left." });
        helpMarker("Iris.SameLine()\n\tIris.Button({ \"Button A\" })\n\tIris.Button({ \"Button B\" })\nIris.End()");
        u1.End();
        u1.SameLine();
        u1.Button({ "Button A" });
        u1.Button({ "Button B" });
        u1.End();
        u1.SameLine();
        u1.Text({ "But can be aligned to the center." });
        helpMarker("Iris.SameLine({ nil, nil, Enum.HorizontalAlignment.Center })\n\tIris.Button({ \"Button A\" })\n\tIris.Button({ \"Button B\" })\nIris.End()");
        u1.End();
        u1.SameLine({ nil, nil, Enum.HorizontalAlignment.Center });
        u1.Button({ "Button A" });
        u1.Button({ "Button B" });
        u1.End();
        u1.SameLine();
        u1.Text({ "Or right." });
        helpMarker("Iris.SameLine({ nil, nil, Enum.HorizontalAlignment.Right })\n\tIris.Button({ \"Button A\" })\n\tIris.Button({ \"Button B\" })\nIris.End()");
        u1.End();
        u1.SameLine({ nil, nil, Enum.HorizontalAlignment.Right });
        u1.Button({ "Button A" });
        u1.Button({ "Button B" });
        u1.End();
        u1.Separator();
        u1.SameLine();
        u1.Text({ "You can also specify the padding." });
        helpMarker("Iris.SameLine({ 0, nil, Enum.HorizontalAlignment.Center })\n\tIris.Button({ \"Button A\" })\n\tIris.Button({ \"Button B\" })\nIris.End()");
        u1.End();
        u1.SameLine({ 0, nil, Enum.HorizontalAlignment.Center });
        u1.Button({ "Button A" });
        u1.Button({ "Button B" });
        u1.End();
        u1.End();
        u1.Tree({ "Widget Sizing" });
        u1.Text({ "Nearly all widgets are the minimum size of the content." });
        u1.Text({ "For example, text and button widgets will be the size of the text labels." });
        u1.Text({ "Some widgets, such as the Image and Button have Size arguments will will set the size of them." });
        u1.Separator();
        u1.SameLine();
        u1.Text({ "The button takes up the full screen-width." });
        helpMarker("Iris.Button({ \"Button\", UDim2.fromScale(1, 0) })");
        u1.End();
        u1.Button({ "Button", UDim2.fromScale(1, 0) });
        u1.SameLine();
        u1.Text({ "The button takes up half the screen-width." });
        helpMarker("Iris.Button({ \"Button\", UDim2.fromScale(0.5, 0) })");
        u1.End();
        u1.Button({ "Button", UDim2.fromScale(0.5, 0) });
        u1.SameLine();
        u1.Text({ "Combining with SameLine, the buttons can fill the screen width." });
        helpMarker("The button will still be larger that the text size.");
        u1.End();
        local v164 = u1.State(2);
        u1.SliderNum({ "Number of Buttons", 1, 1, 8 }, {
            number = v164
        });
        u1.SameLine({ 0, nil, Enum.HorizontalAlignment.Center });

        for i = 1, v164.value do
            u1.Button({ `Button {i}`, UDim2.fromScale(1 / v164.value, 0) });
        end;

        u1.End();
        u1.End();
        u1.Tree({ "Content Width" });
        local v165 = u1.State(50);
        local v166 = u1.State(Enum.Axis.X);
        u1.Text({ "The Content Width is a size property which determines the width of input fields." });
        u1.SameLine();
        u1.Text({ "By default the value is UDim.new(0.65, 0)" });
        helpMarker("This is the default value from Dear ImGui.\nIt is 65% of the window width.");
        u1.End();
        u1.Text({ "This works well, but sometimes we know how wide elements are going to be and want to maximise the space." });
        u1.Text({ "Therefore, we can use Iris.PushConfig() to change the width" });
        u1.Separator();
        u1.SameLine();
        u1.Text({ "Content Width = 150 pixels" });
        helpMarker("UDim.new(0, 150)");
        u1.End();
        u1.PushConfig({
            ContentWidth = UDim.new(0, 150)
        });
        u1.DragNum({ "number", 1, 0, 100 }, {
            number = v165
        });
        u1.InputEnum({ "axis" }, {
            index = v166
        }, Enum.Axis);
        u1.PopConfig();
        u1.SameLine();
        u1.Text({ "Content Width = 50% window width" });
        helpMarker("UDim.new(0.5, 0)");
        u1.End();
        u1.PushConfig({
            ContentWidth = UDim.new(0.5, 0)
        });
        u1.DragNum({ "number", 1, 0, 100 }, {
            number = v165
        });
        u1.InputEnum({ "axis" }, {
            index = v166
        }, Enum.Axis);
        u1.PopConfig();
        u1.SameLine();
        u1.Text({ "Content Width = -150 pixels from the right side" });
        helpMarker("UDim.new(1, -150)");
        u1.End();
        u1.PushConfig({
            ContentWidth = UDim.new(1, -150)
        });
        u1.DragNum({ "number", 1, 0, 100 }, {
            number = v165
        });
        u1.InputEnum({ "axis" }, {
            index = v166
        }, Enum.Axis);
        u1.PopConfig();
        u1.End();
        u1.Tree({ "Content Height" });
        local v167 = u1.State("a single line");
        local v168 = u1.State(50);
        local v169 = u1.State(Enum.Axis.X);
        local v170 = u1.State(0);
        local v171 = os.clock() * 15 % 100 - 50;
        local v172 = math.abs(v171) - 7.5;
        v170:set(math.clamp(v172, 0, 35) / 35);
        u1.Text({ "The Content Height is a size property that determines the minimum size of certain widgets." });
        u1.Text({ "By default the value is UDim.new(0, 0), so there is no minimum height." });
        u1.Text({ "We use Iris.PushConfig() to change this value." });
        u1.Separator();
        u1.SameLine();
        u1.Text({ "Content Height = 0 pixels" });
        helpMarker("UDim.new(0, 0)");
        u1.End();
        u1.InputText({ "text" }, {
            text = v167
        });
        u1.ProgressBar({ "progress" }, {
            progress = v170
        });
        u1.DragNum({ "number", 1, 0, 100 }, {
            number = v168
        });
        u1.ComboEnum({ "axis" }, {
            index = v169
        }, Enum.Axis);
        u1.SameLine();
        u1.Text({ "Content Height = 60 pixels" });
        helpMarker("UDim.new(0, 60)");
        u1.End();
        u1.PushConfig({
            ContentHeight = UDim.new(0, 60)
        });
        u1.InputText({ "text", nil, nil, true }, {
            text = v167
        });
        u1.ProgressBar({ "progress" }, {
            progress = v170
        });
        u1.DragNum({ "number", 1, 0, 100 }, {
            number = v168
        });
        u1.ComboEnum({ "axis" }, {
            index = v169
        }, Enum.Axis);
        u1.PopConfig();
        u1.Text({ "This property can be used to force the height of a text box." });
        u1.Text({ "Just make sure you enable the MultiLine argument." });
        u1.End();
        u1.End();
    end;

    local function windowlessDemo() -- Line: 1830
        -- upvalues: u1 (copy), helpMarker (copy)
        u1.PushConfig({
            ItemWidth = UDim.new(0, 150)
        });
        u1.SameLine();
        u1.TextWrapped({ "Windowless widgets" });
        helpMarker("Widgets which are placed outside of a window will appear on the top left side of the screen.");
        u1.End();
        u1.Button({});
        u1.Tree({});
        u1.InputText({});
        u1.End();
        u1.PopConfig();
    end;

    return function() -- Line: 1850
        -- upvalues: u1 (copy), u2 (copy), mainMenuBar (copy), widgetEventInteractivity (copy), widgetStateInteractivity (copy), recursiveTree (copy), dynamicStyle (copy), u87 (copy), u86 (copy), tablesDemo (copy), layoutDemo (copy), u9 (copy), u10 (copy), u11 (copy), u3 (copy), recursiveWindow (copy), u4 (copy), runtimeInfo (copy), u8 (copy), debugPanel (copy), u5 (copy), u120 (ref), u6 (copy), windowlessDemo (copy), u7 (copy)
        local v173 = u1.State(false);
        local v174 = u1.State(false);
        local v175 = u1.State(false);
        local v176 = u1.State(true);
        local v177 = u1.State(false);
        local v178 = u1.State(false);
        local v179 = u1.State(false);
        local v180 = u1.State(false);
        local v181 = u1.State(false);

        if u2.value ~= false then
            debug.profilebegin("Iris/Demo/Window");
            local v182 = u1.Window({
                [u1.Args.Window.Title] = "Iris Demo Window",
                [u1.Args.Window.NoTitleBar] = v173.value,
                [u1.Args.Window.NoBackground] = v174.value,
                [u1.Args.Window.NoCollapse] = v175.value,
                [u1.Args.Window.NoClose] = v176.value,
                [u1.Args.Window.NoMove] = v177.value,
                [u1.Args.Window.NoScrollbar] = v178.value,
                [u1.Args.Window.NoResize] = v179.value,
                [u1.Args.Window.NoNav] = v180.value,
                [u1.Args.Window.NoMenu] = v181.value
            }, {
                size = u1.State(Vector2.new(600, 550)),
                position = u1.State(Vector2.new(100, 25)),
                isOpened = u2
            });

            if v182.state.isUncollapsed.value and v182.state.isOpened.value then
                debug.profilebegin("Iris/Demo/MenuBar");
                mainMenuBar();
                debug.profileend();
                u1.Text({ "Iris says hello. (" .. u1.Internal._version .. ")" });
                debug.profilebegin("Iris/Demo/Options");
                u1.CollapsingHeader({ "Window Options" });
                u1.Table({ 3, false, false, false });
                u1.Checkbox({ "NoTitleBar" }, {
                    isChecked = v173
                });
                u1.NextColumn();
                u1.Checkbox({ "NoBackground" }, {
                    isChecked = v174
                });
                u1.NextColumn();
                u1.Checkbox({ "NoCollapse" }, {
                    isChecked = v175
                });
                u1.NextColumn();
                u1.Checkbox({ "NoClose" }, {
                    isChecked = v176
                });
                u1.NextColumn();
                u1.Checkbox({ "NoMove" }, {
                    isChecked = v177
                });
                u1.NextColumn();
                u1.Checkbox({ "NoScrollbar" }, {
                    isChecked = v178
                });
                u1.NextColumn();
                u1.Checkbox({ "NoResize" }, {
                    isChecked = v179
                });
                u1.NextColumn();
                u1.Checkbox({ "NoNav" }, {
                    isChecked = v180
                });
                u1.NextColumn();
                u1.Checkbox({ "NoMenu" }, {
                    isChecked = v181
                });
                u1.NextColumn();
                u1.End();
                u1.End();
                debug.profileend();
                debug.profilebegin("Iris/Demo/Events");
                widgetEventInteractivity();
                debug.profileend();
                debug.profilebegin("Iris/Demo/States");
                widgetStateInteractivity();
                debug.profileend();
                debug.profilebegin("Iris/Demo/Recursive");
                u1.CollapsingHeader({ "Recursive Tree" });

                if u1.Tree({ "Recursive Tree" }).state.isUncollapsed.value then
                    recursiveTree();
                end;

                u1.End();
                u1.End();
                debug.profileend();
                debug.profilebegin("Iris/Demo/Style");
                dynamicStyle();
                debug.profileend();
                u1.Separator();
                debug.profilebegin("Iris/Demo/Widgets");
                u1.CollapsingHeader({ "Widgets" });

                for _, v in u87 do
                    debug.profilebegin((`Iris/Demo/Widgets/{v}`));
                    u86[v]();
                    debug.profileend();
                end;

                u1.End();
                debug.profileend();
                debug.profilebegin("Iris/Demo/Tables");
                tablesDemo();
                debug.profileend();
                debug.profilebegin("Iris/Demo/Layout");
                layoutDemo();
                debug.profileend();
                u1.CollapsingHeader({ "Background" });
                u1.Checkbox({ "Show background colour" }, {
                    isChecked = u9
                });
                u1.InputColor4({ "Background colour" }, {
                    color = u10,
                    transparency = u11
                });
                u1.End();
            end;

            u1.End();
            debug.profileend();

            if u3.value then
                recursiveWindow(u3);
            end;

            if u4.value then
                runtimeInfo();
            end;

            if u8.value then
                debugPanel();
            end;

            if u5.value then
                u120();
            end;

            if u6.value then
                windowlessDemo();
            end;

            if u7.value then
                mainMenuBar();
            end;

            return v182;
        end;

        u1.Checkbox({ "Open main window" }, {
            isChecked = u2
        });
    end;
end;