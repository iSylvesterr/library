-- Decompiled with Potassium's decompiler.

return {
    parse = function(p1) -- Line: 17, Name: parse
        local u2 = string.split(p1, ".");

        if p1 == "" or #u2 ~= 3 then
            return nil;
        end;

        local success, result = pcall(function() -- Line: 24
            -- upvalues: u2 (copy)
            if u2[2] == "KeyCode" then
                return Enum.KeyCode[u2[3]];
            end;

            if u2[2] == "UserInputType" then
                return Enum.UserInputType[u2[3]];
            end;

            if u2[2] == "CustomInputType" and (u2[3] == "ScrollWheelUp" or u2[3] == "ScrollWheelDown") then
                return u2[3];
            end;

            return nil;
        end);

        return success and result and result or nil;
    end
};