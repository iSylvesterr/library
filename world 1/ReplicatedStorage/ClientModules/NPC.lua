-- Decompiled with Potassium's decompiler.

local v1 = {};
local ClientModules = game:GetService("ReplicatedStorage"):WaitForChild("ClientModules");
local FieldOfViewController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.FieldOfViewController);
local FramePopup = require(ClientModules.FramePopup);
local u2 = false;

function v1.CanSpeak() -- Line: 12
    -- upvalues: u2 (ref)
    return not u2;
end;

function v1.StartSpeaking() -- Line: 16
    -- upvalues: u2 (ref), FieldOfViewController (copy)
    u2 = true;
    FieldOfViewController:SetAdjuster(-5);
end;

function v1.EndSpeaking() -- Line: 21
    -- upvalues: u2 (ref), FramePopup (copy), FieldOfViewController (copy)
    u2 = false;

    if FramePopup.CanInteract() then
        FieldOfViewController:ClearAdjuster();
    end;
end;

return v1;