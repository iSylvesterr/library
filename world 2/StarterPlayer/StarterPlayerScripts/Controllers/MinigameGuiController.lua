-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 10
};
local LocalPlayer = game:GetService("Players").LocalPlayer;
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local u2 = {};

local function ReadRequestedGuis() -- Line: 32
    -- upvalues: LocalPlayer (copy)
    local v3 = {};
    local v4 = LocalPlayer:GetAttribute("MinigameHiddenGuis");

    if type(v4) ~= "string" then
        return v3;
    end;

    for i in string.gmatch(v4, "[^,]+") do
        v3[i] = true;
    end;

    return v3;
end;

local function Refresh() -- Line: 47
    -- upvalues: ReadRequestedGuis (copy), u2 (copy), GuiController (copy)
    local v5 = ReadRequestedGuis();

    for i in u2 do
        if not v5[i] then
            GuiController:SetGuiForceHidden(i, false);
            u2[i] = nil;
        end;
    end;

    for i in v5 do
        if not u2[i] then
            GuiController:SetGuiForceHidden(i, true);
            u2[i] = true;
        end;
    end;
end;

function v1.Start(p6) -- Line: 65
    -- upvalues: LocalPlayer (copy), Refresh (copy)
    LocalPlayer:GetAttributeChangedSignal("MinigameHiddenGuis"):Connect(Refresh);
    Refresh();
end;

return v1;