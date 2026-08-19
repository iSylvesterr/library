-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Janitor = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Janitor"));
local RunServiceController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("RunServiceController"));
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor;
local Loader = script:WaitForChild("Loader");
local u1 = "Loading Profile";
local u2 = 0;
local u3 = 0;
local u4 = false;
local u5 = 0;
local Frame = Instance.new("Frame");
Frame.Name = "InputBlocker";
Frame.Size = UDim2.new(1, 0, 1, 0);
Frame.Position = UDim2.new(0, 0, 0, 0);
Frame.BackgroundTransparency = 1;
Frame.Active = true;
Frame.ZIndex = 6767;
Frame.Parent = Loader;
ReplicatedFirst:RemoveDefaultLoadingScreen();
Loader.Parent = PlayerGui;

local function WaitForLoaded(p6) -- Line: 53
    repeat
        task.wait();
    until p6();
end;

local function ProcessFinished(u7) -- Line: 65
    -- upvalues: u4 (ref), Loader (copy), TweenService (copy)
    if not u4 then
        u4 = true;

        for _, descendant in ipairs(Loader:GetDescendants()) do
            if descendant:IsA("TextLabel") and (descendant.Visible and descendant.TextTransparency > 0) then
                TweenService:Create(descendant, TweenInfo.new(0.95), {
                    TextTransparency = 1
                }):Play();
            elseif descendant:IsA("ImageLabel") and (descendant.Visible and descendant.ImageTransparency > 0) then
                TweenService:Create(descendant, TweenInfo.new(0.95), {
                    ImageTransparency = 1
                }):Play();
            elseif descendant:IsA("Frame") and (descendant.Visible and descendant.BackgroundTransparency > 0) then
                TweenService:Create(descendant, TweenInfo.new(0.95), {
                    BackgroundTransparency = 1
                }):Play();
            end;
        end;

        task.delay(1, function() -- Line: 85
            -- upvalues: u7 (copy)
            u7:Destroy();
        end);
    end;
end;

task.spawn(function() -- Line: 96
    -- upvalues: ContentProvider (copy), Loader (copy)
    ContentProvider:PreloadAsync(Loader:GetDescendants());
end);
task.spawn(function() -- Line: 100
    -- upvalues: Janitor (copy), Frame (copy), Loader (copy), RunServiceController (copy), u3 (ref), u1 (ref), u2 (ref), u5 (ref), WaitForLoaded (copy), LocalPlayer (copy), u4 (ref), ProcessFinished (copy), ReplicatedStorage (copy), ContentProvider (copy)
    local u8 = Janitor.new();
    u8:Add(Frame);
    u8:Add(Loader);
    local u9 = tick();
    local u10 = tick();
    local u11 = 0;
    u8:Add((RunServiceController.BindToHeartbeat("ReplicatedFirst.Provider.LoadingScreen", function(p12) -- Line: 109
        -- upvalues: u3 (ref), u1 (ref), u2 (ref), u10 (ref), Loader (ref), u11 (ref), u9 (ref), u5 (ref)
        local v13 = 25;
        local v14 = tick();

        if u3 > 0 and u1 == "Loading Assets" then
            local v15 = math.min(u2, u3);
            local v16 = v14 - u10;
            Loader.LoadingScreen.Title.Text = `Loading Assets ({v15}/{u3})`;
            Loader.LoadingScreen.Title.TextTransparency = 1 - v15 / u3;
            Loader.LoadingScreen.Icon.ImageTransparency = 1 - v15 / u3;

            if v16 > 0 then
                v13 = math.min(25 + (u2 - u11) / v16 * 2, 95);
            end;

            u11 = u2;
            u10 = v14;
        else
            if v14 - u9 >= 0.35 then
                u5 = (u5 + 1) % 3;
                u9 = v14;
            end;

            Loader.LoadingScreen.Title.Text = "Loading Profile" .. string.rep(".", u5 + 1);
            Loader.LoadingScreen.Title.TextTransparency = 0;
        end;

        Loader.LoadingScreen.Extra.Progress.Rotation = Loader.LoadingScreen.Extra.Progress.Rotation + p12 * v13;
    end)));
    WaitForLoaded(function() -- Line: 144
        -- upvalues: LocalPlayer (ref)
        return LocalPlayer:GetAttribute("DataLoaded");
    end);
    task.delay(4, function() -- Line: 149
        -- upvalues: u4 (ref), ProcessFinished (ref), u8 (copy)
        if not u4 then
            ProcessFinished(u8);
        end;
    end);
    task.spawn(function() -- Line: 156
        -- upvalues: ReplicatedStorage (ref), u1 (ref), u3 (ref), ContentProvider (ref), u2 (ref)
        local v17 = ReplicatedStorage:WaitForChild("Assets"):GetDescendants();
        u1 = "Loading Assets";
        u3 = #v17;
        ContentProvider:PreloadAsync(v17, function() -- Line: 161
            -- upvalues: u2 (ref)
            u2 = u2 + 1;
        end);
    end);
end);