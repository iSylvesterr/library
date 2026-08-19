-- Decompiled with Potassium's decompiler.

return {
    Create = function(u1, p2, p3, p4, p5, p6) -- Line: 9, Name: Create
        local u7, u8 = unpack(p2);
        local u9, u10 = unpack(p3);
        local Image = u1.Image;
        local u11 = false;
        local u12 = p4 or u9 * u10;
        local u13 = 0.016666666666666666 / (p5 or 1);
        local u14 = p6 == nil and true or p6;
        coroutine.wrap(function() -- Line: 26
            -- upvalues: u1 (copy), u7 (copy), u8 (copy), u10 (copy), u9 (copy), u11 (ref), Image (copy), u12 (copy), u13 (copy), u14 (copy)
            u1.ImageRectSize = Vector2.new(u7, u8);

            while true do
                local v15 = 0;

                for i = 0, u10 - 1 do
                    for i2 = 0, u9 - 1 do
                        if u11 or (u1.Parent == nil or u1.Image ~= Image) then
                            return;
                        end;

                        if u12 <= v15 then
                            break;
                        end;

                        v15 = v15 + 1;
                        u1.ImageRectOffset = Vector2.new(i2 * u7, i * u8);
                        task.wait(u13);
                    end;
                end;

                if not u14 then
                    return;
                end;
            end;
        end)();

        return function() -- Line: 49
            -- upvalues: u11 (ref)
            u11 = true;
        end;
    end
};