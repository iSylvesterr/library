-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Signal = require(script.Parent.Signal);
require(script.Types);
local u1 = {
    Interface = {}
};
u1.Interface.Camera = require(script.Camera);
u1.Interface.CameraActivated = Signal.new();
u1.Interface.CameraDeactivated = Signal.new();

function u1.Interface.GetActiveCamera(p2) -- Line: 31
    -- upvalues: u1 (copy)
    return u1.Active and u1.Active.Name;
end;

function u1.Interface.SetActiveCamera(p3, p4) -- Line: 48
    -- upvalues: u1 (copy)
    local v5 = u1.Interface.Camera.get(p4);
    local CurrentCamera = workspace.CurrentCamera;
    local v6 = `Failed to call ':GetActiveCamera' for the {p4} camera!`;
    assert(v5, v6);

    if u1.Active and u1.Active.Name == p4 then
        return;
    end;

    if u1.Active then
        u1.Interface.CameraDeactivated:Fire(u1.Active.Name);
        u1.Active:InvokeLifecycleMethod("OnDeactivated", CurrentCamera);
    end;

    u1.Active = v5;
    v5.Instance.Parent = workspace;
    workspace.CurrentCamera = v5.Instance;
    CurrentCamera.Parent = nil;
    u1.Interface.CameraActivated:Fire(v5.Name);
    v5:InvokeLifecycleMethod("OnActivated", v5.Instance);
end;

function u1.Init(p7) -- Line: 74
    -- upvalues: RunService (copy), u1 (copy)
    RunService.RenderStepped:Connect(function(p8) -- Line: 75
        -- upvalues: u1 (ref)
        if not u1.Active then
            return;
        end;

        u1.Active:InvokeLifecycleMethod("OnRenderStepped", p8);
    end);

    return u1.Interface;
end;

return u1:Init();