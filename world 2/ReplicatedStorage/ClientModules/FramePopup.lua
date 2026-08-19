-- Decompiled with Potassium's decompiler.

local v1 = {};
local ClientModules = game:GetService("ReplicatedStorage"):WaitForChild("ClientModules");
local FieldOfViewController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.FieldOfViewController);
local Blur = require(ClientModules.Blur);
local u2 = {};

function v1.Show(p3) -- Line: 12
    -- upvalues: u2 (copy), FieldOfViewController (copy), Blur (copy)
    if not table.find(u2, p3) then
        table.insert(u2, p3);
    end;

    FieldOfViewController.SetFov(60, 0.3);
    Blur.SetBlur(15, 0.1);
end;

function v1.Hide(p4) -- Line: 21
    -- upvalues: u2 (copy), FieldOfViewController (copy), Blur (copy)
    local v5 = table.find(u2, p4);

    if v5 then
        table.remove(u2, v5);
    end;

    if #u2 == 0 then
        FieldOfViewController.SetCoreFov(70);
        FieldOfViewController.SetFov(70, 0.3);
        Blur.SetBlur(0, 0.3);
    end;
end;

function v1.CanInteract() -- Line: 34
    -- upvalues: u2 (copy)
    return #u2 == 0;
end;

return v1;