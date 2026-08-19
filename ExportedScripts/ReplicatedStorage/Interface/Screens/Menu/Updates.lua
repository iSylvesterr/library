-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local UpdateLogs = require(ReplicatedStorage.Database.Custom.UpdateLogs);
local u2 = nil;

local function buildLog(u3) -- Line: 30
    -- upvalues: ReplicatedStorage (copy), u2 (ref), ActivateButton (copy)
    local v4 = ReplicatedStorage.Assets.UI.Updates.Update:Clone();
    v4.Container.Thumbnail.Image = u3.Banner;
    v4.Name = u3.Date;
    v4.Container.HEADING.Text = u3.Title;
    v4.Container.DATE.Text = u3.Date;
    v4.Parent = u2.Main.Container.Content.Scroll.Scroll;
    local v5 = ReplicatedStorage.Assets.UI.Updates.Date:Clone();
    v5.Image = u3.Banner;
    v5.Info.Mode.Text = u3.Title;
    v5.Info.Description.Text = u3.Date;
    v5.Parent = u2.Main.Container.Content.UpdateDates.Container;

    for _, v in u3.Headers do
        local v6 = ReplicatedStorage.Assets.UI.Updates.Category:Clone();
        v6.Category.Text = `[{v.Title}]`;
        v6.Parent = v4.Container;

        for _, v2 in v.Logs do
            local v7 = ReplicatedStorage.Assets.UI.Updates.Log:Clone();
            v7.Text = v2;
            v7.Parent = v6;
        end;
    end;

    ActivateButton(v5);
    v5.MouseButton1Click:Connect(function() -- Line: 57
        -- upvalues: u2 (ref), u3 (copy)
        for _, child in u2.Main.Container.Content.Scroll.Scroll:GetChildren() do
            if child:IsA("Frame") then
                child.Visible = child.Name == u3.Date;
            end;
        end;
    end);

    return v4;
end;

function v1.Initialize(p8, p9) -- Line: 70
    -- upvalues: u2 (ref), UpdateLogs (copy), buildLog (copy), ActivateButton (copy)
    u2 = p9;

    for i = 1, #UpdateLogs do
        buildLog(UpdateLogs[i]).Visible = i == 1;
    end;

    ActivateButton(u2.Main.Container.Heading.Gradient.Buttons.Close);
    u2.Main.Container.Heading.Gradient.Buttons.Close.MouseButton1Click:Connect(function() -- Line: 79
        -- upvalues: u2 (ref)
        u2.Visible = false;
    end);
end;

return v1;