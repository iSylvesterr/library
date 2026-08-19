-- Decompiled with Potassium's decompiler.

return {
    AutoSizeText = {
        bind = function(u1, u2, p3) -- Line: 19, Name: bind
            local u4 = p3 == nil and 1 or p3;

            if not u2 then
                if u1.Parent and u1.Parent:IsA("GuiObject") then
                    u2 = u1.Parent;
                else
                    u2 = nil;
                end;
            end;

            u1.TextScaled = false;
            u1.AutomaticSize = Enum.AutomaticSize.X;
            u1.Size = UDim2.new(UDim.new(0, 0), u1.Size.Y);

            local function v8() -- Line: 31
                -- upvalues: u2 (copy), u1 (copy), u4 (ref)
                local v5;

                if u2 then
                    v5 = u2.AbsoluteSize.Y;
                else
                    v5 = u1.AbsoluteSize.Y;
                end;

                if v5 <= 0 then
                    return nil;
                end;

                local v6 = math.floor(v5 * u4);
                local v7 = math.clamp(v6, 8, 100);

                if u1.TextSize ~= v7 then
                    u1.TextSize = v7;
                end;
            end;

            local v9;

            if u2 then
                v9 = u2.AbsoluteSize.Y;
            else
                v9 = u1.AbsoluteSize.Y;
            end;

            if v9 > 0 then
                local v10 = math.floor(v9 * u4);
                local v11 = math.clamp(v10, 8, 100);

                if u1.TextSize ~= v11 then
                    u1.TextSize = v11;
                end;
            end;

            local u12 = {};

            if u2 then
                local v13 = u2:GetPropertyChangedSignal("AbsoluteSize"):Connect(v8);
                table.insert(u12, v13);
            else
                local v14 = u1:GetPropertyChangedSignal("AbsoluteSize"):Connect(v8);
                table.insert(u12, v14);
            end;

            return function() -- Line: 50
                -- upvalues: u12 (copy)
                for _, v in u12 do
                    v:Disconnect();
                end;
            end;
        end
    }
};