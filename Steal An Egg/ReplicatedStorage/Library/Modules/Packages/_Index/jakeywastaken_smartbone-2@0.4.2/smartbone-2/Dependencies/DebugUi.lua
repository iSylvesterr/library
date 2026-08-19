-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};

local function infoText(p3, p4) -- Line: 4
    p3.PushConfig({
        TextColor = p3._config.TextDisabledColor
    });
    p3.Text({ p4 });
    p3.PopConfig();
end;

local function helpMarker(p5, p6) -- Line: 10
    p5.PushConfig({
        TextColor = p5._config.TextDisabledColor
    });
    local v7 = p5.Text({ "(?)" });
    p5.PopConfig();
    p5.PushConfig({
        ContentWidth = UDim.new(0, 350)
    });

    if v7.hovered() then
        p5.Tooltip({ p6 });
    end;

    p5.PopConfig();
end;

local function BoneEditor(p8, p9) -- Line: 22
    -- upvalues: u1 (copy)
    local v10 = p8.Window({ (`Editing bone: {p9.Bone.Name}`) });
    v10.isOpened.value = true;
    p9.Radius = p8.InputNum({ "Radius", 0.1, 0, (1 / 0), "%.3f" }, {
        number = p9.Radius
    }).number.value;
    p9.RotationLimit = p8.InputNum({ "Rotation Limit", 0.1, 0, 180, "%.3f" }, {
        number = p9.RotationLimit
    }).number.value;
    p9.Anchored = p8.Checkbox({ "Anchored" }, {
        isChecked = p9.Anchored
    }).isChecked.value;
    p8.Text("Axis Lock");
    p8.Indent();
    p8.SameLine();
    p8.Text("X: ");
    local v11 = p8.Checkbox({ "" }, {
        isChecked = p9.AxisLocked[1]
    });
    p8.Text("Y: ");
    local v12 = p8.Checkbox({ "" }, {
        isChecked = p9.AxisLocked[2]
    });
    p8.Text("Z: ");
    local v13 = p8.Checkbox({ "" }, {
        isChecked = p9.AxisLocked[3]
    });
    p8.End();
    p8.End();
    local v14 = p8.State(Vector2.new(p9.XAxisLimits.Min, p9.XAxisLimits.Max));
    local v15 = p8.State(Vector2.new(p9.YAxisLimits.Min, p9.YAxisLimits.Max));
    local v16 = p8.State(Vector2.new(p9.ZAxisLimits.Min, p9.ZAxisLimits.Max));
    p8.Text("Axis Limits");
    p8.Indent();
    p8.DragVector2({ "X Axis Limit", 0.05, nil, nil, { "Min: %.2f", "Max: %.2f" } }, {
        number = v14
    });
    p8.DragVector2({ "Y Axis Limit", 0.05, nil, nil, { "Min: %.2f", "Max: %.2f" } }, {
        number = v15
    });
    p8.DragVector2({ "Z Axis Limit", 0.05, nil, nil, { "Min: %.2f", "Max: %.2f" } }, {
        number = v16
    });
    p8.End();
    p8.End();
    p9.AxisLocked[1] = v11.isChecked.value;
    p9.AxisLocked[2] = v12.isChecked.value;
    p9.AxisLocked[3] = v13.isChecked.value;
    p9.XAxisLimits = NumberRange.new(v14:get().X, v14:get().Y);
    p9.YAxisLimits = NumberRange.new(v15:get().X, v15:get().Y);
    p9.ZAxisLimits = NumberRange.new(v16:get().X, v16:get().Y);

    if v10.closed() then
        u1[p9] = nil;
    end;
end;

local function ColliderEditor(p17, p18) -- Line: 80
    -- upvalues: u2 (copy)
    local v19 = p17.Window({ (`Editing collider of type: {p18.Type}`) });
    v19.isOpened.value = true;
    local v20 = p17.State(p18.Type);
    local v21 = p17.State(p18.Scale);
    local v22 = p17.State(p18.Offset);
    local v23 = p17.State(p18.Rotation);
    p17.Combo({ "Collider Type" }, {
        index = v20
    });
    p17.Selectable({ "Box", "Box" }, {
        index = v20
    });
    p17.Selectable({ "Sphere", "Sphere" }, {
        index = v20
    });
    p17.Selectable({ "Capsule", "Capsule" }, {
        index = v20
    });
    p17.End();
    p17.DragVector3({ "Scale", 0.1, 0, nil }, {
        number = v21
    });
    p17.DragVector3({ "Offset", 0.1, nil, nil }, {
        number = v22
    });
    p17.DragVector3({ "Rotation", 0.5, -180, 180 }, {
        number = v23
    });
    p18.Type = v20:get();
    p18.Scale = v21:get();
    p18.Offset = v22:get();
    p18.Rotation = v23:get();
    p17.End();

    if v19.closed() then
        u2[p18] = nil;
    end;
end;

return function(p24, p25, p26) -- Line: 111
    -- upvalues: u1 (copy), BoneEditor (copy), u2 (copy), ColliderEditor (copy), helpMarker (copy), infoText (copy)
    local v27 = {};

    for _, v in p25.BoneTrees do
        local RootPart = v.RootPart;
        local v28 = v27[RootPart];

        if not v28 then
            v27[RootPart] = {};
            v28 = v27[RootPart];
        end;

        table.insert(v28, v);
    end;

    for i, _ in u1 do
        local v29 = `{p25.ID} - {i.ParentIndex + 1}`;
        p24.PushId(v29);
        BoneEditor(p24, i);
        p24.PopId();
    end;

    for i, _ in u2 do
        p24.PushId(i.GUID);
        ColliderEditor(p24, i);
        p24.PopId();
    end;

    local v30 = #p25.BoneTrees;
    local v31 = #p25.ColliderObjects;
    local v32 = `{v30} BoneTree{v30 == 1 and "" or "s"}`;
    local v33 = `{v31} Collider{v31 == 1 and "" or "s"}`;
    p24.Window({
        `SmartBone Runtime Editor. {v32}, {v33}`,
        [p24.Args.Window.NoClose] = true
    });
    p24.Tree({ "Debug Gizmos", true }, {
        isUncollapsed = true
    });
    p24.SameLine();
    p24.Checkbox({ "Draw Internal Bone" }, {
        isChecked = p26.DRAW_BONE
    });
    helpMarker(p24, "Draws a sphere with the specified radius of the bone around where SmartBone believes the bone is.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Physical Bone" }, {
        isChecked = p26.DRAW_PHYSICAL_BONE
    });
    helpMarker(p24, "Draws the actual bone objects CFrame with axis arrows.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Root Part" }, {
        isChecked = p26.DRAW_ROOT_PART
    });
    helpMarker(p24, "Draws a bounding box and fills in the root part.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Bounding Box" }, {
        isChecked = p26.DRAW_BOUNDING_BOX
    });
    helpMarker(p24, "Draws the bounding box used for frustum culling");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Axis Limits" }, {
        isChecked = p26.DRAW_AXIS_LIMITS
    });
    helpMarker(p24, "Draws the axis limits for each bone.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Rotation Limits" }, {
        isChecked = p26.DRAW_ROTATION_LIMITS
    });
    helpMarker(p24, "Draws the rotation limits for each bone.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Acceleration Info" }, {
        isChecked = p26.DRAW_ACCELERATION_INFO
    });
    helpMarker(p24, "Draws the acceleration and the required values to derive it.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Colliders" }, {
        isChecked = p26.DRAW_COLLIDERS
    });
    helpMarker(p24, "Draws all the colliders this root object can collide with.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Collider Influence" }, {
        isChecked = p26.DRAW_COLLIDER_INFLUENCE
    });
    helpMarker(p24, "Shows the sphere of influence around each collider.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Collider Awake" }, {
        isChecked = p26.DRAW_COLLIDER_AWAKE
    });
    helpMarker(p24, "Shows if a collider is awake or asleep.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Collider Broadphase" }, {
        isChecked = p26.DRAW_COLLIDER_BROADPHASE
    });
    helpMarker(p24, "Shows if a collider isn\'t reaching narrowphase.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Fill Colliders" }, {
        isChecked = p26.DRAW_FILL_COLLIDERS
    });
    helpMarker(p24, "Fills all colliders this root object can collide with.");
    p24.End();
    p24.SameLine();
    p24.Checkbox({ "Draw Contacts" }, {
        isChecked = p26.DRAW_CONTACTS
    });
    helpMarker(p24, "Draws the position and normal of the points which bones collide with colliders.");
    p24.End();
    p24.End();
    p24.Separator();
    infoText(p24, "Simulated Objects");

    for i, v in v27 do
        p24.Tree((`{i.Name} - Root Part`));

        for i2, v2 in v do
            p24.Tree((`BoneTree #{i2}`));
            infoText(p24, (`Throttled Update Rate: {string.format("%.1f", v2.UpdateRate)} / {string.format("%.1f", v2.Settings.UpdateRate)} fps`));
            infoText(p24, (`In View: {v2.InView}`));
            local v34 = p24.State(v2.Settings.Constraint);
            local v35 = p24.State(v2.Settings.WindType);
            local v36 = p24.State(v2.Settings.UpdateRate);
            local v37 = p24.State(v2.Settings.ActivationDistance);
            local v38 = p24.State(v2.Settings.ThrottleDistance);
            p24.SameLine();
            helpMarker(p24, "The constraint used, distance is more flowy while spring is more rigid.");
            p24.Combo({ "Constraint Type" }, {
                index = v34
            });
            p24.Selectable({ "Distance", "Distance" }, {
                index = v34
            });
            p24.Selectable({ "Spring", "Spring" }, {
                index = v34
            });
            p24.End();
            p24.End();
            p24.SameLine();
            helpMarker(p24, "The wind solver used, sine is a smoother wind, noise is more chaotic and hybrid is a mix of the two.");
            p24.Combo({ "Wind Type" }, {
                index = v35
            });
            p24.Selectable({ "Sine", "Sine" }, {
                index = v35
            });
            p24.Selectable({ "Noise", "Noise" }, {
                index = v35
            });
            p24.Selectable({ "Hybrid", "Hybrid" }, {
                index = v35
            });
            p24.End();
            p24.End();
            p24.SameLine();
            helpMarker(p24, "The target update rate for the bone tree");
            p24.SliderNum({ "Update Rate", 5, 0, 120 }, {
                number = v36
            });
            p24.End();
            p24.SameLine();
            helpMarker(p24, "The distance at which the bone tree stops updating");
            p24.SliderNum({ "Activation Distance", 1, 0, 500 }, {
                number = v37
            });
            p24.End();
            p24.SameLine();
            helpMarker(p24, "The distance at which the bone tree starts throttling its update rate");
            p24.SliderNum({ "Throttle Distance", 1, 0, 500 }, {
                number = v38
            });
            p24.End();
            v2.Settings.Constraint = v34:get();
            v2.Settings.WindType = v35:get();
            v2.Settings.UpdateRate = v36:get();
            v2.Settings.ActivationDistance = v37:get();
            v2.Settings.ThrottleDistance = v38:get();
            p24.Table({ 4, false, false, false });
            p24.NextColumn();
            p24.Text("Bone #");
            p24.NextColumn();
            p24.Text("Bone Name");
            p24.NextColumn();
            p24.Text("Parent #");
            p24.NextColumn();
            p24.Text("Edit");
            p24.End();
            p24.Table({ 4 });

            for i3, v3 in v2.Bones do
                p24.NextColumn();
                p24.Text((tostring(i3)));
                p24.NextColumn();
                p24.Text(v3.Bone.Name);
                p24.NextColumn();
                p24.Text((tostring(v3.ParentIndex)));
                p24.NextColumn();
                p24.SameLine();
                p24.Text("");

                if p24.SmallButton({ "Edit" }).clicked() then
                    u1[v3] = true;
                end;

                p24.End();
            end;

            p24.End();
            p24.End();
        end;

        p24.End();
    end;

    infoText(p24, "Active Colliders");

    for _, v in p25.ColliderObjects do
        p24.Tree({ v.m_Object.Name });
        infoText(p24, "Colliders adorned to this object");
        p24.Table({ 5, false, false, false });
        p24.NextColumn();
        p24.Text("Type");
        p24.NextColumn();
        p24.Text("Scale");
        p24.NextColumn();
        p24.Text("Offset");
        p24.NextColumn();
        p24.Text("Rotation");
        p24.NextColumn();
        p24.Text("Edit");
        p24.End();
        p24.Table({ 5 });

        for _, v2 in v.Colliders do
            p24.NextColumn();
            p24.Text((tostring(v2.Type)));
            p24.NextColumn();
            p24.Text((tostring(v2.Scale)));
            p24.NextColumn();
            p24.Text((tostring(v2.Offset)));
            p24.NextColumn();
            p24.Text((tostring(v2.Rotation)));
            p24.NextColumn();
            p24.SameLine();
            p24.Text("");

            if p24.SmallButton({ "Edit" }).clicked() then
                u2[v2] = true;
            end;

            p24.End();
        end;

        p24.End();
        p24.End();
    end;

    p24.End();
end;