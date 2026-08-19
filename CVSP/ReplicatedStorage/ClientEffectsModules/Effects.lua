-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
local u1 = {};
local v2 = {};

for _, child in ipairs(script:GetChildren()) do
    if child:IsA("ModuleScript") then
        local success, result = pcall(require, child);

        if success and typeof(result) == "table" then
            u1[child.Name] = result;
        else
            warn("Failed to load effect module:", child.Name, result);
        end;
    end;
end;

function v2.Play(p3, p4) -- Line: 21
    -- upvalues: u1 (copy)
    local v5 = u1[p3];

    if v5 then
        v5.Play(p4);

        return;
    end;

    warn("Unknown effect:", p3);
end;

return v2;