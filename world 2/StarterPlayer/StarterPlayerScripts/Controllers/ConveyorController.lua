-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local u2 = {};

function v1.Init(p3) -- Line: 9
end;

function v1.Start(u4) -- Line: 12
    -- upvalues: u2 (copy), RunService (copy)
    for _, descendant in workspace:GetDescendants() do
        if descendant:IsA("BasePart") and descendant:GetAttribute("VELOCITY") ~= nil then
            u4:RegisterConveyor(descendant);
        end;
    end;

    workspace.DescendantAdded:Connect(function(p5) -- Line: 21
        -- upvalues: u4 (copy)
        if p5:IsA("BasePart") and p5:GetAttribute("VELOCITY") ~= nil then
            u4:RegisterConveyor(p5);
        end;
    end);
    workspace.DescendantRemoving:Connect(function(p6) -- Line: 27
        -- upvalues: u2 (ref)
        u2[p6] = nil;
    end);
    RunService.Heartbeat:Connect(function() -- Line: 32
        -- upvalues: u2 (ref)
        debug.profilebegin("Controllers/ConveyorController/Heartbeat");

        for i, _ in u2 do
            local v7 = i:GetAttribute("VELOCITY");

            if type(v7) == "number" then
                i.AssemblyLinearVelocity = i.CFrame.LookVector * v7;
            end;
        end;

        debug.profileend();
    end);
end;

function v1.RegisterConveyor(p8, u9) -- Line: 48
    -- upvalues: u2 (copy)
    u2[u9] = true;
    u9:GetAttributeChangedSignal("VELOCITY"):Connect(function() -- Line: 52
        -- upvalues: u9 (copy), u2 (ref)
        if u9:GetAttribute("VELOCITY") == nil then
            u2[u9] = nil;

            return;
        end;

        u2[u9] = true;
    end);
end;

return v1;