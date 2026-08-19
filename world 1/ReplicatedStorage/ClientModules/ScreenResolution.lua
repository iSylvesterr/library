-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local Signal = require(script.Parent.Signal);
local CurrentCamera = Workspace.CurrentCamera;
local ViewportSize = CurrentCamera.ViewportSize;
local u1 = math.clamp(ViewportSize.Y / 1080, 0.33, 2);
local u2 = ViewportSize;
local u3 = 0;
local u4 = {
    Changed = Signal.new(),

    GetViewportSize = function() -- Line: 27, Name: GetViewportSize
        -- upvalues: ViewportSize (ref)
        return ViewportSize;
    end,

    GetResolutionScale = function() -- Line: 31, Name: GetResolutionScale
        -- upvalues: u1 (ref)
        return u1;
    end
};

function u4.Observe(u5) -- Line: 35
    -- upvalues: u4 (copy)
    local u6 = u4.Changed:Connect(function() -- Line: 36
        -- upvalues: u5 (copy)
        task.spawn(u5);
    end);
    task.spawn(u5);

    return function() -- Line: 42
        -- upvalues: u6 (copy)
        u6:Disconnect();
    end;
end;

CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 48
    -- upvalues: ViewportSize (ref), CurrentCamera (copy), u1 (ref)
    ViewportSize = CurrentCamera.ViewportSize;
    u1 = math.clamp(ViewportSize.Y / 1080, 0.33, 2);
end);
RunService.RenderStepped:Connect(function() -- Line: 53
    -- upvalues: ViewportSize (ref), u2 (ref), u3 (ref), u4 (copy)
    if ViewportSize ~= u2 and os.clock() - u3 >= 0.15 then
        u3 = os.clock();
        u2 = ViewportSize;
        u4.Changed:Fire();
    end;
end);

return table.freeze(u4);