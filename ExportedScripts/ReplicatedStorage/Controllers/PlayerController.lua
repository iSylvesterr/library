-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local u2 = tick();
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);

local function HandleNextFrame(p3) -- Line: 25
    -- upvalues: Remotes (copy), u2 (ref)
    debug.profilebegin("PlayerController.HandleNextFrame");
    local v4 = tick();
    Remotes.Player.BlankRequest.Send(v4);

    if v4 - u2 < 900 then
        debug.profileend();

        return;
    end;

    Remotes.Player.AFKTeleport.Send();
    u2 = v4;
    debug.profileend();
end;

function v1.Initialize() -- Line: 42
    -- upvalues: UserInputService (copy), u2 (ref), Remotes (copy)
    UserInputService.InputBegan:Connect(function() -- Line: 44
        -- upvalues: u2 (ref)
        u2 = tick();
    end);
    UserInputService.InputChanged:Connect(function() -- Line: 50
        -- upvalues: u2 (ref)
        u2 = tick();
    end);
    Remotes.Player.BlankRequest.Listen(function(p5) -- Line: 56
        -- upvalues: Remotes (ref)
        local Send = Remotes.Player.ReportPlayerConnect.Send;
        local v6 = (tick() - p5) * 1000;
        local v7 = math.floor(v6);
        Send((tostring(v7)));
    end);
end;

function v1.Start() -- Line: 62
    -- upvalues: GetUserPlatform (copy), Remotes (copy), RunServiceController (copy), HandleNextFrame (copy)
    local u8 = 0;
    task.delay(5, function() -- Line: 65
        -- upvalues: GetUserPlatform (ref), Remotes (ref)
        local v9 = GetUserPlatform();

        if not v9 or #v9 <= 0 then
            return;
        end;

        Remotes.Player.SubmitUserPlatformAnalytics.Send(v9[1]);
    end);
    RunServiceController.BindToHeartbeat("PlayerController.ReportPlayerState", function(p10) -- Line: 75
        -- upvalues: u8 (ref), HandleNextFrame (ref)
        u8 = u8 + p10;

        if u8 >= 5 then
            u8 = u8 - 5;
            HandleNextFrame(p10);
        end;
    end);
end;

return v1;