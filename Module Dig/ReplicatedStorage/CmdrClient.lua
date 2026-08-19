-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Shared = script:WaitForChild("Shared");
local Util = require(Shared:WaitForChild("Util"));

if RunService:IsClient() == false then
    error("Server scripts cannot require the client library. Please require the server library to use Cmdr in your own code.");
end;

local v1 = {
    Enabled = true,
    MashToEnable = false,
    ActivationUnlocksMouse = false,
    HideOnLostFocus = true,
    PlaceName = "Cmdr",
    ReplicatedRoot = script,
    RemoteFunction = script:WaitForChild("CmdrFunction"),
    RemoteEvent = script:WaitForChild("CmdrEvent"),
    ActivationKeys = {
        [Enum.KeyCode.F2] = true
    },
    Util = Util,
    Events = {}
};
local u6 = setmetatable(v1, {
    __index = function(u2, p3) -- Line: 28, Name: __index
        local u4 = u2.Dispatcher[p3];

        if u4 and type(u4) == "function" then
            return function(p5, ...) -- Line: 31
                -- upvalues: u4 (copy), u2 (copy)
                return u4(u2.Dispatcher, ...);
            end;
        end;
    end
});
u6.Registry = require(Shared.Registry)(u6);
u6.Dispatcher = require(Shared.Dispatcher)(u6);

if StarterGui:WaitForChild("Cmdr") and (wait() and LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Cmdr") == nil) then
    StarterGui.Cmdr:Clone().Parent = LocalPlayer.PlayerGui;
end;

local u7 = require(script.CmdrInterface)(u6);

function u6.SetActivationKeys(p8, p9) -- Line: 49
    -- upvalues: Util (copy)
    p8.ActivationKeys = Util.MakeDictionary(p9);
end;

function u6.SetPlaceName(p10, p11) -- Line: 54
    -- upvalues: u7 (copy)
    p10.PlaceName = p11;
    u7.Window:UpdateLabel();
end;

function u6.SetEnabled(p12, p13) -- Line: 60
    p12.Enabled = p13;
end;

function u6.SetActivationUnlocksMouse(p14, p15) -- Line: 65
    p14.ActivationUnlocksMouse = p15;
end;

function u6.Show(p16) -- Line: 70
    -- upvalues: u7 (copy)
    if not p16.Enabled then
        return;
    end;

    u7.Window:Show();
end;

function u6.Hide(p17) -- Line: 79
    -- upvalues: u7 (copy)
    u7.Window:Hide();
end;

function u6.Toggle(p18) -- Line: 84
    -- upvalues: u7 (copy)
    if not p18.Enabled then
        return p18:Hide();
    end;

    u7.Window:SetVisible(not u7.Window:IsVisible());
end;

function u6.SetMashToEnable(p19, p20) -- Line: 93
    p19.MashToEnable = p20;

    if p20 then
        p19:SetEnabled(false);
    end;
end;

function u6.SetHideOnLostFocus(p21, p22) -- Line: 102
    p21.HideOnLostFocus = p22;
end;

function u6.HandleEvent(p23, p24, p25) -- Line: 107
    p23.Events[p24] = p25;
end;

if RunService:IsServer() == false then
    u6.Registry:RegisterTypesIn(script:WaitForChild("Types"));
    u6.Registry:RegisterCommandsIn(script:WaitForChild("Commands"));
end;

u6.RemoteEvent.OnClientEvent:Connect(function(p26, ...) -- Line: 118
    -- upvalues: u6 (ref)
    if u6.Events[p26] then
        u6.Events[p26](...);
    end;
end);
require(script.DefaultEventHandlers)(u6);

return u6;