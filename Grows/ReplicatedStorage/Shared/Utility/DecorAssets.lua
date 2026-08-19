-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {
    getFolder = function() -- Line: 8, Name: getFolder
        -- upvalues: ReplicatedStorage (copy)
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            Assets = Assets:FindFirstChild("Greedy");
        end;

        if Assets then
            Assets = Assets:FindFirstChild("Decor");
        end;

        return Assets;
    end
};

function u1.resolveTemplate(p2, p3) -- Line: 16
    -- upvalues: u1 (copy)
    local v4 = u1.getFolder();

    if not (v4 and p3) then
        return nil;
    end;

    if p2 then
        p2 = v4:FindFirstChild(p2);
    end;

    if p2 then
        p2 = p2:FindFirstChild(p3);
    end;

    local v5 = p2 or v4:FindFirstChild(p3);

    if not (v5 and (v5:IsA("Model") and v5)) then
        v5 = nil;
    end;

    return v5;
end;

return u1;