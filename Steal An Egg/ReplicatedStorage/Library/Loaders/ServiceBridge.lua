-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Private = script.Private;
local ServiceToBatchMethod = require(Private.ServiceToBatchMethod);
local TypeInterfaces = require(Private.TypeInterfaces);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local v2 = {};
v2.__index = v2;

function v2.Hook(u3, u4) -- Line: 22
    -- upvalues: TypeInterfaces (copy), u1 (copy), ServiceToBatchMethod (copy)
    assert(TypeInterfaces(u3, u4));
    local u5;

    if typeof(u3._script) == "Instance" then
        u5 = u3._script;
    else
        u5 = false;
    end;

    local function Compile(p6, ...) -- Line: 27
        -- upvalues: u3 (copy)
        if typeof(p6) ~= "table" then
            return;
        end;

        for _, v in p6 do
            local v7 = { v:gsub("__sync_service", "") };
            local v8 = u3[v7[1]];
            local v9 = { v8, u3, ... };

            if v7[2] == 0 then
                table.remove(v9, 2);
            end;

            if typeof(v8) == "function" then
                task.spawn(unpack(v9));
            end;
        end;
    end;

    return function(...) -- Line: 48
        -- upvalues: u5 (copy), u1 (ref), u3 (copy), u4 (copy), ServiceToBatchMethod (ref), Compile (copy)
        if u5 then
            if u5:GetAttribute("__services_locked") then
                return "__locked";
            end;

            u5:SetAttribute("__services_locked", true);
        else
            u1:AtWarning():Log("Instance not found during services initialization. (could cause duplication):", u3, "(Compiler):", u4);
        end;

        if typeof(u3.__intercept_services) == "function" then
            u3:__intercept_services(...);
        end;

        for i, v in u4 do
            local v10;

            if typeof(i) == "string" then
                v10 = game:GetService(i);
            else
                v10 = false;
            end;

            if v10 and typeof(v) == "table" then
                local v11 = ServiceToBatchMethod[i];

                if typeof(v.__deploy) == "table" and v11 then
                    for _, v3 in v10[v11](v10) do
                        Compile(v.__deploy, v3);
                    end;
                end;

                for i2, v3 in v do
                    local v12 = not i2:match("__") and v10[i2];

                    if v12 then
                        v12:Connect(function(...) -- Line: 86
                            -- upvalues: Compile (ref), v3 (copy)
                            Compile(v3, ...);
                        end);
                    end;
                end;
            end;
        end;
    end;
end;

return v2;