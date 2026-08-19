-- Decompiled with Potassium's decompiler.

game:GetService("RunService");
require(script.HeadLock);
script.Parent.Parent.AncestryChanged:Connect(function(p1, p2) -- Line: 26
    if p2 ~= nil then
        return;
    end;

    _renderConn:Disconnect();
    _headLock:destroy();
end);