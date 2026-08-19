-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u1 = t.optional(t.union(t.CFrame, t.Vector3));

return function(p2, p3) -- Line: 8, Name: CreateParticleHost
    -- upvalues: u1 (copy), Asserts (copy)
    assert(u1(p2));
    Asserts.optional.BasePart(p3);
    local Attachment = Instance.new("Attachment");

    if p3 then
        Attachment.Parent = p3;

        return p3, Attachment;
    end;

    if typeof(p2) ~= "CFrame" then
        p2 = CFrame.new(p2);
    end;

    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    Part.CastShadow = false;
    Part.Size = Vector3.new(0, 0, 0);
    Part.CFrame = p2;
    Part.Name = "host";
    Attachment.Parent = Part;
    Part.Parent = workspace:WaitForChild("__DEBRIS");

    return Part, Attachment;
end;