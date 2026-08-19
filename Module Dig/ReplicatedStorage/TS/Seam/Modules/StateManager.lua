-- Decompiled with Potassium's decompiler.

local v1 = {};
local Trove = require(script.Parent.Trove);
local IsValueChanged = require(script.Parent.IsValueChanged);
local UpdateSignals = require(script.Parent.UpdateSignals);
local CreateDeepTraceback = require(script.Parent.CreateDeepTraceback);

local function GetObjectType(p2) -- Line: 11
    return typeof(p2) == "Instance" and "Instance" or (typeof(p2) == "table" and p2.__SEAM_OBJECT and "SeamObject" or "unknown");
end;

function v1.AttachStateToObject(p3, u4, u5) -- Line: 23
    -- upvalues: Trove (copy), UpdateSignals (copy), IsValueChanged (copy), CreateDeepTraceback (copy)
    local v6 = typeof(u4) == "Instance" and "Instance" or (typeof(u4) == "table" and u4.__SEAM_OBJECT and "SeamObject" or "unknown");
    local u7 = Trove.new();

    if v6 == "Instance" then
        local u8 = nil;
        u7:Add(UpdateSignals.OnFrameUpdate:Connect(function() -- Line: 30
            -- upvalues: u5 (copy), u8 (ref), IsValueChanged (ref), u4 (copy), CreateDeepTraceback (ref)
            local Value = u5.Value;

            if typeof(Value) == "function" then
                Value = Value();
            end;

            if u8 ~= nil and not IsValueChanged(u8, Value) then
                return;
            end;

            if typeof(u4[u5.PropertyName]) ~= typeof(Value) then
                warn((`{u4:GetFullName()} expected type {typeof(u4[u5.PropertyName])} for attached state value, got a value of type {typeof(Value)}\n{CreateDeepTraceback()}`));

                return;
            end;

            u4[u5.PropertyName] = Value;
            u8 = Value;
        end));
        task.defer(function() -- Line: 50
            -- upvalues: u7 (copy), u4 (copy)
            u7:Add(u4.AncestryChanged:Connect(function() -- Line: 51
                -- upvalues: u4 (ref), u7 (ref)
                if not u4:IsDescendantOf(game) then
                    u7:Destroy();
                end;
            end));
        end);

        return u7;
    end;

    if v6 ~= "SeamObject" then
        error("Attempted to attach non-state to object:\n" .. CreateDeepTraceback());

        return u7;
    end;

    local u9 = nil;
    u7:Add(UpdateSignals.OnFrameUpdate:Connect(function() -- Line: 60
        -- upvalues: u5 (copy), u9 (ref), IsValueChanged (ref), u4 (copy)
        local Value = u5.Value;

        if typeof(Value) == "function" then
            Value = Value();
        end;

        if u9 ~= nil and not IsValueChanged(u9, Value) then
            return;
        end;

        u4[u5.PropertyName] = Value;
        u9 = Value;
    end));

    return u7;
end;

return v1;