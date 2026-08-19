-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local UIMgr = UtilsSystem.UIMgr;
local v1 = {};
local Talk = UtilsSystem.LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Talk");

function v1.updateUi(p2, p3) -- Line: 34
end;

function v1.openUi(p4) -- Line: 41
    -- upvalues: Talk (copy), UIMgr (copy)
    Talk.Visible = true;
    UIMgr.SetMainUIVisible(false);
end;

function v1.closeUi(p5) -- Line: 50
    -- upvalues: Talk (copy), UIMgr (copy)
    Talk.Visible = false;
    UIMgr.SetMainUIVisible(true);
end;

return v1;