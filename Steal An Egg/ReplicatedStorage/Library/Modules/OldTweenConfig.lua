-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local InstanceCheck = require(ReplicatedStorage.Library.Functions.InstanceCheck);
local new = TweenInfo.new;

function u1.CleanUp(u2, u3) -- Line: 13
    -- upvalues: InstanceCheck (copy), Debris (copy)
    if not InstanceCheck(u2, "Tween") then
        return warn("Invalid Tween provided to World_Animator.CleanUp:", u2);
    end;

    local u4 = nil;
    u4 = u2.Completed:Connect(function() -- Line: 19
        -- upvalues: u3 (copy), u4 (ref), u2 (copy), Debris (ref)
        if typeof(u3) == "function" then
            u3();
        end;

        u4 = nil;

        if u2 then
            Debris:AddItem(u2, 0);
        end;
    end);

    return u2, u4;
end;

function u1.Build_Spectrum(p5) -- Line: 34
    -- upvalues: InstanceCheck (copy)
    if type(p5) ~= "table" then
        return warn("Invalid target_Data provided to World_Animator.Build_Spectrum:", p5);
    end;

    local Configuration = Instance.new("Configuration");

    if InstanceCheck(Configuration, "Configuration") then
        for i, v in p5 do
            if i:match("__") then
                Configuration.Name = "Configuration_" .. v;
            else
                local StringValue = Instance.new("StringValue");
                StringValue.Parent = Configuration;
                StringValue.Name = i;

                for i2, v2 in v do
                    StringValue:SetAttribute(i2, v2);
                end;
            end;
        end;

        return Configuration;
    end;
end;

function u1.Extract_Configured_TI(p6) -- Line: 62
    -- upvalues: InstanceCheck (copy), new (copy)
    local v7 = InstanceCheck(p6, "Configuration") and p6:FindFirstChild("TweenInfo");
    local v8 = InstanceCheck(v7, "StringValue") and v7:GetAttributes();

    if typeof(v8) == "table" then
        local v9 = {};

        for i, v in v8 do
            if not i:match("__") then
                local v10 = tonumber(i:sub(-1));

                if typeof(v) == "string" then
                    local v = Enum[i:split("_")[1]][v] or v;
                end;

                v9[v10] = v;
            end;
        end;

        return new(unpack(v9));
    end;
end;

function u1.Bulk(u11, p12, u13) -- Line: 81
    -- upvalues: InstanceCheck (copy), u1 (copy), TweenService (copy)
    if typeof(u11) ~= "table" or typeof(p12) ~= "string" and typeof(p12) ~= "table" then
        return warn("Invalid configuration for BulkTween:", u11, p12);
    end;

    local u14 = {};

    for _, v in typeof(p12) == "table" and p12 and p12 or { p12 } do
        for _, v2 in u11 do
            local u15;

            if typeof(v2) == "Instance" then
                u15 = v2:FindFirstChild("Configuration_" .. v);
            else
                u15 = false;
            end;

            if InstanceCheck(u15, "Configuration") and not v2:FindFirstAncestor("StarterGui") then
                local u16 = u1.Extract_Configured_TI(u15);
                local u17 = u15.Target:GetAttributes();
                local Originale = u15:FindFirstChild("Originale");

                if typeof(u17) == "table" and typeof(u16) == "TweenInfo" then
                    for i in pairs(u17) do
                        if i:match("__") then
                            u17[i] = nil;
                        end;
                    end;

                    u14[v] = u13 and (u14[v] or {}) or u13;
                    local v18, v19;

                    if u15:GetAttribute("Use_Processing") then
                        local v20 = true;

                        for _, child in v2:GetChildren() do
                            if child ~= u15 and (child:GetAttribute("Use_Processing") and (child:GetAttribute("Processing") and (child:GetAttribute("Priority") or -1) > (u15:GetAttribute("Priority") or 0))) then
                                v20 = false;
                                break;
                            end;
                        end;

                        if v20 then
                            u15:SetAttribute("Processing", true);

                            v18 = function() -- Line: 134, Name: Kernel
                                -- upvalues: Originale (copy), v2 (copy), u13 (copy), u14 (ref), v (copy), u1 (ref), TweenService (ref), u16 (copy), u17 (copy), u15 (copy)
                                if Originale then
                                    for i, v3 in Originale:GetAttributes() do
                                        if not i:match("__") then
                                            v2[i] = v3;
                                        end;
                                    end;
                                end;

                                local v21 = u13 and u14[v] or u14;
                                local v22 = u1.CleanUp(TweenService:Create(v2, u16, u17), function() -- Line: 145
                                    -- upvalues: u15 (ref)
                                    if not u15 then
                                        return;
                                    end;

                                    u15:SetAttribute("Processing", false);
                                end);
                                v21[v2] = v22;
                                v22:Play();
                            end;

                            v19 = u15:GetAttribute("Thread_Delay");

                            if typeof(v19) == "number" then
                                task.delay(v19, v18);
                            else
                                v18();
                            end;
                        end;
                    else
                        v18 = function() -- Line: 134, Name: Kernel
                            -- upvalues: Originale (copy), v2 (copy), u13 (copy), u14 (ref), v (copy), u1 (ref), TweenService (ref), u16 (copy), u17 (copy), u15 (copy)
                            if Originale then
                                for i, v3 in Originale:GetAttributes() do
                                    if not i:match("__") then
                                        v2[i] = v3;
                                    end;
                                end;
                            end;

                            local v21 = u13 and u14[v] or u14;
                            local v22 = u1.CleanUp(TweenService:Create(v2, u16, u17), function() -- Line: 145
                                -- upvalues: u15 (ref)
                                if not u15 then
                                    return;
                                end;

                                u15:SetAttribute("Processing", false);
                            end);
                            v21[v2] = v22;
                            v22:Play();
                        end;

                        v19 = u15:GetAttribute("Thread_Delay");

                        if typeof(v19) == "number" then
                            task.delay(v19, v18);
                        else
                            v18();
                        end;
                    end;
                end;
            end;
        end;
    end;

    local function Recurse(p23) -- Line: 165
        -- upvalues: Recurse (copy), InstanceCheck (ref)
        if typeof(p23) ~= "table" then
            return;
        end;

        for _, v in p23 do
            if typeof(v) == "table" then
                Recurse(v);
            elseif InstanceCheck(v, "Tween") then
                v:Cancel();
            end;
        end;
    end;

    function u14.Destroy(p24) -- Line: 183
        -- upvalues: Recurse (copy), u11 (copy), u14 (ref)
        Recurse(p24);

        if u11.__erase then
            table.clear(u14);
            u14 = nil;
        end;
    end;

    return u14;
end;

return u1;