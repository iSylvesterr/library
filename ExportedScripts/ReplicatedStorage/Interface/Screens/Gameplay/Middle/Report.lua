-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = {};
local u7 = false;
local u8 = {};

local function getReasonOption(p9) -- Line: 40
    -- upvalues: u6 (ref)
    for _, v in u6 do
        if v.name == p9 then
            return v;
        end;
    end;

    return nil;
end;

local function setReasonChecked(p10, p11) -- Line: 49
    if p10.icon then
        p10.icon.Visible = p11;
    end;
end;

local function clearOtherText() -- Line: 55
    -- upvalues: u6 (ref), u7 (ref)
    for _, v in u6 do
        if v.name == "Other" then
            break;
        end;
    end;

    if v and v.textBox then
        u7 = true;
        v.textBox.Text = "";
        u7 = false;
    end;
end;

local function clearSelection() -- Line: 64
    -- upvalues: u5 (ref), u6 (ref), u7 (ref)
    u5 = nil;

    for _, v in u6 do
        if v.icon then
            v.icon.Visible = false;
        end;
    end;

    for _, v in u6 do
        if v.name == "Other" then
            break;
        end;
    end;

    if v and v.textBox then
        u7 = true;
        v.textBox.Text = "";
        u7 = false;
    end;
end;

local function selectReason(p12) -- Line: 72
    -- upvalues: u5 (ref), u6 (ref), u7 (ref)
    u5 = p12;

    for _, v in u6 do
        local v13 = v.name == p12;

        if v.icon then
            v.icon.Visible = v13;
        end;
    end;

    if p12 == "Other" then
        return;
    end;

    for _, v in u6 do
        if v.name == "Other" then
            break;
        end;
    end;

    if v and v.textBox then
        u7 = true;
        v.textBox.Text = "";
        u7 = false;
    end;
end;

local function toggleReason(p14) -- Line: 83
    -- upvalues: u5 (ref), u6 (ref), u7 (ref)
    if u5 == p14 then
        u5 = nil;

        for _, v in u6 do
            if v.icon then
                v.icon.Visible = false;
            end;
        end;

        for _, v in u6 do
            if v.name == "Other" then
                break;
            end;
        end;

        if v and v.textBox then
            u7 = true;
            v.textBox.Text = "";
            u7 = false;
        end;

        return;
    end;

    u5 = p14;

    for _, v in u6 do
        local v15 = v.name == p14;

        if v.icon then
            v.icon.Visible = v15;
        end;
    end;

    if p14 == "Other" then
        return;
    end;

    for _, v in u6 do
        if v.name == "Other" then
            break;
        end;
    end;

    if v and v.textBox then
        u7 = true;
        v.textBox.Text = "";
        u7 = false;
    end;
end;

local function onOtherTextChanged(p16) -- Line: 92
    -- upvalues: u7 (ref), u6 (ref), u5 (ref)
    if u7 then
        return;
    end;

    local v17 = utf8.len(p16);

    if not v17 or v17 <= 100 then
        if p16 == "" then
            if u5 == "Other" then
                u5 = nil;
            end;

            return;
        end;

        u5 = "Other";

        for i, v in u6 do
            if v.name ~= "Other" and v.icon then
                v.icon.Visible = false;
            end;
        end;

        return;
    end;

    local v18 = utf8.offset(p16, 101);

    for _, v in u6 do
        if v.name == "Other" then
            break;
        end;
    end;

    if v18 and (v and v.textBox) then
        p16 = string.sub(p16, 1, v18 - 1);
        u7 = true;
        v.textBox.Text = p16;
        u7 = false;
    end;

    if p16 == "" then
        if u5 == "Other" then
            u5 = nil;
        end;

        return;
    end;

    u5 = "Other";

    for i, v in u6 do
        if v.name ~= "Other" and v.icon then
            v.icon.Visible = false;
        end;
    end;
end;

local function bindReasonOption(p19) -- Line: 126
    -- upvalues: ActivateButton (copy), onOtherTextChanged (copy), u5 (ref), u6 (ref), u7 (ref)
    local Name = p19.Name;

    if Name ~= "Toxicity" and (Name ~= "Bot" and (Name ~= "Cheating" and Name ~= "Other")) then
        return;
    end;

    local Check = p19:FindFirstChild("Check");

    if not (Check and Check:IsA("ImageButton")) then
        return;
    end;

    local Icon = Check:FindFirstChild("Icon");
    local TextBox = Check:FindFirstChild("TextBox");
    local u20 = {
        name = Name,
        checkButton = Check
    };

    if not (Icon and Icon:IsA("ImageLabel")) then
        Icon = nil;
    end;

    u20.icon = Icon;

    if not (TextBox and TextBox:IsA("TextBox")) then
        TextBox = nil;
    end;

    u20.textBox = TextBox;

    if u20.icon then
        u20.icon.Visible = false;
    end;

    ActivateButton(Check);

    if Name == "Other" then
        Check.MouseButton1Click:Connect(function() -- Line: 151
            -- upvalues: u20 (copy)
            if u20.textBox then
                u20.textBox:CaptureFocus();
            end;
        end);

        if u20.textBox then
            u20.textBox.ClearTextOnFocus = false;
            u20.textBox.MultiLine = false;
            u20.textBox.TextWrapped = false;
            u20.textBox.TextXAlignment = Enum.TextXAlignment.Left;
            u20.textBox.ClipsDescendants = true;
            Check.ClipsDescendants = true;
            u20.textBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 166
                -- upvalues: onOtherTextChanged (ref), u20 (copy)
                onOtherTextChanged(u20.textBox.Text);
            end);
        end;
    else
        Check.MouseButton1Click:Connect(function() -- Line: 171
            -- upvalues: Name (copy), u5 (ref), u6 (ref), u7 (ref)
            local v21 = Name;

            if u5 == v21 then
                u5 = nil;

                for _, v in u6 do
                    if v.icon then
                        v.icon.Visible = false;
                    end;
                end;

                for _, v in u6 do
                    if v.name == "Other" then
                        break;
                    end;
                end;

                if v and v.textBox then
                    u7 = true;
                    v.textBox.Text = "";
                    u7 = false;
                end;
            else
                u5 = v21;

                for _, v in u6 do
                    local v22 = v.name == v21;

                    if v.icon then
                        v.icon.Visible = v22;
                    end;
                end;

                if v21 ~= "Other" then
                    for _, v in u6 do
                        if v.name == "Other" then
                            break;
                        end;
                    end;

                    if v and v.textBox then
                        u7 = true;
                        v.textBox.Text = "";
                        u7 = false;
                    end;
                end;
            end;
        end);
    end;

    table.insert(u6, u20);
end;

function u1.Close() -- Line: 179
    -- upvalues: u2 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), CameraController (copy)
    if u2 then
        u2.Visible = false;
    end;

    u4 = nil;
    u5 = nil;

    for _, v in u6 do
        if v.icon then
            v.icon.Visible = false;
        end;
    end;

    for _, v in u6 do
        if v.name == "Other" then
            break;
        end;
    end;

    if v and v.textBox then
        u7 = true;
        v.textBox.Text = "";
        u7 = false;
    end;

    CameraController.setForceLockOverride("Report", false);
end;

function u1.Open(p23) -- Line: 188
    -- upvalues: LocalPlayer (copy), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u3 (ref), u2 (ref), CameraController (copy)
    if p23 == LocalPlayer then
        return;
    end;

    u4 = p23;
    u5 = nil;

    for _, v in u6 do
        if v.icon then
            v.icon.Visible = false;
        end;
    end;

    for _, v in u6 do
        if v.name == "Other" then
            break;
        end;
    end;

    if v and v.textBox then
        u7 = true;
        v.textBox.Text = "";
        u7 = false;
    end;

    if u3 then
        u3.Text = `Reporting {p23.Name}`;
    end;

    if u2 then
        u2.Visible = true;
    end;

    CameraController.setForceLockOverride("Report", true);
end;

function u1.Submit() -- Line: 207
    -- upvalues: u4 (ref), u5 (ref), LocalPlayer (copy), u1 (copy), u8 (copy), Remotes (copy)
    local v24 = u4;
    local v25 = u5;

    if not v24 or (v24 == LocalPlayer or not v25) then
        u1.Close();

        return;
    end;

    if u8[v24.UserId] then
        u1.Close();

        return;
    end;

    u8[v24.UserId] = true;
    local v26;

    if v25 == "Other" then
        v26 = u1.GetOtherReasonText();
    else
        v26 = nil;
    end;

    Remotes.Player.SubmitPlayerReport.Send({
        ReportedPlayer = v24,
        Reason = v25,
        Detail = v26
    });
    u1.Close();
end;

function u1.GetReportedPlayer() -- Line: 235
    -- upvalues: u4 (ref)
    return u4;
end;

function u1.GetSelectedReason() -- Line: 239
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.GetOtherReasonText() -- Line: 243
    -- upvalues: u6 (ref)
    for _, v in u6 do
        if v.name == "Other" then
            break;
        end;
    end;

    return not (v and v.textBox) and "" or v.textBox.Text;
end;

function u1.Initialize(p27, p28) -- Line: 251
    -- upvalues: u2 (ref), u3 (ref), u6 (ref), bindReasonOption (copy), ActivateButton (copy), u1 (copy)
    u2 = p28;
    u2.Visible = false;
    local Main = p28:FindFirstChild("Main");
    local v29;

    if Main then
        v29 = Main:FindFirstChild("Top");
    else
        v29 = Main;
    end;

    local v30;

    if Main then
        v30 = Main:FindFirstChild("Reason");
    else
        v30 = Main;
    end;

    if Main then
        Main = Main:FindFirstChild("Options");
    end;

    if v29 then
        v29 = v29:FindFirstChild("TextLabel");
    end;

    u3 = v29;
    u6 = {};

    if v30 then
        for _, child in v30:GetChildren() do
            if child:IsA("Frame") then
                bindReasonOption(child);
            end;
        end;
    end;

    if Main then
        local Close = Main:FindFirstChild("Close");

        if Close and Close:IsA("ImageButton") then
            ActivateButton(Close);
            Close.MouseButton1Click:Connect(u1.Close);
        end;

        local Report = Main:FindFirstChild("Report");

        if Report and Report:IsA("ImageButton") then
            ActivateButton(Report);
            Report.MouseButton1Click:Connect(function() -- Line: 281
                -- upvalues: u1 (ref)
                u1.Submit();
            end);
        end;
    end;
end;

return u1;