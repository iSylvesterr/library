-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
game:GetService("ServerScriptService");
local u1 = { "RecoveryEvent", "DemonicEvent", "Countdown", "DragonEggEvent" };

return function(p2) -- Line: 11
    -- upvalues: u1 (copy)
    p2:RegisterType("adminEventType", p2.Cmdr.Util.MakeEnumType("AdminEventType", u1));
end;