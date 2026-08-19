-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Functions = require(Library.Functions);
local u1 = {};

return function(u2, u3, u4, u5, u6) -- Line: 6
    -- upvalues: u1 (copy), Functions (copy)
    if not u1[u2] then
        u1[u2] = true;
        task.spawn(function() -- Line: 9
            -- upvalues: u2 (copy), u3 (copy), u4 (ref), u5 (ref), u6 (ref), Functions (ref), u1 (ref)
            local Rotation = u2.Rotation;
            local v7 = Rotation + u3;
            local u8 = Rotation - u3;

            if u4 == nil then
                u4 = Enum.EasingStyle.Linear;
            end;

            if u5 == nil then
                u5 = 0.075;
            end;

            assert(u5);

            if u6 == nil then
                u6 = 1;
            end;

            assert(u6);

            for i = 1, u6 do
                Functions.Tween(u2, {
                    Rotation = v7
                }, { u5, u4, "Out" }).Completed:Connect(function() -- Line: 26
                    -- upvalues: Functions (ref), u2 (ref), Rotation (copy), u5 (ref), u4 (ref), u8 (copy), i (copy), u6 (ref), u1 (ref)
                    Functions.Tween(u2, {
                        Rotation = Rotation
                    }, { u5, u4, "Out" }).Completed:Connect(function() -- Line: 28
                        -- upvalues: Functions (ref), u2 (ref), u8 (ref), u5 (ref), u4 (ref), Rotation (ref), i (ref), u6 (ref), u1 (ref)
                        Functions.Tween(u2, {
                            Rotation = u8
                        }, { u5, u4, "Out" }).Completed:Connect(function() -- Line: 34
                            -- upvalues: Functions (ref), u2 (ref), Rotation (ref), u5 (ref), u4 (ref), i (ref), u6 (ref), u1 (ref)
                            Functions.Tween(u2, {
                                Rotation = Rotation
                            }, { u5, u4, "Out" }).Completed:Connect(function() -- Line: 40
                                -- upvalues: i (ref), u6 (ref), u1 (ref), u2 (ref)
                                if i == u6 then
                                    u1[u2] = nil;

                                    return true;
                                end;
                            end);
                        end);
                    end);
                end);
                task.wait(u5 * 4);
            end;
        end);
    end;
end;