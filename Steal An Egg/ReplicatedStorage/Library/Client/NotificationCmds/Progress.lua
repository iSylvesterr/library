-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local NotificationInstance = require(script.Parent.NotificationInstance);
local Functions = require(ReplicatedStorage.Library.Functions);
local Wiggle = require(ReplicatedStorage.Library.Client.GUIFX.Wiggle);
local Shimmer = require(ReplicatedStorage.Library.Client.GUIFX.Shimmer);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Audio = require(ReplicatedStorage.Library.Audio);
local Progress = ReplicatedStorage.Assets.UI.Notifications.Top.Progress;
local Task = Progress.Tasks.Task;
local v1 = {};
local u2 = { 102750162720807, 139149259758312, 119928278928582, 78616358641574 };
local v3 = t.interface({
    Progress = t.number,
    Maximum = t.number,
    Desc = t.string,
    Segments = t.optional(t.number)
});
local u4 = t.interface({
    Title = t.string,
    SideIcon = t.optional(t.string),
    Bars = t.array(v3),
    AnimateWhenCompleted = t.optional(t.boolean)
});

function v1.Top(p5, p6) -- Line: 53
    -- upvalues: u4 (copy), u2 (copy), Task (copy), Functions (copy), Progress (copy), Audio (copy), Shimmer (copy), Wiggle (copy), NotificationInstance (copy)
    assert(u4(p5));
    local v7 = 0;
    local v8 = {};
    local u9 = nil;

    for i, v in ipairs(p5.Bars) do
        local v10 = math.clamp(v.Progress, 0, v.Maximum);
        local v11 = math.max(v.Maximum, 1);
        local v12;

        if not v.Segments or v.Segments <= 1 then
            local v13 = v10 / v11;
            v12 = Task:Clone();

            if v13 < 1 then
                v12.Amount.Text = ("%s/%s"):format(Functions.Commas(v10), Functions.Commas(v11));
                v12.Progress.Bar.Size = UDim2.new(v13, 0, 1, 0);
            else
                v12.Amount.Text = "Done!";
                v12.Progress.Bar.Size = UDim2.new(1, 0, 1, 0);
                v7 = v7 + 1;
            end;

            if v12 then
                v12.Label.Text = v.Desc;
                v12.LayoutOrder = i;
                table.insert(v8, v12);
            end;
        end;

        local v14 = math.floor(v.Segments);
        local v15 = math.floor(v10 / (v11 / v14));

        if v15 > 0 and v15 > (v.LastChunks or 0) then
            v.LastChunks = v15;
            u9 = u2[v15];

            if v14 <= v15 then
                v12 = Task:Clone();
                v12.Amount.Text = "Done!";
                v12.Progress.Bar.Size = UDim2.new(1, 0, 1, 0);
                v7 = v7 + 1;
            else
                v12 = Task:Clone();
                v12.Amount.Text = ("%s/%s"):format(Functions.Commas(v10), Functions.Commas(v11));
                v12.Progress.Bar.Size = UDim2.new(v15 / v14, 0, 1, 0);
            end;

            if v12 then
                v12.Label.Text = v.Desc;
                v12.LayoutOrder = i;
                table.insert(v8, v12);
            end;
        end;
    end;

    if #v8 ~= 0 then
        local u16 = Progress:Clone();
        local SideIcon = u16.Message.SideIcon;
        u16.Tasks.Task:Destroy();
        u16.Message.Text.Title.Text = p5.Title;

        if p5.SideIcon then
            SideIcon.Visible = true;
            SideIcon.Image = p5.SideIcon;
        else
            SideIcon.Visible = false;
        end;

        for _, v in ipairs(v8) do
            v.Parent = u16.Tasks;
        end;

        local function onAppear() -- Line: 144
            -- upvalues: Audio (ref), u9 (ref)
            Audio.Play(96726510123679, script, nil, 2);

            if not u9 then
                return;
            end;

            Audio.Play(u9, script, nil, 2);
        end;

        local function onAllBarsCompleted() -- Line: 153
            -- upvalues: Audio (ref), Shimmer (ref), u16 (copy), Wiggle (ref)
            Audio.Play(96726510123679, script, nil, 2);
            task.wait(0.65);
            local v17 = Shimmer(u16);
            Wiggle(u16);
            task.delay(5, v17);
        end;

        if p5.AnimateWhenCompleted then
            if v7 < 1 then
                onAllBarsCompleted = onAppear;
            end;
        else
            onAllBarsCompleted = onAppear;
        end;

        return NotificationInstance.new(NotificationInstance.Locations.Top, u16, onAllBarsCompleted, p6);
    end;
end;

return v1;