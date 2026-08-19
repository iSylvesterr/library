-- Decompiled with Potassium's decompiler.

local RemoteProperty = require(script.RemoteProperty);
local RemoteSignal = require(script.RemoteSignal);
require(script.Parent.Types);
local Util = require(script.Parent.Util);
local u19 = {
    BindFunction = function(p1, p2, u3, u4, u5) -- Line: 37, Name: BindFunction
        -- upvalues: Util (copy)
        assert(Util.IsServer, "BindFunction must be called from the server");
        local v6 = Util.GetCommSubFolder(p1, "RF"):Expect("Failed to get Comm RF folder");
        local RemoteFunction = Instance.new("RemoteFunction");
        RemoteFunction.Name = p2;
        local v7;

        if type(u4) == "table" then
            v7 = #u4 > 0;
        else
            v7 = false;
        end;

        local v8;

        if type(u5) == "table" then
            v8 = #u5 > 0;
        else
            v8 = false;
        end;

        local function ProcessOutbound(p9, ...) -- Line: 50
            -- upvalues: u5 (copy)
            local v10 = table.pack(...);

            for _, v in ipairs(u5) do
                local v11 = table.pack(v(p9, v10));

                if not v11[1] then
                    return table.unpack(v11, 2, v11.n);
                end;

                v10.n = #v10;
            end;

            return table.unpack(v10, 1, v10.n);
        end;

        if v7 and v8 then
            function RemoteFunction.OnServerInvoke(p12, ...) -- Line: 62
                -- upvalues: u4 (copy), ProcessOutbound (copy), u3 (copy)
                local v13 = table.pack(...);

                for _, v in ipairs(u4) do
                    local v14 = table.pack(v(p12, v13));

                    if not v14[1] then
                        return table.unpack(v14, 2, v14.n);
                    end;

                    v13.n = #v13;
                end;

                return ProcessOutbound(p12, u3(p12, table.unpack(v13, 1, v13.n)));
            end;
        elseif v7 then
            function RemoteFunction.OnServerInvoke(p15, ...) -- Line: 75
                -- upvalues: u4 (copy), u3 (copy)
                local v16 = table.pack(...);

                for _, v in ipairs(u4) do
                    local v17 = table.pack(v(p15, v16));

                    if not v17[1] then
                        return table.unpack(v17, 2, v17.n);
                    end;

                    v16.n = #v16;
                end;

                return u3(p15, table.unpack(v16, 1, v16.n));
            end;
        elseif v8 then
            function RemoteFunction.OnServerInvoke(p18, ...) -- Line: 88
                -- upvalues: ProcessOutbound (copy), u3 (copy)
                return ProcessOutbound(p18, u3(p18, ...));
            end;
        else
            RemoteFunction.OnServerInvoke = u3;
        end;

        RemoteFunction.Parent = v6;

        return RemoteFunction;
    end
};

function u19.WrapMethod(p20, u21, p22, p23, p24) -- Line: 99
    -- upvalues: Util (copy), u19 (copy)
    assert(Util.IsServer, "WrapMethod must be called from the server");
    local u25 = u21[p22];
    local v26 = type(u25) == "function";
    local v27 = "Value at index " .. p22 .. " must be a function; got " .. type(u25);
    assert(v26, v27);

    return u19.BindFunction(p20, p22, function(...) -- Line: 109
        -- upvalues: u25 (copy), u21 (copy)
        return u25(u21, ...);
    end, p23, p24);
end;

function u19.CreateSignal(p28, p29, p30, p31, p32) -- Line: 114
    -- upvalues: Util (copy), RemoteSignal (copy)
    assert(Util.IsServer, "CreateSignal must be called from the server");
    local v33 = Util.GetCommSubFolder(p28, "RE"):Expect("Failed to get Comm RE folder");

    return RemoteSignal.new(v33, p29, p30, p31, p32);
end;

function u19.CreateProperty(p34, p35, p36, p37, p38) -- Line: 127
    -- upvalues: Util (copy), RemoteProperty (copy)
    assert(Util.IsServer, "CreateProperty must be called from the server");
    local v39 = Util.GetCommSubFolder(p34, "RP"):Expect("Failed to get Comm RP folder");

    return RemoteProperty.new(v39, p35, p36, p37, p38);
end;

return u19;