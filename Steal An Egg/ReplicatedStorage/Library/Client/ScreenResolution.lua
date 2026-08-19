-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local Functions = Library:WaitForChild("Functions");
local Event = require(Modules.Event);
local ResolutionScale = require(Functions.ResolutionScale);
local BindToRenderStep = require(ReplicatedStorage.Library.Functions.BindToRenderStep);
local CurrentCamera = workspace.CurrentCamera;
local ViewportSize = CurrentCamera.ViewportSize;
local u1 = ResolutionScale(ViewportSize);
local u2 = ViewportSize;
local u3 = u1;
local u4 = 0;
local u5 = {
    Changed = Event.new(),

    GetViewportSize = function() -- Line: 20, Name: GetViewportSize
        -- upvalues: u2 (ref)
        return u2;
    end,

    GetScale = function() -- Line: 25, Name: GetScale
        -- upvalues: u3 (ref)
        return u3;
    end
};
CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 30
    -- upvalues: ViewportSize (ref), CurrentCamera (copy), u1 (ref), ResolutionScale (copy), u4 (ref)
    ViewportSize = CurrentCamera.ViewportSize;
    u1 = ResolutionScale(ViewportSize);
    u4 = 0.15;
end);
BindToRenderStep("ScreenResolution", Enum.RenderPriority.First.Value, function(p6) -- Line: 36
    -- upvalues: ViewportSize (ref), u2 (ref), u4 (ref), u3 (ref), u1 (ref), u5 (copy)
    local v7 = ViewportSize;

    if u2 ~= v7 then
        if u4 <= 0 then
            u2 = v7;
            u3 = u1;
            u5.Changed:FireAsync(v7, u1);
        end;

        u4 = u4 - p6;
    end;
end);

return u5;