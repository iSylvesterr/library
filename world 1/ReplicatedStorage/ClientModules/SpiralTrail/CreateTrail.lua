-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3, p4) -- Line: 1
    local Attachment = Instance.new("Attachment");
    Attachment.Position = Vector3.new(0, p2, 0);
    Attachment.Parent = p1;
    local Attachment2 = Instance.new("Attachment");
    Attachment2.Position = Vector3.new(0, -p2, 0);
    Attachment2.Parent = p1;
    local Trail = Instance.new("Trail");
    Trail.FaceCamera = true;
    Trail.LightInfluence = 0;
    Trail.LightEmission = 1;
    Trail.Lifetime = 0.55;
    Trail.Attachment0 = Attachment;
    Trail.Attachment1 = Attachment2;
    Trail.Brightness = 2;
    Trail.Color = ColorSequence.new(p3 or Color3.fromRGB(255, 220, 24));
    Trail.WidthScale = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 1), NumberSequenceKeypoint.new(1, 0) });
    Trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.1, 0),
        NumberSequenceKeypoint.new(0.9, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    Trail.Parent = p1;

    return Trail;
end;