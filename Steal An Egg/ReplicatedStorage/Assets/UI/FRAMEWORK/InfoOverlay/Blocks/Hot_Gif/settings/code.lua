-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GIF = require(ReplicatedStorage.Library.Client.GUIFX.GIF);

function Initialize(p1, p2)
    -- upvalues: GIF (copy)
    local v3 = GIF(p1.GIFHolder.GIF, 1.75);
    p1.Destroying:Connect(v3);
end;

return Initialize;