-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 20, Name: PlaySFX
    local Attachment = Instance.new("Attachment");
    Attachment.CFrame = p1.CFrame:ToObjectSpace(p2);
    p3.Parent = Attachment;
    Attachment.Parent = p1;
    p3.Ended:Connect(function() -- Line: 25
        -- upvalues: Attachment (copy)
        Attachment:Destroy();
    end);
    p3:Play();
end;