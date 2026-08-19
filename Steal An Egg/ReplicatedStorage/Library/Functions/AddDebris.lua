-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Modules = ReplicatedStorage:WaitForChild("Library"):WaitForChild("Modules");
local u3 = require(Modules.LeftistHeap).new(function(p1, p2) -- Line: 6
    return p1 - p2;
end);
local u4 = {};
local u5 = 0;
RunService.Stepped:Connect(function(p6, p7) -- Line: 13, Name: onStepped
    -- upvalues: u5 (ref), u3 (copy), u4 (copy), Debris (copy)
    u5 = u5 + p7;

    while true do
        local v8, v9 = u3.tryMin();

        if not v8 or u5 < v9 then
            break;
        end;

        u3.popFast();
        local v10 = u4[v9];

        if v10 then
            u4[v9] = nil;

            for _, v in ipairs(v10) do
                if v then
                    pcall(function() -- Line: 29
                        -- upvalues: Debris (ref), v (copy)
                        Debris:AddItem(v, 0);
                    end);
                end;
            end;
        end;
    end;
end);

return function(u11, p12) -- Line: 40, Name: AddDebris
    -- upvalues: u5 (ref), u4 (copy), u3 (copy)
    local v13 = typeof(u11) == "Instance";
    assert(v13, "Instance must be an instance");
    local v14;

    if p12 == nil then
        v14 = 0;
    else
        local v15 = type(p12) == "number";
        assert(v15, "Lifetime must be a number");
        assert(p12 == p12, "Lifetime cannot be NaN");
        v14 = math.max(0, p12);

        if v14 == (1 / 0) then
            return function() -- Line: 52
            end;
        end;
    end;

    local u16 = u5 + v14;
    local v17 = u4[u16];

    if v17 then
        table.insert(v17, u11);
    else
        u4[u16] = { u11 };
        u3.insert(u16);
    end;

    local u18 = false;

    return function() -- Line: 67
        -- upvalues: u18 (ref), u4 (ref), u16 (copy), u11 (copy)
        if u18 then
            return;
        end;

        u18 = true;
        local v19 = u4[u16];

        if v19 then
            for i = #v19, 1, -1 do
                if v19[i] == u11 then
                    table.remove(v19, i);
                    break;
                end;
            end;

            if #v19 == 0 then
                u4[u16] = nil;
            end;
        end;
    end;
end;