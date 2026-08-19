-- Decompiled with Potassium's decompiler.

return function(u1, p2, u3) -- Line: 1, Name: UpdateTitle
    u1.title.Text = u3();
    task.spawn(function() -- Line: 4
        -- upvalues: u1 (copy), u3 (copy)
        while not u1.Parent do
            task.wait();
        end;

        while u1.Parent do
            u1.title.Text = u3();
            task.wait(0.1);
        end;
    end);
end;