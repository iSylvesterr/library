-- Decompiled with Potassium's decompiler.

local Functions = require(game:GetService("ReplicatedStorage").Library.Functions);

function AttachTimer(u1, p2, u3, u4)
    -- upvalues: Functions (copy)
    task.spawn(function() -- Line: 4
        -- upvalues: u1 (copy), u3 (copy), u4 (copy), Functions (ref)
        while not u1.Parent do
            task.wait();
        end;

        while u1.Parent do
            local v5 = u3();
            local v6 = math.max(v5, 0);

            if u4 then
                u1.timer.Text = `{Functions.Commas(v6)}x`;
            elseif v6 >= 86400 then
                u1.timer.Text = Functions.TimeString(v6);
            else
                u1.timer.Text = os.date("!%X", v6);
            end;

            task.wait(0.1);
        end;
    end);
end;

return AttachTimer;