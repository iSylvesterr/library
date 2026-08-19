-- Decompiled with Potassium's decompiler.

local v1 = require;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
v1(script:WaitForChild("Signal"));
local HitboxClassRemote = ReplicatedStorage:WaitForChild("HitboxClassRemote");
local u2 = v1(script["HitboxClass Module"].Value);
local u3 = {};
HitboxClassRemote.OnClientEvent:Connect(function(p4, p5) -- Line: 11
    -- upvalues: u3 (copy), u2 (copy), HitboxClassRemote (copy)
    if p4 == "Clr" then
        for i, v in pairs(u3) do
            v:Destroy();
            u3[i] = nil;
        end;

        return;
    end;

    if p4 ~= "New" and not u3[p5._Tick] then
        warn("No hitbox found on the client for tick value sent. Don\'t change the tick value manually, change the ID instead. (HitboxClass)");

        return;
    end;

    if p4 == "New" then
        local v6 = u2.new(p5);
        u3[p5._Tick] = v6;
        HitboxClassRemote:FireServer(p5._Tick);
    end;

    if p4 == "Start" then
        u3[p5._Tick]:Start();
    end;

    if p4 == "Stop" then
        u3[p5._Tick]:Stop();
    end;

    if p4 == "ClrTag" then
        u3[p5._Tick]:ClearTaggedChars();
    end;

    if p4 == "Weld" then
        u3[p5._Tick]:WeldTo(p5.WeldTo, p5.Offset);
    end;

    if p4 == "WeldOfs" then
        u3[p5._Tick]:ChangeWeldOffset(p5.Offset);
    end;

    if p4 == "Unweld" then
        u3[p5._Tick]:Unweld();
    end;

    if p4 == "PosCh" then
        u3[p5._Tick]:SetPosition(p5.Position);
    end;

    if p4 == "Dbg" then
        u3[p5._Tick]:SetDebug(p5.Debug);
    end;

    if p4 == "Des" then
        u3[p5._Tick]:Destroy();
        u3[p5._Tick] = nil;
    end;
end);