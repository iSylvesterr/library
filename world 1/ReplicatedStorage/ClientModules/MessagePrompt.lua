-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local u1 = Color3.fromRGB(40, 40, 40);
local u2 = Color3.fromRGB(255, 255, 255);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Message = PlayerGui:WaitForChild("Message");
local MainPage = Message:WaitForChild("MainPage");
local Header = MainPage:WaitForChild("Header");
local Title = Header:WaitForChild("Title");
local TextLabel = Title:WaitForChild("TextLabel");
local ExitButton = Header:WaitForChild("ExitButton");
local TextLabel2 = MainPage:WaitForChild("Content"):WaitForChild("Message"):WaitForChild("TextLabel");
local TextLabel3 = TextLabel2:WaitForChild("TextLabel");
local Options = MainPage:WaitForChild("Options");
local Template = Options:WaitForChild("Template");
local Controllers = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Controllers");
local GuiController = require(Controllers:WaitForChild("GuiController"));
Message.Enabled = false;
local u3 = nil;
local u4 = {};
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = false;

local function StripFontColors(p9) -- Line: 121
    return string.gsub(p9, "<font([^>]*)>", function(p10) -- Line: 122
        local v11 = string.gsub(p10, "%s*color%s*=%s*\"[^\"]*\"", "");

        return "<font" .. string.gsub(v11, "%s*color%s*=%s*\'[^\']*\'", "") .. ">";
    end);
end;

local function SetTitle(p12) -- Line: 129
    -- upvalues: TextLabel (copy), Title (copy)
    TextLabel.Text = p12;
    Title.Text = string.gsub(p12, "<font([^>]*)>", function(p13) -- Line: 122
        local v14 = string.gsub(p13, "%s*color%s*=%s*\"[^\"]*\"", "");

        return "<font" .. string.gsub(v14, "%s*color%s*=%s*\'[^\']*\'", "") .. ">";
    end);
end;

local function SetMessage(p15) -- Line: 134
    -- upvalues: TextLabel3 (copy), TextLabel2 (copy)
    TextLabel3.Text = p15;
    TextLabel2.Text = string.gsub(p15, "<font([^>]*)>", function(p16) -- Line: 122
        local v17 = string.gsub(p16, "%s*color%s*=%s*\"[^\"]*\"", "");

        return "<font" .. string.gsub(v17, "%s*color%s*=%s*\'[^\']*\'", "") .. ">";
    end);
end;

local function TintColorSequence(p18, p19) -- Line: 143
    local v20, v21, v22 = p19:ToHSV();
    local v23 = 0;

    for _, v in p18.Keypoints do
        local _, _, v24 = v.Value:ToHSV();
        v23 = math.max(v23, v24);
    end;

    if v23 <= 0 then
        return ColorSequence.new(p19);
    end;

    local v25 = table.create(#p18.Keypoints);

    for i, v in p18.Keypoints do
        local _, _, v26 = v.Value:ToHSV();
        v25[i] = ColorSequenceKeypoint.new(v.Time, Color3.fromHSV(v20, v21, v22 * (v26 / v23)));
    end;

    return ColorSequence.new(v25);
end;

local function DarkenColorSequence(p27) -- Line: 163
    local v28 = table.create(#p27.Keypoints);

    for i, v in p27.Keypoints do
        local Value = v.Value;
        v28[i] = ColorSequenceKeypoint.new(v.Time, Color3.new(Value.R * 0.6, Value.G * 0.6, Value.B * 0.6));
    end;

    return ColorSequence.new(v28);
end;

local function CreateDelayRing(p29) -- Line: 178
    -- upvalues: u1 (copy), u2 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "DelayRing";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.Position = UDim2.new(1, -4, 0, 4);
    Frame.Size = UDim2.fromScale(0.25, 0.55);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = 5;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.AspectRatio = 1;
    UIAspectRatioConstraint.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Background";
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxasset://textures/ui/Controls/RadialFill.png";
    ImageLabel.ImageColor3 = u1;
    ImageLabel.ImageTransparency = 0.45;
    ImageLabel.ZIndex = Frame.ZIndex;
    ImageLabel.Parent = Frame;

    local function MakeHalf(p30, p31) -- Line: 201
        -- upvalues: Frame (copy), u2 (ref)
        local Frame2 = Instance.new("Frame");
        Frame2.Name = p30;
        Frame2.Size = UDim2.fromScale(0.5, 1);
        local v32;

        if p31 then
            v32 = UDim2.fromScale(0.5, 0);
        else
            v32 = UDim2.new();
        end;

        Frame2.Position = v32;
        Frame2.BackgroundTransparency = 1;
        Frame2.ClipsDescendants = true;
        Frame2.ZIndex = Frame.ZIndex + 1;
        Frame2.Parent = Frame;
        local ImageLabel2 = Instance.new("ImageLabel");
        ImageLabel2.Name = "ProgressBarImage";
        ImageLabel2.Size = UDim2.fromScale(2, 1);
        local v33;

        if p31 then
            v33 = UDim2.fromScale(-1, 0);
        else
            v33 = UDim2.new();
        end;

        ImageLabel2.Position = v33;
        ImageLabel2.BackgroundTransparency = 1;
        ImageLabel2.Image = "rbxasset://textures/ui/Controls/RadialFill.png";
        ImageLabel2.ImageColor3 = u2;
        ImageLabel2.ZIndex = Frame2.ZIndex;
        ImageLabel2.Parent = Frame2;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.499, 0),
            NumberSequenceKeypoint.new(0.5, 1),
            NumberSequenceKeypoint.new(1, 1)
        });
        UIGradient.Parent = ImageLabel2;

        return UIGradient;
    end;

    local v34 = MakeHalf("RightHalf", true);
    local v35 = MakeHalf("LeftHalf", false);
    v34.Rotation = 180;
    v35.Rotation = 360;
    Frame.Parent = p29;

    return {
        Frame = Frame,
        RightGradient = v34,
        LeftGradient = v35
    };
end;

local function ResolveOptions(p36) -- Line: 248
    local v37 = p36.yield == true;
    local v38;

    if p36.options then
        v38 = p36.options;
    else
        v38 = v37 and { "Yes", "No" } or { "Ok" };
    end;

    if #v38 > 2 then
        error("MessagePrompt.Prompt only supports 1 or 2 options", 3);
    end;

    if #v38 == 0 then
        error("MessagePrompt.Prompt requires at least 1 option", 3);
    end;

    local optionDelays = p36.optionDelays;

    if optionDelays and #optionDelays ~= #v38 then
        error("MessagePrompt.Prompt optionDelays length must match options length", 3);
    end;

    local v39 = table.create(#v38);

    for i = 1, #v38 do
        local v40;

        if optionDelays then
            v40 = optionDelays[i];
        else
            v40 = nil;
        end;

        v39[i] = v40;
    end;

    return v38, v39;
end;

local function BeginSession() -- Line: 276
    -- upvalues: u5 (ref), u7 (ref), GuiController (copy), Message (copy), u6 (ref)
    if u5 then
        return;
    end;

    u5 = true;
    u7 = GuiController:SnapshotHudStates();
    local Gui = GuiController.Gui;

    if Gui and Gui ~= Message then
        u6 = Gui.Name;
    else
        u6 = nil;
    end;

    GuiController:Open("Message", true);
end;

local function EndSession(p41) -- Line: 300
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), GuiController (copy), Message (copy), PlayerGui (copy)
    if not u5 then
        return;
    end;

    u5 = false;
    local v42 = u6;
    local v43 = u7;
    u6 = nil;
    u7 = nil;

    if GuiController.Gui ~= Message then
        return;
    end;

    local v44 = false;

    if p41 then
        GuiController:Close(nil, true);
    elseif v42 and PlayerGui:FindFirstChild(v42) then
        GuiController:Open(v42, true);
        v44 = true;
    else
        GuiController:Close(nil, true);
    end;

    if v43 and (v44 or not v42) then
        GuiController:RestoreHudStates(v43);
    end;
end;

local u45 = nil;

local function DrainQueue() -- Line: 350
    -- upvalues: u3 (ref), u4 (copy), u45 (ref)
    if u3 then
        return;
    end;

    if #u4 == 0 then
        return;
    end;

    local v46 = table.remove(u4, 1);
    u45(v46.Config, v46.Resume);
end;

u45 = function(u47, u48) -- Line: 357
    -- upvalues: ResolveOptions (copy), ExitButton (copy), TextLabel (copy), Title (copy), Message (copy), u3 (ref), u4 (copy), u45 (ref), u8 (ref), EndSession (copy), TextLabel3 (copy), TextLabel2 (copy), Template (copy), TintColorSequence (copy), Options (copy), DarkenColorSequence (copy), CreateDelayRing (copy), RunService (copy)
    local v49, v50 = ResolveOptions(u47);
    local u51 = #v49 == 1 and 1 or 2;
    local v52 = u47.hideClose == true;
    local u53 = u47.titleOverride or "Alert";
    local u54 = false;
    local u55 = {};
    local u56 = {};

    local function Respond(p57) -- Line: 368
        -- upvalues: u54 (ref), u55 (copy), u56 (copy), ExitButton (ref), u53 (copy), TextLabel (ref), Title (ref), Message (ref), u3 (ref), u48 (copy), u4 (ref), u45 (ref), u8 (ref), u47 (copy), EndSession (ref)
        if u54 then
            return;
        end;

        u54 = true;

        for _, v in u55 do
            v:Disconnect();
        end;

        table.clear(u55);

        for _, v in u56 do
            v:Destroy();
        end;

        table.clear(u56);
        ExitButton.Visible = true;
        ExitButton.Active = true;
        local v58 = u53;
        TextLabel.Text = v58;
        Title.Text = string.gsub(v58, "<font([^>]*)>", function(p59) -- Line: 122
            local v60 = string.gsub(p59, "%s*color%s*=%s*\"[^\"]*\"", "");

            return "<font" .. string.gsub(v60, "%s*color%s*=%s*\'[^\']*\'", "") .. ">";
        end);
        Message.Enabled = false;
        u3 = nil;

        if u48 then
            task.spawn(u48, p57);
        end;

        if not u3 and #u4 ~= 0 then
            local v61 = table.remove(u4, 1);
            u45(v61.Config, v61.Resume);
        end;

        if not (u3 or u8) then
            local v62 = p57 == 1;
            local v63;

            if u47.dontRestore == true or v62 and u47.dontRestoreOnSuccess == true then
                v63 = true;
            else
                v63 = not v62 and u47.dontRestoreOnFail == true;
            end;

            EndSession(v63);
        end;
    end;

    u3 = {
        Respond = Respond
    };
    TextLabel.Text = u53;
    Title.Text = string.gsub(u53, "<font([^>]*)>", function(p64) -- Line: 122
        local v65 = string.gsub(p64, "%s*color%s*=%s*\"[^\"]*\"", "");

        return "<font" .. string.gsub(v65, "%s*color%s*=%s*\'[^\']*\'", "") .. ">";
    end);
    local message = u47.message;
    TextLabel3.Text = message;
    TextLabel2.Text = string.gsub(message, "<font([^>]*)>", function(p66) -- Line: 122
        local v67 = string.gsub(p66, "%s*color%s*=%s*\"[^\"]*\"", "");

        return "<font" .. string.gsub(v67, "%s*color%s*=%s*\'[^\']*\'", "") .. ">";
    end);
    ExitButton.Visible = not v52;
    ExitButton.Active = not v52;

    if not v52 then
        local v68 = ExitButton.Activated:Connect(function() -- Line: 416
            -- upvalues: Respond (copy), u51 (copy)
            Respond(u51);
        end);
        table.insert(u55, v68);
    end;

    local function WireOptionClick(p69, u70) -- Line: 422
        -- upvalues: Respond (copy), u55 (copy)
        local v71 = p69.Activated:Connect(function() -- Line: 423
            -- upvalues: Respond (ref), u70 (copy)
            Respond(u70);
        end);
        table.insert(u55, v71);
    end;

    for i, v in v49 do
        local u72 = Template:Clone();
        u72.Name = `Option{i}`;
        u72.Visible = true;
        u72.LayoutOrder = i;
        local TextLabel4 = u72:WaitForChild("TextLabel");
        local TextLabel5 = TextLabel4:WaitForChild("TextLabel");
        TextLabel4.Text = v;
        TextLabel5.Text = v;
        local u73 = u72:WaitForChild(i == 1 and "GreenGradient" or "RedGradient");
        u73.Enabled = true;
        local v74;

        if u47.optionColors then
            v74 = u47.optionColors[i];
        else
            v74 = nil;
        end;

        if v74 then
            u73.Color = TintColorSequence(u73.Color, v74);
        end;

        u72.Parent = Options;
        table.insert(u56, u72);
        local u75 = v50[i];

        if u75 and u75 > 0 then
            local Color = u73.Color;
            u73.Color = DarkenColorSequence(Color);
            u72.Active = false;
            u72.AutoButtonColor = false;
            local u76 = CreateDelayRing(u72);
            local u77 = os.clock();
            local u78 = nil;
            u78 = RunService.Heartbeat:Connect(function() -- Line: 464
                -- upvalues: u54 (ref), u77 (copy), u75 (copy), u76 (copy), u78 (ref), u73 (copy), Color (copy), u72 (copy), i (copy), Respond (copy), u55 (copy)
                if u54 then
                    return;
                end;

                local v79 = 1 - (os.clock() - u77) / u75;
                local v80 = math.max(0, v79);
                local v81 = math.clamp(v80 * 360, 0, 360);
                u76.RightGradient.Rotation = math.clamp(v81, 0, 180);
                u76.LeftGradient.Rotation = math.clamp(v81, 180, 360);

                if v80 <= 0 then
                    u78:Disconnect();

                    if u54 then
                        return;
                    end;

                    u76.Frame:Destroy();
                    u73.Color = Color;
                    u72.Active = true;
                    u72.AutoButtonColor = true;
                    local u82 = i;
                    local v83 = u72.Activated:Connect(function() -- Line: 423
                        -- upvalues: Respond (ref), u82 (copy)
                        Respond(u82);
                    end);
                    table.insert(u55, v83);
                end;
            end);
            table.insert(u55, u78);
        else
            local v84 = u72.Activated:Connect(function() -- Line: 423
                -- upvalues: Respond (copy), i (copy)
                Respond(i);
            end);
            table.insert(u55, v84);
        end;
    end;

    local duration = u47.duration;

    if duration and duration > 0 then
        local u85 = os.clock();
        local u86 = nil;
        u86 = RunService.Heartbeat:Connect(function() -- Line: 490
            -- upvalues: u54 (ref), duration (copy), u85 (copy), u86 (ref), Respond (copy), u51 (copy), u53 (copy), TextLabel (ref), Title (ref)
            if u54 then
                return;
            end;

            local v87 = duration - (os.clock() - u85);

            if v87 <= 0 then
                u86:Disconnect();
                Respond(u51);

                return;
            end;

            local v88 = math.ceil(v87);
            local v89 = `{u53} ({math.max(1, v88)}s)`;
            TextLabel.Text = v89;
            Title.Text = string.gsub(v89, "<font([^>]*)>", function(p90) -- Line: 122
                local v91 = string.gsub(p90, "%s*color%s*=%s*\"[^\"]*\"", "");

                return "<font" .. string.gsub(v91, "%s*color%s*=%s*\'[^\']*\'", "") .. ">";
            end);
        end);
        table.insert(u55, u86);
    end;

    Message.Enabled = true;
end;

local function ForceResolveAll() -- Line: 513
    -- upvalues: u8 (ref), u4 (copy), u3 (ref)
    u8 = true;

    for _, v in u4 do
        if v.Resume then
            task.spawn(v.Resume, 0);
        end;
    end;

    table.clear(u4);

    if u3 then
        u3.Respond(0);
    end;

    u8 = false;
end;

local v95 = {
    Choices = table.freeze({
        Ok = table.freeze({ "Ok" }),
        YesNo = table.freeze({ "Yes", "No" }),
        ConfirmDeny = table.freeze({ "Confirm", "Deny" })
    }),

    Prompt = function(p92) -- Line: 537, Name: Prompt
        -- upvalues: ResolveOptions (copy), ForceResolveAll (copy), u5 (ref), u7 (ref), GuiController (copy), Message (copy), u6 (ref), u45 (ref), u3 (ref), u4 (copy)
        ResolveOptions(p92);
        local v93 = p92.yield == true;
        local v94;

        if v93 then
            v94 = coroutine.running();
        else
            v94 = nil;
        end;

        if p92.force then
            ForceResolveAll();

            if not u5 then
                u5 = true;
                u7 = GuiController:SnapshotHudStates();
                local Gui = GuiController.Gui;

                if Gui and Gui ~= Message then
                    u6 = Gui.Name;
                else
                    u6 = nil;
                end;

                GuiController:Open("Message", true);
            end;

            u45(p92, v94);
        elseif u3 then
            table.insert(u4, {
                Config = p92,
                Resume = v94
            });
        else
            if not u5 then
                u5 = true;
                u7 = GuiController:SnapshotHudStates();
                local Gui = GuiController.Gui;

                if Gui and Gui ~= Message then
                    u6 = Gui.Name;
                else
                    u6 = nil;
                end;

                GuiController:Open("Message", true);
            end;

            u45(p92, v94);
        end;

        if v93 then
            return coroutine.yield() == 1;
        end;

        return nil;
    end,

    Dismiss = function() -- Line: 577, Name: Dismiss
        -- upvalues: u3 (ref), u4 (copy)
        if not u3 and #u4 == 0 then
            return;
        end;

        for _, v in u4 do
            if v.Resume then
                task.spawn(v.Resume, 0);
            end;
        end;

        table.clear(u4);

        if u3 then
            u3.Respond(0);
        end;
    end
};

return table.freeze(v95);