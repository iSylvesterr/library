-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);
local PoseController = require(script.PoseController);
local Connections = require(script.Connections);
local v1 = {};
local u2 = {
    __index = v1
};

function v1.Destroy(p3) -- Line: 9
    p3.PoseController:Destroy();
    p3.Connections:Destroy();
    setmetatable(p3, nil);
    table.clear(p3);
end;

return {
    new = function(p4, p5, p6) -- Line: 23, Name: new
        -- upvalues: PoseController (copy), Connections (copy), u2 (copy)
        local v7 = p4:FindFirstChildWhichIsA("Animator", true);

        if not v7 then
            error((`Animator not found for rig {p4}`));
        end;

        local v8 = PoseController.new(p4, p5);
        local v9 = {
            _animator = v7,
            _rig = p4,
            PoseController = v8,
            Connections = Connections.new(v8, p4, p6)
        };

        return setmetatable(v9, u2);
    end
};