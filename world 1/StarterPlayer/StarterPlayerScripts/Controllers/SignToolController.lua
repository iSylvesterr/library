-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local SignToolChangeTextMenu = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SignToolChangeTextMenu");
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local ImageAssetId = require(game.ReplicatedStorage.SharedModules.ImageAssetId);
local u2 = require("./GuiController");
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local u3 = false;
local u4 = 0;
local u5 = "";
local u6 = "";
local TextFrame = SignToolChangeTextMenu:WaitForChild("TextFrame");
local Input = TextFrame:WaitForChild("Input");
local CharCount = TextFrame:WaitForChild("CharCount");
local Input2 = SignToolChangeTextMenu:WaitForChild("ImageFrame"):WaitForChild("Input");
Input.ClearTextOnFocus = false;
Input2.ClearTextOnFocus = false;

local function openSignMenu() -- Line: 33
    -- upvalues: u3 (ref), LocalPlayer (copy), u5 (ref), u6 (ref), ImageAssetId (copy), u2 (copy), Input (copy), Input2 (copy), CharCount (copy)
    if u3 then
        return;
    end;

    u3 = true;
    local SignText = LocalPlayer:FindFirstChild("SignText");
    u5 = SignText and SignText.Value or "";
    local SignImage = LocalPlayer:FindFirstChild("SignImage");

    if SignImage then
        SignImage = SignImage.Value;
    end;

    local v7 = ImageAssetId.Parse(SignImage) or "";
    u6 = tostring(v7);
    u2:Open("SignToolChangeTextMenu");
    Input.Text = u5;
    Input2.Text = u6;
    CharCount.Text = `{#u5}/{100}`;
    Input:CaptureFocus();
end;

local function saveText() -- Line: 51
    -- upvalues: Input (copy), u5 (ref), u4 (ref), NotificationController (copy), Networking (copy)
    local Text = Input.Text;

    if #Text > 100 then
        Text = string.sub(Text, 1, 100);
    end;

    if Text == u5 then
        return;
    end;

    local v8 = os.clock();
    local v9 = 5 - (v8 - u4);

    if v9 > 0 then
        NotificationController:CreateNotification((`Please wait {math.ceil(v9)}s before changing sign text.`));

        return;
    end;

    u4 = v8;
    u5 = Text;
    Networking.SignTool.SetSignText:Fire(Text);
end;

local function saveImage() -- Line: 71
    -- upvalues: Input2 (copy), u6 (ref), Networking (copy)
    local Text = Input2.Text;

    if Text == u6 then
        return;
    end;

    u6 = Text;
    Networking.SignTool.SetSignImage:Fire(Text);
end;

local function maybeClose() -- Line: 83
    -- upvalues: RunService (copy), u3 (ref), Input (copy), Input2 (copy), u2 (copy)
    task.spawn(function() -- Line: 84
        -- upvalues: RunService (ref), u3 (ref), Input (ref), Input2 (ref), u2 (ref)
        RunService.Heartbeat:Wait();

        if not u3 then
            return;
        end;

        if Input:IsFocused() or Input2:IsFocused() then
            return;
        end;

        u3 = false;
        u2:Close("SignToolChangeTextMenu");
    end);
end;

function v1.Init(p10) -- Line: 93
end;

function v1.Start(p11) -- Line: 96
    -- upvalues: Input (copy), CharCount (copy), Input2 (copy), saveText (copy), RunService (copy), u3 (ref), u2 (copy), u6 (ref), Networking (copy), LocalPlayer (copy), openSignMenu (copy)
    Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 97
        -- upvalues: Input (ref), CharCount (ref)
        local Text = Input.Text;

        if #Text > 100 then
            Input.Text = string.sub(Text, 1, 100);

            return;
        end;

        CharCount.Text = `{#Text}/{100}`;
    end);
    Input2:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 107
        -- upvalues: Input2 (ref)
        local v12 = Input2.Text:gsub("%D", "");

        if v12 ~= Input2.Text then
            Input2.Text = v12;
        end;
    end);
    Input.FocusLost:Connect(function() -- Line: 114
        -- upvalues: saveText (ref), RunService (ref), u3 (ref), Input (ref), Input2 (ref), u2 (ref)
        saveText();
        task.spawn(function() -- Line: 84
            -- upvalues: RunService (ref), u3 (ref), Input (ref), Input2 (ref), u2 (ref)
            RunService.Heartbeat:Wait();

            if not u3 then
                return;
            end;

            if Input:IsFocused() or Input2:IsFocused() then
                return;
            end;

            u3 = false;
            u2:Close("SignToolChangeTextMenu");
        end);
    end);
    Input2.FocusLost:Connect(function() -- Line: 119
        -- upvalues: Input2 (ref), u6 (ref), Networking (ref), RunService (ref), u3 (ref), Input (ref), u2 (ref)
        local Text = Input2.Text;

        if Text ~= u6 then
            u6 = Text;
            Networking.SignTool.SetSignImage:Fire(Text);
        end;

        task.spawn(function() -- Line: 84
            -- upvalues: RunService (ref), u3 (ref), Input (ref), Input2 (ref), u2 (ref)
            RunService.Heartbeat:Wait();

            if not u3 then
                return;
            end;

            if Input:IsFocused() or Input2:IsFocused() then
                return;
            end;

            u3 = false;
            u2:Close("SignToolChangeTextMenu");
        end);
    end);
    local u13 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();

    local function onChildAdded(p14) -- Line: 127
        -- upvalues: openSignMenu (ref)
        if not p14:IsA("Tool") then
            return;
        end;

        if not p14:GetAttribute("Sign") then
            return;
        end;

        p14.Activated:Connect(function() -- Line: 131
            -- upvalues: openSignMenu (ref)
            openSignMenu();
        end);
    end;

    u13.ChildAdded:Connect(onChildAdded);

    for _, child in u13:GetChildren() do
        onChildAdded(child);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p15) -- Line: 139
        -- upvalues: u13 (ref), onChildAdded (copy)
        u13 = p15;
        u13.ChildAdded:Connect(onChildAdded);
    end);
end;

return v1;