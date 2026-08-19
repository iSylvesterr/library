-- Decompiled with Potassium's decompiler.

require(script.Parent.Types.Interface);

return {
    BindOnAdapterChanged = function(u1, u2, u3) -- Line: 16, Name: BindOnAdapterChanged
        local u4 = u1.Changed:Connect(function() -- Line: 21
            -- upvalues: u2 (copy), u1 (copy), u3 (copy)
            if u2(u1) then
                u3();
            end;
        end);
        task.defer(function() -- Line: 27
            -- upvalues: u2 (copy), u1 (copy), u3 (copy)
            if u2(u1) then
                u3();
            end;
        end);

        return function() -- Line: 33
            -- upvalues: u4 (copy)
            u4:Disconnect();
        end;
    end
};